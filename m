Return-Path: <kvm+bounces-39024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 864EEA429AD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B861188B673
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E842661A7;
	Mon, 24 Feb 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ppv8bh5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03A266194
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417964; cv=none; b=Cw9xDPOOesK3aT23xoUKMEmSJUBy//WjEJtaiUtPGxYKXOEGxep6khiKptYZVW9p0FvgKdNRu4k7mRAgRLmvGn2ltZJYhZgAixz+t+WPDcW45dlqTTvFGdz9eQYQ/FFcIZmDDBbjxJqhvhUTYBN/AfF0Kmnl5wdDGaR3RLRcofI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417964; c=relaxed/simple;
	bh=CNJWRD7c7yeqan7bY207IK3YC861bL61AEuCZ0e+7v4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f5KqvD55Aj/UN1E0tbQHqhEDgmhZHQiMCZW7ERLoWYvEEUjraZbwUaZUZ/CwtokGJx0P/0tTYpdC/Oeuia8ow4tPCC6BskSDhWpzs+Im5jnhzXF38oNNZuPTXGURqGMZJl3YYUluvG2Iz+u3R5JTbcZ4rkYjOymTG8OzAX3da+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ppv8bh5M; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1e7efe00so9591561a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417962; x=1741022762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MYlaZ5PnSRPKgkwKjMAZyke2ee4OA5lfFD4fO8bXWhI=;
        b=Ppv8bh5MMTobxJpaTNvR9RwvRKjKun4+A4RFpc+Yie46i1BgzSPB1NVPL0WFRcj91O
         uQKg9Q16c6fBhBnpRYYQiX5CprKDFkU5431ZeN5mobnzGMBHyllgy0WBUoV7P0nLMFy2
         G4MmLkvy7EKGpk2N9xWcSkukksDGmd1pnzXtU9q2oI6Ou3/MCo5phQySt8V8UeU2UNkf
         DstoDemIkChLKg74PM5AGBj3ArLQATVmQsYrQrBb2JZhUH1kLh3cxHjp+WiZdHHqHgC8
         Amu1/PAmVykyh8xZhRCDK7lnZ6O0ZXwspeJFZ4aJeUM+yJIn21ZSXi9RYHIqlUt4iK2c
         qO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417962; x=1741022762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MYlaZ5PnSRPKgkwKjMAZyke2ee4OA5lfFD4fO8bXWhI=;
        b=dd8yDuPbXVnfQmGymVbEXjhZ1ukiidTqx/8OxI0KFvHJOSarGilTAcRvaTTOne5rw/
         AHhmC2xUZUIpsX84ZchhKug0waYX6BhoXrHGsLlZcMhC2mrGDQDATRcKok0A+WM3+PlN
         trOX4nxeWrLwz3Zbak1DiGimJCFxz/bXRz0mSBDLz4AIxjMVVAIUnef8Ra/H2VX0jidp
         SvO/tEIHF0o6azFUqadFnJfiAQ/xwgI9IhSgfhQ/BMEnM+hR7AeHdOtaFZL2eKfkUh9d
         YBjtR0MaFcuALfF1h+ArA5A1VAXzUTgIHN2xm4Yh3u8imgaW8J9adzXrjXlhWEoQLIaS
         816Q==
X-Gm-Message-State: AOJu0YzEwKWvb543v+tLkrJubRwyBRo0Qv34kIqo0PiRC4E9VF2v0JWB
	TO91Zk8zhuZlPIsGumSq7LgozNQR+fRYxfaiB+VC1ia81ay/dyxpuRyrox6NW55R7o9vuePhx//
	w2Q==
X-Google-Smtp-Source: AGHT+IHoSkcGgMd8kWQsfVdQbxm3HDy9K0kQdb8qAYwgvPzR5/o2uY6SO8awxtHkQevxp+h5BR5zNWyILzo=
X-Received: from pfdf3.prod.google.com ([2002:aa7:8b03:0:b0:730:880d:7ed5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:8885:b0:1f0:e36e:f58b
 with SMTP id adf61e73a8af0-1f0e36ef5a5mr7673525637.24.1740417961811; Mon, 24
 Feb 2025 09:26:01 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:09 -0800
In-Reply-To: <20250221225744.2231975-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221225744.2231975-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041748497.2351265.2974753722260063902.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Drop "enabled" field from "struct kvm_vcpu_pv_apf_data"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Feb 2025 14:57:44 -0800, Sean Christopherson wrote:
> Remove the now-defunct (and never used in KVM-Unit-Tests) "enabled" field
> from kvm_vcpu_pv_apf_data.  The field was removed from KVM by commit
> ccb2280ec2f9 ("x86/kvm: Use separate percpu variable to track the enabling
> of asyncpf").
> 
> 

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/1] x86: Drop "enabled" field from "struct kvm_vcpu_pv_apf_data"
      https://github.com/kvm-x86/kvm-unit-tests/commit/5f4bb7408590

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

