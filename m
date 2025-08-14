Return-Path: <kvm+bounces-54633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7C5B25903
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 03:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 480D91C22D13
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 01:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C78204680;
	Thu, 14 Aug 2025 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7iJseiz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DBB126BF7;
	Thu, 14 Aug 2025 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134831; cv=fail; b=RUMt4EFsshAa5Wn1cl2immiPkKIZf4PLxUhzSuNnVzxHRMbER/euJQjN03ZGKTqtODwvIBpVi0xYPQ+vVQoOsNdWkudz1cJFQEvf01x0o4XlymKeFxKkQEPnYu6J3+rKPCReK11qqWiZFHTPlstGuczp4vJy9NWx8zOmz29m2PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134831; c=relaxed/simple;
	bh=Jwy/cjALfIKNOV8BTqLyMz4+LBHyyJQlUls3H2HhDRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwFIYkbaWCULEkG7+UUWKKhJAIiB4JY8AH99Xhx4LM1Anph8aQGbFNBNbFWSOYyFAcEXrCoFPilqUWijM0SX4V4lRyTtFGlcNj/5kvc7jCnFnuCUgkUR4WoP22IpZikV8MaWAGx2bAeyj7vt63xzg/j5A0ptolQEeAUS7QuXjy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7iJseiz; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755134830; x=1786670830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jwy/cjALfIKNOV8BTqLyMz4+LBHyyJQlUls3H2HhDRg=;
  b=G7iJseizmTXeFauS7Kvs6XvcWqhgMs+GJpmRcB9EhaObZ82bEkrlcQ3w
   vsFoXzJqeZuKPR6jWwYv82kLkL+hKMco1i/UBvE+2yWzLj8vVIGYVYARY
   iu+JfBsWZE07CuEHs1CHcY1cP/NPKcJ5u+XcHsfVLbGBPKAz9DFqO0ibe
   D0V2HHMJXEqo+XrWT8GN4kccryLx3GxzMTVOsJI1vjQMiaqxsxdRbxYZq
   8o6+13vDmlmKPIFuROI6F2sfhXGbxBkQU7Ld8Sd/1kSNA8/HPD3FVygDO
   eIVi8iQ2HfPxILv6bWTDywkaMIJjmzpEFvFzIQbx/03RXBOXI1YHrfPUa
   A==;
X-CSE-ConnectionGUID: ZjW8ouHwTH6+2/J8uL7pTg==
X-CSE-MsgGUID: b1TWxgYNStS8soTa7YVACg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57512549"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57512549"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:27:03 -0700
X-CSE-ConnectionGUID: a7HUcEMFQvO89FoLY3eO+Q==
X-CSE-MsgGUID: t/qImm6rRaG35yS+nxvz6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="165807811"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:27:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 18:27:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 18:27:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.80)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 18:27:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pot0flhfmbU6AFWlCrViqc748xXsPoxOJndVxejJUeFhCtwveK+gkU2uiLBAiqrOtOrFFrv/pW7PjoRfarnA7GCDzNxyPKZgtwb9duOY0T8Om/KBP2UCDU66iCU4w1iW7yQpqR5gtw1vaKHsn8wCsOtiNW+FmJIuhYT8pGUQNMwDfSsS3BSRSWc01IXGVjrLG5zF/+ry3W67+pXy0PIx9Ve6ph0rpgsIZpaf1CU6yQwLItneCsrKlTrsFHRQYU6A/AfK32TwEbJpNBwhOpWybkYg6/4LiDJnLDWYNE7zVktA4G3ml2Xp4QXcPt20p3F6T3UYUoNyJ02zzcT7uB7cTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jwy/cjALfIKNOV8BTqLyMz4+LBHyyJQlUls3H2HhDRg=;
 b=hkO7O4o6yFGw3N1Hu/JcCGZE5d/UDAdEW9eVvzGEjXLhXotooqCY4qzAuC71tCuD2vB00LgwfgupUDpzkP3UtL/PR30IX/aaOeyDkaOmbxR8ZTQZegdZlT9IDD3mYsjlNNurxDbNIVEJqsVyOuV/3/tH7aWogjguR10Z4YtiZso8Ne9Hy8UntD39S65q/SCLt90unq2jUuecT6vJ/rUpxszfu64YAo8klPokbfiRAdhNNBfiZLH42rsYiNX5AtJsS8XKbv3uygxlwZS+6i0PeofLk4d7moF0/TAsg8h8YKbBGgU/CA+0jLeRA9S93MhEeiXn43f/Vu1gWRXFxFnIWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12)
 by CY5PR11MB6463.namprd11.prod.outlook.com (2603:10b6:930:31::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Thu, 14 Aug
 2025 01:26:59 +0000
Received: from DS0PR11MB8018.namprd11.prod.outlook.com
 ([fe80::3326:f493:9435:d3df]) by DS0PR11MB8018.namprd11.prod.outlook.com
 ([fe80::3326:f493:9435:d3df%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 01:26:59 +0000
From: "Guo, Wangyang" <wangyang.guo@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Tianyou"
	<tianyou.li@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to
 virt_spin_lock
Thread-Topic: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to
 virt_spin_lock
Thread-Index: AQHcC+yQEgE5TQe78E2AKtk/v3wmArRgpqwAgAC2XAA=
Date: Thu, 14 Aug 2025 01:26:59 +0000
Message-ID: <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
 <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
In-Reply-To: <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB8018:EE_|CY5PR11MB6463:EE_
x-ms-office365-filtering-correlation-id: 6165137b-2244-45e5-3c49-08dddad1a9f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?vr8wr3JTeLZcNtZkvOVzT8buu8ShwH2EdZiSA80FnH9OebtK4j5h9TGm8nnr?=
 =?us-ascii?Q?jxe6GIVJ6neY06zgJ/f79rYoj56QnNBApDgeBxJ9gj1kXF3xETVaGclceJgT?=
 =?us-ascii?Q?Vq4iJKfyqCULBDmvFwgsOKvegVsUzbKaG1wwMFZu8ceI2afy/on8ZoKh8OMV?=
 =?us-ascii?Q?suF9e1ia/2jULNr3RouiiastUYiiuPgmxjrb9/GCvJNo/RM/Ir/5h64pdN4q?=
 =?us-ascii?Q?Fbft7BzwyNqEsyDc/9x2isInSkJ2iq8liD7R1yofqxGSxMQ56wwKNo4vUdoj?=
 =?us-ascii?Q?yRbkR2Kahgx7PZLkx3W5Fe0zX+pIvcxFByK8M2ay691RCp01lN80SJEN3/VI?=
 =?us-ascii?Q?Guj1LlKtCJfPA7dbhj+xQ/Sni1TP+Ck+sWREZF5uKgwWiXztflzIwFtTaO7D?=
 =?us-ascii?Q?k5PODc21Wqv7HR5L2FYvJot7sTdRfxJ1JmGd5tUJcYv23ZVV1he/+tNedufi?=
 =?us-ascii?Q?9yiepODHq9+PDcMFMVbNhA8adqlv+XhdhDFnR9hX3Yx2PrzpI8m4l9yN8Djm?=
 =?us-ascii?Q?JzFOfzYvLjkYhY9yaNOYNrHwdHoJ2ztcrTUyqwo3H/GGRp1/0YLGU6Vt1VZ7?=
 =?us-ascii?Q?9HDfpu2cMcJqkW8/5cRuzoSikTohFydwtamG00sZZ/wCRP6eIF9bGjQjG+MX?=
 =?us-ascii?Q?LcRzn45AIHKgF66/dIPcfV+JdyC8PCdFL/6jZXsF25EYiZwSmXRBfRKp+T9I?=
 =?us-ascii?Q?RuoIiogSTajBwwG6Pr49N3PEzQIHhcz2I0I0vByjUzTZ5LsprNfQDx2b6dE2?=
 =?us-ascii?Q?sJKc6RE6NtxyWbgEafq0IQlvlEIgs0HZjiuFKpDpLKgOc8hAdMOD0AXZHU0D?=
 =?us-ascii?Q?zZRrW7oNSmQ/J8C73XAN1MLtY66amR0OwuOCyNe8ESlCoIeDDYm8urGoqJD6?=
 =?us-ascii?Q?LQb2kZjjUcWMiUh4ehNEg64Np0ZggGrt93l8leLzxwfCtr9iCFu4aPv9GwyS?=
 =?us-ascii?Q?s8fq/b8o8upIPR9YlWMQNndcmer49ZnO6SX4Ao+zoFsSepuPVu3PKnGZMlZE?=
 =?us-ascii?Q?1iNrcgaZQtbANaWMGHFYda4/V0kH7MVEfi2TE72YDjUaUYzHOZGOPSFmreFb?=
 =?us-ascii?Q?VfaEHjImauDwMPQpy30xnd3RNEe+hG/bbz1bxg6eUr7dwqdhInPEDbr6bd0K?=
 =?us-ascii?Q?XX52NlFfadXt2e+V0vatCHpo++2vLmwK0VM36p2FU7vsCbbLVnCQUtllyb/z?=
 =?us-ascii?Q?PqLLSb7gGJ0pbWyQnc4AR4KEafMO6k0+fRCTCHkNahr6Mr+BEm6nJQXW9rRt?=
 =?us-ascii?Q?aFG8AHxNO/TJAef8mnOYWBXstVwPB5MhmybPyKqS8mI7ddZfGSXVy3z0n/UN?=
 =?us-ascii?Q?UZHdSvoYJEKG052eG+7lQlgNmxJoYrlaibfWY5zBZtchxTUPSZ+uSBDPfbk9?=
 =?us-ascii?Q?/F2pAPhNvw/RYO2WaY4q5dZKLa4ct91nfP6TVLDAnYkDjvO25IzKaR50P+y2?=
 =?us-ascii?Q?PeSaq4COXeQonRloxLfCBZg2AiIzu1RONiIBvtUG61TGdUwWkpAEtw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8018.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?41o87ffbOIty/ONWRbooytzRRHWHsFXlaH1huvy4hJvLdG1JtG5gqVYpZm7W?=
 =?us-ascii?Q?fU9Ux3y4bP067gPgibIMFZHJLuwwXDPa6CEaop4EWQQJ2RGiqwazSe/K/OGM?=
 =?us-ascii?Q?a9ITnrow+mtrdB+jTfmVi7xs4LCT9zy5yA55Rsad6lawA0NEGvQ3xWudZupw?=
 =?us-ascii?Q?Fz3yyuPIlx2u2Hiic/wsOng2eiTj0D8sOR61d+Ocoab6Dad11pmMSO2HqoBH?=
 =?us-ascii?Q?i33NM+t8FlQ76mTYPIwkA2nbaK9eUVfZEgKKYV5Gbc2hgW+wB6iLsSWJvYmN?=
 =?us-ascii?Q?LiKOjxv8K2NvRp+2g3Z4AfazDtVJdBwHSls7Z6rkYFgGNos3IFuLEWWzC5wZ?=
 =?us-ascii?Q?IOHUonc3TYrNlgOoy68spwY7sxVm4vujwnip1ADGw74yO1WBb3WaKK7wjrtu?=
 =?us-ascii?Q?hQ8/LE79116uDTb4e5HBtjl18km/YzsUZ84+JTMj9AB3HB3ZG+9yQuLOl7U0?=
 =?us-ascii?Q?8Gb48h6ph5ZDh1XEDSbNa/7N+oNE0CLP2xRpmNOGeDhdy8KnsxgXxgGbq36X?=
 =?us-ascii?Q?mdo6jk/eQzL1pmBX9iXD/ar4E1qmD7x07vQ05aXospgxjv6OI2kmpLlPgIjq?=
 =?us-ascii?Q?i/DjRU+jFoMqwx4SczTVGfWRw9ETDf13c4MyhS8gpEUSkpANr9JDNJKwfV7j?=
 =?us-ascii?Q?WThOUH2fdmxuOaXnlF2uP5F2pq/hed5Flnbck808ATw1n1YEJz3nnBHON+1w?=
 =?us-ascii?Q?hvor3GSNkLF265VW/5BWpmUhCgzy12Wsve5FydEbxhd+T4bJCKyDj6x8Hsn1?=
 =?us-ascii?Q?LMRLzzd9X7yxdYH0vjzDmI8vrVSUMXnnuTGH6RzJwWIhxoKtMj29KyllIg1O?=
 =?us-ascii?Q?EqkZcLFRddURWptKJSYl5GLGgEuidLNeVVe7Ivnx5Um9twjCurHxWMgHj0hf?=
 =?us-ascii?Q?fYdWrxwBpNEUdDFIg/pRYLoH+644tLIxAFyfjMZvHdx5b2ltyDx0nl90CjF6?=
 =?us-ascii?Q?4eWyxfIT1L/0hwINtYdWONv7DZr255w4OFeo2KUuEQIfQJ6xWrkg/Rto/wH3?=
 =?us-ascii?Q?AOuuhWi82vM0SnNyNDCAEbZ4SNkERU5lbuIre9k2FmzjhmboHWvEaeRgM9Zq?=
 =?us-ascii?Q?YS7LTxdtwPbwgTCXibrxjJkmD8mrI96Uba3ctJPA8InbsSLx1omQXwFobv+T?=
 =?us-ascii?Q?7emc7yx7WHkBm+vb/fUwdqw3IAktYFN0350pcHM9+ton3P22VhOBVp4cDIAs?=
 =?us-ascii?Q?7M84XhXPI63Ww2cbq0wGwjlGJOHbWm9536ijVERDXBCMZpumZBKHw0QgLQSs?=
 =?us-ascii?Q?AxoENn7+hOo4FD/ZTUbsQm5pMZR1pJYWR66PpiCfQc6jJP1g+k+t6Nng7oLX?=
 =?us-ascii?Q?TZRM1EmXy7xU+vx8pV7nuzp5r6HLjk3xlg8+dClZzkqyCbpNQ9JrD+/R4i5Y?=
 =?us-ascii?Q?F3zU9la9RTT4JADGgD0rP8jEsoOBs3s5h10n1xOQRK5VgLlfHMHLKbVvDoLi?=
 =?us-ascii?Q?kFo69IucwwR57usRsxtSoebE2RELAl97dJyFjZH7f10LyATMijvkJjyrriXc?=
 =?us-ascii?Q?H5r2XE4bx1WhWONCsdA9M+oA0on76leuSYKarqItMOBSbhxjc2ZmqcV8tTWN?=
 =?us-ascii?Q?AmbbiDSMvKph8NVUKfo7i3ocPeLDRzP54Y+1Bpmb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8018.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6165137b-2244-45e5-3c49-08dddad1a9f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 01:26:59.0471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgfP7+PSx62nL5ILnHXsSWBUXIX9t3rz0bKgNCVGJtLGIutuwPeqov7umYJNCtU+ASfBOQCQ9ho+SDJgk0hPQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6463
X-OriginatorOrg: intel.com

On 8/13/2025 10:33 PM, Peter Zijlstra wrote:
> On Wed, Aug 13, 2025 at 08:50:43AM +0800, Wangyang Guo wrote:
>> When multiple threads waiting for lock at the same time, once lock owner
>> releases the lock, waiters will see lock available and all try to lock,
>> which may cause an expensive CAS storm.
>>
>> Binary exponential backoff is introduced. As try-lock attempt increases,
>> there is more likely that a larger number threads compete for the same
>> lock, so increase wait time in exponential.
>=20
> You shouldn't be using virt_spin_lock() to begin with. That means you've
> misconfigured your guest.
>=20
> We have paravirt spinlocks for a reason.

We have tried PARAVIRT_SPINLOCKS, it can help to reduce the contention cycl=
es, but the throughput is not good. I think there are two factors:

1. the VM is not overcommit, each thread has its CPU resources to doing spi=
n wait.
2. the critical section is very short; spin wait is faster than pv_kick.

BR
Wangyang

