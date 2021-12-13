Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5F747356F
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 20:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbhLMT7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 14:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242660AbhLMT7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 14:59:18 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458C2C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 11:59:18 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s22-20020a056a00179600b004b31f2cdb19so1976149pfg.7
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 11:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8J9lNG7qusp7IKUlm+Z/cw9Edy7QEJ39Y0anc/ZdikM=;
        b=HqbrqM0g/0DWDdAcp3Peib6GEcl+jOYlohZxBdL55y/0g/QE5tEIoDuEfDCYhv18pv
         +u4Gxnsn+xXn9Cax4bN+am/Vr9B1DQHNbEvdNlRp1fh1tU9qxR5Vd5oYHwnvM/hyWpEj
         iDP1CkXQQ9kMKlBIza+RvxYlItfqR6uXoNGYo1ZqfgRuI0igWHZYT+DpakxwiGv8Gbw6
         UGSL9V4JqkkBZ0O6hNYXkN32mmUxYejz+MlOWoh5J9DaXP9vjpn7bmYwQb9eoGCbSqSl
         nsOi+g+jVg6e8FDrmxLEx4ou6POPkxwY1hpeHHGm8aQ3kUXQkibKjrdwpyJw08WDVW2t
         6cBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8J9lNG7qusp7IKUlm+Z/cw9Edy7QEJ39Y0anc/ZdikM=;
        b=3WByWKBzkC7zDRWnKiLRaGH0RI2BoEf0+iF+k9zQOwjIiwFwCLPQPkhwEdomJ/WRqC
         /6xgF9u/o23Uq6V+tXA9iswVoFfkhHbWEBFcvdL6vAvc395s8rwIMbVyagCa63oEI030
         KNskvdij3d1QOs+B4n3G+LnwvAORqsO1OOb7rhO+6OjbykKaumSd2QjvPFxIOUQx6i70
         NR48fyxCJ5JL2px4OO3WQSPV29mZmYs848Vf61DVWfK2USKPfzF+vWT4EZMXRugXW+20
         bUSxFyzY3pNAZt/5Sfny1SjMuPzC/pxB/RLH8HPiA078qkBjyBs69DmauFAZnz4nsXJC
         rFCw==
X-Gm-Message-State: AOAM532YNQCxM22tk1oTmodLIhROS9lnHwyNTfHFpAc5yAjlkMPyF4wL
        PYWGQbzzA62SI8XQ9aLDW6Phx7wwN1MdXg==
X-Google-Smtp-Source: ABdhPJyTWNSj7J7HYTBJgxKMlx7Ns2FVUOvMzgwoBCqHCpAy97CHIIZB4HaeW6WXcO72c5Dain37Rwnc+eva+w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a65:684e:: with SMTP id
 q14mr551139pgt.378.1639425557761; Mon, 13 Dec 2021 11:59:17 -0800 (PST)
Date:   Mon, 13 Dec 2021 19:59:12 +0000
Message-Id: <20211213195912.447258-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH] x86: Increase timeout for vmx_vmcs_shadow_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When testing with debug kernels (e.g. CONFIG_DEBUG_VM)
vmx_vmcs_shadow_test exceeds the default 90s timeout. The test ends up
taking about 120s to complete (on a barmetal host), so increase the
timeout to 180s.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3000e53c790f..133a2a1501dd 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -346,6 +346,7 @@ file = vmx.flat
 extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
+timeout = 180
 
 [debug]
 file = debug.flat

base-commit: 0c111b370ad3c5a89e11caee79bc93a66fd004f2
-- 
2.34.1.173.g76aa8bc2d0-goog

