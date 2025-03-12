Return-Path: <kvm+bounces-40830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1698A5DE1C
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 14:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39D147A9790
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 13:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D11D2475C7;
	Wed, 12 Mar 2025 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hzhQMjPO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C7F2417F2;
	Wed, 12 Mar 2025 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741786464; cv=fail; b=WMvxi/3R1ymrsq5ZW3JV2XJU7gK1uTlRlmr69O659bWjRdGBVIcOnjNq6mqDNRic+geGwMQSjCioFOnMKXFFk0wyM9ZspOa5FuN+CHP2CSaHm/x2X+5mEwKO9JgfQIeIR0RVJHrVH4YGoxPqXRstb/AxErCMxDC6xqL15m7JMEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741786464; c=relaxed/simple;
	bh=TXu7XddEwLXG9sycsj/+BlANWxIj7SzphoARRMjbbzM=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p5mIupgAYvr5xZ514Wb6nN5mQq5h7WHymmsPgh53A1DFqO++Tc5zez2ZrBCJRAFQQYc4Y9koU6y9rda5232MWWkmLwXxxQygdUdDXkXC1iKGFbFIeUYxYruhGySbOED1Z+Fj7fnIMfg+9o7r7Q23cjxIKMGPY/eGrZP/JIm9cLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hzhQMjPO; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlz3T+jjAJyvbKUU8qk8wWXqcdnzhA4HGwY9JxtJDxDVD9OA1tDQdg+2tnWSlQooT2mTrIV83VZuAcq84HgiKkAxzFlxgVHPWBInkFtDGLsgQolrHL2Of0GI7vRzTI4/vkhQ6xTHoQjA38SSzuh1VncoxJrD2nl7SusaSrM/85CDG6KcVKA5uwgnVcpxvUR8dH0KFC2k2qMZJtH0WlVTKekxR2DLgV4or7PVyaEAYEhj4CxY4vgp1iZOP8fneVJCSWImsxwSSJgwxRPJXy14qgpwPes9bxoLIKVt/eWtEJ9GZYBbFOeWcz1bvzzwyKCsYS/j5OPrJ78MgGQtpeoChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ga/l4i5GyTumrZTCiUyc1731tQHeoFknpSFgdgJThgo=;
 b=T1Pr4aI3hhxmgke/JpvsbUgGt5ojthFUmdFH6i6MXzSuc/jdqgKMaAmqQKiv3H/Ezbh/E9TUue4kBmUjzFpqlwh0jZ67MI8xcepycNjQOu0vP1MlH8jG8GXONiKuSlYpiv9DWPc4gpWA3UrfPU6JITPiIKctAEfwE6mEN9tjEZnV/r9GuDKnAGTdWfSvbb3q4dFM4oCmcYz95wGmEXDwrBXvM7F0yUr6qeISOA8xV2v8A05Wh0Dr3crTmg/sa/11BENRWJ6T4uAUym9v1Tkic0PD69yfa4SdgUhef/wUjOzGRYw2DA8Qc85p9MnjqUnqaTpzUlEkxet+KLu1RqPsHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ga/l4i5GyTumrZTCiUyc1731tQHeoFknpSFgdgJThgo=;
 b=hzhQMjPOtMkDfJZtO5IpoejeYeK0JXcDooY67M6FWnE+51oLu4+sbGm844Hb/gWbQ9B2WgnwweBodQMRpJ7OGOuFu5NCWQ8C6TRqwu7sDOV5FN19Jo1EjzNBS7dUBxTV20OwlOt2F+aJmSwY/cCXfRnTYo/fH8wZtcf/222BK1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 13:34:16 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 13:34:16 +0000
Message-ID: <a2b711b5-e0d3-4abf-9a21-0553e69788f9@amd.com>
Date: Wed, 12 Mar 2025 08:34:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/8] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <cbd2f5252549d8499a7a0058db17376003317e15.1741300901.git.ashish.kalra@amd.com>
Content-Language: en-US
In-Reply-To: <cbd2f5252549d8499a7a0058db17376003317e15.1741300901.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CP6P284CA0030.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:15d::9) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: aea48e41-caf6-43ff-6652-08dd616a9590
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3g1bG1MUDV6VUZqY05mc0FOUWZ3eGRVUnlGb1c2cGF6akdJZFIyMWNoWWFC?=
 =?utf-8?B?RGxYakMzc2V5UGozNjY4TW1qR2hiSGE1blFxUm56VlRSaDF6U1hzQ2Mwb0Vl?=
 =?utf-8?B?NXpQOXBJUEdGTFFGdjJ4ak1Jb2FKVVlvTWc1aiszcVhzOEMzN09jYWdYR0M5?=
 =?utf-8?B?bjdJVC8rNnArNFQyMFUzOUNsVGhTcHVFYmFyc0haNis1bTgwM01uVFJqckJ1?=
 =?utf-8?B?RnJpd2ZSeitWeHRmNlFhN0RBdjFmYURkemg1bTZWRWE4elErajFOeXYrY0Fi?=
 =?utf-8?B?Q2N4UE93UWRGZ0I4VUtaSjMvVk9ISTQ4VEkzaGZ6aHlObHh6ZjdkWEVQanZD?=
 =?utf-8?B?eDFqbnFGRkdwVExjUm9CUk14UklYYWlyenRqeENmUURNSitVSk9FVzRyOVNm?=
 =?utf-8?B?c3c2cDFkY29zcXROODBXLzNlYmNDVEJ6WXVsYVM0aGdJMEh1aUhJWjdEaVpo?=
 =?utf-8?B?YkMzK3FtbExkYng4U2JzR08yOW0wK0MyYmtxU0pvYXRDY3J0WE9MNXRsL0hw?=
 =?utf-8?B?MnBsb2dORVhTd1ozMnFhZUVadnBJMkUzTDduRTdURVBzNEQvTVNUUmptRGRa?=
 =?utf-8?B?c1p2WFM1TjcyS2M4anREUmJ0Q1hJdDBlb1EyaTdhaFdGbGRaa1FHTVhSNnFV?=
 =?utf-8?B?b1ZLQlY4Y3daVVNwaFo2MjdMcGVaRTJJanNqZkpZVDhQYVg2bHA4TVJmc1VZ?=
 =?utf-8?B?WUpyRGFXU2pyQzB6TEJPREN3R2pZZVBTdytVazFwcVg2MThhQUx3ZXFjWUIw?=
 =?utf-8?B?MGtOUGtYNkhEN1JpQXoxQUZ2emM3WmZFamJ0Ry9vTWs5dG9WbmljTjZSUWhQ?=
 =?utf-8?B?QkZyRk1heUdGYXBQa1pSNkVyRnFtbGxMa25MSjBDVFMrdFE5RDV0ckhIVEdv?=
 =?utf-8?B?K1hvYTl1QWxlWHBvQldXampEOUZuUEl1MFd2OE9XRFJOeHBhWHJtenJUNWxD?=
 =?utf-8?B?VFo1amR1eW9mWVlja25RRGZSdU1QMHo1YzlwWW0xKzRMcW5VTlJhaWNZUUVw?=
 =?utf-8?B?SnM0SmRDUlRWWDZJTVhMZy9Ka1BhWUFrL0dBRS9jekk0SW82SzJRRVQ2Um5F?=
 =?utf-8?B?a1Y0OWFmWDZQSWtTeWkyYi9tMnVlMHYwUjZaSEtPcWZVYW1rWWpYdWpqVHlK?=
 =?utf-8?B?YjQwN1hkYUUzQ2RneFE1dzFpTDZ3czA0dlZpWHMwZUFveXE0TmVjbzV3V0Y2?=
 =?utf-8?B?anlPNmVzQmQ5dlRsR0JEZnIxeTQvd20reENuMEtIUFM2VFVycDVhQjJSVHZo?=
 =?utf-8?B?RVVKRHM0Mk5LWVRvOHM0SlFsYSszdlkxUUx4OFpENU44cXZWTkZWUk9pODRE?=
 =?utf-8?B?MEhUampKbGVFU0JOTVU4N3ltVm5Wc04rQzNpL1MwaFJOQkVQTDZicUhtK1pE?=
 =?utf-8?B?b3lhbGY3R3pqOTUxcUx6eFpTZkY5U2toYjBlN2QvOXVSdkdHQ0tDU3NncUhB?=
 =?utf-8?B?WGQ1eUxBS0lZUno0K01vRW9zNHpVTXJRbEN2SU93bG90akFZTUZDeVU1OGxz?=
 =?utf-8?B?MnJvYit1elh4ZkM5Vnc5ZFQ0ZWg1dzRSQmVjY2RsenJrMWtZRVptNkZIOTdx?=
 =?utf-8?B?Nmx1QitIV1BvMkdKUlIwYmlwb2llY1g1NVBTT040SDRFbXBIbFhkZnR4a01o?=
 =?utf-8?B?bnlrUWpXMXBoN0pGNUcyMGgvTmtJMWxZdEZMdmVzUXBuclVwUHZ2K0tXR2lG?=
 =?utf-8?B?d2F2YmhTUG91a0duekVNYWl4OUFuOUMyQzlxeUVzSFRWMVp5RHFqN2RDcmdl?=
 =?utf-8?B?T0xUWUk5N0MvNHB0ZkRDdUdUekRhdGV1NVF5S1lZcTNKdWRubzZOZGhBdURt?=
 =?utf-8?B?TWZPZCt6YjRwNUsvVHNYbUNmZXJMT3BvMmNlUzB4eFRoUDlaUVA0YjU0UkMv?=
 =?utf-8?B?N3ROQlcvSWlac3NRVWRTRmxBYVdkaTNkZnEwNVVqditkRXVLV0pWUDBtL1JI?=
 =?utf-8?Q?a0ZpR7CJcDM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YStxcXdqbjh3emlZd3F4WGZrMHpKamQ5UU5XRXJKWG9NUEh6VFIvS0FOS1Yr?=
 =?utf-8?B?OXVUQm9La0RyMEUwN1hQQmh3dGtQRHMyRlJDZE55N3c1Zk51aThxMFlYUHJS?=
 =?utf-8?B?UGtuV0ROS28rZ1dVaGtkZUVUMGhGcG5iWE5FMXhhNHFjbTgyNjdzc29pcXBr?=
 =?utf-8?B?a3R1L01CTjFQU3dtU1gvUkk2V09HOTUzRUw2d1EvdzBVQU13dVRiUkZyVzQ4?=
 =?utf-8?B?aDFsYXNOR21NNE8xWGUwSWJFekVnSTlTZHljb1dpQTZkL3BYK1ZxdkQ5Y2JD?=
 =?utf-8?B?akI1dCtlUGkxd29Ob0pncGZvYURnSXRVRHVHaStvY0I2MGQxMEVpd3ZsV21G?=
 =?utf-8?B?M3hva2VsOXZoNHpHY1lrTkJlbk54VlpIN215b1VVbnlFdHVYVHlCU0hwSGZ3?=
 =?utf-8?B?QmVkcGJvcS9mYmV1eUtPbEI3VzN4NTQ4aVhXeUMxUkdOMjlzQlJ2WThhdWRN?=
 =?utf-8?B?MmJGTjNPMERkci8wZTRmbDZpeGQvWHN5cWtEWENaeXhTdFM4eEkwUE1Id28r?=
 =?utf-8?B?OVNqOXpkTGVzVkRmYlN0ZXl1WEtqM0Y5Vy81UWJ1MnUwRjRheHZRYUR0WFMr?=
 =?utf-8?B?aXc5QThCZU9OcFdFbGErV0FvYmhyQ0RxQXN2SW16L2llb1l4MjIxQlZIY3Az?=
 =?utf-8?B?WUx3cW5HQlFRczcwbGVLb05obFlCcGlEWXNBK0NBdDdKTGlWclpqQTJtc3lq?=
 =?utf-8?B?Rnh6N0NHYytQdnVJaHBmUExwT3lWSVlwYzF1OTZjcTAxOWhnUnRyZTVPM0Iz?=
 =?utf-8?B?OEd3NnY1Z0syQWg5SXRNMWxHdTZyMDRqcjNkdEVSZU1lc1NpV0Vsb3BWU2N0?=
 =?utf-8?B?UVpjZDJPbmJyTmxxWkFYUUsrZ25mQ1czaUtvc0IzVEdmek5md05iTkRQL2dE?=
 =?utf-8?B?b3Y0MUlzS3MreE1QK3pibjlPNi9RT2lhemlpMHAydWdoYlhFQVJpK0ZwWEsy?=
 =?utf-8?B?UmZCQXJkSmFkODJIeXQzWmQzQ3YyU3ZMUjRNUFNYMFlCTnZiSW54UElEeXl3?=
 =?utf-8?B?QmQ0dExudCs0eVlsd0N3VVRWcmt6aUlxc2ZWYzYyYmtUVEdnMWJIQ0d2eC9L?=
 =?utf-8?B?NjJBTkdLMXdyNlVLZGdKUllLVVpDMG1qL1FMVXNRTGVmRG01VDN5YTg0OTFV?=
 =?utf-8?B?KzE1eFJLVFFOM2pRYWU5ZVE0UFZoSEtGK2lQc1lORGpJZmF5UmYycFBGNUVN?=
 =?utf-8?B?VnBtdklpamR3NVFSOXg1amZCUXFhVThKdE5VK3pUNzcraml2OVRaNmN4WGJK?=
 =?utf-8?B?T2o0bGFvK0h6QkI3bXJ0ZWtrMzd0ZDNTbjFxd1dhNW1XSnBnVGV4YW1GRGxa?=
 =?utf-8?B?cXpSUkNrN2krWDJaRzF6eVhvK25lZm5XTVhZRXlsNWFseE1xVVdZekE4dldh?=
 =?utf-8?B?emJBc3pSNmVBLzJPYnA0MzdVUS8wSTJxdmhBMXZNVS93SmF5dXdDRm1wTW5U?=
 =?utf-8?B?T2NMd1JuWllHK0Zsek51a2w4dFhla0xpM3RLRmFWeEtsWW1xSlFnZm5VRjFO?=
 =?utf-8?B?TThqNXFPQkF2eHRYODJ1RUVVaFFwd0JQditoSm5zYTU1d3pFZzRYSVphTmo5?=
 =?utf-8?B?aEk2RnRLRnZnaVlhRlIzSmpLeSt1Ty83NzlWMmV6UlhKRzRjVUp1UGtaMk5L?=
 =?utf-8?B?SVl1eUVIc2kwRm5HQzBlQk1kMHhiY0tQazNSYmd1Rzk0bmZkbHpCWENOcVhy?=
 =?utf-8?B?VUNlNW1qZzVCZ0JqQmMzWU1YWGY3TUcvVjI0ZHVmY0VpUzJseTZmUGRJeXEx?=
 =?utf-8?B?MzlZMlQ5c0NyVVpIRnJpRnZEQ0lXd1haVHdTVEIwOVN5VGtqSTJOVWJQNnZi?=
 =?utf-8?B?b2M1U0M0S0o2VC83cHcwWlhHTWRnS2l2d24xSXJaVEZzU2VFWFNrZGFPeTZ0?=
 =?utf-8?B?b1J6ZGNZU3YweUJwT3lPZG1ZMklIZldNOVhSRDZ2Y1dIYlFrZ3F2UkJJd0dF?=
 =?utf-8?B?am9KdFZySmhiWG40R2RmL1dCa3c5V01PR1Q5b3N5dEwyRHloOU5RUnNnYTgx?=
 =?utf-8?B?QzBkbGlXNUhzOUhMalc2TFFqczBTWjVyQnVualp0RFFXQjNiUGxobU5Pa0hO?=
 =?utf-8?B?Zmg4M1J1S0E5T1VSQThUV2N2YUZJVUZNVUFsdDVCUnUvaStoR1k1NGVkaU1n?=
 =?utf-8?Q?pHpKl4ea9YiiH2q4uC4N2JQxe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea48e41-caf6-43ff-6652-08dd616a9590
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 13:34:16.2652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWikiLIPCWcCX5XyrgWyDRaLY3FseK29S3sLnwF/1535NpKYXSt0EDPjDMJV85TIhx+6h9hEYWMD4BJ+wdJECw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395

Hello Sean,

On 3/6/2025 5:11 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Move platform initialization of SEV/SNP from CCP driver probe time to
> KVM module load time so that KVM can do SEV/SNP platform initialization
> explicitly if it actually wants to use SEV/SNP functionality.
> 
> Add support for KVM to explicitly call into the CCP driver at load time
> to initialize SEV/SNP. If required, this behavior can be altered with KVM
> module parameters to not do SEV/SNP platform initialization at module load
> time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
> during KVM module unload time.
> 
> Continue to support SEV deferred initialization as the user may have the
> file containing SEV persistent data for SEV INIT_EX available only later
> after module load/init.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..7be4e1647903 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2933,6 +2933,7 @@ void __init sev_set_cpu_caps(void)
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	struct sev_platform_init_args init_args = {0};
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3059,6 +3060,15 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (!sev_enabled)
> +		return;
> +
> +	/*
> +	 * Do both SNP and SEV initialization at KVM module load.
> +	 */
> +	init_args.probe = true;
> +	sev_platform_init(&init_args);
>  }
>  
>  void sev_hardware_unsetup(void)
> @@ -3074,6 +3084,8 @@ void sev_hardware_unsetup(void)
>  
>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> +
> +	sev_platform_shutdown();
>  }
>  
>  int sev_cpu_init(struct svm_cpu_data *sd)

I am looking for feedback on this patch.

Can we go ahead and merge this patch or are you looking for anything
to be changed specifically for this patch ?

The SNP CipherTextHiding support and SEV firmware hotloading patch-sets
are gated on this patch series, so it will be nice to have some feedback
on moving this patch-set forward.

Thanks,
Ashish

