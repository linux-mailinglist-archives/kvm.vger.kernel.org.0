Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD517692525
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 19:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjBJSRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 13:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjBJSRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 13:17:09 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98A8E56EC8;
        Fri, 10 Feb 2023 10:17:08 -0800 (PST)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9264620C8B13;
        Fri, 10 Feb 2023 10:17:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9264620C8B13
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676053027;
        bh=GvwdlwmIou+bJX019ml5vO5ujDhFrQi/cZv8npg8uMY=;
        h=Date:To:Cc:From:Subject:From;
        b=owbIv1n6xc8guKcaADi9P67fgtGo3iw8pNe72wsoaHsR1JLvBgusDs0+VVrdfxVCX
         lPli131OFQ+YMgOQMHpbRpOK0twKYKzFDdx0IFuZVCecLTZrSPacmF0aNeBIP0RPVC
         sMwIEwZi6fWGzHQc6s68shpG9ybG3TcHuta4gKYQ=
Message-ID: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
Date:   Fri, 10 Feb 2023 19:17:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Subject: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM on
 Hyper-V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo/Sean,

We've noticed that changes introduced in "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing"
conflict with a nested Hyper-V enlightenment that is always enabled on AMD CPUs 
(HV_X64_NESTED_ENLIGHTENED_TLB). The scenario that is affected is L0 Hyper-V + L1 KVM on AMD,

L2 VMs fail to boot due to to stale data being seen on L1/L2 side, it looks
like the NPT is not in sync with L0. I can reproduce this on any kernel >=5.18,
the easiest way is by launching qemu in a loop with debug OVMF, you can observe
various #GP faults, assert failures, or the guest just suddenly dies. You can try it
for yourself in Azure by launching an Ubuntu 22.10 image on an AMD SKU with nested
virtualization (Da_v5).

In investigating I found that 3 things allow L2 guests to boot again:
* force tdp_mmu=N when loading kvm
* recompile L1 kernel to force disable HV_X64_NESTED_ENLIGHTENED_TLB
* revert both of these commits (found through bisecting):
bb95dfb9e2dfbe6b3f5eb5e8a20e0259dadbe906 "KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages"
efd995dae5eba57c5d28d6886a85298b390a4f07 "KVM: x86/mmu: Zap defunct roots via asynchronous worker"

I'll paste our understanding of what is happening (thanks Tianyu):
"""
Hyper-V provides HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE
and HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST hvcalls for l1
hypervisor to notify Hyper-V after L1 hypervisor changes L2 GPA <-> L1 GPA address
translation tables(Intel calls EPT and AMD calls NPT). This may help not to
mask whole address translation tables of L1 hypervisor to be write-protected in Hyper-V
and avoid vmexits triggered by changing address translation table in L1 hypervisor. 

The following commits defers to call these two hvcalls when there are changes in the L1
hypervisor address translation table. Hyper-V can't sync/shadow L1 address space
table at the first time due to the delay and this may cause mismatch between shadow page table
in the Hyper-V and L1 address translation table. IIRC, KVM side always uses write-protected
translation table to shadow and so doesn't meet such issue with the commit.
"""

Let me know if either of you have any ideas on how to approach fixing this.
I'm not familiar enough with TDP MMU code to be able to contribute a fix directly
but I'm happy to help in any way I can.

Jeremi
