Return-Path: <kvm+bounces-57591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81263B581C8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC9033B1EE0
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ADE279DC9;
	Mon, 15 Sep 2025 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NVH0drK2"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011003.outbound.protection.outlook.com [52.101.52.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE28273805;
	Mon, 15 Sep 2025 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952917; cv=fail; b=TXahGCFfV4re4qL16ssE5fAypPIib5s0dS6uWbOyrrR0f4/mxlyGzuCfoGlUZ8BzuD7K5LkLnWX0L7D5yVz5HKpb2/fDaSfMq/gn2cmF07UqaZoCsRzRm+OuX2yEeCpNiypr+ALRqeshXXga0GsIeh6goqtyr4lEBJykJHYHBcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952917; c=relaxed/simple;
	bh=/MjOAnMRjCOsPN2Jq9gxBC8bBWwgRMknnIo8FHGQ890=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lhhpWMSabl+8AB92vUGoQYTxsXaiXkFZKwS6h44wkBqnHZHQqWkRiyewFyflg8TjQiPPDzQp/0kjWvl+cDtH3/9dtP5Z7gJSaAWGlrK53XBdJpY+ewAG9IgvV5TlLZx/LS0ufPjLUzsLStr0RbKQwwLcY5WH+O9JPJWKwg5+kwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NVH0drK2; arc=fail smtp.client-ip=52.101.52.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ppVolS6mGgF6jDq/R2RrJ35MVMsblaaeOZ6L2zwlorm3SXfk1dgqjt7jxs8ZkD7U5rib1MC1eihW5mMnxMdYIGNAzFGqjo1gnMtSyFiIy+Jc4mEXLjx9fsN4LWusK7i0yaqrwemmEfqw+oYXNHnG0LMUjuSa2BVg0JXvvN9XUNhZ8BGcca0ZOzproL9UI2EsFbM/6j9FKeSETRPlkNUuJTeOHSLGAc2Hq3fwOWUdvSdNd/uDKxyVsq0GiVCZvH1yZ1QokHYKzN/4oka5me/uuEaymOZWb7ljd8TZeFCplzXIiS2ucF9XXIC7phQMuFQdX7iLt7SFAO1PuO5sCPf+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvtLsLZ4Xq7GV/dK8ntl6oiGI4KEoM2jmeULsV/KDug=;
 b=j8CmY+/FqMvy7Y1WS6eyPgbdRvrGgE+xAWiz30uYiFRJTuBRbDIYfDvbi7F0ZZOUN3bMbI9AQ1aQlQNnCnjUKY11eUUJ0jvlaPtvfT6aoUXNXgT6V0ojQME0J4mclbYhNT+j3AjEh3itCGh/pv+MFb5mqYZM8UFPX//nTH2ogNXh+1r+rlZNQA+iLdbol/JsPqPtqOHc7SgdxV8u+7RoH2eco5fBqOqDW+AgE4mPUA2F4iz7Jw/GtaOLG4nOVeSUyIGTbeRY1vccs1s9KwDnFcdw/+W9uGZEhDvy4qWMEdDaOzfV1s9+PXGA0mYABu8UO2KHu2atc8sD++jzND7ZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvtLsLZ4Xq7GV/dK8ntl6oiGI4KEoM2jmeULsV/KDug=;
 b=NVH0drK2QdaE0lvP30g9PkFjHx1s7YJ+iSMWJNew4yot6EM2SfrK7M3Fabs7KnbcS2w5KF38O4170OkpGuHQMbNlUuPrQmKCedjKzuIpaRXpzWeIlyQ4OZcvaSke9XkRdP1DUBODsAN9H85YGWL1YK8653zv6T1WPhLTLVIDGI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 16:15:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 16:15:11 +0000
Message-ID: <72a65866-fecd-5106-17bc-115ba60e67ae@amd.com>
Date: Mon, 15 Sep 2025 11:15:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 01/41] KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to
 kvm_get_cached_sw_exit_code()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-2-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250912232319.429659-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY8P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:46::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 59979ac5-e584-4616-882c-08ddf4730b7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDdmMVFyMmYzditHVEtoSm0xSUthYXFtNFVRNUI3amhZWEFmWEVadUVxWmJp?=
 =?utf-8?B?WDN2Sk1FY1VXMmFhTlZmZDE5aXZob1huSFcyNy8xbGFseVIyWldlTm5yd3Jh?=
 =?utf-8?B?ZXppT3hqbVo5Z083SUgvamJoSWZ3VjJGUkpBdFhLUVlUM2pSZHFIZ1p5NWFz?=
 =?utf-8?B?ekNhWHJnTEZsYUdpclViTnE0aHJBZG5TdlMrb2dVeDREL1Jqd2pnWkRsSkpM?=
 =?utf-8?B?WVVqdytyUXk1QVEzWGpwR0VNVU9WdmNJRVFmcmVYTEFDNXQyTElQNVVodjBs?=
 =?utf-8?B?ZjlCTDVmeWNjNzd5Q3NxVkxIWHRzSnZ3TjVSR3VYcTlVMlQ2K1VyRzNMRlNU?=
 =?utf-8?B?bzFnelk3MVBCU29SNmZzV05WSWJ5M2Q0cTNDdnFLcXB2aC9ENVZBN3BmYk92?=
 =?utf-8?B?TFo0eVJWeFpIeWNYVVN5dnBoMGx4UEE2OHJITmdjT1pqRk5iSWRqbUJYL2lp?=
 =?utf-8?B?azRhRmNSQXljYXR1RDJaaURVNllaMTAyUkZ1aG9JcktobUJqOVJnbjZCSnNM?=
 =?utf-8?B?NU5zRDJmdk02ajNDZWZJcWhMNVVveUN2bFdkd3h3RWZOT05PQ3QxZW1UMnRW?=
 =?utf-8?B?VTZEdUo3bGV1Yy9pVXJjakRnM1FxMVN0cEExS1B6Szk2S3VlMmdyZ3hjUEtT?=
 =?utf-8?B?MC9CT1JZVHhKdHZIR1c0SzM0djkyRlUxUTBOQnZyQ1JMekdRdndYNEtaZGYv?=
 =?utf-8?B?dFFXRjJnYzY1Nk9MZUpoanhlcUZ2aVRCSmZlRjFZb3ZoQ21XaTAzZVFrUHBV?=
 =?utf-8?B?NEJuUVhqVVJZYVBOVitnS2U0ZnBWa0dKVXJpUitQa2lUOFZOYVc0ckp4cWdX?=
 =?utf-8?B?NnNSZXJWaHJVMFhLK05CVk95UVRlUlhDNzJjdXJqbEZkR0czSzh1YnU0elpi?=
 =?utf-8?B?eDd2cUExVVdyK1hYdHFNc0dscGk3RlU2WU9FbGxLRGc3ZUJlMlVveUxLZTg0?=
 =?utf-8?B?OWI1d2Z1Ny9ESVE2Y2tSOGhmTHpKVnpmZjZaK1NBalZ6NTYrTmFPYlhUVzht?=
 =?utf-8?B?VVJpK2k3Tmk1eXV5K2lreVA0UmU1SXZ1QTFualdsdUlKWlUzUFBQYUxlZjBz?=
 =?utf-8?B?VGNZRkgrZy9uclhqTTA1MmFLU1RZbDVoVERQcUJVbGRVK2Q3V2dmUVFJK3Yv?=
 =?utf-8?B?UXNpcm41RHU4YzFwVkdxeFpyNkVEaHQwclFmSFJMd1VtSGNjdW5ncDdBaFh5?=
 =?utf-8?B?OEJ2OU5PUUNQdmp3YWJCYUFjdzdqL1owMVRXZlBWMFdXU0xDM2Y1RksrSmNs?=
 =?utf-8?B?dExUV25hZjV5ekFvNUZqS1BLbVRuYlVMc1pzcGk3ZnNBUlFWZzhKVVl5NXda?=
 =?utf-8?B?RGZvT3FyNmZYZktxZ2w1emY2ZWlqaXhmOGJiNW9vYXFoUjFQcVpXY1NYNzE0?=
 =?utf-8?B?YmNzKytydzJ2RG1OaW1iM0JtSWo3R3hZVW1xVHNoRklCeU0yQmNMRXM1Uk81?=
 =?utf-8?B?SURIWUFPRExIRkU3blBHVDNzSzhrbGRqMjZWc1BZWDFpeTFtREk0d0tiTWFD?=
 =?utf-8?B?YThPajlVd3FWSUJzUmkyeVZjOGJnZ0pwZTBIOUJvc0VLNzV1cmY1ZEMzSTR1?=
 =?utf-8?B?bWhSb0p0cDF0aWZiQU52d1AwckhhemFIOHBpM0h4U3BDQzNqNld6Uk81UXUz?=
 =?utf-8?B?RkRhalpNdG1GOVVkUFJrWjN4Q0QrTUc2QytBNkRaK0RWLzROL3p4YTRnNEZV?=
 =?utf-8?B?OXlFVlBCelZsaVJmbnRrQjVxRkJTb294RmErNWdSTGRXNmlPNm1zU2Y5akI2?=
 =?utf-8?B?WWtxYzIvSmExV1VWbkROMzNmeXFSWDBxNGthbTVKUDNvMlJraGpQclR3aHdU?=
 =?utf-8?B?dkVveVJGMWVhcTU2RkxYV0ovUitRenFjNkhDYlpXZW02dzVKZkhPOUxiYWZi?=
 =?utf-8?B?YmRYamJKYmZLZlJMbEpiY2Q0NGk3bEZoSnY4MDRIYkU3UmRjQ1Eyb0JyZFpy?=
 =?utf-8?Q?DLtTHlpaOuk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWE5VkhpSm9tOEUvUDhLa0JZd01LNnNxc0lIQ0w3bTdYeDZUVlF4ZGFGZkRy?=
 =?utf-8?B?WnBVcDUxbEx5NTJSdGNCL2hvVjl4VkpabmJ2aG80cGhQVE03dkdWajExSEZ3?=
 =?utf-8?B?dGlVYUhPbUZQUTdrZTVtY0lWMkY0WnVuZlhrcE9DVzE4QVhwOUswS1hiQ21k?=
 =?utf-8?B?dDNsemZ0SW5WYXp6ZXo1NG9zRjh6WUFSSWNrZVRSWnN6allub3dvQU5TaENp?=
 =?utf-8?B?cktkbThJYnZoT0p4SXo2TmtiMkRLZlJOWnBuQ2Y2TzJmM1lmR2ZtU1g2dVlI?=
 =?utf-8?B?eGNZRUxPeXNMS2dUdHBUZjNQUmZZeUx6d0pUSitjazh3MnpCeDRaaDV6dzRm?=
 =?utf-8?B?NzJ3M3A2cVgwdURXRElKUGY5TnVsSndIamNTTlIwb1N0TTdhOHdHVmRvclRB?=
 =?utf-8?B?L0RZNHB5c20yb3M5OXF4TkI4QTBoMXB0L2dKTm9adkZQTXV1S0dianNvZ2Y0?=
 =?utf-8?B?bEx0WWZpSnluSS9RajhZZEoxcHR4Umw3MWVxZTdYU3hoa1kxQVFDQ3BYajlU?=
 =?utf-8?B?amExV0ovdHJGMzNVamlVa1dhbDFlTHkzSW9GWkFEREFGaXUya3lSWXl4Vi9M?=
 =?utf-8?B?NVYxTmN6VXpvME9EeUlvdkxCalVzcUMvS0E5OWNURFczVlN6RzBsdnFSQ0pT?=
 =?utf-8?B?QnY4eEp3TFc2NFhta255OWZjU0xkMmFFaFV1YlJZekw5Y1p2dXVTMDd4K2Y5?=
 =?utf-8?B?bFJGdmhQMHBwd2hJaHlRMlNXUlhzTG9leGVGNXFwS3pFVitKSFdVcy83Lzhy?=
 =?utf-8?B?YXp1VFNqR1o3eFVVNitWUndKQ1JEZDdJV3E0UDEweWgzT28zanczMTE4Q2Zv?=
 =?utf-8?B?ejBvK0VoWFBNN25PV0I2TkI2YUllTWNDci9mcFpVMGNGN2pWd3VBdUtGTnNy?=
 =?utf-8?B?SitBNS9sbGxNUjQ2UDc2K1hveG0rR3JOQWQ1dWVvT2xWYUwwQXVVYTBrNXIr?=
 =?utf-8?B?WHVzelA1Yk1MTURIU3FxLzlGSzBnWnk5RDhJaGZZMXdYNmozcVI5OFJyNlho?=
 =?utf-8?B?eEcrYlRvZ2tGb3BObSs3MVdJLzN3TEh4YXhyS2s4a1l1dFRJL09PeWZXRllE?=
 =?utf-8?B?SjJqZS9rdEsrQ2t4TTdHeXMvZnBNY1YrQmNxOXh4WUY3YVVxdWdHeWZhWjlp?=
 =?utf-8?B?L3hhK3NWalFNZVFsQ1BCbHhGaE1VSXR1RzhvaVg3TWpzamQweTFZN2htMVd3?=
 =?utf-8?B?VTd3ejJoSVFkV3U2ZFdrY3RocHFiU1dqTnRzQkxJSWxEeW9MR1FDTHgrSWwy?=
 =?utf-8?B?aUZqWWxsZlp3KzF0a05QZER1bzZCWDFNUlJFd0tKaHJQTmltWGNNOUY3T202?=
 =?utf-8?B?emFCeE5hYUdIejl4ZFdkem9LMUgzT3dIeDF2ZFp1WG02WjNWZDdkbWtDbHZp?=
 =?utf-8?B?MEYwQkVVeWFpK2dpTnN1enFPS1U4S1FMZ1NVdHZkVVZ3bTVuWCs4cldYQTNB?=
 =?utf-8?B?bGllZlF3N1FpZHFmYkZKWWNONnFwL2N0WmJsTURSeVh3S2tuejAzNFdGUWEy?=
 =?utf-8?B?QWxtd0Focjhna0o5T08zaUtoVEZOeVF4L0VZQ3dGOGNBaVZjd3pTMlZqN1Fn?=
 =?utf-8?B?c3VDeVpvbVpEQld4c3NpZ3dGeG1Ra1dnek1hbEQzRWlMZXBQbEtIY3cxM0xq?=
 =?utf-8?B?cE8waWlmcTA3dW1QWXcxcm02VVBzOEpkWTRUYnY0UXpkakt1d2c3d3AzZjE5?=
 =?utf-8?B?aGJTK3BWcExxSyt3UE0zaWdLcFUxUW44cFd1SzBydzEyUldEU21XM0lMMC9z?=
 =?utf-8?B?Ukk1VXBiVmVFV3c0ZDlMa0NzV2kzYVRla0xLa3R3V0dDTkZMaGF2anBDVllH?=
 =?utf-8?B?VUZEV2dnL3h2WDFZcm9rN3puZ2d4TlpRNVVkTUNyNzk4Vy9vV0NIMGtDN0JG?=
 =?utf-8?B?V25uNFg5bEtuZWpMcFpUL05oZ0N3MnNvWXUxSEsvakJUY2lEb3J3ZFViLzBv?=
 =?utf-8?B?QXZneWlVM3BJdUNZSmZ6aXp6TGlndUFLQkY3T3h0RGdPRHZ2VWVpaGZIcDls?=
 =?utf-8?B?Q0d5eGJDMU9iQW42UjJvcVpLRkhRSHM1UFp5VnVyQ0RkZ2VqZlcvRWd6dW1B?=
 =?utf-8?B?UmNaOVJRQzBBRUFEYmJWdjd6dmxxblh0eUVha200ajd3MHBKR2Mvb3p1OUpv?=
 =?utf-8?Q?NcJRadVeCZqCCifN1O9b0vkWW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59979ac5-e584-4616-882c-08ddf4730b7a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 16:15:11.0595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWwag3y0vRvKNaUiFbgyUU8sD9In7TdNlNzanBMhl9yYQbQDbD1tfC/eCpYGPkWtzIccDvOvw/ThFbAhAkAA8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383

On 9/12/25 18:22, Sean Christopherson wrote:
> Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code() to make
> it clear that KVM is getting the cached value, not reading directly from
> the guest-controlled GHCB.  More importantly, vacating
> kvm_ghcb_get_sw_exit_code() will allow adding a KVM-specific macro-built
> kvm_ghcb_get_##field() helper to read values from the GHCB.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Makes me wonder if we want to create kvm_get_cached_sw_exit_info_{1,2}
routines rather than referencing control->exit_info_{1,2} directly?

> ---
>  arch/x86/kvm/svm/sev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2fdd2e478a97..fe8d148b76c0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3216,7 +3216,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>  		kvfree(svm->sev_es.ghcb_sa);
>  }
>  
> -static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
> +static u64 kvm_get_cached_sw_exit_code(struct vmcb_control_area *control)
>  {
>  	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
>  }
> @@ -3242,7 +3242,7 @@ static void dump_ghcb(struct vcpu_svm *svm)
>  	 */
>  	pr_err("GHCB (GPA=%016llx) snapshot:\n", svm->vmcb->control.ghcb_gpa);
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
> -	       kvm_ghcb_get_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
> +	       kvm_get_cached_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
>  	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
> @@ -3331,7 +3331,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	 * Retrieve the exit code now even though it may not be marked valid
>  	 * as it could help with debugging.
>  	 */
> -	exit_code = kvm_ghcb_get_sw_exit_code(control);
> +	exit_code = kvm_get_cached_sw_exit_code(control);
>  
>  	/* Only GHCB Usage code 0 is supported */
>  	if (svm->sev_es.ghcb->ghcb_usage) {
> @@ -4336,7 +4336,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  
>  	svm_vmgexit_success(svm, 0);
>  
> -	exit_code = kvm_ghcb_get_sw_exit_code(control);
> +	exit_code = kvm_get_cached_sw_exit_code(control);
>  	switch (exit_code) {
>  	case SVM_VMGEXIT_MMIO_READ:
>  		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);

