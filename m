Return-Path: <kvm+bounces-58541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9856EB96705
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE8CF3B4C63
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD602561AB;
	Tue, 23 Sep 2025 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BdVcUy0K"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6582924A063;
	Tue, 23 Sep 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638846; cv=fail; b=pAwIYrPs0qtiDgL4aAMkOabXxrYcaDnDDsoJqWfOhmyNIprfoCxe3iisrC2UyPlsosfueB1Lln2LW2+E86F8P0noLY91KhiGZKxnr2HArcnnjvfVtIvlgRMm8drVnZDpPN7M9P0m0KO6U+ryd9j3zTVSPbfvX+zgxCKBuLw4ppQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638846; c=relaxed/simple;
	bh=E1KZcPf+tssnAt494KK7pRrErwvHGkZUh8erQgPIGpk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=g+BjW3kKBnV67NSVJlJ5nxKAQeNVwwKVJMY1kqA6AwavimiRaXPcqLVGf6Eg1XssufBCY7enlA5xjccscNB+hlcnPto30RW1c2L+lCa+dme5h3jzacTP6s6/U9stP3P2Br9MkF/372JmAQr/6H18FDxkz9oWiimj0nhIHIe0iBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BdVcUy0K; arc=fail smtp.client-ip=52.101.53.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hm8kRW+tjq+v/tj9P24Jfl5RBQXpJ1gv2CAYIMCoxcEqTQmUqNsgYVzFUXYH8AMNHR9eAC0zvw2H59y34PGp0/3MIv6juBAGzT6Sr4mTdYp7+OQ0LrrT6aOXtp5vzSP4j1bioZsUDpWDGbQVVNzKVP/659RP8nRMCcs5gGZVAcdCBfCWMArRnrT3jn6clCxbr28JMdypOEZrVXEd6ocfiAzaXOXLvCfAhmffSK3AJUqSlGs6EgPynVii5UMI/h1F3twUdIKr8POdoAi8HGwpYdjS2DP/0FblSFsukvZTWwaSo6unOrVY2JmToFl7bizkK7NHkErQVBLbF1EEm6wLbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqo8bs2BN2qsn+QmgeLnfPkG9c7PSDESd0r0AifiaHo=;
 b=DTMxHmamDNGt63MNG12WWN1s/27g2/hCK8s/fr3bLURUp1oWVt2u8XnsYEV7pujWPE0Qn89Z/vUf20HOMSGlkkyPKnwt3mf52ydgkk3BqfYdrd/zYg7C/lGqGImhZws+zlOoODjz5cCBWkvlC8OogzllpvnciOeJ3YIDqvj+dD35qboNV1oNEAPdsBBFLChPRCGnOXbGZTaxiRO2b4hGvWIEMwmbvWi1Mbxjb646qsDq4FHdk2HtYjsZ+ujxDc2FbnbgIKVKh44sGu1tMg3nb05L5R5svH9tlpo5T0Ce2T3xBOhjuaBYo5Im9M69DM7B6i8rNvkkoP50i/tZze3lFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqo8bs2BN2qsn+QmgeLnfPkG9c7PSDESd0r0AifiaHo=;
 b=BdVcUy0K7T6KB8Lym+DPnnLeDFA044H9adiR6tD8QrBDVhWGPoMp/LAlETdK7y1JJG158YaKmEbUMDYNUYdgsKJ+3dFFaMKN7Uxf9jbf8LhPq5/Gs87marsJwt8eKCJdBbPWkVw3snwvZQgZSEOTbQv8sQMEbVgXjxMnY8mNB+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB7904.namprd12.prod.outlook.com (2603:10b6:806:320::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 14:47:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 14:47:21 +0000
Message-ID: <10d91fe6-c5b7-fbdb-f956-bce7b2e77221@amd.com>
Date: Tue, 23 Sep 2025 09:47:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-7-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 06/17] KVM: SVM: Implement interrupt injection for
 Secure AVIC
In-Reply-To: <20250923050317.205482-7-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CPYP284CA0042.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:81::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 86d1c680-a737-4d17-cbce-08ddfab019df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlFlRGJieDl3dFBmN3RFaVZqd2x5cTUrSmRTWWVRQmwvemN2SXBmdHNnUFpO?=
 =?utf-8?B?NjVWanRVZXVxODdTalBQYXBGcUl6U1Fmblc4UFRGcHFtV2JvN1NIbFExeTl5?=
 =?utf-8?B?cGRsUmx6bU5pNU9ZWFIxTDhtUElyeVlhMHkxb0wvR0lIM3NFTDFvSXQ5c1Yx?=
 =?utf-8?B?Rk82ejVYZEpiUHFjRFNsYWtTWG1NTm9EempkT2dVbFoyaTh1eUJ0Q1dkVHk4?=
 =?utf-8?B?dTdpMW9id1ExdVdMNWhTTUxNalFkVWJ0QU9BOHVYOVc0YVVCN1AxZlZmRmly?=
 =?utf-8?B?NXJENnB4c2ptVFpFbjBlbVBqQnJTU0kxbUVFOFIxRWkxUi9kN1hiZElidzZK?=
 =?utf-8?B?R05DM3FBK25lSjFGQjlnL1pXM2J5b3hFMVJSSldFSnJHWHNzbko5NUFuNE9F?=
 =?utf-8?B?bW55TGt2QXlpcitaMFhRWnpxRERlV2UyUytDS3ZMdnBHOXVoQWo1b2lOblNJ?=
 =?utf-8?B?SkIyT0FTbXR4QnpIZWM2bWg3S3ZXeE1SdUIyeERhN09LTlRzcHh4NTQ3K2Nj?=
 =?utf-8?B?RGE1am1CWDcrbHRkVGs1M04xTjI0VmFLMFFZUGdIZlF4eUlPOWdEY3UvRTVW?=
 =?utf-8?B?SXBIU05IRUdTUllHR3M3bHJVaFlOOHBYbGdFVjBYWXlsVkIwVGxCTjBiaUg4?=
 =?utf-8?B?NjlHaUtRRU1HMUdpNlArOUJnVTd2azZsZVlPT1lDR2d4anM4VEhETW10TmY1?=
 =?utf-8?B?WCtZR00wSzhENG54ZmRYeFhxeE4yWXZzb2FNYlNkY3ZQMlZaeGwzOWxFdnRO?=
 =?utf-8?B?U2crRkplSUh6YUgvc1Y4Wk5zV1dtUVU3MW1WUkJ0NXh0NWVHMDlFWlBUSXdw?=
 =?utf-8?B?R002OGhkYTBDN0VOSW9idDk4dXZ1MSt4MEJKMWFQb2VpeklhSW1Bb1FRWEt3?=
 =?utf-8?B?SStlR016dFl5T1lQNDlzMFZqSHlCNDRjczVtUlp0bmFxaWJKQ1VjU051RzE5?=
 =?utf-8?B?S0dpSVJIV0ZLalVBcmx3cDdYQ2JkNlFvRkdXRjR2VXAzeUZ5K3FUd25QaThm?=
 =?utf-8?B?OUQ5ckdRUHA1TnBvQWpEZ2hDcGh4bU94SUFHUzM1RGFjOTB3dWJRRTFqVmpa?=
 =?utf-8?B?bmpkeEhCKzFnc3M0cjhjQ3VjTkh5T3BZYkVzbzkwNE5QVm5VV2JScDcwOGpI?=
 =?utf-8?B?Ym8zNGVaMHBGOEJKSTR6cE1UUnpqdng0Rm1KTjZGOGpqS2JZUjNjRDdodWJy?=
 =?utf-8?B?Y1M2UGpuSkdYTnR0YVBXeDVEMFZSQlVLSmNVc0Z4ME9KMmdiQ0Yrc3RQTjgz?=
 =?utf-8?B?SU54TGxMT2Y5SG13N2d1UFdGeVVCTnZvVzhWNjBaTFhFMkpCZEVpaFRsRmlZ?=
 =?utf-8?B?NEo0V1B6ZFBNUCsvSnRCaFF5dmtvWWpFb0NhdVZJY2tDbmYvaWNRRWZhYVZn?=
 =?utf-8?B?eUh1SWhTQnZlL0RGTkU3MFJwZDNkeUxHQ3FFUWRxNzgyNjBLQnhITGxZQ0Y4?=
 =?utf-8?B?bTgwTkVySE0yYmMzeldrVXU3SWpYS1FhSDZNN1p3MFRlKzQ3cDVxLzRUTHVW?=
 =?utf-8?B?enk4bHMwWTdPTHNNRVdYUWJWV0grL1R1aUE3Wm1Id1dKNFhLNHpFQVdjZjR4?=
 =?utf-8?B?VGJGR3hjNDg4WVVjb0U2VENVZ3JuZDVOdWJuMWJZQ1RmbzBZSXZSdk5aSXFq?=
 =?utf-8?B?aHNGa2UrRjg2dzhhS3Rod0lCVGFScFpwbUNhVjZVeTdDNGtDMXdza0tpT2hn?=
 =?utf-8?B?blB3MUdRUmxhR3hMQ3RUUHhMU2xscTM4bTBmSWZ5MHZaMW9jTTVsV3dsb1lT?=
 =?utf-8?B?cXJxaEhMVWtoSkptQzhBQWx5cC9sUFBLRW9SVCtFUE5Md0FhTUtyUnY4OU5S?=
 =?utf-8?B?M1luVkVIMkc2M2tVeXFsTXdOQW55K01DWFZnbWxCa1Q5cjg3ZWx4QzZML0FZ?=
 =?utf-8?B?dHpTbnJwenBQVk40S1NtdTZCRDU4N01qc1Bwd1RPTHF3Yld6U2FSMVM2U3ln?=
 =?utf-8?Q?LhJxilhZfZ4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkZGazBYRktCbFVxa3RvYUh5dTRyNitLcWJQcHVGYlZHV0R5YWN5S2x0ekdT?=
 =?utf-8?B?VnF0TStBK3dIYkJOWUJGUjhhbXNHblptTU80ZWRnN2w5dXdyOUdTeHo2Zm9t?=
 =?utf-8?B?em1CRWhqRmZVNGtyZVN4aTJWZ2tuWWNnTVJIbE00blhCUjZnVFN6UW12cmkx?=
 =?utf-8?B?TW1iaGQ3eStyaERnY0hjNUZJRHdjSnp1U2tWRVBkR3krVVQweDlyMEtsN3Ir?=
 =?utf-8?B?aG8wTzQ1SDJXOXdldjV0eWg5RTV5cTJmTzhvWVV2TFc1VEJxOHVTMVk1Q3Z0?=
 =?utf-8?B?RWxwVXN1TlNmeHJ2VnoxdlcxYTRwYlNEdGRLczE0V0lEMFQvL0R6ZGZKNklG?=
 =?utf-8?B?Nm5Tb05XWXdqZTdmK3IwNzdpQmgyZGI0WWJjS0c0ZjZ4SVlEdDNONjhWV0VE?=
 =?utf-8?B?ZEN1Qjd2dTN1UCtUOEF1RTZkRzBXai9TZXNMbjJaOUVJSWkwcHpQSFAyWTVO?=
 =?utf-8?B?eWlYNzFTUzEwK2ZUaytHU1JCOS9VVWU5aUx5RndKeFEvbDVnTGhDM3NVQ0xj?=
 =?utf-8?B?Sjk1ZUF3UFlZOEx6c2FLV3R2cTFvbXFYRldDZ3Iyb1hBdnArUDdObmYwbzBm?=
 =?utf-8?B?WjVjOVc3ZHdVQmozdE95OUJjN0JtNkt5ZzJOaUI2S1g1ekVmaG1saE40NzJZ?=
 =?utf-8?B?R25tUGxSeG4rMUJwMkw1SXVMcEZ3L0dIK2xkZXl1TEd2VTd2K2p5ZWpTK2Za?=
 =?utf-8?B?SGlMVmRrdFkwaW9rRlRteFhycTNSVTBqVUl2MDYxc3dWM0VrKy9pbk5IdUR2?=
 =?utf-8?B?UnhRYnNqY04zRE5kQ3RjWGVQblZva1ZUdlNZS0VKVnVkM1JNeVZZUlU1UlAw?=
 =?utf-8?B?VllhcFpINUd1a1ozdTVjOG5zWW1yeHhsNHA1TXhnWmx1TDhxS2RJUC9kRUsy?=
 =?utf-8?B?dXJzbGFUYXNnRzZ2Qlg4bmJEYmNEa2I0TGpVYTRTdSsvdWFhYmJIRHZQOUZF?=
 =?utf-8?B?elQvTFdWMG9DL21mbUZYMENsQWNWWmdmMTZQdjNOdHBnTEtZTFAzbXlUNlc3?=
 =?utf-8?B?NXRWYXppSnlxUTZRME56aGw1K2pVS3JGMkZuTkxRR3JVL0JUTzJWeDI5N3Fp?=
 =?utf-8?B?THFaWi9JS1hXeFZxMjFLU3haM2JVSklvcFhSa0NFdW56VDFnK3YxU1NsV1BD?=
 =?utf-8?B?QytFM3hYdWQwL0ZJWnJLakQweDZrdWx1aVhGcUc2elpMOHFZZk9DdDUxZS9s?=
 =?utf-8?B?RE9BYzNjekhjUjQ1eVhEYWFYL0V3NTFaMkxSL0FrZytpWS9TYzBZV2E5MHpk?=
 =?utf-8?B?akdlbXpaaE9rekJzbStHSE9kM1ZTdkthdUFFOHBhMWEyc2lkTU5NMUNEUTFr?=
 =?utf-8?B?QXlzQ0RZK1VmTkFjampSVzQ0ZEZWbGtQQnp3aTlTQVFxcHJrOHdNcE9lRnlt?=
 =?utf-8?B?S1B5bFhFTXRWdGx1czczU3lyNDREVFV3em9nS0tkeis5blhkcjkzdmIrdXF6?=
 =?utf-8?B?VGVNUEloQ1p1TldDQTJickNTUTJSMlByNkZGaUJGdktBcEFIQXVUT1Bab05B?=
 =?utf-8?B?bHdUQ0tWV1Q4MU8zazVTODJqMVRzbmlNTm03bXJaKzM5SlRoL1d0L2NIUjVo?=
 =?utf-8?B?NzM5ZU9SeGxVckRlN2RJM3lwYk9UMU5tYzFNcXpwRTJKaUVEdzQvYmx6OGl5?=
 =?utf-8?B?L1E4WW0zZVRqZFI4a3N1eFBWWG5WT2psWlMyUDdSbGNoOXZaSkJpS25BTXNU?=
 =?utf-8?B?dUczRWRlWGZkUGZSbUsvbWhpNlYxNDcwdDJ6Tmt4d00xbERnTEVacVFQVEFz?=
 =?utf-8?B?eU5OYmpCcXNwOXRZN1Q1VTVGQUtCZS9vMk9vUVlsS1MzbzJsSnRRNHdLODdu?=
 =?utf-8?B?L21mZ0tGMHBrRi9WUkpjTTh2M3E0VXJWS0JDdi9CN29ObE1VVlYzclc4cHli?=
 =?utf-8?B?cEdZZlMxZUlzY21GY2NnNlFCRjhkaVM5ZTd4QlZCN1NuK1VvZjVuSERBUmFB?=
 =?utf-8?B?ODhHL3VzOWJuRmRwUUIya1hLWnQwakpiWWhsd05tYXpGR0J3YWxUdElvMWV1?=
 =?utf-8?B?MS9haERjSzVFUTBpTTJwSUpQTTV0bVpyRUJOa0diZTd2ZWtpT09PM2Z2NG0r?=
 =?utf-8?B?cHBtNUdtLzJzQVo1N1plNldZZ1g4NTlRZExJR3k1ejVUUGFibWxjRHJTLzNt?=
 =?utf-8?Q?yilg8DpxCwqb5BnYma0J1HHA4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d1c680-a737-4d17-cbce-08ddfab019df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 14:47:21.3815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P85EJGLvjSdqeO5YbWObtMLGmUvhwlW5DCxI/PGwy+GqGnXKD7RLlBaWRqhVzSk4DgaTtLJBHxOzHFjZTl7ChA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7904

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> For AMD SEV-SNP guests with Secure AVIC, the virtual APIC state is
> not visible to KVM and managed by the hardware. This renders the
> traditional interrupt injection mechanism, which directly modifies
> guest state, unusable. Instead, interrupt delivery must be mediated
> through a new interface in the VMCB. Implement support for this
> mechanism.
> 
> First, new VMCB control fields, requested_irr and update_irr, are
> defined to allow KVM to communicate pending interrupts to the hardware
> before VMRUN.
> 
> Hook the core interrupt injection path, svm_inject_irq(). Instead of
> injecting directly, transfer pending interrupts from KVM's software
> IRR to the new requested_irr VMCB field and delegate final delivery
> to the hardware.
> 
> Since the hardware is now responsible for the timing and delivery of
> interrupts to the guest (including managing the guest's RFLAGS.IF and
> vAPIC state), bypass the standard KVM interrupt window checks in
> svm_interrupt_allowed() and svm_enable_irq_window(). Similarly, interrupt
> re-injection is handled by the hardware and requires no explicit KVM
> involvement.
> 
> Finally, update the logic for detecting pending interrupts. Add the
> vendor op, protected_apic_has_interrupt(), to check only KVM's software
> vAPIC IRR state.
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  8 +++++--
>  arch/x86/kvm/lapic.c       | 17 ++++++++++++---
>  arch/x86/kvm/svm/sev.c     | 44 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c     | 13 +++++++++++
>  arch/x86/kvm/svm/svm.h     |  4 ++++
>  arch/x86/kvm/x86.c         | 15 ++++++++++++-
>  6 files changed, 95 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index ab3d55654c77..0faf262f9f9f 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -162,10 +162,14 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 vmsa_pa;		/* Used for an SEV-ES guest */
>  	u8 reserved_8[16];
>  	u16 bus_lock_counter;		/* Offset 0x120 */
> -	u8 reserved_9[22];
> +	u8 reserved_9[18];
> +	u8 update_irr;			/* Offset 0x134 */

The APM has this as a 4 byte field.

> +	u8 reserved_10[3];
>  	u64 allowed_sev_features;	/* Offset 0x138 */
>  	u64 guest_sev_features;		/* Offset 0x140 */
> -	u8 reserved_10[664];
> +	u8 reserved_11[8];
> +	u32 requested_irr[8];		/* Offset 0x150 */
> +	u8 reserved_12[624];
>  	/*
>  	 * Offset 0x3e0, 32 bytes reserved
>  	 * for use by hypervisor/software.
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5fc437341e03..3199c7c6db05 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2938,11 +2938,22 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  	if (!kvm_apic_present(vcpu))
>  		return -1;
>  
> -	if (apic->guest_apic_protected)
> +	if (!apic->guest_apic_protected) {
> +		__apic_update_ppr(apic, &ppr);
> +		return apic_has_interrupt_for_ppr(apic, ppr);
> +	}
> +
> +	if (!apic->prot_apic_intr_inject)
>  		return -1;
>  
> -	__apic_update_ppr(apic, &ppr);
> -	return apic_has_interrupt_for_ppr(apic, ppr);
> +	/*
> +	 * For guest-protected virtual APIC, hardware manages the virtual
> +	 * PPR and interrupt delivery to the guest. So, checking the KVM
> +	 * managed virtual APIC's APIC_IRR state for any pending vectors
> +	 * is the only thing required here.
> +	 */
> +	return apic_search_irr(apic);

Just a though, but I wonder if this would look cleaner by doing:

	if (apic->guest_apic_protected) {
		if (!apic->prot_apic_intr_inject)
			return -1;

		/*
		 * For guest-protected ...
		 */
		return apic_search_irr(apic);
	}

	__apic_update_ppr(apic, &ppr);
	return apic_has_interrupt_for_ppr(apic, ppr);

> +
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index afe4127a1918..78cefc14a2ee 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -28,6 +28,7 @@
>  #include <asm/debugreg.h>
>  #include <asm/msr.h>
>  #include <asm/sev.h>
> +#include <asm/apic.h>
>  
>  #include "mmu.h"
>  #include "x86.h"
> @@ -35,6 +36,7 @@
>  #include "svm_ops.h"
>  #include "cpuid.h"
>  #include "trace.h"
> +#include "lapic.h"
>  
>  #define GHCB_VERSION_MAX	2ULL
>  #define GHCB_VERSION_DEFAULT	2ULL
> @@ -5064,3 +5066,45 @@ void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
>  
>  	free_page((unsigned long)vmsa);
>  }
> +
> +void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
> +{
> +	unsigned int i, vec, vec_pos, vec_start;
> +	struct kvm_lapic *apic;
> +	bool has_interrupts;
> +	u32 val;
> +
> +	/* Secure AVIC HW takes care of re-injection */
> +	if (reinjected)
> +		return;
> +
> +	apic = svm->vcpu.arch.apic;
> +	has_interrupts = false;
> +
> +	for (i = 0; i < ARRAY_SIZE(svm->vmcb->control.requested_irr); i++) {
> +		val = apic_get_reg(apic->regs, APIC_IRR + i * 0x10);
> +		if (!val)
> +			continue;

Add a blank line here.

> +		has_interrupts = true;
> +		svm->vmcb->control.requested_irr[i] |= val;

Add a blank line here.

> +		vec_start = i * 32;

Move this line to just below the comment.

> +		/*
> +		 * Clear each vector one by one to avoid race with concurrent
> +		 * APIC_IRR updates from the deliver_interrupt() path.
> +		 */
> +		do {
> +			vec_pos = __ffs(val);
> +			vec = vec_start + vec_pos;
> +			apic_clear_vector(vec, apic->regs + APIC_IRR);
> +			val = val & ~BIT(vec_pos);
> +		} while (val);

Would the following be cleaner?

for_each_set_bit(vec_pos, &val, 32)
	apic_clear_vector(vec_start + vec_pos, apic->regs + APIC_IRR);

Might have to make "val" an unsigned long, though, and not sure how that
affects OR'ing it into requested_irr.

> +	}
> +
> +	if (has_interrupts)
> +		svm->vmcb->control.update_irr |= BIT(0);
> +}
> +
> +bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_apic_has_interrupt(vcpu) != -1;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 064ec98d7e67..7811a87bc111 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -52,6 +52,8 @@
>  #include "svm.h"
>  #include "svm_ops.h"
>  
> +#include "lapic.h"

Is this include really needed?

> +
>  #include "kvm_onhyperv.h"
>  #include "svm_onhyperv.h"
>  
> @@ -3689,6 +3691,9 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 type;
>  
> +	if (sev_savic_active(vcpu->kvm))
> +		return sev_savic_set_requested_irr(svm, reinjected);
> +
>  	if (vcpu->arch.interrupt.soft) {
>  		if (svm_update_soft_interrupt_rip(vcpu))
>  			return;
> @@ -3870,6 +3875,9 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (sev_savic_active(vcpu->kvm))
> +		return 1;

Maybe just add a comment above this about why you always return 1 for
Secure AVIC.

> +
>  	if (svm->nested.nested_run_pending)
>  		return -EBUSY;
>  
> @@ -3890,6 +3898,9 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (sev_savic_active(vcpu->kvm))
> +		return;

Ditto here on the comment.

> +
>  	/*
>  	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
>  	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
> @@ -5132,6 +5143,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,
>  	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
>  
> +	.protected_apic_has_interrupt = sev_savic_has_pending_interrupt,
> +
>  	.get_exit_info = svm_get_exit_info,
>  	.get_entry_info = svm_get_entry_info,
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 1090a48adeda..60dc424d62c4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -873,6 +873,8 @@ static inline bool sev_savic_active(struct kvm *kvm)
>  {
>  	return to_kvm_sev_info(kvm)->vmsa_features & SVM_SEV_FEAT_SECURE_AVIC;
>  }
> +void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected);
> +bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -910,6 +912,8 @@ static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
>  	return NULL;
>  }
>  static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
> +static inline void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected) {}
> +static inline bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu) { return false; }
>  #endif
>  
>  /* vmenter.S */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 33fba801b205..65ebdc6deb92 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10369,7 +10369,20 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>  		if (r < 0)
>  			goto out;
>  		if (r) {
> -			int irq = kvm_cpu_get_interrupt(vcpu);
> +			int irq;
> +
> +			/*
> +			 * Do not ack the interrupt here for guest-protected VAPIC
> +			 * which requires interrupt injection to the guest.

Maybe a bit more detail about why you don't want to do the ACK?

Thanks,
Tom

> +			 *
> +			 * ->inject_irq reads the KVM's VAPIC's APIC_IRR state and
> +			 * clears it.
> +			 */
> +			if (vcpu->arch.apic->guest_apic_protected &&
> +			    vcpu->arch.apic->prot_apic_intr_inject)
> +				irq = kvm_apic_has_interrupt(vcpu);
> +			else
> +				irq = kvm_cpu_get_interrupt(vcpu);
>  
>  			if (!WARN_ON_ONCE(irq == -1)) {
>  				kvm_queue_interrupt(vcpu, irq, false);

