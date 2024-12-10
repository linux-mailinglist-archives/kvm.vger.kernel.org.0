Return-Path: <kvm+bounces-33448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA88B9EBA91
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95CDC283E25
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 20:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDD6226884;
	Tue, 10 Dec 2024 20:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2tfofUbI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCAB8633A
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 20:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733861042; cv=none; b=Q1O/Ng+/c2TmkWutIV+220Bu4FrhrgdDvuNW8Eb5b7IRrGilP6jwk+woCVFXblYLdGL/vzd+p+Vm58IwqUgGSzna7JDC8sxqz+urtbH7E1cxnwf/dGeXB9LwRMhI1UEckiY6MR5CQreOnI46LNmOxT59MjQaQ23SQIwRNDP2PcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733861042; c=relaxed/simple;
	bh=HthPYyWXM7ns7qJH1oxyyCxcTrMM61ei5KKI8AyghW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RmAgBOqy9q12QAMPGmzqW01JG6ZlbcxUsbGT+BQXyFr2z9HHgqwkui3VR1eHSy1iscmw3WtUK33xgf8plj93pgC+2yD0C9oTTZ2TqtDWuJ39mBDIWyije4fYLP1i3+2RtsS0fyJ4JIPV3n1C7DhiOEsrsANsPThSm0pzbqrv42E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2tfofUbI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso2776395a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 12:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733861040; x=1734465840; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b12YP6LI5CxDMhQYfb1Kc2Pt0Ydr8IAu1z7uO7m4AgE=;
        b=2tfofUbIx0yQiykosn9k27ps5u2wGOTNVFC2rD6w9AsQsXbL3PpnLpY5k4/9LT6TRk
         AaFqixDmbw0aio+yXopjOtQFSU7lClp1l1nBREW/jQayJqGmsyeRZoH8MIdPBh151RxP
         ae2J5+yI+mx1HNCrEEFEmM7J+IZFE8lyhqiyYiNAVsxAflDA5+tOUHGIHGxJBWmL3BIP
         jkpGNYTDsG21NO/NxNiwyX7LmBbqgghhaLNP8Mp0/URWW3uaSgKlo1A/Rsv+qng3sZYx
         lh9ldC4Q2dCboBA5AjIRQ+CVBUI6ilaMC1uWGkzKMiYsX6ztXTRqYnwxB6KtBedmeR+R
         POtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733861040; x=1734465840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b12YP6LI5CxDMhQYfb1Kc2Pt0Ydr8IAu1z7uO7m4AgE=;
        b=cCLnw5dHfycPRXbc6uZ0Xr7YKRIhBI5PLXxRjuGbyA4IHUTRM4pLKaSv6y/AUrq7sG
         sTR3Wtv7Uw2xsNqeWiJTxIjdi5LxPUiTmqY9LQsLOgXkNEOEs93zn6gWMxHsdLYYB/du
         gxByymsoX2qfNKPs9Mn2kGo560s9JfbppfhIrVilhWkOuVUS1E11/VTxo13IExBQVYI0
         DTQOVrZJWJgesLHcA8H0u6xIh9a261CH7/x5Wsq7/7tjNh9Dkk8UF8h147wzGG41P3GR
         mTSyw18UI5gQsP77UYZWBcawqVXGPmfpiVxt496GIdUgpr4qFDHv5ENh9Vmb9CEKJ+wr
         enZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPAKkEBrxqGp5vZnli6KO6rLOvC5+v1I2uSUQRgIG/21iBAdf75TuaXBWmZw1cwsjUDdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmJmShQi/h1fumAt2UHG3p86Q33kDQjlGATZMQ4N7n9YhGOTtN
	XR8Viww47gMbN1mNbEbsbQ3Z9URzgBivCB1rMDHmfQkUm3hJcQKsgBIbvARl3MJBUot6DjkRY2q
	KZA==
X-Google-Smtp-Source: AGHT+IGKnq0xwIL8hClvKg5o4OLBAI7YS3m+WXsr/V1moELCfZa0g1+/9+ClUPgspDlb4HQmNU67QxV+TNc=
X-Received: from pjk8.prod.google.com ([2002:a17:90b:5588:b0:2ef:89a5:7810])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c52:b0:2ea:4c4f:bd20
 with SMTP id 98e67ed59e1d1-2f12804deeemr332807a91.32.1733861040651; Tue, 10
 Dec 2024 12:04:00 -0800 (PST)
Date: Tue, 10 Dec 2024 12:03:59 -0800
In-Reply-To: <6423ec9d-46a2-43a3-ae9a-8e074337cd84@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com> <20241128004344.4072099-7-seanjc@google.com>
 <90577aad-552a-4cf8-a4a3-a4efcf997455@intel.com> <6423ec9d-46a2-43a3-ae9a-8e074337cd84@redhat.com>
Message-ID: <Z1ier7QAy9qj7x4V@google.com>
Subject: Re: [PATCH v4 6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into
 a macro
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 10, 2024, Paolo Bonzini wrote:
> On 11/28/24 09:38, Adrian Hunter wrote:
> > 
> > For TDX, there is an RFC relating to using descriptively
> > named parameters instead of register names for tdh_vp_enter():
> > 
> > 	https://lore.kernel.org/all/fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com/
> > 
> > Please do give some feedback on that approach.  Note we
> > need both KVM and x86 maintainer approval for SEAMCALL
> > wrappers like tdh_vp_enter().
> > 
> > As proposed, that ends up with putting the values back into
> > vcpu->arch.regs[] for __kvm_emulate_hypercall() which is not
> > pretty:
> 
> If needed we can revert this patch, it's not a big problem.

I don't care terribly about the SEAMCALL interfaces.  I have opinions on what
would I think would be ideal, but I can live with whatever.

What I do deeply care about though is consistency within KVM, across vendors and
VM flavors.  And that means that guest registers absolutely need to be captured in
vcpu->arch.regs[].  TDX already requires too much special cased code in KVM, there
is zero reason to make TDX even more different and thus more difficult to maintain.

