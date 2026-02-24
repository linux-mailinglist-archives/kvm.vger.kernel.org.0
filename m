Return-Path: <kvm+bounces-71582-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMsMHrE+nWlUNwQAu9opvQ
	(envelope-from <kvm+bounces-71582-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:01:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 734CF182411
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B55103026A7C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 06:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED222D1936;
	Tue, 24 Feb 2026 06:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sn33kHW4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74621FC7FB;
	Tue, 24 Feb 2026 06:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771912874; cv=fail; b=DV/FN0mG3CIyzCJlLtI4C8+uSW72GStYj4KAxEVi2E+7PHcZGFX0ggHo4Nu7NEjCzIhkIxMfarTb3QM2bI1kkB88ZEG8OJFqPPcC7ZZpSSG9gzy4nRiKy1n3VpxoFay8ti+oDw496CFi/7fbr32CFM8Kxy33pXVOxkfpkRB1sS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771912874; c=relaxed/simple;
	bh=ycG5nyxnaTC1ogVtSD25lOp6LSq8+K3Mx7MpVOnyynQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N8kitdI5Wnk3j+oSPyfF4fKl2piCg8XxkF1DIWt7B9ds+S6ZMZZEO6/0BCZm191mclhKmttGGnLD/QXYCB7Q+bmcQuiUNDkrhId1Y8ICp8bbk0TDj1Q30jpZrUOGQKM6a7KwDrObzUR+/sTktU2RmYHfxUgGr10opez76S2Lk5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sn33kHW4; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771912872; x=1803448872;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ycG5nyxnaTC1ogVtSD25lOp6LSq8+K3Mx7MpVOnyynQ=;
  b=Sn33kHW4BH4VU1cmLmdVC73wBNogzROvoOICiPPoNDXvYyVuEOblL5aZ
   FqMo2IuV0dQ7UZsrNF7PD3Vn8SFSQx0N4V/azTB663Rw0DGzHK9zIdLMS
   L4s+X7RXxlInQaBAjQXLDNXjBsNLcXuyxO7DdlSOcOYpzC6dpwka03pP5
   0sULOinHnoIHw8qv2+kS1QV5p7dz3XoF0cYpWPqxI4ZWnn6F7KGSqap8n
   NF7sRn8pXDMy3jSFMsq9sJxJhk4/dg9kOtw1e5iaHFHlZSPurGkYv7iuE
   14vnjfsmHVf2rdPaTVgahPyEHl9W7wS/wTRR22bT3kmkRQbWD6dAvI1aq
   Q==;
X-CSE-ConnectionGUID: NBp6juxgSdyHi6Qd9UpP9w==
X-CSE-MsgGUID: 5vQlFXrRQU29MpqJOQ6K3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72796419"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72796419"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 22:01:12 -0800
X-CSE-ConnectionGUID: XdZMvUgGSby4DSztKknzCg==
X-CSE-MsgGUID: djMWzjrbQ6KwILVfsSSBDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="220322586"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 22:01:11 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 22:01:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 22:01:10 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 22:01:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xsfAm3UzQ52V1eG09C9WRmpMyDmEbw3DTdAYqCGvh+8jEGooRR5SSyVNMO5MFg9f5kPy1oNDd8SiRZ52k/0Oz5esa4LndP5T4yHfgQxdJF887C5EArE0k/279ju2DTdV5y5bYymuYBKiTSveKLbqrjKj5NEk4/qSS8NoByRqX6Y6jhLoB5Ai0E72I7U9qLQ+2lOQu9i8sF0+gSVWJdAh31lpirDwP7cOkJQ3qPCcVLdhWP+RFlWhoHgDVWcDkncbPrFCtMj/kVjb8nFWBUOKTpanAGBCBX7lvQHRqxWpFDR8ecyLVVqxeixA7yp8x0yNZ+aZXpiQsz7bS3Uhb0QCgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYobAzvRBTk7VZJDwqTiwbTPkEsAeByektXsxBJhiS4=;
 b=E3YMYu7Fv/G6qRQolzchDZev+eDgNwmrUuLR1dFO35fkjqK5+qUNqtOB+TYzYdJWc4LyeoVilqQitJ8J/qx0Svakey7ECQUzzeRlQ3hXRXNH5F8ZAiMdAkIQG1Jed6PViuJvGMqJqE4mhnc9GFp/mRSVwNT/cLHWqJDXfyPuXCeQ3WlRAsm99CKtTckfxoQHvq8uoIxM6SPEz6vsIIUTKcE5XHLaUwVo3ZR9y3ce7tAbossiiLIXRwyaqx1g0wx8G8CGutYpZMSWXG7p8f6rPlVOkUO3BAvUwjlpXcFxd55yBm0pHFWK8FSVxocEfhc7aC3p8etD5sbK4BANK6Fa8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8578.namprd11.prod.outlook.com (2603:10b6:408:1b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Tue, 24 Feb
 2026 06:01:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 06:01:01 +0000
Date: Tue, 24 Feb 2026 14:00:47 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 11/24] x86/virt/seamldr: Introduce skeleton for TDX
 Module updates
Message-ID: <aZ0+j0ohYdJlCACn@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-12-chao.gao@intel.com>
 <14ee337df2983edb3677e3929d31e54374a1762e.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <14ee337df2983edb3677e3929d31e54374a1762e.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0012.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8578:EE_
X-MS-Office365-Filtering-Correlation-Id: 0753b8c7-2835-48cb-9cd6-08de736a16a2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6PHbg5uqdZdO8f5pCFL3yPEi5CJJJOp8zcI8VZiNtEh6ARiYcPLI7ixVtOKm?=
 =?us-ascii?Q?R3DJlM5ovH+zTRWRRECNQgTKVxv8NLGPiBQxpb8aj4o+8HrFPg3g5fyhw/C2?=
 =?us-ascii?Q?6Z7k7qzqjwWsfN6fSjnOgBAjPtlpAgQoL1Vs3fdvr/2n2xR4OvE2Gi68DkX7?=
 =?us-ascii?Q?la+hmliUYeeQcCAbbec2L1ecHe4jUHJRttr++1jY3E3cB2wEs3grk6Kmf8F0?=
 =?us-ascii?Q?EuNs6wUG9SzhnB8KI7MsmcE85XWHwotwun9CPYTaIeURHyNtDhCuylgNMJWz?=
 =?us-ascii?Q?q+WVwkbOxKULYi6dHgwX1L3HB9/rxI7bXAk/oyLYpRFMqlF1fAJMZprNR6y2?=
 =?us-ascii?Q?OtBd+HjZdCzyU5a3iwD503YnHrp28YXWMzIXPD9BSAadOQdna6Ndf0Bq6xUN?=
 =?us-ascii?Q?OicQS2uPTFuca0k1//GlqcW0PJqoRvNGHm93pHRSGkKevteNgS+4PgpqaSzM?=
 =?us-ascii?Q?WFg4t296n+tLxJuTRvez1cA+HMib/pOsx4n/n79AotOys1hmoX5B421Lq3UT?=
 =?us-ascii?Q?+NvZ/7qgwYXl3fQPMSRd+npWga1bqgs3FKjyk1TxOUs4L1dNpHwreZGg/bAV?=
 =?us-ascii?Q?XQj2NR++7v+5LzKPirt+wtmWp0JVMxG3Kzpqlr7REB6bCxFFFcWL/qoETNbh?=
 =?us-ascii?Q?a13VreKWadR4bbca4YBN8T6Um3tiN9IxBqXOtoYQeRgAhQzeXwr3vpd7YWQm?=
 =?us-ascii?Q?2HgLVFu4ZLRr8AP4+AKhZGX36+/7tsT0LM63Ae8aZrPOT8cbO1YlhHThftX2?=
 =?us-ascii?Q?HTgh58tLLyPTMU7OxcpucPTzgQzTqw+7nW7YM4tWxomzKiPGEcWcl0bMb5It?=
 =?us-ascii?Q?JQlsuD7ltkFyCDPzMbECWFtJh3rkj9+htthoKKUvEwOQd0YeG/n8Og9rss+l?=
 =?us-ascii?Q?8j/LzfvIM9OxdrL7zmYAhCidOazT8KpNT1Zj9d2X2Ovig5pEnLqkrPA+R88x?=
 =?us-ascii?Q?QmSMKFhdJpnBQaIdBZDKmxSfN7RUI2XiSqszSbLx4MJvXjDs1LcblGo7OQ/9?=
 =?us-ascii?Q?MnsQ5qpp0+9Wv0+jxkG5t0vIOwtKQX+xAYpb/v3ykal/GNAq6/73j+lvhxGl?=
 =?us-ascii?Q?/DL02SglAjSBXna/wtQI7y/18M5LKSgs3p0OnVtNfTry4n1lSHtmDqiDJPBd?=
 =?us-ascii?Q?vS4p0Mf2XzSkg/JoSBOZf5BdE0EizEnRj+15wj7n74Qs/ulfWJB4xR54DTh8?=
 =?us-ascii?Q?DmCRgQE5wi7DSMiOnv5w+ETQujIm4hCnYAzO/ehfE6xQY9epM2lpVu/pTeRG?=
 =?us-ascii?Q?ktBPbNf7EURcydxA74T2Vrz2AiNa/RAWJxZLIoSLGKuMGgxANNz2yZKjqJm2?=
 =?us-ascii?Q?UzI2l86IB4elSOZFAFYEfe+U6aN9wlVcyrhP98APo/S+i4Pr/uIWNR7nDC36?=
 =?us-ascii?Q?LYGSl2eZBuUDAFoPNvfvoOch6clBZGm1TdhUg711mQJ0ZZxeBSp45e/ps+vS?=
 =?us-ascii?Q?RvVbfIHe9TSJwF8+Jb+uUHhvwekKSU91WwU8j1gV9GuEQAVAO+BZcGPI42XW?=
 =?us-ascii?Q?B4ncONITSxq0yrV22vg5hC6Pd49JDOio+P48oWnlgWpKx4ayK3z/wCC/yzpF?=
 =?us-ascii?Q?aOKrm3yNTyyhig4g+10=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nkJ6wMljOYCS7rCb3tpIUXOKMZkZd2q6nFbhl3GcmuF1zdwGEDWV3MFXSsN2?=
 =?us-ascii?Q?fXN4yMkiPbJdsHqTmLUhW0rzph+19F0av+Db8mN9btfZEvKXHslG0+/4bEc3?=
 =?us-ascii?Q?sPN7sIx6b/3gxY3+WVjOoaHNS9lTOocCX5rJczfysp8Yw5+rB6IaJxx4pz/S?=
 =?us-ascii?Q?Hhk5xgVIFoSQFBif5rZaStBDwsjIC5VpK/UiFdnUzoOd36SXOjvVcAOqaer8?=
 =?us-ascii?Q?Q0wkh9+VKIKopjpxbTKco0qpTAMuOR6TdQUaD5XL2c9guNH0v8v5IOBH+hFm?=
 =?us-ascii?Q?nULcWH6wuV6W5Vroo6UjvtaJflNlHHkNjbVG5+ZcJY0KvBSqSaQZRAVsHKrv?=
 =?us-ascii?Q?5XFHZoRmdx/ZuoNXVmv72A7aajlVlkm622le88KTcN3+SGc7n7E3LZYGwXZG?=
 =?us-ascii?Q?9BQMX5bQN4V5S4SR/eeEVIdLVeAN9aDvZRmI8jEUNSov3p2pFTKRNXsjt2yS?=
 =?us-ascii?Q?OnbEasHUBr5QpSyobxGDF9NQNnKy3eNX/EIaxKP7QJN0TaCz6VGzZIYr67ol?=
 =?us-ascii?Q?AT241cCPW3EiFRumwz141N8e6wyV0tbhB4GUiIxR819zjRgCJDBrtUh1Z48+?=
 =?us-ascii?Q?aEd4bjy7q9b4ahpl7+F4qgkO/8D1xs1MpF2zjJteyEeXoXB/BE5CkB8ZxLNN?=
 =?us-ascii?Q?GtwUK3hq7vgxZp7JV3vauO0hpesrdGUC6yH6V8S/Tx+YsJ5vLfGf5SWHpQkZ?=
 =?us-ascii?Q?z7kiuvREh5db9TKVW2MDFb9vXDeeJ6K+u8b0WV1d1WnFZgGh8Hd8aRcNzhfq?=
 =?us-ascii?Q?h9WfVLwZnkm2r03TKfpipY9IAEYAMKVaD3jT9yLR6griMLdMXk1y+s25cY02?=
 =?us-ascii?Q?02seU2myf7ChegGyc6MIGc+J+O+6J5QUZu7Vzl7w5cJVq3I0w8ObixUsy6+d?=
 =?us-ascii?Q?BP5CL73WwaTpYeFfRfwxRsFME3V10rXJzSwjIIEHA/mXb8zRh3J7WMdJeeuz?=
 =?us-ascii?Q?XVjk1CcgjXRb6mtowdGrlXfMPOonIfJYilqF5+Ls0gD+8g/WCVjI4BoXfDyc?=
 =?us-ascii?Q?UvrQQd4tk7VojkoZWUY7aqiOpXURm6HlcAnE1vAYM1Ie29+7SiS921QI+Y7/?=
 =?us-ascii?Q?46gjysxlAh7qCczXURkxOFMeBVhOOttsARoK/mlTCMxN5fPKF7S95zdNGaYN?=
 =?us-ascii?Q?FQBuYELMMIvypLfgVlgIMbk/tLfKoWbZnm56dhsjEABbDbdY2a/MITU3Qsjt?=
 =?us-ascii?Q?agqhcxvyC1pxYISeqP3o70ireDFl14eNqsjleDD3Wy6D/4OsKAjVEZL1thma?=
 =?us-ascii?Q?aEQqINKl4olk19KSyPymoYE7xpcb0VC4p9eNgo8jejF1YxzeujPIUhZxbZPV?=
 =?us-ascii?Q?4GGGMBtn2RjGdCVRzTSACqIlG4DiE0Vst/ug+k6+Z7vGdUXhB81/9wTpGKjm?=
 =?us-ascii?Q?iavq9tdes84eIQkpUi/G5A1Mk7GzZrpPf9OsvPKU4jkt5enr+fPnMg4Cz/GB?=
 =?us-ascii?Q?0Sn+RfojNa5le4OfjspIXDiUsQ5Rzo+h9C84WgB3dE8Utm6a2nSBCIaRY4QP?=
 =?us-ascii?Q?Yame4sRtKdY5sE5SjXMD9EpUfSKN6WHCzBiN3U/DKTV1yjxkMvyaIrNSLDyN?=
 =?us-ascii?Q?hiIItHHqK0xCVx+Yr/IwApyuv3CVnjDCpBQm5JIJqMdFvcJ9TS5W7SFes9Kz?=
 =?us-ascii?Q?IfL7mxuZ0uDfdVwpIAgDPkdlWiV9CpMXcMr97jON03uH0PknnVSrEEg1sPxD?=
 =?us-ascii?Q?ZD9eCcFJFfxog1TFicvkP4RpEasy7eT7fLSXCQH/n7GLuzD/zLxqLLUnyDOe?=
 =?us-ascii?Q?0Nq+Z2yJ+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0753b8c7-2835-48cb-9cd6-08de736a16a2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 06:01:01.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EbNDNKL4WxcDKjN8EcH8GrZLF7+i9htRykcv17yWgtdWYpJwU+nj14vDlnBw9pmgAhWmBV294drh45HnrXPkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8578
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71582-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 734CF182411
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 05:25:53PM +0800, Huang, Kai wrote:
>
>>  
>> +/*
>> + * During a TDX Module update, all CPUs start from TDP_START and progress
>
>Nit:  start from TDP_START or TDP_START + 1 ?

TDP_START. See:

+static int do_seamldr_install_module(void *params)
+{
+       enum tdp_state newstate, curstate = TDP_START;
				 ^^^^^^^^^^^^^^^^^^^^

>
>The code below says:
>
>+	set_target_state(TDP_START + 1);

set_target_state() sets a global target (or next) state for all CPUs. Each CPU
compares its current state to the target. If they don't match, the CPU performs
the required task and then acks the state.

The global target state must be reset at the start of each update to trigger
the do-while loop in do_seamldr_install_module().

>+	ret = stop_machine_cpuslocked(do_seamldr_install_module, params,
>cpu_online_mask);
>
>> + * to TDP_DONE. Each state is associated with certain work. For some
>> + * states, just one CPU needs to perform the work, while other CPUs just
>> + * wait during those states.
>> + */
>> +enum tdp_state {
>> +	TDP_START,
>> +	TDP_DONE,
>> +};
>
>Nit:  just curious, what does "TDP" mean?
>
>Maybe something more obvious?

It stands for TD Preserving. Since this term isn't commonly used outside
Intel, "TDX Module updates" is clearer. I'll change this enum to:

enum module_update_state {
	MODULE_UPDATE_START,
	MODULE_UPDATE_SHUTDOWN,
	MODULE_UPDATE_CPU_INSTALL,
	MODULE_UPDATE_CPU_INIT,
	MODULE_UPDATE_RUN_UPDATE,
	MODULE_UPDATE_DONE,
};

>
>> +
>> +static struct {
>> +	enum tdp_state state;
>> +	atomic_t thread_ack;
>> +} tdp_data;
>> +
>> +static void set_target_state(enum tdp_state state)
>> +{
>> +	/* Reset ack counter. */
>> +	atomic_set(&tdp_data.thread_ack, num_online_cpus());
>> +	/* Ensure thread_ack is updated before the new state */
>
>Nit:  perhaps add "so that ..." part to the comment?

how about:

	/*
	 * Ensure thread_ack is updated before the new state.
	 * Otherwise, other CPUs may see the new state and ack
	 * it before thread_ack is reset. An ack before reset
	 * is effectively lost, causing the system to wait
	 * forever for thread_ack to become zero.
	 */
	
>
>> +	smp_wmb();
>> +	WRITE_ONCE(tdp_data.state, state);
>> +}
>> +
>> +/* Last one to ack a state moves to the next state. */
>> +static void ack_state(void)
>> +{
>> +	if (atomic_dec_and_test(&tdp_data.thread_ack))
>> +		set_target_state(tdp_data.state + 1);
>> +}
>> +
>> +/*
>> + * See multi_cpu_stop() from where this multi-cpu state-machine was
>> + * adopted, and the rationale for touch_nmi_watchdog()
>> + */
>
>Nit:  add a period to the end of the sentence.
>
>(btw, I found using period or not isn't consistent even among the 'one-line-
>sentence' comments, maybe you want to make that consistent.) 

Will do. Thanks for this suggestion.

