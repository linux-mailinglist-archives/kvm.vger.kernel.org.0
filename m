Return-Path: <kvm+bounces-23472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47532949F3F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 660981C229A8
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 05:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0CF194129;
	Wed,  7 Aug 2024 05:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2QhpYFHM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2057.outbound.protection.outlook.com [40.107.212.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BFC250EC;
	Wed,  7 Aug 2024 05:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009312; cv=fail; b=UXP38p6yfgORg1LvHWWr+bn7pvYxgznHrfte2TeVyVN+AEyD3wf+d/YhMripJC8sHNTeYchyd/q8O2NwXXMwmpH+edV8n2gBdAGFhGVacSYAu54jghtbriFZMSSgdH0cKQMyXW6Ew6wRF6ETpHnG5T4p/CvwQAPhD6e0hpKtbUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009312; c=relaxed/simple;
	bh=0IWNbR6ujrDVZcbjmbR5ybpYdn9g6E5pizmueSO2Ndk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SHHm1mqB3wa2nOEKSILApqowo4WV/VqxXHPBeLTDmx+Li7Sy1wUpo6QUfSEV6cpCcXHs/BLmmhmL4Cbkv9a91KoJZMTqeL8JHxxXDcsKPkke9WdWdB2/CjAJUvw+kxuHIPQLlzp96XHTocgAfu0ii+WqbOkSgOUwWIvPVmh9z4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2QhpYFHM; arc=fail smtp.client-ip=40.107.212.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ye98NVfNXd4StkQI2CfvyTqUVw/whFelM0WEp1y9ROeQB+9HJ/tt/WBYL/zqpSSiJ9s7qTuLOONU8ZwUOc2fEI4Yu/9+2y8s956P1AK7hFBimnQlU9FC6QqF//+C96Um96BfPhLFZzRqL2t3fhRl8zLvpLEM1i0PiaSvfalpQoIEeTjTZmbNe591co3gX/IkTx9CruZ96WpQfWkXUJA3RNaXyIgC4zqah6NVYNxllWQ6LosTuO2rE95ehwQbmPbz2oz4Pk4HSLKYxCVsOOOIs/BXjaLib3v7lJIRnJAz36FnBXcgt+bYA3yQfXGZj+qZJw61tCSQ8okHCY1RdJ07HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/1OYP1oLqb2fxWWPC5Zqzy2Xj7oRqAxPQYBslRCbTw=;
 b=suPVtzy4M20WfPdEMnfZcrPT+KoHDbaFTnXXm8o/ecy7yClObUkxSEphCAQHQ+mqFHznqBfv4JCtV9mv+vMeDxZfhGrIPJkRi3dv4sD8v6pskDlx7CrM9IidvUv0P03QGNDtQvnJAH7WZz5XBb7HQ4jEvs5vxTUm/cHS1tJbnR0wGghP8AWw4QbLuSr3wWRzN+s1R8u+IbI5A6mnExCVDBzNyoOINPmU7o5ho1QJXQmHB2lVL9+pc0LNcAjSgFVB3tl1jJWdUEeu9tFv7F2fK7CY1nioqpi5sKBvNI5iiVllG6AXEfaxhVeoBZ04UPEkOlpotLjL51dLggkPMyd+yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/1OYP1oLqb2fxWWPC5Zqzy2Xj7oRqAxPQYBslRCbTw=;
 b=2QhpYFHMpltN5VwlPFXRlc5eXZFeOldzCNhTwX1aKdYlh+DWZiPgsfc2Qfyy4h19VrrwKI4f1pHJ8gjh+t9rGGw1jlBqbYCiUb2VFWlRgaVtZCO9UuqFHPJTo/fcf/VVlv/cO+//5Fc27gDiTulUROymbO6sfx7MViQRoDwp6aA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by IA1PR12MB6113.namprd12.prod.outlook.com (2603:10b6:208:3eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Wed, 7 Aug
 2024 05:41:45 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 05:41:45 +0000
Message-ID: <efcee12c-3ae9-4f40-8739-ac706a9fa33a@amd.com>
Date: Wed, 7 Aug 2024 11:11:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] KVM: SVM: Add Bus Lock Detect support
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
 <20240806125442.1603-5-ravi.bangoria@amd.com>
 <8890482d-22b6-2ffa-9902-cb970ed20013@amd.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <8890482d-22b6-2ffa-9902-cb970ed20013@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0128.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::13) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|IA1PR12MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4e3e9d-4fe7-4ef6-e277-08dcb6a39f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzZybUdiTjExaER3RHpJTVlFRktaTHBJcnhhZ000TFl0UlVBampMRmVRUlc0?=
 =?utf-8?B?ZVVjSW5Xb0lPZUxLczZkMmpvOFl5SGFURDdNay9mTVBodWRid1hCLzMxVG1u?=
 =?utf-8?B?RTBsRDZSbGxOeW52ZkxocnNYZzJqYXYrekwxeWswQXM2VXVldVlMcm9NNTdX?=
 =?utf-8?B?K29EdEFZWGxrUDhKb0JHa3JlZ1BYWlBodmY5UE5iNkJuRU9ENVI5QnNFWGZj?=
 =?utf-8?B?c1FTR2xwdnlhQnFMdDU0WDltaFJqQ0kxc2M0Q0NHcUNMMW52dHV0YlB0K1dy?=
 =?utf-8?B?ckdpV2RKRzV6akRPV0hEei9ITjgxS0w1bXRteDUvL25rRHBMaUJWZFFDQUZU?=
 =?utf-8?B?ck5xZW5LaUFjZmlUL3dOSzB1VHFPcDdwSFN3dGtaNTNIcGpkZDlHU2NQWUZp?=
 =?utf-8?B?TWpsZEJ3NHp3MDVFZE9ONUVzbUJGMXZUTzhCQkJ1TDlJYWVsL2hsam5SQXNK?=
 =?utf-8?B?UHhWSWVjMGtPeDNyMHY2VEZ4MERwRVoxWUdCUmFNR1EwbnluQ2pEZmd1OTdt?=
 =?utf-8?B?VG80YXczRmRWdHBGV0lkUzN4OTBTd2Zad0xxa0sxNkRXM3ZUcVFTZHpNWGtL?=
 =?utf-8?B?ZnZLNytGcmtkYVFmcFhGRUJLeEdXRFZTTXpPeG1GNnpMVTZYYzVsbVFoMjNF?=
 =?utf-8?B?VklVT0tVT1NWbVRnYVFmdHE0SXhQbG9vUkxiTkM0TkR5ZFJVamZVR0o5Y3lO?=
 =?utf-8?B?YUN5WWhzRldnVnQwVEhQZUtyOENQUkZmZjlibTE2LzcxSW9QMk4rYkVmMDc5?=
 =?utf-8?B?dm5Sekg3Y0VQRmdkSVBCTmg5dWZxdXB3WEFsWG1UQVlJaTh5dUxWT2xzek8r?=
 =?utf-8?B?V1RwZzBvMUNOd2NyTnNvZDRtZnltTUJtSURtaTFxbDBFOW81OUVrejRnVFda?=
 =?utf-8?B?M2MyTUlTN3ZWYXhBSTV3bzJYcS9kM3lZOGs2c0wzZEU4ME5TaEJCYU1jeTUx?=
 =?utf-8?B?Ukw1dG9GLzJROElXM3BNRnFEQU56NWZvWFpJZDB4eFFtMkRpRmdGaG5jYUxw?=
 =?utf-8?B?VFhXUDJPUlU4bUdnaEUvTWp1UHl3WUsrR2JTZk9aMGp1WDRKZUFCMU5vMmMr?=
 =?utf-8?B?anAyLzEwd0J6ZDdCSVNwTnJ3MWc2ak1kcUI0bHlpRThTV2xybXV1dlJReGgx?=
 =?utf-8?B?dDVUVStFRnVSVUw0MkxVcnMzQzFtcEVHZ25YVk5FN2E0ZmNqa0NrSFh2VEg1?=
 =?utf-8?B?NFNtdFB6WGdIS3dOZ3JBYzByYVdBVFRjeWJkVldNWWQ1eU1EUDA2NStmYVpv?=
 =?utf-8?B?cjBrQzdVQmdvZVU0Ty9nL3Q3aE1wdkRXMWsxTXZRTlNaRGlaYkY1WmhsUkxP?=
 =?utf-8?B?YUxGUjdvSFkvRzMyQWRDSTVta1JqV3UyT2ZCN05yNFRPSEJoTmJQRlBWVVVB?=
 =?utf-8?B?aERIM3NHbklBY1FZWVBteFU5WFBUaG5VdHRtMEFYSE01OFc5WUtuSFVZNTV2?=
 =?utf-8?B?a3l2SmFzK0dZTi8zUTdSSE56cXNqSnowTkRJLzhZdkovNmJQbUZ5ZkhSbGJi?=
 =?utf-8?B?cXUwWUZUUDhqYVh4ZUFIOFhXaER4YWJHUTZLSi9zL09Yc051KzY3bHJLQnZl?=
 =?utf-8?B?dzRHcHdtSHdtM2RYQVRTTEE4N2VIa1EvWVNiYnczem92SUlTUHhlalR2MDdo?=
 =?utf-8?B?bzVsd2p2TUg1VnNVcFo3bVA3RzUrVXJWU3FnRmxDR2tKeUdJWG0xV2Y5dGsr?=
 =?utf-8?B?VzJ1RTlNUE5NWjcvL0RlNnoxWlFsWnB1V1dIS0w0djE5NGxiUEZTQTcwZmVU?=
 =?utf-8?Q?cXBBEHy9D4kcuK4Kbk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHE1aXJwdDAyTWlzbTEvcGpPSTFiemxORTJMcVl4cXNoR3VWZlV4Y2VLcDVs?=
 =?utf-8?B?M2dNbmhaai9kb3hBSGgrTFM4Y081Wktzd0ZzdU9KSThRTm1aNkJXS0tVVTN5?=
 =?utf-8?B?UERZWE5iMUVYRDlsVXpGTWtFbXREZ0ZySEZkTnJRYjl4c1U4aU1saTAxZFF2?=
 =?utf-8?B?ck43cjE5STZNQkxhQkIxbFZZMjZZSVJtZzl4ejBGWlM3Z1NKTm5Gc1hVNHhv?=
 =?utf-8?B?SWRiSjRFK1JneXlVVDdGT1VIdU9meCtweUM4UjV2RnRNUVgvWlRFSGQ1TGVN?=
 =?utf-8?B?TmNvYnlKZG5PMTZsdmZoZ0tXcjNvUXVxYU1UdXRoVnZ5UjBLcXFneUMxcVZO?=
 =?utf-8?B?dzVZUUtiMXZGREx1dVZIWE8rcWs3Q3BzZTRzRzdHai96U1kyc1IrVE5rVU5y?=
 =?utf-8?B?R0s3cGhsWThkRFlTN21VaGxxVU01Ulpac2pnSmYxRlJUVVJFMkJEMjIvb1Zm?=
 =?utf-8?B?TUpTeW1laHNCNmpobmpXbW9EOVg3dkZPVUQ1WitaTC96b3hNRStKcHZuL1ZJ?=
 =?utf-8?B?SG44bTYxMVBBQjF3QmUzclN5c0VuUzdXblBGK1hBSFRmdW5VSHBvdkw3OWVY?=
 =?utf-8?B?UnpxcFdQK0t4RCs4a1FIL1lQZ2pzWlRQNkhWdVBldEdLZEVqcmV0aHBGd0ZE?=
 =?utf-8?B?TFE0MkJ3L2lQQVM1NzhoZnljTGkxWVdyL1FFcXpMRmw0MGVkcHUwelh4cld3?=
 =?utf-8?B?VnkweVNna1RnR0VONTUrVkVUNjFRL3NERUE2bEtMWWtUenBNbkpBSmdHQ3Bs?=
 =?utf-8?B?VFljNnUvNHIvczlrYXZhNVdneTdOQUgzcG1FRVNlc3V6YzJ3OHl5N0psYTlv?=
 =?utf-8?B?eVQwRVFURHBKQkJLNldmdHFKdTVOcFI1WkpMSHVPc0pZNGN3YXNnazdMdWZO?=
 =?utf-8?B?Mmh5WW9RcmFodWVJQ0xONGtxUmxzZytYSU9nVmIrNUhJY2xJNWI1ZTc0WGRU?=
 =?utf-8?B?OXhDaFRDOUo5cUhUWEowV3JYWXB4eW5CM2szSjF5Y3dIZXZPNWtRRExzelpk?=
 =?utf-8?B?Wmd1TWlQbnR5aHhCNjFjKzhIUkM1NnA3d1h0bmRyZzdXV3Z1UkFKK2kwQSsx?=
 =?utf-8?B?eXRYd1ZncCtkUVcxZEc1bjE1YXRpdDRwY3dvZk5va1JNVDY4TThZcFlCTzlz?=
 =?utf-8?B?aWMyeHdONjU2WXhZZ2FtWjQyVFBWWkNlQkNNa0s5VVVvcE9DMUJBajdTN25P?=
 =?utf-8?B?Q3Z1aXcyWjJ5NVB3Sy95MXdrdUdDTDU1MEQ2TldrV2JsNkVsNlNKR0VEWkFU?=
 =?utf-8?B?dXN3YWl3TFlrb2h5QURqVXc4eFR4MFNNTzk4LzRyUHNKVlBjdThyTHFlVDZE?=
 =?utf-8?B?VWVLdUtQbWsycm1wbHdFaWJUM0NOKzBVSFpGOVAwT2VYbWJLWkVKT2tYUWxO?=
 =?utf-8?B?ZTVWVktjRUlHR3h1aGI1MTU4b25jaUdTVWozS0JQb1JGZFlWQkp0bDFlc2tM?=
 =?utf-8?B?Z1ZiOVpVZkdtV01MNVpzY3NtL2tsdEI5aHQrQmNycHBxUVZQTGZyekVMZXla?=
 =?utf-8?B?SkoyS3RsZERZUWpXb29jVHRha0NZVElKTGg2bmRFVndsTERmeGd1bnoxd2hi?=
 =?utf-8?B?bFlvS09TUkdmVFQydHk2V3hBKzFNTlBYcExBRmVpRFAxcHR2ZHJOWDZyWFJX?=
 =?utf-8?B?RmZaeVZWQlBMZEppYmJJM3BPd2l6WG0vQ0ltaVdRMlQyWkxZeTl6L2JQa0Nu?=
 =?utf-8?B?Q0h2WGhFUytNTU9ZTWM5ZXBwMUpJMFJWaTNFZ3E5Tmc5cGdFeS84WUM2RDZ6?=
 =?utf-8?B?am5HWmhaZDl0MDV4cS9QWVpmdVpmNUNPYUFqZWc2aGxybW51SkNzdWhRQ3JU?=
 =?utf-8?B?RE54RkcrQkNVTE0zOGhYZUtUdCtjOTdrbGg5MHFHNi9BeTNxWHYxRDhkYjVG?=
 =?utf-8?B?Z1RTbVRpNHpCbnpnQ3BZckZrM0NmbHZVakZvWndDVHdNYXZyK0ZoM0h0OTNp?=
 =?utf-8?B?M1RjanZ1U0tQZUVpSWxYYlR6MzM3QkZKK0ZvQ285Si82OTNZc09yZTRmQWV2?=
 =?utf-8?B?RlpTS284Y1FUMDhMVWh2TEdTVkJTVE4wcEErRmNyaG9lTWpINE5VU3hFVmVq?=
 =?utf-8?B?T25rTFl4MmRoYlV2NklmUWdacHlyNVpRTk54V1pEM2REMDlaMmVRbU5Mbkw2?=
 =?utf-8?Q?GPoDSJHcTekh1QyzXIMSxMvH/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4e3e9d-4fe7-4ef6-e277-08dcb6a39f77
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 05:41:45.4732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkjA2BXcavM4xtP1Y2hMCL2l6PTfxxLEhsaoNOEXVGNXipJ3//GQhjwW+23YRHyrjZnmJFSeZbVwzAVOqhshIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6113

>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 6f704c1037e5..97caf940815b 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>>  	/* These bits will be set properly on the first execution when new_vmc12 is true */
>>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>>  		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
>> -		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
>> +		/* DR6_RTM is not supported on AMD as of now. */
>> +		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
> 
> This took me having to look at the APM, so maybe expand on this comment
> for now to indicate that DR6_RTM is a reserved bit on AMD and as such
> much be set to 1.

Sure.

> Does this qualify as a fix?

I don't think so. Above change fixes Bus Lock Detect support for nested
SVM guests. But without this (whole) patch, Bus Lock Detect isn't even
supported in the virt environment.

>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 85631112c872..68ef5bff7fc7 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
>> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
>> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
>> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
> 
> This statement is getting pretty complicated! I'm not sure if there's a
> better way that is more readable. Maybe start with a value and update it
> using separate statements? Not critical, though.

That would be more or less a revert of:
  https://git.kernel.org/torvalds/c/41dfb5f13ed91

So, I'm thinking to keep it as is.

Thanks for the review,
Ravi

