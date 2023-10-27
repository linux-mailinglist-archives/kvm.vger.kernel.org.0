Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A27DA019
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjJ0SYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346500AbjJ0SXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:23:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF221985
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:22:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc1ddb34ccso9089705ad.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430975; x=1699035775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pX02ozc7lSRzYa356XIJ+CMNCgv5fZ3NEfG1CClMU1M=;
        b=SdAdDdzkQW9NAOix+vNXPmrygbTqqSa0a0PcQgt4V7j8F4D7DwOVkUnGTZTW8HrWvW
         /Xg3y/aah/5tG3ui0ecO3iGyey+jskVT/pBjXo5MAJWBHvuBgYlIIwHRtROaC3hfxpO5
         I2yHw9aXAcbaIRtuxjUfkGuwaLS75nQNqpUYMD4IdiCNGV+lG2vUe3Rn6sPXbKuQivCh
         jTpWSoqngr2R6KjjFYKOuxH6sAQxe1e08qvOOvNmKn6UJEzbD6BlsnTiBWCZkorZARPI
         juoJPOXQyyiWP796K2Y0nm63JMA7H9wP25LS6LeHpYdXniy/qrMr2K6og17hFGhyK9QQ
         oiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430975; x=1699035775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pX02ozc7lSRzYa356XIJ+CMNCgv5fZ3NEfG1CClMU1M=;
        b=MfzzIMQSP1WCw9iDWN+RYGOw+heQsnVmtV9iESS7TzWohB/czkhCi7Yy94I5CoARGL
         Snp3w8s8dSMxp5LEgIeiUZJD0VRACATubU9RzKpzdnPlirzbq8syuB3vmdd/lO68qo8X
         6y1IWL3rn9DRDxwo9T61Qg/ic1DTZAca3a0rmbbLmMDbARh9rWlwGBPARybzGWSqlwNV
         QO8KZNVGLQ/OZLreK1FMgo1aYZS4vaCjioYPXsyXoqIlGTJhDCajLENoCNJyZom8CcaF
         umBrGdRskmWCpItVzazEQr7iHOFMZ197420xPm1+sHS6WDqaTG/NKNTtTG89YbX0lZ6a
         k8lw==
X-Gm-Message-State: AOJu0Yz392V7+R4fhE9qWQuDNC/wUIhF6Crh3EJfZBzkxrqetocP/l49
        ffnOlewq4XALR0CP3ftbUb4jstIPrpE=
X-Google-Smtp-Source: AGHT+IEZ2DkPV4b8zDYsItSE8S6PNMt34EGJVQ4YpOaZs5hBhRUHv0wBQpomiC7JG41zMwbv7hAHGw5rsZI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7d6:b0:1cc:23d2:bb94 with SMTP id
 h22-20020a170902f7d600b001cc23d2bb94mr38516plw.1.1698430975510; Fri, 27 Oct
 2023 11:22:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:21:57 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-16-seanjc@google.com>
Subject: [PATCH v13 15/35] fs: Export anon_inode_getfile_secure() for use by KVM
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

Export anon_inode_getfile_secure() so that it can be used by KVM to create
and manage file-based guest memory without need a fullblow filesystem.
The "standard" anon_inode_getfd() doesn't work for KVM's use case as KVM
needs a unique inode for each file, e.g. to be able to independently
manage the size and lifecycle of a given file.

Note, KVM doesn't need a "secure" version, just unique inodes, i.e. ignore
the name.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 fs/anon_inodes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24192a7667ed..4190336180ee 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -176,6 +176,7 @@ struct file *anon_inode_getfile_secure(const char *name,
 	return __anon_inode_getfile(name, fops, priv, flags,
 				    context_inode, true);
 }
+EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);
 
 static int __anon_inode_getfd(const char *name,
 			      const struct file_operations *fops,
-- 
2.42.0.820.g83a721a137-goog

