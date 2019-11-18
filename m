Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD4E10065C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 14:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfKRNVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 08:21:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726984AbfKRNVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 08:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574083291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDt0kz5uoG+Wvoc+FOMxPI8N9nsBIvdXSRfwD1DTFEU=;
        b=ZavcAJ3Qrfm53IWdYI+/o6QjfKivMxbKU50HnQKKFHJztO31CmESl+6aZkW3amuNCi1Zdf
        s1sUQYQ0ICa6jCF6g2wQMctDLriUuI53qzm1HcgEdjTPSzCbQAC4PR7kY1MzWzMQjnwE+4
        0+uzctf2URhxlt2cZi9xtEIkZ7/ryI8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-TluLpgONPYKfe63Zlu9EHQ-1; Mon, 18 Nov 2019 08:21:27 -0500
Received: by mail-qv1-f70.google.com with SMTP id g33so12436363qvd.7
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 05:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q9+IKFPWhISyaYV00Tog4e8K2FzhfF9OCbbQXzCjBFw=;
        b=lMCmSsmoAWgkmu+N0Lva78ICs1jXKoGG2ih1v0Ge1cAe9k0xQC2ZNwWT3wLMYDCCim
         +A2iK5RZkC/M0Le5M+96370uBCzY7VMBAfbn8Cm559xJ0DccIUQzaezAyiSbzed/Z6QN
         hDa7cjxj3uUMQBtHk+/1Gmp4l9Lm4WAskGLSmaTC+FY9dK73PQ2Mtya8r2z9takGCDTZ
         zjc6TDoF5ZqCofLM51xHWnOFySPsd9IUD6U/rnytJ8wPxXBse1sMwYcscQ3G4xzTX0ep
         I21qf50yVhy+z92IXwN/0xCY4iSlUBclgHWjQqr0g5ahzoKJuurQr6CzZfS7xT9qwXC7
         Bmvg==
X-Gm-Message-State: APjAAAVVJvyJpFAzoQlN68sRoShM0HwguDHmXzjBHToKswQ3h5z2LjRG
        SQougiojtDdEd5WHT4jswQnEXAcC+wY2tzdugf1pD4R+XtFrXCTEvsd/9IuzsyL1h05rc9SWDC8
        Qf/zeRdRm2lUt
X-Received: by 2002:ac8:13ca:: with SMTP id i10mr25764990qtj.214.1574083287505;
        Mon, 18 Nov 2019 05:21:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyg2fO6T3H3YLS5WBC+X8LieZNM8Tgl3Rc4RrZGwUyU1/5RAkrJEWaL4BfmLzoP5T+X12Q76A==
X-Received: by 2002:ac8:13ca:: with SMTP id i10mr25764951qtj.214.1574083287214;
        Mon, 18 Nov 2019 05:21:27 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id a2sm8410998qkl.71.2019.11.18.05.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:21:26 -0800 (PST)
Date:   Mon, 18 Nov 2019 08:21:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Xiang Zheng <zhengxiang9@huawei.com>, pbonzini@redhat.com,
        shannon.zhaosl@gmail.com, peter.maydell@linaro.org,
        lersek@redhat.com, james.morse@arm.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, jonathan.cameron@huawei.com,
        xuwei5@huawei.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, linuxarm@huawei.com,
        wanghaibin.wang@huawei.com
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Message-ID: <20191118082036-mutt-send-email-mst@kernel.org>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-4-zhengxiang9@huawei.com>
 <20191115103801.547fc84d@redhat.com>
 <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
 <87758ec2-c242-71c3-51f8-a5d348f8e7fd@huawei.com>
MIME-Version: 1.0
In-Reply-To: <87758ec2-c242-71c3-51f8-a5d348f8e7fd@huawei.com>
X-MC-Unique: TluLpgONPYKfe63Zlu9EHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 09:18:01PM +0800, gengdongjiu wrote:
> On 2019/11/18 20:49, gengdongjiu wrote:
> >>> +     */
> >>> +    build_append_int_noprefix(table_data, source_id, 2);
> >>> +    /* Related Source Id */
> >>> +    build_append_int_noprefix(table_data, 0xffff, 2);
> >>> +    /* Flags */
> >>> +    build_append_int_noprefix(table_data, 0, 1);
> >>> +    /* Enabled */
> >>> +    build_append_int_noprefix(table_data, 1, 1);
> >>> +
> >>> +    /* Number of Records To Pre-allocate */
> >>> +    build_append_int_noprefix(table_data, 1, 4);
> >>> +    /* Max Sections Per Record */
> >>> +    build_append_int_noprefix(table_data, 1, 4);
> >>> +    /* Max Raw Data Length */
> >>> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LEN=
GTH, 4);
> >>> +
> >>> +    /* Error Status Address */
> >>> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> >>> +                     4 /* QWord access */, 0);
> >>> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> >>> +        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id)=
,
> >> it's fine only if GHESv2 is the only entries in HEST, but once
> >> other types are added this macro will silently fall apart and
> >> cause table corruption.
>    why  silently fall?
>    I think the acpi_ghes.c only support GHESv2 type, not support other ty=
pe.
>=20
> >>
> >> Instead of offset from hest_start, I suggest to use offset relative
> >> to GAS structure, here is an idea>>
> >> #define GAS_ADDR_OFFSET 4
> >>
> >>     off =3D table->len
> >>     build_append_gas()
> >>     bios_linker_loader_add_pointer(...,
> >>         off + GAS_ADDR_OFFSET, ...
>=20
> If use offset relative to GAS structure, the code does not easily extend =
to support more Generic Hardware Error Source.
> if use offset relative to hest_start, just use a loop, the code can suppo=
rt  more error source, for example:
> for (source_id =3D 0; i<n; source_id++)
> {
>    ......
>     bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
>         ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
>         sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
>         source_id * sizeof(uint64_t));
>   .......
> }
>=20
> My previous series patch support 2 error sources, but now only enable 'SE=
A' type Error Source

I'd try to merge this, worry about extending things later.
This is at v21 and the simpler you can keep things,
the faster it'll go in.

