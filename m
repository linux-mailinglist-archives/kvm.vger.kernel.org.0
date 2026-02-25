Return-Path: <kvm+bounces-71792-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IKVeIv+LnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71792-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:43:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7651921AC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:43:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 54CEF30AF3C0
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3972DE6FF;
	Wed, 25 Feb 2026 05:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1GoC4UgK"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE5E27FB2E;
	Wed, 25 Feb 2026 05:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998189; cv=fail; b=cN8jT3kW+LOEQoFt6CYwCJZd9i+X7cyRcsPBAGauRYEHbZj4kNSq+4qMgAWM+DmI6Ejb67XBuJoKgda/pAneIxpootNSDq6ZMppAPWB9puUfLJgW5w5ce1XHobXx7T0bA6nmggRIdt/rMFEfG579JlfrDJV7klLiYGCVFDUe8QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998189; c=relaxed/simple;
	bh=MErr3RatSDpH10Yk4DfiZOPRvnkByWSUScTrAa3V91U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rgowcs4yHwniufThiA5HYY5rhlvltjWzRJdZRV5wNqKUkMj2GDG4Pd+olxL0gZ/04U3JEuxzgqMbdeaTzWAE2XRDyytUmVG4RDCdZWUgF4naCLcb8ZMRMLHkR733rCxkY3jGltUVXtZTuz9cZdxxU2sZsyzY7YDEHk5ALryyoyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1GoC4UgK; arc=fail smtp.client-ip=40.107.208.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VfMCOMR+d6FHOIYRaRKTHG+Gc2ZO/t6ELGIFvSm8xPUtwFWcKX4rBVyqtIt3xahsCqe6XMpRZJTdT4fgZp0CqInq9s5HlBmfyRd13zubq3Z3PwM7QPjjcS1zjDzh+c2UHsINHqmU8cCIUR+OJZvlyppe6gojRK5Ankh/9EOspOU1VyGG1U9fTMDBQE84uoRMuqYcKAnOxjOE4sV0taeGD6V+jA35hrrCQjITuJo4SnRUxjvjSo0zLHVUMZzyPuzq2jtdb9EzEBP1CVZrDGHsAA/S/s31Ewn4mnw7l8g8QayPOifsIoZWU6fUDOrOKlwGCoEOQxaZNLt3Q3Ixc1+HYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4Rb7tIJgjv++GdtUNJBQeZ+54M6sxqKXPR1t7mj3fA=;
 b=Zxweb6jKO/VdJ8Fx90qDAheOlC2Pi4BdNo3wUKkocumYLrI0+YaLY47iiM1xE4HXhmN/nlr0j3nUVYUxI0gAL6AEf132OWU8yPli1R8q3DrFQkLLZvZn3N2p7tm/xaWwOt5+9kNBqOsIq5l8vzzk4lnRMSZIxjURYNEfbVZkKsvEFa5whROJmXXzVloSpmorQdV/53zSisbeKn3vYYzInUVZnV3VFjsnhetnRc2an+C7DVIP2wXUkYgrLlwrconVQkVaOCRIwxohNb3kHmpvOfNBGMl1xv+WzFu6oO5LqV9CHmBbqdYNstVD/wGlWxlT3RBIgh8pKFVBeWWw9AqXdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4Rb7tIJgjv++GdtUNJBQeZ+54M6sxqKXPR1t7mj3fA=;
 b=1GoC4UgKDfXlAdVBgEYRwALZ6O+CgOd3d3tgeETvR0rHSjhqzFmBi6FLowV9ILZYg5Uafz6cHCwWfWSPd7cxXM4AxX81mifoBa36WP83fd2ajUEoGaboXTccLGg94J5OEP72s2Dy1TmIfdvfPasEFgD/9Rp3xNcPCelO+tQF/Ws=
Received: from SJ0PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:33f::26)
 by DM6PR12MB4468.namprd12.prod.outlook.com (2603:10b6:5:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 25 Feb
 2026 05:43:00 +0000
Received: from SJ5PEPF000001EB.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::82) by SJ0PR05CA0051.outlook.office365.com
 (2603:10b6:a03:33f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:42:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EB.mail.protection.outlook.com (10.167.242.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 05:42:59 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:42:38 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [PATCH kernel 7/9] coco/sev-guest: Implement the guest support for SEV TIO (phase2)
Date: Wed, 25 Feb 2026 16:37:50 +1100
Message-ID: <20260225053806.3311234-8-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225053806.3311234-1-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EB:EE_|DM6PR12MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ac5a50f-ea3b-4692-ebb6-08de7430bc03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVRsZjltek1adHgrNlQ2bWhHZ1V1Q1d0RXdSTytmOFFCK21sdkVzR1BlQXhX?=
 =?utf-8?B?MUZXUTExSXFTaFhNQ21oYWZHdmpjNCtONXdzM3E3MytvYVh3dlRWM2Z0UU1V?=
 =?utf-8?B?MDRydGlzYXF4Q3VKOGY5STd5VDV3Tm40MUw5VklyL2ZFd2w0NHlxTVBKN2tt?=
 =?utf-8?B?bU1kc0lpc3dKNUxnOVJrTE9RVkFWdWRRdWRBaGdxMnZtSVR3UWpJRVZOQXNJ?=
 =?utf-8?B?TDFTZFYya1NrMnVxQ2svc1lISW85bUFQc21DbitWak9XbDNkVnhhc2N0VGpM?=
 =?utf-8?B?YlRzTU1YZS9xSVlSWVIvM3ZXVG1JdUlBMVpnWGtFWndnUFRhbDdqbmZoS1Vk?=
 =?utf-8?B?ekFTamZ3SHZ1TVUxRGVsNXN1SXF5b3huOVhxdGU0Z3hHZ0Z5ZmRGVTNpZGpx?=
 =?utf-8?B?ZE9MYjRFWlBvbkhEOG5XNFJybkFhNHBwRDRUclpldnRiekpISzhkL2lTdGNB?=
 =?utf-8?B?YXBKa01ob3lxVXpXM3RpN2hkUGRZak43aXljU0p6bldUNWMyNDIyQTF5QUlJ?=
 =?utf-8?B?U04xUHd3blBlWHYrK2d4RERIdVBxVnBGME05MUdWbWpiNmcwVHhxY1ZpQXZE?=
 =?utf-8?B?UDROeVY1b1BEaFl6amJOR1NrRUlLWVRtYWRtSFpoZkV1amIyUjRvZnYvbXhz?=
 =?utf-8?B?UGhhM1JzeVJ5R2daZWRVY3cxMjJwL1BLWlhPVjBBWUpxU1phMDBuaEttWDAv?=
 =?utf-8?B?ZEFtTnllL0VpS2F3NkxDOFhiZWlNMXVMWjFZUjJmZDVTQkc0Wk1sUDk0VjZp?=
 =?utf-8?B?aDNjY0o2Mk9SZTBWaUk3SHFxMzkybVpBay8xdWo4Uzd1SEpDQ2liU2E3cWJP?=
 =?utf-8?B?bkNnWDYvaVZicnVLRURJOVplcnRzZHdkcTRXVnc1U3BpWjljYk9WTWJwWDVO?=
 =?utf-8?B?Z21DYTVpZjFTakRsaU41czZReGNmanpQNFdaRjNIUEtrOGlTMmNOR21CS1Js?=
 =?utf-8?B?YisyZzErdFRzNlNkSjNXUGFqUit6M25TQ3NUeTN3Q2hHa1R1dFg4RitzdDVP?=
 =?utf-8?B?SzVFUTE3RVB4RnNLbTg3K3lQNFVRaWV2cWQ4eTV2Rkt2QmpsVFl4cXY5NFJQ?=
 =?utf-8?B?YXVjRGhkamVKUDVhVlNiWTc4UDRYUUJwNWpaZ040VVRQdWdDZmJQaWhQdkdq?=
 =?utf-8?B?OG9ONVhqY0FzbjZ5ekVEckZZWVhqdVFJa3NOK3FNUDRjczY2bGxoUFFnRXp1?=
 =?utf-8?B?NlZ5THU4K29GZytBakpESndKaDRMU2h6RkpraFNPd2xoQVNEeVNHWTRqOGVF?=
 =?utf-8?B?MHdvSEpSb3p3UTQ2TjJicnZsNUNzRFdGR20wVlFSaUdIL3VuSnhlTGk3RmRy?=
 =?utf-8?B?YzFMZUZOeXRXWXBOZTBwY2hHZ05waUVFeU9na0dVc0FreWtTWHFidEQ1SHFz?=
 =?utf-8?B?NVNleCtJSEhhSDNFcHU3UmJRZEg5Z1JaR2FIY204K0xGTEhZVUloYkJlbmJq?=
 =?utf-8?B?REd2eExyR0ZPUFA5TlJsclhnSENmZVo0a1ZvaC9yZGJwUnNhY2hJeDVvTFZ2?=
 =?utf-8?B?dUFZTlpvekphaVFCcGlQcE81RE0rdmk2LzRaOW8vTUNCUUdhUisxMVorc0hW?=
 =?utf-8?B?TU13eW13NmJiLy8wTjF5VkhZZG9IZzhFWEt2MTNpOGF6b2JFSEpkTjdOcWlH?=
 =?utf-8?B?bWgrOEpyYzAwZHZKSkEyTkY5amJQRzhEUXFBbVFOYlVIVUk3TkhBVndMWVNX?=
 =?utf-8?B?aHdTdzAwY1ZWQjMzUko3c2hMTVl0TUgyRXZKZlhadU5ZM2tXT0ZlNnNjdUVs?=
 =?utf-8?B?T2Fld3YxV21oMnhhNTB4dWV6US9PT0JuU2pKOWJJVVk4cE5SNEdBRjZYVVdY?=
 =?utf-8?B?MmVsZGNWcFFYaXIvVldDV2V0Qlo0MzYwc1VGZkxOSCtwZmNmWitMNXFDWElZ?=
 =?utf-8?B?QTRpQVVpYWc1b3BvVU9mbnZ2TWx1MDMwSEJjMnRraWpPZk9wdzJqbytLU004?=
 =?utf-8?B?UWlDbDMzL29wcCtTYzBxY2U4OW5SVVFPTTF3ZUtTQ1FrMlZpU2RWaU5Nc05K?=
 =?utf-8?B?TnVsUUlVR1E5TVJIOUlFd2tHdVBqSnplNDB3bmVoQ3dxYnBNREFHa0FUdzVj?=
 =?utf-8?B?cHEwUE9rZlZLOXJIbndRNkxHRnR4N3VmSTdOSDFBaFZIb2hsNFF4YWxWdTI4?=
 =?utf-8?B?VlNublVRcksyU1AxWGU0SFpEZUtwUTEvN3dsakw0VXlMcGhDSDZJaGtqMTR4?=
 =?utf-8?B?bnI4SnRCN0EyODhmKzRCenlMRFlVZ0syc2NVUWlvUWtKWXVVU1hJdEExK2tI?=
 =?utf-8?B?b0tiWWY4d3hSeFFwdnJhdWVGMThnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	55Vn5kxN6h07wsuwv4SffXdyA9vlJ8d8UTF3W2OxvGqVelgrkqDedN8K96G/0J797ZwqdH0MCe6slFuQiDl/QSi2vUG9IWw0hDmErLBriUdS5OJMGg1t7UtwU4xHQuzgTlB8UxMcNp6aJ8kemSxwhLz3KHbZQ1qRlIMxzvSmeyegct5AVu7XR1qLofD6TDNgN+n8EyvYa2T0ye7t4BqqjZw6ONfUy99g1tlE0xZdSvb2E1vyeeWtZdwqo4f0McfriYEng6plV9mw0p9PzB0xxLBb2Ygm2+Lub1PC//IsMaa3DbXVTtYnf0bp0GormSHO+0tmLcmAjTFoha3T3+ebLWxAqwTwflP38L5LhVN2U9YXfpIlh5QApCLKcWKHNL64RymLqz0V3CoTjujFVELjaWwvrnCSxWaP1ce/oO1MZOsvjZaV9FN6EEZitljTrNyL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:42:59.3395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac5a50f-ea3b-4692-ebb6-08de7430bc03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4468
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_SEVEN(0.00)[7];
	RCPT_COUNT_GT_50(0.00)[58];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71792-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: EF7651921AC
X-Rspamd-Action: no action

Implement the SEV-TIO (Trusted I/O) support in for AMD SEV-SNP guests.

The implementation includes Device Security Manager (DSM) operations
for:
- binding a PCI function (GHCB extension) to a VM and locking
the device configuration;
- receiving TDI report and configuring MMIO and DMA/sDTE;
- accepting the device into the guest TCB.

Detect the SEV-TIO support (reported via GHCB HV features) and install
the SEV-TIO TSM ops.

Implement lock/accept/unlock TSM ops.

Define 2 new VMGEXIT codes for GHCB:
- TIO Guest Request to provide secure communication between a VM and
the FW (for configuring MMIO and DMA);
- TIO Op for requesting the HV to bind a TDI to the VM and for
starting/stopping a TDI.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/Kconfig     |   1 +
 drivers/virt/coco/sev-guest/Makefile    |   3 +
 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              |  13 +
 arch/x86/include/uapi/asm/svm.h         |  13 +
 drivers/virt/coco/sev-guest/sev-guest.h |   4 +
 include/linux/psp-sev.h                 |  31 +
 include/uapi/linux/sev-guest.h          |  43 ++
 arch/x86/coco/sev/core.c                |  53 ++
 drivers/virt/coco/sev-guest/sev-guest.c |  13 +
 drivers/virt/coco/sev-guest/tio.c       | 707 ++++++++++++++++++++
 11 files changed, 882 insertions(+)

diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index a6405ab6c2c3..4255072dfa1a 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -3,6 +3,7 @@ config SEV_GUEST
 	default m
 	depends on AMD_MEM_ENCRYPT
 	select TSM_REPORTS
+	select PCI_TSM if PCI
 	help
 	  SEV-SNP firmware provides the guest a mechanism to communicate with
 	  the PSP without risk from a malicious hypervisor who wishes to read,
diff --git a/drivers/virt/coco/sev-guest/Makefile b/drivers/virt/coco/sev-guest/Makefile
index 9604792e0095..b4766289c85f 100644
--- a/drivers/virt/coco/sev-guest/Makefile
+++ b/drivers/virt/coco/sev-guest/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_SEV_GUEST) += sev_guest.o
 sev_guest-y += sev-guest.o
+ifeq ($(CONFIG_PCI_TSM),y)
+sev_guest-y += tio.o
+endif
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 01a6e4dbe423..ff763c3c5d63 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -137,6 +137,7 @@ enum psc_op {
 #define GHCB_HV_FT_SNP			BIT_ULL(0)
 #define GHCB_HV_FT_SNP_AP_CREATION	BIT_ULL(1)
 #define GHCB_HV_FT_SNP_MULTI_VMPL	BIT_ULL(5)
+#define GHCB_HV_FT_SNP_SEV_TIO		BIT_ULL(7)
 
 /*
  * SNP Page State Change NAE event
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..f6e1a2f96d47 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -149,6 +149,8 @@ struct snp_req_data {
 	unsigned long resp_gpa;
 	unsigned long data_gpa;
 	unsigned int data_npages;
+	unsigned int guest_rid;
+	unsigned long param;
 };
 
 #define MAX_AUTHTAG_LEN		32
@@ -179,6 +181,14 @@ enum msg_type {
 
 	SNP_MSG_TSC_INFO_REQ = 17,
 	SNP_MSG_TSC_INFO_RSP,
+	TIO_MSG_TDI_INFO_REQ = 19,
+	TIO_MSG_TDI_INFO_RSP = 20,
+	TIO_MSG_MMIO_VALIDATE_REQ = 21,
+	TIO_MSG_MMIO_VALIDATE_RSP = 22,
+	TIO_MSG_MMIO_CONFIG_REQ = 23,
+	TIO_MSG_MMIO_CONFIG_RSP = 24,
+	TIO_MSG_SDTE_WRITE_REQ = 25,
+	TIO_MSG_SDTE_WRITE_RSP = 26,
 
 	SNP_MSG_TYPE_MAX
 };
@@ -597,6 +607,9 @@ static inline void sev_evict_cache(void *va, int npages)
 	}
 }
 
+bool sev_tio_ghcb_supported(void);
+int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 650e3256ea7d..c4b735d0aa1e 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -122,6 +122,17 @@
 #define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
 #define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
 #define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
+#define SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST	0x80000020
+#define SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST_PARAM_STATE	BIT(0)
+#define SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST_PARAM_REPORT	BIT(3)
+#define SVM_VMGEXIT_SEV_TIO_OP			0x80000021
+#define SVM_VMGEXIT_SEV_TIO_OP_PARAM(guest_id, action)	((u64)(action)<<32|(guest_id))
+#define SVM_VMGEXIT_SEV_TIO_OP_ACTION(exitinfo1)	((exitinfo1)>>32)
+#define SVM_VMGEXIT_SEV_TIO_OP_GUEST_ID(exitinfo1)	((exitinfo1) & 0xFFFFFFFF)
+#define SVM_VMGEXIT_SEV_TIO_OP_BIND	0
+#define SVM_VMGEXIT_SEV_TIO_OP_UNBIND	1
+#define SVM_VMGEXIT_SEV_TIO_OP_RUN	2
+#define SVM_VMGEXIT_SEV_TIO_OP_STOP	3
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
@@ -245,6 +256,8 @@
 	{ SVM_VMGEXIT_GUEST_REQUEST,	"vmgexit_guest_request" }, \
 	{ SVM_VMGEXIT_EXT_GUEST_REQUEST, "vmgexit_ext_guest_request" }, \
 	{ SVM_VMGEXIT_AP_CREATION,	"vmgexit_ap_creation" }, \
+	{ SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST, "vmgexit_sev_tio_guest_request" }, \
+	{ SVM_VMGEXIT_SEV_TIO_OP,	"vmgexit_sev_tio_op" }, \
 	{ SVM_VMGEXIT_HV_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
index b2a97778e635..c823a782739f 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -11,6 +11,10 @@ struct snp_guest_dev {
 	struct miscdevice misc;
 
 	struct snp_msg_desc *msg_desc;
+
+	struct tsm_dev *tsmdev;
 };
 
+void sev_guest_tsm_set_ops(bool set, struct snp_guest_dev *snp_dev);
+
 #endif /* __SEV_GUEST_H__ */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index cce864dbf281..dc2932953abc 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -1050,4 +1050,35 @@ static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false;
 
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
+/*
+ * Status codes from TIO_MSG_MMIO_VALIDATE_REQ
+ */
+enum mmio_validate_status {
+	MMIO_VALIDATE_SUCCESS = 0,
+	MMIO_VALIDATE_INVALID_TDI = 1,
+	MMIO_VALIDATE_TDI_UNBOUND = 2,
+	MMIO_VALIDATE_NOT_ASSIGNED = 3,
+	MMIO_VALIDATE_NOT_IO = 4,
+	MMIO_VALIDATE_NOT_UNIFORM = 5,  /* The Validated bit is not uniformly set for
+					   the MMIO subrange */
+	MMIO_VALIDATE_NOT_IMMUTABLE = 6,/* At least one page does not have immutable bit set
+					   when validated bit is clear */
+	MMIO_VALIDATE_NOT_MAPPED = 7,   /* At least one page is not mapped to the expected GPA */
+	MMIO_VALIDATE_NOT_REPORTED = 8, /* The provided MMIO range ID is not reported in
+					   the interface report */
+	MMIO_VALIDATE_OUT_OF_RANGE = 9, /* The subrange is out the MMIO range in
+					   the interface report */
+	MMIO_VALIDATE_NOT_4K = 10,	/* At least one page is not 4K page size */
+};
+
+/*
+ * Status codes from TIO_MSG_SDTE_WRITE_REQ
+ */
+enum sdte_write_status {
+	SDTE_WRITE_SUCCESS = 0,
+	SDTE_WRITE_INVALID_TDI = 1,
+	SDTE_WRITE_TDI_NOT_BOUND = 2,
+	SDTE_WRITE_RESERVED = 3,
+};
+
 #endif	/* __PSP_SEV_H__ */
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index fcdfea767fca..5015160254f4 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -13,6 +13,7 @@
 #define __UAPI_LINUX_SEV_GUEST_H_
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 #define SNP_REPORT_USER_DATA_SIZE 64
 
@@ -96,4 +97,46 @@ struct snp_ext_report_req {
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
 
+/*
+ * TIO_GUEST_REQUEST's TIO_MSG_MMIO_VALIDATE_REQ
+ * encoding for MMIO in RDX:
+ *
+ * ........ ....GGGG GGGGGGGG GGGGGGGG GGGGGGGG GGGGGGGG GGGGOOOO OOOOTrrr
+ * Where:
+ *	G - guest physical address
+ *	O - order of 4K pages
+ *	T - TEE (valid for TIO_MSG_MMIO_CONFIG_REQ)
+ *	r - range id == BAR
+ */
+#define MMIO_VALIDATE_GPA(r)      ((r) & 0x000FFFFFFFFFF000ULL)
+#define MMIO_VALIDATE_LEN(r)      (1ULL << (12 + (((r) >> 4) & 0xFF)))
+#define MMIO_VALIDATE_RANGEID(r)  ((r) & 0x7)
+#define MMIO_VALIDATE_RESERVED(r) ((r) & 0xFFF0000000000000ULL)
+#define MMIO_VALIDATE_PRIVATE(r)  (!!((r) & BIT(3)))
+
+#define MMIO_MK_VALIDATE(start, size, range_id, private) \
+	(MMIO_VALIDATE_GPA(start) | \
+	(get_order(size) << 4) | \
+	((private) ? BIT(3) : 0) | \
+	((range_id) & 7) )
+
+#define SDTE_VALIDATE		1
+
+/* Optional Certificates/measurements/report data from TIO_GUEST_REQUEST */
+struct tio_blob_table_entry {
+	guid_t guid;
+	__u32 offset;
+	__u32 length;
+} __packed;
+
+/* Measurement’s blob: 5caa80c6-12ef-401a-b364-ec59a93abe3f */
+#define TIO_GUID_MEASUREMENTS \
+	GUID_INIT(0x5caa80c6, 0x12ef, 0x401a, 0xb3, 0x64, 0xec, 0x59, 0xa9, 0x3a, 0xbe, 0x3f)
+/* Certificates blob: 078ccb75-2644-49e8-afe7-5686c5cf72f1 */
+#define TIO_GUID_CERTIFICATES \
+	GUID_INIT(0x078ccb75, 0x2644, 0x49e8, 0xaf, 0xe7, 0x56, 0x86, 0xc5, 0xcf, 0x72, 0xf1)
+/* Attestation report: 70dc5b0e-0cc0-4cd5-97bb-ff0ba25bf320 */
+#define TIO_GUID_REPORT \
+	GUID_INIT(0x70dc5b0e, 0x0cc0, 0x4cd5, 0x97, 0xbb, 0xff, 0x0b, 0xa2, 0x5b, 0xf3, 0x20)
+
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e6..1f2e34367772 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -136,6 +136,43 @@ static unsigned long snp_tsc_freq_khz __ro_after_init;
 DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 DEFINE_PER_CPU(struct sev_es_save_area *, sev_vmsa);
 
+bool sev_tio_ghcb_supported(void)
+{
+	return !!(sev_hv_features & GHCB_HV_FT_SNP_SEV_TIO);
+}
+EXPORT_SYMBOL_GPL(sev_tio_ghcb_supported);
+
+int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	struct ghcb *ghcb;
+	int ret;
+
+	/* __sev_get_ghcb() needs IRQs disabled because it uses per-CPU GHCB. */
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	if (!ghcb)
+		return -EIO;
+
+	vc_ghcb_invalidate(ghcb);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SEV_TIO_OP,
+				  SVM_VMGEXIT_SEV_TIO_OP_PARAM(guest_rid, op), 0);
+
+	*fw_err = ghcb->save.sw_exit_info_2;
+	if (*fw_err)
+		ret = -EIO;
+
+	if (!ret && op == SVM_VMGEXIT_SEV_TIO_OP_BIND && tdi_id)
+		*tdi_id = ghcb_get_rcx(ghcb);
+
+	__sev_put_ghcb(&state);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sev_tio_op);
+
 /*
  * SVSM related information:
  *   When running under an SVSM, the VMPL that Linux is executing at must be
@@ -1666,6 +1703,11 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 	if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
 		ghcb_set_rax(ghcb, input->data_gpa);
 		ghcb_set_rbx(ghcb, input->data_npages);
+	} else if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST) {
+		ghcb_set_rax(ghcb, input->data_gpa);
+		ghcb_set_rbx(ghcb, input->data_npages);
+		ghcb_set_rcx(ghcb, input->guest_rid);
+		ghcb_set_rdx(ghcb, input->param);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
@@ -1675,6 +1717,8 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 	req->exitinfo2 = ghcb->save.sw_exit_info_2;
 	switch (req->exitinfo2) {
 	case 0:
+		if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST)
+			input->param = ghcb_get_rdx(ghcb);
 		break;
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_BUSY):
@@ -1687,6 +1731,10 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 			input->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
+		} else if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST) {
+			input->data_npages = ghcb_get_rbx(ghcb);
+			ret = -ENOSPC;
+			break;
 		}
 		fallthrough;
 	default:
@@ -2176,6 +2224,11 @@ static int __handle_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_r
 	rc = snp_issue_guest_request(req);
 	switch (rc) {
 	case -ENOSPC:
+		if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST) {
+			pr_warn("SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST => -ENOSPC");
+			break;
+		}
+
 		/*
 		 * If the extended guest request fails due to having too
 		 * small of a certificate data buffer, retry the same
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index e1ceeab54a21..41072ece79a8 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -46,6 +46,10 @@ static int vmpck_id = -1;
 module_param(vmpck_id, int, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
+static bool tsm_enable = true;
+module_param(tsm_enable, bool, 0644);
+MODULE_PARM_DESC(tsm_enable, "Enable SEV TIO");
+
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 {
 	struct miscdevice *dev = file->private_data;
@@ -667,6 +671,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->msg_desc = mdesc;
 	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n",
 		 mdesc->vmpck_id);
+
+	if (!sev_tio_ghcb_supported())
+		tsm_enable = false;
+
+	if (tsm_enable)
+		sev_guest_tsm_set_ops(true, snp_dev);
+
 	return 0;
 
 e_msg_init:
@@ -680,6 +691,8 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
 	snp_msg_free(snp_dev->msg_desc);
+	if (tsm_enable)
+		sev_guest_tsm_set_ops(false, snp_dev);
 	misc_deregister(&snp_dev->misc);
 }
 
diff --git a/drivers/virt/coco/sev-guest/tio.c b/drivers/virt/coco/sev-guest/tio.c
new file mode 100644
index 000000000000..6739b1f49e0e
--- /dev/null
+++ b/drivers/virt/coco/sev-guest/tio.c
@@ -0,0 +1,707 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bitfield.h>
+#include <linux/bitops.h>
+#include <linux/pci.h>
+#include <linux/psp-sev.h>
+#include <linux/tsm.h>
+#include <linux/pci-tsm.h>
+#include <crypto/gcm.h>
+#include <uapi/linux/sev-guest.h>
+
+#include <asm/svm.h>
+#include <asm/sev.h>
+#include <asm/sev-internal.h>
+
+#include "sev-guest.h"
+
+#define TIO_MESSAGE_VERSION	1
+
+ulong tsm_vtom = 0x7fffffff;
+module_param(tsm_vtom, ulong, 0644);
+MODULE_PARM_DESC(tsm_vtom, "SEV TIO vTOM value");
+
+#define tsm_dev_to_snp_dev(t)	((struct snp_guest_dev *)dev_get_drvdata((t)->dev.parent))
+#define pdev_to_tdi(p)		container_of((p)->tsm, struct tio_guest_tdi, ds.base_tsm)
+
+struct tio_guest_tdi {
+	struct pci_tsm_devsec ds;
+	struct snp_guest_dev *snp_dev;
+	u64 tdi_id; /* Runtime FW generated TDI id */
+};
+
+static int handle_tio_guest_request(struct snp_guest_dev *snp_dev, u8 type,
+				   void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
+				   void *pt, u64 *npages, u64 *bdfn, u64 *param, u64 *fw_err)
+{
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
+	struct snp_guest_req req = {
+		.msg_version = TIO_MESSAGE_VERSION,
+	};
+	u64 exitinfo2 = 0;
+	int ret;
+
+	req.msg_type = type;
+	req.vmpck_id = mdesc->vmpck_id;
+	req.req_buf = kmemdup(req_buf, req_sz, GFP_KERNEL);
+	req.req_sz = req_sz;
+	req.resp_buf = kmalloc(resp_sz, GFP_KERNEL);
+	req.resp_sz = resp_sz;
+	req.exit_code = SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST;
+
+	req.input.guest_rid = 0;
+	req.input.param = 0;
+
+	if (pt && npages) {
+		req.certs_data = pt;
+		req.input.data_npages = *npages;
+	}
+	if (bdfn)
+		req.input.guest_rid = *bdfn;
+	req.input.param = *param;
+
+	ret = snp_send_guest_request(mdesc, &req);
+
+	memcpy(resp_buf, req.resp_buf, resp_sz);
+
+	*param = req.input.param;
+
+	*fw_err = exitinfo2;
+
+	kfree(req.resp_buf);
+	kfree(req.req_buf);
+
+	return ret;
+}
+
+static void free_shared_pages(void *buf, size_t sz)
+{
+	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+	int ret;
+
+	if (!buf)
+		return;
+
+	ret = set_memory_encrypted((unsigned long)buf, npages);
+	if (ret) {
+		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
+		return;
+	}
+
+	__free_pages(virt_to_page(buf), get_order(sz));
+}
+
+static void *alloc_shared_pages(size_t sz)
+{
+	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+	struct page *page;
+	int ret;
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
+	if (!page)
+		return NULL;
+
+	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
+	if (ret) {
+		pr_err("failed to mark page shared, ret=%d\n", ret);
+		__free_pages(page, get_order(sz));
+		return NULL;
+	}
+
+	return page_address(page);
+}
+
+static int guest_request_tio_data(struct snp_guest_dev *snp_dev, u8 type,
+				  void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
+				  u64 bdfn, enum tsm_tdisp_state *state,
+				  struct tsm_blob **report, u64 *fw_err)
+{
+#define TIO_DATA_PAGES	(SZ_32K >> PAGE_SHIFT)
+	u64 npages = TIO_DATA_PAGES, param = 0;
+	struct tio_blob_table_entry *pt;
+	int rc;
+
+	pt = alloc_shared_pages(TIO_DATA_PAGES << PAGE_SHIFT);
+	if (!pt)
+		return -ENOMEM;
+
+	if (state)
+		param |= SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST_PARAM_STATE;
+	if (report)
+		param |= SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST_PARAM_REPORT;
+
+	rc = handle_tio_guest_request(snp_dev, type, req_buf, req_sz, resp_buf, resp_sz,
+				      pt, &npages, &bdfn, &param, fw_err);
+	if (npages > TIO_DATA_PAGES) {
+		free_shared_pages(pt, TIO_DATA_PAGES << PAGE_SHIFT);
+		pt = alloc_shared_pages(npages << PAGE_SHIFT);
+		if (!pt)
+			return -ENOMEM;
+
+		rc = handle_tio_guest_request(snp_dev, type, req_buf, req_sz, resp_buf, resp_sz,
+					      pt, &npages, &bdfn, &param, fw_err);
+	}
+	if (rc)
+		return rc;
+
+	if (report) {
+		tsm_blob_free(*report);
+		*report = NULL;
+	}
+
+	for (unsigned int i = 0; i < 3; ++i) {
+		u8 *ptr = ((u8 *) pt) + pt[i].offset;
+		size_t len = pt[i].length;
+		struct tsm_blob *b;
+
+		if (guid_is_null(&pt[i].guid))
+			break;
+
+		if (!len)
+			continue;
+
+		b = tsm_blob_new(ptr, len);
+		if (!b)
+			break;
+
+		if (guid_equal(&pt[i].guid, &TIO_GUID_REPORT) && report)
+			*report = b;
+	}
+	free_shared_pages(pt, npages);
+
+	if (state)
+		*state = param;
+
+	return 0;
+}
+
+struct tio_msg_tdi_info_req {
+	u16 guest_device_id;
+	u8 reserved[14];
+} __packed;
+
+enum {
+	TIO_MSG_TDI_INFO_RSP_STATUS_BOUND = 0,
+	TIO_MSG_TDI_INFO_RSP_STATUS_INVALID = 1,
+	TIO_MSG_TDI_INFO_RSP_STATUS_UNBOUND = 2,
+};
+
+struct tio_msg_tdi_info_rsp {
+	u16 guest_device_id;
+	u16 status; /* TIO_MSG_TDI_INFO_RSP_STATUS_xxx */
+	u8 reserved1[12];
+
+	u32 meas_digest_valid:1;
+	u32 meas_digest_fresh:1;
+	u32 reserved2:30;
+
+	/* These are TDISP's LOCK_INTERFACE_REQUEST flags */
+	u32 no_fw_update:1;
+	u32 cache_line_size:1;
+	u32 lock_msix:1;
+	u32 bind_p2p:1;
+	u32 all_request_redirect:1;
+	u32 reserved3:27;
+
+	u64 spdm_algos;
+	u8 certs_digest[48];
+	u8 meas_digest[48];
+	u8 interface_report_digest[48];
+	u64 tdi_report_count;
+	u64 reserved4;
+} __packed;
+
+/* Passing pci_tsm explicitly as it may not be set in pci_dev just yet */
+static int tio_tdi_status(struct pci_dev *pdev, struct snp_guest_dev *snp_dev,
+			  struct tsm_tdi_status *ts, struct tsm_blob **report)
+{
+	enum tsm_tdisp_state state = TDISP_STATE_CONFIG_UNLOCKED;
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
+	size_t resp_len = sizeof(struct tio_msg_tdi_info_rsp) + mdesc->ctx->authsize;
+	struct tio_msg_tdi_info_rsp *rsp __free(kfree_sensitive) = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_tdi_info_req req = {
+		.guest_device_id = pci_dev_id(pdev),
+	};
+	u64 fw_err = 0;
+	int rc;
+
+	pci_notice(pdev, "TDI info");
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = guest_request_tio_data(snp_dev, TIO_MSG_TDI_INFO_REQ, &req,
+				    sizeof(req), rsp, resp_len,
+				    req.guest_device_id, &state,
+				    report, &fw_err);
+	if (rc)
+		return rc;
+
+	ts->no_fw_update = rsp->no_fw_update;
+	ts->cache_line_size = rsp->cache_line_size == 0 ? 64 : 128;
+	ts->lock_msix = rsp->lock_msix;
+	ts->bind_p2p = rsp->bind_p2p;
+	ts->all_request_redirect = rsp->all_request_redirect;
+	memcpy(ts->interface_report_digest, rsp->interface_report_digest,
+	       sizeof(ts->interface_report_digest));
+	ts->intf_report_counter = rsp->tdi_report_count;
+
+	switch (rsp->status) {
+	case TIO_MSG_TDI_INFO_RSP_STATUS_BOUND:
+		ts->status = TDISP_STATE_BOUND;
+		break;
+	case TIO_MSG_TDI_INFO_RSP_STATUS_UNBOUND:
+		ts->status = TDISP_STATE_UNBOUND;
+		break;
+	default:
+		ts->status = TDISP_STATE_INVALID;
+		break;
+	}
+	ts->state = state;
+
+	return 0;
+}
+
+struct tio_msg_mmio_validate_req {
+	u16 guest_device_id;
+	u16 reserved1;
+	u8 reserved2[12];
+	u64 subrange_base;
+	u32 subrange_page_count;
+	u32 range_offset;
+
+	u16 validated:1; /* Desired value to set RMP.Validated for the range */
+	/*
+	 * Force validated:
+	 * 0: If subrange does not have RMP.Validated set uniformly, fail.
+	 * 1: If subrange does not have RMP.Validated set uniformly, force
+	 *    to requested value
+	 */
+	u16 force_validated:1;
+	u16 reserved3:14;
+
+	u16 range_id;
+	u8 reserved4[12];
+} __packed;
+
+struct tio_msg_mmio_validate_rsp {
+	u16 guest_interface_id;
+	u16 status; /* MMIO_VALIDATE_xxx */
+	u8 reserved1[12];
+	u64 subrange_base;
+	u32 subrange_page_count;
+	u32 range_offset;
+
+	u16 changed:1; /* Validated bit has changed due to this operation */
+	u16 reserved2:15;
+
+	u16 range_id;
+	u8 reserved3[12];
+} __packed;
+
+static int mmio_validate_range(struct snp_guest_dev *snp_dev, struct pci_dev *pdev,
+			       unsigned int range_id,
+			       resource_size_t start, resource_size_t size,
+			       bool invalidate, u64 *fw_err, u16 *status)
+{
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
+	size_t resp_len = sizeof(struct tio_msg_mmio_validate_rsp) + mdesc->ctx->authsize;
+	struct tio_msg_mmio_validate_rsp *rsp __free(kfree_sensitive) = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_mmio_validate_req req = {
+		.guest_device_id = pci_dev_id(pdev),
+		.subrange_base = start,
+		.subrange_page_count = size >> PAGE_SHIFT,
+		.range_offset = 0,
+		.validated = !invalidate, /* Desired value to set RMP.Validated for the range */
+		.force_validated = 0,
+		.range_id = range_id,
+	};
+	u64 bdfn = pci_dev_id(pdev);
+	u64 mmio_val = MMIO_MK_VALIDATE(start, size, range_id, !invalidate);
+	int rc;
+
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = handle_tio_guest_request(snp_dev, TIO_MSG_MMIO_VALIDATE_REQ,
+			       &req, sizeof(req), rsp, resp_len,
+			       NULL, NULL, &bdfn, &mmio_val, fw_err);
+	if (rc)
+		return rc;
+
+	*status = rsp->status;
+
+	return 0;
+}
+
+static bool get_range(struct pci_dev *pdev, struct tsm_blob *report, unsigned int index,
+		      unsigned int *range_id, resource_size_t *start, resource_size_t *size)
+{
+	struct tdi_report_mmio_range mr = TDI_REPORT_MR(report, index);
+	unsigned int rangeid = FIELD_GET(TSM_TDI_REPORT_MMIO_RANGE_ID, mr.range_attributes);
+	struct resource *r = pci_resource_n(pdev, rangeid);
+	u64 first, offset;
+	unsigned int i;
+
+	if (FIELD_GET(TSM_TDI_REPORT_MMIO_IS_NON_TEE, mr.range_attributes)) {
+		pci_info(pdev, "Skipping non-TEE range [%d] #%d %d pages, %llx..%llx\n",
+			 index, rangeid, mr.num, r->start, r->end);
+		return false;
+	}
+
+	/* Currently not supported */
+	if (FIELD_GET(TSM_TDI_REPORT_MMIO_MSIX_TABLE, mr.range_attributes) ||
+	    FIELD_GET(TSM_TDI_REPORT_MMIO_PBA, mr.range_attributes)) {
+		pci_info(pdev, "Skipping MSIX (%ld/%ld) range [%d] #%d %d pages, %llx..%llx\n",
+			 FIELD_GET(TSM_TDI_REPORT_MMIO_MSIX_TABLE, mr.range_attributes),
+			 FIELD_GET(TSM_TDI_REPORT_MMIO_PBA, mr.range_attributes),
+			 index, rangeid, mr.num, r->start, r->end);
+		return false;
+	}
+
+	/*
+	 * First the first subregion of BAR, i.e. with the smallest .first_page.
+	 * This assumes that the same MMIO_REPORTING_OFFSET is applied to all regions.
+	 * */
+	for (i = 0, first = mr.first_page; i < TDI_REPORT_MR_NUM(report); ++i) {
+		struct tdi_report_mmio_range mrtmp = TDI_REPORT_MR(report, i);
+
+		if (rangeid != FIELD_GET(TSM_TDI_REPORT_MMIO_RANGE_ID, mrtmp.range_attributes))
+			continue;
+
+		first = min(mrtmp.first_page, first);
+	}
+
+	offset = mr.first_page - first;
+	if (((offset + mr.num) << PAGE_SHIFT) > (r->end - r->start + 1)) {
+		pci_warn(pdev, "Skipping broken range [%d] BAR%d off=%llx %d pages, %llx..%llx %llx %llx\n",
+			 index, rangeid, offset, mr.num, r->start, r->end, mr.first_page, first);
+		return false;
+	}
+
+	*range_id = rangeid;
+	*start = r->start + offset;
+	*size = mr.num << PAGE_SHIFT;
+
+	return true;
+}
+
+static int tio_tdi_mmio_validate(struct pci_dev *pdev, struct snp_guest_dev *snp_dev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+	u16 mmio_status;
+	u64 fw_err = 0;
+	int i = 0, rc = 0;
+	struct pci_tsm_mmio *mmio __free(kfree) =
+		kzalloc(struct_size(mmio, res, PCI_NUM_RESOURCES), GFP_KERNEL);
+
+	if (!mmio)
+		return -ENOMEM;
+
+	if (WARN_ON_ONCE(!tsm || !tsm->report))
+		return -ENODEV;
+
+	pci_notice(pdev, "MMIO validate");
+
+	for (i = 0; i < TDI_REPORT_MR_NUM(tsm->report); ++i) {
+		unsigned int range_id;
+		resource_size_t start = 0, size = 0, end;
+
+		if (!get_range(pdev, tsm->report, i, &range_id, &start, &size))
+			continue;
+
+		end = start + size - 1;
+		mmio_status = 0;
+		rc = mmio_validate_range(snp_dev, pdev, range_id, start, size,
+					 false, &fw_err,
+					 &mmio_status);
+		if (rc || fw_err != SEV_RET_SUCCESS || mmio_status != MMIO_VALIDATE_SUCCESS) {
+			pci_err(pdev, "MMIO #%d %llx..%llx validation failed 0x%llx %d\n",
+				range_id, start, end, fw_err, mmio_status);
+			continue;
+		}
+
+		mmio->res[mmio->nr] = DEFINE_RES_NAMED_DESC(start, size, "PCI MMIO Encrypted",
+				pci_resource_flags(pdev, range_id), IORES_DESC_ENCRYPTED);
+		++mmio->nr;
+
+		pci_notice(pdev, "MMIO #%d %llx..%llx validated\n",range_id, start, end);
+	}
+
+	if (!rc) {
+		rc = pci_tsm_mmio_setup(pdev, mmio);
+		if (!rc) {
+			struct pci_tsm_devsec *devsec_tsm = to_pci_tsm_devsec(tsm);
+
+			devsec_tsm->mmio = no_free_ptr(mmio);
+		}
+	}
+
+	return rc;
+}
+
+static void tio_tdi_mmio_invalidate(struct pci_dev *pdev, struct snp_guest_dev *snp_dev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+	u16 mmio_status;
+	u64 fw_err = 0;
+	int i = 0, rc = 0;
+	struct pci_tsm_devsec *devsec_tsm = to_pci_tsm_devsec(tsm);
+	struct pci_tsm_mmio *mmio = devsec_tsm->mmio;
+
+	if (!mmio)
+		return;
+
+	pci_notice(pdev, "MMIO invalidate");
+
+	for (i = 0; i < TDI_REPORT_MR_NUM(tsm->report); ++i) {
+		unsigned int range_id;
+		resource_size_t start = 0, size = 0, end;
+
+		if (!get_range(pdev, tsm->report, i, &range_id, &start, &size))
+			continue;
+
+		end = start + size - 1;
+		mmio_status = 0;
+		rc = mmio_validate_range(snp_dev, pdev, range_id,
+					 start, size, true, &fw_err,
+					 &mmio_status);
+		if (rc || fw_err != SEV_RET_SUCCESS || mmio_status != MMIO_VALIDATE_SUCCESS) {
+			pci_err(pdev, "MMIO #%d %llx..%llx validation failed 0x%llx %d\n",
+				range_id, start, end, fw_err, mmio_status);
+			continue;
+		}
+
+		pci_notice(pdev, "MMIO #%d %llx..%llx invalidated\n",  range_id, start, end);
+	}
+
+	pci_tsm_mmio_teardown(devsec_tsm->mmio);
+	kfree(devsec_tsm->mmio);
+	devsec_tsm->mmio = NULL;
+}
+
+struct sdte {
+	u64 v                  : 1;
+	u64 reserved           : 3;
+	u64 cxlio              : 3;
+	u64 reserved1          : 45;
+	u64 ppr                : 1;
+	u64 reserved2          : 1;
+	u64 giov               : 1;
+	u64 gv                 : 1;
+	u64 glx                : 2;
+	u64 gcr3_tbl_rp0       : 3;
+	u64 ir                 : 1;
+	u64 iw                 : 1;
+	u64 reserved3          : 1;
+	u16 domain_id;
+	u16 gcr3_tbl_rp1;
+	u32 interrupt          : 1;
+	u32 reserved4          : 5;
+	u32 ex                 : 1;
+	u32 sd                 : 1;
+	u32 reserved5          : 2;
+	u32 sats               : 1;
+	u32 gcr3_tbl_rp2       : 21;
+	u64 giv                : 1;
+	u64 gint_tbl_len       : 4;
+	u64 reserved6          : 1;
+	u64 gint_tbl           : 46;
+	u64 reserved7          : 2;
+	u64 gpm                : 2;
+	u64 reserved8          : 3;
+	u64 hpt_mode           : 1;
+	u64 reserved9          : 4;
+	u32 asid               : 12;
+	u32 reserved10         : 3;
+	u32 viommu_en          : 1;
+	u32 guest_device_id    : 16;
+	u32 guest_id           : 15;
+	u32 guest_id_mbo       : 1;
+	u32 reserved11         : 1;
+	u32 vmpl               : 2;
+	u32 reserved12         : 3;
+	u32 attrv              : 1;
+	u32 reserved13         : 1;
+	u32 sa                 : 8;
+	u8 ide_stream_id[8];
+	u32 vtom_en            : 1;
+	u32 vtom               : 31;
+	u32 rp_id              : 5;
+	u32 reserved14         : 27;
+	u8  reserved15[0x40-0x30];
+} __packed;
+
+struct tio_msg_sdte_write_req {
+	u16 guest_device_id;
+	u8 reserved[14];
+	struct sdte sdte;
+} __packed;
+
+struct tio_msg_sdte_write_rsp {
+	u16 guest_device_id;
+	u16 status; /* SDTE_WRITE_xxx */
+	u8 reserved[12];
+} __packed;
+
+static int tio_tdi_sdte_write(struct pci_dev *pdev, struct snp_guest_dev *snp_dev, bool invalidate)
+{
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
+	size_t resp_len = sizeof(struct tio_msg_sdte_write_rsp) + mdesc->ctx->authsize;
+	struct tio_msg_sdte_write_rsp *rsp __free(kfree_sensitive) = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_sdte_write_req req;
+	u64 fw_err = 0;
+	u64 bdfn = pci_dev_id(pdev);
+	u64 flags = invalidate ? 0 : SDTE_VALIDATE;
+	int rc;
+
+	BUILD_BUG_ON(sizeof(struct sdte) * 8 != 512);
+
+	if (!invalidate)
+		req = (struct tio_msg_sdte_write_req) {
+			.guest_device_id = bdfn,
+			.sdte.vmpl = 0,
+			.sdte.vtom = tsm_vtom,
+			.sdte.vtom_en = 1,
+			.sdte.iw = 1,
+			.sdte.ir = 1,
+			.sdte.v = 1,
+		};
+	else
+		req = (struct tio_msg_sdte_write_req) {
+			.guest_device_id = bdfn,
+		};
+
+	pci_notice(pdev, "SDTE write vTOM=%lx", (unsigned long) req.sdte.vtom << 21);
+
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = handle_tio_guest_request(snp_dev, TIO_MSG_SDTE_WRITE_REQ,
+			       &req, sizeof(req), rsp, resp_len,
+			       NULL, NULL, &bdfn, &flags, &fw_err);
+	if (rc) {
+		pci_err(pdev, "SDTE write failed with 0x%llx\n", fw_err);
+		return rc;
+	}
+
+	return 0;
+}
+
+static struct pci_tsm *sev_guest_lock(struct tsm_dev *tsmdev, struct pci_dev *pdev)
+{
+	struct tio_guest_tdi *gtdi __free(kfree) = kzalloc(sizeof(*gtdi), GFP_KERNEL);
+	struct tsm_blob *report = NULL;
+	struct tsm_tdi_status ts = {};
+	u64 fw_err = 0, tdi_id = 0;
+	int rc;
+
+	if (!gtdi)
+		return ERR_PTR(-ENOMEM);
+
+	/* Enabling device tells the HV to register MMIO as memory slots */
+	rc = pci_enable_device_mem(pdev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = pci_tsm_devsec_constructor(pdev, &gtdi->ds, tsmdev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	pci_dbg(pdev, "TSM enabled\n");
+
+	gtdi->snp_dev = tsm_dev_to_snp_dev(tsmdev);
+
+	rc = sev_tio_op(pci_dev_id(pdev), SVM_VMGEXIT_SEV_TIO_OP_BIND, &fw_err, &tdi_id);
+	if (rc) {
+		pci_err(pdev, "TDI bind CONFIG_LOCKED failed rc=%d fw=0x%llx\n",
+			rc, fw_err);
+		return ERR_PTR(rc);
+	}
+	pci_dbg(pdev, "New TDI ID=%llx\n", tdi_id);
+
+	rc = tio_tdi_status(pdev, gtdi->snp_dev, &ts, &report);
+	if (rc)
+		return ERR_PTR(rc);
+	if (!report)
+		return ERR_PTR(-ENODEV);
+
+	gtdi->tdi_id = tdi_id;
+	gtdi->ds.base_tsm.report = report;
+
+	return &no_free_ptr(gtdi)->ds.base_tsm;
+}
+
+static void sev_guest_unlock(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+	struct tio_guest_tdi *gtdi = pdev_to_tdi(pdev);
+	struct snp_guest_dev *snp_dev = gtdi->snp_dev;
+	u64 fw_err = 0;
+	int rc;
+
+	/* Quiesce DMA */
+	sev_tio_op(pci_dev_id(pdev), SVM_VMGEXIT_SEV_TIO_OP_STOP, &fw_err, NULL);
+
+	/* Disable encrypted DMA but the HV is unable to restart it as MMIO is still blocked for HV */
+	rc = tio_tdi_sdte_write(pdev, snp_dev, true);
+	if (rc || fw_err)
+		pr_err("SDTE_WRITE did not go through, ret=%d fw=0x%llx\n", rc, fw_err);
+
+	tio_tdi_mmio_invalidate(pdev, snp_dev);
+
+	sev_tio_op(pci_dev_id(pdev), SVM_VMGEXIT_SEV_TIO_OP_UNBIND, &fw_err, NULL);
+
+	tsm->pdev->tsm = NULL;
+	kvfree(tsm);
+}
+
+static int sev_guest_accept(struct pci_dev *pdev)
+{
+	struct tio_guest_tdi *gtdi = pdev_to_tdi(pdev);
+	struct snp_guest_dev *snp_dev = gtdi->snp_dev;
+	struct pci_tsm *tsm = pdev->tsm;
+	u64 fw_err = 0;
+	int ret;
+
+	if (!tsm->report) {
+		pci_warn_once(pdev, "Cannot accept without the report");
+		return -ENODEV;
+	}
+
+	ret = sev_tio_op(pci_dev_id(pdev), SVM_VMGEXIT_SEV_TIO_OP_RUN, &fw_err, NULL);
+	if (ret)
+		return ret;
+
+	ret = tio_tdi_sdte_write(pdev, snp_dev, false);
+	if (ret)
+		return ret;
+
+	ret = tio_tdi_mmio_validate(pdev, snp_dev);
+
+	return ret;
+}
+
+struct pci_tsm_ops sev_guest_tsm_ops = {
+	.lock = sev_guest_lock,
+	.unlock = sev_guest_unlock,
+	.accept = sev_guest_accept,
+};
+
+void sev_guest_tsm_set_ops(bool set, struct snp_guest_dev *snp_dev)
+{
+	if (set) {
+		struct tsm_dev *tsmdev;
+
+		tsmdev = tsm_register(snp_dev->dev, &sev_guest_tsm_ops);
+		if (IS_ERR(tsmdev))
+			return;
+
+		snp_dev->tsmdev = tsmdev;
+		return;
+	}
+
+	if (snp_dev->tsmdev) {
+		tsm_unregister(snp_dev->tsmdev);
+		snp_dev->tsmdev = NULL;
+	}
+}
-- 
2.52.0


