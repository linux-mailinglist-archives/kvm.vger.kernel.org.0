Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C405FAABE
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 04:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJKCtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 22:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJKCtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 22:49:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8DC8304A
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 19:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665456553; x=1696992553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1VfSRCrIBRKTcyCilKi1bIgvX0BH+TJ6rVbLFVM7/9U=;
  b=IrcOSluOHVvP0wqL6LUo+Al0yLEK1fjQIo0Nsd1TyvDRypnRhfaShOui
   6IJ35Dtgw84KSOi6XRbl7NPbxI+JxtTJMeAuoTgJd+gqKIvzTG8Ea/Kr+
   P04CwrR7IuKQcdzGYk6bWyO0eQmCGhRw+YeoLS/VkcfZW28FKr2iWvQcL
   0QrnIouHoylN4VS07OFwy4J1af8vtf+yogDILseRY5//sV9uOLfWI2e4V
   DCMYomzVTvW2Wru/U1fTmbP1J58y3mAu3BA6ujtgzPCs9BAWdTg6RLnoi
   IpWxEMa4hRbzxiIljptPg9B3iWzAgACoPRKdf/GQ9rnTr2yw2XPvgAAJg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="303130421"
X-IronPort-AV: E=Sophos;i="5.95,175,1661842800"; 
   d="scan'208";a="303130421"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 19:49:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="577275434"
X-IronPort-AV: E=Sophos;i="5.95,175,1661842800"; 
   d="scan'208";a="577275434"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 10 Oct 2022 19:49:12 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 19:49:12 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 19:49:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 10 Oct 2022 19:49:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 10 Oct 2022 19:49:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWTGXfDsoRBJx7WlRSCF8IFb31Y5gBaSaHcDi3cFPExWpV/Fkv7tnnquCxqE08ePRKHkLLZZaKk7LpHXouzkJhU6QNXRH+8lGQR/5GHSQtnyGx5K7Tv34Uy2yzDR54MmPt2iZUR9GEsxeFc5RC1zTnatjSPo7HNXqPxSYsZ0mjuVpboBWfz/55LobJlHIemHNvXOFRWgEUL42TlK56A6uBrpmnz19CNrZNNjPPWvEKGVQHYbJN3OZlfIn4oXFKjUYgrbEtoCiOdsKJilC57/Ld+BmovH5qzWBysbGa6Z3jZStrKm+Anf+01ajk8xi+PZYijGZ9MaP1xaFHP2/lY/jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VfSRCrIBRKTcyCilKi1bIgvX0BH+TJ6rVbLFVM7/9U=;
 b=IGTX2dobZ2VCG6QIgScrDQeB+El1fppsS9qc5IJOEEnvXYFRcU+f5MT23DzRGx7DPGVY76+RzCmNTUAULrgU3qnzyOyFjnnmUjxe7tfZ3hhHdb7MmTqZWjPljMKlPmvme1qPoV2m8su/bnoqzaRjIVLrHvihuiXY+HxrZz6cF18tdHd7nb9zEBmzTrT/PB1JjUrPpreRjZ2JtmxbLn7XUB7LT1rxtNhn6gX8eCojUIsFvu8u6IkAzblEjp3BoiuwoIxAZSZUxsNd6BLjFiBm0JKULFS2i/YgbyGHJ5m4jiwsQSBNHnS0sxJOEELuIy8Q0eLSQ1/vL2TWf1XF4AWCdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4515.namprd11.prod.outlook.com (2603:10b6:5:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 02:49:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b2db:19f5:f440:f6a2]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b2db:19f5:f440:f6a2%8]) with mapi id 15.20.5709.015; Tue, 11 Oct 2022
 02:49:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Subject: RE: [PATCH] [PATCH] Revert 'vfio: Delete container_q'
Thread-Topic: [PATCH] [PATCH] Revert 'vfio: Delete container_q'
Thread-Index: AQHY2vcvu9dSYML6x0ebZ8tX5Zteq64H9hoAgACG5wCAAATMIA==
Date:   Tue, 11 Oct 2022 02:49:09 +0000
Message-ID: <BN9PR11MB527695758D3FFFBEF17708168C239@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1665222631-202970-1-git-send-email-chenxiang66@hisilicon.com>
 <Y0RkLBiZc6RWl3pB@nvidia.com>
 <935149c4-984e-837b-1c6c-c3e98dcae51b@hisilicon.com>
In-Reply-To: <935149c4-984e-837b-1c6c-c3e98dcae51b@hisilicon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4515:EE_
x-ms-office365-filtering-correlation-id: e5f3cef6-defa-4ba0-b828-08daab332beb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ATQ3zVohiPG83wSgGkvSVeAIU2GarLAkDsgvJQMK4JcKSGLBHNz5XxXO1H8ygDit/HTsDqOO7LhvmSbpShQB55dopUdRxmyq3oysJxL6HCLDGOoEFvCQFsqdo2WSYIkwd2nDIDzIMoVsaD8gkz/OQ8L/KEgr6TRC4DK6eZVhFgOQG1wkk426lFTDqN9FqZ+pLeICqz7JAe4rVGYThzkCxT33Ip1SExbkRDLjoayLwpjxaWKS9qkgzcpQCYhGo7KZYxQ6ZqCymteZS4PinI1Gt6ko4U5tWoKBBKxq3qmy9zBRavPLYjgYIAQqJNcUjh+rKHvM8sLwNcyHXVf5ZdaEiT0zHi6SIjUAqCkqORQ+h+mpa7yzr7SsFj8bkYll4sB4w3CwLVHfvnzCeC5JpqgDhdkZzI8N5YHlmrbiVXeXuxBusvYB6+H6iho2ylabKOKfwckaYjnSh4FmLKh4cw0dPncwuOhCzMSIQA9z4PQ2Fw42pYXWD5us+JLqXZkJRiT/FQAQDDIAUtL+Ql//0HAMZkjokzza9KRv/nFmIrNBALGNh4HLUZ/GlEWrYnXsaEK2QhQu1VfIASJOg+bzmwrFVHHS3FP7feBO+QWO3aSrGbP8dFw4wJWBimn4rO0eP20igZWMMRsuj0hh2uK0jMAOLEt4SOrakJ7Mtqw9Jne9fI5n+EupuJgj8i5EdvSJhdMOzpOVPgFzgR/W4Zz4T8x/h7ZK2qdSS6UDPzXZzpk3pdtEGK51zUZvdt986h+ETaNZgsaKnszTULG4iGFMW07TGjq/VczGg9PqZvcNtmMxdA0m2rb5wpCJ/A5FYFaIEJyA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199015)(66476007)(33656002)(38070700005)(38100700002)(82960400001)(122000001)(55016003)(66556008)(76116006)(64756008)(4326008)(71200400001)(316002)(66946007)(86362001)(66446008)(8676002)(54906003)(2906002)(9686003)(4744005)(41300700001)(8936002)(52536014)(5660300002)(110136005)(186003)(83380400001)(478600001)(7696005)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWgxZWM2dVk3V0ovb3FqL0Y4U2FJeVplUjkwWGV3bHJwRFdlZTBuT3VzNjlJ?=
 =?utf-8?B?SHpncGdvQVY3TWtIa0tUNFhWYXlqajJFZmQyMmdEaXE3REdZeDdPZ05GYXU1?=
 =?utf-8?B?T2xlWVZkUDc0RlRWM1RLUkQrbk1tS3pxV0dGd3ZmSVFGN1prSGhHcFU1dWM4?=
 =?utf-8?B?amZxS1RiNmdrcGlVbTIwRkwzdGRpZzRQVEc4Mk0ySGZUdWd1NkxFR01zT3Fj?=
 =?utf-8?B?WFFpaTNZSEw5ZlFHV1dxN0o5MXlpNjZIYVRNZXZWdDN3WXQrcDdOcmZBd1dw?=
 =?utf-8?B?ME40SjR3WElaamZKVTZuMzI3TlZVc0ZTU2lMVTFHUzlSZVZnVFBYUDJabHdo?=
 =?utf-8?B?L2taRE1ydytqMjBhZWF2VVlMQXc3RDdGQW9VeDk3MFJwSzN6ZmNRd1pkVHFm?=
 =?utf-8?B?c0pidS9aUThHd3RMM0k1Z29OVW1PRDBRQUNTMmJRd2dFcmM1YjZhRTVwT3hY?=
 =?utf-8?B?Zll0MmJxaGRTcTBQWjFaRzN6bmhJZEFQWnRGclpUYmozbDZKY2pGRzR5ZnJF?=
 =?utf-8?B?Si9LMW44NFdYV3plMmZMME9pSjdxR0tVMWJXNEcwOUtXWmZWK251dGVXOXp4?=
 =?utf-8?B?RWpNZ0hCLzl5NmNYSXpmVG9WMHk5Wlprbzg1bEEwamJ4STd4L3MvNmJ3Y1p2?=
 =?utf-8?B?M2V0TWZOdUdMWVp4UVJiNVNpNHBUNy9MRnV2eWNINlRYbkFwRnJwUTJmZHdx?=
 =?utf-8?B?MUFRVWFtMTExQTFjT2k4WkFUcWUwQk5hazM1ZjN6aFlkWmkrWGljeW8vRHBS?=
 =?utf-8?B?bk9XOXRLaFhvb252R2x3RWFrL1RsOVAzdHpZOUwrL2NkM2NwWStpbUdmWndO?=
 =?utf-8?B?NzU4VFdNZCtRYzl3QXRybmZMSWVMUEdVc0svZUQ4RXZNYzRaTi8xV1dhY1Qv?=
 =?utf-8?B?SmsvVjZIckhqWnQyMG1BNkVJaWdlZWp6OEY0YWE3Zm8yamQyUVJSQTE5RC9H?=
 =?utf-8?B?SmhINzdGbTMvVHphUm51SE5NNHpCS3VhN0RqRUhjemdTUlJXY05jdnFqbXo2?=
 =?utf-8?B?V3JBeTc1Y0FoeWRXQkZQWjFUTy8xOUtuSVIvb1BpN0V5bU5CVmdqZnAwaUdZ?=
 =?utf-8?B?dldKZW1iRGQrOFZrOGdEaldpY1h2dGY3ZUpzVnpBZ1FCS1RqbE9XQlNKZWdI?=
 =?utf-8?B?ZmJGL2RQZEJ1bTdNMWU5TXZUZTJVV0EzMmdBTm9nbjhKR21OSjZRclZtaCtH?=
 =?utf-8?B?UUE1US9EaEV2TTNmZjl5TkdBNlJyTkRHdllORGV2b2ZMUGV6YWRwK3lWS245?=
 =?utf-8?B?WEg1b3lyak03MmNTcWFQVkJTZXJDdklhMEptMXNXNGVwK25oQ0VqVWIyTnNn?=
 =?utf-8?B?bWVlNyt6eWxVZ2VzWnYwTEIxbndjdmt6eGVKNGdLOE1BaDJFcGhQekxFSHZB?=
 =?utf-8?B?TDlWdkVIVVM4aWpTVGd6akd6Y1BQSWJ0ZXZaU1dZMmFnKzZaOGVuZ0JvM2tm?=
 =?utf-8?B?UFU4Z2N4QzB2M3FNUk1SN3hZQWJ0RlZiWEVQNDY3bjRLK3FlQlZQaldrOEVx?=
 =?utf-8?B?bVNDZStvUjVNblIzU3dSeDRUSVZ4c3JDdjNvT3h3VnhGb0VnV3dVTWFpKzRT?=
 =?utf-8?B?WkUzOUFpc1h1NkpxTXhSRnQxOXBDSWYrTURUZ3NvNGdqbGxEalBvdERXaEZX?=
 =?utf-8?B?eUpCQjQ3MmJBbWRrSGJFM0xoSTJCT3JucG51NEloRWNteDViSnhjaHgwTWE2?=
 =?utf-8?B?cW5jakJXR2JEcE1nMXFjU3ZkeUZ0Qkt4M2Z1VTVNRWxuNEQ0TENTRlg5TVdm?=
 =?utf-8?B?K3BqckRwaVJ2bDZIYTltMHZXT3R0OXBsU2VRYlpVMDBSejljYXpkWlJzdXlj?=
 =?utf-8?B?amYrWjg3ODRhMklUaVpTeVNWN1BmZlZ5VkwrR0Jnc2JNZUpWOEFnc0o4bGVv?=
 =?utf-8?B?UEFIMjhXb1lmUTdHeDJjQzhWQ2FMc0hRRVVjV2NmMlEwZEwzQ25CUlZMbGEr?=
 =?utf-8?B?R2FuR2JMTG1OeEYrU0lSRGpBZ1MyaEt6Zlc4by9wRGlxdy9EaldINzR4SGRo?=
 =?utf-8?B?SE50V1J6bHlLV1FhbGJPSm1QZGZlbHNSUmpWTmZoR2pxZUxWR0VIczZqbzQv?=
 =?utf-8?B?QTZTcDlld014ejIxSDV5U0theDlnNTNJR3FyNDRNNHUyUExzQnlsUVV5SGNM?=
 =?utf-8?Q?5r9RIZHodS8HCe93J2bkiqwTJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f3cef6-defa-4ba0-b828-08daab332beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2022 02:49:09.4584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U+DaSHY8eNlpob13ru5mg9a51J2BQGzAQM5oU3EbeODUldNXR5M6uisrbZPBgfNA3o4Oct6MuhVA/uD4Dn5Y0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBjaGVueGlhbmcgKE0pIDxjaGVueGlhbmc2NkBoaXNpbGljb24uY29tPg0KPiBTZW50
OiBUdWVzZGF5LCBPY3RvYmVyIDExLCAyMDIyIDEwOjMxIEFNDQo+IA0KPiBIaSBKYXNvbiwNCj4g
DQo+IA0KPiDlnKggMjAyMi8xMC8xMSAyOjI3LCBKYXNvbiBHdW50aG9ycGUg5YaZ6YGTOg0KPiA+
IE9uIFNhdCwgT2N0IDA4LCAyMDIyIGF0IDA1OjUwOjMxUE0gKzA4MDAsIGNoZW54aWFuZyB3cm90
ZToNCj4gPj4gRnJvbTogWGlhbmcgQ2hlbiA8Y2hlbnhpYW5nNjZAaGlzaWxpY29uLmNvbT4NCj4g
Pj4NCj4gPj4gV2UgZmluZCBhIGlzc3VlIG9uIEFSTTY0IHBsYXRmb3JtIHdpdGggSE5TMyBWRiBT
UklPViBlbmFibGVkIChWRklPDQo+ID4+IHBhc3N0aHJvdWdoIGluIHFlbXUpOg0KPiA+PiBraWxs
IHRoZSBxZW11IHRocmVhZCwgdGhlbiBlY2hvIDAgPiBzcmlvdl9udW12ZnMgdG8gZGlzYWJsZSBz
cmlvdg0KPiA+PiBpbW1lZGlhdGVseSwgc29tZXRpbWVzIHdlIHdpbGwgc2VlIGZvbGxvd2luZyB3
YXJuaW5nczoNCj4gPiBJIHN1c3BlY3QgdGhpcyBpcyBmaXhlZCBpbiB2ZmlvLW5leHQgbm93LCBp
biBhIGRpZmZlcmVudCB3YXkuIFBsZWFzZSBjaGVjaw0KPiANCj4gQ2FuIHlvdSBwb2ludCBvdXQg
d2hpY2ggcGF0Y2hlcyBmaXggaXQ/DQo+IEkgbmVlZCB0byBtZXJnZSBiYWNrIHRob3NlIHBhdGNo
ZXMgdG8gb3VyIHZlcnNpb24sIHRoZW4gaGF2ZSBhIHRlc3QuDQo+IA0KDQpjb21taXQgY2E1ZjIx
YjI1NzQ5MDNhNzQzMGZjYjM1OTBlNTM0ZDkyYjJmYTgxNg0KQXV0aG9yOiBKYXNvbiBHdW50aG9y
cGUgPGpnZ0BudmlkaWEuY29tPg0KRGF0ZTogICBUaHUgU2VwIDIyIDIxOjA2OjEwIDIwMjIgLTAz
MDANCg0KICAgIHZmaW86IEZvbGxvdyBhIHN0cmljdCBsaWZldGltZSBmb3Igc3RydWN0IGlvbW11
X2dyb3VwDQoNCg==
