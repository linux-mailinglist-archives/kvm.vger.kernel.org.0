Return-Path: <kvm+bounces-51747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E2BAFC524
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D067C425150
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BD829DB84;
	Tue,  8 Jul 2025 08:12:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F31255F25
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962349; cv=none; b=HZcehy7gOkVTTC9X1BCSs/H7gc2EldOT975r86mB/Aeqk1eQNbirATtdiqL6TO3XrL4y2bDR45yEUma0A0AQCn9vJW49nOXEMCyiJcmbb+9n8EHfoYPKbfSudKrYP1BXNSnsByEn94w1It5lMSIeMK1hUa2iK2nK7cqcbM7yONc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962349; c=relaxed/simple;
	bh=ShE0KBsCGAE9oVGIJNYHQ0XuAmKf1pWnVbPpO91PQ8I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ECtAG2D/I5/yte7l3GCkwzWbDjxyaDLV/03BFwJigLeIKdLqWWyVBCKYFL/QfCmgf+JvTGEPj9XG+MxE0pashVbHkhrOsomM5srIZy+zFypGZyvUYQVJ2hok3/w5tMNxLA0EAgn4audh5DY56wWKZtsZ0n9eyeIeKBKTEOwWSdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddd97c04f4so66595205ab.2
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 01:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751962347; x=1752567147;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eckydPV4jNGZ39c86mTYz1jw+9b4iWmX6rWZX1gtI6s=;
        b=KdTdPnfWXxqKUX3Puj3HbxlnZxIum4bBnD1ccYyauneUkt+guBNDk8ddFnKGIom0DM
         pmaWN2rTb4Cm+YNG1O6MdN20VBlCsu42mc3ueCk/gp/0DmGnkIeAusMrmHnT5xzcD4Al
         gcX1OYLWF3Ek7WzbqzRUNmT2is1j9A54APWdP31QfPohwpy5V1VOlSxU+p4U7If7VSbT
         t+WOS1YaOkldJELJ5+DR8eL6QFADy2/Wro1NCwYuoZSucUiarKHg2TBQ904Q2JNbBcl4
         pLGCyTHc1UvuzzY4pmcZL8JaK2CB3bBcldQzBl6x9jjqmhY00Ub9naGII7vUSr1v4etJ
         WzlA==
X-Gm-Message-State: AOJu0YzTDYeAKYSGi7sbOMpGg6ZpZOh3ZsiECoqs6aMyVpcxXO/n9yKO
	qA4NGaWXy7YsfNDU8Tjc84OngedcldCLTmjb1kugA25/I6Z2sxwu897jDmEOrILEIDMZ76OLfIU
	CAd1oH4GX+mcmozTCMpIi17fKie/88HwvtycSf8OfsGtcTllreTmP1Kh8P1Q=
X-Google-Smtp-Source: AGHT+IGXJS6Hs9N3wqxnV7S+SIzk8oxBJ8iJwhdY87nD8AgTbEaL0+imJxhS+ViKVSdE6kCDpMLlN37ITm7xxq7ylKNQdlgfgNEU
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:15c8:b0:3df:46a6:cdc9 with SMTP id
 e9e14a558f8ab-3e154ddd88bmr17526785ab.9.1751962347046; Tue, 08 Jul 2025
 01:12:27 -0700 (PDT)
Date: Tue, 08 Jul 2025 01:12:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686cd2eb.a00a0220.338033.0008.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Jul 2025)
From: syzbot <syzbot+list9a2c7079b55fc0f83274@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 0 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 2 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 602     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 151     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<3> 16      Yes   WARNING in kvm_apic_accept_events
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

