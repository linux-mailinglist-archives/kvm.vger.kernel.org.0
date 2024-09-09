Return-Path: <kvm+bounces-26092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E48F970C73
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 05:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC4381C21A48
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 03:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95581ACE00;
	Mon,  9 Sep 2024 03:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D+pvAa9O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FBC18633;
	Mon,  9 Sep 2024 03:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725854192; cv=fail; b=kXCtWxRI57+LvevAKiR+4QKp5GS3NNnjptFwAPW6uCUvCHTc49wZ1F6CpUw8n18fFYeZKrTPp7YKU3deYaTb4BTXiMKazCbp282iXsHtufYkCRiJ74qQcmv+AOUgrlA8W4OSridnfOvTiqtTX+JRTucNafl2QSAZQswVLRaT50s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725854192; c=relaxed/simple;
	bh=6ia/i6rrF3Y2ocXqQZH1nsk5ydssc63BFpWVmIJpsdc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZAo8b3kOB8Y3Qb85oaKzR/N4oB+AnGDzKsji/2lPtUi0Ct0Fm59nK33TzKsq3muLShZ9/DYELIkl3LqaLxz54y+0vzmSM7p6qOnHPBppWms2IhZPGQfim9kbOzfFiBa/ZRubKd5aVA3Uue0ooLV/cFBOrq/m8GGb1unIWGzgOIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D+pvAa9O; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j50eJ6trcSz3w7aPBNU2OHsE96gXDYCZknllgKPy+1JoXauEjnQtM/3GZlIBM7GrutK/hBo48HGQDHxiLhN1CC8KUQcX+a3M3dZ2wNmiRDz+E8jjB4ciUNyWmcDhdCNaq56cswAiiOi7ciZ7KpBBV1jVdUn3y7Y8wjBU67HgDt4aFQ7dydJRNSctGaoCJbbT5OP4VSwSZ1zD7bLWnNsZmC8U83YKfk2XtKQkT9mSxBLjZyZm1whfV/Q2ptGx7hJxZ0XVCi49qQeoUy2QhquHLXdBd97zIoLaP+Kjq9H7S3jQeVUMSi9ackZiglmwGUHQfrtLM1mPa2YHmEkCvgxVTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ia/i6rrF3Y2ocXqQZH1nsk5ydssc63BFpWVmIJpsdc=;
 b=NW2aW9XS6lCkl0fDpeTZtfnfAGovOYfAnTwxvbJ2D7hJalzTaUPea1k6bW28X7Rni7ip7XobdpaMkd10pevjPevTgiAT4rNhgYx+447kQypLtaDXLm0HATWt3voyvEBNG8v4IRzLpih1EOvthwvsmbcpAQPIpFoeyydbgdAHqJALr0rYNB1yFt/KBCaPdVT5hMdmmkjA+MbYjE5MsvLfQ0VzMXcIxwy5ziYUiA/RUBemH1kXf6puyVatyPlRkfdw6fU6swkq8JAUnXOkb8yh4BlH749bi9XTuMluEiAbrXmb1bcEIvTFza8/yxi8Bqfi2HG+SZniz2nKWPLGBjJ7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ia/i6rrF3Y2ocXqQZH1nsk5ydssc63BFpWVmIJpsdc=;
 b=D+pvAa9OWfo+kwrmtxlZcuQclrPx7o3no6VCpPJgbVf1GnFMOhzcjBdLlT4UBnFYiyhpWwkCoAHZFo6I++kRR2Vr+I6Qomp5aMNW4dXj9sEe4yBRj4ttCUm0dAkGuuQ1X8SZAbuwGykjF8YjZdDRgkHj2gV3tjgtFFW3MM99aLYIcvy8NXv+BF15db8J6GTvhskqTsErFr6wjtCWzFsALaUl+IOB6TRYGM0rTuFoMCQnNm1ET7NAYAmLKHc/X9hxWxMwv6QpeNlDGr4kvgxci9HrLdEbIYjhMIHRHUbZd/s4Ksxd/wwgI5XhOKuW9mjXydqwsyzxHpn/0W7g7OgHxQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.22; Mon, 9 Sep
 2024 03:56:27 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 03:56:27 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Peter Xu <peterx@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andrew
 Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Sean Christopherson
	<seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Borislav Petkov
	<bp@alien8.de>, Zi Yan <ziy@nvidia.com>, Axel Rasmussen
	<axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, Yan Zhao
	<yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Thread-Topic: [PATCH v2 00/19] mm: Support huge pfnmaps
Thread-Index:
 AQHa9/i4MxIUuFc0iEilM2ZdWpqZPrI7sxKAgAAF7oCAAB1XgIAA5asAgAAdrACAAIBbAIABR12AgAkzbYCAAAzxAIAAAWgAgAAEVQCAAAB/gIAAAduAgAb7kAQ=
Date: Mon, 9 Sep 2024 03:56:27 +0000
Message-ID:
 <SA1PR12MB71990BC307D76C84BA68E3E9B0992@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com>
 <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com>
 <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
 <20240904155203.GJ3915968@nvidia.com>
 <CACw3F52qyX-Ea99zV4c8NjyWKgtqAKtNc8GP0JTcLOCOjnEajg@mail.gmail.com>
 <20240904164324.GO3915968@nvidia.com>
 <CACw3F53ojc+m9Xq_2go3Fdn8aVumxwmBvPgiUJgmrQP3ExdT-g@mail.gmail.com>
 <20240904170041.GR3915968@nvidia.com>
 <CACw3F51F9J0UYva56TYo4pVbM0XrtHnx9AkBbfUVL1rnHzhaHA@mail.gmail.com>
In-Reply-To:
 <CACw3F51F9J0UYva56TYo4pVbM0XrtHnx9AkBbfUVL1rnHzhaHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB8001:EE_
x-ms-office365-filtering-correlation-id: ae2cd67a-62a0-4052-e910-08dcd083616e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?hQNUi4RkKZ3HuRgTYI5TW8SZTcVcuC9TAFEtmspAe4fZAV2pDgWcUA6zQV?=
 =?iso-8859-1?Q?9dVE6hEZb5W1jo/+1PciLyC0QYisCZaTb9x9wfSds7BpqXUeYYlAJXhgBO?=
 =?iso-8859-1?Q?S1/+ab3qiPnFrDEWZ0EUzjyMpXf+QLyY1Hh2A6E8xI2fRVyglXRkfRbTau?=
 =?iso-8859-1?Q?QWOxYlyIG7iN1rEHuXVIHHM3I+wn7xstpHEZtwyPrqX2qp22SNzJBScwBH?=
 =?iso-8859-1?Q?UN6uLn4rsXPSMPFhva74iUclFnZmRzgp4E9l2AYhpH8DRs2VTLMPWL3rRp?=
 =?iso-8859-1?Q?reBtdD8SCa7EqVlNpgDvCo/homCXZJ0ZXug8rHrNqvxcZjzb9H6fw37C14?=
 =?iso-8859-1?Q?FRY82WmKmekxKL1alzDkYXSCwvib7e9Y6p79rL9YKKT9UgiWTA7aPluBHP?=
 =?iso-8859-1?Q?xoF7GsUGVoJpwlCbs2fOKU2nJR7eBK3A3UNxlTN3t4sNWKOVRXt7uZeUed?=
 =?iso-8859-1?Q?DUDhn6ibpQZOGjM/jTmrig04zpjbjb3rz15g3jWSXE4ornM25j6aNb3dN9?=
 =?iso-8859-1?Q?RhWsIOCBTLbjgayBAI/C4uggdkX3pm8BGlzuWnc7YG+4yMMHn+ZhcYH0Ko?=
 =?iso-8859-1?Q?2/8at9k6xLYRSQXxw5e7LmTiLVxKV0PzFYVDou/DkrR+JdFA2QNNrOokWG?=
 =?iso-8859-1?Q?kKTHg3kD31zESGUHzWAQdqtw23rgaP2WQjOMvZgD5ba3RVulIZXX4FcbVl?=
 =?iso-8859-1?Q?BG4SGn/UQy3eXnR/Oaq6fm/gNdSKnzQrXz8yb8Wa0XuuNOdvPNAY+GaAMD?=
 =?iso-8859-1?Q?lgmTFsKX8CJ3h0n4hU6GXWuOSSvjXlQopIUKNOwbm9BzAlcPS47XdqDztv?=
 =?iso-8859-1?Q?ZaZMicllDIs8rZTsHZa0bZ+1ZXapGCawwivebW8tS8fzFL6ThEe/Yc9057?=
 =?iso-8859-1?Q?q7ImmXmK6FTbUCMLVvUmi5YDew4ydmboRXg1+NTNTqcbXixaM6AAU78dio?=
 =?iso-8859-1?Q?3ApQOYqDKnoSwjkS1HRq/AENX2fbA5yauyB1hbpWc2Tr+wj3veEunsQSHK?=
 =?iso-8859-1?Q?0hXzRn/EoPPDfgfHc3Ge1VVXCmDhJ+GHDyC3iV5p2RN6jSQgfrvF/wD0Kl?=
 =?iso-8859-1?Q?6DkXLkaUPpmynaDDEqnkqKWBoWHXP9L1B6np275vLjT/CafcAd/NcPnqhJ?=
 =?iso-8859-1?Q?uytgsgQ3pkJhogAx4oIE42508fLk9sR9hzMBQg6P6mkunRhLfRfZiabmMW?=
 =?iso-8859-1?Q?vQ6icVOt16gyhZXLA/LbKAVhKUmxCGbt8Va7wM/sTrjznhg2Pz4ri1C9Er?=
 =?iso-8859-1?Q?S/nXBxeWLGU8Zoezl70DisD1VW7Or1UYbWvZz9s5Ap2XxxPwEV9Y8Tar+4?=
 =?iso-8859-1?Q?VPLyF8ks6bGavsB4iKNHV8RN3gulTwNiyilUWhh8ZH72WlXuo9vPxDCRs4?=
 =?iso-8859-1?Q?wDvIBqDbQHugAeMmV+EfoZlSgULtOHUUPTbgMCh3rHl4A42lNcgFgvDAIk?=
 =?iso-8859-1?Q?h+2VzGlgxjY4KFpZQ8y0xwyexAu5szPQnzTM+Q=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?J9BPkwQRyA+uVYIIEr4FFSERPil839g+7yUnrUPNELLcte7ZmL04e4qxoE?=
 =?iso-8859-1?Q?BUK37B0b6fSIhF8PXbQO16wJzRC4SFLVq3iOWiH+BmpIfL4QKSfk0j5mJX?=
 =?iso-8859-1?Q?DAr2hSgBYA12XiuqDAFwIm7nc0CewTs/3YdpNYk8QdphPWysLlxq5WD+IJ?=
 =?iso-8859-1?Q?tzJuB3CK78nyN8rHFWv7X0rbr4cgrtVar3SapXjUMt20g0S2m3S3bVT+Bp?=
 =?iso-8859-1?Q?T7d5edSjb2NAjgQ+4CTQTMJApjayUu56UOHqSTEXXYUD+Ez67znvtt2H24?=
 =?iso-8859-1?Q?g4WCrXxd8dVy6NafMLdUMc/cerdGgjTrOC07LY2kGquva+sMT0+7PF+s0p?=
 =?iso-8859-1?Q?buQZa/af5DRswHQg56y/KcsAuRsZ6gu9li6OJ7Wq34AFaJItkEZLW75AQF?=
 =?iso-8859-1?Q?fAlKTwrUQ8Edb/NATRh2qXd24iMBLTcIFj8YTF3stoI6hgaDOv8dBiKaVY?=
 =?iso-8859-1?Q?vt0p/TvxDB7AVEeWadVhRDigWV3lTAfC1AZYExOjiLW6samkpul8/re8Ns?=
 =?iso-8859-1?Q?Q5yc+NhhL3NdnB8qwaN/Ht4DitJI5Yg35f0gXw1/Fjuk6SIopscrVySRrx?=
 =?iso-8859-1?Q?Ir7GA70r0C2Hku+0Zv0EGnKbjecnNXqugsZPfrD+fsHEI41EM3860/NPce?=
 =?iso-8859-1?Q?GAyVU5csJdN+usYmMkqf0/u1hW+FIyq4ls9lrm+ksr6+vDdn2olgiufHi2?=
 =?iso-8859-1?Q?gcfStsnYSwMuUJYLXNKZfoPt5rtwhUGGf4mlDGhOnxcDLiYTyng9PNL2Xh?=
 =?iso-8859-1?Q?soEqbLo/vghqChxNhYSDKv379/4MLAHNbsBF64c4vniERozf9WOvZuxFD6?=
 =?iso-8859-1?Q?IfeqqGxZWMYBBxNoXCu4sOkpDIxQyFxLvrrCHC74D00GtslLXjZKLf9ilJ?=
 =?iso-8859-1?Q?ZP+oZ5pLkmGCGQptqGnfOW245mkaz2bOLzIlWI0aquZ0ujpySjTva2NZpV?=
 =?iso-8859-1?Q?G9EchoGv9J6oAtJCqS9GScoEGpAFjvDX/pzrk097jdUfCDVRQgO4JzL9Kp?=
 =?iso-8859-1?Q?Px0l+Kn6fOvv6f5Pzx7GfF+z+TAlUcSBjxCjtR35fUPqKL1k93dUqDe77P?=
 =?iso-8859-1?Q?Qluf38Ug/2Dq+KtLYT5Fw0Y8zhmSCaGCn+8Rd12Egl3w40u/l334ywvmiX?=
 =?iso-8859-1?Q?lcjeaBH2DVEZymPLrw97YUAHavdBsPQD8WNlMIR5+79StppYy2Cv4rcf3r?=
 =?iso-8859-1?Q?eVtGlGYFJvlDaNCBbdBsqoIyU4HU+KmPK3z8WbpbNXtvcOLZ00DKiq8z85?=
 =?iso-8859-1?Q?aFhpTgz0v0Yem9P7SGFT5+OIPh+MV7Y83Zp0oA8+r10FQpgZuh2FhTVyVY?=
 =?iso-8859-1?Q?u2/6RUtQ37O5H6c1EHn+XOYCe/kSg89Anf9FkvM8MOFe89C8NA0DnOiwZG?=
 =?iso-8859-1?Q?Cp4F+VEgPFH5xzGQNwwlxaiKG6VJw3viU6bEnsfnjuMBzuc88m8RqqiCcd?=
 =?iso-8859-1?Q?dtvfpa98xoewHdOZV+hsNkMmkaNQVmDo3/Fpx1OwnG83UJU+2PL+lbuET9?=
 =?iso-8859-1?Q?K0ikFgnf8asDiBQtZ9QA0mo8lQpaRLsp6LHHRX9RlEeA2W7ZntSDoijYBe?=
 =?iso-8859-1?Q?fKywG8443xOFvGt10BMrpvNkfT7PUzIH4xM7Tk9nTv5jdjXstG6UG7PSZG?=
 =?iso-8859-1?Q?ZoWI8sd5enCL0=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2cd67a-62a0-4052-e910-08dcd083616e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 03:56:27.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nNySrTvox0eNCK3iKz25F0X0Ejkfzkrn/PEosyNQxo6xon5Q841VN3ovFTJXAxWbIrrF+i8BSpRpzAaM+dLAew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

> Yes, whether a VM gets into a memory-error-consumption loop=0A=
> maliciously or accidentally, a reasonable VMM should have means to=0A=
> detect and break it.=0A=
Agreed we need a way to handle it. I suppose it can easily happen if=0A=
a malicious app in the VM handles the SIGBUS to say read/write again=0A=
among other ways.=0A=
=0A=
Regarding the following two ways discussed..=0A=
> 1. remove pud and rely on the driver to re-fault PFNs that it knows=0A=
> are not poisoned (what Peter suggested), or 2. keep the pud and=0A=
> allow access to both good and bad PFNs.=0A=
As mentioned, 2. have the advantage from the performance POV.=0A=
For my understanding, what are the pros for the mechanism 1 vs 2?=0A=
Wondering it is a choice out of some technical constraints.=

