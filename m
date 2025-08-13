Return-Path: <kvm+bounces-54577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40081B24666
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 12:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D6AA169447
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59B5307AD2;
	Wed, 13 Aug 2025 09:55:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35042F90CA
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 09:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755078934; cv=none; b=uZgm35N3cpQVL6KnUDaX42EobmKkYKFZXoPiNuQYOr3ugaJnXrEQF+5aB5X10LZlH9zu1EUWh22Qfw6Uordtlg7dKQs5ZOxas2/Pa+jN0JTCbqSs36dfjlvjYpYl4vuIMjV+bLfuKdITBS3SRAv3vH7KCmfGdIJ48IDL7F+6fFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755078934; c=relaxed/simple;
	bh=sidzB44vS8fDxirm53233zlrvmEKC6RPy48nYeF8be8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IiQSRbosSrvZj//tVixVxXmAFuKFxc1kVzQvRvx64Ih80e38OkyY1F6prgyDDnzB9jk/E0qndDNZ5yrmueyNbk5jrAMmVVPynA9DEsILcB0oVDw2zeCvMfC+dkIeedtxEhO8T1v9zGf1O1GPZb/IZcltoBwlt5IbtjxwwjrzlUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-881776a2c22so1578392839f.3
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 02:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755078932; x=1755683732;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=syW6P6sH96DJbGciuh8z8YbdPpQvxJ0Uqcbcksg9U2s=;
        b=bYm6exTNYFDJ9g9x1s5zmnR5VkvnabISro1C92lY4zVv9ime/nvTgMuGZzpavRiSjW
         sRrUl7/MLZX1+rT/SzKiZY06aXOJpMUmef/iH9A8kR06hUEpmJTyZUwQor+QBXqWnrPF
         Rlvf6u1Al3SfOD4SWD0I1B8W7kcaJxKMwu87AtemdBopu4AB/U6UQHYqTIJcNjhmDXQ+
         V+3K5n2d/Ylc5HMmiObFARLVzcw3uXIL6LIFh+LOX17GMRtTO5G3xxceQVBW8yksfLHF
         bGNruDmaJUEeTvke/lxfmNBgaMvwb8EfTFQjA4xAiY0PMkeDdbDIGmCW2UOIkFESGMRd
         iDBw==
X-Gm-Message-State: AOJu0Yxd9V4TvK/FEE65lfjU0ZLZSNY0FhD3be9VG0bpfOWiEo8YCQAZ
	iL0kSR7HPoDYdpra3aS23o4DFnGbnztoNBPbLIgYS+JY06Xgg2/s/BOjDyAVqAKquxHzmYNmafv
	48S0nI9RJXRRFf8rHubLU7y+fWUHc77O6KBSYKCzt8Wx4x7rsy7qy5uweFXA=
X-Google-Smtp-Source: AGHT+IEn8c73mlS7WXENcuLt8rnI6vTHagW+0HPPhr7dc5hTPRl7uLTR/9723zxYmtU4T6a62OMDPjwwXkHiNAff/BQcwDalW30A
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d81:b0:881:a0df:34cb with SMTP id
 ca18e2360f4ac-88429613554mr424595939f.1.1755078931739; Wed, 13 Aug 2025
 02:55:31 -0700 (PDT)
Date: Wed, 13 Aug 2025 02:55:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689c6113.050a0220.7f033.0143.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Aug 2025)
From: syzbot <syzbot+liste8f38291080552a06e3a@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 1 new issues were detected and 0 were fixed.
In total, 5 issues are still open and 74 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 151     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<2> 43      Yes   WARNING in kvm_arch_vcpu_ioctl_run (6)
                  https://syzkaller.appspot.com/bug?extid=cc2032ba16cc2018ca25
<3> 18      Yes   WARNING in kvm_apic_accept_events
                  https://syzkaller.appspot.com/bug?extid=b1784a9a955885da51cd

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

