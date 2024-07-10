Return-Path: <kvm+bounces-21298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A138192CEBD
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 12:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C351E1C22657
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C3418FA31;
	Wed, 10 Jul 2024 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Py2M2IgE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F41B86F3;
	Wed, 10 Jul 2024 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605701; cv=fail; b=GVTUV5ZjHcILaO8p43WLz61Ls+AFX4Un1yZX5srgXPadDBh+XFcpozJ6LaOlhpHk0iR/WcKbnsAoEwnCKhWwF98tMX2nSVNWcE4QNvT/NobMyoB0VMxWJu6ECWy6D4tSjJdBMhlUuUBvmmurs0mqkdemvOGkt0HlXGLQpWLbdLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605701; c=relaxed/simple;
	bh=GfS51FcI8h0+s9NqA+8HS624aDTxIKgyr7JjSAJNoqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sxEhCVAXyLxv0jP61BKihKjeEl5BpYnOPphlAC+BcjC7VQb5+qp9RBcEqN7dhfDoMW3BWRmUuskDwgB5J9AP1SLvOpCg7LTCfr/M92lHLVBJ1WTzPUae4v6O3trty1iuIuijIbMRHNuLW9j3YbJpKVE5lc6rd5e9rejvLa3ur8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Py2M2IgE; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720605700; x=1752141700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GfS51FcI8h0+s9NqA+8HS624aDTxIKgyr7JjSAJNoqc=;
  b=Py2M2IgEc9tTKJF0HYZfnKSsYNuoliEu7lzFxGtaQCvLPyAvjlfYXwL7
   eBvO5YIkZCiKf3vjHMF0Tu33FNoyMAiCyFiPbO1nHfPt048n98qj39Jxf
   s9QEfGkRHWO5hda3x9uim4iMDXpWjCwnL5kVe+eV35c4BBuELRShdYYt0
   kYQAOSucmALP+uZXg4Lh4QK14VT8gierjaNELqK7rh5IzhBV8FR0WLhEC
   zCiumndAJdYrd0I8U8VcenyBo2La3JPrXPHWUuEAo0vbAJnYrCXkpunTP
   qxR4dEqJXO5SrX3TCgQpZhtP+0F/HLC5wmAwpzqXphia7cYmZ7NaHefzU
   w==;
X-CSE-ConnectionGUID: BTLG3sN9Q/WYXRswT9Viqw==
X-CSE-MsgGUID: IZ2lR6BGRjusnR0Rb7juww==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="17544041"
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="17544041"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 03:01:39 -0700
X-CSE-ConnectionGUID: SxD9eWDaReuvUfZFLxryHg==
X-CSE-MsgGUID: 4LWijkQwSiiTqrsLPvBHWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="48233063"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jul 2024 03:01:39 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 10 Jul 2024 03:01:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 10 Jul 2024 03:01:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 10 Jul 2024 03:01:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0PuM754PcMy3Z+V8wkj/snxPbwCsQ8MGGjhram8KMND0Lv6hnvz+HY7WbvNuUZlkGY1NE1ZFBmZKTeNnP35HhgFrNOXTxYF1eZkq9hIm0hdmBG2Tg3UeW+axrVDX3h509HD63d6jGJ5OneIxHfb9SBHI+OJ+vwm/pi6ibDHN2D1HIH30i33qU9i0DJ0yVnyY06sgYuLWdH4hoQWsy4BQUNMMWAooCJ0tOEKdY7JjEXQTdZivnAocEkNNVyM5zw1lAANmrrmb9doj8ZoepaVbVXcfw9ziUBRKpaZLucTmjjlb4AE2k44xSv5/NIemkYjb6qTPO1YsfEhJlWDdq31ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfS51FcI8h0+s9NqA+8HS624aDTxIKgyr7JjSAJNoqc=;
 b=dum69tzsb7+j2f+oYHoBg88YI7XRfdovFJ2JUmsDrkw0NTWjqHAqw4OAvYJz9k3xt/q4oV74F25G9Dj1UAh5/7KJSwSwhAVduK9CAmQVmcG517iy1rH+o3ilXeebHCH4zxTxrtyGlNkskRNNAsoOVU1dt9UEjXjPoth8oNDFgtFtpm0XDzSX+aEquzRWC19uQSr4cnQDturYX4hrsbVJ7MAuyXssupiYi+izcz9Wo4OItRHP3WMMoSUz0nITSadgIli59egYNqaXzXe3BksgHX3ptjBKiHykvF1SvxA563cxLzALJJ1alhFMfxKYKbxVJ3BlweEpHoiALP+tNR0qsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5826.namprd11.prod.outlook.com (2603:10b6:806:235::18)
 by SA0PR11MB4590.namprd11.prod.outlook.com (2603:10b6:806:96::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 10:01:33 +0000
Received: from SA1PR11MB5826.namprd11.prod.outlook.com
 ([fe80::9b43:5dd0:ec48:73b5]) by SA1PR11MB5826.namprd11.prod.outlook.com
 ([fe80::9b43:5dd0:ec48:73b5%6]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 10:01:33 +0000
From: "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To: Sandipan Das <sandipan.das@amd.com>, "Zhang, Mingwei"
	<mizhang@google.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, "Liang, Kan"
	<kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>
CC: Jim Mattson <jmattson@google.com>, Ian Rogers <irogers@google.com>,
	"Eranian, Stephane" <eranian@google.com>, Namhyung Kim <namhyung@kernel.org>,
	"gce-passthrou-pmu-dev@google.com" <gce-passthrou-pmu-dev@google.com>, "Alt,
 Samantha" <samantha.alt@intel.com>, "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
	"Xu, Yanfei" <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, Like Xu
	<like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, Manali
 Shukla <manali.shukla@amd.com>
Subject: RE: [PATCH v2 36/54] KVM: x86/pmu: Switch PMI handler at KVM context
 switch boundary
Thread-Topic: [PATCH v2 36/54] KVM: x86/pmu: Switch PMI handler at KVM context
 switch boundary
Thread-Index: AQHan3awbfsLSEvXIkWDeEFfa7XFv7HwCdCAgAAU/AA=
Date: Wed, 10 Jul 2024 10:01:33 +0000
Message-ID: <SA1PR11MB58269828BC46772E32CD1C9BBBA42@SA1PR11MB5826.namprd11.prod.outlook.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-37-mizhang@google.com>
 <18ff4f7d-3258-4fbb-8033-8edbf3fed236@amd.com>
In-Reply-To: <18ff4f7d-3258-4fbb-8033-8edbf3fed236@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5826:EE_|SA0PR11MB4590:EE_
x-ms-office365-filtering-correlation-id: cab53ea0-d1ac-44fd-9b90-08dca0c74781
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZXl2aktCK3FUU0hNcDlmMEFoelZCNnB2bllKTzJabnQ0dlJnTUMyQUFIak1Z?=
 =?utf-8?B?OXBQTldxa1ZnQURrdzQ0VEVxalZKemxQdlVUNXZhc1N6ek9TK2tqM3czYlp2?=
 =?utf-8?B?dFpUTVhZMWp1bldGbnBIeEVoNVlSMWYvRm1iMUZKY2xERmJpVThwMzU2cmpS?=
 =?utf-8?B?Rm9nTk9qR0RzYm4rRmhnUGJJWnRGUmxjQmduZDZseE9TM3BUWklhcnZ1c0Zm?=
 =?utf-8?B?Zi9lWUV3L2V1b2hKWkhMZWl4WkpYa0dwR0szRENNcE50SXhlUVJxMHdnZzhh?=
 =?utf-8?B?NlI1bDdxT1BFSFU4NW5GUWZjSGJhZmttQkgxWTloRlpRZnpZTVgzN1VMZk1K?=
 =?utf-8?B?MWFMenpaMlpWY1kxR1VkYnpKcUxZTmVsbGIxR0wwOXY4L1ZzM3NsSVZmcXUx?=
 =?utf-8?B?M0llY3djRFNNbXMzZFZzbjc0dXlpOTBaS0FzWWZZMWxqRkFLbWFrZlI5TUZz?=
 =?utf-8?B?WWxaY09xQWdNbThwbnFrbTl1aCtrRHBMMXE4eC9meHJnTDNiNE5DR2dOMWNZ?=
 =?utf-8?B?TG9wLzFGZk1mSkU2anJCK2UwODdPUFZaOTNMNTZUU3VacDF6N2ZWanZ1MS9Z?=
 =?utf-8?B?UGtRb0cwYlAzei81N3dQQlpXYkZOZGQ5L0NmNHdGVzA1T3MxM1lJQXNIb3Fx?=
 =?utf-8?B?Tzl5RXpwWkY5NU1mdUdOZ252K3VkV1EzTzVURERMcjJleFYwdVRCY21Dc1Bt?=
 =?utf-8?B?YkRqTWNtUEtNK0hOZitmN3JpdVlRblJBYTM2VXRTbU5rWmJXalEzd29FL3ZO?=
 =?utf-8?B?MUwweUZzWEoyOWdaUEdoaXJ4ZW1za1dKVjhBb0NWNTRSaTlTRHJVUUpGdUMy?=
 =?utf-8?B?Z01ad3JDQWV0M3AxMFIvVVBCN2xtaDhlYjBubWV2a1BwTmFDWFYzWnVoWWVU?=
 =?utf-8?B?cTlNc3dCTElDai9rOUpkdmhMdXlLQkM3RUd4R3A2N3JNNUN5NXdDQmJLbUxM?=
 =?utf-8?B?T0p0SWFqR2tZVnNwVTB4VjRtc0p1UTFnNDFHcTdpZEtjbk5TQVg0NkRXMFBM?=
 =?utf-8?B?c2wyZzVZS2FIN0pnSDF3d3c2UnVVMzhsaEp3UmlVNU8yRWI3SVRrOW1nVjFZ?=
 =?utf-8?B?UGpBSkZWUHdQUzE2dnVqRyswWnp2bWNOMWhPM1RSNWtuRFM4OXA2cGZiaDFj?=
 =?utf-8?B?MHFuM212NlRpMHozclpZZlNkK2p6YjRZbmRLbkxBNnVHVTlrdjBhNWEyRjRE?=
 =?utf-8?B?ZTVSdksreW9yT3UrTTgrV2FrV0pZNStjSk5US3FYTTdNNU91dXRtc09GSFl1?=
 =?utf-8?B?MlNBSjFkOWE3Z3o0M2NqdUQrVjA5Kys4cE1xWE1SMUhLWFpHQVE5VXdjRDky?=
 =?utf-8?B?dzlaRU9rSEUyc25BZXRHU3V5VzBKMzN2Q1RibWlDaTVHQittVjRqYXlRVFBq?=
 =?utf-8?B?Q0pXNUoyQ1l2b2h1NEZQR0xaelBNT1NYRFo5TEV3RnVBeWdBL2l2NjZlWGZE?=
 =?utf-8?B?RkMwRGRqUTJoSnh2L0h1akxibzN2UE5sTFh0aVJwUEh3dHk3UTAxbXZSeHBT?=
 =?utf-8?B?UVBXakUxZ2RnazYvSEdYeDg4V0ZtQVdWYmFVN1U2UlYwZGQ3NmZSUGt3eGYv?=
 =?utf-8?B?WUQxZnFadnJoOUY3cXJ1ZStQTVA0MVYzVjl4NzZwRVY2bTNVenBpaTJyK0hV?=
 =?utf-8?B?dGloRW1PQU9FUTBqKzAxakJmVGZIbU9jV0I5dmN2cWgzWC9oMUlMckNjRWkv?=
 =?utf-8?B?OGRZbGcvU3JwOW5FZFpKak0yeHcwQkhMK0ZPbnpZUVRkdHB3endTVlQrVFBH?=
 =?utf-8?B?YXN6cjlZakgrTHJsajAwek9TRm1INmtMQ2Y3VTVacnNndTF2SGx3eUZRMElH?=
 =?utf-8?Q?K2jpAfH+6LUSfQZphyqa1H/BlAFsg3hL8zWuo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5826.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REZiU01UWlhUQk1hNkIyV2dBdzNIdEZ4SldRUmlldVlib1lzckt2TkN1TjEx?=
 =?utf-8?B?VlRaZ3hqbWJnUHNRKy9VTTlTQXpGMW9EMmtuSkVjbE1kenQ4VUNuSWRvVEln?=
 =?utf-8?B?VHJYdHliK3RwTlhlVkV3VlFmQmhMbmEyOTl6TmIveHBKNHgvYnBrY0hEcTcw?=
 =?utf-8?B?TGpOSUZZKzZicDVpVmxSRFE2R3RvNzBNWDdubHNFKzAwT2FLNWxTQ3ZMcTRF?=
 =?utf-8?B?K1h2WFlncHAvenBrZXBEUkcySE5zQVMxWGNlNy9hQ0htakhXTUNFbEx0R0xv?=
 =?utf-8?B?N2NXSEh2QkhQVlh1R0YrYnNBKytjWXVKUTNPMkxraTdueVBISGlEbHJ1ek1y?=
 =?utf-8?B?OHZRYVNEUGliUWEzYk1Hb3kvQ043ZERrVXU4MU9GZ1lka1A1V0s4Sll3LzdN?=
 =?utf-8?B?LzdrNDAzS28xdEg3ZllYN2theGdnemxHNFl5ZUJYVVBWRkpkTlphdlAraGow?=
 =?utf-8?B?Yk44VnI3cUFDRk82U3YrOFdrZytFeFFoNTJwajIxc04wam9vby9SZWJtL2Qr?=
 =?utf-8?B?eXRDNzFaRFkwakxtMDM0Z1BqVFhlNWZZZ2RLbFhnazFkOUFTeUZzMU9DazZ6?=
 =?utf-8?B?bWtlQWZ5d1dEb2VZVDAvMEZwcFY2Rm5idkE5QnNPdmpLbXc1cFlvcFRCdVhp?=
 =?utf-8?B?Rm9JTnVLK0ZrUmR5K3JmbDlSYWJ5RkdjS2FObXAwaERFMElDUjBEaUk0ZkhO?=
 =?utf-8?B?OFk0bERXejU2WXNWYkZhZUVReG0yem9MODd0ME1jNE5walpON2pNREg2RmVw?=
 =?utf-8?B?azlOSzRheVNLeWZkeU13MjFJTUJRc1gzcEp4WHFGZzFiQ0V5c0F3aGY0MGE4?=
 =?utf-8?B?bENNV0NFQTNIK01Ka1RPRUdIUkZtV2RIcEtyM1ZOUkVtdnVsWWNjL2tNMmRZ?=
 =?utf-8?B?L01tR24yemt4blVlbUNpaHNqZys5REVLcERIdllLbFlvT0hPcnpmYzJyaGxp?=
 =?utf-8?B?OEJmZ3VURjhLT2N0dTNrRzBkTVdDVnNpTFNxOWVMWEFHL2hIU3VPbHl2N3pu?=
 =?utf-8?B?cmVBSkpaRHpIdlhJTHErWnkybkhvWVU2SUg3T0tpQzhtK2crZ3A4dzlzN3ZT?=
 =?utf-8?B?aTJhSXdUQ2lJODBNdllIVzQyY2tSTFRIVkpTUjMwUDlRb2pVcjV1VFV1Y1dG?=
 =?utf-8?B?d3poMm9XdnlieUpSV085ZWFsYytTMk1LMmt6UUpNTXBpckZEbDZCc04yNEdR?=
 =?utf-8?B?Qmxrb2txcEJvc2JNc2xrTjRtMTVtV1FUZWFFZ3kvbjZCV1k4U21ESDIxWFp3?=
 =?utf-8?B?WFhLRktJN01nWFlhaFFSbjdTOUVsQXB5MlFzWnVhZ1JUZzBFeVJ5ZHZYOEJa?=
 =?utf-8?B?cGFvTk5CS00vc3I4eXNaeGxQSEpmQnJwb2trWEtjaEgvY0RKS1N2TDgvWHh6?=
 =?utf-8?B?bVJoVC9yaFFnWEpGSDlubEttRTJmVFUrZGltY1dIWjBDSnF0MFJEdlZFZGc5?=
 =?utf-8?B?U3pOdVRmdkxuRVFrVHFFYjgyL0k1Vk1qYjB0OE9DUjBBbGF0OE1aWFZkRHZa?=
 =?utf-8?B?VWpPSXJZUHlTSHdodHdNUzM1SUwvaHVKVG9haHhzQjJMUzFtVE5Zc05jdFh3?=
 =?utf-8?B?cTdOTWNIQVU3RksxbUI0WlpVaTVXeGY0ZG1nSjcrQzl2dmFmS093dmgrSjlm?=
 =?utf-8?B?WE5ZVlBzL2duWUxaVys0ems3TVNxYllpTGRQYjJaNGhpNTJOQU4zYk5yaFM0?=
 =?utf-8?B?M2x0bGwwSTRHdzcrNHRPNzZUU1YrMUVrdk5EVDdsV3JsRDFKVW43N2RaRGJp?=
 =?utf-8?B?K2t6b1l0RCt4bUdvRWx4eE52b1BMSG95cEhYTnM1djdDUkJ1Zk1KL05EN1ky?=
 =?utf-8?B?MElPUkNLTHo5RXV3UnYxdDhGWGUybHJIME9BOVlTN00zZHRZV01wZnRoclpt?=
 =?utf-8?B?S2Z6d3YvT3VOR0lFL3VXNUk2RjM5OFpkODZJVFpNSmFZd1lMMS9GTTdPbGNX?=
 =?utf-8?B?NDM1Vk01dE1xSVpXYy9ZdVJjbnBEL3BZN0xnZ3M5QURUOGhISXNUWnRMcXhq?=
 =?utf-8?B?MXlMWGY2dm03ZmN4Y3pSQWtyRDNvWTc5NFplYVpUVnZoY2hVYXFwaEdHSlZT?=
 =?utf-8?B?RFFZeCsxajl4VmNXeXIwQU1lMWNqb3JTV0s3ZWtmY29vK3UwTUpKT29hY3Uz?=
 =?utf-8?Q?Lm97yyXsB6VkautxOb4XyI8s5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5826.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab53ea0-d1ac-44fd-9b90-08dca0c74781
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2024 10:01:33.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iY6cc3BQ9aZfEHZTEH4pOe+ZNS5REReYnlcvWoHFfHeLKqs89qlNcWmtFI/y4n941upSv2p/xmbZOr8GNS1JLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4590
X-OriginatorOrg: intel.com

DQo+IE9uIDUvNi8yMDI0IDExOjAwIEFNLCBNaW5nd2VpIFpoYW5nIHdyb3RlOg0KPiA+IEZyb206
IFhpb25nIFpoYW5nIDx4aW9uZy55LnpoYW5nQGxpbnV4LmludGVsLmNvbT4NCj4gPg0KPiA+IFN3
aXRjaCBQTUkgaGFuZGxlciBhdCBLVk0gY29udGV4dCBzd2l0Y2ggYm91bmRhcnkgYmVjYXVzZSBL
Vk0gdXNlcyBhDQo+ID4gc2VwYXJhdGUgbWFza2FibGUgaW50ZXJydXB0IHZlY3RvciBvdGhlciB0
aGFuIHRoZSBOTUkgaGFuZGxlciBmb3IgdGhlDQo+ID4gaG9zdCBQTVUgdG8gcHJvY2VzcyBpdHMg
b3duIFBNSXMuICBTbyBpbnZva2UgdGhlIHBlcmYgQVBJIHRoYXQgYWxsb3dzDQo+ID4gcmVnaXN0
cmF0aW9uIG9mIHRoZSBQTUkgaGFuZGxlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpb25n
IFpoYW5nIDx4aW9uZy55LnpoYW5nQGxpbnV4LmludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBEYXBlbmcgTWkgPGRhcGVuZzEubWlAbGludXguaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBh
cmNoL3g4Ni9rdm0vcG11LmMgfCA0ICsrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9wbXUuYyBiL2FyY2gv
eDg2L2t2bS9wbXUuYyBpbmRleA0KPiA+IDJhZDcxMDIwYTJjMC4uYTEyMDEyYTAwYzExIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS9wbXUuYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS9w
bXUuYw0KPiA+IEBAIC0xMDk3LDYgKzEwOTcsOCBAQCB2b2lkIGt2bV9wbXVfc2F2ZV9wbXVfY29u
dGV4dChzdHJ1Y3Qga3ZtX3ZjcHUNCj4gKnZjcHUpDQo+ID4gIAkJaWYgKHBtYy0+Y291bnRlcikN
Cj4gPiAgCQkJd3Jtc3JsKHBtYy0+bXNyX2NvdW50ZXIsIDApOw0KPiA+ICAJfQ0KPiA+ICsNCj4g
PiArCXg4Nl9wZXJmX2d1ZXN0X2V4aXQoKTsNCj4gPiAgfQ0KPiA+DQo+ID4gIHZvaWQga3ZtX3Bt
dV9yZXN0b3JlX3BtdV9jb250ZXh0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkgQEAgLTExMDcsNg0K
PiA+ICsxMTA5LDggQEAgdm9pZCBrdm1fcG11X3Jlc3RvcmVfcG11X2NvbnRleHQoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1KQ0KPiA+DQo+ID4gIAlsb2NrZGVwX2Fzc2VydF9pcnFzX2Rpc2FibGVkKCk7
DQo+ID4NCj4gPiArCXg4Nl9wZXJmX2d1ZXN0X2VudGVyKGt2bV9sYXBpY19nZXRfcmVnKHZjcHUt
PmFyY2guYXBpYywNCj4gPiArQVBJQ19MVlRQQykpOw0KPiA+ICsNCj4gDQo+IFJlYWRpbmcgdGhl
IExWVFBDIGZvciBhIHZDUFUgdGhhdCBkb2VzIG5vdCBoYXZlIGEgc3RydWN0IGt2bV9sYXBpYyBh
bGxvY2F0ZWQNCj4gbGVhZHMgdG8gYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UuIEkgbm90aWNl
ZCB0aGlzIHdoaWxlIHRyeWluZyB0byBydW4gYQ0KPiBtaW5pbWFsaXN0aWMgZ3Vlc3QgbGlrZSBo
dHRwczovL2dpdGh1Yi5jb20vZHB3L2t2bS1oZWxsby13b3JsZA0KPiANCj4gRG9lcyB0aGlzIHJl
cXVpcmUgYSBrdm1fbGFwaWNfZW5hYmxlZCgpIG9yIHNpbWlsYXIgY2hlY2s/DQo+IA0KDQpJbnRl
bCBwcm9jZXNzb3IgaGFzIGxhcGNpX2luX2tlcm5lbCgpIGNoZWNraW5nIGluICJbUkZDIFBBVENI
IHYzIDE2LzU0XSBLVk06IHg4Ni9wbXU6IFBsdW1iIHRocm91Z2ggcGFzcy10aHJvdWdoIFBNVSB0
byB2Y3B1IGZvciBJbnRlbCBDUFVzIi4NCisJcG11LT5wYXNzdGhyb3VnaCA9IHZjcHUtPmt2bS0+
YXJjaC5lbmFibGVfcGFzc3Rocm91Z2hfcG11ICYmDQorCQkJICAgbGFwaWNfaW5fa2VybmVsKHZj
cHUpOw0KDQpBTUQgcHJvY2Vzc29yIHNlZW1zIG5lZWQgdGhpcyBjaGVja2luZyBhbHNvLiB3ZSBj
b3VsZCBtb3ZlIHRoaXMgY2hlY2tpbmcgaW50byBjb21tb24gcGxhY2UuDQoNClRoYW5rcw0KDQo+
ID4gIAlzdGF0aWNfY2FsbF9jb25kKGt2bV94ODZfcG11X3Jlc3RvcmVfcG11X2NvbnRleHQpKHZj
cHUpOw0KPiA+DQo+ID4gIAkvKg0KDQo=

