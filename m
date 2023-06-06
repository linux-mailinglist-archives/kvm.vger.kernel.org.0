Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CA1724BA4
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbjFFSpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238887AbjFFSpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:45:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9886B10CB
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 11:45:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b04dbcf0dbso45652175ad.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 11:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686077115; x=1688669115;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cq1bDTjZKQu+8FokSAcd9i/aEeyRO+1V7yxU6QcDPDg=;
        b=SyQHi7u1uXQBjZVKJZN8e+jiLgy7KNnOamKu5YqvFnqqdbxz/rNypLYRdIIfE4dElN
         Zqyihiljdoq2kKIYbI4lbxrOqROU4pQHCeoxinn2lDSeR66K2IZuPg/euOFjngLZQCPl
         88MTYPnpV/vEv9sWX0mq6WSnoOQKFu0jxDqRliufQvJRZd9T43QR/paYL+fUvAEhyLgQ
         +yvG4ANvxz80w0p48/95PiutNn2xR9aFlyFYzaQ1RZTnqD7PkcnMBGCmxf2gW4bYVDE3
         L6VoP6/SC7bbV6V5R8/lX/ChtAZ/SyjZBRrFMVljEPFIyOKw+59ZmzeeI8UaX0UNhuts
         47Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077115; x=1688669115;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cq1bDTjZKQu+8FokSAcd9i/aEeyRO+1V7yxU6QcDPDg=;
        b=V5PQtgHZODYGrXAtaF5Y7PlFeJdiF7i7Rf4f54TmcZwDX5MwbuyLWAl2l/CFGlUUql
         XMWWu3t0lqFREPJytQaovW15VeSbnE0vv3KM6Hr57+00vv1kAhNESqgMzqywjeyYSh/U
         vud8avHDRTMw+YDc0VQx/FyiaI8EICxn/ruLSGELbLcQI5IOK1S54zpyoDDSZ7O+7hld
         r71+AJpvWDUaHLjMjSbB6COyrIZl0Y8NKHaUaWipytTU5FI37BXIgIlYphpxvBRMkoDG
         dWpbPZvYw9NF6WssUITNaVaIGL76TkpVSK2HnlqprYDml9wQzeRgSSkmshK3tdbmWBb9
         teEw==
X-Gm-Message-State: AC+VfDwWmRThRDkvZhBD4amtieWUYVVpoN7Ey8Z1V/LboYcJfOu1kolc
        Vnjwn5Q0bunVQ0OSwnOTni3165PPPPI=
X-Google-Smtp-Source: ACHHUZ7qJdL+b/Aomd4mSjTHuAlTbzUL4WoI3pCH7py3TtKtgN+tt+YQ5NLnyn6J6BUMbtskU5LT8+TWn70=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:eb4d:b0:1a6:8a07:960a with SMTP id
 i13-20020a170902eb4d00b001a68a07960amr2129137pli.0.1686077115103; Tue, 06 Jun
 2023 11:45:15 -0700 (PDT)
Date:   Tue, 6 Jun 2023 11:45:13 -0700
In-Reply-To: <20230522161249.800829-2-aleksandr.mikhalitsyn@canonical.com>
Mime-Version: 1.0
References: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com> <20230522161249.800829-2-aleksandr.mikhalitsyn@canonical.com>
Message-ID: <ZH9+ufGL9SGfmmnc@google.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init fails
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     pbonzini@redhat.com,
        "=?iso-8859-1?Q?St=E9phane?= Graber" <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Alexander Mikhalitsyn wrote:
> If misc_cg_set_capacity() fails for some reason then we have
> a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
> not a case right now, because misc_cg_set_capacity() just can't
> fail and check inside it is always successful.
>=20
> But let's fix that for code consistency.
>=20
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: St=EF=BF=BDphane Graber <stgraber@ubuntu.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com=
>
> ---
>  arch/x86/kvm/svm/sev.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 69ae5e1b3120..cc832a8d1bca 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2216,8 +2216,13 @@ void __init sev_hardware_setup(void)
>  	}
> =20
>  	sev_asid_count =3D max_sev_asid - min_sev_asid + 1;
> -	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
> +	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count)) {
> +		bitmap_free(sev_reclaim_asid_bitmap);
> +		sev_reclaim_asid_bitmap =3D NULL;
> +		bitmap_free(sev_asid_bitmap);
> +		sev_asid_bitmap =3D NULL;
>  		goto out;
> +	}

Blech, didn't look close enough at v1.  I think I'd rather yell and continu=
e on.
If misc_cg_set_capacity() were to fail, debugging would be unnecessarily pa=
inful,
and at least as things stand today, there's nothing userspace can do to rem=
edy
the problem except by manually disabling SEV and/or SEV-ES.

---
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 Jun 2023 11:34:28 -0700
Subject: [PATCH] KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fa=
ils

WARN and continue if misc_cg_set_capacity() fails, as the only scenario
in which it can fail is if the specified resource is invalid, which should
never happen when CONFIG_KVM_AMD_SEV=3Dy.  Deliberately not bailing "fixes"
a theoretical bug where KVM would leak the ASID bitmaps on failure, which
again can't happen.

If the impossible should happen, the end result is effectively the same
with respect to SEV and SEV-ES (they are unusable), while continuing on
has the advantage of letting KVM load, i.e. userspace can still run
non-SEV guests.

Reported-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d65578d8784d..07756b7348ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2216,9 +2216,7 @@ void __init sev_hardware_setup(void)
 	}
=20
 	sev_asid_count =3D max_sev_asid - min_sev_asid + 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
-		goto out;
-
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
 	sev_supported =3D true;
=20
 	/* SEV-ES support requested? */
@@ -2243,9 +2241,7 @@ void __init sev_hardware_setup(void)
 		goto out;
=20
 	sev_es_asid_count =3D min_sev_asid - 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
-		goto out;
-
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))=
;
 	sev_es_supported =3D true;
=20
 out:

base-commit: 6d1bc9754b04075d938b47cf7f7800814b8911a7
--=20

