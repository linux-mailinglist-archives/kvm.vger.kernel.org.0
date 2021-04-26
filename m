Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC4636AB08
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 05:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhDZDUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 23:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZDUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 23:20:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A340C061760
        for <kvm@vger.kernel.org>; Sun, 25 Apr 2021 20:19:13 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y62so5374936pfg.4
        for <kvm@vger.kernel.org>; Sun, 25 Apr 2021 20:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1idmU5oasi5s8yake1E5MV/fuZG36GG+m+QfyCDPPAg=;
        b=FFBBiEbKdwEOvS0oHpkmceh8YwkI8JWzk9aEm6Q2tDb7iK0USLW0QEKvQG1ZV1P/N7
         1ynXAijGp5Rvm//DBC+C5zYnIQmGDnQQMASRr8Tnlv271bcyXtY12nHSD+2I2PAl6+Ga
         OkXJOSqpveQOemOW3Ls3p2DmZP5lUBE4R/ncQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1idmU5oasi5s8yake1E5MV/fuZG36GG+m+QfyCDPPAg=;
        b=WWKTAFyEUiq6397LEgU3ZSGzOA9hoUjYyFhuK2MUDSIaVABwMq/Ia09aXsRBgwhxgR
         Xvk93VZgoRHwwX72gM4lONi67SudcCZtSCs+CvIKa2Po8kuxoWMPcI0QOgA58MqI26kS
         4/lUACmjdVHl+YIGVm8/9uSjKNXtELVoUy3+gr+XgsIIBynoyn7pcP5MfasX+mb8+6NZ
         30CaI1qqFNmnLmFWva5GjEgGXYJ0VF81xzYIqZHu2AAjuKGrvjj/HLuZHV2waYN+DtgA
         1HY8/yh/aRAaZjuc0AhC/n9Hj6eHHAkMdSg6Wu8CrKPGVzLOuILAcQwbt5MDhpFuTBXm
         HN+A==
X-Gm-Message-State: AOAM533rf6ymfngxYmtRidb9nMOVO7ZMtEI+es4VpQXzug9BaG3kq0D3
        Lfdua7rXnh8mSvhoy0tlswnqSHFsbgwQlwXQyrc=
X-Google-Smtp-Source: ABdhPJw2NvtElpce5Tsiply0Pczv0FCmrOEKJ1UaVHlZ+QzzAJJ0woA/MGNFNFMfXQxSQ5/2tsFmNg==
X-Received: by 2002:a65:56cc:: with SMTP id w12mr14980759pgs.334.1619407153036;
        Sun, 25 Apr 2021 20:19:13 -0700 (PDT)
Received: from haraichi.dnlocal (113x36x239x145.ap113.ftth.ucom.ne.jp. [113.36.239.145])
        by smtp.googlemail.com with ESMTPSA id s32sm96035pfw.2.2021.04.25.20.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 20:19:12 -0700 (PDT)
From:   Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
To:     kernellwp@gmail.com
Cc:     david@redhat.com, jmattson@google.com, joro@8bytes.org,
        kentaishiguro@sslab.ics.keio.ac.jp, kono@sslab.ics.keio.ac.jp,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pl@sslab.ics.keio.ac.jp, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in VM-Agnostic KVM
Date:   Mon, 26 Apr 2021 12:18:58 +0900
Message-Id: <20210426031858.12003-1-kentaishiguro@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANRm+CzoS=HhiHg6w6dy8P+r3POeP3uMZqFvJr4oHMa1aNJqxg@mail.gmail.com>
References: <CANRm+CzoS=HhiHg6w6dy8P+r3POeP3uMZqFvJr4oHMa1aNJqxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you for the reply.

My question is about following scenario:
1. running vCPU receives IPI and the vCPU's ipi_received gets true
2. the vCPU responds to the IPI
3. the vCPU exits
4. the vCPU is preempted by KVM
5. the vCPU is boosted, but it has already responded to the IPI
6. the vCPU enters and the vCPU's ipi_received is cleaned

In this case, I think the check of vcpu->preempted does not limit the candidate vCPUs.

