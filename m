Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4376FBAE
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 10:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbjHDIJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 04:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjHDIJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 04:09:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8C14683;
        Fri,  4 Aug 2023 01:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691136574; x=1722672574;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rui7hwr4vtpluKm5nElQkTjIG9zWw4/Y5lK8ifojerc=;
  b=jbFwHPk4yRBNKJ4vWJ0qG3KI4d8q7XDqhvw0GBJfDdaHPZjytdkiMlwZ
   MXQEhy0mkaTOP0eC5GL+vlq7reVmHymH8kcX+R0T9Pla+YRE7sdrwjRTC
   cFfikb1XrBz+lvhlkxm1I+8vvWh7m2TmXZ8gUJbT2R40y239YcF/vISzL
   cHUkz53ujMfi81vSrA2Y8JouXp85qEE1uRmFxThnmzazoOqWzDSFuur6X
   o8H7v91SBt33iF6NLjQk+FB68yHWhRffwUa1QTAJKkmsk6ejksIFZoZLm
   On0Dm28VBwAwpF7IKPKuiVMMveGzzeWYtMPZj5WgP70ILkYDPhYIJYurg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="355034867"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="355034867"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 01:09:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="795303165"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="795303165"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 04 Aug 2023 01:09:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:09:33 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:09:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 01:09:33 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 01:09:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkrS7s59yBRqFkHlkWnOUDYa2u9CIUNI4MJ7yEZv7B+gUUo5J8n4l69R1CdmCoz2QxLbtSWBOPj9WS0WLIPC8oRfxj1YH/V/fR5SKCAAchEGOu/9hx522hcnHxj+4YIs/gTVl0TLLIlyj5O4tUQ/chZyyvRvd2wMq8xgcUVYbVE1lrDlRWEbPiHT/KTOKyhR1FqQbxXSLrFSocbZwKzXfvTz35SVwc8iIjljCEPPwjhRKgFrup/ke9GJ9Sf0/PGilKUML7dfwpigTypWwCYbw+b4Y5KD05V/33fTP3EhfBSf3GPqvaBh9oDCVkH8GrsoSbcxhPSyHDCPpdPSCQghPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rui7hwr4vtpluKm5nElQkTjIG9zWw4/Y5lK8ifojerc=;
 b=DNaoJ/T4+bjy0lPWl0hPLS8K4rMEeg5NoQAg/ZHaAG1HbZYHa+U18li3q8GqZ8kAXsRsofRfzekucCu1r9uL5jbY+OO58YzZF77iL+OEUjNdCX09Hafoo1soYgNFIzbo8jyFGbpEjAtc6waksKy5WgPHJnl8pfRbLotQ3p4/bjbO1scGTf5vHopTu6Rc0XZSq3D9h94xhyi7q/amX97TLMdK2ixDT1WHLgcukt1oKBaPoqfMiekuAs8s4ROGaz5P8bfEpk/E1uM+ssqzMW9b+7utBGgL87VrkHKWkOpPU++ia6rLmMj/QsKex9nfkzpHWQdTATZRgUj+gbDLK0VOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO6PR11MB5585.namprd11.prod.outlook.com (2603:10b6:5:356::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 08:09:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 08:09:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Topic: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Index: AQHZq1WE60+8eRoGWEiwEaWea5RdA6/Z+6DA
Date:   Fri, 4 Aug 2023 08:09:28 +0000
Message-ID: <BN9PR11MB52764EE5BA68B6E47028FFE58C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-6-xin.zeng@intel.com>
In-Reply-To: <20230630131304.64243-6-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO6PR11MB5585:EE_
x-ms-office365-filtering-correlation-id: c2ef8066-c201-4385-a4d3-08db94c21fd3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SKyavhq7Cr9BzBX5ikdjoKX2N2RoU/XL60s5xaw9ht2+xCiuFELDnrkNfVXiYHX3GkuVvejz00MdDYfbo3GGGC8R+aVnDKHUQxVsXUFYNTeBIrz66beVL4LkuGXL8Poim4VWLh563XUFnXFojDfsCPGlBjMOx1nPnxRFmb2N9wqI//Mu52Lju06y3VGShsQv0Vmm2W5coEk9cf2AzPhxRb2K2BjuQgxMf1GxykWWw6+bZXgw0SB+e/UJiYgkSODNg/w3+zK1KXliQsEJ2GopxZsiOke6ip11xfOLSB2gSLPv0m+jZlU3EhjMm3zPFMyABglkdwHPo0JsUFl2RVucvfpCb/wnnsCYhzr0IV6c8WQUuAcrv8HwJY9hPtt8s/RQfRqEVzzFYU0YQMmJno9IdGCa7HzJ621VCLOGhlwRFnJd4RhCNwyU3+NdE+TZNYbClRUCmCsKWhtQhdrDiULnTY81xVkBeBUyJo3dCXe1dvtSFiROdj1noOxirUWQYoCv1LEL7Xfpz6IwpBGC4c1tCC3emJJcA3IBAEqD6bL7vvtwDcCXxO2/wpYveZzsK92Sib+D+dHx3a6MyXkzfr5ZjgQtO+If6Rfoj4cgu2krmSA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(366004)(396003)(186006)(451199021)(1800799003)(7696005)(38070700005)(9686003)(86362001)(71200400001)(55016003)(6506007)(26005)(38100700002)(122000001)(82960400001)(33656002)(66556008)(66476007)(66446008)(64756008)(66946007)(4326008)(76116006)(2906002)(4744005)(316002)(5660300002)(52536014)(41300700001)(8936002)(8676002)(478600001)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hvU4BleUuIjaTerKS/HrzBHUROLwU7Nj8lMHirjXJF/snoOHmzwL8cMasnrn?=
 =?us-ascii?Q?GgYKYuoJFr4U+yl5rMadEUYgsMJPC6COxosGMqbzI3ZDFJSuiE4ScLJse1Ff?=
 =?us-ascii?Q?kkMoVn+VWblQtlCOiTxOn1+L1+pBdJdSf2+HNNR2yqtWEqyhUH1EbfvgtgSx?=
 =?us-ascii?Q?etoJpfel9BtZbFNMBRtFAGtvWbkAOY+3XWa87AL4ObU6LxJRafr36NTFxSe/?=
 =?us-ascii?Q?U1FEyfKtGx4qSGwXS5QMBEFQkSa6koEZEBdLBJWOq443jGcwPvD3/eB+OiY4?=
 =?us-ascii?Q?5s/IWqaiZ16eWic2cGyosPaHsr9KMYBIF28UQsmn0TeJdqEWiqcxgNsLDI/Y?=
 =?us-ascii?Q?VSgwwrPjepgyBwYFKHyZEUItM0VDywfl+x0kb9JizrIzjxaOz/q3XrfU7WXm?=
 =?us-ascii?Q?UQYWoqkRJ2vmARG42aASS16/1n3yiRxp9U6Xwh+tSdijiY2rT+B+ZrWqwV2D?=
 =?us-ascii?Q?z9OCr0w6Vbb3GlWkPB4GR5xgMH4R3e8WwXYOT9NhqlzozFmEMxdZtWRMsik0?=
 =?us-ascii?Q?gyBcHNV9l+J8ZduHD/AdNMeDkMKUQsmg4T8aOUzLu6VI5g7UFTaEetkT9dT2?=
 =?us-ascii?Q?FNEu1hMzvXQFSztwvXdyHFt7V/Ru49wY5xAkUBYjAYGZsRdrSicrVINXQxex?=
 =?us-ascii?Q?hhETti7ny1sJFU3uCUO8WutZY/o5cNeGlmY2zv3HQZshMEs7zhYSK2P41q56?=
 =?us-ascii?Q?BwqsrCNaVIkFVlgpRKlu8/9Btpu7C6rWtw3lWkOf1bziUsk440JrjyuJe38l?=
 =?us-ascii?Q?a1Pq3Atg4XRq3DXxFqTcR5MYpriH1nuXU26DmQ9Zili4Yh2WdYxaQ3dJWrfG?=
 =?us-ascii?Q?mfVdPCbOAF9C/iiFaa1WnXGae34ywi6aKDaBuPISL8X6bmT3Ss04vah7UURa?=
 =?us-ascii?Q?LLpXfbBHzINRjhxG/e7jLOdFNT2SsgL2l+dbmEFjcnKabObkh3VOTd7qyxk5?=
 =?us-ascii?Q?+Exhx2V5390y0kOWwyIefPoDP23WZnPlcFVseGWKuPOnaE77cqtjrN6G9lmN?=
 =?us-ascii?Q?eNC+wcfiOfHsxhB2prj9cYR0Ei+RkK9oaRyCHH+DtaByHqRM2lozDSSwuJ4F?=
 =?us-ascii?Q?6Ha5FgI/+VeK2e91AVpzR+YE+cv50CyjqqAfX58GqJoSuONDAt10f83IYHBl?=
 =?us-ascii?Q?Z78YgjSk6+mkGXeoJtTIUAvdrGvxWaiupGX3pu8f0LxLjVOxC4/MJRFh6Q8T?=
 =?us-ascii?Q?/iD6xoMxvL0R/YwgCIF4VA0ZLOyCma9VBVvIt5DbD1XSUOiQluNdwtx10I16?=
 =?us-ascii?Q?zOPWdKZCoMzHPP4Fm2c+vdeeJgjEDUaqaRNm25NmupLVGrU4RyHAugUIgcFm?=
 =?us-ascii?Q?m1ZWvHg5iWtfKkccw0sPrjeD/UVSDAQkboN8sDcKFSCa2Q+pfaczKxESDO9P?=
 =?us-ascii?Q?ofQLP8uVKVrmRN+hABxj2BHcKGFhMt8hxLBRr/h9n2tdzaDcRrtD2bD7Y/Ch?=
 =?us-ascii?Q?8ACbNzHyfeJ5TJGDdLBmpOurPCTOTqQSRKjmLW3VAS0dlZQXH0+cLQzwlJxY?=
 =?us-ascii?Q?9eISGecmeCkyugQJDJqXL+U0ry7b696BYcQbSW8DVHPjJP5RIsbJbKLt0dQS?=
 =?us-ascii?Q?UScKPlquTOxEmudW4Ehl10I2eFW/grvWw7M9hX6O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ef8066-c201-4385-a4d3-08db94c21fd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 08:09:28.1103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e2zeIlBdBWZ/HS7iRlS44Gk1ysXLlwA/WRL5hXzU50EBdlOzo/mVfIkp+vM6j3MqjB4jHyO1rXCy8qVOcYvLEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5585
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Xin Zeng <xin.zeng@intel.com>
> Sent: Friday, June 30, 2023 9:13 PM
>=20
> Add vfio pci driver for Intel QAT VF devices.
>=20
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
>=20

this lacks of P2P support and .err_handler.=20

