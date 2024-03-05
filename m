Return-Path: <kvm+bounces-11071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44FE8872947
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 22:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D7DCB2C79B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D5712AAF5;
	Tue,  5 Mar 2024 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hZL5rxvN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEDD26AD0
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 21:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709673174; cv=none; b=SwHJMzhuI2CR3nlx3A4fXIkE0BsAlXBQQTUe56hY5cCImEpttaKm1QbBKhVQWxYKaNzC/g3Kwc/fzLKdHODJx07ckYi9duLRLaS26345X38qAtM7ISmFWTaVksWlEYH6Is9ZmPniSVuH+1xTEULfAF+ayDBw1T9WXgf2CQN3Bnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709673174; c=relaxed/simple;
	bh=FXf49kdBXVQUcN5HuOuu/xL/lL2UaeLFaRmdPdq6YJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KFxROifiPGdbrs73r3S0MiGrQYSEAWGnad9dqvCLs2jLkbFe2A6o6u4Q7f8avk658pY5eHcbd4N+JxYNyd7e6BZmsvBA9GNVdW27QrSn7Pt52qk0B342XYs/S5s5YlLUhJJSwzUc0wNNN603BXUhzpCHjRfbbKiM0O0TK0xoXts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hZL5rxvN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc647f65573so10759043276.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 13:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709673172; x=1710277972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ag+2iHq1txfrjL7kar9Psm6rqRJcEV1IG7J5tV87jM=;
        b=hZL5rxvNsyE8SPQzAXfAAsNuEV7HvnrNXhGHlhaQYRY4xvdyvuEpIwK3fsSt1exumt
         Oyh469nqGNiGhnnjDyz36adbAVqVZtATsr/4EnupLHHLVYXsKgidtpamis0n5tigSpzb
         EKiwPOGubd+ClULr/i/Iwq9eSLPRd9Q08bCrtsJZ3qg1foDXWB2/8teORkS4dzHEcpv2
         lYxOpRPAwLCrhEZ9pTSb0EF7r+awqCk7D8aKpXg0pZWr059t0RI5A0clFLP4LpKcbeeJ
         k1zUuvMkRR8H3bwzG1D1y+Aigpc3Xxzsi0OELAd19F/MNAiHcGwgTDWlIJ+QwIIJa9XL
         uQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709673172; x=1710277972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ag+2iHq1txfrjL7kar9Psm6rqRJcEV1IG7J5tV87jM=;
        b=vpXvJHnIZNxoj49VNPuq5r2R9F9T/0RFgWAdubKs5TdvgKqSMqKcxWASeXtylMioIY
         +N8Nic/Cl6dtIvbimijbZKqGXnUcCzjcjOGa60PF3Dy+9yJwoD7gx+mA8HFsZl/3HSzM
         7UIVb8jlxqm1x+mAl5bjMLU1j6O2Zvc5e6+Sq5g0KtOJq6DI++ITGFxQ61kGtecAfmRL
         Ery5JPEwiSBOWfAyGGR2p934Q8sffAY57Ejl0Hzv6C92YNs0JUJaprwGLKbyXZTTV7Oh
         4Hhq5ve/VmNVAUnWJ7lpq/8QGPA8l/HC1vjA0CmmvXk1Ewuz+MMZwOPgbp1FR1Crb6Lh
         eZSA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ7KXsx0FzRYQ1R6QXqF8N2uxl/dS5JqHnhI60a2p5ThGDluw2Dx9xqBDFl905E26bwcOszezKEa0YAerE3fEl1R/t
X-Gm-Message-State: AOJu0YwwSDXurmgsa4WW21tFYqMMC11AzYuWGRrIsU6x2UC7eXRFkLR5
	sy5mwYPpebUVa7Fe39ahAfUI7JqOAjUoBtrzVLR5f0CrivSw/QHwwoTU6drxB7ClxdV6+HXpGyk
	y/A==
X-Google-Smtp-Source: AGHT+IGlqIIv+7adrz5MYT2XABbgiBYwvWRi+Vj/bM1xdE33mR45AWrUzWllQG26UicqEt7cbkKEU51adPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc7:48ce:d17f with SMTP id
 w4-20020a056902100400b00dc748ced17fmr3360283ybt.10.1709673172095; Tue, 05 Mar
 2024 13:12:52 -0800 (PST)
Date: Tue, 5 Mar 2024 13:12:50 -0800
In-Reply-To: <c72f8a65-c67e-4f11-b888-5d0994f8ee11@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227115648.3104-1-dwmw2@infradead.org> <20240227115648.3104-2-dwmw2@infradead.org>
 <ZeZc549aow68CeD-@google.com> <c72f8a65-c67e-4f11-b888-5d0994f8ee11@xen.org>
Message-ID: <ZeeK0lkwzBRdgX2z@google.com>
Subject: Re: [PATCH v2 1/8] KVM: x86/xen: improve accuracy of Xen timers
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, Paul Durrant wrote:
> On 04/03/2024 23:44, Sean Christopherson wrote:
> > On Tue, Feb 27, 2024, David Woodhouse wrote:
> > 	/*
> > 	 * Xen has a 'Linux workaround' in do_set_timer_op() which checks for
> > 	 * negative absolute timeout values (caused by integer overflow), and
> > 	 * for values about 13 days in the future (2^50ns) which would be
> > 	 * caused by jiffies overflow. For those cases, Xen sets the timeout
> > 	 * 100ms in the future (not *too* soon, since if a guest really did
> > 	 * set a long timeout on purpose we don't want to keep churning CPU
> > 	 * time by waking it up).  Emulate Xen's workaround when starting the
> > 	 * timer in response to __HYPERVISOR_set_timer_op.
> > 	 */
> > 	if (linux_wa &&
> > 	    unlikely((int64_t)guest_abs < 0 ||
> > 		     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
> 
> Now that I look at it again, since the last test is simply a '!= 0', I don't
> really see why the case is necessary. Perhaps lose that too. Otherwise LGTM.

Hmm, I think I'll keep it as-is purely so that the diff shows that it's a just
code movement.  There's already enough going on in in this patch, and practically
speaking I doubt anything other than checkpatch will ever care about the "!= 0".

Thanks!

