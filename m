Return-Path: <kvm+bounces-46130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B93A7AB2E01
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 05:19:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA445178906
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 03:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E15F254860;
	Mon, 12 May 2025 03:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X5w9FmIx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CF1253F07
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 03:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747019986; cv=fail; b=ndMD5fZ9+f1Lj0I0AqY1zZon02TeaFGUj1saaLaoziHwDMBObzjNG5fuOakxaZBQsDYgLbB/FhKSSVQMbXTGR0BUorRZNLU5fIUa9KLDXgfqEAPcFb/KCJkO65mj6+8MSxjiuiMb3hhrMjzghQfcJ1WoGFLOURZM9qwr8VzFv24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747019986; c=relaxed/simple;
	bh=PAbM4wuKsgU5ZjxHP2xaV+ygBmJHqEcBxeJ38PegLqA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DUtyv9nB/MtokiyGXUNOZ77FVvoLJpc4Tp6qzdZyr3w4ELWPq0XbZ4bjpC9H9bqJdP6Bb9Wml64HifjM9gdUYZ+RadJCYWNL+dSMjVq2Iw2PCWJF9ACe8Fm2miMht8a8lnWJBmdCKCOBnpB/Z+zqaTQXfjoAjI1+rxVNZ/qlgwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X5w9FmIx; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747019984; x=1778555984;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PAbM4wuKsgU5ZjxHP2xaV+ygBmJHqEcBxeJ38PegLqA=;
  b=X5w9FmIxVCXBw2NELsY905L86nR03PvpV0cpI2vt5pkO+hbrbxTJjthI
   oUqTgv9IQNME8hHJ5qV/TiIm1ZgbBFZPoS85v9q8GhWj2Z3vx+VAh1PwG
   fQ0Tcz2NaJjafD0islw1gjuXLQv/nx6V5vwA+P1wrOPY89Qh8c8IT16rd
   jtHFBJje+oz+Iuvad4TV0xk/JQRb3aZzH9nUafw4svUBqMhg3VtW80KIg
   dd+l48ECF2FpfAAHwpF1i8X4G341wZl06vIrFroH0XlX63owmQlT01f3S
   L/DqP35OzGRKv/id+zkXBYWgJnPwPhx5f4zaVSkIl5YGnTo2LbdXBiSZS
   A==;
X-CSE-ConnectionGUID: DAzmuucESd2dNmSRbB0iAw==
X-CSE-MsgGUID: q6+v8ayKS0e1XAz7ggG51Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48799015"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="48799015"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 20:19:43 -0700
X-CSE-ConnectionGUID: LW9WgyARShiIMr8CksK/5w==
X-CSE-MsgGUID: UvIYBdW5SfGndkhYp51ipg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138161703"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 20:19:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 11 May 2025 20:19:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 11 May 2025 20:19:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 11 May 2025 20:19:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tV7E0dor2jpqFhPST1HSu30h0z5A68+omJoq8cTQR4lNOf1BbLesZDqkZds8qM96z2LywvlG1wMkEhNUs7vrmLzZzJV0U0R0MfAwLI6a1UaRH/XHwLtAC3Kb4FmE2cQMGKGsl0vL8WnUC4GFvEZh06pMFZ/8eEGnDWSPr0lyXTOOh1Tb4UwMoZpIKyRI3su2JiAe+7+hGnjLwg5kE/cIlNZuV4ATGi1xB3szVC9PLXMFptr0Lyt9qRjBbM4fot2yP47w0JDZ3ePhizVKWSKR7AT8RZPNLTCJeqsB2R4H0zmX8KCznDET8NEa3iTlFnIQ+bdv+6n45qwQQcC/Lx+9RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nn/3xaAybUWSmdSGjqVZovv4cUO/5mcxgRCl8Eu60gI=;
 b=DG8xF5jvhTHOe2p86x12+iYsZMGh2FeI06xK//E9BgKogxv5bvoXXk/y+uMjw3AnRr5iV5UTgRmfAI1HlO673EAwbB5pl13ZC6XMoO15jGhszahsNVCGucs11l7/A7fuUvXeINZv3exv1LtxQ9bvJmDzOTPIkS1bjxndMOkNmKD5y01OQOxNITdSRXZxLNxLFsGxq1kTMwewbiC9H6E2jThDgjCEvKHKAg7XEcLBbtq4HS1Bgls0Pkdp7BaKuBBrPpsjbsDWZ1LEZU7X5mHKCZonPIRxTj+xfBq0QtOukRl2oCv4dTXoOuH2vaxlFUGdcMPuN5y4Ff1I+Jwkh7PdlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA2PR11MB4793.namprd11.prod.outlook.com (2603:10b6:806:fa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.27; Mon, 12 May 2025 03:18:58 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8722.024; Mon, 12 May 2025
 03:18:58 +0000
Message-ID: <589f2889-5664-4429-83d0-8a08671a88ec@intel.com>
Date: Mon, 12 May 2025 11:18:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/13] KVM: Introduce CVMPrivateSharedListener for
 attribute changes during page conversions
To: Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-12-chenyi.qiang@intel.com>
 <f6b9c107-4f6c-43d5-99f9-c5663cffb0cf@linux.intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <f6b9c107-4f6c-43d5-99f9-c5663cffb0cf@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA2PR11MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf13c01-1bfa-4833-411d-08dd9103bbcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFpwRTIxeUM1RDJhUjZmQ3VOZUFEVGZ1MXY5VzJPVVdKT1hTM09xQXRpSm5H?=
 =?utf-8?B?UnBVRmtMbmplVmcxTVAzS3Q0Tnp4ZkZQTlFrZHh4VVBWNjJZaVgvNDFFeW5H?=
 =?utf-8?B?dUpOUURTMWRxOHNGV1RVVHo0VHZlTk10Zm01d3l0c05KNGs0UjlqYkxveEd2?=
 =?utf-8?B?bG1NamdxbHhFeDVuamN1ZXAydm9UNFVPYUhhd1ZEVDFjM0FtcmJBcnAwLzNh?=
 =?utf-8?B?eDY2SFREVEhYRVRzSTF4bnRiY0dRK2U5cHRKZmV4Y2Z5bytPV1dMVkZSRVNv?=
 =?utf-8?B?UFZydXQxNUErdmk5aWNibHByeCt4LzcvQnRueG03aXpId0lYbFpZWWtMNEJn?=
 =?utf-8?B?eS9tcUptcDRyQ2JNWVE4c0YrYWJOWEpNdG5jaGpVcHFyMFB1a0llbGIweEpw?=
 =?utf-8?B?WmllYVFLUEgwNUc5QWNnWkkyRW9nNFVEQms5ME80UzdiT2RvbU9DVktTYjB0?=
 =?utf-8?B?UVFkenlMUy9qM0kvMlMzNS92WlFtUEdqU09kQWVtTnluZC9IcmIxQTJqNzZS?=
 =?utf-8?B?czJuSit6c1lLNEFja0c0dHRJb1I3YVJ3cmtoSTBlTmxIcG5UOVlwOXJyQzNi?=
 =?utf-8?B?cDVUWE9ieElqVis0bmo2WDBWZ2dRS2R0RlVCS1ZzSkxQUHFaTmZtNmVsTG01?=
 =?utf-8?B?ZzVnYjF6VUhDZnUrTGhkeTFFU041TEc2ZnlMZlY0cTZ1QnZZT1Q4NHdYQkU5?=
 =?utf-8?B?N1RkUHh0WnNoRVlLK1dlUkFCNHltQW5URDFhR3hmOTlHRVFETVMvcldwMkZw?=
 =?utf-8?B?OFFLdS91YTlrbnJ5aWlFRGViTTF1L1g4eXc0OHBwVnBiRUxrWFlWWDl6RnF4?=
 =?utf-8?B?azFrdWNYNjVxNStwT1VuYWhObldhTHo5bldNczBQWDlHT0RrVlJrdDl5QlJt?=
 =?utf-8?B?VW5JZWtCZUZRc3VsTkQ5UFROeGMwVmRENVNnNDFDUHMvNzB6U0g1NjNOa2Nz?=
 =?utf-8?B?VHJyOFNIdVQ2c1g4enVBcHdsWHJQNUptL0F5VFJqbTljcUlmclNPeUczOUgw?=
 =?utf-8?B?MFhKZFVyV2V0NC9lRXhxZzR2b05xMW1qL1U3dlVEZXNmUnZidjJ0T3hlWWJi?=
 =?utf-8?B?SGNnc2p0OVF6VkdrT1F0SWRmSEVPNGNUQ21CeXdrL1Vpbm1WRC9UUTlUcTFE?=
 =?utf-8?B?SVVFanZwQkJ2ZlY3NW1vcjhYbjF4S3g5K3N4VzUzNlVwcVpJd1J3MXFRVVZp?=
 =?utf-8?B?d3VoK3ZYbUNMNkZKaU9rRGhTdXNTVW1penpLSkZxblhHOUNJMGxHYnY0cUlh?=
 =?utf-8?B?aDRJZWZCRjVSQ1N1WExJbEJnTHJWZS9veHA0QWNtZWNsSC9WbzR0V3lWaUQv?=
 =?utf-8?B?S3czanFMM1RQYWM3Y1ZiNEM4bSsrdUNwYVk4Z0grSTMrQ2NNNlZpUFNuSExy?=
 =?utf-8?B?MHBWeGl6eEhxS0oyUkpJWDZNVzc3ZmRJS2UzaytlQjNibzhnL3pMUFR5bVhq?=
 =?utf-8?B?VGRQZXpPRWNtL1g3Nng5ZVljWm1BZlIvbUpxbGZ2SFgvbk5nSVo0MG53ek5U?=
 =?utf-8?B?QzVhSHF3RlVvK3lhK05CdkVEWWZQckdGM3BSUk05S0tkYjhZU0htdHJYMkw3?=
 =?utf-8?B?YW5rc1hXcENKdWNjZ05vRUgyR2pmbWhSb1cvREo3T3NFSFFvMkNwdzRvMDdM?=
 =?utf-8?B?bFl1YjdiRDZMNzNxS1kyUmd3eWpPK01SVjBwakdyeVVkWTFmM0hkOEttMlFQ?=
 =?utf-8?B?UEE4VURuOGR1QTg1Yzdsdm9SRTlPcDFGK2Nxbk4wM2g4VGJYOE1LQllRM3l2?=
 =?utf-8?B?Ui9sLzArTVUxVkRrVlhDWXlHZEFaTVBoUXhjSnRnZlM4SzZmQVRudm80QVpq?=
 =?utf-8?B?VHZSK3BrYlpRKzZDMU9ic29sRE85aHEyK3J1VlZpcVpBVXBKR0MxSW9RN0Qr?=
 =?utf-8?B?eEdrb3JxK1BBT3JTV1VnOG5sUkFEaHFBeTRNYlBGUzVjYW1XZDlqSEUrclUz?=
 =?utf-8?Q?AKDhLLlXtTA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K040Z25SaHR2NU5hVnVHQ2lWcS93ek5EeHhQSUhkS29XaTEvNjJvRjFaWExL?=
 =?utf-8?B?clZkSmxINkMvUzQzM3I3a1p6WTlKSnJ5UFltVXZRdnYwYjhTK1pYcTZPVHFq?=
 =?utf-8?B?MHVyb3RjQkQzamdvR2orNFgxMkJUbCtVTzlOa3A5cXZEbnZVamUzczBHRFJ0?=
 =?utf-8?B?STltNVpsVGtRdGNicnpYU05xWHE2TWxSVlMzbjZlaFMzVXNQb2d0ZUUyc0tq?=
 =?utf-8?B?cHF4cnNDRkRySzIzTUlKYkNDbmhtUHdMZy8yMld2SmZzenRGb1EzczhheXAx?=
 =?utf-8?B?bEJ3N1ludDJXZko1dW9QS2lTWUd4ZFlMeG1RUHlocE4xUzFjTUE3MzNtU1VO?=
 =?utf-8?B?ZFpDeFBWS0Z2c01RYkZuYnZxRmlYKy9PRm03MVlxM1pOVElmd1B0RmZJMURL?=
 =?utf-8?B?eUlJYllpMEZaZjBIZnh1UnVna1lDSDhXYTFsQ1VacFA3UEtlNHk2eHFScHZo?=
 =?utf-8?B?SmNqejFNakt5Z1V6MWRhM3FMTmdJdkx1QlBpeDhtSTFPVmpKU1JrMHNzekhZ?=
 =?utf-8?B?ZEwzU0dXRVVUTGlWaWdHMjVScnlPZGhoeTkyWGEzNy9pVkxNMTZqa2FyL0JF?=
 =?utf-8?B?ajJrUUEvUkhlWmQrMm5RblBuSFVjVE56Q1dNRkRFVytwMzJWUXNCcnRvSVBl?=
 =?utf-8?B?ay9WZFRIWnZZeTVtbVRWZ3dUUnUySldqZTJUVnI4WDBGZGhyaVFLSmk3eTJx?=
 =?utf-8?B?WURZRThQNjBOZ1dRaEgveTJsZm1Gdm5MRVFCaFlJUWxrZno1MDFYUCs1RnZE?=
 =?utf-8?B?YUkyZHVVS2N2L2VsWlpIN3hqcHBhOFJNN1VwMWVESnBDbmk5NnNCb1dHdXdB?=
 =?utf-8?B?akNVT3FGUHdhRGpqMU1nenY0b1d0NTAwaXd3aDM5eWtuaVFUd01pWGZ4Z2k0?=
 =?utf-8?B?TjJEazROeWxTVi9iN3JvcHhiTys3elV0RmV2SnRZUFdpN3ZGRXhJcFM5TS94?=
 =?utf-8?B?VFI2bDc5LzZjMTdBOFE2b2JycVlIdTRBTGxvelVRN2JaYW1qRlBPSVVJeGNK?=
 =?utf-8?B?NFoxYUlnUWhKM05YZkNEeFVtcDJwV2RRMFV4TGY5REd4Tnk4ZHVySG1oQm9F?=
 =?utf-8?B?eUdVU1Y5NWFiVStMSWNvNy9mRHlxQzRjQnlhKzIzMXc1OXJBRVZibWdockM4?=
 =?utf-8?B?S1ZjOGNCZVZodkFUaFJCdzJTbTAyWFZNN29yMlNJWjRJZDBxMGh5ZUVxZ0FU?=
 =?utf-8?B?T0tzRG5uQUFlQ09RcXhvcDNvd3VmWWpOZ3RIMng1WEdIKzFhRUVXOEc2V3Qw?=
 =?utf-8?B?eEd6VkdDTlRQcmt2UTNnTGZUWitVL0MvR29RSkpoOWtydTlYdHZUc0FKSU9q?=
 =?utf-8?B?OFJFK0JqR0ZFak40V0JZbC9OUWVHU0hCcnhLRFUyN3Bpak90U2pkMThkTmNr?=
 =?utf-8?B?WWJQbWNDVmc3TWRRdGoveWczemVEamlzRWFzM2lZMjZONTNuYXExbDJaaWsy?=
 =?utf-8?B?SUZIbVkwbTlnWkZRRVd1bElnSVQrYjFZUTlRZ1FHdWhqK0VlV29pVWwzMDJn?=
 =?utf-8?B?V2NhK3IrYlBNdTdXS0svakE4LzByUmwrWWtqV3lmVy8xbnJVam9SaWRNTEhI?=
 =?utf-8?B?R1ZPMlJ0YitnY2wzeC94QldGWGdWbi9lQURvU29EZTZnRC9seW1LM0VUS0ds?=
 =?utf-8?B?QkhVRWQxalJ0bEV3OFhrNkhxelFRTHh4VWNmby9Rd3hwaXhTN2EveU9MUUpz?=
 =?utf-8?B?T2ZVV2g1SCtabEdnaFJ2Wk9HQzI0a3VtUmNtdC9PU1dsbWpYNkpVT2V2bXg2?=
 =?utf-8?B?R2dwK3lLSGVrdHl2YmZhTFoxVE1NTURtamxqbzlRUWViQmU5TFkxdzIxK3NK?=
 =?utf-8?B?ek00aHQ0NXpZR1VRbXZvWFFzZjQwSk9lMVYwYXN6TVZmRUtFUjJrbzZyU1Vv?=
 =?utf-8?B?WEkvMW5aYVA4VGdyQ1pNTGJzbUxoTWlJYmxid3hYb1djdC8xNjdvK1FUaHIx?=
 =?utf-8?B?M0J4YUNoN2locCs0WlpWSWsyQ1VlTXYxaDljOXdiTmhuc01vVm82TmFLZzhv?=
 =?utf-8?B?dzJMYmVUbTk2dEFPYjVielRGMk5iR0pDdm5Fb3V0NzJqUXJncGE2M1p2Ynhl?=
 =?utf-8?B?ekI0NUlrb2dsMWN4aHJXOU1MTUp5RUt6SWZoRFJicnlZeWgvUURkNEJ0anZJ?=
 =?utf-8?B?SUF6eEdZbkwxTXpOdnQ2eTJVYnRDMWZlU25BY210Snl3N24wOHpLbjBCekJN?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf13c01-1bfa-4833-411d-08dd9103bbcf
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 03:18:58.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VF4Abpuk45jNUuFZJshmEoSg4p6s5BtfqFY4P/eN/nbijyzGUB1BQ5Co77+OWuLWaAt5ppAVI5MalBKLZidwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4793
X-OriginatorOrg: intel.com



On 5/9/2025 5:03 PM, Baolu Lu wrote:
> On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
>> With the introduction of the RamBlockAttribute object to manage
>> RAMBlocks with guest_memfd and the implementation of
>> PrivateSharedManager interface to convey page conversion events, it is
>> more elegant to move attribute changes into a PrivateSharedListener.
>>
>> The PrivateSharedListener is reigstered/unregistered for each memory
>> region section during kvm_region_add/del(), and listeners are stored in
>> a CVMPrivateSharedListener list for easy management. The listener
>> handler performs attribute changes upon receiving notifications from
>> private_shared_manager_state_change() calls. With this change, the
>> state changes operations in kvm_convert_memory() can be removed.
>>
>> Note that after moving attribute changes into a listener, errors can be
>> returned in ram_block_attribute_notify_to_private() if attribute changes
>> fail in corner cases (e.g. -ENOMEM). Since there is currently no rollback
>> operation for the to_private case, an assert is used to prevent the
>> guest from continuing with a partially changed attribute state.
> 
> From the kernel IOMMU subsystem's perspective, this lack of rollback
> might not be a significant issue. Currently, converting memory pages
> from shared to private involves unpinning the pages and removing the
> mappings from the IOMMU page table, both of which are typically non-
> failing operations.
> 
> But, in the future, when it comes to partial conversions, there might be
> a cut operation before the VFIO unmap. The kernel IOMMU subsystem cannot
> guarantee an always-successful cut operation.

Indeed. cut_mapping could fail and in-place conversion path would
change, which makes the error handling more complicated in the future.

At present, the basic convert memory handling does it in the simplest
way, i.e. QEMU quit if failed, which puzzled me a little bit: Should I
follow this simplest thought to just return without rollback, or keep
the rollback logic in case the future change requires it. Maybe I can
move the rollback handling in a individual patch for ease of management.

> 
> Thanks,
> baolu


