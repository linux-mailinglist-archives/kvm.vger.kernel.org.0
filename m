Return-Path: <kvm+bounces-22531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 873979400E1
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 00:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 008AB1F23065
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 22:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE3618EFDF;
	Mon, 29 Jul 2024 22:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fIWq96TO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B4518E771;
	Mon, 29 Jul 2024 22:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290947; cv=fail; b=H4CSF9E+JF/yJ8WaCMHQw0+P583++svdIyUcW3JTSLNL2QA/TMZW2ixwgbfBe/XQHNxchgWJ3xTRETD4gLFVk5TCKn0usPoLLta9Q0SAUR7M0d72u2pb/7qlyYMmW/AC/9QnoIluHbU7Sm91c1Sc45YwEozZCNQxBy56JZq2fWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290947; c=relaxed/simple;
	bh=BQ9qyiRnR/+zRNwE6fOrEiOWMO1m2rjkNVb0zt9IJ/Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzTPENVHMl6aCHiJSbarkrQmN6KVX1CIYEX1Vg6yCb6L7gMTWRLQ3aqR9Rz6Y3surSzNwBUREDHEIrHpaz5R23xcThFNdi4ygYKTixzqLu0t2MGYXzvH/os/D2E6t588E1QyRulCgVKv1o2+Ld5FR/bXrulWKb4UVrwpmx4gpdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fIWq96TO; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xz9kLGFW5v/FBJI2VzO/KsWvKe230qZou24Nmz0n9HsDo0CtYJ2hjncUXXj5rxnGu3DLekUiVxqOzufBdfStlFrj+jX6GcDOOShpFAl1/Arz+52Tt6Apj1rEBnDfvnBTRSi59PEThKRyy9eaK8VzKIuhC6QyIGCVQei/pvVUc57t66VvVZF0c9M9TUNKNgRuAFbXXwvovux4ZiayHOx6PCV/T0mDaGvGoAqGlraGtr1Rird2wRJ0snTuHwoY1832t0HXISBKeVs9eHrlNccxhYzni4t/PMcUaF8q7jZNJqOsNtlnC0mKvaFjpzeGqs/AU6vpC8fpSZU2ZO0evk8w5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JHPjaVuDPZHFWF1gWZHdw0GWI1G6oDJBP8wKgrHF8s=;
 b=xZU3pubFsaM5hAaFm+pUc6wAgbK51+4woeJYV7SiJuBQtRYf5iZYrQ5L8EuGHJ4vHc5sHt5v8OVw7dgzuSelaoptS02m3taTTKKl70Lz8ptkCJRxMpC53e14DGlh/sn7qirjElORuFOTA57bOP9M/BDvzJ5VWclXQkQ833eqLIRaHtzV6z9ZsBYy2pR8+LbeWS3T1p0aBiLc+bxDki7lxLTEclqxQQiKnhLumK8EI0bWkszxNpOJ/DwX2US3zdcgwkjIX6Stcz7zvoyswrnoA0gGjBg5Mt284YoDQi9ewW4C3ZEynhsgN+FGI8Hwn3XE/PUVI4tTsE33pwsrH7yV4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JHPjaVuDPZHFWF1gWZHdw0GWI1G6oDJBP8wKgrHF8s=;
 b=fIWq96TO8tuqb5fFlogPfC0u7nufcvNVy9BAI+Wf1x82dx/jZ/MyzKS5SLlq/R3a2k5SNbXomIVQ5d8UYlZCl2TZQHhRB3iuJdFRExIF2fXdyAa27JhnbtO42Nu3ZsJ7REJ1qSDVzLfkGpyX7tR0jmxKcQoR2sIF2jFT8LNLewg=
Received: from CH2PR03CA0006.namprd03.prod.outlook.com (2603:10b6:610:59::16)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Mon, 29 Jul
 2024 22:09:01 +0000
Received: from CH2PEPF0000009C.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::3a) by CH2PR03CA0006.outlook.office365.com
 (2603:10b6:610:59::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Mon, 29 Jul 2024 22:09:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009C.mail.protection.outlook.com (10.167.244.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 29 Jul 2024 22:09:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 29 Jul
 2024 17:09:00 -0500
Date: Mon, 29 Jul 2024 16:59:54 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH v2 14/14] KVM: guest_memfd: abstract how prepared folios
 are recorded
Message-ID: <20240729215954.fpnh4wr7jq4doblx@amd.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
 <20240726185157.72821-15-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240726185157.72821-15-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009C:EE_|DM6PR12MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e40382-aaab-44db-4d64-08dcb01b0d58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?plOdc0Evj09e/nDx2OLAU3PTauWTgJZYl+AD3ph+qvLZHiQsU8F6vNhn1JE9?=
 =?us-ascii?Q?3qjGbddlRsTjn0b3LmqUXlU9xjZZvR4vBOdUK4GRfqc0nDiHU1nxjQMwjXs3?=
 =?us-ascii?Q?RvsCq2uKTC1rcE+SL7fKMmYLNBjY4FHXwLu8O2Sd98m27gbL4Mxj9hj8G8FG?=
 =?us-ascii?Q?oYvIR4B4hy4DvpSS0iRDX7xCqbbHK+wU8rwBYUlT6HrH0T9Eqo8elKJHRfWu?=
 =?us-ascii?Q?GG0sVeUh8VuH/Z3pZ98bubFLcVD/AcNxjBiAJfgFVm0zXmWkCack6ATPMnHF?=
 =?us-ascii?Q?npwiVYw8sd107DYmA5cbRTsKLowbEkAKJmTotovxTLqzegOMW6nTkCC0KC7L?=
 =?us-ascii?Q?FTEQhPiIPkn2wCU41YDT/e6EoFi5NTD/KmW05397FlCqjsDczQt1PwWxKuby?=
 =?us-ascii?Q?4wwaa2zyqxd1M1Fr+qHTMgwUKf+qG5DIbu+5vB+BWlfEmFJ9gYRSMlmf2B8A?=
 =?us-ascii?Q?Fm3KSRLPh227CHAYD5MKY/9SPOCVQ+0A7cWlYbYaMCgBd4ERmEt6SEe3m0fE?=
 =?us-ascii?Q?rt284GTw1pjrvvbTmpCoGZuOP1cfTJwGetAnAGpHzWLDDupvN75XnMjwcBJQ?=
 =?us-ascii?Q?h1ue+I9HfDUv+ALxKI7YIHa89LH0YaZ52EiKvOA+kbcmYgIQuX9S2FfUUKRO?=
 =?us-ascii?Q?fFvw7byyAaMLe3I5zsI2FN4QzXmtUHRYkJR41whmTp1rebyKv8EAWDkBUJ2j?=
 =?us-ascii?Q?EeiacQQ3SxWoUEsm+bQDrO7qP8l3FeajGIQFCmXq3Cr81ZbGtCKGebIetLcl?=
 =?us-ascii?Q?R1tHul4T6MrJHzupE3fIQFhT+EkY1jv8WKy2H4L6bHAzNx5fvNDsVSUSnlRm?=
 =?us-ascii?Q?cKYEoXBFZ/JTONRoChz6eP/BckQ3q5UcVvgHvtjs4Pu0s4+R3EmKCGYDAjTM?=
 =?us-ascii?Q?0ZtdMooUtxWBBvxUKZlK505d9Z6cFQ/E6D+hqWRlx+JfKvnYXP73cIOIDgkX?=
 =?us-ascii?Q?HC4/2Z4kcSLvlMPYzlkD2krRs6NGKo6oOyT8pug+Lb7lQMFynStOZWIG3M9r?=
 =?us-ascii?Q?SE9P9rHeOcAGi7Rdc7BfY/WyNywYJrjAkw/ilv8n54rRYOdy35VU+ESzyg8A?=
 =?us-ascii?Q?BqBaTi3mmvQB8voqchqjc+WRpnmWNWL5s9MoaSAOeQriKvIWG93tnE/MZtPd?=
 =?us-ascii?Q?iynLzLOVQdFTmrl59tlDCB4Dew42X3vY9mf+7xqJRAmTUWy5Shxb4RTd1RlT?=
 =?us-ascii?Q?Ih9HXqEXDt19/T9Agshvhsv/b/WZvzAR6pEa1RnkDz9IeK99nAp0O3X6XiU6?=
 =?us-ascii?Q?yKVdYHy3pX4CxDkhPWvBsVHYtDEUwn3sGCzC5dVikNs5UKR4JjzZ9KHKwzga?=
 =?us-ascii?Q?RRDI2UbJ8ARqdCXsVovFuvFSJpUlTkt/U/fuBMeRSoTi6xW02nhim9+g5bkQ?=
 =?us-ascii?Q?APsmB01An3jvRJsHrwLpSf9uoZZWoL5oMFZWqxWVcXPAIoJ5BfjmCVN/Y9ST?=
 =?us-ascii?Q?/VweZIHzGhxR8v6YvCXRHrWFuLLM/6r1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2024 22:09:01.3326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e40382-aaab-44db-4d64-08dcb01b0d58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418

On Fri, Jul 26, 2024 at 02:51:57PM -0400, Paolo Bonzini wrote:
> Right now, large folios are not supported in guest_memfd, and therefore the order
> used by kvm_gmem_populate() is always 0.  In this scenario, using the up-to-date
> bit to track prepared-ness is nice and easy because we have one bit available
> per page.
> 
> In the future, however, we might have large pages that are partially populated;
> for example, in the case of SEV-SNP, if a large page has both shared and private
> areas inside, it is necessary to populate it at a granularity that is smaller
> than that of the guest_memfd's backing store.  In that case we will have
> to track preparedness at a 4K level, probably as a bitmap.
> 
> In preparation for that, do not use explicitly folio_test_uptodate() and
> folio_mark_uptodate().  Return the state of the page directly from
> __kvm_gmem_get_pfn(), so that it is expected to apply to 2^N pages
> with N=*max_order.  The function to mark a range as prepared for now
> takes just a folio, but is expected to take also an index and order
> (or something like that) when large pages are introduced.
> 
> Thanks to Michael Roth for pointing out the issue with large pages.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

