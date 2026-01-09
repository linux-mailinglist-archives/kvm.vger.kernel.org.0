Return-Path: <kvm+bounces-67570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACC3D0AB5E
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58DAB3064EDE
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F9E3612FC;
	Fri,  9 Jan 2026 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLDajLQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4B3612DD
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969874; cv=none; b=D6ilu8y0Ez5Ra1zxygeR9JjlD33aeOmtFnQvrHtYyfoTM+JH8zbFM/Bs/rKu5PN0A23tvAgJkzx/5nGKjDkSM7vehXJaBKIV6La35/pcvv8K7ye4zArLLiyO5WCrBzYcbyXuck+4OKCf2CJ5vV9zG8SBexpf8IOgCpbuHOITbzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969874; c=relaxed/simple;
	bh=CNSdun8fmL5H8CN8UiU7GF1ss1xxdVBye7Gw2m4tffU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rUc+nKcoLuZ1vRPuYDstB8LiyXUi9gW8/6K6GO08hkVpZ4/VS1415xdtRzgdOsV2LIf7Ta9YpSIU2Gs206WwHFbHX5tMtFXTznkqHmf5FJLYXPZMjnkVaw42qVaHEwNFndxoyl3kyTrhM5zYBDykjXQGm1FKG7cFAxPYdPgzKc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLDajLQ+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6e05af3bso5354841a91.3
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 06:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767969872; x=1768574672; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jkL5CDF0oQWoJ9P/D7D7gzC4IhlPWE27C3fRqexTiTg=;
        b=ZLDajLQ+eVy4NyYAgIzCkLAugx5B9q4oYnfO5fKDwcva9rOYUob1tx8k/2bjZNgHfa
         q5GqdvA4rB81th6v/NN+cKYVtbcV9QI/epWndwW9URytksokxs1Ova7zOAuiDJgGi/fC
         3EpDert72JT0ihX7wnw3FVT+AC5FztnPpIf5s6A1rimhYWHmbirJs2qAQRQmmbxMwxbU
         uZvGQQWCBW7CD0HHDvzSGCAdRtS9WQEs2uFLNd4SVVVcVnQSpSqxkpfqaJpdbyXIlkzM
         pcp+m/fVr9honz0qyn+w2Qk3mhoerOYQMGqE3bSrNA8O9pvF1YmJ83OMGsrG+8blqDMf
         GEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767969872; x=1768574672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkL5CDF0oQWoJ9P/D7D7gzC4IhlPWE27C3fRqexTiTg=;
        b=nh13Uwi1vh/JiNUnOxaJJ/vssg9+M0cJpu+wCDK1aHPP1oRj3Aew4eOCDWQ5LkYI6D
         U6EU2te1x32/1EO2DTBJ2j5GzoTrsrijJEnJrKeM3nawopSZrdtCTI9W49Kf1IJdu3Vo
         kTDDM9fYKBILAbivVM8KgZLRWBKSQ+OC/kjgtTP8QeZYYel8zJxrwXwO+mpU42Xhvfib
         Nu/Q0z4Mw9nQBaYqlTBOBnGqPC1KiXGK3/y8S1ulR4Cvgh2XsClNmoPIIcFll3IPZN8j
         cgkwjo/YbO5D6yNaQFKOqIMZl4My+isGTAK1PqxKtDreQLb87tr9fRzW9wuRTzKaN5BL
         CjQw==
X-Forwarded-Encrypted: i=1; AJvYcCVoApecFQi2iHpKo4Gcof1so1/F5b31fnnXgpShWQV45k64am+GA9O+uU/5uiEV8Ezs3pw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCuZTAfAAyvDrP1uoQRndZLfHRxU/5QZi3b8E6xH/aMu8uJGhx
	3INlyua1XMtZWZINFKGFaO6JvfiD23giPuFVvrFHdZTwEZplfhfEjfUVwopkpde3jq+/J3qFrgR
	OcFkbZQ==
X-Google-Smtp-Source: AGHT+IG5HQksB4judqGvjW1pzujJJNo/IYUdyJnORfoyyo5Ie1UQl2Dtw+suRKCMbwyv8Q4JlydJDqEiPms=
X-Received: from pjvc17.prod.google.com ([2002:a17:90a:d911:b0:34c:567d:ede4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ec3:b0:34f:62e7:4cec
 with SMTP id 98e67ed59e1d1-34f68b4c743mr8717162a91.5.1767969872102; Fri, 09
 Jan 2026 06:44:32 -0800 (PST)
Date: Fri, 9 Jan 2026 06:44:29 -0800
In-Reply-To: <288eaa68-7d4d-4c1b-ae70-419554d1d8f2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109041523.1027323-1-seanjc@google.com> <20260109041523.1027323-4-seanjc@google.com>
 <288eaa68-7d4d-4c1b-ae70-419554d1d8f2@intel.com>
Message-ID: <aWEUTQeNXugBYAZA@google.com>
Subject: Re: [PATCH v3 3/4] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 09, 2026, Xiaoyao Li wrote:
> On 1/9/2026 12:15 PM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 61113ead3d7b..ac7a17560c8f 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -111,6 +111,9 @@ static void init_vmcs_shadow_fields(void)
> >   			  field <= GUEST_TR_AR_BYTES,
> >   			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
> > +		if (get_vmcs12_field_offset(field) < 0)
> > +			continue;
> > +
> 
> why shadow_read_only_fields[] doesn't need such guard?
> 
> IIUC, copy_vmcs12_to_shadow() will VMWRITE shadowed readonly field even if
> it doesn't exist on the hardware?

Because I fixated on the existing checks and didn't look at the first for-loop.

This time around I'll test by hacking in shadowed fields arbitrary shadow fields.

