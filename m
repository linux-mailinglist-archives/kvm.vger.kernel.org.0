Return-Path: <kvm+bounces-20199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E22911855
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 04:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE6AF282383
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC9C83A0D;
	Fri, 21 Jun 2024 02:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TzKAe1US"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D88E566;
	Fri, 21 Jun 2024 02:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718936142; cv=fail; b=j7eQScvF7tH9nwiLnMmkrDTQUMQyPciGLkDcCR/Woznff/uGGEquohC9mSYmjdXtfT5NVnOuVpuTriwirViJ+sWvRtX4MOv0LzG8JNdyTHL39KGhCa/+aD5Ou93+1BB4CCSmujPpmWsBBkU+YfWXwrM/55MD82z+04NvCj2owE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718936142; c=relaxed/simple;
	bh=Newv2g2R8wcLMi/J+EW0bBKAY6ZeImUavInqRZrlINg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cJsYChjpRq/V70D4KljXsUEUT012CpI1qCD5f6SQiULFccO2OqVV5nYl9cskLIvIGKOS9DWipePF7ebaZPRd/z5T2HRaxM+2AFYZ2ys6nqQemL4aiQ0nbhaYCtdZCb9EOa/PrlaDvIYgFCpPcTdDBlIEqP+EKyUQAvkETgzHxCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TzKAe1US; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718936140; x=1750472140;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Newv2g2R8wcLMi/J+EW0bBKAY6ZeImUavInqRZrlINg=;
  b=TzKAe1USVzTovO/+piOPrveONIoNcBES0NhlMEQUseOmds91uETQI0Au
   1T2opOoAOjRE/awwmg4UFoURyZZ7/WRA/zYVRqrSnwYRYDuG41jasX1ki
   QcmU/L791xKuIV8d/QAJx+tDQfkKCQVJ1zsJftwntZI0YfXKnrfEiJvZX
   bNne5uuy35xkAJVbZggJ0Y4aZbuARg4VAGSJsNIBPV0qGyThDRKbB2mQi
   uxlwgwddeBwRV4pVay1IPs0MIAjIsSJrBbIVMb80mJ9JrCFuKFqBcuiVM
   gCm8WX7awXGhyU1I+GyTfSt7rfP7n/7lrJjoVTiUCLuvpjwITAafH+BgS
   A==;
X-CSE-ConnectionGUID: ld23Kkb3R9iF8eo7lUMh2g==
X-CSE-MsgGUID: o7ikLqtWQLuozHfGAdMcuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="12172967"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="12172967"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 19:15:40 -0700
X-CSE-ConnectionGUID: ZlTJA+1NTbuTwt46BB9sTQ==
X-CSE-MsgGUID: E1ismuIpQzSK+57YjKAe/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42548035"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 19:15:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 19:15:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 19:15:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 19:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgPbxGp39YOOE3fT9tAmiEWaFrjmsIMv4Rm/bPC+qfI/D21ILvCZpWAOVl9dfCW+id0SE6nylB0gacB9SHoX3qSnUDAbVtO0IrxsrVJ8u0VmNf8Ugx0DmtLuMO6QcATPL8IPn/b0PGs17m9xK/Aec1c1ByDWgh3fCk6eX2TBG5VtTyFWG+uXFFdD4Yphk4BRsOOiu0PoGRqn4MBNP21xKpdTipfGUDCQ7widEgHrAWt2iDUyFq0q4QezYZhCRDZsG5elsZmqQkJFSAhCAJFgzN4RHqHT+c/yoyNTBT+phC2/czlR8ITd5Objwr73rMXVHt9EpOBfzcy8YJhrzqh7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OEipiuKW2gURYpJcznXCsoMcD18Zd20LUXqRB+NVfDo=;
 b=VL/aoInJCYMnuk5fvyx0RsWX/Ak80TOX+t7u2uZuyyTMrO8UD9zpleN+XPyuJ0jdtI3Bu5v+LdMMQmxNkhSm3F20i4aTjETeZQknuXLBNw7lfU2BQjwKjxhcFfoKZqDfMO6iOTYE516G54PjBUP2xxOgb/YtDBw+YCRX5eeec9BA20kVcK45Nx3U3jKYK5wk0R1IomOcZw1nY7OPOlmz0sK4DsW+hf0Vixr/XbEPk5YI/dYyPcxyWqZDtHfUbTRNIJPe8UYERGYL1G8JcePu16inijVby+6bz84zZ2ZrG2BBhpqA/f7o3KP03VHmMAaxDGq9NegIsYdbU3KZARdrPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7577.namprd11.prod.outlook.com (2603:10b6:8:142::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.19; Fri, 21 Jun 2024 02:15:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7677.030; Fri, 21 Jun 2024
 02:15:37 +0000
Date: Fri, 21 Jun 2024 10:14:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <dmatlack@google.com>,
	<erdemaktas@google.com>, <isaku.yamahata@intel.com>, <kai.huang@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
	<sagis@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
Message-ID: <ZnTh+gpP7nH1xxEW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
 <20240620193701.374519-1-rick.p.edgecombe@intel.com>
 <ZnTEhQo2r3Uz9rDY@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZnTEhQo2r3Uz9rDY@google.com>
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: 271a9f11-8a71-4165-a1ed-08dc919809fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?n22ny5nflbeB3oANlHP8qPuF9B3LiWFyFyN8UNvZof8fXrqvAkowRM/HyKd2?=
 =?us-ascii?Q?crYGLEpzpP/x/OqEp43vf4PwfJpxXnTxu2uigogRDgOH7QTDY7t515OsIHxH?=
 =?us-ascii?Q?4GLJtU4zytI1IBuDMvyauj7Yx8GKi2yrT00eIppaLaeob89vQ8R71McBxqF9?=
 =?us-ascii?Q?11typ8sYGbZOOEnOAsYxXXU2QVv5CoBd4TCBAySJi3C7pocrEUsv/3kdVVyS?=
 =?us-ascii?Q?6euHCGs7py5uD6towrhGoA8Bo7ybgb4kr+aDJZi4bMLdQSFOuE6lnzRyjSfA?=
 =?us-ascii?Q?Kkl2MUquRn8XMbM9FOThd/CGrdQblcSxQyWl/10/Wqq2CfKLkvG4YPjxng7Q?=
 =?us-ascii?Q?omeru+KYPwuGLUNK0aWBC4TJnyAcrnXYEHP6Dn/lpihH2/89ULI4UrxQZyVw?=
 =?us-ascii?Q?535eKxEeQnrnN+VB2KuVc1j/PkMcbZQI4NkeU7bz1hGdzVUj2lPn2K1SyvAD?=
 =?us-ascii?Q?aJRtxqqxLpB74hZhagL8EH8zqPyHiboeo4GJKa6Alrchcl+4MuvB6zARkGI2?=
 =?us-ascii?Q?TJdSpXaWUzaG3GKJz4s44jgF6RpXVtVNFcRg3HtW1lBca2cglBpG8eUmbDkb?=
 =?us-ascii?Q?MfB2G59b8DfIzpCDF+sl90OK7EBD75ZUnfIzi/Hq+ByhgZ5pQqB5+aDwzhTz?=
 =?us-ascii?Q?qQ9TBNJCTq0Qnrm62VpMTzxwnpKUgbhVTxTQxKh87crYR1igaGx74Ht7478Z?=
 =?us-ascii?Q?LeOj//oa/dMtEfyrmpSX1XDUFUGlCsCbHnT5n9dh08HZlzIws1QRHdpStYsh?=
 =?us-ascii?Q?miHoe7OQftB5UDvr6+YBDHlNHzwk2TgLtWHf7aeUh6lxtt5eeOpYvZ4lsTrl?=
 =?us-ascii?Q?Rtq39FsJH3miukQXZRVv+5/nHx6dFJc0AIDCpgRsV8zEBx3wjV5B1BVFWzuI?=
 =?us-ascii?Q?xVSIqsSX7FytnNhUhocOTlrRI8FqnW6M9jZpMaJzZ7A0WKLTuLWebPateYrP?=
 =?us-ascii?Q?heyR8H+var3I4gRCQRgLzjN9QYXP5Z2/u/oCwR15b9DUYPuXTBi3WWK8j1Js?=
 =?us-ascii?Q?WkdnZTMEHiT0Ytsw4JRAyRIIZ/h1GPNuFHol50eV6E1IQwbqSdy/rbJkPMJf?=
 =?us-ascii?Q?XYajizGLW5SriyhojbnTJOD8Aheg1B0BxD3cy+44hSfj603qKUJzxhlMK0z2?=
 =?us-ascii?Q?lS+vQerehF4qy+OcntXEmZTt3ec8PIqL0VmrTynLyJYx7wAyX3e2RGzXvPpt?=
 =?us-ascii?Q?ha83vVUVQervZpLU89JDe+7SrTgLGWTBOYqMN6EVWMAXlTegLobUUU3HZwip?=
 =?us-ascii?Q?Eh/DHHi1MMT8vFgSHqKWa4Ws9GOlrLqI3KGYqdrunIMpeQbLaiy1e2Wkgcfv?=
 =?us-ascii?Q?YtfZQ1Fi9wDHg0aXkDRfsGXc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mjCirHDw59c69fZMvnzwhgxhg7fV7HjPkxMd1gOUfr4tME8XJI7tvZXcufvj?=
 =?us-ascii?Q?zGx80nGgBwdupmyiDX7/GmANwTSJ25bq/pjZqXVUtO3SMwcjt9k+dY05PorC?=
 =?us-ascii?Q?otqElVqYwFm9JYjWW+X9ERamx8tOdzNdYS5VHygv9Mh30Tz+yREDNdZUWBD1?=
 =?us-ascii?Q?eLctNtH6iwdAmllp7UEcvn/1YAwFhyxLx9D1xZZxALS4oizBn512RA6dveUL?=
 =?us-ascii?Q?PauZ36zQbM7KVfLgHAJJYHppDuEw7TXJJc/W5rfxCRoecme09l+J7balKZSz?=
 =?us-ascii?Q?sMUQaV62xky1XmGiMDqA7w90u9j0uYbnzLWvCWzJFjn5CWFXQOiDvj+/xAyt?=
 =?us-ascii?Q?i6H1jIeXKiPBKeK7wKNjbI5TXqF2fJxAMaGyxiHMgGN6mvz8TJh8lhwR6xJV?=
 =?us-ascii?Q?n3GHLpickus85uEny02sHrUMAtSo/dv3OnafeUDgEcOjxXWCbLujwNX4NQCt?=
 =?us-ascii?Q?97JTI/Iz79YmEf7jBD1mtIB0NbueTVpPJt8gPOOmeRz8AJE83Kjvuid2lo5b?=
 =?us-ascii?Q?X8KIENDke3ZwtmL5f6BjADXPHZ9ox4+aSCR3O4Hotxf3nQ27APj6DkqNRCO1?=
 =?us-ascii?Q?jr+vBvvQ7GRwj4+58yEXir59duqR4pwP5QgSZDCi3fRgcivKr0w1agqDmZiD?=
 =?us-ascii?Q?yvWlVloYfTiJUuVGn/rk375JzWTJ0cwbapJ7ZX2v7iJrjmWKWP4KaoalNLE0?=
 =?us-ascii?Q?K/PyyhOnBQLybCYYv0qoeDnY2XBlZ07JiNFXl8hbP1rICoNMdT5LpB06u2oa?=
 =?us-ascii?Q?fMare2s2kLSnJyPWSyH8ARsuO3tCFNOm1q6J8RWz4gajm2Q8ZSv8ZoeQk8o+?=
 =?us-ascii?Q?7s0cpGVFDzsoIPzwsJeMigi9pcfV+3bdxbjhZn1fEuYXStve4oY3XpZ3TxwL?=
 =?us-ascii?Q?pRbCHHp6hnMgfmWFR/2xVSC42sbEcsgSbo/InEu9eap+LeJ7Ihwhcw4qX9De?=
 =?us-ascii?Q?vPod98mOMSPQYPFVH/9/LIyXkpAyN/ScpqWcAmT8bMtgbbMUmeqgh+zJZkfQ?=
 =?us-ascii?Q?rCmkTap51OR60RDqLWbUFcfoD0/K2M3IG08HYifqzuJD1MFja6UtAfbosqYY?=
 =?us-ascii?Q?WNQwVfwrfcdq91fls5DbkBk/kE+NB9n6h1qUi6UND3JKAIzpeBAhoKUewsqw?=
 =?us-ascii?Q?Ia2SbZ/1zGhsmrdy72JubLxx6sNywhxiRHR+XZbp4MHwqcIFWTh8ilA0Zq/Q?=
 =?us-ascii?Q?jgFzWuLXnGDxqkhF91AdwsIUw3o6sDM8V2rExLmD5o3GZgOjBHN296yBwSFm?=
 =?us-ascii?Q?7TnlIY0GmHr+ancP902+3WqECukuu+RoUWfxonbv1/Y/foGgXzQWEusAP/cc?=
 =?us-ascii?Q?sKaDoagB+7hqpU3Ar2tgcFPsUGTRVq3J3czG9409U/M1VU0txPjbLr7Echu6?=
 =?us-ascii?Q?jINgvVcnq2JsI5hJ7IjYT/rfibceMWYRiRFII7RV+5yJiOHJVTlUbYrhXZWI?=
 =?us-ascii?Q?EpQF4fZ0R1sW3qHBboI4Y9m5LyS1mFfYQYnGpJUf/5Weiyow9nvqcsl+70Lj?=
 =?us-ascii?Q?er6zyAopbuvRcHFcJC+Jrvwn/Kcv9AQjuq43DitQ5Z3iGUW1gAuJfRvtSDgV?=
 =?us-ascii?Q?SrFxGMz39sU8ZhzHK1217Cx/d1bYS1GKB9+YSsF1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 271a9f11-8a71-4165-a1ed-08dc919809fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 02:15:36.9928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jUGL/aoJ0vg2wzQboTrHwaXrNIIY83pYpoJ8KzCHbP3NTn1I/LMx6Z87LJz7//l0rX368Nsebesa9WFpYW2pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7577
X-OriginatorOrg: intel.com

On Thu, Jun 20, 2024 at 05:08:37PM -0700, Sean Christopherson wrote:
> On Thu, Jun 20, 2024, Rick Edgecombe wrote:
> > Force TDX VMs to use the KVM_X86_QUIRK_SLOT_ZAP_ALL behavior.
> > 
> > TDs cannot use the fast zapping operation to implement memslot deletion for
> > a couple reasons:
> > 1. KVM cannot zap TDX private PTEs and re-fault them without coordinating
> 
> Uber nit, this isn't strictly true, for KVM's definition of "zap" (which is fuzzy
> and overloaded).  KVM _could_ zap and re-fault *leaf* PTEs, e.g. BLOCK+UNBLOCK.
> It's specifically the full teardown and rebuild of the "fast zap" that doesn't
> play nice, as the non-leaf S-EPT entries *must* be preserved due to how the TDX
> module does is refcounting.
Actually, slower zap all for TDX was also considered. e.g.
1) fully dropping of the leaf entries within the range of memslot
2) just blocking all other leaf entries
But given current TDX MMU series does not provide block-only implementation,
that proposal was aborted internally :)

BTW, there's another proposal, not sure if you will consider it.
We can still have users to control whether the quirk is enabled or not.
(i.e. KVM does not enforce quirk disabling).
If user does not disable the quirk for TDX, then kvm_mmu_zap_all_fast()
will be called to invalidate all shared EPTs.
Meanwhile, could we trigger kvm_gmem_invalidate*() in kvm_gmem_unbind()
as well? Then, the private EPT will also be ensured to be zapped before
memslot removal.
The concern for this approach is that we need to do some similar invalidation
stuffs when in future memslots besides gmem can also be mapped into private EPT.


