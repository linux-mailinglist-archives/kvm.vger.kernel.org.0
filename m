Return-Path: <kvm+bounces-40450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85288A573EA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C85A7188C8B3
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB902594B7;
	Fri,  7 Mar 2025 21:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uDIRlSBJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D11258CEA;
	Fri,  7 Mar 2025 21:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383854; cv=fail; b=AyiKM0aPQMQ5C5oMCRP71pnMXooNW8saEgHOrsIVnM8mhvIJAPMCkk+6Zy/n+cLRD/5GzRCJ4WpfGD/EI5a7V8xfFl3YoeRQtYtlBxf36wbg05B3jktbCgtpIfu1JU4Bhd+9YFtYYvg/43m1aLxF0653xRtoMrZCcv74SePt72g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383854; c=relaxed/simple;
	bh=dtP+UiJeEOy6jcC9gwUA8uPk2tdntemILa8ozti2jNs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aQKLfj/ogVyDScul/3YlujGnYK90ECTNf+3GSxEZ6upKx+rgcs9moHOpkk83NOMuTSEq1XzOnuVVTH8tfG0G0FkgJI/vsphVYGJwbhOALRVkBGkiT0x8qOgahYKU5vdPiKpZG1alKT9rqdZtvoXHUO/M+XNIkJE8dt+UPcefwmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uDIRlSBJ; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j93mYtG5mWm9EpoCr3x2LjaVNm5/lQnLFgtDfDLMJoJMYVRMisYrN6PzXUq8pZ1RQK4sjdllccH1j2y7bJlSIoIGjKH43XnUHp/AYxS02FjEjp5dJIaZijHxqbCOlUsYjyNWwiaJFfQbzNiCsdlSttTRwNYA7ptTYPgv1tkHHXKpHrs/v3MV8MSriBJiHnHQVYqROnJ7X8zoe1DH4gKXAsNjGBm7h9aznGx9D+HpgdlTDIwHJhCxrOjX/3s9Q+3iJ5lbjiOH44aErsgauB/mDi8kJ1hNm+dkxaoN35alSe20ajvDwb/95LORyC/d8Peu+/0nJnMyPcco2z/11sRccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oipYKMcBTGolpvlsH7UA/WmB2dsmQ0D0Z9ts1dadniA=;
 b=H+SJxwF6Xr7z7OWAJiyBxMcyDUzw9hu0ZqiZa+8JVBOUjRVQV38tG7oquzNB+9B7AbEaLM63RNFfBmhiaOaFLuvczfLSKXYbRn9KKmOMYrNx2BqcWwZN0RmOM0U6k5RqBlY4Qscp9lKkSOIEhKEeBA+vTbT1KPKdWH/wHzEUSfNzk4C1MFaddciDZSbG2fg06lwZTcpMBxYB5ekb7gyGxHyqhiXuj6Nbjm8+EErcaxiT8ey1xwXa3aQ/N4ALGY4MwHnc4hRtCeZbutYGAu2Br8QPyLeVh/HjxH3ryWM3DbaPHwgnCrx0fgZXT4mGH++Rn7TxCR3xo1q4oPeHbHHi8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oipYKMcBTGolpvlsH7UA/WmB2dsmQ0D0Z9ts1dadniA=;
 b=uDIRlSBJ3pYZdeeCyB6Qs3HvlNWqN4PHMuE8yExDXLM+hUVXzyljNDS6oBC/jSeOnOSHt1PTZleMm6uMZETy+W/fYWluXUqu+Gt7jAcDBAS58DU7IqP0mpS+y/PzGbSZ0QXKucO0HTEQUxSnEz51GCr5bOMI56pCoE5tb8Hp4UU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PPFB21296325.namprd12.prod.outlook.com (2603:10b6:61f:fc00::620) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 21:43:56 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 21:43:56 +0000
Message-ID: <0511e641-a122-6ece-ec83-8340b5d08e39@amd.com>
Date: Fri, 7 Mar 2025 15:43:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT
 fails
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
 <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
 <fefc1f1f-fc06-a69b-3820-0180a1e597ce@amd.com>
 <151f5519-c827-4c55-b0e0-9fb3101f35d4@amd.com>
 <8d1884d7-f0a4-07b0-c674-584f9c724f89@amd.com>
 <aab18e65-d311-436e-b291-efe3660a5b92@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <aab18e65-d311-436e-b291-efe3660a5b92@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:a03:54::40) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PPFB21296325:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e9de71-223b-4e3d-7d2b-08dd5dc12965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFJ1VG4xOXRZYjZESWxaQ3hWQ29DOGhtWHFyZ09id25tY1lGOEpnNjhkMVpL?=
 =?utf-8?B?bXpPK3JqWnRFbUxNNUlSbENKTmZ5V0M5bzAwbXpCbE05U29OUDZWUUZRZ2RL?=
 =?utf-8?B?ZmdzTzNPQklFUnYrY1RiaEowZ3Q2WTczS1FkTHlwN2Z0ZzNMeXMrNmFvcGZH?=
 =?utf-8?B?OUh4aHpBL0dUWTc1aWNNeGhWMUNEOG5QeFdodTZhMTlndUpSN1h4YUxoQzJJ?=
 =?utf-8?B?cW1qZ0hYcTBSeUJBMlJQZ2R2TFdhM0pOQXQ3UHFKNmZWQ0VhNVlMeWJaRXlv?=
 =?utf-8?B?K3VlQVZVT1p0VEh4OU5wUjl0TGRoU2NGOWJBZW1lWkdnM1lCZXI0SlN2cndB?=
 =?utf-8?B?U3M4OEtOYzhyR01kQk90dUh0ZFVmeTV4cWloV2liS3l5ZlFyY1IwajQ0TllL?=
 =?utf-8?B?WmdmMU5lUXQrS2RKTU82WjB1aVdVQTVNajNGVDN4M0dFRmhNMVpXanp6K0x3?=
 =?utf-8?B?K1F4dHlCanNaSmtINkJnMWNGM3ErM09KNDh0Q3BOSE56TVN0K2xhM1l0Wkdr?=
 =?utf-8?B?N1BaNzAzN3Bhb3BmdmN0bmNleDlqSGxVdmo5d1llaEVUTGhQaWg4Vkd4Y1Rt?=
 =?utf-8?B?WmI4cHNQdE1iQjN5RXBBMDZFTDB2bi9DcWxDWU9LMHhxa20xeURucEpPMlp3?=
 =?utf-8?B?N0hQb3kxbXJod2R6cTZ2YXpkNEZ1VmxzQnJHWldFdmdYTzFTZWUvNUVybFNX?=
 =?utf-8?B?bFQxR0dIMTRmeVJuSENDQnRpeDNkTHYxUmYrUDh3T1VvOTgyU0Y2YmlFN0ts?=
 =?utf-8?B?WEl5c2UxN1puMzNaTmtmTW05RjhVZ3ZhajdYcXVUdk96QS9NU2xldFJnbE1J?=
 =?utf-8?B?Mm16ZXozcVRLT25GMHFWaGJnQ2NHd2hjaUppb1p2UDFVekVxeEhhb3haaU1p?=
 =?utf-8?B?UkpIRXNlSW5QdkROaFVqMzBKZEUzNmhwWWtXWjQrV3Z2T0lYeUVyYjMrdXVF?=
 =?utf-8?B?UnVxK0xOVU9NM0grMnl1MzBPdnNVNWdOTnNwWklXY3Jia3hEUzh3S0hCU2dl?=
 =?utf-8?B?UTZjTVlHalZMSDVsWFN3RHczRlBDSmszdGFLUVVnS0NZS2pqcUhHOEFSMXFn?=
 =?utf-8?B?YXJvTVVVMnNZV3kwQnpuMjZpcndFTmIrTHhHSDZ1MDJXdWEvYVdGcjZsQXYr?=
 =?utf-8?B?TkZ6OEFoMW0vRXErK3JGcVUvOFB1QXUzRDZHZTdOU0hWaGNVNzBXWjRRaU13?=
 =?utf-8?B?ZUs5YjY2NXRxTW1hSlloSzkzRXdiVjA0ZkQ3Zmd2T0haVHJSVlNpTDc2U01m?=
 =?utf-8?B?UW4vWW51VStEaytnVnZjcVJZQVV1VXJWVDJYb2xYZ0E4dDl1T2kzMVN1SCtO?=
 =?utf-8?B?ZWpjSDV0ZDB0cW9wT1NqUVliYisyWXI2YmQxeEZZSzhCeEtMZUVtaXY2Qk1T?=
 =?utf-8?B?TXNGRm5JNVhXS0ZBMi9aL1ppWTdEcmYxNHVpRGQ3dWV6YUlTa0dETXNZUFhl?=
 =?utf-8?B?ZXJQOWlNeGxqYU9PeWM4ZDJYMTAxanJVbVdtNThhOTY4MkVQaGkyRDRNTFFR?=
 =?utf-8?B?VDJCekFVM3JWMGtuWFFscFViNkgyaHVZdUVmRWZqY3lTUnBHRG5oa1ZmVk9G?=
 =?utf-8?B?L0UxUG1OdnJ0S2dpR0h0VWFXVTdyRmkwVkUwUnRzN0xlYVJZa0pRNnhuays0?=
 =?utf-8?B?bklsdEVMMGc4SU91bDJwSTZRaGtsSTBZaFI3VXk0Mmx4UEJBeExlR25xN2JR?=
 =?utf-8?B?eGNXblQ2d1RkWTA5ZTBtMzhlMHBwVHdJZlUwY1I1NkU4YXVEdVlVc2JQcFhv?=
 =?utf-8?B?OHFCUDF6SmROZUphWUFGeUlqOFBDSGpiZHpnc0JYcTRKUkwzVW9la2RYOTJj?=
 =?utf-8?B?MFoxN05OZkFMamlMUXdiS1lPYzY0Y0hDQ0krNXVOK2hjU1R0cVA0eEFSeksx?=
 =?utf-8?B?TTJ1L0VESU5iMDFZRThEN1RhZWZmM0FBZ21zQTZaOUEwMk1ib1pzeU5YQkdO?=
 =?utf-8?Q?0D2TMcKgNOE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZS9OL2xFdXpnOUFRL1ZpZ3p5U3NJN01hUUlFVHdwckp3MENZSDJSNk42Rzda?=
 =?utf-8?B?cXpnbVlhMnRtSXZiKytQMzdmekNxZmltK3FkOXVnQU9ZQ0U3OFhlSi9PVlFQ?=
 =?utf-8?B?ZnROb2JHOUd1WmxyME9oU294ZVJWRTlJUTkxRy9TRi9yY29iZzZJVFVpUFFS?=
 =?utf-8?B?TkRTeWcweFJPY0RZbWZUa3ozc3RiUGRKQ0MxRXR4V25EbmpFT015VmhzbHQv?=
 =?utf-8?B?Q251QzBkaVBtL3FGanhTWlBrdUE0Ny9XbWV3NWlJSzBEZk5hZ01SMjZuUXdt?=
 =?utf-8?B?aG1mVmpkVVdDSFVYT2N4SXhQWWg1OUQxSFppa1V3VXJySHdacEc0Z3JLSmlE?=
 =?utf-8?B?cTFyREdTd2NkZER3bXN0ZHgwZXA2TDJGRkd3WGdEeWdybDMwRkNDNUcycWl2?=
 =?utf-8?B?RjFpU0VTRFVibWpFOE0yMmlGRTZJMmw4MFRLTXdkUEl5Y0V5bUxoWHhySFB0?=
 =?utf-8?B?L3EzcUFHY0lRejJRMURpRFhXNktFa203Q1V5bkdzYU1lMm9lblZ6bWd3eE5z?=
 =?utf-8?B?VjNNTGV1MlplRUlwcm11VzY0RGhuNHV4aUh2WTAzOVA2eGpxWGFMOG00Qndl?=
 =?utf-8?B?VXZmMHlzTE8rZFJTbkF2ZDlnVlFYVnhGdWROOWhISU5EaUVHdDVaVjQ5dlp1?=
 =?utf-8?B?RWRjMElLVmR4ZE8xWTJsazdHd0QwZ2x4VGJFd0RtZ0p3ajJRRzFLZk1ZWmpL?=
 =?utf-8?B?alFFbDRiUXliUVJseTljbFNmTlROQVNuUFJvSStrRkV6empUcFRHeGxpSjlm?=
 =?utf-8?B?OUZXN2FCdzhSR0VhQjdEODhvQlllR203NXpjY21pNTAyVmtyRXJITjN6RzZY?=
 =?utf-8?B?S3lBcENSdFlOVHF1S3l4c2E0bStUYWtkU3Q4RWFUcHhNV3FBSjJkaXVRUVcx?=
 =?utf-8?B?aFdXUXkxbDd6dkhSMkF2M3ppVm53N0M2RWxPWUNhTTVhSUZlV09sS0RKcmpH?=
 =?utf-8?B?Y1Q3ZzhXajRWamRPZG1KbTZnL0xUTUZ2NnFFUDdTbnhuUk52UFJuVGtOYlFj?=
 =?utf-8?B?ME51Q00wRlRDb2RlOUFwN01uenllNXBpczJwVGp6c1lWM2NBTi9DdDYycm9B?=
 =?utf-8?B?RGR4TUY3M014SHdaTzJGemdOdk13WGxkUER1ZVI5b0RraW45OUlQTEhVV3Ur?=
 =?utf-8?B?U000UUpkM0t3U0xjTSttVnJEZThNK2dsYTUrcFREUWpaUmVxSCswWVE3YXhB?=
 =?utf-8?B?bUZBZ0lIRThLRDhEeGgxMHpPVnFKdjVHekZRZWt4RUtDOW5FaWdVRkl5Ri9K?=
 =?utf-8?B?UnNxeFl1U3NGZHA3SkJ3aTdZQVAyYTFaeVpKajBzS0lrSDZtMFBIZUlqVk80?=
 =?utf-8?B?N0dNME9KMDFmNWMzYzVDT090dTE3UHA4OWgrUmNVdXJZNnVFU0VqV1pidTBO?=
 =?utf-8?B?bUhLMU4xa1N5RTFyQkwyMlBDSW9kYlVQSDhGZG1RMVFkZjFLeFZWOFkzOC9z?=
 =?utf-8?B?Vmo3bGJJYjVuVSt6SXI1QXd0RllhYzNEaXl3K3NUa2dzMWRKdWF5RUt1dU94?=
 =?utf-8?B?eGFOb09DaTJBR3k0WWxUeGdJaTlndE1LUCtQUXZhUGdKZzRXOVpwYnhoVXJN?=
 =?utf-8?B?QVhNbHdyYW0wZEJBcHdob3lUQjU2NU1TOHgydTNTbmQ4c2orOWZsM3FrTGdM?=
 =?utf-8?B?Vi85c1h1OEZuMktFUzBJcW1GOStTM0s4MzFMMXhGZi96N08vOG1BNEtrWExS?=
 =?utf-8?B?Q0VuejdHTXNqeUhMTy94N3V2OTdUK3ZYQzVobldOb1k4cHhXZE1EVU9OelhT?=
 =?utf-8?B?K0ZDa2JpUm1MMlRiQWw2SDQ3TXdWZURrNnUwQWRZeUhsOW1NQ0UxUTlhSnNj?=
 =?utf-8?B?QTJqeWhJMDVNM2R5RUZjTXdHb1hDRlkxNXlWQUdwWGlyWmVJSW42YlZETXFm?=
 =?utf-8?B?VjlPcGF3ckVTUDU2U0V0dGRRMDUrckR0VjY2Y29YUnlFWUdkbDVNeHR1M1FF?=
 =?utf-8?B?S2dIQjRodUdSZkpjcEJteWlMVXNsUW5DMVEvMjNmT3pGRGpOdGIrQzhOU1dY?=
 =?utf-8?B?UjQ2KzQ1bzN1K09uR3lvL29kbTI5TVpJWXlnUkFzTEswNjRQdEpraFBVY0k5?=
 =?utf-8?B?bCtVbTNjc1Nma0c5SWR6WHJsTGdCWHJha1l4UEEzZ3dTRGdrK2tXdGdHQmlh?=
 =?utf-8?Q?c+h85mSclRz27Xlm0PTi5zDKy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e9de71-223b-4e3d-7d2b-08dd5dc12965
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:43:56.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQ6uj8v0p2ocfA86HduHmX2QJ63vPCGl7kFyLUTxD1DcmazFcDvuEPa0tpWDGf6tZJyrQco0ISLizLayWDAu2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFB21296325

On 3/7/25 15:39, Kalra, Ashish wrote:
> On 3/7/2025 3:29 PM, Tom Lendacky wrote:
>> On 3/7/25 15:06, Kalra, Ashish wrote:
>>> On 3/7/2025 2:57 PM, Tom Lendacky wrote:
>>>> On 3/7/25 14:54, Tom Lendacky wrote:
>>>>> On 3/6/25 17:09, Ashish Kalra wrote:
>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>
>>>>>> If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be
>>>>>
>>>>> s/RMP/the RMP/
>>>>>
>>>>>> initialized up before calling SEV INIT.
>>>>>
>>>>> s/up//
>>>>>
>>>>>>
>>>>>> In other words, if SNP_INIT(_EX) is not issued or fails then
>>>>>> SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.
>>>>>
>>>>> s/once/if/
>>>>>
>>>>>>
>>>>>> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>> ---
>>>>>>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>>>>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>>>> index 2e87ca0e292a..a0e3de94704e 100644
>>>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>>>> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>>>>>>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>>>>>>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>>>>>>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>>>>>> -		return 0;
>>>>>> +		return -EOPNOTSUPP;
>>>>>>  	}
>>>>>>  
>>>>>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>>>>>> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>>>>  	 */
>>>>>>  	rc = __sev_snp_init_locked(&args->error);
>>>>>>  	if (rc && rc != -ENODEV) {
>>>>>
>>>>> Can we get ride of this extra -ENODEV check? It can only be returned
>>>>> because of the same check that is made earlier in this function so it
>>>>> doesn't really serve any purpose from what I can tell.
>>>>>
>>>>> Just make this "if (rc) {"
>>>>
>>>> My bad... -ENODEV is returned if cc_platform_has(CC_ATTR_HOST_SEV_SNP) is
>>>> false, never mind.
>>>
>>> Yes, that's what i was going to reply with ... we want to continue with
>>> SEV INIT if SNP host support is not enabled.
>>
>> Although we could get rid of that awkward if statement by doing...
>>
>> 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
>> 		rc = __sev_snp_init_locked(&args->error);
>> 		if (rc) {
>> 			dev_err(sev->dev, ...
>> 			return rc;
>> 		}
>> 	}
>>
>> And deleting the cc_platform_has() check from __sev_snp_init_locked().
> 
> We probably have to keep the cc_platform_has() check in
> __sev_snp_init_locked() for the implicit SNP INIT being issued
> for various SNP specific ioctl's (via snp_move_to_init_state()).

Oh, yeah, the very next patch calls into __sev_snp_init_locked() now.

Thanks,
Tom

> 
> Thanks,
> Ashish
> 
>>>>>
>>>>>> -		/*
>>>>>> -		 * Don't abort the probe if SNP INIT failed,
>>>>>> -		 * continue to initialize the legacy SEV firmware.
>>>>>> -		 */
>>>>>>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>>>>>  			rc, args->error);
>>>>>> +		return rc;
>>>>>>  	}
>>>>>>  
>>>>>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
>>>
> 

