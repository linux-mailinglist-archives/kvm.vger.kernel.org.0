Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D806365921B
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiL2VSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbiL2VSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:18:05 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBBBBF70
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:18:04 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pB0Hn-001cOQ-6B; Thu, 29 Dec 2022 22:17:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=Cw4Vrb2FZzm+VLmtwHzRrpi9COIilDxPuIqgvfvFxUM=; b=Wp3fa7EDvoPAy4ukNmJJMSTuxB
        YxUtrKkW+h0Y1WIl07yfCwneuYGMHed22+W73H2r8UI+EfGX4NYVZirtsdOXMkNvdY7FdjhZ0f92J
        /s4e9UfXqA2GqVz2OwiXM7wchV4DlyQo1JBQaa9bDg7c2BqYY61hcgF27r72jI2tw20pKN+oLr2Ls
        wo4aYny0i25Wpnt/1H0jZjE+PjmEo9DqTATvIUzdpFFfQYfk+j0rn7o3mMRCQgg7PLcqh/MxSj216
        lML8bNnhexP/Z5lU9WgTDH/gMEWQba4lBf81mgGnIlS2i9gkbGeRZvt/TIR1YsLOojP31wSP89g7G
        tizt7JLw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pB0Hm-0001uj-Od; Thu, 29 Dec 2022 22:17:59 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pB0Hf-0003k1-E7; Thu, 29 Dec 2022 22:17:51 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     dwmw2@infradead.org, kvm@vger.kernel.org, paul@xen.org,
        seanjc@google.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/2] Fix deadlocks in kvm_vm_ioctl_set_msr_filter() and
Date:   Thu, 29 Dec 2022 22:17:35 +0100
Message-Id: <20221229211737.138861-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've moved the synchronize_srcu*() after the mutex_unlock(), but wasn't
sure about kvm_make_all_cpus_request(), so left it, as it was, under the
mutex. Or should it be moved out of critical section just as well?

Michal Luczaj (2):
  KVM: x86: Fix deadlock in kvm_vm_ioctl_set_msr_filter()
  KVM: x86: Fix deadlock in kvm_vm_ioctl_set_pmu_event_filter()

 arch/x86/kvm/pmu.c |  2 +-
 arch/x86/kvm/x86.c | 12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.39.0

