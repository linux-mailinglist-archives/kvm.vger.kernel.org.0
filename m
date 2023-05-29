Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D283D714257
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 05:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjE2DgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjE2DgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 23:36:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659CCB1;
        Sun, 28 May 2023 20:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685331367; x=1716867367;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uFE1BijfwKpcS0YoSgjnKtlL+CuDUC5Whiq0VJGgw9g=;
  b=CNJ8w8RXqROTzJ+EV+ityiRLIPje9qRbtRzRpRBp+PpRxo6zlhjFd3wI
   881GlcJSrN2XN0aFbdRGet6eELJCDy0C/mkQTrHjmG5UD6eRlKnNAaqZF
   lly99PoIQOQ/w5aSfQs9XGKdHV1Ql2Nu4rKSzh+pNSyBOxX1AeaoUK6wr
   jzJYijiutkQeWzjsX5ohaE8DEAD1XRGLYPvsm1qbspzu5K//Zf84krdta
   AFqhq7i2V+yrETmWgYDzjwstl7eaaBQdwj5cuxeMnCWTkIis8huUt74HJ
   ALqgJwbvlYCuvUqR+RTtFitLLTi1KidWDDGR7gHI+z1AHawvoaHfNe+X7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="440963494"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="440963494"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 20:36:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="656339249"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="656339249"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 28 May 2023 20:36:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 28 May 2023 20:36:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 28 May 2023 20:36:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 28 May 2023 20:36:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 28 May 2023 20:36:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7Sus/caqi0Rio+rvBirGlFtiOzVFlI4uEu0GXemYdNAMI9J5z8I3abQmP/Nl3V4Pqv8M+V46mh1huSGzdj8gUk/JbRzy1YOh9Dkgp7lMQ9JkSypiP44mwkshbICQTaQX6rXLUeKk2GM/68um1rqyItGSOnf6KAVhRC2kyydf1CAECl0Gt3HUMh/VfHtnr4pqckWfO1IbvrtJ4pGUyeXhTsOYYNjq3+CliH1HsIDq+CFUWUWVfhwis7aB3KbHkrDUM3bxS0EOCgoWv9wqvCWRyG1JX7P7enS0TjhBnCzN9AgLnoHjAAKT1+qLYhnMXXJQNSRBE/Q1k4cOy/KE7fwdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPD+5xKPHABwzfGzn1cQrOJf5nCA2fpDnFabZNw/D6I=;
 b=Q9OP0UoOaFkp4PnEwWETVG97rgeNgqzLrV99oOcJtdR1kOcNsK2p9Nhm4mlB6AN/TnFphDUHOE+vmpmVTC5x/tQ1kKIdpXSjBPNbpB/YaI/NlUX0Zglazj4y6T2SZDdudfeOrcfg1mBZJuWR3F9tKFgMyvT/9czcjs+qLCH3AsJ8UKaUe+oj29AdKUv7xZgXUbgKnOj3o/Lxh/p9gtXO8AiQpIfjmjcJyH0yLlB5b6xGrfI/C6C64KKlXnosJzoP2+90X23QVh2NvaG4lNGx0zhwdikURi8vSFuBZ5m1NC6/sPDKKA+97RXLBVVvhl+PB/ZO2KSxyjOb7IMSSmPcVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 03:36:02 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6433.020; Mon, 29 May 2023
 03:36:02 +0000
Date:   Mon, 29 May 2023 11:35:49 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Message-ID: <ZHQdlSY2tsdGyCPs@chao-email>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGZhW/x5OWPmx1qD@google.com>
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: 62388833-e0fd-4d13-3952-08db5ff5d2da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9ghAOZTrdJ74aAEMcpnDpwTu72H6KVcMsCxQUXeIcpYZwETPqQ/8V3O8F6in7yHCpjekjIjroE/wDmshymODB2n/vPGRvRb/520CB5TLo//vqfMTmK/wm+4JA6mZXWUCl0HX+n2DCTpsCin306eqNkEYt6W92X4jzmGvt2u3vZP3jK2i+FBXecOONxVyQjj3MSni0RKhySy/YcnjNdGz0Tm7GrWcKRxlMWkkGCpfkl18TOGeK9tl9uGgU1rCj130+r12b4A4SsLXkoETiUiKtix7MeCH9z9cBRO6gWlAuANMiGskhOdFSgIJOhVvalosYVmFM3TZQj6ZqUgndeEN4lPMx3b5Kanlbn/+A9fjU6rKjoXQ6cDQoV8MJG5nKZ3d7yoMKgRdBShSYfGt9S8fOlMlfkw0mZMa+HcPx4a43Z2xi18jpcg80vRqq33cJdXCh+Bg7YOE3by0G+IaDbzhGLUj5LswHSEH4A7ZNQ/cC/bxkXvtYDXNoaMtpkCGYAgoSOvuMGDrxWJfxXqAjDylnPhG1Fu4ZYVzZVEFZD397M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199021)(26005)(38100700002)(41300700001)(6666004)(966005)(6486002)(83380400001)(186003)(9686003)(6512007)(6506007)(478600001)(54906003)(6916009)(82960400001)(66476007)(66946007)(66556008)(4326008)(316002)(5660300002)(8676002)(8936002)(7416002)(44832011)(86362001)(33716001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vYLj9s76iHJK8lJ9uEAUtxKUOLvIsFq1W1rw5/fehzQw+EExcoNujuHmlW9?=
 =?us-ascii?Q?FcUoCSXGENRzDCgzOPjGZcg1dVl4zlr4qJplGWTYVl30k4KO5qW8R0BEuo0Y?=
 =?us-ascii?Q?Al+Kr/InW0ZXfQURftPW11pc44YKfirE1zv34Zr+o2AdYRxqt28ngTaRRv6j?=
 =?us-ascii?Q?BrxlMnxf2TM6CxqIdmsP4MXkqs0Xr/Mc8IKirt3m0N/mCe8xhaFkxG1xuDiZ?=
 =?us-ascii?Q?S5pgbsI9fi9s41J2+jmkrUq06+1juvfvDkj8l9yWy0Y2zuWIVcXeyzpZsgwA?=
 =?us-ascii?Q?mdKTzV5ipV4xSZvqm3RlD34L6QhLJyVvxcvDAkuhRW20cwB0x+N8l0k3yR2e?=
 =?us-ascii?Q?Ad9AOHPxpJinKpEuDP0rG1mXILqoqB+xjpXi/yGqJqWFlFSkHWX1sX91J2Rl?=
 =?us-ascii?Q?bikkStF79uAP8pgNzRLAevT60nwfS4IXUxfpg+UzXE8WRoiHrU8mMepDTHLL?=
 =?us-ascii?Q?8hSf/Vi4VU1cPDSnIBelLHTWvi5suKKebZEhk42FyHdefYWoFgmm6DT9siFJ?=
 =?us-ascii?Q?mxJ/OILph8ziqC2dvk5tPmiSzI0Oo5w/uS5cgHsaakV/19Z0tJX9dQzWXK8z?=
 =?us-ascii?Q?1qm+Wu0n3psK222Z36x82O5U/3kgTwe2CIEvUKNPoK54qnG5mXuXiP/6tvuF?=
 =?us-ascii?Q?bBFJdGnoetNZMCSJRtJicZBPkQ3ywC22ERcbEaEzYwBGQWUFmXTSgopJBxit?=
 =?us-ascii?Q?8Hd4HblQPpWD0VtNsEj6/LXdt64UikvSc4uXwzVvNuRyhJt4LPmrZj1Gw3zb?=
 =?us-ascii?Q?u4t+jzQZOgLBLuhVYLJPEh2knoO8+4s4MVCTNhm1PLu1bHX5WALay/oqLi6U?=
 =?us-ascii?Q?6Ags8vRPXCxg7ftGDlDlOMokbOqAe8OTNQ9/p5rnQv9gu1wMDN3wnW2s8n3g?=
 =?us-ascii?Q?6p/ndenrJxhJpqHT2JJyb1AFJzsHfzcQ+BO1cLVHQtXjDxmzHT5ikivypch6?=
 =?us-ascii?Q?7COV/AxDbhBhdlcmDa/zORc2Gl8Rk+hc5zQH/gpXCgvpXOT7o5qaF8bGGa3B?=
 =?us-ascii?Q?oYH3k5k+uszxZgG01kWYcdnOci433OBxsHg2HrH0wdDz8hbWJMoIzKeyxzqp?=
 =?us-ascii?Q?Gll88nnhXZNrktdTiSG58Cpqe1Fm4riwHCT9Yi/tYwe7bekq7XQZ/ilsiDWK?=
 =?us-ascii?Q?iOBqNBs8jV+DsXOTx1hyoWtQJiDkj0HZ7yzwT4DURX1h8+RGC/DdkGrn/Map?=
 =?us-ascii?Q?IKMDOKV3ZGvpeHZkWBPl3PhOd2Gg4w8YBbjhyH4pB/BDxbqUsql22Mg5u353?=
 =?us-ascii?Q?c2CO5U7UZWwZvrKpBSoqskXkmuOEI8WxhJ29fyaRwXcEhg7AD182oBVUVR+L?=
 =?us-ascii?Q?yroUUtDOhYsth4XKXikivoCZgQ5i7BokQUg0ZG29G4t1VswWecSk/41sqI50?=
 =?us-ascii?Q?Az2tB1UTGprCJrQVt4JaX1VSIoptc3edOd7J50TOdpQs65/M8rAGRdTnSSy/?=
 =?us-ascii?Q?HPlKmS3RG2GYLZZlyJlPUWrJUUSMG7YNrirFf1CjFDixfgyG0woEFL5M8MKq?=
 =?us-ascii?Q?+iio3XhvwHly+YG1BY4JTtC8K+FDEwON+h06L8ew3yIQic6JrEhX9at+FoxO?=
 =?us-ascii?Q?U2esOColkweoHgdCZzJ8NfLDL4SfXlAncUHfy5rf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62388833-e0fd-4d13-3952-08db5ff5d2da
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 03:36:02.0972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zG0uRvNae9CRHVzpB7KN/yZDBODNz8Qmm3d6K8/4/4vV8RjdR5nOTe2roLvxfLdc/6Vh9RHb1bBodrNhv4vpbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5471
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
>FWIW, this trainwreck is another reason why I'm not going to look at the proposed
>"Intel IA32_SPEC_CTRL Virtualization" crud until external forces dictate that I
>do so.  I have zero confidence that a paravirt interface defined by hardware
>vendors to fiddle with mitigations will be sane, flexible, and extensible.

Hi Sean,

Just to confirm we are on the same page:

"Intel IA32_SPEC_CTRL Virtualization" series consists of 3 parts:

1. Expose BHI_CTRL, RRSBA_CTRL to guests. They are hardware mitigations to
   disable BHI and RRSBA behaviors and can be used by both guest/host.

2. Enable IA32_SPEC_CTRL Virtualization which is a VMX feature. This is for KVM
   to effectively lock some bits of IA32_SPEC_CTRL MSR when guests are running.

3. Implement the paravirt interface (the virtual MSRs) for guests to report
   software mitigations in-use. KVM can utilize such information to enable
   hardware mitigations for guests transparently to address software mitigation
   effectiveness issues caused by CPU microarchitecture changes (RRSBA behavior,
   size of branch history table).

As per my understanding, your concerns are primarily focused on #3, the
paravirt interface, rather than the entire series. Am I correct in assuming that
you do not oppose #1 and #2?


You previously mentioned that the paravirt interface was not common [1], and
this time, you expressed an expectation for the interface to be "sane, flexible,
and extensible." To ensure clarity, I want to confirm my interpretation of
your expectations:

1. The interface should not be tied to a specific CPU vendor but instead be
   beneficial for Intel and AMD (and even ARM, and potentially others).

2. The interface should have the capability to solve other issues (e.g,
   coordinate mitigations in guest/host to address other perf/function issues),
   not limited to software mitigation effectiveness on Intel CPUs.

3. The interface should be extendable by VMMs rather than relying on hardware
   vendors rolling out new spec. This enables VMM developers to propose new
   ideas to coordinate mitigations in guest/host.

Please let me know if I missed any key points or if any of the above statements
do not align with your expectations. 

[1]: https://lore.kernel.org/all/Y6Sin1bmLN10yvMw@google.com/ 
