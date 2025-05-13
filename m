Return-Path: <kvm+bounces-46301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 392F0AB4D6E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7659717D23D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344751F2B85;
	Tue, 13 May 2025 07:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="URuTe/OG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59F4535D8;
	Tue, 13 May 2025 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123043; cv=fail; b=sWWhwcp85WWCX4ohVA7zDNnyAEb97kBPmsLrHG5wJYZGHRAe67SU+ymdPqBiCy5qEqRIIT99/Q7PgWMZ1lKIQHvyKOpnBJYp4/UJQdtXLCm8GwJwoZmOSTL9zJeHES0rV2S3H6gDJQmcTP89dL1vHQHhl5oP0HfwvGwxUq/AJDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123043; c=relaxed/simple;
	bh=/6MZCgTXPu2KMi4awJAgD8WzjXr0h6OjDpoMugvXU5E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iLna7pwWcAKbK+ZtMgykM7tMxgPM3+lIDHDlSgEqnCq/8vICNmLCTUP9sOF6OE5bliFyQEOxw3Iy6BWxz1b8YBiYuiXmqOXXumlOQWwT6On2Q5AS96OELI+1VUf1OEuxF1/GI/D02ZVgb9ZEOF8czrhv1aPTHIv2W90z8t2N07o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=URuTe/OG; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iuY3+5ZpgBTX1qX0H+LgMUkHlAt+YqlBJrZhBAUjV/mzq9/IZ4i4n80eixnTMEKuG3bku2fluN8vM5EihHNmY4V7dRnDwnBfNBVVvYZ4CiPThkF4tU1y4acGEG5lnZSgJo5Fuugn5DPRyS3QKhjWzVUWqsjlHFy9jA8tQ1lruVKexdEEGX84Jb//ezoBKUsjPEDKRd2EyjpWkSjIQQhf7GJcvhVjbWfJ8gzeelqaKgQl61blmr5Q7F1WRJVlVVXP2HyaKbkXAc1GmJIcM5fzMowlIJQ2rDC8iygNHBgUF7IcFbACNFB8Jidki8CK9mToBEFasHlnAJd+s4UYbKASfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6MZCgTXPu2KMi4awJAgD8WzjXr0h6OjDpoMugvXU5E=;
 b=cEaz9N57iALZspq9ZYynLPkwLnL2i3nvI7qQW80QlX2p8PJtBfCLP0sNo+E5lYhM86koJyFaKqr6AcxM+liyNOYHrnZ5igzEKmOBgz3hCmG+FQjPIark/sCrvdg2tH5FPuNlQjtxAanq640p3YWapLEsoCSdfAu82K4PcJRwPLhZDSb5n3Z1ftFw82OtjNiGAca32ZU28UO7gL+/BmqH/jm2dEZNWqYM4nsPQ3avPzySO8fXapcxwQqf/FjK3YxcpTRxs9iqZSRq9cARkjpWeEImxCYrgF6xrn4pNagd+BLhGGN0toVTYChD1Z9CxaxZ9aW9qKBfw4afwwiScprwBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6MZCgTXPu2KMi4awJAgD8WzjXr0h6OjDpoMugvXU5E=;
 b=URuTe/OGLVLK89ZEGZFK7nUw5Q0WarmuLqKHOoNRTlWMNMNC9tYlOzQK+nSYb4TrOBXrEOhywfSgSwcHkXib6RDL3ye7Gr8VN9zIyo7AEoOGZV2Vp/apMwZ6Vo7Uer17StPiDZFAJ2TCkVhEV8FDmJUcrYWgAw2vOxb4Z4DT2uE=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MW3PR12MB4459.namprd12.prod.outlook.com (2603:10b6:303:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 07:57:15 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8722.024; Tue, 13 May 2025
 07:57:13 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jon@nutanix.com" <jon@nutanix.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Thread-Topic: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Thread-Index: AQHbw9yisSkhdCAu9kK1+gNyefZV7A==
Date: Tue, 13 May 2025 07:57:12 +0000
Message-ID: <49c7519cfaf0c73cf77ab650852cbc81a55c75f4.camel@amd.com>
References: <20250313203702.575156-1-jon@nutanix.com>
	 <20250313203702.575156-4-jon@nutanix.com> <aCI5B7Mz8mgP-V2o@google.com>
	 <9B4F1C6D-05C1-4CFF-ABCA-3314E695894E@nutanix.com>
In-Reply-To: <9B4F1C6D-05C1-4CFF-ABCA-3314E695894E@nutanix.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MW3PR12MB4459:EE_
x-ms-office365-filtering-correlation-id: 1825fee0-d374-4fd9-dc9a-08dd91f3c54b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TUl6cS9YVFFhK3lWL0x4L0RuSHNIeFJ3VmRMTEwrSGZob2hwZVpSN3AxY0hk?=
 =?utf-8?B?QzIxMGtFNi9RaDZleVROeTF3QjdLbDhGTkZmQWVLWVh3eXQ5U3RDVlg4azBC?=
 =?utf-8?B?dnp1aVM5d2ViQ2lJVFhKbUNSdUdJMHRkT0JEQjZxTlJGNkg1clV3anJRbVI3?=
 =?utf-8?B?NUIvbWpzclVrWXdFQlduR0dRVVNDQ0pZbkJZbmNQNHV3SjU5RjhkNGtmOEZ5?=
 =?utf-8?B?Si9jUFF6SUlvQ2NoaVZwY1g1VWFpN2dRMmR0Sk5QSUtYbmE1bnNaSkxENmVU?=
 =?utf-8?B?Rk53SzBnbjZvc2FZeFFkdTMxeUl6c2ZPUzRYcWJGYmtHTWJGWmxReHFMQVpj?=
 =?utf-8?B?bkhoRkI3TTFvVkZ4UnpCTzkxMExRVjBaVmRobnlNNWhpMzg2RzZWdVdDNG1t?=
 =?utf-8?B?V0pQaXJBTkNiMEpiVkRpd0JHaU9tRUR3ZXB3YS9iSTBNTTQrdEtDQU5jNlRR?=
 =?utf-8?B?RTI5M1pUbVFON0tGOFFuV2dTaTNXTGlkTHltL0dXdUVRTlNjdzhQUGxHTUw2?=
 =?utf-8?B?TlRtaGhnMEp1RmwvLzc0Z2d4SWNWTDc0c2pKd1VRell2cERZb0pnNnFFc1pU?=
 =?utf-8?B?M2Y0dWE5eXlWTXU2T0YvdUNZelI3THM4OWJJNG8rczBSVkN3TGJkN2hqZXZG?=
 =?utf-8?B?VUs2Qm44dWY1QUxBSkk5RmFNQmVIY0pqaGJEaVRmL01KaWloR1JPVWIxSC95?=
 =?utf-8?B?SFViTFlJNmJPdjVFdFZmMTZqZzBIYndPdkljWlVGYzRyaG0vbURvZWhxNWEy?=
 =?utf-8?B?eWhqNmNLMWpJeEwrdUEyR1lMK1JTa3NoSjlBYWZPOFUzeWZxS1k5ckhLbEN0?=
 =?utf-8?B?ekF5elpBZ1ErTTY3NFU0T01Xc1JMVWV0YUVQRVBCNFZVYlNiUWxJeGthdjlS?=
 =?utf-8?B?VUw0Z3VtU2gxSFBoZGt1anRxeFdiblZIYkNWbHBIeWtDMGVBYWo2VnhablN3?=
 =?utf-8?B?QW45Y2N0VTZuWm80cndSTzhYY25Pb29nV2FrdTRobndvOVdGTUlSclhHRm9X?=
 =?utf-8?B?eFhSK1RYSXliUTc5RnNSS0dNOEp6MkxYZHNMWG15bFJKQmxZa2xBZ2dDcnFa?=
 =?utf-8?B?SndnRm9OcDlvQmlEU3ZzWFlxUDRhWk8rbHRINThtUHFYd05wTVdsTlA3VERM?=
 =?utf-8?B?b2xWK1BNUmRJZ0lYNU1EWjBsTk9sQ0JLNENOOEVlakcrY3FwaUFFK0pUcmZr?=
 =?utf-8?B?RENmY1B0NWM5OGVhZEt0OUVaV3hvUFIvc01xYnd5bDVRMEF3OGJBbzZubkFO?=
 =?utf-8?B?bVZBQkxvZGpoOVpIL0VLWHRSbVNOVDZmYjYvSk0yWTFraHFCck5hcm9PN1Vw?=
 =?utf-8?B?RVRTM0dFUEZJSnpPK2Z4RDlCN08vVjFpR0hRbXdIaWliMUtmR29MMmJKL1RK?=
 =?utf-8?B?aHRBMVNGd0x2Y0cxUXcyNDAyejUvMXJabXRndEd6WmZSK2dkL0JEVEtBSlhJ?=
 =?utf-8?B?ZGg2RTYwQ3NWWDVQZVlZbXdiK2JTalJOV2NHRkNWTy9PcHdIUStTZFdZMWdW?=
 =?utf-8?B?aUhiWnI0ZU45U2VldTJGZ1poRHVtTmNjUWFPY3E4VFlKRzNsQ3dKVnZqVXQ5?=
 =?utf-8?B?MkVpZlY3ODU1VnZtWVB5M1JWa2I0dURFTjJCWjhDWjEvc25PVEQzSzlPVXZQ?=
 =?utf-8?B?K2NWKzFwdVA1Z1k3UFdOUElvN2lzdS9JRTBwWHloUmcrckZYK2VWVmlQLzNS?=
 =?utf-8?B?TFNkS1VqVnJFUGhTNWd5a3JIdzZQaW9aNDZ0L1pYVFAvQWNHVi8rekc5Vi9R?=
 =?utf-8?B?Um1SeE9zd3V6TS80VXBYVHN2U2dUT3kxTHR5ZTluTW1PR0hycGl4VkI3YlZ1?=
 =?utf-8?B?UnpwWXdnNGVNWXZtcFArVEpYYU1sb1lBZytlaDNDMTdqd2EzTHZHOG5JWXV0?=
 =?utf-8?B?UHdUVUlHL1ZzVVRGY1NBcnhTc1UzVlZrM2FIUjV0VjVUaDM2akFKZ21IZjZl?=
 =?utf-8?B?UXB5MkVKRFR3amxuTHB2VW42R0NubHlXUGxDOFZxSGJhMThMVXlWMzdPMjda?=
 =?utf-8?Q?71J85jBeL2X/dqsLBbL7Qo7AiEUbeA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M003MTRwRUp2a0xVUGhNK25MWnJBRzk5ZzFQQmtOcXNUcXFQdlNIOXRIYTJ0?=
 =?utf-8?B?VHBwcU9xNXV0ZlBSamZIOTFseElDdW94Q1lHNVcvTFZ2eDJYVkxFSVp6U0hm?=
 =?utf-8?B?WUZLeG85TDNBMkJtTUpBVVdXNTNDUUQvTDBGOWlSdk1OVE5ZTGFVRmlUOEFQ?=
 =?utf-8?B?SVdjbzRyK0h1MkdlVEczellYeFVvQWxEMXQ3QWVoSnBBTTR6TWdZVzUzdUh3?=
 =?utf-8?B?cktJQmQ1TSsxd3ZqOW1YSHJONXhCZzJ0WEM5SXFuRjh0d3lPNmJHWVVQL1lY?=
 =?utf-8?B?U3pQUU1ucUJWMFRzNTAya1kxNjNBcHBLdWtqVWVwN29qU3ZmRkMrbm9lNXhK?=
 =?utf-8?B?TnB4VGNxaVNQVkxSQ25RUzBOZnR2d1NCdTM2dEJkdjI4ZTlQUmYrOXlyRngw?=
 =?utf-8?B?VUY0a0pXbVovVHY3MVdqYjk1akllYTZkdFV5M3BVdXUvV3ltMjVXSHNDak9C?=
 =?utf-8?B?cVZ6SVJmeUtWRmk1RUloRVhYQlNiRWEzQURwVENQTjVhMUJaeDczc3ZCVjVR?=
 =?utf-8?B?eTNldm1QOXc1S2ZJSERERnBPdTcza3psK3UxUmFFS0wrMWxTWlR1TjhTbVNx?=
 =?utf-8?B?Z3RlTmRkUmhaUFBsa2R1ZjBGU1pjTzh0Z3cxLytzNSttbmpvcEN1TXBhL3NX?=
 =?utf-8?B?amQxNk9xeDVRR09rZWZObzdmWHdiN1MrK0p3b2k0U1B2SDJHditXb2x5eVhK?=
 =?utf-8?B?OEd2UVZYVjgrWFMrZGxtaVJVK0xVV3h3bHRuZjlKekxhakZ1THpLQTRGWU00?=
 =?utf-8?B?TTlDMlhmRlV0dFZmSC8ydlp0ZkdMUHVrV0dlLzFPYWxjQ2FjcENsNXdwWkJH?=
 =?utf-8?B?RkJXdTZjTjZ0WFhZRk5YMDlVSGlIK2RZY0VkNGkzRmhSNkNIK0JVV3RpWHJi?=
 =?utf-8?B?cTNyNVkvV1V3a0lUVko5akFIZ3g5QmpmcjltOGN6dE5oeEVCMmx0VlVkbXZ1?=
 =?utf-8?B?RHBsRm4wSUhzTVRrZWV0TVJOVTlEQTFCMmtFNys1a0dOZkRUR0xOenhnei9S?=
 =?utf-8?B?cmpPMFltdk1RMUxwTHBLWWRTZXF6NHlENEo4U1ZoWmRPRkRjdytaWlJkUEpw?=
 =?utf-8?B?WFR5YXlaMWFUdEFBVjl4Mk5Bem52Y2dUZ0tWWFdMVzJOWHRYNUwzSXFpalhE?=
 =?utf-8?B?SG9PTm9rUk5zWEFiRnNSbzE2VGVCR1JsSUkvZXhGclQ0NEVCc1pLOCsvSVh0?=
 =?utf-8?B?MFlyOVRHZzlIMFkxY3dOV1RhY25jZ3dwUVFadldJMStPRUhidmFFcldmUnV2?=
 =?utf-8?B?ejYwRDlTcHM2cHZYUHg0SzBMOWFYbERTZUxsTFpuaWowQWxFMnNFVFN6cVZX?=
 =?utf-8?B?SWFIcTBzdjR0OWM3UVFxR0JSLy9XbWhqMzFKUG03T3Ywd1NmSVh0c0R0cDUv?=
 =?utf-8?B?Y280Y0VoRDBvTTd0ZGsrVjhUWndVRGRpTHM4dTVON3NXMFA2MHlBNzdiN2Fu?=
 =?utf-8?B?SkFRTWM5Q0RQelQ0NmNITS9FNy85VHNXcHpEaXB0RXZjTzNJR3Irb3VZT0xl?=
 =?utf-8?B?TC93UzFna3lCNzdIWjFybng3RkQyanQrb21GYkt3OFAxR1RicnlNWnBnUU1Q?=
 =?utf-8?B?RTZZS25RUHpwc0NxeEk5Um9vUjNUYjhVMlo3a3ZkMzRIQU1GMGd1Nm1RRkw5?=
 =?utf-8?B?eHRqYS9lYm51VzVOc0JTMTliRTVWSlF3cm1GK1BYeXpaa3J4dEtpWGhZcEND?=
 =?utf-8?B?QjNUeE1uUWoyejFsMUhvbUZRVVFOa0NNUjJ6UkhuYkthelVVRXJoUVZJQmFh?=
 =?utf-8?B?RGlHWmczMk9LK1pDS3M2WXBMSUtWRE1MMklsZkF5T1RRdGF4K3pTZ2ViRzlr?=
 =?utf-8?B?SVcxeDMvdHIweHU1QzhXeG1hcWo0dnlpeUFWYmRCVTFIN0VEY0hNWitQYTZO?=
 =?utf-8?B?Zmx3UkVBbUZCWENUMDFIeGpvVkpScDZUN2RURjdaa0Y4MFZUK29PaUNCaDM0?=
 =?utf-8?B?RzNYTmdqdDNCb3RPYUl2dGEvRGhlRVJiRTFpWVJKRFVJL2lJaWw4ZVZsOHky?=
 =?utf-8?B?SU96Qm0rR3BFY3pTZkdyYVM1eDZGN29RWTlCcDhwMDVlOUUwbkFGOTZNZFk4?=
 =?utf-8?B?OVBUa0RRaGJhOWh5dzNLOFZBOHhPVjVjR25JSktpRTBoZGxjbms0TnVjNjFD?=
 =?utf-8?Q?xEQ0kN7t4dw3jdqUf4qw9BW2q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73DF9A2508BEF24C958F0A454037D777@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1825fee0-d374-4fd9-dc9a-08dd91f3c54b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 07:57:12.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ns9RTmsEyCPsVgyQfV4NQzK/GAAfqAq+1YGhrlH7lLdF52b0sXOKK5nS7x4mKqWA2OI/N487oGKRdR0JjG/yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4459

T24gVHVlLCAyMDI1LTA1LTEzIGF0IDAyOjE4ICswMDAwLCBKb24gS29obGVyIHdyb3RlOg0KPiAN
Cj4gDQo+ID4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjA44oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJz
b24NCj4gPiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+ICEtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gPiAtfA0KPiA+IMKgQ0FVVElPTjogRXh0ZXJuYWwgRW1haWwNCj4gPiANCj4gPiA+IC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQo+ID4gPiAtLSENCj4gPiANCj4gPiBPbiBUaHUsIE1hciAxMywgMjAyNSwgSm9uIEtvaGxl
ciB3cm90ZToNCj4gPiA+IEFkZCAnZW5hYmxlX3B0X2d1ZXN0X2V4ZWNfY29udHJvbCcgbW9kdWxl
IHBhcmFtZXRlciB0byB4ODYgY29kZSwNCj4gPiA+IHdpdGgNCj4gPiA+IGRlZmF1bHQgdmFsdWUg
ZmFsc2UuDQo+ID4gDQo+ID4gLi4uDQo+ID4gDQo+ID4gPiArYm9vbCBfX3JlYWRfbW9zdGx5IGVu
YWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2w7DQo+ID4gPiArRVhQT1JUX1NZTUJPTF9HUEwoZW5h
YmxlX3B0X2d1ZXN0X2V4ZWNfY29udHJvbCk7DQo+ID4gPiArbW9kdWxlX3BhcmFtKGVuYWJsZV9w
dF9ndWVzdF9leGVjX2NvbnRyb2wsIGJvb2wsIDA0NDQpOw0KPiA+IA0KPiA+IFRoZSBkZWZhdWx0
IHZhbHVlIG9mIGEgcGFyYW1ldGVyIGRvZXNuJ3QgcHJldmVudCB1c2Vyc3BhY2UgZnJvbQ0KPiA+
IGVuYWJsZWQgdGhlIHBhcmFtLg0KPiA+IEkuZS4gdGhlIGluc3RhbnQgdGhpcyBwYXRjaCBsYW5k
cywgdXNlcnNwYWNlIGNhbiBlbmFibGUNCj4gPiBlbmFibGVfcHRfZ3Vlc3RfZXhlY19jb250cm9s
LA0KPiA+IHdoaWNoIG1lYW5zIE1CRUMgbmVlZHMgdG8gYmUgMTAwJSBmdW5jdGlvbmFsIGJlZm9y
ZSB0aGlzIGNhbiBiZQ0KPiA+IGV4cG9zZWQgdG8gdXNlcnNwYWNlLg0KPiA+IA0KPiA+IFRoZSBy
aWdodCB3YXkgdG8gZG8gdGhpcyBpcyB0byBzaW1wbHkgb21pdCB0aGUgbW9kdWxlIHBhcmFtIHVu
dGlsDQo+ID4gS1ZNIGlzIHJlYWR5IHRvDQo+ID4gbGV0IHVzZXJzcGFjZSBlbmFibGUgdGhlIGZl
YXR1cmUuDQo+ID4gDQo+ID4gQWxsIHRoYXQgc2FpZCwgSSBkb24ndCBzZWUgYW55IHJlYXNvbiB0
byBhZGQgYSBtb2R1bGUgcGFyYW0gZm9yDQo+ID4gdGhpcy7CoCAqS1ZNKiBpc24ndA0KPiA+IHVz
aW5nIE1CRUMsIHRoZSBndWVzdCBpcyB1c2luZyBNQkVDLsKgIEFuZCB1bmxlc3MgaG9zdCB1c2Vy
c3BhY2UgaXMNCj4gPiBiZWluZyBleHRyZW1lbHkNCj4gPiBjYXJlbGVzcyB3aXRoIFZNWCBNU1Jz
LCBleHBvc2luZyBNQkVDIHRvIHRoZSBndWVzdCB3aWxsIHJlcXVpcmUNCj4gPiBhZGRpdGlvbmFs
IFZNTQ0KPiA+IGVuYWJsaW5nIGFuZC9vciB1c2VyIG9wdC1pbi4NCj4gPiANCj4gPiBLVk0gcHJv
dmlkZXMgbW9kdWxlIHBhcmFtcyB0byBjb250cm9sIGZlYXR1cmVzIHRoYXQgS1ZNIGlzIHVzaW5n
LA0KPiA+IGdlbmVyYWxseSB3aGVuDQo+ID4gdGhlcmUgaXMgbm8gc2FuZSBhbHRlcm5hdGl2ZSB0
byB0ZWxsIEtWTSBub3QgdG8gdXNlIGEgcGFydGljdWxhcg0KPiA+IGZlYXR1cmUsIGkuZS4NCj4g
PiB3aGVuIHRoZXJlIGlzIHdheSBmb3IgdGhlIHVzZXIgdG8gZGlzYWJsZSBhIGZlYXR1cmUgZm9y
DQo+ID4gdGVzdGluZy9kZWJ1ZyBwdXJwb3Nlcy4NCj4gPiANCj4gPiBGdXJ0aGVybW9yZSwgaG93
IHRoaXMgc2VyaWVzIGtleXMgb2ZmIHRoZSBtb2R1bGUgcGFyYW0gdGhyb3VnaG91dA0KPiA+IEtW
TSBpcyBjb21wbGV0ZWx5DQo+ID4gd3JvbmcuwqAgVGhlICpvbmx5KiBpbnB1dCB0aGF0IHVsdGlt
YXRlbHkgbWF0dGVycyBpcyB0aGUgY29udHJvbCBiaXQNCj4gPiBpbiB2bWNzMTIuDQo+ID4gV2hl
dGhlciBvciBub3QgS1ZNIGFsbG93cyB0aGF0IGJpdCB0byBiZSBzZXQgY291bGQgYmUgY29udHJv
bGxlZCBieQ0KPiA+IGEgbW9kdWxlIHBhcmFtLA0KPiA+IGJ1dCBLVk0gc2hvdWxkbid0IGJlIGxv
b2tpbmcgYXQgdGhlIG1vZHVsZSBwYXJhbSBvdXRzaWRlIG9mIHRoYXQNCj4gPiBwYXJ0aWN1bGFy
IGNoZWNrLg0KPiA+IA0KPiA+IFRMO0RSOiBhZHZlcnRpc2luZyBhbmQgZW5hYmxpbmcgTUJFQyBz
aG91bGQgY29tZSBhbG9uZyB3aGVuIEtWTQ0KPiA+IGFsbG93cyB0aGUgYml0IHRvDQo+ID4gwqDC
oMKgwqDCoCBiZSBzZXQgaW4gdm1jczEyLg0KPiANCj4gR290Y2hhLCBhbmQgSSB0aGluayB0aGlz
IGZhY3QgYWxvbmUgd2lsbCBkcml2ZSBhIG5pY2UgYml0IG9mIGNsZWFudXANCj4gdGhydQ0KPiB0
aGUgZW50aXJlIHNlcmllcy4gV2lsbCBtb3AgaXQgdXANCg0KWWVhIC0gSSB0aGluayAoYXQgbGVh
c3QgZm9yIEFNRCBHTUVUKSBpZiB0aGUgVk1NIGFkZHMgdGhlIEdNRVQgQ1BVSUQNCmJpdCB0byB0
aGUgZ3Vlc3QgQ1BVSUQsIGl0IHNob3VsZCBiZSB0YWtlbiBhcyAnZW5hYmxlZCcgYnkgS1ZNLiAg
Tm8NCm5lZWQgZm9yIGEgbW9kdWxlIHBhcmFtIHRoZXJlLi4NCg0KCQlBbWl0DQoNCg==

