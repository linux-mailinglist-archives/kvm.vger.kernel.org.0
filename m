Return-Path: <kvm+bounces-37246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58ABAA277B3
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7E953A740D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 16:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D90215F7E;
	Tue,  4 Feb 2025 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dh5HtZgC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7132428399;
	Tue,  4 Feb 2025 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738688348; cv=fail; b=j5L8n0FRW00PZOCpw+NxqhC34lGe3r/u2Apa+Xa4LdVrbY4uZ2xHA0n7Kik3DwJdQwF7cjxYkJN7dp9l4DUXnQuedN9Pwucc3ddw6eKSMBTgf/3nGBNhf/SyO5EBKU2RaMs62dtzKJwmUwvg/QC2bR3XinlMzdhVQXUJ16ubLDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738688348; c=relaxed/simple;
	bh=BW7udQPkEUERniIpsJZzcdSv/Np9+T5BT1LMVZdg2Cs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hOlH0b2yPHhztScKBKr5OZzTmAV1lB1kp3dOF7JorI+sEVDr1yzSIGsr3SCEFk9n6oFFBJKaVCY5KGIIMk+ea8yiqzNyqfnddz1a0TErbUqTA+DJRp4XO5n69RMY0uTygZNIhEHF1I+6QYxE8Qx2nNKYRhkCv4zb2bh4ZG0Z9tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dh5HtZgC; arc=fail smtp.client-ip=40.107.220.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yf+QVbPpwW4eVsMkkrIWiFfevHqUphg5ZC/M+DaPe2pWgFRSOZAbpOTvZH2Fy0v8AEDsFa5mhnk+3vgsruThwZ+AqVzMI0VCHJU1nx2KMFx9DuzIF7do9N9p1zEME8GTzpPkDRB3wnT9bEfZ6ep+QU18VnXSczJ/5KzHa4i/oPP4qNSgF97VH8mtJi1ckiFmeaMyKU0v/BCNF9fJnn+lhO1ePVoatWxHhLXbBMmP7ZrGUhuNSphBNxlmepQon3fekcto7l3mH9j6526zDGPqBajC+EujxiE/Xj1/+we/fJPu876WLqkV8l795zOSCxn4NylUSkHgxvUiyA6YH97hZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjSHdEdzn1/UrJLFuz2pYUXF65KlsQZT/T2k1e9cHJg=;
 b=CaUxxSA791vU0Sbs7HTjdFyK7llt6IW1wqll3A3jTUUhjKZ7WxqCxbGJ4DXjHcJyrqw3XBaSa1UTRTD0g8lgQdM0+c/0G4ZL5935TEPW6JlgXNEtSYsAHlK7CIJpYDyx/eOkX9k2M5Eqe+aT3jLsWX7k6xTirFoIRiW4NJo1knraQh2EEZoimRstT2q9y/IDWe99Weq7Xarp8sPvIclAtcSnzI1G6HrakBwS4u9m6H8GDasyefjvIldV+m2gjuEz6NrukAQYJTlfoYdjWtznn+701AG+qTfN/r59dFEUGGLGlVAUNR96Szp3tZ78goGvHtDdeaKYQJMgUiMkkSTo7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjSHdEdzn1/UrJLFuz2pYUXF65KlsQZT/T2k1e9cHJg=;
 b=dh5HtZgCBwNHb7PYcfzVipqHGJvSnhl6Zm9G7MDg5wRLIh64Sw/gs3QX4jzDLvm1iv0GEPvVYLE1PhtaiwEavxyRXTdCgl6XHeKRREy4emWpL5EC2bwT2XvCMfNuSHpvXBBg9pzXFXLIUqQ7igboHqdkmfHGdGaweO9KnfXRKKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 16:59:04 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 16:59:04 +0000
Message-ID: <27f10680-e0df-7da3-8ef3-22e1b9476728@amd.com>
Date: Tue, 4 Feb 2025 10:59:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 1/2] x86, lib: Add WBNOINVD helper functions
Content-Language: en-US
To: Kevin Loughlin <kevinloughlin@google.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
 kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com,
 kvm@vger.kernel.org, pgonda@google.com, sidtelang@google.com,
 mizhang@google.com, rientjes@google.com, manalinandan@google.com,
 szy0127@sjtu.edu.cn
References: <20250123002422.1632517-1-kevinloughlin@google.com>
 <20250201000259.3289143-1-kevinloughlin@google.com>
 <20250201000259.3289143-2-kevinloughlin@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250201000259.3289143-2-kevinloughlin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:806:a7::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: 432ef97d-2e36-48b1-e304-08dd453d3ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGpkZWdRMUJMS2grajg5bElOMjh2SmcyTnNJNEZBNzdoc3dLYVFWNmRCQ0tN?=
 =?utf-8?B?aGc2OWJlNU4vczNHbTRETXVtUDZ4NTVtMFhCMmhNNlV3cG45S2QrSWZqNnZp?=
 =?utf-8?B?dlozWFFpRDNGRFBlMGFwQVRPK3NJQmxSOWhYeTFjbE50YVhndUF0RkFHSlQv?=
 =?utf-8?B?TTVFcnN3bmpVUGJQMTNHUC9kbUhuWkZJMzU5V1JOY3RFYnY2ZnpkelJheUZr?=
 =?utf-8?B?d09BeG9pRFJaVGVxSVhnaXZCS0NVVkN1ZktOOVRXcGt6ckhaZVJVM0cxOGdn?=
 =?utf-8?B?czdwOVpOT3NCV3lra1JsaU1HRlFFU01tVlBHV3A3R0tOQWdTZlBiUnNlT3pS?=
 =?utf-8?B?cDVhNlhucnJXWjVNQkx3L1UrYkljbTk1aW9uc3V3MTc5eDBHdDYvMHV4Mk4y?=
 =?utf-8?B?TFNhZm1jYVpWVGI0bFBOZzZhU1FLcXhkZm1hMEpMbENWTm9POXY0UUpqSVA2?=
 =?utf-8?B?dTBpVVQ3SEtLK2I4T0R6ckdxRy8xSi9QdEVYL1VRNUx5Qjk4MFprVERRTE1U?=
 =?utf-8?B?NWhqeVd3ektTS1krbERnSTZ5VE5xZ2dyNjVCT2wxYVE5OUNoSjBEQ3VVRnNu?=
 =?utf-8?B?MTljRmx4Rk5heVpUaFBMeThrb3o3a2dJS1pYLzR2SStMNU94c1QzRFRvaXRz?=
 =?utf-8?B?bjlBaVh3NStZaVJvWWg1UE1paC9MVHk5TzFud1F2WkE2YlBkcVlDSGVGRnE4?=
 =?utf-8?B?THdTbnEwck1SSnRybkhISThTRTFHTmhTTzhIMkhyeEM5SFpIT3VvZEFiL1FP?=
 =?utf-8?B?WVFVZVhhK29WNnFKV29TTGJZRGxrWTZvL01kZ21IOW1Cc2xkUUVReVJScmk5?=
 =?utf-8?B?K2szOXZ3dE5wRERMTzBLanBLemltUmpRZ0EranBmSG05WWxPR2RTejR2SUY4?=
 =?utf-8?B?QlZLbzBJUEhSTXp5K2NOdmxtZDcyb3NMVXo4UW10SS82RDluWi9Eblg1U2RN?=
 =?utf-8?B?di9ENjFoSXdZQ1R1ZWdlTXQwMVFSSWtISXpNN0hZR0Zkak9lT08zTlVCSm9E?=
 =?utf-8?B?S0Z4TkNubGdxd2lab2wxSjNPTDdrTjJ5WmJZNzRpem9VNUtiaUJkaU55dW52?=
 =?utf-8?B?ZnZlRlo2LzFwZllSQ1dvVWp2ekNJZTdZY09ueEY3eGFrdDdNcVpIN0lXSDJk?=
 =?utf-8?B?RGFJdFRmbVNFVWg5NWF0T29IWDRMNElhQWlFd2djQnQ3amZIUzBuNUlwVG5q?=
 =?utf-8?B?MFpxRng3aGNiQTBua3VqWGt5NG91aU5nblJXTW9pTlZqTG9KNGk4UE1QQmFP?=
 =?utf-8?B?RVdremUwN3AwVFVWMllJdkFGWXArYTByK1pyQ0hOZVM4NHNQRjAwdjNLdE4v?=
 =?utf-8?B?S0k0RndkMUpXMDN4M2NLRU56QXR2UTNlYjBqNVRJaUY0TXlWRU1HRVpJaFp1?=
 =?utf-8?B?cmVGSTZxSWltQ0NpRzFxeE5EQWtpdUcvSUZvSjR6NkVZMUNiSUtMUWNzZC9J?=
 =?utf-8?B?dkxRWW1CRlpzYmRESDRvNUdOYWI3VXFUMWlUYTJiYzRtRU9oRDYwZ0tTaGhH?=
 =?utf-8?B?cXlyYld6V2M4a1E0WThkZUJCMjhpbmJoREo2bW15MkJlSGV6WGlaeWUrV091?=
 =?utf-8?B?SGUvR2g3TXRQcGhJbkRkVFJVenBkSXhCeWRlcmFIUUNtQnc1clVVaWZJT2Nx?=
 =?utf-8?B?N25Sd3BnYTJXVjFoQlZWTmc5WmJEd3M1Y0ZCM1FQUkY5U0NSOW9FMGFUM1JF?=
 =?utf-8?B?U1EwNVZGUUxrQ04xV3lPdm5LYkFIV3hmTFVaOWlzMmdSODFMcnJncitNK09u?=
 =?utf-8?B?OENYaUdOejljenJIWWM4RGpFdlc1eVEvTXRZZEc3RU9kVGd1ZDZyVjI4SEpZ?=
 =?utf-8?B?MThhOGw1NiszRjM0K1VYc0puVkpCdlpEL3VVeWRMU1Fhd09JczhzTnZlTUVx?=
 =?utf-8?Q?PmTlfAZiNByT/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkN5ZHNweGVXNXZnemxPOXgrMmdadkRyZGxnYXVWZUl2RkFKWjJrODdELy94?=
 =?utf-8?B?YVBkTVg3MXdPeDQ1b3FjN0wyRGtSY3ZPT1hrY0RNRDZWU09VanVBOHlRTHo2?=
 =?utf-8?B?dm9yU3MvK0hYSXZrM21lM01zenFJRWkxSkc1VU04SXBFbXpxR2kybkFlbElo?=
 =?utf-8?B?SEFWVndjT2hYbEtaMDFuVTIrbm1nUmdBRkc1c2xjZGFuL2x2WjRFVEVCZE4x?=
 =?utf-8?B?SzRrbmtraVhscnYxNGJidUtVbGE3MkIyczBPcmZXemU5em1ycEl4eitUT2ZB?=
 =?utf-8?B?amo2YVBXMWl3bnZLMWpyU3Z4MVNWTEVQcTRpYUc0Mm53Zk5JTXlKS3VmaUlW?=
 =?utf-8?B?d1A2RHo0V3lQU1hLNFhyZjN1M2RGSTRESUVITWVwc3RmWHR0cGhLTXdNLzFq?=
 =?utf-8?B?bXVZRnNhOHVXcUo4STdxMHFSUFVXbHliRXZ1cGZlVDhoZWZlaHB4V3lSWnJJ?=
 =?utf-8?B?M2JzYnVqbDkyRDVhK1lxNWo3eGlQaDJDekNZc08yZG93aUFsaW9jYnFkTEda?=
 =?utf-8?B?eWFpMWZJcml2NVo5enFCeCtJbU1mbVZYWCtnUjhGaVFwUUFDYldvc2Y3VGl1?=
 =?utf-8?B?eFNZRGRKcUFHUnA0VGRqTFN5cTlRWUx1SkJjVVVPM1pIOFdTdi9Eem5oRmRP?=
 =?utf-8?B?Y241a3Z0aDdmbGhxU3U2NThpYVlYZFpGdnhnZUFBNVhLZjlZK0luNFNwSi9C?=
 =?utf-8?B?OG9yL1FKU3MzakwrWHBXSG9aRGxZaFErNTVhK084OWlydWxKN3hEbm10bkpJ?=
 =?utf-8?B?SGNGWlVIc29mTmNWS3pycjhmUU5SZCsyVEJac2dsWDMyR0ZROEJ4RGJzZWtT?=
 =?utf-8?B?c0tJSnBxUVVKTVhVOHpFRGM0K1R5alhjMy9NT2JYcjlsUGsvMmxPS0JEeDNM?=
 =?utf-8?B?UHpXZnN1T2h2UkpUNkZGTkxaMzlTdHUyUllEVDdpVXJ4cjEwNzg4QURxbzNV?=
 =?utf-8?B?MFhLYkNsK0VVTWE5Ykcyb0xqdnJkRUVXV3RRY0t6U2RrRUMycVNEeUJ6YjYv?=
 =?utf-8?B?U2plQjZaSnd0MTZDK2wzMVZSdkplSW9rUUJVWTh5dEpONHlHVUtyWTk4QkNQ?=
 =?utf-8?B?YUx4OXZyd0FaVDNYZzZpQWhIMWlsQUV5NFpuNG5kZiszSno1UDFSckYwc1JR?=
 =?utf-8?B?ekhGN0Jmd0xadDIvUkNmcE41WXprTFF3MnVqZWhIL3B5Sll0dnFCZkVwQlJI?=
 =?utf-8?B?OWNXQ2oremU1K1puS3hZZEdNcUdrdHZuR0E3a3NkVndERVVVaHo4SjcwZTVl?=
 =?utf-8?B?MW9ZSVRPcGFMd240WHp3Y0crUElNRUtVcnpwQlJhOTJoQjR1N1dvNFlJcGNE?=
 =?utf-8?B?b1dRdHcwYXRHZGpqN0xaWEVVRE5rMEFRUm95N2JVd1FDYklGOVJNbDdncEpN?=
 =?utf-8?B?cjR5c1UwL2k0T29ES1RFbHJZVkd6Y21jSzVxYVIxVnpYNVNsWGtXamxOYVJ2?=
 =?utf-8?B?azB6bWhlSDdsYysxSDlLeHIvdXpFcTRpMGdKZ1Y3THVTbHFPTTNkR2Iwa2ov?=
 =?utf-8?B?cW94ZFVoNmVFMTNmZ3NzaXlXTk5KSFEzRzd0MzFVODdqRTR5bjI3b1NFZi9u?=
 =?utf-8?B?Z2E0VWdlQm43bHpWN2VXdG1QV0VLMFRkWmcrTkhNd3FGbjNranpjeTIwRVQ4?=
 =?utf-8?B?RWp1NzJWZ0cwcFNIL1d6MTZ6S2FoWm0xUDBqRDdDNkRwd0R5a1Y4MWU1VTNK?=
 =?utf-8?B?ZGVZK2xDZ0o1M3lldlcveUg3c0VOZE4rYVg1VjRWZFBDZXVzTXhyTDZKMzR6?=
 =?utf-8?B?N25OYTM5TGxwaUkyWFlJY0NtclNzWXBnQUxSVmZLUTN5UUtZMThTS3N4TEEy?=
 =?utf-8?B?aThneGx1WElkaFU4N0grcGtIWHM0TlFYTnJMVUtKQWdOMFNqeXRTZmpXVGYz?=
 =?utf-8?B?WFI5SUdLV3NsOElkYWVNMkpNQ3lXUTNEUW42MU8zeGZMdURDaUhuQ2krTTl4?=
 =?utf-8?B?NnhRRWhndUh6dFhCQnVLU2xEYzBiQnIwQ24rSU9sT3o4S0pDdWJldUtwYlZw?=
 =?utf-8?B?R2RIYnZWdnhmbWtURlV5YXAyRXR2ZWpvWVFoUDZ0dFVHU28rbUkwSm5heFQ4?=
 =?utf-8?B?MnFvaUpob2xBUHdwRkhYTGNjb0JWcE02K2RNUXZTNGhsWHhPbDBSS1BkbHM2?=
 =?utf-8?Q?y052NvIbt58Dgqi/KYBlc9See?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432ef97d-2e36-48b1-e304-08dd453d3ace
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 16:59:04.0486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/FrNoyAz0Y9aZieWkKHOnaJD1Cxuv+CTFqeFxTRaigE7bSg33akqse3hvt/iUHe8oR5nAoHs5h/+yBjzfex7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

On 1/31/25 18:02, Kevin Loughlin wrote:
> In line with WBINVD usage, add WBONINVD helper functions. For the
> wbnoinvd() helper, fall back to WBINVD if via alternative() if
> X86_FEATURE_WBNOINVD is not present. alternative() ensures
> compatibility with early boot code if needed.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/smp.h           |  7 +++++++
>  arch/x86/include/asm/special_insns.h | 19 ++++++++++++++++++-
>  arch/x86/lib/cache-smp.c             | 12 ++++++++++++
>  3 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index ca073f40698f..ecf93a243b83 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -112,6 +112,7 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  int wbinvd_on_all_cpus(void);
> +int wbnoinvd_on_all_cpus(void);
>  
>  void smp_kick_mwait_play_dead(void);
>  
> @@ -160,6 +161,12 @@ static inline int wbinvd_on_all_cpus(void)
>  	return 0;
>  }
>  
> +static inline int wbnoinvd_on_all_cpus(void)
> +{
> +	wbnoinvd();
> +	return 0;
> +}
> +
>  static inline struct cpumask *cpu_llc_shared_mask(int cpu)
>  {
>  	return (struct cpumask *)cpumask_of(0);
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index 03e7c2d49559..86a903742139 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -117,7 +117,24 @@ static inline void wrpkru(u32 pkru)
>  
>  static __always_inline void wbinvd(void)
>  {
> -	asm volatile("wbinvd": : :"memory");
> +	asm volatile("wbinvd" : : : "memory");
> +}
> +
> +/* Instruction encoding provided for binutils backwards compatibility. */
> +#define WBNOINVD ".byte 0xf3,0x0f,0x09"
> +
> +/*
> + * Cheaper version of wbinvd(). Call when caches
> + * need to be written back but not invalidated.
> + */
> +static __always_inline void wbnoinvd(void)
> +{
> +	/*
> +	 * If WBNOINVD is unavailable, fall back to the compatible but
> +	 * more destructive WBINVD (which still writes the caches back
> +	 * but also invalidates them).
> +	 */
> +	alternative("wbinvd", WBNOINVD, X86_FEATURE_WBNOINVD);
>  }
>  
>  static inline unsigned long __read_cr4(void)
> diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> index 7af743bd3b13..7ac5cca53031 100644
> --- a/arch/x86/lib/cache-smp.c
> +++ b/arch/x86/lib/cache-smp.c
> @@ -20,3 +20,15 @@ int wbinvd_on_all_cpus(void)
>  	return 0;
>  }
>  EXPORT_SYMBOL(wbinvd_on_all_cpus);
> +
> +static void __wbnoinvd(void *dummy)
> +{
> +	wbnoinvd();
> +}
> +
> +int wbnoinvd_on_all_cpus(void)
> +{
> +	on_each_cpu(__wbnoinvd, NULL, 1);
> +	return 0;
> +}
> +EXPORT_SYMBOL(wbnoinvd_on_all_cpus);

