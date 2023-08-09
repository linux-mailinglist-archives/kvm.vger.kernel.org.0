Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3CF776560
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 18:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjHIQrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjHIQrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 12:47:46 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC361BF2
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 09:47:45 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-76cab6fe9c0so7027985a.0
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691599665; x=1692204465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TKLYw5a4wl46UvTRd+wqHFOPUEf9fKU8e+XgZSVZNng=;
        b=UZTtAGbLc3K12uqEvG0cCmTHPST1v5Wbf0478+3O7Ckqc53+8RtxnB4+1jq/p2R0Bo
         ulm6Slf37pMz23waX3upGsvgQ3E35cKFkScVLm19DIsLYShJttd0jkdKbaLxTcUuvdBg
         Hr70lBnodEz73mGydQJEBJyJRsETzs3E9ey5FTqjZj4dVwb8wA7BjTWH+XtbDkH+GNTv
         HS5KLGULyR0hExNiF3c7QNqivit3NOdL15cFRAFvDKKDOK/UE/6BAuxE3YUqdd/fdanZ
         FhaDxzymytwbvZFl26n0u1moieBzNKfOtaK6KneNyofhYxodGKgAjQKd3CN+vCOblUlY
         Ap7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691599665; x=1692204465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKLYw5a4wl46UvTRd+wqHFOPUEf9fKU8e+XgZSVZNng=;
        b=MSZ6A2S72jKqLbBmd1SI1j28dp8LMz5VuMhaO9TZVYVWTet0SzIM5XzZKpQjitX1J+
         IsRijJ82cGN3rX/IrRI4KPdHIvc0z0OUikuGZqj0gATU/eoUJCyRFAID5SNp5YlvxPFO
         sPDpQcAEihrkfWvCa3IKL3c4afnYadngFCvXNuWNYxmtZpNtPVngCSamJxTZneRjavv7
         Uf0MGqVGfgdbnmSzQoX4cUfc/ErOBm01U62mCP0vUJEViAy038qnTlMSyun6Rgg9ENhV
         ZdbZsOnkBLgMg46tMSPAR/T6jihhmycJUzyvwi/44aSnaFHwkk5OPf/LfQJu/1tnM3fI
         OzsQ==
X-Gm-Message-State: AOJu0Yw795odSe9bo6SGdv1IGcXpgh81Iudk/tLJBY5X3BmlbepUJslB
        T+TEYlXFvZVeXyVebVQxHm4q4A==
X-Google-Smtp-Source: AGHT+IFRn8dA0ZK+Uka+o0QNJ8QXllmNjP7TWFhaMs/FaD/CpRa3IV+xWwCG1pyRTy9rwrWogdnhkw==
X-Received: by 2002:a05:620a:40c5:b0:76c:e764:5059 with SMTP id g5-20020a05620a40c500b0076ce7645059mr4328174qko.55.1691599665098;
        Wed, 09 Aug 2023 09:47:45 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id j11-20020a37c24b000000b0076ce5622df1sm4104961qkm.3.2023.08.09.09.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 09:47:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qTmLX-0054uK-A2;
        Wed, 09 Aug 2023 13:47:43 -0300
Date:   Wed, 9 Aug 2023 13:47:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     diana.craciun@oss.nxp.com, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH -next] vfio/fsl-mc: Use module_fsl_mc_driver macro to
 simplify the code
Message-ID: <ZNPDL82H28AqCUtU@ziepe.ca>
References: <20230809131536.4021639-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809131536.4021639-1-lizetao1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 09:15:36PM +0800, Li Zetao wrote:
> Use the module_fsl_mc_driver macro to simplify the code and
> remove redundant initialization owner in vfio_fsl_mc_driver.
> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
