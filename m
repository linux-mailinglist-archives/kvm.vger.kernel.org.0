Return-Path: <kvm+bounces-14822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 086988A734E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BDD01C226D3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18375137761;
	Tue, 16 Apr 2024 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mAjJXpqh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90602D60A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713292516; cv=none; b=faO0yHTFKPnY0lvWQkpI8Wdb1EaII9ltr8Mq0KslbyiiALUPQvoBzWKo7ejNCwAyOAY8Q0ore9uLNsk6nqQSKg6pOVJ53TlmdiWdMgIoYiTJ/yP97wNDfvkgKFPrX8Fq4dZhP37vySEwj7EKz6JoVeXwBJF/RyBBIDUNTOLb6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713292516; c=relaxed/simple;
	bh=2DmfH0iZuBeBaf9fmZxw8bxd/Na/JJLdrJnni9XYYsI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rdV9RFksm4vZUpXn5N64P42+X7hSk2K7evuOkaS9nf1+CKfo7bw2MqwWJ7mreFXGPPyLUIFAv7p+pn4Jshn9eBjbZHv8LGEko4Qn0yeXP00gXaW3Jf3kQU9JmWHZ0Cd8sVhuGO04wJmjMumkyVak85oMwGHY98infTw6U+z068w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mAjJXpqh; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2be2a866aso50307245ad.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713292513; x=1713897313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4IcmDFg9mXfsOm+KYa9etM9trKW2oRgOEYJLX5Llhs=;
        b=mAjJXpqhNpvZHQD00GZO0U/Oz751ABA9G+j4q35BGnuTiqi1/cVAM2sOQCZ/cnwEUS
         Zc92UALDTpfzuN9r9LHlhQ9BR+YIYqKSEDNa8PK7AumZVSOyHVXqpHM5+On/iggdWbLA
         90vUzEu0vyHlgrGZmPRIW7EppLWhdhkKEY8nFm/mvo2Y2IhZS5i3z/i9SSRE0xE3UShQ
         A+PUVOHg554RzM6UM+r8RbC7oydSTbn+vNNc3wLaXrAPdORAeJT0tN2RkD6J10oN09NT
         pASk5elribF1Er6BZYJll0uASG7BiDh7wZJ7OXtH2L7gu3eZv30PjdP2M2ECTAN0ruPl
         lNqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713292513; x=1713897313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4IcmDFg9mXfsOm+KYa9etM9trKW2oRgOEYJLX5Llhs=;
        b=eLCsW/w5IjZ3z0KKu6sOZBO4zGEahXf9qSGhnqi4C8mI+o2miJ9KXgNM4r0QqdmXbF
         aRVsxetDwC5IoMFJpMSAONWCxdXzKvqJZeGMInu5EALXPrVWDMgvvlw+szQvOQlw06yX
         ufXSxkeWcvu5u/E5yifDLfNnzQU0y6nqSncRGmt9B/A+Bbyv0HpXB2L5aZQ4fBOeqD27
         QGt76wqN6TvMGTGBaL2PX2fclbuSYIC1iB9JQ11KFhaMvWrc2oG8WBMD/uQMrAh3m3/1
         mZMwUrT/GuxHsxV0vwUnLWq8nPiGbPDHJn0KYBi0NYOeW8J1EXZqG1h8C2/j40WGhIZ8
         4Mlg==
X-Forwarded-Encrypted: i=1; AJvYcCUVmWalRQy6/ZQW7nAQ9TCWD8t61shjjWT2hgV9NZBc9rXoPzRMqu927wCNnxBRroX4xrU7bt1BsHp2w7x/TwFTXYuV
X-Gm-Message-State: AOJu0Yy05rWQYrKq0Mb3dee6fQPHrBBtMisgfBwF4qx5vwtNzf7fy8pt
	8F5WFbN6EP69Ob0H9XMeXNMkxFWAqmv/4qNnPtH05LHHV8UeN5ElSq5twKTq+xR4zlsqeOW77pO
	x8g==
X-Google-Smtp-Source: AGHT+IH2l/4Q1X0kmlazvUCeA2LxIdHYVFqddoS+Vcjn6XdYq8l7HIp0PwRH0csKmwi+ILtTtyM7Ra+SNYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e80b:b0:1e3:ff3a:7a07 with SMTP id
 u11-20020a170902e80b00b001e3ff3a7a07mr93926plg.6.1713292513069; Tue, 16 Apr
 2024 11:35:13 -0700 (PDT)
Date: Tue, 16 Apr 2024 11:35:11 -0700
In-Reply-To: <ZhkQsqRjy1ba+mRm@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com> <ZhTj8kdChoqSLpi8@chao-email>
 <98493056-4a75-46ad-be79-eb6784034394@oracle.com> <ZhkQsqRjy1ba+mRm@chao-email>
Message-ID: <Zh7E3yIYHYGTGGoB@google.com>
Subject: Re: [RFC 3/3] x86: KVM: stats: Add a stat counter for GALog events
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	pbonzini@redhat.com, linux-kernel@vger.kernel.org, joao.m.martins@oracle.com, 
	boris.ostrovsky@oracle.com, mark.kanda@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 12, 2024, Chao Gao wrote:
> On Tue, Apr 09, 2024 at 09:31:45PM -0400, Alejandro Jimenez wrote:
> >
> >On 4/9/24 02:45, Chao Gao wrote:
> >> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> >> > index 4b74ea91f4e6..853cafe4a9af 100644
> >> > --- a/arch/x86/kvm/svm/avic.c
> >> > +++ b/arch/x86/kvm/svm/avic.c
> >> > @@ -165,8 +165,10 @@ int avic_ga_log_notifier(u32 ga_tag)
> >> > 	 * bit in the vAPIC backing page. So, we just need to schedule
> >> > 	 * in the vcpu.
> >> > 	 */
> >> > -	if (vcpu)
> >> > +	if (vcpu) {
> >> > 		kvm_vcpu_wake_up(vcpu);
> >> > +		++vcpu->stat.ga_log_event;
> >> > +	}
> >> > 
> >> 
> >> I am not sure why this is added for SVM only.
> >
> >I am mostly familiar with AVIC, and much less so with VMX's PI, so this is
> >why I am likely missing potential stats that could be useful to expose from
> >the VMX  side. I'll be glad to implement any other suggestions you have.
> >
> >
> >it looks to me GALog events are
> >> similar to Intel IOMMU's wakeup events. Can we have a general name? maybe
> >> iommu_wakeup_event
> >
> >I believe that after:
> >d588bb9be1da ("KVM: VMX: enable IPI virtualization")
> >
> >both the VT-d PI and the virtualized IPIs code paths will use POSTED_INTR_WAKEUP_VECTOR
> >for interrupts targeting a blocked vCPU. So on Intel hosts enabling IPI virtualization,
> >a counter incremented in pi_wakeup_handler() would record interrupts from both virtualized
> >IPIs and VT-d sources.
> >
> >I don't think it is correct to generalize this counter since AMD's implementation is
> >different; when a blocked vCPU is targeted:
> >
> >- by device interrupts, it uses the GA Log mechanism
> >- by an IPI, it generates an AVIC_INCOMPLETE_IPI #VMEXIT
> >
> >If the reasoning above is correct, we can add a VMX specific counter (vmx_pi_wakeup_event?)
> >that is increased in pi_wakeup_handler() as you suggest, and document the difference
> >in behavior so that is not confused as equivalent with the ga_log_event counter.
> 
> Correct. If we cannot generalize the counter, I think it is ok to
> add the counter for SVM only. Thank you for the clarification.

There's already a generic stat, halt_wakeup, that more or less covers this case.
And despite what the comment says, avic_ga_log_notifier() does NOT schedule in
the task, kvm_vcpu_wake_up() only wakes up blocking vCPUs, no more, no less.

I'm also not at all convinced that KVM needs to differentiate between IPIs and
device interrupts that arrive when the vCPU isn't in the guest.  E.g. this can
kinda sorta be used to confirm IRQ affinity, but if the vCPU is happily running
in the guest, such a heuristic will get false negatives.

And for confirming that GA logging is working, that's more or less covered by the
proposed APICv stat.  If AVIC is enabled, the VM has assigned devices, and GA logging
*isn't* working, then you'll probably find out quite quickly because the VM will
have a lot of missed interrupts, e.g. vCPUs will get stuck in HLT.

