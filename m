Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761D36E822F
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 21:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjDST4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 15:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjDST4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 15:56:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B280CE77
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 12:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681934163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o3ee2UOmXmTnns8+N/DwF+uPlnF+rDLjncVrgdCTyGQ=;
        b=IKa8VyYAb2hU+STgv6cN3nEDHcWIohMEejNp3RXb4VZrkdvwbi70d+/rEssBqvsfZVNK5S
        pOc7ltzxt1SZBR0J0KiAZNdVagwLfGSr3B0qOJ17mZY0GLGB3fam9Ki735h/oBzIfotVlG
        p7M47MWjTVyzoAxmbyqxPOicNopE8dI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-0RckfFqRPP-44zzswbV4AA-1; Wed, 19 Apr 2023 15:56:02 -0400
X-MC-Unique: 0RckfFqRPP-44zzswbV4AA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ed767b30easo266381cf.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 12:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681934162; x=1684526162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3ee2UOmXmTnns8+N/DwF+uPlnF+rDLjncVrgdCTyGQ=;
        b=dGqg9EXw0K5Nwngxki2t4Ve3+AVblpP01JB5VfV7yOF7Mh/avXaOSg1SiM9gIEvp4R
         QidVGAZ+4yHD01Dn+46Purlpf7pKTV4ZcadqTM/8hgtI1q/gG35eoFLREZAY81OQu/It
         LsC4eUf/Y8MEr1RihlDY8NP9IG0tB/323as7rh8FAXVGZ/K8wEwUAU0X9tOPsewUCUGW
         SdghYipGTOOvacf9Ek41wEXDVEUdsiJUlFrHptDDt+zlksivbkN2f8B7MehqVVguD4mZ
         roP4w/llpYUb1bewuC9fNeZik9sHQdvjLUD2wE4bEEE5VRr2lhQ2644z7UeK5y/+SeWf
         6rcg==
X-Gm-Message-State: AAQBX9cTbcq2hRcMZaCR0Tx9U0LpUVnMYmYr0x5YjdUURYrt4L6v/DHb
        SUG+OabJUlANEAt1C2+Psf+yEWG0pbkNydT7LbnrmSPGd1B24zjecBGxdaXH345lM45R/1T4SkK
        c+paqc2+p1ED0
X-Received: by 2002:a05:622a:1a9b:b0:3ea:ef5:5b8c with SMTP id s27-20020a05622a1a9b00b003ea0ef55b8cmr31879232qtc.3.1681934161887;
        Wed, 19 Apr 2023 12:56:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350bm8Jhe6jHZDmUB9HAUPG210Lksz3mgG4SE50D2FR1z8lHa8fCITv7WyHX4P5OzneuRCtvbjQ==
X-Received: by 2002:a05:622a:1a9b:b0:3ea:ef5:5b8c with SMTP id s27-20020a05622a1a9b00b003ea0ef55b8cmr31879193qtc.3.1681934161528;
        Wed, 19 Apr 2023 12:56:01 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id e7-20020ac84e47000000b003e3860f12f7sm822636qtw.56.2023.04.19.12.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 12:56:00 -0700 (PDT)
Date:   Wed, 19 Apr 2023 15:55:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZEBHTw3+DcAnPc37@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Anish,

On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> KVM's demand paging self test is extended to demonstrate the performance
> benefits of using the two new capabilities to bypass the userfaultfd
> wait queue. The performance samples below (rates in thousands of
> pages/s, n = 5), were generated using [2] on an x86 machine with 256
> cores.
> 
> vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
> 1       150     340
> 2       191     477
> 4       210     809
> 8       155     1239
> 16      130     1595
> 32      108     2299
> 64      86      3482
> 128     62      4134
> 256     36      4012

The number looks very promising.  Though..

> 
> [1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
> [2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
>     A quick rundown of the new flags (also detailed in later commits)
>         -a registers all of guest memory to a single uffd.

... this is the worst case scenario.  I'd say it's slightly unfair to
compare by first introducing a bottleneck then compare with it. :)

Jokes aside: I'd think it'll make more sense if such a performance solution
will be measured on real systems showing real benefits, because so far it's
still not convincing enough if it's only with the test especially with only
one uffd.

I don't remember whether I used to discuss this with James before, but..

I know that having multiple uffds in productions also means scattered guest
memory and scattered VMAs all over the place.  However split the guest
large mem into at least a few (or even tens of) VMAs may still be something
worth trying?  Do you think that'll already solve some of the contentions
on userfaultfd, either on the queue or else?

With a bunch of VMAs and userfaultfds (paired with uffd fault handler
threads, totally separate uffd queues), I'd expect to some extend other
things can pop up already, e.g., the network bandwidth, without teaching
each vcpu thread to report uffd faults themselves.

These are my pure imaginations though, I think that's also why it'll be
great if such a solution can be tested more or less on a real migration
scenario to show its real benefits.

Thanks,

-- 
Peter Xu

