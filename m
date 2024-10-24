Return-Path: <kvm+bounces-29629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0776F9AE4C2
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6E0D284582
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04EC1D5AA8;
	Thu, 24 Oct 2024 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t4eveNpI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A6A2744B;
	Thu, 24 Oct 2024 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773097; cv=fail; b=jC9I9drtu87cRPwixTRnKr0YQu8kvejsB0bLmZwOdDS2vZHzjpz62RNuLqhIuMO+UEn28U4dp0GmxWhaNzTDyxzYig1bGn5OChPIE6VhIlcnsGEw3X6HvT2eQYXDwhfVrajBlBLi2ajf/fj7zoZP7Kwxb9Au+3Y7WjepFkD2olA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773097; c=relaxed/simple;
	bh=NtG/fy7+SNNSiQdB8/u3bHDxUyV5s/IflJ+sMYO98nM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=evKfihhBhoT/ztkekkMi3O/IuLeylYWoRh219EPXWVSiMR1RZ7WxqB9TtUuvnkgIt2hW6N7ZweTdvzzu1u5aNZ/RRsCyWRyxt+x905DFPkOTzkWVwptaTBmXroKT4OLmWShCWTSFeWV5XNmNMenf7/+VYywo7ceDkaysxtCJrrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t4eveNpI; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pK5G4H5TMfM1toDK7pdqTx5uurVsTHBwN043Pf1wh+bWzuxB+maYc5ccVbZPyNw1rPq9IrFpuHLMs4yIXPqujdgxOku5YHNAwHEFXPnGM2IPk84X0GcmPDYn7oVtowjKCnoJaIZYD4/HyvvwaqtveH27J7V2MRdMekxgP4NqTQcVqL64gu2a3Y4PBRsbQUCE5apIAy4G3G8lrv2Gh7Ej6Q/oc6Vj39prH/i3+I8K4VyXfP6PxOxQQk3E6Ralcl3tc4rAeV9eoN0S4BJ2DeutqrlAlKzAkA3ZiJ5Bor8q8u/M5UtYY8sxSh8JKMQHhAGuPRzBHqYwDicc+a3Dzmsq9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7MnrwRhgrbt/d0+zaPMoS5j/YmW88FlD5t1C5nWg7uM=;
 b=fZOuXVHnQ7yA3MeYc0j/458VKD0K7Suzh7vjlMkdL6vyvJYm7Z8iDOz8/2EF594TFPBSf/yi9y0dSEE/RoYf7EISCE5CaDmceyWR05gSbR2ofOyZxqL36/vUDlQDfgA9X91ppGP1Eb7tnzTCyGMNWx2EzFIKbSHzZpZtfY7reWLF3XZ9vfubq0v7qIXBHmD0TvzbJ7cpqjn/rib9IltKrR/HJ/C9Q573cRGIXtWWp0PYrbKTQDQ53HorYfN+5JiaC1ADBntH4LB/xDrFE1DvFFynBrg2ykrTVspANB258Hwf1Lw4dKE7K779B9oN0KqJoNZOrtv9w6ujXyFPgoJX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MnrwRhgrbt/d0+zaPMoS5j/YmW88FlD5t1C5nWg7uM=;
 b=t4eveNpIEUY90/3ssUUoIH1gdmMmt2JcLi01N4xJcTfmU/T7ktqiQZbRnLZnEEO3d62kAItenLsj0Tq1Pxh/JVgykvtzVmt36xvXQpsjEeF3FpBVRu97V4lS2lNKdmdbVbDakryZHwJ6PyvUNaA4+6I0sHIaUtKZujbYbAzLOgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 BY5PR12MB4211.namprd12.prod.outlook.com (2603:10b6:a03:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Thu, 24 Oct
 2024 12:31:30 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8069.027; Thu, 24 Oct 2024
 12:31:29 +0000
Message-ID: <358df653-e572-4e76-954a-15b230d09263@amd.com>
Date: Thu, 24 Oct 2024 18:01:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
 <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
 <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
 <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>
 <20241023163029.GEZxkkpdfkxdHWTHAW@fat_crate.local>
 <12f51956-7c53-444d-a39b-8dc4aa40aa92@amd.com>
 <20241024114912.GCZxo0ODKlXYGMnrdk@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241024114912.GCZxo0ODKlXYGMnrdk@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::16) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|BY5PR12MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e0ad10b-f3ab-4cd6-58c4-08dcf427c8ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1o0WjlJejJBWUFkbGQ0eWF5bCswRUV3QWMwQWZJVlpXK1BaM3BOVjV2WkVv?=
 =?utf-8?B?c2dHTmUrUVVhWHJQVTk1eEhBSlQ5OFlsTHdoS1ZhL2VTcDNMTHdDRW9sdTVO?=
 =?utf-8?B?NDY3M0xHTTlsVlcza2xrVFFCYzFWcUJwWHVxdnkwWnVWaFRma1FxbGhDSlBu?=
 =?utf-8?B?VVZoYVpzUlVaY3hxdU94d0RkbTVVY3dmYTRVS3gweTRxdXJxblF1Q0Z6RUZH?=
 =?utf-8?B?UzBMUk1qRTY3UEJJb05Bb09OZW9jeVpmcmRrWDdSSWo1SkhlbzAyUFliVldW?=
 =?utf-8?B?cE9PUmxKZzFTNWxTQXRMekRNdkFpUFdUMktPb0lmZE8yVktNdWpSMTRGMVJS?=
 =?utf-8?B?OXBGVm5WWkhCNVZndEVtbkU4V1Q0NkRRRXc1dEl0MFpjbzVVdkZSNmhPTnV0?=
 =?utf-8?B?ZHB4Y2p0TTQ2RFIzSEZ1UmZPTU0xNzM3S3FpZjhPVU5IRGRlZnR4WVZ4cFBj?=
 =?utf-8?B?WW1xbDNmQmdJVTN3ZEJBUjQyZFN3cW5BT0VZU0V4OEN4MW1DamkvTFp2c3F1?=
 =?utf-8?B?aDVEdVo2RjZyWlBMTVNPR3lScG1RQjZaWTd1UmJGbnRVQ3RJWENLa3FlSGVR?=
 =?utf-8?B?YkpHcjBXWWU5ZVFFTDRVZno0eVZGTzZrdm1jTlNNTXFNcHVEL3VTaTNGTWI5?=
 =?utf-8?B?RUhTNHIxZ1NCaE9saC9taWtoaFkwYlUyTWhmRmZoSXp2ZlhNTHFtaU5aU2lm?=
 =?utf-8?B?S0VUUFk5bmRZWTkzNHcrWDRwZXZZMUhqQzRtT0c0c2wzdUpQUnBkeFhrcVVS?=
 =?utf-8?B?cWgyVHJiNUVZTmx3bHlzMDJOSEs2QUxNc3kyS2JUK0N2ZnpRVFBQbnZ6alFM?=
 =?utf-8?B?dDZERk9Tc2NINGxUemNvTnlRVE1MK2k1TFdOZmVtbThyVGZ1VStadHZ6eng4?=
 =?utf-8?B?aHRsRGtyRGQzSVVEN3N5aTV4ZzhXcFhNTkh3SU9ONFFMelFobHhFdUc5T3RN?=
 =?utf-8?B?OUtidHlScnFmQjhrSWxNdHExUUlRbURDYzdLcTJ3K1dnMGkvUVpJWTdDUHlp?=
 =?utf-8?B?QmhJSWc1NU12cG9jL1g2Y2dEb29GR2ZRMDRuNGxHMHo4SEV2d1NScmRuYjJQ?=
 =?utf-8?B?NW55dUsyS2ljV3h2L3Fnak5ydHRmVXV3UlA4eXpjR296cHk1WDMxVjVacnJk?=
 =?utf-8?B?NFNjS2QzdDJ2RGdQYk5OTWFHZWZsYk0xbnYvczZLSjgwL3l1VWg2SFJFdGNJ?=
 =?utf-8?B?QUNzbi85c3NxdERsV0M3SUg1R0l3TWlRQlBTVjkxVFFYeXcxSXl6NzBhU3A5?=
 =?utf-8?B?SDV2OXpNQkJRaTY1UGJrbGlWTU5ZNC9PNTMya2l6NWt4VCtFeE1sOE1Ya251?=
 =?utf-8?B?VFVKbUdYUkt0MUlEVU4yWlc4R2tzUGtVZGlkQTVLOHFVN0NyWTJQeThxaytn?=
 =?utf-8?B?N0xITTRMM0FDQXpxYW1XQSt4UG9mZHBzUXdadTRiNUVOcE5JVHBoZkxsanFR?=
 =?utf-8?B?Vkc3SlJPMm9rWTdqMHYyVWhMOVdsMUtyY1NMRjl0WEtUV3IzSnNMY2o3cVJC?=
 =?utf-8?B?UVJVeDBROXFKdjMrRjlKYjNhSUFWazBTUlRYbHJkNzlqb2g2a1QxTlk5ZVg1?=
 =?utf-8?B?YXYzdFhjVHBGaEdmRUkzWmVsUGI3WjZKYU5Sc05BUk5oZlk5MHFid2w1eEt6?=
 =?utf-8?B?bTFTZU81WmVTTWlIS0FCbzFhdVZJMXMxdk04eXVFYkd5dVV3WnZGVVFHSXo4?=
 =?utf-8?B?alBkWXFTNk15aFVkbDhlTjh1NHVDQnN4ZzMrajVKN0p3TjVFOFFGdUpZVW5B?=
 =?utf-8?Q?/qKbRHugRzImE4X2xG6dCW4gpaEXmHIwdCsBLAm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?angycVZxNUF0UlczRG1XTUFYYUtiUHpvY2dkWHN5cWI5cHpJeWJUcDMxNGlZ?=
 =?utf-8?B?cmxveHp2L2o4ZzZXQVpZZzhWVEJyWXdGeHhrOFN0dEcwYnNXTzZEWFJpd0NG?=
 =?utf-8?B?cXdtQWtGbi8rU3dHb2xyRXA4aXlmcWhObVhkSGxyNWZka3VLNmp5RTNzWVRj?=
 =?utf-8?B?WGZJVnU1L096Zjg2ZlYyUVY1Q0JjRG8rRDBCUTdURFZzR3MxT09FZ0Mwd3lr?=
 =?utf-8?B?T0dWUUZWQUtWL0pkdklmdkdrVERqWlIxbE5VbFJuZlNHYitJVk5xY01qQ3B5?=
 =?utf-8?B?M3R2NVV1V085K2d5U2hKUFc0a1pFU29SZUZVOXQ1NHdhcDZhai9SSWNiNGNV?=
 =?utf-8?B?WTFVaGRMaW5wZmlQdWt0Z3Ixek9FL0ltNUpxRDQ0dDNBOCtGdkZINGtlSlVi?=
 =?utf-8?B?bFJKaS9BeE9rMlNjcUZxTUllN0dUc3RwRmluTHlwemVvOHErUzRpb2R4ekg2?=
 =?utf-8?B?d01ISHBKYk94WmNsZi8ycEVacGFSeXZZMzloVEpPNEZ4VkpMNWFIaUNwcmFW?=
 =?utf-8?B?T3MxUE9IdHI1MGFBSndsMTVOejM1VVhRV0dQZmZqcmV0OHg4OFFGY2pON2xQ?=
 =?utf-8?B?QWg4dFU1SVduNy94NDZ6Q2RPejdqL3FOQlBvSllhSHVTU1NjL1FwMHJXOUxS?=
 =?utf-8?B?c2ZXYTN6YnR2YUhCemJCZE9XQTJmSnc1Y3lzbVpUMGZMc2xid0l5bC9lS2pC?=
 =?utf-8?B?RWNKdytxMTBZNU9EWXUzbllQblJWdEg3aTY1Tk9BOHhrdjF6NGtodXlXTnlN?=
 =?utf-8?B?aUdmcU5ibm5JMDZHdHNNNW1pbmhuT3NSRHBpSDRCc01kcmFTZWkwV3phNmdM?=
 =?utf-8?B?djBUS2dDSHJJRC9kS0g2QUR1ZjZ2SXFYanNvYjJ4WmFuS3RFNXN5Q09TeDd0?=
 =?utf-8?B?aDRaTWpxNjB4dmNWSmNWTVVNdStBTlZQODNWQzBrbXp4STE0S292eWhEUlZ3?=
 =?utf-8?B?MDljbEsxVXk4YnFnQ0Y1NnkvZzJlQVZ2a2VJYTNnNFdCSGJxbjNuMUlmTHB4?=
 =?utf-8?B?SU9teGR0SFV2UkJ4bWs4UG5pZTRXZUcxV2RnTi85RzkxMW5kanFBNGV0TUFP?=
 =?utf-8?B?RmdBNlJ6Tm1QSE9rU0kvMHNMT21UVFJ3LzBERG44bFBiSGx1VVQ2RERXakxa?=
 =?utf-8?B?M1BxOTM0SUw3cTIvVDVMdlBvbXF4aDJnZXZEY25EN2xPRmw1ZE04c2VFREF4?=
 =?utf-8?B?ZExuZnBndGdEVTAxVkNla3cvV04yZTcyNk5XWENiS0ovbXpIMFJKUEhpMVBW?=
 =?utf-8?B?VXh5ZmdyeFk4OHVWS3d1L2Nac3VhSitsa3oxUm8xSmdKdGJJN0N6SDA4N2Nv?=
 =?utf-8?B?Nm1hdlJleDA0b21PenJFK2FmeitIQ3dVN28zdTQwem9JTTZHc2NMV0R6RlBn?=
 =?utf-8?B?M2l3RTFGOFBvYy9za0U0RzNnMERsaUd6anRya3h6VGtzQnVqaVAybzIrRVo3?=
 =?utf-8?B?UWQ5N2FvU1RWd0ZzdDJRbTRBZ3hDZlJ2bE5pcWNyOW42OGc3UVF3a2cyQnFi?=
 =?utf-8?B?dmNqaVlJVS9PcHl1NWh3RkQ0SldNVVNrRFRSV2RnUUdOZWdFVXdUUnRjU1Qr?=
 =?utf-8?B?aG84YU1wZGUvRERPTnZNbXQzU3dnZXVpbC9wUnppZVlTMUpkUXNjMjFKY3pT?=
 =?utf-8?B?bFdkUkZrZHRDZ2tWd2VzUnJKeU10Q2picm1wWDlQYWxsNHFHRU93NjRJS0NK?=
 =?utf-8?B?MTdITmNqNW1OMUE1dk4xNnVaYTZQV2dZK1BidlNSTzhaY3BsRXpqVXhtdmxz?=
 =?utf-8?B?Q2FjYk4wbklTRi9kNE1yUkRBVzRyWEhYZXB6UjluSXZoOURzQ1VtUmQ3MVZp?=
 =?utf-8?B?WU90aEg1MHRDT0h1ZEY1NHpheDlsb0RYa01CUGxuS3hwUXd4RmU1dXVQOCtK?=
 =?utf-8?B?VFB3cHg5c3RTRDRTV0d3NlVhZEFXVlpuelNPMkxDTkRIb3hVWlZBZEswQ08y?=
 =?utf-8?B?OUR3MHBIZnpnSGVWZkZ1UUo3RDhzaUpva2wvcjA0Vkl6bDRudlY5bEhCS2pz?=
 =?utf-8?B?Q1VYcEpwb3A3N3M1QjRvS3M2SmZuNWZoQ29EWHl0RUpwa3NvOXdCeFpkdkMv?=
 =?utf-8?B?ZFRVKzBERkNQeUxHUFZNQ0FFRk9xMVVMSFFqNWh5RjlYL3h6d1h3Rjczd0tM?=
 =?utf-8?Q?mJUaZI4D/Jk//ptu9iVxK+5Q+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0ad10b-f3ab-4cd6-58c4-08dcf427c8ba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 12:31:29.0648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhNn44tjOcGimslanZzT338tXCF8uIUSIUsCG5rAO0rbkAiKeNy6aqK/3cEwdZcypt0TTrCxi/vksh5ZNdYeEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4211



On 10/24/2024 5:19 PM, Borislav Petkov wrote:
> On Thu, Oct 24, 2024 at 09:31:01AM +0530, Neeraj Upadhyay wrote:
>> Please let me know if I didn't understand your questions correctly. The performance
>> concerns here are w.r.t. these backing page allocations being part of a single
>> hugepage.
>>
>> Grouping of allocation together allows these pages to be part of the same 2M NPT
>> and RMP table entry, which can provide better performance compared to having
>> separate 4K entries for each backing page. For example, to send IPI to target CPUs,
>> ->send_IPI callback (executing on source CPU) in Secure AVIC driver writes to the
>> backing page of target CPU. Having these backing pages as part of the single
>> 2M entry could provide better caching of the translation and require single entry
>> in TLB at the source CPU.
> 
> Lemme see if I understand you correctly: you want a single 2M page to contain
> *all* backing pages so that when the HV wants to send IPIs etc, the first vCPU

With Secure AVIC enabled, source vCPU directly writes to the Interrupt Request Register
(IRR) offset in the target CPU's backing page. So, the IPI is directly requested in
target vCPU's backing page by source vCPU context and not by HV.

> will load the page translation into the TLB and the following ones will have
> it already?
> 

Yes, but the following ones will be already present in source vCPU's CPU TLB.

> Versus having separate 4K pages which would mean that everytime a vCPU's backing
> page is needed, every vCPU would have to do a TLB walk and pull it in so that
> the mapping's there?
> 

The walk is done by source CPU here, as it is the one which is writing to the
backing page of target vCPUs.

> Am I close?
>

I have clarified some parts above. Basically, source vCPU is directly writing to
remote backing pages.
 
> If so, what's the problem with loading that backing page each time you VMRUN
> the vCPU?
> 

As I clarified above, it's the source vCPU which need to load each backing page.

> IOW, how noticeable would that be?
> 

I don't have the data at this point. That is the reason I will send this contiguous
allocation as a separate patch (if required) when I can get data on some workloads
which are impacted by this.

> And what guarantees that the 2M page containing the backing pages would always
> remain in the TLB?
> 

For smp_call_function_many(), where a source CPU sends IPI to multiple CPUs,
source CPU writes to backing pages of different target CPUs within this function.
So, accesses have temporal locality. For other use cases, I need to enable
perf with Secure AVIC to collect the TLB misses on a IPI benchmark and get
back with the numbers.


- Neeraj

> Hmmm.
> 

