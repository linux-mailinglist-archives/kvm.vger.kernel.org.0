Return-Path: <kvm+bounces-3171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED61C80155D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3DB71F20FBE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A616959B5B;
	Fri,  1 Dec 2023 21:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5GwAGUSN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2056.outbound.protection.outlook.com [40.107.96.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593EC10D0
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 13:30:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOfNVyo9uz2UZPHKStzsWyh5ANAJ5qP7ROiBFCr9RBwwFuyM2ILGN8Yfpmi0lQO0PUTnEKnjcYl43amJNRCaLtGDtr84L/m3Pd+CJpgadQ092ws1fGnyK/m+8IDHoSJMqsfJkEMnrWqWQ7/awGXXOnk1bTQ5uozuvzfuB3W+QlHeZj3noREKX5TFtgyQaklRduyD8WdptyPuK8FlKW0j8Og7/fQ1HxOJX1Xx4VuNJEGw58Ee+tKDejlAIEaEm5FVWy0sG9Cm2jOeZnug+/BBEiZ/owTnfaRnrZUqS/ehfcs0NLkPfOtVFUjv2pJ1gmoLJAMf8OYlywhCYFIwhC1TTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7grFkskxn17T1GfjS2r+qgQycbs4+bd6fc/nGugBMs=;
 b=UNkp8vOIOFSguXQiUu8DEo9i+Avo5E/V9EmZXM362N0Jdr1eJbSQkPTrhGx+q6uDViKKi9pchtz5Ga7OXCxmDc3ky3jTXdIQo4qzOzws+0AXNe1/3qEm+kCEkqa1KGACnfbDcbKEJ9/0Nj3UmaKEumALGT4dhM46Ai8wI46W4SXLVBpuTb73upUcLaGVOAorHI92ckdbD5rNok7mV3WUuzFHHUdIEEfsb1H7XGV2kl2B5+DX/7X3F1ExxY+ImgDxbJrW3CF1Uss/HFmQqkOPW5c/05kirIOU0rz9rzUdK1P8TLkZOFYZ4UD6YNXsiwn2Xj95oo9JneUQiAfHvjrzsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7grFkskxn17T1GfjS2r+qgQycbs4+bd6fc/nGugBMs=;
 b=5GwAGUSNSMT27YnMezVOmbp2SqjIlqu3rzXUWX4l/ULeHj7Q8Z2ChwqOxi8+IvDyIx0iDG0BsRDoleI7E6ZZcu0e9uCDUDnn0wjQNCbVzvzhxgLbKtUg8iyaZ96Neec7hk2qTSYzpHDcPb4+m5Ur1tSczr4jcN4GfhNoZ50R7wU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by LV3PR12MB9329.namprd12.prod.outlook.com (2603:10b6:408:21c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 21:30:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7046.024; Fri, 1 Dec 2023
 21:30:14 +0000
Message-ID: <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com>
Date: Fri, 1 Dec 2023 15:30:11 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Jacky Li <jackyli@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Ovidiu Panait <ovidiu.panait@windriver.com>,
 Liam Merwick <liam.merwick@oracle.com>, David Rientjes
 <rientjes@google.com>, David Kaplan <david.kaplan@amd.com>,
 Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>
References: <20231110003734.1014084-1-jackyli@google.com>
 <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0236.namprd04.prod.outlook.com
 (2603:10b6:806:127::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|LV3PR12MB9329:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf1a59d-9f50-4934-d5fd-08dbf2b4b445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QQNXHDVgRmvV98Qmbyg+LzcnJl+OVKmYm81yJeB4k0HBX37nyTfkXlsdfpH7F63eigja8m4UBsISxCLlJfiddO9XDDAGEq67NERWuOhKbYkJJNGWeVtdv/ihKemgvDOrZtNXTAFegOE5eNxiBFqXJu39OqBMdyCoZOjYPLchRJP93aWJAYcBCTrK6k126wQj7YfXGO3e0daZlw5x7t2QBWEmieidvpr88R0mI7HEaUe1UUBMFwMYd5o7zy7SLWy2bLAnsUlcr6QHGBkdsVEQfv/ld3DY0kdIg1qoFcvPtv5JcyVuBDxQb9LrnNm0MTn0+zxYxWhe6OVmnD7Yc5knEDw6qM7yWSsApNHhfWhaqmJtCJC4YPlQeLZIZ02O5FUWydwpZI/zOyITEtV64D0S4JFjpSwXKqHNK71W/C/zYCwarimiZMFmSSL1RleMM+xlDGR1YwXFFtP+dS7/z6nQjJeoFm06m8LuDkJVNBzUIa1O/mTiHUad+qWAlR43pYXSNmXJg/aoaw1mGLZJYHLVRnDLtn44u56I88jxJ8ChLLiViM9p4m1fx8t8G74+6tuaW/yfaOPkku8pzeu3MhpLA5SHDJnvPgLzjfVYkRIG1GnocSy4tQGqtI1wB4s+4TNq9IsnROKYDIayZu5hqmVLlg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(136003)(376002)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(66899024)(83380400001)(38100700002)(31696002)(36756003)(86362001)(66946007)(110136005)(8936002)(4326008)(8676002)(54906003)(316002)(66556008)(66476007)(5660300002)(2906002)(31686004)(6512007)(53546011)(2616005)(478600001)(6486002)(6506007)(26005)(6666004)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rm82REU3UDRBbHFxdFhrejJYZTdZRUVPWHYrbWFudmVMNnQrWGdyTGZZOFdN?=
 =?utf-8?B?VWJnWGl3SGdZMTkvNC9WYnFNcjk2MWRtdFpwQUdMOFg1cGIxaThzTStlRDNQ?=
 =?utf-8?B?emRJckNGTlV0dnZseThub2IwYnlEOGg4RTdLWmRWdGJjS2F3YUZXRWpkamln?=
 =?utf-8?B?czVBRTc4WFlPNVZPYnU4dGp2dDhEVmV3MTdSNTU0UGNGR2FFNHNLRVEyQlhJ?=
 =?utf-8?B?bGZWWlZGRjQwVy9hZi9GeXc4V05iUmtGNEVuOEE0WFR6U0dGRXJqcE5Nb1pa?=
 =?utf-8?B?dnJsQmtOSUdHS3JMd2N0aWdQQUxud2NkK0g2R1ZrckZBU2RJUTlZb1k2KzVE?=
 =?utf-8?B?WGdFWjJTK3BZVk16cUZMZVo1WTZBc0dVQlBmeUZxMnp5R204R2RwS2t1VlBF?=
 =?utf-8?B?UnQvUUgrWllVaWtCVXNzZzVOYURjY0NuNFlMQzFJNEFFNFpiZnU2Y2Vzb2RX?=
 =?utf-8?B?ZVZsck1YR3o3Mmx6Ym8wL2VoTXUyV3RqbUVQQ3FNcHkySnV3ZlFmandOcnpk?=
 =?utf-8?B?bHlEU2FGTDF5NDBuSXJHSXB4QjkrcTZaVFV0K001SUJ0dkdja204WVo4T2ZH?=
 =?utf-8?B?TmZCZU5Ma3VJeUIzQzBZOEpONlJqbEpBWnlTRFcrOWpDaVgxOTE2WVFxU003?=
 =?utf-8?B?RTVyZndqVnFMMGloa2pNZzBJWElYb29qZjhLclJpS2phTzFncTR2MlUzSlo2?=
 =?utf-8?B?b1pDMDJNUGZSQlVoR2NLTFpPRnpGNU1la0tUTGowSmtMSytRK3NRZlNrL3BN?=
 =?utf-8?B?SDM5Uk9KQkQ1djR1UjBDbzZ2ckVFV2p5RGZHWmlUblUzMFBTSDY5TEEvVVJH?=
 =?utf-8?B?VTNXTyswbjdhQThDZ2ZpcTBHZXFSSkNSWlVwNlcyMlNCQTVyZTVkMGg0OTB0?=
 =?utf-8?B?ZTVmakwzK1RyN2gyZWJmZFNCNFdPVTlpalF5VTJHODZIRk5iQTZwRkx3Y3FL?=
 =?utf-8?B?QlpsOVNTRm4zRlhLa2U5dDRtVlFSYldCbHBURFIzLzVtWjJ3d3d4WlR0Wlhs?=
 =?utf-8?B?d2NoaEZJS1ZIUGFuVVZZbWhvVCtJMzVnZWgreFRmei9FSjNpRE01eXBKYXRs?=
 =?utf-8?B?eG1TVzlYSzhVU3BOM2NrdjluNjNWVjlhazlRWE1YRVMzZDlYd1pvUHQ0bEZT?=
 =?utf-8?B?cU9ma3JCeDI0YmR1LytnckNiWHpKNG1Iam5VYnNaRTQxZlg1QVlIbGI0K0xP?=
 =?utf-8?B?QmxXMXZpaC9FaG54ZFZrTDJYM3pZRjAvdmYyRmpXckVKWENHS2VJUmpNelpV?=
 =?utf-8?B?d0FIQVhLQmVTem51NjBzelhpbjk0THBrNlVmUmY5cW9SWm12SFRmRnBUaVdK?=
 =?utf-8?B?Vy9nKzJrOFJJNEVEcFdsU28zUHFQZ3pnS1Nmb0FjZjdPU01TbDVYckNxc0l3?=
 =?utf-8?B?dlJ3aVllL3VHUCsxU3hNL2FJODlvY3d0QVNDdE0vNkxqdGNxWkNpdDNzUytl?=
 =?utf-8?B?K3lPOVhxN1hpU3pBY2Vxd1RNcmgyVDZlYkY3OGppOUhidXJVZzh2WTlsdWhr?=
 =?utf-8?B?VzJPSkxHRXg3YzNUSGc1TkY5Q2xaZm1jTTgvV3ZHd2ZXL2p6N0pZcFhuSVg1?=
 =?utf-8?B?cDNLeHFLS01Fd05vSWV6Znp1MEtJdkFMR0xsd1hielZxWE80Y3UyRGJKZkxI?=
 =?utf-8?B?NzA3M3BIN0J0emxWNmc0ZjVZdGF3RlNCdEVMVS9qVFFXMUJTV0YvSk9rNmxo?=
 =?utf-8?B?cGVGaWpRS1pOTTdjMzVoZ1l1VE5hU2RpS3FrRUpKZ0t6USt1RkdDVVJDS1ky?=
 =?utf-8?B?UlU5RmhYMTEyeDBFVmw1QmZCNzVSdE93QWovU3M1cWpGbCttOTd4OFJkeDdu?=
 =?utf-8?B?YkpreUdZQmkyRTlNeEwrVU9YMG4wMFpBY0hlWmYxMnpIZnRBUU9jcUJWQTB2?=
 =?utf-8?B?SW5pQnNOMWR4QkNtSER3Zkk1Yk52RVdjbFdmaWJTa0IvWUZzcS9UNnlWRWRn?=
 =?utf-8?B?WnlkaDl6NS9Bek9ZSmlTU1UrcDJ3TzY2VU1Ua3FlbWh6RzJielpGSEhiNHhq?=
 =?utf-8?B?THRNcXlCOFlHYWkvdXE1UVlnVmFWTFcrRGFQNFl1VlkzME02ZDN5aGQyRCtt?=
 =?utf-8?B?VEltdC9pcUtDTnZHblBJMjZsUjFqR2J3dzhBU0hRN21yM2RjeVFzL3RmSldM?=
 =?utf-8?Q?98kdUTKf7Cm93NvRfbVyKf10c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf1a59d-9f50-4934-d5fd-08dbf2b4b445
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 21:30:13.9578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lyl0pqbnuHPnU6zEzGd6cXV8z443CIpvQhbuTl8qrtLpuuQFuKCvafkgvu/IHXtp79VeypUR/HUDWDp0Mdq7lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9329

On 12/1/2023 1:02 PM, Mingwei Zhang wrote:
> On Fri, Dec 1, 2023 at 10:05 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Fri, Nov 10, 2023, Jacky Li wrote:
>>> The cache flush operation in sev guest memory reclaim events was
>>> originally introduced to prevent security issues due to cache
>>> incoherence and untrusted VMM. However when this operation gets
>>> triggered, it causes performance degradation to the whole machine.
>>>
>>> This cache flush operation is performed in mmu_notifiers, in particular,
>>> in the mmu_notifier_invalidate_range_start() function, unconditionally
>>> on all guest memory regions. Although the intention was to flush
>>> cache lines only when guest memory was deallocated, the excessive
>>> invocations include many other cases where this flush is unnecessary.
>>>
>>> This RFC proposes using the mmu notifier event to determine whether a
>>> cache flush is needed. Specifically, only do the cache flush when the
>>> address range is unmapped, cleared, released or migrated. A bitmap
>>> module param is also introduced to provide flexibility when flush is
>>> needed in more events or no flush is needed depending on the hardware
>>> platform.
>>
>> I'm still not at all convinced that this is worth doing.  We have clear line of
>> sight to cleanly and optimally handling SNP and beyond.  If there is an actual
>> use case that wants to run SEV and/or SEV-ES VMs, which can't support page
>> migration, on the same host as traditional VMs, _and_ for some reason their
>> userspace is incapable of providing reasonable NUMA locality, then the owners of
>> that use case can speak up and provide justification for taking on this extra
>> complexity in KVM.
> 
> Hi Sean,
> 
> Jacky and I were looking at some cases like mmu_notifier calls
> triggered by the overloaded reason "MMU_NOTIFY_CLEAR". Even if we turn
> off page migration etc, splitting PMD may still happen at some point
> under this reason, and we will never be able to turn it off by
> tweaking kernel CONFIG options. So, I think this is the line of sight
> for this series.
> 
> Handling SNP could be separate, since in SNP we have per-page
> properties, which allow KVM to know which page to flush individually.
> 

For SNP + gmem, where the HVA ranges covered by the MMU notifiers are 
not acting on encrypted pages, we are ignoring MMU invalidation 
notifiers for SNP guests as part of the SNP host patches being posted 
upstream and instead relying on gmem own invalidation stuff to clean 
them up on a per-folio basis.

Thanks,
Ashish

