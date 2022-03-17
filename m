Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A764DC025
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 08:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiCQH3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 03:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiCQH3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 03:29:31 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C73726AE2
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 00:27:53 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KJzBJ2QRZzcb7p;
        Thu, 17 Mar 2022 15:22:48 +0800 (CST)
Received: from kwepemm600020.china.huawei.com (7.193.23.147) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 15:27:47 +0800
Received: from [10.174.187.192] (10.174.187.192) by
 kwepemm600020.china.huawei.com (7.193.23.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 15:27:46 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
Subject: Report an error on GICv4.1 vcpu de-schedule
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <maz@kernel.org>
CC:     "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        <Martin.Weidmann@arm.com>, <tangnianyao@huawei.com>,
        <chengjian8@huawei.com>, Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <4aae10ba-b39a-5f84-754b-69c2eb0a2c03@huawei.com>
Date:   Thu, 17 Mar 2022 15:27:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.192]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600020.china.huawei.com (7.193.23.147)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc，

The patch "KVM: arm64: Delay the polling of the GICR_VPENDBASER.Dirty
bit"(57e3cebd022fbc035dcf190ac789fd2ffc747f5b) remove the polling of
GICR_VPENDBASER.Dirty bit in vcpu_load() , while check the VPT parsing
ready in kvm_vgic_flush_hwstate() for better performance.

Most time it works, but we have met an error on our hardware recently.
In preemptable kernel, the vcpu can be preempted between vcpu_load and
kvm_vgic_flush_hwstate. As a result, it get de-scheduled and
its_clear_vpend_valid() is called

	val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
	val &= ~GICR_VPENDBASER_Valid;
	val &= ~clr;
	val |= set;
	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);


The function clears Valid bit meanwhile GICR_VPENDBASER_Dirty
maybe still 1, which cause the subsequent GICR_VPENDBASER_Dirty polling
fail and report ""ITS virtual pending table not cleaning".

We have communicated with Martin from ARM and get the conclusion
that we should not change valid bit while the dirty bit not clear——
"The dirty bit reports whether the last schedule /de-schedule
operation has completed.The restriction on not changing Valid when Dirty
is 1, is so that hardware can always complete the last operation for
starting the next".

I think maybe we can check dirty bit clear before clearing the valid bit
in its_clear_vpend_valid() code. Hope to know your opinion about this
issue.

Thanks,
Jingyi







