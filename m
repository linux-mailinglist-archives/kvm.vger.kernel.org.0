Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D595E279D24
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 02:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgI0ASg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 20:18:36 -0400
Received: from mail-eopbgr750138.outbound.protection.outlook.com ([40.107.75.138]:40005
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726426AbgI0ASf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Sep 2020 20:18:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaKX6EweekmV8v9gXHcEb9fQ0vHuRPdtTL/lLNGr7Ij3bHNEzNKmi+CTCjVfNkrx3XRii5lHRhE/bRT7TLAq4BubTgi4QyBhFricO9MHdsPc/B3zJY/4TEUZ/fmnq8P6RLXhBfiHMSddujw1S+YHjxVWUt0lyM8VDSaziST6SMjOgo4+478+dfKh5ZbBAhejXDajcnrnrDxZztjatwcIZWXndbK0sS61/X/H0gdZbxA/h1tqxp2+VlsKnBsycsNwS36ay45FevgYFyMkgJvWye54m1MwJ6kz/2ud7QahHTGkQVQYDO0c1ZKr6WZu2ZxRcldVWhmOwuKgQdjLAREkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67+CDl5yP75S43Le9/llTiHJx3sXvsJYvyeQpTwH9Qw=;
 b=PcR+Yw1W1ro/rVrJ3Axp0JSqgVZ4hPylDACHy8/BQuX+Jef4dQK1IXbEsz9OXZIPAxP3cWiEFstUItKdp6CHX3+uyuasbR1yOo8loiXklEUjs2rRRYTJj5ntKHRkMkzVsAyx2a3SUzyH2/WJ/B9D1rQs2u58Qwkcc+YKqB3DaCG8BjcyBbX05aCrhQj7ycr9B+WRws5oKqElhVTTd+anwjpYrgVBjzIpifRALRmr2BDQ/PyL0Pfop+P7gE7uspndEc2W6rPP8s3HF5BOND6ISWf+W7a5Hba3F6gctgbXLl4zKKjaysnycMbYgq4WjY0L9EhLVfp+8FvKs/IkWhDPiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67+CDl5yP75S43Le9/llTiHJx3sXvsJYvyeQpTwH9Qw=;
 b=KnIcJVouFUIAvDlhaUxTAvsIrHg77z+FIAa/yowj5rYrCD+txI5MBQOl9qmu1bbifcj52ZjKDZcT9DlwaXisWhCTSCIZhZIFGFXWkZN/95mGXE2MuhxrfVFBNmRBPjjgxErVJSKItPzGpuyg9EHV97TLZzhwGoA69cSNK1F5PKw=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0731.namprd21.prod.outlook.com (2603:10b6:301:81::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.18; Sun, 27 Sep
 2020 00:18:31 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 00:18:31 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        vkuznets <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] x86/hyperv: Remove aliases with X64 in their name
Thread-Topic: [PATCH] x86/hyperv: Remove aliases with X64 in their name
Thread-Index: AQHWlBEKxEisZQTT3UK9Y8yazUtcyal7nviA
Date:   Sun, 27 Sep 2020 00:18:31 +0000
Message-ID: <MW2PR2101MB1052912692515787D192F6E4D7340@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <1601130386-11111-1-git-send-email-jsalisbury@linux.microsoft.com>
In-Reply-To: <1601130386-11111-1-git-send-email-jsalisbury@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-27T00:18:29Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1c1d70a0-0a68-4b48-87fd-082f93f3aadc;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5bc0e02-8ff2-4285-7665-08d8627add85
x-ms-traffictypediagnostic: MWHPR2101MB0731:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR2101MB0731B2EA923D1D3290F0D238D7340@MWHPR2101MB0731.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3XSrrDGeTO1qFbL6lUmvfDQcihfFfWE9PXpFQ3dYNuqzQiciCDaAeE6bAAzw7Iks+0eIBGbV6kxRkrikmXohr1ZNDdvlPuQpLOONGeUxGnVw/vw4Kq8yNKjMl2KUnLUzaz83spwXu7cep4WTqpbp0D+YvKuQp+kTlJy/Zi9r7O3k7M8D+f5L4yc/m+TJJW8hXIeLqvE/VtZsvjKOf8lcKZTS+3VbdZVa04LHr+oYc2qrDZW9KL1to/bFivmSe8R8vnj/UqeEx0TPzX0/QVDzwugASubeem0I/2d7Cc8E+4V69tYcLD/IIyD/Qp/SGqHY+bWFChQBmLkH2tCKWR+OUoX5q3YGfAU0apF5jDKcNUnIWQrkUi3zytPQGWntqP7P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(316002)(186003)(8990500004)(33656002)(66946007)(76116006)(110136005)(6506007)(54906003)(7696005)(71200400001)(82960400001)(82950400001)(83380400001)(8936002)(66446008)(2906002)(9686003)(478600001)(10290500003)(86362001)(4744005)(55016002)(5660300002)(26005)(52536014)(64756008)(66556008)(66476007)(7416002)(8676002)(4326008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jXGclzbeuHcPSW9GLcArAurk7ifO5GLmGZe/mmEsH9J2dcY7KNo//8WN1uLxllpfXZB93wOK3abPDmIYfjsSkWQIduTKNwTzllKKXu63pQK1wP8z/BL3IP8/QKJ8NtbR4JNhjNn408kTyalq4J7MW3fl1CxZabk4aWTH+JWjBNw0fUxUhCnS4TybgbalWECnvoqftAnr+t1DO6mIUn308P1YwyF1YCXsDdp5W+iAoCDjgTvhH3Eth3D6ioiX+mJ59FyKokZTQhcezQIzpIQfFKMlrvhnn/6HdM+4Dnn4aMOsW+Q3VeuhANpRHVw4V1FQrl0oS6Ht7++ycrGCs7jRd3i8DzXSoKNHYaaKJMjHbsX0d2WRrzBvaDLXPtS8BOE/APqKHEu1Twm/xEYi9ho+U5WM617FNvU8DIBfnvyjUJe1TBGV1GG+DRuKgTwW33j3q4b5o3CvRjO26JW/zmz0zRxjG9IkfFz9189K0/KEWqahCa5fYf2Vlf9qDnUmazWg1lRlnDH2fY+19GXioh9ql90OSbQ3F8o9LckXk3AzT+JqxFMQgf8MFQYK30R2OmWEQ8eZY77Q52hjCHkpUb87dBgWqxHOnaUdQLMNNHVK6FxMFnPu2BYie4x08LmAMKt+qUXZKIcP4FQLuOaFiiaOoA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bc0e02-8ff2-4285-7665-08d8627add85
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 00:18:31.4289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rJvt5nEXiMukN0AqheOeFuLRgNYpdm2KoK/iqercfx5uCFHkxwBDJvpVQMUA85a4xDOdwz1oQSoxeIl+XlChnTuEGlljXUplvqnVHQrfs9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0731
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joseph Salisbury <jsalisbury@linux.microsoft.com> Sent: Saturday, Sep=
tember 26, 2020 7:26 AM
>=20
> In the architecture independent version of hyperv-tlfs.h, commit c55a844f=
46f958b
> removed the "X64" in the symbol names so they would make sense for both x=
86 and
> ARM64.  That commit added aliases with the "X64" in the x86 version of hy=
perv-tlfs.h
> so that existing x86 code would continue to compile.
>=20
> As a cleanup, update the x86 code to use the symbols without the "X64", t=
hen remove
> the aliases.  There's no functional change.
>=20
> Signed-off-by: Joseph Salisbury <joseph.salisbury@microsoft.com>
> ---
>  arch/x86/hyperv/hv_init.c          |  8 ++++----
>  arch/x86/hyperv/hv_spinlock.c      |  2 +-
>  arch/x86/include/asm/hyperv-tlfs.h | 33 ------------------------------
>  arch/x86/kernel/cpu/mshyperv.c     |  8 ++++----
>  arch/x86/kvm/hyperv.c              | 20 +++++++++---------
>  5 files changed, 19 insertions(+), 52 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
