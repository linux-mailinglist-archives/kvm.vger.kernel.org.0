Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0528C67CAB7
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 13:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbjAZMQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 07:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjAZMQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 07:16:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E4562792
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 04:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674735354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5EQavsdE/3IYLViHPQWkDrpyC8OTHXrhqf97l3UpJIQ=;
        b=XyYpdDwl74nDf5FdVuqsiWakDCedIXN+iO+IkMv28shnc1MnIvJxWHNtIcQckeCtDEkWfU
        bsYjoLwbJlxp6L/C6tqSnuibF/JMPAlntyd82n608GhBwCwag+UUZOayNew/5jdsdf8Y+D
        A625goEziyANXrYtJqB1EdsziICSrIE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-886ZYJ3kP_iALkext6bJVA-1; Thu, 26 Jan 2023 07:15:50 -0500
X-MC-Unique: 886ZYJ3kP_iALkext6bJVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 251C42802E31;
        Thu, 26 Jan 2023 12:15:50 +0000 (UTC)
Received: from localhost (unknown [10.39.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7181C14171BB;
        Thu, 26 Jan 2023 12:15:49 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
In-Reply-To: <877cx9y0t6.fsf@redhat.com>
Organization: Red Hat GmbH
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <44d82d98-6a27-f4d3-9773-670231f82c63@redhat.com>
 <877cx9y0t6.fsf@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 26 Jan 2023 13:15:46 +0100
Message-ID: <874jsdxzil.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26 2023, Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, Jan 23 2023, Eric Auger <eauger@redhat.com> wrote:
>
>> Hi Connie,
>> On 1/11/23 17:13, Cornelia Huck wrote:
>>>      if (vms->mte && (kvm_enabled() || hvf_enabled())) {
>>>          error_report("mach-virt: %s does not support providing "
>>> -                     "MTE to the guest CPU",
>>> +                     "emulated MTE to the guest CPU",
>> each time I read this message I feel difficult to understand it. Why not
>> replacing by
>> "mach-virt does not support tag memory with %s acceleration" or
>> something alike?
>
> Hmm... well, it does not support tag memory with kvm/hvf, and the
> consequence of this is that kvm/hvf cannot provide support for emulated
> mte... what about
>
> "mach-virt: tag memory not supported with %s, emulated MTE cannot be
> provided to the guest CPU"
>
> Might be a bit long, though.

"mach-virt: %s does not support providing emulated MTE to the guest CPU
(tag memory not supported)" seems to align better with the other error
messages in that function.


>
>>>                       kvm_enabled() ? "KVM" : "HVF");
>>>          exit(1);
>>>      }

