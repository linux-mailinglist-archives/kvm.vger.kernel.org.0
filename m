Return-Path: <kvm+bounces-24323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53399953971
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A92A1C23289
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B3857CBC;
	Thu, 15 Aug 2024 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IX0Mn7RY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491A554BD4
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723744165; cv=fail; b=mxEaP22C0v2i6rCxOrgaGIKu158gKY62XSNmgairGaB/jU44EVq/8gHnX/wKvdtfLJJHlEQjQeSlbOTeGLvd3K6cxvibYCo6EBGmEO25d8YvcxmZ9QkZZtttCBux7gS6mxyKDXRepRND4FycvGEhHK6owdXWs9hCF0ACWR3dcqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723744165; c=relaxed/simple;
	bh=8b8ZzfK2iX2LyjT7UNaC1J1RI9nLA2Vb8FqT576XQXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cyJ1Q6eHqaFDE8aK+Y5vQFLm5ZlLUNEIKgAn4wjqmA80tu9YsG7imp7VSIPxRqz9aPH1A1I6MALTOkkUN+C7NKulpl+v1CFzUEIcAFkBkT9VFTyRU0fp+fA+HPcJSL4yV4EcJiK8rFE4yfgoOeXY2G5R2RP0z4kt83/4JSdm+3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IX0Mn7RY; arc=fail smtp.client-ip=40.107.96.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txJroQ8yRYTFwl8AuZUtig3h1F6ymRmt8RIvkAhSn5ZIYvyyiYMGnQXngL/BK2+11VwyMoJA8D0fkQoQhKVwAouv2RYlC1nXRZBP3qAHENtFBXlJJCGLDmseu7ruDkhmMd/Yde90hnhRZAigOPmM7bGoi1aktYviNOU81KpcpMaPDKSJPmF18w0LLcx0zHZye787RiB2+OYyz6RQ8BGV1uosprEBsV4FNpfYLN4IJ8GmVPrr+K7KqnQbr8sHop7OvvYdxlh2fz5hcoER6g9TkO6zNdCk2QADh9d9htlUVWNjf3xk7Rrni+YTWCpYecZLTW1ykrHtFRu2SMagmaJ/ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k67lYAopvIumO5uCyJ8yyBq7Mo1DfiW4ttWYsVyuAVo=;
 b=YLdL/T9GFwnMATnNRySVh1d4WpoPF3FmsBFA/+OOaCoZywxR5xLCpfJ2yaGjRWuEcOt4BibC3wkWxomCUCPV69VXppAfsHgj/X7zo+RnoHED6Obv4m8vQ7DH1weFYmBNddAjbvjNiMju8RxTOXbtssQaT0B9fNkDcrTKk6Na8wj3mTc+z8pgOBTb1W8CnARTdFuE/3cWdVMg9Q/Ljx97x0fYNztmAwQu4uEsn30jfVd5Kbp4DWSNDOrQghGbLCA26JPIbU7GsTIq2vScIXsdmT7Td9D0DE5phw8xIxQcQvQwPxH1E+bVBNNxTXHGYcZr58SPxBmCFsRiER38tsZi8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k67lYAopvIumO5uCyJ8yyBq7Mo1DfiW4ttWYsVyuAVo=;
 b=IX0Mn7RYPvx8Lr6RTwNj0ccQE8cF5QYLRVOVWiCIIMTphkG6dU7i1OA7WzGrlyz0ScNdbYyHIGhnQCLFK5aKc3vSmOG/tZL3S9mSnHyjgsW0TfJNITqUtmZJRvjHGUW0Tsr1+VDmH7W7Uh0fhtw7oeRoj9JlDZOy939K6lRVmwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB8829.namprd12.prod.outlook.com (2603:10b6:a03:4d0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19; Thu, 15 Aug 2024 17:49:19 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 17:49:19 +0000
Message-ID: <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
Date: Thu, 15 Aug 2024 23:19:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com, robin.murphy@arm.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 iommu@lists.linux.dev
References: <20240628085538.47049-1-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017E.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::4e) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB8829:EE_
X-MS-Office365-Filtering-Correlation-Id: d946e1f7-bda5-4ebd-759a-08dcbd52965c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0J4dVJYMVQ2MW9pdGcwRHZwWVU2cFV5bXR6c0JTc1hqa2tyTHJvMkdhdmR0?=
 =?utf-8?B?MWxnUk9nd29vSDJyWUs5dkUrR01lSS80V3g5TEtkN3NZSUpJMTF5THRVN3NH?=
 =?utf-8?B?NG4vajZNNzlTN1k4dWtqSFViOTd4ajJpb1ZBWXNlb0ZQMnA4eUtRa1JLbUs1?=
 =?utf-8?B?Zk5Uem00dElaM002REd1ZWVSMFJPNWdCblNIOTdSTHQvUi9tZ0N1T1NobzFk?=
 =?utf-8?B?VzA5NXUzZjRGU1pLZnFTQlozUytrT1FaZCtIcHJwNU9rOStSajZETnAyZ0ds?=
 =?utf-8?B?L0lFaVZMYTAxaG0yR2JEeFAyK21LZjZlVGM0QTZtK3ZvU25hWUNMSFBLOFRY?=
 =?utf-8?B?cWlyVHhYTmtIMTlKZ0EvT0wwSUV1Y09wa3ZnQTJlY01WY1VTOU0wRkVUeVZy?=
 =?utf-8?B?eXFqTnRkbWFONTF2ZDRzV1V5c0JjUFhPOEgvK2hKdHV3cmFnRmFUSlJKZysy?=
 =?utf-8?B?eU5pVXNHa0oxSCtuaFVGWEorYVN3KzlNSFZWZDNGWlAyVXZJZklZMENJd3l0?=
 =?utf-8?B?bTlZVkFuREFVenpXR25lYjNJY01iQ1FCd0ZYMjVEdEJkQTRCN0NzL2Y4bUND?=
 =?utf-8?B?cUdHMEVVbnBWRnorb3Jwanp6TzVjbVhEMnNpeHhJK3lBNUhCWlRUREZDcklH?=
 =?utf-8?B?MDZVSFg0QkVxZXB0WUtlNWJUaTFVTXRRS0VyY09HaHhuYjdqYi9qNmx1dk9V?=
 =?utf-8?B?QXp2UGlVdmFRZ2ViQjAyMUtkVVprVjFOaEU5eXVseGgraUV3aXpRanBPVmhq?=
 =?utf-8?B?Q1BlNlY3TkJsR1NadFZYb3N5Y0R4aCs0NmJoOW81dWJhTzRlTG5xN3FRTDRP?=
 =?utf-8?B?WW5ySXZ3Tm12TXRTMUJobHFob3lacXpobFJ2TnZKdnp3dDNacHZqeUVZMzhw?=
 =?utf-8?B?ZjVlVy9BcFc2dWJwNWxsZ3RWVjRldkNoSzFETFQyaCtrZ20yelV3TURuazRn?=
 =?utf-8?B?S1NZWktlMU1CS3BrM0RYZVJpN0thT2FtUDNNV2YzdHlRZ3FPbXNWNFNmdlNo?=
 =?utf-8?B?OGxNZElhU2xTN2ZsSS9rVnIzZTZ2RmVqMFJ6djE2bjZHNDlnUVhzUDMzSFR0?=
 =?utf-8?B?QWJ1QklUVjJ6Ry9tdmpkeHk5Vms1SDRuQnI3ckdFWGY2QlJLQnFPUGJMREox?=
 =?utf-8?B?U0dhaGEwTHJEdlFlUlZjakJ6K29hckxEb0Y0Z3M1d2RlQ3U4UWtYZytNbFJJ?=
 =?utf-8?B?czd4cjRCSWs1bE4vVzhJaFBKdUQ3c2hGZVJQQklmNC9ySXE5ZVloMEQ2S01P?=
 =?utf-8?B?YjQvd2hHaHQxZnZxcDcyakcrclN5SGJtVWxqRkRSbVFlZnEzeHFXaU9vR2dm?=
 =?utf-8?B?WkduMm9zd3hIUzluTE80VHEvakp4ZloraFVqbVJlWWF4Rzh0b0ZNMDEyZ1pk?=
 =?utf-8?B?UVlMSTMxMU1pd09Ca1FEd29IenU2TmJkSVlUcmJ6RUpuNWhBbFZ1Z0hYR2Rq?=
 =?utf-8?B?a2wzWWpIU3czamIxWElKY1dXRlBsdjFFdWYxT0pEMjc4ZzA0bU9xdGVnYWds?=
 =?utf-8?B?SWNaWW5ud0c4ZjYrMUtPOUpLd2FNcUtZNGpFVlNOYkErYkh3L3BWbDh6ZFdl?=
 =?utf-8?B?R3Q3SkFUT1NCMVVaMHJXUS82ZnN0eGlac1BOem1DUlRIc2ZJNG9uNkRSNUwv?=
 =?utf-8?B?K3hqUkJZcmdNblQ3cDI2eTVBczIybDdMejN3eEtWeTI2V2MwYk44aUR1YnBC?=
 =?utf-8?B?clBFVUJHZ3A3Zmx2ai8rcGFld0FZdFI3R0VFTDB3dlNLdk44TVB2RzUxZ2xY?=
 =?utf-8?B?RDZyaWRrQ3JKc2NrWDhaRXlYNUZXQzRYVG54TzRpL29JcGxTNWN4NTB6LzVt?=
 =?utf-8?B?bG9KUGhVblYvMXVsSnowdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekRGa2lsNHJHTWtaM3pNSWpEUEUxWGJ5UFNMMEdqdDA5QWRNZDFXSjJvR0JV?=
 =?utf-8?B?WUtsc1FrWEdhN3RjT1pyem92RWNUQUxoL2QzRFk0TUZ0dEh6ZkZXTC9vZHFa?=
 =?utf-8?B?UFNQUFNvNEVoVGdld1d1Zm52clFzU2ptRmVKMUI1UktkSVdaa2tMMTlwbTJM?=
 =?utf-8?B?dTg0QjlvZFUvNG82bG1GRmFoRHBBMjlFdnI0Z20wTDh2ZUtsTG0yYWU2enlh?=
 =?utf-8?B?TWNVZnh2SGRMVjlUT2hGemJKZXBaS05YUnZxYWoxR1Vxc2hTbytFb3NzN2VQ?=
 =?utf-8?B?MjJQbGpsS2E5RUhiMnU3cjdEYVhhczhaeUdEaDhERWxvVnQyOXNKQ0Zqc2RL?=
 =?utf-8?B?Vi9YZ2Y4UUlRRXhMV1lGeVlvOWZIb0JCVGJxV09xZnlnakJ6ZUlBWTRHYXd1?=
 =?utf-8?B?enpjZ2xBZjllRUhubnd3QmdtRE5qUmI2NnFiVStFL2luRTRqYzlUNG1xZFdn?=
 =?utf-8?B?dEdBSjN4SGlrTUhCTGRzcEd0RjlJWUxpdGMyYlhLSk0xRStRMTJWTm1HL3hT?=
 =?utf-8?B?WlROOFRZR3hBYlNoNzhnMTdDeldmelJ5OVV1MHY5MlZmR3JTRTh3ckRjREVB?=
 =?utf-8?B?MitaOUpuOFJvSUk2WmFuTnljYzU2TElIcjVlRGg1YU9XN240WWxGSWc1T25k?=
 =?utf-8?B?K09oOHJhWWRGK0w0T0UxRW85VVRqa3o2Wm00ak9sVDZpT1J3VlZKMGhCQ3Fx?=
 =?utf-8?B?N01ZVmVNWVNid1BHeFhxUWlGR2pDQ0lQbi9zd3lqNFhFOUc4dVBLN1pTTFJl?=
 =?utf-8?B?ZnRiQWUxMEZwUE82NENDWlR3SWxwSVdLWGdIdi85WlJyOXZtVHhGaWRXWWdE?=
 =?utf-8?B?RTVLQXpWVWdSTXd0Z3QrckNub0FiMjRhQ0p0dlEzNElEaXcxSUxWUzlRYmI1?=
 =?utf-8?B?Ry95T3RCclFQQ0dtSTZVd0JhZXBadDh4V1p0ZCtPMFg2eng0UXZHV0p0b3FT?=
 =?utf-8?B?eXYvTUdQZnNOYzhDZGN2VzR1ZjQ0SzhSS0NzSVJyaWx0TW5qRkR0dXA0cUFI?=
 =?utf-8?B?UmdWRzRqQzUyNXZEWEg5L1d3RSs5MEdENGliUktYQWtBN1FZWVR0bm5TOGZL?=
 =?utf-8?B?ZGwvNTBJY3pXRWNYb0g1Rkx5K0IxNFJhSmNsRUFQNVJhUjYvMnJYdGRyc2Nr?=
 =?utf-8?B?amE2QkJRSU1yblVWNHcyb2pxNUNPcVRmWHZIR21NU21NWFEwWm1UUEdqUFRN?=
 =?utf-8?B?bUVtdkF3L2E0YkRTcmRtLzJMR1pva053bVdpY3RXYk5TS1F3dWpVTDgwZ1I5?=
 =?utf-8?B?bEp3eXFkTlJHMjNob2tnRVE5YjVYd0NDYWpBTnFZZ2d3L25QUVd3ZTlOaFhK?=
 =?utf-8?B?Q2tBL1RENVFMRDRhYUF0d2RnMWJsTEdmeklJMVRiRkFjWW53aHVDUUFRMFBG?=
 =?utf-8?B?WFQydm9oblZqUzVkRzFuQU5IaTRrYm5iNmF6dmJjOHgvZ1Bxb25LdXhQMHJ5?=
 =?utf-8?B?K2MrZFJJeGczTFFreDlTMnltUjVLem9HS052T3BwSldZR3NXV2NXQnpaQkt3?=
 =?utf-8?B?R1ZpT3RZYi9rNlN5NHp2UXpSR0hwVjJhalorS3hUa0w4WWxVNE5pQ2hrWWxt?=
 =?utf-8?B?SGdMZmlrQkZhVmZzQXFqamN0eEZMS3piTldEWVVtcmpnVDhCSktNZVNLYU56?=
 =?utf-8?B?bnovTVFkeUlyUm5nWDJMYVJNT01aWU85blc1dTVhenovZ1o4enl5eHlDZ3hD?=
 =?utf-8?B?V1VQSVR0S2hGc09lRnlNT1p4OXdoQVgrSS9DVlVId1d1eXRwVUlLRE8vMjJ2?=
 =?utf-8?B?Wk5TL0duN3ZyNFhlYkpLZlpML3pwU3hvVVZVTlFad090eHd3OXJOQm9lekta?=
 =?utf-8?B?S3FtaVpEZWk5S25Bc2tGSXpHYVQ4YzNYbm4wRitDeE9WbUc3N0hwZHR4QXFP?=
 =?utf-8?B?cXN3UjA4MkU1WmxLTnc2YXloNndlYVg4ZDVnYlZZR3VrOExNQ1dyajNuT0Mv?=
 =?utf-8?B?QzB1bFFBMUgrd3NrL093Kzk2dVpsc2FCTmhPd1JXRjJvVWovVzAvTGRtcHQ3?=
 =?utf-8?B?WTZic2V0cklVbjZ0aC9YcllYeU5ZN2xISC9VeUFNS0IyZWxXaDcwa2RFVUEy?=
 =?utf-8?B?cnFtM0VyZkVUVDVLMnpPcnBoYWc3bkJSTnhzdEhieXdyeDBwbFFBV3BoWjh0?=
 =?utf-8?Q?qPO8JMKWTXUl6lYhFDaigpSuH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d946e1f7-bda5-4ebd-759a-08dcbd52965c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 17:49:19.1034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bw/gXgm80Jwm5QzeLItuicH9iMMoHt/RO2mC08XHQutSBrRK0x4ZDLDoqhvn84smywuQvadi0Rmr904xf+p5Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8829

Hi All,

On 6/28/2024 2:25 PM, Yi Liu wrote:
> This splits the preparation works of the iommu and the Intel iommu driver
> out from the iommufd pasid attach/replace series. [1]
> 
> To support domain replacement, the definition of the set_dev_pasid op
> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> should be extended as well to suit the new definition.

IIUC this will remove PASID from old SVA domain and attaches to new SVA domain.
(basically attaching same dev/PASID to different process). Is that the correct?

So the expectation is replace existing PASID from PASID table only if old_domain
is passed. Otherwise sev_dev_pasid() should throw an error right?

-Vasant


