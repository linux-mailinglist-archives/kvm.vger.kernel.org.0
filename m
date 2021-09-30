Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188541DC10
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351790AbhI3OOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 10:14:41 -0400
Received: from mail-dm3nam07on2059.outbound.protection.outlook.com ([40.107.95.59]:18913
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351585AbhI3OOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 10:14:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bu8I1c2KHIExCRDoezxUd4Fp5Rq/EEyGjpYNPFFXdML2OBadabWEBEvPdQyWnvhql/1SgbIdYfSdL9VPcUckbV8sjbnVlrpYs5CO1YFLtK1gQHrBrsgiN5np4tay28UVBwzaoa3RJYhDanMtMh7Td9oznYgHqbpjlQH6qarj3kUTsph6P5CLHcGZ6xOc5zk9Ct+3ZLn2oUuzBBqJU0/cr9njrH2Lr4D5bk5inmxZ8cMfhXwJZuiPFulxB++r/uaTbxg0Zqim8dZ5rVbhSJsCs9YROwT3Ty61hw9e3zZif9VV1r17UVzZngxx9G+BKCo85yOdQvxv90j7ZdHU/0nL6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=W6T1xam5zUDZO1w6l3OGbIKN2nsl8WIR5e29b4+NTGs=;
 b=UjBhvEwkgG7OGQLWzK0NxyfBHs+j+ehJ1d2+9NppxY6HyBPvXVAGMAGxfzVvyHCsgWlspi7mGKefQ1abq0qaNZJvjxWobwQmfZSzrLiV/qWA7gB0n9Og6ffj5v6mZ7nqy4zeiQySXN0S2KoJqUGm4bJFx/+J4vAjgXf1cZonBJERIb5bxHczQTMQakfqbAVUH/HZQYsYEb61V1pStnrXKBbxxBV+bPUAdCpoWoFtV1QZ1Tg0fjB8+qz6qpTut0Tqvn/by61ejar9NEHO5p2sLUzU+OkHh4j37UVqoQrf4GixplymUUfz5obBpbP21rWzomVBg+OW6/zDkIeNvJDhjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6T1xam5zUDZO1w6l3OGbIKN2nsl8WIR5e29b4+NTGs=;
 b=K/bbhINtSQqEbpPmGqmZi94EsW4ulVStDcquV4xwYRWoz6i7UBz5X0KlxpIIePBquhny9aW8y3R5xuIvWnTc8nW2pWenVVt/TalgJsZ7uFKtXcf14z0a2j7D1P6FThyLPWqAJI6tnMYOcQNb19C+g6dUd57uwx4ox0rAao5Poec=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1695.namprd12.prod.outlook.com (2603:10b6:301:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Thu, 30 Sep
 2021 14:12:55 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::41ef:d712:79a2:30c1]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::41ef:d712:79a2:30c1%6]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 14:12:55 +0000
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
To:     Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc:     hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <d1b1e0da-29f0-c443-6c86-9549bbe1c79d@redhat.com>
 <44cef2e9-2ba1-82c6-60bf-c3fe4b5ed9ff@amd.com>
 <2a02b09c-785c-605d-5ab4-e2ce0f5b9e80@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <09ab0486-40a9-3793-fdcf-bcbc6d3afe70@amd.com>
Date:   Thu, 30 Sep 2021 09:12:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <2a02b09c-785c-605d-5ab4-e2ce0f5b9e80@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0701CA0016.namprd07.prod.outlook.com
 (2603:10b6:803:28::26) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by SN4PR0701CA0016.namprd07.prod.outlook.com (2603:10b6:803:28::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 14:12:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b46977be-f9a8-4d7e-300e-08d9841c6506
X-MS-TrafficTypeDiagnostic: MWHPR12MB1695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1695AA15728087922D0EC71B95AA9@MWHPR12MB1695.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUtEa8tslUGRfP5KVB+4VDvetqHQMZDtgNt89Ey5IjTt0KkLrsLL0Gajh5U7ENSYjqdMvU7c/54MAF1l47Thu7Bp3VjKqMrGFpBjuRyWOziNthK2NzZcUdfF+lEGOtLxyDjxgHnM+3zTiznF9me5dBzP/Zt60oxHE6U8ATMiFv1inhy0cXrbteM6O6TGM4RchB9cp3Xg2PlkCnb+JkcNN/OLptdVw6aBu1TlD1jL11SNr3tblIbjJ18aQkJJ4RcOREpK5LeL2ndUaIFSXq60xoOQY4kY0qQQFPMgv/vKR7RyD/NRpA6kDTCcAaDwdkegIzonCUWCsJMU1jNnECEGUiD5f4wQA1ySyO1P/X2lRpn5fuFNR7z4jTabddHzq5mIwCqvwNEosBHBewpuu24o/3/YgdxcfZ6rt+dsgMtMbn1n7CwDa1yplSEFtxCNhYjcqT1kf8AytM0jovtvZxSO0K5V9HuHVYdT6Jph0RC6F/EhVWHl3EE9lmSLZAEEym68mOt2476Dl2NqbhIqx0Du+hXKv70Xtg8McT31PnzFPhRqLeaqweAO/RLq/F+i7ITt+QC2Gqbb6KH+NckzUo1dvUM6Uer6qz3NBR5r/I3xXRHfwick4NXjQYK+5B/vbUHuuePlM8UvaQCa0sRD0fRVi8YcWcjMYsc5Mq+w+Rkh6cOsZWFUDSUXT+1M8umq2PZK3WNSYLJ4XITNslekzqXh5tkAxSa6oVA7TdBldN5R/C+IeYo0XbMsENknGSNKkCYGmuTrNvz9RLOFvjtkYSD1tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(44832011)(26005)(7416002)(38350700002)(16576012)(53546011)(52116002)(186003)(316002)(8676002)(4744005)(4326008)(36756003)(2616005)(38100700002)(5660300002)(31696002)(66476007)(31686004)(66946007)(86362001)(83380400001)(66556008)(508600001)(6486002)(8936002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vk9LM2tpMzZaT0theEFNNTJwK0lFekhuR0N3OVlNMWM4QnI2MlZlVWxicHRM?=
 =?utf-8?B?andGR2lQRDJUS29ZMy9NbExVMjZsNVh2cFFGTTBtNXBTUWV2ZFg1d1JjNjZ2?=
 =?utf-8?B?cHo4dFNwTzBIQjR6VC90TjkwTHJGQVVvekZ0ZSsvL0l2MVd4YlZKODlLUlcx?=
 =?utf-8?B?ck5hWkZwWWQ2MUl0VEdjTlpjMXNrb3BNVUQ0b1djei92dGhRTDdyaEp1TXpZ?=
 =?utf-8?B?VHpxdncyby9Va3ZQQXJpKzdlV3NTS2VLaEQ0OWZ1WHlRc0ZKLzN4SWpGQWVD?=
 =?utf-8?B?UUdwcTh6L3JBQ1hydlNWeER3c0gwK1dkeUlDVXo3NVRkNTA4d1JhN1ErTkh4?=
 =?utf-8?B?cHp1dWdZSzFwZlhnWWRXTDc1VXR1ZXlteG9QN2F3eE92VFFIcldLTi9kbXBQ?=
 =?utf-8?B?MEFjWnJaMFFiRURmbW5jam9hZWh3cU0wbFBVK3kyVW1tVCt4Y3RYMk1CdnpI?=
 =?utf-8?B?ZkpJUW5kZXQvcnU4QklmRk03M0RNVFJvdTZPTzZxUkNlYk01d1R5bGxLUkp0?=
 =?utf-8?B?VkZxelFlSEMwUm01SE1MR25FVlRSY1dCWVAzcjRKU3AySGpCTGdmdHhEaVVZ?=
 =?utf-8?B?VFdNbUVRRlNWT0ladmlLNzNUa0ZEUytRUm9uSVZVeE93M2FKUnlpVXcxSWNY?=
 =?utf-8?B?WDFiVFBnWDJpTlE0NjFMVnJraEV4WnU1WC9jMlFXQm01M3JiU0IxeHdZaVZT?=
 =?utf-8?B?ak5xOVZWQ09TOHVnYU9vV2lyRWVYRU9NaHBFbFlTT3ZwQW9sL2xZcW1Qclcr?=
 =?utf-8?B?c2ZFazNQUWhNNEFJSkNFZUlEeVFjVHRZc2E5R2h0SEFBOExudk9HYTVCcGkz?=
 =?utf-8?B?RmhDZnoxN2Y3blZacFlBVG1na0JrRFNzS1ltbVdDRWI3anZMclVYMmVvUi9i?=
 =?utf-8?B?WjdiNTZEZ2psYlFxTzFJdlZBNkRIdnUzeDk1d2pLK0k0OWtoNHBXa2lyWW1Y?=
 =?utf-8?B?YXppSWJvcGREM3YwMjUzYVBQdXU1NnpWTDQyVlFobGpXdGpBbFRGTW1RblQ4?=
 =?utf-8?B?ZUxqRmhTVDVIWUtTN0pOQ2krWHg2Tmt1RG4wSUZnMVdqWDJBa3NHNk9lbjE1?=
 =?utf-8?B?N0JjeSt2RzhCZldnQXhCZ0xRVUkrYXN0WGtIS3RjNk9ROWtheEpXVURMZ3lk?=
 =?utf-8?B?WFBlZUFyV3B4RXhFREF5T1kxY29YRUgyOWkrMFdRdHZyME9NaVNRWUlxTGVy?=
 =?utf-8?B?N2I5MENna1JqRFRkdmo5WGpoSTJTdWNSbDAyVFZSeEgwRGVTZDQyenU0N0VY?=
 =?utf-8?B?emk0bkRpTW5IT2JEQWZhTGgyV2pjRm50ai9WbVB2YThOUEcvT0VQRERXODhi?=
 =?utf-8?B?U29wcGJXVXg2alpRQlhyMDNuVVZtTDY2MWpDUE1paytCWEZzdWtycHF5VUtS?=
 =?utf-8?B?MmpZdEUxQ09pem5oWSswYjJzK2pzenEreVd6SVNjV0VNejA5QlZCdTZWN0lz?=
 =?utf-8?B?YUNJaU5FNFliNDZDdzZHcitsb3VUWHFIOU1JRS9XaTkyTy8xdTVpS3RPbEtW?=
 =?utf-8?B?VTlmM1VMNkJNRkR6dlZVcXFrUWVVcys4N2pvTGdIR0FrbGVQY3AwcmNqZ1ND?=
 =?utf-8?B?SVR1MlFMQU9pVndwL2xBY0pDZzRKTE92SU55eXNYanVPek1VZndEMWVyWW1J?=
 =?utf-8?B?VUt4aC9XdjkxMzVTSi8zdjROVnhqOFpqd3hTUGZiNUlKN2MwSVpnNi8ySzI3?=
 =?utf-8?B?bi9HblRPdHJ5eUxjRC93ckgwVEcxVUlMZW00U25KckJMZzhydVJTUXUvcGJN?=
 =?utf-8?Q?QOU5/Bk84u6xA3p0DVOFp1IXchUF7sMXRVDIHO7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46977be-f9a8-4d7e-300e-08d9841c6506
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 14:12:55.3923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/cZlpnwCZnwrALItlxP0bHYYUBpAIpj2n/RY/9f0bNlhBv3U/+Nedo2+5MAPwmO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1695
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/21 8:41 AM, Paolo Bonzini wrote:
> On 29/09/21 22:27, Babu Moger wrote:
>>
>> On 9/28/21 11:04 AM, Paolo Bonzini wrote:
>>> On 24/09/21 03:15, Babu Moger wrote:
>>>>    arch/x86/include/asm/cpufeatures.h |    1 +
>>>>    arch/x86/kvm/cpuid.c               |    2 +-
>>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>>> Queued, with a private #define instead of the one in cpufeatures.h:
>> Thanks Paolo. Don't we need change in guest_has_spec_ctrl_msr?
> 
> Not strictly necessary unless you expect processors to have PSFD and not
> SSBD; but yes it's cleaner.

It is always both SSBD and PSFD together. We are good.Thanks

Tested-By: Babu Moger <babu.moger@amd.com>
