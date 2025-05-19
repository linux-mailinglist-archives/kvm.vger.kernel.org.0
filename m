Return-Path: <kvm+bounces-46948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F07AABB3C0
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 05:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C478164136
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 03:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE071E8342;
	Mon, 19 May 2025 03:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P52eXZaS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3215B135;
	Mon, 19 May 2025 03:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747627165; cv=fail; b=pJC21dWmLC1tlGjHLEhJprmY+1bTyIQIOgI90J+9fJNDn5RkePtfrdTAL0ccpBBs/wksBoHSzficB8D67IfQaXUwH3zH7ScyYSEMqtWSji0ItF5xnfEHLVfWtImSFV/4PfW9u0z+6UV60DJ1X0uAX18lI8uzs8Iyt+9sXH2M66I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747627165; c=relaxed/simple;
	bh=jgXZ15ILeV7mbAn3ZQl5sLmj5/Lyi+2aR7gmPOcwlC0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LFcCXUf2E7iyHWrojkm/cV1FB++x8p3kYFxTqlbH6lsl3r/MSNZfy39Pm8Mq/qTheTmqHLSgIdHj1BUru5Ku2K66niKPLO3wM6UJ73gkaJ9JXRSapKx3TXdRUtB7kOEIv6hl9+RE1Nb05eprlskSJwZj6rDwT4QDpVsq8PvFepc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P52eXZaS; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747627164; x=1779163164;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jgXZ15ILeV7mbAn3ZQl5sLmj5/Lyi+2aR7gmPOcwlC0=;
  b=P52eXZaSLcUDle3tdJI8el5i1SuILLSe6lLpgqSWpF05bJRBpPFTvvq7
   ckRh4zb+lmajLKayRHmBMklMcLej9XZMtHJb9+gHtF8NnohZ5z0uPwgcv
   XInoBzR7/+HeOvkuAHv05BDGgaulBoDdq5n16u5XkLC9TsA6FzPlXyI5q
   H21xyIlE8WIma3MYuDJtfN+sCF1M+n7J0/FGC52wq5UsGKDwX1o1lGv28
   5EznMCHk7XYZ4Q0a5BCUV426HgzGX3n7YxeC8Bgq2LBVCj7mW3FsP+Mwz
   GNU82p5Rm+wH2wGNAD87FtOzxdkbBD4ynG4G9hME83LbHiFHlKznDoRIx
   g==;
X-CSE-ConnectionGUID: y0XHiqPvRRWZ07lcbCb30A==
X-CSE-MsgGUID: DBgn/XetS9m3T37+NFdv8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="72016230"
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="72016230"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 20:59:23 -0700
X-CSE-ConnectionGUID: 3R/oSYq2RMKJ3oTZLfr/Ag==
X-CSE-MsgGUID: xAWhqyiGRhe+JbIIAsOBLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="139654547"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 20:59:22 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 18 May 2025 20:59:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 18 May 2025 20:59:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 18 May 2025 20:59:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eo3Ybk2CuhZ4iE1glT6zwXhPlOxSknxKZzjnHS4AAMLRn99wmYjbxUOrePorWXFoH4xX5mj5vLC6eMGsy1gIYePC/1MrzU1ne6tMQRyNs9bZuz6VQclbRhefI/4Qs/xu+F2uI0dWU12ZFZ/0e9k6vb+Fo4RfutDQAWfNhUH7r3vbB+v3FHx/j59PKYcuOVhfg6x3BjjpzRsJx06tCAOND+Mx/KcKXBv5Bek/hwt2aNeCBWOKA2Gh33HMOe28bKa76cQ0yO384TtxhW77Q+muSDjYuGYfKCpZ/fRWd2KZwPt1kDOyqDpeBJyCWYcuwt9MunytzIDVuxFzmwfeVtwW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k16SUppE7V+/4HeuYD79laiZojfVWJjA8i6rNueAqiI=;
 b=yFUj0rT+33Xdfe2AuacDi8AO/GTtO+YJTOYROGvBFEyYRIXMSbKNmht/w6l8FE1w14BZvZzKVPSEQ9CKnBXcV8TMdsZ6ZKWa9pXlztVB5vDryOSAjLTmdTQ00GPOKSP+6PSRxYUBn1xCWRgJ0EhYAL2aIFyUMhYNl2fRjilNq60sI5VQrDJjJT87c+1zOQ3n3IrSKVuVWHwKqDC+oLJ22xkMKwQToM7Bk2Gnm+xJQO6WhiGOfLEPA5MltSP5cqtzzWtVenvV+SC8b39yB3sMWEqnY4mJS/pv/N4zsiV8v+ceDt1Ls10hjhlpzauCQo/cztAfCN/EeU2kLAfrUEpPng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7178.namprd11.prod.outlook.com (2603:10b6:610:143::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.29; Mon, 19 May 2025 03:59:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 03:59:13 +0000
Date: Mon, 19 May 2025 11:57:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Message-ID: <aCqsDW6bDlM6yOtP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030634.369-1-yan.y.zhao@intel.com>
 <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
 <aCa4jyAeZ9gFQUUQ@yzhao56-desk.sh.intel.com>
 <20fd95c417229018a8dfb8f3a50ba6a3bcf53e6c.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20fd95c417229018a8dfb8f3a50ba6a3bcf53e6c.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7178:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1d8f28-6256-469a-c5f0-08dd96898416
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?HK4XxOaYD4irkjjGw0lhtYprFZsHiVI3Z+zVaOBYGofNUY6nfsUE/38rkI?=
 =?iso-8859-1?Q?lyykbkp8b6eihr3oy5vHHorhHztDgEvpzUdMnGk6dHOS8SWKWCv2kT2zIK?=
 =?iso-8859-1?Q?GDnx/kVjj4/+ClyYk2SpzTG1A/toKrBu6c4IbDPisprjGr+VwoHu1sTdRb?=
 =?iso-8859-1?Q?lFybnqUfWpU+wghKBNqEZ7YE+JYVp/FBITM8jGMCIi3/wca9cXRg2hI4d1?=
 =?iso-8859-1?Q?gogvt2REQpIC4bpLREnkrP/Jez2hMGotj/IuwKUOeUR40cltUH0w/Gr92H?=
 =?iso-8859-1?Q?SOfLQoVszhhwSMoU/iKTD5dt9AqcH/RnhdoWo7dAdKzt4MVRo3vGV4Nhne?=
 =?iso-8859-1?Q?wlJNkXB/6uLMlkTyZrPydrAnjy5NM5WHF3QxjYv4BDjZ3zWI3oNB4HqBLM?=
 =?iso-8859-1?Q?etlRFQ36iJZ9wD1qPW0v+Luy64He7FRPCKokPAue1ObFIyfjhakJOXohRg?=
 =?iso-8859-1?Q?wTeFGLgDo70B9MctjyICBVkg89IC6Z0Uh6ZIqq6Z3IkZtVWRiv/ugyUJxg?=
 =?iso-8859-1?Q?gd+aG3kRrbpA7X0BdxOJhn9igqQvXJulJzJ6d5I9ZRA8n32Cjmal7jcW+Y?=
 =?iso-8859-1?Q?2/IFbwUeqMqVoAzTbxE37NgNH26rZelXPqzX14nq2H8KZaXiCF47uPG1he?=
 =?iso-8859-1?Q?0ajnKgaspODIdeHgi5ywvnVf97WGPbK3KUHR/zq/57mrWLrzay01cVzzYi?=
 =?iso-8859-1?Q?kKyudbZfz+k/wKZoH1MdQOUI3DPXEkTOhWyn5LAH1E62iTycNwYpMTYcRV?=
 =?iso-8859-1?Q?V1ZoeRQUWZb9kb5eE+iRCT/QNVQxFEHzZOdI1mod9Ht9TItPOIUWmQsfg2?=
 =?iso-8859-1?Q?fp8+dsiY3UGCD9gJZO50ONk9K+eiEePXOF9yN3rsUe7GNsupxZZ3btuHf7?=
 =?iso-8859-1?Q?gXVALFeZ9sr33RyTXHxqAxdFlehBHefKnI9tt7LL9UNpiMYW6hzZ8LOKxN?=
 =?iso-8859-1?Q?vncxQl1i3hLlhP+cybxmQgxyAWfGZeb91Utt388l7GvbRHjvYXXXR5cK1r?=
 =?iso-8859-1?Q?Yc9tV7JLrecbUy6aiXThNrLvOpkcYa9hfQ3/QkhyfIChembYIhWFe2vYWv?=
 =?iso-8859-1?Q?gGPDGC/gUOjct4QEgLRoZaBafGJxqwzCqZiHH7aQM+6FiAO8y8v5X12Q1u?=
 =?iso-8859-1?Q?KwY0RrRsHxO+epI8do7fphap8PfQuwXd9IOnXc7fNcG6OGi7IaXRNP0Rcm?=
 =?iso-8859-1?Q?fZcjkRI/ypN4MFSrHfO5hcBS0LMslR4ZIYyxxXZATTG87zXLwzvDKjF71W?=
 =?iso-8859-1?Q?gvtcSm8I25PqdNozCkcEklxJcGVQ3seqcjZuUxUKzGn4g0gbBiEZyqNYSC?=
 =?iso-8859-1?Q?RAwRitw/jm1uh8SeTpu8z6ZKkDgdcXaf09jRqImI194VoKaBmx+H/XhQ8r?=
 =?iso-8859-1?Q?yczux5ELBfuOZnHNnBBM8loDbp4KTNaRJzx8T4DBggBHvyv+V/CdwbFZO2?=
 =?iso-8859-1?Q?6VjoZIXhs8RE8BH4AVRnv4h89bBF07jGkpldIk86Qwol2JiP/a0dB2CdMI?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?pfMXLjfIDek61+Au8/gWGTSCtcZ2JHRqzVxKfyS3X9Mh2qXMExa9/LHED9?=
 =?iso-8859-1?Q?hsNWKzgZ2JAtZcvb+3kAEIssQp/yYvHbPsjz2/jHTbgWlLxcWFMJzlxlOv?=
 =?iso-8859-1?Q?pH4iHFM7E+BNOvUVL+R1IeVDD51TlA3PdbC1W9zpL00dvgVnqyR87lzciX?=
 =?iso-8859-1?Q?/fJnaPYMVtFpiUQi1RIFQcM3MDZ4rUIZZWlpKibWDOOkW8jA1xmdhfpgTN?=
 =?iso-8859-1?Q?DdNsVOqhl3OsnBC3OY9hezcOnRMAM1RNU4rcbtRRZMd7jaPvv+SJbYNz7r?=
 =?iso-8859-1?Q?H15f3n2GYCQIX7cBlrO9PbDd+RIKavdKHpiMtCn7dV68s/JZ7t4rKnI9kb?=
 =?iso-8859-1?Q?g24YGVaaDWChZ0fWYU0DueZBeUB2djn4ytsI1KRNfiJ1CuZwQHX/3pMIcx?=
 =?iso-8859-1?Q?gK3U48I/rhSHWwk0Hq7WX5uCdTpMsf5iP07psZ7PP4xk24CztCM5LYHCWM?=
 =?iso-8859-1?Q?pGrr3Pl8Ka9w9ksqvpaMbEEhVPB0eA7WFKEWydG8uQXbMd8UfOrxQ2hc9r?=
 =?iso-8859-1?Q?6FAj/hUmBs1UXaqomwGPzZstxuMGeGLE+vjwR7RUjOlWdS/7zsIQKU7MtC?=
 =?iso-8859-1?Q?afGZ/iOfj4z2pmSthS9x20gvULuzXu7aPLNGj2qBBQbTiZGU55TZngl4M1?=
 =?iso-8859-1?Q?l+bncXnEU06q7rHXVxLBR4L2ZKxQL2bcW+UcVCXbFqFz1GGSlYSD36zFdb?=
 =?iso-8859-1?Q?e8tJeROGGCZsMwn4PRnCXUs5nuQW9iEJJXoBqfxJ3GmbzcV/FmOYUzTN5l?=
 =?iso-8859-1?Q?O9Wfp2qYvptTs8zuxeCOLWB77pLBADHS9LTSpJmqt7xdBy5GG/8ZF10v6F?=
 =?iso-8859-1?Q?Q0aXnxp6+XDYNKVlP/9/zXwnxALT1LvAlNg3DwhLjp8ArGk6zmmXXUpuvI?=
 =?iso-8859-1?Q?Ve+dJNOlgpED3M9GGKP3ipi23sndXHPVXwINJPl5K2xXMxSDB2cYqCf1Q4?=
 =?iso-8859-1?Q?8q0gzrpooWttCoqdLR5H5zMMCz5RGe9lIoeujBq593kMG5HyAcqdpKOK3/?=
 =?iso-8859-1?Q?OxhC+yHRASmgH24cxKiPdiZjohfY+4OJk4+jov1LKR+OAElCww+sN1JAK0?=
 =?iso-8859-1?Q?9Qz7trVKXyd70843MPt5BjXdTjmz6itcISlCuipFdOn1+Lp7efxcFjav0a?=
 =?iso-8859-1?Q?gkUKBaheqq4Q7iB2cYTGGljxjuhdDCZYnQdifNYLzEKOAx9NTRhDQXz+YT?=
 =?iso-8859-1?Q?jXovN4fFUXbcoK2swGbfxYxrMBbC98Izmfl2nc/TZFEZ9ZWgEvP3BOOdkN?=
 =?iso-8859-1?Q?/aSTb4M3En/LZx9GjGFepfent8lUi1kcJlhhs3kHEJeWjHPGV/NuzoEBet?=
 =?iso-8859-1?Q?uOzfnk/AcFYh7zEo4+TzLz6TnyUzStjcM7Ove9FiXkIUrN6w7NLgiLPayi?=
 =?iso-8859-1?Q?F2EZWytu3UTN4uVF9QKpIWgXKe+ILEV8v+adNaEiB7bd6KIR9n1QuucPF1?=
 =?iso-8859-1?Q?Vbw2CXuX7Dgfkjsa5VgPkw4hjU2AvJTLyqFNMd5JmBDPgVTZj6vCTH24xh?=
 =?iso-8859-1?Q?djJuQiueWaXr4DdtF1L/yN4mASutrpTGJW7dvHufzXWG4AvfV+f/5Y5LS6?=
 =?iso-8859-1?Q?1TnIftFxHaSL5R2TQpdvKRUJkzJimVFm1TW3hYddX17yA15o6KwgGySAW3?=
 =?iso-8859-1?Q?gFideKKIAQY0URqdBd0yYpD70b5jgWe8hg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1d8f28-6256-469a-c5f0-08dd96898416
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 03:59:12.8876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eh/HWo+d8dOx84k5gfc2PFS6DW1ExGNDTPTOoeBLPFtvuxLd5VQVdHR3qJqF7J4g0kJDi20/lNKDa9loWoPwFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7178
X-OriginatorOrg: intel.com

On Sat, May 17, 2025 at 01:50:53AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-05-16 at 12:01 +0800, Yan Zhao wrote:
> > > Maybe we should rename nx_huge_page_workaround_enabled to something more
> > > generic
> > > and do the is_mirror logic in kvm_mmu_do_page_fault() when setting it. It
> > > should
> > > shrink the diff and centralize the logic.
> > Hmm, I'm reluctant to rename nx_huge_page_workaround_enabled, because
> > 
> > (1) Invoking disallowed_hugepage_adjust() for mirror root is to disable page
> >     promotion for TDX private memory, so is only applied to TDP MMU.
> > (2) nx_huge_page_workaround_enabled is used specifically for nx huge pages.
> >     fault->huge_page_disallowed = fault->exec && fault-
> > >nx_huge_page_workaround_enabled;
> 
> Oh, good point.
> 
> > 
> >     if (fault->huge_page_disallowed)
> >         account_nx_huge_page(vcpu->kvm, sp,
> >                              fault->req_level >= it.level);
> >     
> >     sp->nx_huge_page_disallowed = fault->huge_page_disallowed.
> > 
> >     Affecting fault->huge_page_disallowed would impact
> >     sp->nx_huge_page_disallowed as well and would disable huge pages entirely.
> > 
> >     So, we still need to keep nx_huge_page_workaround_enabled.
> > 
> > If we introduce a new flag fault->disable_hugepage_adjust, and set it in
> > kvm_mmu_do_page_fault(), we would also need to invoke
> > tdp_mmu_get_root_for_fault() there as well.
> > 
> > Checking for mirror root for non-TDX VMs is not necessary, and the invocation
> > of
> > tdp_mmu_get_root_for_fault() seems redundant with the one in
> > kvm_tdp_mmu_map().
> 
> Also true. What about a wrapper for MMU code to check instead of fault-
> >nx_huge_page_workaround_enabled then?
Like below?

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1b2bacde009f..0e4a03f44036 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1275,6 +1275,11 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
        return 0;
 }

+static inline bool is_fault_disallow_huge_page_adust(struct kvm_page_fault *fault, bool is_mirror)
+{
+       return fault->nx_huge_page_workaround_enabled || is_mirror;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1297,7 +1302,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
        for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
                int r;

-               if (fault->nx_huge_page_workaround_enabled || is_mirror)
+               if (is_fault_disallow_huge_page_adust(fault, is_mirror))
                        disallowed_hugepage_adjust(fault, iter.old_spte, iter.level, is_mirror);

                /*



> Also, why not check is_mirror_sp() in disallowed_hugepage_adjust() instead of
> passing in an is_mirror arg?
It's an optimization.

As is_mirror_sptep(iter->sptep) == is_mirror_sp(root), passing in is_mirror arg
can avoid checking mirror for each sp, which remains unchanged in a root.


> There must be a way to have it fit in better with disallowed_hugepage_adjust()
> without adding so much open coded boolean logic.

