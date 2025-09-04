Return-Path: <kvm+bounces-56751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14315B432FB
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63653176BF9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5110D28C014;
	Thu,  4 Sep 2025 06:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1EWDlQ8D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176DB288513
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968914; cv=none; b=Gg4gdZ2A+eiTuYwVuRQGz3felBY/BSy0AIoEYBh/gAqSm/Aqx9ktg5PraXUFiur2Nk2TNv9WOt7dmtahxOiT1pJp5b2QQt1Swx3WzhyW503pNb62L/XG/IvIsGLwMJTN63+95jlAh4iFcpEIJCb5pqzlUp053hazwTYO0sgkYcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968914; c=relaxed/simple;
	bh=jTAk0VRpOVV4bc0UhlAMxjyl0WAtBQgyMPsTPcfAW2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kj5ZN049vvLMP+zAwBmcuXorpAG6PT8KidV4x0Q4QJYTMVAAP7uuE/MK8sGG/66xXc6zyewb0NMVoqfBooJwpkgYsvqwkp4DQXDb9z5mqw2HM7Q9jXDoTOuLWePLgQbIkAjEMfEmJHsW2qU7rDgQg7e2mbhG9YmBpAUUheksIsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1EWDlQ8D; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329d88c126cso614600a91.2
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968912; x=1757573712; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2BNUyviqUil8XBJbXZDuQ3pKbq0VlqMJJavKpGuaG4I=;
        b=1EWDlQ8DXnJpXX/L0K3Yobmk5UDc0JDWkin9dR8nha6JkLYuohLW+vT1v3qRZyMUNu
         4Z2jkJQEGdHUsmPTG6E2W577bPvnDFbsYOnBPGncumnHRSKpEg6IlNp8nA2jxBzKkCcQ
         7ZhaL3ly0abhZgpiQfgTFZRwocaX39b2UD5iOjIDCf139R87Iq8HPdcv6QhAg6ZGzlDq
         Lg0ZU83dFU4he3Jq4GiTe/VmAsfFVG7YE+ocVRok2wnnGALThqEYBMwD7CXvLE11Z2sz
         maEja5ANyXbFjmi6q/FvdRN0K1mxE5FbI6rQcbEaVneeKXoHGqkEuXC8+C1rs+TiBXAX
         jXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968912; x=1757573712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2BNUyviqUil8XBJbXZDuQ3pKbq0VlqMJJavKpGuaG4I=;
        b=YgJ43Iw+VMB9eAeaYXwBuha0PUlxlp369HSUvFnOZo6zkG5PfxlhU8+KYuIWwl+xjP
         fMHUJnSDfAr9GGjjGQtsm0m8k23D1k5QSEUXVhJxEFosX6AIQc7phHmybqRc2NkOM8ra
         VGdNiNxvTCgZ9AOQEAvXvmxC7GUcHoV/VNY3EkYYp/CAD/VPgpzWWybVh0lSc53hIcRm
         rjgEt8ILAq4mWoPA3PEvHlkcMde2wqglaIfwB1v3rJndH2MaKKgwT+0d6yLl2tphl+FI
         FcUXbsrsrxW04y2k9vO/vEh9Ok2u0EY73SuIq6QWVb6ZhXXFpaQ15zyyaCAiGbCWTH3H
         AB6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvff9WjHKA3hLy9/Q6y6V7/hiCUegyHXmfEFkUSr7GpIHT9C4Bet/2OO6TJem6bn7Bgpg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7/GzAUh17RsRiVUKMUPzaK1ckDTyLPcK5WMguTzBn7cqX8eFq
	73RxxVo8vd5d8YOH7o7febi77XzsdvqCu+SHeshu7QIeLI0BPleJmsuGXtumG4RIPr2tYxkywrR
	ZKA==
X-Google-Smtp-Source: AGHT+IH5hLY38bpfnaQsbJuP8cpIl0UsXd1oicIeqNFK0OMpEiH24w+v7AklRI93GhnSPuMBYNIePkxKxQ==
X-Received: from plblm13.prod.google.com ([2002:a17:903:298d:b0:248:9b66:3356])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:28c:b0:248:811e:f873
 with SMTP id d9443c01a7336-24944ab8f4bmr241345565ad.36.1756968912276; Wed, 03
 Sep 2025 23:55:12 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:36 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-7-sagis@google.com>
Subject: [PATCH v10 06/21] KVM: selftests: Add kbuild definitons
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add kbuild.h that can be used by files under tools/

Definitions are taken from the original definitions at
include/linux/kbuild.h

This is needed to expose values from c code to assembly code.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/include/linux/kbuild.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 tools/include/linux/kbuild.h

diff --git a/tools/include/linux/kbuild.h b/tools/include/linux/kbuild.h
new file mode 100644
index 000000000000..62e20ba9380e
--- /dev/null
+++ b/tools/include/linux/kbuild.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX_KBUILD_H
+#define __TOOLS_LINUX_KBUILD_H
+
+#include <stddef.h>
+
+#define DEFINE(sym, val) \
+	asm volatile("\n.ascii \"->" #sym " %0 " #val "\"" : : "i" (val))
+
+#define BLANK() asm volatile("\n.ascii \"->\"" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem))
+
+#define COMMENT(x) \
+	asm volatile("\n.ascii \"->#" x "\"")
+
+#endif /* __TOOLS_LINUX_KBUILD_H */
-- 
2.51.0.338.gd7d06c2dae-goog


