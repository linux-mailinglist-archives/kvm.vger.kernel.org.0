Return-Path: <kvm+bounces-59412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64117BB3581
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55A36543587
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A3E3128DA;
	Thu,  2 Oct 2025 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u3Sw21oQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937B2E7F39
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394576; cv=none; b=tzU6q3zvpN3d7ySJzDy+SX8RosmcEo4RT4B/o5tJEdPNczKSr6vXRF1D5pnzzZuvby3/AvgBT9GogaEN1Q8NPxHH9egmU0VfGVYho9PykU+03yu0a7EgFmKkC7YdExyOOfPRaz7X+h/7xenHsaPj2aSlWVydoAk2dG+uEFjl6LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394576; c=relaxed/simple;
	bh=v0/zwHCroxq67v/8AxVX0b/I+r1zpBufpo9znEIU9Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n9yGOn15HFRcqLbFrtUPWo0NFbJbBD2rITuh7K68JP2w6wGJrEjxVocxR7tnm+jgIcfVmFRpo6vD5FU4ZES14j8QdaV1358Z3zsiK1JzZEoqc8qXvYSlvWOciedCZrhgelba3WViCyQqSZk3Vb7HKNmqScb6r2HOj/fKW+4Djg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u3Sw21oQ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f0134ccc0cso414446f8f.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394573; x=1759999373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2a+b3m6nNjsik0uExia3oDVD3UfHkSBuHgsktxpBbI=;
        b=u3Sw21oQqPXnlLIsL/8dXcveFZgI/Z5MfMtoyPWvsNzCD2Vr08aMUFGmfVj2gUa8Y6
         zaIT7gmD9EUhZV7Bra+1VCnjo6yzQD9YBLuxHOgLo8B0H9sKg2S+qeNO/+HC+tx8Z4bj
         3UBz6UaU2OJmushuwB12TJs+n/kxQ+RXCgaVy+274HrHM9QL9Et6oUQ6OaJHGBVsnwFC
         in66f660dKJxAYZ8lbzUVuWOAhuZVQE9ueFZtm1B9V3fXuw6b0mDVoXbdjtsCpA7nKCJ
         YF2AAC4hgLugIqwRIS2DkeOLJEth/akwaR28FMCmZAqjxVoQfkD2DR1+7QqDVBKeMRIi
         y4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394573; x=1759999373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2a+b3m6nNjsik0uExia3oDVD3UfHkSBuHgsktxpBbI=;
        b=oVNBB1P6YsFMkpcm5UMSjG9al+iHetrnj4VMEPs/lakFTb7AMsWx5rI3Mt2sAg3sUb
         2wszjXqmPjiEZkH1tzcdXN2ocIz2qjUZzv7i/icnMiE7qSi6sUWOu3QmC7aCinuLV5CU
         tZ7yoncbclw0HTJ9P92ZilZwhtisO8/23erIGhwTXnddmcD05niaRhuHl/kkg9OufKM5
         5QH1kfHykF1QzpdE7lq1NqAgy7nK+O5+fOSqcMdOvPtTNWCrz+lguFjCVYyiV80E+zc0
         Cqu/WfynGPngcb2p/j0V31jDrtscrYe89nRvgYyDRGr/4Mve9kbObIiIW1N7mpgx7X0a
         5DDA==
X-Forwarded-Encrypted: i=1; AJvYcCXrR7PVpk9YnoQ44nnGAz+s5TlXgXHyr15GjJaN3rE1exrJf1eWTIgn6uzzkeCu+Bv4CQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVrNGceAwP398xTDi5B7OAwpR+o036Lrt0e58DjWQGLiyjb8hk
	sQCKRmlpDfRYrRoEABToqmJWz7tgsXH9Pf9YZT6lWGpOicIii7WR8tPfBK1emKmA0nA=
X-Gm-Gg: ASbGncupeVA7dbbywN8vC/t+7e+DMouoVEVD9MvCJuOYD6RhVjFvZ4EUGlmWBmdZmDo
	ludGUZyxBrp5aXnd2mTdctOZ9RKeLn0Eb6istMNA3KZu+5AJFS6/Q9zZqDIT/Viqe1TWa16Pn8G
	bIBqw66WDdOBFBfjwflB4lC+apMve84YdoEpeyc/L1UXQferI/MGCB8RbhFolnToDmJmAVJVDAm
	s+5pyx9/PuL0QCY07IepqYLU/blO6MW0w3XcAVdEWqF0NszmHqsJVdrVTHgFjdzDN6mymTgMaFn
	n/xso/wdrK6CXV8zFMtCmjHVApEjB2vReYyWip9GwuQY9L3+9KFJUEvI4dJP9dsZEGYGhNC2Qel
	FZqaGYtoLP331L9FFckQF72NOSjzGn5us79VTOz/ZyugdNK6zNMta1UU/SvmW7s2NC7t2uy7ntq
	cpzJj3fprvyChp8AP43fMw5+Uu+AZAYQ==
X-Google-Smtp-Source: AGHT+IESawsv8TF9fv7ok0vuTUFPZED2UOH0cc0J9xvSMsVxP3h1RuI1snQ8dRbG23dqFBECTN2WSg==
X-Received: by 2002:a05:6000:288a:b0:3fb:ddb3:f121 with SMTP id ffacd0b85a97d-425578191afmr4750845f8f.45.1759394573033;
        Thu, 02 Oct 2025 01:42:53 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4ccesm2549112f8f.59.2025.10.02.01.42.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:52 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 10/17] target/i386/kvm: Replace legacy cpu_physical_memory_rw() call
Date: Thu,  2 Oct 2025 10:41:55 +0200
Message-ID: <20251002084203.63899-11-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Get the vCPU address space and convert the legacy
cpu_physical_memory_rw() by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/kvm/xen-emu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 284c5ef6f68..52de0198343 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -21,6 +21,7 @@
 #include "system/address-spaces.h"
 #include "xen-emu.h"
 #include "trace.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 
 #include "hw/pci/msi.h"
@@ -75,6 +76,7 @@ static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
 static int kvm_gva_rw(CPUState *cs, uint64_t gva, void *_buf, size_t sz,
                       bool is_write)
 {
+    AddressSpace *as = cpu_addressspace(cs, MEMTXATTRS_UNSPECIFIED);
     uint8_t *buf = (uint8_t *)_buf;
     uint64_t gpa;
     size_t len;
@@ -87,7 +89,7 @@ static int kvm_gva_rw(CPUState *cs, uint64_t gva, void *_buf, size_t sz,
             len = sz;
         }
 
-        cpu_physical_memory_rw(gpa, buf, len, is_write);
+        address_space_rw(as, gpa, MEMTXATTRS_UNSPECIFIED, buf, len, is_write);
 
         buf += len;
         sz -= len;
-- 
2.51.0


