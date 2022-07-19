Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944B457A6E0
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbiGSTBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiGSTBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:01:47 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD0A51400
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:01:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e16so14418246pfm.11
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84fQRcLEum7lr3C0S+MQVM+LkmGA7Kz9oOG7rPtZmnU=;
        b=K90YAZNBHhdAnD+6bQCcIgFHrLzFJ9lhISsj+1pbQKv61VT+Gj8auYkXMWVjxo0HWn
         KE6VKEvGlMpLl/6nORc+1A+OoKXfAyNXxUVWUf/PbIMRhDeT6emmyK/HeKIjejDB/ye5
         ReWHZOVdxLzS/IVkNp9746N2808Ff6cwDR06BX/3C3exi4dvAVGP3W+DorQnDJtth3Ck
         z6NKHfv4+JY6s/NEN5ZhC9xYAm0+2Y1RJ9Q76JLlYMdBCQKR4+q3L0y/7vHozs7fWGZn
         kuXDfkIXv8VNwtJvd9B4HCW7mZ8s5ADkMxPV7FqUDHa5S11tDErtDCMO/GZ4eUTOAL2u
         QVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84fQRcLEum7lr3C0S+MQVM+LkmGA7Kz9oOG7rPtZmnU=;
        b=RjwlGE76k6Nqg+eGjfI93VKfH/20tEs8ZoHaeULZMdmEtfCYAwABbT4IObQAIZgaHH
         gnoVcbnN1E+0NI6MSMIoT2OpjkxUG8AXu2RqWpC3dBZqD1h5NpdsHeHxmX61rrOD+jvZ
         nVkouoto9+usUDIiqBiT0ME7C0qGNA3ygKvNnQuq97rZo/O8Gk6VrqP1y444P4/WOnw4
         3ms8989gMlT+NmK4KbGtKS2v37AGwjWZ6vwcpVUrEuv15VizboKIUJJLSHlusHkaByvs
         eAHpRYe7Qlzdp03bLT1+XE0gQ2u3SoZSeMseRiU7+kftqgD74cDXiVVBH6CZaI9iKOoP
         R5rQ==
X-Gm-Message-State: AJIora/5dcS+TotIGjkEN9YKA7BFRCHW9eTbqWLWggFjXIzmFhoiZNsN
        dmkGe3jeUPiKLPj8UQM1TeB6gg==
X-Google-Smtp-Source: AGRyM1uQeFTRjAK5aiqH0ucgUG+WJv1wP0VVilxGBCHQZWOTCBJXavprlX28/5q8Z2sjIaN/W7IyRA==
X-Received: by 2002:a63:d94a:0:b0:412:6986:326e with SMTP id e10-20020a63d94a000000b004126986326emr30936585pgj.56.1658257305747;
        Tue, 19 Jul 2022 12:01:45 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u23-20020a1709026e1700b0016d01c133e1sm2390230plk.248.2022.07.19.12.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:01:45 -0700 (PDT)
Date:   Tue, 19 Jul 2022 19:01:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: X86: Explicitly set the 'fault.async_page_fault'
 value in kvm_fixup_and_inject_pf_error().
Message-ID: <Ytb/le8ymDSyx8oJ@google.com>
References: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022, Yu Zhang wrote:
> kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
> e.g., to add RSVD flag) and inject the #PF to the guest, when guest
> MAXPHYADDR is smaller than the host one.
> 
> When it comes to nested, L0 is expected to intercept and fix up the #PF
> and then inject to L2 directly if
> - L2.MAXPHYADDR < L0.MAXPHYADDR and
> - L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
>   same MAXPHYADDR value && L1 is using EPT for L2),
> instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
> and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
> may happen on all L2 #PFs.
> 
> However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
> may cause the fault.async_page_fault being NOT zeroed, and later the #PF
> being treated as a nested async page fault, and then being injected to L1.
> Instead of zeroing 'fault' at the beginning of this function, we mannually
> set the value of 'fault.async_page_fault', because false is the value we
> really expect.
> 
> Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
> Reported-by: Yang Lixiao <lixiao.yang@intel.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

No need for my SoB, I was just providing feedback.  Other than that, 

Reviewed-by: Sean Christopherson <seanjc@google.com>
