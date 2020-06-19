Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658782007C7
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgFSL31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:29:27 -0400
Received: from foss.arm.com ([217.140.110.172]:53258 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731047AbgFSL3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 07:29:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15641101E;
        Fri, 19 Jun 2020 04:29:24 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA7FA3F6CF;
        Fri, 19 Jun 2020 04:29:22 -0700 (PDT)
Subject: Re: [PATCH] arm64: kvm: Annotate hyp NMI-related functions as
 __always_inline
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com
References: <20200618171254.1596055-1-alexandru.elisei@arm.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <0236ea68-ec6a-44e6-97e3-eee05de9476c@arm.com>
Date:   Fri, 19 Jun 2020 12:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200618171254.1596055-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 18/06/2020 18:12, Alexandru Elisei wrote:
> The "inline" keyword is a hint for the compiler to inline a function.  The
> functions system_uses_irq_prio_masking() and gic_write_pmr() are used by
> the code running at EL2 on a non-VHE system, so mark them as
> __always_inline to make sure they'll always be part of the .hyp.text
> section.
> 
> This fixes the following splat when trying to run a VM:
> 
> [   47.625273] Kernel panic - not syncing: HYP panic:

> The instruction abort was caused by the code running at EL2 trying to fetch
> an instruction which wasn't mapped in the EL2 translation tables. Using
> objdump showed the two functions as separate symbols in the .text section.

Bother. Looks like I didn't have CONFIG_ARM64_PSEUDO_NMI enabled when I went looking for
these!

Acked-by: James Morse <james.morse@arm.com>


Thanks,

James
