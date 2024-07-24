Return-Path: <kvm+bounces-22175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 088BE93B5D5
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70FC5B21BFD
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C1915FD16;
	Wed, 24 Jul 2024 17:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PgxT/nOw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9386B1BF38
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721841861; cv=none; b=i2Y79T3lDNwuAn8CrDd0nTw1eU71gtF6Z8KjiCMDEQK9kzcYyVOUBp72E9iNrgXvN96vKZHNAq+L6SFFOIEn5Dz3FVhUnL69VHjYqmdOCKS6A9yffA5wmmd8bUz6j/6SPctzgsUOhdZNWt50WnhTdr2hk16Qd0ObuwqXpmuigM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721841861; c=relaxed/simple;
	bh=vM51azXaHDNwpKJTMUM1O0vnkWBr8NPpt7jwhv8sLVw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CoLOx6lTChkfAKbGRqsCwqmGlsCZPhBQstqhano7aa9y1gJ7UxFHOm7Rs8kiYdNOz5eqqT/fco11tPh/mm5EVuRi0ooyaJP2gVfQVIn4fbw6WN6cli3v4jdeQodVBgXIL5jQyCfAvdt4P9wyBPIdNhlpgcOWQYkRe5Tc+aAcq3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PgxT/nOw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721841858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1XBGctsXc7Ftv4Y/G9exRnBNRs5AQn3Z5s5GLDiSgQ=;
	b=PgxT/nOw+92wY3iBnSySnzvckywye13LKoG93Ox1mAl40LBukUcTtprArMzJKWLxmFaKmv
	BsREp0UwfihNhPHWgjBFEF5NBg3MR253vmZubiYvzVPeqnO6u0zuKHqKxqdJ+MaFGSrye4
	/TndF87Kge6Mh9JoWTCqQ7zm0HP/hFY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-TcTtAGHCOk-U9HuUaF8niQ-1; Wed, 24 Jul 2024 13:24:17 -0400
X-MC-Unique: TcTtAGHCOk-U9HuUaF8niQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b5de421bc6so799866d6.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721841855; x=1722446655;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N1XBGctsXc7Ftv4Y/G9exRnBNRs5AQn3Z5s5GLDiSgQ=;
        b=dZb01zmxEfTf9/MlLDcseSxXzgAn/1HAIs8xJxRKyFR/sGVJky/LxlfiKFTVCcsw01
         5ZVFy9LKZMKj9XZYFbGuuoYFw1op5fkYi/QNHQq8VbOoyz/IiGl4FBUQrCvOOXoPfeW1
         KlcI6Cfd/cBqqtpIbrXK04N7ugYDD7OnhZUXCztUo5UoG5ZD6NcrCqaq5VQIwYuRtL2R
         s0GNqWxQKMp/rxIV08casugieIv7xY491QYz1wqfp0tfNp7639EdSVuDA9owVyMpLcM0
         mcYSx3BF8SNIHb8tZOnR4EPQh7C40QFQw2HduUggqq7wyBW9WKRdHFF0b6AOaBIg9RQk
         7vig==
X-Forwarded-Encrypted: i=1; AJvYcCU2Y7zrRwfDN6OaindacgUKmNCECOLeXH7fnUXmq2miLyArnIsaD/uvvbfDwBC47rVUy7JRXoT0VGi4Vx+KENkv0RTf
X-Gm-Message-State: AOJu0YxHmXD0zGPBYZ5pYGTli6Aumie5zOZql6ft/P+ZW/ZA22tWZ5YS
	Itn8uZr44rXhuMtdK/I7UWekJfhlGoeUUQgmDW3Q2f/t65SukKT1GwEr2wFJV1L/kG7Z+qnUlgZ
	XtT58F4hm95BQg2UdekLvkmIYHoPrIp54XdjriCfm3FfyGzGqKQ==
X-Received: by 2002:ad4:5961:0:b0:6b5:6a1:f89a with SMTP id 6a1803df08f44-6bb3c9ceafbmr3178876d6.2.1721841855495;
        Wed, 24 Jul 2024 10:24:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGmXNXlTT92t8xldGPMNOVL+0ETtI9lzy9JixqquimWa65CpXWnNSbeLyLRLbNjgjutsUsVg==
X-Received: by 2002:ad4:5961:0:b0:6b5:6a1:f89a with SMTP id 6a1803df08f44-6bb3c9ceafbmr3178616d6.2.1721841855162;
        Wed, 24 Jul 2024 10:24:15 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac7e5fdcsm60471456d6.50.2024.07.24.10.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:24:14 -0700 (PDT)
Message-ID: <cf24c99cfdefda7c700a6d09e86e0bdc3e562c8d.camel@redhat.com>
Subject: Re: [PATCH v2 01/49] KVM: x86: Do all post-set CPUID processing
 during vCPU creation
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:24:13 -0400
In-Reply-To: <Zow0DVn4CvIxzGYz@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-2-seanjc@google.com>
	 <62cbd606f6d636445fd1352ae196a0973c362170.camel@redhat.com>
	 <Zow0DVn4CvIxzGYz@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 11:46 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > > index 23dbb9eb277c..0a8b561b5434 100644
> > > --- a/arch/x86/kvm/cpuid.h
> > > +++ b/arch/x86/kvm/cpuid.h
> > > @@ -11,6 +11,7 @@
> > >  extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
> > >  void kvm_set_cpu_caps(void);
> > >  
> > > +void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
> > >  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
> > >  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
> > >  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index d750546ec934..7adcf56bd45d 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -12234,6 +12234,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >  	kvm_xen_init_vcpu(vcpu);
> > >  	kvm_vcpu_mtrr_init(vcpu);
> > >  	vcpu_load(vcpu);
> > > +	kvm_vcpu_after_set_cpuid(vcpu);
> > 
> > This makes me a bit nervous. At this point the vcpu->arch.cpuid_entries is
> > NULL, but so is vcpu->arch.cpuid_nent so it sort of works but is one mistake
> > away from crash.
> > 
> > Maybe we should add some protection to this, e.g empty zero cpuid or
> > something like that.
> 
> Hmm, a crash is actually a good thing.  In the post-KVM_SET_CPUID2 case, if KVM
> accessed vcpu->arch.cpuid_entries without properly consulting cpuid_nent, the
> resulting failure would be a out-of-bounds read.  Similarly, a zeroed CPUID array
> would effectiely mask any bugs.
> 
> Given that KVM heavily relies on "vcpu" to be zero-allocated, and that changing
> cpuid_nent during kvm_arch_vcpu_create() would be an extremely egregious bug,
> a crash due to a NULL-pointer dereference should never escape developer testing,
> let alone full release testing.
> 
> KVM does the "empty" array thing for IRQ routing (though in that case the array
> and the nr_entries are in a single struct), and IMO it's been a huge net negative
> because it's led to increased complexity just so that arch code can omit a NULL
> check.
> 

Makes sense, let it be.

Best regards,
	Maxim Levitsky


