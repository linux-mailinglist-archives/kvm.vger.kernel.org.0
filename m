Return-Path: <kvm+bounces-34490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 238369FFAA9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97D757A18E7
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57B31B4241;
	Thu,  2 Jan 2025 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BNnFmmOL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C5E1B4151;
	Thu,  2 Jan 2025 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735829891; cv=fail; b=ZdCEdwvIWcJBatvIJRsPCFELl3eE15zkH1o1I+XNkL6Gu51Z9GL5d63dSw2RgNibh/WozvTYEPlC2lmYI5BZoMDjvpcwo5lLHlb/oHj1itNrQOFYdicYHZda21JDCQrFufX33bdHyiN6PRM9MG8sYsT8tCPsfBC/fxyO1LKDMUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735829891; c=relaxed/simple;
	bh=YCXaw3OSt+9GpFM9+JnHhaD3uveoWrUNeaW7ObMOjFY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gA0WVkNqp9ZkilHKGaiA0MBFfMkIzteL9Veg2JvmwFpWZ2bKP6i1B3dg1+tJIi9EBFJaYRFQnBTdrovpz65FYri2Av0170IoDcRfCNhD+GI1V35a6Q1k4dbuyE4/4KDDsiAxBstztrBvcqqp/F69OqClSRp0TUfCsauy1+E52uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BNnFmmOL; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJQ58ZmDQva8G1juK9H3cRj7iqcrpVj9f6LDvw9BNOArdIVu1ye+LyQXTUuNBq7E3VcKjDBzyk6gPJDLkI+bvk9NNi2pGrYC0OGs8ciK3R9M0ExxILrJvtPuuwqS1W/I1HJRdHbCJGmzINHtsvUxqIMMl4/AIqz1W12fYQTtEbkUy7oSGSY7zMIH4DEAUNYgfbFowCzUD3PzlE+8yvZSkRusajmfapTMO3QeyYfe+OaUlkW4ks+oovUACtLcaGbYGu1xVxwzaLvRT1sfd1K2FEqX+KaSv0jWyMz0v6RVwVv46FGduBqmtOZb8ajFmrsEwR5xIid3ArAVxVfxXXf0Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PjqyGz4iLqYrYqbNbgu0dmpNmIBJLyF4nnsAYpW7hg=;
 b=JZcJelbjFS1ZJWk7aAV8JwxLKJQGf2QOS0SHnwfyEOx3VTYcFaX8XifSZp0LszVu6kEk+oFZjn5QJtEIvCQhoRYH03990a1e2lQbUCWxuzXYSEsVn258ocgUgiQnLZMEM9Cb0oeWEVmkdBLJuluAw+yKM+70GIDBb0ML5mJmw5zMNak6/eVnjBKsmOW250alG7TzkpbHjD9bw3A+BR8+UBLJ7z8Qe5y+p2Wyt0prRTG5qFYtFkjZ8ySsDKxFvTI+2FFm2g2VqoUyj/UlQAdxHmZNa8AlRRMCisAfZlMtR5CuTVNBbz4MGTveUfjNkGtVNfES2tPIXy2kubduDH6i1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PjqyGz4iLqYrYqbNbgu0dmpNmIBJLyF4nnsAYpW7hg=;
 b=BNnFmmOLStYe4ka769IFnEhYNIn7QGaXdWN8sZvQaJj9FdJWgakM/73HN0k2i/aJeGYftzME7GHCzAOWp1gGoqeKNx9MDfGW8lQygMzFz97eFAIdVXDfAzYwZKY+7uaZyM+99NiPOL7RVYRUXU+9912PGMPuVBrBoUe7kMGwWac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7869.namprd12.prod.outlook.com (2603:10b6:510:27e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 14:58:04 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 14:58:03 +0000
Message-ID: <84f5e0b9-655a-9503-1781-26c31cb062eb@amd.com>
Date: Thu, 2 Jan 2025 08:58:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 0/2] KVM: SVM: Make VMGEXIT GHCB exit codes more
 readable
Content-Language: en-US
To: Melody Wang <huibo.wang@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Dhaval Giani <dhaval.giani@amd.com>
References: <cover.1735590556.git.huibo.wang@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <cover.1735590556.git.huibo.wang@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:806:d0::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f31ecf8-fa7d-4636-2f2f-08dd2b3ddbc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NU1hK25TL2hhMWRxRlhhWVcxWFNzQndEOVZGK0h5WDhISGtYYUtLZnNxQXRL?=
 =?utf-8?B?TTloWEMxZ0dpSDAwMDhVWENwa1VjZk5neUswajNsWmdidm1vbzB4NlNvaWNP?=
 =?utf-8?B?MWNkZGdlL0hGcEw3RFNLcmxwWGhrL1YxVHB2b3k0U0NFVWNibVM2OGF5MmhK?=
 =?utf-8?B?QmxlUGlNb3BqbkJpRWxhSklYRkpLSi93dGRsYk9keFdYVzM4S25OeDQxcVVF?=
 =?utf-8?B?cFBqNkdtUHdxMXVVbW9ERmkyZWFzWUx2TVlOZzdhSjU1V1BpVGtRQktWdCto?=
 =?utf-8?B?QUo2NVV3VldpNzVHY2Q2MllGNjM0ekpvN2VxbHFsSE04cHUvMXhtVHozS0gw?=
 =?utf-8?B?VlhEU0tmcHJvcnVrZXNOc1NqM2dmVnY1cnE5ckVwK3BKdndoN2VZZGk5SWk1?=
 =?utf-8?B?RHhYdmtnMHA3U3dLeVlQcXo4Nll0RlI4VHI1MndmdysvdWdRa1Q4TDJRN2Q4?=
 =?utf-8?B?VDRYZHdKOXpDdC9aWTVjd0F6U0JwanMvSHNPWXBaams0QmZzQ1BVamJNTXB1?=
 =?utf-8?B?RHVlU3cvdE9vOUExeGtNeUFiMUlpMUxrMjkydVlLTkVqZXdrSWZmMTdsNGhj?=
 =?utf-8?B?dVFrMG9CYlVNK0o4WXdRZmRPWEJzQXZPT0wxSU56dnNLbFIzV3h3MzF5TUpa?=
 =?utf-8?B?RUhQek96dDMyQ2ZXQm10ZFcwT2JsMWZsM3VMVFhIZXE5ZSsyaTUrV3lUWkZM?=
 =?utf-8?B?U1kreEFTRmpCQ3RKOXVFZWhpNml2NjhRa0FOanFaak1GNEozT1ZzY3JjeDc4?=
 =?utf-8?B?QnlNUWgxQU5PWFcweTRPbUFIMXhDSnQyaGt4clljWkdGbVhacllnZ0ZCYVJj?=
 =?utf-8?B?Rjlad0RZb2M4d1AxS3V2SzAyZG1sVG5takJXWTJRZEo2MUhaU0ljWjU1SElY?=
 =?utf-8?B?QzZHN1BkYkJlNy9MVGtSZWN3RzZ5K2ZIMCt4am1nUmZldWdQamhJRUVNY1Bx?=
 =?utf-8?B?aFVrVEtEdDZaaCsvak5aUHM0V2tzdFFBRCtvQjRoMGIvNVpZOHZTMVlyNGFB?=
 =?utf-8?B?aUVabTdJZU9NTldkcHFZWmExQUNiVzhPaGRhclhqQWE1UnN6RGpKb2FDLzU3?=
 =?utf-8?B?TXRUQ253L3YzalBlU3NiWlgxRnVHVG16ZHUrVVZLTlFId1MrN0ZqUk43UThV?=
 =?utf-8?B?ZnRLaDRTbHBFcWYvU0NSYjB0TElxdkZKZVR6ckVNQnNWamNHZThiMzJ0SDA2?=
 =?utf-8?B?cXhSeFZHNkhCUXk3dlcyb08wYytIMmU4SzJpNXRKZ01QRHYyN3A3WmhCeW51?=
 =?utf-8?B?UjYwWC9mRFZYbExMWWxtcVllSENHc3BPdEtWL0Q2ZGJSdzYvVERrMFFoeHBi?=
 =?utf-8?B?VldDQWR6TVFaSE16aTdOaFl5aGM2NWtJMS9qRENUMDY5dVVWeGd5TFpNK0ty?=
 =?utf-8?B?NWg0WUZRaXpqOGtqaEk3d1MzdE9hM1UreStVMzJLNjBmNzNKNnZKOUl4bDR4?=
 =?utf-8?B?T2dibjgyck81YkNvMHc3cVBDdDN0b0Fqd052YStQRnhWT05jVEN6bGR1MkVX?=
 =?utf-8?B?ZHYvMGVUcUwvMVFsakZNa0I2SVphRlFYK3pYUDVLQldQVVBvdkRsZ3BXanJr?=
 =?utf-8?B?eEZhQ2dIdjhST1dvNmFNRGNjU3lxQ2p3cXIxWTFlWDhyNUo5NFJwckRsTHpY?=
 =?utf-8?B?Nkp2TWR3TTU1dEwyRWY4aHBSem52T0ZQYk9va0tNT2sxUmNTOWJGQXEvRUo1?=
 =?utf-8?B?enVIamc2amtyZlBjbm5pU0REeVBuNG15SmlsVDVjTXo3UysraFJxT3pYaHM1?=
 =?utf-8?B?L1BYRlAza1BoMWFvazMxVmV0WDBCckhDNGgyMmVpNEMwVFFaa0dzZ3ExWnYz?=
 =?utf-8?B?MGpVSFl2bE13aGNHcUh3WmdIS3RucG1MRmFOUFJNWitvSyt3Wi8zM1BWZkFU?=
 =?utf-8?Q?wo0Dk8ZTg4GSM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elprcitON09xU3YwVWtsNnkwanp0cFU0REtIUElpbHNlUzVRM3IxdVhTa1J0?=
 =?utf-8?B?c1Uvb1VWY1IrU2xUc1ovRk1LajhwT2p1VDJ3MDduRFQyMHF1dWdBRVZFNGdh?=
 =?utf-8?B?YTVZY2VLOTVxSVp4M0FWZEtUVFQ0TU1nZkJWaWZXdUV4aTc0R25WNDdYaG8r?=
 =?utf-8?B?TytzcHNqQm9FU2dubWVZT2ZZNzM1MUZ6d3FlUm0vVk5IWmFDS0FHbk56MGc5?=
 =?utf-8?B?TVRHUk1kQm5BMk1ocHpiZ3lZSlBkY3g3OGtWTTNzenpRVlFBaTBBTnJwVkpT?=
 =?utf-8?B?ZWRmWXpVYnZSYWQxN25JRUxWcHJJWkJiRHNVSHdWYStSb0lTdXJMRkVjdWpG?=
 =?utf-8?B?Q2pheElPTlFTQkdZTVVzMWZwRmh3UzFRMy9pN3pkWWxuSFNXS3U1UG5ZdFdO?=
 =?utf-8?B?TGN6NWFVTEJObHFyVVJWY0s3OXh5Tm9QS2E1L3ozRUIvSmRMMUU0RlpOYSty?=
 =?utf-8?B?RG1JczdaVTJSaTlyVG5UbHYzTlFYS0JQeTYwaEd1MURLZDNKQTB2VXpxOGE1?=
 =?utf-8?B?bFRGbVpNUEYvRThjMTRxVUVCM0d4S29LM0h1RUgxK3VUOHlFT25mZDRpOXZt?=
 =?utf-8?B?MlRRSGJLMFBuUEtHYXlEOEZQdzlwM2d6Y3JhaDlrYW8ydVNrRmUxcGlITkdy?=
 =?utf-8?B?ZHlBMHRWdnlmNXF2UWZkY3laVCtTaFNBVXZIcjd1V1dsZGNXREZXVGtFcjh3?=
 =?utf-8?B?dVJjZDN0cnVPbnhJWnhMTDU0VkFtSVp6V1ZiSkJTcjgvVElSQkpZUkptcDIw?=
 =?utf-8?B?NFJsOEdHOFByNnEwUFB6dUdqeDhWNXg0U2RDaHROYVdNNU51V1U4T0grcHdC?=
 =?utf-8?B?NjdaTUdDSWhLeks4WWtKeFk2Zit1d0M2Ym95bmdidUdybW5ERW84M1Q0dzNa?=
 =?utf-8?B?ZnVNaVQ0aklNRVV1UkJLNDRydnpyU3pJUFRMT3VvTFN5bGx3azFaazFNcjdI?=
 =?utf-8?B?MWJkeFdrVFlveHVnTFJpai9DVHNVNHl1cC85dG5ralNLKy9FZkxqWTJHLzZF?=
 =?utf-8?B?UWFKbHNHdmpHZ281blNBSzkzSVYvdUdSN29Xa0kwTGZSOFFIOTk2Sy9neExv?=
 =?utf-8?B?ZjlFTStXRXJiRVl4VlorditsMkhUdDR3Rkhaa1M2cFU4T3VkQmg2VFVRV3pG?=
 =?utf-8?B?azZseDd5UWhnZGJZa2tWWktWTTRPaFJ3dHJ4aTJHaysxYmx6Y3cwNi91eUkv?=
 =?utf-8?B?SlhEQzkyclFTT00rcEEwdGZWSkRLLytwYVBjWEJyWGZ1bC9MMGVLdmJaS2NS?=
 =?utf-8?B?Q1ZyN25JRmE4QzRvSWtzWjUrUlhKand3T1BQdHVxTXQ5ZjBYdU5qY2RwNTRR?=
 =?utf-8?B?VHVpZmwrMGN4SDE2NVliTHpwK0pjUkxxUmJQRm56MFZwcVk2RzB6UmtEWG1a?=
 =?utf-8?B?OXVPTHYzVzZxbVpHd0NrRyszeVRwanZDMkVqdEpKM3FCZHVvaW1peDROTStt?=
 =?utf-8?B?QnZWNUZOdFlra2VKN3FRYWVCekN4aGQ4cFY2QU9NRDNia2ROTmV1ZW1rS1Ja?=
 =?utf-8?B?eTFpV3NiWUJmNTBMdE1jNy9vTFRHZDhwL1hwQ3JYRWdYaVNYZXQ5Yy9QZnoy?=
 =?utf-8?B?cWNmNktQc25iY1pndXYxZHF2RVJFYUQwWGM2Y0k3UktYd2hTYU0vSStqQ1BC?=
 =?utf-8?B?anZMbDd5TFExMjFEV2h4QkJ1VXk4UnI3RGhKTmNwdTNFZTJwVTNkV1dMNWRm?=
 =?utf-8?B?clk4Y2VVbWxVTklzbkw1Q0VGMWdkTlhmMHpxOE9tZEIyQU9iWUR2TVJreUFB?=
 =?utf-8?B?N21jNDFIZnptMHUvNWNXdmNTZGtNRSt4SnVXWE02dzRqZitkcitHREgweUJp?=
 =?utf-8?B?Z1FUdmZaUVFvTEZqMVc2VEZ2dU9ZWndiaHhaS2ozUGIza3pJK2tETnBmSndz?=
 =?utf-8?B?U1NXTlFhVWl3TVpobUxUbTZ4N3F4WFArYnpCcmlrSDBWMjhqWFdWWVhpNW1Z?=
 =?utf-8?B?SlYyODBVYlhaWXBSZGVsS0VlSkwwQXJlWGNuelF6N0Y3RXBwUmcwdi9mZmJE?=
 =?utf-8?B?a01xVXd1VlVMZmJFWGo1c1RaL2VadTg1WGtNcHdGd05LRzVXbmQra1B4WkpM?=
 =?utf-8?B?TlptN1J3cHFIVmRybTVKWUJvc3VqL3pUR1FBMElCcUp1bjExQUIrY2JNQnp6?=
 =?utf-8?Q?Aelmv5VlAkLaaBO5S6md1Fsg1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f31ecf8-fa7d-4636-2f2f-08dd2b3ddbc0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 14:58:03.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdfVt61wt2QwGb1WUMZ95U82+afghbXvmJqsfoPL1iPkJkDR/YbrqvLBlk8F2zssMo35EIEY88RFRKC7EIAxcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7869

On 12/30/24 14:36, Melody Wang wrote:

Just some FYIs when it comes to cover letters.

> Hi all,

No need to put this in a cover letter.

> 
> This patchset addresses all of review comments from Sean. All feedback is appreciated.

This should be part of your change log below.

Here you should have a summary of what the series is about.

> 
> Thanks,
> Melody
> 
> Changelog:
> v3:

You're missing the changes from v3 to v4 and you shouldn't delete the
previous log of changes from v1 to v2 and v2 to v3.

> 
> Here are two patches to make VMGEXIT GHCB exit codes more readable. All
> feedback is appreciated.

This should be at the top. Also, this isn't for exit codes, it is for the
hypervisor return error codes, right?

Thanks,
Tom

> 
> Melody Wang (2):
>   KVM: SVM: Convert plain error code numbers to defines
>   KVM: SVM: Provide helpers to set the error code
> 
>  arch/x86/include/asm/sev-common.h |  8 +++++++
>  arch/x86/kvm/svm/sev.c            | 36 ++++++++++++++++---------------
>  arch/x86/kvm/svm/svm.c            |  6 +-----
>  arch/x86/kvm/svm/svm.h            | 29 +++++++++++++++++++++++++
>  4 files changed, 57 insertions(+), 22 deletions(-)
> 

