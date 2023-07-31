Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1732676A491
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 01:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjGaXLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 19:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjGaXLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 19:11:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B483DFB;
        Mon, 31 Jul 2023 16:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690845070; x=1722381070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZD/+ZpxHfodW+ZLWEjcr6u2s3ce4eeJ3Z1p5oYJp9/4=;
  b=FdAwCwtr9t3FBcDJmhRKdddBlgTEiQmS+mN123ZIVmrW6K0tqMByC6sZ
   0vm4yNYbRdO/7cR5FIyibSl6GD3gy4TVea0BzjHnw8r2Mra8rljvn/xHH
   kwVC70c88/62MyO+p8K8aWYMPZnVCLi1+x+pSMxraiZ8GP7yYGDzEDytX
   Q2fDQZ2ttkbCanRXkNe6DH0sTDM2cCgW2n70DAmhHc6nEERUdZfu5SFn9
   hMy/c+yh0/JY0LmUpdytSrSXkICs31YzJupphuK//Je/ouupA+ObvtRcp
   /fJmu7W58ip4rVTONbx4L9H+eR/a9UmY7S0aH3ouw3xYJ4fw9umSXr9LJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="400097831"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="400097831"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 16:11:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="975064042"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="975064042"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jul 2023 16:11:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 16:11:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 16:11:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 16:11:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 16:11:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0+ouxh+TaCRX3F9I8a5aSp3Y8TKCjTiGPrlPYkgU6Mz1+NPPX83lyY77XNwQu5gNI+X115I2WJ2Vd/rH7lzzYRkmi2BkB+IdioqW40+UIakrLPbJ6oih4yh9gihwbXZGKBbxe4JVJGgO2LLBtOeMWPmPLUKwNAQw09O2JC7R69cZd8EMCflBkaVN7GWcsEhFnQJQDBX2SAiUIpzVPwGGJG6sRX9Ix9UgN0Dz+b6/41037sybWndXU09XlWTkBYsMJi3rhmqyguVrHKFSg7kS4vM9kKEi7FaWICm+fGQSgX4AL3vLvktUq7gaLgMZADtV74Uj3YwMBoQ+S4ReNgjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4/+v80E+BngUl9SBpMgtl8flbme6Gw0FAkBelGbhAo=;
 b=S3N1K6gYnbp6X9059kaK739RfS1UPQK2gxubiB5u7upu5bEKyxD/WgetcaDlDiYtpwoX9Du2J+UhPIinwDZkfExV2axpXPVEhf+RXYJa7+YbyzG59Wa13dv554U3NcO7RM4fuMTgdAa2Nml7K3/2bJVP3bvVRonrjzPU/lNTm3C8gTkuDrgV1AAsXpYrEG7wudzZFjxB6WioPp9z0I0vFx/fH8Zf6GP5Fy0x9mucxja/i9kVfO5sn8O52gG+24dfV4ZPe3aw/K0ynZi2Ksk/kB6sBhB22mLq82nH2A/1F5buA5dftq5XRsdyl0JK9ALCURQNrm+7cMVPGv7Ot1XA8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BN9PR11MB5306.namprd11.prod.outlook.com (2603:10b6:408:137::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 23:10:57 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 23:10:56 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
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
        "Peter Zijlstra" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        "Nikunj A Dadhania" <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Ze Gao" <zegao2021@gmail.com>, "Li, Fei1" <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: RE: [PATCH v9 00/36] x86: enable FRED for x86-64
Thread-Topic: [PATCH v9 00/36] x86: enable FRED for x86-64
Thread-Index: AQHZw3zlhMSIUq8NQ0C4pAXZBOhbuq/UddgAgAAIhXA=
Date:   Mon, 31 Jul 2023 23:10:56 +0000
Message-ID: <SA1PR11MB6734A02EEFD83969F1965A8FA805A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230731063317.3720-1-xin3.li@intel.com>
 <ZMg1sD7IamB0INVs@google.com>
In-Reply-To: <ZMg1sD7IamB0INVs@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BN9PR11MB5306:EE_
x-ms-office365-filtering-correlation-id: 6ca7deae-ff98-4b92-cd6f-08db921b6525
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jWedD0ovvdzTRGlP0Hqaceh32J+cvlb1Hywq8xtjzB1D/OmXZ5BrQ0G8xe5fJcWMj7bx7DbvzbyPZRAaejZcyKMXYkAGdL2gOFmChywnY4t5Xiuqib/D+3obpN5baVe5fkr/i9HOCnuVXPIprJAYe7Kj2HmQehEXKgRm4qzB00JTuLN2Ac9GZApld+Jt63UAl2TE2vbW9yk1cg/JJQdnGFYMuPVmrhSrryeqGgspwawTh9OSAuP7yLWMpvjXaPbPayCinbBjG1CutfM+j1vMQAh7tuPhWzAQ0b+79pK6QoFWl5Ub/VUJ4fGO4AxYlaoDpp4q6b+osqmC3kgjfzVxsQBe6b1XymIjb+SEN9/E8Jm2zNGLzH43LDW/kbpV3MWG/zMpJhZqocxLOYthGsfXdg+0VHMGgrBu7JSiz19ttiCEowEgxCmC+lD8utMlddleWn2Bo3zG+q83bnEmBQa8mziSLYuWUlmRCdldzOSFHYfeI9UaAp825ddNKCyEkqAS61n8ogcLzF+edOd1RK3wssrsr7K/kN+akva/+34c77nbest3wp/qsR/fm0VtTcw/r7yBZrOxxVaaqCQrfxU0LrgcRnEG4VODAM5rFMBo5s8M5LmmsrwiyU9qqYdDKwV6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(39860400002)(366004)(346002)(451199021)(38100700002)(86362001)(66476007)(8676002)(8936002)(64756008)(5660300002)(316002)(4326008)(66446008)(6916009)(7406005)(54906003)(7366002)(7416002)(122000001)(33656002)(76116006)(52536014)(66556008)(66946007)(82960400001)(38070700005)(41300700001)(478600001)(2906002)(71200400001)(9686003)(7696005)(6506007)(26005)(83380400001)(186003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O7GfaB6zW2tbF5rOwxySLTd3lQk0aE5LrrF3TO3yhcM7keeR8Udm5Y5IxXw3?=
 =?us-ascii?Q?me5cbjkFPMqzvipO2NaP6AoYxcYdVVy+h1ReWcoL9CnfAFuAzW8cKcLPZR4r?=
 =?us-ascii?Q?+2aXU+lxPJsL5z13p0f11bdA+CdXFxyc4Gd24+A9WPruf1WFYxuNkSi5cl+E?=
 =?us-ascii?Q?G2SYAWs7iNApVjXFGqgChWEOuxDavV+z9G08A44ycz/JmegE2V5bx4dYjTo6?=
 =?us-ascii?Q?xLilM90JyCrfxkM5oHitqe4kesvcHc49+rQk5dVgu6TQ6AnLBkuALTOyl4jy?=
 =?us-ascii?Q?FTN5zwzEfeE2X4PRosyid/P2VNXhxZcO7ZAggm4efeZ7TU9JE/xsiPOMjrr/?=
 =?us-ascii?Q?kI/WN1CcwPuhlqldt3pY4y0LdzY9qNzfg5n/BrnQruuTckEYcM6yyC2Ny1Pv?=
 =?us-ascii?Q?oL/3VxLuL+KHPpOwaNYcnVvZDSpzq80aQIeWN7W/zs2m0mkNQ81qXziJLDMN?=
 =?us-ascii?Q?3iRReIbEqU6IOyEy2ifLSovUPYx8vvKk0NV6ij9a2Ipu4nc+GLIzNWOY8zOu?=
 =?us-ascii?Q?IRlgJxgT6/wtR0bL0FqJO9aePB6Zb6wgXh8S1LpZ8vsuz1689cnXADe15VPY?=
 =?us-ascii?Q?6jEVjP+mHc9XDpDC2+f9ySI3DwZVAjpN8L+f67yrS8Q7GFwy0vTYIimCT7Ut?=
 =?us-ascii?Q?RhbVpRa1B4eYr4gO/yJ7noOaRJ0edG6RSSjJr/LFDQ5R2X/5UFReo1NNH4UJ?=
 =?us-ascii?Q?R+HcpqF3jQ2BdI/ypLNoFITHsImMlPebEBRi8prML4yQDS1T6bPLSA78wOlK?=
 =?us-ascii?Q?uBje2IokN0NUTgB3v8H0EDLn/6bV2Bh7aazgsWjEpX2ucpWbXEAZ27n6Cq+c?=
 =?us-ascii?Q?VmuEjdL0DFXr8z6RPlzgi6227rRC9INYOaX+DkHR89JZnRtLcN1SARyaXBEa?=
 =?us-ascii?Q?3lWoqMyddZOCcwiLWFPVQNqbBlzkTrGkhycRaIbU2zBdtz3+7LhYEY9MzD6F?=
 =?us-ascii?Q?rq5iNydeOE6e0Mil+dxftF3SMiGju4dl/mPnIV6ONfAEj03rnTNvzBrx83Oj?=
 =?us-ascii?Q?v7y1J8FbKiKurfMY/czxvd6UYM6w55lMKyjyXQUu3ibfaS1ZKVu71DwBi4E8?=
 =?us-ascii?Q?+75SsEx13B8TQBA/DQzzEvhB/7/TpsVLlkh0mfRx5wknSX0cm6GzpYsAnVy9?=
 =?us-ascii?Q?ggKVddVjKMzG8bxpwBBnbHn3zAdHFkKasx9vSVrgjcSAKb5IABZHw3RmjvbH?=
 =?us-ascii?Q?/+D6YARyB4N0rIAIoE4u4x9PA9ivjO6tjmSINkQwSJWHMhBIxC6MjNf2zFcv?=
 =?us-ascii?Q?rA6sYngfQAglqM2T5tHSUp87aXztn/yoaGa0UDhZBNxWWVVcRXFG12uPZPl+?=
 =?us-ascii?Q?W0IEVttRu6pDPO9JbqMJ7K7LJnqB7esIohRBlyaT2KK6mnzR48GZMuVMxnQ8?=
 =?us-ascii?Q?jYyJlogJJNlMuR77L2lzWwBPeTvvM3h8duRUQkau1Y83QPFkCLGdoONqxndo?=
 =?us-ascii?Q?Tws1YL3fnAIaNXy7Y0Ay8WUoqBdJoifGm/8OjyQ8ic8d19J25C1FVPUgglna?=
 =?us-ascii?Q?upeR2N7DOnRCCRcBVVef1NlbmdvKFiyIdTEc5xxz9hnONiN0OggfI0LcLD88?=
 =?us-ascii?Q?43CQKOdLnjQNC303csI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca7deae-ff98-4b92-cd6f-08db921b6525
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 23:10:56.1366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oyKmPWTD20Zsn+PCspph++rs7dNDf8h6M1zc7Qd27AcYGGmyYr+9Il1qixVJcqPMNoyE79Jic2KJub2uMXAulQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5306
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > This patch set enables the Intel flexible return and event delivery
> > (FRED) architecture for x86-64.
>=20
> ...
>=20
> > --
> > 2.34.1
>=20
> What is this based on?

The tip tree master branch.

> FYI, you're using a version of git that will (mostly)
> automatically generate the based, e.g. I do
>=20
>   git format-patch --base=3DHEAD~$nr ...
>=20
> in my scripts, where $nr is the number of patches I am sending.  My speci=
fic
> approaches requires HEAD-$nr to be a publicly visible object/commit, but =
that
> should be the case the vast majority of the time anyways.

Are you talking about that you only got a subset of this patch set?

HPA told me he only got patches 0-25/36.

And I got several undeliverable email notifications, saying
"
The following message to <tglx@linutronix.de> was undeliverable.
The reason for the problem:
5.x.1 - Maximum number of delivery attempts exceeded. [Default] 450-'4.7.25=
 Client host rejected: cannot find your hostname, [134.134.136.31]'
"

I guess there were some problems with the Intel mail system last night,
probably I should resend this patch set later.
