Return-Path: <kvm+bounces-3049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BE8800154
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E865928174A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1AE187F;
	Fri,  1 Dec 2023 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VhnFzZC1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C2AF2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:26 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5ca2e530041so28193027b3.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395785; x=1702000585; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=31js9qP/L46pgHFjemKc+qNJa9+LzUjP7nJw2eJvfNA=;
        b=VhnFzZC1vuQA9w+/ZoBMDiavFXdToIxJ+aHqESCMzVGuGrngV0aX0gu+yn2Gjldwj+
         sErCpZsJtRcmR3yw7J0QMgqTzuniNZXiNjpBSRMr1yvJGnYF5Qs7W9/ZrhXXWlVQtbFU
         +Odgfidd6kShpWW2SND1pbka7K+vyRKxcwy/EsZGqqR2fZhmEfky0JLS2JbviopR0g0u
         d8Cx2tKljaDLBiqDoCpvGrPT1PEM8Ag/WnRB9JCYLne+yTJfokub3uAkLWLLw09x9Dlo
         VJuLyxtPXWQ6CSsVf4uB69enNph++TO70IEJBneRNr9zd0TDNwTj4aSqk0axyC7qdo5A
         pYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395785; x=1702000585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31js9qP/L46pgHFjemKc+qNJa9+LzUjP7nJw2eJvfNA=;
        b=bcNgy+38QgKyNmbHfiXA527dZuRosDREVfHlnlaImfSVwLZjSAqjXAC/Atw8KHSFVE
         jfG4wHQDn3ESgK+t//tguZkII0KxXtvdMC3nPUiQR/vl2nT8wEKdLCHBWz5UZ+lWJbE0
         8Xvy7o7N1Bo6yUmSgZaDri8qIDtUGx1qOZb1wLQRW4ceCm1wmUFl5vzVFgT5exdjnlqE
         iMueCOnxZhtrwB3Cr2Js8h8KaXGjcSfH4Ww8ucsNfWFQ6A7+QcFs7L4zwnBrvRb/PC7a
         z1vYOvs65vKd8aTsHQhhD9jUkJ2udeiTQmGkYrVrQHeFeVWCnqJFWWolhq2qNVeThMo8
         vLvQ==
X-Gm-Message-State: AOJu0YyiSCTvrfASFt/J2Fmypf0wWfzBoxOI0QT2ZxMtNYvOrSTsHFfH
	scpLu3/A6KLqPAr0jVKOOX0aadGGDHs=
X-Google-Smtp-Source: AGHT+IEpsxjrpo5dTWYsiMfs2Wswpo7gotPD8xGYw/M6BtLdhSTmn9pvuQrwa7V44iHovIX+bRzNfIdxd54=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2fc1:b0:5d3:43cf:1727 with SMTP id
 ex1-20020a05690c2fc100b005d343cf1727mr130450ywb.5.1701395785385; Thu, 30 Nov
 2023 17:56:25 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:26 -0800
In-Reply-To: <20231018194104.1896415-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018194104.1896415-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137744449.663393.12077331618615208281.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: nSVM: TLB_CONTROL / FLUSHBYASID "fixes"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stefan Sterz <s.sterz@proxmox.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 12:41:02 -0700, Sean Christopherson wrote:
> Two "fixes" to play nice with running VMware Workstation on top of KVM,
> in quotes because patch 2 isn't really a fix.
> 
> Sean Christopherson (2):
>   Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested
>     VMCB"
>   KVM: nSVM: Advertise support for flush-by-ASID
> 
> [...]

Applied to kvm-x86 svm, with a comment as suggested by Maxim.

[1/2] Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
      https://github.com/kvm-x86/linux/commit/a484755ab252
[2/2] KVM: nSVM: Advertise support for flush-by-ASID
      https://github.com/kvm-x86/linux/commit/176bfc5b17fe

--
https://github.com/kvm-x86/linux/tree/next

