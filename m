Return-Path: <kvm+bounces-59446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0492EBB570B
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 23:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A8CB3B086D
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 21:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648E92BF009;
	Thu,  2 Oct 2025 20:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZkFa1R3+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DFC17C77;
	Thu,  2 Oct 2025 20:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759438765; cv=fail; b=lvFLWWKgFsm1Cw3nnTSTBvNcBr6TWsXcz6M8AeuhXA4buys+QeDps5gqIK76RtIIZq6U0JiiwiaOVoQEtuvlzn3LT7uGNDD1PqWHJcWCZFuK4vRFojZ1Cpk1i/OvI3ZLtbhJFQFFYrLA4VZNbvvk/CxejbRDWK09mHH6irkg6qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759438765; c=relaxed/simple;
	bh=rPlJwmY1AD9OIJZM2DaCV87t0WbYc3Y9iP07u2n+goY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oeJVASHpL766y+Ld+IfvL7v40Y5r3owymBtmxRE8cWi9Dtw32FxPxnIT6HOalgDoq9+kEnFviLc/5BwdGtftm/Imm24Gu4p1p1j60PxbY1hXl5Kt60eDrzKyWSAZwmwT6c8kflSeh4u1BwweJtF1AkuUirQioGPJ4lnX/bytuWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZkFa1R3+; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759438764; x=1790974764;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rPlJwmY1AD9OIJZM2DaCV87t0WbYc3Y9iP07u2n+goY=;
  b=ZkFa1R3+EU9qeDObZodOP4uFwa9k4GhyHXZbZCyb55kEafZDRIlbugYu
   RpKuQjTJ8TbupR2uwk/NGw8+CgAkCXBmuJGHNG04r9Ul8UU37kWZ1eOze
   Y5/WKMw+AOk/cs+URyUsG3QaONQofD7u4a2FZIh3JQpPRNX4UmaE0kDA8
   DDhQZsa0bjHK9/qQ8+/BiwcghLJb9f9kAq+9lGt1tYc5Bp9bt50ME3l1X
   XkZFNnsXcfcJWHxif86PfAZnCrifv3Bj/GC2WLdRGoCYdzAicRxPe4Bg6
   2Ptgy3vwGYPSo4pj2WVH0+hhd+rKxku8HJk7ivrjRMZ4hpBEG+uOquHEK
   g==;
X-CSE-ConnectionGUID: nmChv2GSR/G6qXtVdnzPug==
X-CSE-MsgGUID: ZUSE/fGQQXuGNqO8VGKVtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11570"; a="64346589"
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="64346589"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 13:59:21 -0700
X-CSE-ConnectionGUID: akB5jkcJRjq0MNvSFir2mA==
X-CSE-MsgGUID: 7iBtE1p0R/+6zT32ZNZcxQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 13:59:20 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 13:59:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 2 Oct 2025 13:59:20 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.68) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 13:59:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cuSp6FHx2zlTM1e9q5vBKfVihLOyrOe8TO/+HpFWplfl2bpZ0Yaq9kLGu3RcDaS7TLRHyA8BQwRpJNRX5agt3MWrAtoIB84Lh2K7NxqOaTLEiMjmSAbD8Wmm3LtCnc8rnU92GCyYBVy/HRRtYUQuB2l4otIZ7rd1CWWm+ncZTjvyW5xYTAxP5xeTzl0vOaO0zZurbd5GbB4SOAIaWsV171y8dVZm7ldXSdr9E4KtI9MgX5+bjf2wq/IoJ9H2ngnvY+kp3hPYh/pY8lBHXG+Hh2ADMZSjO+PY0ZeCUR22qXyPCzO0wedEor4c/pNrqiCi25QgA1lidrvIzIH55jopGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekO2H1dxu3D6Azh9UCVdxVJMXVzauvV+jQ4ARRMnpbA=;
 b=sH60hsOTQSPoVCpnB8qcCDmGOue2KL8J9VQocJZ/SOrTqlVcwurAQeoy1DUjDNKWTFWbogPvykgS3ho637nwWbVo1E9jXbGhfTkFVWZzAY+ugP8+Nn0vp95sv8S5pfAw+pC1Ao8xl5Me4+gnnz2PdYseglZWt3EboESCnKcHt6pw3r/A9323QCMskS9IzPwkPJkVkyzuHCsQ1Sv84ukLSvLjiV4ZHbuyvOYUVzVcFoRcFmniulRBNtDbuXU0zSPbJOIEpHNurcDc4CYhR0KSrvGnkhxlonWsNL7a11+oBpkkom1tdhaDBLYNZKq/CGvJymg2VxnvFiSM1eZB4C4KjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by CY5PR11MB6258.namprd11.prod.outlook.com (2603:10b6:930:25::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 20:59:14 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Thu, 2 Oct 2025
 20:59:13 +0000
Date: Thu, 2 Oct 2025 16:01:17 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Annapurve <vannapurve@google.com>, Sean Christopherson
	<seanjc@google.com>
CC: Ira Weiny <ira.weiny@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <68dee81d79199_296d74294b9@iweiny-mobl.notmuch>
References: <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
 <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
 <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com>
 <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
 <aJFOt64k2EFjaufd@google.com>
 <CAGtprH9ELoYmwA+brSx-kWH5qSK==u8huW=4otEZ5evu_GTvtQ@mail.gmail.com>
 <aJJimk8FnfnYaZ2j@google.com>
 <CAGtprH9JifhhmTdseXLi9ax_imnY5b=K_+_bhkTXKSaW8VMFRQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9JifhhmTdseXLi9ax_imnY5b=K_+_bhkTXKSaW8VMFRQ@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|CY5PR11MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 0947df18-d817-4739-38b2-08de01f68acb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TUYwS2kwQjRSQk9kMythdThLK2pzRlIxcWxsZHlwQkRFZXIxN1BjVHdHYjUx?=
 =?utf-8?B?UEsxZzV1Y2pDK1U4K21GTWZuaVVXWGFuL1JodXM5TlQ2QnJsVWJON0ZMMDhR?=
 =?utf-8?B?NUdhczJqUFkrMDVkdXdYb3FRQ1k5Y2k5RzZ0dUhFUXJ2NzJoWklYT0cvQUJw?=
 =?utf-8?B?bzdLbmxMMGlYZ3kvdEl5UmlqZld5dUREYlZXOTBUU3dBRmZwbjR1OU5vZVgy?=
 =?utf-8?B?N3hHSEE3N0pnb0Q2R3FRWUlRN0ZZakFPSTFPV04xK1FhbkY2cEJyR0M5RzFq?=
 =?utf-8?B?RlpMYmRDTTBtN01IbUlyakJaT0dLamxrbUltb0R6eW9HNGNIbktuK2gyQy9F?=
 =?utf-8?B?SU5NUkNaODl6SVNzT3NDTERaRU9NSGM2d2g3eVVteE41ekRuYlZwRHJPbG1R?=
 =?utf-8?B?Y3FQaVByZk9QcE1wd21VK21RTlBSYVBCbVZzYUFlT3hnVVZBbUJHdU5BTVU5?=
 =?utf-8?B?bEZsMTJML3JNV1hLWVBaL3dTaUhKTVJpQVVZS1RyUlVqd0lQVW5IbFd2TFND?=
 =?utf-8?B?NkM1U1hnTldpZThSZkV3eW5tSGk1TXpmM1M0NGVud0RjZkpLRlJiM0lKUWVn?=
 =?utf-8?B?L2RwOWFRcXRrWFhKTGV1Z2RvVnh1ZGZjMDE5YWltOWtLWSszdzJZZFBES2k5?=
 =?utf-8?B?SHl3N3ZVcjl1b1FTcTZLdU5LdWlObWRFaTF1OUdSM2Y1YjAreEdSOW5ydkNC?=
 =?utf-8?B?UDZEL0hEVnF6YUFmbHBpTVAwdHVLclFIcHJTTmlEdk1Vb3dBdE9JMkFEVUh2?=
 =?utf-8?B?cVFmSHAwUFpIR3ZwNWtsR2lOc0pBMXFoM0Z1Q0RTbnBJd1EwS1hKMjNiLzZu?=
 =?utf-8?B?T0hFQnpiUkh2alhKOWlvTWVqVCt0Rk1yaHFEdmlCQlc3QmdCOGM3UTRwWG5K?=
 =?utf-8?B?dWh3b0NpQUlETWJ6blJxUkFKeDJLek5wU1VoaTErMHhWdTVZOVp0RVhjR3lo?=
 =?utf-8?B?dHlLaEpUQ3UrWG5zZ2NUU255VWYrL25RK2lOdGFjcHJHR2JaVWd3UFh2R3hj?=
 =?utf-8?B?U0xEY1RScUx3KzJTam9rT0xFd2VwTUF5OFJoandtZnhNcE9QalBqNElyc05Q?=
 =?utf-8?B?UHFoYU1PZU1mTzNCazZ3SWIySmg5eElRenU4K2tXUGR6WTVtYXN0dUptM2x3?=
 =?utf-8?B?elUwWHJpa1Z3TENhS05nbUxJRmMwemdyS0MzRXdpZE1OcXBxK0NDbkZySE4w?=
 =?utf-8?B?dXZ4TkdQeDJxQnFZcVdJZUJNK0h5RkFqa1VuL3BEL2hicXFvd21Da1UyZ2ZC?=
 =?utf-8?B?RDdocEtrMWJDdmw1OE1mMERaY3hxZ243a2xIc2R3QmtwTkRHNEQ3VG5iMkFJ?=
 =?utf-8?B?QjBFOXZPTmFXM1N3RzVBK1BkR0Q2RFpJeEJXcDFBbnRhM1R2MnRDMjFIQVpp?=
 =?utf-8?B?TWRKeWFkeVAvMnBBUzVBNnovSWdmd09zU1V2ZWtTbWlaOEVHUllaYitWV2do?=
 =?utf-8?B?M0gxRS9yTlNBT0VoQ0IwRzY4R25uUnJqTlNrL0hxZFZDQ1lRdkxaTFg2cGcz?=
 =?utf-8?B?amRlb3Q5NzQ3WWZTRHRNSlBpeHhXSVRKTXAwZFB5SjBmTlJuR1Z4TXRXUEpI?=
 =?utf-8?B?bHVGMmJWL3huYmE1ZW9scEdTK29Dcll3UjQ4WkRZMlV0d0xoRjlMbWtHdEtK?=
 =?utf-8?B?bVptK3ZiejNscnBaLyt1V2NJTlU3SGJOZXIxVmdndFlMZXFxS1VpWnVvTnU5?=
 =?utf-8?B?ZXJzcUkyYUdKQlhuYVBrdGZMaG1ZZTZoRWxNWnVodVVwOVB0MFRZcDlVcTAz?=
 =?utf-8?B?WjU1dW1xOHpwb21jWm1Fa2ZFZTdjaTZaVVpQYk9SbDhxdjZyb2Y4bXN0bytS?=
 =?utf-8?B?TngxZE9BTG9NOEtFRE5mVUVTZWdsTzNuNktHLyttNTJXOHJnOXdKL3Roekxy?=
 =?utf-8?B?dUM1UTI3Z1laL2pHWlg4eWYxWGp1ZS9nZEFqNGh0ZGd6SU51eC9kMWY0eGU5?=
 =?utf-8?Q?sLHJR4b/p8diDgXUyQRpzpuTEqhVjt3z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFQyRnNqTGJJWGc5MGYwUHVldHd1ZmlyWlVEL3VNS3JNckg3M2c3a3RnMy8x?=
 =?utf-8?B?Z1I3N1djWmNEKzcwQjBTbFd0TjJ4TzFRTmptV0cwZGtFam45Tno0YnUzWnFq?=
 =?utf-8?B?L1pmUWtLZ2VsbEM1YU1NRmpQcjJ4MlEvZTZnMDdyWUJqUmZzQ3J6OE9yaHE5?=
 =?utf-8?B?QVhzdWNaVzl3YW9ZWUYrRlFodW83QXpUeWtBSy9jVjNFeCt6Nm9qSUdLVC9S?=
 =?utf-8?B?VGw4RU9hUkdYMGpWUEtvRnF6TmNWTkNjdjk0U2VWaUY5YnlzZWNDMUNvZ1NO?=
 =?utf-8?B?V1hFeDVVRkZxZDZwOHk1NFhURnA1WnE5dEZVbDdSSjF2NE9nL1hTSUgxNDY3?=
 =?utf-8?B?S21adngrT0pENkxIMTFqekxyTGlWK0ZYUEx2VXk3YUx4UlFkZ3RwL0REWDVT?=
 =?utf-8?B?YlByRW9nMGd2NnhZdmZBUmlDVkZiQkxxVDJjVXJRN0V6ckduQUJHK0xtbVlC?=
 =?utf-8?B?YjVlNUJ6TytIdnJVcU4yb2JGOHh1T3pyQ1R2YlM3SEpyVWoybk1YQ29CQnJO?=
 =?utf-8?B?SE52SzVleHlPa1pJY1FINnBQTC9wU3N2N0RxeWhMbFdSL0lZbGVDY0hxNGZn?=
 =?utf-8?B?azZiVUM5WWdvYTZpOFRFQlFlSHpVWXl0aVFTOFNJckpLZVN0WTdENlYva0pw?=
 =?utf-8?B?dnJSUnZkTmNMRXhhdHI0RlRVdVdoeEhKV1A3ZitjQ3JUbm1ZRUlzK2hHQXpv?=
 =?utf-8?B?aHpwd2g0TEljUnhrckVoOFQrWGVubUpPYllNMUhBcWUrZzExZlE2dWZXSHhu?=
 =?utf-8?B?NFpyUkpvUWwzVUdHbXZneVAwcUxKcEJyL0ovM2xOaHpTZmU2elBJdVZHRHAv?=
 =?utf-8?B?K3RtZFlENjk4NmF3Z1FhRldINTRTYjBGeXdPcXovWW1QczFDZWh4YnovSndi?=
 =?utf-8?B?UWg0K09URUN4WjBVaUdVQmtoNWkrUU9PajZzUUU4ZkZ0YUxlR29FeTZ0S2pT?=
 =?utf-8?B?T0E3Z1FHd1JlM09ndktsTW9DdVZXLzI1WEQyd1RCb2tYblBEbnRGSlllZ1hu?=
 =?utf-8?B?Snd4R0NlVEYrMkxaS1ROU2F6ZEVGUmRyY0xIZzhiVm1pRXFOenR2UHV6eTZv?=
 =?utf-8?B?N2JBQWFwenFYbjY4M2JwSTkyMDVNUFdpanNkTlUvcDVTajNzYlF1Q2IvdUc3?=
 =?utf-8?B?bFVFOFRyMnI3em5vZ1hsQ2ZJVHh3NEIwQXJzeFFpWmFMUnpWVVZYa1VaSUo0?=
 =?utf-8?B?N3llZnYzWWo1MHh2N0swQ3FCeDlUak5ibmFpL1FiRGRiWWVjdWFzZm5VOUho?=
 =?utf-8?B?QTFaejJLSXh5bGpsNUtWanU4cVYzMVNJM2FtZ3BRUDNxaVlXMkdZK01sQkJT?=
 =?utf-8?B?OFdtZUJzdjliNmRCdWlmQ2YrSmV0RGNpbGQzSlJSZGpJVkN5Tml2ZjEvc09y?=
 =?utf-8?B?dDluT1NyeDFBK3NhaVR6dmk3VW5veUdOWFkvQVBhWEFNMGttak9iR2IyU29n?=
 =?utf-8?B?WnAveE8yaVIwa0RJanhkRFdtYlhUS0FlS0ZEc1BoYnE4K2FBb3N5K1lwYUQ2?=
 =?utf-8?B?bU42dm9zRlZ1MEc3MDVwVmtnOE1Vb2MyYnZMQXNpQlExcVhLd0pJbGxJTUJP?=
 =?utf-8?B?bUdOTzZlRk5KVXU4bktnOGhQZEYxYlYra2tEVE9LakFQTGE1NkJLZjgrckJX?=
 =?utf-8?B?UDFSZ2haWklaOVFja002U2pmNjJpcXY1VnF0cHBJLzJsR0ZnYmVCd00xZEhn?=
 =?utf-8?B?UzBKTzBhN1JOQmlnRUNMMVNLMmlBaFlmcGdsWUgyZVB4NjYrQk1xV3ZpVWgw?=
 =?utf-8?B?SW55UlA3UlJUN0UvMVNmTXMzSHNlaktPZlRESDRqRy9HWUpDUjRlUWpUOUdN?=
 =?utf-8?B?MkVWTGJEQlNVNVhDU0VkNkR6R1hiUzFaUmVlQk5NSU1nS1lER3h1U3BqTXgr?=
 =?utf-8?B?aURycmtrY1dXNVd1S1hXclNYRzJLNnNLZCtRZXhIbFRCWWlLSWxwQmZ1djJ4?=
 =?utf-8?B?d3A3cVZFS2Y1MGVyTXVhcFBZa0wra2xxQ3dUN1JMbmFJSkZwY3dtTFRBTjJt?=
 =?utf-8?B?a0tVemFKcHhpK2NjZmRoQXFBR2xHTEZIWGhrRVc3U2R5b1NRS2p1d09QdjVP?=
 =?utf-8?B?cVFXRi9XTm5veVhlQW1RKzhDWFRGVThrVUJWQnhhNm90WjJRbTdWR0ZCeHJZ?=
 =?utf-8?Q?UiqLt/li7iKwOibiu1HSAFMT5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0947df18-d817-4739-38b2-08de01f68acb
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 20:59:13.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wCLq/lilhk1+NviO6LFna618V3RyhvtyueXRvlmKwSIsSdN2KmoGpDWqlK1siOAkM81RdMSesVT1apThCntiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6258
X-OriginatorOrg: intel.com

Vishal Annapurve wrote:
> On Tue, Aug 5, 2025 at 12:59 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Aug 04, 2025, Vishal Annapurve wrote:
> > > On Mon, Aug 4, 2025 at 5:22 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > : 4) For SNP, if src != null, make the target pfn to be shared, copy
> > > > : contents and then make the target pfn back to private.
> > > >
> > > > Copying from userspace under spinlock (rwlock) is illegal, as accessing userspace
> > > > memory might_fault() and thus might_sleep().
> > >
> > > I would think that a combination of get_user_pages() and
> > > kmap_local_pfn() will prevent this situation of might_fault().
> >
> > Yes, but if SNP is using get_user_pages(), then it looks an awful lot like the
> > TDX flow, at which point isn't that an argument for keeping populate()?
> 
> Ack, I agree we can't ditch kvm_gmem_populate() for SNP VMs. I am ok
> with using it for TDX/CCA VMs with the fixes discussed in this RFC.

Sean,

Where did this thread land?  Was there a follow on series which came out
of this?  I thought you sent a patch with the suggestions in this thread
but I can't find it.

Ira

> 
> >
> > > Memory population in my opinion is best solved either by users asserting
> > > ownership of the memory and writing to it directly or by using guest_memfd
> > > (to be) exposed APIs to populate memory ranges given a source buffer. IMO
> > > kvm_gmem_populate() is doing something different than both of these options.
> >
> > In a perfect world, yes, guest_memfd would provide a clean, well-defined API
> > without needing a complicated dance between vendor code and guest_memfd.  But,
> > sadly, the world of CoCo is anything but perfect.  It's not KVM's fault that
> > every vendor came up with a different CoCo architecture.  I.e. we can't "fix"
> > the underlying issue of SNP and TDX having significantly different ways for
> > initializing private memory.
> >
> > What we can do is shift as much code to common KVM as possible, e.g. to minimize
> > maintenance costs, reduce boilerplate and/or copy+paste code, provide a consistent
> > ABI, etc.  Those things always need to be balanced against overall complexity, but
> > IMO providing a vendor callback doesn't add anywhere near enough complexity to
> > justify open coding the same concept in every vendor implementation.
> 
> Ack. My goal was to steer this implementation towards reusing existing
> KVM synchronization to protect guest memory population within KVM
> vendor logic rather than relying on guest_memfd filemap lock to
> provide the needed protection here. That being said, I agree that we
> can't solve this problem cleanly in a manner that works for all
> architectures.



