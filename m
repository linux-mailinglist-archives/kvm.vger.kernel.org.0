Return-Path: <kvm+bounces-53786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5B4B16E07
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BBA018863AC
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8CD299947;
	Thu, 31 Jul 2025 08:59:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF04035971
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753952373; cv=none; b=RLl2mvp75doCxAOfPlUj41Evo+dHHi9oEFg53si1OV+NVwd5lvv4M+omgsVFyzpp6tmVPrHkE9INVydO4hTqmvBgvVJjysFV6dnKOa+S4TxO1c+T2aWWRbF1ZHOQz7UHiwga6QkovV3mw7rQIZ43j3PFMNO5yfWOto86BiI4eRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753952373; c=relaxed/simple;
	bh=3mEddPHZsFvJ9Cwt+PYalgpR4EylEMSlJ1PF5CyMsOY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Tgufheb+kAe82fIOrlLAOiNCk57msQH78Dc9JidKUrxc5Dz/MlUM0ht3hQl+Ewve4IcYLTk92VoqjcTCIBQeiwNO9DOTs1KfDkfKmJ7ixpliri5sUybwH8cIevxto4OfVTb+MsJmiIH9VaEHSb6FKz5sJ9JVuhFQ5A5lZy1nqLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-87c73351935so177179139f.0
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753952371; x=1754557171;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bpD3IXUoJUWT7+mzB7fHXG7BExrdSpXHnx0WRFCL1Ls=;
        b=ptUJZKtbEqmqoGNH7mCskMTcnpWX138W+2+LHP4wjz34SlExCLYav8KjWZWYaXRo2o
         yRwvkrAlySyukK3qOuH11GoO/lXk+PtHCISEyFsR0Y4EO/6sqL2W5JdBqX0a6eyqgC9y
         ON3K6f9PkrHpM7pHv/k6axi4LyP0UwAe2k5oJ91JYb3koTc5V4kgXBBXk/u0NgHWHhIA
         GvjJkiu2uNvdRjcylDPUaN9FRw+w1MNLgGT1PAIe1XhPzXlGooT6jOM5fBpbEwb5wENe
         ffPGLvhTsY+QEIpN2WhkDBgJq1Q6g2OO7Tcs8ZaU3/ThhwjtIECQ3qxNezZ5s1qbUuvX
         EUzg==
X-Gm-Message-State: AOJu0YwXlRG0WlaIeynNcyknf9IA80QWswWZqD7axMgqUOTChmQwkAyX
	hlSzhw8c58xc/YN0z8xI7H6boZ0xwsAaK9hUw4IUfFmZ2UrvMkPDMle8JE2SL9DwPlPllhh1Csm
	4LbHRdxptY9Dw22FZuzTsdOFmilL3NZpPtCkqvGw1B6T8APcTSQBiXCQfxyM=
X-Google-Smtp-Source: AGHT+IE98xAoVtpMaY/lDFNzB73p9SJWWnoamk12G3HWmE0rJr+lqsqLsAldxvjeC52RzI3naksfv8UQaoLGmvUOT4/mclx1lgx8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4b:b0:3e3:f47e:815e with SMTP id
 e9e14a558f8ab-3e4058e8c65mr16279685ab.6.1753952371137; Thu, 31 Jul 2025
 01:59:31 -0700 (PDT)
Date: Thu, 31 Jul 2025 01:59:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688b3073.050a0220.5d226.0015.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Jul 2025)
From: syzbot <syzbot+listb4a8dca9c06e0ff0ef85@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 63 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 613     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 4       Yes   WARNING in kvm_read_guest_offset_cached
                  https://syzkaller.appspot.com/bug?extid=bc0e18379a290e5edfe4
<3> 3       Yes   BUG: unable to handle kernel paging request in vgic_its_save_tables_v0
                  https://syzkaller.appspot.com/bug?extid=4ebd710a879482a93f8f

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

