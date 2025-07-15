Return-Path: <kvm+bounces-52494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D380AB05A8D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 14:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2860C74327A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 12:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75B61E1A31;
	Tue, 15 Jul 2025 12:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMbDR23j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7DC1B3935
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752583666; cv=none; b=aBIhdnEvrKoSj1z9Uoq85HUrCA0q3koJcxdwX4SOwNzlsMbRwFvyb382JQPPomn2SBV8vKvots0XopUVgvZ65XEZDtfkX7+0f//xPBKPiEOPvV6FGOIoKDWIKDKflGQQVrkusNT4EAxw3T50pKTKxjKvhGOZm/9mw8M5dbfrZr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752583666; c=relaxed/simple;
	bh=KYR+8WGWnfv9Y8T8MKK6057v1ckaI5RFw4T5Nl9bG3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=avIAWIODOPDk1gl+/uWfYEYgk8p1R2khXeaL8GYQ5ywnflm+33V9GG2RdZje6J9ELHF5bDBFWaWWHn4cnA1qK1wTqf8aANNaX3SaVAK+LySUy9lYOq8n0kPrsbCjE4CBU3zg5k3e/X4XWPGGzbRE0yaDkBgIbswbx5IMRguOgT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMbDR23j; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-235e389599fso195545ad.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 05:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752583664; x=1753188464; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aj7ubsCPwZOZJpEqxVz8TbpdGSsesLgcauIRtiEwO7k=;
        b=JMbDR23jM9gRQzDKri6DOIbCBbeUvnUOrp3r3L3f0Vr9ooey0t7db+fi51HMqSEe9s
         h5822u3cmAH24gIvYS2UaMpp8aur8kbx3LEeRm/7O2ZXtvGR0i/dXwmgRqxRgO9vLZBX
         ONsOjYys71aALvNHVA09agqIn4+6nQHXaALyL+1PkM81KB2CJ+HH6RC4jDeFYd49EYV6
         mgrQ6q4irO5br/YdQRxeR/kEAiEM3jkDi/iF6yWcDku6iG7bEcTebvN+AUwU/KlR5LGR
         dcD5DEFEAfbp6QBrDtqzl/plYpjyo696KRvEOoB+U0STl0ceP37hfh9UVfMtzqHscmEC
         iqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752583664; x=1753188464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aj7ubsCPwZOZJpEqxVz8TbpdGSsesLgcauIRtiEwO7k=;
        b=owYb2Ognj2k68bu7HBl/5rF4c+tkFSq/Nih5uQZL/7LWt9K8Aj1bgjcIW6qWtx0TYg
         UeVfTzdoznHkx8SBjzV3LwZTfNyp/7KE+dO9ropiCZHNsXyHTHggxjOkVzZxpNl25znn
         NhEGPUs6JW35pxOKhZ93dpIL3OKgK6SaMDkldAms6Jr0/txjv1u0gRRzRhqnRvUICqsi
         CBsP5RnPMhU8Qo7/hMVnpqRSJjdA2Gpeb9dJI8nffE+HubpvVkCFVvQat0z2kAHKIkHb
         AM65RkKVjJrZD3zmOWcofo9AHgtpKWSSHKgtVKFmcpQMfJTOtxKBOVJ/VD2PHhkj7CwK
         BYXw==
X-Gm-Message-State: AOJu0YwiJ9jkK2hnYjiyCR9P7v+yfO34ocNJuuTCtvYu+nukPy3RGB1s
	rRHsBKWccclAi8b1Ft/h4dirTx97kcJ39oG9CIV418cPWbaiQzr6OtYc2Rhce+aD9zaM96Yix1j
	JKtxUdmcB9ocfce72Lnj4yf6B7vEEuw5Zfn7jNxOd
X-Gm-Gg: ASbGncv2LqPFzVUnoOQ8mFCGz9a9KANah3Y+O7mkLrAJipfP7XEbGGXN9iJGd1H63f5
	XW3gpI+X9ilJ0QmIdd9AvoBo+2Xow3cZ2EdFTrHqWsL275QtgCaOZa5qVyGCsse+FdoPLl9ZTL9
	KvqKYCVucEijjGAu3yenBcGIOE8XHMgUprwrCWyRsOya+G0H4+t1XULJgtcw9OEbCf0EA8quJMH
	ll/HPocJ7e3jbnAbKfq0mVMvZfih/OmxqsWQ9o=
X-Google-Smtp-Source: AGHT+IH6FhoFqjhts9hPrxy/0Fq8QGuoieFjS6j7sof9NlS1UqMiOBs9T+m5042HRhsk8TgMmcHFmjT0Kfqpm1cbk+Q=
X-Received: by 2002:a17:903:185:b0:234:9f02:e937 with SMTP id
 d9443c01a7336-23e1b55fab4mr2002615ad.25.1752583664056; Tue, 15 Jul 2025
 05:47:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com> <20250613005400.3694904-2-michael.roth@amd.com>
In-Reply-To: <20250613005400.3694904-2-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 15 Jul 2025 05:47:31 -0700
X-Gm-Features: Ac12FXzMu1OlGDkOTawp9sA6enrjnahYfgISzdZFft1Fez6ANKUKFtOIvoCuXnQ
Message-ID: <CAGtprH-vSjkNyQkdqjgnqkK7w0CM2CbewxTwq0XBOXkE8C1WvA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	ackerleytng@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 5:55=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> guest_memfd currently uses the folio uptodate flag to track:
>
>   1) whether or not a page had been cleared before initial usage
>   2) whether or not the architecture hooks have been issued to put the
>      page in a private state as defined by the architecture
>
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
>
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
>

I believe this patch doesn't need to depend on stage1/stage2 and can
be sent directly for review on kvm tip, is that right?

This update paired with zeroing modifications[1] will make uptodate
flag redundant for guest_memfd memory.

[1] https://lore.kernel.org/lkml/CAGtprH-+gPN8J_RaEit=3DM_ErHWTmFHeCipC6viT=
6PHhG3ELg6A@mail.gmail.com/

