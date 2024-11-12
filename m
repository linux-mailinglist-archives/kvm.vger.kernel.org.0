Return-Path: <kvm+bounces-31663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2AB9C629C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F3B3BA7E64
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5997921D201;
	Tue, 12 Nov 2024 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuP78g1T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E0E21CF96
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440036; cv=none; b=WAej30yvIeCuQdlYUBI9ovTCLRuGUqSdcqM4Zzc08PcM9ShiAKXy1BE9uaYBc32QUYq0mplRjv3kKVl3Eirn2KUvxuLa42v8ivntsHiC+9vQwpelswcNY3u/brdz0syxoxgK/GS4Ir2Z0onO6GNP3R+JRbVXYRH4Mfwm3/RZXRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440036; c=relaxed/simple;
	bh=U4kjLXs5feUwIsYm/dbJcwF5AbJY5EfMM09u8LD3BjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sN4k2MSzQWydwN62Wzti4ip2VUWthph0ROIg86WCeEyJBarOcKQ3xRrF2rTtmMvHTwWcSHKqvnHOqQN7z7NPjblMyRYVgNFUnNMCHQkdMQnzh9pXgos8ae7wQbBnVM/F+s3Nsg6E9Tjbd8gv/bFterrnN9MfDiIoaQM4egaDa+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IuP78g1T; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so6490678a12.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 11:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731440034; x=1732044834; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ama/c9MAT1Nu0t89U45e95kT7yr3qHGy1b779jacUe8=;
        b=IuP78g1TX95IWCQq1U07TtFqq57j5HYpoKKnEAcJgx1Jt7S/U6DmzteFBr9xeS2y4t
         q7tl7zaUMcEnrafbygbXtVBkN2FU1OLKL4L+PCrsxkxHGaMXuzPRH5JgSP28EgjQQpjX
         9r5zM4R5pTFP4SjegxKCFBE+Yyd0zlZQcfSE8rjqoIhPs3FbsBLDJf4MR2OsaeaVd0P/
         NvCRGzZC2+UjSyVRpZL0V0F3qwcptKgKuvqKMPDaTuAvme6ZJLsBWu6SOwEKV1HPULG7
         iz7LmbBB22/AogQcNDdRGW2NWk9bRDuTWaCW6dr8JBwJDfwtUm6kl9T3pXT+0t8FgPUh
         xkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440034; x=1732044834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ama/c9MAT1Nu0t89U45e95kT7yr3qHGy1b779jacUe8=;
        b=PBnjfmsaLRWo4fTXc2Tsfc4u6/OQzFeTUhmzrXbdURMPbIu5Hj8Djf8HrFvEuFWJ7Q
         1D6bdXAIrlym6EdUaEDsGBX1UWOSgYZ83Zv84I2xHml0jUAj+9fcpMjnLgt3pOntvEJV
         dWPfhEyag54yCTRtMzpX0ebiANvAN6xVkRhrkqDm+jC6QIYuuRPd+SHpA/p87TF1jcxX
         8UceF3Z36IUr9rqOiEuyKI4VWDYH1AWHAMkGrgzJ4LmSnlcdif+nKazrvhRFsKBmsGwc
         nBjhqATbdvBAxJWD3er4qIvIN5zphMRGWoXE5tIDaTEX/uc3ddVEh8SEs0PhNocu422n
         pJHw==
X-Gm-Message-State: AOJu0Yy+Txl9CUmAyUEQ91hdYpvUqnTj9BpOU3qXsOFqmU/U0oAXyPD5
	Rifghzst8VnRWNAOHRc2rZlC63xRBo01Uwdn/pbhU+a1AKJMgCWzQUkkj37TegBdretaa0piAyD
	XMA==
X-Google-Smtp-Source: AGHT+IEUQ8eRGUVIaZ8fxuBpHUo2H1YVuLcUSZPfA1XmoW2zO5d9zvNdyk4Wyw9jqjdzqI/JWXg4D44mei4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:5549:0:b0:7ea:7727:2359 with SMTP id
 41be03b00d2f7-7f430ba1b05mr53850a12.9.1731440034345; Tue, 12 Nov 2024
 11:33:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Nov 2024 11:33:35 -0800
In-Reply-To: <20241112193335.597514-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112193335.597514-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241112193335.597514-6-seanjc@google.com>
Subject: [GIT PULL] KVM: VMX change for 6.13
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

One lonely, comically small VMX change for 6.13.

The following changes since commit 5cb1659f412041e4780f2e8ee49b2e03728a2ba6:

  Merge branch 'kvm-no-struct-page' into HEAD (2024-10-25 13:38:16 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.13

for you to fetch changes up to bc17fccb37c8c100e3390e429e952330fd7cab1e:

  KVM: VMX: Remove the unused variable "gpa" in __invept() (2024-10-30 12:28:37 -0700)

----------------------------------------------------------------
KVM VMX change for 6.13

 - Remove __invept()'s unused @gpa param, which was left behind when KVM
   dropped code for invalidating a specific GPA (Intel never officially
   documented support for single-address INVEPT; presumably pre-production
   CPUs supported it at some point).

----------------------------------------------------------------
Yan Zhao (1):
      KVM: VMX: Remove the unused variable "gpa" in __invept()

 arch/x86/kvm/vmx/vmx.c     |  5 ++---
 arch/x86/kvm/vmx/vmx_ops.h | 16 ++++++++--------
 2 files changed, 10 insertions(+), 11 deletions(-)

