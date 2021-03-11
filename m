Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17479338009
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 23:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhCKWEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 17:04:45 -0500
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:41107
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230493AbhCKWES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 17:04:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTHknqr/tAJ7Ao4l+iXTAPvt59J1g0NALkOaV5qkFJKAoaFhPWyqGUGeAkg05EOpYUiavq9BsrsEdkwyECMj3zk7kIKpBKSfsXkGZWp6pisKuu9oeYe4XAuqjyT/WwIFMsdWYN9nG6t2a6YTJKgb3hTNyEj77mTFLs3Q/W/vewVqSx1+hSKPKhCrljCjo0J0GDE1IpGNxIKqCGtv5CILaoC70/hsMCjGsVpuz+UV9t7q2DyStLmV0QhJtbV2+aHNcxg/FTIzaSFDayew8CNDxWxPW2INJIcc6KbyPtPZV/UgRxzVrvN1xE5AXZcsyszq5WwzXL+yn2nC46vA+4gX0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ03CItfiDuasLXJpiH4gzuYe2RHfxiUwic04Iy7oiI=;
 b=lDr94/ekaHYVxNDZdwUKsCXwfmEmZJIEEGlEAntjk7x64np+R1IW5jBDhK2bpyDncYyX4oJ4ilxqnW/89GC6pGkou4FQXpKCCjIXxrBPoexIlYkVRe3UykCaBvks98o8k+p/uD1O+g5EuzjNrkpjBOkyMRgdNAd8mLz19tzjA5SjRnKYimIvvj8s9j+SYB4BK+wdJDuEDNijgpMtXv+uR/3HibEgq0Xp8iUEvqiXr0tuv48tvLItrx5m23zokscjxP4bOaikqVmh+D9oAT0HbQSNiyKfyTDN5vVIjfPBX4x30dqlUfGPjDLZWNL0vzslYP2/FXJ7ofnpPumbRwzYcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ03CItfiDuasLXJpiH4gzuYe2RHfxiUwic04Iy7oiI=;
 b=Jz/YbdGMhGCB81/+HEePH+M3/EjolPPv4wUyOUpI05xFM4PTiHQ01P5tln6IhvKtb59G3FS9ZO1n6TLSH0/NNB+jXz1PsGnctT3dEiIb921HAHfRsbF2wFxVznu8SCSj61X3a8UY6CpsP4bF0y/aiRV7qKaZOBJdKbZAGzZLfZA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2592.namprd12.prod.outlook.com (2603:10b6:802:24::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 11 Mar
 2021 22:04:14 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 22:04:14 +0000
From:   Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
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
Message-ID: <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
Date:   Thu, 11 Mar 2021 16:04:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210311214013.GH5829@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0163.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA0PR11CA0163.namprd11.prod.outlook.com (2603:10b6:806:1bb::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26 via Frontend Transport; Thu, 11 Mar 2021 22:04:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea2e95e0-d4aa-45a8-906b-08d8e4d99bdf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2592:
X-Microsoft-Antispam-PRVS: <SN1PR12MB259238047EAABE9DF8D7C3EC95909@SN1PR12MB2592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bDh9MlEqQemv4npzoDa20uZlqtVOdfITzr9uw0soUNyTL+5gSpTUMc7+VKKHLsX29TSDQo/u5AMfsm8yfI6GuF60WaEmaAAa9JmP+B6dpnmbJrdCigu7mfNSruhepy1g55EHwwKQdCmiSj4fB1s5mspBSbvEX8Z9bcGcqT1/KCBhM33LM1YDgWUU+fanlXRfZrVFtdN51ofB77bWpuXo/8gmpUBLHDyUcL+m8a/AO5+BhC+S5WssuWeM2bHA0IJBmVBdXk4m2kcU3Ke7DLaEeIU66GwqrgCG7JbZdoxnD1BxQKGf+I6dvjdBGTVUJ6KwXg1GkWc+okbIfniJQLULawy3Opep6WdQSTPB1fbX1Cp0u2SQMCSce0TOb80JvRlSTSSGIQfJw3iF80SazlmMhqb9B4csd67KSqCUKViAXNUGZcFcIVRMNdE98kLi4xG1cqQO/+hzvgI2jWXVTD57Q7UIi09NyAAP055qPV8shlaG6uSJCxRsLbKnZjonrBVCq5e+yKQnt6Y3/L+lnA2c8ik8QMCPez9xX3Qd0YJ4hfuhpaU4co9uctRKYk7aB9u8yJImw0jDkRVmZ8Wp+03kNwyI4XqjijUvUQO01tTQivw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(31686004)(54906003)(66476007)(186003)(5660300002)(6486002)(16526019)(316002)(52116002)(31696002)(83380400001)(86362001)(16576012)(53546011)(36756003)(66556008)(66946007)(956004)(2616005)(8936002)(4326008)(478600001)(26005)(8676002)(7416002)(44832011)(6916009)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UXR1a3FrdWRSNlNQL1lsVUhNU1YreUNGTXpsWDRvSnZhQllGYVlYWFhid0VV?=
 =?utf-8?B?cEs3QWdRZllJT01yMTdGSSsyemJ6TFhzNmxsQVRCaWo2U2tacDJtaldZanBN?=
 =?utf-8?B?VG1yazR6eHFoeXV4YkNNMEpZakVuK0ZxaDcrZXJ0bms1UkFJS1dxdmt4bzN3?=
 =?utf-8?B?NzFwM2Z1aXEvcEl3TmFVWk44ZVRrK1lYS1B1anhTc2Q4R1hlZU1MYmFoUjRo?=
 =?utf-8?B?eU1UWURCNEZ2b0cxbXBNbFJtaHVHWUs3UWE3M25UQVFFUFB2disrSXdiaW14?=
 =?utf-8?B?V3V5WmFocG94UjdZYThZc3RWVm5lWWRFRWFOREhaWDVpc0p0ellOSkJKTUFJ?=
 =?utf-8?B?YUkwZ0l4RDRQWTZEWW1iWGFzUlF0WmtzckNFUkN3SDNnZDRYeUVYMmtqZU12?=
 =?utf-8?B?NjJ0ZkVweHZNcUQ2am4zVEpBc2ZWemYveHUrRjM1NkZaMmV2WmNrUzZFOThT?=
 =?utf-8?B?TDYrRm5Eak5YbHJjOXZybTNxbVFRbUFGcUFXd3ZsVGt3YitvbnFDdVpiTHZR?=
 =?utf-8?B?MHdtS1c2QzJRWkRHVUxRMUxvUlhPNmNvSlZSQ081Y3VNeWFPM2xPd24vaDhR?=
 =?utf-8?B?WHk0VEYwOGNOS1JpcUNDQko0NWU5djVUQkFrdlQyd3ZNY1huNXJyTnVyZk0x?=
 =?utf-8?B?dDhIYmFnQVdhL2MzdUdYUHlRZWtTUjMwVThpK0grL0FIQTVodkZtK1RJamov?=
 =?utf-8?B?a08ralZ6Rk52WVhNQVN6cHBtSGlGRTVMU3ZhNjNiVk5Pd1hNVkk1ZmxuYkZR?=
 =?utf-8?B?dE43b3RxN2NTclJpLzFtQU1aWmZsY05UOWRPVWJPVitWNzNCZE9ML28xemsw?=
 =?utf-8?B?R1hUbUNzV1ZtTXZPZWhaK2R1bmxXNXI0Vmk5S205MDU1eFlySGpLc1JsRUh0?=
 =?utf-8?B?eTAyRmQrV3dRT2F3eStmRkcwNjJlZC8wTEt5M3hndUtMUGZ6S3VsTkRVQnBD?=
 =?utf-8?B?bFBNYnNHajZUcjhUdE5KTmV1Vmc0WWVYd09xTmZoeHJQQmJoU1dDM3VQQ21D?=
 =?utf-8?B?UjZ3RkRPaUJ6d0RDMW5nUjZKZVVveUlIczJqVzRtbnI5ZG80eFRPblh5SGN2?=
 =?utf-8?B?V2NxdTluMEo0MGR4RWYrVnYyYmhQemVHbnBmdzFqZVU0UG81ZzFZUjNYMDBJ?=
 =?utf-8?B?L05OejhpaWprMlBkK3JPVzk4ZnAwMnlrYThqUWU0NEQ3UlRqbUVnaFJjdDUz?=
 =?utf-8?B?QytuUmVpc3dMcXgvUHFPLzRxS0psbnVDUlZveGkvZEU2M2o2ZExEcjJITEdZ?=
 =?utf-8?B?R3h2SDBBRTV2QU9qSnl3US9yUmYzcm53Qk1JQ0dGbWZJRk82MUF6QnJsTW5F?=
 =?utf-8?B?ZmdOa2tLRk1oVmhFS1lKS2UzTGtnb0VhVWhNeFFWM3hobG9VLzFOajRUeUx0?=
 =?utf-8?B?TmkzZWlreFZPazhPWWpPR0xtYVl6aVlDbmZJa3RORjVFS0pnMmF5Q3BEVVVs?=
 =?utf-8?B?b3EzT05RQVdKSWVZTUw1QjNPYWxWamxhbUxBVld2RFUvMGtOcFFEVWtyUGpD?=
 =?utf-8?B?S2JFSDNaS0tUK2UrVWF0VitjKzlCZTZSOFVPM3FxQXB0aytPUzR2emRpUlgy?=
 =?utf-8?B?dDdtWUZKQmVTSzd4R0RiaFBBMEJweWZHYkZ2WDMrVy9YUHRaZDNrM0drRlc4?=
 =?utf-8?B?d0F5NVhGdEhXU2JNd1VVbFZYS3NhRXM4QjFianZsU3JPQnB2NXhRRUt1MTJs?=
 =?utf-8?B?aFQ5dlZlK0F2TEZzNWh3ZFJ2amtIeGUxMW9wcjZTQy9PVlN1c1c5NnZYbzFF?=
 =?utf-8?Q?n4LrYvKTBUVAH9e9IC/jov5KUsKRdWFl32IppQn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2e95e0-d4aa-45a8-906b-08d8e4d99bdf
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 22:04:14.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkqoWxZy6hx+6Qv17T9O2oyfYNPFEmViZAEMnO4zjDRqONELkOlHD6SyI7N8U/0l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/21 3:40 PM, Borislav Petkov wrote:
> On Thu, Mar 11, 2021 at 02:57:04PM -0600, Babu Moger wrote:
>>  It is related PCID and INVPCID combination. Few more details.
>>  1. System comes up fine with "noinvpid". So, it happens when invpcid is
>> enabled.
> 
> Which system, host or guest?
> 
>>  2. Host is coming up fine. Problem is with the guest.
> 
> Aha, guest.
> 
>>  3. Problem happens with Debian 9. Debian kernel version is 4.9.0-14.
>>  4. Debian 10 is fine.
>>  5. Upstream kernels are fine. Tried on v5.11 and it is working fine.
>>  6. Git bisect pointed to commit 47811c66356d875e76a6ca637a9d384779a659bb.
>>
>>  Let me know if want me to try something else.
> 
> Yes, I assume host has the patches which belong to this thread?

Yes. Host has all these patches. Right now I am on 5.12.0-rc2. I just
updated yesterday. I was able to reproduce 5.11 also.


> 
> So please describe:
> 
> 1. host has these patches, cmdline params, etc.

# cat /proc/cmdline
BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.12.0-rc2+ root=/dev/mapper/rhel-root ro
crashkernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv=rhel/root
rd.lvm.lv=rhel/swap ras=cec_disable nmi_watchdog=0 warn_ud2=on selinux=0
earlyprintk=serial,ttyS1,115200n8 console=ttyS1,115200n8


> 2. guest is a 4.9 kernel, cmdline params, etc.

I use qemu command line to bring up the guest. Make sure to use "-cpu host".

qemu-system-x86_64 -name deb9 -m 16384 -smp cores=16,threads=1,sockets=1
-hda vdisk-deb.qcow2 -enable-kvm -net nic  -net
bridge,br=virbr0,helper=/usr/libexec/qemu-bridge-helper -cpu host,+svm
-nographic


The grub command line looks like this on the guest.

cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-4.9.0-14-amd64
root=UUID=a0069240-cd60-4795-a391-273266dbae29 ro console=ttyS0,112500n8
earlyprintk

