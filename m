Return-Path: <kvm+bounces-64428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A569C82544
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 66CF14E2222
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9680A32C327;
	Mon, 24 Nov 2025 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jowMmVhJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1307D207A3A;
	Mon, 24 Nov 2025 19:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764013681; cv=fail; b=aIR1s+8zzU8wvVUA4F3iIXkDOqP5NDQWWZiE5tEw2IpL07KceqpKUKatYvGCTrG1yQ6Qrd/0byAinHBYPKAmYDmO1d+Nlf8itAeZhnoJnvLxCuh4VcQlnvHMuR5FRyT+Ogorzu/hIF4XVdXayNG5+BThF7wdlrlWUtcUeb+qdrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764013681; c=relaxed/simple;
	bh=LCIMpwTFZmkUKEqRPGloH/XXnQ304MV9KWHaH4f7c28=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fyr9R7PRXVlidfdSNJ7fdfB7LwGsBfjYcNGpCPX28ElXM7Yb8XzkIvW4Kse/ZJDuEUv5l0i2x8nLLrx2c3ONvQEVDe0fqYPJrmnfJ/CG3X8rqqTRwli17ipExS2ekBK/6fCxJWm50Ib99AvbA+5YP0dgRa1hUPQs4d5n/15Fm5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jowMmVhJ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764013680; x=1795549680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LCIMpwTFZmkUKEqRPGloH/XXnQ304MV9KWHaH4f7c28=;
  b=jowMmVhJGjaqhVC0pIpdRKqU0C1ZIidICssHSfT49a7iTdN5o7hcLSpk
   MmD1I6+CXRNql74ucpVynNnHDffwLfAk8IA9aDo6DjLA1TurZ9Un6gquj
   9kwp6zmoa6AqioRS0TZbUXGouyZY6mielkFNDAI64NxxCKn/WdlmBU8sT
   TG6oXDeJ88W7eYyUejsaS8/LiFkb5bE06wyPktdNPs1zxsxv0sRGEWqf9
   5boMH3DT+OQ2VEGgNv8bzg96IceopxY/Mr3BJeHq16jPry6ttuD+k5HNT
   o8o0rIGSYtAw8J7KrtaompYRxTz2pEWr9liMYfxmfOYtbScCqhY09g69i
   Q==;
X-CSE-ConnectionGUID: mwdZ51bfSFWqVON7WeXmfw==
X-CSE-MsgGUID: XGtRsrFnTDS8sFSiANcheg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="88673071"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="88673071"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:47:59 -0800
X-CSE-ConnectionGUID: qgOF9X2FR/WCe4cEQFpW0g==
X-CSE-MsgGUID: jp7kbJCbRC+1H5EuSw0XXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="196595272"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:47:59 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 11:47:59 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 11:47:59 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 11:47:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghoE9BXEX+7CAVLUGF5ViGCxSR171fh1UJWnMDqb7hbIbNjkj9axUFsBZ89QGE5FPrydeLPOGP4Iuy3b1y54bL54LDNhFNkp8mlkGbpf+heHfJ4s9VHSLj5LjMHDpwpuv0fnoJCPApakAliyck9MAWN8NwFEjhoM7ZFsg0CmCCmkVcHC00G9kOsmFmk298aAbkJjPZDx4YJu/Vow8/+LJR6uuvMJaUuNuKzwfpMY3F1rXMr7llbuES4dFku5jVRVYer7dcBIjKit+GKTfwCqzuRjaprm7vj7bd5cP2QWnotCh0sdo72uD/8Id3L4O/6ZmHabTg64TGa1Y7PcJ/lsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCIMpwTFZmkUKEqRPGloH/XXnQ304MV9KWHaH4f7c28=;
 b=tr5O7P1tOi8A2G+4hTM5zoGU8HnvBIeE8fd7B9E3DyY9ti1tENicKBpIcpIJSwEQD2h//a11m4+mc+0jFAqsL2CHOEP308BKHsIoNhMLl3rET4QXoU/+xVHMs/urZeZRKosP8Rd9t7T5NhkweZC8VJB5rLBDD9jw6KO/7tCgAAS+aNiIfHe14TpPLmr78Es5LeqmprUfPej4+NDIf/JiFePbmW/PjVDkLOxwUZ/RQI91ogOB2VbvVde3LleVjEmHZ44Ae1MIsSETcRdhkQRLHbOE+yUkDcyyIKpPkxqLDvS5MQjtvpVBws/CHx44d94kK93PTDlFPIaqo9c8c8U1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5783.namprd11.prod.outlook.com (2603:10b6:510:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 19:47:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 19:47:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Topic: [PATCH v4 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Index: AQHcWoEFy6NxIZ8rPkatotIjti5yQrUBk+UAgACtiwA=
Date: Mon, 24 Nov 2025 19:47:55 +0000
Message-ID: <f495fed769914a476bace0fd7eb58bebd933f6af.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-4-rick.p.edgecombe@intel.com>
	 <8eba534b-7fcf-43b2-a304-091993faef1c@linux.intel.com>
In-Reply-To: <8eba534b-7fcf-43b2-a304-091993faef1c@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5783:EE_
x-ms-office365-filtering-correlation-id: 324d8e05-e430-418e-7a43-08de2b925d10
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ekFOZ0VPU0FtTkR4cmtrWGxnMlozZVYwckNaMzBsdHVEU1pWb09tNmpwcG9Z?=
 =?utf-8?B?R1VYai96MzYwTTV3Qkw2K0ZjRGtrM1M2ajlRSjBjTGFoMnFoN1gxeFRCNHEw?=
 =?utf-8?B?emlNd25malJoVStyOEhlNzZWeWxER3Z4OWV0aldiOCtRMG9iS0hvdVZtWHJM?=
 =?utf-8?B?UGhSM3NtK0hpeTRicmlhU0lac3RDa0paR0tPZGpUOENIMVZhOGV3a0ZhdWd3?=
 =?utf-8?B?Wms1dDhCZFJNT2lsaW8vaTFkaWduekwwZmtKN2RzM2hrcFZrSFVESFlzVGlu?=
 =?utf-8?B?MUJYcURLcjk1YUJtOEdTNHVGZyt1TWE5TzV5RzcxR01rU0J3YmRQOWtGUVUr?=
 =?utf-8?B?WGpLNnY1ajg2dEh0RmM5NmhqZXdhQ2hYV2g1SkJhRUtkekdXR1o5YVZPZHho?=
 =?utf-8?B?eE5mZ3BzeWxxRDhGTXV4KzZ5Zzd5TEFlbGI2V0RDc2hQaXBhejQrSG9UNEhD?=
 =?utf-8?B?OUpXckJWTkNub0NiS3djR3MrZVlMT1BmUUZFV1V1cUxtZG51NnpzMnlZRkNB?=
 =?utf-8?B?TklZcEJwUk5rODB0UGYvTFhvZnpqU3p0ak9GaXduN0hBb2dCcktqZThMY0ps?=
 =?utf-8?B?d2gyTTNFQW1BSjIxV1JRNWpFRGlBb0dDOUw3YzlURjZSQ2ExQVJ6Nk5WaGQx?=
 =?utf-8?B?Q2Q1SkdZODZ0dlFubWtHR09LeFozUWJSbTJTb2VUWjcvZG5BeEVLZVRNdFdT?=
 =?utf-8?B?MjhHYzIycjFaM0cwMlhJQjlwY0NVZUlGMlNuVnk3RWRrb2lMOGNFUnlOUjds?=
 =?utf-8?B?QmpCQjZYM0dlOGNTNkpsb3V2THVZRjVkYzREK01COUVHR0JMNkVOUzA2dlVP?=
 =?utf-8?B?MVU4UjdaK1MrUitCeGkyL0JsazF6MGVHQU1XRjA1SVBUQ0JndXVsTmNJNUFk?=
 =?utf-8?B?SXViMVBDQTc5OUZabUFqeDFJOXU0OFZnQVZBbTRvT1lzbGhCcXo3bWhvcS82?=
 =?utf-8?B?ME1pK2gzT0RCSkttV1ovRnlwaklDaTlvRzhkTi9INU4xZW1WTEVENlBIYmVa?=
 =?utf-8?B?dmRrQnZ3MGdYZzhoVnQ5MExlY1ZuZEhVc2xtNFZNYVNodjYwMStyWUgwZ2Jn?=
 =?utf-8?B?NEU3dWJueW1BWHhURXVsY0tuOHR2THJZVlBBdjlWb08rSmpRWnE0Q0p0cjIv?=
 =?utf-8?B?NGI2WlZjWTA1OGZuOXc4M0krNTlwaERqVWpSNGs1SHBqZWE2c3N5RitmOVJo?=
 =?utf-8?B?QnhHVmdmWkl2Zk90SllTQU9zQUpndkxtMFJtUXcwcVZoUGxDK1VCNjBIUENS?=
 =?utf-8?B?L0N3eWNhNXVhYzBYSXhnZnd2eUVPWG9lZ1FIaFNlVXF1QkVraWtkaEw3SDV5?=
 =?utf-8?B?cVhQTjFiWkNJZzJra3BMY2hCR212MXFHb0UxNGxuZFVyYjNnZ0NZVGdrdUxO?=
 =?utf-8?B?QzAvZXZidjhaN0FwZWhtM3N5YStXTFlDMFQxdXpTZlp6RWxNQ0JPa0s2VVc0?=
 =?utf-8?B?a3l6d0dBSVI3SlpZK3I0TGRJRzRrMkU5Uk9heEY1UTdCNWg4Wk5MNEkyamxu?=
 =?utf-8?B?czhvMkQzcGFFd3hSUHRkSTlQaUwvNlYyV3llVjBVL1NRUHBabkxjbW9QZEpH?=
 =?utf-8?B?SGtPN2NzZit2TklibElYckRhdEdWRmFBU3NGcmJBVUdlb0FVeStEK0VWaTlO?=
 =?utf-8?B?djRLby9iQWFDdjN3NXdsYWpxdUx3UFg0WUJxTnZrRk55STV1Vis1djZDb2lo?=
 =?utf-8?B?SVljWmtWV3lGUzlYTXZPSldzcGwyZDR3dDFScUlOdXFiZzIxMU5XRm5yNi9y?=
 =?utf-8?B?bkhLTGJ0UkJyTlZoL0wzdlJiZjFXdGY2VU1SdVNFbENZT1d3VmNTWWhrY1k5?=
 =?utf-8?B?anorUlhtbER0LzBPcmx4dFQweTdNQVpIc2FuSHVQZ3RCTXdDb1dsSFdyUUR2?=
 =?utf-8?B?azhSaWZNdmRibFdZVldxbUYxTi95YzhHN003MGRSdTBDZzZKb2tUNGxUYU9w?=
 =?utf-8?B?QTJOcGdkVERGTFk1aXZXNzVGNkoyUThxSUZ5dW11REtjaTdzaW1BeGF3VTlt?=
 =?utf-8?B?UFdkOGtrbjlKdGlBUElVSmJIZ1FBQXVlTXM5TlM0N2N1bkdtbjhucjhoOEVK?=
 =?utf-8?Q?Mj6cff?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGk3cnFHZHQ1RlJ4aTdCZk5EN1Nkdy9sdmFFVXlYM0lEZWduaHorRENacENQ?=
 =?utf-8?B?Q2JlSzg4b3M4cFYyUWJCNTQ2UnpnU00zRGxqcEdQdDJ6bWZvcDJBQmk4L0Iv?=
 =?utf-8?B?WUFVRXRoVHdjQUdBZnFwWlZ6NEhoS3g2eHNWeDdDYUxsWUNzOVlxWDE5RmNY?=
 =?utf-8?B?eWgrUXJaNDRyUFZvVGVHVGJ3UTJCVWIwTEIwc2w0dGgrR0NVYjU1SG1yWWFW?=
 =?utf-8?B?cnpieDVkRWRWODBtUTJJcG45Mkx4dm1SSlMxKytBODh1SGEzaEU4c0xwdXFx?=
 =?utf-8?B?eHVPNWNYa2FzbTNkYlVsMmplb2x2UjNMYjZhWUhWZituZ2ZXTk5Ya1VJWkw4?=
 =?utf-8?B?QisxYTcwd3hiS29tWjNvNTRDRmc2Sm9DRlVKQ2ZKQy91Tm8ycDByaTZrOVJN?=
 =?utf-8?B?ZnFZSjl3Y0VYU1pDZk9wbGdTTlFDN29VNE9sL2U1QXFkdzdYK0wyMnNZdkh4?=
 =?utf-8?B?TnErRzRIaHhQaGR0NzFIQVg3YWhCYWRwR0Y5STU2U0JibnZVZzNiS25GUGhL?=
 =?utf-8?B?Q1pKOFZYWVFxWUlZSGQrTldLOVhMR0g2UFdYblBrNitha0ZtQ0g2OTJkUWt3?=
 =?utf-8?B?TFBsdjhNbGZHNEJRQTkwQ2w0ZERjRDk2WVNEbXlzUU5rc1lVcUVxR1IwMWlW?=
 =?utf-8?B?MzJLTHJZUHZOQzFIWldnVWRrUFNvUm1QMHdpRVg2MEtKN1NJMDlGUlIwVTc2?=
 =?utf-8?B?eDZ1bFRuck1aaGV4aFo5dk9BY0lXK3RxRWJmMS9PTElFbnhreGtKNXlSZ2Zx?=
 =?utf-8?B?cGdKWG9IUFZoeW5qZy9HdkFyVzAzTGxZL3B0clRNYlBYZjZ2dCtjeFFMRFNj?=
 =?utf-8?B?WHk1TFFiRzFQZnUrNlFPMDRDaUFyK3lzR3lVWVA1ZnZyMHlOYkx6dm1kMUF6?=
 =?utf-8?B?ZEtWMkROQmNLS3RvY1pqQytRTEt6MExQOVNqMzJQaEF2MStGTURtQXlBS25X?=
 =?utf-8?B?ODQxOUJKZ25yYkZNQ2xqWTlNVnBqRHUxQ3IrN3pvcmg1TU1zblYxUVFUY1Y3?=
 =?utf-8?B?U2dVWlBIM0VpclE0UXd4VzllWThCa1A2ek82ZnZYYXIyWUJzQWdOU003aERp?=
 =?utf-8?B?K3MrT2JFUTdBeEx2TmVoOEIvN2FoWlVqSWZLVzZPMG9CUnlPWElmWmdTZlRu?=
 =?utf-8?B?L3AvNzBjeFp4YnFhOEtEYWNGc0tXUXoxUlRDNXVHdllBOVhPOENBRnNhM3Ja?=
 =?utf-8?B?TGZzZ0luclVZZlprNHIzSTY3ZHhRT0xlL0FBSzhmR2owY1ZuN3p6YjU2VEIz?=
 =?utf-8?B?OHRYL2xVRXgyQytYSFdkSVhTQjFCUERvTlcybGlKcDAzaklUU2ZCZzBqanUy?=
 =?utf-8?B?WHM4SlZDaVhkcWdQTnpQa09XMDJUN3lNaSs0d0ViTjhZTU5ieXNxcCtCRWxD?=
 =?utf-8?B?ZzFMNm1TU2g1MjRQemN3TjM1djY4Y3NDSUlxT01hVzk0V3kvK2xNTkp2MnZV?=
 =?utf-8?B?N0Q3ZXFMVnJhU21Uc0lUd25WbzQyUFJHa2Y4bURFREVkSUxlcW90RHdZTmVa?=
 =?utf-8?B?eHkvRXRDVVV2V2pPQklFcVMvOUtXUThTL2ljV1NsVDFuNDNmaFo1VmtYRkt5?=
 =?utf-8?B?dUVQUWZCekM0c2w1cTFSQlgrb3BjRk9BMFVJalRwVkxoaXVGczJLS2Y4K2Vy?=
 =?utf-8?B?S2FhVGxXMFZwMFEwZUN1eVpBS3grZTVLODUyY01aZWdPTXJBYmtCLy83MzAr?=
 =?utf-8?B?aFlLNGJaeDF2YU4raEhnUVZQRE5UNUlHeWJvNTNmSC9DbkhzUjVNUWdHaXU2?=
 =?utf-8?B?Y1RPNDdwOXduQjNla3Y2Mk9mdi9hb2Z3SmQvWDJlSGRiVjd6WG51cFhydmlR?=
 =?utf-8?B?NzFENnNKWVVnYW5Ub05VblNCWFk0QUt0UU9jSy9jNGlJS1A2ZWxCUVNYMHlx?=
 =?utf-8?B?S04rRmJjd1pmak9scWFmM2RKRVhBUHphN1JqNTJkNFlOaTJMNHp4dnIrYVdG?=
 =?utf-8?B?Zk9RcytGNUhjdFlkSU12UHMyOU5KRmIvaXFraG1PM1FmMkRHekxyTXE1b2x2?=
 =?utf-8?B?UnRTNDFMdHdqelplVmgvajJZWmJKc0hHbm15Sm1XVnBKY25xa1doRHNZYW1H?=
 =?utf-8?B?aU9IZFNMQVRoRTZkbWdIandqazJLMDNMZmxTR1pOMzVnUHc5OG4zK1pCMGgv?=
 =?utf-8?B?dW9Zcnhyd05QcTdSUzRQWi8rQ2ZETVlVL242Y25NOWl6M0VZbWpXNC9QakYz?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1217A2B95627E74FACD14F31AC9DF92E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324d8e05-e430-418e-7a43-08de2b925d10
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 19:47:55.9422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7mxpOhIONe3NLkRquhoeEZJ2viipm6FqxTqf3pbo8ioySXZjWucJnoX906TRzjVXUtiGfpIH9bXUIsfI4etIlq8n+tULwZ/ufaacaZL0G1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5783
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTExLTI0IGF0IDE3OjI2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IFJl
dmlld2VkLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQoNClRoYW5r
cy4NCg0KPiANCj4gT25lIG5pdCBiZWxvdy4NCj4gDQo+IFsuLi5dDQo+ID4gQEAgLTUzNSwyNiAr
NTE4LDE4IEBAIHN0YXRpYyBpbnQgdGRtcl9zZXRfdXBfcGFtdChzdHJ1Y3QgdGRtcl9pbmZvICp0
ZG1yLA0KPiA+IMKgwqDCoAkgKiBpbiBvdmVybGFwcGVkIFRETVJzLg0KPiA+IMKgwqDCoAkgKi8N
Cj4gPiDCoMKgwqAJcGFtdCA9IGFsbG9jX2NvbnRpZ19wYWdlcyh0ZG1yX3BhbXRfc2l6ZSA+PiBQ
QUdFX1NISUZULCBHRlBfS0VSTkVMLA0KPiA+IC0JCQluaWQsICZub2RlX29ubGluZV9tYXApOw0K
PiA+IC0JaWYgKCFwYW10KQ0KPiA+ICsJCQkJwqAgbmlkLCAmbm9kZV9vbmxpbmVfbWFwKTsNCj4g
PiArCWlmICghcGFtdCkgew0KPiA+ICsJCS8qDQo+ID4gKwkJICogdGRtci0+cGFtdF80a19iYXNl
IGlzIHplcm8gc28gdGhlDQo+ID4gKwkJICogZXJyb3IgcGF0aCB3aWxsIHNraXAgZnJlZWluZy4N
Cj4gPiArCQkgKi8NCj4gPiDCoMKgwqAJCXJldHVybiAtRU5PTUVNOw0KPiBOaXQ6DQo+IERvIHlv
dSB0aGluayBpdCdzIE9LIHRvIG1vdmUgdGhlIGNvbW1lbnQgdXAgc28gdG8gYXZvaWQgbXVsdGlw
bGUgbGluZXMgb2YNCj4gY29tbWVudHMgYXMgd2VsbCBhcyB0aGUgY3VybHkgYnJhY2VzPw0KDQpZ
ZWEsIEkgdGhpbmsgdGhhdCBpcyBhIGdvb2QgcG9pbnQuIEJ1dCBJJ20gYWxzbyB0aGlua2luZyB0
aGF0IHRoaXMgY29tbWVudCBpcw0Kbm90IGNsZWFyIGVub3VnaC4gVGhlcmUgaXMgbm8gZXJyb3Ig
cGF0aCB0byBzcGVhayBvZiBpbiB0aGlzIGZ1bmN0aW9uLCBzbyBtYXliZToNCg0KCS8qDQoJICog
dGRtci0+cGFtdF80a19iYXNlIGlzIHN0aWxsIHplcm8gc28gdGhlIGVycm9yIA0KCSAqIHBhdGgg
b2YgdGhlIGNhbGxlciB3aWxsIHNraXAgZnJlZWluZyB0aGUgcGFtdC4NCgkgKi8NCg0KSWYgeW91
IGFncmVlIEkgd2lsbCBrZWVwIHlvdXIgUkIuDQoNCj4gDQo+IMKgwqAgwqAgwqAgwqAgLyogdGRt
ci0+cGFtdF80a19iYXNlIGlzIHplcm8gc28gdGhlIGVycm9yIHBhdGggd2lsbCBza2lwIGZyZWVp
bmcuICovDQo+IMKgwqAgwqAgwqAgwqAgaWYgKCFwYW10KQ0KPiDCoMKgIMKgIMKgIMKgIMKgIMKg
IHJldHVybiAtRU5PTUVNOw0KDQo=

