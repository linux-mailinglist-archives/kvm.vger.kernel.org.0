Return-Path: <kvm+bounces-24415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9965955091
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBB301C21711
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC2C1C37B3;
	Fri, 16 Aug 2024 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w8udlA3U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140B1BE860
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831836; cv=none; b=kN7oOIaZLHlVpjGGxL9ozvPzO3r70lNXjL1tuDJDNSw/0ChJ6Lw5x3Xb5M+/gGzZDSp6sfJwPwAC4deTMd1NVmUODBevX2H/un0ZvUv9G5UANPfvQ6dfOSYDAkIdnjUA6yvS3goOX6xdnbDipTDCBcts/n26LvAmVca6nSrGmEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831836; c=relaxed/simple;
	bh=xHQoPuqd+D9OllJ85LC8A6kuHS0jVMOrx5MVSJ99RK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r4cBlL4rEXsuDeivYY8gEnYukvTeKc/yePeDdbleU/vQHaNn88DHhEMeeyvOz0G+DUW7ujULW0kOy284h44eWDQdZdfFDuyrkY82hX1wySePmB+tMWpgyxF7htlyNLTkmI8z/k+mvY9ak5NNMh4VBi7xDaVM1DsAvXf+9DKHp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w8udlA3U; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7278c31e2acso2258224a12.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723831834; x=1724436634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LKLhc9rN0MWqFTzo18sKWvguSCEcuhqaVkCHFGI4wZg=;
        b=w8udlA3ULp5tWe6SGZmCUaSiCpmZTliz/JYbXR1G93R4/wBxSOHGxe7M+lXRHAdBf6
         g0IE6tmr2tJ1yQ2EKPOGAeiZ0HqnGkNP0gj7beeQqR5HSpb4JZR9XJ8V8rX+btNh24Ke
         hloKUv8zxJeb+EpEb9Gh4auD36pgEVY72MY73dFYOHY61Xvkcjp8CoC1Fo60ocIOcBCG
         gTr22uTVA5XG3BikPNWleefD3XlOglH7UHp8jqCN3son1Koia/1ATOQjCf/Hg11KXd7m
         gfEgc2VTBYDghAmulz29Ug7WMOmstGWjxIGV3Lpt+o10oooJpSFneWK/x8m4q/z/tt5O
         /ORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831834; x=1724436634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LKLhc9rN0MWqFTzo18sKWvguSCEcuhqaVkCHFGI4wZg=;
        b=Z5tlyjdgt2496jWjFQM4UwhVs+QpZ2ILtZJwvynkhSAelZGQ6tBQM1PzmHKsJjk/An
         9BD9kCMYsg8AXRSFJi+ByqzTnw/ci0Hnf3oKEhTxkBDcBdH6nxpfKiZ9Fe5H4/ozpAlA
         dmEicDVZM9hNC8m7Psx+Ec7uItAQ7SI4VrovAci3R0KWzaYAVu6YVm2UXLcwpB0lbNq/
         1RAJ7qqbt5vnamhsRybnC+EKFXNPt0EDRALGaoUL0Yjw9Dr3I5MX/S2MUuzfScRE8Eyn
         K2GeeMljKFGMJExuRvfDxGG8XnBTv/jkeUWVLiCzKZ6Apon5uH+ucaPQsOoQaJdv1kTf
         gqOA==
X-Forwarded-Encrypted: i=1; AJvYcCUYKbNmaYJNo6SLFCe7PXhifNKfUvjOZrSonH+1oPhHHWesEhwB8lju6sT7JFzn0M5XjJcuNVeKRuBOV9BKc2oEj1P3
X-Gm-Message-State: AOJu0Yys3qOK1b+z6bbL694KbUIrznEkJFptP8S9+HlnTgIGjACneYmR
	xIFLhCt+wRMxet2qmiV2uTnsNXUUHA7gC0XaZanISS8XvQe5jgbCjD9wjpQ0KlZzhsFBaU1gRyn
	tSQ==
X-Google-Smtp-Source: AGHT+IETDCf7j3tWXi0l8Zbb8sKAD0O6am89PjJGOYdyX0iluckeLErw8vyRXlL+vHPvSkgy+0M3cMXJJsI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:622:b0:7c6:b68e:de7e with SMTP id
 41be03b00d2f7-7c97ad6bbd0mr6141a12.6.1723831834162; Fri, 16 Aug 2024 11:10:34
 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:10:32 -0700
In-Reply-To: <000000000000fd6343061fd0d012@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zr-VGSRrn0PDafoF@google.com> <000000000000fd6343061fd0d012@google.com>
Message-ID: <Zr-WGJtLd3eAJTTW@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] INFO: task hung in __vhost_worker_flush
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com>
Cc: eperezma@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 16, 2024, syzbot wrote:
> > On Wed, May 29, 2024, syzbot wrote:
> >> Hello,
> >> 
> >> syzbot found the following issue on:
> >> 
> >> HEAD commit:    9b62e02e6336 Merge tag 'mm-hotfixes-stable-2024-05-25-09-1..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=16cb0eec980000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3e73beba72b96506
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990
> >> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> >> 
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >> 
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/61b507f6e56c/disk-9b62e02e.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/6991f1313243/vmlinux-9b62e02e.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/65f88b96d046/bzImage-9b62e02e.xz
> >> 
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com
> >
> > #syz unset kvm
> 
> The following labels did not exist: kvm

Hrm, looks like there's no unset for a single subsytem, so:

#syz set subsystems: net,virt

