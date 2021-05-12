Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0537BB54
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 12:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhELKzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 06:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhELKzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 06:55:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3919C06174A
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:54:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id di13so26526092edb.2
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9AyQNFRVaqZBkCum64ac2+NglKRSTSG7tKAIz1f0VSU=;
        b=TwZ2PNgQ6ijB4H5qDp02wNhKbmobbFG4WokNqwDWqfLgXrLBfgsl9zhYCyb8getMv6
         j5ut8iN1DOHv7M9tu7E1aA5J7dc6EK2hw0fwJ/4IW4p7iyfzN6SRHh2gppVvDRGhBMVg
         FgSQ9FGoIlRO5f/eacfeDrxoLJkP7Zvtmx+INFQTe23KDk/0/7Csrj4ZTTCGYPdvjLN+
         oTtZAygHpsyRZ62OFurrlHfq6oxIIwISYF1XejQRHbaXPWhsPJ/YtVww5fx2qLJrYluQ
         vkk/YkLg9k/qn3WiGxW8+nE8EVVv25uSPqZBB3QX2tVj4nkz24IqdS+bJpTFuvvsKf6v
         owOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=9AyQNFRVaqZBkCum64ac2+NglKRSTSG7tKAIz1f0VSU=;
        b=i+mghMc7+SOWXogDaKbJJ7XbjGd3Oz16u70TY7+pWY25iy/PkExhWN8wB3rXdp4nlT
         2fMLwx1M64cBmBAlAPj2SRIFtVkKjkFjBdp0rkcr5uba8YAjTOpPJPMwMXQtNk/VCHVz
         zTkefqPIs2wTt4T21YCEEGw7DSpn/di4ctjaE2qdxP8gE7ZgoafOV5/eRC2/UKcSq3YM
         j7B7QpBfu4NmXaiTqXp6uVvIKqIZZ+8BRZXsnv9790U2Ohf16l+cM5TB8WA1T0aSDu5w
         pdkhGcfrMmO1VCHrsgcfBRLev3Y4i7IwfkSnHxIg1IA0gLxnO4ZWK/K/It/zs/n2PU9l
         OXBA==
X-Gm-Message-State: AOAM530nG/lK7W6wgp1eZlBtvfXQxrGUO7Cn3aIXAlsNR0a4+qVdlKhs
        3vbEMxY8Hd9DPA7HVkjd5yNGW3f/+Vw=
X-Google-Smtp-Source: ABdhPJwhefcaEZSk4CzEzFI3pWa0vvw3XVp89SQUFD1Knw6bzz/ouYu4c4NHqvytRBVu64y6+qvolA==
X-Received: by 2002:a50:fe04:: with SMTP id f4mr42236651edt.29.1620816882383;
        Wed, 12 May 2021 03:54:42 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b19sm16829624edd.66.2021.05.12.03.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 03:54:41 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 kvm-unit-tests 0/2] fix long division routines for ARM eabi
Date:   Wed, 12 May 2021 12:54:38 +0200
Message-Id: <20210512105440.748153-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As reported by Alexandru, ARM follows a different convention than
x86 so it needs __aeabi_ldivmod and __aeabi_uldivmod.  Because
it does not use __divdi3 and __moddi3, it also needs __divmoddi4
to build the eabi function upon.

Paolo

v1->v2: fix __divmoddi4, make sure -DTEST covers it

Paolo Bonzini (2):
  libcflat: clean up and complete long division routines
  arm: add eabi version of 64-bit division functions

 arm/Makefile.arm  |  1 +
 lib/arm/ldivmod.S | 32 ++++++++++++++++++++++++++++++++
 lib/ldiv32.c      | 40 ++++++++++++++++++++++++----------------
 3 files changed, 57 insertions(+), 16 deletions(-)
 create mode 100644 lib/arm/ldivmod.S

-- 
2.31.1

