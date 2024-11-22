Return-Path: <kvm+bounces-32334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EAB39D587B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 04:18:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77ED92840FD
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 03:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797091531DC;
	Fri, 22 Nov 2024 03:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ehfod1JM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE2523098F
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 03:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732245484; cv=none; b=ILphcTQg6VgQhhDAPG1pogO9JZ6IUq3HUQ5bPf+Ov7Mn8GoWkmOD1FXhXMxxVeN+4ClVD/k/A60RBrxMUv0trcbHB18jOGX/j+j4hxTJXnRAmbd+7b9NkC7Nq40JbgpE+SHoOV+6wRsNA6BjHtuYMNMxl+eB011SSzF70lomMV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732245484; c=relaxed/simple;
	bh=c4xG9vuacevZNTMZpGFx+lbBp97ksMAHfmqZHanuPWI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rEZiyVXKzmSvPn9/G3pLu6vEqMUJ95s/RvS2MjQcXYiWF0fRiclYwnpGx3CzYiX9cMREHhcAEXCtyjjFYkkwIjPw9UM8dLHLO2xxajxv5PoLw10dQdE0cDyfHPQSik+ZXph51jMoqX+83rJH8DlBEJ+77qIvslNXysH3xH4/E2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ehfod1JM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732245481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJopdvGtdSHSgdTNgTCjjcQqxbc7Sde9lChDv4fkdrM=;
	b=Ehfod1JMJY92K4ge53Xq+pzOco3EOaQYPjxaqR85UdgChopZJyMvaj+/fz352CkL5dWLzj
	h5fxI7WxKq+dVuUfPHJlZuE3hv/L6JVZh6QjewGI3cbRlY80jK9Zx0itrZXdyZF3+Uu800
	/GdX/hhTgeDEy3SLZm7veObzD5WOOJg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-_5mLAR3CMoKclpIuDaOKEg-1; Thu, 21 Nov 2024 22:17:59 -0500
X-MC-Unique: _5mLAR3CMoKclpIuDaOKEg-1
X-Mimecast-MFC-AGG-ID: _5mLAR3CMoKclpIuDaOKEg
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7b1581d41dcso187033585a.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 19:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732245479; x=1732850279;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oJopdvGtdSHSgdTNgTCjjcQqxbc7Sde9lChDv4fkdrM=;
        b=nIpfwvkAShSVWEWbbuAP01acKIR4AYv3tjpb34s/TnZBo79zWqa5k/YR4i2p7k5CBx
         NqXseuij34tgK2ddaw1RgT7Z+EGVliFAyk8EcROU5Zy9JIa8PI+sQzZsFNFh4FLzFa9l
         EimMX1QEguWTjp88DUFPlJRVtIHwkLYAkz1ZeZksybYkJTvinuHqlnKtes+b6HrN9jsg
         18+9css2w1s/On0F5fwQ2o69TJpln9fABSgvmdc36FZ0nMgMSrAAcQxD/p3KpgTvQRPO
         BuAYgfyOmDOl09k4dhrWzq+4sN2jtTEbQHaU9L9xG09zsHJ0eDa7vV9jvAgXsvE5htI3
         Mikw==
X-Forwarded-Encrypted: i=1; AJvYcCXftVptz8dFo2KKkIqIypCyVcf7c1KrAcm66TVEL4+7jq1oO1/G2l7D0lIjRvfwck8krjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHQWui7ne7fkHkDLRwjzdRKUgBWPM2VbfMms1mrMBhe53O05Vt
	qh92aaIIVLCu/DpPaPHttsdnoeElKLPLsT/hbwfL9DcerFgwrK+ihHYj0p81YOzR0vt65HwN/Tk
	hC0h0cqBoeZ1YPUyLCBApLRot/bCoIjrU1xtgbcjBXtEI7P8i3Q==
X-Gm-Gg: ASbGnctGDBm21y6JygvhnBEcYbQCvklTapFJyakTnUsUJfEN7ORCdTihKhC9dhp5xH5
	wD73Cg9OMkrh0v6MKEA6xC+LJqzWqDBuIMe3JRsaWBRp5uwV22mJWvuo6juPQz3AuCY+328rU+B
	tNgN+C90A20ju+0dxi/y43ax1bE8d2mfv9EfyXcR6j+FsIJb8SgEdwA9ZHEmawxfZPqcQZ+nrjW
	1IFH0OCcjilu6SQIrq8W/+OTH2U2jlG8G5RDLDHtnGAXNPdKA==
X-Received: by 2002:a05:620a:2604:b0:7b1:5763:4ba5 with SMTP id af79cd13be357-7b5146048c8mr166800985a.51.1732245479077;
        Thu, 21 Nov 2024 19:17:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEch9B3bdAsLQHyb1TbdZGO2HoTk/rwHkhUPDcurD/9bYYvKyc/41ocDo++gxOxEBl6N7HFAA==
X-Received: by 2002:a05:620a:2604:b0:7b1:5763:4ba5 with SMTP id af79cd13be357-7b5146048c8mr166798785a.51.1732245478742;
        Thu, 21 Nov 2024 19:17:58 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b513f90428sm45462385a.17.2024.11.21.19.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 19:17:58 -0800 (PST)
Message-ID: <cbcb80ee5be13d78390ff6f4a1a3c58fc849e311.camel@redhat.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 21 Nov 2024 22:17:57 -0500
In-Reply-To: <ZuG5ULBjfQ3hv_Jb@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-23-seanjc@google.com>
	 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
	 <ZoxVa55MIbAz-WnM@google.com>
	 <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
	 <ZqKb_JJlUED5JUHP@google.com>
	 <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
	 <ZrFLlxvUs86nqDqG@google.com>
	 <44e7f9cba483bda99f8ddc0a2ad41d69687e1dbe.camel@redhat.com>
	 <ZuG5ULBjfQ3hv_Jb@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-09-11 at 08:37 -0700, Sean Christopherson wrote:
> On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> > On Mon, 2024-08-05 at 15:00 -0700, Sean Christopherson wrote:
> > > If we go with ALIASED_F() (or ALIASED_8000_0001_F()), then that macro is all that
> > > is needed, and it's bulletproof.  E.g. there is no KVM_X86_FEATURE_FPU_ALIAS that
> > > can be queried, and thus no need to be ensure it's defined in cpuid.c and #undef'd
> > > after its use.
> > > 
> > > Hmm, I supposed we could harden the aliased feature usage in the same way as the
> > > ALIASED_F(), e.g.
> > > 
> > >   #define __X86_FEATURE_8000_0001_ALIAS(feature)				\
> > >   ({										\
> > > 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> > > 	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
> > > 	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32);			\
> > >   })
> > > 
> > > If something tries to use an X86_FEATURE_*_ALIAS outside if kvm_cpu_cap_init(),
> > > it would need to define and set kvm_cpu_cap_init_in_progress, i.e. would really
> > > have to try to mess up.
> > > 
> > > Effectively the only differences are that KVM would have ~10 or so more lines of
> > > code to define the X86_FEATURE_*_ALIAS macros, and that the usage would look like:
> > > 
> > > 	VIRTUALIZED_F(FPU_ALIAS)
> > > 
> > > versus
> > > 
> > > 	ALIASED_F(FPU)
> > 
> > This is exactly my point. I want to avoid profiliation of the _F macros, because
> > later, we will need to figure out what each of them (e.g ALIASED_F) does.
> > 
> > A whole leaf alias, is once in x86 arch life misfeature, and it is very likely that
> > Intel/AMD won't add more such aliases.
> > 
> > Why VIRTUALIZED_F though, it wasn't in the patch series? Normal F() should be enough
> > IMHO.
> 
> I'm a-ok with F(), I simply thought there was a desire for more verbosity across
> the board.
> 
> > > At that point, I'm ok with defining each alias, though I honestly still don't
> > > understand the motivation for defining single-use macros.
> > > 
> > 
> > The idea is that nobody will need to look at these macros
> > (e.g__X86_FEATURE_8000_0001_ALIAS() and its usages), because it's clear what
> > they do, they just define few extra CPUID features that nobody really cares
> > about.
> > 
> > ALIASED_F() on the other hand is yet another _F macro() and we will need,
> > once again and again to figure out why it is there, what it does, etc.
> 
> That seems easily solved by naming the macro ALIASED_8000_0001_F().  I don't see
> how that's any less clear than __X86_FEATURE_8000_0001_ALIAS(), and as above,
> there are several advantages to defining the alias in the context of the leaf
> builder.
> 

Hi!

I am stating my point again: Treating 8000_0001 leaf aliases as regular CPUID features means that
we don't need common code to deal with this, and thus when someone reads the common code
(and this is the thing I care about the most) that someone won't need to dig up the info
about what these aliases are. 

I for example didn't knew about them because these aliases are basically a result of AMD redoing 
some things in the spec their way when they just released first 64-bit extensions.
I didn't follow the x86 ISA closely back then (I only had 32 bit systems to play with).

Best regards,
	Maxim Levitsky



