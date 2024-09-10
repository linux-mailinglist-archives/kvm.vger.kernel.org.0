Return-Path: <kvm+bounces-26348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 427FB974436
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFF421F25BC2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39711AB530;
	Tue, 10 Sep 2024 20:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3Q5nrco"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761491A7AF6
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726000925; cv=none; b=ZGZt34y/cLyXXM9Msoy7J32ECGsCFSyhRDsZDZoGXRSZW2C/R83KPYr9Uv7Fu9uIDJmeWzWOOq1kOxeahV5KxDqEduegzZR4rAEpO9rm8GygD3tKg0k7Cq1nCmq3T508Y0FTN5UPYYoYQEsilwwq2+8HBAkpxAWSbvpJn2trvJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726000925; c=relaxed/simple;
	bh=/B6ktjls9e8sahrf4f9YjYTnkS2AyJU2YCdJDde3Pcw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J1s+HRp7cPeABvwk5HR0zapgNDSXwokjpl00iFCSfpu+Va/tHZponV1B4m4z73k9zxARYtglJ8vN8bjObneVs4bZ8GqEDjtj0QEutHNALesutqR52cWe3hiQdwca3lwpfwKurFobYJmrgbXEcJcrIvp03h9gyFQQzZKk7Q+icIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3Q5nrco; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726000921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXWc8YwViA5zWo54WjIEfGW+8+5CIqabuJJ/r7VO3GE=;
	b=T3Q5nrcooMM1ZL+n0wtIUqQLFNVhcGZrKQhR4gXScw7d58K8w9dkGwM/Z6d9lU42aKfVWv
	FtVlLjGINfA35YGdAlVCffvjVDR5jJpij2a+wx4p4p7X/W31kgtt/bI31FMg/KwA/glFy9
	UPtHiiXfO+KGTapMH8vfCeWhgEugMes=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-mMY63KMVMy-bbJ4EYw6A3g-1; Tue, 10 Sep 2024 16:42:00 -0400
X-MC-Unique: mMY63KMVMy-bbJ4EYw6A3g-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4582a549257so28767451cf.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726000919; x=1726605719;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXWc8YwViA5zWo54WjIEfGW+8+5CIqabuJJ/r7VO3GE=;
        b=MHvvrLE1DcCW0hMbFJKcYoMVkc4CCpFkzpeej04lZH8DoKSI4CLZyk9Y7BU5NFlyKa
         JlVEsBC52Dc4czjfcE5xuGpjeAkZC+F6LGaWUQ+G5SJxjcu29Q65CcnbvvjAWPBkewq4
         8VBuORlnE6orP6Bew4BINAIpBoI9RzjMf9TfspEKTt4o5TObpiQWePO0EPC8WtMoT8Wp
         pgB3dLUEfTfvYn/+RtqJIZEqFFs0+pW182GJneFrxEFaU/SUTY0ituIvAN1HoKNftCm6
         AKRcT/0OqOToma8OCzmD6msszRqCHcdTt5bkTcLJXRRIZsqT6yLFj9LXZ/J2CXcMH+RN
         hLyA==
X-Forwarded-Encrypted: i=1; AJvYcCU+eFAGX/AAqsMZyW9fapZhWxY8uDoympp2ng0PWPL4EKoPPdlFOadErTCp2pW9dz64f5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YygnhZwSoAexgwa+jMgMVMU1y/cPbbdQVvOWQIyAe7B1n7QcfEd
	xQi3525bTXlK8dq6K4Ia6/F4igqElyOQULcnN8441dDZp7nJFHFPi5GSrEj4oXzzFwnOTD16ajZ
	0fKB7GubTCw5ObTH0tqCgY3mQTQwYcVCgvHQMqDeWpVQWrv3wSg==
X-Received: by 2002:a05:622a:18a2:b0:458:2c40:e08b with SMTP id d75a77b69052e-4584e90021bmr10728021cf.30.1726000919653;
        Tue, 10 Sep 2024 13:41:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6g4A4JvYd5H/gkbWbjJoXbDr6NCaKNFVqZ4P3NxyUw79k0kFE23eV1CPcOhxAh3JabLXj7g==
X-Received: by 2002:a05:622a:18a2:b0:458:2c40:e08b with SMTP id d75a77b69052e-4584e90021bmr10727791cf.30.1726000919292;
        Tue, 10 Sep 2024 13:41:59 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4583636e38esm17482701cf.33.2024.09.10.13.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 13:41:58 -0700 (PDT)
Message-ID: <b9cf0083783b32fd92edb4805a20a843a09af6fc.camel@redhat.com>
Subject: Re: [PATCH v2 44/49] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Tue, 10 Sep 2024 16:41:57 -0400
In-Reply-To: <ZoyDTJ3nb_MQ38nW@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-45-seanjc@google.com>
	 <2d554577722d30605ecd0f920f4777129fff3951.camel@redhat.com>
	 <ZoyDTJ3nb_MQ38nW@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 17:24 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> > > -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > > +		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSPKE,
> > > +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> > > +
> > >  
> > >  	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
> > >  	if (best)
> > 
> > I am not 100% sure that we need to do this.
> > 
> > Runtime cpuid changes are a hack that Intel did back then, due to various
> > reasons, These changes don't really change the feature set that CPU supports,
> > but merly as you like to say 'massage' the output of the CPUID instruction to
> > make the unmodified OS happy usually.
> > 
> > Thus it feels to me that CPU caps should not include the dynamic features,
> > and neither KVM should use the value of these as a source for truth, but
> > rather the underlying source of the truth (e.g CR4).
> > 
> > But if you insist, I don't really have a very strong reason to object this.
> 
> FWIW, I think I agree that CR4 should be the source of truth, but it's largely a
> moot point because KVM doesn't actually check OSXSAVE or OSPKE, as KVM never
> emulates the relevant instructions.  So for those, it's indeed not strictly
> necessary.
> 
> Unfortunately, KVM has established ABI for checking X86_FEATURE_MWAIT when
> "emulating" MONITOR and MWAIT, i.e. KVM can't use vcpu->arch.ia32_misc_enable_msr
> as the source of truth.

Can you elaborate on this? Can you give me an example of the ABI?


>   So for MWAIT, KVM does need to update CPU caps (or carry
> even more awful MWAIT code), at which point extending the behavior to the CR4
> features (and to X86_FEATURE_APIC) is practically free.
> 


Best regards,
	Maxim Levitsky


