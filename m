Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2936B88AC
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 03:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCNCiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 22:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNCiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 22:38:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7927F8A56;
        Mon, 13 Mar 2023 19:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678761494; x=1710297494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hDPfO4oLWwjI1pYXvHU/1IRB8RnFA1iLwQ3CZ7WkcTU=;
  b=BcqnX+ZhKT1GlVf/furd+dxKxP++cR49yF0JjHKMvj8tEwi3pXMeqWGR
   yp1MZwu7802d/O+Z0cIph7ygsGKzAY9opZXgUs4OYm01ORzQMpMW7a4w+
   BjnrWITLk2HY3w4WWREeP+WNklrnbYJo5YFF8A5dSVMfvJPeaC8BZBM21
   qrVl64NEj/qW71rFErYfKLu928135mRdSa43nhF0t5eEDpCebp8BlPeiG
   iPQbeixhQTWlYxXR32IjqZf3uyqllfYlSRZKA1Ft4VfI0RUmlGvl0zzX3
   rO7B0VeNBA2JQ/BBFd4b9Px4vD9t2DOggra+I1LY+n1GP/P0B/ez0VTUu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="423581015"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="423581015"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 19:38:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="656179395"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="656179395"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 13 Mar 2023 19:38:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 19:38:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 19:38:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 19:38:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 19:38:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gt4YxScO0pigqHQxhUpmotSuNcWq5N84t8grZ921nb7lJHtxvAqYq+snHB9tDde8/p5JN1gLy+rRHW/WgEAzS09Sjc76Z3T4L0jXdeNG4fHbPOgpTbUp1oSSG03mPUijUViit5b1TKykPAwlaZixKqDdFt3KQTj8QDlln/tJTA7o+jLRZ7njk7B398nNJ7RaAC0mzJ7ZGF+RVLMSaQdejOvZBTV+kNLzaMKvOE7nUYugs/50J8mpSSag8kMq6E2b/MrVyYq2iOIhj6Zl35ESrKS5B4BYnoiudYzCxLnOaO3JMxLiBEzZxtemRmcQLrEpz8la+GSzv0BWrN/DdwagGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDPfO4oLWwjI1pYXvHU/1IRB8RnFA1iLwQ3CZ7WkcTU=;
 b=c1eJzA8VwMih3D54dgsPjOE5kVOEI/nosx0pP/28ktA5MDIOGezp750sSrOYx+itXy6co3LQKk0o1Tc7SM0uettgFFPYDJcODcLpXEXIvC5uDLySiJyh6Q3JKt3PsMQwAnJpxiemVZp3vO+Ryr67VUloG0WkbhL0Yaf++xOrwAsFt3BW5UC97MF9xJP6emQroRSxpRIuIGuIVrXWH3WGg8Qj4kryMil5gqMqmExhUGKT3MhIs1NddaPWgDHG/x/a6PjHf1OZpYsJbn4Ymt3JP9TWqmSWCMtuItTKQ3Yn6ybZ6dJq5Je9UxGhjdG0yNQyZjxvXB0/k0rn7YnvtvAhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 02:38:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 02:38:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeA
Date:   Tue, 14 Mar 2023 02:38:06 +0000
Message-ID: <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
In-Reply-To: <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4854:EE_
x-ms-office365-filtering-correlation-id: b789c09c-9ac2-4f7e-a751-08db2435241c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5PScgQQbh63i9fK7HXxeCOHkFrD39eaS47njf52pW2oGM0xzaoL8Nk4DZZJWLDi7MpL6rjUfsvN12bz4jb7TXWoAqTdknv6AjJU4wmkqTBa/vGxmOX3bPwLMFUmSaggjWZLjdXeOc/Ur5Dlu9IFkUCXk8IF92EAdYwmgTsflRTxPeRze/sh2ZbKxqHtqkIJlce4O2erM0Jnow3ouJqDd7dsS9RHvV72dEAQPO1Awb03dQrBIFEDtuyzH6/0YK4AyIaKZczj/s3s/yt2u9YmEWVX0NJmXsBd/1+R2gd22Ns1lHimlmpW1VSZlqicKut50UzMx1lzt3L71LHpugLoPdR0L6nWYesBLmwcwCNLOa8gi35w4muUZKeB8OssDVBMJqBT9/Jv2eE9+FXkTmMwH7VMVzSEsQNi8pR17fkOGLWSexN6xDOR87kqqpQ5IVt2i6oxgtWngbqdqe1bfAEYtLVEah/urK8Y0PK5BIHfKzF/EQH605UpD9/WUXGi52TXY2+8gkPGd0VUOt20dBPTq680NKe0S9139iau7Ab6eZ12BzngsMV4eV6nfYUJjzfh+iXeluZ+DlAz9xfILxHBrXxzpCZCM7UbQxM8By+lzrYIcdCraW9WB22lFhfMI7uBMjPZOTvndpg6JX5A467VYjbyXRNwQcc6TelN8VMScpyIOz75cE2DomDOB09+0g/EzisSiq0m9piZfLJLG+r6XfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199018)(122000001)(82960400001)(38100700002)(91956017)(66946007)(66556008)(66476007)(64756008)(76116006)(66446008)(4326008)(41300700001)(110136005)(8936002)(316002)(38070700005)(54906003)(6636002)(83380400001)(8676002)(478600001)(5660300002)(71200400001)(86362001)(6486002)(36756003)(2616005)(6512007)(6506007)(186003)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjBPTjl6cHd6T3VwMHQ3N3hjeTdJSThPMW5LRGY3UHZ6ZFR6NXFDR0p2TThD?=
 =?utf-8?B?K3gyWVliUnlPUnYzV1BmNURCMHBPeVZKZGtVTUZjZlBvYVlPUGYxK1pEaysv?=
 =?utf-8?B?WWFJTFEwaTBqSEtMVlRQOFIzOG56Z2lvNHdkWGdHOHNKcU53TnkxeEtqeExj?=
 =?utf-8?B?Q0xnY3pNS3FQRkE3dDA1UW5IbnQzcXNrNDFOdVhtVHNsTFF5NUVEdmJJSGVa?=
 =?utf-8?B?Qi9qR01tdC92RWRXc0Q3QjlaaEFITXR0US9ON0pra2Y3ODJBN1Qvc1N0dEY5?=
 =?utf-8?B?Nmo1bzZKRjMrN0JYVWg0SEZlaGczdndVN09YSDVyYkJ1VVQvYzJzT0Zoc2Vo?=
 =?utf-8?B?M1Vrb3Y1VnhPYUwwQlNGaEdxbWJFdU94dGFpaHlmbTFSTEdxSGh2bVlYZTJs?=
 =?utf-8?B?bUt6Ny9KTTFQZ1I1U2NhaUlVTW1lV1I3Y2JoM0NFUzlLK1h4NTZkRGo3ZXYr?=
 =?utf-8?B?MHIxeE0yUXZLZEhxSThoSFRZdDA0cDlHd0gyc3RORjhiaXN1c2xvb3k3T3gx?=
 =?utf-8?B?Q3RBSDVPWUw5anhhRXBrbXo0Y0JCckVBOGdlOWtCZU5Ec1VkUnl0TUtmbnFw?=
 =?utf-8?B?MXhTeWtqL0dxRUMvclJZUFVsOGFPZjduM2xBWnpacXZIQ2s0SkNJaGQ1ZmZz?=
 =?utf-8?B?U01WS0ZQTDZ4cXhuWVJQLzBxdFNSM1VnUHJmc2xWRDhwbU0xNmZKWEhNcjEr?=
 =?utf-8?B?MjBlMG1ZaVpSU3pwaG8yZFFra1lVWHhZcDZvbXJUUGt4dVFYMUh4ZENxd3po?=
 =?utf-8?B?Z053RCs1VjZER1cxNi9ZZnZyR1pKRXFnTnFOaHYwMWxZOXp6Y3FHUWExVUxa?=
 =?utf-8?B?NC9EanhCUVYxQVNDSnFkdkVTMDN5c1pVU1dBWGpTdGF5STUvdTBQSUszS0t6?=
 =?utf-8?B?RHZJaHlQcHBLVlhYb0xLRUs0Q05WYzZnakdyOUNoZCtzTytlTjhGVitHOEFp?=
 =?utf-8?B?STBIbXZiYnpsczBoN2tTM2xwMEpNZWQ1dVZRTE5VMzdyNTl1YUs5MWkyRFlp?=
 =?utf-8?B?am5sZHJjOEhWNVJCUE02bWxsOXJLK1FiaGxYWUN3V2toNFo0djg2SG8zekhG?=
 =?utf-8?B?K1JzTkdXd1dqQXBHd01ONC9aS1UwOUNJWUlTQkFNMGN5d3I2bEFGSDlFTnhm?=
 =?utf-8?B?c0U3a1Q0WFNiM2xxbUNmeloyYU95TWQxY0xqZXNDODR0K2Q0cW5uT29RaE9J?=
 =?utf-8?B?UXRSZ2dhR3hUZXRoRWwxRjB2MnBORHo4aW5oU2I5alZhRHZnenFNMEI4bTEy?=
 =?utf-8?B?OERTcWVxUWpucWpsVGdGdEE0bC9IMXd3VEJQK0ZTY2M2M25hcGRwNFRMN0VN?=
 =?utf-8?B?TUhsY0hqL09LeE1Ed1pxVllZNUxDVGpTejZleEVCYlFzNWFwMjhwWjRMNktN?=
 =?utf-8?B?Nm0xcEJYenJhaXdHRU4xbzREckFuYi9mTGlJek9pYkZMN2R0aW5vNW5rZEZD?=
 =?utf-8?B?cUczNE1LK3cvbW9pU3hmR0o5amV6Um9NbG5MR2JzdkV1L1p1R3pGemtNelZk?=
 =?utf-8?B?MVhIQ3daRDdGSUtUNnowZTQwVVo2clZudjZPdmhqcEdzMzY0a2sxa3JCdnZ5?=
 =?utf-8?B?NmNMMlJKRzBicEdGeTc0Y3YzTW5kS1h4NlpWdndjWEZTRTA2THJ2RjMram5h?=
 =?utf-8?B?T0FWbnhJNHFuWFFHWG9ES2EyVFpaYThMdGxKVEJUK29kU0JOUTNqWWVZTU52?=
 =?utf-8?B?Q2NlZGNsN3I5eW9PS2hIT3VHRDNCUEowdndmc1g4R2lCdEFMbUFGZ1NxT1Yy?=
 =?utf-8?B?eG0zMEx5V2FUVmhoNGRhQnZwS1NnWnpDdXJRbTFXZUI5SGhOKzZXWU11M2RN?=
 =?utf-8?B?amVBaVZGN3dCWkVnYUNRRnB0VDVWd2xINGY5SGFEQU1aNTBaRFcvdFJmOTl0?=
 =?utf-8?B?VVpVT0lrR1hZWko1bUJQdGFtZTdaeGlma0F5cVlRRlFIcWorVXJjTVJ4YzIz?=
 =?utf-8?B?NHFlOUhWVXljcjdFUnAwd0R4andiSnZka2I2U3VRdDh6eVdJTWZKYzJOK2xC?=
 =?utf-8?B?SWk4QWVUcFZzKzNpNndEUkNvaktYaHlheS9mVXV1OURySWNQWXhtMVZMSDZV?=
 =?utf-8?B?QzJKZldYV3BYdkRhaGRDeFpQZVVzOU40cGcvZ1c0RkFlSXV2MmVIVytBSWs5?=
 =?utf-8?B?dGpnR1ZkTk9TU0NWSDdFSGIzb0ZEZHBnL1NIcldOK0hmbFluUngyeEhzSlZC?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41BED874FFE0594193E5197577AB8219@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b789c09c-9ac2-4f7e-a751-08db2435241c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 02:38:06.0468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ZBSZ0s8LY2pBDIIpBw+98BJowD/dxvnUHsW3+mMdLIz6nztEbmOhjmedD7pKC6ThGkdJTmYyqx59bCHCa7L5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTEyIGF0IDEwOjU1IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtpbnQgX19pbml0IHRkeF9oYXJkd2FyZV9zZXR1cChzdHJ1Y3Qga3ZtX3g4
Nl9vcHMgKng4Nl9vcHMpDQo+ICt7DQo+ICsJaW50IHI7DQo+ICsNCj4gKwlpZiAoIWVuYWJsZV9l
cHQpIHsNCj4gKwkJcHJfd2FybigiQ2Fubm90IGVuYWJsZSBURFggd2l0aCBFUFQgZGlzYWJsZWRc
biIpOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo+ICsNCj4gKwkvKiB0ZHhfZW5hYmxl
KCkgaW4gdGR4X21vZHVsZV9zZXR1cCgpIHJlcXVpcmVzIGNwdXMgbG9jay4gKi8NCj4gKwljcHVz
X3JlYWRfbG9jaygpOw0KPiArCS8qIFREWCByZXF1aXJlcyBWTVguICovDQo+ICsJciA9IHZteG9u
X2FsbCgpOw0KDQpXaHkgbm90IHVzaW5nIGhhcmR3YXJlX2VuYWJsZV9hbGwoKT8NCg0KPiArCWlm
ICghcikgew0KPiArCQlpbnQgY3B1Ow0KPiArDQo+ICsJCS8qDQo+ICsJCSAqIEJlY2F1c2UgdGR4
X2NwdV9lbmFiZWwoKSBhY3F1aXJlIHNwaW4gbG9ja3MsIG9uX2VhY2hfY3B1KCkNCj4gKwkJICog
Y2FuJ3QgYmUgdXNlZC4NCj4gKwkJICovDQo+ICsJCWZvcl9lYWNoX29ubGluZV9jcHUoY3B1KSB7
DQo+ICsJCQlpZiAoc21wX2NhbGxfb25fY3B1KGNwdSwgdGR4X2NwdV9lbmFibGVfY3B1LCBOVUxM
LCBmYWxzZSkpDQo+ICsJCQkJciA9IC1FSU87DQo+ICsJCX0NCj4gKwkJaWYgKCFyKQ0KPiArCQkJ
ciA9IHRkeF9tb2R1bGVfc2V0dXAoKTsNCj4gKwl9DQo+ICsJdm14b2ZmX2FsbCgpOw0KPiArCWNw
dXNfcmVhZF91bmxvY2soKTsNCj4gKw0KPiArCXJldHVybiByOw0KPiArfQ0KDQpJIHRoaW5rIHlv
dSBzaG91bGQgdXNlIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSwgYW5kIGp1c3QgZG8gc29tZXRoaW5n
IHNpbWlsYXIgdG8NCmJlbG93IGluIHZteF9oYXJkd2FyZV9lbmFibGUoKToNCg0KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQppbmRl
eCA3ZWVjMDIyNmQ1NmEuLmI3YjNmOTljMDA5NSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS92
bXgvdm14LmMNCisrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCkBAIC0yNTA0LDYgKzI1MDQs
MTUgQEAgc3RhdGljIGludCB2bXhfaGFyZHdhcmVfZW5hYmxlKHZvaWQpDQogICAgICAgICAgICAg
ICAgcmV0dXJuIHI7DQogICAgICAgIH0NCiANCisgICAgICAgaWYgKGVuYWJsZV90ZHgpIHsNCisg
ICAgICAgICAgICAgICByID0gdGR4X2NwdV9lbmFibGUoKTsNCisgICAgICAgICAgICAgICBpZiAo
cikgew0KKyAgICAgICAgICAgICAgICAgICAgICAgY3B1X3ZteG9mZigpOw0KKyAgICAgICAgICAg
ICAgICAgICAgICAgaW50ZWxfcHRfaGFuZGxlX3ZteCgwKTsNCisgICAgICAgICAgICAgICAgICAg
ICAgIHJldHVybiByOw0KKyAgICAgICAgICAgICAgIH0NCisgICAgICAgfQ0KKw0KICAgICAgICBp
ZiAoZW5hYmxlX2VwdCkNCiAgICAgICAgICAgICAgICBlcHRfc3luY19nbG9iYWwoKTsNCg0KSXQg
aGFuZGxlcyB0d28gY2FzZXMgYXV0b21hdGljYWxseToNCg0KMSkgV2hlbiB1c2VyIHdhbnRzIHRv
IHVzZSBURFggd2hpbGUgbG9hZGluZyBLVk0gbW9kdWxlLCBpZiBhYm92ZSBmYWlscywgdGhlbg0K
aGFyZHdhcmVfZW5hYmxlX2FsbCgpIHJldHVybnMgZXJyb3IsIGFuZCB5b3UganVzdCBnaXZlIHVw
IGluaXRpYWxpemluZyBURFgNCm1vZHVsZSBhbmQgbWFyayBlbmFibGVfdGR4IGFzIGZhbHNlLg0K
DQoyKSBXaGVuIGEgbmV3IGNwdSBiZWNvbWVzIG9ubGluZSwgYW5kIHdoZW4gVERYIGlzIGJlaW5n
IHVzZWQgYnkgS1ZNLCB0aGVuIGlmDQphYm92ZSBmYWlscywgaXQgYXV0b21hdGljYWxseSByZWpl
Y3RzIHRoZSBDUFUgd2hpY2ggaXNuJ3QgVERYLXJ1bm5hYmxlIGFsdGhvdWdoDQppdCBpcyBWTVgt
cnVubmFibGUuDQo=
