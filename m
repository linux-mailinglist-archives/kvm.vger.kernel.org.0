Return-Path: <kvm+bounces-68435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B960D38CB3
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 06:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B76443040D07
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 05:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FBD328B7E;
	Sat, 17 Jan 2026 05:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JQ2aEgKL"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012058.outbound.protection.outlook.com [52.101.48.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E993C22F77E;
	Sat, 17 Jan 2026 05:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768628172; cv=fail; b=f8E9V6FuhUICfDyqwREeP/IA30qdVVe5KCunNHVkpaRcgflKpibEasvMgAYEKmTz9ZvvqYxwUyuLv3X0C9yaFU2dHUFbW/OdhNQUgtyFtr1Sc3LQd1F5JeUSmrXpXeOUb9KD/XJwwnCtI50wrI1xDx/1q3kC+sFsuPyi/T5QDCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768628172; c=relaxed/simple;
	bh=LRzoNV5LvBwvQRx4tm+7aO9N9kh6RefReEOcZIN5Vcs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZHLvpmH4IB5tM4dr1udruvTbzNh+LqwP76W4atRcf0ly3ZpSJ/8J7DVCOF2OjLmNvhCmuUP1Zz33nWXYo4ADJw9gI09D05OQ3/3UE9xeH/pGmIC1FKry3x83XlUrMBLWX9skY0kSCJi6Dh91U7CXl3Ef9hG9C20WIDnCAUYY8Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JQ2aEgKL; arc=fail smtp.client-ip=52.101.48.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2db8PKuPQxHDmxVcXxYbVA8000riI/eBlnW24UP0g515C4DUR9wBXMmC2P6wmgvQp7VEE1BTKaXWYF19JKGyBEd/s1z9R6mjIUDER/lkwX6jzySoKk2GyzGCvxaRgm51qtjt8ogDeCEFx3T8jfxsexRKPYyI+ym5aOKSIx/aTkZjdAc8qvu0p7zfXqMreZh8AGssGJPql0ZvMP0U/O3nvVWMlCO69hJNQ0AW5vY2dq08QkPZ3PqKA9IFch3VtFUQcBJ005vP+icfMvVw0Kv3OPZg5syrZyA6Oe/0QMeU71wne7+AOfWb3QeBFWoynmMwQgHHJhwKYDgrcyXaTb1kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRzoNV5LvBwvQRx4tm+7aO9N9kh6RefReEOcZIN5Vcs=;
 b=pl5vho3JUKBqZTs1F12a7sAGMeZk3cldjDzp1Bgic4+bPbrDirZ2QLy2TXrscwiIwACJ/BxNQ6rPQ29gD9kC82At9ri/7M3DnyPUTV6vVJ6DTCp6EqHWF/ihLUHSXxNjkVB6jH4A1gK7bCqS0WwGSqCzeoiE5iBLY5Ao6d/i6ETXQ7igq8dgqhBHJ45WvoDqzfTVxwDg+N7KaP8/YmnEi4Uqc5tHAMqfYbJIXqCY8067tBbPpjYmNE93xRJwgNv9EGWprr9pX4LIQT1ph99+sYdFzlz9pSmEc9G8+eKIFWVFqkR9/p/vBZ4glin2mKO06NYXedPHQTks/lzRkexuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRzoNV5LvBwvQRx4tm+7aO9N9kh6RefReEOcZIN5Vcs=;
 b=JQ2aEgKL/rcybb3H8ytkMImJ26OEUBnIDP1E1oPHbS6iP4WCA2pVVYP0HeqNFOD3jvwcVluN6Ou1gUwa0Gt/MMX6/zE98j7YvPmwJbkss/seR24EyT+ipx1Wi/r8pMefA+WsY7DpHcu5+LqvqiPV0ES63xwSqyHeX/3gYDfrdLXm5+C6LKQDaA/M/TOfAPnfEVxs/LqHNV8WKW3Df9OF2k+IXf0Sqdblva1cpCitc8z0/AxZu+Ivctc3PKkDd5a0G3sVO8oP33hXIJTlj4Ei0ppNJeSsTnS+GqWk+KUMysR9Zi+xoQT9EfxHpI9sQCA4jR7nzIn70kcqqCCOl9PrYA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW4PR12MB5644.namprd12.prod.outlook.com (2603:10b6:303:189::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Sat, 17 Jan
 2026 05:36:07 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9520.005; Sat, 17 Jan 2026
 05:36:07 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
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
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Topic: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Index: AQHcTCjI0pjrCheBKUOiFkE7k4wQB7VWDd6AgAASNA8=
Date: Sat, 17 Jan 2026 05:36:06 +0000
Message-ID:
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
 <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
In-Reply-To:
 <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW4PR12MB5644:EE_
x-ms-office365-filtering-correlation-id: 52ba2fa0-63de-41c3-9640-08de558a500e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?DmWKmgtdPLoAWLVitUTVkSWQefePpWDg0IdYr5Vg5GLdHSFERjZWJ8F+Ew?=
 =?iso-8859-1?Q?J9jPIxFvwS03IQoT8lRxK98ih9z3gkbXFNyz9eBU38oC827o6YgEK516Is?=
 =?iso-8859-1?Q?xZdnseBqRFqiqmQYvJ6HDcNVKVgxO45bp+a7eCIOqgTyHqeSln6ysC4V89?=
 =?iso-8859-1?Q?PYNdt67fh6I2sEHxLr4PNNfRAPWan31tw6JNoxXdMjl2zwt+alTRVtkjP9?=
 =?iso-8859-1?Q?/UwFty3n3utcZm7cWfsYPV7WuZk3V6xjTyVgslIk5ZMOPnGkcwVA3+SJSZ?=
 =?iso-8859-1?Q?MYwOmS15ldbGPufjLDxOYtk5VvtE9DF/FgC63nFIFKEb7e3v8OBBCft1Ch?=
 =?iso-8859-1?Q?qKQt5wYj2qczfTurXdN9BUEJ27hibBa1KzBAptgLLAwAra2qG0mRlAYKqS?=
 =?iso-8859-1?Q?XzPvl6ivg8OmTxM5j+vWmV1FFsISD+X89B826OwgEqH5vg0XaZlJIb3wxa?=
 =?iso-8859-1?Q?+PmNqWs3A2zh7++EXamfH7n/wpj/00kYe/5E5dKTyvh6WnTpAccG0rXQ6N?=
 =?iso-8859-1?Q?/JqU7QAWgkMTXDR/P0g35dcNPPaWjK/sxU0LIOpHJOq4cAvXF4RRfk3wDY?=
 =?iso-8859-1?Q?P71sbFxailvxN5/BK52iQIiR0Abm+66iNTf7Z3rollE1u4+q3QBa+SG2PX?=
 =?iso-8859-1?Q?G2RzaDdaiZDatUdu3FQtJM0daiuL/Uc7kITl2Xv+Mu2EZhCWkbCp0SUeGB?=
 =?iso-8859-1?Q?GNnDqRXh2khkeBr8jPoeCObTWEMl5UAoDWZ8WMv49wRnGuDdlpATaK3+Bh?=
 =?iso-8859-1?Q?47GMGldzxhpQxnbsb2RsdNyJ6rPXpOdsqUJdNT/nQo7A7gFcRxuvVmKf4H?=
 =?iso-8859-1?Q?Iu/JlJDvJdZgTDyDDTMglztZigPANahoeUTgEUhj2pweIkYSpkgO8/Iw2H?=
 =?iso-8859-1?Q?phRYAipy7hR5ZYw/ypAfceBWND0+1zoMpPuVTXk7UpkXolAwf83IMvNP7K?=
 =?iso-8859-1?Q?GwFlkH6OMIwj72qk8p9n4qaii1SkHFVJXKhDpB7Y5M80aIF7CdNrYEs5Ji?=
 =?iso-8859-1?Q?B5LOvnXoWeL1LF04mbrw008EOpxd22buYA3/upuNHPoUzYl8vtxwcAaxCp?=
 =?iso-8859-1?Q?zcQ4bM2y1M4cOrNxY1413npdykPjaN2jd1XHd7cMSnuzqY+vkjJCf5A5ux?=
 =?iso-8859-1?Q?x9FjAnSmdpJDTqAi7fSLynkz5jVBx62QCr+HslxpayWkSi63iaCG0BxXVm?=
 =?iso-8859-1?Q?JtSrxIjhpeQdQGpSPAuB0JuFh2A36f8napY2hmRtNoEhWgbmj8Qr2WlcKx?=
 =?iso-8859-1?Q?9sFzU6mct4nYm3FtwlFG0rX8vSgLu2DUZDKXxyN5JN97xSSb2RW5pRki91?=
 =?iso-8859-1?Q?eTUiXuxWkdBQvvCL3YAHlr8ZUUninSC2N0jYVkkfGBzKneuO3SFSOgXrlT?=
 =?iso-8859-1?Q?h7DvrdU7ZVwZxlmrQYwr5wyoiMcrCRh5mBjHcCOd9Y6UmLNBXAAkkLTpPp?=
 =?iso-8859-1?Q?ik1Ci+1xMn+eA1Jrbb9naCrdXcCgsxntjuVhGJg+8oltrT4IQU8LU5D9R1?=
 =?iso-8859-1?Q?5RrvI3qRvH+xtiAPZA4/2A2GRnt/ABBvmKVuIfwiZg7f3teqUetcd6fIp4?=
 =?iso-8859-1?Q?Gh6INVZYhoXVxjBg1a9lsTu6JegcYKudldzd0MQgsYlE4iTMaHVAbFYxE9?=
 =?iso-8859-1?Q?OXgw+MIV1gbfAJ3XZq3HAgU5o3DFBVAGMBh7YGXm7ItL6abH+ZMrSSThkd?=
 =?iso-8859-1?Q?eN3yNN7Jq4oDUzQ4ijY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?6ChpVeemU/MRfWYqdYaqG1OFQ3C36OQptkZtZjDitt0XRSC5/Yk/aqhUrV?=
 =?iso-8859-1?Q?27zv6uzgjC8iwCj0WlQYIHPySxRylsEDV5pjTOKn7Wofhdv2Kr2ZVdHG8j?=
 =?iso-8859-1?Q?Qy8l6o9b8qGlsZSfARdV59+7fAVvpGoagnhKWhdFd8H9aK6dpKDq74wSxQ?=
 =?iso-8859-1?Q?pynAuOIkMZEwiB6iSDgIU4n6hnqFWcDaONLdR0aRPipX3xsQtXcsLMEsGw?=
 =?iso-8859-1?Q?JJkFrs08GrA9x9WBUfNdCdY/LQKn4pJu1vXl8SYRKk+plBMZDiib1e3DnJ?=
 =?iso-8859-1?Q?wkh0tL0AmKGbzLveB+lg+8fiJ3LEBGczJyQs8p6HkpbOl89RvKnJoo09IK?=
 =?iso-8859-1?Q?Pekz2SdB1MQNaxMdzrWb5cGoUkwZRGxWq7J8SYe/4lAn5y4FtCqH5RnG5J?=
 =?iso-8859-1?Q?oOuCuVGi8eumZgh0tFz16GBPQe0WFTJVG/DuDSf7B6c8PP5onw1rIqd20A?=
 =?iso-8859-1?Q?G6gwjiD7A0YKkeNG6Uqn0YpPgupAPgHNWMbXTDfO0SjAbH+PhGZQu8p5Ya?=
 =?iso-8859-1?Q?KXeY5X829AcMxab/FGaaB6h3238YBEL0y8MbbqErRKmzQlPiOR4Oddv/02?=
 =?iso-8859-1?Q?OCd+n2HdIeYiGTI7vGBgNMNgdVADJEiMbKgFg/8v1upYO1RCrVwXpNJ75a?=
 =?iso-8859-1?Q?ussizufAxwjlJn4mrys8ubLKqgaNw1Cgu82u3i6x2EBhY3bcg4ZHU3AQtg?=
 =?iso-8859-1?Q?VMQQwyM+yo9NUi4Ule2Mki32yrzswqNSXdvsWsGYcZEURqP+VZ2wOH8JsP?=
 =?iso-8859-1?Q?7an1KXo4ss8PhdSQNwRhhC6sXINxOnecOQA/NwagiIg9WVChaX41ZH1bte?=
 =?iso-8859-1?Q?x7izJ4TVZruFhexEZ4ORftx4lkh4ygr9WHn5qfL5guIXtgqb4i2umAQLSa?=
 =?iso-8859-1?Q?Lj7eOiVHy4m66hUADidbk9oDo6HTwGG5/H7d9FazsYHNQFBiCJrUn3KBtl?=
 =?iso-8859-1?Q?Dw3vw9odtXT16O29kdOY/X11CyJI0LKtVxrbrRbcFPNeYxc0DyfTnyhx4j?=
 =?iso-8859-1?Q?DTDIo2J/5ebg9JMjYhdr2YlGQODG3lZNdHaMhv5BeP+xA9jp2e1U89KkR6?=
 =?iso-8859-1?Q?KpsDxCYdIEAB7TJhcAxDYRYaNKB+8DlgvDj9tYV9lV34VtBtHqVlBPjPR4?=
 =?iso-8859-1?Q?AInZbM+U0filw5Id4QrR75+IsgPW7FI1SGcHr0UovSefvx8978xMkFeFID?=
 =?iso-8859-1?Q?t+CHCsHhI32qCVohdhpa0WaRIr3QvDm1f7CVZi1BeG2+dv9vJFXtJWB0zp?=
 =?iso-8859-1?Q?cF1a4TKzab4EF5Tt0q+x6daEfiT8dbE6YUpBZSsLZgnV5x9iYRcDnqDkRw?=
 =?iso-8859-1?Q?Awk3MXJCYjQoU4EfktptBHRw9TLJEInxbrF4Y4yawr/fzYMSmcYm7949AG?=
 =?iso-8859-1?Q?ni1KE27kiv+nXhiEVarZhfLWTIaAUkTuRHlyrydi5W0CjXH7h8q7J4YISa?=
 =?iso-8859-1?Q?oA0Eo3szQBa/HwBiQJ7tMj3hkiwCwyhsMY9v6wNnKZBzWv1PNCmcCvsRCy?=
 =?iso-8859-1?Q?fMo2Gwl4EGSocVVS1n8kwlm2hWWr5ekilciMDxDeACOhAYASazmsmPzQQV?=
 =?iso-8859-1?Q?BoG/G3a7fy658EFna/bUFJ8xluEwsVWWo0nj3Gh+8cFncVS2ESuEF5+UZu?=
 =?iso-8859-1?Q?aegOt/rFbyZi2uSI5Jc7wobpLpewGZiXqjqsKUIul+zt9kV0eKHzpzPaur?=
 =?iso-8859-1?Q?PPrkqsarQ8Djv9hbmrfzGjrIA1U76Hojs/6t07nXX/PDnP0ACzW1UIQfKB?=
 =?iso-8859-1?Q?cSQtyRnH5z6Xszfj2wBXVW9Mog3gUX231i5te9KgKQUxRE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ba2fa0-63de-41c3-9640-08de558a500e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2026 05:36:06.9668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bq9I0mYq/WeWkVU4UqEdffb9vkIdcW5wvmUsYk6MrArW+Ly059rKB5zcUB2IEWICoaR15RzZkP4g9YwMuLKGFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5644

>>=0A=
>> v2 -> v3=0A=
>> - Rebased to v6.17-rc7.=0A=
>> - Skipped the unmapping of PFNMAP during reception of poison. Suggested =
by=0A=
>> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)=0A=
>> - Updated the check to prevent multiple registration to the same PFN=0A=
>> range using interval_tree_iter_first. Thanks Shameer Kolothum for the=0A=
>> suggestion.=0A=
>> - Removed the callback function in the nvgrace-gpu requiring tracking of=
=0A=
>> poisoned PFN as it isn't required anymore.=0A=
>=0A=
> Hi Ankit,=0A=
>=0A=
>=0A=
> I get that for nvgrace-gpu driver, you removed pfn_address_space_ops=0A=
> because there is no need to unmap poisoned HBM page.=0A=
>=0A=
> What about the nvgrace-egm driver? Now that you removed the=0A=
> pfn_address_space_ops callback from pfn_address_space in [1], how can=0A=
> nvgrace-egm driver know the poisoned EGM pages at runtime?=0A=
>=0A=
> I expect the functionality to return retired pages should also include=0A=
> runtime poisoned pages, which are not in the list queried from=0A=
> egm-retired-pages-data-base during initialization. Or maybe my=0A=
> expection is wrong/obsolete?=0A=
=0A=
Hi Jiaqi, yes the EGM code will include consideration for runtime=0A=
poisoned pages as well. It will now instead make use of the=0A=
pfn_to_vma_pgoff callback merged through https://github.com/torvalds/linux/=
commit/e6dbcb7c0e7b508d443a9aa6f77f63a2f83b1ae4=0A=
=0A=
> [1] https://lore.kernel.org/linux-mm/20230920140210.12663-2-ankita@nvidia=
.com=0A=
> [2] https://lore.kernel.org/kvm/20250904040828.319452-12-ankita@nvidia.co=
m=0A=
=0A=

