Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195C9648C68
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 02:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiLJBji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 20:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiLJBjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 20:39:37 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCCD9B295
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 17:39:36 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k79so4910201pfd.7
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 17:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hS4vNkG2TCDFUYWNW9tEDdubBmnPpk9OgMq7cBBABXE=;
        b=nw5IR2Mqe+mwULIDCjsWH34GHfeXxnsxRvMrc8zzCGsz6jYkvJPRB8VKJ4wf8mpJur
         i7P82RJHWahOBcOlifPb40NgucHWBswdX3GdjsJDoQvgSAw2G70nEcq4wVmMYpvYFwmU
         R49yOoJElfGznvMny9fjfHqZXCyF+olmIE7YMC4gKiXvAhMfFNY9VUGfT6n2tAoL1cPv
         5SsWGBtIappF6nVgjG/nRIhhJhrUgm3cr/kHAi0m+JC33rTA8LvZf/Omx4hMlm21ptTk
         JFS72ZCmeMPSOaRQFSAfFXgJHoX6/BDHbbpLvcwvyi3osjJFPTv1VkidaES++gYiz50O
         FSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hS4vNkG2TCDFUYWNW9tEDdubBmnPpk9OgMq7cBBABXE=;
        b=nrEOSmE9lmFMJ+QHgNi+0WF2o2gbjvbUUX1+M1XmjzjyjsG98M2DUOOjW1YTNzU3vs
         88B97H3MkpAmB+seDzpFwZlwhwY60YT/CpzS8Ib/u80cpqwwoVk1xSqrgw3fprOq4bzh
         JwF5ahBzuN+jH/N3GfFS27H2MMEcIEwVcq8DjyVjVj3ZDs+vY9OKZZ9GoAYFQVqs1aTm
         YB6O+2FCF0WMSRyNanuZmXRsnJyUUT3CiEG2RZNb379gbxWOnzpz5vuB00vSAF9ZpaUd
         qu0VxzYLibarXTBiGs7FjvF8maMPojoAWkeQ4v7I7bDnzx3em9tG99CTIaKy8ahEE04l
         f9Vw==
X-Gm-Message-State: ANoB5pmS2nlhhqw8zNRosd1Vmfe5BXhMZ+qkJtLq2H0EE7AM0Yk1TycB
        NiXP671VFhvlu4ZviSrtQsSfwA==
X-Google-Smtp-Source: AA0mqf7L2HySjjtzdvJytf+0kS6QHWPOtbc69oKwfeVdE/enJx0PIIQ2WD9xMZhzyrTwo6mwy7irBQ==
X-Received: by 2002:a62:380d:0:b0:576:9252:d06 with SMTP id f13-20020a62380d000000b0057692520d06mr121820pfa.0.1670636376102;
        Fri, 09 Dec 2022 17:39:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h76-20020a62834f000000b00561dcfa700asm1783411pfe.107.2022.12.09.17.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 17:39:35 -0800 (PST)
Date:   Sat, 10 Dec 2022 01:39:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 13/13] KVM: selftests: Test Hyper-V extended hypercall
 exit to userspace
Message-ID: <Y5PjUwTU2KGo5xq3@google.com>
References: <20221205191430.2455108-1-vipinsh@google.com>
 <20221205191430.2455108-14-vipinsh@google.com>
 <Y5OxMBSlzjv3w9YW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5OxMBSlzjv3w9YW@google.com>
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

On Fri, Dec 09, 2022, David Matlack wrote:
> On Mon, Dec 05, 2022 at 11:14:30AM -0800, Vipin Sharma wrote:
> > Hyper-V extended hypercalls by default exit to userspace. Verify
> > userspace gets the call, update the result and then verify in guest
> > correct result is received.
> > 
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: perhaps?
