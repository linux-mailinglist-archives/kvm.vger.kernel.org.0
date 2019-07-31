Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228D27C58F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbfGaPId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37853 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388624AbfGaPIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:32 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so66061239eds.4
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPsK2XRosHpKRDn42pkA1hocZnIJH8axKf5oqIqvF+0=;
        b=RoXYiUX1XnPhAzuEc/754GCS7jv20HjdtnuA0D6/z6EQWRYWWlJYLUmYCp5A9gF6t0
         xmdTvGf/RDPJGsWdvfduqJSiPxD1iQy03XbdfaIQyAILVGsn2EfooQl1HvX68XEmvKvE
         YLVQ2+mjfACH42lwtOVvTBDcZBjRVOCatWgbntGFkKnEMI7/phw5FB2FZk9Pt9J7I72/
         XSOCXiRLBenu+N9P+C9H7h3JIHVw5uD4w9ATyXvDePOwu1HaCpJlCNydaVH+dgiEvjFc
         icfbQU69vCZT3uQOtoM3gTX73RLNevnI2i7LMnV1I9DzMb0PsfE3TEa5CJMzEo4Nvk/X
         DA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IPsK2XRosHpKRDn42pkA1hocZnIJH8axKf5oqIqvF+0=;
        b=qbhbNMwPRyUAnfo+WHG97gTHvI/rarTmbQtPoVShC9dB8kbqP3T8rD2+XBDmNpt2Yn
         wkly8c4L+1snKzTolwKI08uBWTN3umxqmFZ/A/ketlBrff30XRfwfCDYwuzc2mUB9ZeY
         m3fzGSH4AYE5X5GGvYn5Vm8q8xgJ/4MQ5NLiS/f92M7VGqTFUcojJu7c1Fh4JCmdg0cy
         F+daDP3TnBViH464RHfn/cSaDBfgrKK0Nl6p4lQSrQ/MsP5LxC8hXujCwYM+H3fyAzfg
         Cw2Cg9EObdVUy670l7earAh7f8Q2ifxzP6fMDk1isZ4u79xx7QpSz6XeBIY9MKtNSxgP
         b7nw==
X-Gm-Message-State: APjAAAXGjSgrnox2+N0PzSWo0lrc6AW70vpMExmyqrhjABspvbfVM7a3
        FI5tF7f0aZz+W/z9t+liHfA=
X-Google-Smtp-Source: APXvYqw++kl/s7OZc/atZ5tqKoJq5up6RoggcbrTF/G7ZR/ZGQU8Rbyr5OdWAhG3JNmHVdhx6GXBWA==
X-Received: by 2002:a17:906:914:: with SMTP id i20mr28046601ejd.213.1564585710645;
        Wed, 31 Jul 2019 08:08:30 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id uz27sm12533468ejb.24.2019.07.31.08.08.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:28 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 1E0E2104600; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 42/59] syscall/x86: Wire up a system call for MKTME encryption keys
Date:   Wed, 31 Jul 2019 18:07:56 +0300
Message-Id: <20190731150813.26289-43-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

encrypt_mprotect() is a new system call to support memory encryption.

It takes the same parameters as legacy mprotect, plus an additional
key serial number that is mapped to an encryption keyid.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 include/linux/syscalls.h               | 2 ++
 include/uapi/asm-generic/unistd.h      | 4 +++-
 kernel/sys_ni.c                        | 2 ++
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index c00019abd076..1b30cd007a6a 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -440,3 +440,4 @@
 433	i386	fspick			sys_fspick			__ia32_sys_fspick
 434	i386	pidfd_open		sys_pidfd_open			__ia32_sys_pidfd_open
 435	i386	clone3			sys_clone3			__ia32_sys_clone3
+436	i386	encrypt_mprotect	sys_encrypt_mprotect		__ia32_sys_encrypt_mprotect
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index c29976eca4a8..716d8a89159b 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -357,6 +357,7 @@
 433	common	fspick			__x64_sys_fspick
 434	common	pidfd_open		__x64_sys_pidfd_open
 435	common	clone3			__x64_sys_clone3/ptregs
+436	common	encrypt_mprotect	__x64_sys_encrypt_mprotect
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 88145da7d140..4494b1d9c85a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1000,6 +1000,8 @@ asmlinkage long sys_fspick(int dfd, const char __user *path, unsigned int flags)
 asmlinkage long sys_pidfd_send_signal(int pidfd, int sig,
 				       siginfo_t __user *info,
 				       unsigned int flags);
+asmlinkage long sys_encrypt_mprotect(unsigned long start, size_t len,
+				     unsigned long prot, key_serial_t serial);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 1be0e798e362..7c1cd13f6aaf 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -850,9 +850,11 @@ __SYSCALL(__NR_pidfd_open, sys_pidfd_open)
 #define __NR_clone3 435
 __SYSCALL(__NR_clone3, sys_clone3)
 #endif
+#define __NR_encrypt_mprotect 436
+__SYSCALL(__NR_encrypt_mprotect, sys_encrypt_mprotect)
 
 #undef __NR_syscalls
-#define __NR_syscalls 436
+#define __NR_syscalls 437
 
 /*
  * 32 bit systems traditionally used different
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 34b76895b81e..84c8c47cf9d6 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -349,6 +349,8 @@ COND_SYSCALL(pkey_mprotect);
 COND_SYSCALL(pkey_alloc);
 COND_SYSCALL(pkey_free);
 
+/* multi-key total memory encryption keys */
+COND_SYSCALL(encrypt_mprotect);
 
 /*
  * Architecture specific weak syscall entries.
-- 
2.21.0

