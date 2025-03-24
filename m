Return-Path: <kvm+bounces-41779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F93A6D374
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 05:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02BAF16CB10
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 04:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6C217084F;
	Mon, 24 Mar 2025 04:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OaXeVBPx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A2217BB6
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 04:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742789129; cv=fail; b=JG1xSWwdNcz32vJRLrVq1CnIWB6iz1L5YHVZ84SjzGHeJfcqb2e1Kk3Q+WTBAz7d+JzBAYHMW5ThJKA23WmRgvIOJ13dO2MpYOsXQ2Yt42LVTJU6fNBq9X5esRHZL/ybgBOjG3xKr1QDoQMWpamtFEi0S1f6KjAL6Hx2m4z7BGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742789129; c=relaxed/simple;
	bh=faVy84mo+l+tZEuT362mA97kJVFdBwHoc46LnOwNM9o=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z3451vJ67mgYc36GWpeq+18ytIw4I3XtR2SHvQBsGLFNp1R2L6jRwYOAKztnXLjk5HxpGDl6fqzgxYh9LnATFwQ+Dz5HnZESsqPIv8k9yRiSMhhjGucm4wo2b36LYV97LZ2pALXpNbx3VWEWx5Vz3uMvEl45O3gwhh15zAdo9mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OaXeVBPx; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742789129; x=1774325129;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=faVy84mo+l+tZEuT362mA97kJVFdBwHoc46LnOwNM9o=;
  b=OaXeVBPx6xpVMJ+H3R3rZzbLBICoo6xu5t07SLutMv+J1Jklv518gr23
   wJukmQUe3GT/jE6xvA/gzmtK4htQLAtKgWnCs/I2tB5Vo+S4PhPwjdnkD
   QwvSaD9deLrLfcGlpVUDpIgInZH0ecrZzaLfVT5wGxpfX2/LEuxPhlexZ
   U5cxLwN89Rbw/6rilhEMEzDnomGchtWm/NpE+nFrzl11peXKBIzoScbvX
   ogFY81AJrSKwo3WLZAA56MsmDDjKHPfwZkwmb43LKxUDLizoMEH3og2PA
   3pNQq7BKazJi16ABz99gR5JvgBH1K6se7whR5Q7xHS9Hq1II3aHLI0xKW
   Q==;
X-CSE-ConnectionGUID: wEBC+3/DS56Cosb4LWMxuQ==
X-CSE-MsgGUID: zswuLY1OSTW74ZlwAvfq4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="47755685"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="47755685"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2025 21:05:28 -0700
X-CSE-ConnectionGUID: qfkzRBEsTcWDizL7NdFHDQ==
X-CSE-MsgGUID: rCZWW9WORgOY9S363pZV9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="123649864"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2025 21:05:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 23 Mar 2025 21:05:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 23 Mar 2025 21:05:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 23 Mar 2025 21:05:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYS9UOSQzwZn1Dtv2gHk9mDr3E85Fx31bLozJZLR2vgGrMPyd+jTUg+evtu8AswmBSX6Fsj+8gDQ3ZefNkF5yYdHNgctWOsMDtGwavGwRI0Bmi0TExd9Jxul3fLcVmtC/9TntTKCbpS8iUX8YBb6NgHEJuSGDHdfCq2id/YYKnQlgRHvqWQrQw+rhWP9o+gd7D9Cg+E1Nvd3DPZJ2W/lI6TsDiZEFOnP55XwAVnxyYDX2vdemnpz/Rts+EAifKE7QlCw9D5CmRSqC6dxzszDcVYj3rw0TSiFDJH51BVopoNJmlnJtQ/iLhdliw85kjS//HSKIM8ELprD5n5wlpuIiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pw7VfeSknr+5moVcDQz05da0e771C3v9b4KrpQOTIdY=;
 b=hp1wPajfG9P12cl37inUFKttn/0/u1TGZ43uf6HxVPfYgofrb4jUDeBQTKZrmTxzogvstBIfeXd+19kMpR1ZHnr56rQFpGHFIIGZioc1G8RTdIimKLVBEWmlTo9iuaONO8H4/oWeXB9jMuCNQbw2X0gXuEquOgcYE1TFR6ejI3o2aGsJPj/0gINHrrxA0q920HXfIUEe3aQJshLOiZOSeFgIxMS6m62iIbfoaB6clV5oiFih0eJqgru3X+gyrQFIvifs3ZLVD8T3/IPaN3oxDzz9y5AqepRAREActluZzOThx4Ce9DqTmHIERyZBlkFg0iUol7L2KZC/w+ZYn3piQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8238.namprd11.prod.outlook.com (2603:10b6:610:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 04:04:43 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 04:04:43 +0000
Message-ID: <f804a892-482b-4eae-a21e-413e147e03da@intel.com>
Date: Mon, 24 Mar 2025 12:04:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
 <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
 <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
 <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
 <4fd73f58-ac9a-4e24-a2af-98a3cbd6b396@amd.com>
 <4bef4a8c-6627-4054-83dc-79d41ca03023@intel.com>
 <0ed6faf8-f6f4-4050-994b-2722d2726bef@amd.com>
 <c94c26c5-9687-48df-9d40-0bca0892e625@intel.com>
Content-Language: en-US
In-Reply-To: <c94c26c5-9687-48df-9d40-0bca0892e625@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e32a5d-8247-4f83-6bd4-08dd6a8901f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2FUOUJpc3NidmlPQzNNUURmS2czK0xOSm90TGp4VWswY21Db08wSHloWGE3?=
 =?utf-8?B?WXVTK2wvMjgyMllxWEF0K1pYUG1BUDB1VjY1R0dqNzdWSnRxbC9pYXBoV29n?=
 =?utf-8?B?cDhuVDRNQkU1NlVFdEVNbTYxd0VNNGlxVGJ3OHhENEUyZW84WWJEV0o4Znhi?=
 =?utf-8?B?cmtOYnM4aTZyd2x2RFA0eVZpcXNhcDVVbVlMWWZwT3piZlNmSnNSV0poYmFw?=
 =?utf-8?B?dndySWlNVERoSk9uMldzME1zNDgxbzBVb2t4TnJLT2tjaTI0TzBGSEFrdGVL?=
 =?utf-8?B?a3BJd0dtUUg2U1VyVXZyN21CNU96OEk1NlRxSnNzR2NpdE5CYm9neEoxaklh?=
 =?utf-8?B?aTY0a09rbmtVZTFPMFRKaGZvR3laMEFuNE1pNEc3NUUxek1uK0J4dVNKQmFa?=
 =?utf-8?B?VmEvSmFNSmRmU1FYaStVMjBCNnRPSU9rZ3duL0NEdzhxdTlpaE11bThDd1Ra?=
 =?utf-8?B?TDRiZkxzMGhKdjZVeWpYd0IzbTN6YzdVaTB4WTF0MlhkczEvSGdHVUduemp2?=
 =?utf-8?B?TWZOQVNPQUxQekVxVzYrbXpLTEl3d1RkZExFMVVUZXdIeXR5ZEJlN0M1dHpS?=
 =?utf-8?B?dzBmQ3BIOTNDNG1YVEZRNW90eTBHNUpiV2FQazI2Q1MwKzZMelFHbDk0VXVw?=
 =?utf-8?B?VkpyenpoR3FtWlhkRHNScGQ5eG1kTVJTSkJHRXJmZjU2QTVSVE45cmRnN0l0?=
 =?utf-8?B?enh2am1UUGQ5cWQ1bVF4Q2l3R1IvN3NMb3dSMHZsYjVneUttbWhKTUVpL3FP?=
 =?utf-8?B?NDRnTWIzeDFqUjI1ODJSK21aU1dxVEdtOENKZlBuYjNNM011djB1cEdRNHky?=
 =?utf-8?B?SDY0eUlRbmtGSVNFaVgrQkUrOExrYSs4NEg5SHhwV05xYzBHdzNNV3F2ckRY?=
 =?utf-8?B?dU1CUkdmbnFOa0hWcURqeGNpayt4ZmhNL3dKc0lMeU5GL3RwdzluVWM5S1hK?=
 =?utf-8?B?eGZOVndVM3VCUnQ2aFpBVUtQZTV0bDdlRlJibWN5d2Ztall3OWRZT1pSNURZ?=
 =?utf-8?B?U3Q0STFpTXMwSlkzaVZISVpTa1dRcjV6YnJ1eS9QZHg3c1BRelRiRHkybkNr?=
 =?utf-8?B?OTRtNGYyZmhzWHI0VWpnTXZjc1dmUEZFR1RadlRnMVhKeXJMYVhZZkVxVHB2?=
 =?utf-8?B?dEdrRS94cU1ZNURJcW92VzJwZmRlb0dPeG9randpUnMxTDR0aC9wcDhMQlAw?=
 =?utf-8?B?cXBDL1NqWDZzWmYwajN5RXYwQzFIRWNJQ1FTOGY3NmsrTmlUMWRUTmRyYUJL?=
 =?utf-8?B?T3ZVcUU5UlZqMkkzNGd5ZjltcFhnN1hNcVNpaDhUY3JpOVc1clMxaFdWUDZt?=
 =?utf-8?B?bXNHVnhvTlpkb0FnSEp4V3MzZ2prcXh2NE5MYnY2ZjlpTnAycVVvZWo1R0w1?=
 =?utf-8?B?dDJBRm5kZFVWaU90cGFNYmZhS1ZXdXQ0TGVIakIrZjh3K29NVW1CbWZ1WkR4?=
 =?utf-8?B?WG1xVlg1RkZ1K1FmaC90YVFHandRTk5nWm9vemNJRkRpRUlHTTdYbW4zNnNZ?=
 =?utf-8?B?aHZuUE9yM0VZQ09LWTFSZVhVZVQ5VjAwT3FDMmdFNGpDa0RyVytBcEU1QWdo?=
 =?utf-8?B?NXFnd3pjR0pnUWhPTjhvU0hiQVozWmI5VzJONjZwWGFxcS92MUJ2dDdraFJn?=
 =?utf-8?B?UXFyUVNibUU4dTNIaVdYL0pMY3pTaE9BOGVZejBwMmsreTMvbnlZcjI2SWli?=
 =?utf-8?B?ODROK0U3LzZQbSsyVjdOQ1JVZml3bG9NYXhBcEVMT3hwZVdib3hCbEM2aHMr?=
 =?utf-8?B?TGlwQ0dqNWhTYkhYMEFiL1VRNWdIWDl0MHp1VXhWdGFsUFVrTjZoYTZsVXdm?=
 =?utf-8?B?aEJjR0JxNlJxeEdTS0tXcWE4ZWFEY2M3anlGUUhTWHVFdU5IVkJKM3VtRmk5?=
 =?utf-8?Q?7Obhus+/nyszR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWw0d0ZTdzIyaFB1T1ZyZnBSNEg1My9Jd0lmL3JOSWtucFFEenZXZXB0OXdr?=
 =?utf-8?B?K1pHTEtmK09qTjRvT1crazVhN3N1WVkrOVZMY2Ryais2U2tmUkdselJFTEIw?=
 =?utf-8?B?RnlvT00vVndPcDE4TlFmRTJONnhmUXdLa2hndGc0cDI4UlVuREl0QXlFY1py?=
 =?utf-8?B?ZlpIdW02QkRRRlM0WWdDL09PN2VnTTFXYnlPWjNEZkFKcVVUMG1iOEh2ZTBU?=
 =?utf-8?B?cVlnQXd3L2JQTUozNGVHdTV0K1lwa0YwdFAvSnUrd2RuVWxSZHNQbWczZHhP?=
 =?utf-8?B?ZTZUWXJhWm12dGVFTHJsOEFiaEZhTW5FYnByZXpKZGFuZURSQ2d6SjE1Z3pM?=
 =?utf-8?B?d1RQVVdjcUYyV2d4N3MwMVZGVGYvZHErTXYrTFRvTTJMbytuMSs1SWZwQ3V3?=
 =?utf-8?B?eUFRWGZ0WUNndGd1Nkg1VTE2bzY5OFZEOHNkVjdMTUQ2VXUvelhpK2xpdkNq?=
 =?utf-8?B?c2dTMEtGMG5ROTkxZVJDWkpoUFhzNFZxMEdxczBJOUhMd25aaWJVL1UvMGtj?=
 =?utf-8?B?VmFqdWlrZmRzWS9CeXJod0FjYkwvVG9RQUFzK25lUlJGQ3llWHJuZGpXUjZ6?=
 =?utf-8?B?alFXVzJNMTJxeCtEQ0FPalBqdUVrcUJCNE55N01PaTNCdnNabEF3VCtwM0Yy?=
 =?utf-8?B?T0xNREdQaWR6Y29WVE44bVNkMGJtV3dydnduWHY3NE54Ym9WZmVWaUc1Q3BT?=
 =?utf-8?B?SmFybUV2Wm8xRzJCNXZSeWlOU1BqWG1ZcUU3bzhteStUajVrSXVlaGRxYWdx?=
 =?utf-8?B?eTVueWFSbEV3SjhGdmlZaVlhSGNMeXIzL3AwQzR3cWhwRklpU3l0SjJiZWg5?=
 =?utf-8?B?MFJmSGtmUkx3cEJoL3dXSVRZZU5Vb3lNR0w0Q1lMdXV3UGhLK29oQUJYbW9S?=
 =?utf-8?B?OGtKMWVNekJsYlMrRERhRTNKMFZ1MzBLVVBoZzRFbm11Ny9pQWJuRmw2K0Nx?=
 =?utf-8?B?WnFBWjRHZWh6akNlR1FlYlJIQkcyQXN6NUYrM1dqdVp0YjQ5bXJTcGhib1gr?=
 =?utf-8?B?bDYyRVRGcllaamxZZytOOW9peFhMamdyektUN2dUQ3dOaHE0bDI4T1pUQWVs?=
 =?utf-8?B?YVoyNy9hWG1kU0tGZmVYN1oyMXVmV2hhQnVDOVBMZC8xdDlHbjNCY05rclo3?=
 =?utf-8?B?djl1WmRoZVp1d3BMT3ozQ2RFM1FFTjkzcjVIRExXZVNXWFhRYUdIK1MreUJw?=
 =?utf-8?B?Z2hzT2ZPYlp3QjN4T015bld0d0p3ME8vQkZ1VWNUNDkwbGNrM24vSnZPU3F1?=
 =?utf-8?B?ellCQktTZGNQdm1iTktoMVNBNUJqdkJxWGFrcDNZOHhldXRCOFhobi9jYmZB?=
 =?utf-8?B?Z0IyOXJVWmNUcVJJMC9tOGpuNURwMlcxTnlvMERYV0ovOUJPUkJ1MVhVN0o1?=
 =?utf-8?B?UkhLU0dMQk5lN093bDhtdGV6b1RubWpvdVdLNlNhZDZyV3h3em9uaDlMSXVD?=
 =?utf-8?B?ZmFuS1ErNEhPNTBTbjByOTI2Z1l5elp6TU5MRGZxK3RBSjNYeGpLQ2ZvdXRD?=
 =?utf-8?B?NXVDRmMrNE4zUkRxSmFINFZFT0oxYVk5ZUNweW5IQ2ZkNDdYUUw5b2VkRzdB?=
 =?utf-8?B?Y1g2VmwrZFIray9hSlZrVmhmM3R5eXN2Ym1kU0RtelExOG5veUxLajA3bWNK?=
 =?utf-8?B?TmN1d3gxY1Bsb2x4d29vUlQvSThEK0tQRFNkYldoWld0QXltY2NjSjdneHc1?=
 =?utf-8?B?UlVGdWpEY3NYWXdReDZyOHpIRGRnc1NnVythTUgyTFJ0RmUzcW0vdUNNcUFu?=
 =?utf-8?B?b2FwbmhteExReTl5cWpGbXZCRmdGbEtLcVpzNGpOeENoSWRGQnZvdmZrVDh0?=
 =?utf-8?B?YlhDZTloSk1qdDI3bWp1ckNKQVp3YS9qSjhFSXptcXE5eXlKdUxDQTlYdFo3?=
 =?utf-8?B?V1h2YkVVcXBXbzhSVkViS1M2Ym1wM2trRVpDRlBRbGNLWFVFaE1DQXZjcGtN?=
 =?utf-8?B?TW5CMHFrQS9SM1VhYW5sbjZQUjlCYXhGSGVMN0dCbm1PMkh6RnZkaEc4Yldj?=
 =?utf-8?B?RHN0V0wzMEYvOENldFgraC9ueVZxeFVhbjE4eERJajNMWEFqVENXSTQ2STFX?=
 =?utf-8?B?d3VaZmRhNXM0U3pJOXcwUTJwbWNYN0ZRcmtreUdObmFNSjZXdjJVNGxmcTgx?=
 =?utf-8?B?eFdPVkIrUEpXSDd5L0ZMSStEZUVSditia3B6QVVTblpMK0NHb1ZCSkxyWHJS?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e32a5d-8247-4f83-6bd4-08dd6a8901f6
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 04:04:43.6729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GXKQy17lkJVMYyS061VT5xwltP2HLE44hYGVSrygKBZ694rwqxfYfWg449W88yIM7PwiO8SSXvnRHSgDkGzTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8238
X-OriginatorOrg: intel.com



On 3/20/2025 11:15 AM, Chenyi Qiang wrote:
> 
> 
> On 3/19/2025 7:56 PM, Gupta, Pankaj wrote:
>> On 3/19/2025 12:23 PM, Chenyi Qiang wrote:
>>>
>>>
>>> On 3/19/2025 4:55 PM, Gupta, Pankaj wrote:
>>>>
>>>>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>>>>> discard
>>>>>>>>>> operation to perform page conversion between private and shared
>>>>>>>>>> memory.
>>>>>>>>>> This can lead to stale IOMMU mapping issue when assigning a
>>>>>>>>>> hardware
>>>>>>>>>> device to a confidential VM via shared memory. To address this,
>>>>>>>>>> it is
>>>>>>>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>>>>>>>
>>>>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>>>>> adjust
>>>>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>>>>> adding it
>>>>>>>>>> back in the other. Therefore, similar actions are required for
>>>>>>>>>> page
>>>>>>>>>> conversion events. Introduce the RamDiscardManager to
>>>>>>>>>> guest_memfd to
>>>>>>>>>> facilitate this process.
>>>>>>>>>>
>>>>>>>>>> Since guest_memfd is not an object, it cannot directly
>>>>>>>>>> implement the
>>>>>>>>>> RamDiscardManager interface. One potential attempt is to implement
>>>>>>>>>> it in
>>>>>>>>>> HostMemoryBackend. This is not appropriate because guest_memfd is
>>>>>>>>>> per
>>>>>>>>>> RAMBlock. Some RAMBlocks have a memory backend but others do
>>>>>>>>>> not. In
>>>>>>>>>> particular, the ones like virtual BIOS calling
>>>>>>>>>> memory_region_init_ram_guest_memfd() do not.
>>>>>>>>>>
>>>>>>>>>> To manage the RAMBlocks with guest_memfd, define a new object
>>>>>>>>>> named
>>>>>>>>>> MemoryAttributeManager to implement the RamDiscardManager
>>>>>>>>>> interface. The
>>>>>>>>>
>>>>>>>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>>>>>>>> should be an interface and RamDiscardManager a type of it, an
>>>>>>>>> implementation?
>>>>>>>>
>>>>>>>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>>>>>>>> implement the RamDiscardManager interface callbacks because
>>>>>>>> RAMBlock is
>>>>>>>> not an object. It includes some metadata of guest_memfd like
>>>>>>>> shared_bitmap at the same time.
>>>>>>>>
>>>>>>>> I can't get it that make 'MemoryAttributeManager' an interface and
>>>>>>>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>>>>>>>> think at least we need someone to implement the RamDiscardManager
>>>>>>>> interface.
>>>>>>>
>>>>>>> shared <-> private is translated (abstracted) to "populated <->
>>>>>>> discarded", which makes sense. The other way around would be wrong.
>>>>>>>
>>>>>>> It's going to be interesting once we have more logical states, for
>>>>>>> example supporting virtio-mem for confidential VMs.
>>>>>>>
>>>>>>> Then we'd have "shared+populated, private+populated, shared+discard,
>>>>>>> private+discarded". Not sure if this could simply be achieved by
>>>>>>> allowing multiple RamDiscardManager that are effectively chained, or
>>>>>>> if we'd want a different interface.
>>>>>>
>>>>>> Exactly! In any case generic manager (parent class) would make more
>>>>>> sense that can work on different operations/states implemented in
>>>>>> child
>>>>>> classes (can be chained as well).
>>>>>
>>>>> Ah, we are talking about the generic state management. Sorry for my
>>>>> slow
>>>>> reaction.
>>>>>
>>>>> So we need to
>>>>> 1. Define a generic manager Interface, e.g.
>>>>> MemoryStateManager/GenericStateManager.
>>>>> 2. Make RamDiscardManager the child of MemoryStateManager which manages
>>>>> the state of populated and discarded.
>>>>> 3. Define a new child manager Interface PrivateSharedManager which
>>>>> manages the state of private and shared.
>>>>> 4. Define a new object ConfidentialMemoryAttribute to implement the
>>>>> PrivateSharedManager interface.
>>>>> (Welcome to rename the above Interface/Object)
>>>>>
>>>>> Is my understanding correct?
>>>>
>>>> Yes, in that direction. Where 'RamDiscardManager' &
>>>> 'PrivateSharedManager' are both child of 'GenericStateManager'.
>>>>
>>>> Depending on listeners registered, corresponding handlers can be called.
>>>
>>> Yes, it would be more generic and future extensive.
>>>
>>> Do we need to add this framework change directly? Or keep the current
>>> structure (abstract private/shared as discard/populated) and add the
>>> generic manager until the real case like virtio-mem for confidential VMs.
>>>
>>
>> Yes, maybe to start with we should add new (discard/populated) changes
>> with the new framework.
>>
>> In future the current framework can be extended for in-place conversion
>> for private-shared conversion (if require userspace help) and virtio-mem
>> like interfaces. Important is to have proper hierarchy with base bits
>> there.
> 
> Thanks. Then I will follow this direction.
> 
> To abstract the common parent class, what I can think of is to abstract
> it to manage a pair of opposite states (state set and state clear, like
> populate and discard) and define some similar common callbacks like
> notify_set() and notify_clear(), as long as we don't use it to manage
> more than two states in the future. Otherwise I may define a stub parent
> class.

Hi Pankaj & David,

How about defining them like:

---
For class definition: extract all the callbacks into parent class:

typedef int (*ReplayStateChange)(MemoryRegionSection *section, void
*opaque);

struct GenericStateManagerClass {
    InterfaceClass parent_class;
    uint64_t (*get_min_granularity)(const GenericStateManager *gsm,
                                    const MemoryRegion *mr);
    bool (*is_state_set)(const GenericStateManager *gsm,
                         const MemoryRegionSection *section);
    int (*replay_state_set)(const GenericStateManager *gsm,
                            MemoryRegionSection *section,
                            ReplayStateChange replay_fn, void *opaque);
    int (*replay_state_clear)(const GenericStateManager *gsm,
                              MemoryRegionSection *section,
                              ReplayStateChange replay_fn, void *opaque);
    void (*register_listener)(GenericStateManager *gsm,
                              void* listener,
                              MemoryRegionSection *section);
    void (*unregister_listener)(GenericStateManager *gsm,
                                void *listener);
}

struct RamDiscardManagerClass {
    /* private */
    GenericStateManagerClass parent_class;
};

struct PrivateSharedManagerClass {
    /* private */
    GenericStateManagerClass parent_class;
}

---

For listeners, embed the generic listener into specific listeners:

typedef int (*NotifyStateSet)(void *listener, MemoryRegionSection *section);
typedef int (*NotifyStateClear)(void *listener, MemoryRegionSection
*section);

struct StateChangeListener {
    NotifyStateSet notify_state_set;
    NotifyStateClear notify_state_clear;

    MemoryRegionSection *section;
}

struct RamDiscardListener {
    struct StateChangeListener scl;
    bool double_discard_supported;

    QLIST_ENTRY(RamDiscardListener) next;
};

struct PrivateSharedListener {
    struct StateChangeListener scl;

    QLIST_ENTRY(PrivateSharedListener) next;
}

---

For helpers,

- define the generic helpers:

void generic_state_manager_register_listener(GenericStateManager *gsm,
                                             void *listener,
                                             MemoryRegionSection *s)
{
    GenericStateManagerClass gsmc = GENERATE_STATE_MANAGER_GET_CLASS(rdm);

    g_assert(gsmc->register_listener);
    gsmc->register_listener(gsm, listener, s);
}

- Keep RamDiscardManager specific helpers for compatibility if necessary:

void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                           RamDiscardListener *rdl,
                                           MemoryRegionSection *section)
{
    GenericStateManagerClass gsmc = GENERATE_STATE_MANAGER_GET_CLASS(rdm);
    GenericStateManager *gsm = GENERIC_STATE_MANAGER(rdm);

    g_assert(gsmc->register_listener);
    gsmc->register_listener(gsm, (void*)rdl, section);
}

> 
>>
>> Thanks,
>> Pankaj
> 


