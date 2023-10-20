Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FCB7D05EC
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 02:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346811AbjJTAoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 20:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346767AbjJTAoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 20:44:08 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14B8FA;
        Thu, 19 Oct 2023 17:44:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYojC0vHRbqR8J1sAoEIlNzJnOuVLXqa1y+OWUcR4sJN4yzwbez7riQxus8YkyXlIS/L+Lh84/Z1uGIAg3GqIsoQu/5KkcCkOHRXjcr4KSlDKWP1vT++MrG8Zw9hL+BVbDtnT8NVw5JHnIrkbkDDLa7m1dCSC8lhydMslA+GeXWPj8rUubS+JYbSCIsyde46c5eg/MVeApBubnwq69LEJ74N82w4naI+I2cpzZu2ElvUBzTpZ5wg8M02A0+/UcqfjtzlSzuWfLN+F6KDKIS5GNTXSGSP5h+1SEZGHrzfSkOCfNJ6WDOqT3vzSsiBgX4lkmfcfR0GB20kIytoCEaNXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMgIm/ehAmqey2MOX1hwVa7hqKrH9Ffe58BLMV/epXE=;
 b=WmJJliqxe0chLSPJX8BRR+GZm0nwlpY4d/I8PsN+bQWaLXbzM+u7XnJXgrb98TRbCNQAea0KSqMWotiPYoFjLQGy7dlY1okXfm7+1P8oztqEYRJqLqPZQZTQr1O2o4LKKzcBdZeA7ZHOKrPhoRVANLcnIir0GoXrLEdD0q9oIO351u1Ocm9GH46W+4f3+eZa+8ej5UW+6rCVAfSilb/a2BFTAkVfHBaPQBR2OWsQhljB2mGS10N6qcSrm/Nn7X8pD0uEsuvqYWuOBvRaLX+EcFtIOF4aq4ghB0E7KWsUv80SB53D0LE7EVhhg7Avg/GRJj3USntIkedJoackCz5TSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMgIm/ehAmqey2MOX1hwVa7hqKrH9Ffe58BLMV/epXE=;
 b=1sPrYAhsPUKUBVFjX7yUg5AjR/dTsggy6I2lzci4ETuC3dH/iHGisPs2b5JReXs2sqBfuPPLtoXt+7Hm8X50QG0IeX6gB+iubmhtMvydHQQ5pM1FN4EsX/iyWIVsSYbE7Wpg9tkpol2pC3UFC2Bv+0SM/OAPcYIzc0xLQb0Rsyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Fri, 20 Oct
 2023 00:44:04 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Fri, 20 Oct 2023
 00:44:04 +0000
Message-ID: <eea3a2f0-8aae-435e-b839-3f21c4a8e2e6@amd.com>
Date:   Fri, 20 Oct 2023 11:43:38 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <924b755a-977a-4476-9525-a7626d728e18@amd.com>
 <ZTFD8y5T9nPOpCyX@google.com> <2034624b-579f-482e-8a7a-0dfc91740d7e@amd.com>
 <ZTHGPlTXvLnEDbmd@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZTHGPlTXvLnEDbmd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0071.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::18) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 973f31b1-32e3-4094-3e40-08dbd105a8b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4P6sAQxb4G7RbpGIE8cDnA2cZkDnzpzvjWd2RD8a9eGhytPSfwHqiK0yNZGlKd3gz96vupuBSt1en5gWN1WyNNHAJtULtG9F7YHBeQdC+uAl5SdCnwyGe9jRk4VMo91i1fEgW3In9nd4IowNBrdMLBdDYhODxISkDfRCgpnFI7lyBzaf8R6loGQPA1SxAcKDUZDi58lIn1ca1jM8Ykpk+ky8pUywVKhjqi56EnTQu2OsjOTlIkY8W9JVUMZ9Yhtjh7Qvz4jqa+y9muKjUUWhOGxsKpn3jncOKuXEk+8DBDNq6bYirgoGnE24+AlLDu5ikjuDWe6XnAtxF3TJg87vbFrm38p8UDvSW9bbuaqwch8KS+tiNu4eO32UzSYHPDfYDh4cT1aXpYnV6ZWLD4wLaX/aWjYeNn0PxPKd3lbT0Rpm6fthpQzmoS134h0JPSw31Sh5SCL0uS+PoayIjcmG5nBBIMgnuelXQL/MNfz3Bftdv64PptjjsX8GKyVY6KRh4HSEPaNBP1mIpWVu1PGI6bRD+LCL05lWyL5L6EMO77lAngCalZr8jFw+I9JyjifEW1lWgGGYUOL99nozPJF4ELCOwCV8Dy4wYwztkoLEmvXbBmQAv8igr3sUag9uPYiEt1h5MtYiasoPjd5S3RcLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(31686004)(38100700002)(66946007)(316002)(6916009)(6486002)(5660300002)(8936002)(31696002)(54906003)(7416002)(7406005)(6666004)(83380400001)(8676002)(41300700001)(66476007)(2906002)(53546011)(6506007)(66556008)(6512007)(4326008)(2616005)(478600001)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVFxKzA1bXBYMkZJT2xLRXAvQlhRRDhSaUZGVVRyUnhYZUI2bEEzRllrQTFH?=
 =?utf-8?B?eUdDdkNUaWovK283amJBanMyUzRDSitpWjN5Sk1tUE9Oc1NlckpYcXdRcjgw?=
 =?utf-8?B?RG9Sc3FUU3VxMnVYTDJ0VzFFQU1GMk85R2ZRb2ZyOEtjMTlSVWh5WEhISVd2?=
 =?utf-8?B?ZE1oQU5GV2pLcWw3TEVYREZXTFZvRWIrVUNmc2hPb3loeDRNRlFtMkpPL1ZK?=
 =?utf-8?B?UkNkcVRWaE9DRmpFMmttWVhCRWRWT0p5YnVkZUx6aDRhd1pYMXBPRGY2cVBI?=
 =?utf-8?B?bkdUMjlXdXZPZkJ6cTNNMWdWbXJxeGViM0lpMWRJR0J5cmZHWmFwazUwalFN?=
 =?utf-8?B?WlpuaUJVNDNUQ3RMNVBHNXUwKzRDQXR0dWNhNy9DNWtvWEloeWlxMjczSWQx?=
 =?utf-8?B?cTFwcEJRY1hKOHJmMDNoa1hsa1NaT0d5MU8zL1dVaVFOVDIyVU9KbTlVSzZL?=
 =?utf-8?B?Y1lkNkZGdG5aMHdiY2R6RnEwOHVNSDBkTDZkVG5iVm9rRGZJejN2THFnaGU5?=
 =?utf-8?B?OHVEUWFidEZ1MjN0QzRUR05nQzY1SUlIbFZGc1BZNlQveVNoYXpMQnl6ZkJC?=
 =?utf-8?B?YkM3UXpNVXlzNXZ5WTFiUkpxVVpmbUlDK1FleFM4YmRjK1ViV3h3UmVlN1Vz?=
 =?utf-8?B?bUF0NmY1Ylk3aUR0V1dnUDNidDhpWWJIRktMcDRNUE56M1Jjb2xJMWhNajdC?=
 =?utf-8?B?ZEZFQkNmR2JDT1Y0T2xzdTk0LzBZUUdta0ZuSi9DMWYweDNRTW5ZRytxK3ZK?=
 =?utf-8?B?eVVaZkRQS3pQd3BBMmNha2xSTjFWYkVTT2wzZGJYa0NJaEo0cUhaY3psM2M2?=
 =?utf-8?B?M0RYNkZXZU1LRmpBbFdEbHgrZENrdUhIeFpMa1EydXJ0WVZ6TGJvWWJnR2Zn?=
 =?utf-8?B?T28vQ0Z3aCtjb1oxMU43aWJjNFp1bzZpYXBuSy9RSVZUMVFkVFhVOHBoRjI2?=
 =?utf-8?B?M2UrVWxpQmdhZnlGZFBQYTBDaVFRM094WFE5ZEQvYk9yeWlsZzBUeithajg3?=
 =?utf-8?B?OFJoOHFYMzRVZGEwcE9DdEFjeVBjdmVXYlVLMHNOUHBnZUovKzRwczJkS1FZ?=
 =?utf-8?B?ZUl2RDI3U2w1V3hsT1NhdDU2K2kxNXdraDN6QUxma3FNb0V2Zk16RFZ0c2Jk?=
 =?utf-8?B?UE53eTdrVWxkWlkxd3l4OStzSUFvazZna3ZmMXFCcFpjaFVibks0cS9zZHdv?=
 =?utf-8?B?N1lYWUJycTB2UXBhVlhiMlM5cE5NV1pRelFxbnZFRWVKV2ZQQysrUlNUcS82?=
 =?utf-8?B?VUZHU0ZQSjhYNVRWZDdENXdPZzZyMi85VS9wM1l3UUFNRnRSRjZ5YWJJMDhS?=
 =?utf-8?B?L09jT0ZpWWtNV3E5ajBBUGhaeW1zdDVjUm5PazZDSzBuTWVjeDRjSEgwQ0Fj?=
 =?utf-8?B?dW1VSEhEanVGc3YweEJGa2xTeW54enBmYk1CRElWRVFSWllOVUNzdjJWWHQ0?=
 =?utf-8?B?YWRWOWxYZ2o4R2dvQmhBUzN0U3lUVG5DR1M0NzdvTmc1UHhjSjFmYmxleEdr?=
 =?utf-8?B?M2pnWWJUTFpZV0VkQ2xUWThYRUY5czRpR1VyNTQzcHJKZjV5MFBkRFBZb1Ax?=
 =?utf-8?B?Z2NCbzl1WkdMYlI5WUl5R1RvNW5waG5hbFB3U0xZai94RFAxV0laaU1xSmly?=
 =?utf-8?B?dmsrcWxIaDRGRkp0RHI0eUljOUhMU2xtQWh0b3FwYlpFLy93OTltZG1QQ3R1?=
 =?utf-8?B?eVd4L0tseGdYZzRBRVM3Y1VDSHYyVlRPRjVsOS8xeEgrUlYwcVN5YVFHcXYx?=
 =?utf-8?B?eTNBK0ZCYk11bG5tNVJUTy90MHg1VTgwcFhXTkc1SEhxTkwwN2tkb0pwQUlT?=
 =?utf-8?B?TTlUeGZtaWdNc2piRU4yaVB2amxiZEhmcHpRelFPa0FsSDVacWlqVmp0YUs2?=
 =?utf-8?B?VnY3VUp4OGU5OGl4WjRuV2NQNWUwKy9yeXZ2RzFlT3FLUmNMQ1JaOG0vcUtN?=
 =?utf-8?B?dkdyN3EyWkJjeEcrRkFMa3luZG85MndyMFFVOXBUdFhYVzIwaElHenBLMkk2?=
 =?utf-8?B?QVRaZEROZzFHb2tBT2kwNCtzZTJ4aVYyWFRYNkM3WklCVG5WRjVWcDU0Qldw?=
 =?utf-8?B?dTJLWXFsK3puUzlXV0RsbEt6dXdBdXpaUmdZd1o5SVVvSGp0bzZPRnJNbG5F?=
 =?utf-8?Q?HjJCEwMN1jGUFatC+uV/cLVcV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973f31b1-32e3-4094-3e40-08dbd105a8b8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 00:44:04.2063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+AnVrzNXOViaXvY0K1pbIoFd5diF6xHdebfaD8K3j3buI9DH3BM4m5a1s/fvOrG1sXz7opTxkyozNTLYsqL2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8728
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 20/10/23 11:13, Sean Christopherson wrote:
> On Fri, Oct 20, 2023, Alexey Kardashevskiy wrote:
>>
>> On 20/10/23 01:57, Sean Christopherson wrote:
>>> On Thu, Oct 19, 2023, Alexey Kardashevskiy wrote:
>>>>> 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
>>>>> 	return 0;
>>>>> }
>>>>
>>>> This should work the KVM stored certs nicely but not for the global certs.
>>>> Although I am not all convinced that global certs is all that valuable but I
>>>> do not know the history of that, happened before I joined so I let others to
>>>> comment on that. Thanks,
>>>
>>> Aren't the global certs provided by userspace too though?  If all certs are
>>> ultimately controlled by userspace, I don't see any reason to make the kernel a
>>> middle-man.
>>
>> The max blob size is 32KB or so and for 200 VMs it is:
> 
> Not according to include/linux/psp-sev.h:
> 
> #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
> 
> Ugh, and I see in another patch:
> 
>    Also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow space
>    for an extra certificate.
> 
> -#define SEV_FW_BLOB_MAX_SIZE   0x4000  /* 16KB */
> +#define SEV_FW_BLOB_MAX_SIZE   0x5000  /* 20KB */
> 
> That's gross and just asking for ABI problems, because then there's this:
> 
> +::
> +
> +       struct kvm_sev_snp_set_certs {
> +               __u64 certs_uaddr;
> +               __u64 certs_len
> +       };
> +
> +The certs_len field may not exceed SEV_FW_BLOB_MAX_SIZE.
> 
>> - 6.5MB, all in the userspace so swappable  vs
>> - 32KB but in the kernel so not swappable.
>> Sure, a box capable of running 200 VMs must have plenty of RAM but still :)
> 
> That's making quite a few assumptions.
> 
>    1) That the global cert will be 32KiB (which clearly isn't the case today).
>    2) That every VM will want the global cert.
>    3) That userspace can't figure out a way to share the global cert.
> 
> Even in that absolutely worst case scenario, I am not remotely convinced that it
> justifies taking on the necessary complexity to manage certs in-kernel.
> 
>> Plus, GHCB now has to go via the userspace before talking to the PSP which
>> was not the case so far (though I cannot think of immediate implication
>> right now).
> 
> Any argument along the lines of "because that's how we've always done it" is going
> to fall on deaf ears.  If there's a real performance bottleneck with kicking out
> to userspace, then I'll happily work to figure out a solution.  If.

No, not performance, I was trying to imagine what can go wrong if 
multiple vcpus are making this call, all exiting to QEMU, in a loop, 
racing, something like this.



-- 
Alexey


