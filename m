Return-Path: <kvm+bounces-40115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 758FEA4F4EB
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8728618902D0
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50991624EB;
	Wed,  5 Mar 2025 02:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MslySkiR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468A615CD4A
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 02:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143135; cv=none; b=NSeIZjjYbnq7TBSGIfth6ivbqG96XdxLKpsAITp6z4D8tybDZ8LXqReX7vazdAC89KUdHwb4fWGekIvVqrxzXxWvFb2s3KG7ZENJoUuvjAVc8p2IovHxqWWG7DoDK2yic6vYvCqjH3lxWihoyWB+SYiakEuINKiwfKINLmIMQrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143135; c=relaxed/simple;
	bh=z8PMHSd9seF3AUVlpPcwhetZy5doRJadMfFSLi+nKt8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kh6vn26xi5PtwD2j1NVbx80pGP/JAVnpGfLS5gyv48JdqIaJpmO3+kpbjqbARdI1vlsXZdCCEmShm1lEBYMJ8Bl8Qq+9UvnH7of5pTEP6uVBildvQCJzvdPsnrXemMF/m/VgyVgzDz1fQJsWBErqRE6ThBW6bynyza87NfmEUjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MslySkiR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741143132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BjKaEiYnY5H1cwKZK+Yz/RA9HClbXYNadwatn6L8wbk=;
	b=MslySkiRMlq7t5gsxDntSSFZS6wykD0axcC62oNWFdfibl0vSOUcKMbiCAYSHLH4v5VHlR
	Cb3pweQez0boDRDfc24A1bgJRFjWsEIufzIgOnIO2Ugq+IZOgRPZwY6xgubxInD4vHXR/J
	MPe4pQ/IKy656dBBhTJWK8ssKHEtD98=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-rIt2_d_GP8OatYow4N170g-1; Tue, 04 Mar 2025 21:52:05 -0500
X-MC-Unique: rIt2_d_GP8OatYow4N170g-1
X-Mimecast-MFC-AGG-ID: rIt2_d_GP8OatYow4N170g_1741143125
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c3b7f1227cso315343285a.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 18:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741143125; x=1741747925;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BjKaEiYnY5H1cwKZK+Yz/RA9HClbXYNadwatn6L8wbk=;
        b=HTJi2Wmss1emZQqVxbwqcdpEfWhVMHcSO92cMPKuEBxlXrE5nOZC99ODm3ZienTzeJ
         dnBvLGGGLy5gggAWQxhGK5PnIR+8tOjQPoGIrg8jjPpTvWAzlRYAeZdmCglsRU5MQvFE
         SkFlcpjuBOS3sNDVpIe9nqBBztORIJwzZgX0x18poLiJ+Zqen/wNc0YmJ0h2buOYwY9O
         7ui4KlDxfNUN3ZpgFl4cMyp2EZYh+Ec7VbnLssJKPafSrGhZBnU6XjsqMoyt42KV2+DC
         sNyt59GF4Y8S2uytYedPIf/n+ERJbpwMcsqdee2epuPnd0EXry3kvcyWh6N0z/D8jtAb
         p1Gg==
X-Forwarded-Encrypted: i=1; AJvYcCW3Tyu1cjb7+MmXX2oC5Uz9IgAIHGHvblmdxy+e5Qd+mue5t5bgd96JymmfS5WXAoF27gw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8aEZDFXEgj62K0x36a2XHenFCbe1EqKQfjV5vC7mFk9SOIBHC
	3rBfRjmsMp+Gd3NvRU6VnjQGv+olKlpDRk2OHWvRd15CODdHubmuLwHjEpMZ0Kpf12ZnzyYwThD
	jkQQ87ZPidqHEEJ3ngwHM98+3hrObsC4aASf72DJf6eLuupCYEA==
X-Gm-Gg: ASbGncsYwEAx8NYNJYQhsoRoH6URZ0gP0ZkfhsQ23Ylx22/Ul19T5fM7s+zDGh6X55q
	/gqxiDhGU6C5DFy9dZRrIYvWeNl3tY6FJ0iPcAVQ/IQ2/UnjneaheiQH6O0gDiq7fTufDRbl7wy
	HJKkzYWsNekjuFVAVfGX43QmBHraRfjODwHm3Ww+uY4V0AvjJQmPP53TVF1tKaSsUExsLNSBOhh
	zFTOo9ksSOqB6Uzv/TEgCwO8MUk5xQZi9FeMtaWWIK7MAVQBjeNM+Bmen6VirjSZpy+tl8RCXDL
	ao5b855nX6xkU5I=
X-Received: by 2002:a05:620a:2853:b0:7c3:bc90:a483 with SMTP id af79cd13be357-7c3d8def966mr274517385a.32.1741143125373;
        Tue, 04 Mar 2025 18:52:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4Kzaq47oYaXlluWqNHqU3y5KWm3Sf1dynP6q+E+3NZJnSaYHcFgkm9SxC6tuVsRmRNSnNDg==
X-Received: by 2002:a05:620a:2853:b0:7c3:bc90:a483 with SMTP id af79cd13be357-7c3d8def966mr274514485a.32.1741143125056;
        Tue, 04 Mar 2025 18:52:05 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3be81e8e9sm338768285a.61.2025.03.04.18.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 18:52:04 -0800 (PST)
Message-ID: <dcaaf50f186a94147528a4c53706749dc25db395.camel@redhat.com>
Subject: Re: [RFC PATCH 02/13] KVM: nSVM: Rework svm_flush_tlb_asid() to
 operate on a given VMCB
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2025 21:52:03 -0500
In-Reply-To: <Z8YmEC_P73JsvRWs@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-3-yosry.ahmed@linux.dev>
	 <2bb5b47e1b6c1251ae7fffe6d4d9836a401a1be0.camel@redhat.com>
	 <Z8YmEC_P73JsvRWs@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-03-03 at 21:58 +0000, Yosry Ahmed wrote:
> On Fri, Feb 28, 2025 at 08:29:34PM -0500, Maxim Levitsky wrote:
> > On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > > svm_flush_tlb_asid() currently operates on the current VMCB. In
> > > preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
> > > refactor it to work on a given VMCB. All existing callers pass the
> > > current VMCB.
> > > 
> > > Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
> > > callback.
> > > 
> > > kvm_hv_vcpu_purge_flush_tlb() is only called when the current VMCB is
> > > passed to maintain current behavior.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/svm.c | 25 ++++++++++++++++++-------
> > >  1 file changed, 18 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 08340ae57777b..2108b48ba4959 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -3954,7 +3954,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> > >  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> > >  }
> > >  
> > > -static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> > > +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, struct kvm_vmcb_info *vmcb)
> > >  {
> > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > >  
> > > @@ -3963,7 +3963,8 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> > >  	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
> > >  	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
> > >  	 */
> > > -	kvm_hv_vcpu_purge_flush_tlb(vcpu);
> > > +	if (vmcb == svm->current_vmcb)
> > > +		kvm_hv_vcpu_purge_flush_tlb(vcpu);
> > 
> > This is hyperv PV feature that should be looked upon very carefully.
> > 
> > To recap, 
> > each vCPU has 2 queues of pending TLB flush requests that target only small range of
> > memory pages. 
> 
> Thanks for pointing this out, I missed this.
> 
> > One is for L1 and one for L2, because now KVM supports a mode where L2
> > can ask L0 to do a tlb flush on its behalf, and KVM will figure out to which L1 vCPUs
> > to send this flush request.
> > 
> > Requests arrive from other vCPUs.
> > 
> > Here we purge the TLB request queue because we flushed a super-set of the requests,
> > which used to contain both L1 and L2 TLB, but soon that won't be true.
> > 
> > So I think it might make sense to also add vmcb to kvm_hv_vcpu_purge_flush_tlb, and then
> > depending if it is vmcb01 or vmcb02, purge the correct queue.
> > I don't know if this is theoretical or actual bug but it is better to be safe IMHO.
> 
> But I think we are already purging the right queue here. We purge the
> TLB flush requests only if we are flushing the current VMCB. Within
> kvm_hv_vcpu_purge_flush_tlb(), we choose the queue based on
> is_guest_mode(vcpu).
> 
> svm_flush_tlb_asid() is called when servicing a TLB flush request, at
> which point IIUC the current VMCB and whether the vCPU is in guest mode
> should be in sync. So we will be correctly purging the L1 or L2 queue
> based on the current VMCB.

Yes, I also think so, but to harden this code from a potential bug IMHO
it makes sense to ensure that svm_flush_tlb_asid works only on a given
vmcb without any hidden assumptions.

> 
> That being said, it's a bit confusing that svm_flush_tlb_asid() uses the
> VMCB to differentiate L1 and L2 ,while kvm_hv_vcpu_purge_flush_tlb()
> uses is_guest_mode(). We also miss the opportunity to purge both queues
> when called from svm_flush_tlb_all().

Yes, I noticed that too.

> 
> However, we cannot pass the VMCB to kvm_hv_vcpu_purge_flush_tlb() as it
> is also called from common code. So I think we can make
> kvm_hv_vcpu_purge_flush_tlb() take is_guest_mode as a parameter and pass
> it here based on which VMCB is passed in.



> 
> WDYT?
> 


Looking at this again, I see that kvm_hv_vcpu_purge_flush_tlb() can't really work
on a vmcb, so maybe the better solution is to remove the call to 
kvm_hv_vcpu_purge_flush_tlb() from svm_flush_tlb_asid_vmcb at all
and instead let the caller call both svm_flush_tlb_asid() and kvm_hv_vcpu_purge_flush_tlb()?

This might lead to some code duplication but this will put emphasis that svm_flush_tlb_asid_vmcb
can work on any vmcb regardless of which one is loaded and such.

As long as it works though, I won't strongly object to whatever code that works.

Best regards,
	Maxim Levitsky


