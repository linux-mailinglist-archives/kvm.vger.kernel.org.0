Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB3B68C714
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 20:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBFTw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 14:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjBFTwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 14:52:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0459023D92
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 11:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675713098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rVq9FE3zQz68lr7rntok1IqkBi/F8oP97RLDrwJNrAA=;
        b=dq4lG40vq0m37OIicSwq/DOkaQH+I21YTtHwpI5MRyDtn5r1JzafXb4+f60pdjy6GTP3FP
        GwShpBPGFE0R5bdIU0mJKvzrU6Ew+G+LW7s2kLxY4b0Zi/NBVbE5dywGGKMGXJBiJV1783
        JZsiT5xTa7kdU2xLR2j+sWoqNqkhXqk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-Njo0y0DwNYmQxNvIk60sFw-1; Mon, 06 Feb 2023 14:51:35 -0500
X-MC-Unique: Njo0y0DwNYmQxNvIk60sFw-1
Received: by mail-ed1-f70.google.com with SMTP id d21-20020aa7c1d5000000b004a6e1efa7d0so8188374edp.19
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 11:51:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rVq9FE3zQz68lr7rntok1IqkBi/F8oP97RLDrwJNrAA=;
        b=E5PHcmGqALerfIsZdxNBsAujrSdb9CTH4fO0O3fUUaYEimVYG3s8AX/W4U3z8ZQdSK
         cj0fMSu6KSNJ6Z1qCaNM7w5cmd+fl8IVUMeRIhQbc6HxQZv5Z/7hX5tAVVO+doMDWc5d
         WHYODa4ErJpCdaR2+tg3cSGint36NxmZ77H1zdtFvBCEaE37VwN8xEnj7dGpHpTvQgs2
         seXzvCFjn4iM5/KB2Rmtq5fjGcbj9xojYx1+qBQ2YfQYguWfPxXZ2S6BqgEXuW/UWY4h
         Cuq6M6dZ1bYofu2XfsWdQ2uuCUuAVOemv9zCE7gyaclBokn3FCDuCME+oxjindajtaIa
         Cjtg==
X-Gm-Message-State: AO0yUKWxCdSYxJBCxD+ONQAlFF1amois+a9kvrI/KETVJtY/5xxmUJYX
        Mr7McBbrfwtJZX4HBLSQJqAzBB2uzNjrUM7YnTwObC9Q0dbSySMs1yUJANJ24RzEyNZtW7ZTG6v
        LJt1LW3dKq+6Eux6LykGKKy2w/0f6
X-Received: by 2002:a17:906:7b55:b0:88f:9c29:d238 with SMTP id n21-20020a1709067b5500b0088f9c29d238mr184844ejo.214.1675713094569;
        Mon, 06 Feb 2023 11:51:34 -0800 (PST)
X-Google-Smtp-Source: AK7set9p9+rOhbqUscva+gn/sL4GOeq9baOQ8/fRol+3NzaI6Jt/j7FHUp6w61Aaft7LLfmBF8ppV3RFqZ5MN7WEG08=
X-Received: by 2002:a17:906:7b55:b0:88f:9c29:d238 with SMTP id
 n21-20020a1709067b5500b0088f9c29d238mr184825ejo.214.1675713094363; Mon, 06
 Feb 2023 11:51:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
In-Reply-To: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Mon, 6 Feb 2023 19:50:58 +0000
Message-ID: <CAELaAXysa3M-TPbLMCVCwpt40iqhXpF7PCan_i6SzY_YMafXrg@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com
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

On Fri, Jan 27, 2023 at 3:17 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> Dear QEMU, KVM, and rust-vmm communities,
> QEMU will apply for Google Summer of Code 2023
> (https://summerofcode.withgoogle.com/) and has been accepted into
> Outreachy May 2023 (https://www.outreachy.org/). You can now
> submit internship project ideas for QEMU, KVM, and rust-vmm!
>
> Please reply to this email by February 6th with your project ideas.
>
> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> be a mentor. Mentors support interns as they work on their project. It's a
> great way to give back and you get to work with people who are just
> starting out in open source.
>
> Good project ideas are suitable for remote work by a competent
> programmer who is not yet familiar with the codebase. In
> addition, they are:
> - Well-defined - the scope is clear
> - Self-contained - there are few dependencies
> - Uncontroversial - they are acceptable to the community
> - Incremental - they produce deliverables along the way
>
> Feel free to post ideas even if you are unable to mentor the project.
> It doesn't hurt to share the idea!
>
> I will review project ideas and keep you up-to-date on QEMU's
> acceptance into GSoC.
>
> Internship program details:
> - Paid, remote work open source internships
> - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> hrs/week for 12 weeks
> - Mentored by volunteers from QEMU, KVM, and rust-vmm
> - Mentors typically spend at least 5 hours per week during the coding period
>
> For more background on QEMU internships, check out this video:
> https://www.youtube.com/watch?v=xNVCX7YMUL8
>
> Please let me know if you have any questions!
>
> Stefan

FWIW there is some work to be done on libblkio [1] that QEMU could
benefit from. Maybe these would be appropriate as QEMU projects?

One possible project would be to add zoned device support to libblkio
and all its drivers [2]. This would allow QEMU to use zoned
vhost-user-blk devices, for instance (once general zoned device
support lands [3]).

Another idea would be to add an NVMe driver to libblkio that
internally relies on xNVMe [4, 5]. This would enable QEMU users to use
the NVMe drivers from SPDK or libvfn.

Thanks,
Alberto

[1] https://libblkio.gitlab.io/libblkio/
[2] https://gitlab.com/libblkio/libblkio/-/issues/44
[3] https://lore.kernel.org/qemu-devel/20230129102850.84731-1-faithilikerun@gmail.com/
[4] https://gitlab.com/libblkio/libblkio/-/issues/45
[5] https://github.com/OpenMPDK/xNVMe

