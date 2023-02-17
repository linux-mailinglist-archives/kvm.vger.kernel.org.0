Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334A069B0CC
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjBQQZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBQQZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:25:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3A26EF3E
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676651020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MjzchUN/f8n3YVcteUgl6j3t1/V7XmUc2chEf4jEeMU=;
        b=JdlOpCeQhK5XVEajOlsl7FKhAZ22l80pQwP6IUezGGIbl6wUDP2tNU+bmyS8b/EEJNat+t
        thVFGejL2DuwCQ38C6CV9pCWXFRA9q2IFZ/w0uHZCi9gaNwP0s/MW9AnAOXoTnjTGyexqX
        8TUrH9+k5ekovxtkzE5TA3dPVunDVDo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-eUtm1UZ_PT6BeNna2iSPBA-1; Fri, 17 Feb 2023 11:23:39 -0500
X-MC-Unique: eUtm1UZ_PT6BeNna2iSPBA-1
Received: by mail-ed1-f72.google.com with SMTP id x14-20020a05640226ce00b004acc4f8aa3fso2401825edd.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjzchUN/f8n3YVcteUgl6j3t1/V7XmUc2chEf4jEeMU=;
        b=v/hJtXEYaT4yUFgZGJkkln2l+/kRMVpJCNJ8SyiN0IN58R8rWf5tEmS7hiZyGCWRvo
         s8Q+btsI9chqbw/NIyuWvajefPjXQe06zhO666UyleiRUgLDkI0JdGWuMksRt/UP/jQh
         pHW4RDTof91+nbFAwdLJEFp+VqDTgZIIaPiwWPq6NLrf1MQnernTAiPulKBzGRBWSsvF
         HraiVFKb0uTG64X99jY1KPYTJ/VBYHCh+buN8O1qkwgBOi7a5EwImXMKl9+/0uMvNqG/
         VW/TtPr+QbXISyZzDn64R+IXxu4cVFO75jQq4yIiLUf3Z8C6vrrJ2u9FzgWMNK3FndWc
         ApUA==
X-Gm-Message-State: AO0yUKUVbn5YUtLeJYut9hFOLlFPRapD17D6U7PcQl0QlQ+ixITJwx0+
        KUxWwFzRpg431oP6fZkbVbjqzsav8Q1PiwT9V+vV+3F3LOPsqmEVXb1RfInc8vDCHVx1F+wtxbJ
        Q616Y2lUvCFsf
X-Received: by 2002:a05:6402:445:b0:4ac:b2c8:aeaf with SMTP id p5-20020a056402044500b004acb2c8aeafmr1350127edw.26.1676651017691;
        Fri, 17 Feb 2023 08:23:37 -0800 (PST)
X-Google-Smtp-Source: AK7set8fpWKhTwJpxJnLqUuZMMmEGvGXFqrqsJXG8Kb6oEsgQzjVEOaZq9IYVHv29Q90e2WfR8p/7A==
X-Received: by 2002:a05:6402:445:b0:4ac:b2c8:aeaf with SMTP id p5-20020a056402044500b004acb2c8aeafmr1350091edw.26.1676651017394;
        Fri, 17 Feb 2023 08:23:37 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-224.retail.telecomitalia.it. [87.11.6.224])
        by smtp.gmail.com with ESMTPSA id s27-20020a50ab1b000000b004acb6d659eesm2494746edc.52.2023.02.17.08.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:23:36 -0800 (PST)
Date:   Fri, 17 Feb 2023 17:23:34 +0100
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
Message-ID: <20230217162334.b33myqqfzz33634b@sgarzare-redhat>
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stefan,

On Fri, Jan 27, 2023 at 10:17:40AM -0500, Stefan Hajnoczi wrote:
>Dear QEMU, KVM, and rust-vmm communities,
>QEMU will apply for Google Summer of Code 2023
>(https://summerofcode.withgoogle.com/) and has been accepted into
>Outreachy May 2023 (https://www.outreachy.org/). You can now
>submit internship project ideas for QEMU, KVM, and rust-vmm!
>
>Please reply to this email by February 6th with your project ideas.

sorry for being late, if there is still time I would like to propose the 
following project.

Please, let me know if I should add it to the wiki page.

Any feedback or co-mentors are welcome :-)

Thanks,
Stefano



=== Sibling VM communication in vhost-user-vsock ===

'''Summary:''' Extend the existing vhost-user-vsock Rust application to
support sibling VM communication

During GSoC 2021, we developed vhost-user-vsock application in Rust. It
leveraged the vhost-user protocol to emulate a virtio-vsock device in an
external process. It provides the hybrid VSOCK interface over AF_UNIX
introduced by Firecracker.

The current implementation supports a single virtual machine (VM) per
process instance.
The idea of this project is to extend the vhost-user-vsock crate
available in the rust-vmm/vhost-device workspace to support multiple VMs
per instance and allow communication between sibling VMs.

This project will allow you to learn more about the virtio-vsock
specification, rust-vmm crates, and vhost-user protocol to interface
with QEMU.

This work will be done in Rust, but we may need to patch the
virtio-vsock driver or vsock core in Linux if we will find some issues.
AF_VSOCK in Linux already supports the VMADDR_FLAG_TO_HOST flag to be
used in the struct sockaddr_vm to communicate with sibling VMs.

Goals:
* Understand how a virtio-vsock device works
* Refactor vhost-user-vsock code to allow multiple virtio-vsock device instances
* Extend the vhost-user-vsock CLI
* Implement sibling VM communication
* (optional) Support adding new VMs at runtime

'''Links:'''
* [https://gitlab.com/vsock/vsock vsock info and issues]
* [https://wiki.qemu.org/Features/VirtioVsock virtio-vsock QEMU wiki page]
* [https://github.com/rust-vmm/vhost-device/tree/main/crates/vsock vhost-user-vsock application]
* [https://summerofcode.withgoogle.com/archive/2021/projects/6126117680840704 vhost-user-vsock project @ GSoC 2021]
* [https://github.com/firecracker-microvm/firecracker/blob/master/docs/vsock.md Firecracker's hybrid VSOCK]
* [https://gitlab.com/qemu-project/qemu/-/blob/master/docs/interop/vhost-user.rst vhost-user protocol]
* [https://lore.kernel.org/lkml/20201214161122.37717-1-andraprs@amazon.com/ VMADDR_FLAG_TO_HOST flag support in Linux]

'''Details:'''
* Project size: 350 hours
* Skill level: intermediate (knowledge of Rust and virtualization)
* Language: Rust
* Mentor: Stefano Garzarella <sgarzare@redhat.com>
** IRC: sgarzare / Matrix: @sgarzare:matrix.org
* Suggested by: Stefano Garzarella <sgarzare@redhat.com>

