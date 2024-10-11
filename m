Return-Path: <kvm+bounces-28600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE4A999C25
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 07:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7915B1F23C30
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 05:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA04B1F9434;
	Fri, 11 Oct 2024 05:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HDcpykVk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F5E1F4FDC;
	Fri, 11 Oct 2024 05:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728625199; cv=fail; b=LURscSyJuweo6LS2NtTG7fl36OrbBjn8h3V75biy/t+S6DewRmXn71NHyKfTM2LROVe3bNCWrnc+dL74ah/eMGTp6c6NCBZ50jU8bEruP6phmMP+rtNeFHN6r8N9DUu4qwhN0sQ5q2TInkuIviDc3lMjaYEtWd8yHtWbl+pBkno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728625199; c=relaxed/simple;
	bh=7FRa47hsvRv1ADl3sgCQtFEtU0GvQUJ5P/zzNKZNc6g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kio+uE9JSjiP3ZwRtpHChpsYXfXSNX2C1eN7YvyLG+s62Jxdox0JlFpbdcHG/YPAmLjii+WAPMqGJ7b13O3HEt01w7kbH7m53cWEz1MRgMVPMeIEIAbvWYEwUnedpaZ4EHsu44Oogvw755XSXadZ6wlLYlPDRfU8TfpCHvITQmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HDcpykVk; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728625197; x=1760161197;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=7FRa47hsvRv1ADl3sgCQtFEtU0GvQUJ5P/zzNKZNc6g=;
  b=HDcpykVkxERnjkzl/iGBVo0okXLbfd/OyWy9ziUaSeNUbux+3sUy9fdw
   sUInEoQhfBzPKeS8Ju1gEktSsbP9Ba3R/LinXH2ZlgrpdfX/GCr0OShJg
   SoXaO5ytOsh6l4lKJBhqWEcIO8rOFD1GGxpLBtMvhpL1OljeVm8JLer8B
   GGRoAn8yIuiemxXXD6XXfNXbULeHu9na2F5LWOYRJ774prQnu0JWSyGf9
   RCeGY+gJ0fUhUdpRtyLhrCrzzR8RwEtfxjHtrcYnnlrx6fok1n2tScjaN
   XWYNMulNMh8mZkIUCqjVl6R7k1aLG1SveaHY1U00xOM+2Wa5gSEcNTHxK
   Q==;
X-CSE-ConnectionGUID: iApo3gk6SM2y5rKv6SV65Q==
X-CSE-MsgGUID: BmS63hR2RlWEzy/QgfzPlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="53417243"
X-IronPort-AV: E=Sophos;i="6.11,195,1725346800"; 
   d="scan'208";a="53417243"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 22:39:56 -0700
X-CSE-ConnectionGUID: 2r6tlcOrR9yJ2ucZu0+QlA==
X-CSE-MsgGUID: baDH3CyHRCCZvz1RLDiVsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,195,1725346800"; 
   d="scan'208";a="114264234"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 22:39:57 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 22:39:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 22:39:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 22:39:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 22:39:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ne8hQYg1K8Q2iwq9++SpSjX+BbIVRYgJ3y+6w4Rze+uj7cUl0bxv/AZUATHC04MhCGGmtcqU2R/4oSLKOkjrrmlvg4oG5s1JkL55G2bnDjG2cYQ0lBbf6zFcFwQGjjONDgUb4T68xPDYoExlBHGepz3YFR4fjkRMgCgLDGgi5sOvi44gzSHJPo/3B+1KTvuAaiWulBLGvF5sDqYZ6bu1qWtjNGdjMPQFigTPwM6k68x4DAxR/59spJT7cTPCA28lTvUYIzxPB/ELkQQ84X2r4Kjr2DlHGERFaqX7rnFjWsIhb9MogU/aritZUkFqC/YiRx0S+uRi0cjhj+UJ9YDshg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jErQbYdGEBIyY8Ri282MO36UJgNpj1L3VjIbb/WJ9nQ=;
 b=rXlY1DLNEvTl5r5NPeYIXuQ70SS5WJRkyKT5ndsJWB4kqSm9lOyp4Mu1hwTYm+tQtb42F2cNF/tYoCOEHuHp9xSQ8vekqdvrFxnlT2jld5Az86hlFlevVcUBjUpp96FaR8cNVQL3QaftmhvTRc1xVcYQlhJrr54SKbveDovGLJxFTkhex+w+UeUibYNyYAfvIIowDkevzMtdz2zo57dmqEdDa7uBI+BurijCamcwLa7f4zAQVlLBktZUkG+usAXPMK/PgkUnj04V6jIPf5mUbqYD7BEGb7mfCoyv0l5UJOBjk0kn72d11v/d5IMWjYu73M19QmPx8KSgqzfgjapQSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB7702.namprd11.prod.outlook.com (2603:10b6:a03:4e2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.16; Fri, 11 Oct 2024 05:39:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 05:39:52 +0000
Date: Fri, 11 Oct 2024 13:37:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Add lockdep assert to enforce safe
 usage of kvm_unmap_gfn_range()
Message-ID: <Zwi5ogcOiu7aG5hK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241009192345.1148353-1-seanjc@google.com>
 <20241009192345.1148353-3-seanjc@google.com>
 <Zwd75Nc8+8pIWUGm@yzhao56-desk.sh.intel.com>
 <Zwf9cSjhlp5clpTm@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zwf9cSjhlp5clpTm@google.com>
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB7702:EE_
X-MS-Office365-Filtering-Correlation-Id: bde69262-a230-46b2-9642-08dce9b72130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Fj/2q0yhPqyt+jRNI0bZMzG8oQm7TDsq5KZV8ccFHntJrZzjDWZaS0etRuVt?=
 =?us-ascii?Q?OK1Kgk9mLsQTb5wOGDE2pb0pS082LQYvVpRslKmprRwaJ2h3uDvdzyhw1FFH?=
 =?us-ascii?Q?pZ3E8kbKgQBA0V2S9qq9j+moiIgbNtiIBBcb2UsLDzpapGnqh4adkWmauXbx?=
 =?us-ascii?Q?Nj1sUA5Z082U6aL4N3giIp7fhGnm4e7dzuarUQhvpEGo8akv06T7xcehzfvc?=
 =?us-ascii?Q?gvRMnevjRDAgJQDMn7US76ZPcwZD4RZ/S7sbrlleMcicWjXkxGv9h0s3GhMF?=
 =?us-ascii?Q?DU0szYvOpxb5CSw20AF1l4bGcSHl384CthJ4G+chIEngGSPoR21TWXCRb9Iy?=
 =?us-ascii?Q?le1Y8BhGVRKzkfgFR1UWEwZzj31Nv4xXJVi27v8rGxKKyYcYmmt0TXa17ulM?=
 =?us-ascii?Q?VD89KNSqfdLaGKMp4h3jQMpS90w9nomvi8MNYQpRq21PndiEe9i959WDdOuc?=
 =?us-ascii?Q?2J7agLc13jRR4hr9JdL25Tu82Oc+NcP5f20n562zr7jly8SMjACyGHkanwu8?=
 =?us-ascii?Q?JkU/VTU+E3kkJX7Vt4xZlEBzG4OOq12M73tB4IUeDMuRx0cBhlGaZJT4LNmI?=
 =?us-ascii?Q?wiLvwGhh7kt/ajvvo+DqKVt9bP4TZyayZX9/rPuRaojn7DCJCMlAH4x70XY1?=
 =?us-ascii?Q?yzZDPoiD4FICiuusoK8CyltdcJpCqmLd5QB3ljRmbjxVwkBJKJwuePGV+0PT?=
 =?us-ascii?Q?zQNcycewIPokhecfjZI+Xl6V0cMKoMN5Hfj8rPDJSz1gGIC8orSkuDE0x37Z?=
 =?us-ascii?Q?8X4fhSrKMyoNftpP9xBZpbeQhCPw9c/x6EdoiDWefoEIm+Y6tI4JW9wgocOh?=
 =?us-ascii?Q?dj3gPx7j9Y4jL4utr1dr9FmYCQboRjTnPuiYqvFOIQHvHdzoZ0H/VaNmsnWW?=
 =?us-ascii?Q?JQtc/gS8AQvL70hMGloJhe1SkVfN55hmeUwxbt9+xzenDMVTKorPlxP+bDxq?=
 =?us-ascii?Q?uglt8K5g7kcoQaETyfBEN1xBBlbfqq2YlcJTCZsK8CcUErgo7WryabxG7I8+?=
 =?us-ascii?Q?BZKxjpRK5OPafr/naxRK/DHcJuXgZ/fgYSvoUHlZBuDsxRQhzcbfmICkXb1O?=
 =?us-ascii?Q?w/e0SBSBk6Lqm8CgExNfukXo2DjlSrGtZVcE3plfqdDMD/zAIfyr/op5puGh?=
 =?us-ascii?Q?ntEzbKU9/nPBAZo3u0cuaDUrxN/IV7Ob4qgZDkvPaXrO9/unHsXFGP/XMgZf?=
 =?us-ascii?Q?AUgsIPtbKfLxJZFMUoncxjbXM1ddE0i1vvh9ICgcbwXdU0aGx2gRMdAGsQ7H?=
 =?us-ascii?Q?TiHKWZi3ETXwCV9tsYrxThE6FO+pUIhTRI9R9n6J/A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EBxb6i48Vb5BK+qKmI8jsh11botC+5Xa3Pp45ZY5uRebYZKk1urvx3shQngx?=
 =?us-ascii?Q?/Y7vP8r5r0/DMwUWAxyqodBXvHUKY91JpcWDbXf6Rc3tRu6AnmalKZC6R3eu?=
 =?us-ascii?Q?qfqb3b/SYXEvTVM0XR0i7jGsXEip3MblaBitJcBZ5dcxqaobI04Yys3l05tx?=
 =?us-ascii?Q?bZeI2zsvQ9jmf+aZjoUnCozoh0kW4J5x+xeVyC2tTePVZhKONlniuX5PlhFW?=
 =?us-ascii?Q?rIQDaejSulebCa+GUzQBEhzatZcSPqDRAKq9y7kO/sa2t/b8Jm4mPRDc0zO6?=
 =?us-ascii?Q?MLQbIurNRArvJd4n7dWqpOiZ4jBKomrSl4mYPyHvFFKHtKwvktBR+zR4NhSG?=
 =?us-ascii?Q?1NDyjMJZ8C8HEIjakpP+Xrs1jbJ0iZ6MkKJW6Q8dlMVicegFtgrB3q4kNHeJ?=
 =?us-ascii?Q?L+l0wehzY6+512dYGoSIoNT8/74Gtj8lomHEfnLnhWW5QxCHnQE1J1cUOxNA?=
 =?us-ascii?Q?mjiiszx5FTM5eHQAlYEcaeT0ncKt32gqduzpip+QDqt71rA6o/8ENp0vFzWW?=
 =?us-ascii?Q?ZVod4aGjKerMAADs3VvrRkzsSHlYFporGnuwuUURZEm8gsNIour9t1QR//OT?=
 =?us-ascii?Q?p48VoTc2mnGDKi6gRWBWApjXoARNrXpEEmjZBsmO0kusXpn4LxPQMi1B0jQH?=
 =?us-ascii?Q?fvwcvqqVqeykQtJuGWYiH0D7V6Xs31yx+ya7O+uOvxJ1ipkLBXmsgUpgqXEz?=
 =?us-ascii?Q?JrHG84yBo4AbVQGff6uKKLm181a6bwsH4DK+Nbn299dn0UjPng0bjTGxW0qW?=
 =?us-ascii?Q?jh7vwYQb1ObvGb+cWZFh98fewN/fgAN0//MSJJqQK+iBveJzX6zhdvs/dZfF?=
 =?us-ascii?Q?HqkRwt6spDTwtG3g7iQEUM6brcUaj+IE3OZ1p+0ehHGj2IICeMMHcC05cvrb?=
 =?us-ascii?Q?OdALCsmNQ75LSIGiB+Rv3yPmXskXzDMmwp1kbhEBUZwXadKZtcg2lRv20Ttn?=
 =?us-ascii?Q?o0b0zPii46fRrIB4mWrdx03vzfUSswWsjHXUN0BuJWFAXWP15BKNJIB91ki+?=
 =?us-ascii?Q?auyEvWGVI4BlKfr+btlLlqQpHWv869XO/XCgeqsKLJA6e/ErnfGg75U0hzMb?=
 =?us-ascii?Q?YYlNpp6qzmdjSiraGf334TcYJaGo+luDcoy+MUzZR45MyuOoD2sI8W116lZq?=
 =?us-ascii?Q?tmUkBye6Wwnm1reaoBWPzY/p5c3PVnq2IFEC8pBlSKQ+QDTDFb2MQH7oo50U?=
 =?us-ascii?Q?QOayvcyqQzdbbrS7hvlvgoKV/3pQeBO0s7/BaamVmcTBc8XI1pRjVdrglJ91?=
 =?us-ascii?Q?5+Ygwp8+qA3SzcDH8iqqpfdIod1U7PfuwVnsl+M/m4jZToXZTEmaHv7k0hAY?=
 =?us-ascii?Q?KdnizWcHfpatqpA3N9uLA0Isic741G4kQ8wb3hlWNhMYA6hNJZ8DnUD0Vs24?=
 =?us-ascii?Q?E/dt3Av01X6WdpZ3Z4n+IQtszxuxo5B9Eag95Z/h0vZ5fvgLD/okHcojDObk?=
 =?us-ascii?Q?mxKEUX7CzMX4JefKxUcu7xujKTRS2+C48Tt/uP8VdAR3gXBsMdIOzAZydGJE?=
 =?us-ascii?Q?vHVoZ6YfHju+iONj+RlfPd5+ZSAmVVYD8iRvvHrLzz/0+Kzukv9JbBSfsxQR?=
 =?us-ascii?Q?58Lo1MKxBqya5IlWE3TVzdWQ/d3c0IkF2L0v8Kvu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bde69262-a230-46b2-9642-08dce9b72130
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 05:39:52.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYgq+i3z9tbMj0woadn96KP9IvxBYtM5AhaH7EYqRruRJ2IVxI59Z8gpZy9BSn2jick3we0qgpgyG/Hu84N/7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7702
X-OriginatorOrg: intel.com

On Thu, Oct 10, 2024 at 09:14:41AM -0700, Sean Christopherson wrote:
> On Thu, Oct 10, 2024, Yan Zhao wrote:
> > On Wed, Oct 09, 2024 at 12:23:44PM -0700, Sean Christopherson wrote:
> > > Add a lockdep assertion in kvm_unmap_gfn_range() to ensure that either
> > > mmu_invalidate_in_progress is elevated, or that the range is being zapped
> > > due to memslot removal (loosely detected by slots_lock being held).
> > > Zapping SPTEs without mmu_invalidate_{in_progress,seq} protection is unsafe
> > > as KVM's page fault path snapshots state before acquiring mmu_lock, and
> > > thus can create SPTEs with stale information if vCPUs aren't forced to
> > > retry faults (due to seeing an in-progress or past MMU invalidation).
> > > 
> > > Memslot removal is a special case, as the memslot is retrieved outside of
> > > mmu_invalidate_seq, i.e. doesn't use the "standard" protections, and
> > > instead relies on SRCU synchronization to ensure any in-flight page faults
> > > are fully resolved before zapping SPTEs.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 09494d01c38e..c6716fd3666f 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1556,6 +1556,16 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> > >  {
> > >  	bool flush = false;
> > >  
> > > +	/*
> > > +	 * To prevent races with vCPUs faulting in a gfn using stale data,
> > > +	 * zapping a gfn range must be protected by mmu_invalidate_in_progress
> > > +	 * (and mmu_invalidate_seq).  The only exception is memslot deletion,
> > > +	 * in which case SRCU synchronization ensures SPTEs a zapped after all
> > > +	 * vCPUs have unlocked SRCU and are guaranteed to see the invalid slot.
> > > +	 */
> > > +	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> > > +			    lockdep_is_held(&kvm->slots_lock));
> > > +
> > Is the detection of slots_lock too loose?
> 
> Yes, but I can't think of an easy way to tighten it.  My original thought was to
> require range->slot to be invalid, but KVM (correctly) passes in the old, valid
> memslot to kvm_arch_flush_shadow_memslot().
> 
> The goal with the assert is to detect as many bugs as possible, without adding
> too much complexity, and also to document the rules for using kvm_unmap_gfn_range().
> 
> Actually, we can tighten the check, by verifying that the slot being unmapped is
> valid, but that the slot that KVM sees is invalid.  I'm not sure I love it though,
> as it's absurdly specific.
Right. It doesn't reflect the wait in kvm_swap_active_memslots() for the old
slot.

  CPU 0                  CPU 1
1. fault on old begins
                       2. swap to new
		       3. zap old
4. fault on old ends

Without CPU 1 waiting for 1&4 complete between 2&3, stale data is still
possible.

So, the detection in kvm_memslot_is_being_invalidated() only indicates the
caller is from kvm_arch_flush_shadow_memslot() with current code.

Given that, how do you feel about passing in a "bool is_flush_slot" to indicate
the caller and asserting?

> (untested)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c6716fd3666f..12b87b746b59 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1552,6 +1552,17 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
>                                  start, end - 1, can_yield, true, flush);
>  }
>  
> +static kvm_memslot_is_being_invalidated(const struct kvm_memory_slot *old)
> +{
> +       const struct kvm_memory_slot *new;
> +
> +       if (old->flags & KVM_MEMSLOT_INVALID)
> +               return false;
> +
> +       new = id_to_memslot(__kvm_memslots(kvm, old->as_id), old->id);
> +       return new && new->flags & KVM_MEMSLOT_INVALID;
> +}
> +
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         bool flush = false;
> @@ -1564,7 +1575,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>          * vCPUs have unlocked SRCU and are guaranteed to see the invalid slot.
>          */
>         lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> -                           lockdep_is_held(&kvm->slots_lock));
> +                           (lockdep_is_held(&kvm->slots_lock) &&
> +                            kvm_memslot_is_being_invalidated(range->slot));
>  
>         if (kvm_memslots_have_rmaps(kvm))
>                 flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
> 
> 
> > If a caller just holds slots_lock without calling
> > "synchronize_srcu_expedited(&kvm->srcu)" as that in kvm_swap_active_memslots()
> > to ensure the old slot is retired, stale data may still be encountered. 
> > 
> > >  	if (kvm_memslots_have_rmaps(kvm))
> > >  		flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
> > >  						 range->start, range->end,
> > > -- 
> > > 2.47.0.rc1.288.g06298d1525-goog
> > > 

