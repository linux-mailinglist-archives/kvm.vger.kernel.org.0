Return-Path: <kvm+bounces-19755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBB190A2F3
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 05:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12E0F1C21327
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 03:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EAB17E476;
	Mon, 17 Jun 2024 03:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="MtknH4JE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2086.outbound.protection.outlook.com [40.92.20.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCD1A31;
	Mon, 17 Jun 2024 03:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.20.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718596474; cv=fail; b=B32hejYWxOry1nbyIgmcOIjqT4oiMeIoXYiWkGC+oPjdbdaxpTrXM/uNmC44CM2fJUfwmR97aRZjppNkvtLoJ/kAesm4sBsdVnmEWcTJmrY3UPvP2IXLWceF4RLH4oftZGtHDC7bhbFks9ehHhtBTNMFVlgy8HvaJms4P1R9wB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718596474; c=relaxed/simple;
	bh=X8dlUjNsHtKZkbWdJGHPUMcw8x0QV76Oi+TrAXxP/BU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PG6C4UV7sNy3fUDkxtrSyBxo65vJtshmbVVfgOVl84flPEwtnAwFSXDEZ1SPzWxM3oEg+sxwNUwiboU3Cq6UhA+BjYoKZ1krfwlP1V2n3gOMEsEXrFa1c7JBGebSzKQR/uafxbr1V2bfEnvzAZjQET+GKRPuaRE9D0Z4pkQfH8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=MtknH4JE; arc=fail smtp.client-ip=40.92.20.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fT5yrGxaw6yrjpV4cymkZV+rVrw+Tdx2kcmhZs5PuvjAAB0iMTzYzCe4JC0cwYAWdNZokrnD3mLE2QI0UW4rN/B5zcPMwr18P/Uus8WgNDYW8jj6Ap1Yhjf9UxB6xFWUwqjTGSq87OH89/EiB++CZpXlTUO1mQNpldENbV6f4flIEB5Cv2kAlG6kO9KgffYaND6OFHjlxj6/2NfTxqWFl31zZB6MIloMoJYtLW2fTHxIfjOnzxJFcVswwdrQhDXfNoITJJcxHko1CfLsoczzPgwH2nzE6qDKQYwvEL9Uk4ZiuKlltNNChj/aQ1cbhasmHR5fH1LMUXFqW1nvHgp65g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYShXVJJSaXR6XKcrgWiI7QAqVOg6IX2y2bmCitUKZw=;
 b=nWdsNHHiAkqGOG12mxJSZQtZfkYMovpoQJpMJt5yEqswush+GyzwyFRSN04CrASsKtELTT+DuSWe++jIWhLU+f3LHyc/sQNmZTQUuP0LEVkLs+iybibOK50JpX5f+T0LFV6Q6SYVwMJiP6WjkB6qulr/uMBwg3ca0Fu/Sed+36GmOJoxwMwfbhSj0FnzVwWrR2SbyCwOg0I7EsWuwQsDvvlP6cG7f5+3cv8AJeBJPwgjLngb9nFtOxyWq4TDKns5jXpp6BfZY5cQ7nSPM6q7/Ls6xl69xTAiENnBW9GX8qY2dupcBsh+UfaTrbornLbha/bHvSzP7uYHq+m7ttwhJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYShXVJJSaXR6XKcrgWiI7QAqVOg6IX2y2bmCitUKZw=;
 b=MtknH4JEx/KY6i+BQoHGv0cMCo5Ksayndnq3z3wB85yx5gNGmgw7hIMu7bn4jPXbDxeVAdDkgSIoa3z+zbXNZXVjIjH2F7KAS5q4/s6j9Lbs0CmT8ytUPbpCAoqvYjB/FaDFNk1nwLKZoBfZ4RXnfEsGs+MxVnydRD9T6CdfiurlYRz5DCYsz6TEaVlLXYrgIG7oSojl8xehA/Kue/pJ9/o62O20wI19AQqfPxKRjGRqcqfQzsCn2YZjwG3SqWbE4f5wAYU61LoFOFF+nZ/E9tr+3QHHq+HdbUjZY466o4VxfGWdhRzcThyrBIGOnD5T57SsKMU0NKl2i/bYIadDFQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CH0PR02MB7866.namprd02.prod.outlook.com (2603:10b6:610:ed::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 03:54:27 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.7677.024; Mon, 17 Jun 2024
 03:54:27 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Steven Price <steven.price@arm.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Ganapatrao
 Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: RE: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Thread-Topic: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Thread-Index: AQHatyvDpGLInPLe1k+KxuF+HFPQEbHLYNYw
Date: Mon, 17 Jun 2024 03:54:27 +0000
Message-ID:
 <SN6PR02MB415702A53E8516F1BEEC7EDAD4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
In-Reply-To: <20240605093006.145492-13-steven.price@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tmn: [dGrV9OOqt3g4+hFjrL2dqlvw22Eoqgxh]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CH0PR02MB7866:EE_
x-ms-office365-filtering-correlation-id: 55389d34-783d-4988-c15e-08dc8e812f27
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199025|440099025|3412199022|102099029;
x-microsoft-antispam-message-info:
 lDDAzHI2lxbTzdzIs7ghRXPz4oj4KxQuZ04rnaaztyug6z4JmfjaB14O/H2R4Qp5U1pUEcKlzD/JshAkCTx+KJgHI9wi6fsY/1J1kObn3VHQj9eoafzUnDet7jwsxVSbcGEFchHQj6U/POBk3bvRKXltkuNhdKYN/IVllBPlGimF44MCp/S+wPE4oEa0PjNsBbk+UL8ARiDXZElaJ+omU7ojJVi0YM2cOVIZagR4wN8lr1kB5c4XN15aU3Rs04rrm4bxEFl4CQ6pN5J+nO9Rbx6ot/XicPf9dA22xGxeRCWb/X4j6HNggvy2z9nh35zGriBfS5YrvpwBFDq5AXWmoR90JS4bx17e9oJQOWpq9EJ9gV/OYgMTupCTfiUW3qEf+FMe1ZM/H1WJrt/2qt+AxzOgPEERf6FhDJmSKAV3EayJNBWddryh7eCy+c9z1PO4f9qkjMSKwtCiasvQgj3RNs8h368PKYkhxvAEy91QPU0Hwmhj82mNNUn/sxPJaBXk42r8OPakMVI16DYEMY/VMUQ1+vPc55ioZg9d2pGE5vLXOFKrYOM45KUYc+URnjAc
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lbfGzb6Aggy2iVAYwbjGpJtzKpyHi8K7T2e0lT5aefvzHQRUNDISelmb20tZ?=
 =?us-ascii?Q?NPM9T+JzyO4zQeBdUhauU9rkjFX08us8yoPmo9N+ayMwdhItob9bu/agG4rH?=
 =?us-ascii?Q?p/csiCBruBMzzFVW+Hy+yj2LPaP3FeLNhYL9QlBeLXLcY5rhH8NOOUKs55nV?=
 =?us-ascii?Q?KZ/fsNpzSpigi3n0OMkTQbhW7WTUXj4VeB8voVLGKnjSn+o2jkBV7/2+D3hC?=
 =?us-ascii?Q?671EW6ONYRei95ACFIRcgFBbG2H4IUJFiSzmaGV/2QE1vtZB/dCYhgbvWGgV?=
 =?us-ascii?Q?4Z248pgA7sSRn70v9gSB9Qzhu2rV1mZNBVN+ukOAtcqEUCMELtYqiGSzkJVt?=
 =?us-ascii?Q?rJRRaH+n9awyjCx5/QMc8OPhu/5ZBfdDPxXhgSKjVLAIurYBnZLMyKjLJJ9t?=
 =?us-ascii?Q?v+G5Wy2eEwh958Vi+P8tucNIgViTiGTPe3KBkzDBXt5EqyBh5/DWAW3m1dkN?=
 =?us-ascii?Q?RZrtai2idurCedr4aZowSfPeI5VUGSazsppb8Bxxl0bOkryE1pILU2U5pkck?=
 =?us-ascii?Q?/3TVxoesAEQuesOY8M8Qjqb9/2W2UYOSMxiFbiCFiw8FhXht3T0iBFBYfWG4?=
 =?us-ascii?Q?9L9YD2tAWcCZnEVlwoKL8zAkSXwWYO0wdnh7LkObGLbq0tPdgE4VcRVkIMNx?=
 =?us-ascii?Q?ZHCQh4RgRClbT4n/CnKdc1cAsXWEZjXm0JshUooZ6P2UIVYpDYhqOJR7wDFE?=
 =?us-ascii?Q?szimJvzJTZsVr10DdXg+szofMbCvqLfZEhzQp5YcmMlfZGlIMjN8mkAkkuuo?=
 =?us-ascii?Q?3kcesaiJPIn6uYDmQtToDlPDoVRGPcm0Oi0bj7ruIF1WBXpfQfxhjN14cPkV?=
 =?us-ascii?Q?3grTZ/lbtaCYhORAI6xX9zATRwNE61JVhLl5UhG4/c6hpgaOR29mpCTpZPpr?=
 =?us-ascii?Q?/nxEYcS6VpGCVgnrjKBxxB4T0HKS5yrUvjHDRrPKs6ijGmMXTkCgssvcqd6o?=
 =?us-ascii?Q?M4s9KoX18b7HDiSuy6iJr+uc+i4Ag06F2q5KTH8HEvCjANmTcpwIuCz2ftGb?=
 =?us-ascii?Q?VPB+qRaxMvz2wOGWwckUjq3vDB9Q8EGWVzHyEcMSE0ukVWggl7GUNyMnQHtZ?=
 =?us-ascii?Q?qKAWVppdD9Ye+8PPcvLOvtTSh5S4OsOAlXybBEPYdeHvr/kMLAnUY13jJ6+6?=
 =?us-ascii?Q?MpYEBwWnVJUff/FIhBNTq5ROeCvSybkCZsGUqC5L4TfdPQab7fjpyE3NcGFl?=
 =?us-ascii?Q?Od0oPa4QmhNI6J0tRq8wVgNPAvCgRLFjxxN6aV526W/f33w4zKs47s7nUVU?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 55389d34-783d-4988-c15e-08dc8e812f27
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 03:54:27.2531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7866

From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:3=
0 AM
>=20
> Within a realm guest the ITS is emulated by the host. This means the
> allocations must have been made available to the host by a call to
> set_memory_decrypted(). Introduce an allocation function which performs
> this extra call.
>=20
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>  * Drop 'shared' from the new its_xxx function names as they are used
>    for non-realm guests too.
>  * Don't handle the NUMA_NO_NODE case specially - alloc_pages_node()
>    should do the right thing.
>  * Drop a pointless (void *) cast.
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 90 ++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> index 40ebf1726393..ca72f830f4cc 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -18,6 +18,7 @@
>  #include <linux/irqdomain.h>
>  #include <linux/list.h>
>  #include <linux/log2.h>
> +#include <linux/mem_encrypt.h>
>  #include <linux/memblock.h>
>  #include <linux/mm.h>
>  #include <linux/msi.h>
> @@ -27,6 +28,7 @@
>  #include <linux/of_pci.h>
>  #include <linux/of_platform.h>
>  #include <linux/percpu.h>
> +#include <linux/set_memory.h>
>  #include <linux/slab.h>
>  #include <linux/syscore_ops.h>
>=20
> @@ -163,6 +165,7 @@ struct its_device {
>  	struct its_node		*its;
>  	struct event_lpi_map	event_map;
>  	void			*itt;
> +	u32			itt_order;
>  	u32			nr_ites;
>  	u32			device_id;
>  	bool			shared;
> @@ -198,6 +201,30 @@ static DEFINE_IDA(its_vpeid_ida);
>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>  #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>=20
> +static struct page *its_alloc_pages_node(int node, gfp_t gfp,
> +					 unsigned int order)
> +{
> +	struct page *page;
> +
> +	page =3D alloc_pages_node(node, gfp, order);
> +
> +	if (page)
> +		set_memory_decrypted((unsigned long)page_address(page),
> +				     1 << order);

There's been considerable discussion on the x86 side about
what to do when set_memory_decrypted() or set_memory_encrypted()
fails. The conclusions are:

1) set_memory_decrypted()/encrypted() *could* fail due to a
compromised/malicious host, due to a bug somewhere in the
software stack, or due to resource constraints (x86 might need to
split a large page mapping, and need to allocate additional page
table pages, which could fail).

2) The guest memory that was the target of such a failed call could
be left in an indeterminate state that the guest could not reliably
undo or correct. The guest's view of the page's decrypted/encrypted
state might not match the host's view. Therefore, any such guest
memory must be leaked rather than being used or put back on the
free list.

3) After some discussion, we decided not to panic in such a case.
Instead, set_memory_decrypted()/encrypted() generates a WARN,
as well as returns a failure result. The most security conscious
users could set panic_on_warn=3D1 in their VMs, and thereby stop
further operation if there any indication that the transition between
encrypted and decrypt is suspect. The caller of these functions
also can take explicit action in the case of a failure.

It seems like the same guidelines should apply here. On the x86
side we've also cleaned up cases where the return value isn't
checked, like here and the use of set_memory_encrypted() below.

Michael

> +	return page;
> +}
> +
> +static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
> +{
> +	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
> +}
> +
> +static void its_free_pages(void *addr, unsigned int order)
> +{
> +	set_memory_encrypted((unsigned long)addr, 1 << order);
> +	free_pages((unsigned long)addr, order);
> +}
> +
>  /*
>   * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
>   * always have vSGIs mapped.
> @@ -2212,7 +2239,8 @@ static struct page *its_allocate_prop_table(gfp_t g=
fp_flags)
>  {
>  	struct page *prop_page;
>=20
> -	prop_page =3D alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
> +	prop_page =3D its_alloc_pages(gfp_flags,
> +				    get_order(LPI_PROPBASE_SZ));
>  	if (!prop_page)
>  		return NULL;
>=20
> @@ -2223,8 +2251,8 @@ static struct page *its_allocate_prop_table(gfp_t g=
fp_flags)
>=20
>  static void its_free_prop_table(struct page *prop_page)
>  {
> -	free_pages((unsigned long)page_address(prop_page),
> -		   get_order(LPI_PROPBASE_SZ));
> +	its_free_pages(page_address(prop_page),
> +		       get_order(LPI_PROPBASE_SZ));
>  }
>=20
>  static bool gic_check_reserved_range(phys_addr_t addr, unsigned long siz=
e)
> @@ -2346,7 +2374,8 @@ static int its_setup_baser(struct its_node *its, st=
ruct
> its_baser *baser,
>  		order =3D get_order(GITS_BASER_PAGES_MAX * psz);
>  	}
>=20
> -	page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, orde=
r);
> +	page =3D its_alloc_pages_node(its->numa_node,
> +				    GFP_KERNEL | __GFP_ZERO, order);
>  	if (!page)
>  		return -ENOMEM;
>=20
> @@ -2359,7 +2388,7 @@ static int its_setup_baser(struct its_node *its, st=
ruct
> its_baser *baser,
>  		/* 52bit PA is supported only when PageSize=3D64K */
>  		if (psz !=3D SZ_64K) {
>  			pr_err("ITS: no 52bit PA support when psz=3D%d\n", psz);
> -			free_pages((unsigned long)base, order);
> +			its_free_pages(base, order);
>  			return -ENXIO;
>  		}
>=20
> @@ -2415,7 +2444,7 @@ static int its_setup_baser(struct its_node *its, st=
ruct
> its_baser *baser,
>  		pr_err("ITS@%pa: %s doesn't stick: %llx %llx\n",
>  		       &its->phys_base, its_base_type_string[type],
>  		       val, tmp);
> -		free_pages((unsigned long)base, order);
> +		its_free_pages(base, order);
>  		return -ENXIO;
>  	}
>=20
> @@ -2554,8 +2583,8 @@ static void its_free_tables(struct its_node *its)
>=20
>  	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
>  		if (its->tables[i].base) {
> -			free_pages((unsigned long)its->tables[i].base,
> -				   its->tables[i].order);
> +			its_free_pages(its->tables[i].base,
> +				       its->tables[i].order);
>  			its->tables[i].base =3D NULL;
>  		}
>  	}
> @@ -2821,7 +2850,8 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
>=20
>  	/* Allocate memory for 2nd level table */
>  	if (!table[idx]) {
> -		page =3D alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(psz));
> +		page =3D its_alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +				       get_order(psz));
>  		if (!page)
>  			return false;
>=20
> @@ -2940,7 +2970,8 @@ static int allocate_vpe_l1_table(void)
>=20
>  	pr_debug("np =3D %d, npg =3D %lld, psz =3D %d, epp =3D %d, esz =3D %d\n=
",
>  		 np, npg, psz, epp, esz);
> -	page =3D alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE)=
);
> +	page =3D its_alloc_pages(GFP_ATOMIC | __GFP_ZERO,
> +			       get_order(np * PAGE_SIZE));
>  	if (!page)
>  		return -ENOMEM;
>=20
> @@ -2986,8 +3017,8 @@ static struct page *its_allocate_pending_table(gfp_=
t
> gfp_flags)
>  {
>  	struct page *pend_page;
>=20
> -	pend_page =3D alloc_pages(gfp_flags | __GFP_ZERO,
> -				get_order(LPI_PENDBASE_SZ));
> +	pend_page =3D its_alloc_pages(gfp_flags | __GFP_ZERO,
> +				    get_order(LPI_PENDBASE_SZ));
>  	if (!pend_page)
>  		return NULL;
>=20
> @@ -2999,7 +3030,7 @@ static struct page *its_allocate_pending_table(gfp_=
t
> gfp_flags)
>=20
>  static void its_free_pending_table(struct page *pt)
>  {
> -	free_pages((unsigned long)page_address(pt), get_order(LPI_PENDBASE_SZ))=
;
> +	its_free_pages(page_address(pt), get_order(LPI_PENDBASE_SZ));
>  }
>=20
>  /*
> @@ -3334,8 +3365,9 @@ static bool its_alloc_table_entry(struct its_node *=
its,
>=20
>  	/* Allocate memory for 2nd level table */
>  	if (!table[idx]) {
> -		page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
> -					get_order(baser->psz));
> +		page =3D its_alloc_pages_node(its->numa_node,
> +					    GFP_KERNEL | __GFP_ZERO,
> +					    get_order(baser->psz));
>  		if (!page)
>  			return false;
>=20
> @@ -3418,7 +3450,9 @@ static struct its_device *its_create_device(struct =
its_node
> *its, u32 dev_id,
>  	unsigned long *lpi_map =3D NULL;
>  	unsigned long flags;
>  	u16 *col_map =3D NULL;
> +	struct page *page;
>  	void *itt;
> +	int itt_order;
>  	int lpi_base;
>  	int nr_lpis;
>  	int nr_ites;
> @@ -3430,7 +3464,6 @@ static struct its_device *its_create_device(struct =
its_node
> *its, u32 dev_id,
>  	if (WARN_ON(!is_power_of_2(nvecs)))
>  		nvecs =3D roundup_pow_of_two(nvecs);
>=20
> -	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
>  	/*
>  	 * Even if the device wants a single LPI, the ITT must be
>  	 * sized as a power of two (and you need at least one bit...).
> @@ -3438,7 +3471,16 @@ static struct its_device *its_create_device(struct=
 its_node
> *its, u32 dev_id,
>  	nr_ites =3D max(2, nvecs);
>  	sz =3D nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1)=
;
>  	sz =3D max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> -	itt =3D kzalloc_node(sz, GFP_KERNEL, its->numa_node);
> +	itt_order =3D get_order(sz);
> +	page =3D its_alloc_pages_node(its->numa_node,
> +				    GFP_KERNEL | __GFP_ZERO,
> +				    itt_order);
> +	if (!page)
> +		return NULL;
> +	itt =3D page_address(page);
> +
> +	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> +
>  	if (alloc_lpis) {
>  		lpi_map =3D its_lpi_alloc(nvecs, &lpi_base, &nr_lpis);
>  		if (lpi_map)
> @@ -3450,9 +3492,9 @@ static struct its_device *its_create_device(struct =
its_node
> *its, u32 dev_id,
>  		lpi_base =3D 0;
>  	}
>=20
> -	if (!dev || !itt ||  !col_map || (!lpi_map && alloc_lpis)) {
> +	if (!dev || !col_map || (!lpi_map && alloc_lpis)) {
>  		kfree(dev);
> -		kfree(itt);
> +		its_free_pages(itt, itt_order);
>  		bitmap_free(lpi_map);
>  		kfree(col_map);
>  		return NULL;
> @@ -3462,6 +3504,7 @@ static struct its_device *its_create_device(struct =
its_node
> *its, u32 dev_id,
>=20
>  	dev->its =3D its;
>  	dev->itt =3D itt;
> +	dev->itt_order =3D itt_order;
>  	dev->nr_ites =3D nr_ites;
>  	dev->event_map.lpi_map =3D lpi_map;
>  	dev->event_map.col_map =3D col_map;
> @@ -3489,7 +3532,7 @@ static void its_free_device(struct its_device *its_=
dev)
>  	list_del(&its_dev->entry);
>  	raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
>  	kfree(its_dev->event_map.col_map);
> -	kfree(its_dev->itt);
> +	its_free_pages(its_dev->itt, its_dev->itt_order);
>  	kfree(its_dev);
>  }
>=20
> @@ -5131,8 +5174,9 @@ static int __init its_probe_one(struct its_node *it=
s)
>  		}
>  	}
>=20
> -	page =3D alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
> -				get_order(ITS_CMD_QUEUE_SZ));
> +	page =3D its_alloc_pages_node(its->numa_node,
> +				    GFP_KERNEL | __GFP_ZERO,
> +				    get_order(ITS_CMD_QUEUE_SZ));
>  	if (!page) {
>  		err =3D -ENOMEM;
>  		goto out_unmap_sgir;
> @@ -5196,7 +5240,7 @@ static int __init its_probe_one(struct its_node *it=
s)
>  out_free_tables:
>  	its_free_tables(its);
>  out_free_cmd:
> -	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
> +	its_free_pages(its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
>  out_unmap_sgir:
>  	if (its->sgir_base)
>  		iounmap(its->sgir_base);
> --
> 2.34.1
>=20


