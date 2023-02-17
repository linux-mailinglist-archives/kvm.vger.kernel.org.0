Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0369B17B
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBQQ5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjBQQ5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:57:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467CC5DE38
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676653017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fxPt34nrZPuavKcm7iaVj1yB8nD5qAN79wOAGplqJ+U=;
        b=QYOK9DwJWdNc3/NG/tUpwnRAIT/nJ6gyQH6bFEubFsPVhH5NqYcEwXhCa/pXO5m0C6Ue8o
        iJRCPFk2zTyZOJwKSXpuoygfUvA/zRU8kBk0gxurBn/RpjqTfNNC4Hcs/aFk/xchFViYlS
        gWf6aCa++sOtNOFugwPqWZt9YemTxUw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-YDyUc7TwO6qTbrqFxCJrhQ-1; Fri, 17 Feb 2023 11:56:55 -0500
X-MC-Unique: YDyUc7TwO6qTbrqFxCJrhQ-1
Received: by mail-ed1-f71.google.com with SMTP id m28-20020a50999c000000b004a245f58006so2876368edb.12
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:56:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxPt34nrZPuavKcm7iaVj1yB8nD5qAN79wOAGplqJ+U=;
        b=mjwd5S7DSqTUmuaJxZvBuPfbLjrxpGLjCC4JodT/38CP3C1IxP/BDW804dI1Ah9RFe
         6UmnhZQuY4pBcaAZTul5DI5AhbKfujy+bEeHXj3LzAq9MlQyPNl1bCvloe4bWP5dM7Pn
         8gwYiXoWGNt7JvMczD5V3XhDNiSaz+keUDMddrdKI25KWGk183B2XXN9AWgDhitjvqHj
         RNsG3wtqw1rITgAq6LNRd3hn1yLCTnn9EIr8cXpYR8bVlXdYxRGWKdcVP5xL0X2CG89S
         B3lKVVP4PT42fvUUvsUHbghMbULMnGS7p2Tfl5TyTXvh3T1m3koev5pgi/oWhkHiaZe6
         fj6w==
X-Gm-Message-State: AO0yUKVbcg+NfUjJFbaoPr9LZbryk4RpWRmkpmEDi8/z3N0qhAIZyxUn
        Le+8pwkXGGQNG0x23p/W8JTV6ctf3vIopXP5mONEYsqzv8N1yk//2jfIafdIT/noHzsI/WWnG35
        zm7axhjYy4tP/
X-Received: by 2002:a17:907:2d0f:b0:879:d438:4d1c with SMTP id gs15-20020a1709072d0f00b00879d4384d1cmr482895ejc.21.1676653014716;
        Fri, 17 Feb 2023 08:56:54 -0800 (PST)
X-Google-Smtp-Source: AK7set8wr1SrS1L6I+vNIQrdU6DEeg2rU2MbgqdidJX1cMh2eZLmHk6xCYyJgA+NuoqLeF3rmgmmHA==
X-Received: by 2002:a17:907:2d0f:b0:879:d438:4d1c with SMTP id gs15-20020a1709072d0f00b00879d4384d1cmr482864ejc.21.1676653014390;
        Fri, 17 Feb 2023 08:56:54 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-224.retail.telecomitalia.it. [87.11.6.224])
        by smtp.gmail.com with ESMTPSA id w7-20020a17090649c700b0073d796a1043sm2310060ejv.123.2023.02.17.08.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:56:53 -0800 (PST)
Date:   Fri, 17 Feb 2023 17:56:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alberto Faria <afaria@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
Message-ID: <20230217165650.g6easy422igaa73e@sgarzare-redhat>
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <20230217162334.b33myqqfzz33634b@sgarzare-redhat>
 <CAJSP0QXDD5uyY5Neccf4WmGyuXwHuefwbToBdZDwegV2XHMnHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJSP0QXDD5uyY5Neccf4WmGyuXwHuefwbToBdZDwegV2XHMnHA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 11:53:03AM -0500, Stefan Hajnoczi wrote:
>On Fri, 17 Feb 2023 at 11:23, Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> Hi Stefan,
>>
>> On Fri, Jan 27, 2023 at 10:17:40AM -0500, Stefan Hajnoczi wrote:
>> >Dear QEMU, KVM, and rust-vmm communities,
>> >QEMU will apply for Google Summer of Code 2023
>> >(https://summerofcode.withgoogle.com/) and has been accepted into
>> >Outreachy May 2023 (https://www.outreachy.org/). You can now
>> >submit internship project ideas for QEMU, KVM, and rust-vmm!
>> >
>> >Please reply to this email by February 6th with your project ideas.
>>
>> sorry for being late, if there is still time I would like to propose the
>> following project.
>>
>> Please, let me know if I should add it to the wiki page.
>
>Hi Stefano,
>I have added it to the wiki page:
>https://wiki.qemu.org/Internships/ProjectIdeas/VsockSiblingCommunication

Great, thanks!

>
>I noticed that the project idea describes in words but never gives
>concrete details about what sibling VM communication is and how it
>should work. For someone who has never heard of AF_VSOCK or know how
>addressing works, I think it would help to have more detail: does the
>vhost-user-vsock program need new command-line arguments that define
>sibling VMs, does a { .svm_cid = 2, .svm_port = 1234 } address usually
>talk to a guest but the TO_HOST flag changes the meaning and you wish
>to exploit that, etc? I'm not suggesting making the description much
>longer, but instead tweaking it with more concrete details/keywords so
>someone can research the idea and understand what the tasks will be.

You are right, I will add more details/keywords to make it clearer.

Thanks,
Stefano

