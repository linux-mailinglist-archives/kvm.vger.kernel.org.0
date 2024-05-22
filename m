Return-Path: <kvm+bounces-17896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F9F8CB876
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD59D280E36
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461E915B3;
	Wed, 22 May 2024 01:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CBP62Sfg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C264C7B;
	Wed, 22 May 2024 01:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716341408; cv=fail; b=Xe3coYbKUR/o0NBvHbdR7GxZDStlQ3Yocu3eNQ3hLBbjxk16JppEJ0JVyorGwj+oHSMcsaCFY4z4OzR8DlpMRuqei+DZJ5sjm0apjdBAEKaWcuV00cwZalmQxwf/mXPB/k0FVXslffejzEeeTQUy0Y6HA8w0nlkvGGUSLYXNW2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716341408; c=relaxed/simple;
	bh=G12qxb0NNGGYU+iz5G3oZBvQ3cov3SJ4vssfyTex5Ws=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aUYJJMXIRsSfhcZSwtTwMpDghZeXaLjhl/NykV+NpHOtUu6qX/lPI5fkGBNiPx0Y86b9y+hPMmOfkvRZhKxWPe4ONmolFj3Dd9CnjpVTgRUjpbdS/0B+OWly52vtjlmAdiisHZQGZRMZw0dmHdYIoye9E2n+3+4XZoDpOl7kyp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CBP62Sfg; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716341406; x=1747877406;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=G12qxb0NNGGYU+iz5G3oZBvQ3cov3SJ4vssfyTex5Ws=;
  b=CBP62SfgloIaLxSObGlIApqet7WEI2Ehn172ixq/VTnq5oDsXZYBFuSI
   vCnSTEnqUOallUVbB7InlJC7zc568mbCAW7124LGRNqGmJk9fz2m93WBv
   NqnvgylpiK03xWRBGfFzuY8+SaPcYDJSMZIueexYObsuEEDFR2UTWQXYu
   mqd5kJP0IfIP21F9oxHRXORGBKAJ7BCJDi4d47QWCXVsB7mdbnrqnzqan
   VknWtks9EaXTLx9+WbQBlz51tU152TdDXo4VTTQ163DTj6CBYNigmJuRh
   XHcGNJGgDSEHUSX2V0T6M5yzulLXiu75do1MXjEibhKkok8eHcQU1O6N7
   g==;
X-CSE-ConnectionGUID: 8hPXzyMzQHuIiST7oy6Qug==
X-CSE-MsgGUID: Z1WH4cEzRMuv4r67VsRgZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="11640556"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="11640556"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 18:30:06 -0700
X-CSE-ConnectionGUID: /28i/hvzQ321Av3dmFjMyw==
X-CSE-MsgGUID: 4PwbjfsjSQm4YMM1LXUG/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="63944743"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 18:30:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 18:30:05 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 18:30:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 18:30:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 18:30:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVPBMShCipDPXAv/KAcw7jmpogmHF78eNBJWggDq32rC5NEBuWj37PHC1KzPupR8UNCfv8r/OkZBvANUs8t6/PB9gUGlKvgxfiZyUSLZVQnCg9rrxpwHJRFhSN2CL/cjp9fapEojNp5cHf8IQ5b8UbQWR9CMUvsM9tfkCTuO2RgpnvKyQpJ4LlaSvIHKt/PAWKMm3kGCtLkj2IM/avTULuA/r8jGqXfVNaSCUyUhkiga1jDHRcnUkDdo4k1/wuNUX1If2kMP2xP8vyd8TNkMQAlHhr1bddtNq2AxOGqcYBrD99Fjc/JhRm41PxuG/S9L0GGAd7uNCPVUOCx0v1rLWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wStgtuY/o8NKzfSpxCSG7qazqoeMiJ7WcRfCrOl/0A=;
 b=NwgsPHHlfnU2IdvD28Oa8x7O/5jPN5Xw3sc9V8XOl3E0x7VnQyIBHm5/xsDRfJ+l4qmNI5f5v02T3ZfL1mIXclQs93To71HVsJjdpm/6A8EmtiTqU9McQZVK5T+KWiWOsREzl/XWvpCnBr7rR5HxOpGuxUV8PBKv4lBYu3wpJje/Sn4lY8w5J/y9tKY369RF8O86tbrTKd3bhvRhpz+ebEF8+xBOv7b9qFJmS3m25Ey5T1UGn0ntnO1jGOsqYOZ5141KMBMF6JUYa8PkR3NokXbl/96zouqC/d/bZ/jITsGvMtRtyvNnhK06D6iAS77WCkdMmkfHe5VDrJaDvlvXYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.19; Wed, 22 May 2024 01:29:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 01:29:57 +0000
Date: Wed, 22 May 2024 09:29:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Message-ID: <Zk1KZDStu/+CR0i4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com>
 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
 <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
 <ZkVDIkgj3lWKymfR@google.com>
 <7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com>
X-ClientProxiedBy: SG2PR04CA0183.apcprd04.prod.outlook.com
 (2603:1096:4:14::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ad79a23-fbe3-472e-493b-08dc79feb0a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MmdtN1JQSWU1cUZ4UlRka2VsemtMRHEwcFhBeXVTYllGRTBvOXVWNUdGVkRW?=
 =?utf-8?B?bnNRaEZCTU9oR3BXcm5SQTdQUFhacU9GK3BQRmpGVlIrbnFrOHlnWUVLMnA1?=
 =?utf-8?B?Wkl6UW9rSkVzbmdRNFpKc0tibyttbGFXbnVFQUVuUzVYcUVHbEVDYjU5VVJM?=
 =?utf-8?B?RzNwWXBYTW1xdVduY1B0WEtGVC9Lb2thaUlSSnJOOUZmaGdjR1BFSkxxSjFX?=
 =?utf-8?B?bjNiOHh0K2xVWk5sdE5GZ2tyd0t4aDhIbjZvTklHWFlZOVpXZENNeU11aGRs?=
 =?utf-8?B?NzNwVEV4MnVVUlZpaHZWelVqVTJjN01pVVJROTBmYmRYRGIwMzEvM3RlTGRJ?=
 =?utf-8?B?aThKc0VaMm1yTENXZ3YybWVkMkp4d3VveVdWdFMwQ1FYZXpVcitlWkI3dllQ?=
 =?utf-8?B?UTFFTW5zYXdDUkczMG1ONVZXUkJDckdzWTdlOW5xSTdjam0zTlRDK0lIYzht?=
 =?utf-8?B?cVVZZExTcGZmdjdabjRwaUJxZHQrbjVaNW1SS2dzc0ZqK1hvWTBwRGtyK2x4?=
 =?utf-8?B?Um83VUQyZU1ReEZYTU01TWt1RHVleFVHV2k1eUxXSEZ3ZkJSVkhONURlYngr?=
 =?utf-8?B?bW1WSFlMWm1SeGtCVGxuTG5BVEFWM1BKUmd4aDZ2dERBbjhKdkpVQytXM3dr?=
 =?utf-8?B?eXBUaGNoS0hyMFJjdWt1RW9MNmJwY3N3WEdqcHZGcXRDcWQ2YnVmVGhCRmpq?=
 =?utf-8?B?WEtXTnhlSXFNd0FwU2NzcUVQUVpmOGE4OFpFL0VlTWk0MldidG9BL0dzZ1lJ?=
 =?utf-8?B?QTJPbWpRTGlRWE9ZRktKdzY4UEwzcnpUQ0xWSmV2eThrV1U1MndPaXF1bDkz?=
 =?utf-8?B?MVlWcExFNWJQcFhyK1ZpQnBEcWZyNFI2MDJ2SWlHRzBqRmxKdVJ2QmRkbnNO?=
 =?utf-8?B?MkN2TnB0L0JMNXo0NTl0SG5jUTNUSkdMckpWUE51YUcwb3E4YlBNbFJzRllO?=
 =?utf-8?B?WE5QSEs2aXJ6akNUZzR0QUtCK2I4RmFia0puaUpTU3l2VHZEV1MxRTZ0cUp0?=
 =?utf-8?B?UitENmkxODVXTEZ3NE0rL2dFcmpWa0g3L3ZBNVdNSnFiVU5jTDFRbWt5UjlF?=
 =?utf-8?B?VzVtL2VOSFo0cUdqMTBHM1RFdHZRc0I4UDRIN3JMa093a0tIZHlIU0haSGp1?=
 =?utf-8?B?SndmOStucEtWblNOVWFsYjBXamhOR1ZXZGRFbkZMbGNpK1Frb3VXL09YSXpN?=
 =?utf-8?B?VlN4aWVkWExCWC9SMTIvakcwcmlwVFIxYzFvWGZzTU5yM0s0a1NIY2hRWllt?=
 =?utf-8?B?TE1GeFdSdDlqWktsNnphbitpSk1GT00wZ3VleCtRSytMWlp1YWtER2NvYlFz?=
 =?utf-8?B?dFB3NU9wNzUwUzdsOFVKK2l0NHF6WFdTekJJbUphRGwvaVRJeFQ5UGlQdEZY?=
 =?utf-8?B?eEtMa0thWERlMWdBK1NUSmtJSXdvMmZlcHQ1TGZ6ZGdxNmVRUDNvd2RkaE5h?=
 =?utf-8?B?cmt5dm5hbmd3MkNad0ZWa0phL2dvcHU3ampXdEFBcmVsSnlJRFlNaGxKUlRN?=
 =?utf-8?B?NkVsSHVFMVhvS1RCV1c1RExNODdaUE90d2JZVXhmUjNYRmJ2QkRrb1ZpWWIx?=
 =?utf-8?B?dTVxNFByK3paQU85Qjc1WnZHd3JzZld6L0RJLzNIQ09ib0MvM3J0T3VLTzVO?=
 =?utf-8?Q?5xernxvEQBvTBzOTzlkAuSYRgwgiIv7gyru7FO4cZ+fs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkpKRlo5YnUwTmNmSnZYVmd3NHNOcDE3dythbi84TmlVUGx1K3g2QmFNODBm?=
 =?utf-8?B?TWlRTTdZNWU2bmJpRzNvbzFFUDBnTzk3ZlpUOFlGWnJQcjE0NDhaalZxNWdB?=
 =?utf-8?B?K0FsUGM0MXdweE9DNm9qUjJmKzRLdW93bW5BSlJSRE1YNEk3blRFNm9wNnFw?=
 =?utf-8?B?MHBZRmZsNWFodEtoOTRXQW02L1hmNFYwUFBBWlNCVllFNC82bXpMMVl2MjZI?=
 =?utf-8?B?RTdqcGplR3ZwSzdsR21TMFErSUlJNUMxVnZZZ0UzZFNNY0ptQ0M0bDIrbFJF?=
 =?utf-8?B?Q2RtM0I1cVVaL1VxakRZc1I4NG1mOW9LRVkwRWpLQ3hYdjZGbksyUmk3SG1a?=
 =?utf-8?B?diswS1BzMHpRbUNNSVNwc0p5QWozNmZMTWNCdThaMEl4bDZoWU8vRzhJc0p6?=
 =?utf-8?B?dGZaTHdUbWRCNHJ4c05VUlRsK3pFRGFnbGNvV0taWG93bmF2djRQMDZ2STNp?=
 =?utf-8?B?ZkVNQVBFaXIyNFZJUnZEaWxPaFNGM1VMOXRBak5sN0YrRUdHa3pRWEl3cUsx?=
 =?utf-8?B?R2RyUXkvNFdscVVpdDhwNE5QWkMyOHhhNVFMMU8zcnFvbFpOSXliTUF5eG1O?=
 =?utf-8?B?Tk9SOGYzU1VtUFBTUGhtamgrays5ZTI5eDArQVA0OWQ0dExsdklCVVlUNytH?=
 =?utf-8?B?TkhoTlBhUmlQOWpNMGJwV2hXOWN5d3JCdnpncENIQUZnNEpiVGtJZnVsR05L?=
 =?utf-8?B?RDlDTGxSUHc0MlZEL1ZhZ0w4bi9LVFc5eUVTSzlYRkFxZlpCUTRNZlhEd25m?=
 =?utf-8?B?UlBSbGtkVW9uMThtb0dsU24rcFh5VDVzZURtZzFIejFJSTF1QktsYmgyelg0?=
 =?utf-8?B?cHR4L0YwQ3RjaEZWVVZHQk5rUG5oQ0Z4Q2ZZeUFORGNGMjMyZVp0VXYxdWpp?=
 =?utf-8?B?cWFDTm5hTVRQMm1IVDJpaGhBa3h4M1QvRmxsUm9DdU5PSERXQUFpa1ZXVFdt?=
 =?utf-8?B?ZUtzenRyWU5nOFgyZC9ZREQ5Nm1XRndETWpGeURqc2pLL0lQcUl2N1ltMlhr?=
 =?utf-8?B?YkkyT2FRTWlSK0FBakhMYVhlUGhHMHRueVdXbThzMzdoMy8xMkdGTUNSWlAz?=
 =?utf-8?B?cjlvaGYyRVhURVhNUmZhT21mNlVnNUhLVklvRlU2WHRGa2Rtd1FJQ25YcFVF?=
 =?utf-8?B?U3R4NFFhQzhoaVdVQ1pTWTRNaHZMOTB1RXQ0ZTNielVrRUJTYSttKzdDTFN4?=
 =?utf-8?B?bU9kTTFPUHVaNUxCUE14a3kzb2ZDRVdHd1cxUlRXR1k1azRRNURVOFlITWJ5?=
 =?utf-8?B?bmdnNVJ2UUtCdFFFeE5vckdEamRYelhlZHNpMFpxaGVFTTVTK0pxTEtMUENK?=
 =?utf-8?B?S2dDbUk4YU1hZHVPK3NEL1pSSlU3YzZuMUxPWDViVUpzaGhFTktPdE5uOG1M?=
 =?utf-8?B?NXVwNDFpSG9kVEpWV1k5dzNpc3VvWXdOOGd3VEdoajk3M09vUUR1TFlYTWx6?=
 =?utf-8?B?Wlk1UHJhS2lkMzNMdlRQemFtVXlNdXVYdVhNM1IrcEVOSWJqYnhUbnB2RzRS?=
 =?utf-8?B?Z2Q2K2cySWRQaWo4NXZQa3RxdDRaVlZXaHpMR0x1MER5QlprVHdvTU1RaStn?=
 =?utf-8?B?TEFwRnE1cjJyemFxb1ErOUlzRjU2ZHcyVU90ZzJDdDZsZ09leWRPeUVEbVhs?=
 =?utf-8?B?RFpPZmZkMmJtSVhXVTJQK2dkV01RdzcxZVJxZERySXY4YlMxVjJuZSs0RlYz?=
 =?utf-8?B?Vm5WMHd2UzQrWmN5NWkyOTZ0Q2pCM1NFM0dmY1Z3SXVXN0VUaHNuUFE2L2F2?=
 =?utf-8?B?anl6aGp5VFUyRXZrZWZVSmZUbmhobmlGWkNTL2dQclJndHd0Ynl5OXp6ejda?=
 =?utf-8?B?aFFWdVl4ZzBPeEd2QVZVdDh6TXYvUm04U0pURWd3aTFycFdJaXF6VFFmQXlm?=
 =?utf-8?B?ZDlEdXdlRjFjb0hsQ3VwVDRnMStIdjkwOUJxdDJXZXBBMnlqdk1lMG9XQmw2?=
 =?utf-8?B?Qmx0dFk0YW9WNjlwZnV0M0FReVlSZDlGc2hQTnRqZ21lUUZIZ1VDRTFUM1hV?=
 =?utf-8?B?ZG44cDVicDdTQy9TQ04wTFdydmhhaDdjSGRVYmxtVnd1VDJjdktQZDBkc2V2?=
 =?utf-8?B?dkFnT0ZKREpPUVcxd2VuTkh1ZlV4cVBxcWlMcVlkQmxZaHpVdituTTcwZXVG?=
 =?utf-8?Q?eBs6TzAlUcQPcT3+LUPRSyDbf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad79a23-fbe3-472e-493b-08dc79feb0a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 01:29:57.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zm17Bf1DHzEiNumK9LG52zmYl8Lps9OYZvpb1m4WVJYzXwUCrwGVlnkFwKgILpFjmvPRXqOiUVszg/Ud8TWtVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

On Fri, May 17, 2024 at 05:30:50PM +0200, Paolo Bonzini wrote:
> On 5/16/24 01:20, Sean Christopherson wrote:
> > Hmm, a quirk isn't a bad idea.  It suffers the same problems as a memslot flag,
> > i.e. who knows when it's safe to disable the quirk, but I would hope userspace
> > would be much, much cautious about disabling a quirk that comes with a massive
> > disclaimer.
> > 
> > Though I suspect Paolo will shoot this down too 😉
> 
> Not really, it's probably the least bad option.  Not as safe as keying it
> off the new machine types, but less ugly.
A concern about the quirk is that before identifying the root cause of the
issue, we don't know which one is a quirk, fast zapping all TDPs or slow zapping
within memslot range.

I have the same feeling that the bug is probably not reproducible with latest
KVM code. And even when both ways are bug free, some VMs may still prefer to
fast zapping given it's fast.
So, I'm wondering if a cap in [1] is better.

[1] https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#mabc0119583dacf621025e9d873c85f4fbaa66d5c


