Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153CD7A5198
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjIRSHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 14:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjIRSHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 14:07:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3541103
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 11:06:56 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bf7a6509deso34713985ad.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 11:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695060416; x=1695665216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FCpDJhkkPZXZzEKCkdvjugeVs9PL39Lrqr1o9f4MEek=;
        b=V6c+qLIj4CeTwuFa7HO3owk+o5WNKQ0S12szjj/z/FR5Lrmsm6OJ+fEpdY1KXxKX0K
         k0GuI6BWfaKDC5hstYn0K9i0OXimZHh59kPQeaaQ8k5RemA8770tAFyWHN1eRWEHYsDr
         ubA2VAj0KBlizJXuE86WzwtxBGkkAc9/zDDApHVQFPTPmcABcBIk5olrwjzKRJIRn9Q5
         C2MjiG4lNx5L+slMpOI/XxvfODL9ilhAqMCgvxeKPUQ11cTxYPzX5T+iiLttyOPJlW7Z
         QtfpFKFy7g0g+y0V2xXEWgM2ZJt262TbYwXwXONc975kmv97hWKouB3Od6FMgdnTgG3p
         b+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695060416; x=1695665216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCpDJhkkPZXZzEKCkdvjugeVs9PL39Lrqr1o9f4MEek=;
        b=ZhsYq2ulnjSWNsEPC+xXSY7LQgOrdQEPEw3HRkdhyRpg4OhZBhBPE62aoTbu9pReGD
         GLfj3GSl+NLDQxm4GSvlXt2WyFu1Wy58ZbEZCkSycADvshV2vOYOll2DwanmU4MCYOx7
         Cq1CLV+E5x5p/qqjpmIj+CkLbb67iy1jo8jf0w22azn2y8fRfBJpV+HjDL4GhgYBvlyp
         lgKAEEQ1Fc0m2Am3K1WkGum3fH/2MwMArLldmJLDW9LH5lNbmpNNGFZoTEX4kiNV689s
         4s7sNixD44t4z3jeD659apBWXFAfseuSVrRdYNnFzl6qd2K2YtbfR+xpKnk2gDL6npdv
         tzNQ==
X-Gm-Message-State: AOJu0YxT+wc1inDa1xdf00Ouc5nbWNije8Y/W/A0Esmrqd9SJ21SD/L4
        a5I0UEtQ0RCyEqbYzBqStji43A==
X-Google-Smtp-Source: AGHT+IFZaa75xea6Y0dv1G3itQYg2C5MEWq+6lS/hOtngOACcYMLEDGNJM4QBXNYaWpu4NJMe3mq/Q==
X-Received: by 2002:a17:903:120e:b0:1c1:fe97:bf34 with SMTP id l14-20020a170903120e00b001c1fe97bf34mr10291276plh.24.1695060415995;
        Mon, 18 Sep 2023 11:06:55 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902704700b001aaf2e8b1eesm8556720plt.248.2023.09.18.11.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 11:06:55 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/4] KVM RISC-V fixes for ONE_REG interface
Date:   Mon, 18 Sep 2023 23:36:42 +0530
Message-Id: <20230918180646.1398384-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series includes few assorted fixes for KVM RISC-V ONE_REG interface
and KVM_GET_REG_LIST API.

These patches can also be found in riscv_kvm_onereg_fixes_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (4):
  RISC-V: KVM: Fix KVM_GET_REG_LIST API for ISA_EXT registers
  RISC-V: KVM: Fix riscv_vcpu_get_isa_ext_single() for missing
    extensions
  KVM: riscv: selftests: Fix ISA_EXT register handling in get-reg-list
  KVM: riscv: selftests: Selectively filter-out AIA registers

 arch/riscv/kvm/vcpu_onereg.c                  |  7 ++-
 .../selftests/kvm/riscv/get-reg-list.c        | 58 ++++++++++++++-----
 2 files changed, 47 insertions(+), 18 deletions(-)

-- 
2.34.1

