Return-Path: <kvm+bounces-52524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDD5B06467
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C56051AA23FB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1495627876E;
	Tue, 15 Jul 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XWOLf2sH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6C01D5CEA;
	Tue, 15 Jul 2025 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752597294; cv=fail; b=X1h9hFo3fW7sRuPtQolxYjWhDP3DNtY6rGptMBnWfPvuClxzbzjmSOxhTWwMrWKtJMlPS5V2xGJdVPrBSMbx5xH4JlPrEEUqsU7UmmM6wTcqe3AgO8KrQFIcrRVOQfL23yG8qv0HjPc3VtVNU1qbupuNn6V1iYa6ik7cR6NLI8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752597294; c=relaxed/simple;
	bh=Xng83imbF4NYK4+1LeSOciFKPUcFcYc1gt/0TW1fkg0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WnaJqRqf2Xh9/khaQ5MZ8FrivJLmmGJ4gnWhLrl5fN9vm8Mr2WIKDyC8HMdEi/JEIGecawtlg3hGxwc5DqSc0cYT5JVT4rLRRxB8Vh0PtCnmCV0v8vRyyczq64wAwjl++LM/bqySz0S3KhOusWFDG20MSzo00RSkNsOUe4Zx2tA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XWOLf2sH; arc=fail smtp.client-ip=40.107.243.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QHzwKdEZmdNbxjyrxZTTnJuFq+y86Ng+n0jNxtlWQIAJOurcnD8LfA6vuVS7ocogthH3G7nnOFZTUFsPm6qCMCk8ghib8CNdx7aJVIIcSZaMdjoUyx0Si744du5fsW6JU/TRDejadBd6Hml3GqU5vwwKadIbEeyogbkl+yGUXVXrt+A+Q/0uJPF96pYjKxu5Qk2FrilNc1lQEgyWuQCHNLryumGy47o+KJZcDSwJJKxvuEoTwShQVccPRiFuGI2BnWuQa2gbs28slViYJ+ARyErNY/SLTKmccRkYt6QgZLTsASQETEDRh39wNb3Nzipjz2DOO7yLqRpDXC0qALNlmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9PjMuTc/nqLhbRnPR3+KKoerol0F++z+vAtfTYUHNQ=;
 b=ZHalBcJwzRHQuenoKnUws3+m0oOIXHkiSPK3Rka9VkYhRXMFQgXwRR8a/eoSXB36DTW6WfXtU81yvtFWky05j+1ysR8U8p+LWpihoekNqgTnr771eEqNqC4qI9Ef5xAHSGGK9+csvHOgXwQism+ToK4YhkPGYNeRtOR/w+VytWk6pWqwYXKL3Ob6frnNw3aTs8X8GfO2z+1kXDyhk4sjBQFqEIEyB/UD3SmIcPCU58BxQ7mcQJ9b7TUnDcMro9RD4uE3hh5fipkxZL9Q9xnicULY755iw9DM5V5ErEDjXmuG5QLNI/m351fiM06LlHXhFdbusRUOjXV+uXziVM3r0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9PjMuTc/nqLhbRnPR3+KKoerol0F++z+vAtfTYUHNQ=;
 b=XWOLf2sH0lloCW7cOpdqPxB/uhoGYhVLquDbBCBGoltjDgbk1RVP7eHs+mdqGX8W1vrGeM6GKFkniiccEGe4K7bIjHctWX4Rl5N3KUGYd7FPApnMnGBO6d01sD+GciIFxZhDBupHUqlm/gdhoRSgiMHl/flqpTIOg0YpGselD5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PR12MB9600.namprd12.prod.outlook.com (2603:10b6:610:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 16:34:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Tue, 15 Jul 2025
 16:34:44 +0000
Message-ID: <96079fb9-756b-a419-335b-3a78331af4f8@amd.com>
Date: Tue, 15 Jul 2025 11:34:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 5/7] crypto: ccp - Add support to enable
 CipherTextHiding on SNP_INIT_EX
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752531191.git.ashish.kalra@amd.com>
 <15640300c8980b671b34b0b4290976d77c1629cf.1752531191.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <15640300c8980b671b34b0b4290976d77c1629cf.1752531191.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PR12MB9600:EE_
X-MS-Office365-Filtering-Correlation-Id: ca3ff7c8-c480-42a7-1781-08ddc3bd818e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk9nUFBMcXIrTHhTTmlMV2Ntd01YQ3ZtK2FzWWlkWThsU3JhdUZVRVlKUGQ3?=
 =?utf-8?B?SXRmckN3SkZGMXJvVDk5WWlTaVpCamhHdThtekhHT04rWVdTekk5eDZDN0Nj?=
 =?utf-8?B?Tk9Mc0cyTW5sMWxoOGptSFdvcDVzMkZZL0ZGL2ZVa0E1UGxZYmRRd0lhZ2Ez?=
 =?utf-8?B?WkJQOWpBUlBvOHIrbmJ4MnFDODMyNCsyWmRnZXRRYmEydDNTT28yNmhWM052?=
 =?utf-8?B?ak16eVVmckdKUEt4bktiVU1JajROcGo4K2twajRVKzR3MDVBTmsveUF5MXRr?=
 =?utf-8?B?UU9TdnBkUTc5OTRMM2hqN2YrUGUrWUc5MENxWXZmaUo1bjlobmkwL0Y0Z1g1?=
 =?utf-8?B?VkNibFNEY2FuVDgwWjZSdWNtQlZOamU2M0U3R0tlRTRjSlQwcy9oVzRJdkdS?=
 =?utf-8?B?dWlGV0hSNW9uM2Q3enJqQzhBKzVIOUNmQkREekgrK1Erc0lsZkphK2FtM1Rs?=
 =?utf-8?B?RWZkaW90VlJUN28wRkFOQTJLa2syREVsYlkxOE95WS91RlhBUjJlRzE0TWZ3?=
 =?utf-8?B?M3JEU1cxN1ZrTGlpMmlCK1hMUVJqWWYxUlZSTHlkd1plMVNoei9OdGpkaFFU?=
 =?utf-8?B?RS9iUzVoelNvdEhSWmlTUUFSeDg1aFg0ZzZaMGhtMkg3UDNraTZWcmFCaWVN?=
 =?utf-8?B?Yld5aGxvcmViT3RaZkhzRDY2cU1HZkVqTDZmTmYrMTRuQmlmc2FhWU8zT0VU?=
 =?utf-8?B?UXJSczRiMjNIMVJUaFN2VC9GeDJibGkvUmlFNG9ycGFtSEZWVHdYRlBvNWdw?=
 =?utf-8?B?bStldTE4U1dPajZIRGlsU3dGZGJ1WG4rWXBSakc1M050b0J5M3RMMDVuTmpj?=
 =?utf-8?B?MU54Z0VQMm1LcmFncVFZVk5UMGJkRkI5Q1MwSEFuYzFPWUxBWVVyR3MxR3cv?=
 =?utf-8?B?cjd5SjgyNUpXcWhUR0dXQ1FiTVVVWmJiL09Jdk1QMTEyYUVNNzVXYnVFZHNx?=
 =?utf-8?B?WmVFZGZWb01uLy9xQklyZHh3ZWU2TW9SdUFXRnRoTWtXSjkrWVlYVHUxTWI3?=
 =?utf-8?B?cnRpTzFVS3RGL2Q2ZjBsc0xTQitidXVscEJVWVRwRlNUNUs3aVRpcWFYdEdo?=
 =?utf-8?B?QU1uUmk3SGRXOERZQmgwclAyWXJkYVpBMjRIeEliV3NlRW1IQjJBbXdkZ1li?=
 =?utf-8?B?TU44bjR3YVBnWndnTWZKZkRKTkVCWWxNVGFsNXFMcWp3NnVxb084NFdqdXVW?=
 =?utf-8?B?WXlsOEhmZE05U2ptWlNUNG95U0U4M2R5ZUduOHFvc1hkam8yRi8zZWNtbzRT?=
 =?utf-8?B?eXpvUFJUNG1JQUl6YmRzeDdBZFpJaGNrdmZkdHlCdFl1NExBM3BaVXRLODNv?=
 =?utf-8?B?ZGkxbm9rOWxXa2pldStPeTBMbE05ajZYOHZRV1VoQS9OY3NweS83SnFHcStT?=
 =?utf-8?B?dzNBeFpmZkxOSG1tUFhYanpmdm5XOU1uaE5zYVpSSVhiL0FiOEw3YS9DWU9J?=
 =?utf-8?B?Wmo5bGRwc3U4MXFhOG5hZFJQUGRBYjdDdDlHR2VlOGtDenRmRWZmZFByWHph?=
 =?utf-8?B?d0s1Q0FtUmhMOENXT1VaMU1XTXpmODhxQ01aU3dEaDNIcFZ4ODZ3cjVsOGg1?=
 =?utf-8?B?cVd1SmY4dGNrV0VDWU9VNHB2MHJ0ZmV0TmYvVWcxdDR6dEM1QVRBNDhNb2Jo?=
 =?utf-8?B?dHpRQzJyWXJZRHFxYTNTYkUxUUowYkJTZ1E1Mlc4VjZmWnUwVW9XY0lYWjdy?=
 =?utf-8?B?VXVUU2dGNklvV24wY1NmcVBoUTdTRktTZDBUV2dPN1BvVUZWZjQ2T2pETmtx?=
 =?utf-8?B?YnA3ZlFaZmRHYTkxUk9oREJJd0o5VG9CaC9ST1NvVXdEUGJQeU1OV2s1UWxB?=
 =?utf-8?B?N0xXM05FcUFsN2sycU11SER6Z09OVWpOWW5zeVJ3RXQ1UGtCZ3J6eU5nNFJK?=
 =?utf-8?B?YkpLZldtSktqcEpDdTgxaU1QSHRyWU8rbFQyQWlWcFJhcjZsTGM1YXhOLzBi?=
 =?utf-8?B?T1ZnbmhRL3pSNVdkUXcyd0dTWGdlVkkyNWM0UWtCKytBc0ZoSXdMc3FuenFH?=
 =?utf-8?B?ZjlGSTNFVlJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnRGZ0lLcHNDSWxVR0dHU21OcEx3YnNkV05GR0RxT0p1VGg5NFhvUThpSFg5?=
 =?utf-8?B?Y3FqLzRNcnE3MmpzcWVvQWw3d3JNZkZ1NTRudTZYaG5HZkYydmE0RjljMDB1?=
 =?utf-8?B?Y2pzVXcyR21XbGl0akFKNkpkZHBFNldxZFBxTmllaXBqMHNSaTl2aWxYVXE1?=
 =?utf-8?B?aGIwcXV1ZkJNWURCOUN1OUx2VjFEbnpzblR0amR5cE5vUU9GYW9VRXkvUmxM?=
 =?utf-8?B?V1dJei9tdG5qYXRjUEdiak9GcXNSZzI0ZHFHcEppSTN5NE45akFaRFJXdjdk?=
 =?utf-8?B?c1grRkxEMDVOU2daeU1OZFRYRTdxa2dVZnpGbHdwNnhBOEptVklwaU9NUjNp?=
 =?utf-8?B?aXdvdnZ1VmhEd05rakpVdHVSVGxPdDNpaDZ3amV0WE04NnRMMTFOZGJDTTFj?=
 =?utf-8?B?TUNuaDEySzFBc0w3QXpwRmV0Tmh2T1Z4bGNlLzlDYVM3bVVrYUhWTmhrWHB4?=
 =?utf-8?B?S1NkaEZra0o3Y2hSM1dvVzVpclh3Q2dBOHZCdTJsK0w0VWpjK0YyN0FBSDd4?=
 =?utf-8?B?K0trYkF4S0hjd3dhSUwvZlArS1JSc0NMQmlEMnYxQVllM2k5bDh2RUVLdjRH?=
 =?utf-8?B?NHJNTW5rdWI3a1hEaXNHOUVBdmdJUE1pVDNmRnQzSVRTQWpGL1Fvazc0cHNu?=
 =?utf-8?B?ckE4MUVwSmxjRXFRWVZMRklWdGMrZjFZOUd1WHFndW44MnZ1L2lFTUF2S1M1?=
 =?utf-8?B?enFnRGJ4djlIcmlEeG11QlpkNWF4Q0ZvcHVnVE85dU1PVENuaUp5K09CRzBP?=
 =?utf-8?B?RFNNS3JlNlkwNkVsT0t5M1VPVCtybVpoZXpEVW82NGlwbjh4bjZwMTBjVkNo?=
 =?utf-8?B?Q3llNEs1R3AxUlllOVNMeW1FSkdPNWJoSmVqYVJYdHgzc0YzTDdqSjNkN0xC?=
 =?utf-8?B?N2dXTWhTdkI1ODNtRlJiS21pcTd4b3dndktCTElmV2M5QmdLK3NROHQ5aXNu?=
 =?utf-8?B?ck55SVRNRTljVE0rM3VZdkVqRUVPZm5HMzY2RnQyM2hidmNJLzh2Y3pHSGkx?=
 =?utf-8?B?ZnFjNDEwZkNLMUZzZk1SVTR5eFRab2xxWFVLRWxxNzBFQnJicVRMZ2hRT1Uz?=
 =?utf-8?B?Q0VUcHlZWnA2TExnZ0Z4eUNsODM0dGxjUTNNbS9YRWNpMTZFTWhJM2VpbjdL?=
 =?utf-8?B?QXYybXcveE1YNXQwbitHQnR0b3NnVXk5QlVJSkZ0YjlybWRuZmpQeVFOUWJQ?=
 =?utf-8?B?K25hU1RGV0hBUytJU083bng5aGxJQTV3dHBXTTZhNTIrRWtOakY2ZFJVejJ3?=
 =?utf-8?B?YWxSZGNaakFuTjMzaStkeGF1bGJxWGtTT2Y0TXc5eWh2NHkvbDRvYWtDczBF?=
 =?utf-8?B?S0ZJWWh5ZTgvdlE4WW1GOG9uNlVhaTRBVXMyRWNKMEdvK0Q5Q3pKZlM0Q21h?=
 =?utf-8?B?QVBTd2JFbnloREhDcUpxRkFRWXJnNC9LR0RQQ0lnSVJKS0x2YU8zVU5ydEF5?=
 =?utf-8?B?Mk1oUXF2K2dEN0ZDclo4Zlpnd2N0Z0Y2VFVWY01MSGREd3JwWmN4cklYS1l5?=
 =?utf-8?B?eGoyTEN3YzBNcHJSc1FNbVBQQVdRNWhtR1ZoNElYaWh6aWZITHQxaTNiOVUz?=
 =?utf-8?B?RjB4a1pQakZNQ3VEY25LVFRYREgzendnUDU4UzJUMGtkTHFZc3JZTWs2SHhI?=
 =?utf-8?B?NzVSai9JejJyWGlqQzRXdkRpMHQyNkVzQXBZcmZaMVE0VWU5WnM3bC9nTnFx?=
 =?utf-8?B?RlVVUitVRE1GdTlROU5BV0RYTEJ5b3hJVFpXd1BjMjZwRVlXNER4QzkveU9W?=
 =?utf-8?B?ZFZsR1lSbm9kZXIvSGxOaENWbXBJVElCN0V2dkNLdzdCRWhoVVNKMDlIcS8r?=
 =?utf-8?B?MEZCU0h4dkdMVjFmaTRqak02S2RnS01wbGQrd0pjT3R4eGpoTGRabVgxV0hT?=
 =?utf-8?B?RmwwbVRKdWQ3bStlYWV6bUJYN0IyVEFSWTNJUGl1a29yL2xyMUtvQWFTT2Ns?=
 =?utf-8?B?SGxpZFphbDdtTmsyeStDNFNQWVlEWkllZ1B0ZEZtVmwwTmpPQTlUUG9LVGpI?=
 =?utf-8?B?OStSSFhtMzdrc01tanVhUFJpVWROeFhxMlJsTkFwMyt3ZUptek9PS2JFai9K?=
 =?utf-8?B?MCtIL2RPR04xS0VDQ0dKNXNCVG5Qb1pCaWRMcDJZUmpHWFZEbkNKbUdzRldy?=
 =?utf-8?Q?50q5CSGBhINRgUKrT0hxMwycs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3ff7c8-c480-42a7-1781-08ddc3bd818e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 16:34:44.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzOYT/NYLkyiC1ONQmSBpmYzY5Y/lgFC/9Lfwwu4ExAg7NLEoNHdbrNy1St72YSMGQAD9Xt8fDwE+Hae0S8p1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9600

On 7/14/25 17:40, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> To enable ciphertext hiding, it must be specified in the SNP_INIT_EX
> command as part of SNP initialization.
> 
> Modify the sev_platform_init_args structure, which is used as input to
> sev_platform_init(), to include a field that, when non-zero,
> indicates that ciphertext hiding should be enabled and specifies the
> maximum ASID that can be used for an SEV-SNP guest.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 12 +++++++++---
>  include/linux/psp-sev.h      | 10 ++++++++--
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ed18cd113724..9709c140ab19 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1186,7 +1186,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> -static int __sev_snp_init_locked(int *error)
> +static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  {
>  	struct psp_device *psp = psp_master;
>  	struct sev_data_snp_init_ex data;
> @@ -1247,6 +1247,12 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		memset(&data, 0, sizeof(data));
> +
> +		if (max_snp_asid) {
> +			data.ciphertext_hiding_en = 1;
> +			data.max_snp_asid = max_snp_asid;
> +		}
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> @@ -1433,7 +1439,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->sev_plat_status.state == SEV_STATE_INIT)
>  		return 0;
>  
> -	rc = __sev_snp_init_locked(&args->error);
> +	rc = __sev_snp_init_locked(&args->error, args->max_snp_asid);
>  	if (rc && rc != -ENODEV)
>  		return rc;
>  
> @@ -1516,7 +1522,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>  {
>  	int error, rc;
>  
> -	rc = __sev_snp_init_locked(&error);
> +	rc = __sev_snp_init_locked(&error, 0);
>  	if (rc) {
>  		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  		return rc;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d83185b4268b..e0dbcb4b4fd9 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -748,10 +748,13 @@ struct sev_data_snp_guest_request {
>  struct sev_data_snp_init_ex {
>  	u32 init_rmp:1;
>  	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 rsvd:28;
>  	u32 rsvd1;
>  	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>  } __packed;
>  
>  /**
> @@ -800,10 +803,13 @@ struct sev_data_snp_shutdown_ex {
>   * @probe: True if this is being called as part of CCP module probe, which
>   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>   *  unless psp_init_on_probe module param is set
> + * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
> + *  maximum ASID that can be used for an SEV-SNP guest.
>   */
>  struct sev_platform_init_args {
>  	int error;
>  	bool probe;
> +	unsigned int max_snp_asid;
>  };
>  
>  /**

