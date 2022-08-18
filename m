Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9BA599184
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 01:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbiHRXz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 19:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242066AbiHRXzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 19:55:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71069DEA49
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:55:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso6108912pjl.1
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AWtP0u7P1drADzE77AVG8rLD5+HSSz5SKdXunXRuFM8=;
        b=cL8NG/whB9v3KVq2a2XlcCENrHgOx7fp8FcQoQXELCl1Ecm1PAKrhHIx5o6KHRuRWk
         SK9cDMSnsKmsmDp7IbS+0WEwf6FSbGfmSSCJEo1xk1LMQWX7re4Pdmzw0HpZWL4DFpIL
         skFN1YDlrJJF2vYtGj/rjSx0XA7IYA8vvi1eFyaIPPi7CoFurNkHCnLL+7P/s1qDNtwY
         raGIfjd3G+Gmq3tBzrcet1lMOEGk8qd5+7ENYt557Yi0iLYB0SZWdmhq+RxwvTTPPgqN
         EsFlEIYFMSH/fgMg4SoPGj/B+LqNVLJMKt7GYB29NF7zNw887SkK/lelBUzG8xgGcVG3
         YFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AWtP0u7P1drADzE77AVG8rLD5+HSSz5SKdXunXRuFM8=;
        b=WWcG+768eJ83Vl8XIUeuG5gn/u4G//sSJlmOtsJUl7MlhEg+7jqYPM/DIimsgdINXr
         ALmNVD7KsBGnQvPqrdNiy6dqtF25BRsgIftQ7All+5tuTA+2sgaTCFsfb7IkKeP3+Lc4
         AUWjR7hs5a/LzRfLDMPEXePIOOIE3EyCcnRc7ubaRLlrLLUfilknu1AqQTXQDL5OVdY7
         rslo6qo3oKCa6P1KMmnKxTkibEpsJJ0IsE+hb5Mk0xjccR0pW5VXS3qL81U7LUoGTsKK
         9Lu5PftTZCh+C1x7a2e5eqajBQehykDULvXT4YwYX+1UIf5zNkOXczeWzs5HOGVWpKX6
         5b3Q==
X-Gm-Message-State: ACgBeo2tfgozlQ7uLW2CyJaKE9j49gP4suE8mOaMfudvgybF/RAFbjmT
        YcMlJRY5HjPYIFhmHJfEI54GlA==
X-Google-Smtp-Source: AA6agR5Yw8n5fdZV52VOokey3SXceQC19cYCEpGxL4uItmG9H6OsO7aqEAYaHLjY6Pl9CTsm2We7yQ==
X-Received: by 2002:a17:90a:9f0a:b0:1fa:ae10:c468 with SMTP id n10-20020a17090a9f0a00b001faae10c468mr5539774pjp.155.1660866920831;
        Thu, 18 Aug 2022 16:55:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090322c400b0016c0c82e85csm1934038plg.75.2022.08.18.16.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 16:55:20 -0700 (PDT)
Date:   Thu, 18 Aug 2022 23:55:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] kvm/kvm_main: The ops pointer variable does not need
 to be initialized and assigned, it is first allocated a memory address
Message-ID: <Yv7RZCXtatEnvTPf@google.com>
References: <20220812101523.8066-1-kunyu@nfschina.com>
 <20220812102455.8290-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812102455.8290-1-kunyu@nfschina.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Needs a proper shortlog.

On Fri, Aug 12, 2022, Li kunyu wrote:
> The ops pointer variable does not need to be initialized, because it
> first allocates a memory address before it is used.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---

Again, with a fixed shortlog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
