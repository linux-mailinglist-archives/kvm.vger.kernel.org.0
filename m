Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E584F8C6E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiDHCwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 22:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiDHCwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 22:52:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9F81947B0
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 19:50:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so10747993pjb.0
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 19:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wBJikCNVix4/GeJP/XujfqUfyO9Iyb62x5bGxYVXVlk=;
        b=ABznR/QQdY2sVMyIl+FWJtF9rxdJouNlLr/PW7CTkw/aUrEs11Pc4fS1Z1VkEKQ5JH
         spAkq9ZPWQ1fx4XFDmLtMZeuk+wxdayL4qBnEyHKZF5FwCjGvk9iNnPdXWWeH3Mj7mtC
         ZBP4nwXrBkV06uaWENn/leNhjBx6009xMJlk7iIy5gahQQO7+l2kBimZGyIv6aDra3Go
         B9zx6cgoFp2fTLu5vsD87dPbYHVfpsIqb19K37KGJw8z1+iWxOZU0fKmEs8dy70SqdW1
         R5BjOlStCoE0KaZPK8TL6X8aq4orqSc2qXVDScRzeXVyZBYDtCNL78FOWo4XJZ0D+OAz
         5BjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wBJikCNVix4/GeJP/XujfqUfyO9Iyb62x5bGxYVXVlk=;
        b=Mi46rfC+sIYYyBthk60KlcaiNwj0ofkOTPNd3vJPeMi/+okXaIYJxKbAFf9OxMGURv
         bZxlMl86Dnb+Fkr/Nl6yaLWuARfTN6KhIZiEHoIb99+x5mC8tYQ02R1kRJ4jmHsiNx9X
         wFUy3MCMEyhwIuTQNuRPrLMU9+q5VkeTJ/hOt5Sa3uTu6RwwmfGd1dmy7nYP0V7mQ099
         JVJTj6aKUHXLlMmrxw2E2wwRCviFSb4qYnbYX+kfN8Ie1jvJgQ3brmUUJRGW93fs1kuO
         JmmD933zTDnmiy0mJ0x/xc7aUpKGWput+LOLfvhI1RLPi73MQr/5OjKnOFxMmsX6D+C8
         Wx1w==
X-Gm-Message-State: AOAM532Nx4HEK4B2WaIxz39tiSwW9NV9UhJcLkrMXWb0nf9EeWjKcGTB
        dCEsJXHmPX+6gYuHSbq7pAZEuA==
X-Google-Smtp-Source: ABdhPJzn7iEf+NQfifC4mbFKNe8oJxY/c3ukdNZmhxsGSi8D2t1ouN63EnoC6ns9MlYooDxUkyhVAA==
X-Received: by 2002:a17:902:eb81:b0:156:febe:7e74 with SMTP id q1-20020a170902eb8100b00156febe7e74mr7733542plg.6.1649386229662;
        Thu, 07 Apr 2022 19:50:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v24-20020a634818000000b0036407db4728sm19920909pga.26.2022.04.07.19.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 19:50:28 -0700 (PDT)
Date:   Fri, 8 Apr 2022 02:50:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH][v2] KVM: VMX: optimize pi_wakeup_handler
Message-ID: <Yk+i8S1y9s8YGiST@google.com>
References: <1649244302-6777-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649244302-6777-1-git-send-email-lirongqing@baidu.com>
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

On Wed, Apr 06, 2022, Li RongQing wrote:
> pi_wakeup_handler is used to wakeup the sleep vCPUs by posted irq
> list_for_each_entry is used in it, and whose input is other function
> per_cpu(), That cause that per_cpu() be invoked at least twice when
> there is one sleep vCPU
> 
> so optimize pi_wakeup_handler it by reading once and same to per CPU
> spinlock
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
