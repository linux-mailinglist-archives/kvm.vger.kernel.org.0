Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B87F6A5886
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjB1LrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB1LrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:47:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264612054D
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 03:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677584785;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=m6cRSYLDqBxmDSEyqiKzUBHNZS0fEiYg0wE6z64pGGM=;
        b=giAnOHTq9XGwwjGqAtovfKHBeWZFtD7P4Ro6AkZXxOlpH90WGCHKvIO2vWC3kuXzkVpNp/
        8XDncZY6UjkTV/n2MRAhlPHKrXPaNA8N1QlBh4DSquMQWD6FTnl5T1FWOWLrP4ZU432PDo
        kJ/MhEraI+IARSwpctiF30zug8kzAMM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-292-rIrIvqtHMm2K6HMxOUVHrQ-1; Tue, 28 Feb 2023 06:46:24 -0500
X-MC-Unique: rIrIvqtHMm2K6HMxOUVHrQ-1
Received: by mail-wm1-f72.google.com with SMTP id x18-20020a1c7c12000000b003e1e7d3cf9fso6791918wmc.3
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 03:46:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6cRSYLDqBxmDSEyqiKzUBHNZS0fEiYg0wE6z64pGGM=;
        b=B0TQBeMEty2bR9Dn0oT0UiCwvhJP5X5qxIMfWY0syD2N9YNnt6XUqgBRPQ7PiaUpyG
         XdVZwVt5panZOsp5jcjF3XVl6c03XZeDaAK8o3vdEVISWEZ8DEgo55NpSOAtCHsJ6bAH
         Fry3ZkPQ64qOeLbUzCALzBV7Cm+52HC3P1AmBirx3Inni5/KCw19XB5EGijvBoH0qUbD
         AdframUG3EjhYeLJDM6J/nVbGniBt9P+TzQPftv4G3L4LCCncnANUH5qmcZ11GVKJez8
         16jvaHKqD2NdpYW2JqK7KuTDm1GdwA/l7onqkj2xLu/vAGTFwRV+40SQdRDupBp+ElY+
         N3Nw==
X-Gm-Message-State: AO0yUKUJNxSbcvVEPXmEKcCBYDg+NYMMB43PWDlpvEoJfuFSS3kgH0NQ
        X4JJE9j4bjrPRXMzoCbVCnQPuNbTpMBDC/YO7nx08B/yQR+PPxE/DpPFw+19XZqzkgt1sJgTB+f
        kgyjOHHOa1zw6
X-Received: by 2002:a05:600c:4fc8:b0:3ea:e7e7:95da with SMTP id o8-20020a05600c4fc800b003eae7e795damr1964809wmq.8.1677584782846;
        Tue, 28 Feb 2023 03:46:22 -0800 (PST)
X-Google-Smtp-Source: AK7set/shMKwCM172ZTzRXWJO9JyUd7nbrrQtrMMFTF4z77g0hvfydVuvcyPD65XxdgZUTNXe8YBCg==
X-Received: by 2002:a05:600c:4fc8:b0:3ea:e7e7:95da with SMTP id o8-20020a05600c4fc800b003eae7e795damr1964788wmq.8.1677584782462;
        Tue, 28 Feb 2023 03:46:22 -0800 (PST)
Received: from redhat.com (nat-252.udc.es. [193.144.61.252])
        by smtp.gmail.com with ESMTPSA id m25-20020a7bca59000000b003db0bb81b6asm12198013wml.1.2023.02.28.03.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:46:21 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Markus Armbruster <armbru@redhat.com>,
        Paul Moore <pmoore@redhat.com>, peter.maydell@linaro.org
Subject: Re: Fortnightly KVM call for 2023-02-07
In-Reply-To: <Y/fi95ksLZSVc9/T@google.com> (Sean Christopherson's message of
        "Thu, 23 Feb 2023 14:04:39 -0800")
References: <87o7qof00m.fsf@secure.mitica> <Y/fi95ksLZSVc9/T@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 28 Feb 2023 12:46:20 +0100
Message-ID: <87cz5uko6r.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> wrote:
> On Tue, Jan 24, 2023, Juan Quintela wrote:
>> Please, send any topic that you are interested in covering in the next
>> call in 2 weeks.
>> 
>> We have already topics:
>> - single qemu binary
>>   People on previous call (today) asked if Markus, Paolo and Peter could
>>   be there on next one to further discuss the topic.
>> 
>> - Huge Memory guests
>> 
>>   Will send a separate email with the questions that we want to discuss
>>   later during the week.
>> 
>> After discussions on the QEMU Summit, we are going to have always open a
>> KVM call where you can add topics.
>
> Hi Juan!
>
> I have a somewhat odd request: can I convince you to rename "KVM call" to something
> like "QEMU+KVM call"?
>
> I would like to kickstart a recurring public meeting/forum that (almost) exclusively
> targets internal KVM development, but I don't to cause confusion and definitely don't
> want to usurp your meeting.  The goal/purpose of the KVM-specific meeting would be to
> do design reviews, syncs, etc. on KVM internals and things like KVM selftests, while,
> IIUC, the current "KVM call" is aimed at at the entire KVM+QEMU+VFIO ecosystem.

I can do that.
I would have told you that you could use our slots, but right now we are
quite low on slots.

If nobody objects, I will change that for the next call.

Later, Juan.

