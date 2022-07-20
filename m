Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098DD57BF27
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiGTUXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 16:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGTUXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 16:23:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3054A820;
        Wed, 20 Jul 2022 13:23:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlGpnM0So1sbS9lPWlc8EIgLdZYTQlOtYqcsjXEhAGeQOkwUxhje9afJfkeostneG9hg1fnP0u54h1O2TjhnP+VM7isB724MzqTS11tJea5KHhDSZkTc8sq4WraABc/yAN6HaO3LBO2ghF0t2+mXp+M45RHwJDLyPcvekgG3Q/Avbr1hziDlSfeQaj6pdiGJr4TEWUuHws4uiwKBIpwe5JHAdMEQIhdoICx4owFykmwnThC5erQl2f28czecAo2VndNnLbNup3alR7iShMT8hgFCGce0Ipm4pDwlw4j4LnwJNx6TZAQPzEhrVU7IIj6ln4bS0ppcpDQW6Uc9WUO+3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWYR5/glfKXFY5yO87u+ZdvkUB6LbJJqwhaS/jE1Hv0=;
 b=LoNF57rodrso8jyNYVmoafIxETVO14+5ULlcwrpTfz6XrhZYyl+Eual3TNKS19qdZHK98HOVNgZ86OFDE4GrWLntSoOH0FrESn5oQTrH46aEV2xPFfDqXr79txmtgS6ii/iiSNb2M7GWIsnRlpsAh42+mNLVe8UZ9oY0X3piBaTHwOLiL/imstbzr4+7sERrVjtqqkD5lM2rs8BFuzEp3Lgqs8qZnu/p8cc0k0MVsP6BF7kFZX19euFTF8hmYnJAB2rcc+UOwnJUXvjtBKSTJY9QF3MKQ9ROz2JN85ka7j5IcbjZ5R9mimFFRhtV1YqTI75tZAG9/7QBuErsRkcqog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWYR5/glfKXFY5yO87u+ZdvkUB6LbJJqwhaS/jE1Hv0=;
 b=C7B6Nf1hoV+/fheRAQckj6UdMQMAwJeiBcsyHipDTbis90G/2m1g8WtdQX4wRxpeh2a1HfVN9ZwpShAlHBKuzzh//flUvlpYYL89fvuccuvpLZZjayxDnaQzjvo64mQ55yzZUTUBGB8pFNpSbDOlx1k1czhPJKwbIoLrWpoHou0gOxkTCXw6dC86iPztKQvs6+u9qxQwyEJvRLuMgXQzqNNGP1VGEP10Ec1mZuO9/PIR2MadOcmjsvQhtPhUqkSeoFKSXog562ETZimS+r5Mgo+6e+VsSu8Rd678mtmTYSWs4KrOGBzZhr7V/VXDZcWQCw6XHwtWDrr7P56qOecbTg==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by MN0PR12MB6102.namprd12.prod.outlook.com (2603:10b6:208:3ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 20:23:51 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54%5]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 20:23:51 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Topic: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Thread-Index: AQHYhdK9C+0dszRonECIz3pzVsNAb62HxQ8AgAADOICAAAplgIAADVMg
Date:   Wed, 20 Jul 2022 20:23:50 +0000
Message-ID: <DM6PR12MB3500F50D7004191902CAF8B4CA8E9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-6-kechenl@nvidia.com> <YthMZvWpZ+3gNUhM@google.com>
 <DM6PR12MB35008628D97A59AA302E772FCA8E9@DM6PR12MB3500.namprd12.prod.outlook.com>
 <YthX0brdWCZVFB3n@google.com>
In-Reply-To: <YthX0brdWCZVFB3n@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4951aa32-5706-4326-e4f7-08da6a8dc25a
x-ms-traffictypediagnostic: MN0PR12MB6102:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a+AP7Qlkc5a/hECpi9sM1RwsEVcGh4dCZczXkL5bRDJC6ttuuBf6C6yNqxkfkh0Nvk/9ZD4v1EAFPeDJSM5NoU818NBUAY3RdI7B2WgC4XMrL4rJdEXrHAJzM7PE9QCxKCebKL1GOeee7xkvb89kFd+Y4rPC4uJm2YY6IiKlCL79NZp5QZfg8YUcf+7XYGnE4Nga73pGuab9+QAzdaUNJa5gytNJkTYPVuaPFP+eOVS3CTGC48JwNvrBTF/QQTf2FYHh7o2Lxjn6PjRcvIo6GaeItBMPznQsQXuAJJM6QRGFRvdxbscWkGrUtjzH5OnComkpZvQdLDTX5yAFw5TDzLB6aepNmcIpviNnjZQ/C9zM8e25HqB+8c+MAVIaxYU7yrxEUk5+I+0bhJjASqXwIamAG6YeDQ8mDvUBo51IWfvinZBFup3mFttpft/TpiYuVY/kf3fRFmEYE/EikgC6bxtuKXI1E4SFJAQHZmnUH39VTOhzH7XWFCdCdC3ujR/aM00MdU6KAZry/6qxpdFtpL+niXRFtCO+Y/Oym76AGO/SO74tBgwdnsDZRXxxrpxT5DpHFjw2y6EyZ4Cp67rb6aPpIVMuJ1w33EcvO0SYLUd2eUKud9jTl6zfvbhqdn0jSfpn5mcq2XSm0n9uLRK9Bj9bax6dAkjoT/SvUmzJLNvh1kyy12Wp9XEy/SMPNld6eu3ygEkkLj084wlvl02iGfpMxD4abGMmF48c0etbBkdQDMqK3qXGk5cph79ZZ+BQWsYi3FPmBAtFbR6w3E6NEP9jCftRvJ7V64KSek/K2HKadnrgSPuqVNo1kxHrrjo4PnMtgxcdOlPEy7JiOEz8qA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(38100700002)(8676002)(66446008)(122000001)(186003)(33656002)(83380400001)(86362001)(71200400001)(52536014)(2906002)(41300700001)(26005)(7696005)(6916009)(9686003)(53546011)(6506007)(38070700005)(4326008)(76116006)(316002)(8936002)(478600001)(66946007)(54906003)(66476007)(55016003)(66556008)(5660300002)(64756008)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x5v68i/ynoDIGhDGJcwSY8y1LcnhPpXPSA+0i5dVD/DgxJ+zwiHMaLkqCDKb?=
 =?us-ascii?Q?9rKcuepAvddFvk0DQmGvJaQDzvQMWyIsWOo7n/5dA2g4XAfSqA6xoLwQhwYu?=
 =?us-ascii?Q?8NTY9Djc3jC0pUX79DcU6l2XdUM6a4uM/Y9k2vTC1Acf2HHxzDqwpc3+MNmK?=
 =?us-ascii?Q?3ZRDX/uOe9g46chdZfed5uFRNNFVoYsrIwdL0YmNJTLNzt0AI6qLJ4q0MHCJ?=
 =?us-ascii?Q?MPBr0aTWrh9WD4+Lt3No9+nhwV+5eWP9oVUzcrIZ8bGjFL1NTPbbxuXPtLme?=
 =?us-ascii?Q?DcAPMte7rkorwEykneNgaIddMpDiARg0KtmgJ3lgnsJVjM/RfKqBWAVZSU9e?=
 =?us-ascii?Q?rfDmTC/zOuLI+3nLdIT3F9wvHJlj2uYUtUcZpYGPKavz6XAAujTZOIqlTs/L?=
 =?us-ascii?Q?0n55YN9Na8hCOV70gDr/rLg6ddenU4DkV7NoEk9HCH/+4zjGFj+n07aXgZPe?=
 =?us-ascii?Q?xvr1L/e2DmVP/Mw4EctpYnp1PY4NYM3ss5clLRGXX203cW/cd2/+TwUn+y7b?=
 =?us-ascii?Q?PUY5SN+E98WDafle9Z33cb/MOymZYlAJj5amNyofZ9uH/21jwy8mXvCD4RLv?=
 =?us-ascii?Q?0PSCwgDmCRhhZTX01hpDIEHAe3qYRezRrzrR0mH3nUdKoXHohnD2wsd971Si?=
 =?us-ascii?Q?yIBgxPVeNc3KrWV1fjJlRHMA6fu+ucC6/hpszxvXRcXT0BKNMWkIvoAogWgJ?=
 =?us-ascii?Q?nMbtHj6T4T4R+bcUKurr24J8puj0rX3LdH9XFOnqrKBhkCC0Zfh8cqLoGC63?=
 =?us-ascii?Q?CdjSKqJS+HOcDEV6V4g5HClok9i3f/s7OveRW3wAq6DLNNrDVzmqGGYrIWgX?=
 =?us-ascii?Q?eHHv1dIawSuxAdebY9C84K4pJ6B3xNbPEYtHaKhXBoU1GUOP2yKXiCnwNjKq?=
 =?us-ascii?Q?0nJbW3ujA7QCHSVhWm69Mmp5NGGVW7k32F8s2WNx+ZQsiYz/AQfHrpPdtiCq?=
 =?us-ascii?Q?Opgh8S/zQ44fUU6i0WylXlq3XPAZ2DlUirbx+zXJdpXzNaeXF7Msoc/qnKFb?=
 =?us-ascii?Q?u9xPOSEG8LUwEC3QO+3EcS96LMNwyxpv3aAg0tI8UUb+dzPCcRwbvOzRzD7Q?=
 =?us-ascii?Q?Hg6KWPCTVppoHX3rTcFUAsX9kQffqkwP6DN2Q+8baG7AgDq+SGAAW/VeBdPt?=
 =?us-ascii?Q?dVHQMDe7MqpoNlrirLmHiuKybdJpGiw94H2uNpwtcsP8dA4U9RyWs2ugS30G?=
 =?us-ascii?Q?Db7II2AhzlkaylYoSFiRVS0Y2JZVUj8DsmnZIxr51nxplWDlV3w8J24fanjb?=
 =?us-ascii?Q?gRntObgIPv1ckJAasSonKJeO34HzuJnn9uyVWylRNUsQl43rom69sjnoKau0?=
 =?us-ascii?Q?MYOKH+5Uidt9EdBfGLLLlH+qpNvvaSqy6gIy1ODfAkGFiMmOMBGlerg5ZPtM?=
 =?us-ascii?Q?wgfna78KY2/qZqA5O+QjcBMn7S2pvs3bT5xdcDZhDrC1hLda/S69YWbPa3Aw?=
 =?us-ascii?Q?0k9W/pfSMFNbEsKNMHxmi6LJGUdpbQP5BfeK+pz7OSdCTfmlrbIKfW5dwtYb?=
 =?us-ascii?Q?pRk8CZt3NmTpUUQZptJdZoz7P7HBSnf6MAZWB/kEzLRz2Ub/+ztWpwEiGp3O?=
 =?us-ascii?Q?g6HNIDGaujYsUTgaBHSgO9V+KDmfdxPZRwtAIHzU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4951aa32-5706-4326-e4f7-08da6a8dc25a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 20:23:50.9860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xD528RIQ7WSVy5KSKJOouKtQ1UzFVb5dFG0eIIzAvfuc6VPcozrnN+fTApu+wb1EmyOyoPwQ9lBNJnQng7pL0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6102
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, July 20, 2022 12:30 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; chao.gao@intel.com;
> vkuznets@redhat.com; Somdutta Roy <somduttar@nvidia.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
> disabled exits
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Wed, Jul 20, 2022, Kechen Lu wrote:
> > > > @@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm
> kvm,
> > > >                       break;
> > > >
> > > >               mutex_lock(&kvm->lock);
> > > > -             if (kvm->created_vcpus)
> > > > -                     goto disable_exits_unlock;
> > > > +             if (kvm->created_vcpus) {
> > >
> > > I retract my comment about using a request, I got ahead of myself.
> > >
> > > Don't update vCPUs, the whole point of adding the
> > > !kvm->created_vcpus check was to avoid having to update vCPUs when
> > > the per-VM behavior changed.
> > >
> > > In other words, keep the restriction and drop the request.
> > >
> >
> > I see. If we keep the restriction here and not updating vCPUs when
> > kvm->created_vcpus is true, the per-VM and per-vCPU assumption would
> > kvm->be
> > different here? Not sure if I understand right:
> > For per-VM, we assume the per-VM cap enabling is only before vcpus
> creation.
> > For per-vCPU cap enabling, we are able to toggle the disabled exits run=
time.
>=20
> Yep.  The main reason being that there's no use case for changing per-VM
> settings after vCPUs are created.  I.e. we could lift the restriction in =
the future
> if a use case pops up, but until then, keep things simple.
>=20
> > If I understand correctly, this also makes sense though.
>=20
> Paging this all back in...
>=20
> There are two (sane) options for defining KVM's ABI:
>=20
>   1) KVM combines the per-VM and per-vCPU settings
>   2) The per-vCPU settings override the per-VM settings
>=20
> This series implements (2).
>=20
> For (1), KVM would need to recheck the per-VM state during the per-vCPU
> update, e.g. instead of simply modifying the per-vCPU flags, the vCPU-sco=
ped
> handler for KVM_CAP_X86_DISABLE_EXITS would need to merge the
> incoming settings with the existing kvm->arch.xxx_in_guest flags.
>=20
> I like (2) because it's simpler to implement and document (merging state =
is
> always
> messy) and is more flexible.  E.g. with (1), the only way to have per-vCP=
U
> settings is for userspace to NOT set the per-VM disables and then set
> disables on a per-vCPU basis.  Whereas with (2), userspace can set (or no=
t)
> the per-VM disables and then override as needed.

Gotcha. Makes sense to me. Thanks for the elaboration!

BR,
Kechen
