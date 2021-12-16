Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E826477C12
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbhLPTAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 14:00:18 -0500
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:42880
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236361AbhLPTAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 14:00:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b11bhcew4DtWjKoHiz3BTqoxTkeXeLtgnDcW3eI6TXQ7yjxOM3p/w2QpDGRXU2BwM1yS2IONJpMaBREcWc31qvmv9NgDNqSpbJnhIiayeYJ+mgi6fRrTCyzzp1nhI8h8debLjLZWfxH48LM3MoipKvrNH2xFUOXbdmDS6EuvIY/QJZBfIkxUPkGqIH0mZdxCRmFnjtkGqkdgYas7y9XyxKZi6s3oYnGMymgI6wU/rP8IQ6Nnb9xeXv6el8RRVaGPyNxoXLK5PepV4kCJl3lPMDzhMf5Q5TW255P48GXhgS5lsGOfu5n2R+IajdPOdbqhrJU47D8Fq+Eg+y8IGDWxpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXrFwe1QCV336MA0IPntkLdlkwY5cX4nUpHI1LB7ATw=;
 b=MDINnnlYoIkGsz9bFdgSfQdO/UcBSCqvBpiebTgvgnkMZ5MVEO3aOTwKt055kjKY1lXRpipFnMTu8u9nEYmdbFoT4wjfBvkXS0mmjweFeMgqQ0ykw1rbNz9Cb6TCHA8DJ3c0YUlswz+jODGZ156rvy0xvTeGcAFwx+H5d7Q1qmXNWBdf3LQOYN+SmlkLah/eIgJElVXnM/+jye/r5qhG2buat1kLtyBwGKfbC+/ICIgLDGygWV7dd581eRhT46D8Kzts65azPa9u0s4ZJ+nAP4XLvOsU2SFYLoXcrDyhQ+IwQuJbhqwfEakUQuapPB6EpIfGxMYKylxdg3blQAmZhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXrFwe1QCV336MA0IPntkLdlkwY5cX4nUpHI1LB7ATw=;
 b=JCzlla5Y2iPTIT3L/jboEszcyKmrm+D+eHo+BeuKHQKzk3FGp3D7Bgz3iPqU+lV3yVqFmE5u9O+RrARl3T7C/W5xrXTC1DgxGra86T/SAeUK2HOltcx56Tfj+tO0JKWWoXvNTBFeIRu1ir2/u3/H7CKcwvZn4WRAxb0KxNeVbLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5550.namprd12.prod.outlook.com (2603:10b6:5:1b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 19:00:14 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Thu, 16 Dec 2021
 19:00:14 +0000
Subject: Re: [PATCH v3 6/9] x86/smpboot: Support parallel startup of secondary
 CPUs
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
        "hejingxian@huawei.com" <hejingxian@huawei.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <20211215145633.5238-7-dwmw2@infradead.org>
 <d10f529e-b1ee-6220-c6fc-80435f0061ee@amd.com>
 <f25c6ad00689fee6ce3e294393c13f3dcdd5985f.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3d8e2d0d-1830-48fb-bc2d-995099f39ef0@amd.com>
Date:   Thu, 16 Dec 2021 13:00:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <f25c6ad00689fee6ce3e294393c13f3dcdd5985f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0024.namprd07.prod.outlook.com
 (2603:10b6:803:28::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0701CA0024.namprd07.prod.outlook.com (2603:10b6:803:28::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Thu, 16 Dec 2021 19:00:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e446231a-d58c-498e-fc22-08d9c0c64ab1
X-MS-TrafficTypeDiagnostic: DM6PR12MB5550:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55504D8979C26319B804B620EC779@DM6PR12MB5550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNpyNBMa6ZIUNRzHX0q4wznZEZqbzdjGRCAu9TM1IB3I+CiLW12LPtCv7cifikXN+XkZRkouYUzq2uodsj/RlMvtLQXNB0WrnKjs5+9kL1H5STKP8dK37qi99TIeQeVF/60wQ7tVE1TlwkTqnG2QUh7fRdOfCiMW43FPt3lgfOHCyDx9j2gIFHujZXtLHM7leyWCFQ8X1LJcYfIvUQqaQK1oLXs8hoDGqYKaXMHWu1C5o7EFr/UTqQGZjiraLG4KcFWXdxx7kn/Gpy+6i/nbFh6xDwL8Lw7n2RM7fv/vOblaXziCwZFISZ0YpovTOtiZz6w6xf6AJ7Rrg1wHbarIQUtBtxuinEg/DSHxMRZK57rSWayIU4FVD6vBGichcEgb5qzYlJFuwxLeg24j0pQ3wu6FjqEKUwIxRlQupPC2Af/FAElcfeaotIkn0F9+SO+04CjUfR3gecbjreNO4T4BKjmWmYcRZL1FuL3wIq8+1QR7tfmIQ3DmFkHHThIDmy3LjGssUZ+DiAxb1mciuSskamaqQpYDiqxlKQsGmCRsiwkgV8y9aXSIcumFYHc4oQaf0VnTE9TDe3UXatFFCnj31Mrf4JHg9WTOHOR+j3V7EIFSWUf3lDu7e36p4/FtaAG250LlNsAE0Vft7QwL/mENfElpJGAlqplKDART3aMqBeE6IgboalCC8N3U3n+82gEv9oLNtlAWg2uy5CUbF0ubNHm+o5MOZBsfGb4vbpaLotkql0BjV72J4vMxr9XPEbgR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(66476007)(66946007)(54906003)(2906002)(7416002)(38100700002)(66556008)(36756003)(31696002)(6506007)(31686004)(316002)(26005)(2616005)(110136005)(508600001)(4001150100001)(186003)(8936002)(6486002)(83380400001)(8676002)(6512007)(86362001)(53546011)(5660300002)(4326008)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2FQYjVpcC92RUxRcmIrbnR3NDlSdjBzcHJJMmNWaGVKNGhVV2d2dWF3YVg4?=
 =?utf-8?B?Y2V5T3lTVWthaUlyTDlOdmVWMXdXMmlYbm9TTlpFSjFxdFNGVEFueG1IMEpS?=
 =?utf-8?B?bU13VGdDTGNaN2xzeDh2ZnZkUEVodEVHOE5sSU5nUnNSa1dZUTNrbFUybGMy?=
 =?utf-8?B?NEJLRDMxdUpmemdzVndWaDVtaDRNLzhoY0lhakliZ2FWUWFwSzRzMFVjNzVk?=
 =?utf-8?B?Y29IWnJzTTd5Y1FBTnZ0emhjRVpkSUIrKzZoeXAxL1FGV0ZSZy83Q1NjYnVp?=
 =?utf-8?B?bksyT2w2cUNwNUNQeE80akpWQ1FjdncveTM2azJRWEtFeWZFdkxyK3lXVDQ3?=
 =?utf-8?B?eDVLRFQxZDZ4STNybWM4V1pPOFBDT0RYa0NxUWhxN214YlRoVHhRUG9WVlFC?=
 =?utf-8?B?THJMRjQ5dXVQbzZBN2lWZUR0aU1HdS9PRXBrUmdUQk9IZDBHVHFCdmNIQjNU?=
 =?utf-8?B?Rnp2TGd3OTRtSGduUEJYUlI0WmlZeVhVZm9MdmhrbGNWNEdLNlE0S3dHSHFD?=
 =?utf-8?B?SkxwYnJQVEJNbGZTU0tWY3ZIRlJnVTVCUjNJbE1GbGRLWmVVOENPZlo1NTNY?=
 =?utf-8?B?dThkU3g3SGtMaC9MSWE0NDY4dy94TCtCZEJjMy9oMXFlVE83UFZ6Rnh4TlVI?=
 =?utf-8?B?SW1YbE1hMzgvWnpKd2hJV1RQemw0VjdZVTlrS2tuT3NFa3dPR0JVb1c3azlV?=
 =?utf-8?B?NUtlQnc4ZG1HNFdJMCtGSzFCZ21BSnZRWFprTSt1MHBxbEhVbnliNGxKMVNH?=
 =?utf-8?B?Umdrc1ZhbmlGdmlCTlFsN2NNZllBSnplenRkQlUxQ2wvN1NVOFJ4UXM5VlpK?=
 =?utf-8?B?U3VDS3lPWHUvSXRFUlpsdmlCZjgvbk95Z2pSY1RodGFFdTgxVU1RUEZXL2Yw?=
 =?utf-8?B?aEJYV2I5aDVUSEF3akJmRU1NU0lWSVdNcGJ4cm5XeDlBWE5mTXdOeG1RVnN3?=
 =?utf-8?B?STl3NmRpWm5GOTBaMnk0b05QT0N0NjlRLzZKd28rTXFkNzhUTDJSQU5ZT3J5?=
 =?utf-8?B?d1BLZXFUd0FnamJxVXplZi93L3NmY3dLcDVTcDhzWHZSa1JMaVhvWmFsZ2FO?=
 =?utf-8?B?aXRsZ05pUWxSQ2NuMGc3bjVET2xuWmJ3bkw4UlUvOHRiOGNjV0p5K1F3RkZw?=
 =?utf-8?B?cWFpWHVEWE1ibGgxbXB2RUtHbWE4c0d0akROWU4vR2lncGpjbDFVQnEwK1VO?=
 =?utf-8?B?UHU1RTROZHU4WWhXcGdxRDI4Qnpzd0o1SjllME9ER2FDYXkyU2t0RzRwUlVP?=
 =?utf-8?B?UHBnV3lCSUFtWGd4VGZwWk45UTFEcis4aTVjOHU3WEZBY1FZSzBBRUFEVm5z?=
 =?utf-8?B?MXlBWjdTSHRVWGdHTEVzT3AxS1BnMHRGaE0rSVFVRmtqNU9wNnoyR0pDV1Mz?=
 =?utf-8?B?aE1IT0NiOXd1aTE0cUVlcVpXOGxacUlpa25CUjliQ293dlJIQllKajNubXNQ?=
 =?utf-8?B?ekFBWWxrdlloTm9iakZWVVZHanlNRnkxYWFIT3FhYVh5Y01RNEFjYk9FUnBw?=
 =?utf-8?B?c0RBY1pwQmRiU3BHZmlrdG5QUzhaOGVjNnFxOHRDeU42dzhCMlMyMmlCY0do?=
 =?utf-8?B?cm9QcUpZVk5JNjF0cHprUWNEZUVkNTFXZk0rNmZCWi9XNng1WDJZU1l0aTRV?=
 =?utf-8?B?ZmFHUXN3ZThUSHhGYjVKdjFPTGxjWExYZEJWc2MyVjAvMlVrQ0Z0WFh2WlZB?=
 =?utf-8?B?VkoyNkNMQ1JJOEJERXlaUXIxRE9FaVpHK2ZwWGV6dkxSREFsZm9MalJGeXFa?=
 =?utf-8?B?VWw0S3RycVMxalREMjdmbkgvdEgrdDZHOEw3VkwwbFAwTnpIWDV0bUwyRnpm?=
 =?utf-8?B?TFFoTzZkTyt3aHQwa1hqbTNvb2lLT0p4dEVBK1IyMGRXMTh4bnNNUS94bHlq?=
 =?utf-8?B?YmVmOGMrREhlMUtXbG9LRVNQMjZzNUR1WVAyTGJjaXdZeU1FOGpSWW9CRUw0?=
 =?utf-8?B?TTNxNzdpY25EMFl1SnZ1VWkwRHpSV2QyVHlvczdWcUxoNUpOUFgvQmFUUTA4?=
 =?utf-8?B?OHR0QTQwNDYrRGczeE4yMkFIdm9aS0ZwcEZ6OWlOOS9QZWNoZmdmdjZJdGlQ?=
 =?utf-8?B?a3FLZ1FIM1h1N2prbHV6NmJoUi9WamJUc0FlUUxSZE0zOU5PSEIyUU5QRVhC?=
 =?utf-8?B?K1k5czNHbjdXNC9JVHYySTVyN04yMU9icjA2NEg0bUpDaFlFZy90VTJGRUFq?=
 =?utf-8?Q?npg4tp8nUlRM8ofa9UuMQ34=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e446231a-d58c-498e-fc22-08d9c0c64ab1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 19:00:14.1619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xx5BITpqX7oKRmIRQkFpBwsjkrAyOPEw/ipgFymqYfhWsoHYh4VDlL+zxpVtn9DeagQP7JRfG+V3Sz/PjfvpJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5550
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 12:24 PM, David Woodhouse wrote:
> On Thu, 2021-12-16 at 08:24 -0600, Tom Lendacky wrote:
> 
>> This will break an SEV-ES guest because CPUID will generate a #VC and a
>> #VC handler has not been established yet.
>>
>> I guess for now, you can probably just not enable parallel startup for
>> SEV-ES guests.
> 
> OK, thanks. I'll expand it to allow 24 bits of (physical) APIC ID then,
> since it's no longer limited to CPUs without X2APIC. Then we can
> refrain from doing parallel bringup for SEV-ES guests, as you suggest.
> 
> What precisely is the check I should be using for that?

Calling cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) will return true for 
an SEV-ES guest.

Thanks,
Tom

> 
