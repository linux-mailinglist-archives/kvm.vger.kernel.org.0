Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7A7DA07E
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbjJ0Sbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346378AbjJ0Sbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:31:35 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFC32115
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afe220cadeso6523377b3.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698431001; x=1699035801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xz8kt0PqFUxEdWsVGTpKhvh/0bAOqOlDGpUeOhSMn4Y=;
        b=OsCynHN7e3GIf2nZlVgAAzL9xfgOe12HvGyzelq0BaqcPUkHjvUGv7V/t3p6u/QB5d
         XzbYUd3YxZB2GRFVjllNEhiSazwuH/T3RNc6rH72ctO3WrZBN+veVNBuhn6IKD73e2lE
         tvOgu+tn7gQjA86uFzMPe6yMKXMdLIW0AUJchrmYdRKq9wuJUcOiZRVkaJikGs4e037u
         eGQyoS7vy7aj5G3ebzZqFOuVT1Fz0WFlWN1E7+z9ix0Ikl3DYEhE3/8c/6mXqXlqmroo
         4STkfpkHlkT/WIoWMIgbr8caZb/C5xe2b2Ti6oPQHUchCsnWKeY1kEFlI9aHTOebf/zw
         EJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698431001; x=1699035801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xz8kt0PqFUxEdWsVGTpKhvh/0bAOqOlDGpUeOhSMn4Y=;
        b=nec2Y49/fqKm48CZmT1JDlkLe16O3I8dh6VuXSF1QNkwav3+HRgEDFdl9bH9wSgPUe
         RagqLNHvXnnZK8tHGOlCjpMYMD7URLMzSXjzmcWdY6PPIH7IMFh35CKjo+IWlLxTzfHU
         KV560wtScaM0PhCrYRaTyrujp4EHDEeUu58Y8loEWeJOUftpymbTvfGg37IP3JaridzB
         CXBUHMkKHP2H8zDu7HuM2qt/TQKfO2V9XPrtkRIxXqAJ8myXvm2/pVbq23EuqJS1Y+sZ
         UT8R0Xcc5WAQyr+5Vh+tgEznUbKmBB+J51yKOjhG1EiwB4D7qhkN5xCpU7cha8zUWCjJ
         kByQ==
X-Gm-Message-State: AOJu0YzjRAWyD68NizPvMktJl8lOcPg+zs+8c+wBa/iBwD/9zr0o4qwK
        UvCVUwwmFrU50Jg/9UXj+Jy1y2bwvlw=
X-Google-Smtp-Source: AGHT+IElp9q5EmMXm2ScJmYLrQOoQHqoyljn7k2kapIAuiZd/nyrTEs2J8MXUI1aCi13+9HebXd80A1xuUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e653:0:b0:5a7:be10:461d with SMTP id
 p80-20020a0de653000000b005a7be10461dmr68754ywe.2.1698431001067; Fri, 27 Oct
 2023 11:23:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:10 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-29-seanjc@google.com>
Subject: [PATCH v13 28/35] KVM: selftests: Add helpers to do
 KVM_HC_MAP_GPA_RANGE hypercalls (x86)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vishal Annapurve <vannapurve@google.com>

Add helpers for x86 guests to invoke the KVM_HC_MAP_GPA_RANGE hypercall,
which KVM will forward to userspace and thus can be used by tests to
coordinate private<=>shared conversions between host userspace code and
guest code.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[sean: drop shared/private helpers (let tests specify flags)]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 25bc61dac5fb..a84863503fcb 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -15,6 +15,7 @@
 #include <asm/msr-index.h>
 #include <asm/prctl.h>
 
+#include <linux/kvm_para.h>
 #include <linux/stringify.h>
 
 #include "../kvm_util.h"
@@ -1194,6 +1195,20 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 
+static inline uint64_t __kvm_hypercall_map_gpa_range(uint64_t gpa,
+						     uint64_t size, uint64_t flags)
+{
+	return kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIFT, flags, 0);
+}
+
+static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
+					       uint64_t flags)
+{
+	uint64_t ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
+
+	GUEST_ASSERT(!ret);
+}
+
 void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
-- 
2.42.0.820.g83a721a137-goog

