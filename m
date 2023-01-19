Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6169673FD3
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjASRYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjASRYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:24:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B985D4C6C9
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674149045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZLCun6ndTUYHIhway+dCjRST8plu+DLSlmudJ+9iGA=;
        b=CehysE+TUacqwSdjT82SO7EuPi9Xnh72N3GAGX2k/RNneWP02MHvdGKgi5uXk6qnIvapol
        aIUa2hYdrCIPZPsmYMspX6gJr6cM4LOB8+wUIBdBiGyFeylOs0AelfTEEjd44GSA6i9QaW
        feAMvzDuLRTjMlesbCl7mgDrUSmAN+c=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-208--GHTQyt_PlGgYHLOVRbJ8A-1; Thu, 19 Jan 2023 12:24:03 -0500
X-MC-Unique: -GHTQyt_PlGgYHLOVRbJ8A-1
Received: by mail-vs1-f69.google.com with SMTP id l189-20020a6770c6000000b003d0cbd94bc0so917915vsc.7
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:24:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZLCun6ndTUYHIhway+dCjRST8plu+DLSlmudJ+9iGA=;
        b=pc+PIKxhVw7mmoWsaAwD1oV3uhK1NFxi1UNvNIJDdEmDEKSUyncCOpZ8Asr1icBOw4
         f192x4BCoMp3pquh/Y5YP8nr52QHXPvdeq5Uvd4MvXQ/F0wo119nC+4yYK32tG4cQB4A
         f9MIpDYOVogYN0rsKqL7Xy1FPmjNA7YcVtTpsr5Ak4gf0FRcJ1s//L/izgPk61yXHkay
         m5CtH3DZoYfQNeDuZCOYs8gYKHV3/XuKVeb27stKyS+i+Caiek5YkCN41oW3D0xJKcHa
         iFMlnastPKK0tXaGIAJ69oqm0DLjkl+s0AjMfyz66DKhUlYBXN1vmce+Lb9ZqZ3BzPJ2
         YB8w==
X-Gm-Message-State: AFqh2kpq+o2WSmGP2RhYQymMZ9EyxowlDXqIOR4NiVjQPf4ticklczZb
        ZgbwAaLfjlPweGcrniA0nNSI8V2WEaa+pFdpBU8dvraaZQkPndiUtysaa2OXCrnP23fEI9BArMB
        xvPkSBLgs20An/RtsqUWHUsZ8y6Gc
X-Received: by 2002:a05:6102:3d14:b0:3b5:2762:568b with SMTP id i20-20020a0561023d1400b003b52762568bmr1578186vsv.62.1674149041479;
        Thu, 19 Jan 2023 09:24:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtKcbEgINpJzFLAqIx7zgVheHf3U2vYRZ/ijgft8zgf2upp0swiwUYbMZZIryC08LRzFEnE4XMqgG5fhaMKrn4=
X-Received: by 2002:a05:6102:3d14:b0:3b5:2762:568b with SMTP id
 i20-20020a0561023d1400b003b52762568bmr1578157vsv.62.1674149041226; Thu, 19
 Jan 2023 09:24:01 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <Y8l6egh2wWN7BUlZ@google.com>
In-Reply-To: <Y8l6egh2wWN7BUlZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 19 Jan 2023 18:23:49 +0100
Message-ID: <CABgObfaTEZ1_SaQ9ThbeMe8gX2y35ZGTFzgb9K9yZwz8dbOYdQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common code
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
        linux-riscv@lists.infradead.org,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 6:14 PM David Matlack <dmatlack@google.com> wrote:
> Paolo and Sean, what are your thoughts on merging the Common MMU
> refactor without RISC-V support?

I have no objection. We know what the long-term plan is, and it's not
so long-term anyway.

Paolo

