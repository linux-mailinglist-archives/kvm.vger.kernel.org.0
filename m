Return-Path: <kvm+bounces-57242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69751B5205F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1587E4643B8
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3B32D0610;
	Wed, 10 Sep 2025 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o9ELnF49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C6329F19
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757530058; cv=none; b=VzLIEXpZATUmeExPvCeLFfhW3BbacLyxyIUC5mu+7hiO2V0GkYB1j8B66eqI3bx5S3FML9k38FCeHTtdbYKuDUCIR7l37Fp6zK2lLGBiyIlXZv/OQvtXhVcWZhCDguG1PUtlKcA2r1fFFxznnYAGXUEBhHHTm/YxcdONSHVqIis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757530058; c=relaxed/simple;
	bh=3wVIa3kxzyn1jKBO4FKiY5s1rZ0DI2Qt/ZAzIledNSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bFnu0IFAn5RGBpcWBMe0sRF+ynlvgxYqELVsL1QxlNH/IUxtJD3t15aWDM7ISgrY4qPDxwRGHNs4B9xIl7O0lUBgIMxCqC4QUnU8qJuGTuvgo4pKD1PCUdusKdD8ocCv0NwWWdx579vzHFXI+MXE2wOQF3gvgUnpRAN6LqzWTPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o9ELnF49; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77278d3789cso15052155b3a.1
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 11:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757530057; x=1758134857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FIyVRSowSoxm0jH+PFTbTpx3TzBNK5EeRuMI4ty+SJc=;
        b=o9ELnF49FhZqb7uHldeq1GZno6Ag9KzL7aDnQPqDYnR+d4ci7mksUNkStxaIqm7hOS
         agxn1OWCEBd6pzJl26tc8O9zwuAllbQZM/9IZIqzNnVOmQkKTf0itrRiGTaYap60cW9v
         q4CQ35qBGZAkBtZID67wnJ1Vc899DeqeVoeHHDGhnUKpmgg5041Ho8XPId4J0mJmkvcV
         9+xmZlD7hWQMl1VDvct5I+iOQlFNpaTh71R/vhsajVs8kd5eoQtyTcb1JpmsZiZ4Res6
         qcegzplU7UCao2ra9YmN9QpnRZW3oxXhRQL9e/gR/Gt0WK1V96ZS9yzFFlCvcxiNIS3z
         FSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757530057; x=1758134857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FIyVRSowSoxm0jH+PFTbTpx3TzBNK5EeRuMI4ty+SJc=;
        b=ocn6X0UviwrNaJUCPR0Zsvqlic5Esywqu5F2VaHuIlgRt8++8yI2B8zeegYjMfLKQA
         XXtTuurnK+RKdgEg9PmP5b6lMJ90Q5V8hCGaL58NxN5PaQ253pkGQB3TVQE0xClyIXh/
         jqCVXjSai3h8U7AOSV3a1VOU5GHqb9N/53ywiikK6VycNsMHCOOoqaMeAccmGdSwDNaG
         C0uOrBirR+DD8/PTn/fckvz1gz8jnb/HR1I6M5Q0PO4YTWeFtmGGEHKfMd5BVTPKEURV
         G1SCJ4Zmd/mEUbI4X2RDx/Ph/CIcnWMaPFwqQO4hc+Gth7KZnZYpZmLFj+aO2m+qorym
         wCyA==
X-Forwarded-Encrypted: i=1; AJvYcCVxH1qnp5pr7CNdQefrUTCYWb3DnyvUY2WPu1IVIR2LTMsz4kPab5vT2W6pLz2jgLbUjhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUtyrRXEs0D03GmTL7qCw4apYj42hLktNFi4FnX6zA00Puwq3b
	cCG6JVl7APoukA6Hs8E2dlw2atnaMjCpR94epUQkK9xdYiMMlKl++L0oV8aQuBdjtq2dE5SA720
	1XHuaBQ==
X-Google-Smtp-Source: AGHT+IEDLJGMO3AphcAHDNXaSjkdvGKKt2jtxrGUIyclDPwEC7z8NsNkYyuOZtHLhM94tSbrdteIaNUcsSs=
X-Received: from pgke16.prod.google.com ([2002:a63:f550:0:b0:b47:6f88:6843])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a06:b0:250:720a:2915
 with SMTP id adf61e73a8af0-2534441548fmr22969863637.35.1757530056588; Wed, 10
 Sep 2025 11:47:36 -0700 (PDT)
Date: Wed, 10 Sep 2025 11:47:35 -0700
In-Reply-To: <aMFiBZARu5pD+Zzq@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909093953.202028-1-chao.gao@intel.com> <20250909093953.202028-4-chao.gao@intel.com>
 <c0e5cd9b-6bdd-4f42-9d1b-d61a8f52f4b8@intel.com> <aMFiBZARu5pD+Zzq@intel.com>
Message-ID: <aMHHx4Pu4eWdNQJj@google.com>
Subject: Re: [PATCH v14 03/22] KVM: x86: Check XSS validity against guest CPUIDs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	john.allen@amd.com, mingo@kernel.org, mingo@redhat.com, 
	minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org, 
	pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com, 
	shuah@kernel.org, tglx@linutronix.de, weijiang.yang@intel.com, x86@kernel.org, 
	xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Chao Gao wrote:
> On Wed, Sep 10, 2025 at 05:22:15PM +0800, Xiaoyao Li wrote:
> >On 9/9/2025 5:39 PM, Chao Gao wrote:
> >> Maintain per-guest valid XSS bits and check XSS validity against them
> >> rather than against KVM capabilities. This is to prevent bits that are
> >> supported by KVM but not supported for a guest from being set.
> >> 
> >> Opportunistically return KVM_MSR_RET_UNSUPPORTED on IA32_XSS MSR accesses
> >> if guest CPUID doesn't enumerate X86_FEATURE_XSAVES. Since
> >> KVM_MSR_RET_UNSUPPORTED takes care of host_initiated cases, drop the
> >> host_initiated check.
> >> 
> >> Signed-off-by: Chao Gao <chao.gao@intel.com>
> >
> >Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >
> ><snip>
> >> @@ -4011,15 +4011,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>   		}
> >>   		break;
> >>   	case MSR_IA32_XSS:
> >> -		if (!msr_info->host_initiated &&
> >> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> >> -			return 1;
> >> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> >> +			return KVM_MSR_RET_UNSUPPORTED;
> >>   		/*
> >>   		 * KVM supports exposing PT to the guest, but does not support
> >>   		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
> >>   		 * XSAVES/XRSTORS to save/restore PT MSRs.
> >>   		 */
> >
> >Not an issue of this patch, there seems not the proper place to put above
> >comment.
> 
> Agreed.

It was there to call out that KVM doesn't support any XSS bits even though KVM
supports a feature that architecturally can be context switched via XSS+XSTATE.
I'll find a better home for the comment (probably move it in patch 5 as
Xiaoyao suggested).

> I am curious why PT state isn't supported, which is apparently missing from
> the comment. If it is due to lack of host FPU support, I think the recent
> guest-only xfeatures we built for CET can help.

Presumably, perf uses PT across multiple tasks, i.e. doesn't want to context
switch PT state along with everything else.  For KVM, PT virtualization is
intertwined with perf, and so wholesale swapping guest PT state simply won't
work.
 
> Anyway, PT is only visible on BROKEN kernels. so we won't do anything for
> now besides documenting the reason.

Yeah, PT virtualization is riddled with problems, just ignore it.

