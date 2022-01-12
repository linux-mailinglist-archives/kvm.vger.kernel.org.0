Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED3848CADA
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 19:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356238AbiALSXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 13:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242533AbiALSXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 13:23:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679BAC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:23:06 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso13899317pje.0
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gx1/hMlyYwJjfp9cEOVnvVvGiXTS1x2pISnZTPYG1vg=;
        b=nZ3xByFzxGoAfxCriiwtMd87fa9zZbyCGoKMFfJtvzZBhUlifADKleyZ4sUHd/A4Nl
         mSz9FZBoQ9GXV9Xu/ZzwiE8oah30RKmc+BNhP9uWwRV2p2vRFmHEg9z2adldInEzXkl1
         eLJhqRkH+q487e/ruJ9F+VNHeOc7JTay9Xj+uCZuHzSARQFh7/D/hatqTdXMJGm+2rEp
         0oneDMU+/mLXuna1YMXIj7SFU98xyTYJCUxgifhG3kdItFwqbjOE3Ikl8RuXRMKzlafY
         YDu4yPi8QLUFNpi52NGQNnd7uM4ISL6mv6YDWz37MseO0ZluqxMxih2osTmAf7aizRRg
         +hKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gx1/hMlyYwJjfp9cEOVnvVvGiXTS1x2pISnZTPYG1vg=;
        b=BQTkJ3BAmqv6db2sbnD0HMTJ4pq6yasw1TCSCbc5v4/bJrbm17ED2prLEeA7LBZ1Cc
         cz8jB3hq4YVWNLj137XEuUOjBuRT+gZ9QfHBoZqDHc7+G7BKSzw3EkkHx5lP3P6eAznx
         SDBAOXSh1a8aFp7RBYuAO7NqnoozOnPyxNPg92NxVkOT3Sc5MnYzkh3BLWPOM3xqtwuv
         +Iwzrq6wGREtJwO/klQG2I0EnhD2pUHEydw23T3DqiXOeA/kX41Sq5Vf3j6P+lYn6w4K
         BG8YHD5CZgNGOOVNr2udRl+kwoTqw1+jEn7TTFdwBZx//6OFrRRH3zDfC+1nRhp+Bkxw
         W6AA==
X-Gm-Message-State: AOAM531GXSJRK/A4b1Xtrw398mOTkzobK3MfOxdZ+dz1kColbDdIE255
        OMCf2ekNrFkpAiVplF81SdG9Gw==
X-Google-Smtp-Source: ABdhPJzL5TXEMu2oRfAZkV9rNLyVNLQCOfAcDRgj9mBp7c9ooqpsQzjM1UnWhrE4g+YCVZDX7maupA==
X-Received: by 2002:a05:6a00:c89:b0:4bf:29cf:b055 with SMTP id a9-20020a056a000c8900b004bf29cfb055mr580399pfv.58.1642011785821;
        Wed, 12 Jan 2022 10:23:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s8sm267991pfu.190.2022.01.12.10.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 10:23:05 -0800 (PST)
Date:   Wed, 12 Jan 2022 18:23:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] x86: Assign a canonical address before execute invpcid
Message-ID: <Yd8chbAyJA1XB9bY@google.com>
References: <20220112025535.430455-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112025535.430455-1-zhenzhong.duan@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Zhenzhong Duan wrote:
> Accidently we see pcid test falied as INVPCID_DESC[127:64] is
> uninitialized before execute invpcid.
> 
> According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
> address in INVPCID_DESC[127:64] is not canonical."
> 
> By zeroing the whole invpcid_desc structure, ensure the address
> canonical and reserved bit zero in desc.

The changelog should also note the opportunistic change from "unsigned long"
to "u64".  It's all too easy to forget that they're equivalent due to this being
64-bit only.

Reviewed-by: Sean Christopherson <seanjc@google.com> 
