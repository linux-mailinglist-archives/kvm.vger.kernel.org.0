Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BBB608E30
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJVPsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 11:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJVPs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 11:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCB424F785
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 08:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666453705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ubaULjUrByYJfUfr92/n81pA5XqiKjFVYnSXLbaGMQI=;
        b=WDr2tYd3p2cD3Klk+7vcl4XYlVrRMdZUfp3J2/LJDfgiFT6H2I0dK1khz6aXPQHEDOiwtD
        iCzdhnI79uVgqsJS237R9dP5M9B+9lZ75NF0+MFgfOdN228wjfs9PyEKqcQAo9LIGxKcAI
        dTViswD+/s7hMd5vvmoURyagLNA7Vn4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-N3ZNxMu6NdSkX-ZcmhlpQw-1; Sat, 22 Oct 2022 11:48:22 -0400
X-MC-Unique: N3ZNxMu6NdSkX-ZcmhlpQw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E44E2862FDF;
        Sat, 22 Oct 2022 15:48:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 287BB49BB60;
        Sat, 22 Oct 2022 15:48:21 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 0/4] KVM: API to block and resume all running vcpus in a vm
Date:   Sat, 22 Oct 2022 11:48:15 -0400
Message-Id: <20221022154819.1823133-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new API allows the userspace to stop all running
vcpus using KVM_KICK_ALL_RUNNING_VCPUS ioctl, and resume them with
KVM_RESUME_ALL_KICKED_VCPUS.
A "running" vcpu is a vcpu that is executing the KVM_RUN ioctl.

This serie is especially helpful to userspace hypervisors like
QEMU when they need to perform operations on memslots without the
risk of having a vcpu reading them in the meanwhile.
With "memslots operations" we mean grow, shrink, merge and split
memslots, which are not "atomic" because there is a time window
between the DELETE memslot operation and the CREATE one.
Currently, each memslot operation is performed with one or more
ioctls.
For example, merging two memslots into one would imply:
DELETE(m1)
DELETE(m2)
CREATE(m1+m2)

And a vcpu could attempt to read m2 right after it is deleted, but
before the new one is created.

Therefore the simplest solution is to pause all vcpus in the kvm
side, so that:
- userspace just needs to call the new API before making memslots
changes, keeping modifications to the minimum
- dirty page updates are also performed when vcpus are blocked, so
there is no time window between the dirty page ioctl and memslots
modifications, since vcpus are all stopped.
- no need to modify the existing memslots API

Emanuele Giuseppe Esposito (4):
  linux-headers/linux/kvm.h: introduce kvm_userspace_memory_region_list
    ioctl
  KVM: introduce kvm_clear_all_cpus_request
  KVM: introduce memory transaction semaphore
  KVM: use signals to abort enter_guest/blocking and retry

 Documentation/virt/kvm/vcpu-requests.rst |  3 ++
 arch/x86/include/asm/kvm_host.h          |  2 ++
 arch/x86/kvm/x86.c                       |  8 +++++
 include/uapi/linux/kvm.h                 |  3 ++
 virt/kvm/kvm_main.c                      | 45 ++++++++++++++++++++++++
 5 files changed, 61 insertions(+)

-- 
2.31.1

