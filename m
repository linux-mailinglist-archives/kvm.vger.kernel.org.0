Return-Path: <kvm+bounces-15018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFD48A8E16
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FF351F22F16
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464E881734;
	Wed, 17 Apr 2024 21:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NCsWuLeS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEA747F7C
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 21:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389685; cv=none; b=rZfa8Y7Cyj86vMGbR6VRK59Su7pjS4WhmAfuwX/H41RCg4nLdnPZFwC0qUmIzRZ4l93Oh4uCc7Qphpo1GYE6auR7q7fgkfeSdbu8iuU4dOG78Pb8J2iKH/agIW+4/q3gNblEHpwz2X5LygcG0YT+nTUdfABJUB4cvPe7KXjoZK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389685; c=relaxed/simple;
	bh=AXiEFpjwutkI1b7D7DrnphTAmx4kZakjusToR/aZCUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=egmKD/By5qsOKW8K6zB/BrOm74wb41BtOVrLVrykN+HebAPHAwNSU+MvCrIY9rXHGnaulNhxagO5pqgJ4snVRJumQq+P9bCwPbXBq2d9LVIC2G7mFIoBXeP4qzjm8DiV2O5pDVE0iRPfshGNU6yD96JVo31s0ubCKAbmzxf13RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NCsWuLeS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61ab19438a3so2570057b3.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713389683; x=1713994483; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FtcRdic/pWCdYOXnVvo78eeJmsM1IAgH+M6Omc9kMKA=;
        b=NCsWuLeSK+t00r1THrqfXqjWnAGtihxjLawB7hnqdnV+WPrEf7f0iZ7Is/48yEr0oq
         3Ur0BQXAT8y92Pz9xu6PuharR/WMlUehUUaZTm2wtyjVbvlYwXE+gaiqlxR96szkdI8Q
         hYdHPeyjn83suyyeL7E4Jg4D55mnzZ2Q23oBoZvLQ74cG0+m7hnjcX9Y57+3q1n9EQiO
         CgpVvLpVdK+YDtEGuLBF0+y1MJUzqT3cPKzJMbnf32akzGNHQYLDpLv8sxZftaqEETjT
         y9rCQvAstvCGuPqCqvvZSf5D+fJjnubjuWqowrGraswEXTZh5TTBpUrrAaDr2K4Ng6Wt
         rILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713389683; x=1713994483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FtcRdic/pWCdYOXnVvo78eeJmsM1IAgH+M6Omc9kMKA=;
        b=o8zVUOxrj4OQpT/7yjLQ5uPwZIFRxOYadAAQeMgbM3pwL81qX57bD7+U5/eFNvNvI5
         uGPspIZRgmBDaqt59d5f1i9tJS7Rmw9Q9Fz8J/0gBUG8a95xuu0+b1W1VxmeVPzKr37G
         /1CM979GgZV8UwpDTo2b+vnAZ/8oI+E2GYwRwUlNDOJI4sN+hchJxs6UqUWFGDZU8oFh
         vVjBulz6rb5VO3qXNl4DyDPyfgrGddpiWYaQPkVpwnxBEHh8eK/gCJSMaui5TezV8uku
         n/tJo1gtQmPHbzyZIBsvC5nx9jhyKdvWy1iCTyWQxm+zObmXFkofASXlhgFPl2fM779X
         GrNg==
X-Forwarded-Encrypted: i=1; AJvYcCUOX6sAiwAdr/sRbDPND9ZSHvbvNtid99+fjb3/1ii7zHPrLhqXgSLDxC5+XGv7B1GFwZZ9fhW91S4f6sti6sqnekQU
X-Gm-Message-State: AOJu0YzeXakQLIkmEf18S9WxsyxowVAcp8lQx23xmEA+/AGGQ1MLLxGR
	Lhp2cFNOldzYoII9X60ZnwwwjwBh75/s2jI6hQ6LG/6exCIbqIk9HSXXagKP7eQjHXuGtxqYOtX
	O4A==
X-Google-Smtp-Source: AGHT+IHc3DA5VPFpA4aFYvJI8k8Yf0v1oUHErbHCSz7oh4VzqwObcKcgzCdBqEJC4E/YYuZnq0X4zBHlsHc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:52c4:0:b0:61b:1225:dbd2 with SMTP id
 g187-20020a8152c4000000b0061b1225dbd2mr94872ywb.3.1713389683369; Wed, 17 Apr
 2024 14:34:43 -0700 (PDT)
Date: Wed, 17 Apr 2024 14:34:41 -0700
In-Reply-To: <ZiA-DQi52hroCSZ8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-6-pbonzini@redhat.com>
 <ZiA-DQi52hroCSZ8@google.com>
Message-ID: <ZiBAcfoIY3z_ARSF@google.com>
Subject: Re: [PATCH 5/7] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 17, 2024, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> > +	case RET_PF_EMULATE:
> > +		return -EINVAL;

Almost forgot.  EINVAL on emulation is weird.  I don't know that any return code
is going to be "good", but I think just about anything is better than EINVAL,
e.g. arguably this could be -EBUSY since retrying after creating a memslot would
succeed.

