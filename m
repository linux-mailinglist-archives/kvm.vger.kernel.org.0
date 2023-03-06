Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260A56ACB1B
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 18:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCFRqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 12:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjCFRqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 12:46:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F873A86E
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 09:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678124641;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=DYFP8HuE+yaNzeKTTTVNqRqJhb/S7jiZ0JcSofqiuRU=;
        b=SWZGs8hZcuaA4NGlSEfcJqgq/4yWaWqSQgpMqPGtCN7qa1zx3Eq3jnBkswJdJ3tX53e9Gd
        jp78EB4Al2mcsRD72VIqZJbnOLmYdqW8K622eJUP8A2yGdxMvwPJ7GzyroPZ43lwnvGFR9
        FyBOkc2gBuwzVILDGqbrOJ39SXE3b1s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-JlHvj7k9O5ynLltc-wr4UQ-1; Mon, 06 Mar 2023 11:29:39 -0500
X-MC-Unique: JlHvj7k9O5ynLltc-wr4UQ-1
Received: by mail-ed1-f71.google.com with SMTP id ec11-20020a0564020d4b00b004e2cb85c8bcso5556374edb.16
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 08:29:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678120177;
        h=content-transfer-encoding:subject:reply-to:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DYFP8HuE+yaNzeKTTTVNqRqJhb/S7jiZ0JcSofqiuRU=;
        b=YMkhi+QBEe1pMmFqSOyivZ1gxeefQtL25yAL6LAVw/mv8Ui5vHcCrspogYrEiLvUb+
         QX1/rgTcT+K0MuxJQGIsIo2L0l1YSC/YCpbaaipp2f7LLw+PI+Mc0wp4vcqghuDl42Vh
         fNKctZl4ZU8xqJ26GGccgr/eYxt4YgTfKWSmgk4hJkY+OiQLX36+ZIYw9Kam5jN5M5lV
         oFzD9Q1ksosxSPI0qmy61SnxUnsuVSgPRWKmm4m/CIDA6IDaqDxT8y5HkV8Yo3WKaMqi
         jw+31uptAWMsAZtWFlgYlML8PVk4P6e9348G8GVEia/4PHI/plBdJ5nCNlCsofbYNZHM
         n+Ow==
X-Gm-Message-State: AO0yUKWM5Y0uwINi0xupqyp9QFUqpICF/WXjM9HHYqQWZS/AZnv6bxS4
        G3qL2R+oe8vO4gQgh+Ajj0z1yjIp+Gq7hoWhf13UheLcE6MbshBOB/SWih0QiF4fL9VA+pOwhhw
        Zwx9Yl3LbVc36
X-Received: by 2002:a17:906:da89:b0:8b1:7de6:e292 with SMTP id xh9-20020a170906da8900b008b17de6e292mr14890419ejb.9.1678120177372;
        Mon, 06 Mar 2023 08:29:37 -0800 (PST)
X-Google-Smtp-Source: AK7set/wyuFHbxDX/+lcHjnLlx2Nkm7CeI7Shdjq4qxCXPT/2t+nGQRlBbeQ12jrS6iK7BAuPFccfg==
X-Received: by 2002:a17:906:da89:b0:8b1:7de6:e292 with SMTP id xh9-20020a170906da8900b008b17de6e292mr14890395ejb.9.1678120177010;
        Mon, 06 Mar 2023 08:29:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id fx14-20020a1709069e8e00b008e56a0d546csm4734899ejc.123.2023.03.06.08.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 08:29:36 -0800 (PST)
Message-ID: <52e4dfe2-128e-2a1a-b627-6aceebfbb5b0@redhat.com>
Date:   Mon, 6 Mar 2023 17:29:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     qemu-devel <qemu-devel@nongnu.org>, KVM list <kvm@vger.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Reply-To: "kvm-forum-2023-pc@redhat.com" <kvm-forum-2023-pc@redhat.com>
Subject: KVM Forum 2023: Call for presentations
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

###########################
KVM Forum 2023
June 14-15, 2023
Brno, Czech Republic
https://kvm-forum.qemu.org/
###########################

KVM Forum is an annual event that presents a rare opportunity for 
developers and users to discuss the state of Linux virtualization 
technology and plan for the challenges ahead. Sessions include updates 
on the state of the KVM virtualization stack, planning for the future, 
and many opportunities for attendees to collaborate.

This year's event will be held in Brno, Czech Republic on June 14-15, 
2023.  It will be in-person only and will be held right before the 
DevConf.CZ open source community conference.

June 14 will be at least partly dedicated to a hackathon or "day of 
BoFs". This will provide time for people to get together and discuss 
strategic decisions, as well as other topics that are best solved within 
smaller groups.


CALL FOR PRESENTATIONS
======================

We encourage you to submit presentations at 
https://kvm-forum.qemu.org/2023/cfp.  Suggested topics include:

* Scalability and Optimization

* Hardening and security

* Confidential computing

* Testing

* KVM and the Linux Kernel:
   * New Features and Ports
   * Device Passthrough: VFIO, mdev, vDPA
   * Network Virtualization
   * Virtio and vhost

* Virtual Machine Monitors and Management:
   * VMM Implementation: APIs, Live Migration, Performance Tuning, etc.
   * Multi-process VMMs: vhost-user, vfio-user, QEMU Storage Daemon
   * QEMU without KVM: Hypervisor.framework and other hypervisors
   * Managing KVM: Libvirt, KubeVirt, Kata Containers

* Emulation:
   * New Devices, Boards and Architectures
   * CPU Emulation and Binary Translation


IMPORTANT DATES
===============

The deadline for submitting presentations is April 2, 2023 - 11:59 PM PDT.

Accepted speakers will be notified on April 17, 2023.


ATTENDING KVM FORUM
===================

Admission to KVM Forum and DevConf.CZ is free. However, registration is 
required and the number of attendees is limited by the space available 
at the venue. You can register for KVM Forum 2023 at

    https://kvm-forum.qemu.org/2023/register/

The DevConf.CZ program will feature technical talks on a variety of 
topics, including cloud and virtualization infrastructure—so make sure 
to register for DevConf.CZ as well if you would like to attend.

We are committed to fostering an open and welcoming environment at our 
conference. Participants are expected to abide by the Devconf.cz code of 
conduct and media policy:

    https://www.devconf.info/coc/
    https://www.devconf.info/media-policy/


GETTING TO BRNO
===============

Brno has a small international airport with flights from London 
(Stansted) and other European cities.

Other nearby airports include Vienna, Bratislava and Prague. Travelling 
to Brno is easiest from Vienna Schwechat Airport, from where there are 
direct buses operated by RegioJet:

    https://regiojet.com/?fromLocationId=10204055&toLocationId=10202002

More detailed information will be posted on the DevConf.CZ website 
closer to the conference.


CONTACTS
========

Reach out to us should you have any questions. The program committee may 
be contacted as a group via email: kvm-forum-2023-pc@redhat.com.

