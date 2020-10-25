Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F37298336
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418323AbgJYSxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Oct 2020 14:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1418311AbgJYSxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 25 Oct 2020 14:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603652023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zm0y/NgV1CA3qc6DHTxR8W397xZffPB2LchwQHAbN7M=;
        b=dGfpNcA+RrUIIDWBz23tZ30VjJ0lEW8OfU2DQumODvkEOQtn6y3NoTsU/ZlLBUUmqiE/1v
        HWsWyfXkLbosYfhS0BKlHOi1HsMIgMjK/GKhtm/cvM9xbkGIDH5ynM5byqeOiHuptdTsGP
        iTulOBVKd0m1Jkhx1ErjWHeg+DQbrKE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-fbrYhVQ9N3-7zSrB5FUIiQ-1; Sun, 25 Oct 2020 14:53:41 -0400
X-MC-Unique: fbrYhVQ9N3-7zSrB5FUIiQ-1
Received: by mail-qt1-f199.google.com with SMTP id f10so4893943qtv.6
        for <kvm@vger.kernel.org>; Sun, 25 Oct 2020 11:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zm0y/NgV1CA3qc6DHTxR8W397xZffPB2LchwQHAbN7M=;
        b=Th778N8IhkivVSyncmm3p+pB7qV1lIL7Xr/hlh9JHoeCA7H0X5iTlGNuk4W525Qqne
         4OeTam79dCiu/bL8XxzY0ZPUdHS1IO3VY5VhLmk18BVnaRfX1Hly8bUTg1b+iOn3yoaE
         /Ndd+2EzzErFWY/WsY8eByYzlMr9GcRt7VUiqw5CvwUmGWq6D2lZICC4+P5c/79RF6iF
         nQuc5tIIGoho1nsxqnBPew5eyg8WiQaz3dgmTwqnHruB86LOPX3jjUwRGnGryr8LWBSA
         KwYiVlSMqqaJop5qIo6tcHbqgc6gxMirfCVfkcvzljJAoH9rDzKHwG3hTGLZAeapQgLg
         TGNg==
X-Gm-Message-State: AOAM530qEpcznsI7HRJyjd3VXoj6VM8m5vrKDkfpcj+654txC+YDypNg
        uNYUukdLVXOGefwjCUiljNO59bk9bJz+naeqi7K1+/8dmIoVaMqtyTzFJEG6Ta6bevZ9saiyJfe
        m5cHZxjoqbsX3
X-Received: by 2002:a37:a5d4:: with SMTP id o203mr13829917qke.40.1603652020634;
        Sun, 25 Oct 2020 11:53:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyWNSYqgjU/lO0p0UapTK2q5MU0iTqDM8Kql9oXtrbn3a+VgKT8IStndVitg5xOQZJ2pUuRw==
X-Received: by 2002:a37:a5d4:: with SMTP id o203mr13829901qke.40.1603652020413;
        Sun, 25 Oct 2020 11:53:40 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id y3sm5305224qto.2.2020.10.25.11.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 11:53:39 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Steffen Dirkwinkel <kernel-bugs@steffen.cc>
Subject: [PATCH 2/2] KVM: X86: Fix null pointer reference for KVM_GET_MSRS
Date:   Sun, 25 Oct 2020 14:53:34 -0400
Message-Id: <20201025185334.389061-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025185334.389061-1-peterx@redhat.com>
References: <20201025185334.389061-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_msr_ignored_check() could trigger a null pointer reference if ignore_msrs=Y
and report_ignore_msrs=Y when try to fetch an invalid feature msr using the
global KVM_GET_MSRS.  Degrade the error report to not rely on vcpu since that
information (index, rip) is not as important as msr index/data after all.

Fixes: 12bc2132b15e0a96
Reported-by: Steffen Dirkwinkel <kernel-bugs@steffen.cc>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce856e0ece84..5993fbd6d2c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -259,8 +259,8 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
 
 	if (ignore_msrs) {
 		if (report_ignored_msrs)
-			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
-				    op, msr, data);
+			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
+				      op, msr, data);
 		/* Mask the error */
 		return 0;
 	} else {
-- 
2.26.2

