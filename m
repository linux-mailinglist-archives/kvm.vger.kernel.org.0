Return-Path: <kvm+bounces-52547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C68DCB0692F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 00:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10D66172285
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 22:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB472C15AB;
	Tue, 15 Jul 2025 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kfG6cVF0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E749A1DDC0F
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752618165; cv=fail; b=nce+e7SQqgD1vI1x1Czldt1Aj7OqahxW93E82AnZFltHTj0dZt1PEdy/uxk+MWVKXG5O6yN4V9R99Axf/YrCXZLUkLx8fQY5z2QukzNyivQVWZSyjxxu7P23LVBblb9O74oJaA0BWkDyfV3El9SFULSiQSkjmyd+lhbNGmYCi5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752618165; c=relaxed/simple;
	bh=9wdyXhm/6Y/sVNiWjk035w9bfKReSGFeXbcEwPy8Kuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iFP3aVeeDgVPzy37Gx4CWMatt9Cd+m3fZOtpT/KsRYKXxqcCNX5LkZKa4LUYxMw38azjVGgtJISrHAzPYqXCWgZAQS6okCY6MkfsSb5MinZmrlJCtKUjzomjLN4NjTF9YgrIbHke5voPRPkvstjkIPTho1dLANwYwuxHKLlQgKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kfG6cVF0; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nuHPz4fvR+APTo1QWprY/wwhi/xrH+W9PLIOss+9zK3w6DH6YS1mNaCAeTxHv2uNCGY/dwfThr2Y/Vx8a+abebHHjLjsc8sMO+vXR8uD1VpdcgGUYJx7rlykz+4/ZxpK/cuugPTN57eYyTf965+loU51ncspVBO6LRao71XQUMmveANGatqzoO5AcO9dDK/n7cTdURWB5GZV/ivbb/5lp5/KzFSgisblfUdtl3YmpHwV0BL0de1UmPOtmO/xdGPP+wiJp7/VLhxNRwwBIqxSrjEy2YYpIYo4slJ6epxb7RiHIjjSLFFoaEwwULjYJAWL9UxtYik9mR8+6mS8pdHsUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJr17DcCooXzpV3OGnSuhuOYQmK4BOCmZNtG6yXYHkk=;
 b=q/Dj2O9fvx/PNL9qdRIpsYHtKTneBAQ6iEVQ/8G5oOV5vjlXLGvys8+pDMnyfHS/xAjRL6K8MkM5m0lZHe5H8rlCbLLKYZqLKOZlz4BMKFTdJKaojKC2k2JYTpmjjIeBzOQQ0g3IqYgsM8RJyO6ssQy//TrINVC7gc90kMIa6ZIZj7YYO4odd9D1tJFRuKy4pRqgW19uEydR4CGBeNNHKNcTtPQg3wdTr1b7lCNGffc0UQ9oK7B1NJs4FSCxkP7k9N6bgKFIK8Ufvv0ba41kLTaRYY4k0ehO4apbFSO+/fXgrdQM761ziPOldMIsgMXT6qdFKedA+t0hMEiHwgYecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJr17DcCooXzpV3OGnSuhuOYQmK4BOCmZNtG6yXYHkk=;
 b=kfG6cVF0wBQPtOfVCjiuE9+ORajuo8NKKdWqZL49PBgPAdQU6CLqqnQOomKhAFCIVsjAJYse1vYth7/L+dF7b6eScpmCRpN12WkpuLvrwUYJlKhGsfiWi3Ek36zje8vU8RrUmF+JeHP+2h/BvLwF5C60BP8dkEE2q24R50JQA38=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SA1PR12MB9471.namprd12.prod.outlook.com (2603:10b6:806:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.27; Tue, 15 Jul
 2025 22:22:39 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%3]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 22:22:39 +0000
Message-ID: <0e7bb322-e6c3-409a-ba30-1d8a3a6dc865@amd.com>
Date: Tue, 15 Jul 2025 17:22:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] target/i386: Add TSA attack variants TSA-SQ and
 TSA-L1
To: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
 zhao1.liu@intel.com, bp@alien8.de
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::11) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SA1PR12MB9471:EE_
X-MS-Office365-Filtering-Correlation-Id: a90d0079-d902-4fcd-e1a1-08ddc3ee1bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0dTdkNZZWlLTjFyTWltcnk1Ynk0MmNvcG9WSlErMWY0L09aa0d0TDFzT3dP?=
 =?utf-8?B?eDJRRW1jUlhtY2Q3VlNwdmxrcUVkMHVRTDFGWjJMaGN5aWxMUzI1ZWRMUGVt?=
 =?utf-8?B?L0g1QTNJT3BVVkg1OUNFbE1kQVQxWUFqMnA1SjA1cGVrUWpuNFcxendCTUlQ?=
 =?utf-8?B?R0N3cStNWUVqVkloS052QUY5Y29qVnZmRmNFcG9KbklqQkwyL2RrWVhFSGQ1?=
 =?utf-8?B?a0daS2tIa2lJc3ZuWDl1dzRTdDVWNW9scXc0RnZReG5kMW4yeFJPZUZXWTJs?=
 =?utf-8?B?MlpiUEtJZEpJbExrbzQ2azNnanYrcWFuWU5wdlZvVllIUVJ0TTg2Y2VmTUVm?=
 =?utf-8?B?MFdHWU1uNDgvZHBqYUV3MStpVlR0Szl3Z3lHRHdZd3NhUzNsSW9RYjR4NlN5?=
 =?utf-8?B?aG1jSWlEN1J4bGxwMGU0bmZrUnAycFk1OUFyN1paL1F5TFBuR3luMDZrb2lH?=
 =?utf-8?B?dUxHSXYwQ00zcXZjTkx3VjdyNGRHSHRvUzNCcUpkT21MQVhtQ2dyZ2VISHJz?=
 =?utf-8?B?K2RURStucjFFR2pnVTh4b2tkRENBOFU5NjNUSmNjTW5VSUVaa0l3a2ZMS3lz?=
 =?utf-8?B?ZWs0UGduS29zdC8yT0FkV2Y3c3hVVlhpbFlaVEg5T0M0dmtFRk92L0pMZWNJ?=
 =?utf-8?B?dG81R3FLZkMrUEpMK0loeldjTi9CQ1c3UHVXUVkycGZMUHg0LzZ0bUNGMXpt?=
 =?utf-8?B?Y29tTFU2V1JXaGpIZXlQNDVhVzQ4MWwyYkUxLzRmOVU3UzdBV3dvYlpXL0VR?=
 =?utf-8?B?QjhGR0p5RmlaeHZTWTFEVmxQdDFITTNtUWRUTVQ5TXlQNTJnUW5OSGpINHZn?=
 =?utf-8?B?NkVpVTJKd1B4N0NRL0Z1WnVLcXJZSnZyZGJWV0dKSTJRV2hYdUUvYnZma1Rz?=
 =?utf-8?B?Y2dZQnB3R1I0V2R4TkxTb3RZRUFxVEJuUTd5c2dwRStwZU9pdmxQcFJPWitv?=
 =?utf-8?B?NGRnanc0WTI4YUR1TWplcGROK0ZPNWdJU1dzQ2M5MnJRVU5ZbzVqZGdWOXV6?=
 =?utf-8?B?bGpiZXU5MEJFdmd2Y3pwYXFGMVVmMTFRazRBTFhNQmRXMDZHUm5LYjZpdDhZ?=
 =?utf-8?B?TTBsUlJUb2JOb0VmWDJoNkcwVHhOQ1FnYWpEY202bkRXYUIyL3BtWHhBcTJs?=
 =?utf-8?B?bXRubnZTOFJIcFQ4RG9PaFVPZWRwSDI4UUFmQWRSVkVpMnYrT1F5NXBzV3Ro?=
 =?utf-8?B?ekhGZmh4TTVjOVIxY25XUndFQkh5SDJtZStEUEpZQm1BbTVDN3hKZ0F4dnNG?=
 =?utf-8?B?YURNempmU1ZabW5tMUkrRWkwNExtSk5ZZC9XaE5nNHE0NzB6Nmx3OXNpVHlB?=
 =?utf-8?B?Mnh5RVBiQVBySVMwV0h4VWFxUnA2aGJNdnYyYmRIdW8yU0FLNXRmb1RsNjYz?=
 =?utf-8?B?THlDRjRJS2d0dXVwRjRBMTdJMkxqWlpuaGxrcnZnU1lJRFUvKzhhWkpUbHVX?=
 =?utf-8?B?MmJEM1dmKzRtdjdERmRsR1hRYkxIRSsxSklyWGl1OFZDS1k2OXljOGw0YVpt?=
 =?utf-8?B?SFVFMDVPTVdnTW1UcGx5dncrcjlValZxRW9wdE1rNXNEU3JVVmVwcWxIdnkz?=
 =?utf-8?B?b1ZUWlhuc0pSc0RLMjU4SHhzWVlrUktsT3AxMEdBQVFuQkU3ZmZNWm42QnFF?=
 =?utf-8?B?YWVEYmQ4Mk80YUR0WXgway9JbHJyaW1qY3JNQkhKZ2x2cDRXaldOQmhTSFRj?=
 =?utf-8?B?VEZHRm45Z0FVZG1MU0JoOUVEVE1yZTFYTFpCVVNpamt2LzYvY2pJaTN1U3lq?=
 =?utf-8?B?ZUFERjNkVkJaOGFzN3JTVXE3Ymg5bm8xaHJpMTErZUxuaHdTNVpydEUza2Jk?=
 =?utf-8?B?bnpwTFhYMWxFNlVvU251eGJHb0h2WUtveXE2OEg0RlR4QklraXZrMGNZVzRJ?=
 =?utf-8?B?TWlSUThqeTJPTnA5QzZtZGZ4OU40bkhRNGVWbzRaeWltMkxwT2dzYTFjWEpq?=
 =?utf-8?Q?ILE+oCQI8Ds=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDBPVHNoNkVkNVNSWHFvK0Naa0dOU1RiMjdTUnRDcTBGRVJXcGpPOHZQbFdT?=
 =?utf-8?B?OEwzU3lldjlsanhkOTd4TXhCT0EwelRhYU1DSi9FYkt0VmlYWE9XUThFd1My?=
 =?utf-8?B?TXZlK0ZhSzBCMUpnT0E1UWRLNGpSZFhnODM4RE5IdkFybzROYk9iSDVNbWMy?=
 =?utf-8?B?MDFhSURFZFJFTlN6TUpwd0M5alBFdldPbmdQNksxMUY0WklnY0V4OTQwWVpm?=
 =?utf-8?B?RVArYW1XZjRMd0daY2xQTThYdmpZR1RaUUxqNlFYd29jVS9KcWNJSUVldHR1?=
 =?utf-8?B?aGFncHpwZXg0WEM5RDk3QUlmQ2VTRDN0UUx0bklZaDlYYUgveDdtY3NBMnJZ?=
 =?utf-8?B?cGd2Mm1jdjJ0K0hIcWxGaFVaV1Z1OHYxWldmUzJ4SVRHckhqcUdLS1BsZ1FI?=
 =?utf-8?B?VGE4aWdnQ3l6eTRmclcwRlA4S3BTdS9nK01hUVZGcDIvOU9vTHczeWJyamdT?=
 =?utf-8?B?ZTlJZzhTOXFOSVkxSlk4SU5BbFg2K3VYWGNlM2FoWjgvd1dlYnAxUTNzSlhU?=
 =?utf-8?B?ZDVzVUlCNFpJL0VWV2xnVmFwdUhoU1RuZTZhWGZJZGZGVGxsbmdLcjMyZDA2?=
 =?utf-8?B?SnFGMXJobzY4a3F5YVJyanZYUndGZVJzZXlLQlZTc2EzRTFaeURta2xRRWZu?=
 =?utf-8?B?ZGxjL2I2Sk4rLzg3ZDBrN0dqM0ZXRVMxNWl6Z0FOVDI2Qm5IUjE4WFBKbmFD?=
 =?utf-8?B?SU1JeldGZUdkMXpsZzlJejFGQU1FWnRyUzYxZ003Sk5xQ0xkK0hsaERqc3pU?=
 =?utf-8?B?cDVnY25CQWdacXhaMGllSnZ5bXNHdHV1UkFkQ3piRm9jV1Y3UUxEZlV0ZzFh?=
 =?utf-8?B?VWFRUjM5TWoxZ3U3cXowSW9pZXdZcUR0Q0F6Wjcyd0FRdjhNc0VLYm1ubVZN?=
 =?utf-8?B?bnlqVTdhRkYzU2o3TkxFNHEweUR5alM2aXhnSkE0SEJxb0YxZWNLOFpxc1Y1?=
 =?utf-8?B?Qzg1Q3ozZHR0V3d3S2pIenFqSmxRKzltcUtTK0dxa0dNa3diSVlnRXFoL2p1?=
 =?utf-8?B?WktNZnlvTSs3Y3I4Zi9VdW1rTGlBemlaai9XeWduK3BkMk54ZHl4eVBOQXZq?=
 =?utf-8?B?bCtsU1hwNVBQbFdlQXQvWVFnMHdCb3hOMzI0VjF0bm8yVXphKzhwbU1BUXlV?=
 =?utf-8?B?bGdMOXpjKzAvVExUZzQ4YWNVSTF4cU45MjRNSUp0S0xjMTdqdTBiSW1ZNVdQ?=
 =?utf-8?B?QWQ0RHAwMEFUUnNBQ1E0a0xQSEZkSmdtTDd1YVdjZVhTeTBqWW4rYlVIV1BS?=
 =?utf-8?B?cEtERFVjdncxVmZJUFVnMWtCVmJpQ2o2T0x3cElQRDB4blJTVE1kYzV5Ry91?=
 =?utf-8?B?RFRHRkNjTzczSWYzNGo1aWZYaktqOXJLS3grdUlNU2hrSWZDYmROMVQ3Umcw?=
 =?utf-8?B?RS9JY0pQR3djcmg4aHJQZTBDY0xBRFJsMUlGS1p5UUlQNkg3YkEraWE2U0J0?=
 =?utf-8?B?MmozMUtqU0tRUUxwUjJwRG1tZnNpRjAwbXdlZC9uc2hES2g1MEpDWmhOUGdZ?=
 =?utf-8?B?ZWZYS08xZFdkaGlBSnpiNXJhcXN1ZFVpT2hnZ1k5MkVVOHNrbDN5Y1RaOXlz?=
 =?utf-8?B?aHBNdlVybS9KVE40RGF2UGd1aHJRcVZPeTE3Zm5Md1I3Ykx0dHBVeitCT3A3?=
 =?utf-8?B?SkwyRkdDZXp2R1JnVGJ5ai9hWGQyUCtVQWY2M0xhMndHV0tMSElKTTlLamVM?=
 =?utf-8?B?L3FHTS9sMzRwcWd4WnlqQTRWZXN3Yy9wbm4vL3ZDWXhENElWTStHd08vOXJz?=
 =?utf-8?B?TjJ0cVFzUVFveUoxclZtTVlROXVEcndkOEZhV2tmWVQ4V0NHNm1iTm5ueXN4?=
 =?utf-8?B?RHh4R2o2NXBkNzZHalYzekRZQlg0NVkrMEZSMGdBazk1QThXSnd5OXk5bmQ3?=
 =?utf-8?B?NTVzZm1kRGxCaVlmRkZSd3BJZ25nZzQvRTNyL3FLZ0srd3ZiYlVaclVFd0w1?=
 =?utf-8?B?aElLQm1ubXRveFg0eTBHMDZwNnRnMDI5cHdEK2VWK1QzQkFlNlFORXYra29a?=
 =?utf-8?B?MGxIV1pjdEs3SW9QQVpuNSs1Y1hiNEZOcGZybERBK0hpQVR0UnIyMWZvN0tW?=
 =?utf-8?B?SXI5SjUzK08xMzdNYTJZZ1NVSFliUklhRHpOOGJxU1JZOTZQRnhkb2tWT0Nw?=
 =?utf-8?Q?rS80=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90d0079-d902-4fcd-e1a1-08ddc3ee1bc3
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 22:22:39.3994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caF/zt7y0HtHgQqyrbR9PX8kaNjTklozKWt4JzTvPZ/CBpzY7x6gi6seLKG4XZKk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9471

Hi Paolo,

Can these two patches be included in the QEMU 10.1 release? We are only 
adding bit definitions and not updating the CPU models, so the risk 
should be very low.

thanks
Babu

On 7/10/2025 2:46 PM, Babu Moger wrote:
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage.
> 
> AMD has identified two sub-variants two variants of TSA.
> CPUID Fn8000_0021 ECX[1] (TSA_SQ_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-SQ.
> 
> CPUID Fn8000_0021 ECX[2] (TSA_L1_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-L1.
> 
> Add the new feature word FEAT_8000_0021_ECX and corresponding bits to
> detect TSA variants.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v2: Split the patches into two.
>      Not adding the feature bit in CPU model now. Users can add the feature
>      bits by using the option "-cpu EPYC-Genoa,+tsa-sq-no,+tsa-l1-no".
> 
> v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
> ---
>   target/i386/cpu.c | 17 +++++++++++++++++
>   target/i386/cpu.h |  6 ++++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0d35e95430..2cd07b86b5 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1292,6 +1292,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>           .tcg_features = 0,
>           .unmigratable_flags = 0,
>       },
> +    [FEAT_8000_0021_ECX] = {
> +        .type = CPUID_FEATURE_WORD,
> +        .feat_names = {
> +            NULL, "tsa-sq-no", "tsa-l1-no", NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +            NULL, NULL, NULL, NULL,
> +        },
> +        .cpuid = { .eax = 0x80000021, .reg = R_ECX, },
> +        .tcg_features = 0,
> +        .unmigratable_flags = 0,
> +    },
>       [FEAT_8000_0022_EAX] = {
>           .type = CPUID_FEATURE_WORD,
>           .feat_names = {
> @@ -7934,6 +7950,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           *eax = *ebx = *ecx = *edx = 0;
>           *eax = env->features[FEAT_8000_0021_EAX];
>           *ebx = env->features[FEAT_8000_0021_EBX];
> +        *ecx = env->features[FEAT_8000_0021_ECX];
>           break;
>       default:
>           /* reserved values: zero */
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 51e10139df..6a9eb2dbf7 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -641,6 +641,7 @@ typedef enum FeatureWord {
>       FEAT_8000_0008_EBX, /* CPUID[8000_0008].EBX */
>       FEAT_8000_0021_EAX, /* CPUID[8000_0021].EAX */
>       FEAT_8000_0021_EBX, /* CPUID[8000_0021].EBX */
> +    FEAT_8000_0021_ECX, /* CPUID[8000_0021].ECX */
>       FEAT_8000_0022_EAX, /* CPUID[8000_0022].EAX */
>       FEAT_C000_0001_EDX, /* CPUID[C000_0001].EDX */
>       FEAT_KVM,           /* CPUID[4000_0001].EAX (KVM_CPUID_FEATURES) */
> @@ -1124,6 +1125,11 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>    */
>   #define CPUID_8000_0021_EBX_RAPSIZE    (8U << 16)
>   
> +/* CPU is not vulnerable TSA SA-SQ attack */
> +#define CPUID_8000_0021_ECX_TSA_SQ_NO  (1U << 1)
> +/* CPU is not vulnerable TSA SA-L1 attack */
> +#define CPUID_8000_0021_ECX_TSA_L1_NO  (1U << 2)
> +
>   /* Performance Monitoring Version 2 */
>   #define CPUID_8000_0022_EAX_PERFMON_V2  (1U << 0)
>   


