Return-Path: <kvm+bounces-20108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F879109B3
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C93FAB219E3
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A981AF6B3;
	Thu, 20 Jun 2024 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V1FhL5fo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81DE1B1411
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896963; cv=none; b=GBuKxPnhMCNVivgJeuRTefThCqcHvsPx0QcFnHkIXAaV/XEyk5qjQHmdSDvqCg9Qhp6OQ6PjdwHkDQP/ljO/jM1XCz4ELbA0amL6clmtoypEtPgtIzdM4UhhvfhWUXXlSS+9gFrsx3GcoR7bHQjsScNVZsLyoS5FJXEjqHI/B9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896963; c=relaxed/simple;
	bh=dWZToNlnKejocuVrTQZhH42DGhR+YF4KIP5K3Qp2PQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgTtLyl4W/nXv7maqnXRZ/nc3+ausJzwgsilv9tIddPXcbUnSoJC+P4aOzeU/AdRY+W1Rd3rA2V+sGhfC03OsiyLDosJGEHV7hrY1Mq2HEwYQe2tzUySyJ4w/joiOgKWLQcqgkEBjvCKgi7AdgGZA6wvHlHbTJyenyeuGjaDuAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V1FhL5fo; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a689ad8d1f6so121676566b.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896960; x=1719501760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97cycViE9OQK6SdY90/SywB1oI0H0vp7Y3hsl3HXbfM=;
        b=V1FhL5foLnWiauwzaqqMS0rfV0ks+896xaY3msK5H60eVYmHDcYGTHB/D2u+cwOm5X
         +0bz0Odq/BzMZuQH0mSXS5aBjKlUE1yH/0jPGw2SrfdzoppGd+FIojLepK22cmFb6D8W
         xy3+QmgRa0YQYAhu0276fcwa0vo9q81aCAQ/qsIzz4tLoq6fjk3uCCb2yEUXdMQ+yX6c
         HJ0SyRlHOgyzCOL5thVieJ5KPA18KGmyl2h+YA1F+IbWN8tu4Es57k2DITOT6iI83kGR
         qI71iUj1DoZrFgdIXQctGKJn5miARBhbBspupJrKlGsA1CSlP94J1WqZ96FlJi0dA+36
         TmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896960; x=1719501760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=97cycViE9OQK6SdY90/SywB1oI0H0vp7Y3hsl3HXbfM=;
        b=GtNCAxFSsk0eV6ugF+kAdTK0NhEAV2i3yboR67AJUU0vSWC6/Wj64woXTyAaXOKFLP
         ftKTrI6DzCSuhd/CgrfV/WNF/GAN3U2JxDtDn4jb7uGsW1/SGt5XPissqbMGw4F4xhn5
         MEQ1+jMDGTEr66SU/vmvHuTPxk8Q4DgyBdS8g6vqupHz5P3SF5hSgFPzHJ0hMN8XJ6ri
         1kpW9gq2gUDsEMM+6teQRm7lSfIDCsERKcSn3f0z4Pt3cpGcfPZWr/NHyWqD+QGQa5ky
         ZfpIR9AxA4cwmRvRtzsL2UlkhHipk9w1t6jQPOGHa/hSNz3xkKM3LzVpNlteKeWnKu7q
         RKfw==
X-Forwarded-Encrypted: i=1; AJvYcCVfpHhBRp5DjAwBzSO+pA7HywDbYnilBN6E7/fDcmuYdv4v1FIwL98LZv/iqLn+vptVPqrEAFzy61YTNf7uI/sWqruk
X-Gm-Message-State: AOJu0Ywj4QxhQMBSf/KD5wDuqaQMO6aiBTY2T8PDtsBcCW2BngqUldko
	7M4xiokgHQ2HQhMe9m005rU8AT7cpOvCb6z0FLDrhkcRBHYAScjXUUdtJz95J98=
X-Google-Smtp-Source: AGHT+IHWqQ+U5RDCXqQGFMJSuSV70/qn1Ko7rwj6FST0rE/66lYbJ0eLG09x1vJsHqa3Ib9AVn4fpA==
X-Received: by 2002:a17:906:c1d1:b0:a6f:b9d3:343a with SMTP id a640c23a62f3a-a6fb9d3383cmr198180066b.71.1718896960112;
        Thu, 20 Jun 2024 08:22:40 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed369bsm771539666b.100.2024.06.20.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:36 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 259085FA0C;
	Thu, 20 Jun 2024 16:22:22 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 11/12] plugins: fix inject_mem_cb rw masking
Date: Thu, 20 Jun 2024 16:22:19 +0100
Message-Id: <20240620152220.2192768-12-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

These are not booleans, but masks.
Issue found by Richard Henderson.

Fixes: f86fd4d8721 ("plugins: distinct types for callbacks")
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20240612195147.93121-3-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 accel/tcg/plugin-gen.c | 4 ++--
 plugins/core.c         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index cc1634e7a6..b6bae32b99 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -240,13 +240,13 @@ static void inject_mem_cb(struct qemu_plugin_dyn_cb *cb,
 {
     switch (cb->type) {
     case PLUGIN_CB_MEM_REGULAR:
-        if (rw && cb->regular.rw) {
+        if (rw & cb->regular.rw) {
             gen_mem_cb(&cb->regular, meminfo, addr);
         }
         break;
     case PLUGIN_CB_INLINE_ADD_U64:
     case PLUGIN_CB_INLINE_STORE_U64:
-        if (rw && cb->inline_insn.rw) {
+        if (rw & cb->inline_insn.rw) {
             inject_cb(cb);
         }
         break;
diff --git a/plugins/core.c b/plugins/core.c
index badede28cf..9d737d8278 100644
--- a/plugins/core.c
+++ b/plugins/core.c
@@ -589,7 +589,7 @@ void qemu_plugin_vcpu_mem_cb(CPUState *cpu, uint64_t vaddr,
 
         switch (cb->type) {
         case PLUGIN_CB_MEM_REGULAR:
-            if (rw && cb->regular.rw) {
+            if (rw & cb->regular.rw) {
                 cb->regular.f.vcpu_mem(cpu->cpu_index,
                                        make_plugin_meminfo(oi, rw),
                                        vaddr, cb->regular.userp);
@@ -597,7 +597,7 @@ void qemu_plugin_vcpu_mem_cb(CPUState *cpu, uint64_t vaddr,
             break;
         case PLUGIN_CB_INLINE_ADD_U64:
         case PLUGIN_CB_INLINE_STORE_U64:
-            if (rw && cb->inline_insn.rw) {
+            if (rw & cb->inline_insn.rw) {
                 exec_inline_op(cb->type, &cb->inline_insn, cpu->cpu_index);
             }
             break;
-- 
2.39.2


