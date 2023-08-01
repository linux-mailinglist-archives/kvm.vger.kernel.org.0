Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB6476C0BE
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 01:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjHAXTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 19:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjHAXTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 19:19:07 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F309219B6;
        Tue,  1 Aug 2023 16:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690931946; x=1722467946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bj5w8ug5nXkPeA631Z/FPHszoX+SVqqkPZbhd/00H+M=;
  b=gkkUj0mYHi03IR2EMaCScNPuN7k5mb05cI0lio702ZD1H21wyxjjQkC9
   YfriAyt3HVnksxVx0y66MgTz+BRO57YBQDst3SIrMZ0aqtuW/6/CS0WWy
   NIJWojNPnV73v4f8XEEXxFuQFI+yPFdS/j9NSjzu/URc4mv3uJxPQtLBv
   iEp91PH1AOU3asyxuGOQDYiREjOrkzTUAOvu8U/rHyqEB45qpB7b+DGqA
   JTvCHzS8BSzk8Z+Ev6fAyG81cY5y7i6LVGwM3AR1625gomHsXZL6raUik
   7o+GK62F/ryA5yTpcN/aUX5ASd13VGvN3UhwalyGwh3c9Gn6low8WjiZY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="372164214"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="372164214"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 16:19:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="975463188"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="975463188"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 01 Aug 2023 16:19:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 16:19:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 16:19:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 16:19:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 16:19:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6OnvTlFB0Z4Az04FF2JP/OQPJXQARjUEk6tuZWuEzxwzNx1am73RzC4tRurLIPmOE0nAN5+MNDPh/hNYLcuBW+dampqcxvRaf4i+1vrmAdrZ6I4JSGdc0gYtOkKVVnAAsNrsAigNHYN+FECMc3qOuwOXTHFoRIkqspvkvpJ/aiLrD7ra5AfUR6YEyl+G1UQBKJWgLMQ1ifjQAttI4FinsaIYCHwzYcqMLuEiNQald+8WlgpqZEkKctJFJOOUxEPTLnjDaKu0KgItzPXmF6IbLYHelpeBt4Hy0ZkmfyYDeDW+SX+SWh9QxoB5k0pV2/lnoBI2ht/ekn3lBawsPTZOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8XlHjVcyfKORPqwqUUtCNjTJnsqwsptu6fUDZ6EwMc=;
 b=h8Gx5TfTzNt1IIu4IBBZ1PsLgHJHdv5h06581B9Ptv37El2/n5d1c69T36NonHbCHd9u4utT71NF44OeLZtZakNvFOEM6OV1ro5AVqgH+sMnyZx3qtg/kxo1JhNIh6y3Leo+VF9RrQmwWDWteX1SYYyPNQrcvDCp00TCmWIUT2Dvd/dIKZqBbeePbgrGUFnt76ex1m+9GlCjwqTwCPcYXt6XtsgwActzeORHTm+wfJ8W3zwtJpYW/FnbUAcE2qT+RVzOORGY7fEdg/t6gugHbk/XN7HRodpZRICYsxa9DOH+Wjs+5S8w6SgUmym4iNGtQOn1pbowpYFRPGss64oqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BN9PR11MB5531.namprd11.prod.outlook.com (2603:10b6:408:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Tue, 1 Aug
 2023 23:18:58 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 23:18:58 +0000
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
Subject: RE: [PATCH RESEND v9 33/36] KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF
 for IRQ/NMI handling
Thread-Topic: [PATCH RESEND v9 33/36] KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF
 for IRQ/NMI handling
Thread-Index: AQHZxFc6Fm9A65hsiUKYksIzWWSQ5K/VzGiAgABBoTA=
Date:   Tue, 1 Aug 2023 23:18:58 +0000
Message-ID: <SA1PR11MB673440DE4294DDE87D93AE54A80AA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230801083553.8468-1-xin3.li@intel.com>
 <20230801083553.8468-7-xin3.li@intel.com> <ZMlWe5TgS6HM98Mg@google.com>
In-Reply-To: <ZMlWe5TgS6HM98Mg@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BN9PR11MB5531:EE_
x-ms-office365-filtering-correlation-id: dcaf6d6e-4187-4417-1291-08db92e5aef5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r+cxM3pPta8sYitUgROn2PDucNcvUltiyujBLIB2Z3wc/WA1AbpGfiDgnG9ZYXNPCazHzJRSrD7yg9SlHm0RpgIU92mD//G2FOnZbMXYqkS9rAXw8oGg29t03wb9+L8oj34ta6j/zwjU159ZxdM4/KUGyubBdtUbQwPvR2Fcu82GfE6XgEgEcZPoFpG18sWnfD8mwsKSZ/IPzxtmQULTfv0bfMlSUrigqSh/dityjnqxcvC1NlobvtkVFxDX/EtrPJDHDBI33wmCK4NWV/Jfm/PXW6Ojbs3wqBWGKVYnB+mg2ReWtV0Rr7HmOhZ9r0V6/M9Deske9dBdlz/eYLTWAckiJLc6RNaaxIKUrcQc+l8ZHNcuu8pibRB2E/uGeoBe8Z+HejgkJfxE18Xyz1P1r7PwUEPz554vq8wLD/3HflT+OF4VkbiEeEpEadkuRjFktwPyolvk7fmbSq24tNm0qQV+6NuJMDzha/lLGYG6v+KZcAyUfOHWDLWQBrbhrBKYbB+vdNv8paD2fKP2UkojnMLGw5Gfri8nYlkqhwOlRfQgqWfdPfxcVDNZEYmL1Bci+KJ3nYJ/TQkJrRWXZ4ZmOUiM+pw1wFV/3ZLR/xfij2Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(55016003)(186003)(9686003)(316002)(86362001)(478600001)(122000001)(54906003)(38100700002)(76116006)(71200400001)(66946007)(66556008)(66476007)(66446008)(33656002)(64756008)(7696005)(4326008)(6916009)(82960400001)(6506007)(41300700001)(26005)(52536014)(8676002)(5660300002)(8936002)(30864003)(2906002)(38070700005)(7416002)(7406005)(7366002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a/2pvAgarmi6UxxjEwF9/15YLf2D0Eyn4fdBB8TeZPD1X1viRO//B83LSg+W?=
 =?us-ascii?Q?Kb1IdO9MiI6onQllU79snUl5ERrgGYi0IcI196Hl3kip2suAMqWODPMTM2LP?=
 =?us-ascii?Q?eNrdGtYbxu7IVB71bzz8NR4HhEADC8Iz/0UpQWzmDOg5jYVpP9bheXJFvSu0?=
 =?us-ascii?Q?Pe8yWpoq72YuJCN1vn/WZbfmimwy1GnFcNimvVFQmWCVn5sW06QeSYH2BUNQ?=
 =?us-ascii?Q?rWMxGTwHW6TUTD3cJ9N7wIjTotFv7mx6lzbIbfmNaa5Kq8vPbBJbrFC2pkz6?=
 =?us-ascii?Q?o0XywMr2OPye+wB1KthXoxT9FlPr5knw9mevANI78AgCQqBTo/HdQwxLsa9q?=
 =?us-ascii?Q?mh4OmuzyKkQYl1rW2Y/Qj606hKl8yXua+muHOsNGOGoQkzKXsUh4wBdP3IVp?=
 =?us-ascii?Q?9w2RARPvzINL29PxfzwHggsig+iwYOv/hQbxbUE0EOnbLeR34bSucGOl50L1?=
 =?us-ascii?Q?RzjSNl1Mmj872iKuR7IdZKVnx3P125fcFI6Wms7Fwrf7xUstqDQeZJ/831Qg?=
 =?us-ascii?Q?AHrT5Hhoea963KRxmwvc+xTs7h3jDDmwy6cuoEAPzbCze2I/jD1J0JdE00nh?=
 =?us-ascii?Q?8JUkhP1iq2/nkMAv5HP3WBMstojrhSwGAHUmAyVTe9ejwgGWOogZN7/1oKHq?=
 =?us-ascii?Q?gXWYUgLlg1D3JQv8ytHKjTWuXcYkFH9UcUusaGJ6xYpoqhQVfhtyRM5UtaBo?=
 =?us-ascii?Q?E+CLgpxhhHMPkFaYhCub2XqviDWFDoFIUOif5Mp/6mwhYGvozE1/88Kug/f6?=
 =?us-ascii?Q?i8Ip+TfcXnB8OyuoNL/tfdZ7auSwDB9TUvdaQJmjIKxnVPkVu/X75wezWphi?=
 =?us-ascii?Q?YwcyUPwBXPXXiGWXCJfkYBSCGXjDFs7sNpdm8eOoBNeZcRgMQ+kBDC0CHw3M?=
 =?us-ascii?Q?0giAooLfQrIrOvOMgmG8n/rsthYIg+qCw3n8hsjNr3FtZBMLZLh4+JhIjF2o?=
 =?us-ascii?Q?M9b9a+CPz4Fx+VNCkhsSXlnECKrQ2Mx0IYM7PjgyM/WufkvWwbRagO4F8Bcs?=
 =?us-ascii?Q?88T8Rui1/HKgQq2tkgICF13dQehrvtfhw857nucMvWVWxu4il690S0aoVUdu?=
 =?us-ascii?Q?J6L9aje42joksBmHiVoAdRjr8TNotpKWCu+0R33wHKEQhEPuCldsiNkr5mnD?=
 =?us-ascii?Q?gNoxHrhUA19rkcAf+3NcKQkhRqVlDjWjPBPMHFOQ/9IC1MuGWmxe3VwrKM5+?=
 =?us-ascii?Q?6NLq3/MvzcwkJg7MeruyNC7FSHYrnJRJjtTfyFzBV68ahPqny6nmjHhaXXQg?=
 =?us-ascii?Q?mS7kWPhezOmDMXB4j/afudj8xvnEBFaRJg38Clj6x+lohzd9A75OGSQj/wnO?=
 =?us-ascii?Q?0IZVVPSPZCpZF0GRQ2QBUOzS3WFZ/CUcZ1URSH6YA+mhFG7xeXctwtMps1FE?=
 =?us-ascii?Q?QC6Fj1+UhReDZAV4AQUd8m+vvsKtPa2Z+vkSow4Wd0rZmLQBBXGRJHvtAnqm?=
 =?us-ascii?Q?csHgiAtZu+rrRMLsJ62P/DbeDtSc2BkZ8sxdMrOc0sMfRikfW50dzH/O/tdl?=
 =?us-ascii?Q?Ep2bVYks3d+ffPtxBwQm3xVJ2lalH6UQdOZuQW0i1dbQum+zAwaiL3YtjpSq?=
 =?us-ascii?Q?ybJJ8ADOJcos5uSX+uE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcaf6d6e-4187-4417-1291-08db92e5aef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 23:18:58.3382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zLD37UF9Af+/IutB05oxvOXT646Uz9bT1I+muC63nEsLa2MpWAeg8hpAy4QXyWL2PwYzM6wcEojbDrn0Es+yLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5531
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > +#include "../../entry/calling.h"
>=20
> Rather than do the low level PUSH_REGS and POP_REGS, I vote to have core =
code
> expose a FRED-specific wrapper for invoking external_interrupt().  More b=
elow.

Nice idea!

> > +	/*
> > +	 * A FRED stack frame has extra 16 bytes of information pushed at the
> > +	 * regular stack top compared to an IDT stack frame.
>=20
> There is pretty much no chance that anyone remembers the layout of an IDT=
 stack
> frame off the top of their head.  I.e. saying "FRED has 16 bytes more" is=
n't all
> that useful.  It also fails to capture the fact that FRED stuff a hell of=
 a lot
> more information in those "common" 48 bytes.
>=20
> It'll be hard/impossible to capture all of the overload info in a comment=
, but
> showing the actual layout of the frame would be super helpful, e.g. somet=
hing
> like
> this
>=20
> 	/*
> 	 * FRED stack frames are always 64 bytes:
> 	 *
> 	 * ------------------------------
> 	 * | Bytes  | Usage             |
> 	 * -----------------------------|
> 	 * | 63:56  | Reserved          |
> 	 * | 55:48  | Event Data        |
>          * | 47:40  | SS + Event Info   |
>          * | 39:32  | RSP               |
> 	 * | 31:24  | RFLAGS            |
>          * | 23:16  | CS + Aux Info     |
>          * |  15:8  | RIP               |
>          * |   7:0  | Error Code        |
>          * ------------------------------
> 	 */
> 	 *
> 	 * Use LEA to get the return RIP and push it, then push an error code.
> 	 * Note, only NMI handling does an ERETS to the target!  IRQ handling
> 	 * doesn't need to unmask NMIs and so simply uses CALL+RET, i.e. the
> 	 * RIP pushed here is only truly consumed for NMIs!

I take these as ASM code does need more love, i.e., nice comments :/

Otherwise only more confusion.

=20
>=20
> Jumping way back to providing a wrapper for FRED, if we do that, then the=
re's no
> need to include calling.h, and the weird wrinkle about the ERET target ki=
nda goes
> away too.  E.g. provide this in arch/x86/entry/entry_64_fred.S
>=20
> 	.section .text, "ax"
>=20
> /* Note, this is instrumentation safe, and returns via RET, not ERETS! */
> #if IS_ENABLED(CONFIG_KVM_INTEL)
> SYM_CODE_START(fred_irq_entry_from_kvm)
> 	FRED_ENTER
> 	call external_interrupt
> 	FRED_EXIT
> 	RET
> SYM_CODE_END(fred_irq_entry_from_kvm)
> EXPORT_SYMBOL_GPL(fred_irq_entry_from_kvm);
> #endif
>=20
> and then the KVM side for this particular chunk is more simply:
>=20
> 	lea 1f(%rip), %rax
> 	push %rax
> 	push $0		/* FRED error code, 0 for NMI and external
> interrupts */
>=20
> 	\branch_insn \branch_target
> 1:
> 	VMX_DO_EVENT_FRAME_END
> 	RET
>=20
>=20
> Alternatively, the whole thing could be shoved into
> arch/x86/entry/entry_64_fred.S,
> but at a glance I don't think that would be a net positive due to the nee=
d to
> handle
> IRQs vs. NMIs.
>=20
> > +	\branch_insn \branch_target
> > +
> > +	.if \nmi =3D=3D 0
> > +	POP_REGS
> > +	.endif
> > +
> > +1:
> > +	/*
> > +	 * "Restore" RSP from RBP, even though IRET has already unwound RSP t=
o
>=20
> As mentioned above, this is incorrect on two fronts.
>=20
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 0ecf4be2c6af..4e90c69a92bf 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6890,6 +6890,14 @@ static void vmx_apicv_post_state_restore(struct
> kvm_vcpu *vcpu)
> >  	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
> >  }
> >
> > +#ifdef CONFIG_X86_FRED
> > +void vmx_do_fred_interrupt_irqoff(unsigned int vector);
> > +void vmx_do_fred_nmi_irqoff(unsigned int vector);
> > +#else
> > +#define vmx_do_fred_interrupt_irqoff(x) BUG()
> > +#define vmx_do_fred_nmi_irqoff(x) BUG()
> > +#endif
>=20
> My slight preference is to open code the BUG() as a ud2 in assembly, pure=
ly to
> avoid more #ifdefs.
>=20
> > +
> >  void vmx_do_interrupt_irqoff(unsigned long entry);
> >  void vmx_do_nmi_irqoff(void);
> >
> > @@ -6932,14 +6940,16 @@ static void handle_external_interrupt_irqoff(st=
ruct
> kvm_vcpu *vcpu)
> >  {
> >  	u32 intr_info =3D vmx_get_intr_info(vcpu);
> >  	unsigned int vector =3D intr_info & INTR_INFO_VECTOR_MASK;
> > -	gate_desc *desc =3D (gate_desc *)host_idt_base + vector;
> >
> >  	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
> >  	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
> >  		return;
> >
> >  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> > -	vmx_do_interrupt_irqoff(gate_offset(desc));
> > +	if (cpu_feature_enabled(X86_FEATURE_FRED))
> > +		vmx_do_fred_interrupt_irqoff(vector);	/* Event type is 0 */
>=20
> I strongly prefer to use code to document what's going on.  E.g. the tail=
 comment
> just left me wondering, what event type is 0?  Whereas this makes it quit=
e clear
> that KVM is signaling a hardware interrupt.  The fact that it's a nop as =
far as
> code generation goes is irrelevant.
>=20
> 	vmx_do_fred_interrupt_irqoff((EVENT_TYPE_HWINT << 16) | vector);

Better readability.

>=20
> > +	else
> > +		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base
> + vector));
> >  	kvm_after_interrupt(vcpu);
> >
> >  	vcpu->arch.at_instruction_boundary =3D true;
>=20
> Here's a diff for (hopefully) everything I've suggested above.

Thanks a lot!  I will test it and update the patch in this mail thread.

>=20
> ---
>  arch/x86/entry/entry_64_fred.S | 17 ++++++-
>  arch/x86/kernel/traps.c        |  5 --
>  arch/x86/kvm/vmx/vmenter.S     | 84 +++++++++++++++-------------------
>  arch/x86/kvm/vmx/vmx.c         |  7 +--
>  4 files changed, 55 insertions(+), 58 deletions(-)
>=20
> diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fre=
d.S
> index 12063267d2ac..a973c0bd29f6 100644
> --- a/arch/x86/entry/entry_64_fred.S
> +++ b/arch/x86/entry/entry_64_fred.S
> @@ -10,7 +10,6 @@
>  #include "calling.h"
>=20
>  	.code64
> -	.section ".noinstr.text", "ax"
>=20
>  .macro FRED_ENTER
>  	UNWIND_HINT_END_OF_STACK
> @@ -24,6 +23,22 @@
>  	POP_REGS
>  .endm
>=20
> +	.section .text, "ax"
> +
> +/* Note, this is instrumentation safe, and returns via RET, not ERETS! *=
/
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +SYM_CODE_START(fred_irq_entry_from_kvm)
> +	FRED_ENTER
> +	call external_interrupt
> +	FRED_EXIT
> +	RET
> +SYM_CODE_END(fred_irq_entry_from_kvm)
> +EXPORT_SYMBOL_GPL(fred_irq_entry_from_kvm);
> +#endif
> +
> +	.section ".noinstr.text", "ax"
> +
> +
>  /*
>   * The new RIP value that FRED event delivery establishes is
>   * IA32_FRED_CONFIG & ~FFFH for events that occur in ring 3.
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 21eeba7b188f..cbcb83c71dab 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -1566,11 +1566,6 @@ int external_interrupt(struct pt_regs *regs)
>  	return 0;
>  }
>=20
> -#if IS_ENABLED(CONFIG_KVM_INTEL)
> -/* For KVM VMX to handle IRQs in IRQ induced VM exits. */
> -EXPORT_SYMBOL_GPL(external_interrupt);
> -#endif
> -
>  #endif /* CONFIG_X86_64 */
>=20
>  void __init trap_init(void)
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 79a4c91d9434..e25df565c3f8 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -9,7 +9,6 @@
>  #include <asm/segment.h>
>  #include "kvm-asm-offsets.h"
>  #include "run_flags.h"
> -#include "../../entry/calling.h"
>=20
>  #define WORD_SIZE (BITS_PER_LONG / 8)
>=20
> @@ -33,15 +32,31 @@
>  #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>  #endif
>=20
> +.macro VMX_DO_EVENT_FRAME_BEGIN
> +	/*
> +	 * Unconditionally create a stack frame, getting the correct RSP on the
> +	 * stack (for x86-64) would take two instructions anyways, and RBP can
> +	 * be used to restore RSP to make objtool happy (see below).
> +	 */
> +	push %_ASM_BP
> +	mov %_ASM_SP, %_ASM_BP
> +.endm
> +
> +.macro VMX_DO_EVENT_FRAME_END
> +	/*
> +	 * "Restore" RSP from RBP, even though {E,I}RET has already unwound RSP
> +	 * to the correct value *in most cases*.  KVM's IRQ handling with FRED
> +	 * doesn't do ERETS, and objtool doesn't know the callee will IRET/ERET
> +	 * and, without the explicit restore, thinks the stack is getting wallo=
ped.
> +	 * Using an unwind hint is problematic due to x86-64's dynamic alignmen=
t.
> +	 */
> +	mov %_ASM_BP, %_ASM_SP
> +	pop %_ASM_BP
> +.endm
> +
>  #ifdef CONFIG_X86_FRED
>  .macro VMX_DO_FRED_EVENT_IRQOFF branch_insn branch_target nmi=3D0
> -	/*
> -	 * Unconditionally create a stack frame, getting the correct RSP on the
> -	 * stack (for x86-64) would take two instructions anyways, and RBP can
> -	 * be used to restore RSP to make objtool happy (see below).
> -	 */
> -	push %_ASM_BP
> -	mov %_ASM_SP, %_ASM_BP
> +	VMX_DO_EVENT_FRAME_BEGIN
>=20
>  	/*
>  	 * Don't check the FRED stack level, the call stack leading to this
> @@ -78,43 +93,23 @@
>  	 * push an error code before invoking the IRQ/NMI handler.
>  	 *
>  	 * Use LEA to get the return RIP and push it, then push an error code.
> +	 * Note, only NMI handling does an ERETS to the target!  IRQ handling
> +	 * doesn't need to unmask NMIs and so simply uses CALL+RET, i.e. the
> +	 * RIP pushed here is only truly consumed for NMIs!
>  	 */
>  	lea 1f(%rip), %rax
>  	push %rax
>  	push $0		/* FRED error code, 0 for NMI and external
> interrupts */
>=20
> -	.if \nmi =3D=3D 0
> -	PUSH_REGS
> -	mov %rsp, %rdi
> -	.endif
> -
>  	\branch_insn \branch_target
> -
> -	.if \nmi =3D=3D 0
> -	POP_REGS
> -	.endif
> -
>  1:
> -	/*
> -	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
> -	 * the correct value.  objtool doesn't know the callee will IRET and,
> -	 * without the explicit restore, thinks the stack is getting walloped.
> -	 * Using an unwind hint is problematic due to x86-64's dynamic alignmen=
t.
> -	 */
> -	mov %_ASM_BP, %_ASM_SP
> -	pop %_ASM_BP
> +	VMX_DO_EVENT_FRAME_END
>  	RET
>  .endm
>  #endif
>=20
>  .macro VMX_DO_EVENT_IRQOFF call_insn call_target
> -	/*
> -	 * Unconditionally create a stack frame, getting the correct RSP on the
> -	 * stack (for x86-64) would take two instructions anyways, and RBP can
> -	 * be used to restore RSP to make objtool happy (see below).
> -	 */
> -	push %_ASM_BP
> -	mov %_ASM_SP, %_ASM_BP
> +	VMX_DO_EVENT_FRAME_BEGIN
>=20
>  #ifdef CONFIG_X86_64
>  	/*
> @@ -129,14 +124,7 @@
>  	push $__KERNEL_CS
>  	\call_insn \call_target
>=20
> -	/*
> -	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
> -	 * the correct value.  objtool doesn't know the callee will IRET and,
> -	 * without the explicit restore, thinks the stack is getting walloped.
> -	 * Using an unwind hint is problematic due to x86-64's dynamic alignmen=
t.
> -	 */
> -	mov %_ASM_BP, %_ASM_SP
> -	pop %_ASM_BP
> +	VMX_DO_EVENT_FRAME_END
>  	RET
>  .endm
>=20
> @@ -375,11 +363,13 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit,
> SYM_L_GLOBAL)
>=20
>  SYM_FUNC_END(__vmx_vcpu_run)
>=20
> -#ifdef CONFIG_X86_FRED
>  SYM_FUNC_START(vmx_do_fred_nmi_irqoff)
> +#ifdef CONFIG_X86_FRED
>  	VMX_DO_FRED_EVENT_IRQOFF jmp fred_entrypoint_kernel nmi=3D1
> +#else
> +	ud2
> +#endif
>  SYM_FUNC_END(vmx_do_fred_nmi_irqoff)
> -#endif
>=20
>  SYM_FUNC_START(vmx_do_nmi_irqoff)
>  	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
> @@ -438,11 +428,13 @@ SYM_FUNC_END(vmread_error_trampoline)
>  #endif
>=20
>  .section .text, "ax"
> -#ifdef CONFIG_X86_FRED
>  SYM_FUNC_START(vmx_do_fred_interrupt_irqoff)
> -	VMX_DO_FRED_EVENT_IRQOFF call external_interrupt
> +#ifdef CONFIG_X86_FRED
> +	VMX_DO_FRED_EVENT_IRQOFF call fred_irq_entry_from_kvm
> +#else
> +	ud2
> +#endif
>  SYM_FUNC_END(vmx_do_fred_interrupt_irqoff)
> -#endif
>=20
>  SYM_FUNC_START(vmx_do_interrupt_irqoff)
>  	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bf757f5071e4..cb4675dd87df 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6919,13 +6919,8 @@ static void vmx_apicv_post_state_restore(struct
> kvm_vcpu *vcpu)
>  	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
>  }
>=20
> -#ifdef CONFIG_X86_FRED
>  void vmx_do_fred_interrupt_irqoff(unsigned int vector);
>  void vmx_do_fred_nmi_irqoff(unsigned int vector);
> -#else
> -#define vmx_do_fred_interrupt_irqoff(x) BUG()
> -#define vmx_do_fred_nmi_irqoff(x) BUG()
> -#endif
>=20
>  void vmx_do_interrupt_irqoff(unsigned long entry);
>  void vmx_do_nmi_irqoff(void);
> @@ -6976,7 +6971,7 @@ static void handle_external_interrupt_irqoff(struct
> kvm_vcpu *vcpu)
>=20
>  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
>  	if (cpu_feature_enabled(X86_FEATURE_FRED))
> -		vmx_do_fred_interrupt_irqoff(vector);	/* Event type is 0 */
> +		vmx_do_fred_interrupt_irqoff((EVENT_TYPE_HWINT << 16) |
> vector);
>  	else
>  		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base
> + vector));
>  	kvm_after_interrupt(vcpu);
>=20
> base-commit: 8961078ffe509a97ec7803b17912e57c47b93fa2
> --

