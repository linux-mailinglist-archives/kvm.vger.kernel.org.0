Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B36FB3ED1
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbfIPQXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 12:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731470AbfIPQXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 12:23:09 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E23D8C050E0B
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 16:23:08 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id c1so115929wrb.12
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 09:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n34lZLdG/ksf/JKaFfjzz8cm8EDZ8nIYDrb9i3krQTc=;
        b=NM00STxT4olnRSziQeRaGSexc3iSovh+TC+843IINge4qSF0/XNbDWPqR0YDmJ+xAo
         w2FGtfsdw8kYJP7iic9B0quqWtOJ6QBrmOEMmXZocUPaSOZ7CMoBHJxU6/r8cwmQW/sG
         hiQSOkPA10I76GCs7rfhBB4qPSqBEy3wl2zUvKNKrAuVv0MO9UHD5eJkCMUOUezN/AzH
         rPIiTtkJsMXXrj6taZBxNVHxtLq21BE+mSbWq+3PyJ4RmuTb/lnSIpHf0743Gb08elX7
         /n6GxH2Qupf5stYrrZ0NMqQll39k3nlN0YRVGYxFqYYdi0HlBfxoU3ZVt6NkFj9Kxhjf
         NAOg==
X-Gm-Message-State: APjAAAUAqkrlwnoPWsw9n1OHgLk9hgodWRk6TBx+FUpBA1iFOBbPX6uv
        B7vKYfsHb892ZlGdPRYkJh/A11wBFw6HoU2YIZbjzEHHFzyY3uxj3UtlpgGFEUIZd5tbi6/IkMw
        wT48Zc62eLzER
X-Received: by 2002:a7b:cd96:: with SMTP id y22mr263559wmj.169.1568650987153;
        Mon, 16 Sep 2019 09:23:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzOEzFZvaXPQ3JnKoR56GcxQnkFWhDS8m8D8bHNbgjvynKxDkSwMh32zieTRke9CCVfdOzRPw==
X-Received: by 2002:a7b:cd96:: with SMTP id y22mr263537wmj.169.1568650986942;
        Mon, 16 Sep 2019 09:23:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q10sm78370575wrd.39.2019.09.16.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 09:23:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 3/3] KVM: selftests: hyperv_cpuid: add check for NoNonArchitecturalCoreSharing bit
Date:   Mon, 16 Sep 2019 18:22:58 +0200
Message-Id: <20190916162258.6528-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916162258.6528-1-vkuznets@redhat.com>
References: <20190916162258.6528-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bit is supposed to be '1' when SMT is not supported or forcefully
disabled and '0' otherwise.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index ee59831fbc98..443a2b54645b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -26,6 +26,25 @@ static void guest_code(void)
 {
 }
 
+static int smt_possible(void)
+{
+	char buf[16];
+	FILE *f;
+	bool res = 1;
+
+	f = fopen("/sys/devices/system/cpu/smt/control", "r");
+	if (f) {
+		if (fread(buf, sizeof(*buf), sizeof(buf), f) > 0) {
+			if (!strncmp(buf, "forceoff", 8) ||
+			    !strncmp(buf, "notsupported", 12))
+				res = 0;
+		}
+		fclose(f);
+	}
+
+	return res;
+}
+
 static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 			  int evmcs_enabled)
 {
@@ -59,6 +78,14 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 		TEST_ASSERT(!entry->padding[0] && !entry->padding[1] &&
 			    !entry->padding[2], "padding should be zero");
 
+		if (entry->function == 0x40000004) {
+			int nononarchcs = !!(entry->eax & (1UL << 18));
+
+			TEST_ASSERT(nononarchcs == !smt_possible(),
+				    "NoNonArchitecturalCoreSharing bit"
+				    " doesn't reflect SMT setting");
+		}
+
 		/*
 		 * If needed for debug:
 		 * fprintf(stdout,
-- 
2.20.1

