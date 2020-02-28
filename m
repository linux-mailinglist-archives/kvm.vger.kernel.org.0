Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D9172E6E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 02:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbgB1Buu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Feb 2020 20:50:50 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3028 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730343AbgB1Buu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 20:50:50 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id B289FC0E010F0FE6498C;
        Fri, 28 Feb 2020 09:50:44 +0800 (CST)
Received: from dggeme702-chm.china.huawei.com (10.1.199.98) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 28 Feb 2020 09:50:44 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme702-chm.china.huawei.com (10.1.199.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 28 Feb 2020 09:50:43 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Fri, 28 Feb 2020 09:50:44 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: nVMX: Consult only the "basic" exit reason when
 routing nested exit
Thread-Topic: [PATCH] KVM: nVMX: Consult only the "basic" exit reason when
 routing nested exit
Thread-Index: AdXt2LzqeRxPdhtitkuPjSs9pAY5dw==
Date:   Fri, 28 Feb 2020 01:50:44 +0000
Message-ID: <22e24adec35f4a519070e1dbd0fcf858@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:
>Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON, when determining whether a nested VM-Exit should be reflected into L1 or handled by KVM in L0.
>
>For better or worse, the switch statement in nested_vmx_exit_reflected() currently defaults to "true", i.e. reflects any nested VM-Exit without dedicated logic.  Because the case statements only contain the basic exit reason, any VM-Exit with modifier bits set will be reflected to L1, even if KVM intended to handle it in L0.
>
>Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY, i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to L1, as "failed VM-Entry" is the only modifier that KVM can currently encounter.  The SMM modifiers will never be generated as KVM doesn't support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave", as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to enter an enclave in a KVM guest (L1 or L2).
>

Nice catch! There are similar patch catching this exit reson error.
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

>Fixes: 644d711aa0e1 ("KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit")
>Cc: Jim Mattson <jmattson@google.com>
>Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>---
