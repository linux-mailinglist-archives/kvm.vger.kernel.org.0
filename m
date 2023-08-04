Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D47770738
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjHDRey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjHDRew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:34:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE7B4C03
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691170438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NI4jvdIDyh2Ts1MLknp3BoQ/fcSYRa/824rQ3V7P6xM=;
        b=Em7rKfPnj+R01c6TxLMVjpQtgNXrXWrMzhUVPXLHNtVsX2GPEcotSh1N/36CaM1cfc9RLF
        kUyxM5GQI9YRzFJMailISmePR/iMusdm4hQSNe3Ux6Tw4VxoH/TNtWZzrbSrbY2s9ZXCJh
        pryGl9rIAndc/V7gi8pFb7+jPNnAGGc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-B-3snfznM9mXsA2pNEXPEw-1; Fri, 04 Aug 2023 13:33:57 -0400
X-MC-Unique: B-3snfznM9mXsA2pNEXPEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E95B1039439;
        Fri,  4 Aug 2023 17:33:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C876C5796C;
        Fri,  4 Aug 2023 17:33:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com, thomas.lendacky@amd.com
Subject: [PATCH 0/3] KVM: SEV: only access GHCB fields once
Date:   Fri,  4 Aug 2023 13:33:52 -0400
Message-Id: <20230804173355.51753-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMGEXIT handler has a time-of-check/time-of-use vulnerability; due
to a double fetch, the guest can exploit a race condition to invoke
the VMGEXIT handler recursively.  It is extremely difficult to
reliably win the race ~100 consecutive times in order to cause an
overflow, and the impact is usually mitigated by CONFIG_VMAP_STACK,
but it ought to be fixed anyway.

One way to do so could be to snapshot the whole GHCB, but this is
relatively expensive.  Instead, because the VMGEXIT handler already
syncs the GHCB to internal KVM state, this series makes sure that the
GHCB is not read outside sev_es_sync_from_ghcb().

Patch 1 adds caching for fields that currently are not snapshotted
in host memory; patch 2 ensures that the cached fields are always used,
thus fixing the race.  Finally patch 3 removes some local variables
that are prone to incorrect use, to avoid reintroducing the race in
other places.

Please review!

Paolo

Paolo Bonzini (3):
  KVM: SEV: snapshot the GHCB before accessing it
  KVM: SEV: only access GHCB fields once
  KVM: SEV: remove ghcb variable declarations

 arch/x86/kvm/svm/sev.c | 124 ++++++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.h |  26 +++++++++
 2 files changed, 87 insertions(+), 63 deletions(-)

-- 
2.39.0

