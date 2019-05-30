Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78A2FAEA
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 13:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfE3L2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 07:28:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52679 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfE3L2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 07:28:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so3739755wmm.2;
        Thu, 30 May 2019 04:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SX81W3B+rOFD9q++bpOTVE7YZYqatJqgvbGp4A8Bpd4=;
        b=qtfA2WUU97N7gZfyk7DWfoQPdw8Kpd87wEcrAaWdIVYQ5JZ/5X78DZYI7MJRxT8L7N
         0Up3Ksnc/XWVO+nKcLk3vR2sxLNo+cp9Fzw0/sH+pOnwjfsNa6QNvbJWpAw3/ICY/K4q
         J9/fH2X4mA59nLQp6NYv81p0QcLuViSBUtCcyiuvO+8MjNvSuXywaGxjtruYXYneLg5z
         0QPmkteRQ3NUVrLqtRUz0epkgEQBJQ3muJ9rV2oLbucSppFNwA1LAtFV323HFCDLzwd5
         Ul0rlQLkjagDorhpJRKxGhdnnH2ITXaIXqR4jClV+NStLbhqT2HDMeVSVho4UKvSy7we
         R8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SX81W3B+rOFD9q++bpOTVE7YZYqatJqgvbGp4A8Bpd4=;
        b=OLia7Aj3GSuUGs2F4nylQ/O8wSGm0sXhlUCwG0JshPCgkUF+fMk+VvJp3Q6l7BlAr7
         8mxvpOYj/Hm7c2lAKY/yWhxJnzWjfDvF9xlrvsC0QiQ/3wOOEzfHYgt4cYSmUpJ9rO9T
         mo2HOmc8fvqhrdPpFugdFdMuIXUEZzK8xwI5a9PsV8AZFdeGCi4moaF7f6QPupis4CZi
         82NDr5JI/Y8pJpZvF0OKD4rqqGHi4NQw8XeeZ49RZVC4CGdva9/T9idRvvXPRnu+/5sm
         I1SbEftcUvSbOq5Rk+5TG6wgyydDbHYVcXECsLfybhAaakFWu7XPPBNaO6o1N3RCm8po
         7o2g==
X-Gm-Message-State: APjAAAUmJwq2OWCnoNWXPImEoHpH6JaSPXYnncPw7E6FjZ2U+OXk4qU9
        ZyaNSjjzeJCJtBC+f5Zi5PAQ2KV6
X-Google-Smtp-Source: APXvYqwuawoqoaxsaAi5dfLXs/kRgdB7egTSB3YbtyStW8FUYG8b0Z7tqygOGZGRB8BZjVD9A/viEg==
X-Received: by 2002:a05:600c:2187:: with SMTP id e7mr1972772wme.16.1559215694070;
        Thu, 30 May 2019 04:28:14 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:f91e:ffe0:9205:3b26])
        by smtp.gmail.com with ESMTPSA id o14sm2601855wrp.77.2019.05.30.04.28.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 04:28:13 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
Subject: [PATCH 1/2] scsi_host: add support for request batching
Date:   Thu, 30 May 2019 13:28:10 +0200
Message-Id: <20190530112811.3066-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530112811.3066-1-pbonzini@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a list of requests to be issued, with the LLD only writing
the hardware doorbell when necessary, after the last request was prepared.
This is more efficient if we have lists of requests to issue, particularly
on virtualized hardware, where writing the doorbell is more expensive than
on real hardware.

The use case for this is plugged IO, where blk-mq flushes a batch of
requests all at once.

The API is the same as for blk-mq, just with blk-mq concepts tweaked to
fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
extracted from the hctx and passed as a parameter.

The only complication is that blk-mq uses different plugging heuristics
depending on whether commit_rqs is present or not.  So we have two
different sets of blk_mq_ops and pick one depending on whether the
scsi_host template uses commit_rqs or not.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_lib.c  | 37 ++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_cmnd.h |  1 +
 include/scsi/scsi_host.h | 16 ++++++++++++++--
 3 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 601b9f1de267..eb4e67d02bfe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1673,10 +1673,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		blk_mq_start_request(req);
 	}
 
+	cmd->flags &= SCMD_PRESERVED_FLAGS;
 	if (sdev->simple_tags)
 		cmd->flags |= SCMD_TAGGED;
-	else
-		cmd->flags &= ~SCMD_TAGGED;
+	if (bd->last)
+		cmd->flags |= SCMD_LAST;
 
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
@@ -1807,10 +1808,37 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
+static const struct blk_mq_ops scsi_mq_ops_no_commit = {
+	.get_budget	= scsi_mq_get_budget,
+	.put_budget	= scsi_mq_put_budget,
+	.queue_rq	= scsi_queue_rq,
+	.complete	= scsi_softirq_done,
+	.timeout	= scsi_timeout,
+#ifdef CONFIG_BLK_DEBUG_FS
+	.show_rq	= scsi_show_rq,
+#endif
+	.init_request	= scsi_mq_init_request,
+	.exit_request	= scsi_mq_exit_request,
+	.initialize_rq_fn = scsi_initialize_rq,
+	.busy		= scsi_mq_lld_busy,
+	.map_queues	= scsi_map_queues,
+};
+
+
+static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
+{
+	struct request_queue *q = hctx->queue;
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
+
+	shost->hostt->commit_rqs(shost, hctx->queue_num);
+}
+
 static const struct blk_mq_ops scsi_mq_ops = {
 	.get_budget	= scsi_mq_get_budget,
 	.put_budget	= scsi_mq_put_budget,
 	.queue_rq	= scsi_queue_rq,
+	.commit_rqs	= scsi_commit_rqs,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
 #ifdef CONFIG_BLK_DEBUG_FS
@@ -1845,7 +1873,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;
 
 	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
-	shost->tag_set.ops = &scsi_mq_ops;
+	if (shost->hostt->commit_rqs)
+		shost->tag_set.ops = &scsi_mq_ops;
+	else
+		shost->tag_set.ops = &scsi_mq_ops_no_commit;
 	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
 	shost->tag_set.queue_depth = shost->can_queue;
 	shost->tag_set.cmd_size = cmd_size;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 76ed5e4acd38..91bd749a02f7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -57,6 +57,7 @@ struct scsi_pointer {
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
 #define SCMD_INITIALIZED	(1 << 2)
+#define SCMD_LAST		(1 << 3)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_UNCHECKED_ISA_DMA | SCMD_INITIALIZED)
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2b539a1b3f62..28f1c9177cd2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -80,8 +80,10 @@ struct scsi_host_template {
 	 * command block to the LLDD.  When the driver finished
 	 * processing the command the done callback is invoked.
 	 *
-	 * If queuecommand returns 0, then the HBA has accepted the
-	 * command.  The done() function must be called on the command
+	 * If queuecommand returns 0, then the driver has accepted the
+	 * command.  It must also push it to the HBA if the scsi_cmnd
+	 * flag SCMD_LAST is set, or if the driver does not implement
+	 * commit_rqs.  The done() function must be called on the command
 	 * when the driver has finished with it. (you may call done on the
 	 * command before queuecommand returns, but in this case you
 	 * *must* return 0 from queuecommand).
@@ -109,6 +111,16 @@ struct scsi_host_template {
 	 */
 	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
 
+	/*
+	 * The commit_rqs function is used to trigger a hardware
+	 * doorbell after some requests have been queued with
+	 * queuecommand, when an error is encountered before sending
+	 * the request with SCMD_LAST set.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	void (*commit_rqs)(struct Scsi_Host *, u16);
+
 	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
-- 
2.21.0


