Return-Path: <kvm+bounces-64819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B82D3C8CAEA
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 03:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 638053B126B
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E03F273D6D;
	Thu, 27 Nov 2025 02:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lECe8X/b"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9299326CE1A;
	Thu, 27 Nov 2025 02:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764211158; cv=fail; b=CXGDMDeyx31FKN3bnyG8P6HVj/WUXKQhaZcV/65TCibF1vZAp1zuUyatgVT0T66BktjpUij9bw4ZNFSrgWTFNSXhzUf1uRmwkg0YclhDZP0y4CelKg125vIH59zFrZqE9NFfdQCnUdJCpctwVL8dXNrcWmcbEjkC3geOjdMi+eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764211158; c=relaxed/simple;
	bh=QeuZl6m90Jee0XNwF2tcJmsjRd0M2/KIfAqmN+OkYoU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Prewh2rQiB8DpmnzRTddUX2Zs3+pmOG/AgvTUtMd688klaTZA8OZDvlGOdva0a+dDCspdlUJ97ywWJgMTq1Xll8Go/XQGgUhuPq2KTKetyB+c3bH/W+0LImKxDJP8NfN00YCCMjjgIb1kk5uUsh2Sd1k3ezTPgWkz5dS6tmUtcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lECe8X/b; arc=fail smtp.client-ip=52.101.56.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJ+yofnIxVMbyjx19fqsubKmE7o5dxxEeyixGDteu+WK8g9vX2Vjv1XFWF8DoFjAXXeT1GlI49nR7V2TEv/H19yeL75Kq8GvDQSr+bFdsEqRJ7PHooaf+WCfnc/8FR16dJfrG6Mh78tRU46cAhXya5ClGiOxZm/CydvwNw702ERznsL/mpaOyxq27vlJ6Wya0cLx6QpvEJZj+81jrO9XxXmMM+esKN3LataW3bAy8aJlh7FSGcNEqNzoBdHfzRAjlNQcVtl2MqJpxV/dz9mAVDsg1h44igorsVurOivRLNA2G04JMev1wxB+W3T4ytP+FYL0bwu1xE+ggt8/iK/a2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeuZl6m90Jee0XNwF2tcJmsjRd0M2/KIfAqmN+OkYoU=;
 b=if2SDgOMYkDc/ZwHaQM79QAUIRrUlAt7qCsoyRgilhviEICZvaX1qOEYyNEaRFnkFZ+VzXX42g5oG0H/ub+oAwh1N9aKodRXJbIUVAC41xMtdPsvU4XlmCsxiUZvcxPlmEBjq3CiHJAtE8N3VDgia1BYo/USYeSvh86+uKlAfZRSMc+B48AW7lV1EhxY5QY4QLyzFEAMUlZX8VZdgerpGmkhzdFCmHApyYw4xSSa6mnSxmnkfw/jIxihf1zYkJwSwavRRfBpADLYLRzKAuK6WBj80ZAsquYla6dr61Nl74hYHWK0/4A+yajNRx7njLTUr+kqYEAJBx+KbwdHLN/sKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeuZl6m90Jee0XNwF2tcJmsjRd0M2/KIfAqmN+OkYoU=;
 b=lECe8X/bNwixf35188A3656ihA3ZUvbs/nWIUzlAz7IvEKttXAyOv8Zapl4tA09U1X1GIdVVzw2rjNSLTngjYiumjMxDsnK5oO/ZLC72k32+zvM2LV8xjpPO1HK3+SzQUrFMczD9QbXwitaV7hQU5h0/C6U7e/L2/mN5EELar57P72rKnkcV0QRHtGxERqUx0G21JIMmoRcwftK5uH9puzRhd7tFK6k/U5w3h/rf+68NPwlDvUvdLWCRdNkosaeAsehcgU4+dcBOM5QN+uwtJnA/1w+rwWqkHtC5AcZnMRUwPFdGF2hT0jjz+rmw1dGji3yp2kXN4rK8OVNMeqzURQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BY5PR12MB4242.namprd12.prod.outlook.com (2603:10b6:a03:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Thu, 27 Nov
 2025 02:39:12 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 02:39:12 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi
	<vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "Yunxiang.Li@amd.com"
	<Yunxiang.Li@amd.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"zhangdongdong@eswincomputing.com" <zhangdongdong@eswincomputing.com>, Avihai
 Horon <avihaih@nvidia.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "pstanner@redhat.com"
	<pstanner@redhat.com>, Alistair Popple <apopple@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi
 Wang <zhiw@nvidia.com>, Dan Williams <danw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>
Subject: Re: [PATCH v8 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Thread-Topic: [PATCH v8 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Thread-Index: AQHcXwrxiMJkjfo5a0i6wu6p5PYg5bUFguGAgABM10g=
Date: Thu, 27 Nov 2025 02:39:12 +0000
Message-ID:
 <SA1PR12MB719964BD04F7DDA29D570A8AB0DFA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251126192846.43253-1-ankita@nvidia.com>
	<20251126192846.43253-7-ankita@nvidia.com>
 <20251126150323.3b39e1f2.alex@shazbot.org>
In-Reply-To: <20251126150323.3b39e1f2.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BY5PR12MB4242:EE_
x-ms-office365-filtering-correlation-id: 847c5468-c4ee-470a-5bdc-08de2d5e261f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?CpK7/0BWQYvNAmivPXXtxZgundUd9cAZV1Y3janUi44C7SnhCCgKZ+zJxe?=
 =?iso-8859-1?Q?BjJxMCltwkM+Ly08UhG6fZqJXGhtVmGsX+BTkkQ9ZovCQ3Gy9X+rizYfFp?=
 =?iso-8859-1?Q?DiH7iYpLglF5pEg2R16Hkmq6/r74qjlpe0IDDU3kW2Kilbp7XU4gsExSZZ?=
 =?iso-8859-1?Q?7P3shiX2NiZ6YkH3m/pC9vySLsJZG9uITziMYvODjO5uPDjJxGBMGpiQ2J?=
 =?iso-8859-1?Q?4bBSmd2/3GJdzRdHGmT3xnYWSyqQ4CLIpiQzDclT9niRlUalgkQC8UdJQZ?=
 =?iso-8859-1?Q?uledjSsC1CBtAdlk/2JeiuMX1KT5Crwu6lsWGWigJlWUrbli+4tDBQcury?=
 =?iso-8859-1?Q?SFsf1caQb3kHR8LwHg+1mHYOUD1LITrXk05k5qj0Fv+G77C3aD20HbQGgA?=
 =?iso-8859-1?Q?mL3M0bt6wDasDLJ+yTAWICiw0LBlLVLJgqUraMYWgO7Rj8tP12fwdf3bth?=
 =?iso-8859-1?Q?XM53DcZt4U7WI1bPNLmB+ZHDx55WCC5NU68CPcwNrcvrnZCobdGBlG3EuS?=
 =?iso-8859-1?Q?dmmt+jnTT7B8zRA3tBt/aFeTAgEc8GihtY/FV8EE2V93Yh0XfB/BPbt0hP?=
 =?iso-8859-1?Q?DQIMLuFrmn9al7g9F/L5t6AK8vIShqzcPMaltEvw+F3BYSv9SiX/cnfoo8?=
 =?iso-8859-1?Q?Hzn+/kAmKqKn40CO5p5Kg+L9Cy01Zeu06AWNAgkwEvN+ksaNfvwzqNRXp/?=
 =?iso-8859-1?Q?wsn0GsRjrW26WuhNjKhUtdRPk7+AUjFIrt6mu+BhYLO9QV1PoccZEC5nUL?=
 =?iso-8859-1?Q?9N3BOYmL0wKUiu7V0bbrIc2FbkNtoKihG1qbksbX51VJvONO9Ik0D1WAm+?=
 =?iso-8859-1?Q?OUe8qTl0uJzzuTJfy9CNIjEUQX0lHfORFwTRRAbxbodqsiHoTyiK+p008m?=
 =?iso-8859-1?Q?JBf30tJ7A5SIWQKlDtEshNAZLO++BHelo815H8P+V7rtQbFC0uvBUXUOyH?=
 =?iso-8859-1?Q?MU7s9WgCuzUZRxYEjgumxdSVKb/XK32s+q8eXul6jBF/fNv+u0Cc8KQEWv?=
 =?iso-8859-1?Q?t71BjRT7ecF+/2/AiQS1JGlIQoxNSJduYQqomFZkzcbDKgECwXlRf17u5C?=
 =?iso-8859-1?Q?eCGp/4r+DgKyalw+xuv4U2rMqKKC6cuiHB4CPPNCx8JXZYZCTOUZdm6ch5?=
 =?iso-8859-1?Q?hR+BwnvzggoA5xeWBew7F5njmXFPGQ5NSlsiHWFZKizww0mjxsTUutGI//?=
 =?iso-8859-1?Q?qaPoIvb/hG3/Cn0hQR6RAcV7pxQaqvfyBloFg8eV4DNn7sXNzP0Eav2fHe?=
 =?iso-8859-1?Q?3KEvtC04DBavrKyH4rMx+kFG0kxMA29B9hZhYnSQxB5Siu+eH73V1Xt9D8?=
 =?iso-8859-1?Q?G3BffruzbkOxX2C/7auk2z8J1Pb8OORZvTYczcZ5d5taH2oSSe4RgkxLBg?=
 =?iso-8859-1?Q?g7PfNVJdmiTbxxd4YQ2Z+u1jkjNCBlKR5TfoVgQU1nP+VxnEGhlT7lTxbB?=
 =?iso-8859-1?Q?jrLIT4pnBu8CQjiFqu/32rloRM6uOFaancHdt5v0WDWbqIs3bMWtI3bmCn?=
 =?iso-8859-1?Q?TeLFPOPVjgYLRgblQY6hHxNlfidHc9+WABa+B91ptEzNP3woJ8RHyxv61a?=
 =?iso-8859-1?Q?oPdXzM3XbVxBQWqpA+SLEYl2vQ/H?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3OQXCaz92g4QumBNbytiADdB1hPkL8lcMMyZ5j2SXvYD77rt2GEUdmW6+V?=
 =?iso-8859-1?Q?R4CQTkj0NINKxM6/MDa6D8r2u+wa1D+BFPBFJJ2hu60Ko6BFEmGapnifdz?=
 =?iso-8859-1?Q?24sC9wWVbnpJkq7DDGScG6eOKi2knOUVf/SqiqLenD8Zxe27K3alNwuf2j?=
 =?iso-8859-1?Q?y3n7L+A8EPE1ScgW35FaZJSdOp4M7PeCVjuHfhebAo2BMcmlsk8uWy8aoP?=
 =?iso-8859-1?Q?FckIIjKwuHqP2z0Ry7O0ZJ5wXlvznwfqUqXuORrI1ju1yyCVr52tLC3l0X?=
 =?iso-8859-1?Q?37I6proQ5D3sGNbZM2mpwaibOCFve0gRwDnGMMsk5w+ZwzwSorM5x9AJXz?=
 =?iso-8859-1?Q?Gs9EQT3xAmmKlqDVS7AJNVu0bl3idfej8JN/DFsA2/dafIGpqLc9Oid78u?=
 =?iso-8859-1?Q?OYKPJM7tQ+fRAtft+PuEKqTSCREwGCXEPMMGcCUoSc7DqEvSCpg8Hu75Wd?=
 =?iso-8859-1?Q?gSdZCS15xhEaDabaGKGWje683Axa8H05Hk0wclYzEsNJGgoucvYh840gPq?=
 =?iso-8859-1?Q?LdIXXNpbd5uyxODxXKdw9QV7Sqpyf0M/lu2jEkgUcCFVRsTRRHTJVqG2Z5?=
 =?iso-8859-1?Q?xzs84rT6SHoxel0xW4ROCZH8qDozHD7O53CkWXIRjiFvH3c34biw/0ROG1?=
 =?iso-8859-1?Q?VmjwKL95KzHYsmE+ywLLSZ8lH1qW/8NcUCveDC25zpvGEyfZkalQSzH/6R?=
 =?iso-8859-1?Q?Xg67mLHAD0ehkXJapbHDHug1/irZS/uaxcTTpCwdAfuXI1l063qwCh09kH?=
 =?iso-8859-1?Q?OjTD3El2SMf1rXa5qWjLT5LgdtBfpEQf90c7QaympCugV2xcJaIpU/IRQB?=
 =?iso-8859-1?Q?0WH7uM34q20l7eMwbhTtfdt9aC1fnIMoP4G5xog+gCv9IBPgx/s4i3YVh0?=
 =?iso-8859-1?Q?aBHf4Nw8K5ED+5jfshqqbdRYTWMGJWkEJBeMc6K5CvxXhm773lv7nMETny?=
 =?iso-8859-1?Q?5nTTPc4VlxPrxuYLJJmZadMpewRCp7Poc0kmlvgBqEr0F5+4gDgA9Kaxxg?=
 =?iso-8859-1?Q?Fjyl9pzRoeIelzwOwz/sAKceQy/7AWb9OI9nQgVydXxDVSVb7kmwoHNd0i?=
 =?iso-8859-1?Q?UAOHQZPMNkVDB/90RMKIQO5CU+c3VHhXMSIX6726fOaS8S4oUSU5Uwjw9N?=
 =?iso-8859-1?Q?RwOb/84jUhrTB9bmu4M87fvlbvAZjOc+GPztYw08nLXNnCceh60zh/c+50?=
 =?iso-8859-1?Q?/QvKMFRJp/doLdIuKiMzrxlKreQOdc8HO7nHnmLTGAuHhAWYNEmEnlZSMw?=
 =?iso-8859-1?Q?0fXNNa9KA0PjDn67HKZLpRbHFFIHa+IRQxIIPqj83jJkqh0YKZFMWVtuok?=
 =?iso-8859-1?Q?1lKrTwEBGF2brPpExsE8kKX97LsZzlvL7bd7DBtdEJOhXRTNyWuDeP/E+j?=
 =?iso-8859-1?Q?S0fmlPfJlaJ6gG4chmwHFz+1BBRCn16ETsdxfvzL2+h6EVLQ20/LZlxiqA?=
 =?iso-8859-1?Q?WNhzf+KAVgNuwcHGjvuuvIz1vNwWFodFIwOWneYR6THrO1IVrrNkFkEUlV?=
 =?iso-8859-1?Q?w7B87U5V8ZhoDSps2zIlbrLRqGwFCwR40VNluJqhqSRu0e7G8OGp9EGU8A?=
 =?iso-8859-1?Q?T9KuNJoUNLfi93x4IRjC5qEKG9/X2PDGRy1Ugty257EA1hJKpJ2unZBpxk?=
 =?iso-8859-1?Q?BqaZQPLA5/+wSGmmWB75L7J5yn9ZRLgXbJ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847c5468-c4ee-470a-5bdc-08de2d5e261f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2025 02:39:12.2739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuGO48O2ExFDtP7hqhQvBbJqoIc2D3NLmq97QSAbeWSnarR3GUOI+jSZhy65hJ+FhJy9O/HhmQ44P/JywssAyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4242

>> +/*=0A=
>> + * If the GPU memory is accessed by the CPU while the GPU is not ready=
=0A=
>> + * after reset, it can cause harmless corrected RAS events to be logged=
.=0A=
>> + * Make sure the GPU is ready before establishing the mappings.=0A=
>> + */=0A=
>> +static int=0A=
>> +nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device *nvde=
v)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct vfio_pci_core_device *vdev =3D &nvdev->core_device;=
=0A=
>> +=A0=A0=A0=A0 int ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 lockdep_assert_held_read(&vdev->memory_lock);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (!nvdev->reset_done)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 ret =3D nvgrace_gpu_wait_device_ready(vdev->barmap[0]);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 nvdev->reset_done =3D false;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 return 0;=0A=
>> +}=0A=
>=0A=
> It seems like we can call wait_device_ready here, generating ioread=0A=
> accesses to BAR0, without knowing the memory-enable state of the device=
=0A=
> in the command register.=A0 Is there anything special about this device=
=0A=
> relative to BAR0 accesses regardless of the memory-enable bit that=0A=
> allows us to ignore that?=0A=
=0A=
Yes, it is independent of the memory-enable bit. =0A=
=0A=
> If not, do we need to test before wait_device_ready, such as:=0A=
>=0A=
> =A0=A0=A0=A0=A0=A0=A0 if (vdev->pm_runtime_engaged || !__vfio_pci_memory_=
enabled(vdev))=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EIO;=0A=
=0A=
No, it isn't actually required.=0A=
=0A=
Other than that, Alex would you be able to apply this to the next branch?=
=0A=
If yes, would you be able to remove that check from the common code?=0A=
Otherwise, I can send the update to the first patch to move it from the=0A=
common helper and put to the vfio_pci_mmap_huge_fault.=0A=

