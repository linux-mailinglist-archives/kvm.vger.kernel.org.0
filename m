Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D1E355F00
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344289AbhDFWu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 18:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344235AbhDFWuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:24 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F373C061764
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 15:50:12 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 130so13580766qkm.0
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E1A/gblkNN/6Bje/9QrJMIEH7pX9CVt+XIM7D2u/QT4=;
        b=k1VLrYy+geJqpko3bJBWfwTk7EFl/ntdo4+YIV6WjKWLywWZAhoCVI99Q33FIXTJwJ
         PRmqJeDnkiUYEUU7ndGPuSz3KmCtBoeeH7ySyVSr6sbMr1EvcB//QT+06+cnMn4FfZJ/
         KNaCshRzkkcxCp6akBaQXn1jRKJ54Il9u6Plq+rdA58o1fb6yRqtR8rAUmfg3qKACgAV
         c7lrryjKG/h30uTEp1VyZqTgDrsfvNK0D5zj+T7p+t+aWra9t8VUgWqGk+Ex1W/AF/Qv
         nDU8QCFt3eokVPgAEupHKjYowpFTcL83hGHmZeT4PJUVnzNjEoiRzetiwD0yFksn9rEu
         0Qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E1A/gblkNN/6Bje/9QrJMIEH7pX9CVt+XIM7D2u/QT4=;
        b=DKVve5QpU91VNrQqPQRLM8ptdmE6gU5NqISa7dZtGUqGeicjiklbvOAsP3MAkrNlur
         7xPoE1D45sO4pA2NPN5pkAeQhA8741ZofZhSWLl0tKTS/WN/qZX8kSmMo70l70ffZMEm
         YXkJdWBaLHO7/K5nUlh6lSdJ4z0CIg6D94sLYqFgSh+SnuhQUvMeq8wvn9kvck78ApPL
         WJEwIPOnF8iVVZLxBeS/MGT4DfnlsucGjPLo17+H7s3kXvlgPV6RmNyqx6eOY1NML7Cz
         +QGPYGvfvusf5aWPU9hpyz/cqcbHI1gapW+TFG13NHK3neqoexLPNC8/QG1ipfYRdytN
         IR4w==
X-Gm-Message-State: AOAM530Wee6jnMp7aYf1ykT61a3J2mlziIdl4D94J+qrb5ZTAskoq/FD
        PokavsPEaqwCoddh8QqtoNXxIvqTgdc=
X-Google-Smtp-Source: ABdhPJxaxI7VjhhziYAL29D415tAxRWY0bganDlSPJ66nRvZU20MmlqaN5wLWQj0nlMBfo2tlmwp4MwJvlM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a0c:b410:: with SMTP id u16mr319148qve.8.1617749411458;
 Tue, 06 Apr 2021 15:50:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:47 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 3/8] crypto: ccp: Reject SEV commands with mismatching
 command buffer
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN on and reject SEV commands that provide a valid data pointer, but do
not have a known, non-zero length.  And conversely, reject commands that
take a command buffer but none is provided (data is null).

Aside from sanity checking input, disallowing a non-null pointer without
a non-zero size will allow a future patch to cleanly handle vmalloc'd
data by copying the data to an internal __pa() friendly buffer.

Note, this also effectively prevents callers from using commands that
have a non-zero length and are not known to the kernel.  This is not an
explicit goal, but arguably the side effect is a good thing from the
kernel's perspective.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3e0d1d6922ba..47a372e07223 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -141,6 +141,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	struct sev_device *sev;
 	unsigned int phys_lsb, phys_msb;
 	unsigned int reg, ret = 0;
+	int buf_len;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -150,6 +151,10 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev = psp->sev_data;
 
+	buf_len = sev_cmd_buffer_len(cmd);
+	if (WARN_ON_ONCE(!data != !buf_len))
+		return -EINVAL;
+
 	if (data && WARN_ON_ONCE(!virt_addr_valid(data)))
 		return -EINVAL;
 
@@ -161,7 +166,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		cmd, phys_msb, phys_lsb, psp_timeout);
 
 	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     sev_cmd_buffer_len(cmd), false);
+			     buf_len, false);
 
 	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
 	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);
@@ -197,7 +202,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			     sev_cmd_buffer_len(cmd), false);
+			     buf_len, false);
 
 	return ret;
 }
-- 
2.31.0.208.g409f899ff0-goog

