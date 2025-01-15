Return-Path: <kvm+bounces-35497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E7DA11797
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BE017A2194
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAB722F39B;
	Wed, 15 Jan 2025 02:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u0ImUbmk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3A22F381
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 02:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736909965; cv=none; b=q6zc1IQ2WLd+ddm6oA/RgPgUdiBfzNVvGs/K4y6E6rBQavulnCegyInsvtcqYPWHhwUKZ1enLW6g4IfuhQRR/NKkXNNbf+NG8js/FPO5/+2eGwcFXCc4MhnYXPuDRsAYmE8ojxF9HcgU0MMbLK56ibGXq1dHCghqa7ZHEQ6hbeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736909965; c=relaxed/simple;
	bh=TRRm2mGjcGr8ctbUTqufswZjr1hU7xKu96AA+vP2VW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KfqDgaA5+ZErb+IGYvkz+krp1Fhn5GnAZexpJnJfurCcSdex1Aitcf/Ud5oK66TsG/bnK7nXvxs0PKWAaS9uq49YbEhG4uSt8phc+Mj5lIPSv35c654OKxVit0tu+A1I+5+o3UnokYuWFgISz3h6oRH5+9uGQWUnj9AUPlXCLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u0ImUbmk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee6dccd3c9so10553546a91.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 18:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736909963; x=1737514763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GMQwKGMJGPZLzExDa++0Yv2owz671vYGvqRbRi6DqN0=;
        b=u0ImUbmkop2QZT7r9f0Jp9zXjBNsMLHSw/oNt0YgvlFZMmEJFG6ou44cMbrsUDXLf9
         VGNwWO78yb3B+IyP+TmmEG6DjrEs224xcAuHB3JV5CL3piNNtBZ0rHiep+bFLpDXL4w5
         L97XuL4d5yMEesJkL9y80IJSpg0t343DwlODRudwfUv8jnZNJo5hpUuKPztVyyuPgHCo
         TWksb675VyB4/dvf6zEJzZ/3SrI/Wzs3mDNqRN5KgVug0fbw7YQxVVKQMS9tqqxGl6Vo
         3Srn1bh0Jbo3bsRjRC7dwmF2Md9Q4GR0Yc5xdNy3/dUa0/h++YcqcuwqvCjRIYOjK+Ki
         Fjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736909963; x=1737514763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GMQwKGMJGPZLzExDa++0Yv2owz671vYGvqRbRi6DqN0=;
        b=JiMUQIrCS3apPQkkv3b5gcjWCY6ypDfFZtXj7PMma8rQ2zg/u+bUuNmTLytkesPuvQ
         YGZv3pwCQ1AklnZ2pdINRRpGZwQladHxUOUTleU/H5sZAKpO+b7ljS+I5O+xvdNW5fC6
         6JX6pU3dcTuikHWVv0EE0UEk2B8tID3JkCMMpj0sXCrEDypITcCpvkzDd34rtRHPmi65
         kL0O6RlQ6/2BGOj6VR3eO3AT8WwmH+w5ESLVrRfPWPt9/zsxeJag+31txTDN42mAxN0A
         +NDzYMQaBx1WazG3iX3ElQsS60ncePx1ZfvGDsY+aDtyPLVzFS2dxMP/BzN+sLnqCHuM
         r4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw+mJmd7Q0IyPU6zEccqqf7x9/z7A+9G/qQI9JWTpvNtHN8WIp57a+jvmYciqqsWL6R3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx12TqFDUW1PzUY/zbg0NgpEBCN8mkMH4O+ddJQb5yr6Swa2alh
	WcpZmt7ErFXOnqDT2Mxr8aleALguCNXmHljsTjJNqcdBOPMLiA5Q19LYMQh71F3gmjWG/DeHDhN
	x/g==
X-Google-Smtp-Source: AGHT+IFbK+7UCk4KgoEPCEidmSm0GOdkAaFo+fXZJntovC77rjYz67Fqm6c/Yk0pxTjWVyWvJrQEx8pvjfY=
X-Received: from pjuj3.prod.google.com ([2002:a17:90a:d003:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2748:b0:2f1:30c8:6e75
 with SMTP id 98e67ed59e1d1-2f5490e89e0mr33511833a91.32.1736909963489; Tue, 14
 Jan 2025 18:59:23 -0800 (PST)
Date: Tue, 14 Jan 2025 18:58:59 -0800
In-Reply-To: <20250110101100.272312-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250110101100.272312-2-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <173690982369.1807399.8198702888217013474.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Use str_enabled_disabled() helper in svm_hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Thorsten Blum <thorsten.blum@linux.dev>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 10 Jan 2025 11:11:00 +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Use str_enabled_disabled() helper in svm_hardware_setup()
      https://github.com/kvm-x86/linux/commit/4c334c68804a

--
https://github.com/kvm-x86/linux/tree/next

