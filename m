Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AAF5FBBAC
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 22:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJKUAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 16:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJKT76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E0A12AF5
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665518390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Yevp9gp3Kfu1CI9DtUubsDde9/ctCFvT8SlIVvPvCA=;
        b=McMNtfh6O32LihUYx6rINatLvg0EyCC+fw+JRYmrk/EelGhcRDc7g1Ek5GoOvgnTY3uKHy
        GaHNk0km0/8TNEiygg4h6NX4ozKkft0uNAYdjvoA2DTsaBMkkE3vmEni3EwT7Hqk0Sev4Y
        XoDAGiZJBcUdK5hJoCUDvJcnVLU9ois=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-25-IG_uQF4wOTO1FmPYp08ibQ-1; Tue, 11 Oct 2022 15:59:49 -0400
X-MC-Unique: IG_uQF4wOTO1FmPYp08ibQ-1
Received: by mail-qt1-f199.google.com with SMTP id g21-20020ac87d15000000b0035bb6f08778so9783902qtb.2
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Yevp9gp3Kfu1CI9DtUubsDde9/ctCFvT8SlIVvPvCA=;
        b=SADe5E+0PeUfL7ZeQw36pSxsjg7dnvpO4kBKMqSxoTwuleIkPX7Y/ZGx2k6IrUxJZ4
         WHgJBT6MvJkiBK8IQdM7WM1vCmoOg1YjWmcHmjIwWTziiqJStwECEXJaLKcxs+lRe/Eg
         dUqZVkX+N9owSqqjMWegvyVNYjUJKjCkniwrmkm2FtY+hHLUsbpxEFzfw7cO+EeVzmBF
         s1ahsTM22dRgXlLir+bz+ifszT6BhbSc548KIv5fSr5Kmoj/f6TJuYmpQ/a40SufxTdQ
         NOSKoLgp3nJAkq9FSLGjQ/n560RCyTojEfUhyg34fpWluD51GmUqkVq//B+6/xA8AwRY
         qAVA==
X-Gm-Message-State: ACrzQf1RVHUSujECz/rG/ae5GIEORK0iWUlF/YMZxRF8D9iF3qx6So3j
        rlL69YTwjlP/1pmIHa7sZcvYlxDOqdaMzzPoGS7/F2fUMiDKdYRzh3oyGPnHfvAVrubQeWInErV
        5gEk+pWZD1PpD
X-Received: by 2002:a37:64cd:0:b0:6ec:545f:9095 with SMTP id y196-20020a3764cd000000b006ec545f9095mr10080145qkb.133.1665518389231;
        Tue, 11 Oct 2022 12:59:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM49LBnh/R6pXZ8ZDj9dNiopP/LCrCnUzgsu2WgP4jJEuB7vGoS/dPhB9OGhtxh5BKvDICMIgQ==
X-Received: by 2002:a37:64cd:0:b0:6ec:545f:9095 with SMTP id y196-20020a3764cd000000b006ec545f9095mr10080132qkb.133.1665518389031;
        Tue, 11 Oct 2022 12:59:49 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id v4-20020a05622a014400b00343057845f7sm4477368qtw.20.2022.10.11.12.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:59:48 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, David Matlack <dmatlack@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v4 4/4] kvm: x86: Allow to respond to generic signals during slow PF
Date:   Tue, 11 Oct 2022 15:59:47 -0400
Message-Id: <20221011195947.557281-1-peterx@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221011195809.557016-1-peterx@redhat.com>
References: <20221011195809.557016-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable x86 slow page faults to be able to respond to non-fatal signals,
returning -EINTR properly when it happens.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cc26f425f41c..83b9c034313d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3148,8 +3148,13 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 {
+	if (is_sigpending_pfn(pfn)) {
+		kvm_handle_signal_exit(vcpu);
+		return -EINTR;
+	}
+
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
 	 * into the spte otherwise read access on readonly gfn also can
@@ -3171,7 +3176,7 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 {
 	/* The pfn is invalid, report the error! */
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
+		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
 
 	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
@@ -4186,7 +4191,12 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
2.37.3

