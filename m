Return-Path: <kvm+bounces-21672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A06E0931E00
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1531F21AFA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DFC1C01;
	Tue, 16 Jul 2024 00:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r6Ujbiza"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8AD1860;
	Tue, 16 Jul 2024 00:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088859; cv=fail; b=NAMGxCSkiX0NEo+BHAiViy1IFgd6dNvocbRXNEjYQHF3oRyZq/1D7TCRGVY9eeZ5P3HiLETmYbQi379HindiK9Zw/eiT8HMK3rfYSugkHx/OhtVgVNYszT+WD61sT1Auw3LJ9wVOI+OcDBxGpPkpO+a0F5TFrvTDXKgIZ09h8uY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088859; c=relaxed/simple;
	bh=sqsV3UykgLuWKs2Q7yVuQSMLsraO5Xlw445ZIKF+c8M=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GaG3hIJLAb22UDzZ96Sfu75LC7tWUx454fa2ZVYPdKjZIt7kd1zPPrJu1khrFTMGCH8XSpeDMIP7w3y0IsAUdi84r8KSSN6JHUQhM57Ns3gnqj2BpjfgcJgV8yzxUspoIn1SXE2BK8SGz0u5y+0UNGA0HuC7429pWoUDMBseXyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r6Ujbiza; arc=fail smtp.client-ip=40.107.102.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJuNbrzJSAzI+7ppBaX8k7CkOBZi8tglpdeTr+r4qfpmHBgIxcqvJcaP6LsXVClGoH0RcTk1Blw+ZxFC7/RU9RfK/XuRzGQska/11T1bP1gE5HBOvnrhAW8tsnXq1Zc8A7rXPh32oH/hDPU5ElTnx+8HtA31X2j1AkJuRXaO5FgmYzb7atesZWZZWqX8lrmE1CR+oEx8OhQKF3oyjxrmRaP22Ojvklq7Wdt2LIpkMeN2gBlRHnM6eUEKbPDWfmqULaZzK++S0XxLh6kUU0NoD9DtadBzdxyojpSkaE0L55FTBYJBuhM/V0izLBuHihFNKaZovvT20e5dIhPOU9x9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkkZUbtendKgp/O2XQwMjz8x236OIQ0Vcy2gwJnADtk=;
 b=FJJcG9i9JSCcgMAMlihF1Vq5a/EnhpqNia9qASu/iJMmgqi5RwJOcQXE0HBOqI1MvhzlT6naxWb44Z0U2/Ool5Y9lrMYpWg1riecYqLTRCBFkQonny5uhIrdC8p3sgQhkTcdTpI1kAv3wPgdQCVap687GEEvWTKLpilWegTscT9nVPIQ+tCj3ouMqQjBq0cXw6yrGYSvXc49n13vV5cKaKIjs1EktjVCiTzOal/jdd0RR/ZlrEQgRi8JNKmYaXYRPsrFX0JhvVLZiH2NHKVphRHX9QldA86iVTEk95BJsRE1atc6MgRa9dV15zwcrpTSmJly1pcos0cWJyubWsJuzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkkZUbtendKgp/O2XQwMjz8x236OIQ0Vcy2gwJnADtk=;
 b=r6Ujbiza1XRsDMORv6KdOGnBKSWug47yFdcyqW5iuiXKiiyKZkgn2Z4rbn/oBmfIwkrinEErvdCqmzabfIeqFcorZClL/FRb9LqmTiK5By54VA0oRnJV7MDGhyTA4g3RV8x9Ybh1Y/PFYMHolC7lCluDp8KbUWrM5cF/XTaXSK4=
Received: from BLAP220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::20)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 00:14:13 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:208:32c:cafe::96) by BLAP220CA0015.outlook.office365.com
 (2603:10b6:208:32c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28 via Frontend
 Transport; Tue, 16 Jul 2024 00:14:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Tue, 16 Jul 2024 00:14:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 19:14:12 -0500
Date: Mon, 15 Jul 2024 17:36:41 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 03/12] KVM: guest_memfd: do not go through struct page
Message-ID: <n6g2mckhisvxr2k3zipubrl7h4emvfy3ogg7iv3rwwbbgir5dj@icmne2ac3aqs>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-4-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-4-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 653b3a90-3910-44a9-3f8f-08dca52c38e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m4HqL9uAQaoTu6YYNi7TncqP/i5sWN8HnhJPZn1rl9/eaMgn+YXcDX4Ipn9p?=
 =?us-ascii?Q?LSIZjHNS06eB2/750TPwKfNk9Ja+YpyiE15lmzj34+emXT56a5m6ujPqQemr?=
 =?us-ascii?Q?cZIvXl4b7pS0LOOxdPOEnjetOvHupWIHfz9TM7R0BIqx8Rfu/bAWEXIAk2xK?=
 =?us-ascii?Q?beHIJLWNfx2Wlq52Tvh/ywNt8lATnISqU1Slijq0VvXGminJluJ0Ap51mJZI?=
 =?us-ascii?Q?AU6ne3uRFNafGjL4KGuFdFEdh/aJShIx0myy/Djg77wEu0Y/bALhuPLI6e1M?=
 =?us-ascii?Q?tOyMLBw3UV4xos1DpLJ5cmVvT2PMuzeDwMwezaoopX76xD4S51cGQEyXxeNC?=
 =?us-ascii?Q?MxaOQsQ7uoFhsH7CMxqUrvjF91pPbB3ROWpF8/B69cmQtsVT6z29emMIQ4pk?=
 =?us-ascii?Q?15K7iX5OWq+AyuFXsvtUFzWYLremYSMeX+e2yCBbmk03I7AiNo4WChw+g5pY?=
 =?us-ascii?Q?lAlyfj3qneKywQ64EAFcoPSZG1rewdNsfII4pzFKXh6/u63kd7ZmkrPcOLMg?=
 =?us-ascii?Q?/8/YINRhrFpIbKht6tg2pNFXzYrnneFRd/x8BAiuWH39DE5qbmpZ99+k+YU5?=
 =?us-ascii?Q?XLwCClxu31f/2hkEwGIY5boVv0/PQdsDYoUlo/pORYAZkudeKgGpIyw5U156?=
 =?us-ascii?Q?KgRvHmXJqI21O3kItCOBjuQRQtzQgqKW7X4y0ri0XYmawfAPhAudb21OCZL2?=
 =?us-ascii?Q?/WW35lQ5FyJNrK4fOGd8Lxo7gvdl/TnfP4ofaKZYZuS/IMeejxEWQ5Pr6UVW?=
 =?us-ascii?Q?HNoQ2E95hGBr4moVhXcW0yhZ1Oxj/9YYrEnhgLZ23gBlcBnJ+EZi/jPnuG3r?=
 =?us-ascii?Q?RYCOQOp1o+FSwV1l/m5/c1BMEUlqvP62ej8eOHKqhZ+B8ra/9PfN8kxGBIDO?=
 =?us-ascii?Q?oup0z0j7JvdKFRKGzjRh5MwAz9Xm5RH/XMdEM4i/QiE+LXvnXATs+6SqfAHX?=
 =?us-ascii?Q?OMu9xi9N4gqYnX4PGVcML8rmSSZrrcou5Xe3THz0ZyNt70aBJAfEnkFavJyV?=
 =?us-ascii?Q?PT+9F2i9PjNJPmBmxohczUTlegqEYMCudGaxg0spteU3A/h+K6XJ9gcpHTu6?=
 =?us-ascii?Q?R+UWjmuB4Ptu0Ht9uwH5GCFKiFmlhzdR4SacnwJ5cYSWBJhaHlbnL1wXJk0p?=
 =?us-ascii?Q?9+AaYD6fCMbHcE+W9RD5jn+xdFNMyjRWl+p0EgA2n5dPR2/xHL+KjF4vjmUk?=
 =?us-ascii?Q?kEfa90X25yMjj4EZrkQgLMmRjRVG0aX1GC34mvOlnBno14A5aW0LNPY+aQPA?=
 =?us-ascii?Q?+dVjHk43ms8WoSwzkkDnMcK3ncDDqPgzY+Bln5igQS9zZdpVQJ8pKAKN6LAu?=
 =?us-ascii?Q?NvDXpFJevILAJHHOoIwPZlf+5GdxS+fhftHDS/+XAqKpDPvaWur61YLqz1mj?=
 =?us-ascii?Q?bRS0f5l9RZGhEpFY20IgqxdvhXy97LbwNOmY4iJdvndN/3vNZhtgOOTX8x8f?=
 =?us-ascii?Q?3Bl0g0PB4bzu/KMxR7wBypjBYcJgowAO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 00:14:12.9988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 653b3a90-3910-44a9-3f8f-08dca52c38e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607

On Thu, Jul 11, 2024 at 06:27:46PM -0400, Paolo Bonzini wrote:
> We have a perfectly usable folio, use it to retrieve the pfn and order.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

