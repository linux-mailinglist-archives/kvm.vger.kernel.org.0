Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C34775CAF3
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 17:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjGUPIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjGUPIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 11:08:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2C5272E
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689952053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LT31EnQdwzSm3B5EwQJfjJehEaFosn84rDtB5FWxnI=;
        b=NeF2q5Dk8i5rFoVQkLEDStgFiYvgJ82I4vyKQGQcI8bWDj8UIr6piO4e1oAPj8RbVpeQ8j
        uEXRDEVpF2vchUqR2OXhD1+1gv2NNwhJVM/KOui09wDGAimv4lupVwcZpczunwmrKcGeFd
        Vo2h2c34AnjoG1MHu5+MZB49zbmzbZo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-fyUr4fAZP-OIPStPx3Pw6Q-1; Fri, 21 Jul 2023 11:07:32 -0400
X-MC-Unique: fyUr4fAZP-OIPStPx3Pw6Q-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-51bef8bb689so3788874a12.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689952051; x=1690556851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LT31EnQdwzSm3B5EwQJfjJehEaFosn84rDtB5FWxnI=;
        b=V/t/LS/yarl49eiec5QTp1GrAzFeJX0WXxOd6SyLHulwm7CBwmfPQlb3YokBKck2NZ
         0CdEtPjvHdIOqYRwoXHM4GnuTIhJVza7kYxiDttwwnezSFrbluBjhbv4lePQ8aGtE/9y
         aii54gp/1LCziuCrCeLMJjCfrswetjvyuV0UiPQlhR5CLn+6jYD+lh9sq1te2BLdrn0K
         P5Poqbm6Q1GbdrKYQ2GqLs2LkSDYpllQ2qKhbxwwogWzzl7joSk2L8ES2NC4M9QBN1an
         ecX1Mk8NClEORqI4Qf+KoG7sjNo4OFDz9jEF/UDeNawKHpq0240yUu8SsoMT80pQPcmx
         v5vg==
X-Gm-Message-State: ABy/qLa0kqxkEnJsiuHsPU25BPL64W3H9opDdfsVrk29Fk+nlTG4xR8C
        zOW/YwHEXMjz7eYIm0RL6zUpxxyuozr4gFN1zI8ohnSronBzss3fkQCsSso2N7/rO8RgD/tSIqL
        Kgy4/BxBb14dc
X-Received: by 2002:a05:6402:3596:b0:521:ae30:787d with SMTP id y22-20020a056402359600b00521ae30787dmr8297805edc.21.1689952051258;
        Fri, 21 Jul 2023 08:07:31 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEmyaXBPPcDeACqrampuhZk7coBp7sKkHctpw4dd03JKW9PMu58s3JgUnfUUPbC+bjZ7T2rgQ==
X-Received: by 2002:a05:6402:3596:b0:521:ae30:787d with SMTP id y22-20020a056402359600b00521ae30787dmr8297753edc.21.1689952050947;
        Fri, 21 Jul 2023 08:07:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w10-20020aa7d28a000000b00521f4ee396fsm127596edq.12.2023.07.21.08.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:07:30 -0700 (PDT)
Message-ID: <84a908ae-04c7-51c7-c9a8-119e1933a189@redhat.com>
Date:   Fri, 21 Jul 2023 17:07:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v11 13/29] KVM: Add transparent hugepage support for
 dedicated guest memory
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
 <20230718234512.1690985-14-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230718234512.1690985-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/23 01:44, Sean Christopherson wrote:
>   
> @@ -413,6 +454,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>   	u64 flags = args->flags;
>   	u64 valid_flags = 0;
>   
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		valid_flags |= KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
> +

I think it should be always allowed.  The outcome would just be "never 
have a hugepage" if thp is not enabled in the kernel.

Paolo

