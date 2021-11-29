Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87104624C6
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhK2W1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhK2WZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:25:06 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFC6C01F011
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:43:46 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id iq11so13619482pjb.3
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=niDFyo3G1rrYLOt8y0bOWoIEtaOmWUcRtIojXH/huU4=;
        b=poIlpHi8b0oR5xSmmZcG7qPnyXmrrGC5do16ekvY8kiMC7sswuIY8JkFTC0dkCbVAX
         BrD4jTs5CHloC1OkkmxvWpkYZEv1mL3rj7nZ6HqxRsOEwjLB+XNP/QC0/xQDcMRYxYgD
         myVfVChKDOwZkdoYGGTHSTPKs5SQQxN/7G+Fkct8PYXZs5PZQy72LzDXhsEAQPi5woQ8
         cvPVyBDX6qaEktdCDWmhLLZU3u6O1qF1IVgPC+lYDgNpdA3JoEMnT3C2tw7+1wwVyKuG
         nRpwsQdDd2aGvLZ+6TLDFF+W6FUtQrnp80zldvN6n6M94innEFnQQjY0OdOBJ4QocdFO
         S1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=niDFyo3G1rrYLOt8y0bOWoIEtaOmWUcRtIojXH/huU4=;
        b=wBKB1tFzc1KsHRq/RfLE/RZeBV8kj6QpnFpG9d1bDTzOef3vL4K/VM/tb380tunRtV
         GgkhIv6dQn/GbAxhqJ/76Opm72nkkkJDxviy/gTqdGIRxR4zHC6LjN7dFPf1PtwYVGWd
         fgMXTLvg/R1BeYtq6W9GiZTN08ArAgJDy4CbdBoTO7Nee0AoSLo3eGYydVmGDkQIDJjN
         dr5URuKiGhPr1c6o602ugbsUTHpKs0b/gmUVDSKsRFwdbJ2MFK2f3m8QKm5CMhJxTOyR
         w/PeqxgzUA+6kCZBH/xU6lmPPAKobJAVo8/th+XXCW/m5X3obztjJXfYGEntPTCjHK2D
         O4ng==
X-Gm-Message-State: AOAM532VM9GWbse4YZysucwRHepIGv1Cuzbq6X5aP6z/vVd09VQMkFhG
        kGq7JW8E/y4GwQV2IqoY2lH45Q==
X-Google-Smtp-Source: ABdhPJwrzzMd7ubRgDsRmLa28SG47kKTFX1UJKhOdbW60+i6bUkd0NZPKaaHuFgP2YUUQEjYz6nGkA==
X-Received: by 2002:a17:902:8a93:b0:142:30fe:dd20 with SMTP id p19-20020a1709028a9300b0014230fedd20mr62617697plo.29.1638218626227;
        Mon, 29 Nov 2021 12:43:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t8sm17566393pfe.28.2021.11.29.12.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 12:43:45 -0800 (PST)
Date:   Mon, 29 Nov 2021 20:43:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH 10/14] x86: Look up the PTEs rather than
 assuming them
Message-ID: <YaU7flyPaTb5xJa7@google.com>
References: <20211110212001.3745914-1-aaronlewis@google.com>
 <20211110212001.3745914-11-aaronlewis@google.com>
 <5a08da0c-e0e1-c823-b9ca-173a15aa341a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a08da0c-e0e1-c823-b9ca-173a15aa341a@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021, Babu Moger wrote:
> Hi,
> 
> This patch caused the regression. Here is the failure. Failure seems to
> happen only on 5-level paging. Still investigating.. Let me know if you
> have any idea,

Fix posted, though you may need to take the entire series up to that point for
things to actually work.

https://lore.kernel.org/all/20211125012857.508243-11-seanjc@google.com/
