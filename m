Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EEB1D7D76
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgERPxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgERPxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE0DC05BD0A
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z72so32834wmc.2
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bB9pDUjiIlea3U386GXuZY1NOAMaybVFycH+ZuoRiV0=;
        b=nurR+oeqvO38IlVAvYjrxVv0j0dklv6u3yVTDJ9MjtfJGYrgNsKLWs7v/EuSfT1Fyw
         0hekQj/tWlRwGvIoHSlzW9AuZtciTPQcEplw1Pk8G6K0Hbrx+YNLGqJqwsJiwTdGA5Ne
         v9/csSObyWiXDO8tXRQFSARTVgrKmme1B4xlK6G65N3bOCs9+um2jRul25Bre3/UOTza
         OGPqc/K941siuivQI1Wp+Y4WrR+at7LjrzQjI27bJrNP8FSbQYpiJjFPWWuWesiUuFfw
         ukETX0f+LCej7jAyGWg6NyrNnHEv4M8WOryfTbHiRYhmsQGp7mnvZiMDjtMW3y6pEggr
         wGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=bB9pDUjiIlea3U386GXuZY1NOAMaybVFycH+ZuoRiV0=;
        b=No+p//DTF41je92W1dhLOyDoVMiqmNK+t7ulQoNSv3BNyTOFvty9hk7Dlg5kDaylSS
         WXji4Q+kPcn0/ZLAGWAf4DU2uqy/euCCrpzKwqgx4cbZWNzLPLwxuhUwUuALBXtLlOJ4
         eMgosjWZVMb5AwOwuOU1bGp+FApO1aMXR3KwtdtXN3fD5YtJZ6WywxFp4Geug1vcJTbd
         2gYVDEB7FqMesAlctohVV9VyKDSMAvskz6U6mbi2Lv0kLYh51vYwL8zAgpKigjYUN8fE
         9b4sm3U4Ek+fuFqBFdx8+eLoW5YS/HyGwsaUdSDr+DjtGD4m8VPj6e5K9jKh3O78xCio
         ustQ==
X-Gm-Message-State: AOAM5314QrOi8wuvtfrbOaTeXkcnz71VjnZ4hhaZTgZLW4QFgagvNNyo
        dflHCzYPIZ++AibtskzP2iZ6u87yBto=
X-Google-Smtp-Source: ABdhPJyfeaVjxI8bi3kpjnvht2g384iEYsz/UxrYeBJJDMzC5vFKDJec5j+2beg6JCmhPLXHZGmWsA==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr20131549wmc.179.1589817193623;
        Mon, 18 May 2020 08:53:13 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:12 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 3/7] disas: Let disas::read_memory() handler return EIO on error
Date:   Mon, 18 May 2020 17:53:04 +0200
Message-Id: <20200518155308.15851-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200518155308.15851-1-f4bug@amsat.org>
References: <20200518155308.15851-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both cpu_memory_rw_debug() and address_space_read() return
an error on failed transaction. Check the returned value,
and return EIO in case of error.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 disas.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/disas.c b/disas.c
index 45285d3f63..c1397d3933 100644
--- a/disas.c
+++ b/disas.c
@@ -39,9 +39,11 @@ target_read_memory (bfd_vma memaddr,
                     struct disassemble_info *info)
 {
     CPUDebug *s = container_of(info, CPUDebug, info);
+    int r;
 
-    cpu_memory_rw_debug(s->cpu, memaddr, myaddr, length, 0);
-    return 0;
+    r = cpu_memory_rw_debug(s->cpu, memaddr, myaddr, length, 0);
+
+    return r ? EIO : 0;
 }
 
 /* Print an error message.  We can assume that this is in response to
@@ -718,10 +720,11 @@ physical_read_memory(bfd_vma memaddr, bfd_byte *myaddr, int length,
                      struct disassemble_info *info)
 {
     CPUDebug *s = container_of(info, CPUDebug, info);
+    MemTxResult res;
 
-    address_space_read(s->cpu->as, memaddr, MEMTXATTRS_UNSPECIFIED,
-                       myaddr, length);
-    return 0;
+    res = address_space_read(s->cpu->as, memaddr, MEMTXATTRS_UNSPECIFIED,
+                             myaddr, length);
+    return res == MEMTX_OK ? 0 : EIO;
 }
 
 /* Disassembler for the monitor.  */
-- 
2.21.3

