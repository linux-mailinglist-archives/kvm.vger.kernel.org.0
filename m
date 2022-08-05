Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C56358B02F
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiHETJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241114AbiHETJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:09:45 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FFD3AE45
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:09:44 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f28so3037695pfk.1
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=KeuvH/XyX0U6SiBPz9fWxnot+vWNedu93ufa3taywxI=;
        b=Jj2AMv9j8PvHzCaFa6do+QpLHqJud6KNwZvJIPqqpZYtk4chzZfylkfbQHZhEFl1UX
         w26aT0pfC3rRT3D3razig1iHLsP6ZLyQxDgpYPwkoYjOgko40I7ADNV8SUtP0XQ9V7hf
         gR+QXbTCVg+5dY/EgZSO6+WmupX70YMjPOYdBpKfzfLjpAVzmeuoklLxwgCY+kaxofc2
         MZ86Duz+YPgN+vrSL6duW25uuvdb21WLPaWrKst6VAzh6VW+mZTSDLj5BwcJyfWk+6fE
         SwbyqNbUxfdsSawZMSwyUfcb0ysHwGQfoZey4mgoF2H+BunCgO86XhIhXdDC6vCsOF+Q
         ecPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=KeuvH/XyX0U6SiBPz9fWxnot+vWNedu93ufa3taywxI=;
        b=Poltd88sN3cS5YuEwslohnsJcJIN57CM0e9ZgozqiVAnsLzZhv2fg8zckHFbdCjW4Y
         cfNgYBoc39UrAF302+YZOIhx/wEtvdB6uYHO1xQcgKgB+66ISmenaswqm4HeM7gTOs9f
         OWrkNVeuR5wtgfpSi79iiSrhUE8Z4whHbUnvMOEsFoGgavC/frQedFJZNXrZIwk4eu6C
         nkPd68rfoYmwpIt4yO4i4J+MBheZkybQ1ifdMiZBt1+lwDyjnH0Pq3q5JugkOn7f+PZX
         rjbwKHJOYLFoeft4jNEtZguzWIGsF0yW+aHwo6UZ3oFN4+iZJ8XdLZAuFoDKvPQ+umcB
         c22Q==
X-Gm-Message-State: ACgBeo1Krp8+snYftminrkK3qM9ECJIQHC6HRsQ15cklkXen7mhYWqfw
        9zfvAOtGsvQDP3bgUCs+nii9vA==
X-Google-Smtp-Source: AA6agR57IYLs5uAz20BbVIu8RmtSgJbAmD4yv5ZDVgXrhCFFaAMOiJFdsPb44dI7PQl3ujLp0PrHfg==
X-Received: by 2002:a63:82c2:0:b0:41b:c0f3:39b3 with SMTP id w185-20020a6382c2000000b0041bc0f339b3mr6810122pgd.86.1659726584280;
        Fri, 05 Aug 2022 12:09:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id gc22-20020a17090b311600b001f53705ee92sm3339979pjb.6.2022.08.05.12.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:09:43 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:09:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 1/6] KVM: Shove vm stats_id init into kvm_create_vm()
Message-ID: <Yu1q9OjS9qBoEZxx@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720092259.3491733-2-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Initialize stats_id alongside the other struct kvm fields to futureproof
> against possible initialization order mistakes in KVM.

Same nit about handwaving.  Maybe it's just me, but even though I already know
what this patch is doing, this changelog still somehow leaves me wondering what
"possible initialization order mistakes" this prevents.

> While at it, move the format string to the first line of the call and fix the
> indentation of the second line.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
