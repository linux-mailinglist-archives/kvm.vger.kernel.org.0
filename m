Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8266F687019
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjBAUsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjBAUsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:48:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691FC7EFF3
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675284368;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=OFFnJKZb8PMi7/wXr3GZyOfNFD62OL/lS9nRJ+QrMX0=;
        b=P89zRspyZvvtzKPxi28Mg1iQItat8mPDX98SIFTEQFveAbDgrK1o6VHLmkEz6M0eGiOvG4
        gRMOhrxCTLBx2lmTE12ZQOJ1fJ3zTPNRj9Xes52twqEh8BXmPWPkukpP0tq1c7tL33/Z3u
        8Xw8UUParjb5fDsMl0HSSb9El+WciuM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-179-_Fj9TCakO6eJ9lb3SHeWNw-1; Wed, 01 Feb 2023 15:46:06 -0500
X-MC-Unique: _Fj9TCakO6eJ9lb3SHeWNw-1
Received: by mail-wr1-f70.google.com with SMTP id i11-20020adff30b000000b002bfddf29578so2153672wro.10
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:46:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFFnJKZb8PMi7/wXr3GZyOfNFD62OL/lS9nRJ+QrMX0=;
        b=2HK7cuSOu2lh4BA1RTlfOF72YPwAUzW3UwP7M9dTPvomfIt+I48qj59IAwtyjmouEe
         S+w7vkeAKdkIk5ESvpmz2K3RH2NTgbHYNruUoQiwqz86AUAaKD/W0LKFRjlkbQAMG/1V
         sppsF9AtDP4gdcAGKS/SE327R4My5Duih73FR5yCvheOJQ1Ia9lLwmNaIDMSVnA7EEFx
         huIEUEIvDrvxYKuxOvuNYPpBND328pfO+YlfiBKFFX8G3jPpYiKHcG1df8APoDw5gcQS
         Pq07lN92VrHE6XEtJrYt9y0IRvEb000UTjDX8IYpZcvwwnAzGrrk+H3uYNyzg/U+2FQ7
         +8Wg==
X-Gm-Message-State: AO0yUKWW5JtClU+TmBUaBIcQUfC1OMk4lVkAhlJdQyHFdVuRnKvUV47l
        /JvhEfMjehtG9tOOIvwYiYvQVgknAuTwgj1j+DyWglj95nAGqcvDBNrvkGm59YLxiTQGrqUFUGP
        UqClIAtHfwE/J
X-Received: by 2002:a05:600c:468b:b0:3dc:486f:1552 with SMTP id p11-20020a05600c468b00b003dc486f1552mr3270414wmo.34.1675284365654;
        Wed, 01 Feb 2023 12:46:05 -0800 (PST)
X-Google-Smtp-Source: AK7set+RAwtEfrO0X//rLIy0fI5MAqZnGSrHIIQMeD+80k3zENA784Wo2s1SpiGytC7pL6ozqe4h4w==
X-Received: by 2002:a05:600c:468b:b0:3dc:486f:1552 with SMTP id p11-20020a05600c468b00b003dc486f1552mr3270396wmo.34.1675284365395;
        Wed, 01 Feb 2023 12:46:05 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id p10-20020a05600c358a00b003db1d9553e7sm3120300wmq.32.2023.02.01.12.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:46:04 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, kraxel@redhat.com,
        kwolf@redhat.com, hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        stefanb@linux.vnet.ibm.com, stefanha@redhat.com,
        kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: Re: [PATCH 17/32] migration: Move HMP commands from monitor/ to
 migration/
In-Reply-To: <20230124121946.1139465-18-armbru@redhat.com> (Markus
        Armbruster's message of "Tue, 24 Jan 2023 13:19:31 +0100")
References: <20230124121946.1139465-1-armbru@redhat.com>
        <20230124121946.1139465-18-armbru@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 01 Feb 2023 21:46:03 +0100
Message-ID: <87tu05unas.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Markus Armbruster <armbru@redhat.com> wrote:
> This moves these commands from MAINTAINERS sections "Human
> Monitor (HMP)" and "QMP" to "Migration".
>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Juan Quintela <quintela@redhat.com>

