Return-Path: <kvm+bounces-38720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC407A3DF12
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 16:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 126AB188AE28
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81A61FDA62;
	Thu, 20 Feb 2025 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="qpiKUEaj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2126.outbound.protection.outlook.com [40.107.95.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424451DEFE7
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740066249; cv=fail; b=BKndU7aV+vhqRJqf1PoHiR/jgVeS3GHYaIuTomR2WWWvgRz9wap+MJpgf+sjad3wNf+9ph9xOYlJ3axbekfGPL5QzFmMFp+jZ+Ea1E8Cfr2ZBJ0NZpQMgmvEuaOMqfaQkuQQP5X4P+Xb+tLk95SpzLQZ4ycYdY5qhESCjrJJ6Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740066249; c=relaxed/simple;
	bh=A282GYeLBUTeOKpr0M5x4lUwrnc/h1enogUFn762DkU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NNcIARfrcX/HigoLVovxpXakN7QjKI/GIjJDJrQDhjDM2kVa2OsCT5ZY9GV/CXDetbhSYyt58GvdY4Z7hl7OfKhoPB49/ieUdXIMsn9vUp9cl2yjioxvwGIdyGbkNCPLkICxhNcCH7R4wKsYncCkyzTE5ls9PRCmuGvFAHhdfdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=qpiKUEaj; arc=fail smtp.client-ip=40.107.95.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5+9YArGIV4xqKLPFQctHbrH2EWmpqM3Nb3Q7g5Dz6zJIsggFzYRC6T18tOet0c98rtv1cU/QZzvm1VcsBvlhi7NbhTe0GiAmVdZzQgyT8deYhAVHuzIB/PKVtgBoakz+XhRn5pdpE1kH9TXIoaXrzST8Hbr0cyHO8gX/M3wTBoRD9VNfp1Gimfqnl/ZKYZPd5qQc04260nig6y8FjzlXeHMzQ3CuiZOPZ15r6UrWBkTh9d15yVSUei6qET4RiegSsurTo2tR2MojdzLvmibx99WP6HoW69uOLI+Xm1VhsI/2LSALlCTOqBJ4WL4mEj5jndBRzvPzXv6lYWXA0TRkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfmWVw439cC9tNoofyFTf85q3d/+gHkqKQeUqSgeCPY=;
 b=bBFL2U/RrTjKcs+OJ3NlIgf5i+vntLhuHAYzqPkjU8sVG0sMZYp/WpW6/UL+jjPzr3pqfewaOaywNMWFNNhtvjxEa7yUVkqwU/puR0xbAQFKHyYxO65iHcf7117oFFGbdN6TgBgNz5YVGXJoIVnM54W/Egstdhr0tzI1Rh0HsYTtb3M7fEaPgBZ73iBgUbtmqc8m7rZnYl//oOIDwgO08g/p13GT7IcA2NZ7hV5qNzTSokcCGpPdNkM3rtg8Z4zneDi2NKzfjdNakpnaP21wY9qDxlc3j5Ih+WQILilc7dycZybWgnZ0PB+bfmSdc52HqozaXgnA8Z3RBiyk+nBDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfmWVw439cC9tNoofyFTf85q3d/+gHkqKQeUqSgeCPY=;
 b=qpiKUEajCdX2owgURSReak+hr7dCHs3DtIX0wwtghuTlqVwQ5FPCnkG21i1+FVCeRom5XnLphzEIXyjNI+xxrUMfoHOibtWXtvuWy3dxJIukYKdj9Xfc7P7PQYLunBRkbLJqN2Xz4MQI/VTpSB9bxHQ3Cw9MeFCR4TQJnuIycHI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 LV2PR01MB7839.prod.exchangelabs.com (2603:10b6:408:14f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.14; Thu, 20 Feb 2025 15:44:02 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.8466.009; Thu, 20 Feb 2025
 15:44:02 +0000
Message-ID: <c663be4c-87b3-43e0-9669-1d18f1a2998d@os.amperecomputing.com>
Date: Thu, 20 Feb 2025 21:13:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] KVM: arm64: Consolidate idreg callbacks
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>
References: <20250220134907.554085-1-maz@kernel.org>
 <20250220134907.554085-7-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20250220134907.554085-7-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|LV2PR01MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: d049eee2-6eaa-479d-285a-08dd51c5662f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkpSSkVwL08rdlR3UnBGbWptMU0yREdjWmFTQ090eEVONFZ2Z0FjM2NHQVlG?=
 =?utf-8?B?WktvT2p0OWxOUTcwRUxNMEpvRGk5Z2FwSlp5bDhYenBlWjI4WVc2KytXUEdk?=
 =?utf-8?B?NGFGRTREZVNJaVBPcWhRUEhSTE1IQjZkNUtRYWdlejZheXN6bTNOVkcyZ21O?=
 =?utf-8?B?enNLK09LdzNVck5OUEhrSnY5Uko0alM5L2VvKy9RN0EvMGVIRm1PanY2cEJk?=
 =?utf-8?B?b3FwUG56OW5xUHFFMElwMkU0c2NzWGYzcHIyK1ljTEhGb0tvcEVobnpOU2pq?=
 =?utf-8?B?NnNxVlVzV2Q2U0QxRUxaelhiUjR2MGZ0bXRlazRxSDFEK0xRbW9NdmRkWVFM?=
 =?utf-8?B?Zmx5RnhEd2xoRS96ZWRDRVhMQU9jSjN1aEFRdDZMOEtUUkt5aFdPUWZpMnhk?=
 =?utf-8?B?QllObFRUajJrRzUxbExiODlJbWplZlpObjgwVEFPQlY2MW9MaVFxMG1pZDZN?=
 =?utf-8?B?TU5iOTZhcW9LM1A2OUFGTWN1QnFqMzE2VWYwOXM5K2VOYkhSLzJwb3pUVWlz?=
 =?utf-8?B?NjgydjJuNXNuUS9WVitML2lOc0ZDTGNLUzl4TitqUG9hS1NaQ0RudEdqdTN4?=
 =?utf-8?B?YTk4ZVFDY3V3Z2J5ZGR6WUQwWURWSnFYR1RQcjFOcUwwdUFpUzVXV1RWZkYz?=
 =?utf-8?B?YllWc0Y5b0RjR0FERTFkUytwdVVTekFqMUJRRklZMUpPaHkwdEhpN1poUTNz?=
 =?utf-8?B?a2pTZnVFVnNxd3A0RGxQNHYrbFIvdWlQRXZGS3Q2bkRqM0RzRjRTOURHZjg0?=
 =?utf-8?B?K1JLT1NoR2plQWQ3MVZkV3Jzbm1YV0kvU2RWTFVMMDUzSUQ5emVocERwYU5t?=
 =?utf-8?B?ZnNTM0VSMjFVUXVQdEw0VVl1Yk1vRk51c1hOV2FZVWRoSXg0VklidTR0T3VO?=
 =?utf-8?B?Q2w3ZWxzMTN6NUpwM09KWU9CUmZzamE3cHdWQ2RtOVhrbmY0K3M5RUdZL21l?=
 =?utf-8?B?S0d2Q28yL05vckxZSHhNcGdIeWpsWkRRWUV5cEozODl1MnY4VklTMlduREF4?=
 =?utf-8?B?U3ZyL2d2ZFBFZHhCMkxmMGhvVFhnN1ZpWHpIN1dYS2FWVjkvWTdRY2d1T2tM?=
 =?utf-8?B?bW9VWXRUTXliL201cjlxMFQyait3amUwa3M3SXpkY2x6c0pkQ3grY0lCWHQx?=
 =?utf-8?B?dzVMWHpvNnZ0TVQyQWJHazg4S0x0N0VhS0xoZ2lac1ZjTHlldWNWdnRSUjRx?=
 =?utf-8?B?S25ZQVRPbGZRajNsV1NOL0J0dmdxamM1dVMyUUMzQWczeGNjdzFxejV0Mlg3?=
 =?utf-8?B?TkxBR3I4RW1Ia3QrQStVdVJNK2NDL0JaWjRBMFBaTVM1YnB0N0pNMGpzSWRO?=
 =?utf-8?B?bU5YQjVQQk94UW1QVFdkZXRLTDUxSzJhdE5JelNKa1NlT21HR1B6dVBqemha?=
 =?utf-8?B?ZTV1dmpMQXdqNTRsdW5QdFJ4ZmtXcXh3eW1ld2Q3Vk81Q25RNFVCeEhFK1Z4?=
 =?utf-8?B?aHdDRnArMU1SMlhIaGlQTWFvUndxTStsTy82a2RkQSsxc0hlODJXeXgrMWV4?=
 =?utf-8?B?VVFodk9aQi9zSkdBU2VmTE44N0djNHUxWCtZOEZEOFppbTVPK0hOWGZEWlAy?=
 =?utf-8?B?T3g1eUdxck85TmRabVNVU0FmV0RpNnlhVDdydEo1WFZBMHhHazRDV0ZoeGlh?=
 =?utf-8?B?bE90TnkvY29Xc0dsaEd4TFd5K2lJSDUwZ1dqMS8yUHp2MUZlb3d3cDV0dElp?=
 =?utf-8?B?azdGQnVvOG9HSjBSNDBDNG5BekNOMXFxWWtRNHVCZ214Qis0RzJpUWFMMDdo?=
 =?utf-8?B?ZWx1MlE3cHEwTDdxQ21pRFVHTmUxaUFwWjNvUHNHaVlRS1kzc3JCMmpYTURr?=
 =?utf-8?B?U3dRNWhRTmE5QlJid3RwOTFVYlprTjhGckVlUkU5aWEvaWJBT1VuY0FZa3ZO?=
 =?utf-8?Q?1fGzbetCyOvi1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1RzRlBZVzRDT1dxK09RT05RZzhhcGxpcU5UcnpjUE1FRUlraVE3Q25MbUkr?=
 =?utf-8?B?aEhnSUxxcCtsWHhtUGlKZ092bTRxVGUwbTcvTzArb1VxV2N1N2hwTGhMVjF6?=
 =?utf-8?B?SVJSTFY5QWliZTJBc0NIRHozQ1FzalNTNS90U1JBKzFQVUFieWh4ZGsrbWhH?=
 =?utf-8?B?NWJaUWZDNVRqOFpTaWd2NFVZeklGSDhlUXN5NjVpdFgxVmlYM044RFp3VXVn?=
 =?utf-8?B?eVU4Ny9ySTk0TGxFZ2FaZXdhUW9lRmlyQ04rdHVVMTJiQWQ5VWRwektOZG5U?=
 =?utf-8?B?Q293Y093OGpwQlN3bkZxWkVrdHllMHRaWTFkeDh4djlKL0hjRkJiUjlibjVO?=
 =?utf-8?B?NzR5a2h3Z2VsbFd4bi9BY0tWc0VpYTc4RlQ4bkVmWlIveFpONFZqWFYrdDNQ?=
 =?utf-8?B?S2FNOGlqNTd5Z2l4cFFYampWcFphMENKaXVKaTBaMk1hRnpJVUk5azFSMlVu?=
 =?utf-8?B?K0J4b3liRGsxRGNUQjhBS2ErRk9XeTV2anJFRHppOFNId1IzUGNuUkc3ZERj?=
 =?utf-8?B?YjBDRmF1V1U5dVlvSEJvV3lKQmpObjZQQTFLUVB2TkN1Rk9ENTlvblhFZTBN?=
 =?utf-8?B?cnVXN043UlZFMWdqcE1UemU5RDZaNnA4TmtpUVRXQnRpeEt2MjlackNTalZG?=
 =?utf-8?B?eXZib1I3TElkRlJmLy9CM0swRW1DVTBOWll1cGpDaU9VUXFEb1p0QzJDc0o2?=
 =?utf-8?B?WEJkVndPK3U3bnY4SmVJL280enhlZVdMNFJkdWNiOUduaWNFNythSjExQ1Qy?=
 =?utf-8?B?aEM4QzErM0RFQTlNMTVJbjQ5WThmclNMMEE4M3cydEp3c2JwZXF6WGdWTzNP?=
 =?utf-8?B?MUx4VzFXWGR3WFRkM3BFMy9tdjNzZ2dOb2FScTZHdGhqQkVPNytHRkRXYThj?=
 =?utf-8?B?MnBxM3ZpdHNGZGNOczZCM29IdDl5TEo2K1lDMVdCaTJKeGJMdGR2Nkd5Ty9a?=
 =?utf-8?B?aE5qK3BhSG0vc2piMER2VGxhNno5Sml0OTFHNlN3Nkt0TW9BN1czTFYxQzRs?=
 =?utf-8?B?U0VzdCs4cXF2ZE00dzR1NE5ITnZ5WFJtZSsvSThVRjBQQkNadU1DeVN2aCtl?=
 =?utf-8?B?T1RBQlc1aHJMYnZtVlZXR2UzTkZGZ1c1OUIxcEZIaFVNLzdoOXkybjc1Ujhp?=
 =?utf-8?B?b1dPZWhTVTZPRTcraUo1NURYZkFpSlFvMFhTaTJUOCtOSCtuNDd3Ni9XUW9P?=
 =?utf-8?B?Mlk4V1U4SGVnMjBxaGczdGtoSm51WkZNWndzZ2MwaFp0TGRUWnRWV2tvUCtY?=
 =?utf-8?B?YW9JNWRSL3lkWnZMb3NhSXJlQ2daY0R3MmFDc1dFdnpVeVY2aHJxQmFrK3Jk?=
 =?utf-8?B?K29iUWxNbTJwV01MOTlmcmhsUitrSGpIWXlyWHhOQkFLUFY1dklpbVpxbExs?=
 =?utf-8?B?Z2FTeTVYUEpFY3RyclUzdjVVN3pxc1RPdnk1VHJXU2U0d0FhQ3lGdFdJYWZZ?=
 =?utf-8?B?dEx4bXAzR0xQdVVVSE9JKzg2NlpiMEVROUtTbkY2YjhieFR3VUZvZ1VUdXZR?=
 =?utf-8?B?YnljRlc4N2hPOHd2TGFYTExzLzNXYmg0ZXBHa1p4cUtVTndFMThOYm5jU1Ra?=
 =?utf-8?B?K2tRZjlGTWhkN1Q1QU93S2pzVS9KUzd5dlFQUGpQVDlnbjBiRzg4RmJCbm5R?=
 =?utf-8?B?STdvYjlZV0ttQUJRNytaTTNOWXVKenR2cXJsVjgxUkpYeU0rUWRDTkxOejZD?=
 =?utf-8?B?azZKMlVyWDRTMFFhK3M5VGZQY0d4b1UzUmdySUtxQnd1L2dvRXVSZkNyMXJL?=
 =?utf-8?B?Vmt0Y0dUUGo4VWI4a0FCL1ZTOFFNbVFtNU9HdGtaRjJ2Zk5MTnVMa1YyZVBo?=
 =?utf-8?B?L3VFM0ROMXp4anNjZzFWNXBVL1pSQnRKb2pHYS9SR0hJd2RDTzF2SElDMUln?=
 =?utf-8?B?OFZ6ejlGWGRDZ09oRUlPNkV1bjBmU2xlanpVVGJucCtCcE5JamxhbXlURHN5?=
 =?utf-8?B?U01xbEJkMk1FWUdQM0xJeUlRTTNHdnZoS3ppWHMrdmNZZ0locTRRZUdINDBP?=
 =?utf-8?B?ZGJOS3Bxb1NFcURpaVozOGx2L2xpYjlOT0ZOM2M3eDJmd0ZHVlBkbUF1SWYr?=
 =?utf-8?B?eXR3MDdVajNWQ1hQZm0zME1OSWxQT3dQVk81Zmp2cm1vNjM3aGVQSzc4U2xx?=
 =?utf-8?B?OVBZUmxxeXFSRFFQQUVoV3NCSDFDcWxpYnlmNzhydFlSbW1hWlJ3RU9qQU5x?=
 =?utf-8?Q?Bga+IoYXSXMBQ8520FJLTvI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d049eee2-6eaa-479d-285a-08dd51c5662f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 15:44:02.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSLFte/mAn9sUVN2pP0/lNh+720orYvYgut01rvGGQ6JSEzPiGDp2lG9J3vE8URoji/KEQTHLbyIf7zVniNQcvdiJXFQ4fExIE07i1tq8soTHaXyNFoVBZLfJlF9of9+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7839



On 20-02-2025 07:18 pm, Marc Zyngier wrote:
> Most of the ID_DESC() users use the same callbacks, with only a few
> overrides. Consolidate the common callbacks in a macro, and consistently
> use it everywhere.
> 
> Whilst we're at it, give ID_UNALLOCATED() a .name string, so that we can
> easily decode traces.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/sys_regs.c | 28 ++++++++++------------------
>   1 file changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9f10dbd26e348..678213dc15513 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2267,35 +2267,33 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>    * from userspace.
>    */
>   
> +#define ID_DESC_DEFAULT_CALLBACKS		\
> +	.access	= access_id_reg,		\
> +	.get_user = get_id_reg,			\
> +	.set_user = set_id_reg,			\
> +	.visibility = id_visibility,		\
> +	.reset = kvm_read_sanitised_id_reg
> +
>   #define ID_DESC(name)				\
>   	SYS_DESC(SYS_##name),			\
> -	.access	= access_id_reg,		\
> -	.get_user = get_id_reg			\
> +	ID_DESC_DEFAULT_CALLBACKS
>   
>   /* sys_reg_desc initialiser for known cpufeature ID registers */
>   #define ID_SANITISED(name) {			\
>   	ID_DESC(name),				\
> -	.set_user = set_id_reg,			\
> -	.visibility = id_visibility,		\
> -	.reset = kvm_read_sanitised_id_reg,	\
>   	.val = 0,				\
>   }
>   
>   /* sys_reg_desc initialiser for known cpufeature ID registers */
>   #define AA32_ID_SANITISED(name) {		\
>   	ID_DESC(name),				\
> -	.set_user = set_id_reg,			\
>   	.visibility = aa32_id_visibility,	\
> -	.reset = kvm_read_sanitised_id_reg,	\
>   	.val = 0,				\
>   }
>   
>   /* sys_reg_desc initialiser for writable ID registers */
>   #define ID_WRITABLE(name, mask) {		\
>   	ID_DESC(name),				\
> -	.set_user = set_id_reg,			\
> -	.visibility = id_visibility,		\
> -	.reset = kvm_read_sanitised_id_reg,	\
>   	.val = mask,				\
>   }
>   
> @@ -2303,8 +2301,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>   #define ID_FILTERED(sysreg, name, mask) {	\
>   	ID_DESC(sysreg),				\
>   	.set_user = set_##name,				\
> -	.visibility = id_visibility,			\
> -	.reset = kvm_read_sanitised_id_reg,		\
>   	.val = (mask),					\
>   }
>   
> @@ -2314,12 +2310,10 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>    * (1 <= crm < 8, 0 <= Op2 < 8).
>    */
>   #define ID_UNALLOCATED(crm, op2) {			\
> +	.name = "S3_0_0_" #crm "_" #op2,		\
>   	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
> -	.access = access_id_reg,			\
> -	.get_user = get_id_reg,				\
> -	.set_user = set_id_reg,				\
> +	ID_DESC_DEFAULT_CALLBACKS,			\
>   	.visibility = raz_visibility,			\
> -	.reset = kvm_read_sanitised_id_reg,		\
>   	.val = 0,					\
>   }
>   
> @@ -2330,9 +2324,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>    */
>   #define ID_HIDDEN(name) {			\
>   	ID_DESC(name),				\
> -	.set_user = set_id_reg,			\
>   	.visibility = raz_visibility,		\
> -	.reset = kvm_read_sanitised_id_reg,	\
>   	.val = 0,				\
>   }
>   

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

-- 
Thanks,
Ganapat/GK


