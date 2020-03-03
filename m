Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99FB177912
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgCCOdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:33:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729177AbgCCOdY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 09:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583246003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eKkzvWfCT/rGHHgN9ulO4K42Kuyz8FLmS0u2A3ohfjg=;
        b=IfVVnb+fi5UCYk6JO1Ryzj9zTuzU7/AqQBXrtniN80/j1s35p4y+GQQgDlneMKMhyoSfY4
        pbR9KgUWhAQDoj9l9EB+s/I4NjPTyZ1QVlunoVo3tBFO+Bb2JtwCheOnI3Y+rWy6j5XIHA
        fQ8TmU9XicxJ32WPB+Z5Wh2tYlx6Yjo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-dgcx_te_OsGsBn7OvKUUow-1; Tue, 03 Mar 2020 09:33:20 -0500
X-MC-Unique: dgcx_te_OsGsBn7OvKUUow-1
Received: by mail-wr1-f72.google.com with SMTP id 72so1298872wrc.6
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:33:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eKkzvWfCT/rGHHgN9ulO4K42Kuyz8FLmS0u2A3ohfjg=;
        b=HfGgi2zAxXdgOZNg/jwpCsELuRbuCUwEjIWRWZDy9eAprUOoxwU/8H24Uqniw/CreK
         u9UPtvKxVU15BNYUPpwlTVIA3gGcTn3gxLR7nCQVxkJcb8CPq8Hzomi8wCh4hebtb9j+
         jqw8CWGe9y1/UKqsIIDEbkMvNn9o5h36FhEJeFfqeBqz+6Ba+qPAi2Ww5cIm7XlrC7Ul
         56iUYSv4LA7uCRJIeqewMkBSOofLgB+fMTfrnJl8x1Wp1FqLX0/i+dA1r0cwuDhYpdzi
         NXhlT3GAKvSWB7tquJYr0yhr7ckZL9J0zhlfkZSIJe4+tKDyeiIUM99BG3TZPE+6TBxv
         p0rA==
X-Gm-Message-State: ANhLgQ291+ceJcuYA0nqnIwacqADATMC9aP2LWEDfrGO+bCJs4Ip4iCi
        7GuxJ9qgEOAg/fGz/BWBrYuiinJnn+tUJFpsKEy805vskhEzqsEtZnPSecKgYSuNl1kx+JS/Hed
        5GBQlsyBpVVqf
X-Received: by 2002:a05:6000:12d1:: with SMTP id l17mr5426139wrx.327.1583245998956;
        Tue, 03 Mar 2020 06:33:18 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuh4OGE/Mw192/tAEELL/A48sw9lwJA5J10+koNsf1V2Sdz5rHD/kuhdwpWLwvXp6mm2DxkjA==
X-Received: by 2002:a05:6000:12d1:: with SMTP id l17mr5426121wrx.327.1583245998726;
        Tue, 03 Mar 2020 06:33:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s5sm32248504wru.39.2020.03.03.06.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 06:33:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Bandan Das <bsd@redhat.com>, Oliver Upton <oupton@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: avoid using stale x86_emulate_ctxt->intercept value
Date:   Tue,  3 Mar 2020 15:33:14 +0100
Message-Id: <20200303143316.834912-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
mode") Hyper-V guests on KVM stopped booting and tracing shows that we're
trying to emulate an instruction which shouldn't be intercepted. Turns out,
x86_emulate_ctxt may hold a stale 'intercept' value.

This is a regression in 5.6-rc4 and I'm marking PATCH1 for stable@. The
commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
is, however, correct, it just seems to reveal a pre-existing condition.

Vitaly Kuznetsov (2):
  KVM: x86: clear stale x86_emulate_ctxt->intercept value
  KVM: x86: remove stale comment from struct x86_emulate_ctxt

 arch/x86/include/asm/kvm_emulate.h | 1 -
 arch/x86/kvm/emulate.c             | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

-- 
2.24.1

