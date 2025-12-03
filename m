Return-Path: <kvm+bounces-65215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 78404C9F49B
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DDB054E2B4C
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4462C2FB62A;
	Wed,  3 Dec 2025 14:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Nr1xA+jo"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010048.outbound.protection.outlook.com [40.93.198.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8347231A30;
	Wed,  3 Dec 2025 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772055; cv=fail; b=ueEaBh0fi+ffZkREo33n6T8iuTjUuI8X5TQZFVSskm3yd/SHwDFaYVzzS1f9WKNdt6B6UNwLYJtU5iscaq0Sj37/D9AGtG5RuDecixPaj2cUn2Wh2Q73FLftAhNE9T8lkHZ4owOjd7zi1fmjhRQa6p/kljaflw2FY16DWpJR+mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772055; c=relaxed/simple;
	bh=owRW84fVGUtfS08V4vrJS/qwxw5vdDOvyhjmyhjEVMQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TAskLeGtWIPohPZFyP53dz7IgIotGMJkRfZOsg9KXS6kzBhrYoh67Avxst532h+YkEMctTDlo6i5EBeA/SSkO8km9RztsRn0bTpDmMTMI//q1XZYNMfJ3EA9YtGglLgUC+ScIz8wsICauYnZMlPZCkC56aME6h9azajFZ71AF1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Nr1xA+jo; arc=fail smtp.client-ip=40.93.198.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FmHk+4gwq14wQAGE31Q2Y9Samm3oaZDXEklfegT6n84fNQPT3nejn+qwknKNPJ6GsQX6+z5eRUjKU+qcLxSYREhyg/KZ3CzOz325SmrwTjjCbIf+GPRguMZdYwvYX8e4du0N9tQo2EkydhX29hQaqGtOrPHsBnOzvBDQ9zlG/xFQPcaGGe3tDo1hwG9YA8RhoX0iXV3sb7U+l8StpUIhna5jHT8o9KvQ8dJhLqtDnzW4os17udYIoNA2WH2ykojL8pA2MCdwno7UbbiprdL0qO1oCPfy2PVunx1JzRVNiwULL7skGfdJAVlewgsorSL+vmI6qmf0o0K5iYOV0IAHxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLq3sRCccuBOY5xQm+JCcpgvrlciKDLjyDK5GLunx1w=;
 b=YkvQ0cHsmFVD2zDQQ78n5/RosC1qAGyVu8mfURYLkniCU9YD7FimcGZRWVbLLgCqdgIcFU1AbAN6pqpOY2+wUG6IZtTJUjpJImEf7zwEpBA7lyGlewhqNlbENA+PU2aCn/Tz1vl849fb/vqzYH0WKCzHeqpvA2TXQ6OteSWw186Qds24Fh4iYfA+7xzWurSoA8HpTWpsLDc26fUGcJKUCZ+WYL/mQmjwGQoBeog3CeOdZklYaNvO60IIL/hBEgf3GDrrOiXv5PpL6oR1a8ZPor4LG9I+TtXqJ0x7ybOGIA9Sw2C82EmcNrGPIghnoaFMxiM7plj/qK6ZJphOqSRXZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLq3sRCccuBOY5xQm+JCcpgvrlciKDLjyDK5GLunx1w=;
 b=Nr1xA+jofTuYZ8XgQYON9mwiUHGea3iXvK0huYthONjumabSlZUdZpW/iccKL7LAjvEka2RY0uc/HjiTIg5qFp1KT79BmnTAvBL8gDuJOj3fevzAywl0c3Q+qtsMFMQWAO3+cffr7VH2K09Z/ocdLBlse5HYHRHF7Ir72sd0+V0=
Received: from BN9PR03CA0134.namprd03.prod.outlook.com (2603:10b6:408:fe::19)
 by CH3PR12MB9431.namprd12.prod.outlook.com (2603:10b6:610:1c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 14:27:29 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::f9) by BN9PR03CA0134.outlook.office365.com
 (2603:10b6:408:fe::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Wed,
 3 Dec 2025 14:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Wed, 3 Dec 2025 14:27:29 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 08:27:28 -0600
Date: Wed, 3 Dec 2025 08:26:48 -0600
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251203142648.trx6sslxvxr26yzd@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <20251201221355.wvsm6qxwxax46v4t@amd.com>
 <aS+kg+sHJ0lveupH@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aS+kg+sHJ0lveupH@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|CH3PR12MB9431:EE_
X-MS-Office365-Filtering-Correlation-Id: d9eca301-724a-4f86-076c-08de327816a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AOzriAtEEAuCXs9S0tPRcFFbB1aJ8Hw9Tht5IpTB2rw+YQxZq7+T/2oQPH+d?=
 =?us-ascii?Q?MFE8Auomny/h3ZfUHQ5CS+8CPrPcuZuy3u70DPzaqsg+Sq0I8sG6lMTuqGf+?=
 =?us-ascii?Q?/z/e6NcqpBoXobl3wW/WZ254CcdMAia9j52pHq5jT4yJzPbEcJbrDgUiTPJr?=
 =?us-ascii?Q?2QBAIRVyoEQF/JZZkgR7wEXk3xCIlGk7K5j4UZEPue7lozdBSpijfYtqsMKH?=
 =?us-ascii?Q?jI9zuCb4akeGaOR9qFrtZDQWzghKXj/0WRJMFc7ix9CZwyKSKYxVnKH335Iy?=
 =?us-ascii?Q?p9s3HUAtMtvcINGLRf4rkDnDUeEZzcb3B0lw9a6Wwz99ebaeJV+EPQqE/Suo?=
 =?us-ascii?Q?gCP8zYRN+HHbwN7s+Qwc8a3r0oZY56l9MH+7T6Q1xupiqDJujln7MhSNMdmZ?=
 =?us-ascii?Q?M2mr2q/zA0uCkVp+7GZZtRYK9wU7azheAsuFIAelQRLoRXQsSzhV1oE92kXa?=
 =?us-ascii?Q?vYJLSuhRVlZoNz5Qyce5fW8dLSV7nXOd6fLLcpoumattTrl0+WDu0yjUY+2q?=
 =?us-ascii?Q?tWn3JxLX8Mh6Zw8Ao0wOrSJAG3aKs6f0ZKWi3u9pGAL8rrTLSwTfLfzI+JE5?=
 =?us-ascii?Q?SmYZesKPE2M7J9oZUBygCzAL4OFoY0pC3eLauWEM7FjPcakOz2qgb1PJQS7j?=
 =?us-ascii?Q?AkawmDfsyh3VgvGr8sYsq6Ch7ROVp/o7yUBf04QENfwqyWblJZRJG00Y/CR+?=
 =?us-ascii?Q?kFfKmup+/6rTVCsdY7yEeRM9i5lQWIm4CrYX/cVMCzyHCPVbGfS58CPW78mm?=
 =?us-ascii?Q?jbySP8zWYTIuVi7zD56IV8G4k4BQzx/qkvsJnGMD3XSQmBEACIkbaz3d8tJc?=
 =?us-ascii?Q?bMVYW6zZh3T7mE1SwQ96h6+mj3iacf3XH4J6VhQUKgSCvCL0Vp67IFWy0JZp?=
 =?us-ascii?Q?M146MdJgE10pgML1spXiZs4B/Q5cMAfg2fU9pqLmeKkQZzBokgR5yOvXU9gZ?=
 =?us-ascii?Q?2zJmnhf9WpCYhIulougfW/lBQLoZUButXczGzjfDTA9ZqHdn0Y7dSK5bNZKN?=
 =?us-ascii?Q?foR58B2ZAmRBY+6WDOQc9txfyOaK9CKGjJolG9vccZppNf9W89evfzQAngh9?=
 =?us-ascii?Q?q8UgM5rYTR7f+1R0E1DX/TOvTr1H+eenQmLInKcJpnMi/HtOkBry1lL6IDpO?=
 =?us-ascii?Q?LreZUgiaGz0KyAZypetI+OitLvTZG39vcN/DJEHnu2tAzzyfMdsRSN1EdGzH?=
 =?us-ascii?Q?8OlQujSDE5VYVUIPAjmm5tulD4NaB1vjXeRtLH4yi/w1SCGkhkcNj+8aFk3r?=
 =?us-ascii?Q?Q4Ycec+WTsZYpQ7hl99WWitUIlNxRxdNffAuJ9QHsZb7Cwv9N3uZQm+Y0E+o?=
 =?us-ascii?Q?lT+3PJluzIp0xygji0aMFG1AMXJYO9w3I66TzSSgnSKGKeDAb7WoBk5T91rA?=
 =?us-ascii?Q?7N/b697pAUbtMIkRKf8PhaekrL/B55KFtlWTfm/OrtiTX9iwvPbVyD3AXcXF?=
 =?us-ascii?Q?haWTQlbaDy4hd6lTm7/yi/9JJQN6eelIbVLWvBkt4I2q1iqYHptLJYqUmoG9?=
 =?us-ascii?Q?L+pcKDhAWFKrnqTIBOSBIAFHSRG69xPmPPWv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 14:27:29.0076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9eca301-724a-4f86-076c-08de327816a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9431

On Wed, Dec 03, 2025 at 10:46:27AM +0800, Yan Zhao wrote:
> On Mon, Dec 01, 2025 at 04:13:55PM -0600, Michael Roth wrote:
> > On Mon, Nov 24, 2025 at 05:31:46PM +0800, Yan Zhao wrote:
> > > On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > > > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> > > > > > Currently the post-populate callbacks handle copying source pages into
> > > > > > private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> > > > > > acquires the filemap invalidate lock, then calls a post-populate
> > > > > > callback which may issue a get_user_pages() on the source pages prior to
> > > > > > copying them into the private GPA (e.g. TDX).
> > > > > > 
> > > > > > This will not be compatible with in-place conversion, where the
> > > > > > userspace page fault path will attempt to acquire filemap invalidate
> > > > > > lock while holding the mm->mmap_lock, leading to a potential ABBA
> > > > > > deadlock[1].
> > > > > > 
> > > > > > Address this by hoisting the GUP above the filemap invalidate lock so
> > > > > > that these page faults path can be taken early, prior to acquiring the
> > > > > > filemap invalidate lock.
> > > > > > 
> > > > > > It's not currently clear whether this issue is reachable with the
> > > > > > current implementation of guest_memfd, which doesn't support in-place
> > > > > > conversion, however it does provide a consistent mechanism to provide
> > > > > > stable source/target PFNs to callbacks rather than punting to
> > > > > > vendor-specific code, which allows for more commonality across
> > > > > > architectures, which may be worthwhile even without in-place conversion.
> > > > > > 
> > > > > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > > > ---
> > > > > >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> > > > > >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> > > > > >  include/linux/kvm_host.h |  3 ++-
> > > > > >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> > > > > >  4 files changed, 71 insertions(+), 35 deletions(-)
> > > > > > 
> > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > index 0835c664fbfd..d0ac710697a2 100644
> > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> > > > > >  };
> > > > > >  
> > > > > >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > > > > > -				  void __user *src, int order, void *opaque)
> > > > > > +				  struct page **src_pages, loff_t src_offset,
> > > > > > +				  int order, void *opaque)
> > > > > >  {
> > > > > >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> > > > > >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > > > > > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > >  	int npages = (1 << order);
> > > > > >  	gfn_t gfn;
> > > > > >  
> > > > > > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > > > > > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> > > > > >  		return -EINVAL;
> > > > > >  
> > > > > >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > > > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > >  			goto err;
> > > > > >  		}
> > > > > >  
> > > > > > -		if (src) {
> > > > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > > > +		if (src_pages) {
> > > > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > > >  
> > > > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > > > -				ret = -EFAULT;
> > > > > > -				goto err;
> > > > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > > > +			kunmap_local(src_vaddr);
> > > > > > +
> > > > > > +			if (src_offset) {
> > > > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > > +
> > > > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > > > +				kunmap_local(src_vaddr);
> > > > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > > > 
> > > > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > > > 
> > > > src_offset ends up being the offset into the pair of src pages that we
> > > > are using to fully populate a single dest page with each iteration. So
> > > > if we start at src_offset, read a page worth of data, then we are now at
> > > > src_offset in the next src page and the loop continues that way even if
> > > > npages > 1.
> > > > 
> > > > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > > > the 2nd memcpy is skipped on every iteration.
> > > > 
> > > > That's the intent at least. Is there a flaw in the code/reasoning that I
> > > > missed?
> > > Oh, I got you. SNP expects a single src_offset applies for each src page.
> > > 
> > > So if npages = 2, there're 4 memcpy() calls.
> > > 
> > > src:  |---------|---------|---------|  (VA contiguous)
> > >           ^         ^         ^
> > >           |         |         |
> > > dst:      |---------|---------|   (PA contiguous)
> > > 
> > > 
> > > I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> > > as 0 for the 2nd src page.
> > > 
> > > Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> > > snp_launch_update() to simplify the design?
> > 
> > This was an option mentioned in the cover letter and during PUCK. I am
> > not opposed if that's the direction we decide, but I also don't think
> > it makes big difference since:
> > 
> >    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >                                struct page **src_pages, loff_t src_offset,
> >                                int order, void *opaque);
> > 
> > basically reduces to Sean's originally proposed:
> > 
> >    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >                                struct page *src_pages, int order,
> >                                void *opaque);
> 
> Hmm, the requirement of having each copy to dst_page account for src_offset
> (which actually results in 2 copies) is quite confusing. I initially thought the
> src_offset only applied to the first dst_page.

What I'm wondering though is if I'd done a better job of documenting
this aspect, e.g. with the following comment added above
kvm_gmem_populate_cb:

  /*
   * ...
   * 'src_pages': array of GUP'd struct page pointers corresponding to
   *              the pages that store the data that is to be copied
   *              into the HPA corresponding to 'pfn'
   * 'src_offset': byte offset, relative to the first page in the array
   *               of pages pointed to by 'src_pages', to begin copying
   *               the data from.
   *
   * NOTE: if the caller of kvm_gmem_populate() enforces that 'src' is
   * page-aligned, then 'src_offset' will always be zero, and src_pages
   * will contain only 1 page to copy from, beginning at byte offset 0.
   * In this case, callers can assume src_offset is 0.
   */
  int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
                              struct page **src_pages, loff_t src_offset,
                              int order, void *opaque);

could the confusion have been avoided, or is it still unwieldly?

I don't mind that users like SNP need to deal with the extra bits, but
I'm hoping for users like TDX it isn't too cludgy.

> 
> This will also cause kvm_gmem_populate() to allocate 1 more src_npages than
> npages for dst pages.

That's more of a decision on the part of userspace deciding to use
non-page-aligned 'src' pointer to begin with.

> 
> > for any platform that enforces that the src is page-aligned, which
> > doesn't seem like a huge technical burden, IMO, despite me initially
> > thinking it would be gross when I brought this up during the PUCK call
> > that preceeding this posting.
> > > 
> > > > > 
> > > > > >  			}
> > > > > > -			kunmap_local(vaddr);
> > > > > > +
> > > > > > +			kunmap_local(dst_vaddr);
> > > > > >  		}
> > > > > >  
> > > > > >  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> > > > > > @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > >  	if (!snp_page_reclaim(kvm, pfn + i) &&
> > > > > >  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> > > > > >  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> > > > > > -		void *vaddr = kmap_local_pfn(pfn + i);
> > > > > > +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > > +		void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > > >  
> > > > > > -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> > > > > > -			pr_debug("Failed to write CPUID page back to userspace\n");
> > > > > > +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> > > > > > +		kunmap_local(src_vaddr);
> > > > > > +
> > > > > > +		if (src_offset) {
> > > > > > +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > > +
> > > > > > +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
> > > > > > +			kunmap_local(src_vaddr);
> > > > > > +		}
> > > > > >  
> > > > > > -		kunmap_local(vaddr);
> > > > > > +		kunmap_local(dst_vaddr);
> > > > > >  	}
> > > > > >  
> > > > > >  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> > > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > > > index 57ed101a1181..dd5439ec1473 100644
> > > > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > > > @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
> > > > > >  };
> > > > > >  
> > > > > >  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > > > -				  void __user *src, int order, void *_arg)
> > > > > > +				  struct page **src_pages, loff_t src_offset,
> > > > > > +				  int order, void *_arg)
> > > > > >  {
> > > > > >  	struct tdx_gmem_post_populate_arg *arg = _arg;
> > > > > >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > > >  	u64 err, entry, level_state;
> > > > > >  	gpa_t gpa = gfn_to_gpa(gfn);
> > > > > > -	struct page *src_page;
> > > > > >  	int ret, i;
> > > > > >  
> > > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > > > > >  		return -EIO;
> > > > > >  
> > > > > > -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> > > > > > +	/* Source should be page-aligned, in which case src_offset will be 0. */
> > > > > > +	if (KVM_BUG_ON(src_offset))
> > > > > 	if (KVM_BUG_ON(src_offset, kvm))
> > > > > 
> > > > > >  		return -EINVAL;
> > > > > >  
> > > > > > -	/*
> > > > > > -	 * Get the source page if it has been faulted in. Return failure if the
> > > > > > -	 * source page has been swapped out or unmapped in primary memory.
> > > > > > -	 */
> > > > > > -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> > > > > > -	if (ret < 0)
> > > > > > -		return ret;
> > > > > > -	if (ret != 1)
> > > > > > -		return -ENOMEM;
> > > > > > -
> > > > > > -	kvm_tdx->page_add_src = src_page;
> > > > > > +	kvm_tdx->page_add_src = src_pages[i];
> > > > > src_pages[0] ? i is not initialized. 
> > > > 
> > > > Sorry, I switched on TDX options for compile testing but I must have done a
> > > > sloppy job confirming it actually built. I'll re-test push these and squash
> > > > in the fixes in the github tree.
> > > > 
> > > > > 
> > > > > Should there also be a KVM_BUG_ON(order > 0, kvm) ?
> > > > 
> > > > Seems reasonable, but I'm not sure this is the right patch. Maybe I
> > > > could squash it into the preceeding documentation patch so as to not
> > > > give the impression this patch changes those expectations in any way.
> > > I don't think it should be documented as a user requirement.
> > 
> > I didn't necessarily mean in the documentation, but mainly some patch
> > other than this. If we add that check here as part of this patch, we
> > give the impression that the order expectations are changing as a result
> > of the changes here, when in reality they are exactly the same as
> > before.
> > 
> > If not the documentation patch here, then I don't think it really fits
> > in this series at all and would be more of a standalone patch against
> > kvm/next.
> > 
> > The change here:
> > 
> >  -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> >  +	/* Source should be page-aligned, in which case src_offset will be 0. */
> >  +	if (KVM_BUG_ON(src_offset))
> > 
> > made sense as part of this patch, because now that we are passing struct
> > page *src_pages, we can no longer infer alignment from 'src' field, and
> > instead need to infer it from src_offset being 0.
> > 
> > > 
> > > However, we need to comment out that this assertion is due to that
> > > tdx_vcpu_init_mem_region() passes npages as 1 to kvm_gmem_populate().
> > 
> > You mean for the KVM_BUG_ON(order > 0, kvm) you're proposing to add?
> > Again, if feels awkward to address this as part of this series since it
> > is an existing/unchanged behavior and not really the intent of this
> > patchset.
> That's true. src_pages[0] just makes it more eye-catching.
> What about just adding a comment for src_pages[0] instead of KVM_BUG_ON()?

That seems fair/relevant for this series.

> 
> > > > > >  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> > > > > >  	kvm_tdx->page_add_src = NULL;
> > > > > >  
> > > > > > -	put_page(src_page);
> > > > > > -
> > > > > >  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> > > > > >  		return ret;
> > > > > >  
> > > > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > > > index d93f75b05ae2..7e9d2403c61f 100644
> > > > > > --- a/include/linux/kvm_host.h
> > > > > > +++ b/include/linux/kvm_host.h
> > > > > > @@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
> > > > > >   * Returns the number of pages that were populated.
> > > > > >   */
> > > > > >  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > > > -				    void __user *src, int order, void *opaque);
> > > > > > +				    struct page **src_pages, loff_t src_offset,
> > > > > > +				    int order, void *opaque);
> > > > > >  
> > > > > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> > > > > >  		       kvm_gmem_populate_cb post_populate, void *opaque);
> > > > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > > > index 9160379df378..e9ac3fd4fd8f 100644
> > > > > > --- a/virt/kvm/guest_memfd.c
> > > > > > +++ b/virt/kvm/guest_memfd.c
> > > > > > @@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> > > > > >  
> > > > > >  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> > > > > > +
> > > > > > +#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
> > > > > Limiting GMEM_GUP_NPAGES to PMD_ORDER may only work when the max_order of a huge
> > > > > folio is 2MB. What if the max_order returned from  __kvm_gmem_get_pfn() is 1GB
> > > > > when src_pages[] can only hold up to 512 pages?
> > > > 
> > > > This was necessarily chosen in prep for hugepages, but more about my
> > > > unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
> > > > happens to align with 2MB hugepages while seeming like a reasonable
> > > > batching value so that's why I chose it.
> > > >
> > > > Even with 1GB support, I wasn't really planning to increase it. SNP
> > > > doesn't really make use of RMP sizes >2MB, and it sounds like TDX
> > > > handles promotion in a completely different path. So atm I'm leaning
> > > > toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
> > > > support for kvm_gmem_populate() path and not bothering to change it
> > > > until a solid use-case arises.
> > > The problem is that with hugetlb-based guest_memfd, the folio itself could be
> > > of 1GB, though SNP and TDX can force mapping at only 4KB.
> > 
> > If TDX wants to unload handling of page-clearing to its per-page
> > post-populate callback and tie that its shared/private tracking that's
> > perfectly fine by me.
> > 
> > *How* TDX tells gmem it wants this different behavior is a topic for a
> > follow-up patchset, Vishal suggested kernel-internal flags to
> > kvm_gmem_create(), which seemed reasonable to me. In that case, uptodate
> Not sure which flag you are referring to with "Vishal suggested kernel-internal
> flags to kvm_gmem_create()".
> 
> However, my point is that when the backend folio is 1GB in size (leading to
> max_order being PUD_ORDER), even if SNP only maps at 2MB to RMP, it may hit the
> warning of "!IS_ALIGNED(gfn, 1 << max_order)".

I think I've had to remove that warning every time I start working on
some new spin of THP/hugetlbfs-based SNP. I'm not objecting to that. But it's
obvious there, in those contexts, and I can explain exactly why it's being
removed.

It's not obvious in this series, where all we have are hand-wavy thoughts
about what hugepages will look like. For all we know we might decide that
kvm_gmem_populate() path should just pre-split hugepages to make all the
logic easier, or we decide to lock it in at 4K-only and just strip all the
hugepage stuff out. I don't really know, and this doesn't seem like the place
to try to hash all that out when nothing in this series will cause this
existing WARN_ON to be tripped.

> 
> For TDX, it's worse because it always passes npages as 1, so it will also hit
> the warning of "(npages - i) < (1 << max_order)".
> 
> Given that this patch already considers huge pages for SNP, it feels half-baked
> to leave the WARN_ON() for future handling.
>     WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>             (npages - i) < (1 << max_order));
> 
> > flag would probably just default to set and punt to post-populate/prep
> > hooks, because we absolutely *do not* want to have to re-introduce per-4K
> > tracking of this type of state within gmem, since getting rid of that sort
> > of tracking requirement within gmem is the entire motivation of this
> > series. And since, within this series, the uptodate flag and
> > prep-tracking both have the same 4K granularity, it seems unecessary to
> > address this here.
> > 
> > If you were to send a patchset on top of this (or even independently) that
> > introduces said kernel-internal gmem flag to offload uptodate-tracking to
> > post-populate/prep hooks, and utilize it to optimize the current 4K-only
> > TDX implementation by letting TDX module handle the initial
> > page-clearing, then I think that change/discussion can progress without
> > being blocked in any major way by this series.
> > 
> > But I don't think we need to flesh all that out here, so long as we are
> > aware of this as a future change/requirement and have reasonable
> > indication that it is compatible with this series.
> > 
> > > 
> > > Then since max_order = folio_order(folio) (at least in the tree for [1]), 
> > > WARN_ON() in kvm_gmem_populate() could still be hit:
> > > 
> > > folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> > > WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > >         (npages - i) < (1 << max_order));
> > 
> > Yes, in the SNP implementation of hugetlb I ended up removing this
> > warning, and in that case I also ended up forcing kvm_gmem_populate() to
> > be 4K-only:
> > 
> >   https://github.com/AMDESE/linux/blob/snp-hugetlb-v2-wip0/virt/kvm/guest_memfd.c#L2372
> 
> For 1G (aka HugeTLB) page, this fix is also needed, which was missed in [1] and
> I pointed out to Ackerley at [2].
> 
> [1] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
> [2] https://lore.kernel.org/all/aFPGPVbzo92t565h@yzhao56-desk.sh.intel.com/

Yes, we'll likely need some kind of change here.

I think, if we're trying to find common ground to build hugepage support
on, you can assume this will be removed. But I just don't think we need
to squash that into this series in order to make progress on those ends.

> 
> > but it makes a lot more sense to make those restrictions and changes in
> > the context of hugepage support, rather than this series which is trying
> > very hard to not do hugepage enablement, but simply keep what's partially
> > there intact while reworking other things that have proven to be
> > continued impediments to both in-place conversion and hugepage
> > enablement.
> Not sure how fixing the warning in this series could impede hugepage enabling :)
> 
> But if you prefer, I don't mind keeping it locally for longer.

It's the whole burden of needing to anticipate hugepage design, while it
is in a state of potentially massive flux just before LPC, in order to
make tiny incremental progress toward enabling in-place conversion,
which is something I think we can get upstream much sooner. Look at your
changelog for the change above, for instance: it has no relevance in the
context of this series. What do I put in its place? Bug reports about
my experimental tree? It's just not the right place to try to justify
these changes.

And most of this weirdness stems from the fact that we prematurely added
partial hugepage enablement to begin with. Let's not repeat these mistakes,
and address changes in the proper context where we know they make sense.

I considered stripping out the existing hugepage support as a pre-patch
to avoid leaving these uncertainties in place while we are reworking
things, but it felt like needless churn. But that's where I'm coming
from with this series: let's get in-place conversion landed, get the API
fleshed out, get it working, and then re-assess hugepages with all these
common/intersecting bits out of the way. If we can remove some obstacles
for hugepages as part of that, great, but that is not the main intent
here.

-Mike

> 
> > Also, there's talk now of enabling hugepages even without in-place
> > conversion for hugetlbfs, and that will likely be the same path we
> > follow for THP to remain in alignment. Rather than anticipating what all
> > these changes will mean WRT hugepage implementation/requirements, I
> > think it will be fruitful to remove some of the baggage that will
> > complicate that process/discussion like this patchset attempts.
> > 
> > -Mike
> > 
> > > 
> > > TDX is even easier to hit this warning because it always passes npages as 1.
> > > 
> > > [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com
> > > 
> > >  
> > > > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > > > > 
> > > > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > > > in Sean's sketch patch [1]?
> > > > 
> > > > That's an option too, but SNP can make use of 2MB pages in the
> > > > post-populate callback so I don't want to shut the door on that option
> > > > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > > > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > > > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > > > like TDX (at least, not one that would help much for guest boot times)
> > > I see.
> > > 
> > > So, what about below change?
> > > 
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >                 }
> > > 
> > >                 folio_unlock(folio);
> > > -               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > > -                       (npages - i) < (1 << max_order));
> > > 
> > >                 ret = -EINVAL;
> > > -               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> > > +               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
> > > +                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> > >                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE,
> > >                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> > >                         if (!max_order)
> > > 
> > > 
> > > 
> > > > 
> > > > > 
> > > > > Then the WARN_ON() in kvm_gmem_populate() can be removed, which would be easily
> > > > > triggered by TDX when max_order > 0 && npages == 1:
> > > > > 
> > > > >       WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > > > >               (npages - i) < (1 << max_order));
> > > > > 
> > > > > 
> > > > > [1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > > > > 
> > > > > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> > > > > >  		       kvm_gmem_populate_cb post_populate, void *opaque)
> > > > > >  {
> > > > > >  	struct kvm_memory_slot *slot;
> > > > > > -	void __user *p;
> > > > > > -
> > > > > > +	struct page **src_pages;
> > > > > >  	int ret = 0, max_order;
> > > > > > -	long i;
> > > > > > +	loff_t src_offset = 0;
> > > > > > +	long i, src_npages;
> > > > > >  
> > > > > >  	lockdep_assert_held(&kvm->slots_lock);
> > > > > >  
> > > > > > @@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > > >  	if (!file)
> > > > > >  		return -EFAULT;
> > > > > >  
> > > > > > +	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > > > > +	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
> > > > > > +
> > > > > > +	if (src) {
> > > > > > +		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
> > > > > > +
> > > > > > +		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
> > > > > > +		if (!src_pages)
> > > > > > +			return -ENOMEM;
> > > > > > +
> > > > > > +		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
> > > > > > +		if (ret < 0)
> > > > > > +			return ret;
> > > > > > +
> > > > > > +		if (ret != src_npages)
> > > > > > +			return -ENOMEM;
> > > > > > +
> > > > > > +		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
> > > > > > +	}
> > > > > > +
> > > > > >  	filemap_invalidate_lock(file->f_mapping);
> > > > > >  
> > > > > > -	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > > > >  	for (i = 0; i < npages; i += (1 << max_order)) {
> > > > > >  		struct folio *folio;
> > > > > >  		gfn_t gfn = start_gfn + i;
> > > > > > @@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > > >  			max_order--;
> > > > > >  		}
> > > > > >  
> > > > > > -		p = src ? src + i * PAGE_SIZE : NULL;
> > > > > > -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > > > > +		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
> > > > > > +				    src_offset, max_order, opaque);
> > > > > Why src_offset is not 0 starting from the 2nd page?
> > > > > 
> > > > > >  		if (!ret)
> > > > > >  			folio_mark_uptodate(folio);
> > > > > >  
> > > > > > @@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > > >  
> > > > > >  	filemap_invalidate_unlock(file->f_mapping);
> > > > > >  
> > > > > > +	if (src) {
> > > > > > +		long j;
> > > > > > +
> > > > > > +		for (j = 0; j < src_npages; j++)
> > > > > > +			put_page(src_pages[j]);
> > > > > > +		kfree(src_pages);
> > > > > > +	}
> > > > > > +
> > > > > >  	return ret && !i ? ret : i;
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> > > > > > -- 
> > > > > > 2.25.1
> > > > > > 

