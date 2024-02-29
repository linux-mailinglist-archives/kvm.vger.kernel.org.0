Return-Path: <kvm+bounces-10562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 126AD86D786
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 00:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23DC11C20ACF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D7D74BF1;
	Thu, 29 Feb 2024 23:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vmzF74//"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA1874BF0
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 23:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709248015; cv=none; b=gj/3cSWzs+IB1zMPFe1KGG+z4mtJLUdQbfHrTMvyJpHomDVTr2gU2YEQXUKL/QwI6+Eyi17eOuXHwRRmocKzyoPzHIDdcV09lX5ET5PQBa/mfUSnPz3wB92YEYXRGyKPGdFCfpRwQ5nc/QFjOGJ2q4MRjYEG8GwMARm5z7z1mp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709248015; c=relaxed/simple;
	bh=xlv4BCWUd+xW1oov75VPMIAgTQnOq8HdvUJUz5cAOE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pKvBJcjgdYN7Bo/dFSPI5txypoJOE+OsfpJfKiZw9S+eLBeecCkqBYyC3tM6dq7BpV9+/ynsSyueaZH8kEYs1U4iShpfdQoIB1scZL7d4h6XSpo9Q9jV5DCrWvv574BPwVaztmn74yTPI1t8Uh5DcE6glMCVsP9EMygXo3sSV1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vmzF74//; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e5588db705so1210358b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709248012; x=1709852812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDSHqiXfNKpfl7COydQUrDyx9a3y4hCYnPwB57HeAq4=;
        b=vmzF74//eEnu3FEZLvDTrbaKWrHKwN7zPUve1BN473bFERGEAiIRRD+OhFE7prwF6S
         TG9eusVU4Dy3O0jkT89W+9V8w+EiIK5SwoOPH3CamhnPFItXpwCxl5HbxvWExFK1z0DK
         oa5PV9w9iwPmnZhzZL1BndkUIy5I2grBHyNasg//eux/xH8uNx3XVmkWFJGcYo9B3Efq
         t2p03mOEsi/l4goNKK6l8cyYiZLFHQDKq1LWSOEIcZtz922m8nRIqaqcoVzEr7LDmKSM
         k77mt0qF/YSp+Evm/BhxLhp/KaPd3phOGzOrUAV0YadS8o2Uow0yxDoyPa4RSf4bwJ9Q
         QmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709248012; x=1709852812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDSHqiXfNKpfl7COydQUrDyx9a3y4hCYnPwB57HeAq4=;
        b=PnCPNhf/W3wTY3TBjXcISx1/XiuC9owvyOaq4trhpp6MxWdQ/qXKma/8DD9iz/DEZg
         ZaSFmB08LA6o3jfTr+q3B+WbcgaBmhFVx3OndEXOVSLhPEXHw/l0daWAmdGfZPMGGXfO
         Kth3lhqViuvF4CJ0Hhx4D8LG9OlLVI8iYa7kkh5wCMvEyBbojg2PxNxwXxFjFkgoIbMM
         6QIosm3vLImUPm0dds3tYlgBlXQ/SVx4sA1yZzMKHrcC+AJUiHV1irzDt42dZkNSgyw3
         /+RZDna5ZLp+QlKgDic8wphgBbCTOOu3kpBeTkSPw9wLfsiat9iOU1kw6t6K6/qVSDjM
         TEGA==
X-Forwarded-Encrypted: i=1; AJvYcCXD7P801SMsRXbUJLzexDArVcpVWV8bT2DApfQW4IG/qKOe9W6qrLDQ94gIyIDCouxQyEmD539qzX4DnCKZfgj6Er8E
X-Gm-Message-State: AOJu0Yxe0CGh26vEdDrCBKLRWmIeS952LTmt+GfhEQJXKWYDN9BFM2EO
	rDMFPGl7Xi4xrTbEvueAB2Ncfgb4+1KbkR+teZz1RBEihXEDkKmpSqk3sspjTICyBeEzkw8O9QN
	+uA==
X-Google-Smtp-Source: AGHT+IGyOJM16ooLf22gCZwTXPwwrqBH5Gu9wh/XTg/dFAQ9ybGaCE2NIcDjGHVD/eYJmV6aRvTArFW5Iac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d09:b0:6e5:4142:ea1c with SMTP id
 fa9-20020a056a002d0900b006e54142ea1cmr4589pfb.3.1709248012512; Thu, 29 Feb
 2024 15:06:52 -0800 (PST)
Date: Thu, 29 Feb 2024 15:06:51 -0800
In-Reply-To: <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-9-seanjc@google.com>
 <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com>
Message-ID: <ZeEOC0mo8C4GL708@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 01, 2024, Kai Huang wrote:
> 
> 
> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> > WARN and skip the emulated MMIO fastpath if a private, reserved page fault
> > is encountered, as private+reserved should be an impossible combination
> > (KVM should never create an MMIO SPTE for a private access).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index bd342ebd0809..9206cfa58feb 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5866,7 +5866,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
> >   		error_code |= PFERR_PRIVATE_ACCESS;
> >   	r = RET_PF_INVALID;
> > -	if (unlikely(error_code & PFERR_RSVD_MASK)) {
> > +	if (unlikely((error_code & PFERR_RSVD_MASK) &&
> > +		     !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
> >   		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
> >   		if (r == RET_PF_EMULATE)
> >   			goto emulate;
> 
> It seems this will make KVM continue to call kvm_mmu_do_page_fault() when
> such private+reserve error code actually happens (e.g., due to bug), because
> @r is still RET_PF_INVALID in such case.

Yep.

> Is it better to just return error, e.g., -EINVAL, and give up?

As long as there is no obvious/immediate danger to the host, no obvious way for
the "bad" behavior to cause data corruption for the guest, and continuing on has
a plausible chance of working, then KVM should generally try to continue on and
not terminate the VM.

E.g. in this case, KVM will just skip various fast paths because of the RSVD flag,
and treat the fault like a PRIVATE fault.  Hmm, but page_fault_handle_page_track()
would skip write tracking, which could theoretically cause data corruption, so I
guess arguably it would be safer to bail?

Anyone else have an opinion?  This type of bug should never escape development,
so I'm a-ok effectively killing the VM.  Unless someone has a good argument for
continuing on, I'll go with Kai's suggestion and squash this:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cedacb1b89c5..d796a162b2da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5892,8 +5892,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
                error_code |= PFERR_PRIVATE_ACCESS;
 
        r = RET_PF_INVALID;
-       if (unlikely((error_code & PFERR_RSVD_MASK) &&
-                    !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
+       if (unlikely(error_code & PFERR_RSVD_MASK)) {
+               if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
+                       return -EFAULT;
+
                r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
                if (r == RET_PF_EMULATE)
                        goto emulate;

