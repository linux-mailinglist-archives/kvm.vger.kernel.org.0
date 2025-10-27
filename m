Return-Path: <kvm+bounces-61174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D08C0E9BA
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 15:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D23D461D01
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 14:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EE0309DDB;
	Mon, 27 Oct 2025 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TyqW9+SW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8924E23BCEE
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761576112; cv=none; b=FJwBjol6GO1sOpGMecdY3s/sJyOeIrRGu/TYKHh/JI5TXMEWy+vlLH7421Wthobvmt/Uo/rGs9x125Z12b+ccPjyCuf72iO9jgqYhAsD25gXdTad2qJYWdPilpncqETIzeQX4qFM4MheKA7G1tgPnkjZ+hFesee0iWokqYF/lLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761576112; c=relaxed/simple;
	bh=KRdQQb0wh8/jMWv0NcvlejBbk/5bLAuv3/1ZcY/hGSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mC4oNBDJoBC2ZEXdrHAbi1fHM0IN1jCvq6qTchmdUk6UYuyEIEBVPB6VEq3Ce9Av9NXZs1oYWlmIlikvgLCpztTt/bHI408H6aRGs4C6tPgxxR4fHzyaDLmp5GqM6ZbHfE+ba2QHqbU5yiqC7dgA4MMff2tLvXv2Ny95Z529tDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TyqW9+SW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bcb779733so4108785a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761576110; x=1762180910; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6fO12TJOmOefM7qypSUNCCkqj7DD82ALlBIv/0Bx+So=;
        b=TyqW9+SW5i8QjfxNRkNrtk/nOOlL0byXgYGNwVKgpj5hAUradfZ4BFwKBjsIqA4/Eg
         R550Av/6YLCl5DgJXyvLM6G03nkXGLZaOjLSkri7cEGQbWZ99YDfunt4mrn6q4btzCxs
         HbOg2OqgUCSU0O9VuPylccwJuZSTadDPPlMBvwgEj+nEh6P4VZzdSdoxnC37bAIK6dqm
         w2HTqJxjVOpqIxkXHXO2novW+UU3TVaMQ8fdu9aGhYMXN+redrvDEwIKuUvmmp4jN52A
         uHiQDh9otqHPz3GZ1YCU/58XOU8f+acOVnNB5Gxog6h5Zld9m0ejIcHl2LHA8a9YKomy
         NGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761576110; x=1762180910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fO12TJOmOefM7qypSUNCCkqj7DD82ALlBIv/0Bx+So=;
        b=jX2ENHWHlHRHZxZfTlxztR9l92fKWcIgcc7Hc2YNOveXKBrLrjEp6qfQ59f9SZUS9p
         iQCrVHLTaeLrt9lAP+cPfe8Ef4H3GUdTxcIKEvj6Gtz+TUuCkO1Oa04YZxixeXZCArVM
         agWMirBka3mDWmXEEKpW5291hDjZrvGsBeP1uoUgWMZa74y3soJtVFjSasGXl9U+fXfu
         ArsTs+omY6GYeY880TOkjIhfT1F0LGE0F7UAqVSPD4u1CKnIiM2Fs8I4Es6KaKmjmblK
         85b3FYa54PRi4pLKqJLXbzHK5dLxdMuJRxhmi45YD2nvxXZwMv6qqD6St2QurW1byuj5
         Yg2A==
X-Forwarded-Encrypted: i=1; AJvYcCVU51wxDEKZy/aI7zkLVFdqrdQ+Y8vxF3nclBactI/fYY3mpUo6gkGI2D+rqJeNH2i4MaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRmngxMk4SxMcmz7e7lc0Yy9JympRQdyfD9is3CNToPDz9eorg
	v8zgVfrI0x/oqrI1x4yQi/rgPBZ4XQRJLpLqNV2eBw3ECnrMX7J6g3Nm+W8jXi3p62SB5zo/6oF
	kllXi3w==
X-Google-Smtp-Source: AGHT+IH+UwqXdEYCE1CocvyH9lqBSvO8TdLxvBs8Mxx9vAQZb1++QLKCMGGhKByvzH6gbci2kJYM9jTLdWI=
X-Received: from pjob8.prod.google.com ([2002:a17:90a:8c88:b0:33b:51fe:1a7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3806:b0:32b:6820:6509
 with SMTP id 98e67ed59e1d1-34027a0741emr78274a91.9.1761576109905; Mon, 27 Oct
 2025 07:41:49 -0700 (PDT)
Date: Mon, 27 Oct 2025 07:41:47 -0700
In-Reply-To: <20251025015852.8771-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <68fb1966.050a0220.346f24.0093.GAE@google.com> <20251025015852.8771-1-hdanton@sina.com>
Message-ID: <aP-Eq4NFAhIscvIf@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
From: Sean Christopherson <seanjc@google.com>
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tabba@google.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sat, Oct 25, 2025, Hillf Danton wrote:
> On Thu, Oct 23, 2025, syzbot wrote:
> > syzbot has bisected this issue to:
> > 
> > commit d1e54dd08f163a9021433020d16a8f8f70ddc41c
> > Author: Fuad Tabba <tabba@google.com>
> > Date:   Tue Jul 29 22:54:40 2025 +0000
> > 
> >     KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a663cd980000
> > start commit:   43e9ad0c55a3 Merge tag 'scsi-fixes' of git://git.kernel.or..
> > git tree:       upstream
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=11a663cd980000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16a663cd980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=67b63a24f3c26fca
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173ecd2f980000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14bc2be2580000
> 
> Test Sean's fix.
> 
> #syz test linux-next master 

Oh, nice.  Thanks Hillf!

