Return-Path: <kvm+bounces-26343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D42E89743EC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F41A287A73
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32ADD1A7ADF;
	Tue, 10 Sep 2024 20:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yfuz2oxt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21AF17DFE1
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999194; cv=none; b=LZXtbazvww1pP9BvVYIvaMxxPSYg5B9Et5+l2NudnS/+Z1Y6clckPelauYO88XcAMr1C3X7HhpAt4tb+0jHhlILapHGSKFdnC13eWrg2+CMKiAx8skO/5w0hvC5zingl0dyn+t4LyfG3W+oDnocm7chivfQX1AoW6yrIewMzxys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999194; c=relaxed/simple;
	bh=SmGdKsMeARzok6Efk7DiO3PzMavjkZ1CyBtvfmmY88o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VCjRVEtFpx0HVLQHU09DqdLmVrkLGxKi1oiBgxQivzJm8I5bvGrBJeoPNsnFpAu9eFv7OJ4XfrhcC29+6Ghl2aPt/05eMp7EffxYalm6gfhfN7nPJm1zUGEMr0SNwh0TqzHhY2kzf2ddYGnr9lRP3T0WLbkWPbi+MK3vl9lDCVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yfuz2oxt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725999191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDtYyQHUbQoxUf9RtgQfhLfnKwLGRhZtyaZbqqn8Z/0=;
	b=Yfuz2oxtv0Qoq3sfZB7SDw0hhB9Qs289SXaKKbdzzCtNz7p6xZ/hb2poiy7fuVHstj5yRG
	vDqD7oCMmWvmko3q+RPaOAnQdQPptiN9gzTTU4dHECFhloc/+VXn8ujF2KJViKt9dJPQ2i
	z/7yAdC9gFiS5mwUgWS2QWLfKDdHVEQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-5MQ1ducBNdGEsBTTZzdc5Q-1; Tue, 10 Sep 2024 16:13:10 -0400
X-MC-Unique: 5MQ1ducBNdGEsBTTZzdc5Q-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6c358223647so80807256d6.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725999189; x=1726603989;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nDtYyQHUbQoxUf9RtgQfhLfnKwLGRhZtyaZbqqn8Z/0=;
        b=FGwm4Ix5CHwmJNskBpm6WBd7Y8h4gZIbLKLvUPgat6R+T4rdXH8429jBviKiGTxH10
         Y3BBhmwSQsL2wVZ3lXwk039uC1YhvsVvtSdiUtBfzn8nAU3M+C68+4ldtn+B4q4DsS1B
         hKH/PYnPakb02i5NmiHG7piXNWgB4hLt2BfJ6xIVyrrdq8bgsH4ZDIVdWb5Lz6PI+/Wt
         jqgL2vmUFGad489dm6gCum7CPTVbM8Sxg+yxYQ+W+931fW/Vjby8KtyAXL41jDFEG0Kb
         KKrlro9MQBMvbNi3RbM4+U/VwEe6Du9hL+d5TBXjuIBkig5LtRtjaGqY98D5zIkmYBmf
         vzgQ==
X-Gm-Message-State: AOJu0YzpyrvJP63wv5dUmYcNIvN+MdGk2zvSPs51IBFlDh82tzCrMTZ8
	nl3kzwhjfd2JIZV/CNVZx+UoIZ0Qh1+r0sfXIYBlnlNJySAouC6ROSSXAhYlspCa9Q2zKVxO54g
	HCiYWhkMHSKZ3Dd1ib8j/3LI9NTduQTEJPQ6s/hrZxbsL4yeNZg==
X-Received: by 2002:a05:6214:4345:b0:6c5:52cb:eb77 with SMTP id 6a1803df08f44-6c552cbed7emr83953186d6.2.1725999189590;
        Tue, 10 Sep 2024 13:13:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsa80Vfsj+4PZuSTXsmrgG/jjhTRObLUykG/vdN5JeOTBK1I0ZLARmLG+r7hRF7RzLsA44+g==
X-Received: by 2002:a05:6214:4345:b0:6c5:52cb:eb77 with SMTP id 6a1803df08f44-6c552cbed7emr83952686d6.2.1725999189045;
        Tue, 10 Sep 2024 13:13:09 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534774303sm33189216d6.111.2024.09.10.13.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 13:13:08 -0700 (PDT)
Message-ID: <e5218efaceec20920166bd907416d6f88905558d.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, 
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Ingo Molnar
 <mingo@redhat.com>,  "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner
 <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>,  Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 10 Sep 2024 16:13:07 -0400
In-Reply-To: <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
	 <ZRsYNnYEEaY1gMo5@google.com>
	 <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2023-10-04 at 16:14 +0300, Maxim Levitsky wrote:
> У пн, 2023-10-02 у 12:21 -0700, Sean Christopherson пише:
> > On Mon, Oct 02, 2023, Maxim Levitsky wrote:
> > > Hi!
> > > 
> > > This patch allows AVIC's ICR emulation to be optional and thus allows
> > > to workaround AVIC's errata #1235 by disabling this portion of the feature.
> > > 
> > > This is v3 of my patch series 'AVIC bugfixes and workarounds' including
> > > review feedback.
> > 
> > Please respond to my idea[*] instead of sending more patches. 
> 
> Hi,
> 
> For the v2 of the patch I was already on the fence if to do it this way or to refactor
> the code, and back when I posted it, I decided still to avoid the refactoring.
> 
> However, your idea of rewriting this patch, while it does change less lines of code,
> is even less obvious and consequently required you to write even longer comment to 
> justify it which is not a good sign.
> 
> In particular I don't want someone to find out later, and in the hard way that sometimes
> real physid table is accessed, and sometimes a fake copy of it is.
> 
> So I decided to fix the root cause by not reading the physid table back,
> which made the code cleaner, and even with the workaround the code 
> IMHO is still simpler than it was before.
> 
> About the added 'vcpu->loaded' variable, I added it also because it is something that is 
> long overdue to be added, I remember that in IPIv code there was also a need for this, 
> and probalby more places in KVM can be refactored to take advantage of it,
> instead of various hacks.
> 
> I did adopt your idea of using 'enable_ipiv', although I am still not 100% sure that this
> is more readable than 'avic_zen2_workaround'.

Hi!

Sean, can you take another look at this patch series?

Thanks in advance,
	Maxim Levitsky

> 
> Best regards,
> 	Maxim Levitsky
> 
> >  I'm not opposed to
> > a different approach, but we need to have an actual discussion around the pros and
> > cons, and hopefully come to an agreement.  This cover letter doesn't even acknowledge
> > that there is an alternative proposal, let alone justify why the vcpu->loaded
> > approach was taken.
> > 
> > [*] https://lore.kernel.org/all/ZRYxPNeq1rnp-M0f@google.com
> > 
> 
> 



