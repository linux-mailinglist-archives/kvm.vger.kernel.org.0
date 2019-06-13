Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12E449B7
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfFMR3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:29:16 -0400
Received: from mail-eopbgr710080.outbound.protection.outlook.com ([40.107.71.80]:26016
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfFMR3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hwm1tvsKbGpRo9J2H8Em3256KGsQwcdi/VSqqm65kwU=;
 b=bR3K6vBaMftvslR+9iLuITBnrdRy8CmpCDsWjrER+a9SfapXiJehwLGGzUZoPSZ81SnWzC3FB4V6bib2rlq3dbJem4bTeEhP4M2u/gxB1jHijQEx6mFpESdd46paEbyl/Ollifv9wYR7G4fToWhXFxDBb50W3mRUX8ppZu7q9pE=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5606.namprd05.prod.outlook.com (20.177.186.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 13 Jun 2019 17:29:14 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::134:af66:bedb:ead9]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::134:af66:bedb:ead9%3]) with mapi id 15.20.1987.008; Thu, 13 Jun 2019
 17:29:14 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     Alexander Graf <graf@amazon.com>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Thread-Topic: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Thread-Index: AQHVIYeR2j5VBjf3eUa9RwR3XpurVaaZNvCAgACL1YCAAAIdgIAAExeA
Date:   Thu, 13 Jun 2019 17:29:14 +0000
Message-ID: <70BEF143-00BA-4E4B-ACD7-41AD2E6250BE@vmware.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
 <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
 <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
 <f1dfbfb4-d2d5-bf30-600f-9e756a352860@intel.com>
In-Reply-To: <f1dfbfb4-d2d5-bf30-600f-9e756a352860@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3138119f-192d-4a66-3623-08d6f024a7b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5606;
x-ms-traffictypediagnostic: BYAPR05MB5606:
x-microsoft-antispam-prvs: <BYAPR05MB560608061DABE837F6843E9DD0EF0@BYAPR05MB5606.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(186003)(54906003)(478600001)(7416002)(73956011)(66066001)(68736007)(66446008)(2906002)(53936002)(66556008)(256004)(6512007)(229853002)(66476007)(102836004)(86362001)(26005)(316002)(110136005)(66946007)(99286004)(76116006)(6436002)(25786009)(14444005)(64756008)(8676002)(6116002)(476003)(81166006)(2616005)(81156014)(3846002)(14454004)(8936002)(71200400001)(71190400001)(6506007)(6486002)(446003)(33656002)(486006)(5660300002)(76176011)(305945005)(7736002)(11346002)(36756003)(4326008)(6246003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5606;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tfM+xbizek82UJYpE3G8pFbHDAIfKne8E0piLlxImGYOVsTd/BtZ271EEEBwBUKnQvUnNFfwmQT1AWlkDaI64IcidF58phoH4FFXKV+gGo0vBj3kSsnAaqrPulXuCVHqEFuUF5hDg72K8XxAUVavRX1pXZWXlxr8VZGrNncEExqK7Hs0NTkNgUAknDyN82STOU8RYlsHp+BtEeAJRq409Z6t7EGI3WeaXa/VA5/qyObjcInqbybd8D1Dbxp6ITMC4VECnHQADw6XowyZ6n2d4iF71avLFRAzZjU0Bu/k8WE4sSB9NdS6RLPPiL2wIKWCWpBvcsLPcNHqd3aYwpCLSnGUB3Rbx4iIoqNfkaEgCjGYZakqV5ybKCcrxnN4p2TPL/pgDFyFVeAEhm6GO55EfdS9zjmTn5GBs/NNoh5UfME=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <561CA2F7569D154F92346C3F1D71EDE0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3138119f-192d-4a66-3623-08d6f024a7b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 17:29:14.0329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5606
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 13, 2019, at 9:20 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 6/13/19 9:13 AM, Andy Lutomirski wrote:
>>> It might make sense to use it for kmap_atomic() for debug purposes, as
>>> it ensures that other users can no longer access the same mapping
>>> through the linear map. However, it does come at quite a big cost, as w=
e
>>> need to shoot down the TLB of all other threads in the system. So I'm
>>> not sure it's of general value?
>> What I meant was that kmap_atomic() could use mm-local memory so that
>> it doesn't need to do a global shootdown.  But I guess it's not
>> actually used for real on 64-bit, so this is mostly moot.  Are you
>> planning to support mm-local on 32-bit?
>=20
> Do we *do* global shootdowns on kmap_atomic()s on 32-bit?  I thought we
> used entirely per-cpu addresses, so a stale entry from another CPU can
> get loaded in the TLB speculatively but it won't ever actually get used.
> I think it goes:
>=20
> kunmap_atomic() ->
> __kunmap_atomic() ->
> kpte_clear_flush() ->
> __flush_tlb_one_kernel() ->
> __flush_tlb_one_user() ->
> __native_flush_tlb_one_user() ->
> invlpg
>=20
> The per-cpu address calculation is visible in kmap_atomic_prot():
>=20
>        idx =3D type + KM_TYPE_NR*smp_processor_id();

From a security point-of-view, having such an entry is still not too good,
since the mapping protection might override the default protection. This
might lead to potential W+X cases, for example, that might stay for a long
time if they are speculatively cached in the TLB and not invalidated upon
kunmap_atomic().

Having said that, I am not too excited to deal with this issue. Do people
still care about x86/32-bit? In addition, if kunmap_atomic() is used when
IRQs are disabled, sending a TLB shootdown during kunmap_atomic() can cause
a deadlock.

