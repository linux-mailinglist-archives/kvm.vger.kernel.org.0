Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF14A5227D3
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 01:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiEJXvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 19:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238706AbiEJXvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 19:51:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7363037BE0
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:51:07 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d17so304528plg.0
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SDv9/M1BzA7VTMmYsFak6lTY7tudu1zj7RLfwJHZ20Q=;
        b=OdISotBqCU3W7m19xnBLQg9gZlCsFFBJyrlefGBeCCCkWIzWnICkeo3PynTBBJIx0U
         dHiSvu83sfthKeG1XsQcpB8GmIWu8A70Ss1ldtXvk9rCeGxBzaaAvoCAbAVA5h5GGYQm
         ipjeio4ovfo0lK9aML+vlcXzsD2yJ80+M/GzmJpm5f7GIfI6azuTKSN6ROHgB0hxJxJj
         d0eorAafB/MB4CoP8TW4nxMrxZh4nK/cMk9ybksYPflqgjQ5aZodJJuNGGMHvJTVwuuw
         xXXqng9CpSHH4y3NVsHH1mGs14ZgGG5CeNpXRClfYjpFzUOPfLRdXCn6KmlpIYtOMGGN
         qAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SDv9/M1BzA7VTMmYsFak6lTY7tudu1zj7RLfwJHZ20Q=;
        b=JY3oOaCAWdiAM8vg2b0heEOLnOMUARAe3ClDXE2Iwy5yQ96nXgoYWNEN8e5nRZD/Pq
         uMIuf82seAUNd4OItxFGNIweWUkynsSikSr2pbdSlHoDOyJEdrwiE7dFRfXR5/2x8fHF
         fsXTQAoQFa/FIKAWEvAU7uuV7Uh+1j4YEarZV1ahvPhGCNEnAc3lBw32s8jJW2u1RkI8
         zbX0vbyUi48WrZpA4/zPc8rPBv3fRZRGkXGDI+YTv5uvR22uJkk2TnVrsVU+bh2cCs/6
         5nqZ5tryp6r27WkqenfBL71++u2IiktPIfim+l7sCtlVl3O7pDmU5qP6wtSr4rG83QlB
         rslw==
X-Gm-Message-State: AOAM5301mesksZ3FJy4hapXjawvZAMZV5YWQADYc4gL3xsCPbYbP3pW/
        0WEqu5eSduq4oGAQA1L23tk+cQ==
X-Google-Smtp-Source: ABdhPJyPi2wtKKPIJpmLpb6G+aWIT4Vl+bTW8c+eiyIynAnb1Ix7wKcPg+tOXp5ni4pKtI3owYFMdQ==
X-Received: by 2002:a17:902:b703:b0:15e:ea16:2c6e with SMTP id d3-20020a170902b70300b0015eea162c6emr22759979pls.100.1652226666848;
        Tue, 10 May 2022 16:51:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i64-20020a628743000000b0051008603b66sm101004pfe.219.2022.05.10.16.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 16:51:06 -0700 (PDT)
Date:   Tue, 10 May 2022 23:51:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 2/2] KVM: VMX: Print VM-instruction error as unsigned
Message-ID: <Ynr6Z1G3efTmt3mr@google.com>
References: <20220510224035.1792952-1-jmattson@google.com>
 <20220510224035.1792952-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510224035.1792952-2-jmattson@google.com>
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

On Tue, May 10, 2022, Jim Mattson wrote:
> Change the printf format character from 'd' to 'u' for the
> VM-instruction error in vmwrite_error().
> 
> Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
