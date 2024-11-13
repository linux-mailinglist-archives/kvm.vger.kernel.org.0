Return-Path: <kvm+bounces-31722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F759C6DD3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAA171F23A59
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA5C1FF7AF;
	Wed, 13 Nov 2024 11:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fn7Iuo6R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC2D1FF606;
	Wed, 13 Nov 2024 11:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731497204; cv=fail; b=ZbGB0PQEgFZWaPAr+sr4SUyo3V/Knqss4ETzAUJ3Y+RT9Ayp9+k1et35o1aptlFmsqIojr+wsUQUv/3+OQfmYFvG6biaGdHl4WoBF/mx4Docp/TT76rCjOi6dZF+Rxe3IGFaSNwmwRu3ytWgfK9ncAcjSteZD5zrXPtqSy1dqko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731497204; c=relaxed/simple;
	bh=lOYHCmb6HM7QoC0BsTYd1R3j2Q2uZDtvP5BRZvO0ovA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q0Wl8LPLGgQU1AFaYrM6dvltcTXIoDyjtSDovThi225sZBaT8wckdARoWMEfDXD5mDIPG5CC9SFlz4aRUxJotUyMyB4ERzZP+N40DClWAmJdBWDMTFVLgph+SDGA9OW5ynJ4QEASeyPU50+ZPq/8W7e82DKVtctygnpKAFrmHjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fn7Iuo6R; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731497202; x=1763033202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=lOYHCmb6HM7QoC0BsTYd1R3j2Q2uZDtvP5BRZvO0ovA=;
  b=fn7Iuo6RQl/VUs8rDMgkLalz4OxLUdwAl2v2TsfGFCHYz+EWcZs7L7/O
   bbDryOQAiYfDFrec4GjC4wlkteGfDlEgsU2Oj/7YqUw+OKh9raVE143wD
   cmpKcCaj4zPug61Ri6dFHSEQFk+ol77A1Ap9YrH686vs/KGKj1JUQfjPE
   jNagCdmSMJfK18S2bmWiDgXbcYJOT9pVA6xXSiYuwZW225ZHMElq/LpYt
   CVq+gSPmBA055Dcr2jcYIaw6zsIdqh0MkVp/xCOeV/RuyhC4p6yVsvHQ5
   ebBQhDqZoa6bV6DCKfm/QquT91mN/qF1S+S23LB30N448ZkeFRW+1/bWa
   g==;
X-CSE-ConnectionGUID: zK4kGePHQOeG+2I7XfO1nQ==
X-CSE-MsgGUID: ag4jZNXzQxmhHkzt6ZjSbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31152931"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="py'?scan'208";a="31152931"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 03:26:42 -0800
X-CSE-ConnectionGUID: JW7OuQUhTZGzsI8D8tYVNw==
X-CSE-MsgGUID: iGIv9KXWRcGsIgeqztV7tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="py'?scan'208";a="88235032"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 03:26:42 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 03:26:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 03:26:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 03:26:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCxuiSMoEXvPUsVyOqYZddQnYdL6e5tqsEVBhNTKnIel9q2+820bPeLABuKTxJU4z5vP8uFSfzB+/h9A8N4UkVX6ydd6wKzAeE9LJECeTOfaWBpjtXUZWnrpyvdsH5i7Egu3akyxHFf4XOahedqoqiTEctRmqRaCGMNJRMPeu+noRjgTdKx623ZAm+3EuO+i7G/83pph/xtBGoOPB60LN2t9rSqCOCx7UhgChOE4x2Kt9SWjCZ2Y7r+VpyxvgMfc/YbwtgBK1TmM8K5o3W1CzSR6JDz1zJiu/eMsK4k2CtzF1wEA5T2VqxHg36rGrN6x1gC3YdhqRruVhvlvBs91XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4OxKaLuOwHAuQgClwh591ORmV11ZcuK29fVKIjWxLA=;
 b=B+PkIjRpLANqSHQckybe6QP5r+FvhrlW08x+mb4NtfjFGTyRAFCVSZesErQ1XNjK9TSadhQoNvSgSecU4+iVY/vZiUi66DwY/q128+sFCviiaA0wgk5Lw2FVwfhi/AxHA9tfd3YQLXqzyGeX6n12TdG9oiMU9lPZDgtQ2p3lEBskynNsTGFWfCDIts7l1olcKVXudFhz0/g7V0zK7IIS8K8njMdsWYqy2Yw5JNowVE/ZfJE+Wen33NYScZ7Y99Wx+xZGiB+g1VfaJahUWy/E7hr9pqRXo/6+utJ9R5vs5T8bcDgEBGp1xzdO0oox9LRVyvHx1I3IHNkuM1qyNtN8lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7578.namprd11.prod.outlook.com (2603:10b6:8:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Wed, 13 Nov
 2024 11:26:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 11:26:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Topic: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Index: AQHbNCWIZ2qemHMuw0G7kdYKKGDupbKyiauAgAAEUoCAAAMnAIAAB8qAgAJ8jAA=
Date: Wed, 13 Nov 2024 11:26:32 +0000
Message-ID: <d5aed06ae4b46df5db97fdbac9c01843920a2f96.camel@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
	 <0adb0785-286c-4702-8454-372d4bb3b862@intel.com>
	 <f5bc2da140f16da41af948adb50a369840ff890c.camel@intel.com>
	 <c4adf8da-fac0-4a1a-9b83-7a585fc63ca2@intel.com>
	 <1bd6a48d06e9bbf05ce5d6b138955b4306e2e383.camel@intel.com>
In-Reply-To: <1bd6a48d06e9bbf05ce5d6b138955b4306e2e383.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7578:EE_
x-ms-office365-filtering-correlation-id: 6b46ef26-d980-443e-7044-08dd03d606be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UVM5VzZ4TDVPWHd5bWNhbmE3dXNuRWw0dFBXb3RLcUFNeGthSzJqVVhHNXc4?=
 =?utf-8?B?bldDYzcxMllDMG04UW1YanJObXVUVEJMWXVsV1YrMWFPT0luS1dhMkx1aEY0?=
 =?utf-8?B?SGprVWhYaWxybUdLOGliMWJ5MmtWODZNekVLVFNnc0tncktCWWZmaUNHdUhE?=
 =?utf-8?B?dFlMVUo3alRTbDVWM2VCMnNRbnpRdjJaR0g5c1ZkUHl1Nm5VaGNaeE5YZGJt?=
 =?utf-8?B?N2ViOXllZHE2cXZMZzRuTWlkK242V3FGL1J5MzZXTWZ2MW5zSzNENmV3bUxI?=
 =?utf-8?B?dlBHZkFIOE9HcmlRSUxFOXdqZ1BtbEpBY25pNHJPOHdRSE03NUoyTlYvUGtO?=
 =?utf-8?B?TXVTR0FDZ1FpakFQNjJhOG5GTFkzeXoySzZnRm9ERXQzNmxLK2V3ZkhLcWVw?=
 =?utf-8?B?WSsxUmlaOGNTVFVUSE5wOGFOaU1oTzhSWk91S0lrS2FqczJRMjF1bDlIVlZx?=
 =?utf-8?B?cWJHdkZ0WDJJKzU0M09rZERoQ01pMEFpVlJzU1ZWbzlKYk5EWnVIb2RIM3Zp?=
 =?utf-8?B?OVlPM3hwd3RDNUdTNXlpSXlhSUQ4by9lK1N1dUNlajV0c2dtSDltWGNwMzFT?=
 =?utf-8?B?Y3BzUzErTm82UGxjNXFyZWpxQ3pQU3RDcHRlNVFEQVVyL1RGRGtvUkhGayto?=
 =?utf-8?B?dmpLVUFwTHB0cXg5RThtL3c3SUxTWU92VW1ydk01MjZYRC8vN3p3OTZHdGtx?=
 =?utf-8?B?SGVkd3hjTWxvK0pSVVRmVWkyN292WVZkcm01VFhnZEczdERZNmkrdHM2L0Jj?=
 =?utf-8?B?dHBDNnN1ZE9taU9nRFhZYWQ1ZGY0TXA1RjhLQ0lUa3k1ZUVxbWRDZVMxeUZm?=
 =?utf-8?B?TXduQkVMYW50VHF4dXN1dldWaEYvbDA0MDl5NlZoanBqQm45aG96MzZOU2tY?=
 =?utf-8?B?WDUrK3pZeUdRUk8yci8vMCtLck41dndCVXpnUlhWYVpXSmhKMkc5QkJveU02?=
 =?utf-8?B?TUxhWTc4Ky81ZG1Rc3V4Q3dPWUprN1hKNDgrSFlabGFZUFFOQTh6eS9sbnV0?=
 =?utf-8?B?ME8yUG1ZUzg4RCthNGlmaFBWRFM4UU1hb0c3bzRVbmp4K0RxNW9tTHFHeHFx?=
 =?utf-8?B?dk9EUWNxbXpvYm0wTVkybGNDb0JXNzJ4NktuNTFRTzZLd0lIWmxCa1E3blV6?=
 =?utf-8?B?N3UvWGJDTlp2NHhoRnFQY1kwdFlTN0U4K3RvSW9KWjA4WUZyM05hSXRwSmxx?=
 =?utf-8?B?MWpDcVUzKzZwTy9ydkhnbU05dmg4YlJWcm1ST01tZnJsSENxZlByNHdVTG45?=
 =?utf-8?B?c3hDSk1UNU9pL2hIMkljV3p4eVhaZk5ZUVFyZ2RjcUdrN2tZV1I3Sjc2bVB4?=
 =?utf-8?B?bGNjUHdNSHMwNUxjYVlMWnNxS2xWQUVQNkdtZDd5TGJ5M250c1lDWVdtRndG?=
 =?utf-8?B?KzVHaUlIcDg2Z0J4alEybTY3N0JPNFFnYzZmemJFTGEyN1VvUlpMZnNwSUhU?=
 =?utf-8?B?bTVJMWkxY2xnYXF5c25LTzJBT0F5c3I1TWw1TVRBN29tc0JKT01hWG5GVGtD?=
 =?utf-8?B?aXlZOXBycVY0YUlRb3RtdU83NnVXeDZHK2xoWTFnWUZxSzRFcEo3OTlHcHgx?=
 =?utf-8?B?ZkVLakpOUVZpYWFHRWlldjlpL3VtSFY0a2d0Z1BOZWxxSUYrSXgvM3R6OXMw?=
 =?utf-8?B?VXk1K1NTMTdDdzF5bFo4TjdscUhoTytOQlNWbFN0MVV3KytmR1UvQkgwK2p0?=
 =?utf-8?B?OEJMcG92ZFhuR1k0dTNVTFpCbWtJdHBxeTVNREJnY0Eyd1NLdDNkNzlhUmVo?=
 =?utf-8?B?NlZzb2o4dUR4eThzUTRuV2NiOWVyNTJqcUJxUWQ5NzBISWdCVUdKL2hjcHJD?=
 =?utf-8?B?Z3M1L3NQTHFRQ1h3WlhyaWY0ajRSdlVaTDhCRzJwb3hxOTEzajBJNytsZVd4?=
 =?utf-8?Q?meVsgDRVrqgHW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXBodnlSU293NVBSSEJXalJsR0dGdUIySllONXNOV0QvZVdWNEVWakwxRTVE?=
 =?utf-8?B?cXVMVHNnMnpmVDRFU0ZFK04zTXozb0tRbUNaRkMzVG5qWlp0RjVaWTBSMGJo?=
 =?utf-8?B?bDR0TENaN2lOU2l6RDVTTzNsaDJXblYvSzhwRjBWeUlaY1JtcU1OK2hJK0dU?=
 =?utf-8?B?ZnZWM3NzNWdZSTUycU9idjErWHFNSlVsT3R4clpUakRFcjBtU0dxOVZISkQ0?=
 =?utf-8?B?MUQxYzAxRDZHNGZFNjdUdTA5N0gxdGRhYkY3YlpRNm85QmZEeUFVZElrL05N?=
 =?utf-8?B?RWZuRlpLQXRSeElCckdvalA5eHlOZlBodGRYQmJtendkemZlcnJ3MlBlWitR?=
 =?utf-8?B?YnhsMDNTT0JtMnBpNFJ5eFZSbHhkOWNuWnp6R2IyaDhraU55Z1pTWmlzdGgz?=
 =?utf-8?B?ME9ua3lxNTBtUUtUZjFGdjVYN2pFbTdzT2FSQkdiTWtjRlUraFJDbGtERERI?=
 =?utf-8?B?QlBFczdMeE9CM2tjb0JRUmVSV0Z2MU8wcmUybFkwZUpaK2xsdjNSdWp5bHdo?=
 =?utf-8?B?Zi9OZzJYTTJhdk9mTVdJeTZJNEpyTGExT29EZGx4SG1DTFM1MURQYVloSm02?=
 =?utf-8?B?NDhmK0lxL1JNLytobVZiQVVCZklWT1hGMjhhTDZNUWdLdDcvdWhpU1UwazVL?=
 =?utf-8?B?SEd5K2kwYjJHdWIyUDQyVU8rVHcxVVQ1bUtPbU5hbnJFVC9LMDNtSmtSRm1y?=
 =?utf-8?B?LzdNeUZhMWU3WkVDVHNMSFE3aHFnWjhtYTZXaE5ZWGtGUGkrL0JLTE5LT2ZS?=
 =?utf-8?B?dzIvTERiWmxaenRrUEtrdFd0ZXNvb2daSTUvZWtteGU0RjB1ZDNkMFF5RC9E?=
 =?utf-8?B?Y1Izd3phT3dxSXFFZEhWWFNjUTBESmM0TkY1dVNRUG9DYitBM2FXajNmZnBy?=
 =?utf-8?B?N1R1aUo0UklCNktjeXBiWVNjamQ5eXhiZlJXc2RGSFlTNngxanVNdVM4eS9D?=
 =?utf-8?B?MDl1eDZyNlhOdDd2YUI5U1lCdmRnWHhYMFR0dVpwcXVVMmRZWGZySXVXejFu?=
 =?utf-8?B?MmRkUVFlTjZrMHJ6UlAxeFpuMm45ZGhVNjdEVzR3bVFsSFBHK1o1NGQ2cnl2?=
 =?utf-8?B?YzhXaUVUS21vc2hMV0M4U0x3S2RuZFJMa1AvbTlJZkZ1b242bzRUTnBvMk9v?=
 =?utf-8?B?dVkvQ2tHOC9XRStIMkVBUENBeklzT3pXWW81bTdRZVBBc21UMmM5RVVzWC8y?=
 =?utf-8?B?NDBGUU1QQnVhMWc2amhINGJvVVg4TXZIMGZ4SmROdnRZSk0vR0Z1UHdZWFNK?=
 =?utf-8?B?SlBBM1RHNXBmcVRzQ21DR20xbEJidFZmUzBLMlF5NjFHUDN1VXp0VGtOMmVF?=
 =?utf-8?B?MlNITWRxM045U0NYRkNDRkxoUW9ncnZWanZLek5wVkcvRCtRdld4cFN6b3VI?=
 =?utf-8?B?RDg3cjM1NHlFNllyRTY1SDZmd3ExNnNzSlpTWXA3eE1hZ0xtUHJIRldUaEdp?=
 =?utf-8?B?T0lDQUtOQy9MV01pZUhmbUN5aitPV3NRNlR3dVMrMVJDdlBDRHZBYUd0cEE0?=
 =?utf-8?B?WEtXWFI3bDNGY1FFNDFvdHJjUTdEdlQ0cWZsM3QxM1ByTEZwQit6Nk8vbHZ6?=
 =?utf-8?B?dWZFRHREKzhBUXFtaCsremUvRmcyMjl4ViszMDl4d3JyejZWd2hQMHN3MmNM?=
 =?utf-8?B?c21LbHhBVlA5TWE5K0Q2RHk5YnpaSitnbEhNRGFQeHVpU0Rucm9XMDY5N0JM?=
 =?utf-8?B?QlF6UmRxTnJsYjNSVzFubSsrc1djNzc2a2lYTkQxS1lhNVJoNUpzVjNoZUlO?=
 =?utf-8?B?cURDNVZ3SDM1ZWZQaGk5a01laGc1amszZGxKbFBTQXQ2TVY3UUFGejNZankw?=
 =?utf-8?B?N2p2ckdRSlVqK2FmL3R4Z3dldWdmbkVJQWs3bnh6TzNNcTJlTFdkR2hXRzl2?=
 =?utf-8?B?NFZ0OEdQRFJnZDlxSXRHR2lGWTN4dmZRbWJKM0NCcFlyRm9SUVRFVmoxVlBh?=
 =?utf-8?B?OHFncVlRMEh3aWd3b1FQWjUyek8rNUlGdzM4QXp0K0twNzVVcGM5T2xrQ2du?=
 =?utf-8?B?aUdhV0NEVXpHd3V0U1VGQXl3Q0Z2V3FTWW9aNmp2ZEVpNzl2OXVRajJSdFQ3?=
 =?utf-8?B?b3ZUbm1NUWtTblVzakpGUjd1YkNNb0srcHZiUmVXek5HREN3d3ovcGl5SHJz?=
 =?utf-8?Q?EfncbtP8B5alODHkEV/XSEEVX?=
Content-Type: multipart/mixed;
	boundary="_002_d5aed06ae4b46df5db97fdbac9c01843920a2f96camelintelcom_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b46ef26-d980-443e-7044-08dd03d606be
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 11:26:32.7360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mVEbs8vx90EifwstevllA3Lsk4J76ryotiPb2NIQzJ9sdA2kXYnXidu+PnfkeM1Ig2vkZDpGf7boUH/afMgjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7578
X-OriginatorOrg: intel.com

--_002_d5aed06ae4b46df5db97fdbac9c01843920a2f96camelintelcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <63024D8C4A45C84EBA3CC292374344B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gTW9uLCAyMDI0LTExLTExIGF0IDIxOjI4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjQtMTEtMTEgYXQgMTM6MDAgLTA4MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToNCj4g
PiBPbiAxMS8xMS8yNCAxMjo0OSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IEl0IGFsc28gaGFz
IGEgcGF0Y2ggdG8gZmFpbCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gd2hlbiBOT19NT0RfQkJQIGZl
YXR1cmUgaXMgbm90DQo+ID4gPiBzdXBwb3J0Lg0KPiA+ID4gDQo+ID4gPiBKdXN0IHdhbnQgdG8g
Y29uZmlybSwgZG8geW91IHdhbnQgdG8gcmVtb3ZlIHRoZSBjb2RlIHRvOg0KPiA+ID4gDQo+ID4g
PiAgLSBwcmludCBDTVJzOw0KPiA+ID4gIC0gcHJpbnQgVERYIG1vZHVsZSB2ZXJzb2luOw0KPiA+
IA0KPiA+IFdoYXQgaXMgeW91ciBnb2FsPyAgV2hhdCBpcyB0aGUgYmFyZSBtaW5pbXVtIGFtb3Vu
dCBvZiBjb2RlIHRvIGdldCB0aGVyZT8NCj4gDQo+IFRoZSBnb2FsIGlzIHRvIGdldCBldmVyeXRo
aW5nIHRoYXQgS1ZNIFREWCBuZWVkcyBtZXJnZWQsIHBsdXMgdGhlIGJ1ZyBmaXguDQo+IA0KPiBL
Vk0gVERYIG5lZWRzIHRoZSBuZXcgbWV0YWRhdGEgaW5mcmFzdHJ1Y3R1cmUgYW5kIHRoZSBOT19N
T0RfQlJQIHBhdGNoLCBzbyB5ZWFoDQo+IG9ubHkgcHJpbnRpbmcgQ01ScyBhbmQgVERYIG1vZHVs
ZSB2ZXJzaW9uIGFyZSBub3QgbmVlZGVkLg0KPiANCj4gSSdsbCByZW1vdmUgdGhlbSBpbiB0aGUg
bmV4dCB2ZXJzaW9uLg0KDQpJIHJlbW92ZWQgdGhlICJ2ZXJzaW9uIiBwYXJ0IGluIHRoZSAndGR4
X2dsb2JhbF9tZXRhZGF0YS5weScgc2NyaXB0IGluIG9yZGVyIHRvDQpyZW1vdmUgdGhlIGNvZGUg
d2hpY2ggcmVhZHMgVERYIG1vZHVsZSB2ZXJzaW9uIGZyb20gdGhlIGF1dG8tZ2VuZXJhdGVkIGNv
ZGUuIA0KRm9yIHRoZSBzYWtlIG9mIGhhdmluZyBhIGxvcmUgbGluayBvZiB0aGUgc2NyaXB0IHRo
YXQgSSB1c2VkIGluIHRoZSBuZXcgdmVyc2lvbiwNCkkgYXR0YWNoZWQgdGhlIHVwZGF0ZWQgc2Ny
aXB0IGhlcmUuICBJdCBqdXN0IGdvdCAidmVyc2lvbiIgcGFydCByZW1vdmVkIHRodXMgaXMNCm5v
dCBpbnRlcmVzdGluZyB0byByZWFkLg0KDQpBbmQgU29ycnkgSSBkaWRuJ3QgcHJvdmlkZSBlbm91
Z2ggaW5mbyBhYm91dCB0aGUgImdvYWwiIGluIG15IHByZXZpb3VzIHJlcGx5Og0KDQpUaGUgZ29h
bCBvZiB0aGlzIHNlcmllcyBpcyB0byBwcm92aWRlIGEgbmV3IFREWCBnbG9iYWwgbWV0YWRhdGEg
aW5mcmFzdHJ1Y3R1cmUNCnRvOg0KDQoxKSBhZGRyZXNzIHR3byBpc3N1ZXMgaW4gdGhlIGN1cnJl
bnQgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBjb2RlLCBhbmQNCjIpIGhhdmUgYW4gZXh0ZW5k
YWJsZSBpbmZyYXN0cnVjdHVyZSB3aGljaCBpcyBzdXBlciBlYXN5IHRvIHJlYWQgbW9yZSBtZXRh
ZGF0YQ0KYW5kIHNoYXJlIHdpdGggS1ZNIGZvciBLVk0gVERYIHN1cHBvcnQgKGFuZCBvdGhlciBr
ZXJuZWwgY29tcG9uZW50cyBmb3IgVERYDQpDb25uZWN0IGluIHRoZSBmdXR1cmUpLg0KDQpBbmQg
dGhlIHJlYXNvbiB0aGF0IHdlIG5lZWQgYSBuZXcgZ2xvYmFsIG1ldGFkYXRhIGluZnJhc3RydWN0
dXJlIGlzIHRoZSBjdXJyZW50DQpvbmUgY2FuIG9ubHkgcmVhZCBURE1SIHJlbGF0ZWQgbWV0YWRh
dGEgZmllbGRzIGFuZCBpdCBpcyBub3QgZXh0ZW5kYWJsZSB0byByZWFkDQptb3JlIG1ldGFkYXRh
IGZpZWxkcywgd2hpY2ggaXMgcmVxdWlyZWQgdG8gYWRkcmVzcyBib3RoIDEpIGFuZCAyKSBhYm92
ZS4NCg0KU3BlY2lmaWNhbGx5LCBiZWxvdyB0d28gaXNzdWVzIGluIHRoZSBjdXJyZW50IG1vZHVs
ZSBpbml0aWFsaXphdGlvbiBjb2RlIG5lZWQgdG8NCmJlIGFkZHJlc3NlZDoNCg0KMSkgTW9kdWxl
IGluaXRpYWxpemF0aW9uIG1heSBmYWlsIG9uIHNvbWUgbGFyZ2Ugc3lzdGVtcyAoZS5nLiwgd2l0
aCA0IG9yIG1vcmUNCnNvY2tldHMpLg0KMikgU29tZSBvbGQgbW9kdWxlcyBjYW4gY2xvYmJlciBo
b3N0J3MgUkJQIHdoZW4gZXhpc3RpbmcgZnJvbSB0aGUgVERYIGd1ZXN0LCBhbmQNCmN1cnJlbnRs
eSB0aGV5IGNhbiBiZSBpbml0aWFsaXplZCBzdWNjZXNzZnVsbHkuICBXZSBkb24ndCB3YW50IHRv
IHVzZSBzdWNoDQptb2R1bGVzIHRodXMgd2Ugc2hvdWxkIGp1c3QgZmFpbCB0byBpbml0aWFsaXpl
IHRoZW0gdG8gYXZvaWQgbWVtb3J5L2NwdSBjeWNsZQ0KY29zdCBvZiBpbml0aWFsaXppbmcgVERY
IG1vZHVsZS4NCg0KVGhlIG1pbmltYWwgY29kZSB0byBhY2hpZXZlIHRoaXMgZ29hbCBpcyB0byBy
ZW1vdmUgdGhlIGNvZGUgd2hpY2ggcHJpbnRzIFREWA0KbW9kdWxlIHZlcnNpb24gYW5kIENNUiBp
bmZvIGluIHRoaXMgc2VyaWVzLiAgQWZ0ZXIgcmVtb3ZpbmcgdGhlbSwgdGhlIGZpc3QgNg0KcGF0
Y2hlcyBpbiB0aGlzIHNlcmllcyBpbnRyb2R1Y2UgdGhlIG5ldyBtZXRhZGF0YSBpbmZyYXN0cnVj
dHVyZSwgYW5kIHRoZSByZXN0DQpwYXRjaGVzIGFkZHJlc3MgdGhlIHR3byBhYm92ZSBpc3N1ZXMu
DQo=

--_002_d5aed06ae4b46df5db97fdbac9c01843920a2f96camelintelcom_
Content-Type: text/x-python3; name="tdx_global_metadata.py"
Content-Description: tdx_global_metadata.py
Content-Disposition: attachment; filename="tdx_global_metadata.py"; size=6151;
	creation-date="Wed, 13 Nov 2024 11:26:32 GMT";
	modification-date="Wed, 13 Nov 2024 11:26:32 GMT"
Content-ID: <19D5EDC7A082E84C808F8BBAF6C27FCE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

IyEgL3Vzci9iaW4vZW52IHB5dGhvbjMKaW1wb3J0IGpzb24KaW1wb3J0IHN5cwoKIyBOb3RlOiB0
aGlzIHNjcmlwdCBkb2VzIG5vdCBydW4gYXMgcGFydCBvZiB0aGUgYnVpbGQgcHJvY2Vzcy4KIyBJ
dCBpcyB1c2VkIHRvIGdlbmVyYXRlIHN0cnVjdHMgZnJvbSB0aGUgVERYIGdsb2JhbF9tZXRhZGF0
YS5qc29uCiMgZmlsZSwgYW5kIGZ1bmN0aW9ucyB0byBmaWxsIGluIHNhaWQgc3RydWN0cy4gIFJl
cnVuIGl0IGlmCiMgeW91IG5lZWQgbW9yZSBmaWVsZHMuCgpURFhfU1RSVUNUUyA9IHsKICAgICJm
ZWF0dXJlcyI6IFsKICAgICAgICAiVERYX0ZFQVRVUkVTMCIKICAgIF0sCiAgICAidGRtciI6IFsK
ICAgICAgICAiTUFYX1RETVJTIiwKICAgICAgICAiTUFYX1JFU0VSVkVEX1BFUl9URE1SIiwKICAg
ICAgICAiUEFNVF80S19FTlRSWV9TSVpFIiwKICAgICAgICAiUEFNVF8yTV9FTlRSWV9TSVpFIiwK
ICAgICAgICAiUEFNVF8xR19FTlRSWV9TSVpFIiwKICAgIF0sCiAgICAiY21yIjogWwogICAgICAg
ICJOVU1fQ01SUyIsICJDTVJfQkFTRSIsICJDTVJfU0laRSIKICAgIF0sCn0KClNUUlVDVF9QUkVG
SVggPSAidGR4X3N5c19pbmZvIgpGVU5DX1BSRUZJWCA9ICJnZXRfdGR4X3N5c19pbmZvIgpTVFJW
QVJfUFJFRklYID0gInN5c2luZm8iCgpkZWYgcHJpbnRfY2xhc3Nfc3RydWN0X2ZpZWxkKGZpZWxk
X25hbWUsIGVsZW1lbnRfYnl0ZXMsIG51bV9maWVsZHMsIG51bV9lbGVtZW50cywgZmlsZSk6CiAg
ICBlbGVtZW50X3R5cGUgPSAidSVzIiAlIChlbGVtZW50X2J5dGVzICogOCkKICAgIGVsZW1lbnRf
YXJyYXkgPSAiIgogICAgaWYgbnVtX2ZpZWxkcyA+IDE6CiAgICAgICAgZWxlbWVudF9hcnJheSAr
PSAiWyVkXSIgJSAobnVtX2ZpZWxkcykKICAgIGlmIG51bV9lbGVtZW50cyA+IDE6CiAgICAgICAg
ZWxlbWVudF9hcnJheSArPSAiWyVkXSIgJSAobnVtX2VsZW1lbnRzKQogICAgcHJpbnQoIlx0JXMg
JXMlczsiICUgKGVsZW1lbnRfdHlwZSwgZmllbGRfbmFtZSwgZWxlbWVudF9hcnJheSksIGZpbGU9
ZmlsZSkKCmRlZiBwcmludF9jbGFzc19zdHJ1Y3QoY2xhc3NfbmFtZSwgZmllbGRzLCBmaWxlKToK
ICAgIHN0cnVjdF9uYW1lID0gIiVzXyVzIiAlIChTVFJVQ1RfUFJFRklYLCBjbGFzc19uYW1lKQog
ICAgcHJpbnQoInN0cnVjdCAlcyB7IiAlIChzdHJ1Y3RfbmFtZSksIGZpbGU9ZmlsZSkKICAgIGZv
ciBmIGluIGZpZWxkczoKICAgICAgICBwcmludF9jbGFzc19zdHJ1Y3RfZmllbGQoCiAgICAgICAg
ICAgIGZbIkZpZWxkIE5hbWUiXS5sb3dlcigpLAogICAgICAgICAgICBpbnQoZlsiRWxlbWVudCBT
aXplIChCeXRlcykiXSksCiAgICAgICAgICAgIGludChmWyJOdW0gRmllbGRzIl0pLAogICAgICAg
ICAgICBpbnQoZlsiTnVtIEVsZW1lbnRzIl0pLAogICAgICAgICAgICBmaWxlPWZpbGUpCiAgICBw
cmludCgifTsiLCBmaWxlPWZpbGUpCgpkZWYgcHJpbnRfcmVhZF9maWVsZChmaWVsZF9pZCwgc3Ry
dWN0X3Zhciwgc3RydWN0X21lbWJlciwgaW5kZW50LCBmaWxlKToKICAgIHByaW50KAogICAgICAg
ICIlc2lmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoJXMsICZ2YWwp
KSlcbiVzXHQlcy0+JXMgPSB2YWw7IgogICAgICAgICUgKGluZGVudCwgZmllbGRfaWQsIGluZGVu
dCwgc3RydWN0X3Zhciwgc3RydWN0X21lbWJlciksCiAgICAgICAgZmlsZT1maWxlLAogICAgKQoK
ZGVmIHByaW50X2NsYXNzX2Z1bmN0aW9uKGNsYXNzX25hbWUsIGZpZWxkcywgZmlsZSk6CiAgICBm
dW5jX25hbWUgPSAiJXNfJXMiICUgKEZVTkNfUFJFRklYLCBjbGFzc19uYW1lKQogICAgc3RydWN0
X25hbWUgPSAiJXNfJXMiICUgKFNUUlVDVF9QUkVGSVgsIGNsYXNzX25hbWUpCiAgICBzdHJ1Y3Rf
dmFyID0gIiVzXyVzIiAlIChTVFJWQVJfUFJFRklYLCBjbGFzc19uYW1lKQoKICAgIHByaW50KCJz
dGF0aWMgaW50ICVzKHN0cnVjdCAlcyAqJXMpIiAlIChmdW5jX25hbWUsIHN0cnVjdF9uYW1lLCBz
dHJ1Y3RfdmFyKSwgZmlsZT1maWxlKQogICAgcHJpbnQoInsiLCBmaWxlPWZpbGUpCiAgICBwcmlu
dCgiXHRpbnQgcmV0ID0gMDsiLCBmaWxlPWZpbGUpCiAgICBwcmludCgiXHR1NjQgdmFsOyIsIGZp
bGU9ZmlsZSkKCiAgICBoYXNfaSA9IDAKICAgIGhhc19qID0gMAogICAgZm9yIGYgaW4gZmllbGRz
OgogICAgICAgIG51bV9maWVsZHMgPSBpbnQoZlsiTnVtIEZpZWxkcyJdKQogICAgICAgIG51bV9l
bGVtZW50cyA9IGludChmWyJOdW0gRWxlbWVudHMiXSkKICAgICAgICBpZiBudW1fZmllbGRzID4g
MToKICAgICAgICAgICAgaGFzX2kgPSAxCiAgICAgICAgaWYgbnVtX2VsZW1lbnRzID4gMToKICAg
ICAgICAgICAgaGFzX2ogPSAxCgogICAgaWYgaGFzX2kgPT0gMSBhbmQgaGFzX2ogPT0gMToKICAg
ICAgICBwcmludCgiXHRpbnQgaSwgajsiLCBmaWxlPWZpbGUpCiAgICBlbGlmIGhhc19pID09IDE6
CiAgICAgICAgcHJpbnQoIlx0aW50IGk7IiwgZmlsZT1maWxlKQoKICAgIHByaW50KGZpbGU9Zmls
ZSkKICAgIGZvciBmIGluIGZpZWxkczoKICAgICAgICBmbmFtZSA9IGZbIkZpZWxkIE5hbWUiXQog
ICAgICAgIGZpZWxkX2lkID0gZlsiQmFzZSBGSUVMRF9JRCAoSGV4KSJdCiAgICAgICAgbnVtX2Zp
ZWxkcyA9IGludChmWyJOdW0gRmllbGRzIl0pCiAgICAgICAgbnVtX2VsZW1lbnRzID0gaW50KGZb
Ik51bSBFbGVtZW50cyJdKQogICAgICAgIHN0cnVjdF9tZW1iZXIgPSBmbmFtZS5sb3dlcigpCiAg
ICAgICAgaW5kZW50ID0gIlx0IgogICAgICAgIGlmIG51bV9maWVsZHMgPiAxOgogICAgICAgICAg
ICBpZiBmbmFtZSA9PSAiQ01SX0JBU0UiIG9yIGZuYW1lID09ICJDTVJfU0laRSI6CiAgICAgICAg
ICAgICAgICBsaW1pdCA9ICIlc18lcy0+bnVtX2NtcnMiICUoU1RSVkFSX1BSRUZJWCwgImNtciIp
CiAgICAgICAgICAgIGVsaWYgZm5hbWUgPT0gIkNQVUlEX0NPTkZJR19MRUFWRVMiIG9yIGZuYW1l
ID09ICJDUFVJRF9DT05GSUdfVkFMVUVTIjoKICAgICAgICAgICAgICAgIGxpbWl0ID0gIiVzXyVz
LT5udW1fY3B1aWRfY29uZmlnIiAlKFNUUlZBUl9QUkVGSVgsICJ0ZF9jb25mIikKICAgICAgICAg
ICAgZWxzZToKICAgICAgICAgICAgICAgIGxpbWl0ID0gIiVkIiAlKG51bV9maWVsZHMpCiAgICAg
ICAgICAgIHByaW50KCIlc2ZvciAoaSA9IDA7IGkgPCAlczsgaSsrKSIgJSAoaW5kZW50LCBsaW1p
dCksIGZpbGU9ZmlsZSkKICAgICAgICAgICAgaW5kZW50ICs9ICJcdCIKICAgICAgICAgICAgZmll
bGRfaWQgKz0gIiArIGkiCiAgICAgICAgICAgIHN0cnVjdF9tZW1iZXIgKz0gIltpXSIKICAgICAg
ICBpZiBudW1fZWxlbWVudHMgPiAxOgogICAgICAgICAgICBwcmludCgiJXNmb3IgKGogPSAwOyBq
IDwgJWQ7IGorKykiICUgKGluZGVudCwgbnVtX2VsZW1lbnRzKSwgZmlsZT1maWxlKQogICAgICAg
ICAgICBpbmRlbnQgKz0gIlx0IgogICAgICAgICAgICBmaWVsZF9pZCArPSAiICogMiArIGoiCiAg
ICAgICAgICAgIHN0cnVjdF9tZW1iZXIgKz0gIltqXSIKCiAgICAgICAgcHJpbnRfcmVhZF9maWVs
ZCgKICAgICAgICAgICAgZmllbGRfaWQsCiAgICAgICAgICAgIHN0cnVjdF92YXIsCiAgICAgICAg
ICAgIHN0cnVjdF9tZW1iZXIsCiAgICAgICAgICAgIGluZGVudCwKICAgICAgICAgICAgZmlsZT1m
aWxlLAogICAgICAgICkKCiAgICBwcmludChmaWxlPWZpbGUpCiAgICBwcmludCgiXHRyZXR1cm4g
cmV0OyIsIGZpbGU9ZmlsZSkKICAgIHByaW50KCJ9IiwgZmlsZT1maWxlKQoKZGVmIHByaW50X21h
aW5fc3RydWN0KGZpbGUpOgogICAgcHJpbnQoInN0cnVjdCB0ZHhfc3lzX2luZm8geyIsIGZpbGU9
ZmlsZSkKICAgIGZvciBjbGFzc19uYW1lLCBmaWVsZF9uYW1lcyBpbiBURFhfU1RSVUNUUy5pdGVt
cygpOgogICAgICAgIHN0cnVjdF9uYW1lID0gIiVzXyVzIiAlIChTVFJVQ1RfUFJFRklYLCBjbGFz
c19uYW1lKQogICAgICAgIHN0cnVjdF92YXIgPSBjbGFzc19uYW1lCiAgICAgICAgcHJpbnQoIlx0
c3RydWN0ICVzICVzOyIgJSAoc3RydWN0X25hbWUsIHN0cnVjdF92YXIpLCBmaWxlPWZpbGUpCiAg
ICBwcmludCgifTsiLCBmaWxlPWZpbGUpCgpkZWYgcHJpbnRfbWFpbl9mdW5jdGlvbihmaWxlKToK
ICAgIHByaW50KCJzdGF0aWMgaW50IGdldF90ZHhfc3lzX2luZm8oc3RydWN0IHRkeF9zeXNfaW5m
byAqc3lzaW5mbykiLCBmaWxlPWZpbGUpCiAgICBwcmludCgieyIsIGZpbGU9ZmlsZSkKICAgIHBy
aW50KCJcdGludCByZXQgPSAwOyIsIGZpbGU9ZmlsZSkKICAgIHByaW50KGZpbGU9ZmlsZSkKICAg
IGZvciBjbGFzc19uYW1lLCBmaWVsZF9uYW1lcyBpbiBURFhfU1RSVUNUUy5pdGVtcygpOgogICAg
ICAgIGZ1bmNfbmFtZSA9ICIlc18lcyIgJSAoRlVOQ19QUkVGSVgsIGNsYXNzX25hbWUpCiAgICAg
ICAgc3RydWN0X3ZhciA9IGNsYXNzX25hbWUKICAgICAgICBwcmludCgiXHRyZXQgPSByZXQgPzog
JXMoJnN5c2luZm8tPiVzKTsiICUgKGZ1bmNfbmFtZSwgc3RydWN0X3ZhciksIGZpbGU9ZmlsZSkK
ICAgIHByaW50KGZpbGU9ZmlsZSkKICAgIHByaW50KCJcdHJldHVybiByZXQ7IiwgZmlsZT1maWxl
KQogICAgcHJpbnQoIn0iLCBmaWxlPWZpbGUpCgpqc29uZmlsZSA9IHN5cy5hcmd2WzFdCmhmaWxl
ID0gc3lzLmFyZ3ZbMl0KY2ZpbGUgPSBzeXMuYXJndlszXQpoZmlsZWlmZGVmID0gaGZpbGUucmVw
bGFjZSgiLiIsICJfIikKCndpdGggb3Blbihqc29uZmlsZSwgInIiKSBhcyBmOgogICAganNvbl9p
biA9IGpzb24ubG9hZChmKQogICAgZmllbGRzID0ge3hbIkZpZWxkIE5hbWUiXTogeCBmb3IgeCBp
biBqc29uX2luWyJGaWVsZHMiXX0KCndpdGggb3BlbihoZmlsZSwgInciKSBhcyBmOgogICAgcHJp
bnQoIi8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovIiwgZmlsZT1mKQogICAg
cHJpbnQoIi8qIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIFREWCBnbG9iYWwgbWV0YWRhdGEgc3Ry
dWN0dXJlcy4gKi8iLCBmaWxlPWYpCiAgICBwcmludCgiI2lmbmRlZiBfWDg2X1ZJUlRfVERYX0FV
VE9fR0VORVJBVEVEXyIgKyBoZmlsZWlmZGVmLnVwcGVyKCksIGZpbGU9ZikKICAgIHByaW50KCIj
ZGVmaW5lIF9YODZfVklSVF9URFhfQVVUT19HRU5FUkFURURfIiArIGhmaWxlaWZkZWYudXBwZXIo
KSwgZmlsZT1mKQogICAgcHJpbnQoZmlsZT1mKQogICAgcHJpbnQoIiNpbmNsdWRlIDxsaW51eC90
eXBlcy5oPiIsIGZpbGU9ZikKICAgIHByaW50KGZpbGU9ZikKICAgIGZvciBjbGFzc19uYW1lLCBm
aWVsZF9uYW1lcyBpbiBURFhfU1RSVUNUUy5pdGVtcygpOgogICAgICAgIHByaW50X2NsYXNzX3N0
cnVjdChjbGFzc19uYW1lLCBbZmllbGRzW3hdIGZvciB4IGluIGZpZWxkX25hbWVzXSwgZmlsZT1m
KQogICAgICAgIHByaW50KGZpbGU9ZikKICAgIHByaW50X21haW5fc3RydWN0KGZpbGU9ZikKICAg
IHByaW50KGZpbGU9ZikKICAgIHByaW50KCIjZW5kaWYiLCBmaWxlPWYpCgp3aXRoIG9wZW4oY2Zp
bGUsICJ3IikgYXMgZjoKICAgIHByaW50KCIvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMCIsIGZpbGU9ZikKICAgIHByaW50KCIvKiIsIGZpbGU9ZikKICAgIHByaW50KCIgKiBBdXRv
bWF0aWNhbGx5IGdlbmVyYXRlZCBmdW5jdGlvbnMgdG8gcmVhZCBURFggZ2xvYmFsIG1ldGFkYXRh
LiIsIGZpbGU9ZikKICAgIHByaW50KCIgKiIsIGZpbGU9ZikKICAgIHByaW50KCIgKiBUaGlzIGZp
bGUgZG9lc24ndCBjb21waWxlIG9uIGl0cyBvd24gYXMgaXQgbGFja3Mgb2YgaW5jbHVzaW9uIiwg
ZmlsZT1mKQogICAgcHJpbnQoIiAqIG9mIFNFQU1DQUxMIHdyYXBwZXIgcHJpbWl0aXZlIHdoaWNo
IHJlYWRzIGdsb2JhbCBtZXRhZGF0YS4iLCBmaWxlPWYpCiAgICBwcmludCgiICogSW5jbHVkZSB0
aGlzIGZpbGUgdG8gb3RoZXIgQyBmaWxlIGluc3RlYWQuIiwgZmlsZT1mKQogICAgcHJpbnQoIiAq
LyIsIGZpbGU9ZikKICAgIGZvciBjbGFzc19uYW1lLCBmaWVsZF9uYW1lcyBpbiBURFhfU1RSVUNU
Uy5pdGVtcygpOgogICAgICAgIHByaW50KGZpbGU9ZikKICAgICAgICBwcmludF9jbGFzc19mdW5j
dGlvbihjbGFzc19uYW1lLCBbZmllbGRzW3hdIGZvciB4IGluIGZpZWxkX25hbWVzXSwgZmlsZT1m
KQogICAgcHJpbnQoZmlsZT1mKQogICAgcHJpbnRfbWFpbl9mdW5jdGlvbihmaWxlPWYpCg==

--_002_d5aed06ae4b46df5db97fdbac9c01843920a2f96camelintelcom_--

