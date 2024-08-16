Return-Path: <kvm+bounces-24420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1B89550C5
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E52C51F23AE7
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4C61C37BB;
	Fri, 16 Aug 2024 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j28MxS6w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64751C3793
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832724; cv=none; b=RXTIpBMzy1oFV6CFjfPwZBMjb8XXBcbHBSglqF8+ICP5ZXFQ8NmEL8pHD1qk8yPqARuQC60I2ypnH2ds2LUYRe5WiupcDlwuwCKyezwQc5+oGUX/0fCvGIGppyf2m+KgTbLTdyZUcZbcIsmh2DYc9/9rpDFkWyXYarBUD+a60bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832724; c=relaxed/simple;
	bh=bLv3LE7xzf34CPEENcBo075k8UT1C4f+1hdgmseoSxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SDs90qDUGn+uW5RLDO5qykw2Qn1XjTKA7uslmAcOUapSET1fcbknGR37kxNE2qT3gNavwuTURuT/e4Z9g8BoPiK8sBs7CXDpc049C9qxHPL7oRFOYaMVhshWgXjGrJu0Mt3TGeeKWSG/da0tTrf3RoIOUPM9AoaiB7oBZwOYsxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j28MxS6w; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-202049f7100so11963645ad.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832722; x=1724437522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/7qvTYY149J1kqjtJQDvm/wIDojWO6TKOVvEvytD7Jg=;
        b=j28MxS6wbXdDy+WPoWPMGIwscvgIjFuT8SJ6cUFD+Dh5OwNcMeHzH0BGSgqbazCr+e
         NBNIOuDsXkJCFGQBjtk5I3hVuYN6oasOOgX2ssWCYIKnhAbCrdmNMatDA2ls55yCdice
         t/PcHRJmq5r0nos5soOoil57ogE/QI9sWsgRykb4LEIoudTsJgsvwsmaktITpbsfLxmk
         NUvTIpo5JMPWoySnpXjdlu7K+Q3UMR9osnTvjxNLbhtpjPeQWWL5S4o74yv9kITY5Dvm
         BT/P0ZzpcB32E2Rf1j02yw4n2DlRHkxMjmWyNkokFaScE9kaoPIakNItaSBdNC5KUazG
         snLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832722; x=1724437522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7qvTYY149J1kqjtJQDvm/wIDojWO6TKOVvEvytD7Jg=;
        b=Ksrt+jTzf7eJpteWQgoiUoAEo7mhWJz1gq4dAYnTosqhjrmCGIsWFDwvqn83tDOpFj
         /a21/lkHY+JMnOcePctseNg8fNZo85tDZ6WECVLUpebdMeHjNFuO98pHKcL0AB+yaa2J
         ryeybiI9zdDKv5xjKqbfbB3rRxaC3Ln1EmcMFXB1VJBLDhUVr4XtoDlXuC7/ZCTC4q9y
         iUCl0J18ZMUJvHiGAiahscu0N37Bh34O4RXwAqtIfoGFBDGfdAhrETty433o3NZesriE
         QX/owWPIR/aJ9atDJUQoVIjwDdF2LxWnXNbsaJPrTSrI+U1xKTGoNAG29q/xVV4CYlUf
         Nf/A==
X-Forwarded-Encrypted: i=1; AJvYcCUb4Ua2vx4lAwLbKwHd5DMvyacwsPaO1Qog6/V8saMRnbiJ6dS2IzbgWUiL5L1siEFE9rE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfJBAY+hTlcO9DF+aYTDQK0iVmJ1yIpEaEzosc/FGELThiyFFr
	zKlm52eFf/c2IwcNU0TbnYpTGB40Y9JU5VHLWMkd5jRy0Em8QKgCsf8okjDdqot443M6/UaxMDP
	gMw==
X-Google-Smtp-Source: AGHT+IE2e/YxsAd0hQUtNlW5it4ebVJhZ0hecml1WwILxzhgYwa7yj6o8Ej/0Eo+Wl+5FZnC9XXt0MuZGrI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea11:b0:201:dc7b:a8b5 with SMTP id
 d9443c01a7336-20203f552f3mr2554995ad.12.1723832721695; Fri, 16 Aug 2024
 11:25:21 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:25:20 -0700
In-Reply-To: <0000000000009ca899061bab0a49@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000009ca899061bab0a49@google.com>
Message-ID: <Zr-ZkD5wbcKhapom@google.com>
Subject: Re: [syzbot] [bcachefs?] [kvm?] general protection fault in
 detach_if_pending (3)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+f4b2fbba4d8c2e290380@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 24, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    626737a5791b Merge tag 'pinctrl-v6.10-2' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=117e90d6980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53ab35b556129242
> dashboard link: https://syzkaller.appspot.com/bug?extid=f4b2fbba4d8c2e290380
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-626737a5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/03802640516e/vmlinux-626737a5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/09b1b299316b/bzImage-626737a5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f4b2fbba4d8c2e290380@syzkaller.appspotmail.com

See https://lore.kernel.org/all/Zr-Ydj8FBpiqmY_c@google.com for an explanation.

#syz invalid

