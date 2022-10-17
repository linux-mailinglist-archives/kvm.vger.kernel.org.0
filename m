Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9C601D96
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 01:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiJQXcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 19:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiJQXcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 19:32:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0286FA39
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 16:32:16 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso15706956pjf.2
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yiFrNuPRLUt6X6xjKV68iAAf2ofz98aq5uXkbPkmdVk=;
        b=eT3nz9X6K4lR28izSZqgJLzSis/D5+BWPs1OkKQffM8Wy32Rm9GqE2SOwSMPx04Cfr
         OMWNKwL0D8G3pxScE3+PGWFfsT3zOh+BqzjBtvO7EEzy5RFMDRVpg8XgWSndERImRzzu
         vAvuBeZgTD9Xfqmv7dh3BB4iYCzbXeiOcBklgM9VG5nQilAZdRxOsaZojDOXksxYyEw9
         +e52fzM+t+ipCJ2Te/D2uf7AUaYDY9Sne7nvrR757h8hvFmSnXV77N/B5k1RSkYKVcLP
         00Mmhjn8/Dd0lznVbkTJaZJZsmM/hdSDugo6JEY2h3efQc65xD2HiMYC0a3shGPvSHZt
         nznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiFrNuPRLUt6X6xjKV68iAAf2ofz98aq5uXkbPkmdVk=;
        b=xZuySfFSD1pgWIAzAZpAVbnXFNRaCKhZvI2sV9k+E6RDvzvPh+oRZg8TY0H0XrFZpO
         iDwgwTSr4H3mjaMnFf7u2v9CJzUthaHyhOTCtqK43hVmuJZI8e5yhp6EJcJNbriuG+1i
         CFy29sgIiAKKfKXwfpbx3RpcBD8H363GhHoQdEUKHMqtS+KmvEEJ6zId7yKl51JEUpWB
         27k74MMaEp3xQgtfoeBdmSVLU0jJCXtQNGB0F7B25LsYYzTeDLXPA6KU8IA0DF5+MHQf
         lgBRjMfeqdIpUqUaPXrNGLXnZQY1pKgKwZ+OK80GTs35yWV+gqIP+y4uWFszRnhqZ5s6
         2Txg==
X-Gm-Message-State: ACrzQf0wh3sr6pmOrJhypTsuKv4N+Ay8lDGXRsH6jrBTp3DiyRh2BxgW
        wZdws7fvWwIpdqNpZVGgcn2J/w==
X-Google-Smtp-Source: AMsMyM7KQ54TM4Kkd7qdZQ0Pj4PW+GQXkGsSErIdlOIyRTcsTKekXEdVRC4SMmndV5RcbZYqd4SEFA==
X-Received: by 2002:a17:902:bd47:b0:17f:685b:27ee with SMTP id b7-20020a170902bd4700b0017f685b27eemr87911plx.22.1666049535619;
        Mon, 17 Oct 2022 16:32:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g186-20020a6252c3000000b0055f98a2c64bsm7948994pfb.142.2022.10.17.16.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 16:32:14 -0700 (PDT)
Date:   Mon, 17 Oct 2022 23:32:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
        shuah@kernel.org, oliver.upton@linux.dev, peterx@redhat.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y03l+kwGxNW1Icp/@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
 <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
 <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022, Gavin Shan wrote:
> On 10/18/22 6:56 AM, Maciej S. Szmigiero wrote:
> > On 18.10.2022 00:51, Gavin Shan wrote:
> > > On 10/18/22 6:08 AM, Sean Christopherson wrote:
> > > > On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > > > > > +#define MEM_EXTRA_SIZE        0x10000
> > > > > 
> > > > > Also, an expression like "(64 << 10)" is more readable than a "1"
> > > > > with a tail of zeroes (it's easy to add one zero too many or be one
> > > > > zero short).
> > > > 
> > > > +1 to not open coding raw numbers.
> > > > 
> > > > I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
> > > > 16KB, 64K, 2MB, 1GB, etc...
> > > > 
> > > > Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
> > > > math off of those.
> > > > 
> > > 
> > > Ok. I will have one separate patch to define those sizes in kvm_util_base.h,
> > > right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me know
> > > if it looks good to you?
> > > 
> > >      #define KB         (1UL << 10)
> > >      #define MB         (1UL << 20)
> > >      #define GB         (1UL << 30)
> > >      #define TB         (1UL << 40)

Any objection to prefixing these with SIZE_ as well?  IMO it's worth burning the
extra five characters to make it all but impossible to misinterpret code.

> > >      /* Base page and huge page size */
> > >      #define SIZE_4KB   (  4 * KB)
> > >      #define SIZE_16KB  ( 16 * KB)
> > >      #define SIZE_64KB  ( 64 * KB)
> > >      #define SIZE_2MB   (  2 * MB)
> > >      #define SIZE_32MB  ( 32 * MB)
> > >      #define SIZE_512MB (512 * MB)
> > >      #define SIZE_1GB   (  1 * GB)
> > >      #define SIZE_16GB  ( 16 * GB)
> > 
> > FYI, QEMU uses KiB, MiB, GiB, etc., see [1].
> > 
> 
> Right. I checked QEMU's definitions and it makes sense to use
> KiB, MiB, GiB, TiB. I don't think we need PiB and EiB because
> our tests don't use that large memory.

Ha!  I had typed out KiB, etc... but then thought, "nah, I'm being silly".  KiB
and friends work for me.
