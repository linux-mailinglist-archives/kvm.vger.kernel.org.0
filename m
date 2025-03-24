Return-Path: <kvm+bounces-41871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2403A6E5B3
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B19B1892863
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491301DE896;
	Mon, 24 Mar 2025 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NUYxA8Dj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAE15E96;
	Mon, 24 Mar 2025 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742851914; cv=fail; b=JO7DcFZuYAg+doyi1fO6JO7cSpG791N2kROLN2XFD9YSOvgcRwxMkjqsqjxlK+8+qNi6pIZ1qQfViSQ2jyC7j82Ox8kKjt15j6HVMNJT/HZwp312XOeKrnx5qQWUYhUr7S31iFlo6zVUq8KrwckG1K+1LCA6wmFi4sBSXjd3Na8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742851914; c=relaxed/simple;
	bh=sZIJDxFOYUcGEXCezk1TuzQcdvQhbLWzG8QTN9K6SXQ=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RpjX7JwbpbPneFc9cWsWklWAI9PlMrgNR8jt+vXsAgCC5DR3wQahNQXYvJqwhd4+7OhMK4m2mJvNwmtn9QNIUSAyeeHtih2F+h2LTjpfj0XAbweXgsme8G6GoE4AFmxdSa7Z4bsgwHd2tSfdN2D8EwL3ARBpMbcjEO2qWm9l+1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NUYxA8Dj; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOqyn3EKZ8LFVnNRPR+SRUQXlj701IUEpT+QB8Z0xAg9YlUvcT465zjSj/OE/ijPLyYgiwbTylumUipq/nDRdWtTNAuUZFiinxO72ZZylBJFKLB0Hb+kMceJmpPlN7vP4Po4yaDQjKikja2sc/JfVEt15TX0hTuXAjTzCDUnLQDLxEmfwqTjZDMAUtjg0OM55vsLA9VPb2k8EPjD1Vyj0d66TDLb1wM/gItiBm9Z53RE8+qkqAOHIdW2minwh2B0CWQ0htIYBCfJAlPDOCIINQCX4rB8/z1MZOBHkssDUZnH3AYbpUGBxCB7j8chieVoEQ1J07vnUQyv7rXZe8/x5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEQwIdlAQD6qfAqPaE56JuhyB1C8aWYuMWgmyKPlJpw=;
 b=L4AM+jqVDguaGkD4PJyOUQHdIkiRvMUBhics+iZutroedDCUhGwemAxY6zCCGoJLHi1OKlwcTIUCom1YWgBAaAZjFUz0gc3hCGER+Cl1eTOMS3+qECR5s1RYhxL1q7/s2fNDLY3g1KxDet4uLni14oFc1qTrQw9g6P+lF2PpVZyoqFKOb3O56An+pSigJNsbzeO5FcxsRZDR8KPI8CXGTbVxDQhg1JfJjXfNzHVCnJ93B3fI11zjjWsSwvZxt2vvSYSOgdVWFNOo26QEPIL2X6BcmlZzZ7Jy/oxg6CGJYuNps3txfljmb8YizqWZL3s+LhTpkpCdcenlML5wAYaB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEQwIdlAQD6qfAqPaE56JuhyB1C8aWYuMWgmyKPlJpw=;
 b=NUYxA8Dj9ic7oEsN1wYUbb8ACZnOUkAgB4NYm3Z+R/T6fRj50DdJ2ww14JiUE95ufPopWYkwtUpGXOFMD8i4L3y3Fz9zxfN3IfbDIfhKuALuGfWYuZ/GbHwHWPAXPXmHj+hEBeK0DTekcv411Wn50GW/lJ+uyrCwjAnvGfo2zOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8851.namprd12.prod.outlook.com (2603:10b6:610:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:31:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 21:31:46 +0000
Message-ID: <a06ed3bf-b8ac-15b7-4d46-306c48b897ca@amd.com>
Date: Mon, 24 Mar 2025 16:31:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if
 debugging is enabled
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
In-Reply-To: <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:806:130::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8851:EE_
X-MS-Office365-Filtering-Correlation-Id: 186ceadc-8963-4970-872a-08dd6b1b479a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVB4QzEwdjFWOVhQTWF1NFFtQk44TUFOK0V2MEtSTWs4SS8zQ0FaRDhqZnlh?=
 =?utf-8?B?eCtnLzMzd3NjNFRucS9Pc3NLYy82ZUJHanI0Qm5wMkJnOXFCcVVHMGpTRnBl?=
 =?utf-8?B?NjQ4Rmh2OElweFhsZGRWeGtCYk83NXlFcWVUeU4zMERWOTZoZVNUY0E1RTFa?=
 =?utf-8?B?Y3p6OGNlRFhteUdUUXpQY0lTOEd5Z1pDUEJueHNqSGt3NUQrR2VCUC9JYVcy?=
 =?utf-8?B?QWJ4aXYwNCs1bHBRSDZmSDM5dFZiQ05BcjQ4c0x6R1IzbWQrVUR5MDREQXlQ?=
 =?utf-8?B?d0Vub2FQZUE4VGJhVXpnTkdERm1wS2tTeGtaWWsvUmFhZUU1eU05LzRlVGht?=
 =?utf-8?B?OWN2c2xlTWxJcHBkRUJSMzY0REorYkIyK1hGdkNIc0ZIZkZNNlVkaDNBQ2dY?=
 =?utf-8?B?aVhrVXRWYzRodFFBUitIUlVnMlljd2VjRkpRdEJIMDI2VUgwQ0J1OGZ4UUlS?=
 =?utf-8?B?bWJsQTZ3UmhyZjNkNDVkYUF5cGFpWktrZFVMSTJPaVhUOEVnb0ZaSG9kL1hM?=
 =?utf-8?B?aUtrUUJBVEpybUJLSHc3K3FNVllKWlh0Q2lQN08xekZZWS9ldTZnVmpnMHNs?=
 =?utf-8?B?czM1OVljak42b3p2Y1QxNkFGZUFuQlVFdy9CNzZrTi9qdlQ0aGZTVW1tVXpM?=
 =?utf-8?B?SXZNY013b09Mclh3emJjMlRhbU54ajZVZ1EreEZkMHU1UE54aWtGbHJhdDV6?=
 =?utf-8?B?SElQTzJydlpZeTJHNGhaQ1lMSGdLQ3o5Z3hOZnowTmVCdDFWQ3NnSHVIZFZ0?=
 =?utf-8?B?R2E2c1RGUVpKeHNBQWh1ZDNMd2FDVGIwa3JSb3lVNFUvQUJBN3E1MUFickU0?=
 =?utf-8?B?RG9ZakJFTTNLTDRPS0pEaExRd0h1SXN6bFVkT004a3R5NTV5N3ZCSXFXS2Qy?=
 =?utf-8?B?SXh4cEU0V0VBUHJ5NmY4Q3I2OTNlL3ZrdlpDWFJlSUNLaS90amlsQlVzRm1G?=
 =?utf-8?B?V2IvKzdncFVoN3lka2FxcDVNQU5WQ0pmVzZMb0Z0SjNUQjdqZ1JpRVBjY1Y0?=
 =?utf-8?B?OEJOSUQ5TXJhSHpWUHc5MG5ob2ZwMG1TQlg0V3hsYjVDSS9SYlVnSWpSZExr?=
 =?utf-8?B?RGRXdXplaCtnUGU1RGJoeGkvRWQvUnJ2UkVtY2I5aTFESE41MEkyeFNKTytv?=
 =?utf-8?B?c1I0YnBMeGhHM01lTWZyNVNyYTUwbzVtRzNPNzFzSFg1UXB2N08zVExKenls?=
 =?utf-8?B?cjJVTURVK215MXA0NmJ0dU9yaC9BT1QvK1Z4SnlwcDVWSXFVaTFGYy9NM3oz?=
 =?utf-8?B?T1JTRjFENENpQ1BsOWZQUnVZYWVQZ1doNXNQSjl6SVVJR1pvVFkwK2Y0SVF6?=
 =?utf-8?B?VUUyWU5QL0VheEh1SmEwb255d0QrR0VIcHJVNWswTHlrMDFGSW95OTFHVFJp?=
 =?utf-8?B?dnFVcEZWQTJaeVZDa1Irc0k2YWpDUC9kVTJ2N2FsSUtuMTVIbi9VbEJUclh1?=
 =?utf-8?B?amlqR05IRkdWOW41QXdUOEx0a1d1cHArZk0zU2hhcEdVMWlRRjZUMXA2Ylkr?=
 =?utf-8?B?QkJTdjJqOWQ3R0F1dmU0bGZFaGpVSU5MTWx5UlVUSlI2MlFkT2swdmhsR1lX?=
 =?utf-8?B?Qms4RVNDWkkyWjI2ekx2SURSeHVOY2h0d0RBbWhxd3JCZ2x4R0dQYmFxRGdl?=
 =?utf-8?B?cUVOS0htVnZKZGYzUit3elplb1hNNUdndWd3WlNKaE4zS3NhYXZwaVc1V2M0?=
 =?utf-8?B?c3FZT0J5eFMxaTBsY2t3WGE1VFpqejlQWkdLaGtteDhvZmhadnU5NzlBbDZz?=
 =?utf-8?B?K1h2UUdoM1phZnhtWG9yYnBSZGFMQnBBaUpJczNTa1hkN0piK1Q2R3RSZzlD?=
 =?utf-8?B?VnBJc05KWlRtL2hBdFpvQ3lYNm0xREZOc2o4REMvUTRIOWY5TVJjbjJyQjNZ?=
 =?utf-8?Q?L6Lj7CkM7+TfC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnkrcDRzSTNmWmZudDhsZ2ZMQTdScld0R010cW0rdERyRyt3eWVJQUxkNnMr?=
 =?utf-8?B?Yjc3dVpmcitDSkM0djVSLzNBWVo1SXJHM2FPMlhtYmRodnNLRC8rWFA4TlVs?=
 =?utf-8?B?YmxGYm0xeUQzelFFYXJCaHRWamROK3M2ekhNNG12THVRTkk5YVVTcjJaSVVM?=
 =?utf-8?B?V2lvUWlGZmpvYkVoaU13OEwyd0JxejRHMGpRKytKaXhsR2V4bVdoRUJDdFJ3?=
 =?utf-8?B?Vks1R1phTThwWXNrSGRKb0d6SFVldmhUUWt5U3UrbWNtSkZQTE1aR3dZT2NG?=
 =?utf-8?B?cXl0UWJld05CUEpBV05IODdyR0l5aEtBeTlvN3BwcU95aUlmTXdlQ3pzTHpB?=
 =?utf-8?B?V1dycWdDR2pYK1RXOU5RREV6UUFtZVhDVEpRcXg3VEhDeGw3TzRqUmdYakI0?=
 =?utf-8?B?bHJsTnV0SWtUNEw3NjNmRkFRanI2Z0xtZ2lqWlNXWDNkaHBVdm5ieXdldENZ?=
 =?utf-8?B?ZEtHNUYzTndoL3RGczVKc3pqMVNLNEpjV2VUK3RNVlNuZkFTUy9lajVuZ0oy?=
 =?utf-8?B?N2pjUjFxN3h0NkNxSlpFTU11cm9HUHNaMVFLOEFkNk9KelZmL1BvMmNXUXc2?=
 =?utf-8?B?T1VKNWYxNnNhVHVPRVJ1M28vN1dZbmpTdlUzMGNqeS8vd2VadkxqS3RleU0v?=
 =?utf-8?B?aUpGeDFwQXp1a3VBZEI3VHgrQjcxSkViNmltSHNGZHBPczRuUmhvMnJyVnhi?=
 =?utf-8?B?cDg3S2ZoMFlvRGFZSkh5Z1lEVlhQS01yYmtOaUtTc0l2cDBGdHFUaFZsYUpC?=
 =?utf-8?B?eGF4Sm9MZno0SEFhZkhnNStDMWR4bEhWd1d3L1FIdmVWZkV3bUZyN1BnUXlD?=
 =?utf-8?B?bk1WWXpRM1RRSm4rRXo3ajlZWWNIdWJaazBRUTdsODB0Vm01S1BFUlFzb0Rt?=
 =?utf-8?B?aHlDVEV5QTJrd0RQSzNKczBGU3UwZ0hoSEs1UlVJdU1iSzNKQUltN0ZxQjZ2?=
 =?utf-8?B?VEl4UW5WQ2xVNjhiZWdYNm9jVVE0UFhZajAxdzhwVnByK0IzMm52Z0FpVWJE?=
 =?utf-8?B?OXFlZE5BMHJhR1IxQmZ3YzQ4eGZ4WmpyTU5iVHV3NlFwYjFablNNVGJacXRV?=
 =?utf-8?B?QjZIUkJ2TFpoc1FqajJ1ODFNbXdycUpzUU5YUGs1OUxBZGtsT2VaMFRMNU9K?=
 =?utf-8?B?b3VvMVQ2Q0NLdEwwb25BRzU5bVJvejdWMkNZOTlnRmttOUdHRXplVkZ2SFU2?=
 =?utf-8?B?c3p4VVhOM0dQenFRcjhuTEJKc0dlcFlCZm5wQ2Z3TEhFandSQU9tVERWVlVG?=
 =?utf-8?B?VGtyTk15QmJrUmpLUzBlRzBPd2MyaE43alV5OXJNZzJXUVNLY1QrUis4SVJ3?=
 =?utf-8?B?eFRubXRnY3VTdzB5KzFUT3lVSWRLMkU0OVA5V0dySmdQMmlrS0RkN2dKK2N5?=
 =?utf-8?B?SDB1clNWQWltYUc2REdoR290U0YxRi92M00rY1VRWTF2Y3ZTaEVib2RJOGxT?=
 =?utf-8?B?NU1YMjFvbkErdk9jbUdRQUd2YlVENzJFSFJuU24xbWxVeDE3TnVrWFE2KzNY?=
 =?utf-8?B?RE5lSEFYdUx3RzIvUUplTHh6dk10MkdYMjJlelUrTldkWm5RYzdJbTcxZ2Q3?=
 =?utf-8?B?WjBxMDB4cmpjOG9CUExlUGRBcHZFcURTSWVDcWhDRS9wenZBUnVJZStwRUZI?=
 =?utf-8?B?eU9ha0xxSEFJdlRJNzZpaGx3YTMzMTJhaEE4MG5Fc2FDNUdXcE1Bclo3QVlT?=
 =?utf-8?B?dzRveVpGTDVaZlZIRi9MVHE2bWZFeStibnlleW1pUXlKNS9GbUVSR0dsNUtn?=
 =?utf-8?B?VU1JY2dvWHgybElibU9JdEozNWlXaVFrSlp2dWFRQXlkemtDbTFmNG1uVDQ3?=
 =?utf-8?B?bUFzWlJqT0xmelpHNmN6TGdKVUlGVmpKakdqZkd4RzJ2SklIL2hlMXRYMXVZ?=
 =?utf-8?B?OUh2SjJiQkVPMUJrcTdBM3BncjBrQmsxa3V6RGxqay9kQXpEM0NDbFFVc2Jt?=
 =?utf-8?B?TzV5Q0hHRFVNQ25LRXdRYTIwbXVkVDdwb3dFK3lkNVppTTJISWRBMHk5MFF4?=
 =?utf-8?B?MjNWRHhzc3ErWmlQa0FKQWg5SjZMMWxGNmt6MUx6aHFZaHluVERnbWJObHRu?=
 =?utf-8?B?dFM2ck5IK1JIaEJvMU0xcXNsTEgvLzNuOTh3c3lCbm9FUE1lcElDSmdBbjJW?=
 =?utf-8?Q?phtgbHXAi3MNbyxun5pOIj/1v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 186ceadc-8963-4970-872a-08dd6b1b479a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:31:46.7731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1LeL6JRWsw475FHD1TY+CtZHPbPIUbsPes5EXNhPIlIRUIRllHeQa/VSyWX2msEkhOt2EpakmhTBhm+kmhmXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8851

On 3/20/25 08:26, Tom Lendacky wrote:
> An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
> policy allows debugging. Update the dump_vmcb() routine to output
> some of the SEV VMSA contents if possible. This can be useful for
> debug purposes.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c | 13 ++++++
>  arch/x86/kvm/svm/svm.h | 11 +++++
>  3 files changed, 122 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 661108d65ee7..6e3f5042d9ce 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c

> +
> +	if (sev_snp_guest(vcpu->kvm)) {
> +		struct sev_data_snp_dbg dbg = {0};
> +
> +		vmsa = snp_alloc_firmware_page(__GFP_ZERO);
> +		if (!vmsa)
> +			return NULL;
> +
> +		dbg.gctx_paddr = __psp_pa(sev->snp_context);
> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
> +		dbg.dst_addr = __psp_pa(vmsa);
> +
> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);

This can also be sev_do_cmd() where the file descriptor isn't checked.
Since it isn't really a user initiated call, that might be desirable since
this could also be useful for debugging during guest destruction (when the
file descriptor has already been closed) for VMSAs that haven't exited
with an INVALID exit code.

Just an FYI, I can change this call and the one below to sev_do_cmd() if
agreed upon.

Thanks,
Tom

> +
> +		/*
> +		 * Return the target page to a hypervisor page no matter what.
> +		 * If this fails, the page can't be used, so leak it and don't
> +		 * try to use it.
> +		 */
> +		if (snp_page_reclaim(vcpu->kvm, PHYS_PFN(__pa(vmsa))))
> +			return NULL;
> +
> +		if (ret) {
> +			pr_err("SEV: SNP_DBG_DECRYPT failed ret=%d, fw_error=%d (%#x)\n",
> +			       ret, error, error);
> +			free_page((unsigned long)vmsa);
> +
> +			return NULL;
> +		}
> +	} else {
> +		struct sev_data_dbg dbg = {0};
> +		struct page *vmsa_page;
> +
> +		vmsa_page = alloc_page(GFP_KERNEL);
> +		if (!vmsa_page)
> +			return NULL;
> +
> +		vmsa = page_address(vmsa_page);
> +
> +		dbg.handle = sev->handle;
> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
> +		dbg.dst_addr = __psp_pa(vmsa);
> +		dbg.len = PAGE_SIZE;
> +
> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_DBG_DECRYPT, &dbg, &error);
> +		if (ret) {
> +			pr_err("SEV: SEV_CMD_DBG_DECRYPT failed ret=%d, fw_error=%d (0x%x)\n",
> +			       ret, error, error);
> +			__free_page(vmsa_page);
> +
> +			return NULL;
> +		}
> +	}
> +
> +	return vmsa;
> +}
> +
> +void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
> +{
> +	/* If the VMSA has not yet been encrypted, nothing was allocated */
> +	if (!vcpu->arch.guest_state_protected || !vmsa)
> +		return;
> +
> +	free_page((unsigned long)vmsa);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e67de787fc71..21477871073c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3423,6 +3423,15 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
>  	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
>  	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
> +
> +	if (sev_es_guest(vcpu->kvm)) {
> +		save = sev_decrypt_vmsa(vcpu);
> +		if (!save)
> +			goto no_vmsa;
> +
> +		save01 = save;
> +	}
> +
>  	pr_err("VMCB State Save Area:\n");
>  	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
>  	       "es:",
> @@ -3493,6 +3502,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-15s %016llx %-13s %016llx\n",
>  	       "excp_from:", save->last_excp_from,
>  	       "excp_to:", save->last_excp_to);
> +
> +no_vmsa:
> +	if (sev_es_guest(vcpu->kvm))
> +		sev_free_decrypted_vmsa(vcpu, save);
>  }
>  
>  static bool svm_check_exit_valid(u64 exit_code)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ea44c1da5a7c..66979ddc3659 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -98,6 +98,7 @@ struct kvm_sev_info {
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> +	unsigned long policy;
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> @@ -114,6 +115,9 @@ struct kvm_sev_info {
>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
>  };
>  
> +#define SEV_POLICY_NODBG	BIT_ULL(0)
> +#define SNP_POLICY_DEBUG	BIT_ULL(19)
> +
>  struct kvm_svm {
>  	struct kvm kvm;
>  
> @@ -756,6 +760,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
> +void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -787,6 +793,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  	return 0;
>  }
>  
> +static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
> +{
> +	return NULL;
> +}
> +static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
>  #endif
>  
>  /* vmenter.S */

