Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E9322A2B5
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 00:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732922AbgGVWxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 18:53:07 -0400
Received: from mail-eopbgr680052.outbound.protection.outlook.com ([40.107.68.52]:15239
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726447AbgGVWxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 18:53:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGdOG/zS6p49x+bqoKMNQnW/oSAUng1DZmJLEoS7KNq01O1GKoTaysV4aRM1hw3M5BsZPI/xPsICumTepdSRlKi/ICN7E4NlMoV03f2J48RRP4HGEHI61dYUwcGc0MGwAxCY9hY3MTM05a3Elh4VH7FqB+STdF62escsl9BttUKtUh/4HSSLqaMDkChDf7HJslWw9HcRV7TkrLhTEKHr3eXIkNZ1Og21Q75xYlW0/hiviJOvNfd9iJboyEifG+iQWVKyGJvnKsBoDWyOcCOyUEv5z6gJHVLz3QHyjWDfAf0tq4gTVfSWrfzHxZWTWUg3T2owFW5ivLIn1XfQ4d46ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9dmnQYw+8OpAG19bu3lH7k1jhjV2eiNtRJFcHo/Qog=;
 b=iJenZH3qltnrsMjCbR3xYrgG/Tn0Yigx92e9kkHM5OR78wq0fxMcOvKVGHUiKmazR5420qE9wN13kU15NE8N2gAkfYBIecSm4UF/TvtYstApKzOM0ly4SU5CWxXy82GiWHEnq9FTBJhdEtBqWBzjpIdYL9xgJVYzMmdSrGU8DE7Dylk/ZAUPFQ0lIFy+r7aG92DWZsyc1o/T9It/TiESzVYh4sLJjelKWySfVc4g3/eR2kkd6hBLbCb4z64guLPjjxK/AVrMiJHdwoUYjB+UkI+wONnUjcTkfJt56+ZToXbE5T7dXsWrPBAanhogtY04U26UszlF+35HMv7jWiKhBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9dmnQYw+8OpAG19bu3lH7k1jhjV2eiNtRJFcHo/Qog=;
 b=TpH3Bfin/8blXGWjnzWaX6T89G/VxAsJaP+vsLsvXbEBoOR0UpdFd1NJGHgq/kLDpKtOzKEQXQIGs2sQ9Baav8GwsepzLx7c0MCpXyiyPJkjpNDkzI/Q+gJRy02jckoSh2Fa4Nv2gTASSlDD+foOHwp/n5P5GzQu+u4W8RBCVkc=
Received: from BL0PR05MB7186.namprd05.prod.outlook.com (2603:10b6:208:1ca::14)
 by MN2PR05MB6223.namprd05.prod.outlook.com (2603:10b6:208:cb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.14; Wed, 22 Jul
 2020 22:53:02 +0000
Received: from BL0PR05MB7186.namprd05.prod.outlook.com
 ([fe80::885a:c376:7d71:ca6c]) by BL0PR05MB7186.namprd05.prod.outlook.com
 ([fe80::885a:c376:7d71:ca6c%7]) with mapi id 15.20.3216.015; Wed, 22 Jul 2020
 22:53:02 +0000
From:   Mike Stunes <mstunes@vmware.com>
To:     Joerg Roedel <jroedel@suse.de>
CC:     Joerg Roedel <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Thread-Topic: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Thread-Index: AQHWWdfdDTzyqLev5U6Jd/iJZ+m0yKkSkJaAgAC5dQCAAPf4gA==
Date:   Wed, 22 Jul 2020 22:53:02 +0000
Message-ID: <7020C1D2-5900-4AD8-ADCD-04A571DF2EA7@vmware.com>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-52-joro@8bytes.org>
 <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
 <20200722080530.GH6132@suse.de>
In-Reply-To: <20200722080530.GH6132@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:5dd4:d88d:97ba:df70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e460f2fa-e052-453e-f566-08d82e91fd2e
x-ms-traffictypediagnostic: MN2PR05MB6223:
x-microsoft-antispam-prvs: <MN2PR05MB62231424E28051203B419606C8790@MN2PR05MB6223.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FJBsnX6kJyDU3Y1u1t4Q/Z0U2cdQ+tE/uPwgEKfnDnQW7g/fJJQArtlhVG39aa6hk/cpvvyhCyPi7uknAkcb4s7fxsVPh8PlejNBOX8m0/3Pt6MQ8lkrq+E9xC1LYuFANTCW5nI4/pbFtH/f1DvFAJHTTg19MCRtMwWBogodAs6cw3vsAb0Uvt1T+RiYte5mulsc0dcwvz6JMYlXw7dxUHTLopBTamHAe5V3tEF53qZcf8VTpiXwxhJALgT432TimrVgMiD6U+WGsGvitM3oEi4lbzHaCzuBpr7ZodvJn0/hxf3b/fmn9A/4Zq6Z1hXu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB7186.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(6506007)(53546011)(316002)(478600001)(5660300002)(186003)(4326008)(33656002)(54906003)(71200400001)(6512007)(86362001)(6486002)(6916009)(66446008)(64756008)(66476007)(76116006)(91956017)(66946007)(2616005)(66556008)(8676002)(8936002)(36756003)(2906002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BX8HZnpKozFGz6+j+Nv9OGmWz6sRZ9nhQIWR73Yn+HPGeSdH8c/zEP/1FP6f6+1qJM51bedK+k8vEKQ13U2Aeh8XPZBtsqfbtIK3khSOhnQH27q8l9izMnj1IJlBDYuaD9uiTC2e6mmVElBPtcQ611Sahd0WQcyFHWDe1zVjqzqFNGeni0RrzUhmcBlkp2zpONnv8y5Q5Hd6RW2kdK/kRrxONeu71lO3fYegfRinsaZDO/28IDA/l3XKxQ9LdCiZ4nYBoUnPW05h74++cBc9Zofq7aGzNYRe4V+LLDfnv857Z+l3AdLkQNttylOE/Yi+/7FKzD+j9QC0HYSUfeS/7a8vUENr8kG60IKV0cugiRr8sj5lxr9vjNEa3FcrEtAKjTDu0dGfOdhQA3dVX3h2n/xIfL/mg5cQ62yEvtwjNSSo7HVQrp1vfZ3S4QNKRL8gY6OvhOgEP3MOf9FNVyMQeQ2ei3/zqINEulLlPizv/2WRDfRBt5lYicyMJGJPZiX0+bE17ymijyfrjzphZJNvqL970xDxReibySb3PHDne3VY2mRLjkaiFHn4Vai2e7Xl
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <51B15EE8EF8CB4429AD15694F86720A0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB7186.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e460f2fa-e052-453e-f566-08d82e91fd2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 22:53:02.4380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HTtqvKlqcRvzATVHtDlriYmOt+qVgFVaMGyimPTeeYYd4cI3NrmyHVeOFOB3TJgShq7dYCIRQilLvE+RfZPzng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6223
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jul 22, 2020, at 1:05 AM, Joerg Roedel <jroedel@suse.de> wrote:
>=20
> Hmm, I have a theory ...
>=20
> On Tue, Jul 21, 2020 at 09:01:44PM +0000, Mike Stunes wrote:
>> If I remove the call to probe_roms from setup_arch, or remove the calls =
to romchecksum from probe_roms, this kernel boots normally.
>>=20
>> Please let me know of other tests I should run or data that I can collec=
t. Thanks!
>=20
> ... can you please try the attached diff?
>=20
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 251d0aabc55a..e1fea7a38019 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -389,7 +389,8 @@ static bool vc_slow_virt_to_phys(struct ghcb *ghcb, s=
truct es_em_ctxt *ctxt,
> 	pgd_t *pgd;
> 	pte_t *pte;
>=20
> -	pgd =3D pgd_offset(current->active_mm, va);
> +	pgd =3D __va(read_cr3_pa());
> +	pgd =3D &pgd[pgd_index(va)];
> 	pte =3D lookup_address_in_pgd(pgd, va, &level);
> 	if (!pte) {
> 		ctxt->fi.vector     =3D X86_TRAP_PF;

Thanks Joerg! With that change in place, this kernel boots normally. What w=
as the problem?

