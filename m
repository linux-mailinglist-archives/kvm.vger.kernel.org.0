Return-Path: <kvm+bounces-63046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35561C5A033
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E0D3B6B04
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D694F324711;
	Thu, 13 Nov 2025 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S2WOwPl4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F83322DCA
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067083; cv=none; b=t2nx5rNPzqiMLI5K01mSzHdAhIgK620NS5Cgm3AYrIo9lq/b7DdCBwGGWB6DowOm3rbprdOO2F4s6lPF0ouS9hiGSpWKHuZm+G1IyS3OsCeDSRdJgAX5Q++F/ln2hg10qNkwZEaqHBl81Omgf0bpmb2/qkXE6cJlm7ElyYEmPNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067083; c=relaxed/simple;
	bh=eRxbYe0kdGcrEUUzVBzWT3I5r2UPd2pYTMvZwRdDYDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XQoOfrWfF8sCmVr7cJSGQpQgAbvOLpdC5JvsgSdGWvgmmyuJHhUmbDJUXmYCNPeCLbZfHftSCWm1dVQVS57AuKP3F6Wp9rTRNSOTj+HFpADUh9lyAFIhLEnoL8lDKCa5nTldDt0kS94+EssSNLYQOmj5yLAI69DS0ftEnd+MD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S2WOwPl4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-342701608e2so1553927a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763067081; x=1763671881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ejzuboDQw4w6apP9VylzMSB0PpTSFQoCGewPZ8H3aC4=;
        b=S2WOwPl4funA8D19HbpXcxxTMwQvggXHddqKq901H+DOtDdR+If4H68JmnGQKbwL4F
         tEzzhsc/F3zlpzyyoYD7PNyGGsQMCp5Ho02RoAIMAAwFQQtbTuISWsb+6a+mmITuHMZY
         H8KByCEf2hILyygXmnXnJqD9TPbFtwviPAhfi/gEbQI2RyEsviSD1O82cai4x+BY0XSX
         nRHhoCzz7uEK3xwgb9ZjCXoFhX7S/Q32fqtrLuXRuSjqLIjxwtsrEPRJWh+xfEHh/Pt6
         sXYh+WbV0tUVrnTvD95waL7Jv2U2FUs+6YDssXGrIU3OzxLd4XJrbHp9eENw2ea2PJPu
         4PZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067081; x=1763671881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejzuboDQw4w6apP9VylzMSB0PpTSFQoCGewPZ8H3aC4=;
        b=nDmc2sgWrRRuT0bCJqhETSwnM104exX8h4K/Y7J1bTojqPI0oTk6Bhp62CuerLzQ8o
         ZCeB+SqqMyE7bTVJ7hTuWYZEV1Nj6uVSCq9/SEs6ELENwZDwlfosJH1Uyg49GZ81Ez/X
         xqvXLNmrUgbqj2f2u+aJV1iaGIHHldT1L+82JGRolaqumSbRtt8Ao0iCndfTkoZcZiZZ
         qcsbR3Z3Qzwk6UdlOJAEC3kqNfri3/YEx/tTdhMwVJUeqrc2rO3QXfd79bUJgmb2Y1Q8
         P9sFNsfqt7u8uak0tw9G8O3ZGPeVSbeKX75GpFf//XAK5ZBzBKFRhx1R5NmyZtG6mt9v
         wOQw==
X-Gm-Message-State: AOJu0YxgMiNEgrPf7loTLgQiryTpBtu2ptSu9SFD/vlozKgccMSJ8kmk
	X1s/9Rjimo72wzOgFNF5C1yW9S5UOzsDxCdirmx71te/aq/rob2HWtsfYSxXcJpzPg6UeIvf8X+
	zf1pojQ==
X-Google-Smtp-Source: AGHT+IE3TMMnlHBn6B8nmXmxM49hbBVHnKcvO72C9SKjgOi/6oqv7jleyJZlT7nXdmHE1UQkaFzpJLxKqGI=
X-Received: from pjbnk9.prod.google.com ([2002:a17:90b:1949:b0:343:7133:ea30])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2890:b0:340:bb5c:7dd7
 with SMTP id 98e67ed59e1d1-343f9e92771mr605020a91.5.1763067080876; Thu, 13
 Nov 2025 12:51:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 12:51:12 -0800
In-Reply-To: <20251113205114.1647493-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113205114.1647493-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113205114.1647493-3-seanjc@google.com>
Subject: [PATCH v6 2/4] KVM: x86: Explicitly set new periodic hrtimer
 expiration in apic_timer_fn()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuqiang wang <fuqiang.wng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: fuqiang wang <fuqiang.wng@gmail.com>

When restarting an hrtimer to emulate a the guest's APIC timer in periodic
mode, explicitly set the expiration using the target expiration computed
by advance_periodic_target_expiration() instead of adding the period to
the existing timer.  This will allow making adjustments to the expiration,
e.g. to deal with expirations far in the past, without having to implement
the same logic in both advance_periodic_target_expiration() and
apic_timer_fn().

Cc: stable@vger.kernel.org
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 78b74ba17592..a5c927e7bae6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2972,7 +2972,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 
 	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;
-- 
2.52.0.rc1.455.g30608eb744-goog


