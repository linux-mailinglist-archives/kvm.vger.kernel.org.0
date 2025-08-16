Return-Path: <kvm+bounces-54823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C11A0B28943
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 02:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D44D1D01908
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 00:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9ED75BAF0;
	Sat, 16 Aug 2025 00:30:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DA52BB13
	for <kvm@vger.kernel.org>; Sat, 16 Aug 2025 00:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304206; cv=none; b=Zh/Ux/FFgoINApFIMmHKy9FllfgpxRU8PZ+FLRL5ERlLZwPBHbzfFGytvvjvGp8SzNAtP/dsTbbs/PZMVjKidptLKEq3g5kh3J5lLSMuxM0C0rO9EesFoqYNtXWW5OFkREwZB5F4Gsw0wqyZi/9gDF8h/UPuzc7NtzSfwjP2ZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304206; c=relaxed/simple;
	bh=VWUiUzQK86HWSwGuF8xInFChZoi2gS7Rymc5YjbW5Jc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=egT9xh43RK4rZxikT0LxWKT08vTgaT8gSTJIt0K2jbh++4VcJ5rdYJvpszohAa2UTQReBWgi7PjJ6B1iQjOLyF1LzbiPu8VHPTv76QTxyFzDQGorfkTbuq5rIMVT2PYmafodrC04Q24Kzdah2VNP+sYb0TyjmUTafR6C4KHbJY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e580be9806so11308495ab.1
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 17:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755304204; x=1755909004;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COIfik/RujH0ZCMLEJoppWLOYa7oLNPGVJSWQTRhpbY=;
        b=maUVvjcGSYSxik6AX++R1nMYklpxdTBT0O29A+s2IHba99WQWLMtwKAhBOPnp6ajXm
         R9LeX0tB+vkkdVSPP+P4lWmXjI2lXD908Kwx5MWRvKWbwFPdZTljwUPACDjiZYoQTkp3
         cRyQsUBCEF1Uk+zP5tkZT8nbXuLxXt5VpkPs5JceK8t9VIm7f/l69DzFyEpumgFQLIb6
         N1XaNG0aTvhS3UVSCfpt+LXhS99u2daLuu1heST6ZmiOq7jtUX+NzzFBZBPGmZwSpr81
         vRcLeJA44QghjCqKk4Zl0OrQFT65yP7WbCqOsZ8YFBGT6hLOEYimzutDzFMM4J26/TGO
         ubjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWngfzRQLxEKDpE2PHqd1ElSWlV39oJK4ueiMuGkNr5p+FJDxt5H5nV5XEMXsg1GHz0J+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhKJYuR8Hd02stiemTjbCUz5RyA2HMofECkJJAa6R36ko+e17t
	207ulGpzGX8rqpbIAIJYswk3xc0ka4PSeDeM82hEO7W6MjDk/lnd2OXjCHa7RNFNg8hJU7+1LNb
	VM9ZakzxIleiLv06/X+8sdLtgXCUsAPVH4G9T+d08DGincnfduI5h27jiCds=
X-Google-Smtp-Source: AGHT+IGCPgu5VDqf/or0rvRi+5fvi5mHaUDTFi6g/UotAx5ZrpDq+WzqXhoiqrBWQWgr6NUqvygidm0bU9AuzJFp9eJfOYIlACQY
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c08:b0:3e5:4869:fdbe with SMTP id
 e9e14a558f8ab-3e57e82cfb9mr73498675ab.8.1755304203940; Fri, 15 Aug 2025
 17:30:03 -0700 (PDT)
Date: Fri, 15 Aug 2025 17:30:03 -0700
In-Reply-To: <20250816000900.4653-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689fd10b.050a0220.e29e5.002c.GAE@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] WARNING in virtio_transport_send_pkt_info
From: syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>
To: hdanton@sina.com, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com
Tested-by: syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com

Tested on:

commit:         dfd4b508 Merge tag 'drm-fixes-2025-08-16' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=130453a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3f81850843b877ed
dashboard link: https://syzkaller.appspot.com/bug?extid=b4d960daf7a3c7c2b7b1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=125373a2580000

Note: testing is done by a robot and is best-effort only.

