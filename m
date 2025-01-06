Return-Path: <kvm+bounces-34576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E14A01E76
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 05:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BBED3A21B5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 04:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E846F16F8E9;
	Mon,  6 Jan 2025 04:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="32O+SCqi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F654AD24;
	Mon,  6 Jan 2025 04:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736136902; cv=fail; b=nkSx8ezO1XLXdG2h/W0aUGZEQqbCF/17XpgHorY68mo6svaLT+TUBulY/N0vHXwxybVR+Jdql1dRnp/osPcvJGOGY6dmNTyvxrmYioyMPNz17JEbZbqQDEWMdofJHfJJF4CZTV+B70u4v2hDU6ow8lquDMp4IcLVedj7w3EqnY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736136902; c=relaxed/simple;
	bh=JNiJtGMFx0SNu397Ut8OwDjlJA5SQjEj++gtp6Ogakc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h+Y3ngp2UcfgTDqMtJi8W8iBjL6IPT/tZ80nsrCF5eaNd+BWszjRoaM1yt5BPrDSQ6tAUp9X5T8H26g/GxmPA5i5lKKlYGke+eTyqFMTEvgMOD6WgtTkl0w1ekgLcZE20vxX7hILgEAigN0HzxQfaRhIIh/R2Ap5ilQGUooehBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=32O+SCqi; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxOwC0+UXjo0UkJwbjuYFj2al9VcTwLiicITcj4wN6ePpCJDN2Y+qR+aRd3AieOUFA/UZTERzjxhcdT1X9jqR0Q/TJE/96eo0J5JWjeZe5p2qr/nX9dwCRQcBQLrSOvuzDAF8ldsSZdqULaEMyr7Q+3qAxq30URXdOBP4+yLqLwagGvPrzni3EFw16kRgz5p2lZRG/yW779F/Dz927TlriNxPIKnD5KQcGs5GoLMRu8ge6dRCTiyEbHhLYf5UdbuF2WcBDRSLvGshn3eZ06GgjWStAKdDYBKKrla6pFNby/SIWfZoLcQglQV95CxKVLlhhwiOkmEAncj/VnfttSfLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wLWmBsRY+lWF9V2ymThM783in9f0kjoW35owu8HcZw=;
 b=GTWxQTwVc3Y0/mFkRzToBJ04vfzQBXrpjGuNFk1jLQHfVGhSaareXrFaXfwCqtwGDNLlTH2ptW1n943Ng1Uio+VMaxOssCyAtP7oc3q2ZXscoelwx/D9pic06bue75icAFvFM/2oBq8lEhsmq8NOOwYsGR+s2r6RMv7I2NBJl+ByD58GFoW+vVbeUkTgqWYtHklkSy7Ax4Hqx41W43joyB1qphDjCt+INwPMyS93BBGzhwqgqPn0fO3vwfaF1Io3tl4hQybYAq2HsUq5CqonYySvEqHVRp3goOl9QDsBnjW+vmV4jNzmQfd3Mz3T7CDkRPfflA995CYfrHVZiMWZXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wLWmBsRY+lWF9V2ymThM783in9f0kjoW35owu8HcZw=;
 b=32O+SCqiiyr8EWhCU4Py1IBkmN99KVvkVGQlrcX/YrxDRld1wRyxuIiVNdGx4Rxnl/L3QJZCEM/43Du2WvvWpEN3Zx6uH/zMZ46vQSQjM0Dsc+SnnSud/6TJ0Cgn3ackmd27sNtDOAms90Z3MOdJ0glJQBf2fWOxaDy461wLPQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 04:14:53 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 04:14:53 +0000
Message-ID: <8bc77e37-56e4-45be-9038-6ed1bd21c33f@amd.com>
Date: Mon, 6 Jan 2025 09:44:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 pgonda@google.com, seanjc@google.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, x86@kernel.org
References: <4c49a713c6c13fc0faef039ab5ef6b38090c20f6.camel@gmail.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <4c49a713c6c13fc0faef039ab5ef6b38090c20f6.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0001.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN0PR12MB5859:EE_
X-MS-Office365-Filtering-Correlation-Id: 7464837d-d9dc-4e94-9f55-08dd2e08ab4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Slphc1RlenpLaWJ2eW1EOFRuRVJEZjhvdjZwZ0k3Yk1hV2YvZ3hNQVFlTCt2?=
 =?utf-8?B?NnNRYXVRMW1RYjVQTWR4SXNHcGF4VXo4UEVoZFNISW04dC9lcHFGVHFka1hD?=
 =?utf-8?B?anE5bTNWT1VEVlFFaHVpZVpGUDlxeGcreFNtZmVHTlUxVXFmcUtmMVdNc0Jk?=
 =?utf-8?B?eWJ6QVR6WUsxTFJTWDF1UExybGZYeEI4RWJBcytUR0hlaGNqaGVnV0poNzJW?=
 =?utf-8?B?Qjh2MWJKSjFMaktoMDE3dWZpTTFuUUcvRVJPNnJwUUdZS3RIZEU1QzZoZml4?=
 =?utf-8?B?RWJNTC9qZ1RwdUZ6LzRSTHdDM0lzbWdIWGNkY0ZWTXBYN1FVcUhLRy9rM2FV?=
 =?utf-8?B?ZG1vUGVJdVVPTWJpUkIzWGR0ZllwSnBlamlzNVpHcG5ZTkNQY3ZVMXVZcFF2?=
 =?utf-8?B?emNuQWdpaW95YndCRUliQmh3RnJ6RHVIL1MyN05NVzBCeTd6UkZCbVduLzQx?=
 =?utf-8?B?d3k1ZHU4Wk4zeE1iSGY0bW1rUGVFV0V5R21xN284NGZocm5GZ3FhbWJYRmdU?=
 =?utf-8?B?ajFUTWIyQkNHK2lyaThRTjJlaUd5eUpGL3REbUNvS1NJdDZNZ1p4Y2VDZFha?=
 =?utf-8?B?T29VY0JKNlRSNXk3QjJaUEJWcCtyMnZ0MmhwMmxFbFRDelZmS2R3NW96VDVY?=
 =?utf-8?B?MkJBMmovajBhTXpFMnk5WFRhMTllQTFPZmVWR3dXQ1NRejZjeGphVXdFNng4?=
 =?utf-8?B?TElKSXBOYnl0QmRqVXRsNnUzZGhEMlpaZ2I0bkFSczJNVUtFRDhFZjBVQVhI?=
 =?utf-8?B?dXkyT1hxSitLRmE0ZnUwNDRlQ3lhcFZFbEc2TDRJWTJyaVN6cjVMbEF4Q2pP?=
 =?utf-8?B?cURLUlJ4eVZ3eHRCVzJ6QlFBL3ZFWlI5R282dUx1RG9vcE1sU05CSnRjMkVl?=
 =?utf-8?B?L0Jtb3RVWTZjN2dzUDVwcmtEZ2ZyeWQydXBidzIvaE1LVEgvdElYM2Y4a0l4?=
 =?utf-8?B?TXNoSS9zN0NKT0lsSWZJWk11OG41dGptQ0R6Tko2UVpDY3Vjc0xHeHRad0xI?=
 =?utf-8?B?TTUrTDFvNS9TN3RoWS9GZnJyMzZiRFY1L2cwZ0UxVVowZDQwRDFVdHVoU2c5?=
 =?utf-8?B?QStrWG9PdjFjc0RlZTRxR0JJMHZhblBXVjdFcG9Id2RBdlBZdldLa3gyZkdi?=
 =?utf-8?B?SktCYkRTRU8xYjhmbFlsMmcxRnRBN3NtbmdCeFdUTmxjaFh1b0JkSE5uWmFa?=
 =?utf-8?B?cDBwTk9rSWltaEV6S09CV2s2ZlprR005WTZQalVpaDVNRHgzTDA4ZWdiQno5?=
 =?utf-8?B?bWdFc24xcVFYVjBsN2UrMWVZLzFGNklmSDlQZVptSE1qNVltNTRYN2ZwU1dQ?=
 =?utf-8?B?czJ2T2ZCazEwMWc4U2R1MVMxaCtMNHpkZ2JOVGhEVVJFWFUwWFBvOGJNRDNi?=
 =?utf-8?B?VndRVVNaVnNOQit4QVpGRGZwK3RsNnZYRmI3V0w2MWU1NFhIWll2V1g4YUZp?=
 =?utf-8?B?VWk5Rjh0alM1WFFBcVhMUXR4b2RRYjkrVjVWengxWVlTaHBhWTEySFd5d0Er?=
 =?utf-8?B?R0hxLzF6eWFSVFluRE41WjFESDhlK2tQMkN2Q0FWWVFOUnFVam1MUjFhMS9H?=
 =?utf-8?B?MVNTcDBLRWpxNkJaSStzQk04NlpTa1FPcHVLMjYrSDE1VTEyUkZteStBOHcw?=
 =?utf-8?B?d1lVS01xNG5BeDE1Q0xPT25RQjJVdDJRQ1BadWdGUU01RlI5SUxnRW5GY2RU?=
 =?utf-8?B?Q0kwZEhuSXJuYmNQa2NwOXBVTzV2S2diUThob0dZWWk3RzhFbmRNUnhFTmxF?=
 =?utf-8?B?S2s5VzlrN0dsTVY3RU1UeEZzNldZZ1FsMUdFMEZIcFVsMVdIaHl6dWJNQWlT?=
 =?utf-8?B?b2hpeUt6NURvRithYkUwZWFJeXM0Y0VxWlRBSFF0QTM2MDhtVTdycTQ4WFg0?=
 =?utf-8?Q?vI66Sfjbgm94/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnNUdkc1dzdPdjE5Qlluc2Jyd1N2MHM3Zko3aHc1Y0dndFlNUTJ0M25YY2lt?=
 =?utf-8?B?VmJ1NEtVanZHN0JCajN5VmJ4VjlRWUR3WXRUOThNR1ZoVWFFMHYzaElXcFRs?=
 =?utf-8?B?ZFVDR0cyQVYvcFRZY1hEVjNxbG0zY0x0N0p6RXl3c2MzT3JyOTd6cTRWUWpU?=
 =?utf-8?B?Q1JqclZZZWNCVThna2luZUpZOHRacHdnMit2TWlNT1FuTlYyRk5NZ3BwRit3?=
 =?utf-8?B?Ly9IQ2t1akZoRjJncUhyTldWZEtvNlhMRzFYeWlBa256L2lTayt1ZmJubm0z?=
 =?utf-8?B?NVFCT0Y4aGxYTEZ2aTZNRDhzTzR5NVBZQlpzVWUzRjNVQlNPRGdkY0VZRDNa?=
 =?utf-8?B?Kys5aHlCQ2ZSR21SVFdUdW0xVVFqSkpkS1oyTFMwOU04R2szcGcvOTZDOGMv?=
 =?utf-8?B?cGd6R0VtWnhUVzg1TEdDdnh4TC9wQVRyRU1BeFZzNERPb3B5bEUwQ3Z6d0dn?=
 =?utf-8?B?ME82TElpQVNUenRQUmVhZW9zVmFQbEl2dUMyWmF2YldhUmYwVEd5ZUpIV1p6?=
 =?utf-8?B?QzFTWFZuaG8wc1lnQ2h5VWwya0FlVHVuY2MxVnZHN1FSd1NOT0ZlclpZcXA3?=
 =?utf-8?B?dFdGZmxXUG5zRXNxTkpxS0xrelgrM1lxODFibkpzWEw5ZHRRclYvalN0aTNF?=
 =?utf-8?B?K3AwNkozQVZocVIrejhQOG12M1IrWXpJajFjMnRmUm1WNm5jbWpGMk1UVE5V?=
 =?utf-8?B?ck5UcWVVQ01vMmo4eXBadjYxRHB0VkhhTWxPTVQveFhuczFtc1VrM2Z2TTRY?=
 =?utf-8?B?UTBBR2ZsVmVGMGcxRURSTEJHbE1BZ0dJd05RSTRrZGJuYU5JYUc3SWVlR0d5?=
 =?utf-8?B?Nk5WNnpNZXNvVWl4T2UrTWNDZkhramJyT3JvRUF0dlFsaHZCdUFYdWJIOExs?=
 =?utf-8?B?cWxrV3FILzNvUnBNM2FBSnpoQXVvdUpmYVBMbFREQi9uZHlTK09MYjgxYXg1?=
 =?utf-8?B?ekF4OXc2anRUUktuUmtOZ2JVODFZSTByckl5UDV5cDhiVVN0U2svK29CaWNy?=
 =?utf-8?B?cVJIYld5Rk5HOXhVM2IybmVzeGtDdEx5OStXYWlwOWxPN25heDREbElXOTNO?=
 =?utf-8?B?d01JWmdDSzBMNThZb0h5aHZXUlpLQmhIOFNWQ2lseFVWSGQ4dk9vRjc1akRm?=
 =?utf-8?B?enZ4SmlRRFJ4UTRFRm9rc2NpYmdpeUZXbzJ5L21XR21DWHh2NFdoN3pYWDdJ?=
 =?utf-8?B?V1ZOQkpDcThqOTVKK0RFYnBiUmx6WnRmNVh5MGlrWmU0U1UxYUMwNlRLckVW?=
 =?utf-8?B?em9zaSsycENzNXU3cStvZ2hSTlFGVXg2NEdMMXpQcW9ITmZGYk4rSWdHU0Rl?=
 =?utf-8?B?TlJvSFhRRWRjS2xRUkRNV21YVVdiaHRLQjMrWDJXSUpvaTduV0NoaG1HdStj?=
 =?utf-8?B?TXlJZlRCS1dsSy9uM1ZUeStwcnpubVJidHArMU05U0k4L0VLVlA0NGo3VStS?=
 =?utf-8?B?YVlxSDNic1JIVFNsT1Z6bS9qVENkVW1raFB1UlhHNkErajVIOUVDdEJ5eGFO?=
 =?utf-8?B?OWF4bi9sTU1hdTZHSEQvTWNxR3JCak9PUHFlUlU0djlKYXVoMkdYVXYvMDVk?=
 =?utf-8?B?dlErRVNqOFJKZ1lkSGMvTEpqbXRCSXZZR3owaUpJSWdQc0tDenFWbE5wWWY2?=
 =?utf-8?B?OEVRZlJJeXpES05rSFcrWHJrSXM4bVpncHUwYURDaFp2bXo1ck1tRG1oNG5U?=
 =?utf-8?B?RE5TUmNocm9PWVI0R3dtTlR3MzMveVNCSU1yMEpkMzEwZFExUWZyMFdiUEJ3?=
 =?utf-8?B?UllzRHVsaVVURDZIOWFZYiswVGEzU25LMEIxTWRybkxRalhJN3dXTEUvSHJS?=
 =?utf-8?B?c1Y1bkZYY2JWb2o1eS9rQzVjMmRja09XblBXYlhrUU9xeFFFZ3hGK2JneFNK?=
 =?utf-8?B?NGtpOElBR3dSV1hSTEtReitodGxkWVFhUVBTd0JxZTk4QlFqQlhBblI4TUVE?=
 =?utf-8?B?R0hKSURaakNuNGJwL20xWGNtekx0RFFSaWphUmUyNWhoQWczeDFjUTJJMHVs?=
 =?utf-8?B?TmtKR2t3aDZWcEZRNk1FWHNnWitDMG1wdHU2d1lkQXEyQUhVYXd5UEZaVTNN?=
 =?utf-8?B?aEJFbmRUZE1CdmZSWWhmeUs5Z2MyVkVaK1NsVlRCd2FjcnVVb1FJaXhuTUQz?=
 =?utf-8?Q?fG2euU9WP90izBqFkMFQK36FG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7464837d-d9dc-4e94-9f55-08dd2e08ab4a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 04:14:52.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aW43kc04hcWWeibDPFIzhv0y+varuVdfs4nkR2vs/H952oip2TcGLWnfXalbtAK73ko1ccCg734T5XsJZTGgug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5859



On 1/5/2025 12:36 AM, Francesco Lavra wrote:
> On 2024-12-03 at 9:00, Nikunj A Dadhania wrote:
> 
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index c5b0148b8c0a..3cc741eefd06 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
> ...
>> +void snp_msg_free(struct snp_msg_desc *mdesc)
>> +{
>> +	if (!mdesc)
>> +		return;
>> +
>> +	mdesc->vmpck = NULL;
>> +	mdesc->os_area_msg_seqno = NULL;
>> +	kfree(mdesc->ctx);
>> +
>> +	free_shared_pages(mdesc->response, sizeof(struct
>> snp_guest_msg));
>> +	free_shared_pages(mdesc->request, sizeof(struct
>> snp_guest_msg));
>> +	iounmap((__force void __iomem *)mdesc->secrets);
>> +	kfree(mdesc);
> 
> This is leaking mdesc->certs_data.

Ack, will fix in the next version.

Regards
Nikunj


