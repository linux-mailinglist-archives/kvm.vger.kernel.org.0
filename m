Return-Path: <kvm+bounces-4103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF8480DCA2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 676C3B216D9
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 21:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9356954BF8;
	Mon, 11 Dec 2023 21:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gNK5nIAE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48077D0;
	Mon, 11 Dec 2023 13:11:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=capwhdIMFl+GDO48A1JbOhlj9F3a3lDD5wbQn2ZI+MHEmc9HmocAlsRwdOCi1a9Bh5M6BOtbyQd6+D/G/yXtSdM5G3HpXkdsRQpFcoBOnCN8RDwjdG3hm6BReVLrSnhmjWNX423QQEIhRZ3iO9vQycUc3sg5bGV5PAjtzIRhWchWpztS9cioTCr5gIkPAD1OpgUzvpVqHEEJvTydIeVtd8oS2HbWk/eA1+AmlJgHRqD9hjl9Hok69BcOmMwgxis85MuZJWAMqc3B23yYs033iRs9gRy45isxwnLUMpgeVwxiP4hVsadJa6Xh7VjCC7+15lHAqJDeMFwMFh/75q29MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCQlNXeMh3MMrKodn3KJZTEiTKuKflU4pnh41nCxQs8=;
 b=GTqBpSb05mmlZ+UxVTF6rLsKrJnmJ8WyXiUOdKUuFMgZXxsCduFVHidrp5GHcngzRk0RPUYAg/GS8WPfP9ocQx5s9TsXhY5EaDcBTBn8jfY2CnqKl4gRe/oW5F/+DnefUsBykvRVCoeosKhOMuDxsLEV/vVZ5tznTslW6EL48PKb3NfCO7oxCsfqSukRvdHWYm/YSrHiYPzmVRVHAMqT1wLF1TKAoe5AJ04LxJcpmHi63SZ7+cF/ffQSlf8vcqDDUyLY1sphGNjAW7nt6ikXjmxkcc6Yv6HAuDGMwa9k2/P1Z0DZYHt3qTdsZJjGSaCjZ2pZLhWW9lmSdjDBmCrXfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCQlNXeMh3MMrKodn3KJZTEiTKuKflU4pnh41nCxQs8=;
 b=gNK5nIAEB9BxNGpLgE6+Pilz0tPrNzNecO+4zV6G//+C1o9A3Yg07ROu7hc69CjzMYlaHZNStdtmickIkpN591M2ZuJw1G4dlQlt0DVuwd4dcdlrIaGsD1m85OZDskoSC9KA+K7S2KAzkkboRMDJuyQyNPEeMJc3YmUzHdLBPnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH3PR12MB8536.namprd12.prod.outlook.com (2603:10b6:610:15e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Mon, 11 Dec
 2023 21:11:20 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7068.031; Mon, 11 Dec 2023
 21:11:20 +0000
Message-ID: <2800d4d6-8ae9-e6c9-287a-301beb0a2f50@amd.com>
Date: Mon, 11 Dec 2023 15:11:17 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 14/50] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
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
 Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-15-michael.roth@amd.com>
 <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
 <d5242390-8904-7ec5-d8a1-9e3fb8f6423c@amd.com>
 <20231206170807.GBZXCqd0z8uu2rlhpn@fat_crate.local>
 <9af9b10f-0ab6-1fe8-eaec-c9f98e14a203@amd.com>
 <20231209162015.GBZXSTv738J09Htf51@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231209162015.GBZXSTv738J09Htf51@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:806:20::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|CH3PR12MB8536:EE_
X-MS-Office365-Filtering-Correlation-Id: 00676926-4538-482a-3040-08dbfa8db8f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oxANGmkK9i6dSjxMlkK8iN0EktOb5EQa8Grx4IZ4SCKX3SJeclXE23LXtTJrEorLJ1Hr5j00vhl9mJGi6Akjy44VJ0gK7s6ZcxJrgSjleaJi+v3htS8BKUX4ZQZW1JeN4bpxxd/kYU31eU4+h2hAMxWiIobZrYGoMYrxjOerFB6LPOI0Pmiz5BbqGNR1SHZGWYzJN1lqQsY5ORR2w4CbCWWqzrFrfhaWnHKqsGgPYDrihQHPldrFg2yiYRztkXiusXyrqtpUsJr/i2bq6cqG1Z71wOx+ADyPCGmKgBvNTpFL7XicVUSjKX1PjIk6kIt5j2SAbBopHGQfQoMOXBQXojah3pm6JU8sjtKaR8U8Mr3cxVx2akgj2+4zj8tXe4qHd/bSt8nVZN8V2GITHBCf0JzJlTV9PqO1Wx95Youty9D/nSeBOZdS9CuItrLybtpdk8va/Dluf6X6uAEPppSSrnCaT/yFvz9WWZrpSV0p2euaTi2MpEkrPdIRTHAnLqGsVSKJXa3ZfZLqgv8moVm1iXTm1YhikGyelmO3dty4cXehWArbt31iqqtYjHpK4rR5QG9LucIAcXSie0S/a3L5AdKvT0B75VcBSLz4ysueySbqNjZHCjelnc3i3J7BDn4qkpGaVQZdwuXQEVAhm4M9KA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(41300700001)(5660300002)(7416002)(7406005)(2906002)(6512007)(53546011)(6506007)(2616005)(31686004)(36756003)(478600001)(6666004)(6486002)(38100700002)(83380400001)(8936002)(26005)(4326008)(6916009)(66476007)(86362001)(66556008)(54906003)(316002)(66946007)(31696002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVg5dHp4S3UvejJPVnFTeFpiSDcwSW1reElnT1RKQXMrZEh5SUtkZmNkeVVi?=
 =?utf-8?B?ZW9QYk9scG1NSWFUVnpFNUlObHFwbjcydWNtQ09pWnpGZ3dvZzNyTWVYREhD?=
 =?utf-8?B?b0Y1aStkRjhBSFJ6ZU5SQzY4M3JFZnhRS0NmSXM4c09PWjliT0tpcGJZNUlx?=
 =?utf-8?B?a3kwSWIvUlVOU1ovNmlvTEdOOEh5WHRHRjF1VUwvWGpsUE9ESDJEUC8zY0ls?=
 =?utf-8?B?MkxCdmk5QXg3M3pBK3VIVTFzTWJMNk1ZM0txSkZmWHU5R21YNDdGT1J2QVYy?=
 =?utf-8?B?Mm9yRzFJaHNId01pU0pkOUR4QkpCYWdUMjdJR3dNc0hDVjR1UENjdjFXMHZS?=
 =?utf-8?B?ZEV3dlpnNGRIbEw1LzMxODRldUh0UzNobHVPNE52WTVBd2xDVmNhZlRMNi9t?=
 =?utf-8?B?aWptUURMVnNPK0o5RURJMXM1OVJOMlVjaGNqVDRpZHE3R0tmdE4vT3BmWis2?=
 =?utf-8?B?TWhCZkNSbXFhK1hXWHFzTHNBTzJJWTZRb0w4dVpqWU9Ed1Qvc1d0U1VvSGMr?=
 =?utf-8?B?bXg4QmQvM3h5V2xEUUdjYmtsbWpTR29GUVRPK2JoZzJHUHM1YmtuL3gxWWRs?=
 =?utf-8?B?S1RiRlMrNWdkajZkOFZzakxRRHhqaHRvRmRVdWFNakNqc0lUY3lGUzlWL0E1?=
 =?utf-8?B?NFVQSmEzdEZLVGE2N3lYMUY4V3UvOVZrc2ZVKzhPdjRwaUUybU5TTFBKWDkv?=
 =?utf-8?B?OHN2OG1KeHFLdVorNURLMDlOTW9mend3R3hoZitLV3VyZ0FRTjhta2NhU0xx?=
 =?utf-8?B?NDBFeFZOMDZRbDdiUk1TY3dPSkEwaUtWWThoMGNFZDNoTFB0bmptY1hSUmE3?=
 =?utf-8?B?b3BlS3NaallTTlhFMXpPbDhwOHNvM21lMHZZSExFU1d0c2NRUzloblh1OHlS?=
 =?utf-8?B?RXdhVGF1aG5xRUhZV1k1SkxJbCtUd2Rna0ZuYXpXMVJqdE5ENEFXVVJiRlhz?=
 =?utf-8?B?MEtwdlZDSU1rY1lWYXg3TVBsbU84VjRTcnROOEdKN2NhaFNUR3BnUkNISFY1?=
 =?utf-8?B?TUFZL2FGalQ1NUJ6djJWdHpZQjJob2pzc2RyVllyOSt6WnhPeGpiWUEycGF6?=
 =?utf-8?B?N2F6ajRsN0dYS1JZY1BUcXc3T2pkUXl1QkM5dE85Y25RWUdSUG1JVDE1OU8w?=
 =?utf-8?B?Wnkxbi9yUVhCRDZqSFhmNjhyczdXNGFwV2Q4Z3N0MWV6MjZ4MkRrcmNETzhV?=
 =?utf-8?B?UGlSNitUNXRscVdPRzlxT1pzcVJBOWhqSHFjVmt0a3g1SDh4b3FZRFgwOGNl?=
 =?utf-8?B?eGh0Ynl3SFhVVmVVbVdYZGNTN0N3ckd0dUg0eWtDSTFEUjcrVFd2dml5RnRq?=
 =?utf-8?B?Sy93QWhTdVBxYmRUcmdxQUxBQlhUc0RTYlBna0F6TnNYaTM2b01kWDRwdXc2?=
 =?utf-8?B?MXl4SGhTSjczeEsrNW43T2RGSXN0WGdYQnNhZVFzUWxqL3hXUXpnbmxYdWxs?=
 =?utf-8?B?WXZyNnFjWHRsS3I2OHkwL3Uvd0E3c0R5bGFLbWNMODF6eDQ1cEVwZnNrTFYv?=
 =?utf-8?B?SVlINkRwNnRtcWcrcjVxK0JadEs3WFh0eG1ZZHhVNGVucFoxTXVoOW51MXBw?=
 =?utf-8?B?eE5KQy9hendxTG1vTGVXN2I2WThqYzErM1EwY0VocWllOTl5OEFhQUc1bWsx?=
 =?utf-8?B?V3FoWWtCbkpBbTY3U1BDUndNRmdMckZhaEdhZXhxOFlsYjg4bm8vZy95ZTcz?=
 =?utf-8?B?OXRHbDUyWDhkSU91Q1UzY21VMytMd3EzUW5YZ1A4b0hBa2RxWFRTM25icGtX?=
 =?utf-8?B?TDVXbmhlZ3hFOVdKT0YrUVJFYndnZE1iZHM2Tjc2bDlPWmhrd2NnSFhnYlB2?=
 =?utf-8?B?UHRxZ2kvRHhaL3ZoU3JkRmlDYUZWeDM5dnRMUDV5Wjh2Qkx1ZFRMT0NJb2w1?=
 =?utf-8?B?UzBXanJZRXZyQ3hQdkVZWUhkcVhYMFAxanNTWFlRL2J5UlhraVJROWIvMWll?=
 =?utf-8?B?b1RXNm1OazlZUVNXMXpwdGFaWWdlT25SQk1jaHVQdjU3cGE0a3grcldRVXNq?=
 =?utf-8?B?ZGl4ZHovTjVSWUNkM0orL01GMEJqdHUrY3pMZ1ovTVlUdXUxOHpNdzg1M1Z5?=
 =?utf-8?B?TDZjbE5NYUUvaTVkdFM3RXg2bDNIb1dyNXJSWmdnbW1Vdm9WTzdsbXA4dGJz?=
 =?utf-8?Q?AjiPlVankMZrjAta98nkmPd/m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00676926-4538-482a-3040-08dbfa8db8f1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2023 21:11:20.4626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+BulLT4SX+uX5bhtXDQfEiQbtN04MWxqwBEz6rC/Fi+xgehfBTODKu6j0kOxLhJtnVSK4WAepgGtcyGmDH89A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8536

Hello Boris,

On 12/9/2023 10:20 AM, Borislav Petkov wrote:
> On Wed, Dec 06, 2023 at 02:35:28PM -0600, Kalra, Ashish wrote:
>> The main use case for the probe parameter is to control if we want to doHl
>> legacy SEV/SEV-ES INIT during probe. There is a usage case where we want to
>> delay legacy SEV INIT till an actual SEV/SEV-ES guest is being launched. So
>> essentially the probe parameter controls if we want to
>> execute __sev_do_init_locked() or not.
>>
>> We always want to do SNP INIT at probe time.
> 
> Here's what I mean (diff ontop):
> 

See my comments below on this patch:

> +int sev_platform_init(int *error)
>   {
>   	int rc;
>   
>   	mutex_lock(&sev_cmd_mutex);
> -	rc = ___sev_platform_init_locked(error, true);
> +	rc = _sev_platform_init_locked(error, false);
>   	mutex_unlock(&sev_cmd_mutex);
>   
>   	return rc;
>   }
> +EXPORT_SYMBOL_GPL(sev_platform_init);
>   

What we need is a mechanism to do legacy SEV/SEV-ES INIT only if a 
SEV/SEV-ES guest is being launched, hence, we want an additional 
parameter added to sev_platform_init() exported interface so that 
kvm_amd module can call this interface during guest launch and indicate 
if SNP/legacy guest is being launched.

That's the reason we want to add the probe parameter to
sev_platform_init().

And to address your previous comments, this will remain a clean 
interface, there are going to be only two functions:
sev_platform_init() & __sev_platform_init_locked().

Thanks,
Ashish

