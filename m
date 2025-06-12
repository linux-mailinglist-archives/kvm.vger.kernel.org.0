Return-Path: <kvm+bounces-49265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C8AAD70A9
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 14:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B7C33AF815
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 12:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C3D229B12;
	Thu, 12 Jun 2025 12:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+bryTT4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169022B9A7;
	Thu, 12 Jun 2025 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749732211; cv=fail; b=IDznYF5skQW0wWOEYrjbX1GJ+Ze70gaLKdSesGJ+DsrK3ZEXp6HPX1YxztFxqYA5LvrTIuRjDIAR5uZMtXij9GgorbAAhtDyf3A8znvaR2qEm+q0bks5zsaCmzYY0Ud5DHsWTF8HeySpRQMxi5Mhe7fI4ELhozBBE8vTWKorJ1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749732211; c=relaxed/simple;
	bh=+bDU8q9k9Z5fdADusHdu9ALKJ3fXiKWBecREvDaPjBY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gTfI0PmRMqPcVhr27GjR12gtHVFSsmCxtfCvILLrNJRW3XEcLXfvW79BFQpbjq8o5A0FzaaOax7tQIjsa/4xcJNa7SdpqX5Bj13cdhp3IYeoT9Uzr0HCax38GwH2VSHHh2vcNVCsJ5avYsmbDGI7pmyZ6hRY2a23qzM0olg/02k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+bryTT4; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749732210; x=1781268210;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+bDU8q9k9Z5fdADusHdu9ALKJ3fXiKWBecREvDaPjBY=;
  b=f+bryTT4msqTkThquxkUwfIDnBU8yrGApLiC6PZtnXUbjx/doxcCKAih
   tXHkCz4oyaGeVT7dd8QoJYOAQOalB91xRQXQc59wtaLEel4UCOyJjqr39
   FVDKN8JXLRd1NKirZTgty6Yf5A7KxcUY6UJetxpfvv19zNVJEL+K78I7X
   WyTSd+MIH2qrINfStYXe8kcBYVQcPA7CMfjQIXGdKPkGpf8II4Je3n1PR
   iXn9umNVUPy4Z3xmht6575rBma0dHU9p/a75I1+VYC397m6fuJkjiIbq3
   uWPMFDzZPLWBmAeIXDuvm7k6zmYpOvGixw/UZL5vKqcGtK7575dgkE5gz
   A==;
X-CSE-ConnectionGUID: h4SVOyE1TSOxgNX0FbxOVw==
X-CSE-MsgGUID: 5OQ7XMzbSS20PfcXiDWUsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52005310"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="52005310"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 05:43:29 -0700
X-CSE-ConnectionGUID: HHmoSE/kQPygeQtYgSCZYw==
X-CSE-MsgGUID: qjxwwRPsQg+93NNPsrf4Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147389252"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 05:43:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 05:43:28 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 05:43:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.47)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 05:43:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cT8YY3CqPEjY+18uhLdhWd+gTubzhQ0XRZskYFauVDOJXpytR62Aro/rZEK+qtBPjrARVjBUuY0Qku8uH+GO7EEWuZmbKA7KJ+MGXjc/i26t2FiHxwDtJIacWOb++13jZ4S83i2iYlOIA4aM4VzB+mIjqIvc341UgOsDkFEUkOlklyRv0Q6wDUvnmtryp3tcQ1adOJjqVbK8zbvB2s1euVQi3122oMPM9zhArbivROQ5tSfW893/4M9FpIqtp6Zxo0AcATibqdgNT3uivzFpOJvyLS0dIbvVRKFujmeALPDC1WmtG6DH3PvnN6+7e34yys2XLmhjH/f6PgC1jD00kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/7fSwENIwUevqzfw6EmgfagBzJhX7YuZ4kU4x6wiRs=;
 b=NX/521YBHG9yACAHdThPWgN1XPqQlUkJp7vdcGCc16MQ0XPlw8CPW6nuWVFpDXOXt0ZRavNyiTXli2oDL21PDUqDWP+urIWklXgSDo60qVCC1Vk4jfEBOP5kM31NsUG5COBPe9sURvQs9aRih7qFLn5hvMLxmVfZV5eP1DcVICvjTD0s7LRzUJAywmRyuaK7aJm5jfLljOh6IuXH0puEVs6Eo0r6qB2TR3X11a4/gsIseXqS40I5B0IrtC7JErI502X/H9bksJ6kUlBztZiVnQXwd97ltoDxbQ64AQeinejow+Tuw7Q+JbWU7EXlh8jcx+sJO1QBdgFUxDnZbwvcNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4977.namprd11.prod.outlook.com (2603:10b6:303:6d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.18; Thu, 12 Jun 2025 12:43:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 12:43:23 +0000
Date: Thu, 12 Jun 2025 20:40:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <michael.roth@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
 <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
 <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
 <aD5QVdH0pJeAn3+r@yzhao56-desk.sh.intel.com>
 <CAGtprH_XFpnBf_ZtEAs2MiZNJYhs4i+kJpmAj0QRVhcqWBqDsQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_XFpnBf_ZtEAs2MiZNJYhs4i+kJpmAj0QRVhcqWBqDsQ@mail.gmail.com>
X-ClientProxiedBy: SG2PR02CA0079.apcprd02.prod.outlook.com
 (2603:1096:4:90::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4977:EE_
X-MS-Office365-Filtering-Correlation-Id: f3fa9281-edba-4901-fe9d-08dda9aeb814
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z1FVdXVNZGNpUmxzaUFnTnU4YVpBamVObGplSjB2M20wNkIvVCtWUnZSazlN?=
 =?utf-8?B?d25vNXlOTm5WcnJhekd1OUdpbnhsZ2FoMmZUdE1qVlBOR1Q2ejlTb0JFakg4?=
 =?utf-8?B?Qk5GWUxJRVNkUEpXaHVhbWdGS2dicmw5TUNBK2QyUW14dmdiNnNNd3VnUmpw?=
 =?utf-8?B?MHhSZWp6YzNuWS9tSGg4S2U1d0RnL3F6SS92eGVjQm1hc1FlOVBVeisxUFU2?=
 =?utf-8?B?TldsaXZlVDdUUmI1dDlzZVV3UlZVTHlQU25TNFFLZ3Y2RUlIMTI4UFpzeXBp?=
 =?utf-8?B?Rlg1S29hQU15WGlydk5nWmpQa2h3QlpyNk11dTF1TDI1cUF4RkdDY2tCM2Y4?=
 =?utf-8?B?TE0wZ1piTVRjOFRMaG5LMzhMdklURDZ2L2U2dUxCb1NCVWhzNUhPR3hqcnl0?=
 =?utf-8?B?RytTZm1PazM5ZlNnbnpSZ3FpMjZRTW96ZmFDa1EvZ1JuaUNvT3Q1YjBSWFpG?=
 =?utf-8?B?WlZUYVY4eG1icGFPWU5ybEwrTjdIeG5BT29ia01TU0JYb3Zhd1NjOGxOZU90?=
 =?utf-8?B?ZWZ1aFZONU9lQ2luWUJ6VFQ2dVVmT3pqTmx6QkVONTZtbEx2M3hvZjd5cnly?=
 =?utf-8?B?eXRxYlVUQklhS3lZOU4yV3NDYjdHcmhDMUhQdTMvYy83WFd4cm1VV3hoVm5W?=
 =?utf-8?B?RTZJMFBPSVRvYlh3cTV1QzN2TWtidmprR1Q0V3VxMUtIUGF3dHN0V3ZPbjZE?=
 =?utf-8?B?M2Nxc3ZONVlsamtVS3VLeFVRb2dUNDM0MDRieHJHRDJUZXo2VlhvODQzMEZC?=
 =?utf-8?B?WDFpLzlsQXRsZ2k0TUVnR1ZYOC9zRFdzdVVjSkI2ejZnNTF5SDNnSWlmZ2ZR?=
 =?utf-8?B?UlNOOHBwVnlpYkIzd1NqU0szcHlBYlJKKytQTUU4UUw4UzRuUmNrVkZ4MnRQ?=
 =?utf-8?B?cEJHU2tnSVVhWnNsZTZ1UkhVTml0VGN1RGZUSkNUMDRTb3hPY1NGK2IyNXo0?=
 =?utf-8?B?bDBhcXppM2JJTVBucVk5UDVBaEZSMmYvUENyTFdmTVlXeDNmNVJTWFJ0Q0Zz?=
 =?utf-8?B?RVhIYlpEZ0h1UXZQWFFjRUNnVkZJVlEvWHVZWDN1ZittWFRvUjdTTFVpWmhk?=
 =?utf-8?B?S1granVSbmNwUm12cmJubHpENncvU2oyWTFLYkVLTUx3eVFiNUJsQW1TTHhI?=
 =?utf-8?B?b1BBNFpHTkYwcnZSb1N2aXllTGpNYmxrU01QSnkzaGhkT0Q0R09ZV2VvcVds?=
 =?utf-8?B?ODRRay9vVFppTVp4K29SRGMycENCb0pRdy9NMkdhVnlGYUEzSlZXakFTQzNh?=
 =?utf-8?B?UHJjQy9BRjhSYWR6ck5PYUxkRmpYdUNpZW5Eci8zQzExaklSUTZaVU01S01w?=
 =?utf-8?B?SDd6aEZjS1N0ZE13dGZ2RkRBb2hlVjdNQ0hKRjBGcENWVCsvU0k5OE9Edi93?=
 =?utf-8?B?WWFER244Y1NLdWFrbEk3bFBzcmhUU0o0eXk4ZmdwL3VlbHdJaTRRNkx2S2lo?=
 =?utf-8?B?RGxtbEI2V2pDbkVtZXJ3dU5aVE9nUG1XN0I2allUNmJFRjJVYUZRdjM5UnVQ?=
 =?utf-8?B?cnBWazQ0VjBGQURIZ3h4Q1dFRytUNWRxMmpxMUdlUElLM21xWWEwcTR3Ykdw?=
 =?utf-8?B?M0NyUTdUSTB2dXlYcVBveXdGUjIvWnpaaGd5S1NwYW1qTTlLdHJOWkF6RjJ5?=
 =?utf-8?B?WGU2eEVxdGo3YTBzdmdpMngzNU5KM2ZDcG9PK3hGK1VnS3MrVnErN3J3Y1pn?=
 =?utf-8?B?ckptRUx3MFRDNmJFeTNGSExzTVBBRHY3Ly9UbkR5b2RFd2Q3cHA5YnY1QWsr?=
 =?utf-8?B?QTduWGdZQ0RlSEp6eWVXZDB2ekdIWnpiTGRzc3F0VmZMcUc2YWVRdjlyajFJ?=
 =?utf-8?B?S0RTN1Rtb3Q0Sm5xWTZVaUdkNUtjenB4UW4zbTAycDZpek5DRWJCcUZSU2Z5?=
 =?utf-8?B?YVlidmtzN2NkUHFxaldIb2llVjNsQkpxRHJVazV5Z2hOK0g1ekdEb0ZtYzdM?=
 =?utf-8?Q?yuyFiNCyIcY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TW5tNzE0VFdEd3J6Q3pQR2lWZDVSWVB0VnMvbklWejdSOHNvb1I2b0c1L2lo?=
 =?utf-8?B?ZnVOakNmOVV3QXpkTkMrcmlEK3Vid1RHTG1XU2hZZkMxL2dSY29TWS94UElW?=
 =?utf-8?B?cVJLRUZtSFY2WFYrMklBQTQ0akNMRThXQjJwa2FPKzlkcTlMeFpDUG9NcERX?=
 =?utf-8?B?VEhvSHdLb0IrSHJsQnhsTXNCL1YxRk1SUExlVm14NHJKQUUzdERCMjN4Tno0?=
 =?utf-8?B?bEZIamRvSnFJTjRoUkhvaG90NmJGUEVMSHpMdG1ZMC9RNlhxa3NSOGVwRjNr?=
 =?utf-8?B?TnZjbGlZeG9uOHRzYzVRazFOVmdWWnRzSFJaQzNSWG4renpnT1AyaEEvNW1n?=
 =?utf-8?B?RWs5c1FnMmhSQll3bjdOLy9zT2s0cnhOblNYcmhRTGNTSVp5dEVLWkxyM0xY?=
 =?utf-8?B?OXhUelpnUFYrbnBUbVlnZjFUTVVEbkN0OS9hbmtVWUxPNE9jQ2RXQkI3OHZX?=
 =?utf-8?B?U0ErT2NPYXgvbzg2bjI4ekJiMTAxVmFFQ2pXV1g3SE1ZOXQ3QlFHQ0dlUndQ?=
 =?utf-8?B?eE5tSlJVV1VWWXczbkRRSDF3azJKRHphWTl0YmpuQ01TN0pPT016cVhxUDUx?=
 =?utf-8?B?TUg2WGU2RVFtUmZqZDUyQ251RVNKdzY1eHZIUk8yZFByb0g0cFFGYWRZM3li?=
 =?utf-8?B?K3hReEVRTHBQRDFtVis3VTlzakNscytEWlhhYkdpWVJCV0hBc21IVDE4WHND?=
 =?utf-8?B?WWV4NFkyL2RYRlpKRitaZVNianh1L1E5VTBnY3BjcURwWlJoTmdOWlZlU0s2?=
 =?utf-8?B?WUgzeVVnSncrMWlnWitOa05RVjRIUkFGS2pXbTlrd1U0eThEQy9ITTdGUkJL?=
 =?utf-8?B?K0ZPS08xOWRpbEJLbWkvQ3JoTmJ0SGEyLzNnM1M1bmkvT29RbHBDdDhxTHB3?=
 =?utf-8?B?TThwcVRWVmlMR0NLRS9aMklaL3F5L1ZmUjF4aE5yKzBJQ29RQi94RDhCN0xB?=
 =?utf-8?B?cXN4T1dkSFpaRVIxZlZ1OW5yNlR3T3ZVU3FUZHU3eWpOWGJrY1F2TXlCU2kx?=
 =?utf-8?B?NXp0aUpsb2VUckZGVjA5eWMvbEhYaFNEQ0dxbXNybHdmUitFRXNGTitKVjNZ?=
 =?utf-8?B?UVdITEJtbEZBM0MxZzZOeHVwazh0VTk1QnZyV25vMGJrbEErY0V0Y2JmQUQ4?=
 =?utf-8?B?MWhXMzhoZWxFWktyeThobmFZbWJOUUR0Vi9WTVVPOGhHNExPYXU3djVtenY1?=
 =?utf-8?B?ODQ2WUN1aTZ0emVlOHRCT2htVVZmTElLZmJNTXJiMnZIbUl3L2h1N1JMNWVP?=
 =?utf-8?B?MkN1UzVVVjdVcm5IQUlTMFNjbEVzUjlocFlaQkVSQldHdFdRYkw1UWlVWnpz?=
 =?utf-8?B?b3VTVkZXL1kwWUg2aTJMVExQRGxHNEM3VklkU3E2U2FNaHlpZnc4YURTWUhk?=
 =?utf-8?B?Q2N1Nk4ySFpKZDF5QWFyK09QRlhKMGRLV1lsZGF0a29YRGlHdFNhT0hNSkxZ?=
 =?utf-8?B?TU4yRVFyb2dJVFJ4WFNxemYwN0EwdDloc2FuSEZZMHJ0Mmx5elhTcU5YczFG?=
 =?utf-8?B?TkVKemlVL1FZZXBYc2cxSGhuSUtLU2Z2Zzd5TlNKcTFucDI1ZUQyQmlSYWlV?=
 =?utf-8?B?SUw3Z2YwbTBDS01kNUE3Nk45UlpLbFBkazVxdng5K3Uyd2pjRUd4TkZ0NnM5?=
 =?utf-8?B?QmtOdXpteDArWm15V01KWnpURThwN3c4NnlISktQRUNCZTB2OFkvdW4yUmor?=
 =?utf-8?B?MDVvMUNlYXJnY1dheEgvYzVjaG1kTlIzNldYSmRWRm01RHVmZzQySWZYRWI2?=
 =?utf-8?B?SDZ6SitpRTdIQjRhbVpzalhjQ1lLSERpcVF6a1l4eE1PcE5yWGpYYVA4RmtR?=
 =?utf-8?B?enlRM3o2Y2FUcysrcktjVllPWFZGN2EvNjNVL01MN1pSSWF6Qnl2UnBOeDRQ?=
 =?utf-8?B?c2daYVJSM0k0MENTWHpMYytXL1VVVkM3QzQ4ZHpSRE9aVWlzYUx2T29aTEZ3?=
 =?utf-8?B?SElpR2FoMXIwOGtCMzZwOE0rdklyRndEcmRwcnc4Tk1LaFN3TUJFdlZjcjJz?=
 =?utf-8?B?SUUrUlh2ZlQxKzdVMWVWRENqOS9MY2dhQiszMDFuNWdKWWhZbE1NdFdzVnRL?=
 =?utf-8?B?dFdyWVE1N0pnUHZFN3Q2Q0ZmbXhnaUdLemlHMDRGVSt2aXQ0UW1uczl3bGlR?=
 =?utf-8?Q?xDh0SV45W5hrLBKvgVfPInLwX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fa9281-edba-4901-fe9d-08dda9aeb814
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 12:43:23.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFPIIcMk/hXT+zSsnZax8WwQTDQL/R+GfJEpu5Sjgfmad/LByG2TD+uo2oP2ZHJBIbrPWXlqZdxKtxmGAPIZbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4977
X-OriginatorOrg: intel.com

On Tue, Jun 03, 2025 at 11:28:35PM -0700, Vishal Annapurve wrote:
> On Mon, Jun 2, 2025 at 6:34 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Mon, Jun 02, 2025 at 06:05:32PM -0700, Vishal Annapurve wrote:
> > > On Tue, May 20, 2025 at 11:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> > > > > Ackerley Tng <ackerleytng@google.com> writes:
> > > > >
> > > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > >
> > > > > >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> > > > > >>> This patch would cause host deadlock when booting up a TDX VM even if huge page
> > > > > >>> is turned off. I currently reverted this patch. No further debug yet.
> > > > > >> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> > > > > >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
> > > > > >>
> > > > > >> kvm_gmem_populate
> > > > > >>   filemap_invalidate_lock
> > > > > >>   post_populate
> > > > > >>     tdx_gmem_post_populate
> > > > > >>       kvm_tdp_map_page
> > > > > >>        kvm_mmu_do_page_fault
> > > > > >>          kvm_tdp_page_fault
> > > > > >>       kvm_tdp_mmu_page_fault
> > > > > >>         kvm_mmu_faultin_pfn
> > > > > >>           __kvm_mmu_faultin_pfn
> > > > > >>             kvm_mmu_faultin_pfn_private
> > > > > >>               kvm_gmem_get_pfn
> > > > > >>                 filemap_invalidate_lock_shared
> > > > > >>
> > > > > >> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> > > > > >> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> > > > > >> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> > > > > >> ("locking: More accurate annotations for read_lock()").
> > > > > >>
> > > > > >
> > > > > > Thank you for investigating. This should be fixed in the next revision.
> > > > > >
> > > > >
> > > > > This was not fixed in v2 [1], I misunderstood this locking issue.
> > > > >
> > > > > IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
> > > > > part of the KVM fault handler to map the pfn into secure EPTs, then
> > > > > calls the TDX module for the copy+encrypt.
> > > > >
> > > > > Regarding this lock, seems like KVM'S MMU lock is already held while TDX
> > > > > does the copy+encrypt. Why must the filemap_invalidate_lock() also be
> > > > > held throughout the process?
> > > > If kvm_gmem_populate() does not hold filemap invalidate lock around all
> > > > requested pages, what value should it return after kvm_gmem_punch_hole() zaps a
> > > > mapping it just successfully installed?
> > > >
> > > > TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_populate() when
> > > > CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the filemap
> > > > invalidate lock being taken in kvm_gmem_populate().
> > >
> > > Does TDX need kvm_gmem_populate path just to ensure SEPT ranges are
> > > not zapped during tdh_mem_page_add and tdh_mr_extend operations? Would
> > > holding KVM MMU read lock during these operations sufficient to avoid
> > > having to do this back and forth between TDX and gmem layers?
> > I think the problem here is because in kvm_gmem_populate(),
> > "__kvm_gmem_get_pfn(), post_populate(), and kvm_gmem_mark_prepared()"
> > must be wrapped in filemap invalidate lock (shared or exclusive), right?
> >
> > Then, in TDX's post_populate() callback, the filemap invalidate lock is held
> > again by kvm_tdp_map_page() --> ... ->kvm_gmem_get_pfn().
> 
> I am contesting the need of kvm_gmem_populate path altogether for TDX.
> Can you help me understand what problem does kvm_gmem_populate path
> help with for TDX?
There is a long discussion on the list about this.

Basically TDX needs 3 steps for KVM_TDX_INIT_MEM_REGION.
1. Get the PFN
2. map the mirror page table
3. invoking tdh_mem_page_add().
Holding filemap invalidation lock around the 3 steps helps ensure that the PFN
passed to tdh_mem_page_add() is a valid one.

Rather then revisit it, what about fixing the contention more simply like this?
Otherwise we can revisit the history.
(The code is based on Ackerley's branch
https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2, with patch "HACK: filemap_invalidate_lock() only for getting the pfn" reverted).


commit d71956718d061926e5d91e5ecf60b58a0c3b2bad
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Wed Jun 11 18:17:26 2025 +0800

    KVM: guest_memfd: Use shared filemap invalidate lock in kvm_gmem_populate()

    Convert kvm_gmem_populate() to use shared filemap invalidate lock. This is
    to avoid deadlock caused by kvm_gmem_populate() further invoking
    tdx_gmem_post_populate() which internally acquires shared filemap
    invalidate lock in kvm_gmem_get_pfn().

    To avoid lockep warning by nested shared filemap invalidate lock,
    avoid holding shared filemap invalidate lock in kvm_gmem_get_pfn() when
    lockdep is enabled.

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 784fc1834c04..ccbb7ceb978a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -2393,12 +2393,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
        struct file *file = kvm_gmem_get_file(slot);
        struct folio *folio;
        bool is_prepared = false;
+       bool get_shared_lock;
        int r = 0;

        if (!file)
                return -EFAULT;

-       filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+       get_shared_lock = !IS_ENABLED(CONFIG_LOCKDEP) ||
+                         !lockdep_is_held(&file_inode(file)->i_mapping->invalidate_lock);
+       if (get_shared_lock)
+               filemap_invalidate_lock_shared(file_inode(file)->i_mapping);

        folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
        if (IS_ERR(folio)) {
@@ -2423,7 +2427,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
        else
                folio_put(folio);
 out:
-       filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+       if (get_shared_lock)
+               filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
        fput(file);
        return r;
 }
@@ -2536,7 +2541,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
        if (!file)
                return -EFAULT;

-       filemap_invalidate_lock(file->f_mapping);
+       filemap_invalidate_lock_shared(file->f_mapping);

        npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
        for (i = 0; i < npages; i += npages_to_populate) {
@@ -2587,7 +2592,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
                        break;
        }

-       filemap_invalidate_unlock(file->f_mapping);
+       filemap_invalidate_unlock_shared(file->f_mapping);

        fput(file);
        return ret && !i ? ret : i;


If it looks good to you, then for the in-place conversion version of
guest_memfd, there's one remaining issue left: an AB-BA lock issue between the
shared filemap invalidate lock and mm->mmap_lock, i.e.,
- In path kvm_gmem_fault_shared(),
  the lock sequence is mm->mmap_lock --> filemap_invalidate_lock_shared(),
- while in path kvm_gmem_populate(),
  the lock sequence is filemap_invalidate_lock_shared() -->mm->mmap_lock.

We can fix it with below patch. The downside of the this patch is that it
requires userspace to initialize all source pages passed to TDX, which I'm not
sure if everyone likes it. If it cannot land, we still have another option:
disallow the initial memory regions to be backed by the in-place conversion
version of guest_memfd. If this can be enforced, then we can resolve the issue
by annotating the lockdep, indicating that kvm_gmem_fault_shared() and
kvm_gmem_populate() cannot occur on the same guest_memfd, so the two shared
filemap invalidate locks in the two paths are not the same.

Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Wed Jun 11 18:23:00 2025 +0800

    KVM: TDX: Use get_user_pages_fast_only() in tdx_gmem_post_populate()

    Convert get_user_pages_fast() to get_user_pages_fast_only()
    in tdx_gmem_post_populate().

    Unlike get_user_pages_fast(), which will acquire mm->mmap_lock and fault in
    physical pages after it finds the pages have not already faulted in or have
    been zapped/swapped out, get_user_pages_fast_only() returns directly in
    such cases.

    Using get_user_pages_fast_only() can avoid tdx_gmem_post_populate()
    acquiring mm->mmap_lock, which may cause AB, BA lockdep warning with the
    shared filemap invalidate lock when guest_memfd in-place conversion is
    supported. (In path kvm_gmem_fault_shared(), the lock sequence is
    mm->mmap_lock --> filemap_invalidate_lock_shared(), while in path
    kvm_gmem_populate(), the lock sequence is filemap_invalidate_lock_shared()
    -->mm->mmap_lock).

    Besides, using get_user_pages_fast_only() and returning directly to
    userspace if a page is not present in the primary PTE can help detect a
    careless case that the source pages are not initialized by userspace.
    As initial memory region bypasses guest acceptance, copying an
    uninitialized source page to guest could be harmful and undermine the page
    measurement.

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 93c31eecfc60..462390dddf88 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3190,9 +3190,10 @@ static int tdx_gmem_post_populate_4k(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
         * Get the source page if it has been faulted in. Return failure if the
         * source page has been swapped out or unmapped in primary memory.
         */
-       ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
+       ret = get_user_pages_fast_only((unsigned long)src, 1, 0, &src_page);
        if (ret < 0)
                return ret;
+
        if (ret != 1)
                return -ENOMEM;


