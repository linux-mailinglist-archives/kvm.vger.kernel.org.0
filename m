Return-Path: <kvm+bounces-26372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE0C9745A6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A19A286E4A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6431B29D8;
	Tue, 10 Sep 2024 22:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hZ6o7hvP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A041B29C1
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006624; cv=none; b=Q3XJ0jpZMCmakdDooc2Glk+U6HWJLBNC3xkfxkOrgNQV5fc+p2FZo4qKXvh06cV5eBcL4koWdUU405iqOrJerlEUVfcBnzvvp8Z4kLOkUjFtlXmuA8M3Jq3/T7lI8uLs2cc6Frr/NkviSXzCCXk1s2esnR8Ou3/rKqUSy4ML3u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006624; c=relaxed/simple;
	bh=3XPwV5dfQ8tYmIvWh071uuZZZ93mupregg6Mns04HnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QfvCBqfh22H5IfLVmx7c1d/F2qAfNT2zJgRb07KC9q0HqAuzX2jdOWiSDIWt6/mFg4z4G8pdQyX2LDMlhqPAIooMjJSSvzJBWazWkuphK5NcI0YvJdPyJ5gXUg82Dejys++rBrDdrnKQtsrvUaBBp7kYlbNC3LkA2NVoc5wjOW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hZ6o7hvP; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-718e6299191so2047157b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006623; x=1726611423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7oh25CxvFbaGetIeF8ZGKIaTcgg654mKr0Hk3ECIvo8=;
        b=hZ6o7hvPsqCh73kRmi9bUx84Lm0jQ548V3FIYU/VbrEy+UNBfwnQPcgwo1vC1j3nzu
         lQRKzHMb5VtGssywViOexb3P2oCOliu39SvptykF6LyIQAfDIc0eM3wLHKYbggHcVUXL
         U1J0stYlA1NHJRXOE/uPZy5etCmNRJTCtQvC5sj1lEbjzl73Jju0oTxMvQdMIL7iXEIV
         bAIOxKw/MMKUtwF0QLDDfZWwpQP4APm7AfEvK0AviEYIUkUi4DC9URd3q2yOadMLgv6i
         TvJAnxvj3NFa3ekFWcE66KRzPFulP97NTDKKNf9/OfKuKbIuq+wUWR3WPXKRrombs4xk
         Z+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006623; x=1726611423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7oh25CxvFbaGetIeF8ZGKIaTcgg654mKr0Hk3ECIvo8=;
        b=DEES3K7jmjE/naWSIJ5C+rhVpFfO7krSjJ+lE/3yNYOvRrCPhCUi/5Gent2Xo4yTyT
         6MCAEe7bqjIjLHaFcNn2sSPWRKNkfh9h7hc8EfxsTDXi2GRh1P7xl/e5oQ0AQArm4ThU
         CUmsbToIiCzCITVVjcQrXyPjN7VsVlfHbTAcofYTp4CNCfXdsDwhQEDdTWUZA8j6SEkN
         QiI2nKcl/G2IzThVisHtsBISZ3iS5fKrGmn+cvKzHjyrcbGvy3iuxJ/T1UK8ASYBIKTr
         MtfBw5F4dJ8R3Mh2xCc341BHx3DTyBYIEIpxEvOOoYjg4ecMgyM0Yp08HlT1DmSyL4W9
         sN2w==
X-Forwarded-Encrypted: i=1; AJvYcCU3aipaFgYgbdm6K6raIrj07I3dfe4xGMzrCNiix5uNMf6Wa/UdUnveM1jni0QsZCM2z4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbTmWzRuE4hXs7wRkenIWGag77kgvpgPfrLjSu5AWh4xl+eX8e
	T5izJPfOoLeOZh4D8K6BfkJtllXWrQ5DLAbOMtyRWp7ZdYb2FQfzxQtem1bFEWs=
X-Google-Smtp-Source: AGHT+IENKO5MwL+nWqP2QL7ZggohAMhCWhPKSiwX+PHvrBh02mVemU/5A9wLas0m1Pzm50xYKxp9XA==
X-Received: by 2002:a05:6a00:66e1:b0:714:3acb:9d4b with SMTP id d2e1a72fcca58-718d5ee03c7mr14772194b3a.18.1726006622546;
        Tue, 10 Sep 2024 15:17:02 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:02 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 22/39] target/i386/kvm: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:49 -0700
Message-Id: <20240910221606.1817478-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/i386/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2fa88ef1e37..308b0e1cb37 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5770,7 +5770,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
@@ -5789,7 +5789,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
         }
     }
 
-    assert(false);
+    g_assert_not_reached();
 }
 
 static bool has_sgx_provisioning;
-- 
2.39.2


