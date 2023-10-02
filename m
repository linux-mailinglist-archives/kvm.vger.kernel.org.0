Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F9F7B511B
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 13:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbjJBLXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 07:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbjJBLXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 07:23:40 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93B283
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 04:23:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQOICVcddo56iysYnwbBuHyveai/qJZZOlTdtG310YeMi07H9jPZ57OefOiA5gkRpj5lV2tHTPF2i5H597gfQPeQhAoGHngmFiVL3xted2t8rm87f+I3/QV4sO/1CbRSoFOKxq6YvVepKKx6Y25xIkPGNBgnPKKQHOMQONGNyvviHs1hUs8I0haeAMrKAKBWeTNP8eyUYYHKiAHnYcCEfWkXiV/Er9FWa+jNall3lLw2vItmo+/hqrMArV82azcyh+cGasQJmSWUeMkMBEVyKm3JyaUZvC20SewiwhKiQpYFW0TR4vO1S0VZSqEZwhRkDb9t6cZ0nFq0ByOzJ5uhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqNFaWfyqri5ai6ECUgki0hYoJZHc0LuDiwUqaWXwlc=;
 b=XbqTIThFUn1AeylcMvWlbjwAF6I1vwqsMWfnCH0w01kIo1hI9rVvONthELM+7X552tvDE7f7g5vD9fKy+H5jZJvhKAPR0GkECkWG5nbLG4h65ee4UdsWz5QkrgxVa2gouz3/jacjZv06isTYDz/nIzL8IBESu3EhKNc8y17dktItxhczdFk3tz83TD2PGG7UHh10n+9dIJ8wM/ML6MM8qok6YDyyTusn8NPrB0CCCaCD0TzjBPTnLdojaReWLR1v2onISaF1u3hdih7a2HpjxqMLx0aqlMfhpFybOei49vIzzUVTzSuCUg6zIS0le1IH8b1zWJAhe48Gt/j9BZhfdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqNFaWfyqri5ai6ECUgki0hYoJZHc0LuDiwUqaWXwlc=;
 b=plX/VvDtaocgzWZaOXmI8xnnb0YwX6uyQp/3o/B8Tcu8rNQoEu8Zxbm149ut15QeEJSEWyI8cSn5ZDFjfHijYgLwgDOpBPNHhJ73qELi7H+0tFG9vpzqxyO/3cT/bWWxsWfDtgJfQL5dFw6aIInkW7L9a+DCJUl3BikKt7yJXQhuGVkChnXF6TrPvzExbrZo0tu+m4S/5vRy6tQqKQ67+YVTv006NWiSEawuMXJ1w7A2JDiSvFRjrXMs+TNI9RyeAg2uDrb2Ri7iedrx2t61sPAgRCKvDkhHFA8e5BncU0BoRlFMK98pzbk0n+U68MohGJoKdDij+9Wn/a30fYBhcw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Mon, 2 Oct
 2023 11:23:34 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199%7]) with mapi id 15.20.6838.029; Mon, 2 Oct 2023
 11:23:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAnAKqAgA9qw0A=
Date:   Mon, 2 Oct 2023 11:23:34 +0000
Message-ID: <PH0PR12MB54816D19D34358B37CD689C1DCC5A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230922114539-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230922114539-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|PH7PR12MB5830:EE_
x-ms-office365-filtering-correlation-id: 038c973b-30ea-4953-8f58-08dbc33a03db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jz0RYn4DtVMdqED5RqxyiNtRr1r24fGLTnSv/eg92/GVW8TbJ2EbivYwaVgvsYpTMj3F1EyyY5s/8oMhbXNFAs0YGsB2mMAbnsGTvlKokUGIFeZLtQR+UungbAY1hExKGJcvJVXrqftuzvtmzcj0iEluJ9jNY4aTgumH09yje1rBhDdttBnT31i63FLNg2PYypBsGy53rAP+t0AHtHroDLxBp6W5O8OoTHYG6sl4xQn4lSNeEmAWswxKJC9aqtDcGnNhwSRAqgRh5I+VTfuVB/VnuLsZT6syV86NchFha5888k8/KLfGfk58qvW/E7SFI4PPVfe69mw4gQWVnd/H+SLH8JCaZfq9TGSl812NEkRQspxupPld175ziQSv+apvBn4mv8jmAGDIpDfQqs7yGhqhrIKJH8T0puO38lpsZw1DzBT6g4b6/sh/FhF09CXb5sqweP7/XTAllbCiL+dUrNnqccsv1tgoDF8Ezifh/ZjdJN9vtVjaXy272bOOXv6KNkjYvLQKGGQmu5N1OeReDm/0w1bMt2NAdMWsQy7cpnRcFWEXiaaZ4HCXMCn9/JQtd15iqjbvlgDMpFdvaG6ExhOo7t2FAAgz24J3FR6HIrPfBVtHoz3dB9ThlDno8Nob
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(376002)(39860400002)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(7696005)(71200400001)(55016003)(6506007)(122000001)(26005)(9686003)(107886003)(86362001)(110136005)(52536014)(38100700002)(316002)(38070700005)(33656002)(83380400001)(66556008)(6636002)(54906003)(41300700001)(66476007)(66946007)(8936002)(4326008)(478600001)(66446008)(76116006)(4744005)(64756008)(8676002)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c67gs7XKDaqOcSnctAAD2fWvyygJRHpmLaFBBlPaAonWMAYItBcNtc64O1e8?=
 =?us-ascii?Q?mHy0QHuxuTGfjKutv1lyUuhjuvvuoHuqn3ooPn5s/p1lWEesV9L0HbGz0xQG?=
 =?us-ascii?Q?G2l45Xbz3D5O8ASa1hsyvkEaQMBg7enQtPb/1H1hB5TujI4JHrHtvN9aYeP4?=
 =?us-ascii?Q?iPkyyjo4p/HOV+L6zUE3xgpv/qFmPVnUODeipHv2yXmODY85lxikdJijHDZz?=
 =?us-ascii?Q?SI1pOzrnyJdIDl9C7Eqn42c9O0VAW7icbjgBfo+pyBb6Mc18VGq7P7EsNws0?=
 =?us-ascii?Q?KeBSPlAx6rL2VOtwIz28VbGZAfKIb6y7SN0TmNZyHzOVc8EBXe1kCbQcMdNI?=
 =?us-ascii?Q?YaALf6BImes1XA9o9vHiyu0+aNgZZnEHBQAsVfCsVD2ARKyHE1VqmG/d2PCb?=
 =?us-ascii?Q?9WRMFaHYf8Yp/+jyEklRJU9hVmuLG9lLRrnCgjNRIe65aGWwkZGDDOPysUX5?=
 =?us-ascii?Q?W11sjEnCYDPl59sJ66LR1E750cPfpYL1aWVsNoeIFmXC1PVikVp64MDfjQ5i?=
 =?us-ascii?Q?5glgV9DDNvl4JIVlgCm/bkXUCAQ/wMsuweRkTA/bx+3mLjigWSyd0j0MIlyh?=
 =?us-ascii?Q?wom9D2jX0zHw6yIcvRYCuNWlbXNLIN3TSGRktmIpdPBTwG11yPH/UrvqC2l3?=
 =?us-ascii?Q?xi2Zieexy8WBvm5eITkjsKvkwuSTEZVxw22CSz8pIYgcBQaY3TMbWaxBUoFV?=
 =?us-ascii?Q?QZdSnua10wDoeYVCSxCIhY4d8cW5HylVW4hxsZ3g+TlPTkfbaJxYjYVDhSZM?=
 =?us-ascii?Q?HfK2ycdDnyIX4OMvJeeo7PAL5UXgkD03evxDuo7yqxKxbUvRAETqv4FGb/Sp?=
 =?us-ascii?Q?yRu+gh//BYDnhX1i2f5Kr9u0AvoH7w7cgKGrukdVVjToP17W+mzJXIxG5kmf?=
 =?us-ascii?Q?vaxdq5IktBouuocY+ZCuzdfJ9yMR7o5RttxfxSlgeV0ultejVKLjj0iR1+Ym?=
 =?us-ascii?Q?V/1S3s/veC2oq2DpjUqfBck8VQL47wEpS4VYax94er/0//0iKkVhKAhpdc7J?=
 =?us-ascii?Q?djP3iU7ggxCgYfHbp6vS2PIDNmqTTNCqBu3Su3QVj9TeqCO6InLN6+S1IUPJ?=
 =?us-ascii?Q?LSOq9aeHnAWWFwcQHoyuOOhz0cKSvTgUXofdFeQlfLfcV3bvTJRMtGJwz753?=
 =?us-ascii?Q?TtXC9rX/EUtxkJ2TnPjYMy8ib7ZpMX0SucSPCaQBfYH4YPy79QXnFPrUKFfw?=
 =?us-ascii?Q?JjlIeWY4BtgKLBrLSVuH4U9XfQr9Z0e6am7LORi77+bGjst2f3/X8EhXND7c?=
 =?us-ascii?Q?PtUITcwVCWKN40BxpIFxSLS/LV8Jx/FJCXJyizHbhxlZ+UxgFIEdF2yR3H4T?=
 =?us-ascii?Q?A1h5BIAqTG6S2Nn63lYtkenJAmf5h2oX/ORzSa7tITNuiDt2ltWUXq2SNZaZ?=
 =?us-ascii?Q?baEGiyqJL75PawOujKPbFrOM0Lv3D5FKAnuZDWvoAO9qXc4kTxn9MAZ5bV8B?=
 =?us-ascii?Q?LKezyIhaLeZHtUtOL6mQ4WdWvrqvpZbz1dIIb0w3E4Wa4672OIr0xvCGJhnX?=
 =?us-ascii?Q?VJrmeRunl4DBdWuQCnFg3p20i1cA6XxkYAU484PX7UPHqryKdCcp9jgpz2Ah?=
 =?us-ascii?Q?ZknK/KUmj6tc6AylScc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038c973b-30ea-4953-8f58-08dbc33a03db
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2023 11:23:34.3129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jm2Hr7VqK3+7RFghsqk8c0j/eyixo2b45gIPJoo03U/1ZJHEEL1Iumzeq+upORg/dN5XRltSXrv0nnsuqRGK5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Friday, September 22, 2023 9:23 PM

> > +static int virtiovf_pci_probe(struct pci_dev *pdev,
> > +			      const struct pci_device_id *id) {
> > +	const struct vfio_device_ops *ops =3D &virtiovf_acc_vfio_pci_ops;
> > +	struct virtiovf_pci_core_device *virtvdev;
> > +	int ret;
> > +
> > +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
> > +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
>=20
> I see this is the reason you set MSIX to true. But I think it's a misunde=
rstanding -
> that true means MSIX is enabled by guest, not that it exists.

Msix check here just looks a sanity check to make sure that guest can enabl=
e msix.
The msix enable check should be in the read()/write() calls to decide which=
 AQ command to choose from,=20
i.e. to access common config or device config as written in the virtio spec=
.=20

Yishai please fix the read() write() calls to dynamically consider the offs=
et of 24/20 based on the msix enabled state.
