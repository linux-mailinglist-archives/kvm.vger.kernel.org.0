Return-Path: <kvm+bounces-50756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F40FBAE9106
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2446189D880
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139922F3C31;
	Wed, 25 Jun 2025 22:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lI7Z1864"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B8B2F362A
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890357; cv=none; b=f/c5TfsVu4cgyEQgiMFkvXgz6q0xa7AhQsvPysdYco2kyph4Da5fEKmJGG433nRZ5fkD5/mRSMN4RXPtC3gM4XOciNCbvrVo/OPN9QjzUa9Uthorl3obyg5uaUOXPHQaeGRQ1V8J2mymPiM5dERnr0L4sTH6faLdmeS0tHfaKaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890357; c=relaxed/simple;
	bh=aTZyStIULyq/k4CCURzFNAKGPG43KZQBAiLQF+xYz7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W9In7cXhso6+o/+L3gXDHgpMxnWnue1JSLvA7U+fkJB8OV7q0Q3T/CtoMJ6XeHulhJ8kfJCuXA4fNog8KgsEir6a2prEZRlwy6ByZRxxV8yAg60Muw8FBejRWVf4wFlfkDrgFZpzgdUAAgUFNJEO/AASePAawEKZdb4qOVD7QI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lI7Z1864; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312df02acf5so1052088a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890355; x=1751495155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=By7Ee4P1ovSF9qlED+l1YG1EOLcFo+D0m9yIXku26cc=;
        b=lI7Z1864X1KTr2RO2ag5Ozk6gcNAMeH+p3vX1EPMs2euOFWd7RtgkIVl89SZnAV8gr
         XYzbe6RdbLLKeV9E1/VochgFaLeeXbYuBOlC+9rTubaeq0x0UJ47XilhZ7+YtDtE8I4s
         pHaYeUx3sqMG91kNg5dJv0yLaSxkg1q0hLO06k70Qkczs3H3Vq0hjUzbc10k/jZOfOWe
         oaC4o1BY23xFJuIYCWmUeGoyH9DVxUSekeAIFMGIaq6fpOrFWwsI0HRfiFm7JwQCPsQA
         M75IE0+SNEo1aw3UGQpLChHn+RzAng+8yW9+XtAJwxNrT6Ou+xEXw50QGblI7qN89G0b
         pzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890355; x=1751495155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=By7Ee4P1ovSF9qlED+l1YG1EOLcFo+D0m9yIXku26cc=;
        b=TZmX+1ehOVPHckeLiiHAlUOiCIOtIIchyo9w7JBLWKH1VvpvNnBzwUCnUDDzaHdCqx
         4Zh+0aQmXPLO4Ge1iHgNkhfbh8KP3TJVEYW4kGF13JFLZEqHURSzK49Avq2SyUvddcQJ
         Y7p4JJW+s7dUa30PCfsjumiL9jP4CzgineLh4sc379hUlUqISFStfbN8hzcPek/YV2ZM
         5MlAuBBpNLpsapbsoCPbDGvms8V7bM6oXyMrsd6/9ofBFGm09xmN61jr8DgE/VLl1lms
         MVwLXnXw+/z8jAq7m0emddySh09fiWfRcZrMGufwIG8eDwF6dNtXLum+WmekVSoxjts+
         lgYw==
X-Gm-Message-State: AOJu0Yzs3Uvk0sO9XZebrdwxn41EPTx56W0YHusu4GLOUWpglZTUHpbr
	GtvsisVc5juTumo+0PZMn4Rrt6GkJakg4/wOqTFRUkT/ZDT9faY296IqjjUDBM1ecmL4wJQhp8H
	2/zcZzw==
X-Google-Smtp-Source: AGHT+IGJJMfDs7PhnTAVBUcg2mJZPoyVIwr1GuR5qMUdFS3Z6NJYkNozrq6DOaXmJRTPI5RUGTxx4q4Emio=
X-Received: from pjbos13.prod.google.com ([2002:a17:90b:1ccd:b0:311:ff0f:6962])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c3:b0:315:f6d6:d29c
 with SMTP id 98e67ed59e1d1-316edf2f690mr1755634a91.15.1750890354688; Wed, 25
 Jun 2025 15:25:54 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:25 -0700
In-Reply-To: <20250620062219.342930-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620062219.342930-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175089019569.722981.11608669112741473168.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add back the missing check of
 MONITOR/MWAIT availability
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zide Chen <zide.chen@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xuelian Guo <xuelian.guo@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 20 Jun 2025 14:22:18 +0800, Chenyi Qiang wrote:
> The revamp of monitor/mwait test missed the original check of feature
> availability [*]. If MONITOR/MWAIT is not supported or is disabled by
> IA32_MISC_ENABLE on the host, executing MONITOR or MWAIT instruction
> from guest doesn't cause monitor/mwait VM exits, but a #UD.
> 
> [*] https://lore.kernel.org/all/20240411210237.34646-1-zide.chen@intel.com/
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: selftests: Add back the missing check of MONITOR/MWAIT availability
      https://github.com/kvm-x86/linux/commit/0048ca5e9945

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

