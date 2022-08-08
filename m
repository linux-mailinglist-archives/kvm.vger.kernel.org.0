Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D39558CF86
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 23:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbiHHVPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 17:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiHHVP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 17:15:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9350C18B09
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 14:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659993328; x=1691529328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tVlFVtY/A/ngQEehtLByo1ndd1bQYVnV6jnwFzhiGrw=;
  b=QKgRNdEQQ9gg5t6RVTXevFjqk9WU0KrjIfwjQZRdC950jm1J8tWP+Lkt
   HFhFS6qSyfQ+5NxhrV1yJGI9LS+nOfCkwyk/DPQp9JuMwR3LhfneoHykQ
   N+D8T4zSm0KuI0sR/RJxxGcBd4onIO9SafRtmIsr75abvaEUWCJTKQ2ym
   jBeNhDsZBh1MdVRh6yrXrdO+k4gfXvjcjokgeV2Gk2pjDrk2YfXSU7aA/
   yEx3+iQeIBeWjb81XJcKaf9b8gutgb1sOgBMFAlxrOFmwaURjueo+MxEE
   GH8acmszH3dHTYwfpttH5D0YJvZM0C7+aJhxAuvfSbre4z7LXTtaWb7pX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="270469337"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="270469337"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 14:15:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="664141522"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 08 Aug 2022 14:15:27 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 14:15:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 14:15:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 14:15:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 14:15:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gpq0rddiBZZZG16X+XGOQPdyKIRlmo/wz+zAgC3SKDd0Cuc4R/F8GDIl/aQEwv9uYQHw98Vvk330gx4lQl8evqzwFnpDotlaxO5QbrX3A9oIQ6pBYq/JeXIaGBwhXBkoji8aQec4Xj4Xt3wZadHfHzf25n8DRQUng6B38hQSrXcpJkGsGItO55k2BqU1/o8XBF6kHVKhtnQlvXa9w9ZEYpJRdDsf8HccsIGEvTzGvHfnFR+gtNPol9fl6D6HGyX6nI9ejgPvK1q1y+dQNbG21TkcKlcQQPqTxYsfz16pfNqo06khjTXxk+uqMpduaD+w5O+233g2HWgpFAattg6KOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVlFVtY/A/ngQEehtLByo1ndd1bQYVnV6jnwFzhiGrw=;
 b=XdJUvN8vc8lMyWgK1vFyfSheerVh5VEO88E0X6TVc8e7VYR2vRlx2aRSiIXNYciPMn5GHLDL/Q0h16qmp/tC4sGr7/a2UlY772QWWSS3Z/x7gpnaoJaRii6kXwtsTrF8jAbqlFwUs8sRPDP5c00ENtqRC9JR5YxLvp8SOuEMz8xmd/Hvemi6s6vfE6OmAObsElgePRFtOu0i91hz2o0A2H7LRtIKbwCgYv4z30QkGbQtTtdlT2BMX05vYSPnGsLQuttwkfMjt+mqH6Yd2iXgsSmF23TS4SHxn1buVMhcN0xsFN2lYPaJzN6JTYWGQgRuF5wuElQ2O3c3hyX3XWoX+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MWHPR11MB1375.namprd11.prod.outlook.com (2603:10b6:300:23::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 21:15:23 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::1c1b:6692:5ac6:9390]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::1c1b:6692:5ac6:9390%6]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 21:15:23 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: RE: Add vfio-platform support for ONESHOT irq forwarding?
Thread-Topic: Add vfio-platform support for ONESHOT irq forwarding?
Thread-Index: AQHYkUykeyYpecz1HEGQmidk7f4H3K1xzn4AgAC38YCAAHt0AIAALFiAgAaskfCAJSQWgIAGtU3Q
Date:   Mon, 8 Aug 2022 21:15:23 +0000
Message-ID: <MW3PR11MB4554C3C3F07EAD2819E50F7BC7639@MW3PR11MB4554.namprd11.prod.outlook.com>
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
 <MW3PR11MB45544BF267FD3926F90A2158C7869@MW3PR11MB4554.namprd11.prod.outlook.com>
 <00a09605-75d2-2a95-29dc-b5613a52a168@redhat.com>
In-Reply-To: <00a09605-75d2-2a95-29dc-b5613a52a168@redhat.com>
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
x-ms-office365-filtering-correlation-id: ee5794ef-10df-485f-0adf-08da79831b89
x-ms-traffictypediagnostic: MWHPR11MB1375:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m2zFKVcpV5pKfSjYvYakJjbxspi9ue/y+R6Mr7LOM9IWJBW/nD22/isVkwayKB/vXu17cGQyY8yeKGnECFyyCLv317jSwrcslE7+//mcb/dHUAjNSxryZJT4CHIyhksj1Diy+SO+2uGBglba75XyDbiiuscq1i0sZkd2SLwtR1IcXMrp4E+JnQkIwICixUGsu04NYtvlBmuLK49sIjQyC9BpEE73pHOJQgZOCGGhDRV+J3xMJv0xuTz1fkDQlW8vdiWzpessgFpq+nzzPqdm01iQEgOLWUULaix8DhOJ55RzAvrFkdxHxF1yg8UZWD820C24bZ7wFqcEFyR4NtW7s9xbhhllYtPoGyoQkqJ8c/6nfuKtxv9U5fOUfFEAB7U07ASp3pNAPRKUD2FZ+QAJCbIoPDhqsoP+d5Qm9x+7zb+Z+TEVRv4IMNEwFn6vgFDuw0Y4GhF0kUlnSYd/0E+gNVE+kWVO4LlcOJjocKKxFkYovG87VJWaOGngzGfMwXq82N9o6QiN1wzvOWZc3NSk7vN+CPKwsuKoYApZo5oSujqcu1IR8E94Nv8RZuqb1C6o9AgQZI4F11BW7Ks90RzPw1DYJvFISwuSP1dm7vXnQ3BqfyTSDQCyUNMiZBPhrzwIEUExbkhQtR4O4Q921itwYT2Eu7kZXxSlO2RJbOH8e+ZnqZy9bHM0cch7KOLvFgPtsnLsL+b2/jlIGK7VIlP2yfNdS03aUda6+m/3RnkAfkyGMucXZFS8WCukFYFL8THhhoP5pg1inzvgAQnQ5fpYOiqubgXaUIHsWghKpxrJ6wdNKhWlzVTlXY3MWWMAFNRwrUGzE1b9XC8Gl1jIGDwDeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(39860400002)(376002)(346002)(41300700001)(186003)(26005)(6506007)(86362001)(7696005)(9686003)(53546011)(55016003)(122000001)(110136005)(64756008)(8676002)(83380400001)(316002)(54906003)(71200400001)(76116006)(66556008)(7416002)(66446008)(4326008)(66946007)(33656002)(2906002)(478600001)(52536014)(5660300002)(82960400001)(66476007)(38100700002)(38070700005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVFVN1E0aWhUcGw0U3NyTlVnVEFkeWhXeE5ITG10Zmxaa1ZRREdwWThFOUR1?=
 =?utf-8?B?a0Jkb29HRGJtc0NpTTNtNVFSZjhsUGFKcGVhckdNcFZPaFFwQlJ0blcwdmsw?=
 =?utf-8?B?OVdGdTV0ZXkvSGt5cnJMaDVmb2gxOXpoWTVRaStSWldIK3FiKzl2Y3pRN2Y5?=
 =?utf-8?B?YVNFV1o4TjJDS0l4ZVlHZEJIZnVKMlFMRkpyVitYYStiRTNuenE2eDJqNGFJ?=
 =?utf-8?B?Z3N5YnZ1NnB6L3FadVZhaGg5WnhCMWlKZ1dMKzI3MUF4MjNpdUg4cXJOYmZt?=
 =?utf-8?B?SHIvWkI5THMwZTlkdmM1K0pPdkl5Sm9wMndUbzJaNGQvS2grd3JodzN0enZo?=
 =?utf-8?B?aSsvSkV2R1oxSFlBaHl2TlpsakZZWUxsem1iN2Z5ajR3WFhkdkk3eE5EUS82?=
 =?utf-8?B?czgxRmRwKy9CSUgvdEpNaTJ1NWdQVlhES0tQaU9TRXVKcVlOdmYrZFhZU3dZ?=
 =?utf-8?B?ZUxuRnhkUmFBQjdCT1VhbTY4UkRENENDK3FmaHlyRVlGbGxSUmJrYTVFMzZr?=
 =?utf-8?B?M2xac3A1YmlMNUkyb0hSS2JGbVNnOFh4dGRIWEVJZit4UTQ5THJkMmVNN256?=
 =?utf-8?B?UlJEcmsxcWdlRlp2TFp0T3FZdStQZzRlTE5XeFdHUHJja1IrZVlnUXBqUkFP?=
 =?utf-8?B?Y3Q5SzBSajdJU3ViMUJYdFBkVk1rTlNWUFhTK3lHUXJCcFZwZGhqZ3F2Vlht?=
 =?utf-8?B?eS9Qc3VzUm9MRENQV2cwdUo5Y3haTFUxZy9KY2x2c1ZMaDkyZFdIZDJNSTBy?=
 =?utf-8?B?SHZab1kxUVZpUktXYWxxQThRQXViM2FJMWhiZUVsQlI3NHoyejFTUmdGMGkv?=
 =?utf-8?B?TEhkTDJpRUJ3QmJBUEc5VUEraExDSlpvc3pNVlVpZXRoYWFpZTEvb1NjYmxv?=
 =?utf-8?B?aTNIN0ExY25LTHFlMEtkdWkxTUpJbWtYUHh6ajJ3YlJ1YVFXbmsyUEw0anBa?=
 =?utf-8?B?cVdkMnNFZ3k5emNvZVFqUDlMcDdHZ3ZLeUZMM3BtN3RibGZKaGlydUpKSGVI?=
 =?utf-8?B?QytYWEp2RElRUDVhWU40L1NTRVp0MEd0YWl4RDNzM2dxc0pFcFhKZW53MmFh?=
 =?utf-8?B?djlxQ3J1TlIyTlg0WHZiUHl6Ky9xaVhIMm01K083RHc3QndON1Y5RUxRWlR4?=
 =?utf-8?B?c2syQURZdW4vRkg2QlRzSmlUYjBNdWlRaDk2ckk4YjJ2SExqWFA0YmU2UHR4?=
 =?utf-8?B?S29uNUdTdWh3VXgwT2tTUlR3UTMzaWdLa0xFeVhNNWZOZGhIeC9uOU4wYUl1?=
 =?utf-8?B?Qmh0amVubEpLVGM2Zk5OeXhqVkVwdFV3M2xGaHM4ZmRwZEhKMUt0bHhHQ3E3?=
 =?utf-8?B?cFFJL1ArcWJyMytkMnVCZ2hSNVJPQ05RZ0dvRTFkQzI1dnBUYU12Vytvd0V0?=
 =?utf-8?B?eVBscnEzbkpjdEZ3ZE1YNWRxemZWcUJDL3Jvb3VlKzlLTUdaVVYrajVHSVJZ?=
 =?utf-8?B?N1E0cG0wTC8wZ282QzJpVFU3aXRDR1NEejRScWdLRC9USkthS2ZnUU91aVpi?=
 =?utf-8?B?TTA1UmswdWxuWE92UTBUM1F0RUZIamdFeUtVSGxRaEs3QTFQR1lDTlA0MFhs?=
 =?utf-8?B?amVQY05Gdk5XdnZvcFhHZWN5SmI3Y0FJaCtIODdsaXFtb0xMa29xRlB5Z05M?=
 =?utf-8?B?U3dVeGwyKzNWcWNtREpNZk54UW56MlBDdm1mK0U4RmNLTmhxRmR5eTlsblVV?=
 =?utf-8?B?Qjh1ekNvNEEwVG1LWEQ0Y1RpMHIrN0R5bmNOZkJzckxyMGhtd3VVZmYwWDdZ?=
 =?utf-8?B?aS9OdXkyMWdEZzNISWVHVnVHdzNBRzY0cmRGK25jclZZSDF0akR5YVRPbkcz?=
 =?utf-8?B?aUdaZURmRm5IeGtqWEVMeStuNjE2dDg1RUpsdFZHRnJRLyszcUw4UFFhVWhV?=
 =?utf-8?B?UVhKNWg0cldETldhMVFlRi9IUnd3akgwK1pzM0RjaStMVVF5SE9CUG94K0Jz?=
 =?utf-8?B?YzhXVlQ0UDU3THpQSVV1YXh2VE5WWE1BLzI5dFhTNmFjK1czNzJzWHBWMUkr?=
 =?utf-8?B?QXdVOUo4UTY0eC9VRVZxMTE0elZDdjM0WXhEN2gwbWhsaVM5UitMQXppR3ow?=
 =?utf-8?B?Y1RXZm5Ed0ZHZWpIQ1NWVUlTU3hwYnNud05ObzZneFN5anBEYXhHeG1SdFg0?=
 =?utf-8?Q?YwJTkTgj5AF/c5wErvjPL9xnf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5794ef-10df-485f-0adf-08da79831b89
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 21:15:23.5676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wv5FvTbMo/RTqHhPbffgRIMvsyYGUVPLV5+3hJLjYG1rnWzO62lXnYzIzljPwIi5QhvKprq93TomTUaY0kd0vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1375
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgNCwg
MjAyMiA3OjQ1IEFNDQo+IFRvOiBMaXUsIFJvbmcgTCA8cm9uZy5sLmxpdUBpbnRlbC5jb20+OyBE
bXl0cm8gTWFsdWthDQo+IDxkbXlAc2VtaWhhbGYuY29tPjsgQ2hyaXN0b3BoZXJzb24sLCBTZWFu
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ2M6IE1pY2FoIE1vcnRvbiA8bW9ydG9ubUBjaHJvbWl1
bS5vcmc+OyBBbGV4IFdpbGxpYW1zb24NCj4gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPjsg
a3ZtQHZnZXIua2VybmVsLm9yZzsgUGFvbG8gQm9uemluaQ0KPiA8cGJvbnppbmlAcmVkaGF0LmNv
bT47IFRvbWFzeiBOb3dpY2tpIDx0bkBzZW1paGFsZi5jb20+OyBHcnplZ29yeg0KPiBKYXN6Y3p5
ayA8amF6QHNlbWloYWxmLmNvbT47IERtaXRyeSBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29tPg0K
PiBTdWJqZWN0OiBSZTogQWRkIHZmaW8tcGxhdGZvcm0gc3VwcG9ydCBmb3IgT05FU0hPVCBpcnEg
Zm9yd2FyZGluZz8NCj4gDQo+IEhpLA0KPiBPbiA3LzEyLzIyIDE4OjAyLCBMaXUsIFJvbmcgTCB3
cm90ZToNCj4gPiBIaSBTZWFuIGFuZCBEbXl0cm8sDQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogRG15dHJvIE1hbHVrYSA8ZG15QHNlbWloYWxmLmNvbT4N
Cj4gPj4gU2VudDogVGh1cnNkYXksIEp1bHkgNywgMjAyMiAxMDozOSBBTQ0KPiA+PiBUbzogQ2hy
aXN0b3BoZXJzb24sLCBTZWFuIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gPj4gQ2M6IEF1Z2VyIEVy
aWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT47IE1pY2FoIE1vcnRvbg0KPiA+PiA8bW9ydG9ubUBj
aHJvbWl1bS5vcmc+OyBBbGV4IFdpbGxpYW1zb24NCj4gPj4gPGFsZXgud2lsbGlhbXNvbkByZWRo
YXQuY29tPjsga3ZtQHZnZXIua2VybmVsLm9yZzsgUGFvbG8gQm9uemluaQ0KPiA+PiA8cGJvbnpp
bmlAcmVkaGF0LmNvbT47IExpdSwgUm9uZyBMIDxyb25nLmwubGl1QGludGVsLmNvbT47IFRvbWFz
eg0KPiA+PiBOb3dpY2tpIDx0bkBzZW1paGFsZi5jb20+OyBHcnplZ29yeiBKYXN6Y3p5ayA8amF6
QHNlbWloYWxmLmNvbT47DQo+ID4+IERtaXRyeSBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29tPg0K
PiA+PiBTdWJqZWN0OiBSZTogQWRkIHZmaW8tcGxhdGZvcm0gc3VwcG9ydCBmb3IgT05FU0hPVCBp
cnEgZm9yd2FyZGluZz8NCj4gPj4NCj4gPj4gT24gNy83LzIyIDE3OjAwLCBTZWFuIENocmlzdG9w
aGVyc29uIHdyb3RlOg0KPiA+Pj4gT24gVGh1LCBKdWwgMDcsIDIwMjIsIERteXRybyBNYWx1a2Eg
d3JvdGU6DQo+ID4+Pj4gSGkgU2VhbiwNCj4gPj4+Pg0KPiA+Pj4+IE9uIDcvNi8yMiAxMDozOSBQ
TSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPj4+Pj4gT24gV2VkLCBKdWwgMDYsIDIw
MjIsIERteXRybyBNYWx1a2Egd3JvdGU6DQo+ID4+Pj4+PiBUaGlzIGlzIG5vdCBhIHByb2JsZW0g
b24gbmF0aXZlLCBzaW5jZSBmb3Igb25lc2hvdCBpcnEgd2Uga2VlcCB0aGUNCj4gPj4+Pj4+IGlu
dGVycnVwdCBtYXNrZWQgdW50aWwgdGhlIHRocmVhZCBleGl0cywgc28gdGhhdCB0aGUgRU9JIGF0
IHRoZSBlbmQNCj4gPj4+Pj4+IG9mIGhhcmRpcnEgZG9lc24ndCByZXN1bHQgaW4gaW1tZWRpYXRl
IHJlLWFzc2VydC4gSW4gdmZpbyArIEtWTQ0KPiA+Pj4+Pj4gY2FzZSwgaG93ZXZlciwgdGhlIGhv
c3QgZG9lc24ndCBjaGVjayB0aGF0IHRoZSBpbnRlcnJ1cHQgaXMgc3RpbGwNCj4gPj4+Pj4+IG1h
c2tlZCBpbiB0aGUgZ3Vlc3QsIHNvDQo+ID4+Pj4+PiB2ZmlvX3BsYXRmb3JtX3VubWFzaygpIGlz
IGNhbGxlZCByZWdhcmRsZXNzLg0KPiA+Pj4+PiBJc24ndCBub3QgY2hlY2tpbmcgdGhhdCBhbiBp
bnRlcnJ1cHQgaXMgdW5tYXNrZWQgdGhlIHJlYWwgYnVnPw0KPiA+Pj4+PiBGdWRnaW5nIGFyb3Vu
ZCB2ZmlvIChvciB3aGF0ZXZlciBpcyBkb2luZyB0aGUgcHJlbWF0dXJlDQo+IHVubWFza2luZykN
Cj4gPj4+Pj4gYnVncyBieSBkZWxheWluZyBhbiBhY2sgbm90aWZpY2F0aW9uIGluIEtWTSBpcyBh
IGhhY2ssIG5vPw0KPiA+Pj4+IFllcywgbm90IGNoZWNraW5nIHRoYXQgYW4gaW50ZXJydXB0IGlz
IHVubWFza2VkIGlzIElNTyBhIGJ1ZywgYW5kDQo+IG15DQo+ID4+Pj4gcGF0Y2ggYWN0dWFsbHkg
YWRkcyB0aGlzIG1pc3NpbmcgY2hlY2tpbmcsIG9ubHkgdGhhdCBpdCBhZGRzIGl0IGluDQo+ID4+
Pj4gS1ZNLCBub3QgaW4gVkZJTy4gOikNCj4gPj4+Pg0KPiA+Pj4+IEFyZ3VhYmx5IGl0J3Mgbm90
IGEgYnVnIHRoYXQgVkZJTyBpcyBub3QgY2hlY2tpbmcgdGhlIGd1ZXN0IGludGVycnVwdA0KPiA+
Pj4+IHN0YXRlIG9uIGl0cyBvd24sIHByb3ZpZGVkIHRoYXQgdGhlIHJlc2FtcGxlIG5vdGlmaWNh
dGlvbiBpdCByZWNlaXZlcw0KPiA+Pj4+IGlzIGFsd2F5cyBhIG5vdGlmaWNhdGlvbiB0aGF0IHRo
ZSBpbnRlcnJ1cHQgaGFzIGJlZW4gYWN0dWFsbHkgYWNrZWQuDQo+ID4+Pj4gVGhhdCBpcyB0aGUg
bW90aXZhdGlvbiBiZWhpbmQgcG9zdHBvbmluZyBhY2sgbm90aWZpY2F0aW9uIGluIEtWTSBpbg0K
PiA+Pj4+IG15IHBhdGNoOiBpdCBpcyB0byBlbnN1cmUgdGhhdCBLVk0gImFjayBub3RpZmljYXRp
b25zIiBhcmUgYWx3YXlzDQo+ID4+Pj4gYWN0dWFsIGFjayBub3RpZmljYXRpb25zIChhcyB0aGUg
bmFtZSBzdWdnZXN0cyksIG5vdCBqdXN0ICJlb2kNCj4gPj4gbm90aWZpY2F0aW9ucyIuDQo+ID4+
PiBCdXQgRU9JIGlzIGFuIEFDSy4gIEl0J3Mgc29mdHdhcmUgc2F5aW5nICJ0aGlzIGludGVycnVw
dCBoYXMgYmVlbg0KPiA+PiBjb25zdW1lZCIuDQo+ID4+DQo+ID4+IE9rLCBJIHNlZSB3ZSd2ZSBo
YWQgc29tZSBtdXR1YWwgbWlzdW5kZXJzdGFuZGluZyBvZiB0aGUgdGVybSAiYWNrIg0KPiA+PiBo
ZXJlLg0KPiA+PiBFT0kgaXMgYW4gQUNLIGluIHRoZSBpbnRlcnJ1cHQgY29udHJvbGxlciBzZW5z
ZSwgd2hpbGUgSSB3YXMgdGFsa2luZw0KPiBhYm91dA0KPiA+PiBhbiBBQ0sgaW4gdGhlIGRldmlj
ZSBzZW5zZSwgaS5lLiBhIGRldmljZS1zcGVjaWZpYyBhY3Rpb24sIGRvbmUgaW4gYQ0KPiBkZXZp
Y2UNCj4gPj4gZHJpdmVyJ3MgSVJRIGhhbmRsZXIsIHdoaWNoIG1ha2VzIHRoZSBkZXZpY2UgZGUt
YXNzZXJ0IHRoZSBJUlEgbGluZSAoc28NCj4gPj4gdGhhdCB0aGUgSVJRIHdpbGwgbm90IGdldCBy
ZS1hc3NlcnRlZCBhZnRlciBhbiBFT0kgb3IgdW5tYXNrKS4NCj4gPj4NCj4gPj4gU28gdGhlIHBy
b2JsZW0gSSdtIHRyeWluZyB0byBmaXggc3RlbXMgZnJvbSB0aGUgcGVjdWxpYXJpdHkgb2YNCj4g
Im9uZXNob3QiDQo+ID4+IGludGVycnVwdHM6IGFuIEFDSyBpbiB0aGUgZGV2aWNlIHNlbnNlIGlz
IGRvbmUgaW4gYSB0aHJlYWRlZCBoYW5kbGVyLA0KPiBpLmUuDQo+ID4+IGFmdGVyIGFuIEFDSyBp
biB0aGUgaW50ZXJydXB0IGNvbnRyb2xsZXIgc2Vuc2UsIG5vdCBiZWZvcmUgaXQuDQo+ID4+DQo+
ID4+IEluIHRoZSBtZWFudGltZSBJJ3ZlIHJlYWxpemVkIG9uZSBtb3JlIHJlYXNvbiB3aHkgbXkg
cGF0Y2ggaXMgd3JvbmcuDQo+ID4+IGt2bV9ub3RpZnlfYWNrZWRfaXJxKCkgaXMgYW4gaW50ZXJu
YWwgS1ZNIHRoaW5nIHdoaWNoIGlzIHN1cHBvc2VkIHRvDQo+ID4+IG5vdGlmeSBpbnRlcmVzdGVk
IHBhcnRzIG9mIEtWTSBhYm91dCBhbiBBQ0sgcmF0aGVyIGluIHRoZSBpbnRlcnJ1cHQNCj4gPj4g
Y29udHJvbGxlciBzZW5zZSwgaS5lLiBhYm91dCBhbiBFT0kgYXMgaXQgaXMgZG9pbmcgYWxyZWFk
eS4NCj4gPj4NCj4gPj4gVkZJTywgb24gdGhlIG90aGVyIGhhbmQsIHJhdGhlciBleHBlY3RzIGEg
bm90aWZpY2F0aW9uIGFib3V0IGFuIEFDSyBpbg0KPiB0aGUNCj4gPj4gZGV2aWNlIHNlbnNlLiBT
byBpdCBzdGlsbCBzZWVtcyBhIGdvb2QgaWRlYSB0byBtZSB0byBwb3N0cG9uZSBzZW5kaW5nDQo+
ID4+IG5vdGlmaWNhdGlvbnMgdG8gVkZJTyB1bnRpbCBhbiBJUlEgZ2V0cyB1bm1hc2tlZCwgYnV0
IHRoaXMgcG9zdHBvbmluZw0KPiA+PiBzaG91bGQgYmUgZG9uZSBub3QgZm9yIHRoZSBlbnRpcmUg
a3ZtX25vdGlmeV9hY2tlZF9pcnEoKSBidXQgb25seSBmb3INCj4gPj4gZXZlbnRmZF9zaWduYWwo
KSBvbiByZXNhbXBsZWZkIGluIGlycWZkX3Jlc2FtcGxlcl9hY2soKS4NCj4gPj4NCj4gPj4gVGhh
bmtzIGZvciBtYWtpbmcgbWUgdGhpbmsgYWJvdXQgdGhhdC4NCj4gPj4NCj4gPj4+PiBUaGF0IHNh
aWQsIHlvdXIgaWRlYSBvZiBjaGVja2luZyB0aGUgZ3Vlc3QgaW50ZXJydXB0IHN0YXR1cyBpbiBW
RklPDQo+ID4+Pj4gKG9yIHdoYXRldmVyIGlzIGxpc3RlbmluZyBvbiB0aGUgcmVzYW1wbGUgZXZl
bnRmZCkgbWFrZXMgc2Vuc2UgdG8NCj4gbWUNCj4gPj4+PiB0b28uIFRoZSBwcm9ibGVtLCB0aG91
Z2gsIGlzIHRoYXQgaXQncyBLVk0gdGhhdCBrbm93cyB0aGUgZ3Vlc3QNCj4gPj4+PiBpbnRlcnJ1
cHQgc3RhdHVzLCBzbyBLVk0gd291bGQgbmVlZCB0byBsZXQgVkZJTy93aGF0ZXZlciBrbm93IGl0
DQo+ID4+Pj4gc29tZWhvdy4gKEknbSBhc3N1bWluZyB3ZSBhcmUgZm9jdXNpbmcgb24gdGhlIGNh
c2Ugb2YgS1ZNIGtlcm5lbA0KPiA+Pj4+IGlycWNoaXAsIG5vdCB1c2Vyc3BhY2Ugb3Igc3BsaXQg
aXJxY2hpcC4pIFNvIGRvIHlvdSBoYXZlIGluIG1pbmQNCj4gPj4+PiBhZGRpbmcgc29tZXRoaW5n
IGxpa2UgIm1hc2tmZCIgYW5kICJ1bm1hc2tmZCIgdG8gS1ZNIElSUUZEDQo+ID4+IGludGVyZmFj
ZSwNCj4gPj4+PiBpbiBhZGRpdGlvbiB0byByZXNhbXBsZWZkPyBJZiBzbywgSSdtIGFjdHVhbGx5
IGluIGZhdm9yIG9mIHN1Y2ggYW4NCj4gPj4+PiBpZGVhLCBhcyBJIHRoaW5rIGl0IHdvdWxkIGJl
IGFsc28gdXNlZnVsIGZvciBvdGhlciBwdXJwb3NlcywgcmVnYXJkbGVzcw0KPiA+PiBvZiBvbmVz
aG90IGludGVycnVwdHMuDQo+ID4+PiBVbmxlc3MgSSdtIG1pc3JlYWRpbmcgdGhpbmdzLCBLVk0g
YWxyZWFkeSBwcm92aWRlcyBhIG1hc2sgbm90aWZpZXIsDQo+ID4+PiBpcnFmZCBqdXN0IG5lZWRz
IHRvIGJlIHdpcmVkIHVwIHRvIHVzZQ0KPiA+PiBrdm1fKHVuKXJlZ2lzdGVyX2lycV9tYXNrX25v
dGlmaWVyKCkuDQo+ID4+DQo+ID4gSW50ZXJlc3RpbmcuLi4gIEkgaW5pdGlhbGx5IHRob3VnaHQg
dGhhdCBrdm0gZG9lc24ndCAidHJhcCIgb24gaW9hcGljJ3MNCj4gbW1pbw0KPiA+IHdyaXRlLiAg
SG93ZXZlciwgSSBqdXN0IHRyYWNlZCBrdm0vaW9hcGljLmMgYW5kIGl0IHR1cm5zIG91dA0KPiA+
IGlvYXBpY193cml0ZV9pbmRpcmVjdCgpIHdhcyBjYWxsZWQgbWFueSB0aW1lcy4gICBEb2VzIHRy
YXBwaW5nIG9uDQo+IGlvYXBpYydzIG1taW8NCj4gPiB3cml0ZSBjYXVzZSB2bWV4aXQgb24gZWRn
ZS10cmlnZ2VyZWQgaW50ZXJydXB0IGV4aXQ/ICBJdCBzZWVtcyB0aGUgY2FzZQ0KPiBiZWNhdXNl
DQo+ID4gSU9SRUdTRUwgYW5kIElPV0lOIG9mIElPQVBJQyBhcmUgbWVtb3J5IG1hcHBlZCBidXQg
bm90IHRoZQ0KPiByZWRpcmVjdGlvbiBlbnRyeQ0KPiA+IHJlZ2lzdGVyIGZvciBlYWNoIElSUSAo
dGhhdCBpcyB3aHkgdGhlIG5hbWUgaW5kaXJlY3Rfd3JpdGUpLCBpbiBvcmRlciB0bw0KPiB1bm1h
c2sNCj4gPiByZWRpcmVjdGlvbiBlbnRyeSByZWdpc3RlciBvbiB0aGUgZXhpdCBvZiBlYWNoIGlu
dGVycnVwdCAoZWRnZS10cmlnZ2VyZWQNCj4gb3INCj4gPiBsZXZlbC10cmlnZ2VyZWQpLCBrZXJu
ZWwgbmVlZHMgdG8gd3JpdGUgdG8gSU9SRVNFTCwgd2hpY2ggbWVhbnMgdm1leGl0DQo+IGlmIGt2
bQ0KPiA+IHRyYXBzIG9uIGlvYXBpYydzIG1taW8gd3JpdGUuICBIb3dldmVyLCBmb3IgcGFzcy10
aHJ1IGRldmljZSB3aGljaA0KPiB1c2VzDQo+ID4gZWRnZS10cmlnZ2VyZWQgaW50ZXJydXB0ICho
YW5kbGVkIGJ5IHZmaW8gb3Igc29tZXRoaW5nIHNpbWlsYXIpLA0KPiBpbnRlcnJ1cHQNCj4gPiAo
cElSUSkgaXMgZW5hYmxlZCBieSB2ZmlvIGFuZCBpdCBzZWVtcyB1bm5lY2Vzc2FyeSB0byBjYXVz
ZSBhIHZtZXhpdA0KPiB3aGVuIGd1ZXN0DQo+ID4gdXBkYXRlcyB2aXJ0dWFsIGlvYXBpYy4gIEkg
dGhpbmsgdGhlIHNpdHVhdGlvbiBpcyBzaW1pbGFyIGZvciBsZXZlbC10cmlnZ2VyZWQNCj4gPiBp
bnRlcnJ1cHQuICBTbyAyIHZtZXhpdHMgZm9yIGVhY2ggbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVw
dCBjb21wbGV0aW9uLA0KPiBvbmUgZm9yDQo+ID4gRU9JIG9uIGxhcGljIGFuZCBhbm90aGVyIGZv
ciB1bm1hc2sgb2YgSU9BUElDIHJlZ2lzdGVyLiAgRG9lcyB0aGlzDQo+IHNvdW5kIHJpZ2h0Pw0K
PiA+IEkgdGhvdWdodCB3aXRoIHZmaW8gKG9yIHNpbWlsYXIgYXJjaGl0ZWN0dXJlKSwgdGhlcmUg
aXMgbm8gdm1leGl0DQo+IG5lY2Vzc2FyeSBvbg0KPiA+IGVkZ2UtdHJpZ2dlcmVkIGludGVycnVw
dCBjb21wbGV0aW9uIGFuZCBvbmx5IG9uZSB2bWV4aXQgZm9yIGxldmVsDQo+IHRyaWdnZXJlZA0K
PiA+IGludGVycnVwdCBjb21wbGV0aW9uLCBleGNlcHQgdGhlIGNhdmVhdHMgb2Ygb25lc2hvdCBp
bnRlcnJ1cHQuICBNYXliZSBJDQo+ID4gbWlzdW5kZXJzdGFuZCBzb21ldGhpbmc/DQo+IEN1cnJl
bnRseSwgbm8gdm1leGl0IGZvciBlZGdlLXNlbnNpdGl2ZSBhbmQgMSB2bWV4aXQgZm9yIGxldmVs
LXNlbnNpdGl2ZQ0KPiBpcyB3aGF0IGhhcHBlbnMgb24gQVJNIHNoYXJlZCBwZXJpcGhlcmFsIGlu
dGVycnVwdHMgYXQgbGVhc3QuDQo+IE5vdGUgdGhlcmUgaXMgb25lIHNldHVwIHRoYXQgY291bGQg
cmVtb3ZlIHRoZSBuZWVkIGZvciB0aGUgdm1leGl0IG9uDQo+IHZFT0k6IGlycV9ieXBhc3MgbW9k
ZQ0KPiAoaHR0cHM6Ly93d3cubGludXgta3ZtLm9yZy9pbWFnZXMvYS9hOC8wMXgwNC1BUk1kZXZp
Y2UucGRmIHNsaWRlDQo+IDEyLTE0KToNCj4gb24gR0lDIHlvdSBoYXZlIGEgbW9kZSB0aGF0IGFs
bG93cyBhdXRvbWF0aWMgY29tcGxldGlvbiBvZiB0aGUNCj4gcGh5c2ljYWwNCj4gSVJRIHdoZW4g
dGhlIGNvcnJlc3BvbmRpbmcgdklSUSBpcyBjb21wbGV0ZWQuIFRoaXMgbW9kZSB3b3VsZCBub3Qg
YmUNCj4gY29tcGF0aWJsZSB3aXRoIG9uZXNob3J0X2lycS4NCj4gQXQgc29tZSBwb2ludCB3ZSB3
b3JrZWQgb24gdGhpcyBlbmFibGVtZW50IGJ1dCBnaXZlbiB0aGUgbGFjayBvZg0KPiB2ZmlvLXBs
YXRmb3JtIGN1c3RvbWVycyB0aGlzIHdvcmsgd2FzIHBhdXNlZCBzbyB3ZSBzdGlsbCBoYXZlIHRo
ZQ0KPiBtYXNrL3VubWFzayB2ZmlvIGRhbmNlLg0KPiANCj4gVGhhbmtzDQo+IA0KPiBFcmljDQo+
IA0KDQpUaGFua3MgZm9yIHRoZSBpbmZvLiAgSSBhbSBub3QgZmFtaWxpYXIgd2l0aCBBUk0gYnV0
IGl0IGlzIGludGVyZXN0aW5nIHRvIGtub3cNCnRoZSBkaWZmZXJlbmNlIGJldHdlZW4gMiBhcmNo
aXRlY3R1cmVzLg0KDQo+ID4NCj4gPj4gVGhhbmtzIGZvciB0aGUgdGlwLiBJJ2xsIHRha2UgYSBs
b29rIGludG8gaW1wbGVtZW50aW5nIHRoaXMgaWRlYS4NCj4gPj4NCj4gPj4gSXQgc2VlbXMgeW91
IGFncmVlIHRoYXQgZml4aW5nIHRoaXMgaXNzdWUgdmlhIGEgY2hhbmdlIGluIEtWTSAoaW4gaXJx
ZmQsDQo+IG5vdA0KPiA+PiBpbiBpb2FwaWMpIHNlZW1zIHRvIGJlIHRoZSB3YXkgdG8gZ28uDQo+
ID4+DQo+ID4+IEFuIGltbWVkaWF0ZSBwcm9ibGVtIEkgc2VlIHdpdGgNCj4ga3ZtXyh1bilyZWdp
c3Rlcl9pcnFfbWFza19ub3RpZmllcigpDQo+ID4+IGlzIHRoYXQgaXQgaXMgY3VycmVudGx5IGF2
YWlsYWJsZSBmb3IgeDg2IG9ubHkuIEFsc28sIG1hc2sgbm90aWZpZXJzIGFyZQ0KPiBjYWxsZWQN
Cj4gPj4gdW5kZXIgaW9hcGljLT5sb2NrIChJJ20gbm90IHN1cmUgeWV0IGlmIHRoYXQgaXMgZ29v
ZCBvciBiYWQgbmV3cyBmb3IgdXMpLg0KPiA+Pg0KPiA+PiBUaGFua3MsDQo+ID4+IERteXRybw0K
DQo=
