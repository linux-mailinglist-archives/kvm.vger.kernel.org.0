Return-Path: <kvm+bounces-68861-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WI6JIXPacWk+MgAAu9opvQ
	(envelope-from <kvm+bounces-68861-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 09:06:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EA04162D6F
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 09:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 760AD7A7E50
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE64359FAB;
	Thu, 22 Jan 2026 07:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKfb97vl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76536337B9D;
	Thu, 22 Jan 2026 07:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769068375; cv=fail; b=nJGTWxUns9fjFeYfKoZSShEKVYPkjKPBlqVr2jKh7PzQynvFPFYYjhRYRIU/KfQclbqnNhTuRsnMchOlGl7YXVXniWwowd+EbH6oCztYpWmz1d6KEJdu3Wm3p/fJk32jvNgXy5aLFOw+XljUX3BAOx21zE+YnTzEmtrWtqbda5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769068375; c=relaxed/simple;
	bh=G4MIJRNEeM8c93kdiIaruuME9e5diqz1k4k1be592H4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kJkrf3PU5oMaMFY8yW5rg5S0e2cKpi1QmOnmaB0DfaFyO3h5Q/aFtHH1TYEuTCKnCgViarDh/Zs0qvgaxCvLghwaW9kkASQDG0q5MXx7At3c4ACAtboaiQQE4dlRJKqtrgGV2vdNrzVGSZz/rMGalwo+SLwI6/Xt/HbvzJR0Z10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKfb97vl; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769068371; x=1800604371;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=G4MIJRNEeM8c93kdiIaruuME9e5diqz1k4k1be592H4=;
  b=bKfb97vl8viuL4X9sy4A1gCcJCqnuG8U+L5A+AwRq/kA8sb6vvAKoefo
   VnYnz4bfQELjCCbYeB1XMMM1ty+OThJWE5ZzKawYdCWdT7NP+1vzPnEvh
   5sjXR8kXLCr6q//G1JfFFHeFk2yVtUYFZYPwPrkTTKTSBT8y0c+2Mayu2
   ppWdyysmaQiELa1SE2VO5AaAOKZOxiXTc5H2SHRKRpJUaPWvT0glixWQl
   gzzS5hU/NL/98ZqwpZp6VQVXYrDNkMWX92L2ateoLATf7SA3vDtWI43Wy
   69HijVq/NIkd247IAXP/NGWc/AE3EFzgLbpUT6oczitdCEv2rRN9OeQzg
   g==;
X-CSE-ConnectionGUID: dggbAF3jTf+6nR3aOJXalA==
X-CSE-MsgGUID: EemJCm7iTI2YKz9p7pXW/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="80928879"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="80928879"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:52:42 -0800
X-CSE-ConnectionGUID: cyA+UB++SwS69DKwY8slOQ==
X-CSE-MsgGUID: ZcJtbKt6QDag8rF6+NZVCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="206999413"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:52:42 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:52:41 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 23:52:41 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:52:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7A3aOlzqQqmKJZ4u/+50TJ19BcLnteZ14i8j5/2aFrJb1qK5DwuS/soMJtEJT3hKynJs2/1Rvn3MTqHpjtf6cMGnDS0lLg5SQU6fBmQz55f8VJt6X+JhLlNvMNLx7xZqu3a71qs1goveOSm52M/J7qsEyFKlrwr4kbFtd653s29dM8mvaNTSIK4qlUpv5a7CIJ1Ts9JmH8Qj0FXlSvJDh7v7OXO6U5caXfE+nmqmHod6+3er2EuWHqXo4xtnBAW7yBio8zfoMAI5LTHn85jJY0dvoi3XuIkxdyfSBlKxBojZ4/GnBi4TRO0UR8e9exoLgyR8VDw/SjAX9fflMRh4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRNb0BaoLHNuK0hy9fX5UtQlvbpoklMEHCO5A7aRJjI=;
 b=CHAhpdkPP4DCdEr9P2ec84rLj+iwqtPZRjKjwHcoph0GMpD65PuziUUAMKJk2P6s92GAWJm5vgncHy1hJGP0X2vg2T58TQxAFc7PNHu0QCPRasL1GaLm/w/sQXr8GUFC03UnyQQcuQ72RvVevAh8/8vNLyJSn2Po1uMxLsYEjZGoLu7V7+vA3acAR1hT0HkkEysAxID42kW0LXMLIPLXC0bsckjH459zzvN+tMAkkZAYecHW/ehBF3Y3PdpGQee+WOE8U9NnLVRRcxkbZ1z/Bt5TGcDn+SqUwG8noWixkpkMD7KKJmFtawtPdC7XK4/AdHKvyXRwoJ03+H2M35vgcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7452.namprd11.prod.outlook.com (2603:10b6:510:27d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 07:52:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 07:52:36 +0000
Date: Thu, 22 Jan 2026 15:49:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Du, Fan" <fan.du@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Message-ID: <aXHWn411DKY3fYWo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102331.25244-1-yan.y.zhao@intel.com>
 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
 <aXENNKjAKTM9UJNH@google.com>
 <aXHLsorSWHRslpZh@yzhao56-desk.sh.intel.com>
 <8e025ab571eadb2a046e2dc1b53a92de6506ea01.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e025ab571eadb2a046e2dc1b53a92de6506ea01.camel@intel.com>
X-ClientProxiedBy: TP0P295CA0002.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d15d1d-6dce-4a2d-4a6c-08de598b354a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4MruzFYem/7XyVfjWmoYoZaKSN5vTrlDNfP8N+IsDELuxBGnlRVy6BP2ZZgW?=
 =?us-ascii?Q?v1sAqhdEGcShlA+3yCY4T1ZwWWdAOqLXPSE0zYi/8rKPaSbjG01LLuHTc8FY?=
 =?us-ascii?Q?SL+UN2QfAtvaiYEdhzcNmxyr3vbZ4+R0h1sNjnKqZ47G4FfWJ6NtbGdG7cth?=
 =?us-ascii?Q?1MIdPdm1NtrTZ4lrCkRNjoI+OqF9ncdU30/coTFiVO/dGM81wX08OUHmiMR0?=
 =?us-ascii?Q?fT41I4JFFxTbinH5qfkCy8eD1WbiKqmEnxys4TOEVZs/1I1k/AuGCyFrASfc?=
 =?us-ascii?Q?LPVmSQWuArgyWAUDLoTyX/70Y22Fh7NdrCjbqvIZR7MNX5873yOXAnfkE1iz?=
 =?us-ascii?Q?IobJE4KZ8szeqc65UkauYmbQbD4qP2AC7uUcOkps5LA7a/+xQaWYvQqO0Ty6?=
 =?us-ascii?Q?tmkOMfjBcaBH/2taYSOI59SRYPivsz7dFIuvI9Y9HINUse51peiph6T4ED1N?=
 =?us-ascii?Q?jXMEQdxWBc1a14qt3eQzTSNZ/M7g7IC/rqnTfG4DYHf/+Lsv+B9MqnPYtv+8?=
 =?us-ascii?Q?95OE9A7eZlxsOAN0Es+YB09ArOhdwcROXdExH4CoB3M+0omx29tuv9mUx5Zz?=
 =?us-ascii?Q?moVGtSHeCVw0bodxamBXLKiyZWK3xo9t3Ash6jj5PQKMy+QLeW2XOr+KtiGG?=
 =?us-ascii?Q?c3ByTpFfZI9WZJ9VsImqDbYypq4IsWFmD8+56zngsVfbd9hpyhtC1QLbQ2aj?=
 =?us-ascii?Q?fdcye4Y7uh1Z8btEio/djQ9Aaaqz1Y4gXtmhjfL0I1ypkV8EXgCh/hQvIrg/?=
 =?us-ascii?Q?ngGIJmOednLJFlDugj8YqgoDmwY3IJB08uEAFFTmqSFqTD73IEcn07BnMt1M?=
 =?us-ascii?Q?xcyM27qqtvGOmzn/HAMGdqbbQczzkiRUkhnOzFanya6Mt0e7/U871YlX9c7C?=
 =?us-ascii?Q?oD46XTJI5yHENGLIcXsfPsG6nagWzGheQ3sKpbivABTtubh7G6STP5UBdUo/?=
 =?us-ascii?Q?Jq+Y5iGFWx+b9sEO0v688DcO8Q02pvbO1CiBkzXHr6ueI2+EenhWQwwXHatj?=
 =?us-ascii?Q?6IAVFXa9+70061s4iwLWWTyDL9fQTHghCZ4Y6H+j9aGk077V7+amJdGLPtud?=
 =?us-ascii?Q?tfnezuPeVjV+kaf7b0D6ucJ62joI3dd+rD3qacQTuvoZoVOZxP2b2juvKpaq?=
 =?us-ascii?Q?ySUDyN0TqJOGnQ1Y8R7oYvGvMTrR9C4MOQkalV5VEG7KT1PM0QSLnXgbBO2R?=
 =?us-ascii?Q?ofVp3aL3gD5XSggfmzMR5nWG35j19r7XZlfO/9dFeUglff6NzVDZYiVZfu5J?=
 =?us-ascii?Q?RT2yMnsa4e0RTIJTMAe3pbWd6qPui8oukbwXqJsH7jD/iFkoknKRv77k6Zg4?=
 =?us-ascii?Q?ZHA/kjy4phIVWBoAfQKg2E+/i8t7kFoVk3ZSBEXOHsP+IPMMpYIIXPoLedI5?=
 =?us-ascii?Q?3W+UBOLA29BgnHLZH8iZjOvBt0NYMy8omG2t7dKX3+GE3lgxePdw2RXjAjc7?=
 =?us-ascii?Q?gSwJ6V+ddHxDil7OePwj6p6KK2dYHTFWsxRSD54mFdK6gslzzFt8lrTGA/8A?=
 =?us-ascii?Q?nDlGJpjLHLp/a+9+ydQ3BUxFbujkK0K3uUuqAPqXOPqZK4X3Z404YX76oK4A?=
 =?us-ascii?Q?yM9CJDSb4yxFDhse9cQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/af5FuHcEwEultiepoAj56LLHfnSDsJ04tl18PkKyfOR/sSWI/SX2gzwEwZz?=
 =?us-ascii?Q?8VyPSAherkqv1/jJ3IlABAvy5a40d1AoT1gAB4oQPUhFHgDo84X+Otembo1Y?=
 =?us-ascii?Q?pKnfOiSpE/k/uVMhr9vTxGoeol+1ZZQFpeNSnY1+OplOESYCBND4lWUJXVMF?=
 =?us-ascii?Q?KfgTWwE7KnkYSsHTAjf3uKbjIzlQKD64xfhERxUHiTa4aJRp1PVTzHMlNF8S?=
 =?us-ascii?Q?9RGGiS8O2oWR0uuTLZe4FCkcLzOjm4bR8rzITQfltFluYibyQe+xAtNcQoTb?=
 =?us-ascii?Q?u5TX7+0Qlxm49MdrAXue/zv4nVmJx2Qgh+xfpp89z4Flen1NEl6UZkaMpvGf?=
 =?us-ascii?Q?/Ku747aHeNynOkHj7z8kJaXeWr/Dq/RH3LMg1PDpQrqFQjgErHATWO8FqOPS?=
 =?us-ascii?Q?ZF06ydERthOqB4TtXD5oIpqQXO1WxhPwyzew49crkxcHO2CcbtpgYUX2t4Wl?=
 =?us-ascii?Q?BGa7YIIHTL9uPqSjd7hDBeOHcASTL61zymPCdT1v6vg+OPZWWaD6rv5yhoUg?=
 =?us-ascii?Q?BhpaM/+LEWLTt1hPMym90yfHnZyf41jYE1dlrWsnUgFapDaI203CVsP0vG/f?=
 =?us-ascii?Q?aLBx/nftg+GMEFsRmkNLqXFV3qyzdFG40LxkE8dISX72vOGn/o3SeOytleX7?=
 =?us-ascii?Q?roZUa55MkwyKiHgNGwUDTxaIUIPOGITi9S1XvX7m5sAMxIZyn6b0n9yBb+MB?=
 =?us-ascii?Q?/gwByeiWGTLLhcZNky67u6JiQn4MZrHYvCweEiVBeeTy5SXi4exEi7kRraDq?=
 =?us-ascii?Q?AmM1rZeQZ3wFojApDJtSbNzFDn22j+8Qh88C9EhzP4oyjy6f5a+9lFL9E/WB?=
 =?us-ascii?Q?KL6VDRBEoHngDlkUBtop93EVBZq9IJlFfKWCefik3FnwqDzrRqfsIxnYDNhw?=
 =?us-ascii?Q?YsBrJRyyaqGYNrQKYxBPCCMoC2SIPqm4WROknEEoAkThDJDc2VVy/lNyOi9A?=
 =?us-ascii?Q?Qchbok9rPHfr1P/3VZgLl9QjV7pft3xRb8UHLcyTT6G8Vgy9J8RT2X3/9p7R?=
 =?us-ascii?Q?9pydeRgzCOIzpxLayBOqzsB7Fj03jDEdwRYaKApJyoNB3aZLDG0yMpCY1GDV?=
 =?us-ascii?Q?tFpDbRHSDOF7mMPe7WxetcmvFGtDhmJFT4QYLnvXRqxcThBjQHE2JHOVAkbI?=
 =?us-ascii?Q?YxAEScZOPHVWvH5zJ8lEIVB1LKYCJflCQ9HpQL65kVPkSmVjnwRdQp0+JXCH?=
 =?us-ascii?Q?UNAcMINJlXa/xOY7OzwVh8k1kFwsRrN7k40Q+SnKpp2AbK9/VGnb0++TcsX3?=
 =?us-ascii?Q?xewFmAu94R1v70sD6juHfSITzztnmRTTMkwU5vkMegQIlMkyxRC/Z18q3+0H?=
 =?us-ascii?Q?3KNyt9SXgyvN4iaTFoDj7KsSRIf0SVaEAavBRxp3on4DYmVKbrljA2z2wJ/z?=
 =?us-ascii?Q?GTCZK7ibP2+QnVFzYpjEDG5OC1f4+DWOXvXojbx2rbz7WXb5jScrIMjRtXbz?=
 =?us-ascii?Q?Qa8NDE3U3y0V+OQ0DHYI5sQ/5yuXmu8J1/8x586DlQUEnTItRoQTRox8ceZ3?=
 =?us-ascii?Q?9koBUIa/7QA7CC7AytBCJajhFn+OidrgExCrhIzu7wxGJXnoT9xMKwJnpFi3?=
 =?us-ascii?Q?dj+kSII+OvQ8IWEil3HXMPsnygdqHmnau/izWHYOfeuVkkJvofCtQa8yPnsY?=
 =?us-ascii?Q?MhN3F6byD8XSs5g3UxPA1Tkm5bArmzuabWCGDm+lXQqZ0GEEQAEFMTIKsgjG?=
 =?us-ascii?Q?zUia+t5V4KthDJLc9TTzHV38EW0qmb6WxdjWu/t4esGw2mo5Vj1Sv2fPgVcn?=
 =?us-ascii?Q?LEPZGOji9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d15d1d-6dce-4a2d-4a6c-08de598b354a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 07:52:36.4012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sF7kzjdPC2a2G/48FifCtO6eMeLrS0vRwofXHe67PBs1YJpzI9DBdfqAYW+MzqIhoXGuHYHZV1qlZJzCA1D6BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7452
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[google.com,intel.com,vger.kernel.org,amd.com,suse.cz,kernel.org,linux.intel.com,redhat.com,suse.com,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-68861-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_SEVEN(0.00)[10];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid,intel.com:replyto,intel.com:dkim];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: EA04162D6F
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 03:30:16PM +0800, Huang, Kai wrote:
> > > 
> > > > Then we can define a structure which contains DPAMT pages for a given 2M
> > > > range:
> > > > 
> > > > 	struct tdx_dmapt_metadata {
> > > > 		struct page *page1;
> > > > 		struct page *page2;
> > > > 	};
> > 
> > Note: we need 4 pages to split a 2MB range, 2 for the new S-EPT page, 2 for the
> > 2MB guest memory range.
> 
> In this proposal the pair for S-EPT is already handled by tdx_alloc_page()
> (or tdx_alloc_control_page()):
> 
>   sp->external_spt = tdx_alloc_page();
Oh, ok.

So, in the fault path, sp->external_spt and sp->leaf_level_private are from
fault cache.

In the non-vCPU split path, sp->external_spt is from tdx_alloc_page(),
sp->leaf_level_private is from 2 get_zeroed_page() (or the count is from an
x86_kvm hook ?)


