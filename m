Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17283754DF
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhEFNjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234303AbhEFNjC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vbCDEC95SLEC7NvBUhks/P3w4WBw9RAigT+kNtWZnU0=;
        b=Jv1tbvCGglKUBFYqfewu2XJXU/j5zoKWTR9dUqvk7dSvd3AT208rBOAGrskOel9Kvp962D
        bGVIuA/SsQAsEwB2GswgXMNrM8MeY+il5NJOSEPXJI6K+6p3QIU1FWxLUQ9XPYe1gYygnt
        ZWUEpgDoZ51YZLSA34UCTVC9QXiJ5aA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447--QSe6JI3OuWDG87omWAQyw-1; Thu, 06 May 2021 09:38:01 -0400
X-MC-Unique: -QSe6JI3OuWDG87omWAQyw-1
Received: by mail-wm1-f69.google.com with SMTP id j128-20020a1c55860000b02901384b712094so2681163wmb.2
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vbCDEC95SLEC7NvBUhks/P3w4WBw9RAigT+kNtWZnU0=;
        b=CE6QyV+U7qJnvfPq6S0MtuTgAwd+4zmHPsq7AjAHvUw/OecFRDIXvTnUbQkaurPM5Z
         9wZHncBJGxcwt7s3DYeS+kyDmrLmSJaxxNpTxlMvlAWkvBSuZa8nDCZlz3LzuVpdT3OM
         TdUy/qSkz4K8DrrVVkLRHntZdUGLUrngzjl55PJo3HoFjDsB6tRVbGdHksIs7jO7eNKt
         kDzOX6tNSc5aSqwF67DKKd/Oc+ZsykVX6Zm3MVs9ts38yBqYMocBolwoF6VSmbUUv1nr
         /XeWlDa6efwzmm7CmKHJlTw4IMpCW8tjeZZ0YW1XShW7UJD27AzrO9DrX3iYp4byX6Yi
         WalQ==
X-Gm-Message-State: AOAM533wGBmmgRyetQ8ndsvHjLwWYkNUCTdO3FGLaWO4/IjZ3hWz+bjB
        Ga0b12ysE+CvNXc/Jz74N7j2/G0s1Gq9hSMmoTVjpgS+2AnB+DpG4RYmvruKRP0Q0Og876R0mNa
        5NTcv1m42H0j9
X-Received: by 2002:a5d:4412:: with SMTP id z18mr5160046wrq.103.1620308280249;
        Thu, 06 May 2021 06:38:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/lpKgeXPwedLJvJ4wj/Fl9lQspP9LDG16WhazAs5p4oUW5BEc7XMk6TLu2WdAwkGSukQsXA==
X-Received: by 2002:a5d:4412:: with SMTP id z18mr5160036wrq.103.1620308280136;
        Thu, 06 May 2021 06:38:00 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id e8sm4414680wrt.30.2021.05.06.06.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:37:59 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 0/9] misc: Replace alloca() by g_malloc()
Date:   Thu,  6 May 2021 15:37:49 +0200
Message-Id: <20210506133758.1749233-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".=0D
Replace few calls by equivalent GLib malloc().=0D
=0D
Last call site is linux-user/.=0D
=0D
Since v1:=0D
- Converted more uses (alsaaudio, tpm, pca9552)=0D
- Reworked gdbstub (Alex)=0D
- Simplified PPC/KVM (Greg)=0D
=0D
Philippe Mathieu-Daud=C3=A9 (9):=0D
  audio/alsaaudio: Replace ALSA alloca() by malloc() equivalent=0D
  backends/tpm: Replace qemu_mutex_lock calls with QEMU_LOCK_GUARD=0D
  backends/tpm: Replace g_alloca() by g_malloc()=0D
  bsd-user/syscall: Replace alloca() by g_new()=0D
  gdbstub: Constify GdbCmdParseEntry=0D
  gdbstub: Only call cmd_parse_params() with non-NULL command schema=0D
  gdbstub: Replace alloca() + memset(0) by g_new0()=0D
  hw/misc/pca9552: Replace g_newa() by g_new()=0D
  target/ppc/kvm: Replace alloca() by g_malloc()=0D
=0D
 audio/alsaaudio.c           | 11 +++++++----=0D
 backends/tpm/tpm_emulator.c | 35 +++++++++++++++--------------------=0D
 bsd-user/syscall.c          |  3 +--=0D
 gdbstub.c                   | 34 +++++++++++++++-------------------=0D
 hw/misc/pca9552.c           |  2 +-=0D
 target/ppc/kvm.c            |  3 +--=0D
 6 files changed, 40 insertions(+), 48 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

