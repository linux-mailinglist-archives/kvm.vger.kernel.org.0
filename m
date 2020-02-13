Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0761915C96A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 18:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgBMR1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 12:27:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50976 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbgBMR1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 12:27:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so7161888wmb.0;
        Thu, 13 Feb 2020 09:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=xcUKyinhdCpe0Y5faS3M8RVdOca9RIh5O3GnfPcsZ1E=;
        b=ZWwD80NFfEejpAMYgf7bkpcyvwCC6dqcLDc2ipnLME/c8W+t3hvH25tZAuIzDYz4Jh
         qEDDIeaTMtLfSBLJ6RQJCI73fhgA8cslxbVdSXpOPk2ZRWfmERBR1+KLXEZvRG8ZdT5M
         eb05m1hJtjqHGXCDcTvY30p57DIczbslyE69InVjBOg+z0xPLo4mUUQBL9446TSIM0SN
         naDvrtxvEwfJL3RHqkKbzltS0zUw3y8JMo4Uw4fStNVEAgTFLGW/QzdxQKYCVxh0MOeU
         k8uOuuUftROrFsN84J/UmPBVCDJ1mkaD+/KPIrXbXtSotq+dJi88RvazPByansW9RB+6
         +Z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=xcUKyinhdCpe0Y5faS3M8RVdOca9RIh5O3GnfPcsZ1E=;
        b=fb4VlVs03hq6HGGWu4dxs0YCZdmjj45c3Y3ztarObJDqyXWVQBIHvbe1khAo/9FCt7
         rPtmxcVK7viMvTftFupLMA8YXuS2WRuwWx9E5TjUob1CqSEAud8sg/abxpKUVxYXMjuo
         cPE7VHfc5siDcaNi6BPo0Vd7fnr/A4H4i7SckMmlbR7ARNRzwIZTibNiBza+I9UEmc7b
         vnyt1pKab4sqS8K8gfANXO+CpU/DjbcKoY5oYmCLK3SOev3hhwe5OmSqT0g2l3OUjWQ6
         6LYZlRx9ClrxWpgx2Fsc/ic6jseV6YOV+KK+QiSryHTSzV5ao9E77vAHpeilXnSdxae7
         kS2A==
X-Gm-Message-State: APjAAAXoOjnfuM8iLeeiRjCHLHSmZdvooiAUvCw+LL6mNSoB6nkWKwOE
        9XKcwv+72TDZZ+5eBC1iHvDSxdna
X-Google-Smtp-Source: APXvYqylTYL5EvQ84wer++V2W5M5f6n9RK/s4bE8e/GOsVrXZdXk3hAB6zc89oqvmKZWQvj/0R8xqQ==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr6618267wmm.97.1581614819091;
        Thu, 13 Feb 2020 09:26:59 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 21sm3952017wmo.8.2020.02.13.09.26.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 09:26:58 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     cai@lca.pw
Subject: [PATCH] KVM: x86: fix incorrect comparison in trace event
Date:   Thu, 13 Feb 2020 18:26:57 +0100
Message-Id: <1581614817-17087-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "u" field in the event has three states, -1/0/1.  Using u8 however means that
comparison with -1 will always fail, so change to signed char.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmutrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3c6522b84ff1..ffcd96fc02d0 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -339,7 +339,7 @@
 		/* These depend on page entry type, so compute them now.  */
 		__field(bool, r)
 		__field(bool, x)
-		__field(u8, u)
+		__field(signed char, u)
 	),
 
 	TP_fast_assign(
-- 
1.8.3.1

