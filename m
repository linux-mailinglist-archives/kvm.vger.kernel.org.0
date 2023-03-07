Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825D46AF825
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 23:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjCGWBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 17:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCGWBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 17:01:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87897A8C58;
        Tue,  7 Mar 2023 14:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678226463; x=1709762463;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oCWaGWQUyacewz8Q2t2tiamndAql46qTDl6CdipPBP4=;
  b=TSabMbH5SLImMTiX8Yy7JtcfoUxZrRhO/Ui56LFmL7GFa5yreG27FSeE
   oi1x9Bwc9bN9b7WuZNxHgWo9lvD4IwXABU9zwqjJINsYZP616n7w5Yl0X
   4hCDc6GuMqkWiZwN6qxZ4qIIrWwAtzkbLbZJBy16zPA2EeX9P1QV6Sac2
   PZQJk1xUGTEhZaWEMmGpkUyKHXu/oK1TR0hVZDpFYjQXH4YuuelmMfHeO
   QP64Jl34QspajjB18pAqSkbiQbbhs+ACwyFSGAblwis3Qn3BMUwoNQoia
   cYsBldADLKILkAvloCMkEKZZ9ZXEU0qqYhSLMLyC0TkXk+IEfzASolvhh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="400811397"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="400811397"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:00:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922534800"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="922534800"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 07 Mar 2023 14:00:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 14:00:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 14:00:43 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 14:00:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 14:00:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA9X60iW1XoBn+UmfUHLRyAtY78hASvUc28eMaQks9G3Czxv1Q8OKSAA/0cJsGxYAJN1TGbLk4RE4YjNPjxUysfdKSZk+jCCVAasw+0ZH6wZc2RZOh4Iu7Umnu/27bRxXQJhfpVbWaKtramIpd9bpRwBRwjHb10ow6AHLPDinC2to80vMdysH3x9pK0Mi6y12avHEu58ciFF8SYobOg44Rt5r33oY/wVR+kWiv9MucFFzGCADTzbB1ZFK6X3Wn5Ktipk3pK0gJ1Gi6E1HlsHp08077yEb2BbQDkTFVhUh6omtWBSX7HWBVm4kEt10WTSH3VrlT31REDSiU0t4H/ypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nu3OZoML1yPVH7ojJ7Cj1SChNuvV32Y6neDS66YoT40=;
 b=k8AWDvs53c2aXgNcSFeoaEWmvagIkYbP/NbTNIxZJTbH+3effLfEsG9eNVE6pY5HkFc3D7b8oiCWFekYcnlCk3sOsNf83ZCJJBhv9gpB9M4+5VfZLo6OLrHPRb5UcluBYkQJI6u/1Brb9+VTrlrXvImADbYYBzY2UIk69iwnqUDYOGk0cvgyZ3ytFOaVmfI1kVHvE/Usap1rZi/hMjTM87G038dfpnA9SfNFLtxrC3JjhkkiWpSNtXjHV5W8r3P1pNt28bMyXGmPhiGjnBRJCEijl+/uML1RmcEptHmbsEkj9NKwwbnPOUjSLIIKoENFF/49/ZeXrPG3nT1f4+hquA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by IA1PR11MB7385.namprd11.prod.outlook.com (2603:10b6:208:423::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 22:00:41 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 22:00:40 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Topic: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Index: AQHZUKI3WfAyEb/jCU66DZKXu8CGnq7v3nLw
Date:   Tue, 7 Mar 2023 22:00:40 +0000
Message-ID: <SA1PR11MB6734409CB3CA1521323A1C7FA8B79@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-35-xin3.li@intel.com>
In-Reply-To: <20230307023946.14516-35-xin3.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|IA1PR11MB7385:EE_
x-ms-office365-filtering-correlation-id: 7eee1ce0-5b5e-41e4-4eff-08db1f576422
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5XuAhI3WDP9LfFsAlae2NDaISBa6C31cu6Y0HFJgpK6DlPfcj/sRPcIF6iTv1uGwTPTVqFSfwjLLfqb3O81SM29Bt5WeRHdnObxmvdE1Nz8VAz1yrNfcQ4uXcH1c4v7gg+n543XrM0y4FJBUg8YQyEjc8PvNB/lmfAjjCKrtfNqve7HQSsMKIhYqYlu/4E0wDzhDAG9JDp+mOtZ3q+mvtMJaAwGS82cvvPqLmj0rT+34K77nDP1UsSlApQ0+igSd+041O0BqaprbkVAe2CVHOGAwsY7lu59ajTQkRofbfllTvO1tgdx7+BcJXPvR8JjfI6Wl113GtlNnmzrEGk0nt0FFrSMWFefPJn4v4v4GN/bgL/ekvZ+ftAASilpcV0ROV3ad3lgdCCnUr/MhRWLHjP6uh6dinYw80UIP6j0MYmbPhqzoCBjwq2h5hbwJ6Ifo8w8ExxQEpZqLcRMbXa8IXPtlbrP2b/66/mIuzx/fHZCwAx+KS+/f2voGysi2r4EPJo2qNZNmwMy0CX+/NB8vRESIfmUN30OlhV+XghVotcz32R0tPEmtqKXgJ+FGmqFh4oAEMA8iFaiIyBItsVd5wg8yPE7FcwqkPi1Y0YSmJDZTmPU4hCHgsPol+UKQ38YnZp8YhImFYHdpYk7zMwOMS1zzGtGLqBNwDxMVjH0TCZkVtXc3pMajCbLtt1veM4tm3EDHSnUaOTIjxFryM8dWig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199018)(4326008)(41300700001)(76116006)(64756008)(66446008)(66556008)(5660300002)(2906002)(7416002)(122000001)(86362001)(82960400001)(33656002)(38100700002)(66946007)(38070700005)(8936002)(66476007)(8676002)(110136005)(7696005)(6506007)(71200400001)(54906003)(55016003)(316002)(478600001)(52536014)(83380400001)(26005)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VoFzQQFIw+k4NJKHj8pWwoeDvhH6VlNRoOBNRLdlelMDPh82a0CUJZznEO3n?=
 =?us-ascii?Q?G+7n3w5uhSU7JW7ZF6ISWKBRQQeNa6rcfDYVXkYXdn4C33t1RoxuiYFcD2yq?=
 =?us-ascii?Q?7xECCtGHuIw3n0CFYTF1FwoKzsvIdoVZmk0yKm2U3nrhEF9HVg1X+ydA9v1o?=
 =?us-ascii?Q?ln/lyK3JDII91Xr5jvcP5P5qDYHZQN/KRIClCpyEuVgo1t989uoE2UNQVfqI?=
 =?us-ascii?Q?0KKa5P2hTAqcaToLYINCBPYDEF2mZDvKSA0HG4sDakPHbXXrFnHp8if/XbE6?=
 =?us-ascii?Q?tdX4SQ28emB4ayRuqLs3MraQwMf1xE+Td/R583myO++BGAyquP+xMYywD/ye?=
 =?us-ascii?Q?OcOvNd6x8vYSvq0Xy6AOcICsN9JM+R4VqsAMBO0ovg+GDmUenEXUT04x0irr?=
 =?us-ascii?Q?Pe6YFJHq0AHltwpYXSjfNF4BMn3fxb6YECTuz0HTrgKfhe/p6so1pRondbNm?=
 =?us-ascii?Q?oitmZBa0OJf9H0yZu1uuGgKh6F5Umbr9v3IjHm7QtkAerNaQvlQgYojll14P?=
 =?us-ascii?Q?phWfBug1YRjPlQ/4NA9YDWgLHq2cMaVahOyi7i8wveC/8SMcOfA4M6K7q0H7?=
 =?us-ascii?Q?8buaost1YUnMlWB8phxPB4QoSFAtJu7C+XEVYsGFWZpUSVMW0bFePqu8UVhO?=
 =?us-ascii?Q?QVi11g1aSPuYoChNdE1DyVqLeXAbTiQm1hNiBSTxzzNfqztq2qbAs0jfFQzD?=
 =?us-ascii?Q?KVGfA18hpLY12Cu3KiikOjLrVPbVT+XPC3blqDcM5pvAqPDWPopp5HOBiHqF?=
 =?us-ascii?Q?oPLX2dPD+GCAR+3tC6WdxPU2V62kMzrWYMjo6V8U6Gwdge+aSOItHTiySRce?=
 =?us-ascii?Q?zOEofDV/XY3A51SLN7RzRY45n7lh76kfy5cO5pudrnqeCSerwdlBmNd3Rp6D?=
 =?us-ascii?Q?2ALO/Uu0+8M0ecKyNtzHVnNEMVQOmG+eFyYtvOtlA82hVOsx6Ys1LLWw4c7z?=
 =?us-ascii?Q?wrYKcjeJu3JoLupB8zz506bJMAp5vCaH2r62aRR58UMvhWJVOblpq3ICSGDk?=
 =?us-ascii?Q?FW0gA8PSimJ07v+j0fQUaIBd7KJ9UAA6fS061CEA6wQNz5+2VQyEAQfacBac?=
 =?us-ascii?Q?nrKpSFB2ZL1Y9kdorKg6wmpvrepCVig8af9HhnXDnfrq4Q+Ur9hpFm3lxWJT?=
 =?us-ascii?Q?A8aH/TNJOTb3sRmt6PfVpZLEHHoKvX/SOSOQCAplIhTSS0k73Kvc+HE8AGYh?=
 =?us-ascii?Q?7RUwxl1/+tT1aNksxw/HnVFPg7fjeOHaAdkZCHV+boDdkrK/NO1lo06c2YZL?=
 =?us-ascii?Q?aGyadclGkli5x7LyjHyd56YOKNYt0Ul85xoxEi8mV6IDqBVkaEkud5q8aPPJ?=
 =?us-ascii?Q?TaVzz/lTtqw9J/Ucy7Xcj4M0DRDmj5A7SVvep/9PoirfQTQ7MsBF/ColNXAc?=
 =?us-ascii?Q?FbdFdYVWB41EhZ0DNz6Vk74YofFrYbELrcM5k50R1l1PgDc9uCwKcCajij/j?=
 =?us-ascii?Q?WkbD9BlwSVQIXhqn3mHQKcLGc63931b/DgFmOtPL5XRKsb2lObr0yvougeiE?=
 =?us-ascii?Q?X0iSZmpikUzHY8BWh8pbf+n9AwjibVASOMju9ili6PUo+Dz4AOgaRnFngWid?=
 =?us-ascii?Q?KC12GEg2pj/sgbifDZI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eee1ce0-5b5e-41e4-4eff-08db1f576422
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 22:00:40.5486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w3FZuqnjhOuTLLmCRVJzkoj4bu2PyLwKmGtF7VHZeFqTD3psQkW611yKWsX8sIBz1DxGmD1DEoNz/rkas0Z5RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7385
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Execute "int $2" to handle NMI in NMI caused VM exits when FRED is enable=
d.
>=20
> Like IRET for IDT, ERETS/ERETU are required to end the NMI handler for FR=
ED
> to unblock NMI ASAP (w/ bit 28 of CS set). And there are 2 approaches to
> invoke the FRED NMI handler:
> 1) execute "int $2", let the h/w do the job.
> 2) create a FRED NMI stack frame on the current kernel stack with ASM,
>    and then jump to fred_entrypoint_kernel in arch/x86/entry/entry_64_fre=
d.S.
>=20
> 1) is preferred as we want less ASM.
>=20
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>=20
> Changes since v4:
> *) Do NOT use the term "injection", which in the KVM context means to
>    reinject an event into the guest (Sean Christopherson).
> *) Add the explanation of why to execute "int $2" to invoke the NMI handl=
er
>    in NMI caused VM exits (Sean Christopherson).

Sean,

Do you have any further issue with the last 2 VMX patches?

If not, would you ack them?

Thanks!
  Xin


> ---
>  arch/x86/kvm/vmx/vmx.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ebeaab34b2e..4f12ead2266b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7229,7 +7229,16 @@ static noinstr void vmx_vcpu_enter_exit(struct
> kvm_vcpu *vcpu,
>  	if ((u16)vmx->exit_reason.basic =3D=3D EXIT_REASON_EXCEPTION_NMI &&
>  	    is_nmi(vmx_get_intr_info(vcpu))) {
>  		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> -		vmx_do_nmi_irqoff();
> +		/*
> +		 * Like IRET for IDT, ERETS/ERETU are required to end the NMI
> +		 * handler for FRED to unblock NMI ASAP (w/ bit 28 of CS set).
> +		 *
> +		 * Invoke the FRED NMI handler through executing "int $2".
> +		 */
> +		if (cpu_feature_enabled(X86_FEATURE_FRED))
> +			asm volatile("int $2");
> +		else
> +			vmx_do_nmi_irqoff();
>  		kvm_after_interrupt(vcpu);
>  	}
>=20
> --
> 2.34.1

