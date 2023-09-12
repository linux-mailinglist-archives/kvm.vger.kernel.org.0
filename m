Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8A79C42E
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbjILDca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbjILDcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:32:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD662272D;
        Mon, 11 Sep 2023 20:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694489467; x=1726025467;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BibANY+3WW38vcaZxChx5aPMBzh0hAAlOhy5HblVAXw=;
  b=etBsWO0VK7Zl54GeVmonGxf1mEAh6wQpKZPN5ISMa+EdEAwSsWheCx/E
   L48wl9XvNw4iH7s7xwcGJB704urjDxSWqMvxO7NgJFLGPNkHvHtkd/1EL
   tp0migsQo3XeZD63YvcKjqWT+jLmOEZ4ez8OrJzmjgzLlqH/xn6D6pQEo
   fQglBnAa0prA+3NmNeAfPIEUes08i2/R68FHL6ym4bO4abuD+t3XBUBH6
   l5pVaq4oN77DL/83gZ/9Hv6nit66btFAfavHzin0jfn9750+HjzxVBf/K
   7HESvTBbVZCkvVljHMv7UQTNcTziqNt+GsOC3XQR5uHqHeJxL9SVit7na
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="357702040"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="357702040"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 20:31:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="736981567"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="736981567"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 20:31:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 20:31:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 20:31:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 20:31:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 20:31:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7/ONRVa2uCnwmsoC7rrbQrog2mlU0Z0e/IiJZezqDYJ+ZlCuk2zv6/MJmGiCcZf3Lwg2fI5Ba5HNpwWzz2aDqXtmHnVQorKbrJmwavDWUjY5WC2HbTkZo5IWDaV/cu+jkR2MUnDYpAm9nWPkGKj8/2BZ1+JDCJt3c7Dcety7UlMwlhlGEiqF4Pgd39ZgZGLvamOAtB11X9Ojpo3ZG28rHlh9xzvDFIMqdnf5XKUieMQhEFkcbuKYH8OxCP68Hvys5VqPMuiH4C2xH/1/jXiJhkeNTBLFVN+aeAUXOeDmHYtoqYFNURHozTyrcfbBZi0WoKZtSHVY+Y58ZKj/yr8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIuowMT3Iz7ml7ttuPFwgpJTiXyoSWJBdDkoV4iktE4=;
 b=Mbo8BJ9Axc2EUQSfQAXs+fDm7OHjJTgj+tj/tjkAuCtzT5rsL9RwZyxCBKkQfWPfK7P0qzmx/32qBMQ2Ypk0lumTxIx4GOgjDZ+j2XhjrN4KQJ4rqQV6dZ+Iqw5PYjcM+38uBBIPRaaYhjen0wMcyXS5hR8K74f1TcF3lZqcofZKPmWC/6nY2qVovKDBoFluhwsgmQebND2S6u6da6+aj2PAnjJPOCn4iJWAol7coPXJQgSETDsBp9nbsORLRdpq+p1+NCKZS4CE4NXtqE/lWgQpJzPnjrO55q+NbSCP/kwxVg3cVdzE8JWU5DNz6iErb0zWtaC3oZ7XYQ//9h691g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by BL1PR11MB5541.namprd11.prod.outlook.com (2603:10b6:208:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 03:31:02 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 03:31:02 +0000
Date:   Tue, 12 Sep 2023 11:30:50 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Manali Shukla <manali.shukla@amd.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>,
        <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>
Subject: Re: [PATCH 12/13] KVM: SVM: Enable IBS virtualization on non SEV-ES
 and SEV-ES guests
Message-ID: <ZP/bavxZsg7Kbv7+@chao-email>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-13-manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-13-manali.shukla@amd.com>
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|BL1PR11MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 808eddf9-1b28-48a7-6756-08dbb340b05a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kaf3IFqlKI39Dnp2H1TXMRdcMXJj4FbInLFuV+Okv1zzzJ2G8r+J1KLo92CyT30mMuFCjm9W4JT+4wLzDB1mZQ1WkOfaZWGByqLO7oZizWXnkxNoka6DQ46G5q/Hz4PcDQ3WkV0OMNvehgv3ES0iHvv90XSDhrL2E5IaBvoBsIhJTbOoGtTUzR23OEYPkSDVntJ/AyxhNS1UXvfLzzPZhKu8mZtVXzYF4K/LsVc5aV8wQJUCP9J3/gdMp4CBjQT5M12egMawwNYPc0Ndsjz6K1J922A8VS0uWf1fpNwuxfgSdgQqYG4qXZ59VYqsiyKrfCGP3TAghbPh8ZIqJXHUW2YqiURKmrN5bMeW11cARlJasZpttDoOfOrh5Joycpar7xYTulyGyrnP5+5cxomIE4fA0kNAwWsX4OwZoBC0DlO9Z3zTfZ5EM6ZtMZwu/AL0LkkOjDW7/T9AS1yAWGuHsNzyEbb8EdnTkvux8t4aZaQVeATD1VD676RD8b27Qd36d3UNYArSsOKXNUmG2l9mXiYFFOz8gQgIgfApJZ6Qv949r6irGSZXeojc2/1yccNR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(186009)(451199024)(1800799009)(41300700001)(6916009)(316002)(7416002)(26005)(44832011)(8676002)(66946007)(66556008)(4326008)(2906002)(8936002)(66476007)(5660300002)(478600001)(4744005)(6666004)(6486002)(6506007)(9686003)(6512007)(83380400001)(33716001)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LfOhkzmjFB7mAYHh4uo4wFc5f8npwh9L3JDCf1aE8FyWogzVJzYQzMGAzZrx?=
 =?us-ascii?Q?OUJUEwrt06RBPvtkrLVJUmKo3O091SL7ufYZNmqXQpeRfsW5dultY+iRbkM1?=
 =?us-ascii?Q?ke/R7gEo6BSIXppKEQtLNG/YnjSIe2By343JD6RU670zD1Cbn9FsZw1OLxHX?=
 =?us-ascii?Q?gmF3tk4TIX4m0qgta+dHtcp4enfThz2LRGQq1YkdFCSV4iL6sHBOzlUdJOVp?=
 =?us-ascii?Q?aCzq5d6++DXLxwkPy4p3B8FfSFBh9jMCztI0QQWBjVyYw9IPoevfRqclVeYf?=
 =?us-ascii?Q?xi/EijxYZT2TPNq/NyS34+OYiZhJ59LuJsaE6P7ZvokWBNk/tfO+p2k+gCyW?=
 =?us-ascii?Q?AZMH/j+DyNuIZiMRPGx2OBd8AgxM+EYUxxNVqUE/AyG2L+iXAeKHr+Vw0tIJ?=
 =?us-ascii?Q?wG2yaxMXpvFHa/OCYZwI1eZ03UJ+veMJPBkfqzAhH13OqBoRvNJLVBr90p4n?=
 =?us-ascii?Q?7uMOTB0Obt5ik8H5fxGLRgTcSIH3wYxGY5O2i4KRX7STWK4LjgCLDbLR6F3y?=
 =?us-ascii?Q?Yd4eMz9t/9qqNgjMtHh59HyUhD6LJyhAUyNUQVwAkF5FhWsC/n1spMwL1BVe?=
 =?us-ascii?Q?XTvU3D+Yp3Kdd3fl/uuHj9Fe32ujhn60VJcPXjPF6t2YYpyCein51adeO9cn?=
 =?us-ascii?Q?HIqUYMbOhYpnm7YPxgRKC+D6nvyUU+AW+0QKBJy/x3C+KfGprXNW497lKtwg?=
 =?us-ascii?Q?IxVNjulmzRZm5xxRQDNcz9/WJwmZPAkZkKBIXVUc3lCbGKzCXz2UWnKK930S?=
 =?us-ascii?Q?ArSPxivsGPrMltIDm+kA2eKHUa2k8OjuxIWhDgY85P8gdvlxe3DdI154vQIS?=
 =?us-ascii?Q?CNW8u2pTVefjhTS6Bb8vHMQCDhcOmxVpW3vVUhq9wIAN5YcSGHCeF+QPLduC?=
 =?us-ascii?Q?kqc++UrAEn9S52M/z/NHaSTdthZGH3Otf/GLcTB5poVKixpDjftJyTU5KjEg?=
 =?us-ascii?Q?AMDGDWsUgnMyTfXWPT6SXFoat1i+UoCzsEkMs1JB6W3xbfh/dhMBl3qz3Dew?=
 =?us-ascii?Q?4FYI2c+sr/lwK31OF0Yooekf/qb/ZJUVoflr4afZDzroEzUN0fXAxp4PvHqp?=
 =?us-ascii?Q?1mct3KpGVfJhHm1qOZilYKM2YM8I8NZxoSE4cqAX14PyXh0O3bdYCN7XUH0N?=
 =?us-ascii?Q?3Gz2DmjfdfmBUAlBcS18KMrNvxsfjgPNiPXNiu/NTXsMhGipK+q2DsB8GsdM?=
 =?us-ascii?Q?Bk+hON3UlxJUvqtl0b7A8kpOvr62Xdoi6b5upR1TrdrEGud4OUWLpH1XE1ve?=
 =?us-ascii?Q?NTmExoX5Rky5zZ7Qj+b2vGRg6kcb3M8YAjRwPJFnAx/1eu7bGyRrN6IvXo6/?=
 =?us-ascii?Q?6Ed9N2BCUzU+5nCnAwGTUS6AehwdekpPkHm06JwIzYGaaFCp/t9QHDGQQmSi?=
 =?us-ascii?Q?phCXRW5w7ufIHYmgCFpJCJLY4HAc4tkJpLzPh+19gGbxyosmaFpj+5p/P/yy?=
 =?us-ascii?Q?YjlPcqmlIJhdE5EjgzGbEXZlzNkcjfFeKsLh8vOtIgeYpOtSoflEk6Qgkhjd?=
 =?us-ascii?Q?3LlIaCCKuoN9VSa12F3UzJUwNVDGWWoBw9HMflILqpZ0ELPZULS3DrxRK8zf?=
 =?us-ascii?Q?Z/dZyOnBpc8YKx6BUbjnIIA3NpfX2pgFvKiTrB+X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 808eddf9-1b28-48a7-6756-08dbb340b05a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 03:31:02.2538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQV3xkE1LKWeO3mgoTKzdXyKdQG8tDMixtC7mRlJe2U2jatzqSg2a6MXwdkUkJMznTbd1l1x+Y7q8x8rDyCi3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5541
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>+static void svm_ibs_set_cpu_caps(void)
>+{
>+	kvm_cpu_cap_set(X86_FEATURE_IBS);
>+	kvm_cpu_cap_set(X86_FEATURE_EXTLVT);
>+	kvm_cpu_cap_set(X86_FEATURE_EXTAPIC);

EXTLVT is a misnomer to me. It indicates the AVIC change about handling guest's
accesses to externed LVTs rather than the presence of extended LVTs (that's what
EXTAPIC is for).

>+	kvm_cpu_cap_set(X86_FEATURE_IBS_AVAIL);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_FETCHSAM);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPSAM);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_RDWROPCNT);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPCNT);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_BRNTRGT);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPCNTEXT);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_RIPINVALIDCHK);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_OPBRNFUSE);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_FETCHCTLEXTD);
>+	kvm_cpu_cap_set(X86_FEATURE_IBS_ZEN4_EXT);

any reason for not using kvm_cpu_cap_check_and_set(), which takes
hardware capabilities into account?
