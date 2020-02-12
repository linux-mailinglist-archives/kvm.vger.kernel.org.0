Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6215AD6C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgBLQaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:30:14 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38628 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgBLQaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:30:13 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so1150603plj.5;
        Wed, 12 Feb 2020 08:30:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1IlVs+PoyqskVeOryq4nWg0BV3ImUVF+jcq3kxeboTk=;
        b=jgjqfu+MGvVk/djwqmpMh+YXZSNvoqlNm7J1vPLx6BjvwWiupsIax8Rfuj01WRBSzE
         Q5bnRMRZzTulTZifiRb66wgYUbJEEBT7KxbE9uS5mbfVA0lwRmr7aUXUPLn39jtRGcCH
         6ZjxCftEQI09ldAaWF9X9htWJIZBAZGpC5ytkHexgDUbW2NXcGYLKXElRKLAg5HRGCth
         lu+0F7c/7USoLo6uylTzLIl+Czj/lT2iPI7WvfrWtuhAfy5UdC4U3Amp8co/EmgsIXaj
         8TxYmGPkWr+P+khIhzBEPepji1QakrW/U7Lb93qJNRTP3OVZaxddoltw2z/uu1iHYSc5
         ceVg==
X-Gm-Message-State: APjAAAXA++fLwSJVg0QVMTSe+4G95EhkJQc0PtsW+ErVO0RUgey2zZSp
        GO2MK7+gAqNNWUQqXtg5Mb0=
X-Google-Smtp-Source: APXvYqx5Wx6WVU8t/C3lzNyGG1nBbFeYXoZreqRsnGRq3J0F0tUSVkJseGopg+0FRqyzGnmuRBdpPg==
X-Received: by 2002:a17:902:d692:: with SMTP id v18mr9369625ply.9.1581525011511;
        Wed, 12 Feb 2020 08:30:11 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id j14sm968499pgs.57.2020.02.12.08.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 08:30:10 -0800 (PST)
Date:   Wed, 12 Feb 2020 08:30:04 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 0/4] KVM: MIPS: Provide arch-specific
 kvm_flush_remote_tlbs()
Message-ID: <20200212163004.cpd33ux4zslfc3es@lantea.localdomain>
References: <20200207223520.735523-1-peterx@redhat.com>
 <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Wed, Feb 12, 2020 at 01:25:30PM +0100, Paolo Bonzini wrote:
> MIPS folks, I see that arch/mips/kvm/mmu.c uses pud_index, so it's not
> clear to me if it's meant to only work if CONFIG_PGTABLE_LEVELS=4 or
> it's just bit rot.  Should I add a "depends on PGTABLE_LEVEL=4" to
> arch/mips/Kconfig?

I'm no expert on this bit of code, but I'm pretty sure the systems
KVM/VZ has been used on the most internally had PGTABLE_LEVEL=3.

I suspect this is actually a regression from commit 31168f033e37 ("mips:
drop __pXd_offset() macros that duplicate pXd_index() ones"). Whilst
that commit is correct that pud_index() & __pud_offset() are the same
when pud_index() is actually provided, it doesn't take into account the
__PAGETABLE_PUD_FOLDED case. There __pud_offset() was available but
would always evaluate to zero, whereas pud_index() isn't defined...

Thanks,
    Paul
