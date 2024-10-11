Return-Path: <kvm+bounces-28649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC30D99AD4F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 22:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57D001F29724
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 20:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD8A1D0E01;
	Fri, 11 Oct 2024 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RBUnvurC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FEE19E979
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 20:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728676909; cv=fail; b=MUrwvBGKMORN/3J8b1Kg15VYYaWkemiuKHRix/YcRqOS+VGvoFN1/evSNv+ZME++5eyARA+v1bn+CsFIMJhXNOhJEyjXuhG1jqmTxVPaDidRNiN0k1HqIl1pqd3fvOrpW1i8di4DeIoteyMeuPGQaK5xWmrtJfYBAgbZUeIoyJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728676909; c=relaxed/simple;
	bh=dSes5CMy77pSRDDi3dqfzIQjnA5Ol6mN3HYfm5/R2JE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRwjTm5O4CfSdlYMtMRhZ2Tab2mZA9EnHR8PahC3IxDyuIY9Tectd7qwZd9SzRtYdJ2V3u7KjV3+4baUxI/REBdcpKN1Sp0BvQJZsH7KcrsmAPjMCGC10PhAXBUkwLf490NCF/6EoomiaMzacXnM1TTk7GfwePiJIHQTUpnZgMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RBUnvurC; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgWCS7RQ+N292KH/4FHwnjUcGv6KO56aCdWatZbU3pUJdoMZs6jG53nXcdqrSF2LIEr289BPGs4tEXU9928OitEVc9LjpYYcutOfRlaSe0zpmcNbGYUmGWgoI6aH7aILNpePnDz0oVtBl0Er/1mI7uB9EXk41adZou8j2z/IE3kEWtY8s+n56T1m6Ii2UV+5EpNX+n9/oq2Q3KByWuxndwvE7OBp8pl3pX/cZlcBzPtUwtFTDyLaJwlqAaIgWB6KGQh9ozG1JjyUza3GO0z4vLOaXGUpOgZmaOfLCAHzLNsef/DkhWMPSGYREmUP3Wn7ij4JWYnbwuexMYkUP/6HZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkfp3VArSIWiYuBflK4WH4sGzkaqLCMrWaUlkGp6mmc=;
 b=F7JWINyi2WNqkmS5RuQ/de9CBYvC+jHIaq7R9tvgT4NNL4Oc2OcIR2wDC5chHAmi33wE40WpLV+5c8+zd/QCGrwrjbnxY45Ga0Mp3vWffxbibi9sf80ZdTThXRUonz04bcEytyUIltakfOj6VWE4woCcQLLnG9NiDQO/7z2TcYLeVu4hK9Li6DVBvvbGQCrvbVui5ENMM52MPI+ZKQmSwJ4lDFc92svfw7ipJ+hUzRimCyeAafFsAxndmeY1gJ8fXkZ2pvsgxJF+Y801bAW+eqizbktFE7uxTqBc8QNphomWe/xTp4+LoXEFpJtl3byuulsmuVbztqA9rnnUxRUmKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkfp3VArSIWiYuBflK4WH4sGzkaqLCMrWaUlkGp6mmc=;
 b=RBUnvurCiP3KZs7nD5zW67VtiVD++bgHB2AV6nw75ARl+AIG1bzCx98DXxLChJR50N+XCQsFmBC9D5tsK1q1dUIza0jGYv4S7wNKuVueetQnYhIbzC21cnAgqeU3ja4AF4mHm4vzcb5q9nnP/Jo7aWawlFNL6RWEH3Tk1EAOFyw=
Received: from BYAPR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:74::21)
 by DM4PR12MB8476.namprd12.prod.outlook.com (2603:10b6:8:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Fri, 11 Oct
 2024 20:01:41 +0000
Received: from CO1PEPF000066EA.namprd05.prod.outlook.com
 (2603:10b6:a03:74:cafe::d8) by BYAPR05CA0044.outlook.office365.com
 (2603:10b6:a03:74::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.8 via Frontend
 Transport; Fri, 11 Oct 2024 20:01:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066EA.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Fri, 11 Oct 2024 20:01:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Oct
 2024 15:01:39 -0500
Date: Fri, 11 Oct 2024 15:01:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: David Hildenbrand <david@redhat.com>, <linux-coco@lists.linux.dev>, KVM
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
Message-ID: <20241011200119.7kz7ggc2mbnoia36@amd.com>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
 <CAGtprH848Q=RMuOvjvPGPZYhjEmZYAF-Mos2otqKKLv8+TEcMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH848Q=RMuOvjvPGPZYhjEmZYAF-Mos2otqKKLv8+TEcMA@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EA:EE_|DM4PR12MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ab2270-a8c9-47d3-c66f-08dcea2f85d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFl1dlVuYmJ2bDJ4d2tCVnQzd1BsUkd0UnIveUZJSkRaMXBBaXBiV1l6OFZs?=
 =?utf-8?B?eG0wRTkyZnlHTW1GRGMyL21CMUdWQ0l6UXlzUkk1QzJueDM3WWRBNTU2TWtq?=
 =?utf-8?B?a3pqTW45RitTTlA4RzVILzF5NDBjTEZLakJ2NlpweUJFTWN4eDJuc0xrbjNP?=
 =?utf-8?B?L05rTm1pdUc5ZW5SWGUvSWMxNkRhVXRuTFh4ZkFXZjF0b2VWckZCa3lQd2lX?=
 =?utf-8?B?bkR3Vm03N2dXM2MwQWNkRGMyZzdmUUdBZW5lNGRQZUFPSCtKd21RSlJuK0ky?=
 =?utf-8?B?enc2Y05qcDBqb0NvU0FFWjRFb3RIR2U2bkdvb2JzODJIdzNlVFZPb2VOU2pi?=
 =?utf-8?B?VHkvYVBYdEtYNlQ3b3VpMWViajBZNnU0bEVJbm11RkVSczRyVEJGeWIzYWdS?=
 =?utf-8?B?cUxCUlppam55WFlPcmlaUHFLa0ZUMDJFUnA3Z3o5b3ZGVjNVbkM2bTc3cjJW?=
 =?utf-8?B?c2VIdGZ6UTlKNk50aWFlU000dFJUVWJ4UG1TM1hWMHZtQUExYUtUWTVGQ3FR?=
 =?utf-8?B?SWJPQTFOZXpuaVRmRUMvMklSM1NCZnNrTEhWalRVbnZyVEJjM2lBNld4MUFI?=
 =?utf-8?B?aDA3NVYzbHI3OW1MTm5EVXRhMzhpSU9CcEJxWVFHVUVJRkNVMlgyTGZiVlQ5?=
 =?utf-8?B?eWhvUjBkVlQrMjBpallGWEE5ckhPYWZzaUJpYmVmcWpGRm1xdkNaZ2Q5T3hn?=
 =?utf-8?B?SUVFc0xmMmhLN2xpTEtLSHVteHZRMkZxVW1MMFl2M3IwSnBWblMzSEI5OXVl?=
 =?utf-8?B?MFZQWnB6Zng1VEJYQ2JxbGVKVENLRGV5ZVBJT3RVcjhFRVhWL2prZm1zSVU5?=
 =?utf-8?B?aEdnUGJma1ltZUpXNnFXU0ttdWlLaUgxcllHRFV5TEpPMVlPeU5uSjB3YTUx?=
 =?utf-8?B?V3ZSSjJjTm14bEUvUHQ1ZXBpbGcrVmUzL3lNL09PZGNWY0RuUUlxbUJYS2Z2?=
 =?utf-8?B?Y3RLOGgrU01kU0JzMkFzUURWWHliZ0JRS2t3VGxJMjViRHFVSk1LMXV6ZGto?=
 =?utf-8?B?VUVkNmo0NjFUSTJZM0hYK2RLOFh1QkRSUEkxbkFIUjhpaGhNL1NkU0lwU04x?=
 =?utf-8?B?UmJHVXdXR3pmV2dlSjRrUU9lY0Z6Y3ovZDAybVFFTzZzN0FzWDdKQlNkSFo5?=
 =?utf-8?B?eitVVDlrdlU0TjFmcG5HMzc1bFNSMitJc0IyTHEzdVdIekltTWZCNS9WRWJq?=
 =?utf-8?B?OURnNXhDZnpSOWc2dVVwbU8zQnhpeTRVNDhtaGQ2aXI4WkhUQ2twelJvUjZJ?=
 =?utf-8?B?Ym90R092YjZZTjU2ZlUvdk4yQStmSGNUYnVva2ZRenJaRFpWYWxka3lZOFlt?=
 =?utf-8?B?cUwxeFRPL1g2UWVtRGFzemF3Ukk2Q01keEp2SFdtL1BSZnBKSU1OWlRkS05i?=
 =?utf-8?B?VkM3RmRmSDV0Z0dkNG1mWlA1NGJOaGlUa1IvaGtmZkpaczduSGxwVU9qNGxZ?=
 =?utf-8?B?aHczSTJCR1pDcDFQWCs5N0hLYythSXRUL0dNLzJNY1FOSUR6dlNNN3BQbE5k?=
 =?utf-8?B?UVNIaWZDRXh6Q2srZHNqbU9Bdi9VZFBGRXl5WnZKZENmZkFpZ00rZG5OUFpD?=
 =?utf-8?B?ZmdJaE9IK2YxSjJBK2h2dm4xU0F2cGl6cEZkdURmM0ZQMVYyRitjQWkyMnZa?=
 =?utf-8?B?NEZuQk9nbWl4ajlzNk56ZWVaclNBMFVaV2ZqZS9tVG83SU4yT2Q2NXE1Tmo4?=
 =?utf-8?B?N01nY2dpb0RSSWhSVFlBdmhpT09na2NCajBFdFl3czdiYy95dldya1cxQngv?=
 =?utf-8?B?YjRoNUpCcTYvK0MrRVJoZTR0ODB2a3JUWjVtU2N1SzBzK1lSMUp1V3N5UmJp?=
 =?utf-8?B?eVdIdlZzUERKME9VUEhPL1ljZFZzalc2NE8yTWcyaUhFdU1vemoxTTIxcVl1?=
 =?utf-8?B?aXpvYndKbyt4bVdyUDFnUnJZbXA3RVFWVzF2M3l4cmw3akE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 20:01:40.7216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ab2270-a8c9-47d3-c66f-08dcea2f85d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8476

On Thu, Oct 10, 2024 at 07:50:12PM +0530, Vishal Annapurve wrote:
> On Thu, Oct 10, 2024 at 7:11 PM David Hildenbrand <david@redhat.com> wrote:
> >
> > Ahoihoi,
> >
> > while talking to a bunch of folks at LPC about guest_memfd, it was
> > raised that there isn't really a place for people to discuss the
> > development of guest_memfd on a regular basis.
> >
> > There is a KVM upstream call, but guest_memfd is on its way of not being
> > guest_memfd specific ("library") and there is the bi-weekly MM alignment
> > call, but we're not going to hijack that meeting completely + a lot of
> > guest_memfd stuff doesn't need all the MM experts ;)
> >
> > So my proposal would be to have a bi-weekly meeting, to discuss ongoing
> > development of guest_memfd, in particular:
> >
> > (1) Organize development: (do we need 3 different implementation
> >      of mmap() support ? ;) )
> > (2) Discuss current progress and challenges
> > (3) Cover future ideas and directions
> > (4) Whatever else makes sense
> >
> > Topic-wise it's relatively clear: guest_memfd extensions were one of the
> > hot topics at LPC ;)
> >
> > I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
> > starting Thursday next week (2024-10-17).
> 
> Thanks for starting this discussion! A dedicated forum for covering
> guest memfd specific topics sounds great. Suggested time slot works
> for me.

+1

Thanks David!

-Mike

> 
> Regards,
> Vishal
> 
> >
> > We would be using Google Meet.
> >
> >
> > Thoughts?
> >
> > --
> > Cheers,
> >
> > David / dhildenb
> >
> >
> 

