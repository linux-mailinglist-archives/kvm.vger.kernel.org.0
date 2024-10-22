Return-Path: <kvm+bounces-29372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 541129AA09D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 816611C218ED
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D731319D891;
	Tue, 22 Oct 2024 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XvlrOaEQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AA919C543
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594594; cv=none; b=aeb/sp9LbIriYi0fVFx2A0SjmC+o7189HDgliOT9NMagjoGxlOc1mz5/QSd9SoYUQaD803JTRB5BxD8PqiNXUuRyWfKl+nkyVqf7pg8oD0CtKUFVKIf9+eFcNw5qzneT0lVq40sNFNS9Q7/UeW+wg8V2i66svb4y8C0PfVwi04M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594594; c=relaxed/simple;
	bh=W9oqkuoqnG3CzN1HaJ//sVwJsa3g5RCIP1k2aZEBCW4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlT3Cb3LoutRfNvKaHg0VpydM6evbvLZrHA5kunvzbRUAE65KrEVocLIwOP+gCU0PZ5Ne6WqZltmJdRuIFHVUxnrgaAe0Joz02jp0NMZeeOCvxC3t8pn0n2wBMdCH5CPUkafsDyhrpsE+MCZ63WmBbq1yrecSq5r9McWoi28Kq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XvlrOaEQ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c935d99dc5so5891147a12.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594591; x=1730199391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2jXJE3FbWlzhHC2JLNXh46hRwsq96dE8ivUr/Ry4PY=;
        b=XvlrOaEQ8J7uevmXj4FZNv6rc2aos36jBCMn4C7Bet0ZoWrBtA2TrT7ugVO+aIT4VF
         mNqWkDsP0yk4SyEKkqacmtTUu03OvwerOpSZ2OVHxfKDw/5fu58vdNlWHDUf56+4BcTT
         FvXKQvEXeYDbkMfKlMln92zAB4/Vjr6Jq38aG7JL1MPsYDYlbSMkDXtr7ABFoc/6Edjy
         +t97l+jf1kfEnbS652rdyibwQX+vcW3G3L79SpaDYthBCbGFy6YWC0z/GQWINadtKMWC
         KXot3i6b2UySZ7bw6pZlOeFmKy7uCtnyx2AtyQIuExj5Vgskr/9aT7GtLZW4e8KaHOw/
         uQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594591; x=1730199391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p2jXJE3FbWlzhHC2JLNXh46hRwsq96dE8ivUr/Ry4PY=;
        b=qsuQa3uKb2K9fHN20hnX9YVH5kWObZiuHoZIo2ltYLcofPOOlQqRmruzCC7KKeQKpd
         MsAjz5aNjK3sG57w3Egzi7O7msW3XX2Nb5WCbrjnJzFpYpVAnBMfd2TG18UfH8Kx8iqh
         slDWORXZQBOffuI45/QoH/ZoBTRFB03Ao8XSwjmqRvlqE32rDmZWuDa7V8R2+GxTw2kn
         JXd9helDkL32J9lLQBx2JOwrCxa/BlpFq46EDxS8oA0qxNK5PUhRq1FsL+ZpEPW5iNTw
         s1kxkFN/L0xEwHQi+UcJ8+O1shVyJ393/TCXLh/LyYNA1hEP8FXGl7LkMCSA7933umdA
         tXTg==
X-Forwarded-Encrypted: i=1; AJvYcCWe/3x9IVBSMjvDYem9LnGkMfvnhZu8+9/sUB27lXpAcHwXZpmgAvLRH0Pc9HQCubk2QTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcO8HsCK5mNIW44jqh7CQCP29rlRcdGJ8YF3QXd+gegpNnL8Bo
	X3tb2dgGh3Z7q4uKvMR+2kiXQNvvqWs6VkuQKSnsm8DuPp4oTp39JDtzC1+dViQ=
X-Google-Smtp-Source: AGHT+IGUejPeSVv+t0DCi7SW64a6BptBW33UQRq4rjvBjk+8TQgWaYTlBD5pezBspgvI4FXlscux/w==
X-Received: by 2002:a17:907:7da5:b0:a99:4aa7:4d6f with SMTP id a640c23a62f3a-a9a6995d6f8mr1533790966b.12.1729594590554;
        Tue, 22 Oct 2024 03:56:30 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912edc33sm321455366b.58.2024.10.22.03.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 99FE35FA0B;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
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
Subject: [PATCH v2 11/20] MAINTAINERS: mention my gdbstub/next tree
Date: Tue, 22 Oct 2024 11:56:05 +0100
Message-Id: <20241022105614.839199-12-alex.bennee@linaro.org>
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

Make it easy for people to see what is already queued.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b84787ae1b..81396c9f15 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2978,6 +2978,7 @@ F: gdb-xml/
 F: tests/tcg/multiarch/gdbstub/*
 F: scripts/feature_to_c.py
 F: scripts/probe-gdb-support.py
+T: git https://gitlab.com/stsquad/qemu gdbstub/next
 
 Memory API
 M: Paolo Bonzini <pbonzini@redhat.com>
-- 
2.39.5


