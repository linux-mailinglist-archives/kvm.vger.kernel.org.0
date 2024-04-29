Return-Path: <kvm+bounces-16156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A83D8B5B37
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 16:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7171DB21EEF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 14:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D017C08D;
	Mon, 29 Apr 2024 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNvfnSyR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CB777F32
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714400846; cv=none; b=fflvJjvF6pBEhl3smB1Cd6jZCADZNmeL6QxerALLE68Ry7lNi78DS+Vunl4bhtdnLy7MucW6KAWzavSPDH6YFYe33xallQlO8Ovuofaq4bV008jAXC9ldyoyDRkMYgPfgML2RjHvJg2AW5sCQ7wXZ88lNwWvJZfLzfFXO6LIUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714400846; c=relaxed/simple;
	bh=dOL5MQJEWlm+ALadfwEWLIsuMmXKHK7rNTd6CxqSNA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cOdGNNR5ia47c1e5JDXLXckDQORTyGxbCAbum0PFTOtiT4UCHYumLiLYb/YXSaK4E+tzTRg0SMKRou6CCXJcxCOf0LQr5ZExL5xAdF+ymf1q+t7ips7rvgivX8GCX14vsUtdTj1ZlngxXaE5qQ/O07OOKdhwbPDNVz73GL9q3Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNvfnSyR; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5f80a77b95cso5133408a12.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 07:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714400844; x=1715005644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S3mlM0E1TrjvYHfesQNSkr38bw44gyQq8z5XmrX3EV0=;
        b=TNvfnSyRLs2kUehKYQg9lgy0+HSgeBrQ3mGDf7ZZH65mLocaUa6qmks0FzpCpzV2Qn
         BD9e6HPgy7fN6Rvq/0LD6EXaoM+OexYxuE/e59aOI56V3cPh9Ca8QnpVOR3sw6ABQmTD
         zhRNNRIEGeImEQLC3EKXn8IA+NI8ZMv04IMKNeHcgY4fDFgDqANrxIp6xnrk04TONTN9
         bTtORWXUnZv0uKm4bqxVDJHUOsHZEVOBW1jA/qI4nGfb8GxTnxdHg3NbtjHQycg7PlpX
         27ZXstLqzB32bkQi8Dbyb9bM5UWaebeMGIIJwt/siu8JpqaKsODF4ih8CqXilsAtdBcW
         bsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714400844; x=1715005644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3mlM0E1TrjvYHfesQNSkr38bw44gyQq8z5XmrX3EV0=;
        b=BMfk7gKtLZUmucOmLBC9GImEtE17Vu34glTYmoHxT0xr6iYUISpjjcqFxDNeytofQI
         YADjS8JMAgf7HyMn4ilCWUwy3iTkF885eOL6AIFkyQqNwxsqESl5YRkx3m6Vazkmy/Jz
         S+hazT3C79SO8NPI1fyu0IDCUTVhdtvBw4itbiwtHDm1ltfuutXu43e9DzVPvJNWItre
         pT80rVNP5zcrPgG2oZdmBlpm0skDDKVrPDtoKyMimT5QXx7hEUX9rD9vwENLnAjz73I2
         pwft0ATcLK3Ab3UUwTmz6WlKkYJfXbwtMHOrmzpZ6jgoNyFf1hLAOpVYv/eiPxNL41nU
         pviw==
X-Gm-Message-State: AOJu0YwYx2fFU06x+uT2yW9obEtAy/3mBvscU9iRq3qwJC09AxvaiXcT
	rgPwtXQK/TxEDuTvvmP8WVkLj9lCX7TWa4WUAmgteRfQpaJdCQQlC/S17BQ84MUoeywF2X9cb9H
	ZnQ==
X-Google-Smtp-Source: AGHT+IFtI1VRsJxmoBaQkkMNkidpPOTCEAStMWY3Kr4rNLpPFTYg7KKAfEudEOmt/GvfkLL4yDTV9xTdh4k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1e5d:0:b0:5f7:651b:fed8 with SMTP id
 p29-20020a631e5d000000b005f7651bfed8mr29463pgm.12.1714400843944; Mon, 29 Apr
 2024 07:27:23 -0700 (PDT)
Date: Mon, 29 Apr 2024 07:27:22 -0700
In-Reply-To: <20240427013210.ioz7mv3yuu2r5un6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com> <ZimgrDQ_j2QTM6s5@google.com>
 <20240426173515.6pio42iqvjj2aeac@amd.com> <ZiwHFMfExfXvqDIr@google.com>
 <20240426214633.myecxgh6ci3qshmi@amd.com> <ZixCYlKn5OYUFWEq@google.com> <20240427013210.ioz7mv3yuu2r5un6@amd.com>
Message-ID: <Zi-t65xmCk9x78lb@google.com>
Subject: Re: [PATCH v14 21/22] crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION
 commands
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, Larry.Dewey@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Michael Roth wrote:
> On Fri, Apr 26, 2024 at 05:10:10PM -0700, Sean Christopherson wrote:
> > e.g. put the cert in a directory along with a lock.  Actually, IIUC, there doesn't
> > even need to be a separate lock file.  I know very little about userspace programming,
> > but common sense and a quick search tells me that file locks are a solved problem.
> > 
> > E.g. it took me ~5 minutes of Googling to come up with this, which AFAICT does
> > exactly what you want.
> > 
> > touch ~/vlek.cert
> > (
> >   flock -e 200
> >   echo "Locked the cert, sleeping for 10 seconds"
> >   sleep 10
> >   echo "Igor, it's alive!!!!!!"
> > ) 200< vlek.cert
> > 
> > touch ~/vlek.cert
> > (
> >   flock -s 201
> >   echo "Got me a shared lock, no updates for you!"
> > ) 201< vlek.cert
> > 
> 
> Hmm... I did completely miss this option. But I think there are still some
> issues here. IIUC you're suggesting (for example):
> 
>   "Management":
>   a) writelock vlek.cert
>   b) perform SNP_LOAD_VLEK and update vlek.cert contents
>   c) unlock vlek.cert
> 
>   "QEMU":
>   a) readlock vlek.cert
>   b) copy cert into guest buffer
>   c) unlock vlek.cert
> 
> The issue is that after "QEMU" unlocks and return the cert to KVM we'll
> have:
> 
>   "KVM"
>   a) return from EXT_GUEST_REQ exit to userspace
>   b) issue the attestation report to firmware
>   c) return the attestation report and cert to the guest
> 
> Between a) and b), "Management" can complete another entire update, but
> the cert that it passes back to the guest will be stale relative to the
> key used to sign the attestation report.

I was thinking userspace would hold the lock across SEV_CMD_SNP_GUEST_REQUEST.

   QEMU:
    a) readlock vlek.cert
    b) copy cert into guest buffer
    c) set kvm_run->immediate_exit
    d) invoke KVM_RUN
    e) KVM sends SEV_CMD_SNP_GUEST_REQUEST to PSP
    f) KVM exits to userspace with -EINTR
    g) unlock vlek.cert
    h) invoke KVM_RUN (resume the guest)

> If we need to take more time to explore other options it's not
> absolutely necessary to have the kernel solve this now. But every userspace
> will need to solve it in some way so it seemed like it might be nice to
> have a simple reference implementation to start with.

Shoving something into the kernel is not a "reference implementation", especially
not when it impacts the ABI of multiple subsystems.

