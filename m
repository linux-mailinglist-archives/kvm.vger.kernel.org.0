Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB506D4622
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjDCNtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjDCNt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:26 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19256E95
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j24so29470751wrd.0
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjJ0WrIm2Di0AKuPGaQhGuqTtmI2bcqfL0u1knytYyA=;
        b=JaVTpA1WR5Yo7HRGCieD9YHpHG6U+azsDNIGhcFsSoWXaTyGJ5nteWKiXEEwk/kw5K
         4z/HoY6XttEATEGH7ML2L997lwjyaICp58vZdfBt7Ul4c19wLOOL8BaRtOmvSRUuhed7
         F7xab7P0e5GN5SX2AiIVAfbcRe/dg27YalMfRch9sGsLGTKbnuA8YicvcomfH+IfCH9r
         yVPY/U2gVCrVeue5OHDtNrUdHp/MGzzkoCWB1mxWhuzHAzkS8TVmgzbRXCEx5/h5OI/5
         cq4Yc7i4nLK00nhoQn/G9sEJn3XzQD/Ddu+otDQolTbDvgrnOtmxHCp7MTofBVl/bMtO
         ZnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjJ0WrIm2Di0AKuPGaQhGuqTtmI2bcqfL0u1knytYyA=;
        b=HTAwfnGYIBo5lCF/bnMqABQ4cYjK6ec2GTCilVfpG2wAH3Y44N/eSSGm8lf0uJ18SQ
         ZoeC/XdIeYmyhxFIDJEcP9uUgQWBBiPLo4OMdSxxbkLHM1lmEn0TQ1CPGew3DJdKwrv4
         IJcj5JMxovAUDnpUij++SG9LVL7KDMy5xvg2ETwQW87Ig2tE3cenUJDI4oXKsNCbljWq
         wbnxVMWrHSZ0mHha0xHfuCrlMW/YRvtJ5JcsIcP70r/naJRrS4+ScZLVnjXd70h+2oJ9
         lj+xBvks2ING2VEIdblmracYiYJwqW8H4DxObNnd9pkJUDaHwT3QTmsAOasjCYNo6Xz3
         wOVA==
X-Gm-Message-State: AAQBX9d+Wt5YvXwU/oGGht4ycl6suxO7AgiD20hX0RtRYReGO8d7OOp7
        Pmc1lW1mqmpqz4guUGlI0gEKRA==
X-Google-Smtp-Source: AKy350Zih1/UPPhQr8jYeGyPYonELcT+rZRHLNBwD0ldfATP2SC3xnwB/VAGhSWQTnQNEnfb2Ap/xA==
X-Received: by 2002:adf:ce02:0:b0:2c7:cdf:e548 with SMTP id p2-20020adfce02000000b002c70cdfe548mr27185931wrn.71.1680529764201;
        Mon, 03 Apr 2023 06:49:24 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id z6-20020a5d4d06000000b002e6d4ac31a3sm7433916wrt.72.2023.04.03.06.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 6799D1FFBF;
        Mon,  3 Apr 2023 14:49:21 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marco Liebel <quic_mliebel@quicinc.com>,
        Brian Cain <bcain@quicinc.com>
Subject: [PATCH v2 07/11] Use hexagon toolchain version 16.0.0
Date:   Mon,  3 Apr 2023 14:49:16 +0100
Message-Id: <20230403134920.2132362-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403134920.2132362-1-alex.bennee@linaro.org>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marco Liebel <quic_mliebel@quicinc.com>

Signed-off-by: Marco Liebel <quic_mliebel@quicinc.com>
Reviewed-by: Brian Cain <bcain@quicinc.com>
Message-Id: <20230329142108.1199509-1-quic_mliebel@quicinc.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230330101141.30199-7-alex.bennee@linaro.org>
---
 tests/docker/dockerfiles/debian-hexagon-cross.docker | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/docker/dockerfiles/debian-hexagon-cross.docker b/tests/docker/dockerfiles/debian-hexagon-cross.docker
index 5308ccb8fe..b99d99f943 100644
--- a/tests/docker/dockerfiles/debian-hexagon-cross.docker
+++ b/tests/docker/dockerfiles/debian-hexagon-cross.docker
@@ -27,7 +27,7 @@ RUN apt-get update && \
 
 
 ENV TOOLCHAIN_INSTALL /opt
-ENV TOOLCHAIN_RELEASE 15.0.3
+ENV TOOLCHAIN_RELEASE 16.0.0
 ENV TOOLCHAIN_BASENAME "clang+llvm-${TOOLCHAIN_RELEASE}-cross-hexagon-unknown-linux-musl"
 ENV TOOLCHAIN_URL https://codelinaro.jfrog.io/artifactory/codelinaro-toolchain-for-hexagon/v${TOOLCHAIN_RELEASE}/${TOOLCHAIN_BASENAME}.tar.xz
 
-- 
2.39.2

