Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9462726E1
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 16:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIUOX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 10:23:28 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:23457
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbgIUOX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 10:23:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQJk/N4IXM5r+CyWzfcSDuFqHvRN3OJKn1xoH50rbsfc2PIqnWRKS3P4dklfEfnFZyvjcQkvNKBVPCdE4RYO5nvWxqD9KKhcn7B6tFwJG5y5J6eXWjKmlFnLC9M0h+ynScQww1lZ8xDuhNGmTW/rtKxh7+h2vCfBxOss8FnORKLVGvVmd2Un+TUpplv19i9tdsAt4aroRfu2MQqmomhgPHr6IU4CS3Rw68SepZUwaBpgzrBna/Qqe+6MzKPapp2utHfiK3GnyialRqhuIBcGNS4p1hxzSytxIDk5uGDvvLfOyPD+XraPKdNe38yxjD9pkDyWK+wkpZ3CLbQQOnu6rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeaHrKF+Q4+c7U+ilJjmpQLHyWM+KFiTw4Yx5QbL/N8=;
 b=KJX4EsFFniTgt+GXHbrFs6idgAg3MN71XXQGmtViC1Iqe9MBW8WXxoAWoQH9KT+GwSByxUI+SgYftXZVlzD6Mrnq2GyCYRy/Kkyr71UilNuWgVrreNfxvvKpulo2CHn9Uk4NhKioC2raiOV35pyUu74DrNP6eIeZVg5cVaom7hega+uXzRrIw3XGqV6QCbyQWhGQqBOFr74Ql+2WOaKTBG+6qUkv2VW78UKKvxgxXEUbUzbIlX0izN6I8BPc9ZqfbYdqtufTNt96JQPwtkEfjlK+TtLMG6UZdQ1gbPTg6vQMFADyY5MhYmFup+BrVntP2K/bNpaZXlsnF1BFe91pzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeaHrKF+Q4+c7U+ilJjmpQLHyWM+KFiTw4Yx5QbL/N8=;
 b=qOdKG/fpmCtW6B8aPv+Uc2EtcfzblIQKJILOE7/38b6ttiuoR4yXKWGXYzKcxBuAGeqPetzLGLnO6tV8bXMB7OJ6w2IQ4V5Dpa8TQscfy5zVGMFO/k/EjuyRBBK01nmt+/zRvf+seEFB7Uj1D8MVJYvJzT06yuZo3uBwZdpA+E8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3371.namprd12.prod.outlook.com (2603:10b6:5:116::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.14; Mon, 21 Sep 2020 14:23:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Mon, 21 Sep 2020
 14:23:22 +0000
Subject: Re: [PATCH v3 0/5] Qemu SEV-ES guest support
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
 <20200917172802.GS2793@work-vm>
 <de0e9c27-8954-3a77-21db-cad84f334277@amd.com>
 <20200918100048.GF2816@work-vm>
 <57a939bd-9489-2114-730b-bee9ec040b31@amd.com>
 <20200921114836.GH3221@work-vm>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <85440965-8436-92fb-1dd1-fa07e97e8739@amd.com>
Date:   Mon, 21 Sep 2020 09:23:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200921114836.GH3221@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:3:93::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR20CA0006.namprd20.prod.outlook.com (2603:10b6:3:93::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 14:23:21 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9dc1742c-63c3-4a98-65de-08d85e39e50d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3371:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB33711E906DB9AD1501DDB412EC3A0@DM6PR12MB3371.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pkjmyp3Pqj6EN8Zqo3fXPnTp6td2JqPVs5V6K9gXtLjybXeSnB3UmIs3vEngyIDJbYF3o8hhETwsZ8BTW5HZZjF9ZUqf6xvo4nnEUz/W8XkkjhJPZ0qjli2s2BhKw3U44LKQZ7yhDtTeFjkN9EQ1D7zg2fpdSgvawgdA0A1sHTtt2g4KX+f5D6KNNq+BHC3qBB+U29l5EEyoo6CfA2TbXrxmKdgv8v/OtRaynioa7kl/DRNIFGDsAARhjIBIMdFOfQfGXrj8O7+qst/VphPOKDkLL4cJqihdtAV7paml8W549wi9+OFWjCuYTh8HpZiDLbwfm/kTBwFHvzKenTIzx/JWVQJocJv1aHL6hmHUVQPTWscRge0B+xNpsOQcaQ8pb6Bbgwnz2WyEgk3fc37Uy8LN2/DzQHmnmaM5h8E8xlCHy8qqIX6RQ0hfYt8t3mTvqXGLL8z+tzaDUaA3zD3rJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(186003)(16526019)(54906003)(86362001)(36756003)(8936002)(2906002)(966005)(7416002)(31686004)(16576012)(26005)(52116002)(53546011)(2616005)(316002)(956004)(31696002)(4326008)(5660300002)(45080400002)(83380400001)(66946007)(6916009)(8676002)(6486002)(66556008)(478600001)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qf83hlnhlvsclrL5CRFtAUCpEAsRDz+R7JiSS2UbbIqq9eeEhuGKVjacZ22WgsZWshDvl8+gLptrzhusQSw0J4N6hw0sgszD1XaKpCmWsgZVHFFmPQLNTeF3DMsfrEgxjgSvWSn8XVnDymssxXPsA7l/Jq8Aq9ewRiRMSJpA1J7Omkl6xuOqohoJQshiF9WAiPCbUx/kpEfsPBd4/KjwjWi2+a8NwY6BviqkDdFzzJglLWK0PsYl2+IGkWWn9BGr+oIOZSjia2rpk/rgMhG3vdJyLQEN1SJDTu0ahr8wSw+2zb3eknCqXAuZpx+VtQCtncMDv5UtnG8HQ0is+3uplIfmXso4+VW9Zzr1inpdj3PLMjoU1wKN/ti7VPI74JAnRueOGC93CH7Xqg4jwy1MX8KZOpsz+SYsoNOIEx6+cbMhYpU014qdiS0RwhSlDpAqG0aqYhrS5pgJWT7fUknpHI73VzK/M/kW5laX4QKbQIpGcsHnGML4jIDvWUPaULzsVjC4ePjLa0A2VUs6yBH6WP03QmRRkBZFgKE41qD9hvUw/iZ0QlOFvKjda9odmZRciuvVqvwss+UPXziHvuDVQ0k3dCufa2aRxWa8+1k7DasfQmj8x2ezogY4z6O3GlGCSAAdVKA+LpVErspCoCrf7g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc1742c-63c3-4a98-65de-08d85e39e50d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 14:23:22.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KDv/kUfl3ODbWJZ7YznaOB8rqdnPb+cZYv86geXBU69Kn5B9XNoDvywag22WiyHEqyGKv94pOevqW0vC5vU6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3371
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/20 6:48 AM, Dr. David Alan Gilbert wrote:
> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>> On 9/18/20 5:00 AM, Dr. David Alan Gilbert wrote:
>>> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>>>> On 9/17/20 12:28 PM, Dr. David Alan Gilbert wrote:
>>>>> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>>>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>>>
>>>>>> This patch series provides support for launching an SEV-ES guest.
>>>>>>
>>>>>> Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
>>>>>> SEV support to protect the guest register state from the hypervisor. See
>>>>>> "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
>>>>>> section "15.35 Encrypted State (SEV-ES)" [1].
>>>>>>
>>>>>> In order to allow a hypervisor to perform functions on behalf of a guest,
>>>>>> there is architectural support for notifying a guest's operating system
>>>>>> when certain types of VMEXITs are about to occur. This allows the guest to
>>>>>> selectively share information with the hypervisor to satisfy the requested
>>>>>> function. The notification is performed using a new exception, the VMM
>>>>>> Communication exception (#VC). The information is shared through the
>>>>>> Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
>>>>>> The GHCB format and the protocol for using it is documented in "SEV-ES
>>>>>> Guest-Hypervisor Communication Block Standardization" [2].
>>>>>>
>>>>>> The main areas of the Qemu code that are updated to support SEV-ES are
>>>>>> around the SEV guest launch process and AP booting in order to support
>>>>>> booting multiple vCPUs.
>>>>>>
>>>>>> There are no new command line switches required. Instead, the desire for
>>>>>> SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
>>>>>> object indicates that SEV-ES is required.
>>>>>>
>>>>>> The SEV launch process is updated in two ways. The first is that a the
>>>>>> KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
>>>>>> standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
>>>>>> measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
>>>>>> each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
>>>>>> invoked, no direct changes to the guest register state can be made.
>>>>>>
>>>>>> AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
>>>>>> is typically used to boot the APs. However, the hypervisor is not allowed
>>>>>> to update the guest registers. For the APs, the reset vector must be known
>>>>>> in advance. An OVMF method to provide a known reset vector address exists
>>>>>> by providing an SEV information block, identified by UUID, near the end of
>>>>>> the firmware [3]. OVMF will program the jump to the actual reset vector in
>>>>>> this area of memory. Since the memory location is known in advance, an AP
>>>>>> can be created with the known reset vector address as its starting CS:IP.
>>>>>> The GHCB document [2] talks about how SMP booting under SEV-ES is
>>>>>> performed. SEV-ES also requires the use of the in-kernel irqchip support
>>>>>> in order to minimize the changes required to Qemu to support AP booting.
>>>>>
>>>>> Some random thoughts:
>>>>>     a) Is there something that explicitly disallows SMM?
>>>>
>>>> There isn't currently. Is there a way to know early on that SMM is enabled?
>>>> Could I just call x86_machine_is_smm_enabled() to check that?
>>>>
>>>>>     b) I think all the interfaces you're using are already defined in
>>>>> Linux header files - even if the code to implement them isn't actually
>>>>> upstream in the kernel yet (the launch_update in particular) - we
>>>>> normally wait for the kernel interface to be accepted before taking the
>>>>> QEMU patches, but if the constants are in the headers already I'm not
>>>>> sure what the rule is.
>>>>
>>>> Correct, everything was already present from a Linux header perspective.
>>>>
>>>>>     c) What happens if QEMU reads the register values from the state if
>>>>> the guest is paused - does it just see junk?  I'm just wondering if you
>>>>> need to add checks in places it might try to.
>>>>
>>>> I thought about what to do about calls to read the registers once the guest
>>>> state has become encrypted. I think it would take a lot of changes to make
>>>> Qemu "protected state aware" for what I see as little gain. Qemu is likely
>>>> to see a lot of zeroes or actual register values from the GHCB protocol for
>>>> previous VMGEXITs that took place.
>>>
>>> Yep, that's fair enough - I was curious if we'll hit anything
>>> accidentally still reading it.
>>>
>>> How does SEV-ES interact with the 'NODBG' flag of the guest policy - if
>>> that's 0, and 'debugging of the guest' is allowed, what can you actually
>>> do?
>>
>> The SEV-ES KVM patches will disallow debugging of the guest, or at least
>> setting breakpoints using the debug registers. Gdb can still break in, but
>> you wont get anything reasonable with register dumps and memory dumps.
>>
>> The NODBG policy bit enables or disables the DBG_DECRYPT and DBG_ENCRYPT
>> APIs. So if the guest has allowed debugging, memory dumps could be done
>> using those APIs (for encrypted pages). Registers are a different story
>> because you simply can't update from the hypervisor side under SEV-ES.
>>
>> Under SEV you could do actual debugging if the support was developed and in
>> place.
> 
> Thanks for the explanation - it might be interesting to wire the
> DBG_DECRYPT support up to dump/dump.c for doing full guest memory dumps
> - if the policy has it enabled.

Someone on our team is looking at hooking in those APIs for displaying /
dumping memory. I'll forward this on to them.

Thanks,
Tom

> 
> Dave
> 
>> Thanks,
>> Tom
>>
>>>
>>> Dave
>>>
>>>> Thanks,
>>>> Tom
>>>>
>>>>>
>>>>> Dave
>>>>>
>>>>>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C8287b3e99fdc41c682fe08d85e244ee0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637362858215616687&amp;sdata=d9n0rRa2AvVS1dmKyBoCF%2BapDhV6UUc8mfGpWD2%2FxMU%3D&amp;reserved=0
>>>>>> [2] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F56421.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C8287b3e99fdc41c682fe08d85e244ee0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637362858215616687&amp;sdata=84imjHi1kXbEf2omr1sS%2Brl7gKYeGFGKk%2BeTavyluN4%3D&amp;reserved=0
>>>>>> [3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
>>>>>>       https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Ftianocore%2Fedk2%2Fcommit%2F30937f2f98c42496f2f143fe8374ae7f7e684847&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C8287b3e99fdc41c682fe08d85e244ee0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637362858215616687&amp;sdata=BTWlq%2BqgpjRtUrbEZE1wasyXxs3YFmfKioEvzvWlsYc%3D&amp;reserved=0
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> These patches are based on commit:
>>>>>> d0ed6a69d3 ("Update version for v5.1.0 release")
>>>>>>
>>>>>> (I tried basing on the latest Qemu commit, but I was having build issues
>>>>>> that level)
>>>>>>
>>>>>> A version of the tree can be found at:
>>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Fqemu%2Ftree%2Fsev-es-v11&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C8287b3e99fdc41c682fe08d85e244ee0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637362858215626678&amp;sdata=1o51C3GUrPwodt4yP6ZlkORcrtSfxLUytJtC66OSjSQ%3D&amp;reserved=0
>>>>>>
>>>>>> Changes since v2:
>>>>>> - Add in-kernel irqchip requirement for SEV-ES guests
>>>>>>
>>>>>> Changes since v1:
>>>>>> - Fixed checkpatch.pl errors/warnings
>>>>>>
>>>>>> Tom Lendacky (5):
>>>>>>     sev/i386: Add initial support for SEV-ES
>>>>>>     sev/i386: Require in-kernel irqchip support for SEV-ES guests
>>>>>>     sev/i386: Allow AP booting under SEV-ES
>>>>>>     sev/i386: Don't allow a system reset under an SEV-ES guest
>>>>>>     sev/i386: Enable an SEV-ES guest based on SEV policy
>>>>>>
>>>>>>    accel/kvm/kvm-all.c       |  73 ++++++++++++++++++++++++++
>>>>>>    accel/stubs/kvm-stub.c    |   5 ++
>>>>>>    hw/i386/pc_sysfw.c        |  10 +++-
>>>>>>    include/sysemu/cpus.h     |   2 +
>>>>>>    include/sysemu/hw_accel.h |   5 ++
>>>>>>    include/sysemu/kvm.h      |  18 +++++++
>>>>>>    include/sysemu/sev.h      |   3 ++
>>>>>>    softmmu/cpus.c            |   5 ++
>>>>>>    softmmu/vl.c              |   5 +-
>>>>>>    target/i386/cpu.c         |   1 +
>>>>>>    target/i386/kvm.c         |   2 +
>>>>>>    target/i386/sev-stub.c    |   5 ++
>>>>>>    target/i386/sev.c         | 105 +++++++++++++++++++++++++++++++++++++-
>>>>>>    target/i386/sev_i386.h    |   1 +
>>>>>>    14 files changed, 236 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> -- 
>>>>>> 2.28.0
>>>>>>
>>>>
>>
