Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0053F36AB5F
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 06:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhDZELx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 00:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZELw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 00:11:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E87C061574
        for <kvm@vger.kernel.org>; Sun, 25 Apr 2021 21:11:09 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q10so39212638pgj.2
        for <kvm@vger.kernel.org>; Sun, 25 Apr 2021 21:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTb6aVZF5rYyZGAFpZJcdBVEH5JTp6V0QEKxiSNXmh4=;
        b=iWuKDR88umBSdmZzb3myz6GDget2+JF1wwrXG1nQ3zRojc7buHG3wSvC83xAHsqrgM
         dZyQhqs845Jgoq+Nm/B8THJ6jrBZL7ydW1umQdCmiOlv/fVxd++o/5TR1iGEgaYqy+96
         jr2vJtqsxpxJ4L7mc0Ohh6UnGtu3nxBqUsOCg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTb6aVZF5rYyZGAFpZJcdBVEH5JTp6V0QEKxiSNXmh4=;
        b=aN9LfrAJe7t2MNf4gASS1oICfmT0jqSIikFrCvM4M7mtXOuyYEg7gTURFVLRkIgNKq
         2gEfUqCtBQ+/N3A5+T1Lk+uH2OZ1BGLdX43yo6/6oGARVjnq9dOzSU7xx7Z8svLAvOpQ
         G7mukaMxK0FVCaD1pd4VhRk29b63f2F62lAujx3vhlZg2trtjBv2FzrvCSYPIZL6bDwh
         cDIxYql6UC7bcezOXQK0WskaLvNqxgE/GNqAfZ3znUgow1t0CEoWh4aAspMeSmyXQ6PK
         wii9O2jRehraU0Ffkup3A1khxDiO498KnDD8CjTRAzhz3gAUks1SPxTSFdveNbewf224
         Hg9w==
X-Gm-Message-State: AOAM531WlnLTdVG7ftBiQwghozFjLYKLSAwHp+TG2Cs4txsfaavUq2DO
        yplysZlqRMDxhDSVubpmRTRmbA==
X-Google-Smtp-Source: ABdhPJw6wXi3/36bZ4WsuZyFsKo80Kc7II7tEP1lQ7YG7zJE5bloDPI0w/AMtTeQfMxhcEFx5av2GA==
X-Received: by 2002:a62:b403:0:b029:20c:cbd5:5be1 with SMTP id h3-20020a62b4030000b029020ccbd55be1mr15975172pfn.53.1619410269345;
        Sun, 25 Apr 2021 21:11:09 -0700 (PDT)
Received: from haraichi.dnlocal (113x36x239x145.ap113.ftth.ucom.ne.jp. [113.36.239.145])
        by smtp.googlemail.com with ESMTPSA id y3sm10523112pjr.40.2021.04.25.21.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 21:11:09 -0700 (PDT)
From:   Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
To:     kernellwp@gmail.com
Cc:     david@redhat.com, jmattson@google.com, joro@8bytes.org,
        kentaishiguro@sslab.ics.keio.ac.jp, kono@sslab.ics.keio.ac.jp,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pl@sslab.ics.keio.ac.jp, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in VM-Agnostic KVM
Date:   Mon, 26 Apr 2021 13:10:50 +0900
Message-Id: <20210426041050.3310-1-kentaishiguro@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANRm+Cz9GgQFDbbW_3bRO35FwvMGJ-ZFa0rSvEimxFzrvwmpJw@mail.gmail.com>
References: <CANRm+Cz9GgQFDbbW_3bRO35FwvMGJ-ZFa0rSvEimxFzrvwmpJw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I see. Thank you!

