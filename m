Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7656A03EC
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 09:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjBWIfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 03:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBWIfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 03:35:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983D44DBE0
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 00:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677141193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pb7w4ZwmllJKAxdvXoWC2qlcadJkuk1d2W5cm7uRXhs=;
        b=KFvmTHR8wQgEmpimpqPvCpOFqWwlE9KZSGFw0RIriAkTAV1kRsR54bdsUP7YlENfaRckZU
        YxocFOMdmrwI7U17iCoHbqtg0JFHBWAXhEiABM5OO8RT2G9onMAUi1QITWVKreC5ftTEo0
        LtkxBvbJRbFnKbhvDObahwr2K42MmCw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-101-tFhk-WxQN8uyXBVhIQRPkg-1; Thu, 23 Feb 2023 03:33:11 -0500
X-MC-Unique: tFhk-WxQN8uyXBVhIQRPkg-1
Received: by mail-wr1-f71.google.com with SMTP id r3-20020a5d6c63000000b002bff57fc7fcso2253905wrz.19
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 00:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pb7w4ZwmllJKAxdvXoWC2qlcadJkuk1d2W5cm7uRXhs=;
        b=Avn61PsEBFkZLKyOVEKa1zzyCpUioYfKnVh8HyjbM0j0zoxgL8CVSBlyBKveQMHQPB
         1gqbjUWZwU86VSN/qrbojfGntGjVqq/EluZUyZmKiNGhjZwAHcJ6H1eBUKVEddedu8xc
         AiTWVlSLI+s90ZUAIuj3OMlw4/UR/d8R3HtHgGCrjQGAcCXnbnZRkfJOx1mQ65P6tK7I
         agbMljEGiw9+V5BlBCuyR1I5jNxkA/iYpV0todULyKo3ec+I+yu5e9NEfmVeKBVbpWu6
         X9fAiUySfg1F5Wv1okn952OEskP6qV95gIi1zBTbibQjK5tiogKqHcUmA7aza0nredQk
         XMEQ==
X-Gm-Message-State: AO0yUKU4CUMeAckGNw0aZE0fdDaHKEuzbimK2+znFge1FIgsfUjzzeJC
        5yP+SW3sAxRlPTpATXUE1UwH8/3rMdbVW99n0qmqf5to+FJ2XCcRcH6x7bMkyvnl6DaN9pb/9IR
        hQe15AfjXalvj
X-Received: by 2002:a05:600c:30ca:b0:3dc:2af8:83c0 with SMTP id h10-20020a05600c30ca00b003dc2af883c0mr2283475wmn.31.1677141190726;
        Thu, 23 Feb 2023 00:33:10 -0800 (PST)
X-Google-Smtp-Source: AK7set8/exPXYpvKkvDp6cpXvZsIC9vGGhoQN2dLEUnoPfBZuj4eAL8aTXYmGKtnim/iTbvzOclz9Q==
X-Received: by 2002:a05:600c:30ca:b0:3dc:2af8:83c0 with SMTP id h10-20020a05600c30ca00b003dc2af883c0mr2283459wmn.31.1677141190392;
        Thu, 23 Feb 2023 00:33:10 -0800 (PST)
Received: from starship ([89.237.96.70])
        by smtp.gmail.com with ESMTPSA id k18-20020a05600c409200b003db06224953sm11465807wmh.41.2023.02.23.00.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 00:33:09 -0800 (PST)
Message-ID: <092591cbcc40fbbcc42abd3f603b6d782f411770.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Daniel P. Berrange" <berrange@redhat.com>
Date:   Thu, 23 Feb 2023 10:33:08 +0200
In-Reply-To: <05144c6d-922c-e70d-e625-c60952b60f3c@redhat.com>
References: <20220926165112.603078-1-pbonzini@redhat.com>
         <YzMt24/14n1BVdnI@google.com>
         <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
         <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
         <YzRycXDnWgMDgbD7@google.com>
         <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
         <YzSKhUEg3L1eMKOR@google.com>
         <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
         <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com>
         <06d04f32-8403-4d7f-76a1-11a7fac3078e@redhat.com>
         <Y/aWx4EiDzKW6RHe@google.com>
         <05144c6d-922c-e70d-e625-c60952b60f3c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-23 at 08:01 +0100, Thomas Huth wrote:
> On 22/02/2023 23.27, Sean Christopherson wrote:
> > On Fri, Feb 17, 2023, Thomas Huth wrote:
> > > On 29/09/2022 15.52, Maxim Levitsky wrote:
> > > > On Thu, 2022-09-29 at 15:26 +0200, Paolo Bonzini wrote:
> > > > > On 9/28/22 19:55, Sean Christopherson wrote:
> > > > > > > As far as my opinion goes I do volunteer to test this code more often,
> > > > > > > and I do not want to see the 32 bit KVM support be removed*yet*.
> > > > > > 
> > > > > > Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
> > > > > > coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
> > > > > > BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?
> > > > > 
> > > > > Yeah, maybe EXPERT is better but I'm not sure of the equivalent test
> > > > > coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but
> > > > > what's wrong with booting an older guest?
> > > > >  From my point of view, using the same kernel source for host and the guest
> > > > is easier because you know that both kernels behave the same.
> > > > 
> > > > About EXPERT, IMHO these days most distros already dropped 32 bit suport thus anyway
> > > > one needs to compile a recent 32 bit kernel manually - thus IMHO whoever
> > > > these days compiles a 32 bit kernel, knows what they are doing.
> > > > 
> > > > I personally would wait few more releases when there is a pressing reason to remove
> > > > this support.
> > > 
> > > FWIW, from the QEMU perspective, it would be very helpful to remove 32-bit
> > > KVM support from the kernel. The QEMU project currently struggles badly with
> > > keeping everything tested in the CI in a reasonable amount of time. The
> > > 32-bit KVM kernel support is the only reason to keep the qemu-system-i386
> > > binary around - everything else can be covered with the qemu-system-x86_64
> > > binary that is a superset of the -i386 variant (except for the KVM part as
> > > far as I know).
> > > Sure, we could also drop qemu-system-i386 from the CI without dropping the
> > > 32-bit KVM code in the kernel, but I guess things will rather bitrot there
> > > even faster in that case, so I'd appreciate if the kernel could drop the
> > > 32-bit in the near future, too.
> > 
> > Ya, I would happily drop support for 32-bit kernels today, the only sticking point
> > is the lack of 32-bit shadow paging test coverage, which unfortunately is a rather
> > large point.  :-(
> 
>  From your point of view, would it be OK if QEMU dropped qemu-system-i386? 
> I.e. would it be fine to use older versions of QEMU only for that test 
> coverage (or do you even use a different userspace for testing that)?
> 
>   Thomas
> 

From my point of view qemu-system-x86_64 does run 32 bit guests just fine.

The only exception that I know is that gdbstub is somewhat broken, but that can be probably
fixed.


Best regards,
	Maxim Levitsky

