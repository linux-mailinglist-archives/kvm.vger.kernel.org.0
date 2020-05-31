Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AF21E98F5
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgEaQkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728206AbgEaQkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYPUmQb4YdG6fVvlkNEcNWtgTrI955nKbvTxVdHF9pE=;
        b=XE6HymxVU92x1ivgArpiHGe0JayPsLUOatJ6Ea5bP6m3rRM1vbcQRaPAQ87AjUZH5Kxr5e
        YbpkK6VJw3Av+n7bZ2ahmMqYSt49w3Cu79oiul+MQcDlgYDC2Rezp1PZpDUIlPPCDrMcCp
        l4ontoFdTe/hrKQlclAz/oObF/dhke0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-sGRhHpVfNlebwP4JHKltxA-1; Sun, 31 May 2020 12:40:12 -0400
X-MC-Unique: sGRhHpVfNlebwP4JHKltxA-1
Received: by mail-wr1-f69.google.com with SMTP id p9so2659659wrx.10
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZYPUmQb4YdG6fVvlkNEcNWtgTrI955nKbvTxVdHF9pE=;
        b=NNA5mQzCULnciLZX9vIz0AZFxWnOTUt67vomWVDi6bIJ9jVSAK6/T+/ss1MJww//Pt
         wMLpnLOMRFtSRSDi9dcN48hZT2Sf3aK+n6FT7zKGXhjYe8Ep1GEpoAnojZ1QeKQvDBih
         iMaxJChXhHSSERTy0UcmYC6ba7VzaJk+bgrrenj5KQKIBvONC8E3VpYp2Q1EvOhZ3oiy
         YkjP3j0p1AoHVuRhmj4Ws9qQQF8ffUw4Oksx86xDY4ru8+WoBTx1ad2EIr7wdKP6ThjN
         IiTpwyjXxduWAFfJp7R011iqIGVgcTOtkOLgER4MKa87cS92+m66qpF1RuEi+ASPL4Zg
         S9gg==
X-Gm-Message-State: AOAM531PiXXpgotFR1V3oH+njQkGSU0YrX4hVsDJZvSkArqtUbBMYX1+
        9HzJCu4eIFzapJc2mtNywhnIYPe4KSOwRaWX4Pnq1+SYlyX2Z1x2GzJnC9m73n94c2kqPoc/DLb
        AwsEkbFHlfGxw
X-Received: by 2002:a5d:6b85:: with SMTP id n5mr17895545wrx.11.1590943211355;
        Sun, 31 May 2020 09:40:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRd7yv6wPdWcd+XCZmDkbf6iSWHFTnRixvYzZNCu7K1dThRp4MzloCWxTm7st5mmh8HR0q3Q==
X-Received: by 2002:a5d:6b85:: with SMTP id n5mr17895523wrx.11.1590943211151;
        Sun, 31 May 2020 09:40:11 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id s72sm8428958wme.35.2020.05.31.09.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:10 -0700 (PDT)
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
        John Snow <jsnow@redhat.com>
Subject: [PULL 16/25] python/qemu/qmp: assert sockfile is not None
Date:   Sun, 31 May 2020 18:38:37 +0200
Message-Id: <20200531163846.25363-17-philmd@redhat.com>
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

From: John Snow <jsnow@redhat.com>

In truth, if you don't do this, you'll just get a TypeError
exception. Now, you'll get an AssertionError.

Is this tangibly better? No.
Does mypy complain less? Yes.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-21-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/qmp.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/python/qemu/qmp.py b/python/qemu/qmp.py
index a634c4e26c..e64b6b5faa 100644
--- a/python/qemu/qmp.py
+++ b/python/qemu/qmp.py
@@ -94,6 +94,7 @@ def __negotiate_capabilities(self):
         raise QMPCapabilitiesError
 
     def __json_read(self, only_event=False):
+        assert self.__sockfile is not None
         while True:
             data = self.__sockfile.readline()
             if not data:
-- 
2.21.3

