Return-Path: <kvm+bounces-21279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9946B92CCED
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C441B1C2097F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E284F128369;
	Wed, 10 Jul 2024 08:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNlcAnBm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61386AEE
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720599934; cv=fail; b=gFyNDfzUJkVV/L33Xf8G02+PCxgpEu4+gyaH27N78N0qHssdQPqkomQjmLJgEy3nWnGBv7EDdWzu8R1DkcsOz8SJen0BEf61desmCiwdTDGI4qZMa+R67U+fiBmIpW0FUUV5IsKqwS9mLp3ffT/aIZ6ajlfDjhBdpClpTTy3BAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720599934; c=relaxed/simple;
	bh=jTof2D+IU9foq19LADNm96h1zVQ82fVwOF8tIx4MDIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZNbcZxPOnGh++Vwl4ul7HzGqfpRCO4MGMsq3zfzzEpyqYms/N6ojdbIw21WouPPN6dN0tJhcc7V4DLr9/ng0dIZPnMFl6tbSlD2XncaRgLAehxbuIC9bHNR4VaRM9rKnhz/ugqJp3yWzdfkBaNk9Q4krJx2VwBH02fFBhG4zKT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNlcAnBm; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720599933; x=1752135933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jTof2D+IU9foq19LADNm96h1zVQ82fVwOF8tIx4MDIg=;
  b=bNlcAnBmY8YemUgJUIh1nfoBE3sAw87bcFxchgvr7la6oRRypyxYtC8D
   Bb75d9J/yGXWLdzF6FmBCJqkVvYF48c5Fm3iDmYowPM7jGBrAy2YOOTdF
   znaBj2hu1pGNcemY152ALD97HRX05rsiR4Z3BGzSt3cXsE7MyZA3AXAth
   AoonVwAWAybgpjaUMknqFJHvP8pO+ZYIXDRS38hY6QM3XzLBzdBGS/6u4
   JPqx/AwiriY6bZOlDR57yKa1DKi3KZGrDNqQquT1nnp2ox5kzJuBvOjRt
   MQBGq3tQibEcjXDsvBCR3APXl9dH97ouXS5lrXvZwnitGFFV75iCvrvQ7
   A==;
X-CSE-ConnectionGUID: /jP0vf+ySD6V4byfFaASlA==
X-CSE-MsgGUID: TbcLJ+QNSXmoExDQgfa4SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="18044970"
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="18044970"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 01:25:32 -0700
X-CSE-ConnectionGUID: jecMjGc0SDyX5FaPMV7yQg==
X-CSE-MsgGUID: yv29Vh9RSC+0y0yp+2Dthg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="52429787"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jul 2024 01:25:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 10 Jul 2024 01:25:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 10 Jul 2024 01:25:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 10 Jul 2024 01:25:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOzKGd6FGwJFVpwPpD/9PLSkaZQVHX9TXZvFYK8szu+N4stH7PXxTfbuq3X14IF9+GkwoeO0iouJQ+PF4tThaBmdAcg/NZVRV4pl+vDmdFFSAxgG+FjjmAJK0L7qZ5Sz6u+/BrepHjdNogc7gDrQt78aAjVWUR1x4Yz1HCQHKnF7zNFn/JsvRggRtjucKSYrARngQ4lDqGiZD20f5ixCG6iryk31YsLHG2begnjzDNpttN4mpsMxbefF2cZlNjlw2dpvs3dhn8jUtLLpQnMzYLlrltJz63v39t9erxllA0c2nOT29dOTKUKn1P6rSeQrUwqoZE6i4jC+122M1jhkfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTof2D+IU9foq19LADNm96h1zVQ82fVwOF8tIx4MDIg=;
 b=WXDP4InnFPy6LVISiO2aCO8Iv2Nsho7yPpLS1hc7D/kZEKbPZJyeD97DMMEwdezX+peiA6w5wP7scw6DA3wEG8mTn1/u9HZwxteSlqlrvGaiF8fFvA9bzueT1y2z/WdBLraZNFUFtTlnYwwAOpkMdhUU2jvaKhjxXZK8FBAewBUd6yXTg+zL0vDV1dpSbB/GDaaeGLgNUFoye6Uigsw3PN4fIgEqkfDixbWa1O8wpl/eMt8PeXacsk8o9Uex0Vg6R6zqrRZOaCYXGRMcUiEViVSM/Oo1VDPWwqF2qu+6Kwj19agn/SX/5CZICdA93u1OKNmmvCvzuL5Fp44tey9kRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5151.namprd11.prod.outlook.com (2603:10b6:a03:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 08:25:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.016; Wed, 10 Jul 2024
 08:25:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: [PATCH 2/6] iommu/vt-d: Move intel_drain_pasid_prq() into
 intel_pasid_tear_down_entry()
Thread-Topic: [PATCH 2/6] iommu/vt-d: Move intel_drain_pasid_prq() into
 intel_pasid_tear_down_entry()
Thread-Index: AQHayTkBZLuHlPPhR02ROwk3HbPpwLHc7KOAgAATSoCAErLEUA==
Date: Wed, 10 Jul 2024 08:25:29 +0000
Message-ID: <BN9PR11MB527613F44AF9CCA181B681718CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-3-yi.l.liu@intel.com>
 <8e2bbc1a-f014-4fd9-bbb9-c6e5e47595f3@linux.intel.com>
 <7785947b-3ff4-4c5d-93cc-cb54dcc0a5cd@intel.com>
In-Reply-To: <7785947b-3ff4-4c5d-93cc-cb54dcc0a5cd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5151:EE_
x-ms-office365-filtering-correlation-id: fb9a8a24-44fa-4470-e82c-08dca0b9db84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aXg2M2FVV2RUcFY5dEZzb3RscC9KdStyenM4ZW9JaE9SN2hKai9ETm1hZjgz?=
 =?utf-8?B?c3pzaDNxWFRwZWpzTEs1b0lmMW5CTTd6aHNYamEwK2VuZ1dhSUpqVmx3d240?=
 =?utf-8?B?alZPV1RkZWhrbnROMHd0bGtjVUJpRHBvd1J0dHhERzZySWQwWVFyRFNLUlpj?=
 =?utf-8?B?eStoNVFkcGFmVWFTSW4vSHgvQWlmNGZjTGV2QTFJS1lqdFBLczVWbUlnbzZY?=
 =?utf-8?B?U1d1eDZVSzM3cjRuUk0zUFN4bndyUTFGeSs5RyszalY3K1c5YWVCcjZIUGcz?=
 =?utf-8?B?bXNuYkt0VDJibG9DNzVFYlZrc3hndGJJcUZDQUpVdURtK1h2S0RZQXI5Uzlk?=
 =?utf-8?B?YUdjd3dTRXh1Y28vUGVDU2k3L1pRYUV4VTJJSnNSN0F6T1grRGtZZzRUSDVY?=
 =?utf-8?B?V3FwTDRCbU5ZWElTeUJEQmpxSFBLVDJ6ZDRBUS9TaUZIRDd6anhZRnBwNnBW?=
 =?utf-8?B?ZFFUNU55UXlrdVJxYTFlbGwwa0lwajN6UzNSV2EybWxydVMzTEFDQXZvYUlM?=
 =?utf-8?B?NEgyQ2kwSjRaQzd0R2JmeGFZRUxWRkgzNE5VWWsxTHk3NzE1ZzZLZzBYUmNz?=
 =?utf-8?B?T05pck43eGUyL2xadGdSbmxSR0c1aHhVQ3UvcE5iVWIxNUVJV3U0VFB2TUZp?=
 =?utf-8?B?SHNGOEIxRHR0QzhsZ1JRd0RLUkdmZG9GUzNqSzBDVCtmWU51TlZkS3hNRENm?=
 =?utf-8?B?T2Z3VWNDRGxldktzUkE0VXBqZWphY2tKRmZTOHBadkZscTdqNk5wWnBFajFa?=
 =?utf-8?B?SVE1RVpWS29md3FoSndMb1UwNk41TGtSVmExcTZBWEsxeGQrZFQrM3B3OXFU?=
 =?utf-8?B?Rm5hS3hPOWk1bHlzNTFoemhaa2NYRkV0QmdEdHkyTlgyK0xKVWFhMy9HVDNK?=
 =?utf-8?B?aTlmWGdRVzB0R3I1b0hyTTFBckpJM25XN3lqdmRFcjYyZ3pBTnUzcGVoZXhH?=
 =?utf-8?B?amx5Y1N1NUpxeUY3dEJBajdsTFQrYTA4dXZEMGh5TGtmQlVmKzlGSSthdzRr?=
 =?utf-8?B?SmpiQ2RyMSsxTjdKSE5Eamc3OG1xQUZHY0NES0I5RGxYZVE5NlJXQldnbEds?=
 =?utf-8?B?TGdVMEs3U2FLTDBvZTMzYTFvWStpbERUdEh5TGhNbCsyOWpGZmRpU2JtZFBU?=
 =?utf-8?B?MllhUzJlZHRMSDBXeWxMMnBFYXdMQi84ZWNXcDdHd0RRaU9ObE5mNTVwVHU2?=
 =?utf-8?B?UGlZaXhFZjFyUHRnWVV2T01xQndxVEljUHlKM2NlTVNkaXlmc1pnSkc0Y3U1?=
 =?utf-8?B?SU5qQ1pqUTZKanZJMTkvUmJteTNKdWlIb0luZVBtWFJ1SDVaRkRpVWxFUUJw?=
 =?utf-8?B?K0VFNlc3ays4dGxqZnZndktiR1VvdmxIWFlMS1UwVFNNa0ZHODRkNnliWWcw?=
 =?utf-8?B?SGNsNmd3OUxFVWZwZmlVa29YckZxb2tXbFEwQjZESzZQYm9vVG5KYnFieGRG?=
 =?utf-8?B?Y1lEblh4TWFLbmpoeElweTJCNmpQNlJQcFhhV2tPengwTG1MZ29xMDkyK3p3?=
 =?utf-8?B?cGJDQ2JZSDVmWjllMXpXQmtabDBDZThOK25QUEdsdlFwMHhmWUlSRFpuYzk3?=
 =?utf-8?B?SVlBUkhQekpQenRJd3NwRDJjaXVVdlo3dU1mL0ZlSmF4YXVvWDRSbG0zekNR?=
 =?utf-8?B?Zi9QeW9JTlNHeXBxbldtZ3lQOU9objNjd2ZHS0RvOTRmV1RnTlVMemZySzJE?=
 =?utf-8?B?MFNZT0tFVFgydTlPNTZvUUhoZjhVYTEzajhqZUNoK0dLZ0M5cUF1OGl1NW5t?=
 =?utf-8?B?cEF0TjJtQjZGN0JINmlLb1FwK1BISmVWOWlsalNEYTVlcXlZcFhRc2k4c0xr?=
 =?utf-8?B?dUVISXZOMkF5bDc4YnRiZDF3MzZrZXhVb3lwSEhjZ2NJVkc3V1BBaFNwTTU1?=
 =?utf-8?B?YmpFa1luZng2YXBvdlViS0VvMy84eDRuaysvRDdUL21zTkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmZ6OVpIRjZ3dk1oTVE3R2pVNVZYdmpKTDBYR0NyU2s5VDBVSnR5cWprNXgz?=
 =?utf-8?B?RFNKTmRwQUE3dFl1K0t3RGg4WW1Vc0s3Q25scTRFZzVTUmF0c25aM1Jndjcz?=
 =?utf-8?B?bTcxMjdYam9iRnQ4SjMvWmhGQUluWGQ3Ym1CQ2F6N0lSVjl1dzJIU0VwNlV5?=
 =?utf-8?B?VW1PQWVwNXlkYm5PYmYrTFNVVlNrbGc0SnZyZjlSSzcvMWVMRWhYb0FDdTdF?=
 =?utf-8?B?a3lOQk5OODVyRXBlQ0dHanJZb0JQQko0NHV4T0VETnd6MWtpY2tQdURoRDJZ?=
 =?utf-8?B?dVlSVFdpSDB1cDNHdmFRRlVLbXVON2xlaU5uWnh2M0RmSDNreG8xN2dvSTJC?=
 =?utf-8?B?UEtEdnVyRVY0ME1HSjF0MG1tQzZXZzRBTXlURzlQU1p6ZTg0NGxwQWtxVkVj?=
 =?utf-8?B?V2kzeEJpbzlOb2Y2SURzd0dWRkt3c3dpVTVvTUZGSXlLcWtmRE1nVFBrVzFS?=
 =?utf-8?B?SnBzMGY4SVRkMnlKYTdjMzJuUGtHNlhSdFFGRmU3WGlZMDJzeWFkdWhYWTI4?=
 =?utf-8?B?cWg3ZWk2dmd6anpER1I2UGo4UnBRSjZDVjZZaWdIUmFWYkZSMmpENm9vWkVQ?=
 =?utf-8?B?UmY2VDVxRUR0WjlZdHN4VHQwVkhyZmtKOFpsRlVjSUVURTlqcFpMSCtOV0RG?=
 =?utf-8?B?OHdZbWhuUUc0b2IwUE1PZjBrd1VGNE5zUSs2VWpBbGJIdDRHeDlBeW5ndmlO?=
 =?utf-8?B?QVNLTCt2TVdlS1hoZDFONUJ4NXNDcHVWaVpNL1g2aWdEZHNsMU1Cd09wNUs0?=
 =?utf-8?B?VzRxVk5SWXRmbDg2ZlFFRXpKWFEydEF1YWhuTkoraFIwbkdYSWRhOXNCM0lQ?=
 =?utf-8?B?Wkp1cGRJRU1TQlZzZzZ1emRSckcyaW5MUVRMS3R4TDIxY04zZlFTT2phT0J2?=
 =?utf-8?B?NTNVWW00WW4ya0hvdjB4K3lOVzNCMzVNdkZGMUtUSlBNa0VVQ0JOOTdGWUVY?=
 =?utf-8?B?czJqL0oxNU53RGd1K0M5WVlOSTMyZVhIZUFoWGF6TURhVjU1TUFaZWtlK0V1?=
 =?utf-8?B?YjBidG1NZlYxR3RQYXJ1WkM3eVl3YXMrdFhzVkYwdzJPUEdFTmxyMU0rUDFE?=
 =?utf-8?B?em1oeHhPdWQrQjBVMEROMTJFZUcxWFB1Zm1OTk11MmxiTzA2TDJjRjU0Unp6?=
 =?utf-8?B?bDRkbkxNU29sSVV2UHM3bUJkSFVsRjlXdURhVVQvMHp1TVZnMXB4dWdtZm9a?=
 =?utf-8?B?RmJnVTkzVDYzK1N1dEUzRFNydFF1TVlNZ2pkcW5FRFF1NmpsVlhxdC8yWm1a?=
 =?utf-8?B?OVFLa0JObEZ6SEpJQVNlSm1mNy9ubzh1SW43Zlc5dEFEOHJDc3kwNVNmRkJF?=
 =?utf-8?B?ZVI0WC8wekh3K0pqZ2xnckV5eUp4N3VtUnVwVTF1RmRNWnNMd3VXSGRXOVJ5?=
 =?utf-8?B?bFhPdjJLZFRNNzM4NzJqUE1seFlVNERSTkg4UUlxTkRzUWhCUGphTjJOb2tB?=
 =?utf-8?B?N2JGdXNIbzJleFltMDBmUkZwK0pBUUEzRm9aOFRxNEJteTNwZldnZUJaWTBx?=
 =?utf-8?B?UFpMZDRzaTVlcG5PeWwwK2pQcER6NERPZFNJNTU2enovM0tMelpDL2s2RVY0?=
 =?utf-8?B?M0VqM2JpeXgwbFF6NG9mOENGKzBXTXpZWjNjZWw5Y2xmQWZtdnBPNzZCTnhw?=
 =?utf-8?B?Rm5SY0txdDljTEJPb0JVelJNOW1qc0J2bFlCeHZnSVFBT3pyajhDN2tvMEYr?=
 =?utf-8?B?Y0t4aFE0dnM2Y29ZSE1qTnp3YlJyazRyVVRVdmlyai9sTXVoUGlmWEozK3RB?=
 =?utf-8?B?YlZjNEtEaCtXQUhRbHpaYW1BQk8rU2lsdE5qendsbk5kZlNHQ1pMcDByNEJn?=
 =?utf-8?B?bFB0OXNhOUdhV21tK2VrZGZ6NXhYSEdva0s3VVpnWDlPL290QjhiUnVldktS?=
 =?utf-8?B?c0FWU25kR3JsbkRSQk15cTRQejVBRitMMnhmeUxBVHFlS1JJYkQ3RXV5TDBm?=
 =?utf-8?B?RjV4TjFJcDBCUmJpK1pxRVEySlprMFlWN253MzI2cHE1YTRKZStZTXdTOUVY?=
 =?utf-8?B?bHE1YlFDOU5tSkNoRjlRWUVWZDFqek9ldWkybzhTMDZVOVhXRkZLS2JQZGlE?=
 =?utf-8?B?VG92N2NGMStzZERqUXhudVFMSkY2MXNZS1FRTnBDR013a1BQdnVBb3lONWxV?=
 =?utf-8?Q?RerSLb6cLPMqsIPK6qMTcqjiN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9a8a24-44fa-4470-e82c-08dca0b9db84
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2024 08:25:29.2026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2K/s7vO4Fjv+aVd5GBgkqMH/M2j1lhwbpFqIIqAJ1LB2lmd+4BXf/QQt9NwoopVkvKeA03ZuPEGkqFvw3SbssA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5151
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBK
dW5lIDI4LCAyMDI0IDY6NTIgUE0NCj4gDQo+IE9uIDIwMjQvNi8yOCAxNzo0MiwgQmFvbHUgTHUg
d3JvdGU6DQo+ID4gT24gMjAyNC82LzI4IDE2OjU1LCBZaSBMaXUgd3JvdGU6DQo+ID4+IERyYWlu
aW5nIFBSUSBpcyBuZWVkZWQgYmVmb3JlIHJlcHVycG9zaW5nIGEgUEFTSUQuIEl0IG1ha2VzIHNl
bnNlIHRvDQo+IGludm9rZQ0KPiA+PiBpdCBpbiB0aGUgaW50ZWxfcGFzaWRfdGVhcl9kb3duX2Vu
dHJ5KCkuDQo+ID4NCj4gPiBDYW4geW91IHBsZWFzZSBlbGFib3JhdGUgb24gdGhlIHZhbHVlIG9m
IHRoaXMgbWVyZ2U/DQo+ID4NCj4gDQo+IFRoZSBtYWpvciByZWFzb24gaXMgdGhhdCB0aGUgbmV4
dCBwYXRjaCB3b3VsZCBoYXZlIG11bHRpcGxlIHBsYWNlcyB0aGF0DQo+IG5lZWQgdG8gZGVzdHJv
eSBwYXNpZCBlbnRyeSBhbmQgZG8gcHJxIGRyYWluLiBXcmFwIHRoZW0gd291bGQgbWFrZSBsaWZl
DQo+IGVhc2llciBJIHN1cHBvc2UuDQo+IA0KPiA+IERyYWluaW5nIHRoZSBQUlEgaXMgbmVjZXNz
YXJ5IHdoZW4gUFJJIGlzIGVuYWJsZWQgb24gdGhlIGRldmljZSwgYW5kIGENCj4gPiBwYWdlIHRh
YmxlIGlzIGFib3V0IHRvIGJlIHJlbW92ZWQgZnJvbSB0aGUgUEFTSUQuIFRoaXMgbWlnaHQgb2Nj
dXIgaW4NCj4gPiBjb25qdW5jdGlvbiB3aXRoIHRlYXJpbmcgZG93biBhIFBBU0lEIGVudHJ5LCBi
dXQgaXQgc2VlbXMgdGhleSBhcmUgdHdvDQo+ID4gZGlzdGluY3QgYWN0aW9ucy4NCj4gDQo+IFNl
ZW1zIGxpa2UgbW9zdGx5IHRoZXkgaGF2ZSBjb25qdW5jdGlvbiwgd2hpbGUgdGhlcmUgaXMgaW5k
ZWVkIG9uZQ0KPiBleGNlcHRpb24gaW4gdGhlIGludGVsX21tX3JlbGVhc2UoKS4gR2l2ZW4gdGhl
IGFib3ZlIHJlYXNvbiwgZG8geW91IGhhdmUNCj4gYW55IHN1Z2dlc3Rpb24gZm9yIGl0Pw0KPiAN
Cg0KSWYgd2UgcmVhbGx5IGhhdmUgc3VjaCBuZWVkIHBsZWFzZSBkb24ndCBhZGQgbW9yZSBib29s
ZWFuIGZpZWxkcy4NCg0KTGV0J3MgZXh0ZW5kIHRoZSBleGlzdGluZyBvbmUgaW50byBhIGZsYWcg
aW5zdGVhZCwgZm9yIGJldHRlciByZWFkYWJpbGl0eS4NCg==

