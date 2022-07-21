Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F026157C7EF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiGUJoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiGUJoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:44:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C173D81497
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658396657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DO1aaB3+Ryi/v9YoRM2rpcbD7ftKevyNrI/tAjdvyKQ=;
        b=eYfKWylvfuGeSN7Esr1yNZ75LDhs1vWK9VCZ6plw6mWmextrYI0r64QOl+pyK7skVNNWCP
        zV2aWD9EJ28x9lpv8matsqwKSMHjpfflUdnffjIg2v4HcCKDbzKn32HTB57C18BS/yDSc7
        +I0GLSOs6RJiRPMaSVZ4clcHVPwY4LE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-lxZf60OmO4mvTZ00oAT4WA-1; Thu, 21 Jul 2022 05:44:16 -0400
X-MC-Unique: lxZf60OmO4mvTZ00oAT4WA-1
Received: by mail-wm1-f71.google.com with SMTP id h65-20020a1c2144000000b003a30cae106cso2556839wmh.8
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 02:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=DO1aaB3+Ryi/v9YoRM2rpcbD7ftKevyNrI/tAjdvyKQ=;
        b=2KhGIRHsNI66fEbS5U0Yeruq8szRM6df13mM6ztFAaHPCHLlRlVnZPq8UBfgrG13Ru
         UvIdhBEYhVi3b96hH6clxh7kH9WS3Gbry+2yL3tjQ+h8HGNuqQ+ngEUU+B5cTCOfJBAL
         cXuuOSKzfzXYGmV/ycMSKn5qeJ4ElCBJ1VDou0HkEqEGl62IiVWN9OblosaDsgRg5nU+
         hvby/mEsyedmxM+Lzt84PS6j4zrHPkELq7l3C3VPPWWRwJ1MpGYLnk8VDCpfNIWwVLE8
         FPXJsSBX4nxkLTn8uN3KVl/R3sWd01ZIOj58vLqq2Pd5GcKRuoc4Mp4iVmiZGlIWS/FL
         I1Mw==
X-Gm-Message-State: AJIora9qq7HfsgXNp+q8KQBBvMAGXj279ELb7bx/B5QXVb7mth83r32Y
        TEE9kXxy3oS2jyOMzLbnGoPv7RxXECvhahHMo5QbBN8VVQB1e3NugFoar+q7dvUq7rGaC5NzmP0
        YynP0EfQ97I2i
X-Received: by 2002:adf:f70c:0:b0:21e:492c:34ae with SMTP id r12-20020adff70c000000b0021e492c34aemr5793528wrp.482.1658396655094;
        Thu, 21 Jul 2022 02:44:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sVdrY1ryXQTKjciP6+YD6dSto/SyNrNllZQ6zlLoQwsdperSLs8uCpuTc1KPqklo41+2oqvA==
X-Received: by 2002:adf:f70c:0:b0:21e:492c:34ae with SMTP id r12-20020adff70c000000b0021e492c34aemr5793481wrp.482.1658396654459;
        Thu, 21 Jul 2022 02:44:14 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:e000:25d3:15fa:4c8b:7e8d? (p200300cbc707e00025d315fa4c8b7e8d.dip0.t-ipconnect.de. [2003:cb:c707:e000:25d3:15fa:4c8b:7e8d])
        by smtp.gmail.com with ESMTPSA id b18-20020adff912000000b0021d65675583sm1340859wrr.52.2022.07.21.02.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:44:13 -0700 (PDT)
Message-ID: <f39c4f63-a511-4beb-b3a4-66589ddb5475@redhat.com>
Date:   Thu, 21 Jul 2022 11:44:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 01/14] mm: Add F_SEAL_AUTO_ALLOCATE seal to memfd
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>
References: <20220706082016.2603916-1-chao.p.peng@linux.intel.com>
 <20220706082016.2603916-2-chao.p.peng@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220706082016.2603916-2-chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.07.22 10:20, Chao Peng wrote:
> Normally, a write to unallocated space of a file or the hole of a sparse
> file automatically causes space allocation, for memfd, this equals to
> memory allocation. This new seal prevents such automatically allocating,
> either this is from a direct write() or a write on the previously
> mmap-ed area. The seal does not prevent fallocate() so an explicit
> fallocate() can still cause allocating and can be used to reserve
> memory.
> 
> This is used to prevent unintentional allocation from userspace on a
> stray or careless write and any intentional allocation should use an
> explicit fallocate(). One of the main usecases is to avoid memory double
> allocation for confidential computing usage where we use two memfds to
> back guest memory and at a single point only one memfd is alive and we
> want to prevent memory allocation for the other memfd which may have
> been mmap-ed previously. More discussion can be found at:
> 
>   https://lkml.org/lkml/2022/6/14/1255
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> ---
>  include/uapi/linux/fcntl.h |  1 +
>  mm/memfd.c                 |  3 ++-
>  mm/shmem.c                 | 16 ++++++++++++++--
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index 2f86b2ad6d7e..98bdabc8e309 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -43,6 +43,7 @@
>  #define F_SEAL_GROW	0x0004	/* prevent file from growing */
>  #define F_SEAL_WRITE	0x0008	/* prevent writes */
>  #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
> +#define F_SEAL_AUTO_ALLOCATE	0x0020  /* prevent allocation for writes */

Why only "on writes" and not "on reads". IIRC, shmem doesn't support the
shared zeropage, so you'll simply allocate a new page via read() or on
read faults.


Also, I *think* you can place pages via userfaultfd into shmem. Not sure
if that would count "auto alloc", but it would certainly bypass fallocate().

-- 
Thanks,

David / dhildenb

