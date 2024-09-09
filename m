Return-Path: <kvm+bounces-26130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2437971DDB
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DE531F24117
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804D11531E0;
	Mon,  9 Sep 2024 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QQdw73md"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E204F606;
	Mon,  9 Sep 2024 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725894954; cv=fail; b=GWKsL45wx6uzgPzMWUHAIvpGL35IzTrtjb9SpLjY746zU1bDXe5p+xge6bLPCTHErlrjmiAcLoWqZoIquLtjY5wANKRHqFjKeMm+Xluk9jLh7MQTNaxR25AkSLw9cP5WS71BZMt0SgTWv0C22YWqxzXbRwH7sCssaGjqfzoPy8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725894954; c=relaxed/simple;
	bh=h5ZYlSYmDUz6TMdy1E8y0GzRrwFziUn4bJ0aXHSI5HM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rqfGvuikhwlKwCjmpHQnbYBMaDJOxPCb78N0kjSoGV39JPc6eUf8ZTEOO0IaQsq35ORpD4bgNbMdrt0qjZnmyFVK/Ei1QAyCkn4vfslN83si6YBj4w97BNX+XibyJ1cZY+7pqjmt6u4zwsCp2NuSOFuogCGi7qS3xmqFJmRWNUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QQdw73md; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h7wDli+K7S/dZK3wHN0aI9hR7R/5njLaG3XPyD1OeJ/9PZD0GZ6viqsB9zuSZ619Gr5DeMPF9Dt50jscm1R+UPD4zqHcyihvkvmNW4E+/TABWdvsIfLfXir+XvTQoPtRtclzc5/dVolgWSrI2w2uho6PBtCZfTwRsVqT/vnRGG1N4bSVpFIMXPRWN4Y27763i/43pfCe0PqgUNCtJJwnKw1gAK4AuKWkNDqBiZeGP1mvgPeT05PzsAKjnE1k6jInJ4zUHIBm+H9ek5sA+KK0HteVlX3EnUaM0m9BKwjzA41OfnbQh4EwslR0FGMRenvFHsy+2qpPjeNgc85cUQobiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Kk3JOV8Kvyc6/McT5XVhUiho6krY+2mt/nFUUgoO68=;
 b=ZnOD1p+KG6eoWW5YiS1J5PHI9i0c/6YDIncPsbCaT/TG5SigBCMrcLqrr/VA/3r0PHIV5MFsrQGZcrsOMJaRMJ+OdImeE2qHgY0YZ1C1V1Rm73A6Knc7ks7lPtsF8RVWSY1ddcKNmBJHrjxya1EgS2WHpEg1qXsImEjnHMN0/xXeoBRzV+lD2GoDeli2AFOlbH11iVFmIWGf8W+MZc4I/yRcjSUZiqFfdh2FGmUl5DSfvfBgJ2JGmDW6voNx2jfi0PgKpqS1HGF7SYo9kE3yxv/o775DFkl59wbmiK796PQmQKP/0Nj4J0q+Lz8+zPwDUUhzMHc9+HrSD4vbXzjosg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Kk3JOV8Kvyc6/McT5XVhUiho6krY+2mt/nFUUgoO68=;
 b=QQdw73mdhcQslFAn+ZkV0xNEMhqYaMMGavadjhFYD4oWUBXB1q0kFCXcs5Xem0V7aVaUwyycUL0H4rJX2+uOVpClpGnxsCAY/Sqi33SD5WKsmNYN08aNULaK+yl6ZZ2iBDNsw4CInQB4COYZYK7gmXLH2idPp9ewYcsavGUChhkUBqd7H7k6LV+1l6Q7SDr2c1wlUCfsl50Z78n03xeZ7el3uyEcrAiJ9/g0P/9INJWkkJ1kzwl56JG3vP+34Ed/I5kX0LV2yTfdj9nytZNyfyGFmDIHmooQVAd8R+1MbZWhAxhmf3dgL4L6+XcYzHmbwELBUA0ZYOcym+Hfs3GX+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8194.namprd12.prod.outlook.com (2603:10b6:930:76::5)
 by DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Mon, 9 Sep
 2024 15:15:43 +0000
Received: from CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9]) by CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9%6]) with mapi id 15.20.7939.022; Mon, 9 Sep 2024
 15:15:43 +0000
Message-ID: <5bbb2577-59e8-423e-9e59-cc584d9e09fa@nvidia.com>
Date: Mon, 9 Sep 2024 10:15:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
To: Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com>
 <ff5a11d6-8208-4987-af03-f67b10cc5904@arm.com>
 <d55a24d2-bad9-40c7-8a2e-4a7bebe9c682@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <d55a24d2-bad9-40c7-8a2e-4a7bebe9c682@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0342.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::17) To CY8PR12MB8194.namprd12.prod.outlook.com
 (2603:10b6:930:76::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8194:EE_|DM6PR12MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: 0019fb82-20a0-41e6-9e2e-08dcd0e245d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTJuY3RnWUVZMFV2ams0cnBJUE9IL2hxa0NOV2J4RTg2aFR2cTJPZEx1aWxT?=
 =?utf-8?B?d2Z3R0FxTG82N3liemR1RkJBV2x5R0ZSU05BOUF5eCtIU0hVQkhNMzdnSWRP?=
 =?utf-8?B?Z1VtTHFpVjJPWkhpNVk4MjYzOUdlS0lqV0twNWdvRkduMmR2SGhVbk9VQ1Fm?=
 =?utf-8?B?cUZCTWs2akhKdVRYSUQwU1ZlemNwdGluaTJRNHNJSVc0djJCdU1kWG5XMmZu?=
 =?utf-8?B?VXhIUWxiZnRpdGlrWHB6VkY0NHVyU3pLOXBISFlEcWNFNXZqMk1HU0FTakRa?=
 =?utf-8?B?WHhVWXgyMTI4TFFpQ3gyanI5N3J4YWdWcmJuRW42azhyYUxzZHowbko4STlW?=
 =?utf-8?B?dmRlMW90dVk3dHVZb0NwSEYwTU5EWTRHSnZ0WFdFTVd6Q1d0aVJXYW0vU0l1?=
 =?utf-8?B?RSszdnhtbUY1MGtwcVpoT2VaMHpTWUdobGJiUFhqaFVZVlV0REdnMjVtZERk?=
 =?utf-8?B?NVNFVTJvZGJrUmtkc3FFcFJobmw0Z2RLMzlLMWl0K1lkSElXekgrSFVKTHFE?=
 =?utf-8?B?cFJNam9XRWpvemx6Zmdjd2JKK1VBOUt1R25obklRdXZMOXhVZVM3RnlrMnZV?=
 =?utf-8?B?QU1weVlnWkxvbzJjcngzZElhNkFjdExLT3Zwc2d1MlR3T2tZekFDRDdPa1ho?=
 =?utf-8?B?OC9WYTZmSGpHWFFlcnV4VnozczV0VGdoWXozOUhZZGhsdGFsVTMyUmo5MXBh?=
 =?utf-8?B?S0pBbjQwVGxJYnRqbFprOVpOVmhGenh6SlhCQldWODdaTzNuV0Vwa3pNVmNS?=
 =?utf-8?B?UmNSa3QzS0FkNTFUd2lhL1dXaERTSEZ4N0NkN3dnNTMvdFZOZ2ZvZ0N2Mm1W?=
 =?utf-8?B?cm5sakdXTjUvSko5UytsZWowWGJEcHVNMzgzQUxvTFVHS29oeUVjTjNRMXdC?=
 =?utf-8?B?NmhsWHpYVU5ud3VyY3RYd2NXZW96eW4wTEtJNmVycHVGdDFtb1gyV2xxUFNy?=
 =?utf-8?B?dndGbitKYUhnbWs5YW1jaHB2bmZ4NlRJNWtqUXplS1pwT3kzTVAra0NkMlJ6?=
 =?utf-8?B?N0srU3dGblpDaEtDcE1BNzMzNGM2SFdkK3NXSTZMa0dyTHo4VXFPMCtDNjVC?=
 =?utf-8?B?Q09mRStjWmx4YWxMcXYvNmhVQlRWOGg0U0oyL1NBaDV3aVorM3VzRnUwZE81?=
 =?utf-8?B?REIrbklJbnlQRFhaNjM5MkFoNzhWMGZjSko1eFB5K0Q4cy9TbnErU05HMzdF?=
 =?utf-8?B?YXE4M2xXS3VXVmN3enNHcmlWZktzWjlmc2trYjdMMkxDcEpwaVl4YkhPRE9M?=
 =?utf-8?B?WTI1OTErTlNpbkZkVHU5bC9LVjYxejdqRGVrMUIveDh2TFBrL1pCR3hUaElM?=
 =?utf-8?B?TkEveVNHN3U5MTZab3ZubjdWd0t2MEJEQ3VzbG1Yb3h5Ty9SVC9XQTd4LzVW?=
 =?utf-8?B?SktQWjhzVXZId09od0YxWk5yQktqTG5wdGF5Q1RWTE4rcFJDMEdodCswdWdU?=
 =?utf-8?B?UjVnQWJTVXR4M01FSDE2WW0xcHIwQk1LTGFVRm9mMk1xdmVRbFprL3dzdVhm?=
 =?utf-8?B?WVdLL3JuMWdvUS92bEZnaVhiYXFGRGFTdEsxSEtoekJ1R1dhckI1TWtzdWYx?=
 =?utf-8?B?dmZzL0J4RWp1Y2c3NFBpQjJkVTF4ejdRMm9qUHhrSUtZZDQwS2Q2cXYzbm4w?=
 =?utf-8?B?NkkvSE1rRHdNZFpoUy9ISlJWVnk0aFN1MHJ0cHJFTjJBcFp0ZjUyM0YwUXV3?=
 =?utf-8?B?bks4T3lsaVBuYVZ1MkZnVm11VlF1WDR3QTZDbThyZDNRdGMvMHFlSUlsemVF?=
 =?utf-8?B?UzlvRlgxakZQVWtKSTBOMEhoUkpSZkRFNkJET2FTVmY3bDhJTVEwSlpQYmZR?=
 =?utf-8?B?QXFJak5aWGp1akNHOXBCUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWsrUTNpeVp3ZWkra1dHN1B2TjNPcHFBdjFZMmI4TkE1aTI1a2J4ZEtmaU92?=
 =?utf-8?B?UU9zMGVFSng5ZW1YckZQT1ZFcHdRQUozZHF4amdmbng4d2t1TzZ3ZDNkREQr?=
 =?utf-8?B?VHZKZWY2WG9KVExPMWhiOGVEMUE4SWl6Z3pqWFhab1RZMWQxMDQ3MFNvQ1dl?=
 =?utf-8?B?SXAxNnVLa2N0MzJyVUdFQ3NINDJlNFBEUENIYWZvdm5TTXl6MnFHc2lNajRJ?=
 =?utf-8?B?Rk5MOS95bTRCdUdTYmlYK2R3S0xNYmovb2M3blc3MzJWVXAvc1Z0YmQ1ek5U?=
 =?utf-8?B?b213VW5RdTJaZE4raGlMSTVJR2tNaWFnbFk2eVZMNkIxNm5uRTNHR0xZM1Z4?=
 =?utf-8?B?SnRzMjllMzlScWlFK0Z3aDliTWVVeUtaWVcwZlhybVBScjVaK0xDWXpoQUJD?=
 =?utf-8?B?b3EwYjhTYXNycTBiRzJjKzFUUGlrSUo5K1A0QStvcERLblFhSGF0eGFYQkpU?=
 =?utf-8?B?L1NVRGN3TVRxajdaN3Jwa3pPdTBjL3c3N1ZrU21wTVp3d3dzQVVCcWI2NXlQ?=
 =?utf-8?B?bmxSay9DVVc5SFJ0aGdhcTBjVmU0c2RvU2loLzR2OSszSFF1dVVUYUQ1UWpn?=
 =?utf-8?B?WU1HZTlmbVY2TnYyVEpBeWx6UndHOXFKRnhVSFk3RXlyckE3V2NxSmUxSDFL?=
 =?utf-8?B?eHREWVU1U01GbTVMVVV0Z21FSzBpWU15ZGJOa3ppSFBFaDljWldZeFkrcFRP?=
 =?utf-8?B?SC84VUxwT2hJc1BNL2NOTWQ3d3ZvSUtnQ1krQjUyR0lKUzhNZzhZVU5lcHV6?=
 =?utf-8?B?YUg3S2Y4SGtqRjFyeUVzSzV0TmlQS0c0RkhHTDg1YU1pZUFGZndhd0FxTlVG?=
 =?utf-8?B?Q0l5VWcxNCt1QkR2amlOWGtENm40Ylc0OWZtTzVMODhMWDJsZktmV0IxK3dM?=
 =?utf-8?B?NGdzbGJyZHhpdHdaR1FINjBIWlhSTUlqdUJtTlozbHZvM05zelJyVk1YcjZj?=
 =?utf-8?B?RDlxZmN4dXdvY09TN2dnOXBjMjJtYUxIVU1qV1l6RHVSTmtBOUNydDBzMVBU?=
 =?utf-8?B?NlNUUWJKN0ZCUlF2QWh2RGxvcXJKZ1pONjlRbVdIZ3RFWHRnY1pvbHVvQmN5?=
 =?utf-8?B?cmw5MXlvK1ZoOVJ3RE9tbUt6dVBzcWFSN3dMZW9jTEV5aTd1dWxmbFNsYSta?=
 =?utf-8?B?TkpsdHpUZjRRdEFZWjhkN1dDdDFrOHNnSGZXV1dTeURFWFhncWVpRU9FY21i?=
 =?utf-8?B?RjJQaW1OWVBpMk9mSGUzeHNYUHlSRkgzNDBpakkxQVRRTkJtMGpCL3cxRlgz?=
 =?utf-8?B?V2xseTlpODVRZlNON0RYUXN1b1VsMU93OEQyaGdCWExUOU9xR0dBZW9ZVTBz?=
 =?utf-8?B?czRpQ1R0TlFOaDNPdXZvZEZGWk03dHYzZitKSnk1ZmJ2c2txTnVJMGtqZ2lZ?=
 =?utf-8?B?L0FLcG9tci8zajFLVnc5aVZRUG4yMHlNaTkxMk9SaCtYUkFteENuYllJaGZ2?=
 =?utf-8?B?VFpqeEhGRlZwZ0pSbG00d29mVFhqMnVCYXFvMkZBeDdzaHcwQjRkZWptZUl0?=
 =?utf-8?B?OFNnMXlKcU00Z2I1WjNCMG9VaG9nOU5JNUJGZFc4NGw1SnpXTk11WmYwZk9n?=
 =?utf-8?B?Uit2eWI2Y2xuZlVDTTk2bnBmWTBqb3FTcGFTOStVZmdUR2svUkJxT2EveWIx?=
 =?utf-8?B?djREa3NROWZoNnBwak1XZWtzZ2RoS2o4Z0JCN1J1R0FqRGhRb1ZwdDRQRnhv?=
 =?utf-8?B?c1huZmpzVzNCc3pacG1YbDgyWU1ubkhIYWg3K3Y0YjVaS0ZxZHdTM1dhLzR5?=
 =?utf-8?B?dnpmVWkrWjRncVpRb0JvaXlRWkxiZUpsU1NGaU8rQkc0dk9hZVNhWkQ5Tkw5?=
 =?utf-8?B?WTVJSmxJem9Nc2pXa1UvSU55WE8rb0VaZ3ptNENPTXFrWTdpZGhrUHlwcGhx?=
 =?utf-8?B?OGtTRVRtMUhUd0JTUGF4QmY3MWdpK2M0WWtmbnl6TEhqMXNSM2tXeXVNYVR6?=
 =?utf-8?B?Skp1Z2hqek5qOHlhSkhEZmtDVXlvaUlpL21MNU9NTWVmbm83Y3NQTVlCNmZm?=
 =?utf-8?B?WWxvOTZKS1hndkU3SExMTThYcXZhQTE0MmxnSTBpWjh4ZlVLWGJJd0lWSFNr?=
 =?utf-8?B?UmJrTU45R2R2QlZNN1NnR3RXNlhXNUNLWUtNb2plQUNzcVpsVEJqT0ZmSjJ4?=
 =?utf-8?Q?5viLJEe3t7xyrjyKc3NCp49zO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0019fb82-20a0-41e6-9e2e-08dcd0e245d1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 15:15:43.4382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LQKn/4GpB5uT1+ePTESbxaYTIT7GJ4XYd8l5I9Qlh07DtETwoMj4lZBaKk3nZShUPEA6WPBGqBY+bg0BprPVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355

Hi Steven,

On 8/19/24 09:10, Steven Price wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 19/08/2024 15:04, Suzuki K Poulose wrote:
>> Hi Steven
>>
>> On 19/08/2024 14:19, Steven Price wrote:
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> Detect that the VM is a realm guest by the presence of the RSI
>>> interface.
>>>
>>> If in a realm then all memory needs to be marked as RIPAS RAM initially,
>>> the loader may or may not have done this for us. To be sure iterate over
>>> all RAM and mark it as such. Any failure is fatal as that implies the
>>> RAM regions passed to Linux are incorrect - which would mean failing
>>> later when attempting to access non-existent RAM.
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Co-developed-by: Steven Price <steven.price@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v4:
>>>    * Minor tidy ups.
>>> Changes since v3:
>>>    * Provide safe/unsafe versions for converting memory to protected,
>>>      using the safer version only for the early boot.
>>>    * Use the new psci_early_test_conduit() function to avoid calling an
>>>      SMC if EL3 is not present (or not configured to handle an SMC).
>>> Changes since v2:
>>>    * Use DECLARE_STATIC_KEY_FALSE rather than "extern struct
>>>      static_key_false".
>>>    * Rename set_memory_range() to rsi_set_memory_range().
>>>    * Downgrade some BUG()s to WARN()s and handle the condition by
>>>      propagating up the stack. Comment the remaining case that ends in a
>>>      BUG() to explain why.
>>>    * Rely on the return from rsi_request_version() rather than checking
>>>      the version the RMM claims to support.
>>>    * Rename the generic sounding arm64_setup_memory() to
>>>      arm64_rsi_setup_memory() and move the call site to setup_arch().
>>> ---
>>>    arch/arm64/include/asm/rsi.h | 65 ++++++++++++++++++++++++++++++
>>>    arch/arm64/kernel/Makefile   |  3 +-
>>>    arch/arm64/kernel/rsi.c      | 78 ++++++++++++++++++++++++++++++++++++
>>>    arch/arm64/kernel/setup.c    |  8 ++++
>>>    4 files changed, 153 insertions(+), 1 deletion(-)
>>>    create mode 100644 arch/arm64/include/asm/rsi.h
>>>    create mode 100644 arch/arm64/kernel/rsi.c
>>>
>>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>>> new file mode 100644
>>> index 000000000000..2bc013badbc3
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/rsi.h
>>> @@ -0,0 +1,65 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * Copyright (C) 2024 ARM Ltd.
>>> + */
>>> +
>>> +#ifndef __ASM_RSI_H_
>>> +#define __ASM_RSI_H_
>>> +
>>> +#include <linux/jump_label.h>
>>> +#include <asm/rsi_cmds.h>

The error number macros are used in this file, but the header file
'<linux/errno.h>' is not included.


>>> +
>>> +DECLARE_STATIC_KEY_FALSE(rsi_present);
>>> +
>>> +void __init arm64_rsi_init(void);
>>> +void __init arm64_rsi_setup_memory(void);
>>> +static inline bool is_realm_world(void)
>>> +{
>>> +    return static_branch_unlikely(&rsi_present);
>>> +}
>>> +
>>> +static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t
>>> end,
>>> +                       enum ripas state, unsigned long flags)
>>> +{
>>> +    unsigned long ret;
>>> +    phys_addr_t top;
>>> +
>>> +    while (start != end) {
>>> +        ret = rsi_set_addr_range_state(start, end, state, flags, &top);
>>> +        if (WARN_ON(ret || top < start || top > end))
>>> +            return -EINVAL;
>>> +        start = top;
>>> +    }
>>> +
>>> +    return 0;

-Shanker

