Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977867B7451
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjJCWyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 18:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjJCWyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 18:54:01 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408989E;
        Tue,  3 Oct 2023 15:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696373638; x=1727909638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UPNSbLQFHb9dbYjorwUBSUS8Km1hubKCftnIdp5OCXk=;
  b=nTIKAY5zqCNghByl8O3EV/0zVLFkQBjj7d8O9sc5JZNGyDL1b/xPLizS
   VZPgTcVTh94yF3Ixkw6ZGG6E3XBbbRHb24EMBf66l+e0ZyiHfgWzkdjx1
   7VG9O93+Zpfnt1X0GqkkgrWugCQQ5XVY6M8VRnPyp5SIZkWqbiyfPApz1
   4K08OVEcZm8vpzqtiYBFD5Dp5DgipYDVPVllcrmqNAXcoVFe694BSljCa
   X74miydiEGx0AwEZRNy6g0wjB/63yOqb/wZ44nIjrjJMHg0KIxEuHLsKB
   vL2iXuya4RT3CGcQkCkEcAkg4Z4bD5pIyvdJr7ciXTs+1CTEXQtR/XbAP
   g==;
X-CSE-ConnectionGUID: wO5Py5iCQvOLWic5ca7DAQ==
X-CSE-MsgGUID: CIP8WeHLRSqxAEmlavZtLQ==
X-IronPort-AV: E=Sophos;i="6.03,198,1694707200"; 
   d="scan'208";a="245922955"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2023 06:53:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VALMKoB4CY0M38X3/qKfdgiVQTRBybJ6j7A+CW7WOFOheL2gTQVQJjslM5AF0QS4EWNKmXSEY6Kn8L93Iz2OEtD+ugxDz5WpBLOVsE4TQtCVVLPGjI1y40YFV3RiBwivmjOr/EwTtEubuTue/30LSOvD9gCs9KUOu/RJNPf9zSDGDAcwL5pCn/TArbFeijtI2y1EwvcFVXZ8cnOEgcr8LzUmGZ9mU7nUJVKG2mm87CpLzBojiBzX8gptFn2zZH8Cb5YlW3bxb9HwqsTx96Kqg2QCTQWuTmMCmpjOGLU1F/eCTgQlJpc301Vqu+o7oRn6KOsKNyztT/7tOPLqNyjZMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPNSbLQFHb9dbYjorwUBSUS8Km1hubKCftnIdp5OCXk=;
 b=cm0Y0txJyy6FrMpu9QY+0texEGpA4OdTNBqjTs/qAqmXpJ1GjY1Yz5ompB4kYPOnn2ITK6hK/fb9qxd+SWjfL8CW7z6Hlz067LKH8jF3yK56L3RwJIqyyHRug83hGDywzROFyH4ZxIorm9sUpxbBXZ8LnAzkDtALDKjgLWNNt5FrbyPvs2VUsXx3B5yAV7gs+IqDUI2tnFXi0yso8pFfH+0mR44+2AuO5jyoiR1jqGGzmSiztt34FUbVIkOxkMDmSJDfag9S7G75oHwqLWPSNbCoDLqQYME2MmNnXZIjO1etgIVXAwX6AklsQr2eIA2t/jibIBRGSQP21S99u0ekXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPNSbLQFHb9dbYjorwUBSUS8Km1hubKCftnIdp5OCXk=;
 b=ZfxNZ5qh4uO0g/yWSbAGfMHi9T4aUsH6VCHGVVz1LGmD82roOJJM/efW4ZsUSyeu2qaPfvtEPWaO61Z63Ooiuzt3FLdncmBITAtFjf4wjmg/TidbI4QkJL+pQQUBg2kB2V/WZO6aIDTRyaTm2czCzWxQD72R1I69BipHH/15fzo=
Received: from BN6PR04MB0963.namprd04.prod.outlook.com (2603:10b6:405:43::35)
 by MN2PR04MB6751.namprd04.prod.outlook.com (2603:10b6:208:1ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.20; Tue, 3 Oct
 2023 22:53:53 +0000
Received: from BN6PR04MB0963.namprd04.prod.outlook.com
 ([fe80::45b7:3d1d:a02c:eabe]) by BN6PR04MB0963.namprd04.prod.outlook.com
 ([fe80::45b7:3d1d:a02c:eabe%6]) with mapi id 15.20.6838.024; Tue, 3 Oct 2023
 22:53:53 +0000
From:   Wilfred Mallawa <wilfred.mallawa@wdc.com>
To:     "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "lukas@wunner.de" <lukas@wunner.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ming4.li@intel.com" <ming4.li@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "aik@amd.com" <aik@amd.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "david.e.box@intel.com" <david.e.box@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH 04/12] certs: Create blacklist keyring earlier
Thread-Topic: [PATCH 04/12] certs: Create blacklist keyring earlier
Thread-Index: AQHZ8jQHh53vYj2sr0un30/vH2lT97A3xWSAgADvKIA=
Date:   Tue, 3 Oct 2023 22:53:52 +0000
Message-ID: <74359f4f35ac9c418048ba8d78b5d0e2f3fd5692.camel@wdc.com>
References: <cover.1695921656.git.lukas@wunner.de>
         <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
         <7e98a953-a4b-70e8-caeb-a94237e593f8@linux.intel.com>
In-Reply-To: <7e98a953-a4b-70e8-caeb-a94237e593f8@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR04MB0963:EE_|MN2PR04MB6751:EE_
x-ms-office365-filtering-correlation-id: a3574bc6-d8b4-44ae-58f0-08dbc4639dba
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cP0GOvGzIzb8+k9JCbeUv72/W967LDR/99KeO6dbmMYYYhM3/c4MoRj6yHSoei89jg0tK2/QyhaWYp6OtSKna6xrKXkEzpGR0kRYVPgIbSaDYuoFvPaumDAflvxBrRrpT73rIMGqZHbh4HQvD3uAhH+mUa7XX+eT9iu/VUlZcHTUNQ0AelsNLtrm7aO8IxeIPfwrKgx8+wNHcLktnycYksD+3B3TAPl3sWBasc4ZT/gCfsnfk6z6lImAnWmEahw3A1UOt6Pjl0HpCkMTMMvN/YEZHPINllcyQl+SAwV10WPUTyChjfweAuzy54S8D40iRqmQtY1w6t5qsnYx8aVUseVowQieOnb3gncb9AZrKGogL2oUdUXPQFFhDSeNhfTaK4gyM/GGOWLbrt9dw56tgLtSlsz0lXD/VasMnBZzOcrqS9FPfHFH66Ce7CFj+0NCkX9vwJQ7LYSnRLq/Hu6EI8H5rwEE/NNfAYKf2GYLy5ZNmZUZG15rAwetGb5LZCw+i63VpiJU5fLAlqmG7f1mwRTWwu3g6Gm51AO3hxeAbQnuU4TKAq+JiRclchPCf82GF9TIhZwAQx7e37NMnWGsU5SG9mxql2/aBa0LtORcNAJpDdm9z2Z2JC9QXjVsjUlH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR04MB0963.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(346002)(396003)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(6486002)(36756003)(86362001)(6506007)(6512007)(71200400001)(38100700002)(478600001)(122000001)(82960400001)(110136005)(91956017)(66946007)(66476007)(66446008)(54906003)(316002)(64756008)(66556008)(76116006)(41300700001)(2616005)(38070700005)(26005)(8936002)(4326008)(8676002)(66574015)(5660300002)(83380400001)(44832011)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnpvakN3UnVDZWJsd0tvQ1NwUzZCeWJ0Si83T2lCRlg0ZHdmVzhveHViSTB5?=
 =?utf-8?B?WXVTM29Fb0lsU3dSVjNDL0R0OUo5ZHJXUGpmNDc3aFNKZlFuNFJ0R0c0SXZS?=
 =?utf-8?B?ajEzcHQrLzgxREN2MUxnYStlZVc3anA1WHdNQXZMWjUyNnVZMEVQL1hrM3Ew?=
 =?utf-8?B?azkyMUI2V3JseWVaSHZ1R0w3VzJhQnJzanpsMkh2OE9hVXlEMG5UWXB6eTNj?=
 =?utf-8?B?S0U5U29kSEdSL1lOdUFseGNUZFlPTVUyVXpoY1ltUEdVZFFUOHlMd2xlc2Ur?=
 =?utf-8?B?cFN2c3NDa0Q1alBDcS9LUkVDSjNXdTIxTDhieEI3cllwdWFMNENXb2lWZXFt?=
 =?utf-8?B?M1VYakxlNTJiNVFseU1XOE1KMW85YnZVSG51cnVJbVh2aVFDNktuQ01Ramhs?=
 =?utf-8?B?N2Z6N2poZXFYZEZXZWFhUXpRcFEvTVhBZ2NyUnRvdVROMzY1Ujk0QWx0cmFR?=
 =?utf-8?B?ZkVoNFE2VG5laTdMM0pZSDZ1U1d3d3NNbGR5NGk4NjE1RlNNZWxuSTVpa2Jp?=
 =?utf-8?B?ek82anE5bzVudmttUThmb2NEUm9ERHFsWkx1VWc3MGVRNkIybjRlTUsxN2Uy?=
 =?utf-8?B?NjNUR3Q3WXRtTmxQQXAvejVnWEErakttVFI0VDR6dlA4cWUzLy9sazZSZ2xi?=
 =?utf-8?B?V0pZNWdGbjE3S2QyME1LbVJQKzhBUkdId3hCR213aENWTnJBejZXc0poL3Ix?=
 =?utf-8?B?U3ZqbWdha3JUMkFIOWV2cjBUUVBmVXZNVFNid0ppejdqaVBjRnpqWlptem90?=
 =?utf-8?B?dkhEUW14dEZVUFNuQ3orQThEUDJGajFZcFc4SEFIYk1RTUhuSnNiN0dhS1gx?=
 =?utf-8?B?K2VpS2J6ejUvcktvaW5vWnJFRC9WVzVHRExJbnhqN3pKK3R6R3VkbVZuTTA2?=
 =?utf-8?B?VW51NUVRa1NaaHA3RDF1bm9jY3RtRGh3NW85b1VRVVNjZStSRThmOWt4dDQ2?=
 =?utf-8?B?QTMzdmJOYnVHZFNCYkZzWkJwUHBsVk8xUXkzWGNtK3lTOHlWd3FqTVJ5cENt?=
 =?utf-8?B?NGQ2NWhLY3lRTStUaU9SSmV0RmhUSXVUR1JrL3QzRVRpRnkwMXViVG1kV0g2?=
 =?utf-8?B?U0ZLWDByUG5td2hGYXNjeXJIWk9pN3JFelZXNTFZc005cmh5SnE4Sk1lbXl5?=
 =?utf-8?B?alpnUVZEdDJtVlhBdHZicExVWkJreHRRSXNGMlE5THVrUjMxTENkWHZxTkZG?=
 =?utf-8?B?UFVDU2dsYUZjcnR3U1VOcGtoaHMyOU9UcXFSTWtvQnR4MkxYakMyejkzczQ5?=
 =?utf-8?B?OHdKUWFKL3NFRUJJMEU0ZmVuajZxREk3UE1pQkR1MnRpNDVjL2E4OUVTY0ph?=
 =?utf-8?B?N3BhenFxZTNBdVI0akJrTFVTSG1raXNpTWdRbHRoQnllN0Vmdk85MXBDUmtO?=
 =?utf-8?B?eGU1ZkUyOWovVUZPc1c2dmhMejRVMDJWeWl5VHA5blFJWVh0SXJZUlRNZWp2?=
 =?utf-8?B?elBtc1VuTVRzMDBnNUNtWFQxSzg3SlVjOFBFNG5oK29qM09NQm1yMzZNdjE4?=
 =?utf-8?B?V0pldmNBL3JjeUdKN0JqV2FYbXV4OUlPWjRSV3B3Y2tBbXB1amloZlRnc1Yy?=
 =?utf-8?B?VEl1NE9BZWQ0SFdES3lZbldQQ0JMd0FOZ1dJTGZqL2VVS3dhYXZaT0RUUks2?=
 =?utf-8?B?d2d6cW9wdHNabWQ2aE1USDBUNDYyL1BUeG5JL2lWUTc1ZGltazVFQUtWV0pV?=
 =?utf-8?B?NjMyaHZlbkJoQUlLK25RbVBJaEkwSlRaNHpNZHh2UmpCZjd4NU91QkQvU1dN?=
 =?utf-8?B?RmNKNFZ4WkhHZjJGQkxEcWNtVXd5REhaNXpteFlqZWpQQ3NRMERkaElQU25r?=
 =?utf-8?B?K3ErZnowdW9YNU9OandoWk1pYVQrbWhLS1hVbTVzK1ZmM09SV3pncUtScjdG?=
 =?utf-8?B?QWxMVnBja0dMVnh1bVorcnRFMFJsa0I3dHVlMWxqR0phSnN0bm5RTzI2bGJo?=
 =?utf-8?B?eWlmeXJZMjZGTGVzZjhnQVNkcmdEZXhNeWQvMWdjeVFtKzhEeUFhY3Y1cGJC?=
 =?utf-8?B?cWpOdkFnTER3VmZGZE1VdzVYSXhKeGhHSkJ2WFZ4dVhQc294QjQxRHBRMEFh?=
 =?utf-8?B?czRnOTcycE9iUWdwR0IzblhNOFdVVGZueGFQUDNIVUJPeDEwcVBqN2hQTWpv?=
 =?utf-8?B?Y21zelMyQkc1eFdYRWpnSnZJazNqd1lRUmlBSHdOY1p2czM1NG53dzh2bVpn?=
 =?utf-8?B?RHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB81E4A7BA364B40B5F8B9AEAAA9C267@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YVh4YzhJRmRSdFE3MWM2dE1pMzZ4TXEzSElzTi8yanhNaFJYajBkblM4a2RC?=
 =?utf-8?B?eEJiUjZRSkM1cStwcjBxWnNweFlNRmJUczhSQkNTaVJCMkpzZDc3QmV1R1dq?=
 =?utf-8?B?eWRkZXZQSUJRcVBIMi9QQ2ZPRkFFWlpkTjNYcUVReDg2cmdhbEpSMWtjSkN6?=
 =?utf-8?B?UmZ2MWd0VlkrWm9ZeEppNld0TGsveXNmQUdmS1YxbE0xN1V5Rm5PVXU1ZGZk?=
 =?utf-8?B?ZW0yVnJuMi9tRVJTalRUcnJqL2NoZjdrZ0c3VXNGOG5YaEF6NWpmRU94V2Ew?=
 =?utf-8?B?bXp1SVkyN0JsaDBpYkxyT082V2I4V2MvWVZTK1lKRmF5a2RacCtzb2tkbXJY?=
 =?utf-8?B?OTRFUVJHbTRKMm1ucUdBTTFIMjBYeFpCZGxtaG5tSEdJK0xVekJWT1JmdUY4?=
 =?utf-8?B?OFBrdFRJUmhabGJSN3hOSStsS1lUekRhY285K1ZVb2RFUW5wL2lLeXArUzFm?=
 =?utf-8?B?TlF2N2dJV1pNQVNvaGR6Vzc2WWphSWx0WFpsSkVYK0MwTXV4NlRtM213dUZZ?=
 =?utf-8?B?RktUcWJONWtlRmNib0JRMm1uYXVScnh1a04wem1sRWJCTzZQK0orbHY4TzRG?=
 =?utf-8?B?Y3BZb0t1cnFIbWFOdEZFRVVIRUZqOWFqS0NCQjFmRzRIUkphV05MWlFNME5y?=
 =?utf-8?B?eFI2MlZHLzRRZGhZRXpYb0FLZnVrbkdpSGs2UEgrTnZFcjUrdXhQMmh1N0Jn?=
 =?utf-8?B?SlgwMG9yZjE2Snd4RUhQWGRmcEpXSC9zTUtSUDAxaVVrcXlGQnZnWnR3YnQw?=
 =?utf-8?B?RHdremtFZE1LOCt6OWdXeDVpUGhVT3d4b1hLTGtNakVUVkE4SWNVL1BYTC9z?=
 =?utf-8?B?T2NkOGFwV0VFeU04Zm1RUzc4VERjcUxPMVQzU3VldXdqdTRianJjS3VjRmFx?=
 =?utf-8?B?TTZkL09kd0hJMmJIbGhZaFlUUjNjMGJFYXM5SHJEV2I1RjlWdUQrdjZzTVF0?=
 =?utf-8?B?SzJZZ3dybVZDdytEcmdqa3J5N0Y3UU8xQTF6QnU0WFJCbW5pSllZc1gyVzJu?=
 =?utf-8?B?MTI0TWZnb0hyOVNvRzJvdHZwQ0pQQ3UvWUk2V2tPK2ZYQ3pxQm9Ga3ZvdEE2?=
 =?utf-8?B?UzAzWjVsM3hQbnpmcEdSMjNCVGQ5NmZXRjh6K21Bd0lEQlI4Y3dtK040NFdm?=
 =?utf-8?B?WUFzenN4UkUxSXhnUGVDU0RkWVc1d2NGRTZmRG1SNEdqemhhUTUxTUpnZTMv?=
 =?utf-8?B?dGdSTmJzZE9VOG80RUJYczE2d29wc0EvbmNqWGMwQTd2dXpxZ3BsSnFMSmNB?=
 =?utf-8?B?SExDb3p0OXVBTVcrMXk2eWdMRUd4OGhTRUJXdmR0VlJkbWlqZXAzMjVlSkk3?=
 =?utf-8?B?T2ZQZEJvY2ROVDArbnlxSnFJYjRuajZYWk9uOWNrcDJwL3hTK1F4RkFycU1F?=
 =?utf-8?B?cWpwS3FwamtMK3VGMTRTRzA5bVE4a3E4RmN3YWFSZ2VMVlJBeFF6dmhWNUZH?=
 =?utf-8?B?MXJTa1FOUXk2a2dwaE9YczNBWk1mdCtudGpwY0IwblNpbnN0dm1QQmplMyt6?=
 =?utf-8?B?ellNVkxzZVRGd0NRTGFVZWsxeWtWUllDSmRZdVFQbzlQdklNRTMzcUJSOXlz?=
 =?utf-8?B?S0VUOGR0eTdCc2trWUxUMkJyM2RlTEdzWTZTUXkyeVU5K0hsYnppcEgxVW5i?=
 =?utf-8?B?RTN0TEdjc1VIc2hjMHJIUWIwWlR2alE9PQ==?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR04MB0963.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3574bc6-d8b4-44ae-58f0-08dbc4639dba
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2023 22:53:52.9639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8NtmLKGhS7CHUm7Rsol5k4ZP2ECED2l3j4ZlxPZ4jipnnMsCOgwcM2toYUh0EOYw6rHZfXDWZ7xQbbycJxUOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6751
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTEwLTAzIGF0IDExOjM3ICswMzAwLCBJbHBvIErDpHJ2aW5lbiB3cm90ZToN
Cj4gT24gVGh1LCAyOCBTZXAgMjAyMywgTHVrYXMgV3VubmVyIHdyb3RlOg0KPiANCj4gPiBUaGUg
dXBjb21pbmcgc3VwcG9ydCBmb3IgUENJIGRldmljZSBhdXRoZW50aWNhdGlvbiB3aXRoIENNQS1T
UERNDQo+ID4gKFBDSWUgcjYuMSBzZWMgNi4zMSkgcmVxdWlyZXMgcGFyc2luZyBYLjUwOSBjZXJ0
aWZpY2F0ZXMgdXBvbg0KPiA+IGRldmljZSBlbnVtZXJhdGlvbiwgd2hpY2ggaGFwcGVucyBpbiBh
IHN1YnN5c19pbml0Y2FsbCgpLg0KPiA+IA0KPiA+IFBhcnNpbmcgWC41MDkgY2VydGlmaWNhdGVz
IGFjY2Vzc2VzIHRoZSBibGFja2xpc3Qga2V5cmluZzoNCj4gPiB4NTA5X2NlcnRfcGFyc2UoKQ0K
PiA+IMKgIHg1MDlfZ2V0X3NpZ19wYXJhbXMoKQ0KPiA+IMKgwqDCoCBpc19oYXNoX2JsYWNrbGlz
dGVkKCkNCj4gPiDCoMKgwqDCoMKgIGtleXJpbmdfc2VhcmNoKCkNCj4gPiANCj4gPiBTbyBmYXIg
dGhlIGtleXJpbmcgaXMgY3JlYXRlZCBtdWNoIGxhdGVyIGluIGEgZGV2aWNlX2luaXRjYWxsKCku
wqANCj4gPiBBdm9pZA0KPiA+IGEgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIG9uIGFjY2VzcyB0
byB0aGUga2V5cmluZyBieSBjcmVhdGluZyBpdA0KPiA+IG9uZQ0KPiA+IGluaXRjYWxsIGxldmVs
IGVhcmxpZXIgdGhhbiBQQ0kgZGV2aWNlIGVudW1lcmF0aW9uLCBpLmUuIGluIGFuDQo+ID4gYXJj
aF9pbml0Y2FsbCgpLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEx1a2FzIFd1bm5lciA8bHVr
YXNAd3VubmVyLmRlPg0KPiA+IC0tLQ0KPiA+IMKgY2VydHMvYmxhY2tsaXN0LmMgfCA0ICsrLS0N
Cj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2NlcnRzL2JsYWNrbGlzdC5jIGIvY2VydHMvYmxhY2tsaXN0
LmMNCj4gPiBpbmRleCA2NzVkZDdhOGYwN2EuLjM0MTg1NDE1ZDQ1MSAxMDA2NDQNCj4gPiAtLS0g
YS9jZXJ0cy9ibGFja2xpc3QuYw0KPiA+ICsrKyBiL2NlcnRzL2JsYWNrbGlzdC5jDQo+ID4gQEAg
LTMxMSw3ICszMTEsNyBAQCBzdGF0aWMgaW50IHJlc3RyaWN0X2xpbmtfZm9yX2JsYWNrbGlzdChz
dHJ1Y3QNCj4gPiBrZXkgKmRlc3Rfa2V5cmluZywNCj4gPiDCoCAqIEluaXRpYWxpc2UgdGhlIGJs
YWNrbGlzdA0KPiA+IMKgICoNCj4gPiDCoCAqIFRoZSBibGFja2xpc3RfaW5pdCgpIGZ1bmN0aW9u
IGlzIHJlZ2lzdGVyZWQgYXMgYW4gaW5pdGNhbGwgdmlhDQo+ID4gLSAqIGRldmljZV9pbml0Y2Fs
bCgpLsKgIEFzIGEgcmVzdWx0IGlmIHRoZSBibGFja2xpc3RfaW5pdCgpDQo+ID4gZnVuY3Rpb24g
ZmFpbHMgZm9yDQo+ID4gKyAqIGFyY2hfaW5pdGNhbGwoKS7CoCBBcyBhIHJlc3VsdCBpZiB0aGUg
YmxhY2tsaXN0X2luaXQoKSBmdW5jdGlvbg0KPiA+IGZhaWxzIGZvcg0KPiA+IMKgICogYW55IHJl
YXNvbiB0aGUga2VybmVsIGNvbnRpbnVlcyB0byBleGVjdXRlLsKgIFdoaWxlIGNsZWFubHkNCj4g
PiByZXR1cm5pbmcgLUVOT0RFVg0KPiA+IMKgICogY291bGQgYmUgYWNjZXB0YWJsZSBmb3Igc29t
ZSBub24tY3JpdGljYWwga2VybmVsIHBhcnRzLCBpZiB0aGUNCj4gPiBibGFja2xpc3QNCj4gPiDC
oCAqIGtleXJpbmcgZmFpbHMgdG8gbG9hZCBpdCBkZWZlYXRzIHRoZSBjZXJ0aWZpY2F0ZS9rZXkg
YmFzZWQgZGVueQ0KPiA+IGxpc3QgZm9yDQo+ID4gQEAgLTM1Niw3ICszNTYsNyBAQCBzdGF0aWMg
aW50IF9faW5pdCBibGFja2xpc3RfaW5pdCh2b2lkKQ0KPiA+IMKgLyoNCj4gPiDCoCAqIE11c3Qg
YmUgaW5pdGlhbGlzZWQgYmVmb3JlIHdlIHRyeSBhbmQgbG9hZCB0aGUga2V5cyBpbnRvIHRoZQ0K
PiA+IGtleXJpbmcuDQo+ID4gwqAgKi8NCj4gPiAtZGV2aWNlX2luaXRjYWxsKGJsYWNrbGlzdF9p
bml0KTsNCj4gPiArYXJjaF9pbml0Y2FsbChibGFja2xpc3RfaW5pdCk7DQo+ID4gwqANCj4gPiDC
oCNpZmRlZiBDT05GSUdfU1lTVEVNX1JFVk9DQVRJT05fTElTVA0KPiA+IMKgLyoNCj4gPiANCj4g
DQo+IFJldmlld2VkLWJ5OiBJbHBvIErDpHJ2aW5lbiA8aWxwby5qYXJ2aW5lbkBsaW51eC5pbnRl
bC5jb20+DQpSZXZpZXdlZC1ieTogV2lsZnJlZCBNYWxsYXdhIDx3aWxmcmVkLm1hbGxhd2FAd2Rj
LmNvbT4NCj4gDQoNCg==
