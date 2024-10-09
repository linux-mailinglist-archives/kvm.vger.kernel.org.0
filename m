Return-Path: <kvm+bounces-28241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CEE996CB3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 656D01C21867
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45834199FB0;
	Wed,  9 Oct 2024 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xv+cLqdq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6CA192D6E;
	Wed,  9 Oct 2024 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728481871; cv=fail; b=jE6/Sg8hmkKyyebzdfdJ1jnyqQL1MpQ2+C6ei58Riko/YE+dzQlBjunOYdkZOcxESceZztbRoEYtWaBMSxbILdy9PPDI0BgVxCDsVu1vD+bAmNm2T9zi8+RV4f5xDKOi8ld0S5iD1ekw45mKGp+zDmrevy75OmcZDJIgYX1sTuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728481871; c=relaxed/simple;
	bh=NqyTzwseF3aGsogWja5mPDwSmfoFV3T8w8xHftg+00M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JgYbJ08xyQa2zL3dnofXVFp5ozdu9l3xSfCoNrCpt6FSV+JQME5PdsqgjmPTcu9pyxuPmZGPNqGbplTRdX/Q5mIKO4YU3eUAxp3/M6x72na+8nbOdUC5quS/0PKB6I+b/e/lcnM/dbB17KXrCN7v45NIe8rrPi/m8F5+pXL1CE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xv+cLqdq; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V64IRzd+lweI+0jQDfdQ8IqLMSNtcvWbhtCNr894adZUhkc3XE4SXj3207UIlg/j36j7CuPf/pkJbEJ2p2jhSs3F432n6/CkGKK0jYTHHKnd09h+Ji/K3aT0KNzqeyOblwCq0g/OSc4gJsnWJgxd3ASx6BgkWl9JJWTgEsL1OioqRLE7ML5JIjpYFipXIkFnxfiUwOePxs9wzIDLbILzLr8pjkzz3V7PrpY2MJ/HWxocFs1fdDexAqvoWZNGbSkUNPw4Lmwk7S84KEzwVTs3LlESs6vwo0kM8S6pW09vXWV9DbsD1JUD0nQMgBcRUUdRbbLAJvP72ukPd3nvNEE6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQN9W7b5jKavfWCv7xZse1kt7X2Vmop4m6j6tNGz+4U=;
 b=XHDYivgVzx4y3iPb07PDsdK+Nf6ewwNEl0W0gkYrp1lPqk1i8WsaAuyk1zlBXP/2O0F/JgAm+kcUqiSGLd5PHpr+RwFxXLVjvyZSsReuVOFtr6uZaUhn8qtUwTfApW0rBU8oP7NyWI7jWZy4W9MbzayBCm2lKbcsDJfPLPUPTi9EhMju3HLsozo7g45SOeVFQK3Y36b7xijibWYI4QkGOOKE9uC5mZv35LHpoqemf9P5dGn3C0Aokf2PBF4EO84kDJshIGVpsGsLf3t/JirPBQ05EM+aK8Vt7UNDAUs+p74t6/0PIjcNxLeJDnedCwrKzK7L05TrxUnRRq+ZZtYnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQN9W7b5jKavfWCv7xZse1kt7X2Vmop4m6j6tNGz+4U=;
 b=Xv+cLqdqLH3VZwAu26gbfU89WHP5+pHwDUqALU6RJKY6Q1QUjyRPg91YxzDEyqlQAbpY+QA6xawMoAPMZXfGuehzgaTw2+jxHtc0r0/vlqzjNMQ/L7zdAJuEUH31X4pjK/84Trj/4EC0IfOo7I5tLrmMY/WxtOk1+Qp+l5GCTS8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SN7PR12MB7251.namprd12.prod.outlook.com (2603:10b6:806:2ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 13:51:06 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8026.024; Wed, 9 Oct 2024
 13:51:06 +0000
Message-ID: <d35bd29e-d00a-4da9-9ab3-1273ed1bf6c2@amd.com>
Date: Wed, 9 Oct 2024 19:20:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
 <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
 <1f57da63-cf29-c75d-af06-c2cd795f0b04@amd.com>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <1f57da63-cf29-c75d-af06-c2cd795f0b04@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0130.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::19) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SN7PR12MB7251:EE_
X-MS-Office365-Filtering-Correlation-Id: 38f8701f-d774-4223-07c0-08dce8696c18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnQySXZWZGI0YkRzMktCKzhyeG1lWk9hRDNDRFJSNXFadWlXYVp6RmtIZzNt?=
 =?utf-8?B?MDBOM2VZRFY2a2dwanlTbXREb1hUaHBrS2dxaHUxOHVxZEZ6L1RQOUwyNmcr?=
 =?utf-8?B?RlV3SytWUGhXNWYveTNTM25GSnNDUXhiUXZicnZlVER3WE1naloxTmJYcllx?=
 =?utf-8?B?eTJmSSs0aGs0amk4cVNSdityalF6WjRTQmRyb1pNUDB6NTlpVWJiRm5OK0dy?=
 =?utf-8?B?ZzJyc0xoSDR0c3hvcGRlSmNIUUllVk5ad3RpK2pLUU4wT2QzdUVoR21VMUx0?=
 =?utf-8?B?MUFpRTBINlF1UWVtdE1RYkVrOFhrZk1jek5xNExGSjI2R2RTSGl1SzhVTlVk?=
 =?utf-8?B?SmhPTm5nN2NoMnRGSmhlSHd4NUlHZzBpRFU2dlRybFFXRm1KdEtmZmJGZFd5?=
 =?utf-8?B?TzI3UDJjdEllWFdUUkx0N2g1NytHWUlWb0NjR0JPRnRXalgyZlpVN3FWOENr?=
 =?utf-8?B?QW5kT0IySFJCTHo1MVUzWit4bE51RUptL1hrRnJKdEVrRGk4NWcwZUMvOGVa?=
 =?utf-8?B?WU51dmlBeFRPbU9EcWE3WU1lOSsrd3FCUkh6MHgxbGladHBFMjN4dHBZRmdk?=
 =?utf-8?B?clFtZGFkTmpPVHV2Q3NmVldKN1hOaUlDLzJLOFdPZmg5WGJmN291cUtMSEwr?=
 =?utf-8?B?U2tmVDRVTUt2TXd5Y1BJd3V6VzNWb0dMUVY2UnRXd2dZM3loUGFNLzE4WEs3?=
 =?utf-8?B?MW1PTHJLVlJBaC85elprMndGLzlvQTBOVFdPZ3c1emRzSmhrVVZEa1d2aTgv?=
 =?utf-8?B?UXJXTXh6Z1psUk1MbS90aE1CZGxHWWxYNW1zdGhLMFBTL21FQ1NRYVk0NmRG?=
 =?utf-8?B?VlZUK2s5R1JxS2lwamVXVnJaajlNeDNTeVFWcWxSeFJPK25VTVJsN21FdElS?=
 =?utf-8?B?cUlkOVFSMmRQS2ExTUdSZzREZ3crWXc4cndEUUZIaHJNTDNVUHQ4bmVDQ1hh?=
 =?utf-8?B?SlVaeDJtak9iV1dhaWpRK0l0QlFaRjByMnBaR3FSemJKY1hwV2JKS05lbE9u?=
 =?utf-8?B?UnczZnBWazZYbzdsNzhGSTlQZDNLd202VXhadk1ROE1Na0lWOTVPZVBXK1hn?=
 =?utf-8?B?cnNLN1EwZFJlR2ZLdEdWMGVjODdpcTVUZk1JR1F0d2ZFUXhvWDdBTFR6L2cr?=
 =?utf-8?B?ZTBuQ0kyMm95ckpVV3kyWFB3SXloMFVSZ1dVUUtXYksxRHlZNUFyaWhwd2ZT?=
 =?utf-8?B?bFhmb2lHQUFKbUszd1VyWXVZdTFzSmV0MlhFQWdKdVVzTnpjblVCSmJxQnV6?=
 =?utf-8?B?N1VGREVPTndTbU4zTUJyKy9aT29MdXpZVTlXQ2pMZjlOT1BBZFgyemVEdGlZ?=
 =?utf-8?B?NGlWWnc1d1B0dWJGbE53TzlpOSsvY2V0dFJLYXlRd2FQZm05dWtTN1RRZWQ2?=
 =?utf-8?B?Sk1hcWRYVjFvRW1qTVVuenpuNjF6blFQdnpQeGJaQ0NGTFBmVVZvN0FqWG9K?=
 =?utf-8?B?QUh1eHJTY01yY0dXRnBWQ29HRXBibHllTS81cnptR0R1WksyS0RWKzUzcmNj?=
 =?utf-8?B?UitRQ01RSGVlTVNqUzZJazdwdkcyZHRHOEl4d0liOTJIaG9DWjZNQnNFeXFy?=
 =?utf-8?B?L0dFbHIwUkRVUTBEWmR6UXhYL1IzY0ZVSVNhZUNZR2EwQmNGbDgydW50UFZX?=
 =?utf-8?B?WHkvYjZZeXhUbXhnRFRlb3VLTVhuSEw5NGZKazJYTTVJaXBwVVBzS3hWSCtE?=
 =?utf-8?B?MnBwRmJQUkN4eGp5bERMKzJkOWZjZGIyc0JGbHBxaFVSR1FOdnlBTk9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OS93TDNObmJlcHNOWHZ2dUlkL3ozUEt5eldZd1pyalNOUHRYYnVoNWgvQ0Iv?=
 =?utf-8?B?aWl2d0tYQ1dacWI4NHNxWUF3WFFyUXNTTkNCZXZ2Qk9mVGs1Nys1cmF2Q3ZC?=
 =?utf-8?B?UmdKVVJFRS9yTW55RHhLVHFUenlXQWIvN0ZxVUdEZzNhVUxuaXdDdEkwUVp5?=
 =?utf-8?B?a3FMQ1RIZU5VRFhGNFpSYzArd0dGRVFjUjNsNStBMy91ZXhqblN2bzhwRGhK?=
 =?utf-8?B?UzMxcEpKTFplblJBY3p3UTRjTnRUN0prWVVWNFBkaEY4UXUwR3FsWTBxQ0lF?=
 =?utf-8?B?MkJZUkR2QVR6anFPbFVsaEg1T0ZUS1IrdTR2VVZCNy8rem4yZVhHMFRYNktq?=
 =?utf-8?B?Z0o1NzBQYW9Ec2xBN0xQL0tqR05RUFVOTHRETjBhamhXNGpsRTFJR29HTEs3?=
 =?utf-8?B?UTYxd3ZoaktmZSs0bUZ4U3ZsdHBvU2dNKzRzdTZYUUFONWlFaFVScUF0aVFp?=
 =?utf-8?B?SGxZQlRLekh5Q2M4alE2Y2ZwUGJXQSs2R0dnYk51amtrdUs4RmxKdGVMNUIw?=
 =?utf-8?B?Mzdsd1Nia09XR3ZEdEhlbi9yZXh1MnpFVWF4NFVRVVZKSTVXWVRubGRMbW9N?=
 =?utf-8?B?K2tsRHVucFlOazVKTTNXQ203eTlaSEhLTDJGZXdZYlYvT3NsRFY5Wkhzbkwx?=
 =?utf-8?B?RitSSXBHMXRYMDNQWFEzMDh6Nmh4T0VyNVUyOUpybTBCMkQ5STJ3Sml2MnVl?=
 =?utf-8?B?bEpsMmN4aXBldTVsMVlWMVFvaXpwVHlTaFUzK1dtVjBGVGJrU2VqWTdRWlpk?=
 =?utf-8?B?aHhWdHpjcDVzQjJZWU0xejFVTlVrbEMwR2FWZmJ5RE4rSHM2em1nbm9qcHNp?=
 =?utf-8?B?Q003VlNxeDVaWlN0Tmd1RkdQM2pzSTgrRHlkMTVpQnFQK2duWkcxaXM0aFJS?=
 =?utf-8?B?dHl5TW9iRlRKb2hncDVzTkFSWEpibSs3VTZkYnJYcm53bDRzV1FlTWxRak4w?=
 =?utf-8?B?a2wrZnJJUjNHYkJHVTVZTW9JTUxtbUlML3VPY0NtUERob2JCTC90SXFhVkwx?=
 =?utf-8?B?NFZ0cTMwTlBsWFkxSHM5WjZyNFpQdE9ueG5NVzVmMFRzdVVZenRrK0FoZW5w?=
 =?utf-8?B?L2x0cERwQUovUStHMmExTUNnNTZyRlYvRkZCOWFOR3JjajNMc25FWEdXbUZv?=
 =?utf-8?B?USs5V1h0VnVmem0wMWprMHhJOUxvZk0vU1VHOHk0eGlSUHpZanlSWjhkalZW?=
 =?utf-8?B?YWdOaDRRWHNVK1YvQTZJZnBOelZ6Qittb25RZ2E1SW40Z0s4SDB1RzN3RFB5?=
 =?utf-8?B?cmlFMnZqVUxHSjkwMW1UK05wRDlrTUswZGhpaDZGVjJ1S2JRZktnajN0RWdJ?=
 =?utf-8?B?RGk4V1ZXUTdmZ3MzeEVVZXovODNHMFRreHlqTzBCV2NDTUoydmNNTXZISkM4?=
 =?utf-8?B?eEovUGxzcEIwNUpTUFY5L3VOVHRnU3pST0VsaVBiNlUxRmliN21kRnNMSnRI?=
 =?utf-8?B?a3dHNm15Q3llN283aXJpem9LcXIrcFp3d0VwZ2lJR2tQbGEzODZjM2FIaUc4?=
 =?utf-8?B?dkk0WVFjZFYrYXFqKzBXQlZVdEMvQWYyTWNzeDB2bWt4blFYZDk5U0hvb0Q1?=
 =?utf-8?B?YnRDNDNNdHp1K1FJa3YvNi9PRFZ3cXJtb3JLblp5dEw1andaVzlEODBxYVl5?=
 =?utf-8?B?N29WOWNnSTZLYS9kcmlkaFM3dndORlhCdWl6YXdrdUgrUlk4NUMyRFVBZ1JM?=
 =?utf-8?B?Y1VXV3RoN0ovd1MzQTUrQmdSN1VOczdiSzNvblF0VWtYTU1NSzJVY25BYnh0?=
 =?utf-8?B?amdlVU5EdlIyUC9ZOWVIS2ozZytSSVZKMXNEclZQRTVYRFNvTU1rR3pGQUI4?=
 =?utf-8?B?aExFcTVxYzhoTmo3QWRNVVU5bUJzK3BvSFRDVllvV2owbStFVjJmK2JDY3NJ?=
 =?utf-8?B?aHFBdkFBVXJiWGlOazJoNTF1NURHNmhsalFjVEpYSTZXNUl4c1M5dnJyZkdt?=
 =?utf-8?B?MXpQN2VpQVZZR0taSnhhZzQxTUsvQzFmWUxvL2pvaGlwdkVvUExPcGhYalRC?=
 =?utf-8?B?dnRVQldZaGtXSi82TVBJbTJ0MG1HeEh4OXhITWlhVjUyL0o5enhidnJhUHZm?=
 =?utf-8?B?U1hUdXVlRmQvUk1IbHZpdDRKTjA2cHU3SkxCenRHTDhvQ2FZRHUvdEw5cGZF?=
 =?utf-8?Q?sJ9jmbpkaOzcjuK9qBEigBRCs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f8701f-d774-4223-07c0-08dce8696c18
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 13:51:06.6230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AFRwJfkjvQk/ujMPwvcgesBS+tKdTY6FtcXcjSqOHp/6iJDuUN0ktwbUFXF53Jj55K4QjAgifmyWsZbFdNU3zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7251



On 10/9/2024 6:45 PM, Tom Lendacky wrote:
> On 10/9/24 01:01, Neeraj Upadhyay wrote:
>>
>>
>> On 10/9/2024 10:53 AM, Borislav Petkov wrote:
>>> On Wed, Oct 09, 2024 at 07:26:55AM +0530, Neeraj Upadhyay wrote:
>>>> As SECURE_AVIC feature is not supported (as reported by snp_get_unsupported_features())
>>>> by guest at this patch in the series, it is added to SNP_FEATURES_IMPL_REQ here. The bit
>>>> value within SNP_FEATURES_IMPL_REQ hasn't changed with this change as the same bit pos
>>>> was part of MSR_AMD64_SNP_RESERVED_MASK before this patch. In patch 14 SECURE_AVIC guest
>>>> support is indicated by guest.
>>>
>>> So what's the point of adding it to SNP_FEATURES_IMPL_REQ here? What does that
>>> do at all in this patch alone? Why is this change needed in here?
>>>
>>
>> Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
>> terminate in snp_check_features(). The reason for this is, SNP_FEATURES_IMPL_REQ had the Secure
>> AVIC bit set before this patch, as that bit was part of MSR_AMD64_SNP_RESERVED_MASK 
>> GENMASK_ULL(63, 18).
>>
>> #define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
>> 				 ...
>> 				 MSR_AMD64_SNP_RESERVED_MASK)
>>
>>
>>
>> Adding MSR_AMD64_SNP_SECURE_AVIC_BIT (bit 18) to SNP_FEATURES_IMPL_REQ in this patch
>> keeps that behavior intact as now with this change MSR_AMD64_SNP_RESERVED_MASK becomes
>> GENMASK_ULL(63, 19).
>>
>>
>>> IOW, why don't you do all the feature bit handling in the last patch, where it
>>> all belongs logically?
>>>
>>
>> If we do that, then hypervisor could have enabled Secure AVIC support and the guest
>> code at this patch won't catch the missing guest-support early and it can result in some
>> unknown failures at later point during guest boot.
> 
> Won't the SNP_RESERVED_MASK catch it? You are just renaming the bit
> position value, right? It was a 1 before and is still a 1. So the guest
> will terminate if the hypervisor sets the Secure AVIC bit both before
> and after this patch, right?
> 

Yes that is right. SNP_RESERVED_MASK catches it before this patch. My reply to Boris
above was for the case if we move setting of MSR_AMD64_SNP_SECURE_AVIC_ENABLED in
SNP_FEATURES_IMPL_REQ  from this patch to patch 14.


- Neeraj

> Thanks,
> Tom
> 
>>
>>
>> - Neeraj
>>
>>> In the last patch you can start *testing* for
>>> MSR_AMD64_SNP_SECURE_AVIC_ENABLED *and* enforce it with SNP_FEATURES_PRESENT.
>>>

