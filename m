Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9000C740FFF
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjF1LZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjF1LYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:24:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210F6294F
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:24:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3110ab7110aso6451916f8f.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687951485; x=1690543485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qAOjRSpF0XO5rPRK8VZzU5PPs2Rk/Mt51L1HXxQaEdw=;
        b=ut1rK83WaJK2whCXMzlQsE3ZlPnIyBXjn8ps/W09G3vRe1D1D4/vjBdj/knRS/e8QE
         ICdtsv7CaClTMEfSLceCRMLWuwt2Cv0NuZu/+KTyNDY5fjJ75OQNmN3ZnpaEQlDGifIT
         ST0fKwrb5F6kOiGCmb3Gu/4YKG+VYHqECPYBn/5IckHQIamqswFArubVUgmPDSMOxIlq
         xP4/y/YzsN72MAuugOMjm7SZOa2Tdl8AGEUuB7cqt9zjA6lXH7rmQdKNd9KgT5mpM7vZ
         9clKsG9rMTnyV8+CDS/Ez7nSSnh6gFuOIlADDieucEW8dTK4BXo2Mpt6AKLxNUny3Az/
         sLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687951485; x=1690543485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qAOjRSpF0XO5rPRK8VZzU5PPs2Rk/Mt51L1HXxQaEdw=;
        b=W3GyEYlAX2flsYxhftZcq1vC2w/jQ1sYKd6vsbElN3REc/zMY5Ioyw0DZtO83J5pkW
         1TPFK/1ZAO39VPIMDHC9lqUQer6twQSRP0ydsyKn136XRLY11Bx0QBTJPq4rQNqIuP2U
         7TbgJ+vBe/IZr6ycIOl4vwJJviQGaQNIye31zQ/9lynRImunHO5NCTCafEpeXWGav8n1
         MTPl4/J0LhbSCIqU4kZhVa/cKDsDaNv+iGuLEu0o6f3f/tfCCBF+GLIBkV89FSnJZz8B
         NFc84qdkrKaWv+2Q/R8GP/h33qJjJwvsKhG25XrY3GfovIYy1U8RjvsJpIGOzPQWZd8y
         v/ag==
X-Gm-Message-State: AC+VfDyerpruAVctOmglRYdZMfFfmUgcF5rWv3uBjrSLgY8imsV/tbtC
        3YtritCPJIl2iNR/NaKyzfymoLtld0Y1T0aCh1Q=
X-Google-Smtp-Source: ACHHUZ5RPwF+SOsWWeSVaXLrMOzfqtBgk6DCPFy+msaNMhqWIZb6DF3zUK1bYfjFz2wwJZuC61FC7w==
X-Received: by 2002:a5d:4392:0:b0:313:fe1b:f447 with SMTP id i18-20020a5d4392000000b00313fe1bf447mr3320230wrq.71.1687951485564;
        Wed, 28 Jun 2023 04:24:45 -0700 (PDT)
Received: from localhost.localdomain ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6dc1000000b00304adbeeabbsm13065173wrz.99.2023.06.28.04.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 04:24:45 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     vivek.gautam@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 0/2] vfio/pci: Fix unmaskable MSI
Date:   Wed, 28 Jun 2023 12:23:30 +0100
Message-ID: <20230628112331.453904-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
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

Patch 1 fixes an issue reported by Vivek, when assigning a device that
supports classic MSI without maskable vectors.

Patch 2 adds some comments and renames the states, because the MSI code
is difficult to understand. I haven't found a way to simplify it but
this should at least help people debug it.

Jean-Philippe Brucker (2):
  vfio/pci: Initialize MSI vectors unmasked
  vfio/pci: Clarify the MSI states

 include/kvm/vfio.h |  8 ++---
 vfio/pci.c         | 86 ++++++++++++++++++++++++++++------------------
 2 files changed, 57 insertions(+), 37 deletions(-)

-- 
2.41.0

