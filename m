Return-Path: <kvm+bounces-47738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93536AC45F1
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 03:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21B201898BB1
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 01:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA1213D53B;
	Tue, 27 May 2025 01:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2pOpGcK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAF2CA9;
	Tue, 27 May 2025 01:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748309704; cv=fail; b=OFT7uiPNAOuY/SZgccBK5mI8NPxE5hCKk2JczkN1Z8mz6+ABs0b5GeSB1rw/RckfgYTUD4jLbnI8LCjwHY8ogQ13P8jg7x3Zy2+LFoh1Yn0RWD4wo+6WEkDUK0nxiu4qjbXMAeFOxYLY0ospEulq547sfx/PysjOPgqgs2e4Ht0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748309704; c=relaxed/simple;
	bh=vhujLntMG2qY+I7FxhzS7JIgcVnZBNS4F6NF260Fhjc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LMFjhmZIAzYa5HceF82OmBzMmoQYtrKkfJkM17i1OD68OGOspC1m5LhUPsbTaqvwHLcRsI+6XZRYSn3aKyivfq5+JJoArRXm5TMhvacn60XLKgzP4ItO/6dHaKMFXB1qp4OnkoAy/QxwlQeUfAWKA/Z5GGhyIMkkg45a7I9z8h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g2pOpGcK; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748309703; x=1779845703;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vhujLntMG2qY+I7FxhzS7JIgcVnZBNS4F6NF260Fhjc=;
  b=g2pOpGcKQM+QaHh7bFgsCO1AoEulzy2zy8KzSps5N4vuI8866NspJlUT
   l8N592wspNObINsURaye5W+waW7UHWzgLsAgLqlZDcZkkFZWExFGz8tRK
   8zKOs3F72j1qdww7bmVF8tVQR0Tf6771pl7THozvrCMCgq+wcowIfZaY7
   kGxRzvVAZ+4CjAe+TURvh2DV5X/ORipPs2nygSgboJSVLdTzp691NAy7j
   HkO1CMvFC8x+VZjc/TXxlpTILLON6eioph7Bqso2aUzG/xjpoxnfGR7ut
   TzV9KgyxzlrhZr9wOvSdCUKOk7K5rk98MlsoW4gzfJHqtAYo69RODXA88
   g==;
X-CSE-ConnectionGUID: 7gAEgMMnSqe0zJra2gM64Q==
X-CSE-MsgGUID: WJRe2pnNScu2gVgub5cKZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50442083"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="50442083"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 18:34:59 -0700
X-CSE-ConnectionGUID: CYzT3+exSG2fjCiGUWy6+Q==
X-CSE-MsgGUID: w7Fp/ETpSZ69+OZCuqyiyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="165765300"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 18:34:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 18:34:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 18:34:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.54)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 18:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqutr2+cbP+k8LXZGSwqUUoqGft+d1rwGFCYg5aB1iYT01x4N0QpVQMgZe9gPM2sYhvm8mVjGH3L6xaBCThvYQFBl2GF8MgBz3HWWUuJTaSnwKt0Gtc8YonenRd46LpKnoNtE8kUrvaLUW+WeQLzjQ6s8RI53U6XTJ/1uklqZ/dXqFGi5rkU0vFhPKbSx0IFDF9oIbrFUeZXH6aTr4ZZGhxPVv3bfPm3uPWUo89Tj5gNntHVzeqnXchGs7YUNCp2jOM/49hSvYigffVkcknEpoBReN7uN8r8Txf+7DWqWnRRJGGa9gkpMp7oTcB013zW3JzJaen0EVaTAcz2G6dLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/DM2HaEhMFr+yBSuws0GFw08tso0eKCyG6EolchOiY=;
 b=ykbcU71JwpzYgT8lEq6C0u67591g7r4ZTGzpt9F/j/LTvETDKnCv8ekqswhwCB/opppcf5+d3QK7bEp7rwDllsKFyNH3sae/wnhKJ9/4FlPUGBLdBCbb60Zy+yocIGhCaiya0RW9rvJQrvT1FMIChVXGpLNBmcHyU5VvABPb+Jznczm8Faa/sRm8qkbpmNjekDvsdp2eZStt2MdY6YzDY3aJCGOxzvlObM586LKiVFkiiwZ+WMIdXpxDbug4koEVQZAeXmjcFJwKDM+rL2nbu2QFkAQeEhEJUHtZu5Tt5ykLcYAZYnp54+UUQUuyBYvYnvm/N4oOQetxqhh/C7AMxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4534.namprd11.prod.outlook.com (2603:10b6:208:265::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 01:33:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8769.021; Tue, 27 May 2025
 01:33:54 +0000
Date: Tue, 27 May 2025 09:31:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aDUV+CWwjb29pZa8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <d922d322901246bd3ee0ba745cdbe765078e92bd.camel@intel.com>
 <aC6fmIuKgDYHcaLp@yzhao56-desk.sh.intel.com>
 <25e5dcc794435f1ae8afbead17eee460c1da9aae.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <25e5dcc794435f1ae8afbead17eee460c1da9aae.camel@intel.com>
X-ClientProxiedBy: KL1PR0401CA0031.apcprd04.prod.outlook.com
 (2603:1096:820:e::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4534:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc9aef1-9c9c-4995-1fe6-08dd9cbe8ac4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8b+UUNGc1nwWGCzQc9ao2z3ZHEJlqd17QS+DVHuC1LHElJLVqx2Ulgj9/dkd?=
 =?us-ascii?Q?BwMK5o7HftMy/qLksZJdpQN6ZUIQTH1EMgFtLcQCqTHLpUBYFbiLVa4W5hyD?=
 =?us-ascii?Q?rWTwaL4XcQfgXjfSVcoSWgFsUeD1YQvyY/EcmQDuROlP6tctowPbgPuSwn1t?=
 =?us-ascii?Q?cfpJQ2TIy/iVUUeG7fQQloZVFVi3Ya8U8fCZzRmbbHuX+WTH0fL+1UeJekDJ?=
 =?us-ascii?Q?xwooH0wAqAlCmSHgoTAEWHZyX2H459fJZmXM7mj07TCume1KVl/Hirx5ZDKE?=
 =?us-ascii?Q?q0neicCDwCXBj7uv4Qkls+eYLg/+6+xg7lDDkSQtWWcK8HHlfpecrSGpUpTr?=
 =?us-ascii?Q?Dl/fAllo9dBDVu504OHZ+pzw7izNquhiNQ3ubLhssRuVMI/YZg+iGHuCPXqi?=
 =?us-ascii?Q?BHniaiYY1fzZT4kRWuoFDZmcNHgn6ag3AKeT3GINo70Pv31f0AsJ0RB8eAv4?=
 =?us-ascii?Q?oVX9XLtk6S0lpxm/P7axtTHl8tVV/hF8jtx6eFuHg/z1n2DEL/9Hn6A+h5YL?=
 =?us-ascii?Q?RIiGY/BXNcJBR6sqqlrUlH+cfl4PRSng5/TSLkDjaL3zzqdhoxW0nPTiZf9F?=
 =?us-ascii?Q?vQpHEkmRPQRaUSR1fLarH3TOGuw02YORVdP1L4ErslYc0wqyQyLvhKpzzfV1?=
 =?us-ascii?Q?D2MN3adFtCDSodvYPmKUYIZbUMIenszfyZtBjiUBXrDUoKVF19UPABIC6QAM?=
 =?us-ascii?Q?n92lzdc+FznTfw2OB4phfrdVo+IQ7QxTF8bFRaTq6tgLjXTPdKfm7Qr18S4g?=
 =?us-ascii?Q?5PukxfQsREhzV42cwqKGGkq0mUeDUwN8BPBGjkppcpmfvno+XgWq3xX7iN0d?=
 =?us-ascii?Q?ZBu9mlWsGhHNdy/4eKbDbVnSDfd1SF1OK4bBra5+Jzzi7dCyWn8g8r/og1Yl?=
 =?us-ascii?Q?p0Z4bAU+C2h1mEsSfnoB8gEI8JEkmJVS+qiYk1D+kF9YVOsamrwiFZSrZzgg?=
 =?us-ascii?Q?Xhf/mGRZvI/aOjE8urzjSAXdyFyvnWvih0+hTghPrtb8voYn3E7DDCorPOV8?=
 =?us-ascii?Q?oSw5mmFqiCsorUNXPBI+/dMBTMN+GBeKJ+Y0adm+nmXLoOzAJVfly4UwyRjH?=
 =?us-ascii?Q?W6DIATRZXoomcyd0ZB1c+Np5DXKaJEBgUDTaVu+Jvs6SlyNwC+uxjSf1Qebo?=
 =?us-ascii?Q?A9G37XdccjaRslmigwL+bKarZgWI+RlrY8GDIiIKIKb7emw/tB1ak3iIn75f?=
 =?us-ascii?Q?PD4nRHYrinJwLYqme7yAnzlqW2/3GBDMkuEkFU65+U/tLsA/WzvKHD1SguA3?=
 =?us-ascii?Q?2zgYIKI1KEN9sRCnV6wt3pBXmv4eCW8MJo7TShuwDMBF5FuraXl/ZzY7bXyA?=
 =?us-ascii?Q?mA4G4qV+7WPxS/yRA7R3e+dm/RwIiD6x/LyPmGU/I7LxykWOgGFrVOtFnpFU?=
 =?us-ascii?Q?394LQtWBbLlqnRJ+OgCe01aukBlJwvbzQh85Kzhv7EVEkqxsZRsNfVgl8ZMD?=
 =?us-ascii?Q?90ur8kyGnIo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OwfmZt/5vuJOxI3ZbKyI0svY0WKicVU2TtAX9F/XVjihJCO5rIieiRbIa8Fn?=
 =?us-ascii?Q?zhRg4CKPNjC2O1h8zZDo1iaZlCtVg8pQob6f8i01WrhpzJ3M/GyHpg9Oen74?=
 =?us-ascii?Q?BRl+tZFlie34sCvARkVhfM5qCgb7GwEOVfRv7t1XdQ66J9LxEpXL7MzTmXMF?=
 =?us-ascii?Q?53i9k4tejJxQ8CH5kQzy69nA3nu4r3orQzzvG8LqdK2+lTb80nu7ihrvfWTq?=
 =?us-ascii?Q?sRpak53aRJWX3kOotZO4mdV3T1f3Bo8Ux+4YbhMOGMsXgLD1iuJyX4bZcHHE?=
 =?us-ascii?Q?uBA+/FyGw4o7NyF2Vy1KimWFsrrVyA9Hctd4CvrTnzgt8haMAYNvsXfPiP32?=
 =?us-ascii?Q?bT+IOKLOy4xCGKOC9PCAmv424rRN2rpc+cjSiXFJRBENVrFx1n3uWIlXnPLL?=
 =?us-ascii?Q?y8gDA4z1s9ZTjJUilp17V8g2WCtkPO25QkWO8e3z9bkfCNbq/Yoi07sNpx1R?=
 =?us-ascii?Q?OWrHBmDNySgodk4nzlDJ7heMc85KBUUFoVbuz/4cLAc/1so/CCTOxEeBiy9N?=
 =?us-ascii?Q?yWkzCmJ0vI4a8nkAfyQu47U/axf+FY1hwL1cqqw+VZWBMNvKgvb7bBuS9fKT?=
 =?us-ascii?Q?FIjWiRzZiVhq6afdRoo+HGolrkAZls5iJZ3dZFx2ryNABj34xGzr8r3fgSlJ?=
 =?us-ascii?Q?H/bO0brIxSE/EQUXY4pvBvOcaP5FySdsOz9h0bpOmxPSdmqJIg9gMhvfDAy8?=
 =?us-ascii?Q?11UpH80uchp22jLc1h71zrB3C1DAdWs+YzHKkUQdMYvmQp5DqLQGxpWVgIk5?=
 =?us-ascii?Q?NaAStQGhaV3705c3SuQg+8bMbbJyXn+egFwBIo13UgeJd55KPWk9PycCdx9i?=
 =?us-ascii?Q?ZdU+F8x6E7DszyEdkU5sSHnifFYG7MMzG8qPI85a7ArFqU65ZpMRDQZ84sRZ?=
 =?us-ascii?Q?4SzjWlr9wHfxx6BxC+cFH0ezbHLNRiECTygJr+VTSdi/iZmRt/tGHGmOPkuH?=
 =?us-ascii?Q?pzXAGfcDQBIyGpbyDRDkZG58ldKuhao62pJ+LYgXSmmsfeqEEdQckFn2C6AE?=
 =?us-ascii?Q?dyX7ADsRNGjDtollhQtsWARx9TzV/OjSCwFl40/yqQBLZvCvh+LLVU6OL15W?=
 =?us-ascii?Q?xHXpy4sht8VCCx8OdO/uIXqvL8KykQNasZBUb4A+8+Y9/aS6QDfKcGLETdxT?=
 =?us-ascii?Q?ygNWAFx20fD1N0BGXGGjiX3ZOqJVpNJ0+Zkr2nMswJm/tXOgFmNNnDFM9a5q?=
 =?us-ascii?Q?W2cy8NdHCSswyUS8E5xNxlKIzERCdrHYU5Tk0RJY7YVWyJ0WTwRfLmKPU/eI?=
 =?us-ascii?Q?OI8RUb7agakgUZ2L2bGpalxWBR3wafekyIy6GP0BZ6A06mqIUFzdhrKqW2lT?=
 =?us-ascii?Q?yP8Mk3CcqX22HC3+Zr3YQMNM5kxO/C4oa1fs0FN3u8MW4ayp64DjM5HDl4mF?=
 =?us-ascii?Q?29NPs1o+lWQXUg7hwX7+X7VGz5TJNSqg1eWwUpy0zNW44bFjgU4pmwccwbVK?=
 =?us-ascii?Q?Xh5+0IT/DjMhhw6tTH5v8+WhQphTofgLwcL4PEn5G4OiekPvrZkS/0KqPc/z?=
 =?us-ascii?Q?YyMfR8u4ul1RTS7zsTGW/09wbsSxIEURWlEojaLMDNbehySyvXftLubAhx3f?=
 =?us-ascii?Q?nbCjALczWoH4CmPfur0ABJQGfWAg7X0pNvKHz8PG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc9aef1-9c9c-4995-1fe6-08dd9cbe8ac4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 01:33:54.5137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Az6PQqPmJt/nhx8b+MfRzqBqkB3RdlpwRrxCTmm98rIJtSI+OhxycJeqwcQIaOBwXCFetHvPVJDtgoqVL5EtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4534
X-OriginatorOrg: intel.com

On Sat, May 24, 2025 at 07:40:25AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-05-22 at 11:52 +0800, Yan Zhao wrote:
> > On Wed, May 21, 2025 at 11:40:15PM +0800, Edgecombe, Rick P wrote:
> > > On Tue, 2025-05-20 at 17:34 +0800, Yan Zhao wrote:
> > > > So, you want to disallow huge pages for non-Linux TDs, then we have no need
> > > > to support splitting in the fault path, right?
> > > > 
> > > > I'm OK if we don't care non-Linux TDs for now.
> > > > This can simplify the splitting code and we can add the support when there's a
> > > > need.
> > > 
> > > We do need to care about non-Linux TDs functioning, but we don't need to
> > > optimize for them at this point. We need to optimize for things that happen
> > > often. Pending-#VE using TDs are rare, and don't need to have huge pages in
> > > order to work.
> > > 
> > > Yesterday Kirill and I were chatting offline about the newly defined
> > > TDG.MEM.PAGE.RELEASE. It is kind of like an unaccept, so another possibility is:
> > > 1. Guest accepts at 2MB
> > > 2. Guest releases at 2MB (no notice to VMM)
> > > 3. Guest accepts at 4k, EPT violation with expectation to demote
> > > 
> > > In that case, KVM won't know to expect it, and that it needs to preemptively map
> > > things at 4k.
> > > 
> > > For full coverage of the issue, can we discuss a little bit about what demote in
> > > the fault path would look like?
> > For demote in the fault path, it will take mmu read lock.
> > 
> > So, the flow in the fault path is
> > 1. zap with mmu read lock.
> >    ret = tdx_sept_zap_private_spte(kvm, gfn, level, page, true);
> >    if (ret <= 0)
> >        return ret;
> > 2. track with mmu read lock
> >    ret = tdx_track(kvm, true);
> >    if (ret)
> >        return ret;
> > 3. demote with mmu read lock
> >    ret = tdx_spte_demote_private_spte(kvm, gfn, level, page, true);
> >    if (ret)
> >        goto err;
> > 4. return success or unzap as error fallback.
> >    tdx_sept_unzap_private_spte(kvm, gfn, level);
> > 
> > Steps 1-3 will return -EBUSY on busy error (which will not be very often as we
> > will introduce kvm_tdx->sept_lock. I can post the full lock analysis if
> > necessary).
> 
> That is true that it would not be taken very often. It's not a performance
> issue, but I think we should not add a lock if we can at all avoid it. It
> creates a special case for TDX for the TDP MMU. People would have to then keep
> in mind that two mmu read lock threads could still still contend.
Hmm, without the kvm_tdx->sept_lock, we can return retry if busy error is
returned from tdh_mem_range_block(). However, we need to ensure the success of
tdh_mem_range_unblock() before completing the split.

Besides, we need the kvm_tdx->track_lock to serialize tdh_mem_track() and
kicking off vCPUs. In the base series, we use write kvm->mmu_lock to achieve
this purpose.

BTW: Looks Kirill's DPAMT series will introduce a pamt_lock [1]. 
[1] https://lore.kernel.org/all/20250502130828.4071412-6-kirill.shutemov@linux.intel.com/

> > > The current zapping operation that is involved
> > > depends on mmu write lock. And I remember you had a POC that added essentially a
> > > hidden exclusive lock in TDX code as a substitute. But unlike the other callers,
> > Right, The kvm_tdx->sept_lock is introduced as a rw lock. The write lock is held
> > in a very short period, around tdh_mem_sept_remove(), tdh_mem_range_block(),
> > tdh_mem_range_unblock().
> > 
> > The read/write status of the kvm_tdx->sept_lock corresponds to that in the TDX
> > module.
> > 
> >   Resources          SHARED  users              EXCLUSIVE users 
> > -----------------------------------------------------------------------
> >  secure_ept_lock   tdh_mem_sept_add            tdh_vp_enter
> >                    tdh_mem_page_aug            tdh_mem_sept_remove
> >                    tdh_mem_page_remove         tdh_mem_range_block
> >                    tdh_mem_page_promote        tdh_mem_range_unblock
> >                    tdh_mem_page_demote
> > 
> > > the fault path demote case could actually handle failure. So if we just returned
> > > busy and didn't try to force the retry, we would just run the risk of
> > > interfering with TDX module sept lock? Is that the only issue with a design that
> > > would allows failure of demote in the fault path?
> > The concern to support split in the fault path is mainly to avoid unnecesssary
> > split, e.g., when two vCPUs try to accept at different levels.
> 
> We are just talking about keeping rare TDs functional here, right? Two cases
> are:
>  - TDs using PAGE.RELEASE
This is for future linux TDs, right?

>  - TDs using pending #VEs and accepting memory in strange patterns
> 
> Not maintaining huge pages there seems totally acceptable. How I look at this
> whole thing is that it just an optimization, not a feature. Every aspect has a
> complexity/performance tradeoff that we need to make a sensible decision on.
> Maintaining huge page mappings in every possible case is not the goal.
So, can I interpret your preference as follows?
For now,
- Do not support huge pages on non-linux TDs.
- Do not support page splitting in fault path.

> > 
> > Besides that we need to introduce 3 locks inside TDX:
> > rwlock_t sept_lock, spinlock_t no_vcpu_enter_lock, spinlock_t track_lock.
> 
> Huh?
In the base series, no_vcpu_enter_lock and track_lock are saved by holding the
write kvm->mmu_lock.

> 
> > 
> > To ensure the success of unzap (to restore the state), kicking of vCPUs in the
> > fault path is required, which is not ideal. But with the introduced lock and the
> > proposed TDX modules's change to tdg_mem_page_accept() (as in the next comment),
> > the chance to invoke unzap is very low.
> 
> Yes, it's probably not safe to expect the exact same demote call chain again.
> The fault path could maybe learn to recover from the blocked state?
Do you mean you want to introduce a blocked state in the mirror page table?
I don't like it for its complexity.

Do you think we can try to ask for tdh_mem_page_demote() not to use
tdh_mem_range_block() and tdh_mem_range_unblock(). Looks it's anyway required
for TDX connect.

If that's true, the tdh_mem_range_{un}block()/tdh_mem_track() can be avoided in
the fault path.

> > 
> > > Let's keep in mind that we could ask for TDX module changes to enable this path.
> > We may need TDX module's change to let tdg_mem_page_accept() not to take lock on
> > an non-ACCEPTable entry to avoid contention with guest and the potential error
> > TDX_HOST_PRIORITY_BUSY_TIMEOUT.
> 
> Part of that is already in the works (accepting not-present entries). It seems
> reasonable. But also, what about looking at having the TDX module do the full
> demote operation internally. The track part obviously happens outside of the TDX
> module, but maybe the whole thing could be simplified.
> 
> > 
> > > I think we could probably get away with ignoring TDG.MEM.PAGE.RELEASE if we had
> > > a plan to fix it up with TDX module changes. And if the ultimate root cause of
> > > the complication is avoiding zero-step (sept lock), we should fix that instead
> > > of design around it further.
> > Ok.
> > 
> > > > 
> 
> I'll respond to the error code half of this mail separately.

