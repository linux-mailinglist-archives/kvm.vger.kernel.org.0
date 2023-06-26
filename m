Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD08F73E0E5
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 15:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjFZNmj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 26 Jun 2023 09:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjFZNmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 09:42:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E119D1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 06:42:37 -0700 (PDT)
Received: from lhrpeml500006.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QqTV23PlNz67qq2;
        Mon, 26 Jun 2023 21:39:38 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 14:42:34 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.027;
 Mon, 26 Jun 2023 14:42:34 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Shaoqin Huang <shahuang@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>
CC:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Salil Mehta <salil.mehta@opnsrc.net>
Subject: RE: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
Thread-Topic: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
Thread-Index: AQHZp/pp444fl0T5A0KjPRKELV/ZGK+dFe3A
Date:   Mon, 26 Jun 2023 13:42:34 +0000
Message-ID: <9df973ede74e4757b510f26cd5786036@huawei.com>
References: <20230626064910.1787255-1-shahuang@redhat.com>
In-Reply-To: <20230626064910.1787255-1-shahuang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.157.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Shaoqin Huang <shahuang@redhat.com>
> Sent: Monday, June 26, 2023 7:49 AM
> To: qemu-devel@nongnu.org; qemu-arm@nongnu.org
> Cc: oliver.upton@linux.dev; Salil Mehta <salil.mehta@huawei.com>;
> james.morse@arm.com; gshan@redhat.com; Shaoqin Huang <shahuang@redhat.com>;
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; Michael S. Tsirkin
> <mst@redhat.com>; Paolo Bonzini <pbonzini@redhat.com>; Peter Maydell
> <peter.maydell@linaro.org>
> Subject: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
> 
> The userspace SMCCC call filtering[1] provides the ability to forward the SMCCC
> calls to the userspace. The vCPU hotplug[2] would be the first legitimate use
> case to handle the psci calls in userspace, thus the vCPU hotplug can deny the
> PSCI_ON call if the vCPU is not present now.
> 
> This series try to enable the userspace SMCCC call filtering, thus can handle
> the SMCCC call in userspace. The first enabled SMCCC call is psci call, by using
> the new added option 'user-smccc', we can enable handle psci calls in userspace.
> 
> qemu-system-aarch64 -machine virt,user-smccc=on
> 
> This series reuse the qemu implementation of the psci handling, thus the
> handling process is very simple. But when handling psci in userspace when using
> kvm, the reset vcpu process need to be taking care, the detail is included in
> the patch05.

This change in intended for VCPU Hotplug and we are duplicating the code
we are working on. Unless this change is also intended for any other
feature I would request you to defer this.


Thanks
Salil

