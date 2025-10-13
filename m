Return-Path: <kvm+bounces-59949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0172DBD69DF
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC84C4E8A29
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3BD307ACC;
	Mon, 13 Oct 2025 22:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ejNKjrSV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99CD2571A5
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 22:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394789; cv=none; b=AOrLgMrE2xCsg/nbKXGRkibU+uU4TZvnpuMHNcTlQwnwJ/Az2td7ujBDyx8cNT6iS/nn41i8L3Q9mpkc+9v8ae/FR3B+ndW6yiTwpzFKTS33bT+hSFcjQT6nwBk8cPD+TEAo20hFaobLQ0l5Pd77VCMjICpRGkcQDREiLeZkb8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394789; c=relaxed/simple;
	bh=bJtLI1+hjiC84boHbypV9eiVeTHI29mL6L59dBQX8BE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hbbIAAehnk/kK0dBdghY2/sGpQvvtGcHgqUWwDV/Gzk/0yFY7xgQfBnEXiKu78V+s9SQBPWIdBTyZsiw31nKBfwozVPZJDZ/b/jox0yxjtkIVESLPmslwEC25Nk/Wx0BXFyBthbsTAaEdgwyi0gmcZEgBi6HjUzlIttPkSmzsQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ejNKjrSV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so13697123a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760394787; x=1760999587; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=obMltJbGsvsA0XVpJVFpUOtm7Jw/33w9bj9gGaK+2ho=;
        b=ejNKjrSVmxUNU0o7x1XNLvB/1elR8Kx4bcAWnM3QSih+foI4FSRlfCggcBkW5ueQ6g
         HH7xFPx9U3RDz+EVaNyO12KTiAOc5jmIdJ4rFBPBxfpvUxEpwzV1pF0Seahq/nYK70hV
         29k/s+hdmZFvsjIYlZvAZVyKUmqUw1MSIyBNDcsaUT58gHMOeDrOSqi1cf/YoZaN5c45
         mKDfAbWfKMdhaDU0iPIATgz2A0z2JxN/RXaaCsy3torGJ8cWMYUrnZFed0U8ZLuoaAA1
         pQpO2sAYGRe26pko68xRqYzyHndYwjoQ2yi4+fbpVtOoe2yN8BfvFusrTnezFxLEdVyu
         ObLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760394787; x=1760999587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=obMltJbGsvsA0XVpJVFpUOtm7Jw/33w9bj9gGaK+2ho=;
        b=wDTQtefCo5+xZjcTo96V3SqlWL0C0uNYwnoqsZ5YWovEhnVqZR1EdXx1nLzWz1MAhB
         DlbSTcfwRG+han+2wDK0Yq1D6omrwmU9xhRNR+sKIOd3diByjcpRyeyA/uFHz2hG0L3A
         JwPTnHQ/9SAdCe8ABW6QZbUST07JrCC0KmwPXRfyupP5nCHw+d18OYolMkdzM6weeBLA
         OfGrG/S3dWichPjjWaBiB5rLR/lIkLarexKzMBGOSohEo1ZSAsciXIJbBZ7sUkfQ+b83
         5erkJ5sA6LbZxt7HfGebnD30PU7mpoqv900MsN8J/ZyyF7mUs8xnBjlLBmP8sG7ucu5T
         C8XA==
X-Forwarded-Encrypted: i=1; AJvYcCXNXS+bPoSLk8dMQsZfe2NMiokNiKzZqN+nAFnHfocPd8gzr5g3rIoptHMRasc+RQiBO/U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2y4SdiTKxleZQuqbYdM23OHCBCcahUU9LtxqYVHSe5pVooLAM
	oQYE8ODBfqMrkAFHiZl2uxQ1HOQdJhmaxQ3wpUK6xTjS3ob+R4la7HC0f03jU1ULEq/f5YN2G8l
	hMRIeSA==
X-Google-Smtp-Source: AGHT+IGVD63rWhPqkonSveiMzXd5D3Xmn+2MSDEFajiRWdOaaOnWuMsg3SsQQJntOkdhH/DlpnMNAOIcRHM=
X-Received: from pjok3.prod.google.com ([2002:a17:90a:9103:b0:339:b369:ec29])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350f:b0:338:3d3c:3e03
 with SMTP id 98e67ed59e1d1-33b513a1fd3mr35278787a91.35.1760394787133; Mon, 13
 Oct 2025 15:33:07 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:33:05 -0700
In-Reply-To: <20251009223153.3344555-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com> <20251009223153.3344555-3-jmattson@google.com>
Message-ID: <aO1-IV-R6XX7RIlv@google.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Don't set GIF when clearing EFER.SVME
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 09, 2025, Jim Mattson wrote:
> Clearing EFER.SVME is not architected to set GIF.

But it's also not architected to leave GIF set when the guest is running, which
was the basic gist of the Fixes commit.  I suspect that forcing GIF=1 was
intentional, e.g. so that the guest doesn't end up with GIF=0 after stuffing the
vCPU into SMM mode, which might actually be invalid.

I think what we actually want is to to set GIF when force-leaving nested.  The
only path where it's not obvious that's "safe" is toggling SMM in 
kvm_vcpu_ioctl_x86_set_vcpu_events().  In every other path, setting GIF is either
correct/desirable, or irrelevant because the caller immediately and unconditionally
sets/clears GIF.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6443feab252..3392c7e22cae 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1367,6 +1367,8 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
                nested_svm_uninit_mmu_context(vcpu);
                vmcb_mark_all_dirty(svm->vmcb);
 
+               svm_set_gif(svm, true);
+
                if (kvm_apicv_activated(vcpu->kvm))
                        kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
        }


> Don't set GIF when emulating a change to EFER that clears EFER.SVME.
> 
> Fixes: c513f484c558 ("KVM: nSVM: leave guest mode when clearing EFER.SVME")
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 153c12dbf3eb..96177758d778 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -215,7 +215,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>  		if (!(efer & EFER_SVME)) {
>  			svm_leave_nested(vcpu);
> -			svm_set_gif(svm, true);
>  			/* #GP intercept is still needed for vmware backdoor */
>  			if (!enable_vmware_backdoor)
>  				clr_exception_intercept(svm, GP_VECTOR);
> -- 
> 2.51.0.740.g6adb054d12-goog
> 

