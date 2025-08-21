Return-Path: <kvm+bounces-55328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5ECB30052
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F647604857
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A7C2E22A8;
	Thu, 21 Aug 2025 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZND+pr8y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965AE2E22A3
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794361; cv=none; b=nupLodrIRuA85isOB1nnADmK8jyExthtyWNgolPBHXjk4I/lyqVIAjutDutg1airL58ofu+KDXSWfjhxqU9mJN9TgK8aZrZnvU6N8wfMnFJjz5eABDkiIHJrrNNG2m5ZpvsbKfds+ArorJJBkF9aXTWmjKk4fNCm52VVhH9V97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794361; c=relaxed/simple;
	bh=3UZKfx4mbhwam/aE0XR9WSYF7bnCDIDIKNj0iATyI88=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GiZXeVFIaz6rPuj2WhYPkNKDyO0PUCnnZnim3sg3ziHvny3BlLutZWCo60akJmGdDYvTuGwW+KvwrRx48UHsYXHTg67TWcf7QKw1oe+Pzb3nnBL3w6w4cf3QoQ/vjgZRHXPSHJfmHAehdOyyJMdi4SloPqh3qXcjidDX+pBIOFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZND+pr8y; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b474b68cff7so1012717a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755794360; x=1756399160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdYsHVrOadSjoRXvBLux7PY9Oou8a5Zu0vwJXC3BW54=;
        b=ZND+pr8yUNmoPZfLuMgHlbwTm9c9Z2FiM5C7eXTx/j3zUALHORJ53PdqopEd8dQrZp
         hxkru0lB7CRIHlqUhYC97KQqgilfBq+wYcYPUP67L9PIx59XDPnvEjMStHLVfCQLosLm
         M1OAZnC2CXCcvvxTd0xQkv9C7k7kVw+Dx3w0QaBIEGH2Ma03dEcHVzrfaGlNKrwYXjMm
         aanTLMycp7vqM8E67L4JMc4SxN0I7KLWbwE4Vu0X0wfvESIsWqQzQmL+pR6l0VfPG7J4
         8m40jIzWHNu5O8Bbn6Gn/fCJzlE1m831cVFJYupTbvInrfq2BtMJ8irNlTZXSEult2e/
         jcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794360; x=1756399160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdYsHVrOadSjoRXvBLux7PY9Oou8a5Zu0vwJXC3BW54=;
        b=ILqq++ILm2L9Sszsrps85PpJtN495ytQtl4jtuWxtmAhkY8r0jWHKYtZ/Nw3O3ZLJc
         JqiyQYuhfG+rJrH2F+qaLxOc00JJA7T2E0E9fKrEhW2Kbt90s/4nMNE0KYciQ32nSV6s
         iaC17TbZJJxdUvzdWFPbjg2Dk4+7dDNPuqksuXePt88t/nrSeW9FrUs+FT3EWyyRqtLz
         VBUefjNaQFiQLu7Q6dkPvQOxSZ5GfItYIEa4eZ9a2DZw0YtitxiKqToIpEFastSMrE7W
         c6/iVhYkA45yC7usUTn3OrW0hea1Wk5E/PZ2kLPhxwx2OoJ/NqmTYheYBjOFD3LFdPs0
         ZFvg==
X-Forwarded-Encrypted: i=1; AJvYcCWGxVxU8QX3ZdssmEj5bq1Uz3U764WHfAhfswutMzoE/eB+LcXmOgTtDS6gX4Uwg/Dh6pE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJrFBDOpbL+5N0F5s1Ifuph11YqnKeXJPagy239CxWjYex57fV
	5Gyt9+cGzvmQ35CUZbJmFzAHZgrqoWVIs9+0J5kK13CM98T3fXRH11Gid1MBb5hdiBbEZS9dS+e
	XdC0+4g==
X-Google-Smtp-Source: AGHT+IG/O1L4roh6WRELOEyKQDpzX5iGCPIUafYcuuwUz+8rmMGgV3j5siY+SfHE8IgV+TWSBIRtCeumd6c=
X-Received: from pgbeu24.prod.google.com ([2002:a05:6a02:4798:b0:b47:15b:bad8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d1a:b0:240:203d:42a
 with SMTP id adf61e73a8af0-243307fb09fmr4764743637.21.1755794359910; Thu, 21
 Aug 2025 09:39:19 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:39:18 -0700
In-Reply-To: <1a054b30-6c3c-8e58-e2e6-c83cb18cb0ee@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1a054b30-6c3c-8e58-e2e6-c83cb18cb0ee@amd.com>
Message-ID: <aKdLtn-28moWf0_6@google.com>
Subject: Re: SNP guest policy support
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 13, 2025, Tom Lendacky wrote:
> Paolo/Sean,
> 
> I'm looking to expand the supported set of policy bits that the VMM can
> supply on an SNP guest launch (e.g. requiring ciphertext hiding, etc.).
> 
> Right now we have the SNP_POLICY_MASK_VALID bitmask that is used to
> check for KVM supported policy bits. From the previous patches I
> submitted to add the SMT and SINGLE_SOCKET policy bit support, there was
> some thought of possibly providing supported policy bits to userspace.
> 
> Should we just update the mask as we add support for new policy bits? Or
> should we do something similar to the sev_supported_vmsa_features
> support and add a KVM_X86_SEV_POLICY_SUPPORT attribute to the
> KVM_X86_GRP_SEV? Or...?

I think adding KVM_X86_SEV_POLICY_SUPPORT to KVM_X86_GRP_SEV makes the most sense.

If we allow new bits, then we definitely need a way to enumerate support to
userspace.  Even if we made KVM fully permissive, we'd need/want a way to communicate
_that_ to userspace, which means adding a capability or something similar.

In other words, we need new uAPI, and if we need new uAPI, then I'd much prefer
to retain control in KVM just in case a policy comes along that we don't want to
(or can't) support for whatever reason.

