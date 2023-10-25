Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC0D7D7112
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbjJYPj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjJYPj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:39:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C733C1BC
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kHpgRL5EddUTto5/Vaxzfx33SlksxOrFntoVOzzsuPM=;
        b=KwYldo98snPB5lOGLCbHcwssj2qzXD9rLxugj+WPSRUv8u6I9pKqA5nj+dTBC3grFpyuUS
        Zz4d1KKLFQNHlxXc2wqEOOWIcszg/OZcjDR+4PCPAm74eM2DNwn/dBXvmZjYdwecCgve53
        mFIg6UOiACBdNkl1YMi+l8mkR+jkDzo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-jiBywVHKMhqVasCnkGb6IA-1; Wed, 25 Oct 2023 11:29:19 -0400
X-MC-Unique: jiBywVHKMhqVasCnkGb6IA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 296A88870E7;
        Wed, 25 Oct 2023 15:29:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57C172166B26;
        Wed, 25 Oct 2023 15:29:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH kvm-unit-tests 1/4] x86: hyper-v: Use '-cpu host,hv_passhtrough' for Hyper-V tests
Date:   Wed, 25 Oct 2023 17:29:12 +0200
Message-ID: <20231025152915.1879661-2-vkuznets@redhat.com>
In-Reply-To: <20231025152915.1879661-1-vkuznets@redhat.com>
References: <20231025152915.1879661-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make Hyper-V tests skip gracefully when Hyper-V emulation support is
missing in KVM run all tests with '-cpu host,hv_passhtrough' which is
supposed to enable all enlightenments. Tests can (and will) check CPUID
and report_skip() when the required features are missing.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3fe59449b650..a5574b105efc 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -451,25 +451,25 @@ arch = x86_64
 [hyperv_synic]
 file = hyperv_synic.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough -device hyperv-testdev
 groups = hyperv
 
 [hyperv_connections]
 file = hyperv_connections.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough -device hyperv-testdev
 groups = hyperv
 
 [hyperv_stimer]
 file = hyperv_stimer.flat
 smp = 2
-extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
+extra_params = -cpu host,hv_passthrough -device hyperv-testdev
 groups = hyperv
 
 [hyperv_clock]
 file = hyperv_clock.flat
 smp = 2
-extra_params = -cpu kvm64,hv_time
+extra_params = -cpu host,hv_passthrough
 arch = x86_64
 groups = hyperv
 check = /sys/devices/system/clocksource/clocksource0/current_clocksource=tsc
-- 
2.41.0

