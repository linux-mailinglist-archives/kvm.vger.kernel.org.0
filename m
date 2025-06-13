Return-Path: <kvm+bounces-49441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00ECAAD9107
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 683873BCC67
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447991E8353;
	Fri, 13 Jun 2025 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gTmle8mS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFC633E1;
	Fri, 13 Jun 2025 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749828002; cv=fail; b=b/oehVlEISf9DBpmMknTDxaAKvDGjln4gwsXhEOb43n/MABaEHiv9mZjWXiZgnbW7wK8VnH6X18BeX8KMRqwXDWfilodjZ4GC4wCQ+csfnthhfnWa4wp0XkF7S1dWsmAyK8TRmf7sJuD8cdxJDYx7DsA685n7ePcdvu5WOT2mW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749828002; c=relaxed/simple;
	bh=ICNhM6k6XGXC3ab+Ksj+BuY+Js0jqB3oyMq6/3ibCwo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fECWiwBmKQ8DTDebTpucyCe8L6gSnnpcTiud/AflNjxkB0D+aihgi3wQCU9jGyrC6QVo0cpEUbsSZB/YRFbkzHFZAJZ87ywZ8runqN1cpKcnMznkUJzlHeYS+rduiQ8SiXvnRcqDXw6/oNUo2Glm4pIj0yPesiSutInXTtTIyFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gTmle8mS; arc=fail smtp.client-ip=40.107.92.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O5I3JUeMS7vjOATIjl70gbmF3kKmTb3kV2IHd6YfmJNWDoi3Xv38ZVW8MxBhismzPvgOVJ2zBdDOHstquajFxBDC1qpsnM2tHH/i6UOWHNDUwhSydHq4bmoRs1wTsBg1FtbPn+YWB20c9M84EYCYV8gd7dZkAmmdVXcXk1V13Wm5AJHSFblRNHAIkZvfXf7F+na0uLjiJiqkcMs0egztd01scKus9Gi0Bh6b4ouXmV0dqTPuidMxHR7bySQTSojWvRjyxXZz6aXS+8jvWDC8mafsRfpLVpn0uELkRsKSdOl9xtbLryWN7qYm+ICCLog5spADOxxx8N8UbUTM4dE9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvDP22/KhmHZzaLFesYb3B6vjlX96/ryyvxUQEMijSo=;
 b=vqOzXJnutwbm7OA7mHKgEe6o3aj6CJzp7uWxWDOqULD13xnVbhLJBHgcWNyOBlv6H0ATPmBDm/+ZwReVsNcYaOHvah+RK/9KfBmpsneskbMNNa7FkJYuE5qbZCmsjPBZNmubSHX+Mck/jTTFrDWvGMHQHFdCPGDuT0+OKIbVDsd86iHNMjvCNf8UW+IXf6Mr513Cz7TclEkhV6jbS0rYX6cz4fyimrwAVpid6CnRItEnkWOXxp3LKq27SvBjt9KC3GGd2FMRZTipHUFvK0WVv4NbpYX1PEZRRTRoeXkLeYHybRn6ehR46oDVlJoWsH7gF2rhXVoDtFhosUIjxgpx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvDP22/KhmHZzaLFesYb3B6vjlX96/ryyvxUQEMijSo=;
 b=gTmle8mSwqM21W0yBxVByQHGRALIB+awm2AOrT9TgLARKF5eek8yEWqRJ20nYJlxmmk64xpOPkW+NLYrZ0Q+w1Mob1ML+PKpsCDcuWwlDM+dBlM/4+1HilG8MW5ZVQsDmIJt5OhvNPLR9efe8HYXrbXfcPm5RYBOVtXfwyAMinw=
Received: from SA0PR13CA0006.namprd13.prod.outlook.com (2603:10b6:806:130::11)
 by CH3PR12MB9453.namprd12.prod.outlook.com (2603:10b6:610:1c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Fri, 13 Jun
 2025 15:19:56 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::76) by SA0PR13CA0006.outlook.office365.com
 (2603:10b6:806:130::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Fri,
 13 Jun 2025 15:19:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 15:19:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Jun
 2025 10:19:55 -0500
Date: Fri, 13 Jun 2025 10:19:39 -0500
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: Vishal Annapurve <vannapurve@google.com>, Ackerley Tng
	<ackerleytng@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <20250613151939.z5ztzrtibr6xatql@amd.com>
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
 <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
 <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
 <aD5QVdH0pJeAn3+r@yzhao56-desk.sh.intel.com>
 <CAGtprH_XFpnBf_ZtEAs2MiZNJYhs4i+kJpmAj0QRVhcqWBqDsQ@mail.gmail.com>
 <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|CH3PR12MB9453:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cdd485d-b094-4e84-392c-08ddaa8dc0d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVJFeHQzMXp2VnNraVNBU2dUckJOMXNmR1V5eXFHNUJJcFBCekI0ZmhSY1FE?=
 =?utf-8?B?ZUJDd0toMlZIckUxTVNtSWE3UjM5OTY2T3crNStSMVVHM1hOOE9CU0dVMDJl?=
 =?utf-8?B?bkcraCtDeWNJbVcxODdiVHZYY3F5THUwelN1YVdiY2tQTDlGNmk2b2c4QWlL?=
 =?utf-8?B?NTFXOEV1T0gzdkhVMXpIUjZ1QktzQlVZTFlqTkxuSmc4c0w2THVhUFZHanJl?=
 =?utf-8?B?Qm5FSEdVMHV2cll0cDdEb2JNeEpMTVZGNWE2UTJsZFpsOVZPaDVGaFFEeThn?=
 =?utf-8?B?L1ViczJNb0xHcjVnOHcySW90Z1NxcGZneEx3dEhLcGFuTjdJWW1ZZTI2SXh5?=
 =?utf-8?B?UWgvYlo0ZHFkbGdmOUtSZkNaYS9CblFtMDRXcml1b2wydTg5THlQV2Q0aEpC?=
 =?utf-8?B?R2E2cTZLUkJheG5WY1dvUzFXK1k3eG9JVXF3MTZwbm81T2FUbnJuUy96Y1JB?=
 =?utf-8?B?UHZrcGpva2xCbGExczNvVjZjL0xOVmsvOW0zNzBySWxrenZrT3ExOW5vbjgw?=
 =?utf-8?B?eUx3US9BVWQ4RXc5a2F1SEhoclB1K2tPZitQVElGN0duV3FIcW9CUkF1aytB?=
 =?utf-8?B?Q280Zkhiak9BM2pTakx2ZnVrWndrSG5EV01RVVdnUXdCbFZuUUVpVkx1aVVQ?=
 =?utf-8?B?TDFvMnRLNnBvYjA3SlU5SmRJd2NLbkJpN01OdXUrcE4xZnNjbXNtb0dYakp6?=
 =?utf-8?B?eVFZeXh6V0FUMTZpeU55WGs0SnNjYTRObzU2OU9pZnVieU90UUkrNVhHMkk1?=
 =?utf-8?B?S2gvSEY1eVdNYWRRRThZbGowb21oZGU5SWpmSFowVW1LL2NkNWlTRzVudENj?=
 =?utf-8?B?V0VGWCtyYnovTkhjZkZRaWtzcWdLTktTS3M1Z2NROTEzSC9TR2V6cFhJRUNB?=
 =?utf-8?B?WEdibnY5VC93dFF4WFJyc3A3d0dCLzlDMER5UUxqZEFCbENMWjFpdjNWZDRw?=
 =?utf-8?B?NG43WjFEYThCUXIwOEdLdU5HTjhEam9GOHNZVlFvVmJyWHJCcWxSSlgvWXpY?=
 =?utf-8?B?dFR1eG5hdjd0c2VleGtKdHBUdHBnN0doUnhJN2MyYzUyUVdXS1psNHVpdkZt?=
 =?utf-8?B?ZS9GY1B6bG9PVHJLMmZIWFVLd1JLM2pwTWx0d29jZU9hRWEzS3hsZjY3R3Fr?=
 =?utf-8?B?Y3RrVkJ1angzZEhPU1luMzg5dHdocnVYTHQzcHVJVUhQUmFQYmpaREJZbkcz?=
 =?utf-8?B?aUR5WG5CZEtrdmVVUm5WSktJbW1GZVZFdi8wTFY4NzY5QjJ3bitQTlBCYVI3?=
 =?utf-8?B?TFFHWENjaTVkU3BCREdUd0hNT2h2YzBTWFNLeTRkcjlCSzd5ajVyMXFBSEJ5?=
 =?utf-8?B?cVdTclZpQm5WRlBFVTJWMjdXY3NnR0k4Vmw4OURKVFZqTGt4Z3pyQUNodUN6?=
 =?utf-8?B?R0U1N2dpbnc3UWtLTUEyU3ZWbTVZNzZjV2doWERYRU5wOS90dStuaC94REls?=
 =?utf-8?B?Q0NFUmI2TjNwK2NNK3BRenlEaFFOd29hMTRYTklTMTcyTGVCM29TTG5qNnE3?=
 =?utf-8?B?azYyUjA3eEwvL0xBbWttWWxxR2p4NzdFTFR3alNvY3JzNE1UVVora0hXQXpX?=
 =?utf-8?B?SVpKdHJUa2lPbkNHTm5TaVduNWNzQi9selpBcTdOblJIWDNRTlFZMlNuUjd5?=
 =?utf-8?B?c1d2ZDlxak1ScU9EUDI1MWxiUldDamNoSUdLWlFPNVNjcnpJa09TT3dtdUlG?=
 =?utf-8?B?azd1Vm5ZR2NNbTBxTHRwU1EvaFo2d1lZNk5VNzVPNzMzYTJlNnpTdFRaMDdq?=
 =?utf-8?B?UC96ZWViemJnOXIrcVFiTVJSZzJhanlhMDRSREUxSCt4SnhOTG5iMll4MWhr?=
 =?utf-8?B?Rk9TOXlIbHNXQ3d0eGFlNUVzTHo4Yjd3N0RIUDd6dmpSNDVtcWViV1RmbzZm?=
 =?utf-8?B?MHNDeTdHSGFYL2xseS96UzBIbmtuZzJzRTNCRzJqR3F4QTJDVGRxbGhIb0Q3?=
 =?utf-8?B?N3cyZG03SXVlcDVLVVVzMmhqNlAzY3RSU3dENDh5TzBJdWFlZVpzQjc2NVBh?=
 =?utf-8?Q?3BX1USOVfloCtMgzsj8Ou3aPRBN1uk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:19:55.8053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cdd485d-b094-4e84-392c-08ddaa8dc0d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9453

On Thu, Jun 12, 2025 at 08:40:59PM +0800, Yan Zhao wrote:
> On Tue, Jun 03, 2025 at 11:28:35PM -0700, Vishal Annapurve wrote:
> > On Mon, Jun 2, 2025 at 6:34 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > On Mon, Jun 02, 2025 at 06:05:32PM -0700, Vishal Annapurve wrote:
> > > > On Tue, May 20, 2025 at 11:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >
> > > > > On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> > > > > > Ackerley Tng <ackerleytng@google.com> writes:
> > > > > >
> > > > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > > >
> > > > > > >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> > > > > > >>> This patch would cause host deadlock when booting up a TDX VM even if huge page
> > > > > > >>> is turned off. I currently reverted this patch. No further debug yet.
> > > > > > >> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> > > > > > >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
> > > > > > >>
> > > > > > >> kvm_gmem_populate
> > > > > > >>   filemap_invalidate_lock
> > > > > > >>   post_populate
> > > > > > >>     tdx_gmem_post_populate
> > > > > > >>       kvm_tdp_map_page
> > > > > > >>        kvm_mmu_do_page_fault
> > > > > > >>          kvm_tdp_page_fault
> > > > > > >>       kvm_tdp_mmu_page_fault
> > > > > > >>         kvm_mmu_faultin_pfn
> > > > > > >>           __kvm_mmu_faultin_pfn
> > > > > > >>             kvm_mmu_faultin_pfn_private
> > > > > > >>               kvm_gmem_get_pfn
> > > > > > >>                 filemap_invalidate_lock_shared
> > > > > > >>
> > > > > > >> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> > > > > > >> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> > > > > > >> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> > > > > > >> ("locking: More accurate annotations for read_lock()").
> > > > > > >>
> > > > > > >
> > > > > > > Thank you for investigating. This should be fixed in the next revision.
> > > > > > >
> > > > > >
> > > > > > This was not fixed in v2 [1], I misunderstood this locking issue.
> > > > > >
> > > > > > IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
> > > > > > part of the KVM fault handler to map the pfn into secure EPTs, then
> > > > > > calls the TDX module for the copy+encrypt.
> > > > > >
> > > > > > Regarding this lock, seems like KVM'S MMU lock is already held while TDX
> > > > > > does the copy+encrypt. Why must the filemap_invalidate_lock() also be
> > > > > > held throughout the process?
> > > > > If kvm_gmem_populate() does not hold filemap invalidate lock around all
> > > > > requested pages, what value should it return after kvm_gmem_punch_hole() zaps a
> > > > > mapping it just successfully installed?
> > > > >
> > > > > TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_populate() when
> > > > > CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the filemap
> > > > > invalidate lock being taken in kvm_gmem_populate().
> > > >
> > > > Does TDX need kvm_gmem_populate path just to ensure SEPT ranges are
> > > > not zapped during tdh_mem_page_add and tdh_mr_extend operations? Would
> > > > holding KVM MMU read lock during these operations sufficient to avoid
> > > > having to do this back and forth between TDX and gmem layers?
> > > I think the problem here is because in kvm_gmem_populate(),
> > > "__kvm_gmem_get_pfn(), post_populate(), and kvm_gmem_mark_prepared()"
> > > must be wrapped in filemap invalidate lock (shared or exclusive), right?
> > >
> > > Then, in TDX's post_populate() callback, the filemap invalidate lock is held
> > > again by kvm_tdp_map_page() --> ... ->kvm_gmem_get_pfn().
> > 
> > I am contesting the need of kvm_gmem_populate path altogether for TDX.
> > Can you help me understand what problem does kvm_gmem_populate path
> > help with for TDX?
> There is a long discussion on the list about this.
> 
> Basically TDX needs 3 steps for KVM_TDX_INIT_MEM_REGION.
> 1. Get the PFN
> 2. map the mirror page table
> 3. invoking tdh_mem_page_add().
> Holding filemap invalidation lock around the 3 steps helps ensure that the PFN
> passed to tdh_mem_page_add() is a valid one.
> 
> Rather then revisit it, what about fixing the contention more simply like this?
> Otherwise we can revisit the history.
> (The code is based on Ackerley's branch
> https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2, with patch "HACK: filemap_invalidate_lock() only for getting the pfn" reverted).
> 
> 
> commit d71956718d061926e5d91e5ecf60b58a0c3b2bad
> Author: Yan Zhao <yan.y.zhao@intel.com>
> Date:   Wed Jun 11 18:17:26 2025 +0800
> 
>     KVM: guest_memfd: Use shared filemap invalidate lock in kvm_gmem_populate()
> 
>     Convert kvm_gmem_populate() to use shared filemap invalidate lock. This is
>     to avoid deadlock caused by kvm_gmem_populate() further invoking
>     tdx_gmem_post_populate() which internally acquires shared filemap
>     invalidate lock in kvm_gmem_get_pfn().
> 
>     To avoid lockep warning by nested shared filemap invalidate lock,
>     avoid holding shared filemap invalidate lock in kvm_gmem_get_pfn() when
>     lockdep is enabled.
> 
>     Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 784fc1834c04..ccbb7ceb978a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -2393,12 +2393,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>         struct file *file = kvm_gmem_get_file(slot);
>         struct folio *folio;
>         bool is_prepared = false;
> +       bool get_shared_lock;
>         int r = 0;
> 
>         if (!file)
>                 return -EFAULT;
> 
> -       filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> +       get_shared_lock = !IS_ENABLED(CONFIG_LOCKDEP) ||
> +                         !lockdep_is_held(&file_inode(file)->i_mapping->invalidate_lock);
> +       if (get_shared_lock)
> +               filemap_invalidate_lock_shared(file_inode(file)->i_mapping);

Hi Yan,

I had been working on some kind of locking scheme that could account for some
potential[1] changes needed to allowing concurrent updating of "preparedness"
state while still allowing for concurrent fault handling. I posted a tree
there in that link with an alternative scheme that's based on rw_semaphore
like filemap invalidate lock, but with some changes to allow the folio
lock to be taken to handle write-side updates to "preparedness" state
instead of needing to take a write-lock.

With that approach (or something similar), it is then possible to drop reliance
on using the filemap invalidate lock in kvm_gmem_get_pfn(), and that I
think would cleanly resolve this particular issue.

However, it was also suggested during the guest_memfd call that we revisit
the need to track preparedness in guest_memfd at all, and resulted in me
posting this rfc[2] that removes preparedness tracking from gmem
completely. That series is based on Ackerley's locking scheme from his
HugeTLBFS series however, which re-uses filemap invalidate rw_semaphore
to protect the shareability state, so you'd hit similar issues with
kvm_gmem_populate().

However, as above (and even more easily so since we don't need to do
anything fancy for concurrent "preparedness" updates), it would be
fairly trivial to replace the use of filemap invalidate lock with a
rw_semaphore that's dedicated to protecting shareability state, which
should make it possible to drop the use of
filemap_invalidate_lock[_shared]() in kvm_gmem_get_pfn().

But your above patch seems like it would at least get things working in
the meantime if there's still some discussion that needs to happen
before we can make a good call on:

  1) whether to continue to use the filemap invalidate or use a dedicated one
     (my 2 cents: use a dedicated lock to we don't have to deal with
     inheriting unintended/unecessary locking dependencies)
  2) whether or not is will be acceptable to drop preparedness-tracking
     from guest_memfd or not
     (my 2 cents: it will make all our lives much happier)
  3) open-code what kvm_gmem_populate() handles currently if we need
     extra flexibility WRT to locking
     (my 2 cents: if it can be avoided it's still nice to gmem
     handle/orchestrate this to some degree)

Thanks,

Mike

[1] https://lore.kernel.org/lkml/20250529054227.hh2f4jmyqf6igd3i@amd.com/
[2] https://lore.kernel.org/kvm/20250613005400.3694904-1-michael.roth@amd.com/

> 
>         folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
>         if (IS_ERR(folio)) {
> @@ -2423,7 +2427,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>         else
>                 folio_put(folio);
>  out:
> -       filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> +       if (get_shared_lock)
> +               filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
>         fput(file);
>         return r;
>  }
> @@ -2536,7 +2541,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>         if (!file)
>                 return -EFAULT;
> 
> -       filemap_invalidate_lock(file->f_mapping);
> +       filemap_invalidate_lock_shared(file->f_mapping);
> 
>         npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>         for (i = 0; i < npages; i += npages_to_populate) {
> @@ -2587,7 +2592,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>                         break;
>         }
> 
> -       filemap_invalidate_unlock(file->f_mapping);
> +       filemap_invalidate_unlock_shared(file->f_mapping);
> 
>         fput(file);
>         return ret && !i ? ret : i;
> 
> 
> If it looks good to you, then for the in-place conversion version of
> guest_memfd, there's one remaining issue left: an AB-BA lock issue between the
> shared filemap invalidate lock and mm->mmap_lock, i.e.,
> - In path kvm_gmem_fault_shared(),
>   the lock sequence is mm->mmap_lock --> filemap_invalidate_lock_shared(),
> - while in path kvm_gmem_populate(),
>   the lock sequence is filemap_invalidate_lock_shared() -->mm->mmap_lock.
> 
> We can fix it with below patch. The downside of the this patch is that it
> requires userspace to initialize all source pages passed to TDX, which I'm not
> sure if everyone likes it. If it cannot land, we still have another option:
> disallow the initial memory regions to be backed by the in-place conversion
> version of guest_memfd. If this can be enforced, then we can resolve the issue
> by annotating the lockdep, indicating that kvm_gmem_fault_shared() and
> kvm_gmem_populate() cannot occur on the same guest_memfd, so the two shared
> filemap invalidate locks in the two paths are not the same.
> 
> Author: Yan Zhao <yan.y.zhao@intel.com>
> Date:   Wed Jun 11 18:23:00 2025 +0800
> 
>     KVM: TDX: Use get_user_pages_fast_only() in tdx_gmem_post_populate()
> 
>     Convert get_user_pages_fast() to get_user_pages_fast_only()
>     in tdx_gmem_post_populate().
> 
>     Unlike get_user_pages_fast(), which will acquire mm->mmap_lock and fault in
>     physical pages after it finds the pages have not already faulted in or have
>     been zapped/swapped out, get_user_pages_fast_only() returns directly in
>     such cases.
> 
>     Using get_user_pages_fast_only() can avoid tdx_gmem_post_populate()
>     acquiring mm->mmap_lock, which may cause AB, BA lockdep warning with the
>     shared filemap invalidate lock when guest_memfd in-place conversion is
>     supported. (In path kvm_gmem_fault_shared(), the lock sequence is
>     mm->mmap_lock --> filemap_invalidate_lock_shared(), while in path
>     kvm_gmem_populate(), the lock sequence is filemap_invalidate_lock_shared()
>     -->mm->mmap_lock).
> 
>     Besides, using get_user_pages_fast_only() and returning directly to
>     userspace if a page is not present in the primary PTE can help detect a
>     careless case that the source pages are not initialized by userspace.
>     As initial memory region bypasses guest acceptance, copying an
>     uninitialized source page to guest could be harmful and undermine the page
>     measurement.
> 
>     Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 93c31eecfc60..462390dddf88 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3190,9 +3190,10 @@ static int tdx_gmem_post_populate_4k(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>          * Get the source page if it has been faulted in. Return failure if the
>          * source page has been swapped out or unmapped in primary memory.
>          */
> -       ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> +       ret = get_user_pages_fast_only((unsigned long)src, 1, 0, &src_page);
>         if (ret < 0)
>                 return ret;
> +
>         if (ret != 1)
>                 return -ENOMEM;
> 

