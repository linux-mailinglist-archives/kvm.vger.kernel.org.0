Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBFDEC9AB
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 21:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfKAUeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 16:34:04 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:48873 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfKAUeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 16:34:04 -0400
Received: by mail-pl1-f201.google.com with SMTP id t5so5185119plz.15
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 13:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u69GTKH2Lgj0OCNQraYxlMapGuKtQ6srnxcY8D4YniI=;
        b=YKBbLk4HJOYCrCFNIhLudf9Q4IhgmYDQg1IVzhYl01ni3OmZVq7q7hDqSBKMRJ9jyF
         lzgxDFSRhG+/QR/gbceal0sqDz/XyTDNiWZbED7cD4W8qBImRpAPp5/W4InV3FN5MVin
         xrJrw3X4tq3iS/RSA6OhLUy5fb7zn5U3Duav16vwVoizc2MRCdQTGFj/yZoVuNjEaCZp
         a0U0lsAYiF+TlebAxeYdEEHzMyuxkmNIGY1+LIRTZcHa/HkQHnmsGNvQtgDuW2vA6LCC
         Lznk2GdeHy0h+b+LxDvwDbH+CDCNTU1xrofZ/eF4AI33fniNGla66nGNJp2HhIWA5Z4x
         2xrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u69GTKH2Lgj0OCNQraYxlMapGuKtQ6srnxcY8D4YniI=;
        b=Y5qOEeC5wrKKCM8TAPMPP98i6lRGN9CHWAn202UsrQmrCoJ5kAfl+yVsA+ufXwyVpa
         qevDGWkTSyhNv641sFLIyUGl/HGJTP9nA9Fim/CBoqcbtQNCIrLPQcDnpw54ZoTXvjil
         mUi+1cAYDhU4FL54dIKVntD1BcgzkTa7BeiwDRaJZxdTqHNyttrUQg9OStMXH6aYNW/1
         o99K6i+5yDdrGloDK0elGztsqPy5ftefje/30zUmQM+GBMh4IgsDK2INCPH47V5lX2yV
         WbpDVyRg8hzagPMoog0jiGje1UKaarxRoPjwUMR0w713Lj69FbqQ5JqilqgzJZSj97iT
         PpFA==
X-Gm-Message-State: APjAAAWaHSNJ5PJ+lsuM9iGfwDnsylC+p2wEXbhW0jFG3w38bhs9PSLn
        Ob4WV/FLtOIDw15XaNKtGRMJDbZYrFmWthwMZyPtwRSElfG0TKzyMaiBmcGS7UUNV4F4apyBXut
        M1VYmzASflOieNx5mjIUI+VqvClVhU2tqgG3qS+IWcs07KYC5zUXfQQ==
X-Google-Smtp-Source: APXvYqyjrpMWmekN4aNjha/lRyASusKd5juhZOJGE3II7BwSUBaHgKXIRFuXLe4ETnxmKcT4reXYE7/jgw==
X-Received: by 2002:a63:ec4f:: with SMTP id r15mr15122319pgj.17.1572640442146;
 Fri, 01 Nov 2019 13:34:02 -0700 (PDT)
Date:   Fri,  1 Nov 2019 13:33:51 -0700
Message-Id: <20191101203353.150049-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 0/2] Save/Restore clobbered register and
 struct initialization
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Cc:     thuth@redhat.com, alexandru.elisei@arm.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Some tests may clobber the %es register, causing problems later on.
- Many tests require a stack, but it's easy to forget to allocate one.
  Use an initialization function to set it automagically.

Bill Wendling (2):
  x86: realmode: save and restore %es
  x86: realmode: initialize inregs with a stack

 x86/realmode.c | 149 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 105 insertions(+), 44 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

