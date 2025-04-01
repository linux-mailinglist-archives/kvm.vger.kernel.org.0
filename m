Return-Path: <kvm+bounces-42334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9144FA77FDD
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52D7416BCD2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2290D20D51F;
	Tue,  1 Apr 2025 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ULO3mU7B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC18520D4EA
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523880; cv=none; b=Mc3eyZDBGgW9Z36QrQx6rO7LJ23/zSp5nWCcv8Kp2G5rUckxsIqytlHdumgBXByC/NWo6QqOt8DFw8dSQgdsEc5jFQvvaaw7/jp6mDwntZ/1MdzGTgz0L4bnqy3WhK65RYHIscHTmArURWKV3tHAeuayuoVIh/zLsxkKNBFogWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523880; c=relaxed/simple;
	bh=P8Cr7Z2TxPF0ktXGH33ko7FhabI+md/UaeO2mhqlq9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNACYhvKZPCxURyciIDWfdf4d1VihK5gpPuwWIP+OxkO+xrxd8cXbfEdwQUi5z5pPL8nOs8nFbLE+m2ypczz1juJpI82aaj6AR1swfJiAQGg1PzGHAFhYPPXtbgO0izUgdvUQj2UrgT4bEKZVajxXJe6VxNvfUl3UuPQZp/mUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ULO3mU7B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xan579+d7KgslaidCIf/x6Agm9xb9cfRwwriUXqq5BU=;
	b=ULO3mU7BXpBsWMA+GR69gvq9KqJeRcSugHwjw6wxevybFPbNWkGFuyuoVR7yKWG54EQQWB
	GPoh+rOiMGKIpuyQj7TAcuilN88a6BpgI8wRWvXkfhK5Mri2mDafrx1TBBru1EMg8NjTm5
	kxc6KPShh/W9HBR5j/L38sO1Y4Efr4s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-dEegEXiZMc2Gq1YSlgMenw-1; Tue, 01 Apr 2025 12:11:16 -0400
X-MC-Unique: dEegEXiZMc2Gq1YSlgMenw-1
X-Mimecast-MFC-AGG-ID: dEegEXiZMc2Gq1YSlgMenw_1743523875
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d733063cdso48589635e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523875; x=1744128675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xan579+d7KgslaidCIf/x6Agm9xb9cfRwwriUXqq5BU=;
        b=i8SvbaVNM2xGppMPhBvl2DLD2dWZBiF3tJJPxJ7p3te1/u6hKtV5KlL4WjsKmA/pZN
         +kTzMoY+typZ0ghsNaVaJeAu40mVs8BzGWqlOKlHnxrX0sqrijVRA4MnAsYxiMnkVJOs
         c8K0GEP3gcdJp+5skO1I2M+f5CICFqd7kN+YSrEolOp7zzNCmMB78++/1FQ3pi/YOFiB
         uJ/6mN+/QP9Az5kFbOriSP06kM+f3flIkzq3ki552opj7fadHjcSSk8IFgAtn5/VgPhx
         14fDAuhBJgjMfMMjbaMsqt57D2Lhj8eHeBL7KuswyfefY/MDfOuYaDA9NVLrOTZ0WgNN
         b4+w==
X-Forwarded-Encrypted: i=1; AJvYcCWzAgkidt/qWdO0RmOIPYfy9E3Q+1JYZKRG2w7lUso4SI6CEGbk3RehnidjT4q/XEMos68=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzur4txdnLrwuzOEe9gAQNA20sh4VSaaCSBPruw5kfaPHx8zjsQ
	HJhLrodxz8Ho3zvYg5XMBFceSR0JhmVIQxvjsH8JTYKehJRFyF3Tkvc9R92/njkYSvL1keMCMBb
	83h7G7K3hsfn430dYKFs5CCmeDN09v610JuJ2QI9Q2zORyepjvg==
X-Gm-Gg: ASbGncv/jpc//T7IHMsH0dRbd+URGhavLjcPcg0dFbpSuOmyAreVlR4VvfWMvnICQL/
	1UP3+H/wGD/vXbM3wbWti1oLgySXtzDmm6WDFshZwPr1N7wvSPHdHGS7C9gKfZPQID3vkscCLMy
	d7Se7By4ILD3VKty1si+orRYyT6h4N6r8AMT7gbYcwhOU66NAPGHcpFTEKyFxy4uhCZAXdwbQVV
	GPGW55sgP+y6c14r7F+dXB9nJPZoTdVhxuaCfxfI7DQQY9rnjPVioKV2D8aRdng2jFJmaMVfoeh
	ZbKFSl8YxVs20ZquvTydXw==
X-Received: by 2002:a05:600c:8411:b0:43c:efed:733e with SMTP id 5b1f17b1804b1-43e9532e1ebmr100629045e9.14.1743523875086;
        Tue, 01 Apr 2025 09:11:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUdn3Vx4U1/8c8ov9d3i+5ptLX3WkvMAvnyRA6d81On2Tt/Y/tDhAYSD2hlI0h2+y0PDDicw==
X-Received: by 2002:a05:600c:8411:b0:43c:efed:733e with SMTP id 5b1f17b1804b1-43e9532e1ebmr100628635e9.14.1743523874749;
        Tue, 01 Apr 2025 09:11:14 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8fbc10f7sm162095215e9.14.2025.04.01.09.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:13 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 02/29] KVM: API definitions for plane userspace exit
Date: Tue,  1 Apr 2025 18:10:39 +0200
Message-ID: <20250401161106.790710-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Copy over the uapi definitions from the Documentation/ directory.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/uapi/linux/kvm.h | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1e0a511c43d0..b0cca93ebcb3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,16 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_plane_event_exit {
+#define KVM_PLANE_EVENT_INTERRUPT    1
+	__u16 cause;
+	__u16 pending_event_planes;
+	__u16 target;
+	__u16 padding;
+	__u32 flags;
+	__u64 extra[8];
+};
+
 struct kvm_tdx_exit {
 #define KVM_EXIT_TDX_VMCALL     1
         __u32 type;
@@ -262,7 +272,8 @@ struct kvm_tdx_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
-#define KVM_EXIT_TDX              40
+#define KVM_EXIT_PLANE_EVENT      40
+#define KVM_EXIT_TDX              41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -295,7 +306,13 @@ struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
 	__u8 HINT_UNSAFE_IN_KVM(immediate_exit);
-	__u8 padding1[6];
+
+	/* in/out */
+	__u8 plane;
+	__u16 suspended_planes;
+
+	/* in */
+	__u16 req_exit_planes;
 
 	/* out */
 	__u32 exit_reason;
@@ -532,6 +549,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_PLANE_EVENT */
+		struct kvm_plane_event_exit plane_event;
 		/* KVM_EXIT_TDX */
 		struct kvm_tdx_exit tdx;
 		/* Fix the size of the union. */
@@ -1017,6 +1036,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_PLANES 239
+#define KVM_CAP_PLANES_FPU 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.49.0


