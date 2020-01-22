Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2236D1457A8
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAVOWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:22:38 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41220 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgAVOWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 09:22:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so7452370wrw.8;
        Wed, 22 Jan 2020 06:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=GSJGNfmWJdvPi6qCmH6aIuM5Ni4bHB6sMCiDwaOTS0I=;
        b=LdLER1eBpYC9MfHbeHvJMAegzWHtLskW1EG11JfYw/DBieS2F26gkhYq9vU9RFebg2
         CF17Dk7XB1LQZwf+ELFerhfLUeVqPlfgnKdr0qsndoO9+FUYmb4fWYiot3E41uSkEf2q
         b6GUveMs1t2Q6XiScR4FYjFroHRSF6dPxj8j+SoUA/9gzDcAI0cZk1/kmlhGT1RffFHi
         QYE1HZV9VtrgWBE5J+lm9g0B/MPGrEp+pxeUJBmDxZtAC2QA1LTxtht7QM2g1y77k3FH
         YvMQ2eQue16uCNLeMC+AQlPDSOmaXAX24IjQdyYsYTYngKgxuFFICbtgjZqIecQa9rEj
         /hdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=GSJGNfmWJdvPi6qCmH6aIuM5Ni4bHB6sMCiDwaOTS0I=;
        b=nz2+K4Fe5arZ/+ahoFId1A39cumfAn1UHpoi34CDVhAHxOpf0Mta9SbEhFDeqsVet7
         EhzgUSeu0YH6YE7kD7hiZDnXsg1f1Jz8G5dvRpuiOnzByhjQpxKnJjbP521j6aT4LlEr
         /xnHsGKu9Wj+j7rYbomIQoLX+igQT0GXFZa9MTTsW3UE0rYYcmMzrYwA8McFW6e4/LtS
         gbc3Bh+O9EpwymtOn69ZtKw0n3lwpBOWHZDtHh4figKUSXY6exnpAZUMXovl3r1s0+8I
         vXtBf51eBDYIO9k6gBTRzzrJs9LbbPDf4I8tqxlq3NgMZPBJ6UI9nTVZwHDPI3rcnk8n
         KtcA==
X-Gm-Message-State: APjAAAWIKLyg71UMxMSdV/qgOZNcBQ5e3N5LYDfqmVTISM6w1uMwj041
        ZfFAkjERKASuLNXPsrzu1+zmsEEj
X-Google-Smtp-Source: APXvYqyDBM3WjxjQgKzylesMhWKnONMixkkXbQ8g1jW1OC2/O3qhMXZKU8JzidWGU0PZ/3aZlBOL7w==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr11982766wrw.132.1579702956381;
        Wed, 22 Jan 2020 06:22:36 -0800 (PST)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x11sm4172282wmg.46.2020.01.22.06.22.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:22:34 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com
Subject: [PATCH 0/2] KVM: x86: do not mix raw and monotonic clocks in kvmclock
Date:   Wed, 22 Jan 2020 15:22:31 +0100
Message-Id: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
the default kvmclock_offset for the VM was still based on the monotonic
clock and, if the raw clock drifted enough from the monotonic clock,
this could cause a negative system_time to be written to the guest's
struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
observe a negative time value) it hangs.

This series fixes the issue by using the raw clock everywhere.

(And this, ladies and gentlemen, is why I was not applying patches to
the KVM tree.  I saw this before Christmas and could only reproduce it
today, since it requires almost 2 weeks of uptime to reproduce on my
machine.  Of course, once you have the reproducer the fix is relatively
easy to come up with).

Paolo

Paolo Bonzini (2):
  KVM: x86: reorganize pvclock_gtod_data members
  KVM: x86: use raw clock values consistently

 arch/x86/kvm/x86.c | 67 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

-- 
1.8.3.1

