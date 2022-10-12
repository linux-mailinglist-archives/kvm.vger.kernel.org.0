Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4BF5FC363
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 12:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJLKEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 06:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJLKEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 06:04:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1EFB3B28;
        Wed, 12 Oct 2022 03:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VleGGQZoSKwVocpsdylPoOvBdpv8Rw9wurMqxU7sSBTRL5LjbxfE4+56LtYq4TaVkc8RjNhbCHKgK1hRpHdK0cDBOotG2LS3vjXEJTQ/mZlvqBQcBTyPX6oUBjKzSxbyZK2LxQ8bu0UgLPiDF1ovn0pu2eMjl0z7mKdbgmDr6nGahWykICNvc4WtZeFrSbZsUNVQiuvAU8qsSHucETF8+e+rNBwdCYqHKrFzqT8OLcxHEuoI7WlyClteKjYW8QHTXI60xc2OcOniPUsvcKi8Du89wabzsehZycs9THjcie45Ozguvu7dlP+CgFcr9GvnfK+HDf/OLNV+9zac8N6FDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w39JZmqHxKmWX1MIyBfkfUdJhujDJ0YnoYi2urEyh+o=;
 b=A16S2r4zeRkRaaSlNe2gfaScVU4FhWFzcWQmhGVCl62f0EigN5gsDZqTKC1gjupuBpcwst9DTk7eMCasdUYstqQP++qEPbd0fZGX2ynOfyQSbTVCWrtuF/jnRumLjUmk13Ss+6txoHw0LceQi3FTtdVGOGOk9QGqSZHX3Fkc6vDx+kNsoObTRfCoActqGD5hgdoTFyLdTnogJ5Rh4zAfdxIMgNVo8n2kBgcy8zgkCXrQ3+JgULQdfSALCr2bVQ70jfb0/TuF1WZDntURszmDMy/87lfaz2Yl81Vpv03OfJCAx9xHFBljsZ+7UeqcztSdExAELfblK4+FXoeeKL50Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w39JZmqHxKmWX1MIyBfkfUdJhujDJ0YnoYi2urEyh+o=;
 b=uCxUK/qZrP4jTsH1T0gKK32aOoMTPqBxspAZroYFodMHTiDvAi+nazGckQE6Mn8a8wEu2B07kWGnnMLkKOFVWW5pfVll113dWDSJqtCSjtzvCFlMSFKuFbTicnOII61vJ5bPpjnHNC7bOBR2lPOocEG/HZYX0OeleEO7a3+yIXQ=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by BY5PR12MB4952.namprd12.prod.outlook.com (2603:10b6:a03:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 10:04:09 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8%6]) with mapi id 15.20.5709.022; Wed, 12 Oct 2022
 10:04:09 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Marc Zyngier <maz@kernel.org>, Robin Murphy <robin.murphy@arm.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfd0JTWjzcxYd0KhDb1ncGWS4a3T9LKAgDalLHA=
Date:   Wed, 12 Oct 2022 10:04:09 +0000
Message-ID: <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com> <87h71juxuk.wl-maz@kernel.org>
In-Reply-To: <87h71juxuk.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-12T10:04:05Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=66622778-3828-4db4-8051-10a86f0f0e27;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|BY5PR12MB4952:EE_
x-ms-office365-filtering-correlation-id: 8df26784-f331-4c55-f613-08daac391b04
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WHfgiDq2mH7ZGzPktAcFJs+u7N7Jy6TCoB6JDbGmO7fuuO5GMvIEiPwO3HLtevzlavpW2r8VG3n/NMzYk+TFsHrW8ZZnPeWslo5d0pmGR/OC2w1oj9DJHleBLNq3crIl58DMFQ9Y1l8IwKeHSSe1OdJ/Z6PxGQda+kt5COy5mhrfSjem2ixE8Uem6pwU6BBi3QZgEgSUVM9gtwr5LoFKS6ceTesd5qVbTSdgvdS9dD/3nWW3QMqejSnvWt5ZF6I8rKAIL98s/ZzbA3XyDBZcQNDN8Z0XDpct1xx5IOFmJcpB89qaJsWyWxvqJ9uF50nfigiIXsAtRue2uCSXbPZjVw4GEpKZ5sbTFSm86cQkbSW3Tb7Niiso1aJcoY4fIyguzKUdSE2ocX0asicWOOfKVt1sQPf3CiWQOa3UUxMOSKP1kdgDSw3l1O8H7NY1bcOirm7LOZ3cQDx7NVasD9OjSLJWtBov2O27mJChzErsXE4jK5ju/hjn41mphTPmlRHit+lzm5F5FijAf80XddfiEPaBdzb9JhXaTshfnbERJBMOGskSET6ixNSAY1zvi4hf537L2V/nJv7clVoJg1Pbdk3clpmDIuRZ6KXWJyWyRR6omsbhVmud4O1v2DM+/mNKlrX2sHFcp9N//iWTbAQm06g1Ays5HViyLdjHx/dzvZKtZ17pQHF4kPmwADq7GIOKzsuXP+3M/q/UGhZ9WP1qnPndwLHxBNl5BK0/FGTMJs1vk514LOSHNeXijw0XZzFH7+i37WfcFxjx3n6+xbd3Ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199015)(186003)(2906002)(38070700005)(41300700001)(5660300002)(7416002)(7406005)(122000001)(38100700002)(4326008)(110136005)(55016003)(26005)(55236004)(8676002)(6506007)(7696005)(9686003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(52536014)(8936002)(54906003)(71200400001)(478600001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iKRkMh5Hcly1bcHGTB1hPzaOxzcZL3fy/uKahDzzkV9/iWCV7gfsgcnmc1gg?=
 =?us-ascii?Q?qGc80iJpsQ7wO2nc2m8QI3qgGrehUwRQTJssbFxEc1zMTy0SOsC5YlAnRm74?=
 =?us-ascii?Q?cpSgK5JynIFPp5NaLIeSGBB0eaV30A87LAqLeUqFGaWfnzeGZzfzLHlVvYKN?=
 =?us-ascii?Q?lrCeYu2tW5cEp61NY1AI0VSslMp5B6orzoOfmp7GPtX8WvGzHLcln6esPrAo?=
 =?us-ascii?Q?gYBfFxmoSYlgBThRAkZHOrf71rDr7yGLd6FnzJZ9vNT8EHlMyIWGS064a09z?=
 =?us-ascii?Q?HAp5yVc8xvblgsfLddWuh9/e1mnOD77mfqOFj+Qy4nrKgNmCSb0nKquyO2ve?=
 =?us-ascii?Q?U55dkxUKbIlbhoG0JfoRsSWz7XXiQ53fB5gpKS6yfLhOgAVX6ztZvMYtHJy+?=
 =?us-ascii?Q?h7pMvhEPoePbNPsBhKNRD5BVMRqiVxfEWCPqgP6lphnT620mLoQxNS4z7pjH?=
 =?us-ascii?Q?y+/VJV8y8OifZHpeEz4fCukx/VLsUgai8wVDeigf/p8Mjfj94enZbHc2htXB?=
 =?us-ascii?Q?StMsvlZxmGpThN5aE6HwIqxnbwBDNOCMLcahD790Y5PL7b1jaee346FWT2SA?=
 =?us-ascii?Q?ccPM2JsgVhrm8FljXAOV0oqUyuzi2EzAZcBG+nCsgm2IKZMQCnM41zYF84dP?=
 =?us-ascii?Q?c3i/Zn582WBNSg+Zu/E6TnizVs6Y2JC2d4+BLUASRWACQjtcPZdLsDVwSFWK?=
 =?us-ascii?Q?bIsDAtm1DoT44lIdnw59z4u3uEJJkm98UM52f7wMGQuxyNY/KGtr22wvdjNg?=
 =?us-ascii?Q?FIjfhw2arZOJ92AC9ZYjd61hxoEKj4G7fgomfgyngOqInJkFAuvSEhRF4tn4?=
 =?us-ascii?Q?xoSvzjDxaPDPCIj+PUoO9RxFYfb8/KDEHbzrIHVsZf8RigssNC/f7xbA7BP6?=
 =?us-ascii?Q?0zhdc+RALpGyDchuasnD1ZiySmqZPJc7m98wtTa9+qqnUfPpHyTe1OviBrRy?=
 =?us-ascii?Q?+JBvrHeUU94bcWUGM8W367otKKhYw00gFXrtxPuo3QA/U+Z2ummzm+/RhZ52?=
 =?us-ascii?Q?a6F/yDH8KrzMaiZl4Mkt86f1WSDhqVvcKY7YhipmC24NiRBGOOyq96bWjRwT?=
 =?us-ascii?Q?Jvpq2wf/WVWUTSNbtZYV6J0lTFrxEQHkOTSl8brM7US1XXT+vPRME3LR9kgu?=
 =?us-ascii?Q?T9WuwSi/h2b21J3PLry6YlnYtMTOtFMDeNAQ5TrMWITZCOXMxTmfLE2C5jy+?=
 =?us-ascii?Q?zedoVruwjEngTrVVSi9aSYyJ3QclmOHvbaJcA8K314Xp/kGnTXbiXP6JX01w?=
 =?us-ascii?Q?NVk3C7UPpjwBSdia/EkS5MzjszkvLIzxkdNUGal1oawcBMDLsRzyF9gZmmVN?=
 =?us-ascii?Q?B2C5rPTrLdsggaZ7VS94TZ/rLngWYqDMFKzdrM4hBTWBIAWMHeNfeNzYX9ga?=
 =?us-ascii?Q?B/CmJ69ENm9Cl2BcxVvMvpilRGgN73T6Jr7ygMdztVWrxcWsB+WotIqZBP9i?=
 =?us-ascii?Q?NZwqpsjMVSy7vrdWpjmA1xsezPoH34b0UWLRUD4v+W2+eKm5fyQ3/iSozqIe?=
 =?us-ascii?Q?gkzy4QyJ9Xub8AC6D9zzH4qqfpUBBkLzGh5XGMO8SmWkgimVql8WZ6DUczuR?=
 =?us-ascii?Q?f6CrU70uMiLOQI9qkFU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df26784-f331-4c55-f613-08daac391b04
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 10:04:09.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wtnDYjwSTuP/r1app/P/Ari2IhjV14ux07IdHbRX876n0WBvXCWbmsBNzrOwHMc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4952
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]


<snip>

>=20
> > +}
> > +
> > +static void cdx_msi_write_msg(struct irq_data *irq_data,
> > +                           struct msi_msg *msg)
> > +{
> > +     /*
> > +      * Do nothing as CDX devices have these pre-populated
> > +      * in the hardware itself.
> > +      */
>=20
> We talked about this in a separate thread. This is a major problem.

We discussed this further with the hardware design team and now have the
correct and complete understanding here. As the CDX devices are FPGA based,
they don't exist yet, so it would be possible to construct them in such a w=
ay
that the eventid is programable.

To make it generic for CDX devices, we have added a firmware API which prov=
ide
the mappings (MSI vector ID to eventID) to the fabric, that can be referred=
 by the
device while generating the MSI interrupt.

Also, there is an existing table to have GITS_TRANSLATOR iova address (addr=
ess in
msi_msg) for CDX devices, which can be programmed by the firmware. So, prov=
iding
IOVA address to device would also not be a problem here.

We would be rolling out RFC v4 with these changes soon.

Regards,
Nipun
