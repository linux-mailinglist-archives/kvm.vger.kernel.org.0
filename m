Return-Path: <kvm+bounces-71412-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKEOAbqWmGlaJwMAu9opvQ
	(envelope-from <kvm+bounces-71412-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:15:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 246DD169A49
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7C21C3012A88
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D46832ABC3;
	Fri, 20 Feb 2026 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MusjWFB4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7391130CD85
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 17:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771607732; cv=none; b=QdSvMwvst67UWqH7gKM4ETdGEbnueMzaCG4ciFHX7pidoJ+0rhlc0S8f2OjAEdEflWs8jsh6snXp9z4s/4IfSzO4i6aHxJnphSP1qMoo+K+7pqdpk9rcCZlgNbQYIEQWnmWeNX44xbcYL+kmwlXJd7dT+sG/GRl0mgyMvOAcKS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771607732; c=relaxed/simple;
	bh=xh1l3uM68eCJR2SH6gaUCO0N9alFSIukiARRMNTDClo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ciGRd4E6iovM6C+vp1hrbBwkx2Z97SPbXnLbisR/SSloXRQpSo4vYSbWYcnWsBqp5Agjyo4ZZuDzMZzad09t2ho5RLc4GpPfraTo1OBFes4L19PNytOYgf3wVLMzeuIU3cQPHsdcn6+MsaXrOXUtqXZnJDddV/jYQbQRcizPDCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MusjWFB4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562171b56dso2417837a91.2
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 09:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771607731; x=1772212531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vXPc2TVPq9CrPzaqQARpE12B7qXqTUkpOVKjyqscmPY=;
        b=MusjWFB4S8JahUL5FvU543fZbIRz953ZP9q9enMGFyz6/rcGjvud3CGJNRcc102tr7
         8UDaDhAIcmfn3ghT57olGwLz0Ruvj9VFCiW0ZJsnCw9M2CwKYZC7mzhWIoEckS8nvjc4
         mMihEBg/tkhBIaCBRcwDxOkaDCReJsAty6GXViioyVc7LVQpGzNKY1HuHeKA5VnBGFUN
         h3JFc2CfG1P0HZaVsnR8iwUw7s9jUUzjBCXkeNd/v3kP0/bbkTaCobCLQl4CmsG1bdi+
         JDDEcixo2mPrbHhASRrZ6gLjihsRSKVvgJz1TAIAa+fmEto7Tn5bpFCiZunqZbHUDWOC
         rnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771607731; x=1772212531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vXPc2TVPq9CrPzaqQARpE12B7qXqTUkpOVKjyqscmPY=;
        b=ftR2C08TkIH0iqVK7ahmyYahws2N2H7nPwWbfgXSYRwO97aLWm3Ye+jaOQEFnF6IT2
         Es7akKJ83875cCLIF33EMAwhUfURSXsLcgSJlrLbfmxJ6ec1W6WXc/8gm3xV9MZB+v8e
         hu3WYlUAIt6MmbmNUsugmR2O26Y5qnokye/1usctrnu7xI2iQnqECL5SUrK6R2M/tho9
         N03OwOqdCm5tkI0Str09ACzYiYTRpPyADhH2h5pib/HYXXU8GdnQNjmchlGucwBCMciz
         NaIbXoQCNltiG3j9oV78pPSflvgu+njcii2LFeWPjVhfXHNypR8jIEK7xvamOEdKJDGt
         s4Ug==
X-Forwarded-Encrypted: i=1; AJvYcCXQp8Mlrf8KdJjSv4FVRUCdPvJZ9xeZZzfvCa7MnQWtibyIFsRHXetgQbvLuhv6w926B8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSpKhGTpLfOkfvf2E8FJsj2zpUoO99eQME0QUzR3FRNWSmlVWk
	8hL7DWll/fZSHmI9alLy7o87uKFgX0P7nfjd4++mhBTpbG8u/hr9ZL52FUJwF79GAC8KwdCIfrx
	JToN95w==
X-Received: from pjbmq13.prod.google.com ([2002:a17:90b:380d:b0:34a:c87f:a95a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f84:b0:341:8b2b:43c
 with SMTP id 98e67ed59e1d1-358ae8a4366mr402595a91.18.1771607730730; Fri, 20
 Feb 2026 09:15:30 -0800 (PST)
Date: Fri, 20 Feb 2026 09:15:28 -0800
In-Reply-To: <20260210072530.918038-1-lsahn@ooseel.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210072530.918038-1-lsahn@ooseel.net>
Message-ID: <aZiWsL9al0LPi0rJ@google.com>
Subject: Re: [PATCH v1] KVM: Use memdup_user instead of kernel stack to
 allocate kvm_guest_debug
From: Sean Christopherson <seanjc@google.com>
To: Leesoo Ahn <lsahn@ooseel.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	"open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71412-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 246DD169A49
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Leesoo Ahn wrote:
> Switch to using memdup_user to allocate its memory because the size of
> kvm_guest_debug is over 512 bytes on Arm64 and is burdened allocation
> from kernel stack.

520 bytes is a lot, but it's not _that_ much, especially since
kvm_arch_vcpu_ioctl_set_guest_debug() is leaf function (ignoring tracing).

Is there an actual problem on arm64?  I.e. does this one particular allocation
lead to stack overflows that otherwise don't happen in KVM?

