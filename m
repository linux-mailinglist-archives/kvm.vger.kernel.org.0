Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916EC1E98F7
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgEaQk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22365 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728352AbgEaQkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q4vVNWwGJ6X+mCxN22qm0JQKHOJ0PdAaDdcsNO2TkXQ=;
        b=XP9q1aAsYf1Fr7PLqqnnARozlJZiWStmALF/X+i7vMcGElQWS0/1QB1YzMPzebpPpYsWJj
        DVQltubJAWskQ4AtSPbScOeCKPn4j8GClvEcvyvuGcLj4Zj3HguLLfwphApio1ZHoDZoC4
        fxCTTD4WXuWk+9tzcuA+9aYZUOSdPlc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-v5aZ3Mg9PEe2Xz7I5S9-cA-1; Sun, 31 May 2020 12:40:22 -0400
X-MC-Unique: v5aZ3Mg9PEe2Xz7I5S9-cA-1
Received: by mail-wr1-f70.google.com with SMTP id p9so2659828wrx.10
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q4vVNWwGJ6X+mCxN22qm0JQKHOJ0PdAaDdcsNO2TkXQ=;
        b=l1G5UHBNdcBK68LKsAfOm5dkGifzhrT7dK2pMt0jNrjwlqsTlz/Au/na6ZJ1O0wIC/
         vENmos1bFcrCT+PvLuqPkRspw0SAKXBwgfMmCEXu10fSzghd0lpTMurFPnrPV/9q5cEJ
         CYWX32/Kf9HdFYNiXherRdZ+NPiMMEShP15dHIsPTsf3Kw6BY3LeiNKy/BHREDTtfNl0
         7GPjO3IvH2YM0+SHA/xyVi7+NL96VpxFvUl68iqd7FDvpC/MA5rqyA4R8OeBf3ry2MOy
         V51Gux9nPGis5XbOMRr1ElhTJDqbhZgIjuIeyM5krw8wf36NH2VKPyAYWIT8VQJNhwrT
         RHeg==
X-Gm-Message-State: AOAM532Ik7hIaYDe4wyqUhZUv2eVvBz42tF6iH9mjqi1giPfPz0Q9Kcz
        qnjNq0a4X08rf0kBOA/wwSqczFrheTghS8lNOVgYfF5ocErwUC3UM2+PmiBl3bu0SUwrOOODjIh
        /2AMHDDwHW4Hl
X-Received: by 2002:adf:eec2:: with SMTP id a2mr17399492wrp.136.1590943221350;
        Sun, 31 May 2020 09:40:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTbjh1kanaHu4mvEz5G2IetIDATr+AlkqOK/pFPgvXTE/QruP8PTveawBN85Yr0c5UV+YrRQ==
X-Received: by 2002:adf:eec2:: with SMTP id a2mr17399473wrp.136.1590943221141;
        Sun, 31 May 2020 09:40:21 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id a1sm10072069wmd.28.2020.05.31.09.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:20 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        Robert Foley <robert.foley@linaro.org>,
        Peter Puhov <peter.puhov@linaro.org>
Subject: [PULL 18/25] tests/vm: Pass --debug through for vm-boot-ssh
Date:   Sun, 31 May 2020 18:38:39 +0200
Message-Id: <20200531163846.25363-19-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
References: <20200531163846.25363-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Foley <robert.foley@linaro.org>

This helps debug issues that occur during the boot sequence.

Signed-off-by: Robert Foley <robert.foley@linaro.org>
Reviewed-by: Peter Puhov <peter.puhov@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Tested-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200529203458.1038-5-robert.foley@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/vm/Makefile.include | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/vm/Makefile.include b/tests/vm/Makefile.include
index 74ab522c55..80f7f6bdee 100644
--- a/tests/vm/Makefile.include
+++ b/tests/vm/Makefile.include
@@ -91,6 +91,7 @@ vm-boot-ssh-%: $(IMAGES_DIR)/%.img
 	$(call quiet-command, \
 		$(PYTHON) $(SRC_PATH)/tests/vm/$* \
 		$(if $(J),--jobs $(J)) \
+		$(if $(V)$(DEBUG), --debug) \
 		--image "$<" \
 		--interactive \
 		false, \
-- 
2.21.3

