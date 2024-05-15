Return-Path: <kvm+bounces-17470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8E08C6EAD
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DF7280CA4
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E563EA9B;
	Wed, 15 May 2024 22:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cf3VvdeQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6533987D;
	Wed, 15 May 2024 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715812497; cv=fail; b=td4b9GXx7oS8kEVYigP12q+jUmqRGYBkjm42GROB+cc/UJHgTgxWFel3pck4FahfYsC/WzvI4MGKixMM35tFC003KqnCgxqC24LKQSI7I0nsjYIEO5jal2b04DZOMK9d0UFoFO7iosCFsw8AUb5QdvLJgDF6mAkSJCXlRw6D0ug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715812497; c=relaxed/simple;
	bh=+tcabGOsYnlwyoPZImXJVinABZHFQc5gwvuZcGZOxtA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QPdM5LOK7evPjMIgjfdVvjoksR7GDEDh1Rc91nTQHU+Ic3xS8qR/x3ePQIHXTYQrwNoEG0XguSIT6CJuOtvHqMwfvvGrwcxssvbFzZdUYNp8qU4p8qTO9EMKGcwIWtsCGLy38t3LcqmdkfS8vkMHJ1Xi2OxvfA+405KkRnAkq/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cf3VvdeQ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715812496; x=1747348496;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+tcabGOsYnlwyoPZImXJVinABZHFQc5gwvuZcGZOxtA=;
  b=cf3VvdeQv3DEx+EUnWIcxBom0tLqAb1gmyk8l0hJzIzlSzFSKsGQ/Yvu
   8ITcXlDilQKR4vClyMN8cwM9hmdj0YZDRLhZlQlJak42VwfoIbldn73ha
   TJA1VAclH2EDqxgXkzQmHcHXC1v2tSsHQFhHZxtZiHdXNICbGkZAND5h2
   897qopgT0uRytq6xM47x4foCCagzwI7j1IMaGpwDPoApzIGZlEemz0z5U
   EP/aUDcCvpoPHYZHELp/7JZ7J3gTvnmQBoDojOR4ARZcttb/95vdpdMZM
   dzQaiKtqdMGTcnkrfFXjdS4J4AIH26qBOTjUDb5RNiEo8TpljwQtcU3aX
   A==;
X-CSE-ConnectionGUID: jvFbcfCnQ6efdNqyEAK1yw==
X-CSE-MsgGUID: 3CjilDtsQ42rszbtMDhsvg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15717691"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15717691"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:34:55 -0700
X-CSE-ConnectionGUID: 9grCTwmwRZy67bHIzQb7QQ==
X-CSE-MsgGUID: gh03SArcQpylKQDgDOFowA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="62048822"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 15:34:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 15:34:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 15:34:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 15:34:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 15:34:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mt617U1uZKsvGEamdPhxKGQD9ZQAXu+oWh+qPT+DVu3QoMnSpTx1flT3vzKDRwyaAT8sRIKV3kWA02lY2umEiRvBraxuH54c8V/t1XTs1EcCvC5jwhUF44vR/USzV34S8ToLv1VF1Q94vtvyDWe1n+uFJsJ27n+yGOyyBcqWm5tHEq1+n3eZEN3CTkV+0oA2MgrBRdUTS9z+5SItBATrM+2opMAuk5Vf9OzyFKXXz4s0wAQeJUDEoW5jFzE0JEK5o7ZHkpw6HgHSrxMF8YG89OS3i1ujBhKCBDOQUUiVJ5Q5VClQ0AYc83MWSXVsibwFU0losxHWPKWch1HurMi0ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QkYobMzIpsM0bTcFCjz0tdnYvfk8otR30QlcFZ+DKQ=;
 b=gaXcdPU2ZpclhVCHiT0v53NpKJYb+NhbEGsvoRErhNkHtXXsQsqnLovj22X5Umnv+rzMT8GtSVIPNVaUIbQ9AVB3deqrtmbYJns0SthffFI9wTwOlJs3QgQ9nRl5e3GJNtyaDodiBDanI744r63qcDIvZ0Ui+h3ljq+U8PXQ2wiStMRoKDYFTOQHs1VQValXMZElHrFSgID9AReWVA/t2770UuQFCWX9zKilzKjxfzzcBtvNlB2sEZvPVlvxFc9WTSjytrD95Z95SwfIHgmXPUZwsxtjv6IIbbx7iyp96+MZH/KxD3ugvuf+R9KI/jyH7TjAS+swcLv+YjmNrXva+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8046.namprd11.prod.outlook.com (2603:10b6:806:2fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 22:34:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 22:34:52 +0000
Message-ID: <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
Date: Thu, 16 May 2024 10:34:43 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<erdemaktas@google.com>, <sagis@google.com>, <yan.y.zhao@intel.com>,
	<dmatlack@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0332.namprd04.prod.outlook.com
 (2603:10b6:303:8a::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA3PR11MB8046:EE_
X-MS-Office365-Filtering-Correlation-Id: 4985e809-e844-45ee-0f4c-08dc752f3ca7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R2xpU1h1eGRMVlJpZStYZUJSM0hMSjlyblNpM0VJTHhWMEpBZGs0WkdMSzVL?=
 =?utf-8?B?a0NCVWlGbkVYVUhnOHBTcVVhWlgwYURkUHczck04QjZiL1dFQkF5UmdJa3pT?=
 =?utf-8?B?WTJrQXh4akZta3RjZk1zZlJtL1d5SG5hSGxaVEU0QmUwUFFFckk4dUNxN3Rx?=
 =?utf-8?B?eEgzL1BlcmNjY2V1dEI0a2FmYytkQzRoTlpKVEdOL3VvRXhwSWtneWk0SnA4?=
 =?utf-8?B?Z1h5TWt3ZVFhNUVmcVFzY1dXeXVyV3lTTHdCZEpVZ05lM3pCZ2JxQ2ZzV2ox?=
 =?utf-8?B?Q2krQVlnR0VwTUlWQXlkUVVUM3RvN2RWdzM0ZXJtK21SeE10NGdpZW1RNnpF?=
 =?utf-8?B?VTUzYm5BOTE1TjJDcWduZXZxOElUYU5wQU1zTG1HUEJ2aGJkMi9Ubmsrb2Mw?=
 =?utf-8?B?ZEVaMUgrc2xRdkR1MEZlODhtL3dvRHBZV0NSRDZ3V1Z3ZVlBVHpMTnF4ZlVk?=
 =?utf-8?B?MEJCeHRlOHhyNWg4ODBzenphY1dkRzgwY2diU1R3QnUrQ2kwckplejY5NGJz?=
 =?utf-8?B?Q3d3aS9hNkUvQ3d0RlZaY0hTbyt5NldkYnJvUHNxVFNhZ1pMbXkrSWhnN3Ew?=
 =?utf-8?B?dzlvc1YxMTMwNEVVNWNFaVI4ZDJlZGF4Q0NjL0RNOGpIY2p3dCtFQVJqV0Fz?=
 =?utf-8?B?allKc2FDSlFENE9XRSs1dEdTSms2TUd2dTBpLy9HalVpOVhEZEtVNnNia0pP?=
 =?utf-8?B?d0VxeXIvSlZjbkdkTHRnQlpzbkhabXZ3bG1MbkhINlVhQVo1M3NvQTJuVmdO?=
 =?utf-8?B?eEJZcDRsR2M1YnRKTklFZVkvaElnOUdsNkUreXFxbDUvdkVIdHN0NDUyblFn?=
 =?utf-8?B?RjdOSzRKQStUaGNpNjM0U25vNWtlWDNXbzJLY1NCd3UyQStPbENQRTVBS0R4?=
 =?utf-8?B?S3I5Nk1sWE93cFM2aWY0aUlxK001RXY5QnNYdGNHU3poUjEwbmsyTStQZk45?=
 =?utf-8?B?TW9iNW9qUlRWcTVaYXdKeHlvRUljZ1lVL1BoM2cxTmlWZzcvT01vSHgzTGll?=
 =?utf-8?B?RnJ3OTg5c0crZkhPTXdRZWNLN3RkdGFnVlhKai9GOUlEVDM4aVFsVlY2K0Ri?=
 =?utf-8?B?L2t4VEhENlFkYUdYT2lPdmNwTHUwdlQ1ZUp0S0dqSVF4RFQ0a1cxQTNRY3lt?=
 =?utf-8?B?aUUvTVQyWTdnUDBQODZEalpzaWwvMEZTODJuQURHNld5WExNdGFYUklic3pX?=
 =?utf-8?B?c083b3hqK09ERVZSQmFuN29QUy93WkZHT2NNdVBuZlJQQndubk01dnRLajJn?=
 =?utf-8?B?VzZqTDE4ZkFNOFViYmZVZ3Rob2JNZFJwejhFSTQ2QnM0RDdVckthc1Y4QUw5?=
 =?utf-8?B?bE15TjdFellxN3dEUHhGbEEzd3ZIaSsvRUZaY3krb3l2Tjd3V0tzZWFmNEk5?=
 =?utf-8?B?aTcxWFFVQjN0WDdlVXpnRFdOSm1GRmhodmJQNUpNOXd5MXdsZzFjczdBMkYz?=
 =?utf-8?B?UmNwOGdDeFB3SmF4MXpZUUVFWlVmRTNhVDRXeUV4VmpKQ0xNT3BtZG9lbWo1?=
 =?utf-8?B?dTYrVU5sM2gwWS9HN0lPcE1RZDJ6QTNVR1V0ekJacjZJSVhRQ0hSRlpFMmxX?=
 =?utf-8?B?Y0NneEFuWUFxMWhCWGxpRWV0Yzdnb25uc3NKOGM3UTU0K1Q1a2JQUGtpQStW?=
 =?utf-8?B?dmR6UTFDUTlZQlFVa3FWYVJvazU0YUE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUp4L3p5MFhEM3lQYXdUd2ZBL2kxdHIvd0xNL2lFMzk1MldaUExaTnVkbGNF?=
 =?utf-8?B?R0g5Wit5M1F4SUVJT01wVmRDSnAxUGZwZXdFd2VYNEJTRUxYbjJhM3hDZ3Bh?=
 =?utf-8?B?a1d6VFcrTHRFSEtSTTMzUFNCcU5xVGdtekxqWVFtYVpRMmtMTlBKVDJEc3dq?=
 =?utf-8?B?K3JFYmR5NUdDUUtCV0JVZkRTeHJ4R3VMS3dxeklRY3pvd2xYdTRsbUNYTFBo?=
 =?utf-8?B?ckJJM3p1Nm0va2xlVmhrYk9NNDEzR3RZLzJ6eUw5aVZUOE1LRUgzWmVZUGZQ?=
 =?utf-8?B?SWFMTCtCYkMrUjBIMjBlMzZ1cGxoQWh1WmNOcHhDNFN4WmZpdllnYXRDSzhQ?=
 =?utf-8?B?cWFIdk9ocWtoT04yTFh4RXExeDFWZGs0eFJVc25TckIzWmIxRzB1Q0NmK2lo?=
 =?utf-8?B?enhaZEs3dHBXR24ycnJyY0g3OFBGRi9DUFdUZ3VpSURyMWQvWXNLbjBCVlFB?=
 =?utf-8?B?UndJcUFhRjZqTEx1NHVCWVZySGhoNlJIa3Q2c1N2a011VUZKTENraGNNT1JH?=
 =?utf-8?B?QXZ1S3NiU2lKeXBHeGp3WjNhZXZUTG5pTFMzYXRweDlxWURyVFBMK2FXQVNU?=
 =?utf-8?B?NUVnYnhJbFU0OHU2VElsNExsVmk0N204UXV1RkFqQllWSXQ4YStKUzJVa3NV?=
 =?utf-8?B?Rm9lc3JmZDF0ekx6Y243QmlwZEU2dVJwQ1VOeEVqN3BCZU9naWVpcmlNa0F2?=
 =?utf-8?B?bUJMWGdNVEozUEJNbGhGYzc4aXAyUGh6QXJwTVZBSGtPSTJYTis0TWtuelJj?=
 =?utf-8?B?VFh0U3dDcUc1NzdUZ3VqR3JXdURvc0pEU2c1c0RPNEI4MmtBNnJnUlBNc09l?=
 =?utf-8?B?MGJoQzcvaFljaWVBc3kySTQ1TVNMcXYwTjllaU9RYmxNa3llZkFnSG14d3FE?=
 =?utf-8?B?Nnh2MSt6N2JCVExkTVUwSVZSNjBGOGFWK3o5T1lxak8rL3VxM2JQb2dKOHpK?=
 =?utf-8?B?SEZ5TUdibGJKUWJUV2RJN0NOSVg3eWE5Q0JKb0NXc3g4RlJ2Y011WVphSmt6?=
 =?utf-8?B?VUMzVU1TNFMvNVFCT2c1aUJ6bFRRQU5rR2JPcnBaQnFhdmhJdTFQS0dzS29v?=
 =?utf-8?B?czNXZTNLaDdDU0RNZStzbnFYcTFZY2tUdmNMUytESXM1SVZLZUttNmZRT05G?=
 =?utf-8?B?WTNDYU5XcWpUV1BVb3hINC9tOWtrUGNvbndVZER4RGNjOHhVaTBpR2NCQ2t4?=
 =?utf-8?B?VlcvSzhHN2VxWXlOeE1UdGhWckJrcGNZSWRGOHlXM3FmRWUxQ1crRkJvYmh2?=
 =?utf-8?B?cU5TMmsxd0xCODhiK1M0djZLNUtweU5KRExlMFByUVpHKzhPMTZtOWlDNzdC?=
 =?utf-8?B?NlBaNUpQbzh6c0lLSjEwUFErVDI3VjRoOE93VHlKeVVEUDJuQng3cG1hck5R?=
 =?utf-8?B?Yy93azBYZnpibEJCZDJGdHkvQmhlUUQ4ZThrdmpYT0luT1N0Uy9zN0EzMTBa?=
 =?utf-8?B?c0JTbmd5WGlkaGRKVmIyU25iYlhoQTZRZnBkeWR1RDRFWkZNR043R3JrRGM0?=
 =?utf-8?B?ZzRJOTZydjFsUkdPd2FsQjg4ZlRkZnNQTWNtMEUwWjMvWWtDQWVueDdIK2Rj?=
 =?utf-8?B?VCtzeXhXYWpWNG91VGFMSnpTcnQ4RjVUL2R5a0dCek12cFpYZUc0WUYvbjlF?=
 =?utf-8?B?VElSQXZ6L3QzV0JtMEtTYmc5VmZzK2Q3bDd3aGNMQU51R0JxYXNMdklQeFNk?=
 =?utf-8?B?VS90Rk5QalBFQUNuOXlRQ2ZGSWJFcFdTWmVsMitNeU5pRDhITzR1NU5tNzNz?=
 =?utf-8?B?diszMGNNV2NtU0tnL0ZBNlBZRjNZVTNRY1ZnSURLM1d5VlBEWkxzZ1ZrS1Ft?=
 =?utf-8?B?Rit6NlJrMVo2TmVCOHNGN3V4aXc0ajBGcmdWZ25tU2p3cGV2UFF3dHgvQ2Vn?=
 =?utf-8?B?QWZEajVvaTZ1NHZKNFIxTWI0a0hGVGoyaXp3bEQ0SkFLUllsMzVrTXptaSt5?=
 =?utf-8?B?NktSRVcrUU40MW83bXdReGwwdEtJL2dMcVlQU0E3Z1VZYys0ZVdVMWxEejdK?=
 =?utf-8?B?ZjNRTXdGZ0o2NVB6aHhjNStyM2tna3NiUmVuRHhKMGUzSFJqRDV4ajk1dWxW?=
 =?utf-8?B?RWdtamY4UWxlWGFBcUhmS3EvS3Nuc2J4R0RHbkxTbC84cWlWNWhKQXNVaXFi?=
 =?utf-8?Q?XtmC3xZKM4kmdb/FhC2Jd4JN+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4985e809-e844-45ee-0f4c-08dc752f3ca7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 22:34:52.2751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bzLMGgkPDOnvS2Bk8BkAW51uvXw8WUalcVwDr1HWoU7iQ9DtV8xPaFivtd6tUNvZ+kFsjz8HQRbvPEjN6lynfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8046
X-OriginatorOrg: intel.com



On 15/05/2024 12:59 pm, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce a "gfn_shared_mask" field in the kvm_arch structure to record GPA
> shared bit and provide address conversion helpers for TDX shared bit of
> GPA.
> 
> TDX designates a specific GPA bit as the shared bit, which can be either
> bit 51 or bit 47 based on configuration.
> 
> This GPA shared bit indicates whether the corresponding physical page is
> shared (if shared bit set) or private (if shared bit cleared).
> 
> - GPAs with shared bit set will be mapped by VMM into conventional EPT,
>    which is pointed by shared EPTP in TDVMCS, resides in host VMM memory
>    and is managed by VMM.
> - GPAs with shared bit cleared will be mapped by VMM firstly into a
>    mirrored EPT, which resides in host VMM memory. Changes of the mirrored
>    EPT are then propagated into a private EPT, which resides outside of host
>    VMM memory and is managed by TDX module.
> 
> Add the "gfn_shared_mask" field to the kvm_arch structure for each VM with
> a default value of 0. It will be set to the position of the GPA shared bit
> in GFN through TD specific initialization code.
> 
> Provide helpers to utilize the gfn_shared_mask to determine whether a GPA
> is shared or private, retrieve the GPA shared bit value, and insert/strip
> shared bit to/from a GPA.

I am seriously thinking whether we should just abandon this whole 
kvm_gfn_shared_mask() thing.

We already have enough mechanisms around private memory and the mapping 
of it:

1) Xarray to query whether a given GFN is private or shared;
2) fault->is_private to indicate whether a faulting address is private 
or shared;
3) sp->is_private to indicate whether a "page table" is only for private 
mapping;

Consider this as 4) -- I also like to have a kvm->arch.has_mirrored_pt 
(or a better name) as I replied here:

https://lore.kernel.org/kvm/20240515005952.3410568-17-rick.p.edgecombe@intel.com/T/#m49b37658f03e786c6aa43719cbf748215170980d

So I believe we really already have enough mechanisms in the *COMMON* 
code for private page/mapping support.  I intend to believe the whole 
GPA shared bit thing can be hidden in TDX specific operations.  If 
there's really a need to apply/strip GPA shared bit in the common code, 
we can do via kvm_x86_ops callback (I'll review other patches to see).

And btw, I think ...

[...]

> +
> +/*
> + *			default or SEV-SNP	TDX: where S = (47 or 51) - 12
> + * gfn_shared_mask	0			S bit
> + * is_private_gpa()	always false		true if GPA has S bit clear

... this @is_private_gpa(), and ...

> + * gfn_to_shared()	nop			set S bit
> + * gfn_to_private()	nop			clear S bit
> + *
> + * fault.is_private means that host page should be gotten from guest_memfd
> + * is_private_gpa() means that KVM MMU should invoke private MMU hooks.
> + */

... this invoking MMU hooks based on @is_private_gpa() makes no sense, 
because clearly for SEV-SNP @is_priavate_gpa() isn't report the fact 
when the GPA is indeed private, and the MMU hooks should be invoked 
based on whether the faulting GPA is private or not, but not this 
@is_private_gpa().


