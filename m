Return-Path: <kvm+bounces-22067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2D1939550
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 23:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A8C28233B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 21:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4203538DEC;
	Mon, 22 Jul 2024 21:16:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A01CA8D
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 21:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721682990; cv=none; b=NaWAa7dff10XNyOUOL5oRpab7YGp2QRZG+b4yBuPsFde5vJBjteZODhmwyffVGq+F+lLa1neF9ly4mdVzVyeNudTDxFXkCO1Am63hrzN5hN+uZICVOzOzDoy2RHAxvBnGuOz6ZHtrChRJu7N+N685w2eayv+3n63JoEsdSUfcEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721682990; c=relaxed/simple;
	bh=1YiUrEA4gfdPdK1EJw2xEROGIhjaV+yyi2c/TaJWhlQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qDNaJaWE/co3cDoPKI0cJqIznzYdLmBucjh05Obody7mPmyzSuWUoam8VrDg7jMhz3jVc7gc5+RcdwRkZ2tPzSN3mY3sabzO+57FPDGo94h4kvih6qjNP1lmdR4rbrlkheXXgM5b+p6t2or0bDzhQXGTb6alBz9BgfRuWc2o6Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8152f0c63c4so725071139f.0
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 14:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721682988; x=1722287788;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xs94mEAkVlrVSm/7w9ZANGfa7Un1bHL1xCgm8+AxyAo=;
        b=QkzZIa97OBq+xetADZR5KNyIc57C5zGhc82+Fax6uPpKOVhV7gWfqzqBOCakvJ6C5m
         v6txWJzoBAcHxfHx0Se6TGlo4REEn8brxsCNUpIjg0lFR+vI10wHzsbVSCipQP3YpU4+
         ZKQQRfHRClbYqnkUXxJ9FFKnR5MD4pDnC2Yl3qM5qeT8i+cuZfNVyDluNQ1e8iUu1eBa
         TX0CR+5/5IDmpTVN/eo6apTrCVFDO6utu+RbI2+BudzJZYhNIfhc0rshI4VgM2KQmoQR
         gl4TVjbX2nauP24Sexnd3jdi7EmoO8GiH3sl2gK1LG3cEwvRlEXipBpo2CbsNw6lbgGV
         E30g==
X-Gm-Message-State: AOJu0Yw5XKJPlWzUDIJs7oOODMNKU56mhQ5IcDhyiwZLB/farDO0Fug+
	3XzKiyxleTi6kj9dRWQWddvtHBBtY9yfqzpI1eaiPWsu3EWB0GJsD5DgrAf1qeUl3u3DMnD7aJZ
	HpOO8imPYsrnaxydgFBGpxpNdsOezlfhpinyRWC9f8hrZhMokTQFPqMk=
X-Google-Smtp-Source: AGHT+IEF8DnLDcBpyXNlwE6OPF+4WIFZxxmb3DPFkI7qayDNlGZDm55N7M5gyEaBZwJ8I/aG8iSbV+0Lf9+jewOx65+pmO+nEgNl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2685:b0:4ba:f3bd:3523 with SMTP id
 8926c6da1cb9f-4c27999c2ccmr3221173.2.1721682988573; Mon, 22 Jul 2024 14:16:28
 -0700 (PDT)
Date: Mon, 22 Jul 2024 14:16:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f335a5061ddc8e96@google.com>
Subject: [syzbot] Monthly kvm report (Jul 2024)
From: syzbot <syzbot+list9a13c0072a3919a6debe@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 1 were fixed.
In total, 11 issues are still open and 121 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 40      No    INFO: task hung in __vhost_worker_flush
                  https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990
<2> 23      Yes   WARNING in kvm_recalculate_apic_map
                  https://syzkaller.appspot.com/bug?extid=545f1326f405db4e1c3e
<3> 5       Yes   WARNING in vmx_handle_exit
                  https://syzkaller.appspot.com/bug?extid=988d9efcdf137bc05f66

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

