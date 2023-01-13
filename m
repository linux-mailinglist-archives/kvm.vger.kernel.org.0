Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A156688CA
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjAMA5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 19:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240117AbjAMA5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 19:57:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B526D1EAC7
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 16:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673571418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XG7oCthi1cz9qA5sCXs+Yfwmmh8peH0gCPI3GPwykJs=;
        b=YwckGf1PUDaNVmEmlcvR31FLXZulJ8NRVEq7Q0w2OiaG/w6jDTSRC73upzHeYDceeuFI0T
        u23Cg0wN+WM8rH7Jlz5v2hRygXkGi1+NBFqzcY7lceUS6R1+Chzz6dvh92buk87lSN0NQT
        Sz9UkCOl4hRacFKvtfDHZVaqLjFrzwQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-auF583kxPmWA1cOs1_16Eg-1; Thu, 12 Jan 2023 19:56:52 -0500
X-MC-Unique: auF583kxPmWA1cOs1_16Eg-1
Received: by mail-il1-f200.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so14896113iln.21
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 16:56:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XG7oCthi1cz9qA5sCXs+Yfwmmh8peH0gCPI3GPwykJs=;
        b=shHSDYTv0EVUxCPI+dfbk7vCB8Bj+QWNj65jNrt4r0pco9J1Y3RSSwAfWcYz+k2Zcq
         kbTTeBAH+ouN+6JmahsQI/EuCKtZM+Fy4Yqn3+ML3FVihqy7QMOKKhywvlwpKMBd+Zk5
         4X3hVf8yzYaI8PvkL3QLTM7m+ptq0kuTYc+trckYiOrmkNWpzHb3hTCgEGLCBxCjGK24
         PYlsnW5BvGydXYCtRzO+S9UG1tn5mE2srMKYNWGZMIPJmmm1sDCuSp8cn/HfMiYLdRDv
         WyPxkV0Z0CueUhbdT1bE06hAYGO+OAnK1MT0iOIGm/98qTl0sP0gTmDkz8EbUERerKZZ
         dADA==
X-Gm-Message-State: AFqh2kre/cXRvcljAq4iNpePkClMAfq04d22Trl9/I25nH/hsLX1lObA
        9OY4cCaV+BgN6So/7vuHAljWJi2ORCe+IW75z+49ZCULiNUwEpFxqfzE5fuyJjkhAYoC45wDi3M
        AvGij64YngQNS
X-Received: by 2002:a5d:8c88:0:b0:6f1:f493:7240 with SMTP id g8-20020a5d8c88000000b006f1f4937240mr6277485ion.3.1673571411476;
        Thu, 12 Jan 2023 16:56:51 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvsA3h8dnBWYocee5XN2BqUQKDNeUrvNWtFiPzDqbJBlxeKo+IUAua2OcaVeTDIIuJpIjdmug==
X-Received: by 2002:a5d:8c88:0:b0:6f1:f493:7240 with SMTP id g8-20020a5d8c88000000b006f1f4937240mr6277474ion.3.1673571411216;
        Thu, 12 Jan 2023 16:56:51 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e18-20020a022112000000b0039e048ad8e7sm5624918jaa.59.2023.01.12.16.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:56:50 -0800 (PST)
Date:   Thu, 12 Jan 2023 17:56:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <20230112175648.158dca5f.alex.williamson@redhat.com>
In-Reply-To: <Y8CX8YwT/T9v4U/D@google.com>
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
        <20230112140517.6db5b346.alex.williamson@redhat.com>
        <bce7912a-f904-b5a3-d234-c3e2c42d9e54@linux.ibm.com>
        <Y8CX8YwT/T9v4U/D@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 23:29:53 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Jan 12, 2023, Matthew Rosato wrote:
> > On 1/12/23 4:05 PM, Alex Williamson wrote:  
> > > On Thu, 12 Jan 2023 15:38:44 -0500
> > > Matthew Rosato <mjrosato@linux.ibm.com> wrote:  
> > >> @@ -344,6 +345,35 @@ static bool vfio_assert_device_open(struct vfio_device *device)
> > >>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
> > >>  }
> > >>  
> > >> +static bool vfio_kvm_get_kvm_safe(struct kvm *kvm)
> > >> +{
> > >> +	bool (*fn)(struct kvm *kvm);
> > >> +	bool ret;
> > >> +
> > >> +	fn = symbol_get(kvm_get_kvm_safe);
> > >> +	if (WARN_ON(!fn))  
> 
> In a related vein to Alex's comments about error handling, this should not WARN.
> WARNing during vfio_kvm_put_kvm() makes sense, but the "get" is somewhat blind.

It's not exactly blind though, we wouldn't have a kvm pointer if the
kvm-vfio device hadn't stuffed one into the group.  We only call into
here if we have a non-NULL pointer, so it wouldn't simply be that the
kvm module isn't available for this to fire, but more that we have an
API change to make the symbol no longer exist.  A WARN for that doesn't
seem unreasonable.  Thanks,

Alex

> > >> +		return false;
> > >> +
> > >> +	ret = fn(kvm);
> > >> +
> > >> +	symbol_put(kvm_get_kvm_safe);
> > >> +
> > >> +	return ret;
> > >> +}
> > >> +
> > >> +static void vfio_kvm_put_kvm(struct kvm *kvm)
> > >> +{
> > >> +	void (*fn)(struct kvm *kvm);
> > >> +
> > >> +	fn = symbol_get(kvm_put_kvm);
> > >> +	if (WARN_ON(!fn))
> > >> +		return;
> > >> +
> > >> +	fn(kvm);
> > >> +
> > >> +	symbol_put(kvm_put_kvm);
> > >> +}  
> 

