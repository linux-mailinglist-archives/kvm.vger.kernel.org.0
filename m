Return-Path: <kvm+bounces-42208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3D1A75067
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 19:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF4D17A2CC9
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367091E04B9;
	Fri, 28 Mar 2025 18:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZGnlSqx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EE818FDD2;
	Fri, 28 Mar 2025 18:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743186647; cv=none; b=G+5aGuVA0ua0rFE7vLkyUyUXJtYu0S8Lt7+v1b2jk5/xbpBACNnAzqE+TZyYGmrOA2x1lAl1msbeedc702DohSk9QpQWrvJlcotjAEcpPUmL2s7gQwe0YAHVoxJ9+rNM152pSPEGI0azbPI9BSrdx8zU7DlIzBksWEVtIkpr/5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743186647; c=relaxed/simple;
	bh=9XTj0tQhvYxAAdsXUfuCQwK5MFHkVzti01U9d2paLt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLvT7bkI7bVtNMSbjwFfKZS3jWRy8p5V8ueLF+EV/QIKRhL5ckINXS4W0+/wug2EnDNJBxNBw7WebuG8qZZYQMl2Ih6rFVP67U11my3iWCFn0cIW9iag5brhFWN4GIhflbHBRIWefcIZL8RqsOxOYXNDoy4mYuwW0onEqgr0C0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZGnlSqx; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54991d85f99so3666230e87.1;
        Fri, 28 Mar 2025 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743186644; x=1743791444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XTj0tQhvYxAAdsXUfuCQwK5MFHkVzti01U9d2paLt8=;
        b=FZGnlSqx9fxJ7lG+vP/t9H2Q5rd2IFZtPY6S2o8BYAr8fbItAVhtjNmFfHQYaF4fL4
         DU17thOjgteFW4cdz3+ab9HwkdXe6eSVCi+dQngNlOn6SUitCKUrFZiabph3yDB3o7Sp
         H+x3wksZm22CtBxO5uZL7VzNt2yOgpljzWFFMNwLzPmks4iA3H+nCDm/RASmF+B8uIwA
         gXKA8JlAbg5ltnaffFOgTMMCyPAAcg05CWNUUAWjE1qX59HaZ8wZ5+SE+PpAk4i/8uRc
         GMHUaEcE2eJi9rgF7Lx9Hz2Q7cKdU9B3BA/KSf+OqgLU1N/X77XleXbRa/6kKH/58O0z
         Z28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743186644; x=1743791444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9XTj0tQhvYxAAdsXUfuCQwK5MFHkVzti01U9d2paLt8=;
        b=LJcveduNp5ZTi06kuxEp6ka4vzTBThvbaut7TroGdU3JGLcrzDmsA/5/w6w7zAYAMx
         VLvUexPSB2i4Ncayv03WU92eZXNpk2QGU0q5cEfC1bkvTG5OWY7Z/VI+ZxnzWyI4Mki2
         8ymoMy8f0I5Tb2bv/8aUv2z4802+GfnfwEE8s91z+JBw0Cu5MRWHqNdvHINzUiWjzD3z
         qkEYo0R51eGPTV4DVr575vD7+zgCYYmjM9POBGBa0xMtE8/abIp/Va6Ncmak6N88/l0t
         6pomKCSFILoUyOVOfybhv0Thx5Z26np52LwwxwQjlLvotyBNDLGeU/nak8WpCTi3D8pq
         fk5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+r24HcnY8F36e9TZuwYPb4UrRTPLcTWIo3p1+OU1rDG4Gkqda+YLf6OCMKk8+3UM6Zot6KbZaVLVoy6xV@vger.kernel.org, AJvYcCVVwdVKyYdXpcYKSWrmTDL+a8dng/MvIDDYlanrM5HqWX/sccVLmgvz7ExZgpXSvZplce8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc171JCbnf7j+14vI7FtDLSW7JryKxmu+EGP4Nq2USt/C7qtlp
	uZNb2qHeBsVwM7ceRV6iUPElwJMa3RzvBYtz3JD2RnyrjQTtoSCVAsCg1eFdnm6J/KARpHDWCR0
	48pScrUX+cf0LC+IU29IKCbsopAQ=
X-Gm-Gg: ASbGnctnA/vwmgt61YUXRCtdk1tV/hbFJgvr8Am2nvBldNTBpk05V/O+a0YwVqSfJ10
	EEj9X+q/ANBiqelsmu3FdkF0LttrQKV2bWGH0kdQwmuuFGSzYpyKCwhH5tWRDuhTJ2MfTjRB7zr
	T/eWFLB8Krzhp/S5TMBnl3RfEXHTHA
X-Google-Smtp-Source: AGHT+IG8WMab1JJv4PwctVvswElQQEk3CtJtwWMH2HFu53xkAFaHVK4jcuKz2Yn1sEJZPelip91uB1EuozYZEwmDsi8=
X-Received: by 2002:a2e:bd84:0:b0:30b:c608:22bf with SMTP id
 38308e7fff4ca-30ddf7f737dmr2355461fa.9.1743186643528; Fri, 28 Mar 2025
 11:30:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <facda6e2-3655-4f2c-9013-ebb18d0e6972@gmail.com>
 <Z-HiqG_uk0-f6Ry1@google.com> <4eda127551d240b9e19c1eced16ad6f6ed5c2f80.camel@infradead.org>
 <CAF1ivSbVZVSibZq+=VaDrETP_hEurCyyftCCaDEMa5r7HAV67A@mail.gmail.com> <830d2e06c064e24bd143650ce97522c2bc470a90.camel@infradead.org>
In-Reply-To: <830d2e06c064e24bd143650ce97522c2bc470a90.camel@infradead.org>
From: Ming Lin <minggr@gmail.com>
Date: Fri, 28 Mar 2025 11:30:30 -0700
X-Gm-Features: AQ5f1Jq88iPNABeVpuLMSb4SzToojs9keJJVckPlXEcfU-dqZqC42wzY1lmPsJo
Message-ID: <CAF1ivSaEz0brSGfpv08oKnTjT=h99hs_G0ju0UGPwzoLvOSV8A@mail.gmail.com>
Subject: Re: pvclock time drifting backward
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025 at 1:10=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Wed, 2025-03-26 at 08:54 -0700, Ming Lin wrote:
> > I applied the patch series on top of 6.9 cleanly and tested it with my
> > debug tool patch.
> > But it seems the time drift still increased monotonically.
> >
> > Would you help take a look if the tool patch makes sense?
> > https://github.com/minggr/linux/commit/5284a211b6bdc9f9041b669539558a6a=
858e88d0
> >
> > The tool patch adds a KVM debugfs entry to trigger time calculations
> > and print the results.
> > See my first email for more detail.
>
> Your first message seemed to say that the problem occurred with live
> migration. This message says "the time drift still increased
> monotonically".

Yes, we discovered this issue in our production environment, where the time
inside the guest OS slowed down by more than 2 seconds. This problem
occurred both during live upgrades locally and live migrations remotely.
However, the issue is only noticeable after the guest OS has been
running for a long time, typically over 30 days.
Since 30 days is too long to wait, I wrote a debugfs tool to quickly reprod=
uce
the original issue, but now I'm not sure if the tool is working correctly.

>
> Trying to make sure I fully understand... the time drift between the
> host's CLOCK_MONOTONIC_RAW and the guest's kvmclock increases
> monotonically *but* the guest only observes the change when its
> master_kernel_ns/master_cycle_now are updated (e.g. on live migration)
> and its kvmclock is reset back to the host's CLOCK_MONOTONIC_RAW?

Yes, we are using the 5.4 kernel and have verified that the guest OS time
remains correct after live upgrades/migrations, as long as
master_kernel_ns / master_cycle_now are not updated
(i.e., if the old master_kernel_ns / master_cycle_now values are retained).

>
> Is this live migration from one VMM to another on the same host, so we
> don't have to worry about the accuracy of the TSC itself? The guest TSC
> remains consistent? And presumably your host does *have* a stable TSC,
> and the guest's test case really ought to be checking the
> PVCLOCK_TSC_STABLE_BIT to make sure of that?

The live migration is from one VMM to another on a remote host, and we
have also observed the same issue during live upgrades on the same host.

>
> If all the above assumptions/interpretations of mine are true, I still
> think it's expected that your clock will jump on live migration
> *unless* you also taught your VMM to use the new KVM_[GS]ET_CLOCK_GUEST
> ioctls which were added in my patch series, specifically to preserve
> the mathematical relationship between guest TSC and kvmclock across a
> migration.
>

We are planning to test the patches on a 6.9 kernel (where they can be
applied cleanly) and modify the live upgrade/migration code to use the new
KVM_[GS]ET_CLOCK_GUEST ioctls.

BTW, what is the plan for upstreaming these patches?

Thanks,
Ming

