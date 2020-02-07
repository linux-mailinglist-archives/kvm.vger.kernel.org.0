Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F63155DD5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGSQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:40 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40538 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726951AbgBGSQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:40 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 84183305CA1D;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 69D013032046;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 01/78] sched/swait: add swait_event_killable_exclusive()
Date:   Fri,  7 Feb 2020 20:15:19 +0200
Message-Id: <20200207181636.1065-2-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vCPU is introspected, it waits for introspection commands or event
replies. If the introspection channel is closed, the receiving thread
will wake-up the vCPU threads. With this function the vCPU thread will
wake-up on SIGKILL too.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/swait.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 73e06e9986d4..9c53383219f6 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -297,4 +297,15 @@ do {									\
 	__ret;								\
 })
 
+#define __swait_event_killable(wq, condition)				\
+	___swait_event(wq, condition, TASK_KILLABLE, 0,	schedule())
+
+#define swait_event_killable_exclusive(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __swait_event_killable(wq, condition);		\
+	__ret;								\
+})
+
 #endif /* _LINUX_SWAIT_H */
