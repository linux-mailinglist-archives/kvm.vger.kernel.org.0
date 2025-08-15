Return-Path: <kvm+bounces-54795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F5EB2830C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DE5C7B8999
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88937305E0E;
	Fri, 15 Aug 2025 15:38:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC61304988
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272305; cv=none; b=I85O1OfTbqGdQ6a7AEUIEWXuOONsDWWHn5nh5aZTVcFhrGWCH8LbL4RGI5eC8IrWZjwOVr9qegC+YN09Msa8kux1xvIGcwzaI3vdNGprr1YgFSn7Q4Fmkxxv+zyZvSD/x40T5NMqjWF22cjw1YzcX3ajeqG57GpHMKIrUL5YIo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272305; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RxVKBkQo9k2BZFnv+HnU30i+TeGXm6JajvO+aF2/ozrFertzlyx67EGnaXe8eVgseuvYSH98kx3+retgiEIwtUltotLiZGiBBgPsYPZVfZ5ZFhRSAhwuH7efp0a8HF4V207wzKBo+j0yMqn5KhmPyoBOre9uAtjKeikOjeOmVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e56ff1b629so56440265ab.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 08:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272303; x=1755877103;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=qcsYPU20R40A6LuKQzLdEI9PjMUapgJnBZ64Zw86G7aoQNHvBsLxhtjDr7EzMBkJa1
         Tr8Yz/7jyAak1FEUmUQzkLF/yjcBAiksDBZmmnxP52lf0SmmN+DAJcpw6wP5F0uUIbD4
         i+YFy0QpNm2xNRNmrSYQsS53Q6bfKgeLsMucu4iZ4fz0IvKi9buzV96CyfdyVOyVIRyc
         AMWMsBcyybA7KjQxr0j52vACGOCDZeBi7JJt+j48638GwtAxtBz0+F7TjCXbAr4tabLC
         l3C2tlxvrltgyYB2WEwf/n5G2It3xEVpJoj6ki4bitHF3Fpco1oBD+OZL4XsEP/ARg1+
         19SA==
X-Forwarded-Encrypted: i=1; AJvYcCVUC1e/bW8yBmgdPlW0GkHncIOKvwKSnlKM6NCkY+1dMnrGabMtyjM3fhhOKRMdVqkXPX4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzit2Y7LuO+ZjHPyLPd/prsvTJDtIhXxO/wIwzO6MOM7/C6NOrs
	ss3RFZs4nHuXuJ7aKKZi2qqrc4+GVOt1FDMTjypyeJO7G/K7f0ieFfUZKxAruNewYHJ9mM3bm/j
	iAJ10HPRMNCIdZzP0V45Vyzj50HHrFcZVDvrNHVIlTNKrliJmMaIOoiZuZSA=
X-Google-Smtp-Source: AGHT+IEZCErYDJfK+PsAhXz8az/SOFKcABcXNXr0Q2bzIAiRaGBhp8DoowWmbEM2Eo7/QNOXWUZsT99JggtdxpHJX/wQX6tCGYLj
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2707:b0:3e5:58ba:d9ca with SMTP id
 e9e14a558f8ab-3e57e8252f9mr48746805ab.3.1755272302920; Fri, 15 Aug 2025
 08:38:22 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:38:22 -0700
In-Reply-To: <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689f546e.050a0220.e29e5.001c.GAE@google.com>
Subject: Re: Re: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM
 guest and host.
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: dwmw2@infradead.org
Cc: ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dwmw2@infradead.org, graf@amazon.de, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"


Unknown command


