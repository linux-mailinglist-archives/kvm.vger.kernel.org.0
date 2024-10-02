Return-Path: <kvm+bounces-27827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC9998E573
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD72F1C22E30
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 21:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FD81991BD;
	Wed,  2 Oct 2024 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ga1csFFD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE992F22;
	Wed,  2 Oct 2024 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727905617; cv=fail; b=CpoC1ZJiqC+DXBPkDm+oruNx0VCYTRFTwIEbTTcaDbEfERtcm55zBp7A68GVAWXGZ16ySGDLXw0hC63ovvHwxZyXspS2S8N0u7WbGjiDjegzP5c7SNkE8kerlAQpf7awkpye+nVFe9QvCsLBIzBFf/VWoBeyuYGDSLUo1zOb/R8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727905617; c=relaxed/simple;
	bh=XkrudcxiE7OaUaqPfBttS+ruwz4MOezh5JrsQT/EBqk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=doJ4l7CJ8ZwFL/Mx7neAaAchClZWy7Vn+rS77VbPKWoIRFCfjQX5BwlOR90Nx7LhnI67sgaxG6jKySTPR7AE/4LGKlrrarEHninGXwGJnr37RA5s8RaJDUE+ym+iaNUPu35cM5mKHVlTeLT5yUCy1nlh8ye6q2hubGbCT9r2ODs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ga1csFFD; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sAyU2wUN/Z8ED0CeHtak3AfOpXHlGsRNluu1Nv7WpZJI7DckaBqP8taXrmiUa5g5lMktnixN+HaGTGjuvrxp0RrHrocCsRRdKoeaj3WWxuW3C6zyUZMFeoyajaf0fs8J2YwywutjRSMGiekPjJOf9kVPiYjBqosgS5yvFTvHEpCsXaVFAKS9zf0FZA7E/CLZuocRH3ujbR5N9pgDIWsLes0VsNSVOUacC21Uk+a5UUIpqtI88nFwFBp7HfT9+VdI772dmtnJJ3DC6nIPo01DcEQM47u2NGEGXCyMxoFi3zvii5WIyZige1yLD6Ll/Sm8VNbrPX+883Y9mFyzTwUkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INunZPrygJ6PXeLmodkGh53PzW2ouVBRrkEmI9DNPM0=;
 b=F6dEKqMApUXKqpWDH/kDsmLKnnZjfqnKHaSKjqNUofASnHQmnnigfUH8tWbiePZzOiudomfbHL2Yqs74J42IxBHh+OkLzWIZ1Eqp+Ply/p3bP0CCBDib4KfEbdyy1PIYn83/JxEIgWLliS+0VZmR7PypTTvOuMVRQFT2dHx12f1knuNxytDOE3ucjihe0wkv35yN9PGHqY5AIBgYXI33sEiU9AzgSk/6pUvXuqtPX8eQeppUGCAEBJ6w8MidTYKQnH1GI5Lzovg4rQj8a/uHg4Ku5YVZDQVeVezd8v+wDYPWgwnEMvBnMNoxhpf2D4n0ChqszjQSJP0j58BkRAUITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INunZPrygJ6PXeLmodkGh53PzW2ouVBRrkEmI9DNPM0=;
 b=Ga1csFFDQkmMrda5MNdVmxqqj7cAqez8V/SoahfEMnY2+7uR5NhZ0xbYUoTt3WPZR+3QfoME2lI3d4BWT4X/Yai4m3NKhgW32oNkubtfepsjLQtx1uWjo4E5peMn9F0n5XJu/4obkSi9ILjY8ze/hs2sbF4aNdxUuEDxc4NcHs0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB9114.namprd12.prod.outlook.com (2603:10b6:a03:567::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 21:46:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 21:46:50 +0000
Message-ID: <3ca1bbf6-930f-068a-96f2-8b33240496fb@amd.com>
Date: Wed, 2 Oct 2024 16:46:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
In-Reply-To: <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB9114:EE_
X-MS-Office365-Filtering-Correlation-Id: ac84847a-2843-4e53-d10b-08dce32bb8d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVRCK3BGc1F1cWd3UmRFb2I3OXhIZVVhSksxbnJtSFhqaHB4ZFpJR01Zd3BQ?=
 =?utf-8?B?ck1GS0NCK0R4NXRxMWpIZmVxaGJlMXVHQkRWWUxSWUZDYXBQY0ZpQVJMOTZ3?=
 =?utf-8?B?T2JrcmdDR1lFQ0ZCeXZYNGcvTmVROVZIZjhWMW1JSlRqYldLbGtRSVRYZjZr?=
 =?utf-8?B?QS93N3hTaFk2RlU3b3pLWUlPK1ZnQjhpdUl4WitkWWxreExSdUlqY1oyMWlp?=
 =?utf-8?B?U1BsUzlFcFgvWXlvVVNkS2lpQk9ZVzEzMWJJSjNVVW5RbHdSVk80VHNpOG5G?=
 =?utf-8?B?eSs1TVE3dWdkSXVLai95NG5PZ2VqOGlnR3FwaDU4dDcwRzJhNXRSbXduVTNT?=
 =?utf-8?B?aW80YndqbU1oc2pBT3ZWTnpldTUyYW5CVnlEVXZVTWZEM2JUbWlES2FvQWZu?=
 =?utf-8?B?NFlqTkdCOWFzZWg1ZVUvNGZrNFpxbGllb0k4dFU0NXRncDdubTJOMTFDWTIy?=
 =?utf-8?B?VXBwVkwyNXZhbVRUZGppNnY3YTBxMFhvVEZQZXZhLzkzOGpoMmdFVnlxMzhR?=
 =?utf-8?B?bGpwZGZ5cDNFNmFoM3Mvdld3UVFqU21QVXNmM0xYTUFjN05DdDNqY2Q5QUI0?=
 =?utf-8?B?NjVOK3EyWElRM3VrdGRWMnNHRlpGZkxIR1ZyUm1KNFlBT0tFaDFaWEhYTGVG?=
 =?utf-8?B?NWVGUzZOZXlHSjNZUnUySi8xaGhiSzhUUFF3WlhTNitTakVsbnluN1dvZGpo?=
 =?utf-8?B?Um9PRVY3OG10T2IzU3JTVVFKd1lSNVJuK0V6elJxZ2ZjRnZGeEtkTEJxdFVV?=
 =?utf-8?B?bG1SemhOeTR5ODFtUWJOL0tUQ3o0K0pyYTFZTmdrY0tzaDRpU0V1K1h2ekJW?=
 =?utf-8?B?cDV2azJGQ3VFd3RCZXRkYmZ5WmJlNzY0aGhPRnYrRFlZTG1qZkoxZ2dlMmRF?=
 =?utf-8?B?SlBSamZFR2FUUWRKOE5HWDVCVU9MdXZwWTMxbUhXelZNcWNQMEJNOHRqVTR6?=
 =?utf-8?B?RDB0OVNpNWdEQnJHNTVlUFhmdDZHUC9LcUU3YTdzdFJjTmhGMjVzbXBpdWZU?=
 =?utf-8?B?TXdqblpOZzBzeExRSkNFYm9ULzU2aWh4b0RPUHg0TmFYd09MVFpUTWJzYkRH?=
 =?utf-8?B?aEFVMTg0d3RwZm5Vd3lTQ0c1TDFPOS9OQ3lSNkpoS05JUm13ZHVhNXJqays3?=
 =?utf-8?B?RXh3VlFaNGh0Qll6RUJmOGVvL2ROZzNudE1keWZ2c1MzMGhVT2lPSGt1b1BL?=
 =?utf-8?B?ck9LaEl6TEg1TnY2cm1JZHh5SDhZUW5JSm44T3pGZjhpRDM1YXVJUWRTc1Rk?=
 =?utf-8?B?cmc0RVJZeWxxZFNyVnozV3A3SXFQSTgwVGdpUG1pNFRvTDNWQmp2Z0dhOXlQ?=
 =?utf-8?B?Wm9tR09XVFUzc0VESjhFVEdEa25Tc0ZIenZualpxZFc1LzdJazZnMVVwVXJ2?=
 =?utf-8?B?dG1jODdBUlM4Z3hURmw0V2M3MWFGK1B5SDdsNUJDcmJVbkZWdEVXNHFOaUtY?=
 =?utf-8?B?KzNFSXRrRUU2QjRXbHRUYVUyQ0NzVE5vMDlMdmR2dDloL2hieHdKN2ZQSFdz?=
 =?utf-8?B?OHNXOEo3NjN5QUp3b0lUTjFvQVFDcEZkVElOSng0RmdnNjZiVVhoT3RXRXAy?=
 =?utf-8?B?ZXh6Mk1wMEJ3SU85SG1lQVVrWFplQjA0SFNUN05JTHJHVXhDU0YwdEliWXNy?=
 =?utf-8?B?WUJYL0ZZRytwbUN4d0FzMTNwWHF3RGE1d3hLb3QrNklYbjhCL3FrWUloRDRw?=
 =?utf-8?B?dEVrZlNvVUxMSUJKY2hCWEl1cUxiU0Z5NUtXcHl2V2ROZUw4ZFFrYmFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dG5yYkxObndiM3N2cGE5Tm5wdzVYMnlZRDBMN3A5WVYzZWdDcTBZOHFDb0l4?=
 =?utf-8?B?dzNBOEhkUGJqbXQ1TkxoNEpyMW9ZVDhmSFhWU0hLbXpBSWlRdSt6YmMzVGVH?=
 =?utf-8?B?T3VMNmJqMVVKOTJ1YTVmZzZIay9CT0svSjFOOGgrU3ZlVGg4ZEt3U0JiVm02?=
 =?utf-8?B?VkZ4Q1BCQ2c3NkRMMmFBTHdqZE1HL21kQ1lJR1R4eENHVFY5cWhvYStxa3ZO?=
 =?utf-8?B?N3RGY0hYWXppWE1xdVpySnhOOVg0VUlsL0gvOGo5M2lDUUdkMmlNNFlJN0Fx?=
 =?utf-8?B?aGRDVzk0elJBL1loVGhiemNIdHhYczdBc2dIWDZGRDFnbVFLYW9wYS93L1J3?=
 =?utf-8?B?SWlNRmlxZmdmMUh1TFRrajBXbFRxcUJDT1QxUGFJUnNtZC90cU9nUldLQ2dw?=
 =?utf-8?B?cHV6eTZxZmlTb1ZyMFdlQXhyWGhzTHBuZDIrbTNJQnB3YURTcUxPWTFaQ0RP?=
 =?utf-8?B?ejJRY1lzZUZURnIvRnRPTStnckVxanRya0k3NnBXK1pLRVgveUhNNngvZERF?=
 =?utf-8?B?cGErWlBzR0ZNUkJZOE5mUEJDM3M4ZjROVyszTkFKV2pyekhCeDI3TnBSNjVQ?=
 =?utf-8?B?OHQ4UDVMa0ZSdVNiVFduME1PV2Q4Z3liQzNmYjFGdlB0bWtScmlZb254MGlq?=
 =?utf-8?B?ZG1lbmNpOFpJYjQ3bTA0YUVBZzk3SEpoQkRDRENMekpUZ1F4c2k0WDl1dDNI?=
 =?utf-8?B?dldXRnp2MCtpWVd5clpUSExodlZRNjBPak5heFFsVFNYWHo0bjA2TVVhS3hw?=
 =?utf-8?B?OWZ4RmliZ3J6RG4yTUt0Q1NlSVRmb3lkbE5zdHZjQnFkbDF5ZW9FeHNnRWFJ?=
 =?utf-8?B?Y2V0TS9RUEVhblFXTXUyVEVXTFc1c080ampvT1FJQUNzVm9PcW5DVGY2UjZS?=
 =?utf-8?B?cUJuTHpzWkwrUWk4bFEybk9EYk55elhKR2MyRy81WU5PdFV1RnB5Y2RWdzdi?=
 =?utf-8?B?TTZvYTNiME95bC8vRGlRWjFOYk5GTExxTTV4RTB2emFQcXo0YWtaK3RaaWpX?=
 =?utf-8?B?eS84ZzR3SVNpUUZCTFRhNUt5WjA1MUluWm4zUzI2S2Z0NXhJdkFnT3ppejlI?=
 =?utf-8?B?aWM4MlgvcEtzTE0zbkVWZjBDQXQ2TndCQmlFbHpHNk51eXlGOG9LQ3ArT29j?=
 =?utf-8?B?TzNkNUhOVnAwcVY0MndOc3c0OSsvVmxSMEhybC9zbW53OEJ4elJKZWNWZUhs?=
 =?utf-8?B?YkVtakVBUzM1SCsrZytGS0VTQTJPeWoycWx6eFlBQURSV3hRQ3Ewa21RWVRa?=
 =?utf-8?B?cEwzL2d3L1Z4ck5VTDdlWkpWZTdUbE1Eck1tcjhCR0lxdWNaQURJeEc1S20z?=
 =?utf-8?B?WWphZ1FjNG9MdVlnQzZQUWpGdWxCWXNjbC8xWElUbW5kMDUzSWFQa1JvZWRq?=
 =?utf-8?B?a3o4K2VYSU16T2FjS2V6OEczZWk4aS8xakp1KzM5WDJTWW1LMDdBZ1pkTlVr?=
 =?utf-8?B?SmxRZ3VuaG52RjExUFZ3L3JhYitXMk9oSnRVWmgwOThzSEFROXNDcHh4Y0Rs?=
 =?utf-8?B?T0dFdmZyNXpOS3ZQei9iMHZhN1RGL1UwT0NLRHBrdU1BWjNjZHZmSzE3REYy?=
 =?utf-8?B?UVNaTVl5dmErcnFoZjNhMjZhTkh6cGs1ejAzdEZqZTYvYmxWUW5VZjhwUnNl?=
 =?utf-8?B?OXEzN1Z3LzZFV1VoSi9DTkswVGxnQ1JKN2w5Y3VDZ1R1VG1IZU9RNzZseXJQ?=
 =?utf-8?B?aDNBa0NrN0FyNDdHNFdVT0pwQkN2cGpKS1JVY01nZEwwZkZHaXE4c0puWC9x?=
 =?utf-8?B?VUpyUVUyMlNyTlVFNEVENU00VDk5UWdubk44QnB5QnpBVTdYd1A4SjVkVGc2?=
 =?utf-8?B?RWFlVzBUMmN5amh1b0VFYmMzUk5nQ3FzUFZZYWpBR0pEeUV5akNqOE12Zkpn?=
 =?utf-8?B?a0x0bFg2VHFUaXZNd2ZWL3hYaW83dkRaWnhINXJQT2RQMTFmTFZXM0pibTlw?=
 =?utf-8?B?VGJROUcxc1lkY0dSYXFFQ0I5TVVUWW1tNnFBaUlZbmg5Y1pmaUo5TGhQSFoz?=
 =?utf-8?B?bXRNV3U5dUVhYjlOWVdkVnoxdm5MMkRGUlpsVzA3Z0ovc1NOM3dyUFJTejBz?=
 =?utf-8?B?YzZUdlNEMW9hVXN4UHhReGg0cTRQYXBwbER2akxnN0NhUkxFUFVNQ3ZMSkRw?=
 =?utf-8?Q?gtAoWh3Y9ySQdkiAC2viLtdHy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac84847a-2843-4e53-d10b-08dce32bb8d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 21:46:50.5585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIoFgPHpXfsG1wil1LQ5qBQ4PkXBucse/9PQDFlF02gTFOjWCBSJTof7zADxMyBMJvBHPXScft04Q/+fnaBdkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9114

On 9/17/24 15:16, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
> ASIDs. All SNP active guests must have an ASID less than or equal to
> MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
> (SEV and SEV-ES) must be greater than MAX_SNP_ASID.
> 
> This patch-set adds a new module parameter to the CCP driver defined as
> max_snp_asid which is a user configurable MAX_SNP_ASID to define the
> system-wide maximum SNP ASID value. If this value is not set, then the
> ASID space is equally divided between SEV-SNP and SEV-ES guests.
> 
> Ciphertext hiding needs to be enabled on SNP_INIT_EX and therefore this
> new module parameter has to added to the CCP driver.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c       | 26 ++++++++++++++----
>  drivers/crypto/ccp/sev-dev.c | 52 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 12 +++++++--
>  3 files changed, 83 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0b851ef937f2..a345b4111ad6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -171,7 +171,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>  	misc_cg_uncharge(type, sev->misc_cg, 1);
>  }
>  
> -static int sev_asid_new(struct kvm_sev_info *sev)
> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  {
>  	/*
>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> @@ -199,6 +199,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  
>  	mutex_lock(&sev_bitmap_lock);
>  
> +	/*
> +	 * When CipherTextHiding is enabled, all SNP guests must have an
> +	 * ASID less than or equal to MAX_SNP_ASID provided on the
> +	 * SNP_INIT_EX command and all the SEV-ES guests must have
> +	 * an ASID greater than MAX_SNP_ASID.
> +	 */
> +	if (snp_cipher_text_hiding && sev->es_active) {
> +		if (vm_type == KVM_X86_SNP_VM)
> +			max_asid = snp_max_snp_asid;
> +		else
> +			min_asid = snp_max_snp_asid + 1;
> +	}

Add a blank line here.

>  again:
>  	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>  	if (asid > max_asid) {
> @@ -440,7 +452,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (vm_type == KVM_X86_SNP_VM)
>  		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>  
> -	ret = sev_asid_new(sev);
> +	ret = sev_asid_new(sev, vm_type);
>  	if (ret)
>  		goto e_no_asid;
>  
> @@ -3059,14 +3071,18 @@ void __init sev_hardware_setup(void)
>  								       "unusable" :
>  								       "disabled",
>  			min_sev_asid, max_sev_asid);
> -	if (boot_cpu_has(X86_FEATURE_SEV_ES))
> +	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
> +		if (snp_max_snp_asid >= (min_sev_asid - 1))
> +			sev_es_supported = false;
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>  			sev_es_supported ? "enabled" : "disabled",
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
> +							      0, min_sev_asid - 1);

I think this might be easier to read if you align everything based on
the conditions, e.g.:

		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
			sev_es_supported ? "enabled" : "disabled",
			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1
							    : 1
					 : 0,
			min_sev_asid - 1);

> +	}
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>  			sev_snp_supported ? "enabled" : "disabled",
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : min_sev_asid - 1);
>  
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 564daf748293..77900abb1b46 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>  
> +static bool cipher_text_hiding = true;
> +module_param(cipher_text_hiding, bool, 0444);
> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");

I agree with Peter that this should be false by default to maintain
backward compatibility.

> +
> +static int max_snp_asid;
> +module_param(max_snp_asid, int, 0444);
> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");

MODULE_PARM_DESC(max_snp_asid, "  the maximum SNP ASID available when Cipher Text Hiding is enabled");

> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>  
> +/* Cipher Text Hiding Enabled */
> +bool snp_cipher_text_hiding;
> +EXPORT_SYMBOL(snp_cipher_text_hiding);
> +
> +/* MAX_SNP_ASID */
> +unsigned int snp_max_snp_asid;
> +EXPORT_SYMBOL(snp_max_snp_asid);
> +
>  static bool psp_dead;
>  static int psp_timeout;
>  
> @@ -1064,6 +1080,38 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex *data, int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	unsigned int edx;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Check if CipherTextHiding feature is supported and enabled
> +	 * in the Platform/BIOS.
> +	 */
> +	if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +	    sev->snp_plat_status.ciphertext_hiding_cap) {

Remove the indentation here by just doing:

	if (!(sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED))
		return;

	if (!sev->snp_plat_status.ciphertext_hiding_cap)
		return;

> +		/* Retrieve SEV CPUID information */

Remove this comment and ...

> +		edx = cpuid_edx(0x8000001f);
> +		/* Do sanity checks on user-defined MAX_SNP_ASID */

... move this comment above the cpuid_edx() call.

> +		if (max_snp_asid >= edx) {
> +			dev_info(sev->dev, "max_snp_asid module parameter is not valid, limiting to %d\n",
> +				 edx - 1);
> +			max_snp_asid = edx - 1;
> +		}
> +		snp_max_snp_asid = max_snp_asid ? : (edx - 1) / 2;
> +
> +		snp_cipher_text_hiding = 1;

s/1/true/

> +		data->ciphertext_hiding_en = 1;
> +		data->max_snp_asid = snp_max_snp_asid;
> +
> +		dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature support enabled\n");

"SEV-SNP cipher text hiding enabled"

Thanks,
Tom

> +	}
> +}
> +
>  static void snp_get_platform_data(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1199,6 +1247,10 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		memset(&data, 0, sizeof(data));
> +
> +		if (cipher_text_hiding)
> +			sev_snp_enable_ciphertext_hiding(&data, error);
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 6068a89839e1..2102248bd436 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -27,6 +27,9 @@ enum sev_state {
>  	SEV_STATE_MAX
>  };
>  
> +extern bool snp_cipher_text_hiding;
> +extern unsigned int snp_max_snp_asid;
> +
>  /**
>   * SEV platform and guest management commands
>   */
> @@ -746,10 +749,13 @@ struct sev_data_snp_guest_request {
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
> @@ -841,6 +847,8 @@ struct snp_feature_info {
>  	u32 edx;
>  } __packed;
>  
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

