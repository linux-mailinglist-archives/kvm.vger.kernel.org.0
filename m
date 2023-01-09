Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F5B662EC2
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 19:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbjAISW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 13:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjAISWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 13:22:35 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9ED659E;
        Mon,  9 Jan 2023 10:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673288458; x=1704824458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=botZPKv4sevpiUxsulK9qJ2nx1RN/gh5HzewG1ox+Sk=;
  b=lkAllMneuJwrS4P/lIwRODpx5I4uEcgvTyWD0LtbIutGo+nR4TDZbQI+
   tdf8s/s4Vb4EBpGNOJ+mYB7osMlwIZoOF5nu+nQOE/1n1VEk1E+Lx8qJe
   RO1jJeDHidLX701PpAIXb0uBP6i1QEENdEuIvKNw8SpKkAAxdRN4/cE9M
   LjCJE2Ye3b6Jnz0yz8J/dnF0EBwyoAxIxhb1g6bX/6HxpJ9DWziDXDC1H
   ZCBHQqgdTfUXpsqOG7yeqDTf5zgarrPBwOsmupQUVLuERJqKVNQrW96nP
   7HsGuZG9RUlTL7230xUeYRX1ILv3T+FkCwmmnwmMX7TLdiy/HVllPyXSs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="306462677"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306462677"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 10:20:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="720024224"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="720024224"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jan 2023 10:20:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 10:20:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 10:20:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 10:20:56 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 10:20:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpi1it5PFpveOiYIr58vJKpPgpzso/Dn/+OHvcr4oh+m7S6To5A4D3L4KDjDPOjYogPoBdeOezMZXumk3P4jC4nFJekZUeu7uaPi1QPfFcNx7gnEj7ycOCPOc5rxyN3WOKZqCpEu1aAiGpI7GcgmfApggytS4mk5zYB7G7cELgbS6opdKln0uLwxieOnKT/OBUjtoYPhdSb8YywkPkY1qPcsTbH/Ji7tclI8njlqSBojEM6r1mCsql9kMmCAnAPlmyK5V6WVfaG6FpgOGVvSkD1+rSe7VM0gG0kbkGWCIfCalxDAcQs6OG/8vmRmwoN34OHCrI9E3ChoSAvYBfaqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnqQe8cCdSSTWEq9o5Nwby9LhoOIhbA52YlMMv3h0lA=;
 b=Q0UhsgjFbnQ1/gSCZVvn8B3LNf7IsFU/Pt5PAa/QLK9ceeJ0sgwrhITQ8hhitLGdn9YDke7JeXfcgs9OBNsz7un4tHfdiI2LwiU0sqaCFiJcbkMspgHx3QLm28WRGhuCkCpV257J7KQPEGIhzeoTTHFI6mtHecadRdd5lEmpO2X0JumQmXDUxVNyZXOZRvtoLBRVlBYldLTr476pbxz57xvPxsChyGNPGIYpOJQqlBo4L6WKDVAUrGldyKXg3OLQr4vp+4+QnrVPUjjrMaWmHEKWqrD1GD6zrvMHszbDBrIqWsowCBFAK4ItT0pWTm/XoEccyORhUVlv0+1yyl+BHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MN2PR11MB4600.namprd11.prod.outlook.com (2603:10b6:208:26e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 18:20:51 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::52ef:33cf:9be9:fcb0]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::52ef:33cf:9be9:fcb0%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 18:20:51 +0000
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
Subject: RE: [RFC PATCH 05/32] x86/traps: add exc_raise_irq() for VMX IRQ
 reinjection
Thread-Topic: [RFC PATCH 05/32] x86/traps: add exc_raise_irq() for VMX IRQ
 reinjection
Thread-Index: AQHZFEEHMoyRIdAKpEePAcSCwnR1Sq6WhPYQ
Date:   Mon, 9 Jan 2023 18:20:51 +0000
Message-ID: <SA1PR11MB6734110197BD5B5887917338A8FE9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-6-xin3.li@intel.com>
In-Reply-To: <20221220063658.19271-6-xin3.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MN2PR11MB4600:EE_
x-ms-office365-filtering-correlation-id: b8aafab4-e392-4cfc-e0e9-08daf26e3d52
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XJvnb3Au/0oN3ezaLPqqXCug+2ZBp1QODuIMUQdtBgPZd1EQaTyiXgJ4mhhJK0gXfVV+3OvVIyRDqM4PUfE88TmlL21Y23FF0Idvq4621CuOv95vuSsZEsBMjngqOAguR7NkVq4vaKAJH0y6kba9jTD91CCgd5M/ekVnMFTGxNUFpq5Z9USCgFRATIln1d18aJ09h40RJSnmFzgO2n5sEygUBDQLbdStMCw/Vf86U0DGq46abiSzPFxftGEL9F/6v+agtbNb8NW6bY7lW5c4952/zbx7QRF3x2TjO/XQD53bHgTDKIGQOcXVWNPcOcVTVYgABQpDicvToJc3wT+U27fuRP7GTleOwUZRbLBBQkSRo2PogjgiC3/+IN/1PRV+9/mr6mB1ZJD+7w8GNhnVtxQ91yRgABXqYkv4C0QjeWhXQPo48YFdw8FXxat6XjT6qzKR/fHzdwaTjjKQgdzy+T2xK1Fky/5fj69059GqcwPNogZGhofV+m8cyriws2bJH3p1fSU3L4wFA8G/h7ma7nXIDZVf6ElmKvh19n8ub/zP6NREsWtJh9AdfOJ+zO87HODYF7iCBM79ksa/VbM1nO2qHjOzY9F41D3d+EHeoVEJKEz0XVJehRMJCfo+k9aJr2/cMZ2b0tc306ZUZqaDkNYm8qFpwjaqsEeBtvsRAEG520TyUYHppEIULtQGy+LDklAAQNonSPw6C+adr2AYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199015)(41300700001)(6506007)(86362001)(122000001)(52536014)(478600001)(38070700005)(5660300002)(82960400001)(9686003)(38100700002)(7696005)(186003)(26005)(8936002)(8676002)(76116006)(71200400001)(66946007)(7416002)(66446008)(4326008)(33656002)(2906002)(64756008)(316002)(66476007)(66556008)(54906003)(55016003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+rM3K0N5cqmOB4Kre5H3lJgxjdu5NvUUbmKpep8cqnZFE7wdzGDdne006qBi?=
 =?us-ascii?Q?gnQlFUM8ATsKOucn7WhOye0MfETiA1XgGb54kYYdN3B76Bo4Eg80Pj41au3h?=
 =?us-ascii?Q?+4FfUf61gifK+AwYuLVesLvYNZae//3+47tULMPhIt+zjU49OXFozEyRf9Ak?=
 =?us-ascii?Q?8ib0vC0LUBUynsjL9QY3aIznh4HUuZ35F7Vec/8VsAoClUPym5JPoHl0eIyq?=
 =?us-ascii?Q?rYV8tbYvRQBvydqvYmVQUwLB8sTphdoktyL1T9Avwq/YNL8B+vXC7oDqWNzz?=
 =?us-ascii?Q?0Dd0y8W1dJiUcmCHY2ayrPdZt8Q+/LjSq1OraXainsyxqkz3BGCNca0mAWte?=
 =?us-ascii?Q?o7rsBdhXl5nIAPpaUNoBGMu4F1KOfRaGcsJB4iZ5m8Y8kHRx7cW8MW63ayL5?=
 =?us-ascii?Q?XnsEE2kQ0QA4pJkaqBp+txiRBPlZxedEfYvWPYRRH8qWvRtuKnSz3MGep7xY?=
 =?us-ascii?Q?fSgG8GiidFPxCTB+LGh1m4Uk1RjhP2lyN4T5W9ICeiElvfPHlhryBNLOfwbn?=
 =?us-ascii?Q?3bofc3LfzOwJpMhDnCi5DixvB+8dbkQZXiIN2WxpC8idQSrib1XMhSZNdgVL?=
 =?us-ascii?Q?Bygh8uwsnWCCoqzm6dnzt315sN59MmiAhkn2Kdhcg8g0conS1v4UicGxBNRX?=
 =?us-ascii?Q?keDwXAPCWsPWlgkzieCkXq8QxRfzHXIpLarSTyRyWUObxY5juC265RH0eQCV?=
 =?us-ascii?Q?KUQIiZKH0Gp/z0m+SCJ3tomUQ+TOxzx0U5W6VYqlRvdWuqSN9hjzJmLyEuX1?=
 =?us-ascii?Q?qmwc12xPoMfFlxbGwkTl10MmN8qtWVfQ0jUcJtNsysEuqIZjU7Psj6MHb1K9?=
 =?us-ascii?Q?/pXxddJkuKAU/JpJLxpPS87kpIWb8RD8rkIET5hlhxvWMvqqiOeI9uSGcsp1?=
 =?us-ascii?Q?8+grwdCMZtZ+ZVrJkP8RcLt9lX+cy/5pWcrNgIg66miGUV5TLv129HiFRf0E?=
 =?us-ascii?Q?+1DiXU1SJKxCQk9as0N+IBl9ZCh/I8LoSUN0fw9ii8ODkdGlemnM5YkeK874?=
 =?us-ascii?Q?yfXJ6jFJcQYdxAVamyr29mB/ckx5kKkE3WjQB/Yb/d/6ZhhHps9/CXihROtk?=
 =?us-ascii?Q?/BVtqwQ/7PPvGyvC0KeQ19pas/Uz1GnzF67ADg8nurdVP3vNMQ0BXR068IuS?=
 =?us-ascii?Q?A7dLByCJRSOx4Vbbc5cUOj0Auuta4uhFQiuHR4q2zT4z+CZ8t7jLBnnPSUk1?=
 =?us-ascii?Q?1qpmHpeaIGRbDOUrFMh3D29RK4WD7GXaVckfPUCz339zWOdko23FiSSCB/ek?=
 =?us-ascii?Q?yU1tzk98cEm2FMP+9A6279g/L5vj6P+eMY+YOcfhUZIfJiEJLuyD3MkfBc7X?=
 =?us-ascii?Q?bWItUOJQZZZR/+Dsjp2OsiGaHlOFwvjER17JxmvHOVDbnnug0udoyfObfjMq?=
 =?us-ascii?Q?JucV3MYXhYHVwuN+B0qbre6e+rxI1O/9i1+DCCZ8UljyUUJ2enJIJCY3ZXb1?=
 =?us-ascii?Q?STxmfQs/yH3SyO7FgyqwLBgQ3qgObcclEPpCp3/tlwQ+enFsyGpSw16BAXfr?=
 =?us-ascii?Q?R8W8DQYYuDGhb3gAoK9c83ISE3nZrQr5Au2jzPKk8dMtJOh2u7wwqL6kBF9+?=
 =?us-ascii?Q?/GAJREq9MdK89heHK8B8Ugl7GjjkP4mA0rGZedw0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8aafab4-e392-4cfc-e0e9-08daf26e3d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 18:20:51.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: URxP8HZyIkRLZaXqhnkq1hn7+y+9rtXDKFg65FzDxUE7LOKA+REIm6pVF02c+qMT1O2g44b+FwypRKO5TTYWqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4600
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 46f5e4e2a346..366b1675c033 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -56,4 +56,6 @@ void __noreturn handle_stack_overflow(struct pt_regs
> *regs,
>  	void f (struct pt_regs *regs)
>  typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
>=20
> +int exc_raise_irq(struct pt_regs *regs, u32 vector);
> +
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index c35dd2b4d146..99386836b02e 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -1536,6 +1536,24 @@ int external_interrupt(struct pt_regs *regs, unsig=
ned
> int vector)
>  	return 0;
>  }
>=20
> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +/*
> + * KVM VMX reinjects IRQ on its current stack, it's a sync call
> + * thus the values in the pt_regs structure are not used in
> + * executing IRQ handlers, except cs.RPL and flags.IF, which
> + * are both always 0 in the VMX IRQ reinjection context.
> + *
> + * However, the pt_regs structure is sometimes used in stack
> + * dump, e.g., show_regs(). So let the caller, i.e., KVM VMX
> + * decide how to initialize the input pt_regs structure.
> + */
> +int exc_raise_irq(struct pt_regs *regs, u32 vector)
> +{
> +	return external_interrupt(regs, vector);
> +}
> +EXPORT_SYMBOL_GPL(exc_raise_irq);
> +#endif

Maybe it's better to simply export external_interrupt()

 +EXPORT_SYMBOL_GPL(external_interrupt);

Then I don't need to add exc_raise_irq().

> +
>  void __init trap_init(void)
>  {
>  	/* Init cpu_entry_area before IST entries are set up */
> --
> 2.34.1

