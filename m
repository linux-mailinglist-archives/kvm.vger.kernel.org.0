Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D686A3FE8
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjB0LDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjB0LCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:02:49 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739141E1DC
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 03:02:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bv17so5752533wrb.5
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 03:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Is/n8ikgsa8LBLgoVQRElvzTDGlEkSd4GJxiKByJwRA=;
        b=Lh1ZBBJB+tzHlYU6omZ0zSL1OLZTfZRbP60mACXNed4z9IkV8owVDV7nq1/A1SaT98
         D8Q+j99tLPZS1i1lcpi+Q7hA4nXzkmdpDtgVFnc24kpujSuC9E+vlggJVAXAGB8acXRS
         Vf9TZ4pYBNXjMneMFvqoxzFhw6bd0MtiEzk/OKOFqJ6Da8lshHfMJKDOqUK1X22Ea5Mk
         gaV9qsqsuSmrVfIUir0xADfH+e+A3c1WVzVoWL91m0KcgXwlCbf6YotC+iXiZmNiF/Kv
         kMQ5pA51DHCevIyJ4wfi1dfU4zYg3UUEiMWUc/ifmT2SF3JM27BydM77Qqvk0r9tJJ97
         u6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Is/n8ikgsa8LBLgoVQRElvzTDGlEkSd4GJxiKByJwRA=;
        b=Wn4MXVRlolRSPFlDr0lv7cisNHG2Yzm9vVZxJeUU1+0OzBbC3d2z46hHFCo+/xcWv5
         7pTEpXdRZaIm94BVhVQhfGQZPqpGgK+LwnqyBnhaXZqmpSf483qsEPvZ0ig6u1vR7QRk
         LFKT4ya9CD4YoHe3HeT6QgpmQRIlBvWq162otuFKephqqUHtrWP6SHWfyblE9FDu5fAO
         LI8RZo2ijtfPFX9lY9uslZ89xb1twHPBf7lgM6atKv6MiLFBzXqtLSgAQs0taNEMXN0b
         XqSwjwN/KJiuB7umG76JXpbzbjnwBChOdPQ6HZNb74chImnTKf5s7lopOyN5uXvnp5Do
         2U4A==
X-Gm-Message-State: AO0yUKXuYSdlx9QVNzye4VTcNSkhWDMTNGen+bh1WBtsIT+c2EulUyQn
        bUUll1eY6tDO18hh8hdAoT8z1nWAce5Mjg==
X-Google-Smtp-Source: AK7set+fB4DjVZD8pJyiDu5c5EZ3UJFCijIrqXCHUGVSZ254lh5UDZknryfYDq4jiuLJW/3zsc8Zpg==
X-Received: by 2002:adf:ef8e:0:b0:2c7:adb:db9 with SMTP id d14-20020adfef8e000000b002c70adb0db9mr13870345wro.63.1677495744830;
        Mon, 27 Feb 2023 03:02:24 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q10-20020adfea0a000000b002c567b58e9asm6812875wrm.56.2023.02.27.03.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 03:02:24 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:02:09 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     aik@ozlabs.ru
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: Don't null dereference ops->destroy
Message-ID: <Y/yNsYDY9/7v14vG@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alexey Kardashevskiy,

The patch e8bc24270188: "KVM: Don't null dereference ops->destroy"
from Jun 1, 2022, leads to the following Smatch static checker
warning:

	arch/x86/kvm/../../../virt/kvm/kvm_main.c:4462 kvm_ioctl_create_device()
	warn: 'dev' was already freed.

arch/x86/kvm/../../../virt/kvm/kvm_main.c
    4449         if (ops->init)
    4450                 ops->init(dev);
    4451 
    4452         kvm_get_kvm(kvm);
    4453         ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
    4454         if (ret < 0) {
    4455                 kvm_put_kvm_no_destroy(kvm);
    4456                 mutex_lock(&kvm->lock);
    4457                 list_del(&dev->vm_node);
    4458                 if (ops->release)
    4459                         ops->release(dev);
                                              ^^^
The kvm_vfio_release() frees "dev".


    4460                 mutex_unlock(&kvm->lock);
    4461                 if (ops->destroy)
--> 4462                         ops->destroy(dev);
                                              ^^^
Use after free.

    4463                 return ret;
    4464         }
    4465 
    4466         cd->fd = ret;
    4467         return 0;
    4468 }

regards,
dan carpenter
