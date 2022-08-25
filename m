Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E855A182E
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242458AbiHYR4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiHYR4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:56:51 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1BDBD09F
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:56:50 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d12so467920plr.6
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fCNAfd5H6F6g3vYAdurwuCycLOs3svay2SQDs0FC2Yw=;
        b=PuJSRTP2DRF+HsJ7C3XKmvNhIB4xxcyxpRZEVP8wpa6Zhin2o02JlZ5IIcsowqRpJT
         ZDeZQ8iytFuvyVIxsEBRLW2/AV9KroFkw0bNwLy+sFWnt3g2zFpiinmZlijUOQNfFjBA
         iX5dkcBletB6WKh9PqCwZDCTp5NC9LKwTQp+TllhOU6ljzUsMf5iluWE/Jo0ujpz9BlN
         dv5HkCSZiad7EF4mqRB+KEnPWmZmp1omZtbhRbPlKVtJze9RwT0RbNtFqjYIWr9kWzac
         ohonS9qo+8Y6QP+MwmyrEXa/spTzoW+WJNeTy7E+6uZoJfJdvECNlrBNZn7sEuzpfCdZ
         2yQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fCNAfd5H6F6g3vYAdurwuCycLOs3svay2SQDs0FC2Yw=;
        b=QJ+xdDtfhuCFpgDRTj9DZXj6/io0+9KjcsTsw3k4gBvJt3hm12L7QSABwvj6jE8xRl
         eArQtKewQTB8GZ7so4sJwkpm36ZD11JPLmKtSkqn8n7Gj36NZEqstzrHBnbS05nFg/TU
         1fxLBaA8Fo1zacpgb5UMiTRm0HBQSWuoctVH5/CEIUSUl2sxIFiFHqOt8M4+HH34WoI7
         5laWf2tDtqjU1tn3zEBDwJAwonovkHMYvch3aey+l4u1LrN+ml0/SR+qarzj0uf5HUSz
         IoT6TGbd3MYhCQVjGp2mpuj5Vgsn1pIBoA7Gv/FBO6ukEaZLFOcVXiufGkE0SCUXR0YX
         LdrA==
X-Gm-Message-State: ACgBeo2Ckzhk7vR8Yn7SYuO3AdVW3RcFfhH44Pg3cMJYpoDEG6TA6CuL
        RJT4HI372RV6yaSnSq+uMg0vEw==
X-Google-Smtp-Source: AA6agR4i36BKwnhFzbt5nrofdMI9zguLVFQDptYJPNzHeD2uaBjyeKwY6sGj/7hgkqv4/4I0GyS3ig==
X-Received: by 2002:a17:903:41c4:b0:16d:cb15:290f with SMTP id u4-20020a17090341c400b0016dcb15290fmr138336ple.47.1661450210299;
        Thu, 25 Aug 2022 10:56:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o6-20020a170902d4c600b0016b8746132esm5344240plg.105.2022.08.25.10.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 10:56:49 -0700 (PDT)
Date:   Thu, 25 Aug 2022 17:56:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Message-ID: <Ywe33k3yvXCzSh8a@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
 <YwOj6tzvIoG34/sF@google.com>
 <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co>
 <YwZu1K5Rgb1sevsy@google.com>
 <69d74e6a-dd6b-28bb-8011-e204d4ab0253@rbox.co>
 <YwereSW3UPhDNsnh@google.com>
 <635a6f6b-a3b0-401f-dfd4-3a8c27f65774@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <635a6f6b-a3b0-401f-dfd4-3a8c27f65774@rbox.co>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Michal Luczaj wrote:
> On 8/25/22 19:03, Sean Christopherson wrote:
> > On Wed, Aug 24, 2022, Michal Luczaj wrote:
> >> 								\
> >> 	n = 0;							\
> >> 	asm volatile(/* jump to 32-bit code segment */		\
> >> 		     "ljmp *1f\n\t"				\
> >> 		     "1:\n\t"					\
> >> 		     "	.long 2f\n\t"				\
> >> 		     "	.word " xstr(KERNEL_CS32) "\n\t"	\
> >> 		     /* exercise POP SS blocking */		\
> >> 		     ".code32\n\t"				\
> >> 		     "2: lea 3f, %0\n\t"			\
> >> 		     "mov %0, %%dr0\n\t"			\
> >> 		     "push %%ss\n\t"				\
> >> 		     fep1 "pop %%ss\n\t"			\
> >> 		     fep2 "3: xor %0, %0\n\t"			\
> >> 		     /* back to long mode */			\
> >> 		     "ljmp %[cs64], $4f\n\t"			\
> >> 		     ".code64\n\t"				\
> > 
> > Ooh, I see what you meant by temporarily switching to 32-bit mode.  I was thinking
> > we could just make the POP SS testcase 32-bit only, but I didn't realize this test
> > is 64-bit only.  Argh, and so is emulate.c.  And now I get why you added a brand
> > new test.
> >
> > Let's just add a new test.  The above can work, but it relies on the code and
> > stack being mapped with a 32-bit address, e.g. will break if KUT is ever changed
> > to not map everything low in the virtual address space.
> 
> Yeah, it is fragile in that sense. But does it mean code such as
> vmx_tests.c:into_guest_main() or svm_tests.c:svm_of_test_guest() should be moved
> to 32-bit binaries?

Ideally?  Yeah.  In practice, it's just not worth replicating all the nSVM/nVMX
setup for 32-bit binaries.
