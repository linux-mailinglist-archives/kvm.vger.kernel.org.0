Return-Path: <kvm+bounces-55058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2598B2CFB2
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 252F56287D3
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B363270EC3;
	Tue, 19 Aug 2025 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="exVTj5Fe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0972E1C862E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645314; cv=none; b=I3LUSNSYAeZ1QHsk9EbYT9wuMXQSpcZWB2TXFmKH8l2Ra3sDOTxHgbGr02irtuIc4Vikc4IcUrwghLAjG3HGSk6xTexZnAJi/mfj01YDLOVLi9lZRHDSCYcVOiiKgjmgFdr4jLzCZ3OBeeSjPh6Z7nfKlk88vAZKCJffbr3lmvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645314; c=relaxed/simple;
	bh=nOMn3UK9M0LNY0lp+AvhBVBBoJ2rN7sijra+TzeBYK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fvaO/CgkU6KX7ISaYu2SX5AQqDtiLZn/oZR8rBnu1cmB7Ay2JqzeLa61G8SIUZmrbtyYqmkgi/hdIwTm6hdDx46pVnu2N42YuRPU9rw2K8McJij23rgHsFMBnenf+FAPUWYXgRPhFxddElq1uKJcwwaM37KLBwBp8Dtr+mLx+N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=exVTj5Fe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3232677ad11so5440517a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645312; x=1756250112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oZuxG4DJdEct4WQLV7ObKo6lalKw4LY4e5KHgHD7dtY=;
        b=exVTj5FeLfBjbU0Y/7QpqnClkQRgnRgHuGXuwP18lRprEeL3IFBQY/dyD5VUcPk7hC
         znfdw178jFmfqY8K2+51l+KgVUDXCuh55k6PLSkpp2WzGW1MJG4iXFkizWWixshpZPy6
         6W+vuib7sMaqygTsHAIDjbLwmHKSeAd0sC76sOW+dmnBDxxa3AoHKfU2rvbWMGzkrOjf
         k4q/MQLJ2ndP7N3hVuxf3LhupUNfKWfJdU8S9I1smMcRdtHKb0Fxm5wxDMcxZsls/9gp
         PZCg+V1WmXKtvBQLhMqVi76zLgOFJ6+K4ih+gcvEjCmxrwFGUZecAaW6oLTAknsFiWkF
         l9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645312; x=1756250112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZuxG4DJdEct4WQLV7ObKo6lalKw4LY4e5KHgHD7dtY=;
        b=Vk9UNOhud9OqSmbewsugB1di22EK08hFbiiA6jDVOmw1wmW4yXMJqMGHWwhccmLi4u
         Vtz0AKaW7kc9VOPoRSD26Me3NPop4MJ9lRrfS2jytmFOiAig4jKVl91AeUEKVwxntDTL
         fJVvAUuqOEuMwCqs7jr6agMwtVcBiPZjVBogRx1oUsB/Zya3nx/kKezlB96pYeclVavR
         wwYsm0l88+rTbxGBb/FuGPjk5TdOQ6ZRXDlvMqLFYRCH9QGkVlsx5uuip/oXgsKZzrCo
         CYcrM173WPaBf0+NXbutWccwqnc4jgiqMWsKAtd2mVrxoopZyewuyJd8bJyXx2zv6Qjb
         Jmrg==
X-Gm-Message-State: AOJu0YydRviu9JlIfA5NfmvOGgFbVVNniYWPo5mzKJSYMpUVaES1rmtS
	EU7KeR+3zhcZu4cSJeDhH94RpcTWWprvvPbay/n6xAaoORv1vYsm5XDwmbT/U41bTyKaOaHsYkT
	TAovWiQ==
X-Google-Smtp-Source: AGHT+IGQCij7rWwNKcQP/HiTVw3X7iIXS8GUGBk/Sevxvmhufe/DeKIjqMZyXjohikyJOBeXtB+0QqAuH4I=
X-Received: from pjbmf12.prod.google.com ([2002:a17:90b:184c:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558c:b0:321:cfd5:3f95
 with SMTP id 98e67ed59e1d1-324e1425be1mr1116881a91.35.1755645312293; Tue, 19
 Aug 2025 16:15:12 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:03 -0700
In-Reply-To: <20250715190638.1899116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715190638.1899116-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564471845.3066581.8347761517352370906.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Don't (re)check L1 intercepts when completing
 userspace I/O
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 15 Jul 2025 12:06:38 -0700, Sean Christopherson wrote:
> When completing emulation of instruction that generated a userspace exit
> for I/O, don't recheck L1 intercepts as KVM has already finished that
> phase of instruction execution, i.e. has already committed to allowing L2
> to perform I/O.  If L1 (or host userspace) modifies the I/O permission
> bitmaps during the exit to userspace,  KVM will treat the access as being
> intercepted despite already having emulated the I/O access.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O
      https://github.com/kvm-x86/linux/commit/e750f8539128

--
https://github.com/kvm-x86/linux/tree/next

