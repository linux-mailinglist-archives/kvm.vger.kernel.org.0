Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CBF68F192
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 16:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjBHPEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 10:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjBHPE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 10:04:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA94032506
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 07:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675868622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qepYHdACOgrn8tjYC+j2h5SwH4vLNyWaHzF3y6ezPbI=;
        b=daZrf0i4OdBYB73HjwcNGd1QNEtPVOhoPleMCeEDrMMiXluUFobq4nCThacs+eouEI1Jpn
        /s/weh3M0ikzGnST+hXMGLiJcBzArwJ1eCFrmo17Hr6OeufZP+Tl+HOELgFIJvIBR7llgE
        eVGYgonkuYBLeWty5JzHTLV5ofGS4Ag=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-B2jhMCXXOR6CPl3I80re8g-1; Wed, 08 Feb 2023 10:03:38 -0500
X-MC-Unique: B2jhMCXXOR6CPl3I80re8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F19EC299E755;
        Wed,  8 Feb 2023 15:03:23 +0000 (UTC)
Received: from localhost (unknown [10.39.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C519C15BAD;
        Wed,  8 Feb 2023 15:03:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Limit length in
 kvm_vm_ioctl_mte_copy_tags() to INT_MAX
In-Reply-To: <20230208140105.655814-5-thuth@redhat.com>
Organization: Red Hat GmbH
References: <20230208140105.655814-1-thuth@redhat.com>
 <20230208140105.655814-5-thuth@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 08 Feb 2023 16:03:22 +0100
Message-ID: <87pmakmc79.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08 2023, Thomas Huth <thuth@redhat.com> wrote:

> In case of success, this function returns the amount of handled bytes.
> However, this does not work for large values: The function is called
> from kvm_arch_vm_ioctl() (which still returns a long), which in turn
> is called from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that function
> stores the return value in an "int r" variable. So the upper 32-bits
> of the "long" return value are lost there.
>
> KVM ioctl functions should only return "int" values, so let's limit
> the amount of bytes that can be requested here to INT_MAX to avoid
> the problem with the truncated return value. We can then also change
> the return type of the function to "int" to make it clearer that it
> is not possible to return a "long" here.
>
> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst    | 3 ++-
>  arch/arm64/include/asm/kvm_host.h | 4 ++--
>  arch/arm64/kvm/guest.c            | 8 ++++++--
>  3 files changed, 10 insertions(+), 5 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

