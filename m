Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4B4752C19
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 23:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjGMV3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 17:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjGMV3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 17:29:33 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1558B2D54;
        Thu, 13 Jul 2023 14:29:33 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-666edfc50deso769971b3a.0;
        Thu, 13 Jul 2023 14:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689283772; x=1691875772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QZbqwIn1PJ59IrTuVwf2qj/fhd91K+wS0JAfgMP33XM=;
        b=SdwBFntDYC7hcRObyVmR3d7Ge+a/c1evfS4pZv5apLud4eCIuJC4h61ygsYvpWs6cr
         I5HhxtJq5zooePl9j9nbllSevAVif3fDjrQkJxsMpoQgyiIAN/RrbGPL8ghmd5NTW0qW
         eK35ylZtBmrlbb3GiPwTP1n8+oqL86QHpoBG8XHC/SdjNnaRR+0TJeMc+zWcrO2jJ7Xt
         LFx7kmC9CgQi1SZRnWZHfhl/2Uv5lOmJPAP+/6NfOSYvxjorTvHwZE2a4slGsIItucDP
         0OZosOR7ekzhiJu42lXJ09TyX3G8BE4JWW4CRnBlpYldfve+qyAwli5qp2Xh2OLr/HGL
         KLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689283772; x=1691875772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZbqwIn1PJ59IrTuVwf2qj/fhd91K+wS0JAfgMP33XM=;
        b=AInF2JtdZXkjUnUKuiWiWAm9c4q/1zRFMrXBdGoHOZ6UZqhBu6HjpXmZ9K5pfis+uo
         Wt9pDL5/hrr/FNaspfDTDjn0hH19edcqM1EAPzmnCQkgFPk9R6P0RnX7n/jR9Gz1vjuc
         Wlnw3BXtV8VrfqOICcK8lyn3ImBNzhsztpI6L5eRx6bS5soGU3u1v4UNCDQs5zkULhTg
         iF99TZl40x8ibBf2Dbum2oLQtcmoHycypkYPQvEbA0I2v5ZygLoFGq3uoKIwMjvVCyee
         WtuNQQpgHGBfmEq//Va/gP234Lf230+KVhOPl7hJfsVyorMzftFuxxnHIShG8JdENpGj
         rvfA==
X-Gm-Message-State: ABy/qLZVsTxOGyXsQHQi4jIyzlIdUoV2JIt/yJPnnnFPC2iuz84DRPSC
        pZu+hJoeYYjrU1pzNH2ThrQ=
X-Google-Smtp-Source: APBJJlEu7z2Ae8ceg9LubQiYcBXu9OlOpsbveT3b16see0k2oP0VucT1DPKoc+uvvsRSH2FnbIh0tQ==
X-Received: by 2002:a05:6a00:392a:b0:67a:52a7:b278 with SMTP id fh42-20020a056a00392a00b0067a52a7b278mr1216885pfb.9.1689283772432;
        Thu, 13 Jul 2023 14:29:32 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:75e2:8bbb:e3b8:95b3])
        by smtp.gmail.com with ESMTPSA id u14-20020a63b54e000000b0055acfd94c20sm6088999pgo.35.2023.07.13.14.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 14:29:32 -0700 (PDT)
Date:   Thu, 13 Jul 2023 14:29:29 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <ZLBsuZCb8xkOc1tg@google.com>
References: <ZKyEL/4pFicxMQvg@google.com>
 <20230713124811.1b3c1586.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713124811.1b3c1586.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Thu, Jul 13, 2023 at 12:48:11PM -0600, Alex Williamson wrote:
> On Mon, 10 Jul 2023 15:20:31 -0700
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
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
> 
> 
> I'm not sure this hasn't been an issue since it was originally
> introduced in 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when
> group add/delete").
> 
> The change added by the blamed ba70a89f3c2a in this respect is simply
> that we get the file pointer from the mutex protected object, but that
> mutex protected object is also what maintains that the file pointer is
> valid.  The vfio_group implementation suffered the same issue, the
> delete path could put the group reference, which could theoretically
> cause a use after free of the vfio_group.

Yes, you are right, I'll update the patch with the correct "Fixes".

> 
> We could effectively restore the pre-ba70a89f3c2a behavior by replacing
> kvg->file with filp here, but that would still leave us vulnerable to
> the original issue.
> 
> Note also that kvm_vfio_update_coherency() takes the same mutex
> separately, I wonder if it wouldn't make more sense if it were moved
> under the caller's mutex to avoid bouncing the lock and unnecessarily
> taking it in the release path.  Thanks,

I think I will make it a separate patch.

Thanks.

-- 
Dmitry
