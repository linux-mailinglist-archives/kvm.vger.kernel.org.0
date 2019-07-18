Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E66CEFB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbfGRNhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 09:37:16 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:53419 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390436AbfGRNhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 09:37:15 -0400
Received: by mail-wm1-f43.google.com with SMTP id x15so25639032wmj.3;
        Thu, 18 Jul 2019 06:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=999y3b+Bz3jS0Jj/7jnCbhFgQx5WMDE1Lzv6MK0A22U=;
        b=cZdMBgxnb+3HyWKNRXvCr5MgEz0xkLKDuRUUqBmLrPsaAG4xOQB6XH1++Bnh7D8Pe0
         LyuMRC5Ujl0Ixp4b0EHC/AbgQvPaNwlVIni3G2OE2cRQgvS7bq/gyIboyEwZpCeOGh0K
         nAPKyPHNMmuYZj7NNdY02HkO2j4wQL7G7I32vqovpQ8awOKU0uC/9BKFEv++1/DJb7zT
         nty3KVPRuaGPUxZaTG9iIkJHoy/AaclxtOF1TaWYC9dtwvfb8euOpVEmRdtZ01pTlg6K
         yTpcqAIC/05gV5IaZ34slkzJAU4Q8HomJ8EekSsrQRJnf7ykdKr830YWc85sPhDwXQ3T
         rjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=999y3b+Bz3jS0Jj/7jnCbhFgQx5WMDE1Lzv6MK0A22U=;
        b=nvpv9KkIKuKlSCxmutPKYOE/pxp69T/KwNYgpkw2jAqyULA0+TLBK3rylg07jGyQMY
         Cs18+56WtVPd4/Q3NajTLM0AU1knlQXN8BKN5p2TJqGJAJdZ5CF7DSpnqs9+OAdE5jdn
         x3DXyju+iisJawnnkaEFJK0N0ZjYKXgpFOU1X4YFzdgQ02Zuu+ef5YS0zuQF+fe4NVFr
         aVTRXi4wjJyo78tG3LPSYidSXYJPkf/MfO/lcBbbwcJSmV9Ha8FX3XfopJ53fMIglQ4F
         tefezX+3yjNz3ynYNC08H2hNs3kppqC0gXhgBtguZem1XoUVvZY27jwSaRAGcrLVb8j9
         DJFA==
X-Gm-Message-State: APjAAAWjT9Hzq7eQg3Svgjyb+QrK/A1GgbMrDnlzcPq6Srkg+K01B4kt
        JL4HbE0caNCAOejlHZCZc2FZ7MmVh0o=
X-Google-Smtp-Source: APXvYqx3tKk6TAeaApKlVFu7bqdzptJwLPknG1hQJnigV54cuLWNvKsejHEQSqSqfs4e6qZFmYpaOQ==
X-Received: by 2002:a1c:b457:: with SMTP id d84mr45171914wmf.153.1563457033414;
        Thu, 18 Jul 2019 06:37:13 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t185sm20479790wma.11.2019.07.18.06.37.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 06:37:12 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, rkrcmar@redhat.com, borntraeger@de.ibm.com,
        paulus@ozlabs.org, maz@kernel.org
Subject: [PATCH v3 0/2] Boost vCPUs that are ready to deliver interrupts
Date:   Thu, 18 Jul 2019 15:37:09 +0200
Message-Id: <1563457031-21189-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My take on Wanpeng's patches with some extra cleanups.

Wanpeng Li (2):
  KVM: Boost vCPUs that are delivering interrupts
  KVM: s390: Use kvm_vcpu_wake_up in kvm_s390_vcpu_wakeup

 arch/s390/kvm/interrupt.c | 23 +++--------------------
 include/linux/kvm_host.h  |  1 +
 virt/kvm/kvm_main.c       |  9 +++++++--
 3 files changed, 11 insertions(+), 22 deletions(-)

-- 
1.8.3.1

