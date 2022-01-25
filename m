Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616A549ACDE
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 08:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392292AbiAYHEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 02:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S248893AbiAYECo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 23:02:44 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE5FC06175B
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 16:44:05 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p7-20020a1709026b8700b0014a8d8fbf6fso4226879plk.23
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 16:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u4VGIN7MnjBD/esu2dZ6bpp8kPNc8T9BewNKDE5t7Y8=;
        b=aLI8+56PuLvfN1fzAD2XWbW4A0++oPvQCn26wmZlFQ9V0J+1TE6ATTRnbBvx3omWov
         5rJlgmBYdrY6kexb/WrtKuNYs6FD9klhhxQ3uScwo6PCT9iHOEcsYMIRtGrsXlesdwHQ
         7PX8xcrPkUV23SzrW7LisF2vmGJGIVV6iU15EF/K2benAbBhY0lzee7RzWYYyJwhqMOJ
         6KjJlDuOuxLjRzFEL5EBx+/tyh4s1PgSjNHhdIXo5tXvgfYwsxFa/fCgMBe3L+kidN44
         IrNL++0A0vU5bodenLvlseuLX18+xPsxVaNyvo2BpwXhuPVD4/IAi/0cXzzpg1DDMWot
         U3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u4VGIN7MnjBD/esu2dZ6bpp8kPNc8T9BewNKDE5t7Y8=;
        b=6UX1ClUqYrgTsMT1GbGt8yDktJarc0BQ/7cvDg59WrUkuDiZ0C/yc8ZM3tK4SNJPN0
         yew7u1dc0uNBn6tkPPotZhD8zoYcoF8qwJSAQ23EuCHjYfmbde1X3PC9U0SRwICYdqo2
         45/bKJon8MnP1h1f9AckTzSVJ1oP9cVYtCH9MSQGtHYKvBDz1tgHZ7Dr3vijXDdZrRTz
         OZAlsNxWTn18hgTiCQ+PYoTRFka40L6Fbm+Tks+VhHe9dc8Pj2Xa5vTtMIUH2jXNLd/l
         iXhexV/sexZPevSpmiXVKqOTWWXd35GBqg/pxizLZOXpzJLBp9Q00jxmenjLn0pozLK+
         zE/g==
X-Gm-Message-State: AOAM532f6IHVVDv4AGz+AkTOPLxWj0M3QVusK5J7coIAwCXr34xYiYLz
        1dxjuvr75IJLGnXaKlRrP9FSge41EY383KBDsnecY7EZCYS9nDx84X56Q1f0N7FSnafWcs6nxQY
        5gfpnYToCYHb3Sd/GYD8q0GxowDn9I5zSejkuPx3BqNVjMWS26GWBqoUJvlafy0A=
X-Google-Smtp-Source: ABdhPJwRVRW7HdqkKtt+Vd9/XyqW73yL4BZp8tZ/Df9pf61fLgBR1xlxjuaT53BhWfIgh67A7lB7IlJhNiJ3bg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:70c6:b0:14a:a396:8691 with SMTP
 id l6-20020a17090270c600b0014aa3968691mr16658075plt.35.1643071444848; Mon, 24
 Jan 2022 16:44:04 -0800 (PST)
Date:   Mon, 24 Jan 2022 16:43:59 -0800
Message-Id: <20220125004359.147600-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: VMX: Remove vmcs_config.order
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum size of a VMCS (or VMXON region) is 4096. By definition,
these are order 0 allocations.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 1 -
 arch/x86/kvm/vmx/vmx.c          | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 959b59d13b5a..3f430e218375 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -54,7 +54,6 @@ struct nested_vmx_msrs {
 
 struct vmcs_config {
 	int size;
-	int order;
 	u32 basic_cap;
 	u32 revision_id;
 	u32 pin_based_exec_ctrl;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4ac676066d60..185d903a8fe5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2603,7 +2603,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		return -EIO;
 
 	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->order = get_order(vmcs_conf->size);
 	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
 
 	vmcs_conf->revision_id = vmx_msr_low;
@@ -2628,7 +2627,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = __alloc_pages_node(node, flags, vmcs_config.order);
+	pages = __alloc_pages_node(node, flags, 0);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
@@ -2647,7 +2646,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 
 void free_vmcs(struct vmcs *vmcs)
 {
-	free_pages((unsigned long)vmcs, vmcs_config.order);
+	free_page((unsigned long)vmcs);
 }
 
 /*
-- 
2.35.0.rc0.227.g00780c9af4-goog

