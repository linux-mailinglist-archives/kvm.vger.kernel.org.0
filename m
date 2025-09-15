Return-Path: <kvm+bounces-57622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D41FCB58696
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CB2C1AA7A12
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B382C028C;
	Mon, 15 Sep 2025 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WTglIk3y"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759F41DB95E;
	Mon, 15 Sep 2025 21:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971274; cv=fail; b=ka3wrJnbo1Fy7tW8tZnXtCc52z6y8J1Hsf6wKk5ovUjEwvihMFo+RK2xYIy3EmqesX033NJRdaTqulVrol048outcGRwAZNX8ETz0zZZzNF9JHdvOO+pB4i4in2uo9kgncfXMJfdYbrRMfk7qUrnOtDOqRmncnKNclEXr7pezok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971274; c=relaxed/simple;
	bh=kYGeRdSr6uzx3T7h4/yG6MN6OfAgqsjv4fJHo2p7ONY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CdC7ZyGzLlaQKv7RXYTZz/sAUNEvRq/4jriy1lHQKJ59DXibGECX2IuFsDGc7u0/T7p6CneuGPPzAGVcfoItCWJpQVadEkjLgTur+AGeTio7sqQHlsbiD4doTQjzwHo/wPOd6jgRKfuxzWunSso9LgSgY+j7Tc+YejvsBzLU780=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WTglIk3y; arc=fail smtp.client-ip=40.93.195.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LezVAUi1yFuqj6fJ0aWUtMdovJ//w3wRHq/GumQUA7Gv8HVy9lyoXq1uxnG0EltHTKxmKLFOoBZFOobt/iYndeG4qpB8WGhp3XWZoj8c4xwR1PvUqKixq7ehC52ZQHH2TnQ3Butbiego+eUKFFTeWNF2bzd+a071+bF/XjjvFZ+Xv/qXKqrzlzePiKHuJb44vNLyKCYvYWm3vwgKz2TlyZMzz2fGOuZAO7ykE/OF572GG8hwFN8EP17Aq+8ga5Tiqobk6EOV4C5cCt5NeJkwDlm3s7e5BGTKrqgXsGLw099+TY9Qxr62huBwHhsL+CRuFw3C9m42cx4b8zxI48CVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7KBNRpL+Z0796KUMh2d5iXlfZT9Xcd3MiIIYewghok8=;
 b=pF0EsZ+Gqhs0pYOob8KWPs3F+Tu+imSpe9+ADcf9+UL+H+RCi79zfdbrmvVEjd0rEjg+96MOQDY1Szqa6QE3tW3ry0UreSzuDf92nwX4nTZPXM7CxGI5p9SYkc9jUdBH+b55ubaeWED8Jco52BdrPwdcAMV8EdTkrp3qnEu5jGNNLnxl18DexAQryRcsbimgReEFKIc6w+cJR/sXFDe5Fhc8eEGBCVtVo+k0jmc1LffaNaYHRarNWDAbVuQ8NVoIrThVxhhVvXXV2YM2X2WaVJIAZlv4ffFrPpGx/kwKIJDJzP7nSbufPHN4f8POQS2k5qQl3pdYpMTJgYkm+j0ndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KBNRpL+Z0796KUMh2d5iXlfZT9Xcd3MiIIYewghok8=;
 b=WTglIk3yJFdNtwiZJdRj7jXjZHJ1tYRfnxzeFALP/gMmv4yi6PnROZTY7awif5UuuvxpH6+HTl7D00zk0DcCRyBcD8oCimWbwHp1Wbo7NKFGAhxqkJnEkCFU0/HLraqEgMCsM5uNmZ/TfR1rjB9Leyf9j60YEEjp0zBF8i/WBmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by PH7PR12MB7137.namprd12.prod.outlook.com (2603:10b6:510:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 21:21:08 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 21:21:08 +0000
Date: Mon, 15 Sep 2025 16:20:56 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 00/41] KVM: x86: Mega-CET
Message-ID: <aMiDOGwZXWbl9OEm@AUSJOHALLEN.amd.com>
References: <20250912232319.429659-1-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
X-ClientProxiedBy: BYAPR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::14) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|PH7PR12MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff12083-56a8-4cec-13a6-08ddf49dc93a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BL2v7PDUbd6bLo/pW+wHRgA708oVdLpNahepnVhGF0M7eLeUTUcTEQoJK9nz?=
 =?us-ascii?Q?RNNHfqi0VAuVZJz8JFyd55dFj08v2MxAtbxaT1zl7T4RRcJeHxoyyMbn4lWq?=
 =?us-ascii?Q?Ncj7SPArWYi0TjsNPbmugIJ2N8pm9SdgFFu6Nj9DSd731zsiZMtWFO0/bo/z?=
 =?us-ascii?Q?C+5fzqcgHb3uUitK8YyTiWtMBzx1X8YyYtn4JDg2DHisb06dHyBcMP1DZAJg?=
 =?us-ascii?Q?w4SOg1vjWRfkE3D0z4AoeT8vkI+4C6/QQQvaGi3WVzxltfuDScvzpH/HLXGM?=
 =?us-ascii?Q?OQX1cbqCVSl8TBuasFungX3etDGcgC7zmpvWaR3t59Cz3ifEjKj0fgKpGb4G?=
 =?us-ascii?Q?F70nfDyuruOrI5B3Yzp79D/05rDkzLc620KH46G5k5uC3YjbElOhCmiOoIv4?=
 =?us-ascii?Q?0LapfuMqUZaPVy/tEZnhBnXU3mpaLxLsVtifIe0SXHX0k1NLIjQJlvz2DeDk?=
 =?us-ascii?Q?wS0I12YLca3yZXvZk92QYhg+j64JVjo+WL14ZdIWp224MjXRTZOmuJ0bY77C?=
 =?us-ascii?Q?CxfwgGkeajinQJHcl5K4xp27+NiaXlrGbiEA0Diuh7G2e3+iSKj3A8ETw1cP?=
 =?us-ascii?Q?JDDA6rHEbmRdeqvAeDmEsyFD2aBQo7GOQmqqFhZSgOy4w8Da4xMtspf/MTf2?=
 =?us-ascii?Q?et3BBwbjVCib8lQ+A1+vDVwBIkleeofvA5/tM5jY+HDlPkh9j+iGChMYGk1c?=
 =?us-ascii?Q?4v7TP5VvqAx5XziV8koiu33e84/+Rn/zpirV9/mJK92y1QuVEmQN/OUWsfVK?=
 =?us-ascii?Q?zIvkEreB0Krns1JLG0xBXKBY4GJak51Y+tp0OVrk5Pur6pgwAhqyoXUbJuH2?=
 =?us-ascii?Q?D01DI13SVfT0VCh7tOXek49G7wEJZ/DI7aQPw7iy93Eg/UzuK1p6224At+8k?=
 =?us-ascii?Q?HTO9iG+NFs6hxOjkcgaQMARPla0zZ8IPQD0MG8oceobYfGZZc43gzZfR5aeG?=
 =?us-ascii?Q?wYR4icAZKu6Xh6GJ7HCpOZpI/zH5LvnaYa3Iw1UsqJWaZmKpVgRzcS3jVu8D?=
 =?us-ascii?Q?V79kOIloaJe8teoz4MDg/SV10SQOUMSBCGpOu5nOP8BqkJX9vk4anf8JZeEV?=
 =?us-ascii?Q?aKYXR0dPfKka/UIprUUaXGamlaN9WFmFVSQtm8fWB2OKGI4+BI4c1xj1C6fg?=
 =?us-ascii?Q?okAyVGdDG3Dhe8nw9/ZFiwFns6esxOHQmFwfqYxO3vs9STrGL4d5dwgJqlOX?=
 =?us-ascii?Q?4STXmelIjK/MsZpeTzV13DuEmdR6iLzKPd+t+/h9Fjdt/tvcP5+aO4cVkn8u?=
 =?us-ascii?Q?WNhmJ3rRnqZtsFbQE8QPyzvF2YF5PlUAlPy/99Fgbbzcz1QOKW8gv7czlC5E?=
 =?us-ascii?Q?NfT4bFzvrFNANXMyFzLneEINiGLJ4ALOf1IuzcYHSZFIG5e19S7q2rEN7fF8?=
 =?us-ascii?Q?aqk8jA1jYF7ALq241WefCmiPxJf0Nxkt/rfoqRJkx1vxEhwpHcTtVJrnVgwA?=
 =?us-ascii?Q?kBxsWprjsvE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ggqloyyqehKaDkEmRLFB4TFIDGD0KQOjNriPutg6SwxpLwi0Tbkj1jLHp+nP?=
 =?us-ascii?Q?98t5Ecn023MBfc4VqNue/nieavDx5TuDnF40Buc9muJPxTXVN/F7Bew+s1RL?=
 =?us-ascii?Q?7Plosh3XYytWEJXjBXa9NLFeCEeTx97+UqczpgK2O5b9fn/z0LIpF5gFkyMw?=
 =?us-ascii?Q?wW5QLnR7qDDyOB1XDJUT/t59CBOvgDJHKO5pY+3SSGL6ZVI07hzn2Fghaj+m?=
 =?us-ascii?Q?ubBpmjxqDRSnojXFS1+rezZ+B9pJxgrUPJo/wYt//oNSoY2/A5edIzo2XP71?=
 =?us-ascii?Q?BPy1xDT4UPTdm/pphIUfzztLFg1IcrZoivWXtYY3bfdb5s9dIfpbADhbPItq?=
 =?us-ascii?Q?w5wKANs/DICV5O0Npym976sKlzTIvJmJBIr/akzWCbzTgqF0CQ5aLPFe4ct1?=
 =?us-ascii?Q?psBvA8IxSSfokQx1AxRkCUHMFupPamC1RNXf6yQG+32E6bbJjGMCCmjS/0fy?=
 =?us-ascii?Q?OCwgFG8QFzH/hiGlwukbwck8kmjo5FqpGAjugJmRSkV/oTqPS1Pvj9jHS/vk?=
 =?us-ascii?Q?sueT5ZR+iZ/q/Yvn8qsagPpjibqykM9+WAFntHyMIUL7BmYg4PfTH1IUKUDP?=
 =?us-ascii?Q?GBig8HI/hoVs9KrEXXDNzvDLGAoJHcvkv2454nRh4Os4bUptHG8jhaC6WZyQ?=
 =?us-ascii?Q?pZp3df2zCqQsvz78lUujnkrtWcdRF05k/yNPxs/4LgWnl04gngAK9K8t3Tp4?=
 =?us-ascii?Q?jt6Mg0ixTehPqoCBCjZArAow+fMauCWAUMbsZpNxRBDynHZ91YG/wR0gVpEq?=
 =?us-ascii?Q?luZTXKwjdmmdLB18di0UVm8Qgdr3V3dWUIV4EPTLoL5G2Q20MiM9+6ltVijX?=
 =?us-ascii?Q?WazD1aBGwOLLLozaKksQdrUpLRWZ/5sfoWo908D5TFRNByPgFIcxsx/Oo9RN?=
 =?us-ascii?Q?Qglma4POSr6UuW6L7s5F5CEVN+y0rtK9VCNDLsESMECByhEmO3TI+ScMWIU2?=
 =?us-ascii?Q?6WE73ycCbouvGviurz4rdRdu6/LlElnHNSXrox5Js68Cb9pmdpZskeTtPt8Z?=
 =?us-ascii?Q?L2eI0LSSRQYcJE7HLTorUUqwaTp8DLq89yiSsfPh0p6U9E012ft/9u0as2xW?=
 =?us-ascii?Q?V/YWwijBaGV/SAl38uq/AJtjRJILHjb4TFhvojrLM+oLcJQhIrxMJawK5IMW?=
 =?us-ascii?Q?S5KwFNBF9xdaQxcmRMlmZMvf97xttGmLE0O6ZMAfe1cIVajcUKynEs3QfHjU?=
 =?us-ascii?Q?vKCVVF4U0LVkvSI7EiYirWnWEfK8onBpPHJeM4TvFbyjjp9njAlRp0MseYrW?=
 =?us-ascii?Q?j3+T1sQBM1+EW0z3KQqhIlMSd2Gg9vgppb04KNoKMrHbCbz8BXjbow9+pW5V?=
 =?us-ascii?Q?bqeaxxM0s4Mup2cQgQZOUcrUCxMj6i59jeIDU5RK8wvlTH4JGWigDyHPb9BD?=
 =?us-ascii?Q?0AQoIPYZjyMen1APbxx5v66NdXaEGuoFSMERMQZ28fVNT8UoSVkHL/UJdSIX?=
 =?us-ascii?Q?wJ4TlvjTUPDrDPH7OaYi7S2Hf65nXRsTeErW/mTMqIwT0r4ioWg34kuXsuV4?=
 =?us-ascii?Q?8EN20HTiTtznXE+anGKrEhr7aBB68WLLWNKcpEjjUWdZG5NuLaAKYz2hUMby?=
 =?us-ascii?Q?E2YDGHwGfJmxVMwK/wrYJ6LAVMYAyRMbG4fBPzh9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff12083-56a8-4cec-13a6-08ddf49dc93a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 21:21:08.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYHm0RixayDEVkLDh/Wa//z7z9+zvpJvd/VCFsy9cRt3kjYcFoY5ewsWIohyVg+o6hOnmWtiH0q9vIkRZyI/iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7137

On Fri, Sep 12, 2025 at 04:22:38PM -0700, Sean Christopherson wrote:
> This series is (hopefully) all of the in-flight CET virtualization patches
> in one big bundle.  Please holler if I missed a patch or three as this is what
> I am planning on applying for 6.18 (modulo fixups and whatnot), i.e. if there's
> something else that's needed to enable CET virtualization, now's the time...
> 
> Patches 1-3 probably need the most attention, as they are new in v15 and I
> don't have a fully working SEV-ES setup (don't have the right guest firmware,
> ugh).  Though testing on everything would be much appreciated.

It looks like there may be regressions with SEV-ES here. Running the
test_shadow_stack_64 selftest in the guest now hangs in the gup write.
Skipping the gup test seems to indicate there are some other issues as
well.

This reminded me that with the last version of the series, I noted an
issue with test_32bit selftest and sev-es on the guest. This would
segfault in sigaction32 and seemed to indicate some incompatibility
between the test and sev-es as it could be reproduced with a stripped
down version of the test without shadow stack enabled. I'm still
investigating this as well, but the above failures seem to be new.

I'll have some time to investigate further tomorrow.

Thanks,
John

