Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA464ABAF
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 00:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiLLXo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 18:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbiLLXo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 18:44:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C6116B
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670888610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEA/kHTqeoXaUaGcLLLnYDpNScpRzske2CPEB3QlR58=;
        b=UVWifuHCD4EeBwril/4keZVwOUwBANsaf+xGrr8HjRD/cGGul3Y9Czc24Ru8MkFhWPlGW3
        mQW7kYcbQkEZoWOeSnI27dYmCVvFmPT15mNfldOnzGTxgyJ/jvwQS5dw7P57t2dL0/c99+
        zuMLDot8hA2yDQML+rx5y+HVOsu3rdE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-39-HZu-XpJoNYWJRiMCe9hPxQ-1; Mon, 12 Dec 2022 18:43:21 -0500
X-MC-Unique: HZu-XpJoNYWJRiMCe9hPxQ-1
Received: by mail-wm1-f69.google.com with SMTP id m17-20020a05600c3b1100b003cf9cc47da5so4004435wms.9
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jEA/kHTqeoXaUaGcLLLnYDpNScpRzske2CPEB3QlR58=;
        b=a/Gl3T9DGm/8mFs9gQHE9hR3ieI26ILtlimjrP/ZpktH6N4Z+wnnZVMmlk7j8F/fQy
         dsNruF62WCCj3UR8hO6t7fXnr/xAyRgOFNdy1nAyS6qh0LOYre1b7gCfN3X+6dy96u3r
         Tkug7fZt5lrr5Ebo2V7S1AK+dVa+rvT4zgZMHPtwrfJgrGdV7lbilc9JTG1CHQllzZF8
         C5924HK4iwk00WUQ0JgRhRftTHirD5CslFhkzowArBISy7wxhdXuPRV7Uz5UALqTga4J
         /5UmUp0+Nhb47yng8xVUOBdRv9MCPvp/Y1Jw+1hRU5VIawWRScLQB6K7NAjIAEcWDfUI
         3Ddw==
X-Gm-Message-State: ANoB5pkx0OS6nA1Z4egbf7vppxjsqF027vb8YuEDGDdxz12e0RC0Qu/j
        ODmRca4xVLl3dA9Zm9aaVsBQWqAlv+EHqWqDCP5s0zcs0KFjbX7/tLdgCKp/3bpsicDGUZeGKv5
        dZR2pMkPhhysi
X-Received: by 2002:a05:6000:1a41:b0:232:be5d:4896 with SMTP id t1-20020a0560001a4100b00232be5d4896mr11068890wry.10.1670888600340;
        Mon, 12 Dec 2022 15:43:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6FE6NAMqQtmSlBoZgWlaFymznZFcQYb9/qLkdQoBRkq0uuA5oTNuN3c0LKnzZL0EytBO3qiw==
X-Received: by 2002:a05:6000:1a41:b0:232:be5d:4896 with SMTP id t1-20020a0560001a4100b00232be5d4896mr11068853wry.10.1670888600068;
        Mon, 12 Dec 2022 15:43:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j18-20020a5d5652000000b002427bfd17b6sm12017830wrw.63.2022.12.12.15.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:43:19 -0800 (PST)
Message-ID: <f1026204-1895-1a7e-5bf8-3527223f3778@redhat.com>
Date:   Tue, 13 Dec 2022 00:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        David Matlack <dmatlack@google.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
 <Y5OHVzBSHPmAq2FO@google.com>
 <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
 <Y5e4qxjHWoMt8YGs@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5e4qxjHWoMt8YGs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/22 00:26, Sean Christopherson wrote:
>>> I would strongly be in favor of discarding the shadow paging residue if
>>> x86 folks are willing to part ways with it 😄
>> Yes, absolutely.  Something like to_shadow_page->to_mmu_data, sp->md,
>> spt->hpt, spte->spte, sptep->hptep.
> "host" will be confusing if when the primary MMU is involved though, e.g. I always
> think of the primary MMU's page tables as the "host page tables".
> 
> What if we keep the "S" for SPT(E) and repurpose it to mean Secondary PTE?

Makes sense, so just to_shadow_page->to_secmmu_page?

Paolo

