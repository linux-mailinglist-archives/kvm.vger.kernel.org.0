Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0237664AA3C
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 23:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbiLLW2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 17:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiLLW2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 17:28:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38EB1A837
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670884033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zeSZwvHmFeU5UUDXCwOByZegtobcOblZc96Ym35chsE=;
        b=eibkr8klbSQncXZQFstboW32gdZU30uF/uZNuLtSCBH+qDEk1p072CAsnB4a3YkaUUN9s9
        zIk57Eph/Rcb+BxTxBPd0WcRP986anbY+D3LY3EKJPoLTo4JExUblgfjhqjtzB4gYGekxc
        ZV8bqpbprW4cjWgc61DbG8mSThkutxc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-520-1qY71d3XOwSH0mXtJOm19A-1; Mon, 12 Dec 2022 17:27:11 -0500
X-MC-Unique: 1qY71d3XOwSH0mXtJOm19A-1
Received: by mail-wm1-f70.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso3973207wmh.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeSZwvHmFeU5UUDXCwOByZegtobcOblZc96Ym35chsE=;
        b=DzYSZxEAhqXMY5tjpuXbWK3/uJ+JOO/YudT7cGEgDMAfCi952mZHz8/NeOzTymO41V
         2dHShcSUp2fI8KhDW+qM+DmXvEjjuQtB8frDKUBXISh1wcQey+OAYDAPpvuKW/xI1u3m
         dDu9lfc9O2Om/PK3gwuiMB36D4R7qNGXZHueqRtRMhUAZHPk/z5UL23tRxQ3F4BjUNhH
         QtqZNCrLKOp3EnvDGDP3rB4MVJRLklRC6nvd/FTwmzojxKPTvyolen8+HqME1f2lWnv2
         uwUfw0czhVJJXJD6O5PUf89jJFsG33mqteydtC/A3kK21vB8x92jou4Fd2DviKy2NBBV
         ZiYw==
X-Gm-Message-State: ANoB5pnPWOTizTW0aqhS/lawSfvl1uQxftX5hcKmZS6lYi7Sk889Ydeq
        wjt2syzoBwDJfNNnd68XsJCsW8OsFuijKfwM8p7wWz2LzjvknSwuGjSCpLuuBLE+EbQP9Lx0j+2
        dGrmB1r+nQpZf
X-Received: by 2002:a05:600c:35cb:b0:3cf:360e:f37d with SMTP id r11-20020a05600c35cb00b003cf360ef37dmr14411566wmq.22.1670884030411;
        Mon, 12 Dec 2022 14:27:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dJ0ARaW77iY6LzN30Dnbz5ebYPZeA9S1gDChcfg6ar2i9lvJt/8ICiG48/nDxEpBydsoLBw==
X-Received: by 2002:a05:600c:35cb:b0:3cf:360e:f37d with SMTP id r11-20020a05600c35cb00b003cf360ef37dmr14411523wmq.22.1670884030137;
        Mon, 12 Dec 2022 14:27:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l8-20020a05600c4f0800b003cf54b77bfesm11143797wmq.28.2022.12.12.14.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:27:09 -0800 (PST)
Message-ID: <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
Date:   Mon, 12 Dec 2022 23:27:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common
 code
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-11-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-11-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 20:38, David Matlack wrote:
> +
> +	/* Derived from mmu and global state.  */
> +	const bool is_tdp;

I think this could stay in the architecture-independent part.

Paolo

