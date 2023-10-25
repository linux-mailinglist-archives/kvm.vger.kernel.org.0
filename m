Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E507D7111
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbjJYPjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjJYPjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:39:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BFBD56
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28vU8AtFcmowR+oJB1xtmcOuRYh4PysKXZ77Wa0Z6bY=;
        b=YG6xJfgR9NXr9rFalG3Fq5xDb1iRJfCYg8zinA39wOjL75cTV8zTJduTNtAl4B/9gsYVZv
        3JzhDdZmw7A7M0zvRO4SP6c9Rbr/pjTzLZNiqTMyf8cq/Lq+jVEUsTq6aJRbOFJRZZCDAy
        G2bFBOLnQ3IMrFKkNj9VIMfEyoHAlnc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-vLRRCnpbODu3xQdVo3h0hA-1; Wed, 25 Oct 2023 11:29:20 -0400
X-MC-Unique: vLRRCnpbODu3xQdVo3h0hA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 317B385C6F2;
        Wed, 25 Oct 2023 15:29:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ECFC2166B26;
        Wed, 25 Oct 2023 15:29:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH kvm-unit-tests 2/4] x86: hyper-v: Use report_skip() in hyperv_stimer when pre-requisites are not met
Date:   Wed, 25 Oct 2023 17:29:13 +0200
Message-ID: <20231025152915.1879661-3-vkuznets@redhat.com>
In-Reply-To: <20231025152915.1879661-1-vkuznets@redhat.com>
References: <20231025152915.1879661-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'report_pass()' is supposed to be used when tests actually pass, use
'report_skip()' to match other tests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_stimer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index f7c679160bdf..bcf0fc9d8058 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -353,17 +353,17 @@ int main(int ac, char **av)
 {
 
     if (!synic_supported()) {
-        report_pass("Hyper-V SynIC is not supported");
+        report_skip("Hyper-V SynIC is not supported");
         goto done;
     }
 
     if (!stimer_supported()) {
-        report_pass("Hyper-V SynIC timers are not supported");
+        report_skip("Hyper-V SynIC timers are not supported");
         goto done;
     }
 
     if (!hv_time_ref_counter_supported()) {
-        report_pass("Hyper-V time reference counter is not supported");
+        report_skip("Hyper-V time reference counter is not supported");
         goto done;
     }
 
-- 
2.41.0

