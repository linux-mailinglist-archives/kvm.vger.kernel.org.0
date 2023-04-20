Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B03B6E9D49
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 22:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjDTUfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 16:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjDTUe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 16:34:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EDB1738
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 13:34:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b46186c03so1861600b3a.3
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 13:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682022896; x=1684614896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g58JHmfwpqb+kdcyIIUKCcsoNGL22q/TQUafEKPouFM=;
        b=yM/rfgIiL7qa/r6FEiXZ+DundVuYdHeDTmEggRdeVlHfdLlrzG2d03dBP4XcGkWtW8
         m8Jnf9vlrMgwUwy4aswpamun8XbcX75TKbAESP0T1R0lEL+JfSqXvqobQXIk9UV2uecB
         tauWrgVucEt4cA+QbsMaABdvDWf24twVrg1mCGmeKPjHTd37DzqIBYiU1V/FSDFjq5mq
         sN3dH0H55SQMzfZHNaXD3T6xP5ZvPpyS7IS1PGF9LyZ1K/Kxewb70TNbfqHw49H152Wn
         AiGtVpXgSb5rg5Nq4YWD7M9/bHiUKRthkUQUOAmMvT8HV4owNMuVhQUQYjgo3WWWr+hp
         IPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682022896; x=1684614896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g58JHmfwpqb+kdcyIIUKCcsoNGL22q/TQUafEKPouFM=;
        b=CMR4SKI0GmmddmmbQNV2pWwHBABa1m23L8kfzFPyqdFy79/DsrSssoOkhqFPI1M/Z2
         6YcPTtRBN6/7gcaRr/2KMFvHCjs0kETQpDgdad+uKVilEWQWCyLPQLgUc0YiWP33wiZG
         R4T21FiRXPDw3J9fxajn5svIt5bMltL/qMVfEv5//4/+nXCzCiIqSnBILpN2tb+ZWQaY
         vKGnO4lAHkAk6gJbeff+JFFyCVly2MJeiwElBLYvUtaZRpG5k4djVMcRzMch4Hs0yUMO
         ngsArARSd3wtg7x+IEJl+pK1QlqL4n2uz9nBYLc/JxdFtKqREzI7zNteJLOlHBCFs15M
         pO2Q==
X-Gm-Message-State: AAQBX9fgiaxENzHgUUHUq2mWLwy7QsxGObFQvhFy8NNRIMzCUDCfMSXE
        C998gZoVRaSLjTmjlLZaKqSiSg==
X-Google-Smtp-Source: AKy350Z4E4ZbTxyicE8TdX2kjDVkcL7PKYR9XpKyGdNFQfEdAoO/0RfXn8bHfgfIvn3rur5vk1QN6g==
X-Received: by 2002:a05:6a00:138a:b0:63d:3a18:49ed with SMTP id t10-20020a056a00138a00b0063d3a1849edmr3458395pfg.15.1682022895937;
        Thu, 20 Apr 2023 13:34:55 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a0023c900b00594235980e4sm1628138pfc.181.2023.04.20.13.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:34:55 -0700 (PDT)
Date:   Thu, 20 Apr 2023 13:34:51 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
Message-ID: <ZEGh6zrhJX/SN9jp@google.com>
References: <20230413231251.1481410-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413231251.1481410-1-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 04:12:51PM -0700, Sean Christopherson wrote:
> Preserve TDP MMU roots until they are explicitly invalidated by gifting
> the TDP MMU itself a reference to a root when it is allocated.  Keeping a
> reference in the TDP MMU fixes a flaw where the TDP MMU exhibits terrible
> performance, and can potentially even soft-hang a vCPU, if a vCPU
> frequently unloads its roots, e.g. when KVM is emulating SMI+RSM.
> 
[...]
> 
> Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Link: https://lore.kernel.org/all/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com
> Link: https://lkml.kernel.org/r/20220209170020.1775368-1-pbonzini%40redhat.com
> Link: https://lore.kernel.org/all/20230322013731.102955-1-minipli@grsecurity.net
> Cc: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>
