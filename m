Return-Path: <kvm+bounces-36450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 534E0A1AD71
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 046E23A41EC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087391D63FA;
	Thu, 23 Jan 2025 23:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HADvKWue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CBD1D356E
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675928; cv=none; b=iEAtWtSJ5j8e/BDR18tMahxrbZUlLDJburux4Pkkvd0juVhDwZlGyMtgDuiIy08xdznWTsdabTIZEDe39r14PAojlDwJq6x5LHdreYHiaQ2/8Z0bbiLJX4FNZfmtTYAoco1vseWfU2zDO0ysdV+pMC+clsSyzdYG0sQh2WEPV3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675928; c=relaxed/simple;
	bh=O//wGbDAj0zhzP0KpRtF1Gd7nMmSH81vAKE65V5ueJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXDCcM8R0WMY7Vn+YkmUDNPgIracWt6LRRI29wIuSrGAKhXqRwU+yNctRN2CqF9a5Ko1CFKeWIOPu2eVmlbtPM3qjoeCKPejwKjQRMJwFWpqFwjMU+YG4dpO8OlkeRk5aIaqfHnLtMz0VuVAMPVwikNDsTLG36l9UNFYTo83xOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HADvKWue; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43634b570c1so10895935e9.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675924; x=1738280724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MdlpzTogAHHu3L1/GbHJ1cNEJlm92RpTH1AYDuj/6CU=;
        b=HADvKWueOmViq/oN3yzRexSfQ0Um2Q0uV40o8eJG2idgLSZ7jrDQ4dbdOipqNwpbjO
         KTpFa7LB77zzHSFVRfAdpYRFTS6fbR4Gkh1HhTwcRIQdSgVAnMmCg0sEShkxF7IB8NQg
         1HC7hSGq1GjJSTbvSCGpu0Hif+/83kv1AKEzk0WvSJP8ueGUfZISSsUUBQILN6CVR8li
         F8Lma3lOJFdWnQ47PMEDod+oU/i87LTSuebnM/rPSYpF0aXLr8xhcQE3D+b6Avjljifu
         QgFr1IsEcRxmOPTqhw/OV3orMh9IS/T2m07/1POByu7NN7XqKQ9t/Qv6T2cFM0dXFaly
         8RZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675924; x=1738280724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MdlpzTogAHHu3L1/GbHJ1cNEJlm92RpTH1AYDuj/6CU=;
        b=aDyxUXpDEcOyDQkOh7C2gS6omLGDiML+PESoliOssrnImcMZpJz6U3Na3fW1NzrgCM
         akBgMtqZ6KOKPuDcSv9BxYuQ1El8mI+qc7Viu58vFVm9YrDpGAzszP0cacEnBA0Ru6zd
         rEsmsMAtnaBi94ebxRmBp6Km8TovijejuUsT/tpWixfc8HcO8TJUHP8XGyLfH6xQRX6V
         1WJ08uZ7X35I8gpVoHCJy0rxESZPQXi7UJVVtUjVhjFg7Nl7RtIpxDLf+N5HLpbFuu6R
         EmyKAE+0tHS2uxjASN3Azq/maIFDs3M2c0k4YaZbb1mzodYwbT4QuBntcgm3031vh/ht
         RBFw==
X-Forwarded-Encrypted: i=1; AJvYcCWw2tYxJCJnDHLixpuO4KEWJZh0kGCc3YhEa/y7EAUGp7KTwTupFLMz08BhdM6J38ysDjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwixH9gtf9NzEbFG/Sb29ZAW1q0/hDcs02HFnJ12VbJtZB5iKsq
	NHq8UXh8EIEPvBnzojTtYI6pn92Qpj1ecvFm6Iqd6Jf/td5XckQDMZsb24EReyA=
X-Gm-Gg: ASbGnctceoV2AVMCOZwugPie/GGGpE8vvp9rIQlIio7sIS3l5hH0g9MDH9x2qYZP2RR
	n64Cid5arfKTzVI6FJ1evSoF1Dvi/zE1odxo7Xk2w53Kjsyxc0bsv2++lrgpM4Es54TPw8EnZve
	iuB4yztHTHf2aXOZ3nIBTAyypUfD8600eNYU3MtpeNSy1kggTQuo/CLQZgdqt+2+xrjlWkv2070
	o/GoftZx8iatZMBMIwwe/qvbGTenlo1HuEs0lSXl1GC7lJk6fY01WtDwOUxvebw5/3BJWFKo/lQ
	0jx1Mair2yIzf8x/0QMxO/rVIhhkfSVs24hzvtRFy+oQ29sYDE/yUK8=
X-Google-Smtp-Source: AGHT+IEwKoXpxcAtZxGgBrKoty0PAI7DEzj3vUSJHkmHg5BnQeEwYri/vD7fXqCVh16ykXZTkiP5lQ==
X-Received: by 2002:a05:600c:1987:b0:436:faf1:9da with SMTP id 5b1f17b1804b1-438913c68ebmr255744445e9.2.1737675924510;
        Thu, 23 Jan 2025 15:45:24 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4fa416sm6932195e9.6.2025.01.23.15.45.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:24 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 12/20] accel/accel-cpu-target.h: Include missing 'cpu.h' header
Date: Fri, 24 Jan 2025 00:44:06 +0100
Message-ID: <20250123234415.59850-13-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CPU_RESOLVING_TYPE is declared per target in "cpu.h". Include
it (along with "qom/object.h") to avoid when moving code around:

  include/accel/accel-cpu-target.h:26:50: error: expected ')'
     26 | DECLARE_CLASS_CHECKERS(AccelCPUClass, ACCEL_CPU, TYPE_ACCEL_CPU)
        |                                                  ^
  include/accel/accel-cpu-target.h:23:33: note: expanded from macro 'TYPE_ACCEL_CPU'
     23 | #define TYPE_ACCEL_CPU "accel-" CPU_RESOLVING_TYPE
        |                                 ^
  include/accel/accel-cpu-target.h:26:1: note: to match this '('
     26 | DECLARE_CLASS_CHECKERS(AccelCPUClass, ACCEL_CPU, TYPE_ACCEL_CPU)
        | ^
  include/qom/object.h:196:14: note: expanded from macro 'DECLARE_CLASS_CHECKERS'
    196 |     { return OBJECT_GET_CLASS(ClassType, obj, TYPENAME); } \
        |              ^
  include/qom/object.h:558:5: note: expanded from macro 'OBJECT_GET_CLASS'
    558 |     OBJECT_CLASS_CHECK(class, object_get_class(OBJECT(obj)), name)
        |     ^
  include/qom/object.h:544:74: note: expanded from macro 'OBJECT_CLASS_CHECK'
    544 |     ((class_type *)object_class_dynamic_cast_assert(OBJECT_CLASS(class), (name), \
        |                                                                          ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/accel/accel-cpu-target.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/accel/accel-cpu-target.h b/include/accel/accel-cpu-target.h
index 0a8e518600d..37dde7fae3e 100644
--- a/include/accel/accel-cpu-target.h
+++ b/include/accel/accel-cpu-target.h
@@ -20,6 +20,9 @@
  * subclasses in target/, or the accel implementation itself in accel/
  */
 
+#include "qom/object.h"
+#include "cpu.h"
+
 #define TYPE_ACCEL_CPU "accel-" CPU_RESOLVING_TYPE
 #define ACCEL_CPU_NAME(name) (name "-" TYPE_ACCEL_CPU)
 typedef struct AccelCPUClass AccelCPUClass;
-- 
2.47.1


