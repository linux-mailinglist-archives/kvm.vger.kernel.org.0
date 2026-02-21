Return-Path: <kvm+bounces-71442-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADbRL6t1mWmmUAMAu9opvQ
	(envelope-from <kvm+bounces-71442-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 10:06:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E9516C76A
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 10:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 993CD30054C8
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 09:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7B333D4F2;
	Sat, 21 Feb 2026 09:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpPBVSWb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7B4BA34;
	Sat, 21 Feb 2026 09:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771664807; cv=none; b=O+uLYYTRMlO/1YFAvt6wtAquDw/JbA6fwS0of7HalHjS6Xhbqb1DlwGjM5VzvEYLdHh6sX+EEBNwGeTH3BskvOPnzKSL7eKS+q4GPtBEKJCPY/VtannUR0cb5+Qx/eTa91yy45pC1KnQ47yGuMpv4R8lqtRzTZU5NZARDKwSQPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771664807; c=relaxed/simple;
	bh=NuSr2Ox0snsvth2IhjhWJvNqIK7wlvm5NNhwBPz+5D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4sfeBE4h/ZDIAYcCGDz8Fh9SdFLf47OYAE/+olUzwJqE6YbUEflV2AwU4e77Yc/Inl34y7GI8galReJdZmj7hCSeik/jTP8DChWvn+RYTIxYLjyfYuj4Y/Nb4MKzNaoKvh0cUaZRWi2wtXpH1fljMtXcfZbXa4VAcQbTWxBtso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WpPBVSWb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29B8C4CEF7;
	Sat, 21 Feb 2026 09:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771664807;
	bh=NuSr2Ox0snsvth2IhjhWJvNqIK7wlvm5NNhwBPz+5D4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WpPBVSWbfR95GPXNkxIq8HmuElNdDSeJKNlVpbQc77P+xJAbBkxKqDMFsWJWx9GQY
	 KSGpa6J7uPSBJG3qJeE0s+dopDf9znbrF+cDstb+qLJRU8ZXTbCw/+k29qwYC3Ube9
	 C72I0GaSMW8uL1/7loRrVXj55PdPrCaTZgAzDukgY+aOj9KEwti9dYNvZ81NpY9BJ5
	 8USLXZUS0aPromG3EFjsqbke+o1ZNT03vi0RgFh/TF9Mp3R7MMkawBKpk+VfzUf9dg
	 MNqTdDyrdcsY4WsBE+teloa65whIxzLo3DP31YoL6dmBZS2zq2sNDxFDPWJBu9pgiN
	 1P2QOasID+aYQ==
Date: Sat, 21 Feb 2026 09:06:45 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: nSVM: Call enter_guest_mode() before
 switching to VMCB02
Message-ID: <ohthwxldpmr5emdch6b2jipr6uotz7ecfvvf3rkdoaujtnxbdy@aa3nh66ntax6>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
 <20260206190851.860662-10-yosry.ahmed@linux.dev>
 <aZkGlFwWeRx0ZGCV@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZkGlFwWeRx0ZGCV@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71442-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 64E9516C76A
X-Rspamd-Action: no action

[..] 
> LOL, guess what!  Today end's in 'y', which means there's a nSVM bug!  It's a
> super minor one though, especially in the broader context, I just happened to
> see it when looking at this patch.

LOL.

> 
> As per 3f6821aa147b ("KVM: x86: Forcibly leave nested if RSM to L2 hits shutdown"),
> shutdown on RSM is suppose to hit L1, not L2.  But if enter_svm_guest_mode() fails,
> svm_leave_smm() bails without leaving guest code.  Syzkaller probably hasn't found
> the bug because nested_run_pending doesn't get set, but it's still technically
> wrong.
> 
> Of course, as the comment in emulator_leave_smm() says, the *entire* RSM flow is
> wrong, because it's not a VM-Enter/VMRUN, it's somethign else entirely.
> 
> Anyways, I don't think there's anything to do in this series, but at some point
> we should probably do:

I would send a patch, but I have never tested (or did anything with) SMM
before, and I am trying to keep it that way :P

