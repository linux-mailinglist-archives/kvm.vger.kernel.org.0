Return-Path: <kvm+bounces-51871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CA9AFDEBB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 06:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3B561AA3CFF
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 04:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10301269D16;
	Wed,  9 Jul 2025 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BYcWv6Uz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8642526773C
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 04:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752034508; cv=fail; b=sgf98NgUh0ukSYmJnO0ElAZHtyK10sCHgVyCO6q8jsaSSBhhaF3kwkk/CgtahOBm0cG2Ygdyv+Rtyro9sW/Wtckefl0yGSo67mNvLU30ph7boodSB6YR0vnVrhEqkP2ozf7z52RFftiu1SpPWMHVuofhoVtIu3T6clAWFU7wgnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752034508; c=relaxed/simple;
	bh=TBSmNa0fTlaS9rZt0jGwIvDhZHLCVf6aWCBq1haujTE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gd34Vev8yifClhiB7mSrRDLO0Pe/Fw4E3SFzrnuWVMl0pEQKIdIWKcMlX7bmwqv51Z52+hdq5M6mz1O8GV+VTIL34q4yiPc5ixJpl8Qs2IW91uuZuW+JzhUFQ0mOiMOKGp5lfa+GHmlK1rcr9ogcJm90lAUhFZ2piEOVCWzIqBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BYcWv6Uz; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eo/2p/Mac6liBonkGjtccMXDZ2VX9pBxaG5fiH7DBIeqFG0w7LBQmfmkjPUNagiJxKh0LE9oSF4TPRFxNMdcgw+ZML+QiLCGtRni05KUimznSpuRU8PkA4NVeWV76gB+4D1JT/6l/oeWY6yL/4iyBF/A0jwWNbIqvePgM4ib+Z7KObSiTNYayMwP4YwXhly74/uiddC12X9qwE/QC0D00TL0uvPssJUGyswX1NB6SiAc8hzSTS+2pnVEE15L/8bf2mOEirzwYMZAU06nZX/kEcCaa6170nkmogWzhVJdHTPoYJlA65Jtv7GojyjRoU5aT2QejCRXHVp0Nuo1KNbScQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKd5Xj1lKJaHQ/1neN+0XH5r4h8jd0zINI6aQ1gea1A=;
 b=vPaL+7HFEfLrSpc3B62xTQq16pg9h0C3++8XZYXu+C6fcaSGI5wlijMMs0U+5EUgUkv+Kyk+FVFtqyAW8G2KJ0bV2z/NRdo6Xi+8miFlSNDyZfJaHP6FHUZea6LM27AGx/Hpm9neswLBWFwU1+OO7uSMPyh5IJqgrd03BmF5z4z1ZYJKDrfT8fjC4KpOU4Nuic8Fhu/dXRVHjKnhgJg1kgd6i2/a+h01i+ihuLGz4rlcbPyIM38JPPvaMUUKSueobiSN19RSdf8gh+QZ8nEbxxMGnqY68GcN33v2GVEcrmpCCTxaLEZAsgMuHVnXslmFY5gBF9zThCgqGv1EddQUNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKd5Xj1lKJaHQ/1neN+0XH5r4h8jd0zINI6aQ1gea1A=;
 b=BYcWv6UzwM6oyLZ/eBcyV1WvcrSmbk5CuP/huKGaq/dqSvKYRwSlhMBmsaIpA59SlGyKMHTqjdKz/kgp9S7M2pwxsNm6aEwP8ryZt6HvqahcdX8pCFtyBJwGkEoIae1JTTFJLhwEzAGqIa1Axq9cglqnrPU9p6IruLtQ5oBak70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 04:15:03 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%4]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 04:15:03 +0000
Message-ID: <c327df02-c2eb-41e7-9402-5a16aa211265@amd.com>
Date: Wed, 9 Jul 2025 09:44:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "santosh.shukla@amd.com" <santosh.shukla@amd.com>
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com>
 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
 <57a2933e-34c3-4313-b75a-68659d117b14@amd.com>
 <fec4e8dd2d015ec6a37a852f6d7bcf815d538fdc.camel@intel.com>
 <aG0shOcWprrZmiH3@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aG0shOcWprrZmiH3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:277::9) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: dfc7240f-5bd3-4111-5df4-08ddbe9f2d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZklqNWxjd0FnVFo4dnVaRHZNalZKTTdyN0pFanpYMmtKVS9TZzFiK3h5a3Uy?=
 =?utf-8?B?dGdlclR6aWJlOE5ZTUJ5MUJLZ1h2U2lucUZnN1NDa3ZDTEFkWFo0eWNRaXR3?=
 =?utf-8?B?cW5rcElKR2hsaE54OWFQcSthOXFxOFUyTmhyNFFOWlI1ZEJKUU8wT0JlUVJU?=
 =?utf-8?B?djlWdVovUThNZzA1TzE0bjhwYnBVaEcvNTFNRkVUR0ZwOHRuNDZ1YWFsS01P?=
 =?utf-8?B?TzFqT1Nld3JVODhUS3F0ZE1HTGY5OFpSRnZhVkFFdlFCN0ErZ3FqS2t4OXg1?=
 =?utf-8?B?ekYwRVVyVUcxbytNT1NlWTlWMmpIUXhNc0JnZU5iUXBVb0QzdVlaMkV6b3VF?=
 =?utf-8?B?VnNVdndUZm5oVUFFWTdIaUFGU3dRSnVXRUtSOGRlRTVSbWQ5c0NMOTA4L2dO?=
 =?utf-8?B?ZVI4UDVPUEVHOGdoU09vNEMyWjBlR3krRGgyNVZQVHZpSjgyME1Ec2gyME9p?=
 =?utf-8?B?dyt5MHZjdmZiTkYwd2pHa3dheW1aOEhoTHc5ZFpST1lpYVV2aXIwSUEwd21X?=
 =?utf-8?B?OU1CRFFRdUlaQ213YkgxbFVYVkhtQzBYekZZSnVOSHNBaUllY2ZYNURycVh0?=
 =?utf-8?B?UXVSWDA1Mk9rYmZBOVM1Y1ZZYmRFY24wSExqbHo3ekpZRUdJQ1NkRUh1Tm03?=
 =?utf-8?B?MWluR3B6U0N5bm1ocTVRa2lkRi8xamN3UkFHV3JWK0g5YTJoSDd1Mkx0cXht?=
 =?utf-8?B?YmJpQnE3cTUrT1ZOUXlpWFkwY0RZOS9zUWRXRjJtVTY3ZkVsWXp3QVAyYjlr?=
 =?utf-8?B?SzJkejg4aDNYNjhZaU91T2dIMm96R3h6VllIbEZZZGhVN1ozQXRUSkRZdDNx?=
 =?utf-8?B?Ui8xQlVLejM1WDI0RjExc0o4U29MaE54QkVadEFTcGk1UlN1dlFDVUYzNnlp?=
 =?utf-8?B?NnR2cUx6TGNZK1pycWdTQlVNMTRwYlgxNUZIajBwamlPaEhpV1E2RXd4Y05J?=
 =?utf-8?B?THRtRkVFbzczZEdPSzZZQ0ZtMGQzcVpTdUd6N1padEVBeFpXeWszNUpqN01V?=
 =?utf-8?B?NHAzREJsTks5cHY4SlhBTnZtYjhSYmxlUDZGbWY0bVlqam5WZTl4a0hqZ2x1?=
 =?utf-8?B?VnFJN3loVnJQWVBMU3UyOEZRQlRXUUtJdWFGOXNQNk8renhBNVNsYlBRclFz?=
 =?utf-8?B?dXVoZXdrSVNraWpOa05Jc0V0aWIzczJuUUJ5NDBYR0VveTNwdTh0K1k2MCsv?=
 =?utf-8?B?bXU3OUxMRXVZcTNFaUMydFp2R0FENlhoNXB3NURyME5ZRy9CVWV2ZU5QY09X?=
 =?utf-8?B?Q1JGMDVaMXRVdTU0dXFod3pVOHpNMzhMTXAzZFZXaVg4L3NGbVZEdEhraXpl?=
 =?utf-8?B?YWF3S2JxSThUeFU3R3RCUUprZ0NQand4MXdxTmVYNnFwZGJibVRGT2dtcVc0?=
 =?utf-8?B?QmVvUGFib1ZDWGtwSG1KUEFyTCtjZldtRlpJdTRac09WQmg5VExQZFgyNmF1?=
 =?utf-8?B?TmlvZUltNDZORC9mdys1QUdUaWFEY05MUm02YVlKMXI5akdZUDF4ckVkak1W?=
 =?utf-8?B?clVsUWJDQVNXQk4yTlpmdUt4SzlRdXdnQ0c3TjJnVjdtME1XSHBkY3hYVDJj?=
 =?utf-8?B?MTVMU1RydmUrelc5SHVnSHZGcEcxUFNvUFlyRGVqb2llV2FxNnhuUFM1V1dX?=
 =?utf-8?B?RlZSWS80bk5nSzhxZHdEc0VaZUtBdUtSc1MrQ3pUaTdoZHJpRnNDbjFPVC96?=
 =?utf-8?B?WFphTk5pZEdZZCttdENrREk1N3R5Ykw3d2RxeDVMWXVucVRCRnFQa1JiOWZY?=
 =?utf-8?B?U0dYOEpmbGVkMkY1cks4dWNDZVRWcEVXM0tuSlhPdHcxT014ZDQ3aU81UmpH?=
 =?utf-8?B?VktDVHlndndsZWNUaENHL0xlQ1RPc05TWllZUUptWEN5QVo5M2FFbGZLU2xu?=
 =?utf-8?B?YzhtNXFUUytPSEh3SE9ITE9SQXBPcW9wRUFRd0xIUkU0OWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0tJcmhWcHZlS3ZDandVVm0wcm5ZQmdha04vYk9nVHZPMW9JbzdPWXBrcExJ?=
 =?utf-8?B?KzRlaGMwTUlXeVpieGJsNkNXU21VWHZzamhPRWIwUis0Q1QyN0VQS1pIU3R6?=
 =?utf-8?B?U3NFTVZXekpBWnVCR1lkRDZucGJHaDlMR0NZN1ZjSFFYeUYxajd0Y21tbGhJ?=
 =?utf-8?B?MTFMSXY4SFU3a1JtVHB4QU9Fc0VuaU5MZERFbVRRb2grV0gvMFIzRlFJTXVB?=
 =?utf-8?B?V2x6RzhGckJhWS9ZNmZEMEtUUmtRbXl3OW5NaGVCb0xUM3ZXSS8rT1FBYjhL?=
 =?utf-8?B?Q01IOXoxS0ZxcEwzQ3hsZkVjeVhBaXlKaFVpRDBSSmhhdkVoTDhjK2JwdW1z?=
 =?utf-8?B?b3Q5dnJBRk50eTFpcXdsRldWSVBrbVNYUTVwRDg4MVdlM2tCU3VWWStmaEVZ?=
 =?utf-8?B?MFhmSDRFa0k0S2Mxb1lBYUpGb2VFc3hGTnVqS1ZoTUpDTjFWKy9JQmgwdjJo?=
 =?utf-8?B?MWsrWTZGdlpKMjRmMXIxMHdmaVFkZXBKcFBVbEtLbUUxdGwvaWJpMGVtNWU0?=
 =?utf-8?B?Uy9Uc0lkNWRFOUFudVN5RGxnck85aGl3Z0VScXd4d0t0cjFNczdERy9HdTBR?=
 =?utf-8?B?ZWZ5c0xPbHZOZmJiZUxCVTlDUi9CeTZ6MFpkWG5HbUFsMXRVcStPNVorVjNH?=
 =?utf-8?B?VDZyQll3WHVNQnpPV3RycXY5QmlGQkUvUS9Yd3QwUjJ4M1U3Rkx5WHd0NWpz?=
 =?utf-8?B?RUNJaWNscnBvdkt0KytiTGdDYmR6eEgrVitkM09VVHJGelRPdEY3cGxMcUt3?=
 =?utf-8?B?QTlUVDVtSEtoSnBhQ0xaSjV4c2NQejdlc3pWYjZScjVkTlRRbFBlTkVZZEt5?=
 =?utf-8?B?SW9XWEVOZGNBbHVMQk93RVpYUGtHaTlmMXF5SzhDbmJUZzhyVkFuTUhzSmU2?=
 =?utf-8?B?UWZFcHV2Ni9aZXgxTElHYzAxcVdrcTBpK2V2LzBiY3J4WkV4QUZDamsvUHRL?=
 =?utf-8?B?SmF6RkcvbEs5R2VUT2xINlZ4SjAzdUl4S2pHRSt6aEVNanQ0Ri9QOUV6b3Y5?=
 =?utf-8?B?MnYvMHpHczIxUkVnNVJMN05FL2xnRkMvcmVGcTE2QkMrTFJaL2pFR0MzYndy?=
 =?utf-8?B?Um11OUZiSDV3UDZvSGxhRElVNUgxL1huaDdubVk1ZDh2TENSdDVreE5jRERK?=
 =?utf-8?B?b0FGc0hxdHEzUGNxcWFYWkM3Kzh4ZmJsTHE3eTh4dzNkajl1Vm96YVRCUkI0?=
 =?utf-8?B?blZvMElXQ0hBUEhoeC8vc1FJU21EN2FzYURpZjB4dTJqUm50cTB1bzE5S29l?=
 =?utf-8?B?NGVWaXhnNU05YjNJZjgzZmdlU0lDM0ZzbzNTNFRsRDZWaUNwUVROdk1wUnhu?=
 =?utf-8?B?cEQ5cFJMNktnQkwrZ1dGSi9uMVpCMmUzRnZSUytMWEVsd1doUGRkQ0lMWlAv?=
 =?utf-8?B?OGJCM09XbjVjSGN0UW9rMDBieWc3OVhIbGNtcEd3cEpXUWQ3dm5BMmdoSVA0?=
 =?utf-8?B?d3VodXlQNFhZcEZpUTgzeVM3RFUvVVQxS2M4VzJTZ3N5dFY2MHhDM3Vwb3J0?=
 =?utf-8?B?bVRrWG1abGx4dGJFa0dMTWJrdVZvT0NvTytNUkVFSEp2UnhKVEJWaUh6ZTdY?=
 =?utf-8?B?WXA0MHd0NEp2Qk41dFQrZE82ckg1ZTE3eTBuM1AwUVRHY2ZwSERnQVY1YVFZ?=
 =?utf-8?B?L0JoM1VoOVNoUTB1VHdXZkVFTUd4MUlVTWgxaWJ1Q1g0TzlscWVKaFg3Qmsz?=
 =?utf-8?B?RXdKVVZ0czdRRHlJRytzZEkzKzJUSDI4SGdlNnRSVnFSR2U5VGFUeGZxU0Zv?=
 =?utf-8?B?V3MvUlJ5OE5KZE02VlpmV0kxZlVra2wwWE16VzhyWlQwY293SHdGR0Jkb3ZL?=
 =?utf-8?B?QVdBNkhFRFNHTHpNazdrWThHT0JKaXM0bHN3Ri8vMDlvL0dRZDdiRXNRbm9T?=
 =?utf-8?B?U0ZOdzczWWpWbzBCdTdIenZPQlBxZlN6MXJMV1o3OEt5aU1tcnp1RlladTlq?=
 =?utf-8?B?Wk5ROUdHYnpQY3FFRmcrOG9mUlBXZFZIU0E4MEE2YmJDK29nWEFsVnI2S0Vr?=
 =?utf-8?B?ZWc0VzVBTktpbnNTUkgxcDRPR0V1MEVMT3lHOElDRVFkdjJiLy9wZnIyeGFT?=
 =?utf-8?B?LzNjR24zUHlrbW9USU1qdmcwdGgxcHBvZnAvTUVKT2IrNTREUmk0TzVBUFk1?=
 =?utf-8?Q?yLTNLgJ5GzxhfEPloNzAx5F4x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc7240f-5bd3-4111-5df4-08ddbe9f2d9d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 04:15:03.4158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIvpodUEL9dVfx4XkbFK5W51OKAQzq2FPS3OEWTOfyqYEJ1nCmU3cNXqoG/h4zqdU2QCS1rP/U6mM/OhMYrBEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883



On 7/8/2025 8:04 PM, Sean Christopherson wrote:
> On Tue, Jul 08, 2025, Kai Huang wrote:
>>>> Even some bug results in the default_tsc_khz being 0, will the
>>>> SNP_LAUNCH_START command catch this and return error?
>>>
>>> No, that is an invalid configuration, desired_tsc_khz is set to 0 when
>>> SecureTSC is disabled. If SecureTSC is enabled, desired_tsc_khz should
>>> have correct value.
>>
>> So it's an invalid configuration that when Secure TSC is enabled and
>> desired_tsc_khz is 0.  Assuming the SNP_LAUNCH_START will return an error
>> if such configuration is used, wouldn't it be simpler if you remove the
>> above check and depend on the SNP_LAUNCH_START command to catch the
>> invalid configuration?
> 
> Support for secure TSC should depend on tsc_khz being non-zero.  That way it'll
> be impossible for arch.default_tsc_khz to be zero at runtime.  Then KVM can WARN
> on arch.default_tsc_khz being zero during SNP_LAUNCH_START.

Sure.

> 
> I.e.
> 
> 	if (sev_snp_enabled && tsc_khz &&
> 	    cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> 		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;

Yes, this is better.

Regards
Nikunj


