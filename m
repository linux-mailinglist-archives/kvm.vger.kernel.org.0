Return-Path: <kvm+bounces-41131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4969A624BF
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:40:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D02453B9C92
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFDD188734;
	Sat, 15 Mar 2025 02:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HXVJUm9K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513512E3381
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006414; cv=none; b=mZiDRRUr4OQO1an99wZ/1db6RCSz6PJf+b9HhpDb8G1iAfYIGr05Su2Rns4DDKqfwwb/1KR8X0wYRmDckjEd0bVxmiyzUAjGsFeuHwH82porlbbmdC0ueuEVkfHhgGQMQ0upQptPphZaHdVOfZvXalBzrASCoNXlNxRDazEkjFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006414; c=relaxed/simple;
	bh=F37DdpTElQ2q2g+ifpTPVUBGVrrJmQS6C1fk1ytOIFE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pHfQYkKhll7q0XteJnVEVChk8ig6XibL/okQ3ekjBuIWJx629Llm8XQd+XeS18V93WzUWVq/UGTEEVEZt9blfEDwZCjP1ZRZvuK6hUe0ay7ZfrtXG8maxbcuNc8+xqUsy8jDPOFvadqWLwmh89MB6KUQhOIadqbKDmz25kJRdmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HXVJUm9K; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3011bee1751so505037a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006412; x=1742611212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p243mb9oLjguco3vJ1B5SxoOuqk2mjKqrxWdDVESxQ4=;
        b=HXVJUm9KkAvPhhQoykv7Q0oH1PfW1B20eT+oQssC61A5Q7/O4zZ9OTzwgAY730jRCZ
         FNwhAViVIGb496cMb8fInJUKr5m+qHjcuxcgVmV6aWtg6v7cB+I7eNULzrW4JbkUGKvC
         MSDuH8rMkfGkvChsDuntpM1r5aoUqdKBh4QNbYJhYw7FcblBndA7xQNdNU3zqXkn922B
         jaUpQJ96XehwPv6bF6kjkYetXA8JJwluX8B91sYbyeRwHeCKBKbJtJkGh49VTblGosHE
         kOOKEmydDJ/St/qx+GLffdIWYaOo3cPVjai85ZJ1mBAPmvetP/EJrtkQOXOWyteQXsA/
         lXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006412; x=1742611212;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p243mb9oLjguco3vJ1B5SxoOuqk2mjKqrxWdDVESxQ4=;
        b=iWRG0S08L+ADNaK0SYkq2mzSeL93c5dUgDWsEVzxk39orwsTv/SupZ/5iUcBUxX5ES
         R2oZg2k0KauiV1O/rSO1OTo9us3XxBehD5BdDXsfT2UPB94xEeYoB6yFU4svvDLiYVn/
         17vCwZXfzDv9UJjchdCdYicSKi/jJuYY4Xj90FEq9BHHVGSpYfOh7EX6DOhX02djKIPh
         ZQptzM+mEmmr/pjmO+FCjiT6/HnF/Q4FBYzrTK91CeWTqzrDZmNfzUz7XozSnVYDS3Zi
         MudAK+f/Q/dOyey7QtxO7GIceKD3TN6GdHxQlz/NGShW13VfbIpM+F+F0RaZXclpctg0
         //1w==
X-Gm-Message-State: AOJu0YztpVDkwMn1Lf2tTIiKbqtBx6R5FisWHRN5aAD6ujFp91FMICam
	/25kseJcdE8vDOFgOfV8f5HeR2kFo+swTSAcvy82YPfGDV4T2NNijsl9cCbBASazALc/85aJ4Lp
	bzA==
X-Google-Smtp-Source: AGHT+IGl8oTkoFLkt/cHHZ+lGdj9KR0zQyx8nSi0QEJHT+P22WLdQdUmgVzr1J4zJ+0c36Ci2iOcUZvc+50=
X-Received: from pjbpt11.prod.google.com ([2002:a17:90b:3d0b:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5247:b0:2ee:a583:e616
 with SMTP id 98e67ed59e1d1-30151ce122fmr6575082a91.9.1742006412651; Fri, 14
 Mar 2025 19:40:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:40:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024010.2360884-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86: Dynamically allocate hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Allocate the hashed list of shadow pages dynamically (separate from
struct kvm), and on-demand.  The hashed list is 32KiB, i.e. absolutely
belongs in a separate allocation, and is worth skipping if KVM isn't
shadowing guest PTEs for the VM.

Sean Christopherson (3):
  KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
  KVM: x86: Allocate kvm_vmx/kvm_svm structures using kzalloc()
  KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list

 arch/x86/include/asm/kvm_host.h |  6 ++---
 arch/x86/kvm/mmu/mmu.c          | 48 +++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              |  5 +++-
 5 files changed, 52 insertions(+), 9 deletions(-)


base-commit: 7d2154117a02832ab3643fe2da4cdc9d2090dcb2
-- 
2.49.0.rc1.451.g8f38331e32-goog


