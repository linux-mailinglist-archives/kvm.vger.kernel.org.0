Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050796A7AD6
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCBFgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCBFgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:36:44 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC496311DD;
        Wed,  1 Mar 2023 21:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677735399; x=1709271399;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1Kx2IrQLZr2GcP0sZ+BxonjzhupYQTQWsBebDzsfiwk=;
  b=X6RHSeGcTrh1avTdZ73puQ4UE2PtKBzKJmJOh+SxkvNhHnWBlJcQAi9N
   UK8M8UiTnZqTUcrJgY7wfxHlMO8IgFXRV6yIu5Toe162N2XJzyKg08A8+
   YbyUda129eKMYEect38tr2LaizpJ8tzi+SERR04G5EgiBcLLIpVOC9SsF
   lvL+8HObzOhMy+pXzDnhg/GOzESm8XSZB1edq59YM2UI3El9hH1u9PlEO
   TX/ZH3x4I6XqreidYYJOYe2LiruFA67zQd9iptl3lPdgINjfrm2J8HaNh
   lv7/q5Q9Rai4U13wk4KSrkQtIlkc/VW+lp2ofZFNqs1tXVzfO+I32s2kx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="399412125"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="399412125"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:36:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="677051378"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="677051378"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 01 Mar 2023 21:36:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 21:36:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 21:36:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 21:36:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 21:36:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iI3hIttlhA+3UyiOunXXoAVjNjIpYhjVG5m9A9lM/2Bt+B7ttFXf72dEtQP0fT4OcrLdjNsr/pBg4NwGysRiR3pxNn4dajZeNucGpNYADHbv2Vlb7H7Hc+8iJ9cyoRHj1LLhI0mYvNpF+hjXpeZoKlf3tVkYEGndsqjF2caj5HjRNZccwdW4/Q1BNK9SB+sh4LmO2fdz5PnBiOWXk9LytOK1x9dYztWmNINLhO7+pwUXWbbm0GhlNAyMfaRsGBWvUgnXAn4DvSVZOc/zyUqFW6nPkcvtsNPGEMfklK4ltht+hnvaVW7lARaM/zW8YWeyV4HTAQGMOp1Crx0w2KpaCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpdqxOh9i9N8PxvHKLmTayDHuFm+h4p+RhKz5IRGuBU=;
 b=oWCuKIH5ewUeMSNPj6hRKvXHuW8xOhIqkA4AEPD/X4wMI/unz/gP0xYUclWkxJmXfi0nA1Gx5TBVd8gjt/xoZKHUBADbOhRLXupeD5xBez4avVIq2xDSz3g5CxSce6wkYu05t/idHD7PyzcMuT1AtZEYtNV6dEtEpFmbmunTQMWCJnNwkRh8exrpmWsrnF5L+A2h89poEsYg7e1Oxn5iNrsXMc5HiLcOCMAW4H0/2Jad8XJpCPSv0Lamb42aPtAB20j/tqZUQtV/TtlxdYzEnBVn8hC9ooruatgpl60G+5DvAAjEnX7exEyhRQJ3FYRjW8fCr7BQOxNUvl/UUEO0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB5598.namprd11.prod.outlook.com (2603:10b6:a03:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 05:36:34 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6134.028; Thu, 2 Mar 2023
 05:36:34 +0000
Date:   Thu, 2 Mar 2023 13:36:56 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kai Huang <kai.huang@intel.com>
CC:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Message-ID: <ZAA1+EMTIkBJvdZF@gao-cwp>
References: <20230301105438.599196-1-kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230301105438.599196-1-kai.huang@intel.com>
X-ClientProxiedBy: SG2PR01CA0167.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::23) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: 57bcb25b-e7f0-45f8-281a-08db1ae01534
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 98bHMbyD485ziE2TGvRi1MH0/A3BzHu+xH9kOb2hY977EPBV94voOon8KHNFFbDazLhgD3zXFFPSN7GuAYKLbnpspbOJ+o/TWA9M1o+k4gLwP+xB+emA/zQ/0shiwyiJAA+v/0FFr55YEDpJofw5QZrRN3c6/wsA9wwlfPeZBhpksaPSj9B+sAUspE84O3mZp2i+GlzO2pZrMbLZlXMWbpUpIFDZZ7UxY7xTI4CJWX0GnMEjvQRq3Qjh/vcztUhvqUfMxqA6PWtC+kFVTCifnIzFhbJ/27GIIiZuoswttfqSMemTeAXVHMOwKE5bQZJnPQbaK28A6mcSlz+U6P+4olKkGPJnme7CPp6YW6m7afIwqV4ucOrEmpTXRtNoujvk6j+Zmx3y7JZ5qLhXNKLoYbCufE4/6vIRO9pCHwlZQAIHPJZgbBQh1q1KOi4c7ShBm4Mn7/EFkZqxUZdAYn86Z56wG9MpW2uf7A6lk/nX49ntaomDzNoFlOXtECHphXcdMsoLyLbWbaOFP2ZSyxUZJPTczI3lM0BLccAt9ucCdcsp4jmLFQExCpQOuiFDd4XDLBLt6LDOJXBuikIJ5qsJpBz+8dI8jbJdW37De2nNdbCNPl7h1PiUGjpIBr49KWDsg4tZrqtDj0FOvMxNhBEf2VURlZpx46JWm0mY9arnck9EXoqkAhuLI1e2CvQiF25f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199018)(83380400001)(6666004)(33716001)(38100700002)(6862004)(8936002)(5660300002)(478600001)(82960400001)(66946007)(86362001)(26005)(186003)(9686003)(6506007)(6512007)(6486002)(66476007)(66556008)(2906002)(44832011)(8676002)(316002)(4326008)(41300700001)(6636002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u2uld52aQ++5QrYnHiW9Ec7Coz3ApHQrAgKPCXX6lbHt29QwLGugBPkO0J5x?=
 =?us-ascii?Q?naEUFgo9FCWbNx7EyaN2trnxqxJQ9Z5lHTIaSlSOpq8FcYbADF5TJdD9JJC5?=
 =?us-ascii?Q?Cz6bl7qsQ+7ZDPH4fEA58DSrtsi9Il729104jTZs4PMlyWS27jHCy7dl4X/b?=
 =?us-ascii?Q?SZXMsjyd/jN4U67Kv7xuLBdSNJDi7UOvsTM6GTdvNVxQ0WKizw7/ZBIEXeJ0?=
 =?us-ascii?Q?J2Vl59tsfeblJgazZQS64jmnthLCsoM/oYYIHR9LvNh2zFkOZhf5I9dBZ3GZ?=
 =?us-ascii?Q?JPwwsVT6rZAaqGCOdqlPOnShLGmgFCunHoHP8hzgAHId2xDJqD5n0uMVmqCn?=
 =?us-ascii?Q?Nc4IIMq0oajCvit6xPemQx8kMNezW5L8fJt40sY+Wd/B1EjlxzkFFyT3XUIk?=
 =?us-ascii?Q?N2EKaV3rOpfmiwPzGWyV+8gBD9/ydzyn2niHrAWwnX4vaS+GmPw2wumO/2gw?=
 =?us-ascii?Q?pEzyRbZRzyaaHOSCbCLRzwok7K284ITbqIpb2SIs/9ISfi5dQ/7R2mfNIXDB?=
 =?us-ascii?Q?NfYXIq90ugfvE1V9jHGl9NXJZa279tfnTEbXtipcLI3Mada4NNLD+KlyeCti?=
 =?us-ascii?Q?EDtXKRs++ZMUTXtsmBY6awZzRRVM/R7DZgnRJAK3sI+spkOJ/c/GtkhVO8GR?=
 =?us-ascii?Q?3qLZjsYf3ZYJYQ7BksEq12ewD9EPMd0DPFSBxavKD8TitUePj3Xs4UprB/4Q?=
 =?us-ascii?Q?sygxkxDs5to6fswBc1NbskP50BCU9brJ76FdS8W9dbodDBVNzloGgN21rDDs?=
 =?us-ascii?Q?QUWX/oL6MRd6ZuSBBzqv2pVgfp2aok2eioHjcprtOXeIurErbFodmOUkUUc4?=
 =?us-ascii?Q?M1ret8xrWpES1RfG+6kWUvSvJ/cKfLZFukes5/S6KruY9bQl09O1n+PIyQRf?=
 =?us-ascii?Q?C8ImMfOMBpROcrVL47mJEHCNNP1gQ7YeVYfuw1JZQKtkNXqT2tLYaIjJmVV6?=
 =?us-ascii?Q?qMe+84Fj6oKV2hnVfUHyGPNNx7ZvjGUEnwKuSbrEmHnCCxSUkcxdvo5hAh6I?=
 =?us-ascii?Q?a44u0ywTf9yHwMub5uQX1U9/tdhO7Ssu+TqLj8bOyJpnhhf9VeorEHwXSobp?=
 =?us-ascii?Q?5fv3JN9VQMXmRLGJFt0zfB/8snRoyTubUGjpozAf8uMrlErUAMwFah2u2Fji?=
 =?us-ascii?Q?8lVVBk64oUViq5ZYeS3dFjhlM4gYlSieCmZH784ogZNNAcBtT9SQWGJktkOz?=
 =?us-ascii?Q?n1Y3uekZmp/Umhuk5wi9tEft7hO/F+yaSFoekUPHSm6xr05ar9K+jZjzPv6u?=
 =?us-ascii?Q?DXW/sLbOEBy4tUVCurFruYbJ6VTygYJfIX+KvbfXiwrt/rVD0rIuBjqHAHrX?=
 =?us-ascii?Q?58wZk3bJvPFeIgonBcFMDit2pNC9XZoByneWLd84vLKN8UOIv5ZtZE3ZT05+?=
 =?us-ascii?Q?NLbheWat4ezATLi6vHpyX2l9CV1eM9hh1Yshy79nHCnUudavMAUKUaZCx8N8?=
 =?us-ascii?Q?30Ru0hbaSI/OQo8gpMec8EcC6g4rjMj5uGNGHJxYQt76+UmeQaTNqyJNH9iB?=
 =?us-ascii?Q?xQRvstUNRryMa9c4NgmdIPDMlvLO4NbodcBaZLCWmcqGUKS8Zz9S8hTDnAJ9?=
 =?us-ascii?Q?ejjdSvDIbtHzKZyUqbhUYJ56VN4zaQl2PScEWBEb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bcb25b-e7f0-45f8-281a-08db1ae01534
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 05:36:33.5198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s00Nioi6TFz+OnkUNfxzM+OFb/tGfU9WHI453RnNJt3K/M1VsSDMI7oyXBcAcLhToU8iP9KQO4X5a1vhtX7Ydg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5598
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 11:54:38PM +1300, Kai Huang wrote:
>Make setup_vmcs_config() preemption disabled so it always performs on
>the same local cpu.
>
>During module loading time, KVM intends to call setup_vmcs_config() to
>set up the global VMCS configurations on _one_ cpu in hardware_setup(),
>and then calls setup_vmcs_config() on all other online cpus via sending

*all other* is misleading. The compatibility check is actually done on
*all* online cpus.

        for_each_online_cpu(cpu) {
                smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
                if (r < 0)
                        goto out_unwind_ops;
        }

Given this, it probably is ok to not disable preemption because all CPUs
are guaranteed to be compatible later in the flow in terms of VMCS
capabilities. But we don't want to have such a subtle dependency.

Do you see any real problem with preemption enabled?

>IPI to perform VMX compatibility check.  Further more, KVM has CPU
>hotplug callback to call setup_vmcs_config() to do compatibility check
>on the "new-online" cpu to make sure it is compatible too.
>
>setup_vmcs_config() is supposed to be done on the same cpu.  This is
>true in the compatibility check code path as setup_vmcs_config() is
>called either via IPI or in per-cpu CPU hotplug thread.  However, the
>first call from hardware_setup() isn't as it is called when preemption
>is enabled.
>
>Change the existing setup_vmcs_config() to __setup_vmcs_config() and
>call the latter directly in the compatibility check code path.  Change
>setup_vmcs_config() to call __setup_vmcs_config() with preemption
>disabled so __setup_vmcs_config() is always done on the same cpu.

Maybe you can simply disable preemption in hardware_setup() although I
don't have a strong preference.

nested_vmx_setup_ctls_msrs() also reads some MSRs and sets up part of
vmcs_conf, should it be called on the same CPU as setup_vmcs_config()?
