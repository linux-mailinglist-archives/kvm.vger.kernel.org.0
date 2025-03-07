Return-Path: <kvm+bounces-40428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DDAA57321
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F9A2175DF0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1496257AC7;
	Fri,  7 Mar 2025 20:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WTmRMMZG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DB22561BD;
	Fri,  7 Mar 2025 20:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741380871; cv=fail; b=cNGD5VHyasImiwyBL26xCiD7EYmenTplVlUtDjhTOOLUQlTlfC4ydkpIU6XzsZelvqQ29lUuJuflDHa6//VABA27xQo2Gk0TuTUWZgXwxwb36t3yAYUMN7ZByx1Dhr+ALI93tMcCWZVTAH6u5PLilaO9WI9sN/GFFQDhFua0iLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741380871; c=relaxed/simple;
	bh=aU/cqqWZ6mwAWUf57e4SL1JLiJnrRBNSsLZpVWqsu6s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZtzhYuVajVfWc0dooFZcD07YnbS0TuIgAdu0+eVic9CKbsRAGLDG1ETOJEDwfExNWv0S9SzCHxZyaYZTnnirX/KNwSQHbI0XtODWJlQwLgwUuYC6U2bTb7C2fdNSfoFEC0hBonfusDOVqNL37NeNLIeS0rIO6caY+pUc7L4DJ40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WTmRMMZG; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ar/7ZDC80RRgshCNJUkW5+t48hsJaNNnGdiwqJ95dmUk8/QaCHv4sTGIdSVyiLsu/s/sHAccx4O+AmrLyuVnNyuWYImxf/lx69H12eqb6PC+i+pl3rsXz6Xrg1YxvS7T54FdLtKdGvNwpF0MT49KlzAwKEKtksjoyzlcs7YEeQYD4w2m4ktvg/3Vw8pI+EAcMKJ9Cbxv46GXlH4xH4gE9cNqz0//bqP2y74v+FYWMujyDzew6MUP4+Ab/CFtUJG+q2Y4CYvVOpoC35EyigdDVj+U5cLwsATGIBy5Kt052Jm1jyE4avgTBFFuu2heH8AdjigRoCv/dDbuwUrMWrU+sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4rCACjPeTU3Pw+qMbsw9WwcsxoIDKX+QNUaMxoVorE=;
 b=mVWZ0m9mG42nNdseQIG+3YbgnAS/nfDzKLe7VbQCa7E5+SUpK/oui0oKyXdXMjJdjN95sRhQyZ1JmqV1GeHdc6r+vNmI3iQe+3H4oFENTrEcKLgD8ixGf6Iecc5C/2EVQkHno05bAa9P4E4+t2z2s0HC4rL26bYl5pgdZ1wn5OjewFYY8124I8mmmiwPut8q5VP2QufPYMMO+BvK5k2L9XZgm1tpNtRBSVAFXoMp77wIhOH1/nSZMzqZVerw0qWfGqUe/txsFh5brXhZHIpDTlOhHqRQMPgzdWje/J6HUmpttsmeuIgw6wDM7k5L0gvAsrYQfcRmICXayHkWQNAJ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4rCACjPeTU3Pw+qMbsw9WwcsxoIDKX+QNUaMxoVorE=;
 b=WTmRMMZGkQ3bWkGQt4+7acu4IkDaeTG7T5DfV7kqNdT/WU1c/IxWDb3AB41KKANLIB4ZtrweVV5BINXZXuYZ5TpGOibRkFOC9YuhGosD2SaI75pc1L1x0CN1j7jIEJZNE2jwurJsM2JcxrQg4UhxzXLP+hDhtHmyvWcXr01ozzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PR12MB9645.namprd12.prod.outlook.com (2603:10b6:610:2af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 20:54:27 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 20:54:27 +0000
Message-ID: <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
Date: Fri, 7 Mar 2025 14:54:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT
 fails
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:806:f3::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PR12MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: d862a389-d99c-40ae-323c-08dd5dba3fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RkxDRU9UL1hSYzJ5OFMzK2ptWnRtY3lOb1FFaEJJNTRaemdWZnZ2YmZVeVo5?=
 =?utf-8?B?eFozYkgvNUdoY3NoazdUMW9waWM4eCtqV1YyVlFGcGowdU5UemJBQmZSWURW?=
 =?utf-8?B?cEhwRDVuemRtMEhQQkkzYWV2TEg0RDZXcUc4WFFjOUtTZHBsSktCaDZkNDBx?=
 =?utf-8?B?TzBTMk8yeVZzV3B1REFhNEJKeEZiZkRqN2h6cUtKejVXaGdLQUh2QjZEY05F?=
 =?utf-8?B?QzdSdGhyZ3dSdHZLN0R1VHVkTXFHZjRRT0RMTWFWcy9IMmJyYW1QRmRoZEJT?=
 =?utf-8?B?WWNSMldWemg2bEtWYU1oL1ZQUTNpb1YrYVovZGk4Q2l3UERRSzF3VFpkNHdh?=
 =?utf-8?B?SlFzdTNzd1dCUnRhZi9wSk5pc1dQdTlKNEFTYmhHc3B0WTZPOEY4NHgzdmto?=
 =?utf-8?B?cFZpL0Z4WU5XUnNmUCtRN0VGNTI1QWJadlRrcGtyeWRrZENyeDhqMVA4OVRu?=
 =?utf-8?B?OHhINUdDQVNYblcyc0ZwTWpzWG5LOGtmeHpuQnhMMFU0MFRxNUFRUDdhUWtn?=
 =?utf-8?B?cU8wVElFc1BBMkZVMDJDT1o3UnJjMFBFVHd2Ny9JRVRCL2xXOFNiVWJKWXFn?=
 =?utf-8?B?Q09QL1N0amhhcysxSXl0Zlp1QzI4Vndla3BwZmtDTG5ZRksvNisrUjhyVUtN?=
 =?utf-8?B?Y3dvbnZCWkxkcjdrQzh1cTdteEFqek1QZEJ2TjYxNE1FWWxxdzFGME4xaFR2?=
 =?utf-8?B?dS84ZE9tbVV3NnlwTmNXMC9Ga3UvYnUxMU4xVW5VejRqUTVBenZZS3pDcXAr?=
 =?utf-8?B?aHNaSVQwN2ZrRy9sRElyRWo5SmxHL3JDZjlhVFRSdW1NSnNZL2ZpdW56M0JY?=
 =?utf-8?B?c1dFR2phQUNuWGdXZ3pRR05xOFRFb3RLbTRZdHlPTW9PQit3V0dpblFiN2lr?=
 =?utf-8?B?endNOGpmeldFRU5HUTZVZVBCWjBFNWFFdDJWbXN1NHcxQTBZeW1JdjFDNmtY?=
 =?utf-8?B?RTZPVlpsOHBjbW5kM2k1MUcvUWJ0WEd0UnZNM2Zpa2NodmxReTkvY1NiTVVI?=
 =?utf-8?B?ajJEWE91OURQdlZyMWR6M3NBVmR3OXE3clAzV3ZmUnNTSnQ3VHhray9sUGla?=
 =?utf-8?B?MWw2V2NtNzVmemdHd3NGbzE1cVZBZndYN05ZZkowbWVUNzBEbWV3WlRwMnNq?=
 =?utf-8?B?a25HcHlycFBvWUVHMy9MZ1JBNEozWmJ4bnMvL1FwRGxmRDB0SXVIQ1BRY1ZH?=
 =?utf-8?B?M1ZjTUdXTHhaeU9hYmkzU09ocVVtVExLZ1F0dkJDUFdxRTFIUFJ6emxmeWdD?=
 =?utf-8?B?MCt6cTdXS2dQWWxvaVhub3l6R0xvTi91ZjI0eW5FTnVEdzcxWUxKTVZ0bU5T?=
 =?utf-8?B?aFNzZzNFQlNrTzIwdE5Ic3pyUDU4MHFLYzAwaS9hK2dnY0pnY3FBNm80Y3Fu?=
 =?utf-8?B?OFZCZTkxOE9zbDR5WnVuRStvc3R3cldUcGpxZjR3TFpnMy9Ua0FVT3Z1c3oy?=
 =?utf-8?B?WWNlUGxGbEd5WjhzVkFCVjdlS0lLeEd4YzFYMEFoN3J3dFZIdGZyUmhxYnJj?=
 =?utf-8?B?aDgyR2QwdDkxN3NiOGNWVFp0STMrOFRucktTdlg5c2lLYWR6SGJHdTBBczZH?=
 =?utf-8?B?WmlkdGNZNG91aWlQbjZUUXZxaHpsZThBY29Ba1hqd3QwNTd0R1FXTmFyWXFj?=
 =?utf-8?B?S1M2YUZzNk9ub05Mc2l4VzVZVWFXTlo4MCtUQTVkUTU5Q1NhMXR0VStydmw2?=
 =?utf-8?B?UjlzekxZNFdDZjVLeHo1d1VUZzQzdUR6RmE4VGVBNTVnR21DOFlaa0VYUGxq?=
 =?utf-8?B?VFZycDJqT1VONzZzRElCUzVXd1A4YmZrOWFiOEZuYUY4b3gwZ3l0VFpzRG54?=
 =?utf-8?B?U3RjNitZQTlGQkFqS0dlNXRHdmlXMWZHT3lrdVB1RnhHOUljWThQTndoM1NH?=
 =?utf-8?B?enFjNEo2dXhjbUdUcnBkSTI3VC92ejFzNFpqVGpmOVFxakk3bm04NUJSOURC?=
 =?utf-8?Q?/201ics5wFc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjYyZEpxQ0NEZmRWSzdxQ2lEdE5DaUlIeEJTT2xpQkVoRE9nVnNrbFQ1VlB2?=
 =?utf-8?B?NHI1Y2NnYW9qcUZRRmgzNVFSeEduMVg1WUJ4S0VFSjFRU0RYQmJQdGkxbHY3?=
 =?utf-8?B?L2dGcFRKNmluQWhPdDBRVXBHSVkyOEVyUmZKMURxOVExQ0hyOC90M29WTVl6?=
 =?utf-8?B?b00zVnFZaGVCZ29KMHp5R2t1L3UySXJZZzJiQ3Q0Wkw3UFdOWDEvS1djSWta?=
 =?utf-8?B?WEpNbmJzSGJKaldyRkVUcWw5QklPS3JBVFlVUmxJUVJueWVkRmRWeUJUWmxE?=
 =?utf-8?B?VmVnS0JOTzVrLy9Ja2V2bWprQWg2cm82eS9Qa3ZVUlFpaHhHTTkvQzAxc2Zt?=
 =?utf-8?B?ZEl3YnZwbm91Tmp4SlM0YlBXdTJyMUxYQXdTZ3MrU0F1T09DenZIc0VNRU00?=
 =?utf-8?B?WGFIRHpQc1JBd2FuTEV6NjM4QWhmbmJRaGo0SVdFVTFOOU5FVUFuTmtQY29Y?=
 =?utf-8?B?bnZTbXZsblNJdmpoenM2TmxJRnppb0tIUEo0MFpvQVp5MUZNWXZxOHI4OGZP?=
 =?utf-8?B?dk02WDZ2V3JaL3psZzhVdExFeDhYZVRzT2tJVURTRmVUOGRrOVlWYWNhYXBk?=
 =?utf-8?B?cDNFK09XaGFRdi9mL2VtYWpta1lsc1F5ejdBTzl3c0psMk1oTlFOK205RHd6?=
 =?utf-8?B?SjMxMDR5ZHorM21vZ1RDVGl4YU9xWTFWYWM5ODd0d2xTbG9LZ3JoWm5EQTZF?=
 =?utf-8?B?Wmg2UHIreHkweGxSZXVmaDlWZ0NJRVp2Uzltc2xOM09CSWYwTlhybCttdStO?=
 =?utf-8?B?MlRUZ2V2MHBtNnVZbEVUYlNrZVdRM0dSVXJsajZYZnQzNE9XM0dCNTBobkRx?=
 =?utf-8?B?c2dVSFhYOFFDUitkUjhqelRlNkFpRlhLMnNxclVaUmc2R1BrM0ZIcjRVNm5L?=
 =?utf-8?B?YUFVd1pCbXE2ZDRXeVdQc3Rpa2NUK1VNaHM2U1hRMDdXK3J1WWxuR3FNOEJi?=
 =?utf-8?B?SUNrb2JMOWxnKytIaytISitnNGVXOHVUVk1IcWZyY2xZdTJ3b2VsZW0zUmVS?=
 =?utf-8?B?L056Kys0d1ptWCtXM2FFUjhwZnZxbGVaV3FqcW9xUU5YWWVxMThhM0FabytG?=
 =?utf-8?B?cG5aN0RiNzlhVTlsVnZIL01OVXdXMy9vOFMzbWR2enRhWmVOZ0UrRk9mT29s?=
 =?utf-8?B?OUFvU0J1VWEyV2ZzcjB1WWdveHJ6ZktOWU44T1RsR0VLR0l4NS9icG1waFpn?=
 =?utf-8?B?YjF4Wk5NOEdFd3Qza3FFS0NoSTAxLzRORlJUb1dieUF0amxlSFNEb0xOd09m?=
 =?utf-8?B?b0lQMTVMWWJUY3pSbGVHYUNGdTVUdGRWdjZJeGQ5RkYzbW8yajltbC9uMGJl?=
 =?utf-8?B?dWJaY0l5ZW1MMHFLeDZ6WUU3NHFtL1oxTy93c3l2dkxLNWg5OTIwWVp4M3FL?=
 =?utf-8?B?c0ozZVZUd1JQb3BGbEg5RUoreGlVdXQ2RmMzaGFXMEYwUmhmL3o3MGg4cjMx?=
 =?utf-8?B?MFhFYkViZjFRQ1JETGMvb3VFNkpiTjlEYkp6QkROcU5Ba3VnTjVRZndlTWRW?=
 =?utf-8?B?bjUrU2cyYkpHZUFpSGRIOUw4Z1dzMlRKdENRWGNTanlDV1hDSHVIM3JsM3BE?=
 =?utf-8?B?ajIxMGRCWFB1Ym8rSFFWb25mNzZ6cE5tcjRXcFNSQWlRRnltQWRKT0V6V2FB?=
 =?utf-8?B?RFpxTSs1c2xGSHVqTDc1Zk1MMjY1dFhnVDBhTjN6QmFQNnQzeXFld1pzQjZK?=
 =?utf-8?B?bXp0L3JiTnBPN0dVcFExTkxaM2RneGtiek85V0wxampBOVhrcmxWV0Njd0tr?=
 =?utf-8?B?MFI0SUllWnEwaTd0MXJhZmFqSVlXMlVuUDIyUHNpZmI0YkdrcnNKd2RHKzFY?=
 =?utf-8?B?YkJnOHBJckVwVlYyNGJMS1FFUjRrVENNNHpPZnlYa1FlalJWajZTSU9HWVRt?=
 =?utf-8?B?cEoveWxxaWZPTkxuMWcrWkV3V0J4Z3QxT1E2RHpzTHJZZUFDMkxpZVRDTW1J?=
 =?utf-8?B?dDZnYVNyZE1EWS9iRGZ3TEw0TklEQkRNNFIrcWtIYk5uWnpOL09lenRTWUt5?=
 =?utf-8?B?UloxdUN5S2RXMURQdXEzZ3lGeStYL2kzdXZRb3RiSkF0Wmp4SVRuZVhwMkV2?=
 =?utf-8?B?dFdkOXErUTdWcDNpalVRY21FNUhUSHJMbGdMeHlKWENuMVVtbWN5Q1RiMEdw?=
 =?utf-8?Q?BVYdvyq6CTGeus4fcoYPsteSk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d862a389-d99c-40ae-323c-08dd5dba3fcd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 20:54:27.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPc0rLdlJBPjS5zkrtedYn5uNoX2lsAN203GVi4wVSbYz5R+PyHy6UgnvJpxkbcApIM01scsblnb3gdgCbLZIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9645

On 3/6/25 17:09, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be

s/RMP/the RMP/

> initialized up before calling SEV INIT.

s/up//

> 
> In other words, if SNP_INIT(_EX) is not issued or fails then
> SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.

s/once/if/

> 
> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2e87ca0e292a..a0e3de94704e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> -		return 0;
> +		return -EOPNOTSUPP;
>  	}
>  
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	 */
>  	rc = __sev_snp_init_locked(&args->error);
>  	if (rc && rc != -ENODEV) {

Can we get ride of this extra -ENODEV check? It can only be returned
because of the same check that is made earlier in this function so it
doesn't really serve any purpose from what I can tell.

Just make this "if (rc) {"

Thanks,
Tom

> -		/*
> -		 * Don't abort the probe if SNP INIT failed,
> -		 * continue to initialize the legacy SEV firmware.
> -		 */
>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>  			rc, args->error);
> +		return rc;
>  	}
>  
>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */

