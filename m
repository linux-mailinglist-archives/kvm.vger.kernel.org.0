Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2556C1F0D
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjCTSIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 14:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCTSHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 14:07:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3845242;
        Mon, 20 Mar 2023 11:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679335304; x=1710871304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w9vBtBo4241mMMDibjwNptzg1U9EEP6YDgdFqPjZH5E=;
  b=HbbTCaCRe2MG9p0cp8GFgeKbZsCEM/4GVpbRKTlcq355VoInPCFoP9al
   ift60Lb86IWamUp097etZ55SKhOHKyZOFrYrV8LQNFTeo4WW1zlNMY4kL
   ynz8uBDSuZFwF/frCQMH4jgKvdilOzW4y0HQt1T+ANn/5y4OAlgZ5XgqI
   VosCZsZ4ovc1rHKN1tguunVho10Tzc6GbRy0IT53vfo4j4W8PuKi2JPPM
   rnqdEL8UKOxuPxaikm6X5sHqHiMHWsB88UxC09Vceaw/CFBowN8pHYIBv
   WmF5jVS4t/BsI8GDfd2lhVMN3aK5ioPKl2HmNZ3gPnM3HVTGUuU+VOniX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="319133426"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="319133426"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 10:58:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="804979603"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="804979603"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 20 Mar 2023 10:58:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 10:58:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 10:58:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 10:58:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 10:58:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQXgUVrL4EmST4ArA3FlR6/P2NGyoQiN18DD5WYSgr8tbxmG8sKsQk/7xW+BfnAmarDGmEihtaZHmPghCvirfYV2PElgQQk8DyQ6bkVOofDSKRVxLVayjRXgzMMQupG2XkyPG2UQ9+RRbKprqI36QrIl0oxsPj0DKu7tpkDf1dIB8+H5LFTlSWoZUKenzQVQvpvmuHMjkk2g3GIUNzJb2qAT9RkjQ6Lx+gzurIQ+pk3oGvdxHB/yMn3zH8wAm3s1EM9mMVNWiABNdWgBSS05/AH78VcB0H0yiQ7huuJ5ChCFYxiDLxQR7HuR/d/1yFT64te3abJCFEliX0+Cd57Qkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1ozGqIXT9ElvOi3l8GLNKeucIVZO/NadGpsWT76OrQ=;
 b=a2Xi8vu7bpHQrJvu0+jVLJiWZQtQk8KIUgER3+ke5/VmTOso4jC/StTkSX4iMZHtiKSe8JikPSadO9MiLhQVXvxWYLKuT7+m3NIr45SV1s/Kuf9shYDy16bOROjv7hPRRhVwCMA+BA/y01Bf0D0GwicDHWQmN0gCfJTQiH5NkQdPaXuXF8Sag32exVJLuevvYUnkYuk3Nv579cGHNKtPeFXTyqGj50DyCYclIanSvKD9WVlfHm5phDb7Pc/sjS7cBB3TZL8tW98iU6Lx2uZJIQsmPUXkx2k6O8xJFNDYkjS76isdpNoMi1k1Fh5GfgEUsxoZgTkOD6X/NfCa7TJggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BL1PR11MB5461.namprd11.prod.outlook.com (2603:10b6:208:30b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:58:15 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Mon, 20 Mar 2023
 17:58:14 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 25/34] x86/fred: disallow the swapgs instruction when
 FRED is enabled
Thread-Topic: [PATCH v5 25/34] x86/fred: disallow the swapgs instruction when
 FRED is enabled
Thread-Index: AQHZUKITsQSKyx8aEEG2VJ6si6cGwa8D9+uAgAARsFA=
Date:   Mon, 20 Mar 2023 17:58:14 +0000
Message-ID: <SA1PR11MB6734297C9F3B758D27B7765BA8809@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-26-xin3.li@intel.com>
 <20230320165411.GT2194297@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320165411.GT2194297@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BL1PR11MB5461:EE_
x-ms-office365-filtering-correlation-id: 412281d9-7bbc-4f01-fc4d-08db296cad99
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JbW7sFYY9AvfQJF8cI2uuQsMyq6AGreysq6Ydl6oGVavDl6w63wNh/gmbxgkwW4rspu4rZ7cyvYugYlYWLDF+Xolwr18CvG0xpiCdPcx7d0pq0PvXJHWZ7+aav92Q/wwYepyAAPeKae72bos5ttmcYpYZxD8j1/ub+l8UMjN+R9o4P1E8nQN3SrjkZY5xqcYBCXl8Y2hz+et64mddTCWG9UgCR12gNneuaqt1HzdjHmLteeWkKm5vm8AvaWgrAlXpPucGbvyzSMcPY2JvQCSzye/wUFXRd9OZohu3x4VPM1d7f8ao0/nV86rmT41maDCBmxJKc0YKVwkSV5j/bLL5BqyOtbx2moUQnbq+58002U6+K8lWXQ111n87v8W6j3jGH/9gXknyLjTLnWB0T5zVG7S1wui+UKpk0nP5KRi3ptmEuppeXb8SE5BtNHNAdCVcZK+ZaLpSoH7ZjRjXyccaxV6OxliH7D7ZLHvKt75pHoDjv7jJQiiKqyHheA5AtaGlo13/qaeo9x1EM/yURaRJpqhMuBMn3LoctSAH8PsyT19p2DRdAu/2vS0deticRvvg4FGQNo4OxLlEHOirnbNzqI9hxi66YhcOw/PzTw3xyYcZdEQfbCg35g5kFxqbzdS8ph/5ekV5L06nE2oJj76t/A3csWV9vXpGvzfkajWzmbhytoEWKGEBjDKvW+ZsDpZTOfDyhBNGP43Vv7sxnjDSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199018)(8936002)(5660300002)(4744005)(7416002)(52536014)(55016003)(33656002)(86362001)(38070700005)(122000001)(38100700002)(2906002)(82960400001)(4326008)(478600001)(71200400001)(41300700001)(7696005)(186003)(26005)(6506007)(9686003)(54906003)(316002)(8676002)(76116006)(66446008)(66556008)(66476007)(64756008)(66946007)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BeEqn6ayXIb4o3/+aeTENCsLKL/4cfxivuaKT8ska1fG5pbPtIM7XRRgypT5?=
 =?us-ascii?Q?ko6O+ms/LCpbRjJDFzQP/gbtNqUkcb9kMnRJpLvQSzl8Qsx0DAQmpNJILdkP?=
 =?us-ascii?Q?tJTl8Eci5uR6ZMjocklLkFcXPtCV1Ve999bsF5OdkhNFhV/rBvX6/hSfkGej?=
 =?us-ascii?Q?ThdI1Uda3T2sO4vn0hZvp1lj2M0ODi+b8lnFSYROqTnjM5kMMzdL3RcGHIAJ?=
 =?us-ascii?Q?zZt5T91crUIRHqsWYN++/oK0SBWOlZ8ntYpD72HoDZSwwuYx6h3Riia1LrP+?=
 =?us-ascii?Q?BsLjdluwjuQMJu/5Tn1nbqBV7HrtSdsFoaC7F/6b02VUa971WQFQSPzk36ov?=
 =?us-ascii?Q?QqJWlDM6LNVUUBHWPi0PI8hXyiAdvE597gqYpaHJKtQL2oEEfM30oJqO7vR5?=
 =?us-ascii?Q?Oh8zPp/phW9tLCPUufoG6owjovsSiWbP1C2SC3WUhuvBreCmOJDvq7WPkKea?=
 =?us-ascii?Q?WS9ZbwOR04NMwK6MFKdeo6D9Xdm8+8Lj2uQuKV1mLUpgnSNr3yRh7iqd5LZ+?=
 =?us-ascii?Q?Pz5SbWtZSWKiwxP3MT31/jyHSxim7KQ+aMxjp4tplKSoO0F5S3jQvknrWdbk?=
 =?us-ascii?Q?gZk1VYIq9njnePLEw7JHNTabzHYj++yB1VnN2SoVq6mOy/LSS43W9tuw0Khp?=
 =?us-ascii?Q?x7oejfc/6wgjM7aaQ618ahAAwak0SzXjkRN37lXB6Qwl8ibukKzaexUdN1mE?=
 =?us-ascii?Q?PA7hzS53C/txmqmz/pbug9Fijq5vFCoFu4egAZOuzK7/xyrBEXh/HkqKtOyC?=
 =?us-ascii?Q?6KFhk4scTPTcvk3tzA+WAf69JeFVeN1F7jnFWUL8sWJXN+1FuXC4Rd/ys2kx?=
 =?us-ascii?Q?SaExoiNg31zU4QQXORupJufzJH2LU/NvQMOIwi0TVttPg/6MiZEqgSRUgHT0?=
 =?us-ascii?Q?mHuxDWivk1Rtugfc+ntev+JCX9JdVP9FeDNfIV9SEfNfakvihuK7mawyJJvK?=
 =?us-ascii?Q?KEmOz/YLygtohaq9OH8J6AgHWOEEm/+5GaNEvyMMvYBblr+USkZUcr4gwrgN?=
 =?us-ascii?Q?I355g6aAYwERe033lRjskh0h2faSEIXLUqrqWxDD8IfxMkNEGXOtBjmCQRHZ?=
 =?us-ascii?Q?MktbcVZblsB9YvXZ+pFp+cLjLLp9ySu0W3gVNZvmZjjNyE3l2TlcHr1+LjBe?=
 =?us-ascii?Q?Mf49Uo/TPCwP1dp+rUTRZK1mBWMh4oRvr1zlY0tqIB0Y9IglO0dTN2wPqSml?=
 =?us-ascii?Q?u54PJbl2yG4oMMD1wP2ISNkXSaO7rdDi2j++w35nsbwHGFIgPsFD10gqQEGr?=
 =?us-ascii?Q?O723eBaMf9PEGucXXZHkCi/g8s72c/QEarEoNnBcnGLCfqN71ba8zDWe+LsR?=
 =?us-ascii?Q?0n4EMyfYWdXbwl1OnUtT77i9CgQhVNTTp+Ma/HD8b4PDHOPxTvVfamIyuJhH?=
 =?us-ascii?Q?jmrV2JV+gVLq4gqPxotJa7sF3p5wmK5xjeV+SjbmIWcB7UBPJ/KGq/lLW1Zn?=
 =?us-ascii?Q?PUOycv/ElVu66Jj1SO4pS+TMwDVQg9Vp8CMfqJndkRC/opBr0WzU96QNUOhf?=
 =?us-ascii?Q?53kyNqEdUoOGvMv3SWnDLsdGd+YUmo/pjI8CuZFK85c4EmqMjPBSaUDycGub?=
 =?us-ascii?Q?ofFQVNe/Fr1ik80Lt+o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412281d9-7bbc-4f01-fc4d-08db296cad99
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:58:14.8344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HC/juOsAX1/T24wgIMI5px2tmb3xdg5Kp69ilOX5CkmruTpfaixi3QFsXojGFOV3RAE3pVb78fq1Y2pWvSRlNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5461
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > The FRED architecture establishes the full supervisor/user through:
> > 1) FRED event delivery swaps the value of the GS base address and
> >    that of the IA32_KERNEL_GS_BASE MSR.
> > 2) ERETU swaps the value of the GS base address and that of the
> >    IA32_KERNEL_GS_BASE MSR.
> > Thus, the swapgs instruction is disallowed when FRED is enabled,
> > otherwise it cauess #UD.
>                  ^^^ --- new word :-)

My stupid fingers...
