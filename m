Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05F661DDB
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 05:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbjAIEcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 23:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbjAIEcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 23:32:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF32E0AB
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 20:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673237838; x=1704773838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AQQGg+C5qz60N1KF6THUVJk3ErZsbVlzPGqeBpkkLIE=;
  b=CcawUwiSRr5J1qyS0oZEa4v4VB04unClLtj4YrtQwoxox/Wg1VgQjRYC
   NQKiXUFukIVfkMNRCCAdvfHF+kwETDWHPKRv0NSOoVp1iFOABvHonXI6U
   9qJcPD18voLxFDnoLPek8zpS6nf58nPrI4iYNjNC6rwVg1KinOsT8HoNp
   TME2SNwYrEOJwj3MceARpTVEZXRO/mzr3ZKMoNmatEfRbK9kdyyUEHx06
   wTwc7kBCu+KbpOe/USDnDgzwsMWFES8xUwsmlQsT7PJp66wAKuUsZ1zN2
   M2wJO07ryEjwk0pnHM7x4jjLJIbvhKjMrL8DnD4GSO425yHUpFB3y1eY0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="385090457"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="385090457"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 20:17:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="985264998"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="985264998"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jan 2023 20:17:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 20:17:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 20:17:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 20:17:16 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 20:17:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXVkQqY6oGPSVD6fggChXBiDtB++vtOCypaVEgHWyoOmKAmRmO6xJSLaNXphw1M7/QhrSGANThAUITXuo6Bu9FitBx3Q2rWhPv0qYha7t9Py1QCaMtU+tjKmzX0XsthXGinIqfH+uQcxwX6R0j0pMeTfTJOQtFyEBaJwehTwfu96kkV9s/kK8nf2DyRMMaD2SByCqr5yDELDpDYoxhisnHmsh/sc2d9A5Lrpmu3iIe9lp7uxWS+cdqG8rAxoJTma4vvVABFqTbI2i11j7O0LwXvogn2zRnDjsLNAIwtmoOz1RrXp7BQjOwGYmel/5yF2PIJ47+zk3/DvWq57o2lahw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQQGg+C5qz60N1KF6THUVJk3ErZsbVlzPGqeBpkkLIE=;
 b=VBpmifAzd9jgFoKn2C0DBylG8zjU/5IU7Dmsf2WGZDypQ8GzoKgtY1BYk+d3RkZ4wVqEPkTC6m3hHIm6iBNwAwaLkz04bXrp6Y4SqbzebC/1srmuBvuDwv+hMB95EF5K31VllXo5y5W1NMeNbtsw0zKqALW9QVew/kVUQuGkTDxHT6Wvot7+engGxRHue+huCjBA8G2qol3dsxdSfF9yS+VTY3WDS1/sl1mRwK4DwPhluckj1HwQVeFBl2OB/P7uqNbSZZCbenZeSOCkh8T1hk7pFzv7/gcS3bPQAKVxy29DFDQTetoYOkggxPPi72Mc7NL1o/ebC3GYqRbtNVNwjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7627.namprd11.prod.outlook.com (2603:10b6:806:320::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 04:17:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 04:17:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Thread-Index: AQHZE4aUmy7KXZTQ30aApLDo71n+3a6RkGyAgAAD+ACAAAJcAIAAApsAgAQBb7A=
Date:   Mon, 9 Jan 2023 04:17:14 +0000
Message-ID: <BN9PR11MB52769A6BCF689E45DBACD0AB8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com> <Y7gxC/am09Cr885J@nvidia.com>
 <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
 <Y7g2WhrDFHpPPsaH@nvidia.com>
 <17e6b31c-1149-018b-e76f-f3c82e702144@intel.com>
In-Reply-To: <17e6b31c-1149-018b-e76f-f3c82e702144@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7627:EE_
x-ms-office365-filtering-correlation-id: 1e756c53-8e34-4c77-7050-08daf1f86333
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ng1RTubuxx7cNIv9l/WmVjZhqaBQRkY8U4HtKzf2/6NAvRj21mFIHqG3Jy6uIOD4ZDrCI7ATHX+YgiB1zhTmmaG8sxGY1QvoIYd1CsI9+HXhj+DD4elu2qjyrFAzO98njNiDhaTS0J8kGn9iIvOSqwElF8hnNhQRKYdYW7mov9XsYCwPu1nkUvzOhSBHNMsiLlhCDtjatwzIo3IkPlNQPvOYNuwnKy/cxsED4Qu5OG6tF15OFbQLlY+l+RNYsvnYi2PIt1wzY9hxyQW5CM/Mt0r2dBU5ntl/bs/gMgcdCC2OcgE5a7W/Na/Ln9oBXcu7v14ZDGSoDQ/MkhOQhEflpXmgswXB873EzEAkewnJDb1m+JF5OctBFyAYKxnoAxS+bTV7z2of7SSq6jytcXJtOKtTNkb1qSspgvMnQYuVbj55T2pQcA+u42eTx+sqJ8c/sYd7P3N9j3XZzLEYisduPob63O+N/1qVokZQnzRypXMamvYrXF4iRt7bIMGKJc1SV59eFafvsN6qz+tivY6WrS5qq948QX2xd7hLoPlYWDP/Uaq1y/yd0BPPiQzACeW5rQWPV+E2xQP7YUoAMLaNFi1fq0HhdP4X0neTrEthVG706d2R5dP6qRswyc2Voa83OHCFZ8FHtjnh+58uS9zP1x9fLRbJIDy6pYvjtdLGPub/pfiX3o2uwH1K+L2BGy7/cg/gCfqegJHZVwtoAUMDkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(41300700001)(110136005)(54906003)(316002)(4326008)(66476007)(66446008)(66556008)(8676002)(64756008)(76116006)(66946007)(8936002)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(5660300002)(52536014)(83380400001)(33656002)(7416002)(55016003)(2906002)(6506007)(71200400001)(7696005)(186003)(9686003)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?endmN1BTaE8vYTJRZ09hV2JTY2g1QTFld2VlLy9rYVk2a0VnRFg3b2JmWU9S?=
 =?utf-8?B?U2x2SmMrU1lQNXAvUmdvMVlpd3ZRSlZoZU9ZQTAyZ2dWSStHc1V3anVvQTUz?=
 =?utf-8?B?TzNxNjNWWjFLWUx1WnNhdnhBeEJzRkJTVGJlcTUwQk95ZFhnMVpyRSs4cDl6?=
 =?utf-8?B?UWlBYTVVSm05M1NHdmc3R3NLY3F5Q3F2TE9RRUVZYWRqNVVPNDZrYXpQdXh2?=
 =?utf-8?B?azF5VTRYdHg4YXlTWWZZRjBZRzdsdWE3NWV5QVQyeTFPRzFDZzk0bDhFeXE1?=
 =?utf-8?B?U3NpQ3c3bG5IOVliK2xBTG01cVlpTXRQQTBkVklrS2dRVVN5d1Jha0YwcXgr?=
 =?utf-8?B?SzIxcitPUnFPaElBcXJuR3FpRnZRSEFsVURSdU5oZUVuWG05VHZFUkY2dng3?=
 =?utf-8?B?dHdnVXZKTlFwRWxlWjhLVDY0dzA3eDZtUTFDclRaT0JZUGdnVC9HVk44QjBk?=
 =?utf-8?B?TTdXRjk4dkRKZG1YUkh1T3FwUnJ3UGNyK3FNS0h4UDQxYVVGNHZnK2JyaW9E?=
 =?utf-8?B?VDV3NDZmb04wdDBmdmVjeVpLNStUazNlSWZLNHRINGh3eS93Z2pkbWNraUpE?=
 =?utf-8?B?cWpQSllmQzh2N2JNSkVBVmwyWFVvMldqa0FTT1EwdnFGSDlYWUNzcjUwZWdr?=
 =?utf-8?B?UUkrZXY0eU9YMHV2K3ZGaCtvYzduNjNZVkNBNm1pV3ZWVGxQYVF0cGNjNGNt?=
 =?utf-8?B?MkQ0dXN3a3pSajhrVEdSaStjNklMeE42b0JvNDlvWFp6K3E3aFJHRlpOWGZu?=
 =?utf-8?B?MzJtbG9YeXIzSVVDZTl6UTllRlNXT2ZkWXhZRnlMWG1jYStSU0xyaVNpS3pi?=
 =?utf-8?B?d3lNcFF4U2xidklWTkFKeWhyRWMxc2lDeHBUUHhrMHdYT3c0c1pxemtPNkRK?=
 =?utf-8?B?WGtkUjlLQmc4cVhPcGYwcFk1akVHam9vV3NYTGY4SUFqZ3Y3d3hZMmFwSFEy?=
 =?utf-8?B?OGlYQSswVndLTGk1R0F1VHg1WTJocGZyQUlOSU5jeU9JRkh5bWx0VWdHeSs3?=
 =?utf-8?B?VU1aTm9GMVAxYk9XYm9zZXVvb0ZQNWdiK3hkSkFOVU4rc24rUk1zOGVsWFFG?=
 =?utf-8?B?U3lJSWRxaWMrcVUzQnRWcGhsQ3RBcFE2WVpUamtNQXBGUHNSQm9tSVAwd1pt?=
 =?utf-8?B?UDlkUTBjMVVZeTNBdUZQZzJLYlBoblM0U3IxK3QwNFBQbnFsZnUyUUlyL3pa?=
 =?utf-8?B?Sk9FMmtZVWhJQmJFS1o3Uk9ZNzA0b2JlOWpBVmVLZ0dsUXo4OFBhbHdKdGJa?=
 =?utf-8?B?TGpBb05BdXFuU1o1V1NzVWhZY1UwZjBvWnF4UnVYYU5vclM4U0h0Z2Jic2NG?=
 =?utf-8?B?K1FtcVhHSjRaSDlCditRazJUdTVWODBLK0E2ZkkzL0xMMnVyaVlaaG41cFdU?=
 =?utf-8?B?S3FsMll5blhiNkRCR1JmSWhkeWlwbWRnTmlnZmZjRjFpUFhPL0xINHJEcnds?=
 =?utf-8?B?N0RnS0ZYM25jdnYyQVRia2JZSElSSTU2c3IvWXBTQWlKOWhxRzc5c2I3NXNr?=
 =?utf-8?B?ZmI3WkJySGcxK1h3bGx4dEVDeFV2UnhQdTRRaDVuWi9tbk9BM2g4SjZPYVdu?=
 =?utf-8?B?cVU1TmVnVFdpeUhKSmF0Z2ZtVmk0ZFB4WEMxZVVGMU1KQWNWOExTOC9sZkYv?=
 =?utf-8?B?aUdBK2l3eWZTZGtRZmJaQ3lZbVdEZjdhREJrNGFYRTZ0b0NjeHZKRTNjeG5v?=
 =?utf-8?B?M1BBUFIxWjU3NVZYbnZuZGY5bzJPVXQyUzh1OGladlBoblk4ck9hNnpXczF3?=
 =?utf-8?B?TWI3ZFpWMno1S3dBZmM5ZXBONXRkMDFDOGNaeW16djBMYSsxRVBubkRRWTJl?=
 =?utf-8?B?eUMrN3JkTHAzdGR2SkJzbHV5WVlwMTRBd0FSUkgwelRLdExLTTVBbEw2TUxk?=
 =?utf-8?B?Q2c5ZjVjZDM0WHhybGI3MzJuMHlXbU8zVW1xemJTUXBZZUZoT1NaRDBvT2FG?=
 =?utf-8?B?SEdKcWd6SkpCUWJvUEVRcmZQUTV2SngxLy91ellteWdGLzg3aGNWZ1pTSUpm?=
 =?utf-8?B?bFcyRmYwQkQwTzhMMWlkVk1lMTN0VjBCQitsU2MvKzR0dDd2TjNuK0FkVEly?=
 =?utf-8?B?YlRaeTZpVUxNT2ZPUXdxUk1vODhpc2VGMnV4aGtaWW5iSHVNejRzOWtNZENz?=
 =?utf-8?Q?PNSexUwXIZ/wa8l++hnZgYzN+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e756c53-8e34-4c77-7050-08daf1f86333
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 04:17:14.4376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wK5jbR1MPcPf6AE4NsLCWNk0YT0I8Z+0RhEk6hmsqfS07x9UxNvWl4HUQ/ywT2rtBnCcwwLQP/1G6+ES7pmwHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBK
YW51YXJ5IDYsIDIwMjMgMTE6MDUgUE0NCj4gDQo+ID4NCj4gPiBQcm9iYWJseSBrdm0gbmVlZHMg
dG8gcHV0IGJhY2sgdGhlIFZGSU8gZmlsZSByZWZlcmVuY2Ugd2hlbiBpdHMgb3duDQo+ID4gc3Ry
dWN0IGZpbGUgY2xvc2VzLCBub3Qgd2hlbiB3aGVuIHRoZSBrdm0tPnVzZXJzX2NvdW50IHJlYWNo
ZXMgMC4NCj4gDQo+IHllcy4gU2VlbXMgbm8gbmVlZCB0byBob2xkIGRldmljZSBmaWxlIHJlZmVy
ZW5jZSB1bnRpbCBsYXMga3ZtLT51c2VyX2NvdW50Lg0KPiBBdCBsZWFzdCBubyBzdWNoIG5lZWQg
cGVyIG15IHVuZGVyc3RhbmRpbmcuDQo+IA0KDQpsb29rcyBqdXN0IHJlcGxhY2luZyAuZGVzdHJv
eSgpIHdpdGggLnJlbGVhc2UoKSBpbiBrdm1fdmZpb19vcHMuLi4NCg0KICAgICAgICAvKg0KICAg
ICAgICAgKiBEZXN0cm95IGlzIHJlc3BvbnNpYmxlIGZvciBmcmVlaW5nIGRldi4NCiAgICAgICAg
ICoNCiAgICAgICAgICogRGVzdHJveSBtYXkgYmUgY2FsbGVkIGJlZm9yZSBvciBhZnRlciBkZXN0
cnVjdG9ycyBhcmUgY2FsbGVkDQogICAgICAgICAqIG9uIGVtdWxhdGVkIEkvTyByZWdpb25zLCBk
ZXBlbmRpbmcgb24gd2hldGhlciBhIHJlZmVyZW5jZSBpcw0KICAgICAgICAgKiBoZWxkIGJ5IGEg
dmNwdSBvciBvdGhlciBrdm0gY29tcG9uZW50IHRoYXQgZ2V0cyBkZXN0cm95ZWQNCiAgICAgICAg
ICogYWZ0ZXIgdGhlIGVtdWxhdGVkIEkvTy4NCiAgICAgICAgICovDQogICAgICAgIHZvaWQgKCpk
ZXN0cm95KShzdHJ1Y3Qga3ZtX2RldmljZSAqZGV2KTsNCg0KICAgICAgICAvKg0KICAgICAgICAg
KiBSZWxlYXNlIGlzIGFuIGFsdGVybmF0aXZlIG1ldGhvZCB0byBmcmVlIHRoZSBkZXZpY2UuIEl0
IGlzDQogICAgICAgICAqIGNhbGxlZCB3aGVuIHRoZSBkZXZpY2UgZmlsZSBkZXNjcmlwdG9yIGlz
IGNsb3NlZC4gT25jZQ0KICAgICAgICAgKiByZWxlYXNlIGlzIGNhbGxlZCwgdGhlIGRlc3Ryb3kg
bWV0aG9kIHdpbGwgbm90IGJlIGNhbGxlZA0KICAgICAgICAgKiBhbnltb3JlIGFzIHRoZSBkZXZp
Y2UgaXMgcmVtb3ZlZCBmcm9tIHRoZSBkZXZpY2UgbGlzdCBvZg0KICAgICAgICAgKiB0aGUgVk0u
IGt2bS0+bG9jayBpcyBoZWxkLg0KICAgICAgICAgKi8NCiAgICAgICAgdm9pZCAoKnJlbGVhc2Up
KHN0cnVjdCBrdm1fZGV2aWNlICpkZXYpOw0K
