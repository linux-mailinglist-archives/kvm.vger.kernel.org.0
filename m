Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013324364CC
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJUOzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhJUOzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 10:55:44 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FBBC0613B9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:53:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g184so541885pgc.6
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9JgyAK70HZyIgAQroR+/u7SFSt9xCvzh8/IOD9dENLg=;
        b=QhczMTaXn7t74TK4bLmsUBajRe+N0lzIvXUlvq8Pv0eVRfPZyaT9QuyKG3qzD5gpaj
         vXSTMmwpi7jaQgLXVQCy/I4U38ELpD/rZySMN/cZY9FX/szQxqd62OiCsHLwEeIDU/Z3
         QrTZl8rhA90Asig7L2z2remcpCTd+3S9SdvmGMFReofdr21WHtgfH8cUWF/p+7awwJvm
         pfiShO+gfXuPIEVh98/745thh0ZesLXDMl4ZaKubah3ZmnkiA00dCIR6geyXtfginjGD
         3fMW9UVXTdYKdBaR7xfdiJdR/RxYVT9o2s5y21ceJ2MQZXI1MShj8aeDGyyr8whAovKM
         S9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9JgyAK70HZyIgAQroR+/u7SFSt9xCvzh8/IOD9dENLg=;
        b=3fLPK5K/qIbYUbCfNuwUm0uU8/TKF0vq5IoahzxM1JVNvSesc0Y0krHoLJUhW6WCFf
         J7NeDwYm9TfCk/7u8oAVNcMAbDJLZo1KSuga0+0WQlNe912IyhaC1lkeNX7VEU6Zs/sL
         06ye9FQNbiScfiD+G+HPufe7LH+c4qIyX0hjxHdtk+3ueYLZPUvG7DkzNc/+MyvjKHoL
         nAjzXgMiBi4gWKbqCM95JbSVNRJGPJUrPrOYOUwNSCLPBwt1PegdBivJSJ+g/xAZXiyn
         uiNKYyBecYsaSyw6njfP5vXjcKNlooHVvT7VsA5Y46i2BXpFDvHwVBp7X+eeD0HOl3+g
         a8mQ==
X-Gm-Message-State: AOAM533b/exHeMaPdv65oBRFXQk1O7cOimuI8nJCxEvNbmvIt3yMCZZK
        vvKe0IHMuCvo8FYHoOy6gjuXGQ==
X-Google-Smtp-Source: ABdhPJyvDw8OHvUW8PfZc7cMgSl/3RBdmSH9ktsJAfkUB65OT/RSSNv+bTMf1dmAFnJBXo4wqgnFHA==
X-Received: by 2002:a62:5209:0:b0:44c:68a7:3a61 with SMTP id g9-20020a625209000000b0044c68a73a61mr5934765pfb.83.1634828008197;
        Thu, 21 Oct 2021 07:53:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t1sm6088420pfe.51.2021.10.21.07.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 07:53:27 -0700 (PDT)
Date:   Thu, 21 Oct 2021 14:53:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: Reset mmu->pkru_mask to avoid stale data
Message-ID: <YXF+5JiP4pDh2/qW@google.com>
References: <20211021071022.1140-1-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021071022.1140-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021, Chenyi Qiang wrote:
> When updating mmu->pkru_mask, the value can only be added but it isn't
> reset in advance. This will make mmu->pkru_mask keep the stale data.
> Fix this issue.
> 
> Fixes: commit 2d344105f57c ("KVM, pkeys: introduce pkru_mask to cache conditions")
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
