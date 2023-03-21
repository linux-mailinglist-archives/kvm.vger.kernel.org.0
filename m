Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55A46C2640
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 01:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCUANo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 20:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCUANm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 20:13:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F79A1A95E;
        Mon, 20 Mar 2023 17:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679357619; x=1710893619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5HnXS/28ebTLuZU49GNu/L4weO+y6SOSLlkXeLTgvGU=;
  b=f145pxu4UxQrXZLfvQQcussnaSTTXzwqNcavKjM08UDOf851VQnf1Yrn
   5/q9dNTV3xRLZbn2optDPlcY3y6WWGk7AEvCecBvt5bAXxVF5gjv3DtDS
   54EY4Re2Teyh89gvZWZ6QKIJxi9YFP1yOjqlP9O/QdsQcLR8JSqcX+D84
   y4MRuKKeLBPViqDcXFiXZcpOD7gbXJTCxgwFpdux03PhRMZMz60ndRt1E
   SWXps8qDMUuTj8/Cshc8D79XXr39sNoi7djwfCxSM0ORzGelN1RwosI4V
   ZlxChdXC6YOW06f5LLBPxjrAx1zNFP0T3eHvxBYkvQou3M7m0pW90QFQN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="340354867"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="340354867"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 17:13:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="750319873"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="750319873"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2023 17:13:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 17:13:37 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 17:13:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 17:13:37 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 17:13:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyGa742aZ+0gEhgSJUkXuaEwqqe58f8SuEBaopJNVd0CTepqmXM0pNCaImYDIqrsUmXVMcE8EOKse0x1Nr+0lKQoXS1D+T1qWbdzeNgdB/wl7C4EtyQhJs+b+hGQt6disHis0FqciSErOmpY+QyssZbZ68tiGzFBj6FiKRZqDcgSmmi1bJWChhjt+RqyibR6ZxBegSfXCPx9aVGSVbAep7JSfi84f5aaS3LxjX9OjdiJNU0jIfXdd57FP9ZG9uvmuPtFdYCOz7Y8Ahzaf7quX4Ghn9nGQ0PjsNHFmMJgxz9ofY1VSGDHzeIVFPStu0plUdDRUuYickZeP6EUNgVjSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HnXS/28ebTLuZU49GNu/L4weO+y6SOSLlkXeLTgvGU=;
 b=iBheM6r/wrniwYG32TK237o6+yf2kJiCqBRz+tKW8lFK93waLeHMpwfn7YLnoclw5bOxwJPMYYC7r0CRe80KtRzOvt4S4q5RxEQpeUePxFpZCLt1IZonp3kfnLWSaasj3Fr7yIi9lLdd1tr/22kPB30gwRHvVSAukEdjLpVW7VSaSXMxmXbHz3sDH/vK+aOeEY3bwQfW8hzcDo/Hyb/kShbOGYawCl0ZriY9bIN8Y4M15XKWpwDR6ATTjTaYnhp7yQHhv3O6QKTZS8fkMxYajXQGZPfEWc/72EsB5BQDYVHUoW2qNUyy1zvwl8jKUmC2AISurKayg2Ddu66FWVt2Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB6826.namprd11.prod.outlook.com (2603:10b6:806:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 00:13:35 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Tue, 21 Mar 2023
 00:13:35 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC:     Lai Jiangshan <jiangshanlai@gmail.com>,
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
Thread-Index: AQHZUKIwUYB0dIbGLUidau1bSRiyL67/CYqAgACFIwCABGaLgIAAfS+Q
Date:   Tue, 21 Mar 2023 00:13:34 +0000
Message-ID: <SA1PR11MB67342EF55449288F93C3A78EA8819@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <20230320164431.GQ2194297@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320164431.GQ2194297@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB6826:EE_
x-ms-office365-filtering-correlation-id: b7fed83f-e752-492d-e75c-08db29a11c8d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q09wmy/yNljBgrLMu8GBiqN112wrVJoQP1xOWaYn50OYHqJAUzeSzNW4D3lbODGqt73IB/QSiTaMAa0TfxP9ihUVkJdfrSK9/dd8cWMSSvv5buc5rINVDEkKnkYb4zC4B7P46Jbv18ngp25JeczeRd/JJMXatg9pnGWtCCW47Z7jmPUCQYg+U4npwFMX4NkaNojbLm8yF7Iu54oLBhELtUaAAYvFJgOYAaqtCiqZpS2UbVhX0LIbcEIBe4UocAh1nBeLUmrvNrmpqz1lNU4CQ4Oom8KTzwpvWgDPjMDPa/K5uuD2pkjBJvaHYBvl5p9AKNTrtZCtpRa0g5UV5T1Yrs1LkoZhaI9RNyQ8tsBXjmb6H3bWepkC+4TZHzHwQDSkatDI2mgZK+aB88zbT6VKXjNihRTP5+eT3E37g/7KArdLfNiLztRxtyPRhrfFHtIfzIzaYSBAVvmu0DId6m9YvfVFoL+2gEsNuLNliikMkoLd/hkqyW2y2ImbXcQgD8GX4vQQGd8W7loY9GKjvqMyDDp/EbElbrPv/oqAc640mlQPvdzhE3/qLMowEcMVsKXWJkwVbV8BbguFFfHJPAeZBtTCFVvb3sGnF3UdyRVEA7vC96vInN9mTmVOvmOLLrkpy8nTFRej1vrqbObNjQEAbASq8TzDF4G4gPGCtOhm/Hp6CCuEtuiyGoYhb31i6J2UDfAgsYxqhYGobGLvu5PJkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199018)(33656002)(71200400001)(86362001)(478600001)(316002)(38070700005)(54906003)(110136005)(4326008)(8676002)(66556008)(66946007)(66446008)(66476007)(76116006)(64756008)(7696005)(186003)(38100700002)(26005)(6506007)(41300700001)(9686003)(122000001)(82960400001)(7416002)(52536014)(5660300002)(4744005)(55016003)(8936002)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fykCB1LSxTa7LgNZ3Jt/dd3IYG5BfBR2LL43RT46AoKlpkz4LjOzUGu77dvz?=
 =?us-ascii?Q?ghJHtAcuDkr0F+tdr0cpGrE2zBqJe2Wy4z6O1PfcXaIntVfcKhakUWWtOw2z?=
 =?us-ascii?Q?z/VFPim+mP+WwTi8Kica1Af80rRDtVjOiJUchyPeVSpaHlecbReDo6Vdu/4S?=
 =?us-ascii?Q?z45NRw63Ym6Ye/DcNWuD19NsblLAKCALx24VTo2i2QMMxK/Zmqd5iBqfTG8M?=
 =?us-ascii?Q?N2Hcio7Vl6bAS5XRfpqgQ8DK0tJfjm6IIz/c24MInXr6Brs73+BLM7AssCEo?=
 =?us-ascii?Q?7QEHQKl0ZxYrvpa2JtVwgADynVURGuHmdUYp7WuNyDoWnuSM2OAZUsAxeiHP?=
 =?us-ascii?Q?90hcJ9DO53k3yHBWXeXsrpP6LDjRgUAiAVH9tQ+me1NVM/Us7MN1zioRe0V2?=
 =?us-ascii?Q?LQ8PVh8P3ocY4leea0jNb9w3WS6gAch1y/P+lhLK/FFpC5GTugn1d8QyPTbf?=
 =?us-ascii?Q?8dsuL4wXc48k5C5F8q5V/rV6JRuXnGeEHIKUBpG0CoZoRMKEiYVLDt/p2Sdw?=
 =?us-ascii?Q?6UDoKX2tvtf/e6P7fZQDkxi9Byl6oz7G0tHqB2v26lNG1Q0u8yeYn9MImkUJ?=
 =?us-ascii?Q?CsULTn+P6mdqQ2iF01kuY4Ud6WL+yl67+/8TJrYQc9k9n07RAvk5+1QZcp4L?=
 =?us-ascii?Q?2kBrsmKn4mb21bhxvBhG7E20oV8P+wKn1RTZjDvWd/FujOXlsk/ICO74BQAb?=
 =?us-ascii?Q?I13mEh+P+bMUSU/KHAuYHp4pi49ZUj5sw55sN5H/bw9+89aCKQ5QFxWMldyC?=
 =?us-ascii?Q?9DxR4s7bUJdJi2apIzXg30ftG8TR7j+C7CGaBCu3No1zKp4/BrLXG+wKeckT?=
 =?us-ascii?Q?XfFZNTQ1MAlD73DIfm0+pV4zRffye7wJuRCiMOOkDN37wlbk+gDpSlFmsKJt?=
 =?us-ascii?Q?69EBf+65rkI7JA5/EPOg9D3nS3CCYUEEWw8udw5hGcCnalhIra+MIt7061m4?=
 =?us-ascii?Q?UK5Hy78wjo8qgoCHrzTzXLvKhaksLEM43Uy2E5AdTud82JfXhpfMKj98pUOO?=
 =?us-ascii?Q?F57MtvGHenyMH0D/J0IQvFlZYqC+AudWZEEV8uQ99ytEi2kas9kTlKG6vQq8?=
 =?us-ascii?Q?Z4TdQ1OeT9FX0Ogqlv/NODwUYdtW1pOa+ZeC6VctH2mwzOuocYywlDBFH/li?=
 =?us-ascii?Q?UDtstfn8SU0GPZueJRpXPSC9JzTcRMhWdC4n66lzgbLLV45ZWCtbj4fgk6yH?=
 =?us-ascii?Q?UwDcArpSLPFTI2rSz6lwBhselORMTuZCl91ki/ucS7vOWqyiQDD4J4EjEWFQ?=
 =?us-ascii?Q?ThXZqkJWkXlupwkgKjvoV3I3X767TFICWV0AJq0aEJSLuadbRlIzu9mzL0rb?=
 =?us-ascii?Q?igoYg/Etu/K5NtQJvQNwiHM5+Oe+44JvUQFBtpCF7lXmiWeVOJxUqdzRRGnZ?=
 =?us-ascii?Q?xaPEx5mOcspXQnWvJsqLS19Ye2rPrp+644Z6rhOB54qdEKidKBJ1Gf8C1kvI?=
 =?us-ascii?Q?7kRiPGys6z6wraztm3Bj/ngtc63mUvWQ6Y8ZT9AAKQu8/9bE4eothhRcG2It?=
 =?us-ascii?Q?80SJbEpPLk2SmUwuONREx5t/cD0AVmnzI5MeQX/VqfebNZw6ua+mNyfUzJbA?=
 =?us-ascii?Q?f1ik23ZrUWxROv90Y68=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fed83f-e752-492d-e75c-08db29a11c8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 00:13:34.8123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yRFkVqtMDNz2sW3QQzQl5yAbwr8zjC9lJpV4+cv1nA76fZ1tPlLxaXFo4oGsZsdb9fpcH0LY37Zgq7BZZ4E40Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6826
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > The purpose of separate stacks for NMI, #DB and #MC *in the kernel*
> > (remember that user space faults are always taken on stack level 0) is
> > to avoid overflowing the kernel stack. #DB in the kernel would imply
> > the use of a kernel debugger.
>=20
> Perf (and through it bpf) also has access to #DB. They can set
> breakpoints on kernel instructions/memory just fine provided permission
> etc.

So they are still *kernel* debuggers :)
