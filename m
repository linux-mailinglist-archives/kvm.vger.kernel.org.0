Return-Path: <kvm+bounces-34760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 067D3A05885
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E145F7A220B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 10:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016A21F4293;
	Wed,  8 Jan 2025 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2qa5cOpa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69051F7554;
	Wed,  8 Jan 2025 10:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333126; cv=fail; b=P1q7xQyTqI3uU/6R0qbCmhWwawzEZp1fTF9tTvxdByEkYnWmeJJHhiwc4GvufxVAhAdhYgctcDVRx1HvNHovKbzQw5pPF+rL6Jn0HX2yGbnPpaKuRPwz0CK16+nAKW+C7XkkpTkNPEOOUgSKV7FWI0CiRz6yr7SuElMk62z7LrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333126; c=relaxed/simple;
	bh=RbfrDz59ZeJuRwp7jBkaz8HrSBQYhhvn86xdJKDYqBg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C8HD5DOpZHz8mp1MOiFxkJpUUS82XxJVgTL5pbPZd+9cpIF8nY8s2H1VC2uUH8dveEp2ljf66TIAzIKJTx4uq8dwMnoKxOi+cNEQTAn4LreBadjRvy00l2bKVualt2Y9B5wa555rBLN6EjER/O6uHFlX1/9MCz/JP5WaH/vO/r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2qa5cOpa; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7Cm1VmBoOUCCtECHJlA87O0aoZocK2b8SprV9eVaw9SHukpF6vrAdiYcSjTdqZcl+ATr3MJ/fcDzpkJwLUyRcEnfXk/aFZSnTEGpaOf3bVQ1A6+NeE/rJUYvo4KDK/RGZZxPbdN4ItQdWOI6Ky0Jeu51uNannz4RSJ4KpOX8c+2eS/2RvvM1fE0L293vHdehVgQtjtR1H3/yVxJhiRo3eGUTCbjVWGsvSwoRLtBw2cgcBgZ7qGbZEofXy/zLOCgLcEhYcK/lgvhDhQynlupLIWPBnHD5LoEdigGBJlHAPtOj6yLuxl6DloTtShZfx2Ml1nwp3PSngyH7LY2QSNu4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5d01+AV/pdGajFtK80h3pCDcC6e4wJH+P9isggkqtXE=;
 b=ZmheId84S+WowWwWD7kC9YTTW3s48WZ7F+Vo1eo/UfbLzpBsFhJEAdNU1GVewWawsKnfSqHiRwCYk3giLgYdhYCiYU4KHSuIEcVPFrGV32DNHcwcO84wXLG2MW2b+v5gG5ZnAbEpfHUh8o9mWQWSNBVbpsq4Lu1vok3E97Hs1A6NNNO0+afGeZa0uqSf1j+wScs401CIEmPCXmYH/gHIiMHjV0/PwVQtc3ezNKn6L142FiwSJsOt97OyAVb/r7DtKciKj0PJhrARp/5YYc0sxdtJoWfxlpCE9Dke9AfngORL+QLXOcNw0FAIOo424vq1RPgEo/Il0AHYV1qDNeCshA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5d01+AV/pdGajFtK80h3pCDcC6e4wJH+P9isggkqtXE=;
 b=2qa5cOpaBII+SMIOSepN8oHRKgoN9Z+RCmTgfmCbg2eVhjNx27k1fT7lxjjBwhtKu/pK3R0ORAYQ0QLlZTBZ7tbXhqfFtqV18tcIKeU3adDJBzJiwi8tPQ8YCuTMpO9PxkUa2n+xnDPE7/H1Ry+cz2YYwHOCz7CjdpiA8z3rw98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ2PR12MB9140.namprd12.prod.outlook.com (2603:10b6:a03:55f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Wed, 8 Jan
 2025 10:45:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 10:45:20 +0000
Message-ID: <7851bbe9-82f7-4487-8097-d373bba1a18e@amd.com>
Date: Wed, 8 Jan 2025 16:15:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 10/13] x86/tsc: Switch Secure TSC guests away from
 kvm-clock
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-11-nikunj@amd.com>
 <20250107151659.GFZ31Fa1iagsgsyQH3@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250107151659.GFZ31Fa1iagsgsyQH3@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0141.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::21) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ2PR12MB9140:EE_
X-MS-Office365-Filtering-Correlation-Id: 652ac13f-0d6d-4e4c-482a-08dd2fd18c29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkQzenpvWktETFNURVJWU3RjTElZRXEzNUZkNkdRNXh1YkIrT0lDT3Rlem1r?=
 =?utf-8?B?ZmlOY0hCcDZKT25oZFNQUHZZSlVxVGFzVk13OFRPa1NZOW42U2c3b2NoNkV2?=
 =?utf-8?B?MVMxT0g2NTYxYitaUjlwWEZpZzI3ZzlNTUUrbWR1b0toUURKbU1uOWxOaW90?=
 =?utf-8?B?SlN2NWFFMlBxMFVRb3pkWWh6K1hkUjZYeGNheHJ0YkhNSllSZFNVZHF1OURp?=
 =?utf-8?B?TFBLenV2WHB6eStGVkJLc0lQU25XVnVvVnpRdHUxRGtHcml2T09yZnhHbE9u?=
 =?utf-8?B?YkNiSkN4NmM1MEtkV0JnMEJxczNseTE0UjhEWk9LbEp6d05rMTlJMktNNldZ?=
 =?utf-8?B?WUszZml1SVpTWUszNnIzYXZ3cHZVMDVyUVFERmMxb0J4TmxJYmcwRzBzbnR3?=
 =?utf-8?B?THlsQ0xkZVhEb00rVDlLcWVIcHdsS2RGL21uTDVPSE9uWkQrUVA3SkpVL0RU?=
 =?utf-8?B?MFMwYk9sVURDZU9BVXNmZ2ltcEhEcU5ldzhkcWQ3NUhwaldrMmhGWmdyYjRw?=
 =?utf-8?B?NWtIM2Z6dGdPQ3RWd1R1ZnJWWXB6c3hSTk9DaklwRENrY25MMk96dDFmNTMy?=
 =?utf-8?B?NitvcEZjdFc5ZFJhT21KKzd3YVF3aU5Pd1U1ZyttRG1URnhJUlRPNHZhaWhJ?=
 =?utf-8?B?bVpQKzZTeVp0aEJCWXVsQVMxdFdadloyZEtsNFZNMVkvd2hxbW15Zit0T0FU?=
 =?utf-8?B?VGpvWjFFRUNuQVNBUTJQL3VtZXRZTDV6T3NPTzJqdDZaWEtQdlNRYWtJOWxN?=
 =?utf-8?B?cnVwTlVjTklGTmRRc3lmMWg2Ukh5N29Ed2tySUJRL2NRWGpxWXdWeDVzek1V?=
 =?utf-8?B?ajU1a1N1YzNUZkI3YzA4eTd2RHhZYllQWUJBV0hjUURSNTg5bk9UbWVodlNY?=
 =?utf-8?B?aDlpbWJvYk9LSmhweEIvdWNUdHRPS3RDUmJYb2syOW1kTUNSc1E0SUJLTFFX?=
 =?utf-8?B?Ni8wT3pqOXF3anZBUzRpdzRoTEhyR1hKZkxBZ2VCWnFYNy9KS2RXWDBVNTZU?=
 =?utf-8?B?cWVOQW1xejdqRk9kU1FLcUw3cXk0T29Nc1F3eHhoekg5QzZhWHFmcTBMRUt0?=
 =?utf-8?B?Nm9OM1RydW9Yb2ZvQ1hUQ1BhcVArNVE5dmVuL0hpYWxRQzVKVzlCSUhTNThL?=
 =?utf-8?B?UC9HK1FlQm5DWWl2cVhUUUNtcHM4a3JUUmpHTS9tWm92T2o4MmQxQXJMREVj?=
 =?utf-8?B?VEw4VU81MUJKY3F0ZloyREpreENBYVNsRERnKytsOXh3aTYzWm51dmVUUGhL?=
 =?utf-8?B?eFduMHJ0RFJ5SGhhSVduVXBXMjBXQ2ZDNVh3b2JzOXBRalBsWjloVHk3QTJa?=
 =?utf-8?B?TTdhTG05UElPQVk0Tjh0K1pEckY3Zkl3M2FUSnE1SFhHelBkN0ZQbm9ZUVdJ?=
 =?utf-8?B?TW03cW9vQUROaXo1UW9OdXg4dGZrWXVuc3poMnhuK3RDbW1JNThmeEducThN?=
 =?utf-8?B?dGpHdXROanJBdGJlL3Y5MnZjMGFuZnQ0Mm1NSHVxbG42QUVQZUp2eE9wMHEw?=
 =?utf-8?B?U0RTUkJ6ZjVXZzZ4NFgwb0ZYYnNBL25ESkVjT09HN0pEa3l0RG4yMFBhLzNP?=
 =?utf-8?B?bWwvQTV5bW5md1BTZENnbmdoUkN4S0dUeERPNnNscU1TUDdtL05IUm9qalRI?=
 =?utf-8?B?Q1FYbE5heDYzT1I5MEMzcGc3WnlZMVlkTUxaUnUrbkpraTY2b1d6TTUrbnBE?=
 =?utf-8?B?bWpqYlRJTnJxeXFZZEhaQlRhaTFFSXpMV2xXL0luWStLR0NUTEozMUtGUktj?=
 =?utf-8?B?dVd0clp0cFBMV2NuMnpqLzNmV0ZDQkh4Z1lCYkVyQmZDYkhySnF5ekhMWnpU?=
 =?utf-8?B?K2IzK2l0STZvRlYvNlRiYXlnWGtKS3R0V0wwZWkxRklCNWRWaEQrQ0QvUjE1?=
 =?utf-8?Q?2F6h+NUlWoRjH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3RMQzh1QVZjWUF0TCtBRzlKdGlJNTRUekRZS01MczhJcVZyQWlEOVE0d1pF?=
 =?utf-8?B?WVlreStXUXNnZUxFSG8rS2FTLzE3Wm4zR2lrUExBd2RIWnRKbU9hQm9QaHNj?=
 =?utf-8?B?OGNqZVJUVHdoYkdCSjVmS1A4M2ZVN0lkSDFXQzh0bjhJSXlleWxrWFh2UXdq?=
 =?utf-8?B?ZFIvVzQwNUR6bWg4UGcrL25ROXZoNjlKT3lYWWJnb2pSRGFKWjBDYjFmVW9F?=
 =?utf-8?B?M3IzVkJUMloySUVjcTBVTEh3ZitEWGJyVU9jUzVvYjZsaGtVK1EwWXYrTzF1?=
 =?utf-8?B?OFRUcjlZbjVpUzI0anNwWVVqWVYyYnkwQVM2UFJWUElPSXRZR0g1NFp0OWhP?=
 =?utf-8?B?RjBwTVhHcHpVTmV2TmlUcUpxbjlwYk83SUlPS2ptTVV1R0c0SjZMYXpqeUM3?=
 =?utf-8?B?TDRmSGlWY0Vsb0FZNEJKS1I0RmhKbXYwR3Rjcm1TSkVNRk5MbjBBdEo1bFlE?=
 =?utf-8?B?c0hDNDhsNWY4S2d4Y0ZMU0NCb1VWZGhYRnVQcHVyTXAzV3JaL1B1dHVXcHEw?=
 =?utf-8?B?dTFGd2c5Q3BCTWQrMnhVZkIwVW85Y2k5bHdUb1ZXWDdLZlByQWVqR0FBSnFN?=
 =?utf-8?B?UjZ4TDlxOWVFWGN6d0RSbXNJTHljcnM5dDB1S2NzM0hJS2tVV0I0cU9UQWUv?=
 =?utf-8?B?RjdTR0JIWWhqK0hwL1VYd0FjemFuRi9peWVTR1crYWw3bU1ZbXVBV01jMHQx?=
 =?utf-8?B?ZnBFdzVkMGk0S1h1dndhRUpZTXRFMkpIdHQ2d0o0NEUwNC84aDlIMkFMTnZj?=
 =?utf-8?B?bWhSQWpRc2RLcG5uV25GWnh4cmpacmF3ellYbVUzdldsVE5yL0dsa3ZiOVho?=
 =?utf-8?B?QjhqMlFEM2Zhb01tKzdUVys4QVdNb0V6cXNCdEFybWtWMHdkY3lZRHlneWty?=
 =?utf-8?B?bWtjeGdvRUs1RWUzWVhMOGdYNU43and5MVRZMVd0Zkw1SFlHRXVTMmxxM2Na?=
 =?utf-8?B?R0hXQkQzMWZ2T3RtK29ZTEExd1JzNWhQbzJGamxwRGZ3eElmaVdYOE1VcHVt?=
 =?utf-8?B?UGtPZE50WDlTZitPU1BKOVdWUTYrbDRLbkk5NklGaStjTmRtZjIrS2RMNEJ0?=
 =?utf-8?B?QTNWOW5YY0VEQjM5THRZc3ovOUM5UGZuRmNZUWZvKzhNcWxKays0TU5DS0g0?=
 =?utf-8?B?c2IwYjdObkdxWGhMUktHcnpJY3E4aTA2Q1lDcHFIaVgzVG5HQjFmbytxc2Na?=
 =?utf-8?B?YlNpQjJoU0hCblRBYUZ3dzBkQTMwRnI0U3JuK0tJclVlUGFUV1B3aFJ5OUpq?=
 =?utf-8?B?TW5LVlI2ZHB5QlVKZXN3eDRCS2pvc0lVcVlxNEZ1RGZMTUR5RkZPbmw2L2w1?=
 =?utf-8?B?NGt6Q2MyTCtUbXFvZFhXazA3S2hIN0lmdnQ0aC9qMzIzUEFMVW9UcHBua2E3?=
 =?utf-8?B?QmNNSlEzZTZQc0JuN1ZlUndyVVBxc3IyRkNneWpQTm9uRVltWmxrR1VOY2Zl?=
 =?utf-8?B?emFOWmpGR0tRTUNYVWVMRXFoa3UzaUowNjh0TkNqT2UyTlprTE04ejRxTkI4?=
 =?utf-8?B?R2JoaU9HZWpqYlN3bFU3UURmbVp0TndMWGpNZytoSmoxSWJBa00vNHNaRzBN?=
 =?utf-8?B?UnhVNEJQbHY3cWsvdTlwdHpqanBySXJ0dTE1OWVjLzhrdmxaRU44cFV4MU8r?=
 =?utf-8?B?NnlpWVI0QVdNYW1mT1gzL0YvYk9ER1ExeEpNQWhiNCtUd3laQ21vVTdFZDBm?=
 =?utf-8?B?SGhyYWJOU3RUYk84RkVTdWVMWDZyTkdSdFphbHI0NUdpREtiL2d2T2xIUkM3?=
 =?utf-8?B?d0hFZFZLaHZaR0NPaWtIeEZ3eHlLOTRtZlZnUmRYSXNKdG5jM0k5S3FJd3py?=
 =?utf-8?B?b20wMnc0NTZCZGpjOWZYTmxKMzBCL2xkSkxQbncxczk1b3IvTzNqK0t3VjNh?=
 =?utf-8?B?YW0wWERoQS9UODhxZUVBM2Q0d3ZoWTNOc0FHeDhpM0Fpd1MrRjFrd1BGZ2Ny?=
 =?utf-8?B?ZTE3QW00N3lKcnlzekt2MENuV2hYWE80UVRSc2NON3JaT2pHeExMUWVMWUkw?=
 =?utf-8?B?KzBReWkrSEtUQmVUdU9QNy9IVzN4clVNVWV3ak9tQVFFcjEyanBDdUZ1NnN1?=
 =?utf-8?B?bUgxS3JPMkFObkdHQ3Z3NVpOdHJSaC9BZFhtZGswb0R1cjNhNFVyWFkzVXFq?=
 =?utf-8?Q?+8Th/tn2fUvrcavAbmqgAR+kr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 652ac13f-0d6d-4e4c-482a-08dd2fd18c29
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 10:45:20.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP9XtWAZU900as4tIGJmS/MUDlcR+RlH/v1nAlqDxCokUUqCwwci/U2gqT+fEuTiCyf3/RVExw6e3lqaJtzn0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9140



On 1/7/2025 8:46 PM, Borislav Petkov wrote:
> On Mon, Jan 06, 2025 at 06:16:30PM +0530, Nikunj A Dadhania wrote:
>>  static int kvm_cs_enable(struct clocksource *cs)
>>  {
>> +	/*
>> +	 * TSC clocksource should be used for a guest with Secure TSC enabled,
>> +	 * taint the kernel and warn when the user changes the clocksource to
>> +	 * kvm-clock.
>> +	 */
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
>> +		add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
>> +		WARN_ONCE(1, "For Secure TSC guest, changing the clocksource is not allowed!\n");
> 
> So this thing is trying to state that changing the clocksource is not allowed
> but it still allows it. Why not simply do this:
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 960260a8d884..d8fef3a65a35 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -151,14 +151,10 @@ bool kvm_check_and_clear_guest_paused(void)
>  
>  static int kvm_cs_enable(struct clocksource *cs)
>  {
> -	/*
> -	 * TSC clocksource should be used for a guest with Secure TSC enabled,
> -	 * taint the kernel and warn when the user changes the clocksource to
> -	 * kvm-clock.
> -	 */
> +	/* Only the TSC should be used in a Secure TSC guest. */
>  	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> -		add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
> -		WARN_ONCE(1, "For Secure TSC guest, changing the clocksource is not allowed!\n");
> +		WARN_ONCE(1, "Secure TSC guest, changing the clocksource is not allowed!\n");
> +		return 1;
>  	}
>  
>  	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
> 
> ?

Works as expected:

$ echo 'kvm-clock' > /sys/devices/system/clocksource/clocksource0/current_clocksource
[   30.333603] ------------[ cut here ]------------
[   30.334802] Secure TSC guest, changing the clocksource is not allowed!
[   30.336460] WARNING: CPU: 0 PID: 19 at arch/x86/kernel/kvmclock.c:156 kvm_cs_enable+0x57/0x70

Regards
Nikunj

