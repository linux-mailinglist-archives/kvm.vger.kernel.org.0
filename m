Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370CE78D94B
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjH3Scp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242240AbjH3He5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 03:34:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25ADCC9;
        Wed, 30 Aug 2023 00:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693380894; x=1724916894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GKo56YW6npElSoD+s8HeLK4jIqBvCA1HtemZJal7AVg=;
  b=TN3VXEb++vUFrB1enw4hNqN7f3GOW8sgOUe5kmtCRwSKL3YEWXMG4BXf
   P/ABhBsFRfAZeGPnEV4vTldlPgQjsq6lTgtTIiZYtSUIwcXF0UG5HZIEy
   6xbMps4KRJrv6XjQcJ9HYmby7dgnPBKmpOcUF9+VA5ZBisqTW2ecKERsX
   WW3JJrEAmQYQ4pQ2r+EtgZRELjdjRa5IMrg1kW0+LogkUiZzBWqVTcK8E
   WBvLHVRwZvXz7N3wwL0eCJmv0L3s0qt7Cv0I5pdkvZ0VKVuI9FzLdly/K
   aOVvuSdvTvjTirMcrNDN1koxafPEH5KvaGb6R5CMXwsvKXgRew3cX8ReH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="406570906"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="406570906"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 00:34:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="715801186"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="715801186"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 30 Aug 2023 00:34:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 00:34:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 00:34:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 00:34:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 00:34:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXJt7u6sCUaRNjdqQZKUzQw1IcGAkjgfqMsGF+Brngk8HWv8NgF+xbjoef401CAAVPTPO/DMKzJGGruP+Sf1ATVOLNKw+Kzo1Bu4ZVKKORC5zVhXn5Yte+qbg4pAFjDMEmsLbOwb6JO4X/Wy+tw4Kd6yC4FGDyxsVUuv/3Y029u7gN8wR3NE+bLFcejUseqeiP8qs5lgRxU2/rFLnPiht/X8a+FQd8HWAA1/uOIpt5p9sg0MwsMdXwVkbdDPfoRNAgIYPyIxOhPxdqC+nY5CIgrh7oaHXNwmqC2ZZZTB8hG9f8KGdun1zSjmKYuM/6Hqc61nWy4iPMaPoqdHXQ3SYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKo56YW6npElSoD+s8HeLK4jIqBvCA1HtemZJal7AVg=;
 b=WnbGCPkMnVAQDa7fcggXCK448cEMbYmgpHjXCsZjZynSBq9jfJ/ZLwQ68xLNvRPBiKR0W4AlR1Y9Eso80BiqlB98/1gfHjQxzawsCivR4AK+w+lIk32WZe+81Z24OpsJ+vAL+Iwskak6huilQLKjyS9XCm1BOdwRfed02dr8eCFWNSnxj/1eWxo5VsPiKZHlnlq8h0Q+0x+T6AMOIxWtMxjoZJ6tLuSCDqmMCyRSRyxosCM0T4XXVD2DJbGbdzDlvj9jc6o7BZM1dF+RIVFhBi9MiJOoQVM2uf8FL+wp683iG6hoWqFPTAEiaCqfqpySsEfRSoTPM502areieMZQQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB8268.namprd11.prod.outlook.com (2603:10b6:303:1ef::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Wed, 30 Aug
 2023 07:34:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 07:34:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGI4gCABknWAA==
Date:   Wed, 30 Aug 2023 07:34:49 +0000
Message-ID: <BN9PR11MB5276F7754FB54A9B85A028238CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <9ace23a3-ecf9-551f-1c5e-be5b6502c563@linux.intel.com>
In-Reply-To: <9ace23a3-ecf9-551f-1c5e-be5b6502c563@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB8268:EE_
x-ms-office365-filtering-correlation-id: b0b520a4-17cb-4ee7-4d81-08dba92b97c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: znnNb2eI0sM3qtgq0ZrV3ZcxqGIgQ0emPtk4TEwPTw7FJxCpxG0UJ5BHbKppBwRNFlShhpicBPfdq9wVy8o6xcZ7KyzqPElnH45Uo0kD7DGNlVR0wqeK8k7BzjzwwqNcNFkiCjwgGlS7y8xuNc6oKu4YjB3rRFomM6/0dk8tOlb6/VS3bCHrW6vgEPAxiHUugAOB+RQ/tyBCpYYGC5xrS06iv5U/OAptVat9l2gRZ8cWR+Ac1ucgqbPHfZpRrm2ki3r5AWHebqqFGtW83H/g8Z/qa1DI1PbWf4bIxizhVyi1zuwxoFRWcLq9xHFHIcg0JRefOiVSe2mF93IgjqstCNZnxQNm5CN0QZmv00C37TtvLBaKwZGjwSnpraDATZ8ew/QbFju/mgwYKt95ZdA97fpb4mRRP03zttmvJ6iKpB8GER/4sLeEXSqtTqL+hKMDghefuzMKHeQu11h7GrowOcjBSQ0dAU5wGPAMPdA8TmMc16YUv0GyNfb568G/HQrc5l/cowA+iVyev/gJCwjP5Ict47AbNvSTOCnzlfdNI9YAUJgSEndQ9gcMG6pNZO72WPqErzgHDci7PUfEE2bd1JWGbmVlJ259L5aMdXp5lMYR8cNQlghkVlJWMvG4MPYK1w3Yst1/8oQW/1cRCA/+NQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199024)(1800799009)(186009)(71200400001)(6506007)(7696005)(66476007)(9686003)(33656002)(86362001)(38070700005)(82960400001)(38100700002)(55016003)(122000001)(478600001)(26005)(2906002)(76116006)(53546011)(4744005)(5660300002)(66556008)(4326008)(7416002)(110136005)(8936002)(8676002)(52536014)(66946007)(66446008)(64756008)(41300700001)(54906003)(316002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWZZcXRRMGlNTzhrKzdrYStDRm40ZEJyc2FjWmVjYmpEQW0wNHhHSFRzZVh2?=
 =?utf-8?B?OWtudWc2K3M4WEdGYnUrSUZRNXphbGhjRGhqNzZneTRWZDlBN1p4Ni90K1Zh?=
 =?utf-8?B?VHRmV1V3dU10T1E0ZXV0cURiMURneTFPVHVOOXUwRDRETld6T3p1MVpNREQ4?=
 =?utf-8?B?TG9HZFpqWnZ3ZURpSHl5cDNjYjhUUUM3QmdHOHFTYjNTY2RWV0RibFBoSzA4?=
 =?utf-8?B?aHhUNjZsMDlxZTY0NitucEpCYUNOOEx3TTRFRU9OWW9PdFhhQTlOUnBjdHFu?=
 =?utf-8?B?SmpzcXM5eGplRXBoN01EQnBpWVZ6WEFNY2FDYk5ydWwzL3MzYTB1aDluaklt?=
 =?utf-8?B?L3VBNHlaV3BqK0JZQTRndTZZZk5KalgzSGsyRFcxd0Z5Y3QxbkVNUE4zTU45?=
 =?utf-8?B?KzlhcDU5MEJBbDVDNkZGbDhNbVUzQmYxekUwbmViTUx3T05rQUFLbGNSMUZn?=
 =?utf-8?B?a1FCY3p5V0hOdHFLZmtIZXRXeTJKQnlMb2NBcy9JaFBtSE9aME5NRmRQY2NV?=
 =?utf-8?B?ZWFvZEhjUnNQeWo2NFQzN0s4Zjc3SVA5a3BsT2JUQ3VrMWhzNWxiTkcxbjZ4?=
 =?utf-8?B?NWtIRms5M09weFFUSjBrcWh2ZUhKWjkrZ01RUVNhSjRRcUs4S3Z5WUwvVU5Y?=
 =?utf-8?B?Q1h2aVVNUGlyeUp6Q0plcHV0U1NJZFpjcnB6aGU1NG9ZYUhpeDZXZ0ZYQTFF?=
 =?utf-8?B?RW91ZXNRUlFyNnRjbXlUR1NJTGV4ZzBIdXZ0NDlUaGl4ZEZBVjRTdGU5a3hC?=
 =?utf-8?B?bTZKRk1wTUUzaC95MTY3K0lPRTVScTROZGdkaDc5eS9ySUJRQ2ZkWkJOZHVE?=
 =?utf-8?B?aW9PYlgyMTFjSytXOWFxdHNmY1FTb1dFZUZaS0dsSFB3QncrZkFZeVFiQXJT?=
 =?utf-8?B?OWYrQVlzRmpQQXQ4eTB0a1NsYjFTNWpPa0NKN1huOG9SZXZuR3RZNHl4MFkr?=
 =?utf-8?B?RWRqQWNqVTZlZmU4QlZOWFJHejdWRFNTTTJzNis4M1FxdVdBd0xsMGFzK1Br?=
 =?utf-8?B?Y01WV2xPcG9laU1BTVRVOUxIY2h0M1BrWXRGaWJOd1g0MlcvQkRkc1lDZzNs?=
 =?utf-8?B?SUdpWThmV21wVHJ6bzVSRi93eEovZVdFMzJKUTdYZ0lkWGtUbmJtbGlBbWty?=
 =?utf-8?B?TmN1Ym9tYVR2NllrRkVhaUhyVHBtU3JBRWZPRUtDSkhrakEyb0dJSS9NV1Zo?=
 =?utf-8?B?TFlWQW9DM2JkVlZSa3EyeDN5U3RXVjZUc2cvVkJMNE1kbnlicmw2M1RhNDR1?=
 =?utf-8?B?RVhhbHhCTnpUU0luY2ZVL1FLT3VRcE9IcFB1YytXckhDckFnMEk2UXZjbGxp?=
 =?utf-8?B?N3VPd2JCR25vejhDNU1LcDBtdnplNElmRlQra0xjVUYzdVpkYVJROWhlbzFM?=
 =?utf-8?B?SDlFcWEvYWdaaDNocC96ajB2MGNIS3V4TmpQUGhmdDNtajJVRTNpaTZBMGdR?=
 =?utf-8?B?b3RtWVFhSDMwVE93SG40UEtSSU56MW1HcEE1Qm9qYzBoVzRKalNZUEhqOUJX?=
 =?utf-8?B?MnF5SHE2MEpsYnZjcWErM3orb1VoQzNzV1FaUGI4ZFhnaCswUnRNSVlleGlu?=
 =?utf-8?B?TkF5alRiNkpKUHhsbk1iN3RKS213ZEM1Ym1DSGV1enBkcVAwdjdONHBVc2pI?=
 =?utf-8?B?VWcrMkZ6QWs0eERQa3lRTjhkNHQ4ZlVSRzlTYnVNRXhlMzJRaTViYVJLR0dn?=
 =?utf-8?B?MUhKbUk4RVIydk9vY0dmWnFyL251MFk1a1g4QUpQcWJaLzJLU1oxbStJU3Rv?=
 =?utf-8?B?WHJsR3QxTjViSSsvcjV4UVpHVXhLMTIwaVA3UHk2V29uQkpWSzNBZ1lDZEdj?=
 =?utf-8?B?MTJKaDhUeXVNeGh2aEtJWkhXWHF2QTJIbG1DR1dWWFpNSy8rNjFwampyOVZk?=
 =?utf-8?B?YXNwbnFkM0JXMk8xZTE0b2FyUjZtQVUxUUtlY09LRTRNR3ZqUzYwdGYxU1da?=
 =?utf-8?B?dmkzNENBMWdhWjdSS2VSREg4eENGSC9uZ3N2S0IyK2FGak1HY0R4NWpUdGda?=
 =?utf-8?B?VERPOVB5b2xpZEF1NkdTejAyamtWMW45dWx2V3RDU1h0Ym9DZkxUWU1XVE9Y?=
 =?utf-8?B?aDdyZ2FFaXAweS9LU1ZmcitQNTRYb0ExK0o1eXkvejYvWm5nYTM2YXZHWUd2?=
 =?utf-8?Q?Ykg4oExhsw4XOVV88M3stL8bf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b520a4-17cb-4ee7-4d81-08dba92b97c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2023 07:34:49.7650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jaSrtkekZf0YPiCcKETQrJH3VB8n6CrPHgZt0qelZNm76M0O2dSxpLTCXrpGi46STEUMGeWXRUYSzWe6Q1nLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8268
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgQXVndXN0IDI2LCAyMDIzIDM6MzIgUE0NCj4gDQo+IE9uIDgvMjUvMjMgNDoxNyBQTSwg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+DQo+ID4+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDI1LCAyMDIzIDEwOjMwIEFNDQo+
ID4+DQo+ID4+ICtpbnQgaW9tbXVfc3ZhX2hhbmRsZV9pb3BmKHN0cnVjdCBpb3BmX2dyb3VwICpn
cm91cCkNCj4gPj4gK3sNCj4gPj4gKwlzdHJ1Y3QgaW9tbXVfZmF1bHRfcGFyYW0gKmZhdWx0X3Bh
cmFtID0gZ3JvdXAtPmRldi0+aW9tbXUtDQo+ID4+PiBmYXVsdF9wYXJhbTsNCj4gPj4gKw0KPiA+
PiArCUlOSVRfV09SSygmZ3JvdXAtPndvcmssIGlvcGZfaGFuZGxlcik7DQo+ID4+ICsJaWYgKCFx
dWV1ZV93b3JrKGZhdWx0X3BhcmFtLT5xdWV1ZS0+d3EsICZncm91cC0+d29yaykpDQo+ID4+ICsJ
CXJldHVybiAtRUJVU1k7DQo+ID4+ICsNCj4gPj4gKwlyZXR1cm4gMDsNCj4gPj4gK30NCj4gPg0K
PiA+IHRoaXMgZnVuY3Rpb24gaXMgZ2VuZXJpYyBzbyB0aGUgbmFtZSBzaG91bGQgbm90IHRpZSB0
byAnc3ZhJy4NCj4gDQo+IEN1cnJlbnRseSBvbmx5IHN2YSB1c2VzIGl0LiBJdCdzIGZpbmUgdG8g
bWFrZSBpdCBnZW5lcmljIGxhdGVyIHdoZW4gYW55DQo+IG5ldyB1c2UgY29tZXMuIERvZXMgaXQg
d29yayB0byB5b3U/DQo+IA0KDQpJdCdzIGZpbmUgZ2l2ZW4geW91IG1vdmVkIHRoaXMgZnVuY3Rp
b24gdG8gc3ZhLmMgaW4gbmV4dCBwYXRjaC4NCg==
