Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9880950A843
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391483AbiDUSo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391466AbiDUSoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:44:24 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404494BBA8;
        Thu, 21 Apr 2022 11:41:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bY/8TQvS1vXN3a9FsAC4/a8yOAGiz3Q09gQvhFKMVCtfqS38nW6xgCD5ewqEm7EhKgqgmQqoIMKVMbiaGUs3cTD/5BHhmtAbh609TqRZEwrkJoLbCFMLDDMC1rFU3eX1vfHdWs3qAnZtamEVFxyurHMogaa7M7DES/+jywjwddf+R2Z1YAltZzzC14Zs5u5UtVC0Os9TYYlsnmKIfsBafV4/gL3A73soDr0aoWay9qiyEGsygzQBtv2xS0VwOr8a2ONhvsfiR+Ec6CTb20AOBqt72121w/wdkGZe2pgJYpeNwrestZsaYECxjS5KvpXkWrDwhKdRCPwSRYWODC3dwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtuhHSuQTa8oR36tOnuc/uVanO90hIq3eCQyewocLhg=;
 b=ijAzby2SfFO6icAuTgkj4FoYTcG18f/sd8V6LMWquO/R6kC1H1VNQkLrvXClpXQAFxNjf4IYeiC8Sp+BPSi9maZ4YJisRVAVSCZxILDhD9MWS0dpVzmM26Zntgj+F/c2Yz7dtUyCkZIUGal1Vft2iWEPhJOkj65wj0ejR1gA2Z5y11pKKbTyfWE/5wvCv2bvUFYXC808Fq060vjfVXgmg/9xrBCVAq45s63y1lkfxtL00OGr8Xu+LVP5WKtl48VU4e5CiDay+ByygD3CX1VKfgB7Icm5RPOC8B1jWzCaVnMjnLP9W8H5IPyzdECqqe4c3pcjeTV2fnzxqw0gtWvsgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtuhHSuQTa8oR36tOnuc/uVanO90hIq3eCQyewocLhg=;
 b=SNaKYzWnOmbYtzSsjwOC1TLe7k2iyR4GEH9pOqmgwGJ2XdD6wFgPVVCtBc1dqS2Bp7KiqvIuhElkW555XY3YIKxObhuMvPO/mqTgetr1HW0Du20X9QM1+FxEW+PUahdleHNcF2J/G8BGjW7p31DjIPRksU70xkMrbLVhpQNKk9s=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by PH0PR21MB1861.namprd21.prod.outlook.com (2603:10b6:510:17::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.7; Thu, 21 Apr
 2022 18:26:36 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::645b:25b9:a49d:3e13]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::645b:25b9:a49d:3e13%7]) with mapi id 15.20.5206.006; Thu, 21 Apr 2022
 18:26:36 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jake Oshins <jakeo@microsoft.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Thread-Topic: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot
 time
Thread-Index: AdhVrRvIeWjuo4jbQkC6t/9QZsLcgw==
Date:   Thu, 21 Apr 2022 18:26:36 +0000
Message-ID: <BYAPR21MB12705103ED8F2B7024A22438BFF49@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6460241e-8dbf-49dd-a21f-614e3dcc5447;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-20T15:53:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02583fae-f607-45b1-54e1-08da23c47856
x-ms-traffictypediagnostic: PH0PR21MB1861:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <PH0PR21MB1861AFA5AE8D0ECDDA53BC2EBFF49@PH0PR21MB1861.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iZ7kiRHnzsyeKHpUlxml2Nxt/VdChO5ScSqZrm9EYoSysvQNtQdrBhFD1QqVlLfwd1nR7mwOeMk9GoWR30c2fve69LOQbiCxytIpfNnQQGfEE1GBwyZyOo+LlljBxrSJ8fZXJiouVG4FV0oyqUEXLvLhQ+l+YHJgI+PCVERW87M78WWRBiaBeyCGx0puoIyKAIa7VcOv3jxPtX3A07/R8W0D6aTc95LPwS3c3Yoex8t/5tVh8O4yA4kIukXPxZXMvnJFocQG4/nxVz4Kzx1WHdb/ozhUAh5sD74ydZ/c9BqV2MipaFrCMJWNrLvmbeLs3R5p7JSbxibM9DpVIqFdc2Uub10nG9ouQjanfM7P8IpCefDA6qnh5XdHYQVq1980IWebX2QqYQl5SOhV7jqfdUdSMVn5ISPN669cNRjRCmpJ5x1X3z1/sGmBI3ra14Nyc8SFYvG9JaPgMcApaD6BmsujOfWMznkCmyPQDl3x6J1vRqpP3ANpuRdOShAW9rbH0d+66RA8rrpJxSEcrx7dzf0u/gs2rZrmIKYirP7tLaSlLhwZbvUcZAdv08LHzTgA6bEm+N9rtu7kHyMbxMTwhg2WbvYE8dmMVKqDpoC+DR/dPq7x2gOdzlQpJTDw3CCqcKw6QTqr4sHWGapvRsbaB0ymgD/K6ffgfzBSbedbq6OPkDlJy2PsP2/SRvxEPHbBvkqK+1/kDTJP6vXFlgxjmobAVS0zjFBZVTu0vE55lSzvYu8Wg0/Dhin+rAkU7tOl7je8HCIdzijomYR0JHYGUOmBktMeSzNksRUWYhnLLt1SmHN4NLTPwf104GWyz1WF3R55IbKncFdkEYcJZPglqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(7696005)(9686003)(966005)(6506007)(53546011)(26005)(71200400001)(10290500003)(508600001)(122000001)(186003)(38070700005)(82960400001)(82950400001)(2906002)(66946007)(33656002)(76116006)(83380400001)(8990500004)(64756008)(7416002)(52536014)(5660300002)(86362001)(8936002)(4326008)(8676002)(66446008)(66476007)(38100700002)(316002)(110136005)(66556008)(55016003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fD8/ZsFbqh6Rb42WwGkpyjUA2a3ICGeW655DWU1TtHuvm9xWM9i4NtC51wgn?=
 =?us-ascii?Q?U0dkiiu3BSCVkVuL+2N97RbGrsyB+zAt7tfBInwGn1WV22KDWnf3sOFq5O4+?=
 =?us-ascii?Q?HCPp+65OIu3jFIM9wEFtfPK6n2bTdrqJ02N1tPG1mbOAeI5DT8Qu35zC2Fvg?=
 =?us-ascii?Q?LuT9eCZxJ1uyxzOeK3v3KbzKoRcEccIyIretN2tCoqPC4up+d6J0MJmcY9/R?=
 =?us-ascii?Q?wUuAfDQrscAawrmzqzI94fWcYuLbZWuqZYpy6wfVLAhgg0HLejSUZzJlr1L7?=
 =?us-ascii?Q?XP/yDifyUwihU88KnJdgQGAeOFg4pGUFPSfhuABfGKCtrtN9WjcFJT9xYwfF?=
 =?us-ascii?Q?RmLPOXX2RsUakoj8ErNgHyR5/AVnQ6qUSzxETYyqunWC4OHmYM1lxF+GeGNg?=
 =?us-ascii?Q?fb6hSXdHTp7to1NCFGk7vA4mBemdiwMXFpxUThitYRx+ZL3370yyMW/62k+T?=
 =?us-ascii?Q?ua5oN5cw4FlmactwYyiFUQ6DPg+QHidO1kyD4L7E4+GrGnoIWsv16bqLpGEi?=
 =?us-ascii?Q?fxEPXtWkamMLYAcJOgpvHIqzTbejG++iqwCiAIHe10ZBKV7NYTypFMmcOyRG?=
 =?us-ascii?Q?npgEaRraMjrDR/AMQ2S0KJPWSNkxgtKvU/LXy2ZpUue8iFYYOm17QOSHRhiI?=
 =?us-ascii?Q?ZZY8XeQyn1bVOHm6kYc5cITINVmV1yYKnAMIuAfyRtc8ZSVRTYVGC4fKi+1y?=
 =?us-ascii?Q?4guElRJ5ZBisfXdTVvKBwZMus7CT4WteDsW0yEQOotm+YTG8pSsO5fOhBiTf?=
 =?us-ascii?Q?R8NxyAm3CmUYcTIEltVOA4O4siFrGgxWLuS83JuG8LWbBXU8x3L7aj+0gkZa?=
 =?us-ascii?Q?3xDdnrH2rrx4pH8B1ujpVr6XIGElxNQNoWDfUi/SmF1Qe1a5nlwxhRmSoK+C?=
 =?us-ascii?Q?kmXplMWD2g/RMUGRnHg9Am6gsfeFoCVXRM23dpShJc+BPZrCAPgaO5+iJLnL?=
 =?us-ascii?Q?YRJXsUww5pdxUSmaW8E49qVFUaQCYB2BK/lY0ZMERgMJkLhNt0a8Re+Dw2v5?=
 =?us-ascii?Q?CHynYEHrFLiYXmeYeRTs/ul7WZ5UnpzouKeln5VDn7Vpab3ibJ2tuj9+1CQf?=
 =?us-ascii?Q?EV5QB3W2zOUeC2vF2a43f72QVtEb8lAEb/u9fTJIyOQAXRf4AiDzF1BjyBR3?=
 =?us-ascii?Q?0XJCakEE3rxLqvkZ0PYQG+GP1wwa2Ma7m3yRWMtnnGVqMonelpDBfOyHgLGO?=
 =?us-ascii?Q?BSGcu32t+SyGfQHB1kn3oJW67wmtTAXgI67WqX6gkCugqFwLAoytbCX+SO69?=
 =?us-ascii?Q?2jrQFDwtqen4m3u7FmfRbg4p6hSIz89V+o6aFEfQX1lDmbDITfjqFc1Zvx+u?=
 =?us-ascii?Q?kHhYzTGaYO9JAHvvV/SGTVx7DPwsziMoqRMriYbJbvV4Q9y/8K0VJFxGHDbX?=
 =?us-ascii?Q?iq1jsIWh+m+MhZOJ+tQCbmgwIc3bEgerxsj53c21Ms0p2mpUszXityB2Ky5D?=
 =?us-ascii?Q?HA7jh5vssge8Wh3YXwyzMTdVKKF7R9j3aeMQKOLLlWNkS4zpTZUhVa7nVIxt?=
 =?us-ascii?Q?pjm7XOWW3F/GFaJ+mKeqsNqBIHXxTcgYRycy/W97+b7w7iekjKTNTh0vHbPQ?=
 =?us-ascii?Q?IvDeKGTP230tpixr8ZjTJnyWm0n/L7bkWxIkSourqFCdpDSHCMWxhoUBQtsW?=
 =?us-ascii?Q?2eTtggY2dIkq1ajutYStUokaFrYxfT7Uv9cuhDEBILP28guYzGne60A5Tgi+?=
 =?us-ascii?Q?bFSC7IcocaVRETM9JIfh8gbDOWN4VPw565gt2KZzQA3SQyFS8mIaVTdQkLM8?=
 =?us-ascii?Q?457NeEg7PA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02583fae-f607-45b1-54e1-08da23c47856
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 18:26:36.5032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dk9PMFbEfOpMIvhC7RDaVG9fBiSk6gBf2aNXG965KUd+i46t94bGBy9LcbGsh0L/xH9O5Tq7qLrD+I8qPg9yNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1861
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jake Oshins <jakeo@microsoft.com>
> Sent: Wednesday, April 20, 2022 9:01 AM
> To: Bjorn Helgaas <helgaas@kernel.org>; Dexuan Cui <decui@microsoft.com>
> Cc: wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> linux-hyperv@vger.kernel.org; linux-pci@vger.kernel.org;
> linux-kernel@vger.kernel.org; Michael Kelley (LINUX)
> <mikelley@microsoft.com>; robh@kernel.org; kw@linux.com; Alex Williamson
> <alex.williamson@redhat.com>; .kvm@vger.kernel.org
> Subject: RE: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set
> PCI_COMMAND_MEMORY to reduce VM boot time

I removed the "[EXTERNAL]" tag as it looks like that prevents the email fro=
m being
archived properly. See this link for the archived email thread:
https://lwn.net/ml/linux-kernel/20220419220007.26550-1-decui%40microsoft.co=
m/

> > -----Original Message-----
> > From: Bjorn Helgaas <helgaas@kernel.org>
> > Sent: Wednesday, April 20, 2022 8:36 AM
> > To: Dexuan Cui <decui@microsoft.com>
> > Cc: wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhan=
g
> > <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>;
> > lorenzo.pieralisi@arm.com; bhelgaas@google.com; linux-
> > hyperv@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>=
;
> > robh@kernel.org; kw@linux.com; Jake Oshins <jakeo@microsoft.com>; Alex
> > Williamson <alex.williamson@redhat.com>; .kvm@vger.kernel.org

I removed the period from ".kvm@" so the KVM list is correctly Cc'd.

> > Subject: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set
> PCI_COMMAND_MEMORY
> > to reduce VM boot time
> >
> > [+cc Alex, kvm in case this idea is applicable for more than just Hyper=
-V]

Alex, your comments are welcome!

> > On Tue, Apr 19, 2022 at 03:00:07PM -0700, Dexuan Cui wrote:
> > > A VM on Azure can have 14 GPUs, and each GPU may have a huge MMIO
> > BAR,
> > > e.g. 128 GB. Currently the boot time of such a VM can be 4+ minutes,
> > > and most of the time is used by the host to unmap/map the vBAR from/t=
o
> > > pBAR when the VM clears and sets the PCI_COMMAND_MEMORY bit: each
> > > unmap/map operation for a 128GB BAR needs about 1.8 seconds, and the
> > > pci-hyperv driver and the Linux PCI subsystem flip the
> > > PCI_COMMAND_MEMORY bit eight times (see pci_setup_device() ->
> > > pci_read_bases() and pci_std_update_resource()), increasing the boot
> > > time by 1.8 * 8 =3D 14.4 seconds per GPU, i.e. 14.4 * 14 =3D 201.6 se=
conds in
> total.
> > >
> > > Fix the slowness by not turning on the PCI_COMMAND_MEMORY in
> > > pci-hyperv.c, so the bit stays in the off state before the PCI device
> > > driver calls
> > > pci_enable_device(): when the bit is off, pci_read_bases() and
> > > pci_std_update_resource() don't cause Hyper-V to unmap/map the vBARs.
> > > With this change, the boot time of such a VM is reduced by
> > > 1.8 * (8-1) * 14 =3D 176.4 seconds.
> > >
> > > Tested-by: Boqun Feng (Microsoft) <boqun.feng@gmail.com>
> > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > > Cc: Jake Oshins <jakeo@microsoft.com>
> > > ---
> > >  drivers/pci/controller/pci-hyperv.c | 17 +++++++++++------
> > >  1 file changed, 11 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/pci/controller/pci-hyperv.c
> > > b/drivers/pci/controller/pci-hyperv.c
> > > index d270a204324e..f9fbbd8d94db 100644
> > > --- a/drivers/pci/controller/pci-hyperv.c
> > > +++ b/drivers/pci/controller/pci-hyperv.c
> > > @@ -2082,12 +2082,17 @@ static void prepopulate_bars(struct
> > hv_pcibus_device *hbus)
> > >  				}
> > >  			}
> > >  			if (high_size <=3D 1 && low_size <=3D 1) {
> > > -				/* Set the memory enable bit. */
> > > -				_hv_pcifront_read_config(hpdev,
> > PCI_COMMAND, 2,
> > > -							 &command);
> > > -				command |=3D PCI_COMMAND_MEMORY;
> > > -				_hv_pcifront_write_config(hpdev,
> > PCI_COMMAND, 2,
> > > -							  command);
> > > +				/*
> > > +				 * No need to set the
> > PCI_COMMAND_MEMORY bit as
> > > +				 * the core PCI driver doesn't require the bit
> > > +				 * to be pre-set. Actually here we intentionally
> > > +				 * keep the bit off so that the PCI BAR probing
> > > +				 * in the core PCI driver doesn't cause Hyper-V
> > > +				 * to unnecessarily unmap/map the virtual
> > BARs
> > > +				 * from/to the physical BARs multiple times.
> > > +				 * This reduces the VM boot time significantly
> > > +				 * if the BAR sizes are huge.
> > > +				 */
> > >  				break;
> > >  			}
> > >  		}
> > > --
> > > 2.17.1
> > >
>=20
> My question about this, directed at the people who know a lot more about =
the
> PCI subsystem in Linux than I do (Bjorn, Alex, etc.), is whether this cha=
nge can
> create a problem.

Bjorn, Lorenzo, Alex, it would be nice to have your insights!

> In a physical computer, you might sometimes want to move
> a device from one part of address space to another, typically when anothe=
r
> device is being hot-added to the system.  Imagine a scenario where you ha=
ve,
> in this case a VM, and there are perhaps 15 NVMe SSDs passed through to t=
he
> VM.  One of them dies and so it is removed.  The replacement SSD has a
> larger BAR than the one that was removed (because it's a different SKU) a=
nd
> now it doesn't fit neatly into the hole that was vacated by the previous =
SSD.
>=20
> In this case, will the kernel ever attempt to move some of the existing S=
SDs to
> make room for the new one?  And if so, does this come with the requiremen=
t
> that they actually get mapped out of the address space while they are bei=
ng
> moved?  (This was the scenario that prompted me to write the code above a=
s
> it was, originally.)
>=20
> Thanks,
> Jake Oshins

Sorry I don't quite follow. pci-hyperv allocates MMIO for the bridge window
in hv_pci_allocate_bridge_windows() and registers the MMIO ranges to the co=
re
PCI driver via pci_add_resource(), and later the core PCI driver probes the
bus/device(s), validates the BAR sizes and the pre-initialized BAR values, =
and
uses the BAR configuration. IMO the whole process doesn't require the bit
PCI_COMMAND_MEMORY to be pre-set, and there should be no issue to
delay setting the bit to a PCI device device's .probe() -> pci_enable_devic=
e().

When a device is removed, hv_eject_device_work() ->=20
pci_stop_and_remove_bus_device() triggers the PCI device driver's .remove()=
,
which calls pci_disable_device(), which instructs the hypervisor to unmap
the vBAR from the pBAR, so there should not be any issue when a new device
is added later.=20

With the patch, if no PCI device driver is loaded, the PCI_COMMAND_MEMORY
bit stays in the off state, and the hypervisor doesn't map the vBAR to the =
pBAR.
I don't see any issue with this.

hv_pci_allocate_bridge_windows() -> vmbus_allocate_mmio() makes sure
that there is enough MMIO space for the devices on the bus, so the core
PCI driver doesn't have to worry about any MMIO conflict issue.

Please let me know if I understood and answered the questions.

Thanks,
-- Dexuan

