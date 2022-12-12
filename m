Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5A964AAAD
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 23:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiLLW4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 17:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiLLWzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 17:55:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A77D616F
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670885692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5SuLNwdZHpl5E44bqXulIn8ful04ZsB1bGOr0Kxg/E=;
        b=cKYR+8ljT5104C7buncBFbpOf0U6miiEStGKLah+ZsfbZZPq0Y/p1qhckLvio+eI9i/Eee
        MeHdn2RXRfbkAUCLvl3T6jYY2hK2i7oFiONyhHzimA2S8JBLEHbZjbVgzWlq73G74SsaDf
        A7IQHxZmJt8HRTSMPgncfGjtK0HTja8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-256-GkAnN47OP-6opzsm9ukHKA-1; Mon, 12 Dec 2022 17:54:48 -0500
X-MC-Unique: GkAnN47OP-6opzsm9ukHKA-1
Received: by mail-wm1-f69.google.com with SMTP id j2-20020a05600c1c0200b003cf7397fc9bso3987150wms.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5SuLNwdZHpl5E44bqXulIn8ful04ZsB1bGOr0Kxg/E=;
        b=TfxskDgX4R3MlLa5U2DCzIjp6T+ObD8N2kdp8IlxVEprlebAeXAqMKCQyypYPr+ArK
         03LntkVCDMQoWXnWnK3RA5xStD/PZd8yUdymzqUois9Byl1Y5XRN04pNMkiic6fj0/K/
         D8L2/jxiJAVcjpit9XZfTvjt851oZg6EU7UotLekJ/FtzV5OwsIdt8hbPHjPxqQAidr0
         DO7fh2UR39BCA1BuO5dWsdAYKt6FFe6YBq0BK3kKj9DA4DmQe3ztd377XN09tw4dhXYX
         EatLY9O5mYO63turbFC76joDlwt1j9OHeFlrwuh/iGoucMSUu7AgSKcrRB+i+y5YsWbs
         IHhQ==
X-Gm-Message-State: ANoB5pm8ZIJSxeGU2vzMAaIPn4QvMFO2MYbeVRVLQKZDAnwH5QFDQGvA
        xdYUFRqdD6KRII3iE/oMDyFo6hB+MrpgKJTe1E3jKygsc3A7XKhacB1Gh8a706O3F+GTIIYpqrf
        Am2cb8Qo+JHvr
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id j17-20020a05600c489100b003d1fbf93bd4mr13513695wmp.10.1670885687615;
        Mon, 12 Dec 2022 14:54:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7KvFoJFh/xdI6Uil+R/sBcLTOuYWBFn5UTZm2GDLG0lMDUVKnPmisnw/N8nz6QJ1gfZ6zvaw==
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id j17-20020a05600c489100b003d1fbf93bd4mr13513681wmp.10.1670885687379;
        Mon, 12 Dec 2022 14:54:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h7-20020a05600c314700b003cfd4a50d5asm12200704wmo.34.2022.12.12.14.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:54:46 -0800 (PST)
Message-ID: <eb93beee-9d43-1c1e-250c-28ab7e9ebed9@redhat.com>
Date:   Mon, 12 Dec 2022 23:54:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>,
        David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
In-Reply-To: <Y5OHVzBSHPmAq2FO@google.com>
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

On 12/9/22 20:07, Oliver Upton wrote:
>>   - Naming. This series does not change the names of any existing code.
>>     So all the KVM/x86 Shadow MMU-style terminology like
>>     "shadow_page"/"sp"/"spte" persists. Should we keep that style in
>>     common code or move toward something less shadow-paging-specific?
>>     e.g. "page_table"/"pt"/"pte".
>
> I would strongly be in favor of discarding the shadow paging residue if
> x86 folks are willing to part ways with it 😄

Yes, absolutely.  Something like to_shadow_page->to_mmu_data, sp->md, 
spt->hpt, spte->spte, sptep->hptep.

Paolo

