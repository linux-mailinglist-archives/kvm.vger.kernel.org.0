Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFCF179732
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgCDRv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:51:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730108AbgCDRv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:51:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IJXI3OyHBMNvDSp9XDQtawbxBSkKafXuFCrtPHquIJw=;
        b=akvkN1fHlnK7OgqWCEJIp1VwCHIjSu5Rdeb+ujQEUW4IL8h/UtVnARklOIF8mAqgazOeXo
        01KoownD91HYeEdBJDBT2TQF+qu+tgb9L48+BWV5niFwc+K/Xyl0YZaer0V9R49b8m/QQ4
        EjiyiAqaYfJ3Ew4HLTGjRinHzf9FJ6w=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-8olOCbdmOTCF1QC9Z6HswA-1; Wed, 04 Mar 2020 12:51:55 -0500
X-MC-Unique: 8olOCbdmOTCF1QC9Z6HswA-1
Received: by mail-qv1-f69.google.com with SMTP id l16so1342173qvo.15
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:51:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJXI3OyHBMNvDSp9XDQtawbxBSkKafXuFCrtPHquIJw=;
        b=K5F49Dm9+qaMYGcKyYRPb5IBEpXFznZIaoaXXCDx8KGlFc/aAiPXa4DVz0wQhs6QgA
         T5iJ8cussetQEGCMzBjsUPhdfO/ZwI9xTjTEbY5JnUKyxZ+nPzvTkMMzucqzpb0xsuva
         wOQ62fpuFi6IRlg0OCWkrkij+dku2xNe9QY3Pd1VatcaZUErw6Bee+7T3CwK8BuVadJ4
         NI3JB/4wSTOlO6wRRi8koaYao6qrTY4OMPzLDx9lQW2ozEUaE3zXdJr/5Su16pKP5mt4
         0jwKUD3jZj+geaoZLAR3Jfh8t8Yg4nWzDOvMrmZLoW6aca9QrpauUH52dLPk0CoNiY4P
         dAUQ==
X-Gm-Message-State: ANhLgQ06spDYdoQTOEzF5gtQFUw1GuUQ70nJQDhflZVEa2LE5T6Ncb/k
        AyEmrrambnjeC7BaC5CW8HLlbYfzB9OzahijxYLo/W7lQHQ34uyQ8JZXTZfdtmU4T8TXXy6UvDD
        b3f+FNcks2pjK
X-Received: by 2002:ac8:5190:: with SMTP id c16mr3490703qtn.200.1583344314481;
        Wed, 04 Mar 2020 09:51:54 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtWEE5pJUAb30CAlOc0HdE+PUBn4KyN4CpVzLvvvPRbZcbJ8+PWR7QVW9jUIxp3W8cZRXvkfA==
X-Received: by 2002:ac8:5190:: with SMTP id c16mr3490689qtn.200.1583344314257;
        Wed, 04 Mar 2020 09:51:54 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id o4sm14008251qki.26.2020.03.04.09.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:51:53 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: Drop gfn_to_pfn_atomic()
Date:   Wed,  4 Mar 2020 12:51:52 -0500
Message-Id: <20200304175152.70471-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's never used anywhere now.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bcb9b2ac0791..3faa062ea108 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -704,7 +704,6 @@ void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
-kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..d29718c7017c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1754,12 +1754,6 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot_atomic(gfn_to_memslot(kvm, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
-
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-- 
2.24.1

