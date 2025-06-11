Return-Path: <kvm+bounces-49138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1730AD6193
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A0833ABBCF
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C47D25E44B;
	Wed, 11 Jun 2025 21:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LkY8ERvl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E222525D1FD
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677789; cv=none; b=SLP3UHRdEKoTS318YufhefbK39Yh0Uv5SMSsaAtu69XCHymDtN60G9xWTpYJPuhiPi6mNDTaClEJCsBxbLm1dkfUy0mqKh0hHEzp/ug+DgC58f4O+24liww3BbjLKDAJ9tsz0eQtA5ZV1NbYWoCLnj4Ew/08/3ZOiTeEaPweveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677789; c=relaxed/simple;
	bh=pbzjMkYafGxcpLXLqdeS1eEDP6kDrKXYmWNpHPn0xGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lRe3afUBDqDErV/IWZrg7E/8+cCvNyWPjubNJB8YLUrEVehu2CI/b5B5ieixLD8kKzh8/0In7+NprbxFFITBk+zN1RGbVCeBKZzzme18iPi7TbTVgGbezQUYZMzPhajGnzH3JW0Ku0X4vQY2WvcJZlzDVRZz1CKnNvtUA4be1Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LkY8ERvl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31315427249so329362a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677787; x=1750282587; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzs0IiSJuwZzmnPBx3wmk+iVHWs9BLQaD0Cp4OIfdsI=;
        b=LkY8ERvlf3FnZ8ZUvjDgJuiVI4mII6ZvPbVgYoKvAr53Gr9Pf7Fbu4IaTCOkveE6v1
         RoWHSaNfkg9VUbYRIzVdtCzBHQ1Ew4hUTjeYNJ5X7PjFdyGkrvYsuTpxLgNjujWaq13X
         OnJk+ChHut6rduvNGeqep8UGAaXpLYzLFiAiHfL6TmC39FEz0vlFcKROeELyyapGJlBW
         bAWUDauTVck17KkkApFtxODVrV4FMG0WAIUqJA9TUyaaK0OmIWHV0THMCnvabHDikuZw
         WyHwnIKYlWzUlUHA1tFGNz3yHnUYrnq4n6M3LwKVXnYqjL5VLfyorYCcdbE1CXdO0n2V
         OKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677787; x=1750282587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xzs0IiSJuwZzmnPBx3wmk+iVHWs9BLQaD0Cp4OIfdsI=;
        b=hbj+dZQk8Vj62qgGXg4SPYX1AfE/NdPgJHP1BaXSmpDA4qEookVhXXgnB/X/iCw793
         ufEPJHbGIRaCA1HaqHkDOqNThSnA+ztW/KUhSO0XfMEZCejJMNF9NkRmRk0r9EX8m9t9
         OAuyK/Ja+W/6FET5lstebULdOVI47xrG97vrOeHzP/9f20T1e2v+hKWTkxD+mzDnUcJj
         uZjTIyT3EOYX5HXglVIwXuSLcsvwvDCMxYnalcs7jQmVnc7XE3GGVXDZp6x/d4JgDtq4
         rbNyPeOLmVISDjJVD6jzDMS84ychA3ImXNAaljpkwxQ2+kySzxNd9PS+HK0IKyCCjx33
         Xqhw==
X-Gm-Message-State: AOJu0YxMaPy+F6zSNBkPkuIxyVTkL+LRam9XHcrVIC0Q7GuFjQzOUcb4
	s3/urmXhKd8T3OAhm3HZUfL5qTNy3GYKauJcLFhGj/m10UYp1kicTK8RGTqW7R3LAX4t4/bh1io
	Ht/oK4w==
X-Google-Smtp-Source: AGHT+IHIvhKkqqWWcEQHXFR65K8FZLh/xEt/zChKvBvk4uS5J2RIxt1u9I6b9xAUE+S9NBqKiPkCbq7uF9c=
X-Received: from pjv12.prod.google.com ([2002:a17:90b:564c:b0:313:2b27:3f90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a8f:b0:311:ed2:b758
 with SMTP id 98e67ed59e1d1-313af0fd2c3mr5826535a91.3.1749677787281; Wed, 11
 Jun 2025 14:36:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:54 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-16-seanjc@google.com>
Subject: [PATCH v2 15/18] KVM: Squash two CONFIG_HAVE_KVM_IRQCHIP #ifdefs into one
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Squash two #idef CONFIG_HAVE_KVM_IRQCHIP regions in KVM's trace events, as
the only code outside of the #idefs depends on CONFIG_KVM_IOAPIC, and that
Kconfig only exists for x86, which unconditionally selects HAVE_KVM_IRQCHIP.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/trace/events/kvm.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 1065a81ca57f..0b6b79b1a1bc 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -82,7 +82,6 @@ TRACE_EVENT(kvm_set_irq,
 	TP_printk("gsi %u level %d source %d",
 		  __entry->gsi, __entry->level, __entry->irq_source_id)
 );
-#endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
 #ifdef CONFIG_KVM_IOAPIC
 
@@ -93,8 +92,6 @@ TRACE_EVENT(kvm_set_irq,
 
 #endif /* CONFIG_KVM_IOAPIC */
 
-#if defined(CONFIG_HAVE_KVM_IRQCHIP)
-
 #ifdef kvm_irqchips
 #define kvm_ack_irq_string "irqchip %s pin %u"
 #define kvm_ack_irq_parm  __print_symbolic(__entry->irqchip, kvm_irqchips), __entry->pin
-- 
2.50.0.rc1.591.g9c95f17f64-goog


