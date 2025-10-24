Return-Path: <kvm+bounces-61016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B47FC06019
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 13:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E5781C269CE
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 11:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD435322A04;
	Fri, 24 Oct 2025 11:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Izc3GIWL"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010042.outbound.protection.outlook.com [52.101.61.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA2731280D;
	Fri, 24 Oct 2025 11:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761304599; cv=fail; b=u6akGlC7DLubN+TPSf9OFi8o5/4yJP2JQO29Td6tJEsvHDM8kvooB500uxn6ruPmZNE+Bnee3jBjZqrN7tzC8+e3MM0kPtD9OEID42LVCzE7Q75kbwlFguVz6OA3334EKFJkyAbGWz9vU7xfb0QNhzz+ZEe+La6rZc5gVfeKV+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761304599; c=relaxed/simple;
	bh=GznPFtXLiMpo7F5jttGKLZoynaiCcrE3DpAuG+sXtP8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hNiwKZwgHTCoI9B9GRctRJ10RYYtVoX0U1/V46v+mjGgrEd0K+pyHBM+1DsYGx56+An1RDuSmJmR/FPMzCA1fVt4VRG12ap5o5+DhYLZJt49crfXEU+oZ8/0/x26cE5orQ8aMj+AQxhMmbHK50s8fkQbCDiCI2tsUVtmdBy3Olw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Izc3GIWL; arc=fail smtp.client-ip=52.101.61.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PilYq75VVgOS2F3MfLxLichkpog8uvKtKXcT6H06XuU9/2Tgbclu90+Ciwz/NA93HXa6K30bmVAlXyzRLZmb8pU1N0Y1EL1F1946ZgY5AY0F5Jf1pw43qlfV8/iSABxUnk5BBOYbGz3psYIW89XYgpJOuOzBddZiVNT83zZNhjLCIdHFCre3KawPO+UsyqS3x4ImLwPhoZ/lHTJpaSpSQH/aaepILjhV+9DH6xsR59Gq6MR8GGyGGm0V4QduYmDUyCt3aFVHzX3tsoEAtsT/oh1VDrqd6eYaICvkB0+W2qcM1w1G5ON0aYxCVymEyaq4gJM/6FNrZl3WpgK5rjhdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GznPFtXLiMpo7F5jttGKLZoynaiCcrE3DpAuG+sXtP8=;
 b=pPXei/nuwWpBjaBF+IwBHLMGNgSc3JgJsaGNGzg2xklrkkHYQQvb+Sch8QIUKOEUEq3wsdp0Np6wLl+COb7pzpoGx8F1fCQD1H90C1CAAm5ZDCNCONKIfYuz5DrdU3EeiPyK3nd2vvS5x1dLSJdbYIi+RrRVNjTBLbysaRDkoYVW415S0ybCrsUTBd1Odk+nCeNDeM5aeoMw01JJ8kpaFpcUqI0O/SS2SOIQuVjRfEgQwYm4Zn3CHb19Y2RnBeoGWTxPKw5Ni/bVqM2TucK364DTc8bVJHacweJrzJXapBMv9QE4aSr0tP5t7yDDLtEz0E0YELyN/LDvlN6mHOH+Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GznPFtXLiMpo7F5jttGKLZoynaiCcrE3DpAuG+sXtP8=;
 b=Izc3GIWLCjCCQwlNmZavKoqW9fxoCF7/HH1kSnwrEX9wA3qKWHWZs7gqRiUx/EPMiusuM7zVODhE2Gud4yXpMmj/d2FfrTOPokbH1VvFgc62D99WWE3VSBphHRZ2gAuZMYMO/BxI8CEQFejHIZ3sHdVKsnSVBhYFQtHdQoCBvVlhsxWftoP5eaMKPj2fV/oSy8vRnk5MsuIN6OVb8flSxhmGvY0w/wLjZxDrtnFfFFkSFCxoO7+Fpug6XlVS96/AKMZ27uiWDLzK92Dsu2no9koO9FID4AXsVcGbyzKFpkC940A5S7ZvW/wujr5NRcLSGkl7/ubFtWmJxgryhmAGNg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 11:16:35 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:16:35 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi
	<vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "tony.luck@intel.com"
	<tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
	<lenb@kernel.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Topic: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Index: AQHcQnTHTYvFr6s4LEeMxWxMZV3yCrTMyzMAgAAD5QCAACQpAIAAPsYAgAP34AM=
Date: Fri, 24 Oct 2025 11:16:34 +0000
Message-ID:
 <SA1PR12MB7199E3D79881475B4B320F34B0F1A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
 <20251021164444.GB699957@nvidia.com>
 <3ss3epklrmwallhd3nih5qqzjk53dcgns5igudtsg4vnnyjyri@ektyavsup6wk>
 <20251021223850.GA21107@nvidia.com>
In-Reply-To: <20251021223850.GA21107@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM6PR12MB4138:EE_
x-ms-office365-filtering-correlation-id: 16bb60a7-6381-438a-1f47-08de12eecafa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?897t3vkGQyLaFclrfSgOi67KEPmTy0loA7KYZyPaake6xl9kpDUzHrgN2i?=
 =?iso-8859-1?Q?SK216kDZ7yrlDde6qgmhZ1siY58EvlnObOAEBaWJZZE8+BEX6aSqA/ol26?=
 =?iso-8859-1?Q?hZNfHlNoKhgGlsjEDV9tsQpF/xcZGBnx5tJiwuepJ1uAHqvy8Io8gF9Ky0?=
 =?iso-8859-1?Q?b02qRvXMDxuwhdLwNgr6mQRqk13qR8OOZ7VnpCbNtfFjdCAIqoiBkpZFY4?=
 =?iso-8859-1?Q?rlT7GLDrAAHSJsCBPVjNJuSXnuVZHT6jNWd1gi18ksrUAjUF0TkVfo67um?=
 =?iso-8859-1?Q?HDzJm/yU2DSyv2Bx+sPPXXDmnNSXQpNz+ZXDRdXRUx1nfA4s3DlZ8rNwa+?=
 =?iso-8859-1?Q?/wSiHQKFS6/yLfuIt6t6Ahm+mgP+mw8n0AgDBh7BajsMNsgItyclLdpsru?=
 =?iso-8859-1?Q?0WbCVyA6j0nBclUl2HcV39ECi5LGUxVbGDNN6H1wYiY2oKn2J/O9moNjia?=
 =?iso-8859-1?Q?phcNk49UK8qRh/qBcG2rkmdzoEAhKmlBkabvn8ZTDvd3pYlGTEUdl5IRHi?=
 =?iso-8859-1?Q?VdWEY9TIRckj+LNP2brcQfZI1aIHLczgyXrhnK5CorPEOne5rvSXhB6sU8?=
 =?iso-8859-1?Q?Ce2yf97Gi/Aq6k1KO/8sWG9lt7cXR3gyQmTSvtsoCHL2n0l1Uo6KOC8FAV?=
 =?iso-8859-1?Q?HJS+vhsOnGn4tg3BmhFl+VxhHawtiXzQDU+iENIeLPPGim3dW4Hhv771xM?=
 =?iso-8859-1?Q?nDmmi1L74qvylfvAx3zMf+aoQHfXxavU9EqIfVfkEIEZZdm23u8w5PB/ld?=
 =?iso-8859-1?Q?t62Fzu1xJkp47gG6jlniFn48qoT4SGQUho9fy2ZpCm80ZfTOOK9xlGsCyX?=
 =?iso-8859-1?Q?9exb3bLnS9T5+9rCSnELOHcEkqwObkb799FNlNDrR05CUMkU9fkM76eedq?=
 =?iso-8859-1?Q?mqnyGKxU7aAvI/Fo9MX9ET5re1QHLk4IUADKgTZLldV0Yxxwn8YPs9gq5x?=
 =?iso-8859-1?Q?RuFQ7TkKfwCr+KPv/gMwvGLV4mDVBTgdXGZS7Ver5avYwyoQjrjELHPyte?=
 =?iso-8859-1?Q?2wwI9iSn21PyR58qhf9s6qTck6WliuZ5r58WE+FtSS67yhPoG60wBDeaYa?=
 =?iso-8859-1?Q?hEeDsz1sTic0MstweyNfNHDj6JfRGavuF462oTskS4E+C+reMBrjepDLjT?=
 =?iso-8859-1?Q?odNSDg+lfrXmOhtHcaTJfB+6ymjt0RZRqtzy+Qq5UP+9Gok15ee+EJ+Ta3?=
 =?iso-8859-1?Q?LYAwCT/24qrdmzR47hAZaA6MWPCxxe056VDXngrTCUx17oKrvUioe/FgWJ?=
 =?iso-8859-1?Q?BAg2VB+3uj2NeX/vNaLQohdtsyIYgDxP/ifv4h4QF4Ybg9SuSRb2NiMCmG?=
 =?iso-8859-1?Q?zt9PJuAf+hdGFoILyc4a8CtTARSLMkbxe2biJRT1l/1gUh+sjDsou+rTW8?=
 =?iso-8859-1?Q?GeTmRUQrzTmwQWKAqKxXPtuQG77TxUb0DODNzQ5ONrJ+f066lm78KkQ+iY?=
 =?iso-8859-1?Q?uHUo9ygB+04VrgM3gYCfgB+2vq6a/u5e/uiaDyh8AQu12bWXH1eDJPjQT1?=
 =?iso-8859-1?Q?7wu/iDWYQ0lmGNyVzYZnWaA2ogJoZEomRAr1ltB3LGCC/Qu1TqQlT5WzQ8?=
 =?iso-8859-1?Q?xT8n2ZVZhlbRkBkJIwHCady6JR/j?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?frNSozMRIGMIU0qCjyL2wL87A0l/VWoJefcKOXFowgApyChdLlz1ut8ev4?=
 =?iso-8859-1?Q?fbu7b0dZpAOR5v16/mIpo2rDvlcCfXMopHzPbCwLzTRPYo4BczqH0QvaQb?=
 =?iso-8859-1?Q?B4rfn8e5p0v4l5t6a0F+3rFFPyz4fMfxty0IfHAzTkpU8Zxt392FJfzH+S?=
 =?iso-8859-1?Q?1f6oVMGGsw+K1tzaqJ0XAZA1TgoefCzeVtXZl9wjc0W58fHmMdrBjqVzbN?=
 =?iso-8859-1?Q?ujkr7cBIK+gkIDTLDv554Xkag97LchS+xvPxAXL/6f2uSXiuYvwzyzHC8m?=
 =?iso-8859-1?Q?FKF0lKu7MT9PEKjhn8aHfsx3soaHKNlb7JrsMWRrvVZ7vDCgGRJymsFxuc?=
 =?iso-8859-1?Q?WHKS3igzFFh1ZQNfV9gfJtrmvmTncE+iXv+WKGu2sEp2Ej/B2U5vn+YpTA?=
 =?iso-8859-1?Q?VDUlFR6d4/KNAqTqdemwV3F0fPNmi5PtvlGKG9z8MikHPEPfd5X2RvFL/p?=
 =?iso-8859-1?Q?ytELrER86ihxad+RNkl/B0lnkeDxo4sx4FRP0IVbx/md6dTjZXRtF/hiw3?=
 =?iso-8859-1?Q?ow/XCG0pfq7X1jGAm9b6xyhvO4uYqwh7cyZc/+bCsOg+0YrkHN3r68RS7S?=
 =?iso-8859-1?Q?hZORrBzka2gT95UqkPSMnNap67e/uPxSi7FJRRu2Xe009rmklw/FDqQLr6?=
 =?iso-8859-1?Q?CF7L/VknxxBBGdRvPJoihHIRfZdoomnMNyZrVYmtBkWATGgsPNhLNnUh4m?=
 =?iso-8859-1?Q?ZxVxauxdW5+7Ov97XCFuSt+fJyuCUynSYRO2Rrpmb/6IZxPIbrHeQjBZQo?=
 =?iso-8859-1?Q?NF+579hg2G5IQqqrpFcrI9lx1EalfR9+qe7BR/OI22YIYHE2aODYv8sC77?=
 =?iso-8859-1?Q?7Ktjjvqfl+d27H77DpUyNhma0OLtfaKk7k54vogDlMm7ZN5ns9lWHGoXlr?=
 =?iso-8859-1?Q?zsXxRC0cWJ1lJ/FC+7Yt8co/DlLuFvQvmb5CtyqD6YwQjPxigaj075KjPt?=
 =?iso-8859-1?Q?m3jHAE51OrevvuhnncNoEV7avYomUYqru1cuS7KOrWjM0T+58aq+a4Ukyw?=
 =?iso-8859-1?Q?ZIBdZWBMCSn9N4dhMVbUQhMTqWyxW0e9loT66TkanqnJQ3+DyAW0VOEW44?=
 =?iso-8859-1?Q?CwwJ5uoE3j7bPFK954mROItn6JqRzulF4mfLf+tp4DTMsKwL347FJXBBSH?=
 =?iso-8859-1?Q?cyuBpYM80gJ/xExjZ/tTJDZBglKqrruFv+CyC8e3IeSyL0pTmExfCM0oil?=
 =?iso-8859-1?Q?aaLM6J0yGnFUNiRsEif8NEqvf7GrRc8H1Tsf0wAXS/U2vZyG415qukCjlu?=
 =?iso-8859-1?Q?UOpCmpXBpVwYD2bWe8Elw+sCE7T9pbdOuuKl7BO9G52f6TcSvV0ZSTJHT3?=
 =?iso-8859-1?Q?93tCCwDWZrALfJWGv+h3soQaujvzdKRPVBQXw3QW/Jk2P+pipabc7NKmOR?=
 =?iso-8859-1?Q?T4s4Nu7Cnk1paPbGrTi2qBIB0jcxeyXauj8+K3oai+8Rg/f9JjkHMvLKoI?=
 =?iso-8859-1?Q?HkbE4g8csk0GCutAVtphuynEdyBvVqYE2o7DRdMxJy4fYZ+T+tnR79UAnH?=
 =?iso-8859-1?Q?hyuIfcD4GzwCoQuCt7UcHXavH0DW0NA+YSl3eMSyMJfWes/rkpiT1jOhiQ?=
 =?iso-8859-1?Q?un3bVGyDYKEY9qvsGHgX+IHjXxEg6uFk4aPF4vb78m7P5k/t9sFbJllGTp?=
 =?iso-8859-1?Q?n472+31J1kso0=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bb60a7-6381-438a-1f47-08de12eecafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 11:16:34.9630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aCJiuVjfYaTEOX9wPBssbhA/uoh0EUcCxsbRdtZycWpd6QxtDoN7fv4VMentpy/d+ASkbSJdF3GKj2ltv+HeJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

>>=0A=
>> Ah, I see.=A0 Seems like a worthy addition to the commit message?=A0 I m=
ean,=0A=
>> this is really a choice of throwing away memory for the benefit of tlb=
=0A=
>> performance.=A0 Seems like a valid choice in your usecase but less so fo=
r=0A=
>> the average laptop.=0A=
>=0A=
> No memory is being thrown away, the choice is if the kernel will=0A=
> protect itself from loading via userspace issuing repeated reads to=0A=
> bad memory.=0A=
>=0A=
> Ankit please include some of these details in the commit message=0A=
=0A=
Thanks Jason, Liam for the suggestion. I'll update the commit message=0A=
in the next version.=0A=

