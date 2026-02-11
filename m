Return-Path: <kvm+bounces-70819-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ThqRKzHTi2nMbgAAu9opvQ
	(envelope-from <kvm+bounces-70819-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:54:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 280BF12061E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:54:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 77F40305A487
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA85A239567;
	Wed, 11 Feb 2026 00:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="x8ENFbDt"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53A2221721;
	Wed, 11 Feb 2026 00:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770771245; cv=fail; b=uB3IRmlEh/2GBI8Rbby9Gwpkz8GzRhJxFjsPcumw80Kjl7tK18t+gHp1nYlj1mLOlnksmA9tKyFghf8+cxyJeYJ1QBnaa+VZJWP3V2NGl98pRuBGlz5a/dCLnqHOFkUyOmrQbGgX0qYPuWwt3ifVE3/J2mIQ9f65MtuK3t7a/tM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770771245; c=relaxed/simple;
	bh=WLyarINGhcT8TbV2idvKXaaC5ZcS4HI2jKpGEOfk8ao=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G4dgs9VP8SOenBzznCbl64K+mO+STn+5MCxQ/x7ycoiaLVO5cZh+nKWljZ5kUSIp25bInv0WZzVjCm1zsn2jAEtMAZPju8/6bEbQPjjmPYFsL0GzguzCnXhFocjdyNVand5Kr5imOEU2q6T58Rs6/m/oj7FcBSYtCs+F2m3kPRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=x8ENFbDt; arc=fail smtp.client-ip=52.101.46.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJzQitzK7lHvmFSLHe7Mn1wJgQimV7eZllh2ex572WdxpTKILLtZnBSRaUVUNFA5SJq2EULg89BlZNWRmAs0f4DQrZPii5Bx0+ZDPAt4dAFmsZvz/qM2+MjhZi+OvBN0cw3DSAco8EIi763KEs/vUO6g/841XlDDHmR926iIqlje0lAFUvDaqHKEMK/pAb7mz4wxQOU3HL2oiw3wW1ozadKCfVv7YN5m7W2dhPEkNggyXdNYVobf9UUjM85Snd+EtLXn0U5eLPTFXBT1uE98dtL5t14WOAyTb0zE3uPHbBjaF5ulO14GyFFP0Z9sqylz//qEDXSHoO+hz7rC9+wBtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chhvGmbaG/GakDVmrCX/zkXaV4XKo/qrFMsF8vX3FXw=;
 b=yaE/7nbuib0tPrA0mO3CfbuoWxeGHUUcKlrFJFq0KXYzm6tCqO1OeYTDTO8UVMegOwcp2VhoNkDNMrFXUPKKXnfJ2QHV1HW1e9SGaxTOAdlHym53KikCprjQNwWY3dAGFMpRFeZ1mMV9kH4gL9F81XvivNciA5043lzqF9LO7A9UxW5IDgs4bGseLVmMEB34ScwE/PJ82XCi/pd5eNLeTBFAn9cyFG4lYW7et1AmfT0oPTnRIlON88SB3PJr+8AgTPUwBBYOW6hyRuV1+7CcPRMZAwbujHyCC23CuOWab7xbjtPzHFFOcMsv2jocUBDTKTXaZTwcLYHokRI1ptW9cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chhvGmbaG/GakDVmrCX/zkXaV4XKo/qrFMsF8vX3FXw=;
 b=x8ENFbDt95+EtNW9VCdGxN8c49kkBOj5iqkKeegtO4S2NCapKP5kT8OBha+yFQlFh03ede5hBsQ1impDblcKkyRQGUDC86GiAnfbSIEVHvYu0qrEPUFjvPg0qD4U8NMu2E88DQMKSIsGyfvhmQaozQaJ+jqHyNNN7Kwv+yvsy9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by SA0PR03MB5611.namprd03.prod.outlook.com (2603:10b6:806:bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Wed, 11 Feb
 2026 00:54:01 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 00:54:01 +0000
Message-ID: <f3959d60-9622-4817-8b85-2b704c46c583@citrix.com>
Date: Wed, 11 Feb 2026 00:53:56 +0000
User-Agent: Mozilla Thunderbird
To: shivansh.dhiman@amd.com
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com, nikunj.dadhania@amd.com,
 pbonzini@redhat.com, santosh.shukla@amd.com, seanjc@google.com,
 tglx@linutronix.de, x86@kernel.org, xin@zytor.com
References: <85958aa8-98ee-40bc-8fcf-750bbf62ccce@amd.com>
Subject: Re: [PATCH 0/7] KVM: SVM: Enable FRED support
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <85958aa8-98ee-40bc-8fcf-750bbf62ccce@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0479.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::16) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|SA0PR03MB5611:EE_
X-MS-Office365-Filtering-Correlation-Id: 0254fc78-7092-48d1-f4a8-08de69080bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2xaZTQ2ZmtnNWZUTkd2S3I5K2lMNHVybnBkamRaVXVkRUxKK3BSU1J3RkZs?=
 =?utf-8?B?RGUyTG8rUklKWEhFeStlZXYzMjZhbDZ3MjlDZ0JwK0J5azY0emlKaGVBNk1Y?=
 =?utf-8?B?UlppVmQyd24wTXdLNlU3cmVWNnVsRVB5cDZ5a2ZHODl0cWJ2OWhYTGR0bXU5?=
 =?utf-8?B?RWJ1N2ZOb0pzSHVGcHgvSlpBYWhNRm5LNWlsSUx6Uy9iaGppb1BEOGVNZnRq?=
 =?utf-8?B?L1o4b1lkY0RmUDFiNDc5dDhzdmRxOXNkSzBneks4WTR3L3BUUW5ERkhFb2t4?=
 =?utf-8?B?cVZDY3ZaTXRabVZyejdwSkVUdXpQT0dvTmlaQll4a1Q1dTFkellLelFmeXFy?=
 =?utf-8?B?dENiOHNMQ0xaaXVWWDFlblJ2ZnUxQkFWZWxwdno5STJ4RjNaZ0ZDSHVqVUF0?=
 =?utf-8?B?RVhZbUtlVGR0Qy9wcnFJd3k5RVpWc25EWDQ4UGt4anUxZ0lXTlZVM3Y2NDYz?=
 =?utf-8?B?V3pNMXpkNVVaUkVoS3NQUFFDQlVYdWVDWjYvbUU5Q09DKzJjMEVaOVk3WXFL?=
 =?utf-8?B?Ny90SzFjUU8yZnlnVzBxTDZPaUF4aDE3UVZTdUFGSmJWU1dmU0RZNkd0TWd0?=
 =?utf-8?B?N0h0WTZIc3lGSjF5OFk3ZEZuWFJhSk14aVZreVcyei9aQXkyTjdFRXZlT1Rm?=
 =?utf-8?B?ME10S1VuSHY2MjdiOVJYbVNJeWtiVEt4RU5VYjBvSEJLa0hRdUhlUFF1Qlcr?=
 =?utf-8?B?K2t3NzFMRDVmWkFXRGh4dzRpRG1hUXRlNk1LOTNBNTlsT1h2TDRieFZmN2lw?=
 =?utf-8?B?SkFsWkVDSy9XTG9MYnFUTzZPd1N3bjJZOEF6dXByUnp5ZzZEdkRGMVQ5UlI2?=
 =?utf-8?B?K09KWWwyeXNMUC9oL24wNEpuTW95Y28zYUJZd1VWd3dmOFk4WWEwR2VqWUNJ?=
 =?utf-8?B?dXFyWFBvamVJVVZXL2hjdUZ2Njg0UWt3cGFjNmZVanJic2ZNTit4aDFJYWNM?=
 =?utf-8?B?c3phVXJLcnNic3BueXJ5enBVanZTcDE2YkU2RTdOdWZrbEUzRVl3TzNqUytG?=
 =?utf-8?B?OTE1WjNNb0owaVRGNW8zSDJ4Z1RmVm5KZ3hNNlZJMFU1K29OekJlaEVkckhJ?=
 =?utf-8?B?VkNxT1ROcXB2SlA3YWVSMFdEd2FnZmFES1l4RzRpMitaZ2NmdU1OTVpEUi8y?=
 =?utf-8?B?UEVGeU5hdEF3alRPbFF2M2Q1VXRucithK3dEZ3B3UHZvU0tEc0t2TlI0T3Mv?=
 =?utf-8?B?WFdORVZGRzBhcHBRaEZId3hFdFN5ZE41Wjc0Q1dtQVFyZWlMdnlLa2IzVDlE?=
 =?utf-8?B?VXpjNUg3WGNwdlYxMDlobFU1N0lJQ3dmNU9PbFp4My91TW9sWnM5L1ErZTVJ?=
 =?utf-8?B?MXQ0c0hsS25WTzl1L05JYUhFOXZzVDJRYnAyaUxmN015bmpyNCs3akNIMWp4?=
 =?utf-8?B?QU1OdjBCZjhQR0ZLQ0VEVlpWdkRBWmxuaTc2Y0F5ZlJIUlV1ZS85b2NGeGZH?=
 =?utf-8?B?RzNFRW1nYUVpRDBFNjU2a2Fvd0tyYmFFSUcwb1R5NTB2UldpSTk1YU4wWGt6?=
 =?utf-8?B?d0RYN1Z6UGNPMW5UN25ncFpFUVRBZHpBdkNiaEhOeC9lNDBxK0NsUS9qRVVK?=
 =?utf-8?B?U3FOMk9lclBBSnU2dXVKVVBHWVpCeEFkKzRNdGl4bFhaRXR4Z0RDUFUyUHIx?=
 =?utf-8?B?QzVxMi9PNVQ5RXNEa1pVTDlPTE1KM0U3N1VLUHcwQmNVd21VTEUvY0pVUDBy?=
 =?utf-8?B?bzVSb0JUdk8zQWRUMUlyQkU2dUNFNG96NFZ1L2RidHRlV3E1VEUzLzlINkFE?=
 =?utf-8?B?R0JOaUJQYUtpVk9UTUU2VjVkcDQxa05Yayt4NDJwaGFQU0dIR2w2OVhWd05z?=
 =?utf-8?B?bWNUeFlqZTk0MkVoRU5jWTA4VEtUdjdHN2ZxeTRUWVZXNW9UQ0JiZnpYZy9G?=
 =?utf-8?B?Njk5d0s4WjlFcVJaY241cnU3eVVJTDJwOWErcllzSDJZSXRnOHdzTEF2WEFy?=
 =?utf-8?B?SXZ4M3BVZk5uS3ordkRlckh4UUlpSzl2NmVvUkZ5eWxVS3lBMDdnU2ZIRWY3?=
 =?utf-8?B?U3VoRmd1OXVuSFRTZzBYeDlrSVRmUTlqVjNHU2dwZEpXMndZTDlmck84U2sr?=
 =?utf-8?B?d2lPdlJqS2FadVk4bHVwdE8rZVAxYm1KTlNJVk5CSDlGeE0zeG9PQTBWNTQz?=
 =?utf-8?Q?1gPw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlRrNGtsMUVHRjdjN1FTcU5ja1JNVWNzazV1UXdZRGNTMW9iOCs4cGNGYzZZ?=
 =?utf-8?B?TFlvOUsrdXJQOGlidU5CV2FRazFoRWpBQnQ5SmdwMEc4UnlHYVc2UnRFdTNE?=
 =?utf-8?B?RjdDaktsRG5HMUl4TndXZVVKdTQ2VDF5blJ3Yms2VVVRM1FVRFY3OXBxWFpw?=
 =?utf-8?B?YWUyL21SeTRXaEd1eGpzM2RKV0JneEh5bU5tTlgrVStxaW5INUNBcUxFOFA1?=
 =?utf-8?B?dWFEdys0b0FsVWQ2UERsWmVqM0EwU0VVVUVJWjJNZnVNVUhLVlFtaDBWN3ow?=
 =?utf-8?B?L0pTbHJqUFdQWlJvMjA4ZCtsTWYrUDB3MTZtNTkvNkV0V3k0WlJZU1lKa2FO?=
 =?utf-8?B?RmNKTXRSUm54WlRUZ1FBYjI4MHEwcFV1alRveTdIbFcwd2g2aWN2M0JybjV2?=
 =?utf-8?B?Y29NRnBaQTNORzVTVVdab1pSdW90clRPemd2VUl6RmtKNmlIbS9NV0EyVVNk?=
 =?utf-8?B?QTJyVWNTWklaWnFvbkNGdVZEZkFpL0VEVmFWNVY5RThob0dYa09GamcyTHFn?=
 =?utf-8?B?amsrbTJnWnZCSGxCR09LT2pOUHViUGVVN2ZMK0drcEM0NjJLWlhKa3lqVmFu?=
 =?utf-8?B?cmNIZ3pVTG1weDFJaERPOXR0U0x3ek1qS3N3dTY5ODMwK2NxUm55QjNhaXF4?=
 =?utf-8?B?clNkVGVOYXFsRzRObUhIWG9ocERBeHJlb09pUS9oZ0pYVzBOV0tVbXU0S05X?=
 =?utf-8?B?VmZLNkI4U1Q5Yk5OU3RJbG9EVmQ1N0lmOEU0TjFrT1RpNzU4U2R0WjdKNWJz?=
 =?utf-8?B?blhWL3ZoMUw0R2d5SE9jUUdYQytib2Z2TEhsZk5CUVF2cnBoRkdQTmhhOWlv?=
 =?utf-8?B?eE1YZWJrV0NXMnRvN2laMmZzZGRRM3YzR0VjZEgxTDBCd1NuZXhocjVpYnpi?=
 =?utf-8?B?Y0RFa1BkRFNXY1k5dGxsY0xCNGZYNy9oWDN2UlFUYXZDd1EwaklIUENSUmVZ?=
 =?utf-8?B?T3ZTZXI0S1QweTFYdE5OOE1Ub0RsSVRBcmRsY3dUb1FGek1sMFNSWWdOK292?=
 =?utf-8?B?Ym1IQUxsTFd1L1prTVcwQWR5QlFvdjdkalZpL2pqbThOOXJPSmtFcDBnbFBv?=
 =?utf-8?B?K21nMEIrUWZYelRsQ0ZjQnJ6Q2FIZFBhajJFVmxadHdsRS9GejNCbVlyVHJ6?=
 =?utf-8?B?RmJzNDhaOTdEK1VpYjgxeURVVjNCdUY2WWt1RDI5SXFuMk1rOUtOWGpPTXFH?=
 =?utf-8?B?b09lMndZY0JVMnVUVDIraGVYWE5xNUhySktyMDM0WE5JSFhLVFFGUkJyditF?=
 =?utf-8?B?Y0ZENE4xTlFrVmV4RE5hN281aWtjTFlpYzZOMG44WmVRRm1WL29XSEpnSmEv?=
 =?utf-8?B?UndoZ0ZrTjQvZDh4eU1UQXdYYWlzOVIwckdmNFhQRy9qT2xSVlZGdmt1VGxQ?=
 =?utf-8?B?LzNNY3owT2poNllreFNyd1E5UkJ1ZFFmWCtUNExkS2xUS0FPNzNrUjlJc3Fu?=
 =?utf-8?B?YVR1S3VjMm9DYTBxNC9EeW1POEdwRHlldkRnZVpmY0MyZ0w4UlVTOGRTM3Zm?=
 =?utf-8?B?dmhlQTlnVjlnNWdYd3QvOGdya2hmcGJkVDFBWWRJclRvY053TE13Z205UXJn?=
 =?utf-8?B?RTdua0NabEpzakoxa2RNbm5Vd0dUMmVITEJlOXZNT2ZrMkJQb2lCWGVVM25l?=
 =?utf-8?B?aFRVL1NFdkpiN05QSncyeG9VdW5iVkNiZUM0MDEycTlkV1EwVXhyNytWK1o4?=
 =?utf-8?B?QnFSd0tEYXhVekdCWFF0VUVjNzlRUXQrajV5M3VEK2tRQWd4S2NsTytRZmcy?=
 =?utf-8?B?VUNiNHpJMFBGbjBYdE9tKytkemV6N2pKL3BJMHNKbjMzenVOOEIzN1Y1a3N3?=
 =?utf-8?B?aWUrSHFrUjdYKzhPcUFobjEweW1XQVJwUXpWblpPVnBlZ2V3NndQS2JGbThv?=
 =?utf-8?B?R0J0QVFxNmdVbFpFb0NyL2JQQkVUVmdYN1UvYXJ5cUJxQ1M1dndjL0dNZFVP?=
 =?utf-8?B?NzFPbFI3VzBOQU0wU1RiR1QyZmQxcjJIMkphRVhpdTEydmpKK0tqd1RDV1Ir?=
 =?utf-8?B?L0hMTkhNRjJJN052aEsyei9qaTNxSDRQakg5NFdWMml1UVp1M3poUWNwNlNu?=
 =?utf-8?B?SS8wb0VQWmFHM0tnOEdtZmhxa2YvSmkxYnJYODlwK2UyRHdLZzgyTnZ5TlYz?=
 =?utf-8?B?cXNsWUltOHB2VjhPVW85djZQUkFBN2F3dmtDd1d5enhRdGgydG9LU2ZOLzVi?=
 =?utf-8?B?L0JCZm1PU3ZsOUlFYm1ISEhXaEg1VSswZ2VFUW55UytLMGR3K1gvQnRxNURq?=
 =?utf-8?B?NUFmZmcwNit0QkFxSXpGaFZoaUNXREZKaVM4TnJkOVJTc3hIQVVReG5tZjM2?=
 =?utf-8?B?RktVOTlneUE3Nkoyb3llTlFxMVdEZU5ub1FFWS94alVTOVZ5bmVPQT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0254fc78-7092-48d1-f4a8-08de69080bc3
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 00:54:01.2137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mva1ZhUmmHscnuSKkcDCucn26EitnC5P/+dHrw5E5iajZHnmRauckZVAdw67lzgPlvFlFCut8dufJ1KTtW/wBDG5ZwxKKk/1OFlwKdHtDEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR03MB5611
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:url,citrix.com:mid,citrix.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70819-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[citrix.com:+]
X-Rspamd-Queue-Id: 280BF12061E
X-Rspamd-Action: no action

> Here is the newly published FRED virtualization spec by AMD for reference:
>
> 	https://docs.amd.com/v/u/en-US/69191-PUB
>
> Please feel free to share any feedback or questions.


FYI, there is a fun behaviour captured in the sentence:

"If FRED virtualization is enabled, NMI virtualization must be enabled
in order to properly handle guest NMIs"

i.e. hypervisors need to make sure not run the guest with FRED &&
!vNMI.  AIUI, there's no ERETUx intercept similar to the IRET intercept
with with to emulate NMI window tracking in !vNMI mode.

I requested that this become a VMRUN consistency check, but was
declined.  I've asked that at least the wording change to "undefined
behaviour" so something sane can be done for the nested case where L1
tries to do something daft.


There are two other issues which are going to be adjusted.  One is the
consistency check concerning SS.DPL==3 && INTR_SHADOW==0 (not a valid
restriction in later drafts of the spec), and one is "On an intercepted
#DB, EXITINFO2 has DR6 register value."  Both do/will (not sure which)
behave like Intel, rather than as currently documented.

~Andrew

