Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D959C069
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 15:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiHVNXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 09:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiHVNVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 09:21:53 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016112657C;
        Mon, 22 Aug 2022 06:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEAkSRvRnNV0zveiUFv5639XPTJtil7obt1UPb+5rITK9q3Cxs+c4O42RJkA4EamyPdUEemTqFKUKTct9IrcWvR2nQWRVVCwJnnekdtb2rDduySOMT3cd9la3v+lzfeWixZPvvbTkehScbxYnUO+rI/V40QGX6q+nQruPdHgojXf48bB7e5ojJZfwj2juo5iP/RwvR+9kbfdYPKcJlgb+UvbvFvzN45gS4nQLu4pjDehwnWEQoUWNqdoLmYqAF9zGImG5oVIliLYPcK6qLY3dlqjaLPFMYAIUWN1fOJil2HDGNWLTj3YNPlHK/pm7WxeizQcr9lnnXMqmZ287rCe0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zo/Ryl4S263vVtYyf0vrMilsYTnQgSQVXgdZFvMZfYg=;
 b=eao2oA5QRr2wioqiB0g7nKRpmrIP3YyasvoWnDoleTPsqM0nKqbnHpHIMtIy5VUfdg067vS7j9585Sr/eaN0MPMCe+F+PTVslzq3MkVXaW+mwL/7d2cs2bRuafwMY0hxsChpvqzd1FghijKlH/M1ufQ9gjR96qOqMptzy9mCec53lfwvsbaRfYW1tvPeYFFEvHgeQ/EfMgrFgHjJNBN20gYBhwMlZAlEn6mYz6CANtxxUt7SgycXpZ3/znk3dvOZURWvdI3Wmju3hw9bD+MeUGtup75xt4Yr7nZYlTaAPmCBdZDoW9goq+uSBob+jb5dlMP4bKOc1ZumDWVZgGYnSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo/Ryl4S263vVtYyf0vrMilsYTnQgSQVXgdZFvMZfYg=;
 b=g/rQxxSm4by14vVlibhDZYTpC1kD8ffinKEBunGV5KIJ1oLBAqnIkVAKEwo5589Er4GJn4wTZjg3oJdzqONC23kvTV4O82v7HIPZ4eNkqugI3/cGtzrPqYo7XKRIkUDE59+WC8XMG5vkzK2a8Dpy+1EWgPR2CCX1BOVki2crG6I=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 13:21:47 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::1db9:484f:882c:1725]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::1db9:484f:882c:1725%3]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 13:21:47 +0000
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
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Topic: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Thread-Index: AQHYskryPWbD9sL0uUGy0CZ+78RqoK2zOJuAgAeq3xA=
Date:   Mon, 22 Aug 2022 13:21:47 +0000
Message-ID: <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com> <Yv0KHROjESUI59Pd@kroah.com>
In-Reply-To: <Yv0KHROjESUI59Pd@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-22T13:23:28Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=5e8ac026-2f57-4668-a08f-7c0165c4d6c1;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7758024c-3ef0-4062-e773-08da8441441c
x-ms-traffictypediagnostic: CY4PR12MB1607:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8gRb1VTGBuelt7Mn/JksGXEpEcBlDCaeJ2XI9ryllsy39Xvwg4jSpTrubHDGCF4v0uPE28GDgpmILjO8q3182q0M5YBKKm9EI92dXJj0OJt0Ny9qeLeDpluUWpakE3hMSusZZai/e2UsqN/DOEIyah/m5sLCASb5GDAl8+3h9xj1fDE8WGh/4MmcHD1g6QpTEkbxnR5T2lsxHqnFxDMkuCd59Xs1kulB32+0vT9vhvYvkW8alkKUFDAyEepNBHsuEptx1GBF1VGQwx9CubVMVSPmgCoKD63w7QjJUa1UBX++HhZ5IQWQfS1+dmEXHLy6NghOvQDWpyQGg61Xgvq2OJcOMCsy7WK0DOwszaMnq1gXiUzdLp4qevBxEJBrE6Uxyz5YQ9eI5ADqR7ZjTJb8A5MbAPTjnzEDjgR/wyiumTscMrKvTOmV3jIPbIcZqtrScVuZ/s1wy7dQ6DQmx0FT46TzxegKLlqalENpPfGKFb29i9eRczAV4h8uFi9JUW7gCPDNwyL34ZuVxWF9UyrXOjSKzuwJ4zf1SFATgpRoR+zCcJQ4Pbhd6Fn5uk5WcHL8mv31N7P9ZoRzZ2/OSf+jPHYvLDQ6xZ4+jyPlgF2Rr2YrG9S3KIRbgMQ4uNiv3VkD8YVCsg2n5ePZnTjUTmPGKQs42Z1niWwIBvV9RGgrjKrSwjLZIfILrYrl6phvyyqagD7YsoAJZkoPRrmEt0YCcNax0Vr/7PDd0qkGTY52lNbfsW61iSVWotig4tgQEvsryXrX39mK/BSgRrbc0/nGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(7696005)(38100700002)(38070700005)(122000001)(53546011)(66946007)(66556008)(478600001)(9686003)(76116006)(26005)(66476007)(66446008)(64756008)(8676002)(4326008)(86362001)(316002)(41300700001)(6506007)(55016003)(54906003)(6916009)(186003)(7416002)(71200400001)(5660300002)(8936002)(52536014)(83380400001)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PY3l4UDwRh7SqoaVUIr2b9J9hp8cuDjXeAxGoqPTi48CvRfVXucPNC7bR12i?=
 =?us-ascii?Q?WKqiYPQsUpOLTAwRQ3y4DAY72JML0GZAtuCe+j93m/vKCODc+Ag2dBj+9N57?=
 =?us-ascii?Q?UMqtuSgCGlLTqskUJ2EAi4/mzTB2W49PG7xzHW82sSTgj1C57rvYwbLAjycg?=
 =?us-ascii?Q?QkTwxTjbgXQHaSc9qBl/GJ6lFFFfq/vebhRHu3SUfJtp8kTpuU4zvgOJOrzo?=
 =?us-ascii?Q?4Psx/jxca1BM03b8a3CCj76DyifslaHa1H0XjgP4G5vpYMf16Oa3TyKIFuLD?=
 =?us-ascii?Q?BHhQP6yKzmednXHDpz8auyWNp4mwwuCKaX/9/mqhdv4KgoEdBTUA0lM5ordB?=
 =?us-ascii?Q?TBJAqyRuATc7Nm1j5v3e5mdjcne+SsYamK7a8bUCf9ZsnVw/A3Eep24u8JYQ?=
 =?us-ascii?Q?kR4i4QPTpQA1XqV+05Mo1hTwqUM71mWrBMUIknLjyIGpdHEUoLAaeSRb87KH?=
 =?us-ascii?Q?0Ttp7fzKk9zS5EzFZlTedEv1TTBGP9ZTiHxJ1k1pHQMMiI7ip0/zesRcUO8s?=
 =?us-ascii?Q?GGWDx0tRup5Ia7jp8QYuG/z1Kk0L4JM73YCBcFCLcBVtqEr2jMgJWG+kjNVh?=
 =?us-ascii?Q?etUIVzdjnJLpj7TjBrkVNsIzz3rb4FGZHYdltFazC/v5ZVIA25aABce/Y0Ff?=
 =?us-ascii?Q?zmytez4qHxPmMPcsWyYJjFeMB/N339RSk4bInbg7Ko1O8cAET8Q5f0gkYu4u?=
 =?us-ascii?Q?g0h6fhEUteB2jOJKTXB40ZrP4KxWQdauhCvOv97IAshv6MO1GFQuv4XK+YRT?=
 =?us-ascii?Q?+6wbMLe2wBhnQ3Hs2C1+IKNQS0aU9uKnDk/aevq7sqdrqF7BFqFbd1mH/U2H?=
 =?us-ascii?Q?YSAx8VsGIjPt5HFaBau2HE7DrImOHZ+bC1zfnq6ugV/xYl6BOS6/s/SNI7jJ?=
 =?us-ascii?Q?tSED5UAYB5oGmPPDLmQ0qZ8ImV0P06iLC/r/aoteeQ6dHiGcr15btPwBOazj?=
 =?us-ascii?Q?UnMP28bCcY2eemGBJJumolMmRvWMrJBwRK7CHhhc5X647jR7chmmHZgBgh9J?=
 =?us-ascii?Q?18YjkBtkMV1uwQMDlQpHPVeMkdLjpDTwykwqwr50QJ6JO/JFMSx2vz4JjJHF?=
 =?us-ascii?Q?lxFy61O6ntkikUSkIuw8iX5nBTjIgcxUQTVYUCa58/Fq4WL5oxjAC3bu6L4q?=
 =?us-ascii?Q?Dqam8IsQsg/OoNBjOvmtSygWh0Txs7zOGKuXZJulxCqYcmqzuQiJCUSgonV0?=
 =?us-ascii?Q?hC290DJQcTayQ+iDu2HzqQc7FSyu2AM8dWBLlJuN7vXUi5cq30MymenEhKM2?=
 =?us-ascii?Q?gsxoVOibyfKcmiKlqfo3eNJFVz0YO0emUCy8SFR1x+RHGcEypuFlGp06REAH?=
 =?us-ascii?Q?295ZtMlu2Cm96pnqYhVqIXXXLHiQNS0aByiZwzX5Nw5IClapUGxPHkCbPX3k?=
 =?us-ascii?Q?96nUp87D0WlpqIy8vZ6Wo0wn/XA+SS63pA61oeBnqq2EKS3PAd0zMdyEUPTX?=
 =?us-ascii?Q?g0MWkA2hrvACCoUsO7yrA4Ymao357uWyoHRLXrtK61HDEgYb/Kgxo9/OFLI2?=
 =?us-ascii?Q?sJXGk+m2DXb73MdDyueqd3pRdYCpu6gHQNUdlOk3Yv08xptJRcI6TpMSQojl?=
 =?us-ascii?Q?PRXFchZaS7KB1cCfbuY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7758024c-3ef0-4062-e773-08da8441441c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 13:21:47.6675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rLrORZg0AhNZFoFxOwHC/l0x3mL/jEplVq4tyIhQhn2Pu05i9HGjbL14DCsZZkz/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
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
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, August 17, 2022 9:03 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org; rafael@kernel.=
org;
> eric.auger@redhat.com; alex.williamson@redhat.com; cohuck@redhat.com;
> Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> kvm@vger.kernel.org; okaya@kernel.org; Anand, Harpreet
> <harpreet.anand@amd.com>; Agarwal, Nikhil <nikhil.agarwal@amd.com>;
> Simek, Michal <michal.simek@amd.com>; git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
>=20
> [CAUTION: External Email]
>=20
> On Wed, Aug 17, 2022 at 08:35:38PM +0530, Nipun Gupta wrote:
> > CDX bus driver manages the scanning and populating FPGA
> > based devices present on the CDX bus.
> >
> > The bus driver sets up the basic infrastructure and fetches
> > the device related information from the firmware. These
> > devices are registered as platform devices.
>=20
> Ick, why?  These aren't platform devices, they are CDX devices.  Make
> them real devices here, don't abuse the platform device interface for
> things that are not actually on the platform bus.

CDX is a virtual bus (FW based) which discovers FPGA based platform
devices based on communication with FW.

These devices are essentially platform devices as these are memory mapped
on system bus, but having a property that they are dynamically discovered
via FW and are rescannable.

I think your point is correct in the sense that CDX bus is not an actual bu=
s,
but a FW based mechanism to discover FPGA based platform devices.

Can you kindly suggest us if we should have the CDX platform device scannin=
g
code as a CDX bus in "drivers/bus/" folder OR have it in "drivers/fpga/" or
"drivers/platform/" or which other suitable location?

Thanks,
Nipun

>=20
> > CDX bus is capable of scanning devices dynamically,
> > supporting rescanning of dynamically added, removed or
> > updated devices.
>=20
> Wonderful, that's a real bus, so be a real bus please.
>=20
> thanks,
>=20
> greg k-h
