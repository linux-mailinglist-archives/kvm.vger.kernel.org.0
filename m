Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428F975C521
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 12:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjGUK6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 06:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjGUK57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 06:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4033171E
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 03:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689937033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCcb9xtScqAyMOStlm7ewhQnyFA6r02pOvdu3ozJ8ms=;
        b=CfDUw4n5j9Ub8zU/uGCccEihQ3s/RFlSzrHXicFgigg9iXRpcJsjAkzayq/qzqV7eXWNbF
        TgYL2U0/RTkrjVJjgxihUYvvc8ehJ/QT0O8zUK7bCf7VwiS31imZHJUAZyB/kGNlg1HGkq
        JyrMHOhm3ERua6VGu9U+jHpmsjE6Utg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-sHL34bQzOtWj6DCiauOkaQ-1; Fri, 21 Jul 2023 06:57:11 -0400
X-MC-Unique: sHL34bQzOtWj6DCiauOkaQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-98df34aa83aso336629766b.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 03:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689937031; x=1690541831;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JCcb9xtScqAyMOStlm7ewhQnyFA6r02pOvdu3ozJ8ms=;
        b=dAnosz9hbnbwU50CXhqRQgX2oEqXVlsqgQ30FcTjRU8QDG3bVrvOEJ3cB3SLLyetwH
         OvU2JWSdeBUBE0xcVWKE2QuBE+lQ41cjrfGbTagEGxMK3emLWWQq0Urp417UpDpvtCYA
         R6jhdJ4q5Bd+ylgrI9NkSC8UR/mT7SUdO34vg7ab7SdOq3RiJ2O4T8X7Ri8PsBtYwvGB
         laiEcQzFMs16oytLpIJhne4k3INa6WNod4YZzU2ebyYuq1f32EnF1s/igiHTt+PyLJlO
         58xB1g6dtfvBVZnaaohG5Y4xqJ2HhQJQ1PgTVJscToBkoLm00OmFZSWVlNVBmC/k3gXw
         PhWw==
X-Gm-Message-State: ABy/qLYUq2RlXkZRDUlAARX/mYkPtIvetBZ+NDTXox7l5YVdN6+W7LGK
        tXOZAEeuYqVWzzJph4Y4R9DSDkrbo2xjXtUAm59FGmleY+QILynBXbB+0YJ2QZGRklWsJOOoU4l
        okamI0GyS/2qy
X-Received: by 2002:a17:907:d8a:b0:991:d414:d889 with SMTP id go10-20020a1709070d8a00b00991d414d889mr8230231ejc.15.1689937030827;
        Fri, 21 Jul 2023 03:57:10 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHG8R7IreJRTfdc0Wq/Yo7PIzOhZZy/jcnGLgxDY0N1OVv0CFUqys6sH346KYqEVj6MNTbrkQ==
X-Received: by 2002:a17:907:d8a:b0:991:d414:d889 with SMTP id go10-20020a1709070d8a00b00991d414d889mr8230204ejc.15.1689937030548;
        Fri, 21 Jul 2023 03:57:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f21-20020a170906049500b0099364d9f0e9sm2025435eja.102.2023.07.21.03.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 03:57:09 -0700 (PDT)
Message-ID: <0c033063-5d20-4522-87e2-80ad3cca3602@redhat.com>
Date:   Fri, 21 Jul 2023 12:57:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 08/29] KVM: Introduce per-page memory attributes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230718234512.1690985-1-seanjc@google.com>
 <20230718234512.1690985-9-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/23 01:44, Sean Christopherson wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> In confidential computing usages, whether a page is private or shared is
> necessary information for KVM to perform operations like page fault
> handling, page zapping etc. There are other potential use cases for
> per-page memory attributes, e.g. to make memory read-only (or no-exec,
> or exec-only, etc.) without having to modify memslots.
> 
> Introduce two ioctls (advertised by KVM_CAP_MEMORY_ATTRIBUTES) to allow
> userspace to operate on the per-page memory attributes.
>    - KVM_SET_MEMORY_ATTRIBUTES to set the per-page memory attributes to
>      a guest memory range.
>    - KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES to return the KVM supported
>      memory attributes.
> 
> Use an xarray to store the per-page attributes internally, with a naive,
> not fully optimized implementation, i.e. prioritize correctness over
> performance for the initial implementation.
> 
> Because setting memory attributes is roughly analogous to mprotect() on
> memory that is mapped into the guest, zap existing mappings prior to
> updating the memory attributes.  Opportunistically provide an arch hook
> for the post-set path (needed to complete invalidation anyways) in
> anticipation of x86 needing the hook to update metadata related to
> determining whether or not a given gfn can be backed with various sizes
> of hugepages.
> 
> It's possible that future usages may not require an invalidation, e.g.
> if KVM ends up supporting RWX protections and userspace grants _more_
> protections, but again opt for simplicity and punt optimizations to
> if/when they are needed.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/all/Y2WB48kD0J4VGynX@google.com
> Cc: Fuad Tabba <tabba@google.com>
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

