Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88D404065
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352352AbhIHVEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350641AbhIHVEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:04:35 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACF1C061757
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:03:25 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 202-20020a6219d3000000b0040b60510fd8so2164499pfz.5
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2d4nfleHWQk6Q9Qf0G0fpUlHYSowf2WbKKEPepaq7rY=;
        b=KO8+nZdJPGaZn8QnoYwVIdO6MCYkmTZJPROR2cBbazw7mJE6hHqqcxlqlX8x9nMenR
         1JnAjdtTMrvnwytbbDZGN96cia+5bwznuBBTpvRNfUvFfxXkklisBDog+L6QKk26Mdbj
         Ngyd6TF4iRVnj5SxMEdxyZb51mCZAUEI+f6hFIH4WHkd2usMHpnZLm/Zv/tBDdPj4VPq
         cRdMMaYlGTf122Cbg0BVD8wlsk871xqLrF1acNbFtDPlvpqku80pwdArsR9I0KvQOPn+
         w16PtXopOwPEvTYencl/xsWmv750SZsVi9OYo4tvaujFP8xWEPScXr5GHU32Jz6xKfjN
         NfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2d4nfleHWQk6Q9Qf0G0fpUlHYSowf2WbKKEPepaq7rY=;
        b=nuo3tjIpHnAK+o8WX/zb4hWx/dv8upk0sBtwaVMKE9GZgDvhxSuOx118iupvKkin5N
         qcr9FXN2QJ9T74+7otLxAZ7TjqjaFigiWe+tFR2iOznVMOZodBTvkqp5Q8Tw1rHBGYQR
         /hQkwT1ucHtB1o0ItLMrhc+pE7QGhXwOy+w7RW0tXBPh0BFEWBqLJqK5Kn+zP3Zd2cQ3
         gXDh1YmF/hbtjMGkADbTQaqhgUk703zlrbd3Q7A7eVHEZjadS1s362dVzGWLQ+MaSKHc
         sRFwlpSQMqZsFTyR82f0Qwz3BkuJfa/8m39oMEt0+M8eMxzupG0GZ8nMSi5Mb8s1VMTN
         TPQw==
X-Gm-Message-State: AOAM530FMefvtG5IY26Rb5KX09Mz9dsKlXRCyiwj0ku3TcfpA/hC2h7o
        L9agkGwH5Kgxw2qudbWdyS2F/zGoq8XnDIUwLLlmpF1Rv4Y7ITegL2Uz2GqyA/31NQIXaGbg4pW
        Va9GExr1HTj0KvTmw7bKp+fjAR9Yyv8gimcWuzrpmk1pTblwQxKa4LPuL7/fH82o=
X-Google-Smtp-Source: ABdhPJwIVSsg5yuM194jxyxXA4Dmfrn64eyhBy1C61zVrAz4sOc5g0bQEJ0nBw/uh8TR18zcER/UzQnsrIK3MA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:dc15:: with SMTP id
 i21mr168843pjv.64.1631135004439; Wed, 08 Sep 2021 14:03:24 -0700 (PDT)
Date:   Wed,  8 Sep 2021 14:03:19 -0700
In-Reply-To: <20210908210320.1182303-1-ricarkol@google.com>
Message-Id: <20210908210320.1182303-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210908210320.1182303-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above the VM
 IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend vgic_v3_check_base() to verify that the redistributor regions
don't go above the VM-specified IPA size (phys_size). This can happen
when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:

  base + size > phys_size AND base < phys_size

vgic_v3_check_base() is used to check the redist regions bases when
setting them (with the vcpus added so far) and when attempting the first
vcpu-run.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 66004f61cd83..5afd9f6f68f6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
 		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
 			rdreg->base)
 			return false;
+
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
+			kvm_phys_size(kvm))
+			return false;
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
-- 
2.33.0.153.gba50c8fa24-goog

