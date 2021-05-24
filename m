Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E013138E697
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhEXMai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:30:38 -0400
Received: from foss.arm.com ([217.140.110.172]:41710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhEXMah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 08:30:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02C2C113E;
        Mon, 24 May 2021 05:29:09 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.38.161])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D91A03F719;
        Mon, 24 May 2021 05:29:04 -0700 (PDT)
Date:   Mon, 24 May 2021 13:29:01 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Joe Richey <joerichey94@gmail.com>, trivial@kernel.org,
        Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Message-ID: <20210524122901.GH1040@C02TD0UTHF1T.local>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <YKuSEnfEbjpOOgLS@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKuSEnfEbjpOOgLS@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 12:46:26PM +0100, Christoph Hellwig wrote:
> On Thu, May 20, 2021 at 03:43:37AM -0700, Joe Richey wrote:
> > This patch series changes all UAPI uses of BIT() to just be open-coded.
> > However, there really should be a check for this in checkpatch.pl
> > Currently, the script actually _encourages_ users to use the BIT macro
> > even if adding things to UAPI.
> 
> Yes.  In fact it should warn about BIT() in general.  It is totally
> pointless obsfucation that doesn't even save any typing at all.

That's not quite true; the point is that if you use BIT() consistently,
then even when you refer to bits 32 to 63 you won't accidentally
introduce shifts of more than the width of int, and the definition will
work equally well for assembly and C, which isn't true if you use `1UL`
in the definition.

With that in mind it's shorter and clearer than its functional
equivalent:

  BIT(x)
  (UL(1) << (x))

So IMO it's preferable to use BIT() generally, or _BITUL() in uapi
headers.

Thanks,
Mark.
