Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7400B57860A
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbiGRPHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiGRPHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:07:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2115.outbound.protection.outlook.com [40.107.93.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E104C252A2;
        Mon, 18 Jul 2022 08:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1DXuLVaJHUl09h3pOHO6qAVNtgQE5wDKrFqQIng8e3O3yVLt+uUDgQTK4QymRj22hdHMO/U3wDk+b0KHCm0TaDdr1NSAp03J8m2/nOPAyKSyYSfSxoXaxHBp3vje14fVUM8usL/gngxlIaL8GO8P/cGjau2KjXS3MipzpcBvQeT67t4mH/5W0eKSWK0fSFEHj/+aGRNgQo0qDHROn3HEOQJuMaUdTvatYHlWrt0J9wi9OsYyObfkF5ghH7cpXbtdwe+6WC5DiTBzF7bWm5tToN4Dpp3aC63FHGih1zEmDQG8mBJddKoGcnpWgtHEJvWRujnpeymck4Nz0OCJUYL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mM7zcFVmhK6dehExaBdMsgcba5eFAwHdWlbZdiI3nUQ=;
 b=B9Ehv4I9axuNi9rU/5XiWqJ+BM/F+yxfwcjKVRwydxOrZTFPkkmbVbFctNWHtxGR6eS+CzKro5WYoi7Fep9vwsxDHA9HM2kuqQO9xCAAVg8q33m6mNpRIQWCFyhecUCGtkXbR3aFhNENoqJ0hFEPa8uMtQc4I9lGIx+BQa28XoLtaur5xRhhSBaAHmSWOP7PKX8PNVOM9d1mBpjPiCClaWKYmW8V6vY/ouU5PP93bTNZPF2bPgdLOjg9tl0vPB3aosvqvua0J99vgvVtngqjtSN+vrRBCrdQjeuG7pK7NEh+pNQayiai6u6TtmSaOhoRv2x4cHANWLu1zJB+L67Y/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM7zcFVmhK6dehExaBdMsgcba5eFAwHdWlbZdiI3nUQ=;
 b=Fr8aqauViOzj0sRRmo8Y5L+2OLQLQEQ5bAjaYHyK73HbaADGn/+V+0w9vsLEm9nZV9m8QPzdf5+OOuyuCNi9QpW+darug2oOltomSWEWnZOc8fZ9byde9lAqWncgWeOIXVlOWiNIOZC6pVLnBI+KprnLSZDFnXHDOX2u0vYJxmk=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by SJ0PR21MB2054.namprd21.prod.outlook.com (2603:10b6:a03:390::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.0; Mon, 18 Jul
 2022 15:07:31 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ddda:3701:dfb8:6743]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ddda:3701:dfb8:6743%4]) with mapi id 15.20.5482.001; Mon, 18 Jul 2022
 15:07:31 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: RE: [PATCH 0/3] KVM: x86: Hyper-V invariant TSC control feature
Thread-Topic: [PATCH 0/3] KVM: x86: Hyper-V invariant TSC control feature
Thread-Index: AQHYlsoof1I81kCJqkmkNtMQAlF4rK19mWmAgABelgCABklAwA==
Date:   Mon, 18 Jul 2022 15:07:30 +0000
Message-ID: <PH0PR21MB3025BBC14E4BB4F2435B542FD78C9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
 <00c0442718a4f07c2f0ad9524cc5b13e59693c68.camel@redhat.com>
 <8735f3ohyb.fsf@redhat.com>
In-Reply-To: <8735f3ohyb.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=22d094d5-016a-4d8e-8efd-9154d9099880;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-18T15:02:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b682764-eba8-4d4d-2c94-08da68cf3c93
x-ms-traffictypediagnostic: SJ0PR21MB2054:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eFrJYXnu6T744prIRg+tUV2HdpcX2QOC9y3sjG35On8Lo3BssVVQzEMGRdICWt/r/qyaQ2xew9V9s8VWu4HLgbCeB1dhsPIziLpOFDkRvNvngTcv+m83gV3rfnd6FHpRhttreLQwP4uw3HpyvGO2ZwQ8sJl0pkgLvZn2aMgRGIscj7++YFBctk0mh0JheD5CZM0gOyBuQYtAKQ9Z3SoBKZDvONrcr8gGlzxXCuMvUT5u1SnPigDThMdfxaTZQ5duRLA/8mAyHNkGCPM1r/xbRDmWEIS2iDOb8a2U2d4cXMLSxQvP4poiFA4SwezlE0F9h4EvIeSCNtGC+Ix/TqmnXe7o0b1UHz4kzQu18EbTLWo9n/PyVk5YYn2YjOCI/4UAI+zKEybIXk1Pk5JRmO4ut/2QR6XB3yLhLE7UV+vm9TEBAYiNRmKw6vEOGKF4E2odRx4awgSaF/Cgondox7dsOtbP03wzPvM6bZhAEChb44VTYbv56gT56OGzo208WTfjGMEirdGc6FjYZ3V/nPvgc4gdobq6Oud8kTuIEWm2O7doGBpfQsCANh19TK4x8ykqhB9Hmiw2QCPdy9y7zVOlPRgQDFC2tGcqEy0RosUkBg5/C8g6JKPL1wpw7aTawf6wgq0qBctqGkLmKk48/TYq54tY47S4dpiz3TLW3cyyOjAr61PaUX+FTGVO6FCqud6jiPkvPEjph4TLUEe3Ryg69S7mV7i6yiVuNonx5L6IuHGRRDo9CwDup1Mos55z0ryO0csh/wQTvLNDVH56awmKKzzfHpTqNalJpWisU2AayT0/P8TV5cIplCKAYdTPdPZfh2ELPn2EAyBM/SxnRHHQtzHc856ASjaah1AjRlM27TDX++u8uaDWOsNm9VZlAeWfjtJpW3THXRGWAFQ0XEMtmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199009)(186003)(26005)(6506007)(2906002)(54906003)(316002)(83380400001)(110136005)(9686003)(7696005)(8990500004)(82950400001)(86362001)(82960400001)(55016003)(38100700002)(38070700005)(10290500003)(66946007)(4326008)(66476007)(76116006)(122000001)(52536014)(8676002)(33656002)(64756008)(66446008)(5660300002)(478600001)(71200400001)(66556008)(8936002)(966005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ii88OoO62WSpArEQTHSFUeNrzJtLoITVZm4uH9om1Wn9TyLuoXWq8ThYfnhJ?=
 =?us-ascii?Q?iqeHl0ch9WtgmWkLzChJBQDhCxZlTq4xA7Qe41A8oTc5JvnMnS6tjbV80T1q?=
 =?us-ascii?Q?9STMjLrRKRNxkXFigbHFmvbOTtbdCrca3i7siiWHn3avYFNMjNl3hvGtSN7c?=
 =?us-ascii?Q?NT8d/iEj8sMJqrvfUv/YZGUJm/9R0QTCZy5gKNkb/00eYbwd24+3DHjxdGVi?=
 =?us-ascii?Q?O6WmBEheZG0sso7twRnKvLk+Idtfbfl1Q9LEEIjkjI0b+vVLwr8/eSrIFIVT?=
 =?us-ascii?Q?4YOcdw739kcQ+jVQNOU90mfXf8JMOF46AxHn/nBXz9KcYmlhYuHkKh5gfEIb?=
 =?us-ascii?Q?5MXjDpNmJy94kKXKaxIjc5N2HFU9+CGmMm3BCI6xFKcQ/FfZS3h6VSS1ADAz?=
 =?us-ascii?Q?IrMU5S6Pkx/9aogt3kDzAADmYTvVHNz6s8jQpGqo3dcOR7NSWM4HDlJ4PQZh?=
 =?us-ascii?Q?gtvC/gQB+2qTelQbm2MQB4OA2f1GLju+M/c5eeoeD476mf5LfPmCk+n8XOZP?=
 =?us-ascii?Q?eYvkcU/r72L1RwDe/b4G0aUf7fCSGaLiQBe3tlAeMNk4i8yPKO0I0z0ieR92?=
 =?us-ascii?Q?s9TXasuIfouhwbER6g0SoBTf2l8yCWvWeFIOVik9E1lwRVMceGtMXJ+DB7at?=
 =?us-ascii?Q?UC3pkJYKGQl3zJ3UzaOoR6A38VEm77/dlPD38k0IEbU5TsuzrgSgW+tDDaC1?=
 =?us-ascii?Q?x91XT5QirP/KMFtwJX6namL2e0/hW+uYkSDszfuOw/B0Bbnx7driADZT/3KP?=
 =?us-ascii?Q?O3/PKxn2NpLS+cLpqaTFW8/zGKFJsIFrC5wJo3GE9axAbxiyadStlwaN7VDu?=
 =?us-ascii?Q?XAYRzq7PwiyeeZ9EzorVEFN3/yeqrD8m+NnwpzoKABZkDZdx/FUPKFqVWGk3?=
 =?us-ascii?Q?qplLnavBuw/Mi7PrhukLgXiIgSbNCckAqNTpJ7+guYFyyhP+jORO7kp8e2fh?=
 =?us-ascii?Q?w4nFc/tblM2oN6YUbx8Wqo6UrlLQSKAdzc6FRB5nFz/j8pNjWJhYf0bloe78?=
 =?us-ascii?Q?qEICafgirXsIyskHrg5nIHIo90vVA4CPRHacKaUxfUBpJDLgri/XcNx5EgMc?=
 =?us-ascii?Q?piVC9M4DdXFw/2BEXiRkGtr3Szos/tC+KQhb2BhieOS6qsN9Fisv3yCh9Awr?=
 =?us-ascii?Q?1T3FIPThAFxRebcZjDk9KA7MUTozHdZsFxk6wrukg+utQtAzav9GMML8gilP?=
 =?us-ascii?Q?7jFrMstlQwVHkHmh7tOSo2gKvuJQJRPIZW2M7UJSAkH5ZskeKpBcfZVpdGc9?=
 =?us-ascii?Q?W9qj7J/5Z6+3STA6UMXMHE5zI2GHoRxZfUcXmigYqkKsa5Ohuj3WG+/iH81r?=
 =?us-ascii?Q?pFBzDTVyznGjrWvNf+Wlms7Js5doBdYNxpAAwXXBsvwgMP7jwm1JY5meLnmL?=
 =?us-ascii?Q?/S1wbOXn9YbEgXYYYIVLDGbhO9+fjVfwfzjUFWcHPrhlWoejE+dUeKzO9DwJ?=
 =?us-ascii?Q?9kze24eLDWdsmbpkhIxMTnvr1P+2kmLI90do43E/XuK9ARM8aHuNmrLQMa96?=
 =?us-ascii?Q?dsuXU/3SZsHw4aw6MTiSRl38AUfM3CuOwpd9oYAuxVUD0IJ30YwMuWQHzkPV?=
 =?us-ascii?Q?Asd858DaURF9YEStC674fhjhk7qDzftKEPtgtp8IbQsfu9PYmNE/nnMD+h89?=
 =?us-ascii?Q?6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b682764-eba8-4d4d-2c94-08da68cf3c93
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 15:07:30.9831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e3c9BGRO+l0jhZMgkIYX6bEJEOiHl47VqfAKu4dfq76FVVNHU7vqhOVQyEeaL81SzEgZBDo3bBsI63AdkkCET2MGuXrvXOQimuzflP7JXfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB2054
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Thursday, July 14, 2022 =
8:03 AM
>=20
> Maxim Levitsky <mlevitsk@redhat.com> writes:
>=20
> > On Wed, 2022-07-13 at 17:05 +0200, Vitaly Kuznetsov wrote:
> >> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
> >> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
> >> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
> >> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of =
the
> >> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the
> >> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded=
.
> >
> > If I understood the feature correctly from the code, it allows the Hype=
rV, or in this
> > case KVM acting as HyperV, to avoid unconditionally exposing the invlts=
c bit
> > in CPUID, but rather let the guest know that it can opt-in into this,
> > by giving the guest another CPUID bit to indicate this ability
> > and a MSR which the guest uses to opt-in.
> >
> > Are there known use cases of this, are there guests which won't opt-in?
> >
>=20
> Linux prior to dce7cd62754b and some older Windows guests I guess.

FWIW, the idea is to avoid having this new functionality magically show
up in existing guests when the Hyper-V host is upgraded.  A guest OS
version with the code to opt-in has presumably been tested to make sure
it works correctly when the functionality is exposed.

>=20
> >>
> >> Note: strictly speaking, KVM doesn't have to have the feature as expos=
ing
> >> raw invariant TSC bit (CPUID.80000007H:EDX[8]) also seems to work for
> >> modern Windows versions. The feature is, however, tiny and straitforwa=
rd
> >> and gives additional flexibility so why not.
> >
> > This means that KVM can also just unconditionally expose the invtsc bit
> > to the guest, and the guest still uses it.
>=20
> Yes, this feature doesn't bring much by itself (at least with modern
> Windows versions). I've implemented it while debugging what ended up
> being https://lore.kernel.org/kvm/20220712135009.952805-1-vkuznets@redhat=
.com/=20
> (so the issue wasn't enlightenments related after all) but as I think it
> may come handy some day so why keeping it in my private stash.
>=20
> >
> > Nitpick: It might be worth it to document it a bit better somewhere,
> > as I tried to do in this mail.
>=20
> TLFS sounds like the right place for it but ... it's not there... oh well=
.
>=20

I've sent a nag email to the Hyper-V folks about updating the TLFS.

Michael
