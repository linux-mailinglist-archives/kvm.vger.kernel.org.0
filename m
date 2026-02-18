Return-Path: <kvm+bounces-71261-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHewONvxlWlTWwIAu9opvQ
	(envelope-from <kvm+bounces-71261-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 18:07:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 646C6158181
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 18:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 278FD301A53F
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1815334575D;
	Wed, 18 Feb 2026 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u/Kty0pb"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012028.outbound.protection.outlook.com [52.101.48.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D57233F389;
	Wed, 18 Feb 2026 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771434442; cv=fail; b=n0RvaDsdeZNon1U/ar/sfHVqeSxvrGZl/5ILeSeEegRskaqgLw5k5hFOfN7KMB3Jf2n/n1nR414LZTvaEzAKVDmjGZ4+XnZOWMWJkvyTZ5zKAoLu4sjtnyr+hoIHoCy1/sWVrCKBbDI6491EFedEAUw2znwCi97Ws3JKfROIZD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771434442; c=relaxed/simple;
	bh=K1vVwAt88kxvJZMhTfXyIjoRRcNBxTuZFrW1GFkcfqw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jqjw3GioqXMBry40eL4KVqTPbgR7W3Y9hc0Knbg3X0zOsfR1fUE/fcwR4Vsf7ApgZYHdnQ+EUg9kHgUl+MbcngRe6N4jlzzOcXN7I/Dp+nYz6a2JHTFJd3U+xMICSyiTu6UIqDZe1KrtgCf4IfYMyDFLbXNniZHC9JPT/hTcJLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u/Kty0pb; arc=fail smtp.client-ip=52.101.48.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAC67jvUYmPjcscdAp4yEdUVsP9WybnTWENssHjw5j/jK7vWhM0ODOr6I2I+l2Igrvg+C0oaVcNTmIAS0Zq10/8EKWKEzOJkOpUjcl3V7P4zhLkPKn3hGrnvBplt1OFOGeb1L0JfUjWD709FS+HzxU13GIh9daq/BQQgTleT+dtgIV1uqFprY/V8dbGdXD+pwPw3RDu48WA/EKOlH5A5z8Igi1xf1vmvdNDchaKufErAVFtA2t0EGO97c3OEzKDRlprYpWLwp/iAuvZ6RecQ3RlQVyb9DYk+qNn02q309iUOTtAcRosuAayCG4SXMqnotcOHShmpfibM+vIoj1I0zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWC3rkg1TVADeEMaF6Twi2RCCZdUzMN4EG5YLFzfweI=;
 b=ffz8ICMceNKAb1iSFWQjmUZ8i0rYao5MF8eVnpRW5htaSOjtf+5P+MAts3H5QlbgMImG04q4cViNYKoc96Eh1SSS3SrZ+NBI7UOyx8sHeLMKFFgz9vI8PHL0KBixhP2Ap6Mp/Aiav/Qjfpwc3gtzvOBDRSUcN+AaaUcN1G1e1cnwQVS5uTR/fFZ012Ut77pv3iE1d9LgFBZ05FKmkmhxSYNsGAxtAEKx0SITHI9J5ku/hzLwO6PNqyUYLd3pdUuLWUnFJKivPPCsR6/uhiAHzmP6R7GBKdMjUtfj6I2+ZCMwr8yYmLSg+dhKRQpMS8Hup/TyFPndtQa0HOglkofJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWC3rkg1TVADeEMaF6Twi2RCCZdUzMN4EG5YLFzfweI=;
 b=u/Kty0pbFrl6Re3WUmnM7GxQCVMb5GHnT37UUshB2oYjnhMYA8z7cv2Ma6B0D1ki3t/RnnkPjljDYgp03a60YALaq3MNYvsYeF5JZa5KjYqvR8FAtyRwevFHdn9yQQwwpxJj9xXSDqo649HSvL78u08G89gsHP1kS7j2LDR9DNA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by SJ1PR12MB6146.namprd12.prod.outlook.com (2603:10b6:a03:45b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 17:07:17 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 17:07:17 +0000
Message-ID: <e774a45a-c31d-4051-93f7-3848de539888@amd.com>
Date: Wed, 18 Feb 2026 11:07:13 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
To: Dave Hansen <dave.hansen@intel.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, jackyli@google.com,
 pgonda@google.com, rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
 <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
 <b860e5f4-4111-4de7-acc7-aec4a3f23908@amd.com>
 <59c0b0f0-26b0-4311-82a9-a5f8392ec4c6@intel.com>
 <4e912046-8ae0-4cb2-b2cb-11c754df7536@amd.com>
 <eaa17a3f-e481-49dc-8d7b-bd5247d3ed57@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <eaa17a3f-e481-49dc-8d7b-bd5247d3ed57@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0121.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::9) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|SJ1PR12MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a1d08ac-6fb5-4d3a-ec2d-08de6f102b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SldQWGVFekZBK2FxZ3dCSDhtYnJMMmc3WDlEcU94NUxobFFUZjBZYkt0QThn?=
 =?utf-8?B?OUZld0JTdmFlQmtvY3dMdmxoOTVUajRpbFU2My9XSFByYlNWQldPNWJPakVa?=
 =?utf-8?B?QmtuOUdWT0N6bWFpaGNlY1FlbkNPNExuOXNzUWJSWGlXSEwxWHpDamNMWE9r?=
 =?utf-8?B?MExVMXhBc2xYa3JDemFHWHFtV1drQjgySm1QeUVHdnkxZ3k1MlErdW1UNWFr?=
 =?utf-8?B?cEp4a1lDT3d1MndBU1RRV0p0bnhHaUtCcVFNaUhqdXJEMWJEamtJYjZUaTI2?=
 =?utf-8?B?UnVDMmJNMEtER0dEbmNFOGs0V3ZzVjRhUW5PTXdYSXFEbFpOQjlkVnRKYzAx?=
 =?utf-8?B?MFd4V0lZRlRyajBhL2plUGZWUVRXaEtWVmI3UTkzRU83Zm1GSU1CSy9uYjZk?=
 =?utf-8?B?MzJmUUFORHFnVU5pL2ZLUUNMeThwbFZKbjFmTU9xU2VUWE5JRklvRjJUSStU?=
 =?utf-8?B?eHlPdHF3TG9NNEYvdExRVWlnTzBORzBzNnZDRXJBbERSS2hldHk4bjQ1YUd3?=
 =?utf-8?B?TlhvbllEWm9uSFYwekE2TmNHRGJpN25UOWI0eVQwY2VUTDZ5MzFrSHFna1da?=
 =?utf-8?B?UTJSdEtMQUMzcVJRYVR5Vy9jQ20yNkpXNEhJS244YlhNYVZVV21JSjlhYmNO?=
 =?utf-8?B?UU56MFZXNmZGWE5KaGVlTjZ0RWxGTUgwSnZpSUQvVzVaeVMwOE9qY1ZLMHpJ?=
 =?utf-8?B?UHQzd2xhaTFVMEphMFE4ZmdQSUVzZ0c1RXZHTHI2Ukc2REdreVNZWnFyY0FG?=
 =?utf-8?B?amkwdC9BSngyaC9yeXBFdk5ybWN3TzJlWGNnaXpZZGhuT082ak1PWDgxZzNV?=
 =?utf-8?B?TEFOVHpBZlZqMlhtd1VIZHkxL25rNGliNEs2akFPOWZ0dmF3QXVCd09OYVZo?=
 =?utf-8?B?S0JKcmJPcXdsSzRnTHNsMFU5c3plcDZEdXlLVmZPSmkzV1UrcElKaVdzcy9k?=
 =?utf-8?B?Vjl6SjZ4WER3MlVzd0NYd1ZLVG52SUcrdHZDRldZNFh4K28wSlFJbklib3BT?=
 =?utf-8?B?aHRoNEExbm9BMWRjUGhzTkl2dnJIWUNCOFk4Qk9aVUkvVlhISzg0SUpaWEt0?=
 =?utf-8?B?WFVmQ2tuTmE1TDNxa0dYbDl5akJlRm91MHJuL3pFRGpPMUNzcExQUmM5THIz?=
 =?utf-8?B?RDE2T2JGWFh3a1p4aTVYc2hBdVNCRUJ5N0VZNnBLSHdUdE94QnI1ekUvVElw?=
 =?utf-8?B?Q0dJOFVWOTBYa2w3TkFiVXp1Z3phdkR0aFB4SW5GTk9JRVJUdXdzVkZRRk14?=
 =?utf-8?B?VzlCdTRwclA3UW4zMnZCSHJJSXpNVTNCRVovSHFuTFJBRjdnMmdSRGdMeXhH?=
 =?utf-8?B?YUk2OWZqWFRpb21RajQwZGVMdjVsL0dOM1oyUlpUNUJNVko1dmJRS1JpSXM0?=
 =?utf-8?B?SmxHMkgwOHdkd0g4MGNWQXBXQnAycW9WWDF4ZVl6T1JRZTQ0Yml0cHdHN0l1?=
 =?utf-8?B?cTdXMDBCeW1EREM1SkpuT1JyYVY3ajl1U3o1OVlEN2N0QW1sMlFsRGRyU3RB?=
 =?utf-8?B?ZmIyeGZCUitYaXpLd3NZV3U3UElIOGUzOVNTNUUrM2RPWFhyWERPNHRhZWNG?=
 =?utf-8?B?T2RYdVBydkdGbkVaNlBXM1hoUmppNy9IS3hhblJrZWZEVzBCT0dEdUFwTGg2?=
 =?utf-8?B?RlltUTJCYzRpUTZiSWFGZjhSRHIwdE9TTUFOQ2FSMU1BSjFrVndCamJCUVRF?=
 =?utf-8?B?Nk16eVczUDAxeTQweDNTa2phUWptS2JTU1ZwS2M0RlREbk9KSk9RMThuZG0x?=
 =?utf-8?B?Vy9WN1k5a1BuOGgxZytVMk12WFhzdEhzTFozUGtTSUhOQjFWMmFHWnNLWndV?=
 =?utf-8?B?TWk5WmdUSCtsNVBlak1Vb3NFR3l3Kzk4SkpPYVpEcG1Iby9ZUFhHemhzeldU?=
 =?utf-8?B?Smh3eUFIeVY1bE9hQS93RVF5YzJ4bHVEUlJKaXhvZHlrWDU3b2N1UXYvMU5v?=
 =?utf-8?B?T3JjN084Yk5YSy80R2IrQ3lSZkFvd3dCZ0MyN0RoZ3ZoR0UxRVg1TU54LzNP?=
 =?utf-8?B?SmRzd3U1UnpGaUtWS1hZdlF2VmR2Z3A4RHV4UkJpR1ZLeG0rSGM0bHNMbnRa?=
 =?utf-8?B?VlZ2NlRWZ0U4cFZ0WG9ZQzE4OEJKVHVET0l3emhWTjBOU2REbUR4bTJkSlIv?=
 =?utf-8?B?Z0tiTlJtZmd0OXBiL0pyK2dxNWt0Z0dhZ0U1ZmQ4VkFEbDdhcHUrRG5Wa2hQ?=
 =?utf-8?B?L2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2t2ZkwvTWszUndlcERkUDFrVm51MGZIWHpkZlg1Z0xjN2wxR2tldFllQ1VR?=
 =?utf-8?B?aE43dldrcGVJSDFZVzBCdFAzSHlTQ0h1ZFBGVzZMN05GeVBINytIMlJ0NTU4?=
 =?utf-8?B?SktTY0VxMk9ERUJnTThJSmR5YStqY0xHcGdzUnROYXRHMFNSeXl3K1pmemJn?=
 =?utf-8?B?amZhYnZ2dVN0VVRQQkRLaTFUcHpNc3ArQi85cUZQMjc5YjFVeWFGbEhqd3A3?=
 =?utf-8?B?Q0FpckxPNDk4TFA5U1RhUHVBbE1DOWxzazZtYm94SzdlRWUwQlprNG9jVkRj?=
 =?utf-8?B?ZUlUS1Z0dFhpSXhhR0pyYTRXanlTV2NhdWd2QmZqak1ObmFTcmh0ZUVwaXc1?=
 =?utf-8?B?dzE0N005YW1rNXQ3YU4rUnlaaEE1Nnd1ZkRIQlZmTmZwTzVaMFdJc2d3OTgw?=
 =?utf-8?B?blZuMUFYUHc2SnNqMHJhRU94b1RpSUowUjNPTzk3VmVja2JteTV1VW5JeGtJ?=
 =?utf-8?B?RHpYNFFKL0JXcFNpdXJhQjdlODIzcEZKYmthVzBPZ29oSno5RzIzL3ViRzFn?=
 =?utf-8?B?djY3WDQ4NDJ2d3FqNmZka2Y5NDNhUVU0ZUhZV3hEUTVzNHd3S1NIWko2cnNx?=
 =?utf-8?B?ek9ia0l0ekc2c29YRHNZWjZFOFd5MVUzeFE3WmxmU2VPWUQzNWt3Z3lBSkJT?=
 =?utf-8?B?Q244em9pUFFBKzBmUTRubGlFRnVaWTBGSzBRWS9wMWx3b1pVR0ViMndIU0U0?=
 =?utf-8?B?MEc0NVdlSGFNTWE5UHBRUjZ4czdNOWJnbG5RWWN6UHZCMU9TWFVWWTdZc1Vs?=
 =?utf-8?B?RXpnblJ4RVp1VTRudHZzaU5DSjFnRzE4OGx5QUdna2NtWUNHOW9CaVpndUM3?=
 =?utf-8?B?MHR0N2NQRnBRRlJtenR6dDhOaTBzYjRieHRjSG9XZ3Z2YXJYSEdQdXRFcGw2?=
 =?utf-8?B?ZTV1bjE5dkh6M3FTWWJFUFlNRlFMdHM2NURKMENHNFo0RDdUK2Z4U2F1TGp3?=
 =?utf-8?B?U0ZINEtwbFMwcysyMFA0RXlUWSt1Q04wdHd0SlRTSmlxMmFOVUZLbmNoZjJS?=
 =?utf-8?B?clpFVTFkWWVJNE45VG5nTS9WSEFFc3hTNWNYUmpySjJVUjBEMXlOajRKUnRJ?=
 =?utf-8?B?Uy92cU5rdDdLd3NLME5CRkRIYTAwYVlTQmlTeis4Q1RQcUdVY2JRZkhVTDhO?=
 =?utf-8?B?M3RpcS94Mlo5eFNYci8yaW53dVRoV2FsMFk2dFYxSWEwUXV5ME5QQ2x3emhl?=
 =?utf-8?B?UHp1eGJlUGsyQ1ZmcEU0WkVOYVE3aGRMdzFKRFVpaE1NcFNXUEZRS2NYWWtv?=
 =?utf-8?B?d1hNRGZ1Y09UM1FOam9NK0RFV3JtRjdzK1gvYytCRzRCSWhYMk5BY0IxWmk3?=
 =?utf-8?B?eVRCaG4wbGpmaXNYd29UVGVndks3ZUxRMnJURlFXNkwwOUg5SERIQnl0bmhR?=
 =?utf-8?B?VnRLc1hpSTAvYkd2NUlNampBOCtqdU5YajhSWnFIdHA1OFh3TGRuYk5WZmhj?=
 =?utf-8?B?WXV1TElLU1RvWDBRMTc5S3gwbkcwUmxiam9yZEJFNXlCM1JDZGZ2NFQrTStR?=
 =?utf-8?B?MXZsc21Iamx2MjZra2pUanhhL1FpR055amJhUzd3WDFMdXhWSytaSlVaMG5a?=
 =?utf-8?B?WjhCdVlHNUtIZmpmdXZYQ0d1eExJbkRxWG52ZlUremNodU0yOU9VeW9ua1k0?=
 =?utf-8?B?dklrZUUzaEpQeXhFMFhIeUxDZWpPYjlMUXdtS0JJbUlQeHJUVVhGK003MDdW?=
 =?utf-8?B?bHAyeldJNzFNS0VKSHlNSzhVY24xWVNFUVErd3N4ZzBQNnRIQkJvM0QvVVA1?=
 =?utf-8?B?eUNUZGdHVnFUQ0kyRmFUcFVJVnpHUGZ4MXFJenM4cXdVNFRSUjk3N2NPOURq?=
 =?utf-8?B?alNFNVlGV1paYlJHcDg0VnhiWHUxZENqZWc5aGtJd082ODZGQmI0aGJJUjA5?=
 =?utf-8?B?R2xtNSs5QzJuT2kxWEZ5Nzk0Z2RJSVVpM2hYWHc0QVU1ak53cWl4VnJPa05C?=
 =?utf-8?B?Z21FYXpPMWFJcXMwTnJoME5ZNG1UZ0lySDIwV2VuNUZ4NWNzOTlLYzJOYTFU?=
 =?utf-8?B?TlU5SWVMYjVoekxVaE5zMlpJcEd5QVYwdUpHUHFnRGJ0aXo3YWY3YzkyQU1I?=
 =?utf-8?B?c1BCVENNdFRWQ0dFVUNiY3FGcEhYWktLNzNOZmt6cDJ1QlY4N2c4R3NwN01W?=
 =?utf-8?B?Uk9EdUFDRlNjM0RHZDBDMGYrNVo5Q2w1aXBzR2s0S2FYRzdVd016cnJTejda?=
 =?utf-8?B?YmJubmdJUTlmRUlrUG5kSk9vS2VKbWlWdnlQOEt0L2VacXJoWGRoWm9HTnVU?=
 =?utf-8?B?b2hwOVFNU0s1cE9QWXBzcWtZQkVmSWNFRjgyTlZjbGxpVldrZmFhYkZGbnVz?=
 =?utf-8?B?U09ncloyTVh4LzZDTVp0VU43MTFvL3FLQjJBUFRlenV5M1MyZFUzQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1d08ac-6fb5-4d3a-ec2d-08de6f102b09
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 17:07:16.8496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5tu4Dch26SXeN1Ib5ft3cpbjhRh6AQkcD4TL8A7z1MOJRYv4pP6Qi98p3HZYOOkeQ7Vp4K6NFRc491/YL7MhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6146
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71261-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 646C6158181
X-Rspamd-Action: no action


On 2/18/2026 11:01 AM, Dave Hansen wrote:
> On 2/18/26 08:55, Kalra, Ashish wrote:
>> Because, setting RMPOPT_BASE MSR (which is a per-core MSR) and
>> RMPOPT instruction need to be issued on only one thread per core. If
>> the primary thread is offlined and secondary thread is not
>> considered, we will miss/skip setting either the RMPOPT_BASE MSR or
>> not issuing the RMPOPT instruction for that physical CPU, which
>> means no RMP optimizations enabled for that physical CPU.
> What is the harm of issuing it twice per core?

Why to issue it if we can avoid it.

It is not that complex to setup a cpumask containing the online primary
or secondary thread and then issue the RMPOPT instruction only once per
thread.

Thanks,
Ashish 

