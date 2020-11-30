Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6159A2C8285
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 11:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgK3KrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 05:47:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728313AbgK3KrJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 05:47:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606733142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZJqZHNzIbTC2h8SFtL9xDRGCnavReIxNbpgwMlniPE=;
        b=gg4y4r8K0+4D0uO76+mO4Tag+OxRH9uv78zg2Tp4Ohe2SepLGgMSwJDUo0IVY/aaT3ref1
        2C+8Pvs9JnMCnSPtq2/pEHjuivnM0AYyalqXdlDnnkb8ktMQL40Lqrbsi2ICfblIWROj3A
        ZDyj35W0CWvrLDzcu3OODSj6XI30rd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-CuL7RBbjP32y2ymMfPvSnA-1; Mon, 30 Nov 2020 05:45:41 -0500
X-MC-Unique: CuL7RBbjP32y2ymMfPvSnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA40B9A223;
        Mon, 30 Nov 2020 10:45:39 +0000 (UTC)
Received: from gondolin (ovpn-113-87.ams2.redhat.com [10.36.113.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 023AF10016FF;
        Mon, 30 Nov 2020 10:45:34 +0000 (UTC)
Date:   Mon, 30 Nov 2020 11:45:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 5/7] s390x: sie: Add first SIE test
Message-ID: <20201130114532.6fea10ac.cohuck@redhat.com>
In-Reply-To: <20201127130629.120469-6-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
        <20201127130629.120469-6-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Nov 2020 08:06:27 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if we get the correct interception data on a few
> diags. This commit is more of an addition of boilerplate code than a
> real test.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sie.c         | 125 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 ++
>  3 files changed, 129 insertions(+)
>  create mode 100644 s390x/sie.c
> 

(...)

> +static void sie(struct vm *vm)
> +{
> +	while (vm->sblk->icptcode == 0) {
> +		sie64a(vm->sblk, &vm->save_area);
> +		if (vm->sblk->icptcode == 32)

Can you maybe add #defines for the intercept codes you're checking for?

> +		    handle_validity(vm);
> +	}
> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> +}
> +
> +static void sblk_cleanup(struct vm *vm)
> +{
> +	vm->sblk->icptcode = 0;
> +}
> +
> +static void intercept_diag_10(void)
> +{
> +	u32 instr = 0x83020010;
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x100000,

Again, some #defines might help here, making clear that 0x8302 means
diag. (The ipb value is clear enough :) Maybe you can also assemble
instr out of pre-made pieces? Or factor out some code to a common
function?

> +	       "Diag 10 intercept");
> +	sblk_cleanup(&vm);
> +}
> +
> +static void intercept_diag_44(void)
> +{
> +	u32 instr = 0x83020044;
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x440000,
> +	       "Diag 44 intercept");
> +	sblk_cleanup(&vm);
> +}
> +
> +static void intercept_diag_9c(void)
> +{
> +	u32 instr = 0x8302009c;
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x9c0000,
> +	       "Diag 9c intercept");
> +	sblk_cleanup(&vm);
> +}

(...)

