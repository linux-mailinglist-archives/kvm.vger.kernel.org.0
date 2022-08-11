Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4F758F7E3
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 08:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiHKGsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 02:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiHKGsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 02:48:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79F0B8B9BD
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 23:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660200521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UUY4oNhCDV5ex2akqHR3TnYfzZigpKeeFYzIPsZyWj4=;
        b=UBVCJUdzQ5XczPb3GYggZUAblyoWjQP7GR+c2l+nAybW5cSb7JOWfHwyEZso3qp81DW42n
        C3JxJilORPohndvNSxnPlgLo15ikhtqNJqf/nquFUAcwuXl1Gl5SWvWWLvDioHTK8tAutn
        9TXFMY96TUmJoeXSM4QGs2iNlT1+KQw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-340--VGGZvUbPQe9omxotlHwkA-1; Thu, 11 Aug 2022 02:48:31 -0400
X-MC-Unique: -VGGZvUbPQe9omxotlHwkA-1
Received: by mail-ed1-f72.google.com with SMTP id z3-20020a056402274300b0043d4da3b4b5so10273459edd.12
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 23:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=UUY4oNhCDV5ex2akqHR3TnYfzZigpKeeFYzIPsZyWj4=;
        b=cpx8LMYb9RBLLNaRq2Ega5UmdEyoXvGzT+q8diOiXnBZoY5DVvCyO1ZC1KgDMZ8qQ0
         LAW4sIuDEUfVbXGIBVUZFcJh/qpITaGI0wgqvfsXG05nEdpL1INe+dWIppVwpo5SnoD1
         pEsoAC9lhEn9L5NrfRHo5zcp7rV2WRyiywrqJn2hxA7Y2wvgkh8N4ct2pk+hAyjiHs/H
         LT+9UAjG+JiZJhewtH1tvssMWiGpmvW1yaWdrr1XdwfqYd42POIQd3yQH1/LWYfjmD65
         oMsvSPfMnVy38/3cZ6c1LAyLpZ5f9xab1fnyxXVaAy5JJMx1UaAn0zKgdjQ97hFHZSw+
         auNg==
X-Gm-Message-State: ACgBeo0lcjeL5AAmwwKypSrU2sXgOy9nZzUEyV9tJerXOIxxbASHLuIO
        hbc8cqKhzxXJxEVpJqmoY3Kq3++EuTibJMgjrdEjJonMsGmIC3ud9EzASkzGdOXQQufAXJlD56Z
        sjufW2/wWt4RH
X-Received: by 2002:a05:6402:14b:b0:43d:a7dd:4376 with SMTP id s11-20020a056402014b00b0043da7dd4376mr29192331edu.89.1660200510619;
        Wed, 10 Aug 2022 23:48:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Ba9YTjPkLaTzT5BEMehKw/OU/+gGLQ1lTMMIGpaZjcs1rvnE8O296hVvPRv4q9RDqgjacjQ==
X-Received: by 2002:a05:6402:14b:b0:43d:a7dd:4376 with SMTP id s11-20020a056402014b00b0043da7dd4376mr29192311edu.89.1660200510368;
        Wed, 10 Aug 2022 23:48:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s19-20020a056402015300b0043af8007e7fsm8697671edu.3.2022.08.10.23.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 23:48:29 -0700 (PDT)
Message-ID: <d8704ffa-8d9e-2261-1bcf-1b402f955fad@redhat.com>
Date:   Thu, 11 Aug 2022 08:48:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Content-Language: en-US
To:     Dmytro Maluka <dmy@semihalf.com>, Marc Zyngier <maz@kernel.org>,
        eric.auger@redhat.com
Cc:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <87o7wsbngz.wl-maz@kernel.org>
 <8ff76b5e-ae28-70c8-2ec5-01662874fb15@redhat.com>
 <87r11ouu9y.wl-maz@kernel.org>
 <72e40c17-e5cd-1ffd-9a38-00b47e1cbd8e@semihalf.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <72e40c17-e5cd-1ffd-9a38-00b47e1cbd8e@semihalf.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 19:02, Dmytro Maluka wrote:
>      1. If vEOI happens for a masked vIRQ, notify resamplefd as usual,
>         but also remember this vIRQ as, let's call it, "pending oneshot".
> 
>      2. A new physical IRQ is immediately generated, so the vIRQ is
>         properly set as pending.
> 
>      3. After the vIRQ is unmasked by the guest, check and find out that
>         it is not just pending but also "pending oneshot", so don't
>         deliver it to a vCPU. Instead, immediately notify resamplefd once
>         again.
> 
> In other words, don't avoid extra physical interrupts in the host
> (rather, use those extra interrupts for properly updating the pending
> state of the vIRQ) but avoid propagating those extra interrupts to the
> guest.
> 
> Does this sound reasonable to you?

Yeah, this makes sense and it lets the resamplefd set the "pending" 
status in the vGIC.  It still has the issue that the interrupt can 
remain pending in the guest for longer than it's pending on the host, 
but that can't be fixed?

Paolo

