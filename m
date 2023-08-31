Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5C78E92E
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 11:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbjHaJSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 05:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjHaJSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 05:18:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384EACF4;
        Thu, 31 Aug 2023 02:18:41 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V96GIH017856;
        Thu, 31 Aug 2023 09:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SYjbY0tEWfElEbTqgRB4OPWERFBazTwIpVtJ9bms8Po=;
 b=HlEpqGBJJUvpi84o/Ia7wIn3xWtKtG11LOtXCZrD+sFEtOk+zV+1nWpfCNg9noWmquTl
 dLkeghuZ5QvCmlgwgSgGOu8tuu1iqRt8ACuSYQwl8nPEy3CDmvhOuaWLQmQGsIYXWmui
 PDlWT8OU50SIgMvhmfuT6UkZ3b1pH65cXmoAfchvicONDCCdiJboam3FcLe0p6UYd6NM
 bBx+g5A8xGwZ/v+1a0qZTGKHCNAR8RyZkY2GV+HeXe8KTXfdf+XYt5pmXzwSssY8Aupq
 535DWQReKzR4xqZGF3ya1jiCsCEQHEG29MAn1GIIc+YzAqgYx4lrtFkBSrV/Rm053L9t qg== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3std7xdhha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Aug 2023 09:18:40 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37V9B9hv009967;
        Thu, 31 Aug 2023 09:18:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqw7ku1vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Aug 2023 09:18:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37V9IaWU14746142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 09:18:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EA7420043;
        Thu, 31 Aug 2023 09:18:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E8D820040;
        Thu, 31 Aug 2023 09:18:35 +0000 (GMT)
Received: from [9.179.10.222] (unknown [9.179.10.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 31 Aug 2023 09:18:35 +0000 (GMT)
Message-ID: <f4325517-c9ad-4ac2-42a4-6c63d95a0a6f@linux.ibm.com>
Date:   Thu, 31 Aug 2023 11:18:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v3] KVM: s390: fix gisa destroy operation might lead to
 cpu stalls
To:     Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230828151519.2187418-1-mimu@linux.ibm.com>
 <c3825795-ce38-4992-39d3-85341279e913@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <c3825795-ce38-4992-39d3-85341279e913@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tqXI88mYW3dhz9U3hdRYDDvbGVxVv4Td
X-Proofpoint-ORIG-GUID: tqXI88mYW3dhz9U3hdRYDDvbGVxVv4Td
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_07,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=870 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308310081
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30.08.23 15:13, Matthew Rosato wrote:
> On 8/28/23 11:15 AM, Michael Mueller wrote:
>> A GISA cannot be destroyed as long it is linked in the GIB alert list
>> as this would break the alert list. Just waiting for its removal from
>> the list triggered by another vm is not sufficient as it might be the
>> only vm. The below shown cpu stall situation might occur when GIB alerts
>> are delayed and is fixed by calling process_gib_alert_list() instead of
>> waiting.
>>
>> At this time the vcpus of the vm are already destroyed and thus
>> no vcpu can be kicked to enter the SIE again if for some reason an
>> interrupt is pending for that vm.
>>
>> Additionally the IAM restore value is set to 0x00. That would be a bug
>> introduced by incomplete device de-registration, i.e. missing
>> kvm_s390_gisc_unregister() call.
>>
>> Setting this value and the IAM in the GISA to 0x00 guarantees that late
>> interrupts don't bring the GISA back into the alert list.
>>
>> CPU stall caused by kvm_s390_gisa_destroy():
>>
>>   [ 4915.311372] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 14-.... } 24533 jiffies s: 5269 root: 0x1/.
>>   [ 4915.311390] rcu: blocking rcu_node structures (internal RCU debug): l=1:0-15:0x4000/.
>>   [ 4915.311394] Task dump for CPU 14:
>>   [ 4915.311395] task:qemu-system-s39 state:R  running task     stack:0     pid:217198 ppid:1      flags:0x00000045
>>   [ 4915.311399] Call Trace:
>>   [ 4915.311401]  [<0000038003a33a10>] 0x38003a33a10
>>   [ 4933.861321] rcu: INFO: rcu_sched self-detected stall on CPU
>>   [ 4933.861332] rcu: 	14-....: (42008 ticks this GP) idle=53f4/1/0x4000000000000000 softirq=61530/61530 fqs=14031
>>   [ 4933.861353] rcu: 	(t=42008 jiffies g=238109 q=100360 ncpus=18)
>>   [ 4933.861357] CPU: 14 PID: 217198 Comm: qemu-system-s39 Not tainted 6.5.0-20230816.rc6.git26.a9d17c5d8813.300.fc38.s390x #1
>>   [ 4933.861360] Hardware name: IBM 8561 T01 703 (LPAR)
>>   [ 4933.861361] Krnl PSW : 0704e00180000000 000003ff804bfc66 (kvm_s390_gisa_destroy+0x3e/0xe0 [kvm])
>>   [ 4933.861414]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
>>   [ 4933.861416] Krnl GPRS: 0000000000000000 00000372000000fc 00000002134f8000 000000000d5f5900
>>   [ 4933.861419]            00000002f5ea1d18 00000002f5ea1d18 0000000000000000 0000000000000000
>>   [ 4933.861420]            00000002134fa890 00000002134f8958 000000000d5f5900 00000002134f8000
>>   [ 4933.861422]            000003ffa06acf98 000003ffa06858b0 0000038003a33c20 0000038003a33bc8
>>   [ 4933.861430] Krnl Code: 000003ff804bfc58: ec66002b007e	cij	%r6,0,6,000003ff804bfcae
>>                             000003ff804bfc5e: b904003a		lgr	%r3,%r10
>>                            #000003ff804bfc62: a7f40005		brc	15,000003ff804bfc6c
>>                            >000003ff804bfc66: e330b7300204	lg	%r3,10032(%r11)
>>                             000003ff804bfc6c: 58003000		l	%r0,0(%r3)
>>                             000003ff804bfc70: ec03fffb6076	crj	%r0,%r3,6,000003ff804bfc66
>>                             000003ff804bfc76: e320b7600271	lay	%r2,10080(%r11)
>>                             000003ff804bfc7c: c0e5fffea339	brasl	%r14,000003ff804942ee
>>   [ 4933.861444] Call Trace:
>>   [ 4933.861445]  [<000003ff804bfc66>] kvm_s390_gisa_destroy+0x3e/0xe0 [kvm]
>>   [ 4933.861460] ([<00000002623523de>] free_unref_page+0xee/0x148)
>>   [ 4933.861507]  [<000003ff804aea98>] kvm_arch_destroy_vm+0x50/0x120 [kvm]
>>   [ 4933.861521]  [<000003ff8049d374>] kvm_destroy_vm+0x174/0x288 [kvm]
>>   [ 4933.861532]  [<000003ff8049d4fe>] kvm_vm_release+0x36/0x48 [kvm]
>>   [ 4933.861542]  [<00000002623cd04a>] __fput+0xea/0x2a8
>>   [ 4933.861547]  [<00000002620d5bf8>] task_work_run+0x88/0xf0
>>   [ 4933.861551]  [<00000002620b0aa6>] do_exit+0x2c6/0x528
>>   [ 4933.861556]  [<00000002620b0f00>] do_group_exit+0x40/0xb8
>>   [ 4933.861557]  [<00000002620b0fa6>] __s390x_sys_exit_group+0x2e/0x30
>>   [ 4933.861559]  [<0000000262d481f4>] __do_syscall+0x1d4/0x200
>>   [ 4933.861563]  [<0000000262d59028>] system_call+0x70/0x98
>>   [ 4933.861565] Last Breaking-Event-Address:
>>   [ 4933.861566]  [<0000038003a33b60>] 0x38003a33b60
>>
>> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> ---
>>   arch/s390/kvm/interrupt.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 85e39f472bb4..75e200bd1030 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -3216,11 +3216,12 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>>   
>>   	if (!gi->origin)
>>   		return;
>> -	if (gi->alert.mask)
>> -		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
>> -			  kvm, gi->alert.mask);
>> -	while (gisa_in_alert_list(gi->origin))
>> -		cpu_relax();
>> +	WARN(gi->alert.mask != 0x00,
>> +	     "unexpected non zero alert.mask 0x%02x",
>> +	     gi->alert.mask);
>> +	gi->alert.mask = 0x00;
>> +	if (gisa_set_iam(gi->origin, gi->alert.mask))
>> +		process_gib_alert_list();
>>   	hrtimer_cancel(&gi->timer);
> 
> Thanks for the prior explanations.  This looks pretty good to me now, I think the subtlety that I was missing is that we are kicking off the callback (gisa_vcpu_kicker) via hrtimer_start with an immediate expiry (0) and relying on the fact that this hrtimer_cancel here will wait until that callback has finished.  AFAIU that means that now we will either set the IAM immediately here via gisa_set_iam or via the callback after handling the alert; in both cases this will prevent further alerts and we won't clear gi->origin until after that point.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 

Thanks Matt!

Janosch will pick the patch taday.

> 
>>   	gi->origin = NULL;
>>   	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
> 
