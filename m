Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80977DA025
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346380AbjJ0SYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346561AbjJ0SXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:23:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5978A19AC
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7b53a48e5so20850557b3.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430981; x=1699035781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QVHGnajj4HOCkrhgrdEXP5z3IZ3KkliWY6Z9SNVyio0=;
        b=afzTdDPGnR5/HEu+93/RDsiIpfQHiVzu25BF9nT/3rXX06eZXTFvLAKsA99ZOq+cgk
         wbiy+Lwq62Sz7q4lDicIke/0kQRydNxe17fDkPYEuijhK6AGt4y9AkRdkHgZjTb6Hu80
         wc2Sbv6i54ULJbZE9QJG1orQZtFFM7sCcXzoJxw1rDKxX/DhiD9/Z5xeqcMWQxnhWUuB
         S1I9DXwKmlfURezY7jU3Y/bs1AEb8x7QTm4/NOIkYebqeUiFpAL4jcwAyoUs8j3Nuksw
         LBiLrPVEdwUwQSQdjjw2MTvfvhJ3haqOv4qNQxufbbZDx4gLoGohl/j5ty9egK3c48dH
         o+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430981; x=1699035781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVHGnajj4HOCkrhgrdEXP5z3IZ3KkliWY6Z9SNVyio0=;
        b=obrmFpsoT5Ay+KDE/TyvIQ/2RCC+TuPtnTIBF8YNLBPu03R7wgHYxvJFEaif2ysQLM
         aA92VS75sopNxmEzrJkufIwZ2DPpNvwN/MpaORYLX0JPsStzzPHb8S0SS3/EicCsWAbm
         E4xM/F42sbpzb9aS2IqZT4vZIy3B5sK6jPGniR91/HTSEBXIcK+uAjzL/JsRoruCo4vq
         S1mIfc8wETjO7rPfLnDPHCkESDsVSHZx82ph7IluIt2Cwfm0x0t4LIJ+h0ZtrNF0DK0v
         5QbXZTLETamjJ/GO5sGrZ5nxuP36a6Ij1r/uKke0KZJR+keE3eQpt3jhxytY6cvllAIB
         +BFw==
X-Gm-Message-State: AOJu0YwWCjV1XdqBPqr4viIX8zLQEZEL9+yT3oB1tEoPsTLj5RODUEtd
        3O9GW1FRu0KKyiKTuTbE474y8Q9V0pI=
X-Google-Smtp-Source: AGHT+IGhdcD7DYxvJo53MxSFMcue6wHqMJ/dJKXwjBlyW/fIhxTWfdSD8wIFRBeoqz4UflCFK1Su3DgQ67Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:da0:567d:f819 with SMTP id
 v3-20020a056902108300b00da0567df819mr78702ybu.10.1698430981246; Fri, 27 Oct
 2023 11:23:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:00 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-19-seanjc@google.com>
Subject: [PATCH v13 18/35] KVM: x86: "Reset" vcpu->run->exit_reason early in KVM_RUN
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize run->exit_reason to KVM_EXIT_UNKNOWN early in KVM_RUN to reduce
the probability of exiting to userspace with a stale run->exit_reason that
*appears* to be valid.

To support fd-based guest memory (guest memory without a corresponding
userspace virtual address), KVM will exit to userspace for various memory
related errors, which userspace *may* be able to resolve, instead of using
e.g. BUS_MCEERR_AR.  And in the more distant future, KVM will also likely
utilize the same functionality to let userspace "intercept" and handle
memory faults when the userspace mapping is missing, i.e. when fast gup()
fails.

Because many of KVM's internal APIs related to guest memory use '0' to
indicate "success, continue on" and not "exit to userspace", reporting
memory faults/errors to userspace will set run->exit_reason and
corresponding fields in the run structure fields in conjunction with a
a non-zero, negative return code, e.g. -EFAULT or -EHWPOISON.  And because
KVM already returns  -EFAULT in many paths, there's a relatively high
probability that KVM could return -EFAULT without setting run->exit_reason,
in which case reporting KVM_EXIT_UNKNOWN is much better than reporting
whatever exit reason happened to be in the run structure.

Note, KVM must wait until after run->immediate_exit is serviced to
sanitize run->exit_reason as KVM's ABI is that run->exit_reason is
preserved across KVM_RUN when run->immediate_exit is true.

Link: https://lore.kernel.org/all/20230908222905.1321305-1-amoorthy@google.com
Link: https://lore.kernel.org/all/ZFFbwOXZ5uI%2Fgdaf@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee3cd8c3c0ef..f41dbb1465a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10963,6 +10963,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
 
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
-- 
2.42.0.820.g83a721a137-goog

