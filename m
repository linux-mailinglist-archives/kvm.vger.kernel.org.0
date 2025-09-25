Return-Path: <kvm+bounces-58713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F23B9D708
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 07:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE40E1763C3
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 05:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EF82E7F00;
	Thu, 25 Sep 2025 05:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h6elsHh4"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FAA155326;
	Thu, 25 Sep 2025 05:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758777405; cv=fail; b=C7zTfUMds9dYxRhhrOq6pPR7u7dfz8ZvrMcdWLH8sld7oNj0UDpCBGgAO+KDHfUASxvWoU4O/PQcIkZGjcybUbHJ8eXL/JgpjGuqUSGaDW2BPq9qvK9ZOJfV213lMHPnBYhFNLafnM9ccEvU05NpPviSNa60L9ZELqmhwBHbLGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758777405; c=relaxed/simple;
	bh=TMWBNwKTa6D6fvxMcpFGe52lNrpWkqPgLH8xPsogZhE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jQSHtSrHeSiSY7cqFvhKrsH8Xbr2VViIroSTMt2BDuhQjbBWsbdheWJnJlc6+TgGzHP7asdFfU9G2KfooMnQgulzoWQjlD2umTmV+uCuA8yuf9NrHxwimETpYcZLvZFCpru8E78GAgEHoGCBuOdKzm6kSHrRj3OopxJAFOILK+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h6elsHh4; arc=fail smtp.client-ip=40.93.195.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rFu9usxGFAVk1brNjfUbRpGfZJxkRkcDMdQnji239nMuG1RPiPNUhJgXO+JJvQDPBiE7Hv1/U+J0q64fn1TVntcH/PexWdblPzi2chISQSN4xAG41uJSjNU1NffJTcOPyGOss002Q2svmvAZPYsiF/nfsskNVpIlGsR/3g3VG8ea4meRmGKcmkUZ8VYG0jCVCVMWmGBkDj8NWiRBrqRQw15m3WkW8l0uky1yfWj021AZM7xnByROZsTGoj6Hsd9YcSOIypSDYq2N8+u/nOttp2TijURdeiHQVZZH1vhYzXIeZrzfGlOdDrDwesokxBRqE82ZpTboq7842hq0WP/Nqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ce+iuWUpbfJyY/X26sIfgF/TOnd0RZ/PLRt4Q9nejTw=;
 b=y0YXf9enpRdbDWL4RXX0FJoQxys6SYttWDtTPLon1+0ua3MHVS79dYSEN1v8gUAasxpKd7LqhfpLmw46WB5/eNNRPXx/6DE5KDl+FwIqwDosqP69VoVK18NLpZbPpcECyxEc+384z4WM+95/TqRZM0EdlLss3g/aMfBRu5z6EYGxmvNL6ixIZJrVw2N7iYb3L7Dj9CfFp1k4jY4J9MDpn4KLmXil10Wo5i/yyq8O57DYzcZKG7qk+BMdoVFewdZaCBBki/5gLgz8PFzGIFNomb0S81aEft5QIpA2RBkN5wzaGLd30rcPGboWc28NWonoPWTTKcav6dQRLA1yht7qSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ce+iuWUpbfJyY/X26sIfgF/TOnd0RZ/PLRt4Q9nejTw=;
 b=h6elsHh4O/d3r1yXaP44Cj82V9WXVux5E+61Nn9Z7UR1UtU6Y37eKq5ja2F2+dLa43ATKX0Y0T06aZmjwWD3LYwUi3R/u7uA4vyogUkILP7Lh7/YSOoOUTDrOGniUtfhEehq7pdqZqJL5+hXK0zZ18Im1f+8JktqkltwepfYBaw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MN6PR12MB8544.namprd12.prod.outlook.com (2603:10b6:208:47f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Thu, 25 Sep
 2025 05:16:41 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9137.022; Thu, 25 Sep 2025
 05:16:41 +0000
Message-ID: <7fb62597-1197-486c-bceb-0563b7a1f5a0@amd.com>
Date: Thu, 25 Sep 2025 10:46:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 05/17] KVM: SVM: Do not intercept
 SECURE_AVIC_CONTROL MSR for SAVIC guests
To: Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-6-Neeraj.Upadhyay@amd.com>
 <82e85267-460e-39d5-98aa-427dd31cfadc@amd.com>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <82e85267-460e-39d5-98aa-427dd31cfadc@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0171.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::14) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MN6PR12MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: d10325c9-f381-43ed-cb3a-08ddfbf2b570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTNOeitZUDFOZG9hTFlBY1dRSmk2WS8rOTdyRHNnazlLVzlpcm41dVV6QWFj?=
 =?utf-8?B?MjVjeVVReHhpTmNQWDhzSWkvcytRMjdqcENDTlIrRUZMRGt6SUJYVXVZRXEy?=
 =?utf-8?B?Uk80ZktRZ1ozUy9xVEM2NVpZeWFBd3BlaTFjOGNNRjZnbmFWZ1JqNmk5NEdS?=
 =?utf-8?B?enpnMThqd0IrYXNzUlp6SnpRTE1NMFoyQWd5QjFXdktaY0VJaGFGYlUwbGww?=
 =?utf-8?B?QVZCdldlYWMySEFEbmdYbHRGWmh5V0VxTUdNa0FXQU5xRXg5b0lEVVB4QTRp?=
 =?utf-8?B?dDliYlI5NEpuK0xPNlo5Ty80b0FyaDBzSUM4MXdmZnBka0RpVHUyeno4bEo1?=
 =?utf-8?B?QlVTN1gzbnlsOWlYTnd5QmZHR1RackhMUTdZRGt2N2VxQ1c5YW0vOWZEVDRK?=
 =?utf-8?B?aGhyN293OExBZEppT01NQ3J6VUJXQkNzdWRoZnpBdTZqOENoWVNPT2I0NXFL?=
 =?utf-8?B?OXVCbDdtNFM3R0RFcWYwWEdWWU9HbDNlMHNWTndXS3Y5TEhGb2ZudVZJYmNS?=
 =?utf-8?B?Sll4S3lXaG9BSXVXTWRNM1BtelRHYS9uSGxJbDQ1VXVVYTd4TjNUUVJwZTBx?=
 =?utf-8?B?Vi9NcWE4NmlVeUhXZytRTWRlTzdYWFlDZSsxdGhRWlZwNVpQOVE3NDByT01L?=
 =?utf-8?B?ZVBBdVBZMW9RYURvK2RRVnU2UDJkZ1dLM1haR2cwcTNZcUpaM1NEa2NJSzhr?=
 =?utf-8?B?TGtJdVZETzBNaENsRi9RaUFKUGpKZUI1SHBCd1dyYTdPTVN3M3BhQ1VnZHFs?=
 =?utf-8?B?Z2NyRjdwL1hQeHNBZ0p5aExhTWpYNVNPQy9KM2lsdjBOblFjSlZtVWI1YVAr?=
 =?utf-8?B?TW5TaTNFMWlQWE9PcUo4YjdRS0JEcXB5NEpqY3BUUVpJejhVVXVsZkZoQTh4?=
 =?utf-8?B?WUttbTZkVWFMcGE4REppa3hGRmVtdWZuUjA5ZHdsUFh2cDhkVUpUMlY5QVl4?=
 =?utf-8?B?SWtPWWgvLzNFMGpaNFY0SHNhS2t0MjFDV2s4VVFVc1JMRjFBVEJ0K2VaTjhy?=
 =?utf-8?B?WHBLY0NmT2lYVVcwK1JLdU9rSklSdzlsSUNJOVRWdGpaUlU5aU9uTllxRnFD?=
 =?utf-8?B?R2RJNURhWjBGM1BOOWp2VjBSQTR1SUJyN3ZCODk5OXJLUFdrRDdNVTEvd0p3?=
 =?utf-8?B?RUZ1LzgvVTZHUW9sMkxVa3VJVVpyWWQ0UVRxMGRCK2xrUmJXK3VxbXI2V0l4?=
 =?utf-8?B?R2c4VkdPRTdSUFpVdmZXaEtMTEhzbGdxM2hHeS8wNGVMaTgvYm9yQ3dsMDd0?=
 =?utf-8?B?VHV5cXU0VHUvRHB5U05lRXhrS2xoWUtBMUFYMzlBRC85VExLcDd5b0R2QUpa?=
 =?utf-8?B?L0pDVDlPdmh4MVl5SWFGU0p0RU55STRwbXlieC9XNzZSbXp3QTA4dnF3TmZj?=
 =?utf-8?B?MDVEM0FQZTlxOVp0SVgxcjEvK3pJcTBYY2dNdzhseGJjVG55OEZEL3JKd0Vh?=
 =?utf-8?B?ajU5Ni85dUtHdFdVempDeXU2bU44MjNBdG0zM1Z2VTA3R0dTQWJSYVNGQXpa?=
 =?utf-8?B?WVFVNGhOaTc2NE9ISWpKZFRUU09qM3lLYitpbXZhWkppZjYyUG4ycldEdDMw?=
 =?utf-8?B?WTBjYm5MUzUvWG1pVW53azZqSE0xM2paaFJ5R3lxZEtFVFY1aDVhU0JESEhh?=
 =?utf-8?B?OG9TUG4rNld0bjUwSVF6M2g3aGFNbFBLbUI4U0lsQWllN3pFT3BYN3NIZXU2?=
 =?utf-8?B?RkoraHRIdjNLM3Byb005OXlVZS83OUdZTW1xdWtWZ25QTnVYa3F2Z3FmeGRw?=
 =?utf-8?B?SUVoVVgya1QwNzdNMDJOTzBJckIwZDRkNjR5THd6MFRXSkVKWno0Z1VUVGtB?=
 =?utf-8?B?MEp2ZGJJcmtLRkNQNnJ1M3VXSEZSUUdlcEhDRVJXaVFlenNkTU9pNUpwb3p5?=
 =?utf-8?B?VTJtSXVUY0RxeDYxOXQxNGw3bWNkWnl5dWlvTHkvaUVETHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1g1dG1tcTBnSFBEaG4zRzdjNzdQODlVTWZxYzVqcG9pL1ZPdDJpdUNwV2p6?=
 =?utf-8?B?MHlBRU1RWjVZQ1A0SWNGRmRJQlZZUHVleFZMeVJiUDRBeWt1ckNTMmxVWGc5?=
 =?utf-8?B?R2UyMERWbThVUGFOWWdMRjhvYUxBWGVoRlhBNlptdlJiT215M0ZuU25xM3lE?=
 =?utf-8?B?U3F3MFREM3FieDkxY0VzTUZVT0NFOGI4UWFESytSbTRHM3dXd096QVhQTGtG?=
 =?utf-8?B?cVVBaC9iYWh4eHNTdXRKZGVJTzRPT2lHZmVGUDVnaS9JWXpvL2kzTlZQK3Q5?=
 =?utf-8?B?am5CYkIvc1NsVzZ6NGZHUXRuUDdxYnlrZFdTTngrRE9qSzBDSDEvOW8vYUo2?=
 =?utf-8?B?eWJPVFBUNUNTbWRoaDljeTgzWHA1a3FNb3dheVFNUlZZVnRZOS8rT1lYMDhL?=
 =?utf-8?B?ZnNFUmRCVktYQi9QM3krVklHRGFoUkNmOFZnZVRBVlgyM2wyUHA4NXJTQi8z?=
 =?utf-8?B?UHpReFVzdGNKWUZJT0JDcTlJV1pLMGFhSklYeThUallmS3VlNGdQQ1Jick1y?=
 =?utf-8?B?TGV2cHBMYzNvVjhEbWlvSWx3bkZjRndpZ0R1NU9xdnRvWStnRExDek9zMEVq?=
 =?utf-8?B?eWxLMDBjSjI0ejJyNHdCOVVtS3dxdVdCeW5FRlJFd1plNCtjbTRSbDRiNUZa?=
 =?utf-8?B?d0ZWWWdhK1FXd2JNVmJIdW5GM3dmMVl6QnBSYmRUblBFQVRyVU00aTd6NzhL?=
 =?utf-8?B?WE5ucnpvaGRFOUFMaE1HRjNuUU94dHI0c25qeXRPMENWU2JlTU5rTVFUd0cy?=
 =?utf-8?B?ZWU4Sys5YmlTaE1WTDJSM3crNnJ3MEJjR2pYSFdXb1BxSmhpV1ltRHMzVmcv?=
 =?utf-8?B?TGdHaG91K0tWTzU3NDBCZGYySkoxNzR2Rm9XNDRuQndjZzhPR09JTU1mZXpv?=
 =?utf-8?B?L0xidGxzbGN2WUZoSzZobDMvTWR3ZXMwNDBkVG1TRVZoYTd5MWVOT2wwRzBj?=
 =?utf-8?B?akIvTGhPdTlSY0FWVytLT3NhQUFpR2FUSi9HM1BIQlBQMlJ0c3ZHTHF5THM5?=
 =?utf-8?B?RW9GVlVkS2dEOE9mUmtkSTBnVXFHY2psaGZ6UHlVOFhxOVlramV4N2RyQ1N5?=
 =?utf-8?B?QW82U29pdlhhL0xObTA4V1grdEp2K3JGU3cyV3A0Nk14ZHVaNzd3ZE9BSUxK?=
 =?utf-8?B?eWlibUhFeDVJQTZ5MkoyR1RnWnlZb3lUdGNjUGZTc2dUSUEzNTg2NXpRTENE?=
 =?utf-8?B?dXhYV09NUjlPU2k5d0Mvc2JkbUM2VHVZNTFQeGdPTTI0VWRNV0F2VXlpUm1J?=
 =?utf-8?B?UFJiUTVRSGlPTE92NmUvSU9qb0N0ZFNPY1VHS2hmY2FNdUE3b1dxdUFVOUtn?=
 =?utf-8?B?NjBxRVRuL29weWdFd1lORWVoeDlzaGZseXY3T1pHT1dBQU5WSDNOQTFydzgw?=
 =?utf-8?B?Ti9JQUpic1JUaVpWR1hRbzd3RVF5VUVjbko3NFk4amNmWFlteTYwVDhaU1pm?=
 =?utf-8?B?UmJiOGFCSnVLTVNUdzBKN2JzdjBWT25Yd3JoNWxWSS93WVZ4MS9UOExOU0Fq?=
 =?utf-8?B?RlVSelNhL0RpRk1YTVZobTA2RUIzdnU1ZGhNSmNRNHUzb1dnY05oUDJiZXFO?=
 =?utf-8?B?TmNraGdQT0tkaWw5VDdSUjV1c3cyYnFrZkZJdUNnaWZkQm1SWWNQT0dKdXU0?=
 =?utf-8?B?OUFYbnRmcGpJR0xERzk0d21xMk9mbE80Skl6VzF3REFlQUZ3QzVVWmRxdUYw?=
 =?utf-8?B?TFZGNWd6cEZlRzFSY25aNkdsY2tMSkRwTHFTQmdEZkFYbFdQZzdZeXdtWjdz?=
 =?utf-8?B?WWhlc3NKRzZVdlZkd3BEcTdWTndYMU1RRTNiN2RibFJQT0NvZzE0MVFMNlpB?=
 =?utf-8?B?YnRma0NEY1Vwb3habzFQaFluMy9jMnUwRmZ0VWRENGpDNW1RSHRWeXhYeE5w?=
 =?utf-8?B?RmtzcCtYbitVUmlZcHdhYm5iZ3ZqWTZXelNzdWEzTEpMZ0RYeTJlVXRucVVT?=
 =?utf-8?B?WmZiRWp0WndwZEd4WGd6NGdxNjNvUWdUOFNnYnorSHBNRld2cTlyZXpiY1JM?=
 =?utf-8?B?Y0VHU1NDZHpiNitwOHp3NUdrdXo3aTNLWnQ5UzIzNVpqWWJnRmZ0bnFhUFJo?=
 =?utf-8?B?dVhnUkpka2F0R1ZOSUlWWWZENlduaU92M05kcW9hNm44ZDlITHAvTUQyOVJx?=
 =?utf-8?Q?jfpA95bX8aQtKrfJFRObvjV4m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10325c9-f381-43ed-cb3a-08ddfbf2b570
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 05:16:41.1063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnPXH/6g4S274fQ4NvuE6LvCwssB3qr32h3QNkDIuIam01+0VRIG4+uSLvX1w4Tf7qyButv7c6i0WQw1C/OV5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8544



On 9/23/2025 7:25 PM, Tom Lendacky wrote:
> On 9/23/25 00:03, Neeraj Upadhyay wrote:
>> Disable interception for SECURE_AVIC_CONTROL MSR for Secure AVIC
>> enabled guests. The SECURE_AVIC_CONTROL MSR holds the GPA of the
>> guest APIC backing page and bitfields to control enablement of Secure
>> AVIC and whether the guest allows NMIs to be injected by the hypervisor.
>> This MSR is populated by the guest and can be read by the guest to get
>> the GPA of the APIC backing page. The MSR can only be accessed in Secure
>> AVIC mode; accessing it when not in Secure AVIC mode results in #GP. So,
>> KVM should not intercept it.
> 
> The reason KVM should not intercept the MSR access is that the guest
> would not be able to actually set the MSR if it is intercepted.
> 

Yes, something like below looks ok?

Disable interception for SECURE_AVIC_CONTROL MSR for Secure AVIC
enabled guests. The SECURE_AVIC_CONTROL MSR holds the GPA of the
guest APIC backing page and bitfields to control enablement of Secure
AVIC and whether the guest allows NMIs to be injected by the hypervisor.
This MSR is populated by the guest and can be read by the guest to get
the GPA of the APIC backing page. This MSR is only accessible by the
guest when the Secure AVIC feature is active; any other access attempt
will result in a #GP fault. So, KVM should not intercept access to this
MSR, as doing so prevents the guest from successfully reading/writing 
its configuration and enabling the feature.



- Neeraj


