Return-Path: <kvm+bounces-19245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 897019026D2
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17B39281BB5
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2391482EE;
	Mon, 10 Jun 2024 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WC4i6hb1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044E91422CF
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037275; cv=none; b=vEaiw2zeu2FAh19jCADKQJdUP5UxuJQMjOFnO8XzRgy4NNMurQYo8A2Dz/o5tPk8vYVOEp/5n1haq1zqixLyyyVdbOl3EMXL/+5zBTrkEK1Dgpp18rif+Pxgn+XPHJojjJCHl0zFEtEfZAcGJpveFyMgNYidSnqfj2OKvv2nIW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037275; c=relaxed/simple;
	bh=yllP6g2dm2MsE2mnC1k07LPpw9VCtTWLM/HdffmDV2I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NBE86jtJ0zMES69MMvjDJ4iyga+MO8EBAqyp3PYgxl4TfYrwPifPxwrPAsMIzgkbdZ89KnDproDFdpGdnv1fPm87Lh/zdLHrY5wQv733lw+4h+48aNMqJtHfWT+jgZFFrlGMHvS9fs5SmPFuYMx2IyTw09OZobzk2HetwALGkbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WC4i6hb1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a08273919so69391137b3.1
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 09:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718037273; x=1718642073; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZSb9+rs2usNZeKaqhewTAKIWQtnKpWPlA0PtSeTiJQ=;
        b=WC4i6hb1UOexv2yMtF70U7Mr+7bVg3/h5iGO+NyFEHpJt1dQ52ujTP2PHrzH5KnDC3
         VWN/py+nwntPscfcIP6xnnycbmJPaLVZtnw8PxgZaaMoRzbhuSOrWNkpQ76fO9ks/j+2
         vZJATnZLe7ukiOC815CPtAl0xsxUVpmMCUP4w9lgvezGpSdeFfY8yXrugZwf+2MIeRak
         qrPq0x8cVH3IW8MIf43zcSibGDGwygALEu/ZduaS2Xk3hGkeVmmNe50GMzQoJHwHOGKv
         fC1c89n++y6/xupaHYUpx+Ju9PMrmMd4gWzpkRZigLizSh6MPTm8W8sPGPYwEp7rvyAR
         ODoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718037273; x=1718642073;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZSb9+rs2usNZeKaqhewTAKIWQtnKpWPlA0PtSeTiJQ=;
        b=f6HfVeiXOKkBIX+fdle5bqIeHisI0Ix/t1MPG6cYW+QHCpR9glFY0wBp0oV2dnr+UW
         aFDXO5GDknrXKHR53+03HaVe08YUBtUfMktSMj3rXDI4kZ+GUayf2PUDDFNEE2g6PHqC
         GNB2FI1BdCHuM2vsKlVLE3StNpL/4vFTTqVc0kux6pwV5Ry/h4q/wD2jU/czOhko6BMO
         BZeUupWcgEjnm77JxbxsYSPKfHqwMF91z6PKZFEb7MRAGuie864PIppK80nq/CeCABlB
         vRaUvHuYmzfgUKtmKZnPtu1KTPkOlP1TjqTla4FOWzDTjnr5QuEetLSWB3E2FWF0tkUC
         YzQA==
X-Gm-Message-State: AOJu0YwQrawEDzH4RdHRIe4FXL82LRxXiKoRJrIfEmKla8DIAHSlnJ/5
	QRMGtq2my+fZCrQ7bEccP07MFaC7IR+TSi3CqMhYOezxgdIdTxA0Symdlr7NIYWDJ2HQsv/BwjS
	h9A==
X-Google-Smtp-Source: AGHT+IHHh2RNmvVunFf6h0xc9IRdVIUXMt65AfZopDDW5pG8LuS4lbSICFSmAFOGHkb/0UN6udVF9yYpz8g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:dfb:335:427f with SMTP id
 3f1490d57ef6-dfb0335481emr683064276.4.1718037272968; Mon, 10 Jun 2024
 09:34:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 10 Jun 2024 09:34:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610163427.3359426-1-seanjc@google.com>
Subject: [PATCH] MAINTAINERS: Drop Wanpeng Li as a Reviewer for KVM Paravirt support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop Wanpeng as a KVM PARAVIRT reviewer as his @tencent.com email is
bouncing, and according to lore[*], the last activity from his @gmail.com
address was almost two years ago.

[*] https://lore.kernel.org/all/CANRm+Cwj29M9HU3=JRUOaKDR+iDKgr0eNMWQi0iLkR5THON-bg@mail.gmail.com

Cc: Wanpeng Li <kernellwp@gmail.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aacccb376c28..2c48b67449f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12382,7 +12382,6 @@ F:	drivers/video/backlight/ktz8866.c
 
 KVM PARAVIRT (KVM/paravirt)
 M:	Paolo Bonzini <pbonzini@redhat.com>
-R:	Wanpeng Li <wanpengli@tencent.com>
 R:	Vitaly Kuznetsov <vkuznets@redhat.com>
 L:	kvm@vger.kernel.org
 S:	Supported

base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.45.2.505.gda0bf45e8d-goog


