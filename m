Return-Path: <kvm+bounces-41024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE684A60931
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 07:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C1F13B7985
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 06:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A92F1547C5;
	Fri, 14 Mar 2025 06:26:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD91313541B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 06:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741933616; cv=none; b=BXYGj3viTDVbiafwqCYpte2YXokH+7l6vXozebFtVPvQ8b7ZkMvUIQQPk48x1mmmgTibB4slKpyLLPwIKPUl2xfABBKSugqgjxKTSDKByps4BwEv45dTssLul3RcshTPAEm+v3VEHwdUC5iLpzrzHPbnhifM/vYToyL5BJXtJkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741933616; c=relaxed/simple;
	bh=nXOXUD+vv+d+W9cL0ecIjsjZEQ1To7AGKKBZZtkauPs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VLKA6yg0eFZb5tbRP33YTUMQcJ009UpdXa6qk5mt7qpTL5NVK8aWcWvGHj0mDkVLPWSEvPc1hy7x/uX/y9iORfVkjbKhG5mdHkiBlierMQyPHrM8xWVh/VrZA/UQFKy8L0l/MfJW6zn0xpaUT0OoDKYVa1Vv2odZPfkJDl0aa5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZDZ9Y1y2JztQgr;
	Fri, 14 Mar 2025 14:25:21 +0800 (CST)
Received: from kwepemk500007.china.huawei.com (unknown [7.202.194.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 310331800E4;
	Fri, 14 Mar 2025 14:26:50 +0800 (CST)
Received: from huawei.com (10.246.99.19) by kwepemk500007.china.huawei.com
 (7.202.194.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 14 Mar
 2025 14:26:48 +0800
From: zoudongjie <zoudongjie@huawei.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kai.huang@intel.com>, <yuan.yao@intel.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>
CC: <luolongmin@huawei.com>, <suxiaodong1@huawei.com>,
	<jiangkunkun@huawei.com>, <wangjian161@huawei.com>,
	<tangzhongwei2@huawei.com>, <mujinsheng@huawei.com>, <alex.chen@huawei.com>,
	<eric.fangyi@huawei.com>, <zoudongjie@huawei.com>, <chenjianfei3@huawei.com>,
	<renxuming@huawei.com>
Subject: [bug report] KVM: x86: Syzkaller has discovered an use-after-free issue in complete_emulated_mmio of kernel 5.10
Date: Fri, 14 Mar 2025 14:26:20 +0800
Message-ID: <20250314062620.1169174-1-zoudongjie@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemk500007.china.huawei.com (7.202.194.92)

Hi all,

I have discovered a use-after-free issue in complete_emulated_mmio during kernel fuzz testing
with Syzkaller, the Call Trace is as follows:

Call Trace:
 dump_stack+0xbe/0xfd
 print_address_description.constprop.0+0x19/0x170
 __kasan_report.cold+0x6c/0x84
 kasan_report+0x3a/0x50
 check_memory_region+0xfd/0x1f0
 memcpy+0x20/0x60
 complete_emulated_mmio+0x305/0x420
 kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
 kvm_vcpu_ioctl+0x413/0xb20
 __se_sys_ioctl+0x111/0x160
 do_syscall_64+0x30/0x40
 entry_SYSCALL_64_after_hwframe+0x67/0xd1

RIP: 0033:0x45570d
Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f93213e9048 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000058c1f0 RCX: 000000000045570d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 000000000058c1f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 0000000000425750 R15: 00007fff27f167f0

The buggy address belongs to the page:
page:000000005de3ae57 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x111bff
flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
raw: 0017ffffc0000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888111bff780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888111bff800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888111bff880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                 ^
 ffff888111bff900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888111bff980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

==================================================================

Do you have any suggestions regarding this issue?
Any insights or debugging strategies would be greatly appreciated.

Thanks,
Dongjie Zou


