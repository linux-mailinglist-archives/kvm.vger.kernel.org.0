Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E93A0F6A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 04:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfH2CVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 22:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfH2CVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 22:21:30 -0400
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65706811DE
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 02:21:30 +0000 (UTC)
Received: by mail-pl1-f199.google.com with SMTP id p9so1120534pls.18
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 19:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0ntCxjTGtKbzFXJg3nlEr8z4Qg5JGGVYpSbuyABl2w=;
        b=c2BM2RLpsj7vnm7gv+7Lx3xX7Qsl5nTo7E7cP8Rvnb6ikVUvlpb3tQrssdq6MJk8MU
         V5gIkFvB8IgqS3bQL5mntzf0aBbmbVs4a3BItg36s/hje48vXivsnMMr1+4DcXAJ1dEH
         cm3eXFPl+S0+vhdGnPkKYY/SiZEPogEB5WmbdCD8e/uTRsA1KcwDZ33oxe1+hUfuNceL
         jTEd92tGomH4r2dFN/UgyaCLqP91W2zBTGnqOxnExCE8HDnhsOXORfjA3gTBxj6Nyydq
         Fsl9QQl63vxM2N9zrqY94RknD0UxryASGcNETeyaJ/4F/ZDnj7JXGZAFvwMtnSUmXFRr
         NMcA==
X-Gm-Message-State: APjAAAUi0eBElkuBXm1eQuxPfW4jX5t1wEgMn0INB4Ifsh4aPssLMJSA
        Ka2PvzjAgIYJ1seStqg0rvY/Ls+Kd1UX2l3UShEU2y2kdwotW/TOB2d1INH/Pc9MLP7u4sAWtk9
        7W74nC9loEOvK
X-Received: by 2002:a17:902:6a82:: with SMTP id n2mr7070926plk.53.1567045289861;
        Wed, 28 Aug 2019 19:21:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMezApsFpPfMPo0+CoJhPhtkIA4wIFy3VnvhRI32O80EhZ8+FMosGoBfvA+xbB/1GKt6+MhA==
X-Received: by 2002:a17:902:6a82:: with SMTP id n2mr7070908plk.53.1567045289670;
        Wed, 28 Aug 2019 19:21:29 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j187sm750140pfg.178.2019.08.28.19.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 19:21:28 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH v2 0/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Date:   Thu, 29 Aug 2019 10:21:13 +0800
Message-Id: <20190829022117.10191-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- pick r-bs
- rebased to master
- fix pa width detect, check cpuid(1):edx.PAE(bit 6)
- fix arm compilation issue [Drew]
- fix indents issues and ways to define macros [Drew]
- provide functions for fetching cpu pa/va bits [Drew]

This series originates from "[PATCH] KVM: selftests: Detect max PA
width from cpuid" [1] and one of Drew's comments - instead of keeping
the hackish line to overwrite guest_pa_bits all the time, this series
introduced the new mode VM_MODE_PXXV48_4K for x86_64 platform.

The major issue is that even all the x86_64 kvm selftests are
currently using the guest mode VM_MODE_P52V48_4K, many x86_64 hosts
are not using 52 bits PA (and in most cases, far less).  If with luck
we could be having 48 bits hosts, but it's more adhoc (I've observed 3
x86_64 systems, they are having different PA width of 36, 39, 48).  I
am not sure whether this is happening to the other archs as well, but
it probably makes sense to bring the x86_64 tests to the real world on
always using the correct PA bits.

A side effect of this series is that it will also fix the crash we've
encountered on Xeon E3-1220 as mentioned [1] due to the
differenciation of PA width.

With [1], we've observed AMD host issues when with NPT=off.  However a
funny fact is that after I reworked into this series, the tests can
instead pass on both NPT=on/off.  It could be that the series changes
vm->pa_bits or other fields so something was affected.  I didn't dig
more on that though, considering we should not lose anything.

[1] https://lkml.org/lkml/2019/8/26/141

Peter Xu (4):
  KVM: selftests: Move vm type into _vm_create() internally
  KVM: selftests: Create VM earlier for dirty log test
  KVM: selftests: Introduce VM_MODE_PXXV48_4K
  KVM: selftests: Remove duplicate guest mode handling

 tools/testing/selftests/kvm/dirty_log_test.c  | 79 +++++--------------
 .../testing/selftests/kvm/include/kvm_util.h  | 16 +++-
 .../selftests/kvm/include/x86_64/processor.h  |  3 +
 .../selftests/kvm/lib/aarch64/processor.c     |  3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 67 ++++++++++++----
 .../selftests/kvm/lib/x86_64/processor.c      | 30 ++++++-
 6 files changed, 119 insertions(+), 79 deletions(-)

-- 
2.21.0

