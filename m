Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E555E813
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348260AbiF1P6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 11:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347277AbiF1P6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C9EAB79
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656431888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+p5rrSS5gmHyiQeGIkyhRA+tlGeOsOERv89U/jZX2uc=;
        b=N16a8U1UnV6stdAB1gcK+5kMoM2pxvNoCY0VgW08D7c7Vf4InfqyiFP6R90BprvNG9IZDE
        zwYK6R08V3u4uGSedSlyoDR5YMxZZCuXXKFWAh9Jrv8ZXjJUhfChwqWvNhxhm1POMfpsMC
        SNsVT4JgsZQNAETEHC5wW6cxWz819Nw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-wcmq9P1ZMKKRdbKYNTZyQg-1; Tue, 28 Jun 2022 11:58:03 -0400
X-MC-Unique: wcmq9P1ZMKKRdbKYNTZyQg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03E01384F808;
        Tue, 28 Jun 2022 15:58:03 +0000 (UTC)
Received: from localhost (unknown [10.39.193.129])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2E7141615A;
        Tue, 28 Jun 2022 15:58:02 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Schspa Shi <schspa@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: Clear the caps->buf to NULL after free
In-Reply-To: <20220628095013.266d4a40.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20220628152429.286-1-schspa@gmail.com>
 <20220628095013.266d4a40.alex.williamson@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 28 Jun 2022 17:58:01 +0200
Message-ID: <87ilokbx12.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 28 Jun 2022 23:24:29 +0800
> Schspa Shi <schspa@gmail.com> wrote:
>
>> API vfio_info_cap_add will free caps->buf, clear it to NULL after
>> free.
>
> Should this be something like:
>
>     On buffer resize failure, vfio_info_cap_add() will free the buffer,
>     report zero for the size, and return -ENOMEM.  As additional
>     hardening, also clear the buffer pointer to prevent any chance of a
>     double free.

I like that better. With that,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

>
> Thanks,
> Alex
>  
>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>> ---
>>  drivers/vfio/vfio.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 61e71c1154be..a0fb93866f61 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -1812,6 +1812,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>>  	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>>  	if (!buf) {
>>  		kfree(caps->buf);
>> +		caps->buf = NULL;
>>  		caps->size = 0;
>>  		return ERR_PTR(-ENOMEM);
>>  	}

