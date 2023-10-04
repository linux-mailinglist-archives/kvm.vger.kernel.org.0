Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34477B8076
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 15:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbjJDNPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 09:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjJDNPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 09:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1747B0
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 06:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696425266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKB87bTajQH/5HfXBd7T/7DKZGQoywxxIms8WQ1l3Bc=;
        b=Mm73j70c2Yf3f3znOhhXUmX0VAcqfT0jd++S9L4xFIMlnfgjXJ1wJUFKlr3wxyc6gpHn6x
        UBejOS2NLhZ7lSbPIi1D27XY1vL+R3eb6fL/dAXsoTOdPBkoWdl4OqtufC0Lf9uyNJar6j
        Y5w/PyotTFiejzImb6B4NVOl5omG1TY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-0Lm0O1w-M9-3f633Lirxvg-1; Wed, 04 Oct 2023 09:14:07 -0400
X-MC-Unique: 0Lm0O1w-M9-3f633Lirxvg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-993eeb3a950so177766766b.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 06:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696425245; x=1697030045;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CKB87bTajQH/5HfXBd7T/7DKZGQoywxxIms8WQ1l3Bc=;
        b=UatuNAe13ZOMG6wrfk9iPkkHCXT4+VlLcK3SS97+VtqYclVobd9scaEPTgo2d5f4Ml
         YXM27+Tjd1/QQ30+jvSa3lavIBShg70rBOIgXs4l9NtHRzQ7OMFizBDoI8oed3i1LEng
         86UvkrNR3wdW8K1c2+ejB3U0qp0MHvxg96Fw/GWjwWV85zIB20gPi6OaseMIg052ZsrU
         RsW1tN0lMhQIoADaFxrCXo9E6kkI5gktr9UpflMBct4CuE/YlVTkfbOq3lpIZNX4TACJ
         YjdFTvnov33BxuD66KZV0rJ/JxyGNEDPV+n9MfLqVJwYgryLg1AtqwNAtUwT27JyrEIq
         OwPQ==
X-Gm-Message-State: AOJu0YwUKvi24ZsNLJvCmmkNGfMW1cSu9VynkG/HrJLxLUOV8bNXUE1e
        HFBWh3D5jAmMUPBs4TTi+y/GaR/3Ka7mYceB9GSldc1mSP6nU3VHAbJ0JHdxyvy20S5pGhpGFQS
        S6CKH9LbGlJLgztVXvHZ9
X-Received: by 2002:a17:907:2cf1:b0:9ae:513d:de22 with SMTP id hz17-20020a1709072cf100b009ae513dde22mr1648387ejc.56.1696425245065;
        Wed, 04 Oct 2023 06:14:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEC30AVKWCM9IrhyyL18ynsqE9iCne0MTdbHhx8Q+RGfk5sKrumzX45E7UuQGRJoR3t6l1Fjw==
X-Received: by 2002:a17:907:2cf1:b0:9ae:513d:de22 with SMTP id hz17-20020a1709072cf100b009ae513dde22mr1648367ejc.56.1696425244676;
        Wed, 04 Oct 2023 06:14:04 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906048300b009b2ca104988sm2824343eja.98.2023.10.04.06.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 06:14:04 -0700 (PDT)
Message-ID: <1d6044e0d71cd95c477e319d7e47819eee61a8fc.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 04 Oct 2023 16:14:01 +0300
In-Reply-To: <ZRsYNnYEEaY1gMo5@google.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
         <ZRsYNnYEEaY1gMo5@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У пн, 2023-10-02 у 12:21 -0700, Sean Christopherson пише:
> On Mon, Oct 02, 2023, Maxim Levitsky wrote:
> > Hi!
> > 
> > This patch allows AVIC's ICR emulation to be optional and thus allows
> > to workaround AVIC's errata #1235 by disabling this portion of the feature.
> > 
> > This is v3 of my patch series 'AVIC bugfixes and workarounds' including
> > review feedback.
> 
> Please respond to my idea[*] instead of sending more patches. 

Hi,

For the v2 of the patch I was already on the fence if to do it this way or to refactor
the code, and back when I posted it, I decided still to avoid the refactoring.

However, your idea of rewriting this patch, while it does change less lines of code,
is even less obvious and consequently required you to write even longer comment to 
justify it which is not a good sign.

In particular I don't want someone to find out later, and in the hard way that sometimes
real physid table is accessed, and sometimes a fake copy of it is.

So I decided to fix the root cause by not reading the physid table back,
which made the code cleaner, and even with the workaround the code 
IMHO is still simpler than it was before.

About the added 'vcpu->loaded' variable, I added it also because it is something that is 
long overdue to be added, I remember that in IPIv code there was also a need for this, 
and probalby more places in KVM can be refactored to take advantage of it,
instead of various hacks.

I did adopt your idea of using 'enable_ipiv', although I am still not 100% sure that this
is more readable than 'avic_zen2_workaround'.

Best regards,
	Maxim Levitsky

>  I'm not opposed to
> a different approach, but we need to have an actual discussion around the pros and
> cons, and hopefully come to an agreement.  This cover letter doesn't even acknowledge
> that there is an alternative proposal, let alone justify why the vcpu->loaded
> approach was taken.
> 
> [*] https://lore.kernel.org/all/ZRYxPNeq1rnp-M0f@google.com
> 


