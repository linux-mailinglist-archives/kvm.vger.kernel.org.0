Return-Path: <kvm+bounces-49351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCF5AD8028
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92F50188F219
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 01:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DE71D619F;
	Fri, 13 Jun 2025 01:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDWlAgsq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535B31420DD;
	Fri, 13 Jun 2025 01:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749777409; cv=fail; b=eoR0Rm97RrcPMIgAv/DgWITZrVtxe3TS7dBsVz3iFDLo1UCjvPbbcEgLJA3jq0QjeO4Wv7jerY7OQkxLR22uqW78JF72VNFQxdwFIqTfNMRzSq5EGV+jSmevLkVAdlP6TUBkj1xq7fsfLofIQIojPji6KNLbUKBVX96vy2ik6Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749777409; c=relaxed/simple;
	bh=I8ZLxJRYjW7h6RKXa7lxFhZzMH8V4vS7S/nkaVykm0c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qwilfgkl1bztDW9+FPnuc4FMDOfD7xa/MgFzx69n2/i/Gb9oF7rZh7jLCpaIgQt9Wbt2t8BBR8iDsN8Z71Da/5uMk/oj9R4bDff3KqJSk9MdUUcW0KjS78rq8GXZZyA95B/HmNu0lUE58dZj0kzUXS83nh6L8X3obo0bWyv48M8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDWlAgsq; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749777408; x=1781313408;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=I8ZLxJRYjW7h6RKXa7lxFhZzMH8V4vS7S/nkaVykm0c=;
  b=IDWlAgsq4mxiE3qQFb0CXhJi8EIlLCO/M2W9Vbml1MtRsxphZTwfpF2L
   /tLroHOaHt/IdiBv8F1N4tUzGGNPKJXIxZrKMIyxMuVdAAiqMd94mlX4D
   qEvvQD4TANpGPvSOZM12dsWzInO0aCjGRz0TSBK2jOAgod7DtFNjcbpAS
   XBRkcMajgxUsWaT+veJWDAIZpuybEsLrMk9SXsZczqWnld4e7+IofNaCe
   u9ytEY/Dw/i0lYgAFu8bZu/Y/Oe66PolKzB04YSsAMgcKnOTFByevVUOB
   uR8Jb7uMeXCq+w7u3+sk08B42rkTdSfj3ZSmvRlD3SOwHBU+DXijca9vm
   A==;
X-CSE-ConnectionGUID: JTlmql7RSvCE68mIPrggCg==
X-CSE-MsgGUID: 50kQHlAQTaKyY24Z7a1efQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52072805"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="52072805"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:16:48 -0700
X-CSE-ConnectionGUID: dXnqnwqeQ/i3z2/ZjouRfg==
X-CSE-MsgGUID: bhrVsNV5ReG4VtNTu10Gww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="152666790"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 18:16:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 18:16:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 18:16:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.87) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 18:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ov7jTVsgpihaZQO0NFMTwQFKeuMvg0rK1bJIkY0ABPxFIsnU/0te7+YmBjyjDlXp+kFMSBd0sp2/uQcg6GApHhnCcmoIxi5VY5PxlP1sgnUCOxFq0o52N+jP2L9yR1afBbuZQJCEteFwXjkDL2I5hxKl5HdCsF+NsxAIYizIr9LWygzwTREv7EIRUIJr1pKsgb63oRqSv5jSt58RsI1bkBJ05JanH4CGXtvwJYo1Fr/jqr8kRreyUPAFGMBV3UDIpEVqpBXU8dziILfJWq9y+8CDum1em05MhUim9bKpttepr1yb5vrCN3jEhRH5axl1qFndvPnadN4x/Dv7O+aW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6SUwx6A57YjkIr3gb8ylI4Q9cw/mT9unTGPDpnHIA0=;
 b=Rb5pLhAJfusPl+BykbNoZjU7etxw9bta9Uq+pBpaa3TMKRIyAXcqKSC2PPaHsFHjNJCyh3e3vAu5HoWZrRQC7M5+2JsGxG4ls3x+k7VaQ1vdXwB2YgaWyOB6SC0jQcNe6yD1l899lLOEJj8lL/CWkPFZFr8YXMlRuuLsPrfo9Or2U8+F9ricscntr8A78YzPjz+gKqPNtgWsADfslHE9yiUAJf//4mvZ/zbx9sTmpbkUVUG2lufJZ9MsQhJz9EbCtSCZzsdNCEmywUCK33N+rezkVRehgqvfZWPNKrSX00frkJM3lnz4euDxvjfk08YMOsHiaXuaQssaz4YktsLp7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV8PR11MB8488.namprd11.prod.outlook.com (2603:10b6:408:1e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 01:16:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 01:16:44 +0000
Date: Fri, 13 Jun 2025 09:14:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
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
Message-ID: <aEt7bit5tTWRSHfz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
 <aEnGjQE3AmPB3wxk@google.com>
 <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
 <aEnbDya7OOXdO85q@google.com>
 <7de83a03f0071c79a63d5e143f1ab032fff1d867.camel@intel.com>
 <aEnqbfih0gE4CDM-@google.com>
 <2ea853668cb6b3124d3a01bb610c6072cb4d57e6.camel@intel.com>
 <aEp/cHQqI0l09vbd@yzhao56-desk.sh.intel.com>
 <58cf64a2c4a085099bb801e6c3a966b97bc182e3.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58cf64a2c4a085099bb801e6c3a966b97bc182e3.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0050.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV8PR11MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: fec1c140-3c3f-4039-597f-08ddaa17f622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?DN9G18/C8pirCSl8/H0nCwonq/y9whpFRLgcFURNxAnGSqVCbxmpfAPSxJ?=
 =?iso-8859-1?Q?7BOzx9TTLCg1/CaekFm/AS3Ddsm5D0DdpFnQD9sQRRRMOaj2+pcjRojnzb?=
 =?iso-8859-1?Q?2nX9o+DBGZoYPn6Ng4Dj8SpFOvEMTjsNaOci/k10HAzo2F4SYAwT0xJ4sQ?=
 =?iso-8859-1?Q?5+Agv6L/2nDhq5/0ZJuTpUzBikjhGRIMLXOYCbNDJe7KAb6ZLxbJh3299J?=
 =?iso-8859-1?Q?UlJgdsN3CoQMDwyB/VQWSsGy6/CWhd0Id9wQGrzlSxoUmI0v3esyNc/xXG?=
 =?iso-8859-1?Q?GLBAhxL1cvuIAIqBcevHNCRw6oYzr3It5duW2p4beXZ3C3ji/dU7KBbOaL?=
 =?iso-8859-1?Q?UPNVqasaN+pEJaU1NSPye18tLnM7orQwuuSpn26EKS8B/mceRt5o/ttpn7?=
 =?iso-8859-1?Q?vDSMpIvG4qA6d2QqnB/zl7lwUfCuHJr8jOTa/Y7FMghOsXYGfcKad99ebd?=
 =?iso-8859-1?Q?LBDj2513PKNKMfDPdbX2wzIc5wD1Tw092iKLrnf3xw9BjSRojbKkqNoqbS?=
 =?iso-8859-1?Q?PdpyrddrkxbhP76SKoXVWhM2hKuix60+6QdouujokVRv31O0mdfwQFM2DD?=
 =?iso-8859-1?Q?auBgta2m13iqRn8GnHMB+f2nd7lFV0qT5jrRXUu0SoGnMcmxQjJA+61C6Z?=
 =?iso-8859-1?Q?zqEyM24c/qoiMyMQoKx5Mom3WlF727bGgYenTsuBShIksEHYFfNkmNWF5e?=
 =?iso-8859-1?Q?pw4ii9FCwlBGibdeu/dWsCDXggXZy+0+obIUU1UZRmu+88E7LI1TfFHGV4?=
 =?iso-8859-1?Q?Khev79EhZpam+5iF3SiYRGKeLzXZ/M//xRq891NLH6FLGoZj5S2+8WLs9L?=
 =?iso-8859-1?Q?qdc933fRg7ECd6aH5JdYqQ69HKqtSaCCFxlQ0NuOC6j7xdr3MkPw8RQkT7?=
 =?iso-8859-1?Q?mPd3AgXh5+GbR1F4v36ddx3o6/WIL8beJozBWRD6yHXQrHU+Do/sgf8l8a?=
 =?iso-8859-1?Q?eZiidiqQiN/jQH8GoweHw0Wp+QT1wfGbrZ/a/3J1j9Sr5uX300weORk6/4?=
 =?iso-8859-1?Q?9DDT9f54lWU/WEM8JOTJrbJTfbn3PXzMX3D824JK6QHshah+fySfzpZLt0?=
 =?iso-8859-1?Q?fNtR/GapdSb4TVDUWIoRVppXlqZwNvLkjF09QCPBrw9Zl4jtGUxEId+9zU?=
 =?iso-8859-1?Q?4M8d+qNggEta9NgnYhKGgfSxiq0xj5XxMbAGiIFkBZbUdDQMfcrHQiUR1/?=
 =?iso-8859-1?Q?LkXFNHkgu519Lh7sJkjlyWrXpWhydcfV2nwMxbIbSYjYCAs60H3hp+8i2h?=
 =?iso-8859-1?Q?hmT+em6S1oEBinmiXccMCK4KRHq2WtOMrM0+ZSkuxySZr+srY0+/DiztvP?=
 =?iso-8859-1?Q?Zp1E4ZSvYcCNR5ptYPQrBX9aLYYE5JhgfqkgPEP1WScnZsdR7PYbefLZ3m?=
 =?iso-8859-1?Q?sRnGLQBFN1Wu/PM9koCZXsbREHkvjxu6vAwS7YVickSXBhsTYjwrw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2tR0QRjUN27HBUhliXciFwFUU98KIFHKH4FTvFYwlJPMR5bKRVxl74beNW?=
 =?iso-8859-1?Q?CKJViskJ/9PQvcOjDdze3clwoL7rQY6MLWZ661eAfAz1AffiqoL2MEMfSY?=
 =?iso-8859-1?Q?XmlGeglzOK1DPQbVxsIC5JoiiZ+7+wlQfri/kqhwVETiqOvXkj5RVq8uuO?=
 =?iso-8859-1?Q?ioBs4heJNVhE5jzROJZhoszQG5wfAkRE8ieNZrR9mY+lA7eYe/41qyXXmK?=
 =?iso-8859-1?Q?uEB2PBbvWXsZthGHwFkL68KBpYVaBRfXZShpb4QC3+wIF7vtPS8sdojdgR?=
 =?iso-8859-1?Q?TiS+2DWIiHZzO+qWnolDmC+zM6nT0VNa1W4TbFglhymWSXVlGd9XAs8bQe?=
 =?iso-8859-1?Q?4KfgLU9VhEbjJnh1Fl3OCmQIOJAsR3+q+IMqVX1zo1hiIoTrrNuvXo33IQ?=
 =?iso-8859-1?Q?RjodtN7yWfxyZ9hSod6pPBu3UyJiPzBxQFk9PvWSbD02acPIuSUbOeIl/8?=
 =?iso-8859-1?Q?u7hhUwNU2kvwSX7nDi5PW7OX6IIsUqk+f5SDqs+z/ujtzqZyt0NV5reHxY?=
 =?iso-8859-1?Q?lPWPGZVHGhcAtxJ1reGcFDEXBwbdODU7qm3g+OLbO88oOnFhwcmZa4TsMC?=
 =?iso-8859-1?Q?z1wcjVBx5fra4x1lE0Hztgh7Z1cQhx9J31mT6TIFASzvDIDE54H0WUGacl?=
 =?iso-8859-1?Q?tcAp6m5XsfJhDazD4WG2GZL6pbBOUEk5hN1Z7PCRujAG9FzNY+X0WIQ0oj?=
 =?iso-8859-1?Q?92a3T1VO3V3Nw5gr3BwLCM33VBk1VY/Yn2ByqdjiM6YxefObznMpuTmouu?=
 =?iso-8859-1?Q?TnH9fSOpfCprWQYUTuxG962eGR2576GA7S35ObAfAVD9ONJuXPKusHjc+1?=
 =?iso-8859-1?Q?OpInyN0u+uxe6+RowXFNdfnTBa2YwjWUTW+qXk2/Ztz0EarCpYVe2jKMxS?=
 =?iso-8859-1?Q?JTA6hSJ1UwUDETMpl3+CZ0yk7tABcx6+oBSpGlzVKoHbBLNPn29dk3TXkp?=
 =?iso-8859-1?Q?lCdipe03z5NBgx+0cvfKnhw+xNBqbnNUJ5tyomCekJsYly9pGt2eozXH8X?=
 =?iso-8859-1?Q?t/MQCTjaqhB1okoQM5XrKfFVj6O0V2IL+RmRc3YhpobzvPS/UVjkC7bGCb?=
 =?iso-8859-1?Q?k6BTexNR9K+bFnGLHCl3qkn5NdbmreYJcFACo5NcNcJuydqEhJIGo8kFxs?=
 =?iso-8859-1?Q?aaCkudBrljCpiyG0Hv0V/AN6XhIrx56hTo4/tFCRl8cnsWwfizukk42Hs1?=
 =?iso-8859-1?Q?EqfYK+jrlEE7vdB+ojNnQDoO5T0fadST10ngLzSAhCB1tOPeIbFwD8AE/C?=
 =?iso-8859-1?Q?qYY5sDvEbbqfoC2PlLqjSKhhIVTSDZMKmUzHpvNxDhSH4HZqVE5bw4iN0R?=
 =?iso-8859-1?Q?kqA9M00odg4PZL0WL2QJRf4xZC+wQqBrAZyBgV5aEOgm1LgsL53BcGHgRx?=
 =?iso-8859-1?Q?sMvsD8DamYynpdAvAAwewFkWNTQ5C18ql3UxHV9GdI/mGYxWkD32LYWu7Q?=
 =?iso-8859-1?Q?RvJQ2SLD1d7Iv+EbNxZtjObBlKsXD2hWPiCqQjE0fXCHeU4dfLfeLt5ATo?=
 =?iso-8859-1?Q?m7Tdee8h1Ws++kTGtywZO5WE+VyiqlB9OG4hb5uAiOinWu+rdbSTm8JGEC?=
 =?iso-8859-1?Q?BAN+5ozHPZtHfSYf8ncPFtQ+Eb1AT7LBGwdFKZcNgtmtdNbKwHajZOYrrg?=
 =?iso-8859-1?Q?jygmlJKhuhB1OkwGuXYOYVYTpj5QiT8KFu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fec1c140-3c3f-4039-597f-08ddaa17f622
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 01:16:44.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuv6Uux8SeSAOzzdg6g+/F/ewqcX39mQV3eeFLz5ZHDgHoUIJ6A0CcWx7xlSomBky2CeJcdoEnf3RJF2A2jRNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8488
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 02:50:48AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-06-12 at 15:19 +0800, Yan Zhao wrote:
> > > TDX isn't setting PFERR_WRITE_MASK or PFERR_PRESENT_MASK in the error_code
> > > passed into the fault handler. So page_fault_can_be_fast() should return
> > > false
> > > for that reason for private/mirror faults.
> > Hmm, TDX does set PFERR_WRITE_MASK in the error_code when fault->prefetch is
> > false (since exit_qual is set to EPT_VIOLATION_ACC_WRITE in
> > tdx_handle_ept_violation()).
> > 
> > PFERR_PRESENT_MASK is always unset.
> > 
> > page_fault_can_be_fast() does always return false for private mirror faults
> > though, due to the reason in
> > https://lore.kernel.org/kvm/aEp6pDQgbjsfrg2h@yzhao56-desk.sh.intel.com :)
> 
> Seems cleanup worthy to me, but not a bug. I think we should follow up,
> depending on the scope of Sean's cleanup.
Ok. There was an explicit disallowing of fast page fault for mirror [1].
Maybe we can add it back after Sean's cleanup.

[1] https://lore.kernel.org/kvm/af70ce8626cb7366d9b86a41c5d731f8ebd144ff.1708933498.git.isaku.yamahata@intel.com/


