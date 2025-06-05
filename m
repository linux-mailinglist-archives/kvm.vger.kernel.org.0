Return-Path: <kvm+bounces-48552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 407B6ACF36F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 002FF7AB446
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1680E1E261F;
	Thu,  5 Jun 2025 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G5E8bC9E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4E8139D1B;
	Thu,  5 Jun 2025 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749138682; cv=fail; b=SKzvEPmMnTJ+NdeDUMsencXvYNvcZ7fEzvo9/DYOd0GPo3U8bzs7vo2FHuAAMYK3itJTwLACHIZXn4vNP+ce7qKNUMkhS26sbDSzDqCkgEdPmoAVHwXBWPUYspXXTsMGQKDdYe7G/Xk50v2KT4022h2P27NQSPLCHOimP6v2uNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749138682; c=relaxed/simple;
	bh=UnDQa3tysWT/6Hlhg0j/NzWV3oYgfA/Kb5iSZdHqt5M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fkZ9erNiuxEgBkhQkgJZsjtmPCqO2RZwEZ8i4gse34qgxbKvEfNc0q12cJwiuktBYi0x8RGHcXB9XoG91NiUzyfg4+rX9WH3kmxKSeUwXDuF4utV6vCmw50Ps9xhXq0IODULt8r4s2+G5i3WklxdRb8u/K5Ixvs4zOZNuPVFZWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G5E8bC9E; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2H/jTLmyrlBb5lQNs2wx2mFH8CRl9BQlW0SVYznXQ2WNqO9H9GTqyepn6AXymv4f1rKMeuLu5P8vtq0zPNYjJ5ApBLKpiZ1deYaGKVKYYZj7AUgmd0yM+wSrWdBC2C5vAgNC8Z0MqamJtv9VkTjeTd4Rrezbq8upnx73FUuOCIdftVGQ2jj9iV4TFEujyjsO1h8opP4PSvewr5v+YOs7t+43GOh3zR3FU6lMk01CUSOsYNwymQCy/fMpevGWQM9vfhtg+4V5SztyuJCpnnp0iK20jqEqbzky2fV1/NHyuxuyT/AYZ+YnG1DTlB/vYOvOoQ9W2z0XfvxtWrv49vHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nf92Z4++OEYLTDsk1Smjz6VBjhzUxPEFetDtvjDfD7w=;
 b=xXvveMLEVbU8o+DOsgqA9lZeh2QzkqmCDxOjSn0Nqb4Q7j8Sy002Up7L5I2viGw49HFNU85cYlxVwHJA7vhn23K76JK9PKdNgtnWXGYQxP3QQ15hhoYZ47NSEJukMBfpO27MQYYZW3TMJMHlSstziPdBRyCwkFMd59GTTUtOBu8nNEJTMWIJJpA1Lu/a2K5hqLmXwOjP7yr48qYAagUY1WreJQO2vcUtMDGTOJCasMaqW1MEbgLQg3CBjn8L+n+3KkY+3D5TSn501nDbtChg3z1SWQA7bLMtrvRLhUtEUOt44x594rJD6vNq/PadNqTQK4PHBIBby5tyXfoE4Msqpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nf92Z4++OEYLTDsk1Smjz6VBjhzUxPEFetDtvjDfD7w=;
 b=G5E8bC9EDPxSAKnpnWuhVpku/yQdeediTsr24J3oKLhSUj4v3CfrQmX+UlvqHAmeuuwsBBtWYqUglv0k8qcnWqklgn76sSkWMVLsu3wiDLtk091QYQCvk7D1wEgKRr2fe4Un8wgfxXxgtjXX/KXsHKcQN28vyJgOdxTj+1w/UEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.38; Thu, 5 Jun 2025 15:51:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 15:51:15 +0000
Message-ID: <9cac6024-2e13-12ae-24f2-2f1668691935@amd.com>
Date: Thu, 5 Jun 2025 10:51:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 2/5] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
 <295dd551-522e-1990-4313-03543d22635e@amd.com>
 <9af40b3b-91d5-4758-abee-070fbf3ff52f@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <9af40b3b-91d5-4758-abee-070fbf3ff52f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0337.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a5a3669-27be-4aaf-6ebe-08dda448cdd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUR3V25HU0JiVjhKWnhSYW9LMUVLWEFCaER1WCtJbEVmd01FQ05kNEZlMmFI?=
 =?utf-8?B?dWpzMm9JRzNTMWU3dzNUZDBQemR5Um1kQmtMRWMxOWtVZU1kM0ROMWRIM2pi?=
 =?utf-8?B?Z3E4d0MxVnlPVmp3RmJjZXFxVE5ud2FGeEFyZ1VPZGgveVBSZlFiYS9DZFho?=
 =?utf-8?B?Sjd4d0M2T2Vjd0hoVlU5VTJaSXIxdGVQMktzWjRnYTNva0dJZHFXM1hWWk13?=
 =?utf-8?B?TzQ5dmVzVEhyT2w1MTFDcmZnSXV3TkdxaWNtbTNWRWFmNHp4QU9jQkVNd0R6?=
 =?utf-8?B?dmhrMjVwcW9hK3BtUm1SNFkzbE5Yc2RRbytIUENsNFhjdytOaWlJRXBwbTc4?=
 =?utf-8?B?QnZseEI0M3Irc1NhOU9NOTM0UEdjeGhzV2hYejI5c2xkQzZsazlobFZidk1y?=
 =?utf-8?B?M2RRckJBZGJ3eFhNdFhSM3NpOEpsMCtodnBpLzBwYXJISTlRVjc5WUpsZXZa?=
 =?utf-8?B?ZWJzQ3VTMmRXVU1kaHBQMzlwZVlUOHE0WU5oSzdZM0dXVUdUY1pGWFB2bURR?=
 =?utf-8?B?dzUvNVBpRm9nd0IvTG03ZVBwc0xyd2VVRGtmeWRSbjhNUXdWNG5TT2tmOUxv?=
 =?utf-8?B?TnJ6U2lqZXJPaUYvNUVBdksrVDFMM0M2WGlJYnhCOU1BZ0p5NDErREd6VGRY?=
 =?utf-8?B?di9LK3QzTThNbm5Nd3E1bUN4QmtTU0dvYll2V0xKK2FBTG5BR29qNnJ6NjVB?=
 =?utf-8?B?UnRvVG53QVJRbU90QVBJMU40RlM5SDFFMWxGSmN0eDJZbHI5cy85S3owUk1y?=
 =?utf-8?B?bTFwaUNmWEg2SzBPdUJmQzNBZmZsSHFSS2YwL0ZWdGRyZUcwSXVHeXZpZlh6?=
 =?utf-8?B?ZTk1bmNWdWpFbHNvVEVBUCs3dERxa1FpVit4UysrM2lIYmFFSGRvVGIvbFQ2?=
 =?utf-8?B?bGFuV2tVWUJJQTlCUnFDR1pzelI2WTFCSWZHcVIvRXBOdy9iMU1Qa3cxZXk1?=
 =?utf-8?B?eGM2dXBJY1BSMUxWeUVIcWZ0WUgzaTNZZjE4bFhXai9UMkZENDYrc3NzU296?=
 =?utf-8?B?R284NW1zY2dZTTJ4ekY5TlRmeVBxQkNLZ1JhWHg5Sjd6cUlDSDNnZkdvVUV4?=
 =?utf-8?B?N1p0MHB5OHBtS3dNaFhXSklFSURhc2kwUFBjcmhGb201dVNKNlUwSkxkaHox?=
 =?utf-8?B?T0RIVjhDOGEzNmRGL1dXK1FkVlBPaXpwOTBLZExrRzFyZkNvY2gyS2g2UUtT?=
 =?utf-8?B?Z3JyQUdBTEFZVEpjbjB5UTFBZzFHVTNtTEtyM0M5L0FvaFVYMjFWeEVzOUc0?=
 =?utf-8?B?dzBtdk1hV3NNY3kzSEVoV09SV1NpNDZkUndLWWlnNmJaY1doNW9UUERsT1JS?=
 =?utf-8?B?YloxcWRhWkVPVFR2ZVhMbkNvbmdvTTdEenpDRVoxYTUvSnRKYjZHbVc4dzBZ?=
 =?utf-8?B?L3pmeDFDTXQ5U295TUQyU0IzcXR6dE9iYVNZeU93YWdHTnJpeThJVVNaQ3Vw?=
 =?utf-8?B?VGUyNFF3Rjg2VERyS3BPRFZlVTZ1L1lwZ25rM3hSSGJZbjV1ZDl5NC9GbnJM?=
 =?utf-8?B?RWx0dHdCZUtsOGFoNFFQaEhqQmZWeWVOZUNwUXVqR2VCbldneUZQQjc2WlBF?=
 =?utf-8?B?TTEyeVBDWHhyZXlyUHFITEpCQ1lGMHZWeVcwWFBXWU52bUkwa3JQZkJGMGFi?=
 =?utf-8?B?Z0JQVVViVlhrQ0xGV2p2cmlGRXNHWW9qSm1URnZQZUZIQllaZlZFNVRkWWlx?=
 =?utf-8?B?TVZJU3E3YlptY3RGdVIvdXZraFhkVGhZcWxoNXBDa21WVFNvQlRkczBRMEpv?=
 =?utf-8?B?TEIzd05GQzcvbHJYamZuclY0TDNpOWxGT1VuUmpsRkNtNldsS1RJVytzZmQv?=
 =?utf-8?B?bDA3YVRqQyt3N1BESjE0N0VWSnBiSGpvSWowcFpzWmhYTWJSZXlTdHpHcC9O?=
 =?utf-8?B?Zm45bFNzMzQ1MzlwZmdPb0RVS1hyeW05VWNHY1ZhektxMDJ0Z3h4Yi9IeGU5?=
 =?utf-8?B?ZzZFTVNxcjRnUnRuaUVyRTFqYjBvNVNnb1ZBUUJNSXNpcFR6dHZHMlJObWRY?=
 =?utf-8?B?cjRNWXlGTm5nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0V0R1ZTbzZlUjRPVWZPNFhOUnNLZzNFTDkwTUp5LzljTlRPaDMrZFJPVGF5?=
 =?utf-8?B?UUFOZzVEdUpyOXQzWWptbkk3TDF1WW8vU3YxMzd1RlZDYjA3cUpwUktPN3pz?=
 =?utf-8?B?T3Z1VmExWW9LYXZQR0E1TGxyTlRXZjdSajFkeEV4bE5jNmkycUl5UjhnNDMr?=
 =?utf-8?B?MU9GU0c1aXVkZi9TdXFvbUJPMHdhak9qWkdiY2Y2OG9Pc2wyZmt2UlZicTFV?=
 =?utf-8?B?SVRVSE1GS3Fub1NPUGl2Mk1tdloxbDVzK2xwL3JMYkdGZFJ1cEJ0Q3pnVEF2?=
 =?utf-8?B?cW5vdmx4cVF2Y0piZlF0cWlwcGZmTzRpQUdYZjA0UE9kY3V3bnRmQ3dOWkhu?=
 =?utf-8?B?dk5zdGR1ZEpnZTgwZ0xaSmtTSG5adGloYzR2VDdCZHRidCtSM0NGNHRSUHZW?=
 =?utf-8?B?bmFVY0NkSEk0ZlFKcDB1LytIVlhRS2MxWFR6eXhGRUk1eDhpZkRCSTZsRmpQ?=
 =?utf-8?B?R3hJQzRVc1cxb0JCb01CdlN3aW8vaklXNEtwNGxGdUs1MUErNTBsT0l1MHA1?=
 =?utf-8?B?NWtqTGhDamFxb0JjT2R3Q3l2WEV4aTFFa1EzOU4rVG41bGFHSjJ5Z1JEMXR6?=
 =?utf-8?B?c0NoTzUxVkRiZEk3YlowdnRsU1BHZ1d5WjBuT0xoSjFDMmtPSUJUYjRRemtC?=
 =?utf-8?B?NUorU3N0eXZtZDZaeEtuTitVSWczUUxOanlydUM2VzVDY1VzTEl3UVM3b1V1?=
 =?utf-8?B?eUJQeUVST0ROM0p0ZnB5a2FndlVpcXE3QjVqMU1lTzFHRVErK09BMHIwdi9H?=
 =?utf-8?B?QllTSkR4a3h0dERtUUt2V1IrN216elQ4NHoyZFZvMzdVVVdCdGxxNlF3ZWlF?=
 =?utf-8?B?dzZZWkllNzFJMmtzUy9ZaFNJSGdyWUdscCtYcHUyYXZJaUUrcVUrbmg5SW1t?=
 =?utf-8?B?WVM0R0MvL2dGRlo3WksxbWxpUFZ3ZE1qNjgvaG1IOTZueW1ubk43bUpqeTFX?=
 =?utf-8?B?V21WRWh1SzNjdk9nOGw2OTB6Y3Z3c2NJTXZzZXM4bU5ab2p1RC9uTmFTeXNH?=
 =?utf-8?B?UlgvYkh4UHp1bmVLTFh1SS8vc3FGZzBacjNSRFk3eFpwcmJnRGJVbmlONXMr?=
 =?utf-8?B?dzdPSVpLK1hoOUMvWC9lcHg4aFA5SlFFU3pneHBOR1M2NmFBc3IrWTJCL3R4?=
 =?utf-8?B?UDIwWjdmeEZvdnZHY0xBSVNwVkUvRXVlczAveWdreURDT29EQmJSNkVhOHpi?=
 =?utf-8?B?UHZONUNWL3VKSU9oNitWT21wNEFlYW5kbWRnMkhROUw3THFjekFrZ3BiNitJ?=
 =?utf-8?B?dlV3YUI4dkV2R0sxZDJheXgxamc4Nkg2VTNhNkJMMVBkcVlXNjVpNDR0MzRT?=
 =?utf-8?B?ak1IQnBKNXFDcHhrMzRMNERUQnBpV1g3VFp3eFRMZm9ZZUtBb05TMEsyRmxt?=
 =?utf-8?B?RitsT01FRzJ2ZGRMUWphSklhMm1sZFZwM21ZRG1LeU9QRE9DNXpLNURFcXkz?=
 =?utf-8?B?THBvUzU1UEZGYlZzMkR4TW40ajZzWWh3eTJYNWZIODNHWjdhNTEwTER2UXd6?=
 =?utf-8?B?M2pOZGtFRDdKZ1k0V0dCOXlBR2I4Q0hpVGF6TEVaSXByVFdHK1FnOWNYYlZ0?=
 =?utf-8?B?OGtRdGlvYmRoTGF0bWZUSm04RzFPbG9Sb3FkbU5UdExhNlR1U2RoVWlRTDg5?=
 =?utf-8?B?VmdrZnlvY2UzOXd0OGo4NVNLTEE2ZkJwMm9DdWRhRTViVS8wRUEyYWt5ck80?=
 =?utf-8?B?VUVCMk51RFl5Q1AyTWh5T1RyWGpyZ0JNbnZ2RjlmZkRHWVFpL1ZrVWVjMDNj?=
 =?utf-8?B?ODJCV0cvbVNpVkhtSGpOalFiMURWTzl4YkJRNlFsS29UYUpXRFg1YVFrMFpi?=
 =?utf-8?B?U3RLQlhYZlMyVi8vN2xlZzhCVzlYWGhFVjJiOU0zcVl0aE9CamtRdURHOW1T?=
 =?utf-8?B?RmdBbFYxSmJoZ2NhL2J1V1ozWHlDdGw4UGwyZUx4V2RGQlZ5YkpacVAwcElE?=
 =?utf-8?B?a09yNXhUTWlsTjQ3QU1STEc3eFo2ZTdPV3FHUTMzOXRLaGZka2RaYVBMcytP?=
 =?utf-8?B?UkVNcGhTSVdJNWhBaWp4WXZuV1h0R3RQVkpHSjZlb2Y0bkZCM09uVnF5VCsx?=
 =?utf-8?B?d3F5elkxMjZaWDI0QTR1Qk9sU0wxdExFa2hxd3VaZW9qY1BCS2owVWlHdWUw?=
 =?utf-8?Q?3MfN1llSLBblVlFhpiPK3TKSx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5a3669-27be-4aaf-6ebe-08dda448cdd4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:51:15.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVdvmwNbzo1JN/Y/a8yHKXKlw2a1RsdvJHomzk5Hv5derZba/+jIrtbjoi1/sqVyIvsAdVHeqjf6DaIcoRg1vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069

On 6/4/25 17:52, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 6/3/2025 10:21 AM, Tom Lendacky wrote:
>> On 5/19/25 18:56, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>>
>>> Switch to using SNP platform status instead of SEV platform status if
>>> SNP is enabled and cache SNP platform status and feature information
>>> from CPUID 0x8000_0024, sub-function 0, in the sev_device structure.
>>
>> Since the SEV platform status and SNP platform status differ, I think this
>> patch should be split into two separate patches.
>>
>> The first first patch would cache the current SEV platform status return
>> structure and eliminate the separate state field (as state is unique
>> between SEV and SNP).
> 
> Eliminate the state field ? 
> 
> But isn't the sev_device->state field used also as driver's internal state information
> and not directly mapped to platform status, except the initial state is the platform state 
> on module load, so why to remove the field altogether ?

Well the state of SEV and SNP are different, so they need to be tracked
separately (or at least better clarified in the code that the current
state field is tracking the SEV state). Since the state field is part of
the platform status, you can just update that field. Not sure what it will
look like.

The current state is only SEV related because SNP only has UNINIT and INIT
and so the snp_initialized flag is used instead.

Thanks,
Tom

> 

