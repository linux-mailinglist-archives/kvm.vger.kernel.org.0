Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309795EB697
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 02:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiI0A6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 20:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiI0A6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 20:58:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F617923EF
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 17:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664240302;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z0La6MdpiJe9Y2YZ/VyHkbJLNIQ7X1sn+a09BVwMZ8w=;
        b=TMJO63wzO7swHxcfeyK7PVjMEaDCRGmBNw/RYJdiCGsOUhP5RUWuj5pDGauhPknbqfiPFj
        PBVejf8XuOHAH2IWLfkVKS0OHxEg4DO6lWuiM1rKpz87qZ2Pm0J7kUgsY9BhqGIQDaR57q
        swsfz6ANtMzgab1mrsXyIZ5ZEZaPPeY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-lBxFEC4iPrixxpDr28VnzQ-1; Mon, 26 Sep 2022 20:58:16 -0400
X-MC-Unique: lBxFEC4iPrixxpDr28VnzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A917F185A794;
        Tue, 27 Sep 2022 00:58:15 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C468140EBF4;
        Tue, 27 Sep 2022 00:58:09 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20220926145120.27974-1-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <30b5f5e0-1b27-e218-c01f-ca3177d14998@redhat.com>
Date:   Tue, 27 Sep 2022 10:58:07 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/22 12:51 AM, Marc Zyngier wrote:
> [Same distribution list as Gavin's dirty-ring on arm64 series]
> 
> This is an update on the initial series posted as [0].
> 
> As Gavin started posting patches enabling the dirty-ring infrastructure
> on arm64 [1], it quickly became apparent that the API was never intended
> to work on relaxed memory ordering architectures (owing to its x86
> origins).
> 
> This series tries to retrofit some ordering into the existing API by:
> 
> - relying on acquire/release semantics which are the default on x86,
>    but need to be explicit on arm64
> 
> - adding a new capability that indicate which flavor is supported, either
>    with explicit ordering (arm64) or both implicit and explicit (x86),
>    as suggested by Paolo at KVM Forum
> 
> - documenting the requirements for this new capability on weakly ordered
>    architectures
> 
> - updating the selftests to do the right thing
> 
> Ideally, this series should be a prefix of Gavin's, plus a small change
> to his series:
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 0309b2d0f2da..7785379c5048 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -32,7 +32,7 @@ menuconfig KVM
>   	select KVM_VFIO
>   	select HAVE_KVM_EVENTFD
>   	select HAVE_KVM_IRQFD
> -	select HAVE_KVM_DIRTY_RING
> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
>   	select HAVE_KVM_MSI
>   	select HAVE_KVM_IRQCHIP
>   	select HAVE_KVM_IRQ_ROUTING
> 
> This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.
> 
> * From v1:
>    - Repainted the config symbols and new capability so that their
>      naming is more acceptable and causes less churn
>    - Fixed a couple of blunders as pointed out by Peter and Paolo
>    - Updated the documentation
> 
> [0] https://lore.kernel.org/r/20220922170133.2617189-1-maz@kernel.org
> [1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
> [2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
> 
> Marc Zyngier (6):
>    KVM: Use acquire/release semantics when accessing dirty ring GFN state
>    KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
>    KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
>    KVM: Document weakly ordered architecture requirements for dirty ring
>    KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release
>      semantics
>    KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if
>      available
> 
>   Documentation/virt/kvm/api.rst               | 17 +++++++++++++++--
>   arch/x86/kvm/Kconfig                         |  3 ++-
>   include/uapi/linux/kvm.h                     |  1 +
>   tools/testing/selftests/kvm/dirty_log_test.c |  8 +++++---
>   tools/testing/selftests/kvm/lib/kvm_util.c   |  5 ++++-
>   virt/kvm/Kconfig                             | 14 ++++++++++++++
>   virt/kvm/dirty_ring.c                        |  4 ++--
>   virt/kvm/kvm_main.c                          |  9 ++++++++-
>   8 files changed, 51 insertions(+), 10 deletions(-)
> 

This series looks good to me.

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

