Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1250A036
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiDUNER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 09:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiDUNEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 09:04:16 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7596E33342;
        Thu, 21 Apr 2022 06:01:26 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id b189so3439038qkf.11;
        Thu, 21 Apr 2022 06:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mQCnCf+K1M125bkYqePGyRgfEVPHEBFfxFtvjhJFkdM=;
        b=CvLfCvp2RlnXmb8Ch8UStJY+Vdi4Se+tSAFtvLIozHN7P6YwKXGs6opnQhgfIEHwS2
         VM1uBwviA1G8vFR6ELNSNdnxH6Bv8N9Rns6Ma8JJCDNfsdeWuucmWxiox42fgWevvSIe
         AaJycjaS2jXEGlq/zyqCqIr3sJAKyQofhP2XHgtrCpK2fQq2tkMJogd3V3Tw1dTJrGdx
         MKRiBGTB2SRjsTXwb1dTtpRHoQitYw70IjlkU1RTqU9MtAgYdBaqJIirQdxQlAX8rfh7
         b5ZAB3ntSfIGqbRsCTWvscP+GgAIlY2CTtvNe8aG2MV2CQO+6hwUSQvIRZ/x9VgcmcHJ
         5PWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mQCnCf+K1M125bkYqePGyRgfEVPHEBFfxFtvjhJFkdM=;
        b=odMGJmV72YuA2oo+1+9v2ApvxD3wlMypT+NaDUS2LE6tAImQDELsfl8kX2XFLFDl0O
         uO7q5M389Y6cMUzDZzx4F7Wgf3cwOZWQvZHVAI5KKHIK6+2IWSrJCjPlA2b8o/meAeZA
         J1rfPg3FRRWv3Gtb9zrdLm+I8okF3WTt4fWUxnHIdjs5GDTRNrHo9RHQ5zdazb/qWhRA
         LzNhR9+L0/BCKxQgHSTkeNs7aZSaMqrabVKz615YBIREldEWjgqDaV5Og0daUalcZe2d
         bUNDfcVRT/lR41GmH229y7Ew4Hr2kC7KqiyZ1daM2SCxawn9uFsjTNXDKYZJ/yLu4cX0
         5y3A==
X-Gm-Message-State: AOAM533YgZ8X+6MRWyWWrsjzonvYdAPV/xkhUmu9LAnG5saaYwVmjtWM
        MHUjPpQ8SnIeRXU3E7xoLQ0=
X-Google-Smtp-Source: ABdhPJxzqG8C1m/qSVTQIEwcpd6q8Y0psH+4g3rTkgMlOIbP5fXBF2c+6tJlNST0HG9ZqJK3Q28c2A==
X-Received: by 2002:a37:aa48:0:b0:69e:d351:9683 with SMTP id t69-20020a37aa48000000b0069ed3519683mr5033435qke.539.1650546085430;
        Thu, 21 Apr 2022 06:01:25 -0700 (PDT)
Received: from localhost ([2601:c4:c432:7a1:dbb0:23b:8a79:595c])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm3645548qtx.58.2022.04.21.06.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:01:24 -0700 (PDT)
Date:   Thu, 21 Apr 2022 06:01:23 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: s390: replace bitmap_copy with
 bitmap_{from,to}_arr64 where appropriate
Message-ID: <YmFVo8gR8UQ9uu2e@yury-laptop>
References: <20220420222530.910125-1-yury.norov@gmail.com>
 <20220420222530.910125-4-yury.norov@gmail.com>
 <f2edeb89-54be-6100-9464-c99fdc4bd439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2edeb89-54be-6100-9464-c99fdc4bd439@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 09:24:20AM +0200, David Hildenbrand wrote:
> On 21.04.22 00:25, Yury Norov wrote:
> > Copying bitmaps from/to 64-bit arrays with bitmap_copy is not safe
> > in general case. Use designated functions instead.
> > 
> 
> Just so I understand correctly: there is no BUG, it's just cleaner to do
> it that way, correct?

Yes. there's no bug, but the pattern is considered bad.

https://lore.kernel.org/all/YiCWNdWd+AsLbDkp@smile.fi.intel.com/T/#m9080cbb8a8235d7d4b7e38292cee8e4903f9afe4q
 
> IIUC, bitmap_to_arr64() translates to bitmap_copy_clear_tail() on s390x.

Yes.
 
> As the passed length is always 1024 (KVM_S390_VM_CPU_FEAT_NR_BITS), we
> essentially end up with bitmap_copy() again.
> 
> 
> Looks cleaner to me

Thanks.

> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> 
> -- 
> Thanks,
> 
> David / dhildenb
