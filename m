Return-Path: <kvm+bounces-33915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A459C9F4816
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 10:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A98537A34A3
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 09:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC251DEFFD;
	Tue, 17 Dec 2024 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ANLP6jpp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A128493;
	Tue, 17 Dec 2024 09:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734429228; cv=fail; b=A+nBS+mX/3IY2ZML/eTIO8nvKtNfedxns1icMUMV2k+HyHlEKgKPNRfKho7bsGbc4+dO/1dWZeK/YTXd8JwwRYhwQhVhO+PK8C0xTLGTVUitR4g/9Rh8LfxkPd6zPWjhyvafChGrc3Si6mVLFvwUyPBCBUjH6yGiGf6FnAjXgLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734429228; c=relaxed/simple;
	bh=ll1yfOGGS4iZAm+5tOsGdU0fLATj7L7pPGdqKXESHf4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XAP8v9Y0Mn//p1JiKzcJ3SWyNJPA2rN6eOkMc7mEqWhgfLdT2lAbZd5YWA0E+xvQOk+R5FDtz5sJwvqFpz8KaC5hbJlPy5NCk0Px18tx8XTpC+AH/eMdtRWdz7KuFyy/zlAlpKVza2WX2UtWOH5BM21JlYY0mrtTXyFWk2WJVPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ANLP6jpp; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1TVXQhamh4XJgiVLGlTdXjLzMhKfVgKbMAFHa72hd7zcKhb25wyIHMeB5hoiaMuvRJZ78ROEy5hRBDkxFt5FfxZG1SXbMSW4ku2n8m3DVYapH1FJRkfb3CxEUYPZL3cMmM+w1qJmyBwFgwRmTcOpiT0wJ/HZx5pDUFvIciZhfMJPyb2a+QsMB2EMqpOE13dqnDwVoLb4pF+CEDNqQcywyCerLIoNKg7JKTZuVxeP1nexTu0Aqo9PMyuFTbHS1D2IWT+yjvSKmXX1GTYMWAEz0VB5FGB6nlPRLxQq0k3LXVrKRz8phPYGSKzEnsj99iJVcMSVkOSNAg5dk9rSg2Y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xg8sCU6xX5tCwbq4vWxDyc9KDYzrb733CaepmsBhRFM=;
 b=GGGrve01NuHtBJkPxcV94eysdCFTm6obEP+V1eCPGMEYCByXzbw6coQS2QCyMUk9Ow1yxjyq/xXkY77oHZjJ/JE6d/5anjw8CPHrUrkmNIVZLmQtC/IpaSlHdq7MHaNKmuKSkDO1cWf74WeY9wuzVqIQR3YJXUILE156lxSAvOVpfxZc2pg7fjSTf6vRmirEeLfbjEFfGVi+coTxb7EUQojF6uUouFri8LwVuCNhxhNdDrki+o7O2q+HTgnrpluryZ87uTGJw+zHpyxp/NOYuOz7hwAkq5VICFwZ8oKsNr34i+PujtckHpju2cSXCybAHIkr7KZjAHOJ5/1OsT8JwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xg8sCU6xX5tCwbq4vWxDyc9KDYzrb733CaepmsBhRFM=;
 b=ANLP6jppallRK9XjmEvyexPimtUk+wXIubZo+OUdXJHYmzYivCa//Bhfu21x36w0na0ANRUMWa+OSa8Dpi6u+2zeWM0cN1Il/vhyTWtLiJrw2wip93eCPCCLLPIvidhJw7B6OV7l1ZaYAMdlhguy+uT/gNfF6eDT2AG+34xQyOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by DS0PR12MB8443.namprd12.prod.outlook.com (2603:10b6:8:126::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Tue, 17 Dec
 2024 09:53:45 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ec7a:dd71:9d6c:3062]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ec7a:dd71:9d6c:3062%4]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 09:53:45 +0000
Message-ID: <0f207bf8-572a-4d32-bd24-602a0bf02d90@amd.com>
Date: Tue, 17 Dec 2024 10:53:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] cover-letter: Allow MMIO regions to be exported
 through dmabuf
To: Keith Busch <kbusch@kernel.org>
Cc: Wei Lin Guay <wguay@fb.com>, alex.williamson@redhat.com,
 dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
 linux-rdma@vger.kernel.org, jgg@nvidia.com, vivek.kasireddy@intel.com,
 dagmoxnes@meta.com, nviljoen@meta.com, Wei Lin Guay <wguay@meta.com>,
 Oded Gabbay <ogabbay@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
 Leon Romanovsky <leon@kernel.org>, Maor Gottlieb <maorg@nvidia.com>
References: <20241216095429.210792-1-wguay@fb.com>
 <89d9071b-0d3e-4fcd-963b-7aa234031a38@amd.com>
 <Z2BbPKvbxm7jvJL9@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <Z2BbPKvbxm7jvJL9@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::7) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|DS0PR12MB8443:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d775b2e-f7e9-4b2a-14f6-08dd1e80b201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVQxL0Rndnc2Z0lGM3ZpRWRpSUhJQjRIb0M0dUtuREI2UXBlS3hJaERlT0hp?=
 =?utf-8?B?VWh6UnlZMG16K2Y4RjZxSkN5MFdpSld6Um5oTzlWejRIUkgzSm1RMnNPZ0Mr?=
 =?utf-8?B?Q1kyQ242b3BOZWkwM2xGUjlLNEVaWUh2N3BiNzhvdUUrNEhCT0VCcUI2UGtL?=
 =?utf-8?B?WndWZDRFTm9Ya3pQTEE3bkNKTUhMSGtIeENRN28yWk03UVM4cUpTTUhwUVkr?=
 =?utf-8?B?eUZQNnQ2S2tVcWlzYjh2M1FvbzVJY2tFa3Zzam5NajFQM1llNVV0VTVDa2pa?=
 =?utf-8?B?UFN4WjB6ZkNnNFN3RFhoRjFVbW56MlFOMFBscjRjaGE2dm9BUW1NZk0rVTZp?=
 =?utf-8?B?aU9tSVhGSU84cHhXVjBkc042SGxGdm15Y1IyNXhLQ1JiQksvN0ZxdVl2OHVY?=
 =?utf-8?B?Sys2V1RFNzNsY0NERkdnaExieWtNTG1pSjJqSUJ6R1pRK084R0pPTFVSQlVN?=
 =?utf-8?B?ZW1ydkJWZkMyZW9SVzdpckZKQmluRDJ0aUphcHJ1K2xsSENKN1NwWXJXMWlt?=
 =?utf-8?B?ODB4VzdFbEE1a3FEUWY3Q3NNWGhUWnRkUm42UnBkdDVyeUhOcnVBbVFzNktv?=
 =?utf-8?B?QTJYZWNGNWZtbnJXQzV2SzJMQkJ1aXk4QlpFZ3BwQjkxKzF4VUxjbGR1NGxp?=
 =?utf-8?B?SDArZm5wQWxwYnhQNDVVZER6dndBcUVwNXR1QjFIOGVaOHR6MnMyZ2laZTls?=
 =?utf-8?B?TWZwQ3ZKdWFsZlJZa2lLaDZiaWhaeHhJcWNCajY5LzNIOFd3Z0FUSk5yWGVr?=
 =?utf-8?B?cGx5T2h5Y2ViR0NaVWIxSC9kaTBaVjROU2M1ZEZQUnEyd2R3WmsyYVBBQ3ln?=
 =?utf-8?B?QVVEZ3NtV3VuZWQ3R3ZobEdaVVRoblc5TXRRUlIxQWlhZjN4a3ZmVzFCK0xy?=
 =?utf-8?B?WTNvd3lKbDJEcmExbzFNM0REQXh3TjZUekl0cEl1cVlWSlZBL2ZjWEs4Z1Vl?=
 =?utf-8?B?OEduYTRqcTRFMXp2YXNIUU1KOFVIZkxnR2kzdEwvRWJrRy9Pa1lHdmEzVHUy?=
 =?utf-8?B?QW9YRkhWbkdpV3F2cWI3S1pjeU1MUzc0eEdWUHhRbklKMk5rQnBKeWJBckFT?=
 =?utf-8?B?Z2p0b0t4R2VaVnB4TjVHMTAzSDYrQ1NmMm93Ykh6MWIzRFdnbzIyL2pYRDdW?=
 =?utf-8?B?QTB3QkM3aW8ySjludTZWQndaaHpVcGpzK1NxdTVwY2RCS0laZFhlaXEvYkFw?=
 =?utf-8?B?NDYwSE9nR1dPRmpaNXI4dnRCU2dmWlZnZzRaVWttQW9zdlZ6aVIzZEVUaVI1?=
 =?utf-8?B?Ti9kUEg0TFZ6elJjdTJqcitMVDk0MjM4QXM2NmdKK0MrL2N0a0hiTHYyOTJP?=
 =?utf-8?B?V3I4OUhodU96RTlvbWg3V0x2cmlydjUwcGJ6OU9mdGJWSlYwdTFmbldhNmFx?=
 =?utf-8?B?RUtiWDB5NHNreWRKb00rT3dSZXJ0d0lmU2RnK2VXK0lwUjNGL3EvQ2o3WmU2?=
 =?utf-8?B?ZkY5OUJYeGRsc2c0YnVrdzkyclNMT0tKbFp3ZUFueTdReUpDSzlCSklGZisy?=
 =?utf-8?B?WDFaZnpZNWdURFhOTFN2ZUxoSDJQeEpHRlFDckszbWVmL0M1OHgwbTcyS2p1?=
 =?utf-8?B?OHM2dzZaTHJyQTVMeEgzakl0RUYyVTZBTmFudkR6SzF0MzZNdmhEM1Q1TlJW?=
 =?utf-8?B?ZUtjbUFiL3o1WWFSQ1FNTW9Lb0Y2UlNwblBTSmZKTXBYZHBSdEdxZEIrSTE2?=
 =?utf-8?B?ekRSY2Z2ZXNDMkpUcHhEZEc4ZjJZdXdBZVM1TlVnc3R2TmhtM3YrUDZsOFJW?=
 =?utf-8?B?MHZwYVd0aHI3MGdGUlVKY0pwSExSQlZUUUdxYy9VY1hQemNzZDZBV0lQWXk1?=
 =?utf-8?B?U3RQRVprY3I2bktGUjZPZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clNhQWUwdjVSREtaZGtoZHpBMHJJZW5ySVR3RVBDYXpEVjdwVngxMkdhVjFu?=
 =?utf-8?B?TFJjMFlBTmRJb2lROENSQ09aVXNsdEk1K2M3UUZ3WjlXUUZRM0o2N3FqUmp0?=
 =?utf-8?B?cDNlcVZ2R3p5Wm5oSGhzY0k4WER4cjJFVERJdjNYL3dTZXVtbkNvTFAzSEhG?=
 =?utf-8?B?ZzU3OUM2a0ZlK0ZZYkJ1ZUdPYTk2TEwxRW55RDJUS2NXbklocW11ekZkM1po?=
 =?utf-8?B?SlJvYnhGL0tiWlVESEQxWE43Mms0S25jcGJMRlU0RWRHd2hCR281U0J4bk5Y?=
 =?utf-8?B?blpkQmZiSzI4TFdEWEVHazg4QytycXIyb2I0Mk1wdFlOdzNlN05KcFdKSVNH?=
 =?utf-8?B?NG13QjJPOTNBdUcrZzlmQ3RNaWZlN1dQNDhYc1pXL1FWVnZsRldKbjgydzNI?=
 =?utf-8?B?MzdBaHROK3pXWjFJTThrTVovSFA4R0hWNGM1UE1PVUZ5ckIyajI5Q2I2Zk9C?=
 =?utf-8?B?ZmlkSDBacmtoVGdDc1RIbmpCVEZNcWpLWjkrNWt5ZlhTUjNFN0JjQnhSbmtV?=
 =?utf-8?B?dTFFVzgxUThoK2FFamtlRFZsZkFaTXRvY3A5WHZWVUNMamthRlJ4NVpTWlFy?=
 =?utf-8?B?NnAzdTlsQ0huY2F3ZTl2Qkx1ZzdPNko0RDhFSWVmSEZYeExmYTdXaW1xcEh2?=
 =?utf-8?B?V2FJYXhzYVRGSjZWWGttVmVzc3FGbWRFaUVwZlQ4MU1XMXpRd1hhVnltdXEx?=
 =?utf-8?B?NUY5T1VxcXd2RWI4bnBicWYrdHVxV3N3VE45eEpMejB5TVY2N2lvT092ZmNL?=
 =?utf-8?B?Vnp4OUFhbm9wSGd6dTZNUHFjZkZEeWZXUjJmVVhDWlRsMFQveHptQkpocldM?=
 =?utf-8?B?ck0ydTZqZE04T3l3M1IyRHJmQSt2UDVTWkhvT0svcmNaeVlFeHdHUzUrRzFm?=
 =?utf-8?B?QkFmR0M3UERORE9nUU5WNWdGdnU2REpSR014cFB1OEgvYmZNZ0Z0QzlmR3A2?=
 =?utf-8?B?OUxyVkwzYnVyaUg5OW5CMTRIWTJrSWVhT0ZwOUlMenMrbHI1c09CaUpKbUh6?=
 =?utf-8?B?Ym9FZlV5anB5dHRDZVBPeHV1MkJTQmVaQXVHL0dZTWlYZlVTOVdDdFhOOVpR?=
 =?utf-8?B?S2ZhRktQVkJKRXFrMW82VnpPUVBoNVg2Ukk5dEZUWDAvNHY0NEFkcytCR2tS?=
 =?utf-8?B?Y3lQYVRvKzdXeEprZlRsSm9qbVlqcXBWUkNJR3hqM3J4RUVLaFlMOWJLOXl3?=
 =?utf-8?B?Q3pVMjZsMFhaS3I0L0hrU2k0aFFDMDVhR29pdkRUczJZZFVBWnhmek94OVBr?=
 =?utf-8?B?cXJ1Vkd5akNWSUQzSE1ETHlYNEdiOWF6S3RHejhxM0IxbWI3akdXVHhrdllQ?=
 =?utf-8?B?bUYwc2RhWFp3NjBOclUrcUFaN2FyY2ZXaGVVSHhkNTFQWHNkUFY1MEVYWHph?=
 =?utf-8?B?ODFaN2lsd0RWNzZ5U3JmeWEwbjR0S2tFQ1BCWFJoVmZUK2xtcDZOWDdTZENr?=
 =?utf-8?B?WHZlR1pnZnRPRGNGTW9XcjdEMGhUZ2hwU0J3RU5EbC9wbVFTdTEyaW1EL1lW?=
 =?utf-8?B?QjRFTFhrQ3NHUW5XV0dYb2loTk9tOE5PTkxKdW9FemFXZ21sNTZMSjZpazVS?=
 =?utf-8?B?YmE0b1hBTEZXZStwa3I3bDZqYkw2WjhDZHVvdnFDV0FxZHQ0bVZoWnBnblVQ?=
 =?utf-8?B?R1BncnFpZnJpbXF3Mld6WCtRWUg0SXJzeStWbXJvbHVOcFRnZHU3SCtZMWZy?=
 =?utf-8?B?YTdZQTNucWZFQlZmRmlvUHhMM1pNbHVXWVdFS3Ixc3A5ZG1pUW9ralNwNjdk?=
 =?utf-8?B?cFhDZkZEaC9DWDdzdTFsTVl6ZWVkQ0g4TXFzd2ViUkhySjhwakMzTzljZ1J6?=
 =?utf-8?B?MlZFaVhvbXZrRDlNNXFHUzI1VDZ6bk8zZHZyTjd2bUFnWi8wQ1d1c3VqMnFj?=
 =?utf-8?B?Zy9vQmhkc3ZQZWxqYmpQYWxzMDFWWVArV3RoSG9LYXFVRDB1Y21FVWlzaENq?=
 =?utf-8?B?eXBmNWdGNzVNekM3elpVd1puRXBUY3dxU1I4RUpJZ1M1WGdXc2RESGpmRlBU?=
 =?utf-8?B?UnlWT2pjUWRuR3VlcVV5YVBLcDhHVjBtWml5T1JPenBRQUM0NHhYRUIvcktx?=
 =?utf-8?B?RzRRZnBmTTQwUzAyUmxiS2FveWY4aEtkM1JKNXBYbk0wZXUwT1JQOHVLeVNr?=
 =?utf-8?Q?x5SPOuSRoyhz15oTwFV62M7pl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d775b2e-f7e9-4b2a-14f6-08dd1e80b201
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 09:53:45.0301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 935VC2PsN1DzRSapDPeXFbKmbzVaa4eKjafaJQQLZEOSLlM0M44+7c3OQX+KQX1J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8443

Am 16.12.24 um 17:54 schrieb Keith Busch:
> On Mon, Dec 16, 2024 at 11:21:39AM +0100, Christian König wrote:
>> Am 16.12.24 um 10:54 schrieb Wei Lin Guay:
>>> From: Wei Lin Guay <wguay@meta.com>
>>> However, as a general mechanism, it can support many other scenarios with
>>> VFIO. I imagine this dmabuf approach to be usable by iommufd as well for
>>> generic and safe P2P mappings.
>>>
>>> This series goes after the "Break up ioctl dispatch functions to one
>>> function per ioctl" series.
>> Yeah that sounds like it should work.
>>
>> But where is the rest of the series, I only see the cover letter?
> Should be here:
>
>    https://lore.kernel.org/linux-rdma/20241216095429.210792-2-wguay@fb.com/T/#u

Please send that out once more with me on explicit CC.

Apart from that I have to reject the adding of dma_buf_try_get(), that 
is clearly not something we should do.

Thanks,
Christian.

