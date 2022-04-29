Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73513515651
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381205AbiD2VEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381173AbiD2VD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:03:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C083BD3AE9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:38 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f8bbaa6b16so23969037b3.14
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HXnih4STfuZSP9gQw8KiDoHwzhD9DuieHszM+gFMr1Y=;
        b=XUor+V+kBp1C1oo8PgjLYIomhABX7qX1FK3OvrrssZKV2LGa1wVtR2fX7FmiO3Dj8q
         s/C6rxtHIM+f10wkgkdP1GT95Jx6oEXtwNbEPDq90hBtuX4SjnwDtDUBv5QH48ULnFZ/
         tAj74mheXTeuehfK7ONkYLCNjDfKmNqLgYorwHVPUbnlnkqf3jBceecFM+AIVDnuCFvQ
         bRIriuLOLIpVBILX99cAWhHrv4CAxzrIqm65Mc7d6UV19o9FOHFQCJauzyU8Z3H/tu14
         4zePI93u2GtS4RjN3HvQfKy2lRMr4+TiXkXtyTtCRZATNPODREUDJ7t9fZ4wuOidIQOx
         gLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HXnih4STfuZSP9gQw8KiDoHwzhD9DuieHszM+gFMr1Y=;
        b=0FhX0Rl2AVoau7C0B4Ud4tJK3gZ61tTBaT8Ku3bzISrxc/kKrWUHpgQ3q8u+PdKk4/
         U+hGe+VRIaQgBmzh0hBhCER/rOC8dCeUt0sZA4BCEK+0/UiQFkTMWTo5JDTPbryMKREz
         vkX4BuWq9bDtBuQjgpCQInryH41iuapv3Z/R48fmxp19EwcdsKEb55boWtGcFCViY5ee
         F8Z9P0js1zbmSXEQtcw3ZLt+Kn5FmQR07PkkBC9CtAdLY12LI8LvcFoTYJq51c7JXT7F
         iXUrYiIeLxNhwbtrzCIC77fDYRA0ElLtuKvU0eZaDLBzlaREXlU30cPbX7QodJxl3DCE
         1vjw==
X-Gm-Message-State: AOAM533S8ekmHysA7QG1LThFzTTWBFWzsHSxOXjxl6PytiIS+ABsHrn/
        Z3r2kRfWYC8JobqPA/EvLIoX2i+XBu4=
X-Google-Smtp-Source: ABdhPJyOiW1bBv1iaSrEwJmsjNe+xWJVUni+JWC9RdV/XBpoocyR86zZqSRIhmMyOrk1oDuZ1D/TpXRitQ0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:31c2:0:b0:641:660f:230f with SMTP id
 x185-20020a2531c2000000b00641660f230fmr1364455ybx.472.1651266037988; Fri, 29
 Apr 2022 14:00:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 21:00:22 +0000
In-Reply-To: <20220429210025.3293691-1-seanjc@google.com>
Message-Id: <20220429210025.3293691-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220429210025.3293691-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v3 5/8] KVM: Do not incorporate page offset into gfn=>pfn
 cache user address
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't adjust the userspace address in the gfn=>pfn cache by the page
offset from the gpa.  KVM should never use the user address directly, and
all KVM operations that translate a user address to something else
require the user address to be page aligned.  Ignoring the offset will
allow the cache to reuse a gfn=>hva translation in the unlikely event
that the page offset of the gpa changes, but the gfn does not.  And more
importantly, not having to (un)adjust the user address will simplify a
future bug fix.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 40cbe90d52e0..05cb0bcbf662 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -179,8 +179,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			ret = -EFAULT;
 			goto out;
 		}
-
-		gpc->uhva += page_offset;
 	}
 
 	/*
-- 
2.36.0.464.gb9c8b46e94-goog

