Return-Path: <kvm+bounces-30429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0545F9BA994
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 00:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42341282063
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 23:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596A818C341;
	Sun,  3 Nov 2024 23:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfJhyw37"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A692C2FB
	for <kvm@vger.kernel.org>; Sun,  3 Nov 2024 23:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730676785; cv=none; b=bB/kfRMMjMQEBfslyg+XCEKpAtpnLrUk6jk70Hl8JP4t2J91KNLCQ+t+NNMNN/EUApFOEuPCbUjjt+h2cEFEwGQAUQ5XYCTbdh3HqmlNcnfzhS6ekWO7Y2pa3fWNUI2A0W8ijICqfgK84yFANDYZRMV3uHoUkAZ2dlXJC6TuaOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730676785; c=relaxed/simple;
	bh=aRMlHF38CgRP8yr9oPnoK/NA6cE/l4b2werExZJOuRc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q4gDDfkwkwVQDWJ1ru6wNj7KS6d8G79U/93asUqJoX8XNmQukSszAqNy6UxwhHGND41iFVH0cUUkKydcWtmK/sAKJCNnnp/KDps+I+R/dIK+26m4drNffFjtIlZJG8942j4OBfpB7e3KZQ4/7+o+cZE2L/S4QvEC4lGShULa2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfJhyw37; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730676782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bindCkDXpRRg/nRYUpBwCleyN9XpvX9N5bEM4bQSDs=;
	b=HfJhyw37HiQcXjCn6i5xPiX42HCZX6vvpxTHtulFlTOYg8LAPFSEWsihW4SDQEjUboBxgE
	4+4mguAObi3n6kSuDIC0IukRfZ/D2hlKPwNiIdP10DFtY9EYWFYKrQsu+nHMnry94cLeul
	odoESQ2Zh/QnyuJS9+zCakmuRcOPdwE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-MttsmLiRNtixNurNCMz9ow-1; Sun, 03 Nov 2024 18:33:00 -0500
X-MC-Unique: MttsmLiRNtixNurNCMz9ow-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d35062e1fcso56878656d6.1
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2024 15:33:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730676780; x=1731281580;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2bindCkDXpRRg/nRYUpBwCleyN9XpvX9N5bEM4bQSDs=;
        b=teri6nHQZ9Edx6nP/M7yX2esPOsJtQrHhcse5IF8w6FRl1SxFyS9zqHmXjiJ25E3f+
         x/N44i2CqPgMPLcT/sRu8AbAoxOf3nx+ttUVpMOesLszrmi6kMgWXpdw/5hWM38RI2Pe
         Jbbb3i9dkcrMOkHyQX+hA9P0H57wMmCXNU7ugb87lMV7AbNCYcnazfyvnGGfJBBTR14m
         EJCigIuhfRQThnvY1dXX3dpNK5vV0b3Lx0iWuO/WOatimr5bqwe+q6TdMHwm2bvyjh85
         /xgfMpiLu+L5uZ75PjdLWUww+CWrzUjosq2lLiSNvjBtcvpoNPEew2b5XJxhN//2tXyW
         ZRBg==
X-Gm-Message-State: AOJu0YxGFurA/8/Zlrs62zz2wB9lXNqsFSxo2eThHPwWPkDqiew52/51
	sRup3elennuCJS2ZAUTTibn0YaM9Jv3a/XkjX1da32HFJdr+p+2h5iMRR59H4On2jUywUutwxau
	dHy9u4E5AP5Uu45KHp5iL4PgHXW06209otGNxrgIgaDypqlj+jA==
X-Received: by 2002:a05:6214:53ca:b0:6ce:233c:1d5d with SMTP id 6a1803df08f44-6d35c18958cmr194281106d6.38.1730676780104;
        Sun, 03 Nov 2024 15:33:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyubI4rjwUG5eNtfks/Kffu91OVSAu7mglAq+5BIBmLSqgeS27yg7f7xc5/QVZegw7s6a3Cw==
X-Received: by 2002:a05:6214:53ca:b0:6ce:233c:1d5d with SMTP id 6a1803df08f44-6d35c18958cmr194280656d6.38.1730676779483;
        Sun, 03 Nov 2024 15:32:59 -0800 (PST)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d353fef918sm42103556d6.73.2024.11.03.15.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 15:32:59 -0800 (PST)
Message-ID: <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only
 LBRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 03 Nov 2024 18:32:58 -0500
In-Reply-To: <Zx-z5sRKCXAXysqv@google.com>
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
	 <Zx-z5sRKCXAXysqv@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > Hi,
> > 
> > Our CI found another issue, this time with vmx_pmu_caps_test.
> > 
> > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > TOS), are always read only - even when LBR is disabled - once I disable the
> > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > value manually.  Freeze LBRS on PMI seems not to affect this behavior.
> > 
> > I don't know if this is how the hardware is supposed to work (Intel's manual
> > doesn't mention anything about this), or if it is something platform
> > specific, because this system also was found to have LBRs enabled
> > (IA32_DEBUGCTL.LBR == 1) after a fresh boot, as if BIOS left them enabled - I
> > don't have an idea on why.
> > 
> > The problem is that vmx_pmu_caps_test writes 0 to LBR_TOS via KVM_SET_MSRS,
> > and KVM actually passes this write to actual hardware msr (this is somewhat
> > wierd),
> 
> When the "virtual" LBR event is active in host perf, the LBR MSRs are passed
> through to the guest, and so KVM needs to propagate the guest values into hardware.

Yes, but usually KVM_SET_MSRS doesn't touch hardware directly, even for registers/msrs
that are passed through, but rather the relevant values are loaded when the guest vCPU
is loaded and/or when the guest is entered.
I don't know the details though.


> 
> > and since the MSR is not writable and silently drops writes instead,
> > once the test tries to read it, it gets some random value instead.
> 
> This just showed up in our testing too (delayed backport on our end).  I haven't
> (yet) tried debugging our setup, but is there any chance Intel PT is interfering?
> 
>   33.3.1.2 Model Specific Capability Restrictions
>   Some processor generations impose restrictions that prevent use of
>   LBRs/BTS/BTM/LERs when software has enabled tracing with Intel Processor Trace.
>   On these processors, when TraceEn is set, updates of LBR, BTS, BTM, LERs are
>   suspended but the states of the corresponding IA32_DEBUGCTL control fields
>   remained unchanged as if it were still enabled. When TraceEn is cleared, the
>   LBR array is reset, and LBR/BTS/BTM/LERs updates will resume.
>   Further, reads of these registers will return 0, and writes will be dropped.
> 
>   The list of MSRs whose updates/accesses are restricted follows.
>   
>     • MSR_LASTBRANCH_x_TO_IP, MSR_LASTBRANCH_x_FROM_IP, MSR_LBR_INFO_x, MSR_LASTBRANCH_TOS
>     • MSR_LER_FROM_LIP, MSR_LER_TO_LIP
>     • MSR_LBR_SELECT
>   
>   For processors with CPUID DisplayFamily_DisplayModel signatures of 06_3DH,
>   06_47H, 06_4EH, 06_4FH, 06_56H, and 06_5EH, the use of Intel PT and LBRs are
>   mutually exclusive.
> 
> If Intel PT is NOT responsible, i.e. the behavior really is due to DEBUG_CTL.LBR=0,
> then I don't see how KVM can sanely virtualize LBRs.
> 

Hi!


I will check PT influence soon, but to me it looks like the hardware implementation has changed. 
It is just too consistent:

When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update, although
TOS does seem to be stuck at one value, but it does change sometimes, and it's non zero.

The FROM/TO do show healthy amount of updates 

Note that I read all msrs using 'rdmsr' userspace tool.

However as soon as I disable DEBUG_CTL.LBR, all these MSRs reset to 0, and can't be changed.

I'll check this on another Skylake based machine and see if I see the same thing.

Best regards,
	Maxim Levitsky


