Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D281F5AD47D
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 16:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiIEOFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 10:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiIEOFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 10:05:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33161F2D9;
        Mon,  5 Sep 2022 07:05:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeBPqteXi8GidNhg/MvsT6eNeIwhLcYsX/BXyXybhozWDaBAW3J1jjQOncAPHdRk2SfH9d/9zi1aaXII4q52D20sNscDHEJ0vMXISF134ZbWdP/46zHqpO8dMi7Lx/G6ZmP1XOGKvLfy7F4Ar5IdlX7o8igqsWq8Q1WVuT7IDohF1YD7gN4mSxqV+D26TR3XmE6PK4GuY6BtbH5RnOqkqEDoIZAxu8EdIUeaLvZx+6XnMBaaZWD1R3ocpOJV7NZw/f6OR3e9tJKxaKNh9xU43r073PMHsnPZiuTSvSKpmOvkej5yjo+w7bbiJJde/61sRtzdFUUJ1XJi9mKFc0vRqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c59fmMfYgG73wfQUjMJNsEyCAoi2DfmvP3urzdWwrZ4=;
 b=TZjwKmWIAeBzRIELyscFSUBS1bQf/dr6vFImkJDtYKxJigB1X0kljxOUVNSEZnSK9epYF/v4LB7l/FzwZSYmR5m3yu/iPMYTbsbhm6jmNgLsYpseQMXyMcrceF2ezBOEDQUgGhinT3kuuX3u9wU5kPG0qvTcYBzB01z5jIcDmDnM2S2nn2bLBhg5Ldy3XpyjFd6mj4XEVlsdeOZY8kWzWfbpif+2tcWYYhUChw9q8lUtIXrU3PbpGoKDyUkiautH0LEc2emgK+V9w4u3Vp21mrMHeuYs9Wg2qHWz2O1PL51ry2BbtPtHL4TPNNP33j02TlxnwCSOyaG9lbhBbxe8pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c59fmMfYgG73wfQUjMJNsEyCAoi2DfmvP3urzdWwrZ4=;
 b=LbngVA/esBC5ABuc/gI7n2ecf23yewG8HrqisYIEkU9bEuedwBGfrafqgEaYAnzuvG3Y/cL5WTLd9fvdHawAm2UlH4imtyrm6xK6Fi7ar5aT3NGHk0qSfB5EnEJP+wGAa/XbbAArr6TuaXlewx3deppyQeeceq+NbObPE80ftfw=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM4PR12MB6592.namprd12.prod.outlook.com (2603:10b6:8:8a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.18; Mon, 5 Sep 2022 14:05:36 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.014; Mon, 5 Sep 2022
 14:05:36 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Thread-Topic: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Thread-Index: AQHYskrtUUKhcm3XXUSWCYusxie1ua20bGaAgByNxZA=
Date:   Mon, 5 Sep 2022 14:05:35 +0000
Message-ID: <DM6PR12MB308211F26296F3B816F3F005E87F9@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-2-nipun.gupta@amd.com>
 <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
In-Reply-To: <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-05T14:07:37Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=c064c1d3-c8fd-47f4-84dc-27208cf1c6c7;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0223f08-7f25-4b18-1dc3-08da8f47b47b
x-ms-traffictypediagnostic: DM4PR12MB6592:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fF1w2sH6qhwRHcAWeKe46jf9bidUWP+l8cYcY4ShekToPZyzdIEwAHDiKTdHNcORFryuHaRnCUN2GEsnG4pueJ/09ia95G78panrxWOHfzQDtIh4mOX8fsE5tcqRpe3/YZkeEZX3JDsRJfmBm4bZuGlLUcfIBl8qZaJqVZAJyhREcu6ok1KoV55MXU4gIQKhmdXY15AE2EY4HW4LWOWFe/D3kcML3qSERrxp1NljIU9JyjUnmbvxYhNqxo8GVHuBbpRRx+Ug0kEVaH1jiIkysiw/7zgnwEh9G4gLcqmxgjCiBGAl8Z1KpYmUd7U7GAl0KV5PLWu2RSrSlT55zoXCnyzQAM2tFK2KJn51Amiic3g2ntTenXrORf8OuNR4SGwjKP4TDOTIjnWpY8CM+Htpx3WPTIh39bzedqiHo4J6vCy/Vqqx6uHF//m4JLsCw2Hjc653Igbw5jEtehfK4/tVXymkBFgoDpxKDwFhravpbF/oKH7tGfYpmE0W+vMZS3XOgbV1iu2OUX+/c9wtQgNFICH2EI/BhWyeFpYC1XvdafOMTJU+Y0/qPGXcO8T6oj/qDq9wg5uJy63qPB9W1MADdfHePY+J7t9FpA94W/0Lz3bB89FPLBfZIERgFqDGDS7Z5kw3SMSnJtFNw87ywV/amehfj8ENb01j62aGDimuGjKhCOnHsgFQmxkCN4T3IShl16uGhLHSHAxV1re57rdOdTkTi/pDS/V4UcCHESapd/b3v2clEfkQA88c31d6Jd6mY4qma4oBG/rihxg3tI/UNsvebuzWLJYZlmY2m2OhRluzBxaRWNx0dyN7mPsgSpEiYeV9e/rQZ7EGYV8e/FqX0SswrOrzJUULi7n0/RDGkkU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(33656002)(83380400001)(8676002)(76116006)(66446008)(66556008)(66946007)(66476007)(4326008)(316002)(110136005)(41300700001)(64756008)(45080400002)(54906003)(26005)(86362001)(9686003)(186003)(8936002)(52536014)(7416002)(55016003)(2906002)(5660300002)(921005)(38070700005)(53546011)(38100700002)(6506007)(55236004)(71200400001)(7696005)(478600001)(966005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M7lkAz/fg6fiEI32FDwdbEzY7u6u4Z6ApEYfG3QT9ZT4ZAFQPHzFspadn2km?=
 =?us-ascii?Q?0OzKJjMITwK+nUauuRTOXqRZprCB+RnA0HuD0Z9+ja9VmUJMhJceOi24G0Q9?=
 =?us-ascii?Q?JYFXpXnBA+D2GuGU+hpi0yiFQnB8z6cSuWU6yIoUXX47LdFhggvIYrDDLWg3?=
 =?us-ascii?Q?mDq4DEEGTuSFO286PSw7nkZly8NIaEw6L7vd8vWf4wBEGE8uXoWBrQGCKwP8?=
 =?us-ascii?Q?SEDui4Llibp++P48tcpN9Yxhl2mKgzDeCyEKkSfIwuVtsdSRf8tXn81znzHc?=
 =?us-ascii?Q?C+mxLhwfTW/Aw/zwEXIkmtmxkfhnj+dvvfcFwd6DDHpoX7N5uAdyorW46lga?=
 =?us-ascii?Q?o15hto9aAT6WiUT90GDM3WGisX4QHkcgB3AFA8mIBLvlz0YhErq+kNKmQP67?=
 =?us-ascii?Q?Soh2UgxbKAjrxJ5O3Z5Sk7LuhmloO1BRqonU0R8QEUeXmqJ865iHVOAdAJr8?=
 =?us-ascii?Q?eTl7xYlWmh1EEJKzw8G2KfZR19Ev3oXgsDqaVw8F36XQw9V3RD/G75ZEyeZc?=
 =?us-ascii?Q?vNAYAOHYveW9S35wPjPno6ESKSG3FlF5MAfqgTmTLQY7DA0lwzfKFVQ44/gC?=
 =?us-ascii?Q?EDaBSaL8/7iGhiga2x3VrrcYVXGE6pzmPf4Py9f/yEKKzxOVm3xj0GgRMiMX?=
 =?us-ascii?Q?lSBFQ5jG1GGJlH6MvHk7MeOSzx7rtoDbOKct9gX1UXapNjSjtnda87vox34Q?=
 =?us-ascii?Q?vH2ZtZmE8X06jPVblSBuTAW/vKUWy4C3Hvcpd998NuNY8JFzqK7gAnSDsZrA?=
 =?us-ascii?Q?ZkdmTYXuofIlGuzOE2f4GMbdyAc1zwX3AREWXpoI8TpCshWtjEP80RCVSLSe?=
 =?us-ascii?Q?B4LWn3IpMMCFzbfzzHAXBqWjSx/hyU0TITX6JtehkZr0vURYbmFRsRzAGknT?=
 =?us-ascii?Q?kEUUAce3vX1zbbW5LkK9ldxEz9lOJATFP7cq6FxbG3kJ3Cw5M2uGURs1LhjP?=
 =?us-ascii?Q?kY4WbZxuetKHR9szqkv0Djk3z3bw+NJa8fnoJm8UtHLEc/gC80HkAFNwGczv?=
 =?us-ascii?Q?o0VD3fR1IgnemBoP9RhAk9XxMZFziQJDb15mT1IcgTAiZ7KB77+nq6XM7TyE?=
 =?us-ascii?Q?AbA/g7pKLZy0UhL2vtQJX6Rb3JpoHSo+GSBLUx14HN4SG7I16dbZBL6r4KU7?=
 =?us-ascii?Q?k3qr3bZi6stGmSF9LCX17xGwTApa13lT5z2kqoTG6yPNaLh3Y8YiC7BKIX+a?=
 =?us-ascii?Q?sGAADFniv9o/wDmWaphr1FoVODjYE7yEvovdSNcWfsSxxmukQ8qcx11jGID1?=
 =?us-ascii?Q?niU24QQXRBSvUz8W4Q0jR1XpazWnpVkRlpZ3jcCBsOzpVT6gPr3mjBhhr6zX?=
 =?us-ascii?Q?N1ogFE+s4Y39b3RVAnfknauaVPA4xsfP/bBR7APNtNdF+BqqQikPf6NsHQWi?=
 =?us-ascii?Q?bcxW2Dw/FB9QpBwc36Q8HVGg44ykK2J65Sng9wts3Cr7lhqGuLaPhp6fukHZ?=
 =?us-ascii?Q?UMf+0v9jKyNZF+VM38s2wpLfwfFP/ztEMGbOGyS06UhzkzpDCDInh4SMGtI3?=
 =?us-ascii?Q?9A1L7h+HMJlCvpRQ4DsFPVa3U8GgwuCE3ywUyvf089KD6rxWgONNItPGxRBi?=
 =?us-ascii?Q?PBpWzMB6icB8Hk/rhFQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0223f08-7f25-4b18-1dc3-08da8f47b47b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 14:05:35.9295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgII4dHaCpIg2sDhlZZPO0T38t0gPV7CKrE9jhw0CwZu0PTYECEc2kzXOrIg7FAu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6592
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
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Sent: Thursday, August 18, 2022 3:24 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> kvm@vger.kernel.org
> Cc: okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
> controller
>=20
> [CAUTION: External Email]
>=20
> On 17/08/2022 18:05, Nipun Gupta wrote:
> > This patch adds a devicetree binding documentation for CDX
> > controller.
> >
> Does not look like you tested the bindings. Please run `make
> dt_binding_check` (see
> Documentation/devicetree/bindings/writing-schema.rst for instructions).
>=20

Thanks for the detailed review. Will fix the issues observed in v3.

> > CDX bus controller dynamically detects CDX bus and the
> > devices on these bus using CDX firmware.
> >
> > Signed-off-by: Nipun Gupta <mailto:nipun.gupta@amd.com>
>=20
> Use subject perfixes matching the subsystem (git log --oneline -- ...).

Agree, will update.

>=20
> > ---
> >  .../devicetree/bindings/bus/xlnx,cdx.yaml     | 108 ++++++++++++++++++
> >  MAINTAINERS                                   |   6 +
> >  2 files changed, 114 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> > new file mode 100644
> > index 000000000000..4247a1cff3c1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
> > @@ -0,0 +1,108 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fdevice=
tree.org%2Fschemas%2Fmisc%2Fxlnx%2Ccdx.yaml%23&amp;data=3D05%7C01%7Cnipun.g=
upta%40amd.com%7C36ea349b1b464c0de27208da80ffa39e%7C3dd8961fe4884e608e11a82=
d994e183d%7C0%7C0%7C637964132708706641%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4w=
LjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;=
sdata=3D2cB6xGI3%2Brd%2BKXvvoZ7bDQvIAjIc7djKatDrJcuLJIg%3D&amp;reserved=3D0
> > +$schema:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fdevice=
tree.org%2Fmeta-schemas%2Fcore.yaml%23&amp;data=3D05%7C01%7Cnipun.gupta%40a=
md.com%7C36ea349b1b464c0de27208da80ffa39e%7C3dd8961fe4884e608e11a82d994e183=
d%7C0%7C0%7C637964132708706641%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAi=
LCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D=
DfEspCt84z77me2ShufHrL%2FK1X87p65XnbmVVr2xDrM%3D&amp;reserved=3D0
> > +
> > +title: Xilinx CDX bus controller
> > +
> > +description: |
> > +  CDX bus controller for Xilinx devices is implemented to
>=20
> You need to describe what is this CDX bus. Google says nothing...

We will be adding more Arch related details in the cover letter patch to
describe the CDX bus.

>=20
> > +  dynamically detect CDX bus and devices on these bus using the
> > +  firmware. The CDX bus manages multiple FPGA based hardware
> > +  devices, which can support network, crypto or any other specialized
> > +  type of device. These FPGA based devices can be added/modified
> > +  dynamically on run-time.
> > +
> > +  All devices on the CDX bus will have a unique streamid (for IOMMU)
> > +  and a unique device ID (for MSI) corresponding to a requestor ID
> > +  (one to one associated with the device). The streamid and deviceid
> > +  are used to configure SMMU and GIC-ITS respectively.
> > +
> > +  iommu-map property is used to define the set of stream ids
> > +  corresponding to each device and the associated IOMMU.
> > +
> > +  For generic IOMMU bindings, see:
> > +  Documentation/devicetree/bindings/iommu/iommu.txt.
>=20
> Drop sentence.

Agree

>=20
> > +
> > +  For arm-smmu binding, see:
> > +  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
>=20
> Drop sentence.

Agree

>=20
> > +
> > +  The MSI writes are accompanied by sideband data (Device ID).
> > +  The msi-map property is used to associate the devices with the
> > +  device ID as well as the associated ITS controller.
> > +
> > +  For generic MSI bindings, see:
> > +  Documentation/devicetree/bindings/interrupt-controller/msi.txt.
>=20
> Drop sentence.

Agree

>=20
> > +
> > +  For GICv3 and GIC ITS bindings, see:
> > +  Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.ya=
ml.
>=20
> Drop sentence.

Agree

>=20
> > +
> > +maintainers:
> > +  - Nipun Gupta <mailto:nipun.gupta@amd.com>
> > +  - Nikhil Agarwal <mailto:nikhil.agarwal@amd.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: "xlnx,cdxbus-controller-1.0"
>=20
> No quotes.

Agree. Will update in v3

>=20
> > +
> > +  reg:
> > +    description: |
> > +      specifies the CDX firmware region shared memory accessible by th=
e
> > +      ARM cores.
>=20
> You need to describe the items instead (e.g. maxItems:1).

Will be updating in v3

>=20
> > +
> > +  iommu-map:
> > +    description: |
> > +      Maps device Requestor ID to a stream ID and associated IOMMU. Th=
e
> > +      property is an arbitrary number of tuples of
> > +      (rid-base,iommu,streamid-base,length).
> > +
> > +      Any Requestor ID i in the interval [rid-base, rid-base + length)=
 is
> > +      associated with the listed IOMMU, with the iommu-specifier
> > +      (i - streamid-base + streamid-base).
>=20
> You need type and constraints.

Agree.

>=20
> > +
> > +  msi-map:
> > +    description:
> > +      Maps an Requestor ID to a GIC ITS and associated msi-specifier
> > +      data (device ID). The property is an arbitrary number of tuples =
of
> > +      (rid-base,gic-its,deviceid-base,length).
> > +
> > +      Any Requestor ID in the interval [rid-base, rid-base + length) i=
s
> > +      associated with the listed GIC ITS, with the msi-specifier
> > +      (i - rid-base + deviceid-base).
>=20
> You need type and constraints.
>=20
>=20
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - iommu-map
> > +  - msi-map
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    smmu@ec000000 {
> > +        compatible =3D "arm,smmu-v3";
> > +        #iommu-cells =3D <1>;
> > +        ...
>=20
> ???

Will be fixed in v3

>=20
> > +
> > +    gic@e2000000 {
> > +        compatible =3D "arm,gic-v3";
> > +        interrupt-controller;
> > +        ...
> > +        its: gic-its@e2040000 {
> > +            compatible =3D "arm,gic-v3-its";
> > +            msi-controller;
> > +            ...
> > +        }
> > +    };
> > +
> > +    cdxbus: cdxbus@@4000000 {
>=20
> Node names should be generic, so "cdx"

Would be using bus: cdxbus@4000000.
Kindly correct me if this does not seem to be correct.

Thanks,
Nipun

>=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fdevic=
etree-specification.readthedocs.io%2Fen%2Flatest%2Fchapter2-devicetree-basi=
cs.html%23generic-names-recommendation&amp;data=3D05%7C01%7Cnipun.gupta%40a=
md.com%7C36ea349b1b464c0de27208da80ffa39e%7C3dd8961fe4884e608e11a82d994e183=
d%7C0%7C0%7C637964132708706641%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAi=
LCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D=
QN8hk1CEOSmNSV5f0Z2uL4hatFrc1xYC5JBbptcCISA%3D&amp;reserved=3D0
>=20
> Drop the label.
>=20
>=20
> > +        compatible =3D "xlnx,cdxbus-controller-1.0";
> > +        reg =3D <0x00000000 0x04000000 0 0x1000>;
> > +        /* define map for RIDs 250-259 */
> > +        iommu-map =3D <250 &smmu 250 10>;
> > +        /* define msi map for RIDs 250-259 */
> > +        msi-map =3D <250 &its 250 10>;
> > +    };
> Best regards,
> Krzysztof
