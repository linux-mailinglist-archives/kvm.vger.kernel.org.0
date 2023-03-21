Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB28F6C263C
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 01:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCUAMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 20:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCUAMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 20:12:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E5303F9;
        Mon, 20 Mar 2023 17:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679357536; x=1710893536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B8XSB724V1ynOerGo+ksuYNKlXxt/rMPS7KW4XzfHbQ=;
  b=kuBD0mfGg+QX+vVcsj8mO9IXKi4Zho9LibNYj1z6lbUGKd7leXklOxV9
   ilHLmHl5DhrWYc6sRWJCM1n/m8A4rH5nNKE5z00IrpyynbZEUE1Yy0n+F
   KeBzdgTKjOUMYaopVaZ0O+tgkGmhrTPg7LlGd6gzxsAt8Oz5KBmtmh2Yk
   HG8BrPcv32gkwtXlF47VKLGMVLVwO/aZBkNow9V/Yr5Vpv+BPMk4lhTsG
   DQPsHrPqEUTxlUizBC7c6zSTWEOuxWg/3gNYPonphyqne8brGuAcl5Bx2
   vYrHafz2Ey6UWi8k27Z9bQ9pK6GvgxIwJwt28x2KsQNRIn+Fm2XDE896d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="338839742"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="338839742"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 17:12:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="805099589"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="805099589"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 20 Mar 2023 17:12:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 17:12:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 17:12:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 17:12:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 17:12:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e02xbZn9dszzNOybK5X4FglTQKgpmkaswIIBrXN7AAZJedmuYzZuOpstgZxkHTz2nv3cTTIppqQtgvbyoPa/ElpA5EkRo/kksIS6q5DEJpdscenTbU2YbgrhrIlKnQXPmg7oFr+DRdDmDHttsBI7tBiZUrlvrs1cWAqEM8wv+3HYG0Wj9nsYaLjPthTGj1rLqdJLyJcCcHtr+yOT9rABDGnFVRjMbSVdOOQPc6xSOpyV7YgH3fGlg+Iz2xi2Sm4GdKLmbZTsZ1bWc5tcbvLTJ10YNC0HFQRKyR9gjsmIH5zFko5+5BM6f7Pa32LWyo1j70wKgNjBc2jpOWrKZz1cqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2k6bcoG+QV9MZDwnhiDSvKv/eCyTU9srjUth1w2o3LI=;
 b=Pq4MXF967iy5iQRAUVI3Mhw7CZur8TmrJ4Bl56y8B/0r0EbH/VzeujSKBJzH4iYcD2s9z2Cf1KF9lqkE/JDZ+eWXl16uEnP+qxxsZjmm4rxOwgIRoUimyxJ5DOLZKFKzql7nB1aFERjHrhiq+Zso3R92OxkZlGmIZ9+3vpf3URLWmWxHpLLjEwK0NY7jvqgLsr8GzaXkkTuIVeKDJiP5wvUpCrdl7BqcqQQS3MZCZeAEw4BKCMh5LN1y9HRBRdN6XKDhZ3OSMCbc6Z+wZEf06u1BYshVTo0tmKW/tr+FRSV0N/wqdw6JNg/F18o1Y0XeKY0N92s0BE4iSRR8Ex82Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB6826.namprd11.prod.outlook.com (2603:10b6:806:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 00:12:07 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Tue, 21 Mar 2023
 00:12:07 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 22/34] x86/fred: FRED initialization code
Thread-Topic: [PATCH v5 22/34] x86/fred: FRED initialization code
Thread-Index: AQHZUKIwUYB0dIbGLUidau1bSRiyL67/CYqAgACFIwCAAJcqAIAD0N0AgAB6oTA=
Date:   Tue, 21 Mar 2023 00:12:06 +0000
Message-ID: <SA1PR11MB67345D935A2368261E584085A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <20230320164950.GR2194297@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320164950.GR2194297@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB6826:EE_
x-ms-office365-filtering-correlation-id: c114681a-0f29-4324-c84b-08db29a0e82a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gjJYF+X8h0xP/l2kXOcBKCxH1zPH0v7ddjcohzKNiT5PzfTQMbFSMIDxtjPAWO6fGhHWvwkRzMlF8fkTd/Y0MsepxDqP4HljCPhp7fMEaSp9S7LpXpMh12r0uqs/sPwfu9GtiBgFpdjU9kMRzDbTfkgoRJGZjueyovdTNqTymp1+QEVvXZ8UXuo8czj0xw1/NKv1pigMMmwuoqsKpZ4DRiE1YzsuikmnosEjS2gydL6IqL4hY+W496nRVKY76squsjX97cUy1BdWySjQ765Mbi/KTppCN2O82+m13GXFda8J5jihnKla25su5QpS0iqST+uYUqWeHrsuhrUJeS4vRnZA6Fqg7j7V7eb+Jq6QMXaZDyDQsdM/RIuAfXB/147ma2ttTJoAQKoNpF3SuAcLpSwt+BDug9L64ZjpLI1W6t95djg3Lxcu8lVM9zsTr4PV7oXZiR9FyKLsqTUQRVVmCm60VeulwFLzCwJdbLpiLbDvNTlGJ3NYZpKFYFu/tzHo7mFhv6ccbZ7vEkJUP1pKrVUt3DA7UGLWgPLXJUQxYn2el6gwVrEujfAoyuPhp9KjbXmw3U6JCj8WRJAK9+lufBuzu6hzcUsLbd6eQhTZBgt0PKJ5BIRwaVySf1/KVVpxeIQCHUYAl9uUDlz84GI7jFi3JXVqE3LMbtcnD/5waz5vYeWIGseMf1VsvqWHy05KbvKPP57NIPmee+RmszHiZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199018)(33656002)(71200400001)(86362001)(478600001)(316002)(38070700005)(54906003)(110136005)(4326008)(8676002)(66556008)(66946007)(66446008)(66476007)(76116006)(64756008)(7696005)(186003)(38100700002)(26005)(6506007)(41300700001)(9686003)(122000001)(82960400001)(7416002)(52536014)(5660300002)(4744005)(55016003)(8936002)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FQu20fNIU/rffU81yrksuW63E7ohBPE3L9G2M49nkfZVMgM13kPg3j/M/TiF?=
 =?us-ascii?Q?eDRgVEv7mwOen2Bgsx4dkeGF9d6ltJvi68lzd2NqpZwNnPk4DdCbJ+YTw6oH?=
 =?us-ascii?Q?A5CyfF3scr4lwoiHNZm5IlnnhBSjHnhEv2EgskiCQ49k0vDFtPZ4U2es9p5g?=
 =?us-ascii?Q?CqWUpBVcCY8agQklEHXiHk4A9MHeP8CEuuMYykoUpM3JyN3B+uF86jRLcHm6?=
 =?us-ascii?Q?f5jWACCd/vloASncmyDPyisTxhCiHFRn6N4sIFu7imKAvyypqndDy2rkRwcz?=
 =?us-ascii?Q?R7CKMFUv16NRUW1LqYWk60YZ00jENDqSj+Rp1+ilGPh90RFwCL9jTDVBDmR/?=
 =?us-ascii?Q?nZBDWKf1WTxhZjzk3kCkpMBnmT7Aul+/NAkXaT0VcCX8JNLeyF1p3/W+LPCb?=
 =?us-ascii?Q?uKwpKA0wYcuKCJ0iL8Kpqv94E5RS0z94nkvgUqxRpwmNbh/stWTpzm7Z01/R?=
 =?us-ascii?Q?riTfJR4QiUSI7laphbYrCDTPJ7zux4F3DH6COBECZKK/sOnn3R+unk57Pgyq?=
 =?us-ascii?Q?Ej6D/r+HsOEd+4xYQSWzjN9SlM56p8oGGDYVhCgXyWAnB4uhjpiLrX24Gj1n?=
 =?us-ascii?Q?yL/fqsHi0e5BnhtMq0QFuGLvz1hTTb4IE/iIgXKArb7xnF6uIPRdFNNSyMOz?=
 =?us-ascii?Q?yrG1ezVJ0Eq0hNFv/zrhVpNlwsFoF8cjOZj01nMuPqsXrgsGXN6JKLggCaST?=
 =?us-ascii?Q?d+fmO0WRUovWzpzs3cMJiMzUktl0ml4HRO1uH77G4GNhGepwgFOV+0Gp+0ex?=
 =?us-ascii?Q?13lbJRz3f/8iCHTrSP2BvXpYZgln+C5JJtWuVqQHLQ1lS53KHTdStp4yO7PK?=
 =?us-ascii?Q?B8s+ANxKdrcuSCP7xPzdcsqbaVR1bntTgz0GVAludZLScb1oLLq2DpA4jPnr?=
 =?us-ascii?Q?Qv0isjUrcZB/Zf5ELumyZsgRpaP1mgFprLbaHwV5J99PxN3croUvJSx5wVT7?=
 =?us-ascii?Q?leUj7KZsry1r+Eyz6vSIqVVvRUwjktM2bxeSbPDYHNaS6iMDadicuVbKb6rM?=
 =?us-ascii?Q?YENuArkp9BLq/ydSqyWvE2fKGkZ0MRdNm+IQFXX+xEit8mzPtDNoCM7hFxN/?=
 =?us-ascii?Q?0PmUMjbXFcxSLaCX59EQxiuAaP6E1oNOciUPAIzSMKngBuh8IGHfrlnDxzr1?=
 =?us-ascii?Q?Ug7WWrZLE2rm1awBEU1JnfdyKi4MNQl8bnwG9KUYU2qF4vCEP0kQABaHU/l1?=
 =?us-ascii?Q?QOUyMxKoQvGYO6+aT4DG+0cTL0HyfD1ZKw+cOdTnJ/KZ6L8HD2vWIEtL0hme?=
 =?us-ascii?Q?WWG7EaHOmfMzLymURUQzsp3tNfShWU4jYRDs4l+0IemSiViRDmsYBTdHUcb9?=
 =?us-ascii?Q?zSyEqij8LJ6XtjxH4QeVMYme3VT0FI4DriVH1JDbZo3Y8CmKJxqoLirOB09t?=
 =?us-ascii?Q?VFAPsqyk6nWZawDmHKxUki4zM5PcMM3pQDuT2UjDVQc76br33hDyPMjy+Vp3?=
 =?us-ascii?Q?XTk1z2XA1mGzpR1tKEcRalAtIPcSAL+0KJWk2Yn1vPuyLbvC/fwgbXM1eehZ?=
 =?us-ascii?Q?OBU8WUNHgcqMvwvFwd3oeslDolQqN3r9USsaDgVwnKLKNPCj9xIQezs5p6U8?=
 =?us-ascii?Q?/l5YWZj20zslLtgDMcI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c114681a-0f29-4324-c84b-08db29a0e82a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 00:12:06.9524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nay4SazjSoHzIhrg0kKb1hh51nQ73GOtGtNg+A5yuStrp6rS+m2YrAaTodFPTZGKOYHijV6tog21kVNGh4o8vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6826
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > If there is no other concrete reason other than overflowing for
> > assigning NMI and #DB with a stack level > 0, #VE should also be
> > assigned with a stack level > 0, and #BP too. #VE can happen anytime
> > and anywhere, so it is subject to overflowing too.
>=20
> So #BP needs the stack-gap (redzone) for text_poke_bp().
>=20
> #BP can end up in kprobes which can then end up in ftrace/perf, depending=
 on
> how it's all wired up.
>=20
> #VE is currently a trainwreck vs NMI/MCE, but I think FRED solves the wor=
st of
> that. I'm not exactly sure how deep the #VE handler goes.
>=20

VE under IDT is *not* using an IST, we need some solid rationales here.

Thanks!
  Xin
