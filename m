Return-Path: <kvm+bounces-33482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4269ECB23
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 12:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494F6188357C
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 11:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AA3238E11;
	Wed, 11 Dec 2024 11:27:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED4E238E00
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 11:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733916452; cv=none; b=eNS6T2ZYSC/guvfAHkUBGIcXdr/Diot53bllx5grP87HHcPZSpwEK0y3XEDgiFKHJERUng3RmhYguUWh72tcvMgrdV7bo4TzeXLS3jtmkmGJmrfVYsxLUtzRNU3RpS6Vcpbo6JS8nsLX9/m8+9y419MXj7KYNx9Iy4XyylSZsVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733916452; c=relaxed/simple;
	bh=J30Av+5YmalMd4f41vg4/dbJRtGs5vm5Q6LzZuJ+QnE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mAw59fMXTDyVoWv9dIMnMi0+8jcGrQoH7CxxXjBEIsAdTNTLS5OaHQ+o4HdV/q6xVeAgY4wpZ25DywzNyqUcGUVGwnSaQFW8pLdIsX6ZOgNT4lmnw7Ar6WDAJizHUvnAr/zyft/ohGIZbFPs8fQfe26xZsg5rZoXRxfcTlDm2I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ab68717af4so1161005ab.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 03:27:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733916450; x=1734521250;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3JXLWXKpe6lRb7PMjQJI2859i9VmFM6O4DNwZT7Z5zc=;
        b=vgvTaJiC0IDWqV80vDvSwYsUdh0ArVPDBd4AhlyRidqA8ujxH5xgeoHy3N8d1vUBFy
         o2EYHn6mn3hvol6QRZtvqr9j7YMDxyw2UtvpekLp/Bit72zJDZFmGXFq/PVGZ0xTLAoF
         oDEbLeoKROFHhHUh4HlXW9PTAPaTYLq1/rbmOpxosJ8m7vBz+ilC1mXSxdXTjNNQT1aW
         3Kg8IkDpDsjgoi4dfb6QpI+GC5Zk6m9GBwEtJYmNJCBTwCRhJmKynEUUGVRK8Prlezxs
         KKXe8qOldyUE2P2xtxuoTXgpZBKb/9/WYndSXrbgTXLFfijBOOwChcr5kp6S9GeahwgM
         SQgQ==
X-Gm-Message-State: AOJu0YxZ0nGjo6yEkJKsiwu2w+iD0MkcW0k5x8GW+1Xoz01oHhsYEsAF
	OvgXpnecsJ+fgQyyzQz112vdf7Dk+1g55bPqhM3RlVMtNvbMfQGXHYG8g/EFY7aWSNz6EB7+NzF
	IDmQxdhIDXanX5ov0FNwz+JOFuB83vQZ2tCf+mZMLh6+FxgqazwEGIYA=
X-Google-Smtp-Source: AGHT+IE1k641CEoZDUDljeGEn/xzWsHbMyXnxGHnoqNrkR/Dxv8DylQXap/c5Mw4AEcaK4/2SK4uyuQdvSVvU54DjcHj218+um+V
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c4a:b0:3a7:783d:93d7 with SMTP id
 e9e14a558f8ab-3aa05010eb1mr21474035ab.4.1733916450556; Wed, 11 Dec 2024
 03:27:30 -0800 (PST)
Date: Wed, 11 Dec 2024 03:27:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67597722.050a0220.1ac542.000a.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Dec 2024)
From: syzbot <syzbot+listd945ff1949b51baab774@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 125 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<2> 39      Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<3> 8       No    WARNING in kvm_put_kvm (2)
                  https://syzkaller.appspot.com/bug?extid=4f8d3ac3727ffc0ecd8a
<4> 4       Yes   WARNING in vcpu_run
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

