Return-Path: <kvm+bounces-47674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF2CAC3826
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 05:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A81D18919B9
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 03:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D00194A6C;
	Mon, 26 May 2025 03:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LD4d+KUY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC31A6FC3;
	Mon, 26 May 2025 03:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748228524; cv=fail; b=ZFNRdzGpEQkUcXZ6CTk9B+flKK3QpwMoNGQYBFm5Hphe79auK63DHnQxME9xrAluGiEBITx3W0n8YWi0igF+ndgN1iqvish598Jy8DH0GDMdUR/wsGWDZ8ptpihw9w3XNRSpXZ8XXbU5u5qiW/ZtDPtCxKMHtzDmLdC4EbiT8mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748228524; c=relaxed/simple;
	bh=j9h+nWU6sdnakJVqEkokhk5ccE46OlKNGmhq/ejnpz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fEiZpm8MKlmauxXRWfk9kTVTcyAPEtL7ABK0Hl6wcl+COo3DY8PzOyZ0ip7XP3xBXNQ4wMEm1MZl1Ik4ChTbfFBer8GeqvFCQuZ3KyZLCE84m9Whc2YqBp5gmPd1C8vfmiVcQL5iL/AgdC0mNMS9e4QiAX3EYR9kODE0C3KRxKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LD4d+KUY; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SmuyrF+mTTE1ljwgmSRKl2zRHSGUEbn4Ov/th6YJH0hgiLro/HdibjebqhL6piMiqi35ZN316sYKd0rfIigUbZbzrl5HpkOZeyxNFmTA7OIeDfibX2/t/p9kW6OEWQ5ZtpqxCPMhIrfVRz2y2afaR4Esnf7KmbryRmIPQxlnmkSEggy9xdWXZYTacDPzImSCoBXvf5c+QiZj7vszv5SNbs8tYCclRsVYEAbEAuyRF4MxvIUO+GKzeURq1kxykFuvkgfkE2F6ayqO9U2aGOoUlhAi7cZcepaNDBQ2bSzwAue2YvQYlqyLUrMW7IU3aG5qjVK/aEiP6RGupztKHV69uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCAt5E2Q1QBW2GrSuCcTgxS7qPbZtkHBbqtQr0HrxO8=;
 b=JGHA3+/LuJTdiMKlKhGLG9m/Cad3Y7XdVb8VVha4670eWxtR4Ag/bsPC51qqNXCa53iLE1Bu1XYrxtU9cHbV2SR/qtjUCSQLgTzPh7R+r250bj42Ntf4zP2AWAhs6YXc8YKu0Yc3Unxjx9AuUW6Qu2mJ0BSMABfebWfgG6lswBcEK0pu+eRyYqhZqR71i7Uvad/LWs0r+yU75+RyLdgqeyc6a2haNymxe6KewtBn5xmI8Kse1h7qNw5sqOVW5924f9aJynH6ZE3Tv04qm72YQyo+njxMeUaRrNWfAxvutjvpCagqmypa8nQL201Cmfa5vVjCXJevHAZiF281SvclOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCAt5E2Q1QBW2GrSuCcTgxS7qPbZtkHBbqtQr0HrxO8=;
 b=LD4d+KUYFh+OyJuNfGZz+S9LESqF4nBWPoEYVqd0KSMoX4d6cGsiOwoRbQWr/sHvpJuin4FtNUFP4dDI7ZA54W5BjAPqTX9B/PCSBYReeYzncAxdOpUH54ILRCxrOoL8nGp01ANwcQPqzM+qn5mQoN0Ywxc67h4w1CTASS4uEvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 IA0PR12MB9048.namprd12.prod.outlook.com (2603:10b6:208:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Mon, 26 May
 2025 03:02:00 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%6]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 03:02:00 +0000
Message-ID: <93dbeea4-8b2b-4b55-86c1-93db99144de6@amd.com>
Date: Mon, 26 May 2025 08:31:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 10/32] x86/apic: Change apic_*_vector() vector
 param to unsigned
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-11-Neeraj.Upadhyay@amd.com>
 <20250524121537.GMaDG4adGsxaPFT7DX@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250524121537.GMaDG4adGsxaPFT7DX@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::31) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|IA0PR12MB9048:EE_
X-MS-Office365-Filtering-Correlation-Id: 4466d611-a464-4a92-e5f4-08dd9c01aed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1hBUHJnQ1R3OFN0dlI1MkNTUFZPTlRmR3doR05hN0FQc2VJcnlxVVBWMEo4?=
 =?utf-8?B?UE9UdGJrdXFqTnRibzJLdk9ZSGIwTWN3TUF5Qnd6TnNZYWM2R09RY0RHOHNF?=
 =?utf-8?B?NGprcDZ3cThoYUZJWGI3NEw1Y0xucUlvS2JJWktXVVlKUDV5cVEvdnZrNXdR?=
 =?utf-8?B?ZXRZc2RWazhVb3lJQThscHp3L2JpYW10TWVOQkllWVlDOVNFbEl4bWxyZzhD?=
 =?utf-8?B?ajRvMUlVd3NBc2V5TUFCdkM0WWhwUmN2K3NFT244RmVGV1JXSUJRUHZCdXRj?=
 =?utf-8?B?Mi9mQlQyRW92TGQwalZldmJjbGN4RmU0dFFyd1VyTGdRM1ByL0YwOXRSMlV3?=
 =?utf-8?B?dFBVSzJLR3U2b01MbmhIa0JxY2xseWoycHkwVnN5NG1LamNHSk5mTUNzTUs5?=
 =?utf-8?B?ak5UNEV3U3lFdFJaeHhlZ1UrV2h4WFRkWk9PdUNKU1lycmwvZFdWa3pzaHQx?=
 =?utf-8?B?ODk3c1p4SjFqaE5QVHJlL3hDSjJmTjFRQ2Q0RG9JM2FUck5kcWY2dnRSdng2?=
 =?utf-8?B?QUNPWEdieHYvQzVTVnMzRkFGbjRNZnduaFNpd0J5d3BxR05qZXhhUHlGaVpK?=
 =?utf-8?B?TEFUd1pVV05sMmowejU5TnlISmFHOUZ2bERROVBLZ1IvSFVKVG1kNS9teGRL?=
 =?utf-8?B?azJZaFk4MWhCOVllZ0paZFJOMFpSVWp6cDRycDgrc202aG5aMkdtaFYyZUR1?=
 =?utf-8?B?WXdLNlFuMHJ2enBJMnROdlp0QXh3aE5ybG1rSytWYUlKUXRPb3V2anA2TEdw?=
 =?utf-8?B?K0RkZnhaTnlNWVlDNUhsSTN5SlBreUQ5YVVKU2FUS3RyVHZ1VW05MnRwZEVj?=
 =?utf-8?B?eVhwWGxZV09zdzlXVDBHajB2Nkw0ZnNSL2FINjNqQ2tobzh5Y0U5Ly9iUGoy?=
 =?utf-8?B?WDZodHgrZHl0VGVHRm95VHdRUVNLU3pQaGFUSElDZmdmQzd5NXVNdmIrWDBX?=
 =?utf-8?B?a0VobXA5WVREdUtiYjhBTjk2dmZiMGVndjhKZ1h4UldzaWc2RlhkbzJqclo4?=
 =?utf-8?B?WUhuRlJiWDd1N1JYOHpmdlgvajM1VDFxczFtV3NjbHZ3Z05zMEc1THhjbE5Q?=
 =?utf-8?B?enI2ZzNHT1RTNlBiTEdIQllnR3pyNlhCYkVXcEIyZml5UTNGQ2tielpVdUdu?=
 =?utf-8?B?V0I1S3BMN21vcnVZTmpGckRML3ArdHpYdG16TDdrYWVPOUdScEE2ekZMTGIx?=
 =?utf-8?B?cjVJaVNDSWJHUHVmeWFCUXpPMnBKZGd2OUg1bGNPaHFVN0FrOG01TGFPUnRr?=
 =?utf-8?B?UGc2a1JleVJodmlXaERWc1NCSDI4RlV4SVVOS0o5ZzZzU2xCaVhQOS8xcFNI?=
 =?utf-8?B?ZUpHdW9XNW45YXFuUVBweW9VbkhrZkRyNkJ6NzZnL2VZenFXQ1BxTWQ4ekZy?=
 =?utf-8?B?WHp0N0s2Y2lrMXM4Mjl4UElTSWR5YW9JVDNTM2xFTjgvYWdFenErQWN2RlVY?=
 =?utf-8?B?N21DQzVEc2hsTUFCN1BiVHNQS2RuZFlEQk9xZUZibU44cFlVYjNDVUhidE9V?=
 =?utf-8?B?YmdDRkR0UVVqYjFFR0hBSjhFd1l5Smd2Q3Vka29Tc0JrY0paWkNmdXhkSmpn?=
 =?utf-8?B?SDMzcXNyTWkvdjdhbmhzVzQwanNhdjQvNzB0amszL1dhbndrOGhDSFFFSXdk?=
 =?utf-8?B?UVcxeWNlRmdwZFRhTitWeXM5MEtUUjRXNmJNVk8yKzMxdmdFcUI3cThkNWQx?=
 =?utf-8?B?WUVhQ1RyZERJbVZJUHBVT0ptN2duaDRnV2NwWjV2dVJIbm1peXQ5SDdNbVln?=
 =?utf-8?B?MEtoRUYvSEZpd3I0bHdwVFBPRGZ3d1h0Q0hRUDdzT3lBM2VIcmdHTlUwRU40?=
 =?utf-8?B?aEhZa01kSStSQVZ5MDZqRmdTcHVOL2wycXZRdTBBTFlLTHVCcHhLTTFSaWVx?=
 =?utf-8?B?Q2FVTHpVR2ltRlg3Y0dPS0dJM3JpU0lqM0VybzMyaXlMWTZMUndheHJ4ek9u?=
 =?utf-8?Q?Zngx610xw/U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0s5OXJGS0YxL1BiYU50MW1OYTMwb0o1STMweGV3VTdMZ3ZUOU1udlZQTXVY?=
 =?utf-8?B?K0hvRzBaZytEa05sbHA3WVVGdjBUOXNzdTdQbTgwdU9UYTdwOVVlKzZENUtO?=
 =?utf-8?B?UHRXRGZrTUJQK3JuNVl0Z2pVR1NVOEU2WGhQd29RRnJ4SGc5bThFV2w4SThI?=
 =?utf-8?B?SWVyRzJWOVdSM1AyZ2lUVGhtSDE0U24wODM3OGc4djlxUDdhODF3U2ZnaWY5?=
 =?utf-8?B?eWtzTHRDNlk5K3hCTFA0a0kyRmxmT1Baa2U0L2prTTFIZ0R3NStzdDN2b3d4?=
 =?utf-8?B?WHhkVUVGVU14YVBjTWs3UmNXbFpBZGlTb1J4NnM5VElBbjU4S1p3Zmt4SzIv?=
 =?utf-8?B?UXE5VlJKVTVHcVh6ajZ5K0ZMZXR3ZEZlWjhjR25PWVljZTJnTjllSTJnWDdm?=
 =?utf-8?B?V2hsVk81ZlQ5R2lyaDUzWWxCdE9Xd1FMSFJWOWFLeG01anVMVHZvalpuRG9w?=
 =?utf-8?B?a0Q4Y08wa1M0RWNidFQzNE1UOFl3YXBhOVE2RmtWQU1SYU8wdXE1VFN2OWpS?=
 =?utf-8?B?aGlYYWY3QUJrSFByWGJvZmQzenBZY0U1SjcvV2RNb2p5OGhvSXdUYXVOUS81?=
 =?utf-8?B?MGFPSXB2NzJNZVVzdFhzU3V1MktOZDVyL3VVd3AweFdMbHJOOGl1WXFwRkd2?=
 =?utf-8?B?Wk9BMHdiQkU4M3JHVXBzQ0JKZDZZUnlZSzUvL05ObGhpa2dxL25CWDhFUVFm?=
 =?utf-8?B?SWdLUkx4U3h1V2FMS0kwd1oxMVJaQWd1K0hmV0lRemlVUkhDdjVsMEcvL29a?=
 =?utf-8?B?bXYwV2Mwb2h6TzdRbXpwaVRzSEVEMXB5OUR2M0xuOVFpZlBqS3lmcmNyQ2lL?=
 =?utf-8?B?YVowbkMvSEN2SWFzN0JScURhbkJ1Wmk4bllocklTV0dCS1U5OElPaWhyekJY?=
 =?utf-8?B?OEkxWTU3YjJPVlpxYnpES0JnRWdZRXVYbXFQa3diZ1FVMXYxM1ZkTU1aUlF4?=
 =?utf-8?B?UjI1b0ZNZXp6ZjdEOE45TlVIV09oWUZOWFViWDl0VksyRXAvMllMZ3B2YWpt?=
 =?utf-8?B?ZlB2NCtXSXZ6UGFDMW9KY2hCSE96WG5kWlNnc3YrY05xcVZhS3BZSkdWai9y?=
 =?utf-8?B?OXdJQ3NZSVRrWDlENnJjMngzcXIzTE4yQko5b3hMSVpUdXN1LzlIOXJtZ09F?=
 =?utf-8?B?Znh4T2tCY1Q1Unh6N20yMFVVZUNZU3BoRVNqdHM0K3JuMG43OUVwNjlyOXdx?=
 =?utf-8?B?TjVtYXpTc3UzanpmVkNsZXNwc1BOQlhNUWV2N05RTHV0ZzdDeFE2cXVuTmNJ?=
 =?utf-8?B?cllta0tiWHZNUnlocVFJSWRDQ0VtbUorMjJBTmlHOEo0OEh4U1UweitvWXNt?=
 =?utf-8?B?NGhHY3I3VTl5bU1uYTd5L3ExeGhVZmdMbU84VWpkVjRxblpDcWpTY256N2N5?=
 =?utf-8?B?bnJBdytqR003THUrWWttOVlHL1FoWWxKbU5WelFCbWtNb3JwN25KdHIvdERK?=
 =?utf-8?B?dWdvU2xERWNKN3RKN25nUjF2cCsyUStRR3VCVlo5QUNhUGNRbWlINmpCLzA3?=
 =?utf-8?B?ZjRrbGpGVlI0bjZ6V0NaWE1kNzBPQ0lOd0pCR3dKU0J4Y3p0aUo1eHIxRE51?=
 =?utf-8?B?ekhVdzVtK0NaZHRvYlZsZXM5NjZnMDZuaHd1eHN2eUR3Nm4xNUY5QkpCZkZP?=
 =?utf-8?B?SmV5SG4yYU1EVjFzdHpkUWpROTdJYTZuRFJOclRKRUd0V0QzQ2ZFNHRHMjRF?=
 =?utf-8?B?ODBTa3Bmc2s0bTZYK0QzQlo1RGhEMitWZFhYaUZDTG5SOVhoWUlzelRpbnNZ?=
 =?utf-8?B?SlBFMks4cUJDMkl6VzJVdlc2eU5zbkRwcUZvOFJrTjVpWHVRQ09ydGJYN3Ir?=
 =?utf-8?B?VC80aktPV1JTWkhEclhGZVlFODNqS3Jpa3B2ekZqVllYcHhWNlpHUXBaZXFo?=
 =?utf-8?B?M1h0QXVZK1lTOVNncXJWZ2dxRHgyYUEwYlVieW5NajVjRFByZVpwZkhtalVJ?=
 =?utf-8?B?c3cwbE0zWjlkZTZORm5vV3FTaGZDN3dIWURseGxkWk5PS0pTMHowSi83Qkw4?=
 =?utf-8?B?QUpVVDVyQ2YvWDROR3gzNm4yblNreDZJbUJCcmczOFFpR2pTYUFaWG94Zldr?=
 =?utf-8?B?WThvTE9TdGZsUzgxcWY5WkFNaTN4RHB1T1kyWlc5VERKZnpWektrR0F1SWM0?=
 =?utf-8?Q?lIoMmw5nO+O4OHV27kpejyokL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4466d611-a464-4a92-e5f4-08dd9c01aed3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 03:02:00.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rcv4aHL+vd+fcnxBj1sEp/Gwvi5V8MAMlMV51BGVhBtzyoBVKljJXVMGQzoYzAYxyqtU57b2y9bvTzxpt/B+Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9048



On 5/24/2025 5:45 PM, Borislav Petkov wrote:

>> * With change:
>>
>>  and    edi,0x1f
>>  mov    QWORD PTR [rsp-0x8],rdi
> 
> AT&T assembly please.
> 

Ok got it.

> This change needs to go first too.
> 

Will update.

- Neeraj


