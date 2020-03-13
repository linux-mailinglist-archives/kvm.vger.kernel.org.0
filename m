Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE61847E7
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCMNU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:20:57 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40872 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCMNU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 09:20:57 -0400
Received: by mail-wr1-f53.google.com with SMTP id f3so5073976wrw.7;
        Fri, 13 Mar 2020 06:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wyf1C6fvDgXY4wvk08Bh1opszF62aUSzjowFRYBQm0=;
        b=W0tsUm9ZEiiSWqRJF2QtSRp2ic9I5oBrN42Ay2dUzJXNH2i5zvlhF8sMpUcyhUJSMG
         09ZzXKETY3MQGVmzHPYzGvgUADFZqVaDq6L5qxSkRifNjdLKog4BdF7R6tTy6/kyJDXM
         PAeMCx8Kh+vIH6Bjz/NFrNiRWAyHOKKSkSoa+KxaGKhVRuz9lmWwPASsEZVMw4oCNrf4
         ariSnLtWVH7KJne+rZ2WVRQpWY0p+cP6Y0HgYS4jZ/c/NJ5rcMcPk5H0dnThDeWivT3G
         tJzXWDVd/Uvf6xo9/TE4+PXNMXDk5OS4r3b6z9KQATEsZPvOkYvl5t4jl3yE9MWq50lb
         hGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wyf1C6fvDgXY4wvk08Bh1opszF62aUSzjowFRYBQm0=;
        b=rvAOIBfUczfiWKLI62XAHQMroMbuJQUjx1BNW3Y4OccC/sgOB5MprfiT2n6FNmgwUj
         eSx39iT4KCGTqTj2JHNuXG+Z9u6f7Q9ZrPeSkTJ7n/6qi/LEAA9hy2uuaHo1+jnUe7CT
         Cmu5VEKZs7P2zHvg5M6UgI+m7pYF73cPVWGgkuVgaVpHfbqCPhYjEWhFh+t7g6BjsqQ4
         LVZ4GY1VPkrrxtnjAHwJigdexy0GYICVNiBYNKprGEB3squTh0FRdu+xHWfDhexxCD9i
         JkQVROG8dCXSkHsUVLg2kF2sV/p6xRwh1LFN4w7dy4ruwYOnrbzAWSVfQ2HRVJPCRY47
         EAbA==
X-Gm-Message-State: ANhLgQ1+VDvi/3JjRIy5OuDhTZcnEjnW69yiXyx6M8N/FmzucOcK364O
        jfeNDGjGEBCWDUJnUqjqex3YuDJcdgc=
X-Google-Smtp-Source: ADFU+vtL/FpqWd63CU/2WKZIMH+tVjqqYr4tY4VTvKnceraUtMaGgJ7SseHjenin4Qdvxh57YnNuQQ==
X-Received: by 2002:adf:a285:: with SMTP id s5mr18678820wra.118.1584105656034;
        Fri, 13 Mar 2020 06:20:56 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id v8sm77112121wrw.2.2020.03.13.06.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:20:55 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v5 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Fri, 13 Mar 2020 15:20:30 +0200
Message-Id: <20200313132034.132315-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313132034.132315-1-arilou@gmail.com>
References: <20200313132034.132315-1-arilou@gmail.com>
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

