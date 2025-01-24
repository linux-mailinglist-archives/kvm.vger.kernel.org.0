Return-Path: <kvm+bounces-36483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C813A1B688
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1DD9188C899
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B5BCA64;
	Fri, 24 Jan 2025 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dm7svzSD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EE2469D
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737723667; cv=none; b=aaplJsxQOwLF6FDIogmumlnMJnLhzt+sWbxwjCjjzK61PxTOdbCcmxvxgBju/BCJkB2wPhwf6n//QJYEmwNx2LWX0YUw+RMv46FWN/K4ZNUUrHGdezQvWuIcGfoyso3VqlWoa1G+jYCC++PJ+yf/HAO5PNs/aX0QFU1QKmit9zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737723667; c=relaxed/simple;
	bh=ytHUKIyDOnoanzkVw/aUXbzRjP3StW9mVmdnaMlh4rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XosqcXwlhYp47LIW5YbGmH2WQulbnMMw/ba19Tbcee5RKzrvDMYXKTFsYFBuzk1LNbhWetp0pp0BLxv5cjluwuCQGVau9tvxfHJSI3/iLyL4pK3lNCN5FhZPG1IpTIg21+ieqKkaW0bJJs0wj01/dbh8aqWMuBMpf0dfdCOzPNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dm7svzSD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737723664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qhEWVaxKeikmxtBJ5SO9zg19epngSbsvs/Gow7w7f8I=;
	b=dm7svzSD5eKW7dV9V2nVXIyTrWOZSsMBrTgQHcHfV3y4ydtE8XTCPG78dN34UL4zCahAYc
	ip4sO3PBFnrgi9tdMIkzQ5rbJpkl8MMnyY/BwINL35JJtAaclwtRhdI6JxyVbuzmaATZpU
	BmyoZ255JZ/YNuEknif8Y2+qx4XwVLA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-yAiQ_LMgPLq4Y_SFvfhVFQ-1; Fri, 24 Jan 2025 08:01:01 -0500
X-MC-Unique: yAiQ_LMgPLq4Y_SFvfhVFQ-1
X-Mimecast-MFC-AGG-ID: yAiQ_LMgPLq4Y_SFvfhVFQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385d6ee042eso1547459f8f.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 05:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737723659; x=1738328459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qhEWVaxKeikmxtBJ5SO9zg19epngSbsvs/Gow7w7f8I=;
        b=uiqJaZiPQW+hYXwFVVNEEfXFzsqNOo8bDZb1xKBIJS1xYVNHp99zokB+89Udhhxa2z
         qcDjNkoACrulnHgb80KHgR4Bk6SCiZk787dH5K7XTqJwhnijwQNIgA63EQnX4J0LZkEF
         QcVh4nJs6LjpdGEbpg5YX3hif9e7xtvUmoRZd3ehKRwk7BA/DdAX772YTPugExnezhLy
         Q8AXug6xfjWaDwHvwAnbNPdtq5x2HuRkBQDA/A1bK/oQPdQWA7vWxafRwzdaPpUXwNx2
         3pD/KSncOv2zBaxPYtmxR6OgLeh6gruPCTSYq4gCHCpFIs2tbZqItXv5KGUT03tM84jN
         CHAw==
X-Forwarded-Encrypted: i=1; AJvYcCVqFZwZBLoZYKUM0eUk/0pckCF7GUKqClbh2b1tFnXQnIyLSnV/jkx0w/ebWdqlMmBFixo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxczQoDnG1/sBZFAYMjiHileEj6UF70lX+LQFcrPZy1M+zyWKRr
	Dw7J3//c/K67vtNswkeYAbw9q52MVHU/2MloBjc4GRg5jWhqbCPMZ0JWvilhUVCgjo57e7VM0M4
	OO6ydA+Wv5FcyB09TIE9QADg6SZaWp5ebdrXGxS+DNnUJOz4keg==
X-Gm-Gg: ASbGncsBpBwjdyhg0/vV+XTsnSNUv/qRBoJ5NRRkSbroNwuleT17sRsPXror+yfZKVW
	5Yf9b7WJpZ4Xb6Q4x2XjvOxwAKYpMi9pJJFBYrt5SBDwu3ufubCOiioNPd9sEvnIZyRIDjgI3X+
	XVngJx6QbsaBeYkhMctHvi5EzqhJCHHOvGwn0o532bOjmifjxr9UdSiK+VtgfCcC3uJ1fYAAZhm
	DVAq6D0GtL6aNxCW+EuTKo9SZxBeBCi9mddrj8r4uH+ZtOSieDGYXTtvu9aDhOtgqmPXxXWL/++
	mjSJAMvaqEfcMntaQAiQhladV6SZf/Z2x6WRyai4Qw==
X-Received: by 2002:a05:6000:1f85:b0:385:e374:be1 with SMTP id ffacd0b85a97d-38bf5662b18mr28603912f8f.13.1737723659234;
        Fri, 24 Jan 2025 05:00:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNdnSYVkLN0W7EV86sq4qrC5JldVfmcOMcj0YhiKmcOETN+KR3k8MwLJ3VyzAMUkpiTfPPDw==
X-Received: by 2002:a05:6000:1f85:b0:385:e374:be1 with SMTP id ffacd0b85a97d-38bf5662b18mr28603828f8f.13.1737723658728;
        Fri, 24 Jan 2025 05:00:58 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c4161sm2566964f8f.88.2025.01.24.05.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 05:00:58 -0800 (PST)
Date: Fri, 24 Jan 2025 14:00:57 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>, Zhao Liu
 <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Ani Sinha <anisinha@redhat.com>,
 Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Yanan Wang
 <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>, "Daniel P.
 =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>, Eric Blake
 <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, rick.p.edgecombe@intel.com, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH v6 40/60] hw/i386: add eoi_intercept_unsupported member
 to X86MachineState
Message-ID: <20250124140057.2f2bb674@imammedo.users.ipa.redhat.com>
In-Reply-To: <00ecb103-2f0b-479d-bae8-cb3f7bace3be@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
	<20241105062408.3533704-41-xiaoyao.li@intel.com>
	<20250123134148.036d52b0@imammedo.users.ipa.redhat.com>
	<00ecb103-2f0b-479d-bae8-cb3f7bace3be@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jan 2025 00:45:50 +0800
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 1/23/2025 8:41 PM, Igor Mammedov wrote:
> > On Tue,  5 Nov 2024 01:23:48 -0500
> > Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >   
> >> Add a new bool member, eoi_intercept_unsupported, to X86MachineState
> >> with default value false. Set true for TDX VM.  
> > 
> > I'd rename it to enable_eoi_intercept, by default set to true for evrything
> > and make TDX override this to false.  
> >>
> >> Inability to intercept eoi causes impossibility to emulate level
> >> triggered interrupt to be re-injected when level is still kept active.
> >> which affects interrupt controller emulation.
> >>
> >> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> >> ---
> >>   hw/i386/x86.c         | 1 +
> >>   include/hw/i386/x86.h | 1 +
> >>   target/i386/kvm/tdx.c | 2 ++
> >>   3 files changed, 4 insertions(+)
> >>
> >> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> >> index 01fc5e656272..82faeed24ff9 100644
> >> --- a/hw/i386/x86.c
> >> +++ b/hw/i386/x86.c
> >> @@ -370,6 +370,7 @@ static void x86_machine_initfn(Object *obj)
> >>       x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
> >>       x86ms->bus_lock_ratelimit = 0;
> >>       x86ms->above_4g_mem_start = 4 * GiB;
> >> +    x86ms->eoi_intercept_unsupported = false;
> >>   }
> >>   
> >>   static void x86_machine_class_init(ObjectClass *oc, void *data)
> >> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
> >> index d43cb3908e65..fd9a30391755 100644
> >> --- a/include/hw/i386/x86.h
> >> +++ b/include/hw/i386/x86.h
> >> @@ -73,6 +73,7 @@ struct X86MachineState {
> >>       uint64_t above_4g_mem_start;
> >>   
> >>       /* CPU and apic information: */
> >> +    bool eoi_intercept_unsupported;
> >>       unsigned pci_irq_mask;
> >>       unsigned apic_id_limit;
> >>       uint16_t boot_cpus;
> >> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> >> index 9ab4e911f78a..9dcb77e011bd 100644
> >> --- a/target/i386/kvm/tdx.c
> >> +++ b/target/i386/kvm/tdx.c
> >> @@ -388,6 +388,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> >>           return -EOPNOTSUPP;
> >>       }
> >>   
> >> +    x86ms->eoi_intercept_unsupported = true;  
> > 
> > I don't particulary like accel go to its parent (machine) object and override things there
> > and that being buried deep inside.  
> 
> I would suggest don't see TDX as accel but see it as a special type of 
> x86 machine.
> 
> > How do you start TDX guest?
> > Is there a machine property or something like it to enable TDX?  
> 
> via the "confidential-guest-support" property.
> This series introduces tdx-guest object and we start a TDX guest by:
> 
> $qemu-system-x86_64 -object tdx-guest,id=tdx0 \
>      -machine ...,confidential-guest-support=tdx0

then the property setter would be a logical place to set
 eoi_intercept_unsupported = false
when its value is tdx0

> 
> >> +
> >>       /*
> >>        * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
> >>        * memory for shared memory but not for private memory. Besides, whether a  
> >   
> 


