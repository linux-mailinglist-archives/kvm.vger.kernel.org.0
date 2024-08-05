Return-Path: <kvm+bounces-23243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC73947FC0
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2220B281D72
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E3715D5D8;
	Mon,  5 Aug 2024 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PqOUeEXx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223862AD13;
	Mon,  5 Aug 2024 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722877062; cv=fail; b=INK8XRPQCgMm1cCH2vuSY+aum6tKWxON12TaLqXYUT6CKAsHpvCofkfvnZVoi/RBIJi/peT9sCTrb4QdbNsNEnelmuHGriv9lwsqroKHIpicW2VFyPuQPk5KGAZ7zGqrNjwmDB82NCsWDDj1amp1vTeXedPXrW6mnvCxsvcW068=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722877062; c=relaxed/simple;
	bh=WynzL8XzudUYHPy4b2FltStIl3DhcP0vaAxleDQIXVM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aw3ZbDk7SGRrlVt5oprMhKuog9HoQRCkhCqkfEiNBxUm9knnZgeRRmodgL/ZtbV0lZeKaouWIQp8Hcd9I6TwhYSWpQmWLqsQxP4NRVyyQlaIotdNAoTnQX71h7hhCxKZvPobIPIQ5C8xui6BSyGX+XMbOZ9YTb7lG1YDxRP2VC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PqOUeEXx; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=maU7M6tusnXQ0Egyfqtw/ovqxIuX0dE3EZS+su5IO0q1irejB2WyFhQZpTNpCGAy/rGhqK8qzm56jSb8xPLHA8JHc74Q/5jjKmgkW4x4jitPPT8iB1jtsFjcKx8AdWtcx1bnGY6qCzEqTG/z9izSPqmss6V+TLa9c3iqagnhvpeEwxikzyIXM+pLeKrfVMQBD1Bgevm91WxKOT+JHHV0k5RtKKC5n9fihzWTh8AbWFdQFoQy2JdJC2DvEaDPBTbOWdRtzuyN7Jg0L132D00XGUgunDfgIxZE5Sk2oBR8S/Xhm3oVCo3coQLd/6YC3ANFcYn3t08DkU3GpL01f8ws6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r69G+0d1b0pTv9FM227pqkme37aCbl0Y0+2/BHY8Lrw=;
 b=lJut2VUFZqha4m2GCV1Ime0KanCmpRJfrEGhFvuhkGfUohnYMN2pNLMMoTxBSNX7MQmgqmcnCtCoQGTejr2RijMGfdFuNAK7Rn3WLNbbPxWP8l3noYWX2OC4C9uBGu+Z/qtsQ69bNJHeJqbQUGRXasU7PdOH6pIFEOjzTimRGkbfDfV1y/J7bTidLTQY9mh9Go4G8KcoKhbygvTh6jvubnA2uxW8ZcLMYcPxYxFbkyrx9Nq9KfGqvERCl1BCRnxEQGyV+9eh9RxSzdEN9gG29fnG1ow6zSwUNMBUikOv26jFOGTTYXijk7Hh3R8xciwvbdKlBh6xBjUtjyA7Teav6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r69G+0d1b0pTv9FM227pqkme37aCbl0Y0+2/BHY8Lrw=;
 b=PqOUeEXxf3dqf/CrMjxYj1YaU0zPlI7yd4fP6xnGgo0fcOV0T/dL2PVNLIEcOmBswEhWsJ+E9ti9Zv29AFQ9GaPFRTEQPyToq/QlrRv6ObYpcV9i8v6rSJiFiGolgvKjFMlAEA1+VwLR5OT7846zCwEx4HebNbzQYA6r9Lbd84g=
Received: from SN6PR08CA0014.namprd08.prod.outlook.com (2603:10b6:805:66::27)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Mon, 5 Aug
 2024 16:57:36 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:805:66:cafe::89) by SN6PR08CA0014.outlook.office365.com
 (2603:10b6:805:66::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22 via Frontend
 Transport; Mon, 5 Aug 2024 16:57:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 5 Aug 2024 16:57:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 5 Aug
 2024 11:57:35 -0500
Date: Mon, 5 Aug 2024 11:45:36 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: allow KVM_SEV_GET_ATTESTATION_REPORT for SNP
 guests
Message-ID: <20240805164536.7eg74vpmeofnft2q@amd.com>
References: <20240801235333.357075-1-pbonzini@redhat.com>
 <20240802203608.3sds2wauu37cgebw@amd.com>
 <CABgObfbhB9AaoEONr+zPuG4YBZr2nd-BDA4Sqou-NKe-Y2Ch+Q@mail.gmail.com>
 <20240805153927.fxqyxoritwguquyd@amd.com>
 <CABgObfY0zt3NttX=bb2-1kThEAt_OhEn9pMdGZBSpH+aiibGig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfY0zt3NttX=bb2-1kThEAt_OhEn9pMdGZBSpH+aiibGig@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4a02db-1720-4766-d554-08dcb56fb4fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek55ZWo4N3U3MGFVMk1NUm9uZFJneTczSlJzdGF1SjNsUzluNXpLSm1oVXlT?=
 =?utf-8?B?U2Rway9acldVdmVZblc5U3F4NEVieGgweWEzaWkrL2JVVmhzWk9EV2Y4QXQ1?=
 =?utf-8?B?WjdHbUY0WHVZR2gxa0VzVHlGcG43UTRFQUdPSXJxMm1jZDZVbVgrQWYxcTNN?=
 =?utf-8?B?bnk5and0Y0hxTVNpa2h6Q2tFTWxJZVpRcGg2eHRVdXlyamlXRGNwMEhITVVy?=
 =?utf-8?B?UE43MEtFeWNhcUVEN011UWdMcGppOWVYeit5TWw2Q05KUmYyU08yZWIyaEY5?=
 =?utf-8?B?Y1lBd0xDNzY1MTJadFN4M3V0c3M5UlVDbzlkeThmNmw3K1dzeVQ5SU1rZUlV?=
 =?utf-8?B?M25JQTY4Q1AxbXFLbmZGei9QN2JWdjI5ZXRwWUJvLzNZMFlJOGdVeGNsdU1i?=
 =?utf-8?B?S3lDMkEvZWpUbzI0eGhRTENOM2M2UWxyMExLZy9QTll2YTR0bjRJOWFjRUlF?=
 =?utf-8?B?b1ZFcU5jZmJFdVdwWDVUaUtLbGdFQ3drME12R0lsQTFCWnNONGlNekk3anR0?=
 =?utf-8?B?Sk1mVVBZVTJkTXZrcGNlMGhZT0k2QmhWcEp0Y2o3dzhCVWlITUVDdWgxTEpL?=
 =?utf-8?B?NWVubktRbzF3clc2UTdoeDRvMGI2b2g3c3R2Z0tLUmpJUnhveWxJTjV1a1Yv?=
 =?utf-8?B?SXhMOXVCdEhZalVmS2tibXBlYlpwZ0JObU95ZWh5dituSTAzSGppa0tBd0dW?=
 =?utf-8?B?d3BNNnVhdW56c25NTVN2ZWJPbE83cmdpUldVUzhXTTJuMWw5QVV2OTU5ejVM?=
 =?utf-8?B?WWRwWGJrVW5WV0tDbEFWTU9POEs0Z1JnL2FES2Jxa0ZXemp2Y0VZc3JwZnlh?=
 =?utf-8?B?SUdXekRCZ0ZLMmVxYjNFTjM4MUJkOUxNOVBMN1hFSXBlNGFnTmN4d1FIUEY5?=
 =?utf-8?B?bjRsKzhYL2F6YUFmTXE5UEE5VUd6QzVmc3RQRHJlZjl4UFFiMnFGRUp3WXZV?=
 =?utf-8?B?Wi9XSmN1MGR4OUpuVElLSDJuaFFFMm5JaG8wM0lCa0xjRTF4TWxzNEkyL1BF?=
 =?utf-8?B?djFvR05LbWpXRXQyT1IrMkdQWHZQQ21FY0ZrVlFlemZzMld3TWU4RjBacksx?=
 =?utf-8?B?dWN4QUgrS0o1dGpBWjgvSERQcU1sRWt1MmRiTTRVSExkNHQvbUlLaVU5R0x3?=
 =?utf-8?B?aXA5WFpNN2FRRDRiVHNPV2JPeTBlalEzYnV2UEorUWp5N3pmL01Yd2k5eHFp?=
 =?utf-8?B?bzRscUpIbkdRSVNCVWxtVVRHandnYzBxUi9yUStCa2ZKUklKUE55dzFFSHZm?=
 =?utf-8?B?TDBlN3RZZEU0M2EwTDRtS0VsaE5SbFo0cVVYaWtxTHJWQzgwZ0xTaVRnYmFX?=
 =?utf-8?B?aE1odnRVZEUxN0dkWkxJS2tCMjNIRDlySk1LSTVHb2E2U251NzFWaGxya2I4?=
 =?utf-8?B?bUtqTTc1a0RWNUgwcVZlcU9NdXY2M1V0OWlQaGNieFk2Vi81NXIzckhVdElu?=
 =?utf-8?B?aXlQR3ZZQjJYY1JpZHFuSDBZRkUyTG9zc0FZS1VJWStyaXNUUTdVTXdEODZP?=
 =?utf-8?B?NnBBWkhZUlJXZVZRVlEzLytNV040eHJSdjkwOXJYMmI1R3pTMUN0VzNYRkpL?=
 =?utf-8?B?MStZZTlYNEJqM2JuK1NtdTExTFYrZ3NhdjZtbFh4bThBanNFZkNVa096VkFo?=
 =?utf-8?B?UmgzR3N4L0h2NlF1azE3ZkcwNzBwSGdDbHFPMnVVQ2REazlDNGpib3UzYWxI?=
 =?utf-8?B?UFR1bFVvdHJVZys2OVF5YzVnNGRWdThWZlZ3NjIxaGsxLzJYVEwyamV6a2xB?=
 =?utf-8?B?VmpFM0RzVVNTUU9SUC9TSGcrMzNsQnQ1eXIwVWJEbFBBYWRmTU1LbUZkNHJz?=
 =?utf-8?B?bGpLbTYvNUZWdkJRTEdHVVMwZTBwdkpHejZneXQwdWRrS2FybmJmQ3pXNDht?=
 =?utf-8?B?emluQXh1TmJyUUh6NnhRZlY1dnpOMytxUi8vVmNqQlYrUk1lZ2V5NXJhc3cw?=
 =?utf-8?Q?T22yo+amSETAHnI6dqvHDvKDnqIz61dn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 16:57:36.1296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4a02db-1720-4766-d554-08dcb56fb4fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733

On Mon, Aug 05, 2024 at 06:15:51PM +0200, Paolo Bonzini wrote:
> On Mon, Aug 5, 2024 at 5:39 PM Michael Roth <michael.roth@amd.com> wrote:
> > > (And is there any user of query-sev-attestation-report for
> > > non-SNP?)
> >
> > No, this would have always returned error, either via KVM, or via
> > firmware failure.
> 
> I mean for *non-SNP*. If no one ever used it, we can deprecate the command.

This would have been the main architectured way to fetch an attestation
report from firmware for non-SNP cases, so I think it's likely being used
to some degree. Libvirt itself does not seem to use it directly, however
(opting for the less verbose query-sev-launch-measure), but it seems likely
there would be SEV deployments that do. libvirt might find other bits like
policy/major/minor/etc. to be redundant since it also controls the guest
config, but maybe 3rd party tools prefer to known those values as provided
by firmware so they can ensure they match expected values.

-Mike

> 
> Paolo
> 

