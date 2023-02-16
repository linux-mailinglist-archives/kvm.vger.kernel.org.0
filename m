Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD1F699384
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 12:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBPLrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 06:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBPLrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 06:47:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E783D3C2BD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 03:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676547981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OXTLtaJcbOGZxqzET7s3E00C2yccOzv8ZhqQ1/xgB80=;
        b=F3q8m6asMpxqxS3XEhTee+Z7n+rRU0nZ9PCSxbZtYsmQUbHlD7YUSyT6LdVCRvp65KL/as
        WJJ9irLJYiTuHqNxzFFxpPf9SRoO3N5kVfWqWfl6d39fXJckNX2BgeyC1UOpRO2BzFXpZt
        yi+PcCB3gL99YB4ewT4PPl5N6dhd5cc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-EwwwJv4HMcmrOAl_MKgDJw-1; Thu, 16 Feb 2023 06:46:13 -0500
X-MC-Unique: EwwwJv4HMcmrOAl_MKgDJw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14224811E6E;
        Thu, 16 Feb 2023 11:46:13 +0000 (UTC)
Received: from localhost (unknown [10.39.193.73])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3C9E492C3C;
        Thu, 16 Feb 2023 11:46:12 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v5 0/3] arm: enable MTE for QEMU + kvm
In-Reply-To: <CAFEAcA_QiVe=ZZ1VTVwUiGh6EL8F7qXT=3dnEb+xzUZORO_4Dw@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230203134433.31513-1-cohuck@redhat.com>
 <CAFEAcA_QiVe=ZZ1VTVwUiGh6EL8F7qXT=3dnEb+xzUZORO_4Dw@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 16 Feb 2023 12:46:11 +0100
Message-ID: <87lekxal4s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16 2023, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Fri, 3 Feb 2023 at 13:44, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> Respin of my kvm mte series; tested via check + check-tcg and on FVP.
>
> I've taken patch 1 into target-arm.next since it's a simple
> cleanup.

Thanks!

(I plan to send a respin of the remainder once we've agreed on some of
the feedback.)

