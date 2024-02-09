Return-Path: <kvm+bounces-8393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2B984F084
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E1851C265D7
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BDE651B0;
	Fri,  9 Feb 2024 07:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Da73FEj5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EA6657AB;
	Fri,  9 Feb 2024 07:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462135; cv=none; b=SuynooI5+6kI5+4E8N3DVz7AvkNUfgYZSFsxt/jfPdAE+Se3wkgulGI6sCwlkVHJtpf3f3uQ6KClLc1LgEEeReOefX8fhLPaBbiz1AsIrk07jjyubvi73qKkJ4i2JFiZie8mQPsov0Sh8Oa27Z8RAXyjZq79kI4JaSvH0yNwV80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462135; c=relaxed/simple;
	bh=59F2uXNROyyrYFD80n4UUCXU0uos2PlTu+KS2KayEdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOM0ax/CXgtGqmqES8jG7yEsZqMsRdVvMnakC7nxyQzfbaR5SEls4BnWlAcT7r5v9cKQMZ0eVZIiyfiCVRb2EguNWse+8/SkkFPmzrYlXl7prD3xWCstsZJdVfCaO7urKlS8Ek/tYgm+xT3oHCEX88M/yF61C509Tbrmdn8KxIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Da73FEj5; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1da0cd9c0e5so5128575ad.0;
        Thu, 08 Feb 2024 23:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462132; x=1708066932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZWJe/FfY+0lZ+B78melC7fte3uc1Gnzj5kPj86WV+c=;
        b=Da73FEj5OlolUKvvdWUXFDazMDY8iUxI9H3x7JF+MS51S5N7KDVHJ/qteLjaq6V6gB
         FbAI5XhFH2TibUW8cuCvnEwuOmhxUK+YNpFEB3D0MLJrVXHCe0My6uR0V6EOlDhTXFTk
         stM2KVQR+brT/8oih/AVIaSwFc9s/kxhyBlH4Vy7e4SHqkwonD3zXb9JWWdiI2jRAC+x
         cTbgCy59m1n9tlU5MT+nesnj3SiU1nyTte/OuRvfdTloDcyM73YQq4i6NR7Xs8xKawOF
         QBr99em4xWm6Xdy6ct0Hw9x7teG0GUEpd9KZos3z/lSWHrzkanxUopODtxEurTUtborS
         Ph1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462132; x=1708066932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZWJe/FfY+0lZ+B78melC7fte3uc1Gnzj5kPj86WV+c=;
        b=vRJ4Da68mqa5f5cbby+gFcqI09gx/kYcfB/XvDRhvOjL7AxhXK7mBV6RRulxFHnx5i
         7mmAfUE8zV3y2x5ZRK1VVWV33T/Quy0phYz6MJCj9ijnoLfRMyN105Om3SwkGtEqAXV6
         az6tmmKOvtJ3I4x/htpV2/ZOPHVOEJEBMs21nT1UqDAVTuN4Rx4+7Hf0wdYcL3+eKkXy
         cnnut4NnxsXp2iLsSVvYpWn69TrpMBWOzLARrNN7VjZ1AWglpLtWdV9uMZD1jF3pzFo5
         Q353h+egqA6Qmn4U+CzsXzpAp6WXnRuT3M0JvQ5zo5xSM6AA5X9WfM8mdObPwh8s500M
         0rlA==
X-Gm-Message-State: AOJu0Yx/uO+cjyJL3i/SgAuMqW/ZFq7VBcyhWBq/tiWWxISj3r6c9C2W
	OG+s0mQ6FQlMUapafMegqDzUwE+Yx1tvuxzM4Hs0PBMnKOmFKHtt
X-Google-Smtp-Source: AGHT+IHOeahmko/f+RwAZAHEJWia2rOHYMfGMz4gCsHP+DywjdnF57Ty4tjhGRk1+lg6vAvd2PgMDA==
X-Received: by 2002:a17:903:22cb:b0:1d9:efc7:1c4e with SMTP id y11-20020a17090322cb00b001d9efc71c4emr251590plg.6.1707462132399;
        Thu, 08 Feb 2024 23:02:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUjW0aiDCaCLLFfVUVr5+bjGqa7mzeF+p3ViNkQqbgtcj0Il6d+i/6lELOrZwAv2VLO/QuGkDOmTrZv2VMUIMsKQgyI4X6EJsrbFOqX3EwTBCt77J+G785rbh7UEFgzoGo0MeZTvVYFPZD7/1PJ01abi+YorczJW6k6akDxzxMXt9g2gLdOpy3QIpkuiqBIzAePfI7P128W0t4bkitbTsDbBr98gnEpsMuMgQjuH3Si8ur0dF4cnkyVF7dvAjGhMkLgFQmtXBD6lNkbOeef8ggdt/eBtk2c1xZjUn0zCW6G0TMxpZ+4JWMsZF63nPB1q8lKpmVddNx821u3QU0boOD2tlS8wYCQA3O9JUIEQCCb6Qnpm08pHAbnTmgBswHd5imYUiTh9O2eDynpgwF0mNiaOsqavbRC6Jul2MLacr+aprWRyUDanMygM30mw97u0KHVMszGF2zkWJ9/DGlFbxg4mH+LAJXvpwXsmpY+KkbPjxFdxOPeMt3Fc2yK1BQrEDsG6HaRcQ++jE20RCJF/GmJiLzdCsPsWr8F+BeQeiIe7Yj2y2RZ956a
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:11 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v3 2/8] arch-run: Clean up initrd cleanup
Date: Fri,  9 Feb 2024 17:01:35 +1000
Message-ID: <20240209070141.421569-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 11d47a85..1e903e83 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -269,10 +269,21 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	rm -f $KVM_UNIT_TESTS_ENV
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0


