Return-Path: <kvm+bounces-29481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB99A9AC903
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 571EBB211A8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE791AC438;
	Wed, 23 Oct 2024 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ehbIbJqm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1591AB6DC
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683252; cv=none; b=uJfkD+xFSXiY95LEnRyCiaMZY+H59TfrfEDo1ae/bfXXVzDIbine7W25jqd6K1t0oSQBZQRTD0MUp/MZLIABJbNqxsTDgOWeeadm8qtT2vPrlAgtd1YzP0T4H2TTNBsbrM/pTRexLV5L7IoFOPLlPhJPjwPPjHB/wYT/ZUQChXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683252; c=relaxed/simple;
	bh=zjcSPJ91yLJKzP0GqRiEilkRLEXVKDFuC9XjWvrKC54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RoH/uTE7H4R0HqU3Bz2C/MD62fB2zZNHErI1xhA4PmCaIA/O+1TlmH2p6t4+1raHcvPf0o1IjwfDyWh7BVybYry4A/OnJkCD2aUSt0p+rC8VAE6+vIcDbwZ22kEtf5qXCQBeuEKEpebcBgFyxzjW1p29U0u35GAcZsBbAxOlfAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ehbIbJqm; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c948c41edeso7512556a12.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683249; x=1730288049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFUfe3R/gzmi/FEpNAJD4C8KljhahEoI2QawPam7H0s=;
        b=ehbIbJqmQY7kw43VOOMTHds1etgNHJtov6xAfv5RFINSBYsLC/nY/PWUvw9IC8Dt56
         cPMZzD48KJsK3kityS1QzoZQadyj6VN5kU1BGVfmTZ0SrsOSuih5aqt8Uwhz+VjnKdHE
         rQfLiIYvud4gO0r8XIQpIMmwpzpAqM/9bva0uI7g2SmWCWP8M0lvw5kmkN10BzcFf+di
         9fNfeLTdKYs88bfCQxXu7PH+DPFOpBhU77NTSm8y6C/opsp1/XtN/FKqmtIHIRLd+vpd
         tUqdPp74D/Qo0tUBtDqWVqLawd+KhEAkMulf5q+tPyKAk8DqTtpjLmO8EWr5loOJBsh6
         H/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683249; x=1730288049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFUfe3R/gzmi/FEpNAJD4C8KljhahEoI2QawPam7H0s=;
        b=uB7zcj1fQUU6BEyTTEfuY0A57uK6CdfF+gQCxVHNXAbmcxBoRXvuPvuvyRmpdtSHpA
         XabEZgr0g2q5pKbeuVRNJPBV1xeAIaBZPgxKYhetQAorYDUe2Nw2ujeqHGJneN/+oDVC
         E3i9NgXhIBe3wHJW7Gt0ww7XEssFv7+Pvj2El8abLl2S+fcvXV6nOapjbs4Nno8Fg8eT
         nQh8M9QYdSuZgzkT92l/kXlG+gLU0yl16axSQ/WikdWK9z0sTnUVXxVSI29jAsSj4Oq8
         1r5kNaZ9vE/ydelgaeNxpj3Cb3zyJ5q9MhZ0x7PkFOZzy3KoVF9AZodRKGYWiZ8x5SeY
         Gj5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGXPlguYfwD9yI6vtBViX4w9aI12OfzFS2elp3ADMvCtB981pVW8yN1tW8IbwduWFXvvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJVV4DykOVN2JILrqqglaD94R481bZipHwXRgrC9FlzKq+uhEH
	JmKffmwxS/m7A0bI7VsXWbkb0JhMU1knAgbPQDuh5DsEinkDWwiXFh4tm8BbdDQ=
X-Google-Smtp-Source: AGHT+IEqCO9Z86Wc/aD7cMGoDZdsv2MH3Z+EHGDa18MN1P+gR4QtHe2kA90fKoFdnetpV6XOEyKMNg==
X-Received: by 2002:a05:6402:2791:b0:5cb:666e:9f8c with SMTP id 4fb4d7f45d1cf-5cb8af97d8bmr1943092a12.32.1729683248995;
        Wed, 23 Oct 2024 04:34:08 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a65451sm4275667a12.27.2024.10.23.04.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:07 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3EC7A5F8CC;
	Wed, 23 Oct 2024 12:34:07 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 03/18] MAINTAINERS: mention my testing/next tree
Date: Wed, 23 Oct 2024 12:33:51 +0100
Message-Id: <20241023113406.1284676-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I put it under my name as there may be other maintainer testing trees
as well.

Message-Id: <20241022105614.839199-4-alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3bfa132fd..ef1678a1a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4080,6 +4080,7 @@ Build and test automation
 -------------------------
 Build and test automation, general continuous integration
 M: Alex Bennée <alex.bennee@linaro.org>
+T: git https://gitlab.com/stsquad/qemu testing/next
 M: Philippe Mathieu-Daudé <philmd@linaro.org>
 M: Thomas Huth <thuth@redhat.com>
 R: Wainer dos Santos Moschetta <wainersm@redhat.com>
-- 
2.39.5


