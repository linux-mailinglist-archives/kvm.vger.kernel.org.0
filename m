Return-Path: <kvm+bounces-24413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE16955083
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35E581F22A97
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7521C3F2E;
	Fri, 16 Aug 2024 18:06:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1126B1C2326
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831582; cv=none; b=BRGFaOke9YzR6IOv6ppcB7wCS9ZkELaOd2nnbcBrbA/hUr6GUdlhBdgO6QxD7upGqNseAMhiZ2eKQ3/jux253+jx0V2yP9oTT57flqYSzdTv0ToTuYkkgrNYBECuO5u8++2BBj7lOEspB/uPiEjg2kNWOKUqh/rkiP2Cl/Oe210=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831582; c=relaxed/simple;
	bh=QY3ohNySnzo+hMm9ROgMKm7NiLqGJh/ZGAf76kr1LEc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=PXnjg2GircaPFEeEsBXy61IWeXIxnq8LFyVcSt8yKYNz3S4In44iBX0/ZBr2G49ZV5wrHROv/D79Wb1E06H28YotkYfs7ydu/IW9UVzROD2hnWnPQN47pAUYzWueOYBeD3WE0A+SaMkmPCE0dS16UsyWwntndeEbS3jXbAarvrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3962d4671c7so25352785ab.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831580; x=1724436380;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wk7VWIxUCGpPDcCbIVePL+r/gPaOsRfDlMifv32OdWU=;
        b=rY7pU8whCjiciPFMJB+aCNUhzGEjKGS+rStI4wmfGUqA6xbP4o9Ic84PRhc1p9gX3v
         35U6k18Nr98QFrR9DdGzcyH5L/7HPKHuPitlItS95k2Is0Zh3Vzef56AHJF1VUlbZLuy
         YzZyj5kRQWKtRXQQwwj2ZILSO0qKm9RnEJnZiwOcINt4HSX2r7lf9PfVAGPKTKNt4ChK
         7RwyGf9jCG2oQcsfo0uagHJHY76tD/C7pSpPE1bYNDCCxg6ewjjSqGKWn7It6WH12qvm
         WCZKLwyhK7+vWPO+8sh4jMX2XK5vUTgl+ERxuIO/INeTMIRzvc4n2KTI8U3vxhiKxwzN
         qLNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuJCET2PmZRnsCgtuhGEjzqZ2moZEhExOqAtfCeAVbz6FiGuO1yGNHpA7ubIJbpmoUknZzZ/hk40mYQ0jPBvpPs2dT
X-Gm-Message-State: AOJu0YyHkaM+nBTZ47pWqZ2ex32PArnewLn7QNLMIbqh9VKs7Bu2jy+g
	t3T7rlep9zNF8D2hHmsW40NoeZThfeMyRfqsneYjMjbhZvamHM4JzVxbTQea1tAbryHA0jwu45N
	b3Zn9xGPnYQcNMRFqT7mNTe7GLjloxT9s9L8X/1Cge2ADBEdsWhUJU+Q=
X-Google-Smtp-Source: AGHT+IGfABZaedo0n2HrQEGufCpZDZGGnqM4DHsd9tztChw2PWGsN8G47lQwd4Gzke7RLXZRN4XRizt1Lh6fHwwDJhTOWKzB+8q0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c26:b0:39d:20a4:f42 with SMTP id
 e9e14a558f8ab-39d26ce4072mr1686585ab.2.1723831580184; Fri, 16 Aug 2024
 11:06:20 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:06:20 -0700
In-Reply-To: <Zr-VGSRrn0PDafoF@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd6343061fd0d012@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] INFO: task hung in __vhost_worker_flush
From: syzbot <syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com>
To: seanjc@google.com
Cc: eperezma@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> On Wed, May 29, 2024, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    9b62e02e6336 Merge tag 'mm-hotfixes-stable-2024-05-25-09-1..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16cb0eec980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3e73beba72b96506
>> dashboard link: https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990
>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/61b507f6e56c/disk-9b62e02e.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/6991f1313243/vmlinux-9b62e02e.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/65f88b96d046/bzImage-9b62e02e.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com
>
> #syz unset kvm

The following labels did not exist: kvm


