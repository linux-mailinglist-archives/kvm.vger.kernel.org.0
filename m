Return-Path: <kvm+bounces-29905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 080529B3DB4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:26:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 891641F21A6A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94B61EF0AC;
	Mon, 28 Oct 2024 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TxrGeIqc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEFF2E414;
	Mon, 28 Oct 2024 22:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730154375; cv=fail; b=dhPKbBKcmiHoZhAP2ReFwHn4bMXgv/ScuAbZp9nMVHGjVy5FwhUYg/t4m918wPR8SU8XmZqmukGaDdSHevRcH/M4r10GZNAYW9NmnG8u8e8O4eCD/PrS6Aw8doQVYkdZHUTUuMGbdIBAeY9kumzszQ7wRjAp14VLGo3LyGgsF5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730154375; c=relaxed/simple;
	bh=IJRQWCcjRdIM6BnwmRPkYEqX4ATlAnZflUxtfrFnEEA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NZCgUby74JwP7Z+oy3p9pwgjv7xJW8+pAxBMOHz/ug7lDY8GSm5kki6LaN8oGzID+OMEEFH5RYtzSqNB5uyTKQPdQYWLG8lLUN8SvScAJHMpgPfULiv8BIvuOu8d/k4dKdttjSRndJGiAKf4NUJuv8kt4AS2yYctU19EU0zo6+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TxrGeIqc; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730154373; x=1761690373;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IJRQWCcjRdIM6BnwmRPkYEqX4ATlAnZflUxtfrFnEEA=;
  b=TxrGeIqc2h5/RoEK+8SlG//SiPqOvcZgmssYM781d+sGlBQlnhBMRocI
   Xj7PMhmgSPfDT18SbJw+3vS4EW25zG/0V0FB2gVpWfs0W2wgiAwCbxAQ/
   1HhoNl7NQsYAN1WEz/a8zYnta/wNUoyCS83EpHZpR+yva2yzA2NWgNPaR
   fIpAXN6irG22pWEBnIsiqbQW2gUu8t6wp0X0tarqTmQWj9CWLBe+NYScf
   d39vFqIinwYjbBBeImMBAYVrt8jD2S1apkur72B2WPjRKMO4TFF9zDtY6
   pNFoTmqOUu6QAQUujQ3fwIIeS6VZKd3q23ys0lusz3ZHTTqFUK1+haRny
   g==;
X-CSE-ConnectionGUID: Y7biTzO9Rg2CToBgRel6TA==
X-CSE-MsgGUID: hZ/SdqoXRyuJIRI5Lj66XQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="29203700"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="29203700"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:26:12 -0700
X-CSE-ConnectionGUID: mJQBXigKRoOHyKmv5w10tA==
X-CSE-MsgGUID: bfxdi94bRE2lfhNOAUhJBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="82172416"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:26:12 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:26:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:26:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:26:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iz9u4ysdWdq6qPtNn60Kmk9Utyf9DyGphYDBU2oi1MIpMvEAPdTKnoqxTgAVkrs7NvzCA9pOyfmwtHY4/KM5FnVtSO+hwmbpCQkEkQY400oQt5+1jDdn3c0AHdpiX+VIOswb6Cr3c39g/JaOCP/x0FgP9tcTNewvISTOYhsEfHxqHXBfLsn89Ja9iO51F+yeq/F56knWiRJapEUFuZHSbcFpJ8HOPCyeVLNSIk3+cIEgaJQn+DuygHG/2lAEAE4/zbRr+HkqILlITTR0x72NqqySmZ3AxbnW0QzlqzXvcwHww1eHcNM2/NyB/2/JUElf64S/iDPzXAKyX2tfphI+bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKbWc35g92fPwFc6Bxl/aAx7SAt/ANkO+qp4M3NZkIM=;
 b=BOE/lmLnSZY9cYpHla+NPBStDAKQowl1qBnRwhsbgi/MhxKrflWHcFDMAcuH1NkgAFWpfaavVGc+UXP+b4/43Z/l9ahIudac8XcFiwoZC63frXNqS43Cqctv7PDlwzrMT9YJcWEkOUVLHwAk8HuyracTateMtX9J/2YaT3JOKn+lRGmwj/+HI4UXzWVUgkbwfLxxFzRywdawQ2K9Wuy/slQt6KqXlimi2Xh/n8K8LL4eTfRihOKzboRxu73kk7QyBMat/ctx7qtzJIiXlg9enK7Cvf4AA0Z4FS8YZvZGIMpFP6RI39MPbatVKaHFSKKhMtzEzM4O5kaBADIB+W3Jtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7191.namprd11.prod.outlook.com (2603:10b6:8:139::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Mon, 28 Oct
 2024 22:26:07 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 22:26:07 +0000
Date: Mon, 28 Oct 2024 15:26:04 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 08/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Message-ID: <67200f7c12a55_bc69d29456@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <b152bd39f9b235d5b20b8579a058a7f2bdbc111d.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b152bd39f9b235d5b20b8579a058a7f2bdbc111d.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0216.namprd04.prod.outlook.com
 (2603:10b6:303:87::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7191:EE_
X-MS-Office365-Filtering-Correlation-Id: aa955717-49eb-48f6-15ef-08dcf79f846f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yfmFu0LUoOc5Gv28/P3NjYhnArCwsZTn4F3WjyO0vCxoOnB+f6WOxpsxCcXe?=
 =?us-ascii?Q?mXpi0LG9XZKNgWczh0ig/qR5LhGOfE8rHjQTNQOXpsGo/FEdo3CPrXaN4U3w?=
 =?us-ascii?Q?qF0DpqnXCWBohCBYddNTkoVECTUqp4c6ah90GQ9rlhOOkyFnIrpZcJ60vIGh?=
 =?us-ascii?Q?hJoN9bif+qmXKsCaCd2yn5XaVV19OpBvy220DQ2UMOo3/sV3LeaW0aZqqD/l?=
 =?us-ascii?Q?QwdFUegXuEf1CXq+i/pUEqN4W4X4uyMz1aBRKR7yhUD6pBz6aaalPPX8UuF2?=
 =?us-ascii?Q?4S29dgiCvb/lsk6e3AyAizhrNoui/o/rNg32F804KbhpWaKnSM5Wec4BeHcg?=
 =?us-ascii?Q?TWUMYQV/PL8jglAgpgZmEMwBBacMJmKavEBdO1T3mjC1YFZ18ljBlCXc7nFM?=
 =?us-ascii?Q?uHeIp1fq4gmM1ot+M9q9ZFuqeP8J+RJuA9IGZ6T+IYqZctgHocgabNlhHSIz?=
 =?us-ascii?Q?H2nR7uaFnPDWe3d0SC3R9eWumW3+Sy4C795fEXKxJb2Xd/KlKxQKZE3VrgvP?=
 =?us-ascii?Q?ZhB1LxfQQt/8110KgH4ysw1EHtNahHQ0JjYtH6ItH9RFXP+dJ0kTle/BSDh4?=
 =?us-ascii?Q?zT8vhraz1mgfKDRioaKPKOdTODPYU6t/n/sBPaDLSWZV0RmBfbf1kY7CLwB+?=
 =?us-ascii?Q?f1Ool7mJ+UxhXWKG3+B/Laa7sZXzz/XsG2eyFwqfRlqwoTBm4VhQqKuolmyA?=
 =?us-ascii?Q?JJy3rBNIgaLRtRE1M9Ui7fUINGGLV5xiGU4KvMXuZd/yKqY7gjst/HGD/Z5s?=
 =?us-ascii?Q?KXoXXtOy2aD+clotPx4GWIKZSerAcGuqeRCr8c8tH/CIN/LJbmRi6Vts4qHx?=
 =?us-ascii?Q?HeEp5M2WUNyl53m2WlfXqAetl64Y52Xcqs5T8ybRYsVeAmry/tbzhvsrUuYl?=
 =?us-ascii?Q?0rz0xcDWq2v2WUjJYlBZAOYwICNyglvLYsR0ok1Ud+Fwxz1BrHe3wE/R3hLs?=
 =?us-ascii?Q?bsgye39AqRO6HXmXu9nDWohvY0Jt0FJ4jYZn6QQ5N5qO5KL1uh9w05yEPo0p?=
 =?us-ascii?Q?o8Yb4dfwVk5DH01tsm6+9u8ov0zBg5wsGsWEfnQCE2P+KMEsnkSyV+hfU2It?=
 =?us-ascii?Q?A3Rbq4A31FuVSNB11Qs7yAsD4nSA9LRhBKAN96WjO748ziDe8upjp/zk083y?=
 =?us-ascii?Q?itUAmIWIzKYVVU31h1waJuqq/jl4C9FA9xBOKpsgFNMPMlGQG0QMWwlMtyGx?=
 =?us-ascii?Q?PLDlOW/USe1ps4lQZuue8b6NFZfDTm2oWUCvhIic8wEx5j0j3vzZc/XZ9fny?=
 =?us-ascii?Q?pAN95ZufOwBhQoQQtZ6VZsO6e8Z5GhuJSuzZiJfeQTcdKPyBZsKyy7N90l3e?=
 =?us-ascii?Q?2yGKKb/bU7vVhUJq7KRExuSfiooQjHSCnuYgKZzdODdDdgdS9zAoFCxMeXSn?=
 =?us-ascii?Q?CBNU530=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8mylnc0Se6IBgHVRsC5FHJT7BdbCzqsuKtdXezw8R6FGgHJ4ywSeQNv4KVQE?=
 =?us-ascii?Q?Mmop4zRqcxTe/qMxod0D2LrJLED0eeKqkWh1n7R1vGCww4L31wt+WH0u7vl6?=
 =?us-ascii?Q?PNju4XAHb1QGbJS4GVEB37eeMqsqwQxnAhvt2lmY9aNT65k//ryDXWEccxhY?=
 =?us-ascii?Q?shlBv4YMvpqM0owk4z2gB35VAdtup6gIoMQ+7Ips/P2TNzuy+CqZ1AfRFg7V?=
 =?us-ascii?Q?5HWn0OG8qrKaXYsXZzcceN+2cDtjlpnS0dXG0+qA+jvFXUbk94Lz9Q25yvM6?=
 =?us-ascii?Q?bAMby861UA2FnaOrrN37dVO7HeAAPwdiCj1pCZIFleslIdHrpYpC2KeeDXOR?=
 =?us-ascii?Q?UTV/1NPZSiaPIF1OhNc2K0hgAJEbmIHMec3BJcBFSnjBqyK0cUDDjSbHtSQc?=
 =?us-ascii?Q?iNfuPZws6yyBi3jpCquC2bsnapDz9MUVXOVryna8PDZspqz2rNP3XIh//PRw?=
 =?us-ascii?Q?rtfradjFW3Gsp2H77t6HEDgcZmz8nkhfHhdDKjs4G/wsSSPL5u7+ifLCMwuG?=
 =?us-ascii?Q?fg4sq7bBIpwjkcY5zewx4rmFYWrMAD5dH/YwlHz60nItcq3wK31HnY+M2/o2?=
 =?us-ascii?Q?gyEAySsAank9olGgj9RhAimwkm1uNzvfvKG+vQ1uVE1H4nlwNN1+wyByek9Z?=
 =?us-ascii?Q?QO7NY6a2rmBqVo2kHvXG+wii3YCiBtFtnE0Dzg+aQ0NpoIHRT5v2QJBrjqUb?=
 =?us-ascii?Q?OGGrDkm+lVWAOHovk0rrqzRo9/s6C10MFFz3YyLXO8wKzth2ogskrUyenpo1?=
 =?us-ascii?Q?vuWOuGSkQ1BORDxfg5+fXDFo2rYhLBebD+i9c3xwyr1wcrSGEMeZyvx4LtT/?=
 =?us-ascii?Q?HA8noe3R6uzIoARDpBpxVsjuhdF1gMGV/2E1esdpk2S3WzeLRgjet15KZo6D?=
 =?us-ascii?Q?rkR6GFdh/yh0OscsYhkHSg9UhMlwNHLm/dhvCKVWr8tEcbnkcqJtAim3gwVP?=
 =?us-ascii?Q?aix3PhwL/yrggJ3MM5Cs0V1f29iSR5isWe3fFQJBgBUcDGjnwGKvJjKnJLQD?=
 =?us-ascii?Q?6nrOwAcsZMt6AL98nN7j9iSNe1XUPvMSd5xsCDD67cMGdwpJZI83kJI3M+yz?=
 =?us-ascii?Q?/61iUXjsCaQjZ7JM6k2evqqsHNxZDU24Gy1Z3/wwj2kAl5RXDa9iqWW1PdB1?=
 =?us-ascii?Q?tsbDb2Mwrej0mYD3nB/755gmw00A6L5lon3op6i8zbqftdV4ahsKoYeGKs+A?=
 =?us-ascii?Q?OdbVpb/ifOa02ltE7gz9gQYhfRSernkw9TGUfrAykw3gza5YLiogUtE97TRX?=
 =?us-ascii?Q?evdoxXLE3XLF2XkAEKfhB7ZkAPgOAhzSab0F+CMbJD3b8fJ3gMQX9XMfNZh3?=
 =?us-ascii?Q?HNe40tjTNvQL+KJfmA9xUFGUstHcbi/q6na4BPoXFh3hAz8KkUCe3QCtQ2dG?=
 =?us-ascii?Q?1nnDXeAoFMnskBBxYKsK60DTPnKViBelf4BMJeEoOodlBg9lJIVrd8qY0krd?=
 =?us-ascii?Q?8gRo9++axh6TN5blUSNtHew5zFcUNr24ZanZkC5SJ37jnpblVTpiqSiU0b0d?=
 =?us-ascii?Q?+NBNOlJGZ2Xt8m1QZDtC6TkhjniDskCWgxcYbysXbo98A5Q+mENDORntpI1z?=
 =?us-ascii?Q?iwjmQAELtjmSig3CF/Ue32a70E5F34Yt5HvJfN5Y6otZC8DFkNnIwPHlXL4i?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa955717-49eb-48f6-15ef-08dcf79f846f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:26:07.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGI+NL6QkxzWJsqcukdkQNkghnO6hlPPcxmIPeX90a2rLPHiR2JjiqKyJh/iMQA17NmWx+5f0KkEm8UbAGzmCSLbD/RoCENm1T3voA+BahU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7191
X-OriginatorOrg: intel.com

Kai Huang wrote:
> A TDX module initialization failure was reported on a Emerald Rapids
> platform [*]:
> 
>   virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
>   virt/tdx: module initialization failed (-28)
> 
> As part of initializing the TDX module, the kernel informs the TDX
> module of all "TDX-usable memory regions" using an array of TDX defined
> structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB aligned
> and in 1GB granularity, and all "non-TDX-usable memory holes" within a
> given TDMR are marked as "reserved areas".  The TDX module reports a
> maximum number of reserved areas that can be supported per TDMR (16).
> 
> The kernel builds the "TDX-usable memory regions" based on memblocks
> (which reflects e820), and uses this list to find all "reserved areas"
> for each TDMR.
> 
> It turns out that the kernel's view of memory holes is too fine grained
> and sometimes exceeds the number of holes that the TDX module can track
> per TDMR [1], resulting in the above failure.
> 
> Thankfully the module also lists memory that is potentially convertible
> in a list of "Convertible Memory Regions" (CMRs).  That coarser grained
> CMR list tends to track usable memory in the memory map even if it might
> be reserved for host usage like 'ACPI data' [2].
> 
> Use that list to relax what the kernel considers unusable memory.  If it
> falls in a CMR no need to instantiate a hole, and rely on the fact that
> kernel will keep what it considers 'reserved' out of the page allocator.
[..]
> Link: https://github.com/canonical/tdx/issues/135 [*]
> Fixes: dde3b60d572c ("x86/virt/tdx: Designate reserved areas for all TDMRs")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e81bdcfc20bf..9acb12c75e9b 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -747,29 +747,28 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
>  }
>  
>  /*
> - * Go through @tmb_list to find holes between memory areas.  If any of
> + * Go through all CMRs in @sysinfo_cmr to find memory holes.  If any of
>   * those holes fall within @tdmr, set up a TDMR reserved area to cover
>   * the hole.
>   */
> -static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
> +static int tdmr_populate_rsvd_holes(struct tdx_sys_info_cmr *sysinfo_cmr,
>  				    struct tdmr_info *tdmr,
>  				    int *rsvd_idx,
>  				    u16 max_reserved_per_tdmr)
>  {
> -	struct tdx_memblock *tmb;
>  	u64 prev_end;
> -	int ret;
> +	int i, ret;
>  
>  	/*
>  	 * Start looking for reserved blocks at the
>  	 * beginning of the TDMR.
>  	 */
>  	prev_end = tdmr->base;
> -	list_for_each_entry(tmb, tmb_list, list) {
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
>  		u64 start, end;
>  
> -		start = PFN_PHYS(tmb->start_pfn);
> -		end   = PFN_PHYS(tmb->end_pfn);
> +		start = sysinfo_cmr->cmr_base[i];
> +		end   = start + sysinfo_cmr->cmr_size[i];

This had me go check the inclusive vs exclusive range comparisons. Even
though it is not in this patch I think tdmr_populate_rsvd_holes() needs
this fixup:

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4e2b2e2ac9f9..b5026edf1eeb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -776,7 +776,7 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
                        break;
 
                /* Exclude regions before this TDMR */
-               if (end < tdmr->base)
+               if (end <= tdmr->base)
                        continue;
 
                /*

...because a CMR that ends at tdmr->base is still "before" the TDMR.

As that's a separate fixup you can add for this patch.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

