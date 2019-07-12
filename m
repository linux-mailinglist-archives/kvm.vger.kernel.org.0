Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D4E67355
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGLQdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:33:53 -0400
Received: from mail-mr2fra01hn0245.outbound.protection.outlook.com ([52.101.140.245]:9760
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfGLQdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9afiulhk4NdHMDr6pW/IAgLc4n6/zkN0sBRnhhRkqA=;
 b=Asnie40YXEyj41yLNrW+eKyBshoQBpIGxC5SO1FEordGkHrWSTsEw8CUqQID4ZF+Z1PMy8Uwlk8MD3KCvt7czVlO+vG2QYw3nFIo/vvNPTQb9hVHtUOpbjkLTU8aqehG52uU8kXDEyeGdBAca7lv5kffVSAJTVw2k8jFPeo+CGs=
Received: from PR2PR08MB4649.eurprd08.prod.outlook.com (52.133.107.81) by
 PR2PR08MB4858.eurprd08.prod.outlook.com (52.133.109.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Fri, 12 Jul 2019 16:33:41 +0000
Received: from PR2PR08MB4649.eurprd08.prod.outlook.com
 ([fe80::bd59:a723:4d09:9e88]) by PR2PR08MB4649.eurprd08.prod.outlook.com
 ([fe80::bd59:a723:4d09:9e88%7]) with mapi id 15.20.2052.020; Fri, 12 Jul 2019
 16:33:41 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] [v3] x86: kvm: avoid -Wsometimes-uninitized warning
Thread-Topic: [PATCH] [v3] x86: kvm: avoid -Wsometimes-uninitized warning
Thread-Index: AQHVOLv8OwY0NkKxKECiO39u9XcS9abHLaSA
Date:   Fri, 12 Jul 2019 16:33:40 +0000
Message-ID: <20190712163337.GC27820@rkaganb.sw.ru>
References: <20190712141322.1073650-1-arnd@arndb.de>
In-Reply-To: <20190712141322.1073650-1-arnd@arndb.de>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.0 (2019-05-25)
mail-followup-to: =?iso-8859-2?Q?Roman_Kagan_<rkagan@virtuozzo.com>,=09Arnd_Bergmann_<arnd@?=
 =?iso-8859-2?Q?arndb.de>,_Paolo_Bonzini_<pbonzini@redhat.com>,=09Radim_Kr?=
 =?iso-8859-2?Q?=E8m=E1=F8_<rkrcmar@redhat.com>,=09Thomas_Gleixner_<tglx@l?=
 =?iso-8859-2?Q?inutronix.de>,=09Ingo_Molnar_<mingo@redhat.com>,_Borislav_?=
 =?iso-8859-2?Q?Petkov_<bp@alien8.de>,=09x86@kernel.org,_"H._Peter_Anvin"_?=
 =?iso-8859-2?Q?<hpa@zytor.com>,=09Vitaly_Kuznetsov_<vkuznets@redhat.com>,?=
 =?iso-8859-2?Q?=09Liran_Alon_<liran.alon@oracle.com>,_kvm@vger.kernel.org?=
 =?iso-8859-2?Q?,=09linux-kernel@vger.kernel.org,_clang-built-linux@google?=
 =?iso-8859-2?Q?groups.com?=
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR0902CA0035.eurprd09.prod.outlook.com
 (2603:10a6:7:15::24) To PR2PR08MB4649.eurprd08.prod.outlook.com
 (2603:10a6:101:18::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b52511f6-026a-44a8-9d68-08d706e6b2bd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:PR2PR08MB4858;
x-ms-traffictypediagnostic: PR2PR08MB4858:|PR2PR08MB4858:
x-microsoft-antispam-prvs: <PR2PR08MB48581818FA56A2AC67EA1015C9F20@PR2PR08MB4858.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(396003)(39850400004)(366004)(376002)(346002)(136003)(199004)(189003)(9686003)(486006)(71190400001)(54906003)(86362001)(52116002)(229853002)(66476007)(11346002)(71200400001)(446003)(4326008)(476003)(66556008)(66946007)(66446008)(102836004)(6116002)(99286004)(64756008)(5660300002)(76176011)(1076003)(2906002)(66066001)(6246003)(3846002)(386003)(6506007)(7416002)(256004)(14444005)(6486002)(7736002)(33656002)(186003)(305945005)(25786009)(8936002)(8676002)(58126008)(81166006)(6436002)(6512007)(81156014)(36756003)(478600001)(14454004)(316002)(26005)(6916009)(68736007)(53936002)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:PR2PR08MB4858;H:PR2PR08MB4649.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DUHjzF8xn6KxWkFEtJ5fcjsBq87O+7SjGXhR071X24NjHdnOZnmEn1PML0JGZsfSGVR+1bficd/V85xq77HSpIpRF6TTre2IYwAqNS2r2bdlky8/nwNI1c1MPu2FLeBOwR9Vg3QXXVERUcGHnDg5CXO7HbpPrKd0S0yQjSdllJlaB7WX8fqXiMHt1m95/IVKCYYiI3KSpPu2tjxrM0duCmFsLfYmC0DXkVwX/ntBexctyPaMy8J8xBk6EsoyE6NDQoyPGmEoz8f0MaJR10CdSuDJVkRmFzw0yNhfIzAM7RT3Se+bT4S1IevcAZ93VTvjWxTZmGu/5+h0BzjkI9JV8i1buRIFz2aCNA4ky8XqokW6/SY5ibmPAE+keDWXkdvwLNf2O7hho2ZYC644Vic2C4XQ1ALPzEUry0kZuIP//WbxmuUMpySyzhXOIbHdYRAsBPJIIuL2h0HZl9Kf0vJ+bCqfcolHNZ6Adz8CqnPyX8OqK1F+ek0+XDv1MGdd87ya
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <2C580450432E7049A59CD5C781C455B1@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52511f6-026a-44a8-9d68-08d706e6b2bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 16:33:40.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkagan@virtuozzo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4858
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 04:13:09PM +0200, Arnd Bergmann wrote:
> Clang notices a code path in which some variables are never
> initialized, but fails to figure out that this can never happen
> on i386 because is_64_bit_mode() always returns false.
>=20
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitializ=
ed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (!longmode) {
>             ^~~~~~~~~
> arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
>         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgp=
a);
>                                                              ^~~~~
> arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is a=
lways true
>         if (!longmode) {
>         ^~~~~~~~~~~~~~~
> arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to s=
ilence this warning
>         u64 param, ingpa, outgpa, ret =3D HV_STATUS_SUCCESS;
>                         ^
>                          =3D 0
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitiali=
zed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitializ=
ed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>=20
> Flip the condition around to avoid the conditional execution on i386.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v3: reword commit log, simplify patch again
> v2: make the change inside of is_64_bit_mode().
> ---
>  arch/x86/kvm/hyperv.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
