Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA271C5C65
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 17:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgEEPr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 11:47:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729569AbgEEPr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 11:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588693677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EQ23tM5kMyn811fS97lNvm/DAC1rh32RC7gp61B/0ws=;
        b=G/NxtHkzBV4UitB7b8BupWaK+oJ4B+tvYn71++9gYEKYuT4yvfdpTWB+4/JVqv4uB0XL7u
        /m/6ViANMTy3z0HSJzJspeWX8yP0lJHEFNLM7Wnfr0CQXZeaG6DSqD8LrlHEri/DDKBg2O
        dfUlk3I4ioORLfEIR/7rizOj+HHnHug=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-ekGlSkOgPRm2NexKPgRNDw-1; Tue, 05 May 2020 11:47:53 -0400
X-MC-Unique: ekGlSkOgPRm2NexKPgRNDw-1
Received: by mail-qt1-f197.google.com with SMTP id q43so2114054qtj.11
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 08:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EQ23tM5kMyn811fS97lNvm/DAC1rh32RC7gp61B/0ws=;
        b=KwLCTfjcvcopc34KHghMGC2GB8oF62NoE5rnHozwRoSYigtOWViY+qiIuxcYPly8nK
         j64ufjKw/qbG4d+aoY54xKjf0P+enHRBL3pAUVJ/JCdSohDWjqRGYKHsZ3h0oLhpZz0I
         v1Bl1uMlR+an223DrF2hAlZosiUFOmvvxGofjcy8yeyzn5MbsFCUuKlX7r+nU94gzx9H
         qHU5wf+WcT6ClXy0l8l4XugV+eixyZfHmyY3qJtJPcv3oNAp2pC7wtpkhBXymPlpUBjo
         GvuE1TXT4WuWHLyqCnDCgUuTKvD56vxzqGcgNMppWZj9OkKWB2+H8Nbtc56m8bHZ7LOz
         3kzg==
X-Gm-Message-State: AGi0PubzXcnqU1PpOEG9FkBXhtST7sZZLD2G3K57waGPZtC12KmxiWEs
        IoHLs4IHBu6EAga/sfQ3Za2yaBFaL10GFJRiZpnLHbEhoSLKfUezLKu2RMJp5OI0IKVPvZ+4zaK
        KSQLL2dfROlFt
X-Received: by 2002:a37:af05:: with SMTP id y5mr4261809qke.471.1588693672989;
        Tue, 05 May 2020 08:47:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypLoIwGDPk77az/a2DrITfutNeyY8xsNdsMX2fUvJgFNvtmn7qg0F/iELQj44ngrT8/uGNZ7sg==
X-Received: by 2002:a37:af05:: with SMTP id y5mr4261783qke.471.1588693672668;
        Tue, 05 May 2020 08:47:52 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id u5sm2081443qkm.116.2020.05.05.08.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 08:47:52 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
Date:   Tue,  5 May 2020 11:47:50 -0400
Message-Id: <20200505154750.126300-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_SET_GUEST_DEBUG should be supported for x86 however it's not declared
as supported.  My wild guess is that userspaces like QEMU are using "#ifdef
KVM_CAP_SET_GUEST_DEBUG" to check for the capability instead, but that could be
wrong because the compilation host may not be the runtime host.

The userspace might still want to keep the old "#ifdef" though to not break the
guest debug on old kernels.

Signed-off-by: Peter Xu <peterx@redhat.com>
---

I also think both ppc and s390 may need similar thing, but I didn't touch them
yet because of not confident enough to cover all cases.
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..ac7b0e6f4000 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3385,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
-- 
2.26.2

