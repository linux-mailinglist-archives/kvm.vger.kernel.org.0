Return-Path: <kvm+bounces-70696-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIOrNmPAimkeNgAAu9opvQ
	(envelope-from <kvm+bounces-70696-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:21:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 409291170B6
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3AD4D30210E1
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 05:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D4724E4C4;
	Tue, 10 Feb 2026 05:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YYRCkeGD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABF41946BC;
	Tue, 10 Feb 2026 05:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770700874; cv=fail; b=By3O3lCGR+wIULrFISh03G6NU1zQQwIgzgbJ4O4l/vFswrl5971EctOn/14A1sdEoIkfdpy4gMN0cfuiJVs0vqnYmBQBZjoxN0vruRT3A4Upmjxss2hir6GfeoUCva130GGGsD7B3ca6uzn2bnX7UDUhp1lZDdvFU49Jjyj/L3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770700874; c=relaxed/simple;
	bh=b7cz8dDI+huTP3PblTutpNqVd6a+knGyc/CeHDS6ojw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HJh7+4GsZ+nYDHEEf6GbFv8Ad5wNn15TQR1u7e5P4o83Y9zG90wKWTxulwuLATQXXR9/UyKx0FeLDv3gcHTnAUZfuK3lxcE6a5tBymk2zUuwG8fqej9Pf2q1Q+GN/KDKHm6/7YW1NnvyiyMbiEEGlOgiqAAqRAYWZfoYNP3+B/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YYRCkeGD; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770700873; x=1802236873;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=b7cz8dDI+huTP3PblTutpNqVd6a+knGyc/CeHDS6ojw=;
  b=YYRCkeGDAyUvenBDLPIcl9QoK9YgblPWbMKpcnlSMJB4hoaxA/QvEaoC
   5EAadl5+wG/VeVABfxs+hEn/cR/Nqf9W+NNpfUpuxF4fBCSiPDuNSo/oc
   +ugkFQ9o3FZokpQwuL7EmIpLCEVlBLTMZqZpxB9AG1jppIFbLEyZ5JA95
   apH7APv8z4MVVxHQ8BBXb00IFAJ2kBFZ6X7fZllukDaaP0knl1NYsSs/v
   z8QsfCqm6gQkhOBpt3TalOMd053qOo5GVCf/pHZYZ0jO6RyvFOLk8gn9S
   jTMx1LKPQ4qVORf8vvSa2i7WBLIQGzIOSczj4EFddWqQXW+8gZyC0N+Kz
   A==;
X-CSE-ConnectionGUID: cIFFmI5WRX6/i3UJQzroKg==
X-CSE-MsgGUID: d72mNrnGRNC5HwKsy2PdJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82551199"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82551199"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 21:21:13 -0800
X-CSE-ConnectionGUID: DBfN/ShoTl6A2ld+pyYUhg==
X-CSE-MsgGUID: id2y8Y1KSsisE9kggwLJrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="242422230"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 21:21:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 21:21:12 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 21:21:12 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.14)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 21:21:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nbu/Hpvdz49ht4vcv9emYY2j/mDKFWOjwgGnVq3TGVGwSOhuaLUVO0nJJ9LYkaC69obcvztkWp1JhJbeCj3yWBC7JsPLCqRQ73Ra3lE/Yeux8yMDG212DsxYnQMRISOCWQ7+0DfP91SBRNfqHeeZ8wfJgkAI4c7mxy4R+q5FmtFAjT6fq6bqZRwnF5ENhuqAPkJ0zveKAvAJUN9Eo98adfVURoSIl43mziIb1pFv6Cj5i2xFEO6GkIpQgkHOq9lkKdD2hQEFERO5P7vOKv+8fadN0P+dzxRgW9Jj6F2ZgvpapqOrYfRyPSiYDxVE54WDm/FVlcUs4mFwpn1oZaepYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6A5+bY9YiRl5WoqbcZWt+EKqM5Lvu4Lx+OC4k4VZaA=;
 b=yAK5h2JbbVxVgCUrmS7eNMPXS6MIzdfcvxZZnsbq3H2wYjeFduN4ObdbnBuT8Th7iBi2DCVX1ogAtYbcKGVNX8ZAKUyIUqGJxz/HyWzd22exdE0ftTpd0CDyd668Chg9+zC6m5AWpGhnIofB+zmLvBex/u5E8kYlMjJpimtIi0F1rA02p/7MZ/qTYgRwgal8nwI/p5WcZapf9l7m/jmFOHuEnairS9ylezaD6f45XSf7EJNYB9son5L+o35ZmOe+IEewHMXkUcAv6qrDYwASQLoJPyaMMgSJ0M1gr/dXblHe5M8XMLXUuIcQv7VGDX7dPKw4joqt18F4bOHHzt+VtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
 by DS0PR11MB8050.namprd11.prod.outlook.com (2603:10b6:8:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.17; Tue, 10 Feb
 2026 05:21:04 +0000
Received: from CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394]) by CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394%5]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 05:21:04 +0000
Date: Tue, 10 Feb 2026 13:20:49 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, <kvm@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, Alexandru Elisei
	<alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, "Mingwei
 Zhang" <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Mark
 Rutland <mark.rutland@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
	"Ganapatrao Kulkarni" <gankulkarni@os.amperecomputing.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, Colton
 Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v6 08/19] KVM: arm64: Define access helpers for PMUSERENR
 and PMSELR
Message-ID: <aYrAMRRwGwCuRONi@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260209221414.2169465-9-coltonlewis@google.com>
X-ClientProxiedBy: SG2PR04CA0170.apcprd04.prod.outlook.com (2603:1096:4::32)
 To CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8468:EE_|DS0PR11MB8050:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf89c44-a3c6-498f-170f-08de68642ff8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qIPc2L+NJHWRfnfzSQtSTXo7O4LaI9T6KD5+ynmg59iSJqho6p/UWS+zWNoL?=
 =?us-ascii?Q?CLFw487eNZlAoroxnp3hx5Dn8K5qsATJ02EI09YYv1By8oeBxbW8HselsiIR?=
 =?us-ascii?Q?3iZVIsmn48uXVflxWR8LURyuu0SeQ0ZOIbUFWVMPqyaWPDRVmk79/jDVejKJ?=
 =?us-ascii?Q?zyxfDkMy1pqz3ZW4LxJI/Gv2f2aEa+Y//PBf61RrYXW6PLUDpjNoSX0mSdA0?=
 =?us-ascii?Q?1wbzTomMKQrN9M1AM0QWOPz/83todARfrtCqkMnU3786tdi6mOmwpZWbH6Ir?=
 =?us-ascii?Q?+uK5jgkwOu6F8BeZB1OvhhR9xT8QxLcG8wmk339Y62DRdEuuGPrucSgYfRAY?=
 =?us-ascii?Q?LEkg6FMTKeLALwDwDH0OIlGdb4kGt2kRnNSLJvF6oK1tq3AqEua8RRGDAZ4c?=
 =?us-ascii?Q?cIdgbxMOD8amXFzEJXDZyKUy+xgpm+wqSDNjJ8xbVLpTOA84J50R3P+ddWlX?=
 =?us-ascii?Q?4d88zXy1jDPgP+LyUlteYp6nNgf5GttxZalALitDp6lo0toSARwjUUs31vTv?=
 =?us-ascii?Q?rhh/dUVjcUjCHi81ffk3D0RBqS474xLKtQrZEAirGunMsBxgUiQzwtlCjvVX?=
 =?us-ascii?Q?RydDBC4zwvoyiXvIivM54Kg2vBEgQRwSpejyVl7kE5vErKAxmJAO/RoCYX/v?=
 =?us-ascii?Q?S/bxv81Pa3QEcWHJrdLQcopmylC+c5q/Tja79IwrBQDjK1EatVBjPEbSYNIP?=
 =?us-ascii?Q?o0fQAFgb1EO0R1SzYmiP5gZXIMgyQyETMyR31IBEgwJ1C8iBmsYzjwgo9oRI?=
 =?us-ascii?Q?0gnR7PYQdD3zqFFC0H91vTqvAV0lZz7edOmy3DLOHWnEAGzBKLdf0hQ+jLP2?=
 =?us-ascii?Q?KAJgaYmWpWf2g8C18hdiqN1FbnZs2VZATtzKlCVa5IOrVe2jiqnU2GGjDsyu?=
 =?us-ascii?Q?EnMF/KiJf+OsxEUOz6ToV110Ji41pmkmXr6XGehtidprwD0oxFYJ5u3Nxdq5?=
 =?us-ascii?Q?woTRpHUhkR7dXYz4m0X72nrmgQhsWGilf5Vtls2eTRdyy2Js48OcOYCgOzdd?=
 =?us-ascii?Q?wEypJmoLOAEWLo4cHOnwJRzpC0f98U6kTe/lSgsH95vqI8abycDlUtHit5gh?=
 =?us-ascii?Q?v1RFepONSD/vm8CMxkn9HDirIm54N1j9/ymic/WrJgiu8+tofN2/3842Fr9U?=
 =?us-ascii?Q?3KNHuWwQ3muaJhrDQs7n3Ps82zLMd5xiBub+6zdMErAxmuNYXRaBwZkJo0sy?=
 =?us-ascii?Q?fe4RuFQ9k346ELz4WVizo2kqVxBxkHLCEzXlNI8UxcynsE4NqItu6RjxSclU?=
 =?us-ascii?Q?umpPmwhLv5aB/MuADppd+iJvh5479avzkrJFzkYprUQOz97ABlkbWyar5LTt?=
 =?us-ascii?Q?ss0V0c6g5/7x0g6xQQpEdKODUakONze2rYFesx6Gb/A0T4x2Gf37AZK4LciF?=
 =?us-ascii?Q?x9HgkTm7bpkYfavn6oBxryJVXJYMXHQA/trXbx9PMdefY/NV+cHFK/YdvJyz?=
 =?us-ascii?Q?vYgMVnG8AkOjbCEAoGqei397KV7uwqU9pXDCs5opAo9g7wZK/JHB6igW98ue?=
 =?us-ascii?Q?BS25fObSpW60UhEuOD1bHSmiVd6r5OQjOqhoFzScSvvSTPIOqmggFM84qd6I?=
 =?us-ascii?Q?pI+L/Z+N8MHUUPhAhOfQfFR0EdJooYI+WoEluIej?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tLTWorCLxemqU3c54xTsiXxNsU13+cEGCyLQ9M8WfxsFuKjk7aFbzFUiJC51?=
 =?us-ascii?Q?RsIEF8PxMtiv+oamgtR1Qs5Xwq6c+/av5UZ5M8G40X0mA5BDK7w7aTkAWajA?=
 =?us-ascii?Q?p25jWcn0DVwiFzW18pnQInPBeqeWq56bo/ChZxbS5foBiBOJGpbuZmyNdtAQ?=
 =?us-ascii?Q?z2PEFt1dhPmywPl38j9T/bmq6H/SxvCSTYfVJHp8hTMUP4mkvm0R+voEej3m?=
 =?us-ascii?Q?ckPVOXEGqXcOfQKj7E0j+wyXP+3j0Wa5UfT3rnj/XycAT7REx0J82g9FS/UP?=
 =?us-ascii?Q?qD5zn0JVkiqNV+tf3EcH8+bz4PIHE4VTOJSoaKE51PvEl17gsd6gnZEjCG/0?=
 =?us-ascii?Q?xbBn/XQ5w7BlUg8zggnFcDweDnE7LjPYOZllNwajjZJQs/v/aRdKduF/Uvpq?=
 =?us-ascii?Q?N6csSoDP3WhnTg8r6Z7qRXaby4PgUUlBz0om1MeztDqiLMl9dzfNEJv0DFmB?=
 =?us-ascii?Q?y6CDqLH9hvIqin0dLoGuE3L5CCy9P5b6qXGLcvMDdWzRw/tKeiEP0fQcqQTg?=
 =?us-ascii?Q?em3f1Ngi61MrZg1U42qO4Kc1/2k1TA5K5265ClGPgTLPb4vDK1px+iyCdKVL?=
 =?us-ascii?Q?BGSFa7KIkeJqRAhtjj1xs8J8jyo4ntUsqkdn0oLL5QLBrRGOK2N/6a2/LzJ6?=
 =?us-ascii?Q?NlJHeYM6m1jrU4dqV8eYDocQ38ufFa2dso6JosisOODhdjh7cHWr+Y0UOdxl?=
 =?us-ascii?Q?no7JrzJ/jwLBbGIj2eDHLD1WsWZmB+8zoz9w78glL1zSF9rBWyzj/LJJkKc6?=
 =?us-ascii?Q?dIpolhRjFpmIjK283vIUMX/O3mM/1JbmCWQxXAXNg+UdknSYHhlc4S/ZHnR5?=
 =?us-ascii?Q?lr3LLoJGuDcuzJQjyrPNJ+LMrNoQLhysFi1+muDeXn7iCwmseWzgt/1KRa1k?=
 =?us-ascii?Q?i7ldP9kWkJRI1At1iQLYwlu1O/a7eyRqoS3WP+SC/T7QgVlDxo9oBzfG9Mi8?=
 =?us-ascii?Q?Qn/lMErAQktSuDO3xZGApXWkTx9OeCY6C/fFg6VA52W3SgFbfHz4jZS9VtEq?=
 =?us-ascii?Q?QZcnAnLjXgKXF9vP6L7ArCYu3bZk7KKTPLUV374m4s8+EKf8NuG+wssz4orA?=
 =?us-ascii?Q?zQkoB2Jvyz9OrBiuxJo3uRuz1nQb4V4kWKdi7M+nch243LgXraIjmHve0nNA?=
 =?us-ascii?Q?O01nozlTBuTw2JJVPWLbd3tKzoRWiTg/gML1pnm5UBEAREMrqg2IuJq74MNZ?=
 =?us-ascii?Q?ZQUiBUJyftDK9+IwxSXtscrqqTnPQ6d+Wi1D/Sm0cnHv/A6fYaY6cWJehq3B?=
 =?us-ascii?Q?LBn/nrFUlD/ihOgXZ6lQinytUEZjfUKm8p1McolSQRMRzdMuXbUuVpsJ26AG?=
 =?us-ascii?Q?KDqp4ybI/vzP+iVsRfmRbtvKHyNI1e35mUpilBtCtL1TG1Dg6RdhsvsVxKdX?=
 =?us-ascii?Q?qcm/xyEBe/1l7e2dvFb/OVoQdtCnqxI5XAFby+Fe5YDnpO+7SZJ7GE0gebel?=
 =?us-ascii?Q?lhI77r6QyRGrxP1BlPsFmtxiee3M+NT0M/AgqdO4TGuNmwbEm7l6Y6XSdbQq?=
 =?us-ascii?Q?Is/qB7p1DUirm0t6prztDBAl9XxU7gCPqrO0IxT8NDykPJXgx6kgLy9tFAC7?=
 =?us-ascii?Q?/jVuPm3WsYsKGvr3erC1J7vZ/5G23DS+h5miMx/sHGI+bv1jzURxPPgJi0G8?=
 =?us-ascii?Q?HwK6ttL0ztZYEQqpRHcSIY6FPaboppm+S71xrchFjyM0l2baDw/osURMpNEm?=
 =?us-ascii?Q?cKnQWunCSDOH+AJSy62YSDpBM2EirWV+64V/sIIx/BKaCjdcxk3VUefYK6yB?=
 =?us-ascii?Q?KgjT1RLtMw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf89c44-a3c6-498f-170f-08de68642ff8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8468.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 05:21:04.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVOuVaukUnlL751W6GEI8PXbc01kNbVkioqnmzaAowB2HVing93jTs1MRZQ9Cm1QdHhWBcUnmGvzGflDtQtmkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8050
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70696-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,01.org:url];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 409291170B6
X-Rspamd-Action: no action

Hi Colton,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20260210-064939
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/20260209221414.2169465-9-coltonlewis%40google.com
patch subject: [PATCH v6 08/19] KVM: arm64: Define access helpers for PMUSERENR and PMSELR
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260210/202602100555.etWxDEB0-lkp@intel.com/config)
compiler: aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602100555.etWxDEB0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202602100555.etWxDEB0-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from ./arch/arm64/include/asm/kvm_host.h:38,
                    from ./include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> ./include/kvm/arm_pmu.h:260:12: warning: 'kvm_vcpu_read_pmuserenr' defined but not used [-Wunused-function]
     260 | static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
         |            ^~~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_vcpu_read_pmuserenr +260 ./include/kvm/arm_pmu.h

2d3f843993bdd5 Colton Lewis 2026-02-09  259  
2d3f843993bdd5 Colton Lewis 2026-02-09 @260  static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
2d3f843993bdd5 Colton Lewis 2026-02-09  261  {
2d3f843993bdd5 Colton Lewis 2026-02-09  262  	return 0;
2d3f843993bdd5 Colton Lewis 2026-02-09  263  }
2d3f843993bdd5 Colton Lewis 2026-02-09  264  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


