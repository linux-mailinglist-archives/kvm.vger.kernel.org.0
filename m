Return-Path: <kvm+bounces-36354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83ACEA1A492
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41CE73AC6F4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE3820F07B;
	Thu, 23 Jan 2025 12:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TsIoqCsg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9442720C492
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 12:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737636837; cv=none; b=VFsMLJDi5bxPv1tgxY3z5Wu1odQAfMBD7MzxkVc0cSlHSA4QcNLIq2O9E0OnI8p0YyZFc/T2s+iaGXIzRKUCyPtUdMGA7dykpb+m9iTm8ShEBzTcjZzJCzeDWUy5Dl6tT1riq/frDD7a3BX6/CtauNrfLMAxVDP/6yMpNAwQjgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737636837; c=relaxed/simple;
	bh=Jiz2B8VoY/wslkPn9A0AoSIAEBMVsGjU4gz0ikl+GCo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ovhMrH16EbCKGLw4gu0CcLduDtM/g+e1jJyvzPQx8a5f6dCIFRzXrq8zuLE/vP8s8/mFTRKcZV2dizyq8+SM4twQva267FfpkNco+aVxr3Y5cb+ijo3eWWtiYU305W2z5xCj6ODOqcoRMeh+oXM9IaFVfJbQOVtJAiBVVEjxgLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TsIoqCsg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737636834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6Lx9XPIMd/NDewlW4eIGmtgOgdyjfOdUOHvx5QPf8I=;
	b=TsIoqCsgglE7+xInJnNL9atxhzNaghbWaBAYS2SAp08QjajGPfE8LIctJss5RXZDgDYO20
	/0TpNLVCWppIJL1bPNPD/IdHUhVDyE/XJAf206ZWOTFHhJfNYifRrs3VBzAAc+PFjamsPe
	XW590iBY/PW2yHzCxhqSCzE/zVNqhI0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-0nW2wj4MNSuNUHBEzQdJxg-1; Thu, 23 Jan 2025 07:53:52 -0500
X-MC-Unique: 0nW2wj4MNSuNUHBEzQdJxg-1
X-Mimecast-MFC-AGG-ID: 0nW2wj4MNSuNUHBEzQdJxg
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385e1fd40acso545527f8f.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 04:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737636831; x=1738241631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6Lx9XPIMd/NDewlW4eIGmtgOgdyjfOdUOHvx5QPf8I=;
        b=w3RSYPTSG5V5EjjqBOkg6VALn0TwA8sx2e/er6kpR67bCFW67xfSawXWR30z9gQn4c
         hYVPdWiIhLOgvTnrd+BcYSp1k4qLtmlCmhh0KzEPbzyv8izXO9tZ7qwAdMbkAT1J0sCl
         kDqPygCdaAM+y0ifEPL8vWH2yG6MP4GNJDl788VMdruCegaCCdbCIhRE//RQGcreCIZn
         L9N8OA7X2x3pp0GylvmJGPEInHwkaNJ8Dqh6A2iBzSpnW5sz76+XGv88SwJj0UPWslG7
         PaNuIVjH39UFSPfbkhV/TNq9ER4UTXIOj9RhzHB+7Ofmw+QrfdLqjoRfHRt72lCar15L
         YcbA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Fye4sKlnuDb87VH5uVTjxFT3kVHs3HcyLuwr/f+EudPIepBstnb3GdP3vpi6qJZzWKc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6L1fd2JvRG8NfURDPr+/k0E3wzvT0TwjF9kJ+2y+TgcY6kQlY
	Bxti3MokCDI1uP6VJyzBhcDbVWDuLpw7CUM0SVs70rGYXwtZkg3k2THVVfrQA9vavznTlbMktBN
	9wMvVlG+m5lxnjcl0DIvHwsHzMNLx+INfHeWaaz/vjKa8q2cikA==
X-Gm-Gg: ASbGnctAaAYijKY5NUMFLvzuhlZjGyzlohV/XTGFrxWNMkMJmv0jjVwJIX8/ejOmnge
	PcDKFohL7VL4Fdry6pW9Qjp2JkTxOnVy0/GNNvX+bUvPl8sBj7YTEVkAuulhmzEhp4xsrXj3Fkf
	nj8Lq/g6dqz+oJ3rnVhJlJB1U62EBD371PbGjQmazQ3IN28MiPXX4HdDKUnIlJA54DOekc1A6sU
	1FFgsB1o1/wZSG+lxizUghLnCW2ppQzfHzM0zwinV/DJp2QgrWNzDprruNSOdyWMXadyx+NlgK9
	6yJPlAUCcrHN0yLMFn8y/hMdIl9KCH8ZP3RibqJE+A==
X-Received: by 2002:a05:6000:2a7:b0:38a:615c:8225 with SMTP id ffacd0b85a97d-38bf577ff42mr26047599f8f.15.1737636831574;
        Thu, 23 Jan 2025 04:53:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMvbIO6o+LlYetLw5pvz3tRShsz4DN1/5eyO2PVnsxorba4zPA/qyLgwjgHMso+ZxhOtCGVw==
X-Received: by 2002:a05:6000:2a7:b0:38a:615c:8225 with SMTP id ffacd0b85a97d-38bf577ff42mr26047571f8f.15.1737636831081;
        Thu, 23 Jan 2025 04:53:51 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf327e19fsm19632884f8f.93.2025.01.23.04.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 04:53:50 -0800 (PST)
Date: Thu, 23 Jan 2025 13:53:49 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Riku Voipio <riku.voipio@iki.fi>, Richard Henderson
 <richard.henderson@linaro.org>, Zhao Liu <zhao1.liu@intel.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Ani Sinha <anisinha@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck
 <cohuck@redhat.com>, "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
 <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 rick.p.edgecombe@intel.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 41/60] hw/i386: add option to forcibly report edge
 trigger in acpi tables
Message-ID: <20250123135349.3b58f67b@imammedo.users.ipa.redhat.com>
In-Reply-To: <e97102e9-9c38-46a9-912a-0ccc7753f560@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
	<20241105062408.3533704-42-xiaoyao.li@intel.com>
	<Z1tmG63P4TR0UYO8@iweiny-mobl>
	<e97102e9-9c38-46a9-912a-0ccc7753f560@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Jan 2025 21:01:27 +0800
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 12/13/2024 6:39 AM, Ira Weiny wrote:
> > On Tue, Nov 05, 2024 at 01:23:49AM -0500, Xiaoyao Li wrote:  
> >> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>
> >> When level trigger isn't supported on x86 platform,

it used to be level before this patch like for forever, so either
we have a bug or above statement isn't correct.

> >> forcibly report edge trigger in acpi tables.  
> > 
> > This commit message is pretty sparse.  I was thinking of suggesting to squash
> > this with patch 40 but it occurred to me that perhaps these are split to accept
> > TDX specifics from general functionality.  Is that the case here?  Is that true
> > with other patches in the series?  If so what other situations would require
> > this in the generic code beyond TDX?  
> 
> The goal is trying to avoid adding TDX specific all around QEMU. So we 
> are trying to add new general interface as a patch and TDX uses the 
> interface as another patch.

in other words level trigger is not supported when TDX is enable,
do I get it right?

If yes, then mention it in commit message and also mention
followup patch which would use this.

see my other comments below.
 
> 
> > Ira
> >   
> >>
> >> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> >> ---
> >>   hw/i386/acpi-build.c  | 99 ++++++++++++++++++++++++++++---------------
> >>   hw/i386/acpi-common.c | 45 +++++++++++++++-----
> >>   2 files changed, 101 insertions(+), 43 deletions(-)
> >>
> >> diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
> >> index 4967aa745902..d0a5bfc69e9a 100644
> >> --- a/hw/i386/acpi-build.c
> >> +++ b/hw/i386/acpi-build.c
> >> @@ -888,7 +888,8 @@ static void build_dbg_aml(Aml *table)
> >>       aml_append(table, scope);
> >>   }
> >>   
> >> -static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
> >> +static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg,
> >> +                           bool level_trigger_unsupported)

do not use negative naming, or even better pass AML_EDGE || AML_LEVEL as an argument here.
the same applies to other places that use level_trigger_unsupported.

> >>   {
> >>       Aml *dev;
> >>       Aml *crs;
> >> @@ -900,7 +901,10 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
> >>       aml_append(dev, aml_name_decl("_UID", aml_int(uid)));
> >>   
> >>       crs = aml_resource_template();
> >> -    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
> >> +    aml_append(crs, aml_interrupt(AML_CONSUMER,
> >> +                                  level_trigger_unsupported ?
> >> +                                  AML_EDGE : AML_LEVEL,
> >> +                                  AML_ACTIVE_HIGH,
> >>                                     AML_SHARED, irqs, ARRAY_SIZE(irqs)));
> >>       aml_append(dev, aml_name_decl("_PRS", crs));
> >>   
> >> @@ -924,7 +928,8 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
> >>       return dev;
> >>    }
> >>   
> >> -static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
> >> +static Aml *build_gsi_link_dev(const char *name, uint8_t uid,
> >> +                               uint8_t gsi, bool level_trigger_unsupported)
> >>   {
> >>       Aml *dev;
> >>       Aml *crs;
> >> @@ -937,7 +942,10 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
> >>   
> >>       crs = aml_resource_template();
> >>       irqs = gsi;
> >> -    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
> >> +    aml_append(crs, aml_interrupt(AML_CONSUMER,
> >> +                                  level_trigger_unsupported ?
> >> +                                  AML_EDGE : AML_LEVEL,
> >> +                                  AML_ACTIVE_HIGH,
> >>                                     AML_SHARED, &irqs, 1));
> >>       aml_append(dev, aml_name_decl("_PRS", crs));
> >>   
> >> @@ -956,7 +964,7 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
> >>   }
> >>   
> >>   /* _CRS method - get current settings */
> >> -static Aml *build_iqcr_method(bool is_piix4)
> >> +static Aml *build_iqcr_method(bool is_piix4, bool level_trigger_unsupported)
> >>   {
> >>       Aml *if_ctx;
> >>       uint32_t irqs;
> >> @@ -964,7 +972,9 @@ static Aml *build_iqcr_method(bool is_piix4)
> >>       Aml *crs = aml_resource_template();
> >>   
> >>       irqs = 0;
> >> -    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
> >> +    aml_append(crs, aml_interrupt(AML_CONSUMER,
> >> +                                  level_trigger_unsupported ?
> >> +                                  AML_EDGE : AML_LEVEL,
> >>                                     AML_ACTIVE_HIGH, AML_SHARED, &irqs, 1));
> >>       aml_append(method, aml_name_decl("PRR0", crs));
> >>   
> >> @@ -998,7 +1008,7 @@ static Aml *build_irq_status_method(void)
> >>       return method;
> >>   }
> >>   
> >> -static void build_piix4_pci0_int(Aml *table)
> >> +static void build_piix4_pci0_int(Aml *table, bool level_trigger_unsupported)
> >>   {
> >>       Aml *dev;
> >>       Aml *crs;
> >> @@ -1011,12 +1021,16 @@ static void build_piix4_pci0_int(Aml *table)
> >>       aml_append(sb_scope, pci0_scope);
> >>   
> >>       aml_append(sb_scope, build_irq_status_method());
> >> -    aml_append(sb_scope, build_iqcr_method(true));
> >> +    aml_append(sb_scope, build_iqcr_method(true, level_trigger_unsupported));
> >>   
> >> -    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQ0")));
> >> -    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQ1")));
> >> -    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQ2")));
> >> -    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQ3")));
> >> +    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQ0"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQ1"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQ2"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQ3"),
> >> +                                        level_trigger_unsupported));
> >>   
> >>       dev = aml_device("LNKS");
> >>       {
> >> @@ -1025,7 +1039,9 @@ static void build_piix4_pci0_int(Aml *table)

do we really need piix4 machine to work with TDX?

> >>   
> >>           crs = aml_resource_template();
> >>           irqs = 9;
> >> -        aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
> >> +        aml_append(crs, aml_interrupt(AML_CONSUMER,
> >> +                                      level_trigger_unsupported ?
> >> +                                      AML_EDGE : AML_LEVEL,
> >>                                         AML_ACTIVE_HIGH, AML_SHARED,
> >>                                         &irqs, 1));
> >>           aml_append(dev, aml_name_decl("_PRS", crs));
> >> @@ -1111,7 +1127,7 @@ static Aml *build_q35_routing_table(const char *str)
> >>       return pkg;
> >>   }
> >>   
> >> -static void build_q35_pci0_int(Aml *table)
> >> +static void build_q35_pci0_int(Aml *table, bool level_trigger_unsupported)
> >>   {
> >>       Aml *method;
> >>       Aml *sb_scope = aml_scope("_SB");
> >> @@ -1150,25 +1166,41 @@ static void build_q35_pci0_int(Aml *table)
> >>       aml_append(sb_scope, pci0_scope);
> >>   
> >>       aml_append(sb_scope, build_irq_status_method());
> >> -    aml_append(sb_scope, build_iqcr_method(false));
> >> +    aml_append(sb_scope, build_iqcr_method(false, level_trigger_unsupported));
> >>   
> >> -    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA")));
> >> -    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB")));
> >> -    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC")));
> >> -    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD")));
> >> -    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE")));
> >> -    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF")));
> >> -    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG")));
> >> -    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH")));
> >> +    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG"),
> >> +                                        level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH"),
> >> +                                        level_trigger_unsupported));
> >>   
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16));
> >> -    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16,
> >> +                                            level_trigger_unsupported));
> >> +    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17,
> >> +                                            level_trigger_unsupported));
> >>   
> >>       aml_append(table, sb_scope);
> >>   }
> >> @@ -1350,6 +1382,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
> >>       PCMachineState *pcms = PC_MACHINE(machine);
> >>       PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(machine);
> >>       X86MachineState *x86ms = X86_MACHINE(machine);
> >> +    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
> >>       AcpiMcfgInfo mcfg;
> >>       bool mcfg_valid = !!acpi_get_mcfg(&mcfg);
> >>       uint32_t nr_mem = machine->ram_slots;
> >> @@ -1382,7 +1415,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
> >>           if (pm->pcihp_bridge_en || pm->pcihp_root_en) {
> >>               build_x86_acpi_pci_hotplug(dsdt, pm->pcihp_io_base);
> >>           }
> >> -        build_piix4_pci0_int(dsdt);
> >> +        build_piix4_pci0_int(dsdt, level_trigger_unsupported);
> >>       } else if (q35) {
> >>           sb_scope = aml_scope("_SB");
> >>           dev = aml_device("PCI0");
> >> @@ -1426,7 +1459,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
> >>           if (pm->pcihp_bridge_en) {
> >>               build_x86_acpi_pci_hotplug(dsdt, pm->pcihp_io_base);
> >>           }
> >> -        build_q35_pci0_int(dsdt);
> >> +        build_q35_pci0_int(dsdt, level_trigger_unsupported);
> >>       }
> >>   
> >>       if (misc->has_hpet) {
> >> diff --git a/hw/i386/acpi-common.c b/hw/i386/acpi-common.c
> >> index 0cc2919bb851..ad38a6b31162 100644
> >> --- a/hw/i386/acpi-common.c
> >> +++ b/hw/i386/acpi-common.c
> >> @@ -103,6 +103,7 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,

MADT change should be its own patch.

> >>       const CPUArchIdList *apic_ids = mc->possible_cpu_arch_ids(MACHINE(x86ms));
> >>       AcpiTable table = { .sig = "APIC", .rev = 3, .oem_id = oem_id,
> >>                           .oem_table_id = oem_table_id };
> >> +    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
> >>   
> >>       acpi_table_begin(&table, table_data);
> >>       /* Local APIC Address */
> >> @@ -124,18 +125,42 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
> >>                        IO_APIC_SECONDARY_ADDRESS, IO_APIC_SECONDARY_IRQBASE);
> >>       }
> >>   
> >> -    if (x86mc->apic_xrupt_override) {
> >> -        build_xrupt_override(table_data, 0, 2,
> >> -            0 /* Flags: Conforms to the specifications of the bus */);
> >> -    }
> >> +    if (level_trigger_unsupported) {

maybe, try to set flags as local var first,
and then use it in build_xrupt_override() instead of rewriting/shifting
existing blocks

> >> +        /* Force edge trigger */
> >> +        if (x86mc->apic_xrupt_override) {
> >> +            build_xrupt_override(table_data, 0, 2,
> >> +                                 /* Flags: active high, edge triggered */
> >> +                                 1 | (1 << 2));
pls point to spec where it comes from


> >> +        }
> >> +
> >> +        for (i = x86mc->apic_xrupt_override ? 1 : 0; i < 16; i++) {
                                                  ^^^^^^^
before patch it was always starting from 1,
so above does come from?

> >> +            build_xrupt_override(table_data, i, i,
> >> +                                 /* Flags: active high, edge triggered */
> >> +                                 1 | (1 << 2));
> >> +        }

> >> +        if (x86ms->ioapic2) {
> >> +            for (i = 0; i < 16; i++) {
> >> +                build_xrupt_override(table_data, IO_APIC_SECONDARY_IRQBASE + i,
> >> +                                     IO_APIC_SECONDARY_IRQBASE + i,
> >> +                                     /* Flags: active high, edge triggered */
> >> +                                     1 | (1 << 2));
> >> +            }
> >> +        }
and this is absolutely new hunk, perhaps its own patch with explanation why it's need

> >> +    } else {
> >> +        if (x86mc->apic_xrupt_override) {
> >> +            build_xrupt_override(table_data, 0, 2,
> >> +                    0 /* Flags: Conforms to the specifications of the bus */);
> >> +        }
> >>   
> >> -    for (i = 1; i < 16; i++) {
> >> -        if (!(x86ms->pci_irq_mask & (1 << i))) {
> >> -            /* No need for a INT source override structure. */
> >> -            continue;
> >> +        for (i = 1; i < 16; i++) {
> >> +            if (!(x86ms->pci_irq_mask & (1 << i))) {
> >> +                /* No need for a INT source override structure. */
> >> +                continue;
> >> +            }
> >> +            build_xrupt_override(table_data, i, i,
> >> +                0xd /* Flags: Active high, Level Triggered */);
> >>           }
> >> -        build_xrupt_override(table_data, i, i,
> >> -            0xd /* Flags: Active high, Level Triggered */);
> >>       }
> >>   
> >>       if (x2apic_mode) {
> >> -- 
> >> 2.34.1
> >>  
> 


