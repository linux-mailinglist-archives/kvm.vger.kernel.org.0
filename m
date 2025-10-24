Return-Path: <kvm+bounces-61072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A206EC07FFE
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 22:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B77E256526D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3C32E62AF;
	Fri, 24 Oct 2025 20:10:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF982E2EF8
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761336604; cv=none; b=p0Ml16A93VqxepZJUdSP6Omg9Ei2k/ZbgSFolDC1LfwiG0YV4dsxrMHx+kf0S4Z6fv7aJWBqCCaq0V2ePgEk8nGnIWlwRSMHx9fxK+hpNJKpZDwX4WZDF4yysOoEyAgwuwvhTmzbeGJch1Rkue6VeMtGOdFNvQ/1ZJUaJIFo74U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761336604; c=relaxed/simple;
	bh=5e1z4X0GXfz+sXjtmG8f7llpCLE6qws2zHAV//pxovg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EBxolDRjK5TKTLRcuHbMFljjVh9O62WoN/Hmhb2ixbq0xdQNbc2ZbRiLtGWaDMgPjG2uYwKYSrDwtXM127EyboBjURae+wXVFcwIRd/XzimjMi/NCZk3INDbUWN2CD+YxfniPuomHg+BS9VCntCsnW/1PrHPke4cZHMLeJ4edd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-430db5635d6so32446585ab.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 13:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761336602; x=1761941402;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pD5EQC3sKQgvZOVzVKbz3HY4CWX0jjmoHtrgq7Vyt5g=;
        b=VZYxVE1hckK3DwAkMln64HXeZS/FfHaRNJlOwVKnqIb6kVG9jsFQThWPAvrCpgZfR4
         GEU8jva/mgKSp/MNTKTT2WiOa05lhIxnGD50Jfh9Y5NoFYPREuZKhz8BDsEaeyRQbeRH
         KOhTzlacfADhkxNTJKgOgxBIc+IN3qY/3CDBUlrythAEVHji3LMPfiHckVyFXYSGBi9L
         omlmsWV2n1oPvhMz2+4yL9a/2QL3sTdKb6sfwTr0Nw/Azwj/YeeiDwuHu0+s0Nmc+sOy
         TtWaxRzCYiX4aTPK9G0W/ETABxJtZI/YWiYY+HmuHt33kxhEL3T7S3lLImLBBeojjlAp
         XEiA==
X-Forwarded-Encrypted: i=1; AJvYcCU94VrzLi9qp47xSkdhsR9hoj2E0KFR32MOmEhw4OuHV8//k/ZewXl165/4q0wmL91lbZs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd9ui1wEc1a3UGGIbHhRQQcZpRbSvrpvRTUFvV8eCOU1KxHG+H
	04hXLS5OQaQDqsHSVcDnVTBfkwsWxaID0W+PXXnuy8GIyyRrA9N2gqKmhE8LwUmQnVIMA/pHkQ3
	NVfjOhPu4YsFEWdo8/6dhDVBC4EdXRCh13CojhxTNfW5Xs6rFN/fvJA8jAmg=
X-Google-Smtp-Source: AGHT+IGlUpe7cydcYsCSWlW6XihJFInJ5PrrM/WDK2B5vlav5c+q5ILM6EBm0u8n69E78Yxpsybu0+hW5MT50ZjVBupDnAav8Nfe
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda3:0:b0:3f3:4562:ca92 with SMTP id
 e9e14a558f8ab-430c525f520mr220412755ab.10.1761336602321; Fri, 24 Oct 2025
 13:10:02 -0700 (PDT)
Date: Fri, 24 Oct 2025 13:10:02 -0700
In-Reply-To: <aPvQHxLIVpMykkG5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fbdd1a.a00a0220.9662e.000c.GAE@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
From: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
To: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tabba@google.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file virt/kvm/guest_memfd.c
Hunk #1 FAILED at 708.
Hunk #2 succeeded at 648 with fuzz 2 (offset -84 lines).
1 out of 2 hunks FAILED



Tested on:

commit:         2e590d67 Merge tag 'devicetree-fixes-for-6.18-2' of gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=67b63a24f3c26fca
dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15343b04580000


