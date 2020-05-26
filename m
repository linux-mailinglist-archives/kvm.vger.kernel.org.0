Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278881CE898
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 00:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgEKW5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 18:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKW5B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 18:57:01 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E4BC061A0C
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 15:57:00 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id y60so9387710qvy.13
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 15:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VTdpLz5V6/LGlvRs4Pjdcz6Ell8P6OcCKx2MGJVF8uc=;
        b=BrN8i96Patmx0wBxgndIVZrgUBR4dw7eIKuHDar+HyJVTT6QqVTHolRVtwbmCYjqnm
         lu+dPn0CeyHU/Jnu31O1jVWcbXysRCr8x+ve9nLW/lcKzs2kLoB8TL7w2HB2ba4cjLsq
         feSOgcbA+M7ndKlGzozd7HAknoNu7O5Egnuu4qoIqL9Ix7TbpACtd/5ZLwMZMAKQscKe
         OXrSSWm0prZ9mN+cbcJ+5yo985+SqGg7GRWUAccKhSCs3I9OswpTwR8WFieWz7XEQUpM
         PMB91Ayu3PRldho7BlXCBS6WePWjBKg6g7XkxKvK5Lp7Tb4uoOKLS0r+E4P1jDh6yp/T
         f5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VTdpLz5V6/LGlvRs4Pjdcz6Ell8P6OcCKx2MGJVF8uc=;
        b=nYQkhaxycY72sK6Yo/MJCIkuQAeoDfhC6m8A8KCmfB22FfScZDxcY5QQFcuS/ZlALs
         M+LfvDl6O+7vfaaYPfOgEr/Is7PW8pvkLKvXZfJzeZWzFkTypZa+8XkQsrGM/t5sPSfE
         7C4XhMGJOjY9FeZIEtAEEk/xtlD0yJQ9C2mNVBSiFZ1EOfxf/A85bO6E9e76jAFTnAcC
         kzMTpGK76lumqKFU2rsk0hI6IpDZBRaSaaTk6ee42OkCaOWFeMBIikUn2qwQJq+/faUe
         2YWaX43UtBfgDFlR/0W2gry0jVsXNdj3vKUnF7h+5Rwgvpttb3K0XCAIH8ExQE+LyYzX
         cZXQ==
X-Gm-Message-State: AGi0PuaPMoeJJMoF009uPKxKX0U0RbHzEtFD2nRJ28JEYUFpOkUdrteL
        s/lwxv32kHFSsef9siRGh06ATlAj3p0PGurr+J5CnnDcxxbuJgOtNu/OD6QlikOEsTUKlP2/l7a
        0EfZ3vxPqJqCXQdzMWIRHx/qEtLdDurfRyeAFh5zKuBVveMDtRRNfNaZs0UkLKxM=
X-Google-Smtp-Source: APiQypJNIV9Soq4zFlRo7C4w9sAwU9layBGNtrWixcjD+1Oc1m3Tl3L1CUAiqIEcDjNfC78LeyGlWDBmTobeFA==
X-Received: by 2002:a0c:e7c2:: with SMTP id c2mr7976983qvo.118.1589237819159;
 Mon, 11 May 2020 15:56:59 -0700 (PDT)
Date:   Mon, 11 May 2020 15:56:16 -0700
Message-Id: <20200511225616.19557-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH] KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Jue Wang <juew@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bank_num is a one-based count of banks, not a zero-based index. It
overflows the allocated space only when strictly greater than
KVM_MAX_MCE_BANKS.

Fixes: a9e38c3e01ad ("KVM: x86: Catch potential overrun in MCE setup")
Signed-off-by: Jue Wang <juew@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d786c7d27ce5..5bf45c9aa8e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3751,7 +3751,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	unsigned bank_num = mcg_cap & 0xff, bank;
 
 	r = -EINVAL;
-	if (!bank_num || bank_num >= KVM_MAX_MCE_BANKS)
+	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
 		goto out;
 	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
 		goto out;
-- 
2.26.2.645.ge9eca65c58-goog

