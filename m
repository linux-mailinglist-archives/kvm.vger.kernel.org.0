Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC8770D450
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 08:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbjEWGvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 02:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjEWGva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 02:51:30 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1215A118;
        Mon, 22 May 2023 23:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684824689; x=1716360689;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2p81MeHgnC73KpwYB44jqwSEDqlbR9PsAPieVlUpPOg=;
  b=Of0gLVEaoIXXnbyUU3Vw1kP14/fu4vfGqXqy+bAiuNTckOESCXrJ+nXZ
   F1loX1EEi7n17aEb9jQlxmBhnH7F1H5aGEAIhyHsNoJjga3bXQR9728UT
   7+UB54VHEDIjofszh1yOcWp96WJeXP/o3xOJDRBnWqvKToi3471fgQ0A0
   4R9KGq5tfdN7o7yGGCP1Xz5bldfMfHk95gyh3MHv2ACRuaJsGaBW48Mda
   UeiurdyCqS7WeiLuZfvHcDU9qBmuqgCdyn11oaBtih5Au9mGFOOgioFfp
   ms3NjrkufKyYOG5fKOK+8Xo2JxrK3jIFMUn7OBEswi/M8nIEyVvjfYfWr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="337740697"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="337740697"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 23:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="878087652"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="878087652"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 22 May 2023 23:49:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 23:49:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 23:48:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 23:48:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 23:46:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDYNShgcd3BxDQ3Aslm5TBfNzFrjMM+s1xwALJd7Sr4s8bIh771uVZifrWdZ14LBUORWlhMBkyhZaljLfI3M0cxfgIy6Y3luBkXAnctpDXXi/Ln8n+O0rgJxirnvxtoUxz8Dbp7S7t+CqyZukGmWOD9/fF69L5qyg66Tq2dhOIVyxUoGQzs7xHO5KaI31geIznV6JubFIYRlV9hBhzCNfQ/sKuaa/onnPaRv6oj2C4rdoECpzjeMgbx8unk3PxaD33E4HsgUWLtDI/pASBXljzow9KMagnbJaMGMmYezBc/RVqY3J9l5BUoy9GPNQYFrs462ntnjtpU9aehqNhMX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUqvU98eOE1wFVkPl+Ch6eMlBqoBayASdkCiDyZiZD0=;
 b=l+SI8wIiDn7bkpvksnhzb3fb8/AoVjOXR6dhSzZG1wTEWk/v5CDxomt9eNbHxIQJ/qU0Rz4D/Ej0NlXMzXcZjec+m7H8jiu5TPHSeloGB5QMcW5OHeFnDC7tVa6g4egeWZ6JY/ubbrUVYOVqrlEhP1o1lRZ+c+x6/6k8GYzW1RCtySzY5ILH8A9MjA0FM4SFGt60o800X/lc3GZEGpEYk1EYACJ+pbZPgL1fVScHo2QHYXb43XFPMFtxlqOHbgyr9bNFhJMe4A+CylAMB+fWg2XC2o8D5huLz/+qpO2Vx+4PLh0kUcDI791aOpNAADYxI23JKW9dVgzzJAYuAJdANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14)
 by DS7PR11MB6176.namprd11.prod.outlook.com (2603:10b6:8:98::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 06:46:36 +0000
Received: from PH7PR11MB5957.namprd11.prod.outlook.com
 ([fe80::c190:aae6:9019:1ac8]) by PH7PR11MB5957.namprd11.prod.outlook.com
 ([fe80::c190:aae6:9019:1ac8%6]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 06:46:36 +0000
Date:   Tue, 23 May 2023 14:21:30 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Message-ID: <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
X-ClientProxiedBy: SG2P153CA0004.APCP153.PROD.OUTLOOK.COM (2603:1096::14) To
 PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5957:EE_|DS7PR11MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: a532efbf-1fe2-4bb8-532e-08db5b597407
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xg8XyXggjSA+A1ap9vUQ1hnycIspwJyOdGCyzgRP+X0grPDaEnOZcvuZ5GXfK9Uq3JmvgU01suwt09/3wXpocKgO+8OxZIynogojZW4py9SC/DeFczN7dTk75uHn+VaVjwjyL8k/qwXxN9+ILunDnaXzU2u2CaUUEBjwtIV/U/kHlBZ/38nosBfX0L/aJfDLwowvcj6rh6NZ6BcMOWwYdfA5u9BFDmuguJq14nmqY0Mb4uowkHJnxR6ccHmD+tiSqfc0OvEHVd+uonIkSvLfknCFN7cseE9JCjKiVZ1VZjQEk10PZE7nhUIEAfN/iRBa2fv5TQX/6Ae77Ckck5HxElPSmVj5W7jtTuB21KSuwFD1b/2anKTXK0AMgDE5BLaQjHX1Sc7gstdj4MgGoOvaG5AHFjruurpUbhQbIeQAF4rpRnRNU0CR7r2/XlKEQ5POQCw4rOWun77k5i5R6jrja2CqPoeXjUYqV3c88xVdrGx4rwzHb84SQR28OeLp0qJDeONVzr8+vT0R5kdkR/Yc/wLoi6USVEvx4mn3n6CQk4TnlMXPQbGX1Lo1DC+pDXj3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5957.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199021)(66946007)(66556008)(6916009)(66476007)(478600001)(41300700001)(6486002)(6666004)(316002)(5660300002)(86362001)(8936002)(4326008)(8676002)(38100700002)(53546011)(3450700001)(82960400001)(186003)(6506007)(26005)(2906002)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yt8RRdnuWzdQaqifk4avN7/4Uk1zUvMzH3ooNfwLJdrGXX22p9j5prkW+GtW?=
 =?us-ascii?Q?Z8yDiEKCGjJzFOYItTF2tjNIRE6ZHxD/lPsmsSCQspNvg1trpVYK7XpMv+EJ?=
 =?us-ascii?Q?g5CGqlKAumflKl78KeDnDsMTqNKCg0ylVzygPrv0FTu7fK+xa6rqpLEqhE1/?=
 =?us-ascii?Q?B+TJB8jExYO5SMlJx1nMohagCqkJCZUHp2/JmfTpS5Xof5dOC5+T6HN+k6xr?=
 =?us-ascii?Q?954MaXR46pPmxWz6GXi4bNobredvu3IB24HibW0Z2luzKlqb5akjGlOnJQo0?=
 =?us-ascii?Q?XIQcok/NqVT3rGqczCr2j6/tETfnOF452XZR5mzo+BdyMHnVeZWsmlXk4KIE?=
 =?us-ascii?Q?1Z1v7Rma/KjA3gQR2b1EuuUrFRdTRyJxFUy4ofdkBMyl6MhZkF54IB6TdQGD?=
 =?us-ascii?Q?iydNmAR9AKskmbMnrMFEL4tgjedoODseER/a1zwN7xE+tQPlRK/l6K9eiQjl?=
 =?us-ascii?Q?kCcKzshB2PfbRkdYrl9Sucb448hvqJApx70HPYb2oT3nF/HqHsBGZb/IXDMf?=
 =?us-ascii?Q?6rRfY4QNWTISYE/nbMk3ms/PL9cnoKob5SiubZ5um+UFSouexLHJ9gAnKLVq?=
 =?us-ascii?Q?JNbk4qxY2anWA7QViBBNYVuRXlHWO2zji629BKBZB3C6hcXJiLd22uvPo2mO?=
 =?us-ascii?Q?8SIe0uog92s2uTLemqQFBOR1FGlhzSII+GyAfmzBNouUPWJ/P1dsDXsZRzij?=
 =?us-ascii?Q?fEszJNedKOWTSNqqg46KdG5JLsH4/pSlD6/d0Y84Cao/aHfJthZQbtKKP8fz?=
 =?us-ascii?Q?gRNJRevi46obdvMLAk6IJky9dGVo2yDkzwmaTxfg1LzQ31H/iwYafBuyTDfZ?=
 =?us-ascii?Q?jDcC3oAb3C54CFYv0PUPLnEC9d3c3quuRm1ei7G1bP9hr+YD23zKt8SOhTKE?=
 =?us-ascii?Q?fAMPK//sHKMBTWTQpSGGV28MlCCniaXIARYipVyCqtFPdFLyBCx6oHpsCaN7?=
 =?us-ascii?Q?0acIYRt0mMeLuS/yQChyM3Cy3AdPG1ppx/2kuvfBl1qHItKgywG3Ioo7gsbd?=
 =?us-ascii?Q?MxyhAdk0pf5Pa55qK4TmNIfTFFIbpx5x65iPcw7MKVdVNfv2zfXQfud7PIAI?=
 =?us-ascii?Q?ejGhdjjyg5FzhNX+pCZn0qpdzgnydvZN+WjKT3fjloAqAzTQcCHi1EQUFpEW?=
 =?us-ascii?Q?Yj7Q5m3cdEWQGpcI85+MM69cSr5qIMXR0ueQ2jc/jySnjJWvRsTHkJZo8ATL?=
 =?us-ascii?Q?1xYqny5Zf1RdyW6M0ijnumqh82w0gSXRHVV0fV9j9PWva/BN9ZPngVNnOz06?=
 =?us-ascii?Q?ChWof1nb70ic3Ad+rntYof1ML4VvS6CV1wdqF+9f1v3mz31Zv/dyqEI12Q+p?=
 =?us-ascii?Q?73/yckNkDfo/zP/tUpzBlq31OtmyCpmVZHlzU1yooFZuJqzRjpYx6NMRFeDD?=
 =?us-ascii?Q?wPc2CkS8ZKrC/DaJp/wx6HrSqVK3eTzvxYStw9e3MXYtynW6d2a8k3I8xsQ3?=
 =?us-ascii?Q?SxcagLKZPw/b9GTs6EVEdElp5OnTJOMrUEGcMxidmZaYC+AyKAQzDZ/6HMje?=
 =?us-ascii?Q?CiF4/S1bMnog0EryLUjPP6P7N0x28iJQgLZwhPBLKH51Bh7DZ0rlPuW1K78o?=
 =?us-ascii?Q?+h0bwKC8Q3kk0RGLs4RymEKWr0KmwZcqk1RrNsFg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a532efbf-1fe2-4bb8-532e-08db5b597407
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5957.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 06:46:36.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POhmb83XTbj+KigIg0GqiRugJ+QrlZNX6v7RMFiboiQvjBAoKxYAbmr2ZVs83bJ6f7uSskEM48qRkdeQaJjTrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6176
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 21, 2023 at 11:44:36AM +0800, Robert Hoo wrote:
> On 5/9/2023 9:53 PM, Yan Zhao wrote:
> > Keep a per-VM MTRR state and point it to the MTRR state of vCPU 0.
> > 
> > This is a preparation patch for KVM to reference a per-VM guest MTRR
> > to decide memory type of EPT leaf entries when noncoherent DMA is present.
> > 
> > Though each vCPU has its own MTRR state, MTRR states should be
> > consistent across each VM, which is demanded as in Intel's SDM
> > "In a multiprocessor system using a processor in the P6 family or a more
> > recent family, each processor MUST use the identical MTRR memory map so
> > that software will have a consistent view of memory."
> > 
> > Therefore, when memory type of EPT leaf entry needs to honor guest MTRR,
> > a per-VM version of guest MTRR can be referenced.
> > 
> > Each vCPU still has its own MTRR state field to keep guest rdmsr()
> > returning the right value when there's lag of MTRR update for each vCPU.
> > 
> Can we get rid of per-vCPU MTRR state copies and just have this per-VM state
> only? therefore can simplify implementation and avoid hazard of
> inconsistency among per-VPU MTRR states.
> 
> I see in SDM, it notes:
> "In multiple processor systems, the operating system must maintain MTRR
> consistency between all the processors in the system (that is, all
> processors must use the same MTRR values). The P6 and more recent processor
> families provide no hardware support for maintaining this consistency."
> 
> leaving each vCPU's MTRR is just to fully mimic HW?
>
Yes, leaving each vCPU's MTRR to mimic HW.

As also suggested in SDM, the guest OS manipulates MTRRs in this way:

for each online CPUs {
	disable MTRR
	update fixed/var MTRR ranges
	enable MTRR
}
Guest OS needs to access memory only after this full pattern.

So, I think there should not have "hazard of inconsistency among per-VPU MTRR
states".

I want to have per-VM MTRR state is because I want to reduce unnessary EPT
zap, which costs quite a lot cpu cycles even when the EPT is empty.

In this patch, per-VM MTRR pointer is used to point to vCPU 0's MTRR state,
so that it can save some memory to keep the MTRR state.
But I found out that it would only work when vCPU 0 (boot processor) is
always online (which is not true for x86 under some configration).

I'll try to find out lowest online vCPU and keep a per-VM copy of MTRR state
in next version.

Thanks!


