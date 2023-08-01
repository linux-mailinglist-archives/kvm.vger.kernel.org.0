Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C52C76BB85
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjHARlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjHARlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:41:39 -0400
Received: from mgamail.intel.com (unknown [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E331E4E;
        Tue,  1 Aug 2023 10:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690911698; x=1722447698;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qS4CPA9EKW0OJfbbVJ1lseYCR6nfbdaDN/hUHotm144=;
  b=Ska6zS/SioYYYh0A4C5iCgldfdlmvYF2KoPV2iiFpAtrgZrXhm0s0j4z
   a9l5htXTIQcufZi5DkX57Xy4rKECSDjT7BsowmNGDmsEiUuh1Gq6TptZL
   ZYpO6b6bqTBzcAD283Znw49NcLRkLmiIQUYqlo6PxFRyKNiCJnhzKcs5j
   frMFsbXIGwfc3kP4WcTPb5B/qM2GxpW/MQaF5TtepTnm/Nu9kGn8BeXZe
   yuYxCkm1RzgoGXzQq30EiVXm2PSDZSVe1Pp2Hri/5MCVq5GKo7RbFwyFx
   dCze2NusxLBFtaUBCmX5JwHjX1VHoo/+IGMkFE33czqxPGioGFu7neE7K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="455741884"
X-IronPort-AV: E=Sophos;i="6.01,247,1684825200"; 
   d="scan'208";a="455741884"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 10:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="798769997"
X-IronPort-AV: E=Sophos;i="6.01,247,1684825200"; 
   d="scan'208";a="798769997"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 01 Aug 2023 10:41:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 10:41:36 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 10:41:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 10:41:36 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 10:41:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwlyRzHtPWPBWGy8ggnGXWwtcrp8MX+Xf1eokRZNd4nAt1o6ipc44ZvEvAkl7YETGQVtvbbVW3050FLPH+zvbdjlXMs7YmqCE+n7AJe5sVTDJoufe21b6tTRUR8wUNo1uyAZVeM/c4nyaRTJJnFXOHJ8/gbIdYY7roS1XxW7gZZioNkk13HzMMDIZYDS/S5hQAuLNlwg82l9Q61r1OiSR+dXf+efQMbV+5z9yb+FnudPM/0VdZyatRBsn8+911E5DLq3n0xmzsoG96/Hfz2s4ncejFsRWCcO2v5DpBOdQBWy45P78tgASpo0/NglAXnKJV/wuC+vDLNY/1hfYpRLQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oGFI5LY6O1zy/8NOdL5CXeIwuqJxl0Y5UaYhyX0+40=;
 b=HzIbP6eKwQE8AZmyUY533nfBewWcmY1wPA3r+3SyVBdm/hhEffA6OeV/v3Qfth/uEXqmdJ7RVs28m80cyEQbV3YPz09lS2T9RqONhfcqWsHow3m9Cb6m9qempvxwZsCjaHYDycfE3sOSoZ6G2rtoMN7brYMk35sYVzu2Q530hcg9k3Ia/os2ZRg2V6mVrLT2vb/MfNApYKAdD8smK2ONGF/6jA+YM9iQzuBc9GyjfWLxP14NNi1Tt70+3EaY1Cc0UXIu4gLJRuBt5i89zyU5vXyvmERZg4mydGCQGDAo4QT1cjQns97bDbO3nciM+EXSoIKFOgpxrw/+v1vYrj0dMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.40; Tue, 1 Aug
 2023 17:41:32 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 17:41:32 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gross, Jurgen" <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Daniel Sneddon" <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        "Sami Tolvanen" <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, "Li, Fei1" <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Jiapeng Chong" <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: RE: [PATCH RESEND v9 00/36] x86: enable FRED for x86-64
Thread-Topic: [PATCH RESEND v9 00/36] x86: enable FRED for x86-64
Thread-Index: AQHZxFK8XA18LlhFCECR8aoFrmHwB6/VQ+oAgAAkVwCAAExQ8A==
Date:   Tue, 1 Aug 2023 17:41:32 +0000
Message-ID: <SA1PR11MB67343841FFBAB71F005B0440A80AA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230801083318.8363-1-xin3.li@intel.com>
 <20230801105236.GB79828@hirez.programming.kicks-ass.net>
 <20230801130240.GA80967@hirez.programming.kicks-ass.net>
In-Reply-To: <20230801130240.GA80967@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CO1PR11MB5027:EE_
x-ms-office365-filtering-correlation-id: 816e65fe-dfe9-4a81-1eb4-08db92b68b91
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hbZBEgrMrSkukRlhRInro59naLc8vtW89qNg99W/JoEDrg1vZPjqBg/u4FEzRpbdt5HO9n3YhZ+s60rOGWaeJ4JvOlhgRK+NI7ATnneSDZB4P8FcKWam+yYn+En8JNkDAbgqyuyC8QakgKIZA+D2KeDhu2oDW8/ROyrASOQ0qZPC4SM/XL86ffPCul1P99rEXmh2yIGFw4NmyzfwsB53noi5Oztj+ERI1eXQioteUH1Dx9amYk7hAuohNJvRuAPS/Cw/Nn0Wsv8Gq4/j6OJz+tfFCoQdTVI6HdhBphRkuxsen359RArg0aFjQNikQGKVaAdBoZrM6xLtq+9olf4YyDzbCu8Qf5nAnAKU8owMWW0g0sICXRfQ4E9HnBu0TCHEeVybq3g3jaCItPv+dzkyu68aba2LVGF2V+0gcweu8WMWQl8erzUZy8WRgvZ/cZ7GRPjhmkB6xHaMyER/roQfGUOdqQYe8SGUUIDsj2CsdtdJR5qYu30cretfK62yJ1S/V0dF38SEyrrokSZlroSm70S6Xs6cLk2XOaUSqe3FCFdx1vubUU8nImxh+1JwOHanjOveg9TNGYl4WfBQYGv2UmadFzty42nWii5hQE4E0dI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199021)(38100700002)(66476007)(86362001)(316002)(8676002)(8936002)(64756008)(5660300002)(66446008)(4326008)(6916009)(41300700001)(54906003)(7416002)(7366002)(122000001)(33656002)(52536014)(76116006)(66946007)(66556008)(82960400001)(7406005)(38070700005)(478600001)(4744005)(2906002)(71200400001)(966005)(9686003)(7696005)(6506007)(26005)(186003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9S376hmpo4BhJC85NLrvpSb+4HNunXLP+7Y/90z2sNCXPaYTJCGYBVP69XP3?=
 =?us-ascii?Q?R38CnDhUy12iDryXj356vd70qWLvkFEPPnKs9QSXPMeQn9e1+2KDwqV5q1Ad?=
 =?us-ascii?Q?UDxSob9WX8WY5Rtl5bQxzb8q43+ay5YjBdtj76fpa8ly1YR79IVBcSwzkpAC?=
 =?us-ascii?Q?ONS0Wt7DqTJVkYUCmW45kipLv/LJEt/VplBKs4VRqiKojV+gFelT8ruP5nju?=
 =?us-ascii?Q?nnf5u+xEQPYQC7ARPBaHqo67gm41GaHZOmBAXDSMqrJkK15mVHhsHS8Q1RcJ?=
 =?us-ascii?Q?9R8DdjEl7GpIFZGQT+UQ6glJDwBAjckQLOFcdegodVfGebaP9eJF0kpni/1I?=
 =?us-ascii?Q?TxkRJCJTi32sMkOsW+MDfkvrCLGohEBY5TiR+5Dd4gofRICcWePlLVn8eK76?=
 =?us-ascii?Q?6VEaCKB+Uo/ItV6nsCtMBinmbMpiYwUs2m6Va1RrhpSpUnKw+II8QMMD+Slv?=
 =?us-ascii?Q?qNZoVjjTb+Gaj8rUaMOevgnXQ46B2zEGomEFpRVrw0VIoQ+sojxKTqfshlJB?=
 =?us-ascii?Q?3xLN4uYWs5jdDjENcukBUdQXmmtkq4AWnYiXUZ9JZBo/dE3dYIve6PWU6U/G?=
 =?us-ascii?Q?JoGzKouwiw/GrEo08HPIsaDkguQnlTgeNW1BypWbTfs5uS+pLoVwgosokYg2?=
 =?us-ascii?Q?eaHu7sk+9s7T9eQSBLZCjSQ7YNvm5oSJiMmBAV77CTZTRTRxtiMY4Y2e6h4M?=
 =?us-ascii?Q?tWHJkxUT2TMBpHX8bp8IMbTv0tzcTSJQG8ZCgHdnQzZudDK0/9g1ZTGziQiL?=
 =?us-ascii?Q?mOPoWDyiAcqbAu1Mxa54pTkvbdivC5ItrM7AQvQt0TG6Cc/Bgg2ZIYV3ZgGK?=
 =?us-ascii?Q?YKvRfjt2S5aPMkboAPOv2U3CZTAHmkyXHKZpqPz+ulJ5sZHaB3BB3rGPLcl5?=
 =?us-ascii?Q?ilQ9REuSRMtvNsq/JFBqm2KRd8RYP9GRxuU25ydzTFzcoOV/uxDEf5NFI0jn?=
 =?us-ascii?Q?mVRrXjWMPe+saQ/jDa7+UUS5l5cAHHgLuOHs0P+RuuLBZqKMotgu/acYbUlE?=
 =?us-ascii?Q?UUiVrd2ERZXQFJWhxcr2SpULzLqLe6ik5r1JB0NTnJ7UuCIxDOSgYDQbVqYm?=
 =?us-ascii?Q?EmdfFu/TTfFaBjUmkoecNcArt3qFdhTkBS/CIjcJPCChqHu3WP0K2p28/5WA?=
 =?us-ascii?Q?hSvl68zkyS+e1TkrvKNYXQ6gGiz5I9c6eVFSgdxPB47mtia4F6L+cKf9QxhM?=
 =?us-ascii?Q?/hgaq9FZsNxiEKICf/WTsNBxI3SF5Y7t28bNWGghrCMEQ/Zdt0Xu1ThATuwp?=
 =?us-ascii?Q?Y8V9WxSVmsqHHf3l6P0jVmEx5RXzwLbnjmxRj0agul8u9RaQtfTPVv3rOS+3?=
 =?us-ascii?Q?RA28LWVNpXQZ8hQs229ahH7zwrWqwyKmb13SCjTGTZZIFQeC8sx4TQI4EXn8?=
 =?us-ascii?Q?tDtzWwZWbU/8KFRZ2dLW6QZQGJN+IRFztg6CZB0aBRP5UNYu9sfwYOFkOuOn?=
 =?us-ascii?Q?I8xzAm74L+de8SMApxaOSFrNIJ+0LmJ5Uq4Z3dyzvyMwXOYkQrzqfC7+z/Sr?=
 =?us-ascii?Q?sitm0GKIm9ob3fuTsribPqNmnLDJOkM8J1XMIM300Vn2svzZIuiCVYdC5tc0?=
 =?us-ascii?Q?c5H/mL8qbblKNUsarks=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816e65fe-dfe9-4a81-1eb4-08db92b68b91
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 17:41:32.5745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kr0p4GM7rbulXd6menIn/NIkH7YsL0JXwhFRCBBrfmbU0hxYTP9IhCqLJRY2JshGhxJ/9DwLX/odK2AoYSxrYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > I also believe there is a kernel.org service for sending patch series,
> > but i'm not sure I remember the details.
>=20
> https://b4.docs.kernel.org/en/latest/contributor/send.html

It says:
The kernel.org endpoint can only be used for kernel.org-hosted projects.
If there are no recognized mailing lists in the to/cc headers, then the
submission will be rejected.

If I want to test the email sending service, how could I test it with sendi=
ng
just to myself?  Maybe it allows only sending to the sender.

