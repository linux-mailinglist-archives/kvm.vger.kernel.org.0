Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FBF4B2BEC
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352232AbiBKRjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:39:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbiBKRjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:39:43 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F67C69
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:39:42 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id l19so11696935pfu.2
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TvMXYurvNCdUgehPQu7kTC58DmEbnQ86iEZfjMwXWFI=;
        b=do2Tu1PSZdb3VuxITfwJLiRVNCjV3CHZOC6duKl/xD9sjGqnmXYARd/t6BjrBP+fQy
         PHGI2XNxt1W3UXTdz76POfj0R+5LYVSKRcyeot8kDhKLr2HSpkLYNlPX20Iyn/fA8wIq
         pxsh3rt0jGkroIv78oS61UdMk0S4F2VOJdsxerf5vfLNL0B+EdtFi1wJ9/uE1mafreJV
         OKtygIwV2O4MZWPeL8z8S29gOz5YAvzRcE9RhWvSJxkRqtYjft2el0ZL43cY4bSZuWyC
         XLO2iLz/lkNBh4EwxpMPe1BN5eYHdMLqCgGVfKw8oXduYPIW8a+WSq7RjPNrijDjR0iT
         5bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TvMXYurvNCdUgehPQu7kTC58DmEbnQ86iEZfjMwXWFI=;
        b=emicpTwIjS1mKFPeD5xFrcYn6fxf83nolc5RZGw7MNXst89xxiK4AuJJBC++oaNnNf
         +MatOcI+278wjCq0UFpxNqc8wULeIXNHTcN9oAXGt6ZGsrb2lxdxVqOOJcGotnawDAkS
         3NB0m67wBVQOiOTRWA9dvd/tfuhAOQovyGzDiOA0KC017PsKwIBZCWD5Pzf9gNunmWvg
         CgxaOw8XFiI8GzsUKvHbqI2uuHSt879akVKtzLE8ZIngH20E7GGZmK2VdnV0Xdo+lnOT
         +N6iLruzVYXxaImuzfia1Q7Jfx44hQ0kyr/F53m5deKKJCQC049zfJXfchOp4vIGjrOp
         3hfA==
X-Gm-Message-State: AOAM5310pbFh87FvSQIlWRFQytfythVVL0SqdOZLgdIn0C1xWZJD8CSP
        O3K0pLBMwB6SGBnvmImqTu0i/oIUWA+X0w==
X-Google-Smtp-Source: ABdhPJyHp6YDaNYEORsouxWc77v5VMhXKK7h4+vS8y5V966i+wxgdpqWd9ODl9PWTvQ9TKM8KM6VGA==
X-Received: by 2002:a05:6a02:19c:: with SMTP id bj28mr2206454pgb.344.1644601170787;
        Fri, 11 Feb 2022 09:39:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m1sm29072743pfk.202.2022.02.11.09.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:39:29 -0800 (PST)
Date:   Fri, 11 Feb 2022 17:39:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 07/12] KVM: x86: use struct kvm_mmu_root_info for
 mmu->root
Message-ID: <YgafTiXZ4MvSt7/t@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-8-pbonzini@redhat.com>
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

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> The root_hpa and root_pgd fields form essentially a struct kvm_mmu_root_info.
> Use the struct to have more consistency between mmu->root and
> mmu->prev_roots.
> 
> The patch is entirely search and replace except for cached_root_available,
> which does not need a temporary struct kvm_mmu_root_info anymore.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
