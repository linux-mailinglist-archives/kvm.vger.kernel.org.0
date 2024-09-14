Return-Path: <kvm+bounces-26889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1898978CD4
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 04:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64A16286D9F
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 02:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B408514A8B;
	Sat, 14 Sep 2024 02:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ibhPAm5k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E5DD528;
	Sat, 14 Sep 2024 02:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726282063; cv=fail; b=SmW//S74cDuVK0vVD9JrrzVXy3zdzgmoOiR/X33G5iYm0bCYrzV99Trble/YMbDNYqjQz7/FkR8CnjAfZeDKRv4qRhof0OboLmm+/HjTxCmaA9MwC+PKmFv1M2ujZPdXg1Xd/se/KhMORF24F94KTH+JwTTlR8B8RJKzrBJ7vJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726282063; c=relaxed/simple;
	bh=EBfFYu34rXvKAqIC5KuTTl7Eu9VUKvv09db12qPpYZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lyv87oUJ823WnLb4qsfHvuc0Qzi6v8aAraOuuRCqJZpf0as/FVvftOKNVJOzalXhdWweagnNwlGrGTosWNWkR5EvAusa+x+Ktt4C3ONX1oAJHKI5FXhZ4QkcOEvuDH3w0xNuIsh3vVIcK0CRgng25PGrpaRBuswCB0fQL5RDcvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ibhPAm5k; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726282063; x=1757818063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EBfFYu34rXvKAqIC5KuTTl7Eu9VUKvv09db12qPpYZQ=;
  b=ibhPAm5ke2IbpOUS4/krGPGT4Vqgsbsvkc/LgAKaqrRG/0EN8ODyTA1+
   Hf+v22wXlYB4KnpvRKNzq1MX3H9bTOw4Pfo2DNjk2Dxzo3IFNNmLyhy6e
   4ntUD703M6ZnBVXo2JY8pdZ4HqtrVUggncVRw9abMWJyu2EBl10HgvmTa
   KWazGAvHZpxb98qLCPSI5pqiE3Kd6Kt/066b7kCL2PBlw49g3KcMnTACk
   v3nHwCyLFKEHYiChd8mwOVOZ22X50IUSsfYuOtNEvEsHNDsRcbshpmCuX
   +egrdH3hsFUSvw1acAbPnrcxJMjr+yTDIIYpZFsjWfATNZ0nBilgr4E6t
   A==;
X-CSE-ConnectionGUID: pWvNNf9/SYyytgoA40td/g==
X-CSE-MsgGUID: krrYZTAXRmm0S/iuPkfaWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="29091252"
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="29091252"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 19:47:40 -0700
X-CSE-ConnectionGUID: XqzBxkPwS0yljGClzs7OQA==
X-CSE-MsgGUID: 4tGjl74fT3uxSMPpeOVpug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="68225279"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 19:47:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 19:47:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 19:47:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 19:47:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 19:47:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9T8oYGy0f32dshXgZ+dVwRj0EtobnuktpE7MofzsrE74zUoTs2MM4hswxljf8IrUzRkU5ejatDPRoGgzvm+QDZvI9l6HnzT+6ZNiDK6Qt85ZCDz7qqJGk4ghYdIVO0PVHCgDmeO8hcOgC4+mh+bxJqfItJHM7cWy4lFNVT7KDbjB5eDedfpkpGZ15gST7IERp9qENmU+Wqmeni7qkZxS5WVCWaS7MtKuEc/Yb567dYTs05IYZfwTNRpIh1BK5EzqH5TXY0FcmlqsGCP8otKobVbAidqhtbVK+VpCwEMoc06TdX787IzRrhLU5ZHkRird9FzxCNC9m+CIi2zJnBqig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EBfFYu34rXvKAqIC5KuTTl7Eu9VUKvv09db12qPpYZQ=;
 b=UuLNkqtBdAOA8ozt3TsbqDNZI8sE8oeT6wi20oTD9gTd3Idjr6XlX6i/LIzfN7Y+QMRt7sYgiH+YDPsIfyzyDfFRd+fWcwquID+3qpW9XuaEWd1vP7omf183WjT1cfsEAnyyke5gvR3Pu8OgPwPoCXjzFLlJt3llkvFTbm6JrvzQz993vGFI9Xp66BZaI9l8jPBL7V6exo8SPoqBrkal2VYgr0KBLdnSyJdibQr4MNjhTwggPEcvJEpASYeAqcOiOuwTQsc7SwC/d82dMD3TmFqjS2mZNqpcSWnbH1wJ2wpyIS/wWzZ4jiNR/pqiO0r0pD9A4dVUuLa2pyi6umfAqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8303.namprd11.prod.outlook.com (2603:10b6:208:487::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Sat, 14 Sep
 2024 02:47:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7962.021; Sat, 14 Sep 2024
 02:47:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, Zhi Wang
	<zhiwang@kernel.org>, Alexey Kardashevskiy <aik@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: RE: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Thread-Topic: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Thread-Index: AQHa9WDNQ67YRCpYD0iE+VoTl/u3uLJV3PKAgACLXYCAAENmsA==
Date: Sat, 14 Sep 2024 02:47:27 +0000
Message-ID: <BN9PR11MB527607712924E6574159C4908C662@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
 <20240913165011.000028f4.zhiwang@kernel.org>
 <66e4b7fabf8df_ae21294c7@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <66e4b7fabf8df_ae21294c7@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8303:EE_
x-ms-office365-filtering-correlation-id: 134ec7d1-989f-4f55-af83-08dcd4679235
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?GLDChXPcwMUPO7xwycL3hQl0rlLqnDy0XvsI6yHnHETnloO5zkaY+g9rAiA2?=
 =?us-ascii?Q?qUQjZ59qItKQOL1q4PvI5GYcQ/AI6S9IqX2QppTwFpqe7SYLicX9jmHA2qlr?=
 =?us-ascii?Q?quayS2AxsblDfXSOGvjWoRvnsBHnqyLd+UwccnfvsbT8L2AXtnr8/tG5x1LT?=
 =?us-ascii?Q?KnwViwbfs4nwJFTAbfrzr+2yUucHEiuiosVi8+aCvHONRz++mBacYkt/b45X?=
 =?us-ascii?Q?wDXy6wgoMQB7dwrR6IfjBU/qJDwjnrWQvPPkU+FtcXPUNx3rQs367V743rYA?=
 =?us-ascii?Q?Vjx3oOepIk4cshx8dNp+rhh+gukz6g7ywxwGML9UcsUKBYqoA0m1Y8Sr5fcL?=
 =?us-ascii?Q?NyqH+XE7pIIpv0Cksq1xrDuMs+voidmKFxMsrnbyVyGoSFUkHR3Uheur+cPK?=
 =?us-ascii?Q?TlbixoHtLKPmuX9yZg1oG92ZZK45h4XrgHY4+w+jpDCEPMPR3DzxnC5Ex4HO?=
 =?us-ascii?Q?+6MRk021YuFhYE/jnE9gP1Cglaev4FcmVvuYp3WGu5AEdf2j4vGcWxfqJmtn?=
 =?us-ascii?Q?gSAaUq9uJVfOMPepb1LPYgLfYvLe6kIBMdJ8tBKK8iX8voT+TKMFtmv/QjO0?=
 =?us-ascii?Q?YIbAectBefnQEVOYDdkBkU7K5Lboa8zzsWvBaexD2jpewzrBX5n9yHbCG+YP?=
 =?us-ascii?Q?pUTE1oT67rFNFdVlfWf+Z8/BtjSRFFgOHS2uSk6/TSVpp9IS2LMztGYtAK/8?=
 =?us-ascii?Q?i5w9Sk6z1C9I8510syNERvmMM9q0Uv9y1sHOvOcApoZHnYPTnO1VbUva2WuM?=
 =?us-ascii?Q?T87YBRhV44pNsd583OY2rIv5yZ9Ow3xYXBq//hIizIonROQ3/rxzaI0fhVt8?=
 =?us-ascii?Q?M/QaA+qhTIq0g0ZmlErvwrEaD5B382Ax14JqlsfnXZ0Kc5cC2z9qdkB1VWzN?=
 =?us-ascii?Q?qHIUoqEU2z2OPwfV4VWtbcJA0CzF/n6GomIlE0a8nAgwQAhL05zifGDu2SCD?=
 =?us-ascii?Q?dNQITrk4Oym+4/Msk6l2SlSivKhqWpsL/CNcwqP1j3OWeojAk5s1o9mVpCPf?=
 =?us-ascii?Q?f2AYFMdruOBxq2ZWwS7xWMnaSES9JDZsuGMy2vrDvQc+YhULoxe8k3kBxMQk?=
 =?us-ascii?Q?2MwcEbq/2FZhPZljjc2fuGYPUgKZ3u8Xybo2yso7/DCf+5QD/KkngAc/5rwQ?=
 =?us-ascii?Q?Ky7sMa/B8AguDM39TEmixG0mimrBkB+6F0LqFM4xDSpx2KIkxTyyygzfy8YQ?=
 =?us-ascii?Q?XSNiq/SmsYPGgZEP9FKuQAVDYpzRrJLrbB1ziAoDE9r4WkEitBWHb1RvpUxY?=
 =?us-ascii?Q?M8rBIZsC50VnW5AfIqQiGfFWM/mkTpOtmKuFAwd5LUm3gdRr0Q2zUkyPMfhY?=
 =?us-ascii?Q?zcaHinlMOPf8JHW3O8ki0O0YWwvdAb7bgHBJhIBu/fsoKMbuFinx8PNRj6Iy?=
 =?us-ascii?Q?Mfjw2iT8zKdWJb+gbCasgSq24Fnaey2W0NRrGPrO7fD4+LCDMg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w5UkG/ouDpQieYVL+fH9+7getaxQeIZO0tQws5F39jVRbK0awZAW5Bv3H2Z7?=
 =?us-ascii?Q?4wRSq6I+DCxAj2Fs7YtZFvVBMflJJCH7NgftBbfCd9/MiJb7tPoggR6P3KvI?=
 =?us-ascii?Q?e5fbGmf4o7Y37PueVIbANbnR9hzyv9vibTWIVnT1b/XmloUTIaK8fM74tCJX?=
 =?us-ascii?Q?1LH4znWICK1Pt+uaVrdri4IkgMB2jIBcjqyh3Dq9FymFu8ZW1agfq8s4QS/r?=
 =?us-ascii?Q?nlnfaJAnOEf7mldj34QADDGnwaPmeKMPQ3fQ+s9rHDh1KtfmlJi1gihGTD4N?=
 =?us-ascii?Q?uUosWiOK2hFAat9Bk/ggcEASCw4mEOWVsuRIE6S48EW2w8sqtv9Faaml/o8N?=
 =?us-ascii?Q?Sx6qAcijwr6VqpJZcz4CsYMv+hTWhJ0yqjJgFXVbE/izOE+51WDCLKIH3uJO?=
 =?us-ascii?Q?HBhrMdOdTZIkDEnjE3gPaIukbEyIUvj0sA6Q74ai5XA/Tqekq+DLe5NyaObt?=
 =?us-ascii?Q?rMYzeBu4aJJD9+lffHkW2BcJWOGVtSE9y9JmtPFvYpOJ9NE43heY8IarTZrJ?=
 =?us-ascii?Q?9c4BR781PPw8mv0o+IdmShuHoglh2OyDaKCD03mAbwY4RjtYRlotRi/n7gVl?=
 =?us-ascii?Q?pr5fNDtPTeSf2yesKOyW3IXcE2rRlkzffqnsxfL986pGVCobUKpqrbgGG8FP?=
 =?us-ascii?Q?v+RWxzYSupWmfbynsWDh+QHsrFI5VeJZnqzHNgTZzdm0cy6H4wLD/txsMFK2?=
 =?us-ascii?Q?7t4LI4W+pZEmpWSCb32B3NPRFMi3qJ4VO30vxUv+C+ot4owcylq7+AmVl79W?=
 =?us-ascii?Q?OunmZQTr+7iDTqwbMbFgmSwfhchP4s9ksaeNDoNM18DqKG/VHHL/dWcXQMaI?=
 =?us-ascii?Q?AzZh4b+OdsFum4A8y26FqcOpuUA0BWgBvX/odWBPZYs730lIxzKAbf8oVnkW?=
 =?us-ascii?Q?zA4n3vMbroGbwVkrLO2WTNX3cgWJcFuKZbPTcIBemXEkRkWIZeXW7k2ONlqK?=
 =?us-ascii?Q?yuBRVazBVsSrUloqgH9pFjhO8thGsMzOut/21/nVRm9xd0dgao9p885EpmIB?=
 =?us-ascii?Q?JsQyqYDs8vz17Z6l3ZAPwRpVZVD2UXJBl+hpzfOVdN32kaPFiuPybmlRhjMJ?=
 =?us-ascii?Q?d/Wa4bDxD9WyNaqPIpwaOVDhq/BBG0v0dZ7iXFq/6F7F37QwKkbOH6iTaQWH?=
 =?us-ascii?Q?Pi+TJaegeV6oAIqzEqvHnwBwk3JJ+Dr/ednxwIwfZ2bJBIXGBHfVS2M04ZRT?=
 =?us-ascii?Q?J5/Du1ID5KLopvxgBGQKa4cSeOJCTbVHCZUJtzgZ1P29JgGvjOycaqJ9G+/H?=
 =?us-ascii?Q?iEoITvfjtlD07CtsrBwcf2DaNS9xyuFSpMZgi5CKDHqRN3Od7G0U/dQVSf0X?=
 =?us-ascii?Q?fFk5sGeztlHR6M4Fgp9fg6sGoR2TBc0A7JY77w5ZOq/pg2Mj4ENH8Jdis6p9?=
 =?us-ascii?Q?olUrWdWJxEPDQHEG+cJQFqGS8CGgqxEmcxpRnitbQsGRcCT07ukc2bHF8Opi?=
 =?us-ascii?Q?VdXg50gf1CGtJ7Dp3X8wqABE6BIF9TfTd+MDRpUMuFxMsD4pRJUoa2cUwk4u?=
 =?us-ascii?Q?4SyZ86UVqz0a0D4WAOsCSTrRmUluTb2oVR+M1TemAo11Os3c4dSTEfdHQhXd?=
 =?us-ascii?Q?eHEjty+z9VdEFtLeQqjXuX1VWX0GOSCG+TGecUcr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 134ec7d1-989f-4f55-af83-08dcd4679235
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2024 02:47:27.9075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88/Cpdv+C68vAPY21vLlYsrgig2Eti66AbKTWGtx5AjsoMv0RER7lese3xniGV8z7eOUc044RDsgIZUfPS+h4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8303
X-OriginatorOrg: intel.com

> From: Dan Williams <dan.j.williams@intel.com>
> Sent: Saturday, September 14, 2024 6:09 AM
>=20
> Zhi Wang wrote:
> > On Fri, 23 Aug 2024 23:21:25 +1000
> > Alexey Kardashevskiy <aik@amd.com> wrote:
> >
> > > The SEV TIO spec defines a new TIO_GUEST_MESSAGE message to
> > > provide a secure communication channel between a SNP VM and
> > > the PSP.
> > >
> > > The defined messages provide way to read TDI info and do secure
> > > MMIO/DMA setup.
> > >
> > > On top of this, GHCB defines an extension to return certificates/
> > > measurements/report and TDI run status to the VM.
> > >
> > > The TIO_GUEST_MESSAGE handler also checks if a specific TDI bound
> > > to the VM and exits the KVM to allow the userspace to bind it.
> > >
> >
> > Out of curiosity, do we have to handle the TDI bind/unbind in the kerne=
l
> > space? It seems we are get the relationship between modules more
> > complicated. What is the design concern that letting QEMU to handle the
> > TDI bind/unbind message, because QEMU can talk to VFIO/KVM and also
> TSM.
>=20
> Hmm, the flow I have in mind is:
>=20
> Guest GHCx(BIND) =3D> KVM =3D> TSM GHCx handler =3D> VFIO state update + =
TSM
> low-level BIND
>=20
> vs this: (if I undertand your question correctly?)
>=20
> Guest GHCx(BIND) =3D> KVM =3D> TSM GHCx handler =3D> QEMU =3D> VFIO =3D> =
TSM
> low-level BIND

Reading this patch appears that it's implemented this way except QEMU
calls a KVM_DEV uAPI instead of going through VFIO (as Yilun suggested).

>=20
> Why exit to QEMU only to turn around and call back into the kernel? VFIO
> should already have the context from establishing the vPCI device as
> "bind-capable" at setup time.
>=20

The general practice in VFIO is to design things around userspace driver
control over the device w/o assuming the existence of KVM. When VMM
comes to the picture the interaction with KVM is minimized unless
for functional or perf reasons.

e.g. KVM needs to know whether an assigned device allows non-coherent
DMA for proper cache control, or mdev/new vIOMMU object needs
a reference to struct kvm, etc.=20

sometimes frequent trap-emulates is too costly then KVM/VFIO may
enable in-kernel acceleration to skip Qemu via eventfd, but in=20
this case the slow-path via Qemu has been firstly implemented.

Ideally BIND/UNBIND is not a frequent operation, so falling back to
Qemu in a longer path is not a real problem. If no specific
functionality or security reason for doing it in-kernel, I'm inclined
to agree with Zhi here (though not about complexity).



