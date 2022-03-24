Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3384E5D4B
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 03:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347833AbiCXCoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 22:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiCXCoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 22:44:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BE1939D5
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 19:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648089768; x=1679625768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tD+/gY0wwtlyQoP3S0l5niqmigzWECwKC/+zpE9NYNE=;
  b=Z9W/vul4YaB9/TRTs2Mf6DkEEAKCDYKLh5yd/qYBoQi8rmt9ysud4woT
   50wYNjiGxDspWMdcc8UM35UVFg85+urXv2jXvIFCgm/y/VysUnXHXFBr4
   I+m1UVCsqzWUS+iH9CtiGfT9T6NnmJUfFZLZCByuKmupGCsOM4yWlFJli
   ksKxdVWTDBL8mtQMY4ev1N4mqUsBX4WATH3KzsZh7LpfMMWl2golNWTp3
   6Q3aHi+3XDD/GuI9dFeCFf8433uEml77OYYhL3A/9o9KYxRxIg+1DY/hT
   ITU3AxkuMxGgpG1LfiBFCOxIbmggDseDXNk6vOYUlJ4d9f0FvEEkXvTjt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238874481"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="238874481"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 19:42:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="561183186"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2022 19:42:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 23 Mar 2022 19:42:47 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 19:42:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 23 Mar 2022 19:42:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 23 Mar 2022 19:42:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2XMqohpvZghUPDZ3+8u7ZAEHrNXWn+geIRYV7u1qnBC3Sb6pgdWgraXyvuyWdHCga24W7vv6+gzu91Fbi2d/5zc8nN8ynN4QdluaekjNWdz4r/aGKZkaazxqOXDrmQ9OUCcbL3rZGTpx6BvtzKfP2HpNpnBXnJLuQVHOH8155nqbyyebT7zUbiPhvIjMkr6wD0tKUP8NqOCNk/aqqhe3jxBJRa598tM7R8btsO6Cdqa66oQKmG40hkVjyng30rCQ/CcgpyZGJsbJhLAjTlDtChUkYj020YG0p2FJIn4085zQm0bcHNsFLtQ2Jyqw/IqfC60TOCYbKVuRDQ48TUpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tD+/gY0wwtlyQoP3S0l5niqmigzWECwKC/+zpE9NYNE=;
 b=OsrFWS1gWQDcYYHXI4tNO5gaRihKg122I4w1eDvWrCoJqM1T44Yt5LDYz42c40ChJQJMmvjv6PI1rVyt0NJk5iZE6sp45Pvqyo6W6eUt4A/DsgIb+jpCPNpXzg3s9wwwhxtKPt4EEB3GgxFOiM1QQZFoPUC8wxKiU3jAikGTWeu1IPxb9tMFbJFL0s2+PWngDG1M2Sg+ArVZXdv6918B98GbQ85oapIIxr3Xpb2dOhhvAYGOrR8Sd5R8jCFndgren/6s+NZY2ZGyrCAU+26VLn11y6icILVFGO2gIGxmvylazxht5+SPdwO4CFM4ujJ1DjC9uN8IkhS/cXldTEFD1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB3505.namprd11.prod.outlook.com (2603:10b6:208:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 24 Mar
 2022 02:42:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 02:42:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Thread-Topic: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Thread-Index: AQHYOu2DSsSjQi9eMEu6J1ns8GLP6azLfE8AgAAIMYCAAAjbgIAADNiAgAI1J0CAAAhSgIAAAkLw
Date:   Thu, 24 Mar 2022 02:42:38 +0000
Message-ID: <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
 <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
In-Reply-To: <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13820155-372a-4093-9958-08da0d3ff628
x-ms-traffictypediagnostic: BL0PR11MB3505:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB3505BCD04BB718917C9B7F0B8C199@BL0PR11MB3505.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 03ZMSX781SEVrdtJ7mo1iSe001mL4NubPb5NxgON0BFFvmJmZF3MkaJEX5au8z9WzcbnK0yTB9ruOgARDqfYLuOD1tvQmRQYPdDqn33+5faENO1etoxkCmfW18FZ1jp1a6tcsCMcD0w1F2eyLeaX0s+A77LimlVWSHonO/huYePiol8Rdwf3cIrJigMj0j7KDLWuvyloaTiqzYQxR1XidJ8TX/IQKMxxZkU/WOdkkkJpADKtadvL84PjmmCn3Gdm41/2qbL8PeRS4Yda1p9wmdUxKThVAaXZ8OxsHq93Fk/7timmjVT+UhgbYoHUEltMVw43C1V/Ajd3edclkoJAEnnbid+MEi0i7BF3Kt6n7vZm3I4YusBcPkZERdBWTc8CP4GO0h2mTaXtlgdYzqoFbdKjR5Eycz8TY4Ay4PaYa8j/LdW1f8ZLuuccSAAv5cCoGXxGX2KDiCeHhwzHHgOW8qPUW1F8I2ayqvsU7MaeLd/k9B+57yyYGVlUUCRkpYau7me6GQ5tanNtzZql14f863k+d5C5/AsxOtiBNAGGzgRZzCistbjUfp36wb6JtkrhyS1P4Bp2f9JBv8WP1ZNsETO6DCWL2+//Cx9QD0o9W1I0nEO1UdsVUZTRTbAqg71BUKEwocLVUwdvFIxI72vXGzAXdH4F0P1HjvY2wWRb34KDgekfbsJfzoxxipUb2ri6b3wwaIDdrIdEX5Z0oOkeTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(7696005)(6506007)(8936002)(53546011)(38100700002)(316002)(33656002)(122000001)(9686003)(71200400001)(52536014)(38070700005)(64756008)(2906002)(82960400001)(66446008)(26005)(83380400001)(8676002)(4326008)(186003)(66556008)(66476007)(5660300002)(508600001)(66946007)(86362001)(7416002)(54906003)(76116006)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVBIbGxXdUFyLyticllmdUVEeWYzMFpXNXFjNjVXVFNJVXdHODlHQmtnMkdx?=
 =?utf-8?B?Zlluc0dIUnFaU3JZS2pnUWdZSnVUSzQyM2crTmVVczI4WDk3MXhac2ZmdHhn?=
 =?utf-8?B?Y2ZheFR3dDJneVFEYjBYMnQ3ZnNQSDlWZVRQTEczck04TWgwYzNoejFrNkl1?=
 =?utf-8?B?MzYrUkE5NnkyQnNJTE1lRlRnMGdId1ptSUIvT3VDdHRVZWd1YVduRkM3U1B3?=
 =?utf-8?B?YWF3NjFxMFQzR2x0T1FXLzNnR3lLS21XZk55TzZCNy9icGNYMUJsZTJoZkxr?=
 =?utf-8?B?Y2ovU2c2SkF6alF4Y3JkczJKTGxwUFlONjNYRVpqN25rbStSOFQ2SjBtcmVy?=
 =?utf-8?B?Mk12Vmw1alFmckM0SlYyb0w3ek9uZVBPN3ZBcUM0QXprSFBUL1FyVEFvVUlC?=
 =?utf-8?B?WTQ2T1ZyUnBOTURnY1pLRjdPZlpNdVNxY2tvei9NT2ErT3VqZEh6V1Zlckx4?=
 =?utf-8?B?eUsxaU15VXFyNVBVOXJ5ckVGOUpyY3k2S3RHRStOZVdHNmlvdy9ub2hrUGda?=
 =?utf-8?B?cVNUQ2dpa2YvTXorOTM2eU1TbmdHeGhYVG82eUVTZ3Q0N2JnUjgyZDJJeXI3?=
 =?utf-8?B?M3luQW1nNCtJdmI0dm5IcVZzWDZqL0xicWw4NmFwTzgwV0x2MlptL2xNNkw2?=
 =?utf-8?B?V1ZjTC9Od3JJVzBTMC8rVWNnWGtRTERUM3NleWFuY3NsbDZXRHlNRVhxbjJO?=
 =?utf-8?B?aVhuSkM0VGxDZXJGSjZIWDF6SVJ0WWIrVU5mcUdvVC9jRno5aU9WeEU3dDdy?=
 =?utf-8?B?STlHZUg4WnFLUHpkQW9kOUcrTUJoQkt2M01tL0RXMUZZMUtIb0N5MmpnQVZY?=
 =?utf-8?B?S2hKS1dlMk9WSG8zbE9NNE1MNTlGWnB1WkpHTG44S2srK3VrV3FzRVVDdGEx?=
 =?utf-8?B?Z3JpT3dZNTQ0OVVLMWt5MENGNk9CWUI4QmZDMm15L3lUOUp2VSs0SGJ2bXNY?=
 =?utf-8?B?T25vSW4vLzRhdEFBYTZ2RmxldU9CRlJNdUFxOHFSVlIrbkxQSXErTmRianJv?=
 =?utf-8?B?VXZ4d2J0ZlFSdU1KZStDWm40VHh2SDRlZXZESG9VK0pxb2RtY1B5eEhqeGEw?=
 =?utf-8?B?SUtKRFNOYVRDV05BVHEwOGhOd2R3WjRXWlZvTTBxbzQxbkxmdjB3SjA1MWov?=
 =?utf-8?B?R2Y5RjNBOVJ5UWdtMXM0YVJTZkVMQmpNR1E3QlBsalhVVS9ONHVGZjNEalVQ?=
 =?utf-8?B?WHltUUMyV1hNWjc1eVhEN09OY3JwZU5pbG1OdndKQ1BtSERlSmxUQitZa3Rs?=
 =?utf-8?B?SDRNTktWSCtyWmpydE1NQmhnQTFmOEpGNFRnQ2NmZDZOWjBBTzNhQk9CWm50?=
 =?utf-8?B?OFFBbm50VUovQndsL1ZRNVBOWFM3Z0FQaFpwNlIzbSswVmZDU3dzREpuQWg2?=
 =?utf-8?B?RFRSRm1hOEtKY0Rydzl6WVlqZncvbnhzNTNoTDJTV0RWbzJJcXYrS1FNNzJR?=
 =?utf-8?B?OGNDVjE0c3h0ZkljWVZDQXZQbHJXZElROGFQaXR5SlplNmVmck5yaWJTem56?=
 =?utf-8?B?SzBTOEFIMHZ4K25VYXYzUzBTQ1RyUUpoSnZlL1JBTFgySVdOK2FjbVAwYzdQ?=
 =?utf-8?B?V0U5YzlFRjNmZCs1Vnoycm5JTTFlUmd4bjgzZzZJTWVoTnFhQi9EblB0Tm5M?=
 =?utf-8?B?UzE4M0szSDJmN3BBMHR1bHlOcGxlQ21aM3pZa0diNHg1MkpwSE1HK2ZRczRV?=
 =?utf-8?B?b0F0MGt1U29aWjRlWC9SanVVWU5NUGhwZm5FNWhJNFMyR09DeTR6dENHck9w?=
 =?utf-8?B?Y1pXZEw3YmsyUlZzMkVIbXk5V0lBYXZqUjFoMTE5UUJMOEVnYk5OMitaQ2hT?=
 =?utf-8?B?akJlZy81WjhncUtZTEpLVXIxQ3lCcjVsWVhwNVdKbDI0UmJPQXlaUUQ5U2RQ?=
 =?utf-8?B?ZjZ1elFCUE5lajlmMXBzZ1J2bFBJUktVMVExWXU4Y2JWdmRGWVNlUUg4bC94?=
 =?utf-8?Q?EW9IeZ2/I82s308hPXQqnyylrkGfDMt2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13820155-372a-4093-9958-08da0d3ff628
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 02:42:38.7009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8eTbKfGol6Xj1e3+FQ48AAQYHCgiRKdb5Zq0PVY5riP9xDlHw60LcN+D3vNebr66B07phzp0lw+6vm7CVzKkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgTWFyY2ggMjQsIDIwMjIgMTA6MjggQU0NCj4gDQo+IE9uIFRodSwgTWFyIDI0LCAyMDIyIGF0
IDEwOjEyIEFNIFRpYW4sIEtldmluIDxrZXZpbi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4N
Cj4gPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4gPiBTZW50
OiBXZWRuZXNkYXksIE1hcmNoIDIzLCAyMDIyIDEyOjE1IEFNDQo+ID4gPg0KPiA+ID4gT24gVHVl
LCBNYXIgMjIsIDIwMjIgYXQgMDk6Mjk6MjNBTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3Rl
Og0KPiA+ID4NCj4gPiA+ID4gSSdtIHN0aWxsIHBpY2tpbmcgbXkgd2F5IHRocm91Z2ggdGhlIHNl
cmllcywgYnV0IHRoZSBsYXRlciBjb21wYXQNCj4gPiA+ID4gaW50ZXJmYWNlIGRvZXNuJ3QgbWVu
dGlvbiB0aGlzIGRpZmZlcmVuY2UgYXMgYW4gb3V0c3RhbmRpbmcgaXNzdWUuDQo+ID4gPiA+IERv
ZXNuJ3QgdGhpcyBkaWZmZXJlbmNlIG5lZWQgdG8gYmUgYWNjb3VudGVkIGluIGhvdyBsaWJ2aXJ0
IG1hbmFnZXMgVk0NCj4gPiA+ID4gcmVzb3VyY2UgbGltaXRzPw0KPiA+ID4NCj4gPiA+IEFGQUNJ
VCwgbm8sIGJ1dCBpdCBzaG91bGQgYmUgY2hlY2tlZC4NCj4gPiA+DQo+ID4gPiA+IEFJVUkgbGli
dmlydCB1c2VzIHNvbWUgZm9ybSBvZiBwcmxpbWl0KDIpIHRvIHNldCBwcm9jZXNzIGxvY2tlZA0K
PiA+ID4gPiBtZW1vcnkgbGltaXRzLg0KPiA+ID4NCj4gPiA+IFllcywgYW5kIHVsaW1pdCBkb2Vz
IHdvcmsgZnVsbHkuIHBybGltaXQgYWRqdXN0cyB0aGUgdmFsdWU6DQo+ID4gPg0KPiA+ID4gaW50
IGRvX3BybGltaXQoc3RydWN0IHRhc2tfc3RydWN0ICp0c2ssIHVuc2lnbmVkIGludCByZXNvdXJj
ZSwNCj4gPiA+ICAgICAgICAgICAgICAgc3RydWN0IHJsaW1pdCAqbmV3X3JsaW0sIHN0cnVjdCBy
bGltaXQgKm9sZF9ybGltKQ0KPiA+ID4gew0KPiA+ID4gICAgICAgcmxpbSA9IHRzay0+c2lnbmFs
LT5ybGltICsgcmVzb3VyY2U7DQo+ID4gPiBbLi5dDQo+ID4gPiAgICAgICAgICAgICAgIGlmIChu
ZXdfcmxpbSkNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAqcmxpbSA9ICpuZXdfcmxpbTsN
Cj4gPiA+DQo+ID4gPiBXaGljaCB2ZmlvIHJlYWRzIGJhY2sgaGVyZToNCj4gPiA+DQo+ID4gPiBk
cml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jOiAgICAgICAgdW5zaWduZWQgbG9uZyBwZm4s
IGxpbWl0ID0NCj4gPiA+IHJsaW1pdChSTElNSVRfTUVNTE9DSykgPj4gUEFHRV9TSElGVDsNCj4g
PiA+IGRyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmM6ICAgICAgICB1bnNpZ25lZCBsb25n
IGxpbWl0ID0NCj4gPiA+IHJsaW1pdChSTElNSVRfTUVNTE9DSykgPj4gUEFHRV9TSElGVDsNCj4g
PiA+DQo+ID4gPiBBbmQgaW9tbXVmZCBkb2VzIHRoZSBzYW1lIHJlYWQgYmFjazoNCj4gPiA+DQo+
ID4gPiAgICAgICBsb2NrX2xpbWl0ID0NCj4gPiA+ICAgICAgICAgICAgICAgdGFza19ybGltaXQo
cGFnZXMtPnNvdXJjZV90YXNrLCBSTElNSVRfTUVNTE9DSykgPj4NCj4gPiA+IFBBR0VfU0hJRlQ7
DQo+ID4gPiAgICAgICBucGFnZXMgPSBwYWdlcy0+bnBpbm5lZCAtIHBhZ2VzLT5sYXN0X25waW5u
ZWQ7DQo+ID4gPiAgICAgICBkbyB7DQo+ID4gPiAgICAgICAgICAgICAgIGN1cl9wYWdlcyA9IGF0
b21pY19sb25nX3JlYWQoJnBhZ2VzLT5zb3VyY2VfdXNlci0NCj4gPiA+ID5sb2NrZWRfdm0pOw0K
PiA+ID4gICAgICAgICAgICAgICBuZXdfcGFnZXMgPSBjdXJfcGFnZXMgKyBucGFnZXM7DQo+ID4g
PiAgICAgICAgICAgICAgIGlmIChuZXdfcGFnZXMgPiBsb2NrX2xpbWl0KQ0KPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ID4gICAgICAgfSB3aGlsZSAoYXRv
bWljX2xvbmdfY21weGNoZygmcGFnZXMtPnNvdXJjZV91c2VyLT5sb2NrZWRfdm0sDQo+ID4gPiBj
dXJfcGFnZXMsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG5ld19w
YWdlcykgIT0gY3VyX3BhZ2VzKTsNCj4gPiA+DQo+ID4gPiBTbyBpdCBkb2VzIHdvcmsgZXNzZW50
aWFsbHkgdGhlIHNhbWUuDQo+ID4gPg0KPiA+ID4gVGhlIGRpZmZlcmVuY2UgaXMgbW9yZSBzdWJ0
bGUsIGlvdXJpbmcvZXRjIHB1dHMgdGhlIGNoYXJnZSBpbiB0aGUgdXNlcg0KPiA+ID4gc28gaXQg
aXMgYWRkaXRpdmUgd2l0aCB0aGluZ3MgbGlrZSBpb3VyaW5nIGFuZCBhZGRpdGl2ZWx5IHNwYW5z
IGFsbA0KPiA+ID4gdGhlIHVzZXJzIHByb2Nlc3Nlcy4NCj4gPiA+DQo+ID4gPiBIb3dldmVyIHZm
aW8gaXMgYWNjb3VudGluZyBvbmx5IHBlci1wcm9jZXNzIGFuZCBvbmx5IGZvciBpdHNlbGYgLSBu
bw0KPiA+ID4gb3RoZXIgc3Vic3lzdGVtIHVzZXMgbG9ja2VkIGFzIHRoZSBjaGFyZ2UgdmFyaWFi
bGUgZm9yIERNQSBwaW5zLg0KPiA+ID4NCj4gPiA+IFRoZSB1c2VyIHZpc2libGUgZGlmZmVyZW5j
ZSB3aWxsIGJlIHRoYXQgYSBsaW1pdCBYIHRoYXQgd29ya2VkIHdpdGgNCj4gPiA+IFZGSU8gbWF5
IHN0YXJ0IHRvIGZhaWwgYWZ0ZXIgYSBrZXJuZWwgdXBncmFkZSBhcyB0aGUgY2hhcmdlIGFjY291
bnRpbmcNCj4gPiA+IGlzIG5vdyBjcm9zcyB1c2VyIGFuZCBhZGRpdGl2ZSB3aXRoIHRoaW5ncyBs
aWtlIGlvbW11ZmQuDQo+ID4gPg0KPiA+ID4gVGhpcyB3aG9sZSBhcmVhIGlzIGEgYml0IHBlY3Vs
aWFyIChlZyBtbG9jayBpdHNlbGYgd29ya3MgZGlmZmVyZW50bHkpLA0KPiA+ID4gSU1ITywgYnV0
IHdpdGggbW9zdCBvZiB0aGUgcGxhY2VzIGRvaW5nIHBpbnMgdm90aW5nIHRvIHVzZQ0KPiA+ID4g
dXNlci0+bG9ja2VkX3ZtIGFzIHRoZSBjaGFyZ2UgaXQgc2VlbXMgdGhlIHJpZ2h0IHBhdGggaW4g
dG9kYXkncw0KPiA+ID4ga2VybmVsLg0KPiA+ID4NCj4gPiA+IENlcmF0aW5seSBoYXZpbmcgcWVt
dSBjb25jdXJyZW50bHkgdXNpbmcgdGhyZWUgZGlmZmVyZW50IHN1YnN5c3RlbXMNCj4gPiA+ICh2
ZmlvLCByZG1hLCBpb3VyaW5nKSBpc3N1aW5nIEZPTExfTE9OR1RFUk0gYW5kIGFsbCBhY2NvdW50
aW5nIGZvcg0KPiA+ID4gUkxJTUlUX01FTUxPQ0sgZGlmZmVyZW50bHkgY2Fubm90IGJlIHNhbmUg
b3IgY29ycmVjdC4NCj4gPiA+DQo+ID4gPiBJIHBsYW4gdG8gZml4IFJETUEgbGlrZSB0aGlzIGFz
IHdlbGwgc28gYXQgbGVhc3Qgd2UgY2FuIGhhdmUNCj4gPiA+IGNvbnNpc3RlbmN5IHdpdGhpbiBx
ZW11Lg0KPiA+ID4NCj4gPg0KPiA+IEkgaGF2ZSBhbiBpbXByZXNzaW9uIHRoYXQgaW9tbXVmZCBh
bmQgdmZpbyB0eXBlMSBtdXN0IHVzZQ0KPiA+IHRoZSBzYW1lIGFjY291bnRpbmcgc2NoZW1lIGdp
dmVuIHRoZSBtYW5hZ2VtZW50IHN0YWNrDQo+ID4gaGFzIG5vIGluc2lnaHQgaW50byBxZW11IG9u
IHdoaWNoIG9uZSBpcyBhY3R1YWxseSB1c2VkIHRodXMNCj4gPiBjYW5ub3QgYWRhcHQgdG8gdGhl
IHN1YnRsZSBkaWZmZXJlbmNlIGluIGJldHdlZW4uIGluIHRoaXMNCj4gPiByZWdhcmQgZWl0aGVy
IHdlIHN0YXJ0IGZpeGluZyB2ZmlvIHR5cGUxIHRvIHVzZSB1c2VyLT5sb2NrZWRfdm0NCj4gPiBu
b3cgb3IgaGF2ZSBpb21tdWZkIGZvbGxvdyB2ZmlvIHR5cGUxIGZvciB1cHdhcmQgY29tcGF0aWJp
bGl0eQ0KPiA+IGFuZCB0aGVuIGNoYW5nZSB0aGVtIHRvZ2V0aGVyIGF0IGEgbGF0ZXIgcG9pbnQu
DQo+ID4NCj4gPiBJIHByZWZlciB0byB0aGUgZm9ybWVyIGFzIElNSE8gSSBkb24ndCBrbm93IHdo
ZW4gd2lsbCBiZSBhIGxhdGVyDQo+ID4gcG9pbnQgdy9vIGNlcnRhaW4ga2VybmVsIGNoYW5nZXMg
dG8gYWN0dWFsbHkgYnJlYWsgdGhlIHVzZXJzcGFjZQ0KPiA+IHBvbGljeSBidWlsdCBvbiBhIHdy
b25nIGFjY291bnRpbmcgc2NoZW1lLi4uDQo+IA0KPiBJIHdvbmRlciBpZiB0aGUga2VybmVsIGlz
IHRoZSByaWdodCBwbGFjZSB0byBkbyB0aGlzLiBXZSBoYXZlIG5ldyB1QVBJDQoNCkkgZGlkbid0
IGdldCB0aGlzLiBUaGlzIHRocmVhZCBpcyBhYm91dCB0aGF0IFZGSU8gdXNlcyBhIHdyb25nIGFj
Y291bnRpbmcNCnNjaGVtZSBhbmQgdGhlbiB0aGUgZGlzY3Vzc2lvbiBpcyBhYm91dCB0aGUgaW1w
YWN0IG9mIGZpeGluZyBpdCB0byB0aGUNCnVzZXJzcGFjZS4gSSBkaWRuJ3Qgc2VlIHRoZSBxdWVz
dGlvbiBvbiB0aGUgcmlnaHQgcGxhY2UgcGFydC4NCg0KPiBzbyBtYW5hZ2VtZW50IGxheWVyIGNh
biBrbm93IHRoZSBkaWZmZXJlbmNlIG9mIHRoZSBhY2NvdW50aW5nIGluDQo+IGFkdmFuY2UgYnkN
Cj4gDQo+IC1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZD1vbg0KPiANCg0KSSBzdXBwb3NlIGlvbW11
ZmQgd2lsbCBiZSB1c2VkIG9uY2UgUWVtdSBzdXBwb3J0cyBpdCwgYXMgbG9uZyBhcw0KdGhlIGNv
bXBhdGliaWxpdHkgb3BlbnMgdGhhdCBKYXNvbi9BbGV4IGRpc2N1c3NlZCBpbiBhbm90aGVyIHRo
cmVhZA0KYXJlIHdlbGwgYWRkcmVzc2VkLiBJdCBpcyBub3QgbmVjZXNzYXJpbHkgdG8gYmUgYSBj
b250cm9sIGtub2IgZXhwb3NlZA0KdG8gdGhlIGNhbGxlci4NCg0KVGhhbmtzDQpLZXZpbg0K
