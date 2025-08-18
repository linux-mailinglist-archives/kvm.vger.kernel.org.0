Return-Path: <kvm+bounces-54873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4ECAB29B54
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 09:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 224BC178BC8
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 07:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E191F28B7EA;
	Mon, 18 Aug 2025 07:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjX9LQCV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A4427B4FB;
	Mon, 18 Aug 2025 07:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755503619; cv=fail; b=V2PtPu1sYH/4P0/tKULMXn943ETS7dkaBPofGpYQrI72KBy0nI1cATonKOctH+xv7OVqpGP4j0XFcRXjsY6H7+JZAtzCM2X120bx3VFN7zS3mAb4E/z+eCUr84EpuOeQIzovZYgii2vAQN6Jo0lfF9Krol0WsKRx1Rh/Q5JOey0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755503619; c=relaxed/simple;
	bh=O5AkcsTVMttzjNGKclbzHQajW7KaXw3OvHrtocSiY3I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fTD9BKQ+4mC+BfdH124eoJ3qi67uioRURLf/SJZ+8I6VVl83EwchYmE0+ho7C61Qr1Wpg5ZWE1d03oQ0pA2qibNRETdpFp4Qb+40XENhfpC/G/wrU7s7kkx0pOmg1+BHwY8qV5/DcfNfmr0v7pjFLjNFq3dYQnFcJZEK3iZv2IM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjX9LQCV; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755503618; x=1787039618;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O5AkcsTVMttzjNGKclbzHQajW7KaXw3OvHrtocSiY3I=;
  b=CjX9LQCV+TSrBbU6kP8BjAEvQy44Lx40swaG6L5HUrc5jmVu3K7D4rfn
   dTPSLerNCYpfF7XS4K0Dq/6zlM9sdSrac3RepsIQFgxvDIR8aldqFuJBP
   sZ5CWFq3TYtIg6SFWzlhPahSuMmiShvdpCrCsxUr4OWoXU95Xjj2M9f9R
   cV6uSz94ni5hhFI8sSc1uDyotnRPeqLuhPd8/VG1kU7P/7qZXVp5r8gP1
   TlVzkOT8IxtGAIzj55MEO+RhxcEdpIyn/J/vvAjXaTm/ZTcVBoKNZ8f/I
   5e+pPuBt8t1QZErY5VHCxGNHsAJVqsXWlb2E0C3HYpef4nyEXS5z9RQZB
   A==;
X-CSE-ConnectionGUID: Zyi8ydbkS3CiNsQmTiKUcQ==
X-CSE-MsgGUID: HYn3qJuSRFuBJ0FGKo2crg==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="69170754"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="69170754"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:53:36 -0700
X-CSE-ConnectionGUID: NFb8VGngR3mWu4Hs+ycKIQ==
X-CSE-MsgGUID: lcbWOxhiT2+A/XGDkXc6IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167010809"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:53:35 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 00:53:35 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 18 Aug 2025 00:53:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.64)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 00:53:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeBBaAVNCC6skSfKvXkGtr2j4ZWunZjqah1qV2T52v2hkY3+8ynA/fAo/O/Z8u+M4dOIaHlXgs5jr4Yicm9Fb2rDw9dAtxDUimqMpJec+s0j6EXtTl7uiMK8I23170OuTrL/7XWR2eg5/cz7QRVDaY4cS1lvfBoomJHJQKsE3YtgfONK6g2VB6mw+FJ6boL+ahgls/4AUafvc0Kk8KgPUelV55EGckRQps9+X4/PxpLsFxzNskvIEe8XVcq8o2Fqq99tClzJKjT8sw+TJfOaXdD4wI9jWYv5huFm6cnIx2/s0saXnT/Z+8qfJSeXDKBXVHO/ttOcEeEv3VR7d/KGlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5AkcsTVMttzjNGKclbzHQajW7KaXw3OvHrtocSiY3I=;
 b=RDDuuqY0CbUlaqbCTXItM7QD/jzIpb23nmwfS5U6K5+I2WzFZMk3+vTecQg6M52KuND2o17oLx22J5mmZ4ObkZ1LGhr1JZxnk4CpU1f8OKjTJksz0Dr/d420Q8E1s3l/Qp+lIGDmo91NY5d9e2vnB0g7YwGHtFLEJkBxO3e1okf/i5rrnCPMhFHmX6u5J0fInFh6jiOFqCeUCSOiS5Ap1WDNbjq6w4OD+rysESFCr41cJnV9EWFAv0lZ8IGsZY8h+Ask8jEAtEskP5WJyXuivwHBtNxph/5Wm4XAjMJuGw/GxkHh5x/bHcQQX4CbZx+WrvufRai/kjVa3dXW3VFTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7017.namprd11.prod.outlook.com (2603:10b6:806:2ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 07:53:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.021; Mon, 18 Aug 2025
 07:53:32 +0000
Date: Mon, 18 Aug 2025 15:53:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "xin@zytor.com" <xin@zytor.com>
Subject: Re: [PATCH v12 00/24] Enable CET Virtualization
Message-ID: <aKLb8ctmITkw0Gew@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <a988d316494fef4b26e86b9ad9d86f48c70c08d8.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a988d316494fef4b26e86b9ad9d86f48c70c08d8.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0150.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::30) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7017:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d1a6c87-4338-449a-02e4-08ddde2c53ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EkoX28c9mWjWo/2iHZrWM1zIGfkOArFzYFtKd2bdFOzssHpiBTgzhfRbA08a?=
 =?us-ascii?Q?lNDyqzyMDCrFoz6L8zgib61YvNhQ2z+y8gBQTAyhmdsDNZtfBGOvWayaxNXe?=
 =?us-ascii?Q?MuZZTvO/zpkBG1mSoeJp0wWH7bqV/PIQGx4b+pWnajUsfH+hRrNafTzfLAPH?=
 =?us-ascii?Q?PsfLssyVqNnswWhbJwlzzKzeme8fYE0DR94C2PWFZFz41TFy6SoaLwafnGpw?=
 =?us-ascii?Q?9AYZsdaP5fvRVrwNwXw7YyTOQ4BqpDKroY7wQiSluMM05pTeXc6o0jzqUHeP?=
 =?us-ascii?Q?WrV1zcW9reY2c7rXVNvIQDVWxOURU0uV/m1QYDmP92bUefNzU5SORgDET4A6?=
 =?us-ascii?Q?0erpcKWEYvRX0vhah5RQLktwzTYSgb52MiF0hHXfbu75mLTRPlCJYFdIfqOX?=
 =?us-ascii?Q?So4j0y0XXIOpEweclYLVbPRKXtCdq3epGgksY5QsxlPKHCZWKSI0sj2wrnJj?=
 =?us-ascii?Q?I4b26HZr3FA7EGJKRp8iGBnf4YAOUOO+xfoWpkSEm1GS9GtaD70r6xiqUHa8?=
 =?us-ascii?Q?7tOBIahXD/U/2GvB3kympTP+9p4FllJIlb/rMgRnI2hentRA6eZNtuNuJs8w?=
 =?us-ascii?Q?UN0+yL5PaJ3tjwAxHXnoQbs8PiUWL5LdhY5zA3C+I2XbYx4zq6Cgpo6MzOTJ?=
 =?us-ascii?Q?BJ4vvuRPJIEHvw+EUQy1iinQrjmnC7PAQ+mizpSzgcw4pVmsUGEuswXaAdK8?=
 =?us-ascii?Q?EYgnATli43/IUEqesHnIr22Wx7LPNmF0xdVqrwRMPCgWG7KF4Q3x3oOioGLf?=
 =?us-ascii?Q?8FthMNVFU5nQk/5n0mn4XCNL4s9f0ASPEurFcqNS/ORauEaD7wIH4LRmKArM?=
 =?us-ascii?Q?l77Gk1XeBs9zD0Z1LXV6Ep1kwCWi4Rc+/eD9j8NYslcdwLqjIg9Np4BJ8GQr?=
 =?us-ascii?Q?DD+5SAzsLgvkCKAatL/3jfJp4ruAK3mxtrC3GDFXqMzQwZ7DJ7KQw8BKR5F7?=
 =?us-ascii?Q?EtyD2SZYy52Ol2IAkBHU/6P0OGFq9ukdqo4VD7O1+LPtRN6M8NdiX/9M9ztZ?=
 =?us-ascii?Q?jltsqTi2LkO0vDVt17EHXE2bYr/Nz/0QKd3aMvd2YUBCoX0dTXQgXGLwu5WM?=
 =?us-ascii?Q?xCdLZobHHk7FLA9us1p41vcINnmrw/qaNAt5OJaIfPYavKPQqZWRFKqYYfwm?=
 =?us-ascii?Q?1S33yzIdUkuLgIchlHTVGl6vwRWYvGXueJY1VuRq9uyCvw5QN0wWKLwMfX9U?=
 =?us-ascii?Q?ghQsNvJ6u9AWcSzvRJxa88q+F4sKI4Swwu089+qgz4+HmDmkVsvwrspoaQer?=
 =?us-ascii?Q?jc/7Vbdgfth6YoVb4tmbJdwfSYh4+8pGwFM8vM5UuKBCgWxxqr83HSl+0lHQ?=
 =?us-ascii?Q?W7kAJBp2zRKrA1TiXLwJMTCAgvY+1zmnPXIcnhO19jcbvesuKuQhkK0oUT5O?=
 =?us-ascii?Q?pptDmZ4m4hESg7ZUwo0xtSx0xb2yWekZKZXTVmC+oZ5A3gYNJ0HjyT04aDDR?=
 =?us-ascii?Q?h4YUyVB5+5k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ONzW2yK44ywNOXu+mFki0u1VJ5SAwzbg9Xo5rSAQNu2WU1MrpE7f5Yi0hKZl?=
 =?us-ascii?Q?2cK6xqH15+EE1+GNObMxFJIw8DhK78ZtJzHr464asXddrwK3TImvyAa+aSx6?=
 =?us-ascii?Q?gxmda4S1FA69Uwx1s1wxNGImODjcJqafpDktXVRiyKqwS43UosGSlwzpcGyf?=
 =?us-ascii?Q?oxIoWCZ+VMZaBVUAWHcw8iptPPjQ1smhDF1vL4F37UwPLlZzkBVvbOAj5tQv?=
 =?us-ascii?Q?10qwcYgvjFrLqzS9zi1frI1GODGZ/E7Iq6HC22AmC9QNB7ZE+HbQg9KRsgIa?=
 =?us-ascii?Q?UyBu6+kAE8eGjBsee5uzpYmZePxY2OYZCrryAe8kxkGSG24prE8Adovna81u?=
 =?us-ascii?Q?sjYsDTlBf5u74q9+M0wcT2/898soLfaFrB80w2xjXNYv168QevoEVPc/tyK6?=
 =?us-ascii?Q?jmayEGASvhJm8ZGJ0zUZKLd0xYiQ2YAXl53HRU/YLu6jq2XQYP3rQTKjEE2B?=
 =?us-ascii?Q?maU1FLYnCCRldcvs2+SVZK5l6EIPORnCMuceWbuUOgy2/9yXCZWrROPc/18v?=
 =?us-ascii?Q?nVdn7wX9pffPqIMxifj9MigpqZ/SD9wwdD0BROF1iQ3bVwzi1wbX9rYZ9FtX?=
 =?us-ascii?Q?hCdS/lkk/etM62HAfKApJSO2G7E090xKhLsknWqiyF2kU3pSZegTQavF4gFU?=
 =?us-ascii?Q?ZN6fc7CjjxgAUnpDuxYIHmt/0B964XCxjTDeDhFnx8n2soSJWI5BXZ6NmMUQ?=
 =?us-ascii?Q?hrJtB05xYNCtsuYZAaSERad5Aw+HOEN83E/0fQlkJtR7YcQRcTMkHs1tqtKY?=
 =?us-ascii?Q?c/DNBDwRHNZjEpD/HCtRIqjh8yjWhpsWcig1F0QH7m3pcO6nKClY4TwFK9tl?=
 =?us-ascii?Q?nqrPBkzE3Azjn+4eeki5NqNTtYJi07BFnNijPhDmUI7bDgnmnmnZBG5P4Ool?=
 =?us-ascii?Q?nlXg0tS0rodSSkGNzn22VKYWaUd8OIzdawVQNac1v+yStanXLASdxowX4n/K?=
 =?us-ascii?Q?M6qJTCeE0k9xktdbjp+0N+jbIzpGfaEsIwvgx94mzpMX/AF/vZWQWRQz9WHr?=
 =?us-ascii?Q?TxHYimkkOJQ4SlStxDq6I9EODewFR3+9veUQN9S0iuqvGLOnFtLZ3FrC0c2z?=
 =?us-ascii?Q?ILedm6HM5Uoi2JPIqT1EJ/HZs23tBtVsZUmSUtIT+0QvjSqNvpU5sw/AIu5Q?=
 =?us-ascii?Q?6prDM64rSkA0lI6jiYpbnbzIQ1ueU+y2qQaRqYkLb4JT8SN1m3oULGM8Rd7F?=
 =?us-ascii?Q?9rZPLcA9k3bwto2wM0tgY2B3p/BkgKgV7U8zUUCHwpYVibCq1x+CI222HAIM?=
 =?us-ascii?Q?K8WZJxbnVWzRGVvzP5wvsxup7/2mo2WNSmMQ8WJwZSJCTg7JmTupe/8yRSeR?=
 =?us-ascii?Q?A6JHMUSghsNx5yS0cg0wT1k8arf3bO2pvDVaFBHyc4e2cWjbQdBjt3Vg7CyG?=
 =?us-ascii?Q?m2LGYaPwLBnv5yCnY0TihM51r65Q+FLP5X671eUGFvf0rLsPMPjnyRHy5aBI?=
 =?us-ascii?Q?UmW/bqd65hAwHEWPxDly6ZhpWJKBNzrWm6ZhCX0rQQZM9py/v9/zQEhLVdTi?=
 =?us-ascii?Q?m/qO3I8cL/S4AFzmV/iGvQrsDm8NKvbys6bDjG2lqDinxGnDc2Ttl6x2riU9?=
 =?us-ascii?Q?VEsGp0UP+zGQ1fpq8XQH3pNJchRiIwwEOXiObvGx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1a6c87-4338-449a-02e4-08ddde2c53ee
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 07:53:32.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVA4ZKta91V/zcduXDruXsXZac7jU0V6NCUW+K0gYings0jxlb4wfvbMM2606pNX9dl4iXZ/IG5cpOWgC3WnIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7017
X-OriginatorOrg: intel.com

On Sat, Aug 16, 2025 at 06:57:00AM +0800, Edgecombe, Rick P wrote:
>On Mon, 2025-08-11 at 19:55 -0700, Chao Gao wrote:
>> Tests
>> ======
>> This series has successfully passed the basic CET user shadow stack test
>> and kernel IBT test in both L1 and L2 guests. The newly added
>> KVM-unit-tests [2] also passed, and its v11 has been tested with the AMD
>> CET series by John [3].
>
>I guess there is a bug, but I gave user shadow stack a whirl on L1/L2 and didn't
>hit it.
>
>Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Thank you for your testing, Rick.

