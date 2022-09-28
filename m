Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CCF5ED7C2
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiI1IaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiI1IaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:30:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80D86566;
        Wed, 28 Sep 2022 01:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664353797; x=1695889797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z7wLRn7r5/0pnDdu9VeNCRlzFpkvaYZ+4Rl+niVuEtE=;
  b=PkyQ1CdKDxsmYdLqJkXxpr/LSgrBUtcglvxTOaOKVVJXE5tuKni/1mnd
   vuLCW0dH41nins8OE2sqF+dpfUmh9fzONpxcU0oI7G5ICh9ApHSIWhuZn
   armX3oH3cAd5W8+3JDux6CGa3RCmuDq1EhNvrI7f9X4bSJmvnasbDI6hB
   WVsgqq26wSywsyOaFD3F+fQfJm8oG4yFuKHBsQyH4wP/OU9GWJnlNzcoS
   TqtXNIaz4+Tb5bxby0aGGWDDUowYpafDs3/JamVPqC+eD2MV3xuzmxsI3
   7CC9gcYuKG0kOX2waQrc2D5bHM3gH/Y3LzhOUiU5rTXL798Bq71z3ww4N
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="327907121"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="327907121"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 01:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="599494301"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="599494301"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 28 Sep 2022 01:29:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 01:29:57 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 01:29:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 01:29:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 01:29:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN4F9UnV5bnWVyhd6wJ28QdKFM0BXXE6GZ2MWKCBbpPj+W+rgf5qrhLB1arS92eqZwXuIR1SrorncZ5pwVDlMLAgFBz7LCJtwiql2OHmukP5Z9aAVQ7NrHkBTrgBOumdrK/b9MLfPHoLfvTZ2xGQ9hbIB1U/pgyZaY+RdY1mLX8VNvA6jxxB1S/l3QoMwHD27CmO+8vGSGPCefaGfcGMqKW++Ix77H494ivr77Ot9RUKKAQt8YPYRCfAKfQusYFbnaaZvcWhj2jJsn1A0ptI7wPm/g8hoC++2ibSZVSWpYeb9rjAaPLGn1G8lXfYAkz+LEGF+ZM0q6tMfXMBk8i9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuDlCnSXfVPc35gG2j8b/ERgKktYVdFnlmziT03haZo=;
 b=W9ZfdlX/IllRnwjaJOzEseu/TmugwzeNJzQJOPraWRxfLRtxwVqWG/I5Lbuua33JZ9zqGUYlGkSGHrZ9VjckyZOc6Rm1q4hxN5mzV3HPArkHtOfOt4sYPQ1EvttzRrXQpk37PfCKS/Kmg4NZKHP99S8q6/TLdBgvt7Igjca/avszNExphuJsCJ6kfBfbPXblkAKUnwJN1P4VfG+B4+ETNGryQyitPNo//cb/8My1SIDemdoeD/dxHtnVMfyVPS90FgopUbrGwbaoSLNu5hbbqh0d/ULxVxamJIcZmL5MSzTngQe8rxe2ivxSbTNzVZqdlu0+1r1pCf4NQIkfJ3+cjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by PH8PR11MB7046.namprd11.prod.outlook.com (2603:10b6:510:216::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Wed, 28 Sep
 2022 08:29:48 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::816:37d:6cee:cc35]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::816:37d:6cee:cc35%3]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 08:29:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kohler, Jon" <jon@nutanix.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Thread-Topic: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Thread-Index: AQHYzyqiVAqlk3tAREG5c6Y0U9+i2630iVbQ
Date:   Wed, 28 Sep 2022 08:29:48 +0000
Message-ID: <BL1PR11MB52712631CBBED273F5E4E1828C549@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20220923085806.384344-1-chao.gao@intel.com>
In-Reply-To: <20220923085806.384344-1-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|PH8PR11MB7046:EE_
x-ms-office365-filtering-correlation-id: ee44e2b3-e190-469d-68d1-08daa12b9af1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NzH261jQ/NKlKF+2ZtYmenazrYgCpkIPjn8XeE8JRxAC9hzFFEOdLEMMHN8dZYN5U8ejnxctHYmhj2HPNK2H9KMy+74LKaKQI6RF2iegrNP0CPDyBm4XBJ+UNoFq9GDRiqfM+7/3SrArUl06H+P3NSJ956GQXzz+AdqXmazMtCt08HlxLB5vWiQP6jRvELMhgMxZgardzIMWL3OwRI0IR4QvKld3Sx/DsPkCk9gP2d6MVPVao2T1y808VniCF/nGIIqe70fjV2sRHhp28ic2NXuqZAI7LumwKNxAPT7QDwCUghEH5F8BhD600wus7+FY4SpmAig+6HpaxKUw+xfD6BPKnMeew6oIMbk1vmtS48eY+24vf9CGIe6uXKkxOMGqra1sz5ZmXj7nlgPnJxgGH+C7pn6D2pt30duwug09wdwabNXgiY7fpAE9musSOoZic4v+2U0JG9VjtPSOsQJwOEkgqHxdjY9x6djr6b/9i/CgzdAQCMp40/cAPTo1mMoa0634soI0zaZdywreYFTCWg5H6TYagAq41KULk1hwEXuiijLTItdMiqwazMXbZaJrKfAMZKol88rT8aKqyp23uuHxMMOw8a76aza5uKT1W/IMEphF3OhKRsjFHKEx4/qRx8PzSHnIjVzVkMR7o4zm/mgsP/SyC55HOU71KxtBAgItuLXNtrWquKOtRpqHfN2YnS21tj3vQOD/L6FCCsFQ05hBNW7n6EjDlqDlVydiewFtEYv3VBEXtf1UeFYZcGfYky49uwkStKwyAvzvKPsK9PEIK5EG2T542y5X62o9Qn8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(66946007)(86362001)(38100700002)(15650500001)(82960400001)(2906002)(7696005)(9686003)(122000001)(966005)(66446008)(478600001)(55016003)(54906003)(110136005)(38070700005)(52536014)(71200400001)(8936002)(26005)(7416002)(5660300002)(41300700001)(66476007)(64756008)(33656002)(45080400002)(83380400001)(4326008)(186003)(6506007)(76116006)(66556008)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hIhzpIQuElRboCB//6q+OZo3oachgNGvVf0/9+bLf6TfMSkrSe0V2mYBhgQY?=
 =?us-ascii?Q?07Kcd+DKcEV0fFLHC0FOPg/d/s+8h07x7Tk2Jj2kFLHfL5J1eSU3UNoENtZi?=
 =?us-ascii?Q?+LnpVoQRLiQZxVcJx4qbNBAjzdKM5S2Fe1K3mlTlcMrhwG54biXW7g8BlFRn?=
 =?us-ascii?Q?LM4hDcxtyTg8kxd2URKOum2UoUrTLq5aheu+xaYxlaDEsB9AQgWSqIjreqgx?=
 =?us-ascii?Q?WYIhZHbmvHc24GE/XeibIB4B5pobvaCDXnQt6oJcaA7254uxH5qeN9quOadw?=
 =?us-ascii?Q?wjDJ+195z56ZDUT3N+4rODLBJ/nPuRfCxCdP4IoTd1LmUGQ6FBanBkIzeCZk?=
 =?us-ascii?Q?PElHkY0SBlAjGo3fohnltGa9U7UEO//4EzYXYrRNCcB1XylzDsHmZ5q6I9F0?=
 =?us-ascii?Q?DWl7l6pDLIIryodK5F/ln4zt+ul0exEA8gPujbDC6X6VrRwaQVhmwSNHmTRl?=
 =?us-ascii?Q?QEjZb3Tk4VVYVUBpqhm+K0vm+6xSdZCXS5TAR+M+SUIGf5/DQWfTgycDFoVj?=
 =?us-ascii?Q?n7HxTdrtUrRKwWH1VkTGB1jeqQK/zvhZ6gftnCm0R1Dnhg1IptQHMpOrfjuh?=
 =?us-ascii?Q?YkhTgJZfNSK0kiQJdd6gviIUKsEElaUrOZT7CUDGkroDRFPqa7wuQUJ6XmJG?=
 =?us-ascii?Q?BLl+60h6oDcBHQzgqxPeX8Rc9ib9ZLaz6DySEmYm3XNZmYPiTAxWY4LDXjVY?=
 =?us-ascii?Q?8Etdg4Fyj/rEAcHXTri8yycpLoPQ01DYs2x5O0bf65KHmdoVR9JrO5OuoKoS?=
 =?us-ascii?Q?wgeH7GgxdFO1m+JVvKqcANmWVkk2hsueQopEydhOUMZIp3qnBFg4nuVNX+5b?=
 =?us-ascii?Q?LDHwIgyNCDoPLexhXtwlAHIHYhMG6OIcFoTN5pnhN561r7OSeMtLggPnqh+o?=
 =?us-ascii?Q?WPY5nh0FcfAMCs3bhR1B6jzD3loaucCV2x84CRSrSFXj3y57rtxCu6G8Kkcw?=
 =?us-ascii?Q?/WC/HQ20xpYmjBcb7ctkIGl59252pYAa24yYhxRBOsalpz98oEXUevvxulfy?=
 =?us-ascii?Q?x/9Ds26herqCKupnnvuyuBq+yUrkRHHfyiiwNzkbDhANajdwFXjMxAUPpwyw?=
 =?us-ascii?Q?yE1F6jMWjItbkZ1Rspjdz5zNzfzZlygJcH04y+EDVj7MjgWVJ2KJir61jvRe?=
 =?us-ascii?Q?wBcsp0ivP6kGOuY/QY2xqwWP/1SwiX1GkXmlJnS5pyK544YZDvD4YD6Z8Uhm?=
 =?us-ascii?Q?zoof+6Fo8gtDDhXOGlHiri+LjP+kEjJgebi6oqoC8FZ2a0jxHIOWcSL30WGX?=
 =?us-ascii?Q?OOAzQKngSE1ISlX5PCrk6KCkiszC0pPLs8+QEi6xSIz58QlbL9VdGDmiq7Io?=
 =?us-ascii?Q?D4ZYfPrCOpmavnWOluXQBpN0PJYMOerBfCHyqTAiT6yRkbqc0DgfvSME92fp?=
 =?us-ascii?Q?BGztJ5DrR26z0WAx3lnCtn5oG9Za6hiTG7cCdRYENjJeE5FSpCVRLZv9Zwzb?=
 =?us-ascii?Q?6dmkZ9OXGKlSkrz3oX4gt59T01l63ij0uZzTo/a5W7ZROrmEUqo8GjquF0Uh?=
 =?us-ascii?Q?9AT3uNW/DPubkwA3A0hwRMKpMhcnuuZbdkIead3SJjSnsvPKX08PKCP+cb0v?=
 =?us-ascii?Q?9H/v6AIB2PbYtHSWMCwwvK0YNDwiotCHRhjfzIdQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee44e2b3-e190-469d-68d1-08daa12b9af1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 08:29:48.1212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eIZBJndAY3WeIsiBaOIg/V15qwH3UZmWJHwFck00fMB3bzpKFp6JDhsn20fH+vD4ipDHSJa5aMToq3mAKN6juA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7046
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Gao, Chao <chao.gao@intel.com>
> Sent: Friday, September 23, 2022 4:58 PM
>=20
> PIN (Posted interrupt notification) is useless to host as KVM always sync=
s
> pending guest interrupts in PID to guest's vAPIC before each VM entry. In
> fact, Sending PINs to a CPU running in host will lead to additional
> overhead due to interrupt handling.
>=20
> Currently, software path, vmx_deliver_posted_interrupt(), is optimized to
> issue PINs only if target vCPU is in IN_GUEST_MODE. But hardware paths
> (VT-d and Intel IPI virtualization) aren't optimized.
>=20
> Set PID.SN right after VM exits and clear it before VM entry to minimize
> the chance of hardware issuing PINs to a CPU when it's in host.
>=20
> Also honour PID.SN bit in vmx_deliver_posted_interrupt().
>=20
> Opportunistically clean up vmx_vcpu_pi_put(); when a vCPU is preempted,
> it is pointless to update PID.NV to wakeup vector since notification is
> anyway suppressed. And since PID.SN should be already set for running
> vCPUs, so, don't set it again for preempted vCPUs.
>=20
> When IPI virtualization is enabled, this patch increases "perf bench" [*]
> by 6.56%, and PIN count in 1 second drops from tens of thousands to
> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
> VM-exit round-trip latency.
>=20
> [*] test cmd: perf bench sched pipe -T. Note that we change the source
> code to pin two threads to two different vCPUs so that it can reproduce
> stable results.
>=20
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> RFC: I am not sure whether the benefits outweighs the extra VM-exit cost.
>=20
> Changes in v2 (addressed comments from Kevin):
> - measure/estimate the impact to non-IPC-intensive cases
> - don't tie PID.SN to vcpu->mode. Instead, clear PID.SN
>   right before VM-entry and set it after VM-exit.

One correction here. My comment in v1 [1] was actually close to Sean's
suggestion, i.e. opposite to above description:

--
  I wonder whether it makes more sense to have 'sn' closely sync-ed
  with vcpu->mode, e.g. having a kvm_x86_set_vcpu_mode() ops
  to translate vcpu->mode into vmx/svm specific hardware bits like
  'sn' here. Then call it in common place when vcpu->mode is changed.
--

[1] https://lore.kernel.org/lkml/BN9PR11MB52766B74ADFBAEC0AA205E298CB39@BN9=
PR11MB5276.namprd11.prod.outlook.com/
