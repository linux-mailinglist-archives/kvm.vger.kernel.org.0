Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3577261FB03
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiKGRRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiKGRRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:17:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8A121E0F
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sAQme1GAbPodTq1JRNMk+uId/J7lODmXvvWt4/unp6w=;
        b=Y3+Xa4Jy4rYitl0RSB1HsZ6VBBGoBbJT86BNW9d8ksbMvmRJripc1BvieHnDEntzikBGGI
        mIf1HH0jn3vNJz9dSolyJ/N8PhpxdDswtY945xeyHFvTjW7kNFzzuC2f/Z2L4dpNp5pRNe
        wWSw1WREPXUcrhApZKDDGNLeG/KppMM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-ukFuae4ENwyQK-cdkoEeEA-1; Mon, 07 Nov 2022 12:16:35 -0500
X-MC-Unique: ukFuae4ENwyQK-cdkoEeEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CC881C07596;
        Mon,  7 Nov 2022 17:16:34 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EAB3A140EBF5;
        Mon,  7 Nov 2022 17:16:33 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v5 5/8] arm64: mte: Lock a page for MTE tag initialisation
In-Reply-To: <20221104011041.290951-6-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-6-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 07 Nov 2022 18:16:32 +0100
Message-ID: <87iljq3csv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03 2022, Peter Collingbourne <pcc@google.com> wrote:

> From: Catalin Marinas <catalin.marinas@arm.com>
>
> Initialising the tags and setting PG_mte_tagged flag for a page can race
> between multiple set_pte_at() on shared pages or setting the stage 2 pte
> via user_mem_abort(). Introduce a new PG_mte_lock flag as PG_arch_3 and
> set it before attempting page initialisation. Given that PG_mte_tagged
> is never cleared for a page, consider setting this flag to mean page
> unlocked and wait on this bit with acquire semantics if the page is
> locked:
>
> - try_page_mte_tagging() - lock the page for tagging, return true if it
>   can be tagged, false if already tagged. No acquire semantics if it
>   returns true (PG_mte_tagged not set) as there is no serialisation with
>   a previous set_page_mte_tagged().
>
> - set_page_mte_tagged() - set PG_mte_tagged with release semantics.
>
> The two-bit locking is based on Peter Collingbourne's idea.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/include/asm/mte.h     | 35 +++++++++++++++++++++++++++++++-
>  arch/arm64/include/asm/pgtable.h |  4 ++--
>  arch/arm64/kernel/cpufeature.c   |  2 +-
>  arch/arm64/kernel/mte.c          | 12 +++--------
>  arch/arm64/kvm/guest.c           | 16 +++++++++------
>  arch/arm64/kvm/mmu.c             |  2 +-
>  arch/arm64/mm/copypage.c         |  2 ++
>  arch/arm64/mm/fault.c            |  2 ++
>  arch/arm64/mm/mteswap.c          | 14 +++++--------
>  9 files changed, 60 insertions(+), 29 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

