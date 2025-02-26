Return-Path: <kvm+bounces-39207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0DCA4521A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0CFB7A3DF7
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74EC817E015;
	Wed, 26 Feb 2025 01:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JF8J6OZH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379F0154BF0
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740532862; cv=none; b=XWnREOr/JGh20AWl0OfRXKC73hJt+O0QfET1bVXjizUygaetIGInVG+kAP/nInYdmLkMVwCDsbsH/egPtzLmOgEmkSEyRzyGgNr0ItyZzRXOaLLHKQiwqW9K4i1PbpMOXxF+KxQT+MU2buFrxPx5IKUjqBLeNWvH2Qgvzto5vhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740532862; c=relaxed/simple;
	bh=ej9DtK6/GIC7P6gUFFvgcMeLI/e2OMKxKBwv3JUqlfA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b/KG+I4B3aUksQbOiy5DXr7L0zIH2Dlo6p9kNt3HrInOhDeBSRIhTy8jGxYXAv/I1aSMO/JJei6MVGxGHZG4bv9KpJjk07fVWIbVmw6ewWnu2N8qMpO7nHHEU5xhNWyln2WJfThgTovnTiGNMhG+tKV4JHHDjchnI9rPlYRiSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JF8J6OZH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05afdso13602336a91.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740532860; x=1741137660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p2evnJTAT7xA7jPdud/d0boBZNUrVlDGplkZhVlal7I=;
        b=JF8J6OZHs3i/gprr3UH6HFCXbV2H8SxYVBS1/TrmeLbPBZBVoKZhQHe1tOrziB2AC0
         a4fm7XlKk/bKfIJjGlZ/tv/2AHSAl5Zs9DRgcHtbih6aRM7ME0MwbMSNNAE3fbl7EGSY
         lO21Qt6+3XHZKtc4lae6iy/C3VSKza8D156/ePu4kpwEXdNT3pqepIcQEJS5la8wposL
         xzGyXDSAQ117ZPS6ROVcp/glKCS/0zGMALiS7K3+hI0pLNPsOKA8U1Iq5cEvZutOkSbb
         /sl/F8eV1dIP9fDl6VDMqkQD8W8sDVrKc+mM1m7Lwv0OZl5cUKld0My8gXb9MMZxVDFj
         ACqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740532860; x=1741137660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2evnJTAT7xA7jPdud/d0boBZNUrVlDGplkZhVlal7I=;
        b=M2T4fGOCw21TNZk4fljH8FUbsAX3h65K+f1kfbt/JFYdy+3NNhHzw4imB0hZ29xT8e
         aP8OBHJhZabS4JBKiSw+67VUrbHE7ptNu4fgxlni10MmdT4Ho6OeQRG4Mb/xJwxlXGFw
         pjyc7y1FeCHbuXwNvgp49VOpfujWiioGUnHQTzhwkpA/XSrLdDPC5brkkRxQmWb6ihBV
         8c6tArBCIG8Eo9Av8genGO6tNC5BgPwPHJVcrnCGxmhzSpdmhO/iQ/p9emDQCQNtr+Fs
         FVtNxST1+v0QmMihwpOy3MYr/36KuZqFkOGbOCGUlIuKzmkcFB2qnDOxat2kZSu/aOrC
         jVDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNC+Swf7R8xQx3XoBXmjqw7TcoriG3eDfvLkOTi8VZS9F22S3M1IM0n6ppySLnKVSK2QY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9VQ9XcsUQHDToeqR6TH8N5K7jzSjs2eGAIm7yW72uMIRvOhQ4
	1jRxfSadxU7l1/Z8tc849n0YXR8OlSMLKVBN3mCaBxI3cmoOk+h3O31IjXDXtIxwdlZsC2rPcPk
	+sQ==
X-Google-Smtp-Source: AGHT+IHg18aY5r8Tckm8ifppI9xalzebABi31M7tGArAxnDvvCsGP5kXSFQLYelbvQ5IR8I5g7C00iuW5NM=
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:2fa:284f:adae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:f944:b0:2ee:f440:53ed
 with SMTP id 98e67ed59e1d1-2fe68d058e5mr7870141a91.31.1740532860549; Tue, 25
 Feb 2025 17:21:00 -0800 (PST)
Date: Tue, 25 Feb 2025 17:20:59 -0800
In-Reply-To: <20250128015345.7929-4-szy0127@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn> <20250128015345.7929-4-szy0127@sjtu.edu.cn>
Message-ID: <Z75se_OZQvaeQE-4@google.com>
Subject: Re: [PATCH v7 3/3] KVM: SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: thomas.lendacky@amd.com, pbonzini@redhat.com, tglx@linutronix.de, 
	kevinloughlin@google.com, mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 28, 2025, Zheyun Shen wrote:
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
> thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> ---
>  arch/x86/kvm/svm/sev.c | 30 +++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/svm/svm.h |  5 ++++-
>  3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1ce67de9d..4b80ecbe7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -252,6 +252,27 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>  	sev->misc_cg = NULL;
>  }
>  
> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

And now I'm very confused.

v1 and v2 marked the CPU dirty in pre_sev_run(), which AFAICT is exactly when a
CPU should be recorded as having dirtied memory.  v3 fixed a bug with using
get_cpu(), but otherwise was unchanged.  Tom even gave a Tested-by for v3.

Then v4 comes along, and without explanation, moved the code to vcpu_load().

  Changed the time of recording the CPUs from pre_sev_run() to vcpu_load().

Why?  If there's a good reason, then that absolutely, positively belongs in the
changelog and in the code as a comment.  If there's no good reason, then...

Unless I hear otherwise, my plan is to move this back to pre_sev_run().

> +{
> +	/*
> +	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
> +	 * track physical CPUs that enter the guest for SEV VMs and thus can
> +	 * have encrypted, dirty data in the cache, and flush caches only for
> +	 * CPUs that have entered the guest.
> +	 */
> +	cpumask_set_cpu(cpu, to_kvm_sev_info(vcpu->kvm)->wbinvd_dirty_mask);
> +}
> +
> +static void sev_do_wbinvd(struct kvm *kvm)
> +{
> +	/*
> +	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
> +	 * requires serializing multiple calls and having CPUs mark themselves
> +	 * "dirty" if they are currently running a vCPU for the VM.
> +	 */

A comment is definitely warranted, but I don't think we should mark it TODO.  I'm
not convinced the benefits justify the complexity, and I don't want someone trying
to "fix" the code because it has a TODO.

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 43fa6a16e..82ec80cf4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -112,6 +112,8 @@ struct kvm_sev_info {
>  	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
>  	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
> +	/* CPUs invoked VMRUN call wbinvd after guest memory is reclaimed */
> +	struct cpumask *wbinvd_dirty_mask;

This needs to be cpumask_var_t, as the cpumask APIs expect the mask to be
statically allocated when CONFIG_CPUMASK_OFFSTACK=n.  E.g. this will hit a NULL
pointer deref.

  static __always_inline bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
  {
	cpumask_clear(*mask);
	return true;
  }

The wbinvd_dirty_mask name also turns out to be less than good.  In part because
of the looming WBNOINVD change, but also because it kinda sorta collides with
wbinvd_dirty_mask in kvm_vcpu_arch, which gets really confusing when trying to
read the code.

I don't have any great ideas, the best I came up with was have_run_cpus.

