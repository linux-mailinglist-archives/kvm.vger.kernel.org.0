Return-Path: <kvm+bounces-71638-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFcnMgrqnWlDSgQAu9opvQ
	(envelope-from <kvm+bounces-71638-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:12:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C94318B113
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8B5D63124C57
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC6D3B8BC6;
	Tue, 24 Feb 2026 18:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gu2tTGLi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BCA3B5302
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956152; cv=none; b=SDr2Wody1DSXFCM3BSJ/cvQjo8+BAl+KIRiNlOs4P1zgsPuodvGg1vWiqpG5ddX8KdkmdZNwXW8ZO1rNQENVcz0uZgu0aBz7QyjxEEi++GZxd6Gr6b/uLSeRTOlqS32ClaeZdcP8fuj6q+64c96K9Au6uEi8QHLBJpInttCE+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956152; c=relaxed/simple;
	bh=cCmatAE9dThylWxm+FWpAkIZdUndNZOrMNW0BobX/EE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QDgERMuGpqS/0+wCFc25RtrP+I3KIbmMigB+VEtTfiri9RqWe/yaXQ+306NBfCa4TGwAOb+r7dbiNCTHN+YAYUxsbjP++JFF+c9mb4t+4611FxUe+M47Su8qUBD9Q3EEXFpZkkb7Y+KYfyrGz2sTlEHrCbPOfZCgD+ljo6URQm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gu2tTGLi; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a943e214daso362284475ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771956150; x=1772560950; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G7uW3OCRL1RH7IpRvV4IyaNZ2noM/GHDdO5OSGNsoX8=;
        b=Gu2tTGLiRJrkCCRMvZkD771kLK3+Qdqn8+L56zhdUw9bluI5GFYVxFiMUtBRaL1Gnz
         h2tgPelyJ6Kb3l8XIlPFqDTIkEzdcCzURtAQwi837H3TxMQGOJ2gSfhkDwV6xBbV02+9
         AUzXBEQwwfp50F2amcuk/lsVKJAEbXfFouXJikODaZ3mDogdhEvXKkrK11Fs53RzZKGD
         TErksayemppBpzW4vCOiuHql/6p4NjYFBO9P3cq+dDVtlWXB75esJl+rSbmgQDg3Wqp1
         INQ1kT1Qy3J4AHgm9H5JVTl8a+iGOsmn7L210uycLPGdF4hodvHKX0YmZLLLHOu3e23t
         2YaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771956150; x=1772560950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7uW3OCRL1RH7IpRvV4IyaNZ2noM/GHDdO5OSGNsoX8=;
        b=tAJK64zgZvBk2H8pmuQFPqv0Zqjg0J34NvTDmtKPKY93OHIlkQWhITq2/fr4jYs1MZ
         4j9oaf9+IyJUXT93E/DUBphEmsyCJhVG4a1cZXSKxIIIicFCjnz18P/Nv1rMb2HDxg/E
         t/ZUk9GuO9zNUcjfFeBpceohQvRUONFFToALWLam6b98m7pCKgJYIIfqk3Psc/+agElJ
         CX/M1ASE813ZMLBGDosXPx+aTtc6iOOd3C5DzTKwDwZzP0gmymJ8AALSjbheAgy2rJC5
         LUK5iHXzT2dVxmycotUg9zHF5OSrSFvrnr9YrDedxWq2ZQcZ4LthMiulzJ8xqJjJy9WF
         yPpA==
X-Forwarded-Encrypted: i=1; AJvYcCWjYSjpDxsGQzbcati9QZbfeQO8HtckjZd76LTA+fbX/inOCMHo2PqIfL8YkUR2QwVruNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ6yj9PVxh2T6ygmsDgc1GKyJAjNTxtCNDcX7VRzB+au3h4vjc
	EGZt23Sujis0S2ybkfPhOm+CKwfdTWaAUXnnlvugk/EPRXUKb5a/T+6GfP2IpeHNihWvVGbRI6f
	jG4cUMw==
X-Received: from plev10.prod.google.com ([2002:a17:903:31ca:b0:2aa:d604:fb13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b4d:b0:29f:2f40:76c4
 with SMTP id d9443c01a7336-2ad744e05demr125271185ad.34.1771956150186; Tue, 24
 Feb 2026 10:02:30 -0800 (PST)
Date: Tue, 24 Feb 2026 10:02:28 -0800
In-Reply-To: <aZzQy7c8VqCaZ_fE@tycho.pizza>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com> <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com> <aZzQy7c8VqCaZ_fE@tycho.pizza>
Message-ID: <aZ3ntHUPXNTNoyx2@google.com>
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71638-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:url]
X-Rspamd-Queue-Id: 6C94318B113
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Tycho Andersen wrote:
> On Mon, Feb 23, 2026 at 09:15:13AM -0800, Sean Christopherson wrote:
> > On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > > > > +	/*
> > > > > +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> > > > > +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> > > > > +	 * check the underlying firmware error for this case.
> > > > > +	 */
> > > > > +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> > > > > +					 &vcpu);
> > > > 
> > > > If there's a legimate reason why an SEV-ES VM can't be created, then that needs
> > > > to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
> > > > of ASIDs due to CipherTextHiding or something?
> > > 
> > > Newer firmware that fixes CVE-2025-48514 won't allow SEV-ES VMs to be
> > > started with SNP enabled, there is a footnote (2) about it here:
> > > 
> > > https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
> > > 
> > > Probably should have included this in the patch, sorry.
> > > 
> > > > Throwing a noodle to see if it sticks is not an option.
> > > 
> > > Sure, we could do some firmware version test to see if it's fixed
> > > instead? Or do this same test in the kernel and export that as an
> > > ioctl?
> > 
> > Uh, no idea what would be ideal, but there absolutely needs to be some way to
> > communicate lack of effective SEV-ES support to userspace, and in a way that
> > doesn't break userspace.
> 
> Just to clarify, by "doesn't break userspace" here you mean that we
> shouldn't revoke the SEV_ES bit from the list of supported VM types
> once we've exposed it? Or you mean preserving the current behavior of
> CPU supports it => bit is set?

I didn't have concrete concerns, I just want to make sure we don't do something
that would confuse userspace and e.g. prevent using KVM for SNP or something.

Hmm, I like the idea of clearing supported_vm_types.  The wrinkle is that "legacy"
deployments that use KVM_SEV_INIT instead of KVM_SEV_INIT2 will use
KVM_X86_DEFAULT_VM, and probably won't check for SEV and SEV_ES VM types.

Alternatively, or in addition to, we could clear X86_FEATURE_SEV_ES.  But clearing
SEV_ES while leaving X86_FEATURE_SEV_SNP makes me nervous.  KVM doesn't *currently*
check for any of those in kvm_cpu_caps, but that could change in the future.  And
it's somewhat misleading, e.g. because sev_snp_guest() expects sev_es_guest() to
be true.

Given that it doesn't make sense for KVM to actively prevent the admin from upgrading
the firmware, I think it's ok if KVM can't "gracefully" handle *every* case.  E.g.
even if KVM clears X86_FEATURE_SEV_ES, userspace could have cached that information
at system boot. 

> > Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
> > unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
> > stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
> > because making SEV-ES unusable would require a deliberate act from the admin.
> 
> We know these parameters at module load time so we could unset the
> supported bit, but...
> 
> > "Update firmware" is also an deliberate act, but the side effect of SEV-ES being
> > disabled, not so much.
> 
> since this could be a runtime thing via DOWNLOAD_FIRMWARE_EX at some
> point, I guess we need a new RUNTIME_STATUS ioctl or similar. Then the
> question is: does it live in /dev/sev, or /dev/kvm?

Ugh.  Yeah, updating supported_vm_types definitely seems like the least-awful
option.

