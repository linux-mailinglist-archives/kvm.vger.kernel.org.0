Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C621530C2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgBEMam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:30:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgBEMam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 07:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580905841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FHRLTiRDFk91fNbjqjjK4sS7PVxxMVDiLVR/Xqc6yrU=;
        b=UhMSQxZBTr4ZDU1KXea5GiQYdiZTJ5e236pRR6HEuH04ydIouBi5HFyoZrga6IJHecYk0U
        NgZEWaDUBldwiDLnS/5qxhKuI3Y7SfF5c1MDx4NtQQ+p92Eygn+dUQ6UuEXW9LohjHwqek
        WhruqKDJnSoNjMStdpJuVTRxzU9jat8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-7t-6ssc6M8qd8GTTwJr-qQ-1; Wed, 05 Feb 2020 07:30:39 -0500
X-MC-Unique: 7t-6ssc6M8qd8GTTwJr-qQ-1
Received: by mail-wr1-f72.google.com with SMTP id 50so1126652wrc.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:30:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FHRLTiRDFk91fNbjqjjK4sS7PVxxMVDiLVR/Xqc6yrU=;
        b=KULmGoz3EaBGS3UXLnLiLESgXQ1q9t9toty8rd3Juwmi1qEkOrdZE1wIecITBx5/dB
         8f2//v3SedvrUSfxXrln+bKdQKLcoQydu8VcqOdlrXSDlqtTAVeNUM+Tn8+haXg0RaC9
         jeaNbV+uGOYIAbBoxRgEP6FlD3f2WmHxo9m7gRO5pca44vs79PMWoS7C1dKsmoakwVG7
         +ofRnT8jZMsD1wamurIYNfGf3aEXxmCGlP58BuB/dRvyicX6kHoMWaw0o4SdiV0nCwr7
         rTS1Z63ZD+zFUanuC4ZXi7Mdn4YlWnZWCtSoY6K1yHUiF2Cx/jL/4J3/zCMWV7zKtevf
         Fb/Q==
X-Gm-Message-State: APjAAAVXZdfNxDahierXiwSuXTGCl7molhbcLG+R2DVN0GzgMOF5aXH7
        2jvAjXDyp2zVuO9XIne+BevKoZKkoIYtPgZzCaLnHfWlPDPO/Yw7B088WdW5FV3tRiUc8R8vAJI
        KdiIgTf9cKL2F
X-Received: by 2002:a5d:5263:: with SMTP id l3mr27754227wrc.405.1580905838387;
        Wed, 05 Feb 2020 04:30:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxd5Bz9WYMUVNFZyA/vAWEUrG6f9LLsByb0bUcfyGjRUNIQyI+6xv9t7EQ2SbgTUNWO2yOMw==
X-Received: by 2002:a5d:5263:: with SMTP id l3mr27754211wrc.405.1580905838179;
        Wed, 05 Feb 2020 04:30:38 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g7sm34227251wrq.21.2020.02.05.04.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:30:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 1/3] x86/kvm/hyper-v: remove stale evmcs_already_enabled check from nested_enable_evmcs()
Date:   Wed,  5 Feb 2020 13:30:32 +0100
Message-Id: <20200205123034.630229-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205123034.630229-1-vkuznets@redhat.com>
References: <20200205123034.630229-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In nested_enable_evmcs() evmcs_already_enabled check doesn't really do
anything: controls are already sanitized and we return '0' regardless.
Just drop the check.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 72359709cdc1..89c3e0caf39f 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -350,17 +350,12 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	bool evmcs_already_enabled = vmx->nested.enlightened_vmcs_enabled;
 
 	vmx->nested.enlightened_vmcs_enabled = true;
 
 	if (vmcs_version)
 		*vmcs_version = nested_get_evmcs_version(vcpu);
 
-	/* We don't support disabling the feature for simplicity. */
-	if (evmcs_already_enabled)
-		return 0;
-
 	vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 	vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
 	vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-- 
2.24.1

