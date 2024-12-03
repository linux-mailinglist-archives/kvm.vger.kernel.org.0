Return-Path: <kvm+bounces-32959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 123B99E2E11
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 22:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C68C3283A9E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3756620899B;
	Tue,  3 Dec 2024 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q0NfHg6A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80CF170A1B
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 21:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733261217; cv=fail; b=IlOu6WWPeMaxwl3n87cvDTqWWZwdLgTz3VYcTBNbMiz9iKvgdYW98y2eDam4O6lcF6wmV426TD6gSjEY0jgd1i+YRqlNTvJAqgvXHYA+b+qQLr+2d5UBixuEQNTzLdsTjB8TloUWul83DbvDE1gIQ7RxNSicfF6w3zt/MWzhE2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733261217; c=relaxed/simple;
	bh=pinI6oDLVxY82+AQHy46aP9WJrqJA6WbUYYLpbEkL5c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I00FxBT6q7RJ5UwbZQF7WM+j3uI/EZ8/TTgFWZcqBp8LgA13DL0cOAb8KRT8WbzARWynfB24Wxe6VQ9ot/bA6tYrfNK19ZCkAhdaLfOFdev0c8IZlYwy+P4RRFcyWJux/7OO+tBlX1bnObkRO/+ePLx7hvPHRtl3chUy2a7xATY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q0NfHg6A; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mf+5G7ADab79dhhjcKC8jNRkme/lq5xLr+BIlC2JEHudogX17EZD7W1i7gH+LZ2IkCtEuirC/4oAkPZXSuiY8bEPvWQPMC3IXWtmKv48u6wsMTCqhitLtSTuzAnUMganfQNYJmMV2xN3IUE9OkLQOk8gfqu/3EXwHwT26Yi6agPigBVwKudD6MiOI6ZwkT3oUnMQKjsJDIsPEGLN1B5o/qynB6ua5BkdEOREWvD9gsKYVTRYtYyY5CXsmc9wkT7shoJ9epPK3ZHgaG5y5f075EDnO16lqBdxOK/HmO7oiRQ+HIeHUrkfCCJ2X7EJ9wwFBmyflZwDAgQRrSC0SgO13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUAW/0RT8nigOu0RxH2sjYzC5vsoESHfUEfMogEaZGI=;
 b=XQUP+CF6cN5OvJHVqMOVCyNhHNuc8v4EX6fACr3TPDq0AVEYaa9+s6YHGwb6oVmnV4Rbet36kmU0naoGoA6hEZjtwCPXe/Gqh2OY2QTtnHdG7YVJVfag3Y8Gb0sESlWMRBtmB8eFWCb/EFa5LmPaqTjUD8Zj8aewd0LzmHztJVzhn8Kb9sk/0xz7GbhQcrnas9v8suheIhZh6mQ3/pYMEJmy/cf1mJWA780wu+LZbyxsTSHTq8eWwt6Z2LNfjck3QF8h90e2xHZvxsW+qdpPOSti2lEc8PW9JLAoyYz5CvKXsw8exzQkaGYAxbdXcZNrbnYenflW8RmCfM28ExOLZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUAW/0RT8nigOu0RxH2sjYzC5vsoESHfUEfMogEaZGI=;
 b=q0NfHg6Alux0HvMC44JigALgGu/j9Pkop/5nS8S5y7IKOn8G1QuvDGn/qGAJSE/+3oVSsAodH9gV0kvoB33Msa2hhIeWz5TfwbCSaoyZfl+qJymCHa8TrPmM0hlauydP1yofIKq5CFO5O0O1uph9U+f7DmUz5pnTl1ZjA87GUpk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB8266.namprd12.prod.outlook.com (2603:10b6:930:79::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 21:26:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 21:26:46 +0000
Message-ID: <5da02caa-1bf8-87fb-785d-f5db41ef249a@amd.com>
Date: Tue, 3 Dec 2024 15:26:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 09/15] KVM: SVM: Drop "always" flag from list of possible
 passthrough MSRs
Content-Language: en-US
To: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-10-aaronlewis@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241127201929.4005605-10-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:806:24::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB8266:EE_
X-MS-Office365-Filtering-Correlation-Id: a9c8c5f7-3ac2-4c21-5a05-08dd13e130de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3VSb3pyUGk5N0JMWFQ0Ym0va2xtRjlCRHBrRnNPYUF3WjNTbU55MUFaajRu?=
 =?utf-8?B?WGhLY2lhT21LTHZOWUtBcVVSRWVkMXdHZzVPam5uQXlRYng5NCtQSU9IaW1t?=
 =?utf-8?B?REdaRkUraExrTjgyUWNXYUlsMmlSeGZJdGdzeUh0ZEl3QW12cHYra0tWMllv?=
 =?utf-8?B?bnpYODFHeTZkWDhKT09ndm5QY3R6dXNEa2xKUVRDczd4YVV0ZlBHalo3SHFa?=
 =?utf-8?B?a21GbExhMmZRWGdnWVNVa2tXanRaM0JyRzZOblFFYUtaYmJKaC9vcW1Mc05Z?=
 =?utf-8?B?TWZCOThzV3lNN3RXTnJtOWdNUHBtM05vUitYS2k2QWNLUTgvZ1dxL205VW5v?=
 =?utf-8?B?d215VUxER0YrTWVCMXl2bHVnZUJ3M2dYeVB3S0VRek0ySHJqQjJLa3Z3SmY3?=
 =?utf-8?B?OWZsVWNnYzgrTEFyYS9MYmYrdGxIMC8yZzE3Z3B0TU5ML0FuYWF4YlJUNFdY?=
 =?utf-8?B?eEo0UVp2QXoyRmYxUjM0ZEtISDJ6MkI5QzZnZDVkZDhrK1JVWUlQUWp0d1ZC?=
 =?utf-8?B?aE9YU2p3TFBzZnpWMjFabVdwSnJHcDFKL0xrSjZ5YUVaRGJMakpFVlhxa1A0?=
 =?utf-8?B?TFkxUGFaT1NRZVhld3Bmd2hoMERqRWdJcWEveWZNOWFvY0I1Mk82bS91Rmp1?=
 =?utf-8?B?aklJaFhOL2NqZ1I1MUd2YU9ZOFljSmZ1SlhUWmsxZ1lmTnZQZXFSejVIRkNM?=
 =?utf-8?B?NmxUSDlGWEFTMzNaUXprNU1CZzgxdG1wN1gydUU5cjhnc09NREdmS0JpUFFJ?=
 =?utf-8?B?Q0I3SStGK2dnUEJWczJqVlBkRWNtZitTSDBkc2FyN3B6Y0dBR0lxa3Q5bjB5?=
 =?utf-8?B?d2hpQUdzd2xJZkZMZ2xUeDU1SXBhODNWaFZsSVdHOHh0aE8zeWcxNWdGbnNa?=
 =?utf-8?B?QkhpMmtUTEdKaTN5bStMeDFUZENNbkR2Y2swZ29FL1FDOXRXVXNDSVVZeTJh?=
 =?utf-8?B?VDZiNzdXL3pybitZZm9VUHVIazFGa3liR1FKQWw5K0RFdmsxaFVTaW9OYWps?=
 =?utf-8?B?aU1vNG1ac0IyMFlrYWpDc1k5SDRXanRxR0Y4NGpEYW56SG0yZ1RDOHdqQ0NX?=
 =?utf-8?B?QXBqS3g4M1pGY1dMbVJ5SWtLNDJsQWZHR01sWVBTTGEwdmRIaXBqNmZacUgr?=
 =?utf-8?B?cHlsSnBscWRqREJocmpyZUlrODJsc0pIL3ZRRExOYmtsbmlBZkhTUTVPWHpk?=
 =?utf-8?B?QUMyVGtWcVpzQy9yUG0xd2tuajNPZnIyd2ZTOE5oR3UySVowczNpUUtTVC9Q?=
 =?utf-8?B?QWdOanFXL2k1NDMwYnNCQTJITEo2Tk5qWWFCMlplNndtYzFvUU9nWEp4Wk53?=
 =?utf-8?B?bWxPZXYyL21JcVlrc2RVM2tjOEgyWnBqeVRTVjRzdTVLV0hUK01panBsN0RU?=
 =?utf-8?B?T0hheklhWlVNK2pieTlzNkZDWjc5Tk9BZ2lGTjVYSGVKTDJJQUZkUGhGaWNG?=
 =?utf-8?B?RGJzcDNxaFd4ZDZHZXZTUWhQQWdsa01rRTFScWpRWWJoWWRnVnQyM3kwSmRi?=
 =?utf-8?B?emNubVRieGY0RlBsYnFRNXFtTHFtNU1ua0g2SVNEU0MzTlNXdjNHQ3JTUGpw?=
 =?utf-8?B?WitTNTNtaXhQZmk4QUVIa3ZvWWhadXhpaEZiNHBvY29YZ2VEQjhmVE94Vncw?=
 =?utf-8?B?TWMzdjRjd2xPSUlDNUtHdEJLTktLQlV5MmtyRkFYMXlsUUVwbHdvZit1Nlcw?=
 =?utf-8?B?eEdtb1FKOW1tNG9ndk9wWUQ4Z3RwL1RHYnJURE5LcVR2OGhxendudFJGY2lN?=
 =?utf-8?B?emFVNVZBdkVWbnpnOEt6b1Y2OTVEbXBITlRZQ3RkdDJMOWVPRmV1TGVncjhH?=
 =?utf-8?B?V1BMYU9DQ0tkd2lSUFNhZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3gwVGQzekpNRUxiVVlFT0h1RGc5UThGQzdDWHJOS1pjMW1PL05CU3M0UU9Z?=
 =?utf-8?B?OTB1b0ZGMGtJdXE0Y3dZOXFhUVBVYWtHNkZkbUE1RkpLS29QcHlBd0EvV29X?=
 =?utf-8?B?dHkyem9rejVsWHJCUXFROSsxeStKUVRLczZIT094UExOWUhGc3dZaSswc1V3?=
 =?utf-8?B?bzFlZ1pqbjhxTlNhWHJSaWNOOXM4MWhRVmFKZDhuU0ZqVUNCRnZrQlFQMU9o?=
 =?utf-8?B?MDhCeVdjWXRJblBXYlVDRy9qZHhCU3ZFQ3Z3MDNlMW9WVVFkTGxzSE9Xa3RO?=
 =?utf-8?B?VkFBNGVSU21LZnZqN0dPVmlLRVBnMmtvM2tabUVRQ3pUZWd0MUh1MWdCL3BU?=
 =?utf-8?B?WGpGWDlQOG05NlMwdUpHaFBlbVc4WStobm14U2o5N29BbHdpSndQMW5mbjMv?=
 =?utf-8?B?bHZJZm5KSGIrRVZFOXMrUnkraVAvYXpJQWF4dzkyTVRVT2d6QVZPeG0vK05H?=
 =?utf-8?B?empwaGtUQisxVnN3MXE5ZVpueTl1cUZPamgxSnZsaUtpT1dONUw4cWNVUWhC?=
 =?utf-8?B?Y0ZCTGpxdElqLy96Z2l4eG1ZK3BRSzRoT1ptUjFSL04zWkZqaXRrVU00WkJs?=
 =?utf-8?B?Qzd3YWNyRDZoNTdDdG9XVWFQbllHSkpFcEgvSmVlUDhVSjlMdUVEcmhTcVgx?=
 =?utf-8?B?cmt2d3hJYzJvajNPY0xiU1pQQmdicFRPTGtEK3BqKzQzbU5POWxsbkxoTWJu?=
 =?utf-8?B?WGtoYkNTWXFRcWorN2lWUHRaZUs0cXFJbmkxYmFpRUlJNk94M3IzNTVTeXFt?=
 =?utf-8?B?R05GcnlTOHFuVlprZlIvVmdsYWNsU1FWQyswNnRlQVU5bCtlVEhUVlRtMzNT?=
 =?utf-8?B?S01QY203RjN6dHJqb3doZTVieXpWbmFCUDlnQWR4WlN3NDF3QTJtU2txWFFk?=
 =?utf-8?B?S0t6cVhSaW5icDhyYUQyaWdlQ0tqTGlYNDdhK283MlVYL0Y2dHZJeFlVbjg1?=
 =?utf-8?B?UEwxZk1LUGhYVHp5V2RMb0s2ODRLcVVDeFJwbDRLMzMzcDJvR3dkdVplLzFB?=
 =?utf-8?B?STd4b2g3Tm1HNHJnQnhRWm9LUDFvU1F6d0NIU2d5WGxhNTdlUWxxN3c0L1Bk?=
 =?utf-8?B?L3hFNjZGcVB2cGpMYjFkbGtxZjJLelNoOHM3SnNHb0xMZnUvOUlPMUplcG5V?=
 =?utf-8?B?cEh1M25OY2IzSzF4M0JnMUMvMm5veUVCZDFpNXk1clU1Wkpudk5mdDd0M1hF?=
 =?utf-8?B?Q2xvWDNqZUVBUERiU1JVcVE5VmZNanA3QjNOU1dqVkVPY2xsZUd1VmIwR0lC?=
 =?utf-8?B?dS8vQjM0ZDVQalBudUMxVU0vaGIzakNUdjMxUzFYWnNkczA0Q0VTVWRtdFVI?=
 =?utf-8?B?cUNuZkJwbWtPSzBmbEdPN1dFekJOVUhuOCtTbEtuVWFYTXkrS3RrMkpJb2Fn?=
 =?utf-8?B?dEZEeWZWTzRqRzZOVC95Y1dpR2VDdWhyc0duSXFvL1ZEZkZLK3VITDN3NlZW?=
 =?utf-8?B?R0w3VER5cGFhaDNFN1ViS2ZqYVZpRkQydFppeWxVZHhRdkZYOUUxTWNRWlBF?=
 =?utf-8?B?bXc4OXlmTUd1MDM2YVJHNStCSTl6bkpuYUpiUC80ZlFKQUdCQkN1UVRCeFY2?=
 =?utf-8?B?R2xOMUdRSVcrQnFTMmVlVUxENUt3QkZuc0IwdU9aN0pnYnhzbjJFS3FxL2dY?=
 =?utf-8?B?bkpiVDQ5STBzWThyaVR3MkRWcXN0WEVuNklJVnBnZTNSSXNaYUFaVzNlL2N2?=
 =?utf-8?B?cFNzY1pOSGlVbW53S200WU8wZkplRkVJNnJvRzJCUHhSR295OW9lSUllOU51?=
 =?utf-8?B?ZU5nK0RaU0RKT2ExazFyNHE1QjlTS09UNnNtM0xHKzg2TG0wMVIxdzBDV3FJ?=
 =?utf-8?B?bTEwUTAyMEVKNms2bnRidGlpZEJRbzlzZTIwQ3NWODVGbGRMLzVnN0pYbmlM?=
 =?utf-8?B?T0FjWUMxaHgxMmJKS1JxQ3JtRkk0VEJObHpvTDdpYWt5ZHJTTGY3ZXpjeFJQ?=
 =?utf-8?B?eVRMbHBXOEJ1ajN5ZlVHclhLTHI5LzlHZmpCc0I3V2Q0YnpKVEw4eERqRGQ1?=
 =?utf-8?B?YitCSWY1TDVzMGdZdFdWNkJKVEYzUzdtNjRONitkRlY4dmVibHdQUmZDakxS?=
 =?utf-8?B?YUVNQzkzM2lMY0ZGaTlkTnoxY3dKOTlneTZhbE1KckgzajQycWt1OEFCNXlE?=
 =?utf-8?Q?E18CbC3ApzRxnEK5cGjks3aEr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c8c5f7-3ac2-4c21-5a05-08dd13e130de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 21:26:46.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBsLQGJIC+FBDx1779xblpXuXsWFpjQOZPoxtb1/IMg+wy47w2kkT4r+3a2ot2na/Eta7KoBWiWo1ksTnFEh3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8266

On 11/27/24 14:19, Aaron Lewis wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 134 ++++++++++++++++++++---------------------
>  1 file changed, 67 insertions(+), 67 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 25d41709a0eaa..3813258497e49 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -81,51 +81,48 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
>  #define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
>  
> -static const struct svm_direct_access_msrs {
> -	u32 index;   /* Index of the MSR */
> -	bool always; /* True if intercept is initially cleared */
> -} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> -	{ .index = MSR_STAR,				.always = true  },
> -	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
> -	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
> -	{ .index = MSR_IA32_SYSENTER_ESP,		.always = false },
> +static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> +	MSR_STAR,
> +	MSR_IA32_SYSENTER_CS,
> +	MSR_IA32_SYSENTER_EIP,
> +	MSR_IA32_SYSENTER_ESP,
>  #ifdef CONFIG_X86_64
> -	{ .index = MSR_GS_BASE,				.always = true  },
> -	{ .index = MSR_FS_BASE,				.always = true  },
> -	{ .index = MSR_KERNEL_GS_BASE,			.always = true  },
> -	{ .index = MSR_LSTAR,				.always = true  },
> -	{ .index = MSR_CSTAR,				.always = true  },
> -	{ .index = MSR_SYSCALL_MASK,			.always = true  },
> +	MSR_GS_BASE,
> +	MSR_FS_BASE,
> +	MSR_KERNEL_GS_BASE,
> +	MSR_LSTAR,
> +	MSR_CSTAR,
> +	MSR_SYSCALL_MASK,
>  #endif
> -	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
> -	{ .index = MSR_IA32_PRED_CMD,			.always = false },
> -	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> -	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
> -	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
> -	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
> -	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> -	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
> -	{ .index = MSR_IA32_XSS,			.always = false },
> -	{ .index = MSR_EFER,				.always = false },
> -	{ .index = MSR_IA32_CR_PAT,			.always = false },
> -	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = false },
> -	{ .index = MSR_TSC_AUX,				.always = false },
> -	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
> -	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_TASKPRI),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_ARBPRI),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_PROCPRI),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_EOI),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_RRR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_LDR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_DFR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_SPIV),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_ISR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_TMR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_IRR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
> +	MSR_IA32_SPEC_CTRL,
> +	MSR_IA32_PRED_CMD,
> +	MSR_IA32_FLUSH_CMD,
> +	MSR_IA32_DEBUGCTLMSR,
> +	MSR_IA32_LASTBRANCHFROMIP,
> +	MSR_IA32_LASTBRANCHTOIP,
> +	MSR_IA32_LASTINTFROMIP,
> +	MSR_IA32_LASTINTTOIP,
> +	MSR_IA32_XSS,
> +	MSR_EFER,
> +	MSR_IA32_CR_PAT,
> +	MSR_AMD64_SEV_ES_GHCB,
> +	MSR_TSC_AUX,
> +	X2APIC_MSR(APIC_ID),
> +	X2APIC_MSR(APIC_LVR),
> +	X2APIC_MSR(APIC_TASKPRI),
> +	X2APIC_MSR(APIC_ARBPRI),
> +	X2APIC_MSR(APIC_PROCPRI),
> +	X2APIC_MSR(APIC_EOI),
> +	X2APIC_MSR(APIC_RRR),
> +	X2APIC_MSR(APIC_LDR),
> +	X2APIC_MSR(APIC_DFR),
> +	X2APIC_MSR(APIC_SPIV),
> +	X2APIC_MSR(APIC_ISR),
> +	X2APIC_MSR(APIC_TMR),
> +	X2APIC_MSR(APIC_IRR),
> +	X2APIC_MSR(APIC_ESR),
> +	X2APIC_MSR(APIC_ICR),
> +	X2APIC_MSR(APIC_ICR2),
>  
>  	/*
>  	 * Note:
> @@ -134,15 +131,15 @@ static const struct svm_direct_access_msrs {
>  	 * the AVIC hardware would generate GP fault. Therefore, always
>  	 * intercept the MSR 0x832, and do not setup direct_access_msr.
>  	 */
> -	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_LVT1),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_LVTERR),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> -	{ .index = MSR_INVALID,				.always = false },
> +	X2APIC_MSR(APIC_LVTTHMR),
> +	X2APIC_MSR(APIC_LVTPC),
> +	X2APIC_MSR(APIC_LVT0),
> +	X2APIC_MSR(APIC_LVT1),
> +	X2APIC_MSR(APIC_LVTERR),
> +	X2APIC_MSR(APIC_TMICT),
> +	X2APIC_MSR(APIC_TMCCT),
> +	X2APIC_MSR(APIC_TDCR),
> +	MSR_INVALID,

By adding this there are two things being done in this patch. I think it
would be easier to see the changes related specifically to the "always"
flag being removed if the MSR_INVALID addition was a separate patch.

Thanks,
Tom

>  };
>  
>  /*
> @@ -763,9 +760,10 @@ static int direct_access_msr_slot(u32 msr)
>  {
>  	u32 i;
>  
> -	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
> -		if (direct_access_msrs[i].index == msr)
> +	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
> +		if (direct_access_msrs[i] == msr)
>  			return i;
> +	}
>  
>  	return -ENOENT;
>  }
> @@ -911,15 +909,17 @@ unsigned long *svm_vcpu_alloc_msrpm(void)
>  
>  void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
>  {
> -	int i;
> -
> -	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
> -		if (!direct_access_msrs[i].always)
> -			continue;
> -		svm_disable_intercept_for_msr(vcpu, direct_access_msrs[i].index,
> -					      MSR_TYPE_RW);
> -	}
> +	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
> +	svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
>  
> +#ifdef CONFIG_X86_64
> +	svm_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
> +	svm_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
> +	svm_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +	svm_disable_intercept_for_msr(vcpu, MSR_LSTAR, MSR_TYPE_RW);
> +	svm_disable_intercept_for_msr(vcpu, MSR_CSTAR, MSR_TYPE_RW);
> +	svm_disable_intercept_for_msr(vcpu, MSR_SYSCALL_MASK, MSR_TYPE_RW);
> +#endif
>  	if (sev_es_guest(vcpu->kvm))
>  		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
>  }
> @@ -935,7 +935,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
>  		return;
>  
>  	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
> -		int index = direct_access_msrs[i].index;
> +		int index = direct_access_msrs[i];
>  
>  		if ((index < APIC_BASE_MSR) ||
>  		    (index > APIC_BASE_MSR + 0xff))
> @@ -965,8 +965,8 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
>  	 * refreshed since KVM is going to intercept them regardless of what
>  	 * userspace wants.
>  	 */
> -	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
> -		u32 msr = direct_access_msrs[i].index;
> +	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
> +		u32 msr = direct_access_msrs[i];
>  
>  		if (!test_bit(i, svm->shadow_msr_intercept.read))
>  			svm_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
> @@ -1009,10 +1009,10 @@ static void init_msrpm_offsets(void)
>  
>  	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
>  
> -	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
> +	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
>  		u32 offset;
>  
> -		offset = svm_msrpm_offset(direct_access_msrs[i].index);
> +		offset = svm_msrpm_offset(direct_access_msrs[i]);
>  		BUG_ON(offset == MSR_INVALID);
>  
>  		add_msr_offset(offset);

