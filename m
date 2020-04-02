Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FC719CCF8
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbgDBWkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:40:11 -0400
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:63035
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbgDBWkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:40:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFFqRcdA44J7Ou6aGhiJqTMFB5AQ351wvQgF/JQVfL5TZu8F6e5Un/IlZzsrj789SPqBEgETH0rb6As47XFvIXTpEzUnR7hKAI2GRkaXT3U1b80WvOAgBdinBQVrukl4uOsTxJLUkeylpzPvDk3sILeVzGEQgw1QcQmBFIftP2yR0qdxm4LIbQD7Tvw1FGV1TCTVhoK051KzL7n4tL/Cdvd37y7aDKGg3GjDWllR3RJh5DwFemB4QtMCAwnZgyuOlOL/r+JFMq4tA3J4m2KGSIXJvkVlgoaubiQcalfxtvqahLrBww5Zq16WLq4AwvkF19TGqpfIKkoual/5I2Ob1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAp0vtzjOQpkeTIeQTGLAtuUivih67trTBGbvraGinE=;
 b=NsdyFyEcLXKb9K8u+nvTTkXs4X9QDij9d8CSpHZ3CWbwRXlQKCY/qLGlWC/mK9US1ET8nWGsgF4QSAsGGmJoV/R9XeNEYdQOLx2ZfNxz74riFqDI358tcXqtloPopkr9kupknt3/Vo6XV+WGtaBt9Mb79or2NI6vWWdhGcONlSGiVEGM3Py45omnRuiqzZ0X7xx8RUW4Dz2zKXqffM20pOs5FKwtuTuFlvEEM6bK8laX3SW1fl5gO0cKDGqkuMPafoGsM8lBYGG7UG7N7F+IxA9Ite/kj3cL+cJQS+puXsetRn5OIpxmso4oVKuxvkanA42kT1VDEEH5dz1W4kOTIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAp0vtzjOQpkeTIeQTGLAtuUivih67trTBGbvraGinE=;
 b=JCgd/WJdY1amdP2dgeHKK6ee+7XTQhnAdCLLXmsizrmepZ9zzCFICI4Oa6kemvG5aNxTSPOqeF19VML4uZUVXI6nAb6IYGgz++OKLzJPvz6QmoL3MVRd+HPT/OkKlIqeN15fzGsBLQ9IsHC1kB66LzPZlQZNDeLbrSVXDJa7Yk0=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5830.namprd05.prod.outlook.com (2603:10b6:a03:d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.13; Thu, 2 Apr
 2020 22:40:04 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331%2]) with mapi id 15.20.2878.014; Thu, 2 Apr 2020
 22:40:04 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86 <x86@kernel.org>, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
Thread-Topic: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
Thread-Index: AQHWCQdVCOEtAzs890KQwn8WlTwdmKhmE74AgAAFxYCAACkAgIAADE2AgAAaygCAAAOjgA==
Date:   Thu, 2 Apr 2020 22:40:03 +0000
Message-ID: <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-4-sean.j.christopherson@intel.com>
 <87sghln6tr.fsf@nanos.tec.linutronix.de>
 <20200402174023.GI13879@linux.intel.com>
 <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
 <20200402205109.GM13879@linux.intel.com>
 <87zhbtle15.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87zhbtle15.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [2601:647:4700:9b2:d4d:4118:4ac2:ab78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd30232c-d408-4ccc-f738-08d7d756c950
x-ms-traffictypediagnostic: BYAPR05MB5830:|BYAPR05MB5830:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB58303F2FB03B0CF0F7E0EE65D0C60@BYAPR05MB5830.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(186003)(6486002)(2906002)(76116006)(6916009)(478600001)(5660300002)(81156014)(8936002)(54906003)(4744005)(8676002)(36756003)(81166006)(71200400001)(316002)(64756008)(4326008)(107886003)(66946007)(2616005)(66556008)(66446008)(53546011)(66476007)(33656002)(86362001)(7416002)(6512007)(6506007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GeZkwBi6bxcUto5vaV2FD17aIMWa2b7iEckG7z4LzYqNbbXbxyrAt3A28c3brcsd+c8/BBA3dovJQw4RZkaWmPwjKi2jqF/RNV3nZ0lKKhdflUY9zb4PaWQq/XMAr0aY0sUvJKNUprnY8WV4BVlGO77XfsX4DyIE3rpqLsV/ggOfbq+z3oIrTzeuXqY9fWEJ67UgtAIs7lYEqjjPRpCRlEy+s1RefgHKbTb1sEjkJ1+aHK6hSZGbQ4BpSUEGTtFFQDYn/kw1dt1flyFlsZeJ23sJQpvbgMeytmB/XdpijHa2lOYbC3g1Z4L/3gWmpFVCHwl6i7DsDdEXLiiKTfTkh4qa0uA5Na5HNIUe/J3tTcsw73HjWpde7PLZ9qJYXS3EnyMQ1ePUcsNSj/ZamKBr2RwS+Iunzkm00A+YBC28kGVpL6VeEiHPpNAi82WAMJxJ
x-ms-exchange-antispam-messagedata: bHmiKmkan6fIP0mav4YNVgxanjHJmvuHWea4XG5MtpfFHQRc2d0qLxlDi3TEAh/juC9sbHXo8ZKJgyP/xpFQLgr2N4Mzmr3LWAR82gIAqtqbF9TJarmnbAcCJifFC/IPq+1inAbU+FJu0lcowNUC+GU1G7j65+zluuE6ohMzf2e2Rcq043bPr6L0aFirQMiMQgOLTf636RBnKN7NFUhI7Q==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D658E5E2E915E84C97278C728061BE14@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd30232c-d408-4ccc-f738-08d7d756c950
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 22:40:03.7822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RipGUl6VjmSJB3IeFsf/uvmeNcmcQ2WxOsyPU1nlyGRUT5qvUIo90fQNBKeiMDCNLpHxR7zeqU0+bcOAGG9UeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5830
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 2, 2020, at 3:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
>  As I just verified, it's possible to load the vmware module parallel
>  to the KVM/VMX one.
>=20
> So either we deal with it in some way or just decide that SLD and HV
> modules which do not have the MOD_INFO(sld_safe) magic cannot be loaded
> when SLD is enabled on the host. I'm fine with the latter :)
>=20
> What a mess.

[ +Doug ]

Just to communicate the information that was given to me: we do intend to
fix the SLD issue in VMware and if needed to release a minor version that
addresses it. Having said that, there are other hypervisors, such as
virtualbox or jailhouse, which would have a similar issue.

