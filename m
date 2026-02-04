Return-Path: <kvm+bounces-70271-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2EhAHB68g2kgtwMAu9opvQ
	(envelope-from <kvm+bounces-70271-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 22:37:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC65CECC53
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 22:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D1093015C83
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 21:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D797A395D82;
	Wed,  4 Feb 2026 21:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wwODQMWO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033AE2F1FC9
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 21:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770241039; cv=none; b=FNI/XpWHFTj6/anxdhDnkJbLm16mSG+m9ZFXn1gyqJqURWLHNsw39tIuP0WYUADa5hNLsd4KGTD7vGcFSM/KvL/aR5s6/fqcJFdKesxsWqaS+qZLJ/AMlqzabpEpxyKfi37osUFVYQBDEwdDdmColTRHY8kNeQDEfywloLAvqeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770241039; c=relaxed/simple;
	bh=NoQk+WUwevTmhgi2vLUcHu/2l3Wad6kBnJ/+pThVYNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c5wnya9NIBEh3q2dFPiCDYw3UlewYNj7mACAFGF5UqRf9R0LQRacEccYA+f+cdC7R2hOqgvDm+iukVMH90NFJsWc7JmbxUMKweRL6hGGG660G/N0XE/uBXgGRwSk4CXl8tSCHY0T+W/ZnzNk5Z1ZYGs/b84UtIlr29byGwLWsOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wwODQMWO; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f3c36dd2cso189609b3a.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 13:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770241038; x=1770845838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x42FsSrubrOBY2TJXIwfVaWLWCG2JiMLbWyLTkA5Cdk=;
        b=wwODQMWOJyHLU0oMBLB7/qchJ48TawLkFUuFlL+ffBJO3jmzMQ2vTw4TOI+S/3bN0p
         SQXsEe2D7D4KlngslqJvcNVchlXRWoJ5RkslHuquuJJHn1ggrBGTcLegSe1nEoHUUSA4
         3RKZMiY1RrDMDwe2c7HwjkMGFapQYkOQ9+0ryvPzcb2I7mNLUH0kHkPxAXKX2ZCRyfrA
         TAHaxoxy3u8IuzAUMtyUSIc08G9PUCh5fQVmv4GIER8oWaLJaujZxrGbBnuOKKzv2Ka8
         m08liX1GyYIvWfdRSVgL+ER75qk956k8Lim5nFc3asopAsrubXscWrhbEG8DutvbxtyQ
         VD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770241038; x=1770845838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x42FsSrubrOBY2TJXIwfVaWLWCG2JiMLbWyLTkA5Cdk=;
        b=E1kNOnnf7qZznTbNqmpVrsRoEKSqX3a3FL1CLCRDhLlXM/ksl3wAXB5lzU1cEZzlG+
         sWKHbstSolSQHEb2fSH32ebw6Sl3/lVXhE6AR9M5cCrDtt6zziACsBcFC9PdCT3oseP5
         jwdjNWP6KS1dImE0tY4r9HudzLf/2cchMOoWQxPCQodvkAljSCAUqdu3YqlOzntq0fUF
         su5F/LfdRchr3M/JesKeJPS+iZ7D7aq+7LlFEM01ut2nRWN9i3JKOcv8nycuHQEXchtu
         Uv66KT2X85BYJhtT9EG0EdAdN/cYoByJw6KzavBwUjLkW0IBplSXnQR05sbo11xsjofX
         LjJA==
X-Forwarded-Encrypted: i=1; AJvYcCVHmCULq22xwLJA6N2XZYgY5HfKDCcAdmr077l1Cnexub5kprzNKT90FkWv+zZiE+ITFgs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVSWuAWF6kgksEzRCf8RLsoBnqxmKv0qWDEMoswvTdNlGigfQM
	PDzepllnihKDPROp/oeCRRZCfYZelYXnEkL7VdQ/UlQYqQZ8wPQ8wK8fHKSO/JDp8lRwKXNtkrb
	6mHwbSA==
X-Received: from pfvx9.prod.google.com ([2002:a05:6a00:2709:b0:7b8:922c:725d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a90:b0:81f:852b:a925
 with SMTP id d2e1a72fcca58-8241c19da84mr4061956b3a.1.1770241038322; Wed, 04
 Feb 2026 13:37:18 -0800 (PST)
Date: Wed, 4 Feb 2026 13:37:16 -0800
In-Reply-To: <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com> <20260204170144.2904483-1-ackerleytng@google.com>
 <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
Message-ID: <aYO8DLCWw8FEQUAU@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, david@kernel.org, michael.roth@amd.com, 
	vannapurve@google.com, kartikey406@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70271-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,vger.kernel.org,redhat.com,googlegroups.com,kernel.org,amd.com,google.com,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CC65CECC53
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > #syz test: git://git.kernel.org/pub/scm/virt/kvm/kvm.git next
> >
> > guest_memfd VMAs don't need to be merged,

Why not?  There are benefits to merging VMAs that have nothing to do with folios.
E.g. map 1GiB of guest_memfd with 512*512 4KiB VMAs, and then it becomes quite
desirable to merge all of those VMAs into one.

Creating _hugepages_ doesn't add value, but that's not the same things as merging
VMAs.

> > especially now, since guest_memfd only supports PAGE_SIZE folios.
> >
> > Set VM_DONTEXPAND on guest_memfd VMAs.
>
> Local tests and syzbot agree that this fixes the issue identified. :)
> 
> I would like to look into madvise(MADV_COLLAPSE) and uprobes triggering
> mapping/folio collapsing before submitting a full patch series.
> 
> David, Michael, Vishal, what do you think of the choice of setting
> VM_DONTEXPAND to disable khugepaged?

I'm not one of the above, but for me it feels very much like treating a symptom
and not fixing the underlying cause.

It seems like what KVM should do is not block one path that triggers hugepage
processing, but instead flat out disallow creating hugepages.  Unfortunately,
AFAICT, there's no existing way to prevent madvise() from clearing VM_NOHUGEPAGE,
so we can't simply force that flag.

I'd prefer not to special case guest_memfd, a la devdax, but I also want to address
this head-on, not by removing a tangentially related trigger.

> + For 4K guest_memfd, there's really nothing to expand
> + For THP and HugeTLB guest_memfd (future), we actually don't want
> expansion of the VMAs.
> 
> IIUC setting VM_DONTEXPAND doesn't affect mremap() as long as the
> remapping does not involve expansion.
> 
> > In addition, this disables khugepaged from operating on guest_memfd folios,
> > which may result in unintended merging of guest_memfd folios.
> >
> > Change-Id: I5867edcb66b075b54b25260afd22a198aee76df1
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > ---
> >  virt/kvm/guest_memfd.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index fdaea3422c30..3d4ac461c28b 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -480,6 +480,12 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> >  		return -EINVAL;
> >  	}
> >
> > +	/*
> > +	 * Disable VMA merging - guest_memfd VMAs should be
> > +	 * static. This also stops khugepaged from operating on
> > +	 * guest_memfd VMAs and folios.
> > +	 */
> > +	vm_flags_set(vma, VM_DONTEXPAND);
> >  	vma->vm_ops = &kvm_gmem_vm_ops;
> >
> >  	return 0;
> > --
> > 2.53.0.rc2.204.g2597b5adb4-goog

