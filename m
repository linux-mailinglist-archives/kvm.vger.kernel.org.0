Return-Path: <kvm+bounces-25977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F231196E888
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED041C22DDF
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE3C4779F;
	Fri,  6 Sep 2024 04:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZQVyBlp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60FDDCD;
	Fri,  6 Sep 2024 04:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725595661; cv=fail; b=j0y6e8fT1ZawZ6sDt8q7kJuiBHDDb0MIcXUVDMYY3IYWkZTNGpIS68pIhyiR3SveSjRE3Oq+aXaVEP4rQbM3NTejN9Y2WOf8okbf2t2ZAnjNZRNTHPU4B521sUKykqQBWFsoSMiHTskn5yCagkjudJRZy+owNv/j80v10b7Zb8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725595661; c=relaxed/simple;
	bh=RgeetqzjOhIyEe5JtDVaRtYcf62lzqkBU40Zmmq/UIM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h/exBoerK2V5/wHFZm0iV4HaD2XCO7RKwBtP5WZqip/vFrlckRPm2IF+QpK3s5A6AvXBMbCwWRBYViNCEEf8JLNZumCLEjQQXCwUznnRahOVw8wj0sErj0GFGZRIb80lqTPXMW8F2775R/4/9uRRDZCcZOozwxtGk8+rrIUEQcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZQVyBlp; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725595659; x=1757131659;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RgeetqzjOhIyEe5JtDVaRtYcf62lzqkBU40Zmmq/UIM=;
  b=AZQVyBlpsI07GJHctqFPHiMgnIyVhaMqw1t9vd57PQOVfaOJLmULa0yF
   glzwFj4Bv1asbhZrDY5+VEpHcvyqNhfLSheBagZ6OuNH8l2Ep7lOSAjbt
   0HX2fsc4hE8Eni+aR/8+xhCBazw4xGLTKB/pmD3fYhCDcwT/Cg3/fgMW7
   b+HZsGa0wHtWn1i4ZBjbAvd6k6rHuTh0razPNlG3mtDrdMp1UFOtUQ7ex
   zPF/LfOnDNl1GjQUDFg0tVb21Htn8UIuD5WYxkjiYs7hd49ysuvrRvxrR
   e2ZeKSClsU08UN5GtpfsFaXw7EqMenxK25BwFt2dRmMdR9nZreRkTzumQ
   g==;
X-CSE-ConnectionGUID: NsnLTHwGTamQv3Li30mxVg==
X-CSE-MsgGUID: r5B9OjOPQa2WUlYFr+IUvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="35730665"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="35730665"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 21:07:39 -0700
X-CSE-ConnectionGUID: yRmw4yOISGyecjO8pIMR3A==
X-CSE-MsgGUID: cZVIx86EQi6dQVC9KjQWSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="89094493"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 21:07:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 21:07:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 21:07:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 21:07:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GYx0itpNJILd6YWkKFKm4t4j66CgVmh5m2xT2GpUSFU/s6yYqL5Lj59NQ511j6JXBBD4zKBmxFHJI0WwSXL29G87nineBuGnzpa4QuvOGOGlZu0gVGwxEUiPEey07GXyiUWPq60+irEv0l25NRpEsCdkZIG05fw6/54FqqocwEov1DX757kgC2p04X+zrw7Al4iy3QL//9ziNVQhjuzNTZ+vLn5xlpDCgKjEa8WD2mUm1MR8b0w+zHRmece9Vo/S7RqDc3JckViuywoXZ8hbjidGcHQZ+Xa6yfcTMOcjfPDaKBrOpD7zjihoiw8LVXyi6K74oPYF7L/+dOSKE0ISfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iid9QcVtMVQXuH1grrApCyjNS8OmeUQOOcv84MhcTkY=;
 b=HxSR7Rc5lhxQvSE3a2mFARrU9PHssUEYUeuQQNKsNF+aONkFQi1P6apJuoDzO96FFo08uZvxMcymTD/vwtFr0ta6S3VZEa39dGpVILLrC4ZW7Y4f0RZg3rrLZFGVwtAe2NOlAXN3QL1DUf4cgriGe9WaPDIH1EY7KkhT0FFmyyALQylse719WlbH8faSLGoT4n8QJBPlmp1iO8koE49Y2Vyk8m20ROTJBqQV3qid7K+UN8n3PUmVY7Qj24/ikcd9wPNRsnI4A2wc6r2lZTIL18ZCHHbriaAAkyYC+Xuhd9bZrS+mmzXuoBtKXRkvPQh9Djnjm3tkFsIWD9riEJXnvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.25; Fri, 6 Sep 2024 04:07:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 04:07:35 +0000
Date: Fri, 6 Sep 2024 12:05:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <kai.huang@intel.com>,
	<isaku.yamahata@gmail.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <Ztp/lQ/SaCe+/4qb@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
 <ZtWUATuc5wim02rN@tlindgre-MOBL1>
 <ZtlWzUO+VGzt7Z89@yzhao56-desk.sh.intel.com>
 <Ztl5muQNXr7eGLWU@tlindgre-MOBL1>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ztl5muQNXr7eGLWU@tlindgre-MOBL1>
X-ClientProxiedBy: SG2P153CA0039.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CYYPR11MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: 233ff9e9-184a-4c85-d525-08dcce297070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?PMVi+5UwIEmz0MZP1zaOHeeuF9g41UTlPbtfMQih5DrxfDm798l5tDaDIF?=
 =?iso-8859-1?Q?C3NCdBcXA3x8GLmWOJUr4vHbb3gGlr79PmAHzCYdGf59Jcn0eHPvhdVAhW?=
 =?iso-8859-1?Q?qJjDU14BPAMSj0qNdOpc7nIVB/SaPXEs/UCTk8YwriERh7wYznQ09s9J0/?=
 =?iso-8859-1?Q?mfJUiSbAJcGfjowEaN6zcEdN944XuKxyUUT8RpkIc8SafXKGVql9MwRfLR?=
 =?iso-8859-1?Q?0yDrBfaDRJBxlhJmyEBxJ5TFsauQOa6TU+LBG9O3jyXxq8HQtIUo5HwQiL?=
 =?iso-8859-1?Q?tmYMtUk8oQ9B5Cc4IyOQlg226UtR+ZJAl/fFuA8c0dnKqDFEd69rhqvwsE?=
 =?iso-8859-1?Q?9rKUN8b3iGkkfhmp4trxd9dYbsS4eS6lX82bQKkITkoA6XTt3HDAXXNJ6d?=
 =?iso-8859-1?Q?HWfojFWhQm9PAxPCEjqJ4FteiV8XJ52eebijzJX4lwJOCB5qHHQLc9CoxG?=
 =?iso-8859-1?Q?ESsROaKDShg9gmOHGEEyDdsx9XeSxI+hOYWpmwCbVOyL/Tg8dCQNXykZtv?=
 =?iso-8859-1?Q?IX0YfxQOzTPXOtnGYodbNWw8D4PpBTO4OJZS03n0HniV76FUiBL71eiS89?=
 =?iso-8859-1?Q?aeCYLavuG02Aw7NVgoaUezFPteTuGCfp9u7ss/3a491L0tZL60FNqREZMy?=
 =?iso-8859-1?Q?5ondx6KxJeo2eBP9kbiG9VAzulJIG/iu2gs+5/c7k0lZzDzM42lR1YLevX?=
 =?iso-8859-1?Q?6mX60rHnm9KQhbhjE47kgmcfMpK3Qv+G5yPnwtj/2lDqVMyKxFkqu6BUhs?=
 =?iso-8859-1?Q?wj00I3safkmIUgcSxUjUxGj6Irf8Mq4qhhjPscDTWQh9/EyNVpLL/A2MHX?=
 =?iso-8859-1?Q?pIeZb0V79XU//4v7aNaMxiRbjZ1l0Yw1Tb0cAij00tQPPLWzjbZa9gUstP?=
 =?iso-8859-1?Q?dE8dnvsmBhsjNsIcoBHj1egbF/fSjvWEM7dxLZE46+LstKwnbAX9EXIfqn?=
 =?iso-8859-1?Q?Apry0CmjqADz94B3hwh4TxzA90AqV1a/8Ph6RBxavBSqg0tKv1wHtQBHFY?=
 =?iso-8859-1?Q?xKAjiC/N0ANbTzyXCBTgJGx4mKi51ujIUe745EGHvXwCqDnYqFfh/6mbEE?=
 =?iso-8859-1?Q?Zh+J/TdNmzOPY9tNpD4IJw89DYp5/YdFvNdaewusadCaFrVtAB8Yg9t9O6?=
 =?iso-8859-1?Q?fVzRYgsgh6sOZE5ntG7m1CkhbflX8LM7PcSD2DXrJr7Uh4Q/4Y+eF1vPwZ?=
 =?iso-8859-1?Q?bz+0mJho0yHPwDPIFpb1EKC7/cfo5VyYdL7ndIxZlypMHW+M64+QwHYMV5?=
 =?iso-8859-1?Q?wG3pnBeYYQFtXtBwugKvZ5d3kJv1XzujvXTLiRw+i6dVTrqgFKHdX/OCpg?=
 =?iso-8859-1?Q?yTubURYeYVqSjLEhyW4z3dez7iWz8PNiqlpvujH+eGyAj9JEU2jIrd6U8p?=
 =?iso-8859-1?Q?ylxVaLP23kahpGjzBugGBHqbQB9VfhUw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?oqnMUXKov0JZKpYua8BLD+XwonxeAxcP2hO2ErD8DtXFnvaJScLPGqnaWm?=
 =?iso-8859-1?Q?UnIA0HTuud8Qzu3kjjYmSdU/Y0jW+/xIc/DMMuxXTIFuBH0SxqC1RqL/si?=
 =?iso-8859-1?Q?qCRljDft0iHWs9uEh7odFS/Y4hMWhwKIMQYxLeXmaUOnILZHmnbD2/SJO3?=
 =?iso-8859-1?Q?CodCg5tL+Ssev6wteBq+O6i2cJajR7cRS8yGMPppUxOsaQ7RpH5esJh6jc?=
 =?iso-8859-1?Q?QTylcU37j6a1E/VmyMJitHpCpgH0ijeT0kyoio4uXszoTfYtqS5q5jTyGU?=
 =?iso-8859-1?Q?G9emUGHmvrO6uJAhp/TvT/j62NG8amir3u9TYuunIAs0H55eWR0ZG4F/fx?=
 =?iso-8859-1?Q?Ls5nsug0qjJQtfCFd87N9nm6UXqWA+Dmy32aq1//z45DSGFwJrsyT6IbDA?=
 =?iso-8859-1?Q?PegdrXZ9weeBMFW8fn5nNxGicgpXDjQn4+We8i66OYjYbC6/gK6aq46jdU?=
 =?iso-8859-1?Q?b2ZnH99M8Refk52TdPTHb+KfVhpGepTFGENyemUFwRT9y32O1xKnslRZl4?=
 =?iso-8859-1?Q?I4Bb4GUL+dDI6gilP8mqvOyZAPToMLUPg4QJCYjpg3ZTmBAd42F9hj5a+Y?=
 =?iso-8859-1?Q?Rtqd5xByruc8e/W/e5eJBL9G+jTwWf3zpUouFzP50H7dgu4w82dbF2Bppz?=
 =?iso-8859-1?Q?VbAy3TZ5IL7THj750HTzRll8aCQ+uxht3YuoDuw+fDLI9efizHJuRSqzyj?=
 =?iso-8859-1?Q?ro6lrQtSLHbXzsVFBOeIFnEFzfSZ1nX4WUJ9slNbyX4Bw8noj8WWSIjjLc?=
 =?iso-8859-1?Q?CCHm3vTXZO0U3f3nvFdnu2ABNCAy4ZNRsLFYBqImJ9oiOydjj4ldaX7p5w?=
 =?iso-8859-1?Q?3150k36scIGBiQRrBctQ9p0Z+Xt73QmKYxwpuwqdGWVMwNCNqObXdrFClm?=
 =?iso-8859-1?Q?tCedLRWXBGB+Xy05vLDbFB2/JdlV9AhGvD4Hii5z5opwlWfgVS0OODKske?=
 =?iso-8859-1?Q?Fq1Mr4hKRz0rMBb+VMFb8CJ3PCsFbtxJUhc75Yv98tacLE1KFa7VykbWy0?=
 =?iso-8859-1?Q?+DuZOMpObyIERPqqHp2qeKfUNfVXj/JyThMFzFYEU5qm36BruJrEnjjsvZ?=
 =?iso-8859-1?Q?AEaqA3FICBdtsAZezIcIzTaHs73l0yoqU5zUnJqI1J/8tVYr41megefl96?=
 =?iso-8859-1?Q?Fc7BDWAztFOalHI4BLvuh/LfjiX2yKXusU/O0q1LkQDULXQJDgE1zHVFiW?=
 =?iso-8859-1?Q?ZGkmN2ZvzWylvPYtlSlI4OpAR87H+5aQ6802caReSMy9ocr66Isn2kb59p?=
 =?iso-8859-1?Q?H+XQBWmj8hwzhT0GL8eCOECQXufEk7+FbYrPODj1t2LOxLNPcMSUw0jEdz?=
 =?iso-8859-1?Q?R8jj5iWC3rK2D5HVgV8JBpmQ2uArfldas+31P1ew7dFuU/TvFmlPtkITGv?=
 =?iso-8859-1?Q?g2UgMwDuyUbEw7vCHQMVcMryDwRRNO75Kek/MEptIrtsvtOT4WCUGj6tfH?=
 =?iso-8859-1?Q?dijhplExbOWhzlfdFXzVDn8xVzh7i8vZYRPl5cMKETo9jilxbJhQFiXZc9?=
 =?iso-8859-1?Q?k+T26IqB2R2EFlbDcN1CPrEOWb1bDgQ6MUd0NFC8UnYssF9hNQPyVunOwP?=
 =?iso-8859-1?Q?ySHAey4ehTivrrt8KXNWVixLZ6e1krrtzZMTM9P7r844RqiOv+0l++a+rw?=
 =?iso-8859-1?Q?dFSbQJT/AJjjJGzIo0mz/gNQGbyXNxKAgb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 233ff9e9-184a-4c85-d525-08dcce297070
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 04:07:35.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sN9Acm1fLr3ft/BxgDCTIzn0mLDay+H5zw44bQM+cdBd8bdqif588+KKz1v6PVcmK/nreAEkIcNQRiZIQTxIUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-OriginatorOrg: intel.com

On Thu, Sep 05, 2024 at 12:27:54PM +0300, Tony Lindgren wrote:
> On Thu, Sep 05, 2024 at 02:59:25PM +0800, Yan Zhao wrote:
> > On Mon, Sep 02, 2024 at 01:31:29PM +0300, Tony Lindgren wrote:
> > > On Thu, Aug 29, 2024 at 02:27:56PM +0800, Yan Zhao wrote:
> > > > On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > 
> > > > ...
> > > > > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > > > > +{
> > > ...
> > > 
> > > > > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > > > > +	kvm_tdx->attributes = td_params->attributes;
> > > > > +	kvm_tdx->xfam = td_params->xfam;
> > > > > +
> > > > > +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> > > > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> > > > > +	else
> > > > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> > > > > +
> > > > Could we introduce a initialized field in struct kvm_tdx and set it true
> > > > here? e.g
> > > > +       kvm_tdx->initialized = true;
> > > > 
> > > > Then reject vCPU creation in tdx_vcpu_create() before KVM_TDX_INIT_VM is
> > > > executed successfully? e.g.
> > > > 
> > > > @@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > > >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > > >         struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > 
> > > > +       if (!kvm_tdx->initialized)
> > > > +               return -EIO;
> > > > +
> > > >         /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > > >         if (!vcpu->arch.apic)
> > > >                 return -EINVAL;
> > > > 
> > > > Allowing vCPU creation only after TD is initialized can prevent unexpected
> > > > userspace access to uninitialized TD primitives.
> > > 
> > > Makes sense to check for initialized TD before allowing other calls. Maybe
> > > the check is needed in other places too in additoin to the tdx_vcpu_create().
> > Do you mean in places checking is_hkid_assigned()?
> 
> Sounds like the state needs to be checked in multiple places to handle
> out-of-order ioctls to that's not enough.
> 
> > > How about just a function to check for one or more of the already existing
> > > initialized struct kvm_tdx values?
> > Instead of checking multiple individual fields in kvm_tdx or vcpu_tdx, could we
> > introduce a single state field in the two strutures and utilize a state machine
> > for check (as Chao Gao pointed out at [1]) ?
> 
> OK
> 
> > e.g.
> > Now TD can have 5 states: (1)created, (2)initialized, (3)finalized,
> >                           (4)destroyed, (5)freed.
> > Each vCPU has 3 states: (1) created, (2) initialized, (3)freed
> > 
> > All the states are updated by a user operation (e.g. KVM_TDX_INIT_VM,
> > KVM_TDX_FINALIZE_VM, KVM_TDX_INIT_VCPU) or a x86 op (e.g. vm_init, vm_destroy,
> > vm_free, vcpu_create, vcpu_free).
> > 
> > 
> >      TD                                   vCPU
> > (1) created(set in op vm_init)
> > (2) initialized
> > (indicate tdr_pa != 0 && HKID assigned)
> > 
> >                                           (1) created (set in op vcpu_create)
> > 
> >                                           (2) initialized
> > 
> >                                     (can call INIT_MEM_REGION, GET_CPUID here)
> > 
> > 
> > (3) finalized
> > 
> >                                  (tdx_vcpu_run(), tdx_handle_exit() can be here)
> > 
> > 
> > (4) destroyed (indicate HKID released)
> > 
> >                                          (3) freed
> > 
> > (5) freed
> 
> So an enum for the TD state, and also for the vCPU state?

A state for TD, and a state for each vCPU.
Each vCPU needs to check TD state and vCPU state of itself for vCPU state
transition.

Does it make sense?

>  
> > [1] https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/#t

