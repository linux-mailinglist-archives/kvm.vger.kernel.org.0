Return-Path: <kvm+bounces-20521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C78A9177DA
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 07:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6CFC283A21
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 05:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAC313D28F;
	Wed, 26 Jun 2024 05:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CuqoNA6n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA6C44C84;
	Wed, 26 Jun 2024 05:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719378382; cv=fail; b=PI5P/4BzypVC5z9j8dCpwOpMXl7FAI0D1bIM7L0v9gf5B259HrzjCxmkbYdLyENwkNLrIFrwzN2MkSgANy0fCu/2t+AoEUJTZ86wsNj5kWqwDL+HTeBNk/Yzmbj8YN4dsXXdT1+BAsM2kdr98p7+mfIadu6aS00yBZhOFM9iYBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719378382; c=relaxed/simple;
	bh=5ABQb1M7nkpEBv2GBJIymD/jAbhPQqnKEgQ8PGYl8yE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NMpWgGi2lTKW7ZHE4+3fj7RhIzHGzIEfIPvsLaH6SudoIdnPgjprLkQrEAvhksf9PCdem9Sq0gYQoPaVSjqHDsIc2vZz9ryw0aEmcy47f74fF2lHhrgDh4iz6Wa7lMEPanm13kjxnijVDd4F88yqfOc+fHhvCB/FfZpuZJIjo/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CuqoNA6n; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719378380; x=1750914380;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=5ABQb1M7nkpEBv2GBJIymD/jAbhPQqnKEgQ8PGYl8yE=;
  b=CuqoNA6ncC0Dktu6ciYC8VXbsW/H41MxmdRbrks5HmZMxbgXSWUwP2L3
   Z747IGNgxh7L2NYa+0YO/JYz8KxaecPRu5sElBFrkK4WXYBitdrUPw7+r
   hxQOsk38Jv7SlhAJFdlh+KKd4W+GkqtK1H3NmYYeZLUPGd2OeMx4hIDOm
   8EO0XK24UHoxbYgwoLkzD9xtSdviDSc524l8KGUSqzxSq86mz+AuDfxgU
   d85RMBjjZoDWKYvFN9uG18X/UmbRQFviPw0B90swSer4EXS3fuOPqUfD1
   dY8O525dVsAAiaFC+PsoiXiDiFjzx8soVgAAlLEOb+mjtoIaGR4O3RrFJ
   Q==;
X-CSE-ConnectionGUID: 57Nhp2bxTnuSOprqvWOfFw==
X-CSE-MsgGUID: H75tSt0tTEKLDelVjJDpow==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="19320515"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="19320515"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 22:06:19 -0700
X-CSE-ConnectionGUID: /g4kw63JQgaWpMdg6LLYZg==
X-CSE-MsgGUID: E+VLJXHVTAmXtJH4n56KIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="48462799"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 22:06:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 22:06:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 22:06:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 22:06:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 22:06:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e68S5vBRnQzFDT5kiKt3MKRmd3siEQbc4WD9kPKS54yqVm+U1zKJLiA3PNDafoIKkK4LdT2dC9OM/zYH7a6QWX5E7BzpnzuMPwPb2VJDip6ifozvWawTBY/PUE8Nz7GlTSEO/ZJw8NJPSMODBp8kNSDJ2wC/igS0JprVMnsyo2eCcIJwZYV5oRz1h1lfqr6x/yDbF8Y30FObVQQHeZ1OK9gkJ/B81Ly4oVB+Fyrxsvd5Y0nxF/h+IORPNjX7Ro/tEGvYv3+WJZ3q7UK9tzHEkPxbEyoxymTkPrk/agGoyf1rqdys3NHN3fvIe9NdZijvjhjez7I8eq0EO+glUCnstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+vuIn7Mdcb+ez78a4bN2BxAw42ALWH+5tL267kO/PU=;
 b=BS/losXZAhNC5PRMAdZlfhEJlxUdKfof3m+1ZPBujrRI+e5GTo+tdm7ZEOr0N7M6ru9I8PqFnN5f1xupGFfUO719WdVSk78YBofnCYRKFA/w8PE1LsAnEaxb/vfAQApIqFpK7T1fZ2wwxRF1WkFJsz33b+aq9szxU3sDrAcY3O945y8XnnsNImMMU/itOTxcVQoaaMGGYieQiSlj+pCUxvJyRmIu80PVo2YlqPZ+ac6jooxVhEmhVG+6cifnSi119tWcqL0nz77zeKvPPcA+HehBpuqmIQMYA2q46gHKlsOndr8R8k8J9zfDRfKdgvzwQiHXRJpvajvjgiUf6/QmCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.28; Wed, 26 Jun 2024 05:06:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 05:06:15 +0000
Date: Wed, 26 Jun 2024 13:05:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Message-ID: <ZnuhfnLH+m3cV2/U@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
 <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
 <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
 <70dab5f4fb69c072493efe4b3198305ae262b545.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70dab5f4fb69c072493efe4b3198305ae262b545.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bd628f-d411-46ae-7089-08dc959db4af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|1800799022|366014|376012;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?l0SV7kpVxhz/KY2zV9DWcY9sI5Gv7048ynKbSbLq6vQ/28jgCXVk8fsvLx?=
 =?iso-8859-1?Q?3CoWuxS5BkcMbbPQBLZJcnqfIEElKW7sM3Dj7oRVEsKBZ0WBckpnVFzbxQ?=
 =?iso-8859-1?Q?YsSa5/tjE8KKXWc2yOI8h7/RiSRwzxw6cO+soq9pqGbm3FoIDMX+eL9wzu?=
 =?iso-8859-1?Q?Ek7kGjx3gpFEUHXGH4fm0dpjzg7qBhA45S9EL71yVbj4XcpkRg7MOwzmpq?=
 =?iso-8859-1?Q?/2GOvcMCptYIyecvFE3aR2VfK5EaTRiSpGnb5ne/PLByJhenCEPtX9ZAxR?=
 =?iso-8859-1?Q?MNkcRAePw6cvI9xGWPKvsHXgLYKQAOzKuqenvfL5xaHaaDCk9rrG+ufUfP?=
 =?iso-8859-1?Q?BojjbL3H+dA8P7cOIeKCDXIGcn6gp4ztWABi6PC9MSmsEPpdeFyDviCmRr?=
 =?iso-8859-1?Q?r95go/AfHZ+Nmb1sf6FxXjZj6hCB+aiV8A1kCszX0k/pVVuhmxysQte4Nm?=
 =?iso-8859-1?Q?jvKgC8x1PBpqP+1Bk+dRqCGQk8TfuKZ7kDRdJi/H/IynwQ8hCcmvNSiVLG?=
 =?iso-8859-1?Q?4Osne2sQNBxQ0KBVqk2hiIsMZHDioda7N5M79XrIaazsiQ4a2Ey6dCkWKH?=
 =?iso-8859-1?Q?VgJWsYPQBXdsMPnhO27EgqHFcT2662XA4lH9IfKhq1+UNpp8hXu2dWT6Ie?=
 =?iso-8859-1?Q?glOTZES3JIrIqU2NWtuiLb/7rp3q5DVutKNuTh3TtdwiR4+vansQ/6gCY+?=
 =?iso-8859-1?Q?NXmbHxCjg7IEzeiTXd7zfkTuMCOemE4sGmjXSuEM1e6tRbOTFDn9ObbEyJ?=
 =?iso-8859-1?Q?DQKfDm0tq6AOhDR1qTcm5YmwybUyziQY2Bl2WaUYvE7Lb2ehNhlStDCCfO?=
 =?iso-8859-1?Q?GcoVPHs8d/964SIWBppkEBAOmSQp+hBNVKvf+CWZ6aLqyuM0WPn7bYxgFD?=
 =?iso-8859-1?Q?3z6kACsKtbimETFIMI0z+DFU+3prIbNg6+NbSeal+UsZkwYayBN0znj2gS?=
 =?iso-8859-1?Q?MQBVF52Rll9wLHv+sidgF8E2qhDjZpb79sP9H1l9EO2NG8awN+R0oQ9lfz?=
 =?iso-8859-1?Q?Ps2iGGOPpiNRsSRkkGnnMhqXf4XmUPH7P7l0XgIz8+Zbx0BElnrco9U7Et?=
 =?iso-8859-1?Q?eAgVAVTY6IARF2FsgRj/zWzn6pLK430lllmpX/akFgmYcjuDiAd5iLge3x?=
 =?iso-8859-1?Q?91fnHW0Vz0SKx5Yy1Z6PBCc+dBWTPkW1QS6n9QK9cJ9ZlWuwqbvja0q4Uz?=
 =?iso-8859-1?Q?ty5fmFJotrbz97ykCMSMrecGp5Bn2/DTvZJYpr8cMlDbpFbsnlQw3RcrD6?=
 =?iso-8859-1?Q?7E2cMg1+sFUMl8de1rpxArNiU2eWWKrf7JzpHKhFYde2dHJ6qQDfKoyv1G?=
 =?iso-8859-1?Q?kltt+hjzM5b4uKOPP4VL7rzJ+/ev401Rqm8gNr6eoctG+BtGpF6v96DBqf?=
 =?iso-8859-1?Q?zJIPrwp9co?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?biUlE8jU1HYAo2HM6N0ahNupJtqTNKj38yU6lI8VdpDTnb2bnZTfmplUq9?=
 =?iso-8859-1?Q?qYvMmCwacfPH+8HT55GnEGURVVeA7NPflHjdsuEAQ9b9bXgOoT/9Dc6l8r?=
 =?iso-8859-1?Q?lMleIkRuwM9JyGZgjA5umvXgF7lgrbsQc+xX4xNbayEU9crHo7XRC2TGYG?=
 =?iso-8859-1?Q?LAFuJfK02Uj69xga0Tx4mIROP7H4ABgSJ92oujK9aZqL4F7zJjOxM8pqvE?=
 =?iso-8859-1?Q?89r005LuqBImeJmSKAe0Pgp8JuIf91dY+XbPp5qEt3GE3LRnlpTUDrnuKg?=
 =?iso-8859-1?Q?sRC1EPQAf/xKef28jWBWMhYUNPHvHaOLNW9s7RNOJqvOc7tj/wczHEMg3O?=
 =?iso-8859-1?Q?JfUzft2RpaEnkfUF2hh1XOpq2hSc99dubQRMmFjThYDKsiuiqzBAv1pafl?=
 =?iso-8859-1?Q?dMoDDWL7nB/NR+eXePFaDyZvqZb/Md//EmC4qJRKy418Uh9/j+45jLf/y3?=
 =?iso-8859-1?Q?XfEYHO1J/Np4HKYU0Xy8XiGL+UuQy2IQmKLTST3UgPdDUl/yQ5LJietcJa?=
 =?iso-8859-1?Q?piCqY2xPYNr9DRf1lP4AjRAq2WIxceUHbp8mlsReuv8QG+kwhK/urM0uCx?=
 =?iso-8859-1?Q?3553nhzBSeGETfMMQAzLZPa5XNE9A+iKAC3gaHh9PSCmjoVrpq7T4OyKcV?=
 =?iso-8859-1?Q?yHmDr5MB8XZTFmut+VmLdW/YqBuahQbhcAinTI0bapavOo5hd0US7rrLmt?=
 =?iso-8859-1?Q?QQrjTg0+e59Bxh94Rfwkr8gsntLDJJfwhbYMh1nFWRI8DK3tV43NrSBQEd?=
 =?iso-8859-1?Q?gYf6IXL3tkL7AeA8IjJ0YQNZiOfIJG6s1/ssqisjNYptZZCLTYyuqcIcTc?=
 =?iso-8859-1?Q?gebcfUzoBfJTSr0dR4M4NSpcS0Vxo0ANc3BNdXAgFzwcCLr7eg+qOOhTGo?=
 =?iso-8859-1?Q?MbSS/VCvGfUO2Xfwnw9HJqeakVXprtV1uLKEnt4aOfWqy6FlbgNt44DlBc?=
 =?iso-8859-1?Q?Rl0fk9b02l3GKgyEginLq65fDJ14caVxgw2lvg915kI6kGCqamcwEuqF6F?=
 =?iso-8859-1?Q?j81L/4kjUbUetW93CVcYToOs6ssIK/+q7jNevN8A5IqEd9lylH9ra/Ghs4?=
 =?iso-8859-1?Q?IJMF4kEF7S79xsdQ/JmDIXztn5EnR0xv3rF9XV3AuScjDv6xoBHFm6cvPe?=
 =?iso-8859-1?Q?FBQjnxs9S+Ewm3OGo7hx6JStHLEpRBpUJvgVgGDzXt/bnB6U8W3GQ8g2Gj?=
 =?iso-8859-1?Q?74wEwuIULLKekAdQLlZ+VHnNXCiq0yotbUYVXQmuC+gzBWiWUYvC1TxIvF?=
 =?iso-8859-1?Q?9Wg3MBuJ567yahCsJt4MO7txcno4St8XSb8+HG6QZRyjd6IlGphvExmKeK?=
 =?iso-8859-1?Q?s40Jbs98SaNIlM93bxkbWzNU+LS0EM5f3W3ac+shNVWGKlGzCetKtfOVFa?=
 =?iso-8859-1?Q?SdYITsFqufSbPnghHgDwvOiIXvdvHFvsob+k9iiL4IgDZytXt300bOpvLy?=
 =?iso-8859-1?Q?vbWw63L0NQIjV9ySdVwF7RY1pmHohvx0ycVCl1Ow1moEGoJnZiMZ5JguTY?=
 =?iso-8859-1?Q?EeiVhIFTTJnpa1I/jJ35lvLw9fjfMGGPmGVECrUR9dKJmDOFfcV69194eq?=
 =?iso-8859-1?Q?yF3mymsJ+L9Z74rAcgIDal5uXccagTW9ym1kvVrETchnQyKklIEjcS5aRo?=
 =?iso-8859-1?Q?fXJU4ie+PAw1KO4EoztnUfHlK+d/Lqw33v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bd628f-d411-46ae-7089-08dc959db4af
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 05:06:15.5039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXHnsFDJIaqXOCRndL8VQmOMAw/ydmhS+pJ28FEJJOr2/WZU3X9TX5aWHVhU4IR9Lauf8d9xlid+Y4UQH15i3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4545
X-OriginatorOrg: intel.com

On Wed, Jun 26, 2024 at 04:33:20AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2024-06-25 at 13:43 +0800, Yan Zhao wrote:
> > > > > I was originally suspicious of the asymmetry of the tear down of mirror
> > > > > and
> > > > > direct roots vs the allocation. Do you see a concrete problem, or just
> > > > > advocating for safety?
> > > IMO it's a concrete problem, though rare up to now. e.g.
> > > 
> > > After repeatedly hot-plugping and hot-unplugping memory, which increases
> > > memslots generation, kvm_mmu_zap_all_fast() will be called to invalidate >
> > > direct
> > > roots when the memslots generation wraps around.
> 
> Hmm, yes. I'm not sure about putting the check there though. It adds even more
> confusion to the lifecycle.
>  - mirror_root_hpa != INVALID_PAGE check in a different placed than
>    root.hpa != INVALID_PAGE check.
>  - they get allocated in the same place
>  - they are torn down in the different places.
> 
> Can you think of clearer fix for it. Maybe we can just move the mirror root
> allocation such that it's not subjected to the reload path? Like something that
> matches the tear down in kvm_mmu_destroy()?
But we still need the reload path to have each vcpu to hold a ref count of the
mirror root.
What about below fix?

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 026e8edfb0bd..4decd13457ec 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -127,9 +127,28 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
                         int bytes);

+static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
+{
+       return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
+static inline bool kvm_mmu_root_hpa_is_invalid(struct kvm_vcpu *vcpu)
+{
+       return vcpu->arch.mmu->root.hpa == INVALID_PAGE;
+}
+
+static inline bool kvm_mmu_mirror_root_hpa_is_invalid(struct kvm_vcpu *vcpu)
+{
+       if (!kvm_has_mirrored_tdp(vcpu->kvm))
+               return false;
+
+       return vcpu->arch.mmu->mirror_root_hpa == INVALID_PAGE;
+}
+
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
-       if (likely(vcpu->arch.mmu->root.hpa != INVALID_PAGE))
+       if (!kvm_mmu_root_hpa_is_invalid(vcpu) &&
+           !kvm_mmu_mirror_root_hpa_is_invalid(vcpu))
                return 0;

        return kvm_mmu_load(vcpu);
@@ -322,11 +341,6 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
        return translate_nested_gpa(vcpu, gpa, access, exception);
 }

-static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
-{
-       return kvm->arch.vm_type == KVM_X86_TDX_VM;
-}
-
 static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
 {
        return kvm->arch.gfn_direct_bits;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1299eb03e63..5e7d92074f70 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3702,9 +3702,11 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
        int r;

        if (tdp_mmu_enabled) {
-               if (kvm_has_mirrored_tdp(vcpu->kvm))
+               if (kvm_mmu_mirror_root_hpa_is_invalid(vcpu))
                        kvm_tdp_mmu_alloc_root(vcpu, true);
-               kvm_tdp_mmu_alloc_root(vcpu, false);
+
+               if (kvm_mmu_root_hpa_is_invalid(vcpu))
+                       kvm_tdp_mmu_alloc_root(vcpu, false);
                return 0;
        }



