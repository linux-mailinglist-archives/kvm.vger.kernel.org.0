Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670056A759A
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 21:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCAUud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 15:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCAUuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 15:50:32 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F1E6E97;
        Wed,  1 Mar 2023 12:50:30 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id j11so3687912lfg.13;
        Wed, 01 Mar 2023 12:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677703829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EVVIi1qOZQqID+FdPDDHY7NMwGofBluJX4NX+g9TI3E=;
        b=VasxnDSTws6qNz+8E1phAyl+YOciqDut6QJdLrJixPO4nxQ9JOWgTpVJEsCX0GKXVm
         xTVE8oxNEAbZ0THzYdxBe5wfusqulkheAPmXvWK63CBtUwDFUlwIfv/CPOlQm01FGsMY
         /9DkiMjLxXjdf7ozxoOKQ737w6PET4LaWsVyR6j37gLupPpJcBz/Ol2iVat0+AFKwcnU
         Bxq0DRkc3zK2EJyRpE1y69iN9iDL8lJjpIdiSJ6ItYzOR5t5lM6cMomt61wXyWXWQHgu
         s6Z2ZATDIbsy3+mY1t3L1IyOdRS6pbN9xm4M6h3qMyXM/wP9H1s86xgB6aFwvc3RwmjF
         g8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677703829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVVIi1qOZQqID+FdPDDHY7NMwGofBluJX4NX+g9TI3E=;
        b=aLc3VwdIMIG8uNJPOgpTkTG6GBaVwBRcvWfGNSzxLl0tESFzlJIif++TCrPAGnNJuu
         Jy+lHXlO9SkmkwzTSGjMXu4bJlCy11/FzvPl1tivRW/rLYf0zkXWxyIXqgE2O5WjMQZT
         2aWQ2wuUOBoHwoSYDqyYH1zDoQ78xgTB8zhElxfugCTH9oWGMTGeF94WX6H/WB27PIop
         on6AV2nYtFHE5mazb3yJRDhXPaK9RE2qaQGsvSY3lG5Kxb+p3Agg87McWABJ6h4OlQ43
         Z0NOCB/dgglCSg7lCQEq2E/GzJW2wTDI3vtlYhFpqQSJAiSBCuDU6CvF4NxTU3GePhCK
         5h+g==
X-Gm-Message-State: AO0yUKVokuAZE6/NMXegSjz3sMhYtEA1agHYrZMIRO8rRgHtVIbUGh6P
        /8GkqcddqQ1NJCvAhLZMP/U=
X-Google-Smtp-Source: AK7set9s6L68MNMvJaMIm5hnekdlwc+Dfq4svvZSmGQlo9t3K6s+hDmaQhwTMbeCBOc77HvnQYc3dw==
X-Received: by 2002:ac2:4c21:0:b0:4b5:a7c7:9dc4 with SMTP id u1-20020ac24c21000000b004b5a7c79dc4mr1736422lfq.3.1677703828933;
        Wed, 01 Mar 2023 12:50:28 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id r10-20020ac252aa000000b004cc5f44747dsm1869566lfm.220.2023.03.01.12.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 12:50:28 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 22:50:26 +0200
To:     Steven Price <steven.price@arm.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 08/28] arm64: RME: Keep a spare page delegated to
 the RMM
Message-ID: <20230301225026.000054ec@intel.com>
In-Reply-To: <5750eead-44f9-260f-283d-4902b5363faf@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-9-steven.price@arm.com>
        <20230213184701.00005d3b@gmail.com>
        <5750eead-44f9-260f-283d-4902b5363faf@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Mar 2023 11:55:37 +0000
Steven Price <steven.price@arm.com> wrote:

> On 13/02/2023 16:47, Zhi Wang wrote:
> > On Fri, 27 Jan 2023 11:29:12 +0000
> > Steven Price <steven.price@arm.com> wrote:
> > 
> >> Pages can only be populated/destroyed on the RMM at the 4KB granule,
> >> this requires creating the full depth of RTTs. However if the pages are
> >> going to be combined into a 4MB huge page the last RTT is only
> >> temporarily needed. Similarly when freeing memory the huge page must be
> >> temporarily split requiring temporary usage of the full depth oF RTTs.
> >>
> >> To avoid needing to perform a temporary allocation and delegation of a
> >> page for this purpose we keep a spare delegated page around. In
> >> particular this avoids the need for memory allocation while destroying
> >> the realm guest.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_rme.h | 3 +++
> >>  arch/arm64/kvm/rme.c             | 6 ++++++
> >>  2 files changed, 9 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> >> index 055a22accc08..a6318af3ed11 100644
> >> --- a/arch/arm64/include/asm/kvm_rme.h
> >> +++ b/arch/arm64/include/asm/kvm_rme.h
> >> @@ -21,6 +21,9 @@ struct realm {
> >>  	void *rd;
> >>  	struct realm_params *params;
> >>  
> >> +	/* A spare already delegated page */
> >> +	phys_addr_t spare_page;
> >> +
> >>  	unsigned long num_aux;
> >>  	unsigned int vmid;
> >>  	unsigned int ia_bits;
> >> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> >> index 9f8c5a91b8fc..0c9d70e4d9e6 100644
> >> --- a/arch/arm64/kvm/rme.c
> >> +++ b/arch/arm64/kvm/rme.c
> >> @@ -148,6 +148,7 @@ static int realm_create_rd(struct kvm *kvm)
> >>  	}
> >>  
> >>  	realm->rd = rd;
> >> +	realm->spare_page = PHYS_ADDR_MAX;
> >>  	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
> >>  
> >>  	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> >> @@ -357,6 +358,11 @@ void kvm_destroy_realm(struct kvm *kvm)
> >>  		free_page((unsigned long)realm->rd);
> >>  		realm->rd = NULL;
> >>  	}
> >> +	if (realm->spare_page != PHYS_ADDR_MAX) {
> >> +		if (!WARN_ON(rmi_granule_undelegate(realm->spare_page)))
> >> +			free_page((unsigned long)phys_to_virt(realm->spare_page));
> > 
> > Will the page be leaked (not usable for host and realms) if the undelegate
> > failed? If yes, better at least put a comment.
> 
> Yes - I'll add a comment.
> 
> In general being unable to undelegate a page points to a programming
> error in the host. The only reason the RMM should refuse the request is
> it the page is in use by a Realm which the host has configured. So the
> WARN() is correct (there's a kernel bug) and the only sensible course of
> action is to leak the page and limp on.
>

It would be nice to add a summary of above into the patch comments.

Having a comment when leaking a page (which mostly means the page cannot be
reclaimed by VMM and used on a REALM any more) is nice. TDX/SNP also have
the problem of leaking pages due to mystic reasons.

Imagine the leaking can turn worse bit by bit in a long running server and
KVM will definitely have a generic accounting interface for reporting the
numbers to the userspace later. Having a explicit comment at this time
really makes it easier later.
 
> Thanks,
> 
> Steve
> 
> >> +		realm->spare_page = PHYS_ADDR_MAX;
> >> +	}
> >>  
> >>  	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
> >>  	for (i = 0; i < pgd_sz; i++) {
> > 
> 

