Return-Path: <kvm+bounces-47518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73746AC19D8
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D87F3BF341
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4A2205E26;
	Fri, 23 May 2025 01:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHXvL+Kk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F052DCBE1;
	Fri, 23 May 2025 01:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747965277; cv=fail; b=aSPODHv9zmlAIRHu7JnM09VwCK2A2ZV7WN9HpL7F3e7ypf5fSrQRG8geShSAjUWi3OKOnY9CUwGQaW+RBfZAFLtXAGPfG3ahb0VcOyHIM/VD4ceqnIKyEuCjW1TxLUaLcOhXLLJa80FSgBgA8CwT0+X3u7ATDSvH134iOcnhpak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747965277; c=relaxed/simple;
	bh=u3PrZlMlOt5hX+csDDVvgbeLG1A/gLCK9YWFbJkpB+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XBcP+7ZWCz2j6wDM6UbQg62n6T9rTZrztsMnsjzzlxrsLh3EcBMDftXPUa6PJyXyPfV7+rXXVgG/e0LmWxol+4NTfgd+0jlNgr6mfkUXqe6cvz3tF/rVu+98DUvUuzbxDkMTg2/L8x0nkpb7E1w9hQo/gM3JhzXLa2fMEkCIujM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHXvL+Kk; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747965276; x=1779501276;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u3PrZlMlOt5hX+csDDVvgbeLG1A/gLCK9YWFbJkpB+0=;
  b=HHXvL+Kk0w2qitMMGMChZqmrmTjgV7syHibbgj0+BrU4UZpoRMKM8QGm
   nmh4g3sEr6ECgl6t5RFXgMWJ9WFGgKBvZWYnwN24SHwTeN8bd2R8QuU1B
   9ATZNWIehXspL75yh9GPSLlg8VrVWIZwL+V6HfQVanMba84f8aBzjvm1c
   g8k3Kns25QaH1HkfPBdrMngs9OIEdQC5Zh0YksXdVralzcT9T9MV/uQE0
   VLklpcrB0GCDG9h+qVk2QOq2CYF9RlsBsQsNoRcLBvuHW0UnkirAHdP1D
   Bm4I157aBbQNnIkiBD15AXhdBTA2/qj2f4CWqj4Tn83hx+ezH9e6V0z7X
   A==;
X-CSE-ConnectionGUID: 5o5Lr4xrTV6V5sEMeb1MDw==
X-CSE-MsgGUID: iI26Q8aFSiidmmA9cz1bqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="49935247"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="49935247"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 18:54:35 -0700
X-CSE-ConnectionGUID: XkmGSdi2RRSJpltJ4OpSmQ==
X-CSE-MsgGUID: uRBooptkQW+bhlGtQj+p+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="178009661"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 18:54:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 18:54:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 18:54:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.71)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 18:54:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H9/qojOtPF4F3xiiH3QnqJwCrJkVsAdMvK9Yj47Lwrv8R4KHezEQ050jVHgU8Z08otn8aYI7cnIYTCy9NcvzLScv1OxYF0Y0f7gB39m9V7SxnyToIa0fzlowCZPykmZqZKnrpJ4nUERfaX4oI4N5Q9cNgZfh5HueoXCVyUlQEX5k9x/l15lPSfvVVXhYtdgVy76I5mggQmFdMUbScJ95dHL817FQ4JMLXF+V/ETqcSAZ/Ljqlp5j8T5amnnNNz0RyS4Pj9VyMfOlz0Hi7Nz+8Lm9D/7fAXe0adt8NCvN0T4q+4wvIf8Pb6oSLzv5pDttfHRyB8LVIY4OgvSLIaA2Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3PrZlMlOt5hX+csDDVvgbeLG1A/gLCK9YWFbJkpB+0=;
 b=qAsqUAdkIazntC2NnBkqH/XWI/08fQmY453gkw3J+t1EEldC1577PQsenud6oyBGkFBBbjZjeo4BRU3G0paP8RrCeNBw5vGSCF0k/414F0xKXX5xKuRxgkyQwtH8o9WMWfSK22g/mckVduphwINKAgP/tTmZh3VKHcJNXaBwaOTm/EJmvCYZStB2Wl5ObmnAzghC/ebaV+2IvawgaOSPLYbc89S6sQIevCN9JY4JDMCmYmUdA2pUAztWt1Y3I/L9wm8rqBjijDpPzjBOOBViVrCddNotArQE1T1QjHMtubEySdIQDiRSvhIeywyXeOSNJHf74X2SAPRs5Dp2R/UuGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4594.namprd11.prod.outlook.com (2603:10b6:5:2a0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 23 May
 2025 01:53:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8769.019; Fri, 23 May 2025
 01:53:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Binbin Wu <binbin.wu@linux.intel.com>, Yong He
	<alexyonghe@tencent.com>
Subject: RE: [PATCH v2 8/8] irqbypass: Require producers to pass in Linux IRQ
 number during registration
Thread-Topic: [PATCH v2 8/8] irqbypass: Require producers to pass in Linux IRQ
 number during registration
Thread-Index: AQHbxrdi0rnpiDa3lUmxzoAePa1G5LPffYRA
Date: Fri, 23 May 2025 01:53:49 +0000
Message-ID: <BN9PR11MB52767C806F7FD5220DB5D9B68C98A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250516230734.2564775-1-seanjc@google.com>
 <20250516230734.2564775-9-seanjc@google.com>
In-Reply-To: <20250516230734.2564775-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4594:EE_
x-ms-office365-filtering-correlation-id: 192c6859-3e2a-471c-c5da-08dd999ca959
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dFNSVHpPYWdDNVlpVStkRC9nOEZYS1hJZ1I1enAzQVZUMk5KYkV4YjVsWUlY?=
 =?utf-8?B?L1d6NlB2M2JabFQ4NGZhSTFMWE8vemZqNFhndkxTZ2tOTFR1OERDaWRMck5i?=
 =?utf-8?B?Tyt6QmNEMkloaWZtWWNkMmlHem5RazZtQTQvdUFuVzFlTEJjYzVtZHlHK0Ft?=
 =?utf-8?B?M3ptUkwzc0FyWWp5OFlFZ1AxUCtmK1doRGs2Vmcxak5nOHpkN2FPd2ptZFov?=
 =?utf-8?B?dnFka1k0T1VUMWtraEsvT3grYk9scTJnQlBTa05hS0N3S1NTczM0WGVmMTF5?=
 =?utf-8?B?TmRxS0o3RjlmK0I5Y2FzSGFXSFp4VlNTSXBNa0lDNG5tSFVISzYzNGt1ZDZj?=
 =?utf-8?B?YXRaQ3VZVGZ6ZkJKUVM3N0V3elNqYngxdktTeGdBYUFRNzFYRTczdHBDSVl3?=
 =?utf-8?B?SCtHWjR5TUVhTFpkSWFLSFFwNzFLdmx2QjR4cTBQS1hwVXNOdjQwWVhrUHVk?=
 =?utf-8?B?S1puQVA1aTNVZnRZMWwzcnVSRXF6WENrQ0lneGIwQkVKVTUrNTlBc3JzMC8x?=
 =?utf-8?B?MUpCSURyTlF5cHNwZXd2YU9xMDZpOFRNQnc4U0tIQ3o2Rk5COWZyQlpFUjBp?=
 =?utf-8?B?TERETXVlbFU5Z3BpYnN1SURvS085YlhEdC9SSjNZNmtEcnNTZDZ3MC9xQTJn?=
 =?utf-8?B?WXpLZ29wOURCM1dBelpXT3dqcTFOR3VQTDlDRXFUU1JHaUlFL0x3UDRKbmRW?=
 =?utf-8?B?eG5YaFdQSWVXM0tjcHJTbnRGeTBKejJ3ajhjYkJBbHg2emVtSWxHMmF2UUxU?=
 =?utf-8?B?REhoRTdPUDhVQjNJd2JzZWV5SWViRVkwbS9pVWFSTk4yWDlxRkdsc0VPZ3Vh?=
 =?utf-8?B?MW1MMWwzYm9oSThJdm1LallKQXNmV3FzaitvY3JVbGxsMUxPcUxvRHZ5M3RL?=
 =?utf-8?B?TGZDOEhPWXdVWVovL2tPazhuQ2gva1RoWGR2OXlxSjcraFBLWGhWVFJXRDJF?=
 =?utf-8?B?dEczTXd5c1haa0R4NzlYYlcvK1h2d01zVGF0OC8vTXBoTndRZ2tGSjNyNkJy?=
 =?utf-8?B?Vk1LRzJYc3ZwdmRzSkhUL2tveUFCcS9jL3NCdGJnaGg4Q2JrcWErWkpINVB6?=
 =?utf-8?B?TG9rbVN5WUJrTTZJL2lWcldIL1VvUDdYUVh4amJsVzBFS293QkN6dFRQZ3h0?=
 =?utf-8?B?Z3c5VXZ0VTdHUWJNam95cHlTNmE4SFZqNXdYSFVrbmVSaVJnY1FPcmdkcGtE?=
 =?utf-8?B?RUhhSFhsZjlPM1dGOHl1SFJOc3R2TlV1YVloWTNobzl5K0pBYUhXTWlTd2RW?=
 =?utf-8?B?Ynh1R1ZFMEhCa1ZlMUQ4QkxUdWtrekJQclJmRnV1TXltb0kxbVVvSDNiSElT?=
 =?utf-8?B?OHNNN1htOTAwNzdpaFpvMDU2Q09kOHBKSUlpNEp0QmVYblhyWWtlTWJnb1ls?=
 =?utf-8?B?c2ZQZldRR0Q5UnZLZjBETUpwaktreUJSOGI5bEJ6WCt1U2RJb3pLYm80Qk9i?=
 =?utf-8?B?UGRndVVjSlhJSWtBSzYvT005SUw0bHpvM2E0OVE0VWpYQURxakpPc0d4aGFp?=
 =?utf-8?B?QXNYR2VqYWhOajdMZjB2MzUxTjQrTjg4TjBNZS9BUTk5RlM5K0RlVG43NVVw?=
 =?utf-8?B?OElTY3ZncE9qV1p2Wm9Db2RkVW5CVDAzd3c1eGRtS1RneGNuenZHMTUrTWln?=
 =?utf-8?B?V1c0ZDBxRW9wcUVpMFY2TEErNXplTGVocXZSaXRkdVN0TVpNVFZEZHZUVWF1?=
 =?utf-8?B?cjBCclZIWkM1eWJEeFpvMVB4bEorMU9zN0lhSDBtR2R2OUZnRFB5OUxSY0xz?=
 =?utf-8?B?ZUN1d1JlMkJrRzRacm9XZExoWXVkclAzenU0T2RuS1VBeWJJK0cza2QvNUt1?=
 =?utf-8?B?MjhCRzY1R2Y2bURia0ZkNTNLbCtQR0h1WnR2TkpNK1ltVVo3VE5yQkZkY1B3?=
 =?utf-8?B?NFJIN29JcndOSFlpL2FjRi9TN29HMlQ1NVlIU2o5NkNJYUR5MGExRjJZNEFD?=
 =?utf-8?B?TUZYdEtLMlIxWGJ1Y2ZjZjZYVjUzUE9VT1VteUhFbEZZV2V2V1Rxd1BoNVdV?=
 =?utf-8?B?d3ZubE9VWGNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzdDMXZWM0I3WGVSTGM2UWtINi8xc2hXNDhGZmN0enhNY2UzdUxndjc3cy9N?=
 =?utf-8?B?YURnMGtTR0pSZEJxWjl0bjFMMnMrZlNpNUZxSFNCOUlkNnlkZWVuUG1xSisv?=
 =?utf-8?B?SVhrK2hDTlZvVEdUL244V0dEei9ITTVoN3N5NG51Q1NlVTY3a3JwNXZXSFA5?=
 =?utf-8?B?WnNSM2U1emN1ZktJQU5FZ2Y5d1FJc1BlVytaVEcvL0wwcUx3UjdXYmxmekg0?=
 =?utf-8?B?bU9EMDRsc0NtNjZSYzdMRzFtYUxzdUllTTlSUE5OUXJxVE5FNERDdWRBV0ZS?=
 =?utf-8?B?Y3dtdWk4VlJ0ODNkbWN0NmMzNlR6aTRpTHVFUndEbWZMSFIzb3pudk9yNHo4?=
 =?utf-8?B?M1ZOUmM5NHhMUlpzeE4xa2V1ZE90TTlTWE9KL0NsUFBiaE5haUpxYXdNRTN0?=
 =?utf-8?B?SzFYNnlTL01MdERjdldZRU9Gb3JWWGtIZGc2MmFwVU5IRzQvYWVVMjRib1Y0?=
 =?utf-8?B?N1l5R1d4K2ppMnU5Yy9zNW9pM09nTXM3S20reUxHc2kyMHBZUEM3N2lLaHlu?=
 =?utf-8?B?ZWN1YjB4U0hVbTFpTE15OFVSQ1VRSjA0cy9jQ0ZaMm8ydVRFR0IraGc2Nkc1?=
 =?utf-8?B?MjUyN0FFejF4czErQ3kvbEdCdGJuRURsTEE2bjJxWG5ZQ0VrZjNvYnFzMlBm?=
 =?utf-8?B?WThVOEZ1LzJqWTVhN3g0blVoVEVQVGxMTjhlWkhJSm16eE5yNnp5SEJiQXJt?=
 =?utf-8?B?RDJxYmUxdEErNnBveHl2QzNrUzd1ck1oSUc5ZnZVbmsxSW0zQWVIRVVZUzIw?=
 =?utf-8?B?WDBVMHF1UitRNjE3ZXF2bEZKdUNtVWIzQkhpZDhKRnc0MGFnQjJTNTdlNnVj?=
 =?utf-8?B?cXFwME8xTm9XZTQ4Z1RVeVVnaHNOdWdSa25zaUxIeXlqWVpidFJ5enRIcm44?=
 =?utf-8?B?Z0VhM1I2SlRFS21yR2x5UnVTbUpYMnUyUmxYVHhrNXZhYllaWk1zWUpOaUdD?=
 =?utf-8?B?d2JzNk45NC8vK1pWbldPZCs0eUFjeUhodm9RTjY5NUg5N0hUb0JHanJ1eCth?=
 =?utf-8?B?U2F6MEF5cHlDWVBpRnFEQmw2Z2N6bElWd0tZREI1VW1pbXJGZkN6dE1Rd2p3?=
 =?utf-8?B?akJNSWJyeWh1MnRqQXRjKytDa0NIb0ZRdURLeVZxTllqSU1MWm82eDRxb1d4?=
 =?utf-8?B?NjRLV1lIdzFySkM0OTFBM25yR2E5SDVxakV4aGZPeEU3ZEdqRFVXejVJcjRK?=
 =?utf-8?B?bW9yRk1nVE9lMTJ4WUI1UllseXFPTkNCUEpaakxmS1R3eXZvN1A2UjYyU1pT?=
 =?utf-8?B?Y1d2N3l1bk1kMVFHa1lEMXM3QUZZLzA5dXBXaWJ6bkJyMkZFSUNJYUZrdzZh?=
 =?utf-8?B?YkhueXp3V0RndWVJZFUyQTlJQ1hZQk5kZ01QQ3VSY280aTB5emNsOHRTUm9q?=
 =?utf-8?B?KzZTeGdKVCthd1AzRUNUdjZKRnNqbFJGNExnRDJ1dDJaNEhweW1KK1pyV0Fp?=
 =?utf-8?B?UWlOTlhqV0xLSG5za2RGYzI5S1JKQk11aUxuT2FSNno4QjhOL3ZLcDVUNnNv?=
 =?utf-8?B?dm5mTWJrK0UyRXRNS0NjRmJTT1dpVDd4azlDUGdMWERwTDBNTGxveTRKZTZU?=
 =?utf-8?B?K3M1ek5OdUdWME8ra0o3eGYwWFZIdGw4QytJR0Y0bjYxZmZmdDk2eDI1UFJE?=
 =?utf-8?B?ckZKU0JEM25SY0ovWTZvNGpJbmhWd0hjV0RremNwVTBJZmxkYjdNM3BhS1pC?=
 =?utf-8?B?YVFSNzVHQ3U5QlZ3NG5nY0Z5WmZlT3VyRG5sclp6a3NMSWFCNXN2K2xwdU9F?=
 =?utf-8?B?ZGFDb3lHcjV6cXFZR3grU3k3ZWtsOVo1K3pOMjY4K1JDR1NvN1pxZ1FiUGV5?=
 =?utf-8?B?cTlJSWt5RFE5MEQ5ODlDdTJxejVoTWdETTV6c05kekJIblZTVXJJbURIMFUz?=
 =?utf-8?B?bXR0Z3Nqa0x4KzZtd1VvS0EyVnArd044TisyMEkvRnRMb0VSNnN1YUlydzdE?=
 =?utf-8?B?NnVYREtBdXpSK2s3TlM3WXI1OFpjQkg1dEJHR253TlhYbkJtYlVob3AybHpl?=
 =?utf-8?B?YjlTY0p5NWk3SGRoeEpveWQ1S3JlUU0xTkRHWGovUmwvTndwdVU3Mnc2djd6?=
 =?utf-8?B?QVNGS2doL2crUGEvaDdiaHdneitqOVJDQVVGMXppRzlCenV5T2ZoTlk2U2xX?=
 =?utf-8?Q?FdvzT5VAadFMycu9+/3+JiPeH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 192c6859-3e2a-471c-c5da-08dd999ca959
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 01:53:49.1595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ToTlVSvjTQlFG2TEgPxIa5SJWwIZRwlhMNZ6Jwv+uAjM0TCJeg+wHN4KwZIBcdqN17Q3aB1Db6AoB29J0up3MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4594
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIE1heSAxNywgMjAyNSA3OjA4IEFNDQo+IA0KPiBQYXNzIGluIHRoZSBMaW51eCBJ
UlEgYXNzb2NpYXRlZCB3aXRoIGFuIElSUSBieXBhc3MgcHJvZHVjZXIgaW5zdGVhZCBvZg0KPiBy
ZWx5aW5nIG9uIHRoZSBjYWxsZXIgdG8gc2V0IHRoZSBmaWVsZCBwcmlvciB0byByZWdpc3RyYXRp
b24sIGFzIHRoZXJlJ3MNCj4gbm8gYmVuZWZpdCB0byByZWx5aW5nIG9uIGNhbGxlcnMgdG8gZG8g
dGhlIHJpZ2h0IHRoaW5nLg0KPiANCj4gVGFrZSBjYXJlIHRvIHNldCBwcm9kdWNlci0+aXJxIGJl
Zm9yZSBfX2Nvbm5lY3QoKSwgYXMgS1ZNIGV4cGVjdHMgdGhlIElSUQ0KPiB0byBiZSB2YWxpZCBh
cyBzb29uIGFzIGEgY29ubmVjdGlvbiBpcyBwb3NzaWJsZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTog
S2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo=

