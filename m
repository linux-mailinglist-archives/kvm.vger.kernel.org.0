Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97ECA67EA1B
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 16:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjA0P6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 10:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjA0P6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 10:58:37 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDC180173;
        Fri, 27 Jan 2023 07:58:33 -0800 (PST)
Message-ID: <713a3e22-6327-875e-072d-e916f75d5239@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674835111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LilgKmKEflCZfQlcQYFPLEHnFe8sGUdWiFuvFJpiBQE=;
        b=W1h1/95tW4oi19mOTrCL4z3lTFY8WnS1D5JQdlCzgj3W/8QulHUVnFCJLQrkC+WNPqCc47
        rjsHDgp33JKmjFdkuV7f2w+Tvq9wVSksD8V1gMzpBeUH3UoXQOMnhfMW/yBZFXt6NGDQ2G
        6akvkrV+vSX/NkAKfmFonoHFUCrl15c=
Date:   Fri, 27 Jan 2023 23:57:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/4] KVM: arm64: Allow no running vcpu on saving vgic3
 pending table
Content-Language: en-US
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
        corbet@lwn.net, maz@kernel.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        yuzhe@nfschina.com, isaku.yamahata@intel.com, seanjc@google.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
References: <20230126235451.469087-1-gshan@redhat.com>
 <20230126235451.469087-5-gshan@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20230126235451.469087-5-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/1/27 07:54, Gavin Shan wrote:
> We don't have a running VCPU context to save vgic3 pending table due
> to KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES} command on KVM
> device "kvm-arm-vgic-v3". The unknown case is caught by kvm-unit-tests.
> 
>    # ./kvm-unit-tests/tests/its-pending-migration
>    WARNING: CPU: 120 PID: 7973 at arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3325 \
>    mark_page_dirty_in_slot+0x60/0xe0
>     :
>    mark_page_dirty_in_slot+0x60/0xe0
>    __kvm_write_guest_page+0xcc/0x100
>    kvm_write_guest+0x7c/0xb0
>    vgic_v3_save_pending_tables+0x148/0x2a0
>    vgic_set_common_attr+0x158/0x240
>    vgic_v3_set_attr+0x4c/0x5c
>    kvm_device_ioctl+0x100/0x160
>    __arm64_sys_ioctl+0xa8/0xf0
>    invoke_syscall.constprop.0+0x7c/0xd0
>    el0_svc_common.constprop.0+0x144/0x160
>    do_el0_svc+0x34/0x60
>    el0_svc+0x3c/0x1a0
>    el0t_64_sync_handler+0xb4/0x130
>    el0t_64_sync+0x178/0x17c
> 
> Use vgic_write_guest_lock() to save vgic3 pending table.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  Documentation/virt/kvm/api.rst | 4 +++-
>  arch/arm64/kvm/vgic/vgic-v3.c  | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 40ada313faa3..07f07668995e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8074,7 +8074,9 @@ NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
>  tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
>  KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
>  command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
> -"kvm-arm-vgic-its". vgic3 LPI pending status is restored.
> +"kvm-arm-vgic-its". vgic3 LPI pending status is restored. (3) save
> +vgic3 pending table through KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES}
> +command on KVM device "kvm-arm-vgic-v3".

Can we summarize these 3 examples with something like: "when the guest
memory (pending tables, ITS tables, etc) is dirtied by the virtual GIC
or ITS, which is typically triggered by a userspace request (e.g.,
KVM_DEV_ARM_ITS_SAVE_TABLES) and doesn't require a running VCPU
context"? In case there will be more no-running-vcpu
kvm_write_guest_lock() cases in the VGIC emulation code in future and we
have to extend the documentation..

But I don't have objection to your writing and the whole series looks
good.

Thanks,
Zenghui
