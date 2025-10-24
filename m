Return-Path: <kvm+bounces-61079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DDAD9C084F3
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 01:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4C094EA2FC
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 23:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FAF030DEB7;
	Fri, 24 Oct 2025 23:27:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D2E22AE65
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 23:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761348424; cv=none; b=bzrps4f8CFr4/8kbYUxK+mqcvPNT1FSrpxqUwT9L94xRH3u8woavsjBKEY1hgKUdCUrx9DO9DthP22vmGkJsddYm/Bwn6m4qquqcv2rwYqbrHjOcriOZuXt2e8RPazhqwG/M5oK/E8gUEVVJcIHQR5/SyDgMjFCBiP2jEYL3x4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761348424; c=relaxed/simple;
	bh=3IzmtxV+k1CuCWhjKwm3ov3MDEiQQ+Y0OcMKRGuLLtI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=b8d3/PgH9e/IkvSfCY7mbhpM6EWP5xBepG64YIoCFw7sBSWmOi0NQ8Lr5cjnmTRNRCRk9m1imqiqXd/8M/HOJ42w5sicgNkUFeEEOtwXxclaFWp4ji/gFtDfvoV1qlFH/1AXnkCCk+LA66Kuh1AC8O4aRfU2H3UF7tynd4px1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-430ce62d138so34707115ab.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 16:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761348422; x=1761953222;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GblzFMUZu0VlIWrlaRVoWJh9w1MmpHUAGd1oa8PG1ic=;
        b=vWEWiN1bI3C4Jce3DUtqlnkSLuqTD8X47u/LOevCXMio1wgY9dooU9kyuAieoiTk41
         CjbDBSpeNQecXk2OuPYpv+hRF6td34rpCIKDgtzd7NQZkibZPC3jv5iQ6wj02K2fgjRl
         wRII0oT6wRevRFGgV1L6qzjWfiDxdZNI2zP5NtiiCz2ErN5GSPS0npg35cXt5hgwFKfI
         NGCB9A2Tt8bm4HH7XJAEngtxoSBqZLaFQHNinK+/rXcZeBLwlo1bqwXvgeEvdU6VccsB
         LTJ7W/171MhXX6aPGQcv0NM89hVc+GmkQ+9TdGYwk7jPtBR/GnDxl4kf0yRXcKTQ0f/Z
         CSuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKHCaJHH8AHYWeHTNaOwti1hgyZJHcF/6wuG1Cddl+Ik24wjWKtEBHePjCYkbL/Hrt2g4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2JIVRzubkTUdmjr0RNIYk1IFUhF4N6HiIHL/1UOS8dIbl65pg
	R3An3q/kyJCjwfgzlc1ODSTvWqBMSyIMJ8rrMl+mt3RLA1DBf8rE+7/jdZz2MbD065mtH8AQzA3
	qkKi7cJUv+4kxezbzyO2Wpxd3gMDG+apYUoXiLIY8yTUwrdAZTDRlVfpaBQc=
X-Google-Smtp-Source: AGHT+IFFzFiCwb0a2CE6b5Vw4N/nWGwy/jlX6MQXaWDaY5FSRGJARWwTzmq3c6eQv4u+knwAAw3h/O+QaK9dBNlWXB7FJm6Or3uG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a27:b0:430:cfe4:6e61 with SMTP id
 e9e14a558f8ab-430cfe46e9amr398027905ab.14.1761348422373; Fri, 24 Oct 2025
 16:27:02 -0700 (PDT)
Date: Fri, 24 Oct 2025 16:27:02 -0700
In-Reply-To: <20251024232459.8716-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fc0b46.a00a0220.9662e.000f.GAE@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
From: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
To: hdanton@sina.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com, tabba@google.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file virt/kvm/guest_memfd.c
Hunk #1 FAILED at 708.
Hunk #2 FAILED at 732.
2 out of 2 hunks FAILED



Tested on:

commit:         d2818517 Merge tag 'block-6.18-20251023' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=67b63a24f3c26fca
dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14426e7c580000


