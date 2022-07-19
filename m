Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FA857AA4C
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbiGSXMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240732AbiGSXML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:12:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BD265541
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:11:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v21so13346261plo.0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MDB/jWRc9Xajh23m6pM6TUJxABhzEhIq3KDDUhbiofM=;
        b=hGnF4AGZK3imEyE7TkYljfjGVyObt+7NszLD1fgBVsB+iEts2eSwhfR4YgFFpJWXT9
         SNIxu5rNarEWFGEwrI3oCekok5mmkm+0/daZVZnNgeZpk2jUdCm1jn3+hhWORpKSorgV
         Vwose+V7rQm12OsQvryH5753vwlHC09DQYSGrYy0t7CCRz9HxtEjFI/6Boh4VFHwdGZE
         3rKhblolLuTozatYPveOoLMHfMs3u+HA6kB59JRzlY78yFS1Swtp6ouLotDRPcx7dWQj
         4H8h8mZj0XD3xFtvurly7AWLrfjA2l80pi5GX6WZZn9rOIeRxEfHUQaOQF06l9QBoVAj
         t8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MDB/jWRc9Xajh23m6pM6TUJxABhzEhIq3KDDUhbiofM=;
        b=dD3zvP7wXYnDz06BXhn3Zkib3rVD+nCrVKcLJp+EYGsgJusmfufMBEk1dDPdJcj0yz
         LnIScT3oUZGkkGD0gLpxhUAufIKPaQdOjOWx9yNZTSSADlAKigejs/P3W/Yx2Ad1HeXx
         E1EdhRO3JHFo2ILIA3ZWdlmRA9S+DtGUXPCO1ZQ0oxQGmpvfOZSpLf4Z87vIQohTRiLq
         zh9yWtNl6EYZ+9+k3+gdz0bIQaG1hQPEdum7z90V7cV2GmPvAk1HpaaFs/DYDWibeatn
         ajyhz9lw/DvfRfgO5ym1cGOxKom2aNQlhexGyo78idSKYztpJwHkhbVpniTWi4sYDgh/
         wXTw==
X-Gm-Message-State: AJIora8iU/vt0sMz0YlEBpXM8xfxgZnfk8YLsIDStQRTfpIaLV/Ay59G
        1Yxv7iTuTCWmzEptgbAs2M5CIEOXCHUgFg==
X-Google-Smtp-Source: AGRyM1t2bInyU20r85cR9xQ0Th5SsGD18OhUuFnHiFyg50YICO9supSghTrIkBaT+4Nfiru98hkErg==
X-Received: by 2002:a17:90b:4387:b0:1f1:f944:16f3 with SMTP id in7-20020a17090b438700b001f1f94416f3mr2014870pjb.118.1658272318844;
        Tue, 19 Jul 2022 16:11:58 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id r3-20020a6560c3000000b0040de29f847asm10636530pgv.52.2022.07.19.16.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 16:11:58 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:11:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 10/12] KVM: X86/MMU: Remove unused INVALID_PAE_ROOT
 and IS_VALID_PAE_ROOT
Message-ID: <Ytc6O2nsBVTLMiGA@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-11-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-11-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> They are unused and replaced with 0ull like other zero sptes and
> is_shadow_present_pte().
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
