Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB730470FBD
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 02:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345534AbhLKBIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 20:08:38 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56970 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232244AbhLKBIh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 20:08:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V-CAHnF_1639184698;
Received: from 30.212.189.94(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V-CAHnF_1639184698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 11 Dec 2021 09:05:00 +0800
Message-ID: <bbde6da2-9441-53c1-6b7c-bb6551933a2e@linux.alibaba.com>
Date:   Sat, 11 Dec 2021 09:04:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: VM_BUG_ON in vmx_prepare_switch_to_guest->__get_current_cr3_fast
 at kvm/queue
Content-Language: en-US
From:   Lai Jiangshan <laijs@linux.alibaba.com>
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
References: <YbOVBDCcpuwtXD/7@google.com>
 <b66710af-4f52-4097-9cba-27703c49f784@linux.alibaba.com>
In-Reply-To: <b66710af-4f52-4097-9cba-27703c49f784@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/11 07:54, Lai Jiangshan wrote:
> 
> 
> On 2021/12/11 01:57, David Matlack wrote:
>> While testing some patches I ran into a VM_BUG_ON that I have been able to
>> reproduce at kvm/queue commit 45af1bb99b72 ("KVM: VMX: Clean up PI
>> pre/post-block WARNs").
>>
>> To repro run the kvm-unit-tests on a kernel built from kvm/queue with
>> CONFIG_DEBUG_VM=y. I was testing on an Intel Cascade Lake host and have not
>> tested in any other environments yet. The repro is not 100% reliable, although
>> it's fairly easy to trigger and always during a vmx* kvm-unit-tests
>>
>> Given the details of the crash, commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3
>> in vmx_prepare_switch_to_guest()") and surrounding commits look most suspect.
> 
> Hello, is it producible if this commit is reverted?
> 
> Which test in kvm-unit-tests can trigger it?

Hello, commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3
in vmx_prepare_switch_to_guest()") must be the culprit.

Is the test related to nested vmx?

Could you also apply the following patch and retest please.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 95f3823b3a9d..c93849be73f1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -251,6 +251,10 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
  	dest->ds_sel = src->ds_sel;
  	dest->es_sel = src->es_sel;
  #endif
+	if (unlikely(dest->cr3 != src->cr3)) {
+		vmcs_writel(HOST_CR3, src->cr3);
+		dest->cr3 = src->cr3;
+	}
  }

  static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
