Return-Path: <kvm+bounces-46787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF454AB99C0
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF08B3B24C2
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 10:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F260023315E;
	Fri, 16 May 2025 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V6VDte8x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2EF381C4;
	Fri, 16 May 2025 10:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747390107; cv=fail; b=eITl6HgAEo7BDhfMrF2OrCq0AicMKpoMetAOV4p2EGCYCh74m3Imbny8kDCpM1REPcHG0PL2oSmqNFjdhshjz1cOm0/wEr317/J5oVexSx8xmxxm37TjY/eNMPXnHW8tBUEvzdxWcmDv8UuX+0XRMnK/G2yfZK6GGNBfEYbfTKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747390107; c=relaxed/simple;
	bh=EM3HpBEssQBtmrD5G08CMkpuoDdwkXNAaD+90Jnsvig=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jq81Go6YP5e9Ftxskg/dsOPyBdFT30c05rejP5hcLoAdo2LC2BJYP6/Wekw2jzCd9DxrGL0z8VYsgYHiXlgavzs4a9YzuBbIcH+e6d3ptvZHCNitdfvKqAmVZAmK6jUOWnkHSB3aAOTErVpU01awJmHsOgI4JjRIC/kWtaeAJgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V6VDte8x; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747390105; x=1778926105;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EM3HpBEssQBtmrD5G08CMkpuoDdwkXNAaD+90Jnsvig=;
  b=V6VDte8xIY4yyrWZBTBf3Q9/nB5ia1uWn03FSe1EuYHdqBRlfJCEAWNk
   5a3OE7YIyroKAsmxMn0M5IkVqvlqojnDCzzhhs8/i8y2Dl4pDVkCzci8K
   84hpvraWux2WEgCnT56fmoBPDLyviTdkO2jcPki03AgX5lX4skBOf5GKX
   NEMV0RKzLeYl41a4QVLQsqIehoPIoo4K9rXOFcpHniXHFHYYEM5Nn1M1n
   BfHq2hWhXgSz3GULvx5gtdgtwAEb3mKE1HuLfn/l4dU+6uSebB9F0cEdj
   0D1PWzjJWwLnvA5yKCEiwYQBQd5x90OmXLzGHhxvtq3vDAySvWBUSWi0Y
   g==;
X-CSE-ConnectionGUID: iYcQokgPRaaalFHW4dvtgQ==
X-CSE-MsgGUID: 8a4x18dyQJGOMpwEZC8GcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="53171950"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="53171950"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 03:08:24 -0700
X-CSE-ConnectionGUID: vrrq2iySTnyvSxxOqM9tUQ==
X-CSE-MsgGUID: BdgnwKXPTBuqQgUX8DpyJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="138565214"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 03:08:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 03:08:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 03:08:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 03:08:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dq/Ecs8UkyyF3DEo7y4v9NVa/iYIPwaLeI5FX/9mAcC7/tnKNYmrVRVWc4rxVa5HBvcU+XXdHNL0WMVdnvuQzLr8qp8kjQzXnDeoOUerMpcFhBZPEswd32js/2X2jgjNbKTxjjfl9rVkZzcswrWqcW8Wq7jdbmvnjLcwUHMxM4Y/KE5K+F9pfueannuC/afvrdRJdF0TI+hVIsrsGZ98K3w/nROVf3jtG2W2yo5yldgPFlkj3HmPqc/PsIZQp2OluOnZh6FA0/jkkCmdu+EzvIZFQIlXZbYt2eFC7q7WWD2HLoSAQpApgx4EK9jsAvS0xIZci5ze8/njw5XPNl0x1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybS4OTLVVm78gXGNnoqBObCxrOpLwBOJTRDU7AzvdNU=;
 b=KbkPCxQ7fcVs3mv4JMASV+vF8rj9fWl8z7y7WfyWiTchuV23Gf1NBNr6j8Wrk96ZCV0YwoFg8UX7sEDTkJzSi8HCadllJdUKafC41iPEWZZyWr2ktxmJHlNgMfqyZWLI6uovvKlSKGVX89Bn5XX7AVeaFj7mnILYwSUbeFHOYj5YgpwYc23wT9ARYWMknnzZ3yxMdMgq8BYESLUuFXdtwOy321KW8CKVYMvshSTxYpjUI53xGQra3n/GgNxwoaDJ0O4NQpvuQD11fUYUyUhwPqaONCB++W74cEyLsiJqDyVmtOBdt9SUo974pq9Ko06h1iWPhQjI6+6FGb9uyLt8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4817.namprd11.prod.outlook.com (2603:10b6:303:98::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.31; Fri, 16 May 2025 10:07:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 10:07:34 +0000
Date: Fri, 16 May 2025 18:05:23 +0800
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
Subject: Re: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Message-ID: <aCcN4wLA2W3txtIT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030500.32720-1-yan.y.zhao@intel.com>
 <45ae219d565a7d2275c57a77cd00d629673ec625.camel@intel.com>
 <aCWw1lZ+T8AFaIiF@yzhao56-desk.sh.intel.com>
 <49e708ca4a2777c955ca8780117a78acc984dbbd.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49e708ca4a2777c955ca8780117a78acc984dbbd.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:195::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4817:EE_
X-MS-Office365-Filtering-Correlation-Id: d37a3435-f85f-467b-aea3-08dd94617a2b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oPu9ehOwq6/qeTqVq3GBx4dtakwdE7XXLuTkZtzDHmfF2mgsa0VxkdFHZufc?=
 =?us-ascii?Q?fx84+SVKS1Vl8GmhP6FUdNyRbj7GlMDDjIExSU3NVdYsG1Ga9Nro4FLESkSU?=
 =?us-ascii?Q?uSEfDFA0t1RDQNyzoG3rG43YzEQRPw4Jt9ZR4XcL9tLhO08YRnQEFWxd02Cz?=
 =?us-ascii?Q?3VpaWzAyRefg791ol9fwFhqvdhz4p3ixP3clc5JiJk2yeKH2dRegCOyCVvq3?=
 =?us-ascii?Q?qbLO+DN0BhctmgvktxIk6u2thsgL4KAeVSXWw7V42MW5Pqiw7Cti4b+cbfTk?=
 =?us-ascii?Q?RrJwryVRrrh8Vhq3rq2TUsqky9CaQuhXR08nTP5JvDPPWPHcdBTsm0EFxGyN?=
 =?us-ascii?Q?ke0bR2nCR0ryERXfWUY04lg/l4GjnbjvCHIzQdPRCCUMxDyjONvtq96b6rz5?=
 =?us-ascii?Q?LPOUrK4QWWR7W+Cv2/p6LTxjcw1Sey8Eo8dVmcnF0nuz/1+YwPh15ZTCrkgl?=
 =?us-ascii?Q?meIED2YMFHdkBKC3NSiGDnlwRuLvpfiGQvAFfnnH/kUNPWbH5h/JVVJvd2p9?=
 =?us-ascii?Q?Hk20Cej4C9soU6yiMoEXTK2TgXVqVeshkLJDHXTo3zu85tP7KHhyOFdMfifq?=
 =?us-ascii?Q?ygBybba+j/LYKAkyqBrNDDaNh/qTHjA60Zxg5FGspRwc8rMrKLNR8s5iuFAs?=
 =?us-ascii?Q?ZKgjPmHbFCfb9lF40mrXn8O4ZNKTptvmetFMNpREMDQr6qjC87mIgAw2WuNG?=
 =?us-ascii?Q?iwdfKckweXujcLJg2v8GLrqwNWg3O1AaDADIjCvAeTFVM8PPDFMq8STHuBp5?=
 =?us-ascii?Q?pOtEwnYqm+Aas61FMdQcB9Kus37Ce1KUOuGLqtN2oAiil7cVN5qzDePkzPYP?=
 =?us-ascii?Q?gi+HJjoqj9xvwDCctng+mmtPmA7o/eR9y2L9OCtMvW6+Kgu79UBKKYJROnpT?=
 =?us-ascii?Q?gOcyMIpt1QxBpZvCNn4v5566h9q8tpvSPMB5quzvpcWdWjNW2E7QG2lE1o+y?=
 =?us-ascii?Q?1oA/ZnWWaojMUytmAszhplCw9zZ+4VBHjw8WJczLCH0XRJ3QSPSWcY86glSa?=
 =?us-ascii?Q?+x863qxGn9e1cQ/8GNhu+2FC9xYpQgZKWvXu1t+moOHc9hc9vT2JqNL4Hd5y?=
 =?us-ascii?Q?vD32j97r22yaRblU/WJNOtqY3sgGBjOExB8gxRUPn+ies6Co69GVrkIKDMlQ?=
 =?us-ascii?Q?8Pz21+yqghzqqCP7WqlvC42LKecJL/G3na30l0BX0KIx25Fe0O14Q0pMf8j6?=
 =?us-ascii?Q?gnh2WABV1z02DARyBi8dopYsfLm5b6fFcmpBErMJoqJCQV1QJIrejFsWzxQo?=
 =?us-ascii?Q?v8GVJO02b+L5McAwr0E1EgOAxznPjTgjeCsexAyILwLGHvTno8LhhyxAgVy7?=
 =?us-ascii?Q?OURiqP60XjluyiVTBNO9q8ly9v56dSt1JSQYKIDZQqdio9YIAYJVNHqjA54v?=
 =?us-ascii?Q?VVL5yiEQEO7FO0Rsew/yiTCki2QcAMxhOxlgNmO2gQTnObFM0r0iJ5j8zysG?=
 =?us-ascii?Q?cqsREc3jJac=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7vAwKHdxmhKOkWp4n6yokPbYqF3cSnZCzQWPCxdGXMtZgHwA+vi8O6fZ5SNr?=
 =?us-ascii?Q?mI8pb3L5xzbhN90zMebSLzPTVs0tsOHzXgjmgOwWHiM1Oh8MQS9p4XGRkSwh?=
 =?us-ascii?Q?0ArDdQ82m6FtRDfF3n714uCgMyGvwCuwbiBbhXczyM4wthINHwQbl8LiVIEo?=
 =?us-ascii?Q?3evqADB4cM7LCXz6EtIgocVpXlslZf6hcXZ/yhjlrSOVO7EYvTeSZ90NzslV?=
 =?us-ascii?Q?jMt+/jSaxg45/fk4CbmRoGO9/flSOWAtI9uWm6uT7oXjl9iGn1G215LgL5Ov?=
 =?us-ascii?Q?wSbknOiQ+XBp92vyrsjel66ZAfL1l5Nt70kc6kSiYX08ZrWjjnVJtbj9mIwN?=
 =?us-ascii?Q?CJLTArE/ZQ8ISkOzCSPLCYQgmlU7OXo2jMNUrZfPVe4/gY9/kbIXZ5TpUHFy?=
 =?us-ascii?Q?LZZ1EgaFr/g/eV3exmuhBGUpT2Axy2QUYs6nOHPKlpMsS2H4s7qI0rTbMKQp?=
 =?us-ascii?Q?raswSx3pieIcRRibHpT28luioYNyVw7oTS4vy0JVGoTAxDBqOIuQwZ3HYXub?=
 =?us-ascii?Q?IKyQAyZ4yhuhPaPJTNeJkMOvGvCUd4UPUe6eZLR5B9544ZkNFG/uJy7YeT/M?=
 =?us-ascii?Q?hVS4ra36ybxBZMVOFVA/UNhmN7DUf+udt8RAAIBr7te2HFIipeML/gecG2xo?=
 =?us-ascii?Q?7SpPo+3cKPs2KwzQSofZZ1b3N/bVaX8ybzrZAcyt0ePYNusvlVXk7TiW/JKo?=
 =?us-ascii?Q?Q+YiuD+FmCqPg34W/ovbVRjH+6vOB5L3QPjoNMLJ7/TOCtcW04L0bnw7R0Qu?=
 =?us-ascii?Q?NXAhVkPKhGfUI4U9aClm3Ocnma5s2OjvA8pX1pEkJGrUDCmSkz165+Ni9561?=
 =?us-ascii?Q?UAsX7zdvi+dSkSJR/95oNR7KJXqCzTuxGknEABSWdVfFSrDK6UGb6XWyNJrr?=
 =?us-ascii?Q?0Jr9zFFYZmzLsuJldNj2aupI/Z7GemxvwX5n/Yjd3Jg9Fd0vQxGHosjKgYHi?=
 =?us-ascii?Q?+hA8j+QpvnYiYJUwqCrIImD+ATG8x2Qh0ZB+LR22j5wSq/Nu5cH7g+J4B+Hc?=
 =?us-ascii?Q?9SG1JSKoT7Ccwhfr/+ehT/dD1eAkmJ56cFmvygAWaCxQoHHKNAGvJJJCSK5s?=
 =?us-ascii?Q?0vRL1rpPchFFfi/gNXl29Rn3cbp38/FGqGIIbGVtiYdtqWgbNfACOFRyu68A?=
 =?us-ascii?Q?J6ZNkC8P5xRZhIepAWoKA/5zH8ymIv3TYsGvldEVfogWdk/x4vrYa5lTc1bC?=
 =?us-ascii?Q?iWe7VcRh2D+r6NVcoWtbt5SILj2f0wpbdwYfwPmCgQ6rlsj27y/SN5iyow9k?=
 =?us-ascii?Q?xbZD31JZ3RterK4pI5bL2bbuLPYz6t3vtBd3ZNJl26FK2bf3DGwc16dSZ8jm?=
 =?us-ascii?Q?/vibtpPWfL8SE/Ebno1w1soOPCZ6ywgoA+OT/redZitDsqZcoWWtgGAa92tI?=
 =?us-ascii?Q?t71aUqrvUuOmWzr/H9KCMsPislReQ97L2FVyHfKbzX2URPRcCXjqiAnFvR7k?=
 =?us-ascii?Q?mz/7QFbKJ4RArYfEVn8vawH68IkdAE+6GQgqJ6nZtmiLFz4ALSLgECMI2nFQ?=
 =?us-ascii?Q?tXenYV9SPngX+tXFdEDL/RzJ4vfaK0trzqSTmJdatsRR9dCrXcNbVpKtGgq6?=
 =?us-ascii?Q?WGiETFh92XdplhU8/EZyULrppcokZ5MSkKSgdm49?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d37a3435-f85f-467b-aea3-08dd94617a2b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 10:07:34.0238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VGP3STaJyA9yse9pwezQP+jN7vUB8qzD1wK0ALtPHD54WclM2p0emhMPV6zN10ZzsYecmy3FNwss9E1kO/Ixg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4817
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 01:32:44AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-05-15 at 17:16 +0800, Yan Zhao wrote:
> > On Wed, May 14, 2025 at 03:12:10AM +0800, Edgecombe, Rick P wrote:
> > > On Thu, 2025-04-24 at 11:05 +0800, Yan Zhao wrote:
> > > > During the TD build phase (i.e., before the TD becomes RUNNABLE), enforce a
> > > > 4KB mapping level both in the S-EPT managed by the TDX module and the
> > > > mirror page table managed by KVM.
> > > > 
> > > > During this phase, TD's memory is added via tdh_mem_page_add(), which only
> > > > accepts 4KB granularity. Therefore, return PG_LEVEL_4K in TDX's
> > > > .private_max_mapping_level hook to ensure KVM maps at the 4KB level in the
> > > > mirror page table. Meanwhile, iterate over each 4KB page of a large gmem
> > > > backend page in tdx_gmem_post_populate() and invoke tdh_mem_page_add() to
> > > > map at the 4KB level in the S-EPT.
> > > > 
> > > > Still allow huge pages in gmem backend during TD build time. Based on [1],
> > > > which gmem series allows 2MB TPH and non-in-place conversion, pass in
> > > > region.nr_pages to kvm_gmem_populate() in tdx_vcpu_init_mem_region().
> > > > 
> > > 
> > > This commit log will need to be written with upstream in mind when it is out of
> > > RFC.
> > Ok.
> > 
> >  
> > > >  This
> > > > enables kvm_gmem_populate() to allocate huge pages from the gmem backend
> > > > when the remaining nr_pages, GFN alignment, and page private/shared
> > > > attribute permit.  KVM is then able to promote the initial 4K mapping to
> > > > huge after TD is RUNNABLE.
> > > > 
> > > > Disallow any private huge pages during TD build time. Use BUG_ON() in
> > > > tdx_mem_page_record_premap_cnt() and tdx_is_sept_zap_err_due_to_premap() to
> > > > assert the mapping level is 4KB.
> > > > 
> > > > Opportunistically, remove unused parameters in
> > > > tdx_mem_page_record_premap_cnt().
> > > > 
> > > > Link: https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com [1]
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++--------------
> > > >  1 file changed, 30 insertions(+), 15 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 98cde20f14da..03885cb2869b 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -1530,14 +1530,16 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > > >   * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
> > > >   * are no half-initialized shared EPT pages.
> > > >   */
> > > > -static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> > > > -					  enum pg_level level, kvm_pfn_t pfn)
> > > > +static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, enum pg_level level)
> > > >  {
> > > >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > >  
> > > >  	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> > > >  		return -EINVAL;
> > > >  
> > > > +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > > > +		return -EINVAL;
> > > > +
> > > >  	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
> > > >  	atomic64_inc(&kvm_tdx->nr_premapped);
> > > >  	return 0;
> > > > @@ -1571,7 +1573,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > > >  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > > >  		return tdx_mem_page_aug(kvm, gfn, level, page);
> > > >  
> > > > -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> > > > +	return tdx_mem_page_record_premap_cnt(kvm, level);
> > > >  }
> > > >  
> > > >  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > > > @@ -1666,7 +1668,7 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> > > >  static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
> > > >  					     u64 entry, int level)
> > > >  {
> > > > -	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
> > > > +	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE || level > PG_LEVEL_4K)
> > > >  		return false;
> > > 
> > > This is catching zapping huge pages before the TD is runnable? Is it necessary
> > > if we are already warning about mapping huge pages before the TD is runnable in
> > > tdx_mem_page_record_premap_cnt()?
> > Under normal conditions, this check isn't necessary.
> > I added this check in case bugs in the KVM core MMU where the mirror page table
> > might be updated to huge without notifying the TDX side.
> > Am I overthinking?
> 
> If we need so many BUG_ON()s maybe our design is too fragile. I think we could
> drop this one.
Got it.

> > 
> > 
> > > >  	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
> > > > @@ -3052,8 +3054,8 @@ struct tdx_gmem_post_populate_arg {
> > > >  	__u32 flags;
> > > >  };
> > > >  
> > > > -static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > -				  void __user *src, int order, void *_arg)
> > > > +static int tdx_gmem_post_populate_4k(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > +				     void __user *src, void *_arg)
> > > >  {
> > > >  	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
> > > >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > @@ -3120,6 +3122,21 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > +				  void __user *src, int order, void *_arg)
> > > > +{
> > > > +	unsigned long i, npages = 1 << order;
> > > > +	int ret;
> > > > +
> > > > +	for (i = 0; i < npages; i++) {
> > > > +		ret = tdx_gmem_post_populate_4k(kvm, gfn + i, pfn + i,
> > > > +						src + i * PAGE_SIZE, _arg);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +	}
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> > > >  {
> > > >  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > @@ -3166,20 +3183,15 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
> > > >  		};
> > > >  		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
> > > >  					     u64_to_user_ptr(region.source_addr),
> > > > -					     1, tdx_gmem_post_populate, &arg);
> > > > +					     region.nr_pages, tdx_gmem_post_populate, &arg);
> > > >  		if (gmem_ret < 0) {
> > > >  			ret = gmem_ret;
> > > >  			break;
> > > >  		}
> > > >  
> > > > -		if (gmem_ret != 1) {
> > This line is removed.
> 
> Doh! Right.
> 
> > 
> > > > -			ret = -EIO;
> > > > -			break;
> > > > -		}
> > > > -
> > > > -		region.source_addr += PAGE_SIZE;
> > > > -		region.gpa += PAGE_SIZE;
> > > > -		region.nr_pages--;
> > > > +		region.source_addr += PAGE_SIZE * gmem_ret;
> > > 
> > > gmem_ret has to be 1, per the above conditional.
> > As region.nr_pages instead of 1 is passed into kvm_gmem_populate(), gmem_ret
> > can now be greater than 1.
> > 
> > kvm_gmem_populate() can allocate huge backend pages if region.nr_pages, GFN
> > alignment, and shareability permit.
> > 
> > > > +		region.gpa += PAGE_SIZE * gmem_ret;
> > > > +		region.nr_pages -= gmem_ret;
> > > >  
> > > >  		cond_resched();
> > > >  	}
> > > > @@ -3224,6 +3236,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > > >  
> > > >  int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> > > >  {
> > > > +	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
> > > > +		return PG_LEVEL_4K;
> > > > +
> > > >  	return PG_LEVEL_4K;
> > > 
> > > ^ Change does nothing...
> > Right. Patch 9 will update the default level to PG_LEVEL_2M.
> > 
> > The change here is meant to highlight PG_LEVEL_4K is enforced in
> > tdx_gmem_private_max_mapping_level() when TD is not in TD_STATE_RUNNABLE state.
> > 
> > Will change it in the next version.
> 
> I can't see the pattern between what goes in this patch vs patch 9. We should
> have some reasoning behind it.
tdx_gmem_private_max_mapping_level() actually has no need to change in this
patch as both cases return PG_LEVEL_4K.

My reasoning behind it was that I hoped to show the whole picture to support
TDX huge page before TD is runnable in this patch as much as possible.

Without this superfluous modification, the info that PG_LEVEL_4K is returned
before TD is runnable would not be noticed in this patch.

It's definitely reasonable for the later versions to drop the hunk of the
change to tdx_gmem_private_max_mapping_level().


> > 
> > > >  }
> > > >  
> > > 
> 

