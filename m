Return-Path: <kvm+bounces-17309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C404E8C40D2
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55088282B53
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 12:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1F9150980;
	Mon, 13 May 2024 12:35:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287E150279
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 12:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715603744; cv=none; b=EkiCrewB/UGdcNpbuzw947P/I2oyjINLgqOqYusLvft9sH/kO+lJoO2W0UspFgc0Btb6IwYM6l8TTGtwZ6+qiPcM9OouPWJbxdj0r6r+u/QlB/c1jnT98xzuLBPDTMiYkRJNy8qjhdXgA8jvItZmq93yvqo0XU5I9B1yZR56ngY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715603744; c=relaxed/simple;
	bh=oKLIKN/LA2qP/A7K2H7b69maMhrft+dHWN05c1P/Iyo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qil5hyUIBc03VIntPf4Ak1NZ7tOs5p0FPtB+IqQXGyB/BDu5EhATpTEO9/pwQborHZ96xmfakdm9lSWmkn7XuLeTNrZakM032pLawUhGJuEYa2VVXZXuhrLkuqP941K1XpSKvACqVnmR9UxD/H3F/OwaEGx36HrY9s1ZVFRTOeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7ddf0219685so558502639f.3
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 05:35:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715603742; x=1716208542;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=if8T46urbQNJN85WrRQs2gBhlpb+FKzcO0gmp2dH/G4=;
        b=Asp2eI9Tef2hijVDqBjPq/CE4hBbbV5uISk11bUuC3n3Gzz6/S9Dj/jnjVLFr5jxVo
         ZJneu3aYPaSA7y0pQ2bg0D2nhTHyOnhsq0e4jphHT7qyGfnnRZeDhCvc8u32Skzip2Sd
         CjyIVbd6WFUY6/ROcxCc/GeINI3M9cNLqOCdpr/qe3UqKX6Ziz0ODe0MnmlEIWlmoZf+
         DsCjxPRJWilxXXPo3vxap2E66vQrfq8Do5mRzcGw2sIlcvgJEyouIGqoFazP43u3tv2X
         PmK9l4kxRypGI1KI/MoDpvmT7+IMR2hUpT7hwxIWuTz1z0Lqqg1lp/tnWPZwLlVtU7mz
         YFRA==
X-Gm-Message-State: AOJu0YzcPcrFrBcoavHjM28jxBxX5nEt8T+he2uR6v7yyNyNgp+fTdKq
	z5VvPpQCwmHQOeQqBS9wVdu7aO/sO8uqn8IKeWbpVe7e9KjpOgW01se34bBU5KOkE1OvFmdg742
	ptrf61YZTW87MB5O8Nm5caAooZ10ieDkvDezUmoyLhFzVgT6qiWEti0E=
X-Google-Smtp-Source: AGHT+IFkOcJUfGNBMFnhw7AOqZk0zhwbG26hU/3puD3J78jqgbti4ZnaCFmJdXfhI7EHPYytA9urrqbsM+pNjJd3CFgGDktBFTfo
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8427:b0:488:7838:5aba with SMTP id
 8926c6da1cb9f-4895868b41amr921226173.2.1715603742333; Mon, 13 May 2024
 05:35:42 -0700 (PDT)
Date: Mon, 13 May 2024 05:35:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a330cc0618551f1d@google.com>
Subject: [syzbot] Monthly kvm report (May 2024)
From: syzbot <syzbot+listae8e7effb4763866f80d@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 3 issues are still open and 116 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<2> 4       Yes   WARNING in vmx_handle_exit
                  https://syzkaller.appspot.com/bug?extid=988d9efcdf137bc05f66
<3> 1       No    WARNING in kvm_mmu_notifier_invalidate_range_start (4)
                  https://syzkaller.appspot.com/bug?extid=30d8503d558f3d50306b

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

