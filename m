Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5361637124
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 04:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiKXDlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 22:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXDlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 22:41:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8638459FC0;
        Wed, 23 Nov 2022 19:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669261264; x=1700797264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wgUkR+RG1Lak1kz8QSrASaz+IVXJCgquIgUq/ZU6Wn8=;
  b=DY94i9VrAJ9rtGaIjIr3/OBR9IW1ZLrd5JEGoT4MqJ2ssEG5Akls1RuA
   jiykaL7iGj0elgjjWNSKw3yCUMh6wm8HyBFF4VG6j1O3mh61B75WaQkiB
   kfhfMGksHjIfpyH9CYSTvC+rOMtPenGmnBTxJWBIe7NSO+lNTb72STpZh
   yjm2hAvJSIA96inhJAlkVP/4DlI2uis98L+iHxp4Ejem2UMpBSd1JVLuf
   7eIfHD6m1dRkNYbsqmGvEN1lEs2NHl/LjysU38p3JgtSxMcT7ZAtm4gHC
   OxZGQMqDw4nidEl1GAuh75DKNinmU6gHSmZGgwVji42xQtKtUv3giuo0+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293913223"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="293913223"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 19:41:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705598107"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="705598107"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 19:41:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:41:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:41:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 19:41:03 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 19:41:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ludXGWZjoZEdyd960M1bv4hkJD6nIUloGtsRXw1dPHFGzXD39RAkuAYFgEyL/dUuTvjfMl16hAfy6jXqCRFxOzA3dQtJtFy4uCRMolxS9v8GXQPcSJcebl5v3KWwQx2btvlWMwb0mhT/2kE+Q9buV2Snh0vIemkFcmRJZec7N8m4oEKnrdV+4emhaUQKlnb/ATGTfLp7vgnk6jW4MnKX0KmiK9IxK+jKiQvidaOy3u8/tPX1whyiTy91kkHwYint6sHwqzU3hHJcts//EXRetKPidVpknIPoC6WbOZ/W5fJLYP5t0oSZUhr3mAWfJyAVVkwGv4udurpoAB16MmLceQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiumtgGCDtksTmMZ0Okwa8PPVlK72lNX32Q9cP7g3Ck=;
 b=Hr63j3lB2btehK8MdmC7KAYvkCyldKhUw8CRQ22JFUsWl/l/LbjEDsm6w12rhRjJx7jRzQpwmlsFHHqnWQaTx0ZzwNaJ2wxTIv1Y81hcfLIf4HnaxvApbZFaAkf2ec30yLwREGpxWJ2MJey0/BmrBMKmuAPhGh/o8lz1WlvMre/pjFnDe7otQbQwszGvLmG1N/jFdlQfdNPVJEwGrSQuN1/CrtmVxWY5tlLmy+/j1MDumsr5VhnT7tLlStszQ2PxdRdpwpEpcofUv95tZqjDULzV+lfxkGpBE0FB549hWvrSHhZ8f0ft/8X39lMC0WfZWJnXNS2WVM8r1FJsZc64yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SN7PR11MB7089.namprd11.prod.outlook.com
 (2603:10b6:806:298::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Thu, 24 Nov
 2022 03:41:00 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::3a39:ae82:41a0:6492]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::3a39:ae82:41a0:6492%11]) with mapi id 15.20.5857.019; Thu, 24 Nov
 2022 03:40:59 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAAgABQYICAAXpoEIAAGnIAgAK/reCAANL/AIAAhVlggAcl+kCAAIRtgIAAu8MwgADT2oCAAHNCsA==
Date:   Thu, 24 Nov 2022 03:40:59 +0000
Message-ID: <BN6PR1101MB2161E9BB4D4F05DF9F244CF7A80F9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y302kxLEhcp20d65@google.com>
 <BN6PR1101MB216162F44664713802201FAFA80C9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y36Fy/OYO5u0AzEG@google.com>
In-Reply-To: <Y36Fy/OYO5u0AzEG@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SN7PR11MB7089:EE_
x-ms-office365-filtering-correlation-id: f10c9995-402b-4629-e86a-08dacdcdb3ff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZO9kwSbzOxzd/weYyBc7o4W43epRreLgCo/eS16KZG/aa88usY4NshNtRZEUzrm6Sm2LrLwSFO6l+vrAdxMhIy49gAbiYZBQbk0o3GUJcdM9uSOZSQOiZd8MfVoQqqSGDgR5UdfPPSvIHAAFYIVImVPCo+22a6I3Y0ijrFmrS65/2ihBAzLzOKS2rleJXzIfhz247+vFDHzkegfL9G47drNiy6PAPV1s7zPe9BhrHUrpeIROEQbplpGz9Y2xocqBKlnGwWzVsz9aroc/N52eCvRyukUxJAbxIkxGWByj9nnu0EiNxGU0wUtvJLvlRKhMNg1xesTC47DYoB40UsHqBsDf4ETHo+3euXyB0K1TBDz4+ZhlHPavAFSBAYK5f+C/8+5/0PGSKGG3oMwzFgm7PWulVocr9sIJq//JUNzhQOLBdeCpOeGBA0MnjkHw3imqZ2NNm440vH1AOghAmoeDjERgto+x0bz8sDzgPpZizPeR1kUrVVGZSQZ/2XnSvHVQHoKIZNIcUnr8ZUurDeCQL7ufZIC1OyPEGXPO+DCXGbSkJ/UGsoMVs+93zsyA6SNKnhkScZWNnb65LXebW1tkbSIFr+Rp4IGVdvdyorMxCgyvGdeeAL+wN/i9zMxy6PFeKHx2LCw/ac43xxI0+E8WzqiHRTmuRlLFPST0fu85Va36cNHYAC6WtsNHjAwhouoMR1R9rmM4qiWagfNPo3zw3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(33656002)(86362001)(122000001)(82960400001)(38070700005)(38100700002)(5660300002)(7416002)(2906002)(55016003)(66556008)(8936002)(41300700001)(4326008)(66476007)(66446008)(316002)(52536014)(64756008)(8676002)(66946007)(26005)(9686003)(6506007)(7696005)(186003)(6916009)(76116006)(54906003)(478600001)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y3fOjt19GAjDU9dMZp5q+Joljt4qgNCaWGx8BNuyDqkBcrvKbJDodJIxsZfH?=
 =?us-ascii?Q?k1pQhI9j3zboM4YoX11HMldQV3lbhb+J4OOAkh3wJeYWv0uqOTXdihWWzs+h?=
 =?us-ascii?Q?UpSbjI3AMW/F2gkHxXvfLw89jMKus0LMMSMokN56/qfBvhSGL3+LWKXWg272?=
 =?us-ascii?Q?5QHMFBeDz+Tv42v7hM66rqIPxZkeg9oS3oVALMBr5xJOVLGS3RY44IiRL2Ah?=
 =?us-ascii?Q?eVHBqQG9X1dWDnSNT7xQ9dOCDMxO/j3FLBe8EDx9IOcnfG+wPRl6ubLxKyPG?=
 =?us-ascii?Q?bu31GBcVASnQp8zGlKQRlzEnNIsS3Odh7s7Xl8WF6KCwEhBAlpZF52qzqdKX?=
 =?us-ascii?Q?uivUL/eh3skGOKHMPOXQFmdgOTNeOjsDknj9horVVxQJYjW5s+CDweP7qjCr?=
 =?us-ascii?Q?OQ0lt9dSO6QteUoxhzART3+2r11AYg2ZWjNNat4GZ6NX9mWFn4x8mSuut/yW?=
 =?us-ascii?Q?UktM7bsXAE5oCM4KSElpB8quD+SL0oXz0MAf5K9E4WCcUC8TRC6TeVa3jtr1?=
 =?us-ascii?Q?lDi0WMhR6Bu03Oap7pIn7jYPUWxDwxbDTIn+d8ZBKREjhnOEwv6cncbENfRK?=
 =?us-ascii?Q?2VkcRAgbdyxAnXaJEpIMx1C5u0+veofl/jWKJCMBepVgPKnUuVqBvlKD0wR8?=
 =?us-ascii?Q?P7ZfTUw7X4qsMAN9pOsRgBZZqLMRKInp98wp6XQWF091QAOrL509cMbmjhD3?=
 =?us-ascii?Q?14VqTKClCpAltKH481QW4unO5CyxqFRzWKjzGMXjm0WLWXTpz8nMVto5n055?=
 =?us-ascii?Q?0fPKzPpNNnkZyW3Tn8Z/oLGob1mH9Z0K2IsrC1b7YAz9qL/xkXhnIntBcdPg?=
 =?us-ascii?Q?lOVspEOGgL579wYcziUwz12s2HzQt3JFZHEMNElwL7M9W40vNV8gti2Ou4cR?=
 =?us-ascii?Q?IOnEGuMm8nAYJSUENL0nlJwAiKMrqh6k4qq5aiucfXmCdaAUquBsi22Xp7bs?=
 =?us-ascii?Q?JbO7Cc3fNN9WaNxlmeouDpxFHmwEHRpnYDIDUSnUx9KcAptGZTghZbL9qj16?=
 =?us-ascii?Q?0qXwmIn931BZjyCR8XfqW3Bua+lewgh/BhThDlNJLrHqsrsbEKg2ypR40V0Y?=
 =?us-ascii?Q?Jjt54k+qekmsU1+8GTPqR3OiXNPX2u0e3AXBWOw0FPrCDNFfbf1+im2+J/gH?=
 =?us-ascii?Q?YTQD9l56I8D15eaH/lBPgVFonqtUSXoLxMFYnlggdzxmovo72jzNpCC9WSlD?=
 =?us-ascii?Q?RfTljxBV9AbBQaMwuj/9CR0ULauMFTyAM6wJuAxPGbug4/onNSoG8m8r6gEF?=
 =?us-ascii?Q?/khkY0s9ZjM294ojqhbElJ/Xb6cJRMd5/XA2XKiaf98jpcvPRDEYY0Op7bS9?=
 =?us-ascii?Q?q8wYppH/1THFqPby/gdZmrEQUi6P6MJiYNefpjnzyg7xnd7mw+A7r994JRLn?=
 =?us-ascii?Q?uFi6a3jT2D8S9MT9VKM1I2IW+4ulQbH/jA8UACIKmtH2sQl3CWx9Xd708fMK?=
 =?us-ascii?Q?sGPDvydfZoVnRwWlwBzHo5VK6Jud4EQp07bUP90mZR4dqmjVhbtiJXUN8f76?=
 =?us-ascii?Q?8uIjvn6T0NBsrKZk0cyeRM/5kA4VBLN2w3XSMwgsXFwHDvGzwl8eYUW/LSYi?=
 =?us-ascii?Q?TBwbVZSxylyJUq7auxg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f10c9995-402b-4629-e86a-08dacdcdb3ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 03:40:59.7604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iOEP9ljdJ8LDAqVXnEVqA5jGOvpoWYYk5u31pSRAkEqgl4LaZlL2FgSyiCkrHt+U4kSgEjWwHLHPqv/Bkz5emQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7089
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > thouh we'd like want a fair bit of refactoring so that all of
> > > vmx_vcpu_run() and
> > > svm_vcpu_run() don't need to be noinstr.
>=20
> For the record, svm_vcpu_run() is fine, at least as far as NMIs are conce=
rned.
>=20
> > This sounds reasonable to me, however from
> > Documentation/core-api/entry.rst, we do need it.
>=20
> Why do you say that?
>

Copy/Paste from Documentation/core-api/entry.rst:

KVM
---

Entering or exiting guest mode is very similar to syscalls. From the host
kernel point of view the CPU goes off into user space when entering the
guest and returns to the kernel on exit.

kvm_guest_enter_irqoff() is a KVM-specific variant of exit_to_user_mode()
and kvm_guest_exit_irqoff() is the KVM variant of enter_from_user_mode().
The state operations have the same ordering.

Task work handling is done separately for guest at the boundary of the
vcpu_run() loop via xfer_to_guest_mode_handle_work() which is a subset of
the work handled on return to user space.

Do not nest KVM entry/exit transitions because doing so is nonsensical.

>=20
> I believe this is what we should end up with.  Compile tested only, and n=
eeds to
> split up into 4+ patches.  I'll test and massage this into a proper serie=
s next
> week (US holiday the rest of this week).

Great, thanks for doing it quickly.
Xin

>=20
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 16 +++++------
>  arch/x86/kvm/vmx/vmenter.S    |  4 +--
>  arch/x86/kvm/vmx/vmx.c        | 51 ++++++++++++++++++-----------------
>  arch/x86/kvm/vmx/vmx.h        |  2 +-
>  arch/x86/kvm/x86.h            |  6 ++---
>  5 files changed, 41 insertions(+), 38 deletions(-)
>=20
> diff --git a/arch/x86/kvm/kvm_cache_regs.h
> b/arch/x86/kvm/kvm_cache_regs.h index c09174f73a34..af9bd0374915
> 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -50,26 +50,26 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
>   * 1	  0	  register in vcpu->arch
>   * 1	  1	  register in vcpu->arch, needs to be stored back
>   */
> -static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
> -					     enum kvm_reg reg)
> +static __always_inline bool kvm_register_is_available(struct kvm_vcpu *v=
cpu,
> +						      enum kvm_reg reg)
>  {
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);  }
>=20
> -static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> -					 enum kvm_reg reg)
> +static __always_inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> +						  enum kvm_reg reg)
>  {
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);  }
>=20
> -static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
> -					       enum kvm_reg reg)
> +static __always_inline void kvm_register_mark_available(struct kvm_vcpu
> *vcpu,
> +							enum kvm_reg reg)
>  {
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);  }
>=20
> -static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
> -					   enum kvm_reg reg)
> +static __always_inline void kvm_register_mark_dirty(struct kvm_vcpu *vcp=
u,
> +						    enum kvm_reg reg)
>  {
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty); diff --git
> a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S index
> 0b5db4de4d09..b104dfd282ed 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -318,7 +318,7 @@ SYM_FUNC_START(vmread_error_trampoline)
>  	RET
>  SYM_FUNC_END(vmread_error_trampoline)
>=20
> -SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> +SYM_FUNC_START(vmx_do_interrupt_irqoff)
>  	/*
>  	 * Unconditionally create a stack frame, getting the correct RSP on the
>  	 * stack (for x86-64) would take two instructions anyways, and RBP can
> @@ -349,4 +349,4 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
>  	mov %_ASM_BP, %_ASM_SP
>  	pop %_ASM_BP
>  	RET
> -SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
> +SYM_FUNC_END(vmx_do_interrupt_irqoff)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> cea8c07f5229..b721fde4f5af 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5064,8 +5064,13 @@ static int handle_exception_nmi(struct kvm_vcpu
> *vcpu)
>  	vect_info =3D vmx->idt_vectoring_info;
>  	intr_info =3D vmx_get_intr_info(vcpu);
>=20
> +	/*
> +	 * Machine checks are handled by handle_exception_irqoff(), or by
> +	 * vmx_vcpu_run() if a #MC occurs on VM-Entry.  NMIs are handled by
> +	 * vmx_vcpu_enter_exit().
> +	 */
>  	if (is_machine_check(intr_info) || is_nmi(intr_info))
> -		return 1; /* handled by handle_exception_nmi_irqoff() */
> +		return 1;
>=20
>  	/*
>  	 * Queue the exception here instead of in handle_nm_fault_irqoff().
> @@ -6755,18 +6760,6 @@ static void vmx_apicv_post_state_restore(struct
> kvm_vcpu *vcpu)
>  	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));  }
>=20
> -void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
> -
> -static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
> -					unsigned long entry)
> -{
> -	bool is_nmi =3D entry =3D=3D (unsigned long)asm_exc_nmi_noist;
> -
> -	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI :
> KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_nmi_irqoff(entry);
> -	kvm_after_interrupt(vcpu);
> -}
> -
>  static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)  {
>  	/*
> @@ -6787,9 +6780,8 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu
> *vcpu)
>  		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);  }
>=20
> -static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
> +static void handle_exception_irqoff(struct vcpu_vmx *vmx)
>  {
> -	const unsigned long nmi_entry =3D (unsigned long)asm_exc_nmi_noist;
>  	u32 intr_info =3D vmx_get_intr_info(&vmx->vcpu);
>=20
>  	/* if exit due to PF check for async PF */ @@ -6801,11 +6793,10 @@
> static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  	/* Handle machine checks before interrupts are enabled */
>  	else if (is_machine_check(intr_info))
>  		kvm_machine_check();
> -	/* We need to handle NMIs before interrupts are enabled */
> -	else if (is_nmi(intr_info))
> -		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
>  }
>=20
> +void vmx_do_interrupt_irqoff(unsigned long entry);
> +
>  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)  {
>  	u32 intr_info =3D vmx_get_intr_info(vcpu); @@ -6816,7 +6807,10 @@
> static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>  		return;
>=20
> -	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
> +	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> +	vmx_do_interrupt_irqoff(gate_offset(desc));
> +	kvm_after_interrupt(vcpu);
> +
>  	vcpu->arch.at_instruction_boundary =3D true;  }
>=20
> @@ -6830,7 +6824,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu
> *vcpu)
>  	if (vmx->exit_reason.basic =3D=3D EXIT_REASON_EXTERNAL_INTERRUPT)
>  		handle_external_interrupt_irqoff(vcpu);
>  	else if (vmx->exit_reason.basic =3D=3D EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_nmi_irqoff(vmx);
> +		handle_exception_irqoff(vmx);
>  }
>=20
>  /*
> @@ -7091,6 +7085,18 @@ static noinstr void vmx_vcpu_enter_exit(struct
> kvm_vcpu *vcpu,
>=20
>  	vmx_enable_fb_clear(vmx);
>=20
> +	if (unlikely(vmx->fail))
> +		vmx->exit_reason.full =3D 0xdead;
> +	else
> +		vmx->exit_reason.full =3D vmcs_read32(VM_EXIT_REASON);
> +
> +	if ((u16)vmx->exit_reason.basic =3D=3D EXIT_REASON_EXCEPTION_NMI &&
> +	    is_nmi(vmx_get_intr_info(vcpu))) {
> +		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> +		asm("int $2");
> +		kvm_after_interrupt(vcpu);
> +	}
> +
>  	guest_state_exit_irqoff();
>  }
>=20
> @@ -7232,12 +7238,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu
> *vcpu)
>=20
>  	vmx->idt_vectoring_info =3D 0;
>=20
> -	if (unlikely(vmx->fail)) {
> -		vmx->exit_reason.full =3D 0xdead;
> +	if (unlikely(vmx->fail))
>  		return EXIT_FASTPATH_NONE;
> -	}
>=20
> -	vmx->exit_reason.full =3D vmcs_read32(VM_EXIT_REASON);
>  	if (unlikely((u16)vmx->exit_reason.basic =3D=3D
> EXIT_REASON_MCE_DURING_VMENTRY))
>  		kvm_machine_check();
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h index
> a3da84f4ea45..eb52cfde5ec2 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -680,7 +680,7 @@ static inline unsigned long vmx_get_exit_qual(struct
> kvm_vcpu *vcpu)
>  	return vmx->exit_qualification;
>  }
>=20
> -static inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
> +static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>=20
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h index
> 9de72586f406..44d1827f0a30 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -382,13 +382,13 @@ enum kvm_intr_type {
>  	KVM_HANDLING_NMI,
>  };
>=20
> -static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
> -					enum kvm_intr_type intr)
> +static __always_inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
> +						 enum kvm_intr_type intr)
>  {
>  	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, (u8)intr);  }
>=20
> -static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
> +static __always_inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	WRITE_ONCE(vcpu->arch.handling_intr_from_guest, 0);  }
>=20
> base-commit: 0fa32dad1e78629cb42999dacd82489503fdf4c2
> --

