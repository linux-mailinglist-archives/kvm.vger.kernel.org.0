Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B93D40B9A5
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhINVLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 17:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbhINVLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 17:11:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE0FC061574
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 14:09:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v16-20020a256110000000b005b23a793d77so583758ybb.15
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 14:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BGyteJrFicXpaz74Co+W4m7Ybp8XG6rNqdJoL5bS1T4=;
        b=U+U/3xkfAShm5h0uHb24Ei1JfmtrGD7T27mgc4dZgabR0Vz+CNil/Yg7P5ERLL3lJS
         bIiy2UgvXXlur83sCXzMuggHZCa9yN9Tn93ZzQYwhNeNtl9327v01zLA2KuxOc15Dnt/
         GOqIX/AoCA4OuYZ5STtiVENxgK5CFCsqiFI+oQdG54SSiKLiGqdYOewhmj5QtvzpR6jj
         vGvHh+kD84MMapKXVlidFX9dlHM6HPNShacEhQXv9r0r2oFn2MNwxpodU6/fKLz3Cosr
         Gn4tIrHBiUvpAuuwk4n5UZOd0Uaq8SaBotLqfiQNoeqEQuXki8N4WNS3h+ConEjurMP2
         6SWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BGyteJrFicXpaz74Co+W4m7Ybp8XG6rNqdJoL5bS1T4=;
        b=tgU1biYT2RD5hmlITDPaEQp48rg7nayriSNEMIa60xZIkpQAH/JOUlEX9cr9VmD7TQ
         0DjOSP9VZPA5Fyx2O0ALcINd9v54+MPJULSIibzA5csFpU7YD8S3ZtwL6F+3GSP9mdeW
         Fxw/CBFpl5j17IjptmZ6YeoMwmmspHHqy6Y6jfvpp/GmTkKbfNjmdNsAb9TR1mJTnUsu
         m9QISLFAA4GCo2wirvDl4un6IeuxHpqV2wOlv7K8ADqDSD83F3ShwWpVVW/TmHXkQ07x
         Hze0YKZSBQWp5H0s8aUNEE50mnFHIg4+TfmBdCqJYikd+QI60NyTfISdwtkGyBZPPGfm
         v2Bw==
X-Gm-Message-State: AOAM533nNPpPb6PzDlil+MesqP98oFaYFBPFmfy4k37aAhDbB4AgyD1G
        o0rDvHA1H+MP+zkivYpBfC2OoWbB7hQ=
X-Google-Smtp-Source: ABdhPJxbqjts/xW1dOXcBXGREypdE4NrY0Usn/jaJuwFFaekrMb+YSrDJodJUp3RZJ91lCUZbBEE/WCIORY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:d59f:9874:e5e5:256b])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102e:: with SMTP id
 x14mr1711176ybt.410.1631653797888; Tue, 14 Sep 2021 14:09:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Sep 2021 14:09:51 -0700
In-Reply-To: <20210914210951.2994260-1-seanjc@google.com>
Message-Id: <20210914210951.2994260-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210914210951.2994260-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 2/2] KVM: SEV: Flush cache on non-coherent systems before RECEIVE_UPDATE_DATA
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Masahiro Kozuka <masa.koz@kozuka.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Masahiro Kozuka <masa.koz@kozuka.jp>

Flush the destination page before invoking RECEIVE_UPDATE_DATA, as the
PSP encrypts the data with the guest's key when writing to guest memory.
If the target memory was not previously encrypted, the cache may contain
dirty, unecrypted data that will persist on non-coherent systems.

Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Masahiro Kozuka <masa.koz@kozuka.jp>
[sean: converted bug report to changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 95228ba3cd8f..f5edc67b261b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1470,6 +1470,13 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_trans;
 	}
 
+	/*
+	 * Flush (on non-coherent CPUs) before RECEIVE_UPDATE_DATA, the PSP
+	 * encrypts the written data with the guest's key, and the cache may
+	 * contain dirty, unencrypted data.
+	 */
+	sev_clflush_pages(guest_page, n);
+
 	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
 	data.guest_address |= sev_me_mask;
-- 
2.33.0.309.g3052b89438-goog

