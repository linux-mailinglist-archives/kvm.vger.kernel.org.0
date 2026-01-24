Return-Path: <kvm+bounces-69036-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJsTALB5dGnU5wAAu9opvQ
	(envelope-from <kvm+bounces-69036-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 08:50:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5237CE1C
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 08:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C161300FB6A
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 07:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D114429ACDB;
	Sat, 24 Jan 2026 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ok97up28";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bCGwrVxB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EFE23D281
	for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769240998; cv=pass; b=RJrAZ3JjkWiqOnH4w5kyILf0jeQBzo5mv4DafarPAnxw9GtPM9bYgJU5gLefQQtSL10ay1ozs7QGEXSatZpUtVNWEwT2gJ9o/iRqnRWjBvxmAEZ6CSm+fkzPUX/JjUBAgmGnkwqNu1ygWNmzZc7mFagPBl04RuKVKi6xexskCXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769240998; c=relaxed/simple;
	bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V465vl5EWrkkUEgGN5q3ZXPiut0gc3GTsqXwmWVAai5nMT2kkP8sVyXl/jf+H0aXZFNyRzrI9A1ioYV9bFVYf9FI+BCMDfeYjiaobm6kwchTX4iQ+VkJqee3BgM+/tHIL+DklkYBTFTW72L7pgtoBFQNC5o/2kIE7ANF6NYyef8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ok97up28; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bCGwrVxB; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769240995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
	b=Ok97up28cwKzKuP+BwTkQqyLnQji+fmpvR+421Kl1UxREhVEKI9QEBXxtxoyxEmcNL6x5W
	VBHafoFohNpvP8u0TuMEbo+EUR1MbW51qu3rsO3KWYS3q/QHW8ldsLzrDbFtkuI/vg+6ul
	jW7c5S/bM2edBn7xKeUJ/A5MZLLw06g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-BKYnaO5tMTO3-z7s2iWWZA-1; Sat, 24 Jan 2026 02:49:54 -0500
X-MC-Unique: BKYnaO5tMTO3-z7s2iWWZA-1
X-Mimecast-MFC-AGG-ID: BKYnaO5tMTO3-z7s2iWWZA_1769240993
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435ab9ed85dso650602f8f.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 23:49:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769240993; cv=none;
        d=google.com; s=arc-20240605;
        b=eIegWbU2yjzlgUC25W4Gfm7H8VaORlRP8kJT9jyCCDogMXZVpZKyUAeKz5dm43t8zc
         8TdRNodcxrth/iX9FCN2PjKPAYGlRrDwOCXtwC3KhuaUP5o8GzHJMcZfcA51gQT6CMpk
         uWg2NRi8oPa18euou2xj8qSoxJYq8sbDF5jQwZ2r5Yshraxwe4oakjKS/a1bS2AenLqK
         OQBovecjXlkGSdoFWFNETxcBUvJhjatfPk48Hndujf6TLDb7kGVcapk1OByA92h/F2H8
         +097k6Bd00IfJfAud3cDtp6DrfWDCvOZM24ubAMLKfBJhv19gbdekM9Y1e+7J0n0ubKx
         9u2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
        fh=ZugPhG6h2iUmJXkueFng6Uw5S8jiLHdMxrA1Wc9hvUw=;
        b=TIMSOj/thRiwmd/2GyUzmh8EGXg4FFxHba2l4BqEvJExEnK+loT+SmWC9z+3vl7cL6
         FAarx3gkeQCXKlDuRj6IBzLaKpW89Zr9AdFU534LQqku7gc49FovbaPwtS60udM5OP4S
         uAbE2BLm68TnYmlYrEgbWPIvqIP2q+aSkkqMRa9u0nA6zNCPvCvrgX7Hw6FmG9QTY5jl
         +Iku6fNhzJ94u0TaTtlEG5ZP+dqqZDgfgXV5EzRE7dSDwE6wzVZI7fKeybFIOy8zPZR/
         Xwvva5ns/WQoi3YHbfWxHUP7hfcc+sV4plBzS1AfRYqEA5zd57WN20IzRZvsvc/fCujn
         afhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769240993; x=1769845793; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
        b=bCGwrVxBRW+G3YPfHdZBfVsW9u4h2o+hYQm7KKq6lupnkR/7bAeAByTCI8y69IYkiy
         CgVWVIP+wZYP0D43VhO14n95x8IK59SwecT+ja/oPMDhA2fEcwmtdPlMBi3+3Ag3WnoW
         2NVFqQE/+XRzTbSZ8Q2HEIMgwuej7it+luO+qaFmsAJwNH4uj+DPgs7ugHOdYmwQYQ++
         Pf41yVKCGb1Txf/pFDsusU+EUBeO4933MN+KANej1LXJKrFQH/LyTuhai1c9jZ9podHI
         yq4Jed1c2OL4Km4ufHsa0wjgJDer6z4xMfG+k/VcHgywX0/1H8k2EXRWEAlyCxf46rO9
         6fcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769240993; x=1769845793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
        b=s/9/aU0+kmWXI3MVl1gB8DxL58ZPbQy0kIK+YpV3xhbFEqB8Orq+hb/g9xZ7F25+vr
         zmhduw1mLgRrx2lx9BDLUWA5FaBMEDIlSdsSgkp9btkawGy8vtgizNbqmT1NEsjM+0bF
         HG5KuPk1s+XhKPwWxOyuHvHwqoZ6otWmZycrvr+c+NeV3cp7ESQDp4K6T5yBL7GAl5ly
         t/5Z/1g2PPN/QXE7WDYxZtxqP7XS2xpD+Cws2EN9o1c6+kJUcJp14li5jxVn9NJUQheA
         O736no8JC3SckVzBEV3NMj+RgQbCKjV9f9HYuvgpCC9TcPA1qohrg3Lt5D0YOEYSsVE6
         E8Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUfYbRR9GAVkZXWhKK9as96pgRvmFZd5V8bAFhOtIkDPcf+tzkBiQlA1XkSTSfIsBSB8jk=@vger.kernel.org
X-Gm-Message-State: AOJu0YymMgLXU/k3xMlgezc5vK/U9F8BKtzErtSh3Z9raWC1MIMHDEk7
	M29vsG2WbJyk5J1YwNwm+bSQgEmprEhrZrJh+BGmMflIed0e5btVMYWRmsjF8xEMjFjfXLX8Mus
	PlZJkGI5+zZpsHEdHkzXC22wbmECKVMqnyABi9sIk7USfmJpXxLpquOBjGdexGf8Ktv+wKWnGGp
	QlQ31RNUX+CDN2Olif37Ga5LwJPwCJ
X-Gm-Gg: AZuq6aLhaKnIyuZuwmGdDqH7RIEYTMjGNwxSquz0NAhZs3sGkIFzbYwy/FAy1/BnYle
	9Njx/C549VlAokLGMbpljbhO7epQy6KRVvxEJupWRw6NdYwkh2kFpaQt+foGvHES61/5IxlB/HZ
	zrjteOHLlEdsG+eEtrWzzpkpV87Fm0MnB+glpWhZUNx5a9EfzhvFd6irWqQ3TTIpWnyKRRPOoyz
	mLomNHyavK72yA4Vu1ijqwJUvfZFciJz00EOcrrbPUc5X9vYLEBPVAvo+J2DS43tCcVbA==
X-Received: by 2002:a05:6000:601:b0:430:fdc8:8bbd with SMTP id ffacd0b85a97d-435b16039damr9146808f8f.41.1769240992694;
        Fri, 23 Jan 2026 23:49:52 -0800 (PST)
X-Received: by 2002:a05:6000:601:b0:430:fdc8:8bbd with SMTP id
 ffacd0b85a97d-435b16039damr9146785f8f.41.1769240992303; Fri, 23 Jan 2026
 23:49:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <874iovu742.ffs@tglx>
 <87pl7jsrdg.ffs@tglx> <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com> <87sebxtrgp.ffs@tglx>
In-Reply-To: <87sebxtrgp.ffs@tglx>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 24 Jan 2026 08:49:40 +0100
X-Gm-Features: AZwV_Qj6aLwVSas8vwNUo-Ndu2FBevRcUQp0THPxC18GLGDTRk3JARciXPkQtdQ
Message-ID: <CABgObfbijO2k6fe6z03M3u--4ZKXxwPSf2RrasU1=J5rtj9CUg@mail.gmail.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
To: Thomas Gleixner <tglx@kernel.org>
Cc: Ankit Soni <Ankit.Soni@amd.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, 
	Naveen Rao <Naveen.Rao@amd.com>, Crystal Wood <crwood@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69036-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,google.com,kernel.org,linux.dev,8bytes.org,infradead.org,linux.intel.com,lists.infradead.org,lists.linux.dev,vger.kernel.org,redhat.com,oracle.com,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1E5237CE1C
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 7:47=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> On Wed, Jan 21 2026 at 19:13, Paolo Bonzini wrote:
> > On 1/8/26 22:53, Thomas Gleixner wrote:
> >> Are you still claiming that this is a kernel/irq bug?
> >
> > Not really, I did say I'd like to treat it as a kernel/irq bug...
> > but certainly didn't have hopes high enough to "claim" that.
> > I do think that it's ugly to have locks that are internal,
> > non-leaf and held around callbacks; but people smarter than
> > me have thought about it and you can't call it a bug anyway.
>
> Deep core code has a tendency to be ugly. But if it makes your life
> easier, then these wakeups can be delayed via an irq_work to be outside
> of the lock. That needs some life-time issues to be addressed, but
> should be doable.

Thanks for the suggestion---hopefully it's not needed at all and we
can delay taking the lock in KVM.

Paolo


