Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4635AAC59
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 12:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiIBK0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 06:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiIBK0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 06:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7B4A897A
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 03:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662114393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/3Op2YuEkkBOG1RJWqT1GBeAbr2w0wiiubsVaWhZ/YI=;
        b=X/Ywp6NzAM8QF82n6Woui/2x3/wE+2aWMe//EHHN73SpbONndk2inyc1W+dHYIVZEfcb/b
        boW5vqdPgVkWU2xMHOEfDhk2R+D0D8GU2UsebZoZRJZc0sBPizNxJPo5ASB9IF7rwkiN7p
        8JmknLtFG1jv+RqO7E882u6mC/3Yk3s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-hZDcB34nPOuFTpVlcDXXzg-1; Fri, 02 Sep 2022 06:26:28 -0400
X-MC-Unique: hZDcB34nPOuFTpVlcDXXzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DA41811130;
        Fri,  2 Sep 2022 10:26:27 +0000 (UTC)
Received: from localhost (unknown [10.39.193.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 121CCC15BC0;
        Fri,  2 Sep 2022 10:26:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v3 1/7] arm64: mte: Fix/clarify the PG_mte_tagged semantics
In-Reply-To: <20220810193033.1090251-2-pcc@google.com>
Organization: Red Hat GmbH
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-2-pcc@google.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Fri, 02 Sep 2022 12:26:25 +0200
Message-ID: <87k06mdqcu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10 2022, Peter Collingbourne <pcc@google.com> wrote:

> From: Catalin Marinas <catalin.marinas@arm.com>
>
> Currently the PG_mte_tagged page flag mostly means the page contains
> valid tags and it should be set after the tags have been cleared or
> restored. However, in mte_sync_tags() it is set before setting the tags
> to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
> shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
> write in another thread can cause the new page to have stale tags.
> Similarly, tag reading via ptrace() can read stale tags of the

s/of/if/

> PG_mte_tagged flag is set before actually clearing/restoring the tags.
>
> Fix the PG_mte_tagged semantics so that it is only set after the tags
> have been cleared or restored. This is safe for swap restoring into a
> MAP_SHARED or CoW page since the core code takes the page lock. Add two
> functions to test and set the PG_mte_tagged flag with acquire and
> release semantics. The downside is that concurrent mprotect(PROT_MTE) on
> a MAP_SHARED page may cause tag loss. This is already the case for KVM
> guests if a VMM changes the page protection while the guest triggers a
> user_mem_abort().
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
> v3:
> - fix build with CONFIG_ARM64_MTE disabled
>
>  arch/arm64/include/asm/mte.h     | 30 ++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/pgtable.h |  2 +-
>  arch/arm64/kernel/cpufeature.c   |  4 +++-
>  arch/arm64/kernel/elfcore.c      |  2 +-
>  arch/arm64/kernel/hibernate.c    |  2 +-
>  arch/arm64/kernel/mte.c          | 12 +++++++-----
>  arch/arm64/kvm/guest.c           |  4 ++--
>  arch/arm64/kvm/mmu.c             |  4 ++--
>  arch/arm64/mm/copypage.c         |  4 ++--
>  arch/arm64/mm/fault.c            |  2 +-
>  arch/arm64/mm/mteswap.c          |  2 +-
>  11 files changed, 51 insertions(+), 17 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

