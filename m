Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6626368068D
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 08:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbjA3HgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 02:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjA3HgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 02:36:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4E91A4A5
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 23:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675064177; x=1706600177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U3dF2V4BwRcbDdCUgXrvLiM2d1Zk4w8sL5aAeK0rOF4=;
  b=aGLW2vnNKjcZOP6ep5jZyWQADUo7mmT54FcjMvBdmBP01MKRNYxPG/q1
   3MVfgA8zI9Z0OSF8n6ZS7ETUQfUmXN4q6QHn786tsrI+GRaGYLYzxCdat
   ROv7cah2F8EaL4xZMcV428/WY639x31ZAExZf1VSSYFQjIFX93iyDRALO
   9MyHSgP6YOO/FX1DmwP49RLW/7FW6N9HCwBze9teVkzmr8e11RRh+u0oi
   BB/6jIhfi+dI1Rt4PGAEMzF9Z6JQiKschNDVQO8qRHF0YNXgA5hJIKi5A
   u7H0prkTRmjIVklOrj//kdNCPEJrpPN+bXhX5c+E3rZU0GC6ngobqZvkB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="328773653"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="328773653"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 23:36:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="663995440"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="663995440"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 29 Jan 2023 23:36:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 23:36:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 23:36:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 29 Jan 2023 23:36:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 29 Jan 2023 23:36:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWJfQRoqg/lQVLZ+NSpD22tiLAa0yit9HlxkwDCPVxsZ/bcSh4ULbMh/0XER/4xnL+LcsMCnuZz3FRS9ghQMAeE+G9lQEmRVM1tPA0QF4zOJVX/XgnH+xCR1fl8ssH+AsaruvG/ttUkCP/QWHZ9bshQNj2rOr0V9/2bvRzuaXitkxpLj3147jOWAEtp5HyZSNJ7KPgfDZCASMOe/spUo0VOiq8xO9wgtHlTlCiU7MCtp4CGziYm4F9n+w1N3ZcIFE7yYRvlvtnipuQdczHAlkvONLWlmhb13ONQnh3fHnh/rUaWfBPh8POJXnmRkpLpzzxt56CzJeELmGbGzqDTKRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3dF2V4BwRcbDdCUgXrvLiM2d1Zk4w8sL5aAeK0rOF4=;
 b=NEb4TpUwjHpq+QpbpqHnuerv/GdVaF5Wkr1RQwYFOSAOq2KX9NxlNJpI+eaxm6UF43W0WCkO/c3tDwsbMye/cInkRUUAz6JKJ46HUchZz1Uj3oJdmYYiYnrO44L1WUbfNvXYPedlHeWXNTQdS1Xa6wFOEGx1m5ieEgz7C7YW4tnHjUpzW3z/E7JaGAiIKVgBW94qdAMua1cSlmmAPfeb+TkG/SuSjBi78vslK4/uCdLrzveI5gKCuHi8gYnC8qXv0Ovwc6YaxYqGueFpPoQguyr8LMKyQ6T+Q16/fj7DCe5QOYaxDbpkZwHo2lvpUwvSNraHEGN5ohMWC72dSWfVGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB5123.namprd11.prod.outlook.com (2603:10b6:303:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 07:36:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 07:36:12 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 06/13] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH 06/13] kvm/vfio: Accept vfio device file from userspace
Thread-Index: AQHZKnqVcRPtM7ePBUqmQgYp3vR7IK6lfbIAgBEmu/A=
Date:   Mon, 30 Jan 2023 07:36:12 +0000
Message-ID: <DS0PR11MB752945FA0E5E8462A04B0A15C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-7-yi.l.liu@intel.com>
 <a9d03e80-dff5-aa6e-c118-b1299fabbe5d@redhat.com>
In-Reply-To: <a9d03e80-dff5-aa6e-c118-b1299fabbe5d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CO1PR11MB5123:EE_
x-ms-office365-filtering-correlation-id: a5591b22-a756-42a5-d12c-08db0294a9a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LINQC5QVlbXAjlx+lHPnpiqvVgr+LaVMEF4ciGj586nb3K5GqC3BWIxqidgdpEUrD1CzmivGf/MXck5/ngKrunje/SX3EIT8SpMxIRcVc3PhgthBmyUBkmAFy5E+jlOwoIj2/grPJMEXTr5OQ1IMk4Pc+Y8V+Nxqb7obkl1HMCRdLgWxqMcBLDjq0ESKfxjUANa/49ZGm2OBej2nc+FV3KJ57+hBrZ7QyInQg5Ie/VX5NJ+bnzxec4f1bIUua9kiH2NSGKmqeEADTda+KwIZIqkhEaszDl9eCbE5OKUqG/Td9ck9Im+SjoYNjg3ZGnfyJqqzyjt2kB4A7Ez+PmjzTRk/LSdfHB5lgosBLexJKE+wBUeysqmfS+NWcGvurU9lpypVe0pcVbTm6j/p7zsSTAXnvE9wYRPrJ8GeSZED/bkXwhmlzA8tGsVdjD9QBY3Nsco9JBYr9hBVimpzkEmTw+Zjprt4LETheIOcB24HV0LdHOf2VMFSlRJDEb/f1GcEkl7nna6cje299AOWd7r+JzDzLYUL7fVYIz+xIi3xJQmO18laOef/0GB+jvSq1xgTexVngAZ5nMTlpLsz5JV3MwrJLrqZXI0in7+o/5bjlohxVsXXz9C41jztLQM91qSo6+bBTBWoFecoieh6NZY+nB84U8EIvPWRnhtD059pa2XZ9lwq5QjFNIP6emnw9kd1EijeNEFKsq2uYObdaPZPk1NRzW/5jlBvXCzbzJFjzes=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(110136005)(316002)(54906003)(66946007)(66476007)(8676002)(4326008)(66556008)(66446008)(76116006)(64756008)(8936002)(52536014)(5660300002)(122000001)(38100700002)(86362001)(38070700005)(33656002)(82960400001)(41300700001)(53546011)(71200400001)(9686003)(26005)(6506007)(186003)(7416002)(55016003)(2906002)(478600001)(7696005)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDRYeUZiSDlCWWpCcy9Ia2hNcXdBVThqUWpzcHZxMmxwN0U0NTVEMXIwejBh?=
 =?utf-8?B?aFBZZUdVLzVBZXpnaXBDSkRocDdJN3NOcUNVdlhQNThKazl6NWtLV05iV3BL?=
 =?utf-8?B?U3lOWGE0N0FSd3lJaitaZ1laeHk4MjFZMWRTcFc0b0dpL2lYZ2h4VEdYUGZF?=
 =?utf-8?B?Ukx0NERuL1NLaHBYaFlvTjJVbEswWnZZeVlIdWRUN0ZPU21FMkJUSHAyL2Qv?=
 =?utf-8?B?MnVVdklTdFUrRi9SK1pRMWdqdUExMmUxdzFlc2IxOUJVNFF6RkxoMGh4bmNw?=
 =?utf-8?B?dW9hYkZYTTMzamZCQ1g5K25saVRzS3RzNmZ0azBFSU9ubW5zUmxpcmI3ZERr?=
 =?utf-8?B?WlpNb0pHc05wWWR3VUp6RGJzSFVsOEJXelVIeU1ZRzJUMzRDOGIwYUhHbm1t?=
 =?utf-8?B?cGNka1dIOTBvTngzSWVpaXViWndPTmlaSjE4SUd1NVFLMVZaS3JjMlkzUmVG?=
 =?utf-8?B?a2xqTGM2Lzk1WEdFNUl4WVBZVlI0aTFmWEo2dHh6aXlBbE5pWTFhNHVVL1VC?=
 =?utf-8?B?QXJ6UVpJTGFYZnBWZ3dWOURBeHVPaEU2MUhJUWpzK1VXMUw1bU1rbTIyOVJY?=
 =?utf-8?B?aTJTbVlLRG00NktuMUxCRmUyQmNjVWwxZ0VSdlJKbDd1TTN2T0ZvMDkvZDZW?=
 =?utf-8?B?Z0JPWGxwb3N6VVdjemVPQ2EvY1NqbVdFR0UzbGkzSTZHL2ZmdVVUQmpKNzRt?=
 =?utf-8?B?djVIWGdManNwWUtGUDhuVkVKMWd6UzVHTm9qdnZ2ZE83SGxsdjUwZ004MW1M?=
 =?utf-8?B?b2VTT3M2TWQ5Ylhsam9pMGswT0VEb2ljcHhST0lEeklKRFUzU0NrSVorQ25Z?=
 =?utf-8?B?WUd0OHBGcVNUM3IvRUxrSEduU1FCNFpPUnFqQmdJRVF6bkJiU3hzQWsxN2h0?=
 =?utf-8?B?M3NlSXkvdXE1UGJMY3VrVmNha0xwcm1UWEFEZE15Nyt3OHJLU0hscjZQY2h4?=
 =?utf-8?B?V3JhWnNOZFV1NGdiVlF6SFdBNzhOTnA5ZHJrRENjWk5Ea3YzRXdCVUR1Ui82?=
 =?utf-8?B?bUdoeVVCdGJUbDEvYkFveG9BaGJVUGphUVplS252bHdSQ0xRZXFMbCtOa2d1?=
 =?utf-8?B?elZhRGFRbDVrdnI3TkRtbGVyNStHMUl0VmFqK29BYnVmaDFDYzBpbnBzT042?=
 =?utf-8?B?amFYREpBSWV5R2V1cTB2bWlNL3o5aHlkTEJxb0ZlZWc4Z0FhRVRmOXp1V3pY?=
 =?utf-8?B?MDBWVnRlSWl5Z09KdmdKSzIxdTBhcCtaV3o3RkszN2QxK1FUZlJtQXZtMzUz?=
 =?utf-8?B?TmkvT0tKUFF0cVRXVzF0WTNnRG84OWFIRzBrLzdpbkxsVGNCMDBqeXhNaUlz?=
 =?utf-8?B?T3JEQjhQVWMzSEtlbG5rVWtCeiszWDl3ZXhubzgyOGZPMzM3Q0UydlhPTUJD?=
 =?utf-8?B?dkVEc2F2Zi94eWlFRi84VWx1TSt3UE56Tms4b09wcURQMHA5R1drUW5yajNz?=
 =?utf-8?B?NGtlRW5qTlBjZHJKWXl1TGw5aWc2MHdBRk9RMHVHQVJvenRCUEh6TkdSeEFw?=
 =?utf-8?B?bW5CMFg4bWJEMVFWd2FTblZQeVNVRTlnMUJ1VDViU1dYQVZ6MURsaXlNaytx?=
 =?utf-8?B?VlNBZmo3SW42Q3M4SEhUY0ZXNGNJYVFFcER4NmdIaklDQlpVMitaTE1PdTBJ?=
 =?utf-8?B?QmUyL3E3UVJWTFZWRjNZYlFmMy9lWUc4MFpLYUt4Q0dsVTh2QUIxbXZEOEpO?=
 =?utf-8?B?MnBmNGJiMHk3YWpXYVlaM0hrWG5yVkdITkFZVFpFT0w3SWRKYkQ4V3h0VmR2?=
 =?utf-8?B?dEY2a0sxYjcyUjBxS3dCaG5YM0lXMnhFYUdZWFJiS2N6OU9tbFpodFgyUUlp?=
 =?utf-8?B?bW42RVdjQWxST3VITGNaMndzeElOZkhsaGJ4U2F0UUZTa2VWZGV3T1NvOXhQ?=
 =?utf-8?B?b3NtUm5yQWdxUkExYVdHOGhHNDV6QjVsc0h1RkRsY1llQ01EZU5mV2J3Rko4?=
 =?utf-8?B?WDl2dlVmcTR0YU5PczQxY05GSDJ3enptczFoR2RIdnVHcFFtVTdCMFIxZTdJ?=
 =?utf-8?B?Zy9xUnBYcVZBTWlFWHdpeWxYUzQwOHVOQkNJVzB5NWdOTXNDOXQ3SFhQZjh5?=
 =?utf-8?B?c1dVWXVva1lVOHNjSUMwZHgyamRqWUZ0NG1Xakk0eFE5TnU4b0RxdWFwY0dD?=
 =?utf-8?Q?4kK3vWIhl96qxTWIEQgy2rX2n?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5591b22-a756-42a5-d12c-08db0294a9a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 07:36:12.7417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JVB3UZf0Dn4xOxpc+9sFIxReihfkgi4W9WNrgPl905s2jxwvxNOAjYAy6EvkFnABN6O+TqHl/a9QykyuU5ZbLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5123
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDU6MzUgUE0NCj4gSGkgWWksDQo+IA0KPiBPbiAxLzE3LzIz
IDE0OjQ5LCBZaSBMaXUgd3JvdGU6DQo+ID4gVGhpcyBkZWZpbmVzIEtWTV9ERVZfVkZJT19GSUxF
KiBhbmQgbWFrZSBhbGlhcyB3aXRoDQo+IEtWTV9ERVZfVkZJT19HUk9VUCouDQo+ID4gT2xkIHVz
ZXJzcGFjZSB1c2VzIEtWTV9ERVZfVkZJT19HUk9VUCogd29ya3MgYXMgd2VsbC4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPg0K
PiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkv
bGludXgva3ZtLmgNCj4gPiBpbmRleCA1NTE1NWUyNjI2NDYuLmFkMzZlMTQ0YTQxZCAxMDA2NDQN
Cj4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gPiArKysgYi9pbmNsdWRlL3Vh
cGkvbGludXgva3ZtLmgNCj4gPiBAQCAtMTM5NiwxNSArMTM5NiwyNiBAQCBzdHJ1Y3Qga3ZtX2Ny
ZWF0ZV9kZXZpY2Ugew0KPiA+DQo+ID4gIHN0cnVjdCBrdm1fZGV2aWNlX2F0dHIgew0KPiA+ICAJ
X191MzIJZmxhZ3M7CQkvKiBubyBmbGFncyBjdXJyZW50bHkgZGVmaW5lZCAqLw0KPiA+IC0JX191
MzIJZ3JvdXA7CQkvKiBkZXZpY2UtZGVmaW5lZCAqLw0KPiA+IC0JX191NjQJYXR0cjsJCS8qIGdy
b3VwLWRlZmluZWQgKi8NCj4gPiArCXVuaW9uIHsNCj4gPiArCQlfX3UzMglncm91cDsNCj4gPiAr
CQlfX3UzMglmaWxlOw0KPiA+ICsJfTsgLyogZGV2aWNlLWRlZmluZWQgKi8NCj4gPiArCV9fdTY0
CWF0dHI7CQkvKiBWRklPLWZpbGUtZGVmaW5lZCBvciBncm91cC1kZWZpbmVkICovDQo+IEkgdGhp
bmsgdGhlcmUgaXMgYSBjb25mdXNpb24gaGVyZSBiZXR3ZWVuIHRoZSAnVkZJTyBncm91cCcgdGVy
bWlub2xvZ3kNCj4gYW5kIHRoZSAna3ZtIGRldmljZSBncm91cCcgdGVybWlub2xvZ3kuIENvbW1h
bmRzIGZvciBrdm0gZGV2aWNlcyBhcmUNCj4gZ2F0aGVyZWQgaW4gZ3JvdXBzIGFuZCB3aXRoaW4g
Z3JvdXBzIHlvdSBoYXZlIHN1Yi1jb21tYW5kcyBjYWxsZWQNCj4gYXR0cmlidXRlcy4NCg0KWW91
IGFyZSByaWdodCDwn5iKIHdpbGwgZml4IGl0IGluIG5leHQgdmVyc2lvbi4gU28gZXZlbiB0aGUg
dW5pb24gaXMgbm90DQpuZWVkZWQuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
