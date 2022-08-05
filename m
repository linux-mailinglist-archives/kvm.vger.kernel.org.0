Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E7F58B02D
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbiHETHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241150AbiHETHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:07:01 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F963A4B1
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:07:00 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s206so3421884pgs.3
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=8OaelCQwLAmX8DnBKBU4Ne2mRwL6NSrpZ9PHD8kwTfg=;
        b=SAB+P7PszONb/nw54Oc8HuLcyuhTcgNk7V84Tu5GnWeiqsjwgNmmPXRQyRYXYagjNn
         o2x7NpKmQ11Q+8xx8TaesL/+iZYmhDj7KtL1W0xTkzs9C/869CaoTb91TjccOdzgsjcO
         Y/CTjAcn5GVf5wtoU9bZAIwOkhLSIFV957M8n27H5E69AS3vc+GzW4Gpxq6FaK3RB7V9
         NMW3YdzLiiCA2ueksJmCxhc1EHAvv+EphlZhIvePy7/28t3Kyt2ceXGUdE9bq3luGiD2
         XFbjN9MNzfpscT1S0KJEfq6P8kUd+eU7bQpv6ezO8Ui5F5IAxz3QdnE59SRa9GSm8MCa
         oLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8OaelCQwLAmX8DnBKBU4Ne2mRwL6NSrpZ9PHD8kwTfg=;
        b=O9MMffOoGLG/W/0k3jJRVIAo9ypfrDzWq7NI96RcY49DCVONT2NPXDma6VkUC7Su8K
         Ew5D7z89hJJPkFQRZA28Xxzm0lNGDvV339HFwL2SuL7DSS6ol0Wa1AVLGwz555NK5EGV
         lUA/qZTHfBzTDWa/JsuGdC2TC1Hkg42hlfTfaWpQOOlOgtvw1y9uGoBDX70tAtkXamQk
         RHwidOGe5vhsp7mnbJzx+Qs3NaWYaYmY3UiJJUnF2mvwJq2r9vxob/rM4z5uasllqwSi
         Sk8nt0XTimpSZiTm+L9o3z360xaAwKkBLk/r4yTPDXC50poZSYIUAoduEQ6FmETn+lMZ
         XD7g==
X-Gm-Message-State: ACgBeo3gHcLj4bF4jLR/mS+G8P//6S4RegiBWhRSW28bdCyhCA8gbpJa
        MARAIpx+hPcm1oMC5watTNWspQ==
X-Google-Smtp-Source: AA6agR7SKHHLKIEFew9WyMsb8o4XpZDoFy21+jRdAzZwbUSUMRe+S+9BBWgkreLz5MO59nf+sNEMFw==
X-Received: by 2002:a05:6a00:2991:b0:52e:b387:b3c6 with SMTP id cj17-20020a056a00299100b0052eb387b3c6mr5178908pfb.11.1659726419475;
        Fri, 05 Aug 2022 12:06:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w200-20020a627bd1000000b005281d926733sm3357482pfc.199.2022.08.05.12.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:06:58 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:06:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 2/6] KVM: Shove vcpu stats_id init into kvm_vcpu_init()
Message-ID: <Yu1qT0ly3y3qkmKn@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720092259.3491733-3-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Initialize stats_id alongside other kvm_vcpu fields to futureproof
> against possible initialization order mistakes in KVM.

Nit, I dislike the handwaving, it doesn't take much effort to explain exactly
what this guards against.

  Initialize stats_id alongside other kvm_vcpu fields to make it more
  difficult to unintentionally access stats_id before it's set.

> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
