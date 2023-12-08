Return-Path: <kvm+bounces-3977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 461D580B084
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 00:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC8E61F20FFE
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 23:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719595ABA2;
	Fri,  8 Dec 2023 23:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g+Jiq7Qr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E60E1716;
	Fri,  8 Dec 2023 15:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpS22lcAgRJ+FyNtVYYPVK7jHDVd4cCMZTaI0TAN3TILh0aBC81raL2RrSj52wr3ICximuYBfZxSFHy5dUkpKsh9N8eKL8031aLLTWGbSCm4C0XE7LjBfvFvOubnycpt3RbS2MSSiR5N3W9ObgHqrBqj8r5LiX8B983vASo+z5qnaCiJMOwJmb79n+1X5pU9cJe3XXVZ58y7yqIW3SAK43cxC2R55HGHrDuI9RDG6+sBp0MS2bHAw36x2QucdjOrCCqzC8Gbo1SmntAD/rsr4MWkNQhYPlFD0ssUnAM6e2XfnO9pJfMHITbK1a8l0s0Iq3pOg8BdUpnwKn1zxtrARw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pghRfyehC4LjpEbYZxYH6NMVKjNfxE28hJRYhY1N0s=;
 b=Y2e/+SyEYXmh92dR+HRJEbT4YNKGhWvmi+aSKwJK2pnUuPJ7VT7uBU3SXFhI/SX6K6FLL50yrlx+XHWCiqlMbWPL6jlXC22YZEvkTWKJsnQ8cS12pNY3hf5qx4vI53sMfWJnlP7lOu0Z6MJHMdg7BGFjakH6W8mPTh41UFsnYgXDf6HNNcMp18Y+QgWxCC+6YQWFzx/BALyHa9YCcQOleR/FHc4WrVZTr8D9MwgVeWxRlH+Np7PFtzMLV0Pn9i7B1+SLp/Q6zBSzBjgArjg+SrnN7Bg4Cs9va8WCq3RVsE0CcEdIdAALaWjtDXiicMzkmxufabJWqk1SKfGpIBE0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pghRfyehC4LjpEbYZxYH6NMVKjNfxE28hJRYhY1N0s=;
 b=g+Jiq7Qr/XYT7uVG14Kys8OF3RoOndPPXGjEuqg5Yv5c+N8V1/yEjQ3B12zUAtJkSr1qnSkcjCtf7k6NakzUEzKkROdJBiSUJKdz6VZHO/SQ4u/zl0hvN8XggpCRehUD1Xrr3669G/jjUyasQC4ZJTGoHi6oBxxQD8rGPQ295uM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6183.namprd12.prod.outlook.com (2603:10b6:8:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Fri, 8 Dec
 2023 23:21:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 23:21:18 +0000
Message-ID: <0169e8b9-80c8-37ad-2bcc-93105b4e7385@amd.com>
Date: Fri, 8 Dec 2023 17:21:15 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
 Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <68b2d6bf-bce7-47f9-bebb-2652cc923ff9@linux.microsoft.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <68b2d6bf-bce7-47f9-bebb-2652cc923ff9@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0107.namprd04.prod.outlook.com
 (2603:10b6:806:122::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: 24276570-5b2e-4206-f7bc-08dbf844618a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vj8ABIwjMjBbLv7T/IqCjYmpDVpoQTJHKD7Lif/8MuNIYo4wVwiwkDLy7n52lSAtJS+I/1yRvQx2kASpjmErSQUY9V9kiqW3ApdBTc4FqZcTPkuby9XpT363pErVWWJM5VUwhISczqbzc0sHDjIfh+K1cfiOuttGJy/Z2BSM5xeE476+4PNRn6pzObPmqY8c6/+4FNdxjlGw0rAtOqEsJatuM5DkWR63mR0fLVZ0gg0GKd9TTbu2QOIBwLroqaToJ1afm2ajd7IK8x8+153Qc8AKpbd9iCvxfuGClEuI455b8k34B/UcOYRPNT5kOcFaiKeSzmLJOXyFnf8gPvMsFp+sy4x2Hn/ueCK5t5I/6qB3JlkQcvreJUwdmGqJJEgAM4f6fNKxFp9GKGNnhcAUCQI9L3UK89eZ4MEwT/hSees8S3XvQjSUJbI9dFXsaxX7sR0OkyJTkJSButVQOElqIm45t5kRsP8Q0fzdNNv7tJ1CdUlN0rTRGzitYVW2SgAUM/pb8RdN7NOL0sdr9kvD7P++ckYJkHxMM0ZeLKuq7OMAyBDHwNLD3MWOpfayuUzTWwVbj3jOYGhOnHcLSdmQSOzx9IjmCZcdYzHppl1VezHInBDytFZZfoR84xqMhdOHQWoHyfAVuNo7o/jmdXAPe/SVdrCteolAfO6wFDfovtJMX+dwyTmMPhVl94plfdmx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(39860400002)(376002)(396003)(230173577357003)(230922051799003)(230273577357003)(64100799003)(1800799012)(186009)(451199024)(2616005)(6512007)(6666004)(66946007)(316002)(6506007)(66556008)(6636002)(8936002)(31686004)(38100700002)(8676002)(110136005)(4326008)(66476007)(83380400001)(6486002)(478600001)(26005)(7416002)(7406005)(4744005)(2906002)(86362001)(5660300002)(41300700001)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXlDQS9kQitiTUxhc3JXTEJkRmZkY0JvMk12am9Cd21jTkZlM0tlNWZkbzkz?=
 =?utf-8?B?WTl6ZkxpS1dMbm9LL3lMZXBoRjkvNHpnTUdtRlVqQTRjYVI2S2hrQ1AvZk1l?=
 =?utf-8?B?Q1M2NjMxakNzRDNNTVorcEFzYStINksxaTlBN2cxaFkrb3FkbXI4TjdoZ3J1?=
 =?utf-8?B?bEpQdWdMRFE4dGxvZW8vVHV4Z3k3ZGRGRVY2NENCckZJTm14NjhvSVE4UWJS?=
 =?utf-8?B?WTBpOHBsSUdoSjNvT1JVenlLSHFQMlpHRml5SHE3MnVPamc0Y0ZRbU96TFp5?=
 =?utf-8?B?Z1RVc2NlT1JFNkl4amJ4VDg3SEhJR1RST1lLZnZmU0NCN1VEVlJTOUJLY1E0?=
 =?utf-8?B?a2lYcWk4QkRRZEZVZTRDUGxsQVJRaGNKWStWUkgrc25mbk9BRndqUDB1U3hn?=
 =?utf-8?B?cEpHR0twRUJ6ckdnTjk3MkJLMTlVYzZudVFzb0lYQVdRWm50OEZBQWk2eFFO?=
 =?utf-8?B?cUVQZzJqWW5aRXBMYXJPN2daVm9aS0liVjFXWDFMYlNuY1pxdGNKeS85MkE5?=
 =?utf-8?B?d2NsK0pLaHFBQk5xaDNKRDRIN1hRSlArazB6bE5YY1RwdDJQL082cHo2MVNa?=
 =?utf-8?B?Ym02bmVRVjQ3THhUc1RCYWtHN3BxYlo0Nm04aXVaN2tzdnl4eit3NnYvaHI3?=
 =?utf-8?B?Qld6L0Ntc3FpcWUyVjRScUdTdXU1V2k4bHpqK2E2eXZwbWpSQkFWU0RiZEhr?=
 =?utf-8?B?YnNXeWh6cGlVbnJuaDJWUTdCTFp1MFBCVEYxaTA3RVlzSWhFMDFPWVZiWUNa?=
 =?utf-8?B?by9lUHVMNGF3ODRmbVJBNWdYc3JQT3NHZ25ZZ0xNZlI3TEdqa0QwcWNtckVu?=
 =?utf-8?B?a1kwaEIxd3kzM2pRRzM3NWorRWJxZVZuRjgyUUlObzI1ZGhvQ01yazM0VVVO?=
 =?utf-8?B?cGRiaXlOOFQrQjAvNENmRTJNVFkxejNrczVRdzhaNEs3S0J5SUZ0cWx4NG91?=
 =?utf-8?B?ZFlNU2N1bGNEUDJsSGc2VUIzZmgwdXQzUndhdHhUUGgvRW5NdTM3V3MyTDdt?=
 =?utf-8?B?L3d2MGpUdlMvUmpCTjVxckxNVDU0M2xmcWh4Y1hsN0UydHBrbzBnWmxXT1VH?=
 =?utf-8?B?U29oU1lMditnUEw2MGVLaTljSkJsZHltWXpHWG5BN1NKcFhpSnB2U3pkendy?=
 =?utf-8?B?RUJRSUZTQURCR0FYUGxoczJsdGljbmxvSlVjMXZRM3J5Zml3OGdwankwK2ww?=
 =?utf-8?B?QUtiTzRkckdkUGwxWjRQL2tSTXJqMnB0RUJLZHZ3aGhpRWVGVkM2Vk5OOGwr?=
 =?utf-8?B?VWxOQVNkNzU4STRGalk0N01Gc0h4TlJlUmgwY21tUDluNUlEdlAvNURBL1lU?=
 =?utf-8?B?cWRoNzRUSmZ0d0RDV0dGZnJDNTJxQjduV1crTXpFcHZnZk5LY000OFlXSkZo?=
 =?utf-8?B?Q1JzYzd1S2JKOGNtT3IrQmZtKzY4ckROU2hJRHN0akpKM0ZZMmdKaUtrcGhX?=
 =?utf-8?B?M1B2K3AxcktvQUNSRjd5WlI4d0NuQXk5UGVpcm9aR0syTi9sdXkvSjhZYzRP?=
 =?utf-8?B?NVBza1FQdmw1N0xmSDJ4a0pIRzg1a08vckhaTlBXcjAzcUJDNks2QXcwejk3?=
 =?utf-8?B?M3FCR2xObmpDaWp0bjUzeEt6K2FVSVJLNFhubDNab3JvTlZrK3BUOXRuWHV4?=
 =?utf-8?B?QmhuaVdKU1VaNWg5T1lHY1FTcHhiY2Z3WnBicDRMSzVEWDJsMU11ZDhpVVgz?=
 =?utf-8?B?ZWdVcFZ2c3JqYklhQ2cyTHJCelY5Y09NRy9VNHZlV0d1NytYVlo2UjZ0T25B?=
 =?utf-8?B?SlNydFk0d040UjhoQTl6M1RsY1dQZ040eUlkTzhzR2pZTFFsaFJ3aHZwWSs1?=
 =?utf-8?B?ZDlGb0hxUmVoUUZKOUgrZU1jYVFBc1lIRjRWU3ByeFVqaXlmNysrWkF3RCt4?=
 =?utf-8?B?UEZxUUN1dE5ZZzRQYU1TWDZ4eTZTVStiU2tadGovLzNKUjkyMzlXV0dLMFVn?=
 =?utf-8?B?M0taOFRBY1VudGNWWVM3WUxkVS9EV0N4bTNMelc5ZmJQelZPZkJXTUQ3K2ZU?=
 =?utf-8?B?Wnptb2pOV0Y3ekZacHk3c0xIY29DYm9uUXkvbExhQ1ZFV0FiR2JlK0dBWGRt?=
 =?utf-8?B?RmNuUjREa1hGaG9vZWF0WkVxMDhVR09BMnpwaFRiZ2lvbEhVb0tHWGRJZ3Vx?=
 =?utf-8?Q?qgBYXY1+W2QA7K3d4M9D0YI5r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24276570-5b2e-4206-f7bc-08dbf844618a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 23:21:18.2464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRhzLCzrZanawyiCej/ldosfcEnjE6goplpDlZjhpd3oLzhr/netW8YcTRjrcWokZ1nzl82sAl6O+x49zzKLoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6183

Hello Jeremi,

> Hi Ashish,
> 
> I just noticed that the kernel shouts at me about this bit when I offline->online a CPU in
> an SNP host:

Yes, i also observe the same warning when i bring a CPU back online.
> 
> [2692586.589194] smpboot: CPU 63 is now offline
> [2692589.366822] [Firmware Warn]: MTRR: CPU 0: SYSCFG[MtrrFixDramModEn] not cleared by BIOS, clearing this bit
> [2692589.376582] smpboot: Booting Node 0 Processor 63 APIC 0x3f
> [2692589.378070] [Firmware Warn]: MTRR: CPU 63: SYSCFG[MtrrFixDramModEn] not cleared by BIOS, clearing this bit
> [2692589.388845] microcode: CPU63: new patch_level=0x0a0011d1
> 
> Now I understand if you say "CPU offlining is not supported" but there's nothing currently
> blocking it.
> 

There is CPU hotplug support for SNP platform to do __snp_enable() when 
bringing a CPU back online, but not really sure what needs to be done 
for MtrrFixDramModeEn bit in SYSCFG, discussing with the FW developers.

Thanks,
Ashish

