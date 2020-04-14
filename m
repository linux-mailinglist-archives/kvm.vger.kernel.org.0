Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFB61A8B38
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 21:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505025AbgDNTkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 15:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505027AbgDNTjq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 15:39:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CA7C061A0E;
        Tue, 14 Apr 2020 12:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzz6WKLYItK9cNoaIf3RK3AQB9L9+5msCkonXUnSoCBi/3xxF54NoCS4Ss+8gp5M8XVCUGT9F2XJO/I67vW1Z5hn0stxiZ6N+/mYMUpqjtApHv5gS2rBZu2UenI/JbD4k8E5BNLq92XGxDPqeE1E5P9IHfZtf5eyeKiagSJl0kK5CqefKh7thaLHWNYur/puCwQIMczt57GuCvLMRS45zlm36mRpxfVBqg+WYlDXG4FiIIZzQ9IPUQM0ujqbsvqQKjvPE2u+qjFKEkTCC3/+csYcvHGa3gKSFPrt9Ot6IT1D9f7BoXqkuFouLLqMRg5jIVfdolVxDNjE6QpDk5Y73g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU/em2oqVpN+eqgIEjMDV+yMyZKqf55fjPa/p6CV7Q0=;
 b=iHpZaSJ1GsZeoZSrKphzQJqkLURxAcC11vMuFb0i7b5cBnMtfd9546Fi68lo7YQzHiJqASvv4mF2PTTilY6eHwrfkTAp1KU+lEquaw0N5cOp68jBd1tWJfzBmKylTDETnFOPwOQFVhQKGK3y1zJvL3K9JByqR7rtbl1rmIcck59ZUqiOBXYmgsyZ40Z85xEsc0ZZeYhsIt3yF+kR3ReyMqf3TJCpYrIQCQpBJHpdLnmADkg71zQ5jS/ciR+GegG1wWdQm71OdeXR0JLXoZcr2OnvVkBQ6+iy/bjxzjEQb23lOL0Pyqr75JrAKEzwph9W7skmZRotIPgBSEgndydBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU/em2oqVpN+eqgIEjMDV+yMyZKqf55fjPa/p6CV7Q0=;
 b=WesUpgsjQ3C4JOwNXFxG6dCIKykPUKlV+K0BlT9c9P8/EbM98xBplMu1QrWf3hj9mumdoE1FZGF4u3/vwNWXWbmSJj4X/cZhtDSDiWlymh12dYaioPt6ckb7OV8xUuB6dzHg1AfELJWb3koNOK+vE+E7RJZJljXJ44nEwAMae4c=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by BY5PR05MB6980.namprd05.prod.outlook.com (2603:10b6:a03:1ca::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.24; Tue, 14 Apr
 2020 19:03:44 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7869:d443:6c46:e7e7]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7869:d443:6c46:e7e7%9]) with mapi id 15.20.2921.024; Tue, 14 Apr 2020
 19:03:44 +0000
From:   Mike Stunes <mstunes@vmware.com>
To:     Joerg Roedel <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
Thread-Topic: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
Thread-Index: AQHWEo9rgGvn/WKAp0SMYIwlFMJeIg==
Date:   Tue, 14 Apr 2020 19:03:44 +0000
Message-ID: <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-41-joro@8bytes.org>
In-Reply-To: <20200319091407.1481-41-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mstunes@vmware.com; 
x-originating-ip: [2601:600:9e7f:eac1:d5ed:96a3:68a4:b0d7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e7eb8d7-4b57-430e-afca-08d7e0a68dc8
x-ms-traffictypediagnostic: BY5PR05MB6980:|BY5PR05MB6980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR05MB69802B0E431DD7479D0CF15DC8DA0@BY5PR05MB6980.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(71200400001)(66946007)(5660300002)(6506007)(53546011)(66446008)(33656002)(36756003)(6512007)(316002)(6486002)(64756008)(2616005)(76116006)(54906003)(2906002)(66556008)(8936002)(7416002)(81156014)(186003)(66476007)(8676002)(4326008)(86362001)(478600001)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BJE39FT4nXFZHEX9l0EePiNr46M3gj+ipzLCY7IknoFcGGFCoJQuEYz0jnqSBltt74viJ/Bl5FqWG7mk2OcqfC+lQZC7rAcaVE7EeWTQfeUpTYNdjTferlcjbbUoor/eVC7gfUsomt4IGGIMBpVSIp0orb0mMi9ONn4jLGbYNU3igiVNMMbrqiUxYpqXAtnsPftYP0Czzp95KJ0Tme3V6PSQD2kLl0CDokg1+6JlldsIKgQivpy2nC6NMCvEVCYFjTohtDxTuDBQ20bdSXaDK8l9oQphLHlXiL8y2lWK+qC0F943dyIPR5FGErHxO/JZNV/ppLBQIQHK75NA9R9LOVoynpc+N1iCG17dIVAuQrSQ5wxXWIBQaqPcl2uQEkd7hgi5+9ZhtSUke0JaBt2aai0e/M6DJ1AMHU0ntwyyUgPlc2EQ+IVOFp9QyB5pilQz
x-ms-exchange-antispam-messagedata: yBX4H57CQXhyyCLqbIQ1k2CYflyb+R7XL/5RTrhqqpJ8VGTggukmFKZHNhFaXdmQ3Tz99x8TcQCRrAgkqFEg7BciISPkic0ZJjir2Oi8Jo5THtfubgK1sL+GvcTo6WAeMFAQEymsRAdmeztQHfrO+39O0l+XvxP43qlOQGaV2hFxJ1tygpTmU3enKIc4AjdL9fFMDcEFFBcd9KebRn3AVQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCC02F7E87773D41B51FCDF4C0FD1521@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7eb8d7-4b57-430e-afca-08d7e0a68dc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 19:03:44.3350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cA02r/+UqGfjEdTgA53A6FJ4xXypy0l79HjPUTmgjFsFfLe1haiynBiHKnFMmKfUOAnbTRiojdqOgJVYhuvgfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB6980
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mar 19, 2020, at 2:13 AM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> From: Tom Lendacky <thomas.lendacky@amd.com>
>=20
> The runtime handler needs a GHCB per CPU. Set them up and map them
> unencrypted.
>=20
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
> arch/x86/include/asm/mem_encrypt.h |  2 ++
> arch/x86/kernel/sev-es.c           | 28 +++++++++++++++++++++++++++-
> arch/x86/kernel/traps.c            |  3 +++
> 3 files changed, 32 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index c17980e8db78..4bf5286310a0 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -197,6 +203,26 @@ static bool __init sev_es_setup_ghcb(void)
> 	return true;
> }
>=20
> +void sev_es_init_ghcbs(void)
> +{
> +	int cpu;
> +
> +	if (!sev_es_active())
> +		return;
> +
> +	/* Allocate GHCB pages */
> +	ghcb_page =3D __alloc_percpu(sizeof(struct ghcb), PAGE_SIZE);
> +
> +	/* Initialize per-cpu GHCB pages */
> +	for_each_possible_cpu(cpu) {
> +		struct ghcb *ghcb =3D (struct ghcb *)per_cpu_ptr(ghcb_page, cpu);
> +
> +		set_memory_decrypted((unsigned long)ghcb,
> +				     sizeof(*ghcb) >> PAGE_SHIFT);
> +		memset(ghcb, 0, sizeof(*ghcb));
> +	}
> +}
> +

set_memory_decrypted needs to check the return value. I see it
consistently return ENOMEM. I've traced that back to split_large_page
in arch/x86/mm/pat/set_memory.c.
