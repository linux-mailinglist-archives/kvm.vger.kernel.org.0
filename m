Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E3A769C1A
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjGaQSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjGaQRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:17:54 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1315A7;
        Mon, 31 Jul 2023 09:17:53 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-686efa1804eso3316940b3a.3;
        Mon, 31 Jul 2023 09:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690820273; x=1691425073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yRI4uTVmkcfy2T7ALhUcJFpRNujxrfSpxIRskmxX1Hs=;
        b=OXz5Yjyxv8+pYj6Q6lK/kui71QV75eeVQJbDv+9fxjDonaaAYGbetVhIPHnqLavjs6
         PSVN6UFkfGZ7LqMh+amfcUZlX+xKzYd61p+IFx9qHqTHr1c4cOkhL2jYWZJm1xDUVslt
         PmVBGCutLKz+F+GHaxv1vbTOnWtNHmVXGJCGsprsrwXLyhGakwXPKzJfpG8BomIHll10
         /SZgGm/3oxO0dUGDwQ1zQtdjyhTU5E+Q5Ivv/1s1DDHp7u5QhgOCZplzoZa+5qdMmfbO
         6BGgFx+Rqlg6zjG1XnQ4ZZDa0RMXsODG2FXEUugcMQTjZ6GHZQ5mLNEsE/BOPKXsAvzc
         rIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690820273; x=1691425073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRI4uTVmkcfy2T7ALhUcJFpRNujxrfSpxIRskmxX1Hs=;
        b=YqYR5/WxoxMD2ss2UfaYDyZEALl5DeMXcTYqdGxrRW1MjLl8yy9Bg7yhzNrQ/CBl5B
         3laIGJ+X3b/W1ACDXdlAKvEQNX39uweZ6VxSzdwBRT8eLSwVFEbhIew0+zzWdd50P48D
         3YIi4HsvqhfEKzLf6Yo91pNEE5HyWTnpF2POSPAonZpckThhABcKg2ycYQM66q73arPp
         R4WOtYM+KV++GMx0QVWvviOWYPqPngfpOV3PVR5DZBFgBZfnw5QQyrLa+myv1Op/xTIB
         NrqBcEKs/VnAW1XTZhD6/0lLr9nD4zAZaEdIOOF2MwoHgaX5Yn82ahISkGt+M5/UcuLZ
         nXkA==
X-Gm-Message-State: ABy/qLY/YSf5BuYNTmknuEpiT/j5z47xy+muggaMXuRHlqEVXsluMhDf
        gtmXpWOfvamnzN3V91EsDOE=
X-Google-Smtp-Source: APBJJlHwIuyN+mET71//4TE77V2gS7sS2m43wu/Hq7365+nMjSla6ez9Virj3vExzZylYes/40Sjcw==
X-Received: by 2002:a05:6300:8003:b0:13b:9d80:673d with SMTP id an3-20020a056300800300b0013b9d80673dmr9746142pzc.48.1690820273060;
        Mon, 31 Jul 2023 09:17:53 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:6d25:c0f1:d8d5:201c])
        by smtp.gmail.com with ESMTPSA id r4-20020a62e404000000b0064d47cd116esm7726102pfh.161.2023.07.31.09.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 09:17:52 -0700 (PDT)
Date:   Mon, 31 Jul 2023 09:17:49 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <ZMferRPhhYjSno8B@google.com>
References: <ZKyEL/4pFicxMQvg@google.com>
 <2023073144-whimsical-liberty-4b4f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023073144-whimsical-liberty-4b4f@gregkh>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 02:02:59PM +0200, Greg KH wrote:
> On Mon, Jul 10, 2023 at 03:20:31PM -0700, Dmitry Torokhov wrote:
> > kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> > and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> > dropping kv->lock. If we race group addition and deletion calls, kvg
> > instance may get freed by the time we get around to calling
> > kvm_vfio_file_set_kvm().
> > 
> > Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> > of kv->lock. We already call it while holding the same lock when vfio
> > group is being deleted, so it should be safe here as well.
> > 
> > Fixes: ba70a89f3c2a ("vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  virt/kvm/vfio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> > index 9584eb57e0ed..cd46d7ef98d6 100644
> > --- a/virt/kvm/vfio.c
> > +++ b/virt/kvm/vfio.c
> > @@ -179,10 +179,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
> >  	list_add_tail(&kvg->node, &kv->group_list);
> >  
> >  	kvm_arch_start_assignment(dev->kvm);
> > +	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
> >  
> >  	mutex_unlock(&kv->lock);
> >  
> > -	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
> >  	kvm_vfio_update_coherency(dev);
> >  
> >  	return 0;
> > -- 
> > 2.41.0.255.g8b1d071c50-goog
> 
> What ever happened to this change?  Did it end up in a KVM tree
> somewhere?

It was posted as:

https://lore.kernel.org/all/20230714224538.404793-1-dmitry.torokhov@gmail.com/

and I believe Alex Williamson is planning to take it through VFIO tree.

Thanks.

-- 
Dmitry
