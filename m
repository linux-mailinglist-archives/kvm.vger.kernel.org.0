Return-Path: <kvm+bounces-13405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB78895FE7
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 01:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D965B248F8
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 23:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F6642076;
	Tue,  2 Apr 2024 23:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fSNIr3iH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0552E3FD
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712099222; cv=none; b=IXkDLsUAjxKQa3oZ7BVOvjS+B87EzGwKmMiPGUmthgJwWlP2RCagNQ93kVENvsaf3g2YTv7u+1Aniz9WnfeplFzCJFVCOp3Y7+Bc88QQmGw8IsGKvhs2HLyKHnm4/Bzqe7sjmzg+cDCLRTK9sfxEmGkjCf57WYtjlTVCk7gwf6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712099222; c=relaxed/simple;
	bh=C+ij29dRhrqI5jcxTxsDaSlvXKcifI5OQZdLLtJKNdk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ua6H/cxU0K5e+IL2151Nps+svApdDBVblaod8rtvEV8TAsMFV8/IK1nnSec5FQW683n1NDoJh9KujKdPHNKGGb0Loy2Aq28JjWBKHv95AZhQI2la0SKBIawNKKiMMjqp/EcbXKUnL5ZSNy54kcDhWJS3OOEu37jR3Gs47jhRlGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fSNIr3iH; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso4895466a12.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 16:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712099220; x=1712704020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7422aHnKc2YIMvnMd+j0sBwZWTd2YcB6sZqSb8qExc=;
        b=fSNIr3iHUE2KS1JwvAp+0VTuTWOnVAwhzuOjz2jaVuO4SYAPYSfmuGk2d1sSi3FoWz
         YN0FppBeK52vbwjimHxMauvlLlq0BpFuZrmgo32oQ0kYvcl68zXSuC8xxB3sZojNdiVV
         sHxNSQUEQ2/7opU+V3x6cm0/oLWr9FaFNh6IYcCnnqwyYxCRBnbNOJ/2Lcn9jpSLqbo0
         rHMdvLsFi3sP8eKImkxL78yfysEC9oNCPCw25lVlB+JbPvmVAxVY6PoEe7PwJ5uz88My
         xf4Vq+/hnfhLW9XUPdJeVMOo91Fwl7Te6pJOO+ssVSVJbaV+wY/aorXV0z7wEQfyT8AF
         wbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712099220; x=1712704020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7422aHnKc2YIMvnMd+j0sBwZWTd2YcB6sZqSb8qExc=;
        b=DsdMVcveX2JqUioB51WGCwZoACMMEKWjLXXF+Ln0xlr2c8/Vo2rQRowjnxt3mZJ3eX
         kGhpPjw05+BZRh+XXebRgoWmTchcHTrYHboQnmbvafpJLzeDFVKYRljE+Suq7XQ9D6M1
         gpzgtrFJJ+e7vawD+wGn00jFyE1iaUX9TXJwzvtOneLByxLq+IEmrqfRMtsfQeZVKXnL
         7IfZrcbSZX9E5ZDKegs31pHZaO5NfSChCkTY9VIW+WHpi0LbFqNLSb8uFVT9MwNpM2vY
         lcq2aBJs/M0aFtU/OARRczm6WzZ02oUgur6YLAsnQTT39PSbRQEvckknuo7FAVVDrP+2
         wryQ==
X-Gm-Message-State: AOJu0YyREF6mfas+/EZv99AvKAvFB5Yi7oKM3bGiEJVJRcyv6q9J/147
	7OVThTE0/ro1gpOY34DfTsbpLyPXo54j6RgCHEhPd7X6/GPbl+ORsCYguFyudfFMQzE8jh7oFmF
	dgw==
X-Google-Smtp-Source: AGHT+IGRm2VsuXBt3jAN92k0nAeok/Lf4J4zQfP39FSHUoKS6RXRTu02feTnvHV+1X59u3kiSav4RscI6qs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e884:b0:1dd:cc3f:6510 with SMTP id
 w4-20020a170902e88400b001ddcc3f6510mr1141063plg.3.1712099220554; Tue, 02 Apr
 2024 16:07:00 -0700 (PDT)
Date: Tue, 2 Apr 2024 16:06:59 -0700
In-Reply-To: <207d6598c8b74161efc38bd18b476ca8626786b1.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315143507.102629-1-mlevitsk@redhat.com> <207d6598c8b74161efc38bd18b476ca8626786b1.camel@redhat.com>
Message-ID: <ZgyPk-1MCqJIXXoB@google.com>
Subject: Re: [PATCH] KVM: selftests: fix max_guest_memory_test with more that
 256 vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kselftest@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 02, 2024, Maxim Levitsky wrote:
> Kind ping on this patch.

It (and patches from other folks that are getting pinged) is on my list of things
to grab, I'm still digging myself out of my mailbox and time sensitive things that
cropped up while I was offline.  I expect to start applying stuff this week,
especially for fixes like this.

