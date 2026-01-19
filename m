Return-Path: <kvm+bounces-68536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB917D3B709
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D07E230D8F26
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C163392B84;
	Mon, 19 Jan 2026 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="oMMDIUsI"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020101.outbound.protection.outlook.com [52.101.61.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1787A32FA20;
	Mon, 19 Jan 2026 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768849950; cv=fail; b=mdxyJEoEYZuXbyN85QUPlUI1Nvh2f6CWeXkTNfaL4vRhni/3qBaxlvs3HUauzGhO9NdNBi2QAB/lr5q7W9vaqnw4eI32f4XOgXjqe+Qxu3XimcN/rsFPUs11+He22iedNzB1r5jO4uURyhLQnoD7qLOMDFBP4prFPR1Zrq4M65E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768849950; c=relaxed/simple;
	bh=SGbLIbfdb+6xsQ4TpDZdVKELxUjU3l9Z+2Kji5iVyt0=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=aZ9kcgX2YEHqI1Er7JyJH1O50JcXzpcuAHxHNvZqghLUpggKQZAHoEjIsfHUUyEh8Dh2P9KBZGUffDqUmgy2TuBwXewzrB911PN95eVEqZYNa3cS9LOj9LjOkiAS5yVk/E+BLS8ElDfuZbuhUXtWOdfmBBPl+zoCJ9xnuAxGExI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=oMMDIUsI; arc=fail smtp.client-ip=52.101.61.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFhMrKUegKKxsKgT2s+eK4zSLEQMsDCUBspGgPCNNXuuyvszi/okoxItuLRJbavTyGhwrspfYi6yqyeW/rHO6dqHRY2gmxm4zsiyEejz1ZJFaOOCeoqbJsqmv4gn1WYBqGRrntgQA69s4JFZP0WY/UmGv67QmcVQ4U91MO1h1e95gg0QPeqrIn8ChsN5VSid8AcagzvDJ1SZfvrdKoki2Y0VzArJXH/rXZVBSVq8Cvf9eVtikvqZCHjnqMK75vBO4+IiMF2fjxTPtv/sbIJx0N9A0s1P4uasgnt3XfiCDncw+pE0tdsGtr68mUDv6ktylRxPnaUQliX2+ex7uOfRww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gh0kaH7qXT7Z/AWXDtjkCWlUyCZWq8cY1a5ByIaAg8s=;
 b=JkGZnChQOMJ0xqI+kQrGevlxNjkGPgIDy7CLuLTQKsdK1z35QMf3B3XFlVwXzjLZvMA50iTBj3lVvo6UKljR7K4gGRXNjF1iiIoqlgC1PNZLFeVYsvU/2ZMXQWxp/UmnPbhRfuVwJYXhdKQPqM+qjIIiopszhu14R2SgkkvcqGHqlCMVfurx5nqTsCqSHK7TkEbMJOO4TklaUJ07JNtQJu7m9mdf9jG4lD5I4/Lwq47n7o7NPO8k8fY98VumvWIdlfC+vBUTeemoG5m5Z0U15Gxa4odgHfAEok6bmSuFEZwEHiYDI9AZQMyaTXgidHV6wBsbHQ2CiipypWRax9ObLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh0kaH7qXT7Z/AWXDtjkCWlUyCZWq8cY1a5ByIaAg8s=;
 b=oMMDIUsIvmGqwvqem4gqF07UiC9P2rkLWClbUGt1WT8V4jI3EZsUQlQkHLjckKJfS2qs6ZaaH8B3OftuaIVhurbd4COBM4pKPOBp1SGbMviMw6xk3W/xdwVygQObK9GI8fgA9V9pxYSCzad0Ni4hMknCBVIALgkej1p4TG2sy7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from CO6PR11MB5619.namprd11.prod.outlook.com (2603:10b6:5:358::12)
 by DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 19:12:25 +0000
Received: from CO6PR11MB5619.namprd11.prod.outlook.com
 ([fe80::729c:2dc:b1a5:ff6]) by CO6PR11MB5619.namprd11.prod.outlook.com
 ([fe80::729c:2dc:b1a5:ff6%7]) with mapi id 15.20.9520.006; Mon, 19 Jan 2026
 19:12:24 +0000
Message-ID: <82c78d1b-116c-4456-bf8f-a441a97b3def@fortanix.com>
Date: Mon, 19 Jan 2026 20:12:16 +0100
User-Agent: Mozilla Thunderbird
From: Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH] KVM: SEV: Enable SNP AP CPU hotplug
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000405040403040907020203"
X-ClientProxiedBy: AM8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::13) To CO6PR11MB5619.namprd11.prod.outlook.com
 (2603:10b6:5:358::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5619:EE_|DM3PR11MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: 553dc3b8-a5aa-4f58-564b-08de578ead02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFNlR01UMG5EbEhTWWtkUEtFNzlIQUZ3eEJNRGtnMFFFUmo4dlh6czlodUUz?=
 =?utf-8?B?UElwZHlmbDZRTC9ESzBFTHFtUkdRV2VtbUIvYTVFUkVZZ1hmY1gwWlRtTm5X?=
 =?utf-8?B?WUFsakR6NWpVZ0p1SzU0LysrT2FWZ2VnOG5XLzJwRUNTTUMzTC8rOStocy8y?=
 =?utf-8?B?bzlKN1RTemdZRGwvd2hEM3NOem1rNEc0N1pkbEdpYmtwdmZCSEw3ZTBPTmNL?=
 =?utf-8?B?dlpLTWUxV2t4RFhtNjJPNVA1ekpzaUZzNjhmcjRUaEFad3M0dW5ReVdOMGV4?=
 =?utf-8?B?MzlUamx0YjlEb3FSdDlCL3pVVkJuUTRpaWR0bzFpNStVL3htRCtBZG1sUUZR?=
 =?utf-8?B?K0ExWXlkRUpiTU5qYTRveEVXWklVVGs3a3ZpYTlHbWxwS1dDS0R0blpHK1h0?=
 =?utf-8?B?MWdZemliTTFDUE1rTVAvY2szRmVtRWFyZy9PeDIwbXM2eHY2MUZNZ1dTdFR2?=
 =?utf-8?B?VnkzOWp2Q2JKTm9SS2dVenIybk9oVTF6ZUZIRjBFNHZEU1Rlc0hpd2FHWkVI?=
 =?utf-8?B?WXkxazdaYWsvWkVKQisxT0RjelQ2d2p5blNHejNHNnpwNVlWWXJFUmlyZTdz?=
 =?utf-8?B?RE5hOEg4T2RiRFptOW5ycEFzYkdqdFlaR0hwSjEzTWt5VUtYM1RwaFErUEZl?=
 =?utf-8?B?K1hwdXZ3M2pkcloxVlArQTkxSDZWRDZIRjVYc1BSUldaMlhhZXJhamIvZ0Iw?=
 =?utf-8?B?WDdQSHlyMVhDdlJ3S3B2R0VNZExGUUx2UGplSlN4K2o4SmIwbjNQZ1hrdkdM?=
 =?utf-8?B?WHNsR3VMRkMxOG1nNUFwRk5ka2QvQmlRRWw4YUVyYWRwb2JKT2doc1NTcmQ4?=
 =?utf-8?B?dmdhNWttVEhocjFhVyt2WXd0REhaWXB0dlRGVzFXaU5CWFhIMU1hMExFUXI2?=
 =?utf-8?B?QTRBb2E5bGd2Z3ZhaTM2bjRHbGYwRWt5VWRheVpTeXQ0ZlZ4ZHV4RGN6MFJn?=
 =?utf-8?B?MGZsTzI5eG8rSlYxR0V6dlFObjZpcDFmWnZUOVkrWkJFdTR4L0tvYnhpWjJl?=
 =?utf-8?B?QUhJYXkrdXFEYk1ZbGVhbGhsM1J4MXhtWkVLdnR4enQ0WGc3M2Z1Z0lJNEtB?=
 =?utf-8?B?NnJJZkRZaFdWSmtNSXpMRVdwZkpQYTJ4RzNPcXhjTFRHNnZZSVhSY0pXd3R1?=
 =?utf-8?B?ajJjNXlNYVZnSXg2SnlxK2V5VUlHU1BnVkd6UHZYTnh1Q3AyL2x2VUlZcFV3?=
 =?utf-8?B?WkJFRHRBcGFZcGFkUktWckE3SklwMDEydm5uVERGZUZieFdOUFVlT1JUcGM0?=
 =?utf-8?B?NmE2TzhJaHVUUzQwalVtZGlCZXVxakhBNzZEVjB3cFRXUWtzUElIenBIc3RT?=
 =?utf-8?B?aXNTNXNtNmdxeFV1Wkh3dUk2dUNiR2hFTWtSK3A0VVJ0Y3BiZm5aVGJHd2lk?=
 =?utf-8?B?TFRNeDhiY05MejFCUkJoN3VLcFh2WVhPL2Y1MGxZWmdTbDBST0Y0SUg3eWFI?=
 =?utf-8?B?LzAyeDhMTitZVi9iWjBUTmFmZGV2SjRtUG8raE96ekNoWnp5UjFQa2M0TUx5?=
 =?utf-8?B?WGNva1VCQ2NOVExWdldCZk16N2dORHdTaG1UVWtmMUpEV2ZjSDczMVhNVUxi?=
 =?utf-8?B?VmRENXhqVkROSURzNzcrR1VvWlVDd2llL2lyMkgwVjB2Z29nY2hOWkZhNXNv?=
 =?utf-8?B?Nmp1MDdYQXh2ZnZHNEdlSEpYTkZza0dlZXZvcWpjV1QyV0xrclV0MWZiVG1X?=
 =?utf-8?B?OVBnZUFWSmNNVDdOM1c0b0x2ei9FeWRDVjQyNUhVSkNTbHVraDhDcGs0ZXlM?=
 =?utf-8?B?Y0xEaWtMMXgrcjIrS05ieXcrY1k3RzhNMHV5bnpETjl3aGZiWWw5WmdOQkF6?=
 =?utf-8?B?WjdCMlYwODBMbDJKVDQzSzIwaFBsV0g2ZHpwRjBhUndta3o2UHF6c1FhTTB1?=
 =?utf-8?B?d2tPb21Xa1dpSXV5VTNPVStJVmNlcDdSSjdJOEFLL1VkUmZmbmFES3VuYkhY?=
 =?utf-8?B?R1kxNDRFNlU5SkhKNjJ6UXJVTkFzSjRmeVJQL3dlZkNDMnRwUzFSUTg1Zzg0?=
 =?utf-8?B?OGphRlJpVHR1eFFRdlY0T29jWU1GaU1RYXY5M25OY3lTSGF5b0lJOUxkY0lW?=
 =?utf-8?B?MS9La083eTRicFhPeTlDVG83U1JyZ2NRalNNejVtYUR1Z1JacndubjhaYWFY?=
 =?utf-8?B?N2xOMVlUR0J4dHA1UUVXbnJORlBpQjdGVWtJL3loNDRRcVlzL0hybGx3NzJG?=
 =?utf-8?B?MVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5619.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUFPS0ZjSDc0K3I3ck1rQi9vVERNbXVLUFcyTFc5QzRveHVSM1dhaW00VXVk?=
 =?utf-8?B?c2NxLzVvbStmelM1N2x6cHJvTnordTYvaXRZWm9xK1IwTDRpWTRibkNRYWFJ?=
 =?utf-8?B?MnhLd0pPNlo0ZjFjWkRHc0tUY2FOQS9kbXNmclFXNi9aTzRZeHdlQkZ3UXlm?=
 =?utf-8?B?b0w1bnRNYjViUUZLQ3JRWlJlRlNCRDJlclFadWpiWHlIT2MyU2pabi9Uc2hG?=
 =?utf-8?B?M1dpN1JoVE4vZ0tWeTZOczRidlZHK3JOMnE4eVJUdnM1aklyc21iM01JR29R?=
 =?utf-8?B?dlIzZlU3QTI3ODA2Ri9oNmZMeG1naSsrNEhLREJLSERvMFRkSVJkT2tuYXRs?=
 =?utf-8?B?OEtTSzJBN0hieUhVQmQ2aTUycFpTUlk1UmpmRGZjVGdZTlNFdDlJK0F3MnM2?=
 =?utf-8?B?cThjaG9CczYyeVVDU0FlYXJpeGNtbE9QUEhrM3BjWUJ3OG9TRW1tanVGT2NZ?=
 =?utf-8?B?M2hTeFhNWlIvc3VwYVRsSm9FUlp1VmcrSEN3VnlOdDZNT09wVituZUI0dU41?=
 =?utf-8?B?VHh0ektCRk9IRjhhb2tyMmpGTXBtRTV0K1RMc3liNjlnbENDSm54V3E2d1pl?=
 =?utf-8?B?VjNJVXMwTnNWRFpDRGhXZWZwUEwrZGs0Tis4R0cyaGptemwydWdwMEhML2Np?=
 =?utf-8?B?S1luS2NQOTNwdFdnL0d3bHBTbDdYY2MwUmRGZE41YjI3Qm44RW1SWjVjdnNk?=
 =?utf-8?B?TERsRHlPc1JNRFFuMHIwS2lpRkQ1ejIxdWtIV0lvU2YyR2grY25SR2VqTnJw?=
 =?utf-8?B?UGJqWG94bi8xTWpxZ2VzeVdnbVQ4TmhrOEQ2OXBwVzdESlBVNmdzRTljQ2J5?=
 =?utf-8?B?dmZIc3VBNTNrTm9BRzlnNFZQRkFXaHpiWjhnNnNET0I0bGQzNHZzdGFVUlpn?=
 =?utf-8?B?aFhkY3RRUUN0SVNrTlRhcGtVaWJGcEh1Rkhka215Z3hxQm9iMUpCWS9tSzho?=
 =?utf-8?B?OUNPaHkyVE9XNkovTVlOdVVRd1U2dTU4QlpOSTRIcW5VN09vQk15N3pWekRX?=
 =?utf-8?B?dXVnYUMrMjRWanM5VERwM0tvZW1YNzVqd2RYNHhpR0tkRDd3OFpRdW9rV21p?=
 =?utf-8?B?N3VxNWFwRCtmaDZkQ2FEVkFXS0gzL05JTU5TdWlvdWhTQjJCSXBJZGUvU2lJ?=
 =?utf-8?B?NXVtZ1NWQTBOdUU2NG1jNDNRSHFyMitqakhhTjZpbyt2QXVDNGpld1RNSjJR?=
 =?utf-8?B?dFRIRm1WNkFNUkxvNWM3Ti9kbGZuTEJKYzM5dDJNRERqVFlWVU1QaUVqdzBH?=
 =?utf-8?B?c2lCOUd1eHJJNjl5RzJ4TVdNT3RuTnl3amJpUW50Zm1jRFlUWUxEa0lKbTBK?=
 =?utf-8?B?MGxjWUk0dlJ1TzFidyswS3J1aWhjQkxTZjZNWUxmNzErQmZKY0ZQN3o3NWJ2?=
 =?utf-8?B?d0ZuTXZHaHhIeGd5OUV1OC9GVzI1N2hyaVNEY1FaaXhqSGJZVWd3ajB0NitV?=
 =?utf-8?B?Sm9vS2Q2SGhxKzV2dWU5U0pXSUVWTURyT0lyaDQ3MWV2cTgwYjFKY2dFRVkx?=
 =?utf-8?B?N05ybXhCWUNpVElzSUpvVXlkdjlYUWtSMWI5eVVTaEh6K3JmUngra0U5RDZP?=
 =?utf-8?B?NlI2Q2t1alZtc3MvbHhReVVKR21reHMrNlF1U09vaGU2QlYxeHJ0RjgwSmlF?=
 =?utf-8?B?WkdXSjNSWXg5cXZQcXpiNzNYTCtJMk9QN1BxMEVPZGJWb2RMY3ZsRWpjdCsv?=
 =?utf-8?B?M0l2eUtzVm50QU52VzZIRnNhTjVhVStBcWFUeWFUY2FTRnZBbTg4WXhzZnM0?=
 =?utf-8?B?MHMwVGR4OE1zYkFiTEttc0U5RVkwMWxIbzhQUlVXdHVCYm5mZnQyMkNlZUZm?=
 =?utf-8?B?Z095eVl2L01YbGFzNTNYWXFYVGJYTHFUK05UM1pMQ3h4UlhsY1JhdzNRV3Ez?=
 =?utf-8?B?R2NDNkJiOTVDbW9CZlVyYkZiQk82RmowTnhVUHZuQkFINnlkMDdqZ3lmREZE?=
 =?utf-8?B?SEtyODZkR3JCSmxkQjNZb1Q1U0hzbHF6SUkwWlhNY21VcnBjd0lBOUFEREZk?=
 =?utf-8?B?c0lZdlFrRXh3bmNwWmdEdWM4RzczZkxGMXpCUzNNcGl0cXVrTGVLWGVod09G?=
 =?utf-8?B?c21FZTNxU1NmV1FlTWhxMTVCb1VsMzFtdTZsL0ZrU1ZiQlVVcmdDRnZzQVlV?=
 =?utf-8?B?NXhWcUVqMkVRd0l5VFZTcHhwMm1GaWpiTDhxQU1DOTlQTXFmUmpsM0g4VFJn?=
 =?utf-8?B?OTRHakdQUGlTQUFlZkNsMjFnQ3dmMHczNkZNM2xNNHAxK2VTK1BnbytKdWYv?=
 =?utf-8?B?ZFhtWmZSNnhaS25mTFh6dnNWWnBYZ0Z3Wld1dGoyaU9PRTVTMGhhcXR5emxR?=
 =?utf-8?B?N1V0eXl1aWRuTVlHMmdKcGdnRU0ybnlRcWRtdHZXN21XQTU2cXB6QT09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553dc3b8-a5aa-4f58-564b-08de578ead02
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5619.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 19:12:24.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xn4u+fbkXoQvifnfkpIJC5vNTvd9FU6fO7akFW3jkYNZyd4PU2AtGao3PHXPh2iIOrJZTxryZAoxsR7+CETW2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8735

--------------ms000405040403040907020203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The GHCB protocol states that after AP CREATE (as opposed to CREATE_ON_IN=
IT),
the hypervisor must immediately proceed to VMRUN. Update vCPU state on AP=

CREATE so this happens.

vCPUs created after SNP_LAUNCH_FINISH don't go through snp_launch_update_=
vmsa.
Ensure the vCPU state is updated properly during VMCB initialization.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cdaca10b8773..9af1bd5b2071 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -960,6 +960,19 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	return 0;
 }
=20
+static void sev_es_finalize_vcpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.guest_state_protected =3D true;
+	/*
+	 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
+	 * be _always_ ON. Enable it only after setting
+	 * guest_state_protected because KVM_SET_MSRS allows dynamic
+	 * toggling of LBRV (for performance reason) on write access to
+	 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
+	 */
+	svm_enable_lbrv(vcpu);
+}
+
 static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vc=
pu,
 				    int *error)
 {
@@ -999,15 +1012,9 @@ static int __sev_launch_update_vmsa(struct kvm *kvm=
, struct kvm_vcpu *vcpu,
 	 * do xsave/xrstor on it.
 	 */
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
-	vcpu->arch.guest_state_protected =3D true;
=20
-	/*
-	 * SEV-ES guest mandates LBR Virtualization to be _always_ ON. Enable i=
t
-	 * only after setting guest_state_protected because KVM_SET_MSRS allows=

-	 * dynamic toggling of LBRV (for performance reason) on write access to=

-	 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
-	 */
-	svm_enable_lbrv(vcpu);
+	sev_es_finalize_vcpu(vcpu);
+
 	return 0;
 }
=20
@@ -2480,15 +2487,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm,=
 struct kvm_sev_cmd *argp)
 			return ret;
 		}
=20
-		svm->vcpu.arch.guest_state_protected =3D true;
-		/*
-		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
-		 * be _always_ ON. Enable it only after setting
-		 * guest_state_protected because KVM_SET_MSRS allows dynamic
-		 * toggling of LBRV (for performance reason) on write access to
-		 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
-		 */
-		svm_enable_lbrv(vcpu);
+		sev_es_finalize_vcpu(vcpu);
 	}
=20
 	return 0;
@@ -4030,6 +4029,10 @@ static void sev_snp_init_protected_guest_state(str=
uct kvm_vcpu *vcpu)
 	/* Use the new VMSA */
 	svm->vmcb->control.vmsa_pa =3D pfn_to_hpa(pfn);
=20
+	/* vCPU was added after SNP_LAUNCH_FINISH */
+	if (!vcpu->arch.guest_state_protected)
+		sev_es_finalize_vcpu(vcpu);
+
 	/* Mark the vCPU as runnable */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
=20
@@ -4111,8 +4114,12 @@ static int sev_snp_ap_creation(struct vcpu_svm *sv=
m)
 	 * Unless Creation is deferred until INIT, signal the vCPU to update
 	 * its state.
 	 */
-	if (request !=3D SVM_VMGEXIT_AP_CREATE_ON_INIT)
+	if (request !=3D SVM_VMGEXIT_AP_CREATE_ON_INIT) {
+		if (target_vcpu->arch.mp_state =3D=3D KVM_MP_STATE_UNINITIALIZED ||
+			target_vcpu->arch.mp_state =3D=3D KVM_MP_STATE_INIT_RECEIVED)
+				kvm_set_mp_state(target_vcpu, KVM_MP_STATE_RUNNABLE);
 		kvm_make_request_and_kick(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target=
_vcpu);
+	}
=20
 	return 0;
 }
--=20
2.43.0


--------------ms000405040403040907020203
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ZmljYXRpb24gQXV0aG9yaXR5IFJTQTAeFw0xOTAzMjYxNzQxMDZaFw0zNDAzMjIxNzQxMDZa
MH4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
A1UECgwIU1NMIENvcnAxOjA4BgNVBAMMMVNTTC5jb20gQ2xpZW50IENlcnRpZmljYXRlIElu
dGVybWVkaWF0ZSBDQSBSU0EgUjIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDm
Q+3UxwVE9dAx75DUrLZwgASWLLr/ID8bbGCfpcrSHIRsrR4ut5n49JGViu5DYE6addkpajbi
MA2Jaw1Ap4RncDjZ+0fzSWbqGKEE+vNPVLoKy7OVIrxf/9HzGUT6YaELSNrGTR0cYNcR+W5b
E3JTxTMQiLMAwBbMXH4qKXQUT+oyIXD11CIMUtM8ECoo2o7qdpw1zaZWwVvhXy9mkAaRgrkw
2NpddZUVbJKF/spsJa3lNVdSi3wcJpDDQAl6jxtBF/3ctkY1OjBQz32yRlArFymsPc+we9ff
HAgvfqbHVfXvgWG8urVith8/6MjmojHMCKqFoJueLbtTPoN8QhvVh49uoRYYAUUH0HOAYCOz
GBGrdJvMIYZqQsX90XlU7Qxp1En7vMkQswkQTvGmBPWrK/EwSAJc15BZm+i8QBxPqVKFORfL
ETLEC4ZrwomtW/oPxBP8zXPvQ0K1dQzAkw+JXxKv/KiwDryFFhU5xMMB3yKxO5NRYXlnqW9n
wfhdBTJScthzAtGO9KZQ2GPmq0NMVMuXe1XdCOmnPxOptKkMldBItkaYgrkTzqP1nzIAhVfU
4sNnHIxKPftwrZ9VMSc5Wkz88bOtAJyz3KQRY0qcAtR4LaeRkiZaEmprQA8EOpdJxtv03pBZ
taUnnTY6DsEwGQ0+P2mmB5IHB74SknyNswIDAQABo4IBaTCCAWUwEgYDVR0TAQH/BAgwBgEB
/wIBADAfBgNVHSMEGDAWgBTdBAkHovV6fVJTEpKV7jiAJQ2mWTCBgwYIKwYBBQUHAQEEdzB1
MFEGCCsGAQUFBzAChkVodHRwOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeS9TU0xjb21Sb290
Q2VydGlmaWNhdGlvbkF1dGhvcml0eVJTQS5jcnQwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3Nw
cy5zc2wuY29tMBEGA1UdIAQKMAgwBgYEVR0gADApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcKAwwwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNv
bS9zc2wuY29tLXJzYS1Sb290Q0EuY3JsMB0GA1UdDgQWBBRmj6a8t5Msnfm6SeVP3OqQUBFq
nTAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAMJr11ncGIPKbaZxuuU2P1TG
yXF+gy+xH2TBNWNliJVL613nH1J7L2WcJQzqXYl77rKTzGeQexnKeYZ13MFwuE80vISif/gw
K569WLoyCvNVvGEZ2bZ+JL5K49mVhrv1gqO+MgMvc8iEENl1xoWRpJGD4EClk8t4u7NUCgBv
hYORiyzHCZcILHcEMvfEwmmFshMN6TqcAJdRjFT0Ru0hJcs5d7EFdM9dCa5ckXWrKK49cSNq
4qOaxqpG99EfDw6U2c70YcJ1/IhC1wL6z8qlGvhYQ0vJvqGJqW/DdeuWcMmrB+qZL9WbORQ1
nvlNggB6smEk0pXXYBr8HYjxT67XwtBBmkBXFpa7G6y4P0BO3kxWGBfvRBJHfyaiwREgVWa3
6V/WjXtPmV8VHcv04Rqgk64E4OlSUxgi9k9VC6kivTXJN+Gg2uJJBQdf+ptVhJqkkrtB0gAB
F+kQP0xsagKkrS3NVrVKo6peWMx0h7l52bGqT8ucu4Qe200KQi2xp/r8jpP60EE9U4M8D1gr
H3Kh9OxVOL4wykdoC/yGJNLKIl0BfsCVWB/GeSq5hxe/84K51OEJqpjDnOMrkRevfVzqGBFF
Aeg7Kg7uSysVR05wR+ltp3ytaIbjGJtKad8raIbM1qiNFErG7YB7v4baI3BP1s/rTDtPLoto
tahwHP7IqOHOMYIFVDCCBVACAQEwgZIwfjELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFz
MRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE6MDgGA1UEAwwxU1NMLmNv
bSBDbGllbnQgQ2VydGlmaWNhdGUgSW50ZXJtZWRpYXRlIENBIFJTQSBSMgIQNfphqrZnvSlG
TcM/9wjbxjANBglghkgBZQMEAgEFAKCCAxIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMjYwMTE5MTkxMjE2WjAvBgkqhkiG9w0BCQQxIgQglnhFFBxBKMJ7
VDdzPVJVYIc/f5w/3yJjteDnrBJv2ikwgaMGCSsGAQQBgjcQBDGBlTCBkjB+MQswCQYDVQQG
EwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBD
b3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1lZGlhdGUg
Q0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIGlBgsqhkiG9w0BCRACCzGBlaCBkjB+MQsw
CQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoM
CFNTTCBDb3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1l
ZGlhdGUgQ0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIIBVwYJKoZIhvcNAQkPMYIBSDCC
AUQwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBggqhkiG9w0DAgIB
BTANBggqhkiG9w0DAgIBBTAHBgUrDgMCBzANBggqhkiG9w0DAgIBBTAHBgUrDgMCGjALBglg
hkgBZQMEAgEwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgQwCwYJYIZI
AWUDBAIHMAsGCWCGSAFlAwQCCDALBglghkgBZQMEAgkwCwYJYIZIAWUDBAIKMAsGCSqGSIb3
DQEBATALBgkrgQUQhkg/AAIwCAYGK4EEAQsAMAgGBiuBBAELATAIBgYrgQQBCwIwCAYGK4EE
AQsDMAsGCSuBBRCGSD8AAzAIBgYrgQQBDgAwCAYGK4EEAQ4BMAgGBiuBBAEOAjAIBgYrgQQB
DgMwDQYJKoZIhvcNAQEBBQAEggGAm6XIu9sUES+U68g2NCkm+1b/SGbs0F3wnj1qa8kmi1Pk
N29Y3B+pzf1da8uzjYUjKjbgKuv9bVNjtnmPIv+AhhBZdgdtqYmZijV/eWE9KkwrEmQ2gff9
8sJsZHkxF1RnwaeMH4JslsmFJhZEXAxsXDw5LXZ+MUcqKEuZDP6OmXxMBgWlc1WlLZ2EFkuM
Enr0zUOPeXx9w9TNtI1gW/huM2wnTX7yrYhZ4sFqCpKLtoPUsCVRRyqEiIqWV92It4NNmfwj
63i7NPUmj/Epmj2nIwnKOLecSjZdmd4ug8Xq9jwPTG9j7MWL3I1fFxchSMQtg9cfuohLEnp3
Xhme2yQiOmzCtpEgnrSCvfrcoADmALtYJUJVkqAea2vza0x3uUv9MjgUBQRCdwD8eDYv8iNf
43QFXKrl8RzdthzRjKHWC6U5fh5XD51280WWwgtjhhT24yf43PnUCJfSxTYFYFRPckOJx8Fp
cgYkn+E5xVnMITGwvkAfh/mQQVMkn1cpNb12AAAAAAAA

--------------ms000405040403040907020203--

