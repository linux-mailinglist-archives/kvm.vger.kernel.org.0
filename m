Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87C57A844
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 22:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239557AbiGSUe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 16:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiGSUeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 16:34:24 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFD2509FE
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:34:19 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id bh13so14540645pgb.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CVFqoqPpzMTSfS6z/ObK/GxCE/nyCodSdH1HcTh0N8g=;
        b=OOysKaA6L5Ut9deA7TsRQ5tzw4WGESf2NyAsiWkyN7Zw72FO/JT56iBLiALVizvXV8
         XyT43pICpvNYur1KzT172sZxrXSWiev8gScdS4RMLOsA5BtTgTKhDuYQackUtaya/2Lu
         ROAKrw1vghS0XRYrgNh5QUWZDSctJopHmvMhT3IexRWdMyMa9OSPS1Y0+gm6jbqFmIBW
         UABMm+XZV79q+aYSZ9CypMytvzCO7uWAoxYVzB0Bazn8whydRq40pxyfe6ik+39q8eA8
         /zuHeZVsY2bWDt7cI/dc3emEOzdvZg1/ee2ZEIH0Whk7qXFGTkCmoxZFX745xVx4Sxqb
         tohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CVFqoqPpzMTSfS6z/ObK/GxCE/nyCodSdH1HcTh0N8g=;
        b=N/Ns3S2oqUlMUfYT09CWdD0O0bmtgT5BDbFoOUw11mG9zn+3M1QwrHSQmME+hDqf8Z
         s+eJ8t7WtEN4aq1tb8dPJpwMurBruC5AHh53dw/3BNz8J3cdV6HemWQ/aMw2npxEoGGt
         EXogyGBiVTZVR1yTp9waeo0lhwHJOzG3hUN43WRKLQ84+LnsCH9pa/13Y1inqggsJXrr
         6/wDXQyY+R8tEpnYz4ukhieLYE9WA4JtFjIwIdB1oMS2dY5T6ga7lFrKFPEBn80xQCSF
         6fzfuCvopqz1se1PhvmxnMjIv5qnPDXs1cNOsAxNT3+dLfeolZ6F9xoLoZb3pTrFccbk
         h7jQ==
X-Gm-Message-State: AJIora+hg6JgDaqgvMnFK7XMjaSgN/IvTpIKmCrnTZppNn31SILZ4RRk
        Q15bzFnpMFt3QiIeph8/G8Yi0Q==
X-Google-Smtp-Source: AGRyM1uGBJ417ylz9TMhQEvOD+j8lKiUWlaChAIsUiWHwqCgozfNEwxEssDNUnfwYwsJpGBx0BIAeg==
X-Received: by 2002:a63:4c1:0:b0:41a:5a80:50ff with SMTP id 184-20020a6304c1000000b0041a5a8050ffmr1771803pge.409.1658262858638;
        Tue, 19 Jul 2022 13:34:18 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7842a000000b0050dc762816asm11850269pfn.68.2022.07.19.13.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:34:18 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:34:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 10/12] KVM: X86/MMU: Don't add parents to struct
 kvm_mmu_pages
Message-ID: <YtcVRnCshyb03Wv8@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-11-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-11-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Parents added into the struct kvm_mmu_pages are never used.

s/never/no longer, and if possible, exapnd on why they are no longer used.  Most
of that can be gleaned from prior patches, but capturing the high level historical
details isn't that onerous.
