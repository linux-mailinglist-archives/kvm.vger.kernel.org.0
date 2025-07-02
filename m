Return-Path: <kvm+bounces-51248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84DA7AF093C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 653B9426799
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C975B1D88D7;
	Wed,  2 Jul 2025 03:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VlydpkQQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6A3134CB;
	Wed,  2 Jul 2025 03:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751427264; cv=fail; b=DPm7L6cuwk9UT4jeBJes0V6Qk+0ZhKXH5M7w6JLHouAuYWaobMkcU5N+F61CTNPoT3Vs5qBPQVmqobCxh85UnM8IgWsLGVx7cJQGccpnm04KzDfUqSEdYXkC5hDO+eJsycdQst9P481ZcL3vLyM7X6tKiwHAgyyv+6pw9TcZfJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751427264; c=relaxed/simple;
	bh=zfDihXKSHp+7d2dXV5V1nTwex/e4RTpAGp2ajpZkGYU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IKHWjjITw9V/joVmXAOu9ijcTEmlgHtl6Ng3bR7nHFZRrFq+uUpOMM6jyPOEhxKLAhfGn/LqZYuJt1Sf4c+dPj8PAwM8NxzXSnoQpmJtKLa7phQFCUV1YgFwXpvhdSITy7VKw7NtPb17rzERMZ+MQwwXCdqCmiAT0CPWDFvI6Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VlydpkQQ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751427263; x=1782963263;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zfDihXKSHp+7d2dXV5V1nTwex/e4RTpAGp2ajpZkGYU=;
  b=VlydpkQQPnDfXSlOfvApWJYiIxA9thfVoB6VABmjzS1hx9G0ATYzAOmg
   hCpHU6MaXTbO/jEslM2Uzs3ktWirmAIG6CGRSgQOnifrWxb7rw0WQceqb
   n2iFAraOy4NH3eUqQDSXtQ8XEERImC1vau8yQkiurVexkaw5EdLUJGNhu
   CPdmcbYN9H/xwE3b0nZAAuGBRAhiN1tSt5poYRi54SWweRMi1UauqqI4I
   ytvY+e2wvvM2XqIGqRA96JCilto1DS2sHeOZvHy30UCqYN1xn8cy1EBuD
   UqUNpNkkDqqTngh2XNRrpglJMRGI2tGLqQ9JmaL3UFSEhKZKtCcb4XtxC
   A==;
X-CSE-ConnectionGUID: j6Zrfh1rRfm6tZZfUTPZ/Q==
X-CSE-MsgGUID: 91Ags1KZRFKhoYWUmS3Wxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="52824102"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="52824102"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:34:22 -0700
X-CSE-ConnectionGUID: 1uroHob6TY+24QKKVhCo7Q==
X-CSE-MsgGUID: 07mDwV3ZQ1eI02Wsy4C0SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="191128251"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:34:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:34:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 20:34:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.78) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 20:34:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rlgh8+H8C+d+2Rw86HZc+NVDXk+UvVFEO9siPwxcYGnJxaQR9xxqZLBiAtVv5Nr7RabPLnGpl+2k+Wy8AlKBfJbbPLX62udyMn7dKZ8t5XP1lD9Ooy+/2ky1bL+4v5klGbWvJ3Bs1B0XXa0jzf0qB+V+M+FAiRAmLLpUGmx3K/cQVBw1yyDxA2XsCBqbqODNbJZhKoSs/JHY4w+v8Z0J8O7ajXN+2n1beMKKyZIZG+OMv+VZ90SR7z92bHgK2p+dym/tn50EVG5np/mtw2XvtiMroYE6Mx2AqplbJh+tI1TnYTg1awa+pmKq9ylu7wTXW5jYg2Cf0jsHYjXJY6PmTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUlxTpO7TSVkOikCQslOBFz/VMKJY7Sasg91OeE4rjs=;
 b=H9BKAz0HOwnQu/Jio+rTqAXJCVjapHAKubopi2c4hA8Rv0r2mXNJUzIVN+Z/Ip03zws4VdKlYLSZU1mDbYI7ejeOP71eDaaLKb3ntmCCFYutyBzn5LMMK83nvoO9mflvYYeBeeyJ1IDsZLUhSmTS6JQaZmDK+QdqOK18UPsQKHipafQHvVV2khQO9mI7XYDBU4H0OWbuShDKbybtDswOx0REGu7XzOGjM6VCYDmjl240fSpT/YigkfjUCvIyzGGNm0GV03j1MitBIXM8MTaCmShEb1iEHhYqMDXXiX9SUUBGjK/xr8phUEPVzPDIzMvmeWQea7pK09iYK1Ar/Nrh4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7856.namprd11.prod.outlook.com (2603:10b6:208:3f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 03:34:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 03:34:04 +0000
Date: Wed, 2 Jul 2025 11:31:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aGSoDnODoG2/pbYn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
 <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
 <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
 <aGR5ZYpn3xyfOZhS@yzhao56-desk.sh.intel.com>
 <f13239faa54062feb9937fe9fc6d087ffcca7ac6.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f13239faa54062feb9937fe9fc6d087ffcca7ac6.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0121.apcprd02.prod.outlook.com
 (2603:1096:4:188::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb5a760-d4a1-4dc9-e120-08ddb9194ac8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sWbMRCW0NADJ+1lok6n6ZuhQvm+286lYJ8zT/ExqDBK9sGvtWnS0rp4mDAlr?=
 =?us-ascii?Q?xmGblpF6YiOTWvQ/JmJYn4IFZyjAk5DpqyVPUNNIU2Z6kFEgra0KwjT7kM9Z?=
 =?us-ascii?Q?DuPylCHDxeO19+byJ5BngMtEGyM1VYitWDJswbvojgCpKHzh1kwrq9FbrAAj?=
 =?us-ascii?Q?ucAeeT5A+WBOunAp5TGYdsTSK7GWTm29Z9qYE6wcxsk/HTri2eGmARWpSuZ4?=
 =?us-ascii?Q?ARirIIYKLkIXNSJikq8QPH/PiFiNHdjbN1GeU0fZIVFca+HmxS3i0k2YyNLS?=
 =?us-ascii?Q?Mn4ns54kYRDSSoUEg8aJdBkkQxQRbdxMM3bc98tStkxQRZt8fZT7YeEeK+wW?=
 =?us-ascii?Q?G/mA71h4d7nZNCWjefQg2i/5HfGeQJ49dHp8J2Dwa1k1Ibfir2s7+L8s8dPs?=
 =?us-ascii?Q?Kjq3uOS0GP6Wy6OegLoaguWxn1RXpqO+lL80OMa91Vgy+xXoxO4ZGpQh283V?=
 =?us-ascii?Q?qoN/s3mI41/glHsP1c0/E6Slyu+u50XN9ib+BlxZsquP1bDILZjpDLlijj4w?=
 =?us-ascii?Q?AQK/HGyhL8O33Owj5XIU8am92bJ/NIhlGKmuFICQx4vUvjP+bBSW9iEUwiHk?=
 =?us-ascii?Q?7JyqmF4CBJza28Kbj6VOAWxkuPdzgTz5HlcmyJqmenWnp0FHV63lAB9R3g3X?=
 =?us-ascii?Q?gnOOx9iEpxqmP+k6fiNKvL5zAwww6MsDC8/E2JExT9+66KQ33Lzkw0AzJs9g?=
 =?us-ascii?Q?2ipV9Z78lwsccgh/fHDFChsMqHomQwT/bygHKYKnX2Q5u1DH6GQKoyfbSY3G?=
 =?us-ascii?Q?j9D4PsJVl0BBB8MorzSKhCUQW1tGig9peNfCREJ9MnP75FoycIbYJ/pioN5S?=
 =?us-ascii?Q?XVQVi0d4+iH8933h//ILp/LcTHdbdWoOYQ9yP+cCFoF2upQM5KLXSqfkubFK?=
 =?us-ascii?Q?PpOPgYxTEmModyjPNZKP8JHIOPdEsfsvYzU9jkVqISAdjBd9oE0H4PpODaW+?=
 =?us-ascii?Q?fId4HJX9+khVS34gE/ScFZqL+zlD72/LCjS3n2DiPPo6raaDliX6muheKxD6?=
 =?us-ascii?Q?/8RzvMNprcHV9kOQJoOUdqNAUUzHiv3dittvaScwqdonHdEJXoYnMVXvu9jk?=
 =?us-ascii?Q?N6KlKeB8IODOD9wyIpq1W/2GcJxd0q6YmIVmAui5UBzexCxdbU550IkMwFTB?=
 =?us-ascii?Q?wwGszU7QXASBAotIyE8phIdkgeFDVjoAGpW7/UUUAao4VvhcDYzhbIcDLiHo?=
 =?us-ascii?Q?Ulyqc0NEGx4/eD/a81eXNHQVI2ZKsrDQsw0cu0g/g33bAJWQWtAFza3SdZM6?=
 =?us-ascii?Q?lKuXbmV0Rx4x7sDwzFcplbrDaRWbn9pKiRJLKIT4rCtf/SWlKe9/IlsdGp83?=
 =?us-ascii?Q?3DmzFFi9qcwl8xXrA+RTr39kkm/Y3tIGRDZVaKPJfn7k8qWfAST3Uz84MJUE?=
 =?us-ascii?Q?C7vplqrsgDgu9w7cxaFEQdq14ovMLYZKtk+kH3fTxvkH5dHSn3ssWGRSl7PK?=
 =?us-ascii?Q?+CzZdj5G/MQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZxkQGbaVXbvC3hOME/n0edf7N5KK9UWG04+hQee+pNTGO6BrYABA3/jpOFC6?=
 =?us-ascii?Q?/nGfhhh3qlLOy/gsyUqrf37l5bjm571YJPOLMONXTSWASgm92e2mnFVqfCTf?=
 =?us-ascii?Q?VvHPJVSFN9DeO0XmV7K6zXMuy/Zx8PdD/jZu2bcJB6uXm7mcFIsKZqadWsDB?=
 =?us-ascii?Q?8f62e5ptZdoLUB9WaG8uIVRFyGuOyqPK/44dUvRIksujRRGuvyuWuPmVmUFr?=
 =?us-ascii?Q?iKmsDidkBIbHGlUabzrm5pSGTfuWrjjZkA8uBmHt58OcuPxf424NyAP5fmcF?=
 =?us-ascii?Q?AAaLU+9eb3puxTxXBjNISC8zlPab5mP7L2tv0HyP2Fsbm6JCtvVMmym/szxI?=
 =?us-ascii?Q?NL6Ij18bVJZgjOzenB9JTOzkf6KF3ejr0+4MU/F4FWtTyA7jXBsOdLE1XETS?=
 =?us-ascii?Q?SdvSSUAXeWh6RxPl18MI6lROsTQo7kQgKJGMy48JosNft/kJBsiZd3A6NHDA?=
 =?us-ascii?Q?yG7Rw9cZJ2HQJHZluGoAL7CGyap/Eg1FMj4FGtAtIDU35Id/FdA+QMR1v4y7?=
 =?us-ascii?Q?iaZ5VZLaPNNytjEo6HlrnQ7FY/bXHVeCIaTlbbDQH5ZTAPVECQv/uXkXfX86?=
 =?us-ascii?Q?YtsGlk5j1LtbO0UJtOYG9ZVaSOgKiafGqV/AqRuoH99B91ivm77Vqa00XXsq?=
 =?us-ascii?Q?sWGZY4w6q97KhADnLSXwL8wETYqrxIbNsE1StjgWpXHxzJGllyWAqgmQtHTF?=
 =?us-ascii?Q?adq/SCITvtosMbGkOaZDySvtg7Mmy6wsJAJWc12MZ6Zh6x6DuWpe2g36dlx/?=
 =?us-ascii?Q?aXnis2p9EQJIPv1aov32xYPiRVnemKDXR1mAGl58+PoHeDM1EFna3STPtNxI?=
 =?us-ascii?Q?ygkdcPY6nY7Ce/U2JHoMeFqGor/IQft6i0cpR/GgvV1ya7wPaN3IGr47yBFC?=
 =?us-ascii?Q?DZf9VeAMsUnZ0wCkOfo6PoFPMeaB8hiq6pixmiASzVVDPaKg3oZigbgi31DF?=
 =?us-ascii?Q?vEUkYH792Dj3YCuXyN068jUIfFph1J3yHi6TWjqy0qaeRvByOOu39RTrvvPZ?=
 =?us-ascii?Q?9JbL1aD9BwOyiIQyr7y4KceRREvYj7ObvKRa7iT8DC3FfMV0EoyS8BfJ5SVP?=
 =?us-ascii?Q?diKUdChnhYB4rzaxVlJoWgzGw0BK5MIaB14zLJjwerN9zEQ2xVtRam4oJ6uX?=
 =?us-ascii?Q?jym7ksNP8DiDLo7c1YeqL3V8RLxs0JBc0TJ5BqEgP410bAVd9YMrEVcwXml1?=
 =?us-ascii?Q?BtrpN74AT9GgNPRvmylsW+5oh24UmNqJcs7wl7jL4lp2vciSqsPoztBewMcA?=
 =?us-ascii?Q?jcT31oIIzc/yPTpSbc9fAzA8otoY0/sgtRnfyxeBB0R+1INOVM9bqmbwH8QK?=
 =?us-ascii?Q?gnXx+U5d+YiKEr29ILlYqcUsd+sPySG9cEQ2aDqDU4+LbGJgzWHxc2VutkAU?=
 =?us-ascii?Q?UXj2o2YrbvW1Fv8OZwlObfB0m0tYiqTS45SGytXrXEn4PXcmDgTjrGwcQiWA?=
 =?us-ascii?Q?KYSwNGrFb4gKslv/I07pohdKbMlnAmwjV72qvw0+rNwTMBxVwgaZLE5eHveY?=
 =?us-ascii?Q?q+UuVfYTtLDWNUrUqKNTJI1tSxjoo7NcGI2ai7cicNWpSpelduInxZmur2qT?=
 =?us-ascii?Q?Ddnp6y9ER8Ma9nXDnyuEVSkenNDLQT4LtnUS8TIa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb5a760-d4a1-4dc9-e120-08ddb9194ac8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 03:34:04.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Kr17BKz3tS/IqSw6otpcfiKpcjO6Jap3U4v8kgQUbID+pKqGFMwfgAUy+cUtBTyCAyzoqL1dBhtFKvbUMpLqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7856
X-OriginatorOrg: intel.com

On Wed, Jul 02, 2025 at 08:18:48AM +0800, Edgecombe, Rick P wrote:
> > > We need mmu write lock for demote, but as long as the order is:
> > > 1. set lpage_info
> > > 2. demote if needed
> > > 3. go to fault handler
> > > 
> > > Then (3) should have what it needs even if another fault races (1).
For now I implemented the sequence as

1. check lpage_info, if 2MB is already disabled for a GFN, goto 3.
2. if 2MB is not disabled,
   2.1 acquire write mmu_lock
   2.2 split the GFN mapping and kvm_flush_remote_tlbs() if split is performed
   2.3 update lpage_info to disable 2MB for the GFN
   2.4 release write mmu_lock
3. fault handler for the GFN

Note: write mmu_lock is held during 2.2 successfully splitting a huge GFN
entry and 2.3. So, it can guarantee that there's no 2MB mapping for the GFN
after 2.3.

Step 1 can help reduce the count of write mmu_lock from 17626 to 11.

