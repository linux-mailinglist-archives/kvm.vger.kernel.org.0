Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7AB311938
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 04:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBFC7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 21:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhBFCxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 21:53:01 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A6DC08ED87
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 15:42:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id q131so5336093pfq.10
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 15:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yeCMNeiz4/N/4CmycM03VrWoQHeIEnKdm63IdnFSFvs=;
        b=G6F+1RVEiF9GM0EvHs2dMwOril+1HpHQtrFxawa7jaZsGtTExqadaxFSbWns/QlQE7
         sBGOMYGgUG5u3thx4BD4mf7OQc34PE/NIDLjZWr6hDvTotPZRVdy08k4MsY6IXQFjhhH
         E6BMuqGZLqeJLpA3TFUPvdX8Ca1ZD6cRP9l3x07jEq/wS3GFBdPiBoDd8DDa80A1haUq
         HlqulMhUZzwPfJTGwPlKv6AkEfPoB+pB/xsrIFOaHZKIa313ecpWuy8DijhAzNH3phFK
         re793AhwZx0SZix6qReN+ocgon8HPMWIZmLyxwGLZUZiBP1xfx9t1eH9FyuRbSxZdyC2
         6rvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yeCMNeiz4/N/4CmycM03VrWoQHeIEnKdm63IdnFSFvs=;
        b=R3ILZX01lmXE6+g4m/vWqUq7M+t58AqDKYua7Zh7p7qHay4Aa/M18a0chQQpoMQzLj
         C0DPxkRb686Us+iHhp7Fuj6Z/DVmA1L0/JN72/AqlYFH512NG2lJAoX76gO3jqw15oCj
         X6kgnJ6NBoCc7BbSMuyrHgXyTKOWVIHI8gVOL7MvQXAJEXmtYAw8B/AH36hkDiQbv4S1
         TQp2++A1/IE4ohAzf8avbBl1BisIQdfJb/MHsEQCNaeNQlWNaHYTLn54ROlgSE5MP8wl
         5kvF2nUZYxSm6jTqGnVzi3vKk1XeYcbPdoLf4G5IJcp6t916tnYjA2Z2GIRDiqIfSrjM
         bHbw==
X-Gm-Message-State: AOAM532OB1XqMTL+wdCOdf5ruJXr3dpWrg3gpoBbn5NImWcEm/9ZK23O
        ljLtIPx6dR54bm6TlxklOIsCzw==
X-Google-Smtp-Source: ABdhPJzs8rXXmJEdRIkq9J09L1nx4tZPgQN4YOHvffjK/M7T22mxg2Cy2BpFO09s0ByCzzarfOKUwQ==
X-Received: by 2002:a62:ea14:0:b029:1bf:f580:3375 with SMTP id t20-20020a62ea140000b02901bff5803375mr6901014pfh.53.1612568566171;
        Fri, 05 Feb 2021 15:42:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:d169:a9f7:513:e5])
        by smtp.gmail.com with ESMTPSA id k11sm9982981pfc.22.2021.02.05.15.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 15:42:45 -0800 (PST)
Date:   Fri, 5 Feb 2021 15:42:39 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 13/28] KVM: x86/mmu: Ensure forward progress when
 yielding in TDP MMU iter
Message-ID: <YB3X753GYXQMXYfY@google.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-14-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202185734.1680553-14-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Ben Gardon wrote:
> @@ -505,8 +516,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  		tdp_mmu_set_spte(kvm, &iter, 0);
>  
> -		flush_needed = !can_yield ||
> -			       !tdp_mmu_iter_cond_resched(kvm, &iter, true);
> +		flush_needed = !(can_yield &&
> +				 tdp_mmu_iter_cond_resched(kvm, &iter, true));

Unnecessary change to convert perfectly readable code into an abomination :-D

No need to "fix", it goes aways in the next patch anyways, I just wanted to
complain.

>  	}
>  	return flush_needed;
>  }
> -- 
> 2.30.0.365.g02bc693789-goog
> 
