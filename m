Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12184070F3
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 20:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhIJSdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 14:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbhIJSdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 14:33:39 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E9BC06175F
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 11:32:27 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id p12-20020ad4496c000000b0037a535cb8b2so23652880qvy.15
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 11:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cnbcsUxj0+vz286J/QqU6TqKXNjgZZG8Rpm/4K5hx2w=;
        b=pIww2R46Arl4Ntwsc4XJCAiwVxNzRhuhtannaePCd7dYBJ5hjOWCVEHQ4bdvTnmhi1
         i9b2nClpEpBcnp4BW834p6pNhwkT9Lz2YvtDAsioeLYoMsW3AiUF7PAkiZJi5yo5BiMa
         726gv2m7wrOxIfRTMXbtgLxHvXPi/Mzq+qrfX/44MoH7sVMM2fFmAunU8noY83RXnVGd
         PQ+TMkVcgGGsUw1Lx8zOADlavLkshhTczGf1lhaG9YUVbxVGQUzTz9fWG3aREs5g1RZb
         1HNMvrFj008GVGtIRe+vxJIzgBmMM5ExMvlrTSWSi3wVR5Lu4FOBZL9aIcpKI3gcSjHC
         1ajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cnbcsUxj0+vz286J/QqU6TqKXNjgZZG8Rpm/4K5hx2w=;
        b=oEVUaW1aaKC9gdjKPE/c+MxMVzpoRhM8VtArHU+wZueK6Gt5gqJFlSLizQ/Ux0JZyo
         IE1SCPcp/0YxdwmfAhN4PkkwZdy30GFhyFA+VvQmtZ/bYuAhN79+9nLr/yqmYMaJQwv6
         4ali23qtfCNnx1UFxMImKVERKJPbn3pkdK8TvXSs86dOjHjAkYSiwt9kdfMWWm6OSxh6
         SPoGIUDtk2C9Ux18xPZOQcHYczsIO8tWzHgIjma+BrZoJN//62xrzFixicmqqJo4LCWZ
         edLg9pnERm6VjMiE0I84LtkcMM2ngtl3+eIsGpMMzj0OunpaEfEiBM4QUiC+skRkj9M1
         8sAA==
X-Gm-Message-State: AOAM532GIZW0pGXk1voswOrCUhAdlaJ3/eQnC6qNqwlzn/XwdjvVGNwY
        KtLZFL4t1tLLDqZigaiQlpeQuDnYimE=
X-Google-Smtp-Source: ABdhPJzXDjWhio+8oqJuBsmbBOKUJMrxubACsQ/soxYMQizwRXsd1DU4no0VULnpnjDACE5EIgVGkHsQAcM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:d1d5:efd6:dd3d:4420])
 (user=seanjc job=sendgmr) by 2002:a0c:be85:: with SMTP id n5mr9437942qvi.59.1631298746885;
 Fri, 10 Sep 2021 11:32:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Sep 2021 11:32:20 -0700
In-Reply-To: <20210910183220.2397812-1-seanjc@google.com>
Message-Id: <20210910183220.2397812-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210910183220.2397812-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 2/2] KVM: x86: Identify vCPU0 by its vcpu_idx instead of
 walking vCPUs array
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vcpu_idx to identify vCPU0 when updating HyperV's TSC page, which is
shared by all vCPUs and "owned" by vCPU0 (because vCPU0 is the only vCPU
that's guaranteed to exist).  Using kvm_get_vcpu() to find vCPU works,
but it's a rather odd and suboptimal method to check the index of a given
vCPU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..6ab851df08d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				       offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (v == kvm_get_vcpu(v->kvm, 0))
+	if (!v->vcpu_idx)
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
-- 
2.33.0.309.g3052b89438-goog

