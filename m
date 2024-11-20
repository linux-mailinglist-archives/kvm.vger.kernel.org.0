Return-Path: <kvm+bounces-32115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 120219D3269
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 04:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55032B21379
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 03:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828AF14883F;
	Wed, 20 Nov 2024 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q4tDYvYL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEBE4690;
	Wed, 20 Nov 2024 03:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732072473; cv=fail; b=Oxq7lhWvWq21GNR63IFY4bS87uY/XJ9RHM3EUtrmN8eVxIKM9q3o9uGybDhq+5XScvDI5lMclpk/7pvPOBX4udPWNKESJacnUWq+LQt3jIaZxX4OZ8ZUQOU0eYOGi9ZzaoOO8QdNs6lCPbLQy79Gmv6R/S90aJN0T57dAXMULJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732072473; c=relaxed/simple;
	bh=KR+lCHC2RGowC3w3O3WAycth/Mc6bGL2cVLuf51AGrE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jb/2aveUAhqeXDTmKgPFVBZRZ8tJB+PmPfXg/kiXCmNrDpK55J8MbBlt8qWxwh36oTn6/pAFlX5Lc7BJd4LAQilqdDXnAs7OJsGz4xYQuxl30KHJK23Dj0iwbL039i25/jy7B9J3m8iEswo+Ei154y0Mdw9x4RvFncXOP38WX/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q4tDYvYL; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LHiPqEUckkJB8wRr9iBR5i1kGg/jp2mjIXRM+N77Gqhl+i9najq0yq6qsGFIMsFbvGvJtVPR0vvhLT91yY2XGcYJY6qtjD07L/ydIKDdXt+yObChAA6/Ngdby7BFScpMnC3LouLENQpPGli+R9nneesDMASiwkNPikQa8KJmhqlU+f6DRr70t6/CXYvTDMEwjvuP964DejdoJCkF0Rt4IpqjPBcA4tKf61alSA8S9YE+p1ZhwISg7psNX8anKwuA7hSs1tswcdpTdK7NblO9gEUmsjwWqpTUyOMYJjlEzCxJZSjK2jomRxiHUhowGo6Ep+J96wN4WwgEtZdEiy3hIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDfIu3vM/R6La5a3THsz4CCpFhcV3xLZ1Ug6bNZYpmg=;
 b=yeaOrLjFaFjeqVQtG33NCZa822800pkhk7MDwYg12WMJ+3mbMrvS5YWLmKBzily9wQNjssn3BR9+lq9CTxDVbe/SC7nz1hHqsxG5DH38zdsZSmuJbmiWMNeWglwcIVzqRktn38+A6EWwxC9ToAlmBKussXbXLEaZh30H+ek47W/Ob3GyeCAgjivoS3Gk/qdF2DE+mwrBN3mNBNWwWPGZByHdWV+eYZEb9FobRuW88Fd64mhMKP90y8gWYEGfTudXLGrapbTvsyx7cMBozxg2ql2+hxdLnG0hiiPXrZmu3yakVq1P+MHM1Vkn613MUeP9hS4JIyoWSrifrt1dcA0mjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDfIu3vM/R6La5a3THsz4CCpFhcV3xLZ1Ug6bNZYpmg=;
 b=Q4tDYvYLNNxn9EYtRCTaIHY9stwU6SrzJXwjLysci1WOjgj7Em+yd1g8nvlGQZIaln1ePWqAPwbD9AfZ3uoxfUmztQcLh1G6EO29vvq+rvlKVswJ+edyFI28jBl3u5KWGOS5fbDWPPGy7KG5YoJdDtUTITS/FZo5IN4fy2o1YmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB7801.namprd12.prod.outlook.com (2603:10b6:8:140::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Wed, 20 Nov
 2024 03:14:28 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8158.023; Wed, 20 Nov 2024
 03:14:28 +0000
Message-ID: <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com>
Date: Tue, 19 Nov 2024 21:14:24 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com,
 davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZwlMojz-z0gBxJfQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:805:ca::38) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: e82c0d47-04e4-4750-3fd4-08dd09117176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bi9haHdLY3N5aXhzNXptS0RnVU93U2p5dmM1TGl3STA3VllDbExrSGk2WWpp?=
 =?utf-8?B?YXNyalRld0ZXZ2s4RzVHc3BrbUd1Tjh5cHNoMjVHZjIrMFNvKy93aURIc1JO?=
 =?utf-8?B?Q08wdUhzS3ZOdTZWaGlMc0o1UjQxNEJIQVQrRU1ZZEp2bk5QRmhQRlJpK1BE?=
 =?utf-8?B?bkJoNEFBL3g3THdLMFE0dWtWS0FrQWIzcmJzcFRteEErd3BFeTd4TDhMVmJ5?=
 =?utf-8?B?L1JnbVVqRURtQ0ZPMWJIYStEQWlkdk5uMzh4NW00b1BmWHRmZE5LTkxST1dD?=
 =?utf-8?B?ZW16VDMvbHBWRXRnZUJBY3hCc3NNODlIUndoaE5DbkN6a2FtSlhzUks5U2hJ?=
 =?utf-8?B?dlNnRHAvQTROZGppTzc2QWF3cHE1aWs0MDRsNGdWcHNkRG1RZDZCclBRc2U1?=
 =?utf-8?B?TkxpbjlBS2dxMERJZUdDN0xqcG5Zb3MvMWgrb3FJaUJ4c2dBQy9xSjRvLzln?=
 =?utf-8?B?VkIxSjVhS2tzV0hPNFBHSCsvWjJOcnFaeXUwdXFkd2R1cm10ZCtPZE9RQWVY?=
 =?utf-8?B?dUtPM0hSZUJzaUdmcGs3b1dhZlBFdDVaVWxON3lGQkZ0d2tRUXZPUWxYNmRl?=
 =?utf-8?B?SjRWQk9qdVhiTHdnTGJBVEhxT2F6RFJrd3lVNXlPN2dpcFJoT3ZXVktCOWRl?=
 =?utf-8?B?N1pQZlVoOUIzSS9OUTd6OVJiWFJJRXROaThwMWJpaEtvWWp2M3NvNUU4ck5r?=
 =?utf-8?B?dTY4SnJ3WGswOVZFeDluQUJDK0xyNHN3d1BkQTV1TmRXU3MyQ0dpQXlZTXk5?=
 =?utf-8?B?Y1FPRmhqck5EclBtYnJWNkh4NW5qdVZLcm1pZ3BoVWM1U254ZTlROFVLazJ1?=
 =?utf-8?B?Q0xNN2pyN1Fibmt2c0FnNEhkN3JOTUhKdzhvWFVUVHJVNlJxRFY0alpxNHBo?=
 =?utf-8?B?Z29JNFZPZy9FNDFrVVluaHhJQXVWdWhWMjZJK2lDa3R4bVdjQ3ZFSlN5cWVj?=
 =?utf-8?B?TTdtOEpSMzNoUWtJeThqQko2eHI2WldqUk9zNS9hZjlyd0VIdExzRjY4czZn?=
 =?utf-8?B?ODBWbko1M2g1cmVMTjBkVjFCSk1uZjhPcWg3V3dJV3JMTGhMOTdrOWhhTjdO?=
 =?utf-8?B?MGE4ZlNBbVFYNlk0L1owZE5tOXhOK0N3K3JLdnJ6K1RoYkg0TTRwR2ErZG01?=
 =?utf-8?B?YSt1N1M2NU9QZ0NFS0thaUErMHZTdWtJR29oWkw5QjJnL3VsOVV2aHZFaXJE?=
 =?utf-8?B?K0lRZTFVdWFVTmF1Y1NTWXFsT2pWdE82TlQxeFdUaFB4QnpzMDJGd3V2dG9a?=
 =?utf-8?B?cFFjQUh0UFBTMWhnZXdtVE9zS3Z2ck5ZNXZhYzFMc0dJT3RYT1JQaVFlb2ZI?=
 =?utf-8?B?KzJVNWdKNkxJMVFNaG9HWVlIa21xK3N3MVd5U0E4MHAvcEJ2b3BSTXk1bFdH?=
 =?utf-8?B?NFpsOTRyNjdkRG9mOTZ3SExRb0xwME40TGhWTHlTZFBOMGlKSCtIbzFBaTM4?=
 =?utf-8?B?bklFckxxdS9BNmhNQzk1Z1BQZ0tubUU0MU5Vd21Ub2Z3cDhCS1B3a1BSZk1o?=
 =?utf-8?B?aG1ZRUQwZEpYc01yaDZ5Njg2RUFmeE5TZ3A5Sko1anJ1TDNtZHM1Z29yeGY5?=
 =?utf-8?B?a3duRGEzR0JRVWl0L3hoaWphVTl1Q2E4YkRpcmRqcUFYZ1ZLbnUxSi9ha1l2?=
 =?utf-8?B?bmo2ZzRrV0c4cFdydDdjOTlBaU5XM3YvMFUrVmRKTGNoc1NWVFcxWDh0RWd6?=
 =?utf-8?B?YTNVY2N4WVFhN1U1ck1Pa1ZRMXE4c1dXNklTRm1SdDAvaC9oMUt5REhkZ3pJ?=
 =?utf-8?Q?vgobTUKYLovZaGzngfcJ6rlOX2TLl3JGX0Xho0t?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cldqVzlaM2VYSldPVWh3ZVEwUWxwQm9vT1hIVHlDZWI5QWhiYnhqVmREOWhv?=
 =?utf-8?B?S21mZFhvd0piT1JicHdyWjd3dnlVaEw1dTV2d205VzB1SXFxKzBFSkdzWlM4?=
 =?utf-8?B?MElrOEFQaHlDTmVhMGp3czYyOVBPNXFaMVFQQUlhczlkVDM1NEJwU1FQRFlu?=
 =?utf-8?B?RWh0MHdhTXZFcXl0VDdsUGM5RGNhMmJ0elFDSHpHYUNPVW9QK0xJdEtldzl6?=
 =?utf-8?B?UDYweVJKRzlDcEZ6eGFhdTNsL1dndHdlTTM5WDI4MmM4VmoxSVcwaVNpKzBF?=
 =?utf-8?B?UXNRWWt0UG1tS21MeXk5Mzd3S3ZHaU03Mzl2bERsZmdMVXNKY2MxQ1R0dE0w?=
 =?utf-8?B?YkEwdDJ1bU4zeHdxdHB3Q3JRNnFCVSttNFQ1aldicFEwOTJ1Y2JsL0F4aFRL?=
 =?utf-8?B?ZnV4TklYK1A5QndXZzlrMm5rV0xTV1dxNnNJM2lVUjlUWktPbGxYSjRvNU1y?=
 =?utf-8?B?cjM1cmNLQm94K202NDJhY3JuZU9oaWJ2T2J4bFduTGQ0NHQ0RVZ4MEFiSm12?=
 =?utf-8?B?MCt2NXVOL1U2Q0Q4NmRxaThiZG1PR2VwalJXWklOd2hzbW1SOWJTWThUOFpS?=
 =?utf-8?B?UXc3dWZDT01HTVhublh1MW05RkdYTWZXZnJqc09RbkdXdGFSaXNNczFXQVBO?=
 =?utf-8?B?Z2hScnFBN0Iycjh5em42MVNQRm80QUNreGJYTDU0Z2JwaUxIUURFRFljdGdq?=
 =?utf-8?B?cWNoVXRES0ZMdDlaM0w3bjF5cElXd1kvNDZhYitQa2VmN2ZrWVA1b0puWVhs?=
 =?utf-8?B?T0hkdTIxQnNURDlPMXZ0V2pOYjRXeDg2RDY3ZEZpY2ZjR2tzSFFCb01hTU5p?=
 =?utf-8?B?Qy9UdVFWdjFZWVduU0d3bVBOc1EyNUhXeThKVU13bXM0Y3dmTWh2WXltanB4?=
 =?utf-8?B?NVJkb1FGWTg5UlMzWXNMUFJNRXZIcWJ0UktRVmZJU29sWW5Rbzl6QitkZ1lC?=
 =?utf-8?B?RUVGd2U0cm5hMkkzZnJCeVA1WXBFLzRjZmNxa05tNk5uOFdVRmFEKzRBQmQ1?=
 =?utf-8?B?anFteVZaYTU3TnBVdGQwdzhLREQ5cTk4VUo4d3I0Vjc5VkdkcVVMdzFpTjRG?=
 =?utf-8?B?dlh4dGdWNFRTYUtLcEFIWVNnMUR0Vml3Z2F2S1Axd3B1aDFCbGpFS01LZEJo?=
 =?utf-8?B?WitjL2hPRXBaUUZ4b1huUGdRZHdMRE1oTng1SzZaV3hZMXRobHBvNWFDMndY?=
 =?utf-8?B?WlhRQjN0M2pCSXZpV0RnZ3I3K0xEYUd6aTNROS9xaUMyTTZMOEVrcnRDbGRq?=
 =?utf-8?B?SzJ2alVsVDlFc2dhRGxjMWZTc1doMENjeGJ1Ym95eUdpbS83VlJyUHhxMUta?=
 =?utf-8?B?aGJJRTJJUU9IYVpxcFRjK2NSdTlBZTFucUZhNVVYOTVvREdJOE5Zb2c1bEJP?=
 =?utf-8?B?SXJBZzVjaVNBKzdvbWZmV1dQMFY3eWNwNkVNOEtLV1lxL0diWFRyanFUUjBo?=
 =?utf-8?B?SGFBemdlR05jWkZUZWZWaTVLdnlDdEN5Q2ZUN1JjZE1aZGtrN0dhcGFCdTQ5?=
 =?utf-8?B?WGtxdkd5bExZWVl0eXFtQlBoRmpFaStDbWk5TkY1VDAvS09BcGh4azFBUWhh?=
 =?utf-8?B?VmZTUkRNeUp2UGQ4NkdsSkJzZkRuK0RjMVU0UHF4Tmxlcm8xL3V5WGZoVEYr?=
 =?utf-8?B?MGZNc1FFbGVmYzhQWWhjS0M5b01zVldncWZLcmkvOG00RXJFUGd3c0k2b0Mv?=
 =?utf-8?B?NVY4NXFxTHUxanBEZ0tQclpIZDlTUFZwRlVPajhoRlMrUmhySWdleHNvaml4?=
 =?utf-8?B?TThNR0NocnQwTHNOV0hkN1hKMm5JaXE2T3NkZ2ZyRlF0SjVzQTBTQ29QUnlC?=
 =?utf-8?B?NE5IeStOMjJFWHdPSTZ6ZzlnZHNlc2trckM3U2hZYlJHbmRNeGM0QWp2bzNB?=
 =?utf-8?B?TVBleFd0Yk9uU2d1eVg3ZllxbE5SUFJ6SWgwZk80d1JEazJCaXJnTzdDbzV1?=
 =?utf-8?B?bzMxaU01NmdldExWNnArM2F1d0Z1bWRDVlJDY3NXQkowVEdYMXd1bElReGFi?=
 =?utf-8?B?WDZGa2Q5eEV5TmZDd1VXRUtscTRoY0NoNGZIVmkzdzJqZVliaXlpdFVFNnda?=
 =?utf-8?B?QUhzNkttWXlmc0JPTEFxUkFmZkhtUmlSNjYyRHF6cW9lbUx0M3RrdjJ3a2VE?=
 =?utf-8?Q?OkVN+18Js/1CJRv78BCAl1Tn4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82c0d47-04e4-4750-3fd4-08dd09117176
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 03:14:28.1107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZv1ElDSm9cVc7Bpn00c7iTQ7XoZn3rP6eRYaLFUkN/gacqHHjDgeGphYmOmWdPyHrEHGScSvn2+fYCo3VWu/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7801

Hello Sean,

On 10/11/2024 11:04 AM, Sean Christopherson wrote:
> On Wed, Oct 02, 2024, Ashish Kalra wrote:
>> Hello Peter,
>>
>> On 10/2/2024 9:58 AM, Peter Gonda wrote:
>>> On Tue, Sep 17, 2024 at 2:17 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>> index 564daf748293..77900abb1b46 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>> @@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
>>>>  module_param(psp_init_on_probe, bool, 0444);
>>>>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>>>>
>>>> +static bool cipher_text_hiding = true;
>>>> +module_param(cipher_text_hiding, bool, 0444);
>>>> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
>>>> +
>>>> +static int max_snp_asid;
>>>> +module_param(max_snp_asid, int, 0444);
>>>> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
>>> My read of the spec is if Ciphertext hiding is not enabled there is no
>>> additional split in the ASID space. Am I understanding that correctly?
>> Yes that is correct.
>>> If so, I don't think we want to enable ciphertext hiding by default
>>> because it might break whatever management of ASIDs systems already
>>> have. For instance right now we have to split SEV-ES and SEV ASIDS,
>>> and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
>>> enable ASIDs on a system.
>>
>> My thought here is that we probably want to enable Ciphertext hiding by
>> default as that should fix any security issues and concerns around SNP
>> encryption as .Ciphertext hiding prevents host accesses from reading the
>> ciphertext of SNP guest private memory.
>>
>> This patch does add a new CCP module parameter, max_snp_asid, which can be
>> used to dedicate all SEV-ES ASIDs to SNP guests.
>>
>>>
>>> Also should we move the ASID splitting code to be all in one place?
>>> Right now KVM handles it in sev_hardware_setup().
>>
>> Yes, but there is going to be a separate set of patches to move all ASID
>> handling code to CCP module.
>>
>> This refactoring won't be part of the SNP ciphertext hiding support patches.
> 
> It should, because that's not a "refactoring", that's a change of roles and
> responsibilities.  And this series does the same; even worse, this series leaves
> things in a half-baked state, where the CCP and KVM have a weird shared ownership
> of ASID management.
> 

Sorry for the delayed reply to your response, the SNP DOWNLOAD_FIRMWARE_EX patches got posted
in the meanwhile and that had additional considerations of moving SNP GCTX pages stuff
into the PSP driver from KVM and that again got into this discussion about splitting ASID 
management across KVM and PSP driver and as you pointed out on those patches that there is
zero reason that the PSP driver needs to care about ASIDs. 

Well, CipherText Hiding (CTH) support is one reason where the PSP driver gets involved with ASIDs
as CTH feature has to be enabled as part of SNP_INIT_EX and once CTH feature is enabled, the 
SEV-ES ASID space is split across SEV-SNP and SEV-ES VMs. 

With reference to SNP GCTX pages, we are looking at some possibilities to push the requirement
to update SNP GCTX pages to SNP firmware and remove that requirement from the kernel/KVM side.

Considering that, I will still like to keep ASID management in KVM, there are issues with locking, for example,
sev_deactivate_lock is used to protect SNP ASID allocations (or actually for protecting ASID 
reuse/lazy-allocation requiring WBINVD/DF_FLUSH) and guarding this DF_FLUSH from VM destruction
(DEACTIVATE). Moving ASID management stuff into PSP driver will then add complexity of adding
this synchronization between different kernel modules or handling locking in two different kernel
modules, to guard ASID allocation in PSP driver with VM destruction in KVM module.

There is also this sev_vmcbs[] array indexed by ASID (part of svm_cpu_data) which gets referenced
during the ASID free code path in KVM. It just makes it simpler to keep ASID management stuff
in KVM. 

So probably we can add an API interface exported by the PSP driver something like
is_sev_ciphertext_hiding_enabled() or sev_override_max_snp_asid() instead of using
external variables in PSP driver, which KVM can call in sev_hardware_setup() to
retrieve MAX_SNP_ASID and also overriding max_asid (when CTH feature is enabled) in sev_asid_new(). 

Thanks,
Ashish

> I'm ok with essentially treating CipherText Hiding enablement as an extension of
> firmware, e.g. it's better than having to go into UEFI settings to toggle the
> feature on/off.  But we need to have a clear, well-defined vision for how we want
> this all to look in the end. 

