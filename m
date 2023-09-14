Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6479F74D
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbjINCBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbjINB77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 21:59:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897363C04
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 18:56:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c0cfc2b995so3900305ad.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 18:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656592; x=1695261392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Vjv0zC4RrtxbIkJLIAO5e3EhKuQZW28HjcF6ypERxIg=;
        b=4dEdCKgsqAUfA71gJDGn1QkhjWkryjd4tWQSydavJOoANvp/FtV+Br8R0i1zeosT3Y
         u8pvf7DfZ8MHlLpx2+B3bj7hUFd7pFeNJPnwR3f+bRUa38lwP1kOt1Pp5T/X4ZMWLUx7
         s1o9dH78hruSsEApGeTQuP+TKkGaZlSggRV7vwNwF739cPJ8WAgLjdLVVWZaeUJTWN9S
         OfbOmimZGumNiujKk3Ydfl2B1x9HG901OBVUL/c3lLv3JYZvI5b0ZvfbvuxJSCkGdvlG
         OydBaR5ujEvrTFiOuFZiWEuPFp9bWOar6/5nW/qVCcOifbAiW0IuWtjlcA3Cm3zHyg2w
         WXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656592; x=1695261392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vjv0zC4RrtxbIkJLIAO5e3EhKuQZW28HjcF6ypERxIg=;
        b=WPDrSPehuto1pgPbL8n6q1x8Xw8appK7EoXviu5LDMkL8TGHylOWcj04ozThI0S8X3
         9uj1NKrn5iH7OaMHPwXmwi1rvfQHQD3a0pznhAOBpDJZ5MWyZ4Utjnpmsey32Rt4v4c0
         WK4LJ7QA0Zfrz1jMvbz51A8k5+WObzPQ9vfRxkEBvlM6noQahPDYKnJxy+ZeyBNZY7Ax
         zUsNGp6k1LYpC6DU400e55TsjMACLY7DLsNQ2QMIPeGbmSfxkWN+GMtCYFiyEiRmB0uT
         3AiffGDdfQ8a5TcyCu5UNjQSiFZPDPuGNuHcrDJ/MabVDW4SajAEErMob86re7+sMYic
         FReA==
X-Gm-Message-State: AOJu0YwC7xeohv5IjXVNrBlocGWl039d3E5d5owIVw7/Yx9uiX5vX0Za
        39P0+5qJZKsYLhKFd3yogCKlhVSxCGI=
X-Google-Smtp-Source: AGHT+IH29SvaM4IJ2/NXJnaPAeFMS+fjtgLQL7Rq48UqpO83PYLOZng2qV6FMiS0c4sL4jzOiYmTHdNxdV0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e551:b0:1c3:a4f2:7c85 with SMTP id
 n17-20020a170902e55100b001c3a4f27c85mr212223plf.6.1694656591946; Wed, 13 Sep
 2023 18:56:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Sep 2023 18:55:26 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-29-seanjc@google.com>
Subject: [RFC PATCH v12 28/33] KVM: selftests: Add GUEST_SYNC[1-6] macros for
 synchronizing more data
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
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add GUEST_SYNC[1-6]() so that tests can pass the maximum amount of
information supported via ucall(), without needing to resort to shared
memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 112bc1da732a..7cf40aba7add 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -54,6 +54,17 @@ int ucall_nr_pages_required(uint64_t page_size);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_SYNC1(arg0)	ucall(UCALL_SYNC, 1, arg0)
+#define GUEST_SYNC2(arg0, arg1)	ucall(UCALL_SYNC, 2, arg0, arg1)
+#define GUEST_SYNC3(arg0, arg1, arg2) \
+				ucall(UCALL_SYNC, 3, arg0, arg1, arg2)
+#define GUEST_SYNC4(arg0, arg1, arg2, arg3) \
+				ucall(UCALL_SYNC, 4, arg0, arg1, arg2, arg3)
+#define GUEST_SYNC5(arg0, arg1, arg2, arg3, arg4) \
+				ucall(UCALL_SYNC, 5, arg0, arg1, arg2, arg3, arg4)
+#define GUEST_SYNC6(arg0, arg1, arg2, arg3, arg4, arg5) \
+				ucall(UCALL_SYNC, 6, arg0, arg1, arg2, arg3, arg4, arg5)
+
 #define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
-- 
2.42.0.283.g2d96d420d3-goog

