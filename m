Return-Path: <kvm+bounces-15032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF70C8A8F4B
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BBA51C20C78
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6D285948;
	Wed, 17 Apr 2024 23:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x0f/ks3m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162B7FC1F
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713396550; cv=none; b=C/U17MzkgedkluSYDo+yUKlZUz+uqEBIYOGe74jkiIYl2w4rv+Wgpk1gVV/QRR9QfnuSc0LOg/GNjMcif1VvEPOrCFRP7bHb+CCeK4RUpYVt016xFm9jt7PDMRodzB7MhgtjJDSKBI3jiioK03//iTaB9atS9n+HRM0tWw3iXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713396550; c=relaxed/simple;
	bh=LX9GhrK8Jbn3n8Vd940hglekIEDK8T0qyHz2sDku1HU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oYC366gZ3MEkslnm98sWqMxN5eclgaifbo4VQtGZvm+1x/jcDLnns+55dRmCanvuoOzTvfNq00OTHo3PD89Py33kzWbq+W5VmxbkP6KbeuAmqArJbXJ97VwaKoZsWNHiFpg1mIk7VBiIfKwicM84V7y0bsEa70E0aubc1hJlTRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x0f/ks3m; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cec8bc5c66so227373a12.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713396548; x=1714001348; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gj+DqDhXX4ajJtJBjEW0/t+40OLkodEwh01zH7CaUY=;
        b=x0f/ks3mNprswyWRX2b7trF79VvLrFtshVLiHAHDK5eQM8mzqz3wf/g2ZQawD3Oi3q
         HRBw/3xer8R/NOuhwl0FEbXIGT/1QD5ODSlt2CYvsbNMiJcqoN3tVSDJ6L+RAc39haR8
         rIl+77WAx0JjHq7qR+VAi4NTuQ0cFL6bUha2p9VcfoSsiMsc6/A/QkYpw+fXWG2lOuJG
         3eqcSkeunqyQ4uVtC8NWLt/vWmgG2hd8tgKNdbWSApTeA/xRzshcxWfRfj24N/GoEXNu
         w0U81YXO4q/TLWy3wwmT/EoyKuUp75WbOYB6FpXvrakRNCZBdUn5wG5UmkWs+v9fv1cs
         W9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713396548; x=1714001348;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7gj+DqDhXX4ajJtJBjEW0/t+40OLkodEwh01zH7CaUY=;
        b=EsUOzN/w9ZYFzGVam4R7s7DXF05elm3fna0pwhV95X7W1v5eLNoC+boz1atWnb1Xlt
         qf0CVc0nzDxyHKnPCj/B85RCJKFKPqNNE2smb+0JH9DAvo8vI9KcBoXrcxjNMt7KLppg
         3sj0vzUWFZH49ziBBdXfRGH9ZbzDZzyRW6j6QF9qON5AK17arcDubd2kMWsN2U5mv/Fs
         jPC22jiJgyWpo1Xc1y5tK9o2T25IxNVDNqV4j0I3VI/93Lto4Z8G2lVgH6RT5B29vHjm
         tANmpg6RjlSc5SsX707qycjE9XY0jFGbmDYNUNF9uyvYgB1UKl/dhTxWtIH4WA4ISKyl
         3L1w==
X-Gm-Message-State: AOJu0YxZesqAqi2TjDP6DeaSqiofFJv3OinxuyAHMg0duQjTi7Nr2SSA
	vCQAN9QqoQx6FZwZ4o3NJXzxGpMU18UGNox1sTIDzuEv5K7aNa7M1e/X/s/vo35D1/3qfNcklpl
	KYEi2uA==
X-Google-Smtp-Source: AGHT+IEriXW/wJ+5TvYYBSufHLuswGnfwPCfgWyXhfG1cnuEU/33QudGdazTa1oam3gNSbR7iVlCJVqP3ovb
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a63:9517:0:b0:5cf:bdfb:9a15 with SMTP id
 p23-20020a639517000000b005cfbdfb9a15mr33880pgd.12.1713396548291; Wed, 17 Apr
 2024 16:29:08 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Wed, 17 Apr 2024 23:29:04 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240417232906.3057638-1-mizhang@google.com>
Subject: [kvm-unit-tests PATCH v2 0/2] Fix testing failure in x86/msr
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Fixing failures in x86/msr for skylake on MSR_IA32_FLUSH_CMD. All code
suggested by Sean. Thanks for the help.

v1: https://lore.kernel.org/all/20240415172542.1830566-1-mizhang@google.com/


Mingwei Zhang (2):
  x86: Add FEP support on read/write register instructions
  x86: msr: testing MSR_IA32_FLUSH_CMD reserved bits only in KVM
    emulation

 lib/x86/desc.h      | 30 ++++++++++++++++++++++++------
 lib/x86/processor.h | 18 ++++++++++++++----
 x86/msr.c           | 17 +++++++++++++++--
 3 files changed, 53 insertions(+), 12 deletions(-)


base-commit: 7b0147ea57dc29ba844f5b60393a0639e55e88af
-- 
2.44.0.683.g7961c838ac-goog


