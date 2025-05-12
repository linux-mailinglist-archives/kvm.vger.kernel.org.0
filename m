Return-Path: <kvm+bounces-46173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 144BFAB395E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8345F1883775
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 13:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9431295512;
	Mon, 12 May 2025 13:34:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8402DDD2
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 13:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056870; cv=none; b=B9lf5hi/cHrcQw5k+yzP+tIuMBOtxN6OHh/kO7yovf+uF591E46MxZPiFmPYWQrpodudQmrOt/neANa5XPdP7GJeH6XtAuuccfBHZcqkDuNh6k4C702QkH/rPW6L+70vzkR+xZWtXjUsff6Q5kCrZXOmko6MoyIYStuqCNP+jcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056870; c=relaxed/simple;
	bh=4Vv5Yavxgz87k3KuWmpKhv4WsaWKlfAaBZkeX599/AI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b+IZK64Ql+9GmfEex/HV+a9BuLxtIBjH1oR83qoNduJC7NV6v2RkW4c6BA1c7NefhOfjRRPUU+oNza+gxyOhXOw22aeI4R4rBY+cd4/nRpXtgzPGC9cTT+xSAZkVR1ehnJjCoaI34Br9T6dn7L1dPmPdS9imkofbtv4TjPnzhnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3da731b7df8so43272425ab.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 06:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747056868; x=1747661668;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z9j2UdJGB9ncPUm9WnqkIs+crKjDK28ACVt9UMi6y/c=;
        b=n5Z20XmcLSyQHVDejvGI/IVHYRR1VTLxLN/iX2OEZXR6uCdyTbGH1NhGUcPfokB/ns
         TskopNVvHqBbf/7O1wOvHuSX/JV1W0FaXz7tukcYt0i4yCi1pVQBID/mpmOo1xNXuoVf
         hQ+VCNotSFHoMztDjdwBSojr/zPCit3VBPbld2rKdnck3ZpcgZucjiKX9vI3XGTUKLQQ
         QDOBl5zPdn5o+FO+p6KaTbXXshrssUfUNob8T8F58nvDanf0uNW45NgKvyYIcz2Eejla
         C69ZpAK/daA9KNvqciB0uN/CvlAkdOA+SC/DFsc2clD9PoiKQ8fWctC0TH2PNMJoXauN
         s1ZA==
X-Gm-Message-State: AOJu0Yy9ByxtrnJvEKkg+AXqyyYAPuiTMcmCnzPOJ6XgzSX8QwkIgmHM
	EANu6C3+QIApu9ak5aZPJUEed5UzLuV28FgwPIfuJ7r3Sf1wO+36aMmtYg7/j8FE7G88Ge4duDE
	7p0XLoKHvPkaG3CiVEhMSq5E4bDJucNLzQ0NUETLMHbO6Nx+su69jqys=
X-Google-Smtp-Source: AGHT+IHHriIn233CQCM00NI3zG6RxV1LoxUc7TKJ43olQ7KOLrk7exRKx9VgDgN+GkhkyaOpluyPTlV/aeUW3UE5tSTki/ffnh8X
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2612:b0:3da:70a8:5b26 with SMTP id
 e9e14a558f8ab-3da7e2b03dbmr135754495ab.0.1747056868146; Mon, 12 May 2025
 06:34:28 -0700 (PDT)
Date: Mon, 12 May 2025 06:34:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6821f8e4.050a0220.f2294.0062.GAE@google.com>
Subject: [syzbot] Monthly kvm report (May 2025)
From: syzbot <syzbot+lista6f7ce0ccccfec4c13d0@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 5 issues are still open and 129 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 506     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 6       Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
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

