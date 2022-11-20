Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679F163166F
	for <lists+kvm@lfdr.de>; Sun, 20 Nov 2022 21:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiKTUvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 15:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKTUvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 15:51:20 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B762B1A3
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 12:51:20 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id j7-20020a056e02154700b003025b3c0ea3so7441701ilu.10
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 12:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDLcfZl+txYsJtzeVXqCYMCFgcOLb6wRGnlPi43ilE8=;
        b=YWjOkBZpGDV01hsv4R0Tf0cgz75Q6h4Ujoc+SfR6y6Jmel/6PHrAPRMbGlxcHT8pzg
         W0ElyP/q9NgCAb9xZWWcC4jBgafmEdbFpfACKrL/i9tyqR9jwucy6jikyW/uvVH+u8/W
         hNwk1MJy7pgzYKP3TJJvksFjgaZbzonPBMqCHy1CGytI0Jv2MJ3p+2CytuPxJeQeFC4G
         Dqqm9THHPQs6ZAxT6IkAOrOq8BMwOGtDtEHbaEL3ZMhd/ic51M/auObc/nQz3nNihIOE
         cJZ+ptmbgO2P8qrIcixmzTwoKSVasUoSlqWvyMhKAsNY8CHCuBo4xUSVrr0rpgJFLNR3
         OgeQ==
X-Gm-Message-State: ANoB5plQi/Qlghy5nHvxrmiVBnNJcFIxDF6QywpRUSz6grAtaJovsyW7
        IGFGcyX82+9VayIEGhMctQXrgelY5qJ2cndWDpFTQsXxE3nL
X-Google-Smtp-Source: AA0mqf5CBYmEqRFQYqm1UpoVHrdbq/uYkStlCRHWaDTVvlLNGxzh0dMVaQAZBLUykBc00JqAz74S8DO7Ridn5eA4tsjxMLFw/LVU
MIME-Version: 1.0
X-Received: by 2002:a92:c64c:0:b0:2fa:de7:7c09 with SMTP id
 12-20020a92c64c000000b002fa0de77c09mr6888485ill.94.1668977479370; Sun, 20 Nov
 2022 12:51:19 -0800 (PST)
Date:   Sun, 20 Nov 2022 12:51:19 -0800
In-Reply-To: <00000000000021719805d692e035@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cbce8405eded1951@google.com>
Subject: Re: [syzbot] inconsistent lock state in sync_info_debugfs_show
From:   syzbot <syzbot+007bfe0f3330f6e1e7d1@syzkaller.appspotmail.com>
To:     bp@alien8.de, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, gustavo@padovan.org,
        hdanton@sina.com, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org,
        linaro-mm-sig-bounces@lists.linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        seanjc@google.com, sumit.semwal@linaro.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=115b350d880000
start commit:   84368d882b96 Merge tag 'soc-fixes-6.1-3' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=135b350d880000
console output: https://syzkaller.appspot.com/x/log.txt?x=155b350d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f4e5e9899396248
dashboard link: https://syzkaller.appspot.com/bug?extid=007bfe0f3330f6e1e7d1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164376f9880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16cf0965880000

Reported-by: syzbot+007bfe0f3330f6e1e7d1@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
