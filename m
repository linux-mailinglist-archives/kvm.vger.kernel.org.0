Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6641ABC3A
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 11:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441438AbgDPIj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 04:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502679AbgDPIjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 04:39:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FA8C061A0C;
        Thu, 16 Apr 2020 01:39:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i10so3772092wrv.10;
        Thu, 16 Apr 2020 01:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xegz48JzyIZNPeJysw6oCGlOeYewFYMA4DWiAxaVcX4=;
        b=cnL1v6V0mAiUrW3HpV/SNZErA9/hfXwlD6+LKjoWASSYdeTwTi/CGEpGw8e2apDmlO
         oEDJUPBw2+uM2K/99VhpJc79CfeQMHrtOmGlYRiWXRPVfBwvqNlClQs+Q+wbnnu8qAXu
         rzMC8RFe+twveUeDz8NmhVh+wYhQAxEkqEpXPXNtdGsei+jze9RsCXNc9WFUCgKphDsq
         PJj2QbuXNtIhNt/KON/nyJCdxHUmUaDwEn3Vf9eUoh4cjDbqgBqbm6TPCmtwHkXWna86
         9PcqOyjXAxsd4YlCSklklOoDIQXRNf7fw67OX+h8BDVqchZUERYp7zr7GfysoDrbNZdh
         uGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xegz48JzyIZNPeJysw6oCGlOeYewFYMA4DWiAxaVcX4=;
        b=aRhGSliBGcPp0/DjfuMMDJxBZxoV6Kw+lH2+ztq++o6z9e1nKUohfW0HuG9bMWL36z
         vg2Qk0sx55ESftFni6lS3fXKU6fOSAKYhf8IrYDQevnGk01v+WRdJUvkODQXXROXvZYP
         tULucNQ7W77XcNWN6oiBg1NX/5VCUuo48HH/EqHuDpCLl689JhdLVvoTPIY+kL5Ch3aH
         2fZMRccggGtKXX+lGB8oCOLoInuPSpf6UkrgxpjabcuhImSldkQ6WjVvzCxVqGE505m+
         Lq2fiBapLjsCAddR3lS8/HlUzN3M/bqkB1qRbakguv+5UKlYsuNZHYDupyZ5LbRDW6qp
         7eLQ==
X-Gm-Message-State: AGi0PuZXS2lqFmKWkFcY7nv/mrIUQBYSPd4nmskZvHSnwNBdId84uiio
        RN4yhGCzY61LBKM1uXgW/NGs2Xz/nt63Jg==
X-Google-Smtp-Source: APiQypLNCMBfbdp2NLlh1g2+MzQBltmBi7dDmCaJL/0QYAlJCtVNonYnhR5WDlSvOO7xFCPNcdWqbA==
X-Received: by 2002:adf:8563:: with SMTP id 90mr15614387wrh.202.1587026341881;
        Thu, 16 Apr 2020 01:39:01 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-55.inter.net.il. [84.229.155.55])
        by smtp.gmail.com with ESMTPSA id s12sm1256358wmc.7.2020.04.16.01.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:39:01 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Date:   Thu, 16 Apr 2020 11:38:46 +0300
Message-Id: <20200416083847.1776387-1-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the TLFS:
"A write to the end of message (EOM) register by the guest causes the
hypervisor to scan the internal message buffer queue(s) associated with
the virtual processor.

If a message buffer queue contains a queued message buffer, the hypervisor
attempts to deliver the message.

Message delivery succeeds if the SIM page is enabled and the message slot
corresponding to the SINTx is empty (that is, the message type in the
header is set to HvMessageTypeNone).
If a message is successfully delivered, its corresponding internal message
buffer is dequeued and marked free.
If the corresponding SINTx is not masked, an edge-triggered interrupt is
delivered (that is, the corresponding bit in the IRR is set).

This register can be used by guests to poll for messages. It can also be
used as a way to drain the message queue for a SINTx that has
been disabled (that is, masked)."

So basically this means that we need to exit on EOM so the hypervisor
will have a chance to send all the pending messages regardless of the
SCONTROL mechnaisim.

v2:
Minor fixes from code review

Jon Doron (1):
  x86/kvm/hyper-v: Add support to SYNIC exit on EOM

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/hyperv.c           | 67 +++++++++++++++++++++++++++++----
 arch/x86/kvm/hyperv.h           |  1 +
 arch/x86/kvm/x86.c              |  5 +++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 67 insertions(+), 8 deletions(-)

-- 
2.24.1

