Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F796F6E8B
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 17:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjEDPDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 11:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjEDPDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 11:03:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CD39ECA
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 08:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683212521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8gaIe4fJeebZhZJNoEUEvjNevQ8Mn9rjK8GU2Z9g+ms=;
        b=UOkIg8Ze8OTj66SGgbBxfrjQ673ZVn8rRQoxSWEf1Bh8cktvm+xqhomCQJb/tPt7XSruhx
        fzTjbFmZqj8UiZumQITVLaPhAGemg1PEZPLc4PRv3THacX++wO5c84vwP9b2ZVLdv9Oakp
        gK7tp5ANiadLylpYlu14lqTJ5WBXOk8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-O3wbCCP1OnSmUl_h4NhPdw-1; Thu, 04 May 2023 11:01:59 -0400
X-MC-Unique: O3wbCCP1OnSmUl_h4NhPdw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA5D218A6473;
        Thu,  4 May 2023 15:01:55 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B208F492B00;
        Thu,  4 May 2023 15:01:55 +0000 (UTC)
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
In-Reply-To: <2c70f6a6-9e13-3412-8e65-43675fda4d95@linaro.org>
Organization: Red Hat GmbH
References: <20230428095533.21747-1-cohuck@redhat.com>
 <20230428095533.21747-2-cohuck@redhat.com> <87sfcj99rn.fsf@secure.mitica>
 <64915da6-4276-1603-1454-9350a44561d8@linaro.org>
 <871qjzcdgi.fsf@redhat.com>
 <2c70f6a6-9e13-3412-8e65-43675fda4d95@linaro.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 04 May 2023 17:01:54 +0200
Message-ID: <87sfcc16ot.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 02 2023, Richard Henderson <richard.henderson@linaro.org> wrote:

> On 5/2/23 10:03, Cornelia Huck wrote:
>> Has anyone been able to access a real system with MTE? (All the systems
>> where I had hoped that MTE would be available didn't have MTE in the end
>> so far, so I'd be interested to hear if anybody else already got to play
>> with one.) Honestly, I don't want to even try to test migration if I only
>> have access to MTE on the FVP...
>
> Well there's always MTE on QEMU with TCG.  :-)

Which actually worked very nicely to verify my test setup :)

>
> But I agree that while it's better than FVP, it's still slow, and difficult to test 
> anything at scale.  I have no objection to getting non-migratable MTE on KVM in before 
> attempting to solve migration.

I'm wondering whether we should block migration with MTE enabled in
general... OTOH, people probably don't commonly try to migrate with tcg,
unless they are testing something?

