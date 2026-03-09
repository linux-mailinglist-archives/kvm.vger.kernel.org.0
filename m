Return-Path: <kvm+bounces-73332-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6FZ9Ftb0rmnZKgIAu9opvQ
	(envelope-from <kvm+bounces-73332-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:27:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C250B23CB0F
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 419FB302306E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 16:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD263D75A1;
	Mon,  9 Mar 2026 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REPAi9HV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A273D3016;
	Mon,  9 Mar 2026 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073526; cv=fail; b=dEtliYc1n7Z5vX+PY6MKgCc2un/npifpg/zxGnnQTHCvXe7gklE1PIz/lM4Fy+buq9M7tKttZyC3WbIj17oeLw6tdSLVMaDVt2Uq+9QP0cwG9yRh018DfFxqw/mYxLPiBM80THO9l3KrRArJKhip6NfcEpg953zL5m8HclK56ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073526; c=relaxed/simple;
	bh=kPBp/CiOH5iiXQJ1Rkmq+bQYg+1o0vlrcUzhbsGP0f8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VP5GIGPHaeNmvoq1lteHH/RL+2qTIyi29Ks3csg4HD19RtjKS/RVRc7QwQnaBAq89j77VQryFW8IWOgBuoYF21ipbAJG8MSobJoOBI+fWtet1Xzv2LHNhXKH8MJUEqvLEhisaObWMbjDdRD/mz3pGdv+5zv7TEpfEqesDmfxUX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REPAi9HV; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773073526; x=1804609526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kPBp/CiOH5iiXQJ1Rkmq+bQYg+1o0vlrcUzhbsGP0f8=;
  b=REPAi9HVHSvfvztjQlNzTEfJqT48IVewJWM3U1Xvz0HksU9Bi0stanux
   PVjvnBbP7OUjIUkN6jQOHPInuzpgY2k6L/xtDCuVPIcRgNG+hqpbzfgDU
   LljG3BQbeCBA6IP8QXZ7D73CUJFEny33QsJsRp84d/Qv1VMVTjMESOPM7
   qa2XE6GuEWbdra06ndJsOCjkvKEMD+EmNCURcOhiNP2Z7KLclDPNkKm4X
   DSQGQ7bBcTOTAmcS83KvAiNnbrBELOi4ZpMnMu25o/JnHUClzr3BG6Zp8
   eDFY92HmoBfIUhOZWEnGSry8mU5vQGiLY55VXcXU1b1TeFRxbUHKh4dnN
   Q==;
X-CSE-ConnectionGUID: d6lEQctxSCmuRzUfImGn8w==
X-CSE-MsgGUID: +UNudiCkQ2a77zhkQ1k9Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="77953655"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="77953655"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:25:23 -0700
X-CSE-ConnectionGUID: dXUdG82TSwq5EBfVaTxYGQ==
X-CSE-MsgGUID: ZMBeoZZ/SD+daQ95IFdydw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:25:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:25:21 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 09:25:21 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:25:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deoRRZrFFiHoeeZG9znP2KHESiMXFysZivzVF+O8Bh5odacV83xX5dnwIDolrsuSk1Y+dN3clQ/YEs9hyqLSu21tEkCeC8xLCZ84KL2v46efdAjx5Vi6KYSDqZNYjeSEx2c8fK/FW0JuyZ06sMvl5ZmBulTVyAPy4KPY8HvPvi9KkABu2LOn/d/Y10e0bi/IuKX8VOBsKzAi1YX+aXt6yXDFpbL2FASqULVm4CfqhbOsyD6r1NzgPAB3mt1gsIcTPz6EyJcvztal5J+g/XVNGrYXeULhKLui+5HfEnIZyqjlJ/2hlUdt1IjjWzxtwxgAHJ5PdkdZl/rt1k4ksiaL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPBp/CiOH5iiXQJ1Rkmq+bQYg+1o0vlrcUzhbsGP0f8=;
 b=yv7u7aLjFkPM3xammm0sdEzsdmSUgP+5RF/BylUyG0rEyyI5HWTl9Bv9Ya/9cjx7lJ8cIg1j+q+clmR2upCWaPLhJEBPIwFAJyKgEhHlB3/Cijr9Lgh19T2VBUNhilpGDH0rifkh1H0npg+9AvVV7xoL5UdmQKh0gLtvyfzfcy7otdpgbPrmp+YpB+koQDlyFoYynW1AWRu8J+uMAmDXcILU2EK0pZ+XxckNt7AG+MfiI1BGzdfAGfK47iCGTulmc25/5u0Ymq03hK8AvtN2gdYJaE2khSMsI2byxHwmYnRhzfZ/tQ3yeViHd7i8CYFrVUGG5wgZHsh41daKXEF3Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.5; Mon, 9 Mar
 2026 16:24:54 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 16:24:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "tglx@kernel.org" <tglx@kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>
Subject: Re: [PATCH 4/4] KVM: x86: Disable the TDX module during kexec and
 kdump
Thread-Topic: [PATCH 4/4] KVM: x86: Disable the TDX module during kexec and
 kdump
Thread-Index: AQHcrc5SsEQ6LslD9E6tx7zPl9pXX7Wl3iAAgACJOIA=
Date: Mon, 9 Mar 2026 16:24:54 +0000
Message-ID: <16277002cfd6297153a61775919d721c477727b6.camel@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
	 <20260307010358.819645-5-rick.p.edgecombe@intel.com>
	 <aa6BmJzypU1o53rB@intel.com>
In-Reply-To: <aa6BmJzypU1o53rB@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5880:EE_
x-ms-office365-filtering-correlation-id: d4cc22f1-a450-430d-52ec-08de7df865c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: VVDMQDuASayc5W69f2F/ypu8env8EFO9K6FDlvRRVVNWpanpJfE0dKTbXIwb3SNF3G84mBwOWLvp1drzJZ8hHUef4zimC2kU2t0kvWX5TFmAscfJ2+O+3cKkdZep8hHftF8FPN74HcP34o4ZSA0mVxH/YRMdyEuV7EvhRLt2bqZL5AAw+eko4kZYJ9isgHNWnbnZ21n4DgMfkuyBJ4Ey1iuuzPHYcqO5KUNXWfXEfaZyeQCP+77rmr/2Pe3vyTyajY7kdoZQH8eJt7WJjhtswQC1Ak0MOkaWyt3h4nmt2t9PKRzXWyuKmT4B20UyKnCC7+Yrlx/M6ngECN+3kVrNjPLo9ljtf2LD6LiB1rUfEvsJJLa4UwgEvLO3JhLv8JlWeB9E+hn4lxnsdfL0Hj5DbnuS1/yOW2a2BP7VlSX4tTgeq9f6UR9aL2Kv0bXEZ75KmzAqfpbJUq+Vs7DNvT0Bv0gx0/bZ6LvvzL8lC1HF1xQpGk6GLymmoBjY0TZOr1nEed651eJsDy4jaoW+TlLXu8Qeu6iJq5j3APN2mJZWEslEchKvP29GPbWUbyvwGSdzJyhaslPjEIjTAPPeicS5GgcY49MMhTZw31919/mM2MPkG3NXQv3p/8WdiTCpGHsVIgNlrMJQszUlfQhV10grq0MgThVPtWCPVliBQy/OTsWJ3cFDprIiemRwUbg6SS4TMenLhksbf9lvew1ygcNQiKOddgyhhZRtzWbGpW7RBAPgOGV1OqjlQqvZVI+2kVeQh7MJz0jRc3WDE9GycpkMOMGRBSTH196EAe5pkD4L3R4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFAxQWpqdnI1ZDJERGVRdlRKeTg2WDdXNEwzRHlTQ0RWK3I4bW5zbTZNUytq?=
 =?utf-8?B?UTMrNWlmQmp6bGFRdHZpeXpOczl1Rjg1Y2pmK0dVUHNJNkJYV3dKY3R2VlRS?=
 =?utf-8?B?elc3MmRGL0dwUW1lb2lOSkJHUXR3QjJyWGhXY0gwOHltK0Y3b3NxRDFLRTdp?=
 =?utf-8?B?SDdjQ29CRnZSNWlDRVd6bXB5SHhvSEt6anJJaFFWMFlseWtiNmRxdE0vT0Jm?=
 =?utf-8?B?bFE3SWM1MW53T2xKamc3WGZuREkxTzhVMGEyOHZTSjVOWFEzdDBIYnlndVhn?=
 =?utf-8?B?SVlNc0RTbktTMkljZUR1THo2LzRvSFlDTHdGazI4TDVlZGNkbnNZbHRyd3dM?=
 =?utf-8?B?eWxPWXZWRjc0c1JJdlV6WUJqd1EyT3d2c1QrdUJFcEtsV2QzRE5aK0l1TjdD?=
 =?utf-8?B?VE0wNTNQa3psUVNCZHZ6ZVN2MGRFTnJnTytDSG0rUFlsYTF0ZzJNYXBQSE13?=
 =?utf-8?B?VlVjTVhaaFN2cERCTEtwV0c3NVZoQmJnOGRPcGFYUFFHQk5sMDg5a0Q4UXJF?=
 =?utf-8?B?VlJYb1kzN1B1ZzhGTFlaVWFkWWthMFF5aWQvcGVLd0t6SU4rNm9jUXRqcjNJ?=
 =?utf-8?B?anZPd2NmbHB3MUtuN2xJRU84WFRBbTNSUFEyYWlFVWVSdDlFREpKNHIwN0dX?=
 =?utf-8?B?SkhFSUU2SHdxZ05OS1JpV0pWelhYa012N3BoZU40bWhoTXNFOGpOVHFueWJD?=
 =?utf-8?B?dWJTRFFXRm1ydmNjdXg3QXhhMldhUjJVQnBxd1oxbUVrbWhqMXJYbXkvNkls?=
 =?utf-8?B?ZW5yeEJLYXhqdTJkUFBTOWFtRG1zOUFJbjFocEpRcHp0QkIwKy93VEIrSVZT?=
 =?utf-8?B?bmJVckNvVlZLa202RFYzZWY3S25iemZ4cmp3Y3VFWmlZanAwUEhjNExLdTZz?=
 =?utf-8?B?YWxPTVlrQVE0ejZHOG9BTVIxRU8xUWZQVXlOZ0R4VDlPb1h2b05zNnQ3YnFQ?=
 =?utf-8?B?M2VKalJyWUIwdmUydTRqQUJLVzdrajJaWEVVWWZrU2E5Y1JnMWE1d2hqWTRt?=
 =?utf-8?B?WXNHZ0lVcEVPN2JKSnJOTmZ3ZFh4ZkM3VVVDYnVUcUlvUlk1Rnh5OWJ1em9E?=
 =?utf-8?B?ZHZCWkFBbWlxMVRNUDZKYzZoa2xzcm9wTEJiV3p4Q3ZiYXRrRjBZdjc4ZGta?=
 =?utf-8?B?OE5qMHQzcG83a3dQYlFIbkYwZjRwZE5uVE5VZTFZMG5pMi9pNEMySXdXbHJ4?=
 =?utf-8?B?c0tvUlJkZFRGNnZ3KzJjZzFDNHN3ZFNROUNjMG5TUStvc3dqcHM3b2ZBNkk4?=
 =?utf-8?B?Ym5BZjFwNE83OEVrRTFuWmtacUM1VUVvajJWTWlBbG9qdGhEWjk1a3pwaGRH?=
 =?utf-8?B?enJva3VKRThuQXVpemN1d0Vuai93R2MzL2s3V25QMlk0Wk9Rb1BqQnBxLy9G?=
 =?utf-8?B?MTJYK0o2MmJQeCtFTmVmZjU4TlQ1dWFTRXhCWFlLenowQ1RrZ3ROMlJkb3FP?=
 =?utf-8?B?YmZDTTAzcHNQc0ZPT3FrMlZSejNESWNXY1V0S1lrdVhGOXhSZ1ZUNVcvZk5Z?=
 =?utf-8?B?Z01ma1BxdXRXd3QrTCszeGQ1YTJ6VkZmakpqaW5uMGsrK1YzckYwSnhMTHZ5?=
 =?utf-8?B?YlZ6clR6K0V6UmE5cCt4aHl5ZGNqQ2VzSE9iT1o3VlRPN3Fkc3RveDYwcjcv?=
 =?utf-8?B?REhUSzNDM0MxdFpJbzk1WVUvbnB4RXEvenRGSE9VUG1rNnpTb3FITENLc1pk?=
 =?utf-8?B?am1Lb1VsRnk4OSsrSkljbGRxNHZnNVpoTHdnUW15cy95dWtzUGRTVTZ6MnJG?=
 =?utf-8?B?NXRGaDFwNU0rZVNEd3pnT2IrU1I0THhrU1VSRC9wQmdEbFVVdTZRNkZ4dU10?=
 =?utf-8?B?azFSaGlpZWdlY3ltcW5Qc2dVaWZPUXUwUkFxQk50TE1MN3VsWmFlazBNTU5Q?=
 =?utf-8?B?MSs1YmFua3ZHYldjS3hUV2JzNERlbEJkS0FsS1ZOWjlpRG9nQ01ybFRUbFhH?=
 =?utf-8?B?VnBZSjBjd0FEMWNaM3hoaWM0dktJVmhQVFFSQm9ycmRZNzBUV2QwV1ZCMWFr?=
 =?utf-8?B?L3ZSb3crc0dMbXh2ZWFuM1U5RGdPcHdwOWFoZEdzdzJOMTdHd0dDKzlGeTl2?=
 =?utf-8?B?b2xYYjBkNGcrTGZRWXFLb0dNUkFCYmtGYXJLYVNCNEVNMTZGYmxqYmhYZFZT?=
 =?utf-8?B?cXNYNkwzUDNvYThEZmMxNEpjaG5VZVlhaXprTElvYzN6Q09PTGRmTlEzaFE1?=
 =?utf-8?B?Vy9KcEJnTDBtR1NoRUpNK2pIN2d4RzRhN3BMUGxaTnVFK0h5djJqTVZ2b0Y0?=
 =?utf-8?B?c1JtTnFzaW13MDBYeU1iVkFmeTBTVjhMTWVrK2ZYMXRFMnZSeFliQUsyWGJJ?=
 =?utf-8?B?QitoSVBVamNTSVlqdGN3aWR2K3pzZk04WVpDaHdHLzZ1Rnh2VjNWcmxLS2RG?=
 =?utf-8?Q?5rG9MFAsf7zlBGbc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B678D24CB54A9F43954EF8FF069B61A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ElRvJDW6dzAR/+GUg7dDRJI9krgTjYTauwjux/wZ9fvbm/XxqQZKm8JMIpmhmA5UTw8SVHR4W7b5H4V65lSEtmk300Vjnl5ABODdKJojWB4xvCkEIyPNBMmqZvxYXEj1mhPjZRz58ycZpOamXU5QyZUmXpYT/vMASwQmgH4UZNwfg56MunT38f5GfolqDhG1JkW4PePKN3roShkDbX62TWprwm4hbjnUAGdpsAf5yX/l5BJLtRoiyv/58vETQjLHrtsHSHGc1fks23BOJCEVEAP0q/H/JcKpMNveWqVGZEgH0rWZoWu0PwGGhEg4rbKQ7bwIW2bKSv+64cnktWggqA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4cc22f1-a450-430d-52ec-08de7df865c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2026 16:24:54.5730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YZOstJ7Cjs5T+Zq4F6gnhro3N8nM5OqdxH4YlbGxuUHghSRW6dx2uhdTxyaVjighajIbekJPPjHfA5+T0RVyVSoHk09sXjC6Dupxqrm62w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C250B23CB0F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73332-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAzLTA5IGF0IDE2OjE1ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAt
CS8qDQo+ID4gLQkgKiBTb21lIGVhcmx5IFREWC1jYXBhYmxlIHBsYXRmb3JtcyBoYXZlIGFuIGVy
cmF0dW0uwqAgQQ0KPiA+IGtlcm5lbA0KPiA+IC0JICogcGFydGlhbCB3cml0ZSAoYSB3cml0ZSB0
cmFuc2FjdGlvbiBvZiBsZXNzIHRoYW4NCj4gPiBjYWNoZWxpbmUNCj4gPiAtCSAqIGxhbmRzIGF0
IG1lbW9yeSBjb250cm9sbGVyKSB0byBURFggcHJpdmF0ZSBtZW1vcnkNCj4gPiBwb2lzb25zIHRo
YXQNCj4gPiAtCSAqIG1lbW9yeSwgYW5kIGEgc3Vic2VxdWVudCByZWFkIHRyaWdnZXJzIGEgbWFj
aGluZSBjaGVjay4NCj4gPiAtCSAqDQo+ID4gLQkgKiBPbiB0aG9zZSBwbGF0Zm9ybXMgdGhlIG9s
ZCBrZXJuZWwgbXVzdCByZXNldCBURFgNCj4gPiBwcml2YXRlDQo+ID4gLQkgKiBtZW1vcnkgYmVm
b3JlIGp1bXBpbmcgdG8gdGhlIG5ldyBrZXJuZWwgb3RoZXJ3aXNlIHRoZQ0KPiA+IG5ldw0KPiA+
IC0JICoga2VybmVsIG1heSBzZWUgdW5leHBlY3RlZCBtYWNoaW5lIGNoZWNrLsKgIEZvcg0KPiA+
IHNpbXBsaWNpdHkNCj4gPiAtCSAqIGp1c3QgZmFpbCBrZXhlYy9rZHVtcCBvbiB0aG9zZSBwbGF0
Zm9ybXMuDQo+ID4gLQkgKi8NCj4gPiAtCWlmIChib290X2NwdV9oYXNfYnVnKFg4Nl9CVUdfVERY
X1BXX01DRSkpIHsNCj4gPiAtCQlwcl9pbmZvX29uY2UoIk5vdCBhbGxvd2VkIG9uIHBsYXRmb3Jt
IHdpdGgNCj4gPiB0ZHhfcHdfbWNlIGJ1Z1xuIik7DQo+ID4gLQkJcmV0dXJuIC1FT1BOT1RTVVBQ
Ow0KPiA+IC0JfQ0KPiANCj4gV2l0aCB0aGlzIHNlcmllcywgd2UgbmVlZCB0byB1cGRhdGUgdGhl
ICJLZXhlYyIgc2VjdGlvbiBpbiB0ZHgucnN0Lg0KDQpOaWNlIGNhdGNoLCBhbmQgSSBhZ3JlZSBv
biB0aGUgb3RoZXJzLiBXaWxsIHVwZGF0ZSBpdC4gVGhhbmtzLg0K

