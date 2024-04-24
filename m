Return-Path: <kvm+bounces-15870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1DDC8B14FA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 529F71F233BE
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 21:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7ECD156F28;
	Wed, 24 Apr 2024 20:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KjCaHm4S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88B0156963
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 20:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713992391; cv=none; b=OF6YbDmzIkRZDtNHQ179bX0nx82Lx4ac8uZBHWpLvp1FaDmOo94QHw9mx8mU6SBwVd5EJ7f9cXxgzVeqaEGBYVSIuZAzTU7U17Z9F1nJ6LF7s3el3z+SX/ANmyZCaM+mHut7X/Ukisx60kC+TBIFMEWeUoe4qcGJv9shKqUBP6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713992391; c=relaxed/simple;
	bh=uoU2R06bl1D+d4rxO77OZBS6BnVKagWYLEFnEXdTDn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uTBswCziyR932rxxgaviEYuTm0WctcmaxZQWaF6L0KY73AG74I2rzRHrl0KC0aemTIStqOSJeaHCfRKge1rqSV+D7wltAHJ5ucTf6bbkaOdLZ8PYcutLoo+/hVJxUtyUwnTBwtgtZtyaa3jnODMlLZd+56ZKKsEBoPgWGUU64fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KjCaHm4S; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f3988b5e6dso313088b3a.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 13:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713992390; x=1714597190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8U1TRrKJi3x9eg5Tfok1QV3PlGCm0SDXSlp6I7iPxGE=;
        b=KjCaHm4SfZ0BSz0gxlpk5zUch7+meGfx9lZbZw04Lz0w8FrageE3zC70GAizxI4+h8
         XUei4YaPq43QeQX1M+YP7SZKkvlABz4GhDP8bAV6MEC4VO4Fp//Jb1YacuHa3MMlV9S2
         yD1nk99sdUxoR6odE/vZyD8QY7ORDmbAW+VTwbXhMCfnjhXQPVuxkX1knY64vPGB2HUb
         LCu/uRkslz8iPcEgg2q9hEHlRwvd4X3Y+KH4qbPqmi9Zhujm6oo8x7hyFd25FvsF/eUM
         W6AFyGp921NU+dKGc7hC8n1zU7nIrbobPjnV/TFanhYoLJFfDZaiiraT8KWPQx2y6fn9
         XjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713992390; x=1714597190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8U1TRrKJi3x9eg5Tfok1QV3PlGCm0SDXSlp6I7iPxGE=;
        b=uyCFgp18jGaaHrFYmA49tYZQ84PJLqG8uJzh8hX/9xBj42sSa49wTmDJYD3pVi2s4d
         Mb0XkjrMfvohbAz2DOC4eIiL1nurAfLOSZPlcKFlbIV9U716tNkihkT8W435kiHBIC7e
         +AE+KJ1DCun3P3Gyjy38aaqs7J4DL/FjlPw37FfvBFwabOY52VeeGzd5AzvBZGwaKTO9
         itNN19bCJWJbM5kksoV17Q9Xz6wkZ/TTR7ckX508vguaDu7AwrO9JTmVL/ZlC3EZkaB3
         Iw1f0Oix3gXCrLlJHOL+tIwy/c1guC6b9yh575YvhlabF+0vn0me3v0B4bUVeCI/PJnr
         weqQ==
X-Gm-Message-State: AOJu0Yyv13MgzjxcwWoRwD0e+eIn8kWHR4wZJp8Bc1SwkkANS5oC53tX
	MOJAauBY0G6e16y/vym1B8EpqUzvYAeUCF3A55/VGhhCdtrdyVnqW55LgOzg+P7uxqD7Qxvra5A
	J8w==
X-Google-Smtp-Source: AGHT+IGmpsjpffCacAgU+oA7c6LytEyPptV84YPXAIS11abUo+sjJaZSSsVlO+4Jy+7xcfCJfVr3EYbcplE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:22c4:b0:6ec:f18a:2783 with SMTP id
 f4-20020a056a0022c400b006ecf18a2783mr446579pfj.0.1713992389985; Wed, 24 Apr
 2024 13:59:49 -0700 (PDT)
Date: Wed, 24 Apr 2024 13:59:48 -0700
In-Reply-To: <20240421180122.1650812-10-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-10-michael.roth@amd.com>
Message-ID: <ZilyxFnJvaWUJOkc@google.com>
Subject: Re: [PATCH v14 09/22] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 21, 2024, Michael Roth wrote:
> +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> +{
> +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> +		return 1; /* resume guest */
> +	}
> +
> +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> +	vcpu->run->vmgexit.psc_msr.op = op;

Argh, no.

This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
and extend as *needed*.  There is no good reason page state change requests need
*two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
KVM_EXIT_MEMORY_FAULT.

The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
majority of requests are contiguous, i.e. can be combined into a range by KVM,
and that handling any outliers by performing multiple exits to userspace will
provide sufficient performance.

And the non-MSR version that comes in later patch is a complete mess.  It kicks
the PSC out to userspace without *any* validation.  As I complained in the TDX
thread, that will create an unmaintable ABI for KVM.

KVM needs to have its own, well-defined ABI.  Splitting functionality between
KVM and userspace at seemingly random points is not maintainable.

E.g. if/when KVM supports UNSMASH, upgrading to the KVM would arguably break
userspace as PSC requests that previously exited would suddenly be handled by
KVM.  Maybe.  It's impossible to review this because there's no KVM ABI, KVM is
little more than a dumb pipe parroting information to userspace.

I truly do not understand why we would even consider allowing this.  We push back
on people wanting new hypercalls for some specific use case, because we already
have generic ways to achieve things, but then CoCo comes along and we apparently
throw out any thought of maintainability.  I don't get it.

[*] https://lore.kernel.org/all/Zg18ul8Q4PGQMWam@google.com

