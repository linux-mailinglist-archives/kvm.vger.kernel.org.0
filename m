Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21C638413
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 08:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFGGEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 02:04:09 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39138 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfFGGEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 02:04:09 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so658815ljh.6
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 23:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=MmvQ2pc0z+HvkwQjaWTsR4Wkccaoh3EGof+KVpniCvw=;
        b=rvHFQULJnd8YxI8kCLGBcUbRq6rkwpBmAd+HfE+5d7nTyIoyZIW3xcpkMzOE8HVuu0
         x1YwLmmaFPyd1pC9gIu0chl0TBjtA2OzRZJDp86q10EGVCUQN3uOj2gcE5RL/PsryXgG
         yv0E0vCs98N/TZ8j5kWDWdjA5s49XNKE+MvfwM6+E3HXcRN1gx0H8qRti7yiIUpbN1cP
         yrfLI6qjO/fES7BUhZFOqP0Q9d7rKtgewzTEiGXVmoIX2d5hGEoKQZLstnUpu/911nDl
         9CYiE6QooiwNj2qd0MizDFwg8NbAAzPrJbjmelCmmGwkOiQd7vjYKH0cIjTJA4RqoWZn
         YtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=MmvQ2pc0z+HvkwQjaWTsR4Wkccaoh3EGof+KVpniCvw=;
        b=kp037J2E/uyLu9EikLlh3g1P9sYmRaRqHVa+A/mZ/hw/p2WQv8ChXxs7eMdY3Wjtqr
         f5BM7f8/a/ZW7Y9O64B2YRbtP1cNPSyH6mYXj8jr0CoE1AQTnFYzkgCqyGvsdaqBW4Dy
         gPhgBCWsS+Eja2C8wTtW6uh/z4AZd5054HOiW5Z50TGwFhC6JzOsvr03+DcIM1bzZOuL
         QWz7kxFN5Y2ERgUq2NWo/ookqPdTK00yS6rz1BKrO58Pk320PkvbE6cfzVlJgUU88JB6
         nCr0Woz1h5b17wfbVhORaoqybzoZvjMg+1FaTWLgcztybsamex33ga/I0y7HH5trwBcM
         69PA==
X-Gm-Message-State: APjAAAVGccWTcEUkCFx6sjlPUCDNiG6hquP5qposxIETbhUa3gPd87CZ
        BkMgdmTjpNUVZMB5o/X0Oa6+/w03
X-Google-Smtp-Source: APXvYqyfia+2LCkeLvpHo9LJed30gn5dcsB+BT/DpVOfgn5yBMJGI/HW3+6IuHqua1HoeRKn/asrew==
X-Received: by 2002:a2e:980e:: with SMTP id a14mr16178566ljj.60.1559887446836;
        Thu, 06 Jun 2019 23:04:06 -0700 (PDT)
Received: from dnote ([31.173.87.118])
        by smtp.gmail.com with ESMTPSA id d65sm235292lfd.72.2019.06.06.23.04.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 23:04:06 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:04:04 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v5 3/3] kvm: vmx: handle_vmwrite: avoid checking for
 compatibility mode
Message-ID: <20190607060404.GA29127@dnote>
Mail-Followup-To: Eugene Korenevsky <ekorenevsky@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

handle_vmwrite() should use is_long_mode() instead of is_64_bit_mode()
because VMWRITE opcode is invalid in compatibility mode and there is no
reason for extra checking CS.L.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a2d744427d66..b39fc075aead 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4467,7 +4467,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
 	else {
-		len = is_64_bit_mode(vcpu) ? 8 : 4;
+		len = is_long_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
 				vmx_instruction_info, false, len, &gva))
 			return 1;
-- 
2.21.0

