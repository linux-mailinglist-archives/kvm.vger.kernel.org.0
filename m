Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC05973E7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241081AbiHQQMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbiHQQMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:12:17 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AEAA1A5F
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:11:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 202so12344610pgc.8
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=xWBAOz0eFV7zIDbajYRVEfhlshsoSDr9ZPkQQdAP7pc=;
        b=h7SljiIm/8xW6DLM4pfThX+2kjj5AwTCj9EbQfSLlIz0boS3dp8kEmHXrcrEDLTZjB
         fBsHWWSdYPF7EKp59OCi+F0zl/zrQbpuhEHH83c+pjd0N8aKYWLDmHvyzxTrw/ogOApS
         1PGz9H88SM82/R4sxNrK9xNLskSN8fJMKnYqefcCnveZO4Lx6ZmfZgqkTN3XV8lfwurp
         OW+X7Hti6PwPUX+QRg/E5FosMbDg3Ou4SxbF4e6aD91g9iWBlNbHWHfnwvw3EVA25eOn
         eqkJ5vGGzgC2PFJsT7C4dLYXG5mfDgAwwu50eQzqqjbwtMe4KmF9RfszNt4PbZ/T87oe
         5Rgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xWBAOz0eFV7zIDbajYRVEfhlshsoSDr9ZPkQQdAP7pc=;
        b=y2qkSGjCX2QjpMKsQ4HFY1ZJC1s+oaqjIbIR43TckmdLpEqnWMCk0opHU24qyJKUrY
         r9avnXmyWahwKdwZoPioLX992+pEfpmrUvoyDGSUnH8C/iPBhGBgNoLWgQbG+ClfDUVA
         BYQCJYesHdf4fBdglM3zjNRoPMp8564AKIVAiT0xzmV8NIllfU3sVWMC5AN6M6e53v4W
         PiCjVBsNQ1w7G4tJ/5Mbs2Z0aa1aKPFEOJTnxLr6mbQ3FaezDg3BhD8rUbWe+zZhdJyP
         pLu3RGxbis14LEx4oiCc3TVl67Bl+SZhujBD31/QgmvnSbe/MKxesQnHatedXs79GSdC
         bTpw==
X-Gm-Message-State: ACgBeo1Dz4TSFF0VfaDaoQ9Upe4gZ4ce0GK5FxqYF2rcqnQG5Ts9PHwK
        Yhey3M4POPW5cXXiYCoMngRQbQ==
X-Google-Smtp-Source: AA6agR6oKTRDycnGMDNJZWbSnb/UMGWAjGjto2V/nR4GLuW32gwG3tuh8tYjvi+yzQ0JHLyBsMDwwA==
X-Received: by 2002:a05:6a00:1996:b0:52e:b0f7:8c83 with SMTP id d22-20020a056a00199600b0052eb0f78c83mr26718408pfl.59.1660752699369;
        Wed, 17 Aug 2022 09:11:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m19-20020a170902d19300b00172a4170ff5sm110004plb.86.2022.08.17.09.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:11:39 -0700 (PDT)
Date:   Wed, 17 Aug 2022 16:11:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        leobras@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] KVM: x86: Always enable legacy fp/sse
Message-ID: <Yv0TN0ZI0LNFMGQD@google.com>
References: <20220816175936.23238-1-dgilbert@redhat.com>
 <YvwODUu/rdzjzDjk@google.com>
 <YvzK+slWoAvm0/Wn@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvzK+slWoAvm0/Wn@work-vm>
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

On Wed, Aug 17, 2022, Dr. David Alan Gilbert wrote:
> That passes the small smoke test for me; will you repost that then?

Yep, will do.
