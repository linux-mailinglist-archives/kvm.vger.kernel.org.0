Return-Path: <kvm+bounces-11399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 224EF876D35
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1CCC281B3F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AC140851;
	Fri,  8 Mar 2024 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NxsyvlBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC30439ACA
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937431; cv=none; b=gVfNn8i+snLXojzLu1/C67qph5hTwzyTS5S7lbwH+1Q6M3R3atrwscm715WTYUj2Sq3+aK7mwnIiPZcy2oHpYSoghSJrK/nqcaet0qMaILr9M9kRbdhkufBSgp5Jw/I0zam1aYC6bCVoZLLstPAzU7xyGiN9Cu1/txVAoKk3qWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937431; c=relaxed/simple;
	bh=NS+bcTksJzt9UzoAJxYD5IzJnlLkkDM+4ngl1bKux40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Szj3u4ovF0wxgGtV5voYMCtZ0NpgnhvFienkLVqIecWLq2XgzJ4HPh7lTqKK8w0KgDSACjxSj24e8RTsQvhT83SZWfK+/BLox3uhpDFXRYuiqX+QmmZt0QwYylsLrl688Rgs8w1K4pgEJ9+D8dFNMcMrTeXmtEFpfy/j1WcDq48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NxsyvlBf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29bbd1b80c5so589053a91.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937429; x=1710542229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CSMEyvHVT5rcPZYiZTj2DM20CdI6zV4f8pTUQYVjXUE=;
        b=NxsyvlBfSWofJx738igoV6h2ZeDa2BGhzZq0ahuOfMiGGJRiXb2+NVZMbxqj22iWBc
         BBxTVa5WVn1tO1dd5vQf62ykNROzs528NMya0+1x2jnjxIk35g8zVR0M4fYaSHIf/2L0
         YdouPV477zW96O8QJtLdQQjm5Kl71YjUcvwje8ijy1eJO9PGu9FRJT7yorykQKqCQskq
         i6ouLGJuG4O07wNukwoNJG0IlE2awEVynkE6mz2XhhcKivjgwXdTPOHZYwJUqJwicMlY
         Vc0q2EbsuiF6e/GJXOPkQbJ/MLT9vV12wnyG+39Zo0U7juKt/oHQk0WnHSjEjaWLmvy/
         rE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937429; x=1710542229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSMEyvHVT5rcPZYiZTj2DM20CdI6zV4f8pTUQYVjXUE=;
        b=XnXYnur+dWqmStxOjyK8qoiFOLAWlGWY0ttEuOjGHk7perrWxt4CciUMYqFpZmL9D2
         uRO6yO5GfJwElDioMAJqqwdZAdFuNEaLihTE9Sc+4s+xYVSwEfPXNdJnC441Q9Sfd/Am
         eKd7lzKIPnyYaFPuwoZVT87KsPIaHwt0Iyo0yfKa9fhABUQO/2m6kXVJAnBcME+JyXDl
         F7FCtIhTxsQuC5DCAoTUzjFPSfbzy5+Ac7ilEV4z9AP2lDn+yd8SEWhecRZ1bGUvgWLo
         RKfCWY6jkZ+rASjKERPlKUoGVxwCpi2eje/q7okO1QdS8xCXXPfjfdLTJaQy1QC02yq6
         N1Jw==
X-Gm-Message-State: AOJu0YxZ4mMdTKQ1+/MQKtSXuV0sUiMjgxDgNU8MNDH9/VCDApB7zpkk
	zypaNvP4sg03BjAaSQjShiHCrekoTajRj1eEkgvPh0b/XkOVLJmqPIrXkciQFmMbyltazmgNFMS
	FJA==
X-Google-Smtp-Source: AGHT+IFoCdBvlBQVYbr0HIq4dKGpQ2BVqy5ajQ9B2Y1eMh5QxSgFYr2GQ8p8LTcvJRVFlz6U9eWkPyagZqo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f43:b0:29b:b5bc:b537 with SMTP id
 pj3-20020a17090b4f4300b0029bb5bcb537mr1821pjb.1.1709937429312; Fri, 08 Mar
 2024 14:37:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:36:54 -0800
In-Reply-To: <20240308223702.1350851-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Async #PF changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a long-standing bug in the async #PF code where KVM code could be left
running in a workqueue even after all *external* references to KVM-the-module
have been put, and a few minor cleanups on top.

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-asyncpf-6.9

for you to fetch changes up to c2744ed2230a92636f04cde48f2f7d8d3486e194:

  KVM: Nullify async #PF worker's "apf" pointer as soon as it might be freed (2024-02-06 11:04:58 -0800)

----------------------------------------------------------------
KVM async page fault changes for 6.9:

 - Always flush the async page fault workqueue when a work item is being
   removed, especially during vCPU destruction, to ensure that there are no
   workers running in KVM code when all references to KVM-the-module are gone,
   i.e. to prevent a use-after-free if kvm.ko is unloaded.

 - Grab a reference to the VM's mm_struct in the async #PF worker itself instead
   of gifting the worker a reference, e.g. so that there's no need to remember
   to *conditionally* clean up after the worker.

----------------------------------------------------------------
Sean Christopherson (4):
      KVM: Always flush async #PF workqueue when vCPU is being destroyed
      KVM: Put mm immediately after async #PF worker completes remote gup()
      KVM: Get reference to VM's address space in the async #PF worker
      KVM: Nullify async #PF worker's "apf" pointer as soon as it might be freed

 include/linux/kvm_host.h |  1 -
 virt/kvm/async_pf.c      | 73 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 49 insertions(+), 25 deletions(-)

