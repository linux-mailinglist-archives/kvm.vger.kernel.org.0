Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A33F1E33
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhHSQkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhHSQkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 12:40:40 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777FC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:40:03 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s11so6432506pgr.11
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VN33ecJB/N6iYLSupDtOUqWSif0qzCkvoXas5eZaMzA=;
        b=LSCRTJ0o9H6zDnys7tBnuU47UZeLzwv6iDbZv2zD6OF6b9SHi2LiwY6HlR1ru16eOj
         1pfau94iaiXMtp2DifgV/n4wzYSfooNKX/nCWYjMiaQNnVlIi5qW1bsYuClY0tnBCJWM
         4QapizNWR36D2PX263D8IWm47zwDxu66CfhxIJ6ws3bxwQziidJ2a/NFTHcET5jfUGkQ
         xlzbHDCbOsgp2k5XTMKF/uHt2HGfypyjO8ztH9v0iiRPdKiSsxI68MQggGQX8fEqq3oa
         wzDW+jJTuCherrd4+TUtTZCTgjCMdiOm/MxR45pXQ/pxYsrISVPuH9I2zz6+SiJN6lYV
         IvgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VN33ecJB/N6iYLSupDtOUqWSif0qzCkvoXas5eZaMzA=;
        b=aZgEw7B5LFI3I69mbFlKWmdmVdkNKO59C7qD8tj914Wur4MIUVkQvpyuS0YeNJD2pZ
         D0WY7HawbyhdnOEPM4kvxNVW3kXnU3ZijELWYpJkniouWzhMBnT4+Vuoo+zkp4RyTdRF
         kJu6qY0lVrp+LwVQ76AJFzS1v2T1NiCTbiaMoIy4dwyiUFeoBKyiayoahNGgxK7eSutR
         Vt+tGaPBT59MMkbCaakwX7lBFGIiUXx9cE7PwNIAu5sx7ZsEuyxTTtlpNqmMtQnSQVvl
         2dt3px+fqHVCVu58zAa88jLloC6+/FSvOZxTI9V7Wy/oRoV3eVBdGHcdDxUhT96DxXty
         OTew==
X-Gm-Message-State: AOAM532NDg04q3J26fu3vLnHeHeedFCquQQAdCO4pSGtTMxrDolb+b6S
        TLIfKvZO9z6nuqln/wV0cVO+qTSXXS+VBg==
X-Google-Smtp-Source: ABdhPJy/RZdSmWTjWCDY8o9lJS5Ty318HLp/Nrdc4cqCmoF4BqTxh6V2isZ7jvoGUdsKGvbjE2PtOA==
X-Received: by 2002:a62:76d0:0:b0:3e3:42d6:c735 with SMTP id r199-20020a6276d0000000b003e342d6c735mr2587532pfc.32.1629391203004;
        Thu, 19 Aug 2021 09:40:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w82sm4091482pff.112.2021.08.19.09.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 09:40:02 -0700 (PDT)
Date:   Thu, 19 Aug 2021 16:39:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH 5/6] KVM: x86/mmu: Avoid memslot lookup in rmap_add
Message-ID: <YR6JXKqSRlDcVqHL@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-6-dmatlack@google.com>
 <e6070335-3f7e-aebd-93cd-3fb42a426425@redhat.com>
 <CALzav=do97h9LtbWJfDaj0xRv5Ccq5m-bPq0u0=_h8ut=M6Eow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=do97h9LtbWJfDaj0xRv5Ccq5m-bPq0u0=_h8ut=M6Eow@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, David Matlack wrote:
> On Tue, Aug 17, 2021 at 5:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > I've started hacking on the above, but didn't quite finish.  I'll
> > keep patches 4-6 in my queue, but they'll have to wait for 5.15.
> 
> Ack. 5.15 sounds good. Let me know if you want any helping with testing.

Paolo, I assume you meant 5.16?  Or is my math worse than usual?
