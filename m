Return-Path: <kvm+bounces-53715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B448EB158A7
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 07:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4EE3547563
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 05:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8427C18859B;
	Wed, 30 Jul 2025 05:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L2sEr5q2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632018DB0D;
	Wed, 30 Jul 2025 05:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753854980; cv=fail; b=JykSExk+vJCD0AIvgnO7laHNzPEOwHJiNvgJRWOzvconIksrcrQ5oUL52xkvHfdj6KNIpOIa0bAKnI41yFqy81IHfSBIhJ8KmkSCQ8AWUpFUtzqY1MjBp5RhHD/KsLyqRRSLIhbLD3NECBzz6JH9w76s6maG7qiqqmB1plf5OVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753854980; c=relaxed/simple;
	bh=lHoYAxbJDJ9LfjFcJpfEaPhLCZBde2ALfhZUbuzVwI0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ofwd+vxYLTU0GrvrjXnFXFYX0hwb50kMy8VJHzynwTSy724hN4sBw9L83sBBQX+4jmdrZ9kvjDx6FS4y+PQq9ueVZaSPfEqJeAjFfSDiXBSJ9wTTmqBbeFDMFg2WBJBoT8tJ0AqnpQCWSrxaUtl8qA8b/l71n0U8PelkLGESY5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L2sEr5q2; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753854979; x=1785390979;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lHoYAxbJDJ9LfjFcJpfEaPhLCZBde2ALfhZUbuzVwI0=;
  b=L2sEr5q2IvyKJPbh6RkaQ6HHdIDxnZTxy4L6JXyWtB+vdqqqxehygsFZ
   /ezXUq/V7E1TwsQeT1iEExKhNwykHBn6eq5KhfLij9IrIHWBUvu/3pJKe
   BodikB0BUoC3BVqnLAE3aen3FSQFym43d9VwXh+fYDE/yoK+8/ymV77QC
   Vepb99+OQyGd9Wpp4X1xo1Bilz3m1m3FPqGsdCePw5SBCBwpCqyHAF27f
   PrNwXC7qSMASpNKU2UsyOyXvxldbi/+6yBTA2e1xmafSfB1B8RP0O679G
   1vPChre/iEbYH8P7aXsjdcBV5wSkVYcvFiH8dtwhal/1/7D4/0y5sAEyq
   g==;
X-CSE-ConnectionGUID: E6l8lni5S8K81XnbxI9OyA==
X-CSE-MsgGUID: QwRtCh5WQJq2nZn+5p9v9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56292020"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56292020"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 22:55:58 -0700
X-CSE-ConnectionGUID: X+j1SZDlSPC+FFC5Cd+HXg==
X-CSE-MsgGUID: GztVf9++QlqyjUrYTaamvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="168193295"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 22:55:51 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 22:55:50 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 22:55:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.85)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 22:55:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b1w6LvlbDDe7rVnqa/P+KmvvNdkdFUTZyHUipo0m1hHRIOfKzVD6pgIO4gZT/H/nUSMkavQHhrUh+3t1xpv3Fm4xULO2NJMHZLIawbdGfKazUvrmKhZ2QRQjnxk8i6eK6moY1f0DISqNInfx26+Y9roQ3VKK8ZNQDuI9/xVkQVqVdSp+8L4SeuEGe9o8nET3Rg4qLXRy1+qLWSEn9Ff1OtBW5ZKLJUkDEfCK7RscAFEk5AvhRANA6Nh0oCCv5gtbdXgJBgVAufmfcJ0tIJOoENhPHndGY7P519JdPxRHwFQqEW1xKI/XSMcHQwF7ADEDgR+DWZNBJUo2nX/MEWdiCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmgTV8VpBREe4XW0P5XnqpNz0Wsdqgh+PC7XQrWxntI=;
 b=FMoX3tde0V9nfyshDN3YreXhJfdko9ZUZ28UnC/VDWaExjn5p4lO+XMHOi/Du2xZweJOGKcT4v/dQuAr9wCbEw/odCoBkymMwZ/4M/z9ufiuGRhxlT1YmOhfGjOOlMkmnTwZi+aJOCX1FSHOAEy/i3RW/aaaAF87RaWZaRPr9JkxxEQLgrOhyKdji7Gl9lka7cDozSnxjWFIuRvP+QzlAukNe8H7XApIrVOL3HF2Mpla3ZFrhzKTxS6Bjc2M1ARgPdrFWH93EOSFJ7nB62eu+bQeaw0ES843Ld+CzjWOqw8lvgBNVqkgSrW4dqCplBtiN0a22mW/IrPb5scMxir6sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6426.namprd11.prod.outlook.com (2603:10b6:510:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Wed, 30 Jul
 2025 05:55:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 05:55:48 +0000
Date: Wed, 30 Jul 2025 13:55:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Message-ID: <aImzwgbuZniu31/V@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-3-seanjc@google.com>
 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
X-ClientProxiedBy: SG2PR06CA0221.apcprd06.prod.outlook.com
 (2603:1096:4:68::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: a84950d3-b971-40f7-ec27-08ddcf2dbb5a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?HK7qDGXkzjlyGKfm+I+ISHJge1F5nYHeAcSvYBv004UWKl56zmd7+h04lu?=
 =?iso-8859-1?Q?aGEEWxo5Vg+A24tPjEhy2tRkZyJLDhD9xK61lV0FA5kHlAp+WQ9HiwdIcx?=
 =?iso-8859-1?Q?EQwtwGirb+luurHNUHranlP0tO8tH/m69XQl/8nVAi8p4B5rzSoJr3Pr5X?=
 =?iso-8859-1?Q?BIokmM/2Hl2EIXK7nptFIG5EHaDf7p9Cv1RYCDn2K3yxMsg+FVSUnavPVd?=
 =?iso-8859-1?Q?w5onq0Uc4u7YkAg2GOwW5WuIQXj3ZWeqFJ++WQK/IBRpZVWTQaoaWvwObm?=
 =?iso-8859-1?Q?kCtRDDT7JOQwnX48UOpDQJUGzwU9+C+DgV6wUWUDb0X7DjCLeblGu5Msgx?=
 =?iso-8859-1?Q?VJdIvEewd5HH1zdUooz8ytaE9mqy2YKv9geDZv6a5W5/Tq6f3gjRncSDt9?=
 =?iso-8859-1?Q?5fzQQNyEiIFZxSWwF2eW+JkK6yyTerBkViznn7W2CXmLBuBgfCzdVndH6L?=
 =?iso-8859-1?Q?NIwo3G4NuSf+Ichq4HJpPR4S5WHbUATesgM6/R9t/ZE9/Vr0T24eNwUEyQ?=
 =?iso-8859-1?Q?Q/HEDv+Uksc+hBHL5qukiAVYBM96ZohZU/v9ZTXifvWyoQ/TWIgmWY1jsp?=
 =?iso-8859-1?Q?F5yqypnmAjASShFp8bf5TAMXDQ1b5c6rvlkt5NBA2PAWWheId9bc/iVF3t?=
 =?iso-8859-1?Q?VaFDSdzivgQLciA9nwQLq0S1roPBSvMKzSPbZIMOceXClCTuJetoxWreib?=
 =?iso-8859-1?Q?WumjVE7WqQ/Q1BBDHpf0wvQVzFzxwoC0vOIm7klkzPAnxRtxa20pZJLK5F?=
 =?iso-8859-1?Q?sft+mzwuWek5WDvMKlx6phSCn5W7lHR2T2mVns5I7/b9S8Uyx2U9bodzq7?=
 =?iso-8859-1?Q?prM69OJ/KHnl6//46NMX6eTWcITDVOrLyzbzRkw92l26uTnMbcUF6CgJvn?=
 =?iso-8859-1?Q?wb6p92/nDKv6RDfJYPAqoZPxaQg8WGHuxkowa8FJfbBL81F4r9R+C/Bqlo?=
 =?iso-8859-1?Q?eUHVNDAx85/iqGPoGt3WcD1RH9Yz6X07gRp5w+rQpmjZsjXyeKdghdGVFU?=
 =?iso-8859-1?Q?jhEY+0iaRnSPwyJ+EEa5gMwQcFrql7Rb9nG+ZYEmKLyR3g4ppu+FaSNUcV?=
 =?iso-8859-1?Q?O6d0H4h5gN9Yxs7FNks0NiUheF5F1kOYW3VT1rsbuIhq1OgWOHudMlTN8g?=
 =?iso-8859-1?Q?TIaFHH7jHqVEr+ntzoODNkyFW3lvJxmwQMdm9OqC79goVVpP5QqPLzoeBw?=
 =?iso-8859-1?Q?sllXisTg97N6lIya64PbV+Awg3A7mkIhX8uxlc9z91SH7Sam+9GOz24Ov1?=
 =?iso-8859-1?Q?BG8/eg4wvQ0pRQCk3IFSZSY2L5GaxSVamo90ohCIqm7xcfRBKWKuSdg2Ui?=
 =?iso-8859-1?Q?aZEMdrpPdIgu1ELzmLxro/AXh6QuyblmF4Cgi4n+TIk3Mt1pW59rr+hwcR?=
 =?iso-8859-1?Q?th4r2b473GZEAd0E++OkIhFEmXAYysgqk08BlZVzd/2OB2kWXTPPtvYggg?=
 =?iso-8859-1?Q?wy0JRrN73zj9FGtyfn9Q3xe9n64WSlpPODtssPXA0KiLHMeDuaEHMRwT39?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?a5Mdoe7db2wdARtNSJKdKNToib3TZCsCPnllSM7mzj7btQdrnJxbbpr0+Q?=
 =?iso-8859-1?Q?mXSnN2py3z9/4hefR3qdymjR3OwmFGIkR6kzJUYVZw5293mopJ2NMxc7Jj?=
 =?iso-8859-1?Q?tllpodU74QIpo+5nJtIpt/lCC0ceBijQzx5zHUaxNoiFZDs7ho2fJLTZVu?=
 =?iso-8859-1?Q?9i5+EIhNAEiOowr6yK4cfp46u7L0hVV8HrzFM+eQjX3enq0mcxeJ9Q1kEd?=
 =?iso-8859-1?Q?fkmYsHHVx57iCQHeqtPLgjl8NBVhcMIxfrhG2+FyPj9LhIgXMFVei5yK7S?=
 =?iso-8859-1?Q?rLdfcpRgwQ+IRdogenzNqVVy2aINKocPga94ceFkHwHWW7+MvXplPiAJnc?=
 =?iso-8859-1?Q?SOyBWzVspD/wnaoxPxGLR16ZQrLYffRrfk/w9bMw8AAJB9NBRI5q4P/w1L?=
 =?iso-8859-1?Q?C1jBXXjV/0JbIXRNENXHuMrlHXDbnnyCAqbinZZZ8+fXD0mscCWpd3jbK0?=
 =?iso-8859-1?Q?9NVZ61u3lQ2ItJQyHaQLlxmHh793RvT0elXju/sYbepfjAW7hq69OST5TB?=
 =?iso-8859-1?Q?Mqa37Vbdl0YGeJBuhS12AO3Etbe0u74xlBcPtq/Z/dWIbXB0v+h85phkVI?=
 =?iso-8859-1?Q?H7GV1IMEqBgLcUq7lcIANJljXe+hyShzO4g+GY0u5LhOmGL/OdW5RNMwbE?=
 =?iso-8859-1?Q?b0UIIFvwuIKgIe06GLCGutY9z8OvJlsH9PJOxu5CHBwHYpGg6ZDMET1CeY?=
 =?iso-8859-1?Q?yqXPrj/KelO3aEhMIvgCuTDiGEylCaNj8MxI2qulEJOP/OaqGQtzJSJtwp?=
 =?iso-8859-1?Q?SXdMXWLG7Yadek1BIfD30+anUI+iNJzkc7BK+PS9FYvBQZUNIYceJQ8/EF?=
 =?iso-8859-1?Q?iqZoVB2Cbt2aJIvuUkOyd2NTsVV0M0Yytm1xua3tlBAOmXmXUnvASD1lQ5?=
 =?iso-8859-1?Q?yQ8vhjNZPd6/7/z/kcmxZP7XkKu9SX3KD07RbVyoAANaZMWLwlCXmvlZf+?=
 =?iso-8859-1?Q?g/JODwxheNUSSQTW7Bg7kTNcpTbZCyV0bHPs2kFdxfQ13BXjC24/HLl2Rm?=
 =?iso-8859-1?Q?Yb9StBzoRjYxZbTwcE0PRuBWPbsFkhhZJ+xdfXHrZECxf1ordLw6G6s7PM?=
 =?iso-8859-1?Q?r/nvJq/KXZWdsUo7No7O9OnDUGbfRxFho1aB7a2a4h/GkUO9F3BlrjmZLh?=
 =?iso-8859-1?Q?VO3HhRUBjRuIYqXb2XZFMoJ5tNBKAgLW5qsVdZTpxNaMddlI/zra0rXgWq?=
 =?iso-8859-1?Q?Qu4DYmdpmuyXkJ1UYDc1Dyvl4u/KOkfiuz0Irx3hjylL+GMsh7nVcCRLDH?=
 =?iso-8859-1?Q?KISZ4UymZ60QHuhH71c2I4lNRBjbRgqZdzbul7uBOUTEmhDBatY+gSymA4?=
 =?iso-8859-1?Q?3k0c4QHpm36eIOko3WbEWM6lHgJNPP2f3jjrozyTqZ/UjaXUIwg7pQLN6A?=
 =?iso-8859-1?Q?/U+0LjF0zsR8M1K2pnoVx6Ij9sK2OPSsHRzM/XDCciNH7TQyqWWrrsYiZy?=
 =?iso-8859-1?Q?Bb5NyUUTVIhgSbkXIINb+Zekgnt3dQLUrTaLSx6NFo7Abuy93vpdHOvToL?=
 =?iso-8859-1?Q?DTXlJGyiIUD21GH9EAF4KLdjYy5ZGcAp/YpkHpPqfiBB3PGEtfEOCMtcSD?=
 =?iso-8859-1?Q?hCKVfsUnPpJNPpb31QNxUVhdtucQ83FbzkcYzG0cxtfnYf5hNHWSzg6jyZ?=
 =?iso-8859-1?Q?+kyVPcqY7XGfEkD0NW+vQEI6Go9ZZwp8C6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a84950d3-b971-40f7-ec27-08ddcf2dbb5a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 05:55:48.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ST8sdTxOUZ/EL4zaJLEUC93WUZf8OMzprd65C3JQFpMp/TqHjoq8g2js2svAnBYZmXQgj2LBiuV66RSGSWU36w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6426
X-OriginatorOrg: intel.com

On Tue, Jul 29, 2025 at 10:27:34PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-07-29 at 12:33 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3e0d4edee849..c2ef03f39c32 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1937,10 +1937,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >  
> >  	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
> >  		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
> > -			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
> > -				gpa, vcpu->vcpu_id);
> > -			kvm_vm_dead(vcpu->kvm);
> > -			return -EIO;
> > +			kvm_prepare_memory_fault_exit(vcpu, gpa, 0, true, false, true);
> > +			return -EFAULT;
> >  		}
> >  		/*
> >  		 * Always treat SEPT violations as write faults.  Ignore the
> 
> The vm_dead was added because mirror EPT will KVM_BUG_ON() if there is an
> attempt to set the mirror EPT entry when it is already present. And the
> unaccepted memory access will trigger an EPT violation for a mirror PTE that is
> already set. I think this is a better solution irrespective of the vm_dead
> changes.
> 
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> But hmm, tangentially related, but Yan do we have a similar problem with
> KVM_PRE_FAULT_MEMORY after we started setting pre_fault_allowed during TD
> finalization?
Sean's commit 6385d01eec16 ("KVM: x86/mmu: Don't overwrite shadow-present MMU
SPTEs when prefaulting") should have prevented repeated invocation of
set_external_spte_present() with prefaulted entries.

