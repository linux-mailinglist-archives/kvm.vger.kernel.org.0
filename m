Return-Path: <kvm+bounces-15422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E498ABE60
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 03:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 513D11C20836
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 01:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF434C6C;
	Sun, 21 Apr 2024 01:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMvXNyqX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA541FA4;
	Sun, 21 Apr 2024 01:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713664701; cv=fail; b=pK/pBDkaWqPSok8CSH8OBFZBC7BV/AyxcIgokO7uV72kqNsrm0qt+HRuN+sIs+SCGcrx2qdFU7WwkqaPY7bQ1TEr3kLzFHt8Qqdvae4sp/kAWaKp2eZGWfCcwBbZS7l9LBYWStwaM2HA3TVw1gRyuF3DKkWgSj03//ACayBpMsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713664701; c=relaxed/simple;
	bh=95WbnLcy83Dazi/mcYrcjzayuFHCH6ahNtqNw03gFVw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DC1XvPuKZ6HWPQtVEAYUzPEbcyqXdsl86udIjAQQBxUXn7SgBIEcLEcs70JBamiqTdPLlKZDM2EQoyh0B+V2qhGgaHuQ4C1yG45/TurwOGoHbv3dm7i5CeiXZiGSMY6aHYqY4vnp+Q6IFGdOeJqeMesPVgOfsWGM2exSoHF2Bl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IMvXNyqX; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713664699; x=1745200699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=95WbnLcy83Dazi/mcYrcjzayuFHCH6ahNtqNw03gFVw=;
  b=IMvXNyqXBnCmsoUN+Etw1GO0FzksLMs2oESYFOH+TcTN2N5DsyfXIrn0
   O6fIGut4ba4jN3bV3Rv0GitGDH7XyMs8TfJD9tCMN4cTtSFGyEIg0orhi
   2P7Ri+OMuRAjmJelBpBUAle/Aa0aF4L4RNUc3WnJl7pS2YcR6RQ7R/HDQ
   0gda54Y5NV2I5QZKqWjmCD045jVM1MpsSleiHrzj9eCdoGx0awvEVMxb+
   O3oBYuj5wOxrVMrynBvdeJav6RPyO+eCd+OG/9Q/0rqsB0HRQ4HUgiLi4
   uChIGSeYJgpklVulSCNiaYdhMdkMhO9XYqEb/qTBoHve+Fzcdwv91OXNc
   A==;
X-CSE-ConnectionGUID: +u79Rz+hT/ei2YiywAw3Tw==
X-CSE-MsgGUID: +qOW9qKYQE6Y02s+cyRbJA==
X-IronPort-AV: E=McAfee;i="6600,9927,11050"; a="9092710"
X-IronPort-AV: E=Sophos;i="6.07,217,1708416000"; 
   d="scan'208";a="9092710"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2024 18:58:18 -0700
X-CSE-ConnectionGUID: TUO3BBvBT9yIz9Xk672ddw==
X-CSE-MsgGUID: Wa2TfCsbT1OhkwS4NurUGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,217,1708416000"; 
   d="scan'208";a="61124946"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Apr 2024 18:58:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 20 Apr 2024 18:58:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 20 Apr 2024 18:58:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 20 Apr 2024 18:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLV6Pe+KVUtAu3l2I31r0yANa8gRKmpfjY4BBvo9ya7X3y1wgpmFe/Hmn8aGmRDPhEh2DovmyF1Eb90rK/tGLj6HdZKLkmk4OsJreGPG7dO3gxH2FnlJRQr5lO7h/Qn6Gu7GDSaTdk+3YaAAlpF4nSdtjmerl3Kiya5xISfSCZIwWuXcJ1/JmWTMaDwkyZt0tP5ivTruFFLhTZHoI2eqkyOAWwkpCk6/sUAz45NjXElOXf0B5lXn5lRcXGhqnnpDQl1h1N8QmK8JS5SRn1MitoT5KGjGYkepEF0veF4IlP7J1aXWQNgA43C/GRZ1ZkHyb+PCLmAXN30ilTvcfUpb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95WbnLcy83Dazi/mcYrcjzayuFHCH6ahNtqNw03gFVw=;
 b=d75XzmdaSdIW3F0ilugVcTiF9jTKIMwwipUBGwLKfIf30vqa4BxKmKmNzid8LjQTb9oXu0Lst0sBlEAo1Ls4yO1E8f9NNJM4v1QF2SCdCkCYMFQJXuvc/ajOEn0dC1Gukv+LrunoWj94IrdABUVm+V/0SbytlV1BbD0XJgrlxvXJGPeYDNG7Ljs3SAI+LWJRvFVXvKzEruda4vyVTGXAi3we0Btv9+9EnHPusX2/yrbYNx5VmukhqykTa56SFiEajcW9ibe/awHvK/vlDBAtzVQlego9DcK/Spt+n6xJX79tZoNYq41ipm4jcVoUNHnga8khUlzGrjbTPTl/q+ObDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8414.namprd11.prod.outlook.com (2603:10b6:610:17e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.16; Sun, 21 Apr
 2024 01:58:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.015; Sun, 21 Apr 2024
 01:58:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrFyMb4A
Date: Sun, 21 Apr 2024 01:58:07 +0000
Message-ID: <5210e6e6e2eb73b04cb7039084015612479ae2fe.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8414:EE_
x-ms-office365-filtering-correlation-id: c79963e4-30c7-44a7-e8f4-08dc61a67d37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VEs5bHBSMkNHWGhpdERhWTJLalFEWlBsZ0xaajlLNXltVlJmVmtzV3daYk9M?=
 =?utf-8?B?NlVtWmptMGRuRHUrd24ybTFMajdZSmk2LzB6QWU1eTNMZWMxYUlDNjJ6V01x?=
 =?utf-8?B?RFZWNFk4cG5lbWJWR2NFUVp5dFhpMDdCKy9JNUR4bEVYRk44R210YXB6TXJk?=
 =?utf-8?B?ZjR2V1kwdWp6aXJhZ1J3MHVmQ1k2UzhLVlJ6NUFVM2ZiSkFHVkhjV2xnQ3FL?=
 =?utf-8?B?WW5CZCtZL3ljU3kyVnduL1c3WWlTaDZoQ3BENURPT1hTV2M1cW9BY3hSaVZF?=
 =?utf-8?B?ZE9EK1FoU0hlVjdWSnRCRTQzTm5XVWRzNGFwOTJKa2FqWEMxeE1mSllRVE1G?=
 =?utf-8?B?OXNiRklKL3BiWTd5amtBOFdTRjlpMWJwWHpBQUFCZ0JvZUYzVFllSnlzYXRo?=
 =?utf-8?B?dDFEUWFyMmNEK25Mb3d2elBKbGoxeGtDRjM5OGlRTnEvdDYrUHhCWE96d3RX?=
 =?utf-8?B?SFIveTZwdldvUTBpUkNldkFjNlJLbGxmNnRaRUFoNHRqeFJvNlpkTDZJUXhk?=
 =?utf-8?B?RlJiWDQwRERnaDZ1QzdwaE5UQmtOM1lrdDV0QmJMNFdDRGhPcFF4Rm5nRFlm?=
 =?utf-8?B?ZDJhNTI1MlNjK2h5QytLY0tNSDFBZEIwVVliUGZ4U2oyYk5UQkl6d1JnVURi?=
 =?utf-8?B?ZHpZZUdRZlVic29xTVFlVkpSWkh5cVJtM0ExazVCbFFpcW9EL0xld1g5MS9m?=
 =?utf-8?B?S2FqVy9jVDZhTlpRcXlUM2JmcHpRUWs0WmFtSm1wbFNLMnJlUjVZYkVzaDFQ?=
 =?utf-8?B?Snp0ZEhod1MzVWl5K3ZGcld3cWMyNXF3OVZPS1lkMzBpQU9KeVVLS2M1cW93?=
 =?utf-8?B?dTFTVjV6QkZHeWxLV1NxVkZzeGsxTzkwYkdQNE9uMExGcC9pc3JYRXR0Y2hJ?=
 =?utf-8?B?ZFA1ZTRabHZQRUdUdkNUUitrdkNHdUlJK2pTY0p0dHc0dE1vQS9Cc3U5UDVF?=
 =?utf-8?B?V2JUWmV6U3VUVjNDT1ZFUkl3VGttNFRkM2JoU1ptRlR0NCtub3dJS01xTklV?=
 =?utf-8?B?d25tOEVhNkEyK3M3VmJPdFZYKzRHUXl4OUFMMzJmK2RoNmwxTTV5UTQzWnQ3?=
 =?utf-8?B?ZzZ1Vkc4NlBRMjhaeWxjamcvbU5mMk9EVmZXYk1RY2QzblNKRlFnakpoNG13?=
 =?utf-8?B?L1R4RzF1UEl2a3RhalIrK0tRSDd4eXEvUCtYSUlIbjdZS1ZGLysvbXhOb3VR?=
 =?utf-8?B?dXphUDZnRWJ2eFYzNVNZb1ErVUZzd0FybUhWZjBSdDZxcXJhbFk1a1JsaGxN?=
 =?utf-8?B?a09XZ2c5bTc0RWRpSU9sbVo3OUgvaW1vMUVmS3ZqL1l5ZmlrOG4zVUFDVEhZ?=
 =?utf-8?B?U0M5S3NTTjdtUFV0aHlXbmZhazRuOWJyTnlXZ3V4V3NBRUw0TVd5NnNQWnAy?=
 =?utf-8?B?b0dSRnFEK25BOXd5amFsc2R0amhCOFdOYUtFcko2eTFPZ0RaMDlqSzZqY0lw?=
 =?utf-8?B?b1V1S3lkd3dLU2VaTnVhSUdhT2ZQUG1qUEpTN2ZwcStMYURtQjVsTW9tSktu?=
 =?utf-8?B?cUNsNzM4M25RTjJrR3R6TC9sZXNtcXRiZDZiakd4MTRLa1dWRTJtZzlOWU9y?=
 =?utf-8?B?b1hTclZUV0xJd3ZZYktmcEFXODFqVm5yTTAwTi9adzR5VnF2Tm1JNTJRRnNr?=
 =?utf-8?B?Z1VxWENSdHNmaTh6QnRIdzBMcjYwbHRXRTE1aWVCTGZsUzhqdHJ0cXh3Tlls?=
 =?utf-8?B?dUdiRGpiSlpld2hXejdmREFVN2twTHZBTHlXRTF2cTZYRmV2bTFnbk13VWwx?=
 =?utf-8?B?YTlLYTZQQTFKYk9mNkpoU0dwNlN0VUNiQ2Q5c2JFdlpKUkRkNEQ1L3BFUzZo?=
 =?utf-8?B?VkFyWTVmVzU0SXdISzAvQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnhJbFR1V3pZWW5DQkxpTlRkU3FCSjRQMjNFZFlqTVZFTkltT1lmNGJDTW4y?=
 =?utf-8?B?ajdXN2d0T2h1UjI3VGZCREo4MWM5L1NCRU1uZHFaR2R0cVVwRWEzMCsxVDJi?=
 =?utf-8?B?WmRUeUNWeVBoRUNRWFQwMG5ONWdnZHNtS0ZHL0tkWkEvMEpHWUs2ME93NDdJ?=
 =?utf-8?B?aytiNE9rQS94NGNRT29uWVB4SFJvQXVZNHJKa2piU0NVVm5qY1lDelM3a3E5?=
 =?utf-8?B?dENpMFBWQjZIWnNNZ0ErYk9qdXZ2Sm8vSFZHbFRSSjEzUDhwNkNUazh3bzlB?=
 =?utf-8?B?MHlHOS9PY1ZLc3pSSm5hK0loVEhoY0NuTjlTcGZuaVlySW5Ia3dIRWRWNEYw?=
 =?utf-8?B?OThrS1hBK0Z2UEtoMW9Ham1Rb0xLOFVuQjRoZUE1Nm5pbkJsRWtvMHN3QjNq?=
 =?utf-8?B?VWJFZlQxRTN3RVZlbWplRlMvZ1p0aWpLY01MYmlqRnRsOHZQcXh1Z3BwdXJK?=
 =?utf-8?B?bFY0YnQyRk1UN0ljaFc3WENRZmE5T3Awa0J4MkNzekdJUlNJVUQ2N1RLYlYx?=
 =?utf-8?B?QUNHVkEwTWxKemRBQnp4WnFObTNKWlhuN1diNjdCLzZZQzRuVzFjNDlXWk56?=
 =?utf-8?B?TnYzaDEzSEhJekFIdFFIYUZ4Wk52Ukk2NkI3djI2clphZEFNdFdOYkRtL0JT?=
 =?utf-8?B?NWkyalpmM1oyditvUGkvSU1iSUdYbWREVEw2bnJ4enQzdzl3RGpieFFXTGRB?=
 =?utf-8?B?MWJES3Iwd2ZzUnpxbzFzMDhkdGV3U0RDcTkzcUZTSWNoMkUrWXMwWVFVb2Q0?=
 =?utf-8?B?NXZ5RDRGaG5sb1g4d1RKdEVPVnVER08xekx4dTdvc0d6dkhWZXJxaUFuZVhx?=
 =?utf-8?B?SVc4dENaKy9oakhZNXViTjVJTTkwRDM1b2pTUWprU015ZFdLaE9CNk1ta2oz?=
 =?utf-8?B?OWtHWE9RNFl5YlBtMXA4RVNLclhlREt4SzJvYldoY2dTa085OHZDS2VzUmpH?=
 =?utf-8?B?MHdFNTcvdFg5M0RkWitqZ3JpY1BUQVY2eTVhV2tLSlJaeGpsNk1LS3BBdHNh?=
 =?utf-8?B?WGJQc3pyZ2hHUGtqeUFZVkxVUVkyM2Y5ZWlQcVk1eWtYeTBRY1g0Z2laRW5E?=
 =?utf-8?B?RHZ3M3R0VFkyYktYMWY3akpsR0JreWNyU21IN0I4dlZraE54L2NiKy90WjZv?=
 =?utf-8?B?V1BFLzd0aTdFdFNDaCtXaUJjWWVoOStsc0tYLzFZRkI3UXVnY3FlV20zMmFO?=
 =?utf-8?B?c096UytDTlJpNHFhbStEZFE5Zjh1NlJOYXEyS0tNTzVmUTc2RURSYkJ5MnRs?=
 =?utf-8?B?akNZck9FVDRPTkhpMTQ5NU9UTmw0YzBJMk1iclE4UlQ5RzBIMWtJR2RzSlZ1?=
 =?utf-8?B?eFk4UnYxcWMrbFFUNzE1RzgvdnlNS2gzdEtUc00xK2p2MGFKeGZ0c0lUL0Mr?=
 =?utf-8?B?TFJ4d3RUN2JIWVRXckpQdStwMXEzaXgvQW1XWk5uLzZxakc5OThpQ2FtVS9w?=
 =?utf-8?B?ak5nZWVXUUNtanpRRmUvT2Z3RDNtSzNUQVlTVDJMNVBSeUJYWUxBL1B4Z09i?=
 =?utf-8?B?WFBXeEt6WGtobVQxVUJ6U0t6RUExY2d4aGczZEF1NmdmZnhscVA0TGJzaUZh?=
 =?utf-8?B?aVp0bksvbTJHVDFIZFl0cFZCeEwyTmE5Y241Z3Z0bGxPb0VxVUZlaSthYkl1?=
 =?utf-8?B?NU5EaE14V1dnNk1BSE0xd09Cdlo2Qi9ZRDZLMlRYcXNqYzlPVGtiODZuNjlY?=
 =?utf-8?B?eVFsWTRuOWNFOUhGN2Z1b2pFS09IbFlPeHhaOEx1eXFPT3JZQktkY3B2cDBX?=
 =?utf-8?B?MXNjN3ExSXBESTN4WDkvK1ZFamd5eDlEMnFVdEFpeGxRa0U0VE5vS2dUN0Fo?=
 =?utf-8?B?SSs5dVJsL2RNYytkZUo0WG1heEVLNkh6RWpJNEpnV1p1Q0hqMUFEL0kzbThp?=
 =?utf-8?B?ZDd2QzJaQzUvU1gwMXZ5V0tXS1EwNEt6dmFYR3dYdHBWcldQMmJLV2ZKVHdE?=
 =?utf-8?B?N1F1ZlBXWFZ0RTcrR0tLY1NxYWxZaVIrc0ViK0Y2QW1FdHlLalRpWEFXZnVW?=
 =?utf-8?B?Qm9tN1crNm9jUnd6cnlpNVhaVDh5aXZWaDZQaTZEMm9aVHE4K0dUSGhpOThN?=
 =?utf-8?B?ck5Nak5tL1lmRGtNcFdaMEY2MFE4YjdQRklPckhTdDNJS3VHWStZbno1UTRI?=
 =?utf-8?B?ejJ5eUpGbWlVN2QyLzZ4SzM3Y1Ewb25EbG1pTUh1eUExODlod093azlEbXpi?=
 =?utf-8?B?Nmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8D804DF3BB6DF48B648A3800EDEF390@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79963e4-30c7-44a7-e8f4-08dc61a67d37
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2024 01:58:07.2873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZwpylP5Cj+1ZllOAIXn//du19e1oBZaGyp6mr/LoZBbQ/bH7kMFhxbueo+amN7Je5PW5k+5l8wcNNNQB944CP/F1bOiixQ86iN7wNpDIjXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8414
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI2IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gKy8qIFVzZWQgYnkgbW11IG5vdGlmaWVyIHZpYSBrdm1fdW5tYXBfZ2ZuX3Jh
bmdlKCkgKi8KPiDCoGJvb2wga3ZtX3RkcF9tbXVfdW5tYXBfZ2ZuX3JhbmdlKHN0cnVjdCBrdm0g
Kmt2bSwgc3RydWN0IGt2bV9nZm5fcmFuZ2UKPiAqcmFuZ2UsCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBib29sIGZsdXNo
KQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290Owo+ICvC
oMKgwqDCoMKgwqDCoGJvb2wgemFwX3ByaXZhdGUgPSBmYWxzZTsKPiArCj4gK8KgwqDCoMKgwqDC
oMKgaWYgKGt2bV9nZm5fc2hhcmVkX21hc2soa3ZtKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBpZiAoIXJhbmdlLT5vbmx5X3ByaXZhdGUgJiYgIXJhbmdlLT5vbmx5X3NoYXJl
ZCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIGF0
dHJpYnV0ZXMgY2hhbmdlICovCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB6YXBfcHJpdmF0ZSA9ICEocmFuZ2UtPmFyZy5hdHRyaWJ1dGVzICYKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgS1ZNX01FTU9SWV9BVFRSSUJVVEVfUFJJVkFURSk7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHphcF9wcml2YXRlID0gcmFuZ2UtPm9ubHlfcHJpdmF0ZTsK
PiArwqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgX19mb3JfZWFjaF90ZHBf
bW11X3Jvb3RfeWllbGRfc2FmZShrdm0sIHJvb3QsIHJhbmdlLT5zbG90LT5hc19pZCwKPiBmYWxz
ZSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZsdXNoID0gdGRwX21tdV96YXBf
bGVhZnMoa3ZtLCByb290LCByYW5nZS0+c3RhcnQsIHJhbmdlLT5lbmQsCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJhbmdlLT5tYXlfYmxvY2ssIGZsdXNoKTsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmFuZ2UtPm1heV9ibG9jaywgZmx1c2gsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHphcF9wcml2YXRlICYmIGlzX3ByaXZhdGVfc3Aocm9vdCkpOwo+IMKgCgoKCkknbSB0cnlp
bmcgdG8gYXBwbHkgdGhlIGZlZWRiYWNrOgogLSBEcm9wIE1UUlIgc3VwcG9ydAogLSBDaGFuZ2lu
ZyBvbmx5X3ByaXZhdGUvc2hhcmVkIHRvIGV4Y2x1ZGVfcHJpdmF0ZS9zaGFyZWQKLi4uYW5kIHVw
ZGF0ZSB0aGUgbG9nIGFjY29yZGluZ2x5LiBUaGVzZSBjaGFuZ2VzIGFyZSBhbGwgaW50ZXJzZWN0
IGluIHRoaXMKZnVuY3Rpb24gYW5kIEknbSBoYXZpbmcgYSBoYXJkIHRpbWUgdHJ5aW5nIHRvIGp1
c3RpZnkgdGhlIHJlc3VsdGluZyBsb2dpYy4KCkl0IHNlZW1zIHRoZSBwb2ludCBvZiBwYXNzaW5n
IHRoZSB0aGUgYXR0cmlidXRlcyBpcyBiZWNhdXNlOgoiSG93ZXZlciwgbG9va2luZyBhdCBrdm1f
bWVtX2F0dHJzX2NoYW5nZWQoKSBhZ2FpbiwgSSB0aGluayBpbnZva2luZwprdm1fdW5tYXBfZ2Zu
X3JhbmdlKCkgZnJvbSBnZW5lcmljIEtWTSBjb2RlIGlzIGEgbWlzdGFrZSBhbmQgc2hvcnRzaWdo
dGVkLiAKWmFwcGluZyBpbiByZXNwb25zZSB0byAqYW55KiBhdHRyaWJ1dGUgY2hhbmdlIGlzIHZl
cnkgcHJpdmF0ZS9zaGFyZWQgY2VudHJpYy4gCkUuZy4gaWYvd2hlbiB3ZSBleHRlbmQgYXR0cmli
dXRlcyB0byBwcm92aWRlIHBlci1wYWdlIFJXWCBwcm90ZWN0aW9ucywgemFwcGluZwpleGlzdGlu
ZyBTUFRFcyBpbiByZXNwb25zZSB0byBncmFudGluZyAqbW9yZSogcGVybWlzc2lvbnMgbWF5IG5v
dCBiZSBuZWNlc3NhcnkKb3IgZXZlbiBkZXNpcmFibGUuIgpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9hbGwvWkpYMGhrK0twUVAwS1V5QkBnb29nbGUuY29tLwoKQnV0IEkgdGhpbmsgc2hvdmluZyB0
aGUgbG9naWMgZm9yIGhvdyB0byBoYW5kbGUgdGhlIGF0dHJpYnV0ZSBjaGFuZ2VzIGRlZXAgaW50
bwp0aGUgemFwcGluZyBjb2RlIGlzIHRoZSBvcHBvc2l0ZSBleHRyZW1lLiBJdCByZXN1bHRzIGlu
IHRoaXMgY29uZnVzaW5nIGxvZ2ljCndpdGggdGhlIGRlY2lzaW9uIG9uIHdoYXQgdG8gemFwIGlz
IHNwcmVhZCBhbGwgYXJvdW5kLgoKSW5zdGVhZCB3ZSBzaG91bGQgaGF2ZSBrdm1fYXJjaF9wcmVf
c2V0X21lbW9yeV9hdHRyaWJ1dGVzKCkgYWRqdXN0IHRoZSByYW5nZSBzbwppdCBjYW4gdGVsbCBr
dm1fdW5tYXBfZ2ZuX3JhbmdlKCkgd2hpY2ggcmFuZ2VzIHRvIHphcCAocHJpdmF0ZS9zaGFyZWQp
LgoKU286Cmt2bV92bV9zZXRfbWVtX2F0dHJpYnV0ZXMoKSAtIHBhc3NlcyBhdHRyaWJ1dGVzCmt2
bV9hcmNoX3ByZV9zZXRfbWVtb3J5X2F0dHJpYnV0ZXMoKSAtIGNob29zZXMgd2hpY2ggcHJpdmF0
ZS9zaGFyZWQgYWxpYXMgdG/CoAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB6YXDCoGJhc2VkIG9uIGF0dHJpYnV0ZS4Ka3ZtX3VubWFwX2dmbl9yYW5nZS9rdm1fdGRwX21t
dV91bm1hcF9nZm5fcmFuZ2UgLSB6YXBzIHRoZSBwcml2YXRlL3NoYXJlZCBhbGlhcwp0ZHBfbW11
X3phcF9sZWFmcygpIC0gZG9lc24ndCBjYXJlIGFib3V0IHRoZSByb290IHR5cGUsIGp1c3QgemFw
cyBsZWFmcwoKClRoaXMgemFwcGluZyBmdW5jdGlvbiBjYW4gdGhlbiBqdXN0IGRvIHRoZSBzaW1w
bGUgdGhpbmcgaXQncyB0b2xkIHRvIGRvLiBJdCBlbmRzCnVwIGxvb2tpbmcgbGlrZToKCmJvb2wg
a3ZtX3RkcF9tbXVfdW5tYXBfZ2ZuX3JhbmdlKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9n
Zm5fcmFuZ2UgKnJhbmdlLAoJCQkJIGJvb2wgZmx1c2gpCnsKCXN0cnVjdCBrdm1fbW11X3BhZ2Ug
KnJvb3Q7Cglib29sIGV4Y2x1ZGVfcHJpdmF0ZSA9IGZhbHNlOwoJYm9vbCBleGNsdWRlX3NoYXJl
ZCA9IGZhbHNlOwoKCWlmIChrdm1fZ2ZuX3NoYXJlZF9tYXNrKGt2bSkpIHsKCQlleGNsdWRlX3By
aXZhdGUgPSByYW5nZS0+ZXhjbHVkZV9wcml2YXRlOwoJCWV4Y2x1ZGVfc2hhcmVkID0gcmFuZ2Ut
PmV4Y2x1ZGVfc2hhcmVkOwoJfQoKCV9fZm9yX2VhY2hfdGRwX21tdV9yb290X3lpZWxkX3NhZmUo
a3ZtLCByb290LCByYW5nZS0+c2xvdC0+YXNfaWQsCmZhbHNlKSB7CgkJaWYgKGV4Y2x1ZGVfcHJp
dmF0ZSAmJiBpc19wcml2YXRlX3NwKHJvb3QpKQoJCQljb250aW51ZTsKCQlpZiAoZXhjbHVkZV9z
aGFyZWQgJiYgIWlzX3ByaXZhdGVfc3Aocm9vdCkpCgkJCWNvbnRpbnVlOwoKCQlmbHVzaCA9IHRk
cF9tbXVfemFwX2xlYWZzKGt2bSwgcm9vdCwgcmFuZ2UtPnN0YXJ0LCByYW5nZS0+ZW5kLAoJCQkJ
CSAgcmFuZ2UtPm1heV9ibG9jaywgZmx1c2gpOwoJfQoKCXJldHVybiBmbHVzaDsKfQoKVGhlIHJl
c3VsdGluZyBsb2dpYyBzaG91bGQgYmUgdGhlIHNhbWUuIFNlcGFyYXRlbHksIHdlIG1pZ2h0IGJl
IGFibGUgdG8gc2ltcGxpZnkKaXQgZnVydGhlciBpZiB3ZSBjaGFuZ2UgdGhlIGJlaGF2aW9yIGEg
Yml0IChsb3NlIHRoZSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgY2hlY2sKb3IgdGhlIGV4Y2x1ZGVf
c2hhcmVkIG1lbWJlciksIGJ1dCBpbiB0aGUgbWVhbnRpbWUgdGhpcyBzZWVtcyBhIGxvdCBlYXNp
ZXIgdG8KZXhwbGFpbiBhbmQgcmV2aWV3IGZvciB3aGF0IEkgdGhpbmsgaXMgZXF1aXZhbGVudCBi
ZWhhdmlvci4K

