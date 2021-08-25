Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD63B3F7E8B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhHYW1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhHYW1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:27:05 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43CCC061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:18 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h7-20020a37b707000000b003fa4d25d9d0so763420qkf.17
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HM/X82cVkDGvf9nW/K/Zd+IRxigdROMilUCzVCzDBUU=;
        b=eWiCvuSqykeixfaFFud/PmohOoPpWmm/+xNAUa/P6F/hhYLYM69dDe648DtK+T9EyE
         hZOY3B7HZWtAKkEzHSmKSiB0WQRWmWKizHh6MwzZSNMTDieP1HKPVPuEaPotkqqTtgfQ
         W2w3WoQtME5rS827Q5fI5VCG7gJDP5fydugI7Bxw4SB3bUvCfrhoLmw8WG5ET3zs3Cu7
         gW1y/wYhqunZlfhBy1gszW7HEMIWWU0umbzjfmgH0pFDifi6PDqNXMp+0Yjt0ggGJ3NQ
         33Y8YaPZsv8AT6W8Idm4POUpLAWquqo81k7qtIRxCTqkygGUvA4AExFRLTrgre53pLca
         kTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HM/X82cVkDGvf9nW/K/Zd+IRxigdROMilUCzVCzDBUU=;
        b=qQmnwiwSfls/ig89I5xnNnkJfVPVNsH3D0gR4zZu2qTJkZCojSzkg0Gle1TVNGoCX2
         +yI4N9aU3ygx0lXAU9LjXzafD+mnyWpvFbWgB8IvcsliLXL95y/h0KmlQ9N4vP3i8LTe
         JzdIrZe2r3tmSgQJH0tKFw/SHdeOd0C+tWykNL0kLFkot+ikkKMIadgUOUj4GAFCvRnc
         LGUQJ+dSty57tbIxl3cwZUXlInycVawolJYfj4kGaVzP9lNWYpjtQo3snFv4raT5YZ0D
         +NQ2uLZhsFloJm0v/v5fBei9Z2l5Yw2VQQjdcJRarc1PNt7MyqlEWyweoHptvMnJeAzz
         RsHw==
X-Gm-Message-State: AOAM533GLtPYy7ankS0J0yNNwp/x/I3rVAHvJ9ZNNJUswImcYrwTvKi9
        npS4P/oUGcKVUvxd3d744yA55eU4iAxA3wmOL3vAzuOeM/aKQAkSbUnLSxqvM6CVVF3dkMMTurr
        sLlIgGsVHblR8XepGsgqZt1+FAOuQ6gL9iMJdPMoaif4iTQWNfpj+TQ==
X-Google-Smtp-Source: ABdhPJwR83HbHb4Kd88S1stnOCcqQUNlARNlA6J+53lJ5lWOQ01LtUnMvyYqUJplZs9jwgTtvk0HH+lgPg==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:bb35:184f:c54d:280c])
 (user=morbo job=sendgmr) by 2002:a05:6214:c69:: with SMTP id
 t9mr1046361qvj.28.1629930377961; Wed, 25 Aug 2021 15:26:17 -0700 (PDT)
Date:   Wed, 25 Aug 2021 15:26:00 -0700
Message-Id: <20210825222604.2659360-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 0/4] Prevent inlining for asm blocks with labels
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang may decide to inline some functions that have inline asm with labels.
Doing this duplicates the labels, causing the assembler to be complain. These
patches add the "noinline" attribute to the functions to prevent this.

Bill Wendling (4):
  x86: realmode: mark exec_in_big_real_mode as noinline
  x86: svm: mark test_run as noinline
  x86: umip: mark do_ring3 as noinline
  x86: vmx: mark some test_* functions as noinline

 x86/realmode.c | 2 +-
 x86/svm.c      | 2 +-
 x86/umip.c     | 2 +-
 x86/vmx.c      | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog

