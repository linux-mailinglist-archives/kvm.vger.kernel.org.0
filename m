Return-Path: <kvm+bounces-35378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A241A107D5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA5C53A719D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D511C4617;
	Tue, 14 Jan 2025 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uXg5SEB7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638E5232436;
	Tue, 14 Jan 2025 13:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736861510; cv=fail; b=e9id+mIK1w+ekfodw3rWKqJ0FhxojPJhs/Cc+oao8Sdl3jaxIW0xsKCRu46db6PfEf0Ai7/7Png1PDL859LumqVwNVlzwNQ6XJLw6GE/CtVIBwypeqHhDLwAhiuvcIqdsVZW6DwqIKgNYTA4VY1UeF3S5+4h9d8zdcGsVMyqW+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736861510; c=relaxed/simple;
	bh=2JT+B0LC0vNUQsR8Y9VcYwAtRq7SuBNs/v8OxzVDx3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n6DfXV6hXkOwkpce1/j06iTA0Cw5zKJbWxZsZVmYsH8Zr1pPTH8C1KBx4/hKzKyRq+MiQJRj+YXUaSkCH434ixGUjcvEaQ6eWRcGoytDp7l+9ZD4lJovLWnR4+24Ff3JqbniXVmp0jx1GZBxISxV+9mBx95rAHSc+luioRz/E4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uXg5SEB7; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXU+GJ+zKe7uSsaIRdeRFCta3VK1m14NzTwH6rhtQnhcr0lk1bFgyiaZ7hO7FE1gnjk8xuiPEpCT43cY2x0rYfi09Qzz1Ja+GIndNfhlWPx4RGaDzReYuB5F3e09lPjPKq2ksxKX9bD2wW8Pcao0fKEEzfFGPai9pyF3jAHFnyQK5d3NYd33H7e/4guX4OFz3nNSPDjtzKN2kkp3OFGkKDqWbIxDEYCpFUesJDeecsIK+aQfs6G44WhWMK+dQFlpxOAaGShOpWs5kcliSf7aFy3Wm29inF2uTY3kmdpnxKo7DItgVPIHHBw6Gk5CXWWtMz0aB5H57ksJ3/trDgXn1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JT+B0LC0vNUQsR8Y9VcYwAtRq7SuBNs/v8OxzVDx3w=;
 b=DC9zVQ6DlJ11mB2BNw3DsW4oa018ifXYuAYQP6a6VaTAD454BbWAhxW0y+GVruGokeVGYbpaXGp4ybKDmSuhys2zbbZzbp+QUT9plTTv1HfDLWkj5pEDGIbXIgmTJswN6M2GSnXfLsTaZ9JsmxmWLu+mlFWh3eCXdoSix5Q5z6CWH/H7OpKqPgssQM2CgETeczYeojVFtcKEio6ndn9y/aIyYL2h8sc2M4xAeEun8mz8k3bvIRTKhyYrpa9btPnF6Zz+SmrsK+AypOVjoPlBgMHdUZHHut9O7sv2JBaxgerR+FZAFn42sVK8YB1KDmXu4QqC6w+2uUt8BAENBGA0jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JT+B0LC0vNUQsR8Y9VcYwAtRq7SuBNs/v8OxzVDx3w=;
 b=uXg5SEB7BLsruJo4HrzfwtWBdHfdJKyCQXE+c3g+gzeakLiZxZanihYW3NOZFnOqKHQNhVPjibeVD8xIpp5TtqsSQmm5m8+xqdoGEi8rD/rp4qYPPzchtQJXRfTTQQujIqVH4eUNPVGcmT8fezE6tQs5M/y5QXJKgo4Fi8UzvHby9dmX2lwmZw/4J0Hec13drSIYPuw1lvWLWTWp0eMJiGUpo7T0ySw16MuXbzxqRQWYxlZh4Liw+P5dWets6uSkTdzLeN2/1KAu2AgluAeEeFnWWdYZTLgx7bY+sTo6qvcNWFcMqlhW3hzKUfdCPnRgUlRn7mae9bPlv/dBRveMcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7429.namprd12.prod.outlook.com (2603:10b6:303:21b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 13:31:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 13:31:46 +0000
Date: Tue, 14 Jan 2025 09:31:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250114133145.GA5556@nvidia.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
X-ClientProxiedBy: MN0P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::12) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf764ad-dd16-422a-1c41-08dd349fcab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kXVvEG8s8epwJeO1EjvlIq8pdrmAJB/ga6Z8+VLoodWgGubGT+IbJT5yJzC8?=
 =?us-ascii?Q?ypIqtflyXc65NpLVgJ1620tuR/eiq3iBKOsr8i6p+ipOK06sQgZM2VYmO2RW?=
 =?us-ascii?Q?TP3KiS7K7yuwsPrRXEmLgyVnu1ChiHgp5KXDI53e5aO7V7IAySmYeW3PMxIR?=
 =?us-ascii?Q?vf/Ox4rzHBn816e86x5ARgoB1a9oC9am0XJCo+ReniUkMtWIGwtsqS+4N9Dy?=
 =?us-ascii?Q?CO1uvSEw4Z+MKfuh1Ls59RD75ME8N81iKDIcr40T7HAUrR51+UHsoyNRcJMZ?=
 =?us-ascii?Q?yldPvr8l62R2Stxt0KkLtK3XSL7M5GjIEtQlAfAqnkesTg0eK2W/7OY7DoQU?=
 =?us-ascii?Q?H9Z8hU0CovzDEIu2NO1OhkKde27SNs/VksCpMxb/khJoJaGMAydGcwooOQtM?=
 =?us-ascii?Q?kkV24eGP6uzLFx9q58iYRKwsgc9KNSUx1H4D9JFo6YhgvIHAw0m0nx8cNPck?=
 =?us-ascii?Q?HyviwMOke78T/6Ya7cmocG/1w/opPoDuux68N8zddIacQ2v31+EVX4/eObdh?=
 =?us-ascii?Q?nT5LAwayjx6mnaHLHqRy7dISLkmha5c+JBD9u2DlLgtsPEQVcGynxlWJXdC3?=
 =?us-ascii?Q?e8RwUlfYOOP5KI1MlElZwVj3WLZFP8ONMRf5pVyPFTjb/qBmvOrA3mCno9KS?=
 =?us-ascii?Q?bsk6dRAq5elAPlusUAZa2pK/7yuyMmqKAqRoU/PeITmOqZ4iYXLkCMzNGwzq?=
 =?us-ascii?Q?kiL9lqugR1jKogRUgiC0BPBdmdcfp0ojKO/wN6IqgYRpOfcAnoqFrMsf3S76?=
 =?us-ascii?Q?4zB8ivmB+tUW7RzKkFAKhY+fayplyk6faQDI0UN+TF1pjY2Q5ZfJZE3fNjUE?=
 =?us-ascii?Q?7UACb8JhkPnlk31cm2vs2cNkh/0HsX6sxeMJaY2LGSv5lMvRHCBa6Ljx4gWF?=
 =?us-ascii?Q?WtUUdmw14P9sZkNv4WJ47kQFdC5+1StBlFGo1A+lxEt4zC7k+U5DW4Tr2xMf?=
 =?us-ascii?Q?6XLxUVbHFeVwJNFLgVcea9hecyR2VVXDaV0jAeOQZVuaDRT1iV3VHmzcTGFz?=
 =?us-ascii?Q?4wiCoHdLNFh2MZyTzoLnOa5s9ohioeF7aOBmX8+vLtFcObk6lgiRJ26NYSQJ?=
 =?us-ascii?Q?inKaPQESsS01DsYUzht6QjLvurkGFVm57AfjgtVNlpkQdnunVMnHQi+yC33B?=
 =?us-ascii?Q?GxpBnVtaT1Ip0RTwH6hRo6ygmcwrXX04vPg3ejj7aLhwLZjsEq8K+c4f+B49?=
 =?us-ascii?Q?YDmQuE7FwHJRDPQOqbZEIH2YcBST6Vi0xgsuUrQWXl6+jdXXoYOXx34RVlPN?=
 =?us-ascii?Q?cwRxRn0HadZcxo2zXvS1wRl0xS5xPIO7S38Ds5z1Voo82qtXgK0M9sbgDmZt?=
 =?us-ascii?Q?X4w9XPVl5YdbS2qtgnPnB9pKpVXyvQK0iJlUGpjaBCA1tPHo54Z4kiE48qGS?=
 =?us-ascii?Q?4wJ44s0lGIToEK1RUj05n7UyuN0V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9rHzjuN7gU+B6NKeBUR5ONnJV1Kc+uk09DggDM33le6uPgaf04z9db09My+6?=
 =?us-ascii?Q?PyJ70QFlR9H713wOjc7UvnPfMdOEkYiQqlDuFAfXrma3I7Pfp1NF9m2pG2yc?=
 =?us-ascii?Q?aAmFoUkoajJM0XQezRNyQexE+KxvDmgJfqji/XFub/LUTJwM9F7miSEw76nf?=
 =?us-ascii?Q?LqtXYKzeRTIzKHo/puyOmbuVCokiNK0ySY1gyjOMrOlcslUi5N4eowKHx64/?=
 =?us-ascii?Q?xzfinBi7Ku999nGg4SdQt05v9l3Ev4Cj5WtJ+xYl/Tr0T7WqXliCYWvC1fWV?=
 =?us-ascii?Q?aPwULrCCktPzkc5PIf+yHUQUL45WRwvJmnm8HdtpQ7R8grqAu8zlKRmrtu/b?=
 =?us-ascii?Q?LNNNfki6onWFziUeALgmK/4dH1JquTjGNeAMlT5FoKK/taTmqbDV8Vuzx3UG?=
 =?us-ascii?Q?VNtoS1vH1NNnNuHZRx8wBNdOUqDWqoHVE3GepKAs+fpMO5v1N7tLtRpsC6vr?=
 =?us-ascii?Q?HNTg+1ck4DN5sCkNIxPXvQ75Uq+xaqYI19PMnrc9KG9vW6+JO18SVlD71fM3?=
 =?us-ascii?Q?JGQTAsRgkDh0i+UHSmMGDG9Dos0CumfmACrRZZF7oRekoKBYg+vgdPeTtcA3?=
 =?us-ascii?Q?/GwOI9ZZ3p0w8yAZjW/AkuzRFZTdzCRvJU7SgFb85jkKCg1HVwn8wAIlkCfh?=
 =?us-ascii?Q?Ymsai7GQcwUJjsw2ki0P2ozHKtk9REj5Nnb394m62EEe40K4pJRpO2XuLcF4?=
 =?us-ascii?Q?kKU1deqB48CJU5DBd94I2mrtKfrby7msSoH+P0Qf6D8oNji5dX73eTEy71mv?=
 =?us-ascii?Q?wEezCx6KaolCDmm37z6UrmGQeg1ib/LqYgMmrTsfsYWkbhszhHgC5FAelpRI?=
 =?us-ascii?Q?wUnrDr0fFrIJaoJgZUUc/OSf9zJDyTS6MyOOWkQ8VJ5rYlK+4qsK2gmwsova?=
 =?us-ascii?Q?jklfHSO74qQqcCxS+Oi7E52lIm33orrw+GmPN/L65I37ZKBIdpPhsSNRz57X?=
 =?us-ascii?Q?6Hi06tq100ym24PYZ83HnkcCrMqzEQCl/rbE1HqRGCPsKbSmyRkZrO4vI0Fy?=
 =?us-ascii?Q?rhMNs5Eb/7id/a4QTV5WTcNsLcSvToerU4f5mHcZtpHOqs+Xko0Lpus8ZQGf?=
 =?us-ascii?Q?eREp5g2XCXyODCKPulWLnSotUFKzR+49sC7ktITV9B6VQT3cM9UjJpENcRpo?=
 =?us-ascii?Q?JSj0nuICR/D/g5Q8pkIFxYKJ6HHq8c8Fnj+7hq1Mcbv0pvZ/Cc0NKOdvJcfD?=
 =?us-ascii?Q?VpWNu9n3xfJaLNBSHpnW8fJYxNB/d7elB9r/qMPulE15SrgInhlg99atMw7l?=
 =?us-ascii?Q?olIfAjsnRbNXJaVT/nTAdWm5mDg1U341Y9Mdhos4O/H3cVxpIzYvuGV+eL+X?=
 =?us-ascii?Q?gTr/4cD794uJpJ0o/rd+WRN5maENAZCJz+yXdHS26db63kSXFn7ZAhUm05Oz?=
 =?us-ascii?Q?cW298kwJLdqJSxt7/NKLAoCp22dlQtUosuDzuNrB8lg4tMFexK4xsstJi710?=
 =?us-ascii?Q?7iFc4kiM79bvOWaiDhcWe7E3ZqvxXFFGvY5wMyTC6AFRArIu1pnZDn/+XTzm?=
 =?us-ascii?Q?ox0cGEJvCdujOGlkigsuT5ov7rgIBktVgVsNpp2Wg38+A7o0rGyVmuorktKZ?=
 =?us-ascii?Q?LiOlIDcF3AMM7oesW2/lDtWh3Z1PdOgpWrs0PVS/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf764ad-dd16-422a-1c41-08dd349fcab7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 13:31:46.4340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWuep1+yP3LibgmZTEU9XWCEvlFCX9mD6QiaL7mF4KuW8Sjq3xfQBuPjs6fiq7qU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7429

On Tue, Jan 14, 2025 at 02:17:50PM +0100, David Hildenbrand wrote:

> I assume MTE does not apply at all to VM_PFNMAP, at least
> arch_calc_vm_flag_bits() tells me that VM_MTE_ALLOWED should never get set
> there.

As far as I know, it is completely platform specific what addresses MTE
will work on. For instance, I would expect a MTE capable platform with
CXL to want to make MTE work on the CXL memory too.

However, given we have no way of discovery, limiting MTE to boot time
system memory seems like the right thing to do for now - which we can
achieve by forbidding it from VM_PFNMAP.

Having VFIO add VM_MTE_ALLOWED someday might make sense if someone
solves the discoverability problem.

Jason

