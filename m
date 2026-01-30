Return-Path: <kvm+bounces-69756-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPSoBhZFfWkaRQIAu9opvQ
	(envelope-from <kvm+bounces-69756-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:56:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 88627BF750
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3900030164B4
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 23:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8084D38B993;
	Fri, 30 Jan 2026 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GSc/iki5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC90B38B7D5;
	Fri, 30 Jan 2026 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817355; cv=fail; b=BphcxegRoaDi3V6u+69fdcYdGAvvBWZJYiUm1q2OtDRSnkJBS8V2VXh4xgPno+y1nv49djxGW2c1zhZYELiAulZ+mEZStaq/YE6tQGQRmVmnqDdsoCalkgDME+yWUvrt4kOCu+GNQeLpC6xrUIG9NDHpEtJ5IrHqpX90/jxZlKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817355; c=relaxed/simple;
	bh=s8OGueJmn4Gfl4Wrc1z8QtRIMFXTJDyZecEWntodyMg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uDGSzm6WPHuPbSuDUjtAbwNv9p6D41Xf639+AGaGBDYG86M3icu1VE2cOecDbGcyTpKbddhOxN7sXRkiyPTasGhMq8gK7wfz1fummLpuTLm92A1HND82NVnf7E7XrL4W6DcPh64XN+WkAuzgJwsewzA9Hio28gMsvGHG+EbCobE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GSc/iki5; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769817354; x=1801353354;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s8OGueJmn4Gfl4Wrc1z8QtRIMFXTJDyZecEWntodyMg=;
  b=GSc/iki5HEFzgC8u4Skhve0jGGSL7WADfjt5Kqp8WjlAkuZgc98UWPqJ
   SbONBYcGZDIa2CTXOniqE09XRyl/ArpG8mjB5KNo12DsGaY4exhat13wK
   o3GMGBl5sX2Zhrq70c+GEqhnbo6KNO9XvWqhb6U+XXE7zwx0GnhecOgxQ
   hpPnwlAGr90bGC4eg4XIiKwOQz3RSMtSK5rhOUAuZyy2lgFPaUBi9oM4u
   hYso4sktxjF+gNc4xVJteqIlY7UNKXiQkafrm3pErLAiGlMF8pTEeEUBx
   jf+m8Q7aObDqqKWQicdNO/0lvq034QtKXShGczKwUKSX02yR2jZ7RYYvT
   g==;
X-CSE-ConnectionGUID: w6JyOceIRFiujQkwCR+Jxg==
X-CSE-MsgGUID: RIeWeVMFTI6SjDRcb1vVRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="71127665"
X-IronPort-AV: E=Sophos;i="6.21,264,1763452800"; 
   d="scan'208";a="71127665"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 15:55:53 -0800
X-CSE-ConnectionGUID: yI+hZG+kT5CyFstrxR17dQ==
X-CSE-MsgGUID: wsYHgKqbSfmXmGd5Y+bI8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,264,1763452800"; 
   d="scan'208";a="213914533"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 15:55:53 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 15:55:52 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 15:55:52 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 15:55:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+tcCV4FSUYhvBgV5tDKqb/XM6b74VVH4GX8jh+dAgr1WxLKz+j8qhSs/0SmZ/ZirVGBaj5ZDPJvqVCH20mAez3tgRoFCOfJfPxc0Ags4c+zlASEWpIggHmAssL/WnUwZQ9DPR2KOZr1laRXFT0VmEMW+iGjt/4QNjguoS1YlG/MWX7IHfs2J4WCsmq1NE1WbJ0cdOb6SWwijtIpc+/rXBs21akMHwWF7WkdkvDUw0vnRY1KYb5ebotpPDzf1YBo2Qvu972Hj+P0G4TxxKZYBjS7JTTbmYBKhX1OBY8mB0L4+xs1A3xsWw+7SFz26wxTxriFTWnRJk8fHECVVzxfIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8OGueJmn4Gfl4Wrc1z8QtRIMFXTJDyZecEWntodyMg=;
 b=Ffm9NStK4UohuNd8ysy2i+M+ydB1aoh2HXay6n9W19auZDdq0upN/5Q+VdZxWhb6TKMLyPqOC7A+uUtq7nLQahAkgsTtS1dXN6oug0h6jVYe/X8uGp8kkV+rWRH3UCj3iTHOmm/WWJ3DRnstT8Xt/fKE7E0mF2YcaG8/ohpExLJpcEJKGsJYT6NQLtLueuzEvu3iwwu3VlCJ9oSJUNcwsSqNv4CxA5OfyO6AgF/MnLipqQx9Hi0a7qUv80lQZkULSXu5QrKtg61wPkMBNALqEOzbUWi8Dv6KFihaWZuVydumwnu1lg2FWsFWLo8KlM2XRxiCcvP1aYMDFLvWofPTDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB5948.namprd11.prod.outlook.com (2603:10b6:806:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 23:55:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 23:55:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Thread-Topic: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Thread-Index: AQHckLzPtDfQFZTNWUquSq6vUJ5iBLVrZr4A
Date: Fri, 30 Jan 2026 23:55:43 +0000
Message-ID: <0855f4db39b58fdea6f6304fc97863241e509620.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-6-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB5948:EE_
x-ms-office365-filtering-correlation-id: c85cd084-2a88-4698-6f12-08de605b143c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?U0JCbWRTM2RxYUpoWmVnM1I2bjF4akU4QVRCY1c2ZnkycjFGMDRITTRpeXQ0?=
 =?utf-8?B?eXJENFdQY1dOcDd0VzhDWDVjQjNhNmJZdDBVQ1A3eVVFUjFZUVVWUXB3M0Rh?=
 =?utf-8?B?Tzcza1hBMytZY01yL0dFcHE4a3RmQ1FyTVBKQ2pVTXdvZzd0RVJybEphTkpm?=
 =?utf-8?B?bmtzTWpPNVV2UVhieXpCay9CVVUvWDFDVERhR0JWdkx4ay94MDVURFlCUVJI?=
 =?utf-8?B?UHhsZnNoSGlHV3cwNFd2L29iODhqUzlpVnBaTDZFK0U5UEdKYVFFWGk1QWlm?=
 =?utf-8?B?V1FVakJsREZXMkNDVjFrZXcyWjJtbjF1SDlpQU1IazN1dzQ2cVNDdllCOGdS?=
 =?utf-8?B?dEs4NEZVMTdiTUR1UUZ6UWk1N3pGU2EvRDdWZ3FRbGwvbkpWZ1pxcHRiaUdQ?=
 =?utf-8?B?OVZ4NkRoU0lPZ0RMSC9BNFlxNm11bm0vUks1dEs0WGdTZXpmOWJVN09UbUFj?=
 =?utf-8?B?L05kS1ZKOEp3YzhSRzl2Y2FHdFFrUFdsK255Y3IyNTgyb20vN0ZwL0NueU5I?=
 =?utf-8?B?NUlTVUN2SVlpOGxxbmU5K0NOaVhrN1d1YlVuREd4aE45WjRaZkRDazk0RlJB?=
 =?utf-8?B?dHI5VW5tajdGWm1rZTY0a1ZxN1V3N0NPSFNwY2NUTDBCK2dwamgyaEk3MzI3?=
 =?utf-8?B?cytkcjhMNG43bzUwWUdLTkJlT01jMmtmVktlS3ptYno0eHE3SVhIQ2YwbUwy?=
 =?utf-8?B?a1dBZEtEMmJQRUFXS01NY1BEQjV4U256dVNzMmJwQzBiSlczODJGZUVURzdu?=
 =?utf-8?B?Tk81dnRSSFBJczRMaTZsa3VUY1JVdURzK1lJWkNYQk5BMnNSUHBiZ0ozZU5U?=
 =?utf-8?B?T1BWd1hFdFFFMDhGbm1XdGFqVExrL1FoaXdFUmRSaHBnWVVKc3ltQko3SGlq?=
 =?utf-8?B?TjlubmtBOFh2MU9TRVVIWmN0OUpIZ0pGTWxqVkhOWUlRTEtFRWJldDgzNFI2?=
 =?utf-8?B?NFl3S3NFS0xjZC9aMDk5NURyNDFKVElrOTBLdDE3YTZPNTE4UHA3blZHTm56?=
 =?utf-8?B?Q1ViZHljdTE2a0NCTUJlZVdkRTQyRFBua2VYaVUyamZmWUphcllCbDNZcFJL?=
 =?utf-8?B?RmpmMmczZWtkbEFIaW5OckZkSWdQY2g1Z0M4d2NmY3JnZGVPR0h3QkRQUXFN?=
 =?utf-8?B?bWp4RndwYkEyQkpxblN1c2llLzdCZ2RhVlRHQUs5a3NyaG5XaWpkbHdIamN0?=
 =?utf-8?B?QmM5NXNLeE1MWk95enZpQXM5ZGVHVWlpdWVCZUF5NWVPN3ZINlV6ZTZ5UGNY?=
 =?utf-8?B?Zk4zZmsrVXdkOXczWlF6bEFuZW8rUVByclpkeEtDVFltMk5sOGJnSURSUitQ?=
 =?utf-8?B?V0lJZFdNcmdzaDlpNzBIU0U2Z21MSlZrY251TmxNMTFDMDYyRGFYN3VDU21o?=
 =?utf-8?B?T1JKcVh1Y0UzUlJzdnhTL2x1SzB5MXVnWktPVnYyY25Jamh5YkwrNGlGVFVx?=
 =?utf-8?B?ZWxpdk5aZVk1M1JFRE5VWUhETDZKZmNpM0g2YzAxSlhHK3dlamhyd1VsOFRu?=
 =?utf-8?B?ZGhvdm9BS2NDOERGN051VWpXS0FOa05KSzB3YWlEbHZtbkRhYmN4aUF4K29v?=
 =?utf-8?B?R2sxb21MT0ptVGtKNmRTL3VpV0p0QnpReU5TV2JZbXp6UVRLUWM0Tk5FMDFU?=
 =?utf-8?B?bXE0ZTZaYmI3cWdqdnBlUzRTTGNpUUtlSGVmTVFEc1B0QkVtVGxVNjgxdnNl?=
 =?utf-8?B?MDdDMEJjY3RXNkJNK0dFRytLNGVBSmlacm83TlczRlA5VnVySXUvSzN6czZu?=
 =?utf-8?B?T3EzM2tPc0d2anRUVWNDYW5mUnI0ME8yU2V0a1M1NUJzY0UxUXI2WGJObEJm?=
 =?utf-8?B?VWlkTzBWV1NJVExSN2MwSVFXeGlhbllIUlJpWTcvQitDQndZS0lraTJnbm9w?=
 =?utf-8?B?cEMzYnhMUEtEaWl6c3RWMmsza1JoN1lrd1JXOTNaOXRub3FJKzZyTm1yS2hj?=
 =?utf-8?B?eEJrOGdjZlZuT0g4SGdHUUFLZng4NDN5Z2RUbFpYVTg4eDljNU9sNlk2R3Bu?=
 =?utf-8?B?UDM2Q2FDYnRmL0ljYldaQSsyMkk1M1hWTkFhU2tWNEo0aTRYd0V6bjMxcCtt?=
 =?utf-8?B?TlliTEZ0VnF6eWNIL0tsQXAxZTlqaVQ3em5kanVUOTJUUnBCTVo3MkhxR2Zh?=
 =?utf-8?B?aUNtaHpXdWVVOW80ZmVUeE1QRmRvQmVrMXJCQ0ExWk1zdmg3bDdUcmptMVM3?=
 =?utf-8?Q?62/XEGRWNzVFlS0GEmvOT7s=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDZSaFI3bG1EZVJlenlQNkhHR2o1NjdzdWxLU2EvNjhXSTJQYUZ1bTRqNnc5?=
 =?utf-8?B?Z1lGMVNDc0xZaTZoby9DdHVhSU9uS0tlb0F0NE1aTnh5Z2Z3U1hwbFRSOTZz?=
 =?utf-8?B?MWFYQTRFWTZ0cUJCQmhKWUhPYS92WkZERnlFUW9jcVlzN0U0NnkvY000enhW?=
 =?utf-8?B?UmtqQnAwTkd0U3BxbUFmbTBCRUdDRk85eXVFWTNQeURzQkhERi9JVWkzZ0tF?=
 =?utf-8?B?OUhEVDl1QmFTMjVkQk1NZ1NmdXM2UTVBei9mSUc1eVRONVozaVBoRnliQmMr?=
 =?utf-8?B?R0l3d0E5Vm40ZTV2UGJtWUdIb3FpMUZFenBJSGdyZ0hXbmx2cGhMaFJzckh3?=
 =?utf-8?B?TVZCd3lpVlJDRzNkZjFlSkhEV21ISkM0T1VaWDFrMENuUnE5d1JlYnA5Rktv?=
 =?utf-8?B?aWZaazVXZlozNmpSWkdScEk0WlV3V2k5SkJvaDFxL1NmV0lpdTBQNmtlWjIy?=
 =?utf-8?B?RkxPa1pqaHVjNWNVWTBvdDdKdWxaaFZTZ3BraTk3WklpSlBrZlpjZ0tBWEtP?=
 =?utf-8?B?MktkRk5lRnVEZ2hyeWVxK002anJmdUZZY3lzZ1h3UE5vQ2NqVXJ6MjdDNWR5?=
 =?utf-8?B?S2RpSlFWZ1Nodi9UWEI0MVNMcEhtWjN3NWVjQmE4Ylk2QVhjSzlQTXY0Ukcz?=
 =?utf-8?B?WUFqbTJWcFdNZ0JTOExwelFLdFBMYUpmOE9DMUlpWGFIZXg5cUlnYzNvU29q?=
 =?utf-8?B?Yi9pemVVM3NjQ2MwT21kZ24yNCtSMmFnOUNNaDI5eUE2a1ZCYVNHY1VDYXUr?=
 =?utf-8?B?ZW91NnRWdm8yVHBqZGRaM3VtM2t6QjJ5dEUxeGZtOERncnFrend4MzA0MXdv?=
 =?utf-8?B?a3VFN1RNR01wVTBsOVQvczZzSldHczJsYUhJN2cxYUl6R3pwcFBKNVVYMkd1?=
 =?utf-8?B?OGo5b3RkaEQ4Q2t3VDBMQzI5K3R0VVkyODZ5Qmt3RUFwYlFid2wvcHA4K3Mz?=
 =?utf-8?B?SHJrRE9FRkVrWFZDbzBiMVFhaG02ejlKeVE5M2h2ZTA3ZkVUNmNSNjRtMTI0?=
 =?utf-8?B?WlZuaGw1cEwrSUpISVgxYjBENjJPUVZHY1hzZUV6VDlPRXdNb0RzSmVjeG40?=
 =?utf-8?B?VmdsR1JsRmZwSHloRnViOWQ2RCtqSFZXVjhmd2tpaDhWY0tuWE9lK2xFTEJK?=
 =?utf-8?B?c1ptV0tvVWoyOHpWdHcrajM0Q2t0empJWEdBeWJxSktnRS9sNVUvTWRwRGxl?=
 =?utf-8?B?OU51MkVZL21HSGxZWVZXMnByME81djNTMzFlUE9hUUhDNktNMElLUnBmc0Vx?=
 =?utf-8?B?WnMxTWpERFYvS1V0TmhrQ0szOCsrZjk5Nkh3aHkxWVEyNCtjTk52Q0JWNmNJ?=
 =?utf-8?B?aUE5QjlkRlcxZmpPR09aZWlSWWtuU3M0UDArcXFMNjVNbit6KzN4Y0JNT0pz?=
 =?utf-8?B?bkNqYThxbk41dy91VkJ5ZjMrS2Z1WVRxNm45VXVaaHdscjY2SjY2dGw4RE1M?=
 =?utf-8?B?WEF4VU9PSnY0M3pZMFRmbEZHM25SSWdzdXFraE1JU0I4eEpVMlh2cC9DVXpT?=
 =?utf-8?B?OUdqSlY5MGIxTC9XV0JUMWpVcjZ2RjhsamEyYXJzUGhkN3pGSE9MYkNQNk5H?=
 =?utf-8?B?bzVjK1AyUHVEcXNmajNYWTVxVU5hdkliUkoyclZDckk2WjVKSkxLNUhQampa?=
 =?utf-8?B?VzNpZFdmeFdySzI5ZTA0MDZNcXZWY21jNUdRZ2pTbmwxTS9GQ213Y1l1bVpR?=
 =?utf-8?B?VlMzc0lhQTVOcmh3RHNlZWlNTUNIL09kUDFZK0twR0tkcC9qQ3crSVljSEI4?=
 =?utf-8?B?VjFDUCs0cmt0NFJHRFlIcW5YbWFIeVhCd0xLOGcrdEh3VHoxMUJveEVCcCtw?=
 =?utf-8?B?MVk4c05iMUE0dEl6amJ3RTliVERpeTd4TW5sYUlTdUxieTk1bkY5TUtUMFJm?=
 =?utf-8?B?ZjUxVys5ZGdEMmNkamhRcGZhaFk3b2ppdkgrVFBVeWlDS1I4djU5YW5adHNQ?=
 =?utf-8?B?RDhmZmZ4bnFWZSt1THU5M0o1Q0U5b1lVTk1zWURXUlRxK2dKc0NEMmE2VW1l?=
 =?utf-8?B?UU5jMGhjQjcrRWFzeXpIL2h3cGxyN2grbC9xRjVPenQyTnhneFhXR3U1azBO?=
 =?utf-8?B?VXJ5S1I2SG1JRXFRNXBlZVlXQjEzS2JPbUN4L1Rwb1g5cUFEYnd0NmFEM1U4?=
 =?utf-8?B?cmlEMUk4ZmYwSVlpcjU1cTRNRWMwVk1OOGtiKzhsTmJHVDZMaFBSREhKekNl?=
 =?utf-8?B?eml6ZXJHZGUxbGpEVWRIN3RvZnlRWWlsaXF3eTU0dUJkbXJSQkxVeWJzS2tz?=
 =?utf-8?B?cEdZZWlzOTB0THB4dG1odzYweEtlMGdWZ2tMbmxSYjJXV0E5UEJVS3gwSE9y?=
 =?utf-8?B?Q1djcDI4bWEreFVqZ2E2Ym1qYmJEVG9jc3g1UjZjeEl2aVg3RGU3bEpzR2E1?=
 =?utf-8?Q?DAYvpxfA/vcz7ILw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F02E65140DA6FA478CD51B45942FC95B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c85cd084-2a88-4698-6f12-08de605b143c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 23:55:43.0525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SF5jcXbjzy3I1ZfXJqIYFk25Y9c2Cj04kO0vREErP/BVkoo5DkCeYaZhRhDQ26PXeIFL/YSUVQbPbL5cgz08fdv1iRpA3wj/DADp9iXrhz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5948
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69756-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 88627BF750
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIHRoZSBkZWRpY2F0ZWQgLmxpbmtfZXh0ZXJuYWxfc3B0KCkgZm9yIGxpbmtp
bmcgbm9uLWxlYWYgUy1FUFQNCj4gcGFnZXMsIGFuZCBpbnN0ZWFkIGZ1bm5lbCBldmVyeXRoaW5n
IHRocm91Z2ggLnNldF9leHRlcm5hbF9zcHRlKCkuwqANCj4gVXNpbmcgc2VwYXJhdGUgaG9va3Mg
ZG9lc24ndCBoZWxwIHByZXZlbnQgVERQIE1NVSBkZXRhaWxzIGZyb20NCj4gYmxlZWRpbmcgaW50
byBURFgsIGFuZCB2aWNlIHZlcnNhOyB0byB0aGUgY29udHJhcnksIGRlZGljYXRlZA0KPiBjYWxs
YmFja3Mgd2lsbCByZXN1bHQgaW4gX21vcmVfIHBvbGx1dGlvbiB3aGVuIGh1Z2VwYWdlIHN1cHBv
cnQgaXMNCj4gYWRkZWQsIGUuZy4gd2lsbCByZXF1aXJlIHRoZSBURFAgTU1VIHRvIGtub3cgZGV0
YWlscyBhYm91dCB0aGUNCj4gc3BsaXR0aW5nIHJ1bGVzIGZvciBURFggdGhhdCBhcmVuJ3QgYWxs
IHRoYXQgcmVsZXZhbnQgdG8NCj4gdGhlIFREUCBNTVUuDQo+IA0KPiBJZGVhbGx5LCBLVk0gd291
bGQgcHJvdmlkZSBhIHNpbmdsZSBwYWlyIG9mIGhvb2tzIHRvIHNldCBTLUVQVA0KPiBlbnRyaWVz
LCBvbmUgaG9vayBmb3Igc2V0dGluZyBTUFRFcyB1bmRlciB3cml0ZS1sb2NrIGFuZCBhbm90aGVy
IGZvcg0KPiBzZXR0aW5ncyBTUFRFcyB1bmRlciByZWFkLWxvY2sgKGUuZy4gdG8gZW5zdXJlIHRo
ZSBlbnRpcmUgb3BlcmF0aW9uDQo+IGlzICJhdG9taWMiLCB0byBhbGxvdyBmb3IgZmFpbHVyZSwg
ZXRjLikuwqAgU2FkbHksIFREWCdzIHJlcXVpcmVtZW50DQo+IHRoYXQgYWxsIGNoaWxkIFMtRVBU
IGVudHJpZXMgYXJlIHJlbW92ZWQgYmVmb3JlIHRoZSBwYXJlbnQgbWFrZXMgdGhhdA0KPiBpbXBy
YWN0aWNhbDogdGhlIFREUCBNTVUgZGVsaWJlcmF0ZWx5IHBydW5lcyBub24tbGVhZiBTUFRFcyBh
bmQNCj4gX3RoZW5fIHByb2Nlc3NlcyBpdHMgY2hpbGRyZW4sIHRodXMgbWFraW5nIGl0IHF1aXRl
IGltcG9ydGFudCBmb3IgdGhlDQo+IFREUCBNTVUgdG8gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIHph
cHBpbmcgbGVhZiBhbmQgbm9uLWxlYWYgUy1FUFQNCj4gZW50cmllcy4NCj4gDQo+IEhvd2V2ZXIs
IHRoYXQncyB0aGUgX29ubHlfIGNhc2UgdGhhdCdzIHRydWx5IHNwZWNpYWwsIGFuZCBldmVuIHRo
YXQNCj4gY2FzZSBjb3VsZCBiZSBzaG9laG9ybmVkIGludG8gYSBzaW5nbGUgaG9vazsgaXQncyBq
dXN0IHdvdWxkbid0IGJlIGENCj4gbmV0IHBvc2l0aXZlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNCkl0IGhhcyBiZXR0ZXIg
aGFuZGxpbmcgb2YgdGhlIGV4dGVybmFsX3NwdCA9PSBOVUxMIGNhc2UgdG9vLCBieQ0KYWN0dWFs
bHkgcmV0dXJuaW5nIGFuIGVycm9yLCBidXQgb25lIG5hbWluZyBuaXQgYmVsb3cgdG8gdGFrZSBv
ciBsZWF2ZS4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJl
QGludGVsLmNvbT4NCg0KPiAtLS0NCj4gwqBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9w
cy5oIHzCoCAxIC0NCj4gwqBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5owqDCoMKgIHzC
oCAzIC0tDQo+IMKgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmPCoMKgwqDCoMKgwqDCoMKgIHwg
MzcgKysrLS0tLS0tLS0tLS0tLS0tDQo+IMKgYXJjaC94ODYva3ZtL3ZteC90ZHguY8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB8IDYxICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0NCj4gLS0N
Cj4gwqA0IGZpbGVzIGNoYW5nZWQsIDQ4IGluc2VydGlvbnMoKyksIDU0IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bS14ODYtb3BzLmgNCj4g
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5oDQo+IGluZGV4IGMxOGEwMzNiZWU3
ZS4uNTdlYjFmNDgzMmFlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0t
eDg2LW9wcy5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bS14ODYtb3BzLmgNCj4g
QEAgLTk0LDcgKzk0LDYgQEAgS1ZNX1g4Nl9PUF9PUFRJT05BTF9SRVQwKHNldF90c3NfYWRkcikN
Cj4gwqBLVk1fWDg2X09QX09QVElPTkFMX1JFVDAoc2V0X2lkZW50aXR5X21hcF9hZGRyKQ0KPiDC
oEtWTV9YODZfT1BfT1BUSU9OQUxfUkVUMChnZXRfbXRfbWFzaykNCj4gwqBLVk1fWDg2X09QKGxv
YWRfbW11X3BnZCkNCj4gLUtWTV9YODZfT1BfT1BUSU9OQUxfUkVUMChsaW5rX2V4dGVybmFsX3Nw
dCkNCj4gwqBLVk1fWDg2X09QX09QVElPTkFMX1JFVDAoc2V0X2V4dGVybmFsX3NwdGUpDQo+IMKg
S1ZNX1g4Nl9PUF9PUFRJT05BTF9SRVQwKGZyZWVfZXh0ZXJuYWxfc3B0KQ0KPiDCoEtWTV9YODZf
T1BfT1BUSU9OQUwocmVtb3ZlX2V4dGVybmFsX3NwdGUpDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaA0KPiBpbmRleCBlNDQxZjI3MGYzNTQuLmQxMmNhMGY4YTM0OCAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oDQo+IEBAIC0xODUzLDkgKzE4NTMsNiBAQCBzdHJ1Y3Qga3ZtX3g4Nl9v
cHMgew0KPiDCoAl2b2lkICgqbG9hZF9tbXVfcGdkKShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGhw
YV90IHJvb3RfaHBhLA0KPiDCoAkJCcKgwqDCoMKgIGludCByb290X2xldmVsKTsNCj4gwqANCj4g
LQkvKiBVcGRhdGUgZXh0ZXJuYWwgbWFwcGluZyB3aXRoIHBhZ2UgdGFibGUgbGluay4gKi8NCj4g
LQlpbnQgKCpsaW5rX2V4dGVybmFsX3NwdCkoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sIGVu
dW0NCj4gcGdfbGV2ZWwgbGV2ZWwsDQo+IC0JCQkJdm9pZCAqZXh0ZXJuYWxfc3B0KTsNCj4gwqAJ
LyogVXBkYXRlIHRoZSBleHRlcm5hbCBwYWdlIHRhYmxlIGZyb20gc3B0ZSBnZXR0aW5nIHNldC4g
Ki8NCj4gwqAJaW50ICgqc2V0X2V4dGVybmFsX3NwdGUpKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3Qg
Z2ZuLCBlbnVtDQo+IHBnX2xldmVsIGxldmVsLA0KPiDCoAkJCQkgdTY0IG1pcnJvcl9zcHRlKTsN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYva3Zt
L21tdS90ZHBfbW11LmMNCj4gaW5kZXggMGZlZGEyOTU4NTlhLi41NmFkMDU2ZTYwNDIgMTAwNjQ0
DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS9tbXUvdGRwX21tdS5jDQo+IEBAIC00OTUsMzEgKzQ5NSwxNyBAQCBzdGF0aWMgdm9pZCBoYW5k
bGVfcmVtb3ZlZF9wdChzdHJ1Y3Qga3ZtICprdm0sDQo+IHRkcF9wdGVwX3QgcHQsIGJvb2wgc2hh
cmVkKQ0KPiDCoAljYWxsX3JjdSgmc3AtPnJjdV9oZWFkLCB0ZHBfbW11X2ZyZWVfc3BfcmN1X2Nh
bGxiYWNrKTsNCj4gwqB9DQo+IMKgDQo+IC1zdGF0aWMgdm9pZCAqZ2V0X2V4dGVybmFsX3NwdChn
Zm5fdCBnZm4sIHU2NCBuZXdfc3B0ZSwgaW50IGxldmVsKQ0KPiAtew0KPiAtCWlmIChpc19zaGFk
b3dfcHJlc2VudF9wdGUobmV3X3NwdGUpICYmDQo+ICFpc19sYXN0X3NwdGUobmV3X3NwdGUsIGxl
dmVsKSkgew0KPiAtCQlzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCA9DQo+IHNwdGVfdG9fY2hpbGRf
c3AobmV3X3NwdGUpOw0KPiAtDQo+IC0JCVdBUk5fT05fT05DRShzcC0+cm9sZS5sZXZlbCArIDEg
IT0gbGV2ZWwpOw0KPiAtCQlXQVJOX09OX09OQ0Uoc3AtPmdmbiAhPSBnZm4pOw0KPiAtCQlyZXR1
cm4gc3AtPmV4dGVybmFsX3NwdDsNCj4gLQl9DQo+IC0NCj4gLQlyZXR1cm4gTlVMTDsNCj4gLX0N
Cj4gLQ0KPiDCoHN0YXRpYyBpbnQgX19tdXN0X2NoZWNrIHNldF9leHRlcm5hbF9zcHRlX3ByZXNl
bnQoc3RydWN0IGt2bSAqa3ZtLA0KPiB0ZHBfcHRlcF90IHNwdGVwLA0KPiDCoAkJCQkJCSBnZm5f
dCBnZm4sIHU2NA0KPiAqb2xkX3NwdGUsDQo+IMKgCQkJCQkJIHU2NCBuZXdfc3B0ZSwgaW50DQo+
IGxldmVsKQ0KPiDCoHsNCj4gLQlib29sIHdhc19wcmVzZW50ID0gaXNfc2hhZG93X3ByZXNlbnRf
cHRlKCpvbGRfc3B0ZSk7DQo+IC0JYm9vbCBpc19wcmVzZW50ID0gaXNfc2hhZG93X3ByZXNlbnRf
cHRlKG5ld19zcHRlKTsNCj4gLQlib29sIGlzX2xlYWYgPSBpc19wcmVzZW50ICYmIGlzX2xhc3Rf
c3B0ZShuZXdfc3B0ZSwgbGV2ZWwpOw0KPiAtCWludCByZXQgPSAwOw0KPiAtDQo+IC0JS1ZNX0JV
R19PTih3YXNfcHJlc2VudCwga3ZtKTsNCj4gKwlpbnQgcmV0Ow0KPiDCoA0KPiDCoAlsb2NrZGVw
X2Fzc2VydF9oZWxkKCZrdm0tPm1tdV9sb2NrKTsNCj4gKw0KPiArCWlmIChLVk1fQlVHX09OKGlz
X3NoYWRvd19wcmVzZW50X3B0ZSgqb2xkX3NwdGUpLCBrdm0pKQ0KPiArCQlyZXR1cm4gLUVJTzsN
Cj4gKw0KPiDCoAkvKg0KPiDCoAkgKiBXZSBuZWVkIHRvIGxvY2sgb3V0IG90aGVyIHVwZGF0ZXMg
dG8gdGhlIFNQVEUgdW50aWwgdGhlDQo+IGV4dGVybmFsDQo+IMKgCSAqIHBhZ2UgdGFibGUgaGFz
IGJlZW4gbW9kaWZpZWQuIFVzZSBGUk9aRU5fU1BURSBzaW1pbGFyIHRvDQo+IEBAIC01MjgsMTgg
KzUxNCw3IEBAIHN0YXRpYyBpbnQgX19tdXN0X2NoZWNrDQo+IHNldF9leHRlcm5hbF9zcHRlX3By
ZXNlbnQoc3RydWN0IGt2bSAqa3ZtLCB0ZHBfcHRlcF90IHNwDQo+IMKgCWlmICghdHJ5X2NtcHhj
aGc2NChyY3VfZGVyZWZlcmVuY2Uoc3B0ZXApLCBvbGRfc3B0ZSwNCj4gRlJPWkVOX1NQVEUpKQ0K
PiDCoAkJcmV0dXJuIC1FQlVTWTsNCj4gwqANCj4gLQkvKg0KPiAtCSAqIFVzZSBkaWZmZXJlbnQg
Y2FsbCB0byBlaXRoZXIgc2V0IHVwIG1pZGRsZSBsZXZlbA0KPiAtCSAqIGV4dGVybmFsIHBhZ2Ug
dGFibGUsIG9yIGxlYWYuDQo+IC0JICovDQo+IC0JaWYgKGlzX2xlYWYpIHsNCj4gLQkJcmV0ID0g
a3ZtX3g4Nl9jYWxsKHNldF9leHRlcm5hbF9zcHRlKShrdm0sIGdmbiwNCj4gbGV2ZWwsIG5ld19z
cHRlKTsNCj4gLQl9IGVsc2Ugew0KPiAtCQl2b2lkICpleHRlcm5hbF9zcHQgPSBnZXRfZXh0ZXJu
YWxfc3B0KGdmbiwgbmV3X3NwdGUsDQo+IGxldmVsKTsNCj4gLQ0KPiAtCQlLVk1fQlVHX09OKCFl
eHRlcm5hbF9zcHQsIGt2bSk7DQo+IC0JCXJldCA9IGt2bV94ODZfY2FsbChsaW5rX2V4dGVybmFs
X3NwdCkoa3ZtLCBnZm4sDQo+IGxldmVsLCBleHRlcm5hbF9zcHQpOw0KPiAtCX0NCj4gKwlyZXQg
PSBrdm1feDg2X2NhbGwoc2V0X2V4dGVybmFsX3NwdGUpKGt2bSwgZ2ZuLCBsZXZlbCwNCj4gbmV3
X3NwdGUpOw0KPiDCoAlpZiAocmV0KQ0KPiDCoAkJX19rdm1fdGRwX21tdV93cml0ZV9zcHRlKHNw
dGVwLCAqb2xkX3NwdGUpOw0KPiDCoAllbHNlDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
dm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBpbmRleCA1Njg4Yzc3NjE2ZTMu
LjMwNDk0ZjljZWIzMSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IEBAIC0xNjY0LDE4ICsxNjY0LDU4IEBAIHN0
YXRpYyBpbnQgdGR4X21lbV9wYWdlX2F1ZyhzdHJ1Y3Qga3ZtICprdm0sDQo+IGdmbl90IGdmbiwN
Cj4gwqAJcmV0dXJuIDA7DQo+IMKgfQ0KPiDCoA0KPiArc3RhdGljIHN0cnVjdCBwYWdlICp0ZHhf
c3B0ZV90b19leHRlcm5hbF9zcHQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdA0KPiBnZm4sDQo+ICsJ
CQkJCcKgwqDCoMKgIHU2NCBuZXdfc3B0ZSwgZW51bQ0KPiBwZ19sZXZlbCBsZXZlbCkNCj4gK3sN
Cj4gKwlzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCA9IHNwdGVfdG9fY2hpbGRfc3AobmV3X3NwdGUp
Ow0KPiArDQo+ICsJaWYgKEtWTV9CVUdfT04oIXNwLT5leHRlcm5hbF9zcHQsIGt2bSkgfHwNCj4g
KwnCoMKgwqAgS1ZNX0JVR19PTihzcC0+cm9sZS5sZXZlbCArIDEgIT0gbGV2ZWwsIGt2bSkgfHwN
Cj4gKwnCoMKgwqAgS1ZNX0JVR19PTihzcC0+Z2ZuICE9IGdmbiwga3ZtKSkNCj4gKwkJcmV0dXJu
IE5VTEw7DQo+ICsNCj4gKwlyZXR1cm4gdmlydF90b19wYWdlKHNwLT5leHRlcm5hbF9zcHQpOw0K
PiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IHRkeF9zZXB0X2xpbmtfcHJpdmF0ZV9zcHQoc3RydWN0
IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ICsJCQkJwqDCoMKgwqAgZW51bSBwZ19sZXZlbCBsZXZl
bCwgdTY0DQo+IG1pcnJvcl9zcHRlKQ0KPiArew0KPiArCWdwYV90IGdwYSA9IGdmbl90b19ncGEo
Z2ZuKTsNCj4gKwl1NjQgZXJyLCBlbnRyeSwgbGV2ZWxfc3RhdGU7DQo+ICsJc3RydWN0IHBhZ2Ug
KmV4dGVybmFsX3NwdDsNCj4gKw0KPiArCWV4dGVybmFsX3NwdCA9IHRkeF9zcHRlX3RvX2V4dGVy
bmFsX3NwdChrdm0sIGdmbiwNCj4gbWlycm9yX3NwdGUsIGxldmVsKTsNCg0KVGhlICJleHRlcm5h
bCIgYWJzdHJhY3Rpb24gd3JhcHMgdGhlICJTLUVQVCIga25vd2xlZGdlIGFuZCBuYW1pbmcgKGZv
cg0KbWF5YmUgaW5jcmVhc2luZ2x5IGR1YmlvdXMgcmVhc29ucyksIGJ1dCBpbiB0aGUgVERYIGNv
ZGUsIGluc2lkZSB0aGUNCmFic3RyYWN0aW9uLCBpdCB1c2VzIHRoZSBzZXB0IG5hbWluZy4gc28g
SSBtaWdodCBoYXZlIGNhbGxlZCBpdA0Kc2VwdF9wdC4NCg0KDQo=

