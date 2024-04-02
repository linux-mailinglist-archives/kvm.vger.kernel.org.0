Return-Path: <kvm+bounces-13391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C05895C3B
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 21:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E303B265E1
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 19:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0317015B56F;
	Tue,  2 Apr 2024 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehPjJrKg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C046615B117
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712084891; cv=none; b=GcaOEXntdA6aBlFle8HDo2TOa5D16wG7pJyt1H8pt7MlMLxloWTedfyIJENi1dTUf08SXhrmD2VxA4BIxypK84sY0qt57fX5muGA5XP6Q4H2I+MFrw76QqARBtkdaq2yDxWWdnn3eUvFjTJe7tr8DR7fuOFXGcUjo/wdXcDtYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712084891; c=relaxed/simple;
	bh=q0U3BrQTcmK4/NApXsgmm5ZbvAPqywRyG410alb5eUs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OG4wXRYeFN3fQrj/SugvAGMNlHp97+WnbzTwiU1zYKEIIsa9Cn1oh69dY3rpaA8PRu22iL0vr9Q/BijldKxXTPZoSoAmQjYp/pc9s6fkoaaMZobN4IKTp9otpzhQKzADryEobnBAvFc8/me0e7z97G6l+H1Dh2zT+i5SyGXn5QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ehPjJrKg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-29f96135606so5419498a91.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 12:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712084889; x=1712689689; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBguXSa71mOVZveD/4eI3aOqwJYoeyK+Gmcjy5Ld/Cc=;
        b=ehPjJrKgM6CUoUK9ZwN/e/ekspKpDz11LO5NcBmbdc8+jWRg9NGACTx67THfRsu1ZS
         AnLNSvf8BlPuU+i1AeOnYr3CD26sgs3q3Jncm7pqnn+p5NApJkSdDT+jstfx0noiGO7Q
         Hc8W3taNP+Vvfvzl8keXVSXknyb0mP/7833cneEl4OZjQvVuCZj8gjTGxgXpfLXvnJup
         tJkKk0qfktSljTPpReQwhbxiVf7wjtdykDcB1jONNgNJ8jWS+QJeKwK4xtBwBfEXB4PL
         BMuedWH11DlMOyI7QKipI3dx/bZa++AfDCHowHVGFryyB3oPY9Y1E+jp54fgQps8AnYm
         tYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712084889; x=1712689689;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBguXSa71mOVZveD/4eI3aOqwJYoeyK+Gmcjy5Ld/Cc=;
        b=Y9ZWm6JPsRzm3pZ07G6Y1uzVMW5zSnJxolRaOGM8gMGs4a0cR/i1kXIQvgGadVxekK
         GQu6KAEZBbkLYZYdFbLP468iSCfZvpCJhXXnSZgEbRV30PfkUnZgVfeAaHQ2i3Rs0XdH
         vKi+faTJzTGBcvwuJAYy2vCM3ArcEONoBjbZ7XFvclHsoWpH+KeJHmsKQtnHnP4IRHAU
         AGtSvejSYncevT0iqoL0KWllbs7ZGQwLWWaSuBjfN8O7GzIsZ4mbaYXtD8lhQYAtl8Vs
         c5CU3iYmm5VgkS7VrWs1Iq0ROLOUcTudXGgK9YEuQqq+L/kxXZUGM0Ano8ffLfUKynik
         uQ/g==
X-Gm-Message-State: AOJu0Yy7lFfVyam0YmGR9dmWRZ9JmKKpTTfXFA4/8kbWohgflDot+9rD
	v4KWBKcezbDKzqwGAiyyEH4Tk5ONGIjdFwM19064/YnSiAU0d9mBtcLeX668E6DR5qGNstjHqn3
	grg==
X-Google-Smtp-Source: AGHT+IEQasLO/8rjkCI1AmjiGTbp2M6ivNxIk+jHpPAiWjQ0bDl0QzaWOEuBpejUWampLt3y/sbPNv8xXDo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:528f:b0:29d:d935:72b0 with SMTP id
 w15-20020a17090a528f00b0029dd93572b0mr50724pjh.0.1712084888842; Tue, 02 Apr
 2024 12:08:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  2 Apr 2024 12:06:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240402190652.310373-1-seanjc@google.com>
Subject: [ANNOUNCE] KVM Microconference at LPC 2024
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, David Stevens <stevensd@chromium.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jim Mattson <jmattson@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Edgecombe@google.com, Rick P <rick.p.edgecombe@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wei Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, 
	Lai Jiangshan <jiangshan.ljs@antgroup.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"

We are planning on submitting a CFP to host a second annual KVM Microconference
at Linux Plumbers Conference 2024 (https://lpc.events/event/18).  To help make
our submission as strong as possible, please respond if you will likely attend,
and/or have a potential topic that you would like to include in the proposal.
The tentative submission is below.

Note!  This is extremely time sensitive, as the deadline for submitting is
April 4th (yeah, we completely missed the initial announcement).

Sorry for the super short notice. :-(

P.S. The Cc list is very ad hoc, please forward at will.

===================
KVM Microconference
===================

KVM (Kernel-based Virtual Machine) enables the use of hardware features to
improve the efficiency, performance, and security of virtual machines (VMs)
created and managed by userspace.  KVM was originally developed to accelerate
VMs running a traditional kernel and operating system, in a world where the
host kernel and userspace are part of the VM's trusted computing base (TCB).

KVM has long since expanded to cover a wide (and growing) array of use cases,
e.g. sandboxing untrusted workloads, deprivileging third party code, reducing
the TCB of security sensitive workloads, etc.  The expectations placed on KVM
have also matured accordingly, e.g. functionality that once was "good enough"
no longer meets the needs and demands of KVM users.

The KVM Microconference will focus on how to evolve KVM and adjacent subsystems
in order to satisfy new and upcoming requirements.  Of particular interest is
extending and enhancing guest_memfd, a guest-first memory API that was heavily
discussed at the 2023 KVM Microconference, and merged in v6.8.

Potential Topics:
   - Removing guest memory from the host kernel's direct map[1]
   - Mapping guest_memfd into host userspace[2]
   - Hugepage support for guest_memfd[3]
   - Eliminating "struct page" for guest_memfd
   - Passthrough/mediated PMU virtualization[4]
   - Pagetable-based Virtual Machine (PVM)[5]
   - Optimizing/hardening KVM usage of GUP[6][7]
   - Defining KVM requirements for hardware vendors
   - Utilizing "fault" injection to increase test coverage of edge cases

[1] https://lore.kernel.org/all/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
[2] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
[3] https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com
[4] https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
[5] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail.com
[6] https://lore.kernel.org/all/CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com
[7] https://lore.kernel.org/all/20240320005024.3216282-1-seanjc@google.com

