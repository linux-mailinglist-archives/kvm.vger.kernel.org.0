Return-Path: <kvm+bounces-30120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A45E9B70D4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E46D1C20E12
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 23:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927331E2835;
	Wed, 30 Oct 2024 23:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UXnc4MtA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57279217644;
	Wed, 30 Oct 2024 23:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730332781; cv=fail; b=rII7n3UM8cbmp1PjnuhzEzStegYnxiBHuKdEHHE/90BhQcduibDcjcgtEfY0+viIOVLLrQUKbyWbkAmlLklUZ33DCbVJr8G8wTj8Pu1HPNcJzXt6Y+L+PAmnWJaZFpT7hKcKGP07nkbwqAwx2An/YxGj+uXXZhnyKrrHBRrqDws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730332781; c=relaxed/simple;
	bh=fHCI3Ocj0rV5iHfpuq16qj2jgLXjEr3yfv8ipfW0IAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N6Pa2VZzjqKpIpif0C+20A1LnbHgU2clQAkBHG6XAOU0q/gdl2184ZDKJOC4C/n9w5Ufz8ZuAWli93OvtBAC9nuPWNyDFhEHxKBu9pt3QHnTWS9tpqMHV5OJfOwAEIK4DX5ls83/3lwOlZF49XsAglyQ+8hbMvzXwGpu9FXC5fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UXnc4MtA; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kPNFXguB1T8tS7u6wUjs3le0wc/hebupb2TlrRdJVvrG71y3o73qDoPLc/Ufq6To6ep+gyzWnSxpPMWlavTCIFPrRvfnIm1MmcRFnyKRs8llM5bnwBCYyoYT1ctO+uMTebs4nXGfk3bnYit5nZ2/IznWpsx3LtLHO5VEEkuaPlfaTu34mPvPSidsElGA/5U37+2tI4psaMRW6Tp3uhp1h2JHvwFOe2HTyvN3e/2UaLiGFpD+3DHXtVHVSDNKBp7Enni219q30gyDRBCxcCZU91namKiRnnh7L3pjZ42svgoDK/RWpjPenEzuXEX4R4jJrWIwLpTq5P2gBQjtW/q2jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rd21NbHr3F25lFWb2XNoZ6xEYLYjR1AM+fQggdYMGQ=;
 b=f6Lr0KNfY8mJ3ZobdtGV6FDNAzHTokn3CfBwQRMTJmVyAPtjnjpgOSH7kE+hUp/4BzB/x8i6BZLS7x1PyEwioxA2lUR8g1gDZcGqHVodp+9rh1w9GQE3XUS6zhv2s938uk1qHIgp3gseQegFI+1XxIMqjZeth+7jPdwfYQjECeDk62D5Ip7DpDoeeMS49OJMj+fTyrJUj9K1kBl22aRdRLEEeq48Y+c/N4i5RInbXXR5jGRDNhuTZKn2qop9mWGyr2agY33shK3QW6Fcnp8coYymiHDSD0nMiLpKWCUVddJdUOXZW3t0ljyNAIBqQNpc/ptc/TyvnV+DHaJAsuMKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rd21NbHr3F25lFWb2XNoZ6xEYLYjR1AM+fQggdYMGQ=;
 b=UXnc4MtAring2D/mUlplioeBOoNlmzZqsr9Hx2Ha2hbu/GjuTJWX9xX0tPzMqPYSJBJY9zZj+fAKzSMfRIUH8lM9CtK4vr4HEUdLPVsQnR5P0RzVK8Z/3/iSyjocEO+eroMkLc8Ay6Jq3xO8H8PfvM7SlZ6GWpAI2eWEIVfR9ip+vgQkXG9mw4dBiPXsuNLFsMLZy0DH5NLQ4RoxE1g3Rkn/3rO5PFMyyIStOdumuuFot3QRvTI98oAwOnZPnZGclXeYoqykOCo54Uk+EghCc1B1JZtVczFv/ykijE9FgJnXPD5GOmAQHXqQzYoCWOsv+lYV8u0RH3J5aJa4qWxGFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB9148.namprd12.prod.outlook.com (2603:10b6:610:19d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Wed, 30 Oct
 2024 23:59:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Wed, 30 Oct 2024
 23:59:34 +0000
Date: Wed, 30 Oct 2024 20:59:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20241030235933.GA8813@nvidia.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <ZyJe5M4_DHl37PTr@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZyJe5M4_DHl37PTr@google.com>
X-ClientProxiedBy: BN9PR03CA0778.namprd03.prod.outlook.com
 (2603:10b6:408:13a::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB9148:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a2315d5-ba7f-4a66-4033-08dcf93ee752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0IxMEphN0JZcldyN1FvQmJFdVdNcmh1dlNLNm5EWXhSb3A4RU5NM3JVQjhi?=
 =?utf-8?B?a1k1MTVIRXpKRm02YnFVUlNMRXNRbzAxSEJZWWZES0tYU2pXT0dXVTh2SE4x?=
 =?utf-8?B?SWFENThRampjRUFFY3VOVld3eGJYMmZVVHZrSFBCcC9nUnc1aVRhV0UveGxX?=
 =?utf-8?B?ekpqWGJVbXhLdEpqNlp6RHJQTC8yNVc4aGlpSW93ZGRXK2ZBQUJGR0Z0bFJq?=
 =?utf-8?B?enIvV2hKaGNCV3FyZHRBQndFQWU5YTY4V1gvMi9oMFBDekNiY0NibDBrUVA2?=
 =?utf-8?B?ZGhpVk1xU0VxaGZRVVBHbEp4bkNjL3U4dWFwNnZKR1pZcDQ5dTgvR21mQ2tq?=
 =?utf-8?B?SjIvRTFiQkw0WmRGWDd2UWltd2o0SXBlcTFzSWRrUWVpOUNRYlFvWVZwRkFG?=
 =?utf-8?B?dmdXbXdNNzU3VHpkZ0dLSjQ3emxySHdsMzU1cEo1L0VyVEwwUUdJR0hWbDBL?=
 =?utf-8?B?RjI0UkxJYldBUDRZanRsekd3VU0yN0RLQUxIVXJobWJ5ZzVYSUtUK2NUODEv?=
 =?utf-8?B?ZmdqQzB0dzRTUTRCYVE3S25jMU5OcDB2Y3M2dUJRV3B1WFdOZUQvK3F2MDlJ?=
 =?utf-8?B?NzZNMXlqbWVkK28zUm5FY0RhQVFoQVRwVlhxemF5OG1Ya204SndzU21FOFRv?=
 =?utf-8?B?Z2l4eTlSaFREN28rK2JHSG5rejg1dGNJVFJxQU01Q2VTU2FoK2M1dW1QS3ZK?=
 =?utf-8?B?MFVKUms2bVdEanEwcE92V2FmdnB0T2x1YUV1YytnM3hyeWxKK3Y5QllrZXlN?=
 =?utf-8?B?TmJXYjNDKy8zclI3SjY1cHNtUm9BZHlYdGRmWnM0VDN5d0FxNURxNDEvTGRv?=
 =?utf-8?B?ZG9MNDlLYkpUVnB2MExiWmxmYXhUSVhYdjRsOW9OY0lsdC9MWG5TcVA5NG8w?=
 =?utf-8?B?UmkzejhwdkY0UUFyL1ppcWkvVUZ0KzRrenJQYXFlWUpWaHRmcW5WRjBYMVM5?=
 =?utf-8?B?QVRxWTRqbzVxTncxd1lLYlZDbHhWaCtKc3lLcmNPbE9nMjlkNE4xUysyZTIw?=
 =?utf-8?B?UERoOWFqSVUxYnE0UitIcmhxdlQzMlNSS0dTRGJHUmxoRFdwaDNpN01RZlBl?=
 =?utf-8?B?MXd6WU5pTEVXZGJzMXF6b1BmQ1N2WnlWR2NDQ21BaXoyaEROTUduRWt0Nlgr?=
 =?utf-8?B?ckFDRmhGMC9iZVFJR1NGSVFLckg4d2xCYVZVeDNHcFN2Nk9HdFpkSmVaQVhS?=
 =?utf-8?B?T09DS3NkbVZVcXNhbW9jNzV6Ujltalg4NEJQbHllRTQyNU1oVmd1bTlyTU5N?=
 =?utf-8?B?V3JKYWZraWdZN3BEL2NiTGFaTmRYbHNUWW1mZzUxUkh3bjNtQmJ1M2g4VjZz?=
 =?utf-8?B?RjMvcVFOTlVySG1lV2kxL3E0K3Q3K2orNExFZk04Vm5rUjF6S0hlaVc5VEZQ?=
 =?utf-8?B?V1ZnYnMzeWE3QzMzNGYyZW9hekdQSlczYkU2TVRYL2Y0Q3Zxd21ER2I1L2dx?=
 =?utf-8?B?WFVxMVdLRzRJbXVKTStqNWdjK1dzRisvQnQyL1ZNL21ISzkzV0pUTFFTSlFM?=
 =?utf-8?B?TFJjV1FRY0tzek1qWGFZekZ6bnRTSkFkYjUyYWxReDE2WG81ZGY5bWZzdk9Z?=
 =?utf-8?B?anl0TXZXQUZyd0tNcHZYUVBmYUdVZ2VqaUV0ODFnT1JSYzNRUEhwcDMrRXBj?=
 =?utf-8?B?cms0b3psV2ppUElMVFJtcDg1SlM3Yk5UalZBNnJtWkc5cE1WZjJId3FJQ0M4?=
 =?utf-8?B?MHRZbVh1T1pYZmJmc1FSZERXdjV0QWx3K3RVVjJ5L0o3ZmJ5RG5QYUpOQVBn?=
 =?utf-8?Q?6G/7e9DUSNXgI10tLhjaj2AzhOe1CAV3aPe1Gc2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWtRSVppNU5WVHZPN0hyNnQrc3VtUDJOai9mOUhtNks3VXBlQWduakxOU0l2?=
 =?utf-8?B?cWxiNWllamhDSGRFMEorU08zNDNCOUVqSHVycEdCSEp0d21hd2puakYwYkZu?=
 =?utf-8?B?bkxJbzlyRWErejFoZThrUDc5eTF0dzlydU9CSExNTVl4VHZ2WmswbCtKVEtO?=
 =?utf-8?B?aG9neXplL1pGRzBqekw2ZXBqUzhBYVpVcFE1UjdrR2ZiRElhRFpHMEVESGxx?=
 =?utf-8?B?MjJlb3VFU2habUlya24zRlFRNjFrVkV6b2daTFJmWUp0aVBXSy9hN3huY0Y2?=
 =?utf-8?B?T1BEWnVHMERxL0NsYjgzZ3JUQzdHdGRSSHYvclE2dkQ2WEtMelAzK0srczE4?=
 =?utf-8?B?Zmc0OG91bTB6WlNtb0doSnhmQ0FneUU4bXU4YnVuZ0FjTmloVzhCU3kzVmNR?=
 =?utf-8?B?NzRrM1h1QkQzSXhFTjc4SzRmYVJuZzRkYStxTEdmNk1iY05yRU5UZ3hpb3Ur?=
 =?utf-8?B?OWJrcVQ2K1FRR0VOYVNXTkJVd2FoalRrVFdlTTVhR29hRTNvemVhVHl2TmlI?=
 =?utf-8?B?SThLLytuazZqTnlUc0xwZ2RkYlRIc05tRGM2Tno0ZTh3d0VnUjBlTHkyUHNr?=
 =?utf-8?B?a2g2Z0ZWRXB6TzJyc3cvMmFFeFArdW85Vm1lRkJEMnQyYjB0SjVTOHhKdkll?=
 =?utf-8?B?UXNmT01vNERBcXpBQWhNS29jUURVVVRzV3pjWW5aNHF2YTV0VzZOdHRwMlNC?=
 =?utf-8?B?eXBUa0tFYXVLemNKVmxLKzh5SEFpY1lJU0pVd01VVHdtRDRhV2sySmVnM2dk?=
 =?utf-8?B?Qmp0QjVad3U1dlh5Qi94eE1teStheEUyb1FiZVF0MnRRWnJTWXJhdzdYcDI0?=
 =?utf-8?B?VXI3TnZNWXE0ME9iQTB5b084REhENWxka05WNEZhcWxWUElja29yS0ZCVWd6?=
 =?utf-8?B?dUZPdWRxM2R0c1dUSFRTNGNXU2QzbENIYWdoekZGSmZaWjJNWTVNZWtSS29Q?=
 =?utf-8?B?VngxWGxXNlc0aDF0eGJQWTFVYzQvWDdqQUVzbllHZnFZS2hTeTdQaTBXc0RH?=
 =?utf-8?B?enRZOFdJMmtIdVFxWmQ0UXpmMFdxMk80U1Y1bWplVE9sdzhaU3ExQ3BRRVhi?=
 =?utf-8?B?NXNzTzBXL1d4TlVjdjZwQW5KQkdDSkY2VDV4MXc4dkkwTitTMEt1KzZIVXhp?=
 =?utf-8?B?aXdrK09VM0ZtQ2xpZE9XYldEMVZORWcza1JQVUVMTGQ4M2IyM2RKNk5TVHlK?=
 =?utf-8?B?eXFNd1EyM3M5c3NEazh3aC9uZnVSS01JMGZTWFdnVGtITFd0YWdmRGdtZ2JJ?=
 =?utf-8?B?YU51OXk3aFUrTnlCV2JvdndERmFSdTlyNnhlTmJFa3VpV2Q5Y1B6b1NSM1JQ?=
 =?utf-8?B?L2JYTFNZNE9VVlU5aHlVRFdyNW9ETDIxNFo1QkdUWWgxSUppTTlkdDhjZVhV?=
 =?utf-8?B?Nm8zdnlxVC92RmdwVXRoMkJXdURsamhLZm9VZ1dObTN1d3c1emdFTmhEWDdx?=
 =?utf-8?B?Y0hnRXRUdmJRSG02WkFMRWV4SXArV3l5OTdUY2xFdXVzaHFhaHZuT2dWZmMz?=
 =?utf-8?B?Ky8zVGVmSmhJYlNPZkxGajFDUi9PZnpkUUovL2hvWkozM0ZrTnJMNXg2TDBW?=
 =?utf-8?B?emhrZGEza0NuWkZHOERmanAzeW9aRWNBN3F0RDlEdmxpdjZ0S2NQYW5TS1FN?=
 =?utf-8?B?UEdTZHhXa3g0YWRMVEwzNU1nNjRVeDh3QUttKzJ5WlR0VGEyczdQYjNDM25S?=
 =?utf-8?B?Ti9FYTlranErNjhnUmVYWDViQnNONzk0MjNra0pHZmtHRDZFalZOcktmeEQ5?=
 =?utf-8?B?L01raDVqeUQ0VjF1YWdGanE2djFaZ1lXM0lJNVI3UVpiTWRkU243Z3ZNL1Fl?=
 =?utf-8?B?a0dKVDhBamVqQ0FaWXVOb2d0eWxMVHM1ZVZRZ0hRbkZwdGJPUGZRY2lSSk9R?=
 =?utf-8?B?UnNyNk4wNVQ0b1l2ZG9IVW1SQ2FRN0hZbTBHNld5dHd0K280R0p6YUQ3NEp3?=
 =?utf-8?B?OWRnSVhIUXdjcUs4WC9JWkREM3pKWTBDeEdWWHNQZmVVQW1tR3NIRm1HTDBt?=
 =?utf-8?B?V0RjbnhHVjhmSmtiWXlHOWt2WHAvSVB0cFNUOGlwdDI5SThPTm5oS0UwZ0lq?=
 =?utf-8?B?bUtHWVEwaXNsS3hUbkZCSHpLalAvM3IreDdvS240MGZzeDNBZmY3cFJmdm1V?=
 =?utf-8?Q?QCvCJxv5mFX/E201oF8nNenP8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2315d5-ba7f-4a66-4033-08dcf93ee752
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 23:59:34.6816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmlFri/e6NSGKpmjgSuddMPBBKvq/3HS+B7rgt6ZkYWDY5ea9gWSg5GteEq/t4D8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9148

On Wed, Oct 30, 2024 at 04:29:24PM +0000, Mostafa Saleh wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index b4b03206afbf48..eb401a4adfedc8 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
> >  	case CMDQ_OP_TLBI_NH_ASID:
> >  		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
> >  		fallthrough;
> > +	case CMDQ_OP_TLBI_NH_ALL:
> >  	case CMDQ_OP_TLBI_S12_VMALL:
> >  		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> >  		break;
> > @@ -2230,6 +2231,15 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
> >  	}
> >  	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
> >  
> > +	if (smmu_domain->nest_parent) {
> 
> Do we need a sync between the 2 invalidations to order them?

Which two do you mean?

Yes, we must flush the S2 IOTLB before we go on to flush the S1
ASID's.

But __arm_smmu_tlb_inv_range() calls arm_smmu_cmdq_batch_submit() on
all paths which has a sync inside it.

> > +		/*
> > +		 * When the S2 domain changes all the nested S1 ASIDs have to be
> > +		 * flushed too.
> > +		 */
> > +		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
> > +		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
> > +	}
> > +
> >  	/*
> >  	 * Unfortunately, this can't be leaf-only since we may have
> >  	 * zapped an entire table.

Which was already needed because the lines right below are:
	arm_smmu_atc_inv_domain(smmu_domain, iova, size);

There must be a sync between IOTLB and ATC operations.

We also need a sync between the ATC operation and the all ASID
invalidation, which the _with_sync() should do.

> > +/**
> > + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
> > + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> > + *
> 
> That’s supposed to be stream table?

I think when the comment was written the only option was to program a
context descriptor. Now it can do more.. Let's try:

/**
 * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 nested STE
 *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
 *
 * @ste: The first two double words of the user space Stream Table Entry for
 *       the translation. Must be little-endian.
 *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
 *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
 *       - word-1: EATS, S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
 *
 * -EIO will be returned if @ste is not legal or contains any non-allowed field.
 * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
 * nested domain will translate the same as the nesting parent. The S1 will
 * install a Context Descriptor Table pointing at userspace memory translated
 * by the nesting parent.
 */

Jason

