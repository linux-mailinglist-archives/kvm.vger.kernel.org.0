Return-Path: <kvm+bounces-63040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CFBC59964
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 52359348D72
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 18:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821663168EA;
	Thu, 13 Nov 2025 18:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UtGdr9b9"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88840283CB1;
	Thu, 13 Nov 2025 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060326; cv=fail; b=H4RvFp7I8a2dlq1mWoy/QyOzgjgVPNCg3D3/Clq7LlSrbsD1Nm9Orv3yC1jC++jFXOpic1XEbE7/o4JqsnWq7SPXh8wqFFYAnu2EeD+am+ZFc0OEPrKlKggiyGs2H+nRdxJE10in+pBiArZpAm0GJacnlgKNudxS34waNHJsmis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060326; c=relaxed/simple;
	bh=qP4IGD/hYIb537tIgngYaMVZXbfNKDQ/1RrYS/ggPJo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LlEhxtFLd/sx5V74kVtD6z3DRseSnNBZSoquD6yYvSYTIS45biAjivu3TCjWm3+JlR7fdktuehoE6xlOcPAXdoIJGeXay2psvZ+F5gXkPvwt5JDaS7boM7ZgIQYSpzNH0F5KNBJIWw+l5jYMFKzNef3U3ILD4KZzZeIi6Y+Ynx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UtGdr9b9; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jccslEx+5AI82ymbBBaRPykOrjYQt+DjOdJCs6Dzyr3xdmNfk59DJ447knybyudZzW86ti7JZ2Lj9GK0LLh8N8mkY/7jAopDwjS88yRwzmjCfuTtAQwYH2nc2+pnD/Gfm5ByhtewTTbPVvnbG0GtDrF08f2k8jfi0pGQov2SoFc24dM1eE5aEItAz8s+mSPBd6MlDJgrjC2vlcC9N6Feiiy6TwW9PMl5VcMb+DsdjTv0LZnYV5TY7lqIuhbzH8p0V7DclVSz59HMEgV3RrjC0Is4kgd/Taf8Y10imi2P8yqG0jfcixUX9sW/QQsYXx/HLvfTv/a6uTW4xX5O0R1T3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZ1r3AWCnqGG5ytepOvhxnl/qsk+vgndJqUpbvVIRY8=;
 b=j+4zt/Si/p4EaJ6YSvB61b+hU+ii8soX80dX17Z2RTKXrUm1qPlyCzsJNLwYjcSGWJplo3wFKx+xOFpFtu9d1vi7kcPNAJ7RPc+xlYL64PEKvGYI/tZMrU62gN19g/lJgAFZAmAx6uJuG5OTDxQqUBAsuIMyMIW7fwfv+elr2/wCOsPqyK1cv/FlR3k/k6Ejwif2c3NqWrp/eRp1FRnSiWqP+yOpwlylpgj2dF0VbLTWllDlrHpz3EvOmVUyZquGcdBPY6mc6ouFS6f3OljAG2OlZOBiv25u+MBVShJ0r78W0P8UDsJGb26W+R78yPScIhJpaYMn0ZA95oX1nJCfYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZ1r3AWCnqGG5ytepOvhxnl/qsk+vgndJqUpbvVIRY8=;
 b=UtGdr9b9IKDct7n9kPMT138u6j1FnShHvHb9l8ykKJ+k4FRYZMLevmRcWAGRGvYAqWUoZbXhv8Oc9k2WZa5hm3xmnR/vqP8blj2PpDJftjHFOgDoGkHhBkcNwDyj1X8nVW9F1FjQQuKEp9zoig7WtqcWICL4eiFXYg+cNFzhd9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PPFFEC453979.namprd12.prod.outlook.com (2603:10b6:20f:fc04::beb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 18:58:41 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 18:58:41 +0000
Message-ID: <6e9d3d9d-6541-41ed-994c-04415962a7da@amd.com>
Date: Thu, 13 Nov 2025 12:58:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
References: <cover.1761593631.git.thomas.lendacky@amd.com>
 <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
 <aRYo05KMsaNdj59U@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <aRYo05KMsaNdj59U@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PPFFEC453979:EE_
X-MS-Office365-Filtering-Correlation-Id: 54af9f51-9648-4681-10c8-08de22e6a97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzZwUzc1UW03aDdUTStYN0g5WjJMeXh4a21oanlVMDJ4NFJnNnhhUFdjVmx1?=
 =?utf-8?B?UUNISHk3RWROdVJBdnRtZzh2Q2hWOWUrazVzRTJKd0c0bUdCWkErdjZXODE3?=
 =?utf-8?B?Sm93aUZDMlFyYng1OEo0enk4Q09jTGVHWWhEOXV2ZnV5Tnh1TGlub0FDcERZ?=
 =?utf-8?B?Q3VuTnUyZ3lyYWdrUElzY1V4R2VLK2hPOUFHZjFFbmlLRHk5c2dBdERhdVFX?=
 =?utf-8?B?eXQxWlJOZ2VuZ3JSYmwrazQ1QURIOXpoK1NHUlZXZ1NDTU5qcWY0N3h6Z2dZ?=
 =?utf-8?B?UVlCZHA4akN2NmVDbzBNVDZqMWZaWE5DNSttWmE4WDJjUnExclVvUWdQRWM5?=
 =?utf-8?B?eHBaNUFpQ1hNdWUzWmhtbC9WZmlOYldna3FLeUhNb1Z0dnlWZnlOSUhGdlRp?=
 =?utf-8?B?R0VrRTlvS2hiUXE3K2ttWmlReXl2d043SzFBUXNvMXFrNWVzQStoUzBNcC9r?=
 =?utf-8?B?dERKT3RscmR1YlAvYXkyY24zUzkydFl5T2pXZXM1bTF2ckQrb2xVWVJEb3NM?=
 =?utf-8?B?dFFKd3BGelQxdkMvcXl0ZzF5OGVRV0dzdDVrSFU4LzVKNmkyb1I0ZDVjcTdU?=
 =?utf-8?B?UU1wbldkT3FrdHI4VFRjRG14b1hnd0U0QzFqZzgvdzZ1NmdTa0F3Y0dYS2kv?=
 =?utf-8?B?NTdTK1RVWW5hZVEwbVVTYUwraGVqYXBBazB1SEhNNVVPTG5qRW5rRElBTHZj?=
 =?utf-8?B?bEF3dkVWRXFJWHlTOStudXdvYjJGTHowdVhiRGVzU0VNRFFQVjQ5Nmd3WmpZ?=
 =?utf-8?B?MnozQkdZWTd0bW94TFJXNkRRNUxPQ2NLVTltQnQxalFxU05Xd1BhK2tMeWwx?=
 =?utf-8?B?SzJGTE43cGdtMFZvWFZ2VEJwMk1lWDFYVmtNN0drRGtUUFFVWG9wblozdEcw?=
 =?utf-8?B?N01oZEhGeVRBb2hheWtwMVJaRjc0T1dweUpsVGo4ZzlKQUxXb2xVQi9WZnZB?=
 =?utf-8?B?WWJWUTMvL0EzWXN5Q09OR2NGdGNiOFd2R2U4NHpYU00xZE5QQlVQSmR0ZzBO?=
 =?utf-8?B?T3o2RDhqSnZBVllpOWdDMVFaWERlUnpSclYvSUdXZC9oT0tPeGUxMnEybUZG?=
 =?utf-8?B?Tzd3ZSsxdjJuNkxFLzBkYW81NmxuK2Q0TzUyQUExSVZ2bGJOQnBVQTl1aXpa?=
 =?utf-8?B?KzZaWXQxQk5KaVZ1eVBWREJmbFlDcUdtdjRxbUhWRGJoaVlNVVhjN0VDeWRa?=
 =?utf-8?B?eVUwNnVmWEZHSFBJbkp4VzEwbDl3cTQ5b1lqM0FkSGpJdm9ycVp5WGlXWGVy?=
 =?utf-8?B?bTh5Vk5lMDdsa01FZ1RsM25TWWNmZHNBZ0k4b1Awalk0cjNEcHJpbXZKYVhk?=
 =?utf-8?B?TkdnWEE0SGNpaVpNUXlpNzc3RkYva3ZjQklNMXdNZ2N3R3hJTEdzTnE1dEtZ?=
 =?utf-8?B?L0o3QnAyL0VnaWhGK0FyR1JhR1JFZmZLa09haDl0WS9uSW9vRndHRUErRW1w?=
 =?utf-8?B?d01zUmt0KzdqWE0xZGwzaXNFcE8xOWQxeXRYNWN0SnlJbkZMVFY2TmhZUDZF?=
 =?utf-8?B?bCt6WnE5MW9ndkxESTUxQ3IxWkpKTjVWMHJNdmt5TVdBU1l2dmpkQlc2VER4?=
 =?utf-8?B?UVZLeFBjd0RxR1J4K3Qrb24vU1RGMDh0YjV1SlAveHJZUEpWNWM4ajFMRnhR?=
 =?utf-8?B?S1VOeXhUZVIvYkhJeDJaRnFZNVBsVGpzMmwzVDBKNEh2TmFKbzEvZXo3Qk9q?=
 =?utf-8?B?cG5JOWRkTFZnb2RUQmRJTm9qait4bExZYVZLUkxXMi9YcGJOczZlZG54SWxR?=
 =?utf-8?B?L1dYUGpJdEdhT3VoUmxzSlJ6QkIzMG5wWURRbEs0SFRwNTQvN3haMXpFYzdp?=
 =?utf-8?B?ZzZ1MityYTdXQUJSRDdCOTZobVcvTi9PR0ptcWJUY1dMaGluSS9pa3gwNU9q?=
 =?utf-8?B?b0ZRTEQrUGM4NDNjektNc2RGKzhjY2czcjd0eWozUS8xQVBZbEFtRjRrMEhR?=
 =?utf-8?B?Y3lJYzB5VTVIQWc3amlRNGUvL0F6WjF3QndXaks1cVV0dXNTSHRFcko4NUdK?=
 =?utf-8?B?NU5XbjRnVzBnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUdtV0xvbTUwQVlmdVVmK3BkcGFXMFM0ek1rUitxbmNqbEROeDE0MkZtMkd1?=
 =?utf-8?B?UHhJaS9yMXJpcmZzUjN6eDFUSHN6Z2h5cFlrZzI5c0wxVktxblFXbm93ZmdF?=
 =?utf-8?B?dGV3OWdmWlg4TUFPK0VwejZJT0JidTBIenp3bWtRYXFXbDhvZkIwRmtabUJQ?=
 =?utf-8?B?RjE1TVQwa1I2K0k0ckZQdEgzUWpiKzlocDVjTC9GUHA2OGdCdGtDMzRUTzBI?=
 =?utf-8?B?VTlrcnhyUXl5dGhJV0Q3aSttQTAwSkFjQnJBQmpHcEdzc2UvbEVXMTdieXZw?=
 =?utf-8?B?UUxwM2xJK0JhN21iT29hQ1F4UUx1OEJTOTVxbmYwZ2RSY0FsMXlvdVZDdm84?=
 =?utf-8?B?RGtHYTJFeHJOUit6QThjMm83cjhEc2I4NlZHV01INStKK1o5emlCWTFvd1pF?=
 =?utf-8?B?bG5qa0dvc1NTN1RhYlpZMzdZczdIZTJqYmhqQlo1Yjlya00vK3lsT2RRRkVG?=
 =?utf-8?B?WGtvaXRENWhXZW5mSGN3WkJ0VFRFL3ZCbEpDSDFYWC9ZOFRJUGdOdE5aZllU?=
 =?utf-8?B?Zi9kVTF6aENXbjVodHJsdUhIU1dacG9Td0VxMVdoV2Nxd1YzS3RIdjE4dG0v?=
 =?utf-8?B?d1lHQ1lNdGpNdFJNeEZQRFVSRFVGcStoOE92VVloMlI2bEo1elZ0QXd5TVlG?=
 =?utf-8?B?ZEx5R3NJak42MXN3L05jVy9BTk1kQWxlWEs2ZkVKU0hLd3FrdnBsMi80Yzln?=
 =?utf-8?B?UmgwaVh4dHNjQnNWbG9SNFRnelcwZHZxYjB2SEYyUFRRdHU4UEcxeUwrZ2Y3?=
 =?utf-8?B?MUNXUm56cnFsR25Kb0xldGFWaFlhMDlDQmd5eGJFSHFxNlNtTlVHa2orZmpt?=
 =?utf-8?B?a0tGYVVjNXNCMEJITkJNamZtUURqTnVnQ0dTdTBkWnFvQ1dKRmtZbXhocVBr?=
 =?utf-8?B?L3U5dkMzMkU4RmU5eDRxK3pPUDlCbG5JR0loKzB6NHZ0RkI5Si9ueDVVd0VH?=
 =?utf-8?B?dXp5dnZJYXA1U2RnTmdPN2psVmZad0tPeENTNENSbFlyZlE3cEpRVHVJWjl3?=
 =?utf-8?B?SWJsWkJBZmJvOHltTk0waDI1NVNqMEw1MFZrTDVNc211WEZoczJTWGFpZjRO?=
 =?utf-8?B?SXAzVkt1K3JjZ3V0ZWxYd0VoRU1DeWtuQVZmeFBjRFl6MTlZM2hDd1Q2REJ1?=
 =?utf-8?B?a3lhUGhrS3VhRDBISWU4Q0ZISlE3bFNqVEplM2tzSkFBY3N3SXlGanBHL1Jz?=
 =?utf-8?B?ZXNib29YQWN3V25QcE8rcFhSSjhXbnFUSFljVjZHTzdaN0ZkQnQ1WTFzbmk2?=
 =?utf-8?B?eHNRZmVabjNiVDR4NHNVTnkvWWUzVEU1WGFicjkyZzhEaW9DMk11Q0hWMjRj?=
 =?utf-8?B?STVKK29GajZGT2Z4U2dBemc1Q3lrR2JVaUxMemxudHZJLzNza2JVK0hXYU1D?=
 =?utf-8?B?VE13Rk1XS2pKdUo0cWZZKzZZWElxMVBoZmp2ak1IL0dRRGw5UDFqeDVFMDF3?=
 =?utf-8?B?MEg3VTVGeHRXM3drVElHMGxxTXJmWFIrTklsazI2T2l6MkNlR01QcDZkcVln?=
 =?utf-8?B?NlFTbW92MmdTbVZ3ZG1DVVRNMlVNY0trQ09wZlJWM0VCVmpDWGE2YmdGdHJJ?=
 =?utf-8?B?U0hGMWZKUThEaXpkRUVsRmFjK2YyYXRIQzN0aVdDdlM1WUhvL01EOEc4eGxo?=
 =?utf-8?B?T1FIdFRTUzdOUHc1Rjk0aHQvbUFaOHhyM2h5c2J0aVZYV3ZUK0JGcDEyQVFG?=
 =?utf-8?B?blBzU1JVTy91U1UybUZpN1VyaXlzTlVpTXpLcVZhNC8yZ3g4RjNUN3hQa2Qv?=
 =?utf-8?B?bWJxVWFOamxpVXVxNTExMTh1RUVHejdxNUZnNE9hQzVUL0d5TncvSE9hZHBQ?=
 =?utf-8?B?d1RWcXVxVlF5RStwNW80NDJJY2FTVWFVVlFuOVA2eUpNb2dVNjBVUGswMkp1?=
 =?utf-8?B?cUtRUmV3R2Y2S25rMjRXUFBmK1hrRzExV1JTdjF1NVN3aE5uOGpmemVZWWFH?=
 =?utf-8?B?azFoL2x2cXEwNS90bGRKTnNJelE5WjdmVTZzamxwaGkrUExINnpKTmJZYnFH?=
 =?utf-8?B?NnllbzVlNTI5R1hwaHIyNzBIeFJLZ21XbVFDWnF3OHdRV00wODl5ZlpSbWN3?=
 =?utf-8?B?Q3FTV2F0a2VTVVFFN25QVnZlQVFnR3pZZXdTemRwS1lLNktLeXNnQWxIVHo5?=
 =?utf-8?Q?KVCthUq0wzci1SkJSqITIyObt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54af9f51-9648-4681-10c8-08de22e6a97b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 18:58:41.5980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXCaghjTx5SDxqL0IKKDSGcH248TASjza5IdcapWIc4+yg11yOMqZy1TjHf9vwNM/8CipoFDoZDa46MtJhN6xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFFEC453979

On 11/13/25 12:52, Sean Christopherson wrote:
> On Mon, Oct 27, 2025, Tom Lendacky wrote:
>> Supported policy bits are dependent on the level of SEV firmware that is
>> currently running. Create an API to return the supported policy bits for
>> the current level of firmware.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
> 
> ...
> 
>> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
>>  void snp_free_firmware_page(void *addr);
>>  void sev_platform_shutdown(void);
>>  bool sev_is_snp_ciphertext_hiding_supported(void);
>> +u64 sev_get_snp_policy_bits(void);
>>  
>>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>>  
>> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
>>  
>>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>>  
>> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }
> 
> As called out in the RFC[*], this stub is unnecesary.
> 
> [*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com

Ah, sorry, missed that one. Do you want a fix up or do you want to handle it?

Thanks,
Tom


