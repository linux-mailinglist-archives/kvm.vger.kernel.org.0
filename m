Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FC933D5A8
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhCPOZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbhCPOYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 10:24:47 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEB9C06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 07:24:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v11so7537256wro.7
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 07:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U1myjpduufIFHbOjx3MC14gmPXuJUxpXkD0h1tMVdZk=;
        b=orKtTHYuQ/AxMaqkOv5uEGAjqkfhFo6g71B5d/6YVdr5R83v71IWcJwyPLMm9hGeez
         vPAl9OQU798cfL3MGn+dQEq1TCDdtuF+jKCWZQZF69gyNntgvJm564dsGpGFzL0voXxM
         OZBuwXc66wy3w1US4kMx3uOfkQImgIf2NxFAP0MUgPZPlpN8LS51Siw4CuHU1L9VbdBn
         uFlARkm1AzA0m/KPYnKnU33GxnqUqD5qUY07eSXRySqXptvV7Zb7NKSuw1MD0mC807nw
         j80tjsCLAZikF/SHzJ9QOq3r5jZxRXAB79Zvd2zleCjlece3JSaX9MHqTp8TaUGmWPBU
         da8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U1myjpduufIFHbOjx3MC14gmPXuJUxpXkD0h1tMVdZk=;
        b=qpTRQkZrVctZ6jkYEdv4WAK/yDaTAcIMnDDVl5Q7hUgEFxA28QNhtoGzfruixO2wx5
         DEZRBwPfizvU76/GR1L+cdFq70Zdi9O7O1eIkuqdagcP5GD2vhL+8l6rLc9aBcDXhnrL
         cB4+QtPnHfYEMyxL44kAGHiouZVgd/2PxyL0ocuU/97POGpTxbLxat/ROjWwmYMgLn8i
         +m39IuD5VDtK9P2BCl7ZSVT9EV+c50haPfNcAO/pem6zbKYfbkSan8csROicaebmEWp0
         DPu2+uC57820YBYxq/dIarIPNgU8Kgp5ryUyw3RFZDKs7b9CKHUyRPJ9iiLaAF6xWRZ3
         szBA==
X-Gm-Message-State: AOAM531l/Nbxuud2q8wJ41flram0iHIaw6QJdBR+I656ZVbpBSqOKoq6
        SR/D1hzZLQ7fvXtVoOTbjpBoqQ==
X-Google-Smtp-Source: ABdhPJyyMor4Qq/YcVIHZI9X70Br34uiGRVd4G+U5M+lj7mhFa3mulxofA2zCrgyj6FCxFn+sZd73A==
X-Received: by 2002:a05:6000:1281:: with SMTP id f1mr5274571wrx.243.1615904684787;
        Tue, 16 Mar 2021 07:24:44 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id v9sm22615975wrn.86.2021.03.16.07.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:24:43 -0700 (PDT)
Date:   Tue, 16 Mar 2021 14:24:38 +0000
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 08/10] KVM: arm64: Add a nVHE-specific SVE VQ reset
 hypercall
Message-ID: <YFC/pmzqSuXq+3+I@google.com>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-9-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:10AM +0000, Marc Zyngier wrote:
> ZCR_EL2 controls the upper bound for ZCR_EL1, and is set to
> a potentially lower limit when the guest uses SVE.
> 
> In order to restore the SVE state on the EL1 host, we must first
> reset ZCR_EL2 to its original value.
> 
> Provide a hypervall that perform this reset.

Is there a good reason to have an explicit hypercall vs trapping the
host access to SVE and restoring in that event?

It's quite easy to do trap handling at EL2 now and it could let things
be even lazier, if that's any benefit in this case.

Trapping seems to have had a bad rep in other conversations but I'm not
sure the same reasoning applies to this as well, or not.
