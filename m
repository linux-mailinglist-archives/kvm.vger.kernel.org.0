Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3EA17EE6D
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 03:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgCJCPa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Mar 2020 22:15:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbgCJCP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:26 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id CFE5675DCFD32CF15548;
        Tue, 10 Mar 2020 10:15:22 +0800 (CST)
Received: from dggeme751-chm.china.huawei.com (10.3.19.97) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Mar 2020 10:15:22 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 10 Mar 2020 10:15:22 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Tue, 10 Mar 2020 10:15:22 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH 1/6] KVM: nVMX: avoid NULL pointer dereference with
 incorrect EVMCS GPAs
Thread-Topic: [PATCH 1/6] KVM: nVMX: avoid NULL pointer dereference with
 incorrect EVMCS GPAs
Thread-Index: AdX2gYnHrRJm24gdykq2IZCf5t2hfg==
Date:   Tue, 10 Mar 2020 02:15:22 +0000
Message-ID: <35a2dd64f2024f4693737af24637a3d6@huawei.com>
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

Hi:
Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>When an EVMCS enabled L1 guest on KVM will tries doing enlightened VMEnter with EVMCS GPA = 0 the host crashes because the
>
>evmcs_gpa != vmx->nested.hv_evmcs_vmptr
>
>condition in nested_vmx_handle_enlightened_vmptrld() will evaluate to false (as nested.hv_evmcs_vmptr is zeroed after init). The crash will happen on vmx->nested.hv_evmcs pointer dereference.
>
>Another problematic EVMCS ptr value is '-1' but it only causes host crash after nested_release_evmcs() invocation. The problem is exactly the same as with '0', we mistakenly think that the EVMCS pointer hasn't changed and thus nested.hv_evmcs_vmptr is valid.
>
>Resolve the issue by adding an additional !vmx->nested.hv_evmcs check to nested_vmx_handle_enlightened_vmptrld(), this way we will always be trying kvm_vcpu_map() when nested.hv_evmcs is NULL and this is supposed to catch all invalid EVMCS GPAs.
>
>Also, initialize hv_evmcs_vmptr to '0' in nested_release_evmcs() to be consistent with initialization where we don't currently set hv_evmcs_vmptr to '-1'.
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>---
> arch/x86/kvm/vmx/nested.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)

Good catch! Patch looks good for me. Thanks!
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

