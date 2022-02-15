Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED894B7688
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242018AbiBOQz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:55:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242027AbiBOQzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:55:45 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81D8118626
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:55:35 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y5so35856878pfe.4
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ncFR85fN36o35lsssnL+wzNGDTqWC9hiHD/c8p65I4=;
        b=DJvP5WHoBzMbtMh4DC1UgHd3F3NZH6uAbOQ9+lOAr4dk9KlWWjyEJ0cK3iLWVrpM0o
         ucvUE54tj/suLWJdMQbd8+xd2S2+VeF+vhqsincACgfT2Am8n7UelphSp6t0T9VRgzqP
         xBi4FAynS/5RhUaTaFlKu/Aw465/Z3xT7IaOKTEWPXSfhV5kT3m+zyKEIK1xnMILuif8
         6FaCqbGh9D7ZTnlBQieAPkpnQsNKvpAIwwd/iYU/Oc13hevOtlIqxwQEXog4WYIE/kA0
         caiUZdM3bP5l7GD17XMi6GujWP/yoo/8goB350cMd+qww54Q/X4sH85sITFAYrQd2RiO
         4tLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ncFR85fN36o35lsssnL+wzNGDTqWC9hiHD/c8p65I4=;
        b=ZAabITZE0OBXSy3EKyyhFxUhCpSEZmroPeTNEMvEPNm2bEiUqHnUPeoD7/70wEemUZ
         /ru7XF3ltz85lkcangj/OGnrVY3lToh8jEmo0i87Eo+ZsZX8bLo3Jhl8SmqOlXKyDLun
         WoeUcHdB42u3ZzaXFx83Lis5UDCR+CoVo9JKLjAt+h16aEN5QTzKt0NW1NpcjdyJNKFT
         8B/9Ks+ZpHvzL3V3AhnztQ6UsABE97vsM4b6iCQd6/cqY9x6iDacHoG96pzAZVh9VY7T
         4vwo1N6DvF04NGTwzWalk+3cMW8hd3ENs16aTEwjwm43Q+un49TyYPiK80hY0xN0wTgt
         08jw==
X-Gm-Message-State: AOAM531sLsLHgtGLnR5ANIkd5jPwrF4aspUr6bHVZzK33Iv/VJYs5Fnz
        8HXbGaIOWNwGibd5Pn0L2Tvfr9ZJ+pFw8w==
X-Google-Smtp-Source: ABdhPJxNkjayk772NXYsVPDj31XMmXZmRkbRaKzueCQf+WEYb+CAMQrXEiGlLUglpHR9JWyJf1TlxA==
X-Received: by 2002:a05:6a00:2410:: with SMTP id z16mr657064pfh.66.1644944135147;
        Tue, 15 Feb 2022 08:55:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v187sm12187382pfv.101.2022.02.15.08.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 08:55:34 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:55:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/5] KVM: x86: use static_call_cond for optional
 callbacks
Message-ID: <YgvbAyD/4QEGQlpS@google.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
 <20220214131614.3050333-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214131614.3050333-2-pbonzini@redhat.com>
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

On Mon, Feb 14, 2022, Paolo Bonzini wrote:
> SVM implements neither update_emulated_instruction nor
> set_apic_access_page_addr.  Remove an "if" by calling them
> with static_call_cond().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
