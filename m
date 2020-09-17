Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D04F26E387
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIQS23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 14:28:29 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:16865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbgIQSQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 14:16:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxlmt8JXKVhIgjdJHperqauk2b1Ahg/U6segiNKn52Y8DwmKsvi695XFvt1nh80xcEe89WIkzKhmtfUU6QHBIF9Ijw40untSJU0RJiW+O4g7YRgDERbQTMy77ex0o5O/lqpN88WrO1I9uFocXiiOTq+v9jOy1XvWEGS+zgYcXMhdeSZVpTZD3jjtKPn5JVdiNwv3BO5SyCfsmvQ9Y2/kIYDeQ/yUDOya5+n/FKXNx1fBK7Je0PA2zxsvH2SgTUnlLQj9wBBAApTbBWN/EqrsYilTSq10I3CA9mD/xrnms/8gAavah2Vg12gR6ZmZ/3J0wYQwQlqPQMydxciR5q3hqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWyb4CoBtyeRFcK59T0/2xziiC4tkc7lzKjmB+k2ReY=;
 b=SL5+k+iiTKTSmO7qLARAhLfsUZ/9xNlFS00UGMOIYjSHgxAdm401hNIht5wnKT4o+M1C/MZ/4fMb3t0n/YHG4QIZ9MEcEfiZKa+jS7eQ3eHKqMYsDGcgZHbe0CQExMTon5b9+Cssc1CcuCW0WpNp9OQTbQO6jjzOlbVwUnLt7GATzstME6+ivNW8j1YDOtkhIkjH4kDcGwol2hifCU+YjFtovvUpESW1gEG8i74/ratYL29ncuCK2hjuvoWWyc80enMekcKc4N6xohg30C/dNS3ruqS8SFlrVdewVv3iDha/jGqIr/Wa4xquuM8wGapiy5znbeVKo+rxANKwLeLcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWyb4CoBtyeRFcK59T0/2xziiC4tkc7lzKjmB+k2ReY=;
 b=UJOYywOuhFEY7go5SxleNKoSEoxEu+oe3L3EY8XdK1QLWLYZeoDuDyoObhUvSWNGyS6wt9QaaxEWjghaSKl7/k4FYrxqXxyxQPMs6mbvJ8Ie/15z1s3qVQVcZxs2xHfpSudh/D+U9GOv98UUaZKN7cFLwIm40v9dkrTgzD5yoUY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3084.namprd12.prod.outlook.com (2603:10b6:5:117::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.11; Thu, 17 Sep 2020 18:16:24 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 18:16:24 +0000
Subject: Re: [PATCH v3 4/5] sev/i386: Don't allow a system reset under an
 SEV-ES guest
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <058dcb33a9cc223e3180133d29e7a92bfdc40938.1600205384.git.thomas.lendacky@amd.com>
 <20200917170119.GR2793@work-vm>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c54ec30c-21f6-db4f-72c4-b0825482a960@amd.com>
Date:   Thu, 17 Sep 2020 13:16:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200917170119.GR2793@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0038.namprd07.prod.outlook.com
 (2603:10b6:803:2d::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0038.namprd07.prod.outlook.com (2603:10b6:803:2d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15 via Frontend Transport; Thu, 17 Sep 2020 18:16:23 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: de4330b6-a329-4246-2b3d-08d85b35c922
X-MS-TrafficTypeDiagnostic: DM6PR12MB3084:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB30840F4E9970D802ADA79DFBEC3E0@DM6PR12MB3084.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIq3u3pdSjC9JdmUFvdwCSYvuFiqmhaAt7ZfxeMObUTwAi+A4LmvRZqHOLU6fGrdiQA3ZkM6pT85OrCI5huynuFOOQ8rAq+S5JTkUg/9LiUxuoqovGrcV4TZRzSSgubo30uuqqL1b794KcVXaUdKWENliLfiu6qxHIKd0/EJQBc3XUmFHVe7zjAMNwipZdIMv70/5sPhkNudDDW5wdGCadqOHkRv3mq6UYbdNOjYdM478CGSAilfa94ccsrEnuVm6XtB7/tubJsavenIs1omaz4HY7ibUL6RrUxiGUewofXxxlxzTFHsTa4zRJ6Ze/8nSIMNqcK8gEr57GH2vVOUeBMjszwkw8v2WqRmoauw+FhrdFsKg4fqtw4fd2YXXTXf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(66556008)(8936002)(66946007)(66476007)(6486002)(2616005)(956004)(6916009)(6512007)(31686004)(4326008)(26005)(6506007)(53546011)(83380400001)(2906002)(7416002)(8676002)(316002)(52116002)(5660300002)(16526019)(186003)(478600001)(86362001)(36756003)(54906003)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I//aKAIoaNtNumeFdpFDENEcYd0tSXMFvmcdzU0d6ZDtoXJ1BRuXvob2ZK74ZxAEaXMM3Zw27XZp0p+1kp1Bch8xl6QJu0GgzrOypJmi6vlH4vXAziVY7rtoMDtXx6S/5BShSi/FFouTSg9eSEG7rHfjZm7i9uTXhtW2xl4iwLaX6xSmObteg8R/g8EEBOZ/8jvJumhvhxGNvujRHyjMOXt2uxB48H271U5kqFKqCuGpuIAUVcafHfPQxxtrHURO+ajjqMyaqPoSsHxtP/D0YWZ7hKLRrtGtbZ81xO1JOY0nyo1EbqI11r5aoeRLBbEB2qZ3Td4VOWs+jn2VEe7sbIGewot+rysoIaLVno0sFsbKNgcAZK2J/07Df0cbzs0N1v3nbl2aVvgn79YpDo5Mtzv1CVwJ2Oa6RbWr5dV4tn+fyQHyvaL4/p1sE08mzBswI7uNlPeOZYu3aVStI0VGXNYsQvhixMjKv1x1X3t8cUJmfp6Wxr7DPxDZejjvqTUcBW7SMk3UM7OIHP4aqhAnGD/BX4VjYcXByNwZv4qY7l//1M3u9ydpx2joEwjYvT7i3mFLMQXWkphoRN1sfUQwQHO/2B9P0dUjaO5dYdIJpPnegZW6pDBZGh926Qu/i9VqFi1/bzkNKfsCvsuA7/r4jw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de4330b6-a329-4246-2b3d-08d85b35c922
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 18:16:24.1517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0fqy8VJHLmchm/sgt8EOvluB2k6ZGko/AemAi4KCOjFhw4G6YnYHQE/TAIKggYKisRSQfkTl4wDV15Vso7PaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/17/20 12:01 PM, Dr. David Alan Gilbert wrote:
> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> An SEV-ES guest does not allow register state to be altered once it has
>> been measured. When a SEV-ES guest issues a reboot command, Qemu will
>> reset the vCPU state and resume the guest. This will cause failures under
>> SEV-ES, so prevent that from occurring.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   accel/kvm/kvm-all.c       | 9 +++++++++
>>   include/sysemu/cpus.h     | 2 ++
>>   include/sysemu/hw_accel.h | 5 +++++
>>   include/sysemu/kvm.h      | 2 ++
>>   softmmu/cpus.c            | 5 +++++
>>   softmmu/vl.c              | 5 ++++-
>>   6 files changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 20725b0368..63153b6e53 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2388,6 +2388,15 @@ void kvm_flush_coalesced_mmio_buffer(void)
>>       s->coalesced_flush_in_progress = false;
>>   }
>>   
>> +bool kvm_cpu_check_resettable(void)
>> +{
>> +    /*
>> +     * If we have a valid reset vector override, then SEV-ES is active
>> +     * and the CPU can't be reset.
>> +     */
>> +    return !kvm_state->reset_valid;
> 
> This seems a bit weird since it's in generic rather than x86 specific
> code.

I could push it down to arch specific code. Is there a way to do that 
without defining the function for all the other arches?

Thanks,
Tom

> 
> Dave
> 
>> +}
>> +
>>   static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
>>   {
>>       if (!cpu->vcpu_dirty) {
>> diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
>> index 3c1da6a018..6d688c757f 100644
>> --- a/include/sysemu/cpus.h
>> +++ b/include/sysemu/cpus.h
>> @@ -24,6 +24,8 @@ void dump_drift_info(void);
>>   void qemu_cpu_kick_self(void);
>>   void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
>>   
>> +bool cpu_is_resettable(void);
>> +
>>   void cpu_synchronize_all_states(void);
>>   void cpu_synchronize_all_post_reset(void);
>>   void cpu_synchronize_all_post_init(void);
>> diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
>> index e128f8b06b..8b4536e7ae 100644
>> --- a/include/sysemu/hw_accel.h
>> +++ b/include/sysemu/hw_accel.h
>> @@ -17,6 +17,11 @@
>>   #include "sysemu/hvf.h"
>>   #include "sysemu/whpx.h"
>>   
>> +static inline bool cpu_check_resettable(void)
>> +{
>> +    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
>> +}
>> +
>>   static inline void cpu_synchronize_state(CPUState *cpu)
>>   {
>>       if (kvm_enabled()) {
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index f74cfa85ab..eb94bbbff9 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -494,6 +494,8 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
>>   
>>   #endif /* NEED_CPU_H */
>>   
>> +bool kvm_cpu_check_resettable(void);
>> +
>>   void kvm_cpu_synchronize_state(CPUState *cpu);
>>   void kvm_cpu_synchronize_post_reset(CPUState *cpu);
>>   void kvm_cpu_synchronize_post_init(CPUState *cpu);
>> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
>> index a802e899ab..32f286643f 100644
>> --- a/softmmu/cpus.c
>> +++ b/softmmu/cpus.c
>> @@ -927,6 +927,11 @@ void hw_error(const char *fmt, ...)
>>       abort();
>>   }
>>   
>> +bool cpu_is_resettable(void)
>> +{
>> +    return cpu_check_resettable();
>> +}
>> +
>>   void cpu_synchronize_all_states(void)
>>   {
>>       CPUState *cpu;
>> diff --git a/softmmu/vl.c b/softmmu/vl.c
>> index 4eb9d1f7fd..422fbb1650 100644
>> --- a/softmmu/vl.c
>> +++ b/softmmu/vl.c
>> @@ -1475,7 +1475,10 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
>>   
>>   void qemu_system_reset_request(ShutdownCause reason)
>>   {
>> -    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>> +    if (!cpu_is_resettable()) {
>> +        error_report("cpus are not resettable, terminating");
>> +        shutdown_requested = reason;
>> +    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>>           shutdown_requested = reason;
>>       } else {
>>           reset_requested = reason;
>> -- 
>> 2.28.0
>>
