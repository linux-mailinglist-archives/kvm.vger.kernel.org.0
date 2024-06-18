Return-Path: <kvm+bounces-19895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F0190DE9E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 194C3B214EB
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793C0178377;
	Tue, 18 Jun 2024 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BmLR0d9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DEE13DDD2
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 21:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718746916; cv=none; b=Cm/TsiEeVfH0MKGZC/BWkKhkfomiTPexTheT3grrw9LM6xYZbGf9nR7B7GMVVYehKkbCQDaF4dsh2suOjgWo3HyLpH0MYSJU4hYcw13G8LiJ+COndoeYrcHrtPGk3kJvOs8WKdN1fGWb6tdHoau0eCDv0wXnMIaKVIstXxUtBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718746916; c=relaxed/simple;
	bh=Z4NoFk0pvcBtF1cTs4h/UyGbIZZ9bdNUjS2nYIKsucM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ABcrblLKQxWvUmUSPIGaHuX5PIrDQeKkkr+8hSfBz1Q3WLwEsVCaQJCev7IKV+/p6KTm9t/IgP6geQnxK7VfdiymbOJePUd6sYTtc8TCp7pQNvHDPog28DRY6jSuDHCzP4aU/KYRftk/yUcS7SK61BI4VbAsEVf6MvcOtdwfx2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BmLR0d9x; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfe71fc2ab1so11613159276.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718746914; x=1719351714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H57cKGP3VXQlX2Eu4ZKS6ox1H4mc6PGOF+4+faMmX5Y=;
        b=BmLR0d9xhjg1iKJ4GNU1SdGSgFzSc3gwhn6gHJXm3PLwKzhLVGnkdRjZwAvmnxEoKm
         ayAYxtmhPk6TkTPD7jwL3CeghELhj/V03CdMToyhlR7GFVMePmQE1yYBI4JFo0cQBh0v
         +D4mgxCmTug2gXoGvndq47udnMjo3w1ZqKXhAi2aXxFAcMSMhsZPGtDrGAMXMi6XuSLg
         u5o09Nf4eIuQ+mv4ZQZpF22W55/n2E39QtU65tGI2fwnDu6e5v++bJHHcEnf8EWkF9Rn
         Xb/HGrg9McnJV4H0o3l9Y1E0ATuiPQxxUgU1WYespbPYOamKnvTYCX531VqOJQuFgzVo
         2Y2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718746914; x=1719351714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H57cKGP3VXQlX2Eu4ZKS6ox1H4mc6PGOF+4+faMmX5Y=;
        b=qW33iEU2yo30xivSJyN8bMt/TWOY/DYd5AlUPS4xwFYMZ2QByDLbbNLK8U7gGCpUQ5
         Tj0t2H92E/rJZXXKC+wnrQjSiL98R7l2vXfHcYRWHNJKmDyPr2bVldlb1pxQ6LElkCl2
         7j0/nhR1eXUkSNoQQ2e0/wRNyPH3PhuJQl9B74mQmidcILBbw0QfEy35DmGhUKXCgZ8b
         ThDkfM7TG4wEopzKUegI9RyTdTH6t8U1wILZ/8RHuki9EsLc73L0b47Fy/EGIWtHEGtX
         eTb1VsFNzHu6Bin4VSpbSzUeVL5f6nWA0pMGNJlt8LGmRIP8xqpU2fIaDlCRT4dAduAS
         DFng==
X-Gm-Message-State: AOJu0YzKHqnMJ4OpvVcDkCaMtT4zfk5C4CATuL6BrqgkVePcwa0sT0OH
	djFROd/eaJRxaocKbSrq2HO+GzqKmCjdcEu3VLB1eqzkHuhGqG+3a+VrdSCKMlgz9+/7qvn8MP4
	Q7w==
X-Google-Smtp-Source: AGHT+IGDoxqsI6ls/Ma7mzRFkq0CeBwekMyT5DeqBXha+adGVz4r1xs6XwxCU/JTIxhpG/6a4wC6+cFGLak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c1:b0:e02:b7b3:94c4 with SMTP id
 3f1490d57ef6-e02be16c8d8mr370990276.3.1718746914343; Tue, 18 Jun 2024
 14:41:54 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:41:26 -0700
In-Reply-To: <20240614202859.3597745-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240614202859.3597745-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <171874680480.1901529.15135385772186699569.b4-ty@google.com>
Subject: Re: [PATCH v3 0/5] KVM: Reject vCPU IDs above 2^32
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Jun 2024 22:28:54 +0200, Mathias Krause wrote:
> This small series evolved from a single vCPU ID limit check to
> multiple ones, including sanity checks among them and enhanced
> selftests.

Applied to kvm-x86 generic, with a few tweaks (emails incoming).  Thanks!

[1/5] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
      https://github.com/kvm-x86/linux/commit/8b8e57e5096e
[2/5] KVM: x86: Limit check IDs for KVM_SET_BOOT_CPU_ID
      https://github.com/kvm-x86/linux/commit/7c305d5118e6
[3/5] KVM: x86: Prevent excluding the BSP on setting max_vcpu_ids
      https://github.com/kvm-x86/linux/commit/d29bf2ca1404
[4/5] KVM: selftests: Test max vCPU IDs corner cases
      https://github.com/kvm-x86/linux/commit/4b451a57809c
[5/5] KVM: selftests: Test vCPU boot IDs above 2^32
      https://github.com/kvm-x86/linux/commit/438a496b9041

--
https://github.com/kvm-x86/linux/tree/next

