Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162C363C35C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 16:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiK2PPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 10:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiK2PPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 10:15:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F82E2BB13
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 07:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669734862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IeJbxQq4oKJJKxEz1iOkWhtpWVLyX6vpshVx4+Idd6k=;
        b=JGE9DcvjwAsdNIc06qB5YmTAAtbeHSNQPqFM3mX9BKVdvdgZSZTScd09mdrbJj8psddbRI
        FJpLTYQE1xzZBJQJEklg6kS6fc3Uzk8iCVXcExyt1tFWE98+pVbHuIcvhVEtzWHFq8YxkH
        TdxLp7SMA2eX9gqe6Trz1i9cUf/dc1A=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-303-_B6B43aSOGyqGq01waezww-1; Tue, 29 Nov 2022 10:14:21 -0500
X-MC-Unique: _B6B43aSOGyqGq01waezww-1
Received: by mail-vs1-f71.google.com with SMTP id 190-20020a6719c7000000b003aa14ac75f5so5226313vsz.1
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 07:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IeJbxQq4oKJJKxEz1iOkWhtpWVLyX6vpshVx4+Idd6k=;
        b=AelEgvQznq/e7avVtYcpDmN9HEEILd3qI2QFJEpocNKGCPD2VOqgOeviaN7Mwqec0S
         hvpJ9j/tV/ia+4r+jwGJXnloZ+1mCdsnPNQayHK4VdIijaDf7veuLOQuDsfr8uvgCZ0O
         YvGace8zQGrg67uomzHixa1Sj0cLP9BB1rSWk6dymndANgI9OXLbbADcrGEsE7p5xkUF
         OfntU29wySM+9WCrOokEb3z1fO+1Y4gXm/9qgAiQtJb+gDRVDTbb72SRDiY61Rt3Zdt1
         z7yiJ3gZgPrBbqzaDXS48qjZsoklGQSX6X8YwEb/py+kn/LhN8LU7oycHZ33AhSMaKkJ
         iplQ==
X-Gm-Message-State: ANoB5pnCAzViJAu6NLV4ZhqJoZqclbMfo3hIJ8Mg70/GIjCQ5hwX75QT
        QNRZ2n7Pdu6fL0Fu3lINWaA4mRBQ5m11BzCplbMNn4Q2dKNACvq+IExwnV3v07suvNbfK3lQcwV
        I7cOmDLYBGoKsPKAg8/5DcLXZr3CI
X-Received: by 2002:a05:6102:3fa1:b0:3a6:aae4:cab6 with SMTP id o33-20020a0561023fa100b003a6aae4cab6mr31965897vsv.27.1669734860673;
        Tue, 29 Nov 2022 07:14:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Eq4ktzAz6wk4yJ1feDHHcUBL7TWADnI4bM+SjL3EJOIZBy0IOhTulfF9sPIFDHQRStgSwqLNwSr+QFsdvzMU=
X-Received: by 2002:a05:6102:3fa1:b0:3a6:aae4:cab6 with SMTP id
 o33-20020a0561023fa100b003a6aae4cab6mr31965877vsv.27.1669734860366; Tue, 29
 Nov 2022 07:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20221125085454.16673-1-frankja@linux.ibm.com>
In-Reply-To: <20221125085454.16673-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 29 Nov 2022 16:14:07 +0100
Message-ID: <CABgObfb5oGOmaN8MOVrgXHeQfa-80dQnY2mCan2RA-ZnGXbrDA@mail.gmail.com>
Subject: Re: [GIT PULL 0/1] s390 fixes for 6.1-rc7/8
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 9:55 AM Janosch Frank <frankja@linux.ibm.com> wrote:
>
> Dear Paolo,
>
> please pull Thomas' fix for VSIE.
> We deem it to be low risk and it survived a day in our CI without any errors.
> It's a bit late so let's see if it makes 6.1 or 6.2.
>
>
> The following changes since commit eb7081409f94a9a8608593d0fb63a1aa3d6f95d8:
>
>   Linux 6.1-rc6 (2022-11-20 16:02:16 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.1-2
>
> for you to fetch changes up to 0dd4cdccdab3d74bd86b868768a7dca216bcce7e:
>
>   KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field (2022-11-24 14:43:17 +0100)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> VSIE epdx shadowing fix
>
> ----------------------------------------------------------------
> Thomas Huth (1):
>       KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field
>
>  arch/s390/kvm/vsie.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Thomas Huth (1):
>   KVM: s390: vsie: Fix the initialization of the epoch extension (epdx)
>     field
>
>  arch/s390/kvm/vsie.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --
> 2.38.1
>

