Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60C3758B68
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 04:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjGSCf2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Jul 2023 22:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjGSCfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 22:35:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEA91BC3;
        Tue, 18 Jul 2023 19:35:23 -0700 (PDT)
Received: from lhrpeml500006.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R5Kc000Dtz67QB0;
        Wed, 19 Jul 2023 10:32:47 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 03:35:20 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Wed, 19 Jul 2023 03:35:20 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     "steven.price@arm.com" <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Salil Mehta" <salil.mehta@opnsrc.net>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        yuzenghui <yuzenghui@huawei.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world might
 require ARM spec change?
Thread-Topic: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
Thread-Index: Adm55YYLPryt1tEKR0alBn01xBiFBw==
Date:   Wed, 19 Jul 2023 02:35:19 +0000
Message-ID: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.147.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Reposting it here from Linaro Open Discussion List for more eyes to look at]

Hello,
I have recently started to dabble with ARM CCA stuff and check if our
recent changes to support vCPU Hotplug in ARM64 can work in the realm
world. I have realized that in the RMM specification[1] PSCI_CPU_ON
command(B5.3.3) does not handles the PSCI_DENIED return code(B5.4.2),
from the host. This might be required to support vCPU Hotplug feature
in the realm world in future. vCPU Hotplug is an important feature to
support kata-containers in realm world as it reduces the VM boot time
and facilitates dynamic adjustment of vCPUs (which I think should be
true even with Realm world as current implementation only makes use
of the PSCI_ON/OFF to realize the Hotplug look-like effect?)


As per our recent changes [2], [3] related to support vCPU Hotplug on
ARM64, we handle the guest exits due to SMC/HVC Hypercall in the
user-space i.e. VMM/Qemu. In realm world, REC Exits to host due to
PSCI_CPU_ON should undergo similar policy checks and I think,

1. Host should *deny* to online the target vCPUs which are NOT plugged
2. This means target REC should be denied by host. Can host call
   RMI_PSCI_COMPETE in such s case? 
3. The *return* value (B5.3.3.1.3 Output values) should be PSCI_DENIED
4. Failure condition (B5.3.3.2) should be amended with
   runnable pre: target_rec.flags.runnable == NOT_RUNNABLE (?)
            post: result == PSCI_DENIED (?)
5. Change would also be required in the flow (D1.4 PSCI flows) depicting 
   PSCI_CPU_ON flow (D1.4.1)
  

I do understand that ARM CCA support is in its infancy stage and
discussing about vCPU Hotplug in realm world seem to be a far-fetched
idea right now. But specification changes require lot of time and if
this change is really required then it should be further discussed
within ARM. 

Many thanks!


Bes regards
Salil


References:

[1] https://developer.arm.com/documentation/den0137/latest/
[2] https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1-port11052023.dev-1
[3] https://git.gitlab.arm.com/linux-arm/linux-jm.git virtual_cpu_hotplug/rfc/v2

