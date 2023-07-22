Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D25675DAE4
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 09:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjGVHxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 03:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjGVHxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 03:53:16 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4132708
        for <kvm@vger.kernel.org>; Sat, 22 Jul 2023 00:53:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bb775625e2so4900275ad.1
        for <kvm@vger.kernel.org>; Sat, 22 Jul 2023 00:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690012394; x=1690617194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bN+VKWG1+IOztgVSANu62XflYn5gYOmAgQC0VPwsiCw=;
        b=jQon0Yf7szj552v/VCJW+ipTm6W/fJ6WLkXV8j6S/O5zS6i6eBpUB1zltCWR3QiNfB
         3DrbDOokD6olH0pQTQRiXfI2jXguQGmNIozBjB4OdQqQUyLANxYCFNp/KJXzYhUVRwGe
         7nddYdqd0KTVHc6IN/VboBxvHON3PJW8Cti8wkAgHELYJrYaf8izW6o6IpGP+YGWQRmD
         OBctte/l2ulLpFKFFfoSJi0hRhfm/F0oxcgJUy5ibrz9j3D2rFkyuSGTNG+nsmK9zf8u
         gOt0jl94wFNZoatpSFDff3gvwAO+PHyyOqeocpyHadlfr7Vpk23eqeOe4bEMWvvUwcqt
         a6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690012394; x=1690617194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bN+VKWG1+IOztgVSANu62XflYn5gYOmAgQC0VPwsiCw=;
        b=lJ7PzOBGO+yCqe5aRmegsdNqsGArwlqY0NIBd0AluqiFlBMGQe/XNrVUUW19MyefVC
         vHyQACpCAeTHNCKC5wbw5x1Ii241bIuwwdzBSV6Oi3FzdaaHki34JqQhhYLqQDuRsmUY
         cmx/KihmnH1VsnTqOXhemfe9+I6pnpJxdAlWcq0Nz05heKLlZyC9WCg4bqsOjX7bCXA2
         6cMcNIYEQt0s4CuSzD5G60yCBnimQE82+Qv6AFLBNKBAkjfBp6zNr8Co8jUUerIkSnKl
         P3qaLz1jpyK4mIWuZq3ImPa6Cc62t9XB2myn4cQmEs2UCFhcA+TI9kfZxZtGQl+igliE
         H85Q==
X-Gm-Message-State: ABy/qLbzvhxGbNMBkHQVFfQonBH7cBb75yyC661bhFSO7MFnx/xgyyoc
        UkW9eBG248y4vaHDehvK2F1xVvs2hkQdkf1FVwo=
X-Google-Smtp-Source: APBJJlGa5lYO3zvqjWaxdvLxHQCwPfMohLqfWOXm43zeaW4njVX59Op2uErrSdHR/A53vZa2JwjCcA==
X-Received: by 2002:a17:902:f7d1:b0:1b8:76d1:f1e8 with SMTP id h17-20020a170902f7d100b001b876d1f1e8mr4644921plw.28.1690012393834;
        Sat, 22 Jul 2023 00:53:13 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id i17-20020a17090332d100b001b86dd825e7sm4753119plr.108.2023.07.22.00.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jul 2023 00:53:13 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v4 0/2] accel/kvm: Specify default IPA size for arm64
Date:   Sat, 22 Jul 2023 16:53:04 +0900
Message-ID: <20230722075308.26560-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some Arm systems such as Apple Silicon Macs have IPA size smaller than the
default used by KVM. Introduce our own default IPA size that fits on such a
system.

V3 -> V4: Removed an inclusion of kvm_mips.h that is no longer needed.
V2 -> V3: Changed to use the maximum IPA size as the default.
V1 -> V2: Introduced an arch hook

Akihiko Odaki (2):
  kvm: Introduce kvm_arch_get_default_type hook
  accel/kvm: Specify default IPA size for arm64

 include/sysemu/kvm.h     | 2 ++
 target/mips/kvm_mips.h   | 9 ---------
 accel/kvm/kvm-all.c      | 4 +++-
 hw/mips/loongson3_virt.c | 2 --
 target/arm/kvm.c         | 7 +++++++
 target/i386/kvm/kvm.c    | 5 +++++
 target/mips/kvm.c        | 2 +-
 target/ppc/kvm.c         | 5 +++++
 target/riscv/kvm.c       | 5 +++++
 target/s390x/kvm/kvm.c   | 5 +++++
 10 files changed, 33 insertions(+), 13 deletions(-)

-- 
2.41.0

