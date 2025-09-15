Return-Path: <kvm+bounces-57644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 407C8B5881A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 01:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C806D3B2239
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78723280312;
	Mon, 15 Sep 2025 23:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WMH/fo43"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBA035966
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 23:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757978228; cv=none; b=TWnBjDkVHaI7fZSHMg3aqHtRGbQ994/df1HIWEX9+UIr9ZOThxlXSUXISnLFeILHJqcpQk6YVRcyyLBf13uVLifiJk5UldvMGfRjez4XImbxoRbrQkdeNye48yVfO/5ipJraJD/dj2kmYNt+Y2nerEi4cS2DG2q0HZvKz2kRcwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757978228; c=relaxed/simple;
	bh=l2V6fqYdfiJ2rTODCexBeOju2EFBX4wPVJq/6B9yUfc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M16vY3LJOS+oTqKh2yH6ycHIe7P36LKpQZ9NatG6UTO5sQRyaEdHvnljKV+UJkSJyib/CCM4wabSmeQpvPfUqESthCIF1T4tDyvRC6Ki48Eqfg490gEMeqBw9ba/Ir9rTwsZaP9gdw+dukVtTLUSUX1cXx5E8UX007JyEgFFd8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WMH/fo43; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7761c58f77fso2512365b3a.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757978226; x=1758583026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hma1vPBbsEXqmme2bd6IbixZ1iibP1IsqkaQF+3E0SY=;
        b=WMH/fo43WHt0j0y264mfo/wpC6caGQVEcpjkK4jb+P5LchlfzyOMdKwrJbwUdFOzR1
         9c0Xejrm5ScnMDVt8gow9BOwTgrGWlsyheMpxzt9WyyZ2zcIG9lMcQf244nihVeflEKD
         Bx36miEFe7FTatIo9R6ZB5NWsM50MsaQK+2q1jeKOv0Blr2vOreOElJfoTfBVqSDTSCC
         ZzgXFJnt8cCYFLyVFrL/QFEkqnYr3ellDNWq+rnDs/3hVTPtarqXbOfAkkAyQr+/N1WC
         k6nnn5hUViLhpL5am23434xc80KV84rDRIOR691ky9vDM4WqWiyi4RgWmbQALgVUhkOw
         oXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757978226; x=1758583026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hma1vPBbsEXqmme2bd6IbixZ1iibP1IsqkaQF+3E0SY=;
        b=huqPS4Ok63ef+3G5IItZjzgTgKg9meMpB/+0AUKQH1FuMvDp+bPe1PVTHHC7EoVNlw
         OStktlH+6whBjbQuG5SSJ6h9Cb0XYzux04/Myz43MqlDSejH8zP5IuN17PPaNXv8CZ39
         PvZd+bTGc8EZmkWqKj92/yU9wH8/g0GTtV46/+BdTSx3+3xYdEFE/vTL27GleeqrD6dZ
         eH/83wnALtOSxeF/htz/LlZ7E617oLBuMoFvK9pbu8BwaFJQ+d+bj0owHmrWEIbWr+My
         LQyObPEUy1RNzU9Fs1TnV1ymoR0/wcyY58RDU+j+mbFnIZYmtOlY4bepJPLJGshxONY9
         VbUw==
X-Forwarded-Encrypted: i=1; AJvYcCW/RIhCAx9i6TzrdZxYPTgmKX4hx88NyfdnDLdAUwhQO+xNRuO5hk9t0F7nTxzUhFqnWP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKsXug6ehEMrfSTTlbPqjaVL4bUqZK6PhDTunTNrqfYvuv9A2K
	m2/nRlL26xVxqDENWv/FLEdxbbI00P2OflPj/3K4sAsSsDTk51z965b1szcZKDWx7TK3wQU0hI1
	34xvMVA==
X-Google-Smtp-Source: AGHT+IHkTBUEGzvtCuu9L3OjZgsiu32NZ7EieasyNzWzYBKU8EmnlZs3oTbnrfG1ntRbP4E+/v8feDxcqo0=
X-Received: from pjbsc11.prod.google.com ([2002:a17:90b:510b:b0:32e:7282:b66])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728e:b0:243:f5ba:aa9c
 with SMTP id adf61e73a8af0-2602b084850mr18141354637.25.1757978226496; Mon, 15
 Sep 2025 16:17:06 -0700 (PDT)
Date: Mon, 15 Sep 2025 16:17:05 -0700
In-Reply-To: <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
Message-ID: <aMiecWn8kZFXjNZ9@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> +	/* Enable AVIC by default from Zen 4 */
> +	if (default_avic)
> +		avic = boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4);

Got distracted and forgot to respond the actual code.  This needs a comment,
because intuitively I expected Zen4 to be inclusive of Zen5 and beyond, i.e. the
model check confused me.  But the kernel's ZenX flags are one-off things.

I also think we should enabled AVIC by default if and only if x2AVIC is supported,
because Zen4+ should all have x2AVIC, and I don't want to incorrectly suggest that
AVIC is fully enabled when in fact the only aspect of AVIC that would be utilized
is KVM's use of the doorbell to deliver interrupts.

> +
>  	if (!avic || !npt_enabled)
>  		goto out;
>  

