Return-Path: <kvm+bounces-7270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5B083EAEF
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 05:11:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0662B1F22D4A
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 04:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F2812B85;
	Sat, 27 Jan 2024 04:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T9tPdeL6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2FFD2F7;
	Sat, 27 Jan 2024 04:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706328656; cv=fail; b=DjVeIvKoIzGo/45QIrlxW98GXzhb6oeUUXRTFvXNt7WpDCyQ467tOvNj7qPcrykRIXaP/I3GT7rPGhn/8l8qx3l5PT1PXaHJo2a8zZ6dBfPfkfDrhfNosSMUkhlMIo+K2Izg0fn7lKZOEEySF0667gDlrlJ+0uxvMyNNCCrIFh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706328656; c=relaxed/simple;
	bh=0mUT9e7r8dkPTyqwmYSWLu7GARKGeK2MI/X+9uGhPmk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UDOEoxpGrMPjk/Eo0fyJsaqgJ26swr14fbVLf6pwBBmhIBNwWGOPxecx/EdKdJaLFK+ePR4spTXoxEjFNLGyDsx+cNqxwssmxymB7IMhQYTcz43J3AsIez2fN2JThOhTFCql7AiZSglLYVcoGIj5PUm7h735DVzx2oM1YMCW0fQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T9tPdeL6; arc=fail smtp.client-ip=40.107.212.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os6Ne8D6Qtaft8gMsIox/J6IKxzPb/oTKb72tpCaWgGH3QroIvEmlkQejyX5iOdLWUBhfqM7fD2NRmmUi5nEVkkozMywPw616AtuXHBmZ/Ks1401hNflIfOLvq1/dt5lb9XNs4zuL13thpR8P981soVaGoiDU2+h2q4/YreJG0nG6L/C3xkT0GpBTXoubDt0LugFVM+bE4n/n5RFKGUZtTywXzGGwNaPBPWwKvtDh/SWZk6ymVT9l4C+RP6swGOQfSfPJlLFkhBWgGEv5NhXfNguzA6BVQxfsQQ9EiBvnxGj3i7iFK8F2k9cyau1yVb3vuM9B3yY5at0ss73rKLfuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt4/X+EGipu2mlmPe6ziqJm6ULekIFyZxFvYYl/DH8g=;
 b=SwpYUFkxeXpOPKvQ390PeXSiRUSqH+UAHXlUPSHvfosEza4+hUxDpznH8L7SJPaK3mIjHXP6BBGiJdNzKYLN9yEPQUTf3BG021FmmFjITKLa1oAZImTdAwE4dkTYJ0KVoysKu2oFPWBb7nzBT2dz47cn5svBnTjk4CSQ7MGgzCmFNPVmM2N6pMPF05OfrYRQvkGXG58eu/wzMxo80kv1ooCmL/48GaYOBBQib61LnoU3De+RVMYRS6JO8JiAVXx4th+KVuZB0DfwJEn+X+l6Kob2906TwiyQ2Faoih7x0VPXmmdTESDShvtWgldU8hA3PjbVJ6tdvd8xe9MH5lJIlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt4/X+EGipu2mlmPe6ziqJm6ULekIFyZxFvYYl/DH8g=;
 b=T9tPdeL6W7eaxEiHeibLJTc68tpl+j9bUcNu6X/sNOO0aYSbWG49kLAM10QUibgBNrH+IlhjdIix7CzWdrT1HkX6a58ebm7QN9zO7TFFb0Xm/A/7XErG70rYiGVFyXcy7QQ8MisZfsfigX1nx5ppavyQ1d62qp44mwOC/xx9o7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Sat, 27 Jan
 2024 04:10:51 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.022; Sat, 27 Jan 2024
 04:10:51 +0000
Message-ID: <ebd90e46-d2ac-48ed-8d7e-ffc8a221140f@amd.com>
Date: Sat, 27 Jan 2024 09:40:41 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 00/16] Add Secure TSC support for SNP guests
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <8cd3e742-2103-44b4-8ccf-92acda960245@amd.com>
 <CAAH4kHZ8TWbWtf2_2DjEQosO8M08wD-EvaEsBKrXmPUaiFg+ug@mail.gmail.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAAH4kHZ8TWbWtf2_2DjEQosO8M08wD-EvaEsBKrXmPUaiFg+ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0181.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ0PR12MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: e219a71c-fad7-4ef4-a46e-08dc1eedf2f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zvrWXaw8BGUseIbDh844SdvrSLiVMMo04xDntQaFwdQXEtKZz9DVeHLJ4WyCx586s5/uCdgmEO5BEEzal/f5HbW6DeP7aCvXHdZDRh28L9ZnixwFTvqYgjmCerSWEKg1H+KBX8GtOKBgz4MNjezHqN9dYfyIBrGbpEfg1ne0fbjXKUc8wvDBunzFE+xd/8k9O/+kLEHva32R28/xpypwQLNPGxMUiP8TbHTzSnyizD7p2QjOhbspWH4ORjkEKCmDL5E+4a0VhXjWORaC0zfQTdHkJM9bzVrj++bibIN45QPzgXakrQXYVlSNcVe8LWARYk15XI1Msxlc+Q2NayOtc/mgK5qw2ccFUxmpcsDZqlGzo18xGvFRpC2TMCkNKvJcP1NPbaSajbS+ywU5L3ZggF7q/tUksG5YSmRPDpFVZMx1n0RwfGnNqX7lpMGRRKgNPvBSGx2kuUjkHbb5SgN4/dAH+5fXTrIJ9tjTUBf8UOhwDEs9aXuo+NOAF/GsUbLa7C6bC0j3Ga1EsshCXpQGX9W29KK30umnPuZXvXDMjO4zOi4GSLVdNi3nuVIaZYcJTGwOUxCK0WWVRwovW+t5KvypMCOIMeF7Ey26KJdqz7rsoQG49mTsLgwklR3NeJ7+Gws+RTriShfauJ7u6Hjg6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(136003)(346002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(31686004)(53546011)(31696002)(6666004)(26005)(2616005)(6512007)(6506007)(478600001)(6486002)(966005)(316002)(6916009)(4326008)(8936002)(8676002)(83380400001)(66556008)(66946007)(66476007)(36756003)(7416002)(41300700001)(3450700001)(38100700002)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzNVOWxLam9yTDZwWEFCTmxrS01Sb1QwNmRObU95WU5hT01iNEcxRGpoRGFi?=
 =?utf-8?B?UlJ5dG02VXMycVUxUjY3b1FVNWUrT3VrZmd3a29RV0N0SmhFcytVaFpUektp?=
 =?utf-8?B?UVVRRUpqZkdWMUZzcndxbHY2UENOKzhISFhwWmpHQStpWkxkZ1J5SVRzRkM5?=
 =?utf-8?B?dWxWd1FMc3RYR29Ob0Nla2NPQzlIUkZpSGpML3FTS3pmdEx5S1FkL1Bnemg4?=
 =?utf-8?B?NER3cmJzeEROUjl0L3d2Z25Fd28wNVhzSXdsZkMvdS8rcldHZmZaL0pLc1hI?=
 =?utf-8?B?dGVsRjNqUTd5Wmt4UjFpOXhXaHZKcFI2ZXpEVnNpWXNZOEZNbmptTHZXeEov?=
 =?utf-8?B?QWFtZ2xoQ2dlaTBrMnVpZzA5TFFvaVltYWhwazlhUThSZWJXZ285QjdhSEoy?=
 =?utf-8?B?WG1PK0tiQjhOZHpZcC9OalRqRDl1d2hpSzlOb1MvUkpnUjdLMm93a3BmaUQz?=
 =?utf-8?B?NnpBTEYyQWNRdjQzQlNLYWFIdUhWeVNiQ3NpT1JkUjEwaU91MUQzZFVwZTJq?=
 =?utf-8?B?S3pNeUpXdTVCbkI1VVhPUkxmOE9qMXplSllkUjRtUWl6TGtPUEVGR0RlUVFS?=
 =?utf-8?B?MWJzOGtEeDFMaVZoaUtjR1BLeERNL0dYbkFWMkJnb1NvNjhEZG5RWnN0Nm9x?=
 =?utf-8?B?SkZFTVpsY29uUGsweDdGTVNjU1lhbXVKQml6Qzc0QktBaVN4Z2psZXlpczJN?=
 =?utf-8?B?WXd2ajJNbXMyRXVTS25VRFVXMGNLQ2RVRDRMTGRiVGt6RlNCK21VUkNJSGJH?=
 =?utf-8?B?T1RrdlNjYWtOaGhkbWh3TFpTbzROalNsVDNLOCtOZHQzZlpJWTIrTUp6VWI5?=
 =?utf-8?B?R2k4OE9DMHdUelhVYjRqWHkyQWdCVVVSRjhWODlpNkFBeUsvS1dyczZYc1RC?=
 =?utf-8?B?L09jYXdUbkFqdUZkYTQ2Z3pFS1J3RmF6eTFzeDdXRzBPVWpzSVF1V2ZmTXhU?=
 =?utf-8?B?TlZqSTRBWnRDem0wSXFUckRKVkpQZG43Nmh4bGQxazc2R0RJdWhkRFpRTFVq?=
 =?utf-8?B?YjlZcnZtSG1Lb1F1SXRXVXpqK2dJT0NvL1I0eFF1STRpMFYzYjJva0pzR0Rn?=
 =?utf-8?B?azh4cFhUZkpyVkZlMS9JZUI1T1h6SnBQSlRWbjkzS2MvVC9XOTFUUmY1WVEv?=
 =?utf-8?B?UTkyVmJiNUpISzdOK0JEWmY2cFlRbHRQbjF1VjZnYnpzb0Iwdnd1N3ZJbk5E?=
 =?utf-8?B?VWhZaWdEMjE3eWJ4WUQ2aWlaVjRITlM0SGJhbS96Y25YMjRlUHFLSVBEeGta?=
 =?utf-8?B?eXlyblVzTFZwbnEzKzYrOHNxSHFURjQ4QThKMXdoRWlpblhJMDliNWNrdlN6?=
 =?utf-8?B?WGd6MnZGUWpqSkpOQy91c0s4YktVRXdqRlBZdHFzV01aWTg3RUJncGdNVmZR?=
 =?utf-8?B?eUxaWkZTUmdFV3dPQjE3YzdOVVBjZVF3dk53N0JTYkcxeE94aXlTL1pWS2V0?=
 =?utf-8?B?TTZpOGxpTWxpdU0rWjVvS05sUnE1MmZyY0E2QmNsMzdYdmJoTlozTUhsWkwv?=
 =?utf-8?B?a2E0clJoZ1Z0WVhoQjFOUmZrT0QxMXRLZ0lFditBMy9Ubnh0UlFyL0tOZCtj?=
 =?utf-8?B?bHhISksyMkRzdzF1Mkdxd0haYTA0YWlWR0c4ZmhlZWxVTlFWWnY0Z05KazZo?=
 =?utf-8?B?akxCZHZiVnBJZjRFYXZpLzlKOXBqbkRDVUZrUmRESHlMMHR1NWVBdWpaKzFX?=
 =?utf-8?B?NVFrUVdqazZmaWJvQ0ZhU3dJam9FY0ZHelJITXRxTWJoQVFSU0c0YVRYWGdZ?=
 =?utf-8?B?ODd0b1daOFllMjA0TmJ0NTZJa2pyMHVXQ2EzTndPUnVCdHh4UmZZWTZkUXkv?=
 =?utf-8?B?YnpveHBxQ3dSaU9DTE1BUUhjeUxSNkdBckFDeUJPWUpUZHVhZk5EWml1eTYz?=
 =?utf-8?B?MXcvRElIdTV1dTVHT0VMZFlTTHpyUWlhdjFoTWluMDlkVDkyZ2Q1WEpCSW52?=
 =?utf-8?B?cmNWejN5NFVZdXUvVkl1bTFhVkVXUDg2cEZWeXo4clovMEhBczhNbTBRMlVm?=
 =?utf-8?B?eExJU2NvNU56aVd1WFZNS2d1dnFyN3FCQmNza0NKNGxqVlRqenhtazd0VWI3?=
 =?utf-8?B?cWdIMlVHeXBuS3lHeVowRnRCNEFPbGpjd2dwWDg0V21QZHAvWjRZd0x1Tktm?=
 =?utf-8?Q?PJ+CrVCR4zVm21GW8sqI/z99A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e219a71c-fad7-4ef4-a46e-08dc1eedf2f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 04:10:51.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwVLqUnQxIaj4NZy7aMOjs3SAJBl6iDgaydNHJTNwsDrFmMtVYNHajuOO1eZCxVogwFxgQOFqUXGlHb7GYCziw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422

On 1/26/2024 6:30 AM, Dionna Amalie Glaze wrote:
> On Wed, Jan 24, 2024 at 10:08 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>
>> On 12/20/2023 8:43 PM, Nikunj A Dadhania wrote:
>>> Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
>>> parameters being used cannot be changed by hypervisor once the guest is
>>> launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".
>>>
>>> During the boot-up of the secondary cpus, SecureTSC enabled guests need to
>>> query TSC info from AMD Security Processor. This communication channel is
>>> encrypted between the AMD Security Processor and the guest, the hypervisor
>>> is just the conduit to deliver the guest messages to the AMD Security
>>> Processor. Each message is protected with an AEAD (AES-256 GCM). See "SEV
>>> Secure Nested Paging Firmware ABI Specification" document (currently at
>>> https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"
>>>
>>> Use a minimal GCM library to encrypt/decrypt SNP Guest messages to
>>> communicate with the AMD Security Processor which is available at early
>>> boot.
>>>
>>> SEV-guest driver has the implementation for guest and AMD Security
>>> Processor communication. As the TSC_INFO needs to be initialized during
>>> early boot before smp cpus are started, move most of the sev-guest driver
>>> code to kernel/sev.c and provide well defined APIs to the sev-guest driver
>>> to use the interface to avoid code-duplication.
>>>
>>> Patches:
>>> 01-08: Preparation and movement of sev-guest driver code
>>> 09-16: SecureTSC enablement patches.
>>>
>>> Testing SecureTSC
>>> -----------------
>>>
>>> SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
>>> https://github.com/nikunjad/linux/tree/snp-host-latest-securetsc_v5
>>>
>>> QEMU changes:
>>> https://github.com/nikunjad/qemu/tree/snp_securetsc_v5
>>>
>>> QEMU commandline SEV-SNP-UPM with SecureTSC:
>>>
>>>   qemu-system-x86_64 -cpu EPYC-Milan-v2,+secure-tsc,+invtsc -smp 4 \
>>>     -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
>>>     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
>>>     -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=snp \
>>>     ...
>>>
>>> Changelog:
>>> ----------
>>> v7:
>>> * Drop mutex from the snp_dev and add snp_guest_cmd_{lock,unlock} API
>>> * Added comments for secrets page failure
>>> * Added define for maximum supported VMPCK
>>> * Updated comments why sev_status is used directly instead of
>>>   cpu_feature_enabled()

I missed this in the change log:

    * Added Tested-by from Peter Gonda (https://lore.kernel.org/lkml/CAMkAt6pULjLVUO6Ys4Sq1a79d93_5w5URgLYNXY-aW2jSemruA@mail.gmail.com/)
>>
>> A gentle reminder.
>>
> 
> From the Google testing side of things, we may not get to this for
> another while.

Thanks Dionna 

Regards
Nikunj



