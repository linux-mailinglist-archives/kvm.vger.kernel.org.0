Return-Path: <kvm+bounces-26919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 850AB978FCF
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 12:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA685B2056C
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 10:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A21B1CE714;
	Sat, 14 Sep 2024 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGr+1vKS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F6D2BB09;
	Sat, 14 Sep 2024 10:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726308152; cv=fail; b=i3kBYWD2nZAdneEICfX3dqLYB3coUj5eeb3JdXod9PH84WMUmYC2uXKPyMCt9DLbbCalg4OKQWeHijsOh9M+SKVvdKDzAVCj/gT1rRn/BQLDkgWmQHReG2ygAYktU0NXe/EJd5q+iZdoj4w6lkbN5SpaCT1Rke9vvzAd46PWUjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726308152; c=relaxed/simple;
	bh=oVcD3J5XocRZaw777TRKLFjtQeoX7m1yWaZr53cXY0E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tz70leWRw9O4gI4h8T6nwk1JHBXKMz4nk/UTaLBSqlMLwqY+ndrcWGQm2+mW28tuviehKGgZbwgN+RarvSZfMXdDLa9PDleHAXAZ693SXJF/vewHGSP8P0z1tDIvC3RhNzJhQjcChYZqgU4tTN6WfDuUbquFktk48I/Dq9uPPn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGr+1vKS; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726308150; x=1757844150;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=oVcD3J5XocRZaw777TRKLFjtQeoX7m1yWaZr53cXY0E=;
  b=SGr+1vKSG0Z5qh4cC7HZwqfGaKxjVw0DDOyHRxYfwFDA0YylODIQGAwt
   qAjmz2fTGmYiyCTV+J685iH0AveFzaAIF7rP7ynolQ3SWJAMyXpmY5ysz
   0Ei/865gSA0tordVKFuvDcCx8wyFUNZMbPu40jXAZMvEBTKPjdZAAldXw
   xlXy+jx+WH4c/CLiCbdof1/hcAj9YZzZT7UEaH92W2uNGSvDtAGyXdqeb
   dpdOznjfFfjYXRkFRwlXrA9Y+FAqG3UbRJ6POiPB8yjOixRSd7f6lIPvi
   jQ0Vyhs/Z2fwAvnFhOEfaEIBLBfqyxfy6Ivdy+pZmLiRXMHgbYbpMpHh9
   A==;
X-CSE-ConnectionGUID: o0z7e4GWQC6RzXGMQdUCXA==
X-CSE-MsgGUID: uNxc5ASnT1mPCOgdHCWH2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="36589399"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="36589399"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 03:02:29 -0700
X-CSE-ConnectionGUID: k2f0wJw2Tgaz1ywlLd6eUg==
X-CSE-MsgGUID: gIcEV1rkSiqRQWpx8AMJxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="72482097"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2024 03:02:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 14 Sep 2024 03:02:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 14 Sep 2024 03:02:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 14 Sep 2024 03:02:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 14 Sep 2024 03:02:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgFVh88OluuPlKZKmMBzSX0dZPPri9wyekqk32Agw5ISpeQ2PUc1s7PWb8v6K3Q0Nah+UUgAahoJOuZlEhydYlSWIMzQ6lk6evq7tVQDDPxCRf+AXT2e5cjrBdk7HfnQpSVcSIYT8JllRgz1o47hZHEBj/qdhH27fTDxI9OCRcWt7ZM7f6KyZ97TWcuhnUFE/RVgZTMIJ+VEsEIqRcDu0Dy5lXjA7BQHmJi4R9cVrr2/rfkH8J0JkIL4PEotFGTWFwF9jjkBWF45ys0IX4NYr8acmNiYUkn+9PpdTlH0vVn+j5q3ckr4gGxOY1TLb8nk0KeI0RYqovnNtrWat9wDSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iJ0dfTtSKE/1XyXba04PoD1XapDCejeDAg+jIcivls=;
 b=rCxxJ4KkLuRUOX4CiE64QMuQ6eRrR53s18vDm0e/+DWajlJ4YmLRIRcm4prC0qml1lxLve8CauLqyg7oDPrXR41RYAEOC6NgKfz9251McgDemziA0kENXA1HgOgZjlkHZyeI7Q4ER7qF+YGA6h9Kch0sR3YY+A+J4Xd98hntmyS4at9y0HL5speewStEZsZbz6v83/JvdA7F5nTlW4JXrwCDPyx6rKGzLDDtXaif/DlhQOkMnzKHws5LePmiNI7tVeyjZsDm/C+fF8QOGjmP2E5vHWpyvIOTxHFnPU7VRzPCmLycpIjIXVmUofdgDa1RXPMY46oWnT45Obje5K62sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN6PR11MB8244.namprd11.prod.outlook.com (2603:10b6:208:470::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Sat, 14 Sep
 2024 10:02:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7962.021; Sat, 14 Sep 2024
 10:02:24 +0000
Date: Sat, 14 Sep 2024 18:00:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Yao, Yuan" <yuan.yao@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZuVeueksXSIdsnia@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <33b60d50b7aa8ab7d984f9eb216b053e92e3184f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33b60d50b7aa8ab7d984f9eb216b053e92e3184f.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN6PR11MB8244:EE_
X-MS-Office365-Filtering-Correlation-Id: 93ad2dbb-7657-4162-12a6-08dcd4a454ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?GM/4BxyTCUV4qew8FoVmKntadkNZES5zvqPxLail7/xSsvGr/iucQM4VKl?=
 =?iso-8859-1?Q?4lWctqZ4vPcD5of6KnMiSewyjh4Knn/eK2nJHWf3Kd+ba25r3ZBQYl1SQQ?=
 =?iso-8859-1?Q?HiTMbB002u15c82Ymzn0qIHZzq9WS/rSHTlBmQLa4ARjN2IMFCByWADSoB?=
 =?iso-8859-1?Q?UtSLP3ngdTVdowFdb0CET5pQDz5oRkcZbmbeTBHZhYO1H3YXQmbnL7Y55Z?=
 =?iso-8859-1?Q?xLwc3wpYUMx17aFV4vys0jydaL5p5dj2/UBeNn9LDmP3P4XlfBHeM7P10J?=
 =?iso-8859-1?Q?C7xTECZigfyeyJgREfCiRbaPnMzCWLHWef3AnrQbD4LUzLT76S919AopMs?=
 =?iso-8859-1?Q?zMujDD8syH8Ji7txE0OkHKalfRzWeracDf1Sh6dIRMd1xFXmuPEvSd/rZK?=
 =?iso-8859-1?Q?sIhKky3WtIF96mSfMqD8nPV6yslWf7JrjMUOwsywGpSxn8WVYcMtWcz7gr?=
 =?iso-8859-1?Q?klbNNhKhN38XZwd5eNqqY0tQ97Rw7tVvNl+bqZBZ2nd672RlCSLPlf/X18?=
 =?iso-8859-1?Q?zku9Yi9uENU1s3P1FBXo1+i3FQYGxGpLm59dcesed2cBsac1efLrcs4kAU?=
 =?iso-8859-1?Q?x8h10lrqCzcMRZixYWcJUN+bJejvIBME5trXN8PsN8ZLGl6/vu3cC5SkjM?=
 =?iso-8859-1?Q?5CqJrmZv84ShGD63VAGuC37mbbwP8lbDOTBezDpeA/+cNnfwXBojLe6zCJ?=
 =?iso-8859-1?Q?tc3vHnqFEOklpzp3jQxYMsthLvBy3jisANJt0LRIPGrtXK/sMeBEgIbr9A?=
 =?iso-8859-1?Q?YmbN+DWznyhp8JA8QcA681wCgdXeKi8EgQoTY9rse61E4oxOasrxFRqJaP?=
 =?iso-8859-1?Q?q2N5u4abu+YkO53J2xtSLi4eAsyoYzlyjhHxiXjv3vqFC8MTE3YSBYxMRB?=
 =?iso-8859-1?Q?gPIwfAFw5NkinW6UjBwRqTT8h+hnWXwQ6dnsFR8Ki3fZ/Zbl9w//b8KGkY?=
 =?iso-8859-1?Q?AOfKREtYB6SJJrZTx3+8GooNHtyrW/ZJctLXAXJYShYa8dOTr4W8rTDUm8?=
 =?iso-8859-1?Q?T1H69MU3soyQar2VT7bB8SLqnLopXlWKHSIOZ1PgfZ7L0vWc4OmvS5h7GZ?=
 =?iso-8859-1?Q?DlzSUGzyx/tRNZUsuYnw3tCUPgT0johsrAGeSpRPTSN/F0BipznU3wn+eg?=
 =?iso-8859-1?Q?hosiSCbgYRrs7dPIgmaLiD0KobgWFd25z9wc5l+XEzuO6pEe88Fbvtka/d?=
 =?iso-8859-1?Q?YRnJMnlRN6rtyBl92I4ey0YUbJkHOVHFEkU7JgBkOcb6FEnVeZ5nxeDRwK?=
 =?iso-8859-1?Q?n7KERb/3GJOXU3lL98Ct0uyOjy6hUmsI//EnbRf+lHGVq0P8UOPaH+55u6?=
 =?iso-8859-1?Q?8vpDcZ7dwaMfygPsdLvFxaKilU2dNQNATf1/Ox5iDG+3Z6eyvTfauUW3XB?=
 =?iso-8859-1?Q?mGzxbjISxqEQPsJqnr34aQQB1oYJ77Mg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/LkREfPAlRDNBh7jakM8BWuPRiMSrtH2R53OyLzBQQfvrtqUNpWcfVh0Fz?=
 =?iso-8859-1?Q?+lfINQJ3G/psONypEtkJkvyoCc/IhDxgKJ6dlVpi5VKASLRqmUF3Yv+q4T?=
 =?iso-8859-1?Q?Z+4yKyVmGHDHQmrLD7X1cKLqq/YCEllcBoa0JwZYK7zXCaZ/h6mRblwVi/?=
 =?iso-8859-1?Q?DCKLujF0wxzumIAeSsgRitXl5A6LGa94AAY6hu9t4KWKMis9mtfP3+Lerm?=
 =?iso-8859-1?Q?8sZO9qtTeCZmh2aX1W+cehnv07QWgip25NbR6delMRoyNVGbE9J/LQYEzu?=
 =?iso-8859-1?Q?udRdVLoy775lhwwrDfG7PqSKQJu44AhUNfx+SmiGLo4Y1A8svDLYg/toUI?=
 =?iso-8859-1?Q?mpXc96mUDLvEfruqk0taFp0idFykAOrM5cpnM/jKHCGjpqDm5gsEmDiJH6?=
 =?iso-8859-1?Q?gu6IBBYro/9izBYhc1Tr/o7pnnLh6z4YKEo2rQPVQvdWSwwaoGzQC9TIAh?=
 =?iso-8859-1?Q?5VEycFG/kcc8D9+BAs6H9PREFfCLcBbuC3nm6pRDY4FRPUIM3H7JI6tect?=
 =?iso-8859-1?Q?Lsjto4W+DDW96bJg4FUNpRdtcnOWuyRYDnTxU8Y/EN4D0l8GSo+BopkyIb?=
 =?iso-8859-1?Q?QioFWghGe4YeKFw8MSZJjg/fFiFHensEzsRItsRbCmaXRZcQdO085zMrFh?=
 =?iso-8859-1?Q?VVXRGDBFIWIV4iYGLJN0GwLr2BOSgBxIVqrDL1hwrajOEhvw5HKgGH3tNF?=
 =?iso-8859-1?Q?mATvrGV2XZMmXKcbt7mg0XBqMJJUoGhDy+V3/K+pvDbynkuXgZdFwEOAGv?=
 =?iso-8859-1?Q?y9hs3ppkyta2GsF/2RQaucIuy1UePTGPKb8VYWhKnRfkMvxJSEA7jySXrd?=
 =?iso-8859-1?Q?XzuNW4yHVkFbltM8DS4YB2r1jOHA9Qdt4GBlg2j1427rwTXjoDZGJeKIQK?=
 =?iso-8859-1?Q?BWwQaATsrVq2a329Kpl7djhs6ojXjWnZPqaisoo1pd24UkNTutFEkcz6v0?=
 =?iso-8859-1?Q?BMeLfYs9n1A6v4lZflQknUObx2gAhQrdQXxGsGIYv/6riNXMYeyxbHG5yD?=
 =?iso-8859-1?Q?bXGuxQ5nO+gDxDFk/8oEOouawB3h8AYLENUTKmTSzMOaZF8XfTkiEGTSh3?=
 =?iso-8859-1?Q?0MnxuDL46Ppx7gNMQ4vgPU5NaYiJdos01oxP211iWZsQ9ttKs8y010H3A/?=
 =?iso-8859-1?Q?GTG4L3SlX9giDpe8tfWL25sfhjmdtuZkKGOLJ2Y4i4Shnrgib0FsM4O/0b?=
 =?iso-8859-1?Q?XmTUdIZ9ZzP/AAGCqeWADZDjishQJhr3cg/AhvwYYiq6EL5ixpDVM/z+2v?=
 =?iso-8859-1?Q?N+3DaM2EkZxuV/RCpzQvWFlXbzZW5J7AqxhaWMmWssxCwm/maIzcjnpOWY?=
 =?iso-8859-1?Q?t39PgcEIirNiRUirDY41U+U9mOBCwnmI4qE15DdS7Xn8UUyf3m2gviYT8m?=
 =?iso-8859-1?Q?gLXIGVLsyALEKfXfV/MmkrcVddynVptd36EGrcrqzirMZfVr0DPyoayPsF?=
 =?iso-8859-1?Q?/2EHZG/vT8kwhQjT6zvnxYTWrwFin7H7arfuC0oSsZAu1Xs4A4lfTq3qiS?=
 =?iso-8859-1?Q?f/Uh9LiueatFQ9k9EP1FJCsS8xSvadMs19obFpCtb2UMXXCebr+XODtaxq?=
 =?iso-8859-1?Q?JBH8MKAew/iolMIATAzEpAXDMz8SLOUI6bipqR1nrXO3ZuhrhSUN+nEumE?=
 =?iso-8859-1?Q?p7bz1rwKsk0X0GUJIFEsVgyN7bvYh4exew?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ad2dbb-7657-4162-12a6-08dcd4a454ce
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 10:02:24.3475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9OvWFCvzI18nezMe9B0DkwyP9FnrzZv+fgpSWChGdN1seD5v5FsK+MUYEO7fNqXC9BySX3UXwc3tarvzvaIVHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8244
X-OriginatorOrg: intel.com

> > ===Resources & users list===
> > 
> > Resources              SHARED  users              EXCLUSIVE users
> > ------------------------------------------------------------------------
> > (1) TDR                tdh_mng_rdwr               tdh_mng_create
> >                        tdh_vp_create              tdh_mng_add_cx
> >                        tdh_vp_addcx               tdh_mng_init
> >                        tdh_vp_init                tdh_mng_vpflushdone
> >                        tdh_vp_enter               tdh_mng_key_config 
> >                        tdh_vp_flush               tdh_mng_key_freeid
> >                        tdh_vp_rd_wr               tdh_mr_extend
> >                        tdh_mem_sept_add           tdh_mr_finalize
> >                        tdh_mem_sept_remove        tdh_vp_init_apicid
> >                        tdh_mem_page_aug           tdh_mem_page_add
> >                        tdh_mem_page_remove
> >                        tdh_mem_range_block
> >                        tdh_mem_track
> >                        tdh_mem_range_unblock
> >                        tdh_phymem_page_reclaim
> 
> In pamt_walk() it calls promote_sharex_lock_hp() with the lock type passed into
> pamt_walk(), and tdh_phymem_page_reclaim() passed TDX_LOCK_EXCLUSIVE. So that is
> an exclusive lock. But we can ignore it because we only do reclaim at TD tear
> down time?
Hmm, if the page to reclaim is not a TDR page, lock_and_map_implicit_tdr() is
called to lock the page's corresponding TDR page with SHARED lock.

if the page to reclaim is a TDR page, it's indeed locked with EXCLUSIVE.

But in pamt_walk() it calls promote_sharex_lock_hp() for the passed in
TDX_LOCK_EXCLUSIVE only when

if ((pamt_1gb->pt == PT_REG) || (target_size == PT_1GB)) or
if ((pamt_2mb->pt == PT_REG) || (target_size == PT_2MB))

"pamt_1gb->pt == PT_REG" (or "pamt_2mb->pt == PT_REG)") is true when it's
assigned (not PT_NDA) and is a normal page (i.e. not TDR, TDVPR...).
This is true only after tdh_mem_page_add()/tdh_mem_page_aug() assigns the page
to a TD with huge page size.

This will not happen for a TDR page.

For normal pages when huge page is supported in future, looks we need to
update tdh_phymem_page_reclaim() to include size info too.

> 
> Separately, I wonder if we should try to add this info as comments around the
> SEAMCALL implementations. The locking is not part of the spec, but never-the-
> less the kernel is being coded against these assumptions. So it can sort of be
> like "the kernel assumes this" and we can at least record what the reason was.
> Or maybe just comment the parts that KVM assumes.
Agreed. 

