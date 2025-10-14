Return-Path: <kvm+bounces-60005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F749BD8344
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 10:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AE1284FB349
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD4A29ACD1;
	Tue, 14 Oct 2025 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/+nHpKc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42CF3093CA;
	Tue, 14 Oct 2025 08:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760430956; cv=fail; b=ptpk5XmGeB4mMP1PZJj1/bs6AYTLKix8Z55ci1MMcKun7hSvQZQ8i1KXR7HvrNuDI1z7WbsIYo5ZdDb053pl7ObB6v3kauKGvsf5HUnmwbYEJFTIqxo1Ehp+qFyoKt+plAb4PkLr3kULNz0ZDtMuQyECIrPpVRK1boLPyOXTFMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760430956; c=relaxed/simple;
	bh=iCeHtWpvvVt0Buwia36b8PhYJYP8R0A1JdIXQFS3zqg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GfdQhB5MSKeq8PE3y5xuzZlxor1vNSD8FyVqxHS7/fx3llKVuxTIK1ZkqwUqX2eUJ6RR59yl89mS1WnYLgn85gXrgn5Q7F8Jh03TfjdnSr8G030wMQHLrEXxGBcKD5MKdsZB6YOtoXzcS/7zBavw4W/dMiFyoxIHFWQ7K3mV9hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/+nHpKc; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760430955; x=1791966955;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iCeHtWpvvVt0Buwia36b8PhYJYP8R0A1JdIXQFS3zqg=;
  b=j/+nHpKceDJbOTNOhyU3SV2uA3+jlx9rLIKrcZHPhYPy7lL+M64K3nIW
   QQQv+otsYfRAtpkZ4wdrXtBJJhEbQsldibqmovdm/j6bdQu/tYdX2R39g
   YAq4iU8Y0KCgGWrQjs/zAXDDRkankkyy2msgC/SoI/WIEdjsUn1QiuGPL
   jj4qPk/OkykyUzJNe59SPin2ZHW+xxVcJGq9fBjO2Vsfz/+TIM6voPvmH
   /SsGSn8noVitfPToX/Wth1WANtndaZBVXCm7aA+snst2ta6pPgyTGtQzw
   ZLNJtvB71OlOrC8yQf3+n6ptVavMGjeDE4HaEgWiokWj5X5V5qHwNOwg+
   A==;
X-CSE-ConnectionGUID: 3RwGLe4UTRKzKKCZhDnDbg==
X-CSE-MsgGUID: kg9a3n8cRIGdT9rJoRLAqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="66438427"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="66438427"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 01:35:54 -0700
X-CSE-ConnectionGUID: bk2c6rX2SwapUV0PgR4LIw==
X-CSE-MsgGUID: 2TMT3f+HS5WUAksSBbgHgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="186080564"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 01:35:53 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 01:35:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 01:35:52 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.2) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 01:35:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Glmfwey1lIUDCYSuxBFkuXUk0Lqt/vJEw1pBAiFnFIIKs+GyphcajJafxKa39QDgByhMC9EwgIOggJEBrRsnr9hdnUWge7oqv+VXU0PwQxuPg3x1sRiwf8stOUV39rxnqN3SqxT14HVEIzRcoybFZFtjIr4YE/Ailm8PfQIfhlnQ8Wk+/SyaDvqvU7CszYws2va96Iiomuk7sZv+EJDwxrRgeqBROkClSW/9SFGCkJA3Wk2zTvPvuw75483GPpHXnYtziTVNCnFBWFGcUmflRPWTw6eGg15bAF7af5x+c8yXrf47XXgwB4NL0qClAKx7R9GRzMCJmTpe6V/Y+3Hkkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyiapA3pCdnPBwyJ1uDz2PdxOnuVIrPQPadhGIW9DNY=;
 b=xJiFLrXuR32JrDvjmKxEfhOKMn25YtXoFJXPNMxNZDYgk8KWuG0sM+igmnOGpCNTexqYGk1AkwERTQexudFeJI5hXI0PzfZtQDsXXU7VMtM0O0jfpecNFCtbWPWsS0nZFxlpUov4nuurATokihTNeePJB0Nfj/XjxRzVAvufr/mCCAzdIicEpfpTS0dK34CZ9pHPaRxoz+fUl+s+3eLYwcijA9PaLqOG/bqGzDX+15tTjIMzZOLj87mWUEVrDxBk2nsLF2wZlUBIi5aJVxi5YWkMNQSmEaT0sPITPu+z4SrZxtCmdYuTRMi5Xck9ch4wMELAIWGc7cGp+K93oDPmQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB7024.namprd11.prod.outlook.com (2603:10b6:510:220::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 08:35:45 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 08:35:45 +0000
Date: Tue, 14 Oct 2025 16:35:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dan J Williams
	<dan.j.williams@intel.com>, Adrian Hunter <adrian.hunter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "xin@zytor.com" <xin@zytor.com>
Subject: Re: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Message-ID: <aO4LVTvnsvt/UA+4@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <20251010220403.987927-4-seanjc@google.com>
 <ffc9e29aa6b9175bde23a522409a731d5de5f169.camel@intel.com>
 <aO1oKWbjeswQ-wZO@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aO1oKWbjeswQ-wZO@google.com>
X-ClientProxiedBy: KU2P306CA0066.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: b249ecf6-bd42-4b70-4137-08de0afcab22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cGBnAojAlsf2QA8l1XKI3jdWYLj2BA+XaDo6zcOXJmTX9vuHLQnFy+kUsgP1?=
 =?us-ascii?Q?eaVwGZn4DSdX9TPC318Z4BQdwYrbaHmGSqYLgDwk90qhLX9vSbjg1m/y0I6p?=
 =?us-ascii?Q?UPCKs+Z+3B2YPdvmKdgo3M2txqM6suOYLXp+JGybuiwWzUnWy3tk5EZxbbzF?=
 =?us-ascii?Q?A32xmXkO910kCGftgq8eHpJ0YQNjCRwdfe59nXblXSwEUQFu2SmUBensnaME?=
 =?us-ascii?Q?H0zV69hYYF027N/mt8FrNL1Ppae9OEkP9WIvG2tqAsJA0idQ8GaKor8+QHX+?=
 =?us-ascii?Q?VdAJ8pH65uCHYE86+V3v3CoBZuVVu/172YAuzfhNPsDExvwXCsELRp3bzfQt?=
 =?us-ascii?Q?59TSSZcMSLD7sSEUcVfSUNj9GzsefKjP4LDpi5bywQa+hSrqIqVHQcRJsNZa?=
 =?us-ascii?Q?jDYpMbm5xUO3xZa6VbXauP7N547XJlzAI+XQyl2P6LkwKSUjn3+R+xxM+k2T?=
 =?us-ascii?Q?n+6CB1SgRIjemlV76En7Hi9cTCM18l1Dp6kCmIOuOPla/luAjUTpydJwyuEP?=
 =?us-ascii?Q?2muxk5zcQO94rI5jGfdIzwf4i7NvUj8j1iN4PfiARI0zqeLc2rE2AZG917oc?=
 =?us-ascii?Q?2pZCSEAy1bbEWbbPwnCB/QaXC3mV3kV9vr/U8HWBlsrhn+iG/JQX1F00Cq6g?=
 =?us-ascii?Q?WRX6GPwElElBEJzl8sx5SMY/kCukfettwg0hVTkoPF6S5COxaGnTe2LCwCZa?=
 =?us-ascii?Q?nNH2VHNqMHK8SVUoikWDierBSOKZqCxfGzT1OBDBOAs9OBXomlSE2yD2Hh8D?=
 =?us-ascii?Q?R7wvjUg8YVDQNBwii1d81OhoRyvSNjkIWxDOqu/JYPjE/pnMK+41fpsMlNs8?=
 =?us-ascii?Q?HgDb9DFnKdG+TjpSmohr8W6LYrPV57u42Cre6Gf2uLfS+pIFxhceanhS/eKS?=
 =?us-ascii?Q?8lJ2v+FORb8APh8IfLW5cUU+yINpV2Ve2br8MykJw7ceSWXaVCSSHfcJlEVC?=
 =?us-ascii?Q?WEp5Lzlx42TPPjnRBEj5zsIrwu/RZnwqq/h1/x2+caNB/4p1CJZbjn5+am/a?=
 =?us-ascii?Q?z6AfcTuv5pmX4atqlMPkH2Keh9LY0nlp8adLu1DGqPzWNoj2USMgL5enW9Fm?=
 =?us-ascii?Q?E0Xa79lRbI4+7PnNRRqR+rbWdtBE9XA5NmGTMl6pQxqxRspNZYayJ3n45kwE?=
 =?us-ascii?Q?7u9cywHFGWU0QJ8yLBdCgUNSZOwNuTcAgwpxll/x1frqBVaAF71sBMmJJilY?=
 =?us-ascii?Q?DhtvXcLjRPjBrzYJPXH2nmbhON3cM5CqCNs4Y15Cbi922HBfkqtUn9UISym8?=
 =?us-ascii?Q?gVxDjUlsomVawko+LWF/YT/A9ohri9+IYjhMpfrgpeEIhDrm4Ve3JI2ABA/r?=
 =?us-ascii?Q?/DSoxBN6xbomK4N0+1cO7ZqvD4+BQLmnPmZBOByY2lRsJZBVCxyQwPKRnp6R?=
 =?us-ascii?Q?Zk2ytekB7OvCeEd2KhOscQK+fAJE0Om3gYZI86Y8WoZZNlDUcZf3z0k32J6a?=
 =?us-ascii?Q?gjMRf08KFJ0vVbC7GgLMYDPrsCQSDX2g?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XnP+l0hnBIBPVgBa04Ajt+4K6gId+2XzDNy9t0PPGNmMKWYB/u/nq28I4kJ7?=
 =?us-ascii?Q?s02h2jKHT2PW0EqdJC0mr/kt1Zag0M6AzASyQqSNP351sj9x5IkMyU8RcKBD?=
 =?us-ascii?Q?AtR2ogSpiacImcKSK8XifbF4KrE14EimVvpUw9dIuq7lHK7ZLNEoIVg0ag2v?=
 =?us-ascii?Q?IU/cOB91y2udHAnJEka5xI8wWc5KWoMK+HNzWy8FKaULm7VXgfFpk6Q+67T/?=
 =?us-ascii?Q?HDVwbsiyeIuJ/lFOYABOgfNwYbw0hVA6PQpC3bhLr75d0EvQoZt/PvzU3gMf?=
 =?us-ascii?Q?DbcgOxBoixF0g1Ozt8sjr0C3824UCRHLdb4l2P3fnQJrR+cmrYVThkPlUUjn?=
 =?us-ascii?Q?b203g4d/O0aT/2likZRqKJJXexuFVKjR+Hu+8E2XUtz2ZMyUAiZ9byi82MFa?=
 =?us-ascii?Q?ESipRi+AfI/5IAjd4JWCLAqtGR5zhW2IRzr8LK9/uX8wyUS6utNGeQ8kdNeU?=
 =?us-ascii?Q?hsV17IwvbVwoo74ztAjPcYQfGsO1ZoaYT9lYsOlEhZznMLQTtxsOR4zM43a5?=
 =?us-ascii?Q?3umHfSGQGeCL/AJCLVzM120QFxT5Ey4b83kmdV4ny53yKAhSLUC9oywTYqUT?=
 =?us-ascii?Q?X8vIFDD8VvYY92XgRbOpobfDqC5IIMLitCJORBxPdlOq6vhe2MVbnvsPMhfG?=
 =?us-ascii?Q?pNoVOKVCVURPXN9QqIQNiFyMVrRBshFUguDRDOi4R3xv8HDufTF2DkTL164J?=
 =?us-ascii?Q?U5nB+TLHAAsD1pGfSH2VVPitV/hts+fhK+WX7ZgXtL1UodMsRp1umh6cEiPa?=
 =?us-ascii?Q?uPnyZXxurHd9Sjd7NjZ90Gu+ywFeZx+bHPOq9LJsfKWLi1Vizx/cZ/519sTa?=
 =?us-ascii?Q?uywjSni5N8LZYCJY0h3L7SUIpoFYBCF/bDWXHm9RP2I6uz40MKzl8NFgXtkD?=
 =?us-ascii?Q?u87EpP5u3afdrUGkuIX8e3sE33fHgG2I5uB5Xtnsbu8kBjCzKmiPYhc1lbWN?=
 =?us-ascii?Q?3MqNxbhfmuMsDltf/BfG1s1nBRfqQ91vVn7rXcvDfbfOjMqkBzyxNm19LdXC?=
 =?us-ascii?Q?qtVnMFBzQq9T+d+Bav+F+bSUET3vEQ1/QOWwx+Efd4RVdtGQId7Vg9/GkEgN?=
 =?us-ascii?Q?qG04AS9obcIJSEot9iNuavmuwaZl4HQk/bogs/cRNoz88dboo9JJEvYZsSad?=
 =?us-ascii?Q?mW6KEcBlg5hyuc8/rOZQlL6Yx7+AkZjIxE3t4JJUdEpt2pa4yP7pm6pZF7Uu?=
 =?us-ascii?Q?+krUZX3HLuoDe2zkbs+IEczKggIrCUOM6lbJuSr6XtJxzjLigUGNrrHA2sEv?=
 =?us-ascii?Q?Ig8kXFiJSyCxqcWxEIcvKeFUnBwl+Aae9rHJ+kgnmkvDhj+FsQfHUQLIeefJ?=
 =?us-ascii?Q?ZnaDsI9y6NUvK2GT04IPeQJ15G+uPzrnB41DBBOku8efIaNnQw4t4Qmg2HQ8?=
 =?us-ascii?Q?rEA5aC8rjdgzPQOETasr5u/tYoOeFS3tkvGrQfS0qasdqq8r8/VqMz6OMIV5?=
 =?us-ascii?Q?bMTKldL/IILG/dJNOL+w/g5ksQomj9QLKEKBJs2modUztO/C0PI2Qkrc4GP/?=
 =?us-ascii?Q?Qk79eqi39TSu14sTAa0ka9LcfkrGj3hhinm56GxJjUF3PaEVqwtmXwmP8/1a?=
 =?us-ascii?Q?4cKOatwdSVruU9+wZq7TZCaulUSKzb1dphE2dhFl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b249ecf6-bd42-4b70-4137-08de0afcab22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 08:35:45.4557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SteGGTwUBAAr3TYvfTbfm85Ag3u+DTPS6EHhL8mKOFK0b/2VQmQzrzi7iRVHxIHIU+H+EztJddFR/x9ki/Bxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7024
X-OriginatorOrg: intel.com

On Mon, Oct 13, 2025 at 01:59:21PM -0700, Sean Christopherson wrote:
>On Mon, Oct 13, 2025, Rick P Edgecombe wrote:
>> On Fri, 2025-10-10 at 15:04 -0700, Sean Christopherson wrote:
>> > @@ -3524,34 +3453,31 @@ static int __init __tdx_bringup(void)
>> >  	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
>> >  		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
>> >  				td_conf->max_vcpus_per_td, num_present_cpus());
>> > -		goto get_sysinfo_err;
>> > +		return -EINVAL;
>> >  	}
>> >  
>> >  	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
>> > -		goto get_sysinfo_err;
>> > +		return -EINVAL;
>> >  
>> >  	/*
>> > -	 * Leave hardware virtualization enabled after TDX is enabled
>> > -	 * successfully.  TDX CPU hotplug depends on this.
>> > +	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
>> > +	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
>> > +	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
>> > +	 * of a package would prevent reclaiming the HKID.
>> >  	 */
>> > +	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
>> > +			      tdx_online_cpu, tdx_offline_cpu);
>> 
>> Could pass NULL instead of tdx_online_cpu() and delete this version of
>> tdx_online_cpu().
>
>Oh, nice, I didn't realize (or forgot) the startup call is optional.
> 
>> Also could remove the error handling too.
>
>No.  Partly on prinicple, but also because CPUHP_AP_ONLINE_DYN can fail if the
>kernel runs out of dynamic entries (currently limited to 40).  The kernel WARNs
>if it runs out of entries, but KVM should still do the right thing.
>
>> Also, can we name the two tdx_offline_cpu()'s differently? This one is all about
>> keyid's being in use. tdx_hkid_offline_cpu()?
>
>Ya.  And change the description to "kvm/cpu/tdx:hkid_packages"?  Or something
>like that.
>

Is it a good idea to consolidate the two tdx_offline_cpu() functions, i.e.,
integrate KVM's version into x86 core?

From 97165f9933f48d588f5390e2d543d9880c03532d Mon Sep 17 00:00:00 2001
From: Chao Gao <chao.gao@intel.com>
Date: Tue, 14 Oct 2025 01:00:06 -0700
Subject: [PATCH] x86/virt/tdx: Consolidate TDX CPU hotplug handling

The core kernel registers a CPU hotplug callback to do VMX and TDX init
and deinit while KVM registers a separate CPU offline callback to block
offlining the last online CPU in a socket.

Splitting TDX-related CPU hotplug handling across two components is odd
and adds unnecessary complexity.

Consolidate TDX-related CPU hotplug handling by integrating KVM's
tdx_offline_cpu() to the one in the core kernel.

Also move nr_configured_hkid to the core kernel because tdx_offline_cpu()
references it. Since HKID allocation and free are handled in the core
kernel, it's more natural to track used HKIDs there.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c      | 67 +------------------------------------
 arch/x86/virt/vmx/tdx/tdx.c | 49 +++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d89382971076..beac8ab4cbc1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -46,8 +46,6 @@ module_param_named(tdx, enable_tdx, bool, 0444);
 #define TDX_SHARED_BIT_PWL_5 gpa_to_gfn(BIT_ULL(51))
 #define TDX_SHARED_BIT_PWL_4 gpa_to_gfn(BIT_ULL(47))
 
-static enum cpuhp_state tdx_cpuhp_state __ro_after_init;
-
 static const struct tdx_sys_info *tdx_sysinfo;
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err)
@@ -206,8 +204,6 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
  */
 static DEFINE_MUTEX(tdx_lock);
 
-static atomic_t nr_configured_hkid;
-
 static bool tdx_operand_busy(u64 err)
 {
	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
@@ -255,7 +251,6 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
	tdx_guest_keyid_free(kvm_tdx->hkid);
	kvm_tdx->hkid = -1;
-	atomic_dec(&nr_configured_hkid);
	misc_cg_uncharge(MISC_CG_RES_TDX, kvm_tdx->misc_cg, 1);
	put_misc_cg(kvm_tdx->misc_cg);
	kvm_tdx->misc_cg = NULL;
@@ -2487,8 +2482,6 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
	ret = -ENOMEM;
 
-	atomic_inc(&nr_configured_hkid);
-
	tdr_page = alloc_page(GFP_KERNEL);
	if (!tdr_page)
		goto free_hkid;
@@ -3343,51 +3336,10 @@ int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
	return PG_LEVEL_4K;
 }
 
-static int tdx_online_cpu(unsigned int cpu)
-{
-	return 0;
-}
-
-static int tdx_offline_cpu(unsigned int cpu)
-{
-	int i;
-
-	/* No TD is running.  Allow any cpu to be offline. */
-	if (!atomic_read(&nr_configured_hkid))
-		return 0;
-
-	/*
-	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
-	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
-	 * controller with pconfig.  If we have active TDX HKID, refuse to
-	 * offline the last online cpu.
-	 */
-	for_each_online_cpu(i) {
-		/*
-		 * Found another online cpu on the same package.
-		 * Allow to offline.
-		 */
-		if (i != cpu && topology_physical_package_id(i) ==
-				topology_physical_package_id(cpu))
-			return 0;
-	}
-
-	/*
-	 * This is the last cpu of this package.  Don't offline it.
-	 *
-	 * Because it's hard for human operator to understand the
-	 * reason, warn it.
-	 */
-#define MSG_ALLPKG_ONLINE \
-	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
-	pr_warn_ratelimited(MSG_ALLPKG_ONLINE);
-	return -EBUSY;
-}
-
 static int __init __tdx_bringup(void)
 {
	const struct tdx_sys_info_td_conf *td_conf;
-	int r, i;
+	int i;
 
	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
		/*
@@ -3459,23 +3411,7 @@ static int __init __tdx_bringup(void)
	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
		return -EINVAL;
 
-	/*
-	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
-	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
-	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
-	 * of a package would prevent reclaiming the HKID.
-	 */
-	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
-			      tdx_online_cpu, tdx_offline_cpu);
-	if (r < 0)
-		goto err_cpuhup;
-
-	tdx_cpuhp_state = r;
	return 0;
-
-err_cpuhup:
-	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
-	return r;
 }
 
 int __init tdx_bringup(void)
@@ -3531,7 +3467,6 @@ void tdx_cleanup(void)
		return;
 
	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
-	cpuhp_remove_state(tdx_cpuhp_state);
 }
 
 void __init tdx_hardware_setup(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index bf1c1cdd9690..201ecb4ad20d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -58,6 +58,8 @@ static LIST_HEAD(tdx_memlist);
 static struct tdx_sys_info tdx_sysinfo __ro_after_init;
 static bool tdx_module_initialized __ro_after_init;
 
+static atomic_t nr_configured_hkid;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -190,6 +192,40 @@ static int tdx_online_cpu(unsigned int cpu)
 
 static int tdx_offline_cpu(unsigned int cpu)
 {
+	int i;
+
+	/* No TD is running.  Allow any cpu to be offline. */
+	if (!atomic_read(&nr_configured_hkid))
+		goto done;
+
+	/*
+	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
+	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
+	 * controller with pconfig.  If we have active TDX HKID, refuse to
+	 * offline the last online cpu.
+	 */
+	for_each_online_cpu(i) {
+		/*
+		 * Found another online cpu on the same package.
+		 * Allow to offline.
+		 */
+		if (i != cpu && topology_physical_package_id(i) ==
+				topology_physical_package_id(cpu))
+			goto done;
+	}
+
+	/*
+	 * This is the last cpu of this package.  Don't offline it.
+	 *
+	 * Because it's hard for human operator to understand the
+	 * reason, warn it.
+	 */
+#define MSG_ALLPKG_ONLINE \
+	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
+	pr_warn_ratelimited(MSG_ALLPKG_ONLINE);
+	return -EBUSY;
+
+done:
	x86_virt_put_cpu(X86_FEATURE_VMX);
	return 0;
 }
@@ -1505,15 +1541,22 @@ EXPORT_SYMBOL_GPL(tdx_get_nr_guest_keyids);
 
 int tdx_guest_keyid_alloc(void)
 {
-	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
-			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
-			       GFP_KERNEL);
+	int ret;
+
+	ret = ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
+			      tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			      GFP_KERNEL);
+	if (ret >= 0)
+		atomic_inc(&nr_configured_hkid);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
 
 void tdx_guest_keyid_free(unsigned int keyid)
 {
	ida_free(&tdx_guest_keyid_pool, keyid);
+	atomic_dec(&nr_configured_hkid);
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
-- 
2.47.3



