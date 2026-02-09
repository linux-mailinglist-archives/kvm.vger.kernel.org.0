Return-Path: <kvm+bounces-70637-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBPFLMgoimmYHwAAu9opvQ
	(envelope-from <kvm+bounces-70637-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:34:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19ED01138FE
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F4E23032F7C
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 18:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0680637F754;
	Mon,  9 Feb 2026 18:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvfYpIdY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AxMarcK/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C3230E826
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770662042; cv=pass; b=Fnb+QY8+gjcN/VJvP0kzDiDHhsu3T58pwXGz1XlHr8zsaOFtbsfK/RAhkQdKnTmc0JJcOUBHzgdZbzdxP3tnzuOp8leoEkYvIfwEtVd950e8cIrkCqPgYacyoFspYa3S+FZtbeutKncSYJcIaEJh1EU2Vm9wCVArQm4z1dM9TYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770662042; c=relaxed/simple;
	bh=6Al7E60s7uaPQswD9KcuTQ6pbkO9q5vEL5EG1XVsbUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q6sYikMfyyBTdEuybSllhf4bIfFG75G/vdtW7wgA6QCb4csk1tXfX9ecwKDmv2tvH+e72LcyE3PkDLZOp64K5kCcyFtRb5YMupGgMIg6q4XUQadAJ0n5t5aYGUsZj8mZCa5BXU/SdTE58g1B/LCdh7lSafm36VcQ4yP9tjaieH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvfYpIdY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AxMarcK/; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770662041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79yed8r8il9Q5kxqAGkki6UulnTGzfH+FJRmQhLRwF0=;
	b=DvfYpIdYh+BlDPr6SXRYFEG9b5XkhbdD1joZqSH7yuRuS8VTHZFss8z/sdV2UFqmU3qBT9
	m3RPIXZVINJ6ozSbmu5ymtAvN2S0VNkXC3t/X1FCW4cA5ujmhRllNHCXZYKZwmzToH6C5L
	txQ5ASY4YiRAgIxfJ77/s/6zVmVcN4s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-y52ZlRqVMK6lHZR1Ifs6_Q-1; Mon, 09 Feb 2026 13:33:59 -0500
X-MC-Unique: y52ZlRqVMK6lHZR1Ifs6_Q-1
X-Mimecast-MFC-AGG-ID: y52ZlRqVMK6lHZR1Ifs6_Q_1770662038
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4362197d1easo29682f8f.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 10:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770662038; cv=none;
        d=google.com; s=arc-20240605;
        b=Aw27GtzJd7qCFh8dz/iYV0/ps5M2krPg+3z5sYDhayXfRau3BfH3YkOscr5boAv98q
         uVg3e3JHa/Z98Kuk48MlkMG5WAOJvkgNx3Z31prPSuKcoEgsbnuI7HOebIRhONJy+UmI
         qIZFXZb9ct8rHuc1ZBrnlFzJJt197ErNhJzuRh1x8QYJKovljMeBywAMKLBeNRRhyAy8
         oOikeNetbJOf2xrXkIxvTH3g9gno0V6O1KIZzDKpT6tS42QXrqMGDEshW/B8Kc23axip
         VFzhKBt7reTHtOZ5q0TJ/0MSKm3T4AK+xKp/uAqsBfGV3Qr/xEl64r9LmCSlDTxpEBGD
         1+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=79yed8r8il9Q5kxqAGkki6UulnTGzfH+FJRmQhLRwF0=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=dWwFnfxHNo9LDsjQh7iOEHy9IBmAhj44I6+uL8jXjVVgN80MgzXWzOgJfQ+YTU3U6a
         5kqhAlSuwnJt+/tJd9j9wcRHh7cJGsTMEIA2gBXd0nmdi1cJmpC1CaBiMctFJKCX9jaG
         0wmDkmd1EqfIXnSZsfpAjqP/GpBbZyEhuc6HDwSYW0CfrWZ6DJRSNZV07Ft310yawthT
         qPutn5SeDZSzSeFG8gl6tqd7Ut+vitt2avaEQffEYXYxKLVyXmP5igVaWJLW/JMQuHVX
         5tZu1RFf20d1Kx+eP5ns6hxnteaUhgAjUFuQzYc3K0Topc7nCjyeUBt10WoBG+PTM5eP
         kDAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770662038; x=1771266838; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79yed8r8il9Q5kxqAGkki6UulnTGzfH+FJRmQhLRwF0=;
        b=AxMarcK/Nj/zKhXByqT2Pgjz8ITShJudHDytw5/uOuQQav8pHj5EaEfkc6chorSV2o
         zOei0jEiqWt6VZ0dIprgCeXOHurGb3XeuCRi5EaxEccecrnyk67qhP6Atf/nZEm1LKNr
         mOnd8+dH8Irurqyet6+RTxoVO9FalN0hWZ05dErsQzpzqDgr1TRb1N9DmGkafhHjC2xQ
         6aggiG4wP5zxI4Nl49KHPXm0KPGHGdEvB7wTpT7WsyRME44zbNp+os+fpIV+U7NkZKTO
         4RuDhZuMmdzsuG/Aq9QdDEQBkpfmwIMqSIL+vuBwP2dIfcUEHyKfsf8RQxZxTXGyK1pr
         LiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770662038; x=1771266838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=79yed8r8il9Q5kxqAGkki6UulnTGzfH+FJRmQhLRwF0=;
        b=lt3vtc4CPOuU4U1HzGcvbdEuEJqX5hiwAcLviYlMMMAJ+0vYNHwBQBggDI2j+F4QPo
         UqH2Lpdlp9WluKFs9l4BTghwbQlFhvvWiXsJvqsmULEwAuu1uIvMnbFFo+Zq/EWrBZTO
         +F6khX/3bqJq48g+yvJd669UO5TFVABtU9paefQYUAsnGZhPGCeqOBTF70CS+afpDev+
         v2M+fbuXI/6pV5bqL6tl5g5hmbr3BAfwnaDqZmeVpwPkylk95RBaTYl32rLhJzqs2ecd
         aR6aulvyak8ylt5GwYEoNmr0POM7SiqKywGaFT4rdIWj5M3KmWidjbCqBPEL769Wy04R
         ah+A==
X-Gm-Message-State: AOJu0Yz+2DGITkw+OxlFsfM7sC8SvRJGPOFRSBPRb2GAEtYjTjC54f+0
	gBIzATV8lh0JsHgXYgdrPepi3kvuIiI11EmpLOu/SyheY4k/CYGAYzm0NlRZkuqeyRB212Zwc8T
	DW0M7RDTnU7PtwpIv1EOOYfuTr8Q2yVhh81NDxJ7/gNbXLn1iMF8XF+KLoe6qAVBn/nXaIvUI5+
	jWzHd9SMb8GderpMq/yW9Zj+B7GS3i
X-Gm-Gg: AZuq6aK7hL/pceWkPEGxPIbofMMXqEY8apEjyjYaGrA2SH+zHgm6pOl4aVO1yq4uq6W
	dLOyCCYx6IAZoHNoT6yRJYBqG3cZn4Svp+d+zjedEAOnXL33o7lmjPbC4KpNs/MLqdMVafUhhA/
	z07vonFLQlYJEeYx/sNrqARODhMV4Sb8nd+LdmUBTiz79g88jqXzQu2UzTp1DmbfnJ1q9XTJBWX
	qID2QDTzbMyAAPpbQU0JcJyjqxfFUkUKVWB6hH6cR4XLMp5wJy/tUc9wsUl/M6lELXiiw==
X-Received: by 2002:a05:6000:400c:b0:437:6dc8:c372 with SMTP id ffacd0b85a97d-4376dc8c459mr7526157f8f.38.1770662037871;
        Mon, 09 Feb 2026 10:33:57 -0800 (PST)
X-Received: by 2002:a05:6000:400c:b0:437:6dc8:c372 with SMTP id
 ffacd0b85a97d-4376dc8c459mr7526117f8f.38.1770662037372; Mon, 09 Feb 2026
 10:33:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-2-seanjc@google.com>
In-Reply-To: <20260207041011.913471-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 19:33:44 +0100
X-Gm-Features: AZwV_QiAAhfEG6u0adBy2F1e9tU2TBIyVUy4TDCuKR1wEgYSleFvcz-pfH4iU-o
Message-ID: <CABgObfbKEad11qb6OGLjnPp5aPVUXUmn7+yQUCvXT-dmDeRw2A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: APIC related changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70637-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 19ED01138FE
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> A variety of cleanups and minor fixes, mostly related to APIC and APICv.
>
> The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85=
eb:
>
>   Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-apic-6.20
>
> for you to fetch changes up to ac4f869c56301831a60706a84acbf13b4f0f9886:
>
>   KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty() (2026-=
01-14 06:01:03 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 APIC-ish changes for 6.20
>
>  - Fix a benign bug where KVM could use the wrong memslots (ignored SMM) =
when
>    creating a vCPU-specific mapping of guest memory.
>
>  - Clean up KVM's handling of marking mapped vCPU pages dirty.
>
>  - Drop a pile of *ancient* sanity checks hidden behind in KVM's unused
>    ASSERT() macro, most of which could be trivially triggered by the gues=
t
>    and/or user, and all of which were useless.
>
>  - Fold "struct dest_map" into its sole user, "struct rtc_status", to mak=
e it
>    more obvious what the weird parameter is used for, and to allow buryin=
g the
>    RTC shenanigans behind CONFIG_KVM_IOAPIC=3Dy.
>
>  - Bury all of ioapic.h and KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=
=3Dy.
>
>  - Add a regression test for recent APICv update fixes.
>
>  - Rework KVM's handling of VMCS updates while L2 is active to temporaril=
y
>    switch to vmcs01 instead of deferring the update until the next nested
>    VM-Exit.  The deferred updates approach directly contributed to severa=
l
>    bugs, was proving to be a maintenance burden due to the difficulty in
>    auditing the correctness of deferred updates, and was polluting
>    "struct nested_vmx" with a growing pile of booleans.
>
>  - Handle "hardware APIC ISR", a.k.a. SVI, updates in kvm_apic_update_api=
cv()
>    to consolidate the updates, and to co-locate SVI updates with the upda=
tes
>    for KVM's own cache of ISR information.
>
>  - Drop a dead function declaration.
>
> ----------------------------------------------------------------
> Binbin Wu (1):
>       KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty()
>
> Fred Griffoul (1):
>       KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages
>
> Sean Christopherson (21):
>       KVM: Use vCPU specific memslots in __kvm_vcpu_map()
>       KVM: x86: Mark vmcs12 pages as dirty if and only if they're mapped
>       KVM: nVMX: Precisely mark vAPIC and PID maps dirty when delivering =
nested PI
>       KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to vmx.c, and renam=
e
>       KVM: x86: Drop ASSERT()s on APIC/vCPU being non-NULL
>       KVM: x86: Drop guest/user-triggerable asserts on IRR/ISR vectors
>       KVM: x86: Drop ASSERT() on I/O APIC EOIs being only for LEVEL_to WA=
RN_ON_ONCE
>       KVM: x86: Drop guest-triggerable ASSERT()s on I/O APIC access align=
ment
>       KVM: x86: Drop MAX_NR_RESERVED_IOAPIC_PINS, use KVM_MAX_IRQ_ROUTES =
directly
>       KVM: x86: Add a wrapper to handle common case of IRQ delivery witho=
ut dest_map
>       KVM: x86: Fold "struct dest_map" into "struct rtc_status"
>       KVM: x86: Bury ioapic.h definitions behind CONFIG_KVM_IOAPIC
>       KVM: x86: Hide KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=3Dy
>       KVM: selftests: Add a test to verify APICv updates (while L2 is act=
ive)
>       KVM: nVMX: Switch to vmcs01 to update PML controls on-demand if L2 =
is active
>       KVM: nVMX: Switch to vmcs01 to update TPR threshold on-demand if L2=
 is active
>       KVM: nVMX: Switch to vmcs01 to update SVI on-demand if L2 is active
>       KVM: nVMX: Switch to vmcs01 to refresh APICv controls on-demand if =
L2 is active
>       KVM: nVMX: Switch to vmcs01 to update APIC page on-demand if L2 is =
active
>       KVM: nVMX: Switch to vmcs01 to set virtual APICv mode on-demand if =
L2 is active
>       KVM: x86: Update APICv ISR (a.k.a. SVI) as part of kvm_apic_update_=
apicv()
>
>  arch/x86/include/asm/kvm_host.h                    |   2 +
>  arch/x86/kvm/hyperv.c                              |   2 +-
>  arch/x86/kvm/ioapic.c                              |  43 +++---
>  arch/x86/kvm/ioapic.h                              |  38 ++---
>  arch/x86/kvm/irq.c                                 |   4 +-
>  arch/x86/kvm/lapic.c                               |  97 ++++++-------
>  arch/x86/kvm/lapic.h                               |  21 ++-
>  arch/x86/kvm/vmx/nested.c                          |  54 +------
>  arch/x86/kvm/vmx/nested.h                          |   1 -
>  arch/x86/kvm/vmx/vmx.c                             | 106 +++++++++-----
>  arch/x86/kvm/vmx/vmx.h                             |   9 --
>  arch/x86/kvm/x86.c                                 |  11 +-
>  arch/x86/kvm/xen.c                                 |   2 +-
>  include/linux/kvm_host.h                           |   9 +-
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  tools/testing/selftests/kvm/include/x86/apic.h     |   4 +
>  .../selftests/kvm/x86/vmx_apicv_updates_test.c     | 155 +++++++++++++++=
++++++
>  virt/kvm/kvm_main.c                                |   2 +-
>  18 files changed, 334 insertions(+), 227 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86/vmx_apicv_updates_tes=
t.c
>


