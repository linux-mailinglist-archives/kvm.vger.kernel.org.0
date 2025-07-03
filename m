Return-Path: <kvm+bounces-51367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E57AF6A1B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B81D16C1EC
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A5728FFEC;
	Thu,  3 Jul 2025 06:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DlLd3yZD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C8C136E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751523053; cv=fail; b=GXBa8e+KnFoNKXRT/nioJo3Yny15HmBI6NTy2ObvawNyaJf2sABniw/2iaCDP6owBgUpgl7D+qSh5bEjF7IBqdvNN65nSI1bYIPJ1x2COLKTBQZgEveRUBbhx3gGUcATxW6WxjbYuJDb9sqZwVyKvqoIXzUz2YXJxoaiCNd9mcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751523053; c=relaxed/simple;
	bh=bU08o7ltuHgojU1qjFIv9MDao6vVBZ7WICnx9Zphk2s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rcficci1oo3knjwEy5VTW/66KYwRrWJe2wBtD1llAesTm7XeBmmFlw5Es9JTIaLFwP0xbTPgiXVQBnFGnj5YFCM7PUimJuy5uoPI2zr/jr68CdjT54uLJBA4TlMdq5tpipbpAL8LJZjZb8UFtcHAKOWA8P/u9FdMJe5+8kSrTRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DlLd3yZD; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751523051; x=1783059051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bU08o7ltuHgojU1qjFIv9MDao6vVBZ7WICnx9Zphk2s=;
  b=DlLd3yZDMn8xLGyeG+6AnurXFxCps/7y4pY/t9yH8BcHOoKUunbbve1A
   kYFxko7+yL0nyC/BBWsG4G4QpUl7EBH+916zLqJrb8DhqvJ0XVh6xmbJn
   WKaNRkcN2zj6ktFP3/pU1qqCimMBck648shBYtCiA1IzIByV6Z06cAEst
   17VrUdLMDYjvorrFpAZxF8pZzzp3cQLmLKJzkDXk89ptgumUHgcNOru2a
   vEfaSKluaOFLIYXxi33kZoOp8CMPqh83bYdXb/Dv8hCaZW3j8i6dBqIMY
   5sy3e1+u/hXE2XlsmBspHmC5HrUTIQns/bLzs5WmRYhIbfyZOlcLHfq4J
   Q==;
X-CSE-ConnectionGUID: VBQ48gkFRR+WlCUn9Sy1rQ==
X-CSE-MsgGUID: SgLTByEUSuSkqDoxPQjiHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="76382623"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="76382623"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:10:50 -0700
X-CSE-ConnectionGUID: 5la7EtYpQjWHKNaIveTEJw==
X-CSE-MsgGUID: /VeIW4I/QuqGa+hlQ9eeog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="191447126"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:10:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:10:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 23:10:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:10:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jh7AzVmlsjPHSh5zyY1mKPbIqZPfRENr+7+wEyTbO0JALd5GoGJBpYiXb4oa+y//MYAKeW8opQiaPqTpfhRPsvmYc5ySJ0j33VwD8txKTBWHWfcC6WP1Ig3yb4tbCLimvhFl4OlF/6xmJJxGehgS5Xk+JHRddTMVBfmOAF6FOCFqV2vvTgzoomq5DUcNTEYz68RAqPmIv2IdgVyTVRMrhPmhLx3NP+vMrmsf+fN311Ly3x9+WG/hF3FtQx3umVF/6nq4V/6CYyBjCgG5zO2uTdts1OzzSZKVUmCzskl9NXGjT99ynmUhYPreFrYqxUZYRNyQ4toy2C70WfD1spTWHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGIgQAxJdujsjMRW17sUtg/zrmstlgeQMlbcKu0VN2E=;
 b=Aw2EipOOYEsG/oZZY3nz1SRTl7REHkh9RuC3BYbea8Wike44VwIgUlmd76zX3N2wgqrZL8VUSu3TcMTjwxHVc3uIZFHpp9+KmBCsvCyzQ+tgReoumMCvlcggDTiT7z/NFUWnkP8Xc5x1Lz4VpmWCsRZ7QHq+MsbQ247LabFb6A5d2LuiulaBoErKaKsHhxaGqb0du8N2w3SC4hsFgT/yGe42h/7ptNRIvp8bK2vHBSIQIEifbpBpI9b8AzJzM5DeFY7Vaxm6pf8Ao+QQ1E08mibK9ESifsEpnIOqGLfQH4vTqYcyrviwFmgjY1gCkOD2PjqzxEzRcA7RxNwaYqRcig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6332.namprd11.prod.outlook.com (2603:10b6:510:1fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.34; Thu, 3 Jul
 2025 06:10:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8880.029; Thu, 3 Jul 2025
 06:10:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "aaronlewis@google.com"
	<aaronlewis@google.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "vipinsh@google.com"
	<vipinsh@google.com>, "seanjc@google.com" <seanjc@google.com>,
	"jrhilke@google.com" <jrhilke@google.com>
Subject: RE: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Thread-Topic: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Thread-Index: AQHb5u2iBX8tePb160qfph8YxC8X3rQfBwSAgAAevQCAAAGCAIAAzIPg
Date: Thu, 3 Jul 2025 06:10:19 +0000
Message-ID: <BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
 <20250702160031.GB1139770@nvidia.com>
 <20250702115032.243d194a.alex.williamson@redhat.com>
 <20250702175556.GC1139770@nvidia.com>
In-Reply-To: <20250702175556.GC1139770@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6332:EE_
x-ms-office365-filtering-correlation-id: a5bb940d-8aec-45b5-93fc-08ddb9f849f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?jnP4p5ao8fWLbH5l1EVIsaZYC3m0LPYVMawn5q/R6deSKFO8DxAMmrZeJBEa?=
 =?us-ascii?Q?4zZQiGn/YaRreV1vvzRYCp7oXbmdpg/LNdctDOVW98hNMAXtrnzGOVr0Ja7m?=
 =?us-ascii?Q?+RNelqHEuV0pYN2T1Ji7rGuKgYEdEc4OCWMj3v+Ooj3OaTapNTPWkVcixFwn?=
 =?us-ascii?Q?Wl7psaDJgvb/5C32gEJb2bFs70JEibyK1lqe95yvRknCGrlB8kgnrkbUZ/XC?=
 =?us-ascii?Q?nvPwncAjl/ekPzGFdFpKIGk9cXl/xxqb5hT/iYl8TS1Q+DwAlERV2ZwVe8WO?=
 =?us-ascii?Q?+3UEHjgkfuPiPE4JgEO1Ayu/9VxUaQxUYqqQhHNK7XYEOQo+CbUIkMZn9Q4s?=
 =?us-ascii?Q?f9J5ynectZVaAECZRSYSTx0x560gQnb34jZbANKed1dDvlkBpI/WW0QowGa0?=
 =?us-ascii?Q?71gd0wvqViEgdmKjeOVTO6sqFhrlY15+yAUloFj0mvhy8DZmgF46b8RG9kGr?=
 =?us-ascii?Q?Y68vlGFdTYwc+qZ2lTjNGsuLZb26wnhk1mNJ+Y8/fXA3Yr8YIioobmkdyHfK?=
 =?us-ascii?Q?jACuDZRs1j7/8tO4luNOfpvmK5Tdx0wBdke0hcujlLb1ha4zskg6k7GomxuU?=
 =?us-ascii?Q?q28MiETGTMPuDwAP3FfmIJv5iEGvX+evcIf13xEBg7jbWh0LEVLuNL3Hz3m6?=
 =?us-ascii?Q?AZg1O/OhwEePYu0obJdWCzQQTAbFSTqlX+bvPBT8kkzN8gWA+kezj0NLkXT9?=
 =?us-ascii?Q?4bQebvCbrFERKDfqJwcU2XY5vW3Lw0OBouLYtDj3ZaNJ63ov+i6Ba4TmDK0o?=
 =?us-ascii?Q?QQzGlK8crQKTGsw7EFlZQGie6zLZx4zeR7BVOnqeDmf1/aaH9lL30R+cUzbO?=
 =?us-ascii?Q?CKBJnV+GZ1nYLepmWo5Ab4aO1ypFkoebCKGvXavi8WwImiT9rlSObyH7e+da?=
 =?us-ascii?Q?GusA6mMyFki/UoeJkLI7xYKP5gJXVKFxvHSmxMJkFcuC6vjvZS+HZjx7as59?=
 =?us-ascii?Q?O6naap3gtyDEzoOkAA8H1OCHj6R7qj8IWJ1eiSVdOeEyQXzXvvrc4a1G0sTO?=
 =?us-ascii?Q?i8OCqHu+Y5cQhRyzGQr6+zBXX6+VfLc64tkwem7a3HR6JXLg10BzVWliW1kc?=
 =?us-ascii?Q?wbkhdIN7DJoBcrC+Mfe2K95huitA7wbicj9VD7rSulwQZzaDRj188B2pKH58?=
 =?us-ascii?Q?u3tbnQPvwx4rCTYAcZ5LY8WTts1UM8x0v4RZ2ljF0deGg/SIPKlbiwJi6DMN?=
 =?us-ascii?Q?jctXATkDZuI+yYZ8o05jKqItaAO2GWe5QCyj0p0PHb+ghTnLctjZyFNNSYZw?=
 =?us-ascii?Q?OURDzFRm3iwPEJumqB0S2ZEnZ9VM7OPfRMSSU/jpGWQqi3M4xULJdZXdfFGd?=
 =?us-ascii?Q?ZoztQ9qrRZg3uOL7ZrDdJemQCF0mYOwBNPL3tDelsGQurlCk9atCzb2L2It/?=
 =?us-ascii?Q?9ipqhxpdZ2atnOU4LGGmKOl4F9wb8u4NwfVQos8DvwvGogmBdCkry/nK/6//?=
 =?us-ascii?Q?TWJjv21Z4RRElmiU+96+dohDyjTgXK3K+e2LYdzZlFSdjTMYW3fry5HK25Co?=
 =?us-ascii?Q?N6n195c4YFhVdYA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DsDnXOpecr2EidBu/LH8Bu0kFlcFb3Stxa7oTzqCiNrzGjWvMsLg3bBIs/zJ?=
 =?us-ascii?Q?KOag4whOQhPMrDs0u5ApiHq9vKsDuAjKKGmRhuvnH1VRl0jZ7yWnOrPKHDJh?=
 =?us-ascii?Q?t/rj3hlUOCU0bIEwsJcZHaO6S6TRSpsnrYpnxHqlL6CpnJYeevYN4dzaxJKY?=
 =?us-ascii?Q?PNzswA7+n5BSBE3psTBovPrAu3UefM3QzU6VmJYa1V8gMXH/t+B85qUlVnML?=
 =?us-ascii?Q?uf1vDojO5dpTj4gHes0bDRN73Qrr6xZMvRP3H8LcoVVP4OvOSfHgFOoy+YWc?=
 =?us-ascii?Q?3ZHtCX3qbBiNPQR8zwGpO/QWNuPU7K86XTc7jAcVGojru3qhJM9gCO1ZwKBv?=
 =?us-ascii?Q?V89dTit3E/yKpAB9Nu2yFZrekae9ePet8yuk8VmuAXoLZdbPASwAbM0baZKv?=
 =?us-ascii?Q?o8lnYtxDGejnf61njEK5uwceaHIyN7lHYgTYQT3X9xIyv8JX/L1iQLCyyagI?=
 =?us-ascii?Q?38xnyKNlaNZGLzk70kPTXjYS3xaXOexIvm8zJrcXFGweD/UjalNTBHZWZV6e?=
 =?us-ascii?Q?Nc3VPjs9WGFeqRbaeahZOjfK+4uqKvmuDhFahWJ4D4CLmZeXfcNYqzIoJx3l?=
 =?us-ascii?Q?N6Chk4eMAVa7c9ZC/3utcIrpC1khJJ3m8h7ozErcneRb5aPRSjRBAMGgkaxK?=
 =?us-ascii?Q?S/hDe+fR1CRroV/RqNWoW0HMJ9XzYSFdAJoozHCSn6wJT1YKGyzkx+o7PejC?=
 =?us-ascii?Q?2Kv6gaT8t1E6KHLfhI4XW9GGbHBRR6RfzLyCIP0lBvja9uaqr5oupikSMU+9?=
 =?us-ascii?Q?cM6KXAvvy4v3WIKiQqlGsWcK+WxpvOnaESEGzfPnWORajwSR81njX/M2t2Kn?=
 =?us-ascii?Q?5kcfy0SEGjsMrboQY9bFWHkQc8eIZsLcQFoodR2F5VNOdR6JcWjAbQiy4DzM?=
 =?us-ascii?Q?E9lZXsDll+VBkLE3lNvVhUjXWSgswnFp+/218Ml8HPgmXflyeGQ5LKBFPsXe?=
 =?us-ascii?Q?ZOJcU+BTwPJIKKgW2keFL2D1lQ7WBJ2NkEfe0A04pSEUqcwD+c8zRgbowaNJ?=
 =?us-ascii?Q?Y+xNdXx4xU/EvWwd5CnUaIFh4qqSi2S9RrUN8X0ziK+OusAOi55vng6Qyapq?=
 =?us-ascii?Q?L8CENLB1gGqqVqquQexyXcCzOaH6kM7glKnNPqhPS7fSfnkG+QWjF3IwBTNh?=
 =?us-ascii?Q?lLF16A/AjejMJfzTOg9VckS8sQSK4MtL/wSu2nZeSajIwZSEWjlwY1olUIjW?=
 =?us-ascii?Q?om/iYc013hH8S3OZeGT9SvrU/x+1KRciNHmeTSVEThXW940K6N0g9KxqvXxM?=
 =?us-ascii?Q?1yalcJ2ckHR/vNQl6K9pMjaJQJvOwIm7ybKZ7O6hti8RlMm2TKzWbhXA7bWJ?=
 =?us-ascii?Q?v1ta5WSAjfV9siA7XOHn/KtNLGUhpRrYrmu1RXyDTzIzZpRgVRVgHloycQDj?=
 =?us-ascii?Q?wO4L5vmR/XUBfkY4f6WKvdZ+2gat3Ow544kyPZu3SqCk1h6ySgQk2qHq9/ok?=
 =?us-ascii?Q?bwOzN5X3LAJMa9jGSp26CZ0n9NwUSyTpESb9SjiZ9aVQ7R+ijR85MXWgW4/t?=
 =?us-ascii?Q?iWWboT6jqyTbgQNBU9beJubY8GE2egxF8sdfM6I9jUaciLg93FB573ZI+Y7M?=
 =?us-ascii?Q?rilAP6p3yr0Tr10Jzj7ElKHXOT1rk+KfMM2K9lsb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bb940d-8aec-45b5-93fc-08ddb9f849f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2025 06:10:19.9561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJaZHOXMb1qP/jQ4CWuD0N+r/5Hd7DPicwstEe240f+HY1ZSs1Y3M8dThQUUxQdGRuQeNTW13IBIqjdyl50qHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6332
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 3, 2025 1:56 AM
>=20
> On Wed, Jul 02, 2025 at 11:50:32AM -0600, Alex Williamson wrote:
> > I haven't tried it, but it may be possible to trigger a hot reset
> > on a user owned PF while there are open VFs.  If that is possible, I
> > wonder if it isn't just a userspace problem though, it doesn't seem
> > there's anything fundamentally wrong with it from a vfio perspective.
> > The vf-token already indicates at the kernel level that there is
> > collaboration between PF and VF userspace drivers.
>=20
> I think it will disable SRIOV and that will leave something of a
> mess. Arguably we should be blocking resets that disable SRIOV inside
> vfio?
>=20

Is there any reset which doesn't disable SRIOV? According to PCIe
spec both conventional reset and FLR targeting a PF clears the
VF enable bit.

