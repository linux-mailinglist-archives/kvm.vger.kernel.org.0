Return-Path: <kvm+bounces-15865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D79BB8B13DB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 21:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7647F1F2438A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85AB13BC3C;
	Wed, 24 Apr 2024 19:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xdlI8AQz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41C81848
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 19:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713988667; cv=none; b=e0ODE9dE2O/fsxdGdwtrn196yCRXuQKHjtxNmB3qLEdfzgdJHNMvrvQDiNVx+H50YX8yXVuGN9oVg0JSYQ91Aa2Nur/dULJqXqkbfx0V6yi20UOOTdW4ywYtqaQooGO2p08KuHyjz9XSlhnecvyKR4atmGPdKZncz2e/WoqxCo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713988667; c=relaxed/simple;
	bh=Ezf8HcOmGibT6Ls3EvM1xGDK2E4Z50zZWeh+sz0kp6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rjo+a26Pl7E0kyb1U0ef0leoJnVOaFBh43WehKH+p8P2msvFCZry/DA2zUDg3gcqjlzCTWeaFiPEi2nngGIl4h+xUc4hghiWYjfGGGC2Wb6RY04qAJ2pEsIpO3O/7O30avPjWTzA6sy23y5dqj/Ju96CUzreIRr9rdBlD5DHXxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xdlI8AQz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6183c4a6d18so3872967b3.3
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 12:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713988665; x=1714593465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FjCbTQKQdYpMLda6Jiyq7iBjTjuhXyZh4wh3ChdsfU=;
        b=xdlI8AQzarmXF9PJauLE+TL7w4k0wKS9mfgmykURAMH1UC4r4weXICM4V97W52O0sy
         /4bWrkS2gBeji58c/J721ZeJ4tswHyQSDJtlx8vIgtXt0ri0dJ3R6TdP1XWVF+EoEOFf
         313G6j50kWugLmN6ICsPH4Qb5Ybgf4MJTXoQDeurtHZo79U0Bul8Q2exvU0p/g2iHh5z
         VEzykE1/4alSzVvsCxFtVeHJ4V6gsKddofdM73SqWuNiR+cSQACfwT7o8QSwnWhNVhhr
         CK7QjCtsXYLMwZdXEGIW0X6FGCzrDt8patxBxOPvr74HEojphv1MWJeRR+R8WaEY6+DV
         Hphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713988665; x=1714593465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FjCbTQKQdYpMLda6Jiyq7iBjTjuhXyZh4wh3ChdsfU=;
        b=fuqhAJEQSt6VbT5KJE97Uzrh1Wg82tSnv8SB6gKa0IUZNDEKztTem2ULKVOQBriD6W
         wOmaA3MWQu0r5hChmzmgIOABRERasX53Eg3K0aAv5MiOYI79qDqh79N2JWhhPBGOqN0T
         FQzAt3RS5LlB3n/00Kd7BGaDQEc0DcgPTSDKMDVEojWz3MC6ySyHqkFCU1mgDzDN9Tqp
         r0cb8N/CI43UMoLl8ayf+H96PUEWLaPgP4q4Mk/wybwZuN9unSa8e/rs922bW269qjNr
         CZlV5rnvCc11/fC6ER3nuywRhLq4VQU+0VUGKtGEmunCbta19QhMswiI40ZQz4jJdfdy
         vsRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVExgfdRvl2k/LsQ1NLAe3/aCsPAC2eckhMjjSwwLfJBU4auEeVm5QCN9dM29BT0Y4eobavYwaLZ9GWvLrQ74YtYOh4
X-Gm-Message-State: AOJu0YwASolk7BHpJpRfmcwuH7xoTw/BvOockFabvCeSY9RtrwGApBi6
	Fz4DCvMs4pipxrrFfkoIu/Mq+AWG6n1z3e0Jn9bPNcMjqrrVVrsCuYovRbqdVVqBWmHp87Pn0VO
	t2A==
X-Google-Smtp-Source: AGHT+IHoeI+J4/hNST2TgTwDm1q0K7qJ4IBd7czAr+qCHxvrmSquvkLDEnz4XoEATY2E4+JArBcZjoc1+l8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce81:0:b0:de5:5304:3206 with SMTP id
 x123-20020a25ce81000000b00de553043206mr373600ybe.11.1713988664900; Wed, 24
 Apr 2024 12:57:44 -0700 (PDT)
Date: Wed, 24 Apr 2024 12:57:43 -0700
In-Reply-To: <6f476d85cdb9dfdc0893e9eb762dca08f0f5f19b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
 <Ziku9m_1hQhJgm_m@google.com> <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
 <ZilAEhUS-mmgjBK8@google.com> <6f476d85cdb9dfdc0893e9eb762dca08f0f5f19b.camel@intel.com>
Message-ID: <ZilaWM4AmrbeSEy0@google.com>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "jmattson@google.com" <jmattson@google.com>, Chao Gao <chao.gao@intel.com>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Erdem Aktas <erdemaktas@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 24, 2024, Rick P Edgecombe wrote:
> Long term though, I have been wondering about how to prevent TDX regressions
> especially on the MMU pieces. It is one thing to have the TDX setups available
> for maintainers, but most normal developers will likely not have access to TDX
> HW for a bit. Just a problem without a solution.

I wouldn't worry too much about hardware availability.  As you said, it's not
a problem we can really solve, and we already have to be concious of the fact
that not all developers have comparable hardware.  E.g. most people don't have
a 4-sock, multi-hundred CPU system with TiBs of RAM.  Not being able to test at
all is obviously a little different, but it's not entirely new.

Instead, I would encourage spending time and effort (after things have settled
down patch wise) to build out selftests.   I tried to run a "real" SEV-ES VM
and gave up because I needed the "right" OVMF build, blah blah blah.  At some
point I'll probably bite the bullet and get a "full" CoCo setup working, but it's
not exactly at the top of my todo list, in no small part because the triage and
debug experience when things go wrong is miles and miles better in selftests.

