Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09296C6707
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjCWLpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWLpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EB91E289
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679571890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMD7H2kp0eSKoSxfq1PhoExu63Twb+QYc8ILXExIOt0=;
        b=grDe7Cp3QYh2siS+17gPPxYrgmSslJ30XT5aCo6qwbsT7IAoI/WBl7k5z6fjWaP1aOKK1T
        R/fFFY2RAICkTLHqhCAK+R3jaROrXL6Kh0ibcCSueC9hfcZ7j3tMD1r2cWsG8kBaEYLjaZ
        etmtNnVwtMYo1gaeCL0tda7lyVgkAOY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-ehb7uUt3PkWZE3q6vY3HBw-1; Thu, 23 Mar 2023 07:44:49 -0400
X-MC-Unique: ehb7uUt3PkWZE3q6vY3HBw-1
Received: by mail-ed1-f69.google.com with SMTP id t26-20020a50d71a000000b005003c5087caso30232928edi.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679571887;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BMD7H2kp0eSKoSxfq1PhoExu63Twb+QYc8ILXExIOt0=;
        b=B7ryxhG1sTmNGMpFrwAM856gF7CG19HUqnsY1T9lQB0wVbAGuQnB8fn27bchA6TcPa
         Btr90MshLAdLniEoPS+b2pS/o1hCtcGPjEeazwZDKpAj8Cr4VfMth9q88YAJchX/XACD
         PsQoeV1wTYDlh3sFqUAKIx5jgy/edEERDxVqIZCQsg/nZ+MgJqkH0j+9zcRjVzDWDbLD
         m4Ea1r3++2SK4M95i8t0qWcj/+gIRtK1HcQbWs5ddm3q+t22Pn5n2vqsbwLRydmLu/Tu
         URmQTxFWfFfpdBWgwjdlhWlcJdASfBv0Ae2aR92HtPH1XgUgWsdjnk0dQZ4ZGyewkQ7b
         n8Ug==
X-Gm-Message-State: AO0yUKWt7yw3OwB5DFbX45VSLSJNxrCV8xY0CLFpey0bjeRmRc1Dz582
        VleXdKVrPoBOf3r8zmxjnTZS4lqd/c/V037Ytk8yG/PZKygvliUfFNs4DPqPBUB8/vmkOEtOctQ
        02iOYugjWFUVKFoZPNDR8
X-Received: by 2002:a05:6402:2920:b0:500:2cc6:36d5 with SMTP id ee32-20020a056402292000b005002cc636d5mr5727070edb.8.1679571887368;
        Thu, 23 Mar 2023 04:44:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set8uU0070bRsyBjQjpSi08yAtED4W63tVlm60HDGu5Op0XDHfVKzvp9t3BqE4omUQn4yYVC+6A==
X-Received: by 2002:a05:6402:2920:b0:500:2cc6:36d5 with SMTP id ee32-20020a056402292000b005002cc636d5mr5727043edb.8.1679571887109;
        Thu, 23 Mar 2023 04:44:47 -0700 (PDT)
Received: from redhat.com ([2.52.143.71])
        by smtp.gmail.com with ESMTPSA id w3-20020a50c443000000b004ac54d4da22sm9165128edf.71.2023.03.23.04.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:44:46 -0700 (PDT)
Date:   Thu, 23 Mar 2023 07:44:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
Message-ID: <20230323074427-mutt-send-email-mst@kernel.org>
References: <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
 <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
 <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 10:50:06AM +0100, Stefano Garzarella wrote:
> On Thu, Mar 23, 2023 at 11:42:07AM +0800, Jason Wang wrote:
> > On Tue, Mar 21, 2023 at 11:48 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > 
> > > The new "use_va" module parameter (default: true) is used in
> > > vdpa_alloc_device() to inform the vDPA framework that the device
> > > supports VA.
> > > 
> > > vringh is initialized to use VA only when "use_va" is true and the
> > > user's mm has been bound. So, only when the bus supports user VA
> > > (e.g. vhost-vdpa).
> > > 
> > > vdpasim_mm_work_fn work is used to serialize the binding to a new
> > > address space when the .bind_mm callback is invoked, and unbinding
> > > when the .unbind_mm callback is invoked.
> > > 
> > > Call mmget_not_zero()/kthread_use_mm() inside the worker function
> > > to pin the address space only as long as needed, following the
> > > documentation of mmget() in include/linux/sched/mm.h:
> > > 
> > >   * Never use this function to pin this address space for an
> > >   * unbounded/indefinite amount of time.
> > 
> > I wonder if everything would be simplified if we just allow the parent
> > to advertise whether or not it requires the address space.
> > 
> > Then when vhost-vDPA probes the device it can simply advertise
> > use_work as true so vhost core can use get_task_mm() in this case?
> 
> IIUC set user_worker to true, it also creates the kthread in the vhost
> core (but we can add another variable to avoid this).
> 
> My biggest concern is the comment in include/linux/sched/mm.h.
> get_task_mm() uses mmget(), but in the documentation they advise against
> pinning the address space indefinitely, so I preferred in keeping
> mmgrab() in the vhost core, then call mmget_not_zero() in the worker
> only when it is running.
> 
> In the future maybe mm will be used differently from parent if somehow
> it is supported by iommu, so I would leave it to the parent to handle
> this.
> 
> Thanks,
> Stefano

I think iommufd is supposed to handle all this detail, yes.

