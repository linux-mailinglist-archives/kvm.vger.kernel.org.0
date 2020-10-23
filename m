Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34B22968C1
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 05:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374853AbgJWDa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 23:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374850AbgJWDa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 23:30:27 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9DBC0613D2
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 20:30:27 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id d22so16789qtn.0
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 20:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6HFlEVpudWH5pffnpQkc+Yc/oxstkbax6tUIXieA0lk=;
        b=iVgGGpv/7FVDQ3pQoJo5ENDkVCIPPnAb2W/P85Q5YObYQ2qOZxGF5aIUBugdD4WxjU
         Z5RiS70Guwrf2/je+hqDDOaMglLC2zunZShamfYLdW7/LeCKyl0Jm+323jMv/JP4bdLn
         Cnc1mlvlswebVTlRL7llKF7A6RsRxb5HywKIzg2GugnXeaGy2yJebCLgsW4mT3HNGT67
         Q9Ykutn29AadOxcTFqlJfponLBNNUotM0TG5bkKPWwVkNvEfLOzYa4mI5lFBvayOC1b3
         zP5wOtjf8ftz3PMQHQr6qhUXN6Jm0YYw/T2c3+BrXI0d1YjElTouA69Vo9i4xhiZB1ok
         Vx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6HFlEVpudWH5pffnpQkc+Yc/oxstkbax6tUIXieA0lk=;
        b=sM6aHBkZrEYzujxlT57QK6XgZ1Tp0IDh+hQrou2oapvcFa2ADuU2fHXgO6bAaOSbE0
         TO+ASQ7wJR3GZXk6tb+6x7njbbgX1BPMtE8lH3efl1SP9OdgPYraAEkZzIlDlneKlkip
         lt7u9ixH6MD8zMoST4T2rUVkaU9fXR7ztulDusvovtaQEdKWSrHLYvBgNwSalIoooidw
         M4nR6OkzAdlvP7HpqPLe08QxPpW6BgwM2nHYUej3gy3NfvyAl1RQ4BejJ8kIRd4tQy/A
         T9QbOsPCcoORfFaCkJ3qC3ETZr9Lyf3dsUdo1LdDmA6TDHgNL2sIoJ+ILzSRmmRck1vF
         4b7Q==
X-Gm-Message-State: AOAM533pQ+qgqCRddtkFdbL8dw6uyInlTV2R0ezPwDMsP7NOjVA9F/Jd
        zKJA4U+hk/vk0b3D+5lzrfLPdB20HAHf
X-Google-Smtp-Source: ABdhPJywFZ9nl2zxccBBMSoKLsYKnTzcd6iRKtoGpdGnB7NFOH56JsDER6SvXGz5MrN+E2VlfKYlk66r6HEj
Sender: "joshdon via sendgmr" <joshdon@joshdon.svl.corp.google.com>
X-Received: from joshdon.svl.corp.google.com ([2620:15c:2cd:202:a28c:fdff:fee1:cc86])
 (user=joshdon job=sendgmr) by 2002:ad4:43ca:: with SMTP id
 o10mr376677qvs.33.1603423826790; Thu, 22 Oct 2020 20:30:26 -0700 (PDT)
Date:   Thu, 22 Oct 2020 20:29:44 -0700
In-Reply-To: <20201023032944.399861-1-joshdon@google.com>
Message-Id: <20201023032944.399861-3-joshdon@google.com>
Mime-Version: 1.0
References: <20201023032944.399861-1-joshdon@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH 3/3] net: better handling for network busy poll
From:   Josh Don <joshdon@google.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Josh Don <joshdon@google.com>,
        Xi Wang <xii@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the new functions prepare_to_busy_poll() and friends to
napi_busy_loop(). The busy polling cpu will be considered an idle
target during wake up balancing.

Suggested-by: Xi Wang <xii@google.com>
Signed-off-by: Josh Don <joshdon@google.com>
Signed-off-by: Xi Wang <xii@google.com>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 266073e300b5..4fb4ae4b27fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6476,7 +6476,7 @@ void napi_busy_loop(unsigned int napi_id,
 	if (!napi)
 		goto out;
 
-	preempt_disable();
+	prepare_to_busy_poll(); /* disables preemption */
 	for (;;) {
 		int work = 0;
 
@@ -6509,10 +6509,10 @@ void napi_busy_loop(unsigned int napi_id,
 		if (!loop_end || loop_end(loop_end_arg, start_time))
 			break;
 
-		if (unlikely(need_resched())) {
+		if (unlikely(!continue_busy_poll())) {
 			if (napi_poll)
 				busy_poll_stop(napi, have_poll_lock);
-			preempt_enable();
+			end_busy_poll(true);
 			rcu_read_unlock();
 			cond_resched();
 			if (loop_end(loop_end_arg, start_time))
@@ -6523,7 +6523,7 @@ void napi_busy_loop(unsigned int napi_id,
 	}
 	if (napi_poll)
 		busy_poll_stop(napi, have_poll_lock);
-	preempt_enable();
+	end_busy_poll(true);
 out:
 	rcu_read_unlock();
 }
-- 
2.29.0.rc1.297.gfa9743e501-goog

