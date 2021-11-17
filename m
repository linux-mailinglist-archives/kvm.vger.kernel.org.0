Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A84547C8
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbhKQNxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbhKQNxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:53:01 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94B2C061767
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:02 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a9so4831116wrr.8
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZlhS9+hm/75AEdjyPnf+x+bwSMKCsgpovkZ5CEnhVG8=;
        b=WVEm6kvj/DwXsgUgfQqd744Jq8PeuJfSqfK6A6kQaq3w2t6CoSncSYT7I8FpYzphGd
         THLBiTAy8Yt1IB+VLqNxlgkgcjhIQ+n+1W2VKrxfsg0IK+y7w4O8prHos3KCXgByNsdA
         oi3vdARuhRIBJHUgf1LdICMzF6F/X4PsG4ORvM/VLqJEatPE5tiS7u6ctfONW6BfUwii
         J5MqKTDfLQrUNU/Lw1ETjPoJr/889y9NSNa9ycu0hsa6qPJDLihUY0/7RIv+2CKVhW/j
         Vd+H6lchlyyWn7jYIj1E+2ANQ9uLwifpYN/dv0GOGwHnuRd4E8cN1bY0IugX+d2o7Z/Z
         sGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlhS9+hm/75AEdjyPnf+x+bwSMKCsgpovkZ5CEnhVG8=;
        b=hMl4MR/n46mnMJlvVBrSwb4LeBC9o4qBqmZKQRAgKMtpAr33cUhcoDEMZWnHP/n2tI
         V2utd/ksNezSK/n/ofPMaUF1m1yXFW371ljmnK/MD2tIOZpfp9csRryxU3FuC3YVf8T+
         WWxdYBp0is48ngR8+EqsS41F1Hk500mStNeMbgwyLS4B/qseTyPeUp1NSSVwaEqWbF2F
         Yi8Ji9dbW2nwXBsLuGItzpNuqR8SoU+On0bh+coISEb7pzTwKTwpetrdQ55hfbC44zl1
         NdaNvTDylPSzW9jyq5hqTFNOQS721mRyzASSJBgyJkQSi7ArW6IXivP8n6h3yT0Xfk7F
         Isyg==
X-Gm-Message-State: AOAM530aLSdsdhlQR0WE11J4mB0CLbfwlaB6HUq4Y2Ni4o88BQ5omqGU
        3RsbdyFNTchg8s73lnQzUcn6O6BiVatiGQ==
X-Google-Smtp-Source: ABdhPJzk7mcU46bcC2WpBJGPG3KEw+R1ZTBEt8Sg6rXHo7Pui3KAn+uOaORtb2JpG5VbPSAQAu0O5A==
X-Received: by 2002:a5d:584c:: with SMTP id i12mr20641030wrf.95.1637157001064;
        Wed, 17 Nov 2021 05:50:01 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:50:00 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 09/12] x86: AMD SEV-ES: Handle RDTSC/RDTSCP #VC
Date:   Wed, 17 Nov 2021 14:47:49 +0100
Message-Id: <20211117134752.32662-10-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's RDTSC #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 91f57e0..45b7ad1 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -153,6 +153,29 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 	return ES_OK;
 }
 
+static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt,
+				      unsigned long exit_code)
+{
+	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
+	enum es_result ret;
+
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_rax_is_valid(ghcb) && ghcb_rdx_is_valid(ghcb) &&
+	     (!rdtscp || ghcb_rcx_is_valid(ghcb))))
+		return ES_VMM_ERROR;
+
+	ctxt->regs->rax = ghcb->save.rax;
+	ctxt->regs->rdx = ghcb->save.rdx;
+	if (rdtscp)
+		ctxt->regs->rcx = ghcb->save.rcx;
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -166,6 +189,10 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_CPUID:
 		result = vc_handle_cpuid(ghcb, ctxt);
 		break;
+	case SVM_EXIT_RDTSC:
+	case SVM_EXIT_RDTSCP:
+		result = vc_handle_rdtsc(ghcb, ctxt, exit_code);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

