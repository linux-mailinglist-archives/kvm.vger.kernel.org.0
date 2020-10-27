Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82EF29CD40
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgJ1BiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:21 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:44996 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833033AbgJ0Xhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:37:41 -0400
Received: by mail-qt1-f202.google.com with SMTP id g11so1812081qto.11
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=FvatsgTsG1WoGGeJeoTzHqVyn+DKjuS046eIP4vRHj8=;
        b=qRACHt2j3hYxik5R1ejBQfrsWDhp+9n5u36jQJz/c6TYECvpqUT7ijQGGj2CFnBhUa
         o/PnX2l65TYyCAVEfVXQMElOiIwvXWQjn1sKkfjiWck+vtN3XiQUYs2oyaSyXSQzgn8h
         iROxg5YcEbPjVUv/LJxBOkUOe7+LM/4GJUoF9D1vdKDWLwZvEdGh0XmTNuzcQapm0Oc3
         q6OyrWv/lfaOsAX9OGRls3NdYH6J3RluFmELsfzZ7QV7fhmypwaPg4gluKRc9m9bp17u
         Nn8vFPlKGLFa/GhxJJybnZJiofiiOHfc8miFq8J48yYD0k8CZTQ4EDs4rhVAq798CYXA
         gYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FvatsgTsG1WoGGeJeoTzHqVyn+DKjuS046eIP4vRHj8=;
        b=KQoesRgVR4inTHUTmcLLuUIFrPQKEkSvheVyg/PF0wwIBElWgUb3q1tMR6m5ePU8YJ
         1nNCHt71AsCfPZbhJK49zXxYaAEM9G3/DWMM6Ykn5BJTPAnO+M/r0trPuv78T/9fcfsr
         MZRkN8l0L7Wh3fCCiVCw3DOc0x/M9ohrtIMaZwMuq4hXAl6Ecr4ym7/4P7RuieEyLR71
         LywsnMxI4c8U+KJn3OoNfBYMWVWKCdSrmSDR5Ema2B+vS0n6ZHWWAcjavKFdOanvSyhO
         XRRSNYAKwo6AeAgwbRTZ1imdn28u5eo4TlsFTIrmWQ2ojJPpxeIlmCssEhmHf5hfIqBA
         ohDQ==
X-Gm-Message-State: AOAM530F5tgqbbXsiET2qkLQ5xpSwuadJkbF5kyLAHLrVBcS8my2ADhC
        Wz+hoCHR0dyiyuuFWOAJfXsJEzRPzDcq
X-Google-Smtp-Source: ABdhPJzpJHZ1zLUzxHV1BXnrEt/HxOlNf71ANUuumESWHQD/ivyGrzEyPzmqH3kshyVrXtTvTgzX/KMcfkmn
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:fec6:: with SMTP id
 z6mr5059288qvs.10.1603841860309; Tue, 27 Oct 2020 16:37:40 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:37:30 -0700
In-Reply-To: <20201027233733.1484855-1-bgardon@google.com>
Message-Id: <20201027233733.1484855-3-bgardon@google.com>
Mime-Version: 1.0
References: <20201027233733.1484855-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 2/5] KVM: selftests: Remove address rounding in guest code
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rounding the address the guest writes to a host page boundary
will only have an effect if the host page size is larger than the guest
page size, but in that case the guest write would still go to the same
host page. There's no reason to round the address down, so remove the
rounding to simplify the demand paging test.

This series was tested by running the following invocations on an Intel
Skylake machine:
dirty_log_perf_test -b 20m -i 100 -v 64
dirty_log_perf_test -b 20g -i 5 -v 4
dirty_log_perf_test -b 4g -i 5 -v 32
demand_paging_test -b 20m -v 64
demand_paging_test -b 20g -v 4
demand_paging_test -b 4g -v 32
All behaved as expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/include/perf_test_util.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index f71f0858a1f29..838f946700f0c 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -72,7 +72,6 @@ static void guest_code(uint32_t vcpu_id)
 	for (i = 0; i < pages; i++) {
 		uint64_t addr = gva + (i * perf_test_args.guest_page_size);
 
-		addr &= ~(perf_test_args.host_page_size - 1);
 		*(uint64_t *)addr = 0x0123456789ABCDEF;
 	}
 
-- 
2.29.0.rc2.309.g374f81d7ae-goog

