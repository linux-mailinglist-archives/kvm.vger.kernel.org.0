Return-Path: <kvm+bounces-49927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF73ADFAAD
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 03:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 047EC189DB9E
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922C41A2C11;
	Thu, 19 Jun 2025 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aNrBfH9+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C73A18FDAF
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750296438; cv=none; b=loMid6ArYPbGHZCxNDHoKUDuWNSzMAO3ukzYBG3tjzrEXnq3kah7mlLFmW9Bktko1rWzF2c6PqbWVI3sznWsn6O2b70m4KbFfg+WfuGBc45buXZw+gPIOSGyDflc6Yt8XAIlAPpgDxd8Vjqxq+Hzi9xhr19tsC/yit5tWZZw3CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750296438; c=relaxed/simple;
	bh=vm4zc61kQIKBtTJCoGSRV55SShr3qfwIna2hrOexzxU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lUiSBZAGeayQeil4X6St7juNYCM9au0y4+GGQF+L8Hw3ZjtetPHnQi0UhW7Hq6AsVh9xi2mUc+dHRqigOxKGqiwZGvkz12B7xi59FBHe+C7Z2L9iVL9rIbW2kxs/EdnhGJCw5I9a14qf3Ki90PPG9IoIkFJ+LMkFZ183pVdWmcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aNrBfH9+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e3f93687so3965835ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 18:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750296437; x=1750901237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFJAbnmipeJwNloKOstVWAEzz4JfWsiupTDJwINriZo=;
        b=aNrBfH9+7vQpBvjpkC9D5464tuDixZl23TsJBQDcNgLL0KXLkX1t/EjewGgqu5FHyY
         58BNdZtINaZAtWmMnnQ7R6/9qnuSQPVs9UDMlxql+qFhGQwyw3s8xa5Vmfxr28cw6PKy
         Urr9/WbWuTyC97EP0ivHMS1OAEWBklPtw+FeTLOSwqZ1f88VoHEGb+If9nlEkoxYzA4e
         eeVB5QvDLyK4Ogl4z5yJM+URjXnNSsPHT6SjBNM/YAuzj8VDLLXOuCjR1k9WJBQPptuf
         KLpa9yFMS3Tj3ITMErsUuCgsW/NJM8gCsQqiiBiQBf9uxBcg+HEg9SBGq8pYJ7KcJqsg
         Gmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750296437; x=1750901237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFJAbnmipeJwNloKOstVWAEzz4JfWsiupTDJwINriZo=;
        b=r7PYzGbkHTHJaWtDtk2gOpByZh2olaoa4z+8jQyK0SQ6u2w4Ow1CBST608XGgODXIY
         KO/pEc/1I5c6R9K4It/T2vE35pU4QAsyQnBuXr+IWBq/ZHCe7DFmBs+B8E5fDqMr/Uo7
         cA9YSqtTyvSNWsIQ8cuet8TWIAslztUs9mragp2j0EZIZViowoFObK2lsOdC1RH3Vv8O
         8/z3C/gREN2MO27RrzgFluYt9rV1tkEx81eEiDOLSzbBD+LVUyksW1AyQteFBdS6de83
         Ympl1spE24qN0I6V7ZUxbFu7S7RouFgbq23KJDioxtHuWpu/moFHAHJzP2f7RQbUEffF
         S/mA==
X-Forwarded-Encrypted: i=1; AJvYcCW4cQT6s+T/fgRSNhSeGggHY3ckBKf1FEXviS8NOqkl4z326yPeq6isCgwxUrZNu+H1I4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxCTZY5pypPO+myToPCce7T7decKgdrT+WgfyETsVpiaM0VuqY
	QAdM08uXInbuBBkDnJkaxdOjDwBpNB36O27Byg5Nj78BYsg8nl4FzBH69vZ8QAFepRxBppqnut1
	9j9S3xw==
X-Google-Smtp-Source: AGHT+IHfYw3saIGenxdx6hofcNW6m39z+U7j5TjuceZidjPioll6tGDxZ6q1q2NRMsSKefNry3vZpYE+zns=
X-Received: from pgnr29.prod.google.com ([2002:a63:8f5d:0:b0:b1f:dd75:de2a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ac4:b0:234:9fea:ec5f
 with SMTP id d9443c01a7336-2366afd3a91mr304909275ad.1.1750296436711; Wed, 18
 Jun 2025 18:27:16 -0700 (PDT)
Date: Wed, 18 Jun 2025 18:27:15 -0700
In-Reply-To: <aFNBCaLEdABfybmd@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com> <aFMWQ5_zMXGTCE98@linux.dev>
 <aFMh51vXbTNCf9mv@google.com> <aFNBCaLEdABfybmd@linux.dev>
Message-ID: <aFNnc1hZEWcU0Nh_@google.com>
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Oliver Upton wrote:
> On Wed, Jun 18, 2025 at 01:33:17PM -0700, Sean Christopherson wrote:
> > On Wed, Jun 18, 2025, Oliver Upton wrote:
> > And this path is other motiviation for returning a boolean.  To me, return "success"
> > when a uaccess fails looks all kinds of wrong:
> > 
> > 	if (__get_user(chunk, user_chunk))
> > 		return 0;
> 
> Yeah, that's gross. Although I would imagine we want to express
> "failure" here, game over, out to userspace for resolution. So maybe:
> 
> 	if (__get_user(chunk, user_chunk))
> 		return -EFAULT;

I toyed with that idea too, but if kvm_do_userfault() returns a value, that it
bugs me to no end that the callers blindly convert all failures to -EFAULT.  To
avoid that, callers would have to be:

	r = kvm_do_userfault(vcpu, &fault);
	if (r)
		return r;

And that just annoyed me. :-)  But I'm a-ok with that direction if that's
preferrable to the boolean return.

