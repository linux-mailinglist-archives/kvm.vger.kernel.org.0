Return-Path: <kvm+bounces-34807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A85B9A0633D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30A9F188A5A7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 17:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46650201002;
	Wed,  8 Jan 2025 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Trbeyz4Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8FB200106;
	Wed,  8 Jan 2025 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736356966; cv=fail; b=EKeDaOIsQauky35FKBHs+oMqBSj7PeHf40m+FimXaH7ycDvalESO6MKWbzLHuN+s3ursKVLtFI9ajfTps/8H8XkY1UYepBJviQuYds0tM3b1EZoY1rUqLamBtqNLyTCLpMBewwoY1LEbnqNw90RKmzdFbPdByWKuZx0YEEl1u+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736356966; c=relaxed/simple;
	bh=K5pRZyaQVrq5sN983w960lMAH1717n7S7GHy/5v8aro=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d7ytnq/KaQo82lWFQGQOVAYP7paN4Olu0kDhmoal24RWqPKYbBswNZ1O4BGp/JFCRdX+QKHy6Rbd7G4vzpEy3ty6nEsmUJIFB6H0Q/ckuYfRaeBumY9FUDRz/UHBHBwsGCZ+8H+tsm0xcyJ2TNO5SEKed8ikxt1mHTPsM7s6Aeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Trbeyz4Z; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwJ69r8Rjm20QPlUhh9KVgu5RSJDVOMHGh3xgl3TImRZV17QwKpmm1cp6UmERqer7FqQ3DwoIz6qgDwvxyxSGTsXPT35SHHta5PmLNxXNujSkGXWa2VmIR24KTxEWbZdmnfDIF39iEVvAP2er+cbDck6cKazCAg+WCWFB3kJhKXCs4E189cTRAjKI0upOqj2szrXoe/RZ2I685nC4sZ8yDgVY7+WKCjQqhvh5yiIb8hea91iTPhH9uqlmd6RDPxgC2ySIcGj3x/mg/ZS4QTXL/y6YLuVcg01vM9hDuPsO9lAo5zBMca3/SCF7UtpGtR4KxdI6XXyEhw0jiwbuEa3gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IptLKqlFO9DDWkT+N6Tn0CJdwIjR7DBchPu/pwHJAt8=;
 b=DBnEINkgrSx2mGPA4QW+PtZPLLvYCwfLobrP0g0rvdl9FVL/GZs19e9ADh2uiCNFba1nSKcnzW4ZkMkHsbK+nkdNRpcyOeMnv3/3ZLLAB5IMffhuFSex+eTkwJyH+rB8fTVNzhXqKaC3sx8kM+pA//0FbGsVPlvcdBQm2fdoVkZuLRYAnJgKYGcNFIh0S4KCzUHs3X2/aB0hd3os1WPfztFMEVwj7KPgl3Mxunq1ZF8qf3ExX3n8Tq+2XdOKgk94ZbtondtHoS6/EK36ap6Nx4IPFHbhJmrxoDpcmq73qn2dh9kUhFVoz2KMzMhfn36sCsQldVXCZGkG8HYpS7JV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IptLKqlFO9DDWkT+N6Tn0CJdwIjR7DBchPu/pwHJAt8=;
 b=Trbeyz4ZDdlHGynOZeaH28GVvPIEaAM/uhkmpsQrc0MjQCD7GjkCba28xNDR+hNRhmuz2q+QeMGUimocivS7qto30YeAl+57YMGEZ2RaMpnqcCUpVti1hwv3HnWHVtlK4Q7RORct0iJ++oA+MdUDcSM9j83IJJIusHzEMO8WzsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8902.namprd12.prod.outlook.com (2603:10b6:610:17d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 17:22:42 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 17:22:42 +0000
Message-ID: <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
Date: Wed, 8 Jan 2025 11:22:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: "Kalra, Ashish" <ashish.kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:805:106::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8902:EE_
X-MS-Office365-Filtering-Correlation-Id: f7884ad6-e089-4dfe-b149-08dd30090efc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTZlYmR2ZVZReUx4NXpuQkx5U0c0ZHYzc25QelB1T2hUN1lCVVBVMjJwd2h4?=
 =?utf-8?B?TU5IUW9GUmFSU3NQTDFrU3lzd082aklpUVFUak9ZZWRwaWU2eEJHYllJVExW?=
 =?utf-8?B?akhUY1U2dGNOb0Z1NkVsM1pvcTJqZzZHeXp6V2NkN0Jya1V6VTdMQUVkMGVW?=
 =?utf-8?B?aFJxSHBFZCtTM2JBWS9QSWVmSmZrZjQ5ZndCdUtmY1A4d1FZaFI3UkMyanpX?=
 =?utf-8?B?aHoxQnJUQ0pIR2FJSit2VzhkUlVPUkNhd2ZyekVUUW1DSUFEMk5mS2lsYjVM?=
 =?utf-8?B?Uzc2VkMrQzU4LzBtcHNxSFBNRlVDV3gyMmZ0ajFpZkJhcitxSk1KRnRUMlFt?=
 =?utf-8?B?UlMxeTMzZDlsejJJYURkcEpqMk94RTR3U1E5SHZvdmtyLzRSS1NoTFU1bm1R?=
 =?utf-8?B?Z200ZHZsVW9WRGxISko3a3BTMmNOeWg4YnVXR1ZvU3h4K2ZlSEtSREFrSm5C?=
 =?utf-8?B?d3d5SHRLTWlLNXVNUUlPT1BvQjdHZGRtWWloRnpoNzREaTlVeGtIbStDUE52?=
 =?utf-8?B?ODFSR2xYUWp4QkdWRlUyUzRWR2ZNQ1dISGVCdGpRUC9sUkl4WVJVRmlWQ0th?=
 =?utf-8?B?Y3ZFOHVmUlZxRlBKdFR3RUltY3cwWG5JZDJ1bUI4YXJORm4zeDF4ZkZNYmgy?=
 =?utf-8?B?TXlCMVJLUHhqbWxMWUwzdzdrS3dsZ1lRYUhScHY4T04xRFRCYVJUWGFwNldX?=
 =?utf-8?B?bTVmTTI2TlNTV0NrNFZMdCtyeVlXaHBTYnQ5WHhhTG9sRldQUEVtTDRtMWww?=
 =?utf-8?B?cHE2RVhDc000Rk1VWDEwZWJLbU5zN0ZWY2UzenAyVkpoR3JnTVg3NE45Zys1?=
 =?utf-8?B?SlMveWdtbHl0Z3Q1cnhnZFhEeEZsT1RtYU9GVHA3NHVwLy9rNTVrUXUwMjJ5?=
 =?utf-8?B?Wk5kYWlITFY4S0lIZmJOeG5laFpoUTd5aXpBUzdTN3Z3QzZieTV6ZDBKQ0ha?=
 =?utf-8?B?ZGVtS0NBVW42bTUvem8wMGRxRmk5RVE5OUJEbDBPOC9xZWhtNnI1V1lzd3pZ?=
 =?utf-8?B?VWVaL0UzVVlHT1lpak15U0V6UEtnbXN6cFFWam5SWUg2c1dwRlE1SVRqbk82?=
 =?utf-8?B?Q1g2Rk5qcUhLcDlvdXVyaWxrYWFDQmV2SDlTa2FleTJiWnNLY2ZFVWVrVVJr?=
 =?utf-8?B?V0NWT05tcm1SY2VSVkcvbnBUajVGSy9PcDM4bmlOVHUxQldaczNMbEpnZXZn?=
 =?utf-8?B?ZG82VzN0ZkV1aTRXMktNa3A5UEN4QUJ2NkhmMGxPWU5HZEFqRDJCL3pMME5n?=
 =?utf-8?B?NzgydlVGR0pFd0UrZEQyTU9nM3dWRVAyRGNBRGFRdE9ST21Mak5WMWliT1Fx?=
 =?utf-8?B?cHVLU253aHFLcE9VMUZoS1MzbHkvZ0orenBxV0dwc2wzRThQR3AzNExxMFRU?=
 =?utf-8?B?TkZGWlF1Y2xaR3lUMjJrUXNBRHhmL3hCNUFGUi9wM01BTXlnQnhremJUY284?=
 =?utf-8?B?ZXVQb3cvUWNSd09DM2lGMUV5VjVlU2VXV1kwSU55ZWVVczVPRHBMN25ZVEdD?=
 =?utf-8?B?eTRwOGE0RGVjWFhiVDZ5NkdZakJXV2MrUDdsWXRid1pUcllDNXhkcVZZbC9y?=
 =?utf-8?B?aVFCU0hJRDNKbUhzdXpJaUJnZlZ2WlNWaXZDOGorLzlEMWVPMWl6KzFUQ2h6?=
 =?utf-8?B?bTlST0hvR0ROMUxNdkV3aXpVOTVxTVlJTlNiZmI2THZlWG9oeU0vYVVsNmtm?=
 =?utf-8?B?ZDd5UkJMOXFyR3ZoTXUvSGdJVXh2TGV2ZUJ1cytNYWhSZG0wVXZ2MlVqWUlx?=
 =?utf-8?B?dG1NSlFBYzVxK0JFWnR1YlhsdnZaTm1FcTdiNStBTVg3SDBEZThnNWtZYVY1?=
 =?utf-8?B?bEJ0VVhyeHNHeGdndy9yQ3BmSjMydU5OUHY3d2ZNNm8wUTFhZWo1a1JmZDFn?=
 =?utf-8?B?K0ZYMWRKUEF6cUdwNHZaTDJiNEJuRW1yVU0rUGZvQTRLRllWOC9lSHpBWFVa?=
 =?utf-8?Q?LmDf+4GC/nE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NW82dDZXMUdwZXdwdkFOeUNBTVFVeDBaL0VFYUdMcWhqczBMMFFCSEF3Zlpn?=
 =?utf-8?B?ZzhxSzNhazBVcjlXbktTUlg3YkpaMmpleDFSVTVFZG1YMENCMzNsbStrUHQx?=
 =?utf-8?B?d1VVTTBJalVBZ05MRTFKMitpd2gvM01UZ2N5aTlPMVZCUXIwdi9lbE9Gb0pl?=
 =?utf-8?B?NGVzRzliRFpQY01JQTRHbStvRWowUmVjbkhzRTJaR21tREoyVnRlbXRlN2RE?=
 =?utf-8?B?Y2NmSktETGdweFdOSGxLOWpKekY5TkNNQzlrakFDMVVpMmVLckVlWFpJMENs?=
 =?utf-8?B?cVl5NFVjZ1hGTStiOG53bis4R09OSkh6bEJvVXJWZklydStFUXp1czZXUFY0?=
 =?utf-8?B?N2huZytsZlY2V2EwaFlieThFRUhyd0YraTNORXlSV043MmZpbEcyRXJmaEhz?=
 =?utf-8?B?U3BYQmNja2Uza3FGZUdvTW45NVB0ZU92d2NSMlUvSENlRXBNYnl5S0VSY3BQ?=
 =?utf-8?B?aDZJL01qb1dVWUY5TG5KNWdJT0JGN2h5VVpyTnhjdGxPVy9td1RyTlJ0MHJC?=
 =?utf-8?B?bEJzRGlyTmRFU3B0TVhjTlU5U1B0K09NQzVBSmUzeEM0dnlaVFBHYTNnOU95?=
 =?utf-8?B?S0xRU0tqd3hpbFlXeXpLRnZIcXl3RzFHeHdwOGF1YjNsMVlJQ3NJVVlidUQx?=
 =?utf-8?B?NUxrWVNEaW5uSHF1QlZhOVdjOUQ4YXFvUk1BZ0o5Y2FzMmd0dkdqWGJwRDkv?=
 =?utf-8?B?cTZ5Zm96Vk5RLzFObEpERHFrYklSZ1dsTWtlNHoxR0pjeFdSOUtScEt3cy9n?=
 =?utf-8?B?VHhOVmJZNW83cVFRSHpNSlYzMlRrMVRpUFF5YytDR21iek10WFJVTnp0Y1ZQ?=
 =?utf-8?B?SGdEaCtxbTd1L3VQbFBkNEk3SVJ2b3EwNTg3MWR5Ty9GczcvcmVMajBNUytW?=
 =?utf-8?B?Mk4yRStCTExLM2VsN2JXbVIwMFE3QllkTUF2ZXhPMnE2RktsMExZSW9Fd3NK?=
 =?utf-8?B?K05LbUFUcUg4SVN1blNVWm5XT3U2RjNpdy9iVzRhR2JEYVdFeGhKWE04ZGtl?=
 =?utf-8?B?K1lwZk52MEJtb1VNQUh3bFpzMklHNFI5YzdMTEtxWWlLVGczeTlkaWZWQU8y?=
 =?utf-8?B?SUlYdmN1T05uV3NhNHMxRU5TZ01lRFdBbXByWFYrYjZqenUxR1d1VDZNTzVQ?=
 =?utf-8?B?U1N5c0RhRnBNT0dZWEJmOVdJOTVJQ29iVi96YStnYVhZQVdFNW5VYmVFOUZy?=
 =?utf-8?B?RHRmYWVvR3FhWG01dDlObTFxVE5Hc1d1Zzh4M1QvRkM5Lzl4Z3MzT1ZNNG9j?=
 =?utf-8?B?T1Q3VTNZaVlNUVVWb09TRndCemlwMXd6bktUOUNNM25kaGhsR0ZIVVBoaDNa?=
 =?utf-8?B?czFhVjZhcEwra2EvcExJWG5vR2d6M0YvWjFIcmtEU3pBcjRMWWpCTFlkMGR0?=
 =?utf-8?B?M00veVcxNTdkbjY2dGp3Qkt5SjV4V3BKUkhxbktBdll3VUhPYVdNdUxYNVI2?=
 =?utf-8?B?NmV2eTFWbWtvRDM2cGVDUGlrSC91bk9TNldKS0Zsc2lRUExtRmJEbXova1BE?=
 =?utf-8?B?WHB6YWRnREUzdkh0Q25jK2dzck5OdzVsRlB4RWpHQmpZT3llbHdpNFVyVzlP?=
 =?utf-8?B?dW1qZHo3SHNIdVVGTVBHdU5PRzVBZ3h3Slk2a0xaSW9pbTREanZ6RzlvWEdt?=
 =?utf-8?B?eDh1VjEveFo0RWpoeUdNa3c5VzQ2ODg4eXllRWRUUFV1Rnora1JnMlZyVjVM?=
 =?utf-8?B?R0orL1lUZ2VmVEpXV0s3WlI4L2pyWWxHUXNFNngvV1RQYXdkQ0VxK1JGbEMr?=
 =?utf-8?B?V3ZrZzRvOW5kZVNjQnMrNndhSTN1MVhzdDlaYUpnbVdoMjl1UGJIOHd1K0d6?=
 =?utf-8?B?R0JoQkI0SEI5alljZ1ZVZnN3Ym8ybFQ5Wk1XNVliK1lVVXdEZ0Y2aUtodGZP?=
 =?utf-8?B?Uk5ZOUIvYzNPN1ptR2JrTXltMUdlQThMZElnbkQ3ZlYrUERpRGxTbmgwa2ZV?=
 =?utf-8?B?cmYwTEUxd3RoeVNlWlc1SkNNWnB6Sy9UK0NiYldhZUxXWDlOaXFXbERPWW1z?=
 =?utf-8?B?OHNnSmQzVE0wSTV0SCtGTGJST2xQYzEvT1I5ajdZSjRySFFuMi8vMmU1VTJH?=
 =?utf-8?B?N2NJTzBJbEx4b3dWeTc3RGxpZnpOdElTRHlxWHhsSVVQMTBvY3E0cC9vYkE0?=
 =?utf-8?Q?t8PwlJZsuS61/waK1RMElCGv9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7884ad6-e089-4dfe-b149-08dd30090efc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 17:22:42.3579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRD8Gd7Ka/HKY8E+uJy514VnfYp3FdxuNbIvjHw0WzFv7xhsvCFXJBxQ47//IAmRxJB1esNV39ZeyRXvaN+sYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8902

On 1/7/25 12:34, Kalra, Ashish wrote:
> On 1/7/2025 10:42 AM, Tom Lendacky wrote:
>> On 1/3/25 14:01, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Remove platform initialization of SEV/SNP from PSP driver probe time and
>>
>> Actually, you're not removing it, yet...
>>
>>> move it to KVM module load time so that KVM can do SEV/SNP platform
>>> initialization explicitly if it actually wants to use SEV/SNP
>>> functionality.
>>>
>>> With this patch, KVM will explicitly call into the PSP driver at load time
>>> to initialize SEV/SNP by default but this behavior can be altered with KVM
>>> module parameters to not do SEV/SNP platform initialization at module load
>>> time if required. Additionally SEV/SNP platform shutdown is invoked during
>>> KVM module unload time.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 943bd074a5d3..0dc8294582c6 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>  	if (ret)
>>>  		goto e_no_asid;
>>>  
>>> -	init_args.probe = false;
>>>  	ret = sev_platform_init(&init_args);
>>>  	if (ret)
>>>  		goto e_free;
>>> @@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
>>>  void __init sev_hardware_setup(void)
>>>  {
>>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>>> +	struct sev_platform_init_args init_args = {0};
>>
>> Will this cause issues if KVM is built-in and INIT_EX is being used
>> (init_ex_path ccp parameter)? The probe parameter is used for
>> initialization done before the filesystem is available.
>>
> 
> Yes, this will cause issues if KVM is builtin and INIT_EX is being used,
> but my question is how will INIT_EX be used when we move SEV INIT
> to KVM ?
> 
> If we continue to use the probe field here and also continue to support
> psp_init_on_probe module parameter for CCP, how will SEV INIT_EX be
> invoked ? 
> 
> How is SEV INIT_EX invoked in PSP driver currently if psp_init_on_probe
> parameter is set to false ?
> 
> The KVM path to invoke sev_platform_init() when a SEV VM is being launched 
> cannot be used because QEMU checks for SEV to be initialized before
> invoking this code path to launch the guest.

Qemu only requires that for an SEV-ES guest. I was able to use the
init_ex_path=/root/... and psp_init_on_probe=0 to successfully delay SEV
INIT_EX and launch an SEV guest.

Thanks,
Tom

> 
> Thanks,
> Ashish
> 
>> Thanks,
>> Tom
>>
>>>  	bool sev_snp_supported = false;
>>>  	bool sev_es_supported = false;
>>>  	bool sev_supported = false;
>>> @@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
>>>  	sev_supported_vmsa_features = 0;
>>>  	if (sev_es_debug_swap_enabled)
>>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>> +
>>> +	if (!sev_enabled)
>>> +		return;
>>> +
>>> +	/*
>>> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
>>> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
>>> +	 * VMs in case SNP is enabled system-wide.
>>> +	 */
>>> +	sev_platform_init(&init_args);
>>>  }
>>>  
>>>  void sev_hardware_unsetup(void)
>>> @@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
>>>  
>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>>> +
>>> +	/* Do SEV and SNP Shutdown */
>>> +	sev_platform_shutdown();
>>>  }
>>>  
>>>  int sev_cpu_init(struct svm_cpu_data *sd)
> 

