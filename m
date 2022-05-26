Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB0D53525F
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344474AbiEZRBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348205AbiEZRAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:00:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CF0BAF31D
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653584453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ScB3NEe+9Ln+Tkzu5WY+q2tuSZNjpx/VGcUZnRc1NIc=;
        b=YocOrB2GdDz/y+0YpI/cUdcTev5Z8+aGpW+OSUhM27znmZVY7wdliCEQpVndJGInWfjT0G
        Upn33J7wNxD6AAGyI+ACWgMFB6nj1cadRORUsu0Pe/84QmU5BspWxQQvZ9NN+mqK8ZDIyf
        LHOWh572zZ3gyTb8sun2ds+L4lP9m4w=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-_39PRSqcP62eZnByhV9-XA-1; Thu, 26 May 2022 13:00:44 -0400
X-MC-Unique: _39PRSqcP62eZnByhV9-XA-1
Received: by mail-qk1-f198.google.com with SMTP id o18-20020a05620a2a1200b006a0cc3d8463so1941151qkp.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ScB3NEe+9Ln+Tkzu5WY+q2tuSZNjpx/VGcUZnRc1NIc=;
        b=3JCoTbtCcdXnhMyR4fl8s8Dd/ZRKIwUgzVSpKT606JNIkGnitxUeMA0VOaiN5JhRhs
         gucipSFN3WCu7WjDdNGzsjW2Rbj8FwiZKxlW/XJAbUQIdg0eoQ6uBFGjb7F+rC78sTlj
         XpDrVNSdi5yKxwDd5btWcWZGTsjyDaPiuMZVqHoYr0neQSXojo8KNAIa9OpSXMwHWhEg
         RHKdTVQDyxZt7tUyDPpk0DkSQcLW8jELwNdMfhCcjMICSra8bf/bdVCIJuaeKGp6f06g
         rmOt7B3mauC/Lzj9cG/wprN9V5rhDJ49jQLdgXQkwV9VP22e5933N6SbXZz8EAfV1Wc5
         /h2g==
X-Gm-Message-State: AOAM532imA057vPa2CjY07hrJMLjXyGbZmv/CzX0OrOWSGwhw/pw01lm
        Ik62JXT3vHxwJL4MzPogDLkFYxL+mlWqoqaG8m60OgGU+VkPHg+T/gAtrFD7PypDIRDZCBDfbNk
        WeLn+m/fNZpXY6z+XmmOJalBnplGf
X-Received: by 2002:a05:6214:20ec:b0:461:dc16:163d with SMTP id 12-20020a05621420ec00b00461dc16163dmr31140856qvk.40.1653584443709;
        Thu, 26 May 2022 10:00:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNuwW+OIVP4vntmIePKpEQwZ/yx3kjSX7hxVx5Ym3uDYMxGP5HP0I/N0p1Ox7imcOdUzdR7I8xd1xm+yiSe4Q=
X-Received: by 2002:a05:6214:20ec:b0:461:dc16:163d with SMTP id
 12-20020a05621420ec00b00461dc16163dmr31140772qvk.40.1653584443120; Thu, 26
 May 2022 10:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220525105922.2413991-1-eperezma@redhat.com> <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
 <20220526090706.maf645wayelb7mcp@sgarzare-redhat> <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
 <20220526132038.GF2168@kadam>
In-Reply-To: <20220526132038.GF2168@kadam>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 26 May 2022 19:00:06 +0200
Message-ID: <CAJaqyWe4311B6SK997eijEJyhwnAxkBUGJ_0iuDNd=wZSt0DmQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 3:21 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Thu, May 26, 2022 at 02:44:02PM +0200, Eugenio Perez Martin wrote:
> > > >> +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v) {
> > > >> +       struct vdpa_device *vdpa = v->vdpa;
> > > >> +       const struct vdpa_config_ops *ops = vdpa->config;
> > > >> +
> > > >> +       return ops->stop;
> > > >> [GD>>] Would it be better to explicitly return a bool to match the return type?
> > > >
> > > >I'm not sure about the kernel code style regarding that casting. Maybe
> > > >it's better to return !!ops->stop here. The macros likely and unlikely
> > > >do that.
> > >
> > > IIUC `ops->stop` is a function pointer, so what about
> > >
> > >      return ops->stop != NULL;
> > >
> >
> > I'm ok with any method proposed. Both three ways can be found in the
> > kernel so I think they are all valid (although the double negation is
> > from bool to integer in (0,1) set actually).
> >
> > Maybe Jason or Michael (as maintainers) can state the preferred method here.
>
> Always just do whatever the person who responded feels like because
> they're likely the person who cares the most.  ;)
>

This is interesting and I think it's good advice :). I'm fine with
whatever we chose, I just wanted to "break the tie" between the three.

> I don't think there are any static analysis tools which will complain
> about this.  Smatch will complain if you return a negative literal.

Maybe a negative literal is a bad code signal, yes.

> It feels like returning any literal that isn't 1 or 0 should trigger a
> warning...  I've written that and will check it out tonight.
>

I'm not sure this should be so strict, or "literal" does not include pointers?

As an experiment, can Smatch be used to count how many times a
returned pointer is converted to int / bool before returning vs not
converted?

I find Smatch interesting, especially when switching between projects
frequently. Does it support changing the code like clang-format? To
offload cognitive load to tools is usually good :).

Thanks!

> Really anything negative should trigger a warning.  See new Smatch stuff
> below.
>
> regards,
> dan carpenter
>
> ================ TEST CASE =========================
>
> int x;
> _Bool one(int *p)
> {
>         if (p)
>                 x = -2;
>         return x;
> }
> _Bool two(int *p)
> {
>         return -4;  // returning 2 triggers a warning now
> }
>
> =============== OUTPUT =============================
>
> test.c:10 one() warn: potential negative cast to bool 'x'
> test.c:14 two() warn: signedness bug returning '(-4)'
> test.c:14 two() warn: '(-4)' is not bool
>
> =============== CODE ===============================
>
> #include "smatch.h"
> #include "smatch_extra.h"
> #include "smatch_slist.h"
>
> static int my_id;
>
> static void match_literals(struct expression *ret_value)
> {
>         struct symbol *type;
>         sval_t sval;
>
>         type = cur_func_return_type();
>         if (!type || sval_type_max(type).value != 1)
>                 return;
>
>         if (!get_implied_value(ret_value, &sval))
>                 return;
>
>         if (sval.value == 0 || sval.value == 1)
>                 return;
>
>         sm_warning("'%s' is not bool", sval_to_str(sval));
> }
>
> static void match_any_negative(struct expression *ret_value)
> {
>         struct symbol *type;
>         struct sm_state *extra, *sm;
>         sval_t sval;
>         char *name;
>
>         type = cur_func_return_type();
>         if (!type || sval_type_max(type).value != 1)
>                 return;
>
>         extra = get_extra_sm_state(ret_value);
>         if (!extra)
>                 return;
>         FOR_EACH_PTR(extra->possible, sm) {
>                 if (estate_get_single_value(sm->state, &sval) &&
>                     sval_is_negative(sval)) {
>                         name = expr_to_str(ret_value);
>                         sm_warning("potential negative cast to bool '%s'", name);
>                         free_string(name);
>                         return;
>                 }
>         } END_FOR_EACH_PTR(sm);
> }
>
> void check_bool_return(int id)
> {
>         my_id = id;
>
>         add_hook(&match_literals, RETURN_HOOK);
>         add_hook(&match_any_negative, RETURN_HOOK);
> }
>

