Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8D94AF7D4
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiBIRHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBIRHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:07:48 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CB8C05CB86
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:07:52 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso5829064pjg.0
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6K6q9ooo1q6qeMlSJENA4JzRbFJs2C2YinZqF/kRUdI=;
        b=ciaDkCOBTmSmdRkz2yI9IaEArDVU/aNXMpnH0ocTjlWnk4YWy4zN9Pko9CE3ZndSm8
         zrrGPCNcNACrkTnrKLI40RxvWhPC5titdzndhIf885JKiR8gXObf4+wsxEllNx9+pVyC
         c2ECKoamHdwR8SG4m5K6+bkxvkAx7+vzP0shSujAy2t7reJSOkhlckcM9hxW8IwaDKat
         h6W7SXTNV3PVBsouxmjN6AOAG4k+/tzsXUe24wvWrXqsoVQQD5IF2jcAOYL8JyWwI1e1
         FvfvA05uLaLQPjJ9shjXSVSXF4x+1xhBCAv9H7GmK5RlogIMdwe/YuRdVcxgRmZ/BDr0
         I6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6K6q9ooo1q6qeMlSJENA4JzRbFJs2C2YinZqF/kRUdI=;
        b=uu8neGMg4wgb9jf/Xx0d9fdWzsIRVvpvYe6wFPccU3MOMlvm8ddjf96THD1ILDZms8
         GQJTzc0m0VdEbAIJdQ6aB4hDTuup4HKrSi6ia6zV3IZ8L5zd2aU9zcRENR6/p2pEnps1
         VRNLpcDSTn7vkg66s+weVrHbRSz2StZtOLmzgmxMp85P3FsFVjG50TAR1gFmzSbCtZF/
         jXXxwcm0XAdQANZ4Hd08wesF/wetkitm1MTF8yy4vv0Y/IRQVUIxsaIOv9KbhDiZnmzh
         lRr8ia2JOqnbDPJNvuJkyyiEcCm0NwauJ9/N5VXwyGPydsr87K6mNGl+28yojQDKYuDO
         yDCA==
X-Gm-Message-State: AOAM531k0YwJd/gG/XG7V7x4f4E+9UX/p2TyGGFO+jH0cV4ffc9ATsqz
        ddSlaNdDX6Ks+BU4GsccPCVt1g==
X-Google-Smtp-Source: ABdhPJyRj2WEf5Sh2K+1SdXq11oh4HE9FQS75xUq5SOSgZ95OpUQpf8kdGauF1dD0N/SLIao4vjSVQ==
X-Received: by 2002:a17:902:eb90:: with SMTP id q16mr2987035plg.76.1644426471305;
        Wed, 09 Feb 2022 09:07:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t9sm6401673pjg.44.2022.02.09.09.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:07:50 -0800 (PST)
Date:   Wed, 9 Feb 2022 17:07:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 00/12] KVM: MMU: do not unload MMU roots on all role
 changes
Message-ID: <YgP04kJeEH0I+hIw@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
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

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> The TDP MMU has a performance regression compared to the legacy MMU
> when CR0 changes often.  This was reported for the grsecurity kernel,
> which uses CR0.WP to implement kernel W^X.  In that case, each change to
> CR0.WP unloads the MMU and causes a lot of unnecessary work.  When running
> nested, this can even cause the L1 to hardly make progress, as the L0
> hypervisor it is overwhelmed by the amount of MMU work that is needed.

FWIW, my flushing/zapping series fixes this by doing the teardown in an async
worker.  There's even a selftest for this exact case :-)

https://lore.kernel.org/all/20211223222318.1039223-1-seanjc@google.com
