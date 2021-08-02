Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989AF3DDDD5
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhHBQjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhHBQjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:39:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA15C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:38:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k4-20020a17090a5144b02901731c776526so32494818pjm.4
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lQAu3LqRARD7V8wp5wecoxa4nteJQMRA6MuSVLanmJ8=;
        b=g+QN9XxtcL7712bfnob7k9h5VQElwSt9LlezSJ34ETCCmRVRzif+mY8hdSGNEcBell
         tPLeAsg/py78/PECQOIM+OUqBDYosOnU5IwtdsPuIEIHB59TN1WxTyAlb0tQIpOezkru
         2iPw2wrbIRRcPGT+DIC4fDTRQtG0IJy+d95X6FlNwGdH/oPQQOlIsP341IgJS8dxUyXS
         tXk77RuZkoPLgtMMy+wfn8zZXcPvOGzTsC8w7H6y5JLysngdgaVAfXyk/7Zrj5A4ntQy
         fCgv5PWzTpCumUGUqHJHeyjcD2/sGLipqjOxsaygpKGGcU52MM1KSKb1T3U/4xrTYPvs
         HyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lQAu3LqRARD7V8wp5wecoxa4nteJQMRA6MuSVLanmJ8=;
        b=E3mDMmFI4gvSY37Trj6DeLPxww8i+RrKHCK5hZVDWF1SRchJO1GG+CjKpRWm1hqy9o
         KgShKLYd9WaRYsBFJD4BQEBZXxiWeiXm21t6tLEF/1aW+y/2dZ0vK2Ogxxku9+q1p/ZR
         OkBeyftyQzy2fDXWV9BNDpsKya2uxtH1sy/AYguymYLZEf9QaS34uy9FZH93v2kBlnYh
         slrIjTOzUagNMqCYFVJIXSc5rRxDYcRy/04zPIBAFXQ1EFBnvSb0yGiACJcbTf+zXRoy
         aHDh+yWNcLQ1EpIS6F4Q70+6MoZ3yKxx9bFRvHEh43Z4tGm3DSGbWvG2GswFEoum8SOk
         wiJA==
X-Gm-Message-State: AOAM532swW8mrsxwcTUUO5ewa62IPF4RKsw4ng00TIh40iT8QPouX379
        +7SOoY2gYGo+nP8fsAeJxOLRWIekry+0lQ==
X-Google-Smtp-Source: ABdhPJxBhZyl0GpAKdf+wrSeD2Qv5y4p3Gh1wke8fQlzxRZ/T6xEEiMac3VFTpYwsnOrihcA97wN7Q==
X-Received: by 2002:a63:6f8c:: with SMTP id k134mr203335pgc.35.1627922336232;
        Mon, 02 Aug 2021 09:38:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13sm375248pjl.1.2021.08.02.09.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:38:55 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:38:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/6] KVM: Cache the least recently used slot index per
 vCPU
Message-ID: <YQgfnE7fM7VW2+N7@google.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-2-dmatlack@google.com>
 <b87b9f52-b763-856f-16f0-ecb668ba22c1@redhat.com>
 <YQgdA6Blu4vYToLM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQgdA6Blu4vYToLM@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, David Matlack wrote:
> I'll include a patch in v2 to fix the name of the existing lru_slot to
> something like mru_slot or last_used_slot.

I vote for last_used_slot, "mru" isn't exactly a common acronym, and the "mr" part
could easily be misinterpreted as Memory Region.
