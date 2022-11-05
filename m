Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BCD61DF37
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 23:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKEW4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKEW4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 18:56:45 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E0BCBF
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 15:56:45 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id e123so5414975ybh.11
        for <kvm@vger.kernel.org>; Sat, 05 Nov 2022 15:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XLPep18beqQp+f+pVmvgsMS1ktGu/NnvWAUajeqlMnM=;
        b=hwoiuD39iMJsq8iVrri7qkgAgJS1MHKUr/yx33+1BWgsNw7A2fu4GFzHDVCZWxaSQj
         lBZdN5aTmuYEPQNc+DmGDLvNfwAc7Mj6CVIjAljx9h9fUgO5fUMZB+FvBDfXh69idrtu
         zDMFLKbVVetyK3g5v30axgb3MdgypSl4OwHNp45Qm9260fE3AVOmj9Ce9QeoE9kVXy8+
         etKY/1AO4h+O4UkeLR7hK1r3/AwPa5OJOdS5LxTbek2uqrZbMY6Hlu9OMG3tr+krph4i
         YKM9qrz7bGK8h1fGGLAAHqsyhqTfokMLp45tzoSo2Nwoe4G3B0JB8SfMBV7teCUgNOvO
         ndYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLPep18beqQp+f+pVmvgsMS1ktGu/NnvWAUajeqlMnM=;
        b=AwIceBhCZ1rbt6CCOdi4jmw048BMjqKZt3u/xPcQPN/eYpUV0m7OcMK6O7UIbDJDx8
         FSki1bsqntJqwGbE4G3kuhwg/25upCgcs93B6CYTSBvPUZprI5jZ/j91Hkm8cNPTceLa
         9DKQjSy1VzMHZWg3O5xhkOQd7EwZERTCZ4nOoxvIe6YCwJM5xrN9aNubeP0N4Qw1Gqf8
         SzxzclJD5N7ujdrID6gUCST9iqD0LbF32IkdfXtGCKB4ey3A+DE85N3G0DN/34kjTbi1
         LyUZmXNsMXeyvFNKTKLO9OSMG9K6OpOjdZf1JCNEOyVrF35+lEOZnNI9q+1VCu+DeIMJ
         Kd1g==
X-Gm-Message-State: ACrzQf1KgHwkkmh2goaPyDHfBuJPJ7T1TLPF+gacdGvpvJeONhd949Al
        N+xPTv0HYNsZ01RXg/WytunClag9vuNXO40FvZ4=
X-Google-Smtp-Source: AMsMyM7ui9p4sk6GQFCjTKR5o4OD6rgYdGLHFlDNT9OlME4cs3scdCQt6M6EmqZlV+GIdCIkkaGzoRSOZR/y8F+27Jg=
X-Received: by 2002:a25:9986:0:b0:6a7:29ef:133c with SMTP id
 p6-20020a259986000000b006a729ef133cmr42744332ybo.479.1667689004484; Sat, 05
 Nov 2022 15:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221104195727.4629-1-ajderossi@gmail.com> <20221104195727.4629-3-ajderossi@gmail.com>
 <20221104145918.265aa409.alex.williamson@redhat.com>
In-Reply-To: <20221104145918.265aa409.alex.williamson@redhat.com>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Sat, 5 Nov 2022 22:56:33 +0000
Message-ID: <CAKkLME0G53SecdHhpQ3=TWmQ8P9a-OmB-o=Wf6=JX8YBFZkSew@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] vfio: Add an open counter to vfio_device_set
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 4, 2022 at 8:59 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
> Like it seems maybe you're going for by your more recent comment, I was
> thinking an interface rather than tracking a new field on the device
> set.

Thanks for the feedback. I sent an updated series with this change.

v5: https://lore.kernel.org/kvm/20221105224458.8180-1-ajderossi@gmail.com/

Anthony
