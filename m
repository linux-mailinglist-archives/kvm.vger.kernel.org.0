Return-Path: <kvm+bounces-13468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79FF68971E2
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D0791C27872
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A897B14900E;
	Wed,  3 Apr 2024 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="Xn8IhRa6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1A149E14
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152902; cv=none; b=bfHN9L8/kjRsun38lDg+zdYjMhKDj/kBRBUhquOgfDo9bHuxrNLbm6hu993Hj0Xwci/7SBXFn5Wcv8NVOuqYCyiOKrxjCzW+U/MrZ8rGPaRPProIBKIlsf0VkmL6lsf1OX7kBbEW7SBw6nFlM7szS+4itDdYYrDCuC+/e8RDOpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152902; c=relaxed/simple;
	bh=+HycdZGuj5OU1W/c5yOM/8/+whc2oRxO0Toug1yf4G8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ur/fwE5u5YnOZRnF4P2eg6c0w4VfbM6ah1r3NvvB+mp7VD03iq4rgaHXBnSdhBLVayWY+Fqgg4m605vGlDzGudKpHJkPk4w6AcySAAEXk0I29sA3R2LO2e5Y0Yvu4ZKS5LZ9t2FiGNbotbrh6x8tM72t8Xzp1tMHRDvKSR1sMRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=Xn8IhRa6; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-789e6f7f748so335060185a.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712152900; x=1712757700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaWEC4wEGQ+YlZ6ti6+WrczlEY+i0roOx8Ci2YqikeE=;
        b=Xn8IhRa6Q1hH8JPkpsL76ia39K74etBsnq86QvXDJzGkDlu4UQISCgwi31tudYRt83
         jPhWkuvW0WWDPNO5GqkZlkamSdX5m/51kSnDSQgYHV4I90SE59QgGnExdChoF6Hyxsy/
         DEBPORJpE0l965/MP4/PLQef9cZTT3H12g9caRcNBv7jcQ5dxHGDpDKbBGyAdCqr7UmK
         ii2GkcFQTeoXQ0TKmt2dtFu9E3LqK/cgIBT1TdNEm8K+8WXd1kr3P+HKnrm3VftvFPtB
         iodG5/lerUuBzTCWeouSem4Ps7N6uKHKXjVY9g1NsXICLR9FA3KpMZ6aSUbRhyMslQY4
         5ZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152900; x=1712757700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QaWEC4wEGQ+YlZ6ti6+WrczlEY+i0roOx8Ci2YqikeE=;
        b=lbriih+Wr33nhrg70yNAN42Zkwf5eghZtJSt6u6sPhpAq3fas6AODJzl2khfhgSsgj
         q7y3sdY5jDBCLCNFct+qPeuoOFkxvRMSvCdP7Y5HwUDvGum+sG/QbY1HATVae+HthCAm
         0opiS5Bg7IFvRVPhqKxRSxX6Ezxm8Hvcv0OmWPx/Xmua0TpGLuVUX6Ivvoq5E3b/5teK
         188AAx0j3G+J2WHd+eByIpzMTOjSe0zw7Xs2O192AW5m/Q0G1fU5ywOAcWMuG0geYOC0
         WudG7k6BWv3AqRVfpnRdlDDkiSxCLFOElTA9k6JJJOrHsHl4AaivvMXuKfFTip4V17b/
         G7Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVW8/NSRVm8RrCClWPms7H3dVGRbuPGBMclgo1Pem0sO0eAG45rC5bfzD3lP6oszqc0ZDgjJ8xEJ429vw/TifSoKzp0
X-Gm-Message-State: AOJu0YzoGLZ70OWowLXcjJ2VQ+s0hHBRXWoEioId91oeqQhlqrwhc97o
	bg9k1BSwJY0Td5BVUx5/GEDEBMijlaRNIG++Q187h5Ej7Xv99Az79bKHXJ5H74I=
X-Google-Smtp-Source: AGHT+IGXzY5eGF4cfLmjKD8WCxnHKVScVbM/F99svOb+MTbMgCl4GsOWSudI3dDOqx11Q2sEA8gtCA==
X-Received: by 2002:a05:6214:1384:b0:699:1ad9:259 with SMTP id pp4-20020a056214138400b006991ad90259mr2834018qvb.31.1712152900149;
        Wed, 03 Apr 2024 07:01:40 -0700 (PDT)
Received: from vinbuntup3.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id gf12-20020a056214250c00b00698d06df322sm5945706qvb.122.2024.04.03.07.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:01:39 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	himadrics@inria.fr,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH v2 5/5] selftests/bpf: sample implementation of a bpf pvsched driver.
Date: Wed,  3 Apr 2024 10:01:16 -0400
Message-Id: <20240403140116.3002809-6-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240403140116.3002809-1-vineeth@bitbyteword.org>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A dummy skeleton of a bpf pvsched driver. This is just for demonstration
purpose and would need more work to be included as a test for this
feature.

Not-Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 .../testing/selftests/bpf/progs/bpf_pvsched.c | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_pvsched.c

diff --git a/tools/testing/selftests/bpf/progs/bpf_pvsched.c b/tools/testing/selftests/bpf/progs/bpf_pvsched.c
new file mode 100644
index 000000000000..a653baa3034b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_pvsched.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+
+#include "vmlinux.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/pvsched_vcpu_reg")
+int BPF_PROG(pvsched_vcpu_reg, struct pid *pid)
+{
+	bpf_printk("pvsched_vcpu_reg: pid: %p", pid);
+	return 0;
+}
+
+SEC("struct_ops/pvsched_vcpu_unreg")
+void BPF_PROG(pvsched_vcpu_unreg, struct pid *pid)
+{
+	bpf_printk("pvsched_vcpu_unreg: pid: %p", pid);
+}
+
+SEC("struct_ops/pvsched_vcpu_notify_event")
+void BPF_PROG(pvsched_vcpu_notify_event, void *addr, struct pid *pid, __u32 event)
+{
+	bpf_printk("pvsched_vcpu_notify: pid: %p, event:%u", pid, event);
+}
+
+SEC(".struct_ops")
+struct pvsched_vcpu_ops pvsched_ops = {
+	.pvsched_vcpu_register		= (void *)pvsched_vcpu_reg,
+	.pvsched_vcpu_unregister	= (void *)pvsched_vcpu_unreg,
+	.pvsched_vcpu_notify_event	= (void *)pvsched_vcpu_notify_event,
+	.events				= 0x6,
+	.name				= "bpf_pvsched_ops",
+};
-- 
2.40.1


