Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD473D6CB
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 06:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjFZEED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 00:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFZED7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 00:03:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC84210D;
        Sun, 25 Jun 2023 21:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687752238; x=1719288238;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=REf3hJJbcoTdoGZSs/mSngBh2FzBsB35rEGpwx/kaq4=;
  b=KDtHWz9dlS0g3ilkMqHy0I6CwOhDyfPlLd6sK+Ayp3LiQEI4/HMFR/G7
   Ru+4yrTdKyokHHyPHdCtg1FLaXX7CoMQs89chgcZF7mGpvUstzlCnBXqV
   ju1Hse9p9ettH1uQsyQ7m9Eb8KVIqxWlYytFa7iz7XVCyH+PyDa7ivSoY
   7eSb8o5l3HaiTlXTz+qg3+0fMNbqPxmd6+QzsgFRVHsoO/h0t2ams7Zex
   S4TVCHqL8J79814pJzWb79qecCHPuMIyRB6bBshpWPb9iIf6bExtHpLKw
   sBoZs5yLPzIs3uaElwJhHoM6wxvtYVj3qI9d+JRxOZ/if90v09n86U/hl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="364616436"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="364616436"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 21:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="890150255"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="890150255"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 25 Jun 2023 21:03:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 25 Jun 2023 21:03:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 25 Jun 2023 21:03:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 25 Jun 2023 21:03:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 25 Jun 2023 21:03:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD9PVxOjqRFwLmRX7D3MCkSeOC5b/bnU6z5JKBhwPs/UzuPTXOp7j8PLop1Y+29ABJ6VZKlJ8Id3ovzEKycQVcwRSU+0UYMusb+PBPDIU0zTsyyup2wjLF6eeT/cKg+hJeJoQqDfA4kypGV4WubjIlMZAndzq5n8uK4fxn5Fnazl0vFHIMnyWEVXzqGQyTCcjCx1eT2tEaTLgpealHG54ISNPDj5wL9J3DkXPLmEo78uiSb9dAX/SCuerulduMpPSGK6qRKjydMw4c5hA56jdCdlBzUCHPVGobNgMWBahAlFC8GV08/JOcqjsMA7CL1r1EYPyqx0yEBjpUGWGkotfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pViQbzCyQ75WfiFthR5GF9hzjoV3O9vYxNyO8vtrVFg=;
 b=Ih+qfaR97kDvnl1i18CAlGwJjxk7Ky1d/qwy90okpgjQyApi92Pf3COpFZ75kGnGzz6JXlqBJTRv6tpPLC+fe/QpWSBeXDQGS2+vUWOlJ2n0bzf92zKHoRMuSayajQbbRO2zShD0WqnISYfnlURmpG4OjVsq3zDHfjvrmN2fDM6mZYqdRRLrMKZZgrSNx2sPS+FgJXhMVmh3+cQvCVCNtRZdAmWLQLM5XHpMjjcWBVT5IIlIdg2qLJQ++bbXsHSxc/3SKm4qH+cDsIskEPMZt67STgFkNeUPuhPIzmpbkCfmPMKATv1UdDU7Hv/Ds/q69nQdPR5JrW1NeSld+jNo1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6732.namprd11.prod.outlook.com (2603:10b6:510:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 04:03:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 04:03:53 +0000
Date:   Mon, 26 Jun 2023 11:38:34 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJkIOlWoBGI/AJHG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
 <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
 <45be3429-f352-920a-d1af-7f3a07930f5d@intel.com>
 <ZJjW9Kstbfa+LmAV@yzhao56-desk.sh.intel.com>
 <20230626034027.g75sliwf46impob3@yy-desk-7060>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230626034027.g75sliwf46impob3@yy-desk-7060>
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fe42517-4c07-477f-c07a-08db75fa5b0c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+kiVjVZn7YniUY72sNW6aZYpbzuUvbBEBVA+RBGcaedZhjLABOxkaSDKEN7HSTfocWbnGiaLTrzacGASNTV/GNAPUhzgfkP5nvdQwwmGPT1FPmeaCOpPz2UGSn1aBxyIOYLyifq9RorZNpOjTSwDiGyXmzi/Tb0T1VbfjSQYG0+VF0/QDemtglcwKoZQX34B5Is7j98/2lWUZw6xFuKaepUn1xexuPBfKJDWKT0z/fGyG3XzU+d4NuKSoGXNkhtON/sIjplrkjI5IIKnoJ80k/XRHWH7tgxEhN81ZySBLx4tgMuHlBuLGfJpDIadarDU7yn5Z9wi/CBg8uVZZHdxEHW37wLHfsyct5SKORhAecLHVn1NvwWQHZbn+f0rPveDCZyer3T8ytzj45gFV9EhFizt2RKpkXLKrD7N9dPAR1JsPQBedqAV2pJ6iDjIHzcHceSvEtKNs3V43gl1AFGfhkhK1dEVID5tf1KES8r1Jy5pxzZ4LVvaYPD8HNLq4UAjbMVCDa8OtJZ2M1EypleBiZl/occxb8BgC4CxbtNbD0Y2Q4tkKCLLgeyk9kXY29K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(82960400001)(38100700002)(83380400001)(86362001)(478600001)(54906003)(6486002)(6666004)(41300700001)(66476007)(66556008)(66946007)(316002)(8676002)(8936002)(53546011)(26005)(6916009)(4326008)(6506007)(6512007)(186003)(2906002)(3450700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+eHdMHgChnxLHVlojwHqla1EEqi/SLwt+jQOfbO3aOuAg8+iRRGUfE2/WtM1?=
 =?us-ascii?Q?dRahFCzshqAoHTpoWveVxYGmzYAKTU21gc3UCbdR0vsjbz/XhVCEQ2oSWp+T?=
 =?us-ascii?Q?HzOALBoMnepNhSYyxi/5sh9dYE9FiqKip6/hdQ18YafdU/0VnSTMSOQu7vlv?=
 =?us-ascii?Q?j0wBVQ8dW7DQdH91Ewykkhn54ge4GvpjnNFme2Vyb1v3dBoVbv8Ereyk0s3K?=
 =?us-ascii?Q?Dmbj68p7lc5LO/AK+7sFUqCBzHQTXnlSwFsy/7Hh0MikSfciR1bi8/YSQIQ/?=
 =?us-ascii?Q?oUE7a9HOLaNKi/H4JPqkT8DclvA/d1J5f++jUerms/6Er4octtoLZPn3+UwP?=
 =?us-ascii?Q?DH55yG6l74yRa2k1SzSD8p1XBNCGpx5G82Og6wi8xejHtYEGWz/oDAdCbn4n?=
 =?us-ascii?Q?UREbzbzMXaVHcHl8jvo82SCg60QqpEXyNQ8ya9Jt2KI2eoss9IkoK+VxIbmD?=
 =?us-ascii?Q?30HajKH2MNTude9ciOJkBbhBlg1KBiFTZyCe5sGG/1sleAozpmCgmJaoi8XF?=
 =?us-ascii?Q?l77SZlL/nePhdJIYSPJwDyTbbI3wUGj80KWpzykgn1yu4WO6bK+rkHXo5L1A?=
 =?us-ascii?Q?Qbsu/DwaN8qXiZ0XUdIcL2NR5trIAce3npJF4f7ngd0q2PfgoqQwwvEduGiC?=
 =?us-ascii?Q?teOXpPK0WHayW44RYWepZFXp7DRWAsQKEZKs2E06sL/m0U0mCOZZrrywAeea?=
 =?us-ascii?Q?d/uPJn0okh+ybOHPbKj3xGgc9PWfxXgi49yPZHkWk/3MHzB/wmSFoYYodulp?=
 =?us-ascii?Q?2eINJWxOK0+wiyuab7yV8F6CcEtK7b75Ci0NFvcnytJTvHzn1bYm9Fiz9dtL?=
 =?us-ascii?Q?lRpKKr/OjY1pFoQL3qnuc3oFRmZNMPhQ3n7nhuKn+7vFTN8EhJYJC5l5lbtS?=
 =?us-ascii?Q?tH/XtD30xsXcsrsFAueKbonFD+yFfq4hiWwBzDb8dBm9J0x+Yj8gn/CXUYXE?=
 =?us-ascii?Q?GrSWgKCp7jHWiVQbjnCb9+Boeq7RqydmzowoHf/V/v2CiRW7j7JrNL/YSFRm?=
 =?us-ascii?Q?GrPWwjRvvauXHivJ8eVcZoTSi27Ti5BzCKqMKvt3JIZDScU4r1GiIWOiziXn?=
 =?us-ascii?Q?jNRMIL6KF5UUKLmMD6c0RyuN0AS4fpz/Y5ojBd68O5xSt4nR5+qYK02wktMO?=
 =?us-ascii?Q?jlb0rycSqVSR6k7DMYWPPOKZsd4tv1wir+APJvklDLZoRMBlKPjksJqBqSq8?=
 =?us-ascii?Q?2wqKfntvUpGd5iGITQi4LzYQbrfSUYX0SelORYDojnQRlOSHs8gEgsaz4iKE?=
 =?us-ascii?Q?eWfA6EMTH/fVz8UTr0GTj7mluQi+164vmKCPwuoOx5q3w0Q1Pb0J85LHYynI?=
 =?us-ascii?Q?Ye/sX7w6PR6Bi/U0aG+MUCP3BFyLNW5keZWKcdyj+vp6cZQduBTzriQLDWyL?=
 =?us-ascii?Q?5GwIqvsPhEdi0JRQ/H8o6SE6PHiKp1gwTywkmBAhBel6OQEVwC9xtoUX6trk?=
 =?us-ascii?Q?sIgaljFXm9nwg52FdRctC5+uZNHq1vZ0K93ES92mDuCl0rVsMix/JkdmZ9s1?=
 =?us-ascii?Q?9KHJyEX+TGTdKmbpFzc+QNTbGQtvsB9pVQNqia0ppvdQzvsQvAovNB/DvxcC?=
 =?us-ascii?Q?znVy8duT0ULlZxbrTjaRXonke4cwKTEki2qA511m?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe42517-4c07-477f-c07a-08db75fa5b0c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 04:03:53.4655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6n/9NrPLfbQUu8WbUwhNDNyls55c+L7DMzaXAvkwoPbU94mTQvVb20ehw+/Bya+e7fJ8CTWfAKrgRe9KUa/kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
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

On Mon, Jun 26, 2023 at 11:40:28AM +0800, Yuan Yao wrote:
> On Mon, Jun 26, 2023 at 08:08:20AM +0800, Yan Zhao wrote:
> > On Sun, Jun 25, 2023 at 03:14:37PM +0800, Xiaoyao Li wrote:
> > > On 6/20/2023 10:34 AM, Yan Zhao wrote:
> > > > On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
> > > > > On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
> > > > > > For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
> > > > > > types when cache is disabled and non-coherent DMA are present.
> > > > > >
> > > > > > With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
> > > > > > EPT memory type when guest cache is disabled before this patch.
> > > > > > Removing the IPAT bit in this patch will allow effective memory type to
> > > > > > honor PAT values as well, which will make the effective memory type
> > > > > Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
> > > > > which guests can benefit from this change?
> > > > This patch is actually a preparation for later patch 10 to implement
> > > > fine-grained zap.
> > > > If when CR0.CD=1 the EPT type is WB + IPAT, and
> > > > when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
> > > > without IPAT, then we have to always zap all EPT entries.
> > > >
> > > > Given removing the IPAT bit when CR0.CD=1 only makes the quirk
> > > > KVM_X86_QUIRK_CD_NW_CLEARED more strict (meaning it could be WC/UC... if
> > > > the guest PAT overwrites it), it's still acceptable.
> > >
> > > Per my understanding, the reason why KVM had KVM_X86_QUIRK_CD_NW_CLEARED is
> > > to ensure the memory type is WB to achieve better boot performance for old
> > > OVMF.
> > It works well for OVMF c9e5618f84b0cb54a9ac2d7604f7b7e7859b45a7,
> > which is Apr 14 2015.
> >
> >
> > > you need to justify the original purpose is not broken by this patch.
> >
> > Hmm, to dig into the history, the reason for this quirk is explained below:
> >
> > commit fb279950ba02e3210a16b11ecfa8871f3ee0ca49
> > Author: Xiao Guangrong <guangrong.xiao@intel.com>
> > Date:   Thu Jul 16 03:25:56 2015 +0800
> >
> >     KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED
> >
> >     OVMF depends on WB to boot fast, because it only clears caches after
> >     it has set up MTRRs---which is too late.
> >
> >     Let's do writeback if CR0.CD is set to make it happy, similar to what
> >     SVM is already doing.
> >
> >
> > which means WB is only a must for fast boot before OVMF has set up MTRRs.
> > At that period, PAT is default to WB.
> >
> > After OVMF setting up MTRR, according to the definition of no-fill cache
> > mode, "Strict memory ordering is not enforced unless the MTRRs are
> > disabled and/or all memory is referenced as uncached", it's valid to
> > honor PAT in no-fill cache mode.
> 
> Does it also mean that, the honor PAT in such no-fill cache mode should
> also happen for non-quirk case ? e.g. the effective memory type can be
> WC if EPT is UC + guest PAT is WC for CD=1.
No. Only the quirk KVM_X86_QUIRK_CD_NW_CLEARED indicates no-fill cache
mode (CD=1 and NW=0).
Without the quirk, UC + IPAT is desired.

> 
> > Besides, if the guest explicitly claim UC via PAT, why should KVM return
> > WB?
> > In other words, if it's still slow caused by a UC value in guest PAT,
> > it's desired to be fixed in guest instead of a workaround in KVM.
> 
> the quirk may not work after this patch if the guest PAT is
> stronger than WB for CD=1, we don't if any guest "works correctly" based
> on this quirk, I hope no. How about highlight this in commit message
At least for Seabios and OVMF, the PAT is WB by default.
Even after MTRRs enabled, if there are UC ranges, they are small in size
and are desired to be UC.
So, I think it's ok.

> explicitly ?
Will try to explain the background and possible influence.

Thanks

> 
> Also I agree that such issue should be fixed in guest not in KVM.
> 
