Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF936BCA93
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 10:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjCPJS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 05:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCPJSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 05:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD4623321
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 02:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678958278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prBcxf91iIZL3MAy2qfBrYESz+EF2f9sqhQG3HhwSlg=;
        b=Jtdmv0PldWp0ZpiNSZI7fCaLOrYHWg+PfHKXhOBkmJ83C3OcE/ASHBhjOR6apc/Yyai1PC
        KJDSb+VBbzEW+h9STudQyoqGZoDYs/WDZisJTmJA6NocNdgo8kzwnsrwZVM6PZIqSjzes7
        bwv9ZfawVQMULnEO1yat6lEaaEYKF/4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-X1ZspskXPYapyUj-OGlZ8A-1; Thu, 16 Mar 2023 05:17:57 -0400
X-MC-Unique: X1ZspskXPYapyUj-OGlZ8A-1
Received: by mail-wr1-f69.google.com with SMTP id 7-20020a5d47a7000000b002be0eb97f4fso143541wrb.8
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 02:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678958276;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=prBcxf91iIZL3MAy2qfBrYESz+EF2f9sqhQG3HhwSlg=;
        b=fI1owC0DT+CQ+LQEv5XRVph5c7gFF1OOpPu5G8+t/Rs5fLTbkkj8X3JfAK6CQk8dX2
         YJ7ui2TrCmdbkXb1ABtQNtqqkmicelpTPNfPNdnIouY35hMfW+FDQJe0D5bPX75dD96c
         jQGBdSYo7Dkkh5MRMe5XpNzDIkWtlGPE7IX2qYB9nV0pPq1LsJajGZsdAK688f9QTBZC
         s+GshFKPF3POOauV3rjXeNs+9S794QqqWapaqhBlOwUg00y1jqZGjC1HyHj0xCi/qhLE
         FKm1n8FuJvj4UIBbvEJNPdK5dGHa/okXpcLR+W6JzZv1ctRdTy21iqsfluA6iurtwuwY
         /y6g==
X-Gm-Message-State: AO0yUKUQhYrGdj/6B2o0c0wUw4EMt0Cpx3MBwl6nKGvCjOyryaLmRY9M
        HZLfK4SAhQECSQK5CVZ9x3S95va2Ag16qmbxqlwmTDXU/TDMGjPrL78afLUQF/wGJpMw5zwBzVU
        oyoNdSIJaqR5r
X-Received: by 2002:a05:600c:5398:b0:3eb:3945:d3f1 with SMTP id hg24-20020a05600c539800b003eb3945d3f1mr21253332wmb.5.1678958276094;
        Thu, 16 Mar 2023 02:17:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set8fhHoxdUgxfHeMeJXHA71ZQrPDPTCxpB6BsggyeBHtylQKQSQtG2s7krQMIYt/khl/atW99A==
X-Received: by 2002:a05:600c:5398:b0:3eb:3945:d3f1 with SMTP id hg24-20020a05600c539800b003eb3945d3f1mr21253316wmb.5.1678958275835;
        Thu, 16 Mar 2023 02:17:55 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id k6-20020a05600c1c8600b003e209b45f6bsm4763800wms.29.2023.03.16.02.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 02:17:55 -0700 (PDT)
Date:   Thu, 16 Mar 2023 10:17:52 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/8] vringh: replace kmap_atomic() with
 kmap_local_page()
Message-ID: <20230316091752.vskzw5trzz772s3n@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-4-sgarzare@redhat.com>
 <5675662.DvuYhMxLoT@suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5675662.DvuYhMxLoT@suse>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 10:13:39AM +0100, Fabio M. De Francesco wrote:
>On giovedì 2 marzo 2023 12:34:16 CET Stefano Garzarella wrote:
>> kmap_atomic() is deprecated in favor of kmap_local_page().
>>
>> With kmap_local_page() the mappings are per thread, CPU local, can take
>> page-faults, and can be called from any context (including interrupts).
>> Furthermore, the tasks can be preempted and, when they are scheduled to
>> run again, the kernel virtual addresses are restored and still valid.
>>
>> kmap_atomic() is implemented like a kmap_local_page() which also disables
>> page-faults and preemption (the latter only for !PREEMPT_RT kernels,
>> otherwise it only disables migration).
>>
>> The code within the mappings/un-mappings in getu16_iotlb() and
>> putu16_iotlb() don't depend on the above-mentioned side effects of
>> kmap_atomic(), so that mere replacements of the old API with the new one
>> is all that is required (i.e., there is no need to explicitly add calls
>> to pagefault_disable() and/or preempt_disable()).
>
>It seems that my commit message is quite clear and complete and therefore has
>already been reused by others who have somehow given me credit.
>
>I would really appreciate it being mentioned here that you are reusing a
>"boiler plate" commit message of my own making and Cc me :-)

Yes of course, sorry for not doing this previously!

Thanks,
Stefano

