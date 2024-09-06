Return-Path: <kvm+bounces-25976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABB896E845
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 05:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C08C1F24CD7
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 03:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546F14437A;
	Fri,  6 Sep 2024 03:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HRgX3v1Q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9801EB35;
	Fri,  6 Sep 2024 03:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725593522; cv=fail; b=GmXzUUDDMankCocG1X8dcIHjtzngeI2/qYJexwoy1qGGz5jS2oCpVc5AzKlS9ikkN7D8haj3CejRxUyKdqx4XYDpggWpg4v/qbDyfFlgVkpI8XAZEUbMhG2bwYaSnTQ3RSCUmU8rW+o0BMkcwsoKETmq9Rjo/xoqxtzEyk+4PY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725593522; c=relaxed/simple;
	bh=8VQJrUNUx2faCHSb3E/bf0Q3xX+jpZ6qXYcOaqgqitM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WIeRz2YYiAUwwJaz7f6vmrDjKJ8m77BFmALJFz1TFSgDJqS51DTySM7Cb3JMzgcGA/VbQ8WMIc6lDGby/xpAy6xetkslPQfHZrPpsK3KVwv+p0f1KVOD2qina0q15fR7FMGurpB4CxnK53//EDzNYqXwCTAS78TPBXcgFv3TaaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HRgX3v1Q; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJnVwZtlRHHGRG/04/BH/c8yVaSHK24pMDmr2s3rJ7Sr4XErML2U9l5ADcTfEL5EluHpvGUShL0WS2f8O40APVYw2yJ2PA/sWQrg9pCa2B/yIuQjDwy56tc4BEi9o3dnSgj2ojr6w7Um6GX0WNbjfw9qqlVsrJgc5sNNWj5YKc5F4uDeOHoywAPHIZO8yPEDfOZ6K0N8YZ1a569Y6Pt2ZxL2KyJhPwm1+z7y3mEqb4HBO/wFQvLJioIjxGmMYPNTWeQJ/Er2EoIvfWyDSppke+iSXzzHOVTMgPfILwDYUVElHWIcv03DzRtZ0nCizCLjCwOnxiIz7+6Sglb816EyNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWu3OP32ap+zraEA65yYpW39+ncv9zYG+yGEPjIIhbk=;
 b=Gr/N12xl1e7axUKD+p6+v/Rf3CVgWHwmpDhSn2V8zlzgf1FaydTM1aCVeJ+fvpxWwCRHESskoPDKVZPz4PYyb9BhMSI/J0oeXLrjHFau9ktRGpKDXUP8ZOG5RhjCXtMpADCt1ZQK2QG9ifFJBesXeO8xi5iY/7slVH8W3mnNuVX1lRgcfu1GEkuBdFOTA6WUUolKtGPI3wkzKQXgovpWGSZBYAtnjveJxXL+05V2l9VwTrOHUE2AG0BzR+idWEPpRlj+oREHv5gsoSLFklQ5xovePO2TuTnB/r0E6ZQT2nWA6sRv0xZ7ZD+gDGnIK5m7UVTo/6KqzYaYq2S+pxz0eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWu3OP32ap+zraEA65yYpW39+ncv9zYG+yGEPjIIhbk=;
 b=HRgX3v1QKxG2gD7ix8/qlPmK+k7BcIdy5qhbJhnU8ppNs0NhgnHtWNX41tXbyGaYTg1aV91O8S+J0ss/HQySyzAHhqyDbkSaeCMv2o25RKwJd3Wojh135jYzvLGKwoQeW15vWn2xHILVPLX+WxqzxfzFEeXmNwUR5uDkBRdT3sE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB5831.namprd12.prod.outlook.com (2603:10b6:510:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 03:31:57 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 03:31:57 +0000
Message-ID: <262bee4e-7e60-45e6-8920-ec6b8dd0a526@amd.com>
Date: Fri, 6 Sep 2024 13:31:48 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 13/21] KVM: X86: Handle private MMIO as shared
Content-Language: en-US
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-14-aik@amd.com>
 <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
 <49226b61-e7d3-477f-980b-30567eb4d069@amd.com>
 <Ztaa3TpDLKrEY0Ys@yilunxu-OptiPlex-7050>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Ztaa3TpDLKrEY0Ys@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY2PR01CA0021.ausprd01.prod.outlook.com
 (2603:10c6:1:14::33) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: c435b7bf-753b-4a68-d372-08dcce2475d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1VMbVB5UHlEZEkyclo1cGV4WXNnQXcwN24rT2NoZWE5V3docGVFaXVldmx5?=
 =?utf-8?B?SmVZZmg0Vm9ZN1hhczFVMDd1U3FNUURzeEVESnRlTG0yOUtpamlVdW9Memth?=
 =?utf-8?B?RGhrYXh6TW9PaURPV1hzRGpocTN1L2YyWWtyVmZVMm04SHIxTnF1Y1A4ZVM1?=
 =?utf-8?B?VjFVaE9Ubmx4V0tRWTM3YUFUNThvalZNTUVGMjhzQS9xaDkvejFiM3d5OGFJ?=
 =?utf-8?B?YitoSGVZYUNzbkwwRGVZV2loODNzRmxvSkt2ZU41d3Z4azdiV0VHb2xSV2No?=
 =?utf-8?B?ZjMxaDltSG82c01BZVNrRGFtWVppSGhnenM3eGZsek04T3dHQngvdjQ0SzVE?=
 =?utf-8?B?UEJBSW80T3FEdlg2LzlZM0t0K0VpSGp5b29mM3Y4MlE0ZnNaT3ozZ3k4aTdU?=
 =?utf-8?B?TThaamRpNit6ZDlPUVI3WnAzNFFtNlF4Q2VVZUxVSERUaUZBQ2t0YUh1bXAx?=
 =?utf-8?B?K1NiSVB0UVY0QitYMDZ1aDh0cVZTUjFvRFRSSlh4eDQ3NXpzcDIzMVRBdlF5?=
 =?utf-8?B?cEJVZVpyNjJybjJKTlNpZTJTdG9GOFpzd01OL3RMQ3RwWVRObEtzMFI0aU4y?=
 =?utf-8?B?VE5QN1JXakUvbWh4U21SU09WWkVCUmdyaHA2UjNkc1NhZVhyVFFtL3QyaTZH?=
 =?utf-8?B?eUNybkUwU2ZtYkJ5TWtUSWYvZHplTE9JSDZOWTF3dmFZVEQwYXduai9HUXlI?=
 =?utf-8?B?UFlYMkdjZDFxM0FiaU44KzBDV1VGV1Y1S3hSUkloZHhQb2xLQ2F3amtnU1dE?=
 =?utf-8?B?VkZHOFkxdlZEeXVjSlRTM1czc29ockt1RGNVMzl3Mk91dXFGMzZNeWg1S2tQ?=
 =?utf-8?B?d3lsNnFwaEF1M2dnUWNaU3BEVUdDTmt0dGM2TG1NWkZKMWhOdWNPSklueXYy?=
 =?utf-8?B?NXRtc1BpWkJDRjgyajFOWFMrUml1SzA1ZWxwNFpNcE8rWk50b3V3TzBjZzlD?=
 =?utf-8?B?dGV5Y3FTV1ZOQVA5OHdCSnBlRlhIai9TdkdMRUNBWkoxRjhTUmpySFdFRURq?=
 =?utf-8?B?SFdNU0ZkMmxZS3AzRUFXMDFoaUp3Y0VIUlgwM0lSWjI4SExtWXVwRUFIWlUy?=
 =?utf-8?B?M2NQQXQwaW9LY2c2LzU5MUswcEpVbUdJREd2U2hBZVE5RU5FbUpjVWxmazBw?=
 =?utf-8?B?OEt3ZlByTVo1Ny9IaWFOTVAzMjFYSEFudXl1TU1aMXZXTXhsbHBQVFl6ZHpZ?=
 =?utf-8?B?Q1BZNXJsNXAvbWY1NmdRQ0RscEM3blZFUHN3dUZiajlCS1BDeXpKZDVxRldC?=
 =?utf-8?B?NHZpWGxFaUdkaEE5eFA5c0o4QkRzTnJxMFN6NHpLZUJRS0xrN1JMQmN6b2hy?=
 =?utf-8?B?RUN6aXc5MzVMZ3ZVSmxuY0lDUGdOZFdIQmlaTlFkcHN3QnY5UGUwQ1Q2RUlm?=
 =?utf-8?B?aWljVXZOSENZaXlaS0hKQWFZQlppMmM1VVVPNnlGSGZFSWgxcGtieWpKdC9o?=
 =?utf-8?B?RmQvenJUMmVPL0lNRERHSVNoQ3JJUUtjT3BvVDVMSnUyc1VmYmRwM2hpYUpp?=
 =?utf-8?B?V05vbWdNbW4wV056RklyaTB4TUMrRm9RV0VySVJFaFhoSGNZMXRRVkNqaTBw?=
 =?utf-8?B?dHdEcGtLdWczUzNwQ2ZNQ3FzNjV1eWVjU3Mxc0NBL2I0eWVOUitrNTBqSlJL?=
 =?utf-8?B?TURnSTFJb2JJZjQyREEwT0ZmS0w2enhNdGdjMnFkSTR1akVEKzJQSXc0Vkxy?=
 =?utf-8?B?dHgrRHFsdHNURGtkU0l2QStzNHNoVlhIVUlCb0Z5OVkvRDNTYU5RZ003dmFG?=
 =?utf-8?B?U2F2OThNdDRoMDBiMWttbkNHcHk1Njh1QVZkaUNPa2dpait6c2hVYkF1RTEr?=
 =?utf-8?B?Q2FVVHJlNlZJUXhBL3Fwdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTMyQW1XNmMxelQrY0pSR3pnaU5maGZ4MVROcUxFdGlLZTZKQmVveHFSWVJP?=
 =?utf-8?B?R0lFUkh1SGUxVkxtMGFYQlc3SU9zQVlVRFE3Z283QlhQY2REUjhHZHdMSkhu?=
 =?utf-8?B?aVNRL0FhVUlOUE9BU2d4YXZ4ZlJVdFA0VkNWMU1EZVpvVms4dmlMMnRmd0Qz?=
 =?utf-8?B?UHBLR3c3Umc1VVFQTUxKR0hqUWxTUjBJeGZDNzBQOGdMaFgvdkhUcjlUNXNZ?=
 =?utf-8?B?SHM5eFc0aUk1bnNSemNWbDVKV1BnMDEyNzMxMnZMRGVHSW9OaTd4QVZtTUVh?=
 =?utf-8?B?YTZxOFltOVZvZXpkNWpRT2JTREluV2s1TVp1dC8xWHN5QXlVbmU5TnFSMmZi?=
 =?utf-8?B?SnRFK2E1NTFoTk9va1M1YkU4c3NuQUd6cjNaU2UxUzczZzkzZ0JlaEpjZEJ2?=
 =?utf-8?B?NVVONmlWYk9nUnMrNXNQekw0d25KN3Q5bWZJbWRxaEp2enJjeDFGWHV6YTcr?=
 =?utf-8?B?WVJhMzNtd05JSENCTVp5WmxaS3pTM1NoeTQ5YWFkMUdFcFU4SmF3NGVzZlAv?=
 =?utf-8?B?UTQrSHpvMkVaamxNRHQzRjM1Rk12VjZpc0lKWDJxclA0anFyckFmT1JQMHN5?=
 =?utf-8?B?ZzFhUEk1YWlTQUZRVUVzYjJLbHBBOVFNL1NlRlVEMFVJUHJpRzIyZy8wZFZx?=
 =?utf-8?B?UzZIMWZqR2JFRksxQkRISU9tWjRDeHM1TGpTTExxM3hDL0RSY0VaTDhUWkE0?=
 =?utf-8?B?d0VuVzdRbDB4anMzNnFLM3dRdnQxN3ZwbTJ3dThxcno4cE1USmRPQjlXTEwv?=
 =?utf-8?B?VS9BSW0zWVlzRk5hSDFDcDcwREtpQlFyUmJwc0hzQ0ZLVDBEZ0xZVGJZWnhn?=
 =?utf-8?B?NEV6L21WUEoyN0dRcG1nNDlSRzhNdm9KZ3ZJaHorOGtKUTV1REZFbFpVZG9X?=
 =?utf-8?B?cEtjbW11cW1Za3Rva0w1NGFPVk9jM3B1V2lYQzNVaXFQYU5kcTlwVC94c1lU?=
 =?utf-8?B?WlB4S29jc3h2d25Eb3pITWtQcG5hYm5mb2tQQ2NJTlVqSkNIaEZLeHZ5MFhT?=
 =?utf-8?B?R0RZK0dPYUI4SFBZanFkMi85bDUxd0UvOXZCOGxtNHVLeVlBZE9FVG1jZjc5?=
 =?utf-8?B?VUdDeFFZRm1TRnlUVjNQejRTRUMyYWNFSXpUWEtIWWk4VTNleFRCSUlNMHo4?=
 =?utf-8?B?Rlk0cVh6ZzFzRzB3YWRacDF6VkorYWhwQzFZQ3pwaTNpTy9Xb21pQnFVcjdJ?=
 =?utf-8?B?NGh3QU52b0xsUzlCdVVLVTZoaEpvdGg1SjZmdVBNVzhXTVpibHZJc0pzQ1l1?=
 =?utf-8?B?bXgrVDRtMzkwUCtpNWRPeC9kTGNwcE9KVGVLWWxkK0U5VFlOWHBSTkE5RS9L?=
 =?utf-8?B?WHh1aTN2S1JORmZZRzhnVXQ2QkFtN3QwS29rNkJBTGM3cy9PYmJ2ajJqVEVY?=
 =?utf-8?B?R2NEQ0xFRkVEY0srM0JPM0hmK0sxSjVVN2w0L3dpN3Erdk9LNzVHQnVLWmI1?=
 =?utf-8?B?dG9saUhmSkZsSmpsZFV6ZWtzRnFmVkxSMysxeG5zM0lHNVdMakVTQ0Z5ZDNR?=
 =?utf-8?B?RFpvb3RnWkVHS01DMkZyUGxNVE11VndEV3MwOFNNOStuWFlua3g1ZWdUMXMr?=
 =?utf-8?B?cVIrWDN3MWlGN0tDaHNSNGZUTWpCZ0hDVWJDK0NpQTVldVpHMk1UY05jbkdY?=
 =?utf-8?B?N29XekgxaktSb3ZMc2tiaXYvVWdtZEd4c0tMN2ZMd3FTMi92SnVEYS9CWkUv?=
 =?utf-8?B?UVhCem1oZEdkSU5WYmx5RlA1UVQvcGVWYlZ5Y0RsVVhCVXR3VHJ4YzZCK1JO?=
 =?utf-8?B?MVpVODdEblRpaGloRVRCRFR5eTRWVkEvb2Z4Szlla0w0MFNlVzh5QmY1UXFF?=
 =?utf-8?B?SktPUTAwU3VUSHlpdS82WldtMi9iKzRYYlZMZjlvWGM2U1JMWVJQYTNQZkEx?=
 =?utf-8?B?Vjd2U0x5dnozM1lKck5XT2s5azBPTURheUQwS3JsUmVBRVNPTlJrRVQ3VWww?=
 =?utf-8?B?RW52RVA2eUpDRUlhckk0dVJXZmhhd2pOYTJhNm9nZkp3bkw3WEVPM0VDNnl3?=
 =?utf-8?B?TFhMYzl5Z1grcFU0Z29teEFrZmp5YWdwYU9GekhLajhmcWhBQ0dvTGlmZ0Qw?=
 =?utf-8?B?dkZBeHZHN09nMjEzZzhRNmo0RUZIczRmRUd2dlZITG1FTzVUbk9EaVJqQjRx?=
 =?utf-8?Q?WcoofOs15UmcuZzO+1RT7EsL6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c435b7bf-753b-4a68-d372-08dcce2475d2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 03:31:57.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYB5J0fWSX/jOxPqqIgpsBSyya4ik9qJLupDeZkdgcrTf7ECEAh1BkJQibxSUZO8UV0be/jJoq2hY8ZW1viQfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5831



On 3/9/24 15:13, Xu Yilun wrote:
> On Mon, Sep 02, 2024 at 12:22:56PM +1000, Alexey Kardashevskiy wrote:
>>
>>
>> On 31/8/24 02:57, Xu Yilun wrote:
>>> On Fri, Aug 23, 2024 at 11:21:27PM +1000, Alexey Kardashevskiy wrote:
>>>> Currently private MMIO nested page faults are not expected so when such
>>>> fault occurs, KVM tries moving the faulted page from private to shared
>>>> which is not going to work as private MMIO is not backed by memfd.
>>>>
>>>> Handle private MMIO as shared: skip page state change and memfd
>>>
>>> This means host keeps the mapping for private MMIO, which is different
>>> from private memory. Not sure if it is expected, and I want to get
>>> some directions here.
>>
>> There is no other translation table on AMD though, the same NPT. The
> 
> Sorry for not being clear, when I say "host mapping" I mean host
> userspace mapping (host CR3 mapping). By using guest_memfd, there is no
> host CR3 mapping for private memory. I'm wondering if we could keep host
> CR3 mapping for private MMIO.
> >> security is enforced by the RMP table. A device says "bar#x is 
private" so
>> the host + firmware ensure the each corresponding RMP entry is "assigned" +
>> "validated" and has a correct IDE stream ID and ASID, and the VM's kernel
>> maps it with the Cbit set.
>>
>>>   From HW perspective, private MMIO is not intended to be accessed by
>>> host, but the consequence may varies. According to TDISP spec 11.2,
>>> my understanding is private device (known as TDI) should reject the
>>> TLP and transition to TDISP ERROR state. But no further error
>>> reporting or logging is mandated. So the impact to the host system
>>> is specific to each device. In my test environment, an AER
>>> NonFatalErr is reported and nothing more, much better than host
>>> accessing private memory.
>>
>> afair I get an non-fatal RMP fault so the device does not even notice.
>>
>>> On SW side, my concern is how to deal with mmu_notifier. In theory, if
>>> we get pfn from hva we should follow the userspace mapping change. But
>>> that makes no sense. Especially for TDX TEE-IO, private MMIO mapping
>>> in SEPT cannot be changed or invalidated as long as TDI is running.
>>
>>> Another concern may be specific for TDX TEE-IO. Allowing both userspace
>>> mapping and SEPT mapping may be safe for private MMIO, but on
>>> KVM_SET_USER_MEMORY_REGION2,  KVM cannot actually tell if a userspace
>>> addr is really for private MMIO. I.e. user could provide shared memory
>>> addr to KVM but declare it is for private MMIO. The shared memory then
>>> could be mapped in SEPT and cause problem.
>>
>> I am missing lots of context here. When you are starting a guest with a
>> passed through device, until the TDISP machinery transitions the TDI into
>> RUN, this TDI's MMIO is shared and mapped everywhere. And after
> 
> Yes, that's the situation nowadays. I think if we need to eliminate
> host CR3 mapping for private MMIO, a simple way is we don't allow host
> CR3 mapping at the first place, even for shared pass through. It is
> doable cause:
> 
>   1. IIUC, host CR3 mapping for assigned MMIO is only used for pfn
>      finding, i.e. host doesn't really (or shouldn't?) access them.

Well, the host userspace might also want to access MMIO via mmap'ed 
region if it is, say, DPDK.

>   2. The hint from guest_memfd shows KVM doesn't have to rely on host
>      CR3 mapping to find pfn.

True.

>> transitioning to RUN you move mappings from EPT to SEPT?
> 
> Mostly correct, TDX move mapping from EPT to SEPT after LOCKED and
> right before RUN.
> 
>>
>>> So personally I prefer no host mapping for private MMIO.
>>
>> Nah, cannot skip this step on AMD. Thanks,
> 
> Not sure if we are on the same page.

With the above explanation, we are.

> I assume from HW perspective, host
> CR3 mapping is not necessary for NPT/RMP build?

Yeah, the hw does not require that afaik. But the existing code 
continues working for AMD, and I am guessing it is still true for your 
case too, right? Unless the host userspace tries accessing the private 
MMIO and some horrible stuff happens? Thanks,


> Thanks,
> Yilun
> 
>>
>>
>>>
>>> Thanks,
>>> Yilun
>>>
>>>> page state tracking.
>>>>
>>>> The MMIO KVM memory slot is still marked as shared as the guest can
>>>> access it as private or shared so marking the MMIO slot as private
>>>> is not going to help.
>>>>
>>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>>> ---
>>>>    arch/x86/kvm/mmu/mmu.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>> index 928cf84778b0..e74f5c3d0821 100644
>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>> @@ -4366,7 +4366,11 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>>>>    {
>>>>    	bool async;
>>>> -	if (fault->is_private)
>>>> +	if (fault->slot && fault->is_private && !kvm_slot_can_be_private(fault->slot) &&
>>>> +	    (vcpu->kvm->arch.vm_type == KVM_X86_SNP_VM))
>>>> +		pr_warn("%s: private SEV TIO MMIO fault for fault->gfn=%llx\n",
>>>> +			__func__, fault->gfn);
>>>> +	else if (fault->is_private)
>>>>    		return kvm_faultin_pfn_private(vcpu, fault);
>>>>    	async = false;
>>>> -- 
>>>> 2.45.2
>>>>
>>>>
>>
>> -- 
>> Alexey
>>

-- 
Alexey


