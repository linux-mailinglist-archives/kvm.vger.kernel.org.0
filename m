Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DDC60F4F4
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 12:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiJ0K11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 06:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiJ0K1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 06:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE81106E20
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 03:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666866418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4e29Szj0bWjoQcGGn3n5PPNT0uo5CPMikeS3uqJGsg4=;
        b=Aih4eX3HdGJ+OhSu3LCRr0mh0R9P+Ub3KuKEXJMJeOzYmU7JCte7+h3kHwNoPOxr34RZ2H
        VzTt4C0vp+ET83biMeKAa2CAOITUkrr/ePuZjcF/C0cAtNa98sGi2mVrSC6tUNYhjDE8xK
        vHTYni/ApBu9hghyvJp/Pcyu8buNeVE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-kcLumE1WPuO6nfbYhntdeA-1; Thu, 27 Oct 2022 06:26:56 -0400
X-MC-Unique: kcLumE1WPuO6nfbYhntdeA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E44823F91;
        Thu, 27 Oct 2022 10:26:54 +0000 (UTC)
Received: from localhost (unknown [10.39.195.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E21E4A9265;
        Thu, 27 Oct 2022 10:26:47 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 2/2] qtests/arm: add some mte tests
In-Reply-To: <bfd29635-9742-741c-a6dc-145bcf4f8ef8@redhat.com>
Organization: Red Hat GmbH
References: <20221026160511.37162-1-cohuck@redhat.com>
 <20221026160511.37162-3-cohuck@redhat.com>
 <bfd29635-9742-741c-a6dc-145bcf4f8ef8@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 27 Oct 2022 12:26:43 +0200
Message-ID: <87h6zpd0kc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27 2022, Thomas Huth <thuth@redhat.com> wrote:

> On 26/10/2022 18.05, Cornelia Huck wrote:
>> +        qtest_add_data_func("/arm/max/query-cpu-model-expansion/tag-memory",
>> +                            NULL, mte_tests_tag_memory_on);
>
> Is it already possible to compile qemu-system-aarch64 with --disable-tcg ? 

Not yet, the code is too entangled... I tried a bit ago, but didn't make
much progress (on my todo list, but won't mind someone else doing it :)

> If so, I'd recommend a qtest_has_accel("tcg") here ... but apart from that:
>
> Acked-by: Thomas Huth <thuth@redhat.com>

Thanks!

