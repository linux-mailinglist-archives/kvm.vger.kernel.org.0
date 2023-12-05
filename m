Return-Path: <kvm+bounces-3452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7AFC8049F3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 07:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B2001F21475
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 06:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C942DF5C;
	Tue,  5 Dec 2023 06:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AR4HY2N8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC587D7;
	Mon,  4 Dec 2023 22:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701757388; x=1733293388;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=WbGAt6olYWlW38oxWZk9Wlmg0FFaZFKMp1zePaZ1yhI=;
  b=AR4HY2N8xCtklLsh0CkTuE7SFD2WDcsni9KoxCAYLtPjC4Jwj592vflP
   PbfhY09iV+ttvX9tmKQdMqWOx87cblXZzwVHEiGHHwu1u0Koxn/rTr0Ks
   /5IXZwJKChMsPany4iwXFpgvDvHpTVrqhbvKf2G5/2zdqsczXQSIBCVWb
   f2H7F3ivdbbD5wt99XKOfh+Yce3ROPj//nnSbXlLE6a4PShwbubI9vbmH
   xaxdqMva5FrF3HbFdK+nV7P9fQUHoA9e8aAgYTntL9PxKYuJtsIv5rGJe
   H+u28lFr1SBVGv2P96zBasvIwLPHSNBfEpuxI1MItkn6MySf1ay//cvNb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="480043680"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="480043680"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 22:22:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="914700527"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="914700527"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 22:22:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 22:22:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 22:22:55 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 22:22:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fz+829g2LQhfG5UCyY7O8zXMbpJ2gWwNtfJmovUsG+DsxkSVu9uJHukK52UfXZQnh3YYNAefKnEv5apzODKKM9zwHkiHzIs4u7Uerp88iYGfQrfTwXcWmc+7ncNq12tucjqNHcMHO85B6DLreKxBLK+5D7o5nTzI9mj5OAPsFnfcwDipbetauWq1Yx6d6O9C+xka02V/WQAuC+6s8JfLcA7lXa3KRsa4gticbhhXw5smnvkKuFMPROqc0YYbn/c5RRae2R+usn2z5cYDzesOv2FCT/qQhgF/k2vWOXZv4Hz3DikWFzVALRBu4hEbdXrHRBtvva6zIMRXXnezB6DCzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFPwG4/DRslICgFn5BJ32B640Lx/I6yzNCZs2Pe6vUk=;
 b=SIMagP+0xJzn8x2KN0H8Fq7Yju8ZmLu2RTTQB6V/Po7MlubXdVQSDGElbBGSC1NExKELXe9QThj/4zDoqiMgGMJlvgqRjP9h79cLFwtWD20vvRcinjV+Tc73NceL4IizhS97XeKFhKNJk3H0iEjSy4KLQVxeTXzmqArrW/uCWi4CLFMolDSv2FdtJFhtzl113VDypPaKRWZUvLS5LMPGxZekxx3ozAkkQoy1DS/C2niRkL6v3c65yURXdRN80omI0gGJI4ab/IFzVa3bkPQ9grtp1f+mRGIVgqixd4odbdMYNJBgZwJj1t60j5AxojhSur6jr7xcBhV8ycL6RVJqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by SJ0PR11MB5645.namprd11.prod.outlook.com (2603:10b6:a03:3b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 06:22:52 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::2a96:9ab3:4054:d899]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::2a96:9ab3:4054:d899%7]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 06:22:51 +0000
Date: Tue, 5 Dec 2023 13:53:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<alex.williamson@redhat.com>, <pbonzini@redhat.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <ZW666k8FSdpFabjU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <ZW4Fx2U80L1PJKlh@google.com>
 <20231204173028.GJ1493156@nvidia.com>
 <ZW4nCUS9VDk0DycG@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZW4nCUS9VDk0DycG@google.com>
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|SJ0PR11MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c395d9f-c3a2-4b3d-1661-08dbf55a9b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dd/s0v5HFm+vC8aGL89g7IKeMcE2xr5VcZ/TrXzh/ZhHfqZgVesDdVl60r7mS0MUBzADNCQ3NvfsXoxTH7vpNj1+JSrDoHlUuuP5EbXa1qsZhTqwaosOnN6/UuU3wseV5mLrvpexn+chkyxG3CZIOWdMP+Ii2DPHmysS894FyUktgKiYRrhi9MGTkf8vJiq7laznjzeUS6wcbfta50UZnsJ9PLHRgl815n0DtSIP5KQZHpKkzPmCU6qeUug31nT1NAXdFHPvm04rI9qq35RqDLUYmiAjPLwTlL6+IJN0FP23sv2C3YMqlNjROF8y/+YHK8q0+D7RCfJRWxyEH5Pn4GZW+KTQO6sAL8QT0PvzwNwosAov94Dc8OjGhkB4EjxTLr8MBAdFQc9xkMQyNSy+N0hncg4JITBLvff7qUok2n9vmz2ilIkdhGIl68QDX/4kKbQSL+G4+3XsKZBfmLcFW9QYGtOXX7sYmQmkvuyjCjADfzaNtooes7nQaee8G0A+FPAcwjMoLQXDNTupSiL8V4lLn0YiyCpMh5ty4hdW+hA8z4Y6GEVgqcrYuzgJx4lN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(41300700001)(38100700002)(2906002)(82960400001)(83380400001)(7416002)(5660300002)(26005)(3450700001)(6506007)(6512007)(478600001)(6486002)(6666004)(86362001)(4326008)(66476007)(8936002)(66946007)(66556008)(6916009)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?auxuZ1XA412ELtWnnn4ZZ0Gr8OG1p5rR1Q+GIkU1PRxWPnovI/Wc3c6bsh3d?=
 =?us-ascii?Q?e5qShArznEHjHWRbWrwifQU+8nJd7A6OeefrX0sXWAu8YWhMVGFRu2Jezioq?=
 =?us-ascii?Q?EmEBtbHEQZdqKKqG8gBaOPCN2Rhrc0K5owi/JgGDqXSXaQsilvigS3mOWDbb?=
 =?us-ascii?Q?LMlHw3zu7kyIAqB40x2u5qjtN2A4lQQ71nUzRD8SiVxWQGmMOktzc3W2tkU+?=
 =?us-ascii?Q?47YAxMIDAYOfEqGx8d5EKPYcSE5RyJlBpzcXqk3wpf4IxazLS87x1L+NXZzU?=
 =?us-ascii?Q?K8daikid/8CUWSqAFZS7h0jH6zpyMWZQ4CWhITB9x14lcvP5yVAuZTiRigZn?=
 =?us-ascii?Q?aAndUZMvRf1VMdenZaPU7JDuYsDyk3kHhVyN/zbCNImvdjnP99+vnDHxEOU3?=
 =?us-ascii?Q?PXZ86JIhY2NyR5pYLU6CXT0xDn4Y6sjFIdt34eDyIf8k3cdinkXvOsSOn53W?=
 =?us-ascii?Q?Db204h+8wYB8v4h18LSeYVrtfFP4GEut0lhxWwkKd+vEocbxNQUUdxby6euC?=
 =?us-ascii?Q?Sq1wFg7gUJi+N+ChNn86+xS8ZmBZosAaomiXCp+bGXiTE00j640Pi+5XQAdJ?=
 =?us-ascii?Q?IE8QPjwehHiNo7VlS4YNzuagij2KiS1NUDnSYAh/flZDtdNzhueIVXIWE4tO?=
 =?us-ascii?Q?Eo8hHyKeXoQFnB2KB6oSO95FdbbJ83c8wafW7b+9OY3IQfVhV8HeyZizwRl4?=
 =?us-ascii?Q?NOWGDkb75nCD1I9JOYrES99cLp8qMBN/ilaKfy0aS7kB6QJ7sESQ5lWFJvNl?=
 =?us-ascii?Q?wBRGFypj68XrhoPy0KAttcchPCDMe1+w16D5hCkux7MVbJXmHWkioMDgy2JZ?=
 =?us-ascii?Q?NrZx72sl42o5BChN/SPdxSsizi5qZW+DIg/Sp1+ewQp+dpN0OF5D+zxtU2NY?=
 =?us-ascii?Q?XTBu813yOElfhNH9wO6bE0Dxw5EAVR3F0v1gRCToUmYNhDVplF86zY4xug4A?=
 =?us-ascii?Q?L6/cqCo9tV0xQgajsYeIn4gtDxSLDdHVzncv/VRD2Qbl8lxMK7RbF9snHZ8w?=
 =?us-ascii?Q?XoJtsO6oZPtSSXvGS/hMEWU6LfAYjE6quCWNGtnvLwVOxXN5reHEP0sGcMdf?=
 =?us-ascii?Q?XQ+4S9qJLOsgGzUh/x++T14tXRnNuVA1i/WKnyaDo3+bP/tDy013faglYFKE?=
 =?us-ascii?Q?6AtSMQggVGsaYVCG/Ai79/bm6aieWmRAW4TDWgdfHActM0Nbv7fHr8DLRnXg?=
 =?us-ascii?Q?y942RYVutx+Je3Tuo7GhIIqtfLY8FDY1be6BLQxNs7A80MGN4OwEKeR3vhdZ?=
 =?us-ascii?Q?RJP4kKp2JElL/aOOJH8WflO0W1gDoTZ1EB/pwvGJ6veuA2lwYaLp45i4MfG5?=
 =?us-ascii?Q?8Rv3xEaiFRC+lMp896dND79qW4C+BEJgPvhl/5CPnkO5b4nJ+biNSVHv3SKw?=
 =?us-ascii?Q?HrsXpTys9FDXhW4ps5vL8K/uykRJjej/0gNCm1WoawW+iUZn25zteWBgCreH?=
 =?us-ascii?Q?ZYGoOMkjKPVzQ9C2X+y3iXwT5cvy64BLpwDb1Qkgo8s1DRnFG5fY41lWcx3l?=
 =?us-ascii?Q?9kxfiDvsF+rtUsm7n1mQWNcgr9FHWEve6MynBQCf5LnHwq18ZWWz7tfwvBaI?=
 =?us-ascii?Q?bHZQTd0r/JQ95tOJyN61+GgoxftrFXi64icDSMKB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c395d9f-c3a2-4b3d-1661-08dbf55a9b4c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 06:22:50.6609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCoEjhtOnFLcTK6joERB9BQ34Tqwd5r8aXL1FtgcYRgre2yqQFn1OEVAPzy+1kp0qim1ozIn8x9SJAdhA1Haew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5645
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 11:22:49AM -0800, Sean Christopherson wrote:
> On Mon, Dec 04, 2023, Jason Gunthorpe wrote:
> > On Mon, Dec 04, 2023 at 09:00:55AM -0800, Sean Christopherson wrote:

> > > I'm not convinced that memory consumption is all that interesting.  If a VM is
> > > mapping the majority of memory into a device, then odds are good that the guest
> > > is backed with at least 2MiB page, if not 1GiB pages, at which point the memory
> > > overhead for pages tables is quite small, especially relative to the total amount
> > > of memory overheads for such systems.
> > 
> > AFAIK the main argument is performance. It is similar to why we want
> > to do IOMMU SVA with MM page table sharing.
> > 
> > If IOMMU mirrors/shadows/copies a page table using something like HMM
> > techniques then the invalidations will mark ranges of IOVA as
> > non-present and faults will occur to trigger hmm_range_fault to do the
> > shadowing.
> >
> > This means that pretty much all IO will always encounter a non-present
> > fault, certainly at the start and maybe worse while ongoing.
> > 
> > On the other hand, if we share the exact page table then natural CPU
> > touches will usually make the page present before an IO happens in
> > almost all cases and we don't have to take the horribly expensive IO
> > page fault at all.
> 
> I'm not advocating mirroring/copying/shadowing page tables between KVM and the
> IOMMU.  I'm suggesting managing IOMMU page tables mostly independently, but reusing
> KVM code to do so.
> 
> I wouldn't even be opposed to KVM outright managing the IOMMU's page tables.  E.g.
> add an "iommu" flag to "union kvm_mmu_page_role" and then the implementation looks
> rather similar to this series.
Yes, very similar to current implementation, which added a "exported" flag to
"union kvm_mmu_page_role".
> 
> What terrifies is me sharing page tables between the CPU and the IOMMU verbatim. 
> 
> Yes, sharing page tables will Just Work for faulting in memory, but the downside
> is that _when_, not if, KVM modifies PTEs for whatever reason, those modifications
> will also impact the IO path.  My understanding is that IO page faults are at least
> an order of magnitude more expensive than CPU page faults.  That means that what's
> optimal for CPU page tables may not be optimal, or even _viable_, for IOMMU page
> tables.
> 
> E.g. based on our conversation at LPC, write-protecting guest memory to do dirty
> logging is not a viable option for the IOMMU because the latency of the resulting
> IOPF is too high.  Forcing KVM to use D-bit dirty logging for CPUs just because
> the VM has passthrough (mediated?) devices would be likely a non-starter.
> 
> One of my biggest concerns with sharing page tables between KVM and IOMMUs is that
> we will end up having to revert/reject changes that benefit KVM's usage due to
> regressing the IOMMU usage.
>
As the TDP shared by IOMMU is marked by KVM, could we limit the changes (that
benefic KVM but regress IOMMU) to TDPs not shared?

> If instead KVM treats IOMMU page tables as their own thing, then we can have
> divergent behavior as needed, e.g. different dirty logging algorithms, different
> software-available bits, etc.  It would also allow us to define new ABI instead
> of trying to reconcile the many incompatibilies and warts in KVM's existing ABI.
> E.g. off the top of my head:
> 
>  - The virtual APIC page shouldn't be visible to devices, as it's not "real" guest
>    memory.
> 
>  - Access tracking, i.e. page aging, by making PTEs !PRESENT because the CPU
>    doesn't support A/D bits or because the admin turned them off via KVM's
>    enable_ept_ad_bits module param.
> 
>  - Write-protecting GFNs for shadow paging when L1 is running nested VMs.  KVM's
>    ABI can be that device writes to L1's page tables are exempt.
> 
>  - KVM can exempt IOMMU page tables from KVM's awful "drop all page tables if
>    any memslot is deleted" ABI.
> 
> > We were not able to make bi-dir notifiers with with the CPU mm, I'm
> > not sure that is "relatively easy" :(
> 
> I'm not suggesting full blown mirroring, all I'm suggesting is a fire-and-forget
> notifier for KVM to tell IOMMUFD "I've faulted in GFN A, you might want to do the
> same".
> 
> It wouldn't even necessarily need to be a notifier per se, e.g. if we taught KVM
> to manage IOMMU page tables, then KVM could simply install mappings for multiple
> sets of page tables as appropriate.
Not sure which approach below is the one you are referring to by "fire-and-forget
notifier" and "if we taught KVM to manage IOMMU page tables".

Approach A:
1. User space or IOMMUFD tells KVM which address space to share to IOMMUFD.
2. KVM create a special TDP, and maps this page table whenever a GFN in the
   specified address space is faulted to PFN in vCPU side.
3. IOMMUFD imports this special TDP and receives zaps notification from KVM.
   KVM will only send the zap notification for memslot removal or for certain MMU
   zap notifications

Approach B:
1. User space or IOMMUFD tells KVM which address space to notify.
2. KVM notifies IOMMUFD whenever a GFN in the specified address space is faulted
   to PFN in vCPU side.
3. IOMMUFD translates GFN to PFN in its own way (though VMA or through certain
   new memfd interface), and maps IO PTEs by itself.
4. IOMMUFD zaps IO PTEs when a memslot is removed and interacts with MMU notifier
   for zap notification in the primary MMU.


If approach A is preferred, could vCPUs also be allowed to attach to this
special TDP in VMs that don't suffer from NX hugepage mitigation, and do not
want live migration with passthrough devices, and don't rely on write-protection
for nested VMs.

