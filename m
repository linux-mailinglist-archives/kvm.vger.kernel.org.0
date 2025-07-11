Return-Path: <kvm+bounces-52198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E1CB02577
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 21:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECCDB3A5FF8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 19:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637B72ECE9F;
	Fri, 11 Jul 2025 19:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SextTZ8H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23131EB5E5;
	Fri, 11 Jul 2025 19:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752263412; cv=fail; b=pFB5iJnS3jR5sreiQ71Y+F7Abpy9KOWMq40LP8uk2dHC+dw9lLoVpvKw/YXHVmvkmFmD+MwRbV4+8qOtptie54Ju5pCJdZNy4X5ZpmhXLR+LVaPAtNSJh+pzTJGtjl2Pm5oTwSDPtRjpEvmlwdy7JClTAGi7iXsPp3BrC39W4ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752263412; c=relaxed/simple;
	bh=cyUE6cH/CiR3pbcS/AaZAT3EFpHRVn6t8mV3DmMMnl4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8CWamq2Ezxp3o2tONxFAYbRg4gGldAkLKwY8stv7BvHnwZMKT6F03tZHdoRd6BN6FqSsoN6Rf5Lam9lN898ZZtruPGsEygcR2HxSu4+THMei3l1fmORmtBdiYEjqug3T4G7Z0KuDwF7EqlBRa88tCaMbjEjjSbkhhgggngg/FQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SextTZ8H; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rH9W5AQgYNgxPt9sxhe75oty+ofR/Q/f/9nzialn58bV1AhXtinEJGNdJTfmpJqrf3iAYlivMPXksJy7UezdTvY0gh6jvogp+wUMKHtlvzxFTA82uSyFJhHG19IgFqJvW9lIrbco49jtmV8L+VWROzxlSUMLb73sHwo7U2VxMwmummvaf9rbsryaSge/J2qt8KOZ1wktq7i4a1MxQomFZIZCOF1KGTW5ia/wXIBQ3fMS/YnQYsh3Z1cRzzsDG5Lg/NXHRolcAGMTxYXI2wPeovvoHOgGhpY8qt3Dw12C/S5Ccojga2GLjihRpm4WhQPs0LuhUyoKZP2wxjq+JKSizQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dghphar5QKZXwf3f/qw3kz3iODbX5A+BVZroKI8Fu/4=;
 b=yXupYqn740X+k8aOFWnPP3v2t7VXESwE/uwuSa0TP1ozHSQoFz6SeaOWasv4zyRGobSsgMxs7vB3ILW6RQsIKcYpkDN4kanAgw6xHXoeolt3Hn+KKyhMjFgELyqFwBybLa+4+U4dPX7F8dJbqyDasv7oSIQGhNL+k4R93eWErWiclnL5qtUiF0FeHg9o0mVOWhy4T1pNPlgSK/1IPMB5t9k8O/zDegGwPdaekLfpJ7bcmzudSt2EUyU96ReeULulnquQX6iVxDIqMgip0dJIaCbaIEcBe634+RJ7xaumQsjuZxQjFq+GT6aYtZM7XsfNx796llDoFjxa1ZhshGs53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dghphar5QKZXwf3f/qw3kz3iODbX5A+BVZroKI8Fu/4=;
 b=SextTZ8Hqdj2J/HHh8juv93WSOpaJUzDELy8kgiCVQYsZBza1bjgMxWeBvQeo0cEH/wtii1V1vq21kzo+3mnY+1tIT9mpJjfYBAOQt3srJgvrjzIW7fADZgmgxwHCaUOFrM6OlYT1RGxJU0HZ5QgTDadAkPn2xhpRArVEqCN3dI=
Received: from SA0PR11CA0202.namprd11.prod.outlook.com (2603:10b6:806:1bc::27)
 by DS4PR12MB9793.namprd12.prod.outlook.com (2603:10b6:8:2a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 19:50:08 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:1bc:cafe::af) by SA0PR11CA0202.outlook.office365.com
 (2603:10b6:806:1bc::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.27 via Frontend Transport; Fri,
 11 Jul 2025 19:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Fri, 11 Jul 2025 19:50:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Jul
 2025 14:50:07 -0500
Date: Fri, 11 Jul 2025 14:49:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <20250711194952.ppzljx7sb6ouiwix@amd.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com>
 <CAGtprH9dCCxK=GwVZTUKCeERQGbYD78-t4xDzQprmwtGxDoZXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9dCCxK=GwVZTUKCeERQGbYD78-t4xDzQprmwtGxDoZXw@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|DS4PR12MB9793:EE_
X-MS-Office365-Filtering-Correlation-Id: cc16fb01-593f-45e7-6f9a-08ddc0b423d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGNzR29kM1BHd1V4S3JhcW14d2VmK0dpeVBuVXNqMFQzb3Y0aXRmSGx5ckxt?=
 =?utf-8?B?U054b3IzUkZQbk5HVFVzekFneExvZEdKRURGamZ0dkxuWjNCNEtZMm9zWmJq?=
 =?utf-8?B?Yzl5aWJQeDFCSFNRSm5OUkdvM0x6VzJhNmppb1Vsc3RVOUJxOWwydjJUZTJX?=
 =?utf-8?B?d1hzRCtZclFORjl1VGd1ZS9OQU91enB5MkNzUmNGcnF4UForOTk3VlhJUjJJ?=
 =?utf-8?B?R1FuTnZPYkdmd3EyTndWbjZTb3VnbkF3c1ZCd0RnWCtJeXVxMjFuc2c3blFu?=
 =?utf-8?B?QUlNQytzVm9NRDE3aHZoOG5uRWxHQ3RWUlJDeXU2RUczQVlKSU1IOWZDK1NF?=
 =?utf-8?B?MW5TeU9KeEk2ZDdnalVENy9uN0M0NWZCdVd0MzlZNlNxNEVicFp6bWkyek5M?=
 =?utf-8?B?anZaTzZQczgrZzhyTURXcm5yNDVoK01JT2ZPUDV1RjlOWWlLWFBWTzJkRzNu?=
 =?utf-8?B?OUxEcTg5UnZsanlYOVJoREpLcFdTZGJvbStwR1VVekpEMGltTEpuUHJKTktJ?=
 =?utf-8?B?Qmd1ZGFwem85QzhibUZzVEs3OVJjSWRIR2RLRXQ1TW9QSGpEU2g1Q3ptbFpn?=
 =?utf-8?B?Y1lvb2Rncldwbk1lcDBzRklMb0Q1d1ZRb2tuckZCeDNFaHdBQk11NmVUZUxH?=
 =?utf-8?B?VFZkRDJNSnpkaGxSSUhMYnlRN3BUUFZQajEvRkRzb2VXd2ZRY0tYMGQramZt?=
 =?utf-8?B?Qy9oQk5TR210U2RuM3AzTWJSbThxVTVIQjhqSUdtN1lLL0lOdEZjelFkazFx?=
 =?utf-8?B?RS9SVDB4MWNST1YxYXdOdms1OXhBRlhSeXQ1aU1ObFFPakFNN1NjZ3pvTjBp?=
 =?utf-8?B?ZlBCTm9jT0lvd0NwcTBoYlpxVXM3R09OZlZZTmo0ZzF3N3JCdldZQnpxL1ZN?=
 =?utf-8?B?UUFHcDc3Z3JpNTNMS01SVkUra1dlTXZ4YkNhU2VkZGR0aVZHSDlzRFVwcWZs?=
 =?utf-8?B?RmJnbGxLa2pJdTJPMFkrWDUrUlBWb3E2NDVCeHFOTVpHZzFZUXBkSmVCZ3kr?=
 =?utf-8?B?RnF3UjVpQzZYa29HRFFNNVJXUnlVbW8yU0hWRVVVc3VOZnp0WFBGZkcxMlNY?=
 =?utf-8?B?TjJlcXJuazhKZVpuSGg2ZStVK3AxZlJXcTBZdWJvRzdOUDBGMVMxWnZ2MXQ2?=
 =?utf-8?B?RnkvSEJ0Y05MRXQvVGxtMGloVnMzU2ZpMXhrd0lMazRha0VSSzBPZUFJblB3?=
 =?utf-8?B?UVlka1dkbTEvVVFUS0llMUFqOUJoZHYwWElnaHQyeFA1K2JCQnZtQzZ1bldH?=
 =?utf-8?B?bVQ4MW1OeS9VQ3pyYTVKdVRxMjhkZnlHV1NwSmhtbVloY1RYUnkxWk5LWitT?=
 =?utf-8?B?RlRqekdjbWFIZ0ZxYUZLSmViVURJTFJSOFFPKzh0Q1dMN0dFS28vM1B3VHRq?=
 =?utf-8?B?bEFyL08ybXkrL2pReXRNUkttczVaMEo5Um9ZTnBrRS9tR3V0b29GNGtkNHdE?=
 =?utf-8?B?dFNaSTBoQzRPVEt3dHVFOGJMYW11Ti9XSnBEMTZ5bjJuZmYyUTRFVm9kS21K?=
 =?utf-8?B?OXRUQnlwUDVDSFlnTkpYU3dLTDJxNW9vZEVmdmJ3SnpTWGF0WTh3d2QxNURk?=
 =?utf-8?B?SmlVLytVeXcrVTZ2OGFxSC91RlkrcHNZcDZuK3Zkejd2d3d1K0RuNXVOZytS?=
 =?utf-8?B?c3d3SlpzaWZpM2czNTdjd1V3TmNQV0VlYjMzaHhjS1pKci9aazM4YzROMm1Z?=
 =?utf-8?B?VHFjUU1Vc1cvZXUyQXpQWElITERGWnhrS1BET2MySVlYOTlTRnlSaXc4OVlK?=
 =?utf-8?B?T2RKNmplWXpYT0hScFBlakRJNGp6SFFYYmZCVkRDWUs4a0RIRFArUTZKRUV5?=
 =?utf-8?B?dUZjdGRBbng5TDQydzFEdGFCRjNjbG5obDEwWE1SZ0dhM245TDJTeGpEbjNW?=
 =?utf-8?B?L2xKa1BoRFFzOEZITVFidFJDbm1pQ0I0TDFYTzc3TWpDVTd3ZEFXMlNxRzVl?=
 =?utf-8?B?TmJObzVDeVBtVWlvcCtEUGl2MWZ0OXhkRmRKMVZQdmVwK0ZXQkUrVGpiaytT?=
 =?utf-8?B?eUZmRjJCeCtPak9GclpGZFhGeGRmWXVBOGxwazRnT1NzSHlQdEJtYmZRbVFv?=
 =?utf-8?Q?9En0BT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 19:50:08.3338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc16fb01-593f-45e7-6f9a-08ddc0b423d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9793

On Fri, Jul 11, 2025 at 11:38:10AM -0700, Vishal Annapurve wrote:
> On Fri, Jul 11, 2025 at 9:37 AM Michael Roth <michael.roth@amd.com> wrote:
> >
> > >
> > > static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> > >                               struct file *file, gfn_t gfn, void __user *src,
> > >                               kvm_gmem_populate_cb post_populate, void *opaque)
> > > {
> > >       pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > >       struct page *src_page = NULL;
> > >       bool is_prepared = false;
> > >       struct folio *folio;
> > >       int ret, max_order;
> > >       kvm_pfn_t pfn;
> > >
> > >       if (src) {
> > >               ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
> > >               if (ret < 0)
> > >                       return ret;
> > >               if (ret != 1)
> > >                       return -ENOMEM;
> > >       }
> >
> > One tricky part here is that the uAPI currently expects the pages to
> > have the private attribute set prior to calling kvm_gmem_populate(),
> > which gets enforced below.
> >
> > For in-place conversion: the idea is that userspace will convert
> > private->shared to update in-place, then immediately convert back
> > shared->private; so that approach would remain compatible with above
> > behavior. But if we pass a 'src' parameter to kvm_gmem_populate(),
> > and do a GUP or copy_from_user() on it at any point, regardless if
> > it is is outside of filemap_invalidate_lock(), then
> > kvm_gmem_fault_shared() will return -EACCES.
> 
> I think that's a fine way to fail the initial memory population, this
> simply means userspace didn't pass the right source address. Why do we
> have to work around this error? Userspace should simply pass the
> source buffer that is accessible to the host or pass null to indicate
> that the target gfn already has the needed contents.
> 
> That is, userspace can still bring a separate source buffer even with
> in-place conversion available.

I thought there was some agreement that mmap() be the 'blessed'
approach for initializing memory with in-place conversion to help
untangle some of these paths, so it made sense to enforce that in
kvm_gmem_populate() to make it 'official', but with Sean's suggested
rework I suppose we could support both approaches.

-Mike

> 
> > The only 2 ways I see
> > around that are to either a) stop enforcing that pages that get
> > processed by kvm_gmem_populate() are private for in-place conversion
> > case, or b) enforce that 'src' is NULL for in-place conversion case.
> >

