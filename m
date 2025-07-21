Return-Path: <kvm+bounces-53021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCA5B0CA54
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 20:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52C49189E4C1
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 18:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4D22C15B2;
	Mon, 21 Jul 2025 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RYHWG+8t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF28D2E11D2;
	Mon, 21 Jul 2025 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753121323; cv=fail; b=U+watUDDC5jKXtcYyzvHlHks4Lcz6gGI+vS5VJwEjzjDjBhdGfDAZmkRb64RE2hYNZxx7XnGhkOl5r71E6xtyYflGfon4cSotRjQWg1hHcVPgrWdezZ9hU4rvpYwd5hHNHB6TwErCil9sbhohPZPxjVw3uxp6JuyGpIHS+Jz08Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753121323; c=relaxed/simple;
	bh=lStUbaWZCQbB720u98MmMRfAbjqfMkg8IQbuTtYfFzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZnipFYfVT6m2TIX587vY9NwzPH0e3c6rRMerxx7jsixvE5VDTi2KwJwSEbSfnST9xAT+CsGkBXh2f5W/FnXk6cmr12jGBFpc9B7sbUGCafZNnDlPKFUYWddCSPUlOz6YuJFqsNDVapr4t6F95rAMXT8tZKPAfp3QX+/9fWxgpik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RYHWG+8t; arc=fail smtp.client-ip=40.107.100.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v4J/EHxukUsQ69Bx7NtQrIoFm2iJTW5dHc7e/G+nJC7kvwAqBB6qibsBiQTAgsEpc1EtG5NZ7nkFTTG2Hlwj+4yOVCvHPefvJjuy2sYblDl7nU0QKsTpVsRgb6xhMM4iErs2tTwQkq/7NWygvXZkKNwna7eQWJaSuivsls2gUYTES9XbxGfS3oiJ8GyESdQq7vzMGJx/UNm/P06cMxTtd6vSR8ZeIbWJKQ9hU5CJR3MHKU29Ku7WLg22+EFZ/V1oLBNzDrEkTgUk5YQEQqxC15tTQmmKahhQNrzYERLnrVm0R46c1GsJmjxSHOh9SaDsTkvhB/7w43rg14RoXCuBjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbTIdypE50Z2nNTJ5YT3EVNOhxGJZ6r8eyP2O1uDBUI=;
 b=sKubnlIakqZ8yZtZ4ZbgirjvyJF27sBfmfXdS0gBTTbM2wL4vXcjbTXiPXfPCApS883DDmodSprgKtfhcM4PyNnDZrYV8qLkDJHu71HxDRfCVt8RY5UBJ4CzJhb1TRq04upyKMxfi/h911xTRKMsbERbAEF0yoTPJB2+aCFUEmx0Xy6BMMzvI7x81iyv8szCm7DleEvYFLuB8+BstzPzPPVBQxO8XqPlv+Ok0brjTdhU5QPHFjI8mSxB3UJGHiqJMb9mcm40aGrLW6kg7VtNehlOYmNeAZVnQspjIYIeM9+MYztoKFj83BymjujwpznI2E+PaCx0pWu5rb3QE+3HnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbTIdypE50Z2nNTJ5YT3EVNOhxGJZ6r8eyP2O1uDBUI=;
 b=RYHWG+8t4MScLRH/NlvuZF+PXoW4g+4hqyB2aSBRr9YvKdOiK7AErtReWzeZCusLyfZ5puQluEnC96oJGXD2RHzdHjEkpNZ1LmS3WsbRnihACEK+CBZZeuG5AACLkupUhgNn2koPbqGCc4xBJv44Zau2vSl9Xt6HLLA/FNKo0L0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by PH0PR12MB7885.namprd12.prod.outlook.com (2603:10b6:510:28f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 18:08:38 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.8943.028; Mon, 21 Jul 2025
 18:08:36 +0000
Date: Mon, 21 Jul 2025 13:08:31 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Mathias Krause <minipli@grsecurity.net>,
	Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, xin@zytor.com,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
Message-ID: <aH6CH+x5mCDrvtoz@AUSJOHALLEN.amd.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <88443d81-78ac-45ad-b359-b328b9db5829@intel.com>
 <aGsjtapc5igIjng+@intel.com>
 <aHgNSC4D2+Kb3Qyv@AUSJOHALLEN.amd.com>
 <faf246f5-70a7-41d5-bd69-ba76dfbf4784@grsecurity.net>
 <aHisz7hU0VGsf78Z@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHisz7hU0VGsf78Z@intel.com>
X-ClientProxiedBy: SJ0PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::10) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|PH0PR12MB7885:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b34c6ab-ef77-4e9a-7f7c-08ddc8819cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gcTL01GScwTjbYldZjxW2u7CU59hIYdHydinpp5hP+MgScjfsZKAxOstG+j1?=
 =?us-ascii?Q?wZOQxS1pBCN84fb0fXoP+HHlWBnd90c3CbDYkrCRnAC/yyJTJvhXoaGE6rH2?=
 =?us-ascii?Q?6kQ6sSUzzUksGXSJ+fFf3C/gYz6mwQ1EK76hE7Ls/VS/3PYNnISyq1FYPdUg?=
 =?us-ascii?Q?s09Rr4lVa1Rry8D/9/yGQCD99meHDiq3/StNZEyjRA0FVNdlvUXQaLQki9M7?=
 =?us-ascii?Q?0ydzBFLpr3UTgxQnEijMOCHrbkH6Z2glrHRZx2gFNEfUFt0E8g0YlqwTGvdO?=
 =?us-ascii?Q?jyPtwd36/5UIlJ+5sppVPvFajEzVtvInd4N6DhWNtpAk0o57SUF970HrMjZA?=
 =?us-ascii?Q?GRN8vJgdlmHPYYqQuUP7LxUUE/8aJ/p2G0QEUdvf4mpHw3/hyWqkUs4lAqf5?=
 =?us-ascii?Q?ZSQOte09JwouR534IE2wE5y2sazsDjficsB6IRYl2l1K+N/yPv1O4MlD69sI?=
 =?us-ascii?Q?J1edTWzTkPuALnJDzEs5IMPYVhJP/VQeOEA24SOmlwFQBdH1dxNEbneZbRgW?=
 =?us-ascii?Q?BS+2qiT234iN7nOIx2/NBdE6prnYd+Yz8h0/r8bifTe8giEywc6k/vD5+gBy?=
 =?us-ascii?Q?ssMxkvD6uTl8+8UV/a9F9d7oPKBN8F9Mr2DwXIvBXZpkVLSy9s9c9XvQ5tfT?=
 =?us-ascii?Q?yh6+hbZn62Eate2ltpc7dfGtcsMDWafoswPDdMGBqrxmF3zmwvtWkdQMllYD?=
 =?us-ascii?Q?3obD4aIM8yWt3FptEQ1Vc0KJw3qNwoCGRlV8UGmDi5FaGAT3sZ+6kCv856Ik?=
 =?us-ascii?Q?ix9hIHcWhM7DeeCuzsMLh9XKfpafiibjaVW/UFKV3xanXYLd+A7a+7xzr4C0?=
 =?us-ascii?Q?lg7tjHVLQIUN400hNE4Wesl/vP0N4UBL4iBswntKGIkLQ6dUinEKOUz1p+Bm?=
 =?us-ascii?Q?k5MfwaM/FGILbxilVtsO3T6sqsSasQhpXf4rouHYoflD8Ww90VPmjO2zk5/h?=
 =?us-ascii?Q?N8cAJO+yJk6hKOWRt0LTtTLl/rgkDv/YajLD4mcSZkC96IReaYTMoJQc8Gfo?=
 =?us-ascii?Q?FOeadVxvCLIsibaZ9LagG4SeEpTMuPB56THzDN+YLNJkBlo6A+FqvF6km4j+?=
 =?us-ascii?Q?TcQ9KKw7BbMKCWIHiufWao4/Ho9nOdDWYcNX1JsBHeiSop3X89HroG7r+fm9?=
 =?us-ascii?Q?TyzOlXsaOE0WFB5R0lHqEZlAoeh4CkztbDTY3TkFhoQfnO9GTzJZjLK9s8WU?=
 =?us-ascii?Q?tcownweo3xriaVujp7D+goP9DMpLg35gwMg/ocCzVdJqLyoAiWg1bkDrtVsZ?=
 =?us-ascii?Q?aAw4cC6Iqrltyoo3g3mXFyllIqlp1798ReFjRJ0awamVCzHXQcSCW10VcHu5?=
 =?us-ascii?Q?Tdevz93XP1tWeAzZD6GMxyVQruEXUs1GyIM5RjtQyum5Nw05CZIyITrAJBpM?=
 =?us-ascii?Q?nWcidUVCDr/ekT4i0sgrv8wKmI+H59aa5ctPY5ts70Q9qAjBaBbnVOt4MV9n?=
 =?us-ascii?Q?JGtqsfv9UR0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vKxdRNIHv1CYpsWtsrF5htVjVBLmekvDviwjhYYL5OhX/3LeVgHHgE4+161j?=
 =?us-ascii?Q?qH1XNHGCpcuEWL404nQm5X2OF3aqkAiFt6bhklTy7DoMVU4nsqg7GI0KLUTi?=
 =?us-ascii?Q?syOtT3ZvTLG9FcBgv0vem5WPs/q8ujFEjFgSBVHXOcha1MzPUfopuAQdUSbl?=
 =?us-ascii?Q?9ZI1vP1KY5fAETldY0SGVWwoKRcOghMl6nJVQXDadn7YhPZVJOocGhEg9Rmw?=
 =?us-ascii?Q?E24RhUcmrOJIJrFaoQVIEqCRO84UiVvzSGJeRNTr7buBriQXDSvl8CWtyfII?=
 =?us-ascii?Q?U5egJyUPmnlYWOgKsG6Dz5m7254s0w0IBKrA/HJq8djBmJ3kQhQmDo7vEk4Y?=
 =?us-ascii?Q?aG/p+3dbIt77wopF+y3mi3aG40sXYt/pxHDMcWkBagnkBGklMkrfeM4XbMio?=
 =?us-ascii?Q?vyF9tB0GPiNiN9UU9GiAsZ+VdK6ieC+N25ZXev1kiRZzh6m4KcIwPgmHNQR+?=
 =?us-ascii?Q?TWRIZix1HnS23UuY/IjkqKIBcQEIUf8FoktVnB+d1JC96VF9hlTLD3hlkVBs?=
 =?us-ascii?Q?tcgE3pECA7llltoT0czrboG3v9E3q4Ncz4jUzBtOlxfWhLiRPy1l2m8+74r/?=
 =?us-ascii?Q?e+btYZ8vBAMyMlv0FgYezhnWUE3kMHQdWsc1QZQ+nLKaRboO10PKZzPT/eCA?=
 =?us-ascii?Q?Ac5nqUN5AsFpmDHb9wiUwBUN9M/xiYYimKQIdb1vodFtfExQOBl/9VK5Rv5L?=
 =?us-ascii?Q?uHljmNAIxlHHRfBIBC5KS/Vc6KG4jrLlr3N0uauQR9B37uerMTSDLhd1JzPx?=
 =?us-ascii?Q?/zhcUAGAwhyf+r8C+rU2uNDmub03iYIkLq+cTHh2H7bzWZkSYfv65l0yJ7/+?=
 =?us-ascii?Q?nq2RzSIBimoXg8+N61HexItK1HPJOByAVviRbdeZi3nvIF4trSekPLHCpqvb?=
 =?us-ascii?Q?KoCgBBz0oBURWYstIICcavw1o27gn9eQVDhT5EiiDWzZ/zv8JaVGMr/VGWvE?=
 =?us-ascii?Q?I9SzX5xbjSPIYgAGTi9Ns4+NxS/7XnWxhxh0AdLdQ/4ts4P1VErJ66do85Or?=
 =?us-ascii?Q?LFBm8KOESH7jFLyiejGTVXoMj+AEshBMl9y4rqNNAQ7udP6MtPgMbvC1FpTZ?=
 =?us-ascii?Q?AAolITZ/LIKO0kEbAoYdPHJWQydgWoin1Btn8DJ3tQyp/CwaISgwqdRNuPY+?=
 =?us-ascii?Q?4j6tu8mkR+HhUdF/2XZTx7qDuHxsQ4W75o5u2Noaf+Ks69UqQkibQoYN5tYf?=
 =?us-ascii?Q?EZkp9++Vmz4CLwmzUJjmRvznd4FjpSl+3tZ8WFAmNYcUw4OLFS1xQIqJ8Y1P?=
 =?us-ascii?Q?wJMW18/2uJYqjz+/1F4B8DmUWE0THaha1VJKQE7oq7ps7lt1FgWaivzrzd5y?=
 =?us-ascii?Q?O3Mx4bJaonW+1tXX5sXGDXbiZSIrxjO3MCXwu4DjXmmFVqUaedA7/UUGnwrX?=
 =?us-ascii?Q?rqc+AtE/0UOFKnPK5A1GrmM+K0HAfHS/u5MXoMEVvzAO4EMGUo5K8pAeEn/M?=
 =?us-ascii?Q?ej6hvWdv/LOd/qeJpThhgbOHhj3YweCdq4kAeP1IKb6+ZUC1Z1INZkoUsDmk?=
 =?us-ascii?Q?qsM13kUHSIZd5gSHvIbC+6W0FuRXmN6ew97K4aQYeW7KfvJB+k8oqvnFK2e9?=
 =?us-ascii?Q?0v8qt54BuJBZ2VWM4oOACHaL9eM1Yj6T2RkWhuY5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b34c6ab-ef77-4e9a-7f7c-08ddc8819cc7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 18:08:36.7711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IOMYiEvd5W9fs3ePJxxrVTs0yIQlCpbxEzh59q+zzFHghUrD7N/Xlixvj4E67Bv3HBS1zCJixZePRxZdWOo/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7885

On Thu, Jul 17, 2025 at 03:57:03PM +0800, Chao Gao wrote:
> On Thu, Jul 17, 2025 at 09:00:04AM +0200, Mathias Krause wrote:
> >On 16.07.25 22:36, John Allen wrote:
> >> On Mon, Jul 07, 2025 at 09:32:37AM +0800, Chao Gao wrote:
> >>> On Mon, Jul 07, 2025 at 12:51:14AM +0800, Xiaoyao Li wrote:
> >>>> Hi Chao,
> >>>>
> >>>> On 7/4/2025 4:49 PM, Chao Gao wrote:
> >>>>> Tests:
> >>>>> ======================
> >>>>> This series passed basic CET user shadow stack test and kernel IBT test in L1
> >>>>> and L2 guest.
> >>>>> The patch series_has_ impact to existing vmx test cases in KVM-unit-tests,the
> >>>>> failures have been fixed here[1].
> >>>>> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
> >>>>>
> >>>>> Note, this series hasn't been tested on AMD platform yet.
> >>>>>
> >>>>> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
> >>>>> is required, e.g., Sapphire Rapids server, and follow below steps to build
> >>>>> the binaries:
> >>>>>
> >>>>> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
> >>>>>
> >>>>> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
> >>>>> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
> >>>>> (>= 8.5.0).
> >>>>>
> >>>>> 3. Apply CET QEMU patches[3] before build mainline QEMU.
> >>>>
> >>>> You forgot to provide the links of [1][2][3].
> >>>
> >>> Oops, thanks for catching this.
> >>>
> >>> Here are the links:
> >>>
> >>> [1]: KVM-unit-tests fixup:
> >>> https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
> >>> [2]: Selftest for CET MSRs:
> >>> https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
> >>> [3]: QEMU patch:
> >>> https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
> >>>
> >>> Please note that [1] has already been merged. And [3] is an older version of
> >>> CET for QEMU; I plan to post a new version for QEMU after the KVM series is
> >>> merged.
> >> 
> >> Do you happen to have a branch with the in-progress qemu patches you are
> >> testing with? I'm working on testing on AMD and I'm having issues
> >> getting this old version of the series to work properly.
> 
> Hi John,
> 
> Try this branch:
> 
> https://github.com/gaochaointel/qemu-dev qemu-cet
> 
> Disclaimer: I haven't cleaned up the QEMU patches yet, so they are not of
> upstream quality.
> 
> >
> >For me the old patches worked by changing the #define of
> >MSR_KVM_GUEST_SSP from 0x4b564d09 to 0x4b564dff -- on top of QEMU 9.0.1,
> >that is.
> 
> Please note that aliasing guest SSP to the virtual MSR indexed by 0x4b564dff is
> not part of KVM uAPI in the v11 series. This means the index 0x4b564dff isn't
> stable; userspace should read/write guest SSP via KVM_GET/SET_ONE_REG ioctls.

Thanks, tested on AMD. There's a couple of minor details I still need to
work out, but I should have an updated SVM series out soon.

Tested-by: John Allen <john.allen@amd.com>

