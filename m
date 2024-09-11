Return-Path: <kvm+bounces-26435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 374B8974728
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86A71F26BBE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404425CB8;
	Wed, 11 Sep 2024 00:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eT/a/q0Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A59223A0;
	Wed, 11 Sep 2024 00:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726013492; cv=fail; b=cNs4oNiDeaU8SYdsBBtJn7Z9xfblYyLgcQ0FjSZ1uYZ/Fx345RKXnu85J1ZXOTbXq4eCKezkQYRd6fwhQKEHKrTHW/AHUN+URidgFvGo0qjE08deS775sD3WskcLu05Bj5ZjKNV7w69ppVwC/jlWi7832eWwxm03d2g5z0hSPSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726013492; c=relaxed/simple;
	bh=SBXM3AGRyny18pjuhw57hzyRK83UjcG+3RWTLOd9TlI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nGABUzCzlw7+aTgAVFRRF+CpKJEqQP6eW2hG0Nowx5LVlSbUAU8X209cRPs0vI0tPuxm6SAMgw8a/d7OTvl2s3eBTM543CVY0IuBVeS0uOSI6QDrIGeG56ytPW23YWxeZ9B0WXs5aekYPVT3P7p/MdICqyEyYI6UndAW7l/Dm5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eT/a/q0Y; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726013490; x=1757549490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SBXM3AGRyny18pjuhw57hzyRK83UjcG+3RWTLOd9TlI=;
  b=eT/a/q0Y/4HghRrNDxoXUa7hd9QyKRXiUNjy20+LfTgGd4/Q4iHKM+OR
   KNII3KST6gOlMxGxZnlvVfGBbSJDeqWkKmmd2mzD3VvQz0PbuO9higAwQ
   zwI4SadaU/A0+eG7ji7VMjhqfDnB3UKN4st8DhyXYFFHChcQs7aYDZiOh
   cRj99URI1FVWIysAio5d/dQcds1pM6P+XTjudw6rPo/iMwrlu14wIesVR
   QKgzDRjJLyNIOtA42FzKVON3ZLpapx6Zo1uKmW3JAJR/nl/qkIVH8kd20
   07VhGBxvax1VuwZrwUg212o/jYi6Vhar1PJpMv1ORblprMgr4eBAG023h
   Q==;
X-CSE-ConnectionGUID: BPOVOH2hTSCI5WNwvzlKcw==
X-CSE-MsgGUID: rew7i6h0S66/oVUtXb6mBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="28531970"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="28531970"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 17:11:27 -0700
X-CSE-ConnectionGUID: Y+o94LemT/mGAJG3T8JDCg==
X-CSE-MsgGUID: cXveVOV2TyKhKV+STp9ijg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="67702787"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 17:11:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:11:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:11:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 17:11:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 17:11:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcTMmvMH+BZS+TsvN4QIo/XU/GzwuvSTzcV1MR05y2/Xsse/gGLwM0aKCUq3aFELV1LfyJ1V6AEBYgo4EccBBLbCP1TI10OfOgAHE0CExE/AiwEX2imN3HZDwuvdxmw3Ej1ILrBOZTg0IHzgvNMQmY0x0H/MDHs5QJeiQHYD9C/oK6c8AdH9FXAqzjY0W/Y2luCZSTBsqbR16Jt/xUiTxEZb77TebH47oBlYWs96tacGwb7jenA7S6dsX2AeXmEBQIGs09NLfMQv1l9Rj0Wn001VzbbsVPFbnP9vuPUdi+n7T5EiFwrNzJBCcyh9uoX6iBSKQQd6ZjLoYqNCjiaqGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBXM3AGRyny18pjuhw57hzyRK83UjcG+3RWTLOd9TlI=;
 b=IO3RLLcSuPgsgurD0M/DY+jziapz9GItnGQcpgr9tfhDtTzQEPd6K8/TuT2KT2ZIRKsO8vyz3CX3tWqAWslpftxyiTufJ1xN/hk3WL3sVSNQmEbVXIRKTU857xoHi9UqRfYOwD5/3QMmb7mCVYSF+214aVEX+505TlRTFfwikm1xCmsN7nzB4Ve19Lra2P+hcKBGSrGSmmLXUuKGDp/jxkw/U0dzrNrYzmbDexTnignz/Rll9icfGKZ2bKd4uS/ebXcuKjBuNBgy1zraa2y0kw/o+djswGmetpDFCi4c5pXNZ3yNcHI8tiAG1Ajnvs/Ra4BMOjoPVQa3ik+GfUPnug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7309.namprd11.prod.outlook.com (2603:10b6:8:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Wed, 11 Sep
 2024 00:11:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 00:11:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Topic: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Index: AQHa/ne7pTzhAEMIUUeBkR4uOlaw8bJHD/cAgACZDgCAA04TgIAF4DqAgADqAgA=
Date: Wed, 11 Sep 2024 00:11:23 +0000
Message-ID: <32695ba6af19f46fed3307bd363c96b35001e0ae.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
	 <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
	 <925ef12f51fe22cd9154196a68137b6d106f9227.camel@intel.com>
	 <9983d4229ad0f6c75605da8846253d1ffca84ae8.camel@intel.com>
	 <0feae675-3ccb-4d0e-b2cd-4477f9288058@redhat.com>
In-Reply-To: <0feae675-3ccb-4d0e-b2cd-4477f9288058@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7309:EE_
x-ms-office365-filtering-correlation-id: 8374d0cf-ba9c-435d-331b-08dcd1f64563
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?djdDMVZFcjJQRmpUVUd3ZkJHTi9Xc3NvQXFrWUwvYUJFbGd5d1BiVzZqSkxk?=
 =?utf-8?B?a2J3b0VGTXE1WExJTzhFcjZ5YjR0bUExRkJ3MUZZbjZERERDK09YYnIrZFZx?=
 =?utf-8?B?U2JEUEZrMDJDZmg1ZU5sS2tlUlhvajFNbjYvTlJaTldqRVB1V2VIRmxtSWYv?=
 =?utf-8?B?QWc4RFkrV1FIWGVSWk5MbDRMK01WR2FNcCtiV2JYblFneitOU2MwMXo4ak9S?=
 =?utf-8?B?N1l1Tmhlb0gzd0dxM0ZuQ3dSR2YxTUlHM2M2QVNBMS9XVEpMNEdVcjlaZkJH?=
 =?utf-8?B?T1I2Uk9rbzNMdVppL1pHcWJGS0U0dHJNQXJPSFkvUHB6SUdrbm1QNStUUlBo?=
 =?utf-8?B?SmNIajNFOEdLQm1YYzgrd2tsWThQbnhJZ0YzWGZRVXkrdDNsSWNqTTY3eUIw?=
 =?utf-8?B?Wk1EWHpKT2J4R1JkVUtQaHY4bWtuQ2ErbmpubG13L3lpbFQ5YXVzR3RVWkRm?=
 =?utf-8?B?MytJYW9ZWnZlcHBzeUJYb1lrdGRDVHRDak0wVEY3Q3llSDZjY3hGVEliUG1m?=
 =?utf-8?B?bEZlUGlsOEtwZW1TQU9RbDZYSFpPSnhZRHdZaktNOUNya0xnL3grOE5pVVk0?=
 =?utf-8?B?L0FIL2NId0JodGgvZE9BeGQrWmd0aTlrRkNyazI3Y0lCMlMxVzZNYk9UMHQ0?=
 =?utf-8?B?OWVRK1JMOXhaaHFQMXhiNHhwTTVWcG5xb2NXWkxMMDc5L3VNQWV2Rnp1YjVx?=
 =?utf-8?B?V3hKNFBtRVllQWFsMFI3OHV6OGRJeEsvQVZraG5PVENoTDZFOUYyTnowTS9P?=
 =?utf-8?B?eHcrSC9EYXNxZlIvWDZnanRtbFQxYnNuRWp5YjRDZ0JQVTFwbHBrcFY1QzlR?=
 =?utf-8?B?NWFPNTdPQzRwaTZlQ2lXa2FXL0d1QmdBSGRDSTM3K2hNVGYxb2JoVTNJSE9G?=
 =?utf-8?B?N1FtOEFWT3YrdjZsL2kyS2R1V1FvTlVxU3ZueUkvMEFJSU5DWmxydVFDcE90?=
 =?utf-8?B?N3NKU0NqbjhVa2NqWXJrZmoxRndRZU4yOXdrWld1eDI2ZG45VFVjSTIxRS92?=
 =?utf-8?B?Ym45YmVjQngwMVJXYmE5R2pFN2ExdSsvekRJbURJZDZoTmMvZkI5YkoxbTBv?=
 =?utf-8?B?ZzdreTF5MStWKzBwTVptQmZSdFIrd205VUJGTm1aQ2JkZUlzbU1XbG04TUIx?=
 =?utf-8?B?RWdwL2RBRlBCUUZEd2dLYUo2MnFyaitRVWpBTXhxT0FLUlFkbFhsQ0tDWkN6?=
 =?utf-8?B?alkyQVdkblFsSWsxWkxRT1VQK0txUGJ6SEd5b1VWVEd3Q09ubVF2YXVUaFM5?=
 =?utf-8?B?TEVlV1NQc0dDditndE93NjRwT3dTbGc2OHZiemlLTWVNUDNzdGVvVXFKRG4w?=
 =?utf-8?B?aTQzem1pRnNGa3gvTFpjZ0pWNWFob1FRaDltblRMZ1hEKzdPeEo4QUFSMlVi?=
 =?utf-8?B?UW5nVmJVM2tTdlF4TjkvUC9WckVBcFNOaVdqb2JBUmZqVGFNK0MyY1FwbkZ2?=
 =?utf-8?B?TXFlM1RoU1Fha1BzbWNPQk5qV09pcEgzandWUFFjcjBlOTBjZy9MbGVkYzNW?=
 =?utf-8?B?NSsvWTN5anN1c2JoNGNWTUo5L2hTVnA2TTFNREd5TFRRbEFXT3M3dlNraWc0?=
 =?utf-8?B?RmU2TzI0djYyY2RhNlRMK3BORnI5eVdWUHcyd0JRYkdMUmlsUTZuZHUzUlU3?=
 =?utf-8?B?K3FDTjBGSXIvcWJLU0cxUHo3Mkl0bC9pNUl0alh5UHVsR3JwUGp1ZE1QajhJ?=
 =?utf-8?B?eGpqaGFnWVhuUm0rTXRTS2V1RGxtVjgrdksvVE5zN3RwbUxPeHhDdE9HenNi?=
 =?utf-8?B?RFBQaFp2Y2lGbXpMYjZ4MTF4VVdsOW1Fa0ZkK0pMdk5uT25tMmhNVGpBbEVR?=
 =?utf-8?B?Snc2NEJWdlptL1B2bXBpcU1pRi9iYkJTZWc2Wkc3TG9GNTh0NDBHdmVZejRC?=
 =?utf-8?B?U05tekIxNkJsVEgybGgreUxXYTZOaHFkUGQxenlpZDlCVEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ampEdGFNMGRIRmxTZExrSzJRZUF6Z1NyMUkwaitrQXRaTGNZRm03MmpOdlF0?=
 =?utf-8?B?cGRxUW12Q055WHRLYlR5WGw1eHpTQ2NnR05YeVpjSHdMQUFNVG8vZUF2a1pG?=
 =?utf-8?B?M0xJTWxYVnlWV2N2NTl6RnZ0eWlWSU93YXovNDNMemRPOTFLKyt5czBJOU5U?=
 =?utf-8?B?eUhHK2xWRUdVS3lBb0RwVEt0TUZWLzBvZnJEdmRWU0l3c2xhR0pGYVZPdS9q?=
 =?utf-8?B?bk52R2ZkSm5jMmN2VmgyVjRTaTdVMW1SenNTbzhBTEZzdEUvU2tvaDE2SVht?=
 =?utf-8?B?STd1MTFRZnY3bVhQVFZIcDB2YkN4QitIb1I1STViRStmUFY0czJsbGlQc0ND?=
 =?utf-8?B?eVdXaFhZdW9rS2FpbGZERmxXTTZxaUdIVUxQSHhpeUxVLzkwYlhYNjBhN25m?=
 =?utf-8?B?UFo5WmFGNHN6U3BYbTlwR1BCOHdZVnRrOG5mc01xSlhWNEM1R1pHTG5uK29p?=
 =?utf-8?B?dmdpczQwUVVKRkt0QklkVURHVlR4ZE8xYXQvMktHTGNHdmMwUWo1TUd5dWpP?=
 =?utf-8?B?bHY3bmZ0alFUNUJlNFhRN042ZDFDQlUrcjZoOU11RGduR2pBRy8ydG91MmQz?=
 =?utf-8?B?eEduVUEvTFo0ZnBXVmxvSWdzL0d5b0JVeTg3YmN1VFhOVWRSbDhHQkE0Z2w5?=
 =?utf-8?B?aGFkSFVKdlZQSEkwSVdkNGpiOWJKUWFKd05kVVdxSk9aemlLWEF2UGtyRys0?=
 =?utf-8?B?aXVvbzlqWEt5cUk4ck9sMTR0eTV0dThNOEhCakM5OUNtakhuVjI2Y0J1eWl6?=
 =?utf-8?B?cmFpMHRQVU5RSFQrV0Y4R3FmcnE2ZjRpdkhiMzVVS0pwdDF3a2JhU1g0UTMv?=
 =?utf-8?B?NlJ1cWpBdXNNRFlCR0pOaDB3K1ppZ3IwOWdFM1dxSVQ0clJJZStSaVZKNDdD?=
 =?utf-8?B?UjZ6VjcyVWwyNXgydUs0czBGRVRtYmpFakRybG0rckhLUU42NWFLUUUzajNY?=
 =?utf-8?B?VjZuYXVMa2M0c2lXc3ZLVGRmenE0MlgyNmR4QWVGcndEVVhoMDJLODhaLzRK?=
 =?utf-8?B?VkgveW1QeXRzS29xZHoxaGhHRlNVVkFaZzQwN2FZRkFzaTJkcGVTRGZ2WTQy?=
 =?utf-8?B?SlFyM0RkMnptSmJweWlTUDJsM2srYkZRbzdYa3IvU2Ywbkt5OTVXRzZQKzJ2?=
 =?utf-8?B?bzZTMTdseW1pZHRmWmhtd1RZVEpLWE5QaHhJVnNONzFnZE93a2YrQ2hQZGRX?=
 =?utf-8?B?NldZbVg5dUwwVlRBODNKc3g4WXhnejlVM1pCQUp5Nmp0Q0llRytydG0ra0k3?=
 =?utf-8?B?NW9JK09KRm4vVG43WnpSN3FUdlZrNndSY0JWNzVSSW8vWEtURTAwNkpYaXZW?=
 =?utf-8?B?UXNLTEd6NUZNK3ovZ3ZuM3hrYUhVdzVSK1BRZlpHVmtndG1aZmVWamxCWmVu?=
 =?utf-8?B?WnhISFB1N2pwenRHenZnZ1VQOWVha3ZWVW1Qek9sYzk0dWtxME1sMCtiNjdL?=
 =?utf-8?B?cFhuckpEVzZlemVrdlR2eVVOck9MdVBWSng3SVBRSTM0RDRQYVlZYzNONXJw?=
 =?utf-8?B?WjQyZy9YQUd0N1M5QVJGL0NHUW82WkVUbVE3N0VvMndKVEx1aDVGMmNJczdX?=
 =?utf-8?B?Z2M2bUt0SEcxQTJ3disvaTE3dXl5N09RVFNleXpmMEZoSjdOWS9kSFB4VVZN?=
 =?utf-8?B?eUVmYThQbG8xQjlYejJzcnNlQzNwNGw5eUZRNFErT2ozSC9oTndzdzQrc0hY?=
 =?utf-8?B?dTdwTkVMTGppclIvZldSZzZKd3FqWVAxaDZnelZEWU01MkxRalc4TkxwMXI0?=
 =?utf-8?B?Z1JzQlhDajY2SWtSZHk4V3VqVmhSN3dtdmNWWkJqbGdFSUhPYTJwU29kbWlB?=
 =?utf-8?B?RXE3WXBGSnpNTkdWNWhkOUlzUy84NmJDOWRiYlY2R3VROEhHVmhVaGx1Q1BU?=
 =?utf-8?B?K0hYODZiOVBmS210THlRckZ4bmpnSkJCeTBkeFF0c0dwT2U1bFBHemlUcTE0?=
 =?utf-8?B?L3VTSVJtVi92TjFxOHdkU1N4aVdILzlXMkk3eHg3SGxEM1JtZ0oxSEdrRHZs?=
 =?utf-8?B?R2tBb0U4a2tydkw3ZTRNZkIzV1A0eDN2dVk1THJoRU0yc2J1bVNDWWFiK3pk?=
 =?utf-8?B?ajF4TGM3V0NvS08rTHVOYS94ZURFeEJORmFXUGRZTnNseWNhZXA4VXpNTlJW?=
 =?utf-8?B?cTUrZTdWWHRXN0p3SlQwNFlLNGVrdUVBT0RyeERURGVmN21lK0dlamJoMlVX?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6D099D9AB635E4FBF3F87E222AE9CEF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8374d0cf-ba9c-435d-331b-08dcd1f64563
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 00:11:23.5793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UqKCN8Jho80r4stGmrsrK09sDSHWwJlZe+fM5b6D2yKK7LWT2V+k4JIruUeJrbPWmEQDx6if0ndsT6/tn3yk6bb+V1vCDCI0j6aUZ/D3HZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7309
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEyOjEzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
ID4gWWFuLCBkbyB5b3UgdGhpbmsgaXQgaXMgc3VmZmljaWVudD8KPiAKPiBJZiB5b3UncmUgYWN0
dWFsbHkgcmVxdWlyaW5nIHRoYXQgdGhlIG90aGVyIGxvY2tzIGFyZSBzdWZmaWNpZW50LCB0aGVu
IAo+IHRoZXJlIGNhbiBiZSBubyBFTk9FTlQuCj4gCj4gTWF5YmU6Cj4gCj4gwqDCoMKgwqDCoMKg
wqDCoC8qCj4gwqDCoMKgwqDCoMKgwqDCoCAqIFRoZSBwcml2YXRlIG1lbSBjYW5ub3QgYmUgemFw
cGVkIGFmdGVyIGt2bV90ZHBfbWFwX3BhZ2UoKQo+IMKgwqDCoMKgwqDCoMKgwqAgKiBiZWNhdXNl
IGFsbCBwYXRocyBhcmUgY292ZXJlZCBieSBzbG90c19sb2NrIGFuZCB0aGUKPiDCoMKgwqDCoMKg
wqDCoMKgICogZmlsZW1hcCBpbnZhbGlkYXRlIGxvY2suwqAgQ2hlY2sgdGhhdCB0aGV5IGFyZSBp
bmRlZWQgZW5vdWdoLgo+IMKgwqDCoMKgwqDCoMKgwqAgKi8KPiDCoMKgwqDCoMKgwqDCoMKgaWYg
KElTX0VOQUJMRUQoQ09ORklHX0tWTV9QUk9WRV9NTVUpKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBzY29wZWRfZ3VhcmQocmVhZF9sb2NrLCAma3ZtLT5tbXVfbG9jaykgewo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChLVk1f
QlVHX09OKGt2bSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIWt2bV90ZHBfbW11X2dwYV9pc19tYXBwZWQodmNwdSwgZ3Bh
KSkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXQgPSAtRUlPOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dDsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqDCoMKgwqDCoMKgwqDCoH0KClRydWUuIFdlIGNhbiBwdXQg
aXQgYmVoaW5kIENPTkZJR19LVk1fUFJPVkVfTU1VLgo=

