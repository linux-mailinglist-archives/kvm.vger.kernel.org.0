Return-Path: <kvm+bounces-29359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA719AA08B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C434283A1D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEC719ADBF;
	Tue, 22 Oct 2024 10:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wWF5RZsi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312DE199246
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594581; cv=none; b=n326xcVNs+HTKxAsW5rr6NxZK20oMCJ7tiECmipqT+gyioX9fOHt5tTkBgsbNwHbLVGJneNoNvRSw1y6ZJ6P0TIgrDpwxWUJ178fFmyj++1Z7eto2Ah0G397VydsJKFn9wRRSja+9SURArER0pz3Y/UtJKvMp6b5sz+Cky+sga8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594581; c=relaxed/simple;
	bh=abAMXQAwQ2MoPuA+FlXwtgJwTb8SfN7qI0SuliOBmuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oyk305LBalFXAspvhLyS/ambt3tcwcjoD1ZnizR3pD4rnXaCxgjlmMTOPhvMvONc72kuotm34oFTMXqo9R70KMcGCWWpvLeCTbyAUwxcPO7sKrO4y6ebMSZvpdthEy96a47pvReMqsRURfszaLhA6K1unDl5WZa2ZMyRP0o4BvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wWF5RZsi; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d4ac91d97so5282404f8f.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594577; x=1730199377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VedVTeltUD2hOjhTzgZcTRLZkzOYBwLXkPWLhE+aU3A=;
        b=wWF5RZsiCwbBWwIlZgwQUw1EHOuNScuw3v9sDQOfuaSW5eMzPixOo/TiV7PmsUHg1a
         y7DQdSirlOi1kAGptBEKgIKv/2QUQeMZdXt8QrhmfUszizNnScd52ejMOg/2cI3ojN/e
         eu2kDRdyrgoPOLmrZW8b/zZz+jH07zSjOJe/hJS4odBP1TEUkoq/LTmWozJYe5X8NR7c
         yEtvrk+OV0hHC4257gZJGLez18eYpZr2w0rkf6tAJvYVxdUWvAL23OnYns64wthHfPf6
         NJPs+UxRI77b+ZKokZKdLpUfvPDhAQm3gdn2G+CVSeKHgawiGIQc8LvclKD0Eo10DIWW
         bR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594577; x=1730199377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VedVTeltUD2hOjhTzgZcTRLZkzOYBwLXkPWLhE+aU3A=;
        b=Xar12vyE9Xl4NesIyUBiXFmA/nXamCsCz8Hd4uVbc1hPpWG4AKzB0DRf9vFMbqoPbJ
         jhnpmXUBildrXr8M0Sy1wjHJI2Ym4E0U0slscGty+3V4FjbCwXO3Wwa0veWh8IHzoDxt
         6jTDG+26eVhtNiczMaIOUhUTRzwACx4Z9fQ+e/rztlmhHvDkrnHaetaCle2dqdlN/Sm5
         4VlpWyO0bKwfBpoVVhe6kiiSmRzJdj0Jg/iHYfnf72OXoqaDR6UfCNlO2K/jjKe3Yj4O
         xCOmMMI3FqsAHfQvMfEY2q+/351keTmKevfkMaUrlWTSq2jj+mERpyO80P220IrMdYJY
         gPBw==
X-Forwarded-Encrypted: i=1; AJvYcCW+63gqmORZr2Qx4ImgZ9tWvTSW6GwClfAvccNfVrUhM52v/RmwotqIAZ7vPv33TnDcIC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YximVftY8uUR0qf+e/JK/4Or+RaFvQaK6wVKDuUcT3PAnvFv51j
	B+o4/nihikzBD2xRYLSe6OMey+tG0Y0owFZb4pR3a3zK8Z1iuLXb3fplV5UjrIU=
X-Google-Smtp-Source: AGHT+IEkxGTtQDWx75WFvqG2eOnkN/ttLbD0g2OlndDgZrl3BuDo9P5GA68WBIt5JhY19RGUOaJdnw==
X-Received: by 2002:a5d:424c:0:b0:37d:51b7:5e08 with SMTP id ffacd0b85a97d-37ea21d8fbdmr11273254f8f.18.1729594576819;
        Tue, 22 Oct 2024 03:56:16 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91572abdsm326459266b.171.2024.10.22.03.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:15 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E69C95F8D7;
	Tue, 22 Oct 2024 11:56:14 +0100 (BST)
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
Subject: [PATCH v2 03/20] MAINTAINERS: mention my testing/next tree
Date: Tue, 22 Oct 2024 11:55:57 +0100
Message-Id: <20241022105614.839199-4-alex.bennee@linaro.org>
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

I put it under my name as there may be other maintainer testing trees
as well.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c21d6a2f9e..b84787ae1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4074,6 +4074,7 @@ Build and test automation
 -------------------------
 Build and test automation, general continuous integration
 M: Alex Bennée <alex.bennee@linaro.org>
+T: git https://gitlab.com/stsquad/qemu testing/next
 M: Philippe Mathieu-Daudé <philmd@linaro.org>
 M: Thomas Huth <thuth@redhat.com>
 R: Wainer dos Santos Moschetta <wainersm@redhat.com>
-- 
2.39.5


