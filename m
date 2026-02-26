Return-Path: <kvm+bounces-72090-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFPnLpu2oGnClwQAu9opvQ
	(envelope-from <kvm+bounces-72090-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:09:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E34431AF7A1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2B106303A278
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00199394483;
	Thu, 26 Feb 2026 21:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jJgWQu9r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2B2236F7;
	Thu, 26 Feb 2026 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772140102; cv=fail; b=oyvpE4lpHIgR35GBAaHANvnCfyc0JUMRiDMyblEevCvCHi3ndI2D1c6eFKN411yIxfQCl8tZSta9TnJP4vG43jstRUIGi0eRZ0B/NkC71FpQPTonF4XWxmNxRerOydrKw+OF6cQU1zV9Iit4E4F0DlBOOIyKJzEB0+9k3850ug8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772140102; c=relaxed/simple;
	bh=vw3Y914Y7iJhtDBpadYUxwUcHJ0FXNuHp8CmGHxDL58=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=pc6xoUPPZNnyszG+6skMk+ujAd+ZKODhCT4R3VTnKAmfF2tqu73TsI5D4rI2dq6td2k00Y3TGRryk/BwcWynryuKdlcFv0MyoQ3JL5572W3tW4K/ZPBfR8HRJ/GIJiOCfF10YqrX4ZBaXLyaNnV6Hjue/V6P3W6cXv1QEwCX+Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jJgWQu9r; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772140102; x=1803676102;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=vw3Y914Y7iJhtDBpadYUxwUcHJ0FXNuHp8CmGHxDL58=;
  b=jJgWQu9rNQSYT6bEbjh2LUF7AHWXLjAW43BHX1cDuaTzMDTJo8KFxe/V
   IAVmN2gNeiAEjkXb6TFf0GKSBCOvz2MoSTMoF/P0owmCVG2zYVM85kUfW
   WPUa/ESBzoKJuG2CY8RL5uBuN5WuwnxnNmNVOLLVy7VUBHdmxasCLP1R2
   PEJMY1xHAj/f1aUVbQdijxHDdJ0EwpwuHu95TFJVuM0eOmTZezX5dEQOW
   UKLbcOkcVBg+guH37q3NMiYkH7YtZx17S6Ad+pYaLosaLv4vNI48Izi5y
   nVxbD2UvHfpCtLqb1P7CA/ug6lAB7PKdM8w1PZxdslIC4QynHCgh2sJkS
   Q==;
X-CSE-ConnectionGUID: 1f6tSDs8Sbm3pR5gS0RowA==
X-CSE-MsgGUID: n08oew4NT52yw3ExA7N7vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="84676638"
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="84676638"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:08:21 -0800
X-CSE-ConnectionGUID: YKPYrapwThm8erg7MgLFUw==
X-CSE-MsgGUID: WEb1E53qTuGfbL24dmiZkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="216600026"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:08:20 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 13:08:18 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Feb 2026 13:08:18 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 13:08:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzfoevCw8bkj3p4InbtwCGSF+K/3kDxeh+hFJ+6kjqFEHkHc8rOFc4oIQEcA5mYjFBXjgEcVr2yU2dCfFTbMRiwO5lxYmxrAFBSjJF6JQy70/Ny/XGcU0LaqHFxXvS3/GuFBbhnD58+iVnZMPvqjV/+qczpf4vXw+j8lpSyzH9fg8ZJVzHPlvndmPNkfhWTiZVw1cIfQ778v6FQmHmLHdX3QCLlv7IlwmTeb5gyxc05lM9+nPVXUvBor3phsd28vww5TLfoxDuN7XCr9UDjuG42bMTEFFLH0ET6XK9WCSkuG+LtmSYbCyq0n9TpPyV5PJ4dkrXrp6p/9uZAeMhtwzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw3Y914Y7iJhtDBpadYUxwUcHJ0FXNuHp8CmGHxDL58=;
 b=U2/0wfsTdL2RUMgj8eBAOE0iaz5SbbXYBBvTV71JFnjVBsUpcBzozOk1aVUk8g2eMIpvO7iVM+ikzc/+iIx8Z/rZB8LA7I4U2lYqARgwJhNz5+fjIVWlj4c/4l7pL5u5wPSIKxOpvZ3xm1h5M2Eg2UtznXZHdAtuf8WSOv+z+G8XvzpUnuxoOlhVMUkELXy1esZ3zFz8OllLgQx8He5gpb6b5jFvDjH5olfGGbf4g5JLQDbOgwI4srVMJZs42RTCK0CEAYTiw8pN0WnYLnTQsRrbJBZnJgQd0KK+mEOxuoPkXxk0nyqWtwXpDowQ8ZRgv+wjMaDvY+LAh7RT+oIPdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4744.namprd11.prod.outlook.com (2603:10b6:208:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 21:08:15 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 21:08:15 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 26 Feb 2026 13:08:14 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <dan.j.williams@intel.com>,
	<x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew
 Morton <akpm@linux-foundation.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, Mike
 Rapoport <rppt@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Neeraj Upadhyay" <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>, Seongman Lee
	<augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>, Nikunj A
 Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>, Andi Kleen
	<ak@linux.intel.com>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Message-ID: <69a0b63e3e547_1cc5100ae@dwillia2-mobl4.notmuch>
In-Reply-To: <06aa8d10-766f-45d4-8205-0ffc2f26bfb4@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-2-aik@amd.com>
 <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
 <d8fd6e0e-a814-4883-9e58-f1aa501e0d8c@amd.com>
 <699fb11e94082_2f4a1007d@dwillia2-mobl4.notmuch>
 <06aa8d10-766f-45d4-8205-0ffc2f26bfb4@amd.com>
Subject: Re: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to
 parse it
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR16CA0011.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: 95d101f1-4451-4b96-7116-08de757b2882
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info: MccmB4nJHMzccYSnThwoEv6xhf9H7Spm6cp3rs/LZcf53hJJpYrUiVWCke2hoFVtcOyfkzcFHxQALJLb4OGm344xkt0Gr+5BSS7PIhq7ABlczjXJYgRJ7noY4PuY061TduVvmCuGGrWFXyRsGCK06eY/fbFUo4l02IgQAT1tEfFK6qGKb5rJx/rq6ebogv1zp3XQq7InfFC+rPnWf1jf1Oyotqshe47P9+y71N/Abc2jHMTgLsoHTCuABxS7jHov769f2TPawUsrCHuC85VYqlEqzgxe9KGdlzhpziQ2+WSozj42hvC5DKsy4GhVjIpxuTOKDiRRDitsHeTSbDoSagTGSTbkW3IPfD2K6szHBYpa4nqY/XB54v534ZfvtitEJY3nLwxD80zRviisB19sqkCTnHkZh2XyBCeHAQwX9W5klNoY9UeDJmlMMffEJG4iWsZSadEx6nGmkPuL9fmMW14hINIHwPjprV0NAD2/lymh1DnKmPnqRXCLD4ynOaQZilHtCoxOlAS5DrPe9qPuMjdzD9z/3/5PPFnWwzdDJQkk/qAu3QirUgXBTHv1dBDHB2BMchqh/0y0u/cu3naU9IDKeZfk/28dW6eWui+VD4z7U0ZQ5o4bqPSEtylk7sI04sSMwD1osPw5SLFADQNJ1oBYHPOK+4v9SW2dmZhWdfHxw4K1bsVcu+6qemciThBeJh6Vs2hZhUVhtIRSSbdWvpx4dyAvQWiHIjaEKvyO5Ns=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0hYanMxYnNDL2ZudHlId2xZWi9kTlFKNW5LYzUyckVMZTJjc2NIeUl2WHFO?=
 =?utf-8?B?VTBIc3JON05MRTBxWGdQVzN0dGFMOXoxMWs2RjJJa0MyeWwwa0RkbTNvUlY3?=
 =?utf-8?B?dDJjRDVjY0I0UWxUQzAxcFNWVFhpbGlsYTV5UUN3akFSaHVwbmpvZVIxN3Jj?=
 =?utf-8?B?VXRIWi9tenJUazhLL3V2U2Jkc2s0bTRJcTZIdmVpeHloNXRZSzVSTlZRQTBp?=
 =?utf-8?B?c3huQTZDdGlUYSszcHRGVzI4cnJoOHNERzJKMHYreDl2S29WYXNYQmxUNlNO?=
 =?utf-8?B?dGxiSTNFcjV0c3hnVWdsclUwVlhwU3BhRTkvVTFsSXg3RVdlRlBGaWdkQ3dD?=
 =?utf-8?B?MjdzWjVLbmcyU1lxa0FtRDIxRENaMmhDSDd2eHRWNWVMcDd6Rnk4MnlTUFhh?=
 =?utf-8?B?WFAyQmc5VHE0bHFHUlBTYmZWbUJ2aUlUQWF4ZnYzakR4c1k2TWdBWFJMNVNi?=
 =?utf-8?B?cjNObWJNcUJRMkpJVFAwMzlUMWlEM3ZkYmFNY09LaWxwN2lyR1Z6T1UrR25W?=
 =?utf-8?B?R1hWcXppd1BZY3J3cWlXbmtJUHJZSmdPajhmU1N0ZjVBOUpNczRSNXRhOHZo?=
 =?utf-8?B?QUxvM2xwaVJOMWdQOTF6YzlkQ3g2d1B0K0dWRmJyc0N5OVJNZ3ZpZTdtcWx4?=
 =?utf-8?B?UWVNdTl3ZE4rOTR2RFQ2QUNoS1ZsMzdOVXNxMktnemZ3cllYNUVBMVdZbEVm?=
 =?utf-8?B?MUVJQkRyMGxLSzZVUnY1Z3ppU2RyQ09HVEZFYWpJVUdidTNJd2ovcGxnaytL?=
 =?utf-8?B?emg1d2Zjd3ZsTUQ4UCtDQVluQ3RhNXVIRXFwakFRTVk1c0JpeDRsUHc3T1g4?=
 =?utf-8?B?TFR1cEhhbTNsYmt4dGxDU0Z1dVprVmExeHN5bkZVc2hWVXpJbTZVY2FLNEFa?=
 =?utf-8?B?QW9RWmN3U29SQlJ1aGhubWEwS0FsZ2RMLzVJdE1RdkxJQ1NRbHdnMSswKytY?=
 =?utf-8?B?L0hQQWVvM0duVlk5bzNhbmFKVVRMUEZsN2tvdFNmT0ljQ1VHUFNERVhrRzl1?=
 =?utf-8?B?QWpJY0pTWExJbERha1hVRmJ1TUR1Y2xJZVlDOWQyZWhmVG83WnlMZ2dCOTlz?=
 =?utf-8?B?aHkyRHZkRWg5bGRrVzlycUJDV1N0UEhPWGc5blpxdkVJRmRYMnVKNDFTdC9h?=
 =?utf-8?B?VGtoYmMvTkFSc0dxTmRveG9zdlZNVzZEZ25yR2gyVUd2WTB2R2Q2cEVNY3FX?=
 =?utf-8?B?OHMvQ1ltUjRxY3pjMEhVMmtOcGZPeGl3VFpwVEZOZnVDOHhnOFRrdEpzUDdr?=
 =?utf-8?B?WUlGMit5TEpIY0FqcTMrWmN1OEdGamsxdTIycmtDWUdxY3ZxY0QyN3o5bzhM?=
 =?utf-8?B?VXZTR0xzMitpc2FlaTg4TUFQUkRmL1N0ZDdrekozVFJLaW8wcEw0ek5wQ3E0?=
 =?utf-8?B?YUoyMzFZL0R6bVU5clAvSzU1Qkp4UWMyVm9NLzFBTldTQk5LVkRiL0kzS3N1?=
 =?utf-8?B?a1N3RkVjS090YWlLWHZ3UWVubUY4U2dqeWk1cDlZTzdmK0VSbnhNNHgzYUlo?=
 =?utf-8?B?Z3phc2QyUk9CS25zazBQOXF5QVg3c0pHc3dNWXQxUTZoYWxaL004aVJtcUtH?=
 =?utf-8?B?eXNrZlBDVjArUC9pcjZRdlJad2g5SlZxb2dSNmdWa0sxQnE1a0hLOGpxWUJ5?=
 =?utf-8?B?Ny9ueVFQVDdTL09sSmxFVUQyUEl2UW5jYnliN1VpVXpvZ05FemtDSzhaUFds?=
 =?utf-8?B?L2gvblFpU0pHVXdHUlJDSFRoam5ZTTVMRERuV1c4elBrWkNoWlpXUzlTbk93?=
 =?utf-8?B?ckh6TlFJeWlYcDhYRlRaVnlqMXFxR3JJMnlyN25MZzJURXVCdDFFcmFMclNS?=
 =?utf-8?B?L29yNTVKbXVVNVlIRUNScURGWlpoOXlmY1FFeGJiU2ZsZ3QwRXdSNmU2R0Rr?=
 =?utf-8?B?MVRjMUZnUHJvVkxEb1g3Q2VTTFp0bDVwczUxWTFmUklhSGR6a1pOZnAwWUdm?=
 =?utf-8?B?eGJsNGpXeGxXYkhkVWliWlF0Rjh3UlZtcnlmWlYzQlBCSlEwY3VGUWhROUU2?=
 =?utf-8?B?UTBGei9FWjJiQmxqTHZCSVZOYmt0NEM5Q2xrckRJS0FzZk1QNTlJSXVNU2Ix?=
 =?utf-8?B?RElrN0dOMWRMaTJLekdHNEFKSnI0MU05RFBSRHVvbGZTTjh4ZUk0bGhOSGVt?=
 =?utf-8?B?NkJSSkNhU1RMeExaUGpNL2drL2VTbWJXZ0xNYWpLSUtja3FmRlp4dEdhYVZx?=
 =?utf-8?B?Q0pPWGdFWG9waERYRGlIQVg1YUJzdHBmSndkcGo3SFRjcDh0d0FnckYwT2xu?=
 =?utf-8?B?Z1VKeTRCY1k4V0lJN0dMdThycWxIZWlWdmdlZ2U1QVVuU1UxR254V0tzSTlV?=
 =?utf-8?B?cVFnL1dxYjF2cDNMOGR4dGVFUjFoMFhqaDhmWjJPZmZabDdwNHRzMDlQMEE0?=
 =?utf-8?Q?9Hg8GR5reugL2SuI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d101f1-4451-4b96-7116-08de757b2882
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 21:08:15.5551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7Pu0AnlknhwpAIRGYovzqRnhmFpsIuHT70XLj5MGtRU3wexYFd0/SoW82DcJBqG7tToGUmLjJSmJYRqn3kmjwseNvkBooRrHVRLR7WuzrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4744
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72090-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E34431AF7A1
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
[..]
> > Does the kernel have any use for the footer besides conveying it to
> > userspace?
>=20
> PCIe says:
>=20
> Example of such device specific information include:
> =E2=80=A2 A network device may include receive-side scaling (RSS) related=
 information such as the RSS hash and
> mappings to the virtual station interface (VSI) queues, etc.
> =E2=80=A2 A NVMe device may include information about the associated name=
 spaces, mapping of name space to
> command queue-pair mappings, etc.
> =E2=80=A2 Accelerators may report capabilities such as algorithms support=
ed, queue depths, etc
>=20
>=20
> Sounds to me like something the device driver would be interested in.

That is not the concern. The concern is how does Linux maintain a
convention around these use case so that common semantics converge on a
common implementation expectations.

> >> imho easier on eyes. I can live with either if the majority votes for =
it. Thanks.
> >=20
> > Aneesh also already has 'structs+bitmask', I will switch to that.
>=20
> oh I just found it, more or less my version :) I can add pci_tdisp_ prefi=
xes, should I? Thanks,

I have a patch brewing that moves interface report consumption into
encrypted resource population for ioremap() to consider. I will send
that out shortly.=

