Return-Path: <kvm+bounces-15288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 331B78AAF94
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24E3281BBA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BCC12C819;
	Fri, 19 Apr 2024 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yhS8pdkg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DEC12A14C
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713534110; cv=none; b=gKAIiBTnRSJRQHS/mhHvUd2utYeFMD0zG8jYgkx4oIy3xp0ee3OPn9Is+UHqq9B65oV5HZhJgL8SEpEa26nge9In7Clf6FgHp5aSSeBmcFk1hnBmZaEHCMFCV4Q+gVobFSGu5HzyFV4ZOLcr4u6ljjdTcBvQys2OABSUEtLgw0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713534110; c=relaxed/simple;
	bh=++wcf7Oo4HULNgJkZlzxzN8ZrDnid6G0r8PM+hd/TmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mfrHKfgF2N/sRzsp96HaRa3li97EBPy4Rnh+B4q9ubnfXDSW9IHpxYANwVBxHgvYIvKiRA2eUAFoVyUfyVPpewFykP8wsBDUvzVsOFr5a4N4vf+JWcYhzfPQGVQqzAFuakvHGtl7FGlFzKQKJDSqnRIvTcoERyMitEDwt50Fjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yhS8pdkg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b3518eb6bso12555447b3.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 06:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713534108; x=1714138908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eIbLUE3R+om1X38nMWnrzy+JncLTgQydVTTv5mFU/to=;
        b=yhS8pdkg5a0QmmX07joNPZJ0N4sU0obGDf6bRs3TVSq11kdwDWrV2dp0S34rlwlkN1
         iBLI9kvtOwYSmtla4xBsqI3NgAhVW/o0WGzVGMqUdkaAVTEMQQ+u5jBuotUDBPNekhUA
         6yDZE6n/pkcuDReGrlYG9mTy48l5Wg/VeFK8ZZZlOO0D8eMjEHpe/0N5U2aVYMKNcPP/
         2O6ofg8VDMxwmxGSN/faxHXi9tlhY2D8JWh6BRWXrwOq3z2ogq5kPrA+NQ59lQAqYfjH
         b/A5qWjFY9Ug+IPinjO55AorMBOcgVKn3CM8jFCvXgMz1Ma1Nigch69YJgquBIl5IOtZ
         x/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713534108; x=1714138908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eIbLUE3R+om1X38nMWnrzy+JncLTgQydVTTv5mFU/to=;
        b=IPFbXT4BummcQdXmpp78f3ngKgKoulpDudYPPuNEGuPcBxLN+X3xyPt9xUp79ojilZ
         GjFhV0aYILQ1EHf6hc4V1w1TFo3MUfJtKfGPNzyHmVeKUvZjIMW48tUIbK6z9mkikjsf
         2T/aR6S9wecCIO8uXRkMTJTdV10AxRZMno/WcJVCLS1yOEyP9IfcNHnZAcIFA8pR4fja
         19dzT6PjYJDLB7Y+Q4rJy0lYfgp0GgPQAj+LcpusSbx/vsJdT+OrJl9GguzTG40414OX
         zEQd+df9kQBVBmqvVX/cPv2iIw3pDQs9Re7T/4JpBpLxBOOt6Eudwi3ZEVI4znj6m1Ve
         rXlA==
X-Forwarded-Encrypted: i=1; AJvYcCVXt9Fifjj7Ff/pyNBUyJ6yzCJqZM8qQHEFbc2aGUXpTt3dAhpruzSoCTFY38GH0YZy/ee1KGZq55RqBfWzXzRJFm3Q
X-Gm-Message-State: AOJu0YylDP3q9J/9ncEcqgTs01mwZEFhCCxPHGuewhT8ar2YBdKU/Bij
	73AI6FhlUPuHdw/5oqzWJkduP7ZUhQVue2kPDbamtEndDS0XnJiOITUavVEETYJ5N3AGUGi8PTv
	8pA==
X-Google-Smtp-Source: AGHT+IH4Z5T1+pfr45JTb+aarirdSILE0eG0Md04IR0SIPvit+QdVNVNsvLm+lVVA1gUCgt74a+9v16dFMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100e:b0:de4:c2d4:e14f with SMTP id
 w14-20020a056902100e00b00de4c2d4e14fmr404835ybt.11.1713534108121; Fri, 19 Apr
 2024 06:41:48 -0700 (PDT)
Date: Fri, 19 Apr 2024 06:41:46 -0700
In-Reply-To: <20240419112952.15598-5-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419112952.15598-1-wei.w.wang@intel.com> <20240419112952.15598-5-wei.w.wang@intel.com>
Message-ID: <ZiJ0mjZxlRsLwl3E@google.com>
Subject: Re: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
From: Sean Christopherson <seanjc@google.com>
To: Wei Wang <wei.w.wang@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, Wei Wang wrote:
> KVM_X86_OP and KVM_X86_OP_OPTIONAL were utilized to define and execute
> static_call_update() calls on mandatory and optional hooks, respectively.
> Mandatory hooks were invoked via static_call() and necessitated definition
> due to the presumption that an undefined hook (i.e., NULL) would cause
> static_call() to fail. This assumption no longer holds true as
> static_call() has been updated to treat a "NULL" hook as a NOP on x86.
> Consequently, the so-called mandatory hooks are no longer required to be
> defined, rendering them non-mandatory. 

This is wrong.  They absolutely are mandatory.  The fact that static_call() doesn't
blow up doesn't make them optional.  If a vendor neglects to implement a mandatory
hook, KVM *will* break, just not immediately on the static_call().

The static_call() behavior is actually unfortunate, as KVM at least would prefer
that it does explode on a NULL point.  I.e. better to crash the kernel (hopefully
before getting to production) then to have a lurking bug just waiting to cause
problems.

> This eliminates the need to differentiate between mandatory and optional
> hooks, allowing a single KVM_X86_OP to suffice.
> 
> So KVM_X86_OP_OPTIONAL and the WARN_ON() associated with KVM_X86_OP are
> removed to simplify usage, 

Just in case it isn't clear, I am very strongly opposed to removing KVM_X86_OP_OPTIONAL()
and the WARN_ON() protection to ensure mandatory ops are implemented.

