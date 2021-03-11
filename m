Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C843E338016
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 23:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhCKWQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 17:16:12 -0500
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:40636
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229827AbhCKWPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 17:15:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An1+bOoT6Sm8jqC0UmzcHSWr9IqjvsdRoH0W0hVzOGNHkgoE5aV0UZEXGWWsPwBFbGnkNX+hCjKAWV3fPRvIUnu5CD7RbtNPLG7TlQFRvQ6qeSpD9cpvGw2VPAoQocXjQ9jVYYEUEdpewhsYZlfBvyf6R9ObixmcR1MlPx4a3+yxfs8KAvBWbH3Cqv+8H6VbexvBZDn5stMT5ghkhulThc3E5fYGSygcXMs8rV+8jMGhFQplR8IWYxwBiNKZ14iZtKD9YZxi1wb6jxTxv4EEPxrDBmDIIZEcgCkjX7w5mjQZI6xki4sBONoI6d+Wd5UwDXCS83VXkTs3m5ly1yvEQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uoh1Y8LbfFilu+peCDpMwtO3jffraW3Zg6oIhcQks0=;
 b=E0Z2UJa6Jme4dtTw+CofJMdFWX9XgNsSYv9KWNJ5lPAxo8Szhbo729CQphSPQTuP/CxaFmpL9DNCTSdrwtLPo+aqjhfzE2U0HykGu0JEWmrPYCYTHr9s/LeIbdtoK6lDd9/tMEgtDcd76O69FaZsoOdyg3p/8TBZ4V7vjeN0BnjlqaQvwyOjloLkWa8nyz00xv1qEIQ1soZEeYH9zv3guRVga7Hlj3LKvqcprwiZVgkx66+59hOEzAQMicUkpOp2MNGoeCHFqceC0/ZierMh47leNPZL27Xtcm2+AXx3zMl8zkO75KPedCHWYNfMmxMYgor13N5DaFksgl0Tv7uS6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uoh1Y8LbfFilu+peCDpMwtO3jffraW3Zg6oIhcQks0=;
 b=QoKG98h3RHejwfuP3Yb2K2m4OqpaGOFQaSk6Ca218H4bWaSyag/RdjcZoEb4zjl+L1Osup7TAGoLdAKtLypkQ5LTHypdfGQB7dVECiFHcWXplgMbIvTWzclQ+jP0gYfIyG1BYPDzbGbPRelk+lw+RSmqlD34xjVA/7SGuUoBJPQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4560.namprd12.prod.outlook.com (2603:10b6:806:97::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 22:15:39 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 22:15:39 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
From:   Babu Moger <babu.moger@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic>
 <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
Message-ID: <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
Date:   Thu, 11 Mar 2021 16:15:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0034.namprd07.prod.outlook.com
 (2603:10b6:803:2d::15) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0701CA0034.namprd07.prod.outlook.com (2603:10b6:803:2d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 22:15:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 39baa611-7369-4c40-bb17-08d8e4db33a8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4560:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4560CC473D466CC9012837DE95909@SA0PR12MB4560.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6npeGpS+q2M/3Y29XiPrfYy2PFuoSb/NmpkFtzBzzn+Cmb/u2e0kMQnvPgoa09F9YbOnlPJyG72mhwHbhHu5Skaf4gPwOcwpoMGbhCLPsEZ7FI7btkIfaJt2ZTLZPLVWAuIuF1uMRbJ72p/L7zNa5eYs+ndGJ3gY6lBWeC6Un/wzK3LlbYXivv7ktWFt6JAQmSqBw07vl2OKWcT7rvD0l+qpV+Kjr2rdC4ZJsiFWCxgxw4HyJ2DOqqr0jCBV8UJIr9RqnKDg82zLccwJ+/i2tMhYMLz0dSY4lt4EBR3etzQFC28aZq/agoDZzSWer9ZBvmRSXKO1F+8K+IpBp1KjQ+6sx7CNqa6T2w7agjA5i2E/66G9vYbXH7+m/vZkv9IeH5JYZYxbf/2wD3DRboA6/ZPmp1Bzs9nNk5HuT0GASy4N7ePbuvFv0CCyswy54lzpq6bIKKyRp9zdk7bASInsjuDTgt2GEd6vk1zaFKM9ojSTs/zldf47q2xmI42Mjms/mkMRLc7I0S11lmRurKl+NmMRiatmqZlIIcwfsOhHHBTWIEzo2NCXuEKprVkb7Ss8MUwBhk0sd8gUYuDNpAxOZQuFb3B1EpZT+GxD55hmXThY3TL6RBtobBCKFYjZNVhNbln4T33Ce9wjqskwa7/Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(5660300002)(66946007)(83380400001)(16576012)(66556008)(4326008)(44832011)(66476007)(53546011)(8936002)(6486002)(52116002)(7416002)(86362001)(8676002)(6916009)(26005)(54906003)(16526019)(478600001)(186003)(36756003)(2616005)(31696002)(956004)(316002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MEJIWGVQZmNnVGR2S1hLb0Fqb1F2QXcwc0dvN2s4QnBWbHMzcUtDaUMyS1ph?=
 =?utf-8?B?U25xWDY1N211a0d1OE50a1lLVFUzY29mRXVLNU1TSThLQmFrZW9OZW9meURv?=
 =?utf-8?B?eVR2YzdTaEpGZ1dUS0FmY1NPVXZzV1dXajRuSEt1ZWh6RlJXSVVhbm9uenpu?=
 =?utf-8?B?MWVHQTA4OUtPNXJrM1NnRlYvajB4TkNSTWlSOVR1MzhKL2FUcngvUWhtcjZl?=
 =?utf-8?B?SEV6MzVTQnpUS1VzS2wyTU9XVER2enJKeHJKVFYxbGx0QitFVUppU3kvdkJY?=
 =?utf-8?B?b01saERkUGFnSWV3Rm1CTlE3STdxa1cvcC9JWGdYM0RmcWYwVUgvQ1Rnb0J6?=
 =?utf-8?B?N0wwdFZ2RzBEQ0t1VmhNdjV3VVgyZzZjakdDb3JjcFpaNzE2OFhZbzVldEgy?=
 =?utf-8?B?U1hKUVFRY05ESVBneXNkZHFxeUxtenpFeTNwL2xHZzVSaTdFcUZVSzNBb3Ry?=
 =?utf-8?B?WTZNSElvejFHeUhyTVlKU05DZCtJSk40ZWlVMVVTK0ErKzllMzhOZURTRTF1?=
 =?utf-8?B?NzZ1WjRnUFdCQng2TURNa1JTa2lxQjdYeEQ0RFYxMDVHeGszTUxwL2NyTjBm?=
 =?utf-8?B?emdSS05OMm5zVEdFWlh5VWVIVU9iYkJVTjAxdFFnL0NsL2MvdTFLL1FvaEZq?=
 =?utf-8?B?WnRJRkVyRCs2VmJZcERjVUpLamNib200YldCQjB5THRDN24zc3ZaenQ4d1gy?=
 =?utf-8?B?K2ZaZGF1bFA5YVFFTkpKZktSQmhpV2lUOTE0eW95c0R4ejh4UmdWZjFyN0F3?=
 =?utf-8?B?NWFRaE9TUVNkaDNoTkYwQnNjL0hNaS9ZaDd0VzIxQWt5ZTNRQ0ZoZjdUQmJS?=
 =?utf-8?B?MXBuS3Z5RXhFOGxlTzdWczFXcG9kclljdU9JZ0VLb1R4WDA4QXpNMUdHVUxZ?=
 =?utf-8?B?U1Q0UzYvZXpuclI0eFB1T0pRVUVUTGFjWit5RVRHVHNob0Q4ekR5VXJMNlNE?=
 =?utf-8?B?SUhDS2FWanRNTk1VUlJZZ1JVMW56MGhtOFBqZndaM0Yxa1VjbmdMQXlyNGpK?=
 =?utf-8?B?a0ROSGc4c2toakZTS2kzSzZqdWwyaGJsUHp2OXpRRUppOWVoNEg3TGFKbUlJ?=
 =?utf-8?B?MWRtOVladnZGQWlwUUp0ZkREN0ZLZTVmMUFhRnZMckNFSFZCTjQrZHpxYzhv?=
 =?utf-8?B?TUM2Z2hwL1JxTjhoekQ5ZCs4cE1uRFhqYUtxVDdlalJKeFl0VVo5bHh4VFRI?=
 =?utf-8?B?dFo0UWIyTEhwL05EMlB4eSs2MXVvcUpRZUxCSHdXdGtxcmZEbU1WSElPSWZ2?=
 =?utf-8?B?RHpwYXA1ZG1qQm1hTytpT0RKeG5ZbVFDK285dFkraC84T1FMRHo0TzVvSTFM?=
 =?utf-8?B?ejhpWHhqWm9DRGxLc2NuK0l3ek5rTHo2QVhDaUZDcU8vN3htZC94ZERodS92?=
 =?utf-8?B?UXNxYzNJSjdXcUlZWW5tTU1ab2QxRmdzRjArQnNmUWwzb1IvQy9YNDc1YUxI?=
 =?utf-8?B?dW5iT2lPamJMMTErbmFKZUJobFd6YlNlRitaa0k4Z2ZMaFRYTDBodVJnSkJp?=
 =?utf-8?B?bDQ2NjFBM3lYNEtGN2F5RGRMdmcrbmFJaEk0eGJ1ODVwODVLUUNicWtUN1kr?=
 =?utf-8?B?WEJtNkZRQWQ5dU4xOHR4ZXNBcHcvOXVUMEFKUjFsQkhESncyaStWblBtTm5U?=
 =?utf-8?B?U0dLYUt0dGNZdHpoZGt2MlIvZHZVYnM0RTdQVmQwT096WFRSM0IrRGpZMk12?=
 =?utf-8?B?QlRoR1R0eFhKYlA5UElucCtpV1J6bkhrcXlPU0tIeHY3STZpS1ZMdUlCZnBZ?=
 =?utf-8?Q?54xIvHVQCYfbrjlAPFtQ6MoSO8NCxSVLYblq5I3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39baa611-7369-4c40-bb17-08d8e4db33a8
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 22:15:39.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +grMZFiam9yY7ThDaXKFsH3L7ynODwJQ3xgkimH7szbpVSHsEGxH/YdqUp6Pi9G1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4560
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/21 4:04 PM, Babu Moger wrote:
> 
> 
> On 3/11/21 3:40 PM, Borislav Petkov wrote:
>> On Thu, Mar 11, 2021 at 02:57:04PM -0600, Babu Moger wrote:
>>>  It is related PCID and INVPCID combination. Few more details.
>>>  1. System comes up fine with "noinvpid". So, it happens when invpcid is
>>> enabled.
>>
>> Which system, host or guest?
>>
>>>  2. Host is coming up fine. Problem is with the guest.
>>
>> Aha, guest.
>>
>>>  3. Problem happens with Debian 9. Debian kernel version is 4.9.0-14.
>>>  4. Debian 10 is fine.
>>>  5. Upstream kernels are fine. Tried on v5.11 and it is working fine.
>>>  6. Git bisect pointed to commit 47811c66356d875e76a6ca637a9d384779a659bb.
>>>
>>>  Let me know if want me to try something else.
>>
>> Yes, I assume host has the patches which belong to this thread?
> 
> Yes. Host has all these patches. Right now I am on 5.12.0-rc2. I just
> updated yesterday. I was able to reproduce 5.11 also.
> 
> 
>>
>> So please describe:
>>
>> 1. host has these patches, cmdline params, etc.

My host is
# cat /etc/redhat-release
Red Hat Enterprise Linux release 8.3 (Ootpa)
# uname -r
5.12.0-rc2+


> 
> # cat /proc/cmdline
> BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.12.0-rc2+ root=/dev/mapper/rhel-root ro
> crashkernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv=rhel/root
> rd.lvm.lv=rhel/swap ras=cec_disable nmi_watchdog=0 warn_ud2=on selinux=0
> earlyprintk=serial,ttyS1,115200n8 console=ttyS1,115200n8
> 
> 
>> 2. guest is a 4.9 kernel, cmdline params, etc.
> 
> I use qemu command line to bring up the guest. Make sure to use "-cpu host".
> 
> qemu-system-x86_64 -name deb9 -m 16384 -smp cores=16,threads=1,sockets=1
> -hda vdisk-deb.qcow2 -enable-kvm -net nic  -net
> bridge,br=virbr0,helper=/usr/libexec/qemu-bridge-helper -cpu host,+svm
> -nographic
> 
> 
> The grub command line looks like this on the guest.
> 
> cat /proc/cmdline
> BOOT_IMAGE=/boot/vmlinuz-4.9.0-14-amd64
> root=UUID=a0069240-cd60-4795-a391-273266dbae29 ro console=ttyS0,112500n8
> earlyprintk
> 
