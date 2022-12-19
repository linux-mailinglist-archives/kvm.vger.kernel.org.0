Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59104650CA2
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiLSN3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 08:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiLSN3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 08:29:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A18BB7B;
        Mon, 19 Dec 2022 05:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671456591; x=1702992591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=88sMkc4gncARH5GAm70vff3PYqiI9Xmoy9PKKZ5u1JI=;
  b=h0TADSncFc5AMM3ZppkDKmeJLmzkjBk3u0i9T11ZHVsGDaN5JD5TOvUN
   1Aia0iibFtEXTpdUkO/NrMGdMxlwMCy692jWosQuB+7GtpNvw9ToSHjAs
   9KCdKg6qHvRzi6Vp6TpQ26eGrNRwr+VIF8Z1oElnVOCAYBfKcB1t3GAro
   IGXzjLdr6CA6mF2meug+HqR051EqitlGxLbr27c+m3omojfvAZzyPiqvV
   ymlmHHF/k2F4QiBXs/vOTYEvP4nGCr4B046c+f6Rm9//Fgoi9PYQppdaK
   75IvS8gdfPRkg7YKidEeFUnTIp78ZnMVshTwnGWGL4n7dkttb/cpULpxU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="319392412"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="319392412"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 05:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="643998564"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="643998564"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 05:29:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 05:29:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 05:29:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 05:29:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 05:29:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StZY/rEBCNZ4OF6BzElyQKPk0yvpdipz6amPi71pAnf0uNXG1ezXKUmyYOr/+K6oZoCxnCbGJ2CUT8dac8D/rH4cvk/5AFju9GggNeXe06CUFHsTvWfpz6fJU9tp+aNArjjAyhvWKXuu22dq0UaVN6y08z6RCPBAu45lkn2TtcgzG3qK1MQJt3Mr7OUQf7WnrL+LCibzOKU/WjT8NXQi/1qa0agKBKeKlIJ91XRaSecVpA8ZFRkCTb8PHzY+gA+cSDzkqbAAj9fpLAJS2lkbaVNA1n13Wx+1Tq5BHkWk155gK3V4fHYF8qsxRtCB+tuCAGzcqyT8UOgGRL/KuGWVtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFgH6+SFkfnpDcuJmHqJmeEHZvyUEkN7rfk+lhBH/KQ=;
 b=IHtMGjfF6wkhg5Uh1L9SMKKI48Uz/GDGM4UxM8W2f37x0ltTQpUserQA2zej/DC7Pd+kK3v1kZU9qD+ejXdsClDcDJkBkVsXhjdT9sZK3PYlyiJ1DSxJ6lkZ2HMJBiYAHIjWqaLNeRgGcUgyP7TIj7tfrziWLQFYjlPf2mBBXCLnGD8Mm6ImJmu7gFN3LqIxQ9ObMRYEVQjp2R/mNvVK+kq5gWPpI2q1SEN0bKbyxvM+f9oUc0wRS73afdwnLW8afW1Gcm2GeEneKjkechrLJZjY/OQOxIaYXYCFf29pbiQymRjWuhAXdQZaTijvdUBbgXEpwDJyn+zQL8lyujmDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MN0PR11MB6278.namprd11.prod.outlook.com (2603:10b6:208:3c2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Mon, 19 Dec 2022 13:29:44 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4%5]) with mapi id 15.20.5924.012; Mon, 19 Dec 2022
 13:29:43 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: x86: add KVM_CAP_DEVICE_CTRL
Thread-Topic: [PATCH v1] KVM: x86: add KVM_CAP_DEVICE_CTRL
Thread-Index: AQHZEHut34nQNY6vl0i5iX10icsI565wwkyAgALfpHA=
Date:   Mon, 19 Dec 2022 13:29:43 +0000
Message-ID: <DS0PR11MB6373187B53B558EF73FB202BDCE59@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221215115207.14784-1-wei.w.wang@intel.com>
 <Y5ynFUdZXpN5HP7F@google.com>
In-Reply-To: <Y5ynFUdZXpN5HP7F@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MN0PR11MB6278:EE_
x-ms-office365-filtering-correlation-id: 8b51996d-b488-44ff-0d48-08dae1c5171f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U2u8IUY5XBwruZuUEGIBbejcnuBuivir8/z774XLuU4wpS63xf04n2GmDnYEA+6OvEsX5uINU5iRZ5Ie+LjMty+kDhoZps27RXQodw4WcEVwnS1vdA6o1InEFSpHqrABUmxATJDmzgDFHPMGHO3G/U8/g+w/RDu0QFjSr/UmYsRfFhwl/UHfQKC1mfiDfLMpjeKZuYi4q+rrtAQPMIWb7xrUt0YoOsxM4NEUlegL9FxsT75QbaOE/DFonbAsFbQ8TetQyN+GXFd/nCzNbNj4zDYknTV9TCvQbvRo2wv+HMcN906aBJXemsezdI+bDHMH95uDONcK1atECrf1N8V2oFdvMM46cKtrt/Yyb935sBR78qvKrA6zpjzIhaS8MWyho+T7vN6z5axpfMdJq7MUueHpd3pv9yft9lathkxIZ5HBCm5wWIZ4YIA9fHEhE4ADyz4VqC8ZCbsGYg6En0AwbYlsQ+u1p9d+WYungUAF1vT259m1Kh6DjVdtzInE3GbMmdhgcYSIhcLTbKKTPRt2lkwdL6qba2ldx//hH0p/pe/mOZ/xFN5Z3EYxIhGAJSSolis2EKyICSLlmSGnhPZJyQSoPhw+TimSckxSyajruVi7On9U+FrlMSCA/L8jm4Gx4Nhe9eAUMQaSKufi0U8s/sSKknu1ErImSYSO86eI79NnFQkGsVGAVuE9amTG6VuOGSGuqhfiWO62xlmHUM3+fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199015)(8676002)(8936002)(4326008)(52536014)(41300700001)(38070700005)(38100700002)(122000001)(83380400001)(82960400001)(2906002)(5660300002)(53546011)(33656002)(6506007)(7696005)(71200400001)(478600001)(66946007)(316002)(86362001)(54906003)(6916009)(66476007)(66446008)(26005)(9686003)(186003)(55016003)(66556008)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O7oq1R9lYHUzrfetpObuTGcxsc0PZG3jDUgRZxsy9ga88mkFzJbAdZGykc1p?=
 =?us-ascii?Q?ywAyB+HAq5VUmZR+q776AgI1txkaavtvhIH2LmccH/2UDObp/IMrDewUpA2l?=
 =?us-ascii?Q?6MwGlZWWWBRa/1/I7HgVHyg2ipBqd/dANLhVSFXs8WHmY3vX9LRMVnsQlSZI?=
 =?us-ascii?Q?e4LXIVLuPkIx5yHOI97S8PcTuPwUKIUyXPj8NIdedYUnjDQXd9yU1zeVKFhz?=
 =?us-ascii?Q?vLnV9vQpUGZbED9ED6l/7wPRgDnokOZVi6c5JRlGFGl3iVPEWJ1o5GM11GLb?=
 =?us-ascii?Q?FTHBCw0kFg0xLzQwdXNRvtEZ+NSfiea2PG7QBZhqvltrE/ILDeQzNKO/lGgu?=
 =?us-ascii?Q?44isnET+6y6omR2JKuwLYBr6ITof6Vq0p/2/AqHRhaahJ0Yw3vr+FtewBBHo?=
 =?us-ascii?Q?JGawtIMkSEcjHXfkeRrGRYndKySc3Yp7hCIhHHU+NsNPLQxAebg9xkEdTwE0?=
 =?us-ascii?Q?zM0Lv9lIZj+RCnWwgszoMNlQyIIDJliojaNMF0vywhSDDnlZqK+f/ihZCMvD?=
 =?us-ascii?Q?r+tkRwDbMbtqt8dkz0u+z7FzVccpOR3kDiUCVOt+8QBKxfeiU8aTc6wSgNzn?=
 =?us-ascii?Q?tKB9z4upwTIB+XMGtj0uVwzAT9MAB/j7rfz/FOlwPaE9oBIHJ43RgbD2CHrb?=
 =?us-ascii?Q?FEgWb/fSbHKHelNPIoGvPmwgnFW6mOxyEPMpMoi2j7AKT7JtQ3643Icdz9t/?=
 =?us-ascii?Q?dlhUDkSP41k+nCrGfB8oaP5XoxJn+rLtyoAMzaT6vXllzbUxfInLIs26sPkR?=
 =?us-ascii?Q?5+Rv7vWzW3W3ClI6VS3IMw5fjJxhZoY5Wj7JXYVBkhuNIqVUUzbKkSFBnf8U?=
 =?us-ascii?Q?oAKTE1GTH+/6lt4KiQLhEq62S/CBf5PRJ8vWHBaUrZrI01D30u1edzvwtarU?=
 =?us-ascii?Q?vtnmPqIjQyt5MERfzwVFBir29HybCjFY63qtSaa5y8YuuWViAIVHvNf1T8S2?=
 =?us-ascii?Q?YKEUVRrFMBwvn+PtYE689zRKS8nkfe/mvd9TzMtGLac7kRnw52fJJv1iEGZ8?=
 =?us-ascii?Q?MnppGxdXBz0mJmxUMx8qGru9aAGUVutCxUW5xuJP9X1rBH0dsjHBSD6V1RJz?=
 =?us-ascii?Q?CmHidiBJV9pJoGBOQvRKGxR87BXTJLh09iqndxWQ8gnHEVCoKV8UOHMnN+x5?=
 =?us-ascii?Q?ia6KQICNquuTtKk3fxgHJAVu1aeNfosO9+rUtoyle3GIdfkf6j/YtjlKUNOI?=
 =?us-ascii?Q?GaORuOW9woJ9bO1FvF+4bWoDo59NpmOwfhAIyWkZ4OZht0RWy3z7XBH+Qfql?=
 =?us-ascii?Q?OlHCFTDVWwrNLfEwe0R5CWnM5r2QfyJufYUPrxRak2RmhfRfy6OVC4U5EJjR?=
 =?us-ascii?Q?L4/1bKep2b4eKQM2fOG26OVnQ+ybaXPIkricM7ezmqGy5nd+lhh2oTrA3m81?=
 =?us-ascii?Q?pJxCBQNdkOANmklV1TPlXPjTBxbhQLkjcc6uVPCK49Y/CgmwSjoGiwg1awvY?=
 =?us-ascii?Q?4O81tDMgRqg95IOSHNCKVScssp0oHA6ZK8EP8QFSFr5BwDdUVR+NdG4vUqhJ?=
 =?us-ascii?Q?WoJtzbWFhqP2jjz41QDit40PumYo27Y57kTLXS0FGEZFzjwE8qlngrbHKnla?=
 =?us-ascii?Q?WbC2NfWRPzmmZAmqoF8fwkmBvnSIJE8I23pw+4X7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b51996d-b488-44ff-0d48-08dae1c5171f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 13:29:43.8595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wl+SIMm2FagpaWOhM25FubygHvV4nRDUQacdjrk/BY0YlHux1bHnKvQHpoXdU3Cc0DUX1LrcwyvxEPqtc3pljQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6278
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, December 17, 2022 1:13 AM, Sean Christopherson wrote:
> Rather than hardcode this in x86, I think it would be better to add an #i=
fdef'd
> version in the generic check.  E.g. if MIPS or RISC-V ever gains KVM_VFIO
> support then they'll need to enumerate KVM_CAP_DEVICE_CTRL too, and odds
> are we'll forget to to do.
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> 13e88297f999..f70b9cea95d9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4525,6 +4525,10 @@ static long
> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>         case KVM_CAP_BINARY_STATS_FD:
>         case KVM_CAP_SYSTEM_EVENT_DATA:
>                 return 1;
> +#ifdef CONFIG_KVM_VFIO
> +       case KVM_CAP_DEVICE_CTRL:
> +               return 1;
> +#endif
>         default:
>                 break;
>         }
>=20
> The other potentially bad idea would be to detect the presence of a
> device_ops and delete all of the arch hooks, e.g.
>=20
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c index
> 9c5573bc4614..190e9c3b10a7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -212,7 +212,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
> long ext)
>                 r =3D vgic_present;
>                 break;
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_USER_MEMORY:
>         case KVM_CAP_SYNC_MMU:
>         case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 04494a4fb37a..21f9fbe96f6a 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -541,7 +541,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
> long ext)
>         case KVM_CAP_ENABLE_CAP:
>         case KVM_CAP_ONE_REG:
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_IMMEDIATE_EXIT:
>         case KVM_CAP_SET_GUEST_DEBUG:
>                 r =3D 1;
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c index
> 65a964d7e70d..6efe93b282e1 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -57,7 +57,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
> long ext)
>=20
>         switch (ext) {
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_USER_MEMORY:
>         case KVM_CAP_SYNC_MMU:
>         case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c index
> e4890e04b210..191d220b6a30 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -567,7 +567,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
> long ext)
>         case KVM_CAP_ENABLE_CAP:
>         case KVM_CAP_S390_CSS_SUPPORT:
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_S390_IRQCHIP:
>         case KVM_CAP_VM_ATTRIBUTES:
>         case KVM_CAP_MP_STATE:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> 13e88297f999..99e3da9ce42d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4525,6 +4525,15 @@ static long
> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>         case KVM_CAP_BINARY_STATS_FD:
>         case KVM_CAP_SYSTEM_EVENT_DATA:
>                 return 1;
> +       case KVM_CAP_DEVICE_CTRL: {
> +               int i;
> +
> +               for (i =3D 0; i < ARRAY_SIZE(kvm_device_ops_table); ++) {
> +                       if (kvm_device_ops_table[i])
> +                               return 1;
> +               }
> +               return 0;
> +       }
>         default:
>                 break;
>         }

Yes, it looks better to move it to the generic check, but I'm not sure if i=
t would be necessary to do the per-device check here either via CONFIG_KVM_=
VFIO (for example, if more non-arch-specific usages are added, we would end=
 up with lots of such #ifdef to be added, which doesn't seem nice) or kvm_d=
evice_ops_table.

I think fundamentally KVM_CAP_DEVICE_CTRL is used to check if the generic k=
vm_device framework (e.g. KVM_CREATE_DEVICE) is supported by KVM (older KVM=
 before 2013 doesn't have it). The per-device type (KVM_DEV_TYPE_VFIO, KVM_=
DEV_TYPE_ARM_PV_TIME etc.) support can be checked via KVM_CREATE_DEVICE, wh=
ich reports -ENODEV if the device type doesn't have an entry in kvm_device_=
ops_table.
