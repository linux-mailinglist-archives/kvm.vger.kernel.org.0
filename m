Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ED4758959
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 01:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjGRXum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 19:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjGRXty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 19:49:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A958F2126
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 16:48:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b9de3e7fb1so32327215ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 16:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724133; x=1692316133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SDxWIrfosG9XJ1i6+ao4lNZmMm/71hk0CPfpAh3rles=;
        b=oKgQFwiCrPvHzuuXJTxGw9fTJQCZKL9TyIsnHUo20k7J6vJr/dP2UuT8GyfaXNhKWl
         lfnwI4SNZlla+krW1fx/4HTGrmx9tbRfRVWIu3HGnyMHAJnHjaH8b3Nn7OD9lub8Upfz
         ScGl6hIrQNtyqOKMdvwG71E9U1LJYrTTZQq71Kwv4L3GIqczSYB1Q2ibrVYwZRMv7ks2
         QNhyu3W0Ns8Grpmlyc83iZpzHpUsL+aloKwTrirYI0WDq4iN8t2n8ha5cP4AK06m8uQ9
         dXuqm5q+qG2yKgB+nUEYuog82s4uX9rRPSCnrZx4hsx8m3v5+ZWIujkgaic/poWXwLCP
         o9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724133; x=1692316133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDxWIrfosG9XJ1i6+ao4lNZmMm/71hk0CPfpAh3rles=;
        b=VCn+wdaLrDWvRTaA7eJitSQUy8eFG7omh9Uq/o6oz9hU8EQZfLkcGWmlj8Fl6qeC7V
         m4eyIV/O5n+eVJG1ejcrkiDQUPNLNn4c/MaaA/ujSfx3dldI5wDTHNAZxCqqCnO4KB9D
         aMYCe2bP8kSJNzH3qXyOrGaNk4c9SvwUn6IWLKDoBrhcLUvw1GBmsCOctk/AnlvX97eX
         LoHDDdy80Ezm/eX9qs0eyeLeIsY5c4vVgPwnD4ucyi5UUumVMKu/h4G8TKckg3P3njO7
         hL2D0UI36oAoHsjOqXssZjtvSMQk4hPCeJwODJHBqvfZ7vQoDzCPN19jARvCM7106oxO
         7YsA==
X-Gm-Message-State: ABy/qLZM0mHyFETyltWNOhBtkMVJQkh5hb8Wlqlg/XWohui+ipBxoZLz
        kZcRgXRl4fQvv3W1HzuT5QdunuVcvQ4=
X-Google-Smtp-Source: APBJJlFRkrJKR6wk6kjyyawD9jUVadK517ZfNP5yf1yjj9/O0JQ+6He3HEMs3LUDgHlJok/ugi+AWDRSDQU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c412:b0:1ba:1704:89d1 with SMTP id
 k18-20020a170902c41200b001ba170489d1mr21516plk.10.1689724133087; Tue, 18 Jul
 2023 16:48:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 18 Jul 2023 16:44:54 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-12-seanjc@google.com>
Subject: [RFC PATCH v11 11/29] security: Export security_inode_init_security_anon()
 for use by KVM
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
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 security/security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/security.c b/security/security.c
index b720424ca37d..7fc78f0f3622 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1654,6 +1654,7 @@ int security_inode_init_security_anon(struct inode *inode,
 	return call_int_hook(inode_init_security_anon, 0, inode, name,
 			     context_inode);
 }
+EXPORT_SYMBOL_GPL(security_inode_init_security_anon);
 
 #ifdef CONFIG_SECURITY_PATH
 /**
-- 
2.41.0.255.g8b1d071c50-goog

