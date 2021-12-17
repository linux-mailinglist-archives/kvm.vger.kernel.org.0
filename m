Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09F47930B
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 18:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhLQRs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 12:48:57 -0500
Received: from mail-dm3nam07on2075.outbound.protection.outlook.com ([40.107.95.75]:50912
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229736AbhLQRs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 12:48:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjWSA2BFCiMe1YlH7pizdSzOvQj9gSsVIkRy1ClKQsTywJpRtSWLFoaj7kBrte9FIjfm+9DjoxLOk4rnHnzXz8oNP2mPZ5OjITxiT2dYSKPtdGZcNB6nHrL8f4sGXWbzDviPlniXLHfWINIi0znHK1+afeAraajoeZzcNkAxUba3OZ2Kmx1NNZ1KjKdpVg/MH3ZzjsVuDcsT0RzpdV+HVtsKEoaD8nKcA64EDnW/zrvTjQVPtd2ALsDnaomOZZq109uF5NBy6Pr39WUMquNd5uDkdbUltUnvYyUp5k2KNMX4YESY3z0AXYiaShX7SS1X7ty0W4Ry4Afj0VUADAQppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbToKbUbBjDm4F788XgWT0Vw1lQPJx3WFD1pl2YAkvw=;
 b=YjflbNMFjyKXjJbLr8I/vN0SwznIvg3b/h5iaB4z9TwReTxtcVcVId1AOfNL5K1xMmbj4+LQ5IL+hq3hVZJlwHcFZJnu1014CqTebJM3o6516bA9bAHMECS/CV+OSXkpB8/XdylAXYOK0s52SX3dR2HcvG5ACM7CEcrjGFA79MAdHtwBcQARrkovQsvprK1SyiO0oWLswq+8w55WLlDOUwJfeJM3UMluG87fmSSQW2WC7lYYyMraZXJ3MGQVsasE/+5exFM8HBh3jFEAGaDS1fI/4revRRCB557A5kK8I5sNLvPzPl4yhviONAgFnYhqkV7Jw9V6KSupF1CWIrO0gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbToKbUbBjDm4F788XgWT0Vw1lQPJx3WFD1pl2YAkvw=;
 b=sf5xU3Qb278Bs3bW7VZt50K2O3gYedFJmwIF4csgOrC44c7bw9ZdyZHGo4lQxLeJgTKL1NYIIf7YBTf7htyLM69G+INT10Nbro92QbEeDZ1yDy2iQ8svx/aNKgIIONXDhysz1oI1BCDtOmrCDycLgyB1QcA3SdOTH8vqG85qHWQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Fri, 17 Dec
 2021 17:48:52 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 17 Dec 2021
 17:48:52 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1401c5a1-c8a2-cca1-e548-cab143f59d8f@amd.com>
Date:   Fri, 17 Dec 2021 11:48:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:806:d2::16) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA0PR11CA0071.namprd11.prod.outlook.com (2603:10b6:806:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 17 Dec 2021 17:48:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cd79d46-b6df-4431-d7ec-08d9c1857d09
X-MS-TrafficTypeDiagnostic: DM4PR12MB5245:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52457B27E7C0F655CD470D1DEC789@DM4PR12MB5245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+kpfAb0zu2BxI9CvOIaJkXw0UBgSJ4RBw4oftf69TR79VXLPFLZ9EiduN0JyYL3eEw1SBh1xEhvpD10Z4P5CxnqJwp++fd2RyhlGGJq2Tok04Ija4p3ZsOLEV/qchRseNWbCuNc8iM/5lxsdMGmi6yoWnC2m0vA59JsVUZgyRMWSdEocI7QNsewY0dEqdREiaoDrZAKJoCloFoLRC+XsRamvQn/lK24XBIDdRWLPHjo67BclfUatGp9jVd8gleN2I0pHt/D8mtp3PNxmEpfJ7K51oHJjnOKfiMWXZK5uTI4QAHjhMPFGAmE0AISgh8e4qOduPAWKbOjwH9CFOL/gFJ6wd9VMBMM/hZLDF5wajYtCk5fn6zba4oCtWeD6+qAevzDx7sYcI4a1GJTHsUrwIok5F8sQ0suwiVhR++t8nOvv5TTVXEeJNsgt4/eAGD76ZF3q4aIRLjrmuKMX86oyjMHNUeQwcq9KZCLSsskopBkrW/x4Dra+IbeFDFJrXyO1yyx9mTF1x2U0TVHjUW/lIyNLOjgwMfFXojECckjKjazYda/fY/MSMTdOzIp3kMxhwD4vfFG4FdycNhMpzqGTdv3T9k8iPbFvR3vebXdH/RUdq05sSd0LG7mo7G5KWIOKdp0PS3ex32EPKgTjxBBfqTKfx2B0OqoMLv4jUlvUrkGP2FULQYEywZG7t2figAq5JgoJ0s4ycRn4DkUO7H0V5TN7LZ7JUGAKVtD1N0bnTAw0NvPRBME5iyK76MMUi9a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(6506007)(31696002)(4326008)(8676002)(86362001)(66946007)(66556008)(31686004)(66476007)(508600001)(4001150100001)(53546011)(8936002)(110136005)(956004)(2906002)(38100700002)(83380400001)(6486002)(6512007)(36756003)(316002)(2616005)(186003)(5660300002)(26005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WENGRnJSSFdMQWxoWU5jQkY0SW1zSGdzUlZpak9UTmxXaTJYTXo2Rnl6SWFB?=
 =?utf-8?B?M1BNUnl3N0Zkczd5aGlzb1RLOW1iNmtCTm1rcXZwVjk1eUtiQ1JqQjNUd1R1?=
 =?utf-8?B?ZWk3UFkyUlJ4YUtjV2dVeWs4VVQ3SW5vVjhmeCtlcEpJWW5Td0R4WlVhdWxs?=
 =?utf-8?B?Z3hVaDRKVkxlSUhUUEhpV2g3MmJockR2MlZGS3QrZFJvRlZqQWhmZmdMMVcx?=
 =?utf-8?B?SXpKNGlHdEREMkh1TkxmZGZwTjhDN1lsWFArTjZEcHBYKzNTVUFMRjRqaEJ6?=
 =?utf-8?B?NzNmWDRHSkRlYkNpcHJ5UnFPTXB3ajZqVytoYzJXU0N0ZlJ4SjV4VlU4L0dn?=
 =?utf-8?B?UHZvWGluVnI3WGhacmFNTWNnOE05dUVzUTkwVzBPUGxQUVVjK09Tdms2Nkhz?=
 =?utf-8?B?RDVhd0hjK2lrYzJOQmxlbzg2WU1hcmhiK3I3RFYrMEppdjBsSXB4ZFlHaENM?=
 =?utf-8?B?MFZHMDFmdTM5cnhqY2pvNUVINkdneUorWVlGdC8wd1BWTUdQZ1Jld0F4QUxr?=
 =?utf-8?B?czdyV2VQZzBoRnVGZTZPYXc0MkZGbGhGQWtOUmZiOFFMWXRtTlBYR1lHallM?=
 =?utf-8?B?bDBqMDNJUDJKSkF4K1B2TVlOc1NoR0NkWHhMR0xnbFVHWTRMa3NQeEFyUm9y?=
 =?utf-8?B?bElwS0NSaDhXOUFGQ2lQNkdXYStFR3RoL05DTzR4MUxIV3hzQzlvelVtOVVo?=
 =?utf-8?B?K3pic3Z1ekJnaFFNOXFmSjRCTFNhUjVTaDF3VFlGQXFjYitFYXpyQjN0dGl1?=
 =?utf-8?B?RmlKbjN2ZXFDaW8yTmVjWU5DR3kvY3pQOXpkWXFIUkJ5eUtmQlZ1RnFMMDE5?=
 =?utf-8?B?TzRlM2ZXV0xpbDQ1cWk5T1ZnMDI3WjJ2dkVqRXEwTThxTnkwem1sazBwbFha?=
 =?utf-8?B?SDh5TitrQnNQUWxUY1ZwbldUbUZVMVA4RDhEU2MxZzlGQXJNMDdwemFiR3M0?=
 =?utf-8?B?OVRXVDkwYnlKbWh5WFZCYVVuWDlGalRVVVdwSGg3Rk9KNWx0a3RNb2ZCdDkz?=
 =?utf-8?B?aVBtZU96ODFXUk5UVGZiRjkyUHgwbWRUSUJzWG5JeVZrZDR1WVpMVUEvZCsr?=
 =?utf-8?B?TUlOUlJDWU8vQ0Z0d2F0R0R4eUJLUE82WDBHWCtRb1h2dFpzNFVVUHc3WlUx?=
 =?utf-8?B?TENWbFo0aGRoTWJZYlVSMVJEWWhjRTdoaDFhQWxtTFhIYkJXS1BJZkxEc0Vs?=
 =?utf-8?B?b1NTUlNLSDQ3L1B2UWdxMFI4WFJVMlk4cFRmOE1TOTJNUm5GTnNDRVpyNkV0?=
 =?utf-8?B?MmE5V1ZDWTRRTXQzYXNUTnJ5NjVZazdVUExwVHFiMm55YUpSWVgrTXV0KzJ6?=
 =?utf-8?B?VlJtYjhncFFwd0d2YXN4b3RYcEVXYi9FaTVkd0d5dk1ENXNLMWZjUlRWZ1gr?=
 =?utf-8?B?T2I2MkVCMkFuTURQQmtqTW9zdjk0SDhRcVZzSUxseThmbTAwaStGNFhvaVlE?=
 =?utf-8?B?ZGJMSURiaEJraVlTcGdDTzhLclB1TmdielR0Ymx1NCt5SXgxN245M2dqYXFv?=
 =?utf-8?B?djkwVmQ5SjJkWFUyaVRDZnR5SnBXZDl2T2pldlgvbzB0Q1AvS21FclNhYytQ?=
 =?utf-8?B?dlhQSjgxVktGNDVaSWx6bUM1S1owVWJETC9zdmk5V3dhajRIek5wLy9JaUc0?=
 =?utf-8?B?MTVmL1pWYmtsc0dzVU5iTkl1Y1BjY2tFZlZUT3NmOTRmZ0lBTXRlUkRLSUtQ?=
 =?utf-8?B?cmwxbitnY0FPQlE1ZjYwcWtJelFYNUNoSTZaMUpmQlUwUVVHSmVUSGExcnFI?=
 =?utf-8?B?Mk9hZU1uQklNemJRcUlpd044Qkhva0N4WEdCMTdwVk9lOEcwZm1CWFU2VHVM?=
 =?utf-8?B?MUthVytCejZLQzlNVWE0QjJaTlBBa0lSeVhVd0V6bzloZFRNUE5zZ0MyMlZl?=
 =?utf-8?B?WkhMRmVHWEhJSjRZY1U1UkhnMW1GeE5KMkhPb1o1MERZSEhjVWFYeXdFWW5v?=
 =?utf-8?B?NDhGNXMzMG04eDljekpVMjNReVYzMVhPU1hzNXhFR1R2b0tUNHhNamlyZkRq?=
 =?utf-8?B?SEg0YlF4NmJvNXYzNTVOT0k2T1pIalRpUFRiOXlMSmNuYnZnSDhzR1BUaG5H?=
 =?utf-8?B?bVRlcWRuNW8yc3VoNU9KVm9OUUZvaXlYTjdnYWo4cFpaNWpCSGdWczRvOXlP?=
 =?utf-8?B?VjBGRnp2UllSaE5GQm05YWlLVkUzK0JTaVRVb2k3dERXaEZseGF4ck9OakVl?=
 =?utf-8?Q?9Mi6G/xYZ6K+e0ZGsFVeanI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd79d46-b6df-4431-d7ec-08d9c1857d09
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 17:48:52.4185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5s2l7miwEgaerbQFONmca2MppswnswDFmzMsS7JK8iodIHAxrTYrm/cPG142v7fSaj9L9c4iboBJgNdXxdLuFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 6:13 PM, David Woodhouse wrote:
> On Thu, 2021-12-16 at 16:52 -0600, Tom Lendacky wrote:
>> On baremetal, I haven't seen an issue. This only seems to have a problem
>> with Qemu/KVM.
>>
>> With 191f08997577 I could boot without issues with and without the
>> no_parallel_bringup. Only after I applied e78fa57dd642 did the failure happen.
>>
>> With e78fa57dd642 I could boot 64 vCPUs pretty consistently, but when I
>> jumped to 128 vCPUs it failed again. When I moved the series to
>> df9726cb7178, then 64 vCPUs also failed pretty consistently.
>>
>> Strange thing is it is random. Sometimes (rarely) it works on the first
>> boot and then sometimes it doesn't, at which point it will reset and
>> reboot 3 or 4 times and then make it past the failure and fully boot.
> 
> Hm, some of that is just artifacts of timing, I'm sure. But now I'm
> staring at the way that early_setup_idt() can run in parallel on all
> CPUs, rewriting bringup_idt_descr and loading it.
> 
> To start with, let's try unlocking the trampoline_lock much later,
> after cpu_init_exception_handling() has loaded the real IDT.
> 
> I think we can probably make secondaries load the real IDT early and
> never use bringup_idt_descr at all, can't we? But let's see if this
> makes it go away, to start with...
> 

This still fails. I ran with -d cpu_reset on the command line and will
forward the full log to you. I ran "grep "[ER]IP=" stderr.log | uniq -c"
and got:

     128 EIP=00000000 EFL=00000000 [-------] CPL=0 II=0 A20=0 SMM=0 HLT=0
     128 EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
These are before running any of the vCPUs.

       1 RIP=ffffffff810705c6 RFL=00000206 [-----P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
This is where vCPU0 is at the time of the reset. This address tends to
be different all the time and so I think it is just where it happens to
be when the reset occurs and isn't contributing to the reset.
   
       5 RIP=ffffffff8104aefb RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
       1 RIP=ffffffff8104af06 RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
      15 RIP=ffffffff8104aefb RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
These are some of the APs and all are in wait_for_master_cpu().

       1 EIP=0000101b EFL=00000003 [------C] CPL=0 II=0 A20=1 SMM=0 HLT=0
This seems ok because: CS =9900 00099000 0000ffff 00009b00
So likely in the trampoline code.

       1 EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
This one seems odd... could it be the one causing the reset?
CS =f000 ffff0000 0000ffff 00009a00

       3 RIP=ffffffff8104aefb RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
       2 EIP=0000101b EFL=00000003 [------C] CPL=0 II=0 A20=1 SMM=0 HLT=0
      99 EIP=3f36e11b EFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=1

Thanks,
Tom
