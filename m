Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D42568A
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 19:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbfEURWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 13:22:05 -0400
Received: from shelob.surriel.com ([96.67.55.147]:37336 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfEURWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 13:22:05 -0400
Received: from [2603:3005:d05:2b00:6e0b:84ff:fee2:98bb] (helo=imladris.surriel.com)
        by shelob.surriel.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <riel@shelob.surriel.com>)
        id 1hT8Si-0004YY-3a; Tue, 21 May 2019 13:22:04 -0400
Date:   Tue, 21 May 2019 13:22:00 -0400
From:   Rik van Riel <riel@surriel.com>
To:     "Paolo Bonzini" <pbonzini@redhat.com>
Cc:     kernel-team@fb.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Radim =?UTF-8?B?S3LEjW3DocWZ?=" <rkrcmar@redhat.com>
Subject: [PATCH] kvm: change KVM_REQUEST_MASK to reflect vcpu.requests size
Message-ID: <20190521132200.2b45c029@imladris.surriel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code using KVM_REQUEST_MASK uses a pattern reminiscent of a bitmask:

	set_bit(req & KVM_REQUEST_MASK, &vcpu->requests);

However, the first argument passed to set_bit, test_bit, and clear_bit
is a bit number, not a bitmask. That means the current definition would
allow users of kvm_make_request to overflow the vcpu.requests bitmask,
and is confusing to developers examining the code.

Redefine KVM_REQUEST_MASK to reflect the number of bits that actually
fit inside an unsigned long, and add a comment explaining set_bit and
friends take bit numbers, not a bitmask.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 include/linux/kvm_host.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79fa4426509c..d15fb43d7796 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -138,7 +138,8 @@ static inline bool is_error_page(struct page *page)
 	return IS_ERR(page);
 }
 
-#define KVM_REQUEST_MASK           GENMASK(7,0)
+/* Limit the bit numbers for set_bit etc to fit unsigned long vcpu.requests. */
+#define KVM_REQUEST_MASK           (BITS_PER_LONG-1)
 #define KVM_REQUEST_NO_WAKEUP      BIT(8)
 #define KVM_REQUEST_WAIT           BIT(9)
 /*

