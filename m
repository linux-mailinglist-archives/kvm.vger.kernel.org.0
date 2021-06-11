Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFD73A4B81
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhFLAAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 20:00:35 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:36389 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhFLAAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 20:00:34 -0400
Received: by mail-pf1-f201.google.com with SMTP id l145-20020a6288970000b02902e9f6a5c2c3so4101525pfd.3
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5pAQV1Lw2Y47BZl4IaSZrS+FJXZs41SS8a9vGzneCvw=;
        b=AeiuNS4S9JPhjK1Kz82bMHe7Dh6sDgYMa8jUFh1Z+naBWT1MD4c/Ed/pRqvPvrrX7c
         JuIr4EY1Pia0nCQda/RzoiogTXrtxxMQXJBXf1QPRTQwzd72nZPMxQ2E5hZ/eqTbe2IY
         V7JHD+GjmYosvHpzSV+vwMW3fwJ/WIDAMS5VHuGUdQOEewW2xP0g78M4o6id/pveaO8A
         qS2hgu3fO9ugNk2+iY2VPmJ9RLlKfpK3AW5YRWerzW8s81XBVoRtNcVhYwISbbdZraMO
         RHEqh5D5wdrbqmuR6LRem5jDqncOLFwqqCzeB238oNZi0kbD11H8CvWN9nb9vjjEzFyM
         DFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5pAQV1Lw2Y47BZl4IaSZrS+FJXZs41SS8a9vGzneCvw=;
        b=p97gI07+kOqGrfhCiRy0A8R13jUC+LUb4lI0O+V6ikC91rhywzeKOJi+aVHVI+9Rtv
         CRSEOo4DsD5DppdaHTJLglYL0JHUqyiF/RIUBDXKw1lBgXxhKmtE8HvhjahOvVt3vqwp
         e6ioB8Chlb414AXRSFlENUpHBbnFlL6qnLk4UOGeoTVPIK7lNqbB4DQslddJ2nCy98yr
         Y1pBps02ONbjuTLGWgDPbSpaKxgHEVA4MZGoE5hBCie8mHNKj0djeZnoDbINpXtTn34/
         RqtCICfE9olOnci9WK0loYoYLjX53h7DFRmx/kjHWlsP02f7bAQZk6oOhtYp/iOsucoi
         R0dg==
X-Gm-Message-State: AOAM5317Is2wr9mFMIlM+aD6bh1ClCu1KOfE9QRjlulPfUg3TjJ5v273
        N6T1Pz7y8MZB+D7vnwtZKxq10bm5ANH1mb2QOS/pJCGh1ZXsj/NULZFLrKs3699gzVO+9XM/FBy
        RakfwtQ4dozcpAc9fCvkXr+pYwXnSa4IVSTb12AwLTeBu8RFOk5R/0ehO769FNsA=
X-Google-Smtp-Source: ABdhPJzkUGwIsXX5wNHuGCo+J59Fy9E5QZsfvNo5Axwp2Ru3MG7XonR+Or9TcQnK1KTkgzI9Ol/8tzTmfl8KgQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:8202:0:b029:2d8:c24d:841d with SMTP
 id k2-20020aa782020000b02902d8c24d841dmr10586583pfi.57.1623455850345; Fri, 11
 Jun 2021 16:57:30 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:57:00 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 7/8] KVM: selftests: Fix missing break in dirty_log_perf_test
 arg parsing
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a missing break statement which causes a fallthrough to the
next statement where optarg will be null and a segmentation fault will
be generated.

Fixes: 9e965bb75aae ("KVM: selftests: Add backing src parameter to dirty_log_perf_test")
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
2.32.0.272.g935e593368-goog

