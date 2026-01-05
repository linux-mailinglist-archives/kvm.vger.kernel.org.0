Return-Path: <kvm+bounces-67064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE2DCF5055
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 18:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A31F730210DB
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 17:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853703246E4;
	Mon,  5 Jan 2026 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3oOydmGm"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012003.outbound.protection.outlook.com [40.107.209.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5827930BB86;
	Mon,  5 Jan 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767634733; cv=fail; b=f93d3KAonol8z/uThNoFvnxy7bVtfmCzv4Z+5gR7DrcZGMweQ1UUF23HfpihO3Bm7MNs/yAMgfoEQ3KZdXHyA5AweCvKNpYxxY8akzZ6LI+HbxZT7CXu5xysSHR6hvDc4lxgRbkBfdBNCIwgKoKedcL8YF8cyEfQmTvEs63+hOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767634733; c=relaxed/simple;
	bh=XO4BKYRBalxvPDvSiVDG9NZdrggncpskNKf6g4X4WLQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NKtHY55kqYFVxifMxnI21VLSFvbXZ3bLMeBIGUji/n4oVl8rdX2Lirw8BW2Ix4S64qxjHqdF72Tyeu/hBKgVozIW45INloIAeYwAw/jmO8pnCN+gRqWkkq3HCTyEj4MJlMFj06e1JhvdTHEEXB/SnAXq3bnhlqnvyLfG/46OXQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3oOydmGm; arc=fail smtp.client-ip=40.107.209.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m24gcWdLY+lKMbe+8NrHI4dPDi829mtIaVQp2cVaD1YgQqguSzFGQmLTSJIEkh3JTQIoRJ+7TwPUqtIP5pASnnr1bBkzw+5rXjOomu/oGW4kErkcbZkargURgVjTfrfWWRUBkduinJk+KMD4XMyq5tmjJJF110Qq71K4IrO1vpt71ZiG0DUF2MPc/6xEFtKLGZ0L+UtF/NhUAFi9YQddYf6n6RVA8URL87cHELmuR9b3+EM0xtdof7g2DDgWVKM/TkeIiFUf9zaqdtae+vcuVFpd8AI9rz+BwjeOzHnM4xfWuaBLglBD2cYBU7r8u1tcMyb5JTCAdhVHCpkY1oxMWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IgG31QW5wZq4GmTDi5R7DXWA9Yb6AHMNyHzcg8/B+0=;
 b=abFPK6/378enQe3kx5WWHtkFHLQV00vlJZwcBM/sBSCfl3OeQtPE0NyzkZ/eV9FV7pa/eu5Dzmv+vGejvUAdf8jyt3olAs/wOe8tQUDm1VtR5IsRWhQIvGnH3n+L+/1DNb6X/PwwHQUdgwT52NAab39PonoFc3io2zsQG3m1np8KQYjNBapuHPNpc27I7KdLgsLuZJYcy5ElMkus/KOIeVWIPoYjc+QfaoSL9JBri1zNrTwCiAvNm8ss7E5dx+NnHehKbjSKZT0tGQuSOM7qARV5yvMmQcY1bYbXqG1lVKole62jQKYcxUm94y9GOkyo250BO22Y+LU6nMazpP7grg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IgG31QW5wZq4GmTDi5R7DXWA9Yb6AHMNyHzcg8/B+0=;
 b=3oOydmGm2aHkfxk+7WpS74RK3djvKOVty+M5ANrtsUQ+hEL8loUPGcMAK0IICzlt3XV2skP5NkkTZBfIsa0nsCdTGxc42NqsD9rbs1nhBLjUJD8FbY315FOdvlgX+jGW1zta7KmgTqelNsrIS5VDz1EbbgcFpQF/QbrDCT0n5lI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH1PPF6D0742E7B.namprd12.prod.outlook.com (2603:10b6:61f:fc00::613) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 17:38:45 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bfd5:ffcf:f153:636a]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bfd5:ffcf:f153:636a%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 17:38:42 +0000
Message-ID: <86de1961-8d1c-465a-b822-0dd7cb094d46@amd.com>
Date: Mon, 5 Jan 2026 09:38:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pds: Fix memory leak in pds_vfio_dirty_enable()
To: Zilin Guan <zilin@seu.edu.cn>, jgg@ziepe.ca
Cc: yishaih@nvidia.com, skolothumtho@nvidia.com, kevin.tian@intel.com,
 brett.creeley@amd.com, alex@shazbot.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20251225143150.1117366-1-zilin@seu.edu.cn>
Content-Language: en-US
From: "Creeley, Brett" <bcreeley@amd.com>
In-Reply-To: <20251225143150.1117366-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:510:339::33) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH1PPF6D0742E7B:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d8ad79-01a2-4c22-58d6-08de4c8144c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmNGU2Irdk15Nm5QM082aEdmRTJ2bnJIU3ROMTk2T3hlU2JYQ2JtbnBTNmxt?=
 =?utf-8?B?dFI2ejVPVVdqdTVnSnZtWFU1K2JoUkp6WDBYUFd4dDJWNU1rRFhlY1orbGRh?=
 =?utf-8?B?Y2NqWkJYQ09FZjE5QTRKdFJGOEhMTFVBL1d0SVhiYnNiWWIyV2puTEM4R2Zw?=
 =?utf-8?B?TnUyRHFLSXM2YTZYNTZQUVBNcjh3ODV2ZDhtTEd2dUhWcWUzS3JCdTE0aXhJ?=
 =?utf-8?B?MXlJVHFwUU02djV4M09EamtDVE9sTW05RDVWTi9OWll0c2oxVWd1MFNUdmhR?=
 =?utf-8?B?Z0VRNkRWM2kxN0FvVS96N0QrM1lUNy9ibGhTNkFnMndXbGY2Q2R3a21ReUdz?=
 =?utf-8?B?S3RVWGFGcG50dzRodDRPZjF0ZWpNWUQ5bXNtRzY0MmR0eldHQ25VUUFpWmVl?=
 =?utf-8?B?N1djMHRkd1lDOGFpcGNJNWR1L0twUTErUUUrTFFQRlNuVTQva1E1WjBxdFNS?=
 =?utf-8?B?cFZLMThtSXVsME9HcUZ0c0E2aHdMQkQvWmVLbEN1ay9HT0lUMEdVd3gzcXZt?=
 =?utf-8?B?ZkM1QlZLNXc1eHN6cCtpcEZtM0hHcjlRVnBKS2htOUtUaGx1eUlPdGNEVlRh?=
 =?utf-8?B?M0tmLzlmSG0yNHptZjNvcDFWUW1kS2NyUC9Fb0EzckJhdVJHUTh1M3hSNGxK?=
 =?utf-8?B?Y3oyYk0xSVJMNWEzdjZSZ1BCVWw2K3NEL0RlUklTYTFMdHovekdHdnh0eEpl?=
 =?utf-8?B?RHBDbjM5S1liTG5WaUFtd0czWEVQaUM5Z25tdkNoVTdQT1ZIRVFndy9LL01h?=
 =?utf-8?B?bmdSbDdjVE1ZSDQzVXVENWlLVEplZzlwcFJWYVdleXQ3WjFwclZ0YkZMbk1W?=
 =?utf-8?B?MUpxTVZLNHV4R2t6SE9ocm5hV3kvVk9qQnYxU1FtcWdERlhDenJJbkVCemJ1?=
 =?utf-8?B?UWtrdDNPQUU0cUJsWjNtRWpXYkQ5Tm84M2pVaTVqT3pGdG9CdmVmaHlmZngy?=
 =?utf-8?B?L1NrbGVMZDNjZW1aRTM3L0NHOStzc2FqbFdDTC9HN25sSjlLUWt6OGo2WVFx?=
 =?utf-8?B?NUpKMlF2eHpNZHZBZGJSdGtCTDdvaWpZaW4yOEF2ZkkxZnFqYThRMmo1TG4w?=
 =?utf-8?B?eGNVN0FMTENMUW1aaTNhdERrQUxYZTNUMERhV2J0V1RoMnU5Wnowd3RXRlZY?=
 =?utf-8?B?T0t5Rmg5cWtVSGNJL1ZYOU1HRWRqQ1MvdU1JVVdGNmlZdmFLMDhJTU5aN3ds?=
 =?utf-8?B?bjFyRWs5VlorbWlTN2RhMWg5U29ZRnhTaHhtK2w1UDN2Q2lVdlVsbmtKK0hC?=
 =?utf-8?B?M1BwUG1BNEdiajU3ei9Va2NTY2UwcTNJY3ZhTm5LNlpFZ1ErMy9XUUJRbUVw?=
 =?utf-8?B?Qm90OEJuTWJINGhtUXh1MDRuNDBPczUydUtyVW9UK1F4ZUZRbjBET3Vsb0hz?=
 =?utf-8?B?VTFtTnJZN20vZlBVMlFYR2J4dGx2ZW5BeW4rb0F5d2QvZkpuTzM5WmR5eG10?=
 =?utf-8?B?dTV0NE5hdUZHZ21QOCtITGZmUkdKaUI3cUNYTmsrOVh0MjFia0V3dkdaKzE2?=
 =?utf-8?B?YTdMNEdjSEZjUHoyVlNLYXBWRTM1SVpIbk5YMDkrcjl4Z2xrVVhrd0JsVHU2?=
 =?utf-8?B?aWpKTTcyb3lHYUdxd1k0SmwyV0pNd1ZldWNKYVNyOUl5TjJ3YlV4M0dmUzlz?=
 =?utf-8?B?dGFaL0VNWkJKYmRHZ09uOWYreDh3YWlQa1FuSkdaa0t2eVpra3pTWE40d1Jq?=
 =?utf-8?B?VnIxWXRma0RISWRON1RZVGEwZkVFMnlBZlY0eDVYcDRyWTg0dG53Si9DM2F0?=
 =?utf-8?B?SkVhc0pWeUZxRTBsUXVVa2pvV3JJQUlCa1NRbXMvU0ZQVkRZM293RXFiV2xR?=
 =?utf-8?B?eFhGSGptbkc2aDkxZERRc0Q0SzN3NjlCZlp4UFRyRTBiOTl2Q0JDMUl4dmJZ?=
 =?utf-8?B?V0lEQm5EMk9CRGFDbEQzTFZyZ1FzWXVUajhqZ1RCZkpRZ2FRZSt3T1pUUFY2?=
 =?utf-8?Q?heE3wdBgkfjqx6js8vYfysY78X9YJttq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXBOTzJVY09rYk9EU0hTR200Q3pGbFcrdC9kNnY2TEFEblNoaDAvYVhLT0Qx?=
 =?utf-8?B?aUIza3ZSUG5tYzJvbXFtcTIyeUtMM2dGZzBDYXExcHhheTREQ2E3UEw0YnNw?=
 =?utf-8?B?ODU3OW1CdzhjVU1QUmNwSktVbmJqdDY0SWVUMURtQk16dGZ6SEJid3l0OVpn?=
 =?utf-8?B?cjRrOEMzSVorZlRqZUlCa2lEQ2MwZTlIbWhQLzhwUXFUZC82Mmx1NFpjVnBI?=
 =?utf-8?B?clMwQzhWcWF1aEhtdkZxUDJ6MitDWURNbVk5dGozNnNkUjFGZTQvTHFGNHhE?=
 =?utf-8?B?c1ZVY2tZN2I2WldTemFsaWxFSmI0cHZidnR0VkVhYUp0Q01IUzdwZFFXdFlr?=
 =?utf-8?B?R0l1d0RDRmRENllRdVRkcnA2cGpIdHNtK1l1RmhWY0QxbGVQeVNBUlBnaTcz?=
 =?utf-8?B?QmVYUFNVQzdoNWhtSHVJWHV3YVdja09EVm5yeWJHYnV0cER6UHNodGwzM3E3?=
 =?utf-8?B?NENJVmpuWXJnWkZxaEZvTDBrRCtVMVdxMnN5ditBUDAxdzhHV3FFdFJLR0hJ?=
 =?utf-8?B?eFdEcnArSWxaMkl4MngwYkYvNjE3QWlUejh2SStGOEswTkJTUCs3QkpaTUxX?=
 =?utf-8?B?Y1VOZW14Uk8vRGtEcFRaVlNmZENPVFJaZFU4UCsydTNVTFhHL0poS1Zzd1p2?=
 =?utf-8?B?Q0F4cXBEVit5dDcrUE9PVXpZY0k3dmtVNlhOTUwrZTJQWWZmN1h0TkptellI?=
 =?utf-8?B?ejdBZkN1Um9qYkloYlRPeUJxaVEzQlF4bXJPbE9BVlV2cnd0MnNGRm1sNER0?=
 =?utf-8?B?QlpWby8yU09hOWRxRmhNNUp6R1VBZEF5c0pkSFJqMlNUSjBTanhsemljREJW?=
 =?utf-8?B?VndzZkk2Vk9HWWNsQjRwR1Iza2piWEMrOWljekhuYXo3bTh6YkMwVmZ3dlNq?=
 =?utf-8?B?WStDWnkvc3o1bjB4M1V6Ty9NbXhtUy9NRlFjSWdFUkRoT01nZHZ5NmhtQ3Ja?=
 =?utf-8?B?dzBZZmhZTzBBazlXS2wwNGNNNmRNMWZLczhNYWZXUnhYdEJpaWxBZUMwT0dG?=
 =?utf-8?B?SUZRb2Q0QmRoTy9Ea05lS1RyQlZiUHk0QkgySVZTK0N5d01LQ2tjSEtlRXJS?=
 =?utf-8?B?YnZCYnhXME40Q1NZNFlxdGMwRG5WcEc0TWwwOWF3UDJxK0ZVS0FNdGNLbmJR?=
 =?utf-8?B?M2poM3Q5WnlDaUU3c1lTdld1aWNLU1Zmb3dRWVB3by9tb2cyT01WOWpUb0ZG?=
 =?utf-8?B?QTlWQ1ZvaytlazFVNWpJSFlaaklWeVc1N29uUmhpcXV3SVQ1dWVWSTZJWXoz?=
 =?utf-8?B?RkoxWUZ5dEs3QSttZndGUDFuaG5rQzYyWnltZWpPR0I2L1JtRzlkaE5PNlFi?=
 =?utf-8?B?NjRxcGhnSTd0ZkIxTm53NWRZV3Q0Rk4rL1Z6MlMwZnk0enFYYkJrbW5jUWJ4?=
 =?utf-8?B?c1VGK1FwcTVCcTBGZkRaTXNDcDEvZGh4N0taRjFqTno5Q2pudnRQdFMvWlkz?=
 =?utf-8?B?WnNiWlBZTG43UU9DQXROUFRSTjhkYThaQlFFZXZMOHVhaS9JVEJlM3lYUEtH?=
 =?utf-8?B?Rko2UW00NEJqdHJGQmRrbVE5dXpkZFdvYjQyTk9HMi9hd3RUVUJGd3d2N2lJ?=
 =?utf-8?B?Rnk0WW1Vbzc0WSs3YzNNaGc5MGpRQktqMGRUa2JiMnozU2NzZ2p5bGNnaHZW?=
 =?utf-8?B?NVdNNXlhWmcrZThJa0YvU0x0cU9RNmVLQmh4Smp2NHhxVDlUMlRPZU9iL2lZ?=
 =?utf-8?B?VWRYK3E5U3BrOW11eE1EVDNMQXd0NDJENW5uck50NmtGNnphSC9oVm8zcDBJ?=
 =?utf-8?B?alpodXpZUk9ZUzc3ZXFyemc4Y04zOEEybWpQYUl2N1M1ektxbEh2d3p5eVYr?=
 =?utf-8?B?aGppVVNXVGc3SWpWVU5jZkZrOGpFYmZ3ZmJHU09oOGQzVDZMdHpoaXRoYWRC?=
 =?utf-8?B?SHROdnZvQXpZM1hiblg3RXAraHk0dTM0QWtZUStidEJDWCs3SENzNXYyTndy?=
 =?utf-8?B?VVFlT2VRa3IwclNKU1h1Q1U3SVl1bUNZZjNMYWprakhDSTNGZHdJMXZadHBC?=
 =?utf-8?B?RFFqVERHNTUvbnBEejNNN1E0UXdodlRJM2xMb1JUQWZUbmhpNW1GY0p4Vkd5?=
 =?utf-8?B?NHhrUWJIY0RLMm9BNjFtYVBNUkVHWVBtekdLTllXNUZMNVdKcDRBekVUUnBH?=
 =?utf-8?B?MGMyenp3NnpDb25vUkZ3Skxia0ZKS2w4UVBId05DR3hNVEZER3BPNDFBdmwy?=
 =?utf-8?B?QWhYcmNrcFJmTDI0L3VQNFJqUnhYVmxCU29ObUFjdi9obVExcEFKdEM5ak1u?=
 =?utf-8?B?RE0vUEtUL1JiU01NNnIvbzAvY2NTSER2d2FqTWdXd1g3YmJHWHdXTGx4Tllr?=
 =?utf-8?B?bUtiY0I3M0hWMnVRU1I0cllQaENpb09Fd1dSMjNzRS9oSlhuQWcrdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d8ad79-01a2-4c22-58d6-08de4c8144c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 17:38:42.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVqsy4DLPBSDfSYyREV++jv+EhRMJ2hnlp0TGl2QTRb1MWDsO98g9zvDJlr+NhbiSxbX55PbxraN+Gr2IC1c1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF6D0742E7B



On 12/25/2025 6:31 AM, Zilin Guan wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> pds_vfio_dirty_enable() allocates memory for region_info. If
> interval_tree_iter_first() returns NULL, the function returns -EINVAL
> immediately without freeing the allocated memory, causing a memory leak.
>
> Fix this by jumping to the out_free_region_info label to ensure
> region_info is freed.
>
> Fixes: 2e7c6feb4ef52 ("vfio/pds: Add multi-region support")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>   drivers/vfio/pci/pds/dirty.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
> index 481992142f79..4915a7c1c491 100644
> --- a/drivers/vfio/pci/pds/dirty.c
> +++ b/drivers/vfio/pci/pds/dirty.c
> @@ -292,8 +292,11 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
>          len = num_ranges * sizeof(*region_info);
>
>          node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
> -       if (!node)
> -               return -EINVAL;
> +       if (!node) {
> +               err = -EINVAL;
> +               goto out_free_region_info;
> +       }
> +

Thanks for the fix. I was on vacation, but FWIW:

Reviewed-by: Brett Creeley <brett.creeley@amd.com>

>          for (int i = 0; i < num_ranges; i++) {
>                  struct pds_lm_dirty_region_info *ri = &region_info[i];
>                  u64 region_size = node->last - node->start + 1;
> --
> 2.34.1
>


