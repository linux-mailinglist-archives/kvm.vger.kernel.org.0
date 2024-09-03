Return-Path: <kvm+bounces-25750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 541C296A2CF
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876C91C22F6B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55E3191489;
	Tue,  3 Sep 2024 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GVr/BqKm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B3018734B
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377463; cv=none; b=n690desly5kzvcSN0Le/5I/g29qWNdqNATzZEy7l2GN7r8m9SEdKY2xEozKaUpH6u/AZOpjeJPk6u13s2/XAD81qTf91KxFUqFz7wimHoLiki+9wSQH4S2gdc+9K9C0nK5OkdYx6Bi6bfMaSZThgytyrhy5tsODNz9xP9hcS7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377463; c=relaxed/simple;
	bh=myZhSHZglPxRmX1LeF9hNvw0WBoOmbw90VRio1gUy/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mDj1JCzsSo/g0gjnloYeMFn4+zJzqoFgueW2jY96ByfTIcF4U0sDtGwdi5fDx7JxSKTc98SvuusK0fWBToIVE/0gssBltQ/ojN7o2JjFadg3l6Ta1TqoNwjmJ3JZG6iiJUcb5V7jakiB3RpNBJqoF9rDAXqQR8AEydPc16AdN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GVr/BqKm; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d3e062dbeeso62343807b3.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 08:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725377461; x=1725982261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ec7dmsuyq6MURvKN1Ek/X/vHghIhIMnPsF7++yal6w=;
        b=GVr/BqKmN+1FjYtqqdksxJxo8K3VG6iBCh5g+P7c1GolUYYGUE5mMN6lrLtOBO/tgn
         H3yBX30kH8cM+J5KUon5QiXNZ5NLcQSw6fdNPnPJiLGL5AobW27ieHK2s/86ngKQZ/e3
         HNTOTR40l2eAn/XVHuUg2YtvvcGKKDs6WwHOlhNJkRx9ACy/RfKypjhCgJOpRQVnOG5w
         KxmimPRoXgKx5L1iuQvGtBZWXE9KCNtKmZKq4n8fnNxyDLFYZUVF7BxSZIwjekgZ3BdL
         IDGnALM6fCMDHy7TBinurxpIMyPvGZ1L4MKWOAXzogvTZZNK2lQCkZG8rfg4xFwj81FN
         OXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725377461; x=1725982261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ec7dmsuyq6MURvKN1Ek/X/vHghIhIMnPsF7++yal6w=;
        b=HB3ABzzCq+LfnKd4CjEi/IrAj81kcFAoIT1Von92IuWfI3K7/+wtl6JDzNf/u5MJld
         GgCL7sM4kiHjzfUOC5MeTB5sMnWNyEmn65e2mrw6gKImE6nCiN5Ji18/KeNhdcNTV4Gh
         PkDvHcL9vG49ML0dlXtZg0mWF0/FnRUvztwnp7zRAsTr7n+W9wcldrqH8zT9Zob2HZBS
         GUEVAEtK6LcamryyN6r0bBgMwZ/JiYCxMJY+DDwPuaviKHTMQ+qmbt9NaiFirXnAHh8b
         8QyLnAmo4at/AacrfXD1hkpHQAAVLa7tKt1uBqY5194YfnqjUt4U0FJjEg8kIlPwF8t3
         zaRw==
X-Forwarded-Encrypted: i=1; AJvYcCW8KQP/WcPKBSrZUbIP+G6Hpymh286Mf6oblY3HvgzVTHdiaySlsqjCM9LbyAFEfmGNI4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YymDdcmWaprkDw8RRD8pCpgp/6UrWarMC5HkFJJ9/A91KUvUj7V
	6Z3xip8IifGZsM0mzP6lOkhooAsXiQJmzQ5dS0nRrtRfQQPh0+2/npS37UHSQKABTWWjMmXkgWY
	dww==
X-Google-Smtp-Source: AGHT+IEh9ne8KzfgecVZ/RaL9A4Ue6g6HIetOniUqznNH1pR9H+ZBj1JoJsiAHWXhWwmsoKvuOIyhj4bnjg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4d02:b0:6d9:d865:46c7 with SMTP id
 00721157ae682-6d9d86547dcmr1285427b3.2.1725377461550; Tue, 03 Sep 2024
 08:31:01 -0700 (PDT)
Date: Tue, 3 Sep 2024 08:30:59 -0700
In-Reply-To: <87jzfutmfc.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com> <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com> <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com> <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com> <87jzfutmfc.fsf@redhat.com>
Message-ID: <Ztcrs2U8RrI3PCzM@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
> Silver 4410Y".

Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
on another hardware issue?

