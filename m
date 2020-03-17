Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9372187849
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 04:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgCQDsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 23:48:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40612 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCQDsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 23:48:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id z12so11159085wmf.5;
        Mon, 16 Mar 2020 20:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHjQnX3gyUEuVprG/+YZpKO/PfRLqvF0oJQ7HCGTFS0=;
        b=Z2Sp00dgeLuJIlIXyHvryPtiTE1luukRM5GlvrkGrz7DkwFgaT/ME1v5tvagQgTfC5
         dCVrvPw3liBcDM0LIAZTBjnWH5Letev+epOYTX7s/gjaHCeTRR6O2uzTnbjHFVTWgbPT
         J+FqHJ2JmI960U2RlqpelMgtWnF4uuQhOuvVEdlk6Fomzo74/Jw/0iAbJNlaaeY6t5pj
         M06JN1Qsuug6wkqVfnBAbSvjc6rLynFjviGCqdqKj05wYZvHSQ51C5QSkHeovEFhJofD
         9wSlsn99ySMLpU9SzrYZ4IBF+0RDe7ATIUch5u2n7t4VEIdcffGm49Me4VA7hgr7Udi0
         0w5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHjQnX3gyUEuVprG/+YZpKO/PfRLqvF0oJQ7HCGTFS0=;
        b=SyBt2qENgszriy4qGwYB2ALfylVIuKbiV3i7UGgceAUHlrJRUf9mcXrFZnUpYhXWcS
         LNHMwGcXl8xJZJhtFwQFVCFmiTbxIpe5IPbYB/LHpsi0st54nxhVcmRXDgyRFi6h6xMK
         39pz2hLRrBBtAelD8dU7aMm5KWVp7cHQ9ZvvEDhmQhI/o0QxvH4v7CxJAlHtRfrlD3pG
         s8hFNEOqnYR/emmK6uD7kMendfoxeGBEk4CNm6pGwJ5jqy8pGU+2I9/2r1fLiPD+plHn
         TvMNNsAPskHQSFm3HDbv5cO/06EW4iMrPuRrya5o7+i5X5KSri/JgGHq8y9prxXylSmn
         I57w==
X-Gm-Message-State: ANhLgQ2zu+PNPZj4iXlcVr9+VshKG2zIHtOU0QWmU5sntNTOVsr5LkV2
        YM+4KAj7pkIQFXKfGqqpgIKUvPaPq08=
X-Google-Smtp-Source: ADFU+vsShTIWnHo0+okT2rb7ONQw+dICYP2M+Cl4A0ALnWk+85SFBoIxrkX5HCMrUfjJyfCmqg6hiw==
X-Received: by 2002:a05:600c:22cd:: with SMTP id 13mr2564058wmg.186.1584416908643;
        Mon, 16 Mar 2020 20:48:28 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id c23sm1457757wrb.79.2020.03.16.20.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 20:48:28 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v6 4/5] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Tue, 17 Mar 2020 05:48:03 +0200
Message-Id: <20200317034804.112538-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317034804.112538-1-arilou@gmail.com>
References: <20200317034804.112538-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
page and simply identifies the CPU being used (AMD/Intel) and according
to it simply makes hypercalls with the relevant instruction
(vmmcall/vmcall respectively).

The relevant function in kdvm is KdHvConnectHypervisor which first checks
if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
0x1000101010001 which means:
build_number = 0x0001
service_version = 0x01
minor_version = 0x01
major_version = 0x01
os_id = 0x00 (Undefined)
vendor_id = 1 (Microsoft)
os_type = 0 (A value of 0 indicates a proprietary, closed source OS)

and starts issuing the hypercall without setting the hypercall page.

To resolve this issue simply enable hypercalls also if the guest_os_id
is not 0.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b6a97abe2bc9..917b10a637fc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1639,7 +1639,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+
+	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
+	       READ_ONCE(hv->hv_guest_os_id) != 0;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
-- 
2.24.1

