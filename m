Return-Path: <kvm+bounces-55057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBC8B2CFB9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4821C58367F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D185C2773D1;
	Tue, 19 Aug 2025 23:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OQvoB0z3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF24270EC3
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645308; cv=none; b=Rll/KzpFn5CPziRFQHXgL9XCL0RIhfwgncc1cWzEuyKqdTZx485KNhCOpDfDV3x+i17vK/+fLedpSyjd6FQKplwXnsPO7TdKubXZvXwRCjZVaVxIL9tlCX3ft6uy4y4numvuW+MCanNXuleZUqZAsENFrjUCi5sxynDN8yRbP9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645308; c=relaxed/simple;
	bh=yEriFb67RK9r5RACn+K+jkmiLEx3PeKZ2YlQS7CNoQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YoGcy2dw3xcwyb2OgTuiY95nlC5BMGfmwAKleSXY/3oRuiF2ahXrxZmZOsqoM0wgv318Pk61RmrWs6yNy1zYj2C4nJJrZwahFJ+zxV6wphEfCeIoT4XZ3BWLVvskkdcgtrTw2AK0fyckkdpE59vj02pcgfun4QYPS3DPlZqyY8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OQvoB0z3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3232677ad11so5440360a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645305; x=1756250105; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xnFFqxZL2dKWyQPAP8LNzyOxlbZOPfUkGBwwG1dl4E=;
        b=OQvoB0z37qCtxdys9S9lf1yaCo/iPiuAbNXBbV+0itLlCZElPlIcpuZj68oYiIc/jd
         xDMJpxeeqntT6gbCRoFtO0WgLDdIgOglX0sqhbZAWCj2GWIsH0Otakw689TnF9f0LRrD
         0HatjGAyFs60PQi1/B8x2lxP9mpsl1u4bvjcuUtt/cFtSQrPCsOgLCxMAv3EsV2WEDNH
         FgX7jQGo5cebTzseg1aQF2SDEgHA/HstfknD1LrE5FIBRWP3pRkHcxkBY5TtAUh9BqDi
         H2lc/+5w9LsXj7WNpt0hpGfbLRa/L2sf01jyzcwSr7mTybhpxv+iEohIw0uqf+IXETU0
         dM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645305; x=1756250105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xnFFqxZL2dKWyQPAP8LNzyOxlbZOPfUkGBwwG1dl4E=;
        b=Dcqju3wmB9QEKR3scAoRJHKmstzfMwWZBDtltO8znZtm+8WqLUKxvsno3WdrjOK9nZ
         YHSkWx8gxjnnTzHxIM4do+M9WDnfVn+2gprWTvT4QkdpRQSkMjnr7MykbxF75Ldd1Jfd
         0hmldNpa2bJMowa3tYjkADNDN52kQXqL3e+EE+yxu/yzb6LVj3/J5plr2/K4EAiKy1b6
         hlR/T7cZwkKgmdrTS1GM/xDyUUh7Ycv3b7ad3GjyqrefaU0xbTQ6IjVY84h4arbZA04Z
         dZqPPm1Z2AADRv683iLoRjFV6uHDySzVyLICvkI44ElCYf13Cd7gGpAqd2BjsJxhL+Bx
         r9/w==
X-Gm-Message-State: AOJu0YwheocXakupHyAz1VOH3F2xHB82vP9onjFFtOceJJDfsx+rdbWp
	W41wDTYcCSPUAq3VXKEqXkcN7Mh4yNNpscvgKhLN6BtF3qAHH7xyDD9wkAAJPycXjiLmEZQw32J
	J1mpRSQ==
X-Google-Smtp-Source: AGHT+IHv1eDV44dDXpdL3YKaUXVosgCxmndbwnWK4FetmEDu1I4NxJDYRxi+ZCLgPhhGzqJMjLWITh1N5u0=
X-Received: from pjbta11.prod.google.com ([2002:a17:90b:4ecb:b0:31f:a0:fad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1810:b0:312:f2ee:a895
 with SMTP id 98e67ed59e1d1-324e140c437mr909249a91.31.1755645305447; Tue, 19
 Aug 2025 16:15:05 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:01 -0700
In-Reply-To: <20250711172746.1579423-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250711172746.1579423-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564468839.3066340.1363280133168167552.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 11 Jul 2025 10:27:46 -0700, Sean Christopherson wrote:
> Emulate PERF_CNTR_GLOBAL_STATUS_SET when PerfMonV2 is enumerated to the
> guest, as the MSR is supposed to exist in all AMD v2 PMUs.

Applied to kvm-x86 misc.  I put this in "misc" instead of "fixes" as I want to
get a full cycle of more soak time before sending this to LTS kernels.

[1/1] KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
      https://github.com/kvm-x86/linux/commit/68e61f6fd656

--
https://github.com/kvm-x86/linux/tree/next

