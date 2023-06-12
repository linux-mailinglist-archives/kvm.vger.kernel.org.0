Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B393172BACB
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 10:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjFLIfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 04:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjFLIfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 04:35:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B78DE;
        Mon, 12 Jun 2023 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686558939; x=1718094939;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bT6O2cPBKL9wWvt0ZECXZcc2XFRp90hO6lwZK983o1o=;
  b=iXaRqubKQ18NuFai6y1eiZagIPKASsM/hk0Ti3AN0ACalz0eZiAGFL3z
   iJ0TkqxkEZ+jP/Naw4Lj7/oIMBpWhBrVIBtOIXL/zFRSzSfkNeIXfmHX/
   /LhZFapHJ9M0gHTxSTMGUYY+/zFoz/xYqDwqSJI0ZZiMNEFc7KBdGpTzz
   MIqKZ4zkWKMEtFZi9s5lMe0UkPC+UnGXsev5sXHMLbrpdZOa5tgICti3D
   fWEQVQXoPZvynM3ENQsDhMoK6Ihz8EinRV50RxxkV6iVGKbbV+02jDEjP
   nRkpP4r0vmqbYpLQYMp1uUl7TVSsXplpM+gk+ZOLfD+Lx3cfawxMl74NQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="355477104"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="355477104"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 01:35:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="661504969"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="661504969"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 12 Jun 2023 01:35:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 01:35:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 01:35:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 01:35:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 01:35:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZmfNhN+VT7SLTHjFeZ+b4+2N2+eNJO6JkLHGT80jRemWCo0TY45IMxRaYXKzbjc/LYWFm3Nfca8jNmso0cW61nHqsHciUJyLZWDWb1HznPFazBImOfrftiZYckp12vxb6/hfuhEKc2mLjHxC94fBkzYF+C28vHHezl5A64idRpQN086ky1FZBuSZ66yPBo1X6AYkT16WFq4IT/um/LIk/DJtoceAzwJk8UweJ/a8ckDpeFc9XAL78GH6yRwIFlwg7GXB3qzZVtlIqG8juaPF0r0aPW03nU8/TRCrUnfmbLIV57fIV+HhObFW5ZpZSilubp3Z1KrVTcNM4Y6jpIwLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkVYROVDuWUoaBv4MGqQ/kqsCIufwnqiKyOpe0kAo0E=;
 b=HtTJPSJP8a1MTbYtJpN5200gWm6BW3ITZUtnRZdvrK7muDEcNy4hCzmcbFKhPkyNTI8qNRNOEHn7X+4XmjCyvoN+1u4qrWYszL/5FkcEHdzNuEUfK2GygMSh7ipF/MEXmjhar054QBUpqc0Nt6M6xbS8ZX2arqiuFfft0Y3WKU+kwtW0152m+h4kJ/hUDkbUVhMr/FDwAIa2+YXlOQIFFPMSOhLTp8PKzoQeRmEnZOWkNmKSgxuKszOVZfJ/WUt6ymrsznvyrflVhpddH37YxA2BXlUI8t+idj84rP3bBWeGVjWPIUl4356mco6G3roWr0avEqISm5EUbjdB5OsapQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS7PR11MB6224.namprd11.prod.outlook.com (2603:10b6:8:97::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Mon, 12 Jun 2023 08:35:06 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Mon, 12 Jun 2023
 08:35:06 +0000
Date:   Mon, 12 Jun 2023 16:34:56 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES
Message-ID: <ZIbYsBv43EcwLavy@chao-email>
References: <20230607004311.1420507-1-seanjc@google.com>
 <20230607004311.1420507-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607004311.1420507-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS7PR11MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: 57046e16-b2b6-45da-02df-08db6b1fec65
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WT3x7ATkLLY4q1lekFrKI+C8vi//CdrbGROCpM1lNslGPIQFz8Pf8b4aY4p4fMJP0RVVEVSYYQ6aBrgpA9nwNkeDAIczPQN8r5GJHxTZ8HQKEqdxgqbEyXDUcuJy4MNIZv1AYWiMeOdj0Ngo4/ID47/e9o+tpwra8teb6TnfhMwLKnhIjRBBw4h6SpiCKCzBPXMddqtoeDvmlDfTHdgdTGxnnnd7iN/38IcORKnUoPR7xxawLYgjRmwaWLGc2b6N4sP93gdUVquwvt3gSHzUNpTYm1WMWhrDbDQQS5DtBejVulWnEqZP3ITYZKU3Mq9PbFS2CHuOLOCZ1bW2IHOYR5LvcqMhdWLGL0P1x+1BaPUvPf5Fmj476SwMdM7VLP/moMCp9En5jXc3A1fH2acgqGw0iEU6mwD8t08gbd/o6A9OBOPJy1ofyo1HLvWXJdMFo1RghyJMw6wf6giDaQCS/mu8RDlbPeAZ5AunqmLehZ6JIeZS8eT1hSesqVRxkf0JZIN6ozbcpilXj96wVGYjJ/nNBiyMyJMvOIbVUCKVZGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(86362001)(66556008)(6916009)(478600001)(4326008)(54906003)(316002)(6666004)(66476007)(66946007)(966005)(6486002)(8676002)(8936002)(41300700001)(5660300002)(2906002)(44832011)(33716001)(82960400001)(38100700002)(9686003)(6512007)(26005)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OjYk1q9GSbzOaljU0SIg1W67rWpPVAX7frz2z+ZZOwlDbGWNbPOZHvenbJPV?=
 =?us-ascii?Q?szOCAK9Om/+6zurfllJmFqKmUhyi7Y7cgEXwTBo4tYG2MftoIzfKUBCINnLm?=
 =?us-ascii?Q?RnJNfq/bh6p61W88x1VLLtXMTBsfPsQVE9H4EERptzESNObwFOoRp6PtLHle?=
 =?us-ascii?Q?2Ye3wuuJxx3WId1hUMjVZ8Xsa7W/RbnCAP295melNSdp63NiBwBBohy46Fzf?=
 =?us-ascii?Q?a4Z7K/tb57imf5QG87WRkGk/uArKSydjAkyYigFLa4T0Uw4Dgjged0mZ9T2s?=
 =?us-ascii?Q?4sldNKM7PLrojdF2mCmRXgY+Y+G1XlqsEn6jn5zatSvt8dQg0wX2dDD7Jzz5?=
 =?us-ascii?Q?ziIDEYn4sFIw4v8GsmJr7KUw0gHizZji6zlRrP8oXQwMOPhzXFiyYlDHra2x?=
 =?us-ascii?Q?0zg2nGkXF4Zk2Ki+mKIRMgJQizXMyClN6RVQBpdcXWNfxah4RzZfCOMDoTf7?=
 =?us-ascii?Q?/buGlxgCA+hQ8YKViLcIMsQpU6SBQoU8cqc9t7F7laHzXE3UAdReuSpBjBDD?=
 =?us-ascii?Q?Sc9jlqt7GqpaTMIhmj5x1lg05S3f008rxWFSk/IPQnmClL6R5R4tzjekBuuJ?=
 =?us-ascii?Q?InQTJ34nr8ZzYB0Iu5s6JENKBF7PmGfU/eNhwpupYJWZWfdCtIkE8FvgS/XZ?=
 =?us-ascii?Q?97ghKST8nQQql1KwP3mwLfHLCl0YvXyldayQyax7ha2Uxu5Lc3yrF5vSD2Bw?=
 =?us-ascii?Q?mD0Bp+Z4XHTY2Lafdzpp7Xqm9uZMDiVTWmoHFGxzjJjlhJLNRVDlqHvyuVWX?=
 =?us-ascii?Q?BUbc61woe35LEwp2OZSgnkiIeuDS5ShItgK9CylVgVTn0+zC7Hilk2QuJhuu?=
 =?us-ascii?Q?CgrLejJcZwEAFa2+X85+pC4VAVr8761ReWoYK1RD36dWSlhLqVG676kqRz1h?=
 =?us-ascii?Q?ZWTkTujs2x3GZFmDTfcAFz6f05ixLWFlYeI7jHo42UgHfQe3l7o/e8+zXw2r?=
 =?us-ascii?Q?mk9wPIodvvACReMRAY3ThPZ7PidslvJ3ghhfrS59R7/fFJN42ZPeb21Oouxg?=
 =?us-ascii?Q?AMyGNmVULexFf/cR9gUZgme8IkUI6vfNc2SpbhB9VMafIeMkceNgnphCvjm6?=
 =?us-ascii?Q?aKwb8Cnhk6e5HXtGwqzOc7hkgt1H7T6wO8Z0hHUuRSHDw2VT/sjJ/IjzsSQQ?=
 =?us-ascii?Q?A+Ozi9kgps9QRJP6jpGbPxBVqsBe6J7xmMtVdfAV3lIOm5WqQRx6F2CsX658?=
 =?us-ascii?Q?M4IeDWg25DKa7Oh/NeCTnIRElDMugJdgcNWKyd2aJmqq6eKtvnuH1cLK6D2Y?=
 =?us-ascii?Q?hRyFGfR3Jm8V5peG2VlcukAw7l2ztOvojNeauz+a5FT00DNaWn0tJnQUX/t0?=
 =?us-ascii?Q?DTYRCLjOuSL5DFJdYXZDFObVlnXgM1jLIpCipzATFnZ2IS6HCY9hklD1ndIr?=
 =?us-ascii?Q?7TXiCzekUx2BGGb3bEk9DZ6u7nURpcu8DpZOAZlHnTor0tJ3tzKE/O9inHPa?=
 =?us-ascii?Q?Krm7J/G3kat9+sWo80D/z5/qx8OdwHWbPeds1v1mk8UNPlCI2DVHZo2tDw52?=
 =?us-ascii?Q?yoSJS8fuVDqzvlOLa6RG/Lwxy7uKyo2dJNXIh6F5XA5q4xwbmAmb5JXthOug?=
 =?us-ascii?Q?5/LMRbngQOmcFxPXyHxU6NOg+fujVILY/emsVI8/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57046e16-b2b6-45da-02df-08db6b1fec65
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 08:35:05.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rk6Rvf43+ntq179NNni+VfjKD6ROwMNIAMpxvEAg34XPt+eEKI7YjX7UiexyBQ6ARXU8oMnxiuxzKfNotj57bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6224
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 05:43:09PM -0700, Sean Christopherson wrote:
>Snapshot the host's MSR_IA32_ARCH_CAPABILITIES, if it's supported, instead
>of reading the MSR every time KVM wants to query the host state, e.g. when
>initializing the default value during vCPU creation.  The paths that query
>ARCH_CAPABILITIES aren't particularly performance sensitive, but creating
>vCPUs is a frequent enough operation that burning 8 bytes is a good
>trade-off.
>
>Alternatively, KVM could add a field in kvm_caps and thus skip the
>on-demand calculations entirely, but a pure snapshot isn't possible due to
>the way KVM handles the l1tf_vmx_mitigation module param.  And unlike the
>other "supported" fields in kvm_caps, KVM doesn't enforce the "supported"
>value, i.e. KVM treats ARCH_CAPABILITIES like a CPUID leaf and lets
>userspace advertise whatever it wants.  Those problems are solvable, but
>it's not clear there is real benefit versus snapshotting the host value,
>and grabbing the host value will allow additional cleanup of KVM's
>FB_CLEAR_CTRL code.
>
>Link: https://lore.kernel.org/all/20230524061634.54141-2-chao.gao@intel.com
>Cc: Chao Gao <chao.gao@intel.com>
>Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>
