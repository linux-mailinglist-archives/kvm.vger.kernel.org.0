Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4665E38E
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjAEDfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjAEDfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 22:35:43 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3157E3056F;
        Wed,  4 Jan 2023 19:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672889742; x=1704425742;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wtH0E12xC9SArHYSb3FdeLcx2ONXdjpGRUWYax6q2L8=;
  b=GWU4hyH8ugI2zTPHQb2Rv0qxOvPB+ijTj1hpwLFeE7sm72KIpi7lZrD3
   Zq0f4eb2GEznMWFKzDCQ+DM5mqaozO2jrFsnCnSL7D+UtLqrvzi4h3kLf
   W2tdi8/3XrjXkFO0NBgezmCo5nx/NNNzLO+8On7JQBS/tJYjYxqutveF6
   xSCXasLSgnyQsjfP7NDYKn67nW9CQYxTYZ6CyKO4LuOUvDhv7fKgRdGsD
   B9+45xHq9coqho1z+GrHEp2kONl8Zpmbj8Aaksz+Ib9QwvFjAudd70W9m
   DjswGlUACDw23pdUsm91lxV2BT19QyPL86B//0Ny4vw4720ue22v60mSL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="384401254"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="384401254"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 19:35:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="655404149"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="655404149"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 04 Jan 2023 19:35:41 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 19:35:41 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 19:35:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 19:35:40 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 19:35:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5rmzepZd+cw6Wjfqp8nd4CMvW7NnAbSoKmBa0HA+6TVAbPbLqr6lGe3r60c06JOIBQala6cBnBiUdjcA2kdm/+m5Xu0yVJbUHd+vozF/4jUm89CMsUiYBZ1f8wvgwo5T8WZ3b9l/rLsqNNSKXynfWnatYDgmyf7nd9xaYZwmytKKwrj1Z1lxGfa7W8ngbsG8g3EeX2RzeK+RBywIwyzzkffb5RyvRgRkQjitT0iLcbxK60Y8VvLb8T4o0pLfFOqKpaAZyunoPMh9AxLep5dcgPASzt606bEcgyJCHm8JyTAkbXyMxg/m3CDL6NHUA/UZtX53A85X9udiiOuBHrYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MShluGPydxkpPfThl9IhjhjKe6pH8ipyekJqJEvlMwg=;
 b=BZ7d8wAwWG54QbSDhpFVaktFOheAUUvBEVi8/qE/TlOIax0QfYOpnYxDYZys/kaaV9x4jGAywydVj3jVldFCGHcJ5gbowurdWd7Mp8YEepCpzykNINDTdU50Bo44mBXghyRBmeiVIEPKupUbRC2Kfvj5JPotgReB5HC/faMmC/+gy1X0JkuMrxhM1B4XQ6eUlGhTCZ5GD+7n6/jQGT6HII5eysp8qECPMaKGfFKrTQTmsylapZPK4D0DDmZc+Ko/cJgMuccFsmacRkMh6cSRmgAwLnWBrS3/0lW0Eu8vvpo1GB4dPavGjJU+O3HECJNeVIKRE6st8CmsMKawmfD3Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6149.namprd11.prod.outlook.com (2603:10b6:8:9e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Thu, 5 Jan 2023 03:35:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 03:35:34 +0000
Date:   Thu, 5 Jan 2023 11:12:18 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 26/27] KVM: x86/mmu: Add page-track API to query if a gfn
 is valid
Message-ID: <Y7ZAEsQbNbWKngGi@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-27-seanjc@google.com>
 <Y6v287BFez8tU43e@yzhao56-desk.sh.intel.com>
 <Y7SbxcdYa7LKR43f@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7SbxcdYa7LKR43f@google.com>
X-ClientProxiedBy: SI2PR01CA0044.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: 954d3938-4e09-4099-c005-08daeecde703
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqdyXxhF9Xqyx+ayt1Q4iI+it9mkG46J428rGeHSsLnLR+cqIG6IcYWnEzNMKZo3hZICKkj2CS+SOp0KDxU2/g/zTFqEB/MbRegH9kqGp6tPsPZjWw/zkN+r+T2HxBHI2ynNmaBCpS9SI1+RdvrOPKTEvOv6h9oJ0Ls/TDirRhaoZ74jESBu6CoClnAVglCKn+CTKj7nifSkQlv7UThPTRbuSabbFA3g/UJknJIL34BiXc70FnOxlbfp4T0flcKhykcLcwVepLsMLSFXnqoS5IFL5XA2aGjtjZYcqrWzp2k9bSjbKxooEQVtclcJwJxk0KkEexxb5vxYAG97MMHlj3P/nrHFiVxoonCMDS0QqKmyml6jb5jWclBtdLm4XzV4oeIRlacZP1nfJ/+gO+q3tND75vk1TnrgB7Hdefc0vJ7nyCBha6HLv53s9okg+IE0egpzM8K8cSb7d1eumQj1t1PKFkCDUaKtVWzr6zzMrCpFXGINuAMYezejlX0Z9y/+uj2eEGNw2SPXXIhDTp05sQFmHYPp81JOIVsCPHbv2MeykuWrcODowo3lEvTa41Pqke7QnEOpDFnBZKh7j6plVksO3TJeZMlflb8CFp50Annfxdolm7c2Img6cs4vkFzzBbNYvziTod4ucQd+zIgSkqhZYJFfMSKavT1dPDjPqDZtXxQoRVYsnrzOvm/2Jfbu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(8936002)(38100700002)(2906002)(5660300002)(41300700001)(83380400001)(86362001)(3450700001)(54906003)(66946007)(6916009)(6486002)(82960400001)(66556008)(478600001)(6666004)(4326008)(66476007)(316002)(26005)(8676002)(186003)(6512007)(6506007)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dp5eQ6cMyZH91frWVwvrrZ0GQzwpeegWq1vpBX/b51bQaM3myOgou3UYo8d1?=
 =?us-ascii?Q?U/Rc5GwAUwxwbUBXvEcSZ8wLDalOzVz6ChKdN3/bBpeIhQZzMnFc5r0RdjGP?=
 =?us-ascii?Q?4elmjOptWs+ZsyzNqJIEU6zaoPZp+1sTqNAR3pm2lFqGXEfYZ3j4vR/7jV6T?=
 =?us-ascii?Q?jibrHBICo7CnsTxXfyMvm7nAUuoP4lNSvy4xmDtPy9X0tfTghSUCea/PUcF2?=
 =?us-ascii?Q?IBxbhjHfb+O3z1v43l8xsLxM1m5XxCTT39f/zhN9geX/kWRk8b9Q3jEnFA4/?=
 =?us-ascii?Q?BkGSiD7Bkiwa4VIEG4nFtMPnbpcyS11pY5/n23p/8KilBgWb9Grlto6uR+n2?=
 =?us-ascii?Q?BtXeIQGW2q6TJd5S2zsUTKs1YniEhy3Lzf7C5muEYYIPsIIyjTRqAiihQlmS?=
 =?us-ascii?Q?/2gfKacZ1QFeusgQ8REGPEEeauOEtSWycD+PVpqzE3OZaAy6h3D60xdkDlfo?=
 =?us-ascii?Q?2bQzEVA+vaw5kf4kW4TBhMzi/3Vsec49NXN1jXTU8k24gStRNUVuwy555jAj?=
 =?us-ascii?Q?kfEQ4ATmi9SU6FHXtPg5AcAC20xz/zC+mVnlv91cqqP/6GIKucehbmPS+A74?=
 =?us-ascii?Q?t4W0vHfXM6e70CX05nQhpLI5L0mjiPFRjlCbrL60wYnMovhC8V4SVuNx1ZQb?=
 =?us-ascii?Q?5bwkfsXse7ki5m0uqEnxd+2AhWS5ldrGSQT5oc3BbegXsSayHBQlEaaFMYgv?=
 =?us-ascii?Q?uIznz8S84dczS7pLo76lqPrD5Rn9YGRv/dqRU+7PZvzGshTQJKA6eH+C4hBa?=
 =?us-ascii?Q?wZMPB9Tff8dvTs+Qjc1pVTTGfOE3Ufcgb3/pOeuHLtRuYfmV0IFjsEQOzyzI?=
 =?us-ascii?Q?sVCj7Bop4svXFVjQ8EyIafayXmVTGLMHviL2U/x0re0fPaNUs/QlfX2pmEyn?=
 =?us-ascii?Q?U1C4Oic6F5+M/zCRz1dTqcgNxGolBoQ1qd4ECesiyHElSJHRM8PE+AF+tjnh?=
 =?us-ascii?Q?AW8tX0CoCK2oKD9sbR1WtOSc6gRkgyzKMYqWpmN2FFOCxXPuWXniVYdZnWxE?=
 =?us-ascii?Q?suks/fNMI4JC9h696kPpGBbsc/C+a9iNk41rdxb63RL952YfAPWY13tNsZDN?=
 =?us-ascii?Q?A2P/r21lSjqVF/rwYL2nvkCbaUQG6wcFja8yPbkX/iw21sejry90q6oiGsQY?=
 =?us-ascii?Q?MQVtkblFntiNT1JRd1pLYlC+kZmjZdOTbxWIf8UXVd/j0Gd+kCKmMFzn08d/?=
 =?us-ascii?Q?WrEyEXHXO6Uj/+oaewz4RHOn6y4lb3fnOwfAPj+860M6eYyJYi1sQL/ajkXD?=
 =?us-ascii?Q?3PxdP3DU899qH0luvJfHoUnRaEHmVBD8/vHggfxW7k63mGcX/L+5MshBBJQ7?=
 =?us-ascii?Q?HCq8L+WLnqBwHK+5VJloVNM5jvhfx8s3jCBVdGDOV27crHssRTFGw6haHkWp?=
 =?us-ascii?Q?zIlqjKouN6AqsIlIYN5McUX3BFi7dBPeTw0MalKMrEhzwxOhb3n5uWulPN69?=
 =?us-ascii?Q?M30a8goXVNATHykQPeE/mdWtk+7rP4vI6LIvn+C88C3991R+sDPo3xrPTVMK?=
 =?us-ascii?Q?eWHdPnJbFMct/60mk6hqmrW/wtxcrgs8xnmhL0ceXg+7K9rbCcO8Tm47mMo3?=
 =?us-ascii?Q?c8E3jGho7gTMICah8rPCQmhIV+/O41qTB7PJ8BD/6PF2vbF6Wu0SCp6m3ACo?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 954d3938-4e09-4099-c005-08daeecde703
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 03:35:33.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcwhHO4xSqTcdk+0UMo8DvthwUXyBSUhPe+Fvmy8j5bcHxPpQ2rMqZnd5x+qfETbFov6qzx3FIqb3D7ORosDqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6149
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 09:19:01PM +0000, Sean Christopherson wrote:
> On Wed, Dec 28, 2022, Yan Zhao wrote:
> > On Fri, Dec 23, 2022 at 12:57:38AM +0000, Sean Christopherson wrote:
> > > +bool kvm_page_track_is_valid_gfn(struct kvm *kvm, gfn_t gfn)
> > > +{
> > > +	bool ret;
> > > +	int idx;
> > > +
> > > +	idx = srcu_read_lock(&kvm->srcu);
> > > +	ret = kvm_is_visible_gfn(kvm, gfn);
> > > +	srcu_read_unlock(&kvm->srcu, idx);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_page_track_is_valid_gfn);
> > This implementation is only to check whether a GFN is within a visible
> > kvm memslot. So, why this helper function is named kvm_page_track_xxx()?
> > Don't think it's anything related to page track, and not all of its callers
> > in KVMGT are for page tracking.
> 
> KVMGT is the only user of kvm_page_track_is_valid_gfn().  kvm_is_visible_gfn()
> has other users, just not in x86.  And long term, my goal is to allow building
> KVM x86 without any exports.  Killing off KVM's "internal" (for vendor modules)
> exports for select Kconfigs is easy enough, add adding a dedicated page-track API
> solves the KVMGT angle.
Understand!
But personally, I don't like merging this API into page-track API as
it obviously has nothing to do with page-track stuffs, and KVMGT also calls it for
non-page-track purpuse.

