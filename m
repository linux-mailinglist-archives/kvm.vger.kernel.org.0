Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105E54F9B25
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbiDHQ72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiDHQ70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:59:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D13092C499C
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649437041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Amg0xvXpuwMEuLnGP1PQePHLAINBX6RYSENvzAUWj5o=;
        b=RQO44xBOKE2XLzHMb0LjTSAkTFjwSEk/V/iA5JIKmHTHDkyE9KdjATxuV49xTVghc3DL35
        vS+qZjifJroJDCQxZs8qXciK6AWWzHrXDJc5MpVofIpQoITCHdv3ooYrnyp3O8zr2WdFHI
        fpQW/RPliB2b9I/Pv1t1TiEESVJa4aI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-t770FnMfNQa3ZRNimpXjNA-1; Fri, 08 Apr 2022 12:57:16 -0400
X-MC-Unique: t770FnMfNQa3ZRNimpXjNA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C8AD3822207;
        Fri,  8 Apr 2022 16:57:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D701A42D3A6;
        Fri,  8 Apr 2022 16:57:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Date:   Fri,  8 Apr 2022 12:56:42 -0400
Message-Id: <20220408165641.469961-1-pbonzini@redhat.com>
In-Reply-To: <20220407210233.782250-1-pgonda@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  But documentation was missing:

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e7a0dfdc0178..72183ae628f7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6088,8 +6088,12 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_SHUTDOWN       1
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
+  #define KVM_SYSTEM_EVENT_SEV_TERM       4
+  #define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
 			__u32 type;
+                        __u32 ndata;
 			__u64 flags;
+                        __u64 data[16];
 		} system_event;

 If exit_reason is KVM_EXIT_SYSTEM_EVENT then the vcpu has triggered
@@ -6099,7 +6103,7 @@ HVC instruction based PSCI call from the vcpu. The 'type' field describes
 the system-level event type. The 'flags' field describes architecture
 specific flags for the system-level event.

-Valid values for 'type' are:
+Valid values for bits 30:0 of 'type' are:

  - KVM_SYSTEM_EVENT_SHUTDOWN -- the guest has requested a shutdown of the
    VM. Userspace is not obliged to honour this, and if it does honour
@@ -6112,12 +6116,18 @@ Valid values for 'type' are:
    has requested a crash condition maintenance. Userspace can choose
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
+ - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
+   The guest physical address of the guest's GHCB is stored in `data[0]`.

 Valid flags are:

  - KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2 (arm64 only) -- the guest issued
    a SYSTEM_RESET2 call according to v1.1 of the PSCI specification.

+Extra data for this event is stored in the `data[]` array, up to index
+`ndata-1` included, if bit 31 is set in `type`.  The data depends on the
+`type` field.  There is no extra data if bit 31 is clear or `ndata` is zero.
+
 ::

 		/* KVM_EXIT_IOAPIC_EOI */


Paolo


