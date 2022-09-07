Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249EF5B0505
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 15:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiIGNS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 09:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIGNS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 09:18:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7B9786C5;
        Wed,  7 Sep 2022 06:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iS13yijLhK+g0aKemc5ZVmXkoxK72NhxncMUT8QiKiYCdyHPVDze3AIsKDzJTqPz0oVAmKYMqtVAq2ks3vM7CZxaS/DLbWBaoPU4wDEzFOArvvep7yYr5WEooPL7mcjMh1rvOervcRqLMJDk5eBymeddRAqEyvW+wl+lJgZBIdR46lBzFMOk3CTPzPNmwlunql6Sw/delXyBS/vdg67sBePhGf/CLhkdK23ttYjGc9qwxwLGdJ0qqH4BG0C1I1NnCaAKVnpngfJpHPNItH+hjoiOrUOAm++dinPDK3bMrscgEevHsiF4tDfruO0myzBKr4strdsbAX6NJSEgFPyfeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+AtMuImqSw8WpCFh4Dgxqr36LOvtP9/i9i8V6YG5Gs0=;
 b=T24WsEGWvA8+kfIRkTciDvh33P07hSEh+tuWzutRMiLeYPRFdtapV5PO9HfoOYW446HIHhElBXrdDE4d9LyATiPy/09XxIyFMzHbodRuXTaFViaamFUyJqHnJ/+gg7IGTCyvtCHYcjpNsdH+cqNIFmwxoFm18dbSDYCSut1JRR2c9SkqELYVizUXuQT9+TwYi56LArH/7ZxfLG/SaOFl+4m+TGwdgorRkmp30CG+i7sAuLfCeTNx5+UiuyhFrpV2/yK/WrmQa081IQWu/mhP6ngPUXVy9X8vZTeudNE2u2e10mShSkpkw7a/k5Z7HWqM3/ZdkbDuXnFFqmDOfmoCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AtMuImqSw8WpCFh4Dgxqr36LOvtP9/i9i8V6YG5Gs0=;
 b=ypa/nLmfMUTg20Rb5M+K/Pj1VCQgpI1AEYuwvWAKP82Vibejm08VoS2JlhBwK0ekOt7auOFDsB3aE1NrajD4LfUMX4T92H19Er3qpKtIlmcQgNnUi/r3kwNPlIu4dv9FVR9WRR6A+sz1vaT0bzN7BJZobeVfaa2o8rbvMwyZgJU=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by DM4PR12MB6326.namprd12.prod.outlook.com (2603:10b6:8:a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Wed, 7 Sep
 2022 13:18:52 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::e166:fa63:f50:5634]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::e166:fa63:f50:5634%9]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 13:18:52 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3SpZoAgAEtSgCAAADFEIAAFD2AgAAHh6A=
Date:   Wed, 7 Sep 2022 13:18:52 +0000
Message-ID: <MN2PR12MB43581495197F603E901BBACA89419@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com>  <YxeBCsA32jnwMjSj@nvidia.com>
        <87leqvv3g7.wl-maz@kernel.org>
        <MN2PR12MB4358E3CFD2E3ECECC14471F489419@MN2PR12MB4358.namprd12.prod.outlook.com>
 <87illzuzyw.wl-maz@kernel.org>
In-Reply-To: <87illzuzyw.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-07T13:18:50Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=f7863230-3444-4841-91b7-4ecbd6d2e29e;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a489df9-6fdc-45c5-ae37-08da90d3821b
x-ms-traffictypediagnostic: DM4PR12MB6326:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlp7sQDP1JJIDaNxsDUYuT/it/lEZ6E0tpXDNBvWNdmuYUuNJhMILdm/lWP8hkIgMuQr42IZKQ8plSSab31KlTPqWfvgnxHKfMzgIHxyqee2OocvTSpGfs+XwTGiVX1M/CXQZS/JGMSQmBerCRWRGOG4To1NtP4K/7y3iIRIdk9FBJsNZnWHpUbFQgr1q57IbjLPGKNfAuiNE+jn0c6xyOMngCAc8HH8i9lyFUOhVplq2PF11InYfbwvLJNIQ5ueFIdRGkss4EaPs1rGYpIt9X0rewqhKY4B0c4QRpXBI/HWwVhRAAEMVOEtlxQk6X/zKLC41wEjxX0rSh89ymFvT/vt+Vi99ekvDyZZfpj8SM+wj+Dxpb2/YBBoVcMIwTlQwRU6cCHxfhXsr0IjiCcYJqjL5f8To1fBT/phpilTeYLNKxj6AnNERZ/3cVz2ZgrtmPNI4X4Ra1rd6WvTatSNwbqlIICJCfnLLoBKdp+ce2jA/mYdSSdVu1e4/IbmN+NiRsXfCz6XGDLhLxFme2B5Le87CcI80tlMoQcaRH43VOWX9uXeNBaoyjpI/vplxGhlbd0zGC7CB9nmJ9uoU825dq3q/4W1uu8PqZeDNsjBeRGpW3LhGW7DQs/xPAGHu2yoWHkA+9sMK/Mx2RNxMTThQyHaE2mYLY6RiNbP7T3CqXZWxYpp9hihx3Nhn27rIfAKVXS9DTOJAPZ/3crxW2ylUwfKaoiqwxrJyl5bK0lCNO1b78/T39kKVOYqS7w9ICGHyCkstbszc9Y0TulhWW6IbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(4326008)(478600001)(7696005)(122000001)(53546011)(86362001)(6506007)(9686003)(2906002)(66946007)(76116006)(38100700002)(66556008)(7416002)(66446008)(64756008)(66476007)(55016003)(8676002)(5660300002)(38070700005)(6916009)(41300700001)(52536014)(71200400001)(83380400001)(54906003)(33656002)(8936002)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dxiRD95yXKJ6BY6THlHMdoiFaZmAaZkMV66cydP9uo4p8bd/242817RmqAUh?=
 =?us-ascii?Q?jaVTLwZtIymjZ3fwGOjiTjk61s93KvG41hsqjfDeAPHQmg4ttDXxFnev3omh?=
 =?us-ascii?Q?sSkdkn0UMG04U+3qt1/G02cb4w36B5uj5qm/rTOXKgpKXnlK1WdK6V41LLx5?=
 =?us-ascii?Q?sbQH6qibRwKLTblvfQ6If3xMb7FoRbPdpA6RLLBm+y5c8Mjs81OO9SBM+kXR?=
 =?us-ascii?Q?wc6vnY4w1VAq0N/eGp0Tb7JyxLOrsouuJj9XVpMzjUNBy9yTnL6ZCdB7gxXl?=
 =?us-ascii?Q?3QavMXHgq0liNV1U9cSXVgMblT3S3h7yiR0qfrK+JpiGkdVXZwx+eOP+KRtP?=
 =?us-ascii?Q?RPC6yLZa+1p1kpVF/wNXhRLysqB3AyUgyDNfE6NYockvgXRFCzSVqJaS52oJ?=
 =?us-ascii?Q?n0AUcLa6nc7VIaMZ4m0voSZSusmtaaiXJ2GqNmvV2ZLkbToCKQfS/lWNkABw?=
 =?us-ascii?Q?JoW2Mwq2RuV2yPXTSq+HkY+VaWzGz/O84UH6hiKPC7DOPg9Ya+f4Swyk4u6/?=
 =?us-ascii?Q?YNOvz3/pfvg9f4CFBVXIur3zooCU+a5J5/3b4Gpo2Fe/mVabvW1m1dYLZwsQ?=
 =?us-ascii?Q?zNRz6WiY/tmZXNZSVjxyJnpXmnYZd1YE7AZ28x++7DJxW6/RPIOAYnf7Fp8N?=
 =?us-ascii?Q?rtNmwpymn9krUHppdaNx8JODd0CU8okplAgegeOznsQXlIDdY57YD5A4lbKV?=
 =?us-ascii?Q?spH3J/pr189c0DELjreuKDwZlhdeDhdMqJXFNgOem1FWUp0cxb/cI5hJaBhI?=
 =?us-ascii?Q?OwdyKHdusITxjwBf21FXo5tOhaRLjVFpIUArU7Qpmsc1Kfa6TVe9mOVLl8ni?=
 =?us-ascii?Q?3Zh/Q3e6D6ye4gyGxi3lEQqA0FgVAyn5j/hWQOYNYk0SuRcjmxSf7Taeu0CJ?=
 =?us-ascii?Q?dRjGedaax48BwDW8xkWEpNnq0jMp0/KTua/dUH9mGYM3KZ3zfYGexvXf/X4d?=
 =?us-ascii?Q?jUbeAvCRxpAjMXJ7sjzjL3UdjWgR9zBJDYiord6L/5Hqd+aoak5mD1jLCph2?=
 =?us-ascii?Q?fcRzfmGGw6pnQ5DUMTXZRXrdGdOKoaPtF/wWN2FjrZv9JJ0DhogYKJ0unQ1s?=
 =?us-ascii?Q?VISLTy5MwpOqQqGHD3mwxIYRND43JqYyU4FGKYD9IPwQAcIFp+JeBrHB28Ws?=
 =?us-ascii?Q?XL3tx/dqnJofpEoaXcB+i7zo5YSqvWoef4O6v1KEz+byuxm30OFfE7hnja1s?=
 =?us-ascii?Q?pPTj+GyVfNpwVGn34aJYhkShTRMAzfqKIxlU3dNx9IWD/aNje3wjNIvGbZq2?=
 =?us-ascii?Q?6h13UTEvT1FbGVqp5IyHMwmp1/BbeDhiUdqWnsYPeAYPK9CL/bswYzT0OnD2?=
 =?us-ascii?Q?OTZy/XjE2o/1EvRQ0Ob1u9nWXvy/mF4y/Kb7RDdF3WyA0Kt8JO2gAFBRpiT0?=
 =?us-ascii?Q?nq4QgL/pWpi8Z1XBwQnQ8eRnYooeFaMWFsCIigbaOejmtgAfsjKgj4vABg2Q?=
 =?us-ascii?Q?h0sEjCs57F5DPr2QAwJkq4lbQ6cik2KxL4ZYc/ZgKbwm2X3Wx51tBKYC94C7?=
 =?us-ascii?Q?06GGYFNK+krAorTQ63B7mCiL/9ZqSx+bRYcCnMEHTcNRx75rW66m2f34H7t1?=
 =?us-ascii?Q?g5X2UZoXGMGYYOhJg8dlK21OiiAsuhoFiM5N9K7glzd6gDVITESsEGZakud0?=
 =?us-ascii?Q?2CA+If7dlWvLIURjV69sCu8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a489df9-6fdc-45c5-ae37-08da90d3821b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 13:18:52.1385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zKGWiy3kLvyjtmKhfHyzUdfgIA9i/g8yl24QB8eAaSaaYo8KTa5m8FdaD9ILGMHsyBNhEqNQv4EQm1SHzjDRmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: 07 September 2022 13:33
> To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>; Gupta, Nipun
> <Nipun.Gupta@amd.com>; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> robin.murphy@arm.com; will@kernel.org; joro@8bytes.org;
> masahiroy@kernel.org; ndesaulniers@google.com; linux-arm-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> [CAUTION: External Email]
>=20
> > As Marc mentions, CDX
> > MSI writes are downstream of the SMMU and, if SMMU does not provide
> > identity mapping for GITS_TRANSLATER, then we have a problem and may
> > need to allow the OS to write the address part. However, even if we
> > did, the CDX hardware is limited in that it can only take one
> > GITS_TRANSLATER register target address per system, not per CDX
> > device, nor per MSI vector.
>=20
> If the MSI generation is downstream of the SMMU, why should the SMMU
> provide a 1:1 mapping for GITS_TRANSLATER? I don't think it should provid=
e a
> mapping at all in this case. But it looks like I don't really understand =
how
> these things are placed relative to each other... :-/
>=20

Apologies, I got my streams confused. It is _upstream_ of the SMMU, it does=
 go through SMMU mapping.

> >
> > As for the data part (EventID in GIC parlance), this is always going
> > to be the CDX device-relative vector number - I believe this can't be
> > changed, it is a hardware limitation (but I need to double-check).
> > That should be OK, though, as I believe this is exactly what Linux
> > would write anyway, as each CDX device should be in its own IRQ domain
> > (i.e. have its own ITS device table).
>=20
> But that's really the worse part. You have hardcoded what is the
> *current* Linux behaviour. Things change. And baking SW behaviour into a
> piece of HW looks incredibly shortsighted...

For posterity, I'm not an RTL designer/architect, so share your sentiment t=
o a certain extent. That said, I expect the decision was not based on Linux=
 or any other SW behaviour, but because it is the most straightforward and =
least expensive way to do it. Having an EventID register for each and every=
 MSI source just so you can program it in any random order costs flops and =
all the associated complexity of extra RTL logic (think timing closure, etc=
.), so trade-offs are made. The fact that it matches current Linux behaviou=
r means we just got lucky...=20

Anyway, I'm straying off topic here, I'll check with the system architects =
if there's anything that can be done here. But I'm not feeling hopeful.

Aleksandar
