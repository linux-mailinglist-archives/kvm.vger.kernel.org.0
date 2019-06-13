Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C849F4482F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbfFMRFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:05:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44561 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbfFMREL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so2443176wrl.11;
        Thu, 13 Jun 2019 10:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TvR+qacB0dElZBTDtoEVLoMecN1BKRn3OKtcYkb/IRc=;
        b=MMesGwHFFtcqnV48ZxMA6d2UfuiyohNZumYugfdKgulqSIczIG6vuXasYczBqvAmm2
         OCOGyu/VwJEve6urUo7A56I6j2GbtbYOOharz6fwU69iWQlkzwz2uzr5d3Z/KIBdPUPr
         IXBw5sS0eJHdF3SGbtLmNnraJsIgmOIcWA17b/OpACnnvbU526VB+8rV8cSNIqtlpgOd
         aSGINKX0atvA9L7QgRDfyKcME1vxIsMD1hg8YPz0UuafLMM+sZg1EE3tjrfLJRkLZDlj
         lhwA8mWxTcVyI4sDfWzSDJJF9gzvyNUrx9vP4z+ZLuuOSOwDrVg8yGdJEp5yZsokIAmb
         03jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=TvR+qacB0dElZBTDtoEVLoMecN1BKRn3OKtcYkb/IRc=;
        b=B75kkr9R7M4vgS3GzSeNLHPk/cfAuj+IuwsF9l1tamU9CNgabqOG64r9FHCj9aPN3W
         8ra/kHiwjy1wzOoAsPRNLV1SZ0MFQ8abT1rDobN22Hk8I0jQt7v0aqyRBObETmY/ExTE
         Nyat5CUlBl3BLF4/5ugmnSbTJs2H5baL8M+5uhfcwEC5mosgd9A050E2I/uu5ECIyNCG
         iSNPIYtad9JgBH5i/CQAW3D+FJ8A4I0uH8hE/YmfOeNCOuUncshGwR84Phqku93SX559
         XgM2STK6zIpgQVsNAndxJDERuv2Zo6NS4+3ujXiT065KX8D1aUEPV2EPRVUSC/B8a7xH
         lqQw==
X-Gm-Message-State: APjAAAXQPAxylxMn6LXM0a8BcW++Gh+1g6SGJcRBRFq4+RLJxxqK8rjj
        PGQ2a2reO8gJtZ9OH9o3oQ1AZuBE
X-Google-Smtp-Source: APXvYqylnbAyOTeBmB+6uSt17wKY6D5mbP5m4R+L0m0pKkRI/na8cyGPKMaLizDL33GZSkddMLvVmA==
X-Received: by 2002:a5d:430c:: with SMTP id h12mr4990012wrq.163.1560445449464;
        Thu, 13 Jun 2019 10:04:09 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:08 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 37/43] KVM: nVMX: Don't reset VMCS controls shadow on VMCS switch
Date:   Thu, 13 Jun 2019 19:03:23 +0200
Message-Id: <1560445409-17363-38-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

... now that the shadow copies are per-VMCS.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 5 -----
 arch/x86/kvm/vmx/vmx.h    | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9703fcf19837..47adafa42fbf 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -283,11 +283,6 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
-	vm_entry_controls_reset_shadow(vmx);
-	vm_exit_controls_reset_shadow(vmx);
-	pin_controls_reset_shadow(vmx);
-	exec_controls_reset_shadow(vmx);
-	secondary_exec_controls_reset_shadow(vmx);
 	vmx_segment_cache_clear(vmx);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7616f2a455d2..6f26f3c10805 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -388,10 +388,6 @@ static inline u8 vmx_get_rvi(void)
 }
 
 #define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_reset_shadow(struct vcpu_vmx *vmx)	    \
-{									    \
-	vmx->loaded_vmcs->controls_shadow.lname = vmcs_read32(uname);	    \
-}									    \
 static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
 	vmcs_write32(uname, val);					    \
-- 
1.8.3.1


