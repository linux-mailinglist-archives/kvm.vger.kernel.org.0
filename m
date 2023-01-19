Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E97674540
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjASVxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjASVxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:53:07 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FB6B1EDA
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:34:30 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id t12-20020a170902b20c00b00192e3d10c5bso2027991plr.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Voz2cPbyTGcLhdRPa/ltDW1JwajbV9yh0vKVRBbRKuk=;
        b=EpJxslMiPB369mzUjjkYlm6uPL2QZKBT7oLzN1SQCEJGb4OXXMQ43ol3BP9+XPdEML
         mKddYwLg2y/WgeVcvjE7lSb4L8IwQq48ztab2GpzAUIxLhCraMPm4flX/rvLREjQ1BJ/
         woPfmP8Q23JtzXFIS7OaFL9JT1D2WaGEXJL3USd5zlyxb0dpYJ+W1U25rhavicsawLcR
         XJA2m/JvJ0TkuWoccvxVy46kO3QcVjeALowtEpv+iJzDWc0cBGponBViOUHM0/hSyi7x
         qRuaQX1FtSizviOM28/qGR/R2MLtvi6ppiyasaYh/ZRh1uoBjiHnPkvrwWHMOKVs/hj/
         tSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Voz2cPbyTGcLhdRPa/ltDW1JwajbV9yh0vKVRBbRKuk=;
        b=ZSSCbrbvmtSl7knhkqYEFzfshKpHLa8YoRtGQF04TafVxsANR9q2IVe6oe/EyH5OgN
         WtbSFjd0SyTMCSG0qXfXpvzFKeF+OCF0JhbBz33Z/odK9V4hv6RbFrynUyxyVDPSUGpL
         BuIpgdcjceRWn5g+agWKLwvAGbUpS4vJCWcBrdNl6hBnNVOEP/Bb86Eqs0yX7EplpcY/
         l8jmlb6mkC2ySwt/onV4dCpQ0pvZ3iZ/1Rwd11qVPwF6P5ajX7DNwIeYqLr1zCHU4f3a
         tGZ+LYur4De3cFh/u5LoVQSLMRqcVitZZ5apBhhjJ2oeC/dXCx3SKAvV8pjJgNXCbXqT
         5S3Q==
X-Gm-Message-State: AFqh2kpK1gfHgfxVij+oMscjsQnByu6ggvleL3Es4as+u88gu+vzvz3m
        udXue4jAFvrdca8LZnp5gMi8oHEOu/sTUG3uvdo4xaNDU2+K7NpBvjlHoCjyjoN+gM3D6Pabcon
        adFHkKLWw5JqogDsfYRnNqdqDqj6xgVg1mCf8/PFZUmYMf1f0/jpb+R73s+Tcrr+8ALFoSnQ=
X-Google-Smtp-Source: AMrXdXsudqdC6kbrhygpqA4CaWcuUKcCGFCHdFeIRQ6SZ2R4tjo+8mTEWD2IyZTjmldQoTwpG41fDqfzm9ziS6v37w==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a17:902:b111:b0:189:a50d:2a23 with
 SMTP id q17-20020a170902b11100b00189a50d2a23mr1212871plr.32.1674164069271;
 Thu, 19 Jan 2023 13:34:29 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:34:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119213426.379312-1-dionnaglaze@google.com>
Subject: [PATCH v3 0/2] kvm: sev: Add SNP guest request throttling
From:   Dionna Glaze <dionnaglaze@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is based on

[RFC,v7,00/64] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support

The GHCB specification recommends that SNP guest requests should be
rate limited. This 2 patch series adds such rate limiting with a 2
burst, 2 second interval per VM as the default values for two new
kvm-amd module parameters:
guest_request_throttle_s
guest_request_throttle_burst

This patch series cooperates with the guest series,

Add throttling detection to sev-guest

in order for guests to retry when throttled, rather than disable the
VMPCK and fail to complete their request.

Changes since v2:
  * Rebased on v7, changed "we" wording to passive voice.
Changes since v1:
  * Added missing Ccs to patches.

Dionna Glaze (2):
  kvm: sev: Add SEV-SNP guest request throttling
  kvm: sev: If ccp is busy, report throttled to guest

 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/kvm/svm/sev.c            | 47 +++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h            |  3 ++
 include/uapi/linux/in.h           |  1 +
 4 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.39.0.246.g2a6d74b583-goog

