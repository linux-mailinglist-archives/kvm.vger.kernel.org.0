Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE4927DC36
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgI2WoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728752AbgI2WoP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:15 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnVaKlxSjgosYNWUZ3C9BB5KnUFHrX+zW6dbopznvYU=;
        b=gseoum29fdMMi9pAAhmaHd/MpI6MgtF4z/bkBo/74ggV083oewrBdNu98p9UrTSOSAZQYA
        K6NAcLuH0/cKtoGLZK7QMZMhxzyT+FkJnn5NTTGbCOb5pEDJLQtCztY+lDUceSmxdcdtvG
        fNh0xJiXpy/WGljQrH7cAFKm+8+mm7Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-N5EKgtdrPGycX8WYivndOg-1; Tue, 29 Sep 2020 18:44:09 -0400
X-MC-Unique: N5EKgtdrPGycX8WYivndOg-1
Received: by mail-wr1-f71.google.com with SMTP id v12so2361617wrm.9
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fnVaKlxSjgosYNWUZ3C9BB5KnUFHrX+zW6dbopznvYU=;
        b=Y3a4le9ZSGWdSWjQnDaiA4KydoGVCw7sh7DMWpPfeMlLd71iGMhFeiynW8hZo6aBak
         sAgWxPNzq6ibcQQ3jNOQymDTy6Foy6hw52ZEtyvFUw2CdOaX9Dr0DpGG5QkzcXxRpEgz
         RrbqKKs6veNIrp4lUhB/7dwcolfScj4aceTXfslu3rJ1czxb+0za9S9tJ9faSLS3ycsq
         e/n+AZRI5MAFKCstRwcdMygUz+1rpk/P6iF/iBXdgayn1AKwlRrbKciFw5wKPdZDGhQa
         jzangOSB1nzM97b3lOTpFgoq6vvYDI9utC8T88jc+7MB0s/Vuj3Kaea9Ho2cM9wwwE+n
         yyUg==
X-Gm-Message-State: AOAM53399S7GDANqgk+oHKgEwvv70GeMD/X5MIhsZ3KcPTQQuglTW7in
        kkcoTUn2SejhLw4pxkwsP5fW4+/LLpv69CXw7d8DtD2yWdGZUv3lsVTATNzOQitTx3nUgbqHCU2
        3UHpgZ7kv0ZeY
X-Received: by 2002:adf:f2d0:: with SMTP id d16mr6386590wrp.332.1601419448302;
        Tue, 29 Sep 2020 15:44:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz32LQg/FraBPNB2aGTQWNffth7R+ByzmBlrprh0rhJbQuVc73LtYh8e6YQu2ibVKmeTxTjoQ==
X-Received: by 2002:adf:f2d0:: with SMTP id d16mr6386570wrp.332.1601419448124;
        Tue, 29 Sep 2020 15:44:08 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id e13sm8276536wre.60.2020.09.29.15.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:07 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [PATCH v4 02/12] meson: Allow optional target/${ARCH}/Kconfig
Date:   Wed, 30 Sep 2020 00:43:45 +0200
Message-Id: <20200929224355.1224017-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the generic Meson script to pass optional target Kconfig
file to the minikconf script.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
We could use fs.exists() but is_file() is more specific
(can not be a directory).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Claudio Fontana <cfontana@suse.de>
---
 meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index d36dd085b5..9ab5d514d7 100644
--- a/meson.build
+++ b/meson.build
@@ -529,6 +529,7 @@ kconfig_external_symbols = [
 ]
 ignored = ['TARGET_XML_FILES', 'TARGET_ABI_DIR', 'TARGET_DIRS']
 
+fs = import('fs')
 foreach target : target_dirs
   config_target = keyval.load(meson.current_build_dir() / target / 'config-target.mak')
 
@@ -569,8 +570,13 @@ foreach target : target_dirs
     endforeach
 
     config_devices_mak = target + '-config-devices.mak'
+    target_kconfig = 'target' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
+    minikconf_input = ['default-configs' / target + '.mak', 'Kconfig']
+    if fs.is_file(target_kconfig)
+      minikconf_input += [target_kconfig]
+    endif
     config_devices_mak = configure_file(
-      input: ['default-configs' / target + '.mak', 'Kconfig'],
+      input: minikconf_input,
       output: config_devices_mak,
       depfile: config_devices_mak + '.d',
       capture: true,
-- 
2.26.2

