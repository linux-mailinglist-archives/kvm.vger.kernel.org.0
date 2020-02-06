Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16F8153F2E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 08:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBFHLR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Feb 2020 02:11:17 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:60618 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727934AbgBFHLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 02:11:16 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id D587DB9182AE8958FF50;
        Thu,  6 Feb 2020 15:11:13 +0800 (CST)
Received: from dggeme764-chm.china.huawei.com (10.3.19.110) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 6 Feb 2020 15:11:13 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme764-chm.china.huawei.com (10.3.19.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 6 Feb 2020 15:11:13 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 6 Feb 2020 15:11:13 +0800
From:   linmiaohe <linmiaohe@huawei.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [Question] some questions about vmx
Thread-Topic: [Question] some questions about vmx
Thread-Index: AdXctsDpt9tK4MsDR4G7KtucfHatEQ==
Date:   Thu, 6 Feb 2020 07:11:12 +0000
Message-ID: <70c0804949234ad8b6c1834cc9b109ca@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all:
	I'am investigating the vmx code and encounter some questions. It's very nice of you if you can
help me fix these.

About wbinvd.
1. Which way (ctxt->ops->wbinvd)(ctxt) is called? If cpu_has_vmx_wbinvd_exit(), wbinvd instruction would
be handled by handle_wbinvd and instruction emulate is skipped...

2. What is the purpose of set local cpu into wbinvd_dirty_mask in kvm_emulate_wbinvd_noskip()? It seems
local cpu is ignored in smp_call_function_many(). And so local cpu wbinvd is missed ?

3. Commit (2eec73437487: KVM: x86: Avoid issuing wbinvd twice) said we may call wbinvd twice. Could you
please explain how it could execute it twice in detail ?

About nWMX.
When nested_vmx_handle_enlightened_vmptrld() return 0, it do not inject any exception or set rflags to
Indicate VMLAUNCH instruction failed and skip this instruction. This would cause nested_vmx_run()
return 1 and resume guest and retry this instruction. When the error causing nested_vmx_handle_enlightened_vmptrld()
failed can't be handled, would deadloop ouucr ?

About defer setting of CR2 (see commit (da998b46d244: kvm: x86: Defer setting of CR2 until #PF delivery))
How defer setting of CR2 until #PF delivery works? In inject_pending_event(), the payload of exception is loaded into
vmcs12' exit_qualification without setting CR2 via nested_vmx_check_exception() in kvm_x86_ops-> check_nested_events();
But CR2 is unconditionally set to exception.payload via vmx_queue_exception() before we enter L1.
So CR2 is modified before L1 hypervisor could intercept the fault.

Where's the wrong in my understand? Please help me figure it out. Any answer would be very appreciated.
Thanks in advance! ^_^

Best wishes!
