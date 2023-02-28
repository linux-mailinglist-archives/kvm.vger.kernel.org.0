Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481CD6A5EF6
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 19:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjB1Sq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 13:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjB1Sq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 13:46:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6992CFE3
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 10:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677609970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hks2t1Dz9i5s4NS46kF2yC/7sRBZA14ESYqi1LXB6L0=;
        b=FoARa4ox4EO9VMxgWbvT28ZJ4QGKdMosRT7MBMYuC4MdSfaKckSLtbb/ffPlpK2GHrki3x
        XldpoZorYJ+GmD+78dFD23+UrkuVx9jTp8I09i597O76K7y9vYniWo42lcmjiHwXevdtDi
        HNO4f6hpH6JljAGluHIt2xwIYQh5PyA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-53-W-woIHJUP5S409VVGj4teg-1; Tue, 28 Feb 2023 13:46:09 -0500
X-MC-Unique: W-woIHJUP5S409VVGj4teg-1
Received: by mail-il1-f198.google.com with SMTP id v18-20020a056e0213d200b00316ec11c950so6478896ilj.4
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 10:46:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hks2t1Dz9i5s4NS46kF2yC/7sRBZA14ESYqi1LXB6L0=;
        b=lCyt5RBcKcZhNiyW7dr7F1ex1/XrFLlRFjzABEDDPMMop/wrTcb32uChW3YLsYdUwU
         hVQOUCsmLiZSLIw2v4oT3QLSjkGaHnROes4G734YXJmG3laIuxH+XgkdoZkME/Za6MN8
         zAutGbnF5uGXKJ0nzAof3SvSYKl00qrmanJ1tIOZWOQWPO6Zzfgsid0qXsw7OpCVXejI
         t32I3+gB5j7kIgdGxb4unYjukGiFbPVNWjeE00nKgh6yaLz/FmsOErMWt8Io9P0m8ADy
         LJQ+i13ISK7SIOnqslApJe9nPsO+6XwWeHBr/dKINI95R2h/P0fGGZC4Slm4G145e4hg
         4QdA==
X-Gm-Message-State: AO0yUKVpgEKvrNsCM0Z0GZvjB/zEhZ+9oSLJqVM6YbgIj+pGXDKc95O6
        XE+Xe15/6BKGUSZnu+AI5HZb5uE0DDAulCQSIOBoCgBARNU3cLJ+lQfp7BMuKqLINyMJpDxL2rj
        M9mPQe7sdGuyT
X-Received: by 2002:a05:6e02:184f:b0:315:9937:600a with SMTP id b15-20020a056e02184f00b003159937600amr4394181ilv.26.1677609968129;
        Tue, 28 Feb 2023 10:46:08 -0800 (PST)
X-Google-Smtp-Source: AK7set8U1y5WFhis6co3VoQ0Omoi0PUchVx/aBYY0Z7SuhKAa/r9pd9po0jRwbhlDUMfCJcbrrSTCg==
X-Received: by 2002:a05:6e02:184f:b0:315:9937:600a with SMTP id b15-20020a056e02184f00b003159937600amr4394164ilv.26.1677609967824;
        Tue, 28 Feb 2023 10:46:07 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w19-20020a5d9cd3000000b00704608527d1sm3316040iow.37.2023.02.28.10.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 10:46:06 -0800 (PST)
Date:   Tue, 28 Feb 2023 11:46:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tasos Sahanidis <tasos@tasossah.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
Subject: Re: Bug: Completion-Wait loop timed out with vfio
Message-ID: <20230228114606.446e8db2.alex.williamson@redhat.com>
In-Reply-To: <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
        <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
        <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Feb 2023 09:33:53 +0200
Tasos Sahanidis <tasos@tasossah.com> wrote:

> Thank you very much for your quick response, Abhishek.
> 
> > 1. Set disable_idle_d3 module parameter set and check if this issue happens.  
> The issue does not happen with disable_idle_d3, which means I can at
> least now use newer kernels. All the following commands were ran
> *without* disable_idle_d3, so that the issue would occur.
> 
> > 2. Without starting the VM, check the status of following sysfs entries.  
> I assume by /sys/bus/pci/devices/<B:D:F>/power/power_state you meant
> /sys/bus/pci/devices/<B:D:F>/power_state, as the former doesn't exist.
> 
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power/runtime_status
> suspended
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power_state
> D3hot
> 
> > 3. After issue happens, run the above command again.  
> This is with the VM running and the errors in dmesg:
> 
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000\:06\:00.0/power_state
> D0


Can you do the same for the root port to the GPU, ex. use lspci -t to
find the parent root port.  Since the device doesn't seem to be
achieving D3cold (expected on a desktop system), the other significant
change of the identified commit is that the root port will also enter a
low power state.  Prior to that commit the device would enter D3hot, but
we never touched the root port.  Perhaps confirm the root port now
enters D3hot and compare lspci for the root port when using
disable_idle_d3 to that found when trying to use the device without
disable_idle_d3. Thanks,

Alex

