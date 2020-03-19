Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DFB18AC8A
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 06:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCSF7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 01:59:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38976 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSF7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 01:59:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id h6so1166997wrs.6;
        Wed, 18 Mar 2020 22:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qORovMW4qFXFXcdoIljFzjQs+83nq3xI2+7AeVXu0Jo=;
        b=nOOB05HtYbAQ6YRUSNddR9ZQ+6/ctli+nnZkioh6T3HYsfY4+Zuew9FggRhG2speTc
         awFaRyQYwhZPzl12+wYCReZL2030hIO/t4NouiMRtPF2zVcZ8XOqe8M6B2oGWHYi43Uq
         k7Jgw3umWgtcSc8NQJpK4vWdBA+96kHOokL8iwldpbE2epRj57ltRRD5ez8V28OsEg9w
         bdqAHn2hnj7r90T655m3EWVAPQhKFyfR253k33N86mNty69Ep3JmA42p2dVJXsTQSOO+
         k5qeQ3ZMMMZYBlbSzvlz10Qrmpj3h6UcsMLgsScaafKKU9JVA8IhWVvprq4XajLNyLTF
         h6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qORovMW4qFXFXcdoIljFzjQs+83nq3xI2+7AeVXu0Jo=;
        b=bPTPCRGWw9VKfivv3TTQtMWWS6TRe3QkUbefDLY+D4/n/RVQVbNagCcA7TC/jJjN9o
         xGQupVshIM7sGxL+K/CH/luQijswAQ6ROEbyhY97ciZoN0ChFcnKcKxONLyvE1n3SGaK
         4+MZIm5IHl7SAKSq6JqzWdnei+Anza7eI9qpnPveiT86oqwAcXq82/yaOFFJXA27rurR
         qkiY/m3fLfWyGw/8C7Z7xa6PQqQcubkEOKyGj0cxmK5EeZcUdfTmqLncZo/F8J+SNBEg
         ZzCoCFlVwAMZnvZPx6cCiau63HIjF2PNt2jvr5JvVbuq34VeR98Lvu/1lk6YLZ1IdkGp
         1Y1g==
X-Gm-Message-State: ANhLgQ34dM//TqMO9pnKpOG/V1OmXJ2CT1ZwlNF7l/ZOz2ej3ofRFV1y
        wbFIA6ETDwW9dfZwqRKtzJU+Jv+cQX8=
X-Google-Smtp-Source: ADFU+vtnopswMiu3EvNFMbvxn803dFChQpCfrbFVo1x6X+PQHxVbVqXJ4Sybbk9f2hJDEY835gKyoQ==
X-Received: by 2002:a5d:69cb:: with SMTP id s11mr1832766wrw.47.1584597537739;
        Wed, 18 Mar 2020 22:58:57 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id n2sm1884174wro.25.2020.03.18.22.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 22:58:57 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v7 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Thu, 19 Mar 2020 07:58:38 +0200
Message-Id: <20200319055842.673513-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319055842.673513-1-arilou@gmail.com>
References: <20200319055842.673513-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The problem the patch is trying to address is the fact that 'struct
kvm_hyperv_exit' has different layout on when compiling in 32 and 64 bit
modes.

In 64-bit mode the default alignment boundary is 64 bits thus
forcing extra gaps after 'type' and 'msr' but in 32-bit mode the
boundary is at 32 bits thus no extra gaps.

This is an issue as even when the kernel is 64 bit, the userspace using
the interface can be both 32 and 64 bit but the same 32 bit userspace has
to work with 32 bit kernel.

The issue is fixed by forcing the 64 bit layout, this leads to ABI
change for 32 bit builds and while we are obviously breaking '32 bit
userspace with 32 bit kernel' case, we're fixing the '32 bit userspace
with 64 bit kernel' one.

As the interface has no (known) users and 32 bit KVM is rather baroque
nowadays, this seems like a reasonable decision.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 ++
 include/uapi/linux/kvm.h       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebd383fba939..4872c47bbcff 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5025,9 +5025,11 @@ EOI was received.
   #define KVM_EXIT_HYPERV_SYNIC          1
   #define KVM_EXIT_HYPERV_HCALL          2
 			__u32 type;
+			__u32 pad1;
 			union {
 				struct {
 					__u32 msr;
+					__u32 pad2;
 					__u64 control;
 					__u64 evt_page;
 					__u64 msg_page;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..7ee0ddc4c457 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -189,9 +189,11 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
-- 
2.24.1

