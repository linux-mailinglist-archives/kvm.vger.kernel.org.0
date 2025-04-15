Return-Path: <kvm+bounces-43359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6BBEA8A5FD
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 19:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73F013AA2BD
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 17:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A139422171E;
	Tue, 15 Apr 2025 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xRrJ59Tm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D35F21E086;
	Tue, 15 Apr 2025 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744739323; cv=fail; b=lq/tzivkf+Bn8TKN7VS+/jR0YXzYTxQRD4nVpNLYUBXWPRo1y2ycHY81hGy5xab3gXVLevrg36+8gVCTrxDQ6NAEbQp69Cu3a64WVUb/jB6xvw+8yj3TC9GpbROkQkEF0W53C/vK60UONPrVKWwTzLm+2K5yzqheZLP3wHvLCWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744739323; c=relaxed/simple;
	bh=Kri7Whorci1wEmtrgNxALeKH8L1/4mn6Sc195HrjJYA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q7p2AVZyobQtq8lolA0FqCaAB5M0CyoyF/3tyY+IYqOdOVQSf9VWjnxahA1w018IZ/jyT09nejH47/NFIoOCByXBw5zUdamjuzw3r2Mw+RyjlJC73Xk16edQkRvXgUh+tuWKFbN/qCbxEvSWZPy8peiByn0uaZ8ptiDl9CTZtlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xRrJ59Tm; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qL7hu8xYfOz0wfJUtVHsvPHsdggMLdf+bhDkQ/xYbhPG2iYVWrXhGZCl+Jxv42FK0PLmeia0WmcGRWVDUai7EkUxTOfc+ETlUuya5zgynG1lP/IzeO3grmGQCDjd3mU8TK2N7Owf5ioyY8DLLFSs8szalnDZ/Z9RdI7HslPku0408zy5HapAeR/PhWJblDzHMhRcdBXciWtsFgHaoqNK7/1GwFv2rSPCJK8xQlS9to1BoSYJ9hrAjLq5icO1DmFnK0Z1O5dIV7fDfAI9SWRWcCVSTXotzyrCAQsNRXlcyT1EqhHO/Y6CJ44w0bOhODoDD9+LnyAI7JDUoru69tXRjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYxnDUX0DWIp1yxd3JHuRucD4LyY0nPJasaUrM/F57Y=;
 b=kEYCarj5cQtp5SfmYqNZFqWOLnHN8EQ7Gy1BN0XoeNr5LRHr9sJkN8409ln3THMKAlaWVKT8Rf/7nuoZT0YW8Kagof+TJryBJrRfD4+yyA5b+gCvUTb1q9q8Z19QpJH2mEiF4cPJ7MfPwePmmBCdSUl1CcLDnpBg9oKyRSCGCDBdd9D56DR/21ZaYWQOQgGuvcm1JymtTDWV3Xum2FU/URRPbFkaOPF3u4EehfP5RY+8gqheGY7T2K16kelD5OZ782BKVuJnQ2QVwdMfYTu4SCdQrnosZCXosmJ3bOlM16AVM/WP9F0a/HSnpExg6gyZYqn+guaqhHQGsiidk5e4vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYxnDUX0DWIp1yxd3JHuRucD4LyY0nPJasaUrM/F57Y=;
 b=xRrJ59TmQE6CBOe8eJdracxZXpBH+GkkXR0tse/A3jPEoEhaPyMIbwrt7AWZPxkRk0zdRwgx2zZxk1CUC6ILLs+AKJeklgIT3yAF8eebDrrnoVKVcDY6z4+aeDAyPqiv4Si4YywRFZCTCmZtxwuY023xdhZ7QSta/0GNFeT/Xu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.30; Tue, 15 Apr 2025 17:48:38 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 17:48:38 +0000
Message-ID: <fcc15956-aad0-49ea-b947-eac1c88d0542@amd.com>
Date: Tue, 15 Apr 2025 23:18:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
To: Sean Christopherson <seanjc@google.com>,
 Sairaj Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack
 <dmatlack@google.com>, Naveen N Rao <naveen.rao@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-7-seanjc@google.com>
 <0895007e-95d9-410e-8b24-d17172b0b908@amd.com> <Z_ki0uZ9Rp3Fkrh1@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <Z_ki0uZ9Rp3Fkrh1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0202.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BY5PR12MB4194:EE_
X-MS-Office365-Filtering-Correlation-Id: 6634fa96-d17c-4e45-1bb1-08dd7c45c0af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUFsOGRWREdWRTF2eW5HUldITk5KV1BWdzFJR2pYOU4yZzVtaUI1cTVlclh4?=
 =?utf-8?B?NTMrZmZGZUFvdzJCVkRKV3Q4a05qSWJTM1JFemJEMGQ1VHlNK2lRazFpU3Iv?=
 =?utf-8?B?U0J6SkJTUW9jRUp1OHVjbVk4eEtMY0RPN0t5d05rL0RXVUdtNDhMb0l0QVpR?=
 =?utf-8?B?UTQzcmM4cmd1WHVkN0hML3J5SU50aW11YnhmdVdtNG96NmlNNGhYNk9VNXdi?=
 =?utf-8?B?SE5YaHluWHBoSDROZTNqa0ZNS3ZRWXg1VnQ1SFY2Zk9IRWliaXpib1lheWFR?=
 =?utf-8?B?dGIrRGN0bVU4eUpLM1pvdXZzWXduODdHVkZWWjZwU04wOTloN0xGazM4cnlC?=
 =?utf-8?B?Rm9rNkQ4Z1J3eEYxMkdTY0xkdUtQNWZSWUlsbXZRRzlSUHIrV1VkYWRuTk1S?=
 =?utf-8?B?TGY2dGRRWkljZkdLaCtIbW1UWStBRFJ2VTJSczFoWHRiRTFBK3gzY2o3ODZK?=
 =?utf-8?B?ZnQzVEhhSUo0c0locU5weFMvU0c5SUQwaXlZOFhUWHhNUVFmQS9zNlRtalVT?=
 =?utf-8?B?SW04YWNKeCtrVCtMTC90WHZhd0NqZzJXMlphc2drWVpJY3NrVUVPS3k1TjM0?=
 =?utf-8?B?ZC9oZ0lUZGpvdWNydVFhY0FQRXRsd00wSkc4WGM3c2NROU1yQndXR3Nqbmxn?=
 =?utf-8?B?SzFaQzVMdDk0SnpLMTkxUjhQVWdWRUZ4aDU0MW4xaWx5ZFFxbm9Bb0t1Wlp0?=
 =?utf-8?B?QUQ3K3I3aHlEMXBLalByVkV6RFVUQ0Y3SHJ6NkxBN3p2TXJRWVZuUkRWd3Zu?=
 =?utf-8?B?ZytYVzJCK0pTK2tsUC90ZytrWU5laEpZNVJBQVRuTzNuV1dJMmUzRTZ5NWFK?=
 =?utf-8?B?UGJDMkFQMXRVT1VGbDJ3TXB3T2RKN0JQeWFpTzMyeXVzZFNRWXQydGhBS3ZU?=
 =?utf-8?B?djdRRExnSk1DNURycmNxWDRlQ3I3WWlDTTFqcDJPamxFU3dQYUdsUFBiajBQ?=
 =?utf-8?B?NlMvQk5nQjJOcGRwTDc3NDJtRXVRQmxaSFI0NzlWbU9CbEdPWFQ4ZHp4RGFM?=
 =?utf-8?B?N05iNnBRUER0MnJtNXdRSnJET2NDVTZQc3RleFFDOUF3R2xQakF4WERJZXVH?=
 =?utf-8?B?cG9IVjVnUHdodFhOR2FQbjZnOVFkQVo0UWpDbW41c0dYa2VLeFcvUmpxbzJE?=
 =?utf-8?B?czhXUWMrRS8xdHhyNG9tektYK28xVytpaitjakFTQWlNdDRHd25xaHVBRDhp?=
 =?utf-8?B?RHdPM0Q4eVJ1TnQ2WVlSVGpDbUx6d1ZEM2IzTmZiQVFnWWtiQTZvQXFRTE96?=
 =?utf-8?B?QzF6MHlDUk5reXUvczArSlBrbWdieEp2VkdVNktlU05ENkJvU3oycTlPOTh2?=
 =?utf-8?B?ZUhseUxtRGY1KzNwNjZFOXVKS1czOGgwbldnMWpQRGlvbHNnRHU0QSt1eHJh?=
 =?utf-8?B?QXJFUnFDVHJRL01xU1pIYzNjandVa0duTjg2b2lHcmswMnpvTmJLckJ4Y0xh?=
 =?utf-8?B?SVBxQ29LMkthMDJQQ1cwYkRwUjcvVWR3UU8vdCtvOFI0L0JjdkxNNHlaNzRn?=
 =?utf-8?B?blpiS1drcm1TZWEzOTRjTTR2YXI2dDR4YlZiZnRQRzFydWZ2VjZlNmtKVXh2?=
 =?utf-8?B?UVBOc2liQUhvWlpnZ1MxSDhDSHRabVVDZUJYTndVMjVvckM1Umo3TVJqTzFp?=
 =?utf-8?B?YkthM2Y3T29QOG4wc0tWMFZwb0tTeS8yT3d5bVVyZVVnQ21aY1ZUM1NLQVY0?=
 =?utf-8?B?anMzYm81VnBzaDhQdzZONndUS2YwSFY3cVFoalZQSzMxa0xMU0NQTHpPVENO?=
 =?utf-8?B?M3BwdWRmNGFnSDV1djJldVJmZnk1VlJrVStLODRETTNXb29hMU00UGtMMDkv?=
 =?utf-8?B?dFJZZjlmK1hSUXppQTVMVmRXMEVhN2gwdmgvU3hpTmNrcHBrMlFUTEtwQk9y?=
 =?utf-8?B?TDVpMUw1eElCR3VYZ3hWVy9aU0trQThoejZ2OFRvRjFoL1NyN1JIMUt2QWJ4?=
 =?utf-8?Q?7mmV36J+nMw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3dYa2xic2RSYW1KTVd1RUpGUE5pRHVIN0szRFltY2ZSZHk2b051c3dCRjhk?=
 =?utf-8?B?VlordDlkdytGL1FEc3NYckEwOWxlOWJEZTBCYmlpSGx0UDg1WXVrVGVtWDgr?=
 =?utf-8?B?dHNHL0orZ05Bb2lpeDNDdU5SSGpFNTVldHBIanBCZytDMkdKa01vbmt5MStX?=
 =?utf-8?B?THQ4b3UvZ1VpNlFackpQNHhKL3hod1FBakFxYk1TVklvMnQ1OVl2dEVaWjdB?=
 =?utf-8?B?Wkg1Z3NpVXVTc2dIdERDL0pWRXhCYkl1Y0x4UEtnYnRXeVdoaEFSZDQvQVhk?=
 =?utf-8?B?QWU1TVBud3QvR0xkQXEyVCtTcjJMSjJUaUtsUzlzRWJUdHFndDZWR0xSTXJq?=
 =?utf-8?B?aTI5bnRWMnZJcXFMNzRuMDFlY3pKWldTZCt4THVQMU5TNlJNdkRkcERPZGxK?=
 =?utf-8?B?bGZLdDJRUUg0Ym5WUlQ2bTIwZGIrOFJkOFNkTGtBWm5kK05pTTUwSys2cTVx?=
 =?utf-8?B?bDhZd3o4QlNwK2dGOGNNbTlYZHJ4SFlnSE1LVVVPQjduWFdUbmdXdGU5TDZW?=
 =?utf-8?B?Qi9ETXZTbTRTQWkrMS9mVjBWOE9PU3phTGRCWDM4OTJaeHlySFFLcjJsK2RO?=
 =?utf-8?B?cWVUaEhRVEljdnlNTlBwWXhEM2hNbGJ6UzREbmc1MkpCQlBFSTNzVEJGaWkv?=
 =?utf-8?B?M3B2bUgrZUhSSGhGNzc1MSt1M3VmK2N3aXJyMDljVzBpVXJBUjlGaDNGOVpX?=
 =?utf-8?B?ZEFjTlRDMC9jVVFFb1VHVUtSM1Awc2djOUJRN0NLNGx1N1dLc1N2V2tHK0hX?=
 =?utf-8?B?VHhLZXhvSlJiWXY1NnV0NVdybjkvZmpQR3hNTEFPSUhNL1lLcGxrcy9zTGpB?=
 =?utf-8?B?NFJRbldQY0hlS1RENjFnaU9hUTRiajBsclFWNW5pK0dHVVlQazFtU25WcWhy?=
 =?utf-8?B?TEllWUpRNDlFby9QVzg1Yi90eVdvT3plUkhwbkVTQzJxT1JrVlpmdFZIK0NE?=
 =?utf-8?B?dU05TnZLWTVCb1k0Mk1WeFZuZlQwTFZxYU9veVZ4K3Z4L0lNb0p6Ky9BSFhS?=
 =?utf-8?B?QVRqY1dCU2dBcG1ERFUxaXZRN2t3blZjcmVTdWlKUW1PQkFwME1Md041T2lP?=
 =?utf-8?B?UUxrN05HUGJSaERQUUJyMlVPN25XMUhyZ0R0bFJwYnZtUGx3a0tnWFhVUEtS?=
 =?utf-8?B?aG10bFcvSkwza3Q0aUhTa0xrdXhXRHJWUlRDanU1OU8vRWtJRnh1M2hCZm9s?=
 =?utf-8?B?aU5hejZiZTlWNHhIeDFGSzJOMzExWlNWVGRuN1pNWmE3S2k5TE5SVjRMVkdu?=
 =?utf-8?B?ek5KbFBISVZMUCt2eUlFeDJtOUVrU1NCTExzRVYydlVMMDZzbWtRNUFZYTB3?=
 =?utf-8?B?bGN5d1J2ZVVoMmFJNWlFVllJSFc5K1VKYTlPSnBjcERKdXQybGtiSS9oZUZq?=
 =?utf-8?B?YzVwODRrRytNRkxjdlpQa001TEwzOVRWR05FSVQvd3NqRThOWVRSTDhteHJV?=
 =?utf-8?B?RWJUakdpN1d2VkdkZXdhQmNscEkxV3UrRnpJYVdoMTB0amVuTUU2cDdrb0ow?=
 =?utf-8?B?M3EzRFZScURYSlY4VUtJWkhFR2lnZHNyNnNaSjF1WE1jVTY4cmVjRkhZaVox?=
 =?utf-8?B?YnFXdFJrYXN5R0VVcFhOMkRMc2lKeFQzWFhLTFRpVU0zTXFnUzZDU0RVZC9C?=
 =?utf-8?B?cjVMMFVOS2NaaU1FMnV3bUxwcFBJWXdiQVR0RWl0NkkrMzh0c2hWdno2emxU?=
 =?utf-8?B?dUhFaE5NaW5IWk0yZ2dla1pQUjY1NGFEbHZPRWk0WUZNRmpKUVVjZ1FUN29J?=
 =?utf-8?B?ZmhNRSs5ZmdWelgyckxvSmRIQUVJMXF2M09SNXhjRkRMMWpldWU0K0FZQ2xK?=
 =?utf-8?B?TmhIZmNmcnVvaUkwQVRteVFmck10YjI0WDR3MjdudEtSTkNla0NSRjFnWDgx?=
 =?utf-8?B?UzI0eVc0NTJ2cEVEOFhRTzFxMnNwT0M2Y2J3QzFsdkZuUk05YlA4QnRUa01B?=
 =?utf-8?B?bXBYTTNxRy9QTUFHL3hQUmNLblRBWXVZQ3lqbXlpUU5mVE5zMEJZaXBTOEVi?=
 =?utf-8?B?QXlWVElROStYdHNaM0c3K3VoL3ZjaWFNMkxGM3VEZTN1RDN0SWE0UkcvUWVT?=
 =?utf-8?B?RWFlMzNnOTFteWo5NWgwc3JrRnN0TlVNZTRvSmtuSEhvQ0J6ZjJUd3V5dlNv?=
 =?utf-8?Q?X3IrbEiHTl1cnrLV5deSqSpZb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6634fa96-d17c-4e45-1bb1-08dd7c45c0af
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 17:48:38.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQQThjP1BJ77znKWuTEY5Ug1ugYdlq2UeCOmrFS5DvJiHdzFRnGKforQ4y1SeSd/ctSVdvRFV762wes/NWzH4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194

On 4/11/2025 7:40 PM, Sean Christopherson wrote:
> On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
>> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
>>> WARN if KVM attempts to set vCPU affinity when posted interrupts aren't
>>> enabled, as KVM shouldn't try to enable posting when they're unsupported,
>>> and the IOMMU driver darn well should only advertise posting support when
>>> AMD_IOMMU_GUEST_IR_VAPIC() is true.
>>>
>>> Note, KVM consumes is_guest_mode only on success.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>   drivers/iommu/amd/iommu.c | 13 +++----------
>>>   1 file changed, 3 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index b3a01b7757ee..4f69a37cf143 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> @@ -3852,19 +3852,12 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>>>   	if (!dev_data || !dev_data->use_vapic)
>>>   		return -EINVAL;
>>> +	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
>>> +		return -EINVAL;
>>> +
>>
>> Hi Sean,
>> 'dev_data->use_vapic' is always zero when AMD IOMMU uses legacy
>> interrupts i.e. when AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) is 0.
>> Hence you can remove this additional check.
> 
> Hmm, or move it above?  KVM should never call amd_ir_set_vcpu_affinity() if
> IRQ posting is unsupported, and that would make this consistent with the end
> behavior of amd_iommu_update_ga() and amd_iommu_{de,}activate_guest_mode().
> 
> 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))

Note that this is global IOMMU level check while dev_data->use_vapic is per
device. We set per device thing while attaching device to domain based on IOMMU
domain type and IOMMU vapic support.

How about add WARN_ON based on dev_data->use_vapic .. so that we can catch if
something went wrong in IOMMU side as well?

-Vasant





