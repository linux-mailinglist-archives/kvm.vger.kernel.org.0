Return-Path: <kvm+bounces-61019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 815F7C06224
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 13:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8E901AA5039
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 11:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B13307ADA;
	Fri, 24 Oct 2025 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iQ93Bx7o"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7887304BC1;
	Fri, 24 Oct 2025 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761307155; cv=fail; b=b4H1JupLKfU/5Rr549wSqE2y4HAiYct8gn/pnzfwHh3HW/PFnnDkbMUY0d3zpQp1kCQby3cHo+PXmALve2wkuJQKpp9tU25L2Y7eHR8QQQ3HeTM3ikpW7zhWTiOYVxpknQ5pjT1Q8A1+Z23GQjt6TF80jPJe+ng+ZCLsmNDKDRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761307155; c=relaxed/simple;
	bh=lPcBJ+IurrnNE6VPSaCah0Rffl7kGD3utAQ/klb2YM0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Iuk5+iWZYisnFIPMX6yxlczWPB7zeg1Xh/kBYprXyzHxsV0eXapKO0qwU1/KG+rvRx1H0UK+AExqid40yaZS1ESmWGYvNdtlVdgrRdr0Crbpko/G8QMw1GpxAAd/d/wJLEPq8bzQQB3dvUu8O7r5wAeqrKZVt5YruA58XK+MxsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iQ93Bx7o; arc=fail smtp.client-ip=40.93.198.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwAO0UdqEgjC5Plw08VYKS0cC16x2hai/4x8Xn/SfuLoxYCeig4AlQYWr8OrR+9ToowC1eaqegnqVXp3y0mMEUIUh/zAXmfCmkl/G37niwsbdqvTmL6WFsvslLxf2Jbqw2VSZE48GOUuhz8n4LBx+WJCgvOabRVrnbq/W4WsfbIJEsUR71RgMlA8rNQP6SrR6wjczjgAum5tdfncU7fM5Efcvaf3hRalrPHYcffOFCcda785vNz1a6cKDyYMBQSN0aFt4DARyijuBDHx8D/L5NXWwEFxPvQd9p42qsTSZoxC5ok8niS0ZO2tBKKNtYC8O04C7EylJcQ1s6NX6zpnCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7asKaPQ1krv2Lckh95gj7h3c7eO3u8dmHB9Xz+7gOU=;
 b=ibHA/DkmvpbTVkIyuO1OYFM6suffr5t5pHb4mZXZS/A26edA5h2BCyOf3Jy1lRLJUflji3fkWa9Yrz4hMYovW4/dtwNhukvuKTi5d52IUOPD8z2YEDpnENqJ7VN+st6yKW+2+Vuo7irZXHC5theAvAflKIF5Ei5GAzzj5Q2DLE0iFTyVA1C9Ui0m6VCpOnwfCDzqQqTgpNNJVL7VVqQNM2rJWxZBXYdhC160SXGoiN6c9H4a3nrS/A3tq9eE6oNpsy09qslO283QnA1+53VT64oeD5J7qsj6p9FhSD+krBniBBBEefsJjXEEKYZgphEUmmSVIGC5rR7q1wfXqV4sgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7asKaPQ1krv2Lckh95gj7h3c7eO3u8dmHB9Xz+7gOU=;
 b=iQ93Bx7o/YEVHjg3sk/KR1FpUk/YahuX/jvkd3GO9WpMjj66EVxRP1YZJLcZZjt1oSZoZVUtRJB4F8U8+Fomhaw1zcD1KuFpHTzfZ4u+l6pVMM9y9wEhzbT7GwLB2ZrksQBktjtY08b9bR98Spt6yOckSakZHPe1n2R/5Odqc/kyewpwLrIjj3R4goTAkeKZsmZAT9dyRlrjsDz29Ys9Ph5qgRTUbZL7ugpmCE1g2xa/9JtumAowXPKxEKSk9FcGlPrH+N15VsxQD3hel58aUeIymsXzUe0EzbkOQjhRBYihbN4B5zecPyTFps1REJpgu9tt8jw1Gn348TCZBa7NRQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW4PR12MB7215.namprd12.prod.outlook.com (2603:10b6:303:228::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Fri, 24 Oct
 2025 11:59:09 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:59:09 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Shuai Xue <xueshuai@linux.alibaba.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
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
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
Thread-Topic: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
Thread-Index: AQHcQnTIOnJO2MvUxkKEvE04/4cxdLTREQaAgAAjR4CAAAHgmg==
Date: Fri, 24 Oct 2025 11:59:09 +0000
Message-ID:
 <SA1PR12MB71992D35824674EB3A0C7D4AB0F1A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-2-ankita@nvidia.com>
 <d2550489-834c-4dcd-b41f-d22590880343@linux.alibaba.com>
 <20251024115201.GD847003@nvidia.com>
In-Reply-To: <20251024115201.GD847003@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW4PR12MB7215:EE_
x-ms-office365-filtering-correlation-id: 7a374073-93a7-4994-b341-08de12f4bd86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?AHymHMZtIdtCXWrk00B3pNK/XcWyv6W8tJbwoiSJwBR+Pl1JsjLeorTkTq?=
 =?iso-8859-1?Q?Ttlj3ugxooty2l3itOXOeJF9dpeVbyQr4h1tAz/0YyLYBOdWnqmO4n3bit?=
 =?iso-8859-1?Q?GX7nKXMO89T6VWh/Wsq6uQyfZkSVqWxya3BsoMvo9tSmKKAkUhXVW/MG4s?=
 =?iso-8859-1?Q?1WgPoXlXxxdbvCXQas1PsdE2HtLLFmQuih0ifBr33f9LwAhch3xxRwvHp1?=
 =?iso-8859-1?Q?7KXGH3cnsZ38hZcIgdnR4A1Bi39kMwYuponb089DLNdR/MCmtAkODCPGgV?=
 =?iso-8859-1?Q?I3ka3mRYwIMN8lJU7cAhL6/tj46WX2XxLuXoIgPfnZxEiOg0e/ksdvksR1?=
 =?iso-8859-1?Q?VfyO5HfaIbVL9BprKwXhvtNSulAlbxEN8ibDmbPl/KQQfbRWtz4i5Ne9d7?=
 =?iso-8859-1?Q?8py5sI2f/VSTAGorXpMVoDj/0r/I+8V9WUPhqgkexDIYd6TE1Vz5cjuMEd?=
 =?iso-8859-1?Q?CxFF39Wq1QbDSN1PwUrtoqn6yBZ8KIlQJMFPIBxDnCL/+8Xr7OXA6CbBpx?=
 =?iso-8859-1?Q?wdRb0u+0JhJXCLCdd2xcsvxsT5pfLDj+pPlr+gIyryfbp/MXskB7Rrkd0d?=
 =?iso-8859-1?Q?Aviy30ynyqivPjx3zxJ3VDrqEhowagsfp9SB/XWKnvvsEx6T1HnOLhydoO?=
 =?iso-8859-1?Q?O7Pqjoark7YClkjFy1zpT6opK4KOSVa8C4vvX5qoj+fXDJLi0VYs/5XJU0?=
 =?iso-8859-1?Q?OBRwTIU8cqXo767YZYINRhrEW7gXVbSBJiVyxQy63dhYDEq9oLwHmP2SCN?=
 =?iso-8859-1?Q?VbPEKv5mIzWGKUGMwe/F3cwmg+CHNJO9XX0/UCfrMyDZUMd0Oa3d6/ewSC?=
 =?iso-8859-1?Q?A8RnDtAIrAfthR8TIdNIaa2H39Ou7z+P1QCzTYclcZ611DJVQ+X2/z27/Y?=
 =?iso-8859-1?Q?Rmd5kz7BJBo0x81OzPZxR9Sn/Ka4snp+n3nhmnVCFgZJ0jSSPexSVjntVV?=
 =?iso-8859-1?Q?5uJaNx0NGF9WZwHxtQj5eITRMr5gvejenYGKSGFs6/f7R5UK1XSh/PPz/y?=
 =?iso-8859-1?Q?Tqk9ptYnWwHbXfZZYTPGgiLoQi1CwvX52nJIiiIPoSMSmMfxfLGJWe6rH6?=
 =?iso-8859-1?Q?AX224ubEuAxUbJ5aZ02KvAG8Ves4fg07TTS/pYtiet9ICdvDP8s94HQsDW?=
 =?iso-8859-1?Q?BYPo6VnC017GyJLYsrrxcHZ1fhtFmyPR8RMeCAdTGq7XXOqAwHnS/stibB?=
 =?iso-8859-1?Q?FX9aHvc1bEPVrCc4biANDVOerBZPvpgqhvnsXEJDTLBuOVUJ4I+qW8jGCy?=
 =?iso-8859-1?Q?t67T1Mr6+iE0Gd/ZnoYdKZ76tEgmWG5oAU++sMz0X7jQlByYWQdGj/lpVG?=
 =?iso-8859-1?Q?XUWOxlv9FC4ipkdgRoNG0O4RwwLcetv6Tp5Ziby+ChATM7osxMQsZgCRI0?=
 =?iso-8859-1?Q?d7KukEjnrHI+Fdo1z2udA8yHlozXh2WwN8pQ116yETKMZlQiANQQSKEFfj?=
 =?iso-8859-1?Q?JoYs6jdVL9K+ggn9CJm0yqhHzEEOPng6Dsks84to07RDRnaSlZb4kyvDTd?=
 =?iso-8859-1?Q?Aj5mHOlGLxXOCFrY9NKePJXUuVE/WGzYdO0XibiAUcgVRx4Bn+PtIWKKiv?=
 =?iso-8859-1?Q?v+kGAKABIJbnx2o4AOYR963Rcj5U?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Ehs1ONWSw4DmJpu8YlT71Kf0cmpDETmsWErDFcu9YnIwZksUMHtrOFTiUw?=
 =?iso-8859-1?Q?mSZOjaujOA0e7GDMLyIZr0eBTg8gQdy1KfFRR/ynzPonwohMbSwysnlHLT?=
 =?iso-8859-1?Q?2iy6VaYnHWXP9daDUYGLwtKP/smPswYRs+wOhY/QGkWs34mUs0iOsqJw/S?=
 =?iso-8859-1?Q?DcQxLVdrRJmKOwlght1lR7swQIgXOXxDoZ2IWjdM308OG5qQMdumcSgjyt?=
 =?iso-8859-1?Q?uNNg0cPH8d0WIqZflPsfY30xzijl3w3UcrxfN39UYfw7jBDufDcuNvWMQM?=
 =?iso-8859-1?Q?D42TwzyL3p8rNkteEpaEdV1MYkxzF6Edw/NWqcLRz9dG9sPeChK+El7sNw?=
 =?iso-8859-1?Q?My5bLwiSafqk0r/BNJ+G7CJY8TmHTC/ewkbeEo9q/G8Su1f44DS/GsO6PC?=
 =?iso-8859-1?Q?HO6PlPcLWSG7HOH1iwY6hollnLyxolMrGi560JN765c+EQmBj99RYKqtSw?=
 =?iso-8859-1?Q?urFYELuV2KzBZLButCAqfH9tfoC2DOPSyYyxcWwAvV6mecDcEpvDG5rDkt?=
 =?iso-8859-1?Q?UY3rKsW1MxVCUmR70LSvGIWMuGfaiALMZfh1yCslpQHYrqOmLJd0s4Arno?=
 =?iso-8859-1?Q?aiUbc8zEypzuvTQvFAosCOx//MO/BCBZoZCyi2H5BffJN8J69KgLtSnSCl?=
 =?iso-8859-1?Q?iJECAF5QjQDuZyuzABIYddA+trpY2JmYxCrpDN3zjR41ltkumnhgBgNkti?=
 =?iso-8859-1?Q?0SUccjdNw86q4LnwTJAp3lg9zHYplwqM00XSaSBiCmvbY6Woo9sgJfw3i/?=
 =?iso-8859-1?Q?ZP3B7bwIbfJEZl3vdiRbzDhjP+BpjnJo3lz+XGvSkTPZtS3mUTJirHz8zK?=
 =?iso-8859-1?Q?VRiKw/AVWj/XPo4jdQIFVbWdSfNiUHdBaOuIUFPaPwowbOxlnIvx/WAsWF?=
 =?iso-8859-1?Q?fUZ0A/Nz2wbojOPHU/jd1HrH7MNwtyVcF8OLAFj8ztwartftLKqrdM3aDW?=
 =?iso-8859-1?Q?060M5DwgodtMwM1RgIlwA0UQ7OAR2QNsal5NCN2cPHCgz27TaA/g12/DHw?=
 =?iso-8859-1?Q?46dBlEgo2Us+7RpaXwZig5EQxjeve4tIsNweH7fKlMla+/GU+D6jLdKOj9?=
 =?iso-8859-1?Q?YsQUBtXOI5S6fo+vxTNIFSzl8kpU69zWHpVkf8OSb4VyHvY2WhvNl1C2Da?=
 =?iso-8859-1?Q?Nrv0ParFO/04DFBIFGo10oNJ4t61b7xUO8IQXYSx7HglEHyi3t/VZzLlgU?=
 =?iso-8859-1?Q?QGZONqop3WVQKCuJ9MlWG6ijtzzg08Qvf6QhV7HXazdBaEzR8uJ84wYl+m?=
 =?iso-8859-1?Q?qXg2fZHdMHFg4DD952IvbWVPSBxZXthp9z6WC4mog3+MMzTRdcNuAnnquL?=
 =?iso-8859-1?Q?TXCteI3pvx25KAPwEN+UkQuLcFaFJ/LoAKA0gU9YTLD0OuTO302LSD0sSY?=
 =?iso-8859-1?Q?M6Jf9/BiU9mc4HjNzHsnwknKFt40fDgauhRp0obUvoZdDr4yPjpq9u8haQ?=
 =?iso-8859-1?Q?j01WW1qkx3w9zMXI9zdthNy4SaHJZlpflJVsOy1b7IrOKh5lLA8SGHNV3V?=
 =?iso-8859-1?Q?WhYIJHFAKqQmKFv5fslYgXmcHcRN+8jUR1XjbQQqYIS61oYeldLc+SE/MN?=
 =?iso-8859-1?Q?wsj9Qm3oOai5v3ik74pOJeTQJC/1nVuSIhuSWNG5zwZg+JK1xMBhdkOGLd?=
 =?iso-8859-1?Q?ixb7vXc7Suda4=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a374073-93a7-4994-b341-08de12f4bd86
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 11:59:09.3711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Q6YDAEs8zHNRhAqE/TWWnednCV8JA4EKq7QwsV+O5Ca0/snjJG3KSGW9f5RhDCvq171PAWgbGpccdWQO+hHyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7215

Thank you so much for the feedbacks! Comments inline.=0A=
=0A=
>> +int register_pfn_address_space(struct pfn_address_space *pfn_space)=0A=
>> +{=0A=
>> +	if (!pfn_space)=0A=
>> +		return -EINVAL;=0A=
>=0A=
> Is there a reason callers may be passing NULL?=0A=
No, that would be an invalid use case for such. =0A=
=0A=
> Register and unregister are good places to use guard().=0A=
Thanks for the suggestion Ira. Will update it.=0A=
=0A=
>If the pfn is not in the process why is it added to the kill list?=0A=
I kept it as it is still a process with VMA mapped to the problematic=0A=
PFN. This would ultimately result in SIGKILL to be sent to the process.=0A=
in kill_procs(). This is very similar to the __add_to_kill() implementation=
.=0A=
=0A=
>> +static int memory_failure_pfn(unsigned long pfn, int flags)=0A=
>> +{=0A=
>> +	struct interval_tree_node *node;=0A=
>> +	LIST_HEAD(tokill);=0A=
>> +=0A=
>> +	mutex_lock(&pfn_space_lock);=0A=
>=0A=
> scoped_guard()  Or probably wrap this part in a guarded function.=0A=
=0A=
Ack, thanks.=0A=
=0A=
>> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)=
=0A=
>> +{=0A=
>> +       if (!pfn_space)=0A=
>> +               return;=0A=
>> +=0A=
>> +       mutex_lock(&pfn_space_lock);=0A=
>> +       interval_tree_remove(&pfn_space->node, &pfn_space_itree);=0A=
>=0A=
> IIRC removing something not in interval tree will panic kernel. If I=0A=
> am not mistaken, should here do something like=0A=
> interval_tree_iter_first before interval_tree_remove, to avoid=0A=
> driver's ill behavior crash the system?=0A=
=0A=
Thanks Jiaqi for the suggestion. Yeah, I think we should add it.=0A=
I'll fix that in the next version.=0A=
=0A=
=0A=
> If pfn doesn't belong to any address space mapping, it's still=0A=
> counted as MF_RECOVERED?=0A=
=0A=
Hi Miaohe, I wasn't sure how should we tag this. It seems you=0A=
are suggesting MF_FAILED is more appropriate. I'll address that.=0A=
=0A=
>>  	p =3D pfn_to_online_page(pfn);=0A=
>>  	if (!p) {=0A=
>>  		res =3D arch_memory_failure(pfn, flags);=0A=
>=0A=
> Can we move above memory_failure_pfn block here? I'm worried=0A=
> that too many scenario branches might lead to confusion.=0A=
=0A=
Sure if there isn't any objection, I'll update it.=0A=
=0A=
>> On Fri, Oct 24, 2025 at 05:45:45PM +0800, Shuai Xue wrote:=0A=
>> Rather than having MM maintain metadata about these PFNs, have you=0A=
>> considered adding an operation callback similar to=0A=
>> dev_pagemap_ops->memory_failure?=0A=
>=0A=
> I think someone could come with such a proposal on top of this, it=0A=
> would not be hard to add some ops to pfn_address_space and have the=0A=
> code call them instead of using the address_space.=0A=
=0A=
> This version just needs to link into the existing VMA machinery (ie=0A=
> collect_procs_pfn), it doesn't make alot of sense to push that work=0A=
> into drivers.=0A=
=0A=
Thanks Shuai for the suggestion. However, I agree on this with Jason.=0A=
It is preferable to keep that as separate.=

