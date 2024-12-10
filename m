Return-Path: <kvm+bounces-33429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CC29EB557
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 649EB1886D44
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282A622FE04;
	Tue, 10 Dec 2024 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ks7eCByW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63B19D060
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733845647; cv=none; b=OyWvHisAbFeb5qqcM88yMBY+IfLvIGL48mcAzoYFnokCczZkLwb6r/9yT0KgQ/b+yFayq0mKo5fnzOawfasnY6V9rpNIxCqxg1nBdGMuQRA44GB/x49SmYBHIeYBCqQoHwCaoI2R93tEcgo65ZeDt/vs+I6xe6/lvW5sXwyWaFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733845647; c=relaxed/simple;
	bh=1CUVzWgqlJWWmRwsJh1LsALpOZYBXhS4oaGhAijTERk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/qoDzsQSKVPPxiBqeX9ICTMcm0VUSRZWl6F09eHZbRTg7yh+kmwYYgMmu1UIWQNMuJkxMN7bSlsPP/yFQYYjuvixxdPMc7aTohNQxLEVR2eDOu8uABA0V0uXklV73oZEPVhm3KSjGE9wZRWsC27B6D/AuJyXmbwvv1f+oAwB24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ks7eCByW; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-728eb2e190cso121307b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 07:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733845645; x=1734450445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KTvSRRTfNZQvoZQzqZSdBQnAG8g17VjNF2nt+7pLczk=;
        b=Ks7eCByWNdPHBkYEVLy09wezTPij72NUfjt8Kr6HeuBijlk/gGi8gnN1tko6jatETM
         8icpN42BWiJgLha56Mlo2yvZh2epZZ3MaIGX43wa7N7P38X6G3QwtDdD7AdQ9gcBKlkL
         o5lWI4Hvt7CeVDGUvCbiGChlKOMRVPhe7FJCn2U3ItWQMxXI3BmVQwMXEgn9dbrLTf8B
         G4EwkSSGsQ+sQWQlqTLZ0DunmL4Jjbnjpu8VdUb7fFc4f9Z8+4jMgaLkclvLe7nYjX1n
         zZOI8X6ik1Rk6HE2m0vOIXiPxQ6FgKDU6UV9uWnVJvEOI+hLEQIS9eeyEntF5kb6xCMa
         ZTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733845645; x=1734450445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTvSRRTfNZQvoZQzqZSdBQnAG8g17VjNF2nt+7pLczk=;
        b=fWbngTIVBRbKmabY1nwt8Y7dR8d49e1RmhLuEKYla8lAz0Wt+N23BAc6K+rJQat10r
         AKMaLY89WwtLAyDqOmqG3QUHO48vdb00xJoa9z7M4msV3+uGdGBmtlQuRM7sIUaA5IEy
         QLGvYdgOaS8d9UbxHZ5YeVpz29jtFSegHEYhO65EZfZH00/wErAD9PdknbRmgHNLhoeG
         E1UAH8srfkhS3EvVgsHRUKFGY/nITvXoGRgwfbjycZ1GS9NWv7FGVL0HdAwOBx3QC1c1
         Yh4eDDV7IwSFProy+sIMOiE+ObsITa4GxXDqRmCheP/8YcEQOun/agEC2ILqdHFZnEHA
         evfw==
X-Forwarded-Encrypted: i=1; AJvYcCWcEh89T+DIVcLv7CnkAljTl2Hci+jLHLIEki/tNP1BDLM3Wg4K7BbfoCUvEc85z3Le7BE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZossEp6P4o2X/HlV2rfH/MGJXN2juw8k0dQKsP8PSPoIrA+7V
	foiddb/+LzWDS60TQQc/yu67+GYnV0m5XQiLvAFleENCHa/moDEFVDYN4j2Kf3eWPxvoC9dkQi0
	90w==
X-Google-Smtp-Source: AGHT+IGHIWibTQSvd05WcbKMeMUoU8sV0PDsPWhPYjcWh/orNjkXeSQt6HCj/nEUskeUrNyc9MtmCiSB0kw=
X-Received: from pfbcp27.prod.google.com ([2002:a05:6a00:349b:b0:725:b203:3555])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:cd4:b0:725:b4f7:378e
 with SMTP id d2e1a72fcca58-7273c7fdbf1mr7689740b3a.0.1733845645355; Tue, 10
 Dec 2024 07:47:25 -0800 (PST)
Date: Tue, 10 Dec 2024 07:47:23 -0800
In-Reply-To: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
Message-ID: <Z1hiiz40nUqN2e5M@google.com>
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
From: Sean Christopherson <seanjc@google.com>
To: Simon Pilkington <simonp.git@mailbox.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	regressions@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

+Tom

On Tue, Dec 10, 2024, Simon Pilkington wrote:
> Hi,
> 
> With the aforementioned commit I am no longer able to use PCI passthrough to
> a Windows guest on the X570 chipset with a 5950X CPU.
> 
> The minimal reproducer for me is to attach a GPU to the VM and attempt to
> start Windows setup from an iso image. The VM will apparently livelock at the
> setup splash screen before the spinner appears as one of my CPU cores goes up
> to 100% usage until I force off the VM. This could be very machine-specific
> though.

Ugh.  Yeah, it's pretty much guaranteed to be CPU specific behavior.

Tom, any idea what the guest might be trying to do?  It probably doesn't matter
in the end, it's not like KVM does anything with the value...

> Reverting to the old XOR check fixes both 6.12.y stable and 6.13-rc2 for me.
> Otherwise they're both bad. Can you please look into it? I can share the
> config I used for test builds if it would help.

Can you run with the below to see what bits the guest is trying to set (or clear)?
We could get the same info via tracepoints, but this will likely be faster/easier.

---
 arch/x86/kvm/svm/svm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc635655..5144d0283c9d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_AMD64_DE_CFG: {
 		u64 supported_de_cfg;
 
-		if (svm_get_feature_msr(ecx, &supported_de_cfg))
+		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
 			return 1;
 
-		if (data & ~supported_de_cfg)
+		if (data & ~supported_de_cfg) {
+			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
+				supported_de_cfg, data);
 			return 1;
+		}
 
 		/*
 		 * Don't let the guest change the host-programmed value.  The
@@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * are completely unknown to KVM, and the one bit known to KVM
 		 * is simply a reflection of hardware capabilities.
 		 */
-		if (!msr->host_initiated && data != svm->msr_decfg)
+		if (!msr->host_initiated && data != svm->msr_decfg) {
+			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
+				svm->msr_decfg, data);
 			return 1;
+		}
 
 		svm->msr_decfg = data;
 		break;

base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 

