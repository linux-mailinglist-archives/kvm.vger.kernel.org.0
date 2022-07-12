Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCC2572036
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiGLQC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 12:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiGLQCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 12:02:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EF8C54B6
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 09:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657641772; x=1689177772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xmd9tVSyVu/76r/T3Jo/5zpADZp/PpZSKEKI6/37dp4=;
  b=Mt1SXPgdJTEi5VJAWxHgZxed0CAHInkIm9tNfMdobtu0JEj8/HYb9c3+
   wSOYE266Uv1e0ClEiy4uN4cJK1ytlnqP9mfRrpfcNR+YhKwr1UXvX1zLn
   5Shx27PK5BAaC4U+UhXan7YvCOKgAafAABf+1xsZygkhuMbhwMI/HP17B
   sSaYxUMjBN3QlxrdwbLuLb7FAAqsChIvnlazj5rocCIoz253vEwDF4aPC
   XVOMvDg7m/NQOCES0nr22x8TLpdaQkRCv+lPyAjgsrpIXlnrMqfjd5UQo
   9mH7Uuegl2ds8B0E4cSHxw4i6pfMtUo34UjsLvV1GzBWTRCfhIr1oB2o0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="268013071"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="268013071"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:02:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="545481536"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 12 Jul 2022 09:02:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 09:02:50 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 09:02:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 09:02:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 09:02:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxOEMJc5xE13mTgN+tnDQgFn8BP3Gg2tXtQZArB8+C7VMu/JZc+kbqUN8+K3h5pylS5gBCO9qZW1WFssERys8XoRNsmS5W4j72kR2TqCUICg0pCqtlewYJGA6ZYYXSLgV+jxpbenno3SlYc05JzGinyX6Glvt2tt2c6DCpfZllM2zaVWe8uVLxU476emguJbO6ljRvfM0eGBD+YDSNuC+Uxt9VvQX+9h7i778Z4sNTs6aEyddEpjnwvFxkMLygby+PM9ZSp07OK3Np3UFCoz8ZNhijAtIGAY+zXt2pt9lEpbLjMsXbhMIc2HPgo399PlrimDskAXwDrdvh8vR8hXsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xmd9tVSyVu/76r/T3Jo/5zpADZp/PpZSKEKI6/37dp4=;
 b=llbqllDUAJewPzzIAvhKFEd94z69wXvCEa6nKyWer2tANYqQVnt3PQCrrws4PFrtNYvtx763kM4iREaD2mzH6ZR8vf/pfLHFHNKI/UosxA9O8zPOJ9qWrkO6nyaPEKErSJLVSuOlSvoTKRerQ8KnlvR7S/U2gowcj57sijDI3GksrSV57fPoBYudSpqiR9HRQd3jD3qAj631EljO4szqfuVKbg0x/NyzQa04sAWOzxLe9UvVHU4ivLzp3Foocqsye1BEMz+W+KbKutDo+9+syPl00Iq8cXQ8HhJ8b8x5X59dizqyrxdNLfyQwUUQe9C4iYm/C7VpHi8a3rm7BBfZ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by BN6PR11MB1937.namprd11.prod.outlook.com (2603:10b6:404:106::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 16:02:41 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19%5]) with mapi id 15.20.5417.023; Tue, 12 Jul 2022
 16:02:41 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     Auger Eric <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>
Subject: RE: Add vfio-platform support for ONESHOT irq forwarding?
Thread-Topic: Add vfio-platform support for ONESHOT irq forwarding?
Thread-Index: AQHYkUykeyYpecz1HEGQmidk7f4H3K1xzn4AgAC38YCAAHt0AIAALFiAgAaskfA=
Date:   Tue, 12 Jul 2022 16:02:41 +0000
Message-ID: <MW3PR11MB45544BF267FD3926F90A2158C7869@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <YsXzGkRIVVYEQNE3@google.com>
 <94423bc0-a6d3-f19f-981b-9da113e36432@semihalf.com>
 <Ysb09r+XXcVZyok4@google.com>
 <aaec2781-2983-6195-2216-bf4aeeb86d7f@semihalf.com>
In-Reply-To: <aaec2781-2983-6195-2216-bf4aeeb86d7f@semihalf.com>
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
x-ms-office365-filtering-correlation-id: 1094e435-11ea-4eaf-47cf-08da641ff34e
x-ms-traffictypediagnostic: BN6PR11MB1937:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yG8bbcEGQbCnNMqFTfObg+pfLLTNlCDOCiMJuHt+xGEYj4tl7MKkLQ9g9SSVD0AJFDJT3pOFAv5LJilhIT4ig2nX/PihWIOMLG81hMDV1dAEqORvTd9a/os94RNXTRD05oeSpMrMfKxxsAIuFxfYLOridSz/5fJtErB41pVz3mNBLnQoaR0m4Dn9hCCZuezBZ105Fj0kx7ZSCECwnkOya8tBUB3OzAkPVISSQh5M1oeq4g3VEUH8vy3He2+Rpowu1xLd8d7IJuZp94R2OlI1rLoo9OYwzNI2EJ1b2aBAhvusO4BC2ZkARsjV3kVHncrqYTICiROQlhNdclr+uJsNu4IHvn5bLiv37rBwu9osE8tT+gvAHM45BVw+2DSSfpgAJ4H/+ZMVy5Qsj5yHvrw78VYWRjSVo/DFHpGJu3Ivj3JLLUG7wDcMK7I/roQm5NH7P+ID9O8owHH8lFh29A8yOBAtaOFCoTSn6FAuUnK3mZtl7hp7aPtpJs300giHYrFeqMhu+SJD0P6Lq9kaPif8/Ef5SJlNE/ZYCKIVwlCqC3CijbaXNr9luexRbLlATaiBeS1VMWnfDfstvyZZ9fHtCLm3B5rbW9zwTQTjVYqwHAwFR7ISa0gI8oU+q7c6x7XF83KK5e252/ur89Zg5E7AAU6zjYfbkCdPBzj8qTgQ4n53mc9Asz35jc5p7/32AbiztUmizsIA0zm6gjY5GC92FLPqt0lk/JSiEZS/Sb3/K2wK1yDasyrbdm5r0PCoBssvYzUmViJCsp2Ra5hmINHOuAkPF1uxWuTT2Nmuoj4leZUteDmh0qRtcYnikiIdAwOA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(366004)(376002)(396003)(136003)(38070700005)(38100700002)(66476007)(76116006)(66556008)(64756008)(66446008)(8676002)(66946007)(5660300002)(4326008)(82960400001)(83380400001)(8936002)(186003)(122000001)(52536014)(7416002)(9686003)(53546011)(2906002)(107886003)(71200400001)(478600001)(7696005)(110136005)(316002)(55016003)(26005)(33656002)(6506007)(41300700001)(86362001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTBMUExYRHgySXdBbUpDVGUzWUZjalpWU3RTRDhhWnM3aGphaG01azlxZ04v?=
 =?utf-8?B?QnFreDJMdnJCTFZtOEhDdFM5dmFac28zS0RvRHVuWHIzc3A3S1dJSDZGa0dj?=
 =?utf-8?B?RTh3b2JubldTbUNLSXhkekNrUHk5eEZkOSt6VWQ5ZXJtSVIwOFVOa0llUyty?=
 =?utf-8?B?bnZoV3M0Y0o4ZStqK0Y4Y0tZZDRsSVA0a2JPSmJPUmNTbEJjOWw0Tll1K0px?=
 =?utf-8?B?dUltYWR1U3NWa25LMUovWmJONWdQSXBiTmNsKytlblFXdWtsRG1XSTk5MFhj?=
 =?utf-8?B?QmlvbVQxN3JaL1A4c1J4Wm5oRWVWVnNoaDEzY1NNY1dzUGM5WFhWVTFMVUdx?=
 =?utf-8?B?amE3YXdBektTYS9nczZtc0MxaVF5cm5TTGtFQnpxYlpQMDZubmxIdEQ2cCtm?=
 =?utf-8?B?R280cGF2ZXYvUzhvS2JlSTlwUXB3TlVoZUVvRTBXczErMzViYW9LTHBYbDFD?=
 =?utf-8?B?Z0c3RTJlMG0zZThRejgyQk5rZ1ZjMVBabTRZQXVSTkJRdzQ1T2R6OU1NQyt1?=
 =?utf-8?B?RVRvZGM0L3B0ZE9FMkU0S1JSeENSRE55b0tqTzlyYUhjU1ZBb2ExME9CdmpU?=
 =?utf-8?B?MUY3KzdvRnE3dmR1Q3RhYXc0RjFzKytCUnhaQkd5Qm1JYmROUGE5MGN5NklE?=
 =?utf-8?B?WXJsblJiY1luSm9SREJPSnRBOHEwQlJNZGtXcEFWd3lKSEVUZ0dleHg3bDBn?=
 =?utf-8?B?Q0pwSlgzd0NhSGt0VHBtemN3ZkV5TDRxZnBYK2YrNWRSVDVlRG5DVHZNbW5F?=
 =?utf-8?B?UWRrMnYySnUvN0tzblZCTU9BSDZ5ZWJtRlRmeHN1TkhiOG9rN0lSTXlZMFcy?=
 =?utf-8?B?TUlRbU5yU011ck5jLzlCK0pqa3VUa1FEWGtQMFdKQ0NQOUpodVlRNlJ4ZVRq?=
 =?utf-8?B?VDZzQ0hWNjNDZ0owNng1NzM1YWowUzRwYnJMeUxiTWVhOVc0OVVtenBxKys5?=
 =?utf-8?B?Qk1rYzh1aEUybWMrVjFiLzR4ck1hUHNidzR1MEVwdjFxcWVTazJEOE9ueEFh?=
 =?utf-8?B?UHY4R0dkUVBwbGI1d1BzSXFCVVR0MjBmdG9qeTI4QU5LWEx6RkphSFRDbTRL?=
 =?utf-8?B?NS9pQkZJb0Rab0ZoTWRadWRncGVBOXZHN3U3L2kzRXpscVJsci9HaUZzSFlB?=
 =?utf-8?B?VUN6aTRLQ1k2SzRVdVkxeUxacis3aFJkYktDR2g1ajFqR25nYmZaNHd3cWhG?=
 =?utf-8?B?bnlUQnhudWZ4b3A3SkNmSC9PQ1pXWVJlaXZUTjNQTEQ2dW12Y0ZWV2p0K2Z0?=
 =?utf-8?B?UDlDc0RKTDRUK1hWcUhOWmhMd05BVlAwNFJBcThMT1FOSjUyRlFzQVVPK3Bi?=
 =?utf-8?B?VlV0Q0lpT0M2bzhSVzhzMzJqTlp2R1EyZmt4aHh5dzlXSUNDQ0duYWxObFoz?=
 =?utf-8?B?dVBSMHYxRXcyN0VrYzhsazY0NEQ4cGtxTWhkbW9CMHlTd0NCZXNIVFZrUHlz?=
 =?utf-8?B?UCtKSFJFR2prWFV6eHNpOWcrS2N6Y2pGT3p1WVpqZ3UyT1VmRHJUNmZ3MmlR?=
 =?utf-8?B?YWY3eTF2anlUNW80QXZnUjR6UlYwZWFDLzBtQTV0NGdNU2RDVkdpdnJ6L0JS?=
 =?utf-8?B?L3kzM2hYVVowd3FWZWlnaU9ZN0puRjh4NGlwaE5vVmF1MVRVT2h6L3c4S1Zo?=
 =?utf-8?B?UnlYZGV3OXBCNFZWT3JKSU9NUzlyYS95SUxZQjVGTURmSUVNMGlieGVXd3BT?=
 =?utf-8?B?ZCs1MlYrbURneklPd1UyNDgxVURvZ0tZbVp1Mm9UNHZYM3Mza2RVUmFaczFi?=
 =?utf-8?B?dndQRDNRSEk0VHpuRHhRcEtWRWJzVVVGZHNIaG95ckRrNGYzeGgzNTM5Ymox?=
 =?utf-8?B?M1BSeERhaDZpeXR6V0hxTjdydkMxSlplaExET2UvY3pxdEUzMHY0ak0yTi90?=
 =?utf-8?B?KzNSTzVqLzVJTGloVDlBU3BreTg2QnJqS1pEN3piMHpad21xaXV5NjgrWXBN?=
 =?utf-8?B?UXR0b2U1TzJ1S2F0LzRWQldQYlllbkpTMFJsZnJuZ0dZZHpzWE0vZHlEVGNC?=
 =?utf-8?B?VGt0RS9JdEkrWFVNUVUvVmpDK1ROVjJLa2NDWm1DRDJzRXhIZ1JhV1l6ZWVQ?=
 =?utf-8?B?d3RXeTI4c3VSUjZQditKdU41UGV1Q0FpeWpOeS9IaHRHN1ZmT2JsUWJKRjBt?=
 =?utf-8?Q?AkJSriANN09MD+AzXjY1AuvqG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1094e435-11ea-4eaf-47cf-08da641ff34e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 16:02:41.4479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eizg6ljb+60q8ki7hX9vOGLPu6R8VqpdZpqSI117O13RQqmiTnFjnXOqM8fHytPgqhPIKoJK1cDwoDGUQU6cWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1937
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgU2VhbiBhbmQgRG15dHJvLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IERteXRybyBNYWx1a2EgPGRteUBzZW1paGFsZi5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBK
dWx5IDcsIDIwMjIgMTA6MzkgQU0NCj4gVG86IENocmlzdG9waGVyc29uLCwgU2VhbiA8c2Vhbmpj
QGdvb2dsZS5jb20+DQo+IENjOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+OyBN
aWNhaCBNb3J0b24NCj4gPG1vcnRvbm1AY2hyb21pdW0ub3JnPjsgQWxleCBXaWxsaWFtc29uDQo+
IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFBhb2xv
IEJvbnppbmkNCj4gPHBib256aW5pQHJlZGhhdC5jb20+OyBMaXUsIFJvbmcgTCA8cm9uZy5sLmxp
dUBpbnRlbC5jb20+OyBUb21hc3oNCj4gTm93aWNraSA8dG5Ac2VtaWhhbGYuY29tPjsgR3J6ZWdv
cnogSmFzemN6eWsgPGphekBzZW1paGFsZi5jb20+Ow0KPiBEbWl0cnkgVG9yb2tob3YgPGR0b3JA
Z29vZ2xlLmNvbT4NCj4gU3ViamVjdDogUmU6IEFkZCB2ZmlvLXBsYXRmb3JtIHN1cHBvcnQgZm9y
IE9ORVNIT1QgaXJxIGZvcndhcmRpbmc/DQo+IA0KPiBPbiA3LzcvMjIgMTc6MDAsIFNlYW4gQ2hy
aXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gT24gVGh1LCBKdWwgMDcsIDIwMjIsIERteXRybyBNYWx1
a2Egd3JvdGU6DQo+ID4+IEhpIFNlYW4sDQo+ID4+DQo+ID4+IE9uIDcvNi8yMiAxMDozOSBQTSwg
U2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPj4+IE9uIFdlZCwgSnVsIDA2LCAyMDIyLCBE
bXl0cm8gTWFsdWthIHdyb3RlOg0KPiA+Pj4+IFRoaXMgaXMgbm90IGEgcHJvYmxlbSBvbiBuYXRp
dmUsIHNpbmNlIGZvciBvbmVzaG90IGlycSB3ZSBrZWVwIHRoZQ0KPiA+Pj4+IGludGVycnVwdCBt
YXNrZWQgdW50aWwgdGhlIHRocmVhZCBleGl0cywgc28gdGhhdCB0aGUgRU9JIGF0IHRoZSBlbmQN
Cj4gPj4+PiBvZiBoYXJkaXJxIGRvZXNuJ3QgcmVzdWx0IGluIGltbWVkaWF0ZSByZS1hc3NlcnQu
IEluIHZmaW8gKyBLVk0NCj4gPj4+PiBjYXNlLCBob3dldmVyLCB0aGUgaG9zdCBkb2Vzbid0IGNo
ZWNrIHRoYXQgdGhlIGludGVycnVwdCBpcyBzdGlsbA0KPiA+Pj4+IG1hc2tlZCBpbiB0aGUgZ3Vl
c3QsIHNvDQo+ID4+Pj4gdmZpb19wbGF0Zm9ybV91bm1hc2soKSBpcyBjYWxsZWQgcmVnYXJkbGVz
cy4NCj4gPj4+DQo+ID4+PiBJc24ndCBub3QgY2hlY2tpbmcgdGhhdCBhbiBpbnRlcnJ1cHQgaXMg
dW5tYXNrZWQgdGhlIHJlYWwgYnVnPw0KPiA+Pj4gRnVkZ2luZyBhcm91bmQgdmZpbyAob3Igd2hh
dGV2ZXIgaXMgZG9pbmcgdGhlIHByZW1hdHVyZSB1bm1hc2tpbmcpDQo+ID4+PiBidWdzIGJ5IGRl
bGF5aW5nIGFuIGFjayBub3RpZmljYXRpb24gaW4gS1ZNIGlzIGEgaGFjaywgbm8/DQo+ID4+DQo+
ID4+IFllcywgbm90IGNoZWNraW5nIHRoYXQgYW4gaW50ZXJydXB0IGlzIHVubWFza2VkIGlzIElN
TyBhIGJ1ZywgYW5kIG15DQo+ID4+IHBhdGNoIGFjdHVhbGx5IGFkZHMgdGhpcyBtaXNzaW5nIGNo
ZWNraW5nLCBvbmx5IHRoYXQgaXQgYWRkcyBpdCBpbg0KPiA+PiBLVk0sIG5vdCBpbiBWRklPLiA6
KQ0KPiA+Pg0KPiA+PiBBcmd1YWJseSBpdCdzIG5vdCBhIGJ1ZyB0aGF0IFZGSU8gaXMgbm90IGNo
ZWNraW5nIHRoZSBndWVzdCBpbnRlcnJ1cHQNCj4gPj4gc3RhdGUgb24gaXRzIG93biwgcHJvdmlk
ZWQgdGhhdCB0aGUgcmVzYW1wbGUgbm90aWZpY2F0aW9uIGl0IHJlY2VpdmVzDQo+ID4+IGlzIGFs
d2F5cyBhIG5vdGlmaWNhdGlvbiB0aGF0IHRoZSBpbnRlcnJ1cHQgaGFzIGJlZW4gYWN0dWFsbHkg
YWNrZWQuDQo+ID4+IFRoYXQgaXMgdGhlIG1vdGl2YXRpb24gYmVoaW5kIHBvc3Rwb25pbmcgYWNr
IG5vdGlmaWNhdGlvbiBpbiBLVk0gaW4NCj4gPj4gbXkgcGF0Y2g6IGl0IGlzIHRvIGVuc3VyZSB0
aGF0IEtWTSAiYWNrIG5vdGlmaWNhdGlvbnMiIGFyZSBhbHdheXMNCj4gPj4gYWN0dWFsIGFjayBu
b3RpZmljYXRpb25zIChhcyB0aGUgbmFtZSBzdWdnZXN0cyksIG5vdCBqdXN0ICJlb2kNCj4gbm90
aWZpY2F0aW9ucyIuDQo+ID4NCj4gPiBCdXQgRU9JIGlzIGFuIEFDSy4gIEl0J3Mgc29mdHdhcmUg
c2F5aW5nICJ0aGlzIGludGVycnVwdCBoYXMgYmVlbg0KPiBjb25zdW1lZCIuDQo+IA0KPiBPaywg
SSBzZWUgd2UndmUgaGFkIHNvbWUgbXV0dWFsIG1pc3VuZGVyc3RhbmRpbmcgb2YgdGhlIHRlcm0g
ImFjayINCj4gaGVyZS4NCj4gRU9JIGlzIGFuIEFDSyBpbiB0aGUgaW50ZXJydXB0IGNvbnRyb2xs
ZXIgc2Vuc2UsIHdoaWxlIEkgd2FzIHRhbGtpbmcgYWJvdXQNCj4gYW4gQUNLIGluIHRoZSBkZXZp
Y2Ugc2Vuc2UsIGkuZS4gYSBkZXZpY2Utc3BlY2lmaWMgYWN0aW9uLCBkb25lIGluIGEgZGV2aWNl
DQo+IGRyaXZlcidzIElSUSBoYW5kbGVyLCB3aGljaCBtYWtlcyB0aGUgZGV2aWNlIGRlLWFzc2Vy
dCB0aGUgSVJRIGxpbmUgKHNvDQo+IHRoYXQgdGhlIElSUSB3aWxsIG5vdCBnZXQgcmUtYXNzZXJ0
ZWQgYWZ0ZXIgYW4gRU9JIG9yIHVubWFzaykuDQo+IA0KPiBTbyB0aGUgcHJvYmxlbSBJJ20gdHJ5
aW5nIHRvIGZpeCBzdGVtcyBmcm9tIHRoZSBwZWN1bGlhcml0eSBvZiAib25lc2hvdCINCj4gaW50
ZXJydXB0czogYW4gQUNLIGluIHRoZSBkZXZpY2Ugc2Vuc2UgaXMgZG9uZSBpbiBhIHRocmVhZGVk
IGhhbmRsZXIsIGkuZS4NCj4gYWZ0ZXIgYW4gQUNLIGluIHRoZSBpbnRlcnJ1cHQgY29udHJvbGxl
ciBzZW5zZSwgbm90IGJlZm9yZSBpdC4NCj4gDQo+IEluIHRoZSBtZWFudGltZSBJJ3ZlIHJlYWxp
emVkIG9uZSBtb3JlIHJlYXNvbiB3aHkgbXkgcGF0Y2ggaXMgd3JvbmcuDQo+IGt2bV9ub3RpZnlf
YWNrZWRfaXJxKCkgaXMgYW4gaW50ZXJuYWwgS1ZNIHRoaW5nIHdoaWNoIGlzIHN1cHBvc2VkIHRv
DQo+IG5vdGlmeSBpbnRlcmVzdGVkIHBhcnRzIG9mIEtWTSBhYm91dCBhbiBBQ0sgcmF0aGVyIGlu
IHRoZSBpbnRlcnJ1cHQNCj4gY29udHJvbGxlciBzZW5zZSwgaS5lLiBhYm91dCBhbiBFT0kgYXMg
aXQgaXMgZG9pbmcgYWxyZWFkeS4NCj4gDQo+IFZGSU8sIG9uIHRoZSBvdGhlciBoYW5kLCByYXRo
ZXIgZXhwZWN0cyBhIG5vdGlmaWNhdGlvbiBhYm91dCBhbiBBQ0sgaW4gdGhlDQo+IGRldmljZSBz
ZW5zZS4gU28gaXQgc3RpbGwgc2VlbXMgYSBnb29kIGlkZWEgdG8gbWUgdG8gcG9zdHBvbmUgc2Vu
ZGluZw0KPiBub3RpZmljYXRpb25zIHRvIFZGSU8gdW50aWwgYW4gSVJRIGdldHMgdW5tYXNrZWQs
IGJ1dCB0aGlzIHBvc3Rwb25pbmcNCj4gc2hvdWxkIGJlIGRvbmUgbm90IGZvciB0aGUgZW50aXJl
IGt2bV9ub3RpZnlfYWNrZWRfaXJxKCkgYnV0IG9ubHkgZm9yDQo+IGV2ZW50ZmRfc2lnbmFsKCkg
b24gcmVzYW1wbGVmZCBpbiBpcnFmZF9yZXNhbXBsZXJfYWNrKCkuDQo+IA0KPiBUaGFua3MgZm9y
IG1ha2luZyBtZSB0aGluayBhYm91dCB0aGF0Lg0KPiANCj4gPg0KPiA+PiBUaGF0IHNhaWQsIHlv
dXIgaWRlYSBvZiBjaGVja2luZyB0aGUgZ3Vlc3QgaW50ZXJydXB0IHN0YXR1cyBpbiBWRklPDQo+
ID4+IChvciB3aGF0ZXZlciBpcyBsaXN0ZW5pbmcgb24gdGhlIHJlc2FtcGxlIGV2ZW50ZmQpIG1h
a2VzIHNlbnNlIHRvIG1lDQo+ID4+IHRvby4gVGhlIHByb2JsZW0sIHRob3VnaCwgaXMgdGhhdCBp
dCdzIEtWTSB0aGF0IGtub3dzIHRoZSBndWVzdA0KPiA+PiBpbnRlcnJ1cHQgc3RhdHVzLCBzbyBL
Vk0gd291bGQgbmVlZCB0byBsZXQgVkZJTy93aGF0ZXZlciBrbm93IGl0DQo+ID4+IHNvbWVob3cu
IChJJ20gYXNzdW1pbmcgd2UgYXJlIGZvY3VzaW5nIG9uIHRoZSBjYXNlIG9mIEtWTSBrZXJuZWwN
Cj4gPj4gaXJxY2hpcCwgbm90IHVzZXJzcGFjZSBvciBzcGxpdCBpcnFjaGlwLikgU28gZG8geW91
IGhhdmUgaW4gbWluZA0KPiA+PiBhZGRpbmcgc29tZXRoaW5nIGxpa2UgIm1hc2tmZCIgYW5kICJ1
bm1hc2tmZCIgdG8gS1ZNIElSUUZEDQo+IGludGVyZmFjZSwNCj4gPj4gaW4gYWRkaXRpb24gdG8g
cmVzYW1wbGVmZD8gSWYgc28sIEknbSBhY3R1YWxseSBpbiBmYXZvciBvZiBzdWNoIGFuDQo+ID4+
IGlkZWEsIGFzIEkgdGhpbmsgaXQgd291bGQgYmUgYWxzbyB1c2VmdWwgZm9yIG90aGVyIHB1cnBv
c2VzLCByZWdhcmRsZXNzDQo+IG9mIG9uZXNob3QgaW50ZXJydXB0cy4NCj4gPg0KPiA+IFVubGVz
cyBJJ20gbWlzcmVhZGluZyB0aGluZ3MsIEtWTSBhbHJlYWR5IHByb3ZpZGVzIGEgbWFzayBub3Rp
ZmllciwNCj4gPiBpcnFmZCBqdXN0IG5lZWRzIHRvIGJlIHdpcmVkIHVwIHRvIHVzZQ0KPiBrdm1f
KHVuKXJlZ2lzdGVyX2lycV9tYXNrX25vdGlmaWVyKCkuDQo+IA0KDQpJbnRlcmVzdGluZy4uLiAg
SSBpbml0aWFsbHkgdGhvdWdodCB0aGF0IGt2bSBkb2Vzbid0ICJ0cmFwIiBvbiBpb2FwaWMncyBt
bWlvDQp3cml0ZS4gIEhvd2V2ZXIsIEkganVzdCB0cmFjZWQga3ZtL2lvYXBpYy5jIGFuZCBpdCB0
dXJucyBvdXQNCmlvYXBpY193cml0ZV9pbmRpcmVjdCgpIHdhcyBjYWxsZWQgbWFueSB0aW1lcy4g
ICBEb2VzIHRyYXBwaW5nIG9uIGlvYXBpYydzIG1taW8NCndyaXRlIGNhdXNlIHZtZXhpdCBvbiBl
ZGdlLXRyaWdnZXJlZCBpbnRlcnJ1cHQgZXhpdD8gIEl0IHNlZW1zIHRoZSBjYXNlIGJlY2F1c2UN
CklPUkVHU0VMIGFuZCBJT1dJTiBvZiBJT0FQSUMgYXJlIG1lbW9yeSBtYXBwZWQgYnV0IG5vdCB0
aGUgcmVkaXJlY3Rpb24gZW50cnkNCnJlZ2lzdGVyIGZvciBlYWNoIElSUSAodGhhdCBpcyB3aHkg
dGhlIG5hbWUgaW5kaXJlY3Rfd3JpdGUpLCBpbiBvcmRlciB0byB1bm1hc2sNCnJlZGlyZWN0aW9u
IGVudHJ5IHJlZ2lzdGVyIG9uIHRoZSBleGl0IG9mIGVhY2ggaW50ZXJydXB0IChlZGdlLXRyaWdn
ZXJlZCBvcg0KbGV2ZWwtdHJpZ2dlcmVkKSwga2VybmVsIG5lZWRzIHRvIHdyaXRlIHRvIElPUkVT
RUwsIHdoaWNoIG1lYW5zIHZtZXhpdCBpZiBrdm0NCnRyYXBzIG9uIGlvYXBpYydzIG1taW8gd3Jp
dGUuICBIb3dldmVyLCBmb3IgcGFzcy10aHJ1IGRldmljZSB3aGljaCB1c2VzDQplZGdlLXRyaWdn
ZXJlZCBpbnRlcnJ1cHQgKGhhbmRsZWQgYnkgdmZpbyBvciBzb21ldGhpbmcgc2ltaWxhciksICBp
bnRlcnJ1cHQNCihwSVJRKSBpcyBlbmFibGVkIGJ5IHZmaW8gYW5kIGl0IHNlZW1zIHVubmVjZXNz
YXJ5IHRvIGNhdXNlIGEgdm1leGl0IHdoZW4gZ3Vlc3QNCnVwZGF0ZXMgdmlydHVhbCBpb2FwaWMu
ICBJIHRoaW5rIHRoZSBzaXR1YXRpb24gaXMgc2ltaWxhciBmb3IgbGV2ZWwtdHJpZ2dlcmVkDQpp
bnRlcnJ1cHQuICBTbyAyIHZtZXhpdHMgZm9yIGVhY2ggbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVw
dCBjb21wbGV0aW9uLCBvbmUgZm9yDQpFT0kgb24gbGFwaWMgYW5kIGFub3RoZXIgZm9yIHVubWFz
ayBvZiBJT0FQSUMgcmVnaXN0ZXIuICBEb2VzIHRoaXMgc291bmQgcmlnaHQ/IA0KSSB0aG91Z2h0
IHdpdGggdmZpbyAob3Igc2ltaWxhciBhcmNoaXRlY3R1cmUpLCB0aGVyZSBpcyBubyB2bWV4aXQg
bmVjZXNzYXJ5IG9uDQplZGdlLXRyaWdnZXJlZCBpbnRlcnJ1cHQgY29tcGxldGlvbiBhbmQgb25s
eSBvbmUgdm1leGl0IGZvciBsZXZlbCB0cmlnZ2VyZWQNCmludGVycnVwdCBjb21wbGV0aW9uLCBl
eGNlcHQgdGhlIGNhdmVhdHMgb2Ygb25lc2hvdCBpbnRlcnJ1cHQuICBNYXliZSBJDQptaXN1bmRl
cnN0YW5kIHNvbWV0aGluZz8NCg0KPiBUaGFua3MgZm9yIHRoZSB0aXAuIEknbGwgdGFrZSBhIGxv
b2sgaW50byBpbXBsZW1lbnRpbmcgdGhpcyBpZGVhLg0KPiANCj4gSXQgc2VlbXMgeW91IGFncmVl
IHRoYXQgZml4aW5nIHRoaXMgaXNzdWUgdmlhIGEgY2hhbmdlIGluIEtWTSAoaW4gaXJxZmQsIG5v
dA0KPiBpbiBpb2FwaWMpIHNlZW1zIHRvIGJlIHRoZSB3YXkgdG8gZ28uDQo+IA0KDQo+IEFuIGlt
bWVkaWF0ZSBwcm9ibGVtIEkgc2VlIHdpdGgga3ZtXyh1bilyZWdpc3Rlcl9pcnFfbWFza19ub3Rp
ZmllcigpDQo+IGlzIHRoYXQgaXQgaXMgY3VycmVudGx5IGF2YWlsYWJsZSBmb3IgeDg2IG9ubHku
IEFsc28sIG1hc2sgbm90aWZpZXJzIGFyZSBjYWxsZWQNCj4gdW5kZXIgaW9hcGljLT5sb2NrIChJ
J20gbm90IHN1cmUgeWV0IGlmIHRoYXQgaXMgZ29vZCBvciBiYWQgbmV3cyBmb3IgdXMpLg0KPiAN
Cj4gVGhhbmtzLA0KPiBEbXl0cm8NCg0K
