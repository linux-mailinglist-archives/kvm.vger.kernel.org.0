Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050ED5FEA3B
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 10:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJNINE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 04:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJNINB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 04:13:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04822F53CF;
        Fri, 14 Oct 2022 01:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JriHb4lpffOKqxXYs9aenpzCqBS33tqAlWl4LYg+FvC4EnRFGYCYRFLJwQy1WNqrDjIt9K4ERFN7ScvVs39srqalHYlfMFuAHg43pKozofWtu9NMuqDlPM083TTSHcANJsahkD5Td31Bla7FcwxbT4aJ6Q8MQb/Kaxk9lAlr9U98DbslxZ+oPf9XQK7cJSUIilvzGamHtUB6j3IXpFlFtiMFEOq7aWMKBw3UmA7Nnvga80pDZMohZdKQTy2X/v4ZEvE6EdqPL9AbJwxqLmJVQXuuYS6y5m7VR00fhYCjv2i10g/7jAya4o73q3WNihWL5FgPTvGhi/UZg5b2zNFeeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpM/dJhiVQ7EsAtAvBOJsWnqFJy/xOlTTnLZux7mLqs=;
 b=JGcFbIFjITtrSIc7+De8wkF0iDwNuai8V1UdBBy8bL3RyocBdMwVatO66jNuGdYd8i+rKCSrY9PYF27bzOJN9JVnW1CnjQrDxJJLfmDeNGlOkvnXZcNHis90nGHKjf+L3J1LDDk8Kx/07x8HXiKp9EtOpKBfNu84HeCF8OLLzaI89ejU6lo5mDrVxk3RBMd/APBosssOCB2fDPk75FW+A3aVCZSZqbhnpLaTdiVFzo7wrPS5QrX1aS3bV7/oBo0t4hcWiesRzVF0RRA1wwaBQ9OsBAbZW/pgwy6zFcQBA98qfcTWCTg5+WTPT567wUCXSb7fGiPS8kfGbmbi4fhjuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpM/dJhiVQ7EsAtAvBOJsWnqFJy/xOlTTnLZux7mLqs=;
 b=NHOCNoTwZxR7SCsx+9elHFFgXA5lBmivoFv3VFFn3XI4gVByUoC1MbfKz4VVRtwCCCWkHEqknKPom+sAE7C5LOVPDL8tmhDv5bishUS22ukG+K6DMh/PzDJfdh4nl49tnBHO25Yn10mjOa6eVgZ3fNcAnE/5ehcHB6KKe+B16Os=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by MN2PR12MB4568.namprd12.prod.outlook.com (2603:10b6:208:260::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 08:12:56 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8%6]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 08:12:56 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Thread-Index: AQHY34c9oJTijdnoe06lrbXMMQfUFq4NemEAgAAOr5A=
Date:   Fri, 14 Oct 2022 08:12:56 +0000
Message-ID: <DM6PR12MB3082A9D753D6A6E35C4F1FD5E8249@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-3-nipun.gupta@amd.com> <Y0kMiMVQ7gj7scoY@kroah.com>
In-Reply-To: <Y0kMiMVQ7gj7scoY@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-14T08:12:53Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=fae46e5e-99bd-4a0c-ad6c-12065faf6015;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|MN2PR12MB4568:EE_
x-ms-office365-filtering-correlation-id: 187811d3-49a2-4c98-5bcb-08daadbbe69d
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zlvvALoHjiHpswY0f9pfSsFDFwqzeDUHdjiXShPnX5CB/1srFslPuvxOLSmplLjQRr4Iwqqx1jbVMi6wXqEM9iLpguUjlgYe0/GyhomtrR4qfsd2egZkKWTmcju8q6XwKzkeNgr0SzSCGfhMPprd+C9KIKj5ehxDuQuW22NvXgrR2lNpFm41PyTwXQXSkc1zNtiHguAfdWzB2o31xTG1EzMgTew1apma2krNRV2YnMFx0SkML96s66ag+Dq6kaCQL7tp2qaIQmEpcO8uXppLEyMdX5tCR+NQ69yqoqJvnaL/pvdE3LhH0ahjim+WeRGW/3yioIzo48uZCNpxzXUXTnc0vcvdXj2DfPBhz8CdY087SqS0xhl9vR2yjYhYViHsxjFCBtezhfHgQ8533meZOMx18FHoXdcyzcdfhsdQCAMwLb4/sah1CKBIJOslLEFQi9DRVzeZMfAGrr4NrXiku4P9g9uChcBDx+SPMSzZxIUWkDJEIt9g4zyK6VFZ07NF8EnkNtm+T2AHvIkbcSqppuuPytvA3ffXycdd9DN8/S+9aOHgK04tmqKuCiBU+SO421rkCAKCKui/sbpDbfNzrJ1fiLUVfCqPekpM6/OcCxjNVPIuL+erzDuVsVzjdk1o+fJEFtMU0p1sR+tBoo/n9kk4h3gNf8h9gl9eFNNRemUWNbJRHcAVfbfGMad9eKl/f7d74yQssJ9gcs4pCpsVxE+3GIZdcJyvPB6I/89GUysDVEMATEFgcJlV/OpXbRV/gClDBb9oQ1YYySteKg27uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199015)(9686003)(478600001)(7696005)(53546011)(6506007)(38100700002)(26005)(122000001)(55016003)(86362001)(33656002)(186003)(83380400001)(52536014)(7406005)(5660300002)(7416002)(71200400001)(38070700005)(8936002)(64756008)(54906003)(76116006)(66946007)(8676002)(6916009)(4326008)(66446008)(66476007)(2906002)(41300700001)(316002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uztKdBUeaC6T8VcExLeqR62dkcCDLUl4dI87vS5FQiT5MqqQEfYxTRiGclyr?=
 =?us-ascii?Q?YfiJwxhFWtd8UXNdlyZ+++tTK4PuxjC6b9AboSbZSPbBhV7JhClKZ2VEeGjp?=
 =?us-ascii?Q?wAODUMBkhKXuhffxZ4Z46+8DU9xxao35ST6ls3liKMSfGjrUpJOmfoDqogQu?=
 =?us-ascii?Q?L9iIgH33dtOh8FkBcAT3ftzoJ+ECTdPV1mIGPGfzsE8vRaf7kCFeH94kMIkl?=
 =?us-ascii?Q?SgmmOlGexhJuY3pCnaPTwpBsCoMre7Eu0QJU4VPCQOoZ2J032KR2nzQFMriZ?=
 =?us-ascii?Q?Wr2rpXyxtm6pVWkCPAPjTRBAYwB/ATpKIqFCGntxF6LtLTdu9v7g3RH8lR/z?=
 =?us-ascii?Q?L1aANkI8iLEyLtuqyYAe/ArKJsDzWjwkKVw4lawkdWyBvI+fkQkX18q2BFID?=
 =?us-ascii?Q?TCeEQ9dGxWmNCxZkjA4/riR6OgqQ+0DUwidt3qhepwsjAfPgRF75QUJctYzL?=
 =?us-ascii?Q?w2jKvCBnADh9j4+P4IeelO5ebMLi7WoUXW8RwHfWddM2hKYHPBmWBDHToMV7?=
 =?us-ascii?Q?gEutxCGiJqugQuPRw3RhCUX+rDz1ofEu+CZCa41kTkUvXgBFE2/tuVV1SwEH?=
 =?us-ascii?Q?VUfnUYaOsQ9plrhyqgu30nxMRD/3u96aiJ8WrtppKpw5gJWDg40Pmh4tl49c?=
 =?us-ascii?Q?RG1w7bzdBCKAZQUtm13WdQAg9ZhIOEEGycsJcR45KTg+Pv8Iri5eNIrvo1Mr?=
 =?us-ascii?Q?BO8TXZ+2AJFYyouP/cBzg3lqKToSRFLoc8ifURWte8k8X0zjytowrEbOD0SJ?=
 =?us-ascii?Q?6OD06a3UG/+B5OQHAdl/SHG422gDsop/ICGHfkmDdHBu3YrksKDfNy6if5xs?=
 =?us-ascii?Q?RWkA99L1BW3Q4+7adddPEt6vqBqJ7y1c+3CO3WPs4zL4MKir+4dHC1+Sw2Cb?=
 =?us-ascii?Q?7tiH57hPujIKdd1j/YDMtTEXXL1S6tbj7zyUA1h5qHDKk3e6fehomT9rJY20?=
 =?us-ascii?Q?Lq3rLHHBzloQb1kEmG9oJErNlDm4FMg6F2+UGODicqyRrh+ZATS4AoozgcOn?=
 =?us-ascii?Q?snq7GAVgV90hFJqexZ8x4KeGxT6mkpUh67eE+aaXQrMHK1xm71CxpBUiymeM?=
 =?us-ascii?Q?DrKqT0Po4ge8eGC+IlBAGY07JhO1B1PcRteD4K3dQofpxx7Ozv9SJpGPjRIu?=
 =?us-ascii?Q?QLIwmPBv7uNi/leSCfyKS0Y/pLZQMcCC7tHeIzsTqAqmJMhgmYyMK2DjJyZo?=
 =?us-ascii?Q?wjnMlOxpnvwUk4YsDvEjxrtWEnSqxAtn0fiaOSk+oOMrR5oWDZCr+c4hgSAZ?=
 =?us-ascii?Q?D4G+hpcPL9VFn/CqFAvY7JTQ4Q2PQspX6C3I4AE8L/MM27L5Q28Ms/6rf+vv?=
 =?us-ascii?Q?xVsQKibYDRS95Tv/UxyvKqpmaq8nGaip2wO02WaY0AQVPxa4ohadhJGybPG9?=
 =?us-ascii?Q?nBE0E02Cse7rmjcM6DejrypkgJGf5Wza2Fu3LiBM/rUTbNxEXugX4npqJYdZ?=
 =?us-ascii?Q?aqSJZIyHI7qJ5b8CFexpWV8Q/Irsatu8qi9Vo6fb9TIiRrqgP7DB8G89CPhw?=
 =?us-ascii?Q?2srp2xgieGyHdxEvQnjjqzZGQ0B1Px02r9oAUAMBgTUShi40NbPQ5Kobcg5K?=
 =?us-ascii?Q?f2Xawn/0+BbKMrHvQc8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187811d3-49a2-4c98-5bcb-08daadbbe69d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 08:12:56.5283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bj9j9NIaR7kiPkBU9wgegvSce4jsC3Olcm2Q17nynYEipLgyjDpRGc18nkaWKAbj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4568
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



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, October 14, 2022 12:45 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.=
org;
> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com; will@kernel.org;
> joro@8bytes.org; masahiroy@kernel.org; ndesaulniers@google.com; linux-arm=
-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx=
)
> <git@amd.com>
> Subject: Re: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Fri, Oct 14, 2022 at 10:10:43AM +0530, Nipun Gupta wrote:
> > CDX bus supports the scanning and probing of FPGA based
> > devices. These devices are registered as CDX devices.
> >
> > The bus driver sets up the basic infrastructure and triggers
> > the cdx controller to scan the cdx devices once registered.
> >
> > CDX bus uses ops registered by the CDX controller to scan,
> > reset and write MSI message on the CDX devices.
> >
> > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
>=20
> Why is this all still "RFC"?  RFC means to me, "I don't know what to do
> here, so here's a half-baked proposal".  When you are on v4 of a RFC,
> that is a huge sign that this all isn't working at all.  Also, where is
> the questions that you still have that you need help with here?
>=20
> Also, I don't review RFC changes normally as that means the submitter
> doesn't think they are good enough to be submitted, so why would I
> review them when I have hundreds of other changes that submitters do
> think are good enough?
>=20
> Can you just submit these "for real" if they work properly for you and
> you have tested them and you would be happy if they are accepted.

We are in the process of merging the firmware support which is stubbed
in the current series. We will send out a non-RFC change in the next spin
with the integrated firmware support.

Thanks,
Nipun

>=20
> thanks,
>=20
> greg k-h
