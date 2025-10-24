Return-Path: <kvm+bounces-60958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 065BEC04758
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63BC93A726F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A62A26A0B9;
	Fri, 24 Oct 2025 06:15:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09427266581
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761286504; cv=none; b=CVxxNagIZBFNbZUVOXOs8qtgF0H45mVI4QHBuckWh4aqPCVCLdXXJMcaQzZNfh63Cd3kt1sUBkFSEB+4mozd+E2oCO3IA7DAsTzcyfR1ivtu/zTB6LnSSyoOGMlQviPcm2WQ5X6t843giu2D2/VPdvS8vsLS2gK4gbkCvAf7A/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761286504; c=relaxed/simple;
	bh=PlYC9Y2rsT1nOUWBFhwWoCZZT2QzHnsRz6hCh225mcc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ataoAYIrkNVODXAWYBMMS/1ZuGbE48tY1qGXLCJgbd8VesQ8oTNh9eZF5dP/uGygzwMymOl+1QRSJFbwFAb98xUYHjD/2dtJmmtDiUbq6KP/ALWLoAYV0zMURyK1b19IH+KQPn2jvcbXluw0EML6VYD1atZfaITXCzh3AUEgir8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-93e7ff77197so486662539f.3
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 23:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761286502; x=1761891302;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CrCdCycFuQycYMA3WoSKuZjQldBlK8LrRCDJfBsvv9I=;
        b=F++3MBODRbtwCBDiN+UXAX+QaeY3hm+5O/Xzb3qH28vwv3x8MVpREX0tNukU/KI440
         y/LV1MCW+1T8kkkmtEEjxLYBG9VMhMZUFdiUAa7MQZ8BmGxnzCF88gOUfCtuF9tecXt2
         1WgQHGnPaThb/Z8dILi7sqn0kIAl+9BXpFo+VxMxBITWOibXSRAgvbaHg7gunVFKUhDB
         qbjjq09Dwitxl6SgldH25xQ+oDa46zu6Tzq7LPZDUtPXdWldTDU9SCAjAPfs/hYoPTCb
         7BFQzunf3xP6VoA8OOK8EBkhYFmeYqvDa8kiDEnrzjbL2A6QwCj/ntQVzi+u2uXG34sY
         zqSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKwU8dz2J1OflZdy8DC2DhieWGQ+fjAyTD78cfOvTrIQfp2uBCgcuFU1uSU3rfLerwaxA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqcYA8ZNjTEJKuku3rmcZlDJiHXV5hPLaltHT/pICayZAbvwvl
	rfZzU5lxjvnvA/uWCcpUPgwDNmr6Gcw3SKrtzIi61J4xCMwgmASd7mubHudb7Z6WVgZ8zuMllf6
	NO9DMH82F1aV3gzZv6rl+Gh8CFSx7QeSMatIxnCCHOTM4/8niETxX0XjfUTA=
X-Google-Smtp-Source: AGHT+IHK4/0DJUb5fr7uNBIahozKYDiqOoq5eMeuCInZlkg17u5HX6X0T6DQB2yi5+29rTquc9Tc4D0IascxtvB3+NM8qfXMPTrV
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1355:b0:892:6e7e:c59c with SMTP id
 ca18e2360f4ac-93e764a8547mr4673673839f.19.1761286502311; Thu, 23 Oct 2025
 23:15:02 -0700 (PDT)
Date: Thu, 23 Oct 2025 23:15:02 -0700
In-Reply-To: <68fa7a22.a70a0220.3bf6c6.008b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fb1966.050a0220.346f24.0093.GAE@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
From: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
To: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tabba@google.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d1e54dd08f163a9021433020d16a8f8f70ddc41c
Author: Fuad Tabba <tabba@google.com>
Date:   Tue Jul 29 22:54:40 2025 +0000

    KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a663cd980000
start commit:   43e9ad0c55a3 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11a663cd980000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a663cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=67b63a24f3c26fca
dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173ecd2f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14bc2be2580000

Reported-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com
Fixes: d1e54dd08f16 ("KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

