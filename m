Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF456F3FC8
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 11:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjEBJEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 05:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjEBJET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 05:04:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BFE2D63
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 02:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683018210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSbRx1H+cG8NzIjCF3YLAeY91SKkBCotNuy/KA1bti4=;
        b=ZkEg1LMExZ0nTBKaZs/iaKU0WNEyh5Zx+H0dlqy79u2GDWawf90FVXvM7orUFAwkZjzYQK
        /5zcsaqQUN9JN9GUO+JI5FDsKz9jaDCrFJDvRlewGTCqF8vKXXDZkmf2yfjLKV6dHi1w9w
        xYTXvp5pTtVHDl80Q6f319buEhYpKbA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-KVywX8IFN7u-YYNhIIOb8w-1; Tue, 02 May 2023 05:03:27 -0400
X-MC-Unique: KVywX8IFN7u-YYNhIIOb8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F573885626;
        Tue,  2 May 2023 09:03:27 +0000 (UTC)
Received: from localhost (unknown [10.39.193.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D30A12166B26;
        Tue,  2 May 2023 09:03:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Richard Henderson <richard.henderson@linaro.org>,
        quintela@redhat.com
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
In-Reply-To: <64915da6-4276-1603-1454-9350a44561d8@linaro.org>
Organization: Red Hat GmbH
References: <20230428095533.21747-1-cohuck@redhat.com>
 <20230428095533.21747-2-cohuck@redhat.com> <87sfcj99rn.fsf@secure.mitica>
 <64915da6-4276-1603-1454-9350a44561d8@linaro.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 02 May 2023 11:03:25 +0200
Message-ID: <871qjzcdgi.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 01 2023, Richard Henderson <richard.henderson@linaro.org> wrote:

> On 4/28/23 18:50, Juan Quintela wrote:
>> Pardon my ignorance here, but to try to help with migration.  How is
>> this mte tag stored?
>> - 1 array of 8bits per page of memory
>> - 1 array of 64bits per page of memory
>> - whatever
>> 
>> Lets asume that it is 1 byte per page. For the explanation it don't
>> matter, only matters that it is an array of things that are one for each
>> page.
>
> Not that it matters, as you say, but for concreteness, 1 4-bit tag per 16 bytes, packed, 
> so 128 bytes per 4k page.
>
>> So my suggestion is just to send another array:
>> 
>> - 1 array of page addresses
>> - 1 array of page tags that correspond to the previous one
>> - 1 array of pages that correspond to the previous addresses
>> 
>> You put compatiblity marks here and there checking that you are using
>> mte (and the same version) in both sides and you call that a day.
>
> Sounds reasonable.

Yes, something like that sounds reasonable as an interface.

>
>> Notice that this requires the series (still not upstream but already on
>> the list) that move the zero page detection to the multifd thread,
>> because I am assuming that zero pages also have tags (yes, it was not a
>> very impressive guess).
>
> Correct.  "Proper" zero detection would include checking the tags as well.
> Zero tags are what you get from the kernel on a new allocation.
>
>> Now you need to tell me if I should do this for each page, or use some
>> kind of scatter-gather function that allows me to receive the mte tags
>> from an array of pages.
>
> That is going to depend on if KVM exposes an interface with which to bulk-set tags (STGM, 
> "store tag multiple", is only available to kernel mode for some reason), a-la 
> arch/arm64/mm/copypage.c (which copies the page data then the page tags separately).
>
> For the moment, KVM believes that memcpy from userspace is sufficient, which means we'll 
> want a custom memcpy using STGP to store 16 bytes along with its tag.
>
>> You could pass this information when we are searching for dirty pages,
>> but it is going to be complicated doing that (basically we only pass the
>> dirty page id, nothing else).
>
> A page can be dirtied by changing nothing but a tag.
> So we cannot of course send tags "early", they must come with the data.
> I'm not 100% sure I understood your question here.

Last time MTE migration came up, we thought that we would need to go
with an uffd extension (page + extra data) to handle the postcopy case
properly (i.e. use some kind of array for precopy, and that interface
extension for postcopy.) TBH, I'm not sure if multifd makes any
difference here.

>
>> Another question, if you are using MTE, all pages have MTE, right?
>> Or there are other exceptions?
>
> No such systems are built yet, so we won't know what corner cases the host system will 
> have to cope with, but I believe as written so far all pages must have tags when MTE is 
> enabled by KVM.

Has anyone been able to access a real system with MTE? (All the systems
where I had hoped that MTE would be available didn't have MTE in the end
so far, so I'd be interested to hear if anybody else already got to play
with one.) Honestly, I don't want to even try to test migration if I only
have access to MTE on the FVP...

