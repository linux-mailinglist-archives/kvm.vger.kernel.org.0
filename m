Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8963D3878
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhGWJgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 05:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhGWJgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 05:36:20 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E334C061757
        for <kvm@vger.kernel.org>; Fri, 23 Jul 2021 03:16:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k14-20020a05600c1c8eb02901f13dd1672aso3940872wms.0
        for <kvm@vger.kernel.org>; Fri, 23 Jul 2021 03:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QO4j2IzOM4wXld1oT8EabRjAV6YqFAKfUcj8YzHBVaI=;
        b=p4cx62NpsnLzf2m+W/3JJq7BI22oWbvFv0i1JckRLSteAer4gZOuRH15gI/fN+lg9w
         siVxMEdqDosI3aqGGl9F6jnZHnetBuNBnSOem3WOdiUGAbldFFYf8ZssKFnvBDLp0RmS
         3gn6RnAHQRVq8oJ/fgyOTBg0dO5t/3UaGWuOhKn1C9AVTXq6HOqPeiYtXBBZhgMuXzv1
         mZ++vZrTNqqnqGbbaJTUK5ct3SLLBA3pCzneAjbKfInzuveVP9XdaZMHWxkKSeNCS3rp
         FLE94xYozdI0j4m4CdozhSUBM55Yt7y2y2xXVT+7nPx6aMKsta55M6MB6/snld9AMeTX
         5mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QO4j2IzOM4wXld1oT8EabRjAV6YqFAKfUcj8YzHBVaI=;
        b=IfX62x3ppnD64zV0wRG8o68jAin631j1tovupeE3BplHiE0tmhTf/OwsxjzLIncpJZ
         qfOE5pJm99LZif+ErRVGb2lQJdHrBCiKcmsXTgNPjzCVUBNyW3rmVYi5sPSrevTCRUKl
         /tDfwTubhUv7/Xg8Wmsxd3PYbNy6p34Tmkn2Cs9ZSS3d3j9LVlv8qaY/w9BDvg4NE2X3
         t/EW5X8B9eXc74X5VCjMyewOuaFiO9lZnHvRuBl0JUiL7yKAY5nNgdEx/vh0tQy5y+nN
         2mhhn4LeIMlNmK9NhMUgLT+urMbgnj0rvDtEgbn8QiAU00R3UEOwv7ZfTZiXmsWrbXPr
         4fSA==
X-Gm-Message-State: AOAM530ZVNSvFLTTp6eJ5LcbLq90VX35HcV5RYVtijLi9mgHq1bCrAhn
        xJHqo6dQH3ENDM7+v0IBFWAXwQ==
X-Google-Smtp-Source: ABdhPJwcozbpoFVBs05Zwspcd461WuCRshxtkqBNwhnzq02piQroC4Xf8Z0bCbz4m8KGE6IV7yRefw==
X-Received: by 2002:a1c:7410:: with SMTP id p16mr12979418wmc.6.1627035412079;
        Fri, 23 Jul 2021 03:16:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:a74:efb2:dddd:7915])
        by smtp.gmail.com with ESMTPSA id f7sm32325442wru.11.2021.07.23.03.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 03:16:51 -0700 (PDT)
Date:   Fri, 23 Jul 2021 11:16:45 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YPqXDeRMZOX8bmNh@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <YPav0Hye5Dat/yoL@google.com>
 <87wnpl86sz.wl-maz@kernel.org>
 <YPbwmVk1YD9+y7tr@google.com>
 <87wnpi1ayc.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnpi1ayc.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday 22 Jul 2021 at 19:04:59 (+0100), Marc Zyngier wrote:
> So FWIW, I've now pushed out an updated series for the THP changes[1],
> and you will find a similar patch at the base of the branch. Please
> have a look and let me know what you think!

I Like the look of it! I'll pull this patch in my series and rebase on
top -- that should introduce three new users or so, and allow a few nice
cleanups.

Thanks!
Quentin
