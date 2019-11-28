Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECA110C624
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfK1Jq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:46:28 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:52556 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1Jq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 04:46:27 -0500
Received: by mail-pf1-f201.google.com with SMTP id f20so15853427pfn.19
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 01:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pMpbhX7gfy9Upeye3hmpdgvCu57jS/7Jbp2nWuR8Ix8=;
        b=jV7G0pZkgX0Gq1u7LGJWyTrdDYkCRHdGD1P7Yx3+CrvVP+25wPkq8WGG6yKoJzWP0P
         HpV4Rfa60SZnRjWSqNtLPNGkt+INQdkuy7iWFoCAAlX275UkmfT4aDHsgvK2iG+7iNfK
         PY60hr23kuyHLF4qxY0dyLAyKSqNG/rnr0/lGckREldFuoITCpm6YH100TOaDNKoPxgq
         xxYtxR6EO1EtxTHpGrU4upSfNfV05akLcgz/+WzOezZw39SHSHi5GLlb89ik/L+PHz7u
         vh1A5cviZVPk8bwfP8RzB6x8P1JZivupj3WIZcWYbVB2PQ1nq+s9FqrfRlmaNj3e2QCN
         TiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pMpbhX7gfy9Upeye3hmpdgvCu57jS/7Jbp2nWuR8Ix8=;
        b=dTk4a4wL/9lmC8JKdYjK9SDGkYwsrViil38rmiguJC/fK7xEKaDawjj7nBzMrIloDd
         eEuMYUi8dpsdBF2blwylHuM0A2L7yqwFjigs1SgN8EYZ3/qdzIWM4g06BV7Eei+aqEZL
         8nzWY++SC3NdxVRwAD0wyLCe1mt9N38fpbwzwSyCAuuVEPdurp42TD1ae3bw/dTpdIPo
         bWj44Bia4sXNBkTpeHCF19P3w6yCKnXCY7G1+LvFjTLhmlSM5G+YSuTdR7AUhACoYtE8
         SpIScd0NQltX8+gnoKn7ql3kqUEUfP1ej5jBF+nT+v4ldenWQ2z9tjd/ehfk23UcCkAf
         sQHw==
X-Gm-Message-State: APjAAAVxxRRrF9JmEYprP4pgFZsKPyJnIOoj9ikhj7s0lTunWbk2aofp
        p4ycmxuhDw4a+mmtKezFxz7sJShh0magzwkJHc6zV5nuILeF2jPzgekCgGf8/c/cgCncnugPlIx
        zGH7DHK8q/ZDOrhzNnDwgAjEyLeCz6iZpB0mdyqpTSYqrfBRNAaVysqd++w==
X-Google-Smtp-Source: APXvYqzctch60s0NfGoMaAPOgKUzLb/zCG+jArUq8L0tPz23ID9L/C6m5aI1U592QiXKB745Htz/GgWx8B8=
X-Received: by 2002:a63:4387:: with SMTP id q129mr10279326pga.428.1574934387052;
 Thu, 28 Nov 2019 01:46:27 -0800 (PST)
Date:   Thu, 28 Nov 2019 01:46:09 -0800
Message-Id: <20191128094609.22161-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH] KVM: nVMX: Use SET_MSR_OR_WARN() to simplify failure logging
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 458151f65b4d ("KVM: nVMX: Use kvm_set_msr to load
IA32_PERF_GLOBAL_CTRL on VM-Exit") introduced the SET_MSR_OR_WARN()
macro to WARN when kvm_set_msr() fails. Replace other occurences of this
pattern with the macro to remove the need of printing on failure.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..f7dbaac7cb90 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -928,12 +928,8 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		if (kvm_set_msr(vcpu, e.index, e.value)) {
-			pr_debug_ratelimited(
-				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
-				__func__, i, e.index, e.value);
+		if (SET_MSR_OR_WARN(vcpu, e.index, e.value))
 			goto fail;
-		}
 	}
 	return 0;
 fail:
@@ -4175,12 +4171,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			if (kvm_set_msr(vcpu, h.index, h.value)) {
-				pr_debug_ratelimited(
-					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
-					__func__, j, h.index, h.value);
+			if (SET_MSR_OR_WARN(vcpu, h.index, h.value))
 				goto vmabort;
-			}
 		}
 	}
 
-- 
2.24.0.432.g9d3f5f5b63-goog

