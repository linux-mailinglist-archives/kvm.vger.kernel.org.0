Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C74B987A0
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 01:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfHUXFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 19:05:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfHUXFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 19:05:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7LN48gM186619;
        Wed, 21 Aug 2019 23:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QzJqZQAw7CNLcb5AIEfYie7F9fg4e1Zft5yGgFCU+YU=;
 b=T4Yer8ySNwuP0r/wkAxVYeHxtIJSeujeE1bpF0v3tWuAIqzznnZJ1rU91Fgrk18/6YnM
 +fbjOyCQKabYHnagu1OY91cl72JgPc5ZiSnztJtCI5E6pt5nbqttlTfqNOSSlI8oDP6m
 dJ3FsEzYRo0OQULmuxypAH1dhp5uOmpO5UqJQ2WC6RySZ6VvAgf5rydB2JFgyb965Dd8
 0ABBVmnkKHSkDteYAtQrPsMrtGcz8iZYIFwSKHGqdCH7Iz0gLMs0xCu9eb/OSl/dhb8G
 YzACOzreNO2dldSuySD67puZnO1N4avER5Lf9fU6sEIu3XZujG7fyG+P2euNp0XoFzEQ sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uea7r10en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 23:05:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7LN3BOH039436;
        Wed, 21 Aug 2019 23:05:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uh83p8cjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 23:05:08 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7LN56ha018818;
        Wed, 21 Aug 2019 23:05:06 GMT
Received: from [10.159.144.137] (/10.159.144.137)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Aug 2019 16:05:05 -0700
Subject: Re: [PATCH 6/8][KVM nVMX]: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry
 of nested guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-7-krish.sadhukhan@oracle.com>
 <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <6d0a81be-1546-2a02-92b3-6b94468de9c6@oracle.com>
Date:   Wed, 21 Aug 2019 16:05:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908210228
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210228
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/15/19 3:44 PM, Jim Mattson wrote:
> On Wed, Apr 24, 2019 at 4:43 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Loading Guest State" in Intel SDM vol 3C, the
>> IA32_PERF_GLOBAL_CTRL MSR is loaded on vmentry of nested guests:
>>
>>      "If the “load IA32_PERF_GLOBAL_CTRL” VM-entry control is 1, the
>>       IA32_PERF_GLOBAL_CTRL MSR is loaded from the IA32_PERF_GLOBAL_CTRL
>>       field."
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index a7bf19eaa70b..8177374886a9 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2300,6 +2300,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>          vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
>>          vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
>>
>> +       if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>> +               vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
>> +                            vmcs12->guest_ia32_perf_global_ctrl);
>> +
>>          if (vmx->nested.nested_run_pending &&
>>              (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
>>                  vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
>> --
>> 2.17.2
>>
> This isn't quite right. The GUEST_IA32_PERF_GLOBAL_CTRL value is just
> going to get overwritten later by atomic_switch_perf_msrs().


atomic_switch_perf_msrs() gest called from vmx_vcpu_run() which I 
thought was executing before handle_vmlaunch() stuff that lead to 
prepare_vmcs02(). Did I miss something in the call-chain ?


> Instead of writing the vmcs12 value directly into the vmcs02, you
> should call kvm_set_msr(), exactly as it would have been called if
> MSR_CORE_PERF_GLOBAL_CTRL had been in the vmcs12
> VM-entry MSR-load list. Then, atomic_switch_perf_msrs() will
> automatically do the right thing.
