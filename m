Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DAC52ECF3
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349722AbiETNRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbiETNRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93A7914A240
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653052666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+/TKgozQmA8S48TUFeyHxAZ+3/KdSbiwoYfpe0+qGGM=;
        b=Kz1kwEKNzYtyoGmWxCjQ3IHBsa6RGBbcyYK7r9GvZFmeYU+0oGotpgEE5FPkjeCxn3s+9M
        6BQ75iOPDtyFzac0gmN2YlnGO1xAVAIAEh7MxIJsFtn3oHemaFSIfbujA+mhBzJMTUGsao
        x/K0m3IaOUo54C7bkak0CSy0+sPXT7Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-NeBtCj9ONni-MrDmGBlzfQ-1; Fri, 20 May 2022 09:17:45 -0400
X-MC-Unique: NeBtCj9ONni-MrDmGBlzfQ-1
Received: by mail-ed1-f72.google.com with SMTP id h11-20020aa7c60b000000b0042ab2287015so5625129edq.3
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+/TKgozQmA8S48TUFeyHxAZ+3/KdSbiwoYfpe0+qGGM=;
        b=NQjkYI7iERT+O1CIZS6AILm00A92dZKC+QocqiSwfJVC3VefiOImH0pk9sXg5lqKTD
         t7fyunIKk8LoFQCGHLjjYertk/bIvntu6kAVKglE1HZoBcxpKv0x+tgWgiEmRchwpVR0
         reAKvr6Kmpx/Rk0Bbl7I5/RsQUWz+kI4Dy2sJjToTd+s4ai1YN3JNKey6e6vekf1wnz0
         K1+nNXJaeNSISyX+lKIyhAgRWNXSjXi/2aDmd/W4t6XWuaMBxz79fvpyCGlb/KlfjEWT
         Adv6wgF5G4YCRGeM2rrxvbwh1H/Qwu7+axewD7AuNxWfHIdxyWh1Cy7sFuHlNKy1vfhF
         iB7Q==
X-Gm-Message-State: AOAM530lSQSvAI6E1b6lU+b4KfQTiHv1KJ/Y5HZ0O9KWOuhrTZ7iju7o
        vC5PBXmZWWCnz6Kpnh/GHJNAjtFGSRmP77gUOZ9pe5fzhnw1SlsWPETHU9fgV0up5A86omJo+Dh
        Cqeq3+dhijI87RZEoqJjrEhKFuEq3str17e2axMcbi6XBONrQ+/K4MR+je1iI3g8=
X-Received: by 2002:a17:907:a0ca:b0:6f8:5bef:b9c with SMTP id hw10-20020a170907a0ca00b006f85bef0b9cmr8799198ejc.630.1653052664204;
        Fri, 20 May 2022 06:17:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDtgLamQcdSO7Tm2tjrgVK1a742egM7gnqHBGsMy9/y7sxkgOmWF0fSUq1kmZnqSANh2hgkg==
X-Received: by 2002:a17:907:a0ca:b0:6f8:5bef:b9c with SMTP id hw10-20020a170907a0ca00b006f85bef0b9cmr8799177ejc.630.1653052663972;
        Fri, 20 May 2022 06:17:43 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id 9-20020a17090601c900b006f3ef214db7sm3185890ejj.29.2022.05.20.06.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 06:17:43 -0700 (PDT)
Date:   Fri, 20 May 2022 15:17:41 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: Re: [PATCH kvm-unit-tests 2/2] lib: Add ctype.h and collect is*
 functions
Message-ID: <20220520131741.lytat34cnn2lyqbw@gator>
References: <20220519170724.580956-1-drjones@redhat.com>
 <20220519170724.580956-3-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519170724.580956-3-drjones@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 07:07:24PM +0200, Andrew Jones wrote:
> We've been slowly adding ctype functions to different files without
> even exporting them. Let's change that.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

I need to send a v2 of this series, because besides the trailing
space Nikos points out, I just noticed that I forgot a check
for '_' in argv.c.

Thanks,
drew

