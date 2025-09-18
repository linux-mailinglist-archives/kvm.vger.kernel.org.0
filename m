Return-Path: <kvm+bounces-58017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22663B856E3
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 298491C235C9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355F930CB58;
	Thu, 18 Sep 2025 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xpv9dlsy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7D530CB27
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207680; cv=none; b=Mac+OoNEjMsmfE3zsCFAlYEqY4gS1KqOnXcqbmcM1jyf3MO6H74obGUroNttf9hxSg8wqtRooJge+FfLDOljZiSKTG1Gbl72YCuZvEnpdxu1eVVCsXcuvJw/SFV2aes61HwVAU8N/jAqzlPVmNhiyhGWUBRlLm0ev6yr88MJaA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207680; c=relaxed/simple;
	bh=hm0HQnFHDuepzpar3SZ/hafXRi94TxogLGocQLL+sSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MGMGCBUzREbM23YPTeTO9i/6wrYKpXSdCkKkAuHKdizIlwjt4FZSa1F2yeLduRW9LPIYh3uGMRsGNGQkWhlyzD3dl69VQipgu4ccTdzMnFqH3ayZpG4pJj3zPuEqBZTOI81rgHzJYQX+W1aO9MGPXuDUDHDRQOFA13Dm5D7Jwas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xpv9dlsy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-265e92cc3aeso11668105ad.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 08:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758207676; x=1758812476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jaAVY6WwUqvQw+1OWwzrgyRuZwO/IzJmVcJETm6qRc=;
        b=Xpv9dlsyarNgBCNc5vklsSRf2570IBW2zqcBCUNUTJ2NYOWOx8GJtwF49gZyn5xlxb
         PiSdI67i+MUYY2XvxAWl17uOX6DmK0hka7gpbAjmt1ZT0sCvyDjbFwr7k0GCggAzLQpl
         /zw6G7E61p6UcOFwnoW2A+0uGqDAcEonCSB7K9GTSoTRdXhfbo8lcpkOAbyBRZFV4iXV
         twhoqGu3jP0sTZX+ia5M3nmOvtE1B2OfvYLu/ntco9YnrMeTZm94ISvwMG8AcJrNloKb
         zUZqMHta6bGFgXyGEwop7BpeKm+dqBiDGD3sLZ2sDj9fjtZoRlyFSUzQV6N9PyGZNc3N
         o1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758207676; x=1758812476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jaAVY6WwUqvQw+1OWwzrgyRuZwO/IzJmVcJETm6qRc=;
        b=DuOAMJ07BnbD4bURwlBczwkhRG0PDgL0Q4hCrJZbBAgoZpE/xBjCp9EUJa7cD1Xxi3
         mT0bx8A77kVeLJgpjSsm3q64LMJ9Q9acZw7h5UxKAtFmCKLnWr1iASqMc5inzsleqYSo
         cJWg3iVtcLmMrV4JeI+ALHiFroSibzBfgAemf5aI7RL7jmxJcr7jqKC8xm4De2DVKbvQ
         PUbJVl32Hl+9gDkYFcgd+QPorK5TPLC5V3cEwDHX+IET+Oo6Qf2hMEhogb5LpMxy/FVM
         lUS1qyYyTIpR9J0+vHeEURBJ2nIZ3t02aK5pfO02wP25QslZtvZ5QT3ZqBFmdpRavOi1
         7zkA==
X-Forwarded-Encrypted: i=1; AJvYcCVtuL9jBwJsrGjlwJB9MEGOTKTWYmECqNi4wFYBcdN+kHzujVeXH9O3NRyhYBPRTOuZ64s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9opGGNu3p1xB6w8TdKCpvyEj2B9TZqw3ZV3aAf/eY4huOMiCG
	JVZmO2lFxObfLgTxeZp+gEMDtowpI8X8kjU3rbxkY1jMESw1FrrTZ2PyfWhKsmtwR2ooByzWhnd
	r8LsFqA==
X-Google-Smtp-Source: AGHT+IFfK0oDh2ycr/Osr/E7Cn/yD1up1u2d31r7i+s3sYnsD2rX8bDF3WlsXIrIGTtuwXqE52kl8QvwPX0=
X-Received: from pjs1.prod.google.com ([2002:a17:90a:c01:b0:32e:ca6a:7ca9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da81:b0:269:a23e:9fd7
 with SMTP id d9443c01a7336-269a23ea2c9mr19135195ad.26.1758207676208; Thu, 18
 Sep 2025 08:01:16 -0700 (PDT)
Date: Thu, 18 Sep 2025 08:01:14 -0700
In-Reply-To: <20250918104144-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918104144-mutt-send-email-mst@kernel.org>
Message-ID: <aMweun6GrCSn3lDD@google.com>
Subject: Re: [GIT PULL] virtio,vhost: last minute fixes
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com, ashwini@wisig.com, 
	filip.hejsek@gmail.com, hi@alyssa.is, leiyang@redhat.com, maxbr@linux.ibm.com, 
	stable@vger.kernel.org, zhangjiao2@cmss.chinamobile.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Michael S. Tsirkin wrote:
> The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:
> 
>   Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 549db78d951726646ae9468e86c92cbd1fe73595:
> 
>   virtio_config: clarify output parameters (2025-09-16 05:37:03 -0400)
> 
> ----------------------------------------------------------------
> virtio,vhost: last minute fixes
> 
> More small fixes. Most notably this reverts a virtio console
> change since we made it without considering compatibility
> sufficiently.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Alok Tiwari (1):
>       vhost-scsi: fix argument order in tport allocation error message
> 
> Alyssa Ross (1):
>       virtio_config: clarify output parameters
> 
> Ashwini Sahu (1):
>       uapi: vduse: fix typo in comment
> 
> Michael S. Tsirkin (1):
>       Revert "virtio_console: fix order of fields cols and rows"
> 
> Sean Christopherson (3):
>       vhost_task: Don't wake KVM x86's recovery thread if vhost task was killed

Gah!  I was too slow.  syzkaller found an issue with this patch.  I _think_ I
know what's going.  If my analysis is correct (wasn't able to repro the issue,
but found a bug through inspection), then I don't think we want to take this for
6.17 as-is.

https://lore.kernel.org/all/aMwdsFGkM-tMjHwc@google.com

>       vhost_task: Allow caller to omit handle_sigkill() callback
>       KVM: x86/mmu: Don't register a sigkill callback for NX hugepage recovery tasks
> 
> zhang jiao (1):
>       vhost: vringh: Modify the return value check
> 
>  arch/x86/kvm/mmu/mmu.c           |  7 +-----
>  drivers/char/virtio_console.c    |  2 +-
>  drivers/vhost/scsi.c             |  2 +-
>  drivers/vhost/vhost.c            |  2 +-
>  drivers/vhost/vringh.c           |  7 +++---
>  include/linux/sched/vhost_task.h |  1 +
>  include/linux/virtio_config.h    | 11 ++++----
>  include/uapi/linux/vduse.h       |  2 +-
>  kernel/vhost_task.c              | 54 ++++++++++++++++++++++++++++++++++++----
>  9 files changed, 65 insertions(+), 23 deletions(-)
> 

