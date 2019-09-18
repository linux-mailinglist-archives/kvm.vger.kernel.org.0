Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF538B6544
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfIRN7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 09:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfIRN7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 09:59:38 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3175B21907;
        Wed, 18 Sep 2019 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568815177;
        bh=URXxUBjTk8UN8hvZZXUceR3Yq6XLr/iGGT+FvZ4XYn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1fd+uPA/Jih+61wn+qQpgsNGc105PTeiXWdiJBVprA5edXsLHyGOQ5In6cUpzlE7Z
         b0IPsDAQQx5dUzfuc0jdSiQpbAn2tvTE0bQvwzPhl0IQdO8rCd/LoBpp7OSnIx9moo
         FgJ3wUjfOx5oR5TFWNzXPzivimPLRrAh1ppbu89Y=
Date:   Wed, 18 Sep 2019 14:59:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kernellwp@gmail.com,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "# 5 . 2 . y" <stable@kernel.org>
Subject: Re: [PATCH] kvm: Ensure writes to the coalesced MMIO ring are within
 bounds
Message-ID: <20190918135932.aitmvncwujmjnwyr@willie-the-truck>
References: <20190918131545.6405-1-will@kernel.org>
 <9d993b71-4f2d-4d6e-39c9-f2ef849f5e5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d993b71-4f2d-4d6e-39c9-f2ef849f5e5f@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 03:41:40PM +0200, Paolo Bonzini wrote:
> On 18/09/19 15:15, Will Deacon wrote:
> > When records are written to the coalesced MMIO ring in response to a
> > vCPU MMIO exit, the 'ring->last' field is used to index the ring buffer
> > page. Although we hold the 'kvm->ring_lock' at this point, the ring
> > structure is mapped directly into the host userspace and can therefore
> > be modified to point at arbitrary pages within the kernel.
> > 
> > Since this shouldn't happen in normal operation, simply bound the index
> > by KVM_COALESCED_MMIO_MAX to contain the accesses within the ring buffer
> > page.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: <stable@kernel.org> # 5.2.y
> > Fixes: 5f94c1741bdc ("KVM: Add coalesced MMIO support (common part)")
> > Reported-by: Bill Creasey <bcreasey@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> > 
> > I think there are some other fixes kicking around for this, but they
> > still rely on 'ring->last' being stable, which isn't necessarily the
> > case. I'll send the -stable backport for kernels prior to 5.2 once this
> > hits mainline.
> 
> Google's patch, which checks if ring->last is not in range and fails
> with -EOPNOTSUPP if not, is slightly better.  I'll send it in a second
> and Cc you (and also send it as a pull request to Linus).

Okey doke, as long as it gets fixed! My minor concerns with the error-checking
variant are:

  * Whether or not you need a READ_ONCE to prevent the compiler potentially
    reloading 'ring->last' after validation

  * Whether or not this could be part of a spectre-v1 gadget

so, given that I don't think the malicious host deserves an error code if it
starts writing the 'last' index, I went with the "obviously safe" version.
But up to you.

Will
