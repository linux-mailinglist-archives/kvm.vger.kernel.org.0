Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD9F1B9893
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 09:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgD0H2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 03:28:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726349AbgD0H2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 03:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587972516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fhbDo34NJp8lf0z2mD+gxz78VWyhT6vzLSI7DIn5U0k=;
        b=QM/66+JXXbkP5SECyuyUPGIREMTF9itLCIoqLm/iEeYJugk3Nda9iocJdQR1eKaGNfBxts
        mhx0exD3qILJM4n8AaMvRatvnENmr53orpoK2EoJq95LLF3ui+FjDfmn5D5us2i9TLOqQq
        O/466iCtsy0a8eqQoq6En5rtKpl9VaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-xE9ys-BJNemCctbaqWDaxQ-1; Mon, 27 Apr 2020 03:28:33 -0400
X-MC-Unique: xE9ys-BJNemCctbaqWDaxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73EC11895A28;
        Mon, 27 Apr 2020 07:28:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D76A95C1D4;
        Mon, 27 Apr 2020 07:28:28 +0000 (UTC)
Date:   Mon, 27 Apr 2020 09:28:25 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: Save/restore sp_el0 as part of __guest_enter
Message-ID: <20200427072825.ekcekll6f23bt2um@kamzik.brq.redhat.com>
References: <20200425094321.162752-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425094321.162752-1-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 10:43:21AM +0100, Marc Zyngier wrote:
> We currently save/restore sp_el0 in C code. This is a bit unsafe,
> as a lot of the C code expects 'current' to be accessible from
> there (and the opportunity to run kernel code in HYP is specially
> great with VHE).
> 
> Instead, let's move the save/restore of sp_el0 to the assembly
> code (in __guest_enter), making sure that sp_el0 is correct
> very early on when we exit the guest, and is preserved as long
> as possible to its host value when we enter the guest.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/entry.S     | 23 +++++++++++++++++++++++
>  arch/arm64/kvm/hyp/sysreg-sr.c | 17 +++--------------
>  2 files changed, 26 insertions(+), 14 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

