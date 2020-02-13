Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28CB15CD44
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387410AbgBMVaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 16:30:39 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51271 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgBMVaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 16:30:39 -0500
Received: by mail-pj1-f68.google.com with SMTP id fa20so2937206pjb.1
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 13:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjVzNJBK83ikW0TIlSzbtH1BgwGaguqWKS1Uh0bPMR8=;
        b=dTiM0Mz/slq1uUJKEcofNHhqiUiy7xB79p/2HWlp3laiLYDRlanVmv3B8fHGkWuNmG
         yzNk+Kf2OaG7UYgZ9A7v4voYtOSO6A7JeYhJo4K0oLnKldbLXjrdldMSlwwdfd9hwmAj
         u3qY3vh6IN6M7aP/dB6pXf6BpjJZw5VLmyqlMxeSS1SU9MFZW7BjJRRCw2X6oT0i0VVT
         luAobTHEoP9utgoebAvgXbND66i1qqR0Qpm/fnGAxfLog89sj3CDq4TVNufkTkJcBehj
         JbRpscT+pLn99ueAjpSGZ+SeX4RvFIrleYVCnr4h6WxpM8JnKtlu1zNzIjIK2zFNVQVo
         2eXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjVzNJBK83ikW0TIlSzbtH1BgwGaguqWKS1Uh0bPMR8=;
        b=QVYanljZhg3XCklsRyFji2gtGs5wczw6zaezINnv7jnVFjAQq9glkF9NjNw1WZUgCC
         eJg3FaIn8RCPUlhkFXS6yyzQiQcLSnt4gOG9IchD+dRngA7nsktLDPgLi0XU6QUEMYX9
         Hs7Rd5OmA9dhzC2DdVgDUbx+rCngTZAsjcYY+WEJcsAaOgpyJgvAgTKmQuFFV01c3u/Y
         jb7AD1L6N/xLIh9F+tgK+6RxWGon7V+pscbZ29lNsYqhemU/RdNfIbgTw/+mDwdK+qcv
         9NpdVWUSN0oaBGcyjP6QQVekId0d3w0QsTvnDvjPCjVsTb0F0ZHH0oNMX4Q6BxsPWzeL
         YZKg==
X-Gm-Message-State: APjAAAUENkGXo9tasRO5iarKm0xwZIkeZ59z1+z8dqi9cX8W3bP0YgWQ
        X80V83N5Xun+0j4V2Zm1EaeC5HLd
X-Google-Smtp-Source: APXvYqzp6i4zNTju3fPQFtSvmNIUZa6xjTh/ZBrude8YNxGPXiOUyGFvHEPV8DEPau1cdMHscsnW5g==
X-Received: by 2002:a17:90a:20c4:: with SMTP id f62mr7709341pjg.70.1581629438674;
        Thu, 13 Feb 2020 13:30:38 -0800 (PST)
Received: from olv0.mtv.corp.google.com ([2620:15c:202:201:9649:82d6:f889:b307])
        by smtp.gmail.com with ESMTPSA id s130sm4346683pfc.62.2020.02.13.13.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 13:30:38 -0800 (PST)
From:   Chia-I Wu <olvaffe@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, gurchetansingh@chromium.org,
        kraxel@redhat.com, dri-devel@lists.freedesktop.org
Subject: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Date:   Thu, 13 Feb 2020 13:30:33 -0800
Message-Id: <20200213213036.207625-1-olvaffe@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Host GPU drivers like to give userspace WC mapping.  When the userspace makes
the mapping available to a guest, it also tells the guest to create a WC
mapping.  However, even when the guest kernel picks the correct memory type,
it gets ignored because of VMX_EPT_IPAT_BIT on Intel.

This series adds a new flag to KVM_SET_USER_MEMORY_REGION, which tells the
host kernel to honor the guest memory type for the memslot.  An alternative
fix is for KVM to unconditionally honor the guest memory type (unless it is
MMIO, to avoid MCEs on Intel).  I believe the alternative fix is how things
are on ARM, and probably also how things are on AMD.

I am new to KVM and HW virtualization technologies.  This series is meant as
an RFC.
