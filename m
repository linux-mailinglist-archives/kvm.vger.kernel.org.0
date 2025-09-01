Return-Path: <kvm+bounces-56422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08952B3DB3F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 09:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9476B17BA20
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505C3272801;
	Mon,  1 Sep 2025 07:38:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960F26FA46
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756712315; cv=none; b=Mfyp0jxoeaftGaPa+/AGbLbipFZ6/q3qFddJAAwO1bhj5+WYvQRVPwQhfT3htKznntW84LqbH8ICOeB8rWnfIP3La1kU7rCHx/m3hY8vnipl4ajaIqnXZY/+UbREYnn0pV4Jgp3k7eCRgxlnvfAajEZL09p7oGtVurwnL4T2wQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756712315; c=relaxed/simple;
	bh=sQQSWSV885Jj7JQz8gNeil7CoEvnftgq44GNzVub6YY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZCHMspLB45haGFPookRnHw4Wl0e2N0LQHkwcciEe4DfwCnwtQbaWx7szMxo6oLWVowxu1T10ZeAqixE3lY8Fgtox3CpwW6hfSFMTGkqw5U9cIyOm8cOuOiZdI0kBy9Ss0iq2YKszJuCv9YKHXF73pBuYXi25DpucFZ9jp0qChcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-88714e1fd48so292842139f.0
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 00:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756712312; x=1757317112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v/UJh+rH1Sl4Vn0nGhSgqQ4p60qWqfFhvtpOqby8hKc=;
        b=oZqlSqLtAMo8VxxL20apVVuXZ+mIbvUJCRfARpRCkm1ecOMMmHwt01tI7iaM7r/n+R
         fIzeUjLzGUTPFeD0bH0knefbEIsgiuMnewBTPZMAA+gMm0Q/xX56D/BYvmGBoHxmmrT7
         MrElVbsVU2TTkpAfar89S59uODofU2dAOKAU1L2aJPzYyHrjKkR3/wqjKfygH4HfJsCR
         7QzhQge+hJErUgEQetYrPq2IOg+zDN1h/0gceiN0WRo09cblQ4IrZBOhsA9oNPydYFCV
         eb4E4IKLuLZk6jq3EfGmgL7C6nfNPTi5x5H1SB0ibVuNaPbN3Nc5IaLHyqsKqSNFUPOc
         133g==
X-Gm-Message-State: AOJu0YzDOG8AJALRp4wdTIe4hvorXN03sc4jnXbIirh+/cn4wQpOgJW2
	w+G+JodeSGqd543gY8pPcwuFp5I2wQ9EnLVh6yiGelmmTDaFIx3q9Vt99nEZUrItd4Sp/ev/z6F
	deB4BlewMIOQ8lGefQkc/9KjOUytRYjbwGKqubFG2pTH+ZuATp3NKLZuSHH4=
X-Google-Smtp-Source: AGHT+IFkkBQAyNX7DfacqOon5FLlqQQuwgLSAEcCYpBtrVoXRt0WPjWg5fiX9a/wlMI3TuAJltytLrbohZAL5o0tmXACkIu6aQJG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cd3:b0:887:1779:9a8e with SMTP id
 ca18e2360f4ac-8871f432d05mr1423849839f.7.1756712312419; Mon, 01 Sep 2025
 00:38:32 -0700 (PDT)
Date: Mon, 01 Sep 2025 00:38:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b54d78.a70a0220.1c57d1.0542.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Sep 2025)
From: syzbot <syzbot+listceb50001a1986a9527bb@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 1 were fixed.
In total, 4 issues are still open and 64 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 635     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 13      Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
<3> 6       Yes   WARNING: locking bug in vgic_put_irq
                  https://syzkaller.appspot.com/bug?extid=cef594105ac7e60c6d93

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

