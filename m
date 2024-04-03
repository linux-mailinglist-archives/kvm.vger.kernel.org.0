Return-Path: <kvm+bounces-13420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BFA89635D
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 06:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 127A1284C27
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 04:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED83543AB4;
	Wed,  3 Apr 2024 04:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h0+MzpP4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AB319470
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 04:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712117704; cv=fail; b=H5xl3as09CFYpgN3Ltjv2ZjxdIM62Uz5VWBBcpfOVhTsDskj1ed4TxM55m8Ke3Wvg2KY29k+2ceG+dFBuxdnYNZXTJrdfZWifsOiZqVnOngRuGSkTHiBSfEyPC8zPFpA0V9WmNQqVWRea3Qp1XXvgmguZh2ODDagkBeYFZPICow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712117704; c=relaxed/simple;
	bh=4TlZcN1wxbd9T0MEUM7RXJ/I7xipjTxvcz/Y3ulHCN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nkqrQ2+pnvhhbj19THZtTZ3lvxuXAMu0KpZ5Fg/Txssy45cYat1Pzn8KFh2Xx8Y2SV8Rtka1ALozYiqauofI7xQLOUjod8c7rIbH9+unCAYZ3UMjL+hAmIfspXfAbzFh++m5mSvqQcdEmiVLzkx37Q9AGaZCLuRNxVpwBGXINKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h0+MzpP4; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712117702; x=1743653702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4TlZcN1wxbd9T0MEUM7RXJ/I7xipjTxvcz/Y3ulHCN4=;
  b=h0+MzpP4aS8zO31zQmTwIiwYjxASAJ1IPwCZBYwBMR6ns4EKIDYnO/Hy
   ZRuw5SLSBZVVHSwLUpTSGiT3Wb6cqtN9L0uIVISbg53CMVoF1VmxZnUpB
   bLQDYWfX60Zex0o3LwsLVapbRYL2WVeRxwS6vvrth5QHn459QjRGnP9iT
   eioxBGDjQMEQK0r9usVMRElKC7fIUGEEn5w07cbhV1rcZxT0uPRqJTHpT
   QetkiBTDfwRLA9Y9Ffdue5JD4pT5/hbD/mTa6tTQmpGeKctAyuOEF3X83
   Huw6NzdORMrcl6GdpxVYw+KgFQJ8SULHGhPZkqRJNmdun7l7wzHHsCGMH
   A==;
X-CSE-ConnectionGUID: wnTojZQvTXu9oi9IDwBFwg==
X-CSE-MsgGUID: BPvJdh46QjG0h9vc3gRmsw==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="32719359"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="32719359"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 21:15:01 -0700
X-CSE-ConnectionGUID: gkApMC+oQCCkZ9bac7dQMw==
X-CSE-MsgGUID: ohhHU3jcSXef3yaZJ8bdtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="22760697"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 21:15:01 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 21:15:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 21:15:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 21:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaymqkZN5KOdj79r9j0/l+RgCXrLOdaecA+M9GOy4ajEswImQMx+oh6aLbDRIXxy5jfamMFsXIWt0dHZJVTpPtxbJhCNJLJkqPgwN7SD7rB+RwxemLHGq5wA7bjWZg4eqZ4mWspI3C1apMUHkpTFa5FRzucXL2Nr88b8rBpeAzVPdDz4GMMsKkH2o7YwyHdiyovgP8vSTKBRlv3FAZK2d9D/PMIKXr3qJLsx+c38JGSmZtQrpGXRCCZlMYJa5qj0R7iA7u0U0Htq6TD48RK3NSfGjkGIlUtzFQ9ff3ye/etju25BSKEXQ+Zh5XJfgcA459j0XJHqD5CbbuLzW1vtZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TlZcN1wxbd9T0MEUM7RXJ/I7xipjTxvcz/Y3ulHCN4=;
 b=NF+581hPZJUOCPgJNA00RH/XQoWeh555icNuq7pRB/jQ6RjeoEPgxsYK8OZPLl3AQa5oeJwL/2Ukr5Yjwt11LHW+eetnXY1iNxjefLqptqYcB7/RPCv2/AjKTSEMVbcNr67X+W8yZf59Q7JoJg0b+xpTinloPpeqycFCvr1EY17JF7TvhRT+sx5RhbguAi7DFPe8DYy0JOkNV9UAg/NUK4rp1U+aDXv++AxuBu5vAtmhFTw4cVnW8m7jd1RB9CMZbCoQRtwTFUBn48xI2vMBDsz9KtDRoaquwiau+rZtfKC0uEDQYoclG7iA7VZF7c0Ai8dHHbZRsvRDvVKf25zD8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by DS0PR11MB8667.namprd11.prod.outlook.com (2603:10b6:8:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Wed, 3 Apr
 2024 04:14:53 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::e4a3:76ce:879:9129%7]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 04:14:53 +0000
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"Tian, Kevin" <kevin.tian@intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Thread-Topic: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
Thread-Index: AQHagQuswU7tTG/G0USa/UYOZse2O7FN+kcAgAfouQCAABWFQA==
Date: Wed, 3 Apr 2024 04:14:53 +0000
Message-ID: <SJ0PR11MB67441B8B896A87821F529C66923D2@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
 <a1766e58-eef6-482d-a401-7fbfe6063023@linux.intel.com>
In-Reply-To: <a1766e58-eef6-482d-a401-7fbfe6063023@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|DS0PR11MB8667:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iVBogOxg1rdCStn3ptVJeaJICPPc/OjbAaE78F/K75EN2TZUqvztBmm49LkVYvTQZ2rmb1nMHMlM6kTBJyXiwfvR+Bxo28GsGV4HJIyZfq+rBXyh+WTruyOx1CgxikVlGiR3/6WGHtTPs0mD9yQ57bJ4FgGafT5jZ2prpRofZEUkYkWp2y3FDwscVQvHZ3ogcQtMAAXEZYajaYcEDXDTKwyyHvXntiOUKYjmwYBjBxhp1/+UNUj/Xvt25xzfOLDjbwpyLkL/Yvwesh20nOP+vcWErCzce0ePxwNqzwLvuWp4VJMHQERGOy7RIWGVZ9xTN/CUPkaDG1Vtlu54OU1+B+ONEBHacTZ1Mes+OmV4ln44jSN35uVx+1Rnat3rhHJGM5k+X4kvVwazwbcQ/bc8rEdBkpFwbjgTyo8po8NaBrmouewRzVyOGrctInxLUOT6C4D8bVC5OKndm4QFA9IJSfbF3JV1da+bzKgvsnjk1TGlP1PHbbNvkNbrLwopQuw5qmgIViHSEZ0Cym+5tOERdHQk4FtAncAxpiB5gMTTIveAv6aqbGuvTCeG8f412zTtNo6UpEsYJUxsOLIKOVrqWYOQSVN/VeuCkaCFJ1lQrjERBh9xhKikRQf0iFgwVnLWnqL5rT8lMMdSC/tg/DRV6ov9N857HZU/ddoBRh3Zt7Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjhDNThJN3RWY2FhK0pyc0RCbjZhOWxmUDlKalFvcndtVWJNRWo4YW5Eb2pF?=
 =?utf-8?B?TDZUWjNaa2orOFRUWE50ZFVjelAwelpzemxIMVhIU3NnbXVKZ2pFNW8xZEJq?=
 =?utf-8?B?MnYyVW9FbWM1bDhJUUhiankxaFNiN0FGU2JtUExnNWszV05ocnkrNGJHdHJ0?=
 =?utf-8?B?VVUyVFhmYXdBZ1hqY1hSbndVSmxidEJjV2VpZUNrbThDWUpYeE5vdGhEUmdi?=
 =?utf-8?B?R3dVa3c3UkFSa0JTSWU4eVc5K041VkU2NTh5VDFJVnI0c0JnUGxmSDZUV1RT?=
 =?utf-8?B?ekYrR0dsSG1ZTzRkOU85bWtXTXNlMm9qWllrTGRBMXI0UUhLZnI5Wk9yQnBC?=
 =?utf-8?B?RVJseXJLTlVzMEY1eVQ4a3dLRHFXdUovbFVGTEZUQ3ZJb0pwakJPQzlEMUx0?=
 =?utf-8?B?UG1NWk5mdzczdzdJSU4yUnRxSkVHd0luNHU1WjJ1MStXbTkyd05GaXBxN08z?=
 =?utf-8?B?OVZiYnV5ZjYvOW11Wnh4UjZCajNmOVgyZ2hhTGZrN3RuWXptVFBZOEh4UWkv?=
 =?utf-8?B?U0hmdzc4OXFqQXQ3UTVyWDlqTkEzQUFNN3ZHV1B2bWVQT0VOd2hMc0FzQ2pk?=
 =?utf-8?B?QXBvOXE0M3hjSDNMUzJPZnNzRzlNV0RreGlJNWNlajJIS2U4dHpjbndwdjJk?=
 =?utf-8?B?N1Q0U1JWdzUyTzd6Zy9FcG1mdEZ3SS9OMXVHbkxnVDBFUkl4enpReXNaT2xR?=
 =?utf-8?B?S3VHeEgwME1ibGp3c3JQRzVybHlnK1NVelhYdEpsenZUMHIwZmpEcDFiNGQ5?=
 =?utf-8?B?bzB6cXJEZnprd1NndWZHeWpsN2hySjJPSWdWRmd3UkFVaHc5Rm1oZkQ3eEpH?=
 =?utf-8?B?STRoZEk3UHR6ZGplRG8wQUlNYUsvV3VtNmZSeFlpcHFGakVvdEUzWTFJVVVl?=
 =?utf-8?B?SVhJWnlxRER3Ry9OODBqQ3JYQ0FpdUVXTERQbTdLeFFpNkg4d3JKaUxzSGgx?=
 =?utf-8?B?enE3cytRbEJwbW1jQ1NDYmtsMC8xYzRQenNUbzFxTi8zMjJwMFdtR1Jya3JC?=
 =?utf-8?B?TFFuUUF2RkVnNnA3U2ZpWktGc291V05xK1VMdnV6M2ltQ2hDZmp1Q2N1YWFN?=
 =?utf-8?B?RTAxbC9wKzJ1THVuTURERDVuZzFNSTVGVisrWExTdnI5OTA3THB5SXhrdDUr?=
 =?utf-8?B?QWVhMWtQWmI5d2F0Qk1hTHR3N1kwbEpDTG9YeG0xVndINk0vaDIwOG1OTlJW?=
 =?utf-8?B?cStNd3VsWDhRL0JmQWxoS0lkcFpyem5ObWRtemxhTDBScVMvQUd1dUlwR1F1?=
 =?utf-8?B?dE5oVnBNSGlheko1UU5LZlpCRTFwNFZySnMwSFNXK2dHTElFSnJZMVNSWm9U?=
 =?utf-8?B?aFVjRGROTWs2UGpMWGJuZ1FTS2ZGelcvck1wZGIvaFc2cVB1RG9PWWs3akNT?=
 =?utf-8?B?ZjlaaTlwaWhraG1xR283cS9RaFNoWlBmek04bVlmMW1pY3hhdTNtQlcwVVdm?=
 =?utf-8?B?UFJpSnhxamNYaU5XMmhCUXN5MG55elBwNXFsVWVxcEVSU3VpdDYzTS93MFJ5?=
 =?utf-8?B?c014NzQxV0w3cmQ1bmUrTWhFRTdVUVZNMmlUZUtWaVJ1eXZpU2Q5MS9mQ0pr?=
 =?utf-8?B?SzJMenZEeHRhZk9tWHV3VERWNmltZk1YNVBWU1J6b01kc3VwNXlodXRBZThD?=
 =?utf-8?B?SG9UcWppSXBhV0l4OTNSMWdEK3JBS0gwZS90MkY2ckx1N3BERTh5YVpHenNo?=
 =?utf-8?B?OWphWGo4TG1ZMUkvcG1JSTJhQjZDVk1wVVBkbmt0NElMaDA1dlg4bkMzQXBC?=
 =?utf-8?B?cys3dC9LWHQxUVc5VXZVNmhCRXM5UjViOGY1M0lLMnBHQ1Z1S3gvNjc4VG0v?=
 =?utf-8?B?OHR2a2srRG81UjJOWjJXZjBWWWdndEgvVTJ2bU96RXNYL2lNcVVOUjlZWFl3?=
 =?utf-8?B?SHpEOWZPOHdPWEJCVHA4TnkzSmJ6Yzc2c05LK3ZrOE5VZ1ZHT0xwUUkwdzNN?=
 =?utf-8?B?OFpzMWxOQndmZ3I4Zm5rc0F5ZkhETXpRUmpESU11UFNZeFhpUldVdlFWUzVk?=
 =?utf-8?B?RFRVQnpORVR5NVdDUVFCSloySTBTTklOZ1d3V0N6b01jVWVsZkRwZWxEcVpH?=
 =?utf-8?B?WnJHZ3ZFME40THhtb0lhdW1XcTZHL1pic2RYRjRVb2NLbXZNVFFSVXB0WUhw?=
 =?utf-8?Q?dT/g0WZq1HwpolvY1fldZYmBW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2048095-f410-48f8-f78e-08dc53949d12
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2024 04:14:53.4755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y5O+WynBtY7QTLM+3aFZnAp02nlmg4syEfpIH1nh+zXkkAWCchsKG/GuVMBxZ7++atkHqAjGVb2lcWcsNcZFpk5O2VmwEAysPo1noLnB/Gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8667
X-OriginatorOrg: intel.com

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEJhb2x1IEx1IDxiYW9sdS5s
dUBsaW51eC5pbnRlbC5jb20+DQo+U3ViamVjdDogUmU6IFtQQVRDSCB2MiAwLzJdIFR3byBlbmhh
bmNlbWVudHMgdG8NCj5pb21tdV9hdFtkZV10YWNoX2RldmljZV9wYXNpZCgpDQo+DQo+T24gMy8y
OS8yNCAxMDoxMiBBTSwgRHVhbiwgWmhlbnpob25nIHdyb3RlOg0KPj4NCj4+PiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPj4+IEZyb206IExpdSwgWWkgTDx5aS5sLmxpdUBpbnRlbC5jb20+
DQo+Pj4gU3ViamVjdDogW1BBVENIIHYyIDAvMl0gVHdvIGVuaGFuY2VtZW50cyB0bw0KPj4+IGlv
bW11X2F0W2RlXXRhY2hfZGV2aWNlX3Bhc2lkKCkNCj4+Pg0KPj4+IFRoZXJlIGFyZSBtaW5vciBt
aXN0YWtlcyBpbiB0aGUgaW9tbXUgc2V0X2Rldl9wYXNpZCgpIGFuZA0KPj4+IHJlbW92ZV9kZXZf
cGFzaWQoKQ0KPj4+IHBhdGhzLiBUaGUgc2V0X2Rldl9wYXNpZCgpIHBhdGggdXBkYXRlcyB0aGUg
Z3JvdXAtPnBhc2lkX2FycmF5IGZpcnN0LA0KPmFuZA0KPj4+IHRoZW4gY2FsbCBpbnRvIHJlbW92
ZV9kZXZfcGFzaWQoKSBpbiBlcnJvciBoYW5kbGluZyB3aGVuIHRoZXJlIGFyZQ0KPmRldmljZXMN
Cj4+PiB3aXRoaW4gdGhlIGdyb3VwIHRoYXQgZmFpbGVkIHRvIHNldF9kZXZfcGFzaWQuDQo+PiBO
b3QgcmVsYXRlZCB0byB0aGlzIHBhdGNoLCBqdXN0IGN1cmlvdXMgaW4gd2hpY2ggY2FzZXMgc29t
ZSBvZiB0aGUgZGV2aWNlcw0KPj4gSW4gc2FtZSBncm91cCBmYWlsZWQgdG8gc2V0X2Rldl9wYXNp
ZCB3aGlsZSBvdGhlcnMgc3VjY2VlZD8NCj4NCj5UaGUgZmFpbHVyZSBjYXNlcyBjb3VsZCBiZSBj
aGVja2VkIGluIHRoZSBzZXRfZGV2X3Bhc2lkIGltcGxlbWVudGF0aW9uDQo+b2YgdGhlIGluZGl2
aWR1YWwgaW9tbXUgZHJpdmVyLiBGb3IgeDg2IHBsYXRmb3Jtcywgd2hpY2ggYXJlIFBDSSBmYWJy
aWMtDQo+YmFzZWQsIHRoZXJlJ3Mgbm8gc3VjaCBjYXNlIGFzIFBDSS9QQVNJRCByZXF1aXJlcyBh
IHNpbmdsZXRvbiBpb21tdQ0KPmdyb3VwLg0KDQpDbGVhciwgdGhhbmtzIEJhb2x1Lg0KDQpCUnMu
DQpaaGVuemhvbmcNCg==

