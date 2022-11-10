Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58086239D4
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiKJChP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiKJChH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:37:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA81F28704;
        Wed,  9 Nov 2022 18:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668047825; x=1699583825;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jCit/sJog1NSUlA2BYX54dyMNZVe5Y7EzsJkFZ4tXeA=;
  b=BAfy0pargPQmQ6/RqMRlxilwfI3xvm2y4JhaUZgQLxBUh+i1iEvJWRLQ
   PLrO+o1EGsl2va7jfRraOZg74cfGkVlUA5Y/0v0ahn0ANwzQ5hf5KdjZB
   l9jE5BQAm1s4by4pn2hO9Un504KqYL3mwhsgK6TMEywt0mNQkeAebNsaK
   s6iJm+l8+I2VrU6BcLmqItF7B6gkn2cVK7+qkE3SrQNFJgu2gkenI0tVJ
   dJtfB2+kc27HF+NjoHCbG5eLQbqeSnZD1Rv9zbZQVo43CVvj1PfkaR5O+
   ywEr9QYTvyXlPCHPJKQ2ubuN6KgJuh4PKXDkzw219ADJp5KGzuUfaTGsE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="294532809"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="294532809"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 18:37:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="882173454"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="882173454"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 09 Nov 2022 18:37:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:37:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:37:02 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 18:37:02 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 18:37:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4yaiIGqHHBAlwmCNuIMdE35w6D04uFHgkHDCAOieZ4NYWpXOPC+S60wan75UTCd6EvvzAB5P/9Sr4nHc6pmK8v+1gqR8MH+vZJAYgFyiPgltUXl7ySHcHMSOuHkxV7o1k+89zBuhmMx5A4A1VioVDzScSb3aon8VIkSJikwc4gU5qYEJxtIqD3FOgv02TMnn630kewR9L6rCJAGUsTt6S3+bIv8w0DeytCX0qNhk1jQFkiY2gcvwS7msvRw9HlXsRtyoE540LH3L832FRNpyimJGukmp/iZ7ZgGM4Be9dbDDDn9iZnN3C9tb5Tf1J8fO1EMVDOliAoOsZHe2kNd6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0SHig6TsCm9Suq8wXFkfay8LDgWxUbLiZgLbukCLqU=;
 b=S5CoDe5s/NmYd5n0kQo4JFve8Qd5b8EJu6L9ZuAPVyRCavlPr+kD3nlfRBM3U+r3SFrJgVsvrJWx1MYnKx8nyQlzwa5VhlCQijrFA4CuqY/2xFhCq7p4KuER++AFA/Gm6BNwxQYg+MD6V3TA3mrmIxPP8U9vyNqpYQZZGygVt8z6hUwyC3n2DCar/JkhQFWdNOytj6Aptpk6j6ToZ3ssqcDrqbSSuDU4aQN+Ni/4vq6noDU3Izu1z8kb8s/SkFBzVtKNVyLDQT6IiZQ9F+GxRFZ/HymyJ9sqYwfPzAFH/1msK0SjSSUnSXDi/h9vHKrp4l8lE7zuS/5oAJnMuHMEGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7033.namprd11.prod.outlook.com (2603:10b6:930:53::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Thu, 10 Nov 2022 02:36:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 02:36:56 +0000
Date:   Thu, 10 Nov 2022 10:14:12 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: do not prepare new memslot for KVM_MR_DELETE
Message-ID: <Y2xedK4QwJ1DsdlD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221110012204.3919-1-yan.y.zhao@intel.com>
 <Y2xZq8Xn0Bk4de+R@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2xZq8Xn0Bk4de+R@google.com>
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7033:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d094f65-1f08-4d6a-9b0c-08dac2c46f6b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: di5dKJyKQv29d5NxV3mJ8PaeCjItanyquLlT6GM8Rqfont0+t80mZ8PDJzDlzOqwZRuP2mCG7lX2paECbK51HfrRKhwXQZNR2USzza5B3vqKkorYPPa7CxoVDJNyJjJQPQcCH1lXhgUB+FAV9DjNkSRHuVa5yIJYKt9n5XI7FTrhmyo1J9wTkhDFVly0LHm41WyiuA9TJrvYmFRGtWrHRErXjIHdG5VUMK78aSNfXMZ4DcQ0Ohef6hqigZ8xqKRbJk82M9PzUeu0vWlYAb41HF9M9AXB0gHfmykKQFi10yQgHE3pDkk4fW9K0GwvTKQLv4jvSlfmT1YnGg8GmPoX2JhPxWLc/R+hxtEcFndG5MeN1B95/P2o0l/+Ac+f1m9yttXC+bJ4P8AE78GER2yoIsUR+0NEZMrutEQni6PzjPcsAPlHkzFug4SB2uWP8V0C9Xm5R9mg2H8SWoB8elaypyTR7tcN+Thy99/fio+6oDpeGYQo5RVPIuuRMu1Wl8+F2oOJnQSAnydAF5dZ5VdWWC4gh/XBC6hzYxEYzn5oSBAM47LM0yewK5z1atjTjMHbqHzxGFkRDHQdOc0nlYXWcjssTeDQSLR6EDOO5ZwxEvBIkDFzqtfRODKTvfR8YYTULB+ochnRap2tErPC8qi8yBLR5fzPAKVB2hTf57iEwlqAA7wZA7VhgWn9DymgRXzHNYvVwF9GCmy3XD6cPTqOig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(82960400001)(38100700002)(83380400001)(4326008)(66556008)(8676002)(41300700001)(316002)(66476007)(66946007)(6916009)(3450700001)(26005)(2906002)(6512007)(186003)(6666004)(478600001)(6506007)(6486002)(8936002)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vS76w2jkPrKgztzSjnRvOQOiEvakwAYlSelT54Dfzjq8rgp9DGDYca6JRpBy?=
 =?us-ascii?Q?CEz0AppNW592oKDbXpwdfphdXqafy+3R4/GLKjuC4Tndy1TaIAyMfOJlH6Zg?=
 =?us-ascii?Q?fsXpR/A1Y9bJ0DJ/OGyqeQPfRpE3XpXygEJr9xKhoIaUuYxw6u7O0icL/4Zt?=
 =?us-ascii?Q?fPLZE/1kp5coiLdM1j+N4URB0kB9QR4MUvY36zpeabW+rh1ocxwZcB3RSQrd?=
 =?us-ascii?Q?Gp6UftYxDiZNaVoy6L383IKpwqB6rTenWUCJ7W7+NQk2Pw6E9xpsQuqUK898?=
 =?us-ascii?Q?dk2l9gG1fDrAlsZrY56YSOPV4dNBXh9pvel6zcxpC3bgCgGe2qDjbrkTq1ff?=
 =?us-ascii?Q?0B/uNq+2CDo6M6d1Nebzggf1hRSxFlkH0gmLPN8Dus+bLd4gOjy1ZWfhUjY5?=
 =?us-ascii?Q?U28UjR7TYk+qlA4ezDUMPvItxQkdhCT5i3/juFluewj5bwNNTi2HgmDj4LUl?=
 =?us-ascii?Q?nZU39pqIhGnKDDpmsqTd2Z53f8wwJONuZsKH9oI4I2WCos3ahvJbsHJjHYly?=
 =?us-ascii?Q?QBecGTuG/IG3uZEb81F5k3TgVm1N6xF1BLakKFukWlUTbOMMdGpkEE8MX4ul?=
 =?us-ascii?Q?cPsm4GeIOnUQVHofGRH2LJdgkppQ/j6b7KP59ngsMZvLfv32InAcXzix/CLo?=
 =?us-ascii?Q?iSlMGZYXGpBcwUzl9csnBORwtX1eihDuV0FRN/Mfu4PaaGrLjle8QpJMkjrF?=
 =?us-ascii?Q?EVANIKZlfKdOVk7lojZDpXjXZBLHx7HkviwrCVwO3y1YHg9KedtBtZ7NnAGc?=
 =?us-ascii?Q?V00/3XilvA5OvS4Sm+WQD6F2U72ChNVVerfm7Wl3sfm39AemmzcDpcME84Ma?=
 =?us-ascii?Q?FxHeGEr3x3OqdvP38OjVze5itrIwDh1RRCmFW4wfUq2s+Urfke+GuNVl6Yqp?=
 =?us-ascii?Q?z4hEOw7UAU96TO49tTyd3pd5ieSP3hvBXfADO+fYdumVYZbceRy3O/HaFzrx?=
 =?us-ascii?Q?lNW1Ke9aM0BRfVRS5dsCmzuwsciBQBA75U6Vw6kADAH7S8sHt83481MfyhOd?=
 =?us-ascii?Q?HIXqCrMMqDxUWmAEIlfzGfpbLB3sFeZ8LU7yPl3BJZ1/s8I/CqT1sqhDCTEE?=
 =?us-ascii?Q?8YBL1d+VpAIVqhCu1jJ3hA3bxXZrR6t2IL2jmhdNtpouv+p+IDvw9LDBzcXZ?=
 =?us-ascii?Q?ojbsZW3o/x3EdF74ENyYz9BLigbsF6/uplyD9S1o03v725ECUiXq5fKgx5H7?=
 =?us-ascii?Q?ei8oCyxWenGnR1jEnT0cycnV2cPMyqbG8NwBn+n37hu7xIXN7pkt4NjBth02?=
 =?us-ascii?Q?M2j/vh5eiHkX/1qMPpcgZKzqSEyjsAkbQbi11a3oPD14hyMRjj5AxaO9IRLh?=
 =?us-ascii?Q?pa+qfxSPiAE2xfE2SRzmDBM5Zk7cKFvWlzU0zomx/kpmo5sIJEf1GJtXoYP0?=
 =?us-ascii?Q?rZpnj8sfc8hQ19Gt/X+qLeFTjnWHOOFlDvFvtRREhh2LEHT8YSh1PB/k2zly?=
 =?us-ascii?Q?OncGkqxBehwZlPzpoHGKKRHtHaFPD5T28JPQS6sydKqYT1G/YjrTkgUspaME?=
 =?us-ascii?Q?Rly15hAWOvlpoNJ0zOBKW7IBsJGySgPGKUiEIZmYZeyJzQ5zk5cPX+DH7rxd?=
 =?us-ascii?Q?drOJOH0kb4wNQw5MRYHjenZ34UrpwQ8YfVG9/qmZ4+QMnYCn0F1XRiKIR6eB?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d094f65-1f08-4d6a-9b0c-08dac2c46f6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 02:36:56.6453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKb5JfPfoB+7HMFtDGyOlMIYQ7Mt93FfeLVXm9MZFMHVWYkkJxvmCy7pomVoXgyLVRfxgF3TmmlT811+6TntPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7033
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 01:53:47AM +0000, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Yan Zhao wrote:
> > kvm_prepare_memory_region() is not useful for KVM_MR_DELETE,
> > and each kvm_arch_prepare_memory_region() does nothing more than returning
> > 0 for KVM_MR_DELETE.
> 
> This is not true, s390 has an error path that fires in the DELETE case.
> 
> 	/* When we are protected, we should not change the memory slots */
> 	if (kvm_s390_pv_get_handle(kvm))
> 		return -EINVAL;
> 
> 	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
> 		return 0;
> 
> 
> > So, just don't call into kvm_prepare_memory_region() to avoid unnecessary
> > error handling for KVM_MR_DELETE.
> 
> Even if the s390 case didn't exit, I would still prefer keeping the code as is.
> I agree that a "dummy" call is somewhat confusing, but skipping the arch call
> for one operation is equally confusing and could easily lead to future bugs,
> e.g. if the order of changes were reversed and an s390 developer wasn't aware
> that s390's arch hook would be bypassed on memslot deletion.
yes, you are right!
