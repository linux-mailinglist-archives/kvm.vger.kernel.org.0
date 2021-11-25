Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1303845D2BD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245252AbhKYCDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348639AbhKYCBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:09 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5793FC0619DB
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:33 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id iq9-20020a17090afb4900b001a54412feb0so2325190pjb.1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rE/NaZRrlbtu4MW3X7vDSEmrgKkxvryqyHCMV3coc/E=;
        b=Cluc57s7+WyrdKpeZCKeXW7Yh+/og7vqwWAf1ldCDcy6GAi1hhEzrgtotKjl+ZVIy3
         Addmwc/DnFo6oVj2ELAhWyFdENLYcLXWt7plPTgw0HlLcGLhSBlzfoI5JROH6z6N0bD3
         gfk1q0E5hfpEkGFb1kT36V99dPpUOCcPHMcodC0h5xtR1uD/htiGWvMphGTC12hDI+VY
         bxwMbgDFFzhF4Lqd14QSeJYQlEq8oRDx/SrQsr8SLtanI8+y1i5Rrqf3wRyr+AR5wuby
         9dCXGxfIim75IjlGvi3hgaVWnkLJbKyA6MM0YFeroHOscNuwVPuf4Ky2rqFC4vc/dzpP
         0tfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rE/NaZRrlbtu4MW3X7vDSEmrgKkxvryqyHCMV3coc/E=;
        b=pokE7z4li96z4yHv0aXqu+nEYfvS1nf3nJu2xHeV+Ci1m55pRlMIposwHEvvqyw8bi
         myf+ufRpCYGtONwIbZniNhkAz7DLYcCYH93kToDOi3AKayBaLqSdYduvS+vDdrkkCMAO
         ZXODud5PF6J8S5Ru9Dgtp/0p6zmGWOJzpI8JhM6eSk25jNN4J12UOwbZD5WWvwmc6IHG
         bTl9wJQoWtOpzvPV93xYWYN4vhsK6kkzOHBhVFlsdOyXj9by0jj4eOw4b3O6siWdwi0B
         APNaek1uhzZbqnHwkhNYJbbWoekeJdQSx29HKRXwjY0uPeEE6RalO8npsRiwx0OwvUkG
         GAGg==
X-Gm-Message-State: AOAM533pf7mSaztfuPxYJENu4SQe6TBh39xYu12GC0nl2vb2QQJT3rTY
        i5fbqDQPJAGASU/+9S5xdXG/t2Dm0Nc=
X-Google-Smtp-Source: ABdhPJyyMvcCv1uw8GVakhr3QkhUHgJVdRwGWcglijruUJxhOHr0M1wwWwxwwjQVW21tlSmi64/nU7Frgqw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7883:b0:144:ccb8:674b with SMTP id
 q3-20020a170902788300b00144ccb8674bmr25004157pll.63.1637803772878; Wed, 24
 Nov 2021 17:29:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:38 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 20/39] x86/access: Remove timeout overrides now
 that performance doesn't suck
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The access test now takes less than 5 seconds when TDP is enabled, and
is well under the default 90 second timeout when TDP is disabled.  Ditto
for VMX's #PF interception variant, which is no longer being penalized by
unnecessary CR exits and other general stupidity.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 4402287..f3f9f17 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -117,13 +117,11 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 file = access_test.flat
 arch = x86_64
 extra_params = -cpu max
-timeout = 180
 
 [access-reduced-maxphyaddr]
 file = access_test.flat
 arch = x86_64
 extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off
-timeout = 180
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
 [smap]
@@ -358,7 +356,6 @@ file = vmx.flat
 extra_params = -cpu max,+vmx -append vmx_pf_exception_test
 arch = x86_64
 groups = vmx nested_exception
-timeout = 300
 
 [vmx_pf_exception_test_reduced_maxphyaddr]
 file = vmx.flat
@@ -366,7 +363,6 @@ extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append vmx_p
 arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
-timeout = 300
 
 [debug]
 file = debug.flat
-- 
2.34.0.rc2.393.gf8c9666880-goog

