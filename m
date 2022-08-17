Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24843596656
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 02:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238072AbiHQAge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 20:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbiHQAg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 20:36:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50F8C461
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660696584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTwL0O3UlpIIc32A0xilckqyKglNDPBffWl5+tmKDhQ=;
        b=UV8yl/1LiedkEbklExGDJczz2HIYBQ6udJnHKNH2VADCEH35QIP4tYwqWbWgV2Os8eJP64
        vvQD/n+hi30pwMGavhixvdegh2/okfuOtJ4YXRyTDG54VzpBBQ2icvCouJRuSnl51wMpIh
        w3Yv9MDc4GvlpgXHyEwz40sqEh9bUyA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-HWVexxwcPj2k5dl3TGBUBA-1; Tue, 16 Aug 2022 20:36:20 -0400
X-MC-Unique: HWVexxwcPj2k5dl3TGBUBA-1
Received: by mail-qt1-f199.google.com with SMTP id ff27-20020a05622a4d9b00b0034306b77c08so9444336qtb.6
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BTwL0O3UlpIIc32A0xilckqyKglNDPBffWl5+tmKDhQ=;
        b=gF9VtdYVkweoGx1EjDJhaxxQJ+o8UY21ctE9R1NOHIrR9ER+BUlZ9l4HaFOVpQgEh7
         vKK95qZjls8uU7t1sJfWS+LHTy+eWwwOgNLDevqG8LJF5ibyYviJYi+T6+4+m1f+eZeh
         7RroYHCnZ3adyqbJEim0AwcGk4OhGYWTX9iyva48sZLZaH5Htx78Bnw2HmfofiLKpUFW
         VXp2p4/QOSXnIGL8Gu7TOyiZB4vIzLt8lJIuQWGRFXbJ6dWN9lc6pvbVTQ/OmvxYNLfb
         0Lyc6kdXT+2ErvPeDyenYuL4ZCv3s6A8EYih277qeZFeEtag6up2pxm9slMnUGjcJ3Cp
         S8+w==
X-Gm-Message-State: ACgBeo23ufGqE0/m6MGlpa8OmqVpfPi7KogHRHcVBSDqzn6q3CCVQ6ee
        se6DyWrahJhWkejn8G64REqyP5QkiFf+dmcEbF5IdlcCeNkzroh4x+wq/uCGSLOzATMA+g5YKta
        95/EIoMwN4/KP
X-Received: by 2002:ad4:4ead:0:b0:474:7bba:9865 with SMTP id ed13-20020ad44ead000000b004747bba9865mr20428363qvb.58.1660696580458;
        Tue, 16 Aug 2022 17:36:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4UUHOe8O6QFGIYvp/9K2vK0n6Fp6ajMCcyZcBb9hv+otrDbdfVJjGZcpSZ0cwahduBZbENsw==
X-Received: by 2002:ad4:4ead:0:b0:474:7bba:9865 with SMTP id ed13-20020ad44ead000000b004747bba9865mr20428347qvb.58.1660696580285;
        Tue, 16 Aug 2022 17:36:20 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id c13-20020ac87dcd000000b0034358bfc3c8sm12007175qte.67.2022.08.16.17.36.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Aug 2022 17:36:19 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v3 3/3] kvm/x86: Allow to respond to generic signals during slow page faults
Date:   Tue, 16 Aug 2022 20:36:14 -0400
Message-Id: <20220817003614.58900-4-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220817003614.58900-1-peterx@redhat.com>
References: <20220817003614.58900-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable x86 slow page faults to be able to respond to non-fatal signals.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 23dc46da2f18..4a7d387a762a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4177,7 +4177,12 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, NULL,
+	/*
+	 * Allow gup to bail on pending non-fatal signals when it's also allowed
+	 * to wait for IO.  Note, gup always bails if it is unable to quickly
+	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
+	 */
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	return RET_PF_CONTINUE;
-- 
2.32.0

