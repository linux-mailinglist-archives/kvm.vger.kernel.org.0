Return-Path: <kvm+bounces-33790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 021999F1B4F
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E0257A0581
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 00:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB198F7D;
	Sat, 14 Dec 2024 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4BvU+Tp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A14366
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 00:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734135642; cv=none; b=bOmpeVdlZy+y5h4XZAHzOnQok8RnXS/PlRHtsYQoDBWEn56yqV/e64NYC8zbACEWOYlFAvtbgxxZSMdXCI23Mpae35pcF4A5a65rKotjeR301nHkZpyjc/C+3excDh/xc30yWDURGx3E/8nQG2AeEvaAlAl1iot2jDpizJr+USE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734135642; c=relaxed/simple;
	bh=8yuMQ+3CDRnjG+Wb+cnwa+8AddfSY6nYK6xuILNqi6s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pl2q3LI4Iy8pvEMmor6ifueb102vDm+TZdEOueASSycQRvbo5280TxK8KH1CLGON5eIZZ1jBPO9K9om5oFCAVjRINvYPonudQ3inZst1rEDnoYptSdXxi47czl8hjT6usSOC18wFF0XrIDghAGGSTcbLaNPpBjkRt+pBD4HaV0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4BvU+Tp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734135639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tdq/JjcXfusOkbNObz3bvjVQNfsURiYAdiY/m2rSuaM=;
	b=F4BvU+Tpjc1PCsICNqyKAL1HX2zG5pxaiuygFSrvgz9Y8DFnXcTVSvi0o64W1LvNFgA3xS
	TTLtY7WV5t0OzggssrAHJSUuK0XQP0KNxuX9LK8T9MED2HIuMq6VXD1Uyk2uymJjxUyz+A
	ftFRvDPxV6QrQBWB8n70cHlb3sHeS0A=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-QZRan4Z2NJi-VVIcwz9JUQ-1; Fri, 13 Dec 2024 19:20:38 -0500
X-MC-Unique: QZRan4Z2NJi-VVIcwz9JUQ-1
X-Mimecast-MFC-AGG-ID: QZRan4Z2NJi-VVIcwz9JUQ
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844e344b0b5so169496339f.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:20:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734135637; x=1734740437;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tdq/JjcXfusOkbNObz3bvjVQNfsURiYAdiY/m2rSuaM=;
        b=QZ/WrKqjmFk9tuXBkh158OHtaOVyES1W65WGBJ0JBl9M9VGI9W2wDl68H8CN8A/8PN
         hwH5WCT9d32asTwnYHdlT00sAgjBpgT71w8SG5eq2jzl7aTphuUMCte1Nm/fs7UCZgET
         dlCaYlR9oi7wRdLOrfA8bREHFu5UuMvc9hCmzgKBbr6c60m+N2BPgFCIGYKVoxX7QrHb
         bZMVm0GoKCHBCPCJVjIGzGUwkeDJjQFZQZv0482EaGnf4e5gx0A4yC3WVrwYcnRJHyQg
         aGnNg+UYIajHsHtzdqXSXgaXkcKWXmGIOb9RqJ0crI4b1zxGjPeBknNB731vxJN9lzAq
         tYjQ==
X-Gm-Message-State: AOJu0YwtEtiVodnnvGlVgNa7k1xU0e72oYTmKqimyPVv+pQcqPOoSbiA
	N/MyG00NfzwJYJHYdrrYnfUtSgtkP4OhN1GCa7XfB1DIthvvuao9uKe1OsUwo8KfqIranwhAPdN
	ThZtFrZOE8HS8cXXKUdjMnkr58K2879WcSxvXZuLTCUGzZ+k4HNmixP9BoA==
X-Gm-Gg: ASbGncvMqLQyqqyYBDUo6slRmBVUh0tuxqPHwQWuJQF5KQffMvSgx2n++cKXwWsm4yk
	9Alxr2OpCc83L/Y2AxXHDYoVYwq5ex4yN1cKxHIN1fYBgg3kDwOmJwkOHhBYdK+1jvk5yV8Mxot
	QKyDeK1Haz5eqvnPdWkiNM0kkoB5KEiFvje8PllrRhzCoVq88LgVqMiOkf6o45IGDdA+OPyo6rS
	9h3DfbZ13uDd3dWADtnyNBAtdRQcc802MZG8KrQ8QMdTZRBkM3bTW70
X-Received: by 2002:a05:6e02:198c:b0:3a7:c5ff:e60b with SMTP id e9e14a558f8ab-3afef630628mr64503905ab.6.1734135637454;
        Fri, 13 Dec 2024 16:20:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHI1QbbKlrS+804wWCxAQ6t6Dz9+y6pCPsVkzgdaKAZW93/zyUJAmFQDKWYu6wSVl5x0P08Wg==
X-Received: by 2002:a05:6e02:198c:b0:3a7:c5ff:e60b with SMTP id e9e14a558f8ab-3afef630628mr64503675ab.6.1734135637086;
        Fri, 13 Dec 2024 16:20:37 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b24d9d2070sm1811985ab.75.2024.12.13.16.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 16:20:36 -0800 (PST)
Message-ID: <1e4dc1788b846215126c5bcbce8d33cae6abd408.camel@redhat.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only
 LBRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Dec 2024 19:20:35 -0500
In-Reply-To: <c0f7e5b96829407d839d9e5f3907943c4c0f960f.camel@redhat.com>
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
	 <Zx-z5sRKCXAXysqv@google.com>
	 <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
	 <c0f7e5b96829407d839d9e5f3907943c4c0f960f.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2024-11-21 at 22:35 -0500, Maxim Levitsky wrote:
> On Sun, 2024-11-03 at 18:32 -0500, Maxim Levitsky wrote:
> > On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> > > On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > > > Hi,
> > > > 
> > > > Our CI found another issue, this time with vmx_pmu_caps_test.
> > > > 
> > > > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > > > TOS), are always read only - even when LBR is disabled - once I disable the
> > > > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > > > value manually.  Freeze LBRS on PMI seems not to affect this behavior.
> > > > 
> > > > I don't know if this is how the hardware is supposed to work (Intel's manual
> > > > doesn't mention anything about this), or if it is something platform
> > > > specific, because this system also was found to have LBRs enabled
> > > > (IA32_DEBUGCTL.LBR == 1) after a fresh boot, as if BIOS left them enabled - I
> > > > don't have an idea on why.
> > > > 
> > > > The problem is that vmx_pmu_caps_test writes 0 to LBR_TOS via KVM_SET_MSRS,
> > > > and KVM actually passes this write to actual hardware msr (this is somewhat
> > > > wierd),
> > > 
> > > When the "virtual" LBR event is active in host perf, the LBR MSRs are passed
> > > through to the guest, and so KVM needs to propagate the guest values into hardware.
> > 
> > Yes, but usually KVM_SET_MSRS doesn't touch hardware directly, even for registers/msrs
> > that are passed through, but rather the relevant values are loaded when the guest vCPU
> > is loaded and/or when the guest is entered.
> > I don't know the details though.
> > 
> > 
> > > > and since the MSR is not writable and silently drops writes instead,
> > > > once the test tries to read it, it gets some random value instead.
> > > 
> > > This just showed up in our testing too (delayed backport on our end).  I haven't
> > > (yet) tried debugging our setup, but is there any chance Intel PT is interfering?
> > > 
> > >   33.3.1.2 Model Specific Capability Restrictions
> > >   Some processor generations impose restrictions that prevent use of
> > >   LBRs/BTS/BTM/LERs when software has enabled tracing with Intel Processor Trace.
> > >   On these processors, when TraceEn is set, updates of LBR, BTS, BTM, LERs are
> > >   suspended but the states of the corresponding IA32_DEBUGCTL control fields
> > >   remained unchanged as if it were still enabled. When TraceEn is cleared, the
> > >   LBR array is reset, and LBR/BTS/BTM/LERs updates will resume.
> > >   Further, reads of these registers will return 0, and writes will be dropped.
> > > 
> > >   The list of MSRs whose updates/accesses are restricted follows.
> > >   
> > >     • MSR_LASTBRANCH_x_TO_IP, MSR_LASTBRANCH_x_FROM_IP, MSR_LBR_INFO_x, MSR_LASTBRANCH_TOS
> > >     • MSR_LER_FROM_LIP, MSR_LER_TO_LIP
> > >     • MSR_LBR_SELECT
> > >   
> > >   For processors with CPUID DisplayFamily_DisplayModel signatures of 06_3DH,
> > >   06_47H, 06_4EH, 06_4FH, 06_56H, and 06_5EH, the use of Intel PT and LBRs are
> > >   mutually exclusive.
> > > 
> > > If Intel PT is NOT responsible, i.e. the behavior really is due to DEBUG_CTL.LBR=0,
> > > then I don't see how KVM can sanely virtualize LBRs.
> > > 
> > 
> > Hi!
> > 
> > 
> > I will check PT influence soon, but to me it looks like the hardware implementation has changed. 
> > It is just too consistent:
> > 
> > When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update, although
> > TOS does seem to be stuck at one value, but it does change sometimes, and it's non zero.
> > 
> > The FROM/TO do show healthy amount of updates 
> > 
> > Note that I read all msrs using 'rdmsr' userspace tool.
> > 
> > However as soon as I disable DEBUG_CTL.LBR, all these MSRs reset to 0, and can't be changed.
> 
> Hi,
> I tested this on another skylake based machine (Intel(R) Xeon(R) Silver 4214) and I see the same behavior: 
> LBR_TOS is readonly:
> 
> It's 0 when LBRS disabled in DEBUG_CTL, and running (changes all the time as expected)
> when LBRS are enabled in the DEBUG_CTL.
> 
> IA32_RTIT_CTL.TraceEn is disabled (msr 0x570 is 0).
> 
> Also on this machine BIOS didn't left LBRs running.
> 
> I guess we need to at least disable the check in the unit test or at least
> speak with someone from Intel to clarify on what is going on.


Any update on this?



> What do you think?
> 
> Best regards,
> 	Maxim Levitsky
> 
> > I'll check this on another Skylake based machine and see if I see the same thing.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> 
> 
> 



