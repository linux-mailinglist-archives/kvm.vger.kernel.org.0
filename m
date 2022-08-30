Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2C5A6F44
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiH3VlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiH3VlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:41:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C2F79639
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:41:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso19272499pjk.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=bGJebBHNBGBfTYH52nJ/4zrJRnIOUuR7anRwaOqukIA=;
        b=WuHFymfEyeJPJ9uDED+jghM/Kuvt+GlhvU8D/Kx/Q8h7328CBpHcN1aubI8zx/b6wQ
         puy3Q/stB+05olrbkEtR+sQnMobHxBWaQ+g0UqPIl2dYO4VTuEKL6S9KQa2i2YLOq/sk
         Nj3FGxydua5m03Pq7Lww8TIm2zs9aLOnnQbnbvm78wZDvqC9KQiu1dbnjlK5Z8BSmess
         Xd9Pp1rNP+WchEtFqf8unBrAwwiWcGvbLvOLDkPxBjDhKJ6FRDDCa/eZSgqyVh3bMN21
         Hj4LsogF3FtGMrBUGXNXYHvi7QSvVoFg5/h5wJKhmae891buHYIzPeTPjjwLVhcfnZxd
         sRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=bGJebBHNBGBfTYH52nJ/4zrJRnIOUuR7anRwaOqukIA=;
        b=NzKPmk0sQh2dJcMhQ4G2RnbqQFtPCURrDeXY06UxNbOJkY/oJQziMckZx22kxjwdyG
         iNIREg0a19cXYZ56jR+ACS4WUTYMfnxilvoizfhPkZKd5Sx8Fn4iOlAQfwd+suC2bQh7
         emowjkdf8x7+lng8SEzv5zCW8onStjhn/flsaIBsj2EBaPPnce5CzCjjT4Lx3p833NO+
         6M1Qnco2Rklk5Qb7aGvwRvncXVNBCR0NoF0I3IHXebH22q5u3eOKMxH8QNTSZMGaU6sf
         tCgZJL65Lyj6XVRuAMP6rSOW9eZfdlsPXW5MRP5HeQmk3k5gJh510eyLCTS7VBu/1nBz
         vzLw==
X-Gm-Message-State: ACgBeo0GXQFqjNUxcJEgCVE3yqkfQKqjb7HJkzegsqDnKm5auWVMxQIO
        FyfwY5Z+c417rGxMbkPyKVSuxg==
X-Google-Smtp-Source: AA6agR4xzyqYr1aYePIow4F2ILdiukstffLtjpDe5m4mP6taDyCS/++ThZwOc6iA2dwieAHGGBKWRw==
X-Received: by 2002:a17:902:f693:b0:174:46d7:fb91 with SMTP id l19-20020a170902f69300b0017446d7fb91mr20124738plg.6.1661895676178;
        Tue, 30 Aug 2022 14:41:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709026f0900b00172b616f375sm10086136plk.228.2022.08.30.14.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:41:15 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:41:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86/emulator: Fix handing of POP SS to correctly
 set interruptibility
Message-ID: <Yw6D+IBXAZAWvVri@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220821215900.1419215-1-mhal@rbox.co>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 21, 2022, Michal Luczaj wrote:
> The emulator checks the wrong variable while setting the CPU
> interruptibility state.  Fix the condition.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable.
