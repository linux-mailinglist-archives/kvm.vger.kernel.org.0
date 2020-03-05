Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E381F17A2F1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgCEKNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:13:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50395 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCEKNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:13:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so5559396wmb.0;
        Thu, 05 Mar 2020 02:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=cxk+MXcOeQV1WCXNQhxSl7i6QKVRGSx/9Z04A+Iz51g=;
        b=USeffCvGW2kT/2nvw5Nshh15XS/mOrJtx1GAM/JerLUzySuvvCWxin5vWI23TGKR/m
         tQFAFp1FGa71JP8HW4kq08UYGOqN4Dx2VlFi/QkN3/wMqIbGeFHvdJvmkpF3pm/6QP8n
         Z/7NoxN40809fdsX7ZklFuQSj6xO8cMDpdngGTFdC34m6w2IRaxzzBYkY/tI9Uu0Wlhk
         Pp4t+kSSO4TncVqzAVTZorMiglcTIIdDk5fkJZzu5CdK72Rw1NAjMcHJoGEoZOgaLNUl
         ByHiM8ysMfiPyPBPBa5RHYJ2b4kInsKpr9dnQnLDzsTSDyL/qkOiutYD4QxaltWVZnS2
         TFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=cxk+MXcOeQV1WCXNQhxSl7i6QKVRGSx/9Z04A+Iz51g=;
        b=e6ib+0NOjXix6dycrhxjXeIdWD9GlUtBDHEDkwvrxBUEo6uT0NoqvKlMtUwDv6WBE4
         ZWfn0IzJVNV8fcw9RA3hXUf30bTFFJPR5/jAxoFyktCxuEqo28nOz5FeB+7DVbvSqubA
         f9LHjQXtL/NaydH4CbJrQUPJnYl0XbaEEvzD8ZU9IUmNGqWjtsJvIzhesW4aEX64HUep
         NrEBpgUANHcogtLb2xyHwlJmgmccOmvUp0o5O1WlBnch7G6qEKXHc//XHjDEzuXguBsn
         UQgcO15ANfbyfr/wgnaaI19QjA3RiHQmHCQF2CEX8IYHsS3Ma7hJhO0kMfHXMXVdh4Iw
         bVOQ==
X-Gm-Message-State: ANhLgQ3b/p3kKPO9wyUIRjnPGueS6lQYrbLaerLQ3Smb51li+++y5FKc
        Rm4TnL53Q/pROmw0OQ6C3jypRflc
X-Google-Smtp-Source: ADFU+vtTOHJCj1WO3JX2pSwmBJ2rHiIGvOkj6V7BV0UQ+q4w1huemNS4QWTaP3HgDBcAIVBi2B7fTw==
X-Received: by 2002:a1c:7719:: with SMTP id t25mr8314292wmi.7.1583403230448;
        Thu, 05 Mar 2020 02:13:50 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p15sm8331066wma.40.2020.03.05.02.13.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 02:13:49 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     cavery@redhat.com, vkuznets@redhat.com, jan.kiszka@siemens.com,
        wei.huang2@amd.com
Subject: [PATCH 0/4] KVM: nSVM: first step towards fixing event injection
Date:   Thu,  5 Mar 2020 11:13:43 +0100
Message-Id: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Event injection in nSVM does not use check_nested_events, which means it
is basically broken.  As a first step, this fixes interrupt injection
which is probably the most complicated case due to the interactions
with V_INTR_MASKING and the host EFLAGS.IF.

This series fixes Cathy's test case that I have sent earlier.

Paolo

Paolo Bonzini (4):
  KVM: nSVM: do not change host intercepts while nested VM is running
  KVM: nSVM: ignore L1 interrupt window while running L2 with
    V_INTR_MASKING=1
  KVM: nSVM: implement check_nested_events for interrupts
  KVM: nSVM: avoid loss of pending IRQ/NMI before entering L2

 arch/x86/kvm/svm.c | 172 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 103 insertions(+), 69 deletions(-)

-- 
1.8.3.1

