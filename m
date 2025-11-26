Return-Path: <kvm+bounces-64592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6EAC87F36
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 04:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78D873B4937
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 03:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5D530E0F4;
	Wed, 26 Nov 2025 03:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b5xPUSyu"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260E30DED3;
	Wed, 26 Nov 2025 03:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764127621; cv=fail; b=prlIoDk4cpPpXylkpzeDy1B2BKf15iRG7AiCXVBfoF24x7cwX/BojBeGMwwMq9SnZ/PO9GfRzCT4/M9PSZEH/HdICfFPpliLfFEQs3UK/6/a5KQOhbLC6Ob+enq6/gnMQNd4Xhts2m3+kshjW9RxW72CAogg/zDEj044Z5WkINg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764127621; c=relaxed/simple;
	bh=5nibmaqZmR7vw+ZokMR9N2GL6xxc1oV80dk8wP56Wqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MLkRpoFo5WX1AeDWjYCpNrEDSc3+d1rExcwDKdMMhKZQLMh+OCTimbdBUxJri+//CljScg9fPdKyW2Yymyk+qNbzDppMGzGCI8p9ZikH89z7PKGxatwxIY5G81ZXVCXWLytLU6/03+NY5HQ0MmV/297mqKa0ciP/Y2/hfOLtDQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b5xPUSyu; arc=fail smtp.client-ip=40.93.196.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0CfiHtp1vK/tiFDIV6p7oA5UF4foxvnSfGQBHI8dxaNElZNOjMEZe5pYskgkTxJ93vmqxIy1eFHLlGhm1im72BswKg9C4HUs9HpGw7zTXihCqmhY0EhD53O3+LN4KRsGOH+Fc2fISIFNwivDGNaEI+t+vDHlp4MPkEyL8oL7Vh2Rw6RRujNq0MZvlct/7Cmc2fYSJ0rA8MP9uOEtP88ObnmwB0EFQh6Vx6NamQLY/TPILOy8FoG9sbDpCSb1U+vwylhjJ/NaddKlCvvlT+2/gssO6tbQg8iUKQhl46GylNkojVGQ+SFVgkJhU8mq9whHb/3T7y+S23aYLOXdWfn5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nibmaqZmR7vw+ZokMR9N2GL6xxc1oV80dk8wP56Wqk=;
 b=vDto8QOl+52MM5n9wKNIa1T5nPdNoHXc56iOcyqJJNuVXaUPlNmmQ+RFFrvqVDNpEe8uvDMF3J7vxN6tBOhuUjtWmXPFmqCrNezlb7aHStwC2DgP2F1L0qwjHe9g7SheJnBA8vdyVTu88ep1e3WMK035+OlLcupY7GOg5HUkiCO78eHzN2E5eTkJKtu3EXzEyhguvMvLsuJTGrGwj2t3aqYCDpyOYLPXQh0xJ6qhtDLwzFrmJDk3Vcj724ITXsB5A7xwperIrRwHpgiNbvzcg9/5Ia90JzPwcqubXqqVe29rosRNXMWEEKHvjIPhdc0w+EM6h+z+gnf0dQFWJ7AkEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nibmaqZmR7vw+ZokMR9N2GL6xxc1oV80dk8wP56Wqk=;
 b=b5xPUSyuyYzJUJNCt0kNEMRuJmmjMMVhp//IIzcM4053e0Qq7+JqWXHMqKRUu81hNLzQmQfEvJL0HD+Zt4uDdzPVuVpDYN4bdW7v4PE/PR8Oo3nchVrxriiKrP5c7RXQxtMLt9v+fJb/dPlhe+CprYDnjusinm1lrAvsLZODFwiMKIWpiWpxRKOKU9lGcG84rl89pvcgxi8jhthkNl3tTj8DN2WiO2Gxy2TYHO/rJBgr1PGTh5EXYWqBzb2GDSvkIZh/5w0T0D20uGLTaktU6TUSJAGPvTpDZWzpdmxEmYB5Sadw9FrB1FYbjVKwmkNqxtHZr9QfMZJmYTaaAPRhcQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA1PR12MB8466.namprd12.prod.outlook.com (2603:10b6:208:44b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 03:26:55 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9343.009; Wed, 26 Nov 2025
 03:26:55 +0000
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
Subject: Re: [PATCH v6 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Thread-Topic: [PATCH v6 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Thread-Index: AQHcXjE+pHylMalMgEu5yOv1Zq9VdbUD3oaAgABtpkM=
Date: Wed, 26 Nov 2025 03:26:54 +0000
Message-ID:
 <SA1PR12MB7199DF7032D570B5C610FD60B0DEA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-6-ankita@nvidia.com>
 <20251125135247.62878956.alex@shazbot.org>
In-Reply-To: <20251125135247.62878956.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA1PR12MB8466:EE_
x-ms-office365-filtering-correlation-id: c2b1899d-3ae6-4ef1-2a6f-08de2c9ba5fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?lNcICzIquqAu43dlpnlK+QUrVpBTNp0gnEYCIEXIYbmIfpgGd+IT/Ys651?=
 =?iso-8859-1?Q?IGVEj/8QariRmjk7jJQ+uGf84eEnqMihx4dig/s0M1S+IWrvAhMINANzoD?=
 =?iso-8859-1?Q?y2iHgEcCJDWhsUeetGwQzA8As3c45acuHkDX+YiPpcHKHCbZQSOIX+C+Fv?=
 =?iso-8859-1?Q?F0eTcVoLXcjuLC7V321/rdOLqOkiYTKg/UCrDFwV6N31eZUAb+0f6ZYKcD?=
 =?iso-8859-1?Q?DJtAJ4mSxwx5qgnHsoAmixXFQ4zqX0xVL40QiK6/2gAmVXDKHWvAMyOJTJ?=
 =?iso-8859-1?Q?vE5Vmp23VyZizk/Ra3NDRBg7N4eF9IT7BQdA4ucGIM5G+Xh1qEf1NhwvJk?=
 =?iso-8859-1?Q?WbuCPMxVU4qS8Bs8YXGLSJyONQ+qxrnY2k+E1rHuS0p3Hsj+D1zv30KHPj?=
 =?iso-8859-1?Q?aPnD10ijiIihLwDRY1OrlN+oYN3lo8xFs1YMYgvJ+HV/M3sCe9e5x76b9w?=
 =?iso-8859-1?Q?jH9ITbWJ5FXMpoHK6r+1z7cXbPjnJcc6eF1DSiCB7dN+ZpZbELM91v7Foz?=
 =?iso-8859-1?Q?37pQBDt8JTelrJaVx6Bu4ghC4Kr2FpVCZbUyLW5Q5Q45UIm8pgVfNX6U9d?=
 =?iso-8859-1?Q?uryIPre0PC3AdgBMI/QwuIPMW+a3xwT0CNLAYL8KW6k6kQhrb5za9C8VW1?=
 =?iso-8859-1?Q?VUxauVal0282JJuxBElpDv6zTJswr2zLDvE98+3H1jYRF0CN56mtjcqOFH?=
 =?iso-8859-1?Q?RcuEzLTnVxT+PvAWCVJ2FXSurWqsQjaj8lbr9Zbq/zwHeog2GU84P4y45/?=
 =?iso-8859-1?Q?ESNFxGmBg2dRIHjhRSKzcn4RDYqiPyYZLYijXsrNNhKx0YVatwbfdHSNjo?=
 =?iso-8859-1?Q?wdP1r6305ZPxAc/ltDFOjgRsCnen+hyhx6T2a3MhRheTxwvF8lRtXrkvGk?=
 =?iso-8859-1?Q?P3+kAUe8bEOqAU855y0EHJ9uWgIAINqYQZJxTYR8UGuRYdnsNHjv0ldT3H?=
 =?iso-8859-1?Q?gka5fOgvRaZtBn9eYeC9c3yju6fTJkOFZEQ2WpZPVwIUblC07UHWLUbkXw?=
 =?iso-8859-1?Q?7HCxVNmkqJwTWDbhg5V97T0cw7a5AgpdsJCqisxQt9gOmWPF/kN8s2OBJP?=
 =?iso-8859-1?Q?Nn78MO2N6rwAufnQP/TiU6IHVsXhwt8vg11P/silQMXSpZSTinXTmxAp1z?=
 =?iso-8859-1?Q?3qWJz2ZRCpjvu0aJcTrBkShs1Lxv88yxn4Tpbhw/RToSAoARC+Wko9aUtu?=
 =?iso-8859-1?Q?4Y1wWp2rGi+ogjpeyNsk/PSg++MYHWLakoSRX/QZ16+lGs94Ww6cmVDJf8?=
 =?iso-8859-1?Q?2FbSeIYnuxlfzRJUGp1S2pShT22DcjSjt3ymgg6tof93a4GsZywbt2U+yC?=
 =?iso-8859-1?Q?4GWASYlLMmL8ugD80ywymQCHM9pYwU8fI7hROEzJxRCJTqbitI6TjNZvAf?=
 =?iso-8859-1?Q?aN/cANQFDBb9K7anAjx4r5fArGUSGJXbDXyQW9MZ8n25oDyLYC+jNFB2Lx?=
 =?iso-8859-1?Q?7ZBOTcnP0PFRWUCTMSAIumnMoVy1FIKn0RXdA5qKdaPSUXTqqb7GR8fq4A?=
 =?iso-8859-1?Q?jFgwfIw+gHTXs2PDuXw7jQ3KD+P60a0PlGkN9+zQkfRqo/+cCZ6t/wxTFA?=
 =?iso-8859-1?Q?o22Bo5QASh9PEAqaPBxG7yG4fXTX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+fyXFiAejgYz+Ql0Yf1R19DFEy9/4vgXGRd/9d2QZlkaHZmRoO9kDhu4pf?=
 =?iso-8859-1?Q?audL9YpjMO9eEE7peHT41HKTNXguBUyNDsXEn/3P5wMMTXVC+Tk5KiL8Oz?=
 =?iso-8859-1?Q?IM6Po+uvlcVBOM/kaa37pRTqsaSHqaGTKHK8vKUjE55hHqPsGXfahqsnpd?=
 =?iso-8859-1?Q?/I3qn8Lw+pSrFvzjs9UKjjCIPTOU5wOMMort3Jx16k/LHwF50nphC+7uzc?=
 =?iso-8859-1?Q?KT3x73ZLDyNoyUtpRAKiS+3DSj3wWBLpKKsJ0m3U+zoTL8Au4jRhQXDJdi?=
 =?iso-8859-1?Q?8HUFr0GQcjN+NVg6F1JqgIXAq3ZUTI+EdPpkuUDGidbkxUdwNXnY7Cw14a?=
 =?iso-8859-1?Q?q0dpWGV7GlqTosrfEVyvhYTQ6mFeawWTQPA5t92PcbW5Aob2L/XHAbc7w5?=
 =?iso-8859-1?Q?+w7OvuDtiIArLxeZFtmH9wBUY9aTrg5GFOVg3p9NBV/VW33FH1ZPyVOnOp?=
 =?iso-8859-1?Q?cgSwzHXPm4eU13EmiT6gnG+INWtNhoG5rKzXBdd7sOPyWiJyP1THhhqsb6?=
 =?iso-8859-1?Q?1H/qNDncJ4Nry4SPbrS9CwbkuKAjhSFdHn1jXeAlw0JtfRhV5Ia7aZzLpc?=
 =?iso-8859-1?Q?xW/kVRNqjinzyxAyb2cJ+cS4Z3D0UZ1Q9sRh35omyHSJkEmd+6GngpEJ5n?=
 =?iso-8859-1?Q?trN9Is9jFUOJkJi/J7ShSrHmxRAoTUA3nE5/a2PJDQE+4nwCA9jbI5/8HY?=
 =?iso-8859-1?Q?F+Ld1+q+jjocBDNKhDpDFvv5Ql4laXYWBA8eYP3S+ZBSy1nuJtx2RfgFST?=
 =?iso-8859-1?Q?eFczdRUw34gDuxDo+Pr2DPIQn7O2Mqmml/jMDnvtff5LlMhaeuUzV0vs9g?=
 =?iso-8859-1?Q?iric9akk5IcvF0MCTdCls0ocWpx9CvEhzmNHSGXZAkMZdul+cyKJKJe3ME?=
 =?iso-8859-1?Q?3C3eQYUoC/vUftBB+PLdWkD/q5jAufqoUWRqaRz+u/BkmcMZkcBaQqeE//?=
 =?iso-8859-1?Q?l7stYuSrdMgHiMOqgrmlpbIOJ4s6hLjlK1Ty0zpFZJBfo/8daOd6OdhJA8?=
 =?iso-8859-1?Q?Bxy9Fqb6d0VeElXFtxg0u/vlPnmAkLdD+4mlFKOW1v8IMF2AV7Zbpnc2iE?=
 =?iso-8859-1?Q?nOoE3ys7IwQEVP/IrdPFbrqszuH7hjNHJ3ai0MYXuyFjXTiNg71LN3OFSg?=
 =?iso-8859-1?Q?RH6Yc0upcSNIv5Y0H6ykKjckpfzRMYmarrO/rQ2uj0Y11ao/F0w6Tz+grz?=
 =?iso-8859-1?Q?JtS6552FYQaWlCD5KkGCfzwl5G2SphNmKh2ed3SMwWDcCWi4EKM2PaPKcF?=
 =?iso-8859-1?Q?OWeO7O7rUX+K0zULTnNy1hmFbOndT7vghOIBMJ569g3Nw7ZsdxHo+bbSC3?=
 =?iso-8859-1?Q?d2SUhGyegI2Uvg37JardMDBrlfyboeImdH2BQMVDDpo70a1UcG7BI7XZxf?=
 =?iso-8859-1?Q?+5FcAJNAhmzpKYl0MBjJkRHTzpOParfCfTSjR+tkdSzEHt9F5NKEm4/N9T?=
 =?iso-8859-1?Q?60dGdLcRnQq42cAz8fNQImF3XNu3UowIaTKKda38kpQDILyyD3oeERUYiS?=
 =?iso-8859-1?Q?PTFa9bDotq1b2S1Im/2OiWsAAtet23jcpr7IRD6syv+hhXYI3c7qUUXxxT?=
 =?iso-8859-1?Q?tcVM21G6QK5qfTkAT80S8gXLAlCcfZhCOVobmV57vbccQy/olg9QlIIIGk?=
 =?iso-8859-1?Q?en8nqrvWNDVQQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b1899d-3ae6-4ef1-2a6f-08de2c9ba5fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 03:26:54.9420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/9VYx7SzwM6+EMzFCLunACAkjn0OSLngnyr9uezH05/sB/AWrrtUtPwUQoVfoONTU3ecWx/hKi2oHYmrgtGOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8466

>>=A0 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);=0A=
>>=0A=
> /*=0A=
> =A0* Comment explaining why this can't use lockdep_assert_held_write but=
=0A=
> =A0* in vfio use cases relies on this for serialization against faults an=
d=0A=
> =A0* read/write.=0A=
> =A0*/=0A=
>=0A=
=0A=
In this patch or the next where we actually do the serialization with=0A=
memory_lock?=0A=
=0A=
> Thanks,=0A=
> Alex=0A=
=0A=

