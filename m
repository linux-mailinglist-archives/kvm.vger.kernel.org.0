Return-Path: <kvm+bounces-62828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA55C503FE
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 02:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDD443B2B61
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 01:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598E2295DA6;
	Wed, 12 Nov 2025 01:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HS531eJU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64D928A1D5;
	Wed, 12 Nov 2025 01:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762912490; cv=fail; b=KDW12U70NKxZhRgGWSVPQ4SCfI0Cun/qIdrsfjGUOUs5pyPwKLdpeXzrWmMY2+ADN/nB0bw9/kIbxcfJX24sJVkUTFFyJUZDaL4LM3XYPs7tyehsYfkOXglNbo+qhrO9BbFXA1wD93XrHk5MXI63KdyoOy0Ui/gjqwyuj00EipY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762912490; c=relaxed/simple;
	bh=FNLPo0MNyx1rynTBTFX+h8NnS+sVmGmC2YslFx2QAVQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IG++3ciDeFlrwYdKE4U0nIU2mRKmmV2GNV3efuVygxtqJ7kiISGijATM+zF0P7a6TjoLsgVPGHty7NUsTfzZX0y0VN7Th4IxEQwE4tBnIK3dLRrq2qsOreKcnBEJ4o0qJZv9hRjuOBZk4BNMWb5nR+aReekdDUP/VtL3dj5d4nE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HS531eJU; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762912488; x=1794448488;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FNLPo0MNyx1rynTBTFX+h8NnS+sVmGmC2YslFx2QAVQ=;
  b=HS531eJUkOtNHXb4tx2tPKFQGmH1O0TXpBJ3ZHLVV916L9wALqLQcKxh
   Q+HH71Vcjq/Q8upyK6ka5RkRkBujszA1TPs2pfnBiHx4rygqTu1WaSmsi
   uKw5a5n1i72ASyUUPZd1yN7B+U3+MBVsn+4+WvVTz+oY/ty6ks5mewQDW
   ifZpkzEIgufgawPYEY7ehIWHdLHESRz0v1Mu+nanbo0RvL1cguhGoTy3C
   xeZg07+nx0xcO0RHSqVzsoFixrsaNvUikvNvVZiom6h6+wMdw0K7hk0BR
   FoFrYDqf4xzptVFh86QFpsAJWZqUrZzvmszo0sG2MJwEUSUhm0QCTUQrf
   Q==;
X-CSE-ConnectionGUID: fdXdLgadSoS4katNaJnEVQ==
X-CSE-MsgGUID: W89gBbKsR66NkTdwtxgsRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="64176517"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="64176517"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 17:54:47 -0800
X-CSE-ConnectionGUID: BLMBJCSiQ2yOKjoIbEfhHg==
X-CSE-MsgGUID: omDhTjm9R2iPu5j45TTCvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="219734278"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 17:54:47 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 17:54:46 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 17:54:46 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.43)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 17:54:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KAdlg5Vujjn5ymO02OkgaTwvG19Qg5cGa12hf2YlB7kz3HaSE4H/oZpMp2UWTxxtLc3V/yhPEQ1mG9az2r8aWo80evfGpSr44l1wId7GwPGjw6OjJl7x1VAWfDkJJghetyFuBJJt23+QMakK9ux86vs80ZvsuXz2IATi3aAoPBmBzeQpDLRlsMdqFIz6Y8PjzUX602zOBKd/llhTx0V6vsScsw3mqZK0afQJfb6OrjHUMdr/k9CyaLt5EWZ9BlyAI/Wl5IHShqJQ+AR8YKiXa0MLT8PtMooUhfcNCv/TH7Zw3f228UglO2NAk8bMxq8OcbAj6v0VMME8Miuw9MrPMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciRzfTg4MuGC0ueebgAFu8X+Wqh1PJD76cj7b6YPLNc=;
 b=Let9dW76Q7I05HjFEBiftCHBWEl6jyZGiQDKJtgF/fc6UIcm6gJrum872+GGyRmeTWYpbJeNUgCXGRqNXCDQRBFkXmT85N50EK4b0aCG5wrQp9aaqH5zNM4KiUHwOxxvuyweoz8hObW5DqP2Vc+SULAoFQWyyGPuUUaXWkmF5ETKipwmQ5AzSfHEdFa/RCzLe1i3UZIuGACGWB8a75zQDCrEb9qnyAdfTY6C6/aZzf8IXlbYB0gOiBTE/K0u6N7xVymCe5s7lP+qbBX7uigUKZRtRT4LtsiusBQaPk70vpH/05AnxtrJyKgee6NcZ9RNgy40gDMsrB5Wmsx+c9ndZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPF5ACB2DC0D.namprd11.prod.outlook.com (2603:10b6:518:1::d23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 01:54:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 01:54:43 +0000
Date: Wed, 12 Nov 2025 09:54:34 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Chang S. Bae" <chang.seok.bae@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <seanjc@google.com>, <zhao1.liu@intel.com>
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
Message-ID: <aRPo2oxGGEG5LEWv@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com>
 <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
X-ClientProxiedBy: KUZPR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:d10:31::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPF5ACB2DC0D:EE_
X-MS-Office365-Filtering-Correlation-Id: fc54de99-4b1a-4338-fe14-08de218e72cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?BefzutrDJ2Y6pLauz5oZWKD9q0hm4+KiW1W+BSExO5tYHhNsgsw5xYn/U/?=
 =?iso-8859-1?Q?Uob2rf8kVZ6Xae/T+HItm/QARUu/9MAdYBPjkmlMYRsNKScfV9IxDFVj+D?=
 =?iso-8859-1?Q?h5tE8+dBl4FUM3Opjvkm5ZX+2dV72YcnoFxYfcy1N4grsAZ/mI+LOtnWc8?=
 =?iso-8859-1?Q?gS2WuVRVxsqaYIyqjlH1WNlP1XcX0zt2p0Tdo2YHSLXouIymMYbbwuTkcr?=
 =?iso-8859-1?Q?REquSIaczxPqAM4UqvqgvWhr+XrK1yQXH8ARCubN/431evo1fIyKIJPk+s?=
 =?iso-8859-1?Q?OLheERETGm2pehTiE7FY8iSvH6TlxzKUV22GWGptXbMDfbtki6y1qOlYnT?=
 =?iso-8859-1?Q?wWF6HfxbKtd9lclBXgLlbCc1V9fM+GFtNmTQdbl8PhP8131OMEBog9IlTD?=
 =?iso-8859-1?Q?zVY3HSoQ4bcUrxw974OJ6YF7YU8zX9xPq7qTWdhEc5/BnoahxANqcmXfvP?=
 =?iso-8859-1?Q?aMWJCf1C7YsYO+QC/74H0Cso1iXvsSjjyoJYU7Ta7lZPUc6o3APW6ZXG7x?=
 =?iso-8859-1?Q?AR5NrcRJwDLDzOzuPPdke/IG6TB1I/lFOxFriLFE/b5necQY6ce9nzBKx3?=
 =?iso-8859-1?Q?TeR3iFceQohT5xyce1Ull57RGfsha45P9Qgh6E0IME9cvcW0Hl4+KhZczZ?=
 =?iso-8859-1?Q?zqPpcB+TWTrBYozUN47cGgKONUKhi/637QA+Ru3umb6O9VQagrFUaE0bNn?=
 =?iso-8859-1?Q?MmVukIlRYrfZvAEjNGxPGo1J//eQMBOpTnsiSDYVcHQvi+PdmMYLfKrZzQ?=
 =?iso-8859-1?Q?mBdeXgk88VlYocb+QLGxZA6eZZcnHKiwG//+x/3SNVcr7lhivxMWQ0MoBT?=
 =?iso-8859-1?Q?10AL232Xoy4Tj6N9T+J/ctnAmssfHZR0z1KwqjewBPC6M9P3eNfsvKLf1u?=
 =?iso-8859-1?Q?A5KOZdWcFAMmmDpS9nQvN/P0kzqTQnhOCFkiO/CvZYe46ELjGm0cC624Kz?=
 =?iso-8859-1?Q?CbVWZ1XTVR8ChKQn5HY074gwJE9PQOGkPLOp7me7WBss/VsJep42LcWjjr?=
 =?iso-8859-1?Q?XTfNfcht8GEm+YDnVyxG/tO8an2UUj0mYhCsfSSQ7okRu5qKAQgF1wMV6G?=
 =?iso-8859-1?Q?7aMwlx0eJrVLKmhMp0xX45ds5OPXcBuoq8+y24QaGbJi6e2+ZsbX7wDbbO?=
 =?iso-8859-1?Q?qEGvTG8q9skSYrqzWXQR3tMyzl4D7I2oCtPFivdsIl6hr5dGaAmkg7M+O+?=
 =?iso-8859-1?Q?znVnJdGYXyA09ycAc59XC/ux4QurSGAC8pivtXXj45mgL2+uJsQPG8yWuN?=
 =?iso-8859-1?Q?ePTYjGFcyNA1KP+PzC79ocOmEl8GZEClJ4lMkOMJpLEIO5M48t9UMWiubB?=
 =?iso-8859-1?Q?LihKo87RQBpCD0Ah+qCoGoINftnxaHZqZnGs2kCCzUS7NxFRjx+qHLaI34?=
 =?iso-8859-1?Q?Q7M9hoGq7PAobP+BYDRKk3oZMlUdipYI3/jjl+48bxfkVQG2I4hBpvSLFH?=
 =?iso-8859-1?Q?uL+JjTy2ubFLn6NnYzW61mqtAn70N4eI+zEdiWLF59ui5Uqn0KQPmZsi2O?=
 =?iso-8859-1?Q?tKNNBWWCkRucJ0Q4y4cvMU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/LKQFjzfPnyPO03mNU8uUR+cgjTODFzcu+6OVc+3Jl1ZkolGoNh4clMwlt?=
 =?iso-8859-1?Q?ZXKw72CKXpFRrVupL7LIxVblp4qeSGrrwIh4RsHeXFE46gsYIIayAxroKQ?=
 =?iso-8859-1?Q?LbdyCPIP8IcijaXj5dlp94WOkcn20D0ucbXZHH/xGQsKWB0M4drt+LupoG?=
 =?iso-8859-1?Q?Pl5f7lG2796xA2Hu0Q9rJB3pm3nxER3Byqd5gApvU0/qrzrnt9kLY4qQx+?=
 =?iso-8859-1?Q?kCKdvNOsxKi/JUXFNFW69GxTeLmXkK924FCZTe7gtqoyWtEv3BpTLUf/lf?=
 =?iso-8859-1?Q?BtgEYCXRSqgAGcX/TEZqqbuQqzMN0LHTkacZ69emTgGWXSGuhfSAvy1+++?=
 =?iso-8859-1?Q?viZ9gPFuvpqLjhvmrs/MM7cTstLzv300D5JP3rBmpp4JEnPYyl6F3If1oD?=
 =?iso-8859-1?Q?mG/z39mK5X6e4OTYv1BN4uhFoDnA7KKlaVSzYnhHNv21kTh7EV5qHcOAuc?=
 =?iso-8859-1?Q?+jA3AqK4u9hNHzQCcF7D7UwmLz5i+HM8NeF4HFJWmlfXfWkX+I9OicQc3J?=
 =?iso-8859-1?Q?mLj7SjHeF78w02GFEhIOMY00zK3C7pCwjR16wOrHW3rhk/K6xwEiY0ky8R?=
 =?iso-8859-1?Q?fMA5NGEZT6vOBavJ++s/KUu8XMVjaj4wMHL8k97AJWPJZRBHAmV4osxN0J?=
 =?iso-8859-1?Q?Cm3EJdjcrbXxzPFgEXus9cRIuDkQYsmR2EAKGUvPB1mNfByAZ1TLpBAt4a?=
 =?iso-8859-1?Q?87grPPhrhxvTBf1jgXJmRRST7CJFW0PjF+eOITZCpKWiz0Bvy4LaAjmOdn?=
 =?iso-8859-1?Q?foYQ+SZPZd/kGpAi4Ur080Sb0pIMkiz6H0XQ7vMsJ7kR1YU9nsgIsX5ZuM?=
 =?iso-8859-1?Q?s+FcHYnwur5easmTRfUW4X53DWIg1ECOSp6Qvdx4Rqkbpy371OhYA0Gwpw?=
 =?iso-8859-1?Q?aiif/Lu1j21gWgOUw/WvcLLszzpTf2dzKNmC1o9EXc90qPySzWe7uU4wMF?=
 =?iso-8859-1?Q?6AfBYq8ay9O72O8cArOq6FdKIwwKk6foJYkZWRUe8uoUaHSjWAOa6lI0yr?=
 =?iso-8859-1?Q?LLGf9mQ8lIMHy/YWX9cN+yaGYLnMdQfkNqHR+Tk8/mfGfelAHgNW/UCEfn?=
 =?iso-8859-1?Q?Zo/KhqK/SjRKEkekXen6x9upNc7WVelRwLy5rVqz8PgRj5CM3EmhnisldF?=
 =?iso-8859-1?Q?dgEru7t+jcu7j3KfDWugucwp5HExgbPUCeqPGE4G6M7UAbs+gBeIawZO1q?=
 =?iso-8859-1?Q?+tjS2oR5eyRIDXzwzTOhIgHI8rBBWUiShqkCrCgZOK37IORILjgLE0urlp?=
 =?iso-8859-1?Q?vPy72gdwAb9+h+cBsT82mJhhUcNrgIXmvFyCXWc0XFKrkF6S3j4H+I1zE3?=
 =?iso-8859-1?Q?mdjk6K5XgDM0/BIPPIZVwBeYfGR1bT5x6/Gn90k+swlOrOht7YI1HKjpcM?=
 =?iso-8859-1?Q?3Sm1bhXXr27GSyV6Zdv66k176k0y9rcEoobtfo+G877k2fS7eBNBKvNBM8?=
 =?iso-8859-1?Q?1hjPBUBVnwsVc1NKqjuS689kOFt5bM6S5T++57+8BIGoJZ2UJKnUK72DLB?=
 =?iso-8859-1?Q?LwuwWMJtZVfarliEkKE/gmacpNjXZcylLTgCBz2wJvjbbTl9zGqtBczKAj?=
 =?iso-8859-1?Q?N4epGlQGYAEqNARS4gVecI1P4ObjN7CGeF1OKk4Hyu8lqIKYqXurhHMlhJ?=
 =?iso-8859-1?Q?M4G0SABF6Bc3fxbqnOWddtF1Mleg6NTrp6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc54de99-4b1a-4338-fe14-08de218e72cf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 01:54:43.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZ5Hb8BojdZTs1haFnZsSQCTEa4f6h6DhWHMN7yeSYHiYxKYKw1palYuXVfGHzhR8y5gxSbrbB0wxkqYOn/1tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5ACB2DC0D
X-OriginatorOrg: intel.com

>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4798,6 +4798,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>   		vmcs12->vm_exit_intr_info = exit_intr_info;
>>   		vmcs12->vm_exit_instruction_len = exit_insn_len;
>>   		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
>> +		if (vmx_egpr_enabled(vcpu))
>> +			vmcs12->extended_instruction_info = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
>
>From patch 17:
>
>+static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu)
>+{
>+	return vcpu->arch.xcr0 & XFEATURE_MASK_APX && is_64_bit_mode(vcpu);
>+}
>
>but here you must not check XCR0, the extended instruction information field
>is always available.  The spec says "A non-Intel® APX enabled VMM is free to
>continue using the legacy definition of the field, since lack of Intel® APX
>enabling will guarantee that regIDs are only 4-bits, maximum" but you can
>also use the extended instruction information field if you want.  So, I'd
>make this also static_cpu_has(X86_FEATURE_APX).

Shouldn't we check guest's capabilities rather than host's,

i.e., guest_cpu_cap_has(X86_FEATURE_APX)?

