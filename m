Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05513A1CC2
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFIScC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFISb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:31:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAB2C06175F
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 11:30:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so1980323pjq.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rcASrBBC54ippeJc8KQOcZ4tnnIbc6w6h2SU/3e0h2I=;
        b=knMT4cbOHYlSHse6UAmWVOaYbM8xq3gLYxzLz3PhirgBHMh+54RL1PmSjEnBfFYcFl
         VewzMyf5W0ZTNFTeZGVjqs+TObyvBvRclk2yUh3A22b5mraCUT1kZhfgD0SnwOTCZ6Cc
         1nHpxC/4TPwqBPhtV0Ld1+4Gau2VbADNpei2Hk3m0CwrrboPUegm8Z3RIXcR9uY7tnCy
         tcMQkMKbcL1F+KJJ0Gh5LOFs3Vcx09MHqv7QBB0Ob0e7Hk0HX0OWxNRxWAcqzB5UO7L9
         kEwh8FrJsW47pHZ2yg3RBH/zAxTyywkNx43a++sGmpRZut3nnj1W0mJWgYruihZ0PObh
         NDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rcASrBBC54ippeJc8KQOcZ4tnnIbc6w6h2SU/3e0h2I=;
        b=ghIfd36sRl+Jck9SffcussSn60t8kwn7UDKpgDQF1vXmM7BKG8XLR3tm2tIE7q+2z3
         1WjGI2DqbuTe3s5/zmaVnXTyMCB5pK+xafn6hu3WTEcGnj4hp+O+uRcahbMe3dO9nqMf
         OvGf1zj3NrueeJPzTluoEAyToSlVegYtlBkUeJ4ygbUpJOHXXgboDC2JZfePHsQxSmnv
         0UvXH1fBSi1z8gBVkrgByO+UQ6wx+nQThKNT5b1QTZ5dsYs5GLuDy5yZw51o3oOZleD7
         H05NL5OtucZkZtk64Pve0uMZhjlFllanOAR3RH2uh6+SExsb9pULXjGFLCx37NjF4wSq
         pFoA==
X-Gm-Message-State: AOAM533J24DTMBeGwR9/eEmISFDTrMRFhe1k0UsYqYH93V/1hHSHjDwA
        luZOg02b9otrM7lLgbPDdA8=
X-Google-Smtp-Source: ABdhPJxmD/zw+2oejK7wLrGIrC5fZYF0PVIMAi72mx/jXtU0Qllvt+3xCFmGU97b8zt+jBzkrQpb0w==
X-Received: by 2002:a17:90a:24a:: with SMTP id t10mr911144pje.178.1623263402862;
        Wed, 09 Jun 2021 11:30:02 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:30:02 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 5/8] x86/hyperv: skip hyperv-clock test if unsupported by host
Date:   Wed,  9 Jun 2021 18:29:42 +0000
Message-Id: <20210609182945.36849-6-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

Skip the hyperv-clock tests if time reference counter is unsupported by
the host, similarly to the way other hyperv tests first check support of
the host.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/hyperv_clock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index b4cfc9f..f1e7204 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -150,6 +150,11 @@ int main(int ac, char **av)
 	uint64_t tsc1, t1, tsc2, t2;
 	uint64_t ref1, ref2;
 
+	if (!hv_time_ref_counter_supported()) {
+		report_skip("time reference counter is unsupported");
+		return report_summary();
+	}
+
 	setup_vm();
 
 	ncpus = cpu_count();
-- 
2.25.1

