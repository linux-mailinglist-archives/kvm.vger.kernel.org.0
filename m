Return-Path: <kvm+bounces-52550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8663B06975
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 00:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F292D1C20B3A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 22:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5274A2D0292;
	Tue, 15 Jul 2025 22:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AtBVXktA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EF117BA1;
	Tue, 15 Jul 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752620166; cv=fail; b=SlLL4e1XQi6qZZ1LkuXxo/wrkQxJegiv60twcYFtOX/WjoXiLF8p/QbK8NFAXNM5Do66PqHw+rPjdGE86txebfWxo4dRLEXqcM6+tPkSxUuIGQU2m3SxyfW1+ICMyQLNFmgeEYidBgEvsXKuhuA7DNz5evex/x/q0/rB3+dRd5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752620166; c=relaxed/simple;
	bh=aAVGAgRI7TWP676JBCOhsIv3mKjxRU4SobCYiekkpOs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAYCQCZZ9IPRdRAJByiFxxWF9V5Z9efhzX5+RSUeLRu78GNEOKP2Sw7sVHJ5P95KOS1MwjaZZP0ZjtpH5G5DVLNg2s+8JjsvWw4wkPQOnt17EAZBDTMKZJ4KNG3gEkqGacdXAlgqawMyQY/LjfB+QBWuCb39EeC7YNMGnlPhuP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AtBVXktA; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBT8GOEwmNso58uhQshNiFZJ3UVtus6+qu6YbXDNiBOJ1ttc5pVO3TK0eOmaK4sE5/0XTSEOaoZanm2UatSUs5aK1NPh1OGRNHcDTexNOSRbHxOU/OrhJEis3PJsbL6+GlpwKaCBqgA/gY9x6rBRCffF8ddC27YJ9xt/ZaTz/IqCeNoKXZMKlNhAQSzFkzl8fjhxqrW/3aPQx7r52+qxBIlfuz4Cbp5DA1m5pdto1l+NTcD8uaM2k/RAVX0QaJ8NyDW5bxiqdYWb06ReVTv2LW8y0iuH4xyoomnIQwXnTz51fZsbssd42Fcwp4mdUbqNFdD4+LspigsgbifGo8I6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y678HHSQDH8/+Qj3NFpMXyWFC73x5o59TJyKcD2n0w=;
 b=iPG/Gf07BFdLf3XsUXpuHHBtaRrZdY/FhuCeO3g7+kDLPEdAYO26uU089CqAyerrV8Yk2A5+wZu3xtc5+mpnDW+NSdSyfz/LacCa0R69w7m+ufC7ny03hoxscdbPIWkk3HqcI9u1pQAvs7+JhfDmR2n3/Nx73fDVgYsFINdpNOBm92/Fa2QfHb6F1HdpPvVxe1nx3FIK3Auj1GfWdr+3EAb21kaiHAIuIa/a7A/B+FwmVBytmdbxTN4hQOoh9Qx453Pk4Jh4RnaT9tVu+8FAPJpsswGZeakAcCCh6PTKYeiKnUsxPZNc/fZnEgLaa4kmBP54EgPi7ciqQgc9EWJ+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y678HHSQDH8/+Qj3NFpMXyWFC73x5o59TJyKcD2n0w=;
 b=AtBVXktA2PQHFVAQZV9jbOlTl8WaVBT7eFv39Mj+jMLiDvw+8yuzli11y/G7NsXSFAjhpQg2TlNmHRtcKgzcuflI1o0aTRpm4szTAVxcN4lpLZOTZMgyZx1QGFWMTBfQ79/yg9/c1SOuMhS6YN+yyzO9UHo5TBb2qgqia+v+rdc=
Received: from SJ0PR03CA0216.namprd03.prod.outlook.com (2603:10b6:a03:39f::11)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Tue, 15 Jul
 2025 22:56:00 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::7f) by SJ0PR03CA0216.outlook.office365.com
 (2603:10b6:a03:39f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.33 via Frontend Transport; Tue,
 15 Jul 2025 22:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 22:55:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 17:55:58 -0500
Date: Tue, 15 Jul 2025 17:48:25 -0500
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<ackerleytng@google.com>, <ira.weiny@intel.com>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<joro@8bytes.org>, <pratikrajesh.sampat@amd.com>, <liam.merwick@oracle.com>,
	<yan.y.zhao@intel.com>, <aik@amd.com>
Subject: Re: [PATCH RFC v1 3/5] KVM: guest_memfd: Call arch invalidation
 hooks when converting to shared
Message-ID: <20250715224825.gfeo5jdqjlvtn66l@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-4-michael.roth@amd.com>
 <CAGtprH9gtG0s9ZCRJXx_EkRzLnBcZdbjQcOYVP_g9PzKcbkVwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9gtG0s9ZCRJXx_EkRzLnBcZdbjQcOYVP_g9PzKcbkVwA@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: e4d62f4c-3cb1-41ed-35c1-08ddc3f2c408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkM2c2dWeEwwS0tXQ0xXOUNBbHpYeDgxTVRoWHZNclIwclgwaDlYdy9uOEZn?=
 =?utf-8?B?VHI0UGxIU3M2UmY4SHhMeTR0c09abnRtWTFuSGVJelRCaW5TYjVHYUk5VFpL?=
 =?utf-8?B?RENqNUtqQWlsNzVSUlIraEdTUFdwWlRoRkdWWHVYTnZuVkgwYTdqdFhlSGo2?=
 =?utf-8?B?Nkd5ZzdKa29leHZKaHNLbkVHeGZLdXhTMjgrWHFMSDVzN2loS3pNYzVVZkds?=
 =?utf-8?B?M2M2eHBuT0FLSlV1QmFrek1Dc2I5eWUxTDJ0Q044YUdad1BRekZvWktqaGEy?=
 =?utf-8?B?T1FUUGFyMXB6ckpqQWVWaHVtVmZVai90YS9QSWZpWFRBaXFLZUM5bzR1RHJn?=
 =?utf-8?B?YVZxY29WQ1BQK1FTTVBkM1J3amJ4bzRoV0VTUkJiV1ZUSGllNG8rdVJpWkU5?=
 =?utf-8?B?bjdTSXF1ZExqaGUyZy9ZcnlYSGM4ZE5aSEpyMUxLbG1mdUoxM0MxQ2ZEdlNa?=
 =?utf-8?B?MHdla1FUYXV4RmdVZTFPdkNoN3lNcVZXVFdMcCtVeGtUbnhwZUx5aEJrMklH?=
 =?utf-8?B?NWFiczhwRG1LM2JOQXdtQ3RmV3J6ZTFwYUhlaWt1SmdaSFFHMm9OMXVGSm5H?=
 =?utf-8?B?YmppdmZsZS9oWGJ4WTA3SGVWdEFsM3o3SGhpdXNsZVJ5QnkvTTdTZW5ZUUlI?=
 =?utf-8?B?Q2RlSHdOd3pKZis1NHhlNXd3Kytub3RKL01yZHhmby91VzhndnNOTU1LZlAx?=
 =?utf-8?B?ajVBeWp4LzZmanIrQ2s3SmtneHdwREN4c3JKeHVhK0syY0Z2UWpnODlhdVc2?=
 =?utf-8?B?MCtUWDhJbmh5YXZsaGpxK09hRWY4TFl3SWxSWW9BdjU2U01lVFlySFNmalNQ?=
 =?utf-8?B?RE9nVnJzTDQvdXlqcHo0MWpUZk4rNHd4UFppVGJ1Sm95OUNkMzZpKzNNN25q?=
 =?utf-8?B?NjM2TkkrUXBwNlZhb2hPSzVwWXgyNTlBM3JaZWJGVWRhbUxsRlBDWXFEVHdv?=
 =?utf-8?B?Qm8rWGFkUnRMSndJSHlubkd0M3VwYnpETXQySkdBNmE0bmR5U2pSeWhVNWFI?=
 =?utf-8?B?K2RjOUlQNk9wV0k4VHZBTGlwQ1B1c1IvLzYrZlpKWUVoMGJwN1hZNWRTK0NP?=
 =?utf-8?B?dGNVaDFRS1dCQ2s3bmRIZlFKSFFPdmJZMHVSUUZNc0FNRW84WnJXbHY1VzdE?=
 =?utf-8?B?OEtaaDJ4SDhRM2s1c0R0UGdDbG1MZjJKNU00Z1B3YjdKaGMrbDJ4enlCWnRL?=
 =?utf-8?B?bUs0UnFDUndJSjBJUkVHUjRQdVlzanRZRDQrS1JEV3hvNlk1SWhrcU1ZTzhI?=
 =?utf-8?B?bTB2Z1RKTmUyUE9Da016VElaREdIczRMNjhtTEQ4MUcvWG4rTHFRMXY3b1RU?=
 =?utf-8?B?MlZjZ0lPMEpHcllqcGlacHhTVVV6WVdLNG5kb21rbHZ0VnNBSERlQ3g2Y1lO?=
 =?utf-8?B?SU04UU0wNVE0VjlRYmZ1bThTMWlINTZQODhydUhFVVFpdUNobnQwUmhDV0l0?=
 =?utf-8?B?UlZzK1N4cGc1WVBOZ2JYVWJta1k5S0FtUy9pa21WRFFKM0REdTlnVXBmbFlT?=
 =?utf-8?B?ek94UTNNYUxJbzVYQjVHQWdZRVJzQzBMcHV0OE1ldmsySEFJYjAvZUZRQW40?=
 =?utf-8?B?UmdiRTYxR0F4UFNjK0ZsRHdEYUZEb1ZHQStkbVVTeldDUndUc1pmS1phVFlC?=
 =?utf-8?B?d3JybVV3K0J3SmJxWGtmemJQL1gyT3RnNVlVL2V3SlNvZmJXdWloV1ZoTEYx?=
 =?utf-8?B?MUwydWJKRjhuNkJINkQ1a2RuVFJGWHV3ZDVKVjRsWFZQVDFZeWV2eVFUdGpB?=
 =?utf-8?B?N0QyNzhoRk1QbG5jZTVSc01YZUxqWTc2aVdPa0pDdHFuMmJxN0RaaHJicHhZ?=
 =?utf-8?B?d1pCOWs3QVlINzBvZ2poN1F6a041Vlpna2h5bkM2UDBNR3BHUXRHcGo2U3Nl?=
 =?utf-8?B?TWZzUzYrRy8rNjdBdEI5L1ZvWUVFZ2pNbHJuT1lpY2J5UkN2U3owRC9SWkVi?=
 =?utf-8?B?NFBXRFNtcGdEZGR6cFRUQm5VMlZ2WHJQT1BTK1JTUEtpb1Z4aHpLTGJJMUdT?=
 =?utf-8?B?NGJaSFNXUFhrMXlNaTJWZ3ZDclpKR2U3Tk10Z1VyWHhwRlh1SURURCtVaFNO?=
 =?utf-8?Q?yK5S0q?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 22:55:59.3962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d62f4c-3cb1-41ed-35c1-08ddc3f2c408
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

On Tue, Jul 15, 2025 at 06:20:09AM -0700, Vishal Annapurve wrote:
> On Thu, Jun 12, 2025 at 5:56 PM Michael Roth <michael.roth@amd.com> wrote:
> >
> > When guest_memfd is used for both shared/private memory, converting
> > pages to shared may require kvm_arch_gmem_invalidate() to be issued to
> > return the pages to an architecturally-defined "shared" state if the
> > pages were previously allocated and transitioned to a private state via
> > kvm_arch_gmem_prepare().
> >
> > Handle this by issuing the appropriate kvm_arch_gmem_invalidate() calls
> > when converting ranges in the filemap to a shared state.
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  virt/kvm/guest_memfd.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index b77cdccd340e..f27e1f3962bb 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -203,6 +203,28 @@ static int kvm_gmem_shareability_apply(struct inode *inode,
> >         struct maple_tree *mt;
> >
> >         mt = &kvm_gmem_private(inode)->shareability;
> > +
> > +       /*
> > +        * If a folio has been allocated then it was possibly in a private
> > +        * state prior to conversion. Ensure arch invalidations are issued
> > +        * to return the folio to a normal/shared state as defined by the
> > +        * architecture before tracking it as shared in gmem.
> > +        */
> > +       if (m == SHAREABILITY_ALL) {
> > +               pgoff_t idx;
> > +
> > +               for (idx = work->start; idx < work->start + work->nr_pages; idx++) {
> 
> It is redundant to enter this loop for VM variants that don't need
> this loop e.g. for pKVM/TDX. I think KVM can dictate a set of rules
> (based on VM type) that guest_memfd will follow for memory management
> when it's created, e.g. something like:
> 1) needs pfn invalidation
> 2) needs zeroing on shared faults
> 3) needs zeroing on allocation

Makes sense. Maybe internal/reserved GUEST_MEMFD_FLAG_*'s that can be passed
to kvm_gmem_create()?

-Mike

> 
> > +                       struct folio *folio = filemap_lock_folio(inode->i_mapping, idx);
> > +
> > +                       if (!IS_ERR(folio)) {
> > +                               kvm_arch_gmem_invalidate(folio_pfn(folio),
> > +                                                        folio_pfn(folio) + folio_nr_pages(folio));
> > +                               folio_unlock(folio);
> > +                               folio_put(folio);
> > +                       }
> > +               }
> > +       }
> > +
> >         return kvm_gmem_shareability_store(mt, work->start, work->nr_pages, m);
> >  }
> >
> > --
> > 2.25.1
> >

