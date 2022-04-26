Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E255108EF
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 21:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354005AbiDZT3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 15:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354097AbiDZT24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 15:28:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2109.outbound.protection.outlook.com [40.107.236.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCF12E6AE;
        Tue, 26 Apr 2022 12:25:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPsWrJA0b24BXwMU1J/MnM2Yr88gxgADKKUM3wXENo0em6hj6G+j/Gd3wp7rfdU34sl7KW8OtOc/Tp5bElyIO6VvLY50H5FdVOFkDFWrX58ai8Hf8vN9T0A0OLYhyHGbJkQwsP3k+Ern7HMDS4DjJA4IN0ooBxeQHbb49urKsPPfvawNlLA2uKE7b3lcbRk1zgJ26jmDJIgKlPwphLMMp7AtQ/ZzmOIxmbpqSfY3GQjUO5YhSNQPVSvMZkvmf09fP99//kcN1q/nMAyo6vPZuLM8yffxUbTIos0ys+A71/7PruvA59XA3gbr8zTqB0UqTuJO7wjtNe1U/VtT6+xcdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APzemtZkPcFQIBrw+cZwYtiZZKbmQxU6SA9AL45u3dQ=;
 b=ISNgREh1oYDsF2e/sY8EUz4n+TwE4WAGwmYoyyw0IKc2LYvB7mhWWFxwUjpIvYbNkvP/kI7Fdb5Ja+R3V18o8ZcgwzbY4gFlgq9l3A+pR2JkJ+d2vtBtsfme7SXVXCIrZ6E28cslPODXa/D0omywIKOIJzHb0EBR3vVKMzxM1n0fI4iRMwa3ylSFY5RU+M+IilnyL4ANoxkIVNTphlXHZAfx909dWTvGTYiaVveDz/++MtfFPoPyoVdokdbkoJCW0n2XHsZi7ugOVoNajUWy+7pGKFtq9+24U+J2o77r+Fa37FvJOZVIlZ2CJzlm86dja717vY2Rm6TttMcxvNmsTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APzemtZkPcFQIBrw+cZwYtiZZKbmQxU6SA9AL45u3dQ=;
 b=HUqvKNmkaiXtLwGRVeG61CYNaevJgLIc+tB+sbgCJHas4cL/QZLSBMr2qPeAzJ1uWaYrlVLXniNmCz7l85GVRh9il/rW0KXqLOfYJ29qAmUSz0ikgUR0fRt/NQJkzmxlOvWKpuwwFEFI8sP+B7bbhRtrdd2+Uie8+yUu7VJLJBo=
Received: from SN4PR2101MB0878.namprd21.prod.outlook.com
 (2603:10b6:803:51::31) by MW2PR2101MB1849.namprd21.prod.outlook.com
 (2603:10b6:302:7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.4; Tue, 26 Apr
 2022 19:25:43 +0000
Received: from SN4PR2101MB0878.namprd21.prod.outlook.com
 ([fe80::9d9:64f6:70cb:4bd8]) by SN4PR2101MB0878.namprd21.prod.outlook.com
 ([fe80::9d9:64f6:70cb:4bd8%4]) with mapi id 15.20.5227.004; Tue, 26 Apr 2022
 19:25:43 +0000
From:   Jake Oshins <jakeo@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Thread-Topic: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Thread-Index: AQHYWZvqMSeNB9FR00eBGiDkKFjxX60Cjztg
Date:   Tue, 26 Apr 2022 19:25:43 +0000
Message-ID: <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
References: <BYAPR21MB12705103ED8F2B7024A22438BFF49@BYAPR21MB1270.namprd21.prod.outlook.com>
 <YmgheiPOApuiLcK6@lpieralisi>
 <BYAPR21MB127041D9BF1A4708B620BA30BFFB9@BYAPR21MB1270.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB127041D9BF1A4708B620BA30BFFB9@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4e64cf5a-7ee8-4ca3-9e7a-b567d41fc5e7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-26T18:18:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37c89c46-1f21-44de-384b-08da27ba8e95
x-ms-traffictypediagnostic: MW2PR2101MB1849:EE_
x-microsoft-antispam-prvs: <MW2PR2101MB18499ECAFECCDB1EF70681A0ABFB9@MW2PR2101MB1849.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o1Rk4pN91lZku6ZyPATMpd5gP0vgM8bAwfJFGZZG58fUWTqM3vrSo87il4PsUJK9gMPD3Q9QSu8fyjcObxqRSEZNsqS/scIs1XPFev9jE1JTGTyqtBhqkOqQuzZ/PSlekh7yVnX9Q0a4neaQWreDUb/fhoPtKJ5I/0rONR3iXNf955S6qrkgMIwJN+Q37rWVlVgESUaiof14KxoMxhsRvawCiZuvIJi3kTJkUc6QE1n43qoOqcXRA/N/ndHyAeDNBGJaNQGI6IlEqBcX8OQhlx/8ivBjKs122sjLiqRgHSmkbLG5TzfzJHG6z1HnzIiY6Ou2NBa+ntxJAWx43EeuAqwn8ZE6HBPKanA+LOSDntmeChy0utWeuG9aRilw6W3Qc7yJ+KoHgFQQ/Dig7GG9O8W8mCiBCpf5N2lmoXb+F2FY660omhBkne7j1bQxvvDwpOBFlhphTDqJsKJls6WOGVRcot11umFGCCl0tDOER2cunvKytIVCoq5bdKJY8qbtMB1tPHitTTctIszcQEVQvUtSzpM2Hg8hUBpMU/y9Nwtpo8omlb9m4T5+BZBV0xLC4+dNIwP3Nq5Wxv5VxUUaPJe0pFr+q2rUVxofqOIpABIdiAudVv2GfmSuBkZRNPoslsQDV5BYE/ISLY10pkBlAxEwjtg7rirdmqn/St0Dyuiazd8TeMazmH8PA7RNsgWVx3wUqcdwUv+h2GU5wBUixPY+RsD+9I3k2uQ+QcN/7ieLv15UsCx2DpJW5Y48vVE6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR2101MB0878.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(8676002)(38070700005)(38100700002)(7416002)(83380400001)(86362001)(76116006)(316002)(122000001)(10290500003)(110136005)(54906003)(82950400001)(82960400001)(186003)(26005)(55016003)(7696005)(53546011)(71200400001)(6506007)(8990500004)(52536014)(8936002)(5660300002)(508600001)(9686003)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ASttWGUvWY+2lcUEwkCciGKqZB7Gmfa3BpoL7xFCK9td9mc+ILGZ9ba2sAwD?=
 =?us-ascii?Q?oVjj9k4PoynBV13H59JznYYcJtoY9XHqOhqCU8uEyugUQZj0DKL8AGD9jkdK?=
 =?us-ascii?Q?k1nUd5h7MF7i6ToGm9+PgEPUTP/5KzZQ3S5znjsOsLz6lJylL51jjXi8/1vw?=
 =?us-ascii?Q?yrlGbKiNHofTRtoUkNiSOAJD/hiBw/erd+eGYr/dVjXVYjBDNKorcO8Gugcw?=
 =?us-ascii?Q?VCYTZEF9FjtJkzkyA+Mhv4Iwe+I7uSH8s8/vzMYXhDtY5EsW3X+SE0jNoH38?=
 =?us-ascii?Q?Jc+30LdPoFx9Ceue7RLXcSFVx54PP126gpy76Lxh98f8BjsV2S2jm8EhzPgL?=
 =?us-ascii?Q?7od2kVH8SulZdcxbZLjNHCc1pYoFXaV83M/CtZC5t377Z6aH/Yyo1xHKzxHS?=
 =?us-ascii?Q?lEU7awBO/HZZc7SgDmTFr0UvwVohAg0DOuLOBpBHpVM0d26O0Mmn+D1/Yioj?=
 =?us-ascii?Q?83Cep34mv+hSxb2gdCVj3Ce2o5e3sopON9VfRcCt44kwAdphm9U+jgGuO9mD?=
 =?us-ascii?Q?wyiNmh1PqFT7yK6/XdcRtQ0ywYq8tCf+9U4PoxW6IqEmr3U6cY8EZNo0ftMo?=
 =?us-ascii?Q?AlvUmrk3vHB8Hcmrxlp2iGqeVkyte7Vs2SRezWUFAvUU11tzeY6mQifIHPSl?=
 =?us-ascii?Q?UWfuSpp+2lIoBoYv3frI0MuLjUMcz+xHLaXgBmX4ebYdWc5xJ1HCRE1fdrPn?=
 =?us-ascii?Q?jUHp4gyQqSrTtAMgw8pUv9FmiHG/yCkGrstRzMyP1Oqb4A9sEwqUvVKsO7Je?=
 =?us-ascii?Q?kkBCo9HVopEw27yB5jxIQMnOJPrrv3/s2Ydl8uYlpYlaLl7fxzAj2Ty4FVbm?=
 =?us-ascii?Q?KgqAkuJMJbkEwfyjnx8tO+0aDziEfyieQnXc6RZNQ85B2Q6PUcgubYkhpP++?=
 =?us-ascii?Q?ulB/bVNTwwGjI8Ymx/RYUZMrgsL02WI0U21JWQGqUEdMpihNrIzvkmzcDlu8?=
 =?us-ascii?Q?QyhyP5JP62EdtvS3DzCI7FE31fKstmC70H0z9IPwZBarfC2B9yIYM5WRLT8w?=
 =?us-ascii?Q?2fqvHNV/2opnX44+C3McvgqtBVgdXtMrr6644UHhW4CDTB7yWOe8UoBWnlUR?=
 =?us-ascii?Q?JFAULrLs9UzsdhqrqjrDccEHN1cymnBaXIfpz61SVQhqIGHyay0VbHuWaPhn?=
 =?us-ascii?Q?fVVzUl9UA2z8xnca3Id6c3Pg4b5Wi7Iu1keN0onQCh65j7dAG9E/g9d0KjYB?=
 =?us-ascii?Q?fc2y+ePSY6XAD2IvMogK5PrztcPa/HMs0+AoAtVs7F2kp4Ctvepl0Aiz9Q72?=
 =?us-ascii?Q?9UVHyVw7uzbCbgfTEXV+PMa4yy48iaiahYoeklPkUroCH2AkkZ7i3AUabda9?=
 =?us-ascii?Q?SMgFFUWYpFLbFQ52bv4PvNFMPxim2U2SMwka7WWH4go9LF7meO5GFG5mWCAE?=
 =?us-ascii?Q?psnzeSFCfU/DSpv2+ALci0zkGNhH+wdKv95s0C/zStI+t5T8LFdeuJi6/iZM?=
 =?us-ascii?Q?x5Bc7Y0BVdnJJgYRTK+SkpSbm0MtHrYb+slCSBNkj6E7edw0ySFBf6Fsy6as?=
 =?us-ascii?Q?MemvNmgUP+pThuuR4ZVt7orL3sW2u37oMneUH1k32cb7qsdVnPhNyJBBuO8S?=
 =?us-ascii?Q?/Jj8eG21mE9KxGc1ZMKLi8++sYIzZEWy4oZ1n7vwNvc91beTAcp3U7ZVOUHG?=
 =?us-ascii?Q?SQdiLuG2LI+HoXIbWjynOfJ/udOPCU2T1eiD+GeJRSHF5nP7Ffk9S8UO9i9T?=
 =?us-ascii?Q?WEdMii6J7MTwU0gtCU88ribzSiHC6arqmvGMTj+LDwNWx+4INA88EiN2My5A?=
 =?us-ascii?Q?oHlR4Cw66UorL9rTN75M4b1psa8lEWM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR2101MB0878.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c89c46-1f21-44de-384b-08da27ba8e95
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 19:25:43.5590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5DnEJ8bCN+DxLWEz9l2m9isjtkAcA5Cd0aJmGF5rexUEFddTkvQm9D7ZU2udiF9KFLUk7n5DfHp6z92jsYewAp0WoyHZZFgHDo6EHCvXItQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1849
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Tuesday, April 26, 2022 11:32 AM
> To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Jake Oshins <jakeo@microsoft.com>; Bjorn Helgaas <helgaas@kernel.org>=
;
> bhelgaas@google.com; Alex Williamson <alex.williamson@redhat.com>;
> wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> linux-hyperv@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>;
> robh@kernel.org; kw@linux.com; kvm@vger.kernel.org
> Subject: RE: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce
> VM boot time
>=20
> > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Sent: Tuesday, April 26, 2022 9:45 AM
> > > ...
> > > Sorry I don't quite follow. pci-hyperv allocates MMIO for the bridge
> > > window in hv_pci_allocate_bridge_windows() and registers the MMIO
> > > ranges to the core PCI driver via pci_add_resource(), and later the
> > > core PCI driver probes the bus/device(s), validates the BAR sizes
> > > and the pre-initialized BAR values, and uses the BAR configuration.
> > > IMO the whole process doesn't require the bit PCI_COMMAND_MEMORY to
> > > be pre-set, and there should be no issue to delay setting the bit to
> > > a PCI device device's .probe() -> pci_enable_device().
> >
> > IIUC you want to bootstrap devices with PCI_COMMAND_MEMORY clear
> > (otherwise PCI core would toggle it on and off for eg BAR sizing).
> >
> > Is that correct ?
>=20
> Yes, that's the exact purpose of this patch.
>=20
> Do you see any potential architectural issue with the patch?
> From my reading of the core PCI code, it looks like this should be safe.
>=20
> Jake has some concerns that I don't quite follow.
> @Jake, could you please explain the concerns with more details?
>=20

First, let me say that I really don't know whether this is an issue.  I kno=
w it's an issue with other operating system kernels.  I'm curious whether t=
he Linux kernel / Linux PCI driver would behave in a way that has an issue =
here.

The VM has a window of address space into which it chooses to put PCI devic=
e's BARs.  The guest OS will generally pick the value that is within the BA=
R, by default, but it can theoretically place the device in any free addres=
s space.  The subset of the VM's memory address space which can be populate=
d by devices' BARs is finite, and generally not particularly large.

Imagine a VM that is configured with 25 NVMe controllers, each of which req=
uires 64KiB of address space.  (This is just an example.)  At first boot, a=
ll of these NVMe controllers are packed into address space, one after the o=
ther.

While that VM is running, one of the 25 NVMe controllers fails and is repla=
ced with an NVMe controller from a separate manufacturer, but this one requ=
ires 128KiB of memory, for some reason.  Perhaps it implements the "control=
ler buffer" feature of NVMe.  It doesn't fit in the hole that was vacated b=
y the failed NVMe controller, so it needs to be placed somewhere else in ad=
dress space.  This process continues over months, with several more failure=
s and replacements.  Eventually, the address space is very fragmented.

At some point, there is an attempt to place an NVMe controller into the VM =
but there is no contiguous block of address space free which would allow th=
at NVMe controller to operate.  There is, however, enough total address spa=
ce if the other, currently functioning, NVMe controllers are moved from the=
 address space that they are using to other ranges, consolidating their usa=
ge and reducing fragmentation.  Let's call this a rebalancing of memory res=
ources.

When the NVMe controllers are moved, a new value is written into their BAR.=
  In general, the PCI spec would require that you clear the memory enable b=
it in the command register (PCI_COMMAND_MEMORY) during this move operation,=
 both so that there's never a moment when two devices are occupying the sam=
e address space and because writing a 64-bit BAR atomically isn't possible.=
  This is the reason that I originally wrote the code in this driver to unm=
ap the device from the VM's address space when the memory enable bit is cle=
ared.

What I don't know is whether this sequence of operations can ever happen in=
 Linux, or perhaps in a VM running Linux.  Will it rebalance resources in o=
rder to consolidate address space?  If it will, will this involve clearing =
the memory enable bit to ensure that two devices never overlap?

Thanks,
Jake Oshins
