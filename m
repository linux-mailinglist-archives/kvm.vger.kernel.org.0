Return-Path: <kvm+bounces-58519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 343B9B94F23
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 10:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DA6E1900FAC
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143073195F4;
	Tue, 23 Sep 2025 08:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/0sr/TE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12D1A83F9;
	Tue, 23 Sep 2025 08:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758615374; cv=fail; b=g4oiNVoG+A2aXUOM2OuEm8xZ3Yh/wwwbIDJW6gIQq8PI1bvWaYOYkH0mxgPsYAnmDiY6UXXBCHYsV4ihCt14jPZLRC1W2dUE98nSovsK83V34ZhtIo6U3aW5AM0bGjhPE3vTMDxjTG7SCNo7ynG42FeIgh0EEP4PLrMa6vAVDpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758615374; c=relaxed/simple;
	bh=JRgmWZ9CUxWVss06a6ZeaszcR4v7RQiFqOzTUNQR11Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mwa93njcSB8D2Q+ImIX7mjqT1M6aLmQjKOptr15HvLzVk0x9IqkHj9YHwfJo3I3pPToFAPrKnMPwisHlap1428aGV30qUAHilwVtpxliuRDhCwTksx4OeqUXomyeLWIhL5rF4ptNHmn5Z6NxEtiTzq9vMRSYh0s7KjmSPgkp3ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/0sr/TE; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758615372; x=1790151372;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JRgmWZ9CUxWVss06a6ZeaszcR4v7RQiFqOzTUNQR11Y=;
  b=D/0sr/TEwDTKWfR2yIWtoTJ2HsJh3exmZf3CHAyRzCUoQIPtxeJHda1B
   o/JYZitJsclVbm40V7CAKGJxFCqckUx2/TCAbYJ06/lJ9cPOjI1KTzPgs
   2Uz65w9e0Eul03mTzODDquoJwt9Pfk0fnsfgL35CeUCDxbjwljVmywwfK
   30wBTmBSs1RijIRDaGt6HtvmMvYXjLdODUOaLaUegsk6gXFnBFEGGMlgi
   Fq4G7GfRShUQUPfcX/Lmhdh3j53zAWF6KUkyWe7lYyeheu0N28qhBJqcl
   GCQgg5TbT5ah7EX+qufEgnxwhWvA91Lwc8+BpRRI/ZqYBPjd9FC7bYnhd
   Q==;
X-CSE-ConnectionGUID: 3Jn8xluES6SX0wSSy/FzvA==
X-CSE-MsgGUID: vwsxUz25QTmah8uY7f+4pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60813850"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="60813850"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 01:16:11 -0700
X-CSE-ConnectionGUID: zh9zqOpkQKSlFQRGjBzKcQ==
X-CSE-MsgGUID: gQ6Bnu7LSwiZMFMMd8eXOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="181975031"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 01:16:11 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 01:16:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 01:16:10 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 01:16:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rCEg0PFbNYQtwvg2JcZYyT8Qf3LmqVGwGqNF1uAh6BlORxcXKbtdDF1trnXz2tftDD2hwNl65WFqPabCPqTkz4ggDrAbOe8IXrpeb9PE8V4CQtNkfVlH4MXP2o26m8FxFr/MIr2CIwSc9B4CznYqY19zj5/FNv3zRy31pORyBOuaFj/+xygPDR0qZCHPjAnxUJoxhwlwoMIZ89h9XX6HehO7rGbF0/esj6WItUCfdt8Fn/0+kbX+qjoVfRHT/PelYOuZqs81/YI1joHdqrkpqo5mGsP1eSNMvX02lg3R09G3Qva8C3Phjc2JSohki+a2pzMLSgEV72O3FkYTmJmqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiAYeXsdBxT3oVy0Rc83qcytpF6nKVBt9x7e7s9+Fdg=;
 b=xnoWo3es9bdjArrb46i+u/j0jJAIl352NjSDZhOMa4Os+XGRTp+YULdBZuvXKNeWclv00G90vR6AGvPYaFaKYumZw/D/0RujKxAg1wsO6fGVqr798Ni4Z9rrZPiVlkqsE3cTEN94EHVwNQqwmE3xON89bwkYsAH/ZPgnxzo9ur4ue3ujSZyOyMY/J6quEJwLwviwYlpyNIK0SCGgvtNhbN6Tkogj1mLEdg94cMoLXeFHSA+gUoNtaQOAP2impdFEQi6RrQNlXNw/GRSz1F2MVG2uIFYg28nhSWOb1Q8kXpucXjxzR2lpKBc9KoRB9QgOPfBV/rV34TWh2nTSHTRaSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7650.namprd11.prod.outlook.com (2603:10b6:8:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 08:16:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 08:16:07 +0000
Date: Tue, 23 Sep 2025 16:15:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 24/51] KVM: nVMX: Always forward XSAVES/XRSTORS exits
 from L2 to L1
Message-ID: <aNJXPTMmc7QLvBek@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-25-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-25-seanjc@google.com>
X-ClientProxiedBy: SGXP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::31)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: 106b238c-f2f3-4925-eaf0-08ddfa79728f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OE0a//pS830aVaTTGgC95oe1Q/yo37o7YphVuxbQjvEG49yx2IwnxlTTtRA1?=
 =?us-ascii?Q?tnMfjFHxU39d+Z1cC6e1l8cxutceERfEAoFFPpqQoyQ2lHOYxyAvQ8fE26qp?=
 =?us-ascii?Q?wnF0ohpI8E5jLSVliECqlxTuElKbolPBRrW0wbdokslpIb+0g6TSVl2qqeiq?=
 =?us-ascii?Q?MuehYl0PkNblCmh/c4jVR7NJxO1VKbK/CUnKpSP9/XS1SjaqOg3uWKfMdRmf?=
 =?us-ascii?Q?uEz5OTahKxGR+uMs5bSVszbLgstDK33MBM9+Lzsu7eJNN3RSZin4KhPVQDzR?=
 =?us-ascii?Q?WV6hQd8SifgFLfo9SMpP+MCQ3gAF7oeo9zTEoWMRh0E+kdim9AZQqoZOJJ6j?=
 =?us-ascii?Q?ECVqKhAkyv0PLztRV+rCu7UZPJX85TxpwK+H1ijd4ReIdsXJVx8FCSaO8qxB?=
 =?us-ascii?Q?8V3LLX9Ecpx3WM5H/pHS8EKzZ4uI6kkczCadtwgpPWOnWM+xtLEU4uiVYy4y?=
 =?us-ascii?Q?qWZqlrDhsa+jNHEyWMQt9+YL/8misAYemfu/vdsOYaAnVouRDxda7uNi0drL?=
 =?us-ascii?Q?aQ91LsJE3b5WaksOSP5ct1jySCgLphobYDTnG2WCDWj1w5d84J4biaS2kJLd?=
 =?us-ascii?Q?Gzdgu/OpL1jHRsPcCQom8u7QgApILfHGyuKwmIhCb0J3rfrYujjX7VlS0t0l?=
 =?us-ascii?Q?fHMtV7BDP1N5FE/OODDFbhu6KCIQkZHBLpFYWPV8AnCTF+2eNWk29PiLDlF4?=
 =?us-ascii?Q?HyibQONYlLz72MGomLOsFcOFRIfQz1hvNr+bC4R7mMHad1jl3qUBCNupAKlf?=
 =?us-ascii?Q?T9CGFxzeIyTQWcTt4I1glJfeUzjDPYTz+IVwQ3uiyBDTtlyWkY4VmYqEsEdF?=
 =?us-ascii?Q?oGNslk0APY9GIc6gQfMCAXPDzlFYGLH73yEByCBelLBHY6nAy0VQ8ccDQn7c?=
 =?us-ascii?Q?IzVeB5dO/8F9BfSR6v77LoDD+om7J9u4k9XPWgJ4HxkST+6CvLJzTGpqsXEW?=
 =?us-ascii?Q?XACXOIYI4bWJucnNmTj5Fw0ux22/ugOWYppbCR7MMOnj82QT560rNu4csF+k?=
 =?us-ascii?Q?o/TYT2PXjEOtOcEN1JCCQBj5zFU1jhkfEApLrhhGh2P/p8Ub55FUNDBF2Wzq?=
 =?us-ascii?Q?ThzRA524WY463aFZeA4kBRpdt+wor1Qm6uPTrzA4wMtjg7YhJnpthcY7W/yD?=
 =?us-ascii?Q?aOOCB+ndhXHFAKOyLKdY6T17Oem32qz6TbbYBRKJG2m3fbfWh1dqSIm3cA87?=
 =?us-ascii?Q?Z7KxUbCI0c87dG0qjoov+haPyqzJVt2+yZ/DiUSAXRHJrqNNkcPlYVvontOr?=
 =?us-ascii?Q?FyQD/vaz2E6kbMAnQxGiAwVxcfHoqOZj+iYfMlk0EHcNpoL/fQWrGq+6qds3?=
 =?us-ascii?Q?CmH2vl7HbaiaWXbfYy3OfzUL7Ma9+GNSt30IOfl3ZaVSTJLyNG9Idwm+MFF2?=
 =?us-ascii?Q?x3AVMhSJoQ8ToEKjdSfywiJyqzPH5Bn97htpbho77K1UVRoGrPTqXo4rXBCR?=
 =?us-ascii?Q?+NBdWV5HaWg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJBOpyb0GcEX80vZCI0lW0ufEUFqnd5TZ0GeJf6ILfgF4CfT5L4nG1nKfKzK?=
 =?us-ascii?Q?Wg4dR3XJOTlKQYM1e+mp3YqB1SgInUhcY9Pj/j/w1UZxxiRjTCI/NINlg7yn?=
 =?us-ascii?Q?LRTkTME0imFPro43Z2gqyV6cRmeodxvHA6T8TopUfWAWkhNujJWemE+Xwkkh?=
 =?us-ascii?Q?vH+F+DX3IfbZalHT6N1VnhpIJO+KaTryiDR+dXup+qKsVb/3UipQbwSqPfyq?=
 =?us-ascii?Q?MSv6/8esmLZRi8fX0cV3h55ELAoWGuQZSYGBZ6WzhKPY1QBrwJ5IaXvfdJoP?=
 =?us-ascii?Q?nmuzlRoJoZXw3stZ6iCKLD4u/QUSC3M3Ekpc2Znok1C+BS0h9k3atZvBi9uP?=
 =?us-ascii?Q?0QB97hGflbkzNT+lI/W4OTJFzv5NHiVTcX1ySkxB1d0KuzlKFhIzxYvFHzjr?=
 =?us-ascii?Q?TG3Lg+lXMkM0SsAYMR1qypeswYen7kQZw6Ln6IzEKYNcS0Ifv3UvWNYbx9eq?=
 =?us-ascii?Q?yF8cFFDJrc2CaP+63Dbcm9PZyzE/E5wQ2AkvFsIEEWnPJNieQSdncbwV6faX?=
 =?us-ascii?Q?QzKVE2oyPRJ3+Vmfs64tKrfwBkN1vimdzufT3mxHLuodBeNufx4S4OeZyLTY?=
 =?us-ascii?Q?e9xDwepR/EDxUA0AsrsnRiBUqj70bhhqxmLhsrYcFAxxJb4PxZURb21PzJ+N?=
 =?us-ascii?Q?xcuH3YEY/IrvG/5tHrX8m+W5GskX5iLeGty2XoJJ3lu0HJVGsjoAS/cGXIbM?=
 =?us-ascii?Q?oAw7N+k9QU92ByFi1qZl6GUNMG5rEWZYbMpbqyANTnn14uhH62z7k9SPbPNR?=
 =?us-ascii?Q?AmR0hw6pxINQnWelRq7hAMh4oFaFNvMvdZAeavcSGkzXV5Nuc57zduGH3DIp?=
 =?us-ascii?Q?0KbfmWM4v45XNpt5Hnlpp+UzTBsgrsC1zqswqZ5XtHje++bLdOxSmQwkv3jv?=
 =?us-ascii?Q?Uw6raIxmnOTaxLaSiih6O7ZWi3ilrjLDDITByAVXEnhKMoGhQ16NjZ0hDTDI?=
 =?us-ascii?Q?HF4ZTDk1ru4PQHOAPNtk9FW+h6z0z8ro+Cvlv9v22mEkVaprz9qTSygiCVI9?=
 =?us-ascii?Q?XbtnwBz20aMw61uCxmRhE/EAkap+uo0GMriGSSGey/mxo/8Ja3jy5sPlcCsf?=
 =?us-ascii?Q?F2QY0QsL/knV5kioip05RkCbACrr9jKnNu7rclrfwJ/B4NeoXCnQ2HLl4ey1?=
 =?us-ascii?Q?G5DGmO9Oeue9Hoe5DJi/NtwHdkO22asxmDYJIkPh8JcUCpZPpCThSQacsGDW?=
 =?us-ascii?Q?ddiKQUb3ii+8a4/+iDyFJbw724/GY4A1k1ilQEFyo9vFm9JuYwx+Cn//bKIi?=
 =?us-ascii?Q?mFeqANhdjib4qc4rEZq0hYhGQteUXYft3uTZA6sgzUvGUPrY5R9hFoX2/Rt7?=
 =?us-ascii?Q?4z04Nk3Q/YTqnMGeAumkSWatp/8DJWWKyTFfn/yHhTSsIzJFNvdReyTn3bUW?=
 =?us-ascii?Q?4UZW/LAgo2Z2eu1wMdViGoDCxqY3YaVvK+uCwcog3djOJhVYzhE9Wep7qt/C?=
 =?us-ascii?Q?Wbi0qKBraLJv4UCQYAdrfO1himtfSQjZSvGwsOyVHKIDcE3m+7KFtJE5fhuN?=
 =?us-ascii?Q?fUfJK/TnHBD5NNrFCdxR9DZx/9AawHQPhyYoQ/YyhfIHVHflGThTdzjQIO8D?=
 =?us-ascii?Q?C6clGNd1yNLdEZw+zUgQghe9KvrmNY4liMnFr4oT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 106b238c-f2f3-4925-eaf0-08ddfa79728f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 08:16:07.8321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2w5Ab7lokIhFKvMbTs71NvrpCLLHzOIEgVRagKzJB5SbNcvpUb9oKKRdpGsj0B+t1oz6a8D+2iNXzriltlDwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7650
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:31PM -0700, Sean Christopherson wrote:
>Unconditionally forward XSAVES/XRSTORS VM-Exits from L2 to L1, as KVM
>doesn't utilize the XSS-bitmap (KVM relies on controlling the XSS value
>in hardware to prevent unauthorized access to XSAVES state).  KVM always
>loads vmcs02 with vmcs12's bitmap, and so any exit _must_ be due to
>vmcs12's XSS-bitmap.
>
>Drop the comment about XSS never being non-zero in anticipation of
>enabling CET_KERNEL and CET_USER support.
>
>Opportunistically WARN if XSAVES is not enabled for L2, as the CPU is
>supposed to generate #UD before checking the XSS-bitmap.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

