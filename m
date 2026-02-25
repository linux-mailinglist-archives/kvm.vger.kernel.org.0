Return-Path: <kvm+bounces-71799-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8C1wJlGcnmkZWgQAu9opvQ
	(envelope-from <kvm+bounces-71799-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:53:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F19C21928A8
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB15930F0A67
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B152C0F6F;
	Wed, 25 Feb 2026 06:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VIeyxZxn"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D7075801;
	Wed, 25 Feb 2026 06:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002105; cv=fail; b=JvYeOFJrja+UpUYkJgftbOwHtFkANrt+RnP7kRsVPUfxdRJ00pg1k+EE0BTKw1tqT+xoOSqJz4wNp+YQaAdKPDNhj5AuYD8Fn2ctusD8U6RettCsLubh1cRwYREtnSiRLHITHKd2dGbavy2sEmdi1BfQeRG0fg+GZ4UwMOQDiTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002105; c=relaxed/simple;
	bh=oKvpnoi29plECiuQEAwWO5CKv1jSym1ZKHzpOFWrjN4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fNdFCTPLu9SVsbkYAJO4InrjbNGYtBMEyv5LYYm1Zgxde4hg+A9FiU/jkW0htcwdTeiRz6ncKYWXZj33en23qQqKata8kMaBW3a9uNtlIEn2Pl6WEmOWay++aQKOWmUXgvt3vJB61QnFvRGRFsJ9Lnz3DB+r3rTAdh8GKk/G7n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VIeyxZxn; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YNIbOO3IR1Jes15ApXUqCZ6LrjWwnBfutWZjMOcmr9TjXWoo3x36DLoFwgK/Zu4IASNwbqAjXeMtQ6J6HjEYivFHy+4CtMx85GD68QOLWZbvVTkPZ8cWLYy2dnXKULnRcIHNAfsE1VGvJnpSE1t60w5M5MPPgHwifBM0vP1UtGHy1JAPICi2KWgbJO51aJkbakWj+AySOo+VSBx2J1lEIhRUWyrpUTF5lCs8srOesKK1M+vAXr++xDSEz8t9Bi6oHCLW9OstFIEprCo96xmItJecSc6eckfTYyC/GnOrZtFlqtVGV3iBUnexQXyNkOPfZQ/6zZC5v8r05+RfD2/AlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4oSwbY9wi16oC0vkgIZPMl7umDsxkGpeE/GGyc5KAQ=;
 b=wI9keqUb3oEUkkjUTKfmfTRZ/rRrQxczqlZYBK+v0dcHxY1hzQbavqkPvbK6UfX3t4wb4By+mjwFmQXrivH7lneI68qfqhqRzj6xGYOaQFQHV0aAnRGaeIwxfS395kE8stX4SDXDuHi30vrN8YZdtSJKpDtFDe3ePoNDV8MM70r1YHXAvwsqHgk9nGjsZ+ymc1I+doE0pPievxncPQmkfOnTwsyvtXH/aPz+lwWSpEvka/odkeccD645xRNu8Uhit/lnkLueEZ+st6EF5lnO6np+oVifGiCg7Dhp7uZHxrvl/V8sBQmtUFCipd+VtPVblDQqK+8nuEHcYlF1AXjZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4oSwbY9wi16oC0vkgIZPMl7umDsxkGpeE/GGyc5KAQ=;
 b=VIeyxZxn8WB0Zir21ED+hnZAhY44Oimy7tQQ9pEAwr3wIdYD1imhU6l6WTntE3fFnfjB7B1gp3FJJFQZfQEjkKJSIalKJ8oMu7DvhF2gJPY3pF7prqvvHUp46y1OqllhWl1+tqV8EjTbS/eGXCoIVihQA7Cvz2455Ao9G+QSDfE3lPqkrkHDx84oYeGz6T3x1a+HjHBCd++8h2EWM464r6YfXSqIW9SDcsiQI9n8NKChpu3UWaH9qr7j5/W/tLMX6+SpPJPAw3EJ7HRtYJXbpwHmgflnh/bV+Ybgbx4/QLtIbr13XJKVsgRC5CRc5E4QNk3SXCYkPgL0g74Rr2nP+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 06:48:20 +0000
Received: from SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b]) by SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 06:48:20 +0000
Message-ID: <26fa60bd-83a5-43cf-9630-71c3a3c85b00@nvidia.com>
Date: Wed, 25 Feb 2026 08:48:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SVM: Fix UBSAN warning when reading avic
 parameter
To: Naveen N Rao <naveen@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dragos Tatulea <dtatulea@nvidia.com>
References: <20260210064621.1902269-1-gal@nvidia.com>
 <20260210064621.1902269-2-gal@nvidia.com> <aZx_VsnmWLx96AeY@blrnaveerao1>
 <3c2969a9-c58a-4935-9d53-f3d6f3343b21@nvidia.com>
 <aZ6UJyaBr6XExhsv@blrnaveerao1>
From: Gal Pressman <gal@nvidia.com>
Content-Language: en-US
In-Reply-To: <aZ6UJyaBr6XExhsv@blrnaveerao1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::16) To SA0PR12MB7003.namprd12.prod.outlook.com
 (2603:10b6:806:2c0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7003:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: 08bc0f95-4e96-474b-31d1-08de7439dcc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHBWUWxCNFhzbzVNRnc2QzV0WVFnNzYyT1owOHFVcHpJekcwZlBNUzlxOWM0?=
 =?utf-8?B?YUFoa0tuc1N2dmlVaUhNVml3RFJ6V2ZveFN5NGVOTjNCOVptRjVjbzZmSUxx?=
 =?utf-8?B?WTN4USswRFZ3aEJudE5wN1FxNHErbGhrdG5zUU53YTVNYkRkbkJOYUZ4Z1Zv?=
 =?utf-8?B?T3lCL0h5eFBzcmJweURpRmZjd2ZTVmlpNmtlRlloYjJsbjRIMi8rZGdkd0RM?=
 =?utf-8?B?eWF2MGMxcUVEOTBVSVA1aTlEaWNRT1JhRTFWY3QyVG9JLzhmcWtKOWVzMW9V?=
 =?utf-8?B?RHJ0VVR0MDc2S3VKc2Nuc1N1WDh1YjNzYzVXVE1OR1hOWDV6SllKeHoyRkx1?=
 =?utf-8?B?NllMazRHN25DY281UDZ1eEVEL2FUcWdUcTV0OVF5bTNRRFdQZXM1SUVLdFVh?=
 =?utf-8?B?bGhmSGY1aWlneWJUMWc4b0hUcnlYRHNLYzlnTysxWjBrYkFzSWpTNVpmSXZN?=
 =?utf-8?B?OUdQWi96M25rb1c1SjlyWDJEQmdvMG9ZaHEyWmVMaXRRSHp5VUw1WkZtbUd5?=
 =?utf-8?B?Mk1CbG1VMEpUN21YKzZ5cFhRc3hpOGJQZnlQU0d6OUlDYnRtZ1ZFTWxnbGxN?=
 =?utf-8?B?eTh2cmZ6UXFhblBHVmNLSUtxSWVrQzlSMGxhQWVmVEZnK1ZKM3lKdkVlVzli?=
 =?utf-8?B?bXhyeVA4WklJR0tMVmpXZnpGVmZ6WTdQUDkzWm5jdlZlaWVLYlR5YWxPV1F6?=
 =?utf-8?B?QUlscC9qUmZreGE3QnQxdUt5OElIaWMvUHdPaHN5d2l5L0QyMXRIc3kweGFa?=
 =?utf-8?B?a1lBb1JyVE80L2ZiUnFSNnd1dEVKZGpQOVJNVkVwckQ4U0tQamFMS0d3RlpD?=
 =?utf-8?B?NmpsNy80L1M2cXc0S1l5emNxdnMzckdzVjdBbzFLYkExZ0l1Tk9nRVRRWk1s?=
 =?utf-8?B?eTkrMHBhS2VpZGI1Sld1MU5yWUZ0UDF5U3VpK2JMKzJBQ1NFa0dRdjZ2SjhC?=
 =?utf-8?B?c0NnUE1YOGJ5LzVwNlRrRlNaSTJ2U3l2U2ZzTTZlNEVwNWhsazdCYnpkTWVn?=
 =?utf-8?B?NHMvL2RCTGlJQW1laE8yWjA3OWh0TDArQm8xcEJ5YThXMzErT1VrMWVRRk41?=
 =?utf-8?B?T1ZkVjNMaDlwT2kvVUVKanVnc09kak8vSzFMaFBLUHltZFFEZ3hiSXpwK1Ja?=
 =?utf-8?B?NmFWNU93L3ZEeDJTUG9tMjhMN1kwQjgwM0dOQUQybTVSTE5CVFZzdThaKzFF?=
 =?utf-8?B?WUNvOXlBM3h3WXFkMWk5enQzMy8zZ0VBVEw2WVovN0VsaWZLbXl3akJWMExC?=
 =?utf-8?B?bXJ2d3JCQ1prZHFpUzF1S2FQeno4bU9IMUI5V25aTWpyUGlsUzI0b21yM3E1?=
 =?utf-8?B?OHpmWklDbHMxc0JIYmx4MDNCUkUxUUhkUHZCUGVKczZEVVFkNnNhS3d6NmRE?=
 =?utf-8?B?b0I2VjBSZVFHb3JlYkhiY3dWY01acDRwQW5oV2Qva0QyWGc0NUFhRUs2d3Vw?=
 =?utf-8?B?d0pZSjhUamlKdlI0bDBUTjdDM0ZJZ2psL3k1Q2Q4UEJ4NHBWa0lELzBQVkll?=
 =?utf-8?B?ekhIdE0yQzBhK1QyOXRTb0JaMFpBTHdZdUJvRVBMazc0WjFDWndxUDhpTkE4?=
 =?utf-8?B?T0JWa1NEbStWSHN0VXF1N1hRMERmdHlMajNmQlExS01ycExBOWtJZGhYL2JP?=
 =?utf-8?B?QWRiUzdZQVlwWnRKUkVMbFBBWW9ZdXFFa1huNks0b2pOSlUrR3JEakZZZUtj?=
 =?utf-8?B?azJvcnpJbVJDb2lxK2U4M2ZIT1YzR0xaUjFtRm9KbVJqMjc0UGhDbllMeDVE?=
 =?utf-8?B?M3h2VHJQTXQ1dHl3b0dUcndLZnRXY2kxNGMySFZRUHV3MGJCaGl6T1E0Mnl4?=
 =?utf-8?B?Unh1QjZlK1BoUmlTK1lxcklNMlBHV3RIRnR5a0kwVDA4eVRNYTRuTFdTSjlE?=
 =?utf-8?B?ZkdYdndhS2pVdHZkSXZLTnBvV1lFVGdxSWcrdmxFVFRaWmg0Y25HdmRyWC9T?=
 =?utf-8?B?ZEVhNGRadkVBYit1SkpnTjY2N09mSkNpd1ZWNno0c3pRbTJiOXl2anRKckhG?=
 =?utf-8?B?MjhBWWxFQ0U3OGpsNWtlZVVGMnF5RFBsT21xckVLRWF5NDNJQTFOempiL0ZW?=
 =?utf-8?B?dTBuVEJEQUVqM0dzMDZ4SkVtTmFnakhENEdFeWVWaWpRQkhFN1FjTmpvNW9R?=
 =?utf-8?Q?ANiI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7003.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0xKR3RHTUxvcnlzWm9KbzBTNHBZSVkxU0pjWmQxUnltR1dJK0RrMHZjeWh2?=
 =?utf-8?B?WUhXeEVFOXgwSklGY280QmtQOElSOW0vTW9idUcwL3RDam1LcTNaSVYveXpE?=
 =?utf-8?B?aWF0MkJQMnRtRHI4M0x5dzNyUkFRcFNlTjV3TVlKY1lEQm54N3JzOHhXK0Jq?=
 =?utf-8?B?U0oyNlpxTFZBN0lEa1N6TjdZK1E4ZEVVaDRCU1JucGYreUdjd0NyenVQTzFG?=
 =?utf-8?B?eDMwQzQvcG5ocUI0bFdXTmJpcUZ0OS9VbXBSNFhlSGI4NkVDQ1Q1NEhiSWR4?=
 =?utf-8?B?YzZCNER2S2RnTndkUmpJWWdwczdnQ0NPUW5EQk54T3M3Y1MxTXBKR2ttL2xN?=
 =?utf-8?B?U1JXQTlpTU1TNnJKTDArbXB6MWFML2QrVERNN20zWjlZRjJQMy9Scnp0d0Fm?=
 =?utf-8?B?REpKUkpVNG5rTEpPOHZyaVByU080amxaOGlYa2NTanJMZTNNVnBxcDhNUGM2?=
 =?utf-8?B?TmRHLzdOVGJvTlFCaS9udVVuY1RqUjBWOE4xdHhITTJrSWVDd1dWSElYWEZE?=
 =?utf-8?B?OEZ4a1BCZzI5ZjM1TTRlOGIvSHgrR3ZJVmQySFpjeURkZU5tcXo1M0hRWWt5?=
 =?utf-8?B?TEordnJyN01tSTRyWmQvTHNjdEZPRkVyNlc5MFhaVkttS3JCcVloYnE1ejdJ?=
 =?utf-8?B?aGdtQkZjaEZISk15REdaMGVJZlhMZ1hDRnoyb3Y2MDhUV0hsMVRZRzFZOFFU?=
 =?utf-8?B?Vi9qQWppWU5KZ2pqdEQ3MjdUNmo0Y3VTSjIzWFZCSHg1VmdDMG0vaGJCdTFH?=
 =?utf-8?B?U050MUdES0RkZVN0dWFkb3hHRkFac25nTzFMSWROMDNFbVBMVGN3QzF0K2Rj?=
 =?utf-8?B?NVU1UVZuN1dSVXlOaVJtWWE4RzZCQllyejFXemJ2eUxJRmt1Y0NNeXRVSW00?=
 =?utf-8?B?Mis1dU1PNUJoQ0k2TjNqcDdwRDltelNBL20zSzJuSFpjbGN3OVZDVmlhOE44?=
 =?utf-8?B?SFRMenJ5cGZYeWIwT0RDL2dxcUgrZENSKzF3QlJqWWNNc3QwOXFPZytNU25l?=
 =?utf-8?B?Y0tUNjkrTVUyU0FyenJ3MDhUYjEzOXRmVXBRSForQnE2YzRwTzcvQll5Nk1p?=
 =?utf-8?B?U0IrSFF2RXBGeWtvT0tvZW1EK3R4VjlHQTFaaFVydXVSdU1neWJTeVlWUDd4?=
 =?utf-8?B?QnJiR3B0Vm0vUkgweXBWMEpwdTJkWk1aSE1NbHhDQjloRkpTc2N2anptR2V4?=
 =?utf-8?B?YVV3b2l0ZHFKQXFsUnZqNzE2VE5idzFBR2hDZm1nYVMybkRuSkgzdlEzK2lN?=
 =?utf-8?B?UGFZMWpUOGNYQ1lYNWFhOElFbG1vTVVObERtSG5heTBNVzFFU3N5a1E0ODlS?=
 =?utf-8?B?R3ExVWJaV2t4L0FQQVVyOUEvbFFtaUxRUkh0Q29rcDZ0ZENmclUzSEw4eE41?=
 =?utf-8?B?RG9jd25aZnlZUUkwRlRBOFpjQnVWZXJmZlMzMUhQOGVFNHF1akVobnltM0VY?=
 =?utf-8?B?cEl4bDJvRVMxTWthMHpXNXoxdW0xc25ZdURsaFVUdFVpYncySHVaUFlybDc3?=
 =?utf-8?B?MC9POEYrOWxVaWVENUtLd1dST010L3lJaEFNVnZSaitQMDg2eGtrMHZGM2pi?=
 =?utf-8?B?TWkrcUZQZmluRy95ajlWOHBCdHVpbW1tUjFhYjlVQXN5YUxTMVJjQ3F6ZTl3?=
 =?utf-8?B?ZVNiSlN5RE9oZDZhVVFzWGptL1p2c2lsUG9FVkNYODVMZ3ZIWXg0cFBoalVU?=
 =?utf-8?B?R0w5aUR6UDVUeHgzVk5qSDc1WjB6Q0VpOWUvakRlVGd4U2dHMTRpNTJURHR4?=
 =?utf-8?B?bUZjSmxrOHlMZlp4ZXhaRHVoVnFMcE9UYnIyRWdKRVNqMW9Pc3RuamdNMjUz?=
 =?utf-8?B?OCtVZHFXOUlCVkFiNGg4Z0IvdS9idUVSUUFoazM5TXY5UmpqY1R4a0FadXMv?=
 =?utf-8?B?cEtKRVVwRTdqazBMQ01XS0lGMnlBc2pzUVJNd1UzNTd6L2FhcW5DUitFWU5R?=
 =?utf-8?B?ajg3WnBQWmhmeVo5OWVTWTlSNUJicHhDb1pFZEd1YXAyNTI4Y1NJZHhCb2ZC?=
 =?utf-8?B?UE82dFBTQVZRL2JwSnpWRmRJQ0FNSDNpUnFucUJQd0lKRW4xaTBBVHRab09u?=
 =?utf-8?B?SFVndG9xRGUvbmZEemlLQ1huZEtmTlFmZjcvbVdwUHlpdTRyYU0wS3ZpdGtq?=
 =?utf-8?B?Ny8xZUIvSzlPcnJPU05CVi9FRmQwMnE3NjZ5eElrS1hRKzd4dmN2QXF4dndn?=
 =?utf-8?B?a25RbFFLbUNrSEg5UWJIWXk2UktxWGQ5WDRKQUZHTzM1VUw5elNLQk52U0wx?=
 =?utf-8?B?MnN2Vzg1Mm5OQzZNRmZoWVBpYUFVR0E0bjY1S3NuTGVVRnJabFd3Z05EcUhv?=
 =?utf-8?Q?+KpSVna5cis3qUPKv+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bc0f95-4e96-474b-31d1-08de7439dcc3
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7003.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 06:48:20.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaVAWtFPTvC/EaTZQ4k9YqO2kqpGzvGY9/BbytrDi4Hxc4AsYRMMLiVbf34qD7/k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71799-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid]
X-Rspamd-Queue-Id: F19C21928A8
X-Rspamd-Action: no action

On 25/02/2026 8:27, Naveen N Rao wrote:
> On Tue, Feb 24, 2026 at 11:18:01AM +0200, Gal Pressman wrote:
>> On 23/02/2026 18:38, Naveen N Rao wrote:
>>> On Tue, Feb 10, 2026 at 08:46:20AM +0200, Gal Pressman wrote:
>>>>  
>>>> +static int avic_param_get(char *buffer, const struct kernel_param *kp)
>>>> +{
>>>> +	int val = *(int *)kp->arg;
>>>> +
>>>> +	if (val == AVIC_AUTO_MODE)
>>>> +		return sysfs_emit(buffer, "auto\n");
>>>
>>> My preference would be to return 'N' here, so that this continues to 
>>> return a boolean value when read.
>>
>> I guess the boolean conversion used to return 'Y' before this patch, why
>> is 'N' better?
> 
> Because that would reflect the state of AVIC more accurately:
> - in the case of kvm-amd module still being loaded, AVIC has not yet 
>   been enabled, and
> - in the case of a non-AMD system, AVIC is not enabled and is not 
>   active.
> 
> Also, note that AVIC used to default to 'N' until recently.

Will change in v2, thanks for the review.

