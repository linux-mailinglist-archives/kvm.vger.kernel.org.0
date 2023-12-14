Return-Path: <kvm+bounces-4417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD44812573
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02F161F21A99
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9A017F0;
	Thu, 14 Dec 2023 02:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="pyaRSrZE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ECA100
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:36 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-77f8dd477fcso118107085a.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522055; x=1703126855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIavbINZh5nYTp8Oo+UkDFK4yofTsKFYo/9aAWUfbh4=;
        b=pyaRSrZE9bUbL1v6wRSTh/KrGJhVI/H81tqlpUnSBayz57AhzMTxw5v7ZKAw2Qrbm4
         8/1K/8T10ZhhTHu4BcZqfttWcaylyFiHInRdINWJtnoaBoJDQW0DWkk8qS4enaJO5zZ3
         xrGMo4CskepCFD/mNh7c+6AZ961di3QTiuzBnAB41nTbCqr1sRfcXuNjYaMoK9t0VRd4
         JGq6CI6L7jmAIxKhMYJBFHL+Q/2lz2pKlI0tcAwsV+ds+HHJeo6EAjPxVaiIGp5F1+P9
         v5ONl1fej1S+bJWAAy84U2xfxD67IVTP+PHXvWufjaPiVLiEl+sCgzVANIX/MCs+vE1r
         Qj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522055; x=1703126855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIavbINZh5nYTp8Oo+UkDFK4yofTsKFYo/9aAWUfbh4=;
        b=R2cQuMytvWRxdBlUl64t+WqDNMjU7eHbgUGkQZg+EUllsKMW67qo0q2OJsH8aM0Eeq
         NMADdl9bZKYOELih02k698HPLGn2EYRdxfokNJ4/z16BNA7Mfy4Es32NHe1q75vhqMBd
         TzsOOYSYc0mGuQR65Q24N5g7Vi+RwHTwIdDNV86jKJ5bf4s1KnddNy6A9do5gCep5i95
         1BavwJNJzKF2j7EmJYuEZECfeFuF9YSYX1fsPGfNVsih8gYgsRo6WvXuU/SRYrqBqkMZ
         FDrwGrtSFC3xDzT0f4YEFtSaASuwOloIEpLeLSD92f/oUlJlrIldm2d2uh6TlMDFsVPv
         hG7A==
X-Gm-Message-State: AOJu0YyV9U3JP87JbKwgzwxA+BVaNgS2znZ7DPJgHWzyykZKIpB05O6j
	ekobphZcevOGyG5c43KIK+1H7Q==
X-Google-Smtp-Source: AGHT+IH6u1GHrME2lBmJJpVZSxUPVZ6fOdoMo5fRDVqA+ScERzhBmZ8B0kv7EEMH2wDjJzf7yiNE+g==
X-Received: by 2002:a05:622a:8d:b0:425:4043:29fc with SMTP id o13-20020a05622a008d00b00425404329fcmr12342292qtw.119.1702522055644;
        Wed, 13 Dec 2023 18:47:35 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:35 -0800 (PST)
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
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 2/8] sched/core: sched_setscheduler_pi_nocheck for interrupt context usage
Date: Wed, 13 Dec 2023 21:47:19 -0500
Message-ID: <20231214024727.3503870-3-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__sched_setscheduler takes an argument 'pi' so as to allow its usage in
interrupt context when PI is not used. But this is not exported and
cannot be used outside of scheduler code. sched_setscheduler_nocheck is
exported but it doesn't allow that flexibility.

Introduce sched_setscheduler_pi_nocheck to allow for the flexibility to
call from interrupt context

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 609bde814cb0..de7382f149cf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1908,6 +1908,8 @@ extern int idle_cpu(int cpu);
 extern int available_idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sched_param *);
+extern int sched_setscheduler_pi_nocheck(struct task_struct *p, int policy,
+		const struct sched_param *sp, bool pi);
 extern void sched_set_fifo(struct task_struct *p);
 extern void sched_set_fifo_low(struct task_struct *p);
 extern void sched_set_normal(struct task_struct *p, int nice);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8f73ff12126..b47f72b6595f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7850,8 +7850,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	return retval;
 }
 
-static int _sched_setscheduler(struct task_struct *p, int policy,
-			       const struct sched_param *param, bool check)
+static int _sched_setscheduler_pi(struct task_struct *p, int policy,
+			       const struct sched_param *param, bool check, bool pi)
 {
 	struct sched_attr attr = {
 		.sched_policy   = policy,
@@ -7866,8 +7866,15 @@ static int _sched_setscheduler(struct task_struct *p, int policy,
 		attr.sched_policy = policy;
 	}
 
-	return __sched_setscheduler(p, &attr, check, true);
+	return __sched_setscheduler(p, &attr, check, pi);
+}
+
+static inline int _sched_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *param, bool check)
+{
+	return _sched_setscheduler_pi(p, policy, param, check, true);
 }
+
 /**
  * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
  * @p: the task in question.
@@ -7916,6 +7923,27 @@ int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 	return _sched_setscheduler(p, policy, param, false);
 }
 
+/**
+ * sched_setscheduler_pi_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
+ * @p: the task in question.
+ * @policy: new policy.
+ * @param: structure containing the new RT priority.
+ * @pi: boolean flag stating if pi validation needs to be performed.
+ *
+ * A flexible version of sched_setcheduler_nocheck which allows for specifying
+ * whether PI context validation needs to be done or not. set_scheduler_nocheck
+ * is not allowed in interrupt context as it assumes that PI is used.
+ * This function allows interrupt context call by specifying pi = false.
+ *
+ * Return: 0 on success. An error code otherwise.
+ */
+int sched_setscheduler_pi_nocheck(struct task_struct *p, int policy,
+			       const struct sched_param *param, bool pi)
+{
+	return _sched_setscheduler_pi(p, policy, param, false, pi);
+}
+EXPORT_SYMBOL_GPL(sched_setscheduler_pi_nocheck);
+
 /*
  * SCHED_FIFO is a broken scheduler model; that is, it is fundamentally
  * incapable of resource management, which is the one thing an OS really should
-- 
2.43.0


