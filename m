Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DF566895F
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 03:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbjAMCFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 21:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjAMCFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 21:05:20 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69522621B0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 18:05:19 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id v23so17125215plo.1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 18:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=imvHeHfSB76NKxqNg7yS5d0bnfZ/68ukGArZSjXXLbU=;
        b=gfL4hh/PAfTWoPxrgPNOjugdRQT6/WV65DgBrSnpV5ljD3nsqQZO//RzEo7T4oLQqx
         c4Q0mI405eGfoj8LuS0wI2sQdlqaeNnCgTAsK9ojs6iEaCaHua6vjwZaKDc+OIsKFBm9
         w5TSAgwjkuR9lTRDlbRtIxIeYn77XVQL36m+j6TNN1IPYFjq7eERVWltVZh8xI+AuS6x
         Ebb8o0T31ad1vrZqKXtO581o4RiY7HqEeVSqH6w/J7bYR6aLkGoMN3t0S7fDWdcn2JdL
         sRmydefKjnfHqNzBKp647Hzmqgin/vcHPGOfInZ9RvBNC86xV/kMej7ry3nwiPeZw8Hm
         rb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imvHeHfSB76NKxqNg7yS5d0bnfZ/68ukGArZSjXXLbU=;
        b=5wLOcQ5XXfrgUN4jFT04pVdI+xvl3vpyHfcDmETUl3aZBq5VhxS40vtZPcXeyCVHvh
         VTWaTCSgj7FLjgHV6jUvji+XpxAism+VD7sBrpWXPnABAH9ANQgG478o2o6/OWU39u7d
         6wlre7d6Pu0s+b0lfXsPW77U/GilsPdke9fmbketZdzq1dDmem2GbvlwcURRR4/nFLgn
         G9NBscjVeQm3flKlunW7Qw7QXY+zla9ij+XiSLoKZt4suIpzuwwtzn4SaSxW0rmwn95D
         JbHgyyMjVpwhoNDbVIFq9btPebpF3WdEWTiOSruk478MKuqCutoAcnjfl/D0MWKJF5IE
         EDYQ==
X-Gm-Message-State: AFqh2kp69UQfPYN/vzr2+wwKlO74xoJimZ/oHZv8PaWyzv2uN/8+GGX6
        8a6HbJoV1A/QBFyub33DOP8+cw==
X-Google-Smtp-Source: AMrXdXt5UhWv4+gCCOg9vsmsrXhYZBecqcoz5x+/Oa5eI3PEct7oPHliTdSgvAqHMlV57ui5SVshog==
X-Received: by 2002:a17:902:b10e:b0:191:4367:7fde with SMTP id q14-20020a170902b10e00b0019143677fdemr994708plr.0.1673575518755;
        Thu, 12 Jan 2023 18:05:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm12835625plr.175.2023.01.12.18.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 18:05:18 -0800 (PST)
Date:   Fri, 13 Jan 2023 02:05:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, pbonzini@redhat.com,
        jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8C8WpkjgFelldTQ@google.com>
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
 <20230112140517.6db5b346.alex.williamson@redhat.com>
 <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
 <Y8CX8YwT/T9v4U/D@google.com>
 <20230112175648.158dca5f.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112175648.158dca5f.alex.williamson@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023, Alex Williamson wrote:
> On Thu, 12 Jan 2023 23:29:53 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Thu, Jan 12, 2023, Matthew Rosato wrote:
> > > On 1/12/23 4:05 PM, Alex Williamson wrote:  
> > > > On Thu, 12 Jan 2023 15:38:44 -0500
> > > > Matthew Rosato <mjrosato@linux.ibm.com> wrote:  
> > > >> @@ -344,6 +345,35 @@ static bool vfio_assert_device_open(struct vfio_device *device)
> > > >>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
> > > >>  }
> > > >>  
> > > >> +static bool vfio_kvm_get_kvm_safe(struct kvm *kvm)
> > > >> +{
> > > >> +	bool (*fn)(struct kvm *kvm);
> > > >> +	bool ret;
> > > >> +
> > > >> +	fn = symbol_get(kvm_get_kvm_safe);
> > > >> +	if (WARN_ON(!fn))  
> > 
> > In a related vein to Alex's comments about error handling, this should not WARN.
> > WARNing during vfio_kvm_put_kvm() makes sense, but the "get" is somewhat blind.
> 
> It's not exactly blind though, we wouldn't have a kvm pointer if the
> kvm-vfio device hadn't stuffed one into the group.  We only call into
> here if we have a non-NULL pointer, so it wouldn't simply be that the
> kvm module isn't available for this to fire, but more that we have an
> API change to make the symbol no longer exist.  A WARN for that doesn't
> seem unreasonable.  Thanks,

Hmm, I was thinking that it might be possible for kvm.ko to be on its way out,
but barring use of force module unload, which breaks things left and right, kvm.ko
can only be going if all VMs have been destroyed.

Agreed, WARN is fine.
