Return-Path: <kvm+bounces-20612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F003B91AB86
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 17:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EC151C22CEF
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 15:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D071991A1;
	Thu, 27 Jun 2024 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NrVxTj/C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF52199EB9
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719502504; cv=none; b=U2lsm04RkO/zba3Mtbco4RIbP44fReLatfS6oTAVP+ZafqALDZ0wWHu/fSzxjoGV9y0pWNxaCUDb6u98jvQia774DNv92IrgTrvG2oQBVbeWdMALJ/lfIKHry3uqOxAfnJYy1/FgdiiagnT+cax8I3NtTPU2HWlLGKPdIHuOUIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719502504; c=relaxed/simple;
	bh=B4B+7Qegfc8xqRAIl73gUCcFR/R5LPG8JWLBvTTX94w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eXYft0SRNQHte4WyLCa3cm/Qx0GLAae2dvcEGpf10KfyNF8125PfN8VPNbT5GUgo2CJuuFIS5EK+uVKcXOnw1DcjnxacmgpWSUaRDUv348XM/EacsoBvPIYnK/v5iq+xysR6jYZfLYVIGxpolFToejti/fBe3VRVa/taBafG+40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NrVxTj/C; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62d032a07a9so171215987b3.2
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 08:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719502502; x=1720107302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwfQmZ9NIpbsBfaBGly2IYRr+v7gRdeIIwzA8stq+iM=;
        b=NrVxTj/CixlZIZjkRuWYlFSJ0OjE8IU0QnuLch/D4wEe0T+X/btVuXMnX+xghyxLlu
         q8F8RlZng1sttVbHGf+3JmBGZ7ff09pzGS7lIDP1+WoqSVnIgssvp2V53jIhAWYFW1m3
         aYWcrVLnxhh4d6eeVHZbGozAgVZ2wxnms4IJinL75u2I1v4VnByCTNFeA/r3FyWdYOat
         hDsJ86j55TaNuXJAZP6U7Uf5JFygWt4Dm6uHzmYGk0HSDxq4N6U+Hm/Kg0oxHH6V34lb
         tTPTMWChkqNExFjMjVjJ/502o/TpFliar6hh4ZCkBb3Jg0D5gBswNrrKpk6ibs25dfxe
         5udg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719502502; x=1720107302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwfQmZ9NIpbsBfaBGly2IYRr+v7gRdeIIwzA8stq+iM=;
        b=JKC5KFKNaLNbSrWs75GnHftwQZ83suP/WsVge3/TC2FDUnLUdnCkiiBQGfZAbWey9z
         8r/PH+tqdnFBAL3q2APq7MDNq5jcxqMkDz+rJyiNruVGHykVfgYgSFPJEQfnFgzvdq2q
         BkMZLB4mwQzuSp9kBSR/drEiYJnryG0ACwd8z1xIMz3bs7rmNzSSZ1lTeeV0IvPiv556
         12a9nDv2m5FOXZ3CIL44LV40fGDdgTCq4vzbIMVXgx7BSWitEM/HqY3W5IpL4xz9EL5j
         hKW5P6vHXeINJYJMVq078F6Q76yPPQL1w1iyUh0OBcHpA8L19iNv4kQJVqKatErDdLkN
         yp4g==
X-Forwarded-Encrypted: i=1; AJvYcCVzcM62yCF4dVbO3XtBRC2t5sD+4lJOUZYe7jbhNqAzA6vxDTUtT11gi7vUBsYt2t7QKznCA3TkkTN9WFHO0YUVj7Uv
X-Gm-Message-State: AOJu0YyZljJQsFOEECDd6Anys4+FUcyTLfCXyEJXDb69e2yOHN2RmmBw
	27sXLVbaf0uUgAtK5nUWS8KFPjofKSlPZ8SE7SdWvtxkVl5BG5jua5oDYGtyrHB+7PkUuhpuDJp
	Alw==
X-Google-Smtp-Source: AGHT+IHEi2Jyn7G4AkqbarTu97kFAUKrcEOi465mYHsg50AqIgEPtVFdPWfoFGoEoYmptmXIFg5d8pn8ivU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b84:b0:e02:c739:367 with SMTP id
 3f1490d57ef6-e0303fe4816mr697575276.13.1719502502278; Thu, 27 Jun 2024
 08:35:02 -0700 (PDT)
Date: Thu, 27 Jun 2024 08:35:00 -0700
In-Reply-To: <87320ee5-8a66-6437-8c91-c6de1b7d80c1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com> <ZnwecZ5SZ8MrTRRT@google.com>
 <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
 <ZnxMSEVR_2NRKMRy@google.com> <fbzi5bals5rmva3efgdpnljsfzdbehg4akwli7b5io7kqs3ikw@qfpdpxfec7ks>
 <ZnxyAWmKIu680R_5@google.com> <87320ee5-8a66-6437-8c91-c6de1b7d80c1@amd.com>
Message-ID: <Zn2GpHFZkXciuJOw@google.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	jroedel@suse.de, pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 27, 2024, Tom Lendacky wrote:
> On 6/26/24 14:54, Sean Christopherson wrote:
> > On Wed, Jun 26, 2024, Michael Roth wrote:
> >>> What about the host kernel though?  I don't see anything here that ensures resp_pfn
> >>> isn't "regular" memory, i.e. that ensure the page isn't being concurrently accessed
> >>> by the host kernel (or some other userspace process).
> >>>
> >>> Or is the "private" memory still accessible by the host?
> >>
> >> It's accessible, but it is immutable according to RMP table, so so it would
> >> require KVM to be elsewhere doing a write to the page,
> > 
> > I take it "immutable" means "read-only"?  If so, it would be super helpful to
> > document that in the APM.  I assumed "immutable" only meant that the RMP entry
> > itself is immutable, and that Assigned=AMD-SP is what prevented host accesses.
> 
> Not quite. It depends on the page state associated with the page. For
> example, Hypervisor-Fixed pages have the immutable bit set, but can be
> read and written.
> 
> The page states are documented in the SNP API (Chapter 5, Page
> Management):

Heh, but then that section says:

  Pages in the Firmware state are owned by the firmware. Because the RMP.Immutable
                                                         ^^^^^^^^^^^^^^^^^^^^^^^^^
  bit is set, the hypervisor cannot write to Firmware pages nor alter the RMP entry
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  with the RMPUPDATE instruction.

which to me very clearly suggests that the RMP.Immutable bit is what makes the
page read-only.

Can you ask^Wbribe someone to add a "Table 11. Page State Properties" or something?
E.g. to explicitly list out the read vs. write protections and the state of the
page's data (encrypted, integrity-protected, zeroed?, etc).  I've read through
all of "5.2 Page States" and genuinely have no clue as to what protections most
of the states have.

Ah, never mind, I found "Table 15-39. RMP Memory Access Checks" in the APM.  FWIW,
that somewhat contradicts this blurb from the SNP ABI spec:

  The content of a Context page is encrypted and integrity protected so that the
  hypervisor cannot read or write to it.

I also find that statement confusing.  IIUC, the fact that the Context page is
encrypted and integrity protected doesn't actually have anything to do with the
host's ability to access the data.  The host _can_ read the data, but it will get
ciphertext.  But the host can't write the data because the page isn't HV-owned.

Actually, isn't the intregrity protected part wrong?  I thought one of the benefits
of SNP vs. ES is that the RMP means the VMSA doesn't have to be integrity protected,
and so VMRUN and #VMEXIT transitions are faster because the CPU doesn't need to do
as much work.

