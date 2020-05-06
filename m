Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392B61C78FA
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 20:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgEFSIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 14:08:55 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:2528
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730058AbgEFSIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 14:08:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC2UB5bqgPSeNdFI4YFeG05b0jKznX6Wm1rAwOA6dzVzvYYb/iS3amNIIUf7esgDM167iNVwT41s6U+WfAB634Dh//X1ep2484lY/sOq7L6X0e/vQkUZwMKFauftng0QUBTas1KGLgob5bo8MRDEFApc9z56DHR/3tSpizBDJejLdy8ZwqYhfqXW88GtRvrLIcvspTUPb4+E5U4bExGyu8fC9ZWVIlSwnOJB4F4Ox0BxCjoOxcKXPzN/1UuoDGKeFEOhjRQIrd+nWrZcsWOPXX7Z3myBzxLsvRrPESgj1rtz5XU+EmIKxyCAjhLy6I9dv3DKYmnpEkP5j/LxLQSoTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b/kjVUrjfROKCvrrAkp8FxEALNjp+UXo1ASgrzTXr0=;
 b=oe+/V8IHdic6me5bKUhpNhyPKjn8PBYenRGfWF/142acH/kImNxE145jFn87JPed/4sIjOVm6lTI5aywliTWdEyuw2JdzWpNyE8PoRor36DK6vM1d179wj2v8zquv0phlrDcRoFRSytMZRFWp9e0n8SOhCkXdwrlrjdOGbqs4J0NReHxEhvbEluvBOXaGCepgFu08LZdc10BlGZj+LlGI8JQCJp+en72RdwdH/rh5uKOOeK9T1VoJ0v75uamResvZRlxxUfDjLb3ytiY7ZElJRx96zFo0BuRAWhx7fKo76mYbEv21JIiEEiJUMKISttVFXyBtOkjUTcpi7VnHf0Pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b/kjVUrjfROKCvrrAkp8FxEALNjp+UXo1ASgrzTXr0=;
 b=Gxk4eW6tz56eleqCeAZLi7DQgJRpmT+YIJoiWXlt7kvWwht20R95iUVBnXhEF8QjVdiv/4vAM0p/AtUCgN5Qdg9/sLv44LihD98q9N0vgL9SKm14UEPhSU0O7vCL2IQowk/ImeYcyshFFSKSRfECBq58/ecvR+Q8NdKw4Emmo6w=
Received: from BY5PR05MB7191.namprd05.prod.outlook.com (2603:10b6:a03:1d9::14)
 by BY5PR05MB7060.namprd05.prod.outlook.com (2603:10b6:a03:1c8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.11; Wed, 6 May
 2020 18:08:50 +0000
Received: from BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7869:d443:6c46:e7e7]) by BY5PR05MB7191.namprd05.prod.outlook.com
 ([fe80::7869:d443:6c46:e7e7%9]) with mapi id 15.20.2937.041; Wed, 6 May 2020
 18:08:50 +0000
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
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
Thread-Topic: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
Thread-Index: AQHWHXBA/P+Yd8hdF06d40yxuusaNKibZ+eA
Date:   Wed, 6 May 2020 18:08:50 +0000
Message-ID: <ADD6202C-6743-4C05-B9C9-952BC45C215D@vmware.com>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-65-joro@8bytes.org>
In-Reply-To: <20200428151725.31091-65-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:600:9e7f:eac1:4d6f:2c58:1ea4:6d5a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d12544bf-a848-4f25-0979-08d7f1e887cc
x-ms-traffictypediagnostic: BY5PR05MB7060:|BY5PR05MB7060:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR05MB7060372B8D87B5FD1C4EE1E9C8A40@BY5PR05MB7060.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 03950F25EC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uWeh4cssHM+xx9dH7dRoJcIwYccIOpHIaYndmBmwRn5SRUPfZ+jmQZIlfn+rg8z+LjCR99aS1AHiIe+Z5RCleFV2J2ltArUCFyeFrhT/Mziv3WfUP7GcJE2TVYx7k5Q5eqO/RPfwodDBieR2SGVK1HyyiEw/92L+JM1Mee5dd2p+8BMvm1Um3JHWrDR19L+5b5DgDeZIadbmFS1jsPo/nfWhHaCvsbLs9rRSP9YsWxfguW2KTodTQh/FDt133h07SjWYZgCKh1HLmHoioU63HDJIAWP/q52ofSD3m69QNzwQTKGoDpBDHyYyfETthkhaPMIyEuGOeq7KGzzSovCmStNKguFp0ebzbeNLOElycBsoI4pSOcN0Or0yr1AtFhvTDjLWX26sFd17XYikNv69tdioGlsgB2jRgzj7VMJ8G6+ba+CoVkAjvgiZ9hmqv4RhlnvIVIQFhqH/w3ZJy5CCV2KALr9rh3hldgPDpKQmKi48SdKUmmzbFuw+co9/yhH/L1VzDzcV9/n6IsdWJo2T3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7191.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(33430700001)(66476007)(478600001)(64756008)(66946007)(6916009)(2616005)(7416002)(186003)(4326008)(66556008)(53546011)(5660300002)(6506007)(36756003)(54906003)(6486002)(2906002)(6512007)(66446008)(33656002)(33440700001)(71200400001)(8676002)(316002)(86362001)(8936002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +yJPQQ+H8xOeYYuNfNIxgFWORQWLeH6cnk52K2SBpje6KqcyUC0t4xkI792Yc9ld68C9rroMaE0zsLKexPY0U/3TWkg86dJh4M6hNeBfDXoAhv5HzVtATxi7YOfFHrH/0cJlVClHseVGDmxfGMHcwZ6DkwfeGLfqMjAlx7UUwR3ueWITIQDqNLthV2i0uMhPG/K+GahT+LCx0aX2C95XQ2YEi3MBVHuUPTre3QkoNiNLrY2RA0JOoHdc6Jf27wgDQBfxgwEC/Pf3MLE10hUMhekXiPasgl3fjvk6ns3ZL35GX7INvZvnhowjl30viN6xNbG7G7tehhOK6Lrr3ASE1TGpviNUgEuYigOl7Nd98fhOnh9YAm9+EvGMS+h5iCYOcfUc2F4jYxypGHu9oC3R24sNtYAct3g8f0nLaU9OGoTkIYAT7J4U79GhVIPpTNQuvcc0uYPlUy/G/SY2Hrx7kxWSjEefCSlUQrRJMrLeTCEQHw3j3hD3DpwWzDgDfcoRl7fxRTGBcruMgLGQ2Et1lkfRU7f7ddC6wbU6iERtWP4dNpxzCM1LadmWPmj9GShAuvnXv0YLMD24jRop1+KkYAabSC0FVQTniGptkogeUYr6+H0qCXQUVl5/tVE4MXMk4YdxaAkX02hJp+MEDZhtJaFq0sqpjvs05vpPQFsqn6ebEbbXKVjJPg9FFW/4NTC/8hpXeC1HakFdlnSYN2oris6OWvYAQGoHB7o/HdRPgQe2aohUB4miT7qsTnS2wEjRIEaRXo2IbiT+4+iJP1Wz1B6d/+0NoIdzZ0HKri/+QM3Hd9T/yCrN2UHuT8HpWUqFMPT5niuJARDCVRaSlgCYmGI9kCOBDxBJgMgRdKYhh8o=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29358357CB8991418C23B508C7813EE3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12544bf-a848-4f25-0979-08d7f1e887cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2020 18:08:50.7439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWJOQIv3RZXzvjn0rJ38kNcJJBGYF/QXRehcmHXvp507M3FMdZHTEwO+eFJ191VAZ4+VOwASaSj+F25B9uGDfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB7060
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 28, 2020, at 8:17 AM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> From: Mike Stunes <mstunes@vmware.com>
>=20
> To avoid a future VMEXIT for a subsequent CPUID function, cache the
> results returned by CPUID into an xarray.
>=20
> [tl: coding standard changes, register zero extension]
>=20
> Signed-off-by: Mike Stunes <mstunes@vmware.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: - Wrapped cache handling into vc_handle_cpuid_cached()
>                   - Used lower_32_bits() where applicable
> 		   - Moved cache_index out of struct es_em_ctxt ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
> arch/x86/kernel/sev-es-shared.c |  12 ++--
> arch/x86/kernel/sev-es.c        | 119 +++++++++++++++++++++++++++++++-
> 2 files changed, 124 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 03095bc7b563..0303834d4811 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -744,6 +758,91 @@ static enum es_result vc_handle_mmio(struct ghcb *gh=
cb,
> 	return ret;
> }
>=20
> +static unsigned long sev_es_get_cpuid_cache_index(struct es_em_ctxt *ctx=
t)
> +{
> +	unsigned long hi, lo;
> +
> +	/* Don't attempt to cache until the xarray is initialized */
> +	if (!sev_es_cpuid_cache_initialized)
> +		return ULONG_MAX;
> +
> +	lo =3D lower_32_bits(ctxt->regs->ax);
> +
> +	/*
> +	 * CPUID 0x0000000d requires both RCX and XCR0, so it can't be
> +	 * cached.
> +	 */
> +	if (lo =3D=3D 0x0000000d)
> +		return ULONG_MAX;
> +
> +	/*
> +	 * Some callers of CPUID don't always set RCX to zero for CPUID
> +	 * functions that don't require RCX, which can result in excessive
> +	 * cached values, so RCX needs to be manually zeroed for use as part
> +	 * of the cache index. Future CPUID values may need RCX, but since
> +	 * they can't be known, they must not be cached.
> +	 */
> +	if (lo > 0x80000020)
> +		return ULONG_MAX;

If the cache is shared across CPUs, do we also need to exclude function 0x1=
 because it contains the LAPIC ID? (Or is the cache per-CPU?)=
