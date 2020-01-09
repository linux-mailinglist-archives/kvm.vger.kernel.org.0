Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58B713596C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 13:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgAIMmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 07:42:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36637 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725308AbgAIMmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 07:42:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578573764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=I9jDaeynE1d9kwYt8S/RUdyY38V/dyqHVO5mylxsD8g=;
        b=H6qOUVXK8YPHaMmj90ET4u32oRiz5ySOSJ/FnIezV5aEQ6HTJOljIrJSi4JWt7XaYKSjtt
        5l7BmQa2pox4xbtRAqM1phYY9RhHk+VjEO8iLMEmZs97iASjXNijVq5cYLajxHNJzF8NZ5
        B/aML/2nqMcv4q2cojVFsMR5aaHD63U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-92xeLR84PAO7bkoFVUCsIQ-1; Thu, 09 Jan 2020 07:42:41 -0500
X-MC-Unique: 92xeLR84PAO7bkoFVUCsIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65532477;
        Thu,  9 Jan 2020 12:42:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-32.ams2.redhat.com [10.36.117.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7859460BE0;
        Thu,  9 Jan 2020 12:42:36 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 4/4] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200108161317.268928-1-imbrenda@linux.ibm.com>
 <20200108161317.268928-5-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2ca46041-2135-3847-4f22-e1cdebe01936@redhat.com>
Date:   Thu, 9 Jan 2020 13:42:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200108161317.268928-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/2020 17.13, Claudio Imbrenda wrote:
> SCLP unit test. Testing the following:
>=20
> * Correctly ignoring instruction bits that should be ignored
> * Privileged instruction check
> * Check for addressing exceptions
> * Specification exceptions:
>   - SCCB size less than 8
>   - SCCB unaligned
>   - SCCB overlaps prefix or lowcore
>   - SCCB address higher than 2GB
> * Return codes for
>   - Invalid command
>   - SCCB too short (but at least 8)
>   - SCCB page boundary violation
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sclp.c        | 462 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   8 +
>  3 files changed, 471 insertions(+)
>  create mode 100644 s390x/sclp.c
[...]
> +/**
> + * Test SCCBs whose address is in the lowcore or prefix area.
> + */
> +static void test_sccb_prefix(void)
> +{
> +	uint8_t scratch[2 * PAGE_SIZE];
> +	uint32_t prefix, new_prefix;
> +	int offset;
> +
> +	/*
> +	 * copy the current lowcore to the future new location, otherwise we
> +	 * will not have a valid lowcore after setting the new prefix.
> +	 */
> +	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
> +	/* save the current prefix (it's probably going to be 0) */
> +	prefix =3D stpx();
> +	/*
> +	 * save the current content of absolute pages 0 and 1, so we can
> +	 * restore them after we trash them later on
> +	 */
> +	memcpy(scratch, (void *)(intptr_t)prefix, 2 * PAGE_SIZE);
> +	/* set the new prefix to prefix_buf */
> +	new_prefix =3D (uint32_t)(intptr_t)prefix_buf;
> +	spx(new_prefix);
> +
> +	/*
> +	 * testing with SCCB addresses in the lowcore; since we can't
> +	 * actually trash the lowcore (unsurprisingly, things break if we
> +	 * do), this will be a read-only test.
> +	 */
> +	for (offset =3D 0; offset < 2 * PAGE_SIZE; offset +=3D 8)
> +		if (!test_one_sccb(valid_code, MKPTR(offset), 0, PGM_BIT_SPEC, 0))
> +			break;
> +	report(offset =3D=3D 2 * PAGE_SIZE, "SCCB low pages");
> +
> +	/*
> +	 * this will trash the contents of the two pages at absolute
> +	 * address 0; we will need to restore them later.
> +	 */

I'm still a bit confused by this comment - will SCLP really trash the
contents here, or will there be a specification exception (since
PGM_BIT_SPEC is given below)? ... maybe you could clarify the comment in
case you respin again (or it could be fixed when picking up the patch)?

> +	for (offset =3D 0; offset < 2 * PAGE_SIZE; offset +=3D 8)
> +		if (!test_one_simple(valid_code, MKPTR(new_prefix + offset), 8, 8, P=
GM_BIT_SPEC, 0))
> +			break;
> +	report(offset =3D=3D 2 * PAGE_SIZE, "SCCB prefix pages");
> +
> +	/* restore the previous contents of absolute pages 0 and 1 */
> +	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
> +	/* restore the prefix to the original value */
> +	spx(prefix);
> +}

Remaining parts look ok to me now, so with the comment clarified:

Reviewed-by: Thomas Huth <thuth@redhat.com>

