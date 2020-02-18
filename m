Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46B11626EF
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 14:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgBRNOD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Feb 2020 08:14:03 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3014 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726086AbgBRNOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 08:14:03 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 763E98507C88AB9936DF;
        Tue, 18 Feb 2020 21:13:58 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.16]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 21:13:47 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Subject: RFC: Split EPT huge pages in advance of dirty logging
Thread-Topic: RFC: Split EPT huge pages in advance of dirty logging
Thread-Index: AdXmU97BvyK5YKoyS5++my9GnvXVkw==
Date:   Tue, 18 Feb 2020 13:13:47 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
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

Hi all,

We found that the guest will be soft-lockup occasionally when live migrating a 60 vCPU,
512GiB huge page and memory sensitive VM. The reason is clear, almost all of the vCPUs
are waiting for the KVM MMU spin-lock to create 4K SPTEs when the huge pages are
write protected. This phenomenon is also described in this patch set:
https://patchwork.kernel.org/cover/11163459/
which aims to handle page faults in parallel more efficiently.

Our idea is to use the migration thread to touch all of the guest memory in the
granularity of 4K before enabling dirty logging. To be more specific, we split all the
PDPE_LEVEL SPTEs into DIRECTORY_LEVEL SPTEs as the first step, and then split all
the DIRECTORY_LEVEL SPTEs into PAGE_TABLE_LEVEL SPTEs as the following step.

However, there is a side effect. It takes more time to clear the D-bits of the last level
SPTEs when enabling dirty logging, which is held the QEMU BQL and KVM mmu-lock
simultaneously. To solve this issue, the idea of dirty logging gradually in small chunks
is proposed too, here is the link for v1:
https://patchwork.kernel.org/patch/11388227/

Under the Intel(R) Xeon(R) Gold 6161 CPU @ 2.20GHz environment, some tests has
been done with a 60U256G VM which enables numa balancing using the demo we
written. We start a process which has 60 threads to randomly touch most of the
memory in VM, meanwhile count the function execution time in VM when live
migration. The change_prot_numa() is chosen since it will not release the CPU
unless its work has finished. Here is the number:

                    Original                 The demo we written
[1]                  > 9s (most of the time)     ~5ms
Hypervisor cost       > 90%                   ~3%

[1]: execution time of the change_prot_numa() function

If the time in [1] bigger than 20s, it will be result in soft-lockup.

I know it is a little hacking to do so, but my question is: is this worth trying to split
EPT huge pages in advance of dirty logging?

Any advice will be appreciated, thanks.

Regards,
Jay Zhou
