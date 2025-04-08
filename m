Return-Path: <kvm+bounces-42945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 544ABA80F6F
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCE2A1892E52
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C0A22A1E9;
	Tue,  8 Apr 2025 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pz7Css5I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F581224252
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124923; cv=none; b=Of+ne9uD5E1b+hKqeebeIJPR5fwlW65u7n/M8sVBaM6ER9uCPv9gaivukjcyjm72KKn89uMKBssIiJQp92Q1LQq7O1g2g+dsE3xDPhr6p41qw/Q5coDsJ7WJ2079RmFLMLPeXJpjTAFKNyIwd5Ka7yiiKO7swjh4uv/qV+qs9R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124923; c=relaxed/simple;
	bh=HNXnbhfmGDZM+xj/jEAWizg89ODfflpmEZ5rbDsSo8I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=st88s0cMNQErIPzf74yeVlOpO9jGwmrOEoAM+R78Rn6j7ywApflMbWZV/MnG5nxLl5hMrnTir1yzMfpAcVx3Z8048UrajVy5hyhdLrYnNWqR41agZaE5EU6vsTz3tjhJQM1keI+4CD3B3O8dyGaU/eNV080YmqtLgzGX7vUEt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pz7Css5I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744124920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZrKnbR932NuSRMO08mOFLU+K3sEyi6GgonUlzMLmrM=;
	b=Pz7Css5Io7oTPwR6ukGMsN73UX0A7NT2ETc1MUhYwgZGLhgIf9XMCOht4XophPgqPPcnSL
	U/haQwdUJYROfzeqfkapgXSyUx0VwOgS9HeHcuHK/a2ANYASdEQf6poeEeHhHkP34p4TFM
	i+eEYTOyIyKUimQotzTG93rc+tDOL2U=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-LFw96bElMwiQwPDHxcOSQw-1; Tue, 08 Apr 2025 11:08:37 -0400
X-MC-Unique: LFw96bElMwiQwPDHxcOSQw-1
X-Mimecast-MFC-AGG-ID: LFw96bElMwiQwPDHxcOSQw_1744124917
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c793d573b2so236206785a.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 08:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744124917; x=1744729717;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dZrKnbR932NuSRMO08mOFLU+K3sEyi6GgonUlzMLmrM=;
        b=VsXf9LEsYd9GDPF1uvMbA1tB2JkRfXrbDRlaKhGnUSUTsvjxCGEHim3rdCZ27mF0iD
         zUP6i9aUT+m8ReVNQpeFmBWf60VSAd8WJWmTUhnP87TSuG0JcgUPzLfIph7W9ApBOrXE
         BJTmYf8XJ8sgMNua1JN7d9Oa1wvs5gJMRoXtvX/FRWha3mCwuYMP1xc6eob2jtZb1adi
         mV+lAatf/VLKv98oetuf10Gp19ASV5XHQyT8grIPhDunwJHR+3Xdo3GeWhfFhpGBzUmd
         CMKfDhfG6tx09hrKT8Makdf1CG0afXv70s5tsL4bxItQAaUJtuN7jP1+YUUrEksdAwdx
         KXog==
X-Gm-Message-State: AOJu0YwW7CB2eZ/HC/zr55SGiuG+MBX8SpRwQmwduzQ9N55Kg5XDIIhe
	qozXSKxmaBxFQ01JTw2wkFWO/R2u8V4F1+XPXzrkKxs2u04NAdiHBi4NYXftSEO/BnZg+6yJaYJ
	3MMwQw3aEuGmwn5qzpi4dKgHxelAQamXV75Ohvr1XZrdc0XkdjQ==
X-Gm-Gg: ASbGncvCyMvfgXHKub9XENPoKhunlqapaAKQAVZXmLSUeieFOQb91ya54jbKFH+belW
	zvqwmq8D6WHq7etZEnI/HFF8aJ4SgCTAXKIaLuh2qBczfD0ImqxTlodq8h8Hj1eknsoV1gbWYuG
	kcspxA6qXT5JuSeGikieTpibQEduopHb9U5UM1mx9aX2q6FouZroCTEJZbDKK8tdsK0bVkepjCS
	y9IhZgXyavJ+xFtbocWeqPgiYErTw/3MY9ghmwrzeYshXl0hB9iKxJK52fM5cAxi3dwAERJm6YW
	1l6kbPjVkM/k188=
X-Received: by 2002:a05:620a:2953:b0:7c5:f6be:bdae with SMTP id af79cd13be357-7c77dd878d3mr1889955085a.20.1744124917228;
        Tue, 08 Apr 2025 08:08:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyjwRvAMPsc7+/yZsuoA8Vm8+KGnJEimLkd/evsKpNc1uqTkvyoDqNHIFRzfthudHDVbRBSw==
X-Received: by 2002:a05:620a:2953:b0:7c5:f6be:bdae with SMTP id af79cd13be357-7c77dd878d3mr1889951085a.20.1744124916873;
        Tue, 08 Apr 2025 08:08:36 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76e5dc169sm778625785a.0.2025.04.08.08.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 08:08:36 -0700 (PDT)
Message-ID: <1371fec40588247a5f3d42f1b0f21cf4d0f5bc4e.camel@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Ravi Bangoria
	 <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	rangemachine@gmail.com, whanos@sergal.fun
Date: Tue, 08 Apr 2025 11:08:35 -0400
In-Reply-To: <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
References: <20250227222411.3490595-1-seanjc@google.com>
	 <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-04-01 at 23:57 -0400, Maxim Levitsky wrote:
> On Thu, 2025-02-27 at 14:24 -0800, Sean Christopherson wrote:
> > Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> > DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> > context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> > just supported, but fully enabled).
> > 
> > The bug has gone unnoticed because until recently, the only bits that
> > KVM would leave set were things like BTF, which are guest visible but
> > won't cause functional problems unless guest software is being especially
> > particular about #DBs.
> > 
> > The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> > as the resulting #DBs due to split-lock accesses in guest userspace (lol
> > Steam) get reflected into the guest by KVM.
> > 
> > Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> > likely the behavior that SVM guests have gotten the vast, vast majority of
> > the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> > option for a fix, e.g. versus trying to add proper BTF virtualization on the
> > fly.
> > 
> > v3:
> >  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
> >  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
> >    it's guaranteed to be '0' in this scenario). [Ravi]
> > 
> > v2:
> >  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
> >  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
> >    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
> >  - Collect a review. [Xiaoyao]
> >  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> > 
> > v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
> > 
> 
> Hi,
> 
> Amusingly there is another DEBUGCTL issue, which I just got to the bottom of.
> (if I am not mistaken of course).
> 
> We currently don't let the guest set DEBUGCTL.FREEZE_WHILE_SMM and neither
> set it ourselves in GUEST_IA32_DEBUGCTL vmcs field, even when supported by the host
> (If I read the code correctly, I didn't verify this in runtime)
> 
> This means that the host #SMIs will interfere with the guest PMU.
> In particular this causes the 'pmu' kvm-unit-test to fail, which is something that our CI caught.
> 
> I think that kvm should just set this bit, or even better, use the host value of this bit,
> and hide it from the guest, because the guest shouldn't know about host's smm, 
> and we AFAIK don't really support freezing perfmon when the guest enters its own emulated SMM.
> 
> What do you think? I'll post patches if you think that this is a good idea.
> (A temp hack to set this bit always in GUEST_IA32_DEBUGCTL fixed the problem for me)
> 
> I also need to check if AMD also has this feature, or if this is Intel specific.

Any update?

Best regards,
	Maxim Levitsky

> 
> Best regards,
> 	Maxim Levitsky
> 
> > Sean Christopherson (6):
> >   KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
> >   KVM: SVM: Suppress DEBUGCTL.BTF on AMD
> >   KVM: x86: Snapshot the host's DEBUGCTL in common x86
> >   KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is
> >     disabled
> >   KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
> >   KVM: SVM: Treat DEBUGCTL[5:2] as reserved
> > 
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm/svm.c          | 24 ++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.h          |  2 +-
> >  arch/x86/kvm/vmx/vmx.c          |  8 ++------
> >  arch/x86/kvm/vmx/vmx.h          |  2 --
> >  arch/x86/kvm/x86.c              |  2 ++
> >  6 files changed, 30 insertions(+), 9 deletions(-)
> > 
> > 
> > base-commit: fed48e2967f402f561d80075a20c5c9e16866e53



