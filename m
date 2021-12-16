Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7744773EA
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 15:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbhLPODR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Dec 2021 09:03:17 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16824 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhLPODQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 09:03:16 -0500
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JFDMT0WM6z91K5;
        Thu, 16 Dec 2021 22:02:29 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 22:03:14 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.020;
 Thu, 16 Dec 2021 22:03:14 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: The vcpu won't be wakened for a long time
Thread-Topic: The vcpu won't be wakened for a long time
Thread-Index: Adfw8hOY5GAlKZgbTtqexw2IMvmqfP//t/OA//yjT/A=
Date:   Thu, 16 Dec 2021 14:03:14 +0000
Message-ID: <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com>
In-Reply-To: <YbjWFTtNo9Ap7kDp@google.com>
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

Hi Sean,

> -----Original Message-----
> From: Sean Christopherson [mailto:seanjc@google.com]
> Sent: Wednesday, December 15, 2021 1:36 AM
> To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> <longpeng2@huawei.com>
> Cc: pbonzini@redhat.com; kvm@vger.kernel.org; Gonglei (Arei)
> <arei.gonglei@huawei.com>; Huangzhichao <huangzhichao@huawei.com>; Wanpeng Li
> <wanpengli@tencent.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Jim Mattson
> <jmattson@google.com>; Joerg Roedel <joro@8bytes.org>; linux-kernel
> <linux-kernel@vger.kernel.org>
> Subject: Re: The vcpu won't be wakened for a long time
> 
> On Tue, Dec 14, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> wrote:
> > Hi guys,
> >
> > We find a problem in kvm_vcpu_block().
> >
> > The testcase is:
> >  - VM configured with 1 vcpu and 1 VF (using vfio-pci passthrough)
> >  - the vfio interrupt and the vcpu are bound to the same pcpu
> >  - using remapped mode IRTE, NOT posted mode
> 
> What exactly is configured to force remapped mode?
> 

It's a misconfigure in one of our test machines.

> > The bug was triggered when the vcpu executed HLT instruction:
> >
> > kvm_vcpu_block:
> >     prepare_to_rcuwait(&vcpu->wait);
> >     for (;;) {
> >         set_current_state(TASK_INTERRUPTIBLE);
> >
> >         if (kvm_vcpu_check_block(vcpu) < 0)
> >             break;
> > 					<------------ (*)
> >         waited = true;
> >         schedule();
> >     }
> >     finish_rcuwait(&vcpu->wait);
> >
> > The vcpu will go to sleep even if an interrupt from the VF is fired at (*)
> and
> > the PIR and ON bit will be set ( in vmx_deliver_posted_interrupt ), so the
> vcpu
> > won't be wakened by subsequent interrupts.
> >
> > Any suggestions ? Thanks.
> 
> What kernel version?  There have been a variety of fixes/changes in the area
> in
> recent kernels.

The kernel version is 4.18, and it seems the latest kernel also has this problem.

The following code can fixes this bug, I've tested it on 4.18.

(4.18)

@@ -3944,6 +3944,11 @@ static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
        if (pi_test_and_set_on(&vmx->pi_desc))
                return;
 
+       if (swq_has_sleeper(kvm_arch_vcpu_wq(vcpu))) {
+               kvm_vcpu_kick(vcpu);
+               return;
+       }
+
        if (vcpu != kvm_get_running_vcpu() &&
                !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
                kvm_vcpu_kick(vcpu);


(latest)

@@ -3959,6 +3959,11 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
        if (pi_test_and_set_on(&vmx->pi_desc))
                return 0;
 
+       if (rcuwait_active(&vcpu->wait)) {
+               kvm_vcpu_kick(vcpu);
+               return 0;
+       }
+
        if (vcpu != kvm_get_running_vcpu() &&
            !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
                kvm_vcpu_kick(vcpu);

Do you have any suggestions ?
Thnaks.
