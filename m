Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A09C561FC0
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 17:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiF3Pzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 11:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiF3Pzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 11:55:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B0CD39817
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656604542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nRvPip85gUSbUJnsZ8cTFSvmkrYw0M7WomwTPU0jwws=;
        b=B6UCXX1D+JLJUnyIbQHkPxuW1SZIeB7PA/OkmpdIB8aWQNiHSrSMYGB2JoVeyGTXgNGDtt
        SYQub5N5xP7Nf5wgcuAiwx680NdQD5eQXGI2/VFagqW2ZA4PtHepzAzjRpzp4rROz5GRWk
        R29fRoll4WRXrC+zFHoH/orHhI3JJ9s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-zHtl7fHHORa_8sUJbxyC8g-1; Thu, 30 Jun 2022 11:55:40 -0400
X-MC-Unique: zHtl7fHHORa_8sUJbxyC8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F03D42919ECB;
        Thu, 30 Jun 2022 15:55:39 +0000 (UTC)
Received: from localhost (unknown [10.39.195.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2F702166B26;
        Thu, 30 Jun 2022 15:55:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Auger <eauger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] arm/kvm: enable MTE if available
In-Reply-To: <9dfbfd42-6a40-80d2-8d9d-f5849de0b726@redhat.com>
Organization: Red Hat GmbH
References: <20220512131146.78457-1-cohuck@redhat.com>
 <20220512131146.78457-2-cohuck@redhat.com>
 <a3d0a093-3d59-5882-c9c8-6619e5aeb3ab@redhat.com>
 <877d5jskmw.fsf@redhat.com>
 <9dfbfd42-6a40-80d2-8d9d-f5849de0b726@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Thu, 30 Jun 2022 17:55:38 +0200
Message-ID: <87o7ya2lj9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29 2022, Eric Auger <eauger@redhat.com> wrote:

> Hi Connie,
>
> On 6/14/22 10:40, Cornelia Huck wrote:
>> On Fri, Jun 10 2022, Eric Auger <eauger@redhat.com> wrote:
>> 
>>> Hi Connie,
>>> On 5/12/22 15:11, Cornelia Huck wrote:
>>>> We need to disable migration, as we do not yet have a way to migrate
>>>> the tags as well.
>>>
>>> This patch does much more than adding a migration blocker ;-) you may
>>> describe the new cpu option and how it works.
>> 
>> I admit this is a bit terse ;) The idea is to control mte at the cpu
>> level directly (and not indirectly via tag memory at the machine
>> level). I.e. the user gets whatever is available given the constraints
>> (host support etc.) if they don't specify anything, and they can
>> explicitly turn it off/on.
>
> Could the OnOffAuto property value be helpful?

I completely forgot that this exists; I hacked up something (still
untested), and it seems to be able to do what I want.

I'll post it after I've verified that it actually works :)

>> The big elefant in the room is how migration will end up
>> working... after reading the disscussions in
>> https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/
>> I don't think it will be as "easy" as I thought, and we probably require
>> some further fiddling on the kernel side.
> Yes maybe the MTE migration process shall be documented and discussed
> separately on the ML? Is Haibu Xu's address bouncing?

Yes, that address is bouncing...

I've piggybacked onto a recent kvm discussion in
https://lore.kernel.org/all/875ykmcd8q.fsf@redhat.com/ -- I guess there
had not been any change for migration in the meantime, we need to find a
way to tie page data + metadata together.

