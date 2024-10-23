Return-Path: <kvm+bounces-29494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F0F9AC952
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5D511F2179A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8108F1AB515;
	Wed, 23 Oct 2024 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ITxa9Mtg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E870F134BD
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683847; cv=none; b=ZTFYgnSKfKSrww6kk2jGNlzC2sqWUylqK4/H+0wQU+CUsO/w5p4xwkNi0aHRqMvdEBIu6ymoWUlPxcSS53vdilHP0P9kgrvLvKCXvJnuEM/lLH3/1UgLlhHTueWztl1exwKFectjrZofBT0vAAxVbh13cH1H6BxgNhGURYuYvzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683847; c=relaxed/simple;
	bh=BXarhcb40GWzuIYmnr+ci9E7FXXyvsSMVj+QBu1fn8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HT7FDhC6QAkDhSke/x3O95L9goyh7x3Pf9p0JtqlRkaz0qIfdOJSSD0l/iEaC/eWBKWD7qKrXiUbctMcbYlNrWs9s37iXJdLWD1YjKxpEA/F2N+NzVSrYJvpZ6EsWHxJnWApq7GZlA55qH2tRaAt9e1XHYhhLWyyD4g4NYeV1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ITxa9Mtg; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cb6704ff6bso4671433a12.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683844; x=1730288644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/D/QQxPvGmndZaJy0kEIveJUD+81sSd1CLz3T6BVVI=;
        b=ITxa9Mtg3RfEwxRzVJwAOfA1Va9griMjqMCo5NoMMUr7FO7agiV8rzEKNd48H/s3yx
         OgYOLl57DT9M6HFQ7KE7xyl6EDmtqssyfqG84MZ74FLjHwtPiHPoRJWYVfbCZ2RQWa2P
         ihxZxGO3fxVHm9cUY6l5zwXAeUwh4M2fBObiSx6m5kSV3mvymjdfTR1wUVX30WRl9fZO
         8lUgzjKgdxoE4+igN9ktmBfBBMFbiOa0P7n7+blYnsHD7AO3895oF+ZyYRDSeCs4ncpU
         M8DPzizVq6i/Uk+6c9/HhZuTb5bbe+6I5Cno86P0D9JFDGu9y6flv3OvaJekQw6nmc1s
         O92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683844; x=1730288644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/D/QQxPvGmndZaJy0kEIveJUD+81sSd1CLz3T6BVVI=;
        b=hPafjW5sba8T/SIjlDRNPX4GDgEbfMXBUPsPi942ALvf5xqWScrqptB3XrvHm7S8oy
         nU4WBewGWXClc+4hBexke7BmA5Cy0dU3GkgAi2yfxb10mPj8bXHDbJB6waCXc33hkCug
         FT67gHyLs/vFallWHWqHuQwpcuYHdcIZLePcCj4BxnBbRkuX8pfEsxfBqU4JbOfsXX8r
         A96LC9fIwLWKqW9DDbdPR1zsToo7Drq0Z2lmXGmWR9FYJj4nm63kSGpjySG2uHHWw9aV
         fhYt1hbmOn6Tf4hiXg/g2Sc7U5aCpUyrKnNcKldkLWmqRX2NvtZTKyCZecriP4wSS9lW
         B18A==
X-Forwarded-Encrypted: i=1; AJvYcCUhByXNht7pAYS8bXF87z0O6G82JDuhcCJft0SqiVwYCryusopyEif/MDXXzJXjsVDVN2w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFpz2jte0YTgc3FGlyLKMLSLQtORF/HjFb+ZeP9JzpWDz5cnex
	gBHfopyyk9LPajU+NJplqu5czcLmUM0yEZkaR7y0YqDoSDVMxbO14Eb1FRw2Wew=
X-Google-Smtp-Source: AGHT+IH3zSM2BlEpP3N6KkqeMBnwOhxkf5fGgndxyFj6xPVN+t2t4+UZ5S+M/nxkFu4HGabpb7TqCA==
X-Received: by 2002:a17:907:9405:b0:a99:ee42:1f38 with SMTP id a640c23a62f3a-a9abf8aefbdmr202024366b.31.1729683844062;
        Wed, 23 Oct 2024 04:44:04 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912edc33sm463333266b.58.2024.10.23.04.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:44:03 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 7FB525FC11;
	Wed, 23 Oct 2024 12:34:08 +0100 (BST)
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
Subject: [PATCH v3 16/18] MAINTAINERS: mention my plugins/next tree
Date: Wed, 23 Oct 2024 12:34:04 +0100
Message-Id: <20241023113406.1284676-17-alex.bennee@linaro.org>
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

Make it easier to find where plugin patches are being staged.

Message-Id: <20241022105614.839199-17-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7eea7b7954..5b6c722a20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3708,6 +3708,7 @@ F: include/tcg/
 
 TCG Plugins
 M: Alex Bennée <alex.bennee@linaro.org>
+T: git https://gitlab.com/stsquad/qemu plugins/next
 R: Alexandre Iooss <erdnaxe@crans.org>
 R: Mahmoud Mandour <ma.mandourr@gmail.com>
 R: Pierrick Bouvier <pierrick.bouvier@linaro.org>
-- 
2.39.5


