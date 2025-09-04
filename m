Return-Path: <kvm+bounces-56812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 289EEB4372C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4870056679D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1ABB2F7479;
	Thu,  4 Sep 2025 09:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fm9RieJt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F28292938;
	Thu,  4 Sep 2025 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978331; cv=fail; b=JoSnMTSMc+eBUuc7hG00AY+8HDRDsqPlgzxSc36/9Zsn0u5NPEdD7651q0thMJc+qYNJT3zZDpy4muIMSCt2Ke2uOiCn/R8rFqdUAf2px7dLlOdwSPGnZLpt6PO8WcvKI70TIH7tAAP47tlX8xXhpcdfBvTrkzmhz2iX5E0Xhfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978331; c=relaxed/simple;
	bh=gRb019Vh+elrvJkpyEn2gMijXTbQsuSm/JQv+6HwCiU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VgefcwCOxuqcjgysOgvjL4Vz8iHabUK/n4xvow92Zg1f7yXUWgM+RR6x5ApXkMDTFE48hLYvtfldRIZUh/cvWBJjfT5M5lO5iddeOqaUjC0VXj2+0vzRDbbE6enaiLo7fdACqQYodaUiBDNr8mHvhr5ilc0pTEfiL0u+ctSwNdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fm9RieJt; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756978330; x=1788514330;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=gRb019Vh+elrvJkpyEn2gMijXTbQsuSm/JQv+6HwCiU=;
  b=fm9RieJtrygQMuElajtD9lu2CQll6iQiIGiNakDXdZfOzNVhtgbJGS93
   v5lHMlwzIF88XDpH/G+ndU+667RG1ZNcxJoAP/86chDE4P0zTiMU/FZDS
   Xole4yzOB6wQoO1eARCZvLzX3ELLfYFrLnxEJcVLc33KQjO61AG7VW536
   dhTNJD7UnYxlQ+QJcNNgOD8vsXtoYfCbfaXuUb5Y1u1P1e2gnrJpV+esG
   i/tc2mtYSp+oMv/4dpxlxJhh+dqw47Fms+PO9NM+0UZtL0e0pPVlbRTnA
   iZi8T+TO/RVC5NafBeR3W0ECCxwWAtrtCaZmM1LBZXNE8CvAkO/DAiHPA
   g==;
X-CSE-ConnectionGUID: 0GtaP157T0eqK5FcTEkptQ==
X-CSE-MsgGUID: 7MUtt7HdTXyX3ozU7OaNQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="59457847"
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="59457847"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:32:09 -0700
X-CSE-ConnectionGUID: EPdLnJFMTqu2Cz5eQorHuA==
X-CSE-MsgGUID: GE6r8vDBTQasxGMNwUAjxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="171093068"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:32:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:32:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 4 Sep 2025 02:32:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.79)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:32:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/xzdSZyE0sJ+hSyoPPBGvss7oRITG2OLIJ9sTvBi0K+cswo0tQiHfCX8gxvPt7Btcv93BJR/j1YwZDsu5Ils6dADiWW5j+mBRe8Hq+bood3hGIX6AFzidS3LnIQuafyE4Qzatj9tUQuDdVRq0+YQX/YVyp4JbSY8exV4CAozBq6UJbhztjb8vp9dyspUY0rbiZkyLN5NCoFT9od5lq1bxNGXNjGbKN8nnGyilVWLxfQ8ui41Qgwapx/hBX8LgEaEEbe8emSYCJbIC6a4QEMUwj0b2gbwthpB8pn49xv1P+W4mNOL9mXlzOZUOwRfSJj1azVeMFZ9QKgbMb3lzD7jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwfWL7okpxmFkfmfrn0/qPWUSNvV/yBsQ7h/ggDRV1M=;
 b=yiHfG3ODOf+UewPKkaZYjjwqnZuFO68d73hk21Bm/I1zVPq0w2fMeEK5bEjZr1+8mF+jz79nem+cJsCsowGHZyHnXlEzkfuNQQsO+yHGLmBgX/zB1RNZre9PkrsFC42+4gmasfA120tlZqix5BXQfbe6nnFXrl+esmGyOaeOrb/yYINd7fPWH31V6dfMvztYq3JahL8Aj4smxQvPhHBaNR40c2OE5X9DRxXNhAHkQn41ZNGMLKBn4EtpvGec4B1LM8CwtynyqzO1lburdVxN5a0RBQe/zpuswHkBMpygfLgxwzQ9Mde4eVuE+PXF4R4B40U8X3H+dWao6cZVpYum4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4712.namprd11.prod.outlook.com (2603:10b6:208:264::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 09:32:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 09:32:04 +0000
Date: Thu, 4 Sep 2025 17:31:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Miao, Jun" <jun.miao@intel.com>,
	"zhiquan1.li@intel.com" <zhiquan1.li@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aLlcWmdO/Ast4tKm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094149.4467-1-yan.y.zhao@intel.com>
 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
 <87fe45aae8d0812bd3aec956e407c3cc88234b34.camel@intel.com>
 <aLcrVp6_9gNrp1Bn@google.com>
 <a35581c9e47d6b32b59021f27b18154fdc10c49e.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a35581c9e47d6b32b59021f27b18154fdc10c49e.camel@intel.com>
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4712:EE_
X-MS-Office365-Filtering-Correlation-Id: 92824a9a-e2e3-486b-5503-08ddeb95e8e5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7+nrd693CoWPvyG5VdTKYsZs1ybUxxDYM9JzSCQbcD0pvAWOt834/DEf4SAh?=
 =?us-ascii?Q?ov6iVhTQ/W9yseAx+kpfiSfC1yKDgbfZeKCUW6My1VhuKVrLvI6zPGIEesGw?=
 =?us-ascii?Q?wtekqcyGz9Vr48enCbbBFaWwwEw34yqgRuXpJiJUAYHs4MEO/W6i7+fB8QcJ?=
 =?us-ascii?Q?JRgZkj1xZYWqKTye/E6gDgxHmVcmfqizkwcnXBf92tB6DkdnvoevZ9lTrUQQ?=
 =?us-ascii?Q?VoQHcCVKT5voUkoiitMTrdmz3chTM3vGkHpQG4P8YFT5pX0QhaC0UqwcjXLB?=
 =?us-ascii?Q?ss2fYvx7KrKvx95KPD0fqHFM4TMry1IBSFndyzpN+oB2G4dymWYphArYpNom?=
 =?us-ascii?Q?S70nwVL35jhRxJM5admFV/UpuE/yj8ZEVGscUOWC5FEoNvJs8KmDeR8yasty?=
 =?us-ascii?Q?/Pj4ivRKcyBHI5WmXJ1hOVngS87lZb36oEY5RhMzwfEjtJfpk70dbZzS9Rz+?=
 =?us-ascii?Q?EznozhNJ2Z05meEIibS7Scjc3GjvIamGrc/LNNnufBw21QxPdRbsPusKEL4z?=
 =?us-ascii?Q?z+OQX6Y9U160zjmk8FbA+NLBsD+VFIc0qdab0hkBFlxrbTEDcIP/cx7d15PC?=
 =?us-ascii?Q?PKO9Y9+CvrjMdyN/TOSUWC9LiBejwAtCF6yPz/zEHd/LVpYU+pvY5+VRUXke?=
 =?us-ascii?Q?JQ7tW+Ga6iHIYKimofSJknxNcx+O1vKIZeLjuQIwSF7m2m0LC+kcbC5TgGcv?=
 =?us-ascii?Q?nFlBkd2is3zjADkHS96To8yUGIAe8ZZsoFehfNhJdFu4qolkSHC7Ss2kZKUj?=
 =?us-ascii?Q?v6/xbfXLxLPEX4hZcg3svFffXiaUPhux/jIbsaqCI7AwT9fFTj2+JlfcxM51?=
 =?us-ascii?Q?jX3OH9FA2Wy8M1ff4+HM1fj1aTRBKdzY0uwDkwjBvNDUeUQoH7oWSus6/muT?=
 =?us-ascii?Q?7qs5dOQMJi2rj31rRp49iDDazsp/8WARwXdqmYtgobA9jI56P0iuOk0pqVGx?=
 =?us-ascii?Q?X6KgHTnU1SWSlDqYK3fcW8tDkS0P1+NbNDo5U6tCQaNKGFDhd9NEkkpJhsE6?=
 =?us-ascii?Q?kiweL7Kg10sEUWzzF4r4xw1NwbcBpFg7UlXLIWtK5+EG9VdT/KWTxJTz+O4k?=
 =?us-ascii?Q?RSXqbbP3SesMc4VVoLWundJCjey0UIW4cLKt6esDOX52dHP2k9iB+SCIDhKQ?=
 =?us-ascii?Q?bXlUH+sUu/U/JXQiUWR4hD5G4SD6rPi+HVqNWdDxhaRklaQ+AFdzKMyDuPQ+?=
 =?us-ascii?Q?CbxaCaGOfOcP6g7GmXb39CBN8dKr7UINPQVkAAFi2//ggmUgMvuMV0UNlZjY?=
 =?us-ascii?Q?tDQRGAhw7IqTkzSQh8W3rQTA/ba87yuzbhNnGcwN45cx2KGNq2zbsD3sp07u?=
 =?us-ascii?Q?MItONm9oBTSYyVP+uYZVP8LqhesRTFhRuBQuQNDQUAV/NCv6L0Hn//UaGLPB?=
 =?us-ascii?Q?5AD7pJuqHTRjarkUBhoy+nbtO23OAyQiJ4CZR8ytBme2MOYtDePwDXk5C/c8?=
 =?us-ascii?Q?gnhXQXGCp00=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u78Z83TO6uWTaE+AvGYMFjw2ZiV/opQBYE3OWNHUIqvW1kDbHl2Wys5RV+qH?=
 =?us-ascii?Q?iQHJXJQwR4dPMoy1OuXjkblq3mkZKfohEXuX9A/gimGORhY17shHEX/BoMSc?=
 =?us-ascii?Q?kEuyqT1qSfltGcXbZX7qFBDzzTP8WSRW+m3XB1brDU2yAw0tuGkLgZLVvqmm?=
 =?us-ascii?Q?O5HwUREoQNE3yfWIFQStCffestvMcLeMChOdaMGF1Bndstw9Q50NIc5HUtlb?=
 =?us-ascii?Q?jEEzH/G5rTKvPTCao94vMFN4+6ozMlocWYvEz8HpBjjY0pWo9EAopX4pZ45P?=
 =?us-ascii?Q?pSkyr2YYlFyeBASGh6wFSDjeT5ZcKy7Khs3T/hHpRZx9Z6mrEjQxAC5FpRjd?=
 =?us-ascii?Q?nyY3c4XhIoRM8HjV52Y96xQWTw4Mb6Jkw3dd96ruw9J9ZLP0hgZagAnJ9Qoy?=
 =?us-ascii?Q?WYAVxduJUBnuRGbU3+gRcbGLbaZDf6zQxf9N0tOTI8lwrFzZ7qg5Gjy/3IWw?=
 =?us-ascii?Q?qnLYNPpydaCspE6EDWyOamjCRkvClEuc1JneaLYdhaB+ZFjmIHzUDP2fb/OA?=
 =?us-ascii?Q?6oSFCtaNSHm+VNes22QqDdQJGMhtcO0aCLIFcZacIXxpBYHLXTV9H/hTsq/C?=
 =?us-ascii?Q?vCZL0w6W/el6yJMVQ+adpkS2VloJD6P1ws24INCscWVwtsgSBY3aCaLHGID8?=
 =?us-ascii?Q?C93mXYHmAfIVamsEtHNs+GMk4xTAlGxTdcLp48GOGVnD0HoNvXP1D5A4hdr4?=
 =?us-ascii?Q?kVF1hrRFpYggJp1EWTDgugGGCUrdNCdMr1KZ5XPKPbwtLuDtMDf1mpsh+0As?=
 =?us-ascii?Q?kZgANhau6RMCtAdJ3ucCLuF/duUH79Onf2JuVq24oXwacmVqYbLDFqjDeo0I?=
 =?us-ascii?Q?JsP+dz3Tp016LSWDX9Kc7VT9h670X0oO9bY1tcS0WPJoqVCoBnI20U0Qk0kI?=
 =?us-ascii?Q?qADQZtFOGwJil4rQgQPqbZqn57C7mdeqXPtr6ajfsawWs84eH10+MCha0Kh6?=
 =?us-ascii?Q?xyo8Iz2GLRs/MMkBbfWwWApBXi23BEX/qJiMREtRj4YLmQXNGagyphKzrAVz?=
 =?us-ascii?Q?Cg4idc40zRVDLWRtDBHFu27Ilq8aXN1/4afb/3YyLqKrrUqJjs0LQ7UktMKm?=
 =?us-ascii?Q?gk5bio1YCcCIZEI2w1bkNkCPS6V1xm0OBaOfpa91biltJhbe84kcVnEMM+EG?=
 =?us-ascii?Q?Exz45X7XT/4xUrf41rJamgs2UOL1CG8oFbIfCpN5V3g+y9hh0QYiTD74xcae?=
 =?us-ascii?Q?iFfyiu6lxC99oHCLZr0lT6l7lK2r5bIZ38JInKU6LraJ/prXaF6UHvFxVB3e?=
 =?us-ascii?Q?LVfKw+5veScJLa2BAsYx2TNhtYiYttfLiqFB7vHTIEw+qM5cyHD+9/eUmEUl?=
 =?us-ascii?Q?cuBL/j+sTh3nJVVy5dEIrJ1+tGuzu77mtGAS7SZg4IIq9WvxJlEqXaIgKIxa?=
 =?us-ascii?Q?ndvRFX+e8SI6UPT2gb9nWcyLtPvZrU02/IDn/e3cXzKkOlSuk7oW1oq1p9TR?=
 =?us-ascii?Q?TIdmVjNqc/143h+3DAkfUr3Ppi0TD7NDCs1MrWKD4nBFNMU0iUD9qXWMeHXQ?=
 =?us-ascii?Q?LOQh/nrZfwEXNshGrnstYKZ3uLuXB5vN01/icoYWWRrNeph4nLsrSU1PyaXO?=
 =?us-ascii?Q?1//DIopUs/lpsxDusidmU1b6yGgNXG0fJP0EuODz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92824a9a-e2e3-486b-5503-08ddeb95e8e5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:32:04.8566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9Q9HN/NprGyDTPAkO+JQRRfLMrYrzZUaO/8+ZD2+eDkRb1vdgkE2dSTKE7qz759XclBNbgFgBR23gWLaRRUgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4712
X-OriginatorOrg: intel.com

On Wed, Sep 03, 2025 at 01:45:27AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-09-02 at 10:37 -0700, Sean Christopherson wrote:
> > > If there is a flag we could check it, but we did not ask for one here. We
> > > already have a situation where there are bug fixes that KVM depends on, with
> > > no way to check.
> > > 
> > > I guess the difference here is that if the behavior is missing, KVM has an
> > > option to continue with just small pages. But at the same time, huge pages
> > > is very likely to succeed in either case. The "feature" is closer to closing
> > > a theoretical race. So very much like the many bugs we don't check for. I'm
> > > leaning towards lumping it into that category. And we can add "how do we
> > > want to check for TDX module bugs" to the arch todo list. But it's probably
> > > down the list, if we even want to do anything.
> > > 
> > > What do you think?
> > 
> > Could we taint the kernel and print a scary message if a known-buggy TDX
> > module is loaded?
> 
> If we know which TDX modules have bugs, I guess. There may be some bugs that
> only affect the guest, where tainting would not be appropriate. Probably would
> want to do it at TDX module load time, so that people that don't use TDX don't
> get their kernel tainted from an old TDX module in the BIOS.
> 
> What would you want a TDX module interface for this to look like? Like a bitmap
> of fixed bugs? KVM keeps a list of bugs it cares about and compares it to the
> list provided by TDX module? I think it could work if KVM is ok selecting and
> keeping a bitmap of TDX module bugs.

Specific to the problem of TDX_INTERRUPTED_RESTARTABLE, could we choose to port
this feature to all old TDX modules?

