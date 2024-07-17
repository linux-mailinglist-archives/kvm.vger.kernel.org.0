Return-Path: <kvm+bounces-21745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B88549334C4
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 02:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91711C223C6
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 00:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22FBEDF;
	Wed, 17 Jul 2024 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M98Wx+6D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F80B63C;
	Wed, 17 Jul 2024 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721176718; cv=fail; b=s3PTgigsmgzW3RFwQDo8pIpn57TY6uQxidoZLx8XMqe5wwbfbmW9NAahBouYZPtpARTzJPiUzn71+XtfY2YcOv/lgQN+s+OaD9xgMhS7u0zrXZcMdlsXPZIrF5H1g/BjL/quK4PZ2In4kr87iEfxeBA4TVvrs164yXcFHrgsP50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721176718; c=relaxed/simple;
	bh=4sPn5A2/TBaPY9W/A4ZI7Sd5S4/H+gwirpYPThFPNnE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JYjpJvf9jqMwRwWaRN8VpPaUacb1nIKc6fMhL0SOdZm4LVPLJ0BLgNXPVphW4fcYoDZlIuJ1JQ8Wi8PkfjqTYYbE3DUnfYnj0JriRSph58zSPBQb/uQKM8Lbk2RHOKWWh8RTIq3XLK/8W+SA3INI5nFJphRIAgsnNo7Ki1qqUpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M98Wx+6D; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721176716; x=1752712716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4sPn5A2/TBaPY9W/A4ZI7Sd5S4/H+gwirpYPThFPNnE=;
  b=M98Wx+6DiFHBEEu5X7MATuUPIH8VBhWdJxRRylxXYpRWKFeW2dcYKO+V
   4HOYbQrnCVroJww6/4+R/yY8FozzXXq4xa5Xst69sDbegOrLdWbHUJGEN
   hDEaMhs6uDBiLRZ/veO1Z8XZgrs4rOsdIrzN0XH6JUllEKsNRS9LBx+9x
   m2+xzitCq1rqbvmqcKK/r43eiDk263eK+up8xV+xjsmrg96Om7+KEpF/K
   zauCKKvVDeorTplFH06C/seuLuePfvBZhpp8gXf94Vlst71zYfawOXRDE
   luFS1zbEPagErarzFYwkGdK7oa1WqmYS9YJ9dqjD0wBgQ5Mehz1MIVnGA
   Q==;
X-CSE-ConnectionGUID: k0kCeAcpQrWv12UXdCZhkA==
X-CSE-MsgGUID: 3QFtr2FSRDO71N5FTKBNKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18270162"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18270162"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 17:38:35 -0700
X-CSE-ConnectionGUID: i22aMDJyRh2vAXtIn5VVHg==
X-CSE-MsgGUID: Lu6A3RhWTiOZmKqDbiZTiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="50793953"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jul 2024 17:38:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 16 Jul 2024 17:38:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 16 Jul 2024 17:38:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 16 Jul 2024 17:38:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 16 Jul 2024 17:38:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3izU7g1Om0KOmY4ca7rHIfhgLLhoogn/2pOjBZAp4TPEEgY4fop0/bypB5Ou9r6XwpasQpNiNeTakHZmuKBzEjHyvbsdCLJ3PVbloixj+CBYf8w29kQLtfUBOa4ZWI99bgxERF8HVAhQcx6o2h7Ml8IZbZ/6ebBpVMC5RkPY7gA4OwZNJ/6XlSzNY1rPSSrt1CBdbICtSMVqFZARLSeLK1RspZrtPmD3dbomMubz3VtYFuag/LxvZ3pZDIRuDdIyFksPqt5fveNSHXZR7Xq15WDjkFltASOSy3LVOFPQQYr+fx93NZy7/J8aD6ar0uGrUQqvfrJj5sHl0Nbs1es0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sPn5A2/TBaPY9W/A4ZI7Sd5S4/H+gwirpYPThFPNnE=;
 b=J87ZLS2nuf5dg1e8hCAD8ALhj9lL6HR2kV2l8N9Dcmpsavlp5qPosrbZ0qFO2AQPQh3+695yPYkJs5S1YjTkzYEWuw22UAMoEUs9php9mHbieii7xMmz8sK+fj01leJnybWv3goM8PCogym6GjLql6F/z8mjyI4Xieh/KKJMUZeuWtpSS5ilNTRxGI+dXS10MuKk9JS9NkB03nxDStkHk2VvgmagVyW21OoyXAclzdGLrEIs7Ebb+jAjjIRQVShbmTZIOKCZImm8uIeg3m4TMmJR4ah8ykPIv3giT2DbLfToouCCdVkF2y8DoB2Ue56f2CMtilE8wtak0oN93U5wEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7140.namprd11.prod.outlook.com (2603:10b6:806:2a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Wed, 17 Jul
 2024 00:38:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 00:38:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Thread-Topic: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Thread-Index: AQHa1x52SQHDcx1NlUy5OEbh4zbwNLH5v2EAgAA8guiAABkjAA==
Date: Wed, 17 Jul 2024 00:38:25 +0000
Message-ID: <08cb04f1408461d436eb48370888a066c4e03001.camel@intel.com>
References: <fdddad066c88c6cd8f2090f11e32e54f7d5c6178.1721092739.git.isaku.yamahata@intel.com>
	 <ZpbKqG_ZhCWxl-Fc@google.com>
	 <2b3e7111f6d7caffe6477a0a7da5edb5050079f7.camel@intel.com>
	 <Zpb9Vwcmp4T-0ufJ@google.com>
In-Reply-To: <Zpb9Vwcmp4T-0ufJ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7140:EE_
x-ms-office365-filtering-correlation-id: 69166010-0914-403a-580f-08dca5f8c4e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SjlTN2h4MkV6UC9aK3FZQ1M2UTF3QWNWZ2R2T2ZoR20vbTZhU3MyS2dXcXk2?=
 =?utf-8?B?Y2YvZ2htOGF4YjNMVi9ycytMS1k5UEZjazcrWmRVR2oxcUNnSWhEZFhWYTRC?=
 =?utf-8?B?VzNqN25FUE1pSEdtVUR3MkhTYmVjanlVRitKOTlHR3QvVE9sT1kxSFFXYVRC?=
 =?utf-8?B?YllabjhEdGVSeURNYUtkMUdIVDlmb21ncTQ2VXJtMXV2NHZnbVhIVmlXbUto?=
 =?utf-8?B?WWZOaHpMQjVkaTdGbTdRVHFzQTZSb2FGb2ZVOEptWXdnQUZpNU5SZ2IrRlM4?=
 =?utf-8?B?elBkbjQ1djlmTytlR2hpOXp4L1JueU5tV2d1ZUdQWmljSTdQTlNFcFpiWGFz?=
 =?utf-8?B?SDFIKytoY3JIdnhGUjZJRExraHlZWCtvVEkzZ0NpWW5iaWZ4ejZXa3Q3c2xT?=
 =?utf-8?B?RlFuOEdXY2hudDg0cDM0QTJyZWRVR2RVYnpwWGhBR3dHUmdNeVdNemVMV0o0?=
 =?utf-8?B?VTBrbitCV0JydkJyL3ZPK3RsNFJKOE9CVThYdDRRZGxCUVBPQlV0ci8rV3RM?=
 =?utf-8?B?enNodEM0VTlFdS9PSE1VdjVYbURUaFQ3OWlZZEJuYlBHTDJKMDVtRTE2VmZG?=
 =?utf-8?B?bHlSaGRBRFJEUENxTTV2anVxN1I4T1dJWWRQQXpJT2Z6d0Npd0hOd0xsQUMv?=
 =?utf-8?B?SVNwZ0FFeDNuUnBaMzFTNlQ1eGtSc3ViNk4vdDgxR01sb1RwVW9kY3BvbENG?=
 =?utf-8?B?dWdncmdNRXk0dGlSNDRyZXU3WkE2czZrNkxpQVZrMVdQUXE0VVUwSys5NEtr?=
 =?utf-8?B?YVBXbWc4YXJSbmk4QkVnTG1nTzZVeWdZMWRheUNIUHNpNnMrOU1pK3k3TUls?=
 =?utf-8?B?NTZ4VlZjbXArbVBJald5SERCRiszckVlZGxoQUtyaFR4VmRwcDJUSXFUeXVC?=
 =?utf-8?B?ckNRTlRRT0hremEza0xyTmx6Z0VmaU1vb3JPeXRhTVlMaS9VUjJMS1JHMmsv?=
 =?utf-8?B?SjJ4TVBVbVFPUkhsd0h1T2VIYlZDNEVmcGpVVkoyMXVNemRoSk5hcTFNM1Zr?=
 =?utf-8?B?Y0lDLytBR0FCVFhMdjNYZVcxbTJMRW5OSlFKMS95MUVjR0k1Ui9vT0w4OU85?=
 =?utf-8?B?eHVQUDg4REtjb2JCaTBhQmNkZ05VU0M2c2YxWHNnZXE3Skw5NEwrTklkM3g5?=
 =?utf-8?B?S2VZWlN1NmY4Tm5memxYYUhtMHhCTzFMNW93TTlOdHJZa1p3QVNqUG9ibXRp?=
 =?utf-8?B?aEprVTRRY0p6MitXcmcyZDg5TU1keHNsSFNlY1hWbytqOXdQVkZEbndPQ2kv?=
 =?utf-8?B?SytFYUhyRzBSSG15ZmFWRThJWHFvSWY2ekpha29vamJnV1l0MGxIZkN5Zy9S?=
 =?utf-8?B?cXdGV2x6Qmw3dTlVTStzUS9BM1U5OUV6TkpkM1l3Sm9hVGR3RG5OUGhlOTJV?=
 =?utf-8?B?SVNpTjZVaHlpbTFwdThwTUpCSTdwZVNtVnlTcDBpRTh0OCs3b0E5M0kvbFpv?=
 =?utf-8?B?dnJUazRsUEl1cmRJcVFvVDlhTUlpa3FtNG9xL0ZMb3RaL1EveVVpZmRBL1Bq?=
 =?utf-8?B?ZUFOWTRFVmJwR2pFcDZuSUxDNit1ekg3WTI4VkxTellpT2l6dktJVndJd1VP?=
 =?utf-8?B?MUlGaU9HQmYwL2kxQmNFYktsNksyUXp4eUVzYjhTamczWkRTT0xRM1MzSmN4?=
 =?utf-8?B?SWZ4WUFmTWMycEpzUXRxanlVQ2FUaXZFb28vTzd3LzZ3VmRQbGplbFNqZUFU?=
 =?utf-8?B?NXRkaTc0WGpxaEpNcHhuT2lNMFJyQStsL0EyaUprVGVQQm0xektqbnN0WmtW?=
 =?utf-8?B?L3hEMW43SS9Nc3dlS041dURDRmhKS3VQYW4ybi9mZTVjKzMvZXRWa2RiMkVo?=
 =?utf-8?Q?vpS7d27vSPVA/MtJY71+c/i5RadTaFQU9d+ms=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHE4L2hXY29XU1oybG5FSXFzbTBKUWd2SER6UFVHRXE2d2JzMEpjN2ttcEpG?=
 =?utf-8?B?RUQzeHBGRFNRYmxwdzlyQjlqcU91VTN0cllvdC9DR0NnOEVmai9PYmNMejlB?=
 =?utf-8?B?K3cxc2xuRFpaSld4Kzk1WmdxK1JMZ3FHVmNqWTc3STFPbXRjOWZ1RGc5YzU4?=
 =?utf-8?B?a1N5YnQyL2xhMndTNE1vd2YzR2lsWVdXbGkyY2ZiNnN4SGhzS01tSWxjVjhh?=
 =?utf-8?B?dFRMTzFFQXZvTjJGRXhqY3A4MndCblJNQlpLV2E4Um90WXU3bzFXVXgxOHVI?=
 =?utf-8?B?V1VvTUF3YVdoWFlCWEpkMzFnTjFjeTQzVlVINFpZTU1IbmQ4TzVkSzhqWU9n?=
 =?utf-8?B?bmgvOG04c1hqTElRdlB3aklxdUJhY0Z4WENVS2lZcFArVGNQaUNNMUlJeW9Y?=
 =?utf-8?B?VU9Sekt3TzdRN0lWM0hqejg4NGJid2xSdlBEUWxHYnhYcHAydHh3WVA4c0pI?=
 =?utf-8?B?b09SY05waFQxKzRMdG53aUZYM1pHNjluNEUrUXJDREdaY1lxTm5OVXFRN016?=
 =?utf-8?B?YTVEcmdEMzlISi9TdVNzU2JhK2NYRTVxdHl1QjZaZThGTFFFUmVCeWFNeCsv?=
 =?utf-8?B?dG03dzd6MTBsV0p6T1JvMnlUa2NhRkxiRjFsZkFXb0R6dkl0cFIzYVRuQVJo?=
 =?utf-8?B?cHNzdTh0VUpkbUc4eVVZT3NjMWwzMDY4UUY5YXg4MC80TXVkV0JLWDZ3ZlVQ?=
 =?utf-8?B?U2tjVHoxVGFENFRQeGNGRFFNaU9aYnBhVUQ3eDVYSzVleGx3aTZXc0hrWnZq?=
 =?utf-8?B?S2lHeW82VW9yTnBuazlhRTdEU3UrVHhMSVplK0QrcXNwS2NFVWxoNVBpd2p4?=
 =?utf-8?B?ZW1ZT1VLUWU4eDRrUUhKWVI2LzJxaS9Vam9GT1NXYkN1L3NDUzE4N3VWMmFi?=
 =?utf-8?B?cWFRSnJNY2hTTlVnNUw4RWdEUlJSZXVkZXVHRjdXdW1GQlJINHlna1lmT3c4?=
 =?utf-8?B?M21KazJaSGFRT2ZSeGJqT3hyT1lIeUM5Q3YvNmIwdGM0NWxrVllDT3JZY3gx?=
 =?utf-8?B?UVRtdHI4QnhLcFJoYVVnd05qUU5KWHRHaVRNTG1pUDlvK1V3Vmc5RzZJaENM?=
 =?utf-8?B?dFJGVk1LWjBhaE9SWDg0RHZlV0g3NGZIaDlmYTVNdTk3TkgweklhUEVOS2pB?=
 =?utf-8?B?d2FiUVZuRGZkTWtNUUxNdjdjUCtEallJUWd3Z0RiYVpEbWFZdmRMRUlwM081?=
 =?utf-8?B?akpicnlHWEJsZGdoVW4xU0RYZE1PN2VZdVY2V2ZYV0tsZmF5RnBqRlB0U3lO?=
 =?utf-8?B?eCsydS9RTnI1S29BNUJtNzQ1OS9MUEVSbmFiay93NjZjcTFoMFpKM1BKUDVG?=
 =?utf-8?B?eWFmNWkrdVlONUoxdEloQmZjanF0T2ZJb2huVEp5NFZyRWR2bWxNbDBXSTU3?=
 =?utf-8?B?NWhvcEEyQU0vV01aZWlOOGRVWEdNL3NPRkg2YzJ2ODMxUzFwdjBkMllORElr?=
 =?utf-8?B?OFJDZzBVUVZyRFN5a0k2K09hS0dITkZUMklHRHFyN0xqRnd6VUZWVXFFSDdC?=
 =?utf-8?B?QjJWNnlXZW9vTzlGTGFMbm9ET2RUd2lHTGZHejdDYzI3T1RMRFg1dlkxcFlF?=
 =?utf-8?B?NWFYZ0VXcVl2amp1Y29wamtHTHlZTFNZRXNIV2c3eGRZM005TDhQUVFKSE9C?=
 =?utf-8?B?eDVLR3dsWHR3cDFQTTg0T24rSWZvZ0RQQmtqWVFIS2ZMQXNmLy82Zm9rRWUw?=
 =?utf-8?B?aWcxdXJzQTlKQnlmREgxL1JCVVZhRUIrNlprMmZoYXRpNEJZQWw4cWpUZ0xN?=
 =?utf-8?B?TU95OTk2b0dHSHQrdG5PcHRTZWNHNmU3VTlKWEpoTzlWbFIvMkZzQTQra0FD?=
 =?utf-8?B?UDF0QXFwZzZOajNqSUp3ZEZhTnNHSjl3Uzh5Qy9xSnY0aXlnVWdMQWtqUHFz?=
 =?utf-8?B?Y0lCbEJvcUpqbUhDU0NvK3Z5UUEzTG11ZERVZzhlQ296dXB2T3dCZ21jUlZV?=
 =?utf-8?B?U24xYXJXVEw2cFJjWjJ5UjRDYVpiUHk2VTVuenlzak1raU9mUkFwUS9YRWc5?=
 =?utf-8?B?UVNPa0gxdVdXRkVPbzBrRWVZNi83QmlpY2xoSDVwUXE4S0dYOXVEQ3dNaFVP?=
 =?utf-8?B?L2JweWtvTXZlSmlGSWRBckZKN0hFdG9HTFVHbnlVeWFrdmdja2NyUldaK3Zz?=
 =?utf-8?B?ZE5FNEJqZ1Q1M2dRZnhnNTRvbXpRanBSTGR4eWpCdjFXeWMrbWd3VmFQWHVQ?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF2386A71DAA974394EF4320330239AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69166010-0914-403a-580f-08dca5f8c4e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2024 00:38:25.3618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P6Is0lk8vCYEN2bXiYVStNBt4ATLLao6+l38Ezpa2mDO1oAxNZ30kB+svv8Syje3c5d+ADDhXJ6RWwS3nCztd4YF6KlYp9nj43REXllwVuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7140
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA3LTE2IGF0IDE2OjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gSU1PLCB5b3UncmUgbG9va2luZyBhdCBpdCB3aXRoIHRvbyBtdWNoIG9mIGEg
VERYIGxlbnMgYW5kIG5vdCB0aGlua2luZyBhYm91dA0KPiBhbGwNCj4gdGhlIHBlb3BsZSB0aGF0
IGRvbid0IGNhcmUgYWJvdXQgVERYLCB3aGljaCBpcyB0aGUgbWFqb3JpdHkgb2YgS1ZNIGRldmVs
b3BlcnMuDQoNCldlbGwsIEkgZG9uJ3QgbWVhbiB0by4gQWN0dWFsbHkgdHJ5aW5nIHRvIGRvIHRo
ZSBvcHBvc2l0ZS4NCg0KSSBkb24ndCBzZWUgaG93IHBlci12bSBtYXggZ2ZuIG1ha2VzIGl0IGVh
c2llciBvciBoYXJkZXIgdG8gbG9vayBhdCB0aGluZ3MgZnJvbQ0KdGhlIG5vcm1hbCBWTSBwZXJz
cGVjdGl2ZS4gSSBndWVzcyB5b3UnZCBoYXZlIHRvIGZpZ3VyZSBvdXQgd2hhdCBzZXQga3ZtLQ0K
Pm1tdV9tYXhfZ2ZuLg0KDQo+IA0KPiBUaGUgdW5hbGlhc2VkIEdGTiBpcyBkZWZpbml0ZWx5IG5v
dCB0aGUgbWF4IEdGTiBvZiBhbGwgdGhlIFZNJ3MgTU1Vcywgc2luY2UNCj4gdGhlDQo+IHNoYXJl
ZCBFUFQgbXVzdCBiZSBhYmxlIHRvIHByb2Nlc3MgR1BBcyB3aXRoIGJpdHMgc2V0IGFib3ZlIHRo
ZSAibWF4IiBHRk4uwqANCj4gQW5kDQo+IHRvIG1lLCBfdGhhdCdzXyBmYXIgbW9yZSB3ZWlyZCB0
aGFuIHNheWluZyB0aGF0ICJTLUVQVCBNTVVzIG5ldmVyIHNldCB0aGUNCj4gc2hhcmVkDQo+IGJp
dCwgYW5kIHNoYXJlZCBFUFQgTU1VcyBuZXZlciBjbGVhciB0aGUgc2hhcmVkIGJpdCIuwqAgSSdt
IGd1ZXNzaW5nIHRoZSBTLUVQVA0KPiBzdXBwb3J0IE9ScyBpbiB0aGUgc2hhcmVkIGJpdCwgYnV0
IGl0J3Mgc3RpbGwgYSBHRk4uDQoNCkluIHRoZSBjdXJyZW50IHNvbHV0aW9uIEdGTnMgYWx3YXlz
IGhhdmUgdGhlIHNoYXJlZCBiaXQgc3RyaXBwZWQuIEl0IGdldHMgYWRkZWQNCmJhY2sgd2l0aGlu
IHRoZSBURFAgTU1VIGl0ZXJhdG9yLiBTbyBmb3IgdGhlIHJlZ3VsYXIgVk0gcmVhZGVyJ3MgcGVy
c3BlY3RpdmUsDQpURFAgTU1VIGJlaGF2ZXMgcHJldHR5IG11Y2ggbGlrZSBub3JtYWwgZm9yIFRE
WCBkaXJlY3QgKHNoYXJlZCkgcm9vdHMsIHRoYXQgaXMNCm1lbXNsb3QgR0ZOcyBnZXQgbWFwcGVk
IGF0IHRoZSBzYW1lIFREUCBHRk5zLiBUaGUgaXRlcmF0b3IgaGFuZGxlcyB3cml0aW5nIHRoZQ0K
UFRFIGZvciB0aGUgbWVtc2xvdCBHRk4gYXQgdGhlIHNwZWNpYWwgcG9zaXRpb24gaW4gdGhlIEVQ
VCB0YWJsZXMgKGdmbiB8DQpzaGFyZWRfYml0KS4NCg0KPiANCj4gSWYgeW91IHdlcmUgYWRkaW5n
IGEgcGVyLU1NVSBtYXggR0ZOLCB0aGVuIEknZCBidXkgdGhhdCBpdCBsZWdpdGltYXRlbHkgaXMg
dGhlDQo+IG1heA0KPiBHRk4sIGJ1dCB3aHkgbm90IGhhdmUgYSBmdWxsIEdGTiByYW5nZSBmb3Ig
dGhlIE1NVT/CoCBFLmcuDQo+IA0KPiDCoCBzdGF0aWMgdm9pZCBfX3RkcF9tbXVfemFwX3Jvb3Qo
c3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290LA0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJv
b2wgc2hhcmVkLCBpbnQgemFwX2xldmVsKQ0KPiDCoCB7DQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgdGRwX2l0ZXIgaXRlcjsNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqBnZm5fdCBlbmQgPSB0ZHBf
bW11X21heF9nZm5fZXhjbHVzaXZlKHJvb3QpOw0KPiDCoMKgwqDCoMKgwqDCoMKgZ2ZuX3Qgc3Rh
cnQgPSB0ZHBfbW11X21pbl9nZm5faW5jbHVzaXZlKHJvb3QpOw0KPiANCj4gYW5kIHRoZW4gaGF2
ZSB0aGUgaGVscGVycyBpbmNvcnBvcmF0ZWQgdGhlIFMtRVBUIHZzLiBFUFQgaW5mb3JtYXRpb24u
wqAgVGhhdA0KPiBnZXRzDQo+IHVzIG9wdGltaXplZCwgcHJlY2lzZSB6YXBwaW5nIHdpdGhvdXQg
bmVlZGluZyB0byBtdWRkeSB0aGUgd2F0ZXJzIGJ5IHRyYWNraW5nDQo+IGENCj4gcGVyLVZNICJt
YXgiIEdGTiB0aGF0IGlzIG9ubHkga2luZGEgc29ydGEgdGhlIG1heCBpZiB5b3UgY2xvc2UgeW91
ciBleWVzIGFuZA0KPiBkb24ndA0KPiB0aGluayB0b28gaGFyZCBhYm91dCB0aGUgc2hhcmVkIE1N
VSB1c2FnZS4NCg0KVGhpcyBpcyBzaW1pbGFyIHRvIHdoYXQgd2UgaGFkIGJlZm9yZSB3aXRoIHRo
ZSBrdm1fZ2ZuX2Zvcl9yb290KCkuIEhhdmUgeW91DQpsb29rZWQgYXQgYSByZWNlbnQgdmVyc2lv
bj8gSGVyZSwgdGhpcyByZWNlbnQgb25lIGhhcyBzb21lIGRpc2N1c3Npb24gb24gaXQ6DQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA1MzAyMTA3MTQuMzY0MTE4LTctcmljay5wLmVk
Z2Vjb21iZUBpbnRlbC5jb20vI3QNCg0KUHVzaGluZyB0aGUgc2hhcmVkIGJpdCByZS1hcHBsaWNh
dGlvbiBpbnRvIHRvIHRoZSBURFAgTU1VIGl0ZXJhdG9yIHByZXR0eSBuaWNlbHkNCmhpZGVzIGEg
bG90IG9mIHRoZSBURFggc3BlY2lmaWMgYmVoYXZpb3IuIEl0IHdyYXBzIHVwIHRoZSBURFggYml0
cyBzbyB0aGF0IG90aGVyDQpkZXZlbG9wZXJzICpkb24ndCogd29ya2luZyBvbiB0aGUgdmFyaW91
cyBvcGVyYXRpb25zIGRvbid0IGhhdmUgdG8gdGhpbmsgYWJvdXQNCml0Lg0KDQo+IA0KPiA+IE15
IGluY2xpbmF0aW9uIHdhcyB0byB0cnkgdG8gcmVkdWNlIHRoZSBwbGFjZXMgd2hlcmUgVERYIE1N
VSBuZWVkcyBwYXRocw0KPiA+IGhhcHBlbiB0byB3b3JrIGZvciBzdWJ0bGUgcmVhc29ucyBmb3Ig
dGhlIGNvc3Qgb2YgdGhlIFZNIGZpZWxkLiANCj4gDQo+IEJ1dCBpdCBkb2Vzbid0IGhhcHBlbiB0
byB3b3JrIGZvciBzdWJ0bGUgcmVhc29ucy7CoCBJdCB3b3JrcyBiZWNhdXNlIGl0IGhhcyB0bw0K
PiB3b3JrLsKgIFByb2Nlc3NpbmcgIVBSRVNFTlQgU1BURXMgc2hvdWxkIGFsd2F5cyB3b3JrLCBy
ZWdhcmRsZXNzIG9mIHdoeSBLVk0gY2FuDQo+IGd1YXJhbnRlZSB0aGVyZSBhcmUgbm8gU1BURXMg
aW4gYSBnaXZlbiBHRk4gcmFuZ2UuDQoNClRoZSBjdXJyZW50IGNvZGUgKHdpdGhvdXQgdGhpcyBw
YXRjaCkgZG9lc24ndCB6YXAgdGhlIHdob2xlIHJhbmdlIHRoYXQgaXMNCm1hcHBhYmxlIGJ5IHRo
ZSBFUFQgZm9yIHRoZSBzaGFyZWQgcm9vdCBjYXNlLiBJdCBjb3ZlcnMgdGhlIHdob2xlIHJhbmdl
IGluIHRoZQ0KcHJpdmF0ZSBjYXNlLCBhbmQgb25seSB0aGUgcmFuZ2UgdGhhdCBpcyBleHBlY3Rl
ZCB0byBiZSBtYXBwZWQgaW4gdGhlIHNoYXJlZA0KY2FzZS4gU28gdGhpcyBpcyBnb29kIG9yIGJh
ZD8gSSB0aGluayB5b3UgYXJlIHNheWluZyBiYWQuDQoNCldpdGggdGhpcyBwYXRjaCwgaXQgYWxz
byBkb2Vzbid0IHphcCB0aGUgd2hvbGUgcmFuZ2UgbWFwcGFibGUgYnkgdGhlIEVQVCwgYnV0DQpk
b2VzIGl0IGluIGEgY29uc2lzdGVudCB3YXkuDQoNCkkgdGhpbmsgeW91IGFyZSBzYXlpbmcgaXQn
cyBpbXBvcnRhbnQgdG8gemFwIHRoZSB3aG9sZSByYW5nZSBtYXBwYWJsZSBieSB0aGUNCkVQVC4g
V2l0aCBURFggaXQgaXMgZnV6enksIGJlY2F1c2UgdGhlIGRpcmVjdCByb290IHJhbmdlIHdpdGhv
dXQgdGhlIHNoYXJlZCBiaXQsDQpvciBiZXlvbmQgc2hvdWxkbid0IGJlIGFjY2Vzc2libGUgdmlh
IHRoYXQgcm9vdCBzbyBpdCBpcyBub3QgcmVhbGx5IG1hcHBlZC4gV2UNCndvdWxkIHN0aWxsIGJl
IHphcHBpbmcgdGhlIHdob2xlIGFjY2Vzc2libGUgcGFnaW5nIHN0cnVjdHVyZSwgZXZlbiBpZiBu
b3QgdGhlDQp3aG9sZSBwYXJ0IGRvY3VtZW50ZWQgaW4gdGhlIG5vcm1hbCBFUFQuDQoNCkJ1dCBp
ZiB3ZSB3YW50IHRvIHphcCB0aGUgd2hvbGUgc3RydWN0dXJlIEkgc2VlIHRoZSBwb3NpdGl2ZXMu
IEknZCBzdGlsbCByYXRoZXINCm5vdCBnbyBiYWNrIHRvIGEga3ZtX2dmbl9mb3Jfcm9vdCgpLWxp
a2Ugc29sdXRpb24gZm9yIHRoZSBURFAgTU1VIHN1cHBvcnQgaWYNCnBvc3NpYmxlLiBJcyB0aGF0
IGFscmlnaHQgd2l0aCB5b3U/IFdoYXQgYWJvdXQgc29tZXRoaW5nIGxpa2UgdGhpcyBpbg0KY29u
anVuY3Rpb24gd2l0aCB5b3VyIGVhcmxpZXIgZGlmZj8NCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS9tbXUvdGRwX2l0ZXIuaCBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX2l0ZXIuaA0KaW5kZXgg
OGJjMTllNjUzNzFjLi5iZjE5ZDVhNDVmODcgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vbW11
L3RkcF9pdGVyLmgNCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX2l0ZXIuaA0KQEAgLTEyOSw2
ICsxMjksMTEgQEAgc3RydWN0IHRkcF9pdGVyIHsNCiAgICAgICAgICAgICBpdGVyLnZhbGlkICYm
IGl0ZXIuZ2ZuIDwgZW5kOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANClwN
CiAgICAgICAgICAgICB0ZHBfaXRlcl9uZXh0KCZpdGVyKSkNCiANCisjZGVmaW5lIGZvcl9lYWNo
X3RkcF9wdGVfbWluX2xldmVsX2FsbChpdGVyLCByb290LCBtaW5fbGV2ZWwpICAgICAgICAgIFwN
CisgICAgICAgZm9yICh0ZHBfaXRlcl9zdGFydCgmaXRlciwgcm9vdCwgbWluX2xldmVsLCAwLCAw
KTsgICAgICAgICAgICAgIFwNCisgICAgICAgICAgICBpdGVyLnZhbGlkICYmIGl0ZXIuZ2ZuIDwg
dGRwX21tdV9tYXhfZ2ZuX2V4Y2x1c2l2ZSgpOyAgICAgIFwNCisgICAgICAgICAgICB0ZHBfaXRl
cl9uZXh0KCZpdGVyKSkNCisNCiAjZGVmaW5lIGZvcl9lYWNoX3RkcF9wdGUoaXRlciwga3ZtLCBy
b290LCBzdGFydCwgZW5kKSAgICAgICAgICAgICAgICAgICAgICAgICANClwNCiAgICAgICAgZm9y
X2VhY2hfdGRwX3B0ZV9taW5fbGV2ZWwoaXRlciwga3ZtLCByb290LCBQR19MRVZFTF80Sywgc3Rh
cnQsIGVuZCkNCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyBiL2Fy
Y2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQppbmRleCBjM2NlNDNjZTdiM2YuLjZmNDI1NjUyZTM5
NiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQorKysgYi9hcmNoL3g4
Ni9rdm0vbW11L3RkcF9tbXUuYw0KQEAgLTg4OSwxMCArODg5LDcgQEAgc3RhdGljIHZvaWQgX190
ZHBfbW11X3phcF9yb290KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0DQprdm1fbW11X3BhZ2UgKnJv
b3QsDQogew0KICAgICAgICBzdHJ1Y3QgdGRwX2l0ZXIgaXRlcjsNCiANCi0gICAgICAgZ2ZuX3Qg
ZW5kID0gdGRwX21tdV9tYXhfZ2ZuX2V4Y2x1c2l2ZSgpOw0KLSAgICAgICBnZm5fdCBzdGFydCA9
IDA7DQotDQotICAgICAgIGZvcl9lYWNoX3RkcF9wdGVfbWluX2xldmVsKGl0ZXIsIGt2bSwgcm9v
dCwgemFwX2xldmVsLCBzdGFydCwgZW5kKSB7DQorICAgICAgIGZvcl9lYWNoX3RkcF9wdGVfbWlu
X2xldmVsX2FsbChpdGVyLCByb290LCB6YXBfbGV2ZWwpIHsNCiByZXRyeToNCiAgICAgICAgICAg
ICAgICBpZiAodGRwX21tdV9pdGVyX2NvbmRfcmVzY2hlZChrdm0sICZpdGVyLCBmYWxzZSwgc2hh
cmVkKSkNCiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KDQoNCg==

