Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAC9394B34
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 11:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhE2JO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 05:14:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36714 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhE2JOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 May 2021 05:14:55 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ADBB121915;
        Sat, 29 May 2021 09:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622279598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RLLpKzaG6cee9YoeuvdoRHLOhiqV7lPKVjXnQJR+5c=;
        b=ykylH80xEmwxgMd21Qls+Am+RypWoqSTD20zrUMEAKHyvYo32N13VBtqkNUBSn9bPFOlmp
        wD08aKkXlJlyRMwO+gUvcgzNQqxQ5T1r1sNjzRa3lp/2KfoDy7Uny1fPtG+ol2p2lX8gA7
        A9YL/fgbeg0Klc0TSlSbiW81iwI+8Sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622279598;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RLLpKzaG6cee9YoeuvdoRHLOhiqV7lPKVjXnQJR+5c=;
        b=VUMBoPN7OJgUBq3ojM8vbVmDbzggH7zjcBinnkn5SNbz6NlbY72o2YYlaT1iYHD9hc5Pj9
        AYD9y77TYu77UABA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id C3FD4118DD;
        Sat, 29 May 2021 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622279598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RLLpKzaG6cee9YoeuvdoRHLOhiqV7lPKVjXnQJR+5c=;
        b=ykylH80xEmwxgMd21Qls+Am+RypWoqSTD20zrUMEAKHyvYo32N13VBtqkNUBSn9bPFOlmp
        wD08aKkXlJlyRMwO+gUvcgzNQqxQ5T1r1sNjzRa3lp/2KfoDy7Uny1fPtG+ol2p2lX8gA7
        A9YL/fgbeg0Klc0TSlSbiW81iwI+8Sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622279598;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RLLpKzaG6cee9YoeuvdoRHLOhiqV7lPKVjXnQJR+5c=;
        b=VUMBoPN7OJgUBq3ojM8vbVmDbzggH7zjcBinnkn5SNbz6NlbY72o2YYlaT1iYHD9hc5Pj9
        AYD9y77TYu77UABA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id cPj/La0FsmCbEwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Sat, 29 May 2021 09:13:17 +0000
From:   Claudio Fontana <cfontana@suse.de>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: [PATCH 2/2] i386: run accel_cpu_instance_init as instance_post_init
Date:   Sat, 29 May 2021 11:13:13 +0200
Message-Id: <20210529091313.16708-3-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210529091313.16708-1-cfontana@suse.de>
References: <20210529091313.16708-1-cfontana@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: *
X-Spam-Score: 1.00
X-Spamd-Result: default: False [1.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLY(-4.00)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCPT_COUNT_TWELVE(0.00)[13];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This partially fixes host and max cpu initialization,
by running the accel cpu initialization only after all instance
init functions are called for all X86 cpu subclasses.

Partial Fix.

Fixes: 48afe6e4eabf ("i386: split cpu accelerators from cpu.c, using AccelCPUClass")
Signed-off-by: Claudio Fontana <cfontana@suse.de>
---
 target/i386/cpu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6bcb7dbc2c..ae148fbd2f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6422,6 +6422,11 @@ static void x86_cpu_register_feature_bit_props(X86CPUClass *xcc,
     x86_cpu_register_bit_prop(xcc, name, w, bitnr);
 }
 
+static void x86_cpu_post_initfn(Object *obj)
+{
+    accel_cpu_instance_init(CPU(obj));
+}
+
 static void x86_cpu_initfn(Object *obj)
 {
     X86CPU *cpu = X86_CPU(obj);
@@ -6473,9 +6478,6 @@ static void x86_cpu_initfn(Object *obj)
     if (xcc->model) {
         x86_cpu_load_model(cpu, xcc->model);
     }
-
-    /* if required, do accelerator-specific cpu initializations */
-    accel_cpu_instance_init(CPU(obj));
 }
 
 static int64_t x86_cpu_get_arch_id(CPUState *cs)
@@ -6810,6 +6812,8 @@ static const TypeInfo x86_cpu_type_info = {
     .parent = TYPE_CPU,
     .instance_size = sizeof(X86CPU),
     .instance_init = x86_cpu_initfn,
+    .instance_post_init = x86_cpu_post_initfn,
+
     .abstract = true,
     .class_size = sizeof(X86CPUClass),
     .class_init = x86_cpu_common_class_init,
-- 
2.26.2

