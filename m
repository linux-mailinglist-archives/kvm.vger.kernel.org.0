Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC87C7C62AA
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 04:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbjJLCUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 22:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjJLCU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 22:20:29 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9920698;
        Wed, 11 Oct 2023 19:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1697077227; x=1728613227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wpzIerpExV7OiYeM6cpIEGj47Ed7Mu7cQoY9qInwNmo=;
  b=aRQF5V4qlit0PzJ+1u+mzsYh+UOrz5cn1WFdGKn0wgh8/nx5DphitGqG
   /0OTg9U4vgeMEiXGIXxljsYQrRt+s/xBhsmhUp7fYCFunAhSNzXdDKUmv
   +rlfI8FWlQ5SFxoGbDbK0EXNT7b22RBFekoY94yiAgec/y3QjiR+8bdnb
   ctK7amaCVc6mrK24uVi+gWpCwIhUygM++40WCKIphw/gnRj5nRpik87ix
   USkX0J0ocaM61zivkiCbLQq66vVDp4MhTIFmj41Hib4HTfQ/KQ3UHsTEW
   GnaK3LXzc5ZuaRzie4xjZmf2XPX1sKtaUhGFcCrTVL9ZGlbTH6qs4gDS6
   A==;
X-CSE-ConnectionGUID: RgDM3ky+RmGk5OVr5OJzCg==
X-CSE-MsgGUID: Ds8PmYffR1uQaQ+cMlgi0Q==
X-IronPort-AV: E=Sophos;i="6.03,217,1694707200"; 
   d="scan'208";a="246345079"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 12 Oct 2023 10:20:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z06teoHSrJ8akk6CZz3yfvX+dsS8DxPRgvGbPpJAuKX6CPezFUUthg/feGcILm8z3C8hNa5TZZEoIVk13tlmVzyWATKRs9xsDb3Jj8eCccGX9YqJMYbyzallsNGeQBkDn3HVDVuJkNp8XiE5KqLF5daX4PKGs29ZnK/QGQzn3ui6l5MdMaJLbWLNI5CFSdH5vQGMlUQinfIo9frKCUIkSHeduEo3vEvloJvN1vgzfczoS0pzdoeIJUOwiLkIFaFCmq20GOD8aSFNT+UTaa8u//pPDjbI2upe/unbvXQtXLgnXx3ihc8UYwfsR3d2gdkzJbvH7bk5tf1YaVTbzuyYQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpzIerpExV7OiYeM6cpIEGj47Ed7Mu7cQoY9qInwNmo=;
 b=Ikgseo/XZRb3rzrXiRdJEuUbotLlSJ6ChH58lrKpEpDAfkiS8r99zUdWMA5u1wXNX6PETJWXCVyubepKj2C3AldlMaPdQw6sUAtnseCd8fBsd1cGMJC/ItRniG6qKParfw1kBbx02K+h81/I0ZtFNH1pkN9cI4TvQFdEtO90sWWT8zHab+A8z/Ur2QGEWe4Fh4Uta+Wae6UurI502/VpEtBcISRED0JxGLjJ4CFNe7KbqKk57tkntANNQQAqn38o9RgLcjViBVPwpX/FmqqlrPvjM9DM/FoBoEvIxy/UPOalhWj+FKtLeMRqX21dOJjV7Rpd+PbV5cd+XqMmZkSlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpzIerpExV7OiYeM6cpIEGj47Ed7Mu7cQoY9qInwNmo=;
 b=VztUq6BwIL+o65+VC2KEX4SGQZMfK39g62Y0cXBmMe0suO14srD0FUnks1D8BKQUQMxPiIFx/PGp6RNCs8kEu+9VDtQR+DuF+GzyYg0QQs0fICX2+hgW22DpWuWprqmtsZdfLBithsUEmzd0NSP6kRVL3FPo5kQZfc8avhg1JsM=
Received: from SJ0PR04MB7872.namprd04.prod.outlook.com (2603:10b6:a03:303::20)
 by MN2PR04MB6365.namprd04.prod.outlook.com (2603:10b6:208:1a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.17; Thu, 12 Oct
 2023 02:20:22 +0000
Received: from SJ0PR04MB7872.namprd04.prod.outlook.com
 ([fe80::d60d:e7a0:5674:fafc]) by SJ0PR04MB7872.namprd04.prod.outlook.com
 ([fe80::d60d:e7a0:5674:fafc%4]) with mapi id 15.20.6863.032; Thu, 12 Oct 2023
 02:20:22 +0000
From:   Alistair Francis <Alistair.Francis@wdc.com>
To:     "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lukas@wunner.de" <lukas@wunner.de>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
CC:     "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "aik@amd.com" <aik@amd.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "ming4.li@intel.com" <ming4.li@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "david.e.box@intel.com" <david.e.box@intel.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "graf@amazon.com" <graf@amazon.com>
Subject: Re: [PATCH 04/12] certs: Create blacklist keyring earlier
Thread-Topic: [PATCH 04/12] certs: Create blacklist keyring earlier
Thread-Index: AQHZ8jQHC51TwHvbXkiwYX4PX+bytrBFgOSA
Date:   Thu, 12 Oct 2023 02:20:22 +0000
Message-ID: <df8c403791a588b97188bf0465426a270e3a4e6c.camel@wdc.com>
References: <cover.1695921656.git.lukas@wunner.de>
         <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
In-Reply-To: <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.50.0 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB7872:EE_|MN2PR04MB6365:EE_
x-ms-office365-filtering-correlation-id: 443f735c-b30a-46da-80e7-08dbcac9c9e5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B+oU7FR1ZanO3vrFNzrLt9S2l3fxhV0GBjUsnZcEwSU9vY4oqk5ZzJhmv7UrcUHCB2Oz9PIOPGn7vzxx+zJ92WVqVROTvsvaJ5BFuoysB4F94yH2afYb6lsp/rX93CpA2KFprUyq3tQqV0xYsajj3v3pctBKbF8i6rUbPEwprUcBKPAKWWKE+nct8jmxA06qMBJTe05W6wEiBqZcVMEjGLOiaw8r3wRcKw6IGCtjemwG2L02V25Nnyr7iJD8/1+45bExIt5qEdUrHk7KSxVDTPxShk6cxRP3n9KdJdXuJ82fnUi2dhhco33xlLS67/cY1ygt9L5uqS7Dh69o3xSMpBnnI2m3Ni+urUmmlCgkj2LhUgIa0S05IB4oipPanZzD6e4i2xEL4O6nCp5D+uVyJlImTvuXDyy07t51hFcit92p5WgW+jMayFopaoq3JA3q046yrjx8GashEyhYEyT2oQ5xSGw1n7EaU6JYgK60BJDdRtDaEktuHHg0YWClB0tuKRjer4efyg/5xnxr2pD/yHR8O6ni8AdhiVqLISdBF5/83cNW019uzCU72cIaCVJ1jMCuwguDi78Si9zd/mN9WCp52ySPK7PeOr548f9uE9PNgZc4zyRktMD52lmea8pPMeJw2nKJz0RA1sD0XWqk5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7872.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(71200400001)(478600001)(921005)(38100700002)(5660300002)(122000001)(6486002)(76116006)(66446008)(64756008)(66476007)(66556008)(91956017)(110136005)(66946007)(54906003)(41300700001)(8936002)(36756003)(4326008)(8676002)(316002)(7416002)(6512007)(2616005)(38070700005)(2906002)(83380400001)(82960400001)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y214OThiNFJTNWMzMmpzK3k1NWs4TUovbEN3TUpMazNmWk1hMmVzR1k4eVFL?=
 =?utf-8?B?MlBRR0kvZnFWZEtFNjc1cWR0dWFhZmNCbUpINzIwNW1NM0ZpUjE2S2xpNk44?=
 =?utf-8?B?UkYzd3MrQzNhMEQ3MUFQQkY5MmJPZzhXY3N2MkQwZ2NIcXFpK3lzRlp3Mllk?=
 =?utf-8?B?cWJYWXJoSWtaUi80emVSSjg5dkRnKzAwY00raVJrcUxJVGtER3FDYWRsUzFC?=
 =?utf-8?B?MUZnWXpjN3VaWTZ4eDNkdFQ4eGtaZzdvd3JGczJRelpYKzdra2RRblZ0aURT?=
 =?utf-8?B?RzRwMGdMVUYwVEUzWGozbitEbnhCMUs3YVMxTTVSRDNUMUFCUmN1WTdIdGds?=
 =?utf-8?B?SFdnRUNQS3p0T1hSRFg1MmR6RlFFSU9SMVN2d3VzM2tNdzdUL2RsRjFUTTlT?=
 =?utf-8?B?cjJ5ZUVzamdYalBjTWorL2QyZ3o4bjg2STRRQ1M0NTRNOVM1SlFqOGdvUWJF?=
 =?utf-8?B?dndIY2owQVREdnBXRmJxdjNtejhocHZKTzI5aUFxYSt2b3NYeE4yTURRRXRO?=
 =?utf-8?B?WllpTVhSWExNU1NVaHZOVjNhNUg3WFgvWW94ZG4yNkJ6TzlKeXF1MDRodVM3?=
 =?utf-8?B?aVZtajBNUE1nWjFvSzJvTURVZ2JwblhvNXZBbE9HWEx0blFwQ0lQdlliK3dS?=
 =?utf-8?B?WC9NRVYweS9DU1dHOTZ3cjhFemI1aW84bGZYNTFjMlNFTkpZZldnbHZtM0Rm?=
 =?utf-8?B?SGx0Ym5xNUhodGhYRXY4NTNzbC81Z1dtOG9LNFRTMWh6T0lRTnpLditCRmtv?=
 =?utf-8?B?NGJtZXZPRmZkcmIwemdkbExReXJVNVJlN2ZpK3BZZUdEVTlxVC9tRkZsek9Q?=
 =?utf-8?B?U09mVCsxb2NnQjRkUHBhNFRGME0wT3N5Ym9haUdwRWtva083V1lYZmQzeXg2?=
 =?utf-8?B?bndQZXFKSWE5cnpHNDRBYXpkOEJBb0taVWZqd3VYZml1dnBTNXZ6VC9mQS9M?=
 =?utf-8?B?SHYzSjMwc2xLdmswMHdCUWtCWnBxSktSQWJkb2k4N1pXTzNVVVp3RUZkT1dL?=
 =?utf-8?B?Wll5ZTBMdkJuNkRIZmVVd2piMXlIcCtIWU9yVkt3WU9HUU1BZXNzZ2k1NldH?=
 =?utf-8?B?MUpkc2t6STJQOE5mcTYzVkR6dEtDR08yR0w5alpydUMvbkc1SXBLelBPOENG?=
 =?utf-8?B?UkpMOGg0MkpMbW5HQk84WnJiajJndUVoM0tlSm9QSG9pQVRlc1hZWnRwcjNm?=
 =?utf-8?B?cHNKdDJ1MFh5cFlNSmN4MVR6NUFDT3g1OTdiM044OThmRUIwdU1xcHpGVy8y?=
 =?utf-8?B?RXdmMUtiL1NGRURwbDdpRVdWQWwvMG9TdWVRSFJ6WnptUnQ4MnZuemVwNmYv?=
 =?utf-8?B?K2lSMG1wd081RnAwSHdIZ0RqemFGays0L1NoN21zMjJjZVJSbWxwTWQ3TDFs?=
 =?utf-8?B?enF6QVQ1clIyRG53VVlJazNyK0JBa0JldTd4bEVkdTArSElyeCtYS2gwNHBK?=
 =?utf-8?B?S0FXSnpYeFRKeHpqeWVrS3Q4V0hNWHZVQ1NQYm1OZE1HK1d3dzRuZDgxNlRM?=
 =?utf-8?B?TVlRbldxU0VIQ1dOamRVRjBtVHZPbXlRZnJZNFdnbng1K010NGtXdjZ5M3h4?=
 =?utf-8?B?VmMvSmZ3aG1HSUdYeERtczU3NEtsNC9sSHd2VU5nSys3N1UrMmZYK3ZaQ3pp?=
 =?utf-8?B?blVLU0dUbmIrYjlBVGNvYzNHRkVFZjVIK0hqRWs0cU94N09obE1DZHozMHhD?=
 =?utf-8?B?Z0JlVlNXY1FVdEpTNFVUMDdTZVg0NFlyMkZiUEFBZ1dnWm9ZYzl2bnAyVFhQ?=
 =?utf-8?B?dHRkMDBld1FhdTRUeGlnQzNZS284ekJWcGZrSlRaWld5OEFrb3RHTkJ1VWdW?=
 =?utf-8?B?Uzg2WG50SE42WUlrL2RGNGtETWFFS3dCNzF6cWd1V0ZEOW5FNU01QUVOaGJS?=
 =?utf-8?B?NXRhMFNPNnAxMmVxbU5sMGluK1VUZEoxNkhuOXY1MDVNV25MZXozTHRrODFr?=
 =?utf-8?B?OXljTTl6S2ZIby9yc0tTdktOK0ZqSHc4VXp3VUx2NWhNb3V2d2F4Q2NIYnhS?=
 =?utf-8?B?UGk0SGVBbmdMZ051alVGay9lVGx1ZExHQUk0ZWl4dDFscklOTllDZkhKWU5E?=
 =?utf-8?B?bVZIUWpFUmhLbFlRdjFMaHBFQW5rbkVDM1Vuem9odVpmWUFRTFY5a1Vpeklj?=
 =?utf-8?B?YkJ3RFd2akFaTmoxcXVGRDMvMG9BUHhjNXMzK0RqUmVvbmQ1S0haazlaREtT?=
 =?utf-8?B?RUhjMlpZendCQWE1cFhuY3Q5T1pDS3A5c1FpTmdsVkxwN2JIRktwTzd3NUJE?=
 =?utf-8?B?L05yVmxuMktsaDYzYll0aUEvc1ZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBE3C32245016544BF264EE5440CD51F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZmJ0OWljMjI2eCtxWGdaTFE4MWcvMmtxdDZleUlxaVdnMmhjOTNuNVZTeFdh?=
 =?utf-8?B?TVdvQVdYMCtaRnJFVllaMlZPMHBVOS9IN0FSajExSVE1RkZZd1JxRERmaWo1?=
 =?utf-8?B?RlN5cVFSVVhvNFNXcVoyVTRmdFRrTEx1cVEyWTRkc3luODdVQlhJQWxQbFcx?=
 =?utf-8?B?WDMxNlVEQ3dLMTExcnAxaEptZHRXdllEUWJtVmxMUVJwYXpHNGZnNy9RNkVS?=
 =?utf-8?B?SGdvelkyWWV2bFpBSDVtR2ZqOHFjYUkxWVRTeDJ4Slc2cnpPYnJYRHpRY05P?=
 =?utf-8?B?cmM3VW9mWFdTRktmbGcyLytrLzVoWTlKdWorYkN2WWUxS09BUFczTHVTaitR?=
 =?utf-8?B?VjkxY2NyM284d2ZkbXpvc0ozZHMzSXk2dUl1eHVPUzZhTVlaZzZxK0lOLzc4?=
 =?utf-8?B?dElWSXZVN0lzdGZIamJWYWc3S0ZQV3Y3amdickJMWDUvWDEwN1JrdW9zcmJV?=
 =?utf-8?B?NXoyeEtpanJKWFJseFJnT0hXUU04YjFmdmJObng1bmNSR0hKQlBsc1A4NVkz?=
 =?utf-8?B?YlVJR2NEWGdwZEJGaFdHbzlUKzJ6aS9VS3E3L2hoSVNXRW54U3krZDJ6M0Fw?=
 =?utf-8?B?K0p0TzFNTWlXREl3SVVxRENUSm8rTi9lZjdYaTQ4WmgwUUFTUVd6RDBXZ3kz?=
 =?utf-8?B?aDdwSks0YnJ6V3dURFFBaXljNFBZeG5rWTJRRjVoOVM5Z2Y3dytVckVmUGV4?=
 =?utf-8?B?a1BVQnIxaU43K1N5Si9wejBoUzlscGtXem5QQk00WC95aTF6eXFvUFNZM0ZO?=
 =?utf-8?B?QzlNWlRaeDdFOVk4YXlNQlhZZE90UDU4bVN0dTBtdzFEWGFJbnJsVDhpZ0NF?=
 =?utf-8?B?YmlZSnhWc1VmQzloT1dOWkwrdHIzanZRelkwUSs4Z0FKSURkbi9ZRTFzWkgz?=
 =?utf-8?B?WEhLQ2dJSGdCK0QrelVMRlFMYXYxL2hlU1Y5NWtEVm44OXNtRFY4KzZVRGZk?=
 =?utf-8?B?Q1V1enM5ODZlRm1Pd1Q3K0JpVnJ5ZDhPeXZTOS8rSTJMdTR6REp6VkN3RmhK?=
 =?utf-8?B?bkxtYndTZG5nZllGR25QSWtOS1c3ZTZ4WlhhanRpajFCaHhiVWFMdW5qczVw?=
 =?utf-8?B?ckh6ZHBwWnpuaGdKRkZBalNsK29lc3JoWnJILzBzVHkwdzdjbFAyVEtBcnVU?=
 =?utf-8?B?emQ3NnVFcXIrL09hSVhXVG93OWxHN1p3K0JhZjVnOEZjYlRqTGFmMHRjdis5?=
 =?utf-8?B?K1lVa2JFMEhZSTZsMzczZjZMbWtNQ0VwZVJucDZhNVVqVXBOekIvc1FuMGlC?=
 =?utf-8?B?WmlRN2hURHMrWTY0RzlvTDJUVGFBNVVZOEtFUVlnQXZieFFYNEdZMndLMkt4?=
 =?utf-8?B?VFgxMk5QVlVUMysyOFFzWktZS0Jqa1QvWnByN3BveDdEdnRNN0M5Q0NJalJV?=
 =?utf-8?B?QXdCSU9jWlhyZ0kxSmlrZWNheklManJtNlFaQ3hpRHhnUE9aN3kxNzdqQkh3?=
 =?utf-8?B?MXcxMFlPcGxVMFFnOC9UemZwbjRwVWRFcXBwYWQydVRDMmJXMlpvei95MUJ5?=
 =?utf-8?B?Q1Y0VVlyU3Z1MlBOVG5kZmpyVVlCUS90UE8wTkVMbk0wZEE5bnRHbGZmOGR5?=
 =?utf-8?Q?xa8AfKbtbcu46EUbvhb47OtxI=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7872.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443f735c-b30a-46da-80e7-08dbcac9c9e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2023 02:20:22.7251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dWMEKhUWFnoBuZLLIfA/UsZUi4VVY17JlnhDVC3ybXYSeMtK1V6DQobOBmcORrNDbDoYJdba847glVBWfKurpaknGK/YP1aq3Mptw33q58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6365
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTI4IGF0IDE5OjMyICswMjAwLCBMdWthcyBXdW5uZXIgd3JvdGU6DQo+
IFRoZSB1cGNvbWluZyBzdXBwb3J0IGZvciBQQ0kgZGV2aWNlIGF1dGhlbnRpY2F0aW9uIHdpdGgg
Q01BLVNQRE0NCj4gKFBDSWUgcjYuMSBzZWMgNi4zMSkgcmVxdWlyZXMgcGFyc2luZyBYLjUwOSBj
ZXJ0aWZpY2F0ZXMgdXBvbg0KPiBkZXZpY2UgZW51bWVyYXRpb24sIHdoaWNoIGhhcHBlbnMgaW4g
YSBzdWJzeXNfaW5pdGNhbGwoKS4NCj4gDQo+IFBhcnNpbmcgWC41MDkgY2VydGlmaWNhdGVzIGFj
Y2Vzc2VzIHRoZSBibGFja2xpc3Qga2V5cmluZzoNCj4geDUwOV9jZXJ0X3BhcnNlKCkNCj4gwqAg
eDUwOV9nZXRfc2lnX3BhcmFtcygpDQo+IMKgwqDCoCBpc19oYXNoX2JsYWNrbGlzdGVkKCkNCj4g
wqDCoMKgwqDCoCBrZXlyaW5nX3NlYXJjaCgpDQo+IA0KPiBTbyBmYXIgdGhlIGtleXJpbmcgaXMg
Y3JlYXRlZCBtdWNoIGxhdGVyIGluIGEgZGV2aWNlX2luaXRjYWxsKCkuwqANCj4gQXZvaWQNCj4g
YSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ugb24gYWNjZXNzIHRvIHRoZSBrZXlyaW5nIGJ5IGNy
ZWF0aW5nIGl0DQo+IG9uZQ0KPiBpbml0Y2FsbCBsZXZlbCBlYXJsaWVyIHRoYW4gUENJIGRldmlj
ZSBlbnVtZXJhdGlvbiwgaS5lLiBpbiBhbg0KPiBhcmNoX2luaXRjYWxsKCkuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBMdWthcyBXdW5uZXIgPGx1a2FzQHd1bm5lci5kZT4NCg0KUmV2aWV3ZWQtYnk6
IEFsaXN0YWlyIEZyYW5jaXMgPGFsaXN0YWlyLmZyYW5jaXNAd2RjLmNvbT4NCg0KQWxpc3RhaXIN
Cg0KPiAtLS0NCj4gwqBjZXJ0cy9ibGFja2xpc3QuYyB8IDQgKystLQ0KPiDCoDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
Y2VydHMvYmxhY2tsaXN0LmMgYi9jZXJ0cy9ibGFja2xpc3QuYw0KPiBpbmRleCA2NzVkZDdhOGYw
N2EuLjM0MTg1NDE1ZDQ1MSAxMDA2NDQNCj4gLS0tIGEvY2VydHMvYmxhY2tsaXN0LmMNCj4gKysr
IGIvY2VydHMvYmxhY2tsaXN0LmMNCj4gQEAgLTMxMSw3ICszMTEsNyBAQCBzdGF0aWMgaW50IHJl
c3RyaWN0X2xpbmtfZm9yX2JsYWNrbGlzdChzdHJ1Y3Qga2V5DQo+ICpkZXN0X2tleXJpbmcsDQo+
IMKgICogSW5pdGlhbGlzZSB0aGUgYmxhY2tsaXN0DQo+IMKgICoNCj4gwqAgKiBUaGUgYmxhY2ts
aXN0X2luaXQoKSBmdW5jdGlvbiBpcyByZWdpc3RlcmVkIGFzIGFuIGluaXRjYWxsIHZpYQ0KPiAt
ICogZGV2aWNlX2luaXRjYWxsKCkuwqAgQXMgYSByZXN1bHQgaWYgdGhlIGJsYWNrbGlzdF9pbml0
KCkgZnVuY3Rpb24NCj4gZmFpbHMgZm9yDQo+ICsgKiBhcmNoX2luaXRjYWxsKCkuwqAgQXMgYSBy
ZXN1bHQgaWYgdGhlIGJsYWNrbGlzdF9pbml0KCkgZnVuY3Rpb24NCj4gZmFpbHMgZm9yDQo+IMKg
ICogYW55IHJlYXNvbiB0aGUga2VybmVsIGNvbnRpbnVlcyB0byBleGVjdXRlLsKgIFdoaWxlIGNs
ZWFubHkNCj4gcmV0dXJuaW5nIC1FTk9ERVYNCj4gwqAgKiBjb3VsZCBiZSBhY2NlcHRhYmxlIGZv
ciBzb21lIG5vbi1jcml0aWNhbCBrZXJuZWwgcGFydHMsIGlmIHRoZQ0KPiBibGFja2xpc3QNCj4g
wqAgKiBrZXlyaW5nIGZhaWxzIHRvIGxvYWQgaXQgZGVmZWF0cyB0aGUgY2VydGlmaWNhdGUva2V5
IGJhc2VkIGRlbnkNCj4gbGlzdCBmb3INCj4gQEAgLTM1Niw3ICszNTYsNyBAQCBzdGF0aWMgaW50
IF9faW5pdCBibGFja2xpc3RfaW5pdCh2b2lkKQ0KPiDCoC8qDQo+IMKgICogTXVzdCBiZSBpbml0
aWFsaXNlZCBiZWZvcmUgd2UgdHJ5IGFuZCBsb2FkIHRoZSBrZXlzIGludG8gdGhlDQo+IGtleXJp
bmcuDQo+IMKgICovDQo+IC1kZXZpY2VfaW5pdGNhbGwoYmxhY2tsaXN0X2luaXQpOw0KPiArYXJj
aF9pbml0Y2FsbChibGFja2xpc3RfaW5pdCk7DQo+IMKgDQo+IMKgI2lmZGVmIENPTkZJR19TWVNU
RU1fUkVWT0NBVElPTl9MSVNUDQo+IMKgLyoNCg0K
