Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760076BC2EC
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCPAna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPAn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:43:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B18AA568F
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678927407; x=1710463407;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Lvb71/ar2NqlUz/JiKFri0cCIh1mx25tZ+Qplsn31z8=;
  b=A7Nh8tqAc4VCmRCYLjZp6N4N8Y9nx4h/QZU8hIW+j15S44913jvBf2Rq
   VhWGUX3whB2eVBRTcqVm7DYEYrAjf3n2oGGhe2LuXt61J6Cj1g7a/ynj8
   CgqpYIy+ExFTfg+h1hyGpLDouPz4PLwvM3QrzY/8nhBbe4WPupd+ZkFgA
   OHuI2rtqls+f4SZM0Olgt9wFSwsdYA9z7oz6S+8FlpKy6qyWe2ENeBOdn
   i6N3FGgDNiuejlm5f2rLdqYwriidml+MyFko7nKRH6ALt7G6fijREo+ET
   WtIouiGRoVwoUd5htbAeIgRbLEr3GPAGDKVKmoKYeMn12mRFzZDszFZoI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="400430281"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="400430281"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 17:43:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="1009024686"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1009024686"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2023 17:43:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 17:43:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 17:43:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 17:43:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 17:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhxSqAwUmiTAaq4V5DjveyEnF3YWGfkfLNhGmxGHasJ3PBJS4IssXfeKDN2b+CR/NdSbE0x2ym33WgDXbzl3OwSbPGX2UiI53OU72mNzhf7nh1HgsLX6ZmXX7JIygQPjneQVon1r794GXdWlWJfcnE9ccIM20Nf7MllZbOmh9ndZbmRYpI2IcM/u4hBIuWwIydROJJLC9H7/3xOBm8E4Iy7Xj5p6FmODIDzeMCIszxf45xThgxyVVZ0T/jHguXMsejF77nBSYQwI5CfugzGVJT9dIGYlCE4CZ6SczDxTGTad3M3cAu0RER1S7SLTMaxBOIItsa252nnIv8CUk5gAsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yV4v633GxN9nvPrFxaVdjX8zGotyioVYimJfKa7CvKY=;
 b=cGAmVrJpV2shn4CM6FRC8VIHy3nel3Dg55WeXMXJc8RkXer9ooZ90j8LGR/vEte3tIvrSqNWM5Bq7+EMDuy2Ndu5uRmhWVnoc9JqlrBqXVQHRnIcjyHkxMFcmveVlnMlBfhe00+ujz8SMVNpDcxn/m9gAuehRa65ONmyeefl6oVYweA/MO1BRjhjGsrAovv7LOYoaS0iK9LT8A+QcQzGbMYjsaIEa6ctI5H7wjiNUUEFmOrtZD2/XsYefvvHrYMbF2JqSQ2dJXuX4omnjYm4AIlykxrJBUAWP/9KWZxTgrSUpip4eyMdUs5OoNKmT1xDC3QB9bLxzt+Qxusgd5DsPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by CH3PR11MB7177.namprd11.prod.outlook.com (2603:10b6:610:153::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 00:43:23 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::fe3a:644f:1a2d:eb62]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::fe3a:644f:1a2d:eb62%6]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 00:43:22 +0000
Date:   Thu, 16 Mar 2023 08:50:09 +0000
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Message-ID: <ZBLYQYXdGsYfY2IN@jiechen-ubuntu-dev>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com>
 <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBCC3qEPHGWnx2JO@google.com>
X-ClientProxiedBy: SG2PR03CA0107.apcprd03.prod.outlook.com
 (2603:1096:4:7c::35) To SA1PR11MB5923.namprd11.prod.outlook.com
 (2603:10b6:806:23a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB5923:EE_|CH3PR11MB7177:EE_
X-MS-Office365-Filtering-Correlation-Id: ad5f41e6-4871-4b14-f470-08db25b77210
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NxUut1AMg5nnr0X2PvkgLJ8vGUNnVNbbvfRwLh/Krm+J7bLDGrg4ljoqWWXiISHtAcarcqrkyG9UdvRZJHZz82I3vMCpzwNkb5yFvtfOzB3YIMpWuVmL4QhOqaX+XTMoe6TOq0y15n8hdFPUQZnccjNNGCabprMD3fYFV/J1G/qYQZ6p+EYudUA2a5yw45DXfD+ypqnQdKV+MjwCLFmnkIbbjYhdLbDIBqqCIAvhyOMT31uv2Hun05qbqT2HyHrX5saN+FCV1tRK/n+ssE+x/2BlJViTX7LM1wzToZPsqqRAPiUhznKHDLG+/Zo7JuGeTybhOvT1pnjVWWjaRetOnWNKaq4Ip+pWPmvQ+k5V9ZFAkNeXDkgaPGNqpNwiogESprWioUp9DrCtssTx10xNgNGQTrgAmCjm/0OpKfgxQ6WKMODfesBoH1gsVQd46EL9y6FhUIT49NlTV9uUMWbxn87r5ln6l8PdCNxUneB3gtrlZ8fFBR6J+5sDl+S07ExJqtBkj5OMlDQdDsj7wnQUHHIQftpuVi27zN2cW5nMHeuGTBNFjsCoaGJc02BIb4/kpqLRWppibPfhpv6gqC/0HydmdUeAq80/F/LELtC+Onn7uOiZqNbjHm3FlryUHzqXThfGHjHGAOB4s6/PoxSxnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199018)(38100700002)(86362001)(82960400001)(2906002)(41300700001)(8936002)(5660300002)(33716001)(4326008)(9686003)(6512007)(6506007)(26005)(186003)(6666004)(316002)(83380400001)(66946007)(66556008)(66476007)(8676002)(6916009)(6486002)(478600001)(66899018);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PuVCq24jqS3hMRv2VF6dy6i0pSl2LzP11IRuWM338WmbgUFmXCniCACNbx50?=
 =?us-ascii?Q?XmJ3M8124GN/sNtH21sTpL10+j/QFO1t0oCgWUQsd/dSoLyuMqCs+bUv89rH?=
 =?us-ascii?Q?IhiAfANhXnL1mkBS78WiOcxmmc83/hOg3UmrnOuSpItjZ/IRKsUockHbeqqC?=
 =?us-ascii?Q?yF1MjSqP0p0Ofkb14ol+dfoqxrFkguP7CgKYWMstOXYFozH1Nwj9lh6kNro2?=
 =?us-ascii?Q?xlHWv/I1UI+IVfkBfvI1CKv7d2QJ8qsVUpX4mtqoiyxvTpWMgbxENHa0faHh?=
 =?us-ascii?Q?KY5PHbmxtGU9Cj6dMf4rcBpgjvam1V91JtjvjpLZeyJmhFbIOmuqdQZ5zyWD?=
 =?us-ascii?Q?KJSJl3ywg1Gjys8+A2sti3TN3meVGK4VTceTT22zWHfm1wDkAAbHTSx5uNBT?=
 =?us-ascii?Q?5s/oQBq/1p+xBHjs9pFalSm8DriWlXQkxNFuubVvrQ68rLSWcwMybvAy8ocR?=
 =?us-ascii?Q?F1IYs97v6fCQMyc6FvRkQJ77qfFf+XI6ijfbpzoL3mya56moE0cRWFJZv6tE?=
 =?us-ascii?Q?PagMvi1kID8HefDvroyz9YN/Cj2Y/+tLerItg2986yapBHMJkeZuFXCYtgGp?=
 =?us-ascii?Q?vECuh+mVrwD7L3Xj0e/rtSK0AvMupiirzbKTmmBGRKasr6oqqzs1CtQ4mc7c?=
 =?us-ascii?Q?aXq4o380jtxXNrn9G/lj+iFQ4Wh7Y2W2or9OFRjKT63SbgWXO/UkNoO+Neie?=
 =?us-ascii?Q?Xn5NKuG7mi8gC/npHK1Loj6eCTPamd8Phd/fOkz2mMmtrEnAlSMVTS+HqKB3?=
 =?us-ascii?Q?pX521Wp8uj0Yv+DA6P9flLMW+2uv6Q7sgLibpdoc2r6VPROE2bXN3BJJKrzr?=
 =?us-ascii?Q?BAhC27bHMsg0Ivvpw9ylr3b6nYUNMbhWjWqD6jQifWFjH1Ebb2J5iDMOTXWJ?=
 =?us-ascii?Q?0MQIWE/xAJOyYHzqn2EZ4hyjNjl25m8mM61RclFwveWmd/7q+IYphUyXpWJx?=
 =?us-ascii?Q?wIuuLKAvBbYlr0vLhf6fl7PrDZZK1E3Hoz1Sw9ccsUvCdAHk4ggNupA93iUN?=
 =?us-ascii?Q?cwujN9Xxrdpq630ftFARebzirY6EPdOC8nV2l/sFDm0WArPU+kUCP1LwCFOb?=
 =?us-ascii?Q?qx9wZ9xQWgHyYkh52vkcboP8J6QT7Bp8qWGUne20iNrlX87JsGlqtMmNQ+0u?=
 =?us-ascii?Q?zKBBJ4cbFxSgEwBgfn2ckQPDTPHIml2afEEeyRttg956HMCTvuzY0Zq6F6VQ?=
 =?us-ascii?Q?ALMJ0J4VhiDihrIdHSaHFMkddCfI4uGT1fMjxo2A0Zu0eF9hz/Kt/IrpribL?=
 =?us-ascii?Q?OvyIB3ef74kx0NFoXzTTM0IZNLM9c73KauDmnURLxJjgKzx7GkjHWH4dJrCk?=
 =?us-ascii?Q?OjcEFgDu1YebvZCXVpZwwnU9ZGhN2EwBsOjC28vb0eclJKMfS5K79V9C8M4f?=
 =?us-ascii?Q?TGDeXJXX24fAoZM0fLTwaQY49kUnnu/UhdjpP3MtnG9C/9UsM10+EJuk8T7q?=
 =?us-ascii?Q?Uor1i5iCpDT6pzcG3gV4L8+ZK3p2dGp85eaMQtoBrIjjbaoLVPcsoDA6eJ9E?=
 =?us-ascii?Q?xCJJX6sdtw9eu8U43xHeOnMdcdo/V4hViCmLCR+lK+e1Fbzz1Z9LuG1rqSoN?=
 =?us-ascii?Q?mjKFTJ3ivI2FfdDnGFoqi5ftmYfUKsWtgTEx1oIUdS6jzzlO9RbXurhGQU/D?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5f41e6-4871-4b14-f470-08db25b77210
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 00:43:22.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLglvnM5f+Pk1EACZd28RhuzjhjU9MxFtA8jOeHnHCN+fZ21j80p4/KrKhbwQto21njpCgyCWG3GOuPz58gafA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7177
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
> > On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
> > 
> > > On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> > > > There are similar use cases on x86 platforms requesting protected
> > > > environment which is isolated from host OS for confidential computing.
> > > 
> > > What exactly are those use cases?  The more details you can provide, the better.
> > > E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
> > > the pKVM implementation.
> > 
> > Thanks Sean for your comments, I am very appreciated!
> > 
> > We are expected 
> 
> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
> then please work with whoever you need to in order to get permission to fully
> disclose the use case.  Because realistically, without knowing exactly what is
> in scope and why, this is going nowhere.  
> 
> > to run protected VM with general OS and may with pass-thru secure devices support.
> 
> Why?  What is the actual use case?

Sorry for the confusion, I will try my best to give a general
description of the exact use case.

The use case is for client platform with requirement for confidential
computing:

 - host VM is still working as primary OS (act like native), it will
   launch its required normal VM (e.g., a Linux or android OS)
 - protected VM (e.g,, a Linux OS) is working as a TEE, it launched by
   host VM but finally isolated to host VM and other launched VMs, and
   it may run with pass-thru secure device (e.g., finger printer, secure
   camera etc.)

The general OS support for protected VM is ideal case, I suppose that
most likely user can be convinced to restrict it as a limit one
like 64-bit OS.

> 
> > May I know your suggestion of "utilize SEAM" is to follow TDX SPEC then
> > work out a SW-TDX solution, or just do some leverage from SEAM code?
> 
> Throw away TDX and let KVM run its own code in SEAM.

May I ask what do you mean "KVM run its own code in SEAM"? The target
platform to run pKVM on x86 is not expected to support TDX. Do you mean
we should keep same interface as SEAM?


-- 

Thanks
Jason CJ Chen
