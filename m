Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6973B6D215A
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjCaNS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjCaNSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:18:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5331A46E
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680268658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R29u93+oWpNSwMXbFvdPj5Qlpu2wfig3qZnrc9Aas7g=;
        b=Z/fSBVp6b/r1fiVDK/UXfh6wE0Z4a2oC2BBV3CTLTFPGyAlq60Vx3Oxr29D9xOmmi12S9h
        wUg2gRVndF42eGhjARIXBBibje6P4FgrSJTVXHZIjQ34GxrgUZNjCs6bkvTdQzZ0W5mHjl
        Uc1zK91rxsLzOtwSPW4h4fTyx2U8N8A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-cy7iBHcxN2GIF6nNakoKTQ-1; Fri, 31 Mar 2023 09:17:36 -0400
X-MC-Unique: cy7iBHcxN2GIF6nNakoKTQ-1
Received: by mail-wm1-f70.google.com with SMTP id n19-20020a05600c3b9300b003ef63ef4519so9791554wms.3
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680268655;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R29u93+oWpNSwMXbFvdPj5Qlpu2wfig3qZnrc9Aas7g=;
        b=BuO3EELMqVJuncRsXt1BaZsfaGBbOohwHaBgQOvihAcXRkbAvYfOKLSIad/IDSxTi0
         6ue9MQ82KPPXBDr8q7iF+he7rag/EzkLAIeBDP11Ftzr+E0cuOajHBxlm7xGjZmjVve5
         CoNWT0c0vkHFg//jWqfWlfgvlVUbZz35UqyZD6DhWyOyPXAZBtEzo5vmoomusqcdD4a/
         kaE8Na9dsQK8FNPjKgffzuNzGuPaidn5jy5rvRwYGQtL4DvGs/uSXRCkvKyF3RhVfBzg
         3j9SmKFfgDES7r6cj94ssDYYZyv88yjeEswNqp/ls6F18vGtrHq/VQ1FtjMxRvETBqEV
         qcTg==
X-Gm-Message-State: AAQBX9cYt2jdTz+AA3pRaBhPCT3ZoHT4EbTG6ysLHf4vPVF+1E/M14BJ
        tE8hMgmIWFZgGTpwjcyYKLAVvd1zDjlipHEJM9i/8sUfdWbzZs8zUjB+/PkmlEBLQQ8ODJvHLmO
        9mIBs6zmwGP6EQR4jgGHWsPQ=
X-Received: by 2002:a05:6000:180d:b0:2c5:a38f:ca31 with SMTP id m13-20020a056000180d00b002c5a38fca31mr6538279wrh.7.1680268655363;
        Fri, 31 Mar 2023 06:17:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvW6vc0eOYs/DmAWRda5UOv9Wnjr4WKD0nGgYUlepPK8SuvHvZ2hv7vUwL+H1AXp2mAaoP3g==
X-Received: by 2002:a05:6000:180d:b0:2c5:a38f:ca31 with SMTP id m13-20020a056000180d00b002c5a38fca31mr6538266wrh.7.1680268655056;
        Fri, 31 Mar 2023 06:17:35 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-12.web.vodafone.de. [109.43.177.12])
        by smtp.gmail.com with ESMTPSA id d16-20020a5d4f90000000b002d51d10a3fasm2205837wru.55.2023.03.31.06.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 06:17:34 -0700 (PDT)
Message-ID: <4a757f48-3fc0-4c1a-b401-8a2388b4d94d@redhat.com>
Date:   Fri, 31 Mar 2023 15:17:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests GIT PULL 00/14] s390x: new maintainer, refactor
 linker scripts, tests for misalignments, execute-type instructions and vSIE
 epdx
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
        andrew.jones@linux.dev, Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20230331113028.621828-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230331113028.621828-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/2023 13.30, Nico Boehr wrote:
> Hi Paolo and/or Thomas,
> 
> here comes the first pull request from me. :)

Thanks!

... I gave it a try, but I'm hitting a failure in the spec_ex test:

$ cat logs/spec_ex.log
timeout -k 1s --foreground 90s qemu-system-s390x -nodefaults -nographic -machine s390-ccw-virtio,accel=kvm -chardev stdio,id=con0 -device sclpconsole,chardev=con0 -kernel s390x/spec_ex.elf -smp 1 # -initrd /tmp/tmp.cxHP06rT1F
PASS: specification exception: psw_bit_12_is_1: Program interrupt: expected(6) == received(6)
PASS: specification exception: short_psw_bit_12_is_0: Program interrupt: expected(6) == received(6)
FAIL: specification exception: psw_odd_address: Expected exception due to invalid PSW
PASS: specification exception: odd_ex_target: did not perform ex with odd target
PASS: specification exception: odd_ex_target: Program interrupt: expected(6) == received(6)
PASS: specification exception: bad_alignment_lqp: Program interrupt: expected(6) == received(6)
PASS: specification exception: bad_alignment_lrl: Program interrupt: expected(6) == received(6)
PASS: specification exception: not_even: Program interrupt: expected(6) == received(6)
PASS: specification exception during transaction: odd_ex_target: Program interrupt: expected(518) == received(518)
PASS: specification exception during transaction: bad_alignment_lqp: Program interrupt: expected(518) == received(518)
PASS: specification exception during transaction: bad_alignment_lrl: Program interrupt: expected(518) == received(518)
PASS: specification exception during transaction: not_even: Program interrupt: expected(518) == received(518)
SUMMARY: 12 tests, 1 unexpected failures

EXIT: STATUS=3

I'm sure I'm missing something, I just cannot figure it out right
now (it's Friday afternoon...) - QEMU is the current version from
the master branch, so I thought that it should contain all the
recent fixes ... does this psw_odd_address test require a fix in
the kernel, too? (I'm currently running a RHEL9 kernel)

  Thomas

