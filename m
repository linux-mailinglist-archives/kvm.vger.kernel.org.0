Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA306D70D3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 01:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbjDDXlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 19:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbjDDXlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 19:41:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555403C1D
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 16:41:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w14-20020a170902e88e00b001a238a5946cso17579957plg.11
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 16:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680651678;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AN7vvyrfQRxNCTFTsRCgL7QJiJbUSugi+Bj0dVXxuoE=;
        b=NuOIBKAneqyeF96rhZQCRv9HmwlwyDvWsBZZMROAHIcdyaVexMyLuDAwQvqvtv3iqg
         E4iV4sIh7CGR0K+U+aS5BuGpzigNm3iwYegfZTp5a5NRKUJbJS/ZTazDTfyQqwIhmGB7
         Vkg92ULhMiuXlRNRDMUcQu165kOHMI6JJ4rcAp+pUeFppfHI/1Ov8oEWpiruNzx2Na95
         MtFSwx3m7Y+Y7T280B9nVoIHxdpHMePy52o1C6BYG12h5nedKXQFU7yvH0JWT6vPO5eU
         crEjNx46icdQ6N31hJlzSyisQRk15LecSSAFDVQHbRbgWDFzxUqoLvtnoOjBbo5KU4cD
         VZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651678;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AN7vvyrfQRxNCTFTsRCgL7QJiJbUSugi+Bj0dVXxuoE=;
        b=EblIf6UaTCm9wBVjaZK21JHgSElWmBlZWGD5gDlQJ+gv3NN34GHL5bYlKu6EkLCSht
         zOKRhmmkQfVvrLdmpaBVfgM/+uXRScEdEEeTawTGXAsMv3b3XGMqvAic4XPrza1TVILb
         LAdRhVsCGamCmk7LdPgSSETL+VkjUZGQMogmxRwM6/r2mlCRQ4xrVOsGN50ZujYE9dyq
         XenAOKiJaiB1LuBJA37H58vxvLu7oLRN7Ttm5OeLWEBPGlmEBLLaszEjvqvMkurDkj8v
         y2tczd8q6bzLybBQtJATgve+XOBjGlsypBvHhWStOyNrFhBLzWRw5tPXj016dwck4mAD
         ZRMw==
X-Gm-Message-State: AAQBX9dyD7Y3/cH7tbQ7vBy0sEErI9vpckjGJYIeA7zuEvfySETDvW1o
        4/cyrIQJQyemoZVH0wbnIgesVkJ4Sr4=
X-Google-Smtp-Source: AKy350Zv5EnFg+Gpz4pEd30M1lNOUlgAGKicBfTR2DfrD/mLu8E+8kbuszROkSaNHUNiJjQs5VNbWuBfDrs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4f85:b0:240:44c4:a09d with SMTP id
 q5-20020a17090a4f8500b0024044c4a09dmr1597871pjh.0.1680651677777; Tue, 04 Apr
 2023 16:41:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 16:41:12 -0700
In-Reply-To: <20230404234112.367850-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404234112.367850-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404234112.367850-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: Exclude forced emulation #PF access
 test from base "vmx" test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Filter out vmx_pf_exception_forced_emulation_test from the base "vmx"
as intended, someone just forgot how the nVMX megatest works.  The
runtime of the forced emulation test can easily exceed 200 seconds
and thus has its own dedicated test.

Fixes: 723a5703 ("nVMX: Add forced emulation variant of #PF access test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 9c70562d..b7676c28 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -336,7 +336,7 @@ arch =3D i386
=20
 [vmx]
 file =3D vmx.flat
-extra_params =3D -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_ac=
cess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vm=
x_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_=
test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vm=
x_pf_invvpid_test -vmx_pf_vpid_test"
+extra_params =3D -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_ac=
cess* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vm=
x_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_=
test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_exception_forced=
_emulation_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test=
"
 arch =3D x86_64
 groups =3D vmx
=20
--=20
2.40.0.348.gf938b09366-goog

