Return-Path: <kvm+bounces-60723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A9DBF911B
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B013218C7EF5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C1D2BDC03;
	Tue, 21 Oct 2025 22:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bzMJPLDN"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A117F29D265;
	Tue, 21 Oct 2025 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086340; cv=fail; b=ppjTzfEQ1rJCtj3tnGDGnvtXxzo2QTjMxPlN8XKUf/NiLvUK2lYmulS5vfrPzjsHcQAblw7ihOMqwlrhf/FYweBVcamIaBZwyyWKbhJ7DXzuJstmwZk8tZtrUNjuhk71dDWsBJ4LVsEIFrJOZqx1sePFDJrTFpZvy7fX4i1FmRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086340; c=relaxed/simple;
	bh=3O4f8O9gfA2nyVt9FQA0CBaQwolQEO2ghsLAUBuU3b4=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q+97JiJ3lsuu+qBkMl7znRHhc54Bu42cFFOKxWqC+VDdqZhcjhhedHNAhNLXdzvpTRXgKnSe3IeZlMbpXMclNYq2NEbU+dwa4k/xjd5mbxRYF1NjV1DqPrHP2MNCdp7bIWs1/N5j+kIuK2VhAJFS0vqYhLcG9+vv1+uy42PtIBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bzMJPLDN; arc=fail smtp.client-ip=40.93.198.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aKyQxLjgcoGjMnBd02wf8WbIWUrnSog/K4EMvlQBJgSPh6FKZicE1bRBkR/3XNxAt/gswTzHGGuMbpc9Axf0FUWPmYskHLlH8QthoKAeSA/lYUNjICCxeZarbWRpzw9DDPIKnGhlV4s7UfuSPyUmxRS6+wLeURCB3sNKEi85x+l6AXzMvzMW8ZjOtHLdaJCaWInCPs3meM9UPPTO/oTn4QEHoJiNT6UpUXVMMyuDO6+PDdxdHZXym0902Dp8xsAcXp8SJqGaLrKf43as9BiWUhoZ2rNAAVnSSNlw7QFRp22fbVp3rTqMKCvnYC1NABsF7EdEzpUaISQJ4XwYBzYvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQQV5iz3xqeY7mo2lCPsIziBBJLO9r/FHtXGcJvk0is=;
 b=QCBJb0Z8+PHdP2lQy03+VytVxkhiDBtJFDoz+XJgKHDhxKrRp7R8gJ4XNUWaj+ZcI+S7DvmHYZFcn9rzKVuQqbnz3LCGuDr9meW6uDrHInHh4CMPvDbcn2ydtm/nY854qW3QwywyTfc4Xk+ggVU7NM6qsRn9pzK/hunp1XZPsV+rJhH0qI8egjrjuh69E7Kvje4xpo5mXAY/j3F2dIP4sY1FB8cUcx2hkJQo2f7Xm92E3In1r9539hMDm/SLq+T9KNFmP1IKaWCeUGyFKbc5jndv0aMQmMLlnOP3+rZ0GPpC3IQ5yZqpvJSnowbT2fKadWPbL5EvBfP+bmauiwsl8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQQV5iz3xqeY7mo2lCPsIziBBJLO9r/FHtXGcJvk0is=;
 b=bzMJPLDN+rIfORerYOSHPyS51mNBZ6OwmlZ5IKJu61NG8RDH0ls6dM1LhGhiHj+EPY3xkvs95uQ4fC7WVNOgkCc1E3W7kKoAxdeU8E5QfObQvfJTzd7D/gfyshAqShzmU4//Xf63VdXJPPiQTknn/l1aqsfoJEuHy4gncbe1KtTh/DrihPa+JAXMrh/hUJFORlyTrkBTEV+z5bzLAEyLeZToRdXuKuPYDmvr9oF6+YcSz/cZmp1fUboW2AEl9CSx3GPcLviQin3LNMfqkOSZZxy705y0s2MIuD3f11QbH443wdTELwshWy/0pe01+1vpOsiIROYpEEdRa4bRprG/5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by LV3PR12MB9330.namprd12.prod.outlook.com (2603:10b6:408:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 22:38:53 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:38:53 +0000
Date: Tue, 21 Oct 2025 19:38:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, ankita@nvidia.com,
	aniketa@nvidia.com, vsethi@nvidia.com, mochs@nvidia.com,
	skolothumtho@nvidia.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	tony.luck@intel.com, bp@alien8.de, rafael@kernel.org,
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org,
	kevin.tian@intel.com, alex@shazbot.org, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-edac@vger.kernel.org,
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	u.kleine-koenig@baylibre.com, peterz@infradead.org,
	linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct
 page
Message-ID: <20251021223850.GA21107@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
 <20251021164444.GB699957@nvidia.com>
 <3ss3epklrmwallhd3nih5qqzjk53dcgns5igudtsg4vnnyjyri@ektyavsup6wk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ss3epklrmwallhd3nih5qqzjk53dcgns5igudtsg4vnnyjyri@ektyavsup6wk>
X-ClientProxiedBy: SA1P222CA0144.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|LV3PR12MB9330:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b1401f0-da71-494e-f947-08de10f29c57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f3l//33xWaJkBoM7T4IsT43IoqlvmLAB1SQRqEXN4jA4hrbZkDzEHdsjyVbo?=
 =?us-ascii?Q?McendHsn0Un71DeXIMv6Kb4JPtpAEqe5Ml45ps+0fnH5akZaXM0HpPAz/G4l?=
 =?us-ascii?Q?K3R3FEQ8vPKBT2Zsp+8YxYz1z6uOu5f+2kViOQJbyDB/+HlC7MzdUHKPbftM?=
 =?us-ascii?Q?RNf0QCGjdMJF2zJ9WGyJfVueffvApTOKgiATfxxcY1nIScxIbMJ7HPpu4SAR?=
 =?us-ascii?Q?PaSzo9i4L0i0ACESeq0v8ZFkVeBWXQZTwFe5vX+TfFiynawjkuWrlz4pEkVR?=
 =?us-ascii?Q?GTEne5rDVtxgQokBa6rxKFdbYYklZR1+7Knc9oVv5wdM175w0lvcKuw9wKiu?=
 =?us-ascii?Q?QzllVlM7ccYwIx+8dn2KwoF92DhmNS2iWPPOsIhofz7IXEcWH20DucZe3zbU?=
 =?us-ascii?Q?G1QuNfbWveCE6tQNp6T9+dQmHy5+Zf+hJy/7RVGurhoxkl670hlsmBoUrk5G?=
 =?us-ascii?Q?36Z5Mrcu24PeC7NnqmBJQT6+nNuYvKxdNUAj8MEU0GdIsr3RaXx+EkoisE2P?=
 =?us-ascii?Q?8bTRkxD3rOZ+9GE0QZGdvx/ELGWMweAJBIktfgOxVcwvGf/1KNXT59bu6+Sc?=
 =?us-ascii?Q?Jic56bKnf18e5IC2B1AiSOgkAgjR9z1scr/pIYtLXzjSEdz/szXqJjvxa/Sg?=
 =?us-ascii?Q?h3gAGQcIQN05yUF6ZpC7GvXDjF79dXjX7r/bwlndkqH2fwPDJevtrI7BGURd?=
 =?us-ascii?Q?hw0asIg3uiSIfrWzmO3V5bf8MKg4pVKTw4LHI71cw9GUoNv4If2Ls4CZeNFn?=
 =?us-ascii?Q?uFdJiLJ3vOMeuFOWMsyDPNoSqx6to6WiL0ldIAnoMGgp4NYnXPbqGtDQ7PRN?=
 =?us-ascii?Q?TPH7NylxVjvjoOQh/v3n9dsDjDYczYZQpaLyhlhpnGjV6U/ibpo3a7CzKjfI?=
 =?us-ascii?Q?dTulrHcHdcdrKE/Lq30m8VuDrCYMzDlMa+o/Ck28w9IlHO3I/rFnWalFMYh+?=
 =?us-ascii?Q?Dw5syZ1HWntjl2AR8TwTwbo2WVv7ZiRpTFKkKe8X1xJVkCquY9V8fTI1pjFf?=
 =?us-ascii?Q?dlZmx3CKKMlRNKbMdyPPUBblOVXl0V+gL0eA/tL30GeHH+QKCtKLMcXFOJaI?=
 =?us-ascii?Q?nRkNnQroETje0y0E1Tw42dfOubwGUM2BwIW56yXydwwzllN8+xDa/QpkBgrR?=
 =?us-ascii?Q?pcP6nTJE6B5whAOEQBIgl5X8RXzUwXzdSUOo0wmp+zWs892xRdvmQsIQXhp1?=
 =?us-ascii?Q?ZIL4CaYzMSsWu00YpAm4MOLyfOKcwKDzpjOyWDs2xuFLipWvTgfQvM+FwBjy?=
 =?us-ascii?Q?WxfdIf3A4s6IM3axcmYe1IgwOYInhNffiQBXMpEQf961w/lmcXUCauARowEd?=
 =?us-ascii?Q?3D8cRhyDBhrFRkMtj0anYPtUkIAOCRJ8K3nDfznbGUU3++/9PY8/RgfKQOB3?=
 =?us-ascii?Q?rq/dQOWycAjL0et3cdgILulCfF4eorEJhWbdiPGPj9Hgr3G/zm2VFTnLTnNe?=
 =?us-ascii?Q?zaPrh/JBjxZvI7/kh7hN7+aDKXjkN+/kxsWZegIE1RMxpbA9Br7OBgcFKD+r?=
 =?us-ascii?Q?YEvuBxNA9satjL8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SLRnRmnFqMp8YALmwZvuktq+s/qbQfEINbYxcYK1Y3qgfGk9r0Urej+pzXGV?=
 =?us-ascii?Q?ii7VKAXeUM/dvlElbMyq1h2YyzprUnB3m1wh7dGJLKItlt4ERFTQVsipgFe3?=
 =?us-ascii?Q?qPDIXC1rMjXt4hpc5ycE/cIupTnAmOzgqxeHhW5G2qgf87tFmarhfBe9vXLa?=
 =?us-ascii?Q?EhZ0oSaLtR65Og2/o5xfjkeNnhZB5T50rgwgCZl/zfnC+pj2V7z2Cty0eqW3?=
 =?us-ascii?Q?EtdfRBmMx7SKYy93L8D/d0mbh3pIFB0zfFYfEteweo12TYGiwiyy0IG1lFU+?=
 =?us-ascii?Q?Q4I02YZhRCB7HN+pZ5dkO4AQl2CveawSLLxK1dMqN7mEFRGtwIBLcfHSThH0?=
 =?us-ascii?Q?50wonK+Gs2m51KtO5cl5xA/X3PoIivSdbMucSOzKU2PpdJgRLK/0cBjfEesF?=
 =?us-ascii?Q?2lkcdBS0U7wwlpeXCQDjfTCoANAoz0o1jUqiUs/6jLhlIdhFQ6nQTv2BwKRJ?=
 =?us-ascii?Q?F+5QUtlXHWJ/gnriT50c38BPwyjeRzo1sxXG+kIMMXup7mZzEF29234lDzX/?=
 =?us-ascii?Q?+g5Fc/9hUlypcb626WzQBQv/fR8dizhjmB8zK8z/iOU/69+KvIX3r8OncMrc?=
 =?us-ascii?Q?Z9CA2UMVN4vgQTAuqH9Xk9dQkgV0FRh5WaoXMYLugoRxdYPhkqCH+/7+/t+k?=
 =?us-ascii?Q?ubUkX5HLcARAKxMUzsS2JQt107a4RKqh1wyHUCZKwIfcC6F+NiLvCxbKeTRz?=
 =?us-ascii?Q?F3eTMotbRyw5OA9PVrAy3aZB0hfH1XCG/ITI0sdyInlsMp+vqQhUEriqUJ87?=
 =?us-ascii?Q?WA0Cm/3PsG9xPOvJc2n9Gg5zkS2OnA1ZdZ/zK1ICsz+EEZxn7mfslSgQgiYX?=
 =?us-ascii?Q?oAPv1cmVhVa34VywqEnLr6QH9JTBxdnLB4jCk2hipWBST46ZKCsWyEDrjhtD?=
 =?us-ascii?Q?+GSzGwHs09R4GDiWQYxQiqGxLnldbGN9MsR6QZq6Ss+U5XDFzQBw2DAyl5rQ?=
 =?us-ascii?Q?kFzFZ/Ri3uB1QTjxgKl/UjWPcnlKS85J7A3LASy/xAEppx71Z+qTzwTnF0Yd?=
 =?us-ascii?Q?cFt+VsuUGLKxGdc3EjaSvP50Urfjyfif0ppnUWH6Ol2xyglg4k/0W3+AnW9p?=
 =?us-ascii?Q?AdSwOEeQ8XRLZr2IXG6be2/dc4sFK1vb1TSlFCruI9sSGvdCDaem3/lMaQS6?=
 =?us-ascii?Q?zXxKpwdfjEllMhu6h/o5T8FQG+qe1XjIKIL9OMT9DTVFzJEEP3UoVRr2sXGb?=
 =?us-ascii?Q?2dkTUJKJSfhWH8yrf8XvolD8Ff1gDzg6D8bmctDezKu9MU4iWQFyPFUowpmG?=
 =?us-ascii?Q?LrLz4bd20P8ch+BHjFx/b9DRgTI3tb0nz16VA4pGRXR2z2C588Uv1MqNRvCV?=
 =?us-ascii?Q?qhQmUX/TPYLT97Fgq/fJUakzzz/DCKU1XXdPEYOogUatouhSEgLY0nm9u3st?=
 =?us-ascii?Q?iDfE4lPs9BnXuQpCnBYFbqKeYPP0GQ2mURUIAws71RI8lHmtyeBxFFUrAJJG?=
 =?us-ascii?Q?Oe+MI9YvdlXZCO9bKvuTFf6iUj/bHRkCdbibNA4Hs0Fy4Nm2vx8l0cNehN7x?=
 =?us-ascii?Q?xzpxV3rWOGOmhqLGTVl2mOyPiy/o7RqQtz2CTnTPn6KLP07CYZX3njp9x8Bg?=
 =?us-ascii?Q?9U/qASFrWgwJkhg6g9igV/H5IfjHoC1+gtRYgFPx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1401f0-da71-494e-f947-08de10f29c57
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:38:53.0600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKsYb5Gf8RldHSfE7ZJFYtohxR5IHocetgIHiEM/c3p7ozWNjvz5byab8vKRumaI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9330

On Tue, Oct 21, 2025 at 02:54:10PM -0400, Liam R. Howlett wrote:

> > > Surely it's not failing hardware that may cause performance impacts, so
> > > is this triggered in some other way that I'm missing or a conversation
> > > pointer?
> > 
> > It is the splitting of a pgd/pmd level into PTEs that gets mirrored
> > into the S2 and then greatly increases the cost of table walks inside
> > a guest. The HW caches are sized for 1G S2 PTEs, not 4k.
> 
> Ah, I see.  Seems like a worthy addition to the commit message?  I mean,
> this is really a choice of throwing away memory for the benefit of tlb
> performance.  Seems like a valid choice in your usecase but less so for
> the average laptop.

No memory is being thrown away, the choice is if the kernel will
protect itself from loading via userspace issuing repeated reads to
bad memory.

Ankit please include some of these details in the commit message

> Won't leaving the poisoned memory mapped cause migration issues?  Even
> if the machine is migrated, my understanding is the poison follows
> through checkpoint restore.

The VMM has to keep track of this and not try to read the bad memory
during migration.

Jason

