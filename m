Return-Path: <kvm+bounces-37707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C836A2F676
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B14441655D5
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E1A2566D9;
	Mon, 10 Feb 2025 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wp2aDQ+P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A4C255E5A
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739210914; cv=fail; b=TxTJW5FUjOe4Uj45hSyPAkSgNVvwM+3qpBmpffo/w13omzkueffREvIPq/Bbx2IaUBigzC4Rn5Eor7ivw0nQ/MNxQ4Ej+EMjE9IF6tM+QQ28FndzRWr4CRh7y0WkfBs0+3yLFi3yifftqKNHwdvqC3UKT8l8nvuVSJq3WCzAdSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739210914; c=relaxed/simple;
	bh=fETp6HWvsw89qQJpgTfKPaNM37g+4tKB3jNV4vzzkxY=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=d0fj4JkNnYsKemt64aPnNDHchnbtEmSUCMl4ew8zns2s+ASzz9x18wmUGFdVeJOgaJyDMYzx3t4Un3mT0F2ipojy/slMFFmtyTaK+xZpwdh7Xy7OBPsrY3N7A9CKXHkMnDt+5fJSZp0SiyewHPogmts25ECYzbAEuT4S00rgliU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wp2aDQ+P; arc=fail smtp.client-ip=40.107.220.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nD4Tprsdr8GCZ7ftKvsqoUxn8OTdpF3ODB+QoxzNfDOsWqs/vXjqSpvMqL5zLt558MMzFO3lSyRBNw/ZuUwvJuwb2jCkePvoEZc+T/5RsqZr09rHEDktgnF6vYMae/4z3f96MTRUD4qSDxjEvpulSzkpEKL4gjSkzTR9A0BLTcKWB0vIZwLlnmYEW7q52Ykp3MOdRKciPZ8TtzSXZNx2whY9VhwHugPLAr9KKTHYNW2PFG1Li/Kf+qhd6lE+p3A6RA0x0uTi7wSXQQW+f2Gtgs0zMOl4vPqj+0Uq/jWqVIQluHcCb+OaC/VRIsY3JUt1ROzTtjIzlb1nHpU7yw0Ysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/33JxauDs1lS+J73Q5JnuKEga8Jf9wXtuKw6frQm64=;
 b=QvxnVm8o3L7KdKlc3ksvDBhv90VxRGB/IqjeUMPvDL5ZXDG2RkObfG3xulmx+k2aHTCZWkt8uH6sTZ4ikk00TEZlYYaTFENL7Ughn+AdQ4UPDRdBADXcsGuLT8bl3ivo5BAB2ZdewG7kWMeflYo35fgwMLCa+wME5VxsHeURINoY11aaudHpP2L8QI1SHnmC7RtwWW/cNyVOKxsqeCF2vIpHJvhzSbrpxJnyMedBQC/XPFeoLjPo5g2FWCHKiW+hpI6O9bPGmw2VNjAprrDAMpqU9DKL6Lhi0SuNtlkprKNglOl9pb4jHpEiYx88izMnOWBdomctSoekHNHFWJvJTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/33JxauDs1lS+J73Q5JnuKEga8Jf9wXtuKw6frQm64=;
 b=wp2aDQ+PDX0YziMuot+VmQ0LpXjyw5rWZ4a32LihKKspyFD6MAWObeFeYEJIOKh+x6zerifUA3EdBLUw2ULVD3M+X126dYrtloCXOMko3DMZUaFc2kNpQdyrC1etqVKKjuolhKZVPbFBvEdJUB6/4S115ubitsS9D6FYy1+adCg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CYYPR12MB9014.namprd12.prod.outlook.com (2603:10b6:930:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Mon, 10 Feb
 2025 18:08:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 18:08:30 +0000
Message-ID: <4eb24414-4483-3291-894a-f5a58465a80d@amd.com>
Date: Mon, 10 Feb 2025 12:08:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Kishon Vijay Abraham I <kvijayab@amd.com>
References: <20250207233410.130813-1-kim.phillips@amd.com>
 <20250207233410.130813-3-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
In-Reply-To: <20250207233410.130813-3-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0016.prod.exchangelabs.com (2603:10b6:805:b6::29)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CYYPR12MB9014:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bd10857-e2b7-4cb7-bf8c-08dd49fdec6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1BBU25hN0JOWEVxYlVUc0FxeVkxT1k2eEtSQ25DL2llN0VjcHlDbEdxQ0N6?=
 =?utf-8?B?NUJSRy9VMVVTQVZDVENUSFVNamV0YkxMQmJ0U0crd1I1bzhacDRQM0k0dldM?=
 =?utf-8?B?ekNpeVA3SndqWHdpSHptcVptaHIreHprUWVqTTM3c1lUbG5XU3U3aWpWeG0z?=
 =?utf-8?B?akh2cUhia2RmUWZwV1B5U29tWWpSekNpbGxhTExmOU1Bc3Q1eVgrNXo5KzI1?=
 =?utf-8?B?aTZsRW1qWEZyVVhyYmVNQWtwWDA3ZUVQMW1XWWgvTlF6WkRqVndKMHZmSGlp?=
 =?utf-8?B?angvdWdtSTNtYU1KNzdEdGY0VHRwNlNVSlM1UHNTVWRXMmV3QmFQZnlJUnoy?=
 =?utf-8?B?ZGIxdzhOa2ZhbGdQeFFST3JBRzJPczNicGNDTlFsWUc2RVF3STdOYmlZWmV6?=
 =?utf-8?B?bmdYaHNOQlJyaERacHQvUURJR3htYm5na1lndUtFbUdBdkZpS20zMGQyWE1t?=
 =?utf-8?B?bG8vQlphTjRESVZUYmlVMW4wejV5WFJRV0dIWWJPZCswV2cvaEVxQU9GSXZj?=
 =?utf-8?B?MjdGdEtqeVllcFJ6eTJzY1BjNm9VLzNXWTBEbUN4NmJ0K0NiaDQxS2JrYkg5?=
 =?utf-8?B?UlgwakI0azZBNW5JQjRnNFdZczZ1VHhwWmZWakNpdWd1ZHc4MkcxZ0lOZVVQ?=
 =?utf-8?B?ZHFIOVVid2cyWHdPU01TODdWQ3M1UGxsaWJwSzBSQkZwWU9UZHV0Q3FXb3Rx?=
 =?utf-8?B?dnZlL000dkVmSU9SaTViQWFMb1hoUXhLQlhLS0VET0p3T2d5MHRBUWdGdmJF?=
 =?utf-8?B?M0NWM0Q5TGV4MVd0b1hMamtBRDZwSmNXSUM2cEEyM2dqekFEdytneWprZC8x?=
 =?utf-8?B?MFdJaUFnMk9zR3NjdWZOcFZMdkl5TzhmZXVCN3Q4dW80eXVFWUhudWF3Mmtm?=
 =?utf-8?B?bmt0SDF1R0VadUZaRDJKSGlFcFA3azY2elBaUWpwZFBNVEFZOU5SL1lHWDJV?=
 =?utf-8?B?bjVlS2RBc21LclA4b3dOK3NCNmpqMXlvR2czQ0ZZU0h2WnhMK1lGVmxGL1JZ?=
 =?utf-8?B?SU1vTUNzU0Q0c0RuUTNHbmZKazBnN3hVU0VNclorMTVKOGhFNEZzbHc0QW1r?=
 =?utf-8?B?azRuVlc2ZlVqblk2U2dYcXNLaXBuN3NZaTc4NjUvZFFkK2VlWjFsK1JSUHZ0?=
 =?utf-8?B?SFQwQy9HUmZBQWk5cnlFbHVSZVZVZ1Q0b1pnbmt0aG9WOWE5QTNuK01uR0NI?=
 =?utf-8?B?dXVxODJhUFdGTUNJZElOZTd2Y1QxT1dhcjBKQTFEbjVzNkUrbi9JUEdpajVD?=
 =?utf-8?B?S2I3S3RzNCtlclVzaGpSWGRwSHB6QzBXTGVoZ3R4aThrN3BWNXBiSFVRd2x0?=
 =?utf-8?B?UHAyaktMQmk0MDVVd2dWcUZDcUZLSUgrQlh6ODNzVjJnY0JMaDhzYzFHUG1L?=
 =?utf-8?B?ekNtT1A2MllPcWp3T3FqNFh1NTI0WklXa01PWWhnNXc4bndLWnUybWJyVW8y?=
 =?utf-8?B?QUwvcHZFVksxWGkveVhwSFJvdlBuUW02RTBsaWRiQ3RGcmlpNnpDOCtJMzdS?=
 =?utf-8?B?SmxtdTZqTkVMajdONFhQRnZPOTNzUW9uT0tKeHo1cXlqM1hrL0o2SmUxdmYr?=
 =?utf-8?B?akwyS0Fuc1FNK2tNQURsUWFzWENtUzJPZEwzYzFQb1l6ZGJuTy9zYkw0dnpU?=
 =?utf-8?B?eFRUaEFYOU9Pd2lwNVJIOGpEK09ndzZnczExZWdIcEJ5MXhhSGZLaW0xb2tW?=
 =?utf-8?B?RmwycXpUb1dkUnZScFJDbTNFbW9qNERtWFJ3UzdJTFh2Nm8wTW9kOTFYdEZu?=
 =?utf-8?B?RTRSdzJPQUpnWXNJNllIU0VRbkRDSWgxWmFNaURIcjVqWkFNUWY5Q2x5d25R?=
 =?utf-8?B?SlY1TjB3V2RkUWJVRjZBQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VS9mNEl2dlh5aVFVNzU3azg3ZDI1QWZXTlJtUDFTeE9sRXVma3BablFsb3Zp?=
 =?utf-8?B?S0prVUhXM2VqRnAyeVFHS0RzMUQrS1JndGVubWFzRjl5blBscHZYTmkycnJl?=
 =?utf-8?B?SGRiYlJDYjZtNW84dk9qM01JRDB2TkxLNHhrbS96R2dUWUppVEdBbmY1cFAx?=
 =?utf-8?B?NmxNbXJ1bmI4QXpOUFhzTXdrWDRma0EvN1VMMDdaTWsxUERuQ3Vad3I3N1Vj?=
 =?utf-8?B?Ry95SFZXSTNCTVlqT3cyUlBlWU9CUnFoS0ZLUE1QUEFNS0MyUEppaGp6MjUx?=
 =?utf-8?B?czVodTRoQ3dZSFA4cUlQbVVGL0ZWRkRVZjlYN0lKMmt3V0UvVWRhZS9qS1JN?=
 =?utf-8?B?T1pJZkhwNDM3NU9lV2FSZTFxNFpIblhEcUJHWVlNSUNwM0RkYmt1SmsvbkxZ?=
 =?utf-8?B?bktNLzRXNmhDTmpISlcwMHdTSVlHVWc1SVg2bkFZbEN6Y1RBOFhYSUx3OE0z?=
 =?utf-8?B?TVVHM0FubTVPeGQzeFB2bUNhUUNQRFd2TkVDajRiMHFLYVlKd2dyK1FCVDV3?=
 =?utf-8?B?L2NuNmxubTFuZWsycTMzMlE2R01QYUNJeWdub1c2RjVNTS9vZjNhSkQ4UWFt?=
 =?utf-8?B?M3NNMmVUZFRRNHFmK3RodGE3NmRsZlZzWFV0SE45S0xmVWhWdFR3Tm9RZEtP?=
 =?utf-8?B?WStQN3RPczZkZXFsZENJcFZPb1ZJTTFwTjY0TjNNdEtvYmNFcjVoNHJpaE54?=
 =?utf-8?B?ZHRNZnIwZGh3UUtPaE05emhZbkRaU05DcldmUTBzeGtIZXRsdkZCTmdwUXMv?=
 =?utf-8?B?YkZqcXl1c2w3Z2NuWkp5a0tJWjFOaERtU0Z4Y3lNNkVyekgwYXVWL1NkSFgv?=
 =?utf-8?B?NTB2dnhPOFRpVVdKbVJISk1CbktRZ1BWSHo5aVVWNUYxVlpVc2luZXR5N2I0?=
 =?utf-8?B?b3U2dkRTcmJMRlpXYzJuR1FraHUxYVo2MnFyeW1vUldkbGtZRm1qQjlpbTZO?=
 =?utf-8?B?RnByd1A0eHYwQ1hVTUhLcG1pM21wZnFBRVpHUTgyVEJ0RkhlSHprWFpPUXBu?=
 =?utf-8?B?TENMNndhUE1FbnJpeHkxeFdOdkxDcjR4d2FqejYxeDhXRTlmam02SUZiTDNm?=
 =?utf-8?B?MnRZSFZHa2lWUzJ2emdKbzJid3g1NTVIaGJqNjJrbzlLODlCcENITzBiMWxw?=
 =?utf-8?B?b0Y0UUxoTDJkRks3SnpDYmFvQUdMWWtkZ01BV2ZxVUhiaHpydGRURHFZQUVh?=
 =?utf-8?B?UHZwVVVHbkVETEpWaUJ0b013NjJlRFFZK3dObjN4VWd1dFc2Sy8yb2kyK0dO?=
 =?utf-8?B?NExIVDFJakI2TkdOcFE0K1paUG16STlzWC9KQk1yWWdZaGplUjg0aUtqVWhP?=
 =?utf-8?B?SCtOUmVFbGNnRDJ1d1RZQ3ZGRDdJZnMrM2ExNnoxMUtuNG1zK2ZjaHRNaUxY?=
 =?utf-8?B?Y25FekdLb1NMWFYyZ0xtM2JpdXRSSnQ0Z3ZKcWQydHVxU0lveFdSUjVkdjRM?=
 =?utf-8?B?Yml5MFB5aW9DTm1yWnlZejEzU2Q1dDI5cmU4L2E1eTRMK0lUODNOZk11TGhn?=
 =?utf-8?B?ejA3N3VxdzlyazdYN2MwVElpaG5kVFQxcVVPbDd1UlFkWkFUYlpETk9EZEly?=
 =?utf-8?B?Ukx6akNQR3VDVTUxNk04V1VpQU9UeEZya2hxZWZmVm1hWGF3QjZkZzVRUkdX?=
 =?utf-8?B?SGEyYWFjaUZCcThjeTN4bXQ3ZWF4QnZmVE80bFhaSDVNY3MvYVRqR0JxUkww?=
 =?utf-8?B?RnR0ZzhyYVdOUmNpSFYrWnFySVh6cDJpZjROSUhCMjhUUk40aDBkS2FqNzFn?=
 =?utf-8?B?TStMN1hxU2w0MFh3T0ZMeUxrWVFOU2pOT2FpZTdVZ3lRSlVZbVdqOGFkOUpU?=
 =?utf-8?B?WXkyWDdwSi8xc3QvUW5DcjNVMWJERG5uUEx5MHhqS1hOemVDcERJUW1tcjJ3?=
 =?utf-8?B?TDMxK0dYWEVvc0pINXF1azdIOUFVUkhKWGliMmFUZUQrbEN4VEVwdGVjN0ta?=
 =?utf-8?B?NC90V2JwZlZlM2ZhZnFMV2JMYjVxMW5TaldCY0xDWEExMmNtenZCaHRwUkNG?=
 =?utf-8?B?Y3RTTVduRUlQbDdCd3NtUU9rRnJkUXcwa1Q4V2w0ZXMyRStWZVh6Y1QxOTJR?=
 =?utf-8?B?U0lYRWU1SjF6VWFsb2hCUXpYb1dnK1lWTjduNS8wNVN0Qm52NXBZN2RxTkVo?=
 =?utf-8?Q?JQfDW6SVfxYm6onIUnqSD4LC/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd10857-e2b7-4cb7-bf8c-08dd49fdec6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 18:08:29.9973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1gaesJBYfToY6P/l1fgWP8IK4iT++Go55vFuM4NEEUlQn2xnwcZn8kHc7Jiarc3evSQDxDEIzpWYW9Vp0Av8mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9014

On 2/7/25 17:34, Kim Phillips wrote:
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for, or by, a
> guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
> that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.
> 
> When ALLOWED_SEV_FEATURES is enabled, a VMRUN will fail if any
> non-reserved bits are 1 in SEV_FEATURES but are 0 in
> ALLOWED_SEV_FEATURES.
> 
> Some SEV_FEATURES - currently PmcVirtualization and SecureAvic
> (see Appendix B, Table B-4) - require an opt-in via ALLOWED_SEV_FEATURES,
> i.e. are off-by-default, whereas all other features are effectively
> on-by-default, but still honor ALLOWED_SEV_FEATURES.
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>     Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>     https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  5 ++++-
>  arch/x86/kvm/svm/sev.c     | 17 +++++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index e2fac21471f5..6d94a727cc1a 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -158,7 +158,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 avic_physical_id;	/* Offset 0xf8 */
>  	u8 reserved_7[8];
>  	u64 vmsa_pa;		/* Used for an SEV-ES guest */
> -	u8 reserved_8[720];
> +	u8 reserved_8[40];
> +	u64 allowed_sev_features;	/* Offset 0x138 */
> +	u8 reserved_9[672];
>  	/*
>  	 * Offset 0x3e0, 32 bytes reserved
>  	 * for use by hypervisor/software.
> @@ -289,6 +291,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> +#define SVM_SEV_FEAT_ALLOWED_SEV_FEATURES		BIT_ULL(63)

Hmmm... I believe it is safe to define this bit value, as the Allowed
SEV features VMCB field shows bits 61:0 being used for the allowed
features mask and we know that the SEV_FEATURES field is used in the SEV
Features MSR left-shifted 2 bits, so we only expect bits 61:0 to be used
and bits 62 and 63 will always be reserved. But, given that I think we
need two functions:

- get_allowed_sev_features()
  keeping it as you have it below, where it returns the
  sev->vmsa_features bitmap if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES is set
  or 0 if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES is not set.

- get_vmsa_sev_features()
  which removes the SVM_SEV_FEAT_ALLOWED_SEV_FEATURES bit, since it is
  not defined in the VMSA SEV_FEATURES definition.

>  
>  #define SVM_SEV_FEAT_INT_INJ_MODES		\
>  	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a2a794c32050..a9e16792cac0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -894,9 +894,19 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	return 0;
>  }
>  
> +static u64 allowed_sev_features(struct kvm_sev_info *sev)
> +{
> +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES) &&

Not sure if the cpu_feature_enabled() check is necessary, as init should
have failed if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES wasn't set in
sev_supported_vmsa_features.

Thanks,
Tom

> +	    (sev->vmsa_features & SVM_SEV_FEAT_ALLOWED_SEV_FEATURES))
> +		return sev->vmsa_features;
> +
> +	return 0;
> +}
> +
>  static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  				    int *error)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_launch_update_vmsa vmsa;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
> @@ -906,6 +916,8 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  	}
>  
> +	svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
> +
>  	/* Perform some pre-encryption checks against the VMSA */
>  	ret = sev_es_sync_vmsa(svm);
>  	if (ret)
> @@ -2447,6 +2459,8 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		struct vcpu_svm *svm = to_svm(vcpu);
>  		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
>  
> +		svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
> +
>  		ret = sev_es_sync_vmsa(svm);
>  		if (ret)
>  			return ret;
> @@ -3069,6 +3083,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_es_enabled && cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_ALLOWED_SEV_FEATURES;
>  }
>  
>  void sev_hardware_unsetup(void)

