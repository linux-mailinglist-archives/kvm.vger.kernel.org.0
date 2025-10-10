Return-Path: <kvm+bounces-59761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BABB5BCBED6
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 733D51A60C1A
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34051274B32;
	Fri, 10 Oct 2025 07:32:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449C1126C03
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760081552; cv=none; b=jFvlTywcOUc8GBwNzxwLNKxUGMSwEB9NSsBnnThqs882TTsTdMlTFFBya6RBBCt3L1NeqkmS2p7uwU312bAUPArlvHxCIMVft8YfIKvbFRUEBvLS59sIIRyUS2D9gudqExV9D/pnP/xxivAcWkfrk+MhsGiQcCD3VnB4BwCCOSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760081552; c=relaxed/simple;
	bh=ttINZP9/5MVUK0XvaowCW7l/505B7b4VQq9AdR7brbw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RJ7+PNZfPV9X4b682wv7o50IEp00SS4OWFTRKh9X/ijEbeVfzHe/UXBH9PQcaH5mdGcESSSii2bg0rPabjVPNHtVlGjSzz485CjImt6VtO+1n71xhQLZVPykyI9CG4sb0AS7BkHLmKuE6QfnOwqSkEzsmxhyJwuZ+QyjkvHW66w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4257e203f14so106427555ab.2
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760081550; x=1760686350;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQPoOHJXVilhqdCudz8OjlgRyvFMfrtV4ytvm2IsQfg=;
        b=dI5AWYV1qKAAMXXsM4zA+SwPaSzb4BCOS3IWLpcdvvU0EZe0heBQHDHp4dCumAWhkG
         jMBDOMpLP1azCiZIIv8TRDGCR9Vh6qknLyOdUq3fP3W6HIrcyzxFYC+jd4fye2xAk8o1
         EQ+zhSnkikmPHBCzOOeSrARu8fM+rvSHfZVZr5zJV3+LKkGkIQx4F/+NPzKJA5mmmzmh
         NYXlUzsYMIdE8aBC3AfM0XgkGTwiZY+xBi8L566lGCXYoQZpwNMxJzN4Pb3E5tVFStZe
         SMctocWHU3of7D5k+LTSQIvMTYaMEohrRtEYxQNMH/a8w4Rm0SIZhDDA9ADuDRgpDKCm
         0w4g==
X-Gm-Message-State: AOJu0Yw/EndQn8GSChukMNSBfgcIkxwxSDGrl207HtSbyrkhMDFazoWF
	gdeGpHXdgB5fWIRzc6NDEAUnTxTR/yVvuZEM/7qE7y63ZJgUPxRT5s9CQ/E6/dxsTpMAly99s6O
	//wx6UQLwJSBf9jrZQrau+TF3uFMV/9lIJSneSj1ofabgR2pqLsGuIZY/TUA=
X-Google-Smtp-Source: AGHT+IHRnXbjnWVa57fAT/g/AunyboyoAzVLWuG5/Zj91A2ki2q1fTgqkAUvQTGs9z1Wl05C6nvOLw5ZFDRsUEJpiNCrvDKng1J5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a44:b0:42f:8b94:c128 with SMTP id
 e9e14a558f8ab-42f8b94e60dmr85150445ab.28.1760081550412; Fri, 10 Oct 2025
 00:32:30 -0700 (PDT)
Date: Fri, 10 Oct 2025 00:32:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e8b68e.050a0220.3897dc.0117.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Oct 2025)
From: syzbot <syzbot+list6bac0337c0f09a6aace1@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 0 new issues were detected and 0 were fixed.
In total, 3 issues are still open and 64 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 649     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 15      Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
<3> 4       Yes   WARNING in kvm_read_guest_offset_cached
                  https://syzkaller.appspot.com/bug?extid=bc0e18379a290e5edfe4

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

