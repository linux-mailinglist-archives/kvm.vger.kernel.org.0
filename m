Return-Path: <kvm+bounces-41395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC8DA677F7
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D23B27A48E8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA92021018F;
	Tue, 18 Mar 2025 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cVEaW6fZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D70820764A;
	Tue, 18 Mar 2025 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742312016; cv=fail; b=CmC8TbXoFfojUfqLqT2e61Jxm5gXf7C95p77iX4Hb73t44w7NoLRIfEudNVnxn2M7K4Gprkos/QqHzHmVmGf3S6bV0v6Dag4T+EZ+wO6ZMuHliBuYXbDu9Csz9L6UpRbAwGgzfAZBiGTNcKKb8tFIxQ+HtB7g1tYSJcXU2F3Xig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742312016; c=relaxed/simple;
	bh=MHsrUi2qKhS8K7zCWOAyaiun+Htf4WIaRdrMQs+ZS1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UaUzpBaI2n2bx0yHKpDinidKSK2xAp5PlFH5/fpkWenK7cEbuzF4+kmhJoLkobm90+o0N4s0CzpZnc8f+URBcCiJhc5OWkR+KuU89Wnr9Srx1EHbxjV8GFMxfFK9yQgsIMKyMWSJkCZbOvIX1c97zHnB1sTD7ZS4z8mMV0TYo2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cVEaW6fZ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742312012; x=1773848012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MHsrUi2qKhS8K7zCWOAyaiun+Htf4WIaRdrMQs+ZS1k=;
  b=cVEaW6fZRBlU6uJiYUqNZV7lisMGfRZ3N1gr8SheLlKLH1LWTfeRAePY
   8Qf9lUVLWVUl03hNjz72lRv4/RfEJMb3/xz4PK+Pgym0XgpdCxhLLtzAK
   CALZemL2rYTOHcWJAIOZYn8rwjJhFtoJFL+7SBp2bU5UblL4HXufsNSto
   EIlNccBK1RsdRs2Ui/A6BOE1OD7juhUUNeAYzbOB3Y2AI1KhHHXneVsp7
   IDZ00ca7jRCxzgSdIOXp1FR8uoybzTaAUVzb0D2lTjUc+Sj0xhOF9LbtM
   fvLnZZdpx5Z6kOyq1ZrYzBGWPQzQ1h/5xOlwWvxzfkuIa0x5UYbyLC9ka
   Q==;
X-CSE-ConnectionGUID: 9dXVvATpTZ+AcTT8125zzw==
X-CSE-MsgGUID: aBvUWx8bRX6rhjpVrYpqnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="42636375"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="42636375"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:33:31 -0700
X-CSE-ConnectionGUID: dWfv/F67QVGJ0xD3J7o/tA==
X-CSE-MsgGUID: 2XoaRGRsT6KkTRu7Z2D6EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122787057"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:33:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Mar 2025 08:33:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Mar 2025 08:33:30 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 08:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ECwDoROUUokty3MgZxWKQHXiYHdOPvmxAlhVqSTWmnRV3b7YBT6mCSmY1Vlf31OYoNjQufsd1KDcdHDW60y2RNCvVYLTTRR8OYo7aLirVmd92dQ5N70cEm+gm8azyHAFmImw7rHXTTThvbP+MFEQ7ztWIsTi0Upj/xppbPYfmsbUv/QVH49ORmd8DDsPwG3xAvP5TZbWfh4G8u+4s5wyceaG0tO0ne3TAszAjmGAkc4mkqUCje4FpOm2PgL+ygssfWsIDpkC3s1zOs7bQQFjORlBlcNC1AdegdDG9EdsSKedVoytdYUUB7jj22QtkrRbTfIaUgs7pG74D4kxL37SJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHsrUi2qKhS8K7zCWOAyaiun+Htf4WIaRdrMQs+ZS1k=;
 b=tmElOenZebO+sk7iJ+3DItiFM1zdhPrH2I9RMjFschVrK+MOXczsTy8O/bbIoo1MStvGAAO5na9hKSnYhR1Mavj46i/pPP5H90kxqihYtwJjR/g/e44J75MBmls3YgMlZgBK9471ed3TEHoePttT3TLrtH4KU79mc01+7hag/9zUhPSgP9NlHuWB1xLFgCAZTIpxpnHs3I/XszMPX83yLp5MFsldT+G3MDQylCRPDKLTHgJkIkrjTpFXh4QQ33885/TVFgla85I8OOp6/H6rwHM2r6KU4fldznUrJtpOSf9dfaNdQldxlNxX7GFcSmj8+8qlFf/lx1aHRWeeV1jnhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6379.namprd11.prod.outlook.com (2603:10b6:510:1f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 15:33:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 15:33:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linxu.intel.com" <binbin.wu@linxu.intel.com>
Subject: Re: [PATCH v2 1/4] KVM: TDX: Fix definition of
 tdx_guest_nr_guest_keyids()
Thread-Topic: [PATCH v2 1/4] KVM: TDX: Fix definition of
 tdx_guest_nr_guest_keyids()
Thread-Index: AQHbl9ABakHG6btZ1ka1cKrSc5qZ4rN5BokA
Date: Tue, 18 Mar 2025 15:33:27 +0000
Message-ID: <5a9335bdf4fbfef9d34c448d1bd8f075e56f82bc.camel@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
	 <20250318-vverma7-cleanup_x86_ops-v2-1-701e82d6b779@intel.com>
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-1-701e82d6b779@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6379:EE_
x-ms-office365-filtering-correlation-id: 81426006-c95d-4b8b-e82f-08dd66323a85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZWdhMko4MlE2VTlJQk55Smo2MnppeUtORTBSTms0TDNXSlpzUnZsQWhZUi9v?=
 =?utf-8?B?WldvRnd1UVBHb29qSFZSOG5XSlUwM08vNzV1MFpQbWhtVHIxY25tdzNvb1Za?=
 =?utf-8?B?eG1rNE1sdExVaTBxWENrVVNabWhlS01JbFNHMFpScGtOTHAzVnZOUFNGS0tQ?=
 =?utf-8?B?eFlxVWIzZTE4Q0xtcXJ0dGxjMGVEVTVXU2o1clNXSE9LbXNjRzhuMk5QdEFk?=
 =?utf-8?B?eWZ4Mmg0SzNFZkl2cXFFTHBwSC9nMStoaFJPMkNjRkR0RkFtRzdoRW5nWWc3?=
 =?utf-8?B?QVUvOElGcllYNk5lV1NKZ2tMTVY2SXNvUFNSYytqai9ZZEZURUhFVlJBdU1l?=
 =?utf-8?B?NGlMSmNZMFp5cnFqdE5jSzh3STBHRDlJRVNUbHEzdU50cDNUSXc2b3QrRzZL?=
 =?utf-8?B?MlJLcVloZTBTVXhWR3ZXT2JrNnJ2b0Y1bU9WajRVOHd6M3h3VFRJZlc5aGMy?=
 =?utf-8?B?WnJZSjFCaTZ1ZzNtTlEzR1pvVHN4TVNmbUlPa1BHUE00VVYwQy90OGZHRUxV?=
 =?utf-8?B?MXdYZnBJM2p4SnR3M202blNFME5sbmFlVnFSYmJYbjJRMVpuSXJwQUZ0SWtn?=
 =?utf-8?B?WVFUcXkwOGZGZFEwVy9ZZVRzYzVhcjNEaS9vS3VWNzU0YTBUQkJtVGpXRWpY?=
 =?utf-8?B?MDh4OWF6VU5pNVFzQklGTmdrM0hFOUZhR1dpSjl3TC9WOXJIYTF0NFJ3ckVL?=
 =?utf-8?B?UktBUFlldDAxTS8zUk5zS3ZvYTVXaTVQcEdpTU9rN3VHVi9XN3Y2SXFLUnBC?=
 =?utf-8?B?akg4MC9iaDMydlA1SGl5WW02S2RjeWthdy9YbVVQbHNwaUZwZWh1bWo2ZCtB?=
 =?utf-8?B?eWlOd2ZPQWtkK2lsZStDSmsvTGVhQ3pqSnNuNnFNR3lPbEZRWWlhbEVIa3cz?=
 =?utf-8?B?WVFvemNkV3d0RWwybVJ0ZEkrVlY4MzBNM3BzaFM1Y2N5ZWozZUN0blRGVDlT?=
 =?utf-8?B?d2lJSHhBaVJkQkpDb2J5Tm1BNVBTb1ZCM3l2RmVWSHZxbVZPL0dJOEhCMStI?=
 =?utf-8?B?SURlSW9hQkJ3TEZKU1VacEhTSEtRSWxmaVpXeXBBZ1EyTzFBWkt5c3RjTVlK?=
 =?utf-8?B?OXIvay9nMVJRU1d3K0xHYVRUYXJRdnhHU0tIeHNQVFV5OTVJdmpTRzJ2UGtw?=
 =?utf-8?B?MTU1U2VmUFFHMVlMZk5TaTVIOFJPbmJTMDhkbVFhMGFYVW5uMTJjWWY5TkRD?=
 =?utf-8?B?bWhRWUxkMGVJeXpPaGJGaHFaNjZoeU56TGRiOGc5cFZPdEpZa0thU2ZCV0NZ?=
 =?utf-8?B?dk05V1o4Q0N2dU93SkFodXd3NGc4bGhqZlpGd3B3b2NSWGxIZEVyeXliS0hx?=
 =?utf-8?B?SkU4YnJtZTVzS2FhalIxM2JJczQxTHVTcEpmaUVub3hwdU5lR3JZZHoySEdR?=
 =?utf-8?B?OEFqazlRUXdkVG1xRi91a0VTQ09MZjlpdXJNZjVYaWZ5N2E0WjBFM3BxT0xw?=
 =?utf-8?B?QUhaTWtheDRaZjh3MzlPWStzK1BjZDdxVUk3RDU0ZzB1RVZUMzcxWG0yOHFM?=
 =?utf-8?B?TkRKTE5sZDdBNnhyakhSOEp5OHFTWFhBYnd6b2xUb0RFbmdoVlozSEgrYld5?=
 =?utf-8?B?WGc0WlZYRE8ybHFtWlV2TmtmYklxU0IzbXQ2R0RVNjV5T1JtN3N2QjVRZEVu?=
 =?utf-8?B?RHhjanNidVlaMGpMSU82WENFTXlnelhqaDZQTlRBUnp5QmhJRWtHV1AwRlFr?=
 =?utf-8?B?blJBa3RqeGZyZ3NhVFUyWHF2R0kyQld5THJTMVFrUFZmMkNYOWt4R0lHVnZt?=
 =?utf-8?B?bzZBeUo2NUkvcDhOV0laVnpDR2JhUmhidDBQMkVCakwyMTJuYzl4d0duMXY1?=
 =?utf-8?B?NUwrZkxBVzFOczJnZUk1REdLckptbnUrT0NiNkgxVUNVWHg5emJWOTJyQ2dj?=
 =?utf-8?B?T3RxdU92N29VaWNYdlRxeDVOT1N4WFFhYmc3dlpoU1hkK1QvV3ozR29qWjJX?=
 =?utf-8?Q?gUEtRQnin1CDK/FD+RPlgA7MU9D1TFri?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUtLbktOOVFGK2p3MUw0MnNJUks4VXowTm1GeFByWU5IQ2pnQmFoZ2pwRi9z?=
 =?utf-8?B?TFBvLzZaeVdRZWRFbUJFd2syZUJ1NHZ1S1FYaHRWOFcxRnNHNmIyY3poTFJs?=
 =?utf-8?B?bUR6U0Z5R3lFdmYwditvTVhKVmlDVWZsT3VRWnV6ZUk0c25BWHRtVExNT0xH?=
 =?utf-8?B?MllRQ3VINUdub0xJcSs0MFpOK3FsajNuRG5ka2pIVzh6OWhQVklGVG5ka0FW?=
 =?utf-8?B?NFFTL0hmR3pjZUNXZ21rYVl5M2JQeUFhdlFQdkF0YmhtdmRTcE9VUUFhMFdR?=
 =?utf-8?B?YmU1SWMza1YwcVlZdzhtdEY1bVEzZVFNaGVJdE9SZW8wOThGYjJTcFlEaU9R?=
 =?utf-8?B?d2d3OUVNUFE1aTJHeWlxZk02YlBxT2NsbXdJKzhITGI2WXhxQnluMTk1V3lu?=
 =?utf-8?B?Z1RUalNpS3hIWnFzd2htbG9LZWFFM2k4OXN5MjgvcVJMdzkzcHZzZmdKWTlp?=
 =?utf-8?B?WUpNa1NXSXFzV01XQ0ZZSlBWTWhJRmZUN2d2S1I3c1pNSk5qUXUvZWU4SHdp?=
 =?utf-8?B?aVNsSEw4VXFMZTJ4MjdMUmpUVWpFcGo5ZGswK1JIa1hCcnRMYlBId3ZBUCtp?=
 =?utf-8?B?ZHBzR2JuemNQWnZMcUl1YnFnSTVkcFUvbzFMTXk2dW53OHhWNmRzMzNWelFF?=
 =?utf-8?B?VTc1TTlSYy9IUDR1ZXFxV0YwOU9pbURaU2JpQ2ZnanQ1WmZxSmJsanI5WWNs?=
 =?utf-8?B?UUNxWDdRZ3F4dWdxbzV6MitRZTdHMTBZbnZFQ1NsMXdFcjk5T3NYTVFnYWRp?=
 =?utf-8?B?U2gydUtlcGEvdkVDYTZ6c2plblA0QkhRUU95b1N3TkEyd1M5azdVTVBJeUI1?=
 =?utf-8?B?eWNxbldsb3IwSUp6M1NyYkd6dGNzb3VmcVdCeUJTM0FDMmx3ZWlJdHhKWmFq?=
 =?utf-8?B?QlRMM3orYzNTbXVMdHNCOXprQ2ttaXhoNkMwQnlvSWtEUHN2ZENlYm1PMmZI?=
 =?utf-8?B?a29mVTRKTGZuL0thMCtlNHNBd3dyeFFwMFJvWTZoemFiamJlWHdIRS9YQ0FQ?=
 =?utf-8?B?VUdTUG1QemVXSUdJdHplRFBwczlGZ0h1L2UzTUErVlNQYXNub0lXaTJ1N2o4?=
 =?utf-8?B?WUhLQnBzN3dwbXVoVkFFMTlJT0kwOFAxTC81enhyTUdhcE51b0Z3TWFDbVVF?=
 =?utf-8?B?TDZmcmVkL3VwVUVSZG9aSVlLM2JIdkt6VXdHL3d5MzlibGxDeWJpRThzd2k2?=
 =?utf-8?B?ZW1RdXM4VTI4Vm9DaW9XY1FzL2pIK1Q2QkR2UGk3QXZNRko5bGF5d2xJL0Ni?=
 =?utf-8?B?bkE2WHk1WjM0ZVNoUlJDZmQ2YVBtYWJtN0VneXVTMDUwbUtSZkRVT1dFekp4?=
 =?utf-8?B?bHB4T1YwZHAwQkhjbk1zZTZsdUJMajlkZjlqZ1ZhYlBzWGYyclB6SWVnRWlM?=
 =?utf-8?B?YVJUbXZ4Wm1SUk5yd0gvSFUrbVV0M2tEbGlKenEwUkw5aG42RnBBRHd3V0Fa?=
 =?utf-8?B?YnNqMWlUNXphUUhQd3hwMjQxbm9wUzkxWnRXRVFYT1h2Zm9WK0lSZkhNazFD?=
 =?utf-8?B?M0RwTWJMN1dMSG01cFdVNTU2RUN3S25Kd0U2TTVuZ3FhVXo1cFpxNVpTUzE5?=
 =?utf-8?B?SkUrVUlyQjErZ2NYRlRoYzNSYk1MY1ZXSm5mR1k0QzgzNFcxZkdQNDlONXVG?=
 =?utf-8?B?LzlLM1ZiTTFqRC9ROWhEMmI3cHNEUkFlSHlLZ1BvN2RGa1RUYjMwalNDbGxz?=
 =?utf-8?B?YWQzUmY5YWNXZnZPS3k5QzNxWlA0RkNHbUtjczhla1JkSGxEaWFtczdBTjZk?=
 =?utf-8?B?NklFRk1lTW5XQktFTDNLYm1uczdXSjZKOWN3SWZDYWh2Mm0rY0lHWXNQV1F3?=
 =?utf-8?B?UTNRQ0h3VmVma2wwbHUyYzBkVytOaTFEOEhlQ1o4VHZBWWRnc0dyVWE3VHA1?=
 =?utf-8?B?L3QyRkFZZGhwbUpBUXMwdjdrNExwN3dFb2F1blRQWjNaOHNZOGIzNUhtSnhk?=
 =?utf-8?B?V2EvQjQxUFpQNjZwVGVuaEs2NHErK0dLRFZTSngwRjhodk14aXIxdGp0WURs?=
 =?utf-8?B?Z3BNdDd3aEp0T2pNdCtpQWk5c3FGdTlGclgzVGFwckRia09IQldxNVhidGtu?=
 =?utf-8?B?c2NBeHRlT1pDTUV5WEtWbmxSQWlqVGtDdWg4T0ZUSGpEOFZzSFMyRGswOStY?=
 =?utf-8?B?cTZlM0RBNmhmRVFaNy83bXE0R3hjeTVrNjErcWtGNW5NeG9McVpQTjl5QXE3?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EC91ECCA4391E4E926C9ACD1BB3372D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81426006-c95d-4b8b-e82f-08dd66323a85
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 15:33:27.2150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f6B5RIrR3MQeWhH/y5MObeUdMQvCvmIo26xiPjCix5LraLJWn1Hv8er6pLbSiaN/0YS8PYxoZFd2NLYkf8gjyOpE5p6a7QpY9289+7xktvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6379
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTAzLTE4IGF0IDAwOjM1IC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IFdoZW4gQ09ORklHX0lOVEVMX1REWF9IT1NUPW4sIHRoZSBhYm92ZSBkZWZpbml0aW9uIHByb2R1
Y2VkIGFuDQo+IHVudXNlZC1mdW5jdGlvbiB3YXJuaW5nIHdpdGggZ2NjLg0KPiANCj4gICBlcnJv
cjog4oCYdGR4X2dldF9ucl9ndWVzdF9rZXlpZHPigJkgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1X
ZXJyb3I9dW51c2VkLWZ1bmN0aW9uXQ0KPiAgICAgMTk4IHwgc3RhdGljIHUzMiB0ZHhfZ2V0X25y
X2d1ZXN0X2tleWlkcyh2b2lkKSB7IHJldHVybiAwOyB9DQo+ICAgICAgICAgfCAgICAgICAgICAg
IF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+IA0KPiBNYWtlIHRoZSBkZWZpbml0aW9uICdpbmxp
bmUnIHNvIHRoYXQgaW4gdGhlIGNvbmZpZyBkaXNhYmxlZCBjYXNlLCB0aGUNCj4gd2hvbGUgdGhp
bmcgY2FuIGJlIG9wdGltaXplZCBhd2F5Lg0KDQpUaGlzIGxvb2tzIHRvIGJlIGZpeGVkIGluIHRo
ZSBjdXJyZW50IGt2bS1jb2NvLXF1ZXVlLiBDYW4geW91IGRvdWJsZSBjaGVjaz8NCg0KPiANCj4g
Q2M6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBDYzogUmljayBF
ZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBW
aXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaCB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gaW5kZXggZTZiMDAzZmU3
ZjVlLi5mYmMyMmJmMzljZmQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Rk
eC5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+IEBAIC0xOTUsNyArMTk1
LDcgQEAgdTY0IHRkaF9waHltZW1fcGFnZV93YmludmRfaGtpZCh1NjQgaGtpZCwgc3RydWN0IHBh
Z2UgKnBhZ2UpOw0KPiAgc3RhdGljIGlubGluZSB2b2lkIHRkeF9pbml0KHZvaWQpIHsgfQ0KPiAg
c3RhdGljIGlubGluZSBpbnQgdGR4X2NwdV9lbmFibGUodm9pZCkgeyByZXR1cm4gLUVOT0RFVjsg
fQ0KPiAgc3RhdGljIGlubGluZSBpbnQgdGR4X2VuYWJsZSh2b2lkKSAgeyByZXR1cm4gLUVOT0RF
VjsgfQ0KPiAtc3RhdGljIHUzMiB0ZHhfZ2V0X25yX2d1ZXN0X2tleWlkcyh2b2lkKSB7IHJldHVy
biAwOyB9DQo+ICtzdGF0aWMgaW5saW5lIHUzMiB0ZHhfZ2V0X25yX2d1ZXN0X2tleWlkcyh2b2lk
KSB7IHJldHVybiAwOyB9DQo+ICBzdGF0aWMgaW5saW5lIGNvbnN0IGNoYXIgKnRkeF9kdW1wX21j
ZV9pbmZvKHN0cnVjdCBtY2UgKm0pIHsgcmV0dXJuIE5VTEw7IH0NCj4gIHN0YXRpYyBpbmxpbmUg
Y29uc3Qgc3RydWN0IHRkeF9zeXNfaW5mbyAqdGR4X2dldF9zeXNpbmZvKHZvaWQpIHsgcmV0dXJu
IE5VTEw7IH0NCj4gICNlbmRpZgkvKiBDT05GSUdfSU5URUxfVERYX0hPU1QgKi8NCj4gDQoNCg==

