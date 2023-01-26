Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5567D344
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjAZReF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjAZReC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:34:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECBC61841
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:33:58 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p24so2449972plw.11
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yjkve0GkHRTT7LcJVMv9OBtV7u24HWVBrdSJpzuk9SQ=;
        b=lyQLi9NoIwQVMN6ip6uYi4tQscqL20aNad/kOw7203r0uE4HvY8VzxOVPB2hYD/9HR
         iDwKK4PYTSAPeivfMEL1tLNAEUs0KI2RKXjgvlm0+8Wz84GiJLeibvTi2i2+1aDEHa42
         N5uZ7oKRzNusC2TcaeZjsD5OsYM2Kc8usog3MHUllxSD9T7eTs4KVjpazxQrcqDIyCQM
         OAI4S/MPVmBykrWlojF40yg32nWQ9AViy+DNBBw1d9dY0Owdx8cC6h62dtlH5WtHRA21
         C2W21zipXnISiTmEaebFTYvK5ASKtgH0U0ZLOeoRCEeeGwhOi0q2MBE3VY7XihZs9G70
         7X8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjkve0GkHRTT7LcJVMv9OBtV7u24HWVBrdSJpzuk9SQ=;
        b=l0pRjna2eDTvCLOi0cNEHnL3mVIllfC4dPx4kns5ra8L7ksu3g8fvJoVbFS2yi5x3C
         3NvaL6yAUAbdAnW6RfUq0IrbniFXPnGO2rn0UpYEceqgOQGE91t3ILz9x+LbDCokUJ34
         6/3rr3pEHYwfMrW1yXeqoPJheFzz+F414jO4cTkuxozfY0MH+BONQ0k2IpShXbsbIYmm
         FlUqsrjrAo1AmSW//Pk/WP8IkY27vxGhizYhNqWPK4Ot0FCFS8O1pKhl6dks+ywbfgle
         LrNSGyf4i6VuxDWAyPPseI7v8mn8/f3l/BxpTV9MnRuFTYXBEu9ao3uqWhzxiYHUk86D
         EEow==
X-Gm-Message-State: AO0yUKVjyLXqLyRHuUVq2ZrP7d0JGCXfOz9/b+nggzcoZoJaEKj9wZZ9
        g3Pybvt49F/gjc6ptmD2faiBWtLLZHjMMPOfoTg=
X-Google-Smtp-Source: AK7set/P3FSyhNLtnWR3iv9QrVAW5fL4CYxfj/lFkN/Un3ZxP3JDUESOQpVylKvI8/TFltIeG4d/3Q==
X-Received: by 2002:a17:902:7891:b0:191:4367:7fde with SMTP id q17-20020a170902789100b0019143677fdemr1024166pll.0.1674754437315;
        Thu, 26 Jan 2023 09:33:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902c74500b00195f0fb0c18sm1267942plq.31.2023.01.26.09.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 09:33:56 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:33:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
Message-ID: <Y9K5gahXK4kWdton@google.com>
References: <20230126013405.2967156-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126013405.2967156-1-mhal@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023, Michal Luczaj wrote:
> Two small fixes for __load_segment_descriptor(), along with a KUT
> x86/emulator test.
> 
> And a question to maintainers: is it ok to send patches for two repos in
> one series?

No, in the future please send two separate series (no need to do so for this case).
Us humans can easily figure out what's going on, but b4[*] gets confused, e.g.
`b4 am` will fail.

What I usually do to connect the KVM-unit-test change to the kernel/KVM change is
to post the kernel patches first, and then update the KVM-unit-test patch(es) to
provide the lore link to the kernel patches.

Thanks for asking, and a _huge_ thanks for writing tests!

[*] git://git.kernel.org/pub/scm/utils/b4/b4.git
