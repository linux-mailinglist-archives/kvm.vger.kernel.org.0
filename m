Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A33D7D82D4
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344627AbjJZMkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 08:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjJZMkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 08:40:10 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFA7C0
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 05:40:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhXbPEHw3eYoh+7qUXikVLLoEjaEYHxxevhV5+h0NxvCTXWIyxX9IL69xa9f5SCvi/VTx075s/GBS0Z3Fh5MMlkaD70JwdFJtulx6CrWWpdeqnjh1XJdNN5/yjW1Yj8Wwk7E6fqNQW5IyCzVAlapBrGzcwGh/jR0n8shygmBCcga/X+7si5OHxHISSPhW/hiqOiRKD5gCKsBg4fje3mx4s9CwN3xjxX+qpWHfP6opGN9/dOrFsym2dL2sFv0IjPHFHWgiIaFH3huzOpbj579SYQeoDDULlH2Ly9zDj4HSEQ2iU8+V5x+5diUZxMS4lsdIncyu42sW6zurZT1pLi29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hKkn7MXzaT2TlLY2wyLW/9cT6jdMM93iAp8cnjfykI=;
 b=bNIbHkW/9vtoiDWxMBL7My5A6A7koB6Z0w9nhI1/QOdDgxaVZdV8Vj4QoDPou4NjnNiLsbJJZYWYi36R78hXQZfcQenYXihkcKzTfFE4d3auiRGwUYHor6KEi4HG/n3tYFicYWBaZAyRo0ysN6qxnWQkhYll+0q4kYLYvZyvXrDvwoRLPNglZ+2uLnwEoG5Jk0iI41P96/MJwZsHAl/1XWUvFtIcm25Wg1fJvOl1e37hYF9/6lh6obKnPIR0n/SO50Cw93TvQakdxm/1p3dANxq+wxGG2K6xVsFz29cgzod2ndzwfrRoPB/hF7iYPmR0nxvXCpmdCPBpbyD8vCLkQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hKkn7MXzaT2TlLY2wyLW/9cT6jdMM93iAp8cnjfykI=;
 b=DNzzegq7vZHAisyvRzFrwALjltD5wMnIyrqBex8Mz8On9SNFj5nhlOeslkG4+tD49q/LwlbgcZNrFak5/Fg2Ra5kEXRrQFHnxtt+52dRmo7bSSw2aUiKoid8wdpbZXtpQb9dhp0u3/TsGTkTbbiC6zEBXh6DzM1fxseYtkk1TVkXVShAnFInlFVhzhKAYCML7b6dGOpm0j7NQkBAaYPswTZ45VUiIt9qQgEYJEd/WUWwuue3pey3ZEFnmfIxWcAC1n9zFql7sT7weBvJDD96bJvRgrDXEZOYV7IJaXEsn3hU1nZL0Ht3s0c12xBSXd1PDh5YXlYISrnZ9ScQ3GXWIw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Thu, 26 Oct
 2023 12:40:05 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c%4]) with mapi id 15.20.6933.022; Thu, 26 Oct 2023
 12:40:05 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaAP/t3dG05nYg50S7FQsh4+CEA7BZZo+AgAE4i4CAAE2RAIABG4MAgAABLoCAAAcq0A==
Date:   Thu, 26 Oct 2023 12:40:04 +0000
Message-ID: <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026081033-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231026081033-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|SA3PR12MB9178:EE_
x-ms-office365-filtering-correlation-id: 910bc8cb-9880-4acd-c031-08dbd620ae09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 74GWgWHD1iH3Moh476IU9h8Uz5yLb/yxj4zqBUYi2PzuOE3kLJ66LtB+EGagKiaa1r8PDUF0f1NYW/VI7SX1yYf2r+A1bYi3y5SdPogBRsSMHnccQdgUkZUDqMQlicxB/zdghnJvxNTlJlOxqBz3CaFTICbSTnX2K6slHvDFhNww0GFdYeYWwCL5miUa57eMQYltA16xgOFZBVRRWhariTyivA0P7kqe8ibFSFyz4PdRu3VDHIzXOPuCnPPLKxX7ptms/1tf9vGExz6YvgpuAz1QS+s5JsDUIRNV/CoFtD30HW03Jq2Qidu5zc7nwY4sHJF7dGVeQ5y/FZJnGydp5c+o0gHc7hyIrnTJ69Cx2FrlvKOX5sx8m/s9zQCAT5QW2R+K1fTEZDVtyBSzSbOQ1JhJwil89ZYMLk9Lff8anNVymToIkh6iN+JvtYy30p5/hpf4IRk5WvdfrPiZrzHkHpx+GJ89Lhl+wXfkKkoAUOYKUZDxhjVEmcfePdd4qqUZ0EACjoimHibzm1g2la8WlARrpKbYsALWYqYuqKaElKbaG1xx4B9DBjDWjNnIHqg+6Ck8sxoH+0m3bfMUns1iJWyvjj03mgB7ENNTlM0sZXLin+6Z7gtT/pSc0HFuCbWL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(366004)(376002)(346002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(122000001)(71200400001)(4326008)(2906002)(8936002)(8676002)(52536014)(107886003)(55016003)(41300700001)(5660300002)(9686003)(6506007)(316002)(6636002)(110136005)(26005)(76116006)(478600001)(7696005)(38070700009)(86362001)(33656002)(38100700002)(66476007)(66946007)(54906003)(66556008)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2X7ldA2TsajzQWRMA/bOxZMkyCGILfMFBnixS20Ai8WEywqfjgWyPqlbnhQK?=
 =?us-ascii?Q?tRgHu39ibAQnhXOx4GHvYaa13sL8mHetQIgnuG2mxSDnHfvcedyfk+l2VVqs?=
 =?us-ascii?Q?CPyOLNyNhoWH1d0pry4nCaR4z+doRhVGKeqWl/EbqbgTsBJZ3kje5Uar5Tiq?=
 =?us-ascii?Q?ldiRW9uL79iiXwdPdPMzhPAIZt9q4PhwPKDezbeVfWzMRn6OFwfQCqXKkpS9?=
 =?us-ascii?Q?2iXMwLxt258d3GSU/WDtkp6kVI6KLhavSqnlI7PLFa5vbTzPavuus0rOMfLR?=
 =?us-ascii?Q?hU1VMGEfKzzxnHCNO7H5U3+59reVV4KJbwKYytP3lsHfPjyLPnS+ewXqs+p1?=
 =?us-ascii?Q?rPeRV0Jr+uPq20IABVjpzDM4g7HGEteAgYsmBWSO/QLe7v2NUNX5p6uhgf2a?=
 =?us-ascii?Q?A782QXV5fPy+A5Ky5vGg4rkd93FD8cEbxbGevLcMV24dQvfyBDnLa7yMCQB9?=
 =?us-ascii?Q?RvUV97kWCg09e7c6a2PX5f6HIS9nCX5rWsLsAwb7R6g52f/PyweqNoCeIsQY?=
 =?us-ascii?Q?G6gRBqXlxLUB40xCTcNB8bwAzfDA1P3lWzzzstSh1JLMwM7x3+V8cseFk2jl?=
 =?us-ascii?Q?ExdXUY0hLXCpT6v7OSzMTAKkn9bifRRcVG7uMufd8+pe9VzJMF1oIJWTQxmm?=
 =?us-ascii?Q?Y2IdJGwCXljrTxCDdMbfcehV3TxepQDqZR9z7gHgm8BNpW1y+BLPwIC/61vj?=
 =?us-ascii?Q?yZYbAqbbuINk0ZljLwZfqIgOqrDbU3PVX/SiaXW7ITx2tvcYL8D9QAbFjZUi?=
 =?us-ascii?Q?GiC0iv0jnc2SaKd96+pOsUtXIxltGKME7L8ZPvX3xzNefzO5Y69xUmGeLpjH?=
 =?us-ascii?Q?ShC3svAve2iMyaYzkUT5KPuORyM966w6qWsKaunuQcqovtuJGY/HJSR2LiWY?=
 =?us-ascii?Q?SY1W18KJdN8yXjWUyVJIRQooYBfDmDYx+P/SUv+VnfKTihKx2X9TSGrAZ/nh?=
 =?us-ascii?Q?Hj6cK5goNEbEscFTIs+sxWnqr56Jn/zN4KTNRb3idSUKctTU9yoBRwZqcQSW?=
 =?us-ascii?Q?LdKYvWKhAUlESXhXFdBRr5In63vbsJ7iXawRzWVr9oqMPPicpaz67CYAbg0c?=
 =?us-ascii?Q?mx66yjLQ3fyuwmIBkA4JD8gmKKslc1kmZ0MrBLYS7rRM9js+LOuZl8Na+OqR?=
 =?us-ascii?Q?r6vGY/LjAUT5c+nOqdaO9h2NO4ItknHfb5a3WYNvjLKcQFjpD7DiHjpysCK0?=
 =?us-ascii?Q?+DxrRpfrmdb2BjiZJN+2dDsu77d5DN5k4Cg+QeQZxgwP0hMAikaPfiyzC4mb?=
 =?us-ascii?Q?QAh/Ce+Ud0iKBsgqhVVwO9KhxVzI7lVLQghILlfz5cdMoMD6D0fNow/uh0Tq?=
 =?us-ascii?Q?sAv3uioviuHp9tpa3w1nxOeuwYdl1R49i1wTN/nN7S7OlV5YGpqT9O8Fl0CQ?=
 =?us-ascii?Q?FG+ivyMLKvop0Z0xgqOqwU3Hduv2cQhzkNDCyxcPpCfF9oWSMkleolZgDOax?=
 =?us-ascii?Q?YaV5gOMjoDXBFILJ/gG+RPNQ71ItkiHEoe5YMY8lh7jOUJXQbJlbHrtUBLF9?=
 =?us-ascii?Q?IDEa8If4hiHgj+090Fjfq0+QdkJI4RmoHMk0PN6dg+IvcdnUbluPOcikaB6C?=
 =?us-ascii?Q?Z7L4WtnM2IFHbbA+rMo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910bc8cb-9880-4acd-c031-08dbd620ae09
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 12:40:04.9765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p7mOafkwnxOxfeLYiB5JZsrp3nNCth0Va1O0ZQOg6TUsq6257C1KBmHYTwRSteq5MeO+iYyuwswQp09sDwQICA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, October 26, 2023 5:42 PM
>=20
> On Thu, Oct 26, 2023 at 03:08:12PM +0300, Yishai Hadas wrote:
> > > > Makes sense ?
> > > So do I understand correctly that virtio dictates the subsystem
> > > device ID for all subsystem vendor IDs that implement a legacy
> > > virtio interface?  Ok, but this device didn't actually implement a
> > > legacy virtio interface.  The device itself is not tranistional,
> > > we're imposing an emulated transitional interface onto it.  So did
> > > the subsystem vendor agree to have their subsystem device ID managed
> > > by the virtio committee or might we create conflicts?  I imagine we
> > > know we don't have a conflict if we also virtualize the subsystem ven=
dor ID.
> > >
> > The non transitional net device in the virtio spec defined as the
> > below tuple.
> > T_A: VID=3D0x1AF4, DID=3D0x1040, Subsys_VID=3DFOO, Subsys_DID=3D0x40.
> >
> > And transitional net device in the virtio spec for a vendor FOO is
> > defined
> > as:
> > T_B: VID=3D0x1AF4,DID=3D0x1000,Subsys_VID=3DFOO, subsys_DID=3D0x1
> >
> > This driver is converting T_A to T_B, which both are defined by the
> > virtio spec.
> > Hence, it does not conflict for the subsystem vendor, it is fine.
>=20
> You are talking about legacy guests, what 1.X spec says about them is muc=
h less
> important than what guests actually do.
> Check the INF of the open source windows drivers and linux code, at least=
.

Linux legacy guest has,

static struct pci_device_id virtio_pci_id_table[] =3D {
        { 0x1af4, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
        { 0 },
};
Followed by an open coded driver check for 0x1000 to 0x103f range.
Do you mean windows driver expects specific subsystem vendor id of 0x1af4?
