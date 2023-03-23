Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC5F6C5B5A
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 01:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCWA0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 20:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWA0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 20:26:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A62193D4;
        Wed, 22 Mar 2023 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679531191; x=1711067191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LfcnEnc7RyT3R63lxxH/91bkp0TxGqWOY+hLGWiS/rk=;
  b=Bq0JWtcOZNVnbf8akSwQK3GdG2/pWDgGkyWE50STwGxlTXngOMqyLBvQ
   AhKIY5n0lz0gYlxnCjDAz05JGW3f/UGvGgt+Ly9+D64eUD0GW30EQR4Ms
   y4QXj8CjG8aLDbaqIzcEClEf2R526Y7tS8QsEzJftkUBJ3EaLL6ZaBlo5
   4bB2rkxdgD4+tuKy+ahA+hcNniI1EO73w6fjRApdYfflfADDa89R0YHff
   x96bEYsTQ0GFph/B9AziYJ0UQzRa0Nhtn9T4Kvvg++QwGupjvMsVfu1vL
   P6zbHUbn+uQ8c6u7K9XX1l9L7RunbteaLjPXmz7soy/GUzeRK22uwXCNC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="401931779"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="401931779"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 17:26:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="751271170"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="751271170"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 22 Mar 2023 17:26:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 17:26:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 17:26:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 17:26:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 17:26:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffJ4UpSLEbIdPN+Fd9iZ2h8KpfRdXknzUmiiqWG0WImeHeb71Od1a22adnHKpdeur4MnYi1WB3dOzOffF2PIcuOdK0Z61nh65Mt+4q8vDI59eKlWRzQhWQL8tfRN3YenOh/J4ylWbilne7+b3YOC3JsWzI7ylDJfWTTjBDJWk5bhmbI8Pvy6FjcllNn643LhIlXlO57FR5tXIRWlDkjvrSmhkBO6Wc8wrW5+pJ6ZgrYvodGmNUasVTD3wi6ycyrX01lqn1apErF58raUfSP009P9iYUa0coWV83YMCebAcjA8O+lNQYuE83kr10s+R1dTP7bgd26xw+VbHhSb6FjvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ldbqzW9Fqi7gFb2lebldpT7nORaD1R+U40UGSISI4k=;
 b=jpJoa6TY+BHE0eKN/ziX7iE3VAfEzMpzK5e2BXnitEybVSjfgY8Go4y/HefQlwataBWO9cX4LJwvVAm41AZnGIjAt6jl4JudLXlAvw5gmUjLAjmnbjuphO6ebVDOb1zqEnx1Pm3vftrds9CjxEWUb940rse2p2uyMMc7wzClHT0ajalLO8DxNf5+XpEhsZu/XS1NVZTeFjHE5WCyBFFpdHJYsPwigxKRerh14+EC+qTrLisQWpqmyk01kHJt1uGb9P2fYHMKgLhLOnpcEL1H1IBPWj9qZkZucoeL8YVAW/XTKES2RyyNrGue357b1d6EB0kQ7j0C8HPR47I0v6g0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH8PR11MB7024.namprd11.prod.outlook.com (2603:10b6:510:220::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 00:26:26 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 00:26:26 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Topic: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Index: AQHZUKI3WfAyEb/jCU66DZKXu8CGnq8HLBKAgABX0ICAAArqgIAACW+w
Date:   Thu, 23 Mar 2023 00:26:25 +0000
Message-ID: <SA1PR11MB6734AE9646C3018A31872D88A8879@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-35-xin3.li@intel.com> <ZBs/sSJwr7zdOUsE@google.com>
 <c9abb017-0088-b96f-d19a-b25e54ad150d@citrix.com>
 <ZBuSg+3jJpjA5S5P@google.com>
In-Reply-To: <ZBuSg+3jJpjA5S5P@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH8PR11MB7024:EE_
x-ms-office365-filtering-correlation-id: 771e675b-292a-4100-f49b-08db2b353cde
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bvNquLtdLcnw3Hp1ywUGqCsMdpH7fBj2zh8BqYC/YZX7b9AQfYJFPRgj5au5u5jXYKJIxZ5KhfOwZxODqIMxCMgsvDR7fHFQSym5HpM5fANvmYdo711Q5DUfu5sLchUJ1IhzgNN3WpfA8ZApB6f9sQkxIYQGxf+qa5ficK44cLgZzTh6u7MVeiQZUbJ648H3zCl/A4bot1JIRUY6P6O5im908BSMK95YOsL6ktUoWLQUYEsDjKzpBbupgKdHlhuVPCN7uVd6TGw/sCf1hAoGcj0zxfjfqHwselaK27ADwLol6CZ4eF8v8QfUyGvY9tnirAXt4ZvH5ZiTwZzK21AzVL7nz6KDGH5XmIL/Zmv5Va6wvjRyyxDr+PFPEz841wRstuXj7FmcZc7GHXWCMLw/ZVEcEwBZwXB5KL811lr8ewGkKT1/8fzAxqhgDidFuUCM4dI3QDcXbM9XN9xbjtKz5fQ/uxHqqsYTWhb3VZXcYwAc5qnDVPW5uo3nWlDSgXBfGUwsUkxyD+FUV+cFphUZ9/ergdcNCxRMmMIjU3Yu+YTSFF7OrXTXmpmvw46lFLdhyo6PcXyohpUSoMDqqQnkoUoC4bB3+Av39YEUGcIcM9PsSUo4c5AfVvrOF+Ae2U3uw0XrX8gYqB0qEMUkhW7LOsc+1irRINpoZ1OdP3W8UYfUSot9XiO3rQ4oR21qEowTuq67cPZzl/3B0s7h1N6bxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199018)(316002)(66946007)(7696005)(66446008)(76116006)(478600001)(122000001)(82960400001)(86362001)(2906002)(83380400001)(52536014)(4326008)(64756008)(8676002)(110136005)(66476007)(66556008)(33656002)(7416002)(186003)(71200400001)(38100700002)(41300700001)(4744005)(54906003)(38070700005)(5660300002)(26005)(6506007)(8936002)(9686003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BnjAFlbtaFedaTJpQVa3OcGWbKyVUl8jyoka7QV6qvTMwTQbLKoo5tskb50L?=
 =?us-ascii?Q?cftI5Q+q1RVcno/zlnuMElGrtYjf/B6JX+fvDOXrL17fUDLtSv8h1F394s2l?=
 =?us-ascii?Q?D12VrpP2X+kHZ+nlGwQ/Bt44IMidXbm9mSS3GdCARaLUgKyk6LN1ur9aAhSt?=
 =?us-ascii?Q?mI3RBITvRuIBgtGlFEmse0x0genPAQy6ZL0MUTr9gbEsqHOT35LvraScTRCY?=
 =?us-ascii?Q?9ENoXkcSjw90TuJ/EyGYuNbDb/q2aCqSr8LbdxyyaN7j7vIUIhpGVI2z8xFd?=
 =?us-ascii?Q?whiKXIlbFWFej53lFvHh5zwLBBc50M8Uu3/BclJcedPPDmecVK7LdPmmHUg0?=
 =?us-ascii?Q?oyk3dyR8fAt4lNDINhNuBcPPP9/p3n7WWztGjn2NXd4x2EgkUURxfXns+SMh?=
 =?us-ascii?Q?ksDaoXOqo5qheiM+JeU80ZQqSJQ8OYtYkm9+bXF9GplgQGRQOwtkwOVCHsWL?=
 =?us-ascii?Q?0lPaokkq692KnI1g2uwRVNtuN8uKckIgTP/gcoss7KhfdLd9cmp41psa0FDQ?=
 =?us-ascii?Q?0pHPPreMQPwN1HHm2FMowuV4kbY77+rWUQch26SYaeFOOGmxO5UGxPfCcXbn?=
 =?us-ascii?Q?XFcHgihMdkqn6v6qvKhrAPW/CovwrtQswE1mSMnavbtXpjUPkHCyEImcNLp7?=
 =?us-ascii?Q?8ZdH2wL3KFaux77rriOoz50i1N89UA/Ytu91abOMaC8bKtin36cjLn+GjLke?=
 =?us-ascii?Q?nTkAj3Trd0NpCBDbvmVfd9dh4ShIHnYwP3pI6I3gBoC/v+cBP774pNlL/1ve?=
 =?us-ascii?Q?CLXaLp2xuKdRkoMPUcySQQlWEeQCJXZ8OWiHz6YAHsrFSJHgRrNRTv8s/cy0?=
 =?us-ascii?Q?YBHUQs6lJYUm9J4Wcys/dJolH6ITLA7QH5rrXaEh4qAWBZ9iDjD0VXdIKuvV?=
 =?us-ascii?Q?WRWyzBMgwbNskXUSgNVPrv+i1H3EHZo+9HAzIq2V0YFKJ24Bm9MBdxy6Z+Rz?=
 =?us-ascii?Q?18Rk9vg+Qm+R4YACl1KlWSfOcHlCBThqf2LvuU1fxUczNC8HHUa5jp90dv6E?=
 =?us-ascii?Q?p42ojsM8q9zVSSxqcyeaQCLvSLwp/OnfKPlSmc6EzlGN6ehVLEW9x3FnMDm6?=
 =?us-ascii?Q?TCaF+2NKhQNvW1PgfASyeCPwlYDU0lP70de4opGPCfPzdvSR7qyIh1E5Wwmj?=
 =?us-ascii?Q?tomjB3UEBEeZtxWKMzK8Yqv/tn6idma2aoXusyxSP61f4+pY4XmPlIxd1DzZ?=
 =?us-ascii?Q?XE99whfg48jnlV88VFdLU61JxHaidOaHfRR04nD7n4Iy04oWuJLDz8FIPZwb?=
 =?us-ascii?Q?DaBrOnuiIEF+Ml0678fbiYioSZHluJuDEBwlFXMYzkcu9UKLPmcpltG3B02L?=
 =?us-ascii?Q?2eloteKy9l153qC1mhSwfdoOP0ygdH2SuCevUDR+3QHxcaWBtdJ+IjDwGVuC?=
 =?us-ascii?Q?PWWM2D97pUs3RuPWTNi7zQGofjfmxp9Gb+IC8/yL83jSgZr8T8by8vfagEoo?=
 =?us-ascii?Q?2Tb17r3A6hvmSaDtmnmL2xGgPVC9LS/gryFbEa1RSzR+2zWjv4em90pxqP+e?=
 =?us-ascii?Q?sdfZFgDCdXcU/zDu8iQP8usGQpqDLPW4JweiXr4EYkLFmQ4n7TGszlYIiQ5k?=
 =?us-ascii?Q?XJIxA5k8tJS0u4l76N4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771e675b-292a-4100-f49b-08db2b353cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 00:26:25.7406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Djz9/+wkkm9fi0EbU5g1POczpoTQpD4rXQ17YPHPYO1eNOWwI42AZcgqXrI2omWUCltQEY7Go2GFnI9ud12Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7024
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Organization aside, this seems to defeat the purpose of _not_ uncondition=
ally
> unmasking NMIs on ERET since the kernel assumes any random "int $2" is co=
ming
> from KVM after an NMI VM-Exit.

I'm a bit confused.  KVM VMX is the only component needing to execute "int =
$2"
and it surely has NMI blocked after an NMI VM-exit.

> Eww, and "int $2" doesn't even go directly to fred_exc_nmi(), it trampoli=
nes
> through fred_sw_interrupt_kernel() first.  Looks like "int $2" from users=
pace gets
> routed to a #GP, so at least that bit is handled.

FRED does a 2-level dispatch, unless an event handler is on a hot path,
we don't promote its handling.  NMI seems not a frequent event.

> I'm not dead set against the proposed approach, but IMO it's not obviousl=
y better
> than a bit of assembly to have a more direct call into the NMI handler.

I will give it a shot.
