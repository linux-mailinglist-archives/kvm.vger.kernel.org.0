Return-Path: <kvm+bounces-71293-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIJQOzNIlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71293-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:16:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B5315ADC1
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAD713071F3B
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8798033A9F8;
	Wed, 18 Feb 2026 23:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zq463mtm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45C933A9DE
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456361; cv=none; b=urHgwWasRWOPNZEbOU2Nve0cvowK9PgjqgJGDfkKhehnbHfTZpfKLGvjtwHVzfZSu2R50HZ/KOmCs8/5/QspnOOU/mzledQKzWrm5nPMJ/cGKOMy6zttJn552EYNd9pgJa+R4g/Wy2svfwtiEpXP9dGM+wWVcm3quoRiFLQquEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456361; c=relaxed/simple;
	bh=J0OEKES3G7uLLP0gC9Q6SUYN7A1Uk5HZtzFIVnAXE8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dLEYQNcxnRzWHlQXM/A2zsV2z/TwT11Kakfu9euIQRjeRzTVhuCWQF8rhNactbBejXkkQccWTJFUfH4mLaBPl5pzIO1774Ww/YosyIJ0U+mu1yyNzopo2bhZHRLwAfCisHYU1fFJQA2dYcuu94UwwFkLW2cD9tKXmTRL7+dCZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zq463mtm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352de7a89e1so259959a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456360; x=1772061160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wDTU/+n7WxF2jTJpTD2DZkMo6ds7ZDdb6/ZoYXHP1ZI=;
        b=zq463mtmVNFvEj8x8e6x49W+PN7xoLXvyxQ5Tsds/o6oR5F72UIpO3mJlnkeKjovcA
         Q3d4/9RzWMOMsvNn8IThTeLdlG8AkNgZ7BPKYAgMJoTmNE6LUica762LWc/kRtvRtp8A
         +eaEZ02uFUKkwThGf7p2MRokWuK3/SAI7Io/sY1Tuk2IP+5d9qV2eDcGgH3Z5LLaVn8K
         OHVn9ndHKxv7wHzy1zLF8o2J1HqRUtTKTSCXOGbiovhxR6GUup3E3x8mJ52gNYy4lTO8
         kzQIkpqAHeH+fDAlooZokVDxvpAEUM8kCcOeMimGuigUAukN8R8XvZIchEluUFPsstrv
         oSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456360; x=1772061160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDTU/+n7WxF2jTJpTD2DZkMo6ds7ZDdb6/ZoYXHP1ZI=;
        b=DJAhxmQIYQgQsMqVYMyQVqCev7aZjkirLCE+tpXjJWDAy8ORuKt6FRP6qpVnjKmJSR
         HIspWQeH2RypYO18BhW1Hqms1TJz0LZ+1HpFcDnp2rUnhi/sneTNMIRYpCvs7mNc9y1i
         +jZnK9bVYBL1GouN8g/GBdfuIi1sRj0YtfR9upMx7hv3ak+NgikXJclsrCk7RzkneTt6
         VPxDacC2F9tUA4HSXRToxK5DyEym+8BrX5IXQj3R3YpjrvSbQMgWJomqEeHZdc6AoAn0
         nYARF8oMc3ZyO6KP49PTxKPjCRdjCjghlvk2kUSiq26gA6oOMN1kvIAyIiq0cKc1J6yi
         EyNg==
X-Forwarded-Encrypted: i=1; AJvYcCXussVCIGEM2O3ZYufTq7NZW5dHSmHT+1lqHsNea0z6IXwMpZ3izgOdTTmExHjZQxBi0ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnDwBMnX6OIAJED/dDoTk8PtgKlS+CReWK23MhiSOH4N400uhb
	1y/kRxy6kdQdooDfBf1CqBAtCBEBKb2D16cluSuV7NPO+hwS+IDxB1AJX+mMFEM+Gi/vPcf7yv3
	XHzIahQ==
X-Received: from pjzb12.prod.google.com ([2002:a17:90a:e38c:b0:353:454:939c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b92:b0:356:2fc5:30f5
 with SMTP id 98e67ed59e1d1-35889055dfbmr2539808a91.13.1771456359932; Wed, 18
 Feb 2026 15:12:39 -0800 (PST)
Date: Wed, 18 Feb 2026 15:12:38 -0800
In-Reply-To: <20260211162842.454151-4-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260211162842.454151-1-yosry.ahmed@linux.dev> <20260211162842.454151-4-yosry.ahmed@linux.dev>
Message-ID: <aZZHZrohXehS5G8Q@google.com>
Subject: Re: [PATCH v2 3/5] KVM: nSVM: Move sync'ing to vmcb12 cache after
 completing interrupts
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71293-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: B9B5315ADC1
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Yosry Ahmed wrote:
> nested_sync_control_from_vmcb02() sync's some fields from vmcb02 to the
> cached vmcb12 after a VMRUN of L2, mainly to keep the cache up-to-date
> for save/restore. However, NextRIP is sync'd separately after
> completing interrupts, as svm_complete_soft_interrupt() may update it
> (e.g. for soft IRQ re-injection).
> 
> Move the call to nested_sync_control_from_vmcb02() after completing
> interrupts, moving the NextRIP sync (and the FIXME) inside it. This
> keeps the sync code together, and puts the FIXME in a more adequate
> location, as it applies to most/all fields sync'd by
> nested_sync_control_from_vmcb02().
> 
> Moving the call is safe, as nothing in-between accesses any of the VMCB
> fields sync'd by nested_sync_control_from_vmcb02(), except NextRIP.
> 
> Opportunistically make some whitespace fixes. No functional change
> intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---

As discussed off-list, I think I'll skip this patch, I'd prefer to go straight
to addressing the FIXME.  For me, the ugliness of the FIXME is a good thing: if
we make the code awful enough, we'll hopefully be more motivated to fix it :-)

