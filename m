Return-Path: <kvm+bounces-16479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4088A8BA69A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F065928303E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98E6139592;
	Fri,  3 May 2024 05:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7xdoRVA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD17E139CE5
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 05:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714713928; cv=none; b=txUdYday+2jAJJnUuYeEung/zy2y+FPpy7UdtSNa3M5W2UeMnfBx4AbYF0P1NWGG2iI9tHUR8KuLdWfwexm3IYFFmQZ+nsD1wQjX1LbGzAc19CbPctnklrcAWelLIlqqRtyCdsUfiLfUl24ZpjpIcIKmQo0NWvwjrUb35N2MDqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714713928; c=relaxed/simple;
	bh=JeA5mI3vUMr7R/JPmKozJDAF3D/4aqmNm6hY31qIEFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paZ2+cHTUqMuR86q9AGuImVhAA6M+jU77H8TdvcPKAbMiO511S06Vc4R/Kb2DUZI/FIAGo7WTzImtBIobDJwZHbAkvyjcwx4f0suFYZaC4as9W+XSfH4O5fszbYfPe1fEKKycQYkRXihJztfTPQaxpKZUVuGIC5lEcggiduEnuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S7xdoRVA; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f42924ca64so2005998b3a.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 22:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714713926; x=1715318726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yFEwOR14pqnbOrQHNSsBfGSjqz3qQtVBLsgwLzoh18=;
        b=S7xdoRVAsPJMo4CfwSfvjC574zOoH2oOIi9HlnEO6EHZMtCTbGo6Vjw+AXGOvFel3k
         hslCGf2g8/anux1QNOrctRU3vNoR2M6u0j4Etd0hQP0P8Rm1LFe213y3jb3zfdo3Jxip
         bzqiXgoG8//ty6vplCg3OYsTA1vckeleMaXbGZVi/F9SGn+iDMGUlwpmgQVvYKHc0mqq
         OYOqoHb4gAR+T0a4BjWH8QvsdiE3RM8po/2nfAUxkN2MhxJQ/qUchIbFUyD7UPh5USbU
         614A0kQOZ8EAzaqROQw8s6ZbTZJQSHoau6PBLE3Pd6eQlVCWjU5pSWPykaQMdk3IyAQM
         TS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714713926; x=1715318726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3yFEwOR14pqnbOrQHNSsBfGSjqz3qQtVBLsgwLzoh18=;
        b=VA8hN51xSs/jrHKVjkcIk9teA50wOQ499jVLQgJMBwqilT9J1QR1You9hi99naKeOJ
         ypfOglykGaRkrwSLCOu+o0NYRytv5CZQ74PQRrfiLHsZRvms+3Rbwbx4/EHgwcW4PeSx
         PdTg0Aajp29kLhZ5OArDOyGs/G6i2HqAsGyIkOHPN19Sp5WrxRhK0B7Ox3tSNhlIMD08
         +zjjL8CcVcV8LPLk/4tHdeL4psriNoONo5f2AvtO4J+ElheDzIcXxhuqS1PWyRRICX+8
         gOfUjMM1f3+PMFj8ywUp+wL6BPdFZ8QXXbBx5A8u4EmbxdHQvQAEcuSJTWprJEeH8wcr
         sh+w==
X-Forwarded-Encrypted: i=1; AJvYcCXo6J84JZ9zp26arRpCzIduF2c5de8y7CX/Okow2bNEjT6qxTp4d9c0e+SC0Ui9ySAGzg3exRvGTf+lTSLtAAJWJnrD
X-Gm-Message-State: AOJu0Yx8NiLAzP6MHe38+UcOMpJlPP3heTM8BaDZCEps819H/wVPApy6
	KLdkiUYVf7j3/eX1bGnqb7GrDfg2HAOr3jU3LrMas9tchmVCG1vJ
X-Google-Smtp-Source: AGHT+IG5YNdyQwD93MND3nm+K3xCFtMT7ZViZ3Ss2JwTZCMXoihFOunPJgT1NL9ji/scK6s56/ecfw==
X-Received: by 2002:a05:6a00:2e14:b0:6ed:e1c:102b with SMTP id fc20-20020a056a002e1400b006ed0e1c102bmr1903008pfb.4.1714713926125;
        Thu, 02 May 2024 22:25:26 -0700 (PDT)
Received: from wheely.local0.net ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a00191500b006ece7bb5636sm2205571pfi.134.2024.05.02.22.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 22:25:25 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/2] shellcheck: Suppress SC2209 quoting warning in config.mak
Date: Fri,  3 May 2024 15:25:07 +1000
Message-ID: <20240503052510.968229-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240503052510.968229-1-npiggin@gmail.com>
References: <20240503052510.968229-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's not necessary to quote strings in simple command variables like
this where the pattern makes the intention quite clear.

config.mak is also included as Makefile, and in that case the quotes
do slightly change behaviour (the quotes are used when invoking the
command), and is not the typical Makefile style.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 configure | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/configure b/configure
index a8520a35f..0e0a28825 100755
--- a/configure
+++ b/configure
@@ -420,6 +420,8 @@ ln -sf "$asm" lib/asm
 cat <<EOF > config.mak
 # Shellcheck does not see these are used
 # shellcheck disable=SC2034
+# Shellcheck can give pointless quoting warnings for some commands
+# shellcheck disable=SC2209
 SRCDIR=$srcdir
 PREFIX=$prefix
 HOST=$host
-- 
2.43.0


