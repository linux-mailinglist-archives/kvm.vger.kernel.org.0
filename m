Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777C1176DF4
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCCEZQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 2 Mar 2020 23:25:16 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2974 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726859AbgCCEZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:25:15 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id D29A1C59750FB9889CB7;
        Tue,  3 Mar 2020 12:25:12 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.90]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0439.000;
 Tue, 3 Mar 2020 12:25:04 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "peterx@redhat.com" <peterx@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH v4] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH v4] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV7Q3Lxg5gWmOj/Eu4NPJgo7BMPag0/xkAgAFNMnA=
Date:   Tue, 3 Mar 2020 04:25:04 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB4DD51@DGGEMM528-MBX.china.huawei.com>
References: <20200227013227.1401-1-jianjay.zhou@huawei.com>
 <63c0990f-83bc-fa41-43b1-994d3bb6b4df@redhat.com>
In-Reply-To: <63c0990f-83bc-fa41-43b1-994d3bb6b4df@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Tuesday, March 3, 2020 12:29 AM
> To: Zhoujian (jay) <jianjay.zhou@huawei.com>; kvm@vger.kernel.org
> Cc: peterx@redhat.com; sean.j.christopherson@intel.com; wangxin (U)
> <wangxinxin.wang@huawei.com>; Huangweidong (C)
> <weidong.huang@huawei.com>; Liujinsong (Paul) <liu.jinsong@huawei.com>
> Subject: Re: [PATCH v4] KVM: x86: enable dirty log gradually in small chunks
> 
> On 27/02/20 02:32, Jay Zhou wrote:
> > It could take kvm->mmu_lock for an extended period of time when
> > enabling dirty log for the first time. The main cost is to clear all
> > the D-bits of last level SPTEs. This situation can benefit from manual
> > dirty log protect as well, which can reduce the mmu_lock time taken.
> > The sequence is like this:
> >
> > 1. Initialize all the bits of the dirty bitmap to 1 when enabling
> >    dirty log for the first time
> > 2. Only write protect the huge pages
> > 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info 4.
> > KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
> >    SPTEs gradually in small chunks
> >
> > Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment, I did
> > some tests with a 128G windows VM and counted the time taken of
> > memory_global_dirty_log_start, here is the numbers:
> >
> > VM Size        Before    After optimization
> > 128G           460ms     10ms
> >
> > Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> > ---
> 
> Looks good.  Can you write a change for QEMU and for
> tools/testing/selftests/kvm/clear_dirty_log_test?

Will do.

Regards,
Jay Zhou
