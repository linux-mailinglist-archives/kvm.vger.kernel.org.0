Return-Path: <kvm+bounces-61373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EABE9C18264
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 04:15:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 768A43BD521
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 03:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3FC23B61E;
	Wed, 29 Oct 2025 03:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q2kDYBUv"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012014.outbound.protection.outlook.com [40.93.195.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BE6194098;
	Wed, 29 Oct 2025 03:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761707714; cv=fail; b=YwKoWnL4xk7LjZJ12TCnBQwZPQYskauy2Q0WlntPOf8uzJj4K8SPRWpvKMXrEFjfBzR93/IT8ESIhMy1S2LadOQ4NYPno8vPMXpI2KSY9Y8QTNxy/lCCw7tMHdACrlYlmJ8zN8LMY7tr7816zq4nnNO/6Ix5Y6F64XQKJiVONvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761707714; c=relaxed/simple;
	bh=Odh/FuQYrLExuI6tmD7gnBfgtMk2mgaP1sGnsWSs0Ps=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U6bTVCKarkUvog9RSw2/Z89/hERO29YuUPhTiLB9cwYpy6D18CmetvXI+5YHUMSPXsaXDvfSY4SNSbh7Hm25JC1a1R8iIrD6KiG6NjefK9BDLY6YWCfwr5G9BMSDvIBr3CqiYbXrnyr5+UcRRcBofB/dAE/wl8WnzDd20oBaj+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q2kDYBUv; arc=fail smtp.client-ip=40.93.195.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dr7f2NPZwHF/YkHEVXKsEs3cb+OUrITrMFhE63xnoA8CfBJHiwKPbylpV8a+oI18dCOK7VpdH75wtrWhCigkExitd1eBmSrSlCGXyQsdnSEC8hrfddc1mffJvXgf69d1MbOvy0t/ooIRobe9OWs9LL76lwFc54tMgJ8ZrwWToOiBTeFwgREoAL5Odpmk6MGbX2KpM8n2ayAoSqoPnAJDsRWMh0yVyO1ewYLKvToeW5RTXw29BJWXIQ3AFF6WufUzKftWEFf+s9iRR91G9sI3AQ+ZWX7SI9FBJJU8rNi3jEKD+zwkS4Bob79DOdFB4pAlercauKEGEIxluFYVGpRNIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Odh/FuQYrLExuI6tmD7gnBfgtMk2mgaP1sGnsWSs0Ps=;
 b=UX/Dsq3/8fmRrTAq1BijkX6+l4nQXUKxdlLyvHutCawZP0UuUL8ASKE8kShO4/sJTukiYN40UX4WmaubXi+OtvuueEVJvUYvt54lAycIxbXtHeMMYzwKGJhyLcmG3vQ0s+R4HD01tghkk1eoXt+T6Qy3Yo/x8JJgcrjFCSWnp+N1ZGJKxmzXvyvATml9ayXtUQ3aQFb8mmxGBFrf/5yswkAz6y9ApAJ0TqF5ev2Vk07yrHkn7HA4H+Lgw4wA2hsWe1HI5Ze6cykD0ZtbNfKAa2+FRq3BKSWL6vtMFsD2pTLtN7bC1N/k86jqV5Xu28qfCVZvy+AqNn2487YpIQdM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Odh/FuQYrLExuI6tmD7gnBfgtMk2mgaP1sGnsWSs0Ps=;
 b=Q2kDYBUvboJuG1Q6IxXWKhDufwF/tJlEKiaM8hCJo9NhUaIcrZIrYHKDu7+K2HFv/jISQXx7dQJEcVY/SzX8uo9NgwN5pGdVlaCSs/dQYdkIHGD6VbfGekiJhmTTiruUaJB8gkaxgJ12dwBzLYhr+JK0TD+nVAiaQYZrvm+PleWuePzD6YyvvKaQwE3bOu4I+W7lex0761qjK1NAzcppcR8Ggc/EwXFIpQBIip1xf4E3UcjLFmTbOML3qLmxOP+uuXsfgcepaQLyUJNMj7mhblKN5Q+Tqw6IiV5GPQVCSZa+yE+BYxDvj62e9JpBEHkwNEuqn8UScNdNWVRoOAS28w==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by LV3PR12MB9215.namprd12.prod.outlook.com (2603:10b6:408:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 03:15:08 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b049:8074:780:73f]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b049:8074:780:73f%5]) with mapi id 15.20.9253.017; Wed, 29 Oct 2025
 03:15:08 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
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
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Topic: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Index: AQHcRoOUWJnftWewAUixSPYj9sJbdrTWte8AgAHBIgM=
Date: Wed, 29 Oct 2025 03:15:08 +0000
Message-ID:
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
	<20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
In-Reply-To: <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|LV3PR12MB9215:EE_
x-ms-office365-filtering-correlation-id: e64c2b95-514b-4383-73f5-08de16995d59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?fxzb6hLN/X33IF7vCwlQPHlH1+W8YSy7g5lTr+HFOH9Q2PcOBcb8Un0/7F?=
 =?iso-8859-1?Q?3ue22+vBLuiGQF7TLEv6Znsl+lB5hpxKDANyEQzbRKy2Bh8ZMfNtsc3fF4?=
 =?iso-8859-1?Q?iPWDdUTIF/Gg2H84ERjAA0gw8C5V8CKaWAgBZa76KN55lrIOpXRFktf+qQ?=
 =?iso-8859-1?Q?2A2FjvQBx9G3bRPqJDCrl8tZwpLXUGwEoIKct0nBIMf/K12+nk9q8JP9DO?=
 =?iso-8859-1?Q?qZMQN8rtbVW4XbM0fzBFl20ASXzqOwOn9C0qZ9hyPcOpGOIcA5I7LAbv14?=
 =?iso-8859-1?Q?wBCNu4Gq9rKc5c3D0ujcfVBJXzeIk5SRj1MOZLdWcbsxH9awIvSz0YcqPQ?=
 =?iso-8859-1?Q?Vtc8Ds3+qpqIlSBCoOZv4+UADCIZoP3VAFpo2JZgA1I6qrFrw/1eh4ZMH9?=
 =?iso-8859-1?Q?XghTDO/wrGdqeDMCMJcyanubMqwwBiWOAS0Tkqb0e0xS4HSTEDoPhmqifW?=
 =?iso-8859-1?Q?4e/VhvPm8Z9XBO3d5Lx2lJqhYnpH9AL6hWoyx7wTM6tm8qyF8trgZTCiJX?=
 =?iso-8859-1?Q?rbwY8oasdS9+rIAJdopzUcx95WrLlSqpiUsVCm2tp1n5DLq3pFxPfEMNR+?=
 =?iso-8859-1?Q?5rUS9gkEC6H4pVzqrI4bD/P9i8FWdeZkmp0MJqUrHuFQGwIc5PcyceEtA3?=
 =?iso-8859-1?Q?/ZnVGVa8Md5pPyWK/k+3c4G15OdmrHD8wahiq+C4O6U8fJwjSLz5HrSBzY?=
 =?iso-8859-1?Q?zGgR/8CgigBev5ER72PJs0mA10Mors/1VXIMsaq7JByHl9WyRG8U4yOYLp?=
 =?iso-8859-1?Q?b3Fz4Qxb4SlGPrdGEgzrs56zAFGLhsjSr8WQ660OpumAvDWok3x+nCytqp?=
 =?iso-8859-1?Q?Fw8EqWTSLHWM1jX97WMobjjWlK+TyyCao+qyrMWvePv1RG/SZ49S5RP+Lz?=
 =?iso-8859-1?Q?NN95jN/RETm6gsTD2gk5t+j4X5eOfhnjnH72lvmnZlUzs12J5x9FbtSiaA?=
 =?iso-8859-1?Q?DAtN0hPN9jxXRWZcWYGe9u2sEkRMTEYGrMw3lu/BnLTcI6+BdQrZIepgF5?=
 =?iso-8859-1?Q?tcNWU0t45IzyghBazw3SBJoduK1T209lKHnnEyH1z3FAQ9zBOHzCUT1cGV?=
 =?iso-8859-1?Q?bI6btkGQIEnDo7mfBaXisZr6gXRy0igNL5I/ku9jlDpFJVkWYA34+U4sOI?=
 =?iso-8859-1?Q?BUXPJVWJqwmoIEVht4RNSAsnYtusm2mbEUVYMfGca7jwwZ7IeVX+nK1JJQ?=
 =?iso-8859-1?Q?GbVXsJytfZMEBlTh0fDKof69+NMLxBFoE7iVkA/+N1Ra7EivKoukq7n5RW?=
 =?iso-8859-1?Q?+XEhxbhLF+f0+/s3vULVlUx3j9SedIgJe2CsHdhF3mVBdjs0Iwk93/z8ef?=
 =?iso-8859-1?Q?huG4id0f0jRNRmD7WKo0dO504aa5tysR3cwlvrv+iPCpiu9ZZFJ9b0jRS9?=
 =?iso-8859-1?Q?9J5CUDM7y3etwsSq06sn9nwtgajxw+nzMiu1UX2Oe0ltcAIXn3Fa8gs9qC?=
 =?iso-8859-1?Q?K/xT0C/oj6PEKuNu9YntFI0VEfH4uFIFkCQtv/rjxF6fgR+0YdKoEAwByM?=
 =?iso-8859-1?Q?6uSPslSKeh3VF5tf2hStSLmWBCGbww6M2ayPeLFNaFDGZ9rBAtDUNCRflQ?=
 =?iso-8859-1?Q?dsShLZr7b+qsOEl2vf/dPp8egKkp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ZU6aly9yW4tpgo6d1N2hvw4HzK+s5p0GzsNz+3Quk6kT3rNcGz+N1AMP/k?=
 =?iso-8859-1?Q?d5Teob8fYfIe85iSe9uSMt1c10ToB7pV7d22AsAQaX8hyOM1zJ6PFaDV9R?=
 =?iso-8859-1?Q?J/4GTt5c1KIaDagP/TZ2NcWD8ibQ/q5p3BbzgLRMsaw6zjs85PrQpwcg/L?=
 =?iso-8859-1?Q?PU3QTEEuGnBF8pGe/z+1blu57O98iOZZZetmrvnDML+jw69svBsoyeO4Vn?=
 =?iso-8859-1?Q?Iolsheo10I/a4ZiJbE/tq7AI36lVP4DJJlbtzizDf0TWWwMdmghmny2J6g?=
 =?iso-8859-1?Q?RsghWfVBcJhHMsHmTzIY5qmuZTwm9vb4WtEOtBHfG8VR7VaLARl1Bo83/I?=
 =?iso-8859-1?Q?G7dhaxAVX1Rz9rdx5y5EA1hz97dWoUQ9z2Oci3QY0A6w5XsNKA3ChC0F+z?=
 =?iso-8859-1?Q?tn53JFFvgwbEeWp58Yk4Wu+k+KSKLvD8UqmQjTuVqiITkg8dodGTi2nY/+?=
 =?iso-8859-1?Q?Cp0Dx6iwNYNnDpSzP07sdeVQzz6i8JWmzvyfQSznPYf+Odhx77LlN5ubDY?=
 =?iso-8859-1?Q?KfnFOK9jPiIEkNOPDkpcpTBYvi3ihUbKqELYJ4ic00NsEDHi7ofYrBlXoY?=
 =?iso-8859-1?Q?7+W4Ef6UEQoyUJmGSP2pSAAq2B18atRSamOMKMOJDwnO21zmLl1w/vUk0x?=
 =?iso-8859-1?Q?SSDtwHWX07bXPNgSVxHif56rXoUa4bI9xzdeZEPlYBVoNIejYx+3OagGS3?=
 =?iso-8859-1?Q?jZ9aQHcBcYYvOCjtNFzjkIF+Z7DIEbYg//ekr9VoUflrnebALZNuMt0Bli?=
 =?iso-8859-1?Q?kf9tAlpk+TTZKP2Jkch5HzPeXY67bXqyaUoh+USmWtSN5aQKVoJZ/rz0sc?=
 =?iso-8859-1?Q?8PcLSa2RNLQAPY2tNKixIOKu5pSaXZfyr3Nk/VeWAv+YYGelepu3o9KQa+?=
 =?iso-8859-1?Q?+55dtm2lb2Kmyv2xXHtgq8Lf0Awla9wnFTVhp3Ip37ZiyM/9MfpZm0l+3i?=
 =?iso-8859-1?Q?rkULce6BZHXtIFyvBQkyhjpXGy01iyLb0ArwplGaQBfUS2doRBFXhgLC4w?=
 =?iso-8859-1?Q?hf/mxqY8A012S29co0nnOWyuZs1DXtXVdMkN5STQrgsFLssBuvS/5VNidu?=
 =?iso-8859-1?Q?CFGNzVQyT5Eg+eeH0+Z33V32WMzFQNiEDq+bSczKWT1L46U4R5nG77AVG/?=
 =?iso-8859-1?Q?05oa3VmBCV8nM4fml1i7e2n34+fl7c9Mv/DVnvhm8Jd3piixqhJzT3bISm?=
 =?iso-8859-1?Q?gUA+JaIhIjhP2BFgD3JyEnqNrww0W03QeouLTyt7ImSIA0/gIXT+SbLaaj?=
 =?iso-8859-1?Q?iGYqZ77bMJ+BND53tieWCkPsAS2w2TJH/DHJEHMY1FeeVhmscC57UWWk7J?=
 =?iso-8859-1?Q?JWqhIh0hkUeOuFRchPk+YtZLEI7/AgBVz0hRKZcvKW/ZGmEKfiox6nDJzW?=
 =?iso-8859-1?Q?mLxpHYYu1ETTWtlm3V3RSYVySITukfiSWLL3wh/xnqdklmtlQiZCUKNXj/?=
 =?iso-8859-1?Q?6mf3WrTQXzzqKCYz7/3DaTmkTSTqyzXLxduh6b0dlY8mKySqWkvUvKIOGS?=
 =?iso-8859-1?Q?Kf0Qv9ISmB4sBDbKrhVlmIvyCsBWwYsetoKUiEIz/9bz1w350XkM7DzBoF?=
 =?iso-8859-1?Q?3fTi5JR+hNan02OtqfpZ7xo+pKc+rf6KbzhGgUtRnBa3GEmrE0Q8LgbMIZ?=
 =?iso-8859-1?Q?uP7fy29kn+XnM=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64c2b95-514b-4383-73f5-08de16995d59
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 03:15:08.5046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/gfYyXRtDdKK5WAmHsurhYHyxc6xmeW74LliUHj8JqHV7ldOfadFGDQ1FWwJfadg3Mr2evTTnACLNHC/dFgJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9215

Thanks Andrew for the comments.=0A=
=0A=
>> +int register_pfn_address_space(struct pfn_address_space *pfn_space)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 if (!pfn_space)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;=0A=
>=0A=
> I suggest this be removed - make register_pfn_address_space(NULL)=0A=
> illegal and let the punishment be an oops.=0A=
=0A=
Yes, will remove it.=0A=
=0A=
>> +static void add_to_kill_pfn(struct task_struct *tsk,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct vm_area_struct *vma,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct list_head *to_kill,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 unsigned long pfn)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct to_kill *tk;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 tk =3D kmalloc(sizeof(*tk), GFP_ATOMIC);=0A=
>> +=A0=A0=A0=A0 if (!tk)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;=0A=
>=0A=
> This is unfortunate.=A0 GFP_ATOMIC is unreliable and we silently behave=
=0A=
> as if it worked OK.=0A=
=0A=
Got it. I'll mark this as a failure case.=0A=
=0A=
=0A=
> We could play games here to make the GFP_ATOMIC allocation unnecessary,=
=0A=
> but nasty.=A0 Allocate the to_kill* outside the rcu_read_lock, pass that=
=0A=
> pointer into add_to_kill_pfn().=A0 If add_to_kill_pfn()'s=0A=
> kmalloc(GFP_ATOMIC) failed, add_to_kill_pfn() can then consume the=0A=
> caller's to_kill*.=A0 Then the caller can drop the lock, allocate a new=
=0A=
> to_kill* then restart the scan.=A0 And teach add_to_kill_pfn() to not=0A=
> re-add tasks which are already on the list.=A0 Ugh.=0A=
>=0A=
> At the very very least we should tell the user that the kernel goofed=0A=
> and that one of their processes won't be getting killed.=0A=
=0A=
Thanks for the suggestion. As mentioned above I'll mark the kmalloc=0A=
allocation error as a failure and can put a log message there.=0A=
=0A=
>> +=A0=A0=A0=A0 scoped_guard(mutex, &pfn_space_lock) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool mf_handled =3D false;=0A=
>> +=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Modules registers with MM the=
 address space mapping to the device memory they=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * manage. Iterate to identify e=
xactly which address space has mapped to this=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * failing PFN.=0A=
>=0A=
> We're quite lenient about >80 columns nowadays, but overflowing 80 for=0A=
> a block comment is rather needless.=0A=
=0A=
Yes. Since it passed through the strict checkpatch.pl check, I didn't notic=
e.=0A=
I'll fix it.=

