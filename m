Return-Path: <kvm+bounces-32588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AAC9DAE6F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1980C281AA1
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D1E202F8F;
	Wed, 27 Nov 2024 20:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0c0oQOZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42698202F94
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738788; cv=none; b=T7KrxWurZCGv7XI/MEntdrb8zcxzddbrXgyZvAiEHo0fuSjO7cEWEQ3KMWsE0iKPaB3AZsK5R6SEB+emKN6sjDeNutAunCe7veoMAw3UIQNtCZPtlnFL3MhJPtL4+h9RBm9biOx3ld4O7g8Qp5c+MVGXsqEjXjYcvjIGQG6XBGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738788; c=relaxed/simple;
	bh=55ka0JARxkKK6j/Gd1Rkz0SiD1//nkCrDW7ti/LUP9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L41wqul1PFuqMG8PHQ6EB6X9fhApG3E6Ede6IXMT2DG9Wa+2yi3e5z9ewo//E+ibwA/A6FJtyaZVbgJYtCDpYq431YbT0Oo+DGJEBTfQjysiIa06UkmQeRwQdcua5u5vUbBv/Y5vKNs2i5z/v4v3VV5VhLhApuNMgOlaqH1bvG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0c0oQOZ+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee21b04e37so158517a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738786; x=1733343586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/aoBOHMDlBzdeA5z8TizKQ9mU30wOoqXCBFWfyqEOWc=;
        b=0c0oQOZ+2Vx74l/TrznuDbWGSefhBgJT9xE3ZzcTY+48h64Gp6uCb/2JsuoTOIOjKb
         LRPXpOk2s42+U5/q0KeqlMGZoXXqWJldJtQvMxqMjC+A86CWi49j93i7JhvLhN+ctwpy
         EH2g6nvhp4pKyrN+33dj1HZemOcpSa1qKyiPDACR7Cg+rTWngYcsB+r50w5XpNIi619U
         7uKJzrpA4nEioPRN9IE1FmJn/LJlcSa/8sjhfo4EkLO2O4IAOUT85fjZwlcc6tp9z99i
         9/lzZp1vi4b0JpysPRlOAK5mw8Pm1yW29Yvr6tTasDVcCj9Vx5qxW1f69EimlkjLMRXm
         bWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738786; x=1733343586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aoBOHMDlBzdeA5z8TizKQ9mU30wOoqXCBFWfyqEOWc=;
        b=X17r3L3TaLi+bnTDVjCF2MMjye9Y4DmebSzyZPKMDvpePaAN8RPKhaoRGeNuFTX0Od
         wBsS1+G/CNU22VgHyU5BrAa0uUbdlFjQSwetzQkqNhvbYxdxNPNgD2qffcjE+lcrrSyM
         NyJ4Dpi7xFp+vONPNOBFfNRBpuURKCSAbxmgYDYwSkA+lO8eyzQnKT/gxBw0/DBrwQKp
         EMJ4QdYDCZncOIul74ti5ag1SHFsbclIM8yTRNtWC6ln3DL+VIbiTbF7OlmQAOR5Urfq
         jqhtuDE6E1WLLnnZeBR18xDuz9RKxANtcLmYYB3VzyZP/j+jTlzoPnCnpOelWVK8u+hO
         lInw==
X-Gm-Message-State: AOJu0YztdYUHJq3ofi9b+eoHAkVJHgng8g2aJOBugjzu/4tIilXUtBl9
	/8k53beYa+l4PBphk8P7T0fpQTrzsuyOfND0achhV+9JZzope4Yem9IQHmNqvnQpax1Ua6pJssx
	neVo+vYQ2HIKkwB2kXAv84XiTBhCYPcxf6SIpgmwMTY1FTAswZFrcCQ4qYFHuWrs/PqDfbeEj4o
	RemsNc7vL4aug8r2dbMvpOF4QLmEuC+7sagcbTv3XOuCzpzfNuWw==
X-Google-Smtp-Source: AGHT+IE1jYtTGQGaf1HZiuNOX1A6zzbjMtC2bxQRsqs2c0AbUND1MLVmCmDdHVrMd/9NYAJwOdfr3o4rbcPP0IJq
X-Received: from pjtd11.prod.google.com ([2002:a17:90b:4b:b0:2ea:5613:4d5d])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1bd2:b0:2ea:4150:3f82 with SMTP id 98e67ed59e1d1-2ee08ecd374mr5032714a91.22.1732738786574;
 Wed, 27 Nov 2024 12:19:46 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:16 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-3-aaronlewis@google.com>
Subject: [PATCH 02/15] KVM: SVM: Use non-atomic bit ops to manipulate MSR
 interception bitmaps
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 35bcf3a63b606..7433dd2a32925 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -852,8 +852,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 
 	BUG_ON(offset == MSR_INVALID);
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
+	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
 
-- 
2.47.0.338.g60cca15819-goog


