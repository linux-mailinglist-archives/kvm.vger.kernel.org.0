Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9610E4BA2A7
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiBQOM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:12:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbiBQOMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:12:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64F2D2905BA
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645107159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/cZXGNior+ZsJ3e+PrQnLgahobz9IXWhoV+xYGtogyM=;
        b=QTfQNWcIM8GgnTr1SmR1Cp8igBefLXlJZU6C4hbufpj2QqNWIqFvbFMqsH2jS2AUa4yJna
        zElbv62TxgPFlWR0MOPUUTO63VxRMRrBZMKrd684Gx73wJH+NjPC2jLiGY0OCknozXjwEk
        KuSrRsVBStRlaXE9gwc5qO4WJiOjTIA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-OIB9AQ86O4GRo0GTNF_RVw-1; Thu, 17 Feb 2022 09:12:35 -0500
X-MC-Unique: OIB9AQ86O4GRo0GTNF_RVw-1
Received: by mail-qv1-f72.google.com with SMTP id g2-20020a0562141cc200b004123b0abe18so5427791qvd.2
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:12:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/cZXGNior+ZsJ3e+PrQnLgahobz9IXWhoV+xYGtogyM=;
        b=h2S4Ak0n79oiO8UCeq307j0R9xwLnLHx62XZVOgyd+NONoyUm5rkbb3xRKQV61sQAA
         6/4cUfCtumE0AeT+ZSRM0QrygCZyenQmyhg4nPsg1pmoBDgKwi/HfJxKj6s3BGiuR5xD
         NVwYNHeB5Czg8SeRCrTiT9lcBNy/KOviWBJ9ZknPd6sRJYqKArDvpWpUb1YasP0OQq+L
         vTpqD4ePfYb4Gphqe1YwRIaxrrjBhsdabTZ+doF0ANi1NALwwuMKCuzrwdVn+riSgjTI
         aXCSTABFj35jSqCMdQZzxRe7jzQ/+Hk9wLhUhdR3pjPRN2ucNbEPjYUOPIv7LEuj3c1F
         AaFw==
X-Gm-Message-State: AOAM531mYI5rZvg6mbFoyrMJ3136PySGHXC+rjBHPYk4qCKBSLNiNIBg
        QODvA3Yv5KemT0vfSbu5X5p8esukRrdsgB4jsXVAHhOEZuv26UxXjI6GBJQMh6dhFRydbUqTOE4
        1NJUNP2a5Myq+
X-Received: by 2002:ae9:f80f:0:b0:60d:dca9:d021 with SMTP id x15-20020ae9f80f000000b0060ddca9d021mr1278465qkh.53.1645107155359;
        Thu, 17 Feb 2022 06:12:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQ28xbd3gosVH54yFSb3YNcBcISrsFM0+HMmhcisfzw8nknVsLJomqhc3vG1UlAdRabcvprw==
X-Received: by 2002:ae9:f80f:0:b0:60d:dca9:d021 with SMTP id x15-20020ae9f80f000000b0060ddca9d021mr1278449qkh.53.1645107155086;
        Thu, 17 Feb 2022 06:12:35 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id h21sm1706611qtm.23.2022.02.17.06.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 06:12:34 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:12:27 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Message-ID: <20220217141227.sk7hfng7raq6xvuh@sgarzare-redhat>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
 <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 02:01:52PM +0000, Stefan Hajnoczi wrote:
>On Mon, 14 Feb 2022 at 07:11, Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>> >
>> > Dear QEMU, KVM, and rust-vmm communities,
>> > QEMU will apply for Google Summer of Code 2022
>> > (https://summerofcode.withgoogle.com/) and has been accepted into
>> > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
>> > submit internship project ideas for QEMU, KVM, and rust-vmm!
>> >
>> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
>> > be a mentor. It's a great way to give back and you get to work with
>> > people who are just starting out in open source.
>> >
>> > Please reply to this email by February 21st with your project ideas.
>> >
>> > Good project ideas are suitable for remote work by a competent
>> > programmer who is not yet familiar with the codebase. In
>> > addition, they are:
>> > - Well-defined - the scope is clear
>> > - Self-contained - there are few dependencies
>> > - Uncontroversial - they are acceptable to the community
>> > - Incremental - they produce deliverables along the way
>> >
>> > Feel free to post ideas even if you are unable to mentor the project.
>> > It doesn't hurt to share the idea!
>>
>> Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
>> (vhost/virtio drivers) would be an interesting idea.
>>
>> It satisfies all the points above since it's supported by virtio spec.
>>
>> (Unfortunately, I won't have time in the mentoring)
>
>Thanks for this idea. As a stretch goal we could add implementing the
>packed virtqueue layout in Linux vhost, QEMU's libvhost-user, and/or
>QEMU's virtio qtest code.
>
>Stefano: Thank you for volunteering to mentor the project. Please
>write a project description (see template below) and I will add this
>idea:
>

I wrote a description of the project below. Let me know if there is 
anything to change.

Thanks,
Stefano



=== VIRTIO_F_IN_ORDER support for virtio devices ===

'''Summary:''' Implement VIRTIO_F_IN_ORDER feature for QEMU and Linux
(vhost/virtio drivers)

The VIRTIO spec defines a feature bit (VIRTIO_F_IN_ORDER) that devices
and drivers can negotiate when they are able to use descriptors in the
same order in which they have been made available.

This feature could allow to simplify the implementation and develop
optimizations to increase performance. For example, when
VIRTIO_F_IN_ORDER is negotiated, it may be easier to create batch of
buffers and reduce the amount of notification needed between devices
and drivers.

Currently the devices and drivers available on Linux and QEMU do not
support this feature. An implementation is available in DPDK for the
virtio-net driver.

The project could start with implementation for a single device/driver
in QEMU and Linux, then generalize it into the virtio core for split
and packed virtqueue layouts.

If time allows we could develop the support for packed virtqueue layout
in Linux vhost, QEMU's libvhost-user, and/or QEMU's virtio qtest code.

'''Links:'''
* [https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.html VIRTIO spec 1.1]
** [https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.html#x1-470009 "In-order use of descriptors" section for split virtqueues]
* [https://github.com/oasis-tcs/virtio-spec Source code for the VIRTIO spec]
* [https://mails.dpdk.org/archives/dev/2018-July/106069.html Patches that introduced VIRTIO_F_IN_ORDER in DPDK]
* [https://lists.oasis-open.org/archives/virtio/201803/msg00048.html Patch that introduced VIRTIO_F_IN_ORDER in VIRTIO spec]
* [https://patchew.org/QEMU/1533833677-27512-1-git-send-email-i.maximets@samsung.com/ Incomplete implementation proposed for QEMU]

'''Details:'''
* Skill level: intermediate
* Language: C
* Mentor: Stefano Garzarella <sgarzare@redhat.com>
** IRC/Matrix nick: sgarzare (OFTC/matrix.org)
* Suggested by: Jason Wang <jasowang@redhat.com>

