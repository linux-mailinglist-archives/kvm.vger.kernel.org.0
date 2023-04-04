Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204F66D70D4
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 01:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbjDDXlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 19:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbjDDXlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 19:41:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0898E40E0
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 16:41:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a250fd5000000b00b6d6655dc35so33422867ybp.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 16:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680651676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0+DedVkeC74OPADGmZggMzFk6G4CfCE2ZZ9ieRjgTb0=;
        b=T813VjyLGXYeEGFDSrhHSW30AnV/qb/+4fXbLiH8Jy2+Y4m59SYUhLFlwhedvLb6qj
         2Xm7ZYf9bNyEX2S6oF0LyfvkPhTgXpQeFXDdRdLYIUvUj3OYu2xTfysSfyIF7C+lxCRO
         ah9w4ZwGstWspZOIlemxHYj/OlETdTufhSCxK4rS/VXtAdcXURKafpU++eU7wWOC+Qm8
         //OU4SErpvx0BAov6Ck0O6cmBs42EnyCmzAaN60iipOkx0w58uvJRp6EowypYo3Ad5zs
         c7aVXEKON1VBSrYVCnxvluue2d5lryPQjOJgKKX5VWMM3O6edUVvH6XaKF+UqD5tatid
         oIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0+DedVkeC74OPADGmZggMzFk6G4CfCE2ZZ9ieRjgTb0=;
        b=UNDvLYAmJSy9W5YUTNyitPGDM1bGpDa5BXDR8/hO4DpEJhIR6yyFAqWxTgn83rx9Mi
         p6T/VqG6Y/XrxDFaZFUGW0wB3oRaxziMG8WJCZ1Dvt7+IbWhJ2uN8plCI1p1d4EJ6LQI
         PNf6swzyUgMLZqjYh1c6/AUiXlhPFCarEdfk9v+oGXcuAFrJFXaHJqLy5JiXWq9FI3di
         dPZJYs8JqnNKA2SfMTj8Ck4MxFG+IsML9+FmQgbIvSfbJvYM8QblPNoXPTlaZPoh3U7E
         VSsW9g6X0hr//EgJiK7EVbN4Ioh+1HaUiBNwdnWyF3DwTJm441SvFwelYAlnfS+AybUf
         5e7g==
X-Gm-Message-State: AAQBX9euGrdz/E1ThmB3YbRNdaCba5NaO19vfIlGkjdyQoKeEMkatxh6
        ttQLMwYWh5tfuk5bqDnoX2d6SnEIGqs=
X-Google-Smtp-Source: AKy350ZHa6dL5OPYug8mzHxM5EfvqF+6ZGs9Fk3mQxR4I2MZKqZwM0NqEN28XCbaYqKRHQPkraxVfzRRJOk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:76c9:0:b0:a0d:8150:becf with SMTP id
 r192-20020a2576c9000000b00a0d8150becfmr2986020ybc.13.1680651676288; Tue, 04
 Apr 2023 16:41:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 16:41:11 -0700
In-Reply-To: <20230404234112.367850-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404234112.367850-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404234112.367850-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: Set forced emulation access timeouts
 to 240
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the timeout for the forced emulation variants of the access test to
240 seconds, which is the (very) rough expected upper limit established by
the VPID-focused variants when KVM is forced to emulate something on every
individual testcase.

Fixes: 76ffc801 ("x86/access: Add forced emulation support")
Fixes: 723a5703 ("nVMX: Add forced emulation variant of #PF access test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 0971bb3f..9c70562d 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -148,6 +148,7 @@ file = access_test.flat
 arch = x86_64
 extra_params = -cpu max -append force_emulation
 groups = nodefault
+timeout = 240
 
 [access-reduced-maxphyaddr]
 file = access_test.flat
@@ -414,6 +415,7 @@ file = vmx.flat
 extra_params = -cpu max,+vmx -append "vmx_pf_exception_forced_emulation_test"
 arch = x86_64
 groups = vmx nested_exception nodefault
+timeout = 240
 
 [vmx_pf_vpid_test]
 file = vmx.flat
-- 
2.40.0.348.gf938b09366-goog

