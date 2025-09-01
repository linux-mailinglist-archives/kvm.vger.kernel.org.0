Return-Path: <kvm+bounces-56514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA32FB3EBF8
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3D717AC6C5
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF842EC0AE;
	Mon,  1 Sep 2025 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PqzOWUo4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AD5320A22
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756743013; cv=none; b=KIl3S7WzKUjGEtN+2+x0Us2nG57yGERSiuxVJMpL9x2LF9Z5RBU4At8pwKRSZwDPYD8P6s+zN724zAvLqy0v3/Sqe1SuLzlP+DeQ6iyHD6eah4FjOUMTDzgSODl4chmoJZHw/GTY05rm58Ue04sZ9+Y4QD/pLQxGnPwttVE6KU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756743013; c=relaxed/simple;
	bh=Uo10WvJDZhKL6JBEoQLyO2D0kgnDiGHkYMbNhBPE5D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+kR7cBthhCJGsc5ZGcSLk8PspTGt7QY/V7HTG6cIfQxpVv64T/ZBIMb2o4mFLgjjWPkFp4L0y+ZATm9AeMVaRUgnaBE0owRxHr0lm8OlwGaeiAS0lpHBdF6tGsQ+r8JWaCHE0TnnQ/RKSZQJEyzwFEQj861Bn+yB/YAfKUaadc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PqzOWUo4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756743010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ay5gC/rJKyMKcqoVVau41lZbwoCz+kjLe1Ep7vUjxrI=;
	b=PqzOWUo4X0aODDz4UFRbBtZIiRm7AcsYnlHyu8kF8t5sfLXCQ73QN5Kit209UDOWu0hKXN
	ONRF20E9nARJasSL1TQ1cNNr8yx/bcPu4W4KbLi5Vb4+zQx2fpZ/VkW4tH7o02wwo1ZZcs
	u5ku7ig7J81Gjdeg9rZgoT7ASFPLGbI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-7uUvMyVcNo-uoE-Js3f3Pw-1; Mon, 01 Sep 2025 12:10:09 -0400
X-MC-Unique: 7uUvMyVcNo-uoE-Js3f3Pw-1
X-Mimecast-MFC-AGG-ID: 7uUvMyVcNo-uoE-Js3f3Pw_1756743008
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-70de52d2870so33858926d6.0
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756743008; x=1757347808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ay5gC/rJKyMKcqoVVau41lZbwoCz+kjLe1Ep7vUjxrI=;
        b=nGA+FnK5qt+t81SCnnOOB/aIvRcaDeArV+u7spy4xkCyg6KtJDj/xw8DuNRpCO7i9K
         Flr26kTS9p964ojUaA64YFD1tKYOm4Amw20pvGi+Iy3nKOA59phFCQsnFOLonwxoMh0P
         +TL71UoBhi3fBDEMtrn6TcmWzcbaGlLtNG/nTNqZ9oGgsNa8j2icKpsKR2wUIvP17WkG
         PpLzamautFrCnlDaaJWZyBiGb8aoCnufheh8YNCNfSRvWBxNPYSHxpYL5X6G8R6Rd2/1
         kvV28gn3KD15yt4LhO4hhD9Afpkr0k8+ADz/NAMtiPgi6uK+59tlLv21zlLTzbBkGmZ/
         +a/A==
X-Forwarded-Encrypted: i=1; AJvYcCXcav1ZDnE5YfFNuk4UwC9P+Bkf31UGabUZaJOL2YHv82TItPW/FNqKkLmEQ+5myNbeEx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIHZ487RvcMdG8BZps3IlBZ/15v8LQx8SsQ1R4wrx7UeH++6mr
	e3TVaHRjs4EyO1kEQjTgEpxpLYHnuGjn5FR7Hb8up//+zlGbTgsEVKvBuKwUV7ywXIwKyhxxBT5
	Fd+CP/m9A0iyEoNOp0U4qGXJWS6+FYJuki0VDJCUtwLgLBEZx18lL/w==
X-Gm-Gg: ASbGncuV+zh17mAdLzt7vPsyb7DCoCSneZVoSz6AvwswAYkZVv35Lakc4RvrHrqeaXc
	jWalexZoDq7VvB+dfZYup48kSxbL8UlUBsF/TxfqGhHqF3BCStsWlkHb4syhinzVBxzAuQRvdmF
	CvJ1ruUxg6f/ZsOpz+suOw6a5HWdvacwBDe8WWCiMznM0BwNsaMr7UZhbRKKuW8qj/46wWuL/z9
	g1qs20t/eiBXznKdw/S136IcK8uL6HtW7ghgEB14OSMUWd88a86xxBHJ2gOJsw8hleFXTdUMaAy
	5IsI4B7blhRdSJl488UFr4/8p33Uae/TN1klVgGXnxOx559Rs0nw23VhYGkSt1sKHOKyGu0BlmG
	Mh+SyTGmT7eVub5v9wc4k7Q+fobIZ1Mf8NLwGqeWCCOlT7LnSM0b75imyzTL6ujw3Zb56
X-Received: by 2002:a05:6214:5195:b0:70f:5a6d:a253 with SMTP id 6a1803df08f44-70fac8db3c8mr75708746d6.49.1756743008258;
        Mon, 01 Sep 2025 09:10:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUuYwiXfYyBhb47Z0hN01SMvdEEJPNPj4R4dXKcCWUWWe/rDi3MWAMqA91oA+pVPmIsSEo7A==
X-Received: by 2002:a05:6214:5195:b0:70f:5a6d:a253 with SMTP id 6a1803df08f44-70fac8db3c8mr75708306d6.49.1756743007561;
        Mon, 01 Sep 2025 09:10:07 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70fb283781asm42015296d6.38.2025.09.01.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:10:06 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com,
	x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	kai.huang@intel.com,
	seanjc@google.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
Date: Mon,  1 Sep 2025 18:09:30 +0200
Message-ID: <20250901160930.1785244-8-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901160930.1785244-1-pbonzini@redhat.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

On TDX platforms, during kexec, the kernel needs to make sure there
are no dirty cachelines of TDX private memory before booting to the new
kernel to avoid silent memory corruption to the new kernel.

To do this, the kernel has a percpu boolean to indicate whether the
cache of a CPU may be in incoherent state.  During kexec, namely in
stop_this_cpu(), the kernel does WBINVD if that percpu boolean is true.
TDX turns on that percpu boolean on a CPU when the kernel does SEAMCALL,
Thus making sure the cache will be flushed during kexec.

However, kexec has a race condition that, while remaining extremely rare,
would be more likely in the presence of a relatively long operation such
as WBINVD.

In particular, the kexec-ing CPU invokes native_stop_other_cpus()
to stop all remote CPUs before booting to the new kernel.
native_stop_other_cpus() then sends a REBOOT vector IPI to remote CPUs
and waits for them to stop; if that times out, it also sends NMIs to the
still-alive CPUs and waits again for them to stop.  If the race happens,
kexec proceeds before all CPUs have processed the NMI and stopped[1],
and the system hangs.

But after tdx_disable_virtualization_cpu(), no more TDX activity
can happen on this cpu.  When kexec is enabled, flush the cache
explicitly at that point; this moves the WBINVD to an earlier stage than
stop_this_cpus(), avoiding a possibly lengthy operation at a time where
it could cause this race.

[1] https://lore.kernel.org/kvm/b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com/

Signed-off-by: Kai Huang <kai.huang@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
[Make the new function a stub for !CONFIG_KEXEC_CORE. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  6 ++++++
 arch/x86/kvm/vmx/tdx.c      | 10 ++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index c178360c1fb1..6120461bd5ff 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -228,5 +228,11 @@ static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
+#ifdef CONFIG_KEXEC_CORE
+void tdx_cpu_flush_cache_for_kexec(void);
+#else
+static inline void tdx_cpu_flush_cache_for_kexec(void) { }
+#endif
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASM_X86_TDX_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f457b2e578b2..04b6d332c1af 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -423,6 +423,16 @@ void tdx_disable_virtualization_cpu(void)
 		tdx_flush_vp(&arg);
 	}
 	local_irq_restore(flags);
+
+	/*
+	 * Flush cache now if kexec is possible: this is necessary to avoid
+	 * having dirty private memory cachelines when the new kernel boots,
+	 * but WBINVD is a relatively expensive operation and doing it during
+	 * kexec can exacerbate races in native_stop_other_cpus().  Do it
+	 * now, since this is a safe moment and there is going to be no more
+	 * TDX activity on this CPU from this point on.
+	 */
+	tdx_cpu_flush_cache_for_kexec();
 }
 
 #define TDX_SEAMCALL_RETRIES 10000
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2abf53ed59c8..330b560313af 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1872,3 +1872,22 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+#ifdef CONFIG_KEXEC_CORE
+void tdx_cpu_flush_cache_for_kexec(void)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (!this_cpu_read(cache_state_incoherent))
+		return;
+
+	/*
+	 * Private memory cachelines need to be clean at the time of
+	 * kexec.  Write them back now, as the caller promises that
+	 * there should be no more SEAMCALLs on this CPU.
+	 */
+	wbinvd();
+	this_cpu_write(cache_state_incoherent, false);
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache_for_kexec);
+#endif
-- 
2.51.0


