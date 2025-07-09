Return-Path: <kvm+bounces-52000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 757CCAFF4AC
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 00:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8C485C19BB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 22:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBEC2441AA;
	Wed,  9 Jul 2025 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mvNMVwTs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06C22F77E
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099951; cv=none; b=Bow21NgrNvBkyvu9WS6taXMtfElPu3Ny5hRIxnN8AZQHLEI3qnCkjMLKGmhBGEK7C+PJ9dZIrO2d6cVVdei73VvliU4RT8Vi+4iPaREAtuAQCCj2f64Z7UgvT7I8yAAFjza/GPTx2ucx7igrN/bZnnXMlQiGJCSG8rAMALeO4OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099951; c=relaxed/simple;
	bh=dkJ1PtZQqXxYBvMHRQpoXnzlUKAa7PWDoMi8PXhc7QU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kbSYrGYUbF9LNQ0Q9ubVGgUfOD+0fms//DcMxoAJ6AMg1LJpVy0IyCr84wREsni0F7Hu72tiOu09wvBHkm/wv8otPJbAFXn4nLPzHmyvZ1bADWM+kuKbIUho6MrfWnBZFGS7cH4IBHqygjrWfyjw9sqQp8Lp82jLoK7WBywYXrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mvNMVwTs; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7492da755a1so234139b3a.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 15:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752099949; x=1752704749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CEkPKw3M8obzlysqjDzuJ0l8ChAy9EN0Uu/m/zS8TW4=;
        b=mvNMVwTsWRUbOozt1kJ1rVM2eud94BlPtzDDViEpCZP5BBALrXS0WtUcgU1unXn2+V
         XsMcFGHuq89Zl0oZAguCc6+IYgpRGUaayl5mVPAgMRbpdQy84JP7+SXv0Q5Ml9druTUi
         tipYzrJdY6eaWris8UKR6zAkxw6UfCL7R4frIQsDm7Kl0k8hJOUQQrdR0HbDvciwV8wv
         reHtiFlCB4JRls8jyM0PEVoQtQz4jKH02DDifwKFbfpWTesscJkOfUNAYzXWziBpdT/V
         vaV0mh1kt67Y9CXpOHq/Ut4TYLJ/yAvse2b/PQuLsMD2KheDmhP5DE5CK9JuPsoLTD35
         gkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752099949; x=1752704749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CEkPKw3M8obzlysqjDzuJ0l8ChAy9EN0Uu/m/zS8TW4=;
        b=JFRyf1G7aZkVyKu1BFLFXI0ScTlxmmJSKRPM3Eou6m9rRn3sRTztMOiWMUqP8VRS8e
         sbfXVGQ3DucHPhV3GwPCmVDG21R7rLnrLOo6gALjd2kX4u9WpR5EvqDcKo4MrV9d2y17
         9TZyFTCuJZFZL/xPsrJfN4X99mb2mQCHDmH2M932iU4/Qe3yLWLngq8blMF7n4ivzXH7
         KhY7xCXYLGtYE7ohMapENfqb2uSuCYjJzfW6N6LrNJhORgmXA9X0DoAdhxvcmtNnk4b7
         xhSxHoumaL4e+Wcv7pkRMnbW+k/CISMfL8tvp+geVgX0EIhebwjeTrdWBcAwNdrP7j4f
         9Nxg==
X-Gm-Message-State: AOJu0Ywl+ZwR2c3Ft3vWnLjTljvasOS7k+5M8Onjnuw5e3rqL7DgZlfN
	2JBsRMBC5VT1GrxmroLumwHwDs42gd+4ZLxCvDJMN7wFXBt87PIfgDnwhA/xrSpcxbTtRWGs5xn
	KXFK2pA==
X-Google-Smtp-Source: AGHT+IHzaFg8XpZkeBot1MQe7M9Yb3LfWilFjWjxq3XfLXBIK/XNa5kNoc+2CdqHT487bCXwnmwMfiMG/dk=
X-Received: from pgjr1.prod.google.com ([2002:a63:ec41:0:b0:b31:e758:d80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:502:b0:1f5:6e00:14db
 with SMTP id adf61e73a8af0-230040e3516mr508970637.14.1752099949457; Wed, 09
 Jul 2025 15:25:49 -0700 (PDT)
Date: Wed, 9 Jul 2025 15:25:47 -0700
In-Reply-To: <20250606235619.1841595-4-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-4-vipinsh@google.com>
Message-ID: <aG7sa2fju7noUS8L@google.com>
Subject: Re: [PATCH v2 03/15] KVM: selftests: Add timeout option in selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> @@ -48,10 +50,13 @@ class Selftest:
>              self.stderr = "File doesn't exists."
>              return
>  
> -        ret, self.stdout, self.stderr = self.command.run()
> -        if ret == 0:
> -            self.status = SelftestStatus.PASSED
> -        elif ret == 4:
> -            self.status = SelftestStatus.SKIPPED
> -        else:
> -            self.status = SelftestStatus.FAILED
> +        try:
> +            ret, self.stdout, self.stderr = self.command.run()
> +            if ret == 0:
> +                self.status = SelftestStatus.PASSED
> +            elif ret == 4:
> +                self.status = SelftestStatus.SKIPPED
> +            else:
> +                self.status = SelftestStatus.FAILED
> +        except subprocess.TimeoutExpired as e:
> +            self.status = SelftestStatus.TIMED_OUT

This needs to grab stderr and stdout from "e", otherwise there's never any output
to the console for timeouts.

