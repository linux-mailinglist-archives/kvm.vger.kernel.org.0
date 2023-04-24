Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCE6ED186
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjDXPhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 11:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjDXPhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 11:37:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1FB7A9C
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682350620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/CAo7ajv8NQ/2ztFNCQQbDdpRXuWVRxNmzbnC6f9fp4=;
        b=ecVZsdyDcQvYp/7hw9H5YpG/OGpt1phLusW0b7i4hhFxrwkWXrW6OgzGn6zRZJzcof0iE0
        jWFQfN14PWi9kAANji3LeGT/ICwD9w0mYFHZWU+N358TnEqyJgaCKp6g20qht2lqItktBg
        PNuDSSBUYPey+P8mzEA9y+2EwzuHPJY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-OkG7ivJDNwWb-YVJ_15HkA-1; Mon, 24 Apr 2023 11:36:58 -0400
X-MC-Unique: OkG7ivJDNwWb-YVJ_15HkA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f0a12ab268so6924911cf.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682350618; x=1684942618;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CAo7ajv8NQ/2ztFNCQQbDdpRXuWVRxNmzbnC6f9fp4=;
        b=ipLrOYLH77hAlonCbGnk9dVcmdGIiQXDELqgVbVi0LmH1ZkmWOdW9ILJ4S75IdoKQ+
         CxBnImBzE/TI0OqRQSHU7kZ9M3xiYLglCg8D7h/oG4iIhi4VIrQ36H/iMf7H5/yubnem
         39e3hV8/LOm8XEzNGEGlyFPOdsB4wa5TbGGxFnGrD75ZBZyorKzuWXpHA2NqnQRosoIw
         qMYnsNIiF7/PsD+wUQ4GwvVn/XjDNlIhJ4qzD9UfgJOiNq+U8R2a/bHW5IZTp7wF7QRj
         Sj1ufwVXLKnzWj6XR129vRIFes7i6kcPgEtRXOgX/oaNia7GXW1fvLIvzyaL8mjQYB+J
         rgMg==
X-Gm-Message-State: AAQBX9drFecpqciJH6ZlX+Xvp9Qt6hw40hIF/nfykBzsoerRjSPo+WXE
        nWh/edtO67sNXSuk3Twuo8B+yqbqzZM5yMtQEYu0kekqMu+uQgqf+p6lj4mb6Td6Xwx3RknCXH/
        SfQsiIA+bpDmF
X-Received: by 2002:a05:622a:1a09:b0:3ef:3af7:1c4a with SMTP id f9-20020a05622a1a0900b003ef3af71c4amr23814706qtb.5.1682350618334;
        Mon, 24 Apr 2023 08:36:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z1sU41bm37KXgY1/iSYPLEpQ6S3VAy+8sj8XhWZFOdj93XffQuOAs3sNYAX2qXESHEnyg80g==
X-Received: by 2002:a05:622a:1a09:b0:3ef:3af7:1c4a with SMTP id f9-20020a05622a1a0900b003ef3af71c4amr23814661qtb.5.1682350618008;
        Mon, 24 Apr 2023 08:36:58 -0700 (PDT)
Received: from [192.168.149.117] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id x15-20020ac84d4f000000b003ef28a76a11sm3697374qtv.68.2023.04.24.08.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 08:36:57 -0700 (PDT)
Message-ID: <f7e2495d-56d1-158e-b898-d3869e4e4a89@redhat.com>
Date:   Mon, 24 Apr 2023 17:36:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm:queue] [kvm] c7ed946b95: kvm-unit-tests.msr.fail
Content-Language: de-CH
To:     kernel test robot <yujie.liu@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <202304241320.ab1eea12-yujie.liu@intel.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <202304241320.ab1eea12-yujie.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24/04/2023 um 08:19 schrieb kernel test robot:
> Hello,
> 
> kernel test robot noticed "kvm-unit-tests.msr.fail" on:
> 
> commit: c7ed946b95cbd4c0e37479df320daf6af7e86906 ("kvm: vmx: Add IA32_FLUSH_CMD guest support")
> https://git.kernel.org/cgit/virt/kvm/kvm.git queue
> 
> in testcase: kvm-unit-tests
> version: kvm-unit-tests-x86_64-02d8bef-1_20230421
> 
> compiler: gcc-11
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz (Haswell) with 8G memory
> 
> 
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <yujie.liu@intel.com>
> | Link: https://lore.kernel.org/oe-lkp/202304241320.ab1eea12-yujie.liu@intel.com
> 
> 
> $ ./run_tests.sh -v msr
> TESTNAME=msr TIMEOUT=90s ACCEL= ./x86/run x86/msr.flat -smp 1 -cpu max,vendor=GenuineIntel
> FAIL msr (1899 tests, 2 unexpected failures)
> 
> # msr.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel x86/msr.flat -smp 1 -cpu max,vendor=GenuineIntel # -initrd /tmp/tmp.BZGuoMxiVP
> enabling apic
> smp: waiting for 0 APs
> ...
> FAIL: Expected success on WRSMR(PRED_CMD, 0x0), got vector 13
> FAIL: Expected success on WRSMR(PRED_CMD, 0x1), got vector 13
> ...
> 
> 

FYI this failure is fixed with
https://patchwork.kernel.org/project/kvm/cover/20230322011440.2195485-1-seanjc@google.com/
which is currently on the 'kvm/next' branch. I tested it just to be sure.
The 'kvm/queue' branch doesn't contain that patch yet, and that's why
this unit test failed.

Thank you,
Emanuele

