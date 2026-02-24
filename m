Return-Path: <kvm+bounces-71576-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBR7INoNnWnLMgQAu9opvQ
	(envelope-from <kvm+bounces-71576-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:32:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF1018107A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2ACE530FF91E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D48E26056C;
	Tue, 24 Feb 2026 02:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STx3vaHQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A7681724;
	Tue, 24 Feb 2026 02:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771900339; cv=fail; b=KcXU3cLehXB7ERSful5QKbnnL8flLMaufNqyEUtyb5boSf8njmzXJBRWFhySf527TiKPr+7ENdFRnZjASs0/FA2fjjnVH8M6h5mByfPc45EAk4+V3IpZOqpyNHwCiABzM52dD+3rF9bbI8Ly3WNPkLc85+OCZBlF2wA0ph36yZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771900339; c=relaxed/simple;
	bh=woRpXf0Cz8SHvKjIHNKRL9ktenxnKAYbMJ+uCx+QX4w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MuG+YLb3EQO1b0AJbqstPjZ3a0VVxGXhLCzQbRFhr+eLDUWD7np2DIwhwERrIgI7Nk5GpinjdmO+yjDwu5inQzuCc6TVN+tqYuUNxWjN5QeBkDLsrkQQvLErKVOB2++w/jLnrp/J1AKKj2ydGbNz+e17qKmLoJDXeSh4XZb1mxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STx3vaHQ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771900337; x=1803436337;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=woRpXf0Cz8SHvKjIHNKRL9ktenxnKAYbMJ+uCx+QX4w=;
  b=STx3vaHQ3BFj8HzUwkyqSBORoFQqTOQEObDN30i4KUQUdHPjQBbR4cOH
   80yFjv7wMEhLYbMg8S9p/2e+OYfBt7D/JVCwbxD57k8larVTtx0HLfmxx
   7PNzPl5R+cNLiZwgSkvIsXg0TNUNDawsC/jUxinJREVRpqLfokI7606HK
   Zee66yz3mFraysbggUlhKJJlAvQb/OrE2ZNW0DsZARL1j9lMf37rIzfQA
   FXlVAf4G6XBOaJxRHDjDrzli5atXQxYQTLj3AFycW8yzZiZgTr/Ch6guI
   ZC/UsM63K8HzOp6boNRUAT9yxAu2bIkZwsoR2Yu2N2dvGpV3sGvry5c2f
   w==;
X-CSE-ConnectionGUID: V64SYyqwRpW9XvYK2k8xig==
X-CSE-MsgGUID: aPAZRBvSTISf2sf9rAmDRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72949274"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="72949274"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 18:32:16 -0800
X-CSE-ConnectionGUID: 87+tuL+iSfyzu3JviCN2/g==
X-CSE-MsgGUID: gW+VIP6cSh+LIG3T+2adeA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 18:32:16 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 18:32:15 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 18:32:15 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 18:32:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tgHzblziNP9eXIRfFKP7QJ5Ru29RJ7iv4E+C53myCcgwV6Pmy+jJ155g5zzPsbQRXwzG5ZtjGgNj/wxVRIHFREUiKCph9EiZCA9v4v9XLA4JlwqFVNZh1C0eLcF1vckuhFUFvwndSAkXly7ogkYrrmJyq0xNMS3zINi7Cr7LMy0k1PFkEdoWrydwFkwPKnJG1UWvGEgDeuRZ2CGc6nKM+iAuBSjCTZc4cjwvrzDeaQuk2nSXDIUO42KsxAj2j2DLa4VsW6MqizfWtubTpP+EtxEVzEA0kl7i/T2tyrUdww0AAU8vKktu9+2KrKgiZfs1D51JwxQAqCtY95O2Md20Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3CqpHK+KvHYrxrvNSY60i6PMsa3vkVSyoz2Sjn9rYE=;
 b=LXN2h6kiUd0op1nHAr2VCvR6HcQja6pWQn9iR0remDVHyh+HQikkbQP1VJdRtCcm410baonrj2zh0m5rn4RBcuypcEjmUDrmTzqJyVSKUp5GudjhuyP4Gz1y7vlVVAElgWeNJvtWo839TCgasuudSoDp9mL9sVE6dj7Xmy6zeVr2/NDn5lrlzfT129mfSVVERNgFHQeSYHbFqiOhKVlMRzuJczGUiz1dWuzknNiIWTIuc6Y5M+7P47o3KMe4pO7SbCNf/VEf8MXZ3jt4bhy0HPxQ+XZKLrDo60VrhXiU+JQb8w/5ftLLaojk0nHM+kYjk2lZshM72oDa95D63uPOqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7682.namprd11.prod.outlook.com (2603:10b6:8:dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 02:32:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 02:32:12 +0000
Date: Tue, 24 Feb 2026 10:31:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Chen,
 Farrah" <farrah.chen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aZ0Nnay7ygKeXmuC@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-5-chao.gao@intel.com>
 <2683dff7a7950c57aa7a73584d86cf1b34bcfc07.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2683dff7a7950c57aa7a73584d86cf1b34bcfc07.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0005.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: 458f6917-c679-4d92-2bcd-08de734cea8e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?pS0GgwngtHvjQD9UhYXD6LdoDfqvPevJb+nY1to4B/7TgD/w8uXN5ZyDrW?=
 =?iso-8859-1?Q?MhC9llencwpQpGBK7Q7MiqtXbZRSYWmLX+B8B9+XFc+ZqVk6DDDM8NNwfB?=
 =?iso-8859-1?Q?zmKBhLUkQ5zwd0fbtVxEhEe3C0dAnCjTIbxMJnLLtB6plZnKHTv+MN/Tva?=
 =?iso-8859-1?Q?Bntzl4posS/uI4RGDnS3kc0CogCuJe1mBeqdYmGdAPnHcthbuFX1TvvRMW?=
 =?iso-8859-1?Q?aJbGPLXTRlLNwSJN199OL28AaMzog0qYPRlreRTyve4qdWG/yGYjVwrZDK?=
 =?iso-8859-1?Q?BwzstTLwI+N7pUATY6LehCbp/4n/hm3zmRpgE8w+6f6H9Q22EHy3Vmy35z?=
 =?iso-8859-1?Q?H9YB1SpcqiqYKMK46cyvwUroDYm9DDLV+rsWnjook1U0t6sIn6Uxas/nXB?=
 =?iso-8859-1?Q?QALLQC35mxL9xD79TaWZQlsL9t6S6anX6qInoVjOm7G0UXAbrF1+s2rOKK?=
 =?iso-8859-1?Q?7YHwtNUb9h8szTw62UjRxatyhw4/CxlhLSQwB1DZ2Z0zpqzoWIlEHsp3rn?=
 =?iso-8859-1?Q?Aaib01mmZppgmjxjn2FW9EKrWogfOq3agU/ICxis6neYpPvwxuJW74tvIg?=
 =?iso-8859-1?Q?mvaxv7GX94JyjyA/56IOBFqFFLYsYm7AqN06pJi0QytdbhPNlr1qMch1BM?=
 =?iso-8859-1?Q?esaRTtQdiETuNsN09Ei1lmRvPNvFbvkRyssfYZGRXdirzwsw17uLToAUPV?=
 =?iso-8859-1?Q?5owiNqBfg5ZnAWugLdn2tddTI8rs2VmXVFmMWNfpny1pGqmRpRfpERtG5z?=
 =?iso-8859-1?Q?XaGm/4FLNcR2rjWsmY9O1y4QU+pFgGsH2MqBRzI0LLLlnLRE4nD+0ObUhH?=
 =?iso-8859-1?Q?Ifpe7AYYis0Y1wFqvTUt40BboNGJGGrwQYbf9YXr2iUUgLRJDOZqQ/Db35?=
 =?iso-8859-1?Q?dLbMwleN+2W7vvqEiSJYZiHPMSEHwf/b+gOjp+4Lcz+u40W/2rvfU0GzFr?=
 =?iso-8859-1?Q?eIiZCaMsYsGY/aXtiG8roW2Um7aOzWFLoNLmXwI43+prhcaxWoBsxUy3Nk?=
 =?iso-8859-1?Q?bJB0vJ300UO0OptjcuZeH/bsG7Ap4vXRcrZu/kP9+ON0DZJGYAgKcg3JtP?=
 =?iso-8859-1?Q?binC46gQs8cAjgUp7lcwUy94qPDbkErn6B07UaiNe8Np+ml9Olxj1bgUeQ?=
 =?iso-8859-1?Q?YGVzr3ulfSYZTivVDIX7bxQn+Fpcvel9jlPt8xgoqBU4OvuKyqh8vki6zU?=
 =?iso-8859-1?Q?TXnDLexIgfiKkrB5HX7gIVPZWPj/OdsTr6V6bhkbzjgchtNS0+P3m6hSry?=
 =?iso-8859-1?Q?Wou5F3EGSTZjIkH8AII/j0PRFnDiYat3ZyHt9uMpN3eW73kZ3PttYNmz2/?=
 =?iso-8859-1?Q?F8HWD4RfplCgY2sIIJjTVmzvlwXCu/RLO5FSn3PpL+DnOVjIHVtD/YnwsV?=
 =?iso-8859-1?Q?a1psXU/B2ORDYNH9x4ps4rB/iZWkXT6y+VEsSRep8xRWSBcNfUhL8WQj7m?=
 =?iso-8859-1?Q?h+QtL1OtWzqPhmOJ1q97SHXfYJbsDleTB+MofuRSBzRHGOzC+k2umvZmkV?=
 =?iso-8859-1?Q?SG8tgV4/mGydHHY++eqFeosv49SiPfSdPMc+Za2zTnvheRECBW9wPxKFrc?=
 =?iso-8859-1?Q?MmkfrFZiMfgztjuyl+hFA40d+cQnPqAPRZjt0wayLr8lb48+pdDIzFwnNA?=
 =?iso-8859-1?Q?3D9ZdKJx+zIxZFDE76GLu+XFXDrg4k7Ilm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?zmUPfQMEw3P6u+8HeVuLY3DvJUbDgr1DfTxorQbCMoef6XlUCSM62DNQTx?=
 =?iso-8859-1?Q?5gRqmtZF3AQl8n2tv3tEgHd7LH88MS537op4JsImGd4ZJINY3AVpQPmVRE?=
 =?iso-8859-1?Q?2Oed2nPjn6ixxcLdsjgbQa7TDIfSha6yMDYEry59JFE2uSP3LodLj5L/WW?=
 =?iso-8859-1?Q?Ph0cRrreFlOT9srCvjA4jZH7Hm6BisCu6gfHfn8UGuwhy9ysRRlKM2ZPzv?=
 =?iso-8859-1?Q?rtHsQuVVWhqS/y7fZi3klyKYtkmfxAWYHaZ7owudROgHWZ2KoD6Jn0O9I6?=
 =?iso-8859-1?Q?btruC4mucnjV58vsC8kJ+dpVoICCRMVxgTzfFWiBEryxyyyeyuATVRzpaT?=
 =?iso-8859-1?Q?ZzkC1H/EghWkJEPCDqKUnrxrpIqOQ6EftTOQkJDYvbfvpv4pzncRTPHsMU?=
 =?iso-8859-1?Q?8zcNbVHQoTTs0YJ5WWU+aXJQXS290aK29ueJHN6bkzBR7YQpB4aMpgBF2B?=
 =?iso-8859-1?Q?6yJ9/hSeoa+2wY3RvDzuBGHByRKK7GzucTVHO9yCZpiA7eKCeDbvgrtiYu?=
 =?iso-8859-1?Q?wmzS3bh/ImEWyBnhKZzrhg3yS+akkCx77jSb5Ck4rlavEq8UriVa/+3+4N?=
 =?iso-8859-1?Q?AV4qzGSYqavJNcHM4Xir87QgCuX1eBKGWqR5VfvZHcJbcsfTMTuRFAr61I?=
 =?iso-8859-1?Q?d2WxEb4dWCFhZgalgaguQxaiTz8EriuEnJPHJtpYxixtha5yWPSP6qxrnX?=
 =?iso-8859-1?Q?TVvgFS5pdTitAd3s1mWe6G1l6ApSRvm7eQJ/HtNGgiuL9MJfOJOiV09RwY?=
 =?iso-8859-1?Q?+ckxNgvWHlQnwx8+Co48cvbEgDh4uTfoWBX7IanE2bzt+sCFz9YDrvnXor?=
 =?iso-8859-1?Q?T5HYtpOrcSaXxxrnN+Y9lHNi1KPnKonOEovQrFG/sIOc7/U+cmnq6M+djW?=
 =?iso-8859-1?Q?OlZa0X6ZK6nUDZpyUv8aJyxLYGATfkllYqs6nyR96VlHxzMFhdnMswUOA2?=
 =?iso-8859-1?Q?SkKrKCYrNScWx4Ck2Xq6c+tRfPv89bUh2tgi4ANBhNkHutBSOW0qsd8lza?=
 =?iso-8859-1?Q?MoW8h4Gz1vCjC2NL2la/ij1qDzuQ20qGRjVaom5hrrmRcnOX/Tbd5hiT5Q?=
 =?iso-8859-1?Q?BHSxxZcwBUiBXz1QfwnM7eDAQxFSPpDXBQuSEnrMkMn3BjFnCrjCP7tWjH?=
 =?iso-8859-1?Q?wZwkK4F+HM/yCTdkBl76mYicqPyawRYOtNyY209yk+xmujljugRa9t+TP4?=
 =?iso-8859-1?Q?iZBQsiJMBgX4IgtnsjqzbHuw4I88IAuKnKlieA+CPADoVt6u+ndDtShCoa?=
 =?iso-8859-1?Q?EidmrzEPytoGR5mwfOmUA6R1tePe5e9TkNul1LsvImW/xwOCzG8DalVRFu?=
 =?iso-8859-1?Q?YlSgsKAniMUV1+akweIBmyCRIqVwOJXe9k9Rk1px7O7fFru9fpamVpz4lS?=
 =?iso-8859-1?Q?8xuGBXMM6zoCK0ZsGXGFWagcC2TxKFIyHyTS+GRqLdmsr1bQNTtY6pXwDH?=
 =?iso-8859-1?Q?tnaGNE94upnMmmRBAciDeZXvan7NlCOBRGCUGIyryI07TF/rAqSEN9qA2d?=
 =?iso-8859-1?Q?H9M86g7WmTSTHViam/SXcdL3HlBGDwwltOwEy7gYUDJnNsgQ16swmjKlGG?=
 =?iso-8859-1?Q?GZDWcd0fyK194fE9ANbSPFDgGiC91iCBwm3mRZfgxXx8YJRpI0+txvsm7r?=
 =?iso-8859-1?Q?1RM7gz7aEBwHHVd/4uBvky2QoxvuAxgSP3ay7jqp2UX0Xv1Xv8E3jFt8jE?=
 =?iso-8859-1?Q?zl4ry7aGiyfYSghsCJ0/L6Ef1pQfMNYow2FfLmEZ+ea/LRntPqgqr1o1v+?=
 =?iso-8859-1?Q?wfTD8TlsypklPk/YY4h16ILLWKcDU0akYrcA14gzhzEIWgaHdrKEZSCsjB?=
 =?iso-8859-1?Q?FJrhq6HDTQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 458f6917-c679-4d92-2bcd-08de734cea8e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 02:32:12.4808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/4PGg9kk+lE0QwiwMcxlasR8UErsGl/6cli804zH5+ooyFLqrnsMINM/F1bke+dXMeGovxi1y601e7B1bzp2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7682
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71576-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:url,intel.com:email];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: CFF1018107A
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 09:12:29AM +0800, Huang, Kai wrote:
>On Thu, 2026-02-12 at 06:35 -0800, Chao Gao wrote:
>> The TDX architecture uses the "SEAMCALL" instruction to communicate with
>> SEAM mode software. Right now, the only SEAM mode software that the kernel
>> communicates with is the TDX module. But, there is actually another
>> component that runs in SEAM mode but it is separate from the TDX module:
>> the persistent SEAM loader or "P-SEAMLDR". Right now, the only component
>> that communicates with it is the BIOS which loads the TDX module itself at
>> boot. But, to support updating the TDX module, the kernel now needs to be
>> able to talk to it.
>> 
>> P-SEAMLDR SEAMCALLs differ from TDX Module SEAMCALLs in areas such as
>> concurrency requirements. Add a P-SEAMLDR wrapper to handle these
>> differences and prepare for implementing concrete functions.
>> 
>> Note that unlike P-SEAMLDR, there is also a non-persistent SEAM loader
>> ("NP-SEAMLDR"). This is an authenticated code module (ACM) that is not
>> callable at runtime. Only BIOS launches it to load P-SEAMLDR at boot;
>
>[...]
>
>> the kernel does not interact with it.
>
>Nit:
>
>Again, to me this only describes what does the kernel do today.  It doesn't
>describe what the kernel needs to do for runtime updating.
>
>Maybe it can just be something like:
>
>  The kernel does not need to interact with it for runtime update.

I am fine with this. Will do.

>
>But I don't know why do you even need to talk about NP-SEAMLDR.

I included this because Dave had some confusion about NP-SEAMLDR [1], so I
wanted to clarify it.

[1]: https://lore.kernel.org/kvm/aXt0+lRvpvf5knKP@intel.com/

And, since NP-SEAMLDR and P-SEAMLDR have similar names, I thought it would be
helpful to clarify the difference. This follows Dave's earlier suggestion to
explain SEAM_INFO and SEAM_SEAMINFO SEAMCALLs for clarity [2].

[2]: https://lore.kernel.org/kvm/b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com/

>
>> 
>> For details of P-SEAMLDR SEAMCALLs, see Intel® Trust Domain CPU
>> Architectural Extensions, Revision 343754-002, Chapter 2.3 "INSTRUCTION
>> SET REFERENCE".
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Farrah Chen <farrah.chen@intel.com>
>> Link: https://cdrdv2.intel.com/v1/dl/getContent/733582 # [1]
>> 
>
>[...]
>
>> + * Serialize P-SEAMLDR calls since the hardware only allows a single CPU to
>> + * interact with P-SEAMLDR simultaneously.
>> + */
>> +static DEFINE_RAW_SPINLOCK(seamldr_lock);
>> +
>> +static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
>> +{
>> +	/*
>> +	 * Serialize P-SEAMLDR calls and disable interrupts as the calls
>> +	 * can be made from IRQ context.
>> +	 */
>> +	guard(raw_spinlock_irqsave)(&seamldr_lock);
>
>Why do you need to disable IRQ?  A plain raw_spinlock should work with both
>cases where seamldr_call() is called from IRQ disabled context and normal
>task context? 

No, that's not safe. Without _irqsave, a deadlock can occur if an interrupt
fires while a task context already holds the lock, and the interrupt handler
also tries to acquire the same lock.

>
>> +	return seamcall_prerr(fn, args);
>> +}

