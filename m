Return-Path: <kvm+bounces-37864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D68EA30CFC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D60CA1679A6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FC524E4AB;
	Tue, 11 Feb 2025 13:32:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668711F3D58
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 13:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739280748; cv=none; b=WKOopNthy/omZNb+Y6SV9T/mssURK0uGyJM4/df2E1Sew6YZV/sEdRzXrRq6DGBMxFDOrtFY4mpYL+snOOur1GvuHKexKgJ/Prfu6nNtaGfpK2nnXAu1Y+6MMSUoVEn0AyIA8QNgmgff1NPwFrriozBmzlKZGAJOZzdL0Q9DKrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739280748; c=relaxed/simple;
	bh=9p2nBK45yC0kBtiR9JflsXngBVCnbuGhsfR3KrP4+Rw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=duvQlF8aSZAeaodF97l+PawNM3yVHJZpASREIOeHuoWZ6nEevuC5eVGOEmE6q1j8aum2Cgm1FcLnVnq3THBpMrFiRoyxAf8J0g7jfgn9QpiR6So4gYfaMDMVS5A5XQNyCHIlCVXu//aZMXw4yE/mSaSVZHXei+82ReSPoBmISho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d1466cbaddso29268015ab.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 05:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739280746; x=1739885546;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=evizQsq3nnwBs0+D8L3GWY6Q7PjanGj/b/RM8+YJTyE=;
        b=hm1qJJm13p14+o7vJxmLhACuGzNHirNs7nibh1X+2sN7yoOw/2z2n7efEny1lD2Kcc
         e3zGXGi54OaK1DpjixpZJ9ye1sCQZRN/adOt7Gmw3/hEtzVYJhYPMRYiyplOB7rhWvUN
         j59OKyRqXys3Lt7XpY/qP0HIzZX0P9uPvdiS5/ir9E1Zsrc+3ki0JdwXamzDfGn7Chu4
         UsDz1SoScUmjWh/l+T3tIVJZvoYPk/sFs2mG5Qb8LQaUicjOwTv6lB6zz/ynD0mETsyL
         CzjceK/YC57iHmllHNzuZzyqf6iE6m/GTMW12ZpuDTlt5Un8dGYU3DBV4zwVq04zyYNl
         u7iQ==
X-Gm-Message-State: AOJu0YxzcpgctY+7RoxcaZfZF+A2XYLG5s1u/C8lGWkmwmFSu0OHahCh
	QfjFKBlN6y3reJOvLZ0SoE4QGIOJTWEFbQmnjZXvv3zJTkiVOOP8J8LFP+PPIfz2zXY0QoNTV+5
	ikaX+zUuJXHv3k2WSUvaPy8iude+gydUCYYNfyRbwy3G+qcVDWUMkbLI=
X-Google-Smtp-Source: AGHT+IG0OkctezPm/Jtvc4JlTMMPiWAtA7MsSbaWgMj7NY/n/1W9N3UtCWGff+aXyjQDHZJo6bCWvY+9G2T11b7T+EKdyzu5QjUW
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a24:b0:3cf:b2ca:39b7 with SMTP id
 e9e14a558f8ab-3d16f40ac30mr27560865ab.3.1739280746542; Tue, 11 Feb 2025
 05:32:26 -0800 (PST)
Date: Tue, 11 Feb 2025 05:32:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ab516a.050a0220.110943.003f.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Feb 2025)
From: syzbot <syzbot+list2039ca2416c8ea9fe8ef@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 7 issues are still open and 125 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 274     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<3> 6       Yes   WARNING in vcpu_run
                  https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

