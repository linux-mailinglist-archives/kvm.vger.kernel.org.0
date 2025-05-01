Return-Path: <kvm+bounces-45059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C97CAA5AEC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FE101BA7BB4
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3AFC27EC9D;
	Thu,  1 May 2025 06:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YSNwMW7C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFFB27E1D9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080662; cv=none; b=LGU0uZqJkxzrgUZQxPQbMln8t7pRmoMc+PqSPpTv0NMA5I9l1yEWEgCZ4diDDpPTcerA+MkmS/2nM84qzDdFB4LSbCbXQp/jRI1B1CXgzXCM7tV9a+YOEnBXGSvMZi+P0gPmkCldV2ZE6z/PYfU5/wsCknySNyQ/dboKrYediHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080662; c=relaxed/simple;
	bh=CnICwwPxjH35nyyu92wg1dYLcFArVLsSk5HgOruwcOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2tKJwPth1vSvyQydFfIFr4IEVyvw+BRF9KnUgK7BpkAYiw40AEl7OfGYwphItEklzU1RW24kBvOSkWTsY2c9QwZ3ruCY54sPCAj3dP737hBbQsIY9djR8OYCijvvcX70nz30z0G6faK7I+Vr36bvoy/IsEKHdFh67tdFLq4Rzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YSNwMW7C; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-739525d4e12so664502b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080660; x=1746685460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyqibr5WTwLzvCspC/7bIausnrARYT0xJa7lj0PHF3Y=;
        b=YSNwMW7CVRZzCRt6Hn77lQsFKi9XKZxvVNDc1ReKb+BlRRMaplav4l7l63ZFwfK68s
         6nLopNpY+RO71Q//VVQmCZia+Yp3ZotxCbonPSI2gIdpCkD3qEg6TqX977LWw15aZKc7
         tutQJAN/jmbMuFCkMhJw4wULJkOJvPyLMnxiiRJR0jzBjZre4AUVY2TfP9kBnpP2MDBg
         0EYDNfIJYTYbiYNJPQpjBCEuSnauiLzj+0TALiCgSHbKXBRbg9FH7OHgK+9IxSzEsh1D
         ++TiyQ6EED/QvXBKPM0hX0yMhPQRupKT+cCOA1BN14yEH5Ncik40xV+1PdcwHexxgIfa
         7Syw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080660; x=1746685460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyqibr5WTwLzvCspC/7bIausnrARYT0xJa7lj0PHF3Y=;
        b=xOmf6nGNfMRC8gq7HqV3WLgSOkDviuAbSUwJkPn3A7OWgUWwb6am2DRmdtIseb+An3
         Clsf0b891df/SRsBJ1jM5dwF+N04G9+xCBABmV9+weArQyudfzisRUxr+2L8IkUCOPWz
         uuZBpJKXn1/bQIMgo0w+ZXNqLe/1azl6WKBtXlCbjJ31O+PgERF9QmWl7OFcpMNNc4EG
         tze+62ejxM4fZrRiSBkz3Igei3Fqs9JVvrWIJOkmvHKzyVnBtvt8AXA6EwN6SWcYqa9F
         hfHW0JyG5016vvaah7V9FGE21P5Vn11OZzJ0TPLrPe9RC3C5mWS4mmkmVoQvIQexDTXg
         +E2g==
X-Forwarded-Encrypted: i=1; AJvYcCWvcgnyxSbegb9uG7fURpOwDOpJjtd+h0K7u9EtUpKfqReN531vIFqWvTXGNJj0YpWgjHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4NYOgWttWbo9aLVYFV6zEG+gvOlOCzCGnDWIH3IIGX1XQAoym
	efC8thUR/t7SgeLq53YBiGm9YAL18AS4xKygjNvpmt6IbbZlDeINgAjEsvnqhEk=
X-Gm-Gg: ASbGncvKlhSOAi9TgPgq7PvQhEhNr+pit/j9enxKLv8JkVXS5vufI8qujAUJ+E2nwSf
	R2C9rpE1EoUY5fhbz4nnw6t5NFPqQC/9h3yM9MiwMTp7W3veZbAzc/+fGOn44r+BFUc+eVK5yqa
	EUlY1G4PYAhrFDIL62F1+7baovcyd4/thdNj5al2A/xEaj6qdgbcWlRMJmNLiKHBFNpu65fYt05
	51vfcIki9gKDx+vQk0+tSgVwJuEN6euqbJawNJDQD/Fat8LTx3U9qTbaD4XpRgxsaKGt4nnOd93
	KctMHZ0uFzF4vf/RsPcs624IgAn01VWo7EVTeINi
X-Google-Smtp-Source: AGHT+IGOIfzA8NxqRXdsP35Dd5N84asOZwmvhx3Jb02bYWpAaIstZgl+JozJSaaWgqMUtX5FhbNeUA==
X-Received: by 2002:a05:6a21:a4ca:b0:1fe:9537:84a0 with SMTP id adf61e73a8af0-20bd6d3c490mr1900241637.15.1746080659993;
        Wed, 30 Apr 2025 23:24:19 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:19 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 32/33] target/arm/meson: accelerator files are not needed in user mode
Date: Wed, 30 Apr 2025 23:23:43 -0700
Message-ID: <20250501062344.2526061-33-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 151184da71c..29a36fb3c5e 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -5,9 +5,6 @@ arm_ss.add(files(
 ))
 arm_ss.add(zlib)
 
-arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
-arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c'))
@@ -18,6 +15,8 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
-- 
2.47.2


