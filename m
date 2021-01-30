Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1835B309175
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 03:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhA3B4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 20:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbhA3BxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:53:24 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A7EC061756
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:52:41 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m1so5253344wml.2
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G9dNmRIohMTgXAElzkQ+lpMLRmxhHG61au1rY6dJdIw=;
        b=PEjpazXUgk6kR6UqDmwU45UySoXQLcz5AUjh6P8ScUgFkBsPisn+Tm/qm9hBMUWlxU
         bXEcLJ8UugY9aEVPQbo6p4m/Hux6j9xRlGgX4nFBl3CdGdq2BBIrSjLEO86Z4aoFc8pO
         sOUDNxqSQ0sq11WskYH43JUY8ipQhlYj/w/bYvz/VXaBRpbw+O5FYEX3aiwba24dV37x
         eXoZz8Ukp5kBBqvvXXbiR7M0vIrCWLxvkVDzdRwwembHyYCl3SSmuG6HSoiE25+STMef
         fVEoHq1XKPD0QMR5koqBX/Yf7PEsrpn+QnhlP/GxxXqA9IDdom/mYPcwNcgu4Y2ATxaQ
         whbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=G9dNmRIohMTgXAElzkQ+lpMLRmxhHG61au1rY6dJdIw=;
        b=t797YXQ8PaLabsOW/Ok8Fn+ASCaaR437TOaUmAYVt9e2LFsQE2+sY4PrRuy/sWu6rU
         hWWXQUxBD0JNZeK4OtWKcJ2DgPK8z7YpHRvOxssJBmUOhDY7TGaFE/sBvJ3CMUThVQHY
         XJoCoBVw7murg/+2FU8w1tVb7OeLcfFuQlarJtBIj+5OfpV+o9v4diEI6C/zbKGwN5ZN
         bdBw/BZg9UPdS5O2jLvF8iWUKXZfDTKgAOLX1iCvCp7ACKGspysh/XJYvPk7DyrRORyv
         R3ieDQqbE9uBNmjY3Homjo9TfzhiwFkBC33olN2eNC1yahhMIHYYx/E0reNUW0VKAe8p
         l3+Q==
X-Gm-Message-State: AOAM530G1ow1yPO1UEfaGgyHQTqq8WhFQYk3uWaz3UtlXK/gavu/03De
        ADk3YeAFlOflZWJ0z3cxpys=
X-Google-Smtp-Source: ABdhPJwskto+f53o9TCaynYuVK8iQ1uBoTdTN+CKWcrz2acq5nnSN55h/BCj1DXRiUJLZD6Cr+Hp6Q==
X-Received: by 2002:a1c:21c6:: with SMTP id h189mr5786718wmh.173.1611971560647;
        Fri, 29 Jan 2021 17:52:40 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id w126sm12485133wma.43.2021.01.29.17.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:52:40 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 02/11] default-configs: Remove unnecessary SEMIHOSTING selection
Date:   Sat, 30 Jan 2021 02:52:18 +0100
Message-Id: <20210130015227.4071332-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 56b5170c87e ("semihosting: Move ARM semihosting code to
shared directories") selected ARM_COMPATIBLE_SEMIHOSTING which
already selects SEMIHOSTING. No need to select it again.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/arm-softmmu.mak | 1 -
 1 file changed, 1 deletion(-)

diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
index 0500156a0c7..341d439de6f 100644
--- a/default-configs/devices/arm-softmmu.mak
+++ b/default-configs/devices/arm-softmmu.mak
@@ -41,6 +41,5 @@ CONFIG_MICROBIT=y
 CONFIG_FSL_IMX25=y
 CONFIG_FSL_IMX7=y
 CONFIG_FSL_IMX6UL=y
-CONFIG_SEMIHOSTING=y
 CONFIG_ARM_COMPATIBLE_SEMIHOSTING=y
 CONFIG_ALLWINNER_H3=y
-- 
2.26.2

