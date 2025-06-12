Return-Path: <kvm+bounces-49209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 402D1AD656B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5233E17E457
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341FF1AAA1D;
	Thu, 12 Jun 2025 02:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XuE56tWq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F22A1C9;
	Thu, 12 Jun 2025 02:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749694193; cv=fail; b=pS3SsH2xbJgBz2mBzh+JcqAPN96g4Esv1y1TmlxL1bI2+7eiitNabk2A9wi6ANd+G5fKzbtIg9jw4RoAB/dMequf6hleEEeQZaIPKDsCUXYhiHj9R8e/3Atw7ZKK3lkInv2z9JktR+r3j+NOdgQWHqm0HmxMp1ZIdiLKbDriqww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749694193; c=relaxed/simple;
	bh=UAAqUsYtY2HDVW9S/4tyS5IlVW4alCQz4TL31v371dA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D1v7GymF5VfEZSWfVIuKxItUPRpHhGyuY2AqcuhuZtz9fPKooC6VtJW55UlAfOcVmaAz5xxphvCuIuWu3LgVwfL3sQkNZl8GhH22iyBaO6dr/bjyl0PLxRMx1altWZr1Iya3nIpucFRLWgJtZCrh1Q+rhaTy3t89m5hjUJnTuDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XuE56tWq; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749694192; x=1781230192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UAAqUsYtY2HDVW9S/4tyS5IlVW4alCQz4TL31v371dA=;
  b=XuE56tWqx9aU9+sqoC6hfudBWsLv0G4FKnAkHpv7nifWgJxhuBpQ2pMz
   AIq5uCTr55OHi38ylFv258s46ja10uznLUjnZF860eZ1IxOycZCjSX7g5
   roWWbp1JmRxa5jqzGXJI+zh2y05k2ZFE8cNPJOihtmmxzezrFTjzsZPDl
   iNwBiLiJRFlL3HUgy/jyvpppqlTks5nuERxTUp/rdQJ8XQWVffyDevFlo
   gpFP3/8yWgJo1c/aPPfNILe3u/Tlie5V4XtxkNPVAigEjc0HSVAJK6i2L
   Cl/KutdbD5eZaiGTke1nob+gtMYurCGXavkmzKpp2XhKA+WH52RDq0iSd
   A==;
X-CSE-ConnectionGUID: O3RQUhbiQt6/sD2QpZk1zw==
X-CSE-MsgGUID: dYhwr+bMRPKgQBYgrpQz5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51075508"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="51075508"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:09:51 -0700
X-CSE-ConnectionGUID: vcGi6YwgSGWcSImxnbTEAg==
X-CSE-MsgGUID: czFQDdiJQXiydotIsv3r8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152266423"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:09:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:09:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 19:09:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:09:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+p+jfVktZ8Y+S0aWsdh98hTGh3yKm4x/T/q3SV7vSxLI+gsNFFwC/u8roE0+KefiKeVMIdRq5C7NS25/JhlO5DtpsWY/XM6INfMy30eFKxAJVJwCNFxsDltxYzHscY6dGnbd3FlBPFcaHDOXT8Xw0mrKwhc++hV76m+yv/vod1PAPr1UbNtv9J9dRFeZsTenxsOhoPgCuAhJEkh4QE0jPUSSNAUjKFT19FzRJWmPaqL9DiEUk3QLVJctJiEy8bYkcP8gb2bGL5vN4tLzJrKhqzpExdHjsDEecyoCTv0Hw76lVWH3FLsgTUvz7ZjeWqe/QXIE8/bVH9zT1brb0NDUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAAqUsYtY2HDVW9S/4tyS5IlVW4alCQz4TL31v371dA=;
 b=M4bgCcb6Gv1hUF0VHHq4/iXKp+l0REe9CUjNgufRMBgCTdpJRlAW5o9HIPtKJ4XZWh8FBAggmFQ9BbcG/2qcSZRfzXM+G7aC/evp87dsH27ErnjVpKBGflmNIhXWQWEZ9pxJ1uyMIvp8Pg3iSvh+KM4pqT3qJ1ASD/OvE9ARD9eCl3nvlLFq+lPDiH07t0/mx9+YgJha6eLMYRC/LhaqIq0yMum0zsgXi2/FlezL7uUIG70Qu/PVtGreEWpxmBKwy9gj1qBYQpne7YWtBfC+eyEp/4/LuBkTkxrnZozohtwQqVJyHhYdiWmbB9XIXGVrPdBF5jjMm+H+dLizeazRYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BY1PR11MB8031.namprd11.prod.outlook.com (2603:10b6:a03:529::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 02:09:48 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 02:09:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/18] KVM: x86: Move PIT ioctl helpers to i8254.c
Thread-Topic: [PATCH v2 05/18] KVM: x86: Move PIT ioctl helpers to i8254.c
Thread-Index: AQHb2xjjURDqJ6/fK0Wd6yOfF3Ih07P+x+wA
Date: Thu, 12 Jun 2025 02:09:47 +0000
Message-ID: <c90e3ceba8a47b2139e3393c44e582c5a7b7d151.camel@intel.com>
References: <20250611213557.294358-1-seanjc@google.com>
	 <20250611213557.294358-6-seanjc@google.com>
In-Reply-To: <20250611213557.294358-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BY1PR11MB8031:EE_
x-ms-office365-filtering-correlation-id: ea9ad66b-2e62-42c6-f621-08dda9563507
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dEZFNmMyV1VKYWM2d0U4bXVVYytmV083YThQV2RzOGxhamx6OVFTSEpDY0sw?=
 =?utf-8?B?V2YvdWV5MnV1clVRalhnSkdJZmFFeksxTnhwQzd3VVI0N3lxY3NaTFEyZnNE?=
 =?utf-8?B?dG84TXVBSy85YVVRaytzRlZGRC9JSG40TkFTL1hpUWRWQVkwZDhscVFKdksr?=
 =?utf-8?B?UEl4TmJlZnRWR0lBK2YvTXpDUGM0ZmlQd2ZHVk9pcDhjNXg0TWRPalpIckZv?=
 =?utf-8?B?RThCVkJ4V2NoR2ZhYW1OR2pLcDFJeHZwRTJRNjAvTUFua2JBOE5tL2M5N29C?=
 =?utf-8?B?NElaUnEzazloRjhRWlM3cWE1dkpuTE45SWMva1l3T1daNFpORm9hNDJ5TWRU?=
 =?utf-8?B?QUZPejFSTnFZdUxCTzNRdHRkTVZ4bGlqYlcwQmprcnp5K0ttMUw1dlhMa2tr?=
 =?utf-8?B?M1JDZEN0KzA3d0ZYK3dROUtDdUh1WFM4YjMzOFZHWEdla0Fjc3pjMWJoK0xC?=
 =?utf-8?B?blZsdVZiZkJUdC9scmxXQ2IzWndubk1WUlhVRENTU0VIbEZjOHlYR1RvSk5n?=
 =?utf-8?B?WEhRWDJGUFNxSTd6UGFRZEh1MDBpZWVoekM0REhUS21lZXdBeEtWalYwRWpu?=
 =?utf-8?B?VXVEWnJxenE5Q1pLYktMTk9lQkhUUnlMN3VnT0RuTjExUlFFOGJYcGRNV2M1?=
 =?utf-8?B?S0lkaWJOZFl2L1VBNjUxakRDY1gxeWZGMzNZNWQzcUVXRXdJMG1BZkZ1alN6?=
 =?utf-8?B?em1nQW5LQWIwZC93VEdLZnN1QXNXSVVjcXRsSUh5bnBveVh0ZTJqMTNncDZl?=
 =?utf-8?B?Q0N2cHVEc0lkOEFZL2EvKzVZTC9QeWNRMlRrNjA4SFc1dlNlRkIwdUhSMTZn?=
 =?utf-8?B?VU9iaElMNkhXRTNaRGZjcmVhTUNFNXJDU1hITUlxUmZxSytWL20xUzQ1c1Ez?=
 =?utf-8?B?cStmQVgvb3hjdk5WTGtPV0tpaDYzYmwvVlFFNXhUUW1kbDNmTG1zTS9lUVFV?=
 =?utf-8?B?THBJYlNGektCSEF3QjFWS2dlOVkvSVV3SnROdE0vNFBDR2lGR1lCY25JK0Fz?=
 =?utf-8?B?RnZoSTIrQS9uM0xBUTcyNmE0WGZXRDI1eHNXbUp3Nm5FUmdpTGFoYzVKdFZt?=
 =?utf-8?B?a1lLU2pRcEQxMm9UeFFRTlBYK2V1WXppcDRUTHo4UHVjTDRoSkNDZnNESnRv?=
 =?utf-8?B?SDZhNUtsNTFzVllrVXNjR2U5NVNPbis2NnlTKytDaGhlM0c3bXVHckFOZ2xD?=
 =?utf-8?B?MHNXQjFjYUREbFJ1WGtCTHN2cUxsRWUrSW5xTUhIeUJ4dmlhRi83VFdzcDNC?=
 =?utf-8?B?aXNYQXpGSjg2UGtjYTJzUUxUZVZJQWVYU05KYkxQYkRnMGY4QTR1SHdrVVNN?=
 =?utf-8?B?cWNlWHVZVGRvOWVyQnA2VkIvUnZDcFJiZk5QUzdTYy9xZERTT1hmOVdKbHpr?=
 =?utf-8?B?SVBiSitER2F2TXJOKzBRdEwzVHVZaTVEeGpvVEEzSnFoRG1lZVhlNlRjbDBM?=
 =?utf-8?B?d2EreFdWcDFOak5NM0JLdUdlNFBlcWpFYkNxNXE0T0hlRmVtTFFUQzBCMHJ0?=
 =?utf-8?B?MmVXZkdYSmtHL1J0K3RjQkkzVllISEt6THJCU3kvQmpGVXdYWXRpVnZCNExs?=
 =?utf-8?B?OTk4YkxnY0RoWVVXMVZ5WGpPRTlZbVJBREZxdHBTcms0N2VVUlQwaGo1ZFdu?=
 =?utf-8?B?RTl3VFIrcUxtTWJ5YzliWlNaWGkxWGdMRHVXMHNTcytTUWFjeUlHS2RqOUov?=
 =?utf-8?B?d2RYZUE3NUVkNWV5b3lxejhRUXhhSW5GOTNiN2JLd0xTRERNL0FQTlpYZ3hJ?=
 =?utf-8?B?bWlOb2RtOUxTSzJiaWR3QStkNjBoU2hpSDZEcGhYSjgzamRBZng3Qyt6VEow?=
 =?utf-8?B?dkRFcmk5cExvSFJiWnJ1c1pGWjVJMGk2eHhKT3AwN1NiWmxRajFWWDJ2U25v?=
 =?utf-8?B?ZThFMmtuVkljQXF3bnJ0WW9rZ3REN1RuL0lGUldOQ3dPUVJtdUJndFdoVlZz?=
 =?utf-8?B?SFBkN1dmamNkK1UyeGF0KzZ6UTIyMGdiZURUZEpuVHEwK0I5S1hwUFNRam9h?=
 =?utf-8?B?a1E3eTRLMzBBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU5hTVNhNlZ1RFB1STlacjR5cmlMSjd3ckw5YksvempFdDBYVEFUS2VQRWtB?=
 =?utf-8?B?eHhDSmRYT0NuTG5Nd1NCYU5oQXh5UVQ4Y05maFZldHI4UmxVR3dFNWhjMlRo?=
 =?utf-8?B?c2ZWR0E1aXVDZnphc3FubnpxM2tsYmhEb25UNXpFbWY3YkpTSlpjNVlwVlox?=
 =?utf-8?B?Uno5VHB0d3c4MGZoaHY1KzhFdjN1bW1VT0ZGZUIrMGtQSFhvbGtuRlFhakdw?=
 =?utf-8?B?Yi90M3llNDYwM3hPNUlqZVN2eXBGcjhoNkpHL2xpKzdzTGU2aWx5cURhNEcr?=
 =?utf-8?B?VHpOTUs5TTdmWkM0Tm1UdFVDcVhOSWhXMnBtWnFqaFVld3IzdVovOXRhN3Np?=
 =?utf-8?B?QWhacStkVFpxcnBIV1lwS3ZyVTl3YituMnVtYjdYa2o3RTZRb1JvVEdyK3lH?=
 =?utf-8?B?S0w3dHNISVRjdEFkSDNuT0Y2dDk3TUl2UnB0dUg0UjkzNDBnMjVMRGlSVHl4?=
 =?utf-8?B?VTJ6TEp6Vmt5NHpraitPUW4zOEFkYzlRcFFPOVRhREZzTUhHZkpPMUh5alUv?=
 =?utf-8?B?Y05sM1NlRm5hbzh4dmkyMjBUR3pUWnhjZno5ZXNrdXF2R0UwR1FpL1Z1a1NX?=
 =?utf-8?B?UjhQSHlqS0tWR0tIbUUvaWtSODRsYVVyZmdWUnpiUTY4SnhvNEhGQVY3cVhr?=
 =?utf-8?B?WjFkR3F5MFhndktZNlFjSU5jclBma2Y2OVgzRlhNZlVRSEw4N3JITEFVM2ZP?=
 =?utf-8?B?ckVqckIwTUVRclgxdXQrU0V1NVNsanV5NmE2eElaSk5IZDNpLzdKRCt1QkNu?=
 =?utf-8?B?Z3lWQXZkK0U1dkc3ck1JUzVzdzVNcldzYTdwakIrR2dCbzJuUkxRbVRNUVdi?=
 =?utf-8?B?c2NnSnA0bTJYWk9TZklQaGZuUVNLdExZSGUrOTJzaUx0cFYrWnZXL2lOSjNs?=
 =?utf-8?B?RlkrYlZpK3NZanZQUHRFamx2bmg1djJIQ29qZ3Fyek53MlNXUGRNNnFqSmFD?=
 =?utf-8?B?SDZ0TzhsSWJtUnB6ZVdwSmpxR0QzUEpodzN4TlRPckRoWGlOVDZGM1E3LzVB?=
 =?utf-8?B?dFE3RWo2VnZLeGNLQnV1NEtkTmoyUzJORlg2azZ1OUJJWkwvbStHdkZZRTBi?=
 =?utf-8?B?ZHpGdC8wSmh2cC9qTkdnMGdNVVp2UytlQXZmSHJVVFhwWHFQaThZR2RiT0VS?=
 =?utf-8?B?d211TkgxNkgrcDJSSEMyUFpLbDcwUy82TEQrdFJPQXdmbmgxVnlIUU4rMkdI?=
 =?utf-8?B?L2h3RnNIUUpoenEzbVJFdXNrVE5PSEZFSkExVmphdUQzYXFaeHpXSVlWMHJO?=
 =?utf-8?B?eEd0bUN0TExGblcxY0RIdmFjY3RHakNvRlFzWlR4TVVORThORXZyakoycXdw?=
 =?utf-8?B?bHlKMlB3NlZPemorU3ZRc29VNW8xbEp6OWp6djJuemplOGNldVdPTmY5NnNH?=
 =?utf-8?B?ZzhVVXhrMDJmc2MvZVh1eVJUa0tqaFd0VXZXNm9Rc0dwT0hVSjAxY3F2bEdS?=
 =?utf-8?B?bzBSV1VBQzE2cmtXczNNZGZxZGJuZHQrWUh4d2VlUndQYjA3ZXFuaXNrSkZn?=
 =?utf-8?B?dmFlMEV2azROMEIxVmNISWRIU0tCbWJIZlo5T1A0cC9EWkV0V1JPR2VJbjZ4?=
 =?utf-8?B?TlR6SFlUZkJLeExiSDJGSWVjZm9oWVNveG1rd2VFS1J6YVBtM0pZTnBQOGYx?=
 =?utf-8?B?VUdTTDNESkJDK2xjR0FwYytOTkE0a2x1S0ZjckpRN1hLeVY3TXZTMVFOQ2ts?=
 =?utf-8?B?TEtvZWFwZzBQZVZJakN6aVBGV2NMbiszR2NDTllNcThUZllFdTcwVThFWFdh?=
 =?utf-8?B?NVFJeEN0bGgzeVNuMmRFcVpmUVJsaEdQdXBDQ0JlL3ZLSDRkTFNOdkR6MDAz?=
 =?utf-8?B?OUZSaTcvSFRyRVVXVys4bysrd2FicW91ZmxRTTRuaHZaZWhQKzI5Qy9oQWp4?=
 =?utf-8?B?cndCZWluU21wV1FxWDNodXFqRU4vTzRNdnJjMjhMUVFaSHQ0SDFRcExJV1Vp?=
 =?utf-8?B?bHdNN0x0SGpZOEpnYm43VWp3RCtES3ZKbEhJWFVqU3FzV1hScDZURUtIa2hu?=
 =?utf-8?B?M3M0ZGcyQmVKNUlKUTQyMnYwYzFzOVVyTmg1ZkxYUy8vUDlVc2UvT1QyZlE3?=
 =?utf-8?B?M2NwamRRdER5YjVMZTVJMXhtNVkvNno4bFBjZWNNUGZORVhJaDJPdEE5TVd5?=
 =?utf-8?Q?hXYJBTUAPXptvsp8beVss4XXY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAF42AFBAF9AF043835051580D31D35F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9ad66b-2e62-42c6-f621-08dda9563507
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 02:09:47.7908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l0a4lNE8U+E5EYLFDxL3szngvfZ8+aOojxdTKDhYyXHkCFxxFhO+K/fGqv2dllNt7hKrqE579c5zPpL+HC+Yuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8031
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDE0OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSBQSVQgaW9jdGwgaGVscGVycyB0byBpODI1NC5jLCBpLmUuIHRvIHRo
ZSBmaWxlIHRoYXQgaW1wbGVtZW50cw0KPiBQSVQgZW11bGF0aW9uLiAgRWxpbWluYXRpbmcgUElU
IGNvZGUgaW4geDg2LmMgd2lsbCBhbGxvdyBhZGRpbmcgYSBLY29uZmlnDQo+IHRvIGNvbnRyb2wg
c3VwcG9ydCBmb3IgaW4ta2VybmVsIEkvTyBBUElDLCBQSUMsIGFuZCBQSVQgZW11bGF0aW9uIHdp
dGgNCj4gbWluaW1hbCAjaWZkZWZzLg0KDQpBbmQgaXQgbWF0Y2hlcyB0aGUgb3RoZXIgKGV4aXN0
aW5nKSBpb2N0bCBoZWxwZXJzIHdoaWNoIGFyZSB1bmRlcg0KQ09ORklHX0tWTV9IWVBFUlYgWypd
IGFuZCBDT05GSUdfS1ZNX1hFTiB0b28uDQoNClsqXTogIFRoZSBrdm1faW9jdGxfZ2V0X3N1cHBv
cnRlZF9odl9jcHVpZCgpIHNlZW1zIHRvIGJlIHRoZSBvbmx5IG9uZSB0aGF0DQpzdGlsbCByZW1h
aW5zIGluIGt2bS94ODYuYyBidXQgbm90IGluIGt2bS9oeXBlcnYuYy4NCg0KPiANCj4gT3Bwb3J0
dW5pc3RpY2FsbHkgbWFrZSBrdm1fcGl0X3NldF9yZWluamVjdCgpIGFuZCBrdm1fcGl0X2xvYWRf
Y291bnQoKQ0KPiBsb2NhbCB0byBpODI1NC5jIGFzIHRoZXkgd2VyZSBvbmx5IHB1YmxpY2x5IHZp
c2libGUgdG8gbWFrZSB0aGVtIGF2YWlsYWJsZQ0KPiB0byB0aGUgaW9jdGwgaGVscGVycy4NCj4g
DQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KDQpBY2tlZC1i
eTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

