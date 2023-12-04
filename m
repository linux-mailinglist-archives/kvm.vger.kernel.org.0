Return-Path: <kvm+bounces-3383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 310C0803949
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B5F8B20BCE
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34552D054;
	Mon,  4 Dec 2023 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tJ1a5QNx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661DEA9;
	Mon,  4 Dec 2023 07:56:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ja8dgT97E9mvt2gcX0QXZZ8KovYEfEMpBGgMbR1/3krbXXMAKVDlNN9yLZCH3Gzw44JvSWn8l07Ces2ZKK0SK6CinaJIHVsMRAer/LrTYCl1PYJGrV5Sw0FKv2teQPV6yIJ6OuA4P49NL2NMVb/aI56HCk/trqq1niSUj/ld2xT0380HzR6JhMbZIr15MixGAFhGbaApPxpVVK64N4PW11sWuvO/m8O2OmI7tCEJa9Uvq2mw7As8dVvXRFmKUUHPuvU4/NsSMjkAFL29Uy80cgnEy/DR9rM+mprMabxCBIYNVuaWI0C4HeOOFIOG6JGwiGFlUjcKkvCQwCcscQXIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyraeTIiq6h2e2IZQqL6oa61V9G8TyRjdOYHCSiyt5Y=;
 b=lb2Y+IW+ULBwA9R4S1/0KT9glssammWVI3uS/tWWuqw5ZX3lWuHq7gS2iBTev8W30sqEvMRffgThF/iGslyaDpfIupWNuB1YuzqqIcWXmDv/YnzFlcpLTqgRwMGLvn5HMB2DemgdtEkHapV+z1LwL4rQNA013McODy7gAxpWm85GKbuyYdJRRO7sx9XMw+lQyNC9HN5lYt2cBAO8KoIpmjccKLT1BD5uOB/kdO/fM3DG7X0mfDpvYkMRqyNQDgLAhSLDJterFW7ut8+vwg4Th0ZtpbZi+Dnp9l45kTtJpgeQ7uqxfCpLyshPw/AfnF0ybaWuGD2yMS1hOyZ6v14Odg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyraeTIiq6h2e2IZQqL6oa61V9G8TyRjdOYHCSiyt5Y=;
 b=tJ1a5QNxkIXQXWnTfXeB00MRIhhSGeOmB4Pr3DCluQDTpsYnk3yUyHb43hFu61UWHilJt8f1edvDSfzNFOYdQ6UYFRYnzxWuTzCR/rqCLslStjN52ilamqRW5XqZKUFf++xzaVXMBjcutn10T0C0IQQPuJ6nPfgKa2fzNgUGvLbWBtMa99h0aZVTvAYje46Kme/YXEojXw4G2oWQLxjyDGwgqsUXvtpifVb+1w6slwbIoQrQMokWtyNJD4t74+3dCwADFuPelOFTwjEXW0NDbeOeSkVbZz5tmUt10x10adBzOT9vdRHFylnfVdLwfvo1cnjAbV1GFPu0+O/Vl0GY0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4284.namprd12.prod.outlook.com (2603:10b6:5:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 15:55:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 15:55:55 +0000
Date: Mon, 4 Dec 2023 11:55:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Borislav Petkov <bp@alien8.de>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"shiju.jose@huawei.com" <shiju.jose@huawei.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] mm: Change ghes code to allow poison of
 non-struct pfn
Message-ID: <20231204155554.GG1493156@nvidia.com>
References: <20231123003513.24292-1-ankita@nvidia.com>
 <20231123003513.24292-4-ankita@nvidia.com>
 <20231202232319.GAZWu8Z6gsLp1kI5Dw@fat_crate.local>
 <20231204143650.GB1493156@nvidia.com>
 <20231204153646.GCZW3yDgal3gztpDRY@fat_crate.local>
 <BY5PR12MB3763A85483534C7FD50529C8B086A@BY5PR12MB3763.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB3763A85483534C7FD50529C8B086A@BY5PR12MB3763.namprd12.prod.outlook.com>
X-ClientProxiedBy: BL1P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 0368f6b9-772c-4698-d8a3-08dbf4e17fba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zf5EiCbQsqm1+6JnQlRAx2Hvtg2RI+n92A4ECpJE1eQXCNOJcRggRzkqDszucaLJBdD+4z3ktnmsIusUszwWJhgeldafC5VkMthfMMKNqH2gu2WQ/8d11SGJJxo/etbyavjBLb3m/75+1nrM6L8Guh1ExmLkkQ4PDO3lG+sqydP6yjhbR35lLuNnGv6AztRvoVgdvdIqM6VcqWZ0XcTJnbj32PCVSBug1WvP5AT/XO1p1FHnbL0sYys8tQx/PGFoyVfgsHstVr9TQDQAPfh2Vrp56LJP+tolYfBiDqtlfwVI8XLXDM616LjxYxh7Iq9AVXCE81OxQbconcRVBq3KzqPYpF8+y6AeHNZvof4akKXvH3rWztv2Vm+cT+fZL1+aEcX+blB0zeJ0E0DpXMYfLwr7de8ZWGvMw3XLlmMRZSxRq57dIr5qKYOPBcz9wfcHqMKDNQ4/2OOf6jEg3hpjDuqIifC5oKavSxekTHYSZO9vyMyN+azhTae+mPLL4KW/1RyYrtEPIgALpF7nIxbkJbZZGjOk9dBrrUmJgqTuOlxyhXQ2TJQMRmXzpFnrwL4J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6636002)(54906003)(66556008)(66476007)(66946007)(4326008)(6862004)(8676002)(8936002)(316002)(37006003)(6486002)(478600001)(7416002)(4744005)(36756003)(41300700001)(33656002)(2906002)(5660300002)(86362001)(83380400001)(2616005)(26005)(1076003)(38100700002)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eAQ9SsW8FRgGNa1V1JocLYek47KJQCqLVGM9Mp/WyeIbNRXBSaK1A9/23JJL?=
 =?us-ascii?Q?APNQQ7kcaC6Tcd9SGS8hnumO3TFob6PmxGKp5XKsKu6LgsdvJrobFdl/VO7q?=
 =?us-ascii?Q?duBx8zk+hEG/hYHMYGFR/60mxLmaVQfDTMf0J+bdL508NzRNZh0JnbixIIjt?=
 =?us-ascii?Q?RKOOKGp/0rp+FkdLrnpFcc75IS+/LQNz6Elf/8v+GhT0acovB6GXfKPiH7Zx?=
 =?us-ascii?Q?RzkIvNW6+Y+ypOh52zROIq2XwR+sChaqE8kfBrGsdHtw03KFrvAaA28Fj2wA?=
 =?us-ascii?Q?v6FqHLHYBYMde8MFdAYMi1qd+0S84tEtU7pcNcO0uOLd3ieZxsZQSpO28/so?=
 =?us-ascii?Q?6JWobDGpbs6R5g1UZoIs0b0+3Vz5q8kZhEZJLq5fV/Cjj4ANcwkBjhQdjyW4?=
 =?us-ascii?Q?/YslVi6Wh6Uo+dPuj4fi2U+wmAx+wsGPqM5SLrR53GbFSLNfv3kl1ovvpmQA?=
 =?us-ascii?Q?T4U3NP7rnTuS9vOx7mk88KUSHc0khq+tD4BB4rQIs7GOgeGCQN6/kZh2dkpq?=
 =?us-ascii?Q?o4cuZv7lhSL6Ivp8kFUPGqaZW1NuWDL3aiTgcpJCfR96HQi5vfb2hIuAfkl/?=
 =?us-ascii?Q?ty9MNzbc8RYT7Oqy9hOUBCxwxpvLaNBRD8cU0U3spe2w5ed3Ey0hmhXcFu37?=
 =?us-ascii?Q?nQ7HS6oWRTat+DfEpr+i4fUJnL+n8udfSvDBdefpLQBlKr6U+TonQgQC4WGp?=
 =?us-ascii?Q?Tgf8VEVWOqjCXsdyhDkpYJLLlQDayDA36JgWIByfwyheY6S8gVKPGohQ+l+U?=
 =?us-ascii?Q?VV4z1i9DhYchP9EXPraGryYpehV+CkcZrSnYBMdsDgHTC0FJBermumTUd7mX?=
 =?us-ascii?Q?IL8lRpmN0AKDQpyd0rcwspCLVVdOaM4Bn2urIcy71R6vrLTnsvSo7jXL6AL4?=
 =?us-ascii?Q?PIqzHFObrF6vxbS7s4Elyk9/YcxaOao6tF6T5MB1sAvVf+nGxIKU8wXlk6Zt?=
 =?us-ascii?Q?KmlZvTANCZreHSWbRN2vhPLgyqIJj2virCqbdh9EosSKphthbi/dY5+j7vaH?=
 =?us-ascii?Q?zp9EMAn+CB/eLl6nhAMVvbxwTS8E5QxN1rBVQPp+pZ8qXsD/rrRF7ghiP7sS?=
 =?us-ascii?Q?lQCZ42snSu/nPJODqym7zE+dkorrVM6TyYgYxHLYnRadAwg7J9MtjDOPm9Kg?=
 =?us-ascii?Q?FuKrKxbSIW7OrKMocuq1IANyvOClZ//lgb+qi42t53VUcaGRg5agyMQ52mHp?=
 =?us-ascii?Q?amjUN3a7IqPd62HqSIBP4Rr3OjeYBq4a6VrXzN5dVluBWN1PNS+xlylyWFlY?=
 =?us-ascii?Q?dcjEbYbALVKjx4y0QUlcMnq2yCdZa939MKi/CyG701+6Dk9xa3Re5O16K6el?=
 =?us-ascii?Q?j1oPso+5GsipbXxDsj9D5lJWX9br7/NvIPxWUUXsCtW8h0YBoMgZP1c7hiZ2?=
 =?us-ascii?Q?GFGfUW3tDQXgYu+TPIDV6GrQLf2DuMTcbfG2oZjz1PqrUcuRoW40FNgRoxsP?=
 =?us-ascii?Q?zx6LesOcXz+uFsd8xjTOue2TnTBCtCuZuaSjSSWw80hfdD5fDD1eZVdUZII2?=
 =?us-ascii?Q?QkzRXD1ILbJCC3xeN+XErPUUtzcz7TOC6fsjrDI9hPsG+fkOXEsPhbXBRA+5?=
 =?us-ascii?Q?HBtHuHuSwlZThVoF62NWlsXBph2kvHmEcChClQLr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0368f6b9-772c-4698-d8a3-08dbf4e17fba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 15:55:55.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbWd9L8gIF7IwoNt4iBRBoB/lXVdbxErXZsD8sDoVk7gmJhKbCuCwi+tpMzBStKF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4284

On Mon, Dec 04, 2023 at 03:54:52PM +0000, Ankit Agrawal wrote:
> >> It wasn't removed. patch 1 moved it to memory_failure() where it makes
> >> a lot more sense.
> >
> > Why is this a separate patch then?
> 
> This was done to keep ghes code separate from the memory failure code.
> I can merge them if that is preferable.

A single patch to move just this code could be a good idea

Jason

