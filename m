Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707016B7AD4
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 15:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCMOt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 10:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCMOtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 10:49:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A91BFF;
        Mon, 13 Mar 2023 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678718949; x=1710254949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8E7ptsixEkrYZgw7ph96LfDpa9E2s3AviLJFGmFWNNI=;
  b=Tf/DH5x9pp7qT8uUpPh4xEGQSqRf7n5sVydeqKzippcZQb+3KzK9EsQK
   YLtNsnB26TIZfIlIa9Ptla1NBGd0DJGNDJTJPZtL9oRyaHtga9Wri9mKg
   7xXr4iiiAVomPoR1nIpb4zQD70xVhywsMm26oMH97BkeIVYFdpmAJN5ws
   JvAax5gMyd8VjErpU3pNyZ8TpO1CJdphSUJbMLoAtXsJPnSwJiMkApO+R
   YX9s5Gd8Ol2Aizs26l4eA4QLNRJsubtdI0Beoul714ZtwKCSCZNFX4m9D
   I3hdp5wlNmoZ/Hmwz6qH8JDV7Yw36u37Lyb6gjsKnnvR61Qn2XpqE+4eq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337185321"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="337185321"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="681065840"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="681065840"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2023 07:49:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 07:49:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 07:49:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 07:49:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 07:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Av4CF+tIw/1FoA4DAOCwYDUwz6Gs4Oxq3TrC+kV4WYGSSvavEjdoVeJ0KWJIxAZbhQQhIoo23XBF/vIdy+/SD3fzIY7GfGCH0yStpKytbbWjo/F0lRb50e0HXkvajehjJ/cogjNM7XfPm4loNCE2nQKr1wEMSQ7XVPnvx2YDpBztos2oJn9dFzr5bIppdT1ORwgwAD1A80pEyQWO+dtGDdNiaJ0faLiORvsLau1MR3GJudRlzte1ZwKKlKaiWlk1/XF84FXCXnhtaellEYZO68na0K9aF3rntOPMhayHnMdkahU6yTxSyi5OZA9Req/Q6HVcsKQqgQagFSwDFZjQEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTIqVwRLAJYLr6GwIMEMkZ5jHFhdVfPqnFCKvdUNYFo=;
 b=UbWALT7DZrDxGLS0As78Ovd0Eo5gJ+3BCcy79I8ILYMCQMfRnyFbLN1TaPJJokE9aVQkqnx4u8g3dSxRncanWnGZCQFTnoBatBxbMyg6eLSGpb2MRAM1V3nu+579CvjXOyBk9EilDNWeZLnulw3xLTSGN6JW7fzkwxhaPnMkZtf4I8OtmBj8FST0b7Wd26d1HsDNvI/3l4F+gY5tWJIv7zW4CqMdIcS5x1pfGctVFiCru0T1C6ylGNwGU94rANA6W1IKfNfTqiOJQQfkhebCW8ZFYuc6HoB0yxvlvbcp4dPJVeDyCHI943QQ/nyGdFD12qieijK6SD6dqNL0UDmnaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5158.namprd11.prod.outlook.com (2603:10b6:510:3b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 14:49:04 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6178.023; Mon, 13 Mar 2023
 14:49:03 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: RE: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Thread-Topic: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Thread-Index: AQHZVQwyPtweEeflQU+AdyzJJ/rB6K74yaGg
Date:   Mon, 13 Mar 2023 14:49:03 +0000
Message-ID: <DS0PR11MB63735A7EEC68894923925ECEDCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
In-Reply-To: <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5158:EE_
x-ms-office365-filtering-correlation-id: 99b3338c-483e-4610-b5a9-08db23d216ff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iSsT4fcdmrybKfOgIj6KmaEK4ppjnJCKbsBT9Oi9Z37puXoZ/uq0/1VuU+DFKWTZRfPKRKaD8hpeG+yZFNT+PV4VxO0rfJ5DdEAVbWZ+yv/kKoWpYENwVO7t517ZMoL3U5SVcvy1oTrX+nCTWQZHR98t+CsVoLZpXZbNIaMsZmXgmvo73F7mlliimZtxYrKvq9wBf1cQlfpXMl/k8TERStZ42uSQicukcISp+xCWDRdPCXbrmLGRBqd0vSDKzcu5Op7afP9zHn4NZAFqf1OH9NulRqhmxtkofJ8lRb6cyS6Jqte3NKLkHB1PpKIWb6IfhV7iJ85faHifuON9crh4VHhhH08Op4JP5IEgBK8ZlKT4nau0iQKUfpnoM+E1IZVOe+4ig8edEsxmqu+Xw4d2CYJKIZ7/y3pzasJNxglq1ORTTbiP0fEbMQZBKdlVGBss8g3ALbyByU0JHbyh83GQRqOZMdotAUp61LyygUVWi7oLz43ZI39DsDA0fSWryc9s6Kj52V8dcnEDcejXGGtbu/4aXb8juLe74nGpSn/CrjeqbKIDbWFUOnJhCpV3bZT8vEmgfkhz0NBA7wrUAWvk/GQ8lqpQdb6OACMsBsPqHnsQhJg1F3GSJ7elaKN7rZltU1uy0+Hy24wPL87+yJJRo3zrk3Sahw+7NB0Bt7L0AQLF4tQP07WF95tZJLPMWvKey2KWCcbPmZih82f0KS0+Dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199018)(5660300002)(83380400001)(186003)(478600001)(6506007)(26005)(71200400001)(9686003)(7696005)(53546011)(64756008)(52536014)(38070700005)(4326008)(66446008)(66476007)(76116006)(33656002)(55016003)(66946007)(8676002)(66556008)(41300700001)(8936002)(86362001)(316002)(110136005)(54906003)(38100700002)(82960400001)(122000001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3HOxlJqT7P6pEwE+rS0hoJi7ukfBd+KxUF9bnjCXm+KZ+bHGxBGTfnNZBmkN?=
 =?us-ascii?Q?NrcLGf8KOSMWlVrkVF7vkIZ1J8HfQLuS2nbjO81XKOU9YjC1EGq1pDGUBcon?=
 =?us-ascii?Q?GMG1nSw8K2qiDnfhwgqI0gJiUbZc0XyLZLNShUBoTG5J4KyC4nVV8v7Rp+NS?=
 =?us-ascii?Q?+I4T4utnFrQLYGzLdXwU10w9qA2KwMv45LwY3YU0eLJoX4DTWi/AHobRD2lC?=
 =?us-ascii?Q?7iiOWqhjB9M6UHW3/nkTvvzepH+Y3xVuTsO/ID2uKuVZf/6Iv78FOJHeQu8M?=
 =?us-ascii?Q?5Rdx3j+jFPPAu9n0CgVoDt3JjjppHZ3+v3+bdEtAOBu5f7CIhpfflydPIdUc?=
 =?us-ascii?Q?IBSSYceUx0sGxu/wgBo+DypBOPV1yWX2fVkargjfAXnK1y0xnSLDWD92YKaf?=
 =?us-ascii?Q?F4oSSwfMDohNEDsQwZ2eMFpn9hltN0k9l71fBe0E9XPxEWB/PZ2/vgxGJkzi?=
 =?us-ascii?Q?piVb4l2WKVWaY5cJz+vWh1xYqtJ7A6RlyEhqieK+qZUYGRFdFVoZZ48W3OB6?=
 =?us-ascii?Q?XPtuwvBSZLs2m0hvTMoC3LgZKqB9aYN5p7KpE65hG0A4h/uind+aN2myZvWE?=
 =?us-ascii?Q?bRZsqofsm9VGiQbH+5m3UelPMfWnBlX3ovKKl7oGf7WEkr6xeWpic0X9G2lH?=
 =?us-ascii?Q?Ri5MnoYBe1v9VjiSFzNqHGGQOOz4si7Rg2k99RwVX7k8KQ68kOjieHM3tWfN?=
 =?us-ascii?Q?0fq9D0RGpaEbexSf5TMX2/OQV8sf+K0d2m7BurMtCokCEPybTXegrJ7W73ul?=
 =?us-ascii?Q?yJwHSzmoC9fl+uGr/onDEozTObwDoXxqGpjmM0pzaoIZI3Dd/CUKHV4svWdj?=
 =?us-ascii?Q?Dpciyn7UKTNbrHhekVNl4Rp3AYscAZ4lr5AmsX0iQo55kUhP7VVFTf/NI1lM?=
 =?us-ascii?Q?3gGUvaLnbX3qHrZilzvd8LeYGw2dtsD15wi1TdeunLwETrSAmHgeef/uUlps?=
 =?us-ascii?Q?6dsl41yFukRXAv0D6L+ZSZAs4NI3njY/HRjFRyloZ80dFMUs2S3VEADpCM5F?=
 =?us-ascii?Q?KgM95RkY9bm5nluNSq08YYIY3JlwIQ9neYISaYw0UKaXwh/Rv+ADg3roBbWv?=
 =?us-ascii?Q?Ky0ZzrqU+cnWO6ugMgKUlNAeZw4+C3qSqmN42Yxrnybv63A1hBoxfyvGGrAt?=
 =?us-ascii?Q?V8QMC4YbQay9mk67NG8GYA8ZDie38OfH7ALGBQ+A95YK/E49suCs4+2JPw8e?=
 =?us-ascii?Q?7vVbiIeQt8w7VGV9XuLrNgexJlWSGYVlY4QbBtZVN41ScDarBYDjBP0Y9dt/?=
 =?us-ascii?Q?n44OgctXyDTdEZ3+5A1IJtIYLGOJsHb8EbSfCVHfz2b4O88OQrjsVzY2+BHL?=
 =?us-ascii?Q?6MjEerjU+4DTgt5jh8Mnc9HaRaEqINtj7CsZcjSFMx9DHz6JXbwwfXV8mp5e?=
 =?us-ascii?Q?xKR+RU8cDm8WSSWh7/u4m/ZaNsxG+uXlLsU/DUEn1BSX2Jdr51Pg1aOsIrHR?=
 =?us-ascii?Q?oUD0seoz0mjHG8BaSgnqn5vOQ/pWKVUoYwGX7EUGoW9vsAY1aIrn6IEVNqrB?=
 =?us-ascii?Q?yPgrfl1to9LLqmYecjgjgJyYD/ZZPPzWak2jesaIk5hxEgm+OhbI1xUXis5H?=
 =?us-ascii?Q?QIleghHXgO8o3PwrbyqBGflH1CE1sbwiQpcfwCse?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b3338c-483e-4610-b5a9-08db23d216ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 14:49:03.8393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oQ4uIWiz7GLIPWBySQBo7iAM98eD6u3UNZjtzv7XYDelq4daEhNFi9pHoqTk7mDtrkBVJtcLmwuRoFG6ps4eVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5158
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, March 13, 2023 1:55 AM, isaku.yamahata@intel.com wrote:
> Currently, KVM VMX module initialization/exit functions are a single func=
tion
> each.  Refactor KVM VMX module initialization functions into KVM common
> part and VMX part so that TDX specific part can be added cleanly.
> Opportunistically refactor module exit function as well.
>=20
> The current module initialization flow is,
> 0.) Check if VMX is supported,
> 1.) hyper-v specific initialization,
> 2.) system-wide x86 specific and vendor specific initialization,
> 3.) Final VMX specific system-wide initialization,
> 4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
> 5.) report those sizes to the KVM common layer and KVM common
>     initialization
>=20
> Refactor the KVM VMX module initialization function into functions with a
> wrapper function to separate VMX logic in vmx.c from a file, main.c, comm=
on
> among VMX and TDX.  Introduce a wrapper function for vmx_init().
>=20
> The KVM architecture common layer allocates struct kvm with reported size=
 for
> architecture-specific code.  The KVM VMX module defines its structure as
> struct vmx_kvm { struct kvm; VMX specific members;} and uses it as struct=
 vmx
> kvm.  Similar for vcpu structure. TDX KVM patches will define TDX specifi=
c kvm
> and vcpu structures.
>=20
> The current module exit function is also a single function, a combination=
 of
> VMX specific logic and common KVM logic.  Refactor it into VMX specific l=
ogic
> and KVM common logic.  This is just refactoring to keep the VMX specific =
logic
> in vmx.c from main.c.
>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 51 +++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 54 +++++---------------------------------
>  arch/x86/kvm/vmx/x86_ops.h | 13 ++++++++-
>  3 files changed, 69 insertions(+), 49 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c index
> a59559ff140e..3f49e8e38b6b 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -165,3 +165,54 @@ struct kvm_x86_init_ops vt_init_ops __initdata =3D {
>  	.runtime_ops =3D &vt_x86_ops,
>  	.pmu_ops =3D &intel_pmu_ops,
>  };
> +
> +static int __init vt_init(void)
> +{
> +	unsigned int vcpu_size, vcpu_align;
> +	int r;
> +
> +	if (!kvm_is_vmx_supported())
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> +	 * to unwind if a later step fails.
> +	 */
> +	hv_init_evmcs();
> +
> +	r =3D kvm_x86_vendor_init(&vt_init_ops);
> +	if (r)
> +		return r;
> +
> +	r =3D vmx_init();
> +	if (r)
> +		goto err_vmx_init;
> +
> +	/*
> +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> +	 * exposed to userspace!
> +	 */
> +	vt_x86_ops.vm_size =3D sizeof(struct kvm_vmx);
> +	vcpu_size =3D sizeof(struct vcpu_vmx);
> +	vcpu_align =3D __alignof__(struct vcpu_vmx);
> +	r =3D kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> +	if (r)
> +		goto err_kvm_init;
> +
> +	return 0;
> +
> +err_kvm_init:
> +	vmx_exit();
> +err_vmx_init:
> +	kvm_x86_vendor_exit();
> +	return r;
> +}
> +module_init(vt_init);

I had a patch to fix a bug here, maybe you can take it:

kvm_x86_vendor_init copies vt_x86_ops to kvm_x86_ops. vt_x86_ops.vm_size
needs to be updated before calling kvm_x86_vendor_init so that kvm_x86_ops
can get the correct vm_size.

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 41f07d92aaf6..37a8c212c653 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1126,18 +1126,6 @@ static int __init vt_init(void)
         */
        hv_init_evmcs();

-       r =3D kvm_x86_vendor_init(&vt_init_ops);
-       if (r)
-               return r;
-
-       r =3D vmx_init();
-       if (r)
-               goto err_vmx_init;
-
-       r =3D tdx_init();
-       if (r)
-               goto err_tdx_init;
-
        /*
         * Common KVM initialization _must_ come last, after this, /dev/kvm=
 is
         * exposed to userspace!
@@ -1153,6 +1141,19 @@ static int __init vt_init(void)
                vcpu_align =3D max_t(unsigned int, vcpu_align,
                                   __alignof__(struct vcpu_tdx));
        }
+
+       r =3D kvm_x86_vendor_init(&vt_init_ops);
+       if (r)
+               return r;
+
+       r =3D vmx_init();
+       if (r)
+               goto err_vmx_init;
+
+       r =3D tdx_init();
+       if (r)
+               goto err_tdx_init;
+
        r =3D kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
        if (r)
                goto err_kvm_init;
--
