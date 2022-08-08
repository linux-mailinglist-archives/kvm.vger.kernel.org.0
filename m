Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA26058CCB2
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 19:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243067AbiHHRer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 13:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbiHHRep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 13:34:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95EBBC82
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 10:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659980083; x=1691516083;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qWwqo88CApGQ246Lgj3LztDyWbMNim4hmdY8/5iLBfM=;
  b=csyXzkCYZGNnnGDSjlYd+bBIHirtXB9hHdx+UjUyK7q1Y00MSWS3rx7R
   G9jFXWWBVCpRw3hXML9Ahs+7Y8Em6k8PkVC83wFYw5A4HnXOUgG40UnCs
   9iOOOheUrnXA9SLBLerf88zzQ3yesARKec/d2vY4n8kBiIc9ZF3Q+DelZ
   5FsXiLwEgG5w0hb0tBZUHFKB7XBwaGSuFN/EntQI9mgiePBKLtLHYYeIT
   S+w58jCdK9VJDOYJSrWECbYK7rm7Y8a5uf+CLnQJ9l7DeVtw19WVd6Exk
   FIj/JhjlswS6xZIYoKao/QCPor1H3+K11Lx1qolXv+XtKMjCRYnmrHBjZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="291430087"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="291430087"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 10:34:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="746723642"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2022 10:34:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 10:34:42 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 10:34:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 10:34:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 10:34:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwgIoz27J9WeJx6vrGb+I1u/HerCErkZcHuG2wjtcoKT4CluAOo2vr9Yau0ByMtHaV7wTq+qsmQQ1HkO14CqwrnApzyLooYaCrBnwsY9XnPX8au7Ik8TidUHHwbYS36O139SLQLLZJix1EchlOWsHn+/JzihBPIdUXLLDt/GD+3tOw+5yiG0fybzIfGFSpdD3Uu/lJ5QQOMH7ACt0ecZMJbytYdgTWup0dIT1NZ1PEYFW/l48EOvESDU/bC9iaFWEOdoCXdFA7GVU7/iIy/ESuZzIDKEXc6XYY9f31K5Oqj/Km8HU0Om/zfBRvmVz+wsDChuaniBuNEQsytzJCCfHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWwqo88CApGQ246Lgj3LztDyWbMNim4hmdY8/5iLBfM=;
 b=J2F5iomI6Ogz5GUUaYvAE2xuoGYvqAM2J3/UKEz2nH7E3/svnCJgw+DGAvaH+ID47ejO5N757j8ce4lGy4SFFetNW/nTkZYgahX0f7JUzaPxQsyuVnHIIPYFyOvnetgA5l/YRUp8C5C9/N3AuCtpQktd1ZaPZcm4aS7M+68f5kCwDVZ3BmEQkSYdQOp3f/oFAibdwqI2Ahhxv+0wInLA5lAWJkY/NQ/Wap9/ogtwKLfGzt8pOgmCrfr9sJniUajNoPxSHJYx5oh2XfCvdfsE75EMNdUwRJFmH7+SV3gpx8Ku+1/MtIojBk4ZJpGg0CCZ1FTBbJeSnS6gsWXFssf/Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CY4PR1101MB2102.namprd11.prod.outlook.com (2603:10b6:910:1e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Mon, 8 Aug
 2022 17:34:39 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::1c1b:6692:5ac6:9390]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::1c1b:6692:5ac6:9390%6]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 17:34:30 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Dmytro Maluka <dmy@semihalf.com>,
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
Thread-Index: AQHYkUykeyYpecz1HEGQmidk7f4H3K1yk4sAgAAOFICAHQmq8IAPUhyAgAZ2+VA=
Date:   Mon, 8 Aug 2022 17:34:30 +0000
Message-ID: <MW3PR11MB4554B529859E87F2717105A8C7639@MW3PR11MB4554.namprd11.prod.outlook.com>
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
 <MW3PR11MB455491C48BD1F630654CD491C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
 <069a98a2-d4a1-8599-9deb-069115d5d22c@redhat.com>
In-Reply-To: <069a98a2-d4a1-8599-9deb-069115d5d22c@redhat.com>
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
x-ms-office365-filtering-correlation-id: ae015486-c70f-4322-c143-08da79644015
x-ms-traffictypediagnostic: CY4PR1101MB2102:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2UgeIHvV8QyiopT9AwGWYfakDqqw04l88Q5IPD6cVUVvaGV7ydKZPowutduTXgcdlqlBr3sYryGaylUR2xLSJTixVC90EdBj3dBSFN/gT5VqbXgfAsYN6KjeOziXyPqS4T09cUuYlUD9HCHVR4faj+76ysc0Nq6o9gsBOMQqwR6jQA/wnsIzJppS8cTpkaYERPo+6Fip39iul2P/O/9CMBWQU/Ov8yeMFbmwXWrSunTeyxZLmCI7wmNwZrN/FS6+RaZiR9TFCwnyLeVGyYTEFWM1pToFF878ChynRWJMFZUkb48QpOE/EaepCPn11ipA1oi6hMNcdn5MgNp7Qo2lm2Bq3lUDI0zi6jpfi74FRK2rye31lDt9oCS/7GR5P6MZ8B8t9fXfVXtDRb81shmSWAHd49CT226U3OKa9TCiSxxGLuhcnpLwNhBI7KnwmSwn9A1My9z//dhCt65HGbdhKdBBu9C7zeaNDmZOHdTn1xXPQHUB6iUx53XMxviv6WHWSv5pumC01RkuojqaW1iRbb2SKC5Lg1hMHDmPV9DXGOBN3XlBRVaPIJ8go7a2HeZrTg3KkIf12GkDwiSzzx59s6Y8PdlNShCkeor0w68U1iYxWODBlAIy5YPC9q2jFhpl5x/4PINvBL25mvVL814bq5dxn9wIbhLkdX1ZSVcDHfLYS2LhW0Yba5rMFSi+Y3/zhu+qzEPZavfd3KDJ9HjhwPFyLSFQ04MxdEjOyVvWoBuf54e+7n4gqwSIcHQdUSGiQNQEdgPBE4fLDwApmsMMCKPelQEWUDejbPMU9uLZaJJYgnjUT8xx15O4GlVn6syGXTNqzEIRCF3u1QxXuHdvVxRxiw1+P/dTHzagjCBo1Gff0NKrXZoacfsNfCUTvdZk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(136003)(396003)(82960400001)(38070700005)(38100700002)(26005)(966005)(186003)(71200400001)(41300700001)(6506007)(9686003)(53546011)(7696005)(478600001)(55016003)(110136005)(86362001)(8676002)(66446008)(4326008)(66946007)(66556008)(5660300002)(66476007)(76116006)(64756008)(54906003)(316002)(2906002)(122000001)(83380400001)(33656002)(52536014)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTVCSDM5a1ZhWVVjTzRXOGltczlSL002TWJZWUVlU0k5dUVzM3JuQUZIdldG?=
 =?utf-8?B?Z2E1VEdPWnVuMUdDQVRKZDdEMGxWTGtpWHNFenlaOW5tNjNnbGV1M0Z4TlVI?=
 =?utf-8?B?VXdLM1NFWWNLRXBGRGpzaXV6MW1iaDRFMm5pdzJGTTh4MFJHTnNKbndBeG1H?=
 =?utf-8?B?RFJZWXJqY3lsSElOSjlpY0gyQVhJOTc3SmtPbVBNRkhENkI0VWc5a3owLzYx?=
 =?utf-8?B?RjB3YlRISkdYMHg4czdLVEdZc29oVk9jWVFnWDNGRlIyRVd0QkJnbVlqdkpt?=
 =?utf-8?B?MVNET2ZGbXN5Y3N2S2JFVUs1YWRDREFKcUE1bFcrYzExaEwvUHV5WHAxa0o3?=
 =?utf-8?B?SGxRUE9Nd3hYcVl2TVJEN2ZEYnVMMWhrcWNjM3dBL3hHSk9kV1FNd2JhR2FI?=
 =?utf-8?B?Y3I2b3Z4bzdFdDJwSEVrL0FHN1dNdlRHdWQ3NEhoVEFQVXU5aWx5c2xjbUQy?=
 =?utf-8?B?YU1SRXFXMDhrK09DMnZzZG1WamFiWjFGVzhnTjNpMTE5cnJoVGt4akNpN2ll?=
 =?utf-8?B?RFJ5Rm40VVpBL211YmV0SmlaWHBxZmRZemZMT0tWUlNWLzU1MjY2U0hER1Bw?=
 =?utf-8?B?VHYwWkl3c25BaHFBVEJEWDB6STBmekZWblBRNFROVnBudkJDdUx0dXdvT1ZV?=
 =?utf-8?B?bFdmYUx1K2JIQTAwUjdrbnZ5ak1yQXhaWWorK3pPOWZmZWpNTks2M09rNjFH?=
 =?utf-8?B?aitwV3hOVU5NTGY0TGlTQk5DMlArRzhzK0x4dktVSUp1T0ZHZEVQM2NjSkFa?=
 =?utf-8?B?VTNDU0tiZTNqN210TG5aOWtMS1lkMW1VK25nNkRvVGswNHB4dXkrUTl4L0F5?=
 =?utf-8?B?bDk3YWYveHkvZXYzMVVLYlFIV2N6WS9XWVcyb21wTEs3cmxoV29pN2FuZ0lC?=
 =?utf-8?B?RlMzNzkwMUFvdFNDTytFK1hBVDlUd2VGK3dkVzluYXI1N3k4TDRVQlpiQnNL?=
 =?utf-8?B?V2lsRmVMSTN0bGNsbVNlU25VRDI3dkVPN0lDZUFHcnh2ODBWcjR6SkwyckY2?=
 =?utf-8?B?NnV1bDFKWVVEcy9GTUdBYjBQZzllei9NWW9OUDdtZGRoY0NNWDk1bmI0WHJw?=
 =?utf-8?B?UUlPdXJGeCt3ZWNxYklyK1RhaVUyU2lwRm04STJpVU5yZUMxZWhYMWxLL2JV?=
 =?utf-8?B?dVE4dGZRb2YrUzgrTHZvamx6c3B5enJuVDZtd0hWSG9DZSs5anFFZmlmaHJQ?=
 =?utf-8?B?K0dpQUtEb2tqYXoxVHBtY25mcWU2UmRHUGZMcXVGRkx1RTZwVDhnbWVrSGFn?=
 =?utf-8?B?R0U2OTc3VTFoNXJ5dngzYmhjbDFPdm4vRml2TXJZeHZSa2d6NWxpMy8zWjU0?=
 =?utf-8?B?M2U3eEhvcEp3U1d3K21xTVdvTVpiYXFDM0ZISzYwWGhqQU9iOWtvSzBxVDhn?=
 =?utf-8?B?a1lxMW1HdGVXd0p1UUlwSTFZSlVUQUVmWWFyNGV0SG1mWmpEWFkrU1hrRTFB?=
 =?utf-8?B?SlFiNEtmbWtSMk11REttZUpxQ1BxYnRHTmxvSVRHUmd2WmpTcWo2YktlT2dD?=
 =?utf-8?B?d0plOHlwT1U3aXlnZXhMVTJxQmU3cTIwb2w3UlFPU3EzUS92bTZ0akc3MkRK?=
 =?utf-8?B?bHZoMjVyNkUwUTM1MlBML29BN3k1VkF0WTJjVDk5RHN5Z1pSVFZzNUtMWHls?=
 =?utf-8?B?elJGaGVEeFFsNlpEUEZ5dDB5d2dEcVpxY0pZakJHLzREWnFiOFhwR2xaZ256?=
 =?utf-8?B?VXQwc09OR25XM21JcldHZWlwNForZ3g5NkxvR1d2L3VLdTd4Mkt6SWZXeXNx?=
 =?utf-8?B?UjhoamNqMTVsS1dYZ2o1QzBEUFJWTUNqcENtdlgzZW1QcmVxN2x5eGt4QVk2?=
 =?utf-8?B?b1E3Z1JCT2hkc0FjTklFZUw1UFZ6ZUdhbkhEcTFIYzJvMFVELytKbVR4c2N1?=
 =?utf-8?B?eldmVTNLVnBWV2d1Y2xyNnU5d0VhZUtXK1FpbVRyYWFETjE1dWpydjdVU1pS?=
 =?utf-8?B?Z3B3clY4WVo2QjRMWVNWL1lZWi9UUTNEdERyN1RQcGFKdG10L2oyb2ZDWWVP?=
 =?utf-8?B?RGd6TzNaOVhlcjNucnRBcWFUR05qUXYrSlE5bDZnWitqTytwci81YjZveTRM?=
 =?utf-8?B?STY3OXZad25UUmdLbmxiV3c2cm4rS2VleHBjRXl2MFRDakxuSStyUmtJcUow?=
 =?utf-8?Q?exCA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae015486-c70f-4322-c143-08da79644015
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 17:34:30.4546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D72pD4rQRh6gih8T+IZdjOj3gCrQXfjNW6z4mESWebqXQhDb5yB+oGKcl6SlUT1UcbLn8A9X9lRuXWXmBE0IrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2102
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgNCwg
MjAyMiA3OjM5IEFNDQo+IFRvOiBMaXUsIFJvbmcgTCA8cm9uZy5sLmxpdUBpbnRlbC5jb20+OyBE
bXl0cm8gTWFsdWthDQo+IDxkbXlAc2VtaWhhbGYuY29tPjsgTWljYWggTW9ydG9uIDxtb3J0b25t
QGNocm9taXVtLm9yZz4NCj4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJl
ZGhhdC5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBDaHJpc3RvcGhlcnNvbiwsIFNlYW4g
PHNlYW5qY0Bnb29nbGUuY29tPjsNCj4gUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNv
bT47IFRvbWFzeiBOb3dpY2tpDQo+IDx0bkBzZW1paGFsZi5jb20+OyBHcnplZ29yeiBKYXN6Y3p5
ayA8amF6QHNlbWloYWxmLmNvbT47IERtaXRyeQ0KPiBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29t
Pg0KPiBTdWJqZWN0OiBSZTogQWRkIHZmaW8tcGxhdGZvcm0gc3VwcG9ydCBmb3IgT05FU0hPVCBp
cnEgZm9yd2FyZGluZz8NCj4gDQo+IEggTGl1LA0KPiANCj4gT24gNy8yNi8yMiAwMDowMywgTGl1
LCBSb25nIEwgd3JvdGU6DQo+ID4gSGkgRXJpYywNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBEbXl0cm8gTWFsdWthIDxkbXlAc2VtaWhhbGYuY29tPg0K
PiA+PiBTZW50OiBUaHVyc2RheSwgSnVseSA3LCAyMDIyIDI6MTYgQU0NCj4gPj4gVG86IGVyaWMu
YXVnZXJAcmVkaGF0LmNvbTsgTWljYWggTW9ydG9uDQo+IDxtb3J0b25tQGNocm9taXVtLm9yZz4N
Cj4gPj4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+Ow0K
PiA+PiBrdm1Admdlci5rZXJuZWwub3JnOyBDaHJpc3RvcGhlcnNvbiwsIFNlYW4gPHNlYW5qY0Bn
b29nbGUuY29tPjsNCj4gPj4gUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT47IExp
dSwgUm9uZyBMDQo+ID4+IDxyb25nLmwubGl1QGludGVsLmNvbT47IFRvbWFzeiBOb3dpY2tpIDx0
bkBzZW1paGFsZi5jb20+Ow0KPiBHcnplZ29yeg0KPiA+PiBKYXN6Y3p5ayA8amF6QHNlbWloYWxm
LmNvbT47IERtaXRyeSBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29tPg0KPiA+PiBTdWJqZWN0OiBS
ZTogQWRkIHZmaW8tcGxhdGZvcm0gc3VwcG9ydCBmb3IgT05FU0hPVCBpcnEgZm9yd2FyZGluZz8N
Cj4gPj4NCj4gPj4gSGkgRXJpYywNCj4gPj4NCj4gPj4gT24gNy83LzIyIDEwOjI1IEFNLCBFcmlj
IEF1Z2VyIHdyb3RlOg0KPiA+Pj4+IEFnYWluLCB0aGlzIGRvZXNuJ3Qgc2VlbSB0byBiZSB0cnVl
LiBKdXN0IGFzIGV4cGxhaW5lZCBpbiBteSBhYm92ZQ0KPiA+Pj4+IHJlcGx5IHRvIEFsZXgsIHRo
ZSBndWVzdCBkZWFjdGl2YXRlcyAoRU9JKSB0aGUgdklSUSBhbHJlYWR5IGFmdGVyIHRoZQ0KPiA+
Pj4+IGNvbXBsZXRpb24gb2YgdGhlIHZJUlEgaGFyZGlycSBoYW5kbGVyLCBub3QgdGhlIHZJUlEg
dGhyZWFkLg0KPiA+Pj4+DQo+ID4+Pj4gU28gVkZJTyB1bm1hc2sgaGFuZGxlciBnZXRzIGNhbGxl
ZCB0b28gZWFybHksIGJlZm9yZSB0aGUgaW50ZXJydXB0DQo+ID4+Pj4gZ2V0cyBzZXJ2aWNlZCBh
bmQgYWNrZWQgaW4gdGhlIHZJUlEgdGhyZWFkLg0KPiA+Pj4gRmFpciBlbm91Z2gsIG9uIHZJUlEg
aGFyZGlycSBoYW5kbGVyIHRoZSBwaHlzaWNhbCBJUlEgZ2V0cyB1bm1hc2tlZC4NCj4gPj4+IFRo
aXMgZXZlbnQgb2NjdXJzIG9uIGd1ZXN0IEVPSSwgd2hpY2ggdHJpZ2dlcnMgdGhlIHJlc2FtcGxl
ZmQuIEJ1dA0KPiB3aGF0DQo+ID4+PiBpcyB0aGUgc3RhdGUgb2YgdGhlIHZJUlE/IElzbid0IGl0
IHN0aWwgbWFza2VkIHVudGlsIHRoZSB2SVJRIHRocmVhZA0KPiA+Pj4gY29tcGxldGVzLCBwcmV2
ZW50aW5nIHRoZSBwaHlzaWNhbCBJUlEgZnJvbSBiZWluZyBwcm9wYWdhdGVkIHRvIHRoZQ0KPiA+
PiBndWVzdD8NCj4gPj4NCj4gPj4gRXZlbiBpZiB2SVJRIGlzIHN0aWxsIG1hc2tlZCBieSB0aGUg
dGltZSB3aGVuDQo+ID4+IHZmaW9fYXV0b21hc2tlZF9pcnFfaGFuZGxlcigpIHNpZ25hbHMgdGhl
IGV2ZW50ZmQgKHdoaWNoIGluIGl0c2VsZiBpcw0KPiA+PiBub3QgZ3VhcmFudGVlZCwgSSBndWVz
cyksIEkgYmVsaWV2ZSBLVk0gaXMgYnVmZmVyaW5nIHRoaXMgZXZlbnQsIHNvDQo+ID4+IGFmdGVy
IHRoZSB2SVJRIGlzIHVubWFza2VkLCB0aGlzIG5ldyBJUlEgd2lsbCBiZSBpbmplY3RlZCB0byB0
aGUgZ3Vlc3QNCj4gPj4gYW55d2F5Lg0KPiA+Pg0KPiA+Pj4+IEl0IHNlZW1zIHRoZSBvYnZpb3Vz
IGZpeCBpcyB0byBwb3N0cG9uZSBzZW5kaW5nIGlycSBhY2sgbm90aWZpY2F0aW9ucw0KPiA+Pj4+
IGluIEtWTSBmcm9tIEVPSSB0byB1bm1hc2sgKGZvciBvbmVzaG90IGludGVycnVwdHMgb25seSku
IEx1Y2tpbHksDQo+IHdlDQo+ID4+Pj4gZG9uJ3QgbmVlZCB0byBwcm92aWRlIEtWTSB3aXRoIHRo
ZSBpbmZvIHRoYXQgdGhlIGdpdmVuIGludGVycnVwdCBpcw0KPiA+Pj4+IG9uZXNob3QuIEtWTSBj
YW4ganVzdCBmaW5kIGl0IG91dCBmcm9tIHRoZSBmYWN0IHRoYXQgdGhlIGludGVycnVwdCBpcw0K
PiA+Pj4+IG1hc2tlZCBhdCB0aGUgdGltZSBvZiBFT0kuDQo+ID4+PiB5b3UgbWVhbiB0aGUgdklS
USByaWdodD8NCj4gPj4gUmlnaHQuDQo+ID4+DQo+ID4+PiBCZWZvcmUgZ29pbmcgZnVydGhlciBh
bmQgd2UgaW52ZXN0IG1vcmUgdGltZSBpbiB0aGF0IHRocmVhZCwgcGxlYXNlDQo+ID4+PiBjb3Vs
ZCB5b3UgZ2l2ZSB1cyBhZGRpdGlvbmFsIGNvbnRleHQgaW5mbyBhbmQgY29uZmlkZW5jZQ0KPiA+
Pj4gaW4vdW5kZXJzdGFuZGluZyBvZiB0aGUgc3Rha2VzLiBUaGlzIHRocmVhZCBpcyBmcm9tIEph
biAyMDIxIGFuZCB3YXMNCj4gPj4+IGRpc2NvbnRpbnVlZCBmb3IgYSB3aGlsZS4gdmZpby1wbGF0
Zm9ybSBjdXJyZW50bHkgb25seSBpcyBlbmFibGVkIG9uDQo+ID4+IEFSTQ0KPiA+Pj4gYW5kIG1h
aW50YWluZWQgZm9yIHZlcnkgZmV3IGRldmljZXMgd2hpY2ggcHJvcGVybHkgaW1wbGVtZW50IHJl
c2V0DQo+ID4+PiBjYWxsYmFja3MgYW5kIGR1bHkgdXNlIGFuIHVuZGVybHlpbmcgSU9NTVUuDQo+
ID4gRG8geW91IGhhdmUgbW9yZSBxdWVzdGlvbnMgYWJvdXQgdGhpcyBpc3N1ZSBhZnRlciBmb2xs
b3dpbmcgaW5mbyBhbmQNCj4gUE9DIGZyb20NCj4gPiBEbXl0cm8/DQo+ID4gSSBhZ3JlZSB0aGF0
IHdlIHRyaWVkIHRvIGV4dGVuZCB0aGUgdmZpbyBpbmZyYXN0cnVjdHVyZSB0byB4ODYgYW5kIGEg
ZmV3DQo+IG1vcmUNCj4gPiBkZXZpY2VzIHdoaWNoIG1heSBub3QgInRyYWRpdGlvbmFsbHkiIHN1
cHBvcnRlZCBieSBjdXJyZW50IHZmaW8NCj4gaW1wbGVtZW50YXRpb24uDQo+ID4gSG93ZXZlciBp
ZiB3ZSB2aWV3IHZmaW8gYXMgYSBnZW5lcmFsIGluZnJhc3RydWN0dXJlIHRvIGJlIHVzZWQgZm9y
IHBhc3MtDQo+IHRocnUNCj4gPiBkZXZpY2VzICh0aGlzIGlzIHdoYXQgd2UgaW50ZW5kIHRvIGRv
LCBpbXBsZW1lbnRhdGlvbiBtYXkgdmFyeSksDQo+IE9uZXNob3QNCj4gPiBpbnRlcnJ1cHQgaXMg
bm90IHByb3Blcmx5IGhhbmRsZWQuDQo+IA0KPiBzb3JyeSBmb3IgdGhlIGRlbGF5LCBJIHdhcyBv
dXQgb2Ygb2ZmaWNlIGFuZCBpdCB0b29rIG1lIHNvbWUgdGltZSB0bw0KPiBjYXRjaCB1cC4NCj4g
DQo+IFllcyB0aGUgcHJvYmxlbSBhbmQgY29udGV4dCBpcyBjbGVhcmVyIG5vdyBhZnRlciB0aGUg
bGFzdCBlbWFpbHMuIEkgbm93DQo+IHVuZGVyc3RhbmQgdGhlIHZFT0kgKGluZHVjaW5nIHRoZSBW
RklPIHBJUlEgdW5tYXNrKSBpcyBkb25lIGJlZm9yZSB0aGUNCj4gZGV2aWNlIGludGVycnVwdCBs
aW5lIGlzIGRlYXNzZXJ0ZWQgYnkgdGhlIHRocmVhZGVkIGhhbmRsZXIgYW5kIHRoZSB2SVJRDQo+
IHVubWFzayBpcyBkb25lLCBjYXVzaW5nIHNwdXJpb3VzIGhpdHMgb2YgdGhlIHNhbWUgb25lc2hv
dCBJUlEuDQo+IA0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCg0KTm8gcHJvYmxlbS4gIEdvb2Qgc3Vt
bWFyeSBvZiB0aGUgcHJvYmxlbTotKSAgQW5kIHRoYW5rcyBmb3IgY29uZmlybWluZyB0aGF0DQp5
b3UgYWdyZWUgb25lc2hvdCBpbnRlcnJ1cHQgaGFuZGxpbmcgaXMgYW4gaXNzdWUgaW4gdmlydHVh
bGl6ZWQgZW52aXJvbm1lbnQuDQoNClRoYW5rcywNCg0KUm9uZw0KPiA+DQo+ID4gRnJvbSB0aGlz
IGRpc2N1c3Npb24gd2hlbiBvbmVzaG90IGludGVycnVwdCBpcyBmaXJzdCB1cHN0cmVhbWVkOg0K
PiA+IGh0dHBzOi8vbGttbC5pdS5lZHUvaHlwZXJtYWlsL2xpbnV4L2tlcm5lbC8wOTA4LjEvMDIx
MTQuaHRtbCBpdCBzYXlzOg0KPiAiLi4uIHdlDQo+ID4gbmVlZCB0byBrZWVwIHRoZSBpbnRlcnJ1
cHQgbGluZSBtYXNrZWQgdW50aWwgdGhlIHRocmVhZGVkIGhhbmRsZXIgaGFzDQo+IGV4ZWN1dGVk
Lg0KPiA+IC4uLiBUaGUgaW50ZXJydXB0IGxpbmUgaXMgdW5tYXNrZWQgYWZ0ZXIgdGhlIHRocmVh
ZCBoYW5kbGVyIGZ1bmN0aW9uIGhhcw0KPiBiZWVuDQo+ID4gZXhlY3V0ZWQuIiB1c2luZyB0b2Rh
eSdzIHZmaW8gYXJjaGl0ZWN0dXJlLCAocGh5c2ljYWwpIGludGVycnVwdCBsaW5lIGlzDQo+ID4g
dW5tYXNrZWQgYnkgdmZpbyBhZnRlciBFT0kgaW50cm9kdWNlZCB2bWV4aXQsIGluc3RlYWQgYWZ0
ZXIgdGhlDQo+IHRocmVhZGVkDQo+ID4gZnVuY3Rpb24gaGFzIGJlZW4gZXhlY3V0ZWQgKG9yIGlu
IHg4NiB3b3JsZCwgd2hlbiB2aXJ0dWFsIGludGVycnVwdCBpcw0KPiA+IHVubWFza2VkKTogdGhp
cyB0b3RhbGx5IHZpb2xhdGVzIGhvdyBvbmVzaG90IGlycSBzaG91bGQgYmUgdXNlZC4gICBXZQ0K
PiBoYXZlIGEgZmV3DQo+ID4gaW50ZXJuYWwgZGlzY3Vzc2lvbnMgYW5kIHdlIGNvdWxkbid0IGZp
bmQgYSBzb2x1dGlvbiB3aGljaCBhcmUgYm90aA0KPiBjb3JyZWN0IGFuZA0KPiA+IGVmZmljaWVu
dC4gIEJ1dCBhdCBsZWFzdCB3ZSBjYW4gdGFyZ2V0IGEgImNvcnJlY3QiIHNvbHV0aW9uIGZpcnN0
IGFuZCB0aGF0DQo+IHdpbGwNCj4gPiBoZWxwIHVzIHJlc29sdmUgYnVncyB3ZSBoYXZlIG9uIG91
ciBwcm9kdWN0cyBub3cuDQo+ID4NCj4gPj4gU3VyZS4gV2UgYXJlIG5vdCByZWFsbHkgdXNpbmcg
dmZpby1wbGF0Zm9ybSBmb3IgdGhlIGRldmljZXMgd2UgYXJlDQo+ID4+IGNvbmNlcm5lZCB3aXRo
LCBzaW5jZSB0aG9zZSBhcmUgbm90IERNQSBjYXBhYmxlIGRldmljZXMsIGFuZCBzb21lDQo+IG9m
DQo+ID4+IHRoZW0gYXJlIG5vdCByZWFsbHkgcGxhdGZvcm0gZGV2aWNlcyBidXQgSTJDIG9yIFNQ
SSBkZXZpY2VzLiBJbnN0ZWFkIHdlDQo+ID4+IGFyZSB1c2luZyAoaG9wZWZ1bGx5IHRlbXBvcmFy
aWx5KSBNaWNhaCdzIG1vZHVsZSBmb3IgZm9yd2FyZGluZw0KPiA+PiBhcmJpdHJhcnkgSVJRcyBb
MV1bMl0gd2hpY2ggbW9zdGx5IHJlaW1wbGVtZW50cyB0aGUgVkZJTyBpcnENCj4gZm9yd2FyZGlu
Zw0KPiA+PiBtZWNoYW5pc20uDQo+ID4+DQo+ID4+IEFsc28gd2l0aCBhIGZldyBzaW1wbGUgaGFj
a3MgSSBtYW5hZ2VkIHRvIHVzZSB2ZmlvLXBsYXRmb3JtIGZvciB0aGUNCj4gc2FtZQ0KPiA+PiB0
aGluZyAoanVzdCBhcyBhIFBvQykgYW5kIGNvbmZpcm1lZCwgdW5zdXJwcmlzaW5nbHksIHRoYXQg
dGhlIHByb2JsZW1zDQo+ID4+IHdpdGggb25lc2hvdCBpbnRlcnJ1cHRzIGFyZSBvYnNlcnZlZCB3
aXRoIHZmaW8tcGxhdGZvcm0gYXMgd2VsbC4NCj4gPj4NCj4gPj4gWzFdDQo+ID4+DQo+IGh0dHBz
Oi8vY2hyb21pdW0uZ29vZ2xlc291cmNlLmNvbS9jaHJvbWl1bW9zL3RoaXJkX3BhcnR5L2tlcm5l
bC8rLw0KPiA+PiByZWZzL2hlYWRzL2Nocm9tZW9zLTUuMTAtbWFuYXRlZS92aXJ0L2xpYi9wbGF0
aXJxZm9yd2FyZC5jDQo+ID4+DQo+ID4+IFsyXQ0KPiA+PiBodHRwczovL2xrbWwua2VybmVsLm9y
Zy9rdm0vQ0FKLQ0KPiA+Pg0KPiBFY2NQVThLcFU5NlBNMlB0cm9MamROVkRidm54d0t3V0pyMkIr
UkJLdVhFcjdWd0BtYWlsLmdtYWlsDQo+ID4+IC5jb20vVC8NCj4gPj4NCj4gPj4gVGhhbmtzLA0K
PiA+PiBEbXl0cm8NCg0K
