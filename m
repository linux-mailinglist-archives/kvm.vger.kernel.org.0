Return-Path: <kvm+bounces-63784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B569DC725E3
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 637582AFBB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4B4223DEA;
	Thu, 20 Nov 2025 06:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Maiy6MNs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07772E62DA
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 06:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621328; cv=none; b=LQ9b2sMFs9uR1TE13706v0LKT/hDDwnhnQm1mqiIvTHwrTiiami17b33B+EFkZEteKeXYsgsO3nL7g4ofTZTrwh2SAjHYsDThaABIy6Uq6TDbjNDV0WVaBgRNFy3N51tXP5La0ZRNNzE6yVuA6ZIio2suE+5ahVeSUo/TRutenc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621328; c=relaxed/simple;
	bh=IYUvDTqfTunZlqyEbM3MxtUohL6jviff2LmIbZOlgr0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=l0WgsYql+ZBEaD4OIlH+W0bnRJOe7kDX1FsN7Mlo4zmqEtcRJvLsphr+mmwj/Rfr3tEx2wU+37Uurt81cWdf8Gb7UWha2L6Gz2b3/d8/RrC5n4Jta2rgsAk7br5/vnp2JHFv78DPQZylPVNQ5JC4+WM39WqvC0QD0c2HPRh+k8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Maiy6MNs; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-55982d04792so376321e0c.1
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 22:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763621324; x=1764226124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IYUvDTqfTunZlqyEbM3MxtUohL6jviff2LmIbZOlgr0=;
        b=Maiy6MNspPnPXrPrvrJL6j88/jSXoiPCfoDAghmlIwB4SbWlGKzVtYAb1n8ltuwiXZ
         b3qVIq7J+LmsbDT9tlPbWlbGEMzYdgGXAxd1b7FUS+Xga4jrIo7ScL976IqBE2SxIarJ
         PLd6CepYRzC5Gw53rXTtBxjrfc7BNu9WJDQStocGDzEOE788ZqSx+u16A1UWIvp91jtF
         4wOoIBaLfGZEc/bzjco4oFGyCAxbfGDtFNlLe40z66ofc+JO0Jz7kN+/PfSfR5+3h7Vi
         xXS/9FeSeFdTJExzEbqEOmrKYQ5gFrS0BSOAbLc1UZo5c3AMqdHvaQlWAk39FJDCesPL
         QQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763621324; x=1764226124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYUvDTqfTunZlqyEbM3MxtUohL6jviff2LmIbZOlgr0=;
        b=GjQ38cg0JQt2QbMilH7i5MObAvmmgNqxxve2+PrqtPefHmUjIdlUcpHwpPcYMNHHGP
         pyp9qP98lttB3MUTQ1GYfrZDezG8SYpB+sQ9bILnSDKgeHs31WiQan7Re4xGaEV+iva4
         +XXG6bgg1weri0z2Dg2YneyR41q/xM2RcSjCzfO3Z3QfsZAmWMUDCXuqShSQuBavJI0V
         nRrdZssP0ErmPF/5v/bO7NUlSRto+CxCB2cd9I35X2lHL9iO4cE+g131wDM/LTtvN3iZ
         RCN/osKGmbul/nl2BUCJsRpouYv9jEudqs5yBFEH0/WzjmxaMukz/02OLqMXoMmd5gIA
         XZTg==
X-Forwarded-Encrypted: i=1; AJvYcCWKTpFERdUvo7l6+9ExuvaQKf6Bu3hIWPrR/m4Y98chnZV+lXAZchIFDcF4ZdNnIWvOnGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvpkdA1iSh4ZWZg2BFLanvNVoo1G9X5cc/fkcTl4MR4UxpHg9f
	MGdzCpM8x1TKJDuK5JDMASJ0W1F3Rd8fjmWXjdhVSVYWZB8z8Mwa/bHK2mmKwjEARtqODohJUBs
	2DUUmqxeCKh5f+v4Frtls0+t6OsacQR3g1htc
X-Gm-Gg: ASbGnctSKqInbh/Y9skNGG4Hk3VQk1jadeo67KPI7Bc52Nmvb40RkXdb8oky0U0HsVB
	S7WvMxFBPzprgIhfLpMBlrP871YjPWGeLItFmThnAQfMelDPG8v4sGkQcAJiImZN0kRiUlzci/y
	41hTDSsQSpEk8ju4b6AxfgQQiz5QI3A86ZY4Z90IVVmELdjsIQmyrKSkxJCvDKwLllS64dr6Sfk
	9cyTfmZgaafYOf42aE+GK2cUhMJKp+KRlUv1fnIOO4NSA4Hu41MgGYmeQ+GWms9bEoPuSBPi16C
	Fa72VgHbq6elETU+JPXxRuQ=
X-Google-Smtp-Source: AGHT+IFvdbvEy7YTWQ8I395mWk9vY5BEaFxOynP2NYPXxmWj4wDHtQV0ODSg4gJsSzuVn9Ph6VS1QPGynH7+zQXNYj8=
X-Received: by 2002:a05:6122:320e:b0:544:7d55:78d6 with SMTP id
 71dfb90a1353d-55b80a08953mr464222e0c.2.1763621324215; Wed, 19 Nov 2025
 22:48:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xianying Wang <wangxianying546@gmail.com>
Date: Thu, 20 Nov 2025 14:48:33 +0800
X-Gm-Features: AWmQ_blUwv8bWn2oMo87ZO_TGXjkfng8UUG0dLZcPetMzDegpY_i1puF75bXckU
Message-ID: <CAOU40uD=Ry0iOj-0X8DQeEz3avvk=a0k+zb5upGhYRfd3FhSKQ@mail.gmail.com>
Subject: BUG: soft lockup in smp_call_function
To: pbonzini@redhat.com
Cc: vkuznets@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I hit a repeatable soft lockup in csd_lock_wait() via
smp_call_function_many_cond() while running a KVM guest with a
syzkaller workload. This soft lockup can be triggered by running the
attached C reproducer inside a KVM guest for some time. The reproducer
just loops perf_event_open() + ioctl(PERF_EVENT_IOC_REFRESH) +
socket(AF_INET6, ...) in a child process, while normal userspace
(systemd/journald) is running.This may be a soft lockup caused by an
incomplete cross-CPU TLB flush (smp_call_function_many_cond /
csd_lock_wait). The lockup occurs in csd_lock_wait() in kernel/smp.c
(inlined into smp_call_function_many_cond()), with the upper call
chain being flush_tlb_mm_range() =E2=86=92 kvm_flush_tlb_multi(), triggered=
 by
an ext4 fsync().

Since this is a KVM guest and syzkaller typically does a lot of
stressing, it looks like a possible race between kvm_flush_tlb_multi()
and CPU state (e.g. CPU hotplug / vCPU offlining or an incorrect
cpumask) in the paravirt TLB shootdown path, where one target CPU
never processes the IPI.

This can be reproduced on:

HEAD commit:

e5f0a698b34ed76002dc5cff3804a61c80233a7a

6fab32bb6508abbb8b7b1c5498e44f0c32320ed5

report: https://pastebin.com/raw/Lu4Tz2SH

console output :https://pastebin.com/raw/BxtNEXnq

console output v6.17.0:https://pastebin.com/raw/PBytK7Wq

kernel config : https://pastebin.com/raw/1grwrT16

C reproducer :https://pastebin.com/raw/ySCpMzk2

Let me know if you need more details or testing.

Best regards,

Xianying

