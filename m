Return-Path: <kvm+bounces-45707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E026AADD8A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 13:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC6C34C0BC7
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 11:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AD3233727;
	Wed,  7 May 2025 11:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fyCNaDnJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C831C07C4;
	Wed,  7 May 2025 11:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746618001; cv=fail; b=LV14zcgy/BE5gz9fhFpK6M2ZuQmH6CTGIjD/l45qTIV+XIy86CzIaxmRr3vOCK2ml3YP1SfDxFqzjmiEH46tJz9uNH6B3y8VBkZLv2pkFHzLezI4R6rIvH5c9z5qhbk8b1SQJJFDuhFFiHDTiTltHqYy9zXNV0oVJ812vpYXCKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746618001; c=relaxed/simple;
	bh=LKh1cM4hxyT9zp/fqbVu8nB/YSn35sV8DoE9SQFwK3w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WwJ+aANsCQtqjEyGMC/I69lGvJ7nwwi3vClkm15EwyzGByquvzSHZveaPv108+913NN5X9WnfQ9RdGVffCFZsylVGiBP8fHi0ru8Mn0Cy+8q1lRvMORe+grF65e70RmWFfS26V6WSgWpzlPOakEooRqmSVBT/wj4Z1ssM9OxTec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fyCNaDnJ; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KogdxJxmTAgE+GW86mnO0lgWrIH7sUjVe4Tk6ZyQ/umSJPr7dQYDSq4LV7XR+AbUlupWBRGq3ewmLdlVWIN+8ME1srIKMvCZUZRslE7Q9qv06fFAh5V1ExSWNFZYlBvwHlpka8KKKpjBfyNi7wbGXkqr8kOmSSAyRfP/GRTDmZvlegQPyxXorCKC4LdALiILwKlj8u3fwHW7QpEJMjBzsMxneuf98ao2ss1lqy3GA4s4C4FvaONOWMGBCgOePLZGdYtZaauq3RE2K7Lxf7dt0qkhedX5OkFbSHBCKDQH9vlaCezJYWemDQ4a5zish69BKmkFTlxatooA2Vjh1RbbMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2Jzn5o0h8OJN8xpeUskC10vcHVr9yFoAgmNeX3FHuE=;
 b=uk8cKAEth+GNcEq0QxhksWGYUjOToQTgNFUV/EpGgGpnyAGDg//Xa/BfMEML2yoiwdgwZdxuXdHbGDKsECP8X9uq/pgLBXOr5BrBKyD0NTKsvjoEkYBUXtKwocTuz8X2XkeJyU7Q9MrqkFEzK/DbkMKN72+gLMEZ8ibTETFr3T0uk6HpieaYFYOzH2uJNGMwUxe7Jw2SYjAjiHG704Vp3checxR3ACdecFa//yjdoKkGzJDEP9+Br98O5aWAIqkZg7VzvuZovd/tW7M/Rsy1cRXAltStHrvd+wOy2tSuh+6uq3vM3B6pCsJz3MxmjIOlEIp5XH5fK1Sv/Eraicn/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2Jzn5o0h8OJN8xpeUskC10vcHVr9yFoAgmNeX3FHuE=;
 b=fyCNaDnJEUVtcGNcVxZlC1hrN/UT5m+Pd+aCUFNbQKc9eCB6VJHwE6yDasiI4jahfXu1Faclimij5Vu+vORCQQ6mAUkzASWlacf3uTFMGrJ4mM4tecbjmnDApbmVM9DSIBUqpF1/iTyYEoR9eupzQhR6zjuRZe9Sn0+VrJkGms4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM6PR12MB4452.namprd12.prod.outlook.com (2603:10b6:5:2a4::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.21; Wed, 7 May 2025 11:39:51 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%6]) with mapi id 15.20.8699.024; Wed, 7 May 2025
 11:39:51 +0000
Message-ID: <83dbcf46-642a-48fa-b9e5-6d163f0dda35@amd.com>
Date: Wed, 7 May 2025 17:09:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a common
 header
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
 <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
 <aBDlVF4qXeUltuju@google.com> <62ae9c91-b62e-4bf9-8cf2-e68ddd0a1487@amd.com>
 <20250507103821.GOaBs4HVnMXOdzOo_y@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250507103821.GOaBs4HVnMXOdzOo_y@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0148.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::10) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM6PR12MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: dc154c17-40a5-428c-7dcd-08dd8d5be104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlR5QTlpVFpuNFJ0dTlGS2psMGd6T1V1RlB0TEgyTENKSnQvaUZ0aE1uUDN2?=
 =?utf-8?B?SUY3VGhrOExIRElIczB0R1B0UmNnOFRTdC9YY1NzVk8vLytVS2x2KzZ1UW84?=
 =?utf-8?B?QThkVHZ3MC8rQjBUa0E0MUFWbk9XU2JKNzI4TnNIS1JIQVY2dlVjMTJJY1hS?=
 =?utf-8?B?TS9iTHRjd2lFclVpMWhUM1MzREpOSmd1ZE41RDVibzc0WlU5VEdqai9JMFMv?=
 =?utf-8?B?eWdpMHB2NFdkMlBUT0RLUTJQRHVqdUliVEVDaWxETUVsVkdpeXB2b0xycitv?=
 =?utf-8?B?OHBLbGpTcFN3RTMrZTlkYzZWeDZLbkMzbjgvM1BDY3NuZDZSRko3MkxNVnBQ?=
 =?utf-8?B?RERKUHJpejdKbXM0bXVPelkxOWtnbTlzMnFSbkMzcUp0ZW5aZWFOMXdYU2tV?=
 =?utf-8?B?YmNCakRaSHNjS0t0anhYUFpZdnR5SllDczA2MGhBUjVtN21HMnRSeHpscDht?=
 =?utf-8?B?KzFacy9oZDBVZ3dxdVRvUmdsNGlhdmRWVG54RHpTTmowZXFSRnZXWCtxUUdH?=
 =?utf-8?B?VTYxMmVhZXVqVmJ1THhWa3R0YTR4dnNla2JVai9tNjVZMWpGUGkzeWtVamlW?=
 =?utf-8?B?am9HRlA0QlQwaVlURnJYMWxaQnUvTm5FY2E3RUJjSmdybGY0NDl2VXh0d29X?=
 =?utf-8?B?MVNTbG8wQXNQSVlDSWVDdGVwb1J3QUFtbVNmRHliL0FoR0NZTHlrd2IvYzhv?=
 =?utf-8?B?eVYvUDc4SndFQnFVbVc3bUpoSFdMemhaQXdXdWx0VWczcmxLamZvWEFOcS9l?=
 =?utf-8?B?ZTUxbjZUYm9Ca0NWSTNRaTBHclBZU1E2emlqNnBXVEZkandONkt5NER0bnhv?=
 =?utf-8?B?K2NscTZtZUc4MnJYTFpIR1FSZWt1YUpPYmdnSlhzVkg3TlM4RzZEYXdPWDB0?=
 =?utf-8?B?eUlaRCtvem90djVMMFkrTHVUSXl3aWtRTTEzdWgrdC80aDBuRWtuUyttbTBU?=
 =?utf-8?B?bDM0T1ZtamdoSGVoRi8yYXBaNWt6RHRpRUtteE92Q0o0YWZZTlMzNG1ZWVVu?=
 =?utf-8?B?K2dHNUkrMTROM3RCamh5cXZJSzJ2cHNUenFqNU9DZGdlMGpaQTczeUs4bUNn?=
 =?utf-8?B?Qk93R3VoNU4vSkhsME1wTUhOSDZzdDZDRTdxMkxUSkdqbUx0d3k0OXU4ejM3?=
 =?utf-8?B?a2w2LytmMWRyc1MvS0FOME1QR1NGTXV6cEswRDFwT0RzQThQclkxcFJUY2Iv?=
 =?utf-8?B?YTgrTW1ia09KSnh0dEhzcW1WY2N3Yml2WmhQRis4THdYdFViOGI5RGdnV0J4?=
 =?utf-8?B?V2l5Nk4yRjFPaFdEdzhuYkZUUEYxTTN0RDlQbWUxVUdYTitjNVI2Y0JPVjJw?=
 =?utf-8?B?bnlLM1RVUXNwMEQrU1dKNUVBeDdieCs2Rnk0NjFpL0FQZzlleW9aTWxXWi9P?=
 =?utf-8?B?Vnc3Rm5RSnlHYnRRNXhuRXFUQlk3ZTVXZ0hXa1lUeWlkZlg1K0duSTdUaFhT?=
 =?utf-8?B?c2hMaTJkamJwY2pCcHJzWVBpNWJxTkFTa2E1Nlo5Ly8rc2VMK252enRHSytm?=
 =?utf-8?B?cTdPZFd5MW9TdWNQeWY4c3htMjlrU29zWkl0dkUzMGR3UUhXVUR2MEdLcCti?=
 =?utf-8?B?azNqdnQwTWxWTERibG9tTjNIemlaS0VHNXBmV3ZhU2NXalFRWTNFd09iUEJV?=
 =?utf-8?B?OGJYSFhIMW9VcUxUczk1OENRdkNiMzFuM014cXlrSWhwN2ZnSmFtZjhYemZP?=
 =?utf-8?B?UDIySWlWTmZKck9sRlVtSUJuTHNveXRZekI5UnZscVBlYjl3RXdIL01ONDdw?=
 =?utf-8?B?Q3lIUjNXSHJyNDVncnlsTGdFaUk2VkZWOVFtOUIzZ3ZaZmZuOU1VMVRJVWJJ?=
 =?utf-8?B?RlhlMlYwNjlnKzVLZGZBU2lmSGdIc0RxMWt0RkZ6ckNWQktNYm9HaFE2cWlC?=
 =?utf-8?B?eTk4WDliQ2pGcE1ubVY5NnRnSTZiQ1hPc3gvVVNZMnNnU2VSYy9JMGxUcE8r?=
 =?utf-8?Q?3KDBq8lgXcM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cy9CbDZ6RXBOMDlxeXpSd3dLVkwzOGh6WnVLZWo2SVh5OStON1RKWlhxSmdz?=
 =?utf-8?B?NVlWT2JRc0llMWZpMGR5bDFWMldZa1Vob0d4THVmcmhmVitlRXdWTXYreGlq?=
 =?utf-8?B?Q0w0Wk1ZU2txOEpYa2VSZTlGYnh1V3J0NCs0ck54ZjFZdEJWMmU4cytuMEw0?=
 =?utf-8?B?a2R3RVAyUHZseHVoQ1RDTFZFRENoUWp3SE9menJxK0V2VVF4eFUrWFVFSWor?=
 =?utf-8?B?ZkNIQ1k3Y29HWXozaEx6ZXZoeGszQkNtZmRPLy91bFRjTDZoVTBoU3U5NW9J?=
 =?utf-8?B?WmNSVVlKNUM0L2J0QUpnenlRRVlad3hxaThObnBVL3ZoemlmbW9PVlFJOC9x?=
 =?utf-8?B?YU8yOWhURzdGV1dNbFUzbTNIWDE4aW9wZzR0T2lnWm84NWZ0QkFqcU92RGdS?=
 =?utf-8?B?Ky9rdE15bnFUMjY4VkV4ODV0L0t3SWRmQnprUkNrTEJtbEpyRTcvUU5TUGpi?=
 =?utf-8?B?S0huakU5QUs2QnI0RlBpMkZ5N3Nrd1dxUWhKZ0hnY0t1b0VnYmJmYys5Wkx1?=
 =?utf-8?B?RXp2Mit6MDlDa2xzVXp1TlEraDdRbEszazdLVmRkUjVEUDNhNEViMzJqYndp?=
 =?utf-8?B?clFENkZXOWN2TGRBL0VJTVZzSUhxWDcyeFp2d0tnM2xmRDg4UjMyeUZCR09p?=
 =?utf-8?B?eWRMa1g1SXVJYnR4bDUwL2MvRUZHY0ROcHlqQkVvT3p4SWw0Z1BWSTJwS3pL?=
 =?utf-8?B?N2o4Sjc1S2twOXoyeFdQYjg4eWRrTDdDQW80QjlXTlN4VEpOK3ZZN3ZjTG1Q?=
 =?utf-8?B?NUN1REo0Ty9yMEhUYmQ2QVFjSmJFaW1iZVdVNWZweWdFbnU1dFlTZld6bkJH?=
 =?utf-8?B?bDc4NnhCVlBQQTFzaXFOQWlIaTc4NlEycWcySFZxVnd0Z0FLbmlvMVdoa0tr?=
 =?utf-8?B?aCtqdGpXRDd2RXJ6ZHFoS3lLN0xhQllLdmR3ckJaVFBWWHR1d216dFQ3RGNm?=
 =?utf-8?B?a2xudFpZdVVidUhJQXRwTXRYMFVxa1FPOERnd0txdlVMSEt1eS91eENsaHNZ?=
 =?utf-8?B?a1VoQmhHdXZabk1KTmROaEt1bWxBTkd6U2sxa1BCSEM1dVNDM2Jia0d0RVBJ?=
 =?utf-8?B?ZnJNU01ma0ZrV2luUHZkZkpUdmNtVVFzbU02NU12alpPY294QlZnZEtUbUJa?=
 =?utf-8?B?ZU41VDhsQUZQVWZJUGxjc09QTUNQak1Ld2pLZ09vZFFjbmExWlk1VkJyTHp0?=
 =?utf-8?B?UGdrbENsZmFtbW9OS252SlBCTWoxT2RtZ01SYUxFWjJTMDFiRVBNMFh0SnRV?=
 =?utf-8?B?RzRXMldJUHM3cWN3VTFwcHR3bHp3eStnZzd6MlN2NWd5R0dZZExaWnVTUjhj?=
 =?utf-8?B?b01CdVNSVklQYjdYOUNTa3NwVTZHSmpXTW1OaXphbm5QbXo1MUw2MWV6QnpF?=
 =?utf-8?B?TXUwTWF5TzhJTnExcVlMelluVTNzSDN1UUF6b242OEIwekhBeDVJRE5aQStj?=
 =?utf-8?B?U2NrVmRuRXU3ZXk1elNEMG9wd09DY1FPQmllVExZWUNPU1k1bXh1K1dGNzZY?=
 =?utf-8?B?MW11WUw0U3A3bWxIbi9FMVM1SERDQmRKUVJwSXR6YmhXL3NwZGtkOWhLWllH?=
 =?utf-8?B?M21TZmliN0piQ2dNejVmS2prS0NNODZ2QkRjRzdUMGJaeDg3amFjVVoxYVZI?=
 =?utf-8?B?QTRkbWpRbFBhaGNQMVJlS1Q0KzBOK1RFcEdicXJiU3I3aFRtQ3Myc1k5cHFS?=
 =?utf-8?B?UEJSN3Qwd0dsQzJ0OHBDZStCZHlXTVpTNlNVVFdURlVrZndTNmUzQ280TW9R?=
 =?utf-8?B?K1dscWM0amJPcWxRVVhtL2pJSWVOS1pQL3hEa2hIQytqV2ptaTJjM3FHdGx3?=
 =?utf-8?B?U3BFZk9LdWRaYXc2YXBjdytyNXY5ajJvTm5kYmwzOUpvejVlNXNMZGgyWnVI?=
 =?utf-8?B?cVRmTSt4UkZyc21DMFl2QTdoa0FzQytBdU9sM2g4TWNhYnlkTEFSejdQRTdN?=
 =?utf-8?B?OHUrZ05VTmZ1UVJLOXJZR2RjV3krTEdZQURyWE5CNjhzK1ROaW5uOXFETzNX?=
 =?utf-8?B?VjNDeHFBWHFBRU9DNGE5bXUveHhjMDA5cUxlZ29vTm9XZ0RxWHIxU1dpU2p4?=
 =?utf-8?B?U1RCMDhTMWN2anZ0OHpMaWlwUW5QSnBCOXB0cWw1TGlWd1JFOVlIZ1BwUTR5?=
 =?utf-8?Q?NAz12b1nLOfzG1/AqWXQ7/Vfy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc154c17-40a5-428c-7dcd-08dd8d5be104
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 11:39:51.4627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmx07EzIno62SP853FypWDZmxtJ4/FYlGJF9A+YgrZsWFYEVSR5YGwjJ1JMpTe4Ckn1KO3J4hEhQVubUIUqtRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4452



On 5/7/2025 4:08 PM, Borislav Petkov wrote:
> On Tue, Apr 29, 2025 at 11:39:53PM +0530, Neeraj Upadhyay wrote:
>> My bad. I missed updating the changelog with the information about logic update.
> 
> No, remember: when you move code like this, your first patch is *solely*
> *mechanical* move.
> 
> Then, ontop, in further patches you do other changes.
> 
> You want to keep mechanical move separate from other changes because it
> complicates review unnecessarily.
> 
> One of the reasons I'm trying to get you guys to do review too is because then
> you'll know.
> 

Understood. Thanks for explaining this!


- Neeraj


> Thx.
> 


