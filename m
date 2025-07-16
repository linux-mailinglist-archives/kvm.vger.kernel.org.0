Return-Path: <kvm+bounces-52604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D39B2B07209
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAAD1189650F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54FD29E119;
	Wed, 16 Jul 2025 09:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YUgD2xOv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441262F19B4;
	Wed, 16 Jul 2025 09:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752658945; cv=fail; b=trDBVx5vBKRjoe25DlcMyF1nWOtDthzModc7s+fn6CjtnU0lza5SJmixUM1Di12HmspeNxjs2VoZmFnMK+EGsQJgjkgrZhVPx72DpPiBCmLtKitoEb2Xb5gP0wVh2Kf1SLEU2/7owA86nsRaEtmh2rzq8gzJtMGZGx5LDou7eQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752658945; c=relaxed/simple;
	bh=TSx/UcfHU6e2eZBhQVrI3JvsHxPFvBL+CbSW0Yjd9E8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kFcXebdzMWvegsRTA3J3NnWSkANN4bPTLMwMzJtacJpftf+oVsZpHMUZoavKzXBVnzEPjsU6L7VlbCPLmqLYJVZSl/Ce98EIA1uSLWygTMIxcbTtTH8chOblwvOZG1tPsPZOEdBAyqO/Q4XKPu4P1olfgjc1Vz6ZuWcLQLTOkJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YUgD2xOv; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gc82R/i4toSZUSCCgvIDITQEKivil6OL35BhSzEU3K+MorWLbchThTT3cbVoJK5R31zD6i7nWbAt9XhtshsBxkleKgXMqMV2cRqkIdCPXw8hC6niP1Duqvm4IVCYJihnT0nfkKyRN3Ba4IG27O1KXQOJnP9Zm65pJFvUE646cekIi7YePnIhhAqT6R0cB+JFJIN4hicO2GHmLbtmWQ8I+r/uG2r1lt7sEcWhbxSA9DY1EVmY4szCrt21ENoolrTv+sEAkgMyhqpG6w8n0CoONrhXPnhDAhem0RALOktLoHLBynFIvQLpRoRz0I2NGIPD1R23uwBsQdUZKo1KJoGgKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhZtEibwT34769n4uat2IW8Ku4X2kmuYgRxg1GIe4+s=;
 b=csaow/1PfBWfXDV/V49FJ19n0YTpHdhdEZogqWZIs0f+Mz3ts+61pOjDuPVDl13cdswm6Y4J7S3JEYmjwiWAn6KvPdv0+JpNqZyL4Wr8Hkq856fYaqusKUxQ1HNmPTqfCAQ/hniKRyngYcIWlDzhAPIwMKAZoCZrHoiBAkiZVPxDtDXXBGMl/70KWXmNw9TteGvuwxxj5Tfq113R7w+kB6ypGt6gBLFFeMP2nvm9nPBdm+NT4U7GasMSXPn5X2jchYtnvjS9R3g27QOKhPUlwRg1T1C0ZUGgtl6o0dVJLdCPN2eDqwgeezJMhK8jdxmxwNAI5vIg4rAiVk1ZZrkWjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhZtEibwT34769n4uat2IW8Ku4X2kmuYgRxg1GIe4+s=;
 b=YUgD2xOvvF66BNZXcoOuo1+WIvc9StfD7+RFuzrj7Uom/06HqfJ/8K3p6Cst39Q0J0i+W/RvIvXglcAaHPo/kfAJPwNhyr6FcgF8plJcTIJJNFJg+kRjpSaKHhUZ7pmSur94st9zqM0iUcJIMNcdK0WoHEMTk+6wssh0NQxkXNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS4PR12MB9564.namprd12.prod.outlook.com (2603:10b6:8:27e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.36; Wed, 16 Jul 2025 09:42:21 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.035; Wed, 16 Jul 2025
 09:42:20 +0000
Message-ID: <7db3a4b2-dff6-4391-a642-b4c374646ca7@amd.com>
Date: Wed, 16 Jul 2025 15:12:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] iommu/amd: Reuse device table for kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ae::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS4PR12MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5ff05d-80dc-4670-01f0-08ddc44d0f57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0ZLSjkrcjRTeVpMbEFHRzFzQW01VE4vZjk5bUh0TzFjSjNESk9ocDZrblBQ?=
 =?utf-8?B?dUlQS0xZRUd5dTlBRGNET05rTFgzSzBrOVpHK2ZKVW9tMnRvMXVsVUZUSVoz?=
 =?utf-8?B?Rk9FSnFoUnpKa0dqU1VkeGhiNzFKMldQNFBHUjlKdStkUVBSZ255dEg1aC9D?=
 =?utf-8?B?c3Btb04zaXljTzdXalJpblRkaloxMTNUN3ZVZ0RaN2w2UXd5UUczV0JkbEcr?=
 =?utf-8?B?ZVR5WEhYYzBQeTF1UmZUK2VNTnJWbWFzaDhTNGZ0WFhkMlN2eWVQZDlRRWMz?=
 =?utf-8?B?L2FUdW5tcjZrMENCa0oxcm9xa2gyZGt5c0U0cE9jWXZkKzVZaktza2c5MHNI?=
 =?utf-8?B?by9LRGU1NTM2YlI0aW82VnlvK0tsWTVRSjUxbkhzT041WWRnR2xrN1gyancr?=
 =?utf-8?B?a3lKQjE2Tm5QZ21YZUNxWUVxQjVMaXI3MjdQVWovSUVZR0hIT0tjS1VvREhv?=
 =?utf-8?B?TmQ5UmQ0WmQyaUFhUXgyRVFpTGVrV0lLNlRaZGhBbm56cUF2blhmMHVBV3I2?=
 =?utf-8?B?WWRhajI2VXBURi9YeFFKQ2NWbjhyOERLdnlCeEVUTVAxQ1F4VEtub3NyTmVz?=
 =?utf-8?B?VXBsdGNBYWZkQThwSzBQeUFCZFU0Z1oxTkZ3QnJCR3lNN0YxWEVuczl4c0lE?=
 =?utf-8?B?TjlPOWdLdXFRQjJwY1VIRVRXSnV3Y0p2QTNHSThIRStpYU9TRithbkdKQWFt?=
 =?utf-8?B?Vk45M0ZqM05DRkQwUHhPd3BsSWhUY3NpMWg0QUpYK2NuMzZVVE5DaVB5bTR0?=
 =?utf-8?B?dnFSRVJXMkZzd2JER1d3S1dnQjZ6MlJwUVBiNG1LRFhUWTZaaDBuSU9PRk9p?=
 =?utf-8?B?THRGbkcxWkM3Y1RnR2hSOTF6b1VtZFc5eDkxQlFNYVpBYlBlTEs2VjFmL00v?=
 =?utf-8?B?eUExajFHNWN0bm9sdTB3TFlKRXRsSEhwMnZXd2hCM0tlcjIwWFB4OStjTGhz?=
 =?utf-8?B?NjdCWGZ1bXRYL0dBL21mVllTdXI0RmdvS04xeWp4WnhBWTlzVGJqbEU4YXdG?=
 =?utf-8?B?Vm1zS1BjM2tsSmtxNUs0cFltRi9tQWd0WHpWaVNTSjBwc2ZYNjcwd1BXY1ht?=
 =?utf-8?B?cXE2R3k4eWtQT2dNeHFBWEVpaUJUaS9BSjNqZytCTmFhZ2xYZHhxN0hvbXhK?=
 =?utf-8?B?Wk8yWW1qWlg5LzNBN283aFBaOHBiZFhaSVMyRlZwdWJIUXg3RzJieFM1YVVP?=
 =?utf-8?B?OFZKZXk0UHVNeVJVTWxVWUVwT2h2VWRaYUdoZEhWZkNpeWxBMFhIODVBa0Vk?=
 =?utf-8?B?YXBDdm5EOW1xMmx2UUhsMTBnMnA0aXFOZjVHeER0ODB3NGlib2R3czhhMURN?=
 =?utf-8?B?ay95a0tSeFRDbWlmVzFmZ0FiVWJ5c1hTb1lBSnRSc3p6M0dQTTNYVWdOL0tD?=
 =?utf-8?B?RTlGU1prWWtNWTdQVkVGRWVFbHJ4aHRnaE9yNnFlQXVURXRYOU5VUHd2MUdn?=
 =?utf-8?B?WitsOFJUcGZ2ODQ1Nm92THFvWW45ZXVzd3k5NTViT3hsV3dJVUJUZUltSHhn?=
 =?utf-8?B?WE5Qb1FjSGY4Y3RZeXBqUms0S2MvZzZZTkZsUjBUNGVKeDVadlduUnNDdVhC?=
 =?utf-8?B?bTNlRGtZYkVoYndOTXhuSjB5VWdxZHJmZkphRUV4YWhUYzB6R1VqWXNrKzc1?=
 =?utf-8?B?YmcwYm9qOEpsSURkRUFrZVFpYVN6bS9jZThISkluZ01DVHFiVVVGek1jWWNI?=
 =?utf-8?B?ZVNadlY3a2s2ZzN3bk5pemNyM1dVTUk4V0Q4SUdzdE43YVFxZXpKRDBoQlZu?=
 =?utf-8?B?dEdMYk1sZzhCcFhzeUZIdS8zeVZYYnhiZmdIOXBVL1dRQks1WTF2SFdOL293?=
 =?utf-8?B?T1ZCeXduUk9Ca3dmMzQ5b3pUVVlqZmNvbFhBQW01WjNjc0tQeGQvVTRJUU1B?=
 =?utf-8?B?M1YzVXFjTit3QWpBeXRBK2FvTzJBeDJjZnBReTdaY29MaytYUTVkR2xsOFVG?=
 =?utf-8?Q?4L32LqQaR6c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG5od09mSEpkVmtwbzBRWnRQNHcrY2FrTzluNHpHSHBwTnQzaDJpMTNlZ1ZH?=
 =?utf-8?B?NjVneDRDaGM4eExQbmYydFlheHY4ZXgxbUNWT2ZvdDE3Rmw5VTZaQ24rUi9k?=
 =?utf-8?B?NkJIdkg3bjM5YkhwS0MzL0d1UVl6ZUQxbk5aL3Jna0tydERpNEhITHVwZlJ4?=
 =?utf-8?B?NHZmK1dmNG8wNElRcmJRTkZqR1l3OXBncEpveSt6bHloZnJ1cWNkanQ1MWF5?=
 =?utf-8?B?dW1jWVh2djI3ZVVmazdIZUlwd3p0dGR0VGswRW5MM3N6Tk9GVjBtZFNna3k0?=
 =?utf-8?B?YU56b3NxcmprV2NEOG45aFowTkE3OUUxMUhzbGpjbU9KOFlCNnlJRHVnOWdZ?=
 =?utf-8?B?dWsxTlE0K3B6bjA1THZJMlVNVGVrbzB6c0lkYm5lK0plMUJQOVJmdFZ5ZmNj?=
 =?utf-8?B?TVR0b285c25Sb1ZNWnpiNUVTL0pWK3luU1N3bnBnYWZGREtMQ2JWeEJZSUd3?=
 =?utf-8?B?QTlNL2JPTWhxVk1vck00aU9rVXZOb0YxV05NQTIreFJhWnB4VjFLS0JGWUIw?=
 =?utf-8?B?ZXdhdGwyT1BhaHVjeHRNYzhobitySTM4VFQ2cllkV2x4bWVaSElvZThlbXFV?=
 =?utf-8?B?UmxGZmwwUmtEaklsenNjUmpxVHgvSDkyQTR3SS9XVUsrekc2ZVpleXViTUpW?=
 =?utf-8?B?Q3dPM0xYbkxmcERCR3poZXUwNzMyV2NGZTF4U0xCeFhGRVprcXVCRHFESktK?=
 =?utf-8?B?d2xiWmMwQXdPU1cwUkhQWVBXUjVjSWQxeHRCcW1heVpudFdLYmVoOE11d2FW?=
 =?utf-8?B?ZkdmNTk1L0k3SHNocENEaVdqb1JybmJWYVZiMmluN2h5dG5Fc2RXb3pzUmNE?=
 =?utf-8?B?bDRsVnF5WUVOWmpCdlgrVlgxSDhZenN5Vm1WOU8zcWp6am8xckxIK05xemxj?=
 =?utf-8?B?cU9TMUkyb2U0dUcrTmdrTExhK2tyOGw4blVrVzNRYlI1dkVaUlh5emJzMXVs?=
 =?utf-8?B?SE1ZN2lyMjA4dzVzQVpHdll1ZkFFTlhzNkF1U25ib1Y5SE4vYkZHbm5JNTZj?=
 =?utf-8?B?MGVwM1FsNjQzZFFvdEVEcUd4M2tJZTlWSGpQekpxT2d6SjJHUGlTNWpMdVZC?=
 =?utf-8?B?bzhJaHM4aUU5clZ0NDhyVkRpWUl4bzZnZTh6dk9zMWowRFVuUjFRT045RmJi?=
 =?utf-8?B?M0dvYTUrb2hYOHN4VW5EK0dEMW96QzlnMXo1ZUZweDNFUHJVV2NndVpkWHZG?=
 =?utf-8?B?WEs0eFEwWXRTSTVnVGNXRHJYc3laRzRxenZxR01RRWV4cE9pNXZldkdxNmtE?=
 =?utf-8?B?U2R1Z3hTZ3hmTjdUb1BDMDlRQ1F5TWcwRkphM1RCWkpCcW51dVlSSWdnb2di?=
 =?utf-8?B?aEZtQ0w2N3RsZDVTN0RVbWk1MmdDdzd0enFPek9CL2VBMGFIdnEzdEkrRnA1?=
 =?utf-8?B?VldQaWFSbHBMYjNKZjdiNEJob0hOa0tBOEkyWk9pd0NtSG1DWjgzclZQQVRt?=
 =?utf-8?B?cnV3ZXV4Zy9ZR005d1dScFJxamlKWmFXRUxDTlV4c3B6MVQzWVB3cy9rSDRX?=
 =?utf-8?B?YkFqOEdEaDJvQ1QwSUVqVnUvd0k5UkFPZjhaTU1MQlFJa0RxZkNFUE5FZmZP?=
 =?utf-8?B?NnVFeEo1cEppWFNyMlg4YndiSHZmZjZMcjRzOC9OMjYrdDlFMUhGNGJyYXQ5?=
 =?utf-8?B?SnVvalRMcXpLU2hycmdIaUU2TFBqNFZ5ZjF0QVByMVV0bytyVXJMVW9Zc0ZW?=
 =?utf-8?B?WXVZMkxucXpjQkt4Z1JoV3dRMHQ3UzgzRHk3VVlSZTJyczcrcGdScDl5YWxa?=
 =?utf-8?B?Y0cvNTJFNG5jYXZQcmtRbUMrQTlHcFMvYU01NTNRVnM5LzBLMDZ2Sk5RZWdR?=
 =?utf-8?B?YlNiOEhtditpYWVsU0Mva1VTRWkyVTcvRU90aEg3Nms5RHd6YXBiZkZodUQx?=
 =?utf-8?B?RGJUdE9vMklzQmhOYTl4MWdveHBxMlhMV0xrS2N4aDYyU1U2Q05WZWR4Ulor?=
 =?utf-8?B?bEJGNHhFUGUrc3o5MTRDMlZBeUUrL2lrblhJZjllblRkSEovallZNFpTYU9J?=
 =?utf-8?B?aUg5TEw3Y1I0WEl4VUx3MFgxbndMWVJnZWpmaDR6T050aGF1VjVXeEZSWFpm?=
 =?utf-8?B?VzBBL3BEZEdQd1Vub2t6bE5pd2lkWDJlckZlTzZIOWxzUmNPNXRBRENnYVEz?=
 =?utf-8?Q?FcR8SpRwT4iQ3jpoY9JcUqLnV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5ff05d-80dc-4670-01f0-08ddc44d0f57
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 09:42:20.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEbhK50yBT0YHJP5ohcO0ws7QWrd/bzv9JOiWhSvd2IUSuNiLj8qKIhELa0d2FGkuP1raSNT93JeLWRgqtE1zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9564



On 7/16/2025 12:57 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU device table register is locked and exclusive to the previous
> kernel. Attempts to copy old device table from the previous kernel
> fails in kdump kernel as hardware ignores writes to the locked device
> table base address register as per AMD IOMMU spec Section 2.12.2.1.
> 
> This results in repeated "Completion-Wait loop timed out" errors and a
> second kernel panic: "Kernel panic - not syncing: timer doesn't work
> through Interrupt-remapped IO-APIC".
> 
> Reuse device table instead of copying device table in case of kdump
> boot and remove all copying device table code.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/iommu/amd/init.c | 97 ++++++++++++----------------------------
>  1 file changed, 28 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 32295f26be1b..18bd869a82d9 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
>  
>  	BUG_ON(iommu->mmio_base == NULL);
>  
> +	if (is_kdump_kernel())

This is fine.. but its becoming too many places with kdump check! I don't know
what is the better way here.
Is it worth to keep it like this -OR- add say iommu ops that way during init we
check is_kdump_kernel() and adjust the ops ?

@Joerg, any preference?


> +		return;
> +
>  	entry = iommu_virt_to_phys(dev_table);
>  	entry |= (dev_table_size >> 12) - 1;
>  	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
> @@ -646,7 +649,10 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
>  
>  static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
>  {
> -	iommu_free_pages(pci_seg->dev_table);
> +	if (is_kdump_kernel())
> +		memunmap((void *)pci_seg->dev_table);
> +	else
> +		iommu_free_pages(pci_seg->dev_table);
>  	pci_seg->dev_table = NULL;
>  }
>  
> @@ -1128,15 +1134,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
>  	dte->data[i] |= (1UL << _bit);
>  }
>  
> -static bool __copy_device_table(struct amd_iommu *iommu)
> +static bool __reuse_device_table(struct amd_iommu *iommu)
>  {
> -	u64 int_ctl, int_tab_len, entry = 0;
>  	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
> -	struct dev_table_entry *old_devtb = NULL;
> -	u32 lo, hi, devid, old_devtb_size;
> +	u32 lo, hi, old_devtb_size;
>  	phys_addr_t old_devtb_phys;
> -	u16 dom_id, dte_v, irq_v;
> -	u64 tmp;
> +	u64 entry;
>  
>  	/* Each IOMMU use separate device table with the same size */
>  	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
> @@ -1161,66 +1164,22 @@ static bool __copy_device_table(struct amd_iommu *iommu)
>  		pr_err("The address of old device table is above 4G, not trustworthy!\n");
>  		return false;
>  	}
> -	old_devtb = (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && is_kdump_kernel())
> -		    ? (__force void *)ioremap_encrypted(old_devtb_phys,
> -							pci_seg->dev_table_size)
> -		    : memremap(old_devtb_phys, pci_seg->dev_table_size, MEMREMAP_WB);
> -
> -	if (!old_devtb)
> -		return false;
>  
> -	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
> -		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
> +	/*
> +	 * IOMMU Device Table Base Address MMIO register is locked
> +	 * if SNP is enabled during kdump, reuse the previous kernel's
> +	 * device table.
> +	 */
> +	pci_seg->old_dev_tbl_cpy = iommu_memremap(old_devtb_phys, pci_seg->dev_table_size);
>  	if (pci_seg->old_dev_tbl_cpy == NULL) {
> -		pr_err("Failed to allocate memory for copying old device table!\n");
> -		memunmap(old_devtb);
> +		pr_err("Failed to remap memory for reusing old device table!\n");
>  		return false;
>  	}
>  
> -	for (devid = 0; devid <= pci_seg->last_bdf; ++devid) {
> -		pci_seg->old_dev_tbl_cpy[devid] = old_devtb[devid];
> -		dom_id = old_devtb[devid].data[1] & DEV_DOMID_MASK;
> -		dte_v = old_devtb[devid].data[0] & DTE_FLAG_V;
> -
> -		if (dte_v && dom_id) {
> -			pci_seg->old_dev_tbl_cpy[devid].data[0] = old_devtb[devid].data[0];
> -			pci_seg->old_dev_tbl_cpy[devid].data[1] = old_devtb[devid].data[1];
> -			/* Reserve the Domain IDs used by previous kernel */
> -			if (ida_alloc_range(&pdom_ids, dom_id, dom_id, GFP_ATOMIC) != dom_id) {
> -				pr_err("Failed to reserve domain ID 0x%x\n", dom_id);
> -				memunmap(old_devtb);
> -				return false;
> -			}
> -			/* If gcr3 table existed, mask it out */
> -			if (old_devtb[devid].data[0] & DTE_FLAG_GV) {
> -				tmp = (DTE_GCR3_30_15 | DTE_GCR3_51_31);
> -				pci_seg->old_dev_tbl_cpy[devid].data[1] &= ~tmp;
> -				tmp = (DTE_GCR3_14_12 | DTE_FLAG_GV);
> -				pci_seg->old_dev_tbl_cpy[devid].data[0] &= ~tmp;
> -			}
> -		}
> -
> -		irq_v = old_devtb[devid].data[2] & DTE_IRQ_REMAP_ENABLE;
> -		int_ctl = old_devtb[devid].data[2] & DTE_IRQ_REMAP_INTCTL_MASK;
> -		int_tab_len = old_devtb[devid].data[2] & DTE_INTTABLEN_MASK;
> -		if (irq_v && (int_ctl || int_tab_len)) {
> -			if ((int_ctl != DTE_IRQ_REMAP_INTCTL) ||
> -			    (int_tab_len != DTE_INTTABLEN_512 &&
> -			     int_tab_len != DTE_INTTABLEN_2K)) {
> -				pr_err("Wrong old irq remapping flag: %#x\n", devid);
> -				memunmap(old_devtb);
> -				return false;
> -			}
> -
> -			pci_seg->old_dev_tbl_cpy[devid].data[2] = old_devtb[devid].data[2];
> -		}
> -	}
> -	memunmap(old_devtb);
> -
>  	return true;
>  }
>  
> -static bool copy_device_table(void)
> +static bool reuse_device_table(void)
>  {
>  	struct amd_iommu *iommu;
>  	struct amd_iommu_pci_seg *pci_seg;
> @@ -1228,17 +1187,17 @@ static bool copy_device_table(void)
>  	if (!amd_iommu_pre_enabled)
>  		return false;
>  
> -	pr_warn("Translation is already enabled - trying to copy translation structures\n");
> +	pr_warn("Translation is already enabled - trying to reuse translation structures\n");
>  
>  	/*
>  	 * All IOMMUs within PCI segment shares common device table.
> -	 * Hence copy device table only once per PCI segment.
> +	 * Hence reuse device table only once per PCI segment.
>  	 */
>  	for_each_pci_segment(pci_seg) {
>  		for_each_iommu(iommu) {
>  			if (pci_seg->id != iommu->pci_seg->id)
>  				continue;
> -			if (!__copy_device_table(iommu))
> +			if (!__reuse_device_table(iommu))
>  				return false;
>  			break;
>  		}
> @@ -2917,8 +2876,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
>   * This function finally enables all IOMMUs found in the system after
>   * they have been initialized.
>   *
> - * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
> - * the old content of device table entries. Not this case or copy failed,
> + * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
> + * the old content of device table entries. Not this case or reuse failed,
>   * just continue as normal kernel does.
>   */
>  static void early_enable_iommus(void)
> @@ -2926,18 +2885,18 @@ static void early_enable_iommus(void)
>  	struct amd_iommu *iommu;
>  	struct amd_iommu_pci_seg *pci_seg;
>  
> -	if (!copy_device_table()) {
> +	if (!reuse_device_table()) {

Hmmm. What happens if SNP enabled and reuse_device_table() couldn't setup
previous DTE?
In non-SNP case it works fine as we can rebuild new DTE. But in SNP case we
should fail the kdump right?

-Vasant



