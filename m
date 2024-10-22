Return-Path: <kvm+bounces-29378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2C59AA0C2
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03D3E2837B1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D90F199EBB;
	Tue, 22 Oct 2024 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VfeL1+KB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28F2198838
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 11:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729595038; cv=none; b=JjMNIg39EYueHQHEttBBy5X0aLe2xiRP0vrQtKmlIQMP5iMMOMTc7PmpAH3HLyglzohMiyxOUnhVwuLxHnEW24IbmhcwWHwuJW57c3omu6p1jjUT6b+w/ViyM789Nnn1H67q45d4zCgN90sOmerqMl425Q7tmGzJaDiUxNmAz4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729595038; c=relaxed/simple;
	bh=FLg9jPHwuXGr2Nk94kzK8K8ojMtKCSdvSv8p/meBLhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSEMjGmnQpj6rWCm4z6kftNwm4ydpjqd+VZUD/AFGnatIsHVwF7fyDipyQT1JmTL0g/S2wX0x3AV8uCFlVatCfHaHSt0KzaY2iM2FOzXGGKZ6PPceFL7CWvxwOgdsFWjHceTadnlxjPRdx204+s/zgvqrwK0KghlshOi5VXC2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VfeL1+KB; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c94b0b466cso6248067a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 04:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729595035; x=1730199835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhZwhDsyP9u5fu/gLDiAkir8lHLMK7A4MI+ExEvLX/4=;
        b=VfeL1+KBCg0Wvjcm7pC7sjQfHeDL5c0PQzGnpG56zce6iHKM7yEMb8B04MEBSydRUr
         zYED5USqWbcznfIzRzPK4U8Wv3/OfUX3OABqtEX4dT2YdZlvZrytjYpl7QpgoCUclQfH
         Le1iJCVmP1/w3EW3zgm8coCtxmxCn4axjOB+asgWmiNpCXKM5RtUw4TpKHcNxUYZM6UN
         lyLDNZ/q4/HkBl0UfGG9QIsYFbCZRgIg48iOf7Q/fYzLVJ3Ymbx3VytuFYtUg+L5g1sW
         DU1gH0faHM3yxJxzIylkvqQFyvYpCPsZPopixVSC4ihOop3FPBiLq2ORH1RpdRhXjhA/
         FgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729595035; x=1730199835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhZwhDsyP9u5fu/gLDiAkir8lHLMK7A4MI+ExEvLX/4=;
        b=S3lTT4ESbumr4dM4gBew1J7rwOzyB6s4pfEVkZgeoNQruweFksGFk1vm+rkuzSHGzI
         4dEYKWvi6akLEz3nkyiUillrzLNzbzBvv9rPQ6HC+O/hOtbFtv8kAYDibIjtemtaC+m3
         WrzlayPlJM7li+qxs61BOHGguhYf0TESVcxJhOQ0pyvnmP2x++PWoyq14AO1CrKmpLW+
         ccQo+0s2+S8IptICf2ptK9wVIkdfSviN8lzk/vQrhOLuhd2wEMHp2zscjjIqNtmhWJj1
         NePwWgVJjcB4OBKktqIIVeIgpuuP7tl18vKX+MDNho4vHW1gpO4WJi5WQyMRqAzd8d2h
         EMoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgxkAInd24ANoazaY0EOGt893bMByOXRVQRASKAxzzfxEYjPxqyQ8qyY98uD6X+WV5ML4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywkq+FI8EHwEgAcjd3HTJtfNInzlYUUw2WE/79Ofz6dRW+nADKk
	HwZ8tiXA41/6oHDGdtyi3s0UnXf6FDUboCQHpctpMeq6gscu/THB6ChO7trhAE0=
X-Google-Smtp-Source: AGHT+IGrsXwXm6QQRI2EJsc5NTDWH/8THorwiRLqjS3xUSuBrUIQM0t1N7fBGivyxVye6YEvh9zvEA==
X-Received: by 2002:a05:6402:13cf:b0:5cb:7295:49b with SMTP id 4fb4d7f45d1cf-5cb72950e50mr4337266a12.34.1729595035184;
        Tue, 22 Oct 2024 04:03:55 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a6a6efsm3001448a12.53.2024.10.22.04.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 04:03:54 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0BE3F5FC19;
	Tue, 22 Oct 2024 11:56:16 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 16/20] MAINTAINERS: mention my plugins/next tree
Date: Tue, 22 Oct 2024 11:56:10 +0100
Message-Id: <20241022105614.839199-17-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make it easier to find where plugin patches are being staged.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 81396c9f15..02b8b2dfd6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3702,6 +3702,7 @@ F: include/tcg/
 
 TCG Plugins
 M: Alex Bennée <alex.bennee@linaro.org>
+T: git https://gitlab.com/stsquad/qemu plugins/next
 R: Alexandre Iooss <erdnaxe@crans.org>
 R: Mahmoud Mandour <ma.mandourr@gmail.com>
 R: Pierrick Bouvier <pierrick.bouvier@linaro.org>
-- 
2.39.5


