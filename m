Return-Path: <kvm+bounces-64188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B70C7B3D3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:12:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CD1234E96AA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4590B26F2A1;
	Fri, 21 Nov 2025 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Klfv1R21"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DBF1AF4D5
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748549; cv=none; b=GEiYq0uY682RbDl2UPpJoWUAl5m41zu00tW9q+S8KqnEB9fMs/hz/hltv92D7a5k0HsWTtUgdi2ilyGCjbh6qoX/pACtV91qsdOJEsfWsszBWPA+Ua3ncmVVaOFq3J+LCE5flUY4gXUB26amoxoxNuOODiILDmF72DGdmzLrJcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748549; c=relaxed/simple;
	bh=/NaU4lmx3uscTLYLZQMdQzUVIepLpvduQtxZB2H8Gz4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UlVbI0x8WVPsrpYfZD6sKrHa+HcckUdXndd2ISzu6+Vk4cyCBwT9YUKugVym1jh72YJbZiVuD36Pa378rtlYRjEt63OxQdqn5c8/PcyIsywC0gyTT88HGImOsLenCmy75j1Hu5tiLI6WOEFB8bnPMwX/T6kc8To/D+LUuHPZ86Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Klfv1R21; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so4812985a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748547; x=1764353347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rV2Rdr8ijcDqFuCn5kiFm2RGNN8jEP7qleAp3qZdxbE=;
        b=Klfv1R21tVduQAj8KqCoo+tpaq6mw0xaHupu4rFBd9MvmYNAcrqwaMy3sLxMIJ6dWi
         5mUvl1VdaAGxt0+TzDXbfEgSjm9FcGb6bRBconVHQJpKoIJTuff2UHfgCK3tLyF35b5k
         1kQiUHDtNQc8DCWLpQOUMKXdM8sK98zbpd9FkIlIYnuE/AxVOryWnsa0auR7Rimaw20/
         rhXB4ZVVhCKtutPn2HxtX/FUVBf+kVyOEIo3PbqWV1Ljcm4VLqi5lZgw3pka8Oj0wnWx
         kuV762R0vV/SqVoZVsjscVk//g4ROjR5BqvSnImFm0jx/2e53EeuY/B8XmM4bgYGe5/8
         yYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748547; x=1764353347;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rV2Rdr8ijcDqFuCn5kiFm2RGNN8jEP7qleAp3qZdxbE=;
        b=omEI45++CoqnpJoBHJcZikb6LNkjw82yamTacWE1i8seplp0/bw5jtYWhG493Ml5R1
         CG9Xmzvdqamk04c9NAplgt/0SLCco0wYZvY8fEnw8Ca7fgpswQU0dIqrxPkAVpsDOfGL
         oK0WF8fwxHUAT2rKN0GOTjOuzNtrmS3+Lzzo8P6RdKb8HqfC2OvZ2olphAFQnmGswFx3
         IAk4qkO29iEnhtx10HjMhuZddv0emxTxAdfWIp0jAy8W7246FcOMCDdpA4h79COnw/CN
         ckXbnbXusXJjR0nIHm56zF8B9vPX1ttBNtS6tX+YzNsr1D/awoLcs1nVflk57Pxtq3Dy
         fNiA==
X-Gm-Message-State: AOJu0YwseA3MlmMZrwOamgGDcryH46htt0DiLZTvSCNAuHodNNAAaOzE
	CllIu54MWBpy7SJ8B92oDOok7caQ9DsL31I0dKGCzPvWV4OlDStGAMzRJG1jK/ozxuAS1MqzGMO
	mMQZoYQ==
X-Google-Smtp-Source: AGHT+IH5AQd2VtAPoNslN7xaE15eO2er6/2UDhfv/4L1bI4prc1/oDliG2zre2eT9YrFC8wesrwtF59w1oA=
X-Received: from pjtf12.prod.google.com ([2002:a17:90a:c28c:b0:340:c53d:2599])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d4c:b0:33b:dbdc:65f2
 with SMTP id 98e67ed59e1d1-34733f0fee5mr3506683a91.22.1763748543619; Fri, 21
 Nov 2025 10:09:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:50 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 00/11] x86: xsave: Cleanups and AVX testing
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A "slightly" beefed up version of Paolo's patch to validate KVM's recently
added AVX VMOVDQA emulation.

v1: https://lore.kernel.org/all/20251114003228.60592-1-pbonzini@redhat.com

Paolo Bonzini (1):
  x86: xsave: Add testcase for emulation of AVX instructions

Sean Christopherson (10):
  x86: xsave: Replace spaces with tabs
  x86: xsave: Drop unnecessary and confusing uint64_t overrides
  x64: xsave: Use non-safe write_cr4() when toggling OSXSAVE
  x86: xsave: Add and use dedicated XCR0 read/write helpers
  x86: xsave: Dedup XGETBV and XSETBV #UD tests
  x86: xsave: Programmatically test more unsupported XCR accesses
  x86: xsave: Define XFEATURE_MASK_<feature> bits in processor.h
  x86: xsave: Always verify XCR0 is actually written
  x86: xsave: Drop remaining indentation quirks and printf markers
  x86: xsave: Verify XSETBV and XGETBV ignore RCX[63:32]

 lib/x86/processor.h |  62 ++++++++++
 x86/xsave.c         | 270 +++++++++++++++++++++++++++++---------------
 2 files changed, 239 insertions(+), 93 deletions(-)


base-commit: f561b31d3dee01f8be58978be23bb0903543153d
-- 
2.52.0.rc2.455.g230fcf2819-goog


