Return-Path: <kvm+bounces-36324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5776EA19F60
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 08:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 536997A62E4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 07:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EF620B7F0;
	Thu, 23 Jan 2025 07:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SydGfoDZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E9C2F2A
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737618610; cv=fail; b=ULRTPwfHF64wI6GTa/loBvCnqLo4DuW5/4WnTEuuK14RNCf//lJgTN67dDiZkB0bEZXkHkBSZepXMcTsT1UocGDbviLIOmcKdbs7YhDSDUPIL4/1InJn5lSy/Hq120maabhQd8qPOMS4OoTUhN2Y2JuTf4mlMdH0Da98cg0UTjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737618610; c=relaxed/simple;
	bh=OknO/Nk8HeX2QBbULCeU2iEKFS1kZRHMGSEXdGqMp/A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qK2aN7FDV15/dI9geDV3Q7k6JDOuRnLP0sOmAuunnBwqmCwVXcx4s/HZOpgttDJ5Qaoqds+uPfXiJh2+BP6UjW3w2rTt5w8OLqMR8TnFsbt3KKec1j9hcdANRAdFUle3kf96nUdCe+Jl/k5V0GmcgYONS1QOUAzV2YgHPsiywBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SydGfoDZ; arc=fail smtp.client-ip=40.107.223.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wwwacb9zCMgEW5Cno9JOX85M+5hCOplAJBWz5xViL2JRT6rZ2LKlpIKf6hMC6AuKITh7EQc6uy5c8za/Il7oFLrP7+znnI3HIj4dKg6sk66XY42Kxzw0PMORBo7/ystB08dZ1ZNXfzMFX9FDIHfSBdwncI7B+HRtF3vgketCVTQv6blDg9M0WZ4jTo31WcMxxGDN00nuo7/mukYiHa3g9sxKCwCumyzLyIUMoSCOum6wSXGi7rCxNfTQCOYd1ojUbTcLGJfEcQkQFfnEtwNQh0yES0am8BNQjz1ErJDA4Q7b/iiF7ihZsmZAy6CVMLUPD48BXhYAbd/W7rrbdDnETA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9DGfb353DuNHjK33wRZOkyXTmmb+EloQNFWU9VFZI8=;
 b=Z6VTqT9t2kxQYaq4axq2LSp8fXpO69VvStDa1PjWWOarF7p2ysVQGIhzBsQ5QX1prby64eK2myhWHLHUfRnU+FFpM+kJGiuhhmdFDA5AG9wYhsYuPo+8iZeIS1OL5M6WTJ/LrqBZQf8IUHFwHRLMwdRIr/qGKyJZXkezF0AKNYERQ+2WOVvB9aXVUzXW+pP07M+0ABDvNttdSe0UWsKrccaIqbUgf7eIDDQWZMzrGwrziN94bNgBsgqwVdGKROYIPVu2/e2whouYHEBsl2CGeUPlW/R9MH73I8XXCmPbQUpyXB82jZZ3Y95c2lMaKZavVoyACjFzWdBguwk7HKZCHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9DGfb353DuNHjK33wRZOkyXTmmb+EloQNFWU9VFZI8=;
 b=SydGfoDZztfyyZ5Iq4OpACMrMXup4lTUJR04QNCDGA1SEfbX8wjjfOAJaQvckA98zgTn5QEdNOe76S2h2Z8uQmyDo8xU1mztRqph3lL4p49XcRl5IfXrQZkblqPs1ms7s65RdCe8Cf5pRzEToc/nYphCvANZ3cJL2TWglv1wkys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Thu, 23 Jan
 2025 07:50:05 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8377.009; Thu, 23 Jan 2025
 07:50:05 +0000
Message-ID: <129a7821-a4f3-4e78-886b-a5d7fee0392f@amd.com>
Date: Thu, 23 Jan 2025 08:50:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info
 struct
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com
References: <20250123055140.144378-1-nikunj@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250123055140.144378-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: b5dd9557-fb05-4bfc-ea4c-08dd3b828cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEh3Y2h2WDVFSGNZbDZjeWlCYkFrdGNmR2NtTXY0cEdaOWEvZ2k0MFNPdGJP?=
 =?utf-8?B?eStkTW0xWHN5R3RBZXhPUzVLQUpwZ2xiQ29rd0JIWlJod05jUXIxYlo5Um5S?=
 =?utf-8?B?UnhWQ1hXcVlWQnk4UGlkZmVWWUdMdk5FcUVjT3VnMksrRVNocEl3bTByMDNy?=
 =?utf-8?B?QzdHcWJIQ3N2b3owS05NNHVjZ3k3NTBCMDdnemdZeXR5dkVUWkRLTVhHUmpP?=
 =?utf-8?B?cEFOeEZQbm5obnIrT3EzdVdHNUk4TmNXTms3d1dXOENLUHFVaDBwSkFvQ0xo?=
 =?utf-8?B?RGQ0MDJYWW9sQTVBcVJKN29IemlpN3dDRHQxQVVwYVN4VG16VFFMMHQ3WDlH?=
 =?utf-8?B?TjRQVTVBNGpxK1ZydllJM1haYzROUlE3bEJvR3Fkcm5zVzU5b0hHc3QrbUJD?=
 =?utf-8?B?QjNBRUdMMkd4U3V5SzBVaXVOTkw3M2JwVWY1RFV5dndNWS9LSnYrWDRIaGN3?=
 =?utf-8?B?V003QWg2cjRuZlN0WDFjYzlQN2Q2aFNlUm1GQzh6UG9Ncy9sTVBabnVhVXhH?=
 =?utf-8?B?VDZzSUdlZ3k4b044Z0p4U0pBYkV1b2JXR0ZUV3IxWnlxQ2p1cTRuKy8wemRL?=
 =?utf-8?B?Snl1dHE5ZVQxeFFsZDk2c21jSjF1OHc2WS9SbTRXN0RFbFZlQ0tqZURJNjdw?=
 =?utf-8?B?M0xsVE5NTlJmKzZDTGNmcFNPUkM0TFZnQzhETGp1cGN5ZzRIcjVOcnlrU2Ja?=
 =?utf-8?B?ek16TFg5MHJqYmpEVXpwNUlDVldLSkFreG9oMG5yUnc3bkJjdE5IR3JUQWdE?=
 =?utf-8?B?TjFIMnJUVzB5N0sxODE4U1J0WC9rdGxvb3hqWmxKVmsxS2tJTUdjRUlhMVBl?=
 =?utf-8?B?b24xaEg1MWwvTUEzSGF2Qlp1ZnFnUklkNWJQQTVQbTc3NzluOFlvSlA2bHlQ?=
 =?utf-8?B?VFNzQ0F0OTBXVEVmajNabVBXM3NDMll1dlZuWVpHeWNqamhKbnU5MmMyNnZv?=
 =?utf-8?B?bEhNak5lVEhydWllUFNLRU1FdU5pVXNGU2R3Tjd2RG9oWXdQYlh4V0pSUVVs?=
 =?utf-8?B?RmtPa1hRUy9xZGlNakp6bWRudzcvbE5ucFpCaExOaWNHVmRldDU2OXlnWTRX?=
 =?utf-8?B?MWNEcEFhNytaNTVUWmlkamd0YWZQRXd0TE9QR3FwK3BTSUtnNnBubHVWeWp3?=
 =?utf-8?B?Mm0yRkRvMGpNOEloTVZkM1BzMzNtcllBd0txTUc2MEJrQjBkK0VQSi9CR2Jo?=
 =?utf-8?B?S1RZdDlza3BMYXRGMHBOYVBaNzYrQ28veHFqdXc4OVl3ZnBoT2NIcGVkenhH?=
 =?utf-8?B?SkUrYVpha1RBbVNnazlYL2FXUEhGQnJOYXJZTldRenF3c2hBNFJUTHZGN1ZI?=
 =?utf-8?B?c0R4WktrZjM4YmZnNUJIU3BTdHY2S0RDSm1VcVF6OEJVRlh4bDA1K2JvVFIr?=
 =?utf-8?B?SytLNGFGTmFVUVBKajZrS1FKeVhkSDFTaFdXL1YxTUdRcGs1SWUrelVCYXkr?=
 =?utf-8?B?VlRDdXlrZ0x3OFlUU0ZXeWVDVXNtNWRGRHNRT2t3Y1RNSUI0RDYzZTBLNWhP?=
 =?utf-8?B?R2N6L3Nnc0VsaXZLZzNZQmhvWmZoc3NFSXhHS3hobTc5ak9MTE9vTXFwdlZn?=
 =?utf-8?B?Mi9NMHI2WFBFUlB5UWhLTGRFMERFakxNQWU5c0o3bXcyNUdEblZ1TUJIcnQr?=
 =?utf-8?B?TWlzbG1YK3ZrSnk4NFZpYUhFME9zc1hMcGJxcDVDV0JLNjBpMk9lbzFEVTU5?=
 =?utf-8?B?MU5VUlJsdVhWandYREFlbnZRckt0K1ZLK0I2MUppR3NPWkwzRGpBclQ1clBY?=
 =?utf-8?B?dU93eEV6ZVYzL2U2U1BlcnlSMVE5a0xMZFJUWlhaeHQ2Uzd6aTM2NmNpTWJs?=
 =?utf-8?B?ODBySHYyWnRWeWIrWFk3MVVnS0N3RW1GYStRalFsZkRDVUFYSzFuTWo4RThD?=
 =?utf-8?Q?91Tlf+bsp/hub?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjFYdnVMaGh5djFoSUs0OFJOSGZTeXhWN0h6S0J6ZVI1QUkxaUg1Y1BSME5u?=
 =?utf-8?B?aUJ6Rlk4ODBqVE9iSWJ5MHBPU2cydHNXOVpuUmlJV0xkZWlHaVN2ZTBxZzNl?=
 =?utf-8?B?c014V3FncjBqbW9LMGNOMlIzOC81R3F2ZjRoMHNMdU9MWnphTzlCUTJzRjJI?=
 =?utf-8?B?VG5JdC9MWDdiOFkvbTFWOUQwTFE0OWIyajdIcldybEc4Z3hoa2EzQnljeXZ6?=
 =?utf-8?B?aHJ1Z3F6MmJYYlFKaStUVWhmcVFsUHNsMU1OOHBGUHpWaS9BNUJrYk0yaTRG?=
 =?utf-8?B?cVhNZ3lZRDBtMVNYMWNZRGNXbmc5bEtXa0NPeDM1SjBCQ0xNQk42U3RGNmVW?=
 =?utf-8?B?WXhnbUxQZi9oZWpXVnVTd282cjhSRVNQT3BCZkUzWk40blZWcGtvSXl2bmZB?=
 =?utf-8?B?ZWhhUUdzak5WUEcrRHZnTG1NWDlyMitadkFBSndMRHQvQ3dWMTZ5UkJHVkxN?=
 =?utf-8?B?S29Namw0TXllMTF4b1lwbE5yWTNWOUdTR1FpM1RQTS9KU0xZOXJjeUpHWURi?=
 =?utf-8?B?WnhrT2phKzg1YXNKSXNJaldsZTdSTUEzU0szVnpxYTNybzREcll4TFVQcWRr?=
 =?utf-8?B?U0RmYkpaVytxUUx5Q1BwN05lQVRIUkp6a0xhSFVReWdKdlhRNUZiM2p4Q2lR?=
 =?utf-8?B?OVd6azlTdGQ2SzcrSExodUE1OXFUeUlHQU9tbytkYjRhQXovWWZQQkw0aU9P?=
 =?utf-8?B?VVBiUkNGK3hnYWpTZStzMjRCbStYd2pQL3NqN08yVUwwQkswbURZMU5WVitv?=
 =?utf-8?B?aStkaGFacDB6dERkcWNINlRNZE85d3cyR00zanZQSzBzUzM3M2tqSkM3TER4?=
 =?utf-8?B?c0lpTW5CTkRoc1NlSm1jYjFRdjJaa0h5MGQvdEVGcUlZSW9NeEI5d2FtelFX?=
 =?utf-8?B?aHlJYVlremdiL2hkd05iRktMbHphdWtMMm1pdW1MN0t2VTBhWTJod3hEcWpD?=
 =?utf-8?B?SkpsWG14ajFtdzArWTVVcjMrSUcvRHhNZnBYT0dHS204QlB1cnh4czdocStj?=
 =?utf-8?B?M2o5RXJnUWs2SEpvZVBwR1NmSlBiNEVDNW5vU2prbXBkQUJic0J2eEVUMnZw?=
 =?utf-8?B?Q1BVYXhjSWtZRThSd2ptbVVqYkJHSVB1VUhDdEhKcXRUb25FMEtPd2k1d1lC?=
 =?utf-8?B?MEk2YVJnRjhKamIzbjU2em13UnBMcEdZckhkM0FVSnVycWVuZWlSQjUzOTNj?=
 =?utf-8?B?YXRlU0RQeWZ4eDVidXozeSsxMHU0TTB0SXVyeTRyVW54L3o0cXVYU2hPRm9o?=
 =?utf-8?B?dTd6MjU2WmtqRWRYL0o3dndjOTJ4elhUQllrVEgwZXVwZWRzQXpINE1FSno3?=
 =?utf-8?B?b2l5UUhUWFNpSU9uQ0R3cmR5Vy9uV0hQR3NFUEZxNTVqZHEySmpSMUY3amZ0?=
 =?utf-8?B?cVVUd2w2WXFielI4YzVlcThPMWhJWTVHNVB3bDlFaU8wOGlZUiszUEQyUUxU?=
 =?utf-8?B?WlFYYnNaRHN6TFpOOVpzYlRLV3g3Y3VBMCs4YlBKRGFSb1ErazY1dTJuNHdB?=
 =?utf-8?B?ZTJRM1VJRmtqN0xFYVR2dFJWR2x4RnNHdDFEazBUejdYY09JeUhKYTUzb04r?=
 =?utf-8?B?QkJxOGF4RmhtSVlrNTBBYzNubmZEa1BuUFdUdVNtS2QvbXJEY3FkVmY0WUtp?=
 =?utf-8?B?cFEraFE4cDBCWjc0VkJWdzJuZFBqbHNtNUQxY0UyR3hjNzFOSmNEQWxuQVNX?=
 =?utf-8?B?SmhhN0pkRGhJRWJKUEtvdEM1VytaWXVjT1JqbWJNbW9Pb2ZVdzRtcHlYZW95?=
 =?utf-8?B?MmxQSVhMU25jVzIxZzVxMWdaQkt6RUJ1bzAwYnZ2eGcwaURpdmJpUzk4dDZH?=
 =?utf-8?B?dGRnclBDMjlKYjRLemY2UmpaVE1qcGNQTWlFcmQrajRMYm9vNjlWWVZSK3pR?=
 =?utf-8?B?MGNONU5CRnVXN1RYWG0xaTk1Y0M5YmdBN0tlZWN5Z3pzTEljblptdmpCUGJn?=
 =?utf-8?B?dEpXUW5JWS94eTZDeUthZWdSUTJmTm9aa25tbmFPbk11b3RVNUM5Skp4dlpM?=
 =?utf-8?B?Y0wza1NrVFNCbEEvWldHM0YzZlNvU3pKWWo2dC9PbEUxNUNPeTkxMzYzSTdJ?=
 =?utf-8?B?Vm0va3o3enRGTDhadTdIcG5YY3lMYVRaOHpNUGQ3Z1d6RUc1cGpOcmsvZ241?=
 =?utf-8?Q?Nr+jqjVdfkL/gzegQQ0r7KmbT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5dd9557-fb05-4bfc-ea4c-08dd3b828cbd
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 07:50:05.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XGmEaEWci87gLgWGu0a9e2fu/sa9GqAFiX50QXaMbtVU1WOA6vTB1Q97Nu/nq8pu6zVl1T+3Y8rqhWqnxbYltw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458

> Simplify code by replacing &to_kvm_svm(kvm)->sev_info with
> to_kvm_sev_info() helper function. Wherever possible, drop the local
> variable declaration and directly use the helper instead.
> 
> No functional changes.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

LGTM

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 124 +++++++++++++++++------------------------
>   arch/x86/kvm/svm/svm.h |   8 +--
>   2 files changed, 54 insertions(+), 78 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0f04f365885c..e6fd60aac30c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -140,7 +140,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
>   static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>   
>   	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
>   }
> @@ -226,9 +226,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   
>   static unsigned int sev_get_asid(struct kvm *kvm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -
> -	return sev->asid;
> +	return to_kvm_sev_info(kvm)->asid;
>   }
>   
>   static void sev_asid_free(struct kvm_sev_info *sev)
> @@ -403,7 +401,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   			    struct kvm_sev_init *data,
>   			    unsigned long vm_type)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_platform_init_args init_args = {0};
>   	bool es_active = vm_type != KVM_X86_SEV_VM;
>   	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
> @@ -500,10 +498,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct kvm_sev_init data;
>   
> -	if (!sev->need_init)
> +	if (!to_kvm_sev_info(kvm)->need_init)
>   		return -EINVAL;
>   
>   	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
> @@ -543,14 +540,14 @@ static int __sev_issue_cmd(int fd, int id, void *data, int *error)
>   
>   static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   
>   	return __sev_issue_cmd(sev->fd, id, data, error);
>   }
>   
>   static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_data_launch_start start;
>   	struct kvm_sev_launch_start params;
>   	void *dh_blob, *session_blob;
> @@ -624,7 +621,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   				    unsigned long ulen, unsigned long *n,
>   				    int write)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	unsigned long npages, size;
>   	int npinned;
>   	unsigned long locked, lock_limit;
> @@ -686,11 +683,9 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
>   			     unsigned long npages)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -
>   	unpin_user_pages(pages, npages);
>   	kvfree(pages);
> -	sev->pages_locked -= npages;
> +	to_kvm_sev_info(kvm)->pages_locked -= npages;
>   }
>   
>   static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> @@ -734,7 +729,6 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>   static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct kvm_sev_launch_update_data params;
>   	struct sev_data_launch_update_data data;
>   	struct page **inpages;
> @@ -762,7 +756,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	sev_clflush_pages(inpages, npages);
>   
>   	data.reserved = 0;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   
>   	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i += pages) {
>   		int offset, len;
> @@ -802,7 +796,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>   	struct sev_es_save_area *save = svm->sev_es.vmsa;
>   	struct xregs_state *xsave;
>   	const u8 *s;
> @@ -972,7 +966,6 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	void __user *measure = u64_to_user_ptr(argp->data);
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_launch_measure data;
>   	struct kvm_sev_launch_measure params;
>   	void __user *p = NULL;
> @@ -1005,7 +998,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	}
>   
>   cmd:
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_MEASURE, &data, &argp->error);
>   
>   	/*
> @@ -1033,19 +1026,17 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_launch_finish data;
>   
>   	if (!sev_guest(kvm))
>   		return -ENOTTY;
>   
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_FINISH, &data, &argp->error);
>   }
>   
>   static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct kvm_sev_guest_status params;
>   	struct sev_data_guest_status data;
>   	int ret;
> @@ -1055,7 +1046,7 @@ static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	memset(&data, 0, sizeof(data));
>   
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	ret = sev_issue_cmd(kvm, SEV_CMD_GUEST_STATUS, &data, &argp->error);
>   	if (ret)
>   		return ret;
> @@ -1074,11 +1065,10 @@ static int __sev_issue_dbg_cmd(struct kvm *kvm, unsigned long src,
>   			       unsigned long dst, int size,
>   			       int *error, bool enc)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_dbg data;
>   
>   	data.reserved = 0;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	data.dst_addr = dst;
>   	data.src_addr = src;
>   	data.len = size;
> @@ -1302,7 +1292,6 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
>   
>   static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_launch_secret data;
>   	struct kvm_sev_launch_secret params;
>   	struct page **pages;
> @@ -1358,7 +1347,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	data.hdr_address = __psp_pa(hdr);
>   	data.hdr_len = params.hdr_len;
>   
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_SECRET, &data, &argp->error);
>   
>   	kfree(hdr);
> @@ -1378,7 +1367,6 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	void __user *report = u64_to_user_ptr(argp->data);
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_attestation_report data;
>   	struct kvm_sev_attestation_report params;
>   	void __user *p;
> @@ -1411,7 +1399,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		memcpy(data.mnonce, params.mnonce, sizeof(params.mnonce));
>   	}
>   cmd:
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, &data, &argp->error);
>   	/*
>   	 * If we query the session length, FW responded with expected data.
> @@ -1441,12 +1429,11 @@ static int
>   __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   				      struct kvm_sev_send_start *params)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_send_start data;
>   	int ret;
>   
>   	memset(&data, 0, sizeof(data));
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
>   
>   	params->session_len = data.session_len;
> @@ -1459,7 +1446,6 @@ __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   
>   static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_send_start data;
>   	struct kvm_sev_send_start params;
>   	void *amd_certs, *session_data;
> @@ -1520,7 +1506,7 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	data.amd_certs_len = params.amd_certs_len;
>   	data.session_address = __psp_pa(session_data);
>   	data.session_len = params.session_len;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   
>   	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
>   
> @@ -1552,12 +1538,11 @@ static int
>   __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   				     struct kvm_sev_send_update_data *params)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_send_update_data data;
>   	int ret;
>   
>   	memset(&data, 0, sizeof(data));
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
>   
>   	params->hdr_len = data.hdr_len;
> @@ -1572,7 +1557,6 @@ __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
>   
>   static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_send_update_data data;
>   	struct kvm_sev_send_update_data params;
>   	void *hdr, *trans_data;
> @@ -1626,7 +1610,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
>   	data.guest_address |= sev_me_mask;
>   	data.guest_len = params.guest_len;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   
>   	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
>   
> @@ -1657,31 +1641,29 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_send_finish data;
>   
>   	if (!sev_guest(kvm))
>   		return -ENOTTY;
>   
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	return sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, &data, &argp->error);
>   }
>   
>   static int sev_send_cancel(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_send_cancel data;
>   
>   	if (!sev_guest(kvm))
>   		return -ENOTTY;
>   
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	return sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, &data, &argp->error);
>   }
>   
>   static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_data_receive_start start;
>   	struct kvm_sev_receive_start params;
>   	int *error = &argp->error;
> @@ -1755,7 +1737,6 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct kvm_sev_receive_update_data params;
>   	struct sev_data_receive_update_data data;
>   	void *hdr = NULL, *trans = NULL;
> @@ -1815,7 +1796,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
>   	data.guest_address |= sev_me_mask;
>   	data.guest_len = params.guest_len;
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   
>   	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
>   				&argp->error);
> @@ -1832,13 +1813,12 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_receive_finish data;
>   
>   	if (!sev_guest(kvm))
>   		return -ENOTTY;
>   
> -	data.handle = sev->handle;
> +	data.handle = to_kvm_sev_info(kvm)->handle;
>   	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
>   }
>   
> @@ -1858,8 +1838,8 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_id)
>   
>   static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>   {
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
> +	struct kvm_sev_info *dst_sev = to_kvm_sev_info(dst_kvm);
> +	struct kvm_sev_info *src_sev = to_kvm_sev_info(src_kvm);
>   	int r = -EBUSY;
>   
>   	if (dst_kvm == src_kvm)
> @@ -1893,8 +1873,8 @@ static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>   
>   static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
>   {
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
> +	struct kvm_sev_info *dst_sev = to_kvm_sev_info(dst_kvm);
> +	struct kvm_sev_info *src_sev = to_kvm_sev_info(src_kvm);
>   
>   	mutex_unlock(&dst_kvm->lock);
>   	mutex_unlock(&src_kvm->lock);
> @@ -1968,8 +1948,8 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
>   
>   static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>   {
> -	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
> +	struct kvm_sev_info *dst = to_kvm_sev_info(dst_kvm);
> +	struct kvm_sev_info *src = to_kvm_sev_info(src_kvm);
>   	struct kvm_vcpu *dst_vcpu, *src_vcpu;
>   	struct vcpu_svm *dst_svm, *src_svm;
>   	struct kvm_sev_info *mirror;
> @@ -2009,8 +1989,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>   	 * and add the new mirror to the list.
>   	 */
>   	if (is_mirroring_enc_context(dst_kvm)) {
> -		struct kvm_sev_info *owner_sev_info =
> -			&to_kvm_svm(dst->enc_context_owner)->sev_info;
> +		struct kvm_sev_info *owner_sev_info = to_kvm_sev_info(dst->enc_context_owner);
>   
>   		list_del(&src->mirror_entry);
>   		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
> @@ -2069,7 +2048,7 @@ static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
>   
>   int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   {
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *dst_sev = to_kvm_sev_info(kvm);
>   	struct kvm_sev_info *src_sev, *cg_cleanup_sev;
>   	CLASS(fd, f)(source_fd);
>   	struct kvm *source_kvm;
> @@ -2093,7 +2072,7 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   		goto out_unlock;
>   	}
>   
> -	src_sev = &to_kvm_svm(source_kvm)->sev_info;
> +	src_sev = to_kvm_sev_info(source_kvm);
>   
>   	dst_sev->misc_cg = get_current_misc_cg();
>   	cg_cleanup_sev = dst_sev;
> @@ -2181,7 +2160,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int snp_bind_asid(struct kvm *kvm, int *error)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_data_snp_activate data = {0};
>   
>   	data.gctx_paddr = __psp_pa(sev->snp_context);
> @@ -2191,7 +2170,7 @@ static int snp_bind_asid(struct kvm *kvm, int *error)
>   
>   static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_data_snp_launch_start start = {0};
>   	struct kvm_sev_snp_launch_start params;
>   	int rc;
> @@ -2260,7 +2239,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>   				  void __user *src, int order, void *opaque)
>   {
>   	struct sev_gmem_populate_args *sev_populate_args = opaque;
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	int n_private = 0, ret, i;
>   	int npages = (1 << order);
>   	gfn_t gfn;
> @@ -2350,7 +2329,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>   
>   static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_gmem_populate_args sev_populate_args = {0};
>   	struct kvm_sev_snp_launch_update params;
>   	struct kvm_memory_slot *memslot;
> @@ -2434,7 +2413,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_data_snp_launch_update data = {};
>   	struct kvm_vcpu *vcpu;
>   	unsigned long i;
> @@ -2482,7 +2461,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct kvm_sev_snp_launch_finish params;
>   	struct sev_data_snp_launch_finish *data;
>   	void *id_block = NULL, *id_auth = NULL;
> @@ -2677,7 +2656,7 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   int sev_mem_enc_register_region(struct kvm *kvm,
>   				struct kvm_enc_region *range)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct enc_region *region;
>   	int ret = 0;
>   
> @@ -2729,7 +2708,7 @@ int sev_mem_enc_register_region(struct kvm *kvm,
>   static struct enc_region *
>   find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct list_head *head = &sev->regions_list;
>   	struct enc_region *i;
>   
> @@ -2824,9 +2803,9 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   	 * The mirror kvm holds an enc_context_owner ref so its asid can't
>   	 * disappear until we're done with it
>   	 */
> -	source_sev = &to_kvm_svm(source_kvm)->sev_info;
> +	source_sev = to_kvm_sev_info(source_kvm);
>   	kvm_get_kvm(source_kvm);
> -	mirror_sev = &to_kvm_svm(kvm)->sev_info;
> +	mirror_sev = to_kvm_sev_info(kvm);
>   	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>   
>   	/* Set enc_context_owner and copy its encryption context over */
> @@ -2854,7 +2833,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   
>   static int snp_decommission_context(struct kvm *kvm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct sev_data_snp_addr data = {};
>   	int ret;
>   
> @@ -2879,7 +2858,7 @@ static int snp_decommission_context(struct kvm *kvm)
>   
>   void sev_vm_destroy(struct kvm *kvm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	struct list_head *head = &sev->regions_list;
>   	struct list_head *pos, *q;
>   
> @@ -3933,7 +3912,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>   
>   static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>   	struct kvm_vcpu *target_vcpu;
>   	struct vcpu_svm *target_svm;
> @@ -3974,7 +3952,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   		u64 sev_features;
>   
>   		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> -		sev_features ^= sev->vmsa_features;
> +		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
>   
>   		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
>   			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
> @@ -4134,7 +4112,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>   {
>   	struct vmcb_control_area *control = &svm->vmcb->control;
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>   	u64 ghcb_info;
>   	int ret = 1;
>   
> @@ -4354,7 +4332,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   		ret = kvm_emulate_ap_reset_hold(vcpu);
>   		break;
>   	case SVM_VMGEXIT_AP_JUMP_TABLE: {
> -		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +		struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>   
>   		switch (control->exit_info_1) {
>   		case 0:
> @@ -4565,7 +4543,7 @@ void sev_init_vmcb(struct vcpu_svm *svm)
>   void sev_es_vcpu_reset(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
>   
>   	/*
>   	 * Set the GHCB MSR value as per the GHCB specification when emulating
> @@ -4833,7 +4811,7 @@ static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
>   
>   int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   	kvm_pfn_t pfn_aligned;
>   	gfn_t gfn_aligned;
>   	int level, rc;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf87..5b159f017055 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -361,20 +361,18 @@ static __always_inline struct kvm_sev_info *to_kvm_sev_info(struct kvm *kvm)
>   #ifdef CONFIG_KVM_AMD_SEV
>   static __always_inline bool sev_guest(struct kvm *kvm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -
> -	return sev->active;
> +	return to_kvm_sev_info(kvm)->active;
>   }
>   static __always_inline bool sev_es_guest(struct kvm *kvm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   
>   	return sev->es_active && !WARN_ON_ONCE(!sev->active);
>   }
>   
>   static __always_inline bool sev_snp_guest(struct kvm *kvm)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>   
>   	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
>   	       !WARN_ON_ONCE(!sev_es_guest(kvm));
> 
> base-commit: 86eb1aef7279ec68fe9b7a44685efc09aa56a8f0


