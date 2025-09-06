Return-Path: <kvm+bounces-56949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3DFB46918
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 06:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 575BE5C5840
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 04:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AA1279DB0;
	Sat,  6 Sep 2025 04:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lYo5bUie"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2E9279798;
	Sat,  6 Sep 2025 04:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757134189; cv=fail; b=JgpqWsf7ekvBxqaMWEhcnSNpIelLepxuAnc5QDJfiW9J5xII0kRycATt2+woRXjzHuv0uOzfiMmcKKsTCC1KitLxBwWG3Q3M6vq/ritz5uxpw9VT3bbVEcPSxV1e+PcUeITvPF7A6Lb0PkUmLURgVP/Ot5/4g2Sm5juCzf9Y7Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757134189; c=relaxed/simple;
	bh=pwD1n70UUXletmYutzZ0BiyD0EuMLQU6ZitSwqNxGyI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LWVmhFrm/eVJWjgP9bIAIQ3ElNFD2qUuXi6ZUQUNdIM7bdsjDFtu/Na35PfH5LwxLGFOaS34DGQJTq5Ql4w4V65zPNN/Tx+E/S26ciipY0ZLlgewcktV0BLI3404DXsoQWjz/gEVDHrk1Y4OG/Q1Wvp4nxtpHJkZy0jhtagL/Ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lYo5bUie; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757134186; x=1788670186;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pwD1n70UUXletmYutzZ0BiyD0EuMLQU6ZitSwqNxGyI=;
  b=lYo5bUiec1PJBs1mjJm1uAUq+cEOAu/TWfi2A5Ibz6gNMIZ7pPDOhQyv
   wu6xaCEGiVKKNKmOP2B/+Cf2NN7pSupGEyVJTkZNa74snb/Hr41DXmeot
   RSEWqGfUEdrcjXgw9g9l3VFbWiGHxrfTXSWac9qAy5se49dH1SVGUwQTk
   7F+PmJ4slr1Z3HBgu5746+Tl8Rn+g4TDy06smj2cT2jLTJE9RsPk3J46W
   mYkyow0mvF3+0AwJiMrw0cfdmHp4dsNybaDiGtEKWymhi58RAgmfJgav3
   E+uR3gbHlbeI158115HTbxlon9q/LXSK3V7M1fpwA566uYZ7FQhVjf0qR
   Q==;
X-CSE-ConnectionGUID: 8o3v11yIQeeMkNfKGvoMLQ==
X-CSE-MsgGUID: ZJCVQuvkQ5uhATnTmT489w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59431878"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59431878"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:49:45 -0700
X-CSE-ConnectionGUID: EOv/II0vQ722Ge5+cFlzCA==
X-CSE-MsgGUID: h3Fwx+hXT7+Fqc0cqw/r+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,243,1751266800"; 
   d="scan'208";a="171596914"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 21:49:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:49:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 21:49:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.50)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 21:49:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXeB6SbRil8pje8dXYKGaBbhUT1LIKOvT66wvww9zFgu2m++mSsTfTWrDdRK7NYwYhgzkrBzDvfwuQzBWRx+TtMujSkEEsKqSSQ0kNMlT/wJvtt4eQQDa3Y7FPM8Whaku1BTZIfzo+U7E8AhszIu5wLdYE5trZPbSzvrDcK+2lSmuIlESXJ9oR58CU+E3vMFU9MuwlwJHm0jmdGWbQB5mkMSAD1QV7dJVxyjqVAuaY9gzuVkFMJEvNYKAfh8nOqay8002qk6PN1kCtR71zK01Ok1CBYdTCHq2Dfk9KO8ikPQuHUKSy8Nn3iPoLZusqtflw8Sj++oPjF/Jup+tEaXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2qOnJ+Nd7+JLTvaXKPiZ/QU41MpZrOaKkvAadvoD1o=;
 b=lRpgBnPPEirn4PFlMsogbag0GhqwbzjBoeDOA/GecMM5Prjshwk9JixADncIRS53s3P53JvXG1A1HrFZG0xDEAGJ1mrXAUuOcObYe9o/Yl97SSrXu+ujJ8Bc+XwpZMqBLoO6D9dFsYTAJRyxaM22NcsPWDfSlYevmCSez3PEWP5TsKrHBhzuUw3xrs9jGE5B9R8Azpqo65nb3ENgr+zsswnujZqV9KmngYMC0zQ6ahQABfG0wALP1T5nmYbjmRNbDBNzWYjsfYHu+3yjfD2Cgyz96BPAw2//Bl+TfH/R0mJAQq1/BL4qlMJN3oqO1abIYe+XLo8JclgWoDegSS5aqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF46B98A11D.namprd11.prod.outlook.com (2603:10b6:f:fc02::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Sat, 6 Sep
 2025 04:49:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 04:49:41 +0000
Message-ID: <effa04df-5452-4d9f-b026-73f9e043e324@intel.com>
Date: Fri, 5 Sep 2025 21:49:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 25/33] fs/resctrl: Provide interface to update the
 event configurations
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
 <1468bf627842614be7bb3d35c177b1022c39311e.1757108044.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <1468bf627842614be7bb3d35c177b1022c39311e.1757108044.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0014.namprd21.prod.outlook.com
 (2603:10b6:302:1::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF46B98A11D:EE_
X-MS-Office365-Filtering-Correlation-Id: 96cc3de3-58dc-4f3e-73c5-08dded00caaa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eHh4aE1aUTUzaHl6emR0WlVWUDZRVWt5RkpJVy9VUmUyRzBzWWZ5RHY4WlVk?=
 =?utf-8?B?My96QUNkakdORnhxRU1DdlJmMDNOM0l4YTB5T2wvM2Z2bDFIbUduOEZ0M0lM?=
 =?utf-8?B?alQxckoyZ0NwbHlKRUZadUhnQldxNHcxUmI2cnhaRGxNL0lvZmJ6MlAzR2VY?=
 =?utf-8?B?WVhHMGZqd0hkV0I0dW9rcVBjTGV1V05weDRDVkFhYWtuOHQ1b2NrSmc5Z3dt?=
 =?utf-8?B?Wk5DSXA4Q29DcG1Xd3YxMkV3cHp3TTVXckFNdEcrbGQ0ZGZ0TFkyNzVvbTZN?=
 =?utf-8?B?RzIwZU5kUDlySXQ5UTJ5a0c4cVVIREJsVm1DdHFIYkdveGZLcnltVE1xZ1ov?=
 =?utf-8?B?enR2R2Frb0wvcmpoTk9oWFFxbUxuRnF1YzJ3ZW9xQzJzR3laVjdZdFAwVVBI?=
 =?utf-8?B?MTRjQ1I4NllKQTUyK011NW9FaGdBQWE1TklyMW9OQ0lrNHVLeHFMamR3TEdi?=
 =?utf-8?B?RHlqMytXK3U2Nlk0dHFXOExuYWJ4K1NPYjBWL09JT1BiamhSUTN3ckZZMmJP?=
 =?utf-8?B?THFKUVRpeWU2ZFNDS3Ird3VFQjdBU3JuME5uNFRYQmNSaHdCbVZhY01CazZ3?=
 =?utf-8?B?SWNzQ1EvUXhkWVkycXRlYzFlaE1DR2dmTXY2Q05DblAyY2pROS95MDM2aG9E?=
 =?utf-8?B?b09SelhBOXM2VXVKcTV4NllDeXN6ZTVKTGlRSkVoYTFsQklGZHdxUjdnTWR2?=
 =?utf-8?B?WElkK0dsYVJyZGhCMHVsQ2I4UFBMUlJtTXpJbTh5MnV2N2ZOOEJiRjJLcG1C?=
 =?utf-8?B?elZaMVNIdkdwelovN2Q0cFkrZi8vNFAyVWlOck4yZnE0dzJMdUgrYWJIUzZa?=
 =?utf-8?B?T0xEajhPanI3bGYvQ3ZjenR0dzIveEFxVHY4dnYzT2MyNEJXZTUwNThRQkR3?=
 =?utf-8?B?a1VFRzRNZkFoNEF5dGVZNWtSUXBRaXVhMDZPSHVPRjgvL0VZeFNZRTVidW1i?=
 =?utf-8?B?RDB3R0UrTjFyQkI1YU9TOUxQOThPcHlYWndUNnUrUE9hZUhhdXhGWnIrL1J0?=
 =?utf-8?B?S0lxbzhZaldPdE5Seld1bWhoSlA5dDhKTCt5RVNjeUxDS3FaNHpYZEFOT3hk?=
 =?utf-8?B?dk9ZcDZLSHNYbStWeVFnUDdhd3QySnlqb2JseHhhb25La3EzeGI5UENNVFly?=
 =?utf-8?B?b0JzVXdjL0ozWnlxczFJTkk2UlUzNy9Wd2N6bCs4Sy9MRXNRTnA5c0tYcWtN?=
 =?utf-8?B?WlRTeU1nRDVQNTZOMFNCbWtsZnNxa1NpUzF0blR3MSt4dldpdzlmbjZiTlk0?=
 =?utf-8?B?bXp2Q1hyMDd1TjB4RE5rT0RIMDhmZHFBc2cvOWlBNmVEZ01Ea3VXbm9kOWV4?=
 =?utf-8?B?elNpMWwyZFRyYVVoT0NKT3NEbkl5aW90dVIrbERoc21TeklVTzJhNGZhR2hz?=
 =?utf-8?B?eTd2a1kvRDJwVGw3M2xRanFkMzR4Q0Y4WnFoYlErc0RnMHgzRWhRNzZHa0xo?=
 =?utf-8?B?R3hsc2F3bjlpdi9NRkNZb2p1N1RsSldScXEvazZVRUFqWHZXampKbStwZjg5?=
 =?utf-8?B?RWtTUnRoNkl1V2IxU0l0VlBmVU1MTXcxRUJTcmhsTWJTY296TlladmIyZEdk?=
 =?utf-8?B?RlpxcUcyeE5JUThVYXYwVGJoL2hpZ2w0dVhMQU9FTFVnWEduNWo1cEVQMlFp?=
 =?utf-8?B?ZENITkZWUE5odVhwOEZrYUZ5SElyTGE0OUJyZkN4UTBVbFVPcDVueFJiNnZL?=
 =?utf-8?B?UVk1c3JZUUFTZjZ6cEJXTVR0a1VLNjl2WVBzeU84dFhSc1RRZFNOQlNNeTd2?=
 =?utf-8?B?RytZb3B5eksrMFJuS21TNW4rQkpoOEc5ZDNUeDZuZ2ZKYlZROXZwdGcxb2dz?=
 =?utf-8?B?alJ6QmhWT3pjVlFBakVUOXoyanhoR0F2VXRIc2xjNFhkN29Jamlnb24ya3NL?=
 =?utf-8?B?d3Y2NGhuSnZ4TWJ2dkFZd0ZBTUhoZ29Va01zYlk3M1R0SGxDbW8yMkFJemtm?=
 =?utf-8?Q?4huvtKhyQu0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnYyK21RRkVHT2M5WUw2QjVJdHJJWUxNVlFZWmtiMFF5OU9OT2NmMkV6Ui9W?=
 =?utf-8?B?S2U0ZlorWFFnMlVmV0o3VG5PTXhla09JdnlNSklkRGh2VmJaY3RmajM0c2Q2?=
 =?utf-8?B?Yk9OUnlkSmlzTzR2L3Q5MU1TcG5XUnZpaEh2KzhtUWRtMkxLbFdkQTRtbWJi?=
 =?utf-8?B?ZzFZREFoMThWQ0lKaDR6S1dFL3BxK3MzdWZ2VzA1ZkMvU0podEs5UHFhbllx?=
 =?utf-8?B?N2xZSkRrVVFDRVRlL3RLVjdRM0ZvVGdDSG1qYkpmVkk2aitFOHpPQVlseDBK?=
 =?utf-8?B?Q0hvUUM2dXZjcGRJZkR2eWlrZTRTRGovRXpYbjhYT09PWkNqM2pWREd1MWdv?=
 =?utf-8?B?alhDQS9kVGRRQkY0ZmJwQlN0dzNoVG4zSzVmQkRrL3dGbkQ4MVZDM1FkNTlD?=
 =?utf-8?B?RVNyR3lIeVBTYXVtMFQvS2lRd2l4T3F5OUY4NTJmNjhGMFVwOFBZVk5naVd4?=
 =?utf-8?B?d0JVekZhenZsRHd2R3cvc2lVZkMwUEVRZVJCSDV2QnJCaVFZU3p5OWZuZFdy?=
 =?utf-8?B?cXJnYWRhY0VMQWZ6Q1hoZWVHQmMwVmlpOEo4ZytHc3NacCthUGJGVTFyem5W?=
 =?utf-8?B?SFA0ZVMvK2RoTUxtWUttbDNubndqTisxbG93Z1NUWGNWOWhDVzZFQWQ3K0hY?=
 =?utf-8?B?QXVEWmdpSUd4dW9Wa1oySzdjTmRLdEhNSThzT1Y4c0d3aDY5OXB3RjFRbmJU?=
 =?utf-8?B?R3JKY0UzUHJWNjd1bnZ2cWwrTlpLSGljZThZUE9CckNSOVNMd1QyR2x0Tk52?=
 =?utf-8?B?RHV0aVZpdDhUZGdMSEV1MGdjYVFJWEpIL0JuQUFUeUllUDNzQmR4QzRHWXBY?=
 =?utf-8?B?WHNhTGxtamdHR3hoK2NPWllVclVueG4zNExIV1NhM0IxRG16Q0REbUJ6Nk9p?=
 =?utf-8?B?akJSRUFCOWtaaHNnQklBSDBlT01RRHRWNWh0QUdxdHpuL3ZmVGwxd1JhemxV?=
 =?utf-8?B?ajRWRjEzbkxEQS9VbTh2bVBMVklLbkxZQ3VoU0c5cFJvcWxxU0JPZEtSYmxH?=
 =?utf-8?B?TWdTZ2xsQ0g2aTFGS1R3Vlh3Vkh5cE5ML1Q1a3hFQU5zeU9LUklRYnhXMGpv?=
 =?utf-8?B?aVNZYVFXU041dXFnTFFkeFNDWUJCYnpUd2ZwZEJ3TnpoUXdsbllkenltNkJY?=
 =?utf-8?B?UXdXRTBJM25SKzJrUmliVDltZm04SU5uUm9EZ0ptN1A2UldFbG9WR1ZHSTAv?=
 =?utf-8?B?bnJHMnlhSjRQRC8vZnlUaEJsTWpxVnlMa1FwSnZrcUlmU1haVGtxSVJKS1ha?=
 =?utf-8?B?WS9wL0RxSkg3TFh5Y2N3NmJINFcvSlRMczdhTVZHUi8rZmNoQmVUWjlQZEc5?=
 =?utf-8?B?VFRhS05neTZyMThQaENnYXpnSVA5TGljWW5Xa1dSRFF5WWdJdlB4UExiWjUr?=
 =?utf-8?B?U1ZLYlRnbWhIUHBzajFQVUNmcnNkZmxTaUFFUGhDRWhvZ0poZzZIaWNBY2Zl?=
 =?utf-8?B?N29QbXAxU1Nwa08vMnBNODlibngzYW55MlBXZVNyeDRWOW4wbW9BVmpDdWx0?=
 =?utf-8?B?VEdJWDJQeERCUXpxTElKUktmN1I3eVh1NzJrY2IyZ1pZTno1T3MxemdrWU9I?=
 =?utf-8?B?ZzVQRzg1SEd2eVNQOUNxRnpleHIvVWFVbHJ0ZlpHVjdWL1pYWnlZRkE3dkNF?=
 =?utf-8?B?anNMdDVveVFpZlZPV05ZbnRyNHViT0hSdHRlNFA3V29DSnA5aDNxRTZUM3FM?=
 =?utf-8?B?VHVKeW9jZVJXUkdSNFA5ajlhRVhBeXIwcFJYNmtRWFFFRkxwTU5SVE5TVXBI?=
 =?utf-8?B?YytoZkxkUWlLMUNWZmlQWng0bGFQaWtwMmhpYUsrTnhWaS9lMmZKZmc2bUFJ?=
 =?utf-8?B?OFJZeDlheGJQQ3hyM1VaRWdjVjh0Z1luUElCNUpJU291SDVVSzhMclJOanM1?=
 =?utf-8?B?ejVVZFZDVlBOZ0p1L3I2WE9oSXJCVDZEVFl6QlJzbUg4ZzI3c1RxalpnN3FO?=
 =?utf-8?B?YXVmdGRiS0wzbmxZa2R1VVFROFR3TnNCRzUvU3pnZDBIbTlaNnhVTnpRMERl?=
 =?utf-8?B?S0RsaHgwaVBKVXg5MmRHSmlmWW5KdGRscnB3ZHlpKzJmNkE2ZTBmanhPM0Vn?=
 =?utf-8?B?RUtZcVFMdWNhYWNWNU1ydStoam5FeFNJZ2lMU0w1cVZqTWhHZHRjaTRvdTJE?=
 =?utf-8?B?TjhiV2NZV1VoRWJwZW9kVlJqTkZVQ1hwcWp6N3lhc1hkU0orTmwyV1NLUVBP?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96cc3de3-58dc-4f3e-73c5-08dded00caaa
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 04:49:41.4573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1eIjBuBKJhE+4Qu+T/dOnZ+1mNHC3ELFVWgoSNTPirYRq0QPsiTROX7M9fXjXatRMGpmoMtR9exOex9sVc2lcAadgzofSyibROQJxhF6Cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF46B98A11D
X-OriginatorOrg: intel.com

Hi Babu,

On 9/5/25 2:34 PM, Babu Moger wrote:
> When "mbm_event" counter assignment mode is enabled, users can modify
> the event configuration by writing to the 'event_filter' resctrl file.
> The event configurations for mbm_event mode are located in
> /sys/fs/resctrl/info/L3_MON/event_configs/.
> 
> Update the assignments of all CTRL_MON and MON resource groups when the
> event configuration is modified.
> 
> Example:
> $ mount -t resctrl resctrl /sys/fs/resctrl
> 
> $ cd /sys/fs/resctrl/
> 
> $ cat info/L3_MON/event_configs/mbm_local_bytes/event_filter
>   local_reads,local_non_temporal_writes,local_reads_slow_memory
> 
> $ echo "local_reads,local_non_temporal_writes" >
>   info/L3_MON/event_configs/mbm_total_bytes/event_filter
> 
> $ cat info/L3_MON/event_configs/mbm_total_bytes/event_filter
>   local_reads,local_non_temporal_writes
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


