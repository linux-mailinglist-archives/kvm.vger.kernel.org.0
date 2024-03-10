Return-Path: <kvm+bounces-11479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C364E877927
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 00:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E153E1C20DC6
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 23:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5C73BBC6;
	Sun, 10 Mar 2024 23:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cf0zdIMm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7BF1170B;
	Sun, 10 Mar 2024 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710112370; cv=fail; b=lO5HO1OBQOevYjQc5EkOzEoXFSnhBEHKLdn5taT7FDwn3fYNAoXqIS+ZgKHA4XV6rigkzPo7EWKbTc2SeiJIzNqBDZAvmcI4ypAKORR55wVD9ZiKJkz7MWOWoPePN0QcAe/xA+SlMm6TCBpvmiL+Xk4VrP/kGMpDoRPo6pn+vDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710112370; c=relaxed/simple;
	bh=u1/o9yU6PhXsXoQH2N3nR43cbMhQ0XubtLzyvd+yE+M=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f6I94g5niWp9/HoxtckGqHGWaCv/t/ndfji6Vaym2452t+UVYaTuVz3VetHoPsyCgty/x0pDOQqc3o+6vx7qmk0NS4Y7KlVPNzFg+0YLc4tRURrwGE+hexKQpctt+ww6ZinDSMbDXYIW58JVY4W6dzB+AZB3Wh0WvvNTSO6d4U0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cf0zdIMm; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8pM3OJhkL7WQLlVUucjkQaACSiDwLJLPFefC1cysSfd5UZw9B0/fb5W3wUJE8OrvnnueYOykU3IS3I1afN8j1px/ktyGf57YXyI+axUmYoTyy0HeA4JnkUOya0jAGJ4mlcwqTHJPLk/E15A5Aq13PKkSz4nfs/+Ss0ywredUIqsUuRS28BpElSZMMVbU735zuqxEBayeovsHAucPzJvXlb9SYW/9BzwMrgp/9Z/wcGi9O/HJZUWnOafK8o76W5ioNvdE9AQM2Pd54qF2qcDzR08RLSyKCwqCq//y42UDtMRKaYoAAq+WnogjOXoalpRELYit5fdbMCTHWRKAZVoqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qoX5KP71zrOxUOV2RAlEhP2cWBXD4n/9uwUt7x1Y+c=;
 b=Ab+WgxJ6YetBBzHf/XMWs4lUALJkdfiPPeEWM/QMnHCRJU0UKmLIfU1OuugcZsOEIAtVcvrRkLdgdVeepmfTKruZ/YWCMfmi+/uRaoG1reyunVVoDRJTAJ/MVTwHK+l4kqEhiQs1u7/C4o4QnBjVM+Av8jVfd0M3hbq2BNc6fe/f2bTDlPELgKIeeGwATuM1dhLkVlZXwbEANAS0xKzZcdQDE0wI8BxayIVdzE74JQ1YBkVJbcRGFA+G0UjD8nLQ2tDuagZaPTmevCRMuoza5oUxVhplPWenWb+knj395TF3mmP/XWSzBU0UKKgteymoiTGNaSWGVjwqy2NYhyV7mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qoX5KP71zrOxUOV2RAlEhP2cWBXD4n/9uwUt7x1Y+c=;
 b=Cf0zdIMmVwRdrDGiS+SeV9sMqVuJ8uZ6teO18bTAiVq9cmi4uKZoYmBLCWazyLrERVtqMROoc91oc0xqJT8gPCaiWeZFF9ulEIhHoVe3QO6Z6pEmWInsOJOkZcu0iSNz66kmf4nIgIuHoh18Fh9LQfzIs7VrWiA7045zPAin1DI=
Received: from SJ0PR05CA0172.namprd05.prod.outlook.com (2603:10b6:a03:339::27)
 by LV8PR12MB9232.namprd12.prod.outlook.com (2603:10b6:408:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.34; Sun, 10 Mar
 2024 23:12:45 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::7a) by SJ0PR05CA0172.outlook.office365.com
 (2603:10b6:a03:339::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.15 via Frontend
 Transport; Sun, 10 Mar 2024 23:12:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Sun, 10 Mar 2024 23:12:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 10 Mar
 2024 18:12:44 -0500
Date: Sun, 10 Mar 2024 18:12:26 -0500
From: Michael Roth <michael.roth@amd.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata
	<isaku.yamahata@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <20240310231226.nfs2r7wcpuc6eenf@amd.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
 <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
 <ZepiU1x7i-ksI28A@google.com>
 <ZepptFuo5ZK6w4TT@google.com>
 <20240308021941.GM368614@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240308021941.GM368614@ls.amr.corp.intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|LV8PR12MB9232:EE_
X-MS-Office365-Filtering-Correlation-Id: be01bd08-9a6f-4a0e-e418-08dc4157986f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rjyxpqlr+G/JfmCjfFTIwy9MxVP10S0EbnXx8uycGrRY6IyKzuy/ugfBPBTd5XRThL3aZNdVrLBzB9MdWwd9tOXDBarNav6YvAHoZRzUC6BE9HhfQocel8xgD8XUctq1OX67CC0FGZPtkyw4NGex3q6lxiBZEj2e8OQqnoBUUwDJj4PLpNwL/hUIECrSgY39jww9qS36RBWx2PCjXElVQWmnqUf9DdHeygWFLB6kICwZlOCawjKY3jfmFGSNYbenfMn0E2FtQ6RIHfvdfzNrNseDun/AceXVwkJyKBLBs0j83T9Hh19EzxNJSsyIZOGjSXGZ0rc7K9z9DAYxKQdJNuyI+MvxB9zSYWshAT6U4GdAmg43r9vrk9Wf9hjRbMDODnlbndWV9wXRjuYgccPfalSQ+Olp7kRHG7M3tI04AaCdjUYv01JSBh3psTobNxTHrC4nW6RZMgFAFHvtIwZwdzU5nGj/5rHxItv3QrKGJf8EwvrfyWGeMas/dldH6Twq09bztf/RWjhiYHj756z2HD6vY4+M0r1pVvw/ARnJAfcO0tuwzE/orXdVYe8TewsnXb8Hw2I6EuLETvdwp38c9aleFrS3wuuLwSzrgxKmzzYivdWAM944Ib1rHIa/NeqdoRo95OWyK6EI6r3iucRV71x43hJ9kLCtBn3BCc69Qu8JPeV6s/E+jNaOTO54FeIn8jYF5ih4pNu4R6CMN2fj7txyKoRsOBUmoAz15YSMzqnQIAYeKiEvKXnG967YLECa
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2024 23:12:45.3947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be01bd08-9a6f-4a0e-e418-08dc4157986f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9232

On Thu, Mar 07, 2024 at 06:19:41PM -0800, Isaku Yamahata wrote:
> On Thu, Mar 07, 2024 at 05:28:20PM -0800,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Thu, Mar 07, 2024, David Matlack wrote:
> > > On 2024-03-08 01:20 PM, Huang, Kai wrote:
> > > > > > > +:Parameters: struct kvm_memory_mapping(in/out)
> > > > > > > +:Returns: 0 on success, <0 on error
> > > > > > > +
> > > > > > > +KVM_MAP_MEMORY populates guest memory without running vcpu.
> > > > > > > +
> > > > > > > +::
> > > > > > > +
> > > > > > > +  struct kvm_memory_mapping {
> > > > > > > +	__u64 base_gfn;
> > > > > > > +	__u64 nr_pages;
> > > > > > > +	__u64 flags;
> > > > > > > +	__u64 source;
> > > > > > > +  };
> > > > > > > +
> > > > > > > +  /* For kvm_memory_mapping:: flags */
> > > > > > > +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
> > > > > > > +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
> > > > > > > +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
> > > > > > 
> > > > > > I am not sure what's the good of having "FLAG_USER"?
> > > > > > 
> > > > > > This ioctl is called from userspace, thus I think we can just treat this always
> > > > > > as user-fault?
> > > > > 
> > > > > The point is how to emulate kvm page fault as if vcpu caused the kvm page
> > > > > fault.  Not we call the ioctl as user context.
> > > > 
> > > > Sorry I don't quite follow.  What's wrong if KVM just append the #PF USER
> > > > error bit before it calls into the fault handler?
> > > > 
> > > > My question is, since this is ABI, you have to tell how userspace is
> > > > supposed to use this.  Maybe I am missing something, but I don't see how
> > > > USER should be used here.
> > > 
> > > If we restrict this API to the TDP MMU then KVM_MEMORY_MAPPING_FLAG_USER
> > > is meaningless, PFERR_USER_MASK is only relevant for shadow paging.
> > 
> > +1
> > 
> > > KVM_MEMORY_MAPPING_FLAG_WRITE seems useful to allow memslots to be
> > > populated with writes (which avoids just faulting in the zero-page for
> > > anon or tmpfs backed memslots), while also allowing populating read-only
> > > memslots.
> > > 
> > > I don't really see a use-case for KVM_MEMORY_MAPPING_FLAG_EXEC.
> > 
> > It would midly be interesting for something like the NX hugepage mitigation.
> > 
> > For the initial implementation, I don't think the ioctl() should specify
> > protections, period.
> > 
> > VMA-based mappings, i.e. !guest_memfd, already have a way to specify protections.
> > And for guest_memfd, finer grained control in general, and long term compatibility
> > with other features that are in-flight or proposed, I would rather userspace specify
> > RWX protections via KVM_SET_MEMORY_ATTRIBUTES.  Oh, and dirty logging would be a
> > pain too.
> > 
> > KVM doesn't currently support execute-only (XO) or !executable (RW), so I think
> > we can simply define KVM_MAP_MEMORY to behave like a read fault.  E.g. map RX,
> > and add W if all underlying protections allow it.
> > 
> > That way we can defer dealing with things like XO and RW *if* KVM ever does gain
> > support for specifying those combinations via KVM_SET_MEMORY_ATTRIBUTES, which
> > will likely be per-arch/vendor and non-trivial, e.g. AMD's NPT doesn't even allow
> > for XO memory.
> > 
> > And we shouldn't need to do anything for KVM_MAP_MEMORY in particular if
> > KVM_SET_MEMORY_ATTRIBUTES gains support for RWX protections the existing RWX and
> > RX combinations, e.g. if there's a use-case for write-protecting guest_memfd
> > regions.
> > 
> > We can always expand the uAPI, but taking away functionality is much harder, if
> > not impossible.
> 
> Ok, let me drop all the flags.  Here is the updated one.
> 
> 4.143 KVM_MAP_MEMORY
> ------------------------
> 
> :Capability: KVM_CAP_MAP_MEMORY
> :Architectures: none
> :Type: vcpu ioctl
> :Parameters: struct kvm_memory_mapping(in/out)
> :Returns: 0 on success, < 0 on error
> 
> Errors:
> 
>   ======   =============================================================
>   EINVAL   vcpu state is not in TDP MMU mode or is in guest mode.
>            Currently, this ioctl is restricted to TDP MMU.
>   EAGAIN   The region is only processed partially.  The caller should
>            issue the ioctl with the updated parameters.
>   EINTR    An unmasked signal is pending.  The region may be processed
>            partially.  If `nr_pages` > 0, the caller should issue the
>            ioctl with the updated parameters.
>   ======   =============================================================
> 
> KVM_MAP_MEMORY populates guest memory before the VM starts to run.  Multiple
> vcpus can call this ioctl simultaneously.  It may result in the error of EAGAIN
> due to race conditions.
> 
> ::
> 
>   struct kvm_memory_mapping {
> 	__u64 base_gfn;
> 	__u64 nr_pages;
> 	__u64 flags;
> 	__u64 source;
>   };
> 
> KVM_MAP_MEMORY populates guest memory at the specified range (`base_gfn`,
> `nr_pages`) in the underlying mapping. `source` is an optional user pointer.  If
> `source` is not NULL and the underlying technology supports it, the memory
> contents of `source` are copied into the guest memory.  The backend may encrypt
> it.  `flags` must be zero.  It's reserved for future use.
> 
> When the ioctl returns, the input values are updated.  If `nr_pages` is large,
> it may return EAGAIN or EINTR for pending signal and update the values
> (`base_gfn` and `nr_pages`.  `source` if not zero) to point to the remaining
> range.

If this intended to replace SNP_LAUNCH_UPDATE, then to be useable for SNP
guests userspace also needs to pass along the type of page being added,
which are currently defined as:

  #define KVM_SEV_SNP_PAGE_TYPE_NORMAL            0x1
  #define KVM_SEV_SNP_PAGE_TYPE_ZERO              0x3
  #define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED        0x4
  #define KVM_SEV_SNP_PAGE_TYPE_SECRETS           0x5
  #define KVM_SEV_SNP_PAGE_TYPE_CPUID             0x6

So I guess the main question is, do bite the bullet now and introduce
infrastructure for vendor-specific parameters, or should we attempt to define
these as cross-vendor/cross-architecture types and hide the vendor-specific
stuff from userspace?

There are a couple other bits of vendor-specific information that would be
needed to be a total drop-in replacement for SNP_LAUNCH_UPDATE, but I think
these we could can do without:

  sev_fd: handle for /dev/sev which is used to issue SEV firmware calls
          as-needed for various KVM ioctls
          - can likely bind this to SNP context during SNP_LAUNCH_UPDATE and
            avoid needing to pass it in for subsequent calls
  error code: return parameter which passes SEV firmware error codes to
              userspace for informational purposes
              - can probably live without this

-Mike

> 
> -- 
> Isaku Yamahata <isaku.yamahata@linux.intel.com>

