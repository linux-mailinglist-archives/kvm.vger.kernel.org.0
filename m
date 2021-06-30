Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2223B8A36
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 23:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhF3VvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 17:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbhF3Vu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 17:50:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D7EC0617A8
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c20-20020a17090ab294b029016fccb9582dso2072924pjr.7
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YypJ74lmVV39roAzI2i/DT39zCOCRxagBpvdMWnNzDc=;
        b=dXfuUM5fUb7MEtYMYaWBLLu4qCZpdBqagSYXoYay0Te9r9EjgMBTVuyxQ+Fa/RL5kL
         3dOAn/0fzSIdgrUpxHiFxRB1wd+hxkiI9XGvfbYz8qVqhIQvCsSkDhNCzRobQFPwgxxl
         6JFdrLlwcT5USW1BVI90NLuftpWxS3B3YgSN2RprJg73aOMWVG5Rlh9SsxxnyBjZquxz
         DneU9VxWZuOQJ3K2qvyx5t0tYpPhPUpFfrP03g7rpFAnqwXBhMhLSFVAAtlNpSULtbUo
         DL4iH1hMzetLcmNPncAyWlRvUsmsDxKy2UXDRggZCVy+Rq+NlSPkU09mvNAVD2UsU6vx
         DEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YypJ74lmVV39roAzI2i/DT39zCOCRxagBpvdMWnNzDc=;
        b=pNVZO4naFTFhr37/IaFO88jHdMtFdjIELK8BYwlXW6o+e8bM0ByZ3VdX+rgMDyt3av
         LxfQ0+9wOjXeWBW1eKET8mCBpbvksVLk1fEXwIFAmQoO++FZQBVnkh8mTIaJimf+vdle
         zBUD2gKwa0LSg2bFhOBnifSU26FfW4ylY2FnZsLHy50w4CFD2r/wuAcG2NQHVUaoAQLb
         E73OYlYAavOUQsLXKMdsnLzZrbjO19Wqe2v8jQtwGAykXj4PzrFv1Hsd4vBiN8lUgDkG
         aSC79knTHEvVhfoTp1qoHH4yms27WkB0QwOe7HjFaW3DhLcwLPQFJ0d7u9BF2v41j/eE
         BC0A==
X-Gm-Message-State: AOAM532Pk1duRisg2inbhND6g3JTxk/z58r0ZD0o10QM7A2S2sjBCact
        zacNXWBSn4uOJC1t389wPem2Gwex+5F/SaQnz3/IgCVl4tk6T//IveGlJqxxMc3cBexrx2Cn0xi
        oMYsE1mohkMe+/y5wEO7100MOy4Lq64rv2/yVc7PRUFBwAmt9ZprYM8sK1J6oLqw=
X-Google-Smtp-Source: ABdhPJzTAO5PjVdslNaUsLkX1FxHllgR8bDnlHNWt5o46T/rE8p/IyghmugnqkWDSrZfyjQLqWqiXIOcUS0UTQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:1da3:: with SMTP id
 v32mr6518035pjv.192.1625089707340; Wed, 30 Jun 2021 14:48:27 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:48:01 +0000
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Message-Id: <20210630214802.1902448-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 5/6] KVM: selftests: Fix missing break in
 dirty_log_perf_test arg parsing
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a missing break statement which causes a fallthrough to the
next statement where optarg will be null and a segmentation fault will
be generated.

Fixes: 9e965bb75aae ("KVM: selftests: Add backing src parameter to dirty_log_perf_test")
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 04a2641261be..80cbd3a748c0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -312,6 +312,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'o':
 			p.partition_vcpu_memory_access = false;
+			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
-- 
2.32.0.93.g670b81a890-goog

