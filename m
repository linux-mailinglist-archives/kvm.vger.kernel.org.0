Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B92035318E
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 01:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhDBXh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 19:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbhDBXhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 19:37:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4345C0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 16:37:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g7so4247322ybm.13
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 16:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tWGPmYxfnzt33W3VLjjp8IWoTi4qctFUNmTStaF/oq0=;
        b=UpI8DoSTQX7z6FJEew6k3pZBAAaeryLjvfqdCALVHSZkoxag55UxcpnNfq2hT4TR2r
         IAXZsXjDIEDDekJrQnIGhW/wI0PdAe3iOX0jQx1AFlI/aqEiNMOnIXPjzo02HJwDoGwc
         2Yf9V9Z3cYw9I1tkTmrbSdA+p0zO4yO9I/sL+jYh1a/xn+sqx0NilImXWXSEAPSMHeLe
         C8M1OMqQr6TK7MwqYbE978iQQ04R1Q1OsXruOzap5nBalD7ojI9VAJtjHDBeMRJHccbd
         xErCdUKschPo+3yY27kdAXYDzz/gWIMUVVRaAHkNmWlaFgxElrXYFSSLM5Lc9vhhbO0C
         Wu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tWGPmYxfnzt33W3VLjjp8IWoTi4qctFUNmTStaF/oq0=;
        b=fucX3bxmL9H+MH4CpKbMny/T49pO6XvszmafguScJ8Kn/zwaEv54t13Yb5Epobuxp8
         GGgfu2Xpk2XHn7RlGMQ3QqEjqUi+a7ZPZcAGn7k/76zUu9VvPX30QPo2gp+Qbv3jH6L3
         h0RI6Wg9asBXUMbwDccxPNytfFdQ97/Cvg0yAe/X/MqX8sn46EfUIQagGfIVplwzF0Z+
         oZXqR3rBv6wV7en+zvtfKeW9vn0wdyIbyftad1Hl2DAmvSK4QIdw/2qUUy44pe8QBvGB
         HytPv0V9eyR+uNQmVWMVuJ9RmJ9hX8WXjeRIl6FMdoH2kJ5nFMxd9A3OwRJrd3xkRhx2
         cFrg==
X-Gm-Message-State: AOAM531pojjTmKx2o5v+MeMTUwvxOakd4Rc+/jHNzlapaTQ0B0koJSkf
        QHercJXcZ2hY2PyohFTiSNinGek9cRw=
X-Google-Smtp-Source: ABdhPJy6YL9pZNR9w8jmEfEXNWHxNDT8FkCUSSRdz49Ri5z+71ONhVQyFSckRoWglSVSnn/W/zezRMkLwrs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a7:3342:da61:f6aa])
 (user=seanjc job=sendgmr) by 2002:a25:d6d4:: with SMTP id n203mr18713882ybg.177.1617406638887;
 Fri, 02 Apr 2021 16:37:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Apr 2021 16:36:59 -0700
In-Reply-To: <20210402233702.3291792-1-seanjc@google.com>
Message-Id: <20210402233702.3291792-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210402233702.3291792-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 2/5] crypto: ccp: Reject SEV commands with mismatching command buffer
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
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN on and reject SEV commands that provide a valid data pointer, but do
not have a known, non-zero length.  And conversely, reject commands that
take a command buffer but none is provided.

Aside from sanity checking intput, disallowing a non-null pointer without
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
 drivers/crypto/ccp/sev-dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6556d220713b..4c513318f16a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -141,6 +141,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	struct sev_device *sev;
 	unsigned int phys_lsb, phys_msb;
 	unsigned int reg, ret = 0;
+	int buf_len;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -150,7 +151,11 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev = psp->sev_data;
 
-	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
+	buf_len = sev_cmd_buffer_len(cmd);
+	if (WARN_ON_ONCE(!!data != !!buf_len))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(data && is_vmalloc_addr(data)))
 		return -EINVAL;
 
 	/* Get the physical address of the command buffer */
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

