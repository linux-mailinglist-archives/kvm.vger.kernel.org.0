Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6651400E
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353884AbiD2BOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343714AbiD2BOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:14:52 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DF336300;
        Thu, 28 Apr 2022 18:11:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XR6gj0qJrK6keZixNdxNcD0tA17skbIQffdjT1DYwuPNNLFyxo+G4YQheWpEFtkL82Yque8lJoViVOPHnri0K/jd4SyGHGfkLijL76Gdrvd87aJHKvf7hi6C7x+ipTSGbiU/R4B2r9Bfw+UDsWGEMAGoMXNLfjZumlArI9Ohv8cNGabVKntkhL8PdLxfKrS0z5LjlzZlD4KmKP+a/V6h5M4Kb68wkPAP+PwPZFaECKDGvbqQp4or/ZUEr4s0f0MqLV5ulnjMc1FSjvHjrdh2Lc1F6AqT5JydB+s7sSBPJt3dqt/VJd6xkwVExOCwpcpnf0+gMFJf7PMjWXBmSWD18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+G+yoTaJxxYaXCOajdNh8GN4abo6IhHLKfS5ghOvn2E=;
 b=ZN2uyT4hEcYYowy3PkIhAtqrVR+Nf3zQAv+KdY4jkhCfJjm66xN1kp/o38jR0OAFej09kDv6ZwdsM95ceoDtuUPBVo1OVqJyGrLejASZzlBFHhlWk9/3FChYQnPtxDqGVHqzuOKl7nH0Ms22K9MCSThe9RuelU9X4KZdTiIrqmuv2HA/459fh5Tm1UJ80iba9iqUJfX3VK6XcvtBlLdMo2rnSMwXigr87XIAun0yI0qShHX65FroQDRv2IE0DuTmIj3wntiVW4II1CWpdIj3Etb0oglSvOyp5iduET6160fBmCwSDLKBrEBTZ4EeLYPAi++JxfNLwAkTV1EM3XToDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+G+yoTaJxxYaXCOajdNh8GN4abo6IhHLKfS5ghOvn2E=;
 b=b9uXEunWGmz74y5AApbiVpC0coXauLGQ3TqUg5Al8IDHMhrNYs+qfe9Jxm901wXEjqRIw99luFCxsBi9mM7psWTvDB9xd3rXtVq0gESZBVDSyTDoqYSMM3RqLeK7MDz0hWLflpKbi9ZFDVxXsLrolujKaa4mCSw3vrfVuBeR62U=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1967.namprd21.prod.outlook.com (2603:10b6:a03:29e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6; Fri, 29 Apr
 2022 01:11:29 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2823:3bd7:8a28:4203]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::2823:3bd7:8a28:4203%7]) with mapi id 15.20.5227.004; Fri, 29 Apr 2022
 01:11:29 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jake Oshins <jakeo@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to
 reduce VM boot time
Thread-Topic: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to
 reduce VM boot time
Thread-Index: AQHYWZvqMSeNB9FR00eBGiDkKFjxX60CjztggAMlSICAAAGe8IAAXyhA
Date:   Fri, 29 Apr 2022 01:11:29 +0000
Message-ID: <BYAPR21MB12709F42ED7C2496D366792EBFFC9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
 <20220428191213.GA36573@bhelgaas>
 <SN4PR2101MB08786192CE6DFC3450BEC571ABFD9@SN4PR2101MB0878.namprd21.prod.outlook.com>
In-Reply-To: <SN4PR2101MB08786192CE6DFC3450BEC571ABFD9@SN4PR2101MB0878.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dd106178-eb74-40c5-95f5-d84ebf71c7f0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-28T19:17:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4ae4cea-a403-4d03-91f8-08da297d30c2
x-ms-traffictypediagnostic: SJ0PR21MB1967:EE_
x-microsoft-antispam-prvs: <SJ0PR21MB1967481427B637D3FB7EE86DBFFC9@SJ0PR21MB1967.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VdPWTNs1OBt8E9JOWT3Qi631gnSv2UdDvaI/ouRzWClCtSfiNOe02hNMeOvD/hgabogVKs8v6lcWBz5LpIbcj94BOi7YlVbotDEbKV1E8sjHzrMFvKXITB5Dez+Q8+hnTghzCDTX/W6pV/ICrFGph4F0eoelcAcih3tAC0kGkbYELLOrLvYgF6p/odOQe/pZin2NZn5Vikqgu4VeJAt7EUNxCvHOtWSgILKZILSsegwEpGMpFGmS8L2JdtdRq8RQqT5xxXUOuzGNK9B65Ng8/nmEerWhpLgReez/MsMllTexzszapg9Xu/MOdg/OeIu+pACUipI82kawfUWC9edh61/XEu6unZFFEbYsO+oMrvUSKrUDROetJZ5sO7S3/b8aZ7pYxkZhwzt45xWWIeb+ev2G21V/kM1gnthwUpBWxRWHElwUcIoEMCdWB9VWNcl0IUqXV/JenCkusbn35KpNfwHsMKDTMbFCQoKy5q6XdWl1BgifMfgomGauIT6gbI1bapJOooajFI8CMoJ7isr2q4Ipwj8FO7QtlSTqB2M/zkuoIgN3Vg4gbL5sCrrXl8Rc6qoZd0I+07cXHUYbvFeGg2KFUeNm2iqZs9cGIYKaFaz7fQ6QFmJnP+9gpqqFy9mzuEr6eDCLy8o84U4Xh4YSW5NXb7sfEpKYYk/wwvyGpIGJvvEL8pBuhMD7BxPJyqGRdDguB1gmJZcLJWfX0o2QRdBg82FMeCSvnRDhrXj4mH9SYctj5fHDI09gyBObQ4Qj5z34MjStEtZ5RRIuW9LwQGKHOkJky7fsEv+gGyhT45/3Pajh4h3bFH5Plc4k3Q72dW82oTHrNzQGtA2rBxWS/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(4326008)(38070700005)(86362001)(122000001)(76116006)(66946007)(38100700002)(71200400001)(8936002)(55016003)(7416002)(52536014)(8990500004)(5660300002)(4744005)(2906002)(186003)(33656002)(8676002)(66556008)(66476007)(64756008)(66446008)(966005)(110136005)(6506007)(7696005)(9686003)(316002)(54906003)(508600001)(26005)(10290500003)(82950400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0pVIHjfjdSOnN4kK2WjGUOgT/cQ2LqkD186/UOp7TuQZ2eiGur8nvC4uUJGZ?=
 =?us-ascii?Q?FbzHbh2/tyjPwkYNDMA0zmcKmGBbuRL4L+LHtn7alSN2uG84JvsaYH6Bo7pm?=
 =?us-ascii?Q?69oszfo/PiFrkZmVsc5ZlCzPIaZPNEMsT20xTXcLgKkvJY35QCARhgJB6Tx0?=
 =?us-ascii?Q?zC7SfUvznbRr+LQ9iif8UPYvkC2GNv2JBvOIr8T9K9NrgomOuaoScy4scJAS?=
 =?us-ascii?Q?fx4EA+fOIBMTQrEbI9bBb9RBpG87x+y7i4IljLQN6A0heuPFD7aSniGkbQZa?=
 =?us-ascii?Q?LfzemmiMD2vHC1BDmYSojbAY7KwbufkaRHLEJZnO3cPwrvGK5IWEr/unjtoj?=
 =?us-ascii?Q?5/pM1QBu/PnFtq2qmfXpAeZwcBMGUxXscncbe0JpqIRsaRVtjEgt74BrAt9O?=
 =?us-ascii?Q?bjvYrseCFMVLB9g7/3DeNKJ9NZs3Kg2qFNEElzcWc4DyO3mmim+3s7IzQK6S?=
 =?us-ascii?Q?0sEFI5E6L8bGADQ5gZkjE7BpaZ8jV8zkE7le/z0XfaDbkxdBlS1JD06MouIj?=
 =?us-ascii?Q?CtKilw4y4psdnvKzn7QZNE7Ou69JLS5sKcxil4qzQmUpUHXMhIKsLgNosd+v?=
 =?us-ascii?Q?utpovNR/mTDwVYWke0ArV4ckgVV3t3LKEP5Cd8HcitzqnoYlOma29hfkYIsD?=
 =?us-ascii?Q?ZjMAhPGhndkGoyuiMRdCIIcEnyFhq5/SwrkH6GiJ6tGfOJMf4wcjjIkKxQIE?=
 =?us-ascii?Q?RBt+FkpApaKAcYOeUieCEo8jatbU+qiIS2D3cllh4KDjF+6sG4j2qAqZC56F?=
 =?us-ascii?Q?MbWwHCkI+ZT/+QcL2NeRasOPjuDmDNia9WSme42gffEHLP1LbmWwQDwE33hY?=
 =?us-ascii?Q?89j6QEiiavas6Q5rqn8NFL+3AFq3SuF6EMBI/yMzW6MGAFG8OZgmY/9NZIX8?=
 =?us-ascii?Q?433OpDIItXktGEPZvQjiF3XSG1HqeCZdLlg0oe0YzKlF0Ina6ddVDKBMdBvZ?=
 =?us-ascii?Q?XZ7uOhrwL7DnadqxNYz0Sa22gk0Ppe2gtcaYRCuwJ8RHrcOVUNoEtFcF0udR?=
 =?us-ascii?Q?PrvkuOEMZ5mM+SjVaNY9dcAkEYM0W1Oy02ss5PTEMEXeTSJ+cfR+Q3liaSyV?=
 =?us-ascii?Q?NR/tFdFFL30C13UHWnZ8rywZqE1rw+ehEtJmjdFvI3R1M/kumUnw7/DbuRdZ?=
 =?us-ascii?Q?Tr/gvAOao3jxyTuaQTUsVQpMgJzIA6kb8bbbON9Rdjy2qYhXr/BKATzqu8d2?=
 =?us-ascii?Q?HkUbpRrJnXY8KG/o5oVZp6lnnfpJxGP+JDv59yhsWuHaB5jkyFZDV8+cBDv4?=
 =?us-ascii?Q?wwTIsfUfEvtvwWf3YUXpLHg9xr0XrCwVbNjlNNUUo2VP3snknr3a3SocRtHC?=
 =?us-ascii?Q?bpIGM6IuJSM87UXu7NVYReKSRN2PqhXF0F7jxHAdUaBWxsQr3Kj23jcDAI5V?=
 =?us-ascii?Q?ttW/PIaaYpGKabUxlHK5nJ5tWqkdxCvhVsgJp2H4sa0NSPhfx9J0O8zUi8fM?=
 =?us-ascii?Q?IY4M4UWTGRuRDj9faenYQT5RXW8bWTwttYKwdtst/uOgB7zWU4iipsbZ2Cnz?=
 =?us-ascii?Q?h0lrieEXoSLP6rHAkppq05OxJxXmSJCQyKY8Us39VcS8xeqKxa4gzlPhGdDw?=
 =?us-ascii?Q?Rif1vqRCuSWgngBzoO3XkUKBO3Uyyb1X3DcnC2nnm1/djmnvZ7l5/SmzqbwC?=
 =?us-ascii?Q?EzUm7JsD3SX5onRdh2Ochhv9So3guL8Bm/p/W3UEDcztv5wncmG5B+WVmuRb?=
 =?us-ascii?Q?KnEgb7IVkVu3uMum5tgHTUk4PNilgh9M+FoP5QRBcxyuLp6OLMspGraV6nMw?=
 =?us-ascii?Q?fPkfp/gb/Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ae4cea-a403-4d03-91f8-08da297d30c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 01:11:29.1705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68KXXvO/23xKFOHKyBXzTnzBg9jLewehlDt86KBLWzHkpo2VGrNPQAK9/C/pb86BFHOnqHm6Wqi17Fo1mpE7cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1967
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jake Oshins <jakeo@microsoft.com>
> Sent: Thursday, April 28, 2022 12:21 PM
> ...=20
> Thanks everybody for responding to my questions.
>=20
> Bjorn, from your response, it sounds like this change is safe until some =
possible
> future which new functionality is introduced for rebalancing resources.
>=20
> Dexuan, I don't have any further objection to the patch.
>=20
> -- Jake Oshins

Thank all for the informative discussion!!

@Bjorn, Lorenzo: can this patch go through the hyperv tree?
I see some recent pci-hyperv commits in the hyperv tree:
https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git
