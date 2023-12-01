Return-Path: <kvm+bounces-3125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A963800D2A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EF74B213DE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A4F495F3;
	Fri,  1 Dec 2023 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GDGZhfr7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E7310FA
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 06:32:06 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-50bba1dd05fso3072095e87.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 06:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701441124; x=1702045924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xwueZRhq2TeT+o6ic/j7f+3sIl0gG5LOrM78r5l+kjU=;
        b=GDGZhfr7oRa1f3pof4dTVPuIrP0f3VAoXgw9Ey7OYz5zoYj9XDPDQ3dDCyb+86i+z9
         mYL1G+kih6Ry/g0UlIL8gAwPQbve5y7eq010H36sjJDg3QboDxzqe0MdeBL+ZPgAumYX
         1ifWVzalldYF9ufGtfJp5KmGKMeJnfzK3orc4gbFGSzduJbuZHPdjA/uUedN2JVxvm67
         tmhBTqd7f0XjkKC4tS120glO/jVyE2bdNaX23vf7EoLQYg0a3gfC5LIrSOwG/LJyxf6x
         Of6MRk02IDBzPXrrUe8jhz2wFSDVinvUcjJJh7jveEF16D9GHX7Hmxg7Ec5IKKYxTo+V
         FgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701441124; x=1702045924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xwueZRhq2TeT+o6ic/j7f+3sIl0gG5LOrM78r5l+kjU=;
        b=aBhgRp34tT+r5XDuig3fPLs79epwQ3NhdMzbT6XfYP1nKUN9CKjbfil37tz7Rq0sxx
         JmHI8ZN25JA1EcH0vdMlckpZJlHRo5W+R4Erz9cxpkUGyWOsGQtkOa/lL/X91YkNj3IQ
         MBUAEICcU7rGVM8ArEd4zxCo3Jx4jFK0o2k2afCZlLN7fh1HKVN0WPrqig4sBGx6/IeO
         DED2q8DM5fmmGu/kDciNqGEIL6Lw8JycFZnsr2932k/Ahiyj0zv+zPEntP8oPt0Ja8DW
         DfmAzDcWGAYrDh6YebS/8OMtBWY7JHbTf6UcSTe7g7yrZIsrk2Vm0nc/meojujrou/vG
         1d3Q==
X-Gm-Message-State: AOJu0YxwSAvu+VKBoDA1/PO4bGp89AbG3q97VFKBlOxYfq8PG/XBFwfZ
	fyRGkmvmfI/4UG/UOPTH21XkXw==
X-Google-Smtp-Source: AGHT+IG+i5oTJrMGcXU3dLzjwDLlF60WGvP45lcq/lrWskltUNDKHSHfD6UrYjW0v1l+7x9xMDtklg==
X-Received: by 2002:a05:6512:318d:b0:50b:b834:d3c0 with SMTP id i13-20020a056512318d00b0050bb834d3c0mr1133486lfe.32.1701441124226;
        Fri, 01 Dec 2023 06:32:04 -0800 (PST)
Received: from m1x-phil.lan ([176.176.160.225])
        by smtp.gmail.com with ESMTPSA id f12-20020adfdb4c000000b00332d3b89561sm4338984wrj.97.2023.12.01.06.32.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 Dec 2023 06:32:03 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 0/2] target/arm/kvm: Use generic kvm_supports_guest_debug()
Date: Fri,  1 Dec 2023 15:31:59 +0100
Message-ID: <20231201143201.40182-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Expose kvm_supports_guest_debug() to all targets
and simplify ARM using it.

Philippe Mathieu-Daudé (2):
  accel/kvm: Expose kvm_supports_guest_debug() prototype
  target/arm/kvm: Use generic kvm_supports_guest_debug()

 accel/kvm/kvm-cpus.h | 1 -
 include/sysemu/kvm.h | 1 +
 target/arm/kvm64.c   | 9 ++-------
 3 files changed, 3 insertions(+), 8 deletions(-)

-- 
2.41.0


