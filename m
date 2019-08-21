Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BCD974F3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 10:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfHUI0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 04:26:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55037 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfHUI0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 04:26:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so1174913wme.4;
        Wed, 21 Aug 2019 01:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=8a1RxKgl4Ho99BSDrm3kp2pAknY5o067UUqOAsK0EP0=;
        b=dT8WftTimyE7Yxj68nlu4Izp6oOh20ppEAjBdSuZMO0uCVE6wu0b2+HOly3r1AQEYe
         sVD330ISGuOhleQRplfaMjsVooBZlMCryBWft8NYK5EUZUMg3i4FcFd+kCauPgsYVIX7
         nqrtRjqLbHddpMJfRxRSkv6p/0c43MYLUCY2dUg6Z6+A5KV3V0sbgAdaEpEe7CeMQkJh
         I/6UdtzDgD/J7EwEn+vc9lwWLR6KZgFFiM/Vb2AWiugKHbWDlLZMuC0gV/QEU5CJZYdm
         e9sLkBiJHPNu43V5Lf9e1lenVHuY1iXxDXb6dvXRZvY/QVSGCsaGtoR6aGuJ6cgrccXP
         Di0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=8a1RxKgl4Ho99BSDrm3kp2pAknY5o067UUqOAsK0EP0=;
        b=sY5Pe4E5lpAUAGk+SS9nH6bBC2q5EJX6w8oSJaYW7fz9933ZG5NGeGCGLZcKQV537A
         U8bLs6axYtYmQWEC9ClEMnjtTl4hDYWjLE2G91qHsUOCKH1qa6fNnbovjm1vhHvFFN6t
         74EFRUxxaylH+gTMVlC45C0njXoJUYxo/+IIPlmGLJK2hMelwRfjmtCPxoUqproumdpr
         IFM31JGHmZ0omHc5phwPZ2RJoXw2O3bnBYpEIInsy5Ewx1Q5ktlEfWpw9Lrs/6B0kw9Q
         rsqXrrRawPcMXl0zEYwFE4MthAD7Pp4DBYp7leh/3+e+VsmNV5oTNgSuBip7U5Ujkvdq
         iF2Q==
X-Gm-Message-State: APjAAAXTxqaud7o4/nJrPHoJjlQ8lEBz+iptSv42mfwojafNHDAzorpM
        vvbH1rmKlYK+4MkiXgdUCms+5h1r+sE=
X-Google-Smtp-Source: APXvYqyy/d0jhexMZME5uEI9ZADdvOfT+nlmvPZwLeJB1ms/t5JydsYI16TK5wdsJgX25jSNiAOIsQ==
X-Received: by 2002:a05:600c:2111:: with SMTP id u17mr4847080wml.64.1566376004647;
        Wed, 21 Aug 2019 01:26:44 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w5sm2931892wmm.43.2019.08.21.01.26.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 01:26:43 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@redhat.com, ehabkost@redhat.com, konrad.wilk@oracle.com
Subject: [PATCH v2 0/3] KVM: x86: fixes for speculation bug feature reporting
Date:   Wed, 21 Aug 2019 10:26:39 +0200
Message-Id: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 1 and 2 are the same as the previous patch, but using
svm_get_supported_cpuid and with a fix to the placement of cpuid_mask.

Patch 3 is new and, unlike the previous one, will only be in kvm/next.

Paolo Bonzini (3):
  KVM: x86: fix reporting of AMD speculation bug CPUID leaf
  KVM: x86: always expose VIRT_SSBD to guests
  KVM: x86: use Intel speculation bugs and features as derived in
    generic x86 code

 arch/x86/kvm/cpuid.c | 27 +++++++++++++++++++--------
 arch/x86/kvm/svm.c   | 13 +++++++++----
 arch/x86/kvm/x86.c   |  7 +++++++
 3 files changed, 35 insertions(+), 12 deletions(-)

-- 
1.8.3.1

