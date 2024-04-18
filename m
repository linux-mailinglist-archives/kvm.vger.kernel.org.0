Return-Path: <kvm+bounces-15168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A71758AA3A7
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 22:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D366C1C233AD
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB6F17B4F8;
	Thu, 18 Apr 2024 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gdHx1lqI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600BB3D62;
	Thu, 18 Apr 2024 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713470604; cv=fail; b=Rxi6X+rygzlCsrfUNo3wAU0xA14QHfdINxomZi+cFlo7je292hFXs4KNbCPf3KxmHjYRjDq8n+kVkBGFTqPpGiFDyjdbMxMZ/9fZk/yQnMqjFAz8ZIuKiccFpSFHZI7XJmaYJzsTL/e+QhGuY6tJrEg6+/Ya/sNsd/YW0UaEBJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713470604; c=relaxed/simple;
	bh=052H+aW9suF3VfJSnAm85r92IAzTRYyjmGREvPhhEJM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpUnxJLxjya3RoYhJK+cOncpZJjx7d0WG70/XHqVO4IVBDzctseGlH/djTqxIquD8ccB79a24LmC1XGslWJCOn703T/8GekzfDuLRIqTgB/EN6vNuZDobgoxHcc0ieb9NVBCmeAevEIM88z+qBE38Q1H8QgUF+CYPfXfcaY5Dw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gdHx1lqI; arc=fail smtp.client-ip=40.107.102.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGhP7uiwuD8meaSLEgq6eNWYi5WcHZWypPagBUFVSB6RoU4F8MDVMjU/LqaBcTkfsyhjGIZ/U9Yb2ph9tpIH1ooYxXbS4XEq0Om1QvXpoW3+NRxW3klq2fHpzJzhxx8OJGY0p4TeFAQdGfBz9sutQ2KoZPB9T/DUS12t8qOvp5vNXwqTSO+m5JlCfHAP/UcT9TD2KDNqQckfPBhFL7vMR9+PhDTAIjz4/278HnfCNybIcN3tQo7VZVkS5eu4vGryX1HjPQ9tU/f+4bRWmJ4scOTRXQQWvd1dTzz0rOo31ZRE+QkLx4QmmmUDaH5VU5DSJsJg4ZTakG/5R44EoGzSOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWUZwqBM7GZGVd9g4qAU12o35H4l74rP3aHiyiVwwp0=;
 b=Qblz3eH4nNts/lZFkkD2NsrPGjD6zbYXMfHW63tVzAK1S4Kh5APnXj5YLfA2mxSpFbrQmC6IRtiBV6+DxJvnhBFF58/Wr0YFzRWVEKnfgxkvL+wjJ2WLJU0z+NahOYQLEm9IddyO4Y+EFIfe7OhxOYc7oPaTxQypr+cysdQCghrC0feEmCTEH0g7SshmOpoEf9cdyluh6x5DR5FMjE//mrCVsAygkeVP+ERqIjk+8rgV7nxvUjekbt0qKHZN512arkYPlOt6jsxiDoDLqITkaeUKiB9Ah5rEXoeC3gxj8dzvL6x4GnsKgKFcI88GfhNfZRbVnL7eS7q0l4kNE0Tt5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWUZwqBM7GZGVd9g4qAU12o35H4l74rP3aHiyiVwwp0=;
 b=gdHx1lqIxigYH474PYgDlI2vDqyZ4z+EKe7BFPoKPEKX5X2nrr1bvqNNKXE74hH/uJjeWkeFgoTpxDrjrvMrWiEI7F/kK7/uC7DvCKkS0P0JSAUyb27a0XMCS21mMqnDeCMy0KBuPj3JXOE8XsrTa56QqlmYFi+gPIxZcfEj9Es=
Received: from MN2PR18CA0001.namprd18.prod.outlook.com (2603:10b6:208:23c::6)
 by DM4PR12MB8521.namprd12.prod.outlook.com (2603:10b6:8:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 20:03:15 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::19) by MN2PR18CA0001.outlook.office365.com
 (2603:10b6:208:23c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.26 via Frontend
 Transport; Thu, 18 Apr 2024 20:03:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 20:03:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 15:03:14 -0500
Date: Thu, 18 Apr 2024 14:57:54 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidating
 private pages
Message-ID: <20240418195754.h6gl5qd62kas7crx@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-23-michael.roth@amd.com>
 <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|DM4PR12MB8521:EE_
X-MS-Office365-Filtering-Correlation-Id: 4012ab85-c981-4eab-f4e6-08dc5fe295a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YzpMOCb/tgZpKgq6eE8r5BNSDeWJt2o4Yg9Smzth5/FJTwpiH9MUp6rj2xRIpTur8IaHEL2t8TNyNtzefBdWy2GEiHzQrrRn4Ealkm2QYHQZaLwn75B1UmfArVMkQPSe2JwgUmYf5+DefztPZcBJy9i9kWRfZad+oKrN4IxwwrX0Q/6rmEwtVMBr58tx6lJrVX9qVXcXWifnfG4mD5obuq9/UpA3kvecnVVp6nPkVSnDGqeqeM1R0FlVj4Mw/JpNdVVy9cqp2mwn59jGGrhIGcAIkStv+4Z7qxXVIxUz0PqcEOnpAO5hSQUA5SgBlDPNNqEly5phg21cyF7JCP+VFoQ+8sgAIKm60VGDXi7tfxUBbrPmdM/VrZYSwaHftz9FuhcQiNEEWb48XpSU4wmU++xVIOGVxDLRm2ZBNrSuw9U0qbZlPo1iljG2IK78NasMFznlpoMI1uE8GqDxpO9mzi5iHWtuDCdP/gGC6r2BAxbmm/wjwBNz3jTHgHhMNHzF90Tln9RnatyEwVCev+X0bA+ZXTViPS1FdY1hLS6X8amjSs4SJ5J41WQA6D4EpeF+9tUKYfYkOsz/ICI+8dEjFVqsgRqHZQSqQwv91E6O3ZOqa47pQzMnp5790v1mHdPj3SIyq7Gso/nE30kX6UPNFvACqv2lsGxNh8Q9JtULXFkrmSg1g4QHqYgX2TBRW7DFMQSj/oGcM1aY9QLJGK97fg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(376005)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 20:03:15.5937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4012ab85-c981-4eab-f4e6-08dc5fe295a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8521

On Sat, Mar 30, 2024 at 10:31:47PM +0100, Paolo Bonzini wrote:
> On 3/29/24 23:58, Michael Roth wrote:
> > +		/*
> > +		 * If an unaligned PFN corresponds to a 2M region assigned as a
> > +		 * large page in he RMP table, PSMASH the region into individual
> > +		 * 4K RMP entries before attempting to convert a 4K sub-page.
> > +		 */
> > +		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
> > +			rc = snp_rmptable_psmash(pfn);
> > +			if (rc)
> > +				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
> > +						   pfn, rc);
> > +		}
> 
> Ignoring the PSMASH failure is pretty scary...  At this point .free_folio
> cannot fail, should the psmash part of this patch be done in
> kvm_gmem_invalidate_begin() before kvm_mmu_unmap_gfn_range()?
> 
> Also, can you get PSMASH_FAIL_INUSE and if so what's the best way to address
> it?  Should fallocate() return -EBUSY?

FAIL_INUSE shouldn't occur since at this point the pages have been unmapped
from NPT and only the task doing the cleanup should be attempting to
access/PSMASH this particular 2M HPA range at this point.

However, since FAIL_INUSE is transient, there isn't a good reason why we
shouldn't retry until it clears itself up rather than risk hosing the
system if some unexpected case ever did pop up, so I've updated
snp_rmptable_psmash() to handle that case automatically and simplify the
handling in sev_handle_rmp_fault() as well. (in the case of #NPF RMP
faults there is actually potential for PSMASH errors other than
FAIL_INUSE due to races with other vCPU threads which can interleave and
put the RMP entry in an unexpected state, so there's additional
handling/reporting to deal with those cases, but here they are not expected
and will trigger WARN_*ONCE()'s now)

I used this hacked up version of Sean's original patch to re-enable 2MB
hugepage support in gmem for the purposes of re-testing this:

  https://github.com/mdroth/linux/commit/15aa4f81811485997953130fc184e829ba4399d2

-Mike

> 
> Thanks,
> 
> Paolo
> 
> 

