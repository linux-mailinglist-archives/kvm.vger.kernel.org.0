Return-Path: <kvm+bounces-22188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 735C493B659
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBB4A1F22E91
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8C01662E7;
	Wed, 24 Jul 2024 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MrJoRWyH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7317215FA74
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843971; cv=none; b=J/rh5zqkgMmJKr/klYhTi5vA2UPnvIcTSuYZ2BG5XWdofaINQbeLprQcbhW/F4LUJkMczwYDCn5TEQ22N2fGUO5DIfrT17gByEB+a5DHUPoCyrx3biomKCTmWaUhS2Es36W2mEJ/3Lmz630B3ATyKbBMFFr55oh7lcTNDTBYwak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843971; c=relaxed/simple;
	bh=vToUSFfuBxFDwHHbmDpLt129lVI02pWGZoeP06wz/Ts=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H57EVLGTV+HDH526/5d6CYTwINZOaWMMujE29IxnAOwz7L39esKoWmRymyT+tyRhh+87g7GGBPvpjBHIm1mmuJNXOozFh33yb97HXsThQtBljbacnf/zJqDF7DbqBZBmPPGR7w5OsZshn16/svFmio6uJGNU9Zot6XtRieEsDEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MrJoRWyH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721843968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UrO4J8+RYRKw88kJ7TpCWAFl9RA8wwB8eC8PuzRLyzw=;
	b=MrJoRWyHyUTw/+oSwimCqMPU1iZGu9ftlwmt31+F4YIQCKL8QAlrt3HsJEtG/NIYYL5umA
	/yo+DTOU3z2N0HAlrGPAt1Shb4GQ0mJKCjw1wiRbtdLmuVMm8BmK2wWnfLE4ZfbvV09d9n
	VMtR8LiRBCvI8dWOKTxRU/u7mBNVuxA=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-wAJSdmRrNtOFy3SwCdP6NQ-1; Wed, 24 Jul 2024 13:59:27 -0400
X-MC-Unique: wAJSdmRrNtOFy3SwCdP6NQ-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-822abeb17dfso14271241.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721843966; x=1722448766;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UrO4J8+RYRKw88kJ7TpCWAFl9RA8wwB8eC8PuzRLyzw=;
        b=Ua55+q5aKVb4Dp49sAGlLidCJ/PKfhlvAa31p0Ca3m00QVXyaBrli21WztILY5/DJs
         rL7JBc0pOSARukGDDDyydULarkkUgD/qrFNxM5grDHdrgckZFJI7ZdozMaCQ8uvClgkg
         zxOH4R6GvJXvXw2GUAJtGae3N18SbZi3O9+5W1WDoXdsarpzNsuMxXDeNjjoFCGUjuna
         zQpv8zrPzb4ShVRFbTBHCmJBBnCdfyc3Wxmywl4Uh+VGoy96/ZbzUtjFcQjIIFt9PrNG
         mWUt/ZuF2N9eh5a8YKwu0aTkhCgD/1dF0YExdCbzR7z2H5mK+jnvVDxoRG5ruRKx3+jz
         UQ2w==
X-Forwarded-Encrypted: i=1; AJvYcCVn5rpfzGlCnWYa5pRbN5tBi5LYF7GmQWx4aWCl01so7E1OhI3FuViC8shY1taOUfY4cL3oGSMpsF22GVbzrvBiwntb
X-Gm-Message-State: AOJu0YwGnj4ckXV6sMYe4/iIeuUiY1B/RtiCBYsWFU0AYuFdJQLJAsrX
	rb9WReNxbjm5ZHemG6QfMwR073EbezgIeBI43ZM76pYHnNrRVpLtoJ4wQi14iAtlvLQ7lGBI9y4
	nD/h8stGHpboWMfoUkD3rULOcHTbFj0kgk1RBOwM48O8I6DFTwQ==
X-Received: by 2002:a05:6122:2a13:b0:4ef:65b6:f3b5 with SMTP id 71dfb90a1353d-4f6c5c56b42mr709135e0c.10.1721843966591;
        Wed, 24 Jul 2024 10:59:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv2KFdtV00Z6o3UF9MC26wgwcqFFNRmS00b7jyX/7uEhsN3NmY4g0QuJUpa0SgnKPSCmbH1Q==
X-Received: by 2002:a05:6122:2a13:b0:4ef:65b6:f3b5 with SMTP id 71dfb90a1353d-4f6c5c56b42mr708069e0c.10.1721843943219;
        Wed, 24 Jul 2024 10:59:03 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44f9cdd4a6bsm55296631cf.97.2024.07.24.10.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:59:02 -0700 (PDT)
Message-ID: <f04b682df8f424184fc3b43ce7c8c319924b50d5.camel@redhat.com>
Subject: Re: [PATCH v2 29/49] KVM: x86: Remove unnecessary caching of KVM's
 PV CPUID base
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:59:01 -0400
In-Reply-To: <Zo2I3FChU58bX7qH@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-30-seanjc@google.com>
	 <5b747a9dacb0ead3d16c71192df8a61e8545d0e6.camel@redhat.com>
	 <Zo2I3FChU58bX7qH@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-09 at 12:00 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > Now that KVM only searches for KVM's PV CPUID base when userspace sets
> > > guest CPUID, drop the cache and simply do the search every time.
> > > 
> > > Practically speaking, this is a nop except for situations where userspace
> > > sets CPUID _after_ running the vCPU, which is anything but a hot path,
> > > e.g. QEMU does so only when hotplugging a vCPU.  And on the flip side,
> > > caching guest CPUID information, especially information that is used to
> > > query/modify _other_ CPUID state, is inherently dangerous as it's all too
> > > easy to use stale information, i.e. KVM should only cache CPUID state when
> > > the performance and/or programming benefits justify it.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> 
> ...
> 
> > > @@ -491,13 +479,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> > >  	 * whether the supplied CPUID data is equal to what's already set.
> > >  	 */
> > >  	if (kvm_vcpu_has_run(vcpu)) {
> > > -		/*
> > > -		 * Note, runtime CPUID updates may consume other CPUID-driven
> > > -		 * vCPU state, e.g. KVM or Xen CPUID bases.  Updating runtime
> > > -		 * state before full CPUID processing is functionally correct
> > > -		 * only because any change in CPUID is disallowed, i.e. using
> > > -		 * stale data is ok because KVM will reject the change.
> > > -		 */
> > Hi,
> > 
> > Any reason why this comment was removed?
> 
> Because after this patch, runtime CPUID updates no longer consume other vCPU
> state that is derived from guest CPUID.
> 
> > As I said earlier in the review.  It might make sense to replace this comment
> > with a comment reflecting on why we need to call kvm_update_cpuid_runtime,
> > that is solely to allow old == new compare to succeed.
> 
> Ya, I'll figure out a location and patch to document why KVM applies runtime
> and quirks to the CPUID before checking.
> 
> > >  		kvm_update_cpuid_runtime(vcpu);
> > >  		kvm_apply_cpuid_pv_features_quirk(vcpu);


Makes sense, thanks!

Best regards,
	Maxim Levitsky



