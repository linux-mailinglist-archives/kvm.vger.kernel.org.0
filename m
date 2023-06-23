Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6667273C4BA
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 01:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjFWXVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 19:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjFWXVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 19:21:16 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2422683
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 16:21:15 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-543c2537dacso668931a12.2
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 16:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687562475; x=1690154475;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DUD5RYjo6Sx5P4lA1ER1U7bhRxM4zQjuiTOF9zGf3yE=;
        b=QLiQ9fXbHiCe0qK57ildEM5KTuDKuavekOKc0qZAvV5TZ+Xns1ge/pltTmsuxkoXus
         CfICaQaAOpMVJXBHhmmavEyPvBGphytxBo51EJ6dvPNto6RPjIBDKGvw0h50knpKPW+8
         QCPdd2487OYHgEeNateURDQvlJYucy7BAt4B9d8YkURczWIKEWGBrEQUH4jEseSH23nG
         qF6foUDt1tj/HRJcX3k97/Gq5jtf5goraEMESh8ywCs56xoT8tAt9BksEjfXi9yAAnYF
         T5dTzZg8hLF3MikoSItK9TxF0D2Izn12udp7tSquqEBY5CrIZ9orHwfTBmvugM0f8AT8
         mjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687562475; x=1690154475;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DUD5RYjo6Sx5P4lA1ER1U7bhRxM4zQjuiTOF9zGf3yE=;
        b=ko89WphhYjxo7vqZaTWEWMBKpYxefxUu/aFXNMTrxNnxvVw1pIuUXMfKH/uogD9DKZ
         ut/zHX1ZOECSg6fgRg23lX+6AOcLWJVqFls5huV3uCnBejsz5m4LG/mwr9PH79mKEaTu
         tYHtdAN3purH4Tjc4ugE6nKRFAzJMz+DCEeFOdL8f5qAApVsk2WSjm9B66+dx8vteT+R
         BsDM7vzDwyvdzEa9Kxz5uj08zxeYSpl4Zrw1syRBeOOrDMe1i30Aj1jsPK4y9JsItcQR
         p1Hbht7eH1jijeYFidtQK2oXHgXrt0E7a7rsz9TY5lcRbiXaJfmA1Zvu63hTotkiV/Je
         mc4w==
X-Gm-Message-State: AC+VfDzcJaBHq6Y4+j4r09KnnI25nGpk9aLNQiriSHN5kG7hm2yOnTKw
        KGMSf90JHLY7LdicIX4L8daMUg1TEMM=
X-Google-Smtp-Source: ACHHUZ76wCt3kLoU/pcmU3i2bY4ZdXcM+NFgKY37hXTE8tgyzFAFCtUFnXoZgC71g3fXutZxhceNY6B3278=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4382:0:b0:551:eb6:1ea6 with SMTP id
 q124-20020a634382000000b005510eb61ea6mr2614071pga.10.1687562475077; Fri, 23
 Jun 2023 16:21:15 -0700 (PDT)
Date:   Fri, 23 Jun 2023 16:21:13 -0700
In-Reply-To: <f2708ad5-494c-c91e-cf5a-09f6e2d81e15@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com> <ZG77wu4PyBn1z587@chao-email>
 <23169e5f-9793-9486-fd5f-287e3317b837@intel.com> <ZHXnP5bEvxPrDg3m@chao-email>
 <6e1e9de9-8def-46c3-a238-c1b4ef52e331@intel.com> <ZIuitcH7P1JpkzFH@google.com>
 <f2708ad5-494c-c91e-cf5a-09f6e2d81e15@intel.com>
Message-ID: <ZJYo6aDtt0DQ5Tjv@google.com>
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Weijiang Yang wrote:
>=20
> On 6/16/2023 7:45 AM, Sean Christopherson wrote:
> > On Wed, May 31, 2023, Weijiang Yang wrote:
> > > On 5/30/2023 8:08 PM, Chao Gao wrote:
> > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu=
 *vcpu, struct msr_data *msr_info)
> > > > > > > 		 */
> > > > > > > 		if (data & ~kvm_caps.supported_xss)
> > > > > > Shouldn't we check against the supported value of _this_ guest?=
 similar to
> > > > > > guest_supported_xcr0.
> > > > > I don't think it requires an extra variable to serve per guest pu=
rpose.
> > > > >=20
> > > > > For guest XSS settings, now we don't add extra constraints like X=
CR0, thus
> > > > QEMU can impose constraints by configuring guest CPUID.0xd.1 to ind=
icate
> > > > certain supervisor state components cannot be managed by XSAVES, ev=
en
> > > > though KVM supports them. IOW, guests may differ in the supported v=
alues
> > > > for the IA32_XSS MSR.
> > > OK, will change this part to align with xcr0 settings. Thanks!
> > Please write KVM-Unit-Tests to verify KVM correctly handles the various=
 MSRs related
> > to CET, e.g. a test_cet_msrs() subtest in msr.c would do nicely.  Hmm, =
though testing
> > the combinations of CPUID bits will require multiple x86/unittests.cfg =
entries.
> > Might be time to split up msr.c into a library and then multiple tests.
>=20
> Since there's already a CET specific unit test app, do you mind adding al=
l
> CET related stuffs to the app to make it inclusive? e.g.,=EF=BF=BDvalidat=
e constraints
> between CET CPUIDs vs. CET/XSS MSRs?

Hmm, that will get a bit kludgy since the MSR testcases will want to toggle=
 IBT
and SHSTK on and off.

Actually, I take back my suggestion to add a KUT test.  Except for a few sp=
ecial
cases, e.g. 32-bit support, selftests is a better framework for testing MSR=
s than
KUT, as it's relatively easy to create a custom vCPU model in selftests, wh=
ereas
in KUT it requires handcoding an entry in unittests.cfg, and having corresp=
onding
code in the test itself.

The biggest gap in selftests was the lack of decent reporting in guest code=
, but
Aaron is working on closing that gap[*].

I'm thinking something like this as a framework. =20

	struct msr_data {
		const uint32_t idx;
		const char *name;
		const struct kvm_x86_cpu_feature feature1;
		const struct kvm_x86_cpu_feature feature2;
		const uint32_t nr_values;
		const uint64_t *values;
	};

	#define TEST_MSR2(msr, f1, f2) { .idx =3D msr, .name =3D #msr, .feature1 =
=3D f1, .feature2 =3D f2, .nr_values =3D ARRAY_SIZE(msr_VALUES), .values =
=3D msr_VALUES }
	#define TEST_MSR(msr, f) TEST_MSR2(msr, f, <a dummy value?>)
	#define TEST_MSR0(msr) TEST_MSR(msr, <a dummy value?>)

With CET usage looking like

	static const uint64_t MSR_IA32_S_CET_VALUES[] =3D {
		<super interesting values>
	};

	TEST_MSR2(MSR_IA32_S_CET, X86_FEATURE_IBT, X86_FEATURE_SHSTK);

Then the test could iterate over each entry and test the various combinatio=
ns of
features being enabled (if supported by KVM).  And it could also test ioctl=
s(),
which are all but impossible to test in KUT, e.g. verify that supported MSR=
s are
reported in KVM_GET_MSR_INDEX_LIST, verify that userspace can read/write MS=
Rs
regardless of guest CPUID, etc.  Ooh, and we can even test MSR filtering.

I don't know that we'd want to cram all of those things in a single test, b=
ut we
can worry about that later as it shouldn't be difficult to put the framewor=
k and
MSR definitions in common code.

[*] https://lore.kernel.org/all/20230607224520.4164598-1-aaronlewis@google.=
com
