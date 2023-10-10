Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F7F7BFF85
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjJJOq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjJJOqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:46:23 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6B9B6
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:46:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a22eb73cb3so101204197b3.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696949180; x=1697553980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fMAV4Pzyhnv9LKuSwz3p65tBRhFFBxEMfLBcYd0Sf1k=;
        b=nwanSktsrp/VbW655W3gmdjY4g+LOkt/MhdjOFLEzj5Fz/FTbY4Xttq6H2kbnxuZMB
         YkSpAhRwGIxGkqZ68HpON+h1MKOeNWLikB8W4JggzrPmWmChEWzXw4OzSWmPQ1EBfQUu
         qFFCp74TaNB4Cc0fzu/k1eupOM3XrvIJ2q/8HkVD2WxcYsIySz36p1Q4+K18r+6jLq49
         4BCr5B4+g7DQInfYy7uIVfSL2rcLRJd3WUkGEGlrfu6IiPRe6kLeenWsVBpDDvg/93ua
         i4lUYAqAX3Bkt4CFtpDBgGixSTPUgcwjCUFDx5J1f1Chflshpnqfcu7iJmL4/agU/ajx
         7hcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696949180; x=1697553980;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fMAV4Pzyhnv9LKuSwz3p65tBRhFFBxEMfLBcYd0Sf1k=;
        b=IsiJv3t9CpTuFx9I3YVqCimJJrLO5L3siHEx87kYnNZ+PP0ih8F1y841i6Sv5R3zF9
         FhFFUr90UHBxFW2JWUE9rvirUEbyIMbw5dLAs8xZfzwjH+0pych2n5y/49WdDOENSLKt
         bwDKlmMiNsIVqPdBVK+tFyA+X9rtrZfohGn8KT0KLO78//IFudJEDS730A++JY1PS/1j
         tBXBi1i67NzpQ4rV4TNWQwwmpplYDlW5gQ5Jb7gG1rw8XsBEPmZlupr4+vW9/gukcJ3J
         vm74sHAJ4141EBCGaTfJDyN/aQ3WeAT3Lr5bYpqbf4KWzR6KSv7a9+Ywvy8bJj4gaORA
         gzOg==
X-Gm-Message-State: AOJu0YznQt2Ukor6fryRw32HBm2upSgxn3xGdgZgJVDkH8/NL+Pj/PpF
        jlgUAKdlzYQHkd+gdHl007fs1vZSKzE=
X-Google-Smtp-Source: AGHT+IE/TXDzI2n2HhZxqazpt+zV8jBYLUVJHzMmOl2AXB81S6e3SfKpYLGnAoOwvxqxaSpO7rgkGtvImlw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c14a:0:b0:5a7:aab1:96a9 with SMTP id
 e10-20020a81c14a000000b005a7aab196a9mr78960ywl.6.1696949180578; Tue, 10 Oct
 2023 07:46:20 -0700 (PDT)
Date:   Tue, 10 Oct 2023 07:46:19 -0700
In-Reply-To: <e348e75dac85efce9186b6b10a6da1c6532a3378.camel@redhat.com>
Mime-Version: 1.0
References: <20231009212919.221810-1-seanjc@google.com> <e348e75dac85efce9186b6b10a6da1c6532a3378.camel@redhat.com>
Message-ID: <ZSVju-lerDbxwamL@google.com>
Subject: Re: [PATCH] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=BF=D0=BD, 2023-10-09 =D1=83 14:29 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > Note, per the APM, hardware sets the BLOCKING flag when software direct=
ly
> > directly injects an NMI:
> >=20
> >   If Event Injection is used to inject an NMI when NMI Virtualization i=
s
> >   enabled, VMRUN sets V_NMI_MASK in the guest state.
>=20
> I think that this comment is not needed in the commit message. It describ=
es
> a different unrelated concern and can be put somewhere in the code but
> not in the commit message.

I strongly disagree, this blurb in the APM directly affects the patch.  If =
hardware
didn't set V_NMI_MASK, then the patch would need to be at least this:

--
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b7472ad183b9..d34ee3b8293e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3569,8 +3569,12 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	if (svm->nmi_l1_to_l2)
 		return;
=20
-	svm->nmi_masked =3D true;
-	svm_set_iret_intercept(svm);
+	if (is_vnmi_enabled(svm)) {
+		svm->vmcb->control.int_ctl |=3D V_NMI_BLOCKING_MASK;
+	} else {
+		svm->nmi_masked =3D true;
+		svm_set_iret_intercept(svm);
+	}
 	++vcpu->stat.nmi_injections;
 }
=20

base-commit: 86701e115030e020a052216baa942e8547e0b487
--=20

and maybe even more to deal with canceled injection.
