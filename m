Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9C61FAE2
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiKGRLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiKGRLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:11:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DA6140C2
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rfFJYesx+4rIOVCmddyPJXOJt2foLuyf55xGPHLwEB4=;
        b=c5E3I2Xfk0bZlwzX4QiKvVvgtxm0Y7UI6yl0QEi8luCVrpC+CZjojU9wtQYUod2FsJe6UI
        6WXkujvhGTsdNMXRO2j7N+euifxh41diZ+Csi7dn16WSOvh2RviSauK/C0XcKiM+CwMLjw
        +RaXwgicbPD4iHfbp30yI/77vXZQzyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-jX9ggGZMMGWvypVznMMVmw-1; Mon, 07 Nov 2022 12:10:46 -0500
X-MC-Unique: jX9ggGZMMGWvypVznMMVmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3A3A1C087BA;
        Mon,  7 Nov 2022 17:10:42 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A499D1401C3B;
        Mon,  7 Nov 2022 17:10:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v5 3/8] KVM: arm64: Simplify the sanitise_mte_tags() logic
In-Reply-To: <20221104011041.290951-4-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-4-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 07 Nov 2022 18:10:39 +0100
Message-ID: <87leom3d2o.fsf@redhat.com>
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
> Currently sanitise_mte_tags() checks if it's an online page before
> attempting to sanitise the tags. Such detection should be done in the
> caller via the VM_MTE_ALLOWED vma flag. Since kvm_set_spte_gfn() does
> not have the vma, leave the page unmapped if not already tagged. Tag
> initialisation will be done on a subsequent access fault in
> user_mem_abort().
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [pcc@google.com: fix the page initializer]
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Steven Price <steven.price@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
>  1 file changed, 15 insertions(+), 25 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

