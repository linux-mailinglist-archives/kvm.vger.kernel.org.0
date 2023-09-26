Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00117AEC6F
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 14:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjIZMUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 08:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbjIZMUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 08:20:41 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B423126;
        Tue, 26 Sep 2023 05:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=GVRP7ZhX9y66fV8la0Z0phq4YOuv61LMjBgGZkw2zl4=; b=rj2urSvrvK6H++zO04aJR9h+9T
        EkFDrmH3fH6pu6WNr9oi0CobGOYQzl/7mmqEXBu83s1Cj+i728wbadosNbhxm8jKHMsRmK7R83k9v
        xoi03HNc3qOMIf3rxRJmbX+d92Tu7TV6zGanD5irxQLUyPE51H5zSe1CKp5tvY+1jz3c=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1ql73I-0000Hm-HE; Tue, 26 Sep 2023 12:20:32 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1ql73I-0001mF-9r; Tue, 26 Sep 2023 12:20:32 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v6 09/11] KVM: selftests / xen: re-map vcpu_info using HVA rather than GPA
Date:   Tue, 26 Sep 2023 12:20:11 +0000
Message-Id: <20230926122013.867391-10-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230926122013.867391-1-paul@xen.org>
References: <20230926122013.867391-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

If the relevant capability (KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA) is present
then re-map vcpu_info using the HVA part way through the tests to make sure
then there is no functional change.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v5:
 - New in this version.
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c        | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index e6672ae1d9de..a5d3aea8fd95 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -66,6 +66,7 @@ enum {
 	TEST_POLL_TIMEOUT,
 	TEST_POLL_MASKED,
 	TEST_POLL_WAKE,
+	SET_VCPU_INFO,
 	TEST_TIMER_PAST,
 	TEST_LOCKING_SEND_RACE,
 	TEST_LOCKING_POLL_RACE,
@@ -325,6 +326,10 @@ static void guest_code(void)
 
 	GUEST_SYNC(TEST_POLL_WAKE);
 
+	/* Set the vcpu_info to point at exactly the place it already is to
+	 * make sure the attribute is functional. */
+	GUEST_SYNC(SET_VCPU_INFO);
+
 	/* A timer wake an *unmasked* port which should wake us with an
 	 * actual interrupt, while we're polling on a different port. */
 	ports[0]++;
@@ -892,6 +897,16 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
+			case SET_VCPU_INFO:
+				if (has_shinfo_hva) {
+					struct kvm_xen_vcpu_attr vih = {
+						.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA,
+						.u.hva = (unsigned long)vinfo
+					};
+					vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vih);
+				}
+				break;
+
 			case TEST_TIMER_PAST:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
-- 
2.39.2

