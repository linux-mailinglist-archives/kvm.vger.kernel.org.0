Return-Path: <kvm+bounces-72841-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFb8Mne5qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72841-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:12:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 411BE215EC7
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:12:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5AF531AD1CC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC93366835;
	Thu,  5 Mar 2026 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f8A3mvjM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B517738E132
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730513; cv=none; b=CiIt9aAWUd+9grRewKX2nVKGqDVxIzYmekikrcRmTM+56knGF/qeDUIevFg+nDEawACW0a+ZclV9gxzSMFo7lvLj9NtIXCP4ElLiaw8Eh0Dx/RelA3Tz0kOlAHlQumBGdH6HvkeKXy5KDGnRS0tbPhcys9DTaDCQr/xnBvKxy/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730513; c=relaxed/simple;
	bh=zwg03FMczjDMgy/eLRoPdWLzs1gOqGtEghqgOEAdAN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=cpiFg75u24V1RRVU5/IfJ+7DirkfUdgaARwO/3coBviCcT90dhXWF5MkhG9cfoOsq+I9GktNtoUMDZB2bjYvPUUtn5K+fUq2r7WzKwkuGreFoqI/3hru3mP06nl9ZTKkE31txbhezJO4sAg0WHWbUF2/pGOmWD8epIROtQ5zx48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f8A3mvjM; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae47b3adacso46968755ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730512; x=1773335312; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E1UlGfT0u5VuDeFsuylXs3AKZjSLfcKICQ5Yv5XyQ0M=;
        b=f8A3mvjMkTxtyk81hy8R3eE+q3U8o99RMBuCmpAc/OQLFNxrQ0oQY2gPRRuCluuArm
         ijR9j7O2BAuP/rX0CA0GP+qg2yp7Uj8CJr6BoWCjHnw95+EKaZWHzBGZq/QmwwiJBdDa
         txT0G5p5Bj9FbigkO/npZHP9zGLbBdh146wMYLWLBsqvOol9dLCTIQPDW5SeoEM9GIyj
         e6eYW75/cIesgEM3QyXgjqjFOQaoAi+zNKLJ9TB77Rt8ux4J0/w86LxrKxLSuHoDI/HG
         +cNDDTmauV5vunNYBGbjQqYC5jDTD6bek18MAb7mUzRsIpPZiR4JwPddX8qa6mB/R4KV
         cg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730512; x=1773335312;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1UlGfT0u5VuDeFsuylXs3AKZjSLfcKICQ5Yv5XyQ0M=;
        b=kYr8FMkCcRITTiXMcKpDWHR36GOza8K57WTZMMTVLgMbT+9ObCo1hPP+7p50w0oLXx
         fF0ypUlnp/d3txc5pvmLdBqe4ZtxHwG1p0fFbhLNrXE0h2RrWal1XGIM7AQZxTweuZBs
         jRsqfU9MxhIf8yM786eF3Q8Y7Xjb8JLaN3iaPcnBUjqMVMBBrfsmKQeUpJqb37Crmouo
         kk1E/qrTYI9VbU32RfYv02013LuunsRGcGLu8aqdKkmSCSdjj8Plw7XSRKuYCAdaEIcV
         eId7G6Xir2ERDdtRK0hf3lClnB6AUbLCZ3i8u8LxMyZnFKU1GTw6pXynwnXvPz9JJ0SS
         AZJA==
X-Forwarded-Encrypted: i=1; AJvYcCWymy6/NsGX6ecjM4rJW93LQhTB59Pl9vDZHC4jBgv7mnDquhSEo+HjrR7CKI3izE2EO8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG5ge0AYuCIaBvLzfc7pMXUsuj6NHUNDPQ3y9k7gB0jruWAyIi
	LvSfSYoo6nTinUakR2C2uNNIdF04b0p8jqOZJm4BZyOmwp4Afb+AuiWRYMj6ytLDuMZQ2DimEu4
	0WoUwLg==
X-Received: from plpg12.prod.google.com ([2002:a17:902:934c:b0:2a9:63f4:124])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e788:b0:2ae:50ec:fa27
 with SMTP id d9443c01a7336-2ae80254c5bmr2932795ad.45.1772730511812; Thu, 05
 Mar 2026 09:08:31 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:33 -0800
In-Reply-To: <20260204091206.2617-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204091206.2617-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273036859.1571877.2315265496479229970.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Fix SRCU list traversal in kvm_fire_mask_notifiers()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 411BE215EC7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72841-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 04 Feb 2026 04:12:06 -0500, lirongqing wrote:
> The mask_notifier_list is protected by kvm->irq_srcu, but the traversal
> in kvm_fire_mask_notifiers() incorrectly uses hlist_for_each_entry_rcu().
> This leads to lockdep warnings because the standard RCU iterator expects
> to be under rcu_read_lock(), not SRCU.
> 
> Replace the RCU variant with hlist_for_each_entry_srcu() and provide
> the proper srcu_read_lock_held() annotation to ensure correct
> synchronization and silence lockdep.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: Fix SRCU list traversal in kvm_fire_mask_notifiers()
      https://github.com/kvm-x86/linux/commit/68c0526d8c07

--
https://github.com/kvm-x86/linux/tree/next

