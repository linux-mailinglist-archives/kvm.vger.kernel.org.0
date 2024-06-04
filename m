Return-Path: <kvm+bounces-18810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3D28FBFC3
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 241DE282263
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6385814D703;
	Tue,  4 Jun 2024 23:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iV/AmKNc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DE31411F3
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717543211; cv=none; b=RPa44xGpTS0bMo6J/XMQ/Yra0EOAfY5ZV8h3KkuugJPy6zEzDsz/NrdzwugyiIMNFmdNA/d4tJAr1jCiFRaHTmLxjcgdmbbhxQzy1HxE0/XQIkL9bN1kEWPxgwvqkfMp57pE9exjs2RizUb7x+VDuBlb4e5Tv36UuIsuJS/pzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717543211; c=relaxed/simple;
	bh=WIluJOaemcKSXL4xEhVN8aGC4Ies4keeQ0FcA5XlcZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VD+PeSq3s7aS4X+SoRa9wqmGwWznJ5hTmgSknPMXsAaCbJ4lC1NR4pAj8zVQ1nfmKZ3zZAaTsyB4yOtr9uu63EIZKeJsHFNH6J6fXC8EM0/gLBsQVV0I0POgjqCANkYyK6tm87dJAIyLZoPsH/RoyOQ0ogDDeRKNgWXpqaseedg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iV/AmKNc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a084a0571so100025387b3.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717543208; x=1718148008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wfQoSk9TuBoZ1xV7NJG5lVPKmBxQJqDgjEcvbYDw/ZA=;
        b=iV/AmKNcBgDBJkX5zoJPm98/7TqarmgpXyTb5iNKw9nMEn+BdE63Lf5+8PBJ4CsRun
         n1zpHdH6qF+HxmCH7jwjXxXrcqtIzkzhsNwnQThwTh/xCrQotLWhVroKO49GLwVktgDI
         rT9NJcYMElQufvZsARhGPJzeeXaxc6prJC8wtIdNuncRRcbmx9VGq+grrFWHMcz8ltbd
         nCTmkkjoX5r24inh0V/pCEX8e3ORGv3FwS4uTgaZzNOZCyq9U2k94alv81Oe3Uu5LtIA
         uIpe/WdiparUYeZD0an58O+uWWnsLlvjJjBNHdNXqAkZP1V3vMbwtwIBswz1qP0CnUJ9
         VJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717543208; x=1718148008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wfQoSk9TuBoZ1xV7NJG5lVPKmBxQJqDgjEcvbYDw/ZA=;
        b=Eolj/MJtxo8Ql2KlhhrGZhKMNEMxG+wyCFc0+4AO1FNsG2YDlWgVXa1Ee1dySl0idS
         yGOPniZ9MwaOyZGNwXh7kePJcJEzjkBnIWJeteMxm+RAZW/l8a3mjceNdphytET6CbVR
         HtQQ8tODTwPDdA+tOXQtyO+c1lqu5q/HhTUHqN2+Bc01kXKnhz5viDXg//oCTPDRq4W5
         7EQqUTMtRVgvnHPhkIypjsJDCVxy4h40vZJD01daiZ+nM+zIGYOAq1paSUdFKw2J0gwW
         Megt+2lPje0wFhqV1n5s4d+dUt0ihUfbgsPg4pCZ6xY/WJXmwccfxtTn9+ysmZBditmg
         hCag==
X-Gm-Message-State: AOJu0YyyAu789DpHKtpxsk3qlRtw+kz2ifIplDwoMWuXdZw6FDoyJz3z
	mcETO9+NrMcuHUgC43jwMi0gzjIMFG7kemFYoNixLs+G834qr35S91B5KhEIuNjNXrrhVGp0yAl
	nGQ==
X-Google-Smtp-Source: AGHT+IHIRiMezWigcEsMDlD3pFBpIO28MScfNfvU6yZfvjAwBTwoyTTUN7gUO/1MDeggHEuoqV5ege1PNc8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6a11:b0:61b:14af:df5 with SMTP id
 00721157ae682-62cbb5de957mr1921597b3.10.1717543208041; Tue, 04 Jun 2024
 16:20:08 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:20:06 -0700
In-Reply-To: <20231102154628.2120-3-parshuram.sangle@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231102154628.2120-1-parshuram.sangle@intel.com> <20231102154628.2120-3-parshuram.sangle@intel.com>
Message-ID: <Zl-hJgglNRy1G-IO@google.com>
Subject: Re: [PATCH 2/2] KVM: documentation update to halt polling
From: Sean Christopherson <seanjc@google.com>
To: Parshuram Sangle <parshuram.sangle@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	jaishankar.rajendran@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Parshuram Sangle wrote:
> Corrected kvm documentation to reflect current handling of
> polling interval on successful and un-successful polling events.
> Also updated the description about newly added halt_poll_ns_grow_start
> parameter.
> 
> Co-developed-by: Rajendran Jaishankar <jaishankar.rajendran@intel.com>
> Signed-off-by: Rajendran Jaishankar <jaishankar.rajendran@intel.com>
> Signed-off-by: Parshuram Sangle <parshuram.sangle@intel.com>
> ---
>  Documentation/virt/kvm/halt-polling.rst | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/halt-polling.rst b/Documentation/virt/kvm/halt-polling.rst
> index 64f32a81133f..cff388d9dc72 100644
> --- a/Documentation/virt/kvm/halt-polling.rst
> +++ b/Documentation/virt/kvm/halt-polling.rst
> @@ -44,12 +44,14 @@ or in the case of powerpc kvm-hv, in the vcore struct:
>  
>  Thus this is a per vcpu (or vcore) value.
>  
> -During polling if a wakeup source is received within the halt polling interval,
> -the interval is left unchanged. In the event that a wakeup source isn't
> -received during the polling interval (and thus schedule is invoked) there are
> -two options, either the polling interval and total block time[0] were less than
> -the global max polling interval (see module params below), or the total block
> -time was greater than the global max polling interval.
> +During polling if a wakeup source is not received within the halt polling
> +interval (and thus schedule is invoked), the interval is always shrunk in
> +shrink_halt_poll_ns().

This is wrong.  KVM grows the interval if the wakeup event arrives after KVM
stops polling if the total halt time is less than the max allowed interval.

The existing wording is a bit odd, and it fails to document the per-VM capability,
but I didn't find anything in the existing documentation that is incorrect (ignoring
the Module Parameters section below).

If we wanted to clean things up, I would vote for something like the below.  For
this patch, I'm going to drop this update and just keep the Module Parameters fixes.

  During polling if a wakeup source is received within the halt polling interval,
  the interval is left unchanged (the total block time[0] is less than or equal
  to the current interval).  If the block time is greater than the interval,
  there are two possibilities: either the polling interval and total block time
  were less than the VM's max polling interval (see module params and
  KVM_CAP_HALT_POLL below), or the total block time was greater than the VM's max
  polling interval.
  
  In the event that both the polling interval and total block time were less than
  the max polling interval then the polling interval can be increased in the hope
  that next time during the longer polling interval the wake up source will be
  received while the host is polling and the latency benefits will be received.
  The polling interval is grown in the function grow_halt_poll_ns() and is
  multiplied by the module parameters halt_poll_ns_grow and
  halt_poll_ns_grow_start.
  
  In the event that the total block time was greater than the VM's max polling
  interval then the host will never poll for long enough to wakeup during the
  polling interval (KVM will always poll for less time than the block time), so
  the polling internal is shrunk in order to avoid pointless polling. The polling
  interval is shrunk in the function shrink_halt_poll_ns() and is divided by the
  module parameter halt_poll_ns_shrink, or set to 0 iff halt_poll_ns_shrink == 0.
  
  It is worth noting that this adjustment process attempts to hone in on some
  steady state polling interval but will only really do a good job for wakeups
  which come at an approximately constant rate, otherwise there will be constant
  adjustment of the polling interval.

