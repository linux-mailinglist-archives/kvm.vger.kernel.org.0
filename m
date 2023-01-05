Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3027A65EAA1
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 13:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjAEMY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 07:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjAEMYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 07:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E8A38AD8
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 04:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672921448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k2Cc8KbcqDM52tgjmCbz6zzOKzeDpQU8nAj3gh4LJuk=;
        b=EZTCleC0uVO83WJTe9wIvSDyye4k21PQrfX0yTsWwrRb/jlZG9fQVmK6INnaCO8po4NZ4Y
        tH+xAVquoKqwN6mpgvwg3vd5rPsc2VK8/Vg23kexb2QU3cMAgue7fB0Jk2IiHXjVHtmMdV
        G/uNbmg5KCYNRR6G4AYMyrnVeMQe3mM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-59-VtuZZRRQO5SCqy3ed7PPQg-1; Thu, 05 Jan 2023 07:24:07 -0500
X-MC-Unique: VtuZZRRQO5SCqy3ed7PPQg-1
Received: by mail-wm1-f69.google.com with SMTP id k20-20020a05600c1c9400b003d9717c8b11so17652435wms.7
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 04:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k2Cc8KbcqDM52tgjmCbz6zzOKzeDpQU8nAj3gh4LJuk=;
        b=qRxmw97JuNUGx412c8PrPaV8aC+VzS+HQABTW685hSDbLzTwS9d3ESpEhsbJw2mvyo
         09S8mdVOuVUWsWYgCcNe7xR8lBF2COmHTAR8jSdqhGYt7tYxaXK8a/cGbrqM3fdtNfCC
         9L7HYq01yZfKyUfHanJd4LQ/15L26iDevE0aO+a3ZTZ5DlpAmHCwj8SDSwTq2imoYVHL
         lFQvtRvVmwfGdJkEX49xskVEEe0FRsskpXN/x60mMNHFZ+hHCqoYQTsGjEotyoelVg8Z
         RF6UXoOdjNnaMi1elUIU6PU6Q0DfLjMx3jTSt+zoQOnHkyFVa0lF+8bYBj7ZhTk0E9yU
         iKcw==
X-Gm-Message-State: AFqh2kqgIuE62pAWTmYH1HKY3Sm3JQoCXeM4oCdi2bpHpl7EU292Unqk
        MMBXORZ2mPbP+BYhBcog7AqEt8ae6dZ6qhKsy5fOIAxQiIsybu2zNn156QEgoayxX9IbZ/TBBWK
        kjg9K5LibBeGy
X-Received: by 2002:a05:600c:1c27:b0:3cf:a83c:184a with SMTP id j39-20020a05600c1c2700b003cfa83c184amr37101124wms.24.1672921446179;
        Thu, 05 Jan 2023 04:24:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtw2mdOo+3v1uzvblMByMiy8w1YpA4B3d1tu4jDJ0obI2TdlWhJBzWPoYN457kYkpdWhoi3JQ==
X-Received: by 2002:a05:600c:1c27:b0:3cf:a83c:184a with SMTP id j39-20020a05600c1c2700b003cfa83c184amr37101116wms.24.1672921445990;
        Thu, 05 Jan 2023 04:24:05 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-239.web.vodafone.de. [109.43.176.239])
        by smtp.gmail.com with ESMTPSA id fj15-20020a05600c0c8f00b003cf894dbc4fsm2260657wmb.25.2023.01.05.04.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 04:24:05 -0800 (PST)
Message-ID: <b525ee76-67ce-f1f9-8b09-b3d447641943@redhat.com>
Date:   Thu, 5 Jan 2023 13:24:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests GIT PULL 4/4] s390x: add CMM test during
 migration
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, pbonzini@redhat.com,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
References: <20230105121538.52008-1-imbrenda@linux.ibm.com>
 <20230105121538.52008-5-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105121538.52008-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 13.15, Claudio Imbrenda wrote:
> From: Nico Boehr <nrb@linux.ibm.com>
> 
> Add a test which modifies CMM page states while migration is in
> progress.
> 
> This is added to the existing migration-cmm test, which gets a new
> command line argument for the sequential and parallel variants.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/r/20221221090953.341247-2-nrb@linux.ibm.com
> Message-Id: <20221221090953.341247-2-nrb@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/migration-cmm.c | 258 +++++++++++++++++++++++++++++++++++++-----
>   s390x/unittests.cfg   |  15 ++-
>   2 files changed, 240 insertions(+), 33 deletions(-)

  Hi!

While this works fine on my z15 LPAR, I'm getting a failure when running 
this test on my z13 LPAR:

$ cat logs/migration-cmm-parallel.log
run_migration timeout -k 1s --foreground 90s /usr/local/bin/qemu-kvm 
-nodefaults -nographic -machine s390-ccw-virtio,accel=kvm -chardev 
stdio,id=con0 -device sclpconsole,chardev=con0 -kernel 
s390x/migration-cmm.elf -smp 2 -append --parallel # -initrd /tmp/tmp.YKFTGTHnwt
SMP: Initializing, found 2 cpus
Now migrate the VM, then press a key to continue...
INFO: migration-cmm: parallel: Migration complete
INFO: migration-cmm: parallel: thread completed 65308 iterations
FAIL: migration-cmm: parallel: during migration: page state mismatch: first 
page idx = 0, addr = 28000, expected_mask = 0x1, actual_mask = 0x2
FAIL: migration-cmm: parallel: after migration: page state mismatch: first 
page idx = 0, addr = 28000, expected_mask = 0x1, actual_mask = 0x2
SUMMARY: 2 tests, 2 unexpected failures

EXIT: STATUS=3

Could you please fix that first?

  Thanks,
   Thomas

