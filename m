Return-Path: <kvm+bounces-45061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64204AA5AF0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256EF3A8B0D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7AE280A2F;
	Thu,  1 May 2025 06:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N03PH7DO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681BB268FF1
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080662; cv=none; b=I6hfXGnkBspFUpXkp1YsvjZ1qumsO30UifjexeGRMrqMnI2PDXfB5eD5rhNaV1Bz2Id4LwJZ4cNC+Q9MwMltkULDVIuzYA6675rC71YmudJBFO3hHa70AtDJUpV0AxXw22kZDDy4EqJC0eZcI283i6joocFwayP/swJqM2+s934=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080662; c=relaxed/simple;
	bh=S3NSHIyO7DT+Encik2c+lChFEhOSN//aclFijVeFvKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp7lEPBVfbQhqLSKV0Ccy2oECrLjbAWLc8D+LaMvzscSmWnm8KTSkrLm2PS7tWOU4GxNWiaVyYp3/cyPgOafs+QYJoqYW9qxkMQNkHFP3P/E5FYa6rqBGulFwLduAg0RsyPSuWoa4EClVW8Z/Mg3JDNGlURZLeH39dnTtLLVCrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N03PH7DO; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso721700b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080661; x=1746685461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBI5uPHzYMY6eh2c7dgtwBog8gNzmSQclyZLzeP9xXw=;
        b=N03PH7DOuU8GtiD01wq4D0vd/VzvRAthXQ/kzoCPnv4M8/gG1oFI7TofiE+yHh7ayJ
         6ZYn9EubzTt7y6qeXk96A+6DcdqNpalD5VygJK2qP7GnuAiRS//A3OBNmFAOXkYxXfPA
         rN/L6PsN+A8tin/BGxwdabUrVQ4KiqSvQaLaTTVScB3OERM5ZGaUry1okdq4wvp1FBQ1
         dt01sL1hghVbb//GStgIWyG8gcbFCRyBxHxUYigPAe2zvnnZBckz8HTCtqv5FTUvA4/6
         2pvo8DTKL90P+dNwy5SKlgaLfNgsMURw0nENjLB8w60iRZwdwRc4kuAKJugWnemPqXd0
         0OWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080661; x=1746685461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gBI5uPHzYMY6eh2c7dgtwBog8gNzmSQclyZLzeP9xXw=;
        b=IxahgOksbWQCKjNxXguDNW95bOWa/KeFseGINbO/AzpKXorQIdKncIyqukml1CzivW
         ED0D36whZpmc+m6vVzN4DzdKS/3UaLDiWcZp0gaH0QchC4KeQEXmkt/wkNff03FP2tyq
         UKAomcFrmvafOk5+N0Wc7Jx39zEHincNnmU0AFZSmsyjwQnhtB6MSVdPVUYmyjAyXnT+
         AxS87VexGtGTYnHzmSRYjLoyEHR+azlzvMunEi3B28AtLcDXVe4knH+ac6bZcRt8qaxO
         5Z7QG1wzhZXKstOGyVXPCQj5krrcLSmGOqQQ9Ewlv5meLxPuhWZdJrxUwPNbfPgmuLZ/
         D5Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWHtPQ9WkpzyLdkfcnZQiXfr9r4bssD2nT4eCmieYGxXYmEPuKI7HRBuBNUFVWzSzAPbMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDwbYCEfJkzhXBY/bdMf6oDJDG2hI7u0MoAl+fWfRWm+sRsxz3
	NTfhJB1s95AIfFnZ/9Qef9UGhPc843erxkoD6WJ86rtp4LVv/sc2+VbcZ2BDxeE=
X-Gm-Gg: ASbGnctsgwWnHC463Q5AzcvL5j1vMTvWYH2W5FRhv8dLHAxMTjbZ+MbLIyZSnEvqkDJ
	AEuxWu5PzLri9jlK2NLix9E9LQ7o0VFHT4jnk6Eu93EE1NuOksneXYj4yoCRIou5ECpy2smq14d
	k0tEBjqlbJrkYjrgJW4UAumg/qwUNGO1NE5C6oj8zm3NaoEkiO4oSN0Wgp1nZyD6FdGxSZNJ34X
	Kdk9noC7seUG+qBVs/scKAqdn1HbKDmEGuUG56ANbwMQExwyPatWIqeSoOvChdGllR+mqDmjHtW
	V7Ng8WL7st8nBU+nbuzUxWe6cDHQ5ccmZXOabttf
X-Google-Smtp-Source: AGHT+IET5AJXzcKAYJBSnisETMHpG9TeThJDNZVtwu2V5zDEzGbE3MiHWS/rW9B33TSjVTYXS9+vxQ==
X-Received: by 2002:a05:6a00:2286:b0:736:a6e0:e66d with SMTP id d2e1a72fcca58-740491af0femr1922678b3a.6.1746080660829;
        Wed, 30 Apr 2025 23:24:20 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:20 -0700 (PDT)
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
Subject: [PATCH v3 33/33] target/arm/kvm-stub: compile file once (system)
Date: Wed, 30 Apr 2025 23:23:44 -0700
Message-ID: <20250501062344.2526061-34-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 29a36fb3c5e..bb1c09676d5 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,7 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
@@ -32,6 +32,7 @@ arm_user_ss.add(files(
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
-- 
2.47.2


