Return-Path: <kvm+bounces-6007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C912829DEF
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC2F2846C1
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1084C3DC;
	Wed, 10 Jan 2024 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NAqVqhjc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE853D60;
	Wed, 10 Jan 2024 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td7boE5IbifmuAxYj1TQY8zDLQhQDu/0uL8Vnk/BH5z4a5ezI/EcNkJNa2RFTalYF9B/9I78GAjt60lLoixKhDKjMfk3hzIm6/K7dudIC7kYKNVkVIr6ux9CHjtqrcb8F+KhuWkECSPgbka4wHu5JYxt8yxfgHn3cS5tI+TsnUt5ekLhWw/hROejncY2pflLHrFxe9WsZgfHIdwXAPUftczjEsE/zbg6OXS9uGyzEBMDinaRzgZ/yZ6+jyJMVp7sHOqtS3JkML11oDUsXE/DWgh66EApUBZn7XNc9l8+NQ6YKt4pg3U0mnDUP0gGqC3mn+XKpYyOo+F2YyeotYkI4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRsewiuWjHLLNi6ttZsd/GlNy9DYTVfxx+6V+1KOgs8=;
 b=FZOezk7W/eL2tlB9c0XtP9vT+VEb/M0qfFNbA585JYde7lIhVBuewTUT7UFizNiWMhtHkEEYNmsY1PQ958h4tK1ZmammKHNJc/f8+laoSmNZXDWebAxOCThBM7LnHg2xUw/tWtBxXXZJjDKzf1DarEa+Y5iDmxTM/QVz+geaZ0wT516dnYy3Oh7JOfJ9rxMl/illI6Z45nH/s/+0+mckWP4JiRWBt2RsWDuzWwcgY67rlopcr8N0B/hpjcbFxUiGnDAjP84lu/3EVJznLocr87y0OS+yiJfisbD84p16DQehtXVeV8l21dSc+3D3VhykAsPuLJ7gsoMveoxZtvQLFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRsewiuWjHLLNi6ttZsd/GlNy9DYTVfxx+6V+1KOgs8=;
 b=NAqVqhjc8JqH1+fcloZJ9iOVOR0EQDf3801b3CqAn80HGv+097ytHytwJQlBmPOFAPAVP6/iwksow4IvljXePmj0Eh/Itu7FyXIAF11g7PTaveziyXNAkFfyOWrlCWghlRISQ8ILJ55X/bs1oUNHcPKKFzatczFKTPNcGPk9Okk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DS0PR12MB8562.namprd12.prod.outlook.com (2603:10b6:8:164::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Wed, 10 Jan
 2024 15:51:08 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%3]) with mapi id 15.20.7181.018; Wed, 10 Jan 2024
 15:51:07 +0000
Message-ID: <9e3a6d33-cc04-46cb-b97d-e903a263800f@amd.com>
Date: Wed, 10 Jan 2024 09:51:04 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-8-michael.roth@amd.com>
 <20240110111344.GBZZ576DpwHHs997Zl@fat_crate.local>
 <625926f9-6c45-4242-ac62-8f36abfcb099@amd.com>
 <20240110152745.GDZZ63cekYEDqdajjO@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240110152745.GDZZ63cekYEDqdajjO@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::35) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DS0PR12MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c1df307-d6cf-45cc-9708-08dc11f3f5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pHkaNw83kEEs5eLfItmnhaM6kMXGa6s2F9hiN9/YXsK8m5iWZ/JJcmDaFoy3Q61ksaz0PeZbmoXwEVg0M2Pd+/Iux4DGonCVLctWQWTu9sf3yfZuQ2KY85JwzV27NEX7gyAtNJ3dkBCZhBc9v7H9H4Z1pBRFb0FlWZe1Ykj1mprbS+v4oR1WWHwMbprCk6TELvKavrt3tGX/iTPfpBbH0G3DSIx+f4MWQWedZJYVhwLgUAYKGx4M3JkI7m+3kzlvBuw6Z9oMsGYApvSdDQQu/TweooX2SwrH2VkuxDOTzToW2h7IzAvfq6moKJoMUV4WvIz0YZKXVZuKsT7a2OHLS4KkcRaLNjguvG8lQcjl7eYSVx1ffT5Wcn4cHdMbaTOgjhq7m4c7UUMUglOKK3uyjLayBG/62tPbLuEQ3S/lk42Dw1iPYj5PfIqnkEK7g8O7k/Ms9MK9e3/6ZVFHVV0q8B1Nx8ZSVsxDH9bHIN1GDuZG3TpRqqyQusWznwQnF7rURSRSvv5OJzkpELwc7oaiQ8riDkT9+cQI4TB2VTKDgUsB9W3Lg74cFCrEv3ayUxJBCs7yEzqB1mvKpYkCt5qjuQYchqekSMco++8OMP6LX73z/hcd8GfhjRNJyVyycFStHffMBWK/Rk1El/L3H9Ymlg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(39860400002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(38100700002)(6486002)(478600001)(31696002)(8936002)(8676002)(66946007)(4326008)(31686004)(54906003)(36756003)(6916009)(66556008)(316002)(66476007)(6512007)(26005)(6666004)(6506007)(86362001)(2616005)(53546011)(7406005)(4744005)(2906002)(5660300002)(7416002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFlrVHhKZFF2U3grTDMzYXZpVWxmcW9aNjdVdm94blMzVy8yMmFEd0RuTTBD?=
 =?utf-8?B?VUc1QlY0OXQrZnAzWWRCNHBWNytyMjBwS0ZFa2VHc2xzU2UxbEJhWTdlUTU3?=
 =?utf-8?B?Z09MS2k0dmgwOU80bHFXcDhwOHZZODc4djZOdHhMbWxiM3JWVCttNUZnVDFh?=
 =?utf-8?B?eWxmSWZwSFg4dzc1M1p1QkJiem9TSGF0WEVmLzVidGZqaHhaOXdSV29wZ2J6?=
 =?utf-8?B?dWZ3amdpK3dhVFIvSXJaZzJwOGNpSVdndTNPOTh6YVBXSU53eEl6WmVRMnV6?=
 =?utf-8?B?ZnpEd3NlVXh4dHRhVzBzbXBKYTFuL3gxS1doRkxQdVozeFZKTGVlOFJuMG1i?=
 =?utf-8?B?Q29IWGpjODlyWk9VeVlLaVY0bitRcTR1ejRNTEVvQTRXWlk0QnhTM0U1eEtX?=
 =?utf-8?B?OUg0WVlmejZTUEYra2UwLy9ZR2dVM1BySU5yMzh0aCtlV3N6Rjg4S2tIcm1v?=
 =?utf-8?B?KzR0K05pc2VSWnlaZ2JRaTJhTjVJZzQ3dTcyUFluOEhhdm43Y3JpYnltc3hk?=
 =?utf-8?B?em51ZG5hTTZseDBvMnU3eFlRcmlpNWFBbkZWNkxyUks0NGp2QmxUb3FHZW4w?=
 =?utf-8?B?d0pQTWVjWGVGaEdLMy9aSEpFU0RVL2ZvZlZWSWVqN3AwTzRSek5HN2p3VEQr?=
 =?utf-8?B?dkhHOFN1UlB5eHlveTFrNXJ0QlRqN3J1aG5IOEJwV0NlTmRQQ2pMUUh4MkRw?=
 =?utf-8?B?b1JvME9OUW13MVlPT2lNbDhPYUsvS3R3a2xzOE5Zb2hoVUNDZXRmaS9VWGpx?=
 =?utf-8?B?M2x1d0RJMVF5QmVpeUdSMkFldGNxUHdrWmZnSm9TeGlhaGZUVTBCTVNJSE56?=
 =?utf-8?B?M24yenpOeHBpaEU4MjZ6QldZWFlNaGhNNnNJZG5USkkwbU80OVNPWFRqM1lI?=
 =?utf-8?B?Q0hWbUdmVzA1Qnp3bktlOHFIWDBmVWZZaVpzVnlHNUxCWXptVFQwZkVwY1h0?=
 =?utf-8?B?bDR4Y3dSTDZKNjdCSHlsYUlMQVNlNTJmYmRZRU93TXpJSittVXNvMXN0UDQ5?=
 =?utf-8?B?YzQwTHFRZDc0akoxV0Z3bE93QUk3SHMzMTRRMnhubS9pYi9Uc0w4QkZucTVU?=
 =?utf-8?B?TWlESXFjbE5uWktvZjdqN1N3ZU5hcUNSRXFZTGFSa3A2NXlSUkFNN0krK1Fw?=
 =?utf-8?B?aHNZNGlkTVgyWWc1L0M2akFtUnBBQlExRHRKaFdEWkxhdzNudGx3bGxNeDln?=
 =?utf-8?B?elhqK2xFRDJXcU9PWkxlMlB3TEZyNGVpcnBGN0doODVmaEFoaDArekNITzVZ?=
 =?utf-8?B?NDl2VVpXK1hvZE10ay9LSDRsdnFBa2ZMQVJTNldoTCtlZms0bTZPa0cxRUU5?=
 =?utf-8?B?ZXo0akxuRkRuZnQ3RDZ1eG5oU3dNU1NTMnl3bldHSEVjclZKbG51cCtaRkZa?=
 =?utf-8?B?dk9uYUVJK0dzS3c4Umo1OW4vSGpWTWVSVzJwMXptSjl5amhGVHBHUXdMOGdT?=
 =?utf-8?B?cGdaNmFXeGkzSmdIK2VaSmlFRVk4ZmlNaHovdVY3bkNUaWk2K0JMdkhqOE9T?=
 =?utf-8?B?QTY5NVhtZWs1MlNHT3dWSFVpeVNxYUQwUFFwdm1ZcmpuejQ1N1d5b0YybkhT?=
 =?utf-8?B?MWFoUVltMEZDVmdadk1MMmszVUxmK2Y0ODBwUC91S1M0WGVtWHErQjZXTTVn?=
 =?utf-8?B?NDhTY3JEb1lwSkxMUDVFZlk3dExLWG9aUVFnd05SQXE4WW5DMGp6eWhtcVRx?=
 =?utf-8?B?ekwzU295Q0NZZ2Q0S01BLy9IWHo0YXc1azhOMTY5cFZKMytzUWFDWlFmc2VO?=
 =?utf-8?B?WlY4ZzZLTEErMUpGU3NVSVJEOGl0SVNTSlcvWmMrUjZrL1FuMjZ4WWpFTlBX?=
 =?utf-8?B?QXh4WkVlUEVuN3hFSkdxOHBvSVJSUGdiSS9PY2tDQm9xaTlqcnBoRWF6bE1R?=
 =?utf-8?B?cUN1NzY4UDdHaFZaMEZod0t3dklWOFFXcFJWYWhUa2lKYmo1UmVVVTBLMGJM?=
 =?utf-8?B?S3VzYTFTL1VSQXduVmdqYlBwcmJxMlJzWlRDRDRlbUozZTA1M3JQUFlpMGZ3?=
 =?utf-8?B?aUM3TU1OZUZBMHA5L3RnTlY3YmJNOTd3OEI4NWx5UFhXaXJOdlUxUDhHYVdK?=
 =?utf-8?B?a0p0V2szSVd0VC9ZcXQ5akFIQ0E5eSttOXdPVUdaUi9rVitnZVpvVVVWTlZC?=
 =?utf-8?Q?3zlQnZseJ9h6tV5CVNB2GhjS+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1df307-d6cf-45cc-9708-08dc11f3f5c3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2024 15:51:07.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQhn5X1pV2bz3SkytJHRZsa8sDUXxn4KsZ84TAE03DaVMCFGE6aiwIf2bLR1nbtBXhpT0zXtfn1OMFavccYITw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8562



On 1/10/24 09:27, Borislav Petkov wrote:
> On Wed, Jan 10, 2024 at 09:20:44AM -0600, Tom Lendacky wrote:
>> How about saying "... dumping all non-zero entries in the whole ..."
> 
> I'm trying not to have long stories in printk statements :)

Well it only adds "non-zero"

> 
>> and then removing the print below that prints the PFN and "..."
> 
> Why remove the print? You want to print every non-null RMP entry in the
> 2M range, no?

I'm only suggesting getting rid of the else that prints "..." when the 
entry is all zeroes. Printing the non-zero entries would still occur.

Thanks,
Tom

> 
> And the "..." says that it is a null entry.
> 

