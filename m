Return-Path: <kvm+bounces-13253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 559B7893537
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8711C1C22F96
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A28148832;
	Sun, 31 Mar 2024 17:13:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF78145B08
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711905186; cv=none; b=MaHcUGay5tayMPOmZ+bdT7S7S93pbOKnNROveBTseM5hFEJFbcavYFi1jchVFf7/oTen8mF19KS7JczuXOXYJ4viisgHZBJNKG7IOZpJkvsRaQyeziDbqxDkUW0pTYWAQKT6plpS93U9wpLhelvqYQjGdwy5tQ9J8pC/2h5C/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711905186; c=relaxed/simple;
	bh=FScdHe+fk6X/bRMpAt+bYKDo3+/Td6qWbsCuVZfnUoQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ju1xkEwPMm14jjQLXExA74KELFBjUy2RVZrmLa11kWakyqtn4X3GPhPb3rCu7nBZBO6+tjgGnjxJ7w6Avrz2gOIlDSuGiTDGli9hLFCc40GbRPc+37KWQqR+VEly38tArVBQqLcC0WsJX34aUHI16dATjie56Oipihttq6rSi0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36683ec010eso33804325ab.1
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 10:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711905184; x=1712509984;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=deRLN61LKcB85ChPAUqeDe6bQ+MZfu9QCkK/h4ip7O0=;
        b=Cmoh27tZf5oBq6Gc9rsg2tYIfLvPAgwW/pcG9j2TQ1100OJ+v5/S8754U8gFHkkh5G
         H6BaRMdVj/oegqOhtu9rdhFL2E6gmCoBEG1TpGz3oGy5Urz4P2AJ2ofFD7Ih5xP+4SAV
         GhPXhWaCck5AeZ+MMxqV4bKEB0yxQKHHqvSCuB4orNQag4+nYEB3rtMRlb5ql2gav1AN
         SYCvJLDKN42wHy1FbL1RSRC2YmpOLRn12oVSukI90K7YnkKqTTJRiS7PzXZPVLDDWMCg
         tgvRsHA2XoYP4Omh+lgwHYJQ51qkPilBlA9p9uLcMC6grZDMBdZQydGTGsiqIPU1MzxI
         hZxw==
X-Gm-Message-State: AOJu0YxqTS+eMQjbYDOWmRk62Ooxb16Oj9/Xr9QpBGzaA2Kj6xAvjC+Y
	N3gnudzyn9p9kvoMNWu8Y9lTwd0PJBwSryr0ldqFUsTxgcyVss3qfD2024YAhFVMA3qCK4fLGfq
	K2rIPFbxQE5j73/bpfWYk8O/5/gBmaSQxuZuE1fRkMp5Cqes9I7AQPvqEhw==
X-Google-Smtp-Source: AGHT+IGjmZ7IPlqphmWySQGCQs9CN2c0UvHwRlksBQGi2ROsLUy8RA7w1NvmOKMLqXUczc04+JCG6HMdcNm9foNi3vUmR4mBhNiH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1c:b0:368:79b4:dd0b with SMTP id
 i28-20020a056e021d1c00b0036879b4dd0bmr400627ila.6.1711905184383; Sun, 31 Mar
 2024 10:13:04 -0700 (PDT)
Date: Sun, 31 Mar 2024 10:13:04 -0700
In-Reply-To: <31e473b8-8721-4421-9ebc-e7053e914030@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006796530614f7fcba@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in mmu_free_root_page
From: syzbot <syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, phind.uet@gmail.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com

Tested on:

commit:         a6bd6c93 Add linux-next specific files for 20240328
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=108a85b1180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45a8d76f0242b787
dashboard link: https://syzkaller.appspot.com/bug?extid=dc308fcfcd53f987de73
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10167af9180000

Note: testing is done by a robot and is best-effort only.

