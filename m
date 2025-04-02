Return-Path: <kvm+bounces-42464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF74A78B35
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 11:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4CBC16E190
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 09:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFF4236A68;
	Wed,  2 Apr 2025 09:38:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF441E8358
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 09:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743586705; cv=none; b=Ip1Kwo7DoK8DePZc1iLgz62SI3oIlRRul4Ldt8YjGvc80G7YRMYpj01c4oZxiCczF5DAnnbzNG/XltrTjehft7kY18RQjpedLKun/RDo3NakdjgllpE2gLrOxrBZH0lQZQ0SiJjlpSLvZ/e8WesaEJcMVAZ3MaNDv+9jZDynNpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743586705; c=relaxed/simple;
	bh=TxOdn7zfMJ1G4ABuFDhrvNKGIFsxHeCl5qtcdIukllg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ETGtwnI3DaOwLeHAsnnWVkiSHtucPS2WW5W6BKre8UwvnX8k7OconCga85VzLXzrrGOpqp5XHzMjMz6re+IqeX33spbDXTgMa4853s0F+cnWD6wKvCSIm2iHTrGa2VfHEnRa+KGGpuE3dtgzbUchgrzed398ggNoVdfOWcQ94CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d5a9e7dd5aso71717515ab.3
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 02:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743586703; x=1744191503;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cFAFcDdeatsk0rIUEwRZMxS5vX6WVqCabbcWXMXHWEc=;
        b=S3mqOiCP8a0Q+DNudxDrvNgr2GsVlzmj6iczrceYeyf3AInoifHcMLf4+KMRE/fIAx
         rkNlPjdOSUIa1Hup+oldboA0S5uRwIFIa2VhXe9V5O6oP9wgWjauZoTDjPBpsCWoH/Bu
         CAKBZpEqg01nvTUwemtyZEaLoi90y8bUrEZv2dJEiLBSXJGQuPMkpi5EAqFute3csrfO
         QhyaGPr9ELOFf5qs4GeRCS45AVQB3JFNBNu1T5LRB9cQ/1AtkaTmqaRwTfNOO5Nk9Ynt
         3IhV36HJ/nVNg1UYSUNRuF3EhcZR9H5nsQOj3XZbMc6603pQaslKyb37kp2MLvC9LMie
         2IaQ==
X-Gm-Message-State: AOJu0Yxu5+2Jj3v0mAub8ra4SEFbxu75Uu5z7VwD44/kgGbpulZCXYyT
	QnAaRrg0ocWcBAmfbBEXIDe+jrCXXp1DkXknPi6EVpEfWvLHt7Mfh49X63wWkgonhVj6Y2sUd2B
	xrKc3008TEBNT7ykHxWKcsvHoSIMJZFRAuc63xBqs53APg3+E/kf5pS4=
X-Google-Smtp-Source: AGHT+IHLCNtKlZQUNTx1aPxdQlS77LFaF4uvBLk2+xCqBEWq6nfh5H96ofCOufzihjvGjl+6za0RD++QASHqV6IexKQvbxHiUiWm
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152e:b0:3d2:6768:c4fa with SMTP id
 e9e14a558f8ab-3d5e09fdbf6mr170165725ab.21.1743586703538; Wed, 02 Apr 2025
 02:38:23 -0700 (PDT)
Date: Wed, 02 Apr 2025 02:38:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ed058f.050a0220.31979b.0040.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Apr 2025)
From: syzbot <syzbot+list005eb7ef44f63424b8ba@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 0 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 129 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 323     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
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

