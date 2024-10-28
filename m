Return-Path: <kvm+bounces-29903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D419B3D89
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0439FB22A8E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C022D1E9083;
	Mon, 28 Oct 2024 22:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XA8g0fWO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD88019005F;
	Mon, 28 Oct 2024 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730153533; cv=fail; b=KzEwGDCx6yNVztU5Oa46z+h2SMUgQGqSALgzN2fEArd+D2aAOBe2zST7ZBF6dfifPVybOrAibsUAkfTIk/WlDFVjvE5pLzS06pN4Inae95raHODaWrSWY+P2vSa18PXTD1mfnTIaUDaTlF5EMc8BpgbBrHG9moZ6O6DfoODdsKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730153533; c=relaxed/simple;
	bh=ggGUdClM5ia3gzVrTDSRbu/Anx5v9pxrD6bOqpOa05A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XwOCWZvKuoNV8VCkuRg1wwji9Vq5Wf/mdrpuyo3LQZ4GJrYs2Ges1wCgSGeqFb5NJRYGULLxWpEAFrw/AzF2n83Iox+blkgh0K0wVwuxKo4Yao7xeIlI6kl5GriiV3erU+GTrO8MCSb4DCwSA5sudqcRT4RhWehDL6X/0ZDK6xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XA8g0fWO; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730153531; x=1761689531;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ggGUdClM5ia3gzVrTDSRbu/Anx5v9pxrD6bOqpOa05A=;
  b=XA8g0fWONWbHVq3w1otaRWbT7YjbtwpI9N/2PQfRVbYiX5vAtq2yfNMr
   M/nZHYECh/SHjIieSusVU9XTADu5VSArJ5vFOETZAvQ0DfTDPL9SOsdp1
   bOztQ2TPnHUZ8sXf5P8kVLKupW3RYZfqamF1bIYm3kW53ns7XLirj/Kye
   SGwksJ9QzmJcJ3zmhubOqI1nlB1HYJrjr+NBSvyvXxJvePX7VxsbLsGGw
   KclO7Hl7MTwWHHJVrQQWgg8BZLVowdcBM/rulFzPQYZhrtJjzOLVwI/VA
   +mzSiQm3Jv6zuxKTJ5uyCZJQ3ZykUQeMzdW2LZ+QrcfwkWtUHOmse2D8K
   g==;
X-CSE-ConnectionGUID: WlfV4mjaSZ+H+B/DVpx/lQ==
X-CSE-MsgGUID: cWfkvxxqS9C/M1WMurYSKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="40388925"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="40388925"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:12:10 -0700
X-CSE-ConnectionGUID: /G+x6iwkQEeFU0DX7xcxJA==
X-CSE-MsgGUID: bqtAFm15QsSuK8zMxDLBnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="86314086"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:12:10 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:12:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:12:09 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:12:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ky3Pyf6WjN7OjSRQDNVxDk5Rt1TyJcK8qlBMeoFRZ/5HIvN7us9Ld89eoY1+hTzyCbU1tQ5cgo7hmj0xNrs3LrUPfo7U1OLoeA8nV4f/C6oMFWBPNWp2u1dJwVpm/rSjttGn9JvOIBAP/dmdtTtgr5ZB4MHcpa3cznzCU7Pz5dpk3+2eMgDE4upLuE8IARhOBUVcF7d7RKiLZbmi8ujvFO9c22z7tMroiUtiZhlMGKfwYpx70a5qqH6McVopWpvkpEnz+48L6O9m+KS8YKiIq1pCPh3lXJahfPd1ZZM1otIcXANAswaXVjXVuYrRBdVjLrlud8KvK609qVSH1Kmyyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKi22SwwzIhcW0Musk6wTAnVqbTdtlGwcpfQCXZlCtg=;
 b=qVijfMAY+t3tKyTooqz+q5ZX09HiWB7XvvwNNFkccz1dYOsUli9C98CwTJ9PxOc0o0Ght1TztcFa/3mOfjrdOULwRARDgVvtjpi3ADPzc75vBzPq8nFGVZpVClxfxjbFQXq0okEHAvKmz1y/LCga2tnM8wZ+wJSBD9zK/q9pGo2rXvT5yZMQt94NLUE/RSnWWQKhds8u3xHP4hezJpiRSJz9LwDd9mnfSj/RA03vql0yFX3RllwWbJ1hF/tPWBnKX9Uwrho4b4A092KDVcAovNvaqjf5mDgzi3eT7/daqPQ7GVNoYPkvKbchcOYyU2hX2+Gk8jDgzuVw9CPA3tgdNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB6844.namprd11.prod.outlook.com (2603:10b6:930:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 22:12:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 22:12:05 +0000
Date: Mon, 28 Oct 2024 15:12:02 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 07/10] x86/virt/tdx: Trim away tail null CMRs
Message-ID: <67200c325bebc_bc69d29459@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <03e8e509f8a6c298807af771ebf1a37a82660565.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03e8e509f8a6c298807af771ebf1a37a82660565.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0196.namprd04.prod.outlook.com
 (2603:10b6:303:86::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB6844:EE_
X-MS-Office365-Filtering-Correlation-Id: ae416ac1-6a6f-444f-b941-08dcf79d8e72
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vyQ0f2ezzol0vjrPR25ckzhwX4guZDTbAyJbv9OOdqzjKyfaMAqMJ9Gh3Ozn?=
 =?us-ascii?Q?MHkaap949ypQe2A9cbxXFdGYtiDD+ujnnWysYl/n6A+DKK+sCLWvqo99CWoc?=
 =?us-ascii?Q?CKEE0vZjfyhPrY615aBdjNWLHJnSRyYXbGREonwS0BTrukAuZp2ziMEL9I3d?=
 =?us-ascii?Q?kx+O/QAj9t0bi4KviGTzmM56cNBfgamJxiLCHeh//keJR02GmD1c17ElK++i?=
 =?us-ascii?Q?mtTHUBKI0H3fMgGnfElDkW2B13HdzM+sSEndN6coPRvILS9olBLjD77ZOHza?=
 =?us-ascii?Q?9OhrHnolBZ3cJcUinnKEXQ7vICXTJJxg7NzzIyglE9uW9dLiE4kqv654jyr2?=
 =?us-ascii?Q?KCprD32X4ZcOElFGnvg/UXzWa8hCpmLjlA4hvLup0VACno6MvsKGeeuscnRU?=
 =?us-ascii?Q?Rv2RH3XJHihoi4DVM0bnfVrmfAvE5uamQxpRqDCce+z201bcofEQnIypIc6s?=
 =?us-ascii?Q?xu8IvB8zOZSNcHH/fQPZFFjCxKeimHkdRKD9Gpif3+fepPKk0e1bVLs2wyI+?=
 =?us-ascii?Q?t8dAdxo8Z5rubB/GLb/pi2W+UW4HEbHdl02430iZg4Sg3rDeRlcN1eKCHKD3?=
 =?us-ascii?Q?+fJOovfqm/PVYVjz9LMPowGm4xTgFohCO2qQ8j4eRlX7mZcaN9ejRwaHNLzd?=
 =?us-ascii?Q?t1D+pLuT7Gyqzqri5pUFdL78fe1Mwcps/Odxz7PdZ0EBH+rq/JZt5yr2tr3c?=
 =?us-ascii?Q?5so9lX1L1e1W8hFVn33yo4rNUsSRKviYWKgsFTOAAEAXsW9MPBplhhmmRGPf?=
 =?us-ascii?Q?PMxnQKfBuhQ8XBrzOA/M6ZORmolcErRcC7kW+QJjQ3AlGyVu5/j+bc5ywMHL?=
 =?us-ascii?Q?9mwnb4jUYhzy2Y/MEYe5KH62+wTMlAcOBw/I7pWr0ML6auZkHxdbjRe8s+ae?=
 =?us-ascii?Q?PBAMf2N0q3dlzdKA9zgHk8uigACRSRDrPqfg1CZScHZxkqB6ZYxj1RJTXHG9?=
 =?us-ascii?Q?uK+GecsRkpnMw0BtOycc2d76RoM0Cigtjm97XYB3X+wkO0BIB61t+sp58uw7?=
 =?us-ascii?Q?OVPwXjvMbbTULWfzuvwvbbXvqUH/tAjLxJbTwL1DtevSbWuLhXULlN3yH/rx?=
 =?us-ascii?Q?lUSTpKUkzb/Mruwx4qCXj/InLBxXWDk0+Kh5XmhY8nISQjsQhzLFwT+8EkUk?=
 =?us-ascii?Q?ukXZqi64TF6ieqQ+gtOlHRjFzgn1Rqt1t0hjIqrTa3ADHGQjPIvmbBxvYsl/?=
 =?us-ascii?Q?dMy6zcXD5n8sS7CORXAKJkitiEk3JZQPKrvL2lomBBxjDDfwe2TmXdMglwvr?=
 =?us-ascii?Q?s9g1+cJrYmqXXkqen48z/ufWO/lTx4ewlRdJonKlQQsaNmX62jpBUMX+7KBG?=
 =?us-ascii?Q?Ks2xkBGlh5hgSsGBxIx/wDh6AqW4MBcxGNmtuXEZPIe3duRWeWNEkWCXY1Vk?=
 =?us-ascii?Q?bKhlJfFDOZHC1eVc9wfwmjxZZh7b?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DFcCeg4xL0Mo1FCd7zX3JnuHuKNLKM0LxZyDk6igtvxf44bxMFOPmlB08bp7?=
 =?us-ascii?Q?41H35v9umCQ0CkBxLkx+PwaSJnWUqAZnIzfuF0F0zzKVxotknblC7F9lPoWn?=
 =?us-ascii?Q?8dp8INalFFwL6Phm5gCXVDMXvbp5q5h68LW3yvwsVjGUDs0Wes1Uwi15onRs?=
 =?us-ascii?Q?GDjMyChvEVnva1kLbRoMKoW1hWzW9ri9dBnxmqA5l3tC7A7RNdgXgWnyt5Am?=
 =?us-ascii?Q?OxCJ59H7EfTNpLI14Zk5IrEfebNvsNWENvLiQ/3DPLi6hFIKnicrq7wJfowp?=
 =?us-ascii?Q?PKCuEifFwXpofjx6x1NX/XN9jFCvqRAKQUQKAQoinw9p6xsuAJMNZre69Zy7?=
 =?us-ascii?Q?sEn7XrZI9C+tc6+jyg51UPaa8BrLEfRG4jSH1JeqynOk09lyekCgVauzW4pQ?=
 =?us-ascii?Q?IC00QgT+nN2pa3QVPYtDRsUM15Fq+1MuSpTpnvhWDxRCB0p9JmIQBk2Cup+3?=
 =?us-ascii?Q?Agre3XWtoCKmqEnAY/c/CTZ+ca2l7cFuRfG8KrAZ542DQx96z2+vdg1HDePk?=
 =?us-ascii?Q?9Q5Opbd8VrG9owJjo1V704ZBKkzCyWjk3w5F4L3vKuN16w7MsBQPfTFtLyOe?=
 =?us-ascii?Q?lLJqvirU8Oyvf2dxyrKHn1rO965W2dnIIcPVRFHF2dCMTdr8hwFSit4Cs9nL?=
 =?us-ascii?Q?lY53u2qQbrL0SifFB7V/1wHpZxmPjIeN0JJULCYUBShQS85YIcXEI3SJrDzu?=
 =?us-ascii?Q?ULuI4suqekpl63Va89aWlqJ57q7wdobL/ZedyVqOEV418dUtbR44osy+6s0x?=
 =?us-ascii?Q?sFDfwUt1MqlMu90OuxOMHQ9AHyUMlxwKcZfcqHef3nlV5gNFBLQeqfi8YVVp?=
 =?us-ascii?Q?RRKtTMDTuXS+ppUPCQ6UqRKqfxEh3UmNxy52nxzKDMB60MMUi/g9qUaOMFwT?=
 =?us-ascii?Q?mDQbl119jDUtXx9e/TE0wctZN0zx+KnsCBkfDIng67jANALQEAz05/K7NuZD?=
 =?us-ascii?Q?tKD8eAXH7qmi7fEilYLlxw5flnxKBGRzMrTn4xL5drMbg7IqOwHjJAh7T9fb?=
 =?us-ascii?Q?c1vftk2OJg2/8E5UONMLx9YqsXxZxUs50if9Jcj1LnTjN7s/HcBuPnBAAOuH?=
 =?us-ascii?Q?S244GwSNO5MACwRYwK6inbOETm6FZxGOiXGebN2L8xWDe36Sa/3468FCcsVU?=
 =?us-ascii?Q?izbp8d/TNzvD3J9CYQrC52UhxROFb0lHPGv6W4a7U8kNZpwCU4HzwaAvg5qD?=
 =?us-ascii?Q?H6c62DzXwiOSoMf8wKYgqPvIuuOMNWoGCCJU+XO9WjGyP0FPAvyzcWovYqvp?=
 =?us-ascii?Q?mj4XxRwkU3qrnrSPw2suTUaBMdtpdjLr8MyAPvr3EJcH6ooOLVPU323UYmyv?=
 =?us-ascii?Q?CcROzm8QocilRLOkN7bF1jvRdtm7jcPMIQjjdiLJNgpd4VK6Oyiip9jUd/tw?=
 =?us-ascii?Q?C3SRilfKl1laFD9BxW99kPS+MgewkE/fEVDKr6fm1krjXe6RORTAr+SOkfgP?=
 =?us-ascii?Q?O/ItrPR4LSIXQVtVHUdkC5uUNtUY27tlnKj+nV70NYJpFu52Mu098e+Psk2H?=
 =?us-ascii?Q?nZGUwqWrZ6WGACZb32hoxa9BvlQTK5ooeAoWcP0ZeaGGPARzWy6Cee1pWvWa?=
 =?us-ascii?Q?CQiQkAqpcWlOxu7XUtpBkVaV6i0O4pvCpDCySkBEUIRvSB4Hixx9Ni+qMC1F?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae416ac1-6a6f-444f-b941-08dcf79d8e72
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:12:05.3214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95zCwtvZwWIDbZ950F3t52lu361kgmhnQu/WnSI+sld9dx751/ecdF9W5zh0Hmojxp7bo3Z1TZegg5WO7Q14/GJHzjg8LWT7XOUw27YxFVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6844
X-OriginatorOrg: intel.com

Kai Huang wrote:
> TDX architecturally supports up to 32 CMRs.  The global metadata field
> "NUM_CMRS" reports the number of CMR entries that can be read by the
> kernel.  However, that field may just report the maximum number of CMRs
> albeit the actual number of CMRs is smaller, in which case there are
> tail null CMRs (size is 0).
> 
> Trim away those null CMRs, and print valid CMRs since they are useful
> at least to developers.
> 
> More information about CMR can be found at "Intel TDX ISA Background:
> Convertible Memory Ranges (CMRs)" in TDX 1.5 base spec [1], and
> "CMR_INFO" in TDX 1.5 ABI spec [2].
> 
> Now get_tdx_sys_info() just reads kernel-needed global metadata to
> kernel structure, and it is auto-generated.  Add a wrapper function
> init_tdx_sys_info() to invoke get_tdx_sys_info() and provide room to do
> additional things like dealing with CMRs.
> 
> Link: https://cdrdv2.intel.com/v1/dl/getContent/733575 [1]
> Link: https://cdrdv2.intel.com/v1/dl/getContent/733579 [2]
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

