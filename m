Return-Path: <kvm+bounces-30111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B321D9B6EB4
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E51DA1C21A88
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60778215C59;
	Wed, 30 Oct 2024 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ/EOO5R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7736C1E00A7
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730323215; cv=none; b=Wh3Y/KcDYP+STsbbrzlOAgQsdMVcD1WGxVDEnu80rvw3LnnoYEBFsj/4ZyxVXn6Z/1J3mPSXlcoF3YzH2c53jQYO6ovWPV30cyCxzUpvG65upzP6aYxMczQ+KT2DeyNSYznsjtpsEVvwXu1DRtcHiirRiNaWDXvZDaiTpJzDRXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730323215; c=relaxed/simple;
	bh=ou/K9z7I5slXhAZomwyGsLEr50zYHncbkSJO0ntzmdw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FtYExjaqMsZ0U0cPHbsgn2tWQL8vL+ERM2Nd97VTuhJhB4PbK/xuLsoRljjzMxhaNngVr+9E9d2KIjrCse89tsPvGs/bscgT4F3hTIo8GuYKjDO5aAJ4ueeEUN69167BvRVwmXsJ9oN/glUmmioZaXPF6P5EIg8d9hdr3Esrsug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJ/EOO5R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730323212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3i2SWa69rx6w+JHb2UvB5xMrMzNpXYFD6vk5MbHMjP4=;
	b=aJ/EOO5RWj2SEWsgL/QqrsJET3pLBlqwl2KYrL+RBSSJQuzq9uiuKKpFx5PsWmuQJgtsOd
	IdPUD/fqMpkJN1cSAqdn1HyKoiYOV4/cLW/JVhYbkIO2dM3HmcA5c7QZyrcAeIF40bihw6
	EMdjl31l0kxdAWm7TIYSObaS2uKwv4k=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-zkCOMm8KNaalRrfFM5KoUw-1; Wed, 30 Oct 2024 17:20:11 -0400
X-MC-Unique: zkCOMm8KNaalRrfFM5KoUw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-460b46cf23cso4168571cf.3
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730323210; x=1730928010;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3i2SWa69rx6w+JHb2UvB5xMrMzNpXYFD6vk5MbHMjP4=;
        b=YN0Flw5s/kYq7Jeaf2XoljUeYwFPXF3dW5K4iw27dClZD20/arhqOyWgqu0vmY+KqD
         0dRTf/9eB62xqmahQHL0Y38KFqV99WUDrtcbh56Yrw5OezIcT28e74TFfcJBrcnIbIzP
         cjMLSOEhuOlec2ozCXs0/zdgBtpDWbzaBD83YHw0VanMMxHeQJUrarDgZET9bN9oHFy4
         95kwbtA8/lZyeUvbFlszYuf2UbOADKtSGuWrFz6xa6BoomAesPCry/HKficRtNlQXrw2
         tppiE5Hj3gv3LYPvNndKrfbgMYuP29TU1xcdM53vtlCd10eZImfIzt2v/GYcliOEMlSt
         VnCg==
X-Gm-Message-State: AOJu0YyOszzePdlHGVp0TAu4lJ+Woeto4E/YbfmrXAlFWkSuO/OS9kFY
	WVF2B6Dz2VkfbiKjLc8x7bVO4aJ/yo0FBZlPVj11c4Vp05+m4YFlAStQmse+b2/5WkeoMgqeehh
	OftJ+Mo8GSqrmFFryo9TVCVIs17TmogeY5pDCGsWtiSMlItt2l2anb/SbRK/a99OEgflPwIqu/0
	RN5aBiC4CfSFKr30iZ3al4zBMs0f3/7qstSg==
X-Received: by 2002:a05:622a:1a0c:b0:461:263e:6ab3 with SMTP id d75a77b69052e-462ab281620mr15291411cf.30.1730323210408;
        Wed, 30 Oct 2024 14:20:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtN3uJv+UByFkfx2/K+ZSGKtwZI/5pF0/PDjxdaVzdmxOkM3wFZDdC2t3yJjKmo3XMrBeigA==
X-Received: by 2002:a05:622a:1a0c:b0:461:263e:6ab3 with SMTP id d75a77b69052e-462ab281620mr15291011cf.30.1730323209857;
        Wed, 30 Oct 2024 14:20:09 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d353fcc777sm554086d6.56.2024.10.30.14.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:20:09 -0700 (PDT)
Message-ID: <c6594c5f040eedc7e5b3cb001aac1bcfcb6782cd.camel@redhat.com>
Subject: Re: [PATCH v4 0/4] Relax canonical checks on some arch msrs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar
 <mingo@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org,  Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>
Date: Wed, 30 Oct 2024 17:20:08 -0400
In-Reply-To: <20240906221824.491834-1-mlevitsk@redhat.com>
References: <20240906221824.491834-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-09-06 at 18:18 -0400, Maxim Levitsky wrote:
> Recently we came up upon a failure where likely the guest writes
> 0xff4547ceb1600000 to MSR_KERNEL_GS_BASE and later on, qemu
> sets this value via KVM_PUT_MSRS, and is rejected by the
> kernel, likely due to not being canonical in 4 level paging.
> 
> One of the way to trigger this is to make the guest enter SMM,
> which causes paging to be disabled, which SMM bios re-enables
> but not the whole 5 level. MSR_KERNEL_GS_BASE on the other
> hand continues to contain old value.
> 
> I did some reverse engineering and to my surprise I found out
> that both Intel and AMD indeed ignore CR4.LA57 when doing
> canonical checks on this and other msrs and/or other arch
> registers (like GDT base) which contain linear addresses.
> 
> V2: addressed a very good feedback from Chao Gao. Thanks!
> 
> V3: also fix the nested VMX, and also fix the
> MSR_IA32_SYSENTER_EIP / MSR_IA32_SYSENTER_ESP
> 
> V4:
>   - added PT and PEBS msrs
>   - corrected emulation of SGDT/SIDT/STR/SLDT instructions
>   - corrected canonical checks for TLB invalidation instructions
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (4):
>   KVM: x86: drop x86.h include from cpuid.h
>   KVM: x86: implement emul_is_noncanonical_address using
>     is_noncanonical_address
>   KVM: x86: model canonical checks more precisely
>   KVM: nVMX: fix canonical check of vmcs12 HOST_RIP
> 
>  arch/x86/kvm/cpuid.h         |  1 -
>  arch/x86/kvm/emulate.c       | 15 ++++++-----
>  arch/x86/kvm/kvm_emulate.h   |  5 ++++
>  arch/x86/kvm/mmu.h           |  1 +
>  arch/x86/kvm/mmu/mmu.c       |  2 +-
>  arch/x86/kvm/vmx/hyperv.c    |  1 +
>  arch/x86/kvm/vmx/nested.c    | 35 +++++++++++++++++---------
>  arch/x86/kvm/vmx/pmu_intel.c |  2 +-
>  arch/x86/kvm/vmx/sgx.c       |  5 ++--
>  arch/x86/kvm/vmx/vmx.c       |  4 +--
>  arch/x86/kvm/x86.c           | 13 +++++++---
>  arch/x86/kvm/x86.h           | 49 ++++++++++++++++++++++++++++++++++--
>  12 files changed, 102 insertions(+), 31 deletions(-)
> 
> -- 
> 2.26.3
> 
> 

Hi,
A very gentle ping on this patch series.

Best regards,
	Maxim Levitsky


