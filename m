Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B795187844
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 04:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgCQDs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 23:48:28 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39680 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgCQDs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 23:48:27 -0400
Received: by mail-wm1-f54.google.com with SMTP id f7so20333322wml.4;
        Mon, 16 Mar 2020 20:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wyf1C6fvDgXY4wvk08Bh1opszF62aUSzjowFRYBQm0=;
        b=N5bu65WGQe4to2kj6cRbT91ksKW+ulaqmcan0SE0LeqlmvpjI38tsYN6oLpXkh8T4Q
         4HdOLIhAgJJsXh2NvydGHDESmU2B1J1fcJPwrDa2fo/mYy3k7zMLkXyDw0fzjGpeSHLQ
         zth4awAk10OfVpYiUec90RqnvkatGTPAt0hq7Im918p+9MxLLgv7hW2m6YS9v0Hq6H3E
         E6ygD0QSmBnUmBI5VN+fyGX2txlaVdi6ug81zX+Uczvoj72MWCySxn0N2tq47csgW7Hi
         Um0EfDREDyyK1WjiagHW86hfLIlKUSvZMidef4HRc8GTgzbPJO4tvg0rmvc5bBKalO1v
         UavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wyf1C6fvDgXY4wvk08Bh1opszF62aUSzjowFRYBQm0=;
        b=o1xdNrrtgC7beY4kt63kgLVlGQSMi6mGgFCdc15E+xT03aN9PnolhRWS5tpIQQV0fA
         g0Ig3ggLpuFO1Gx+Nj21HVGwDnkyrRxOakbvZ+sjcMzoUYvtyLIw6RT52aa9zpGnDH9K
         lUYpUXx8h+J+6po+IJe2BYphONek7prwUG+jJhAHp1D7ChiYeFX+Bxn6kn/YSstYkhqH
         JI7iGvqRbmMvQBKnvDAS57soPdjLHmqCzpaKquRhrGhxckTJxlgDSIBX1xsn6N+VOLlM
         x5SpJOP7GDEmbvDIjZ+U/7PYKClMd/p9ggX2yQuJ5vvHtjfoAbBrqdfC4SJ6wFvOjLoQ
         +MZg==
X-Gm-Message-State: ANhLgQ2bY2W2TaHEmj7RvVjrGeTU2EHJjeNC0Q8boXsxgh8Qwhok8/yA
        kj+ZiHjBU272FCDFMw4JLnubBIIWonQ=
X-Google-Smtp-Source: ADFU+vtjGgmes94M/UmfLe+nc+uaJFj49wmHRIBao9RmhseNbQ0AkiNQzvNZb3EMuqo7FsrZhqM4Qw==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr2556256wmb.177.1584416905577;
        Mon, 16 Mar 2020 20:48:25 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id c23sm1457757wrb.79.2020.03.16.20.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 20:48:25 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v6 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Tue, 17 Mar 2020 05:48:00 +0200
Message-Id: <20200317034804.112538-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317034804.112538-1-arilou@gmail.com>
References: <20200317034804.112538-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

