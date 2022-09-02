Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F345AAA02
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 10:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiIBIcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 04:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiIBIcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 04:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC97C0E66
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 01:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662107531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gVEKJqfyqM62jNy2YKZYtKZ/hwivLO59J+dFY7QJczE=;
        b=ePAaKG68CO/vTcpHYZErniRHZDGJUNmolcO12HtPAudbDqZxH6Jmib9Kk5Qt8D6mKolNpP
        2gom4PMiLTemaUQcF+Mgw3ubVbR0D8OdpI455UwaAERqfB9Cjufo/gtltqoU7E2cYCPCid
        tSAND5TuxKKlLahOsiGyjleJvKQUCUE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-257-EWMRZFC-PbGC9VDj9o2KhA-1; Fri, 02 Sep 2022 04:32:04 -0400
X-MC-Unique: EWMRZFC-PbGC9VDj9o2KhA-1
Received: by mail-wr1-f72.google.com with SMTP id r20-20020adfb1d4000000b002258c581ba2so142484wra.1
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 01:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=gVEKJqfyqM62jNy2YKZYtKZ/hwivLO59J+dFY7QJczE=;
        b=WZWYwVAlkLm5FSjeFmIitfqVp4dXBnDZAgTk0wwatJ5PAkV/07AL03VvtZF7OOg/RV
         WR0KRxEwZ5yR39lK8H8CdvfHm4yPSyO5OKNB4R+onZnm4RqSah+lmXyh/SkY7HTz4XlQ
         n/XRbnuOJkxvLNgY2pCDXjlhbnCnsknyl8Op0evnhN1w5fPXl7HIHGjp7jtdw7EBpZaW
         PRAjIe+dkoVzuihok0uKG3JMKuu+pWzDfdOd0vwVSG3TG3i8lkl1rR1Euf9kSaiQksY1
         TIqRzSocF89P4TW/fUHxR2/DtBFV0IeXe9NYCWG2mZK2JoNtWdB23tph9SITxJahMYxi
         Wowg==
X-Gm-Message-State: ACgBeo2b0hRj5hbGarbW7hGSR5wNOOz/uubrgFryj77eU/4RT2sUcDE4
        dmunQM4c1t5X2XUBHOAS3oCEbYj2SyqNyBkCqiArYn5MTh5jbDozXVCajjj3q4SjxxqglpzN8rD
        uWDw69ApWUxBU
X-Received: by 2002:a5d:698e:0:b0:225:72d1:94c with SMTP id g14-20020a5d698e000000b0022572d1094cmr16086322wru.381.1662107523258;
        Fri, 02 Sep 2022 01:32:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5cFRb/7wBrcvC2/EphgIHs2moSm/UDzURbuodmKzpv+CYxxWeH1D9/0odvgXjQ2vg0XprTkg==
X-Received: by 2002:a5d:698e:0:b0:225:72d1:94c with SMTP id g14-20020a5d698e000000b0022572d1094cmr16086302wru.381.1662107522919;
        Fri, 02 Sep 2022 01:32:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:4800:2077:1bf6:40e7:2833? (p200300cbc714480020771bf640e72833.dip0.t-ipconnect.de. [2003:cb:c714:4800:2077:1bf6:40e7:2833])
        by smtp.gmail.com with ESMTPSA id z10-20020adfdf8a000000b002255eebf785sm921167wrl.89.2022.09.02.01.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 01:32:02 -0700 (PDT)
Message-ID: <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
Date:   Fri, 2 Sep 2022 10:32:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
In-Reply-To: <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.09.22 10:24, Tian, Kevin wrote:
> Hi, Alex,
> 
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Tuesday, August 30, 2022 11:06 AM
>>
>> There's currently a reference count leak on the zero page.  We increment
>> the reference via pin_user_pages_remote(), but the page is later handled
>> as an invalid/reserved page, therefore it's not accounted against the
>> user and not unpinned by our put_pfn().
>>
>> Introducing special zero page handling in put_pfn() would resolve the
>> leak, but without accounting of the zero page, a single user could
>> still create enough mappings to generate a reference count overflow.
>>
>> The zero page is always resident, so for our purposes there's no reason
>> to keep it pinned.  Therefore, add a loop to walk pages returned from
>> pin_user_pages_remote() and unpin any zero pages.
>>
> 
> We found an interesting issue on zero page and wonder whether we
> should instead find a way to not use zero page in vfio pinning path.
> 
> The observation - the 'pc.bios' region (0xfffc0000) is always mapped
> RO to zero page in the IOMMU page table even after the mapping in
> the CPU page table has been changed after Qemu loads the guest
> bios image into that region (which is mmap'ed as RW).
> 
> In reality this may not cause real problem as I don't expect any sane
> usage would want to DMA read from the bios region. This is probably
> the reason why nobody ever notes it.
> 
> But in concept it is incorrect.
> 
> Fixing Qemu to update/setup the VFIO mapping after loading the bios
> image could mitigate this problem. But we never document such ABI
> restriction on RO mappings and in concept the pinning semantics
> should apply to all paths (RO in DMA and RW in CPU) which the
> application uses to access the pinned memory hence the sequence
> shouldn't matter from user p.o.v
> 
> And old Qemu/VMM still have this issue.
> 
> Having a notifier to implicitly fix the IOMMU mapping within the
> kernel violates the semantics of pinning, and makes vfio page
> accounting even more tricky.
> 
> So I wonder instead of continuing to fix trickiness around the zero
> page whether it is a better idea to pursue allocating a normal
> page from the beginning for pinned RO mappings?

That's precisely what I am working. For example, that's required to get
rid of FOLL_FORCE|FOLL_WRITE for taking a R/O pin as done by RDMA:

See
https://lore.kernel.org/all/5593cbb7-eb29-82f0-490e-dd72ceafff9b@redhat.com/
for some more details.


The concerns I discussed with Peter and Alex offline for VFIO is that we
might end up charging more anon pages with that change to the MEMLOCK
limit of the user and might degrade existing setups.

I do wonder if that's a real issue, though. One approach would be to
warn the VFIO users and allow for slightly exceeding the MEMLOCK limit
for a while. Of course, that only works if we assume that such pinned
zeropages are only extremely rarely longterm-pinned for a single VM
instance by VFIO.

-- 
Thanks,

David / dhildenb

