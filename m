Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4574B2BD7
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352208AbiBKRfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:35:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbiBKRfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:35:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63145391
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:35:45 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z17so5227030plb.9
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BGhaxVIEQMKlnFcodkGDs2B0bdbA1zu7/HNHNzxtIHQ=;
        b=TMLCyor1ZmLwTWfr4X1GkFJXppyTuhx25TVidRmaZktchdJmqD3wYAkmh1LHUZTjz+
         B971b9sHPctgI8QZhriH6JfI8XxRY+3vRvzAIc+eurPCXyV0vlTvfbeRb4mNCprKi9yC
         /MQq7b0CJvnAJ9hIQPoq4e1w9Dqch4DtGDxxNHoO7QBJvdtEQiqstXCvvNAyqFflIqNR
         6ntY3bmnR1dqF4c+X8UtZUv2AIral2oQVaP20dmnGUxo2X3xfeAc7fIrtgU4Z3sUD3GE
         QxfJerqjGITv3l/v27fEK5g542vh/WA7tpR85d05sf215sd36X/yZyGynMA3CPCT8kWD
         RP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BGhaxVIEQMKlnFcodkGDs2B0bdbA1zu7/HNHNzxtIHQ=;
        b=COn4k35GfQfcRLcIFkHI1v8/qyrmBDnxdXh/BNXjPWa1foUMQAOy/70JMWFTchXXya
         wMIXEzQSfV2TqIME7TxdMKygjPxf6Fo1ufC8mH2T3N7fk6KAJ7Wd+049isLf5COMA/Oc
         QhWUMnJCDjg18MZtxFvRXw1hkW7Bs/My+/UjElxdCLY+rIOs2P5T0bqc+FwiZFBKnpI9
         /M2uvoOf/OrAXdcrvy2KJkpv8q7vGKiLcRzDWXUpkUpcxAeRGD4fQKB+1IjIcNemNNlp
         GKDrdYNZGBqFroy3Bo9VkOXA1sZwmxgl6gp9UwQ5BDdgfpJ80B6R86/AuToKIuq28/4k
         jG4A==
X-Gm-Message-State: AOAM5311boicTtkO2tIItf1ezddSHgEjsBB0E+0RgFBCmHkLbSW16Csa
        1uaVmmwn5B+M+5KLBwIhCOe0EQ==
X-Google-Smtp-Source: ABdhPJxLBFiNsLm9NmCNa99SYDvQhCe9XTvaZ+13rA/bWT9PyY5haNVekt2sL8iCfJwKFO94LL5fLQ==
X-Received: by 2002:a17:903:1107:: with SMTP id n7mr2665212plh.59.1644600944724;
        Fri, 11 Feb 2022 09:35:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s6sm20408450pgk.44.2022.02.11.09.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:35:43 -0800 (PST)
Date:   Fri, 11 Feb 2022 17:35:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [PATCH 3/3] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
Message-ID: <YgaebIQH+IgsfQjf@google.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
 <20220211110117.2764381-4-pbonzini@redhat.com>
 <YgaYyJGN0v07vfzc@google.com>
 <3f8e8e3d-8bd7-dfd4-f4a0-63520d817c10@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f8e8e3d-8bd7-dfd4-f4a0-63520d817c10@redhat.com>
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

On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> On 2/11/22 18:11, Sean Christopherson wrote:
> > > +		/* Process the interrupt with a vmexit.  */
> > 
> > Double spaces at the end.  But I would prefer we omit the comment entirely,
> > there is no guarantee the vCPU is in the guest or even running.
> 
> Sure, or perhaps "process the interrupt in inject_pending_event".

s/in/via?

> Regarding the two spaces, it used to a pretty strict rule in the US with
> typewriters.  It helps readability of monospaced fonts
> (https://www.cultofpedagogy.com/two-spaces-after-period/), and code is
> mostly monospaced...  But well, the title of the article says it all.

Preaching to the choir, I'm a firm believer that there should always be two spaces
after a full stop, monospace or not.  Unless it's the end of a comment. :-D
