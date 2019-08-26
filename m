Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68829C92D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfHZGVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35230 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbfHZGVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id d85so11128603pfd.2;
        Sun, 25 Aug 2019 23:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gNf5ZL0Lz4r2GcoGjcAFgnDGuk7h+uzlYMdrguHa03U=;
        b=Vss4dMZ2j5htmPtoE3AwNO0YRp9sUcRZXatOeKmyvxLztxPWkbwb99NJkQykmYVSQZ
         s6WEV4WolhtvigRpwdsfDGtpKyyR7Te5X4x0DjLd1E8P4GSIV+i+7OVatUqMJe4mfG4M
         yA102lf+fA9HEh0Porhr798Q4/JyVWnvunZuFiJD4Y4r/fB+R4AjOsdtAa75FVkGCQMl
         hWsBWYlCv96C/cnySCS3xoB3mxqJ3F3voqaqBrtyDSAqzk/Tbh+pVNn2Bu8PocvVD9Rd
         R3xe9O+SOKOI33qMxUh51PLzAOwMtKXEvB981Jzbqbk/ovik0AGiFkSqXVs8F97rRPLt
         HaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gNf5ZL0Lz4r2GcoGjcAFgnDGuk7h+uzlYMdrguHa03U=;
        b=NUuBpvQqMWu17wXXQVGRsHXnY/F0XpVbHQgnu+AUVwx/f5AJnWGVPyTGeYk4QfqWEX
         uGPoSsqGUi9UV0hGfl3zUGJleZl0nUaq0Ev/3BVt1nfXJgS+82M3tWvPbs9QEe9RQ44e
         4gIcDmxJJSBevspn3QrbcypjO5vJ1DIuIZ/CSTkqTAzR09MNj0ROOqH7kdNdXbbbphHL
         Ro3gIWvSNYEokc5OifpVgNu7DsK9Ft/xgD0KiJQ+Se6ApGA63NUDf8LG94m1SDdtTDJl
         acq3nzy5r0fCIl6uc/ZkiYVDr/y0u85ycTJKA5gnkfLHF8VIEpcobYgOZ34//ZPkv6r6
         aw+w==
X-Gm-Message-State: APjAAAVtgYc/O/M+LtysvSkpfwJeRrpIm6snYk1iF8PHaPAQDSytUVqB
        d8FJgMaiP4AZJv7kcIw12ff1vKTZbQU=
X-Google-Smtp-Source: APXvYqxYW4mZby2zgIzajDXHS5jY/pi87m6YhDYVIrrsroTxmWOSzGKUzXphfccNdn0hVxc5g2amsA==
X-Received: by 2002:a62:1ad4:: with SMTP id a203mr18037546pfa.210.1566800480750;
        Sun, 25 Aug 2019 23:21:20 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:20 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 02/23] KVM: PPC: Book3S HV: Increment mmu_notifier_seq when modifying radix pte rc bits
Date:   Mon, 26 Aug 2019 16:20:48 +1000
Message-Id: <20190826062109.7573-3-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm mmu_notifier_seq is used to communicate that a page mapping has
changed to code which is using that information in constructing a different
but reliant page mapping. For example when constructing a mapping for a
nested guest it is used to detect when the guest mapping has changed, which
would render the nested guest mapping invalid.

When running nested guests it is important that the rc bits are kept in
sync between the 2 ptes on the host in which they exist; the pte for the
guest, and the pte for the nested guest. This is done when inserting the
nested pte in __kvmhv_nested_page_fault_radix() by reducing the rc bits
being set in the nested pte to those already set in the guest pte. And
when setting the bits in the nested pte in response to an interrupt in
kvmhv_handle_nested_set_rc_radix() the same bits are also set in the
guest pte, with the bits not set in the nested pte if this fails.

When the host wants to remove rc bits from the guest pte in
kvm_radix_test_clear_dirty(), if first removes then from the guest pte
and then from any corresponding nested ptes which map the same guest
page. This means that there is a window between which the rc bits could
get out of sync between the two ptes as they might have been seen as set
in the guest pte and thus updated in the nested pte assuming as such,
while the host might be in the process of removing those rc bits leading
to an inconsistency.

In kvm_radix_test_clear_dirty() the mmu_lock spin lock is held across
removing the rc bits from the guest and nested pte, and the same is done
across updating the rc bits in the guest and nested pte in
kvmhv_handle_nested_set_rc_radix() and so there is no window for them to
get out of sync in this case. However when constructing the pte in
__kvmhv_nested_page_fault_radix() we drop the mmu_lock spin lock between
reading the guest pte and inserting the nested pte, presenting a window
for them to get out of sync. This is because the rc bits could have been
observed as set in the guest pte and set in the nested pte accordingly,
however in the mean time the rc bits in the guest pte could have been
cleared, and since the nested pte wasn't yet inserted there is no way
for the kvm_radix_test_clear_dirty() function to clear them and so an
inconsistency can arise.

To avoid the possibility of the rc bits getting out of sync, increment
the mmu_notifier_seq in kvm_radix_test_clear_dirty() under the mmu_lock
when clearing rc bits. This means that when inserting the nested pte in
__kvmhv_nested_page_fault_radix() we will bail out and retry when we see
that the mmu_seq differs indicating that the guest pte has changed.

Fixes: ae59a7e1945b ("KVM: PPC: Book3S HV: Keep rc bits in shadow pgtable in sync with host")

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 2d415c36a61d..310d8dde9a48 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1044,6 +1044,8 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 		kvmhv_update_nest_rmap_rc_list(kvm, rmapp, _PAGE_DIRTY, 0,
 					       old & PTE_RPN_MASK,
 					       1UL << shift);
+		/* Notify anyone trying to map the page that it has changed */
+		kvm->mmu_notifier_seq++;
 		spin_unlock(&kvm->mmu_lock);
 	}
 	return ret;
-- 
2.13.6

