Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6754D7519C6
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbjGMHXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbjGMHXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 03:23:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC5B1BF0;
        Thu, 13 Jul 2023 00:23:01 -0700 (PDT)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R1mGr3CYpzLnj9;
        Thu, 13 Jul 2023 15:20:36 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 15:22:56 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Make the doorbell request robust
 w.r.t preemption
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        <stable@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>
References: <20230713070657.3873244-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f5096fb2-f96d-a553-364b-a7f6b5158e23@huawei.com>
Date:   Thu, 13 Jul 2023 15:22:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230713070657.3873244-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/13 15:06, Marc Zyngier wrote:
> Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
> running a preemptible kernel, as it is possible that a vCPU is blocked
> without requesting a doorbell interrupt.
> 
> The issue is that any preemption that occurs between vgic_v4_put() and
> schedule() on the block path will mark the vPE as nonresident and *not*
> request a doorbell irq. This occurs because when the vcpu thread is
> resumed on its way to block, vcpu_load() will make the vPE resident
> again. Once the vcpu actually blocks, we don't request a doorbell
> anymore, and the vcpu won't be woken up on interrupt delivery.
> 
> Fix it by tracking that we're entering WFI, and key the doorbell
> request on that flag. This allows us not to make the vPE resident
> when going through a preempt/schedule cycle, meaning we don't lose
> any state.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
> Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
> Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
> Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
> Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Zenghui Yu <yuzenghui@huawei.com>
