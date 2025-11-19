Return-Path: <kvm+bounces-63675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 126EDC6CF26
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D70E54F105C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D3A315D24;
	Wed, 19 Nov 2025 06:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OAx0Y9Dx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5632EC097;
	Wed, 19 Nov 2025 06:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763533932; cv=fail; b=Cii+CaU1/wwtWP83iR/HFhWqsTZnFr6zUOKpm4g4NvLAWFbx6iuZwsf3gBcebi9IVut0g0+3VxZ1ClETBnuN7aKFP2ARpGNlCd3QqGe+Qx8LbeHvQc3WjkYGBoP/VaIDehlTMAWbuKE3Lm09uqiVEVHznWA70Cbu0/UD/oY1WrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763533932; c=relaxed/simple;
	bh=xJi0gzdw7sdLu3LNX0YSj1NGWdoVDJ/h5lk26cXKZp8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kq9AarBKTlRUXVk/BylvYNWX2fWF9A6vDoMrGy7wwCBWjeVRS4U80xfIWvoukmajzSBblGKmKC/Ol0M9iOegy4k3iyagfuB525O4ORYrMx9GmkpdZI3PHVtYTwbDrn/I0vDMyw1BbZ9vezagCY7YJ7OKDvzxdjfs98vM0Doo5GI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OAx0Y9Dx; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763533930; x=1795069930;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xJi0gzdw7sdLu3LNX0YSj1NGWdoVDJ/h5lk26cXKZp8=;
  b=OAx0Y9Dxd3pQnlr3b0FM7QSI+VOekQ6dIok4wH9U3IK0/0TQSITNEd01
   AcaBi6CuzjeZrBVTbJ7Ona8dadvEZVu+qrUDcgW0dXgfbdpDhxTIhXJyV
   /2idxdJy6R7eymxwYvABpgYRiw4eXpBtU/B98X0ym9trGCzL/KK7aEmks
   YBFDsPdP4aItfCZKQB0iZHpg6L3tVplI1trGFN1L0I1M2YdIW8PftRiGP
   GPHAa44wj/nBmlNmT6/2Ef9NisEd+tJwz343GDypYBivy1eN62krEo0Hz
   4BvIrqECQvDla3xk5A6R3bKO2Hw6pIHp7gNxrjodsMDP6k12zLGWxytqi
   g==;
X-CSE-ConnectionGUID: IxT8inqkQCagic/fDIHq6A==
X-CSE-MsgGUID: sGUaZyk8QV6pXd4qsA0iuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="88220739"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="88220739"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:32:09 -0800
X-CSE-ConnectionGUID: aFYA7rDrQM2yZpKv1VwCNw==
X-CSE-MsgGUID: pdqMOBW1SFmK5UQWmaxD9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190234025"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:31:42 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:31:41 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 22:31:41 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.25) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:31:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSNRUeAsDkeQdqeHaFTeS18AjHbcqaw6cCPmPUhdLdHWI03YuAIOibPk60y51HROLlydOnZcECtoUYNxudCOlx5KLb/H+u75Gyktz+jdRIi0Nq684UH2QuZsiJSqmQfw2XNZlO9wID/eZQzh80yoniInqHHI5SAG6wakkeWLZYaP9g7i+Z7i9OKPIkeKfDJtP0Z0MdSkyPytCJKjvyhr3OOMGu/EEEl8omrq5jMPJMxHg9noaiqHJXUH0DCd4Y9kUE6a4qHDSCocW/CZ6nUYIimCS5sELA5OMDgCqphEIHDyMNv9e0s8xYcrpBa9ED0eeBp/HlDzzmY8gnqWtZhL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISJN13EGCXt2TkR2tHNH+Cc6ExzGbJcwwbGcj70yt/I=;
 b=L6iXQK4g03Pc/BuBz4Vn+e4rP76u0t8eZGzBmtyhUam3p4qvnWmmmb6V1P0q2AumWkG+rfMw403FG2ZIxHVkI8jG/ZWfxEkC3Jq8M6vTozXOTAx+qm5lLF4rN+PZcv3KBAudb65yqP9n+KnwyGIoA999CAed1R82EzXrrJwY9LyeuujtbtDreZ8DoHo6bbb+xZl8gqaIdO0v9rGAcgOnYIYjH2MbKwXl2FefQZFVD1Z/+zx5UzQ1iPKLvVYW7ig6XznPAQgox0wQ5SH1WNHefQB4G2Rah8aCFgKrPUyHXQJz2q3rBW9nTWNJVEu1owc7vq82McmHMHuxlPVknAcdmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB8853.namprd11.prod.outlook.com (2603:10b6:8:255::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Wed, 19 Nov 2025 06:31:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Wed, 19 Nov 2025
 06:31:38 +0000
Date: Wed, 19 Nov 2025 14:29:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aR1j5SlA/YlOL8zo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <141fd258-e561-4646-8d86-280b14e7ca32@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <141fd258-e561-4646-8d86-280b14e7ca32@linux.intel.com>
X-ClientProxiedBy: KUZPR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:d10:31::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b4f3d9c-98ba-4a45-d0d6-08de27354b80
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?56E78g8qzgL/axMfdQyfr1idcdxZ6xAvFSc/9pvmqfAHHwM34V1w8O547D?=
 =?iso-8859-1?Q?N+azkYVvgm3jAldDVyAcpUdYs665g7IEjXb4eOHrvSl12aszLqqsiCg4em?=
 =?iso-8859-1?Q?xAAXi6HmP/mubUGqlzw3u46yM42wOOr7JAjvy3ZXFCrFvPxiY9lTxOg552?=
 =?iso-8859-1?Q?74wAPSjaU6Gj1cMVEgYXpJ+cfhIr4YGObz/Li0ALlFhjb/s2ArXKKH6G0w?=
 =?iso-8859-1?Q?RR2HIOCjw5OWGq+io0MGzM0IsM1MNc6mtI8claXA2hw4450WnIgYVF5H72?=
 =?iso-8859-1?Q?7si92AC/pdPZ7w8UihhKEa9Jrk17DPrPw3DFGdq5KDk/p5NyR62IRJV8vf?=
 =?iso-8859-1?Q?DI9UaQML3LZ9l2+4ty3vLnVnzkrIJddq9Ts1lukw5zhcb2NJBuSA3t0AUY?=
 =?iso-8859-1?Q?f6YJ1z+NXIND24A/f8Ai8nXG+FPJ6JbiUbT86rni2rEUNLc3pY+3tpsmwT?=
 =?iso-8859-1?Q?cMNH9iu0PT7/eFmpOYKpcvnKKKOj8jnkorq8FCXcP0cW8lsFURruzy2Son?=
 =?iso-8859-1?Q?8oOh3FZ4Zw0jakWKLbJ+g0pT9wmPMik5bMAtYBckJN7o8tfoE25rlu3vpP?=
 =?iso-8859-1?Q?wrf1rgLynCHZrATsqsK0BuleldUNALqEWtbRAcqe3zSJBOLgFhmbdb2vZ9?=
 =?iso-8859-1?Q?fjz0glNK693T/81jNrWPd4DprjBG6c0uOmViGtSi02HqB1rilD7jeJLmdg?=
 =?iso-8859-1?Q?//hBiH7RnNgQzqimKn5svW94R7e12EqFHTVE2/XiFtzv5pcbyONu1yoVTf?=
 =?iso-8859-1?Q?QGMf1w6nyLSXnoTLc9OdOEGbh0qCPAUQXFbRqG8sVwYpdW4+CLQq9BK+jI?=
 =?iso-8859-1?Q?Gdx3+3V+aQjMsuGW50wxi3irnclOJR+ZsJLsrkhKHZJ76NbBm9A7Kjhv/W?=
 =?iso-8859-1?Q?RJhYTFSwvzgSouewu02zgfKzJ7OSfdcMhn68snmjdDpppXpapkJp8wE0xr?=
 =?iso-8859-1?Q?uNOpO1gUcqjGVlpFe44sDl7FF8U3NYfcza53pIRtTuwGRDelaOzSyc7zwA?=
 =?iso-8859-1?Q?rgM/RBLai2pH05renpaQRq/0Tzg9RmJdQmiaovC8JB4+MeZ6aKiXyWAOs3?=
 =?iso-8859-1?Q?IfPVHsv6R2+Q6HVIpsdz85d0aBNHV5RZdIoY55F3hCgswZXco81wsdb+y8?=
 =?iso-8859-1?Q?IK+qyzMYO8QzcWUIlhkr4SAERfeAOpPwSfgNlNcmVEA68gNtbEjyoIh1Fw?=
 =?iso-8859-1?Q?v8VxmmKNfE61nRU6M0aCyL+LqqSi7mzM9fxT37UT6z1FRYw2RoiWKwgEga?=
 =?iso-8859-1?Q?pRZJrav00HSf2zcXggx7XnAzYpuZme9+tSfepF+eF8X/O5WNCAW9x2trGN?=
 =?iso-8859-1?Q?JAsmIeHJbrYgRdXc+desBoOAUaLmaeLCxb0OTJg+tTfFetPGOYQSPLEoM0?=
 =?iso-8859-1?Q?VT1WpVLgxvee8DVMB3h9jMty7TW5W90vMjyDJBUaQQWexrMN9w0oE33udj?=
 =?iso-8859-1?Q?cD2USreMwDM9jv3jhsbGrWl6R9zkYvBBXVnQWebALJb+xFSTxbC2d4kA1s?=
 =?iso-8859-1?Q?xRRIYsniyb5vBLkwIL6MTJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?CWfS7xdpraUg2wMpbG1L3ALix/BnVaY61VvS/fRPkOoVTxBK9eOCnOjTiS?=
 =?iso-8859-1?Q?Mpw66gALRQuMX//56ceGnhfGlOXEW8eksaprm5WMqCx9ffTrf5sUxujwlb?=
 =?iso-8859-1?Q?ZGUlrKMuiYUUKcIGEiTV6ZypX/g52zpmoEw17eWH6P/4qgq24rwGUbFyct?=
 =?iso-8859-1?Q?NsmBY0a/IMqpX9KfyEzoO1E25ODP4VwU0HK7xT7JkabesiXQYXEOSk9YrZ?=
 =?iso-8859-1?Q?tViN5yBSVnkjPp3g37adb7UJkW4Gk+X6SdqRxng1xatK69mRx27/me57LS?=
 =?iso-8859-1?Q?PPsQ9TJLrU5DLl7ULj9PBMRXLfh7FgAa4QVI8zWeeIvbsuuCdaxFmGUCHQ?=
 =?iso-8859-1?Q?vwa00qA5btiXtvaxFuIYgoOeEeCIhhW3kwtfdJA8raIvKg9Pg4kI14rE4b?=
 =?iso-8859-1?Q?4HEsXLPo3mi+bMq2I4sYAfrEdQswZgHCz47CjLXA1wrgIj4CyAy43VS2+I?=
 =?iso-8859-1?Q?8Du3xgRY2xfJCAYDqnq0/jeVngDIrtT4XxNgAcRL5QckhLWG/cT7/L7Ope?=
 =?iso-8859-1?Q?ntRHdONx7tiAdeTJnoX5eQtWX2HY6phqTWZinZXIacvUji7kW69aDzo1Su?=
 =?iso-8859-1?Q?X9/VjZNcEC5i6yt5xx44JWY8e0qmooDZEoHGh/aA+sjGd0pK2nj1XOUA5L?=
 =?iso-8859-1?Q?NYtvv38K/atdDYFiQNtTZ+dSBeWEw1HhPYzJ3gZxNkP/BV+m7mhAV5rgtb?=
 =?iso-8859-1?Q?IfOJ5/FnGc+mvLJzPmMEvzh6O5EqV2+TGtdGYO8DBTfttGv27j+Fk/r1ez?=
 =?iso-8859-1?Q?ojAPdeo+Y6OwmwwT9ckDsZ3u+8LrjgphZXX68qIAX2ujpLOK8w4ly/So7V?=
 =?iso-8859-1?Q?/XybjnCd/KsSkx1Jfc625K3vkFty5lgsVvq6w2f9Z+ui1dzzBdswqNIVgM?=
 =?iso-8859-1?Q?B8f8sFB1SxMU2MmhzzssffTtXC1h7iol4memklK5jvon6vF6Zol9av46Xi?=
 =?iso-8859-1?Q?IsK5LkwvxsqtaXKBLwbj3gcXWuDgHJXvetD/OWJjIkJjKa+DqM3FwZ5gJ/?=
 =?iso-8859-1?Q?vQybYlT+kcgOoX3C7q7x2+WkoRmefCEOHuHyg7HWPxxJ2kX5D6R55VUtHj?=
 =?iso-8859-1?Q?GYHL4+HTfEs64YoOpqnFbtqVNkw/kVdr8S8zq7zFtDpIDGD09N60AhMXcN?=
 =?iso-8859-1?Q?ysxJMRs4z1wsK7UFZdJfIn58AQLn6h1NcZG2wJ3fEkhzXB5GPmnpGWe0T7?=
 =?iso-8859-1?Q?Tqhdk3FjN0BKnKYvv3hlwQREEWkpitE5p/6BR55GlpLzRSi2rUt/J/FN7W?=
 =?iso-8859-1?Q?aQh2Vb0A6nj0VZvgt7P8o0ryWfJpgZ7luuc0xKjMSWU1lHJkrcx8X7IjDa?=
 =?iso-8859-1?Q?SRmwrxwknsMZ56IvhXmW0OlHq+PBc0o9bdSbhH5jGS5Rh/P8VugoK9FdgN?=
 =?iso-8859-1?Q?xYGJR1WenginXTRItUnCgjjsGGiEttocTELa5bmFdBAtjpS6TpzQ4D3quQ?=
 =?iso-8859-1?Q?1OI0/UAAqV7as/ve7SU72PAuA9P1GumtEHa14e8XvHGr9j6HJER3xYZDm6?=
 =?iso-8859-1?Q?wWSIlc9JTXuAKp9GdJ6y9D9HHPORosHKaHU74MsvdWY2ZZYZw8u0oj53y+?=
 =?iso-8859-1?Q?ciFnC2IKHBWI1Y1Uq75+j1BM94s0nTrkAUV6HnKGYDKrjMtC7MoudktYVo?=
 =?iso-8859-1?Q?J/mDD3ytbxfN3bw25Rt+eTPKRHjjgCq32w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4f3d9c-98ba-4a45-d0d6-08de27354b80
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 06:31:38.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+6ahueg45/iWaYhKZLLkOtjLbIkKJGjA+s5Ed3OlHSMIw/Pi+DTK8+9XzlQZT+dLdbXubP3a9UsZxsqFoBmqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8853
X-OriginatorOrg: intel.com

On Wed, Nov 19, 2025 at 01:51:26PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:44 PM, Yan Zhao wrote:
> > TDX requires guests to accept S-EPT mappings created by the host KVM. Due
> > to the current implementation of the TDX module, if a guest accepts a GFN
> > at a lower level after KVM maps it at a higher level, the TDX module will
> > emulate an EPT violation VMExit to KVM instead of returning a size mismatch
> > error to the guest. If KVM fails to perform page splitting in the VMExit
> > handler, the guest's accept operation will be triggered again upon
> > re-entering the guest, causing a repeated EPT violation VMExit.
> > 
> > The TDX module thus enables the EPT violation VMExit to carry the guest's
> > accept level when the VMExit is caused by the guest's accept operation.
> > 
> > Therefore, in TDX's EPT violation handler
> > (1) Set the guest inhibit bit in the lpage info to prevent KVM MMU core
> >      from mapping at a higher a level than the guest's accept level.
>                              ^
>                             an extra 'a'
Thanks.

> > 
> > (2) Split any existing huge mapping at the fault GFN to avoid unsupported
> >      splitting under the shared mmu_lock by TDX.
> > 
> > Use write mmu_lock to pretect (1) and (2) for now. If future KVM TDX can
> 
> pretect -> protect
Thanks.

> > perform the actual splitting under shared mmu_lock with enhanced TDX
> > modules, (1) is possible to be called under shared mmu_lock, and (2) would
> > become unnecessary.
> > 
> > As an optimization, this patch calls hugepage_test_guest_inhibit() without
> > holding the mmu_lock to reduce the frequency of acquiring the write
> > mmu_lock. The write mmu_lock is thus only acquired if the guest inhibit bit
> > is not already set. This is safe because the guest inhibit bit is set in a
> > one-way manner while the splitting under the write mmu_lock is performed
> > before setting the guest inhibit bit.
> > 
> > Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
> > Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2
> > - Change tdx_get_accept_level() to tdx_check_accept_level().
> > - Invoke kvm_split_cross_boundary_leafs() and hugepage_set_guest_inhibit()
> >    to change KVM mapping level in a global way according to guest accept
> >    level. (Rick, Sean).
> > 
> > RFC v1:
> > - Introduce tdx_get_accept_level() to get guest accept level.
> > - Use tdx->violation_request_level and tdx->violation_gfn* to pass guest
> >    accept level to tdx_gmem_private_max_mapping_level() to detemine KVM
> >    mapping level.
> > ---
> >   arch/x86/kvm/vmx/tdx.c      | 50 +++++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx_arch.h |  3 +++
> >   2 files changed, 53 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 035d81275be4..71115058e5e6 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2019,6 +2019,53 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
> >   	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
> >   }
> > +static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)
> 
> The function name sounds like it is just doing check, but it may split a
> hugepage on mismatch.
> 
> How about tdx_enforce_accept_level_mapping() or something else to reflect
> the change could be make?
What about tdx_honor_guest_accept_level()?


> > +{
> > +	struct kvm_memory_slot *slot = gfn_to_memslot(vcpu->kvm, gfn);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	struct kvm *kvm = vcpu->kvm;
> > +	u64 eeq_type, eeq_info;
> > +	int level = -1;
> > +
> > +	if (!slot)
> > +		return 0;
> > +
> > +	eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
> > +	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
> > +		return 0;
> > +
> > +	eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> > +		   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> > +
> > +	level = (eeq_info & GENMASK(2, 0)) + 1;
> > +
> > +	if (level == PG_LEVEL_4K || level == PG_LEVEL_2M) {
> > +		if (!hugepage_test_guest_inhibit(slot, gfn, level + 1)) {
> > +			gfn_t base_gfn = gfn_round_for_level(gfn, level);
> > +			struct kvm_gfn_range gfn_range = {
> > +				.start = base_gfn,
> > +				.end = base_gfn + KVM_PAGES_PER_HPAGE(level),
> > +				.slot = slot,
> > +				.may_block = true,
> > +				.attr_filter = KVM_FILTER_PRIVATE,
> > +			};
> > +
> > +			scoped_guard(write_lock, &kvm->mmu_lock) {
> > +				int ret;
> > +
> > +				ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
> > +				if (ret)
> > +					return ret;
> > +
> > +				hugepage_set_guest_inhibit(slot, gfn, level + 1);
> > +				if (level == PG_LEVEL_4K)
> > +					hugepage_set_guest_inhibit(slot, gfn, level + 2);
> > +			}
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> >   static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   {
> >   	unsigned long exit_qual;
> > @@ -2044,6 +2091,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   		 */
> >   		exit_qual = EPT_VIOLATION_ACC_WRITE;
> > +		if (tdx_check_accept_level(vcpu, gpa_to_gfn(gpa)))
> > +			return RET_PF_RETRY;
> > +
> >   		/* Only private GPA triggers zero-step mitigation */
> >   		local_retry = true;
> >   	} else {
> > diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> > index a30e880849e3..af006a73ee05 100644
> > --- a/arch/x86/kvm/vmx/tdx_arch.h
> > +++ b/arch/x86/kvm/vmx/tdx_arch.h
> > @@ -82,7 +82,10 @@ struct tdx_cpuid_value {
> >   #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
> >   #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
> > +#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
> >   #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
> > +#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
> > +#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
> >   /*
> >    * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> >    */
> 

