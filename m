Return-Path: <kvm+bounces-33456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD499EBDFA
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 23:43:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C582840C9
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166D71EE7BC;
	Tue, 10 Dec 2024 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JiZ4Ne6T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AEF2451C7
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 22:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733870608; cv=none; b=rUhPgYYe/SVl4zx2ZthJQVOkFtux5D181JM+Lg3CCdWg1qFwO/NbtxHNgaQrG+Lx+grX3xbOVVZ+OiVGKBLQv4KL6hvkDTXft+iP0cZ3d2tsDhe4AeVjIvC1MW1G37udf2a8U4oj1/M5CBBtuK/Q1Jg4X+oe4NLA3cWSwTJ31Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733870608; c=relaxed/simple;
	bh=3Eq7AMhO7ZTya8w6ZdwS9S7NprMbQ+yUU2/rRO1Y3Pg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ecUXY+midsSfL7ZjhLT3a9DEZhNCO+BsmftdsVdZtRDUKuo8FZ1lIH/muFfBZgIA2eB3dsuCATqNQyEegDS2MApQ22MUqQw6UEKtIx5ie8xnoQxzjhydN16SeR9LlFJ+kijzBI3QzqIFuhK9XY0iVE0cPaLKhwdQ12QI3/TFUEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JiZ4Ne6T; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216266cc0acso921105ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 14:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733870606; x=1734475406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h3X5Qr+8k9X+2hvuHngUho46v83TFcRfFs+gwv7G7uE=;
        b=JiZ4Ne6TNLrM/aE31ncsSx08z+6zlNM0u+GUEJ71MweMp3c2u2mE9nY5ru2oBsCyn6
         h+6Q7iR1ixODlAj9RbL1kemHjd3QSRRpmbjZHMXOcBGz/lzlxyuQm3Pa1zjwtu2zP8EB
         nauvhY1MO3xyXeTT38NNiSV5Gpp55SzAexANS72DOzE97EBkTzJ2iTb2Vbkmr0Q5W6J1
         +cUjatPAmC+LXQRhVRkkOlZ8zTKKlNlfcfaieg54YQSqdapDBtZTvrG3CgXjxJ0Rp8Ay
         Uht4Po4lF46eJrRHtTJN7Tol7JqMtjQwUTlZVrS0iEwlghRemZ0Uuvsw/qv80TO1xnRw
         17Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733870606; x=1734475406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h3X5Qr+8k9X+2hvuHngUho46v83TFcRfFs+gwv7G7uE=;
        b=O6t4bknKDSPRCUsq0GywV6tUxraYGSUMf6Fkn494KA3PP/cxiV+j8mbNULWp+WDD2A
         XE3VIOp7vXPhk9jgLKpZkG5a7KivD/COmIyirNmLfCBGQ6NOAsUE7Rg1YUp/qw+ijGZY
         ZWeNNP6V7heiaRnUpe8cH5osKZw/uVpkmauMbML6mmBDXPvn6OiDJbj5wXc7b8ZlOsC5
         5JYK2ihbCsiFj/gJdNZQXkkJKqbHNsrUgnKssPWgOOdIz49NuycS3zpPIVKpGP48P4uW
         7POfxLbLZPNqwo57gMBVdAfmYyh+eCQbIcmPAQz/x/qg9AGRH1g4aU0AolUlRzSs25UE
         lD6w==
X-Forwarded-Encrypted: i=1; AJvYcCXgSwYqBK4s2EvXBy1lpcOzfj+l7jm00pih3En+r31c6nF/VGXWY1X85XwyIqK343TQtKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuED9+aj+PnXktiN94dYxB2nytWd6fphzDQipNJTAsHUODESlb
	ket85mK98kBIAbvVEe/Ki3Ft1MDoVXqaKsxaAZOm7Yx0w2mqS2p7g8UTBlqtrHZDt60UXSfTLRH
	rgw==
X-Google-Smtp-Source: AGHT+IHYFqYGkifAALeF4QNpnm5GdQyLqJOcPHyuQMgLXtkVCm1AQZ1NNcY7Jl1J9ugq/G8HQT+Vqw7hlFw=
X-Received: from pjbqb3.prod.google.com ([2002:a17:90b:2803:b0:2e2:9f67:1ca3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1811:b0:2ee:ad18:b310
 with SMTP id 98e67ed59e1d1-2f12881b569mr669555a91.18.1733870605922; Tue, 10
 Dec 2024 14:43:25 -0800 (PST)
Date: Tue, 10 Dec 2024 14:43:24 -0800
In-Reply-To: <9e827d41-a054-5c04-6ecb-b23f2a4b5913@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com> <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
 <9e827d41-a054-5c04-6ecb-b23f2a4b5913@amd.com>
Message-ID: <Z1jEDFpanEIVz1sY@google.com>
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Simon Pilkington <simonp.git@mailbox.org>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 10, 2024, Tom Lendacky wrote:
> On 12/10/24 14:33, Simon Pilkington wrote:
> > On 10/12/2024 16:47, Sean Christopherson wrote:
> >> Can you run with the below to see what bits the guest is trying to set (or clear)?
> >> We could get the same info via tracepoints, but this will likely be faster/easier.
> >>
> >> ---
> >>  arch/x86/kvm/svm/svm.c | 12 +++++++++---
> >>  1 file changed, 9 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index dd15cc635655..5144d0283c9d 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >>  	case MSR_AMD64_DE_CFG: {
> >>  		u64 supported_de_cfg;
> >>  
> >> -		if (svm_get_feature_msr(ecx, &supported_de_cfg))
> >> +		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
> >>  			return 1;
> >>  
> >> -		if (data & ~supported_de_cfg)
> >> +		if (data & ~supported_de_cfg) {
> >> +			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
> >> +				supported_de_cfg, data);
> >>  			return 1;
> >> +		}
> >>  
> >>  		/*
> >>  		 * Don't let the guest change the host-programmed value.  The
> >> @@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >>  		 * are completely unknown to KVM, and the one bit known to KVM
> >>  		 * is simply a reflection of hardware capabilities.
> >>  		 */
> >> -		if (!msr->host_initiated && data != svm->msr_decfg)
> >> +		if (!msr->host_initiated && data != svm->msr_decfg) {
> >> +			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
> >> +				svm->msr_decfg, data);
> >>  			return 1;
> >> +		}
> >>  
> >>  		svm->msr_decfg = data;
> >>  		break;
> >>
> >> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> > 
> > Relevant dmesg output with some context below. VM locked up as expected.
> > 
> > [   85.834971] vfio-pci 0000:0c:00.0: resetting
> > [   85.937573] vfio-pci 0000:0c:00.0: reset done
> > [   86.494210] vfio-pci 0000:0c:00.0: resetting
> > [   86.494264] vfio-pci 0000:0c:00.1: resetting
> > [   86.761442] vfio-pci 0000:0c:00.0: reset done
> > [   86.761480] vfio-pci 0000:0c:00.1: reset done
> > [   86.762392] vfio-pci 0000:0c:00.0: resetting
> > [   86.865462] vfio-pci 0000:0c:00.0: reset done
> > [   86.977360] virbr0: port 1(vnet1) entered learning state
> > [   88.993052] virbr0: port 1(vnet1) entered forwarding state
> > [   88.993057] virbr0: topology change detected, propagating
> > [  103.459114] kvm_amd: DE_CFG current = 0, WRMSR = 2
> > [  161.442032] virbr0: port 1(vnet1) entered disabled state // VM shut down
> 
> That is the MSR_AMD64_DE_CFG_LFENCE_SERIALIZE bit. Yeah, that actually
> does change the behavior of LFENCE and isn't just a reflection of the
> hardware.
> 
> Linux does set that bit on boot, too (if LFENCE always serializing isn't
> advertised 8000_0021_EAX[2]), so I'm kind of surprised it didn't pop up
> there.

Linux may be running afoul of this, but it would only become visible if someone
checked dmesg.  Even the "unsafe" MSR accesses in Linux gracefully handle faults
these days, the only symptom would be a WARN.

> I imagine that the above CPUID bit isn't set, so an attempt is made to
> set the MSR bit.

Yep.  And LFENCE_RDTSC _is_ supported, otherwise the supported_de_cfg check would
have failed.  Which means it's a-ok for the guest to set the bit, i.e. KVM won't
let the guest incorrectly think it's running on CPU for which LFENCE is serializing.

Unless you (Tom) disagree, I vote to simply drop the offending code, i.e. make
all supported bits fully writable from the guest.  KVM is firmly in the wrong here,
and I can't think of any reason to disallow the guest from clearing LFENCE_SERIALIZE.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6a350cee2f6c..5a82ead3bf0f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
                if (data & ~supported_de_cfg)
                        return 1;
 
-               /*
-                * Don't let the guest change the host-programmed value.  The
-                * MSR is very model specific, i.e. contains multiple bits that
-                * are completely unknown to KVM, and the one bit known to KVM
-                * is simply a reflection of hardware capabilities.
-                */
-               if (!msr->host_initiated && data != svm->msr_decfg)
-                       return 1;
-
                svm->msr_decfg = data;
                break;
        }


