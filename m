Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0914D58070A
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 00:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiGYWDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 18:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiGYWDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 18:03:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070F014095
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658786625; x=1690322625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/m4OomMxw6RkMXCzJ2ewcyDOshahwhsRbmo89pRZl5o=;
  b=ZUNU5a8Ty4xOsczYaFOnwa5GEtMCBgVAM1dyhXb6BcJVvn1wdzObqpj5
   CjQGdhywWVmsodhi7j4pW+e3XuH+uOl1drV2S+REW8tCYthRpWgrsGQxB
   px8x87IY7c2z2e5vHMKcCxDbdhkWn0GvFqG65gxZOTu94a0u1Nv1giyyA
   aPGabnYTL0TJM0h6Oy2nf843rWcBHyjT7OQ+P/qq2mRdaLGDkRIaUFQ/C
   x1PXVJHtBgeKVVxYmxi6l5jS5t6/19p8SeX4+u2Wnjunar+exDfkQRVKW
   Y2UGuGN95OjQykS21D4ChPlhNZ+F8clUob0GUIQvZrWwk/jOOtRjKNw3F
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="288991798"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="288991798"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 15:03:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="627631961"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 25 Jul 2022 15:03:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 15:03:44 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 15:03:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 15:03:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 15:03:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2j48WF1iWMwYn8MyGRjjnzy5PQgkIOwVpsqVCFl71Atc2ZRXFgFC8sUvJ+xTA84ECxw04hAGQaI8CoVY1nTSNMZYzzjFe5WQ492PgPnFldA9h1wvsriPCadFc1ZHB18k0/SZt8fKAzqPZux9NLRRCdfND6r8vVU+vD9E7q9G7e5sHL/sEPkAU7alC9E5PSvLOVXMqzYqRLNElHbgEVvlfY/pJLNbC9Hn1+B8L711X7bZRqOZwJr/OAChB5l2wX5xUWS2rOOqsf2F7vDoFOcTz8Si510p8IaJ6fAMfmdYUGxpMpWzWuFvFiiRWPLf11D9EUb98DqVJozt3xnvkbFlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/m4OomMxw6RkMXCzJ2ewcyDOshahwhsRbmo89pRZl5o=;
 b=nPveRKmhjKf4+DfuQLCU0opOXArEaJxilM2+hacaIDLTJ4pvd9dkCWXzoPJ926zv61t7zrzMfjyEOgx6E5auMiw3/3oQN2MjFpDlSRzSz2QBqBMC+wNMifgrK/WMz0SDzUM+1Ji7H0V6tqU/lrZvORTSfVFXJB9WZFcqgLsoNzeTk0ufqBjhNq8HpdhY0EfPpM6QVPj+kjMq3GFih/PvICePDdh1q9Hozwox0tMvLfM7WbmlYfxT0D1u3YNtZvPib+d0TyHfnBw1u83fCwc8md+wHQ02evlsR30Z+GDjoye/r8i+xon3NDNdSfQUyFxS4wJGZC2P2qp0y9XknEERhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 22:03:42 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19%5]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 22:03:42 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        "Grzegorz Jaszczyk" <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: RE: Add vfio-platform support for ONESHOT irq forwarding?
Thread-Topic: Add vfio-platform support for ONESHOT irq forwarding?
Thread-Index: AQHYkUykeyYpecz1HEGQmidk7f4H3K1yk4sAgAAOFICAHQmq8A==
Date:   Mon, 25 Jul 2022 22:03:42 +0000
Message-ID: <MW3PR11MB455491C48BD1F630654CD491C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <0a974041-0c61-e98b-d335-76f94618b5a7@redhat.com>
 <d6f3205c-6229-3b58-cdc2-a5d0f6cfb98f@semihalf.com>
In-Reply-To: <d6f3205c-6229-3b58-cdc2-a5d0f6cfb98f@semihalf.com>
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
x-ms-office365-filtering-correlation-id: e7f122b3-358c-4117-43d2-08da6e898983
x-ms-traffictypediagnostic: CO1PR11MB4962:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: acrUOompsoPJNZpM4aBvvJh3sQfTReyt8dIV75Z9l9A+Jo30rY1KTVq+6O2HGWOxw37y3oUeQ0siryEaGqYHrQ+ZBTEgmr5zAdVEAHz6vbSVldHIq2OXSjeQvSvOySQ3n71wbCk1Hr+ZMTb8BlXZZO6z8NNLJRHMI2Ec2qQDre/yz+80iFlk0Ld6Q38QxpbCDs++tKhApZKH6oiwz0tz/F4o2ydLAO78yy1z+d7lEbJnj3uk7VBNfdx+JAuSYzNluFczLeUJDK7Um0dMgTwooE2WjnHh1YKkALGvnkU/cjD3u8RGvb9xJwwfJ5ERnBa6WYcVWUTLlFMUUmycE1/ji9lxptwd9t8k7Db2v+wJS+CGiaPryO5LdlJ2bfHHcauiEdiBiNsZqqjxd35oX1ofwxiuBDcDRt2mf7F1KCQZMJ3SqF7mNvWGyiMcOUfxNCbeQ+BXXJgDBynSkZvFQ2k6A3Hat05RrRUlXvPXdH9kBISX6LP8fnhT7SXYluNgYsUn7Ip5oMhMHEpklTdV0UHIhVwzpiI1YBdd377GXx6SbEXyTuOi7od8N64YY5x1L+ItZZuUjVxPjQUbj2eedizkCxqGi3vj0UkZAOWhFeZTxezHdmw7XnIQ+H7fRtMA7kMGbMqk67DccfBkRX7V5RkZph45YgVd65y4ZkV0LHvEwA3tw51Qxk3vT0ht6nyxajDF29WOKoFptCckdeococ/Xc1KHXeLL54yS7gyef7EJ47nQjpWxRWYgvb2a0S0WUmGXUAeNFV1gESUF51RD69QbtljooqONeY2T/Z12w2GeycIHsTXwJ5CQpizNKwJgpSabpxc1CCL3MBqF+8P+/c0zI95EUFdNmT/gYe9fhx8LSzQTboJGrrgMe9akeduo+tfJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(39860400002)(366004)(396003)(122000001)(33656002)(38100700002)(966005)(86362001)(8936002)(478600001)(52536014)(38070700005)(82960400001)(5660300002)(9686003)(316002)(55016003)(66946007)(64756008)(76116006)(186003)(8676002)(71200400001)(66556008)(66446008)(54906003)(83380400001)(7416002)(4326008)(66476007)(110136005)(41300700001)(2906002)(26005)(6506007)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkMyVG1UUkVoWTg4TXBYZHhoK3JNQngrZUtOSnBsbXV2ejV3UUwxV1BTT3d1?=
 =?utf-8?B?aHdxbmpzbHhpRjRUWHA1S2tlSU1KQytjZlUzalRFSzFQKzB0eFlDMFRINFZ5?=
 =?utf-8?B?amFpaFRvN2d2elRkVjFtbFR2K0U4RWtWWnUzYkl6dCtFSU03SVU5dU5Fency?=
 =?utf-8?B?OENyZXQ0TUQ3eC9hNmtvOUdIQW4wK0VHL3lyQ2JFUjZwZnB0OTZQVkFmL0tD?=
 =?utf-8?B?Y1c3STlKQjN4enU0RTBYbXVUaEl1bWsvMk9UYXBaM3JsSjg3TFJwYWV6WE9k?=
 =?utf-8?B?ajFzMUhDZjVVUmJoWjBtUi96QTdTN0oxazRnSXBkS2dWUVpMTUF6OFNhMjB1?=
 =?utf-8?B?VjZXT3VxYmJNZGhMOWQ1aThZc1VLWjRSeFkwYkJYK2tDL1kxUG5sdWV6RjBH?=
 =?utf-8?B?d0Z2T1dzaUJSU1hZdUJMZkliOGQzcDIvNmxiY3gxdVFsc3RDUVVhSm02R09R?=
 =?utf-8?B?WG9GMWZYOU9uSVloT042SW9UQ1ZVaHFMQ2hiL094cTd1aWovbkhlT0NZM09D?=
 =?utf-8?B?MmVxWmJmTm5TZkRaNEgzMElYVkUxa29xeDd3UENnVEJYcWhUcXJMUFAra0Fq?=
 =?utf-8?B?VWpXM2Jrcm90Q25rUCtwZ1F4UytpTkt1MmJmREhjWUhIMGEvUFFBU2Y1UEhX?=
 =?utf-8?B?TFhKQll4eVJFQS9BbUY1akxyL0RJZnp3by83bVJhWWRNdFlVL2pHZ2ttZzBz?=
 =?utf-8?B?dzZWUGkrQmEweVBuNGF4TzRhL2puYU5Ba3VDWGJlVGNxeUphL085VVMraXlR?=
 =?utf-8?B?aTFLK1h1ZGR4YitJTjV2dlFkOEM4V2dnTUhGWWpZYmljK3dHKzFzNGIvbVNo?=
 =?utf-8?B?OTdUUTRvbENRdnlGalZtV08renpURStscW1wNG9GZzY2clFuM21NbHk3VUFU?=
 =?utf-8?B?d1Qzb09Oa3RHUzgrOE1hVEkwRm9MQ3FYR29WZHZDY2k3TWlaU0J5MjI0amVv?=
 =?utf-8?B?azNEZXBsTlI2aGdPVnB6YTFzb0N5ZDVvcHZNbHhxcGxJSDNLaVArajlZZ0RU?=
 =?utf-8?B?QVl2MGIzR3R0YmNLaURnOG1IT0p6VkZlaW15MUhGV1FjUU1Lb1QweXFDQnlE?=
 =?utf-8?B?R0pmQlZWcmpGT2hHTkR5Q1dNcm1vRVIxck04aW9Oc0p1MkVBVnJiMENyL2Vx?=
 =?utf-8?B?Y0JodjJpTm5DTjN3YU5QUFduaGFoTEttRjhOL0RVL2lOUXhUQW9rRTZ5MlRq?=
 =?utf-8?B?UEVOVHRFV0t5RzRSVWRiazlEOC9rMHZQRjljMld1MVFYMjRyLzN6bGRsM2pS?=
 =?utf-8?B?ak5jWHlQUGcyaEpwemMvZmtKeWErRzhyV0htd3FKK1ViNlQ2NENxczc2WVZm?=
 =?utf-8?B?dEd6Mk5ZYXFiUWg5MnZESHQ3cHdOTktLTndBclprc291ZHQ0eXAxUjAyVFIw?=
 =?utf-8?B?QnM2TUV5S1piazUyZk1GMGN1eG5SQzUxQ0lSMDRSVThkQmFpZWJnY29wMFFX?=
 =?utf-8?B?aW40U28rczZDdWV6TnN0TlZySzlWL3pGL1NRVm5ScEVtcHVBMThySkM5U0Jz?=
 =?utf-8?B?Y2dhT2pQY0lhMlJ4Nkp4bXI0VGFRU051UURvcWNUV0hQbHlCSHYxeXdkdE5Q?=
 =?utf-8?B?elNub3N3MDZObVlVMFVqa0RMVjRITy9xUWtsa0lDcUF3TllZQ2xxbm5TL2FL?=
 =?utf-8?B?Q2lxSDR5TXR1b2YrZmNwQi9hdmszcXJXMnFGYklYb1hQbE5pMlY0L3Jadm1O?=
 =?utf-8?B?bFFqU2llKzZ0ZzNGcEo1VXliVlZ4d2tHUnRKd21ic3A3VGlOdi9sV3RmQ1dP?=
 =?utf-8?B?QzdaZnF0NmdWSDJDVzAxL3VBWmszY3VLakQwOWJ5azkxVGlMS1NtSzV3UXJ3?=
 =?utf-8?B?QUxJUXVVNFdpTW9yL2o0NGlBUUhsanowOEw3aStWc0RmcDBWa3VWMEpYQ2hZ?=
 =?utf-8?B?ZjJkMExpU3IwU2lOSlZ0MzBTTGRUakprS2VlYnpyRnJkaGlwVE1RazFQM0lp?=
 =?utf-8?B?bHZCZlBmSXlDbkhaQmJpbjhQM29vakhtSlZIZCs2YWxqZHBoRXMzUExYNDVJ?=
 =?utf-8?B?ZzI4eFRWcGUxbHhqK0kzVG4yNWJLc2pPU0dQdDczOHRPcFFCMUVZMGUrWC9Y?=
 =?utf-8?B?dXp3cEN3dnNUczQ1ZWFVbFdqNmc1c2tBOURSZlRNMzJHb2kvcDFDSEtKbVhH?=
 =?utf-8?Q?RoOQdt7OV/759Q1yrS6gyolp0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f122b3-358c-4117-43d2-08da6e898983
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 22:03:42.2533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+cncY5PflicikpEmU8tuig0im19Fdl+/eGZsYfly8OPQMcI4vge8+Oqqdd7PLR4eY6muc4d3xo16pnbcdeD0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URI_DOTEDU autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEbXl0cm8g
TWFsdWthIDxkbXlAc2VtaWhhbGYuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSA3LCAyMDIy
IDI6MTYgQU0NCj4gVG86IGVyaWMuYXVnZXJAcmVkaGF0LmNvbTsgTWljYWggTW9ydG9uIDxtb3J0
b25tQGNocm9taXVtLm9yZz4NCj4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBDaHJpc3RvcGhlcnNvbiwsIFNl
YW4gPHNlYW5qY0Bnb29nbGUuY29tPjsNCj4gUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0
LmNvbT47IExpdSwgUm9uZyBMDQo+IDxyb25nLmwubGl1QGludGVsLmNvbT47IFRvbWFzeiBOb3dp
Y2tpIDx0bkBzZW1paGFsZi5jb20+OyBHcnplZ29yeg0KPiBKYXN6Y3p5ayA8amF6QHNlbWloYWxm
LmNvbT47IERtaXRyeSBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBSZTog
QWRkIHZmaW8tcGxhdGZvcm0gc3VwcG9ydCBmb3IgT05FU0hPVCBpcnEgZm9yd2FyZGluZz8NCj4g
DQo+IEhpIEVyaWMsDQo+IA0KPiBPbiA3LzcvMjIgMTA6MjUgQU0sIEVyaWMgQXVnZXIgd3JvdGU6
DQo+ID4+IEFnYWluLCB0aGlzIGRvZXNuJ3Qgc2VlbSB0byBiZSB0cnVlLiBKdXN0IGFzIGV4cGxh
aW5lZCBpbiBteSBhYm92ZQ0KPiA+PiByZXBseSB0byBBbGV4LCB0aGUgZ3Vlc3QgZGVhY3RpdmF0
ZXMgKEVPSSkgdGhlIHZJUlEgYWxyZWFkeSBhZnRlciB0aGUNCj4gPj4gY29tcGxldGlvbiBvZiB0
aGUgdklSUSBoYXJkaXJxIGhhbmRsZXIsIG5vdCB0aGUgdklSUSB0aHJlYWQuDQo+ID4+DQo+ID4+
IFNvIFZGSU8gdW5tYXNrIGhhbmRsZXIgZ2V0cyBjYWxsZWQgdG9vIGVhcmx5LCBiZWZvcmUgdGhl
IGludGVycnVwdA0KPiA+PiBnZXRzIHNlcnZpY2VkIGFuZCBhY2tlZCBpbiB0aGUgdklSUSB0aHJl
YWQuDQo+ID4gRmFpciBlbm91Z2gsIG9uIHZJUlEgaGFyZGlycSBoYW5kbGVyIHRoZSBwaHlzaWNh
bCBJUlEgZ2V0cyB1bm1hc2tlZC4NCj4gPiBUaGlzIGV2ZW50IG9jY3VycyBvbiBndWVzdCBFT0ks
IHdoaWNoIHRyaWdnZXJzIHRoZSByZXNhbXBsZWZkLiBCdXQgd2hhdA0KPiA+IGlzIHRoZSBzdGF0
ZSBvZiB0aGUgdklSUT8gSXNuJ3QgaXQgc3RpbCBtYXNrZWQgdW50aWwgdGhlIHZJUlEgdGhyZWFk
DQo+ID4gY29tcGxldGVzLCBwcmV2ZW50aW5nIHRoZSBwaHlzaWNhbCBJUlEgZnJvbSBiZWluZyBw
cm9wYWdhdGVkIHRvIHRoZQ0KPiBndWVzdD8NCj4gDQo+IEV2ZW4gaWYgdklSUSBpcyBzdGlsbCBt
YXNrZWQgYnkgdGhlIHRpbWUgd2hlbg0KPiB2ZmlvX2F1dG9tYXNrZWRfaXJxX2hhbmRsZXIoKSBz
aWduYWxzIHRoZSBldmVudGZkICh3aGljaCBpbiBpdHNlbGYgaXMNCj4gbm90IGd1YXJhbnRlZWQs
IEkgZ3Vlc3MpLCBJIGJlbGlldmUgS1ZNIGlzIGJ1ZmZlcmluZyB0aGlzIGV2ZW50LCBzbw0KPiBh
ZnRlciB0aGUgdklSUSBpcyB1bm1hc2tlZCwgdGhpcyBuZXcgSVJRIHdpbGwgYmUgaW5qZWN0ZWQg
dG8gdGhlIGd1ZXN0DQo+IGFueXdheS4NCj4gDQo+ID4+IEl0IHNlZW1zIHRoZSBvYnZpb3VzIGZp
eCBpcyB0byBwb3N0cG9uZSBzZW5kaW5nIGlycSBhY2sgbm90aWZpY2F0aW9ucw0KPiA+PiBpbiBL
Vk0gZnJvbSBFT0kgdG8gdW5tYXNrIChmb3Igb25lc2hvdCBpbnRlcnJ1cHRzIG9ubHkpLiBMdWNr
aWx5LCB3ZQ0KPiA+PiBkb24ndCBuZWVkIHRvIHByb3ZpZGUgS1ZNIHdpdGggdGhlIGluZm8gdGhh
dCB0aGUgZ2l2ZW4gaW50ZXJydXB0IGlzDQo+ID4+IG9uZXNob3QuIEtWTSBjYW4ganVzdCBmaW5k
IGl0IG91dCBmcm9tIHRoZSBmYWN0IHRoYXQgdGhlIGludGVycnVwdCBpcw0KPiA+PiBtYXNrZWQg
YXQgdGhlIHRpbWUgb2YgRU9JLg0KPiA+IHlvdSBtZWFuIHRoZSB2SVJRIHJpZ2h0Pw0KPiANCj4g
UmlnaHQuDQo+IA0KPiA+IEJlZm9yZSBnb2luZyBmdXJ0aGVyIGFuZCB3ZSBpbnZlc3QgbW9yZSB0
aW1lIGluIHRoYXQgdGhyZWFkLCBwbGVhc2UNCj4gPiBjb3VsZCB5b3UgZ2l2ZSB1cyBhZGRpdGlv
bmFsIGNvbnRleHQgaW5mbyBhbmQgY29uZmlkZW5jZQ0KPiA+IGluL3VuZGVyc3RhbmRpbmcgb2Yg
dGhlIHN0YWtlcy4gVGhpcyB0aHJlYWQgaXMgZnJvbSBKYW4gMjAyMSBhbmQgd2FzDQo+ID4gZGlz
Y29udGludWVkIGZvciBhIHdoaWxlLiB2ZmlvLXBsYXRmb3JtIGN1cnJlbnRseSBvbmx5IGlzIGVu
YWJsZWQgb24NCj4gQVJNDQo+ID4gYW5kIG1haW50YWluZWQgZm9yIHZlcnkgZmV3IGRldmljZXMg
d2hpY2ggcHJvcGVybHkgaW1wbGVtZW50IHJlc2V0DQo+ID4gY2FsbGJhY2tzIGFuZCBkdWx5IHVz
ZSBhbiB1bmRlcmx5aW5nIElPTU1VLg0KDQpEbyB5b3UgaGF2ZSBtb3JlIHF1ZXN0aW9ucyBhYm91
dCB0aGlzIGlzc3VlIGFmdGVyIGZvbGxvd2luZyBpbmZvIGFuZCBQT0MgZnJvbQ0KRG15dHJvPw0K
SSBhZ3JlZSB0aGF0IHdlIHRyaWVkIHRvIGV4dGVuZCB0aGUgdmZpbyBpbmZyYXN0cnVjdHVyZSB0
byB4ODYgYW5kIGEgZmV3IG1vcmUNCmRldmljZXMgd2hpY2ggbWF5IG5vdCAidHJhZGl0aW9uYWxs
eSIgc3VwcG9ydGVkIGJ5IGN1cnJlbnQgdmZpbyBpbXBsZW1lbnRhdGlvbi4gDQpIb3dldmVyIGlm
IHdlIHZpZXcgdmZpbyBhcyBhIGdlbmVyYWwgaW5mcmFzdHJ1Y3R1cmUgdG8gYmUgdXNlZCBmb3Ig
cGFzcy10aHJ1DQpkZXZpY2VzICh0aGlzIGlzIHdoYXQgd2UgaW50ZW5kIHRvIGRvLCBpbXBsZW1l
bnRhdGlvbiBtYXkgdmFyeSksICAgT25lc2hvdA0KaW50ZXJydXB0IGlzIG5vdCBwcm9wZXJseSBo
YW5kbGVkLiANCg0KRnJvbSB0aGlzIGRpc2N1c3Npb24gd2hlbiBvbmVzaG90IGludGVycnVwdCBp
cyBmaXJzdCB1cHN0cmVhbWVkOg0KaHR0cHM6Ly9sa21sLml1LmVkdS9oeXBlcm1haWwvbGludXgv
a2VybmVsLzA5MDguMS8wMjExNC5odG1sIGl0IHNheXM6ICIuLi4gd2UNCm5lZWQgdG8ga2VlcCB0
aGUgaW50ZXJydXB0IGxpbmUgbWFza2VkIHVudGlsIHRoZSB0aHJlYWRlZCBoYW5kbGVyIGhhcyBl
eGVjdXRlZC4gDQouLi4gVGhlIGludGVycnVwdCBsaW5lIGlzIHVubWFza2VkIGFmdGVyIHRoZSB0
aHJlYWQgaGFuZGxlciBmdW5jdGlvbiBoYXMgYmVlbg0KZXhlY3V0ZWQuIiB1c2luZyB0b2RheSdz
IHZmaW8gYXJjaGl0ZWN0dXJlLCAocGh5c2ljYWwpIGludGVycnVwdCBsaW5lIGlzDQp1bm1hc2tl
ZCBieSB2ZmlvIGFmdGVyIEVPSSBpbnRyb2R1Y2VkIHZtZXhpdCwgaW5zdGVhZCBhZnRlciB0aGUg
dGhyZWFkZWQNCmZ1bmN0aW9uIGhhcyBiZWVuIGV4ZWN1dGVkIChvciBpbiB4ODYgd29ybGQsIHdo
ZW4gdmlydHVhbCBpbnRlcnJ1cHQgaXMNCnVubWFza2VkKTogdGhpcyB0b3RhbGx5IHZpb2xhdGVz
IGhvdyBvbmVzaG90IGlycSBzaG91bGQgYmUgdXNlZC4gICBXZSBoYXZlIGEgZmV3DQppbnRlcm5h
bCBkaXNjdXNzaW9ucyBhbmQgd2UgY291bGRuJ3QgZmluZCBhIHNvbHV0aW9uIHdoaWNoIGFyZSBi
b3RoIGNvcnJlY3QgYW5kDQplZmZpY2llbnQuICBCdXQgYXQgbGVhc3Qgd2UgY2FuIHRhcmdldCBh
ICJjb3JyZWN0IiBzb2x1dGlvbiBmaXJzdCBhbmQgdGhhdCB3aWxsDQpoZWxwIHVzIHJlc29sdmUg
YnVncyB3ZSBoYXZlIG9uIG91ciBwcm9kdWN0cyBub3cuDQoNCj4gU3VyZS4gV2UgYXJlIG5vdCBy
ZWFsbHkgdXNpbmcgdmZpby1wbGF0Zm9ybSBmb3IgdGhlIGRldmljZXMgd2UgYXJlDQo+IGNvbmNl
cm5lZCB3aXRoLCBzaW5jZSB0aG9zZSBhcmUgbm90IERNQSBjYXBhYmxlIGRldmljZXMsIGFuZCBz
b21lIG9mDQo+IHRoZW0gYXJlIG5vdCByZWFsbHkgcGxhdGZvcm0gZGV2aWNlcyBidXQgSTJDIG9y
IFNQSSBkZXZpY2VzLiBJbnN0ZWFkIHdlDQo+IGFyZSB1c2luZyAoaG9wZWZ1bGx5IHRlbXBvcmFy
aWx5KSBNaWNhaCdzIG1vZHVsZSBmb3IgZm9yd2FyZGluZw0KPiBhcmJpdHJhcnkgSVJRcyBbMV1b
Ml0gd2hpY2ggbW9zdGx5IHJlaW1wbGVtZW50cyB0aGUgVkZJTyBpcnEgZm9yd2FyZGluZw0KPiBt
ZWNoYW5pc20uDQo+IA0KPiBBbHNvIHdpdGggYSBmZXcgc2ltcGxlIGhhY2tzIEkgbWFuYWdlZCB0
byB1c2UgdmZpby1wbGF0Zm9ybSBmb3IgdGhlIHNhbWUNCj4gdGhpbmcgKGp1c3QgYXMgYSBQb0Mp
IGFuZCBjb25maXJtZWQsIHVuc3VycHJpc2luZ2x5LCB0aGF0IHRoZSBwcm9ibGVtcw0KPiB3aXRo
IG9uZXNob3QgaW50ZXJydXB0cyBhcmUgb2JzZXJ2ZWQgd2l0aCB2ZmlvLXBsYXRmb3JtIGFzIHdl
bGwuDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly9jaHJvbWl1bS5nb29nbGVzb3VyY2UuY29tL2Nocm9t
aXVtb3MvdGhpcmRfcGFydHkva2VybmVsLysvDQo+IHJlZnMvaGVhZHMvY2hyb21lb3MtNS4xMC1t
YW5hdGVlL3ZpcnQvbGliL3BsYXRpcnFmb3J3YXJkLmMNCj4gDQo+IFsyXQ0KPiBodHRwczovL2xr
bWwua2VybmVsLm9yZy9rdm0vQ0FKLQ0KPiBFY2NQVThLcFU5NlBNMlB0cm9MamROVkRidm54d0t3
V0pyMkIrUkJLdVhFcjdWd0BtYWlsLmdtYWlsDQo+IC5jb20vVC8NCj4gDQo+IFRoYW5rcywNCj4g
RG15dHJvDQo=
