Return-Path: <kvm+bounces-65473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A20CAB7AC
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 17:22:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F0CE3016DF3
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 16:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E2F280CE0;
	Sun,  7 Dec 2025 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jnXqLp7l"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE449274B46;
	Sun,  7 Dec 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765124503; cv=fail; b=FdgTG59RnvdoXS7qVkpaf/F8zp4NPPA1FmDEB6QYh9fX5g0RdGkT3ra1SRNMbQyDfbS/hQTK8RWq/Gehc37+093jV8U7Oz5hR61pbFEjiYMwyrYkSM53eqJPL9UwFyhGaRoRTXIDwjXcCSS1JPsPNemeEGwCuzP/ZL2sTOfZumg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765124503; c=relaxed/simple;
	bh=uEy5fhUxSPQE+xrl8fgk98Y5r4bE00c9w/9+4VG30TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ivJJm+Nvh7QO2FaisBncWqxnkQNe4zXGfIsKO/35lsQwZcNNJv9RMAjeSKU90MF9QWc1iZbUO1NDkzR3wXnyQuorYbXMWb9SoE0Zym8LBtyGTu9nIpC5NNzN2z+jYVBpKXoTRQy29clsO4zrNUOCgXlEFzPwB8TboaOSQH6MBmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jnXqLp7l; arc=fail smtp.client-ip=40.107.209.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c/mq8bJBwifPYMUwFB/kP0vM0sEq99K2TBWULtOSjaR77qdVClDQVWxfu84+9f+rE1UUGMFCRhd46yBFu159b8iaRlqxo7DNPb+Nk7h20hju+G91iJTQKH/fAI9YlVfbZdIHPA/bLQkfT+CvvGwCZay+cy2l1P11+wxJzVw9MEvfrtpHK+h3nlz4+SrxhspwLgRNzRRXP30IiIMXjMSyIY1OyrV/HN74eJG+CYS4o0Prenvxcqm2GPTLLQyG+/guFLeY7sWniujxVSuaqSsgY7/z5vzrkQuhj7t45jyPvwjO5NggrklbKnGNp2UA8K/AUQs/EuKwutEW0AQSkXF6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+9zOeLqKUTykIlZzRtwRSZltDt/lRX8FSvuSr1GAMA=;
 b=l66VJP3nJq5LKqQA92YYsScCkNGrFooGlZ/dE1Bi/Nq5mmDdk5PRpP+5HeaXBbY4XhNr3vSf8jXc1Mi9Li5uI34OZQzKCo2HZn9PQ8R5UyRtD/RVP4aLILTIQX0ZE6SscdSf1PwaoNPxVs+fWJY17hhYd5Dv6JHpF4QGRfPiktZeuh6muzAAoTnZucoTMKJgbMVnllZ/77fjjChSVzwTvDaJ1MAanHdmmpIIPrk9ajnCLwGFEdGjOSWRjxMmQ3n9KAOysbBErTS7CheLzY1sod4Eiz/pYFDiYSLrRxF3EDz1/5ETgrydla0AiSkUX/mdomaQwMf3hY/SyzXf7k8gcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+9zOeLqKUTykIlZzRtwRSZltDt/lRX8FSvuSr1GAMA=;
 b=jnXqLp7l6pwAoGuvuFDWGy2g38BYDvqSC8Cs/9u9QRzsk1w9P1iXIovPMDXN4VE+6QNl4n1Auygy+BV8G/3uZ0VOW6EkpKsNHWb6RB/XMDok6SIA4EZkNzh2RqKhV7viI3AMUo5KBuh4jQNVmMm46RfKTGzhVJ2MATPy6Z4Je1mxqDTsqCMMJiUNdmLxVdkS/5T/fhEl5txrPYEdUFn+XoPQGPam/l6+czrlVhFR1/FpvQ1morRVwkzSVD/QpqBNF6Z3eJJ/ktHm110Z/laW7wTCuevuAPwp7elyYnuZ8hiRR+5rNlieyBs3z8KDwJjiFR3sw8qcpw1QAtJNN0uZpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA5PPF9BB0D8619.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.10; Sun, 7 Dec
 2025 16:21:34 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9388.013; Sun, 7 Dec 2025
 16:21:34 +0000
Date: Sun, 7 Dec 2025 12:21:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTWpjOhLOMOB2e74@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-3-peterx@redhat.com>
X-ClientProxiedBy: YQBPR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::12) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA5PPF9BB0D8619:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a75c673-5e87-459f-87ba-08de35acb012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/H/ZykLUIV87ymUi4yfiBsj7WNbOKc0Xr2GS9o5l88KbRNtAccc0ViJU7oiT?=
 =?us-ascii?Q?5Mpp4mOLWcxfuujozYvq4bDc90AElSLu2vq4fu/ZdM+OAmLVtep9eljKafDV?=
 =?us-ascii?Q?GVU0bGmpOxhjEaCw5A+FfhpDdaycJGBN9K9N9xgqhRuXSaApYKgYQz44aPgh?=
 =?us-ascii?Q?ajwNtWbWNnBJFV/2I4IOo6OIVZ5RiUoC9zSaTG1P67heJoxwNS3bR+HQzaoz?=
 =?us-ascii?Q?dgwQaO41HkjnOoJmXYtfyvFv4xSM34QDXIHjVYeGC5w96YFu10JJ8f0amFRh?=
 =?us-ascii?Q?Sxp93uH7SZxh8QBPDrKNML2ARkRJOqAAFiqUbiM/3I2KtdgE2aDZQLwmUA/T?=
 =?us-ascii?Q?jy/SYrocEd7DFpzS4oBq5hdYNfUoaAnMQ7WVPdNrvYHTZ1qzPSg8zg5fXHMl?=
 =?us-ascii?Q?CGroreKR/VcuU9RQNSJzafNJSQp3B8krdEbqJaHlRYrKGn8MQjPYNz2JCrvC?=
 =?us-ascii?Q?C2E13ODrNMIwFXj87FIqXp7aaO3zqgq48lThCqsbTVvIUl/l4c60F5A7QTq7?=
 =?us-ascii?Q?z+QJ1RWD1JvwR2Tfe/yR+sB4YMGLZGIfNBYmprw/F+2M3a7lAT9eJvrGtH3G?=
 =?us-ascii?Q?mJreUEK5Xjw+myrK+solWB8dUCBRgvWPMiEYfo6wY9Y9aaVkgT7KNsBPEdd/?=
 =?us-ascii?Q?zUsb01VaQFneZ3Y+Bapwz/bIgax3W+FvBamCZFKB6Vgh/oXBnEPfDcoZwpBP?=
 =?us-ascii?Q?X06YqlBhKUP+HSQPOxIHc1pMsJ/z85AaYTgwwcknVbYEI9oIjHTmt8s+sinC?=
 =?us-ascii?Q?gCp1PcU4cQA281+kf4xovP7VZcv4gFZd6n9TrRnvgoFY0ya/27U22v2omdvy?=
 =?us-ascii?Q?ORKaKlnQCU9xFM/mhOhqJkTPx2tYKhKzwIbxzT5AqJNqZlh9Ma++zP8wXy8p?=
 =?us-ascii?Q?VzBvh7lVlwe5ulpJp5BKesY0rsCMGPKqape93GUynzPqR3K2sp/9OWfbB8of?=
 =?us-ascii?Q?GGEa4P1HKAqcN5A6GJCEiBb7sw5nsM5YFaOyQwqE6qb27+RL52DID2nQnqGJ?=
 =?us-ascii?Q?hsoKUveDOlgdAoEoH/Vp2LqBPkmTeaKrpxaA14sQI4XVdLZkbMDQGFvxAdZu?=
 =?us-ascii?Q?lneIQJAALItkjaPZcGoaU9VguGmslHR35ZMJxerbtUG0UzpxrIRldGTpsHGY?=
 =?us-ascii?Q?X8c3Cj8tiE0iPGyK5vucCWRVIQEbnz6OgUcZG0x0pVHb3WoJsCWg5UX6bG+t?=
 =?us-ascii?Q?Yb+xrvcwv1xrc7raMleD92phgFOMRTe674A1iDUiIcZXpZPYcLBDsGbm2Hdy?=
 =?us-ascii?Q?BZDVg9nbgT7l4COHnBiejzIdb4bvD3mxhrjH0ixNLh8Y1OWcMCFnNcRaznwO?=
 =?us-ascii?Q?BJX+gmehdcLZWgfmusz0zay4GXO8qD1O5HNFlPloVFR1LBdaK3XLuCeDVFdJ?=
 =?us-ascii?Q?QelWu5TPBr9cSn8DQ6TZb29iGgz+Y+lYlX8xWqwxSKCaaGnIXHqGsY4FF12G?=
 =?us-ascii?Q?95DxWvmNKyQDIPX/QHi0wCV0bA8e+g18?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UcIe/kiEAb4Hfj1x70Sepbx4ulT0tb/9bg9ybYZH/kvPF3EUAnXT/ZyDeQy8?=
 =?us-ascii?Q?KXDMXo68L7q+PiQUf7Hx9JcgJoVH+1wMOJx/KngpQ+nAvJQxTWrA6tJn2VTX?=
 =?us-ascii?Q?n0CpVGKXB4h/2q3j3gRYg8m0+fRA08DOhOpb1fgWOKXLSzUWN0woxVRQDlzk?=
 =?us-ascii?Q?v6lW54mAGNbhNWYSZ8ocL+NWpKn0HXGbT7Svh/UgL6Evai9sXzJBWln/3aNL?=
 =?us-ascii?Q?LgS95R2OqTt3hY/TUpoDKMe064+0OdTH+C5jYyS4CJUhP5Q/g0hukZMBbu8V?=
 =?us-ascii?Q?LgOXk+Wz/uUunkSgR7TkZdvtKE0bGNXoQ+sjHpUC+VADU3k1xB7hhuadzMSo?=
 =?us-ascii?Q?//6xt2YH5PLq1aMH52byUmcLE5q4atJiSH7E1oSF0aKxMi7ZIg25VsxcNpcf?=
 =?us-ascii?Q?W1h4zsvc7s8HuoFhcCZL+nG+f1d2maEuQtDzWMIXZDP60JTHhbSiRM3K0VWm?=
 =?us-ascii?Q?tUrApnfFZdALTZ7QS1jBEJxnjDZktbQVw+GueHN62BxzLEY0YMD0WJi8zn8O?=
 =?us-ascii?Q?UtdaSaKYXAevmyx4v0i3zI9RWfHi0iueYi9Bi7goydMz15A4kTb0kCqmcMF6?=
 =?us-ascii?Q?VJb7OErKiLz20s4LmX7fxCIYZ5k/Hee4tNfSIJ3e8ey2m1rrcZNVP2kxfbgr?=
 =?us-ascii?Q?ByWCW3uxTlExGqxyvbRl19mHyWu4bOI2KPO8JxdPANvtVYtq1AqLUnOiFdBS?=
 =?us-ascii?Q?rsM2Bz9mz35rAKTMoAJRbHZUzvz3Esq6ckX5xgwniVzasTxCSZRb+tEWcTR9?=
 =?us-ascii?Q?zcX81JT8CfiSwnkEMlh2jMCmSOR7RFSTi2E3tPkZBwYQWoBTmuD2OJV4a6uM?=
 =?us-ascii?Q?v5kSwbPFNAsr5/kYHAyh9LPK5d+AN4mg5FkRU1alGWcFyYTwZ4+r1Y5cUbMi?=
 =?us-ascii?Q?2zYQOilzWaWa8DydMGI7UMrwmHpQLAqk4kFXa8quqmNgrREKxNwFK6BgLeg4?=
 =?us-ascii?Q?Vqhxqp+ihJfPMMI6kiYybYQRMWCko5d8HrkRtsZloIqoIfkJ7Q8k7jDzsphC?=
 =?us-ascii?Q?HKJgjNMjqGoe+uuHw9xCDXdP91pgtS5MCM5ijNChWPbvXs+nkCcafdcWAruS?=
 =?us-ascii?Q?kSNahCowpSwPvKzWQBJGgp4XVC20zaeHgJUjPQ5yjgpsuwNK/4QptUHdYkJD?=
 =?us-ascii?Q?mUlBVOxy2lrEELw/3/lxWbbyZiIgXeFrNV3Ey9N682lAkmo5t09nkkAOYM6C?=
 =?us-ascii?Q?Q4nfwDxtw18tL1IRIMQeEG02q5CeS4yL7tnxROo6Hfw++rGDGtebLO+QkZd6?=
 =?us-ascii?Q?pC69Waifo3muMTfTxz0Zwk/WlrtWPWtgMugVMeuDN3ijkH0eg648i493yD9H?=
 =?us-ascii?Q?U/ZI6UPicRese5jAB5kqnpnLvvJViklomy0a7irHDe0Kq3SP/TRCq0ocYZGf?=
 =?us-ascii?Q?IMDH1OaydZXxajkD0gf3+0oHeysPvM3MQubuP6oHd/o817ls0DAfJNet+oxX?=
 =?us-ascii?Q?Gep9MXELhYyVvN9WZi7vVgYaWm08terLkYMNSmpsSnEvjGa3R6hHZLWAuUgj?=
 =?us-ascii?Q?KYE31OnAJk2ji9rD58EQLXzIIAw52Gv/tP6HIbxhcohbZWLiICR8Sf3iLEGZ?=
 =?us-ascii?Q?8kwwnuUrJWnnrjL+0bFqNv04Ap8CZMp0yHT1OI2N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a75c673-5e87-459f-87ba-08de35acb012
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 16:21:34.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J842ZeDnxgE9cx97t/iWG0lq8H5pfxgI5u7n7WKuh/sAofHEtaaS3nHb0CEauwGZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9BB0D8619

On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> Add one new file operation, get_mapping_order().  It can be used by file
> backends to report mapping order hints.
> 
> By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> the driver can report the possibility of mapping chunks that are larger
> than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> when allocating the VA ranges.
> 
> This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> VA alignment matters and it needs to be aligned with the size of the chunk
> to be mapped.
> 
> Said that, no matter what is the alignment used for the VA allocation, the
> driver can still decide which size to map the chunks.  It is also not an
> issue if it keeps mapping in PAGE_SIZE.
> 
> get_mapping_order() is defined to take three parameters.  Besides the 1st
> parameter which will be the file object pointer, the 2nd + 3rd parameters
> being the pgoff + size of the mmap() request.  Its retval is defined as the
> order, which must be non-negative to enable the alignment.  When zero is
> returned, it should behave like when the hint is not provided, IOW,
> alignment will still be PAGE_SIZE.

This should explain how it works when the incoming pgoff is not
aligned..

I think for dpdk we want to support mapping around the MSI hole so
something like

 pgoff 0 -> 2M
 skip 4k
 2m + 4k -> 64M

Should setup the last VMA to align to 2M + 4k so the first PMD is
fragmented to 4k pages but the remaning part is 2M sized or better.

We just noticed a bug very similer to this in qemu around it's manual
alignment scheme where it would de-align things around the MSI window
and spoil the PMDs.

I guess ideally the file could return the order assuming an aligned-to-start
pgoff and the core code could use that order to compute an adjustment
for
the actual pgoff so we maintain:
  va % order = pgoff % order

Jason

