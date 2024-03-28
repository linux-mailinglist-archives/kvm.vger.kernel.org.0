Return-Path: <kvm+bounces-13030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4CA890709
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 18:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AC441C28E5C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 17:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210B83D55B;
	Thu, 28 Mar 2024 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWMuD8rk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF79E80BF0
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711646408; cv=none; b=HYebumdsAbBO4KODVwCdoBTCKZSpSvl6OI1v3KWmpeSCLR6oJJnyKw0ATf9hD5sns9W+3lj/8Z7qr3ZJSl1H5164mCQDl3jknwOInWhLQoYPMwYicq/Nti+kALV0PLNn1vrJcInezrzutDtpy7xyb7cdefcwVkXNdwn9DoGYCVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711646408; c=relaxed/simple;
	bh=5nG12px40b95OiupwSpL661ZIzoB74o9DKh2Yxu7VGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqTEieWWNDM/cI9ZptCZYtJD9wJQzSfvUfTkMpf8etkbrHwq6UDQHe5M8hs227GAn63gZCYoEaopY9O2lx3iWs1NY0V9QJueYNolSVrM9/Z/bWwn+M1faHcmeiApyU1qRNih0QrIZUTd4jF0TzTY3lqo8U9BTNFdqrUjZqCfeLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWMuD8rk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711646406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NlDC3S558v4nqZXrURYnNQqnqNZ8k/Xoba+HwgD1low=;
	b=PWMuD8rkq8W/Byu8Uyyu4wMXEuNv71muovk5EwbD9ZKrPm8DAQaNwr41FWCoNd4R+RH0p3
	g/fMV5P8sgrfWD1hbe4Sd/8Q8AOTWuNwTXjJqTUdnCOu1nLjcxRkY+uz7ExpeOirlb9RNT
	wBx/VisB7k9PWgAV+zc/2otZE7/wb1k=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-rDgbDAV-MmOnEezqVLOvyQ-1; Thu, 28 Mar 2024 13:20:04 -0400
X-MC-Unique: rDgbDAV-MmOnEezqVLOvyQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-69680a9fe29so9890226d6.1
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 10:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711646404; x=1712251204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NlDC3S558v4nqZXrURYnNQqnqNZ8k/Xoba+HwgD1low=;
        b=MfUq5DpsC01NYGvh99wSYedUVgicOxsESifR4m5+DCFoJaj9ww9iUDKErnr1OgSB6H
         q33XyLHyOicLCA2AjMy8YS1NePXZmehp7BroD0Rdwn+UawX7nIEteuu8JYOzAjtzajh2
         n8HmXqnMkicJnr3/R5i7Fvxe6ze7ywIMoxfLMBZ2JZ2llUvRCOri0zI5GHwopme8wcay
         ora72sEB3S1/FyvdQ10A1ae1k7sW8cIsyknyhTc5EsqbbEd2O4sLu8DKpmiKcq6nK495
         vKvZozIwzPDn3P1wkOGuE6ECLCqy9JJBJhvB1yxTNgibZ2wCOb5sGn04F7sBfRekDNOK
         bVSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjWFYcd8bVLgKN15kNCtjjSWYnBE4mQnLtBtCqyqOTlgw3I3VUmWn/y6YifmcjY/HLMaUG3kZc7JkoqowBigvbfoV/
X-Gm-Message-State: AOJu0Yx9jxx1UXLAfUO6jupdvAuwrDn3zFm26n8/ZswveKM4rMf28XqY
	OJU/TsntCiQf/QBftpgicbaOT0YU93F/URWghrfLIBJojSEsxEKKtZroHjHvTWKiJaQaNLqBBNY
	eOSHt5v/NEt3U/BISvWgFZl//h+a2Fgm0+7QEr0bTJnXYyo0QJw==
X-Received: by 2002:a05:6214:500a:b0:698:7ab0:eb15 with SMTP id jo10-20020a056214500a00b006987ab0eb15mr2054237qvb.46.1711646403994;
        Thu, 28 Mar 2024 10:20:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmeHJjJWBC27/ap5AWRtSmt7CBRCbfvjktUlnWlqC/t2lVabfEtbBhByfRUEWDgZkb7PIurw==
X-Received: by 2002:a05:6214:500a:b0:698:7ab0:eb15 with SMTP id jo10-20020a056214500a00b006987ab0eb15mr2054204qvb.46.1711646403682;
        Thu, 28 Mar 2024 10:20:03 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a801:d7ed:4b57:3fcd:d5e6:a613])
        by smtp.gmail.com with ESMTPSA id m13-20020ad45dcd000000b00696944e3ce6sm809078qvh.74.2024.03.28.10.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 10:20:03 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: [RFC PATCH v1 1/2] kvm: Implement guest_exit_last_time()
Date: Thu, 28 Mar 2024 14:19:46 -0300
Message-ID: <20240328171949.743211-2-leobras@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328171949.743211-1-leobras@redhat.com>
References: <20240328171949.743211-1-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep track of the last time a cpu ran guest_exit(), and provide a helper to
make this information available to other files.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 include/linux/kvm_host.h | 13 +++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..be90d83d631a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -470,31 +470,44 @@ static __always_inline void guest_state_enter_irqoff(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	guest_context_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 
+DECLARE_PER_CPU(unsigned long, kvm_last_guest_exit);
+
+/*
+ * Returns time (jiffies) for the last guest exit in current cpu
+ */
+static inline unsigned long guest_exit_last_time(void)
+{
+	return this_cpu_read(kvm_last_guest_exit);
+}
+
 /*
  * Exit guest context and exit an RCU extended quiescent state.
  *
  * Between guest_context_enter_irqoff() and guest_context_exit_irqoff() it is
  * unsafe to use any code which may directly or indirectly use RCU, tracing
  * (including IRQ flag tracing), or lockdep. All code in this period must be
  * non-instrumentable.
  */
 static __always_inline void guest_context_exit_irqoff(void)
 {
 	context_tracking_guest_exit();
+
+	/* Keeps track of last guest exit */
+	this_cpu_write(kvm_last_guest_exit, jiffies);
 }
 
 /*
  * Stop accounting time towards a guest.
  * Must be called after exiting guest context.
  */
 static __always_inline void guest_timing_exit_irqoff(void)
 {
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb49c2a60200..732b1ab43ac9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -103,20 +103,23 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
  */
 
 DEFINE_MUTEX(kvm_lock);
 LIST_HEAD(vm_list);
 
 static struct kmem_cache *kvm_vcpu_cache;
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
 
+DEFINE_PER_CPU(unsigned long, kvm_last_guest_exit);
+EXPORT_SYMBOL_GPL(kvm_last_guest_exit);
+
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static const struct file_operations stat_fops_per_vm;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
 static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
 				  unsigned long arg);
-- 
2.44.0


