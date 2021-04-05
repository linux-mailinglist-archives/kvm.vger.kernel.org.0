Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4B354550
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhDEQh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:37:26 -0400
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:25480
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238638AbhDEQhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 12:37:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAf5/jrSyhpdxJARcs+XfBFyDZIjK/hQz35wDCjiSzusoI/h64MaD7PzTQAxxkKjXUQqPfdr6oP734N8HQ0Xi9msQ4bwyu3P1/40f3NsbyRGL7WYmgXffCrmGH39nvNfbjy8fx6YPvnvy1OB+aHoNHxfcX8/86w+su068oZa1280YLR9ZhOWw0yiDG5T0HXbKQNP7+npT8P0joT988/JHcpGzzEKnbWR5+3DCc0rR9MsouMl8Hl0cZU8xEglJVhXt/wZjIryQ7wC89XGMcNRjkbS7j7tJZSPKjYvjHAg2As9zEKi2O6Wn0w9Rsg8k4MU/yjGxOoUcSUlxxUQdMtPCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnKL7zRAogVBPa4WpxcNbnBZItSu1L13Fn0snQK+2Rk=;
 b=hII61HBW+zv53dBMfycuXwk5ENIOoQX6E+52280+DUnGSCASEu3xcjVI90pgo5KY3wYVBuL+M2TumcKMmdkF66fDgkYrQMVgu0tW4QE/es4yGnMrf0zA7lJ/9wtz89n5FuWEh+gNtyxCKynkE3GyyTFnnBKlpLJE3j6wX/pZPA5c1ZcRKRJct5pGiySWIPbdf6T5+9FFn17YnjKXe3qUUSQlBpmebFtbNmLDDEbKJdHL9rDgs6YLzD0xQhyzkoS+GpBs5uE9HnFKAPEl6TpYxxG9pc8Jo6IeBiNw2kXVAtkSXKpPWyivCofboOPLsuE5miWE8kSlECgiFIWlLPIGPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnKL7zRAogVBPa4WpxcNbnBZItSu1L13Fn0snQK+2Rk=;
 b=ciVhbFI5IHBMcNzwu5gG1rd0nLIDZIaIgCx4aHGDlvWKY+hRYDBNorNY37bgHHF34aYcdaQCrGGwTcMFhjp8Q55MvIYXQBT85Rt21gV4wga/tuofoazvX9VWExLAJPqta8s4yuuNub59k4SujRU6okHWJuL+u9zJY/2I1PGub30=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1717.namprd12.prod.outlook.com (2603:10b6:903:11f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 16:37:15 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::8910:71f2:c193:d302]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::8910:71f2:c193:d302%10]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:37:15 +0000
Subject: Re: [PATCH 2/5] crypto: ccp: Reject SEV commands with mismatching
 command buffer
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210402233702.3291792-1-seanjc@google.com>
 <20210402233702.3291792-3-seanjc@google.com>
 <bc82825c-03ff-1b3f-7166-f6e5671f0a4f@amd.com> <YGs7vioH8TVzyckx@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d79ac2a4-10f7-2ff1-fb66-d246348493fa@amd.com>
Date:   Mon, 5 Apr 2021 11:37:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YGs7vioH8TVzyckx@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR12CA0018.namprd12.prod.outlook.com
 (2603:10b6:806:6f::23) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR12CA0018.namprd12.prod.outlook.com (2603:10b6:806:6f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 16:37:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2159eef-f628-46dd-21c8-08d8f8511239
X-MS-TrafficTypeDiagnostic: CY4PR12MB1717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1717055F0C60DC745EAE2B7EEC779@CY4PR12MB1717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BoyjmABgaMHCKdZpZ4tg1E3LtLj9ji6rf9Nyr9jHD8rxHZlMsjiLjcsx9kNPKgwc04OyFNCBZDC6lOSvu5FrhADkJeBePZF7aPMp+KpZc1+sx2lwVVeNO7K8g+wqPb4S2MTyEypnhEmreg+4wfb3ZBfe+gYzen4xifEAB34GNEvnLbBwocD1GGSpg6qRHkPo+Bumtuna8sfj2t7y1EuDnsNyVZdqo/YmN5Sn9VEAfzue/M+9BULt0dHeMNWPCIFVVgqJSd4ibS1hc3OjYRekkYDTNk4a0ytc4Iot/Wj9ikhWndbj6aSH5eoqzmaQDbmFIaQf5A/Ez8RPc4j1ac1n3Ic+WxgNKAIrFKPX20fmcyNDCvSf5hBlGBp8j1jZQ6ctDWF5hWteElTKK4DRbFiTsmF1L5f+wuLZ0mRCDrS/rNvPDfgAxiGjPX7J9EQB2DbxODPgghSS41Drw212wuFJOjWfkQeK+5fuAdDsuUWmWWlKsU6WQ1aF4VmJRHt3qqk972avy7+qVP+jgwDp7pIi7qz5CCvLr2hAbhshllXDIpt71O6rnZrf6XiTQuC69g3naJYR9qKWWJsUNoEn+RhbXEB+M4ni+bTK87kPuO6De3OhvADWfs1I3K30R9o4nKajv1keqDpXen69cY8SuvmMynADRoAWrmeBUbXLmCt1GDQMbILoD7QdxcfEWmXzIAEoeQv1h8N3L1Leg0pDoGjFx15aP4VzqRRCaXJrNVcTIQrPU+nZK05wZ62yl9i3E3l6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(2906002)(316002)(2616005)(6486002)(83380400001)(6916009)(8676002)(7416002)(5660300002)(38100700001)(186003)(16526019)(66476007)(6512007)(66946007)(31686004)(31696002)(8936002)(36756003)(53546011)(478600001)(6506007)(956004)(86362001)(26005)(54906003)(4326008)(66556008)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UFdOWElWTVRhb1dHOUhUYkxsb050ZE9aY1p5OWVvcUF6dXVSb1E0a0t6TU5y?=
 =?utf-8?B?dFBtSllLZFlsSmtiUktiM1FSRGo1aDF0U1VKRHZBVndzNzFXaXV5THJXaTFu?=
 =?utf-8?B?SVFsMklmY3VzcWlMUURzdUtYQXN6ZC9FSU9WUDR2MDFORGptbzhVVFB3SmhQ?=
 =?utf-8?B?ckxXbHBDOWFSRm8vOWpQT1hjM3ZwS3Z1UzBQbE1id0RjeWtUL3V2LzBHckZq?=
 =?utf-8?B?ZE9Fd0UzbGdrVDh2aVpuWXdocmJ2aW1XaExPVW5Fanhra2N2U3JCNnM5VS85?=
 =?utf-8?B?R2k1SG5Eb3M5alJYQVVJS2tZM29pMnRNdldGQjJNd1FsNm56ekxOdUlCOVY3?=
 =?utf-8?B?bjI5S1dvYnNGcVVqVFdVMmFYb2cxeElRa3hqbXNid0p2aE1aYWw4SGJRb2hK?=
 =?utf-8?B?VzNjaGphS1RCaUZSYjZwN3FIWUQrbDc0SnZKZW9VU05lcllwMW9leW5PTzR2?=
 =?utf-8?B?eWNuV1pyY3lCczRFdmlKY1g4T0pSb3QvaG54V3hEQVA2QzNJNXEzQzJiNTJ5?=
 =?utf-8?B?dkNMZU8rTXZoNDZWL0xyTWJZMllDZVVFWHdPWUhtQzdqc0d1K0dKY25BMGUy?=
 =?utf-8?B?cm1ka1I0U25UTnVnTE5hakEvY05CWVBicmhlaGxMQ21LekwvUXpIY0xQZm9x?=
 =?utf-8?B?Z01KNVl2YXE2NGFYYnIvUGt1eFFNcUQySThjS2RYUHhRc00yTFhyUGZoSDYr?=
 =?utf-8?B?RW96bzJjb21iRGJzRzJrTG5renFxNFYzOS9XcTJKVG5RK2ZQYmIwOFZvQnVk?=
 =?utf-8?B?S2RFOHovOENXQktTdWQrZEYyaFdNVlpONGZwT1k3bTRkQlRST0RoNThnY0cy?=
 =?utf-8?B?c21pWmVERWZQWm1YeWVEbzEvOTJzRm5iYjRaWmRwMUdIMUtFUDY4c0tMMGhq?=
 =?utf-8?B?eGxXbzVjYlBkczFqTmp0Ymg3dHRuTUFEV002dXFzRTRQUmFQYlVGUU5Pd1hs?=
 =?utf-8?B?ZFRQMkFnYjh1YlZIZU5mZmV3NlJia01OREt1SlhRM0toalNMdVYvMWQ4WjRu?=
 =?utf-8?B?Z0dzclpLdjR4cEl4ZVNZZVlTQlNwZFpSazdBVGJkeFZNTFFhVWFISUI0OS9n?=
 =?utf-8?B?eUtURG9yZEZpclVOSnNhQzFPQTM4MGtRMGNkMW1vSUZvdTdwU0g1eUNnZ2ps?=
 =?utf-8?B?V1k4anpxMmM5dFUyV0ZvaU1CZ2poY2Y5bFJOYWJSRHg5SEZBZzVpQmtnRCtp?=
 =?utf-8?B?MkxLRndncFZZZFViY25UM1p0Y0NtL3Jya1pmT0luTll2VWN3ckhhR0NwZXNN?=
 =?utf-8?B?cXhTQnpSOENibGN1M21FWEZSRjBQUHNGVm9sbmJ2MDZpbkhPb015b3c4a1RG?=
 =?utf-8?B?UUhaOGRaaGZKZWtjU2gzVVAzZ0t5Q1N0MUFYck0wc1laNjNudzc1OFd4ZXgy?=
 =?utf-8?B?TzlBcFE3eTNmL0pKU252aFpnY3cvSmdzRWlkVVB5ZEJWZXJUMFQ3cWJ4Zlc5?=
 =?utf-8?B?NGc3eks0eWRUK1g5VFNvY053Tld3NTZldFlSc0lnSkM3VGlsTEI5NHRHU2VV?=
 =?utf-8?B?SlY4azlEejVubnRqRkxadnVuYjR3Ly9GRlB4MUUzNVl4b3VzWEM2dmE0MTlF?=
 =?utf-8?B?cXZ0ZDFqaGdWcHRYWHplbFI2aE5zRXl3N3Uxd0c1UTJXRVZUREo3MitadjRX?=
 =?utf-8?B?aW45SXhFbWNaNkhCVEQvU2VPc2tITkgrVm9vaUd5anlHajd5Mk1EL2lwVldw?=
 =?utf-8?B?bDJxdEM3Z202bW44MlcrNVVKZlZoZkZlRVQvLzF6ZjRHbDc1TDh6TFJnSG4x?=
 =?utf-8?Q?cLT0S56p2T9mzfb0uv/U3m/KnKjUHlKirgOGGWV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2159eef-f628-46dd-21c8-08d8f8511239
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 16:37:15.6227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xX74E6HmIAAW2fWnL6xZnD7aGheU2RBJlQOzT8SlJztO22z3aSWO3ECqktsuNpv3o7FzQwk6RGgeTMrj9GPgEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/21 11:33 AM, Sean Christopherson wrote:
> On Mon, Apr 05, 2021, Tom Lendacky wrote:
>> On 4/2/21 6:36 PM, Sean Christopherson wrote:
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 6556d220713b..4c513318f16a 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -141,6 +141,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>>>  	struct sev_device *sev;
>>>  	unsigned int phys_lsb, phys_msb;
>>>  	unsigned int reg, ret = 0;
>>> +	int buf_len;
>>>  
>>>  	if (!psp || !psp->sev_data)
>>>  		return -ENODEV;
>>> @@ -150,7 +151,11 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>>>  
>>>  	sev = psp->sev_data;
>>>  
>>> -	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
>>> +	buf_len = sev_cmd_buffer_len(cmd);
>>> +	if (WARN_ON_ONCE(!!data != !!buf_len))
>>
>> Seems a bit confusing to me.  Can this just be:
>>
>> 	if (WARN_ON_ONCE(data && !buf_len))
> 
> Or as Christophe pointed out, "!data != !buf_len".
> 
>> Or is this also trying to catch the case where buf_len is non-zero but
>> data is NULL?
> 
> Ya.  It's not necessary to detect "buf_len && !data", but it doesn't incur
> additional cost.  Is there a reason _not_ to disallow that?

Nope, no reason. I was just trying to process all the not signs :)

Thanks,
Tom

> 
