Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F276BAEA
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjHARQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjHARQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:16:06 -0400
Received: from mgamail.intel.com (unknown [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BEE1FFC;
        Tue,  1 Aug 2023 10:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690910165; x=1722446165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+CCVzjLnbeSNysyEXz6yi7nFGWkI9dBZ7iOSmBeOerw=;
  b=CtXWK8AUzovkWhxDmPLWDDTeSjDQtcdkyp5XhK5BvhAvpnGXa8fNOy3D
   lg3speXX7HKLsBSkQP3lEoB+9RKcCzKSZTjZqkcMX0icleR5HX0z1c/Nv
   egrMJEZaOI9Qeum33sRgidp7EGiuElPchKQ3+yIykh38tdDaFMfT5r6ii
   ft91AYNoHCY39tPAJhAWVCYw5g0iNCatbRSfXrF0EWqNAgxV8UdwXWgtt
   KLrgZapvmI9Evx2DanKZeluzWpFrYvqd8FgE/JAbhr1Ar/0Gpl6IkxgDA
   Go7S4AX1Ijxj8HHTJaAh3nEfBfttc6Acv6JGh9ow5bZHcTgLmqIToHyKC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="400307988"
X-IronPort-AV: E=Sophos;i="6.01,247,1684825200"; 
   d="scan'208";a="400307988"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 10:09:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="678730789"
X-IronPort-AV: E=Sophos;i="6.01,247,1684825200"; 
   d="scan'208";a="678730789"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 01 Aug 2023 10:09:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 10:09:39 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 10:09:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 10:09:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 10:09:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkCF/TeNkhevV1YALkTdsTqyojOTIoA9Udt5KouUzmStgo5TFsZtoryW7UIXCsyS4osT/JIuW+iZ4fiWt4WGFwDS35E2vFkGhsd5OO3c5SRWSGTzIAmlpDDG2n74lmIuC+lW8Ptyeg5uDxB2o7E6XeVV06YjF9wPv9CTg970KuccEuQT2llJtMNJt00lTN/KroFyS4AHTQ1nlox9WYtnYRLm540gS4pdaeTY3IlQtc9Phi4ixeqNYaa0ONDpXXCG3a4ukmI61wBxgTSohqu1tE1jY+GvG64Y/T/DehwDKOkXf9SNI+PWQdxMbhgJHNImX2MjWejkhu6hxjYKFd3/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CCVzjLnbeSNysyEXz6yi7nFGWkI9dBZ7iOSmBeOerw=;
 b=D3NPIsmaepn+W2gRk4wDV7WsarTPyBYJb7IqBfkaY76bSROZUXlp2+a6nCN3bhB7DTPPE8l2qAp/jZG4ZRhNDLlZGIU/e/skhwknLLaWYanYu+g8iAWPQAxm511bcvat/++vVAXsOmY8jGzk+KjnIR5T0+tUvYuT1owkcFskop6wjJHi619trZmQKCKRUEILhZkEzIuUfjS+IpY7ykjAf1U77fiRfvmXi0cJyU8zUT03zM2u8H4iXbQTTZ0FOQsLul9uOYfGZM4Z1clhcdkYnYDGytZ1DlKaaXY5p1JIIoLKM5J+czSxXsKIpRk6rCwGOIh68CE79OT3NdFyNpSpcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Tue, 1 Aug
 2023 17:09:35 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 17:09:35 +0000
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
Thread-Index: AQHZxFK8XA18LlhFCECR8aoFrmHwB6/VQ+oAgABgJaA=
Date:   Tue, 1 Aug 2023 17:09:35 +0000
Message-ID: <SA1PR11MB6734532B586E631CE59DD1D1A80AA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230801083318.8363-1-xin3.li@intel.com>
 <20230801105236.GB79828@hirez.programming.kicks-ass.net>
In-Reply-To: <20230801105236.GB79828@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB6827:EE_
x-ms-office365-filtering-correlation-id: bf9786ca-6ce3-4e4f-68d8-08db92b214c9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CDKQ0TjGJh/7/cVvM+pqz1HbOAdr5D2EtjMzX1Gx2Vi5AfP0mN/JUocX2BTFvTQLpZG7nDkBUEqyQYAAGI2l/SN7kKCGgYTRnwA7Kdd4mvqiGSInh8xE2AIFNWr5SPJy2EjUYiD1lFBEQb130JvD4Mjht6WUqRpXA1vDQoSJ0vhW7FC/j6WhIiSBFUEviCRWqB9WoYo/l1kEfX7FW7stNtZHvnkfS/qXNv84H/9V6K0yc+6wa2fm1v8AP2mcsGKF5euS+srWr24YfLb1cgsB8USI4HHlShimvUeFshzxcMeXzz7fbg2YuzZzo7kWZSOT+WNKKh4uR31wk2FIqt0tQY0QPW1MvXbsZz/i7vqWq2TxWfs0hT9MphjZAeh2DJuu/GqLExiIBd9OQ3TkoULzC+ZTG/f/gYOPWTjVdXcapz3FkdsPiG6VXNi5b4y5FFYaGmCrt+9Uyb7f+e4f2hKWaQUJ/Z0TV/RagM2I/XD4Q2TKh927AX8B30ZDjLS8LFqWU+s5J6hI647m9CG89Pil3znLv1r5kv7TTxGNzgmHgqE3l4jjVm8fe6RSV7wlMWBHOFJ4UxgaJjKpRZ0BzZLQFT2/HzKXEH9dmeDCLQeGkjtsK0GSc6+S3AD3+K1WZsPX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(478600001)(38100700002)(82960400001)(122000001)(55016003)(86362001)(33656002)(38070700005)(9686003)(7696005)(71200400001)(7416002)(186003)(8676002)(26005)(8936002)(6506007)(7406005)(5660300002)(76116006)(7366002)(52536014)(2906002)(4326008)(66446008)(66556008)(64756008)(6916009)(66946007)(66476007)(54906003)(41300700001)(316002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?81Tp7M1Ra2r7Mk/hI8OqMUQD86NtOytB/N1LDRFjK4VO5A6Tmqt58QWm+DNX?=
 =?us-ascii?Q?ncwjOAgmEANPbQsvM6qvlfSnCIRhvxWpIrNMtRQ7v6SDJv9XR7cjscMn8N4W?=
 =?us-ascii?Q?3v6iUSY2VHDiKHHhy+zWLAZbh9jjpflAryi/1MIBztyq0v5/LhrpAZ/Fevp1?=
 =?us-ascii?Q?sxTMVAcm7A1tjB5QmBX2xe5QIuH9KtRdYPTXD80nN3WiGJUFuc1wpyyWuYlt?=
 =?us-ascii?Q?nKuMYZDWXnUmCViHFM0t9gS9okT1LJK6l3tq+NXmP0rXtxT6aWctvRpQtC5S?=
 =?us-ascii?Q?WHcNFwEx2xkw2fX/mTJMeOZterP3BNcdcRlcG7Q2xwr5f7UsC31ajfjE4qBE?=
 =?us-ascii?Q?ox72dkKunRiCWtPLfhsG3K1wVU+lLelFEmDTNojdLFjrmmDP3Va0nyI1yley?=
 =?us-ascii?Q?IQTlUduKi/WByOo6QAQtTG4DgfMHUfXVc9ZqpSHizZzfQHmHqvtkGCw7QsDG?=
 =?us-ascii?Q?ggnrka5KPKvLGG2NtYxcdGzJUWJcS8mGJKGS4GkGZLOyMLXJ3M1AwITAyLBV?=
 =?us-ascii?Q?V1LGjgCyRsMO2NOpZFZ81QMz8iPEFu0Ji82WfAqh+5cr8x57UyTlDyoujX5V?=
 =?us-ascii?Q?BccV2rjNm436169kADd4aHNwcXOZFPkKSO0xGcq8cQ0A5cnKKxg8t+hvCE3T?=
 =?us-ascii?Q?BBi+CBLaXooEnk4wdLsX43Hk0aAnsdFnJz7MNP55BPD/RNKMpJZfDjqw60X9?=
 =?us-ascii?Q?Qk1pnlcSiUJ6KwlF8g/GRxv2IUfyBels5tvyMPzOac9UmvKSa57pFbzJ+61v?=
 =?us-ascii?Q?uC+aSpU3ZjUNKWsixaxgw24EtMjpgFA7S/MRCRm9PeI6efEubftgRpwToumd?=
 =?us-ascii?Q?PXiE1wD0oBMFa1eq09KG3HQZFA3OASj2iYb6UbRbRszkQZo5lfh4xScCqshK?=
 =?us-ascii?Q?9bxo+92dvyyQEB9Q9Bo+vArHsAMlJMAMFxvM7+jC7WQN1kNPFDRqwG8Wsld6?=
 =?us-ascii?Q?1lcvhidq19e/+DcMyIhGdXLaOKjZKHDFdBIwNMMhbHJEHPIVxXw5nydvWDoW?=
 =?us-ascii?Q?R2IBra0+Vr+ToNElPRe1AC/cXx5XkZQLIsZsOY68pRdesLEGNXpbrHubFI9v?=
 =?us-ascii?Q?VZXodzZ5zBJvruHH7JcFmf641qKLYVlH0VE1R4Aj8T+5Ru46q/oQBfKYdXOT?=
 =?us-ascii?Q?t1gp3XYcHZfBio4zWJNYdIo5AdkXIpzuXztZsF61e1hmq3bCyI/VO2cjkPY0?=
 =?us-ascii?Q?WfRg6Otzupp8axwCAT+qAPLpBJDUUgCviGrjN0IgSeyadVW43M5p6Ul2Edlp?=
 =?us-ascii?Q?FS/0Iip2r/i61WFADtCVL7ebirqQIzdlePzPGhHdhxwxuGjyHLhEFctmA3Ao?=
 =?us-ascii?Q?p96at9KyjsIPNM+3VJI6Rydiz650kNb7jgbLhF1THKxaaZaqibklvwd2em0c?=
 =?us-ascii?Q?6vlSN+2Jb2bGpNSeu+GEXTw5FPnSH305Oy9HiCL12gMSDsZ9TUgz8ogS2CXf?=
 =?us-ascii?Q?RwgLaKy5tG/CP6/DOObNvAGRo9rjrtrukFgxDl0rdpYWw5JdFSOXoim4qpIk?=
 =?us-ascii?Q?qJo5Rgmn+i2KCPth9odVnamVKNHd2fXaB9i3kccf+DqUPiIXKMIU9r48bYfi?=
 =?us-ascii?Q?2oP9NNwXK14SuEpWbIQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9786ca-6ce3-4e4f-68d8-08db92b214c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 17:09:35.3481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dz4UjiirvuvXZbLrF9Wf+pNK1IwNG9f98n0EuAQ9Srl+HrTQFnxuOMeSLtsM1hpe7/6aQDL/a8rzB42L96M0Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
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

> > Resend because the mail system failed to deliver some messages yesterda=
y.
>=20
> The one from yesterday came in 6 thread groups: 0-25, 26, 27, 28, 29, 30-=
36,
> while the one from today comes in 2 thread groups: 0-26, 27-36. Which I
> suppose one can count as an improvement :/

Sigh, sorry for the chaos.

>
> Seriously, it should not be hard to send 36 patches in a single thread.

No, but it worked fine before thus I didn't realize there an email
service policy which prevents sending email to too many recipients
in a short period (I have a long CC list in this v9 patch set).

> I see you're trying to send through the regular corporate email
> trainwreck; do you have a linux.intel.com account? Or really anything
> else besides intel.com? You can try sending the series to yourself to
> see if it arrives correctly as a whole before sending it out to the list
> again.

I did try sending to myself before to LKML, and it worked fine. But
now you know why it happened.

As mentioned, I should avoid "the regular corporate email trainwreck"
before doing it again. Working on it...
