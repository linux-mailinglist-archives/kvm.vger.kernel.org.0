Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED3F7ABC3D
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 01:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjIVXWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 19:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjIVXWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 19:22:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EE619E;
        Fri, 22 Sep 2023 16:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695424915; x=1726960915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eRSQiAA0/fY80IdmbnDj6mU63HiekFWFjAJs7jeFOsA=;
  b=hPYnciC2Zl04lfwZnyVfsPn0ZN+QIuR3h/ooCinOE48vzygkxB8RSGzq
   38n8OJs7Y1EmfPrdvUJXMAdL+RVTUVAeJ6scurKDwJEKC2QphOHUcuLWh
   grVbJsw/33mnvlrg8YecodooWwvs0T5eIiFgJgsuTudfgNUkFLwsX4MES
   jiDY5LFHCLpp1ZLK4YVyhC5izDJlVZ7Mu1kBMkcPZNxIZ0EORcc2M4sFR
   tXLuuiS/yRXrdKeVyiavEjCDo/TJbGrI88UX0hG1Z0pcZ+dNyLbjGDtgO
   lEtvxMjMDEzj8e3jbcCS8Riwz4tswSlyE2h44zaToXUnyzXMP6jwuD0KM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="360348322"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="360348322"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:21:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="777013684"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="777013684"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2023 16:21:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 22 Sep 2023 16:21:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 22 Sep 2023 16:21:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 22 Sep 2023 16:21:54 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 22 Sep 2023 16:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fs0YHcxp47VQTDDTIjZ4i8Yo/or0uwWhmcDCw2NZMRZspO3iIXm2s/tGV6I4ZALiUUc0NRb63VISovDGrWFtyF3X5kUTqUpvEwgnC6wDYQL9gLYfcLyqOMQos1YhYqnloa2/J8JiQc8So1HewPwkNZ/TJBu0merxqYW7kYVy8wDj32AeHk0bklqtWVV5Y0xgwNuLBtOTIjtDAa7jgsLLPYX6PHWGAOZ3BTX/gsycSLc7ToiJaUCJf6en+heNKuinD6Wt7PZfwm4+aKxlSMNp68HmRbmG3yVBUjeaTbAANCVFhxqbCr1wZmOXZuFOqoRr6zUoLh7QmFnyHMp+Y/2Jhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fu86OMXWhzKasKRPAoR0Ot28UCYqUIKz3W7U7EBwKrk=;
 b=bOp7kJ+6Xi0mnWyjoT9ytxVrNGza342hNHoMt3SDBrRWqoduBAMB3dHOpp/XXHPLzniUpldNFjjDCHawElV0BrR7FVnvVBk1rFCIua00tgfIeuZzg8WouKr284+ahLkSk+28Kvjfqa3UCDLEeiDLw36MuJWZGkrDbR6IZzK0liuHEZqUYWdb/EQlcN60baRKpPvXB0nl9rBiZ+mc23ueWSOzpM+nKkM2KWoqwDoHWEvpVf1mcSF+EN1+zBsmLZtt/brxtF0Zk0y5hSDGXh52yOAJWZWKVszJd7P37cN1gYlfVNVEzbTKh4VdpqylLrON8I/rRl0XRCWbXK59M5/99A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB5061.namprd11.prod.outlook.com (2603:10b6:510:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 23:21:51 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 23:21:51 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Thread-Topic: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Thread-Index: AQHZ5ssSXb894LHEBkqZUWtDh9samLAjYtKAgAADDuCAAyUhEIAAclUAgACIVkA=
Date:   Fri, 22 Sep 2023 23:21:50 +0000
Message-ID: <SA1PR11MB6734FA69601B69FBC92361D8A8FFA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
 <dda01248-f456-d8d7-5021-ef6b2e7ade2c@suse.com>
 <SA1PR11MB6734F205C2171425415E4F00A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <SA1PR11MB6734445986E951E686172419A8FFA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <87o7hugsnh.ffs@tglx>
In-Reply-To: <87o7hugsnh.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB5061:EE_
x-ms-office365-filtering-correlation-id: 50fdce97-b9f2-432b-5ece-08dbbbc2b362
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WMfVeQb7hnt9WXGXYpg+0b6XYqDKaFsaWNQVRzwiWUJHT8BRsLSZvlBrP1cYdUDY54503PQ0wF87DSu3ukvLekiuuR0/VRE/S5r0iRhV4mOg1x52upoD2Uq0Zlb/4NdOA/vjefcUSkF5e3sKj2XOV6t2v3pQMYCfJEoQQz+p3Z+anzY3UR1tp+vyhSfePapqIJbNl9Jr6ynUWcjsnKZmGXdKGc4P+0NyAUedx2mWhYuGAqPLOvnTadgKhV66EQU/oinJig6wibYqbz8/qymsV0kG4+zRD49Ny5uQzNHaECKWISq578hsdZjxikDGajFRNx67Aw9hn+X7C9zlJCIDeFe3VCSbeoA+2nwSXAvSNEVe5uAzXAZ/BV0Q8r624NNaKCTiEVYZ2Tg1CAS2WW7AXDNOkz0Nxa8ziCZBfmtHHUh4yLQZkqcTQ2TJgds1PWw7eDUZSH+JTV0jE9mHDP32G+g6QYClvULgw36eNDnrqIRTVS3/UYsAxV1aPRJysSUYweQ3DWN4ujRqbUPWunc1+1zywTg98TjxT/xvoppUAdMGMywzZ0eYxqWpmKwRs3tr/8ePEZw4Xdk3VBAEycixQAK+T8/GnsMcLNNhoZz8U6YbXVaRGpGXybNJlQscLsgsUk/aIT9dH92F1H2gByjOyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199024)(1800799009)(186009)(7416002)(4744005)(478600001)(66476007)(66446008)(83380400001)(66556008)(55016003)(54906003)(64756008)(5660300002)(52536014)(316002)(41300700001)(8936002)(8676002)(2906002)(4326008)(66946007)(110136005)(33656002)(76116006)(86362001)(9686003)(7696005)(6506007)(71200400001)(82960400001)(26005)(122000001)(38070700005)(38100700002)(133343001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OwYLATXwLUsdGqTk5CXv2uEArtiJxY9ytp85Qw4KM6CqtMcLAMYyd02Un+ok?=
 =?us-ascii?Q?FzgHLym8H0/zbF+HMYTUYYZqLfk1HXIspT7bQug0SuG106CaWehEhwJQNLL8?=
 =?us-ascii?Q?eepdex+LZzlVfQfDgcgCpeEhEcb3OMsd5n4SEtH40QV3IMcliEC0Ug6kUOjr?=
 =?us-ascii?Q?ebB0bsxcIN8/f5jgzsYv/PG8QYWLn2xnHfiJkZyvFwfe5P0kDNguxU1MNwAy?=
 =?us-ascii?Q?dvrjCHpv1BoqJdqu7VDMUuu6yoEV3yiFXfwOrM1nJV1ORO57Jl74bfjoKdGK?=
 =?us-ascii?Q?epQCL84F/HF6ONxSiXhkCoWQU9QRT0dPX02uyMbl5UC5W5XL11sv6oHe6Wd6?=
 =?us-ascii?Q?yYALeXQPh8mVSSa2wBSHUl2FlTnfCNIpM3X6x5GOHr+XRgKgE6EPbBEK1vGA?=
 =?us-ascii?Q?zrwGoxKmzWffcXn2zJODBz7wGcclT9xmlg/lIgSBeSeM/JgRFhR9ZzLa8r0n?=
 =?us-ascii?Q?ElVOLnCUVoCMOWUss+0QsikJ1wBsZ59TWGTwcVQ46m1an7VSiPIuMKqlLhZj?=
 =?us-ascii?Q?9og98AkD/Qn+0/W62esy0Q6+IjCBqk27pcDMeShZhGMTLXl0QhgNV61X+MGq?=
 =?us-ascii?Q?ofvNUEgZEA0N10aSxzSOYg5WsM5O4j1eSnGefzkMCXzRrGa440Y2GEEZBsL8?=
 =?us-ascii?Q?EyhV1/vNyE8r+1XYdG87Lfi3HqfP99qFmFUZWEndRgWZBSlcwYODsGbgl4Ja?=
 =?us-ascii?Q?sVmXnHAhygbPPHlaYmVZyLbiAHdD0fwf2EdaR5kI49d3yTz/HwRCw3E3AgSu?=
 =?us-ascii?Q?I2AZEzhnr4fn+3f3vS1IDfeQfsOvjGN1z4PTB6iwQlxUwuWh+MIt/1Y4hOMt?=
 =?us-ascii?Q?9a7C7yD359JqCZ2hBqpW96Sy0jxflrSybrJAloBah3nTHg+X10WWaaKNRqpZ?=
 =?us-ascii?Q?aUbjNYop7fpLiX7E2ODBAMNngvocmsoXNtpepyInp3KtCTjh2S/0rcKbdAO/?=
 =?us-ascii?Q?cMYF0TRqEjJzgHCcRaWgKdHOrIGeRbjIlxMHR9+RdVEWNdDFfMaiIw8Lu7VM?=
 =?us-ascii?Q?B922lSBrJL1WI19YzsGMsDLBJDYyyRCPnzw2ut5irp6hAqDaSPNHMx9cb8gm?=
 =?us-ascii?Q?YNw+5lucUe1YFYLs9XvyZ5LicsukDUWO/9fJmNEo7U4eSTmzscWHJeZBJhGN?=
 =?us-ascii?Q?9E5ebbhrXg7bzD9wyih1Erpnrpq1mzwg1+92u5SYlKOvrzLB8Ps/0aZ0IdL1?=
 =?us-ascii?Q?CbimL65ST+dw3M5jpMCYDAoD5MergPLDUa+vWb9q0Xpkg0w3QtZIj5jp+vca?=
 =?us-ascii?Q?RmwSONEEtbvsFYdFGsZmyeNYJWLVeDw76oDgzjVDIJa/Bj50map8rcFsFpTw?=
 =?us-ascii?Q?in4tqKfSKF7h2DaEKTlmogK7q8H3JqhCP+q58iCtbQI+p0xTq72EADd9iCbj?=
 =?us-ascii?Q?o2HHH0bnYyh8sp8Nz9KmJvmq9RHGmy2JhMrLly5GOMz4g0uY4mrco9Hopioh?=
 =?us-ascii?Q?bos4CsNweoRwp1PRCyoF6WIyxW9mLOj+1gotHY0SiWDOI4P4gGkJZifsCRhz?=
 =?us-ascii?Q?4TnBbC9r0SUaA1tguBqsxWXSroQtk7y/eslMrG7CV9dE113t6BHWbiza5k4k?=
 =?us-ascii?Q?jtMtP9PWCGMOA0E0GL0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fdce97-b9f2-432b-5ece-08dbbbc2b362
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 23:21:51.0298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ad1q9hX2zy5dXs8bhVWM0+WYziBPZ8kgPgQJ8Pq3eIqJTsE4+uDbgSPNV5A4WTf7QaFkOiAVSqjUQQiHzWacFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5061
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > I notice there are several call sites using the safe version w/o
> > checking the return value, should the unsafe version be a better
> > choice in such cases?
>=20
> Depends. The safe version does not emit a warning on fail. So if the
> callsite truly does not care about the error it's fine.

Right. So the _safe suffix also means to suppress a warning that the
caller doesn't care.

Thanks!
    Xin

