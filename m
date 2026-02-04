Return-Path: <kvm+bounces-70122-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IPlLJyOgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70122-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DA01DFEC6
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 255D43051578
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2107835975;
	Wed,  4 Feb 2026 00:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HN82gUWM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2F61E86E
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163862; cv=none; b=c2IMrqTCHR+C8Y+BttZy00SqA0+bJL3EeLKvSuAg/ZFrntgNSfVtGFOgu7MUY1fTjfvPlg+loA3leMvotMFi323fs56rVBH3OZj7wROJ++V2pSQKDo1nMWT0+NfDt2rqWvD1Rd02MhBOs9SaTcybWqb6dxqHwlOGXHlDBiz1fls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163862; c=relaxed/simple;
	bh=YR8JG1rxqeqQvnn3XQP75sunrORnlQmp4fD9P78DfSE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oql1aRMsfH0kxB5tHrOnwfKyVf/DoQdRkvlplRnaTuU/qI77ZRU8OeoiCk3xFnc4yZAyEqCN5B3XKOSjLn8tC67ZdWZgUI8svQyXm9u48PlbNcSRAkrzlTWvxeCAep4wDiwPxo76wkYE9NO7uGryqycewp+uuy5uOvlApi2fT9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HN82gUWM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a863be8508so80784005ad.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163861; x=1770768661; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4pwB4csRXSN3YIr4wsuOmTDwhnD/JebNUm7D7D+maQ=;
        b=HN82gUWM1Xef1tOYecx2vWxDY/7rmNtYLLqMBJ8H0Z5Wsl9hBG/RwfbWWUEfuGKeCi
         YTAFnOb5s+XbQ27OV45lB6vU/Ct1tp8mY1KfFFEH8gOvEBD0U5mypAuClo/36fP68Oi9
         6Zg/FVm7sYQW2sA3vXnF4XjZsMdQj7oY1wIhrkkmH3nSZCKQfx8h44RJnJQJ+L7tZjk8
         ifQ2SbW57nxh4OfzYGs+VPkFSOi1yB0ANSA6i8PsQrDbit8436vG9jcwHlLB2XyMLj+9
         mnW2vPeY7m9R5SEBmwXCXo8WkLQdcPNGU4GzIeGpjRs3PAenU23GdO1+KeGopeaS04Oo
         EQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163861; x=1770768661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4pwB4csRXSN3YIr4wsuOmTDwhnD/JebNUm7D7D+maQ=;
        b=mcaQxL3Rawl6gwz17X+LQCDC7g5q43bzqeyNIfopLuu4agSLi8vBwak/wMRHygjtGd
         Pah4X1Y4ppoD52GkgUxAtrxhS9FuHLXiQ8fjBQRz6Nlg41Tve1ZjRdgs71rItpW93dxx
         TkdJrWdz4y22Vt6Zk1XYA3FVc4Wi2WFhhxlJji0SI8ydEgHxJinXPpeV+Jt+foqa8pH1
         KbvnQOVWJw8F56LLC5mCWt1NXf0+0L3fIsdOJYJES3vQCPwkXbmArQ2TYhtMoZ4Q0930
         ba0hm9aVrtACvq9CHpf3qCSwXrRdQrs9PTodJgb1UL+WQJ282je70pk4+6GZV45dgCjK
         n9Ng==
X-Gm-Message-State: AOJu0Yydr+6+VdzNPh5bY6l2/b59TS/DBRiRdqfJfB+8ZObFXBzkw5eW
	TBhe/EV+f7gUAoVAFdbRyf1THA7GlDzRFqbiAiBcYWBe+HioaGRZa1o4IO+GMKmo/0OFYppvAB0
	KH0/Y2w==
X-Received: from pldt11.prod.google.com ([2002:a17:903:40cb:b0:2a0:d5be:7bb3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88d:b0:295:560a:e499
 with SMTP id d9443c01a7336-2a933bc9b8amr12161285ad.5.1770163860720; Tue, 03
 Feb 2026 16:11:00 -0800 (PST)
Date: Tue,  3 Feb 2026 16:10:25 -0800
In-Reply-To: <20260115172154.709024-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115172154.709024-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <177016376262.575354.15783428739984459015.b4-ty@google.com>
Subject: Re: [PATCH v5] KVM: selftests: Test READ=>WRITE dirty logging
 behavior for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70122-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5DA01DFEC6
X-Rspamd-Action: no action

On Thu, 15 Jan 2026 09:21:54 -0800, Sean Christopherson wrote:
> Update the nested dirty log test to validate KVM's handling of READ faults
> when dirty logging is enabled.  Specifically, set the Dirty bit in the
> guest PTEs used to map L2 GPAs, so that KVM will create writable SPTEs
> when handling L2 read faults.  When handling read faults in the shadow MMU,
> KVM opportunistically creates a writable SPTE if the mapping can be
> writable *and* the gPTE is dirty (or doesn't support the Dirty bit), i.e.
> if KVM doesn't need to intercept writes in order to emulate Dirty-bit
> updates.
> 
> [...]

Applied to kvm-x86 selftests, without the duplicate sync (hopefully).  Thanks
for the reviews!

[1/1] KVM: selftests: Test READ=>WRITE dirty logging behavior for shadow MMU
      https://github.com/kvm-x86/linux/commit/a91cc4824660

--
https://github.com/kvm-x86/linux/tree/next

