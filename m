Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB035720689
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbjFBPvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 11:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbjFBPvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 11:51:44 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C4C197;
        Fri,  2 Jun 2023 08:51:42 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352EUnp2015557;
        Fri, 2 Jun 2023 08:51:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=IBfTQG294IZXe9w4TWIscFHHh8oQ/HPTBLQeqPPUnzE=;
 b=dej7bMX6zjvejM2dyz+FVantCEjOEz8aZJSTrnDXwwqC4WTo6WX4npxA7vdvGN+5hqn5
 ez6QEkhHJGWtVbyOP8kev6f2p0Bfa8LXOoV32bu0jpLdgI5tWoy8Fy7Q8qLwUylmL1lE
 IN5QhXIiQUqqTsd99QZywVPDExRUHvcXTQjAgNKRonc6oLWngt7cSzXV+usm4dh7WRsH
 +yz6mCWBxj/tIsUSVWaDDYDJ4ksTr+YTBiWH2z1/f7XdkoXtOhTiJyr2qgn4R50KEPwQ
 WcE4RAQwpwuy1JyakAPIC57sL3jP9v/wl0e14rFenggiQzjO0MGWfWIpphf6fri7FXgX RA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qxdh9mc9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:51:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecX/T5xQtVkL0rO3uPzC2BeYbV04OzpEpj0MurCPOKRTtC5GGcvBmIHpnSUMH4oAFmIB3skTT9E3QEzbUHJJfjVgXsvpXZkIj4aG8Af0HSxrlyEEPBaTv9jwsPzyRB5sfqd+fDo0fRW+qIi4ClJ7Ib6V/uHXvJsQFx8PzB081DRJrn2+Fef6LLLXR2DLfRseyY43Uzc9Yiu8nTQZcN+UioZ6JsOQWprQ+9N+efPijuHKHa5Q3Z7W9fjOGgLTOTCyTVgM3AxkbomTkuPyA418gxUC48a7+Uilbs+k9J9vYMhrV45mhxcw1Gvps6ydFAcgeh/2jGXUrFRyBy1A4C+9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBfTQG294IZXe9w4TWIscFHHh8oQ/HPTBLQeqPPUnzE=;
 b=RvYFgBmkJ8xCNuN4JnPzWu2RZ9ZNyUkj20zeQFY3HrDXA0fMbUJ3cS9a2TqWxBL+3Jjw5Dsvlw+rd++NVZrJrMGpq5LQFwXZmuGoiFsDsXxClpswAZV8Rp3wyIOA92soSli8ufGngkvkyJu0/ecbgUYsd30/q0sKWpBRxp4K8+1+voxqr48fHc1kmiG5cH+wlKWK+CVW3A8Hctx6hAVR06bdcrTNg4AFf2W6acRtKi6C+9Kkx8G0BaqkcgxMFAA0TgD7H2FR7W5Ga/N3GkVeSrEEK4vbt6MByS4sPX05KMe/QUbAKhLYQKY2xNdj1/m7QuDo1hXBUKdYiyjhZ/YuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBfTQG294IZXe9w4TWIscFHHh8oQ/HPTBLQeqPPUnzE=;
 b=ZXl2jHgw22u11MOtEjrc26y/e/OuFYp7X1FA6qXVzVaUFMHrx46gAG34ChfG91Dk3tLxBwAU8zRMiedEC9O29hF27HSNPYJ5hzEuUDKZ7nU9TA0rf0h6THkEbxPOq49vw2c/w+C/Rz+AHYkr4VP/Qequ9imykhysSXNK1duUvaopKcYB77nxEuBwL38mS+9zDEE2HtW+JKAs/Hd2Ij/4+e11Utmd25Kws8h/xoR5ZrV3FdjnExmUYHRjw5CzVSnzILXPDxKNz8SocKMfVcj0ZYle6R9GVUPuoWJnA/lnBvyOUyDkDWLNSro/bxjp8Y26eha4WD97y7dbO2gA2yrqIw==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DS0PR02MB9149.namprd02.prod.outlook.com (2603:10b6:8:13d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Fri, 2 Jun
 2023 15:51:32 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 15:51:31 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Use cpu_feature_enabled() for PKU instead of
 #ifdef
Thread-Topic: [PATCH] KVM: x86: Use cpu_feature_enabled() for PKU instead of
 #ifdef
Thread-Index: AQHZlO5k4NTBs0ELg0erRYIxXuAawK93qlQA
Date:   Fri, 2 Jun 2023 15:51:31 +0000
Message-ID: <C8324338-FC07-454E-9A5A-1785141FEAB3@nutanix.com>
References: <20230602010550.785722-1-seanjc@google.com>
In-Reply-To: <20230602010550.785722-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|DS0PR02MB9149:EE_
x-ms-office365-filtering-correlation-id: 33843663-df98-4cad-4150-08db63813c6f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mJFfbHM31ofWR5s5O8Co/vxwDwdRsYpPxDs1KOcTEnYOwFY5s1cb8uOlbjaQLxwVPwVQa0WHNqSZJuGWaE8LuvC3B/czOBlVPdFB7E1oEPR/9iksQqpv/nfJqboT8RPRRHuTK0WxuVkSgusCdDuzcv6cxSXm79a2hjCtSraXocuBRaJ00sohDg4ratnT0SO7GwIXhWWWjF3zb9VsfiWV+h/te3fMzOQM1ygUMgwOy91JUt7DCDXjR6R5PDNJFCSJYoMB7xhoH690UWrjkvyIuMvdHeBhDQVJjIpIIajdYMksxtbGi9QjoVILw0Je7YixYE8/+gyOcnhNOMyCX6kTuUlYfI3KTmmTOpowlwa0JtW+v3cXAmqS6Hg/bw3y9slDgeGwg2En4gec6HkmHaYtGJCr+WZcKWMno55X537IvBZjA4nGWQtKpDsMNrVe4BAsVjv8T/tjV8jLfIP9Qf8ivSmtY5ItM4FgHonp9niShZG1ShonlllbGulXuH2Y4buQ4IQEdZEeC8gm8dfB2zpT436W5ehx9RmXscOZrJMEFA7n3xThyR9gJqdza8jsWPv569ndDgPkfuIrKwvObTmjNeYH5OEnoY2prK7zWjkv4G6dKzifNbBR00Jeot7uWdp66aH0witBJHla7wtVmYMNjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199021)(54906003)(71200400001)(316002)(2616005)(66556008)(6916009)(478600001)(91956017)(4326008)(76116006)(66446008)(66476007)(66946007)(64756008)(6512007)(6506007)(41300700001)(5660300002)(8936002)(2906002)(8676002)(53546011)(186003)(83380400001)(122000001)(38100700002)(38070700005)(6486002)(36756003)(33656002)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tCcm0F+jsvuNO3MwViZG4hdcuGQol61B+DleNOwk6AmjE4MkMTeQZE9Y9O9y?=
 =?us-ascii?Q?L6WidWZgRoZMnTjE9Hh5wLt7/zoyUUyTgATKh+KutI08kVwtPuDpORidXc2L?=
 =?us-ascii?Q?Nmj4ps+EBRWgUtPvN1zodHfjM2/vFSXtDiSBEXGFfUQwL0LGBPfrCtnkfHBb?=
 =?us-ascii?Q?1jdzzxnJuVQSD2rnRiPL8tnPbumQtAuXZ3z2Rovjfgxk7B8Z8r4v0PTm5Z4b?=
 =?us-ascii?Q?FWtpP/6M5PFnxpArSTa8BuGfqxkPsjUhNegCLH0sHEV47CxxypXRGWg8iBHH?=
 =?us-ascii?Q?ofwdMDkTBPiH4Oc6e256Ha1IdEg9hALokqYKm/Jb2POewiv8E04OEdGDPiks?=
 =?us-ascii?Q?Ff62sKUdCKJswEX+VkOT+frDCqEPnffV5tNpGNd+hop7KM4SNmd94jJRSNTH?=
 =?us-ascii?Q?vci/yn6eV2JCcrpLyAYnF+lkdJGiElDZBPjgMhfH1gw/fM3o44cnOS+omXQJ?=
 =?us-ascii?Q?GpKnSSW00ycAT3t439c+ILTh9+aA57/bSb+ON6xaxw/j4YMZR6bxq36t//Co?=
 =?us-ascii?Q?dXzPkW1gqUdZL28y4/iLbJabW6H/bYzm+REGjKMD1j8SspCIXTgSgIjA+I3B?=
 =?us-ascii?Q?dkYCbBeeDBXqEsjH6ilG5V6n7baLuNW/Ul8EZZPCOKDjNLWZMjG5YRUaIx8u?=
 =?us-ascii?Q?BzG8Dklo9zcAu7MKSMGj15M2rfeWYW16tvdqVv9fIK5TSta2fVPRxeJljgHi?=
 =?us-ascii?Q?22PR1Yj2ajViq+QibOx0DzPfMZc5Pa9ocliCsWzDbHeyGjHdVN+6Qg/4XPwY?=
 =?us-ascii?Q?UKHy2eN9dCaMnmBL4jd0pnhsuVis9kLwo2R6QH9owGyc8OTvQqsnG31oY405?=
 =?us-ascii?Q?F5IzmVuTa3QcEiNhdnVi+yGvj+eo/cAGRlu67kFohtUPqvmF32i6/ktL+SpL?=
 =?us-ascii?Q?U6dSemNu4zwGOVJh0nOnNxIQKiqoKyDxuEbEOxHuoQ9yS9X1nqYziv7SiExF?=
 =?us-ascii?Q?ABFQI7RaIilqwjgNJlO0oexubN5FBE00uwHdWdcMUtZgkDsN/SI27kZjpeC1?=
 =?us-ascii?Q?qTS9cs3rM0Ftu1WCXn1C8yB22yqkMefUTJuH39yazorgIMqQcwBueTaH9fk/?=
 =?us-ascii?Q?1Uhq3x7zhdFOQGVz/3aLCwY9MiIF4Ij3V1MIa+38C2UTNqqIdS7IyssR9fsa?=
 =?us-ascii?Q?fnWFDhoESU4ubPxBSPYI4BB4nZ514gKIXBB0vWghrqTucHHXSts5asc/1J0z?=
 =?us-ascii?Q?TuD2RKBxbqlWbBI3rrrkjYMq9he6xMlrtIJS470/NVWgAYUM5ZZaYfmcoTS0?=
 =?us-ascii?Q?R865halY4uvT/dEVSzE5lwoJZ6pAtN8eIWUxket9ENDJOHJ9sZGtL/hkGYRO?=
 =?us-ascii?Q?R+KDhFBU2kHsvinB1cMR7WnEQQjUXtYUK0gO645zb4/7Ne5hOi1t2NRyi3XG?=
 =?us-ascii?Q?/u24a4ex8zbbRGcWWQR0/DrfLGvgCJooQtLvykiT6T/7O3zKQKCz6tCP4+Eu?=
 =?us-ascii?Q?/bqjRp5tWCYPXFpGRHisZj6D4DCiXyf+4w7V0iPttaGQawSng1j9irqpsmFA?=
 =?us-ascii?Q?WPTgxxQYq6MRP0ot81CXzF5ScF5Hty8mcq7IMM5l9UFMvFw7LWo+DtIhr16U?=
 =?us-ascii?Q?fiod4rVdCGOnZ05y0DqB8s42sz4BByBf9VfuGPZu7kFLuR3X/Icd6gSLGuPC?=
 =?us-ascii?Q?Zw0yeUxLRvIKktjYrTw1EE27QfUUI4RO2FWHsiJhfL76TsdvPAh1LlxygCgv?=
 =?us-ascii?Q?+heTZNiQtBw0Dsciwd0Z+RDkrcU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D46A00B76610A741964D1E7C11CA10EF@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33843663-df98-4cad-4150-08db63813c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 15:51:31.8305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l++t8oE/+p8epR28+Jvcc5jAXGiLljC5ZrNZpsdmQOQGiQzn5pJtxHK4u0oQPYHeY95ul2wKyoe2QmkEnFuYmM07Oo5hDYyglgH2+HC29CE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9149
X-Proofpoint-ORIG-GUID: p7QYPg1OYviIREWKRiITlXQPeN-Os-jB
X-Proofpoint-GUID: p7QYPg1OYviIREWKRiITlXQPeN-Os-jB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_12,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 1, 2023, at 9:05 PM, Sean Christopherson <seanjc@google.com> wrote=
:
>=20
> Replace an #ifdef on CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS with a
> cpu_feature_enabled() check on X86_FEATURE_PKU.  The macro magic of
> DISABLED_MASK_BIT_SET() means that cpu_feature_enabled() provides the
> same end result (no code generated) when PKU is disabled by Kconfig.
>=20
> No functional change intended.
>=20
> Cc: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> arch/x86/kvm/x86.c | 8 ++------
> 1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e..eed1f0629023 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1017,13 +1017,11 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *=
vcpu)
> 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
> 	}
>=20
> -#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> -	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
> 	    vcpu->arch.pkru !=3D vcpu->arch.host_pkru &&
> 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
> 		write_pkru(vcpu->arch.pkru);
> -#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
> }
> EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>=20
> @@ -1032,15 +1030,13 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *v=
cpu)
> 	if (vcpu->arch.guest_state_protected)
> 		return;
>=20
> -#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> -	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
> 	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
> 		vcpu->arch.pkru =3D rdpkru();
> 		if (vcpu->arch.pkru !=3D vcpu->arch.host_pkru)
> 			write_pkru(vcpu->arch.host_pkru);
> 	}
> -#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
>=20
> 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>=20
>=20
> base-commit: a053a0e4a9f8c52f3acf8a9d2520c4bf39077a7e
> --=20
> 2.41.0.rc2.161.g9c6817b8e7-goog
>=20

Thanks for the cleanup!

Reviewed-by: Jon Kohler <jon@nutanix.com>=
