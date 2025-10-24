Return-Path: <kvm+bounces-61017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF3FC060EB
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 13:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 65EBE58635E
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 11:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E891532D433;
	Fri, 24 Oct 2025 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ob62X4ys"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8728F32C31C;
	Fri, 24 Oct 2025 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761305186; cv=fail; b=kaz/X1kcBZuXj1vECbl5SgWvaUV0nTRIK4uDtB2BDuOPbnJyoZwWJuTWZN15D2TaK6ZYBMNnYuoFyNl6D5YS6jelygmOlkocNqHd5wszKF0h7PD3sttV1k6jd6nM91sdj0uH4NMire/jqXS627BUpUDu5nsd8KK+3fo1hcSm/mA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761305186; c=relaxed/simple;
	bh=45+2YkbGU+Ct3rHZVzpRzf6PM3+zUhOxO0lgUQcMT7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SMp7OPlnml3t38THnxV8byxNDsKl+hKnM+tsHlXoWsdWAThHDUeaYkMiLUXs/uGF25f9RI+LnEjgB7DFAaUYmfPKUPj3lbIjPRSWgmjFb1Byk4WVVdFAxUEvYxcMjObiNPT+CG8+/2cOH0MeuL/bl/6IbpK755RX1gYgGfRS99I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ob62X4ys; arc=fail smtp.client-ip=52.101.56.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJqeuFHRGQkn7tzFx3PUoGVOqZCMK2ra6XWDuW3nBQHVQ9czX1bGtd4PoTM46aAtjQZzrb3puxJEafAaWJtI+jIj3W8JHbkbyREm+vb3PDDcVtgNS/xvLWL33Y238s5Kr2pLjmWLu9+7ydv+WqNQrWIxyL+r7X4IC9Sc7Hd5wwwbblb+tPfHpTl1w9N4X97FPRWSFpdVsrqpeV0TtoMzx+advylwxN+fHxQBoE7denNxEXIqjt7zBAsFMtNAXsIqMEnWwODxAqP34j0sRxF+q9/B2LoQiLK49e1O6KXuqhHO3a2vmBsKoqWAj52ITW57aeBxZe9EbO7PmlKuogGEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45+2YkbGU+Ct3rHZVzpRzf6PM3+zUhOxO0lgUQcMT7U=;
 b=O2iF28bEqZm5DCzpXTOpCI2TJc5J1pynqeGKY6f9ddW2mSj00oFR9cMeW9jYym8tskkVNBIDH+AjaW9Du0mfIQF01N68cf7IB402K6Xq2M3Eg7gNTUbTKd7w/H0cns/tSg3Den/N9Ud9oK0ACHJJA+X7WexYbzsr+YzE9nO8YINSKONrGR0UF5PC+uMex4K0RvAOE0b3qDElA9OrbbZs+6og20G4/2saxd78QLhmIdGCMcA9m5NGz3pQHtlQvVApw7KyYFa5j9XBrC7gzJ1XMR0WLdZGKifRJvh5d0j0WmXmHrxsxNtY0k/XtbgZ+f0vkgninOwY+kHNhpD25R9YJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45+2YkbGU+Ct3rHZVzpRzf6PM3+zUhOxO0lgUQcMT7U=;
 b=Ob62X4ysXkjJsFBJmmaEGX+G8fVLy8qDaSHVU7WqzvyWuglUSVAo4RRqAvK8xemio2piLJet/LXu4qDpItCyFhnl06jjyVOEPgFBWFJ8wn5aNyo8JG10loxYXMgDmPWAAN199XKb9OyPRnrpx0pKaBi1w821UUvjv/VyMA7sR+JIEaNUMmnOd67L3cqqv8SMZyFLPrHoUdDHdgmQVZVAT2Vx9qRyx6FR0glBRRnNSsT+yLGlLC9VQHtTtLuKkUUWKn03Rsv/qgXXnc7zoNQZvVntE+pEIuXmWTk15QEC98NVoMfgY78QCoyio1IVYWscsxnzVi3kT/bOzaUeMCr2mg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM4PR12MB5724.namprd12.prod.outlook.com (2603:10b6:8:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Fri, 24 Oct 2025 11:26:19 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:26:19 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>, Ira Weiny <ira.weiny@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "rafael@kernel.org" <rafael@kernel.org>,
	"guohanjun@huawei.com" <guohanjun@huawei.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>, "Tian, Kevin"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj
 Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
Thread-Topic: [PATCH v3 2/3] mm: Change ghes code to allow poison of
 non-struct pfn
Thread-Index:
 AQHcQnTJ7CAM8GRhqkeBM99OaIj+UbTM1xKAgAABqICAAONpgIAAiRYAgALQuQCAABSJlA==
Date: Fri, 24 Oct 2025 11:26:19 +0000
Message-ID:
 <SA1PR12MB7199585DDC589EEFC23FCF4EB0F1A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
 <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
 <134e43f7-583c-48c1-8ccc-dddc18700d3b@linux.alibaba.com>
In-Reply-To: <134e43f7-583c-48c1-8ccc-dddc18700d3b@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM4PR12MB5724:EE_
x-ms-office365-filtering-correlation-id: d94683b2-766f-4bde-8df7-08de12f02749
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?l0Jwn0VdKBMjs7MhGOIxQi4Z4s7ihpqOzuVCUH0kkRHdBDsvypEdrxRomL?=
 =?iso-8859-1?Q?Msag28jjgDBYIBMiwOc5jq0jbA/Gq7u3YmbetxVj8at41BObPjDFjlOqD6?=
 =?iso-8859-1?Q?jAqsZWxPc+UcwDjJR512wn1le39Hb730RjEUaktXprz6bkn8aocWWRQmDx?=
 =?iso-8859-1?Q?tJxSKrmdqgHED4a7nXa+p2jDBWrI5T1ho0o26bXEJTqVJ2ASV//UQiGf12?=
 =?iso-8859-1?Q?zRUZV06dWK5lSFyQUIUT7WxIdtQJcjt4JQputb/Wwr4fN8co0Aj1DAqpfO?=
 =?iso-8859-1?Q?syGV25t0T3cNF+JUl9VjzoNhuRzxfN9h0nwRf728sm/eW/fMP0ftycwWQa?=
 =?iso-8859-1?Q?jPK9gVqjc+8g0iuycr/TITI0zgFmhIq86ZdEuPllIgQdqvXnH9u0Xo6D3g?=
 =?iso-8859-1?Q?UAvxJfagOgZEQTO+Wp8L57WuQvaRxLtnz0/h+1TEeYZrK8DZ3D5Uf1D6tS?=
 =?iso-8859-1?Q?S+VdGLftNgBugXChFSO2iHV45/o6brPRPNHj1WvW7n1P8awEtt86kJ3oZV?=
 =?iso-8859-1?Q?Zz+xj+OthVv+6KuxiKQKdOF0113rviwUHLdq8tk93qCt0M/87950Z2nzEH?=
 =?iso-8859-1?Q?hfgQ5lb7Nq14hkSbk/94IkD2e+OcdOoVeWQK6XRAL8jID8Cl/NTGc4Spq3?=
 =?iso-8859-1?Q?El+5jIlnX0PzLko5y0O99gBZQfd/CD5VIkUR9CXeXZB+pNf3EA6nDri4pq?=
 =?iso-8859-1?Q?EUeKihUReJGY/VHd0IvPV//HuR6GxaDHxQPikAyOpRqIY7FrK5RAlgg00+?=
 =?iso-8859-1?Q?hERGzpKehMwD5u99eJdbkqEbW8VtF3FuUkbmexD1aoqRGZGjMAF6TPx94o?=
 =?iso-8859-1?Q?iuMvK1NyL1+zw7f6LdVLL1X1Di5ve3T4KgUUCETJP0sdD5SZFYgaJj/s6b?=
 =?iso-8859-1?Q?SY4PKHMu2nzDriUbx4HYx2eTdISYgKap/qvakMoZEFZLxy6MwgAXXbovL9?=
 =?iso-8859-1?Q?pZ2yWWUzlSxPEYN3Tjva5i0DgWs04m95VudEu4ZctBZptHJwZ5lXIVmSzB?=
 =?iso-8859-1?Q?csdP6yIcrV24pghzRV3MwgCZnX3xK/DWVCbiSQjY1cNWTWgjqGWTCBpr9/?=
 =?iso-8859-1?Q?+deVFmE6w/cSHBRMPg1GK0dMcO1yQXOISFaixccVwAPyP9szFlgB6BvU8D?=
 =?iso-8859-1?Q?jxApVpjpRyntiyRxJVQwTED+09v+d8dLV7ixOLgkCARQwLs9McpbLYTbfo?=
 =?iso-8859-1?Q?mDKJfragMDl3QBPbJlTkhPKXUK5w5pjV0/oVwMCfoYXEVQBYOPTPGWRIZR?=
 =?iso-8859-1?Q?IlFcXLzcsop9jeMGcGQAAwFKp3N/e3gIkEuisKpfgIvCUJhphPUWu9jlb0?=
 =?iso-8859-1?Q?ibvNSy6HKDF0Wt8qGVIoBDiGvwFRhwi2U9hQrJ9yem7+Rq074mN0vymwBW?=
 =?iso-8859-1?Q?t1/ZfnHTk1K+cpMJkLPOf9tGF7DNHjilbnZD7wKQdgfx/Ep0TvWNEIsCAN?=
 =?iso-8859-1?Q?GCMpNQKCoBXdUhL/rfzDNTnnz9ouqydeaLy7wSZAyEIYDGnB39Rx+4UQFe?=
 =?iso-8859-1?Q?0WT/7MZU7jI4LBlnLGycv+PTVx7hwjxNj0I+3FFf/60bR8aMcEn1QHtJf/?=
 =?iso-8859-1?Q?D9bjk3cE3muw2pUjGnA0/o9ziZ/4RrPgrr29dN0K2YPOAU05yQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?TPbukBI15mAyK21vvnoqs1W6liQIHJJwtKCQ2KiNzo1aJmn5o9efx44MHJ?=
 =?iso-8859-1?Q?oaPhG7WeSKNdFD1pFH1RTCuHYkErRNXWRXRhy2EuLeB3zAfaKa+3kYHTPk?=
 =?iso-8859-1?Q?KdO4jiPHyI3DBRCm3Rszr7vB3+9ryDL/SwAwgK/WRjsKho4yA6h9aO2Yje?=
 =?iso-8859-1?Q?P1UU4VQeoRuR5XYsBpINUjktU/Umnwc+mVsWy+WKUNBVsQ7s0dIke44QaV?=
 =?iso-8859-1?Q?PanIu7XtBEuEp4ZqpWVWwK//sD+KyqLwEaOyth3RAIdpFyfju9IYY/9Q8I?=
 =?iso-8859-1?Q?E80+gTOCBp4atGnG8NUfraxqhE5v5DtLu11EC5q5/LdXBj601Oacv0tuP5?=
 =?iso-8859-1?Q?ffhXu9L30NE5xyz2X9QaV/En0FQzGnJlcddd5khoY/LPnD2b0qQkgATOsx?=
 =?iso-8859-1?Q?5AZ6pkeEo3mu5l9TlwhtYVpagH6mYG315uD2J3Hy3UkFAxIM+7QpFAO/Tv?=
 =?iso-8859-1?Q?vgHp9pkn5T5oA1NNxb65iLQlakwthU6cXOW2Obm4VsgGWAfv6AnU8P9HvK?=
 =?iso-8859-1?Q?tSQSP/WWts7Hd969ljZorQqb7UAbdggnX2YtkbI2aTByrfBrpXPTmndCNg?=
 =?iso-8859-1?Q?RqRTsiO087ZBnI9xG5TPC4kPmPPTXI/V6WFAnez3MDBZLNQO5pwLL6BHeZ?=
 =?iso-8859-1?Q?+NSHVmX8PQ+4eqyX6i0+EFWN74IvXhrHY9hC6GGuKIoEnSIUuhFhK5a9ij?=
 =?iso-8859-1?Q?bnx3Mx/wlDNg5TTgNIiLIPzRo4Q497U7/98KusnZ0eM8EF3w/WO8YOSqMB?=
 =?iso-8859-1?Q?72YM3Y5czKfEOocVnhHM4cKLwPyI+gXNxDdgVPVUoBMPveXC0F93pwB3Vc?=
 =?iso-8859-1?Q?PdIaLOYK/1l5Q4rR1swUj6uLQp3/bhfIIOjR6yRRhZ04D0Xn4DlLVXFhMq?=
 =?iso-8859-1?Q?CxzT5luX0Iee/RkC5NltX6MH+VTi8Z8fFd0YpuzXpT1d/L9J7WyTeEfQaL?=
 =?iso-8859-1?Q?x78v83MeU2QUtlJ+HoD66KwnGXjpt53hlRbomuJSELKcDrBHliU7v6fZT0?=
 =?iso-8859-1?Q?lbYgyJcjk1e2GsF4IpCR8CMMJU+w/NLrkfnmtaHiV8zaQlKgjnd2Usc639?=
 =?iso-8859-1?Q?ogMb9Q1SfBP5IvEcg5C8ZFZEyXFDlMdHNG5yK61Ye34FCQWanz3EcXzNtO?=
 =?iso-8859-1?Q?uxSTe4xwiAAzUpDfgqhMuhltyjkuWi2vQt/zV/pqZ8SVBLG20+OMLKbEBw?=
 =?iso-8859-1?Q?qmA9YI+aSYSfKIn90n2GEjGJemg2CRb3i44tbnyWsHmPRCL5zrXQcDR7FL?=
 =?iso-8859-1?Q?COsFu4C7kWZpjz/GAzPdaNCdcvykVDGYr57HJx2CIgqWqJE8b1MXnqZsQC?=
 =?iso-8859-1?Q?ndO8RiBR14AQMwWIRtmhYEeXjsFxyE6b2BQLACBxd6m9ratjtLeBxcEl8w?=
 =?iso-8859-1?Q?LZVGQkIF1NYSY2ROLUrHGxqCcGgMYJdRovj7Ho+izxceKB8cDjnM9uBhpK?=
 =?iso-8859-1?Q?b0VpFfuhTKSf5cTn0n9rKTAjUI4dme2Uk7BXGjG7Ii2Ji11i3qWY5mjD3H?=
 =?iso-8859-1?Q?LofqNa51Di1TZBCYshP12bDr3Q6AFKqLBpfjcXK9fl5U3ou/GB9iZygy5e?=
 =?iso-8859-1?Q?9pcVytLX+o2x+uwiwiBIUuJccVtSF+ZpE/O+KHlv/rkyfTgkc7ITQYxEcE?=
 =?iso-8859-1?Q?1Q5aAnXAlOtxw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d94683b2-766f-4bde-8df7-08de12f02749
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 11:26:19.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOH2L08VzvhMGnNDMwb9Xu0NXUuIHCkzQJl5vpD1Vo7YM/KSivf9EKZwH0NW5PJnQHspvr/A1jawUyD2lXtb0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5724

>>> IMHO, non-struct page PFNs are common in production environments.=0A=
>>> Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memor=
y=0A=
>>> managed by a separate VMEM allocator.=0A=
>>=0A=
>> Can you elaborate on this more?=0A=
>=0A=
> We reserve a significant portion of DRAM memory at boot time using=0A=
> kernel command line parameters. This reserved memory is then managed by=
=0A=
>=0A=
> our internal VMEM allocator, which handles memory allocation and=0A=
> deallocation for virtual machines.=0A=
>=0A=
>To minimize memory overhead, we intentionally avoid creating struct=0A=
> pages for this reserved memory region.=0A=
=0A=
Thanks Shuai for the explanation and providing the "Reviewed-by". We use=0A=
the PFNMAP for the similar reason to save on the memory usage by the=0A=
struct pages.=0A=
=0A=
Also as mentioned in the 1/3 patch, I'll move this patch to the top.=

