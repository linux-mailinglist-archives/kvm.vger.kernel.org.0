Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE60186FC6
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbgCPQOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47959 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732062AbgCPQOV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:21 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 12:14:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMtlamo7Zl3wCiVgcr8iciiwh4khJI79F07LAInMKRc=;
        b=S82D8YofBZZxBHKff+KXXUNL32EI4mq5wct+Dv2jBoaD96A772iuz/zmxDC2K+QOwCHBO5
        p30l/k4sLNPWBfiXUObLHCo9Z32afm+3kXkkYahv33evV5MXXfLGfCb4gTcv9rSIJMdH2z
        fAw+r/zqkqxjgmkUXWrYSXfqFNcudmk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-l8UuJ0x_OCuyPrEX8w-EiQ-1; Mon, 16 Mar 2020 12:08:12 -0400
X-MC-Unique: l8UuJ0x_OCuyPrEX8w-EiQ-1
Received: by mail-wm1-f69.google.com with SMTP id p4so5071050wmp.0
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kMtlamo7Zl3wCiVgcr8iciiwh4khJI79F07LAInMKRc=;
        b=fFXCXWWbb1itZ9HueJuxm9TrLyF+BzXF65QXdi6R3P4kvg7bkCtETZuTBv1lNWSV7S
         CUc5P5wgq8E9N7WgAUHqOlfrpcOpwHCKGmVCx4eg18/Y9Y3RGf1YeAG+8eg/+t7Sg2By
         //43xeYjoYeJR3JSRqxKkHwGHcK/oGBChj/p3cwC4rY/a8CARm46FexJJQPwEvCCFGZr
         HC8Fhl+B8RYH43SDsvmvnFyrQOgGFbrdgQsZMWVC7ZQJr5RIFjoN79YWvpVB+WxA8CK5
         ccYlfFyB4Nj8lsOd2gbqrpUdOD9JjzEYhInHaYD7el65qRqrVamawnuYU3FB+kDByNan
         p7AQ==
X-Gm-Message-State: ANhLgQ0IlVF9ECtBsEQ+qnyEQ0PmEsmDo7XOfgrb1Mehkn8JKTHDqqHZ
        sNa+6mtY3nDxpm9G6qPwFUT2KNv52eV3HmYd2IdyGYtUO8sUV6PjR0i+sGbvuDrPb74M1X827hJ
        hL0a+XFfaIkUH
X-Received: by 2002:a1c:3241:: with SMTP id y62mr29793851wmy.66.1584374890988;
        Mon, 16 Mar 2020 09:08:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuQxAMoxg+u/+lPk/pzDgAO3wAjX2ARHQMgEZz41ANJhw8Gpk7UQYNDXjdjZkbYOg+VPhVfcg==
X-Received: by 2002:a1c:3241:: with SMTP id y62mr29793824wmy.66.1584374890780;
        Mon, 16 Mar 2020 09:08:10 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id 127sm70683wmd.38.2020.03.16.09.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:08:10 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine on KVM
Date:   Mon, 16 Mar 2020 17:06:32 +0100
Message-Id: <20200316160634.3386-18-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When building a KVM-only QEMU, the 'virt' machine is a good
default :)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index d0903d8544..8e801cd15f 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -1,5 +1,6 @@
 config ARM_VIRT
     bool
+    default y if KVM
     imply PCI_DEVICES
     imply TEST_DEVICES
     imply VFIO_AMD_XGBE
-- 
2.21.1

