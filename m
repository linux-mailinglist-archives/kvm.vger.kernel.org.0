Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4654773663E
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 10:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbjFTIco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 04:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjFTIch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 04:32:37 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4071BE
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:32:34 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9829a5ae978so695786066b.2
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687249953; x=1689841953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9cfwKNlayoFMCCu0sYxAxgZalGAwrCIJSoCGBT1lAzU=;
        b=umrKPnvAZWIpJ8rGJEd5lxMvkUXiDEgSv+w4/Q6SUZ4zPIBO4HxKpVAs7Nc3iKXC8t
         nhF1v7OnklEmdO+Cv/iEgifv0jz8+VReLnCkd3P1WnlrxOHnP9h4Be/x+Jgns4OgW0El
         PyAvUnQ5ztBmO7Uc0A1aYIcK4lu3fAfHKkUQtHb0S0MMhPOEvL1MPewkmuTbfeRYMGlq
         XcjJMnVxxDXaIM/rSzeyC2zMb5ePYKijgSNBefH8WKWnOJvNzPAupS3+wD9DLehnbK6e
         J/ixkPDfBGJuqwQIlhsReDtK8lG20qjxmd+3APJD6wVN/pozSE+hxz4SGctK47R/cNuG
         o2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687249953; x=1689841953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9cfwKNlayoFMCCu0sYxAxgZalGAwrCIJSoCGBT1lAzU=;
        b=Bn0cZX82FBwNyLDQx3NbRtxMFju/Y17olqQjWpucq4K9KgPuVRhf32pQOQk9LPlnE2
         hQcpSi2nxb6eQsRYP3Rpo2RlKx+XHPOujogifJj+L0CjkajFma1XIrj9mheeudO45ZZw
         oHyVIKZr0ES+ZBp2v/JdGqVQFwpKuvG9crndh+ov09IQpF3fbmqP+81rQRwEiUEfjZQ8
         d4rUnHgaOq97E7Otfn/cQr1O6E86Z72l7Vd+YFDp8wsipeKshNcWxnhVpKu24Jxds/8S
         TQOO8ze/rtCht5vJ5vFphViwc7Xj8BeRAgaivQYTmXOdZxTAcRKYoAIEK0bl5Gs+C+Cg
         mF5g==
X-Gm-Message-State: AC+VfDwAZueMTZ6WXnmXpk39QwbRQzN0uvsHXvfi7+ndu07JpMrMufxX
        OhnFVrQsFvlZOw6YgwXpC05iKg==
X-Google-Smtp-Source: ACHHUZ4Ca/MEHHlBSV/4BaX2Qj2sdr8O612CbUsqUq8kznOCL6pduwIkW9foHMoG+BAoSwLUWCTlLw==
X-Received: by 2002:a17:907:6ea7:b0:988:9836:3fdb with SMTP id sh39-20020a1709076ea700b0098898363fdbmr5814988ejc.11.1687249952909;
        Tue, 20 Jun 2023 01:32:32 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.183.29])
        by smtp.gmail.com with ESMTPSA id r6-20020a170906a20600b00982362776cbsm956473ejy.118.2023.06.20.01.32.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Jun 2023 01:32:32 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/2] hw/i386: Cleanups around kvmclock_create()
Date:   Tue, 20 Jun 2023 10:32:26 +0200
Message-Id: <20230620083228.88796-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After removing the kvmclock_create() stub we restrict
"hw/kvm/clock.h" to x86, the single arch implementing /
using this.

Philippe Mathieu-Daudé (2):
  hw/i386: Remove unuseful kvmclock_create() stub
  hw/i386: Rename 'hw/kvm/clock.h' -> 'hw/i386/kvm/clock.h'

 {include/hw => hw/i386}/kvm/clock.h | 14 ++------------
 hw/i386/kvm/clock.c                 |  6 ++++--
 hw/i386/microvm.c                   |  6 ++++--
 hw/i386/pc_piix.c                   |  4 ++--
 hw/i386/pc_q35.c                    |  6 ++++--
 5 files changed, 16 insertions(+), 20 deletions(-)
 rename {include/hw => hw/i386}/kvm/clock.h (65%)

-- 
2.38.1

