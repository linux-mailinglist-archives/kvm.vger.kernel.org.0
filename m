Return-Path: <kvm+bounces-68470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D13AD39E24
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 16ACB300A358
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE0825A62E;
	Mon, 19 Jan 2026 05:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ft0hObvX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E58A255E43;
	Mon, 19 Jan 2026 05:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802321; cv=fail; b=ODQIJXYtWGyqEzFG2K/0IXcoDd050AxT+IdbmS/Y/+W8WONJ9NW0O3fpKvDd4It9C05iNiqMP06bsuhzoVdHLyff/TQfdHbc7d3oa69XIPSLryZEJdYNIjZIGoDpRfe9mBFLIurO8Ea2gN7JC0aiGetKzflYEDNk4NdAGvJSw4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802321; c=relaxed/simple;
	bh=zp43b/jQUTOji06ue097BfPlyrgD3FfpykBW82X5WoQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bRn+QGChF2NCuix0XmN6AETEWuk75Cxy1qcks7myHQEDZuzKMXZ5Jj3LdkZz65w275V+wEZuwjnizZa7xbrvahLCZF9ZtD+9VZcCDPa/oBtfmnH0Te3FDi0ULDOLJ7cByEuAYqRc6isN1nJbuXIJIxKlomnGfcNozMzbiKXH4ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ft0hObvX; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768802319; x=1800338319;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=zp43b/jQUTOji06ue097BfPlyrgD3FfpykBW82X5WoQ=;
  b=Ft0hObvX0XISRfL9yGZCw4l7x/2fxb4Pm/EHJ5LwQGkMhgGhc2M7IB4f
   SQLI72thYdizQavKFpMxaeP16PHj5K7u3CuaciWw89NtLIcLtvwr7V+C1
   GOQ3S0L/fi7MkHQOXk/yzFy7cHYGicFg9pWPDtYjrB45xxYlkEi1qPNlf
   7YZEsLwsIN3BPeNT1KWNvIa2lXNesdKuQAYIDuqCPUs5hJqGMHtMZhi0p
   229t9AbMSqE29lDhX8XYDbIOsNOXvhSG/ECZTq5jk+cRpk6+namECwYWq
   qG2d5zJEpMh6GgifkRynYzqremTo6eyqV8XXd7LVvFB9UVPvBuiKX+XZe
   w==;
X-CSE-ConnectionGUID: cyT783t+RM2XovDI32wj5A==
X-CSE-MsgGUID: TLQEI3PLTP60FRnSkajVcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="95482748"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="95482748"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:58:38 -0800
X-CSE-ConnectionGUID: EtbpcUw6QkCw4PJHeJWwOQ==
X-CSE-MsgGUID: 4et6MLrBSeW9lqd1KT9u2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="206137020"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:58:37 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 18 Jan 2026 21:58:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 18 Jan 2026 21:58:16 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.24) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 21:58:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YjzAtirDOkfp6KoT2daYk88e3v767iGRKdlpMH8lALB3vgCfnl4xepcY778mUBtVlkCvM+OX3jdok8k2ZugD69Ydp4sbrIYEe6AS+/YzF0zDs0FlCjG19Ab0pTb8ck44G3qLC4lDaRqTd0ERSrqbPVqtSbLJNJhnuSrRtrHyK0o4Gqo5p57xpA8ti/FrPzx0+VbYSCI8ba00adMZgtyWuCf2sF/BjcY7xMIBK2BrR+hsLkhY/vPWvDRmgPCuee7JsxOgzFlfXhieXtmOw9lCYVpmc5S8jdhe7ZGReWKh9JZ7JoEBaOkBU59qXqEBjm79JJb6uoELpwyesnlrg+/G8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cjr535ugVA2AhzKfwwNaPPtgYt+ulVZfHlEdXI2FV74=;
 b=vkPGINSQRVVOAdSl2m+LLpjrZwZyO9CvK56QuIt/VmK3jIATuH70sIIhy/EWSzqgzA2Cdy0IN7WhiyEUBjn9fx8MbfOkFeUnGS+Jhb35anBOdFmgaUuSQo6sIKeVVA1gxwaDP0K+VQbX7M05J1tyr9goRXroooMcpHp0qmeZjBu6Z9ZDJ87xk9b+kE0esjBdrownCS5laSWFXdVygmPvoUOPgpnw+8AQRzAXQg1earanQVb/+0U12Q29Put818X90FAfGwzjoa+Exm0NNmRW4D7A7NXfmkx4IlcjHF4W2ISQY3ABGjZkAtS73Nv0++FLQYLe7+WG5zE5pBMw+D7tjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF75D68BA1B.namprd11.prod.outlook.com (2603:10b6:f:fc02::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 05:57:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 05:57:48 +0000
Date: Mon, 19 Jan 2026 13:55:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aW3HUmw/8T+8y+rX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101849.24889-1-yan.y.zhao@intel.com>
 <96f5c9d2d27b151d2d1a753ba303f2ef1f187049.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96f5c9d2d27b151d2d1a753ba303f2ef1f187049.camel@intel.com>
X-ClientProxiedBy: KL1P15301CA0040.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:6::28) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF75D68BA1B:EE_
X-MS-Office365-Filtering-Correlation-Id: f9047e0d-0444-4d84-037a-08de571fac99
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?XXFOK28j4IyZ1HTa5fBCvWnM/tkOR/gw7XxjHZMEG2si4kydl0KoCfZc0R?=
 =?iso-8859-1?Q?78Ydl3gqM45F3gJ1h/eUbvNiWtJpuOyHNUS8b7Ioog87Q0LNb6Oq/15tuS?=
 =?iso-8859-1?Q?InrWaJhnCTUZBLZ4ajvp5eg6NMyNc54rh35u181T6HTb+gbXrVzLJdErPP?=
 =?iso-8859-1?Q?YG/o1ppOoHj9OWb0npDvtbscSJ2SL/IAnrQCJuDRJDO+Zqz6vad/p4TdUf?=
 =?iso-8859-1?Q?uvVxmogS9PYt+PuhOelhv6ATuK/VN6NrC2oUIO878EFf4895mOJl+XBMFb?=
 =?iso-8859-1?Q?Hjq7UUeInO57YXQk52W8iTAeKPyaJgEAhSMxhjF2hHhLbmQMHOcSzyDkRt?=
 =?iso-8859-1?Q?BDUm3ptLdU4wJ05kPDQBIgi7i+yNCcYsDehS3tJN+gpmakRWez5Tm1L4bb?=
 =?iso-8859-1?Q?4Et77MS0MfX48zxM2vgeQhBmcVzQ/Jj+peTppffs3EQYxidBylT5908FB6?=
 =?iso-8859-1?Q?XFfsDVNY3cX3yHi/VPnxZxDTiAZKx4r1DEFjGaMSjLhnw77C26kfaAh+Qd?=
 =?iso-8859-1?Q?GCIpc9OSH0sj7Za5bh8RUhhAIFXbCpv3B+414bbEFUtC8oryIuRG9v2gj7?=
 =?iso-8859-1?Q?znCZjP4y1bC1IUYbCJsM1MWNl3Q5Ozflo7TOjMF9e2KeOYfzPwVgHhMfSI?=
 =?iso-8859-1?Q?ctOlND7/Fr7nH23stIGEdX1NKyOZi33pH88DCAltq2YJ4LbgUZ3PPWsgct?=
 =?iso-8859-1?Q?Pd2R50V6GHc1bOolHiSMfy419ELEbeonokhzFJHNs8AJprBqR9ekThB1Uu?=
 =?iso-8859-1?Q?EpYm3/Hzcnv0c5eFnjgKPafun2fNnGrYr+8Q0f3p6Reu6tisIn/C/qDdtF?=
 =?iso-8859-1?Q?0Rm/++ECa2wljxMl5JOJL6Ud7hdp0xx1+Z8YDe35pyionVuwVMA92A1OL0?=
 =?iso-8859-1?Q?PlnUgkecAEIMidSg0Q6pyuxQIoXBgqcIMypNN/f4BR21Fk5JFmok0Eizvu?=
 =?iso-8859-1?Q?reSw+TR5/HhHNEVIeAPIFYJhvNFORN2UlVFqKhYg/jfCeBi+/1Y3gJO43x?=
 =?iso-8859-1?Q?Gf/vCwSpYbCRbparpW/+rp/zP/C+MUkF2Vs9KR9FzkY1211NuSvGAkhetE?=
 =?iso-8859-1?Q?1yM6Q0u/IOlXqWXgahe6YlII7gdRhdUk+w1hDJIvM+Nc0El3C5bFm5LMSv?=
 =?iso-8859-1?Q?fio7C32XSjMOzWUT0vjZWLt7QaS7KnXQ9uTgkjGW+BtGnPI5hnnZs2XjDu?=
 =?iso-8859-1?Q?tY/F6Athu7EiUVZ2YSK3TxXs1S/dNHzCyP2qLn6YSY8FacWQ1UOndK71Kf?=
 =?iso-8859-1?Q?IPTafzbPQqXSNXF16gqPlIP005rz+zChU30Qy+DDmtfED5nIICafLNTPVt?=
 =?iso-8859-1?Q?YiLFQjF7Lb4XTRile1tanA51JkeXaY82Ot+1W83G6wINqTSLBbDPRbAqzh?=
 =?iso-8859-1?Q?wevzyj/xp3WF+slG41zFzBG6E4PVb6X9ozBoyCBSbaRL70Mn1Q2qeajyG5?=
 =?iso-8859-1?Q?dNn/K4IEAFDNR/m8nLH3vJSqIVXrYcVtWWbLtppjAsdMS8sGFvjjSbBhLq?=
 =?iso-8859-1?Q?sJjRY0iWgx5hhMtim3vkEfLQ/qDPWPt4hMi2FKLb6qLJnJCbVWgg91XOJ/?=
 =?iso-8859-1?Q?P4fpp3CYCEQQYjwT4JgBZCRGMtR6BEsMTrcst8AwXbCWH3T/QOYg2GtxNR?=
 =?iso-8859-1?Q?dpHIrO8v8ZdOU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?UzhcYkETHzR6IB15vGA5j2xpKJMDTHdfqYqHGHxb2RKcXm/8TOJWeD8Mlt?=
 =?iso-8859-1?Q?oZ6+ZvdNM9SXgdK9LQD58xRwiH2lq2COVDXIX28ET9t+Disw08WgEt6nvR?=
 =?iso-8859-1?Q?QIrKyZS2yAB1um6/Za7eLzgi+QW/pQ9Skg/cKMiWyRleEmBiRDWCIU5Qxi?=
 =?iso-8859-1?Q?r4F9PnrTNkV8jqlcxkecYrtIErN0vEAV1PuQ/m/tZ5L82mMFCkFlOzTI70?=
 =?iso-8859-1?Q?bwy0uogSW/i537gVv2cPOSYPsM+KUW/lOPfs3qo+RKoLD9RLxrGWDJwrWL?=
 =?iso-8859-1?Q?qAuKiyCZEKXwvEoWSZOYAVV0VuRKklt2DFGlwIyOSdupAr/hLC44E7XjA9?=
 =?iso-8859-1?Q?yKUiTlse3BWgdVK5oRt+Lt2Jbt5gG+mNHst3VDbnzNk9KGhrA4fARa8zOD?=
 =?iso-8859-1?Q?hKgDyISXD1g8vqfVoDEFE7dB47RMzl19fLxixIizt7R5hPUbwsTkM0jnsD?=
 =?iso-8859-1?Q?E2LWsK6ziaLFiZ2T/MI4JCiZg1G8qj7vRq5riT+RA4HVCQKy+w2VNGbMfp?=
 =?iso-8859-1?Q?k3gfzdWoOSwHby+T4pp/Mffncd6/SsA06RZJC2JewpXw9D2jWJhUUqVTca?=
 =?iso-8859-1?Q?Af61hzAooMcu2o9S3SyTajhmHAB2ztvSCHqEOQZk5aJf7iZUIlftMwOcSt?=
 =?iso-8859-1?Q?wtzuMo7EG0w86h2h+CdZl0paKmT9MRHa3ttmFTsrJP6PVAfU9h8kuC7KBe?=
 =?iso-8859-1?Q?u5PqUNZ0WvtghBGzIgYzdLrusGv+3kTgDNmzgNrq6iUt8wUG/kSkOuYdAN?=
 =?iso-8859-1?Q?+kZ6Q0oi8rmvZT05m/FOqNkdssU35QGO4DzJmGWGNuyj1GLzzr2ZOryirE?=
 =?iso-8859-1?Q?mYa6E7JkMEypkbvF8Fclb8WCnEH8Kr7/6dF0TH5q7a6loK+aCOjS9kJpli?=
 =?iso-8859-1?Q?f2SSQhjqVUuf9iSx0GrVQO+lWCibXnni//K4l0+II//R63VpvcZMxP7Lfa?=
 =?iso-8859-1?Q?ZwF7h0/rHyjOYN1F8IxVQ+LLsQd/drpoWP+WMitqqFvDo3u26Dau7ytcCN?=
 =?iso-8859-1?Q?mR5moctQT//iZnIO7z8G/H7+ypNUH5pwQ90FHYM3VzuLAdu2Jblvg8mXOM?=
 =?iso-8859-1?Q?sSegW/akK3pKzJXvYFP81VeH1lB1Y3xYVr8DU06z8uAe4W0J3F06sHAy7a?=
 =?iso-8859-1?Q?wUMnxc+S8VM3TOf0slDlWYNxwzJN/54W3IwnGBmjxk5KgvF3FQJOFE4ugl?=
 =?iso-8859-1?Q?hCulZaDpdytP+414k1R/iYWF2wg4+SogRhdtjEmf2GhR+YuJ0zOoQQvFjZ?=
 =?iso-8859-1?Q?mC9pOQk/91zZ0t02fMgAj3mkhPWhnHNf2zA/74Uj3m3s7D2Xn43y/VHmGJ?=
 =?iso-8859-1?Q?U1w/Fg6Lo/t3HceOs8oif2atLIT4vlPENac1/VE2ks/KLnnfjDCJIVhlja?=
 =?iso-8859-1?Q?xLSHqzRXrXN45eEcsmteIupy9Zxu3OFGaMF05vJ5dHqHdqs17WOds8zrkh?=
 =?iso-8859-1?Q?0TYcLBrvwKCyTDIxqVmCoqG87ZcbevgqRWWy8kKhIvg/ncEkfu8Ixr2aAD?=
 =?iso-8859-1?Q?c9zdr2h9+smactTf08FLciPsWn5OkBekSMrvtLPIjLr4TRjhCBthE5r4G6?=
 =?iso-8859-1?Q?8cFuL6DMOjp4I8bgiwkIbEJG6wSf9ytspc85ToWEt3RmvatWwbzgjlteaV?=
 =?iso-8859-1?Q?qkR0accxfsW5btwjlVi3RF9tmvPFUrkL+D/S+qiwIO24eW1wW/KwzHnSVD?=
 =?iso-8859-1?Q?yuBjGYOn9x69uqM1BRQWitwY1bO4D6IwEJqFXmtjo9I0JjS+TbvaBI+Vqs?=
 =?iso-8859-1?Q?GAGjMpYCbI7ZIX62df7cp5yoU6elaF+9EQpsXFSSEahuK9kFT70jscUZgo?=
 =?iso-8859-1?Q?RPZF2Vnr5w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9047e0d-0444-4d84-037a-08de571fac99
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 05:57:48.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbQe6jOEDzOpCkXVQ5UxbWOp4wrxED02zbEOiZU4ABtNoDF8YwSBkcqi0H4PRmEiJ+WJ9BoXCC+84RKh9gLWLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF75D68BA1B
X-OriginatorOrg: intel.com

On Fri, Jan 16, 2026 at 07:22:20PM +0800, Huang, Kai wrote:
> On Tue, 2026-01-06 at 18:18 +0800, Yan Zhao wrote:
> >  /* Bit definitions of TDX_FEATURES0 metadata field */
> >  #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
> >  #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
> > +#define TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY	BIT_ULL(51)
> 
> Nit: the spec uses "ENHANCED" but not "ENHANCE", so perhaps change to
> TDX_FEATURES0_ENHANCED_DEMOTE_INTERRUPTIBILITY ?
Good catch. Will update the name. Thanks!

