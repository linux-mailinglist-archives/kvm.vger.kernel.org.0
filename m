Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DC84E9EF9
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 20:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245234AbiC1Sah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 14:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245229AbiC1Sag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 14:30:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76B91FCC7
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:28:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y6so12855371plg.2
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YlyvxIF/0YN0Eeo4aPYDlfhCsFMnv3Yl/MwBqQ8bL6w=;
        b=SQWMLp74JIN9MnaIYc6XJeRbS01vJZUXXKT2tqD/1JgXHwzA+dIEaH/0vXtsFXxYtB
         DX8f+7exySDhwqX4eBmocwG/bdxKpQ5EWXuPjgY1X8E+/CvZPdMdCbwUP5V73o1lmAxW
         vsehJcM/QLOy45KyNqYKBvS+sEU+qu9R0YA565I0IpOA5tKZF3d2LGPIeEeKUgmuVNcl
         GDfI1sg8+xlZp0z01ci23Y3ma9KVana07fYSR3RGJhIQdP4g5jUTIlpRW2P89pvWdzc6
         VHHUwWldh3D4s9CMZF3nZ7eEE2Y3BBPVP3K82tHPXxjOd3BD9THSjlSO2Abe8LLlveUO
         ohJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YlyvxIF/0YN0Eeo4aPYDlfhCsFMnv3Yl/MwBqQ8bL6w=;
        b=K7FV7cidkyubyYKZvhpw+LfDsCjTXSHRLiy0en/ntWwK9nr1S25QUixi2/JDbEhse6
         z0xoAUHaeMqPujnRifV7qbZQEMduAtw4t0fzXFfsx9Uy7fboF9xPuPgFKgiXhGPXLXg0
         jwIOxWc8UN6EUFfXr6eWu7WVcFcZw4IClUiGd0EbDIHY1b0JLnLe+U/9WZcl60sqmEqb
         CLMkI7ME5ASTo7c1M7W+pIcD+bXtI2p0lElydflK0ma7eHBPcJjBv/HoXl1K6o07yzqj
         ZDqjuYERuUuNNDZMuG+nC6xug8stHRRh4kLHp/bim92yz60kKtOyjBMtGjQBj/TlQTaH
         LGxA==
X-Gm-Message-State: AOAM531PhsBIGbqmA6H5aPMwg8bhw6azbktVKzAbg6thGJDaXlzvehVt
        pEb7pvVmFVbIysQLXWTlJ/kP5JJEeqcFpw==
X-Google-Smtp-Source: ABdhPJwwwHTBrFYRpymZZ2yXC5nODZuULknXzosv6VRrm5aWIubLCzhNQkAvGnBwifIWqRs37q2sZQ==
X-Received: by 2002:a17:902:d48d:b0:154:54f6:9384 with SMTP id c13-20020a170902d48d00b0015454f69384mr27158012plg.83.1648492133085;
        Mon, 28 Mar 2022 11:28:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ds15-20020a17090b08cf00b001c6a4974b45sm188284pjb.40.2022.03.28.11.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:28:52 -0700 (PDT)
Date:   Mon, 28 Mar 2022 18:28:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <YkH+X9c0TBSGKtzj@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com>
 <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
 <YjzBB6GzNGrJdRC2@google.com>
 <Yj5V4adpnh8/B/K0@google.com>
 <YkHwMd37Fo8Zej59@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkHwMd37Fo8Zej59@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022, Oliver Upton wrote:
> While I was looking at #UD under nested for this issue, I noticed:
> 
> Isn't there a subtle inversion on #UD intercepts for nVMX? L1 gets first dibs
> on #UD, even though it is possible that L0 was emulating an instruction not
> present in hardware (like RDPID). If L1 passed through RDPID the #UD
> should not be reflected to L1.

Yes, it's a known bug.

> I believe this would require that we make the emulator aware of nVMX which
> sounds like a science project on its own.

I don't think it would require any new awareness in the emulator proper, KVM
would "just" need to ensure it properly morphs the resulting reflected #UD to a
nested VM-Exit if the emulator doesn't "handle" the #UD.  In theory, that should
Just Work...

> Do we write this off as another erratum of KVM's (virtual) hardware on VMX? :)

I don't think we write it off entirely, but it's definitely on the backburner
because there are so precious few cases where KVM emulates on #UD.  And for good
reason, e.g. the RDPID case takes an instruction that exists purely to optimize
certain flows and turns them into dreadfully sloooow paths.
