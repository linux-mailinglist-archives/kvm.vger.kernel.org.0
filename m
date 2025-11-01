Return-Path: <kvm+bounces-61751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D21C287DC
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 21:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6A7BC4E371C
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 20:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1642F22FDFF;
	Sat,  1 Nov 2025 20:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l9QhHl7f"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DBD22127A
	for <kvm@vger.kernel.org>; Sat,  1 Nov 2025 20:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762030524; cv=fail; b=Opp9R788QKtWFoljNvY3aTR9L00pX12nd6XpNtZ9C5caMm7ylvN0VU+f1C/PSPTQ4SNWWLCjA0rQU740uVcq995QZEsT1dMM5bYuuwX3YrH9m+CE83Pgn7abcpKUzCur+KinUgCALmIe1wkrvoRAA2oP5EFe/gXM7CDk0WK0498=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762030524; c=relaxed/simple;
	bh=+oNdb2EIH2l5TpIJ3mSsi7hpPScC+TA2WSpWk8X1mDY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ASJOusBFQeDfdGzVzPDaG6NrH0kvAp2rhg4o/3m5LnHggK4J4TZqXr+8vMNdKMQ2fn/bBIRgkCGhkCo1HBPLoL9a0GvVJULa0t7GMPRvDoISsMmUM6HpIGJ2DdMGHpYofICzpk0IDat6iWONrCc/io01lQ1DtvtfCPqDlduxlcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l9QhHl7f; arc=fail smtp.client-ip=40.93.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0esnhmQuaMVWBeClpfrYRYK3ypFt+vgLf8lIUOnAUIv19dAFWBN53qHv964nl+Z6hKEE9E+D4O/YDlSZ6K326VsY18U+wVwQhaTQElHEl7JwyYhiS2EITqmNKD7NQmI+9Z6kZnzY2NDOPl2LkTASPoVJG9gtbzogwzbbFpOmi7q6VgW4onXIGBKlF+Bobc+HscM0+w/hGc3ejnUUZKksp33eEeoFL4z64+ci+TkCUZrgAwHicIWENwNsQlAyFBMMVPWn2JHk5KE1qaxeDbr5H7wJ7kFJFX282lIAd7v8u3OR8yMgTT9sJwdTkGCqwjGKDh/Ka94DldCFJeQ4Bj8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oNdb2EIH2l5TpIJ3mSsi7hpPScC+TA2WSpWk8X1mDY=;
 b=KAjZKDpPwroX4KNFt/046gylf1N7gIoPk18sMQZLLQ15TZDJPcXBFK4bRV3jj+nLnS49VVnGLHn2oHdAG+ToJYAThhTRj1MykD+079IQ22yBQHe7wqPHKAmHR3H+FN/hzZkzxkeyN5syz6CwF3ITseOqSkmwCSQ7az61ApCggVGpRxVfbdH3gmX6LeFEzAOIqjgFfJ+4EQi13mx5wPwf7yO8Y/HDskuOuYVOh3oL48QeaJ+J02Yc5zOPnTXLVgq03gApJ9BTKTN5bpZtx8nPpkifQyVvBYgnaPQ3KkYO5VD0OimdGuubmWvHH9FuKvFi8jEzMebeHdhUX4JEJ0k0pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oNdb2EIH2l5TpIJ3mSsi7hpPScC+TA2WSpWk8X1mDY=;
 b=l9QhHl7fmPJMpSa90D8yyaER7MoAIac/qMQ4I7vPSpJW2nrRVA6zlvah+A5ayV5Fhzx67w6dX+9mFlSiZc8cmXZWXWDJEznLR4XkAgnFAq7bIJzrrlHAgBOnHeSieqQXvAYwdZP5LPGPoP0sbTM893boPHVFd1U8YoTKQqZHPN2mpWkMbP3h5EQKT7OwvrSJqe15GSls30jKmCguKf7S0C3pzMS1sWEYbSMJmCg2340dUd0Xw3Et4233uVn0Fp8lXxSkSH/JpnBmnRua3dDjx2zxtxC7va0fVUBa5ldagJ+szSgGN6t5ScJNW0oekI2JPxRCR41IOChBMsMYWG9AXA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by IA0PR12MB9047.namprd12.prod.outlook.com (2603:10b6:208:402::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sat, 1 Nov
 2025 20:55:19 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9275.013; Sat, 1 Nov 2025
 20:55:19 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "mst@redhat.com"
	<mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH 1/1] vhost: Fix kthread worker cgroup failure handling
Thread-Topic: [PATCH 1/1] vhost: Fix kthread worker cgroup failure handling
Thread-Index: AQHcS2f5SLSU5aETU0G0R3FImkjTfLTeTNeA
Date: Sat, 1 Nov 2025 20:55:18 +0000
Message-ID: <dbebe5a7-5b35-4d19-8a17-8590d3f78a13@nvidia.com>
References: <20251101194358.13605-1-michael.christie@oracle.com>
In-Reply-To: <20251101194358.13605-1-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|IA0PR12MB9047:EE_
x-ms-office365-filtering-correlation-id: 8f3c77d1-2fe5-40c2-6004-08de1988f75f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RWJ1TmFNZmZoV0s4U21sRzFwcGdReGVSNEZTMHBiU3NiT2Jsc09LNmNhcFJN?=
 =?utf-8?B?MmJ3aE9sbEhDNTE4U0R6bVFvN2c4QVYvYVFibGdkUndpcFc3KzBnTUhnKzZ6?=
 =?utf-8?B?YnlBR1VmbnQ3VWVnZFQzbHJBUjRyZ3phMXFOak5mY1E3SkVIMDl5ZEFJVXpi?=
 =?utf-8?B?UFI3cTNDb3pRaDhuTy9FNjRCdjBiVG1CMWFBclh5L0hZNXY3S3Jxb2xGbnln?=
 =?utf-8?B?QmVGeXpvUjV5NzJHUnpYRmttY2lHM3hlS2o0TktxWmplWXdiVUdGT2JSTnBW?=
 =?utf-8?B?RjY4a3hlWmNrTGJRc0k5N1ZRNkt0Ym1DdVh5eVQ0anRPc2hRd0lLcy9IcmRo?=
 =?utf-8?B?b3pkeXBuU3R6eFVZQkI0dWxmMHRCejkxNDZGRWRsejdGanZiT3Y2RWh2N1V5?=
 =?utf-8?B?NGpXNmFpcVVlaU5QQ3VYMDRPSWNSRXlvbTgwNERhOHViT3JjeEd5VlBqWTdi?=
 =?utf-8?B?YUxuQ1Y0MG44Y2F0SmZ4Q1Vjb3RQU0IrUUdoTGpQUzhDWjJuV3IrMWNDUTdT?=
 =?utf-8?B?MXdMZUxsZEZ5bVhndkZidktyamY5RmVmdEQyM2pkT1I1M1Q3bzNrckxRQ0dz?=
 =?utf-8?B?T2tXRUFYejEyZ1ZSU1lWeEh5amEvUmdUZW9kbHFKVkNKYWROL1lPb3pyM3Vi?=
 =?utf-8?B?NkNUVkdkOE9pRmFCalQ5T1pFcnRaT0dta2lmbytFS3FiK01TbUFudFFLZyti?=
 =?utf-8?B?Zk9XS3F5Y3VtWCsyZm5Cb1k4Mzg5OGdQbkd1eEdEeUJzdXNnQ3JFN1RLU2J2?=
 =?utf-8?B?TitKRUc5R0Jxb2M2OFA1bTJsV0NlNkNYZGtQcGU5R1FPQWd0V2dqNFZFb0w2?=
 =?utf-8?B?RjgyN0s5WjdCYWRDSUdsUzhlQU0wWGlDbXUvLy9RT2FzWnFUU3YzK0lHWXBu?=
 =?utf-8?B?MmtVZ2FBcWZWWHVGTUN6MEtzUTB3bnhwb0ZpMnRaWWFvVFNGdkJuZjQvNmp5?=
 =?utf-8?B?dThKM1N6KzUxS1Q5WHg1bmVOdW5POHFFL3FkNitTMm9XWGVBV2FpRHJMZEtG?=
 =?utf-8?B?Z1dmUnpvaGMxSURMU1hVNFNaWDh3Wm9vN0lYUmh1MC9pL1RTMUNuOW8weUEz?=
 =?utf-8?B?NFRIcXVXTi9XcUQ3KzIzZjFRMDNFS2pmMEM3dVFwYnBlNVlWelVOeXlmeVJX?=
 =?utf-8?B?UjdQSlExWXREd1Z2S1FsalhWbCt1WDAzelVKaFh1dFR3MEpaTDlDeDJiaG45?=
 =?utf-8?B?dHRjQ2VsTU1KeHpKV0JTY0RiK0ZHRzJRZ2NLNHgrdDMyYVVhbEJCSXpQNWZl?=
 =?utf-8?B?Tm5veHA5S3UyL1JEeDF4TzlxSHlSUmt2QjdQU241TUNOY0hGRkIxMTJ0bi9y?=
 =?utf-8?B?WjQ5RVQxTDFpS2o5L28wTTVjVFM3VCtmTUJvekcwTDZyd0M3T2JZdjBJVDRl?=
 =?utf-8?B?RUNSS3IyZXBwWlBBd0Rwa3hvY3E3Y1Y4S3MyVTlmV2d2blFFVkRRc0dZQ0Zs?=
 =?utf-8?B?a2p4VUFidFEwckUyMTAwN0JicFcweUp2RXZ4dUFob0JxTVlhSkw1RW9DbU9s?=
 =?utf-8?B?allCNUk1RmtvT1hyamlJVVNUY0RVczRyV1V0TndSRjhQTmVjbkZjbEZhQUpM?=
 =?utf-8?B?bHdHcGFpanlQUE1HcXhua0hadTVMSTZ4OXYwalF6TEpJR3BOYk9DWDd4L1Uw?=
 =?utf-8?B?RndaK0dZenVtTVFKMTg3UDNiUXkvZGtVcEwwaGVwZWQvdkNsZGhFSWNXOFN6?=
 =?utf-8?B?M1E3NTcwM200U2lyampPdVF4Q1FvWjdNSlJZeVdoOEwreXV2UXhicnBYd2hG?=
 =?utf-8?B?cG90S3VBZVFNVHdzYWVzVlZsNWxoVWxjUEhOelBwSDM0YlNaQmNJV21EdFNU?=
 =?utf-8?B?YXg1WktkMUhVOVhVcUpRS1BtRnhwVWZvanlBNFlXTjFCMXpCekUyYng3UkZV?=
 =?utf-8?B?bXp3NjJxSWo1ZldDYzZSVzRTOGJkNmE4NHE4V1NUTE1LVWtWRTJHOXRKbmUz?=
 =?utf-8?B?dGxHVWVZUDVLZVQxQ0hoSC96RVdYVU54ZVIvcFRTQ2dYSHViL2xpemVGS0lZ?=
 =?utf-8?B?TEwrNHJpNVpCalVhV0p0QUd2WHZUK20wckgzR1hkRGxTc0NYL3hZL3BMdnhj?=
 =?utf-8?Q?mVQbX6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnpvcUE3cmlvR1hFWEIzWFdFcTlMUSt6Nzc0ZWlBWEd6SFpGTm0xaE13N2VI?=
 =?utf-8?B?OXJLeHZOZWMyWEhHMHdld3kyNmRNOW5POWdtRldkRUZjYUtGZVNwa0ZOa3VF?=
 =?utf-8?B?dkMxajZsSmpWbURBM241TkhyUUF6SjhMZUlXcmFuRU0wQmhoRkVEbVZ4dE9U?=
 =?utf-8?B?YTJWazdNN0tvNkZ5TW10RUV4QmZCNnMvVVFha2x1ZzludFYrYVUyK0JhczJ5?=
 =?utf-8?B?MHhUQXc5R3hLUnZ1b2tpU3l5UWVlcXZ3eUlGYzdWMVFIUkNHaXNDcVhDM0dT?=
 =?utf-8?B?cHpVbSsxVnB1UU92dW1qY3VTUzFxKzBsNmZubnUyLzJFSkF5TldPa2NCMUU5?=
 =?utf-8?B?UGMrUStxOVBsRE8rYTFNOEx2QUtYd0lOaEFkaGo5RkxRSTBKMGRDMll2bWdN?=
 =?utf-8?B?UUpPcUE0b0FYZTF4bDZlRkJua2RPOXRRdnpYZ1JYTjhxS0hjUlZwaGUzWkxR?=
 =?utf-8?B?M2JNbU54U2pzZlhhRDV2S3VLUXlJOWxOTDBhMTJzNkpQNk9BNHZTWnErM2ZP?=
 =?utf-8?B?bHpKUkhGYzJkRVQ0Q2JFcWpCdXJsUi9lb1VLUnI4MmIyY1hqL3k5WWFTWVVp?=
 =?utf-8?B?WC9ZL3JXV0U5TThadUxsZUw5SGVNNVViOWFQRmhVMFpCZzNocUxPbWtJUEEz?=
 =?utf-8?B?bmZqRWlPcVpjNGJlai9uSXJsalhudU05ekM2aWtCUThhb3cwMWNocnRpbTdC?=
 =?utf-8?B?OUZvSUxaMytZRkFEVEpidlFNeU9ZYTkvL1RXNmxFRDc1WTRzSjZjaUpHOGlV?=
 =?utf-8?B?RHlhZkdkdXFNMHQ5aGR2MEJxRlRoYVdpcGhiOFhuSnZhOUZTazhSZmpVVFNI?=
 =?utf-8?B?cVdtK3BsU3czRDlGRmxUQVJ5S0h5RlgvUW9hSEgyMFhQOGs4U25rQTBKdi8y?=
 =?utf-8?B?d0Iyd2Ryc3BpaElpWjZ1eGNoZGFEY3d4cllFZFkrYnFkbCt6Q1FZanlGQlQ2?=
 =?utf-8?B?MGRScEFJMnc2RC9XVVdBODVjQ090d2kxc3c2czRZbzBUeTgzZGwzcG5ycUFS?=
 =?utf-8?B?aGZrUmwzbU5YRXdlUnA5U2xidHQ4UEptTEdUVDRLd0NiR0hBbE1kZURwdUZO?=
 =?utf-8?B?Q29jNThReEErbmxQNXB4ZWVHU2JObkU2NGUvV25MSHMrZktvRDd4dDFmZ0lT?=
 =?utf-8?B?akdMRUpNTkhjK0hPbWhXNy92S1BKWUt0WGVndGJkamo0dS9jd0VrU2lST3hu?=
 =?utf-8?B?NjV3TXpXLzY4dWtUR2I1blN0Q2tXMUJ2ZnJXQkp6cGtQbndlTVIyK2daWld1?=
 =?utf-8?B?cHI1R0tOc09memxkdFk1cXhnQkNtYzk4STNBdm9EMFo1YVNRbzdZcllPY0tq?=
 =?utf-8?B?MllieWNMZk5wdEREa1IzbEtjRnk4M01sRW93bDFleVptZXJ0R200czFrejdn?=
 =?utf-8?B?UDltakRGNyt2NmtCWVVKRlBBWkNQUlN0ZTFxYm1FdjVrdCtJYXVoZmN0YVFV?=
 =?utf-8?B?Rmd5aEh6MnpTQVNZSmVreTRYV1RaemZKYk83YzBKS3d5RkUyWlE3L3FWa01a?=
 =?utf-8?B?eXUzL25IWnExZXRsSjJMaHEzSThMZTArTkxheWwvNVk5aXc5UGdSenplNzFi?=
 =?utf-8?B?RU9mMjVBRjRkMXcwOXVObHJZN0dYWmk1YmtRM0pUdWRWM3hLbk5QbTdTWFFo?=
 =?utf-8?B?TmFXZ1hQWDd2bU1TT28xQWlPNW4ySUxTSDU3Vmd0NUhvL3lTbEZYNy9BQzFB?=
 =?utf-8?B?UjVHdm56Q3BrWHYvUi9EbjhVQ0gzak9VNVNwcXBJY3JySVdiR3FlOFdDSUFR?=
 =?utf-8?B?U2RyZHFMNkVTbEppejVpckZvWk5FeDZJWmNQeDJaL01aMHRTTnZlUlBrdjl1?=
 =?utf-8?B?NThiNEJON3NTWnBSSzFzN2lPa2xyOE15RzlsOVhQbUFBY1ZlWUVKQXkxNTB3?=
 =?utf-8?B?U1hFRC8yUEVOckR1YXMyMG9zR3FmcWludVdBNUprMGRwK3V1TDd2TnhlYzBM?=
 =?utf-8?B?YzQxQlRhN29jaklPNVFrWlF3ZmpzbzlSeThGWWFYZ0h6MzdQaFZOQjN5Ym5W?=
 =?utf-8?B?VVNYUS9waFJITTdraVdIVmpjbkVZc2s1aVY0QXpHa0JDUVIwanB5eVJSRzhU?=
 =?utf-8?B?dDNDd0RLaUNRdGpUdnNUMjVYSWo0azZkRWdnK1FqSjFkb2VDSXRCNXlOejdG?=
 =?utf-8?B?N3Uxc2orL295bDRpUTl0a0ROQlRhMzVUVEMzRnBZZitTUUtMUUFHZndJd3Rz?=
 =?utf-8?Q?gLffLsga6biBIu37cx5vPui8M6pp+jIcUV23PN4BQnGk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3719E0997D82644A8E7024E025818E7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3c77d1-2fe5-40c2-6004-08de1988f75f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2025 20:55:18.9082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1lWvhWyTfEuKZZeSv7ekvYQ3cnwZK1JmB5k6ZyiMqNokGsR2wkyK3+gLwz0buC8lzMjomXc5H0ZhpwkXknWbkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9047

T24gMTEvMS8yNSAxMjo0MywgTWlrZSBDaHJpc3RpZSB3cm90ZToNCj4gSWYgd2UgZmFpbCB0byBh
dHRhY2ggdG8gYSBjZ3JvdXAgd2UgYXJlIGxlYWtpbmcgdGhlIGlkLiBUaGlzIGFkZHMNCj4gYSBu
ZXcgZ290byB0byBmcmVlIHRoZSBpZC4NCj4NCj4gRml4ZXM6IDdkOTg5NmU5ZjZkMCAoInZob3N0
OiBSZWludHJvZHVjZSBrdGhyZWFkIEFQSSBhbmQgYWRkIG1vZGUgc2VsZWN0aW9uIikNCj4gU2ln
bmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZTxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+DQoN
Cg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52
aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==

