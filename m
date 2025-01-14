Return-Path: <kvm+bounces-35342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD00A0FDDD
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 02:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 691ED166421
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 01:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 147A645005;
	Tue, 14 Jan 2025 01:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G1GVnNWl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B72628D
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 01:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817268; cv=fail; b=Hx7dZWF588emOyn02SES9Y/BV18fNwwSF64iG+KDpMqmhgpeqqkcypeqNVeJHsNdYoohV63U/3GYU25dcJ7bskGD0ijJgEghj8hq/b2f5o3zs+ROjd+la78o+p+grf7ly5hEvJZfScgT0dLVqEj0gPF3zpBaxbI7FrsSM7UPjHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817268; c=relaxed/simple;
	bh=fwU1jyew9Xk0kPamJ26XCepGMAXiQWl25OzOZ20oyZw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c7IPCGdHQkx5QW2+kuTVok1EHT4iV8JYVc1zAXkOv4F65tui1qzoEI9MhLmveByhOUK3VIwJ69u02HjDmJLAYXGRuIiGnCxOikRs9F8mjpD4IGhqcBsf4TF0WTIJkJhjhYQNOoaa2M2RmZPJH/Al5YmyVaU3F/LpmoX99/RHXt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G1GVnNWl; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736817267; x=1768353267;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fwU1jyew9Xk0kPamJ26XCepGMAXiQWl25OzOZ20oyZw=;
  b=G1GVnNWlFyN93kh2tjxKH/bP5xWTTUGVYYOXbpNdf3XwfeAgcxhZh9hp
   lMNWD8JkTAeUfuZ5eXjWUU8/nQyq5q+MsgBAuCAScCMDWWpMl0fXO0d1c
   aXOB13x+1tMePuybd85OrCj1Ge9IxDP43aGBReAPJPKboDGz9lbBtmT27
   KS7Hl5p+/CMEfVDyErO2dse/larjlL5XRvGxp+ZRUPpQQrugtenSAetft
   MRnUD1cB6cuLGBxj/zk5B+BSidCuSQabnPbRHjMYSjLFskhXjXQAs7e7Y
   O78FhP4eoTyP1FDwOWq2LtlTKFEWxWCXj6CYTG787ombVW8uWd5UquPMU
   w==;
X-CSE-ConnectionGUID: 3n9tpisGR/SSRLTG7YM/wQ==
X-CSE-MsgGUID: JZzLIYLrS2GYlpxh1BsC5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="54643852"
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="54643852"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 17:14:26 -0800
X-CSE-ConnectionGUID: +GTIWExjSHK5asCNuLuuAA==
X-CSE-MsgGUID: Ve6vwsw5StSoLHez1Q/E7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="109670185"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 17:14:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 17:14:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 17:14:25 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 17:14:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvxpAaYJNM6aWfQ7MIUbJx9h0DnXqhRUB4S/oYH3ChNpnhYPAtXrXsFsa0F86FhRLpUwpxBoJ1ReD7Cf2Xt8n82X11ArmUTJpqNye5BZqjQmxmFsBlAmn2nxk9T0NBKnJGdAq/gOFM4LiPdyMN+AwQ2i9xUA2SX9YvRy/9zcKjKJLd97vOPMsJ0QG3YX6R5RSiu6ZgqyVQZcnnfGfoKeI/E2G8ucZiDN7dRXf/Cq5jNuHfPSGOPdi7TzZzutOn/kt8LT1tENronk4aU8ETzYXJ5t9Fav8RAs7ZM/h1RW9m23dBOWvcedjppMu2qBaGCoKb6TZUToRRrGIJXT4qdlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbV5FkFHI60M6H9v98g0pNxS6Jc4mMLislTr2VVe80w=;
 b=lio22HcOBtf2FAdEkym0CbXrngDa0cb/YfvLsrEaYCv2v73OmS7PoNErueJiLOWHyNiXT4/yWvAG/G3yseU1gY6iejTMrv7EtswW5HHkMqmu9IC0w0F2H+NX9O6ZuVe9WNwuw9QHwq3I8J+c14o6sSWiCkROhpfBdJmT7tCGfZwDxG8pgB32WD+kFSwTmDQH3eFocSj2PJYQFd2WDtbam3NqJDGn7ZOHDcudH/wtnpbepwZmX+rFDtlpU98G4hzzIy8LE2F+wgKPL3X7ADXZnKpljqhr6ocqjHMKOA/WC+tu+6JRUwmBvEBCM+vP8ZWwNGk3T2xum1uJjS1qNJInhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6698.namprd11.prod.outlook.com (2603:10b6:510:1ac::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Tue, 14 Jan 2025 01:14:22 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 01:14:22 +0000
Message-ID: <0e299860-3dca-4216-a9e4-bb27c994af86@intel.com>
Date: Tue, 14 Jan 2025 09:14:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <Z4A45glfrJtq2zS2@yilunxu-OptiPlex-7050>
 <Z4BEqnzkfN2yQg63@yilunxu-OptiPlex-7050>
 <565fb987-a16d-4e15-ab03-807bf3920aa1@intel.com>
 <Z4RA1vMGFECmYNXp@yilunxu-OptiPlex-7050>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <Z4RA1vMGFECmYNXp@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 397f7f86-0f5f-4bd2-e3de-08dd3438c706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHNXTUhEVHQxVFVJWGhWeHFJOFZGVnhWZkVHSXBRWTN4V1UxSmJLWmxPQWlY?=
 =?utf-8?B?MnQrRlRRNUhOSXorMHh6UWx0SjBuc2xMaGFmZlNxakhMcXlaa2VqdmtWRUI2?=
 =?utf-8?B?cFRKQlMveVhrZko4dEJUMlY1WjF1SG55ZXAwMWpZZVlLcHdENkdWOTVodXpK?=
 =?utf-8?B?K3poMlhVakhLSUZHemhYTXdIbloxMWU3S1JibXA2eFpFdW41V05yWC9XK05T?=
 =?utf-8?B?QmtqekJCcHZPRlpVTzdVazhtbU5lbGNKRUduWWxGU1IwOTdlbmpJc05VZXJz?=
 =?utf-8?B?Q3BrV2ttaWgwOVZPUDZXdWs3WW9qN3pWYThNeXM0N0VZZnJWRWJ3Y0MwZVRF?=
 =?utf-8?B?K3k0MEt2dFkxelhhNHhoSUZIOE54QWJ6blVyMVN3OHVYcHNlNkROOTZPb0Rn?=
 =?utf-8?B?RnhKK0JEOEhHS3dZMmFySnlEbG0zNjhyR2tXTk9ZQUtzSlB5U1hJc1pIWmg1?=
 =?utf-8?B?Wk95S3puVzBWaElTeFh3UUVmZDRhOGoydWdqdzJnVkVpaEdlYW96N3BKRklS?=
 =?utf-8?B?R0lOYUdjQVFkQkZZZ243S0xIakdmaTE3MjY4Wkx0dFMxWGc1QnBBWkxRWHdz?=
 =?utf-8?B?QmVtOTVjdGM5akJaVkZtSWRNK0I0QmVNUDdMZjNsOU8zSk5FcmdESmI2R0sw?=
 =?utf-8?B?OHZmZGUyclpqZ3k0YVp4bFZNUXFacnY5ZDlZMS9GUVd2cGpiakc5SEt1MlIx?=
 =?utf-8?B?VkF3ankvZUc2MTdqUnZwREdLM2pnc0R4NjRJZlIxeTRJWStUMDRFQkJnQk1h?=
 =?utf-8?B?cEY1ZTlBdDlvc0tzMUlWa3c1SXlzdTEyME03dXAvVW1ETW5SQ2tMVmhiQTQ1?=
 =?utf-8?B?MFpCOUhuVXMwb08rSDQ0ZmZXYzA0M1krRXpXNUpTaWMwSDEvZGZKM3h3V2Vr?=
 =?utf-8?B?WWRPeVpCWnhnNUkyb1VTZ1E1Qkg1TDBGWE1WTFM0SnQ1NGNlejcxNWlpTEN5?=
 =?utf-8?B?eGVhWGx5cDZ4VmdRWlBMNitNZEpiMzB0Y0o2OHhOZDJtUVdRRkhRRkhkRGdn?=
 =?utf-8?B?K1ZzczJXMDlTZkdnT3JnUjQvcUNHRlRINitwVFZ4MW1MYUx2aUV2QUt5R0ZS?=
 =?utf-8?B?M0sxLzRkZXNKQ0duZDBhZ0tVcTNkYSsxNnRXa3Z4S3NabVorU2FPWkovVGx2?=
 =?utf-8?B?WW0zandoWE96WUVKS0E3M2o4cmlMYitRaWIzclBOcW9uSzhHRjZ1Qm53eDIy?=
 =?utf-8?B?SEpYMmFhc3dzTG5xNGJETCs0SXlYWGFVNGZNT01nNVFyZVJndTk1WWFzUURF?=
 =?utf-8?B?S2JOTXl1NUxjajQ4VXB4RDREMy9ZdnZ5cEwyK3ZKVmkydWwvZUhQWHcrSjBP?=
 =?utf-8?B?REV4M21Hd3huSjBSZzJYaEJlbWJmaThmTzM1OW5zNFZsQ01Rd29qRWR3T3Nx?=
 =?utf-8?B?SHNHdGs0VStZZ2IzbHdvVUIyR0VaZldmWE9mWkNaNDRZUEVVRmJha2tLVDNF?=
 =?utf-8?B?aThnK0NNenpwMlJMakoyK0kxTjgvcjBJcnBOU0JRWW1BK3JjcXpraWdIVVVL?=
 =?utf-8?B?SFRtQVZiaXNLZGNRSmR0eVVOYnM3WndkRmt1d1MyZ2hyUmxjd3o4WE5maHgy?=
 =?utf-8?B?bmpkOUlDRVVDSlhCRXRCUkZKRFV6azVwZS9CRzlwaFM5L3dvZk45UVFOaVdj?=
 =?utf-8?B?dXFOTm94N0VDRGZnNFFldG9VYUp5ckFCZzE3TDFzaHo0cVQwKytnak1hcEE1?=
 =?utf-8?B?OGc1cHBrVm5vMWQ4VDBKV05jUDZFTkZ6aWhGQnJEdyt3Q3VXM2owc2tGT0Fo?=
 =?utf-8?B?bmN3WVdEQWFKTWozSHE2RmNVTm9UUkllMGg3QjJ4enVTZk1zaUZYcURIcC9s?=
 =?utf-8?B?aEl2cVhDSXhsblpBa2MvUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1VwSEN5Y1FwcmpSUS9MVXhiODJVWnVHTGxpMVVibnErV3Q4UFh3WFkrbW95?=
 =?utf-8?B?cmV2bWliWVZqK0VGemxEeHhiMXk3TGlQZnZuaXJMZ0laYlpEQU10b2QvTkk5?=
 =?utf-8?B?TkNZMGJkVE9SRVdzNDdxRHhuS28za2RjVHhBbG1lYjVtMXlpazcrd3F1a3Fp?=
 =?utf-8?B?WnJHOFdXUFJUR01reUFxNGVGbDg5ek9NbHZGMXAvby9qeXdyYW9GOCswYTVM?=
 =?utf-8?B?RFVjOURLTTJTbmxRYnBJMkRSNEpWVHBVYUw5c2FRbEJUK0tGdHZEZ0wrUEFw?=
 =?utf-8?B?dmVTcFJFS2NJRHdJOUdsYUhWb3FzYjEwM0ErY1kyNnVPOE5HaUl6Sk5ROXhC?=
 =?utf-8?B?cmhpcGtwcFREemZDcUdDYitYUDRCT1I4TnFLNWF4Wm52YU9NK1M2OCtBRGVZ?=
 =?utf-8?B?czc1Si9CL29JTzVJcncwSTZtelhPSnIrNGtvVllIOW1NY0U0VW83eFRoRFht?=
 =?utf-8?B?emM3Wk02THZPejArb1lYVWFRbEk3czdkKzk1dzkvTHFHZkNwcTYwN0M2NEZD?=
 =?utf-8?B?Q09OT0FPWDFTRVdrS3ZSYU9OQjdQM1RwNFUrNkJMbGY2ZXNabWZ0OVFudzY0?=
 =?utf-8?B?b1NFZGtiaEk5TTR4Y04yQ2NjMkVJelZPeWhTMnFveFl4TmhQQjA5Nks4RE5v?=
 =?utf-8?B?M3NVdDljQm5TalJRVHd1dEx2Um9zUm9ZWDN3ckE2bzRJWmVqcXZVcm1JUHV4?=
 =?utf-8?B?V0t5NUlSaDhiK0lTUkNWR1hUYUZFbnMxcVhHd0V1Tnh0c2NyZUlaa21nNnZq?=
 =?utf-8?B?NTY2QVNwMTlHZTZxUHNNK2V0ZUhQL0lIYjN0d2M3RWIwUWdOSzlkLzJCUjI3?=
 =?utf-8?B?TW9ab2t1bVdFVmtTWENaaWdnS1JEVEp2aCtHRStpUmZRUW5jRCtjSVIxcTVL?=
 =?utf-8?B?aGFvS1hiRnl1bVV0TjF4bDR6eVFwZzdHdm1PL3FIQ1BFTTl6L2xFaTBFS1FY?=
 =?utf-8?B?dTNBZFV4TDMvbU9TdVdvQWdXWis4Q2pBekhWU0E3Ni9ab21sUm5Ua1p2OGVO?=
 =?utf-8?B?V2p5Q2ZDU3NZZlZzK2QzT0RPelhZR0d4S1ptL3pXQzE4alYrRW5VUFZ1WCtl?=
 =?utf-8?B?QitKRmErcUhubDRHdkxtaTZySnlvUEhyZWpqWHJ2TkNXY1luR3N1a3NTMTNk?=
 =?utf-8?B?dzB1b3dHVnJZSENVQ3BrSS9FcXBCTDZHekRLbzNvcXRHWGE0Q0d4U05Wa0Rm?=
 =?utf-8?B?M1ltZGQzcWVtQml2SHNSeU5uRXNjMnh5blI2OExhd0dMZmdqSmJUZXNGUnhK?=
 =?utf-8?B?TFc4NUQ1VFBYQ0MweElBMjZqd09rcFRCREwrZU9kSEcvZ2kvU0tNazA1Nm0x?=
 =?utf-8?B?WHNiYVBNZzFZQnBLZVpNbjV0MWFQTHhKUXhJa2FZaDJYa2pOR2Q1Q3dxRzdD?=
 =?utf-8?B?bG5FcXU0ckFGSVU0cEtaS0REYmtlOWJnSU1vcndObUFySEgxakJrLzVHNS84?=
 =?utf-8?B?TFlnOFVZUG96RkEyc3E4amNYQjhycXFJWkZqYVI0N3NUOWdFMnUwQ3RQQUZ1?=
 =?utf-8?B?WUkzUldPM1RBRlhMRFF4OE1td25jZlVZSVdQMnRMN1lVZXpaQ0xWMCt2M3gr?=
 =?utf-8?B?V1M4WnZtMXpVL0VwaFFIMWVkZkVJYkFzZTdmcUR4YnJMakt2Rm0rdVB4RHJ2?=
 =?utf-8?B?V2dxSm9PZEVGRmM3VmhudDdDM0VCZzRuNXZ2dFBESndETERLMHNJanpxaVdB?=
 =?utf-8?B?aG9XREMzK0d4WGpoWnViby93MTRQSU1mbko1OVBlekZOZVozaVJXREVscUZo?=
 =?utf-8?B?ZlNRNUZCNStvTFZwblExNnEvSUVSNnNwbGo3dG9yNXQvMlRGWnkwTXFaNHlE?=
 =?utf-8?B?dVA2M0FNZWlOd0h2TWZUbTR0S0puRWM2dmcvSkNEcm5JcWVUc1NkeW1hWndY?=
 =?utf-8?B?WVVrU1JaV1B5WVlzNWltOWVHTnRuL1JsNnJyc0p4MjZqOXplUWxhTm04Sk9p?=
 =?utf-8?B?MzhWcTdQNlJKcDhNTU9Hc1p1ZFcvZGZ5SnFRdTFDR0QxZzdVdGRQRVFYQTgz?=
 =?utf-8?B?a2FVdWNRMjJKdFhGNEhxVlEwMFZpT25landGVHpkM2EwWU9ZVWcyUjNnWDZL?=
 =?utf-8?B?VDNYbG9jbFJXNis3a2UrVGkxeCtlZTNjaUt2alhwd0VQVnFwY1UxMWJ2eDU2?=
 =?utf-8?B?N0NrQnRBVVBZdzBFVW9OWGhma3Vlb2pFOTRQUlBqdjVCTFBYcGZXVGsvY09O?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 397f7f86-0f5f-4bd2-e3de-08dd3438c706
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 01:14:22.1763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQXa3Zi7CQbVcT+lieURx63mI08iy8NC7cds0o0ZvXWWlcwK97V2CY6BhD6sgTx9fFDzOyvW/iO8gF4x2RxUSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6698
X-OriginatorOrg: intel.com



On 1/13/2025 6:23 AM, Xu Yilun wrote:
> On Mon, Jan 13, 2025 at 11:34:44AM +0800, Chenyi Qiang wrote:
>>
>>
>> On 1/10/2025 5:50 AM, Xu Yilun wrote:
>>> On Fri, Jan 10, 2025 at 05:00:22AM +0800, Xu Yilun wrote:
>>>>>>
>>>>>> https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
>>>>>>
>>>>>> but I am not sure if this ever saw the light of the day, did not it?
>>>>>> (ironically I am using it as a base for encrypted DMA :) )
>>>>>
>>>>> Yeah, we are doing the same work. I saw a solution from Michael long
>>>>> time ago (when there was still
>>>>> a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
>>>>> (https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)
>>>>>
>>>>> For your patch, it only implement the interface for
>>>>> HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
>>>>> the parent object HostMemoryBackend, because besides the
>>>>> MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
>>>>> MEMORY_BACKEND_FILE can also be guest_memfd-backed.
>>>>>
>>>>> Think more about where to implement this interface. It is still
>>>>> uncertain to me. As I mentioned in another mail, maybe ram device memory
>>>>> region would be backed by guest_memfd if we support TEE IO iommufd MMIO
>>>>
>>>> It is unlikely an assigned MMIO region would be backed by guest_memfd or be
>>>> implemented as part of HostMemoryBackend. Nowadays assigned MMIO resource is
>>>> owned by VFIO types, and I assume it is still true for private MMIO.
>>>>
>>>> But I think with TIO, MMIO regions also need conversion. So I support an
>>>> object, but maybe not guest_memfd_manager.
>>>
>>> Sorry, I mean the name only covers private memory, but not private MMIO.
>>
>> So you suggest renaming the object to cover the private MMIO. Then how
> 
> Yes.
> 
>> about page_conversion_manager, or page_attribute_manager?
> 
> Maybe memory_attribute_manager? Strictly speaking MMIO resource is not
> backed by pages.

Looks good to me. Thanks!

> 
> Thanks,
> Yilun
> 
>>
>>>
>>>>
>>>> Thanks,
>>>> Yilun
>>>>
>>>>> in future. Then a specific object is more appropriate. What's your opinion?
>>>>>
>>>>
>>
> 


