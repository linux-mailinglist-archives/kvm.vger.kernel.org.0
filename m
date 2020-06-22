Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E26204341
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgFVWEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:04:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730736AbgFVWEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592863489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D9zKETShESnlmbV3mu0MXm27L6L0w57VJPQLcTIPbrk=;
        b=bNCQ3/cnaPQ11zk3dqoQnHvKwmyBrrPHQL2KW4BbrAcZmDuLmXkTNNAmNxoQf8jNkZAPpQ
        JrrDZy4GJynpNfEUXftQrZdh/x88EXxKuv9HAkVUkm58SBrCKUIEm2qQgAqV0LtoXy7vIg
        7qsU/6S3jiBtoXT0E849sHJx3vU7KL4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-JkegwOwZMrapsB0DOCA9nA-1; Mon, 22 Jun 2020 18:04:47 -0400
X-MC-Unique: JkegwOwZMrapsB0DOCA9nA-1
Received: by mail-qt1-f197.google.com with SMTP id r25so2757955qtj.11
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:04:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9zKETShESnlmbV3mu0MXm27L6L0w57VJPQLcTIPbrk=;
        b=hEc6hSGHAmu+qkXRJ9bfdz85MpqfkmsGyA9868JdSD9sYHmxcC4raZE7lgen3w62Mb
         ZH29TbVfqrx2merJKgYYgj74FKvSrf6bLqVmPju3Kze5pE9G1XhwhUBYFiben1fQWO+T
         ur9I4EOlObfsClVRqz2m9AAR1WwlNL16z72LXvLgKT1hEKFEdYnBgeWE88BWqWDpYuwL
         1TEUPNtRReSe8cWHKS6fYCCtyVSvRIsf8X1MUgElv7ZgJP4tI3OBTStFZBFlYO1ITKH5
         Yn5dUt3hRdF4/ya//v93nfVUGjqhCKC8NKZVEL2p5ZHcdsKFf65Di4w2FWVTaHrjk2XU
         D0Sg==
X-Gm-Message-State: AOAM533zfkQ5UVXhid2olxbmtK3rM1Yo3LPV6DGR+r20qJfcyCaZ7qYy
        3N3YInByb78DX3QQXerdPxEfkqCegw5RM0T1zit2oC5hiihzsaAvSL6qQLAvO2paA0jykH1O1X0
        1g1LMqbd6humi
X-Received: by 2002:ac8:39a5:: with SMTP id v34mr3750921qte.377.1592863486981;
        Mon, 22 Jun 2020 15:04:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPioSIYBbZtgP/PBxkHkqJOw9BSt46b64TzBxG1INjx9E7Vg9ObXsPvQdo2rC0ZKklAQiWMQ==
X-Received: by 2002:ac8:39a5:: with SMTP id v34mr3750894qte.377.1592863486754;
        Mon, 22 Jun 2020 15:04:46 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h6sm3506810qtu.2.2020.06.22.15.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:04:45 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 0/2] KVM: X86: A few fixes around ignore_msrs
Date:   Mon, 22 Jun 2020 18:04:40 -0400
Message-Id: <20200622220442.21998-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently ignore_msrs and report_ignored_msrs have a few issues:

  - Errors could be dumped to dmesg even if the msr access is triggered inside
    kvm itself (e.g., kvm_cpuid), while what we really want to trap should be
    either guest msr accesses, or KVM_SET_MSRS.

  - These two parameters didn't apply to feature msrs.

Each of the patch in this series tries to handle one of the issues.

Here KVM_MSR_RET_INVALID is introduced.  Ideally it can be an enum with both
0/1 defined too, but I'll see whether there's any feedback first about this
version.

This originates from a discussion between Paolo and me on an unexpected warning
msr access message that triggered on a RT system, which seemed to have caused
some system jitters.

Please have a look, thanks.

Peter Xu (2):
  KVM: X86: Move ignore_msrs handling upper the stack
  KVM: X86: Do the same ignore_msrs check for feature msrs

 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 90 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/x86.h     |  2 +
 4 files changed, 66 insertions(+), 30 deletions(-)

-- 
2.26.2

