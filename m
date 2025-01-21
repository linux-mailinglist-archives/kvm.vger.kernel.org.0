Return-Path: <kvm+bounces-36192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC67A187F3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 23:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9970A188B84F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 22:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AFB1F8EE8;
	Tue, 21 Jan 2025 22:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSAchyN7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493871F8698
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 22:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737500225; cv=none; b=VroM1v/lXMLvdp9PBvNvh4H5xXfC+OwfEP/zStz+8J/ox0mKG3pbZL3jYrfUbQvQB31oTQIDrTZ+ijlhqc2MnLEccwSmFfXkhHxLT22IGONtmWSNVOpDHK1vhTLUyETbbV7TL7okruRYVc6Kc5o4bfIeo6Gr11LoRavjYqkkUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737500225; c=relaxed/simple;
	bh=8at++4Fkk1xiHDOzqEEnDbMsjBVs6dfC+bWTGD+uqMg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C6FNFuYPWaphXlgj+2B23rOV8IYFHqtdUWoFvNGgF76FZE62Kw7FWJ8LKjDAGqSfH1jr8UGFPt+GM28BzKC3Fx/W95yLwE0VWP1q2YxyuqS8nQDS6/78pxYAGmTf8sChYl0F/CwmFDsBSzypptjHNmj1dy/spzzNck7fvR0MHFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hSAchyN7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737500222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3D9YlXhxHkD2mD5Dh2VNJI1gCYrObVyeG/ox6a1e/Q=;
	b=hSAchyN7lCygALVGJPHUURce/jdYj7/eDrwpRfByW7D0QIQCkS/VAx2RY46dGXviNI3gjW
	pbnEnV9GX7YnX7ERIHPjUCXpvfW0ob6co7qEU5IYNCUpsUfS9f8qqmU/ivq9WijNIA3UpN
	/yUyinaTJaoMAvgdGD8mamKRVWEgtgg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-beH9L41eMOG5VpCOlH5HrA-1; Tue, 21 Jan 2025 17:57:00 -0500
X-MC-Unique: beH9L41eMOG5VpCOlH5HrA-1
X-Mimecast-MFC-AGG-ID: beH9L41eMOG5VpCOlH5HrA
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d8f6903d2eso109946546d6.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 14:57:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737500220; x=1738105020;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b3D9YlXhxHkD2mD5Dh2VNJI1gCYrObVyeG/ox6a1e/Q=;
        b=ec593zx0crgFFIPEspXssmpK1JTGd0/BGelL7wbA5OXtTfFhwG8yJKVj6F/qn2VICR
         MnS+GhDXtJwWcqbCBXG4Awjg+Etd87D7UXHIi1s3h1OFMYUXb6T484KPJ+1YMu86NXdR
         DLXFtUYu+obSXPGU4I+K4z4uR8DWHHRXCN196UYjo1u3j+36iHbCg4bhuO1ozwRbmDAT
         OuvAwFvv73O3IwMPayoQgrhLC/UTeDh7NVxuS4xJlH3RCDXF6yZRHLcsSFAduZ0DDq33
         Xd7sJRkMUcqkhOWpr6K7baKLGdZTkBdsKwQXZ8jWEzO098RRSiiN0c6fj063LpoyX6o6
         3DVg==
X-Gm-Message-State: AOJu0YxQ+vjxzxTcH9wmVROn31Oy2T6nSTcHfez+EyrZ5YOeTER5Ktr1
	9Ii3HsqyUr5lGlfW/qDl1D8ZsCU5aJ6SPMImIKjd3uTcwMJew1t5OMqg1bMThc8mqFslmbhaX9i
	FJArvNBr5HCD7SPdIFioqdHjzeUD+LWhfDJS7YWeHB3a5qeOYrFucdOOI1w==
X-Gm-Gg: ASbGncvPtvmdIiICm2IYlm5KE7qJbNLvj1002hJm0qSo527rcWVgu57lV9A3mjD8RAk
	dfH66CvQdfqryY45Y2/N7VH0d9vm1WDsWz+wRGs8ppCNoNCKzw8ekH5YAV+NCpIe4CLyb9EMuXM
	u7GrYjAdnZPTb5BArs/F2VIGXrGtTRaR7iGh3cpfFzAsjXWeAcZibKMfwCCXk5t2xhzqbV/p9cT
	l72Yd+yMQCPRwT36ehwNsuUxPnfeuA0U2o8zvW1Ndy7zJ0ecbJ8D8Jc/x+0eIvAqoBgzA==
X-Received: by 2002:a05:6214:2f81:b0:6da:dc79:a3cd with SMTP id 6a1803df08f44-6e1b19d8728mr352367926d6.0.1737500220084;
        Tue, 21 Jan 2025 14:57:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFsj5TQXnSlY74PgtyV/qFWWKlRmrnSql4FvfOIgnBEwg0jRLE2q7PFa3M24dlyznMqCF6JQg==
X-Received: by 2002:a05:6214:2f81:b0:6da:dc79:a3cd with SMTP id 6a1803df08f44-6e1b19d8728mr352367626d6.0.1737500219752;
        Tue, 21 Jan 2025 14:56:59 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1e2efcecesm11285206d6.17.2025.01.21.14.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 14:56:59 -0800 (PST)
Message-ID: <b1a885fa4fbfe432c2e4bda2725d5bc78b1a6400.camel@redhat.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only
 LBRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 21 Jan 2025 17:56:58 -0500
In-Reply-To: <1e4dc1788b846215126c5bcbce8d33cae6abd408.camel@redhat.com>
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
	 <Zx-z5sRKCXAXysqv@google.com>
	 <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
	 <c0f7e5b96829407d839d9e5f3907943c4c0f960f.camel@redhat.com>
	 <1e4dc1788b846215126c5bcbce8d33cae6abd408.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2024-12-13 at 19:20 -0500, Maxim Levitsky wrote:
> On Thu, 2024-11-21 at 22:35 -0500, Maxim Levitsky wrote:
> > On Sun, 2024-11-03 at 18:32 -0500, Maxim Levitsky wrote:
> > > On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> > > > On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > > > > Hi,
> > > > > 
> > > > > Our CI found another issue, this time with vmx_pmu_caps_test.
> > > > > 
> > > > > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > > > > TOS), are always read only - even when LBR is disabled - once I disable the
> > > > > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > > > > value manually.  Freeze LBRS on PMI seems not to affect this behavior.
> > > > > 
> > > > > I don't know if this is how the hardware is supposed to work (Intel's manual
> > > > > doesn't mention anything about this), or if it is something platform
> > > > > specific, because this system also was found to have LBRs enabled
> > > > > (IA32_DEBUGCTL.LBR == 1) after a fresh boot, as if BIOS left them enabled - I
> > > > > don't have an idea on why.
> > > > > 
> > > > > The problem is that vmx_pmu_caps_test writes 0 to LBR_TOS via KVM_SET_MSRS,
> > > > > and KVM actually passes this write to actual hardware msr (this is somewhat
> > > > > wierd),
> > > > 
> > > > When the "virtual" LBR event is active in host perf, the LBR MSRs are passed
> > > > through to the guest, and so KVM needs to propagate the guest values into hardware.
> > > 
> > > Yes, but usually KVM_SET_MSRS doesn't touch hardware directly, even for registers/msrs
> > > that are passed through, but rather the relevant values are loaded when the guest vCPU
> > > is loaded and/or when the guest is entered.
> > > I don't know the details though.
> > > 
> > > 
> > > > > and since the MSR is not writable and silently drops writes instead,
> > > > > once the test tries to read it, it gets some random value instead.
> > > > 
> > > > This just showed up in our testing too (delayed backport on our end).  I haven't
> > > > (yet) tried debugging our setup, but is there any chance Intel PT is interfering?
> > > > 
> > > >   33.3.1.2 Model Specific Capability Restrictions
> > > >   Some processor generations impose restrictions that prevent use of
> > > >   LBRs/BTS/BTM/LERs when software has enabled tracing with Intel Processor Trace.
> > > >   On these processors, when TraceEn is set, updates of LBR, BTS, BTM, LERs are
> > > >   suspended but the states of the corresponding IA32_DEBUGCTL control fields
> > > >   remained unchanged as if it were still enabled. When TraceEn is cleared, the
> > > >   LBR array is reset, and LBR/BTS/BTM/LERs updates will resume.
> > > >   Further, reads of these registers will return 0, and writes will be dropped.
> > > > 
> > > >   The list of MSRs whose updates/accesses are restricted follows.
> > > >   
> > > >     • MSR_LASTBRANCH_x_TO_IP, MSR_LASTBRANCH_x_FROM_IP, MSR_LBR_INFO_x, MSR_LASTBRANCH_TOS
> > > >     • MSR_LER_FROM_LIP, MSR_LER_TO_LIP
> > > >     • MSR_LBR_SELECT
> > > >   
> > > >   For processors with CPUID DisplayFamily_DisplayModel signatures of 06_3DH,
> > > >   06_47H, 06_4EH, 06_4FH, 06_56H, and 06_5EH, the use of Intel PT and LBRs are
> > > >   mutually exclusive.
> > > > 
> > > > If Intel PT is NOT responsible, i.e. the behavior really is due to DEBUG_CTL.LBR=0,
> > > > then I don't see how KVM can sanely virtualize LBRs.
> > > > 
> > > 
> > > Hi!
> > > 
> > > 
> > > I will check PT influence soon, but to me it looks like the hardware implementation has changed. 
> > > It is just too consistent:
> > > 
> > > When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update, although
> > > TOS does seem to be stuck at one value, but it does change sometimes, and it's non zero.
> > > 
> > > The FROM/TO do show healthy amount of updates 
> > > 
> > > Note that I read all msrs using 'rdmsr' userspace tool.
> > > 
> > > However as soon as I disable DEBUG_CTL.LBR, all these MSRs reset to 0, and can't be changed.
> > 
> > Hi,
> > I tested this on another skylake based machine (Intel(R) Xeon(R) Silver 4214) and I see the same behavior: 
> > LBR_TOS is readonly:
> > 
> > It's 0 when LBRS disabled in DEBUG_CTL, and running (changes all the time as expected)
> > when LBRS are enabled in the DEBUG_CTL.
> > 
> > IA32_RTIT_CTL.TraceEn is disabled (msr 0x570 is 0).
> > 
> > Also on this machine BIOS didn't left LBRs running.
> > 
> > I guess we need to at least disable the check in the unit test or at least
> > speak with someone from Intel to clarify on what is going on.
> 
> Any update on this?

Hi,
I hate to sound like a broken record, but any update on this?
Best regards,
	Maxim Levitsky

> 
> 
> 
> > What do you think?
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > > I'll check this on another Skylake based machine and see if I see the same thing.
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> > 
> > 
> 
> 



