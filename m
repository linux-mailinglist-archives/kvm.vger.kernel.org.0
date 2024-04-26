Return-Path: <kvm+bounces-16012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D308B2EE5
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 05:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6C83B22119
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 03:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 147E7762E0;
	Fri, 26 Apr 2024 03:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kuPfPnBk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073CF8473;
	Fri, 26 Apr 2024 03:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101702; cv=fail; b=fsxpX3jCcaX9/z5JHcS6XPlCHIM38vhemkeszZl7s0CDV7kqWIqMsOzn/xS1icQuQLGemAG6YZ5RT0spdQRZNK0LzAU8XLVc4AK4MM7VYQUI4gxfRVzyOpsJ3fNwVed4of7hbH8d2lPMEifHAElJ4yiLW6bYzd3s28FD/7L8Dr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101702; c=relaxed/simple;
	bh=EjbyI/mZpdzhHh0vPRK8Z2J5N/nQx9jB/Nv1yz1GKEA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cGBXjEpduNBuK/1foIcRa/81ky1SUJZcovfRYKrRa0VNFCK5tUq538UtEw6pXAyh+72odgOz6Mw32VArRDW/jGsoXTGsTDmer0MPtlRilE6Gh7AKiP7HVBeiJg4+RpeZq+TGgowdwzy5p+ePo4wl2WOm3cdv1rCsPkXSYzef/L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kuPfPnBk; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714101700; x=1745637700;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=EjbyI/mZpdzhHh0vPRK8Z2J5N/nQx9jB/Nv1yz1GKEA=;
  b=kuPfPnBkp/dpFI3bg9c3guvt2vOEy5Sa/SteuQbTCdspyCXedEereROP
   EYe6TeINPR32rfcgPcRo40tMC28pHROQTUuPuT/VGOzlNLmL6d4q+zxlD
   OfAYL8bXnkVMfN1vtMui9orHPEnQcCZ9nwj5bZmLA9yjSMMNUFwrhBPeK
   ghXah50TBGDKMxVnOgHglGkNWECPp02xg4jaKxgfw1QSAQXVPymn/SbhL
   7WKv9EcgiXnfqYQHYWwFiVIQMoLJYlXJK1g/kW2ShivkUJSU2oA+3pLHW
   sHjA3NZWZobw4je+Y/Ju2iypAbumpCTA3m7aiRHxsL8WqS4y7/WSVmZUb
   Q==;
X-CSE-ConnectionGUID: r4lyr6X3QfC15NMWrrhRFA==
X-CSE-MsgGUID: I9ZX7cEXQ6qKN3wps1jmgQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="21233071"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="21233071"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 20:21:39 -0700
X-CSE-ConnectionGUID: wRToOKagQC2jHwJ6+R6VuA==
X-CSE-MsgGUID: gwMK1ZnLQs+L3g3wxvM59w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="25375868"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 20:21:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 20:21:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 20:21:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 20:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmHW6WGGnVA6Nigi4W8FiGioNqehIZSYYLniTJkhYlkiGlFiLYY9E5jK62XofvBA3rIeADAKLt1QG5LKoKFLP1uKPRHed7oC37/IaiOUqJM20nz0NodwgolNtTMQja1jbG5wEX+6BnzU/QUYI7XC3nyt0yw0u46OP6n0Vxjzg/5O5RyVvp0/9MgRripxjzyILpYNmu37P2DsO+5tdwzKFpMA8N5JY0ObbDGj426DLOx0AD7Dm5t9yUTMKFc8ZWzimn0kjmD//bbVIHBiKMcopcnA6ypjGn/eKYwS2vUUM7Do/e5YfoizLmDmvI5UhjuLrXyn5hULtkJZDTCj00549Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIhMVg+Pt1AU1sGjCshhKufs0nSXBExl+BB7v7XQHug=;
 b=ByVpO8VqoZRFP66gF4C7Qgo82/FOvkP595vD9r95+ZG95dvXPqF7cHPi7dZVZhsP6HcfotkWc56PlQfFanUcneE/dlLzKn5FoeO4yJGq/6KLbFiDtxLFC32L3iL4+mnlTpdw0rE6FJgxd+KHxH1gaE4pjPGC4sw0Iviq6MyA9R/v6PEwaUXg+ZPKaNQV4mtRoCABb54ChxMYJ+Dy+imDkmikKEt1al1+5weT3yHmgrUZ563DSMIrgdqdmqPkXDR+JXG0fRr0dVV7FeYrHtYBAkVABIiJFwJ28iXscAw4dFltlXnymNDVAX+b5tRoS/UKyizDojYIzAMn8aGrTx0pBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8458.namprd11.prod.outlook.com (2603:10b6:408:1bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Fri, 26 Apr
 2024 03:21:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7519.020; Fri, 26 Apr 2024
 03:21:35 +0000
Date: Fri, 26 Apr 2024 11:21:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <ZisdtTJoqe7yxnvI@chao-email>
References: <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
 <Zib76LqLfWg3QkwB@google.com>
 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com>
 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <ZiqGRErxDJ1FE8iA@google.com>
 <22821630a2616990e5899252da3f29691b9c9ea8.camel@intel.com>
 <ZirUN9G-Y1VUSlDB@google.com>
 <2caa30250d3f6e04f4e23af96caed0f92bf5f8c3.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2caa30250d3f6e04f4e23af96caed0f92bf5f8c3.camel@intel.com>
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8458:EE_
X-MS-Office365-Filtering-Correlation-Id: cccbe619-b384-44cc-2f57-08dc659ffa21
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?DEyaCihmiYbGtngs6rpWbJ0HVqNCG5UYIf8x3TJI5Jx7dse9o0WMmQEywH?=
 =?iso-8859-1?Q?eB5COecWh4BItYDtmm5++vDla4atMtF32VyftaS038gJvsFzlDvN94Shs4?=
 =?iso-8859-1?Q?JECcLaxdwsrGMLK2ER4UuwEuG7Bk6N+aY5lpiC/jAnPpFjfuoiE0rEurid?=
 =?iso-8859-1?Q?Vo4pF/cMyKl5w8MEHGDdPiFZg642i/X9KbLwtBzkz2W6XVyvnyOzXzmq3n?=
 =?iso-8859-1?Q?mGz62wVQr1GKgqbd5AaDGL5Jt+x6Q/Wrl6JeVdTO0p2QX7OReB4lXpmFIU?=
 =?iso-8859-1?Q?vx8noMMAcY5Hrg0+48ZEvqqXQiB04b12HRsl2YcaHoLUz4bVQdoyVjDglb?=
 =?iso-8859-1?Q?qaXXv3nMY9BMMXf32IoNHPxD55944VUdtsDjWbvfHIKvkkIprP4LYVpQ82?=
 =?iso-8859-1?Q?NFeiDCdCGOOik9hcI95dGGKE+yPsr8FqaSHtwLGXMnJ3ZGBjWTL1/zqrQS?=
 =?iso-8859-1?Q?ONeHJH9RlT9ux4qdY4OAeDRVh/rCRierJmSMhRe5JJ+FlyB5Og51uZBPka?=
 =?iso-8859-1?Q?S4hdpKDnQHnmZIlIHkKCcYABsNtC2LqzHZFv0K0APl4ZsbLjhUISxaQ2q2?=
 =?iso-8859-1?Q?iaF1i/g79nTjtkXqQN//xk/MMV7olyWb0FrR+NHHm+5vLA0hf9WLLjuKk2?=
 =?iso-8859-1?Q?I6ylAd4glVrojSLnY2qs4y6SwAdDCG3x2jhhCmEEnGLTOHjaoVWomXiUCY?=
 =?iso-8859-1?Q?IdDgIPKJDpn+n17go2h1Tf6oY/IFztOAgTArQGz3taA2sKxU4j47MF5ASR?=
 =?iso-8859-1?Q?LHufCi+93exT8WyC8yokqywPFAD6twRtpHwZkVt8bFG1z9WbidRSlbIZM9?=
 =?iso-8859-1?Q?wSu7yKqoXfQWqFYhsO7EB/9i83X63A01r8qXT8mA/3LHd7us3BvySHZMsr?=
 =?iso-8859-1?Q?6ZUEQYUZwiYOylfQyYZOmAYKnKXyajc+Ptoiz213SjPSjQAPfOmouhnTyJ?=
 =?iso-8859-1?Q?VY658I6q54hBjKbI32E41k2hyeHvdqBAzLFdNd5TeeTxwtHAYiQBORV/0G?=
 =?iso-8859-1?Q?IevlcUQxlVpslIBS3H8gOFna60LMgugR4hHSoMzZrIg9WbFY4MEvbf0Erk?=
 =?iso-8859-1?Q?g5TKb7vtSS2vRZ32tr2ML+sJaLUUy6VIZG9Ha+/nKUDlbdGxY3YkSvL2Rn?=
 =?iso-8859-1?Q?N3u7oskLDojJA7L7TTvt8lTNkqZAREqqQWfQgHsxsqAqVOd8KcyFsZ+0X5?=
 =?iso-8859-1?Q?hIIkjnFmWwOAbz0VJu6obv1sslQERuGqOdsrVrsLBrQBd16jbSEV8mF2DA?=
 =?iso-8859-1?Q?vqD85GNOAO1gKDwM6OAfDIFpfaN2gcVqAPX19eonk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?5VGs4MaRZEoaN5f2YDTz6BBUJSfbRxh2REhPGdMhjCLb5YGnhQ0AEIkFmL?=
 =?iso-8859-1?Q?TKpYsKAKfz8oqCVN5g0ISp4hyCjoTK+oV8jtYXKs7yJEn8QfeBTWvdx0vC?=
 =?iso-8859-1?Q?Iu8li662M7/xhc4Bue72tMZAZGoRJakK0YA+RNpNB9hNf7AAXyO+q2TQw5?=
 =?iso-8859-1?Q?KJCKWaRRhtiydwFFVpNtfF0zOcL9xggPSlwWK8+2//NuLgx/OlNcdtPcGr?=
 =?iso-8859-1?Q?12Jj5tJk9Ol2Y33UfSTUQpOV4ZYXPLauTswHtNY7XeFpRSJM7mtl+Slif3?=
 =?iso-8859-1?Q?2nLWEaNPeoYbiqvvldzumQNipVa3Th+BlqNUW43x/N+Ji5FxtTqpPNbTqh?=
 =?iso-8859-1?Q?Sp0/UkMbuDjTNJuhPolnLyhvlKKp+MmA0ycZkbU1HWkEe9AXley/qIgHln?=
 =?iso-8859-1?Q?oJxPLOhemBXk5PBc8UyWpofP18YXSrN6J/TBEXt0yJOAjd5Py1UDHzhy7+?=
 =?iso-8859-1?Q?IfuVB33eWTi/VW4Rzu5P38eYEwLWi66Afu3vAMpQ2dVeyjyqHC8G30YkEz?=
 =?iso-8859-1?Q?LZ5ogeUP0EhcthMEIgmig67jWvAjJmb8A+tIUTGFh8mIBst07QnP3h+xSE?=
 =?iso-8859-1?Q?3RD5lQ1Wrm6+LU7/Yl+VWSI2HksLit9/N1+ggScIkOh3Sfq94Um25Ijrhq?=
 =?iso-8859-1?Q?jx7noHe/9XflGd2zGgRb1APLEO819/3i0QeLkbSbFU0YS6iaCsBzjPtqod?=
 =?iso-8859-1?Q?vQwvSQH/ZcgucVCnFktoE6MIhyfp+og76oDS3UL2THZTQECMoe+GHzDcHJ?=
 =?iso-8859-1?Q?txhwp2eUlVCuBAETHe11uEv/hfe2+B0iCI3Gt3TkSi11YCMcK4ddO6Rh4H?=
 =?iso-8859-1?Q?punO7b8dqtpFyuAeZ4lbslEQRrIP88KUDopZqfkAAxj5Mnnqcgto6G9v3+?=
 =?iso-8859-1?Q?itENKYJschCyGSGPWeKYmtdiheERYWUjnPWA3e55mnisbEhRhGpQnXHhRx?=
 =?iso-8859-1?Q?5k18cC8EbNTzoMS9tfQGD0w+hcaUUmV/uvCSIh5e7/fq47gmw9jTwFKO1O?=
 =?iso-8859-1?Q?304V9S5Vf7m2RXrL5NEAFmsz5uJnP03BAr8bQK1WqmOYyHUi10TXKutnjf?=
 =?iso-8859-1?Q?Sg+8GSQTJtEAKehT7iWzArytRfxvKY0zFRymkXLPOUl7BE4xppWnhsP29t?=
 =?iso-8859-1?Q?SxqrrWy/PV9aUdV400smKK46euMPGTXiSdfBZXpgPegD9gwHd8U2R+Zi1x?=
 =?iso-8859-1?Q?eHfMhVB2G/qPAPykOp5EC0iUbGukD84vXjP97CWXTLSYSCtvkaroP3sHnp?=
 =?iso-8859-1?Q?TbHcuU5td6wiToMRYNGEPwztAm3QYmuQjY6T7jllgARe7V5/Kt7WKb1HOR?=
 =?iso-8859-1?Q?BviYn1C4l3TyZ82HufcfceQAhRdGrfe5Kv2cbVCOmkuL0rbPuddMfQ8yZ+?=
 =?iso-8859-1?Q?grH246nmTddJzvSuJwK24CvXOYIXUjvgJe7Zvsv8VWfaj1SnXVyNmfimjn?=
 =?iso-8859-1?Q?P9IddGZmJSDv15JOHTlwCZoE8SMNYCv5y0iaTeWAAM6ppZWCDtFZ3kWWhd?=
 =?iso-8859-1?Q?BNQk4+eTO0OfETo9zy2dbPzy8k9E/V8Rru57bM3I7xFA1JtUahq35rVvlF?=
 =?iso-8859-1?Q?T0vpzGxbvaUcRYRBcrrWsAd9cuui2MmZ9typmnYC+Q81838aB/xyvq6fTw?=
 =?iso-8859-1?Q?LdLSO2tOgLnSgOzr0ENHaZPwqhVhv5zNh9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cccbe619-b384-44cc-2f57-08dc659ffa21
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 03:21:35.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZEXYdRBQj2VHTRvhoYtISBD1W7PxCimb4v4/3SM//N8i7NSyx5OtNKds3mTi16rV8rIUfMw8BTUkR+s+9conQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8458
X-OriginatorOrg: intel.com

On Fri, Apr 26, 2024 at 12:21:46AM +0000, Huang, Kai wrote:
>
>> 
>> > > The important thing is that they're handled by _one_ entity.  What we have today
>> > > is probably the worst setup; VMXON is handled by KVM, but TDX.SYS.LP.INIT is
>> > > handled by core kernel (sort of).
>> > 
>> > I cannot argue against this :-)
>> > 
>> > But from this point of view, I cannot see difference between tdx_enable()
>> > and tdx_cpu_enable(), because they both in core-kernel while depend on KVM
>> > to handle VMXON.
>> 
>> My comments were made under the assumption that the code was NOT buggy, i.e. if
>> KVM did NOT need to call tdx_cpu_enable() independent of tdx_enable().
>> 
>> That said, I do think it makes to have tdx_enable() call an private/inner version,
>> e.g. __tdx_cpu_enable(), and then have KVM call a public version.  Alternatively,
>> the kernel could register yet another cpuhp hook that runs after KVM's, i.e. does
>> TDX.SYS.LP.INIT after KVM has done VMXON (if TDX has been enabled).
>
>We will need to handle tdx_cpu_online() in "some cpuhp callback" anyway,
>no matter whether tdx_enable() calls __tdx_cpu_enable() internally or not,
>because now tdx_enable() can be done on a subset of cpus that the platform
>has.

Can you confirm this is allowed again? it seems like this code indicates the
opposite:

https://github.com/intel/tdx-module/blob/tdx_1.5/src/vmm_dispatcher/api_calls/tdh_sys_config.c#L768C1-L775C6

>
>For the latter (after the "Alternatively" above), by "the kernel" do you
>mean the core-kernel but not KVM?
>
>E.g., you mean to register a cpuhp book _inside_ tdx_enable() after TDX is
>initialized successfully?
>
>That would have problem like when KVM is not present (e.g., KVM is
>unloaded after it enables TDX), the cpuhp book won't work at all.

Is "the cpuhp hook doesn't work if KVM is not loaded" a real problem?

The CPU about to online won't run any TDX code. So, it should be ok to
skip tdx_cpu_enable().

Don't get me wrong. I don't object to registering the cpuhp hook in KVM.
I just want you to make decisions based on good information.

>
>If we ever want a new TDX-specific cpuhp hook "at this stage", IMHO it's
>better to have it done by KVM, i.e., it goes away when KVM is unloaded.
>
>Logically, we have two approaches in terms of how to treat
>tdx_cpu_enable():
>
>1) We treat the two cases separately: calling tdx_cpu_enable() for all
>online cpus, and calling it when a new CPU tries to go online in some
>cpuhp hook.  And we only want to call tdx_cpu_enable() in cpuhp book when
>tdx_enable() has done successfully.
>
>That is: 
>
>a) we always call tdx_cpu_enable() (or __tdx_cpu_enable()) inside
>tdx_enable() as the first step, or,
>
>b) let the caller (KVM) to make sure of tdx_cpu_enable() has been done for
>all online cpus before calling tdx_enable().
>
>Something like this:
>
>	if (enable_tdx) {
>		cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, kvm_online_cpu, 
>			...);
>
>		cpus_read_lock();
>		on_each_cpu(tdx_cpu_enable, ...); /* or do it inside 
>						   * in tdx_enable() */
>		enable_tdx = tdx_enable();
>		if (enable_tdx)
>			cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
>				tdx_online_cpu, ...);
>		cpus_read_unlock();
>	}
>
>	static int tdx_online_cpu(unsigned int cpu)
>	{
>		unsigned long flags;
>		int ret;
>
>		if (!enable_tdx)
>			return 0;
>
>		local_irq_save(flags);
>		ret = tdx_cpu_enable();
>		local_irq_restore(flags);
>
>		return ret;
>	}
>
>2) We treat tdx_cpu_enable() as a whole by viewing it as the first step to
>run any TDX code (SEAMCALL) on any cpu, including the SEAMCALLs involved
>in tdx_enable().
>
>That is, we *unconditionally* call tdx_cpu_enable() for all online cpus,
>and when a new CPU tries to go online.
>
>This can be handled at once if we do tdx_cpu_enable() inside KVM's cpuhp
>hook:
>
>	static int vt_hardware_enable(unsigned int cpu)
>	{
>		vmx_hardware_enable();
>
>		local_irq_save(flags);
>		ret = tdx_cpu_enable();
>		local_irq_restore(flags);
>
>		/*
>		 * -ENODEV means TDX is not supported by the platform
>		 * (TDX not enabled by the hardware or module is
>		 * not loaded) or the kernel isn't built with TDX.
>		 *
>		 * Allow CPU to go online as there's no way kernel
>		 * could use TDX in this case.
>		 *
>		 * Other error codes means TDX is available but something
>		 * went wrong.  Prevent this CPU to go online so that
>		 * TDX may still work on other online CPUs.
>		 */
>		if (ret && ret != -ENODEV)
>			return ret;
>
>		return ret;
>	}
>
>So with your change to always enable virtualization when TDX is enabled
>during module load, we can simply have:
>
>	if (enable_tdx)
>		cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, kvm_online_cpu, 
>			...);
>
>		cpus_read_lock();
>		enable_tdx = tdx_enable();
>		cpus_read_unlock();
>	}
>
>So despite the cpus_read_lock() around tdx_enable() is a little bit silly,
>the logic is actually simpler IMHO.
>
>(local_irq_save()/restore() around tdx_cpu_enable() is also silly but that
>is a common problem to both above solution and can be changed
>independently).
>
>Also, as I mentioned that the final goal is to have a TDX-specific CPUHP
>hook in the core-kernel _BEFORE_ any in-kernel TDX user (KVM) to make sure
>all online CPUs are TDX-capable.  
>
>When that happens, I can just move the code in vt_hardware_enable() to
>tdx_online_cpu() and do additional VMXOFF inside it, with the assumption
>that the in-kernel TDX users should manage VMXON/VMXOFF on their own. 
>Then all TDX users can remove the handling of tdx_cpu_enable().

