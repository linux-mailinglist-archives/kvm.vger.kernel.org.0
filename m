Return-Path: <kvm+bounces-24165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54337951FDE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:26:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AE64283C61
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E72A1BC9E9;
	Wed, 14 Aug 2024 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="llwQ/2aU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4891BB6B8;
	Wed, 14 Aug 2024 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723652660; cv=fail; b=KichldJit06Sa+yHNXzKaLBW2BLsgoyXc41B8GmLyiCpOwp1OWQr7DGl66w9o57QULm45H9AINw2fma2R8u9ZFZacccPoFXrcYcpOqRWgw7xHBIoLlNdoeaBXV7sz5LpabipVfTk15vLSAWUxGkNNw32MW0OZ+5S0NXxEXWwnow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723652660; c=relaxed/simple;
	bh=VmJi64SlWCh0tmTb4ejrrXgTkSf6ZChYUMNES7P0ii8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XQyyFrjpLExlrxuHR/JZObptODwNRlp1HmdbeatbaaHf9nhHI0myvcjsW2OjMYBYhsflf1LkZkRLdqALbufgkiHqk73kLQrp+X8W8OBfW2xXHpCVyUVDkTurVUMHkqoi0ICG38JcQ7dp5Y5vlw3ovsWUPoU9uXE749vFcWuDza8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=llwQ/2aU; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6Me62LUaR/Cc0nsiCxq8tASnfGhoCvAOcja2vH/UPDtCQUaQScOgnw0/0K1RdXs8F1Cm/ESmQpvlmFhGHBFr/sSB+nU7W1ZlNzOpGdWMH24K3ye3oDWafer7gi1ia6EQhVj4Nbi+Ykc0o7rAdtp3+iAHCZaPf6luPeRbhjTi6SS72WfGPgCQ0gEFbIfRHbLB4SRrJk0oVMhcIle2K0odXZdSSfByhK3hKaDbvLvRgxD3m5zbaztw+xb2m9sCl82zp32zG9XWDLsaMgmPb0qOcn8uctcIfpWqNRNiiF7Th/qh+2jpEUDqCxXvagTu3Xaz8GJe8eCNaWpzHNzD8bldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmJi64SlWCh0tmTb4ejrrXgTkSf6ZChYUMNES7P0ii8=;
 b=ZS5kJTfnFNhj8ws/mP24IdG+XzhjnoXU0evRai/TSIab1bP72bY9XsHtA6HmOUTwf5Kfli4DUGFb1yyA4MpEN8wMmgutbeh0Qc3Oxdew/+Ee/CM/POi+g6cCXAATxcSDqsK8XHf0s6qdmOx9IMPwdEtOd/29fZ1jUKsXc6K6x9MithRPWLggi53nqdxyCnARinHrK9f2yKCVGdHJe4w5jOEWt3PpV+UOzbZBlghWbTG0sJ11rsQ61+V57rEtalNXmsagDYHWsEGYApBemyPAsp0cQUKNOb8ZzPJQ+Dcj/0mdQ88sEFfTumsg+Bw8CFE7x0RFaw2bL9wSO6UpsWfycg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmJi64SlWCh0tmTb4ejrrXgTkSf6ZChYUMNES7P0ii8=;
 b=llwQ/2aUp4fUm/G8fq2LHB3Uf8ctj74vP+sigmXKuljDNE1o6beHBsdpYD+YPPvSrJRXTq/Pz2SndujjgBERFqxPNKDmDvYAoY9iI6I4MC1kXMkl1MAu3rb36azHjQHw2MY0y/8warOWD5p2mI9dXIKTrQeyRfSLzB58l8Pg9PZ9GnmVBvz8bnUZPjU0gULLKyLgjWZGqaP+ncZoJj29FBCv4eSGOO7PuxImQTZn9C2jrAcWH9Uw1Prx5PNQ4nOXt1zL554XpM9QZRZiYuCYixPTQmnPd47mj0ntklFHeINRwzQJe7aoxH9I2+ypkwa7cz4xnE+xajNT+pV6IVJyeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SN7PR12MB6741.namprd12.prod.outlook.com (2603:10b6:806:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.24; Wed, 14 Aug
 2024 16:24:16 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 16:24:16 +0000
Date: Wed, 14 Aug 2024 13:24:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 19/19] vfio/pci: Implement huge_fault support
Message-ID: <20240814162415.GR2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-20-peterx@redhat.com>
 <20240814132508.GM2032816@nvidia.com>
 <20240814100849.601c14da.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814100849.601c14da.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:208:329::31) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SN7PR12MB6741:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d9682a4-648b-45a8-ef73-08dcbc7d8a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q4OBjUMwCFk0r9uqXolxqQfA4Ev9BnCooMcxGGTcpK7TIZG/1eyrrB2GvE9a?=
 =?us-ascii?Q?+dp0C8fN8TA/7iTBenSnYUT1syLKwHUrgN/7lbczyAGZhmRPnB2ag2eWKoS4?=
 =?us-ascii?Q?Bb3YPdxatKOUbsCUlxL2RotTgJ8TPN7UJsUbzriHpQ+xm8fLgN1yA3gj26CF?=
 =?us-ascii?Q?I9SoBzoMViBIb/rMdQ4Vj5dqQ+dkim4R8XAfwJTlbDplIUPjRVx8ESGb0/az?=
 =?us-ascii?Q?7e+K1IEyfungWWNF/J3agJQAC0yULovCXUCC6Ujl2VydiSVz0mLvassJS5XE?=
 =?us-ascii?Q?PmDNQaEH/2JocS//Ce4R8hJ9+S53MPNaBWlKRBE/ZQL8GuTom1BhgrmHzL+p?=
 =?us-ascii?Q?vYlFs4izNILdtA2EmglOywELnJyUyIb5OJwSIOCahfd7YzJWBVstQeXcbT94?=
 =?us-ascii?Q?nQil2qbx2zY3GxHJhEthVsLGwC/qf99fCqczb7U9+kx2SXcq9vXOh7MhT0mj?=
 =?us-ascii?Q?MMCrFgxR5tDdLzOf0cWDXIZyIGX9ifMetYiceDMNPvonk9wnMgpg8a0duQwf?=
 =?us-ascii?Q?e0jzqs7ba2T825oP/nVe8A+WaL9SPqioe+mibHXkbnAI2Mkf0YzEiLjXTxmA?=
 =?us-ascii?Q?NzU5d5sZ8hDfYW1NoKa2erWKMGkZnBBCMpktp051fkxpdQB9VNMZgSkr09Sg?=
 =?us-ascii?Q?zNMjpJ6wKZ967NwzBbJe0MCQi1WBhWQRWLaqU3rYJ5uP8o5eDq0IikpauloB?=
 =?us-ascii?Q?PvJ7jwZudJQU8n2rVYmzcOferSOZC9DZEKonWcNs1PbmATPqKEcuLwh6LdVP?=
 =?us-ascii?Q?zozNK63NHR/yydpIErJKlMmTCqJK1UDo9xV9zxJJkVQWtnE8dlyUwQxp5Jic?=
 =?us-ascii?Q?rOjKjhZFeSv/t3qXwGKecTZwUAiDCnux2MhYAIrqWh6GH2L7qDmehygZLWeB?=
 =?us-ascii?Q?e+Z7icjgE9xnoa/d37pFrZbDCgv9srMujlasj1AQ/w0A1LZ2IAXi6IcxqcN7?=
 =?us-ascii?Q?1xL4PqqzWWRXNjokRYuK58R3nOjFJa4nNHLH96pMcH0Kog9Bj0FqKTUB6HdZ?=
 =?us-ascii?Q?JqByajyeDCYTOAHmRR/agZH+YHCTxxdl6BHPCFKGkOzCHvKBcyPZGRSraVvY?=
 =?us-ascii?Q?aSLajQj6vy6rz4b9UA+077MMm3zS7Ce/dsBoocCVMgVnubQliFTRDEkO1sq6?=
 =?us-ascii?Q?Oi8rguvGZCO1S2655F+789A2P+knuWdhqq3SyhKip/BP+kv3dd2Sm+B46z2l?=
 =?us-ascii?Q?OqVmT8Mi4AhToeO28a4MmIibopsmOzjpCype2vVmuqvqallE7xWmDahkClv7?=
 =?us-ascii?Q?OuqRJ6IhDJ5v3vV4BN1nG00w0RuHTGxm0a+dGjWpXn2tS9818Hije6K7xyoR?=
 =?us-ascii?Q?cXP3Nhhg/KgwcM8iufsU6rR1HfbyIn04GKUq04/1DJo+Ng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sPBr33z3fWjQQCU7T12Qa5lszJ8Xq3RLCCnyobOd41gqpTFtu2K7Ax8rqJ6m?=
 =?us-ascii?Q?Jsyw3SNe+M/ngSdr9BibFPGzFS+E2A8hpqRfsB8OdTTP3BWlw5LkII7Wf5WU?=
 =?us-ascii?Q?bHo5uSbnLh/pXldKvZfleOXtWd35vCOH2xXk81qjjtVHY6vZqXqhZhBROrYU?=
 =?us-ascii?Q?PVK/fZnBWt3AsElMQhcfmHAYPau+XnkpLNuC6JqMqp+5kDcwGT/RL1Ax3D8u?=
 =?us-ascii?Q?wctTEmuid1zy8XwJIfeFyTMUfqkSd7PuZpeFKZyq2Vob1lr36N51netN+exW?=
 =?us-ascii?Q?NbD6hjKt2vXl7UI9NHfFYQBPn39zFVhA+CgnTN9eFIOLGdvVq1MFErVbnO6B?=
 =?us-ascii?Q?kYkobdDJwTK3rW4d0uQJutloqMPOWcB1pkEWCQdqOe8Ch+UHC69v6dyo+iun?=
 =?us-ascii?Q?adYfkf/qVMjvA+p3YOBVLysuMRT0bIdvdHNoy4h4lrCRFBR3ngPUq30RM6J5?=
 =?us-ascii?Q?s8sbqEFIvtBpjLIZdToRnxluOLMwTr2tcn66zgrmYgQH7TRjmVKWgs0GPfIG?=
 =?us-ascii?Q?hvFpZ+aV46H/JWYySgQE61W1WK0ThkMeUQDh8ithpqhXy5fCiQMpkEPFjqlN?=
 =?us-ascii?Q?1Dqn6vufkWB+usJaRZmUdkahiq8BmfqGwg1Ntx9zRP+rbb6yK4Fjbu2Zl70x?=
 =?us-ascii?Q?73Fs57CwKk0bq+Njhh+B4jsqeCHxHNs2S01JcXI4gvbmSO0e64nB9197WyYY?=
 =?us-ascii?Q?fYP1gza8n3t22nnqHfpG9GCyIEju16WcMYbWtgXd/64jk0+++bVBs7/nieK0?=
 =?us-ascii?Q?iRpjg1rT/tuvRr0RwfOdoecZix8TRmezlht6kCUDaZ8oEwUHV+gadyb/y+/w?=
 =?us-ascii?Q?KxOnNDhrMvuKgR4Fsjdtllp0TNCxbdWWQuliZyv2/ScniHiUnWZP/fZGCaiI?=
 =?us-ascii?Q?DkMpArBk1Zbk+LOhju9zg1FoJlKyPIzGSrJmmrI8CPNBxXJ37qLbZ7T4KqfG?=
 =?us-ascii?Q?QTAlEhkXc5cCmJ1lLGdzU3WynoUKI6YFLqUYdLH4yIUe5GZb1pierQWFsdbW?=
 =?us-ascii?Q?03LO0C7dU9zoneHPrdL95SXQCLD5KGOUUjEUYZeS5AivvW9IwzBfT/bW2GSm?=
 =?us-ascii?Q?6/cS+LS1LXqCKok9hVXMvX8+9waz+U2bEly7bMhi+ksJb6EKFjmrjVQuwOba?=
 =?us-ascii?Q?PIS8QpiRUTcs8ItCq/qRlZJ9w37pDH7Sx0F0kk5C1//Sb0hJd3ZkBt3GKyG3?=
 =?us-ascii?Q?/oyYww2+TphC6/rmODXAMPkoO+ds1U68SWjjQh2h/UCGx2gjClNZVXz0mj3b?=
 =?us-ascii?Q?v/g5m5SJObZVcejjSjxdIDGsPFZvSfveNxUU2dtk+q8jKCNiLZdhpIy3iXT+?=
 =?us-ascii?Q?9eV5/2vvt4yWXkK46zydEODbRNA5WLzzG68o6bXEbjrsK+Utkiel29T7Iqel?=
 =?us-ascii?Q?oLvLyr8j2n55bIAKVZouC8f5gWtjKe7fvIB0uaPRuAYEbgiPw6+X0X0b75c1?=
 =?us-ascii?Q?w7S7HjB9HIL1FdVl3eSr8dxWkwHt7Hwk904FdNj5mUuw7hn6jHdke/G71cKt?=
 =?us-ascii?Q?uGqdfIbuiGpXbrf3JipFiO8ycSyDrtPTLqgJdjd+UPA2xBDTe7507+69hNdU?=
 =?us-ascii?Q?2JaKAQP1CgZJCLCd2QKpjJ//6FatQKvS53RWGuU1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9682a4-648b-45a8-ef73-08dcbc7d8a64
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 16:24:16.1238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXfv0Y5wKwulRuq8VQPA+Yo5+ybLOrJkXxBhlT8H6XgPa4QLh5GoZiNBcJRxj28n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6741

On Wed, Aug 14, 2024 at 10:08:49AM -0600, Alex Williamson wrote:

> There was some alignment and size checking chopped from the previous
> reply that triggered a fallback, but in general PCI BARs are a power of
> two and naturally aligned, so there should always be an order aligned
> pfn.

Sure, though I was mostlyo thinking about how to use this API in other
drivers.

Maybe the device has 2M page alignment only but the VMA was aligned to
1G? It will be called with an order higher than it can support but
that is not an error that should be failed.

Jason

