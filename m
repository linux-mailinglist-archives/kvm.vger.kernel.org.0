Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B122B8361
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 18:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgKRRuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 12:50:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727562AbgKRRuf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 12:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605721834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiyN39i1ac3oiyIb1NhSMxljKEIgrqsk3y8a/SFB3BU=;
        b=geU0yDa258BwqXGRd9KjiAsQOHj/9aMlpobgiJgoRHlKOuHOdICa5oh7xuFMPpAfl80uCP
        vPfCn5zk2jyPjPvx4fiY9MlLJxfEw3nNiYQHS9xtC/o7QwZi7aD/Eg10cckumcncCK++pp
        rOSFLWeaoAMQ9cYpkrWEyQKVHTCInyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-VoO8jP-lNVWPzMxJ6w8sGA-1; Wed, 18 Nov 2020 12:50:32 -0500
X-MC-Unique: VoO8jP-lNVWPzMxJ6w8sGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DB3C808255;
        Wed, 18 Nov 2020 17:50:31 +0000 (UTC)
Received: from gondolin (ovpn-113-132.ams2.redhat.com [10.36.113.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71C9F5D9CA;
        Wed, 18 Nov 2020 17:50:29 +0000 (UTC)
Date:   Wed, 18 Nov 2020 18:50:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: SCLP feature checking
Message-ID: <20201118185026.776c63dd.cohuck@redhat.com>
In-Reply-To: <20201117154215.45855-4-frankja@linux.ibm.com>
References: <20201117154215.45855-1-frankja@linux.ibm.com>
        <20201117154215.45855-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 10:42:13 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Availability of SIE is announced via a feature bit in a SCLP info CPU
> entry. Let's add a framework that allows us to easily check for such
> facilities.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>  lib/s390x/sclp.h | 15 +++++++++++++++
>  3 files changed, 35 insertions(+)

(...)

> +void sclp_facilities_setup(void)
> +{
> +	unsigned short cpu0_addr = stap();
> +	CPUEntry *cpu;
> +	int i;
> +
> +	assert(read_info);
> +
> +	cpu = (void *)read_info + read_info->offset_cpu;
> +	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
> +		if (cpu->address == cpu0_addr) {
> +			sclp_facilities.has_sief2 = test_bit_inv(SCLP_CPU_FEATURE_SIEF2_BIT, (void *)&cpu->address);

Can you wrap this? This line is really overlong.

(Also, just to understand: Is sief2 only indicated for cpu0, and not
for the other cpus?)

> +			break;
> +		}
> +	}
> +}
> +
>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>  int sclp_service_call(unsigned int command, void *sccb)
>  {

