Return-Path: <kvm+bounces-16426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBC98B9FC1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 19:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C933628311E
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03707171061;
	Thu,  2 May 2024 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QelKTEKQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D641216FF4F;
	Thu,  2 May 2024 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714671969; cv=fail; b=RBfG3JHVCKa+v7Ry637F81FlCZjRA9QaAaa9GTLIo+DfvsKp2yCt9Ig+km3EGF9kXr8FD7qRLNrzwKuM6SWE7TCqxnu43xhj/qOYZI72ba0KTkFD6SpSYCqO6PXTYdN+7UxA37sd2nZypuUON0F1JiJ5PmGaEs9rtG1a+wLVTH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714671969; c=relaxed/simple;
	bh=PXWzuSn45X+i8f9YhBY7/xddJr2Dn1rUJ0qJ2AB09NE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=nK9swYZayAD0F6vQBuUoTMU8MY2/uzTTsS3dWv/MdOv3IKlpNbaMNGjoMlIK8aMyIygoicPK/efA1sWcwQcZWg8AMYhJvEXyazYJSY2dJtIUdviVTzJ0bCSyCvKjw+bk2hxhV7hczLfJuM3Gt2teIAGgtL0RO9UdnZ5w9jBq6vY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QelKTEKQ; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+n66hkEOvyh57lm4OJBfTZT315jJh65Cn+Xa8xohpN4FvoDyRy7JrbtGuCpjirqhhmdIBweiJYa9a8BmEsQF4RQ7l93gvAXf6l6TH31yeyUUvt0fW+wvcIwCJLxrWfAw46R2DjMKTi3YtQjEqJHxhFisZdhQGT48ZrKHrCJUzx8D1Mnuh6/9NIl8BBxkbFFVV/ZV736/Dlzx08k6dBhmTzq3rrBCt8xupa5YOHBeYmVv2QmQ1rGHPBWZHJFYCdrOfumbmEy+WATow6GkmGsFYSX+qImhr56YzYlA/MBhHCcaXA6ZnKDC+IQv4Qi9+iyEP18iqNnN7qHNOfDVL4i/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfoD4ciGl+jMLRvqXO30roqtvnj6fnRtDoWtcLeuu/w=;
 b=PVjVgvJ+OQRoku0q+ZpGi06+xZ/EzRwpwsI1JmmXDPe9AgOZjNcBg0ZcqHaPCR27v6nMHqVYlQThkBMZ6iaUnhUfOiC+4kgpy9DEVLA5ETJuFRXj4pFUnCkin+HhSrSLAmnyo7444Am/k8M3/PxhCKWVl9zjPkOYEke+r0dcFOZ4SlDcH8939q/r308qYdI2i92xq8uf6C/iZ7pBI+KZQ3imCRc3lgQm2oD6wZzv92p3cPkvfsfPGzxF3v15CAJ2Mv09x3NS/4fCf02WPeiYtHVgfS3J7BA+cyfezVSLvCdG6/fF/z9uQvR8ZR2UEdWFn2cG973KbfBnMa2OdMXizA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfoD4ciGl+jMLRvqXO30roqtvnj6fnRtDoWtcLeuu/w=;
 b=QelKTEKQaQ/I6/U7SuS7G/kztMM36JNUCiFNkBP9mW0lpu27sIki2a4n+6m8NIX5ecH+cRi2bFSDX7MBVHpWYnf/IHu6GRAJZ4MrrmVteZrFVYfGi3MNH2oDjWLEKdBirVqv3YBnub0I9rx+aClG0xNasj3te7fZaDbDpnPVlh4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DM4PR12MB7599.namprd12.prod.outlook.com (2603:10b6:8:109::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Thu, 2 May
 2024 17:46:04 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7544.029; Thu, 2 May 2024
 17:46:04 +0000
Message-ID: <9b05e2d7-ac1c-e60f-0f6e-f4befea06334@amd.com>
Date: Thu, 2 May 2024 12:46:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com, rick.p.edgecombe@intel.com,
 bp@alien8.de, pbonzini@redhat.com, mlevitsk@redhat.com,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20240226213244.18441-1-john.allen@amd.com>
 <20240226213244.18441-7-john.allen@amd.com> <ZjLTr0n0nwBrZW36@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
In-Reply-To: <ZjLTr0n0nwBrZW36@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0023.namprd21.prod.outlook.com
 (2603:10b6:805:106::33) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DM4PR12MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 62e61025-b3d2-4ef5-d4fa-08dc6acfbd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RW5BT0FIY1hFTzI5bCtpME5hd2hkSGppT3FOVDduT3haOGJ1K0pGMUIrcHVT?=
 =?utf-8?B?MzhyTnZHb2M1UnplYmwyRG1lTDhDUHM1N2I2YytISVVmc01XS0N0RGlXWkE3?=
 =?utf-8?B?NHAwUXQ4YXh1ditHNDZYTjhoUWdVaHJ5R2pBVzVJNFY0LzVJQVk0L1hyWHZ4?=
 =?utf-8?B?cVQ1UWJsVUJoeFBhcC9xRGhHRVJNeHNJT3NWOXBQUDV2SXZtTjhLdUdyd0Rn?=
 =?utf-8?B?K0JtaEZSbFZEUGpVdHcvdnRLRlY3amlzbGpXVVJuTFZ2V2V1N0dHTDVxM2sv?=
 =?utf-8?B?aDM5ZE56bG5KZHZ4ajBCQ2lCdTVuQnk2aHJtMTRHSldvdTIxL1NPVjNxaFJL?=
 =?utf-8?B?MlFETDEwVDU4a3VWT3ZTREVtemp4dFBycFpJRVh2czZrK2R3Y0hZdFhFQ0J1?=
 =?utf-8?B?LzUvZlE5Qyt3aGRLVkJpSDY5bkR0VitkV3NzMkpmSzkwTnJGSGwvZVhBNld5?=
 =?utf-8?B?OEZKTWNhejE1bVBJa0duYXlqOE5zdCsyN2tCeHVrbW11a3VvM1pRQ2xhSjBm?=
 =?utf-8?B?QlBUZVduOE5aTkxJQ21GcnRoUzlRbjh0SGhpTWs1WGRkWkp5UXFCVjF4aU5q?=
 =?utf-8?B?ZHY0ajNxNVpTQkN4MTIrbVc1enpDVzFaU1lDeno5SlZ5NCtzaXhJSzI5aTFV?=
 =?utf-8?B?VDRoUDJRenpJODEyQVM0Z2NnL3N6K2FLV0kxbUl0SWlMMERZZnh1czRUUGh5?=
 =?utf-8?B?Q2poVHVhYmNuTmtsR2luYjUxdGpOUVYwT1JsdHBiL09rY3ZaM3JnTU9XaHFW?=
 =?utf-8?B?ZjRDdktySWhKMnd6U29mamFwOEdMK3lubG1VTWljWFBvQ0JPRy9oRDAxR2Rp?=
 =?utf-8?B?YmRUbkVtNjMwVHE2Y1F6bXhiUThlYzdFS0t2Q0ZCTlh2Z1JMSzFWanFYVWsv?=
 =?utf-8?B?NGhpcGxYaElYNEFmaGY0R2hJZ1Q0YnBpMFRoZjNONml2T2dWY0pBczIvbDM1?=
 =?utf-8?B?YVNyUGVrRUZKSitXNGxkMU1vUFcvMmVlZ3FtaW95S1pmdlAxQmU4QjRROTJ4?=
 =?utf-8?B?ZXh4UytrMU9nRkkrMlB4blNDeG5obkNGZ3JIMkUzWG05bGQ2Q3VFODhCNnFi?=
 =?utf-8?B?b3RaUTdmaUUrMk96UUxxSzFuTUFhdm03VVZzckVNNDlpNm1OTG12UW5jdDh1?=
 =?utf-8?B?U01FeURIR2xld3c5U256MzRJSER1ZVZCV0F6aWVQaW5VQ1JpVmREdGF1QitG?=
 =?utf-8?B?Vk9ZZlI1aWd2S21JeFJJLzk2UHhPZkFJSCtMejRhNVppWTJicWg2UmpDQXhH?=
 =?utf-8?B?Ni8vdFd2WkMyMnliL1dpbU1kdlB0dVlDQ2xlZWNBRk1GTGVOWVRCcTRXTFh1?=
 =?utf-8?B?WEtCVEhIM3NHQ3hPbmdIY3RiejhHcjlobEdteGVjK0xib1FDazlpNHR1OTZI?=
 =?utf-8?B?OE81OEZTN0xjUHdiWW9LbkZRdWZ3eXZvNWhEQVJMb1VsQld6SFkrQVpTem92?=
 =?utf-8?B?enUvdkhYV1hWNjdlSTVFMGtrdml4RlQvaU51d3BKdkt0YWRFQlNwZ1FkWGVF?=
 =?utf-8?B?L2hjMWdHWTBBaDlwQVhjZnBIRGtsVmhjenoyb3BZaUNqa1JHWGhKUkRsaTQy?=
 =?utf-8?B?bGp6UWErY0w5dlBIZjRsU2ZvenUzdmJqbE5RK0YyVWZ1RGFJK0R3N212eE1G?=
 =?utf-8?B?UGt2a0taZkI1VDNVa011YnYreS9JZitGV2ZRZVZkV0ZZVTN5bWFDYTlsaDRs?=
 =?utf-8?B?OUN2bFFoMm82eEh4anlkMHBWWHRELzJ0UU55OTlINHR4L0N6VjVuN0xnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUpzd3cwLy9QYjE4Q1k2RGdoYUFHd0M0NEprbHNuSEEyQUxzY2p4VlErNU5q?=
 =?utf-8?B?c2FWZ0N5NVVKK2NZblV5bzJxckhYb3V4NHhHemo0NlZaNW9pTGpWMnRwMGU0?=
 =?utf-8?B?NjMwK01WWlRFZ3F0VGFETFVNdC9xY3FCWHlJOC9adDNORUl0SzdXSEM4MU1m?=
 =?utf-8?B?RmZEditOc0kwdUZMUkNzUXdab3ZXeS9GdjVVRVNaeHlTcExKTFVRc2dqVFJL?=
 =?utf-8?B?L0t2c1VGSGMwS3FUTjdyd0crejNndi9mbWZkMkRqalpWck9xOWtBVDl1N2hu?=
 =?utf-8?B?blN1YThpeXdoV01UQiswZFF5c3E2SENRRmRPbzZJYXlocW9jVzFtQ3FaYm1Q?=
 =?utf-8?B?UEhHRkwzeFpFMldYaWdOODBFUW84c1Z0VHhSSlByK0tMVjF2KzZWbkUybkIx?=
 =?utf-8?B?V291U2ZmdmFGSFNzZFFtTGRiUEpiVi9CYVA0MVFFNTJGeDExRE9nT052US9F?=
 =?utf-8?B?ME1BcW9kc3BPL0t1TGY2UXhZWUpSQTBmMXhhTFpqV0MxVWxaSWNNNE5naHN6?=
 =?utf-8?B?QnNIb1Fwa1ZZdmVXSGxURU5UVzhoZlNXNWhKQnRqbS9PVXFROVJqVEtKRGRt?=
 =?utf-8?B?NXBlSlhVOWRjUDZ4WjdtTUVsR2RiMmU2MFpaSjJYbE9mb3VrNjk0QSsyMmIy?=
 =?utf-8?B?SDlLMVZKd3h1b01hb0VhQ2cvL200b1BmSmJ6MkFUNjY5SFJ6bGFKVUZmaGlU?=
 =?utf-8?B?ajQ0RmlQYlNkUzE0NUxVSWttWi9FZ29aTEJ0QWhXa1pqUmpHdFNBMFhwWm9S?=
 =?utf-8?B?czVGV09SL25sYTNEKzFDK05TSmdkeDAwTlFnYlVacElMQXBLcHlFUmVNNHIx?=
 =?utf-8?B?V25PY1ljc2hSMUd4T2dGZ3pDL0ZpUU9nWEFLdnNjZjZsUUlsYkV5cmNid21s?=
 =?utf-8?B?cm5WZnZPUlVtVVhyZmg3ZE9sbWNaR0NKTkovMFZFdWdYY1hZekd1cmg5ZGFZ?=
 =?utf-8?B?Y0RjL1Y4ZVFPbi9LWmI1aXJFTkxyRzlDaDlUQnRwWjFVM3JKR0w5clBnZkI4?=
 =?utf-8?B?anV5YzJsNEI3UWNRTjY1cHU4cEpUeWplSTRLZUlWbTl5d3FVRWdIUWdaWTFN?=
 =?utf-8?B?bUkydkpVbWh3ZlB5a1VNejhiaitldSs3WWhGajliaFlXRmRGbFR1aG9DYUtM?=
 =?utf-8?B?UU5OZ3lmKzhZL2E2VkF1ME5vQXUyTCs2QllHd2J5WXlDdExsTDNhSmZKaCtl?=
 =?utf-8?B?S09pYXowS1VPN2daeS9vRHM1d1VZWU50cUdhMTE1S1dkKzVYSUYyQjBOTVMy?=
 =?utf-8?B?c2h3cklWa1FUUkVWdVh0WWZxbWJwL2NOcVFSajdvLzZkZHJWZUhvSTB4QWRz?=
 =?utf-8?B?NXdlMUg0R0s0QTBtMFc0QjF6T1lwSlFESTNLOXc0Q3loc0dYSCsvWDI0Y0dI?=
 =?utf-8?B?eFV3MnhKeGpCaW9WaUNOcGZpZ0F3OHdXYnhwV3lXempHWEltUTh5eERzLzdh?=
 =?utf-8?B?eVVmTEVDd09kQ1lwMHdHMi9NSUc4ei91emVsNEV1UG9PWVBJT1JPcDJuYkF5?=
 =?utf-8?B?TEpvTkNOdFh0emFuOWMyNVNLMTZUWXlrMldxMGtUQjl4bVBxc2RaT3FNQ2Rz?=
 =?utf-8?B?Ukxlc3pNKzRXc3c3aG5FdzQyRkhOZi8xaTVwMGRxQTV2MkJLaWxSR2VJTmFC?=
 =?utf-8?B?NU1HbjM4Z1I2dWtFMnB1NFhHUk40RGVCSW02VkYwem10d0xQbFVrWlhxb3lZ?=
 =?utf-8?B?bE5rd3J1WU9reXdVNzBVcU4wUlozeWIrV3ZVYXBqVWlNVXpRRW9TQ1lsSFRs?=
 =?utf-8?B?T1RGYzl3Umc4VXdFS1daaFpQWHBIb1F4cG5iR0Q4MENsaHJoRzVoV01BbDgx?=
 =?utf-8?B?dUc3bkFCQSs3Ym02QlBBU3g0QWVNZ01RUm54L3IzMmtKbjBCR3I5UlY2RGU4?=
 =?utf-8?B?Rk9zdHpKSUhSVldGVDE1dG9LSWhpZVFWUmdlcEdtbUx1UlpVcjJlVDlFWGdq?=
 =?utf-8?B?ODFTUTc5K0JSOGZ1Mldnem5NWHhRbDJBQjM5MnhDOTBGaDFGZ1NNeFd3UW9h?=
 =?utf-8?B?ZldOTXhYNU9EUmdPMGNkOGpsM00rQWsxYWF6QklCZW1GZldRb2tmNmY1NlFY?=
 =?utf-8?B?cFR4UW1Xa3NLbHJ0SEVJaXErc3o3MHpMNlluQnhoOUN2M1VpNnNTdkkvS1Vq?=
 =?utf-8?Q?1vDkvMmJUyGn7i4TTuoTL7ouH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e61025-b3d2-4ef5-d4fa-08dc6acfbd03
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2024 17:46:04.3142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+PiAfWqIHI83iJ80fJX4tMQizx9qDFJXUTb3zzTeFKuwOmCG0wa6KJYHZMjEK/JzHjXH5G8G35an1AYM+qXcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7599

On 5/1/24 18:43, Sean Christopherson wrote:
> On Mon, Feb 26, 2024, John Allen wrote:
>> When a guest issues a cpuid instruction for Fn0000000D_x0B
>> (CetUserOffset), KVM will intercept and need to access the guest
>> MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
>> included in the GHCB to be visible to the hypervisor.
> 
> Heh, too many pronouns and implicit subjects.  I read this, several times, as:
> 
>    When a guest issues a cpuid instruction for Fn0000000D_x0B
>    (CetUserOffset), KVM will intercept MSR_IA32_XSS and need to access the
>    guest MSR_IA32_XSS value.
> 
> I think you mean this?
> 
>    When a vCPU executes CPUID.0xD.0xB (CetUserOffset), KVM will intercept
>    and emulate CPUID.  To emulate CPUID, KVM needs access to the vCPU's
>    MSR_IA32_XSS value.  For SEV-ES guests, XSS is encrypted, and so the guest
>    must include its XSS value in the GHCB as part of the CPUID request.
> 
> Hmm, I suspect that last sentence is wrong though.  Question on that below.
> 
>> Signed-off-by: John Allen <john.allen@amd.com>
>> ---
>> v2:
>>    - Omit passing through XSS as this has already been properly
>>      implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
>>      accesses to MSR_IA32_XSS for SEV-ES guests")
>> ---
>>   arch/x86/include/asm/svm.h | 1 +
>>   arch/x86/kvm/svm/sev.c     | 9 +++++++--
>>   arch/x86/kvm/svm/svm.h     | 1 +
>>   3 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 728c98175b9c..44cd41e2fb68 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -673,5 +673,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
>>   DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>>   DEFINE_GHCB_ACCESSORS(sw_scratch)
>>   DEFINE_GHCB_ACCESSORS(xcr0)
>> +DEFINE_GHCB_ACCESSORS(xss)
>>   
>>   #endif
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index f06f9e51ad9d..c3060d2068eb 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2458,8 +2458,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>>   
>>   	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
>>   
>> -	if (kvm_ghcb_xcr0_is_valid(svm)) {
>> -		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
>> +	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
>> +		if (kvm_ghcb_xcr0_is_valid(svm))
>> +			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
>> +
>> +		if (kvm_ghcb_xss_is_valid(svm))
>> +			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
>> +
>>   		kvm_update_cpuid_runtime(vcpu);
> 
> Pre-existing code, but isn't updating CPUID runtime on every VMGEXIT super wasteful?
> Or is the guest behavior to mark XCR0 and XSS as valid only when changing XCR0/XSS?

It's not really on every VMGEXIT. It's only if those values have been 
supplied in the GHCB will the CPUID runtime be updated. And the Linux 
guest code supplies XCR0 and XSS only on a CPUID VMGEXIT.

Both sides of that can optimized. The guest can be optimized down to 
just supplying the values on CPUID 0xD or even further to only supplying 
the values if they have changed since the last time they were supplied. 
The hypervisor side could be optimized to compare the value and only 
update the CPUID runtime if those values are different.

Thanks,
Tom

> If so, the last sentence of the changelog should be something like:
> 
>    MSR_IA32_XSS value.  For SEV-ES guests, XSS is encrypted, and so the guest
>    must notify the host of XSS changes by performing a ??? VMGEXIT and
>    providing its XSS value in the GHCB.

