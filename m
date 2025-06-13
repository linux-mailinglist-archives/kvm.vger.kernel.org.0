Return-Path: <kvm+bounces-49473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF231AD944C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:19:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBEF91BC28B9
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A97C22F14C;
	Fri, 13 Jun 2025 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UGzZ9+AJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB41222574;
	Fri, 13 Jun 2025 18:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749838768; cv=fail; b=bCjS4l3YpXgS92dD6FegmtN6LUBwIcnIb8V0Zec6hTE/Whes7yi/d/fizwEeb91D5VIRh8P7WWt/xS+R/V2rhnFLG5qFPbGM6lEDmm1MUSYkHf9wAm3VNuU94i2wrMW7hKzwUW7ahmYRnKombN7OTffoJr9dc/N2iJPaGrab4Xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749838768; c=relaxed/simple;
	bh=1GlvbF+yM23stPpRWVNcC0ZCEJ7VAXXms2WrPxWWCgE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLLUCVX7XzPB0UoyuYiGts3GxzT1XN1UO4h+WUCnAH6y/r8I4D7XN2wwrWQlMQLOSAxVFGlOoJ/mz+QoidnnqXwZ3oudFRs4pjWuaHGasRMGFIj/ML71mWB/rNaeCyfPimOz2nvWfJl2BllSo3RrJqgx+0q0FB5Gi2ysAVCRK/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UGzZ9+AJ; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4jIDHBPanjgpMVcigvEljnNjhEt/mdYRAGzkHx69w/Xok8thT20Qzy9Id1FdvqfY1j0XuJcDUB2k2TU/vOJ+gh01iYQMYfXSniQnZeTQFk7/gwts59rQG62iEdrQTai/bXHqwMXwuwdH0wCAoDTAuip/U9JwOJ1OBEIVdp8AD5efxl7i6Y+65nG6kIX4Lu9HlNlVczzoX09YcQrh6oKdnjObv7feSZlYUkF9gr6o9itU1ZTYt1uzWMtRsLL7M/D5qYd57Av2lkcutZHLKhYYS4CmCVaI9xaxLV7m9i64kNdkR3pnJxYe1tHuQgpyrgzbFdbiaJT9iWHYUZi6GiRQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NunCWsZ8g98NT7HDjOKbzLSxfKfURUs2krrU53k959g=;
 b=Q9mdVjmUKXoQVw7s12tzvVFIHwAFsV9t7Y2d4GQbKVNxtGFe6qK3d6SlgKmgP1QvQUmLvI3wEP+g3Tl2r8+rBaCbt55oxFcD4sEH0t7HZ5mGz9UvtGOV+FzuwUuXjmfYblxNlXoLN8GaIBjHJ6JW0c1OYOc89M4+jGXgMg1V4FxmelsGqzJbe7M0jRVa0BQyTe+VMD0Hmw+WNCZ9xRfJkZwNPsZ7kxEEYHATnhsG2agQJTXCDQDAPYRFVG86lIADWmqYFNKCRu10gLC2XSJJM0iTHDLNKDlrnAkIZGSMlzUHZquYnro8XPRetbt8FzWlK4nQYKmK3dfI7Q0rSwUW1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NunCWsZ8g98NT7HDjOKbzLSxfKfURUs2krrU53k959g=;
 b=UGzZ9+AJ3QebMBepLqAjxBVfGCU+tv7kFWwYbtMSq1UM5mMMoDc8mD4RT4Q3vO8uWg3FkiWVJ/XoYp41OdHonT2Gh55N/SFHnwmDgocyBPPPo5OrOVejEbiSgGLgC3MZgMU7SlyRxs7Xg2OuiFyBTT9sXElsA1g4xKYJctmIaCI=
Received: from BN0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:408:e6::25)
 by PH0PR12MB7863.namprd12.prod.outlook.com (2603:10b6:510:28b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Fri, 13 Jun
 2025 18:19:22 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:408:e6:cafe::6) by BN0PR03CA0020.outlook.office365.com
 (2603:10b6:408:e6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Fri,
 13 Jun 2025 18:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 18:19:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Jun
 2025 13:19:21 -0500
Date: Fri, 13 Jun 2025 13:04:18 -0500
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
Message-ID: <20250613180418.bo4vqveigxsq2ouu@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|PH0PR12MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 68270619-fed4-4921-28bb-08ddaaa6d1ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFZNY2dXcnUyam9XN2pkdjV6MVFoa1VZOWxOZXhxUUxGTHk3RjRWZ2czaFdw?=
 =?utf-8?B?dkh2a0lwNEhaRmN4UnUveW5NKzZxczdvOW0rWEc2YUd4dVRtSklsUzgwNUNP?=
 =?utf-8?B?R2x1VGdxK0J4YmFab0krL3NUMkNZa1VIWUlUUzBoSTlSdFFEakpwemVGdm9M?=
 =?utf-8?B?eTVWUXBORlRpZDJiVGxBTWROdGNLaEtIN1dvYmpXNmt5SE83cHRYQlliZldD?=
 =?utf-8?B?NjhCdnYrV1QxNzEyTmJtTTJyb3NjKzI3RGg1cVl6Z3luR0lzUFQyZ1Arbjhr?=
 =?utf-8?B?YUdPNXpwaUJaNGxsbzRNVyswUkVSSWFBekwwNlNWZjZacEtHSHMzbG16WTha?=
 =?utf-8?B?aUJ5ME4rU1UyWm1UazZOeEoxNG85SzNmNlltcFV0N05oQVQ0UnRLU1FyaEJn?=
 =?utf-8?B?WlZSMjF5ZEwrZ1Njcjl6TW1HU1RRTDNHMHRkVWZqQmZ1YXJGcnVJdG11S0F3?=
 =?utf-8?B?WG9UQW10dElvcWUyZlFpY3I0YVdTbGdTZysvdER2a3R0QkhjeDEzaytoUC9o?=
 =?utf-8?B?VkZ3V2pnMXFzMFU0NmxJYUF4RzZpb2UxMXBFaEhDUG4yUkhHdTZLZ1pFdHRN?=
 =?utf-8?B?T0hMT0JISC9Ca2dDSzVUdjdoOWh3ZHBZSkg0SUFzV2pEUFdsTjJqYnk0aDlL?=
 =?utf-8?B?K0wybWFXUGFrN3YzQXBKbnZHMVJsWHBUblB0RVdrUnJpZlJrZ0hnQlQ3UXps?=
 =?utf-8?B?RzVobXVzK1Y1ZTVYdEJKSm5RV1Q4RHZhUUNIbVo2SkQrNitZRmdXRXdQaDYx?=
 =?utf-8?B?ZjMzUjJMWGR0S3MvSTN4MU9rK3pvVWhnWW1za2ZDR0xWYU1wWWVQcmRBNW5o?=
 =?utf-8?B?Y2JUeHBBSnBad0ZiZmU1SUwzOUlsUTRIZ1dIeVdWcUtJcGl5WVd4ckloMzF1?=
 =?utf-8?B?NU5nQnI2d0xMZ2xlU3dDbXdwalNBdUI0R3lUbUEraEVaeGVESkFHRTZOSlRV?=
 =?utf-8?B?dlRSU2JFYllPYlBpR3N3MVM2UG0yMkpIdXVMTGhnbjI4VDNTaXBCSC9OTUdT?=
 =?utf-8?B?SUxvajgyY3VrbHR4SWp5VXpuL0EyRkErb295M1lRL0QvQ2FlZjk1KzZBbi80?=
 =?utf-8?B?K2loTEozRjBqOVF4elRhZlhWWU1TVU90dlA1NHJGdUhkMEVEM00rYXNhV3Ba?=
 =?utf-8?B?KzVsWFZzcG9FaTJGVTVDb0Zxb0RLSGFuR1ROOTlZQTFHSEZ4Rll5Q1JOMkM4?=
 =?utf-8?B?UEhZeUpWMHNzKzA4NXFFSTU4MDlnUWZkT3hzSG1VaFRnMXRSWjZnOUI2K0sr?=
 =?utf-8?B?N2pkWFB4VjdVOVhONDBDUjlSMmhQM1ZlNnJmTTFWaC96cWQ5ejZmVVlPOVpt?=
 =?utf-8?B?aHpYaEw1NlhPRW9Pc0hiWGVmR0NrZDZrbjRpYWs1NFVCbTRMVUpSaXRqUkJM?=
 =?utf-8?B?OERKZHJLRGFWTnIwOGx1WXpDcktySFBWbmIwckVFRTB0aW8yY21tU3NmU2VX?=
 =?utf-8?B?NFhHYkx4NGlrTUx5d1d3UlVSSk9uUVRicnZxVVZFdmQxdkt1T1N3TjBQRjl1?=
 =?utf-8?B?akYxMUU3R3ZHd3R1MDhWOElYNFJ5Zm90c1dGbXZwMzRWUmJSRE9pMDlldGw2?=
 =?utf-8?B?R3RKaVZ5SzlVUEhMTVJQc3BOOHg2eWIyTGZseEhSbjFqbjNIaTUrelhMN0gz?=
 =?utf-8?B?Z3E4Y1Z4SlY4aGNmR0JURVBmeFNaZjhRK0FSL3h4QmhWQ1U1clROcDBVMC82?=
 =?utf-8?B?Z3hwR3RCN0tUVEtVYmxwV1F4L2M1S2NCU2JpMEhPY1VYR0pSb0I5QllIMFdz?=
 =?utf-8?B?Z0VkeHlDdlYwZzdsQnd2OXZBTTZiVTdEbFoyRnpnYmNQTGVuVjdWNm5WNS9C?=
 =?utf-8?B?VEh0THlqNGN4L2ZCS3RxeFE5cHFvcUFscFNxSHVwOWJDOVhOQTBTVXV0cjcz?=
 =?utf-8?B?ZkYrcWlvZG50aThOQ0dYYy9iN2IxeGxFWGFnRDkrVGpCR3J0WW1BcWkvRXNk?=
 =?utf-8?B?bzQ0QmlwUkNaOEM1MkpWK2RhQnQ3by9MaVByc05ud1NrVW16bE9nZUZSQnVI?=
 =?utf-8?B?NStwZ3o2bmQzMHpNWVg5OXo5UlptTlQzOGl2U1NOayt3eE5lVldWODhhV1pF?=
 =?utf-8?B?SThjZWNIS0dueWtUdFVjVFR4akNnZGxZUHI5QT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 18:19:21.5065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68270619-fed4-4921-28bb-08ddaaa6d1ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7863

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

Since those requirements are already satisfied with kvm_gmem_populate(),
then maybe this issue is more with the fact that tdh_mem_page_add() is
making a separate call to kvm_gmem_get_pfn() even though the callback
has been handed a stable PFN that's protected with the filemap
invalidate lock.

Maybe some variant of kvm_tdp_map_page()/kvm_mmu_do_page_fault() that
can be handed the PFN and related fields up-front rather than grabbing
them later would be a more direct way to solve this? That would give us
more flexibility on the approaches I mentioned in my other response for
how to protect shareability state.

This also seems more correct in the sense that the current path triggers:

  tdx_gmem_post_populate
    kvm_tdp_mmu_page_fault
      kvm_gmem_get_pfn
        kvm_gmem_prepare_folio

even the kvm_gmem_populate() intentially avoids call kvm_gmem_get_pfn() in
favor of __kvm_gmem_get_pfn() specifically to avoid triggering the preparation
hooks, since kvm_gmem_populate() is a special case of preparation that needs
to be handled seperately/differently from the fault-time hooks.

This probably doesn't affect TDX because TDX doesn't make use of prepare
hooks, but since it's complicating things here it seems like we should address
it directly rather than work around it. Maybe it could even be floated as a
patch directly against kvm/next?

Thanks,

Mike

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

