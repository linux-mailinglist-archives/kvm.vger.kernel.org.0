Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50E14743F7
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 14:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhLNNzl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 14 Dec 2021 08:55:41 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16807 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhLNNzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 08:55:40 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JD0Hg1Kkhz91h2;
        Tue, 14 Dec 2021 21:54:55 +0800 (CST)
Received: from dggpeml100025.china.huawei.com (7.185.36.37) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 21:55:38 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml100025.china.huawei.com (7.185.36.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 21:55:38 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.020;
 Tue, 14 Dec 2021 21:55:38 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: The vcpu won't be wakened for a long time
Thread-Topic: The vcpu won't be wakened for a long time
Thread-Index: Adfw8hOY5GAlKZgbTtqexw2IMvmqfA==
Date:   Tue, 14 Dec 2021 13:55:38 +0000
Message-ID: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi guys,

We find a problem in kvm_vcpu_block().

The testcase is:
 - VM configured with 1 vcpu and 1 VF (using vfio-pci passthrough)
 - the vfio interrupt and the vcpu are bound to the same pcpu
 - using remapped mode IRTE, NOT posted mode

The bug was triggered when the vcpu executed HLT instruction:

kvm_vcpu_block:
    prepare_to_rcuwait(&vcpu->wait);
    for (;;) {
        set_current_state(TASK_INTERRUPTIBLE);

        if (kvm_vcpu_check_block(vcpu) < 0)
            break;
					<------------ (*)
        waited = true;
        schedule();
    }
    finish_rcuwait(&vcpu->wait);

The vcpu will go to sleep even if an interrupt from the VF is fired at (*) and
the PIR and ON bit will be set ( in vmx_deliver_posted_interrupt ), so the vcpu
won't be wakened by subsequent interrupts.

Any suggestions ? Thanks.
