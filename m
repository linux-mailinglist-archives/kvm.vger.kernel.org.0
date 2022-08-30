Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6045A5C7E
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 09:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiH3HHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 03:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiH3HG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 03:06:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C549CCD0;
        Tue, 30 Aug 2022 00:06:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeXDOdya/PRSfEUjdn6vjPWnHBwxnaHxdprKIb62OFTie0pEc54YIUsuYELnjZyQ/CCEFMezelm79/0/Y+BRYLduQhxcMabRbKpydbEu3/lqmeZQ5+gSsY29AXXdVaIrxFaFgFEt1ryxmKvAabSEosKBry4zNvvIYcBzr8h2CaLsnfyWx4kCJroeJ+ODtTA4tmzCHzIofflU0Pl1qMLBbXcZc1ywyggtockhjYxCMkRfczXrsuM992BQGvUuM8laAGg11h8MSXECARr/93EtLLe9eRvwLG81JSGVAfFbD5o8Kp6BK9lyN+87W/WIl9tWz/Aeq/aBkG1RRjD4VTTcug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idBgm9JG4lK3wsUBY2sQlxxOnKN+CGl8S3p2TcBLPKs=;
 b=VlwCpTx+bP5Fd0pr/88WvLdBb/srCqbBInOWV1IGDQd4sYC1hA24Buy94qBqFhQSFC6jFE/TqcbxATAKddEswF756brkAq4uFalH49DY7lbHCOsfU1E3cvAmuxvWI27YUk5x/G0ZC/O22995p3/DuwCyvrlLeda07MnMQ+OCMQrPiD4FVW+hikJMna4lC+ZVBXvgIbY4AlMzImxfNtc8eaKMQAi7xaYugkrdn3uGgWsenGdXLWpTCHdOBEqsqyf9VS8YZKj5lJNI7DAA2j5r6BBLwammWdyuYFZqpupwW61J4s9qf/bhrV/oReoQBhh+XltIXPW+YkowkKbHQRUMrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idBgm9JG4lK3wsUBY2sQlxxOnKN+CGl8S3p2TcBLPKs=;
 b=wifVC3gSqnGPZoZ9xMCOtHvsvozR8kAFGFHQeIM4brZRsVwG/je1YcwVm46psobnV5H5JB0KWpURRQHa6a9tAptamWuoVN+eTD+8q/Zip+7hA1iAqAoKZFObh6i/SeTkgNDR0SVd+2I4xqqB+cdM5WP26deEBQjArGF6jXiK45M=
Received: from MN2PR12MB3087.namprd12.prod.outlook.com (2603:10b6:208:d2::32)
 by BL0PR12MB2369.namprd12.prod.outlook.com (2603:10b6:207:40::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 30 Aug
 2022 07:06:12 +0000
Received: from MN2PR12MB3087.namprd12.prod.outlook.com
 ([fe80::c901:3c6c:b21c:7883]) by MN2PR12MB3087.namprd12.prod.outlook.com
 ([fe80::c901:3c6c:b21c:7883%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 07:06:12 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Index: AQHYskryPWbD9sL0uUGy0CZ+78RqoK2zOJuAgAeq3xCAAA5ggIACkHJAgAB+fACAAL3fAIABQH2AgAAWLYCAAMjUQIAFNimAgADvfjA=
Date:   Tue, 30 Aug 2022 07:06:12 +0000
Message-ID: <MN2PR12MB30870CE2759A9ABE652FAFD8E8799@MN2PR12MB3087.namprd12.prod.outlook.com>
References: <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
 <DM6PR12MB30824C5129A7251C589F1461E8769@DM6PR12MB3082.namprd12.prod.outlook.com>
 <Ywzb4RmbgbnQYTIl@nvidia.com>
In-Reply-To: <Ywzb4RmbgbnQYTIl@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-30T07:08:04Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=b862dc8d-0cb1-4c24-a0e4-0d5297058067;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91cc621a-88bd-4249-664b-08da8a561f4d
x-ms-traffictypediagnostic: BL0PR12MB2369:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ebn9gKoRmUwym7qlvvWim7vJvAqXs85rDp5qABFuogz/TXvmEnWIhnCMuAIPx8jHUdJE0phr09Pyvyu228XU2TxEXN8qIh8ImzElzJiP+T0CC7TReGGOZYpkZt5tvUTIok0tUNRcrkcV8RgK1PFuSOxvqK8/ILidonqTSzpKMdkxfVMHSSlvSfjWbf4BpDWA3wHXSddydHGX7ssjy858deY7UfwdTo/64yWBNVw1Klz6QTuj536/XH9kcj3QhQ7hcThLPs9CmatGPxPHgN1HfDCk+RZSPLc8q0jgCc6CRW9+1iqvTA2132uVNlM6suIKhDKFFXJBze2oTDB3lYm1rxLVO8CGQaSOtwMd5h0VxIGjMQhQzNSAtjUnHhgCcxxNKGXRlC2HyYsOmNp8H9SsHp6cPCNjvys9JQeI6evjS+yHrSgsCJGehUG7x+nEzul4iTYz4xbCvU9cq7L8CuseBZonvNNVflXS02cm8XeHI7CWIp26pODZkhG6KiyhYS54nRoTpr61YDYYa/npVw8pznXUWbcbvL4O++pJ6UoWhlmZ34s3jOE8xzt4ME0f6yLvfsT66mVyUM6u9soI6iqXz0V3FhtWirfz1AlTv9iJwAtTnKBcI4wyrz7xdax7Um183nSb+UhGRyOsCgJkW9AK2CDACfoiPF7u75YmHpbJv8PrqX1RutlwBXb5kf6ZhzA1PiMej6RV54pnqwFYG3gzeJyyYjefdWYG41T/BclMPc2qibZkTY6oMmLjV0JbIZySA6vabvUSeTYUItSHq5+MBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3087.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(9686003)(66446008)(71200400001)(4326008)(8676002)(478600001)(55016003)(38100700002)(7416002)(8936002)(5660300002)(316002)(122000001)(54906003)(6916009)(52536014)(86362001)(66476007)(76116006)(66946007)(66556008)(64756008)(38070700005)(186003)(83380400001)(6506007)(33656002)(53546011)(7696005)(2906002)(41300700001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ws1emkUxmOoob4noG0XWt0WHCHAEz8/iH5kgaPrBfBHi5GdzxtQpDp/pdkWM?=
 =?us-ascii?Q?aFLFiZo6lrLHNDPE4LvQpg/ht2JQorNxf0YJHNl3F7OhQHhNIES1xM3kC/6b?=
 =?us-ascii?Q?dk+rJeNudE4Vb1j1BCOIweZOzmyLoMX+qBNFggK+x0ZXXVmmx8CciBQVllX7?=
 =?us-ascii?Q?mF/48jeKRK1UQwtp2AzwGNSaozfgTQV3zItn2LmQ1J753gjYHlUnKGrvjMaN?=
 =?us-ascii?Q?eiXoUmHnHBcbjDz+rMS7SrM8kR+DpXGpt+EsCbJaU1xZiUlSSfarhySze54m?=
 =?us-ascii?Q?lMlAIizv+kfDQxO4wmBHAQREtBDWEBfqpaEpRmLn8aKwNZU8nhOXWH37q18L?=
 =?us-ascii?Q?TNerigrb9/RRqc5EwOMT2kCtf7j6xvGYNy+++Tm+vBYsxE5WMRIZIoJ4TKsm?=
 =?us-ascii?Q?LDRNMc13+aG7Wph9zDRqfNzCb1dcAX8KOXaAlVKWTMgOsnWCSoZ+Py/DUYfJ?=
 =?us-ascii?Q?r5KlsWkfUg8q1RVS6MLq4sqqPeGLKIhCtwnzKBMso14XeXkwEowu1cCvzrgi?=
 =?us-ascii?Q?03gKDLoESe1rmqo/kUau7lVPM6mZuuXQb0kQiOX2blSzFCR6j5WcCLg2faIb?=
 =?us-ascii?Q?5CDWAqyij4yF6Vucb9/gZmTYp5oe3uv8PARLddiw0iZnVtKcuWuLbAb5ZLGW?=
 =?us-ascii?Q?09/2oLdg+f+nS2moccefYCaISm+hVrndaifwBzpxwnxA6NA+xnPDFqIt7j7c?=
 =?us-ascii?Q?q0uaruZo9+lzX4MAlg52nEeJQfojcCTeQ4aWxsNm+hNvVJfDjZQBf5gRXUDE?=
 =?us-ascii?Q?MXOzRdpgLoOjawuROONoaZe0FIGzmv8fOhGkAu4VwE9BTx9o1jcYqdRnW85m?=
 =?us-ascii?Q?lIC8W8NHO8qUyXP8p4JQJL9kgz2qG+Fzfg4ZJH4xt1FVgNb09eUnDhbhSRN7?=
 =?us-ascii?Q?b6MAvDaAhxhxqNNPv70tl+NrU/pYlSauVq3bfO4JzEFjfKNeOeFPkonhIb5G?=
 =?us-ascii?Q?7AJipDcQ25VReQcvguilb37V3orEqUQ0Ovhii8CzL3oQJMyMqCLewR4tRNak?=
 =?us-ascii?Q?1UAb03Db0hvq+YCZcjyyz4bdrhFZlw79ucSm0KaY5ptZ9TeX9+pXEvc6vjUj?=
 =?us-ascii?Q?ZRXAoYcpc+t6/dW4YCvVf5rxuG9k4A1AAR3TSUYNzJ83eHDLCPZQ8qk06yN8?=
 =?us-ascii?Q?A7WX4YXVi9ZsMG3RHmfksjd/FyaLRmK34UoIbxxkTob9+jWQI4nS67slY64G?=
 =?us-ascii?Q?arYiYN375nmLMALWEUy1EQhKB48drGqPhPxto4ZgEmk5j+cpg2GWCPpsiFLt?=
 =?us-ascii?Q?EAAP2SFPCE1S3gTtJ4tjUfq8dc6UBNbJ5mxufeXt7H1TQBfhRJIYHUY3s98/?=
 =?us-ascii?Q?5gKBEwJcmngtQQPyhgo++RCP3yUnt7UUBJJM3oM/VXjSMvrAfd6V6R+sanle?=
 =?us-ascii?Q?dSmXunS89M4OG/15ulp39fZx/GPgHJmaL1M8R+0Qi6z6JiTokfAJK0JxQTo8?=
 =?us-ascii?Q?itYgMGBODuxHNMvluaCh2qLNp05DXTS37ASAEOuWqOV6QJ7Q13EjTdiL0tOO?=
 =?us-ascii?Q?8FRS0XpPgoK/cFTrqwwv+pfZCni1Nxz41DTcxIRX3kUofnpXrnCWf9Ry/4ay?=
 =?us-ascii?Q?ESUkOahuVfVvVLaplkA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3087.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cc621a-88bd-4249-664b-08da8a561f4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 07:06:12.3176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBgyr/QoQd/t84PIJsRTpW2F3hQV893aSX1HJUMqEzrgXegcjx+raiiBGAcQrGo/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2369
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
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, August 29, 2022 9:02 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: Robin Murphy <robin.murphy@arm.com>; Saravana Kannan
> <saravanak@google.com>; Greg KH <gregkh@linuxfoundation.org>;
> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.org;
> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org;
> maz@kernel.org; f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
>=20
> [CAUTION: External Email]
>=20
> On Mon, Aug 29, 2022 at 04:49:02AM +0000, Gupta, Nipun wrote:
>=20
> > Devices are created in FPFGA with a CDX wrapper, and CDX
> controller(firmware)
> > reads that CDX wrapper to find out new devices. Host driver then intera=
cts
> with
> > firmware to find newly discovered devices. This bus aligns with PCI
> infrastructure.
> > It happens to be an embedded interface as opposed to off-chip
> connection.
>=20
> Why do you need an FW in all of this?
>=20
> And why do you need DT at all?

We need DT to describe the CDX controller only, similar to
how PCI controller is described in DT. PCI devices are
never enumerated in DT. All children are to be dynamically
discovered.=20

Children devices do not require DT as they will be discovered
by the bus driver.

Like PCI controller talks to PCI device over PCI spec defined channel,
we need CDX controller to talk to CDX device over a custom
defined (FW managed) channel.

>=20
> It is still not clear
>=20
> Jason
