Return-Path: <kvm+bounces-49306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D88AD79F8
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 20:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D2F17B0530
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 18:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8110F2D29D5;
	Thu, 12 Jun 2025 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SAhp+NWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145A2D1F40;
	Thu, 12 Jun 2025 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749754254; cv=fail; b=WeYjpLGlTxbfd19AZEPBh24a8RgY2WMIf5ENp/5UNkzQog+KPIEDhBraH+OOlsl8XLbV5IRI3VOVg0bWib+TKsWdGkpA+vteiTeK+F/1IaktnjIfZqBhhlUmrfUAkTyQZzaoUdsxYjkwIsQZHej6y1+p9aYxDar5dB+WZBYun1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749754254; c=relaxed/simple;
	bh=maEqdmGkqwRBEdO4ogOdxU6TeLlSFmALLt0/kkLUSmQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jOR2Xf0vKZNlLEpB4nsFCckN9PTIqiOWUSuzXG4a11GwummfNhtVx5cNw7U9Y9J36dz1OaC++NnfjaI9UZLC10vKomQ1Yve+WXrPijTvuxOxArZhQBwKB9mKH3Zb4OKKmdX2ms7Xd7wwTbLKVqA3hRXjS3Uh3A2JKhFJWOtOMYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SAhp+NWZ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749754253; x=1781290253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=maEqdmGkqwRBEdO4ogOdxU6TeLlSFmALLt0/kkLUSmQ=;
  b=SAhp+NWZ8GnVSfsNZOsRHbiKOCweEpnweY7W/o2QTCoFGHJf+mrPG6RC
   dRZgbfo7yMPBrWJuoOM/unH3eGzjHQrl2k6ZVtDk8y9DiwSXPP1DjszAi
   akc2h4mrLSjN4wQ2Sghv7yxd2EgD5Q5flqoh+GCTP9REj2CKHEBnlyr4E
   I4u/pfRb/EPvY2v4zTNOp9MP3J033GF1NOAQ1PK045L4LSRU6z8eAP9xg
   omUptADJ+lB/M+O2PhUtuNIbeIQKMwngsJvrCG/wsfBaYixDIHrWwacMp
   SHalmwWUmxEgIj32HhZK+3lO7f4UaxuZ+Ood2k+i7ThE4lu/aF1r8NroA
   Q==;
X-CSE-ConnectionGUID: jm00DRdxQVC32ASpMqy5OQ==
X-CSE-MsgGUID: qrrB8fsFQjevKFh6WXgsnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51937259"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="51937259"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 11:50:52 -0700
X-CSE-ConnectionGUID: UZhddhVHTSmC/ZhdD5pWvA==
X-CSE-MsgGUID: mOyXFBycRei70520mfhFsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="148505529"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 11:50:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 11:50:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 11:50:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.72)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 11:50:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYb6GDtNTKaMHiN3s3o/CDcBqASkNAbWX1alpyqPqxm+wzMf4K0/1e9DWkm+iVvk7aV9/W6Hcpkr7fo7wqm1GZoCDKUFETGkslO8CQGY5QTw3AnQ1c2G5RcWMVIaIhKoNtqqrZRXn9WTZi4oAUd3jdGqOk6Oesda8JplmUm+xLnESh0aF2DwOyvVc0t5Qa63lxafqkKlmu51E3CVYCaEbQ1VnZfXlfZCAbbgkc5P61dOFWgNxR+yQkyU5r8BYZlDVKjBsmskfjyvxAcHOZRy3Cp+3RxTQO0ANNrs3z9T+cUEe0Eco9aXSqxTWGGYjpLgc5z2Zi7ZCfQt3L8YOT9ufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maEqdmGkqwRBEdO4ogOdxU6TeLlSFmALLt0/kkLUSmQ=;
 b=WIHADSHtFinwkuZCKPh52T7SDSySudTIAuPNoSC6HeGlMHrNYXkaXh9mx+JbXQKka3JL2wyD9NRYdHctwZ/6XOv0p+E3e4wqI0+FHBHnccjb6cY5xaMmTSBqxVx4IiCy42ufm/f4KUvFjYJUBjJlpuMOmrYOPDZn6WrQxgbEYZHTAxfWoZKfZHeiMl86acOdO/cpz39PNZ1RV+2H6PCBm14dXR198KkHKAdLutQUYJoK0bW/gBrzpXj9QkFBi8x8CHyuER7vvMsBnKuhxZcqRQnGWO8dXvU/TQ0jOvytB70SLHI7yM+E1y+CaAhRBowaiZD5nqxknz4nGkoLnkf9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Thu, 12 Jun
 2025 18:50:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 18:50:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Topic: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Index: AQHb2mYn9dWQDgvWTEqusObPtA6y57P+Q2SAgAADDACAABVmgIAADVSAgAAE/oCAAAkggIAAqIMAgADBOwA=
Date: Thu, 12 Jun 2025 18:50:48 +0000
Message-ID: <58cf64a2c4a085099bb801e6c3a966b97bc182e3.camel@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
	 <aEnGjQE3AmPB3wxk@google.com>
	 <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
	 <aEnbDya7OOXdO85q@google.com>
	 <7de83a03f0071c79a63d5e143f1ab032fff1d867.camel@intel.com>
	 <aEnqbfih0gE4CDM-@google.com>
	 <2ea853668cb6b3124d3a01bb610c6072cb4d57e6.camel@intel.com>
	 <aEp/cHQqI0l09vbd@yzhao56-desk.sh.intel.com>
In-Reply-To: <aEp/cHQqI0l09vbd@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7997:EE_
x-ms-office365-filtering-correlation-id: 0e8656e6-f769-4fd8-803f-08dda9e20c4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zk0wcy9YRVRzZ3VJTExOcTVJWUZrZkM4Y1hSVk50Zmo3YURBeTRtNWJUSEJy?=
 =?utf-8?B?NVNJSkVFd1U5UzhSc0cwZlFFUSt0UUR6UFdNTXpWcS9kcUNnaE9DS0NWa0Nj?=
 =?utf-8?B?eStZZEdad2tUNWVxMFVJcFY2RjYzMjZHVGc5NW5HeTJMd1dVYzZoUFRPb2gw?=
 =?utf-8?B?VHRCQ1YxZjZDL3YrZlNBVzhIWmFlVlQzZVRIUmthUklUMitjcU56RUNQc281?=
 =?utf-8?B?S1ZnT2VLSEh1ZEw3UTZjMFZhOEtoUHUvWHQvdk5Ic04zaVZHRkcvTklENDBH?=
 =?utf-8?B?eDZncTgxOERYTHN0NGZCYlZKbDZpUXhzQldGMmNqOS94QS8zUXNSeUNJNDI1?=
 =?utf-8?B?WEQ5NjR2aDlBSmJpNHNwQ29KVUhseFJyTi9WcDNldmdNSkpCMXNtdEpVWGhX?=
 =?utf-8?B?VVBISzNLV0VWR2NoRy9pTExvL2N1MjBCYldvbTJZQTA3VnlwNVloYW5zQnpz?=
 =?utf-8?B?d1oxK1FMTXBuN2dIV0l0b2VCaVhzcDZ1eVduc2IxUDV2MENvVlpJUjlHalhI?=
 =?utf-8?B?NGNjaDF5M0tiUm9rV21jRnkxaGNCUlNsOHlHV0NUUUs5ZENNa2NISk42N0Zo?=
 =?utf-8?B?bmx5T1ZwcktvUmJQYkRDNTBLUXZ6eXF3YXExNE5YdHVaT293U1ltbE11OTd0?=
 =?utf-8?B?MHgrRFNvQVlFUTRwWGdCSlJDZ2YxeW1sNWw5bkY0VVM2T2lVUGY2RkFZYU1j?=
 =?utf-8?B?QkxwUCtETGVpdzNtM1hlZ1RXK3FWVkFUTFk0SGppbWMyekM2VGgzVXRGd29X?=
 =?utf-8?B?L2paRWxjTnphQ0NLdlRMTGJaY2NCK0N3Q3l1eG1LNzZKZlU5a1Fyb3FwUnNy?=
 =?utf-8?B?RVA0WmNNd3UxTmJyNDdPS21FV0JMODV1NEo2VWw0ZTJ0MTdBWDg1enVwQTJK?=
 =?utf-8?B?Z2JUMzZVbm9qbTVOZlhLbEthQ1QrU0lsNVlVejRPdWhqOWwwTXZqditOOWhy?=
 =?utf-8?B?SUxnQmxaUnMwcTltbzZnWWR6RldnRjVZckZMNUZCUGp6b2gxMElSTXR4K3Fn?=
 =?utf-8?B?dTMxZStMS0R1QnR3YkR1UGUyUzVTWGJNMGdDS3BSR0haVjRnM1l6SkFTeXZm?=
 =?utf-8?B?M21LSTJRVXNGVzFJM1B5NHpoYVdxdGlrMDJNQnBYZ0REanFtOXVmalVnUUFs?=
 =?utf-8?B?MlhFNmQvRXZUb1psNzNQNFhuMzEyVHA0eW9TS1piZmZmLytNRmJra1dMSVBC?=
 =?utf-8?B?R0NIMXZRUFRDQ3VnMWxITzhjaElNaGtkMHgxZDMyTngwOFhxV2ZiQkFKNjF3?=
 =?utf-8?B?KzlWenJTbG1JSktwNFJ0VmFkYWlSVGlQUElEaUxwVEhJYTBuaTlXc3J0ZkEx?=
 =?utf-8?B?WVpOQWkzcWdiZGFZTHJtZUlZbEk0ZklYTjNFRXJIV3EyMHF4ekh5bzBLTEdx?=
 =?utf-8?B?aVhhWEFrWlQyWU14QW1obm44Qk9JWDU0NmRXUkNqZW5aR1pKM0ZTQlpqd09G?=
 =?utf-8?B?N0h3L2pDOHl5cngvVUFlYjZEc2RNY3phZUtwYzlONWVrS0RNK0FpYUtlaEV6?=
 =?utf-8?B?b1FwSzZSWUtsVFRBeklEa2tPMGhxZ0pRWWg0aWcxRVlrR1dqdzZOVm5CQ2Z2?=
 =?utf-8?B?SzgwU0xMdnRKUVlpQ3JKSkplNnlnNWdMZFlSZHhKR08zVkhUK2RiQ2dTNEQr?=
 =?utf-8?B?M2tFQklrWjBIY0JLbkJBUlU3OXhwMGNFMU9JNFFzL0xJcW13M29WUnZnbEQ2?=
 =?utf-8?B?QXR3VXg0SzVCYXIxTWNQR3NVT1JkL3N2d3FWNlN4eUhUU0NXZ2lKbGhDUlE0?=
 =?utf-8?B?cEJKQlE5MW9NYXF4ZHFnN1RrZkg3VnQvREo4WU1IYTlHM2NkcGswSFEyUG1l?=
 =?utf-8?B?c2NsN2JLTVp1WTNDdk5sVCtvSTZHTGxMSkJGdjR1WHRxZHN4d1ZNbWZSSUR5?=
 =?utf-8?B?dlI0cDlZYmpUdEpwR2s5UnpyWUVWQS81Y2dISXVPTzNWQWh1U0dHaDdTT1RU?=
 =?utf-8?B?NlQzczlCYmkwRHJkQnJtdGZwTzN2Nm5yMFhFbys1dE80MVprZFlod0hyL0xs?=
 =?utf-8?B?Z0hJVEhQYWhBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG9VR0gwZFZ4b0taRWVwS3hpZXgwOEVEZFlWMERQeXk5d053amhUQXI1dDZV?=
 =?utf-8?B?MW16amNXdVIvd2xDNFU4eXlIZlRIMkhXR3hYY1Y3b2FESWIyVzkybWRzT3VU?=
 =?utf-8?B?RS96Rms2NCtXMHc2eStnZkdBTlZnRmlaSnViSi80OEtQTjFVVEd1OXVCSWRG?=
 =?utf-8?B?ck5XMmJWRFdvbmhEVlZJdU5qNjllZmxHRk1uWlFFMEVUVEI2ZGxQVXU0TkJo?=
 =?utf-8?B?akJKSGFmQ21SYTdiQVNGTTZNQTdvMFNhOVprRld1dVB3V0VLbGZyYWliVnIr?=
 =?utf-8?B?cWlWR0FyQ1hmaEs1UGdCZ1R2TkZFb0R5TkkrNE4zc2trdHBqUlRaMzREdUoy?=
 =?utf-8?B?T2VuRHlsY0VHNzN1RzAzb1BFUjk4bTRzN3d0ZGhqS2NFYzVsWDloaVFyZXc5?=
 =?utf-8?B?dy81OFc4V1FhTkExdE9xUWJma3VRY3JsSUJaK2JLL2ZXSFhucXZqVjJWenk2?=
 =?utf-8?B?a1hJa2w3aVNzUFdkME1JYUFEdE1JL3JZeW5uM1BqTjVIa0gycW5iN2g2Qm82?=
 =?utf-8?B?dEFNWXFUL0VRSXVMNkxONkpsYmlYcUFJelJSdE1jMUJVODdMQWE2TXExSlls?=
 =?utf-8?B?NGNhNS9Udkc1YXVURnNlN2tqOTNUc3Fmb05VZlptd29ya2xmSFZsSW1UTzNH?=
 =?utf-8?B?cXBMUEp4T2NYK0xZcm16UmRFdU10aWNTTnRrVWlSUGJTc253aStaekFtd3ln?=
 =?utf-8?B?S2FXZ243RG9DdmNpeFBtQ2xtdHlyWTZkeTQ0czd1RTA2Y3FDN1dIelpEUXpO?=
 =?utf-8?B?VFhjQm01eUsrYjRxc000YWpqVmJnSklZalFUanlvcllaRGtnbXd2cC9rZitq?=
 =?utf-8?B?MnRVdERjeG83Mnk2d0tWMmhQdGM0UGdqUFNjR0QzdXljb1kvd3dRaU1GQVly?=
 =?utf-8?B?V3VybE1QWTh2TFhzd2ZaZFovMTBSUGdVNDc2M3hWaUx6TE5PaTNoQ2twTHRQ?=
 =?utf-8?B?UTVrRkFQaU1LMTZpTlkrcnRBbzJSNnVZMk9VNS8wb3hOZ2FaWDljdkppYVk5?=
 =?utf-8?B?TzJVNlhCUG8vZXJ4aW9CUjEwKzBDUmRLOEM4S1ZPaXBBQW9mQ2N2WXlzd1Y1?=
 =?utf-8?B?NkE1ZHNMRGpJQmZ1dGZjUkYvblJzNmVHWVNOeUI3NUY4SHp2THlVWXQrTXh6?=
 =?utf-8?B?aUR4NFJyV3QvVFlqRWxUZm1FVk5lM3JGcE1DUDlPbkJpbWRkQytFKzl1QnVt?=
 =?utf-8?B?dTk0M2luclQ4eDZ0cjh6aThpQVlCUk44c0EwZ0J0VlB4ZXJkQ0llaTdiTkFN?=
 =?utf-8?B?YzRVbi95L0twTXZCQXJUZkFBN0ZTajgyM3E1Z0NNNkZEQmdlY2lyenJhY28r?=
 =?utf-8?B?SEIrV203Vks2LzRybzE0aWpPckFEam5qVHJNRTBYMlJ5alFobkxPRkJRMXk1?=
 =?utf-8?B?SlhoWit1WVc0blh6U1g4YlByUjRLTVNiK1E0bzA0OU15K2VIQmxHQW5uSWRv?=
 =?utf-8?B?RHpGcHZxQmdXdnZEeXdadDhabG5md2hhU3A4OFc1V1RZRHVKYmxFYzc1SVYx?=
 =?utf-8?B?Z3ZlWkN0YmdTdWlUUXZMTmxzcHRBK3oyOEUvNDRTZDBTK3hrQjQ5Y2t6TWk5?=
 =?utf-8?B?MEJpSXFvWHNkN0J5amhVaC93bFI3QjFlN0Nwdkl3SmVPY1NVSEUvNmZZTzRt?=
 =?utf-8?B?ZDVveVYrYlBHUWh3WmRMZlhWWGJTS0dRcGluaE04ay8wSUhmRWJZeVlIbHd3?=
 =?utf-8?B?dkRRL0ZDdk9QWFJYcU5xYTV0RW96cWpEZmNiRlVMNHNLVTFldFgrVmdVMnds?=
 =?utf-8?B?dEl5STVSVEs4anZQVFNqRjNGcDZVUGZMK2xJSWhoSnlLMHYvRk84c0NaVFE3?=
 =?utf-8?B?Q3dVS1QzU3BnUENvRXRBdjR3YXNhM29VQitPVktSZFE0RXdReWV5S3VNbW0w?=
 =?utf-8?B?aXZza0dmTTFQaUMzbEZPeGZPRVA5UkdxTjFxMEYra285WXJuS3JzMWM2UUxK?=
 =?utf-8?B?dFhPT3R2ZnZHTHRlTE9XeE9SQlhOcTlwM01xVzRFS0pCU2RrcmNwS3hwUVF0?=
 =?utf-8?B?Z1B5YUhWWVp6MkNhdy9OYlZSaHh0UlkvMm8zblNBM281bTg0aFJTbzQrVkhp?=
 =?utf-8?B?MTBjNk9vVG5BSUhyZnlIUEpQQzBnbUtYV2xmckI1Z0VrczVvc082Z2o3TEdo?=
 =?utf-8?B?dnpRN3NTU3hzS21LdHpqdGE4OURXK3pNWDV1U2k0YkdGeWdwM09VNjVSRGlU?=
 =?utf-8?Q?mW+9Q/FnIZc6IKlEPHf7Rcs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1DD1840AC921844A3FE517396C7CC2C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8656e6-f769-4fd8-803f-08dda9e20c4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 18:50:49.0029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PJptCxl3eZdGMbcTFxj6EyVRChgF9z45Oh+y2YY/QkmtHuKNLONITPFqkm57dZabfR00eTuwOiivxKdWOuWYsPKlZ9gcjFk2/HTD0ZFCBsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7997
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDE1OjE5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBU
RFggaXNuJ3Qgc2V0dGluZyBQRkVSUl9XUklURV9NQVNLIG9yIFBGRVJSX1BSRVNFTlRfTUFTSyBp
biB0aGUgZXJyb3JfY29kZQ0KPiA+IHBhc3NlZCBpbnRvIHRoZSBmYXVsdCBoYW5kbGVyLiBTbyBw
YWdlX2ZhdWx0X2Nhbl9iZV9mYXN0KCkgc2hvdWxkIHJldHVybg0KPiA+IGZhbHNlDQo+ID4gZm9y
IHRoYXQgcmVhc29uIGZvciBwcml2YXRlL21pcnJvciBmYXVsdHMuDQo+IEhtbSwgVERYIGRvZXMg
c2V0IFBGRVJSX1dSSVRFX01BU0sgaW4gdGhlIGVycm9yX2NvZGUgd2hlbiBmYXVsdC0+cHJlZmV0
Y2ggaXMNCj4gZmFsc2UgKHNpbmNlIGV4aXRfcXVhbCBpcyBzZXQgdG8gRVBUX1ZJT0xBVElPTl9B
Q0NfV1JJVEUgaW4NCj4gdGR4X2hhbmRsZV9lcHRfdmlvbGF0aW9uKCkpLg0KPiANCj4gUEZFUlJf
UFJFU0VOVF9NQVNLIGlzIGFsd2F5cyB1bnNldC4NCj4gDQo+IHBhZ2VfZmF1bHRfY2FuX2JlX2Zh
c3QoKSBkb2VzIGFsd2F5cyByZXR1cm4gZmFsc2UgZm9yIHByaXZhdGUgbWlycm9yIGZhdWx0cw0K
PiB0aG91Z2gsIGR1ZSB0byB0aGUgcmVhc29uIGluDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2t2bS9hRXA2cERRZ2Jqc2ZyZzJoQHl6aGFvNTYtZGVzay5zaC5pbnRlbC5jb23CoDopDQoNClNl
ZW1zIGNsZWFudXAgd29ydGh5IHRvIG1lLCBidXQgbm90IGEgYnVnLiBJIHRoaW5rIHdlIHNob3Vs
ZCBmb2xsb3cgdXAsDQpkZXBlbmRpbmcgb24gdGhlIHNjb3BlIG9mIFNlYW4ncyBjbGVhbnVwLg0K

