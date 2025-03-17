Return-Path: <kvm+bounces-41260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C90A6599D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED85F886E7F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF331B4242;
	Mon, 17 Mar 2025 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B0F8PcWT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7464A1B393C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230654; cv=fail; b=JT1upRYpjxsimJfkzyikGEq6Zo0maHoxf4dluARF6EfS4X/YRzcFRXL0x6o+wmBH4GONQ1APVGzKCvlebslNGD7yx5Gl+MmwUiqW8t5FVZzFSGcOphi8ZzIpfs6bZL3K9zdnc028LsEZqO1SrYn7bezjIjdCCAicFC2aFFeDVg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230654; c=relaxed/simple;
	bh=CKdYi0z8/LfGIScvhhmC9U0Tm003UeBVbmvvd9dtBbk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ltzbfPo5IfDRiP4+u5gagdp57/n4DOtaHPAuiez75jWsgpphJ1ueYVyNyBsBRY1eXbV0DUP+Ry+aiqIq4ojae1a8ScL1UM+RwbDy7LKC7K5kE0c8syKw5u2/G43/WUyEmtK5ayZ1Z0wivyszjc3lhwo4Aez6I/0KJdGuIcqcwcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B0F8PcWT; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pz4EghLA61WRuCde033aiMKhdsIz7Ts3uKu2E5mtK1YGwNrs3oQxRDBiWHw0CZG6hnHu9B5fdH5mR+1I4EszHZiJFjfMG3HmaA0ldvdV4mc9jPTTwQ7GCTGJWQ6kq1qm0bvgvBRYBpZYVGHEo2y4ZmhZFCwHvm1+9WCuSlztR2pclSRWGDnr/RffHLQqRmZuqJILfJDPAeoCKIihAe0bXAnv0eSjiejg8viby2PyBiznlsPd2/OUmjtxRWkWS9WIMvlwR9wUXYGC8sx6AnncTYpXX1+mUzE2/5/0MivRyp/z3jHHNzJajvBun6Z/cxayHxs9c3X9bjrPQxcQ5V8JIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CG9Ij0kFe6Yj63h6YtWnUXg+SfL6cfi7IQka9rfEP4=;
 b=ue37Gh7IfO/k51TngJMDvdxAkzK89OXzzIAkT2MN8SIp3m/VtmnVH+Z+BOaJzQgZ++ZjD7zEYqPenAmF+YYmLlRwXf1hgNqa5Bq1P+K2hlBgJe3IATMOKequ8N5IUZ9v7NXby92xFNzaHRV8i7KR8xqBM3kEqx5YtWGQ2CwDnzjKDu2ZEso+5EV/hfs6JVu9Cc10f1CuZdhrWQnZoaEUN+L4Jnk92dTv3ZjuBGIOCGrBN5OLXEzzoIz6RHacYr9DICs/D41ZJiEmekdtLo//w6GPWkDIO9C5dGT2dlvMWnbi1z0Py5qsPBd+u7diU85U4HWcfdlUR9Z7HhdI8WyvbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CG9Ij0kFe6Yj63h6YtWnUXg+SfL6cfi7IQka9rfEP4=;
 b=B0F8PcWTAfZAd2UjKIKO1Mgh/itn/4FNo26TF2uwGRdF1BHP7v0kxSmeZYtPG3+9HLtZACabZrU+uGu4XN6FG6YXgSk222+8t+/HRQa5hwi7WEiUZvTRov0gxE2Hc1INzErdy4e78q3G8dIadbcjiTH+v85VV0Q8v7v3XmUEW+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 16:57:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 16:57:28 +0000
Message-ID: <5a3e7266-30be-3549-ea53-ce5d885a13cd@amd.com>
Date: Mon, 17 Mar 2025 11:57:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 4/4] KVM: SVM: Enable Secure TSC for SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250317052308.498244-1-nikunj@amd.com>
 <20250317052308.498244-5-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250317052308.498244-5-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0207.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW5PR12MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: af88464d-0a6d-433e-0489-08dd6574ccd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEJYNFI5Zml6dUlDQ0lmcVpnMHoyc2E0aUV5S2wwK3o5SkdvQzJxSW1FeWtN?=
 =?utf-8?B?THJyM29KOWw2amJYL1pIVGZRVzJ6Vjl1WHNFT0lJdDhtZGlrZm5hNTBMZTUw?=
 =?utf-8?B?Zk5wT3FXNDJwUjdTSUlIY3BzUi9UV3hjQ2IxNTBnbWpCZ0MrdjEzbTJaRDM5?=
 =?utf-8?B?dEtTd3pidmo2QmxmZjZVcWE4TEpZNGxuS2FuYnI4bUkrK01vYldIQXBScnFW?=
 =?utf-8?B?L1ZxZmM3NzQxb0x3cTYrNlNJbEZkNUpnTUpiNURHRzhRVFZ1YmlITUx4c21P?=
 =?utf-8?B?UDNOMkFYbmJxR3ZhYk15dkx4TWlqRDFqZVZCMVlyUzR2MFp6T2JVWVR0Rzlu?=
 =?utf-8?B?UXJzMDRoVmswTjYzdkZyZk0zYjBTZXAzOERzUUR4QkN2VkNLNUJaMlRPZ1NL?=
 =?utf-8?B?NHJtb2Yyb2dvUWd2Z2JQb0JlWWVRcnpQNjAvUzNIWEh6YUV0NzRudTB1bzJZ?=
 =?utf-8?B?VldBNE5JcDZ6WE1DWWdUUjNDNlBibndIV2YwcTBOUUFObytiOEpwclNpWDJH?=
 =?utf-8?B?WDBEdjArdjlBYXA3R3p4b2xUU1dPZ0ZkcXhKQmhuQ1pVQmhXQnV0eEVlTFds?=
 =?utf-8?B?VFZWU1R0TE5mMSswQlNwYUh0ajFUeGdtQjNHa1krS1NieVdlTFhiMU0xNnc0?=
 =?utf-8?B?bHBpb1N5Y3NXYkZhbWpNbzQ0UTNWRnp4OWp1ODJqRHFNOStNRXFaOGZ2a1pq?=
 =?utf-8?B?WHlVTVJLUkI5c0tRTGZkOTI1OWVNUy81azdZL3VnUGFkR1lRS0ZlOTZnMytm?=
 =?utf-8?B?bWpnQnNCOUlMZFpNeHdoeDI2eWN1WFR2Wjh6aHFqV3MvZE5BNWdxdUVyUVhJ?=
 =?utf-8?B?SkpxZkhMNzM2ZnBvK2NSNkNEZXRPdmVKV013WDNHK1R6Y0NwN2gwaUhnM1hV?=
 =?utf-8?B?Mm5tcm8yWVNPb25XeC8wNDJVRURwSHdZTTNBSFErWllNWlpMaUNNVllrN1pU?=
 =?utf-8?B?K1I0aVpRMm5wekx2MTRTMXJYK1JDNG1Tc2VkZTJtSGRHWXN4VnJxMVEzWWxR?=
 =?utf-8?B?OUtVRTBDMXdacndUUGl3WDYvR011Z0xwRG8xSU1pRmx4N2FQeUNuN0hWTERO?=
 =?utf-8?B?cSs5cGxYRndXbTBjWTlObFpWMVpnaVNYVENMVlRoU2tHdGwyRGtRcVdTVHpQ?=
 =?utf-8?B?aXAzU1RUSmVIQkhtVkJzd2ZubHNpVW5memVzZHJYLzljVXFiSGFzZHpWQ1Ji?=
 =?utf-8?B?aTFLWXlIc05XNEdLSGVOenIyMHpMbDhtYXRoZ2ROeXlFVDJZSTNJQUVYYWVE?=
 =?utf-8?B?MzFtUG9SSEN6ZXB2NnFwd0FibGVJS1lNMU55YzFTaWIzTVVQMG5weFArUnVo?=
 =?utf-8?B?dU9RRHJWUWdPSTN2azRVaUpsSjRXYzNBbjNvenE5NzBMNmEvOXd3Nkl5TDB5?=
 =?utf-8?B?TGFUTTNHZjhqZ29vQy9xamFPN2xTUEVSdXM0MHF1enFhRDBuY3RESU8rNGRy?=
 =?utf-8?B?V09LOVpUcnNBRmRmTVVaaWZyTzVTLzB4SC9YRDNuRDhiZXZ5YnJOdkZxSSs5?=
 =?utf-8?B?YmpTUmYwWElsR291am91OW1wRVNhazJ1anQxemZXM0E2NS8rdnl2Vk9aK0xL?=
 =?utf-8?B?MlhSYXBLVzA4cjR0enhIRzZ5ZmlQSDdUU1pmR01jeCt3T3gvUFF6aHE2YkhM?=
 =?utf-8?B?VFd4V2dZd09ITit2UXRpdjF3UHgwYkZqeG5iK09ZRWUwcnk3YVdJNFpkZDZO?=
 =?utf-8?B?eFdkSjUrazNYQnU1RXRrWDBBQnJYVXhqVjdEdWFkdVdTVTc3K1orWTAvNDA3?=
 =?utf-8?B?YVRyVkZiYTN6TXhkNHdIZmdWOTArTG1RR2F5U2dCVXh1UTVvZDg1ZGpPRUwr?=
 =?utf-8?B?SmE2dTVzVlh5ZjBZRnVCVkM5UERJUk1DWUIwWVE3QytPWVBMTmY4ZGNlOExL?=
 =?utf-8?Q?Y8zZAKXrDGc9q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0t6OVdVZ0xqMHVZOWJwRG95ZTdhT3lyc2pPWUYrQlJWaDN5UDh3a1poK0dx?=
 =?utf-8?B?a1dYMTFoam44S0Yvdnh4Yk8rc21KWkNiOEVRcTFrbXp1aFpUTWZweTZ4SG1o?=
 =?utf-8?B?eHBMS3FwWUhxcjZvQ2RlYlhpUXVOQUwzMTM0Z2NUMys2YWtmL3B5L0NNa2lZ?=
 =?utf-8?B?Y1ZtYkE5ZWQydUJVL0dOMnY1WGV3RUViaGh3S01uV2R6WDZiclFhNGttZy9F?=
 =?utf-8?B?VVlkWVE4dmEvMm1FZENqRjBtMWk0WkJuUTg1SVdKMnFIQXZ0bXdveXdTRTI3?=
 =?utf-8?B?MVcyNEZrMVVCNjJvb2FqUE4zNUM3VmJsREdjektrbFpaTG0rOG80UTZDTVlW?=
 =?utf-8?B?ZTM1RWswSFRldjhpcWI3L0szTmhodys5Si9HRnFldDE0N2I2Y2xGT3BUOGUv?=
 =?utf-8?B?cmJLOGp1ekczMzhCMllhbEdGY2ZacUFsQVJiTGY0eHgzNVRBdWFSNzlrSXpL?=
 =?utf-8?B?M04vZERkTEhkWE5xdjJUaGtKOHc1cWlkL1RDNFA3THdBMFZUaHZQQUFwdE1R?=
 =?utf-8?B?a1h2S0NQbmlZR2xwVjBQTk55MGp1VXN5R1BJaWpiMkp0QnQvRkxEdzJsRFBC?=
 =?utf-8?B?U1lZUEc1M1pKR0EzZEViNVRHUy9wczNOSkltUXpZbGNkZ1p5clVwZ3huenV5?=
 =?utf-8?B?MnZFM0lTRFppaVMxVi9mOXZRSmlabzZFbFVJOGhianJHK05uL2RlUWE3SjFm?=
 =?utf-8?B?cXNQM2FDSWFnbDdxOEhlZnhMV3JtRzRxRTZOUnR6eUpLTWdnaklJcFd4ZEVq?=
 =?utf-8?B?QTFBZ01aNWt2N3IwYmhpRmt5Q1AxWDY1aVNvc0d6aGNaaXJQMFlCanBVYThu?=
 =?utf-8?B?KzB2YkdNNktIMk41amZFZW1XNGR1QkZkRmtUeExEKys5a3AwTCs0WVBkQWxS?=
 =?utf-8?B?VTc0cU41NTFRRTUwNWticUlNT3gxcXJ4VnMyYXVid2RsK0tVZDVObEdka29X?=
 =?utf-8?B?ZVJFNDMzL1B3Qi9OTGZaWkFUenlrNmJBbG1lbDdZTzJweUN5TTRKWkJwTFcy?=
 =?utf-8?B?cGhIN3J5dXNWSGNrVktMeFB4TGZPNCtZQ2x2YVVEQnc2YU1QNXdkT0xCMjZM?=
 =?utf-8?B?KzFETWhrZXA2VG01S01rU1ZjMkd2SlRUck04bmIwb1NYT3VPY2s2YzJObkll?=
 =?utf-8?B?OTlyaVRCeFZLNCt0MDJJaHRzU1IrcWtKemdJZFR4bzNnUlFMNmQ1S0o4RHF2?=
 =?utf-8?B?RmRCdHRKQUxHWCt2TWtvbHJTSjN3enpIQ2JXSVBwRDYwTk9xcFpFNEpGb1dK?=
 =?utf-8?B?bktoNDd2SEZTMHdjQ25rRVNieXgwMkVmSzJTOTlXbjd1dWVEZjNRdHA3NTF6?=
 =?utf-8?B?b2xQTyszVFdldXlGcDB0Yml4RnpCWXBWUkNXL09VK3AxazRKM3IxVXlhdkd5?=
 =?utf-8?B?V0VvZFpOZ0h4Z3htUmJmOC9FWE1KYXl5Y0Y0MExCbXQwZGNONTRUN0dackll?=
 =?utf-8?B?ajVYMmUwQlhobU1OSDBJazg3by81NldRQ0d5TE01Q2pnSzNEclZlMmhVM3R0?=
 =?utf-8?B?TytPYWw3Y1d0UGdPZitJb2ZYVXlSUEpYTVVXcXh4eTNNc3RLdEkwUHE5Uk8v?=
 =?utf-8?B?T05lWkZROEoydkNqR0Y3TVEwdndiRW5Dc1JGaW91ZE90aDM4bHV2TVpWZlI3?=
 =?utf-8?B?bHIzNTl0VU9pMXVQSktlOHVoOUEzbzRuMTl0RFo0a0dhbTR0MWVZUmM1RjNR?=
 =?utf-8?B?SlI3YTBHclhNVFJTN0R4bXBTY2dzelQ1Z2dCM0d6UVg0QnBSRitGMFpERlB1?=
 =?utf-8?B?OHNQVUJrcWU3MnZkYVZBbjZ0NkJncUR1dGs5R29aNlJ6elRLaHg4Q3poUFVS?=
 =?utf-8?B?bmkzNHA5S1BWVndNaTdSTGYyMllhNkVNRGkvUE80a1ZPQ1ZYWXRvemlMU09U?=
 =?utf-8?B?UlM2UWY4cFlPVmNNaGlyNVRqZ2k3ZWFiRmoyanAydHQyOUl4V3ZKMVAvMG1t?=
 =?utf-8?B?UHo1RGJ1bFNPR28vMll0eU0vekxGdmpqdzN0eWZHdEhLVExWZnlPclRnSldu?=
 =?utf-8?B?K091cElrNzFBaDd5MlB1bmJnV3JUNFRBODBkbXZKWmJHdHhZZ05rL21aWmVK?=
 =?utf-8?B?UWRNZjBGWUxKRXQ2MDJVbUU3L0lvTnYrcDY2ME1VbWVSV2RIK2hJSlBBZXdI?=
 =?utf-8?Q?lq2LnmkC90uFGWCYSEsdZPm7a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af88464d-0a6d-433e-0489-08dd6574ccd2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 16:57:28.5310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKTgDAfXtQsoCrWy5EpEaSlLtccwwi0H0Nre3x7psQxj1RmNz57PU/rIHWy0MMub50ZlCxNAY+9fwZE/K8r8ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652

On 3/17/25 00:23, Nikunj A Dadhania wrote:
> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> 
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests.
> 
> As the frequency needs to be set in the SNP_LAUNCH_START command, userspace
> should set the frequency using the KVM_CAP_SET_TSC_KHZ VM ioctl instead of
> the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.
> 
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Just one minor comment below, that can be ignored unless you have to do
another version.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 ++-
>  arch/x86/kvm/svm/sev.c          | 14 ++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9e75da97bce0..87ed9f77314d 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
>  	__u16 flags;
> -	__u8 pad0[6];
> +	__u8 pad0[2];
> +	__u32 desired_tsc_khz;
>  	__u64 pad1[4];
>  };
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 80a80929e6a3..4ee8d233f61f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2226,6 +2226,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_secure_tsc_enabled(kvm)) {
> +		if (!kvm->arch.default_tsc_khz)
> +			return -EINVAL;
> +
> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
> +	}
> +
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
> @@ -2467,6 +2475,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		}
>  
>  		svm->vcpu.arch.guest_state_protected = true;
> +		if (snp_secure_tsc_enabled(kvm))
> +			svm->vcpu.arch.guest_tsc_protected = true;
> +

This could just be:

	vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);

(and you could clean up the line above to:

	vcpu->arch.guest_state_protected = true;

while you're at it.)

Thanks,
Tom

>  		/*
>  		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
>  		 * be _always_ ON. Enable it only after setting
> @@ -3079,6 +3090,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
>  }
>  
>  void sev_hardware_unsetup(void)

