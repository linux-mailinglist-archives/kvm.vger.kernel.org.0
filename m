Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5FF4FFB34
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 18:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiDMQ1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 12:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiDMQ10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 12:27:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CE274EDDF
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649867101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RgEcoM6U2AWPf465Xahivshzo2kZbOX7C4c0ahKp1Dw=;
        b=Eplmut0vF4DlV6c+zkqOtHlqzpvGJ3v8k5+lbRl4yV4OIA9iFxRyXwgYXzb6KlsVO9QzW3
        nl7HxNwJgX3oOvsp23Un2bK8WEuOBeDieMudWOsbppTnuMOa3/mJXAO8o3AjJSCeWGDNZi
        qjYkdrvIe6mRigEbiz/xC4dFVOxgsL0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-VBM-uKC2Pw2UIUmweqPlKA-1; Wed, 13 Apr 2022 12:25:00 -0400
X-MC-Unique: VBM-uKC2Pw2UIUmweqPlKA-1
Received: by mail-wm1-f70.google.com with SMTP id c125-20020a1c3583000000b0038e3f6e871aso1087299wma.8
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:24:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=RgEcoM6U2AWPf465Xahivshzo2kZbOX7C4c0ahKp1Dw=;
        b=47acDLRZDUV0Y0LWSh7/PUeXkeSaviQw8el8JPJs+/W/+wpw1+gJeXvFSGItDwEvt6
         KgGPS3mqgrsRuWqM8nHHEh3eGgXbncjj6PCMBYhTOw/NJc3USqVFmX626lbmR/z2HmJq
         olupx/HOl0Yi8f5892tQaxn8ZAXUjbvWYPvj0JG4g2jYAUUGuwdhxtvXQ4RCIMhft4th
         Ny1TcHtRNjMsyqBjtCg0qZNx1m0bfuqcFvWFSdcBdIyRGcqbKipKF5mH7c4vyRTCLPNX
         fLrlx2wQOiUpdWI22avUzoKFIXiYQWdRDDYYeEF0Yo7aKActbOzt625RkBNaia+zd6aa
         lBnw==
X-Gm-Message-State: AOAM530wLXOksJgK8u8NhdaeVBURGoYKUct86OTMNwlBb/h9beTt3OD7
        AjDhfZxLdRG7vEyzYxPCKL9+R+Mbq0X9tI6h3uNi5CSvppdCOIFIcuByDqM+oU+DQ4YqGtfLF5K
        7MtrWHV9T8IQ1
X-Received: by 2002:a05:600c:3c8f:b0:38e:4e47:3e95 with SMTP id bg15-20020a05600c3c8f00b0038e4e473e95mr9076144wmb.173.1649867098878;
        Wed, 13 Apr 2022 09:24:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwylTIzzqJtz5EFX+MPmIPe9ZuRAk8yMJ3/juBgt0JzCyKFOBhzlfQN6ejdx28PKvB0mUKO0g==
X-Received: by 2002:a05:600c:3c8f:b0:38e:4e47:3e95 with SMTP id bg15-20020a05600c3c8f00b0038e4e473e95mr9076112wmb.173.1649867098647;
        Wed, 13 Apr 2022 09:24:58 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:5800:1078:ebb9:e2c3:ea8c? (p200300cbc70458001078ebb9e2c3ea8c.dip0.t-ipconnect.de. [2003:cb:c704:5800:1078:ebb9:e2c3:ea8c])
        by smtp.gmail.com with ESMTPSA id n7-20020a5d5987000000b00207891050d4sm16274621wri.46.2022.04.13.09.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 09:24:58 -0700 (PDT)
Message-ID: <1686fd2d-d9c3-ec12-32df-8c4c5ae26b08@redhat.com>
Date:   Wed, 13 Apr 2022 18:24:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v5 04/13] mm/shmem: Restrict MFD_INACCESSIBLE memory
 against RLIMIT_MEMLOCK
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>
References: <20220310140911.50924-1-chao.p.peng@linux.intel.com>
 <20220310140911.50924-5-chao.p.peng@linux.intel.com>
 <Yk8L0CwKpTrv3Rg3@google.com>
 <02e18c90-196e-409e-b2ac-822aceea8891@www.fastmail.com>
 <YlB3Z8fqJ+67a2Ck@google.com>
 <7ab689e7-e04d-5693-f899-d2d785b09892@redhat.com>
 <20220412143636.GG64706@ziepe.ca>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220412143636.GG64706@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.04.22 16:36, Jason Gunthorpe wrote:
> On Fri, Apr 08, 2022 at 08:54:02PM +0200, David Hildenbrand wrote:
> 
>> RLIMIT_MEMLOCK was the obvious candidate, but as we discovered int he
>> past already with secretmem, it's not 100% that good of a fit (unmovable
>> is worth than mlocked). But it gets the job done for now at least.
> 
> No, it doesn't. There are too many different interpretations how
> MELOCK is supposed to work
> 
> eg VFIO accounts per-process so hostile users can just fork to go past
> it.
> 
> RDMA is per-process but uses a different counter, so you can double up
> 
> iouring is per-user and users a 3rd counter, so it can triple up on
> the above two

Thanks for that summary, very helpful.

> 
>> So I'm open for alternative to limit the amount of unmovable memory we
>> might allocate for user space, and then we could convert seretmem as well.
> 
> I think it has to be cgroup based considering where we are now :\

Most probably. I think the important lessons we learned are that

* mlocked != unmovable.
* RLIMIT_MEMLOCK should most probably never have been abused for
  unmovable memory (especially, long-term pinning)


-- 
Thanks,

David / dhildenb

