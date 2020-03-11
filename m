Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB741811C1
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 08:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgCKHUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 03:20:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11626 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728242AbgCKHUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 03:20:10 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1D0CEFE6F693335B3302;
        Wed, 11 Mar 2020 15:20:06 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.230) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 15:19:55 +0800
Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
To:     Marc Zyngier <maz@kernel.org>
References: <20200309085727.1106-1-zhukeqian1@huawei.com>
 <4b85699ec1d354cc73f5302560231f86@misterjones.org>
 <64925c8b-af3d-beb5-bc9b-66ef1e47f92d@huawei.com>
 <a642a79ea9190542a9098e4c9dc5a9f2@kernel.org>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Jay Zhou" <jianjay.zhou@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <9ddefc54-dd5b-0555-0aaa-00a3a23febcf@huawei.com>
Date:   Wed, 11 Mar 2020 15:19:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <a642a79ea9190542a9098e4c9dc5a9f2@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/10 21:16, Marc Zyngier wrote:
> On 2020-03-10 08:26, zhukeqian wrote:
>> Hi Marc,
>>
>> On 2020/3/9 19:45, Marc Zyngier wrote:
>>> Kegian,
> 
> [...]
> 
>>> Is there a userspace counterpart to it?
>>>
>> As this KVM/x86 related changes have not been merged to mainline
>> kernel, some little modification is needed on mainline Qemu.
> 
> Could you please point me to these changes?
I made some changes locally listed below.

However, Qemu can choose to enable KVM_DIRTY_LOG_INITIALLY_SET or not.
Here I made no judgement on dirty_log_manual_caps because I just want
to verify the optimization of this patch.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..1611f644a4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2007,14 +2007,16 @@ static int kvm_init(MachineState *ms)
     s->coalesced_pio = s->coalesced_mmio &&
                        kvm_check_extension(s, KVM_CAP_COALESCED_PIO);

-    s->manual_dirty_log_protect =
+    uint64_t dirty_log_manual_caps =
         kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-    if (s->manual_dirty_log_protect) {
-        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
+    if (dirty_log_manual_caps) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
+                                dirty_log_manual_caps);
         if (ret) {
             warn_report("Trying to enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
                         "but failed.  Falling back to the legacy mode. ");
-            s->manual_dirty_log_protect = false;
+        } else {
+            s->manual_dirty_log_protect = true;
         }
     }

> 
>> As I tested this patch on a 128GB RAM Linux VM with no huge pages, the
>> time of enabling dirty log will decrease obviously.
> 
> I'm not sure how realistic that is. Not having huge pages tends to lead
> to pretty bad performance in general...
Sure, this has no effect on guests which are all of huge pages.

For my understanding, once a guest has normal pages (maybe are initialized
at beginning or dissloved from huge pages), it can benefit from this patch.
> 
> Thanks,
> 
>         M.
Pretty thanks for your review.

Thanks,
Keqian

