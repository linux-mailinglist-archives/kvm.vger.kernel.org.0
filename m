Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084D85E6288
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiIVMfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiIVMfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:35:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33D36DC0;
        Thu, 22 Sep 2022 05:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663850101; x=1695386101;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9LyEE1zAd69zsubmgXiSDkMPYdlVSfAtO6YBsav9AqI=;
  b=W/ZQoMzfctFbVvHGHdGBTRirdquOeLg2vEzk0OylsKPyQ4ANeys8eOFp
   RupL9C0wGML0koUI17vyhHwN3A9pqEDCBVRouqdwQMNOjQ3Vbxz14kOIG
   BEtU1lae5z2rkcKHw16tVa4xukBzBBvaoKsbvjCyNK33kfLYBLRml7rfV
   mbPlG9AA4LTRaPhZHm6Jorf1/I54rLIHy85WZU6LUaMMYLN9WI7cJ1v9d
   WjQKzpgxUWNVsnFJkFLQNFjp7m/6lFOJxQRoOkE5kyHtJ30s3QKDGp5pf
   /N49Oz2AdjNvVmJ4OCC3cQQPM6RZlT0lRe9mM1zYmzEzNRGoJsB3FV83H
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="280002585"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="280002585"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 05:35:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="619774253"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 22 Sep 2022 05:35:01 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 05:35:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 05:35:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 05:35:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 05:35:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkEWRq7c71Mf/S3bEIEM19dSa+YgIB2R+4Sb2+T3sNVVqSUheH+yq+iPS+g1hHjOJ1+wg31G76dqpnhc/1P1X0DPeVipGup68yuWZINIj45wLXywpDXmsmLWR573ZLCGXqT4dTOQImnb7DNw/chJEWQyh86lFxECXD9O4dbr3TkQTkuq3WpU0VtlEg2VwmFICPZ8Kew3tBgfvJI72YurxBY9nwSmXZDDoGIuJXjIHSI6gr3YHzSEF7kOW56tf3WrrR+qrCh8XE8Nwb8Rek2nbgCJs2SpxPFBuP0RAi6dz6+DrJ6O61mSsTwSD6qD1wJV8VoEmM6D9IytnauUoSITdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZHLB82mmsKT/3bhoBkJJXUkxRoff9pWkr+oLwLx8gg=;
 b=UlV/TLszkKtTrnDNr6vSLd0IxEkNNNRK/DnLQjTip3gmOEtwadcGw309ZO/WuyyXY43tdSgMMuWjKJ2G0UlL1Kvv9GCRtyO8jAQwe5Rg05dXmr37+TBhF2ufIe6CSIXnDhmLPRGspajSqloD60KPzqqSB2p3wBi31ObvQwwc49Gy7qR7oqKZBCmS964nOpUaoPTJ8+d9POf2gdeJPbgn8COd1LpJHQEuXQB2cMhHp7uqMpIn6F1HJ3hwaRYTcAIr/oVANIfbv6H8oQE5Al2TvZf2VzXufDXmSHHRwpixr4WsYBkqIbIiwaYUkSyWco5+hG2prHGeAPRYoOmDS20EhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB6120.namprd11.prod.outlook.com (2603:10b6:8:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14; Thu, 22 Sep 2022 12:34:52 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 12:34:52 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v2 3/3] KVM: VMX: Stop/resume host PT before/after VMX
 transition when PT_MODE_HOST_GUEST
Thread-Topic: [RFC PATCH v2 3/3] KVM: VMX: Stop/resume host PT before/after
 VMX transition when PT_MODE_HOST_GUEST
Thread-Index: AQHYzdmby37+Us/iUEOsmljdkGVvLa3rCSSA
Date:   Thu, 22 Sep 2022 12:34:52 +0000
Message-ID: <DS0PR11MB63736FE9FC78F44A9BD9BB9ADC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-4-xiaoyao.li@intel.com>
In-Reply-To: <20220921164521.2858932-4-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB6120:EE_
x-ms-office365-filtering-correlation-id: a9a4b74d-7038-400b-6e74-08da9c96d90b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DqGiil5lUK8dHqxrE0jgSri3f3IpqGsXuRWey/8A93G/Cd+z1yuo4kLy0qsPKh62Scij9FWV9ECH/KwcBqwPVN4SXbP6pVW/lO9MLEL8jG+pxtwDNCbIvCFTiM7GdenEJ/4WIiWl/B+Yd4yx8cOFwPk+lcS4QhcwpHTrb3Iq2jStjgmExE7XGqKYrPMp5zev8ZWz2R7eKbt8Jb3gthW6yEAzzLwqupXfqrz5nQiJQLA7viVXWdRmbDN2hemPC8Mmq4tTdGch7iwRsOeDi1onOvkEM1tpuTKTgrj27HxYM1dIIXoG+Xufl1/z964TaMCUHhg1lDoSHfbSrl5/K8XG5EkJvrw6jaJqTPd6YyX43GPDBCflyOh1VRfzfRfabE0fOE2Q5pFiJlPC32P8+LJuK1NwYYKZQkSCjOrzmSAyC8QOtd3UXVdbdqkk4716udN6/AlGqDdwSWHgOcYFGoyPaQDl//IpyB0nsPQUBH0LDgzXsC2ejW+cz4p6HyVDIgw/aI1caNkcCllmZzejBmrNefZAs+AwQMy1CePAdIGNZvW6B+nfAw+4XbZDV2z2uWiIkdsYLtWx0S1lOZBN2Bl+wglqLTGXYzUTC6lUiIwedk+KS0BwD8qLAk2kJyeYFQQ5lqpnKW3udOGqlcEAi6CATS2YpzbeF1/YBkH5p/rOY9DM868WDEoMJQI+BIt+zdFi6FvBWGC8XgxNApF1+u30emDPlnWPkUi3mkwlDUJxj1JihkE9s6AzIQy0qkTj/hPKarPJpIdKir2AhIDiIlAEZFZjry2YKlxipASTmcfrk1E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(122000001)(86362001)(316002)(921005)(54906003)(38100700002)(38070700005)(2906002)(186003)(9686003)(53546011)(6506007)(83380400001)(26005)(33656002)(71200400001)(82960400001)(110136005)(7696005)(76116006)(478600001)(41300700001)(7416002)(55016003)(66446008)(8676002)(5660300002)(8936002)(4326008)(66556008)(66946007)(52536014)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?75v7dwBiqMQd+r6rDrimJVNB0SXyPe0JoMTAd4nKx6dqo3Srhk9JW9m+NjOT?=
 =?us-ascii?Q?XVndZ1q0AUFeNXWwh7oBBlFcYR1WgY1XaslM+4Kttu3sICr+J82xG36XTuQj?=
 =?us-ascii?Q?F+80gOUhnW9tMbeNU1Kpv+heDjEYE11/VaJnN/4IGpfvf9/bFMfuK4uCSxAZ?=
 =?us-ascii?Q?pCbeqcBvDY93skelszXKef+f+0mparvX9RkbqTiHDDR46Gynlb5nw18w4VwK?=
 =?us-ascii?Q?cjfHvTxIH4SUNT+pku2kszCNB9mPemF0yJ0ACpOFJv+806nU//CrJinkl2SO?=
 =?us-ascii?Q?jFES5cPADayAUeisz700Q6jBlrHi0XAZPRiyZjoo/2j1euHEex6qn3x9Hpvw?=
 =?us-ascii?Q?9fRIUiIVP1r2qNcel+lDVBRAnWpcniaAcVwTFkfKJkuhxzAuDWaOMUdk265T?=
 =?us-ascii?Q?wLAGYYquTjc10yam2dIbn8k1PfsXTQFBZilVm7Fzk5grHYMleS3I6gtPY+HZ?=
 =?us-ascii?Q?Y4qNOh//UMFJ9GJt5j4YnGDkGF24MNBRnYJEK0h98Ze09FwSCNOCwHqCK/nN?=
 =?us-ascii?Q?GkFdDQyopzQ9bQgbw1SncEGaB3nMt2DNdgZz3TCwTQNBv8ylbzUUBCym+Dh8?=
 =?us-ascii?Q?cwrksy/+WLe8nz7fvgVEENTduR6FjpnN/3R4x0OxoczYSFwRVcCKZgSHHEhE?=
 =?us-ascii?Q?SgGB3AliGf6Rq4ie3s/c8vFcvh/bM3M2qbm0eVDDMKk7lzDdziwPhrKGfKYW?=
 =?us-ascii?Q?xjzOmD2vzr4WUu2DJbPd3yaYnvDvQu1Apci51cWuhQi9eOurl4VyhW8xewk0?=
 =?us-ascii?Q?6mJb9p0z+nYbHOhK2YC0DLTnc7D92AuKzFkFcC1GqIohZDLYbB0i7Kst40eX?=
 =?us-ascii?Q?Dmc/LPbqPOCuhcg4fxSqVmurIze/AI0yf+dyy81uwtKKjwhj54YnXaqlHzDg?=
 =?us-ascii?Q?7RM45Y3YR/8POusYfof3uChY4b0HJIM5ov3ZT6rlOnFRvPTK2WjF5ToBJJ0s?=
 =?us-ascii?Q?DIeGAA8PK76skcTPlZgSmc/kJlC7LDLkJEP50Ig+cPHPUfbXzDeeKaJm45oR?=
 =?us-ascii?Q?4obKyEWnOtuVgOut+ruv4p5oWHM2ZEINv/Hfe9v3IrofHFo85Fa1sfFsUr/3?=
 =?us-ascii?Q?e6FHxqi2gCwtF1s1pkZSG+4f3nnXeFARpY/mKmjWqtHZONqo3g2M912y8Ffg?=
 =?us-ascii?Q?Tl/Iawb6uccwnMY22n8wvsLP6go2YbyYwUb7ieHs7Hg1BEUqvEt5dtnj567p?=
 =?us-ascii?Q?VwQ1okvv9k4MHwzFVzERi0PSNJhVSfqN6S8E9J6q+YGomqOl4uCevpxcF3YU?=
 =?us-ascii?Q?Ttp08edaLYuPgL0hqwzK+5MADXWTeS2dRS8BXgvcxp81QN1i6mzYZBvav/VW?=
 =?us-ascii?Q?jYBjmfNkptmCxpUBnsz3XyQjGmTC6MP9wetIGiE7ka+fn1kFtoY5EH40gvwa?=
 =?us-ascii?Q?b4hfATyjqv8PLDCOm2q8Molwg2gtVetFwWh8iO//cZjqwISEARtI8bDlnxSk?=
 =?us-ascii?Q?Airw0oz2Vuk8kPrrlFVTxJSg4HJRvP8UyBwEgOI5E2Nf3zL5N73qO7OS6bbm?=
 =?us-ascii?Q?Mo3Ha8CqndXd3Sgh8ffx7p4ZApYSXjq2W/MVnZ3L88NiRNOAIjTM19LPibv2?=
 =?us-ascii?Q?pCkvS2P+i3+5w0HBOw58iDu4xyqqZL1LyLfpDX48?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a4b74d-7038-400b-6e74-08da9c96d90b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 12:34:52.6466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YvoDcQPHnvq21fZf1pUWKTLO3jsL0wDsJpIQGew4kZNdS4itlPqZjJOX6djuCotToiK8rZD7I2sF3HEMnr9udA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, September 22, 2022 12:45 AM, Li, Xiaoyao wrote:
> Current implementation in pt_guest_enter() has two issues when pt mode is
> PT_MODE_HOST_GUEST.
>=20
> 1. It relies on VM_ENTRY_LOAD_IA32_RTIT_CTL to disable host's Intel PT
>    for the case that host enables PT while guest not.
>=20
>    However, it causes VM entry failure due to violating the requirement
>    stated in SDM "VM-Execution Control Fields"
>=20
>      If the logical processor is operating with Intel PT enabled (if
>      IA32_RTIT_CTL.TraceEn =3D 1) at the time of VM entry, the "load
>      IA32_RTIT_CTL" VM-entry control must be 0.
>=20
> 2. In the case both host and guest enable Intel PT, it disables host's
>    Intel PT by manually clearing MSR_IA32_RTIT_CTL for the purpose to
>    context switch host and guest's PT configurations.
>=20
>    However, PT PMI can be delivered later and before VM entry. In the PT
>    PMI handler, it will a) update the host PT MSRs which leads to what KV=
M
>    stores in vmx->pt_desc.host becomes stale, and b) re-enable Intel PT
>    which leads to VM entry failure as #1.
>=20
> To fix the above two issues, 1) grab and store host PT perf event and
> disable/enable host PT before vm-enter/ after vm-exit. 2) drop host pt_ct=
x and
> the logic to save/restore host PT MSRs since host PT driver doesn't rely =
on the
> previous value of PT MSR, i.e., the re-enabling of PT event after VM-exit
> re-initializes all the PT MSRs that it cares.

I would also re-write the commit:

Current KVM implementation directly modifies the hardware states when it
wants to stop or start a host PT event on VMX transitions. This is not prop=
er
because:
1) host perf event is well managed by the perf subsystem. Getting it stoppe=
d/started
needs to go through the perf subsystem to update the related metadata (e.g.=
 event
state).
2) Simply modifying the MSR_IA32_RTIT_CTL isn't a complete way to disable t=
he
host PT event, as there may be special cases, for example, a dangling PT bi=
t in the
interrupt status register after PT has been stopped may cause the PT interr=
upt handler
to enable PT while KVM assumes PT has been disabled after it clears MSR_IA3=
2_RTIT_CTL
(for more details, please check SDM "VM-Execution Control Fields" section f=
or PT related
requirements). Not properly handling such cases can result in VMEntry failu=
res. Those have
already been properly handled by the PT driver (i.e. pt_event_stop) called =
from the perf core.
3) stop/start a host PT event needs to save/restore the related MSR states =
for an
event switching. This has also been properly supported by the PT driver. It=
 is an extra
burden for KVM to maintain another version of function to do such save/rest=
ore.

For those reasons, change KVM to get the running host PT event from the PT =
driver,
and call perf_event_disable/enable_local to disable/enable the host PT even=
t running on the CPU.
This will reuse perf and PT driver to switch in/out the host PT event, with=
 proper management of the
perf event.

>=20
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 31 +++++++++++++------------------
> arch/x86/kvm/vmx/vmx.h |  2 +-
>  2 files changed, 14 insertions(+), 19 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> c9b49a09e6b5..df1a16264bb6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1124,37 +1124,32 @@ static inline void pt_save_msr(struct pt_ctx *ctx=
,
> u32 addr_range)
>=20
>  static void pt_guest_enter(struct vcpu_vmx *vmx)  {
> +	struct perf_event *event;
> +
>  	if (vmx_pt_mode_is_system())
>  		return;
>=20
> -	/*
> -	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
> -	 * Save host state before VM entry.
> -	 */
> -	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> -	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> -		wrmsrl(MSR_IA32_RTIT_CTL, 0);
> -		pt_save_msr(&vmx->pt_desc.host,
> vmx->pt_desc.num_address_ranges);
> +	event =3D pt_get_curr_event();
> +	if (event)
> +		perf_event_disable_local(event);
> +	vmx->pt_desc.host_event =3D event;
> +
> +	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN)
>  		pt_load_msr(&vmx->pt_desc.guest,
> vmx->pt_desc.num_address_ranges);
> -	}
>  }
>=20
>  static void pt_guest_exit(struct vcpu_vmx *vmx)  {
> +	struct perf_event *event =3D vmx->pt_desc.host_event;
> +
>  	if (vmx_pt_mode_is_system())
>  		return;
>=20
> -	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> +	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN)
>  		pt_save_msr(&vmx->pt_desc.guest,
> vmx->pt_desc.num_address_ranges);

As they are only used for guest msrs now, probably we can
rename them to pt_save_guest_msrs. Also for the load side.
