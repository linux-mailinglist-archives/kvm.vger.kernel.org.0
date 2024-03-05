Return-Path: <kvm+bounces-10868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B812387156D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC0D81C21B97
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 05:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9307A12E;
	Tue,  5 Mar 2024 05:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eOfxYNI+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E904CB23;
	Tue,  5 Mar 2024 05:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709617888; cv=fail; b=kAKOYHJFoiFcE5geOd+OaoefwKKeYd86OXhTtxgdeEkmlraj/uIYEmyv2Q+hkW/Zp3MAgjzF9wMYLIllNttC56j8RZrSIZ2g8urvm0vj3ux+wLy7biYnyIp7NMQifkj1qYf2SaWo5zADRmGmLZfjplkLNZ9cEDbatsuiJ5wOQ8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709617888; c=relaxed/simple;
	bh=CLhQ/ye0wU/3Sc4lik+7cgTRgEzinXv3oVggeQGLXVg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nqxKXh6l0PRf6wux4OIYxNfattdOiiw9RTx9hbY8QQH4ckNUrtc20q1dYxNFt0tYfznRsZ05x/Pr99wFFuNwqbsZ5ipvhVFqFI7hUrwatQ93ttwGNcD50L2PsHKYYvv90MvFDkjN5TfYLIkfNlDT0ye/Z+Nns3waIoF2249aIGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eOfxYNI+; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709617886; x=1741153886;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CLhQ/ye0wU/3Sc4lik+7cgTRgEzinXv3oVggeQGLXVg=;
  b=eOfxYNI+2uFB3oZ9N5UuCqcEoLK3kcrX3YD7OLxuD4TprBNcsa4kbHMZ
   eukG4ENZE5lu6reQTdyiuh09t6HfG677kAS8Sb+6WTaYusufIfojZ80Kq
   gcAtJE+BB6iE53F7pVjjW8BzCQhZ7oE4S0KW28rRmdXNOVOaizZyuBf/j
   5v7uywCORvQiWcEt8/2Cdu+ddL8XlgQqAjCZOMKdMAc9hED8JUzl1wCQh
   5bvXvbC6HRlDhg5krQVhRd1CcUI38xXD7vO3Rqil8RlqIc3mX3mtc8mWQ
   4R07oYvCRUvvsJHsl7sVfJlVDnvdfJhLXnnPqLoORBcVwrXSvpX7j3O/+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4273533"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4273533"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 21:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="40238263"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 21:51:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 21:51:25 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 21:51:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 21:51:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRz6kQH4YKfVFPH45PB9i44jaYxWgs1EuPQw/v0FNXRwkXJhcDQ88aUvFxyqJUji3jPfgzGTVpw6AktiebN19q4LYIhgX8+yztu4y9X0/Gdi3ANsMMgKRiw+fpdZW4CYrUEPRxcGFhqcFjXSjTFCpE3vYn/cwmpaxnhc/TqmvzL7aFJomxcU2hIFS4PB8hRB+YaTswQGMXheCCSsHtyuUbUcP1W/lfebyFJ25ewdZTxPKUeEq2fGNC3EdNry4UgeSDAv78zxU7MWNh6KJEYDUxPQWZDYffUMgggkNZK07PZ3JpdO8LlHw2XeDQUFDXHnGgKa87ehbnmNgDtVmm3NxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eunoaoUP50zk2gwH1qMA5n1mtXn8xEN8wOTAtvGQT3k=;
 b=EkrbO69Pkb8Xw0or4pSAQRwHKmsnROLUPOqU3X5ikH7C6smoYFCY3mKsQ/n+U/7xq/3Xd71qefeldoB0PK6HPJElbGp9S9gEbFErJBPOeWk6lxwD0keQAlipIYa+eJ3vMNuearfHJiKs4qa+cFyj1vUf63B+ANPBI2N0CEyqqp7f1kOeK6lNeMVxqU4IN7cso7kqRFXxQWoGDl7u7CD4A2yUGNTPgAb2Hh8jVKzDeSz0shv7oaTIjZ/n0dQPnQwP5QgksUMz7TiRMjxjCnr1mwZlWzJOj2WYkCc02aPO8qV/VjMf7ljap2so8HKcVA83aOP6FrzY9sNI6kXkpzKRDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6304.namprd11.prod.outlook.com (2603:10b6:208:3c0::7)
 by DS0PR11MB7287.namprd11.prod.outlook.com (2603:10b6:8:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Tue, 5 Mar
 2024 05:51:20 +0000
Received: from MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::4d4c:6d3e:4780:f643]) by MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::4d4c:6d3e:4780:f643%5]) with mapi id 15.20.7362.019; Tue, 5 Mar 2024
 05:51:16 +0000
Date: Tue, 5 Mar 2024 13:37:14 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: kernel test robot <yujie.liu@intel.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <linux-kernel@vger.kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <ying.huang@intel.com>,
	<fengwei.yin@intel.com>
Subject: Re: [linus:master] [x86/bugs] 6613d82e61:
 stress-ng.mutex.ops_per_sec -7.9% regression
Message-ID: <ZeavimfXlL4p1L85@feng-clx.sh.intel.com>
References: <202403041300.a7fb1462-yujie.liu@intel.com>
 <a1a2da34-af20-471d-a637-ddd749ce809a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a1a2da34-af20-471d-a637-ddd749ce809a@intel.com>
X-ClientProxiedBy: SI2P153CA0016.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::17) To MN0PR11MB6304.namprd11.prod.outlook.com
 (2603:10b6:208:3c0::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6304:EE_|DS0PR11MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d9c4c5f-983d-4368-15e2-08dc3cd845ef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +QrgUpp1Ah0YfnIwjzretbNAtb1PDo7Yqp5nwtL8Xp6dW+OkBAsUeN3EX2Wuq2UhuqKgvJXgHnEl4Q8rc5eIoRE9vlACdtUxkaFvRFISw6IyBmGHQFDXoz3Xfu+WGVuPcKzgGkUaERRkqT/TvBmNIo8kKqIhjIxN/rG+NPY4snPumnYKrSwIgF/eByvWNsdOLKihGBq80P2aeLGi8iNA0l5TZKhNFQq5BQpQTPkxcZzHS8iFIKEmJRbU/Rk11xZyMMb71WOgQ2wa5+baWT1HQWBpYUHQll+duoFOyjOPfolubG4LMaq/lyF0qJIqLmfXyroRB2P6aT0g/OS9WWSGGJ29I3ia35yGtaJCkNfgUmfwxbC/2TKS+D3mbGRZ2bdvspYv8W+krzdJx3KKoz/hkCo1UQkriVIqyJ9ju8pmzXv8lEEsP7dO0W7uT73pA7aLSo4Ms0Ns9EdVQ2tM5J+ffP8K3yzxRd6/QtXSdCLYxq4BMP4paMsbZPTfnFda6q3PiPhSKmu0W9XxLZ8bz6IPFFqRAwBDsHvo10TX1cDluGqKVbya6u7kJVwjtF8UtKlluj5pcYlBzB3DsUWzNtV7a6o5CxE7lfia2Y1e6bi/lsuPHIp3ofPSIS/sVVUH2hFR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6304.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oDVdBQ8ohHS9Xzdtt1L/Fv/5YPVv31wIJiaZYuuNMa4MsayJmYxNHG5i0J8P?=
 =?us-ascii?Q?2eN/8ubVwM2J45Ad02eOBjOELum+dFYXppWPJIn9hkbFh9zDDJ5041tFeSq1?=
 =?us-ascii?Q?9Ot6CA8DdrPqO0PZ1bi+LyEa5ogpEhFPgrGVFyLerXCRuDES1tQt1Fs7UN4L?=
 =?us-ascii?Q?MKffcO1YrUHUcnSxuRpNGSqCBlIm4uEQWteT3eR/1DUb1icfbv66JGWa3ZmF?=
 =?us-ascii?Q?EzoQ0CUe4mN6pZxhje8JZx6BsH8Cdzb9rdStluNNESsna4zul/3b0EMaJ23O?=
 =?us-ascii?Q?zq5QhRL2sds940n2c9gcZrLMdc3tFtTHcv2mcXvKpbysgZFwuGNnxaVZmboV?=
 =?us-ascii?Q?jn1hLaGb7k8OzI1x4aBXNcAl/mxtdGbmVXZxs6cxXFt1WbtZ6UqvYzVISb44?=
 =?us-ascii?Q?L7B/pIr2fIHaEtX/fwmQEdmSIyuxfU+yyPrVFD2QfU1kVDFNh+uYk3NIWbe8?=
 =?us-ascii?Q?CrdQ66T3GCce970BPk/7ihZzzpeCRhIex9rQQUyVniOKO6+WtB1XyfyoAnay?=
 =?us-ascii?Q?B29Q3CwZ/fyV/uDrHPY9Gqd/4wX5kJ7JOjeJZVvP6g6oKapQ2yo6JlxbZhue?=
 =?us-ascii?Q?geC6CrpAJMjto8MGZBOGjA94+3sYv2eEjwUGLjm464+gjRJXaXDr74Z9cR0R?=
 =?us-ascii?Q?uSLNsadReR3d/tbPc1hX3KJFQdVhvDTEthiZKmugfMpAQz88lsYJWN8QPgH4?=
 =?us-ascii?Q?q5OV4Gmi8+Qv39d8mIgJGSiBsOLzumPB/bsymaInd2dmGpsqo7AJn9L8ciN6?=
 =?us-ascii?Q?+ZDgXcr5rMltYuQ+tKslINri0dbwGiDCFWst6sQRJKd+V7d/jZDf/dU3pasg?=
 =?us-ascii?Q?AAIfdpv9gWT4F1p5r4HTIJtZMyRX0l0lrFay/mCDfJ1beRddsZTRNgFS1qGt?=
 =?us-ascii?Q?XeUERtghlOIccDZP0qQNLELaB8Iv01g4BGjS6qtIbf7dqM3YiDBRPxK8qvpx?=
 =?us-ascii?Q?3QD4KEnH9qKPsxNkg4NF2xF7lzhZdd3zCVA+iZFZJmazctNjVsDuHHPgBAaY?=
 =?us-ascii?Q?+hoR5RbB8ELVaRWkr6CNHJGkE6NweEp1fkwcLOiykALIYzJguJxLqXcyh6Vn?=
 =?us-ascii?Q?Nbz/k6f4+H+TNZKNu3Jb1/sm++/5CYHFlKpv9oVwXqcJOm8LK+OABMSc9NLd?=
 =?us-ascii?Q?BUDxfO8hhNaSbdhy6L1vh+Vc6uA4c3y7xaDdIrxrPK3bhnz3rJcRu+i8RoLb?=
 =?us-ascii?Q?F9N8IwSUgXdIXlvKeXiOjZw/KjL0NPxTKt2R+5RFJWl2lASZc6jAcbX9xOu+?=
 =?us-ascii?Q?nZd6zptuvbaieCKGQX+pkUk2dvSHUCkRBipsBVQac5ltG7FM+GXl9LM/HB4z?=
 =?us-ascii?Q?38Q8hkfYaqpEX32onUhU5sN4LZM3QSYYu4P11CXmTkn4PY75j6/J6n0CmWM/?=
 =?us-ascii?Q?ys0rjrDv20OIxlRHiJzHPklV68tHALKX+g3wpiSoFXN3JzR4NquuOnjRWfv/?=
 =?us-ascii?Q?ZttMMJtE+qAML+egzllLmHFf05T9ogAAQXY3MEJHfl/1SK9NffHcuS51NxBw?=
 =?us-ascii?Q?3MVtaosl7aN66rU0jFNHLaEyJz4T2/0eFE7QGzR0sDRNMg1mnqi8Wbxtbt6u?=
 =?us-ascii?Q?sZ/d5/WY5E2RzorGFqFWc1Lr/0DtftK+KtIzAv7j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9c4c5f-983d-4368-15e2-08dc3cd845ef
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6304.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 05:51:16.4568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cO0SrXd9s3XNctqYc8NAHZs9bEF8KAIkxQVXFZjo2YotsyFKjhf/FD+DKNCpoMJOk6oNKPOIzlA+NMWneZrRWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7287
X-OriginatorOrg: intel.com

Hi Dave,

On Mon, Mar 04, 2024 at 09:58:53AM -0800, Dave Hansen wrote:
> On 3/3/24 21:53, kernel test robot wrote:
> > kernel test robot noticed a -7.9% regression of stress-ng.mutex.ops_per_sec on:
> > 
> > commit: 6613d82e617dd7eb8b0c40b2fe3acea655b1d611 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> This _looks_ like noise to me.
> 
> Some benchmarks went up, some went down.  The differential profile shows
> random gunk that basically amounts to "my computer is slow" because it's
> mostly things that change when the result changes, like:
> 
> >     182670            +9.0%     199032        stress-ng.mutex.nanosecs_per_mutex
> 
> Does anyone think there's something substantial to chase after here?

We further checked this, and it seems to be another case of data/text
alignment effect, that 6613d82e617d removes staic key 'mds_user_clear'
which sits in '.bss' section and change the address alignment of
following data in that section.

With below debug patch to restore the alignment, we can see the
performance is recovered:

   a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 398e7f0da8595354dc330938831 
   ---------------- --------------------------- --------------------------- 

    302318            -7.9%     278364            +0.3%     303161        stress-ng.mutex.ops_per_sec

---
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 48d049cd74e7..1876865dc954 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -111,6 +111,9 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+DEFINE_STATIC_KEY_FALSE(test_static_key);
+EXPORT_SYMBOL_GPL(test_static_key);
+
 /* Control MDS CPU buffer clear before idling (halt, mwait) */
 DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
 EXPORT_SYMBOL_GPL(mds_idle_clear);
---

There was another similar case which changed the alignment of
percpu section: 
https://lore.kernel.org/lkml/ZSeF6T0mkrH5pOgD@feng-clx/

Thanks,
Feng

