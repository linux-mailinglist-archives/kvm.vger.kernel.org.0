Return-Path: <kvm+bounces-40121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD29A4F536
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 081A0188BFF6
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E8F1547E9;
	Wed,  5 Mar 2025 03:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZyRQXLA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85C72E337F
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 03:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741144486; cv=none; b=QBlGpyhOZSCCGvX4y3DMacuuRfmSDn0Cn+M8DYepljWNbhrXzLRb66AJukmOloHX2IoV7cb36Lq1QPZariG/cw3SOewHRCoLZh5HbFcUpH7pAVqdq/lWCSsEOlH7LG2e+IAP867EUvb8cEDD1s7HMPuNnUNN7b8/UtKwQANUfHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741144486; c=relaxed/simple;
	bh=mKIwmU5nGmMStslBhDKJLOQp2Mw7lkW2KzNmyVlIHDM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GoHy80cZxk/I8temTdg+QX9dgCygbz/Y8Tkl7mfN7pJLPzICIit50z1uuE4JchF4rXASFGdU6+FPYvBREKdf/rAnuYRmu+nQZ8AWzkaRIiRvJKEWDX4dXo2fYCNnakQGuCZ8wTW+Q50z7HmnXf6pugTXkCqiqZwtCtlrOPeE+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JZyRQXLA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741144483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8OIlrSSbnRoH/I9ueewHmQOSL97xriOrLorU3tLDCU=;
	b=JZyRQXLANKSG8yL3cIFUuNpBHSSmWUlQpWUBJBA/HNVD76LXAsrigWZIk38Syuml/usogO
	/1hRWlEDVdFpnX483Ew895PkhxIUUYY/dwJH2seLPK1vJwNRczIxM9RDPVyh0IkA9vdM02
	Y1FzQRn5UCGVJO6YW3Xg09XC2kPhXmA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-EPmYY8yTMv2VJ2S6MPhN2A-1; Tue, 04 Mar 2025 22:14:42 -0500
X-MC-Unique: EPmYY8yTMv2VJ2S6MPhN2A-1
X-Mimecast-MFC-AGG-ID: EPmYY8yTMv2VJ2S6MPhN2A_1741144482
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c3b4bea51eso434745485a.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 19:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741144482; x=1741749282;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F8OIlrSSbnRoH/I9ueewHmQOSL97xriOrLorU3tLDCU=;
        b=dIQeYoVZE7LwgnwynMjyDtuDBkVmqBSG+tIPifhWKKOuBueyyOqLTpIXAZ+jz5yYfo
         2H8BuvOFW1yLYcoUVx9Fi9TLObFBxyyOteE3YnJWeTNFOqmM+m57JD6XWCFqlqqsuANI
         G9oBlgGOj4dt4nXDS2SXFp7OxjyAXdYxS0b9cNuBjpwUHf9QWgaLQUNTg2uZCnVe+hsl
         OdOVwZD13LG/2L3y1sVGgr9ArYmhO8o2H1ZrPMUwy8WwZCB4JxVYbDop57jb5PNuVsmR
         YQvVVfSDc10fYmhj6AA8G81Z0Io9UFOwTrMO6HfoLysWq1+AYq15GVrFHGPZJGxCgUmd
         4SmA==
X-Forwarded-Encrypted: i=1; AJvYcCWOwz01ZstcP5hL/8Lj2mwRrQGKjeLDL3nzNLEl6lSjZTpeolmUe8PM6aSo3o4swzxMFCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCug5woaKpp/0Eq832nHFgBYwNpGoI5FJJhilmgXuqV/AgBkDU
	zeEAaHrgD89dlnyScckNUBbk4NmTGx61kFnVxzGJQZfMv/k049hHhygGvdw+Ti45dMK5SFPAg2o
	18B35FdwskasyakZ6A0PSyhtofvHmRtmfWR98dWMySnnbpUZxlQ==
X-Gm-Gg: ASbGncuHo4lRBa6B94imQ1GWOkw+WNzn7EP5YX2f2IajZ6S5I06dMQz1RnLzOSM0N9h
	sxVe0/SdnCMn+JmERWwUM909FMS6jk0orgquADa9AGl6CFVxQ37vLxigGkDT7uUF8rjBP/RKVgt
	5fq8M4uK7aEsCIy38DHAOUIEMs+lJJayVXM4IUZe0CAaaPWIh61yyiX6KkhsAZNwyMlSVDD7N5j
	cVq5TJHBr/VQIeDwzM4tSDC10rlSripMp5MpQ2XwNOfJFwEo53zRu35D13GquYGWWL/E0jbGVQI
	1PcbGEry2CTK+2k=
X-Received: by 2002:a05:620a:6411:b0:7c3:bfb3:7f52 with SMTP id af79cd13be357-7c3d8ee1cbbmr262343585a.42.1741144481820;
        Tue, 04 Mar 2025 19:14:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFIen1Tkw83r5Q1ou2d9UeK1E+93rOWEHWJsNCoUP22/wPVtYlHBpo4G+TU41xCNd0VtnnNIQ==
X-Received: by 2002:a05:620a:6411:b0:7c3:bfb3:7f52 with SMTP id af79cd13be357-7c3d8ee1cbbmr262341885a.42.1741144481470;
        Tue, 04 Mar 2025 19:14:41 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c395c5376bsm781326385a.37.2025.03.04.19.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 19:14:41 -0800 (PST)
Message-ID: <36d8ffbda9e69c5245ded717e7491f6fcd5ca72e.camel@redhat.com>
Subject: Re: [RFC PATCH 13/13] KVM: nSVM: Stop bombing the TLB on nested
 transitions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2025 22:14:40 -0500
In-Reply-To: <Z8YrdcWd1PD76adM@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-14-yosry.ahmed@linux.dev>
	 <da0b13813b11e5b13f01dced9a629ac07fad27cd.camel@redhat.com>
	 <Z8YrdcWd1PD76adM@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-03-03 at 22:21 +0000, Yosry Ahmed wrote:
> On Fri, Feb 28, 2025 at 09:21:54PM -0500, Maxim Levitsky wrote:
> > On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > > Now that nested TLB flushes are properly tracked with a well-maintained
> > > separate ASID for L2 and proper handling of L1's TLB flush requests,
> > > drop the unconditional flushes and syncs on nested transitions.
> > > 
> > > On a Milan machine, an L1 and L2 guests were booted, both with a single
> > > vCPU, and pinned to a single physical CPU to maximize TLB collisions. In
> > > this setup, the cpuid_rate microbenchmark [1] showed the following
> > > changes with this patch:
> > > 
> > > +--------+--------+-------------------+----------------------+
> > > > L0     | L1     | cpuid_rate (base) | cpuid_rate (patched) |
> > > +========+========+===================+======================+
> > > > NPT    | NPT    | 256621            | 301113 (+17.3%)      |
> > > > NPT    | Shadow | 180017            | 203347 (+12.96%)     |
> > > > Shadow | Shadow | 177006            | 189150 (+6.86%)      |
> > > +--------+--------+-------------------+----------------------+
> > > 
> > > [1]https://lore.kernel.org/kvm/20231109180646.2963718-1-khorenko@virtuozzo.com/
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 7 -------
> > >  1 file changed, 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 8e40ff21f7353..45a187d4c23d1 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -512,9 +512,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> > >  		svm->nested.last_asid = svm->nested.ctl.asid;
> > >  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > >  	}
> > > -	/* TODO: optimize unconditional TLB flush/MMU sync */
> > > -	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > > -	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > >  }
> > >  
> > >  static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> > > @@ -530,10 +527,6 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> > >  	 */
> > >  	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
> > >  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > > -
> > > -	/* TODO: optimize unconditional TLB flush/MMU sync */
> > > -	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > > -	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > >  }
> > >  
> > >  /*
> > 
> > Assuming that all previous patches are correct this one should work as well.
> > 
> > However only a very heavy stress testing, including hyperv, windows guests
> > of various types, etc can give me confidence that there is no some ugly bug lurking
> > somewhere.
> 
> I tried booting an L2 and running some workloads like netperf in there.
> I also tried booting an L3.
> 
> I am planning to try and run some testing with a windows L2 guest. I am
> assuming this exercises the hyper-V emulation in L1, which could be
> interesting.
> 
> I am not sure if I will be able to test more scenarios though,
> especially Windows as an L1 (and something else as an L2).
> 
> Let me know if you have something specific in mind.


KVM can run itself 'under' HyperV (although in this case when it runs a guest
the guest will be L3 overall, so not really something supported but still something that might
reveal bugs).
In this case KVM/L1 can take advantage of L0's TLB flush interface.

Stress testing L3s also can be nice, although in this case from L0 POV, it doesn't see L3 at all.
Instead it sees that L1 runs two different L2s back to back, so the current code will
likely flush everything all the time.


The direct TLB flush that hyperv does, especially from L2 to L0 should also be tested,
it's a relatively new feature, so we need to check that L2 actually uses it.

KVM also has its own way of TLB flushing paravirtualization, which can in theory interfere with this.


It's also nice to run a hyperv enabled Windows as KVM guest, and run a guest in it (can be Windows or Linux or anything else)
Such guest will run two L2 VMs, Windows itself and the VM you run inside.


You can also try other L1s, like VirtualBox, VMware, running in Windows or Linux L1,
and themselves can run a windows or Linux L2. 

You can also test other OSes like BSD* and such as L1, they might have a different TLB access pattern and
might reveal something, who knows. These can also run L2s using their own hypervisors.

Running a very old (say Windows XP, or some very old Linux) as L2 might also reveal something.

(But don't try to run win95/98 - this OS is known to not flush TLB properly (it doesn't use INVLPG when it should),
so it doesn't work well on AMD at all because of this).

Finally, it might be worth it to develop a TLB stress test if one doesn't exist yet.

Best regards,
   Maxim Levitsky


> 
> > TLB management can be very tricky, so I can't be 100% sure that I haven't missed something.
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Thanks!
> 



