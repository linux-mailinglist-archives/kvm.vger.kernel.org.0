Return-Path: <kvm+bounces-22071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 421FA9396FE
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9C1C2827C6
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 23:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE20F5027F;
	Mon, 22 Jul 2024 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MMAuQLJG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED6A4D584
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721691009; cv=none; b=ZmP+9vMPzp1qjK0aNr7Y7evh4khfgDroMsXl+YVr4/N0pcGxgsWyd3BUI0Hgr7YS0c65B7dfdu6ckXRMKmPrY+UG1lW5xyXVUDjvz3yfiDyYu/r85IBEo7TkWp/hQdeFHXuKdQBbZzEATbFVJvbVb7kPujJu3uJOd9GVZg6PETM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721691009; c=relaxed/simple;
	bh=50W+8mOf5oT2ZgPwKo57Acc+wlJOIgj2xhu/ig30r7Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SKoYvgT7ar30PaoKBEj3ALxSe9M5zw3ctrKa1Cz4/fPFmkviyYaOeqMVnxtLidC+OC2dnEwqHxx/6qIkFZd6j/Yox+3keobqj+6UlU+5iqJRApQDCVKaE5rq/esv2wJXs9e6gJPsbkwDxecLhhEDH6IgtGiJAI5gIRaB4XcUu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MMAuQLJG; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e033e353528so9290283276.0
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 16:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721691006; x=1722295806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CT52fA42ULSwMbS28vOqpAMMtaxYXvYs5fxzjIhSTH0=;
        b=MMAuQLJGWZOZSJGQ9IImKhL+IB/c2A4tp2kN5srAAtMWQLkEr6Wv8kkcSHqANpNaVv
         bynFUDxpia5Hu339SjYh+W7VvpCbV5lMRl2hM3EUUZlJhkr86BLGIFBsLW/y/dXhOohb
         4WYIYhyKRKEm4JCLaaHunjeTNGP6t5ECGPtLw7mIZ6ZSCZGQpcMTuJKmOuaIXxR4RQKr
         igsTit9h5fyd3CR8/U4tXcHbxAFdMpZH3lbsp5qYZ73VZ6S00s+wO9Bnx09He/y89hwg
         pSdnMlz1c292qmO/NVsqqeNr/hT+XEN2eIhJ+c4im5ymJexRoOjfWbYP4EZ8BFp9KXFP
         cgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721691006; x=1722295806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CT52fA42ULSwMbS28vOqpAMMtaxYXvYs5fxzjIhSTH0=;
        b=JpiHPD/wqpnbVWSBzZAgNjbLW5FaqgNNpAVTg3Bljn7si1Ab7EJldIWDQycJBic5yE
         C27oOm+YW1StCWXUH0GRmlqrz6IDjj0NJNKxWL3InZK2Z1xd6m/SqQCXq0wcbKeGFVCm
         7FOr/iDPG0yA1x1jfP6ftoYxMP8ugSAdRF3+kGhU8aKZvjMRJh4WoNex5Dgf8y3L2n4S
         7toSK2k3Dezh0TWSLIZcalz+yasN1gBbpaWyZlDKoYKoXgIvHhl1IIUqKRdKmmHhOJ0b
         jXDfWQY4fg46qSoscfIUgYDiiC5MTZewc7kphkmO/SBMDGz4/yDz2JkDy0ZId20fvpRe
         2wlQ==
X-Gm-Message-State: AOJu0Yy7mHXp1cdvu6jZBSWUVNThKHPFOBi+NIBZvGu7IUsBEQoRjq9P
	o9WZKwRL0WdR5VD1HIiOgi1Pl0kiHI7LSqHLtjXJ/IJqe+MR3QI819LOFacKSDvRLLYt/n4/zGv
	fsA==
X-Google-Smtp-Source: AGHT+IFNs+/2hSgf+AJ9Cyab0VhWImUSXPEIK5yU9cpGk8LLruW2Bue6yMQkA0A2x7nFhg7otqvD7YHGAr0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1006:b0:e05:6e45:84b6 with SMTP id
 3f1490d57ef6-e0870422791mr29610276.8.1721691006328; Mon, 22 Jul 2024 16:30:06
 -0700 (PDT)
Date: Mon, 22 Jul 2024 16:30:05 -0700
In-Reply-To: <23f30de150579d4893a493a6385f69f6@cock.li>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <23f30de150579d4893a493a6385f69f6@cock.li>
Message-ID: <Zp7rfbJpNDyhaZQO@google.com>
Subject: Re: [USB Isolation] USB virt drivers access between guests instead of
 host -> guest?
From: Sean Christopherson <seanjc@google.com>
To: privacymiscoccasion@cock.li
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 22, 2024, privacymiscoccasion@cock.li wrote:
> Hi everyone,
> 
> I'm coming over from reading about Qubes OS, which uses the Xen hypervisor.
> In Qubes, the way that untrusted devices like USBs are handled is that they
> are pass through to a VM, which then (I presume) allows other guests to
> access them using virtual drivers.
> 
> I'm looking for a theoretical explanation on how this would be possible with
> KVM. I am not a developer and thus am having difficulty understanding how
> one would let a guest access virtual drivers connecting to hardware devices
> like USB and PCIe from another guest.
> 
> Any help/practical examples of this would be greatly appreciated. This seems
> to be a hard topic to find and so far I haven't come across anything like
> this.

In Linux, this would be done via VFIO[1].  VFIO allows assigning devices to host
userspace, and thus to KVM guests.  Very rougly speaking, most assets that get
exposed to KVM guests are proxied through host userspace.  I haven't actually
read the DPDK docs[2], but if you get stuck with VFIO in particular, my guess is
that they're a good starting point (beyond any VFIO+KVM tutorials).

[1] https://docs.kernel.org/driver-api/vfio.html
[2] https://doc.dpdk.org/guides/linux_gsg/linux_drivers.html

