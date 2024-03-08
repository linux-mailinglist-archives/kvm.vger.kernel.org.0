Return-Path: <kvm+bounces-11393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9240876C01
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 21:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2137B1F2280F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 20:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80BE5FBA3;
	Fri,  8 Mar 2024 20:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Af8XLM23"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED3A5EE96;
	Fri,  8 Mar 2024 20:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709930784; cv=fail; b=WkOa/C2qxWb3Ekh3BnGA6egfmCxHKnnkWsZX48GIMjEClQHyJH2ISwLyR64ZRWFpMH6oQXSDMmKuetWD2KoJDD2dMiXEMWiPZSQWFbA5EQLsCD7Xps8YhvXMCGcfdLb3967WdFnbk70clcZ/Hb0tp9lOxhTYqeFwHIaF93aT+XA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709930784; c=relaxed/simple;
	bh=jC4431GtX+VB3Dn9taYo8vQ9F5Qs+vlvyTBWI5pkhi0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FLvn87K/YjuNSlK4I/aODypgLDSyDzEBBLjcL53n1T1mRXMQm1OPJDEU6zYzjCAkA+yfnKWUnu2cNvAsCwdUzf2qylT1NN6A0QvGKsxqLWy9+tcAtJs8lYR2PI5qKSxm85QR21+kF+humkmJJQ9vOmol7AOcN8uoHLhjQu/KYgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Af8XLM23; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709930782; x=1741466782;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jC4431GtX+VB3Dn9taYo8vQ9F5Qs+vlvyTBWI5pkhi0=;
  b=Af8XLM235vREoKNJe84CGP64bmXRhjR1Ts89omBynWV57jkG8pAi1ZzG
   p/f8wigf7jznspOMcaCWiocHLC9pqlZG/22tWUyWx3zHtc4S/1uCG+9qy
   tJxzSLuJ8bLpnHOk58WwtS3D2LNQ5icj7LpeN9UBSFCQRC7AV5m5HGSlD
   +OnDOu/Ymmk670nEnB0/CQdpvtcMc9EvMp3GaJyT4nFals9vKktrYWEFf
   yK4cUQb2wso7UU9GREXQRIN9YOGqfpSPVjYDZlgVx9ErMxHdnRU4dus+G
   UduO3EqOl+dNK9h38iekR1khMBAPfi0s3ymwOSc21xzmlI4pAeU56hES8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="4534408"
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="4534408"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 12:46:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="10667234"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Mar 2024 12:46:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Mar 2024 12:46:21 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Mar 2024 12:46:21 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Mar 2024 12:46:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SS+gx3PCWRKCIzJLMlfo74eR3ns3sCnc44DGkJVw1pN9QOvd5m90/NVeJjoETQtp7zyDZnyuO0q7qZjjWxEveAZJWxZYxJB9SYq1dh3RDb/CSN4Wv7VD4myNxUp0jLXs08YtasDUgvG5ze1ZCPH/puU5p+DJPokCabLRWePXDJrzl40soDRZciZG9yYUfeX4Eak6vc9TRxAlPfr8bb0hgtCg0414XMvDxN82ifoH3+BWE2lKY1WWJ0m8GG2jaJHBYyY+KwEqva6/jkj+pBVy2H4v3cYV9FoMgBqJCSqwWhvBi0wc6oLBxaRKxg6+a9JVer0ys6vIVL/rT2K4LHEcLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTkC2hXEIYDGfImZx4HIr6rXTAFA5a1SXIAPA1Bd7IU=;
 b=BNwu0N8nJFf7WiMQTYQcw1GYF1UX4pA5w/s2jG9YbcQjFwC9rEKkdaXNPfCAdQ5nmkfksDLuDcoJVmb6tvi6fsdu/Ti7cg9vIp04j4dH7n07YSyKb3Wfa7/KrV1/84ZgJmHtRmlDqmaFA3Uyve39gtU9fcQhbEeIFHoErGmVr7h6XvQQKPlt2E4bDwTYAeAtsG+Jqxsf/ikzkGr/+OCiZTjw8npQCwyczZuTQ4nyDYghCFSoxr/OrR9Cp2SF+W4Av1fTGpKP1XldvzOabe+cHkTx3RDUuy/e/Vhky7a3EQn97ajsn2HbcBCGXkP1aInDIG2GyduNHOP4gWPYPeGGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.10; Fri, 8 Mar
 2024 20:46:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 20:46:19 +0000
Message-ID: <b57b6a87-9805-4643-a56c-e866c8a5b1b5@intel.com>
Date: Fri, 8 Mar 2024 12:46:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] vfio/pci: Create persistent INTx handler
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <eric.auger@redhat.com>, <clg@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kevin.tian@intel.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-5-alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240306211445.1856768-5-alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: e61eab70-17a2-4329-09c0-08dc3fb0ce6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpnNsNqV7uB4S9xU2yvcpMSdJnDvTJeKzW1l+PltrE8sDrCOZv6f6MAqlDltIvS17BRXMy3bp3Hy0xdGxKMkEx5ZPJhJk+smJ1vLoGoxHyMZZ7aPoqC8jtBf5zKn1J/9kkpBayCtQ/pCZSKGYHXzYJBlZIv8bWVScUTzTKB1mJp37Erjg/GVd7udkjF3bflx9Sn4uJ/xCyxzdn7iKP/hPAdkcztPG7QOTp1GtvfpAK+fIjAGFFfFMS7AaHJwnuRlH9XI3hj/Ap809+6A7UuqUY9KG6m5Wy2VEBCkmeAcfRr33JbKcW0Ezqnturr8MKM1WK4ftdyf7MvMNSqmPvcB2Y3FFcPXDUtog/F1MSZ6PBwAyThpit96gJ9Bm33Qeb3r1LWTlcQ8LEjGJgO0ZE29X92QhX38PWTxURYHBTAd3oIgWXJGMkUSMX2Y/zrKxv+kb/9lJvyrZIvGHFtpv1bdUzfl7IRnRGw4gyi94m2JvHlAocEQotghxq1HFbl4g/EeE6INPjpbARldKK9/L89XPaYgiYX0DBktomvLPnHfXsDkJbeXRtOA+FR5G0ht0gd2SMJD6JFmXgKbbC7MfuvrKftYxV+hblaHxiEPda+MZdPETvJSv/PnW7vPhscefMlvfxlWRZlfSAPABK9VNtOlRW2zFbNsV97hjZ1eDsOyZRU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDBRSFlUWmVzV0YrdlhsT0hzc1ZEUWJCVTRMOXVPajR2eEYrRy9SM0VQaHpT?=
 =?utf-8?B?ZUk3ZGJoL29mNCtIbFB4Y1pWRmFBZDdNamYwbDBuUUpFbFVvTFJXMkc3bDhD?=
 =?utf-8?B?ZXlVaEtlVmVBS0F1WmxxUU5wSm44bENxb1Y3ZDJPYmN3NTgwNVJ6d2NZOXRL?=
 =?utf-8?B?YWUxQ29GTjkxa29vOXMvb0tMZkl0OVYzMEt6cUhhdUpObSt0Y0E0Nkk5enZB?=
 =?utf-8?B?aldBUWthbnhtTU11TmxzeFcrS2RiQlpGUTVRWldPbTVWN3psREl4ZTk2K2dz?=
 =?utf-8?B?ZXlvandyajFWSXY0S095bHhDbFRFdVpqQUVnRGNGZ3E5dlFtekxpSjk5dktZ?=
 =?utf-8?B?bThWQ3pHT2FrUFhpTXRKSi9vbHBjRmNXUU9Yd0FUWkR5ZHMvWHpIMnFkYU5a?=
 =?utf-8?B?VHNCRTduVVU5OVg3WGZaVE5hWVJabzlNcjNMbVByYS9jSlhqM2thcXM5a3NZ?=
 =?utf-8?B?UEdLYzMyTVNBMGYxQndGeEU0VFM1eXd5M1hDT3REa2VrVUk4MkxTTjZQMGxr?=
 =?utf-8?B?K3VSSVMvRHdZRmZIemFGVWtEYWY4aUNqa2o4TVRxRmtKZXdiQ1hCMGpmZ0I0?=
 =?utf-8?B?dDRBdEgvbWdVNFMwbm9NeUtXSzhWTFlsSXArU0JibjRwdmFPVWpsWHFZYkN5?=
 =?utf-8?B?dm1oZnVhWm5RNmw0NHZEcTZYVHFSTy9oQ1o5QSswazg1TmJGbkEvQTdrNysw?=
 =?utf-8?B?K0JucjZCcU9FVFcvb1BhMXhDZTIwczhDMW1nWHJ5VFNxQXcwMjJoSXNmMjlY?=
 =?utf-8?B?S2dsaEk4ZUpJeHlvaGxjNkV5TCs4cysrMmJFQ0JVMW5PR3pvN0JzdjFlNUpw?=
 =?utf-8?B?cU55WDYrTHBvVnFReGwzaDJKZVA2V2dkSDB0WC96UndnMWY2QzlscVczMzJ1?=
 =?utf-8?B?eGZYaWlkRWMrV2tVS1NHbUtGMkdJN1VnalpBR3htb2dnUzYxZXJRTTlUU2xB?=
 =?utf-8?B?S3B6eW9YTWxucG4yWWF5dUp3WXpNSFFEMjlFc1ZLUXlOS2dObGFsYkhtRjU5?=
 =?utf-8?B?Smh3Q3B2RThaR0tZemg5QzNRSDQ2WUdmSjRleXJ1RUFJZFNEZGpKT1NIc2FR?=
 =?utf-8?B?dHpJZS9wUG1SVXpWMmlxRjVlK3ZTaXhrUlFEd1BQUmZZUUVhTmV6NFYyMnNX?=
 =?utf-8?B?bmhRbXVUVDFqendSVWlhdFViMVZsTlYwNnk2MDdoVFpGNGxzUThhc2hyMXlY?=
 =?utf-8?B?N0lVUjJiVEo2KzRjbEtqS1RNVk56ek05TWxpQjd6cGtaRFV1eEJqV3gxeEs0?=
 =?utf-8?B?czZKREdBS2xPdy9oMGo2WDBXNk5vK0syZ094UUMzT3kxdVJXTjBFYlVnWHJu?=
 =?utf-8?B?b1pxMjVMNWtEdFpJdVAraVRQV01UUW1ZUEtreTNyaTVZMFUrZmtZU1R5Mmla?=
 =?utf-8?B?SDR3TmFCYUc5OFg1SE9nRHVqalZVb3BLbm9hMXFJVWZ2dTV0Y2lldHhDazhB?=
 =?utf-8?B?UHF3NkwwRmdBR3FuZ3B5RE14SVRhbmFZeXNOWGJVRWZ1d1pCQ0x3SmxabjN0?=
 =?utf-8?B?L01LSnBFZzMzSHVaT3JyU0ZyZ2pJOGM4ZkM0a3A4eENNVFg5TTRzalVOTkNR?=
 =?utf-8?B?YXV5QUtQdXpKLzkrN1FKWFgwcnZtckxBRmdlS09STmJVK3RNWG9OY1RMSnNy?=
 =?utf-8?B?Y3FEZ3E0NmtTbk55WHgyNlFJd3VlbjhFbFp2MDZaelBaNmRtZnV2aXJUbkRy?=
 =?utf-8?B?MGhiL29MdjVqd2dvdStJS2tZNUw5dmY0WC9SU0ZHS0EvbDFqNlhoSHp0ZkFD?=
 =?utf-8?B?VVdmOEZDZHdmY0lRLzQ2eVA0QVB0eDE2WFNMMEFMN1p5bFhuTnJLYUxqMml5?=
 =?utf-8?B?NFNxdjRjT0NlMTNNUEVJQ0dSOGVtbUdvYzNXUktDeWRodmhCQUIrc0d5ZWk1?=
 =?utf-8?B?U0V5Zkg1MXZla1lsSDRVTWh4dkxnclVvNFlkK1daSEhobC8yU2w1cWFObXVF?=
 =?utf-8?B?OHhrdTh4MVJhWjJCOXlCN0llbDNlZHJwbjJtcXlTRzUyK0VkbW5kWnFpZGdM?=
 =?utf-8?B?eEhtQ3pmcjZ0Yk8xOGdPL1F1S3FVWk5uOUJQQ3NIZVF2SjZLL1Q1NDZZSnZS?=
 =?utf-8?B?WFhzTGVSbExqUEl1SFVjWmhvVmQ4QjhkaGFIOW4zUTJNaHlpd2xiRmh5QkZw?=
 =?utf-8?B?bEpMTTlFMDZSR1p5RkVnWTQzTkNKQ0RGaDRFcDMzTGV6azlDVmpLdmJ1Y3dK?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e61eab70-17a2-4329-09c0-08dc3fb0ce6b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 20:46:19.0703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91dGBwKRJaba3XfgohUmTdSK3RUrcy5DqJYfQ6BMEzIYg+JXUKKUwXMOgbQ8fQww3SCFbhCUXl/7Y+MuQR2574JiUYHZnJQkPXMR3E00nMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Alex,

On 3/6/2024 1:14 PM, Alex Williamson wrote:
> A vulnerability exists where the eventfd for INTx signaling can be
> deconfigured, which unregisters the IRQ handler but still allows
> eventfds to be signaled with a NULL context through the SET_IRQS ioctl
> or through unmask irqfd if the device interrupt is pending.
> 
> Ideally this could be solved with some additional locking; the igate
> mutex serializes the ioctl and config space accesses, and the interrupt
> handler is unregistered relative to the trigger, but the irqfd path
> runs asynchronous to those.  The igate mutex cannot be acquired from the
> atomic context of the eventfd wake function.  Disabling the irqfd
> relative to the eventfd registration is potentially incompatible with
> existing userspace.
> 
> As a result, the solution implemented here moves configuration of the
> INTx interrupt handler to track the lifetime of the INTx context object
> and irq_type configuration, rather than registration of a particular
> trigger eventfd.  Synchronization is added between the ioctl path and
> eventfd_signal() wrapper such that the eventfd trigger can be
> dynamically updated relative to in-flight interrupts or irqfd callbacks.
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Thank you very much.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

