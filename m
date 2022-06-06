Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE23E53ED47
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiFFRxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiFFRxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:53:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5B6146405
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 10:53:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t14-20020a65608e000000b003fa321e8ea3so7263644pgu.18
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DsaAs5Mtj+7v7RCIqvKHiaNPafiwu1xMM4QFAYPQb14=;
        b=DCn8lnjACbULOpGUugKkD1S6OYb51O+TtQmxUPs+/ku/L/mhzN7zrKK6s62TVHZlg4
         SgFXmo3e5nxGrT4mcvk9Mje4g50Ffrt6efUxa2X+QiAbQ5cICxnwjQJgbVSoyP9b+bYr
         am0/KCkDauRrflAHhB4kx5KXi4tneI51pRUJQOLQ/SgFVF1zO4kBsCqXrR1T+9kRo24o
         a8nrjmWgE4CSib7cdzKqHoqKw6mL0W21ka7jCnd6d4l3JtGanGY4MiGnG0vGPIXzw5r/
         JeyknonNS209SOTjfyk91lvqPp4gyp7Bi59O2Xd+oG9wj9x5znd7jma8L4bZ/Xh4TWOW
         ++ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DsaAs5Mtj+7v7RCIqvKHiaNPafiwu1xMM4QFAYPQb14=;
        b=7SvB/vDMrafgjbj3BYd1vbtUDI5/PQKt2yL9yUF4WTYT+v63yHys8hcK78NJ2x/Pu9
         BF/UNNlrTj0kw1FlK4QQmmvuecq3TPOdlWgiPmVtM75ao7n+IAkiOjiKi4L3HlWDfDSR
         Mh+yho7eNsacdm2CrHi470T/3DVmoWNOkCeP5GKJW107VD9uyPOHKq44PUh7I8dDBNfA
         7wseQnDxoLOwkn3FlA68l6apG51+441XF6YRRkEqTJ2lVSlcmeLncl+tYEIhObOMvMxS
         N3c7oa46TJttseuMk1fMMMjp5xDTYdkEicf3Z1JOlHaR3N5Gui/o05VaB1dgE7AcCGb8
         E/1w==
X-Gm-Message-State: AOAM531hQT75vpakGPP0WHh3a2gcHn5AfynL5QbhDvo8jr9YPaWtjLlx
        dZ6638P1ve2+4I3BvuFFyBEI1jLT8jCRLZIVqlKDCedmZ3PVKK+eXb1AVShnsNWeofdag1SfenP
        CABxKVoy+2YeT2bawa8Tk8oLo1+kr9TYzJPyjDS2JTKmPO1R15c/Kh5ruS6sJp09ucCb+
X-Google-Smtp-Source: ABdhPJzCdj7Tls6sh5fpxBRFGPdDQMcRP8Jns0CaCV1+pJ9J2ny5w+pn7Z1G1P1c/ujvaFsVcQin7TfYQwAQM3Cq
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:d591:b0:165:ddec:f6ef with SMTP
 id k17-20020a170902d59100b00165ddecf6efmr24878940plh.35.1654538026464; Mon,
 06 Jun 2022 10:53:46 -0700 (PDT)
Date:   Mon,  6 Jun 2022 17:52:49 +0000
In-Reply-To: <20220606175248.1884041-1-aaronlewis@google.com>
Message-Id: <20220606175248.1884041-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 4/4] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that masked events are not using invalid bits, and if they are,
ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
The only valid bits that can be used for masked events are set when
using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one caveat.  If any bits
in the high nybble[1] of the eventsel for AMD are used on Intel setting
the pmu event filter with KVM_SET_PMU_EVENT_FILTER will fail.

Also, because no validation was being done on the event list prior to
the introduction of masked events, verify that this continues for the
original event type (flags == 0).  If invalid bits are set (bits other
than eventsel+umask) the pmu event filter will be accepted by
KVM_SET_PMU_EVENT_FILTER.

[1] bits 35:32 in the event and bits 11:8 in the eventsel.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 5b0163f9ba84..1fe1cbd36146 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -550,6 +550,36 @@ static void test_masked_filters(struct kvm_vm *vm)
 	run_masked_filter_tests(vm, masked_events, nmasked_events, event);
 }
 
+static void test_filter_ioctl(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f;
+	uint64_t e = ~0ul;
+	int r;
+
+	/*
+	 * Unfortunately having invalid bits set in event data is expected to
+	 * pass when flags == 0 (bits other than eventsel+umask).
+	 */
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW, 0);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+	free(f);
+
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r != 0, "Invalid PMU Event Filter is expected to fail");
+	free(f);
+
+	e = ENCODE_MASKED_EVENT(0xff, 0xff, 0xff, 0xf);
+
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+	free(f);
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
@@ -595,6 +625,7 @@ int main(int argc, char *argv[])
 	test_not_member_allow_list(vm);
 
 	test_masked_filters(vm);
+	test_filter_ioctl(vm);
 
 	kvm_vm_free(vm);
 
-- 
2.36.1.255.ge46751e96f-goog

