Return-Path: <kvm+bounces-62525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C0CC47A19
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0346C188CEBC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98532279355;
	Mon, 10 Nov 2025 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bl/IsGhf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6288B224AE8
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789291; cv=none; b=eMtePTUQb/J18a5dH2uV89XZup870vzS2d8+hQ4D7Hja0IG3HTnW94gZo5raAsGBSWz7JEJse8LLMSGpPXltFU9qlTg7TpQVSGHjZT5vxQM0AgE8G1ZlfP4ZBGWDrlYZdsA+bYSUse22CRxl5uJ8CK1NBnQglmu48BqWxVg8ncY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789291; c=relaxed/simple;
	bh=h6fvhlb5qL2yiZWyNImFBexKvyI93L8SUFeljjK9Ops=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GuHyn5krkHwNnkhN/mI/B7gJV+U3Dnv0cqAps6yNuUVu/sQKgOkFkUm96o0HfZZzkEZ+irO8fEKQejvm4SlsicBbjdJOAWyPPWsig/oXWNhJZvV26d0RqgwLnAtGOmQ4qRwCYZHy7uAsg+FGrROV0wC1F+HG+y5DN2Fpm2S/bNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bl/IsGhf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso1663367a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789290; x=1763394090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IgkoVDJKLe1jOBuatcMyGEsvjHvtN3ZYXFqt51mzfaM=;
        b=bl/IsGhfibbZZfT6Oli9cONWBMOL8XPB2/sl9FIRneQoC9l54fY9kOdAEUl4rq4rL5
         RZPOIid2T5cScwGOJjhdKMK+mIykEXpehUKrZf0imN4ml8AwFn33PzjZclFYyBJjS7ok
         OjOSJpzz5CvZ/fkBleL1Vr36kd/nDY/Ycs2XptNasF9DTVmydlPBDzQvd2aS7MOa5kBs
         GLk8ONMMTXPN5JghA+iBgE6iTZ+mBL8DGEcAyRef4/j6/JrBC5uy8NktlTtoQ5JY+Cr9
         ZvqktGz7PKlj3+laflONsMKJJzvoDrjMHCNFj7UP3bDDG2wF8Ima+wwJbgqte93uOjXN
         OPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789290; x=1763394090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IgkoVDJKLe1jOBuatcMyGEsvjHvtN3ZYXFqt51mzfaM=;
        b=apZ281ACeGlXzaf0X+BVt+aD4ptOST6H4hJjRzWUhkuf19SDQ0RNV4AefsBOczCs2h
         Wvo8/K5dmcaSgYcduf8VwRCvOhYf56YdKmxeMHte8TaF24GxVLzWP4qR4Jb6RDw5Nn6G
         QW5uejH1yJSprgtO5OC0gQvqh+4gIbGq6Cs4592QoLkEC/MLU8v2yCG2COnRz/O10Pcu
         UaljVhMKH3ZptmufneBJB/ar/jJAEHgkE1OoiqCvGlrinxwrwNEieEweLGWKLdfWhAkM
         EdHQAw8yIZceiDYKvEK6VKPomUpNKurbCjU34uyS/fjbpLfaJf0kUaAJvSDkWLe/Tpw+
         ATog==
X-Forwarded-Encrypted: i=1; AJvYcCWmC/AvySbk/NvqNndA/S/AqMDKQEkMlA4PnPUK7Oo/zIjTV9xahFtrAPtln+eAntiRsM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdiscCFj+XnaA6JdW+bvMoVja7zLfP2wCjqq1V1w6HcfQFmpLV
	wRsl0T+tnHCfKba/vNYr3vbT39+igRKe3XOpEkDWDXWc/mcb5lCTXVmDM9zK9KYl4sRSwwVJsUC
	66RZ6Ug==
X-Google-Smtp-Source: AGHT+IGdNkJMtTEnYMfSsIqBsSSQ/jBHwYkaAkoEe8549P2buRjTsfhQe8p1ftk/vjq/9yTIZHYVO8kgbHE=
X-Received: from pjbkk1.prod.google.com ([2002:a17:90b:4a01:b0:343:65be:4db2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a8d:b0:340:f05a:3ed1
 with SMTP id 98e67ed59e1d1-3436cced91fmr10306410a91.21.1762789289588; Mon, 10
 Nov 2025 07:41:29 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:27 -0800
In-Reply-To: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176278819404.918294.6609629362258186097.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: nSVM: Fixes for SVM_EXIT_CR0_SEL_WRITE injection
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 24 Oct 2025 19:29:15 +0000, Yosry Ahmed wrote:
> A couple of fixes for injecting SVM_EXIT_CR0_SEL_WRITE to L1 when
> emulating MOV-to-CR0 or LMSW. LMSW is handled by the emulator even in
> some cases where decode assists are enabled, so it's a more important
> fix. An example would be if L0 intercepts SVM_EXIT_WRITE_CR0 while L1
> intercepts SVM_EXIT_CR0_SEL_WRITE.
> 
> Patch is an unrelated cleanup that can be dropped/merged separately.
> 
> [...]

Applied to kvm-x86 svm, with the proper stable@ email and the tweaks to
svm_check_intercept().  Thanks!

[1/3] KVM: nSVM: Remove redundant cases in nested_svm_intercept()
      https://github.com/kvm-x86/linux/commit/3d31bdf9cc79
[2/3] KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation
      https://github.com/kvm-x86/linux/commit/5674a76db021
[3/3] KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
      https://github.com/kvm-x86/linux/commit/3d80f4c93d3d

--
https://github.com/kvm-x86/linux/tree/next

