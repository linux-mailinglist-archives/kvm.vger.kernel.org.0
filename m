Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62B664431A
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 13:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiLFM16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 07:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFM14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 07:27:56 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5942B6D
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 04:27:54 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRKMg1HsczqSsR;
        Tue,  6 Dec 2022 20:23:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 20:27:51 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <pbonzini@redhat.com>, <maz@kernel.org>, <james.morse@arm.com>
CC:     <kvm@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [RFC PATCH 0/2] Add vcpu debugfs to record statstical data for every single
Date:   Tue, 6 Dec 2022 20:58:26 +0800
Message-ID: <1670331508-67322-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently it only records statistical data for all vcpus, but we ofen want
to know statistical data for a single vcpu, there is no debugfs for that.
So add vcpu debugfs to record statstical data for every single vcpu, and
also enable vcpu debugfs for arm64.

After the change, those vcpu debugfs are as follows (we have 4 vcpu in the
vm):

[root@centos kvm]# cd 2025-14/
[root@centos 2025-14]# ls
blocking                halt_wait_hist             vcpu0
exits                   halt_wait_ns               vcpu1
halt_attempted_poll     halt_wakeup                vcpu2
halt_poll_fail_hist     hvc_exit_stat              vcpu3
halt_poll_fail_ns       mmio_exit_kernel           vgic-state
halt_poll_invalid       mmio_exit_user             wfe_exit_stat
halt_poll_success_hist  remote_tlb_flush           wfi_exit_stat
halt_poll_success_ns    remote_tlb_flush_requests
halt_successful_poll    signal_exits
[root@centos 2025-14]# cat exits
124689
[root@centos 2025-14]# cat vcpu0/exits
52966
[root@centos 2025-14]# cat vcpu1/exits
21549
[root@centos 2025-14]# cat vcpu2/exits
43864
[root@centos 2025-14]# cat vcpu3/exits
6572
[root@centos 2025-14]# ls vcpu0
blocking             halt_poll_invalid       halt_wait_ns      pid
exits                halt_poll_success_hist  halt_wakeup       signal_exits
halt_attempted_poll  halt_poll_success_ns    hvc_exit_stat     wfe_exit_stat
halt_poll_fail_hist  halt_successful_poll    mmio_exit_kernel  wfi_exit_stat
halt_poll_fail_ns    halt_wait_hist          mmio_exit_user

Xiang Chen (2):
  KVM: debugfs: Add vcpu debugfs to record statstical data for every
    single vcpu
  KVM: arm64: Enable __KVM_HAVE_ARCH_VCPU_DEBUGFS

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  4 +++
 include/linux/kvm_host.h          |  2 ++
 virt/kvm/kvm_main.c               | 62 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 67 insertions(+), 2 deletions(-)

-- 
2.8.1

