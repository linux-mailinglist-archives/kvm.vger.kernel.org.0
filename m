Return-Path: <kvm+bounces-2517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C14237FA7E0
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 18:24:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 063281C20BE1
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 17:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC69381AC;
	Mon, 27 Nov 2023 17:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dDeDJeVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2E185
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 09:24:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-28583d0fd4eso4888550a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 09:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701105851; x=1701710651; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rL9LfDvcE9DBnUyEpS1p+L6oMlIKUpS9e4ZuAaaj8xo=;
        b=dDeDJeVQHlQ994p98Okkt8Fi8rO1ymAvpvZY+lNMB0xLQP3k3YRPwn9ZU9FM10XfYP
         MpWA0na4iyrnNjsT1acdT0xPP8jDcuoea7DyqVPE2BudYQTvoI4nvsdOXtnIxvyqE9m1
         fqNWvqdHvZVzjONjkZAQVCua/7BOXMe1xSrmLKgk9Ac2Vs5kx8zUcTeWZoqNhqVerl1K
         dpBkNjWJrHd8C8c+ubG39GQute/aj+q7GVgozK+sqjlEpTI17g3cIPVDJbYny4+OwWI5
         7P464B7FJqQt+9EbtT/IrxqNel4bMvdakiNUUYr6hzJ69vYfrNJu+6r1HE2cXoZGrqjJ
         VqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701105851; x=1701710651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rL9LfDvcE9DBnUyEpS1p+L6oMlIKUpS9e4ZuAaaj8xo=;
        b=jaJeJnSdlf4wGMkDwRW1uD1OW2X428nP1+ezUAiEfQBXdaUg2aanba574UrmuIx8IB
         tRR4p8QpjKYEag8oK1M6LjvIKQ8FFZw5qQ4A60IX7Brkg4cKD6t90kDIq0RiVE/sUm9g
         RJ/9QQPKQGR/OGPHa6m7iSB7Ksq0F/gPJyzuB7elDqH2eHyQh/LOkAWYy3x+0Qz8rruw
         JkCfzra+WWIUvKz21iGb3/K7LNfFBw67SfctIbJCWBKe4STKnM1Dzp5JqNaZy9zgp5Wr
         MZZx1/JAbFmDQRw/uy2x6tmAYKi+DhD6Cojuio0/H4v4kVKCjpCwv8A+C8dCE3YI7FE4
         921A==
X-Gm-Message-State: AOJu0Yy9RiEc8AjlMXpJ6j/PvSo1td3Pn7nRYZuKuWdcNS9HI3On0+eY
	IUEe0M5nyajVBsxa3mf5XFaMOP7QrdM=
X-Google-Smtp-Source: AGHT+IECzk14EwMjjFb3/1urDD+Q4mbeNYdw2g1/0ksrRD/AQy7nqH1ycmu7b6tnBPlSMiaoFaFQgGrTeFU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e8e:b0:285:b86b:6412 with SMTP id
 fv14-20020a17090b0e8e00b00285b86b6412mr1194032pjb.4.1701105850944; Mon, 27
 Nov 2023 09:24:10 -0800 (PST)
Date: Mon, 27 Nov 2023 09:24:09 -0800
In-Reply-To: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
Message-ID: <ZWTQuRpwPkutHY-D@google.com>
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 23, 2023, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Since commit b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
> kernel unconditionally clears the XSAVES CPU feature bit on Zen1/2 CPUs.
> 
> Since KVM CPU caps are initialized from the kernel boot CPU features this
> makes the XSAVES feature also unavailable for KVM guests in this case, even
> though they might want to decide on their own whether they are affected by
> this errata.
> 
> Allow KVM guests to make such decision by setting the XSAVES KVM CPU
> capability bit based on the actual CPU capability

This is not generally safe, as the guest can make such a decision if and only if
the Family/Model/Stepping information is reasonably accurate.

> This fixes booting Hyper-V enabled Windows Server 2016 VMs with more than
> one vCPU on Zen1/2 CPUs.

How/why does lack of XSAVES break a multi-vCPU setup?  Is Windows blindly doing
XSAVES based on FMS?

