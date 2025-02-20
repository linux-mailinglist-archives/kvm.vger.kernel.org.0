Return-Path: <kvm+bounces-38624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B57C9A3CE76
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C5E3B5AC1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0A814A098;
	Thu, 20 Feb 2025 01:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="23d8mdim"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C883129406;
	Thu, 20 Feb 2025 01:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740013974; cv=fail; b=WDPe9BbAC22FEomotzbEw3hOMYP/xx7cPGod3twnhMUIr+h3oeAMLbFCPG7gosPrR/8WChnIPCkhg0GiYnMKJDM9RcwlvVp+yMQvn5GM/XISv6q5czA5zcO1HGnWP3llrNAPW4PObLnQyXVB6n5mvpNQPMiWzAvaexOFFX1vHJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740013974; c=relaxed/simple;
	bh=4IKaRZZYlo92hpymsoEIYtQtQOWOnVzdxOlV96wNDuo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1pY4FcEL1Hpkz9A6G9Kn/ipKbBfz+VNkCAEwbFMESLPcWIcl4V7DXI7zGT56z2MO3bd+p3Rw+JmqlCSlJkldYGwx9PPE+ppngLZXHTTLr5VkZkooechciUXa/ENKBlou7t1oAePulT5TqCAJ0ZVFY5e+V2lEmA2FWJ0Ol4hFlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=23d8mdim; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y69Y9ceTDZIw1vlgoXAQuyF3g413syTn3+5pn8lHDiq9zd0DxJH2kSHgUJIx53lW2+AJYm1Ri8ZcEyazLZ1Zwt++dEmV4jb2qbKNe2RjwNuhhh13RHxTa0CrNJtVmSMQ9aiO/7UgdpIhEFMZwG51bypXUe2ejcrqkvp/GgIE+so3kvHO0nySm+TbxtSPpZBOWtwco9oFaqa2okKiwOPWQ4nhozk3VBstTi3AzI1Q9b1vmM2BKoLK/UxV0oVmzTwSl28s5+FpQKbasU4W+gYhIYFLXS/vZ31GS2KUi4H1Zxng+Q1AHfmfVy02oE5liJJYoNYut1OL5V7915nkzfhHYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjyUhgaXJe5srU1oJ64DWC9ymxxyDTuqu9jkMdpx0Ow=;
 b=jsZ2Q6smOo0tp/Es+TkNJkGLLzmWEv5hKcILjD9TajJcOsOpGhohXb/V8ej2sdWj3QFphys9RYaNt7+PCN8dTVht2S06jbJCmSzMFddjOqNVXnWAOJynezjY57e1/DNY34gIVZjQProrLHHB9vXFqUzEZpM1B2r3iLgzg4lZVR1gbOOhDg+t6mXuogSjFluzB184zewjQvL/8juNiQ7hr/aSx8k80o5XO+sIvSFyCn6Rm5ifS0JoC5sGq+Nma7KXB10nY92Z0p+fqSe+yHyzh7e05Us0nIG2Qb2DKFleV4p9LWR4ygO9jASNcP3Tj/OHuEfck0hJ4zE3YqQHJF9NGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjyUhgaXJe5srU1oJ64DWC9ymxxyDTuqu9jkMdpx0Ow=;
 b=23d8mdimANkRui61a6tygWGQkUtLuANrbPFC03LXTTqgNB6vKlDkUIGnC1u5FqoRnhrme+1aISimvWowDeiadHGXC4RYVRzsbw+KeqfmEZ3U25wT9yfPMuhL08eEsZRUNYYKAr4ylqz9g4d2XHHVUHGsc0RJgPdQi0Y7qRkGisg=
Received: from BN0PR04CA0061.namprd04.prod.outlook.com (2603:10b6:408:ea::6)
 by MW6PR12MB7070.namprd12.prod.outlook.com (2603:10b6:303:238::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 01:12:49 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:408:ea:cafe::9c) by BN0PR04CA0061.outlook.office365.com
 (2603:10b6:408:ea::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.20 via Frontend Transport; Thu,
 20 Feb 2025 01:12:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Thu, 20 Feb 2025 01:12:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 19:12:48 -0600
Date: Wed, 19 Feb 2025 19:12:11 -0600
From: Michael Roth <michael.roth@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <vbabka@suse.cz>, <amit.shah@amd.com>,
	<pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 1/5] KVM: gmem: Don't rely on __kvm_gmem_get_pfn() for
 preparedness
Message-ID: <20250220011211.tjgo66egqxwqjzdk@amd.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <20241212063635.712877-2-michael.roth@amd.com>
 <80a5a52d-68d9-b4d3-e243-7720a097a3a1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <80a5a52d-68d9-b4d3-e243-7720a097a3a1@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|MW6PR12MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: c974f94f-ff7c-4f17-4963-08dd514bb111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Gm1xekcbqWbHTMrowefczBN5TLd1kGkXLlmrN8lnL7yDuIfQ4SkkHor+zJt?=
 =?us-ascii?Q?8xc/CIJhtBESjjQUUdpB3Kq8tIhrY4nn/4zUDktt1rK9fLIluXZUq18uYwEy?=
 =?us-ascii?Q?KE91t2U58j+sdNUv0pZX2PDEvhsfmj/bCW9Qgj+YqHOMfEsBKTNJQYViShSq?=
 =?us-ascii?Q?TtKYQnWCWonOLV/5FTN8R49hVNSurE61I9DdfvrH/73FgqvqORhFl2/yZjNJ?=
 =?us-ascii?Q?4X3gsrWEF0j5eStKixJFu+/9rWGi9D4/RMXkdqC1RA4qlzHG89iZOp0knJNr?=
 =?us-ascii?Q?mJR8+ivB2hv/FHVZZwAFH96ApBlOiplxsu9RLeqIx9sPvWdE3Uw0bAzwYKgW?=
 =?us-ascii?Q?DWtcTEizTpdjgpmHXG4v4l/SAhABbfvgfm8EmkOuCBStb/9BSG693enjGgtD?=
 =?us-ascii?Q?NUVccc+G3zeTlZo7V00krpeZTpVSgy3AetANXfDdPqidAY8za6/DFsuDNlNT?=
 =?us-ascii?Q?tZA3VeZNar436eLC8MqnOup0w6DtTebXe0MtHVQ73HenIlKwY/hD+6pqwys4?=
 =?us-ascii?Q?Sl/7QKhED1fljIL5UJdFXdHl10a05HQXTQlKQMZ8qwuqg92VA06IIwu5vmqm?=
 =?us-ascii?Q?yJdvcUHgrDFPZ4z1jHdZ22pzthMQt1PsdBtLzK/n+hWa7pk9pI1EbcXNMfHO?=
 =?us-ascii?Q?6pEVLDSD1tMjfKpJBc/3ct0Gh2fwcPFtCcR6arHtslCYlfZbzhQwlPZjblm0?=
 =?us-ascii?Q?6GsY+O7pN4QySPggmFTY7XdUqnC+ZEtjIVd2QgN4NqroV2WV22IrFrwzLRfh?=
 =?us-ascii?Q?z2z7BwY+awaUO2eEQvCbBwCNSWWoIohtplq4KHEXmJ+sYbvn0xMuAdv4jNaG?=
 =?us-ascii?Q?KTKvgsVkJWGW96ByR+/L1c99BLt8Ov4bLlIo88/o3H6BLK3GKJRz2KuS2q+E?=
 =?us-ascii?Q?X+kTv+KM1Se2wMAB4VLszR9P67fa7tCKWrKDn7wNrA0AEYZiwumpsDWgQ6uF?=
 =?us-ascii?Q?zDWyL5yV8gGA0/iAFbSrBbuqnp6a5vTlhpQb27eszUpcbBmNecO9caRiBt7Y?=
 =?us-ascii?Q?pYKSaAC5OKGUXL9T+B05JoefPVnj4z1LzM3SyRjSmPO6gCWTfVYVr6pRdy0/?=
 =?us-ascii?Q?iW0P6/o48ut34eVPBO0rlmbr7D21PX/hfoZygtOHJLYzPbwi998Osv+rK+2E?=
 =?us-ascii?Q?QhYpfgNo8m0kqgIhABsM8ZWYPhOTZdV/G5/45mqo0UEUr+nq3cU5kbG0IlN9?=
 =?us-ascii?Q?My830a6AbZuIHTred3P+T8gGpcFJ2ytA5ni7tt2KE2r2QF3bsT3GUPfXMs5S?=
 =?us-ascii?Q?W7wLSeoygtD2ClrXJwnZJTixNnl4HNloumW82iv6LAxnzD2PreJak5ICvru9?=
 =?us-ascii?Q?tnMCKFYnPF/vOZCD0fjm/dCVOgN81nCtbrBXkt60TKdcykkeL1Fn1ia0vI5w?=
 =?us-ascii?Q?wyN3Wqia7iomP5PmbKNQ0kVWBW4Yq9HxY4wkOGWgoIKVGbeX4JD8MUQE1yxx?=
 =?us-ascii?Q?A6vFi/X8TbiKO3TaMtl1kjBeC6lpYyH9qjd9dA2Olm97qmZCEdPOOszQSYUo?=
 =?us-ascii?Q?RKnWdEOGNXIEZ9w=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 01:12:49.1106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c974f94f-ff7c-4f17-4963-08dd514bb111
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7070

On Wed, Jan 22, 2025 at 08:39:37AM -0600, Tom Lendacky wrote:
> On 12/12/24 00:36, Michael Roth wrote:
> > Currently __kvm_gmem_get_pfn() sets 'is_prepared' so callers can skip
> > calling kvm_gmem_prepare_folio(). However, subsequent patches will
> > introduce some locking constraints around setting/checking preparedness
> > that will require filemap_invalidate_lock*() to be held while checking
> > for preparedness. This locking could theoretically be done inside
> > __kvm_gmem_get_pfn(), or by requiring that filemap_invalidate_lock*() is
> > held while calling __kvm_gmem_get_pfn(), but that places unnecessary
> > constraints around when __kvm_gmem_get_pfn() can be called, whereas
> > callers could just as easily call kvm_gmem_is_prepared() directly.
> > 
> > So, in preparation for these locking changes, drop the 'is_prepared'
> > argument, and leave it up to callers to handle checking preparedness
> > where needed and with the proper locking constraints.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  virt/kvm/guest_memfd.c | 13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index b69af3580bef..aa0038ddf4a4 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -773,7 +773,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
> >  static struct folio *__kvm_gmem_get_pfn(struct file *file,
> >  					struct kvm_memory_slot *slot,
> >  					pgoff_t index, kvm_pfn_t *pfn,
> > -					bool *is_prepared, int *max_order)
> > +					int *max_order)
> >  {
> >  	struct kvm_gmem *gmem = file->private_data;
> >  	struct folio *folio;
> > @@ -803,7 +803,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
> >  	if (max_order)
> >  		*max_order = 0;
> >  
> > -	*is_prepared = kvm_gmem_is_prepared(file, index, folio);
> >  	return folio;
> >  }
> >  
> > @@ -814,19 +813,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> >  	struct file *file = kvm_gmem_get_file(slot);
> >  	struct folio *folio;
> > -	bool is_prepared = false;
> >  	int r = 0;
> >  
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> >  	if (IS_ERR(folio)) {
> >  		r = PTR_ERR(folio);
> >  		goto out;
> >  	}
> >  
> > -	if (!is_prepared)
> > +	if (kvm_gmem_is_prepared(file, index, folio))
> 
> Shouldn't this be !kvm_gmem_is_prepared() ?

Yes indeed. It looks like I fixed this up later, but accidentally squashed it
into PATCH #2 rather than here. Will fix for the next spin.

Thanks,

Mike

> 
> Thanks,
> Tom
> 
> >  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio);
> >  
> >  	folio_unlock(folio);
> > @@ -872,7 +870,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  		struct folio *folio;
> >  		gfn_t gfn = start_gfn + i;
> >  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > -		bool is_prepared = false;
> >  		kvm_pfn_t pfn;
> >  
> >  		if (signal_pending(current)) {
> > @@ -880,13 +877,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  			break;
> >  		}
> >  
> > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> >  		if (IS_ERR(folio)) {
> >  			ret = PTR_ERR(folio);
> >  			break;
> >  		}
> >  
> > -		if (is_prepared) {
> > +		if (kvm_gmem_is_prepared(file, index, folio)) {
> >  			folio_unlock(folio);
> >  			folio_put(folio);
> >  			ret = -EEXIST;
> 

