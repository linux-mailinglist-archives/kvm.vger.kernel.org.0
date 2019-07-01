Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529B956872
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfFZMRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:17:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42651 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZMRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:17:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so2464236wrl.9;
        Wed, 26 Jun 2019 05:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=sqVCItjMY3+HDhxAqrBSkaqzCTGRuM/71J/XyWqeX94=;
        b=iEu4CD5vm7tPd0O8TZI1F++F+/iQLR3jk6q9M/anjqq48J+RjhmhA9vN7noIKUBBBC
         +jNL7rmXXpIm7vDXDmD8Q/LSadQt2yjZ1PSuuvxjoaUjx8/utNUcwOB8IK4Ph+bbD1Aw
         nt555EXvEUcUblFyfVaLLiQ0pxA/3CfwaagqIbsx4WKYVsOfymhHrsXKeHoeArJKZrTK
         JSncBA9obTj16OC904mw+UXA5N3aJjXse4c7287Ks3dUwTdpg9QDAONhN6BJMzHh1EGh
         vuy19nJNXy0N5MgkP1Mp84No0oTxIh3g2IEEQoOwNUcQjMP5X5tlYj+ziLRHnJp+XBxq
         vc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=sqVCItjMY3+HDhxAqrBSkaqzCTGRuM/71J/XyWqeX94=;
        b=lTzyVgy31JfTXkEB8//mWUJWzCbbMnTQ+Reynz4yqsW5yivdknNeU1ar2gZdJS08ps
         NR5xAx6l1TzRK0aqhjLJF9oD0Gn7QjZJRXAHnDKADnNPeNLUnc9mOObEOUHLo8EViX5p
         8gysHxNPk6rAyEzNg2HTqLrK5de0GgH+M1g50dIXClqdSw4TCQ2upR58New7gM8ZVsOv
         MVZ2ibO2IX8+1ND/ACxjOudq0Q/54yT/dQVRjtxHcb7ekq1oDXpRV/GozwGWTaxTcoUP
         q6HwaFaxrlIhB2j0VGpCV+rprSF0uBRtlVQ8mEHlmULlGr1WjrvtR9Ej5APHEXv7wkXI
         mMoQ==
X-Gm-Message-State: APjAAAW3SW2bdQoojeqmADTO02GStdRMLKPxeNIIVNqO4biU4SQclq6v
        hfvd56pLPkcvZRHHUhCE7l6jo/rmA0w=
X-Google-Smtp-Source: APXvYqzhzLnKVk834rarVTHbcHKk+MdY4iRH5H6XcsAVTLQk6RKcN+cVTzTubSzMT+sQG+e1Py5XMw==
X-Received: by 2002:adf:f84f:: with SMTP id d15mr3420086wrq.53.1561551469106;
        Wed, 26 Jun 2019 05:17:49 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 35sm20821248wrj.87.2019.06.26.05.17.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 05:17:48 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Alexander Potapenko <glider@google.com>
Subject: [PATCH] KVM: x86: degrade WARN to pr_warn_ratelimited
Date:   Wed, 26 Jun 2019 14:17:46 +0200
Message-Id: <1561551466-13173-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This warning can be triggered easily by userspace, so it should certainly not
cause a panic if panic_on_warn is set.

Suggested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83aefd759846..31cdb0b8d418 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1557,7 +1557,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 			vcpu->arch.tsc_always_catchup = 1;
 			return 0;
 		} else {
-			WARN(1, "user requested TSC rate below hardware speed\n");
+			pr_warn_ratelimited(1, "user requested TSC rate below hardware speed\n");
 			return -1;
 		}
 	}
-- 
1.8.3.1

