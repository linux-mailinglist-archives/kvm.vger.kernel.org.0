Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63268513C27
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 21:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351449AbiD1TkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiD1TkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 15:40:17 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020027.outbound.protection.outlook.com [52.101.61.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44D2AC930;
        Thu, 28 Apr 2022 12:37:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2Ufaefp0prh40RD4XYgWobTWSdAoZOtHWbTOBmozc+r58ozExFZIIEixPLnhjv+9RDu+Qp7g9r15/3Wfh3NipI5tSQOhFWAmy4OkDZiSKZ5IZ1oVFVNtmwyO546Z5Ns4vppy6MGQF5R5ZqQrnklLC9HQV+g7OLxcB3Ana1v35uPJeYx/W3TqZm+OO5qKPqp3ClBd3+MNUVDoByTWwdp8PsORnE2iVnOz/DujrJiyBQCp+IiPEFY7N/sSnc/+mvKXNG18t/Tjt9AzYTWBzpC1voyJaPJjSkYuCRJ47rb2QcH4eEm9erpYEHXPBuyILpMoA7z1A9fEEsw7OJPYqeUYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWMiK5pGHFD9OWoTNGHUdplMnxQ1x1RKxeMc26S7bP8=;
 b=NnBzNeiaQfY3jC5DXUM0IuTGuKSLotKyYwqvitVFANyLn+mSCg8CtIh7u2OFlSf4//PQA3OkzQsdAn0s4X7JQZ7UjvLX4Fn0ojBNpftfM5D9D1r0uAkr+1jYyTQt2qP9OmkZIYGiTJprK0d4rd0Pk0n93vhwiETQ3riZWSusGAvzq06k3koUW2ghnxVZ7HDMzxjKNfTVUgXfLQszxrYV+PV5oylqy7y6nc4WHSznBqH8LcDFUBDpOjW7p+6ORivhlCzKdEfFt4yEakg6q1YZlR/7DuU9lf3nJgi/mppZg6zP6IgEN9CpjddqdBNS+8+dV48F32IochINY8ppKBHiLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWMiK5pGHFD9OWoTNGHUdplMnxQ1x1RKxeMc26S7bP8=;
 b=QePnEeNXvAWC25M+p6zlWrHgBG6dJeJQ/4BcmuDHZGRPJ+lH+NhfxOepLZWhj27IQ36F6V2ZnNHJYOLWdl0UZjxE71mrHQ5A/GUqQe4BU7tPvhGsJW5Pn1xBMvEk8VUPc1RJ+1ZK3jPJf0GK49yD7qH++KUspIdbBl68yP3COJo=
Received: from SN4PR2101MB0878.namprd21.prod.outlook.com
 (2603:10b6:803:51::31) by SN6PR2101MB1053.namprd21.prod.outlook.com
 (2603:10b6:805:e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.4; Thu, 28 Apr
 2022 19:21:09 +0000
Received: from SN4PR2101MB0878.namprd21.prod.outlook.com
 ([fe80::9d9:64f6:70cb:4bd8]) by SN4PR2101MB0878.namprd21.prod.outlook.com
 ([fe80::9d9:64f6:70cb:4bd8%4]) with mapi id 15.20.5227.005; Thu, 28 Apr 2022
 19:21:09 +0000
From:   Jake Oshins <jakeo@microsoft.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
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
Subject: RE: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to
 reduce VM boot time
Thread-Topic: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to
 reduce VM boot time
Thread-Index: AQHYWZvqMSeNB9FR00eBGiDkKFjxX60CjztggAMlSICAAAGe8A==
Date:   Thu, 28 Apr 2022 19:21:09 +0000
Message-ID: <SN4PR2101MB08786192CE6DFC3450BEC571ABFD9@SN4PR2101MB0878.namprd21.prod.outlook.com>
References: <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
 <20220428191213.GA36573@bhelgaas>
In-Reply-To: <20220428191213.GA36573@bhelgaas>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dd106178-eb74-40c5-95f5-d84ebf71c7f0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-28T19:17:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 507bfe51-91ea-4da4-7003-08da294c4012
x-ms-traffictypediagnostic: SN6PR2101MB1053:EE_
x-microsoft-antispam-prvs: <SN6PR2101MB10539B1B8DE00797788F0BC3ABFD9@SN6PR2101MB1053.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: est6Jf2pKQdSMcrUCS6XeFGzCFfANlQgH0B/hj5pN5CwrYiW/dQb/u3q8r71dIPFyRFHMPMM9wZ4mEWyPU8xRu0qjijZBlf4hHuCGKlKds3TpAc7bCvVen4/mFV2S149SjeX0Gk08IRh5sTmN5+Tme8ck45tKyBklmCL3fa+tohGaGibCqOuYl9kcKsQ1SnLJJzDE9kUVck6s0dt2TMWskXbdlRvBv8kkpVouIUbf46otZlthABHdfztvder6TuQ/n8XxT0NLr2RCkiyrqJxKubC5o0/WRbdmKmOZzxlaTvHMk1p/Sy8jPx0BsQyjGIDMepEg7FiXZZBFsug6kNCC3tUan+J201UvNEI7OkRSlJ8uX9KSIm31ABuOA56scD4QUOBzb9Eia+h6fzFisUG27z/1wzq9u+JoSNS6HK1rSHUTuycTqWhVdLoK7svAuatqmJNPTwhYhVvBUrCvmHLBQR+iCp1riIYf4Hxl1Y8l2ii84xLBdV4YvCEcVyPf/LnfL6Es/w4s8AHXVB4NbuLiacMIz/Lu0c3nI2l3ckgtKNbavmrEZCqXPFb5AOiFoNn7CXuX/+IbdFyQSrY8XjuDvdVhhDidPPkFnyMnuj417jxvQgnvy8AhCYEzqlFQrD9CmDvi/7pe6AwBgZg2teSDo0WFsrta1zdkTs0ObzetVTzVnGyt2771tPzxL0xQZJn17Ar5nLmp16DjkU6kdPxShQ+Bje86elqe4d0zO6YiaqvXViFwSqJ4GALoRFyzeoB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR2101MB0878.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(10290500003)(2906002)(8990500004)(82950400001)(122000001)(71200400001)(8676002)(4326008)(86362001)(6916009)(64756008)(9686003)(66476007)(66556008)(66946007)(52536014)(76116006)(7416002)(66446008)(53546011)(6506007)(55016003)(82960400001)(54906003)(38100700002)(8936002)(5660300002)(7696005)(508600001)(33656002)(186003)(83380400001)(316002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2YE5jqo5+kQAdtoe3tFcyihVCq4dhk7PKGuL5qvw0sTzSDXqrb5OpgyuefMo?=
 =?us-ascii?Q?xfyomnfwJY+dmmqTe6coqED8xAc4Oe2f4RSUosOCN+QBXdYgpO9IjrQbyzSW?=
 =?us-ascii?Q?vwVpBdidF8PKVDDfSR5iSMDM4nXgOqyU3edxxqvGw6P0mvBv1NhzA/3PNZ0K?=
 =?us-ascii?Q?uL6KngJHKA6+s5llOyw6qOrS5cPU0QBqq36h/rPtf2eaxvhvLutVFJ6gGFis?=
 =?us-ascii?Q?t4mXmxcrQSpLh9J64C2RdxSejXN/Ge6yt4HeqYy7FeFijID+Ggr3jQgDP9L5?=
 =?us-ascii?Q?W7ebY2DMnc3HMkCyLV5cJYtnv8urGPE2vVMK9Yyzsm7z8SImO8lVUAjO3U1H?=
 =?us-ascii?Q?CKu+jJPPBfaAn+p8p9sNlkuZ8shYLWhR7i/veRRbaKBcgB2Z17bs0sDtpBDW?=
 =?us-ascii?Q?E10lPjRqha2wtPO5uEm/QcNgfcfe3RVbctGQAO37K7OlKXQJERd9AeeqLRn+?=
 =?us-ascii?Q?PIftlNJ1plYX4IGz7Y2cTPnjMMWkPMV82wjdExnsBthc7o/ytphxhoyJSqVk?=
 =?us-ascii?Q?+kUsmkJY4XH4XufkxP0LK28DT36YnDw2fGcA2X8ExCn5PMewpwcZbg+frTtk?=
 =?us-ascii?Q?6DAZ/Tn/QRaKklAhhi2uSf/W7mYB0/StcCEFIoVPrcTiS2yoJyOuUSjgnvHI?=
 =?us-ascii?Q?9h9XFSr2AEnUD2Oz4qRh4pFiC5UEPDYznB9X4qRbJlpYbtdc34lNbU7tDLnQ?=
 =?us-ascii?Q?+27gtG3hPUyA6dSdkVIYHkWEMWtiyrWPqN6mhnLvmLSL6Vz2HKGM3JEF8MLc?=
 =?us-ascii?Q?2QN1YkSjNaYlQZI1Y4JJtKHFfPQtSbnAew8PppNtspw4E+KdGg2jPeYHGGrO?=
 =?us-ascii?Q?Z8hT68Tztn4GxBXDVl5dJuz/RqO9Q8vXoI8EZ8U7zs0WYby355VFJjHtW3cE?=
 =?us-ascii?Q?y6YsjmyiYoBm63W3YGHzP1c3reSbUNHAvvlBH/1I3nAvDH+EW19/oMGVwZge?=
 =?us-ascii?Q?lBrOLVMZr9xTRSQYZwq30GnLVw5HKTSBG6qrEIynkJkd2RZV7pi8w5vSNJ+a?=
 =?us-ascii?Q?uE0M7LzI6LxDR3sw2xT/ZNwnhT8EeRezXbkrpyvcGpyEcex4/uzGHY7TYi3z?=
 =?us-ascii?Q?SZ73vHjEsNJO0Quo7LUGtJuj7H80M0XQp8YhF7gqGRx2liIJD9/olK2k60Y7?=
 =?us-ascii?Q?EKM3hOfYxTxMbApzzV8KvgVVDkn/Ky/djfh0718/cKdwiFEx+/GIphts/x09?=
 =?us-ascii?Q?CSaDIDgT49tRKg1pBIPyb5YCxS8Dl6rIL8R/B62AJtk4IKZDLlybJ5DGKYWk?=
 =?us-ascii?Q?+CfDmSsp2LTlStzwXghwzPXTuhUwycGyJQxIPiIKpFtDQ5O4ghEqmSzMspVD?=
 =?us-ascii?Q?y08ru4+3ZhA7r7LejLEgLaqs7tVgtMbgnxJapmDDiTK4VvNudOUT23OdFv/V?=
 =?us-ascii?Q?BrQ8Mo8CB74dITh0nxWxWT2wK7j2U3X5j/5roDWMhxp/10R3s0sQXKGy9c31?=
 =?us-ascii?Q?fY7/qmX+tACcx/l5/nmqWm3QmBzt0SNKq3RbXWHLsW2MREpTPy1DUgEUmyOS?=
 =?us-ascii?Q?wGfd6ydcg4+cLaiYEbV5BQkFXEKnLTV0Cq6zECbLYr4Bd8dEzcB22GocW0fz?=
 =?us-ascii?Q?nu96gMOdxuE7VgMYE+v2T5d4EQV3V67JAXZKrioT2Rpb51MbqSCo9ktTJuEo?=
 =?us-ascii?Q?XqkPcEjMCZJ09tAOLrj8BCVKvNkzb2nkle9ffwzML4y2FsT9ZrMdrp9aCc7s?=
 =?us-ascii?Q?4EBDlrKmlirv6io2SxRIERo505c3bPhzeS+gv8LhBlOZA1ukETwBJs46PyFm?=
 =?us-ascii?Q?85d2k62NWitEXKoERpea93dy8Jwz2fgMCmytpLIBywpUHNVbAsAjpT0xV0YV?=
x-ms-exchange-antispam-messagedata-1: ycxOP2set9WOvQnQRd7/nXPQt9OcDVL6V08=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR2101MB0878.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507bfe51-91ea-4da4-7003-08da294c4012
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 19:21:09.4999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D5k3eZrNSazUya8fujuZIE0c/yaGTS+JfWb2NylILh4aqV9O9sdmq8LD1yGgf5BLGOPpAirnBJaGZGy5Wn2fqIV1IpKW0qck+94W5NP68YE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1053
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Thursday, April 28, 2022 12:12 PM
> To: Jake Oshins <jakeo@microsoft.com>
> Cc: Dexuan Cui <decui@microsoft.com>; Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com>; bhelgaas@google.com; Alex Williamson
> <alex.williamson@redhat.com>; wei.liu@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; linux-hyperv@vger.kernel.org; linux-
> pci@vger.kernel.org; linux-kernel@vger.kernel.org; Michael Kelley (LINUX)
> <mikelley@microsoft.com>; robh@kernel.org; kw@linux.com;
> kvm@vger.kernel.org
> Subject: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY
> to reduce VM boot time
>=20
> On Tue, Apr 26, 2022 at 07:25:43PM +0000, Jake Oshins wrote:
> > > -----Original Message-----
> > > From: Dexuan Cui <decui@microsoft.com>
> > > Sent: Tuesday, April 26, 2022 11:32 AM
> > > To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > Cc: Jake Oshins <jakeo@microsoft.com>; Bjorn Helgaas
> > > <helgaas@kernel.org>; bhelgaas@google.com; Alex Williamson
> > > <alex.williamson@redhat.com>; wei.liu@kernel.org; KY Srinivasan
> > > <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> > > Hemminger <sthemmin@microsoft.com>; linux-hyperv@vger.kernel.org;
> > > linux-pci@vger.kernel.org; linux- kernel@vger.kernel.org; Michael
> > > Kelley (LINUX) <mikelley@microsoft.com>; robh@kernel.org;
> > > kw@linux.com; kvm@vger.kernel.org
> > > Subject: RE: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to
> > > reduce VM boot time
> > >
> > > > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > > Sent: Tuesday, April 26, 2022 9:45 AM
> > > > > ...
> > > > > Sorry I don't quite follow. pci-hyperv allocates MMIO for the
> > > > > bridge window in hv_pci_allocate_bridge_windows() and registers
> > > > > the MMIO ranges to the core PCI driver via pci_add_resource(),
> > > > > and later the core PCI driver probes the bus/device(s),
> > > > > validates the BAR sizes and the pre-initialized BAR values, and u=
ses the
> BAR configuration.
> > > > > IMO the whole process doesn't require the bit
> PCI_COMMAND_MEMORY
> > > > > to be pre-set, and there should be no issue to delay setting the
> > > > > bit to a PCI device device's .probe() -> pci_enable_device().
> > > >
> > > > IIUC you want to bootstrap devices with PCI_COMMAND_MEMORY clear
> > > > (otherwise PCI core would toggle it on and off for eg BAR sizing).
> > > >
> > > > Is that correct ?
> > >
> > > Yes, that's the exact purpose of this patch.
> > >
> > > Do you see any potential architectural issue with the patch?
> > > From my reading of the core PCI code, it looks like this should be sa=
fe.
>=20
> I don't know much about Hyper-V, but in general I don't think the PCI cor=
e
> should turn on PCI_COMMAND_MEMORY at all unless a driver requests it.  I
> assume that if a guest OS depends on PCI_COMMAND_MEMORY being set,
> guest firmware would take care of setting it.
>=20
> > > Jake has some concerns that I don't quite follow.
> > > @Jake, could you please explain the concerns with more details?
> >
> > First, let me say that I really don't know whether this is an issue.
> > I know it's an issue with other operating system kernels.  I'm curious
> > whether the Linux kernel / Linux PCI driver would behave in a way that
> > has an issue here.
> >
> > The VM has a window of address space into which it chooses to put PCI
> > device's BARs.  The guest OS will generally pick the value that is
> > within the BAR, by default, but it can theoretically place the device
> > in any free address space.  The subset of the VM's memory address
> > space which can be populated by devices' BARs is finite, and generally
> > not particularly large.
> >
> > Imagine a VM that is configured with 25 NVMe controllers, each of
> > which requires 64KiB of address space.  (This is just an example.) At
> > first boot, all of these NVMe controllers are packed into address
> > space, one after the other.
> >
> > While that VM is running, one of the 25 NVMe controllers fails and is
> > replaced with an NVMe controller from a separate manufacturer, but
> > this one requires 128KiB of memory, for some reason.  Perhaps it
> > implements the "controller buffer" feature of NVMe.  It doesn't fit in
> > the hole that was vacated by the failed NVMe controller, so it needs
> > to be placed somewhere else in address space.  This process continues
> > over months, with several more failures and replacements.
> > Eventually, the address space is very fragmented.
> >
> > At some point, there is an attempt to place an NVMe controller into
> > the VM but there is no contiguous block of address space free which
> > would allow that NVMe controller to operate.  There is, however,
> > enough total address space if the other, currently functioning, NVMe
> > controllers are moved from the address space that they are using to
> > other ranges, consolidating their usage and reducing fragmentation.
> > Let's call this a rebalancing of memory resources.
> >
> > When the NVMe controllers are moved, a new value is written into their
> > BAR.  In general, the PCI spec would require that you clear the memory
> > enable bit in the command register (PCI_COMMAND_MEMORY) during this
> > move operation, both so that there's never a moment when two devices
> > are occupying the same address space and because writing a 64-bit BAR
> > atomically isn't possible.  This is the reason that I originally wrote
> > the code in this driver to unmap the device from the VM's address
> > space when the memory enable bit is cleared.
> >
> > What I don't know is whether this sequence of operations can ever
> > happen in Linux, or perhaps in a VM running Linux.  Will it rebalance
> > resources in order to consolidate address space?  If it will, will
> > this involve clearing the memory enable bit to ensure that two devices
> > never overlap?
>=20
> This sequence definitely can occur in Linux, but it hasn't yet become a r=
eal
> priority.  But we do already have issues with assigning space for hot-add=
ed
> devices in general, especially if firmware hasn't assigned large windows =
to
> things like Thunderbolt controllers.  I suspect that we have or will soon=
 have
> issues where resource assignment starts failing after a few hotplugs, e.g=
.,
> dock/undock events.
>=20
> There have been patches posted to rebalance resources (quiesce drivers,
> reassign, restart drivers), but they haven't gone anywhere yet for lack o=
f
> interest and momentum.  I do feel like we're the tracks and the train is =
coming,
> though ;)
>=20
> Bjorn

Thanks everybody for responding to my questions.

Bjorn, from your response, it sounds like this change is safe until some po=
ssible future which new functionality is introduced for rebalancing resourc=
es.

Dexuan, I don't have any further objection to the patch.

-- Jake Oshins
