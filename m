Return-Path: <kvm+bounces-65716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B85BCB4D49
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CE1530133AD
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656B6279DAF;
	Thu, 11 Dec 2025 05:58:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FEA7E0E4
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765432708; cv=none; b=p5l8d0TCmw0Kzg3Bydw/B9ezqZTQCS6S3O3c3Qd8Rk//Pi6lTjSVsCjGZn6ONZ+JXNSHQ7GZ5sYGXa3KwFBhRVJu9rLUn3YlcGuAboI0WEZOyUYFMyiMRmClwGxX0x1z8Mr/CIrnWV6slgG8nqj7rFe4kr+eeSR8b7r22JEc/Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765432708; c=relaxed/simple;
	bh=da77VZxsIHOPfFF/2Fm0ZWf4tIlepJXfqpfMHSJHmjc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lr1xZ4Oh7FX1QwyZ12IW6aWEpStGIOwMLfbZ58TP9BNlfrZApfIGzlRbcL1nBSjJH4IxzqiY5TJmiJf3wOBzT+qJt/30mKIfVKpXlcF1rQ/wVmH1mONbTSZtYMFwq+qQiz5BcpOwV2B645Cnh6TKF1KXPYdRjkCirt4Y8HCCOao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c705ffd76fso663549a34.3
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 21:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765432706; x=1766037506;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iJ8Da8sF3hVYNvp53TAUxY1WluOPp3L1zftzfOUJ8Sw=;
        b=bv6efQfGSTjcZwwzRL97xMZTYaC2GGvVFG2qNwAeFVLRIerwGU8TLF4m8tTO3GcLiy
         lXqJA78DsGbmQ3FXZbG4retYPoIQ1ZDGMOXcG1VWRXNE2zT+VTld2YEFcAv5QiO4YUsI
         Q4Jk7myBEbAm0+dGc6uHgSX+LjHF3ianOqU99rSJ51TGrTyooKwoGTm+gKgKLHvkMKv5
         ySID6DTSRgBRRUYCLWQC5vmPT/zl8TUsok7qmKojFIrzbI22jke6C5ofiW4A6K1PXNGh
         NRmR7SNNTO+IcwdOBRsTV19fhwZqZJP94XhQRazCHC6RCHpycHxeEMohCsVMx1ceLejD
         wAIQ==
X-Gm-Message-State: AOJu0Yyjmv9UIRkB1rj+jG5lAf5egoYj9AEoCivMlI3ImVw+o39dpWgt
	Xtp4jZfGv5vAorxzVBZc+XHd+eCLJR7uQ49kbSqPNCkkab/AhVeURd5rnajLHrzd5jDAMu2rMjy
	qFoHSvP7PMW0xvasizai3bOBrqUDgQtwesJxBtX0aOrXWKdSQX04l/ebVLUA=
X-Google-Smtp-Source: AGHT+IEgSBXFMRzk0pKjDSFzb3woEajCvgpnab23lyPdxIDY4W9o3ReetHTcCwLAjrQhcmnZUleRA846LD0aD6fwrI8D42X/mYLT
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a0c:b0:65b:25e8:13e9 with SMTP id
 006d021491bc7-65b2ad00ca0mr2959496eaf.70.1765432706596; Wed, 10 Dec 2025
 21:58:26 -0800 (PST)
Date: Wed, 10 Dec 2025 21:58:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693a5d82.a70a0220.33cd7b.0024.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Dec 2025)
From: syzbot <syzbot+list5017e134bce051795ccc@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 2 new issues were detected and 0 were fixed.
In total, 6 issues are still open and 65 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 658     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 38      Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
<3> 6       No    INFO: task hung in kvm_swap_active_memslots (2)
                  https://syzkaller.appspot.com/bug?extid=5c566b850d6ab6f0427a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

