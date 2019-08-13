Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8418AE51
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 06:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfHME7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 00:59:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50391 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfHME7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 00:59:11 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4670qd37Ttz9sNF; Tue, 13 Aug 2019 14:59:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565672349; bh=zEBhVZ6IpXDU4PYZ9P+PigemVld0vncVI7JH/weoHsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfdf0QquNKcWiP9FC0OfWcm5hNPpORqt+0lxo3RUcH+SaRi76xamqMtyqHdKIQBNz
         QfZa70VSnv5bAMZJD38VWzA7Yt2lMzts+TbsO4ftSoT3Lz0AqunsRCQNNpRkWlLyBo
         06jnKnzdAy3NBe8ftweSiWlGm8BFlvvR5s8iLrGyWfWf8n0pfhXKikSCOq4xn5X1ah
         ++klMjYhH4FNsq9P007EzLPHCdF+++6qmbkq82X0FYM/p7s0ZSkih+FzXdywu2DuaI
         8zpvR5nrgqLXX6QpAXIhX6/zrg8rVUDl+7rm1Wy1kTEAzOZtbOk95HYG3QTzbZ3QOb
         5Z/k0KQiXu3qw==
Date:   Tue, 13 Aug 2019 14:59:05 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Fix race in re-enabling XIVE
 escalation interrupts
Message-ID: <20190813045905.nsoi7u2ke3mz4qkq@oak.ozlabs.ibm.com>
References: <20190812050623.ltla46gh5futsqv4@oak.ozlabs.ibm.com>
 <20190812050705.mlszjkatxa635pzh@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812050705.mlszjkatxa635pzh@oak.ozlabs.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 03:07:05PM +1000, Paul Mackerras wrote:

>  	lbz	r5, VCPU_XIVE_ESC_ON(r9)
>  	cmpwi	r5, 0
> -	beq	1f
> +	beq	4f
>  	li	r0, 0
>  	stb	r0, VCPU_CEDED(r9)
> +	li	r6, XIVE_ESB_SET_PQ_10
> +	b	1f
> +4:	li	r0, 1
> +	stb	r0, VCPU_XIVE_ESC_ON(r9)

This ends up setting vcpu->arch.xive_esc_on even on platforms without
XIVE, which is wrong.  I'll send a v2.

Paul.
