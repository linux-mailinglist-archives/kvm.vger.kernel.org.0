Return-Path: <kvm+bounces-33460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BA19EC111
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 626B6168581
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 00:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121926A009;
	Wed, 11 Dec 2024 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c9TBX7V6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9291F5EA;
	Wed, 11 Dec 2024 00:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878144; cv=fail; b=VR722rG93LhjSaXT6xr/KWFC6Zkki3UurJjEEfFmvcW4170ShLwb/gN+w6jlfUHHzoA8FPW4ur4fwRnkn+fsefB6lni8NHgEiCeJxygP0UAW6RHp2m/+28IMUxFPW6+Tj48DOcQzoRdDg3SYp8lwCq7b8wI1Hi7RP5SkVEUoJis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878144; c=relaxed/simple;
	bh=cWYHGhGn74YNcV+Ead/ZJs4BWVRlt8/ay151TVUQhLE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=umnA4Ipp0+gEmIaEA/kyphb91i0za9NrV16oHQ5LrMxY+UdTqP3wIEIoXJnD/BzIyqqOFoKYyBkNazB/XszAvSVSOUN2SE7fBwnWn61GrCRqcb7US7cevdTneqYdoWVEeNyr8ylpCEId9yn/AIrKxd/m3GofJl+F/QMmqAKSwnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c9TBX7V6; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VExxez9EHLF8BkyinWFbeofLbFuwuA/6m8OtynR/lTaYEvwpikeSFScwXTWGt0rdWuewr45HZ9IoTzt6CO4cOb2pwa9IXhPkqHRKbtV5VWAWbaiVWCYhiC8EZGNW/Z9xmN5JTb/70RdmpLfHwN7EHlOhFocLdmwW45CYLxqSNUQEbY6AdHoGIX85Q6J6QUB3YqsaSPiBY8Z19SXpZqtANzhKAUcekxq9mPBrr4/lO/V4ZL2ot6w9Gnh+N9fl13Ms9R8uM7nuyws5dusE1guBOYAIRPvP5XdyoasIPHmwdgaSblPne+RXTur0iozks4GwL8amFIYKzW9ytKWfrowH3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cO8H+VpkR6tXBIAhiFpVywCOeXuSiwloefzkzsq+Eu0=;
 b=DodC95V/rXTRlFWWx5P4a3f4eYitIjUeslh20f9KFhA6DGh/TgMJyyLmX/RuBM/cdHQ5NNJGAdfQq7ZGQ5EbOjn/YyKtC6/oi2eWVBt8Ca8rlLtV+eGt2Ju7f8DExKCOJe70+88OPafN83rR/Es5Mxmgcz930LR3rlHOOUENmomTe7RzVA/XPSZgPw0FUhDYCvGmhez4TqAj+DttSInPZ6nphYAThC/p3LDjdigcLJJDXthF7Lyw3vQIS43hwMrVBZsGeybifbAyd39FGfjTmhFgRApkEll/30LYU1lxMOytal0vhqjV9B/BNiEyU3CkD+U5VvXjmIVJl5QRGabA2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cO8H+VpkR6tXBIAhiFpVywCOeXuSiwloefzkzsq+Eu0=;
 b=c9TBX7V6Xc2YfFkRctm7mQlj6CHXu21c+R8VmVawGYTJ9hla/eUiTPHNh7nPlTQeOpuUMD8ROvvevSe60Y8wDVFKS+TuSGLvmbKloLaFDN0jnOza2O4dR8CjHr7lxIysSRcsGclo0mk5twPGle7PsDHELwtMVmgRgsNS/a/hPvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV2PR12MB5726.namprd12.prod.outlook.com (2603:10b6:408:17e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Wed, 11 Dec
 2024 00:48:57 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8230.016; Wed, 11 Dec 2024
 00:48:57 +0000
Message-ID: <8dedde10-4dbb-47ce-ad7e-fa9e587303d8@amd.com>
Date: Tue, 10 Dec 2024 18:48:55 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
 <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com> <Zz9mIBdNpJUFpkXv@google.com>
 <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com> <Zz9w67Ajxb-KQFZZ@google.com>
 <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com> <Z1N7ELGfR6eTuO6D@google.com>
 <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com> <Z1eZmXmC9oZ5RyPc@google.com>
 <0a468f32-c586-4cfc-a606-89ab5c3e77c2@amd.com> <Z1jHZDevvjWFQo5A@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z1jHZDevvjWFQo5A@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0123.namprd11.prod.outlook.com
 (2603:10b6:806:131::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV2PR12MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 675ddd7b-aeb3-44fc-000e-08dd197d984b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDltNG1yaEUwR1VNVTBRT254QTl0RnNGNjRVbTJZdUw0dEMvUE0rd01uZ2hY?=
 =?utf-8?B?R1pqYUNCSy9WYXMrOEVVVDZUMFB0YjVGU1d2ZnkwQWI1RTFCQW5ETHJOYUtW?=
 =?utf-8?B?bFFJeXBjSjNQSWY2VnlzdGpFVzJRbmpPVUExbGdaNGRHZHAzendhWXB6d1hT?=
 =?utf-8?B?bnBwSGE3QktMay9yN1lJNW9SVXA2UThpeFZqWGczVWpGc0JzM0l3QlJuREVq?=
 =?utf-8?B?NHFSdTdtalcwRE1ZSWNOblF2anRsMUtvUHpwOW8rKzJBc3c4bmc3K2JCTVVr?=
 =?utf-8?B?UmNsdkJQbUlHTmRqZUVhVjExVkgzYStpZFFoZlZSclNWT3ljanFXYTJzdGdh?=
 =?utf-8?B?Q0VaSnJNVXFvczN4VUZma1Jyb1E1OFRQTEJaUzY4RG44dmdVdjZnMitRU3RP?=
 =?utf-8?B?LzliMmdkdVdlLzBKZ25Pek10R2VkdHhENkgxb0hxSHd4QzlYODJta2Y2UGhi?=
 =?utf-8?B?ZDdGMmVjZysrRjErZVp3TEpZTHgwUm05MXRRQWNrRFpHb1U5QncvK1R4Wk80?=
 =?utf-8?B?Z0JkYzR6SmE1bFNqbmVZNWF0RmxlaTJEaXFkUWo4am5VTVdtNmVWOS9xdE1H?=
 =?utf-8?B?K0RTbTg2WWpYUDlUL1NnVlIvTW1yNWY4SUttNnphYjlTRkNQRVo1NHd3RGQ3?=
 =?utf-8?B?cDRJbGRPbHlPZHNPMVZId1FTS0hEK1VQTTdGOGdoSGpkMDN4ZStrM1N3Zk9w?=
 =?utf-8?B?SmRNTEM4d1pmSkFYSlNXWDhKTENtY0p5RkV3SG5BZm5RVnZicWhBcGlkd2VD?=
 =?utf-8?B?WVYxejBYMU1nZURobTRDVGdOa3E3Mm1OT0lJckRHZU1waG5aZmw2K2VhQWtJ?=
 =?utf-8?B?WFNSTW1JdDVnTGJmWlpkL0t0WEJFQXJJTVdzeGFhMEdNL3V3cmtkWnRnVXZC?=
 =?utf-8?B?aUtrcVl2T1ZjRGowVmVDSkhMblBRdithcjB3ajJPbFY3R0dXSkE4MkVOZHIz?=
 =?utf-8?B?SzhBWEw4dEZMRGprWUxSVVNJNmdhZ2IyVTRRV00xbXB0R3QwNDgzN2FjdTJI?=
 =?utf-8?B?cExjREM0TWZCd0FJUU1KYlZ6aGE1NTNxbmp0dnNMTExnNFJ5SjZIemJ2bWlk?=
 =?utf-8?B?WE51TWtVS2E5M2gzakNLa1U2TkNVYlk5cFhwM1F4Q0FLKzNIejd4aGkrUjdQ?=
 =?utf-8?B?RG5adjA2aUpTVWpSak1tTHJYU1VJYmFxSFZuZjFqUnJNZ2hNQXMxdC94YWpy?=
 =?utf-8?B?R1lwY1R6RVpHT3RtLysxR0ZaeEk5YWxaK3FQMUNXTjNpWkpneCsybGtFTmM2?=
 =?utf-8?B?dnh6ZHREdk5UdjFQZGxIZmRZMWtmLzE1QmU3cFF3UU1qU3l3RWhFa205bmla?=
 =?utf-8?B?VS9sM1l2OEpFYWZpWSsrSVNHZWxnTmNTM01odGhvMGxQc2lkMHIyL3hOT3F5?=
 =?utf-8?B?M2hKNVRQMFFoQU1rdTRSYVl5MXp1M1FIdkdvcmVDMW9meWhYd0dGNk1ldGhu?=
 =?utf-8?B?bkpaS21ITTU0ZVZiRHlzNnVwZTNVWDdYNWNzRzZ1N0cwaDNEMGRINlNiWUVU?=
 =?utf-8?B?SVM4elVJTTE1Z043N3M4UlNYamN6MGh0MG1xdjFDSUZGRHVlSFRqMUJ2bEhK?=
 =?utf-8?B?SnFzRWRnRlZRTmdYeURQNmxhK3BJZnZGVzArSEFPN0JIMFZ0V1luSzVjMU9m?=
 =?utf-8?B?TVB4TUtIa3dzNjVsSXdYWU1BZGNUK2xScDlOUlFYV2FSZWpDY0NYTkhGN3Vm?=
 =?utf-8?B?ZTRoaEpWUHdhL21RZjNhckY0bnphSkZVNlEybzRuVmRyZlUzZEdRTjhPTHo1?=
 =?utf-8?B?dDk0Q1lqRFhNUjJkUFNGUzMzQmdER3dVQ042MldlUVdCRVpNSURManFMQVZM?=
 =?utf-8?B?ajkra0hXdFdoVGc4ajdYQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmtaYmJVcGFESDdUSytLeGtyTUJpZElIT1R4YUhmRFYrZ1FBNXZocTBBTitk?=
 =?utf-8?B?NVlKcTRiR0JXekdNWE5JV2ZGb1YzalFmN2F2QjR1ZTdVOUVaYkVLRzdKcW9T?=
 =?utf-8?B?SUdVVnltcytaMndoWk5jdXY5emRGcUVtdmJ1NDBLcUJrT2JhaEh3SG9RUnhD?=
 =?utf-8?B?VWNxaE80T2hDQ1YwVjdqY1ZCMnQ4M0JsVFFiWklRVnp1emF3L1hUc1ZsYTFZ?=
 =?utf-8?B?L1MxZm4xZmhXb09GUlhuR20zVHgrRGt3MHc1d2pDMFVmZlJ4aFdTZEpMQ2lj?=
 =?utf-8?B?dXBvNDJhbFplaXBXYXdGdEFLdXlncXl6ay8zeHo1bTR1aXBOeXp6RmZwTWZz?=
 =?utf-8?B?S0dDVnhhL0V0NEkzMUpUUTMrZW1CKzlmOUlPYndab0lnUVVWQ2d2cEtkTC9J?=
 =?utf-8?B?aGp1L0MwUmxacnpkcnVzM3J0andTZVA3RXVCSjVSMkY3SkdsTmxUeUZsejl3?=
 =?utf-8?B?dC85M2hSYzJjeWpsU01ieEZaZ0JIajc3NXIwMnRMVkcyTXJCcm5BeUwxeGhK?=
 =?utf-8?B?YUtkVTVIV2hKemVXR2ZLZXVyVlIydnVQTHZsdDNIeGo2Mm5yd0FhcUk2SHYy?=
 =?utf-8?B?SjR3ZU5yQkJSam5nMFFTOWxCakZ2NUtLejg2cXB3WHNXVzVkaWUrb0JqLzVN?=
 =?utf-8?B?UWg1NGpPV3ZCZlZSWUhoVjZaUnhOVEJkQ3ZPK3Ywb0t5YitrNVlmZytDMXB3?=
 =?utf-8?B?OUFXRG1DYTVhZGhpY1BISEE3N2FnSDJsOC9iYzJoNDBJcjBZS0U4MWxJVFNa?=
 =?utf-8?B?bHdaaFg1VkQxMDFxbm1xaElQdEx5dlJIeTlQdUZwSUgwaVZWNVU5N2RHMEJv?=
 =?utf-8?B?d0MyR3BVWnlULy9sRlVvdDJwdEJQcGk2VkFCWktkc3J0L1ZFOS96M042RDND?=
 =?utf-8?B?Zy84Y3ZudU1LbzIxZm14VXRhS0dtTVBRTktYNEd5VzE0K2hMdHk2SzJiZ2ZE?=
 =?utf-8?B?d1krSEFnRXUyVEtvNmVOM0NCeDQ1dlVuMmZDRFVmRDhZclZCWlRxUWQ1ZDc2?=
 =?utf-8?B?ZG9vQWdxeHhEL1RxN3hPK21CQklxL0VlRVdSelBRODB3T0VsaFRRbDFhay9y?=
 =?utf-8?B?eVoxbWZiNUkxVFROWFRseGVCd2srZDFRU2hPbSt0dFlUUzVqaWlrcDFBTEIy?=
 =?utf-8?B?Yll2RHRZNmd2cVhKMUNzS3pUV0JWUkQvcGpzL1ZHNkFvK01XRS8wYXluY2ZH?=
 =?utf-8?B?anlRaFlrRXpTK1V3TVY2Z3VSTU80YW10T3YvYU5uVDY5WlhWK1VJakRUNFJx?=
 =?utf-8?B?U1Uwc0M4d25zVEVRbVIrVE5vUFpIYlk5NkdBWjNJRE04VmlXZUVOK09UZ2Uv?=
 =?utf-8?B?K2VTOWd1QVR5SkwvTVU5UzNnb3ZPNmxudTBheVdFdlRmRGRNM2tmS2g1bHJX?=
 =?utf-8?B?T1ZPR3NuaTVXSm83QlQ0Q002VDMvTExGUDl5L0t6TmswK1NEVmpLWDRxN1Ew?=
 =?utf-8?B?SXZibGgzcjd2ZTVjMXBYcVIyNzdsSW5OdmEwVzdIRW5VUHkzbGV6NHVhbnhP?=
 =?utf-8?B?ZHRMSDVMQ2ZxM0ppTjY5dlBjOE1mUGkxYW5VaTFJN2dkTDVUdVNYK0crOEZp?=
 =?utf-8?B?N1V5WWh2MkRwYWE0YnFMVFJWVkZqQkFMMkxRV0s0MXA4VFd0c0l5QXZHTFhH?=
 =?utf-8?B?R1U2OU9VeVNRQ0xndnhiaWlRQzdpZElEMjZ5M09VWjZOUURXSncvaUx2dzVh?=
 =?utf-8?B?Skp0bUVHam5vL0FIcS9OSTZCRnVMc3dJVEVhKzZkT0orQkN5OW52Z2ZPcDZV?=
 =?utf-8?B?NE9EUUZCQUtGRnRYZDlqMjl5WG80Vm13UGlTMngxdzJyOXA1elhxc3dPMXBK?=
 =?utf-8?B?eisxdm9UTzNiL2JVWDRTbHBLNVMzbElOY2ttRUtMaEhTY0FXQVQ1L0haVGR1?=
 =?utf-8?B?NTZObmNrWnpSWXZQazk5K2JNRWFJbEdBR3BGZUhPK1ZJN1lJR0VNU1BaUTBn?=
 =?utf-8?B?WGNOc2hCZ1g2RWJ1U2VFM2g2dDlvYThvS0RCb3ZzRlpCYUhuc3VPTVVvakI2?=
 =?utf-8?B?OWdvampjcnZPWjhaYzNyOVJCS3g2dHQzdVpkcnJKdXAvVlZYYmFqL0pHOVlw?=
 =?utf-8?B?OWNyY1IwUzl0TUFldjd0RkRPMUZqemk5Rk9qUmdlaElPWkUzaUl6MmNqSmJN?=
 =?utf-8?Q?r0rCHCbiJm6AYqjIM4B4mMMne?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675ddd7b-aeb3-44fc-000e-08dd197d984b
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 00:48:57.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77Lwff0Xxen1ZgGDuofYtVvReUWK0qnCM1zzK3N9oDcnaCwMxjmymSBZBn0thhL6rvQp4WUPm2U6NBSNwASb9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5726



On 12/10/2024 4:57 PM, Sean Christopherson wrote:
> On Tue, Dec 10, 2024, Ashish Kalra wrote:
>> On 12/9/2024 7:30 PM, Sean Christopherson wrote:
>>> Why can't we simply separate SNP initialization from SEV+ initialization?
>>
>> Yes we can do that, by default KVM module load time will only do SNP initialization,
>> and then we will do SEV initialization if a SEV VM is being launched.
>>
>> This will remove the probe parameter from init_args above, but will need to add another
>> parameter like VM type to specify if SNP or SEV initialization is to be performed with
>> the sev_platform_init() call.
> 
> Any reason not to simply use separate APIs?  E.g. sev_snp_platform_init() and
> sev_platform_init()?

One reason is the need to do SEV SHUTDOWN before SNP_SHUTDOWN if any SEV VMs are active
and this is taken care with the single API interface sev_platform_shutdown(), so that's 
why considering using a consistent API interface for both INIT and SHUTDOWN ...
- sev_platform_init()
- sev_platform_shutdown()

We can use separate APIs, but then we probably need the same for shutdown too and KVM
will need to keep track of any active SEV VMs and ensure to call sev_platform_shutdown()
before sev_snp_platform_shutdown() (as part of sev_hardware_unsetup()).

Thanks,
Ashish

> 
> And if the cc_platform_has(CC_ATTR_HOST_SEV_SNP) check is moved inside of
> sev_snp_platform_init() (probably needs to be there anyways), then the KVM code
> is quite simple and will undergo minimal churn.
> 
> E.g.
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5e4581ed0ef1..7e75bc55d017 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -404,7 +404,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>                             unsigned long vm_type)
>  {
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       struct sev_platform_init_args init_args = {0};
>         bool es_active = vm_type != KVM_X86_SEV_VM;
>         u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>         int ret;
> @@ -444,8 +443,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>         if (ret)
>                 goto e_no_asid;
>  
> -       init_args.probe = false;
> -       ret = sev_platform_init(&init_args);
> +       ret = sev_platform_init();
>         if (ret)
>                 goto e_free;
>  
> @@ -3053,7 +3051,7 @@ void __init sev_hardware_setup(void)
>         sev_es_asid_count = min_sev_asid - 1;
>         WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>         sev_es_supported = true;
> -       sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
> +       sev_snp_supported = sev_snp_enabled && !sev_snp_platform_init();
>  
>  out:
>         if (boot_cpu_has(X86_FEATURE_SEV))


