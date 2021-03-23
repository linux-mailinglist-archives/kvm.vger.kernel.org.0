Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC31A345EA4
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 13:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhCWM4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 08:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhCWM4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 08:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3619619B8;
        Tue, 23 Mar 2021 12:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616504168;
        bh=7s1M3IsLZtGNlNk01+JyIT7SNm9jTdPqx5b5zByfRyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tqiQf2egd3FRlPC2gMcFNgwmVFU3j04Mp9W/SwOUfQEhucaofggWeqoSZp0n6DqYZ
         +LtxhrvTSCsggPocaQmVxpynR6Y7NV9YgJ0BgXkICEr8DRsmwjHwqXP09gL80dqcvY
         eJYg+ci/qtpPxMSC/jhvbWq/4QqFr3hBu7D9VRe8=
Date:   Tue, 23 Mar 2021 13:56:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Graf <graf@amazon.com>
Cc:     Adrian Catangiu <acatan@amazon.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        rdunlap@infradead.org, arnd@arndb.de, ebiederm@xmission.com,
        rppt@kernel.org, 0x7f454c46@gmail.com, borntraeger@de.ibm.com,
        Jason@zx2c4.com, jannh@google.com, w@1wt.eu, colmmacc@amazon.com,
        luto@kernel.org, tytso@mit.edu, ebiggers@kernel.org,
        dwmw@amazon.co.uk, bonzini@gnu.org, sblbir@amazon.com,
        raduweis@amazon.com, corbet@lwn.net, mst@redhat.com,
        mhocko@kernel.org, rafael@kernel.org, pavel@ucw.cz,
        mpe@ellerman.id.au, areber@redhat.com, ovzxemul@gmail.com,
        avagin@gmail.com, ptikhomirov@virtuozzo.com, gil@azul.com,
        asmehra@redhat.com, dgunigun@redhat.com, vijaysun@ca.ibm.com,
        oridgar@gmail.com, ghammer@redhat.com
Subject: Re: [PATCH v8] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <YFnlZQZOasOwxUDn@kroah.com>
References: <1615213083-29869-1-git-send-email-acatan@amazon.com>
 <YEY2b1QU5RxozL0r@kroah.com>
 <a61c976f-b362-bb60-50a5-04073360e702@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a61c976f-b362-bb60-50a5-04073360e702@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 05:03:58PM +0100, Alexander Graf wrote:
> 
> 
> On 08.03.21 15:36, Greg KH wrote:
> > 
> > On Mon, Mar 08, 2021 at 04:18:03PM +0200, Adrian Catangiu wrote:
> > > +static struct miscdevice sysgenid_misc = {
> > > +     .minor = MISC_DYNAMIC_MINOR,
> > > +     .name = "sysgenid",
> > > +     .fops = &fops,
> > > +};
> > 
> > Much cleaner, but:
> > 
> > > +static int __init sysgenid_init(void)
> > > +{
> > > +     int ret;
> > > +
> > > +     sysgenid_data.map_buf = get_zeroed_page(GFP_KERNEL);
> > > +     if (!sysgenid_data.map_buf)
> > > +             return -ENOMEM;
> > > +
> > > +     atomic_set(&sysgenid_data.generation_counter, 0);
> > > +     atomic_set(&sysgenid_data.outdated_watchers, 0);
> > > +     init_waitqueue_head(&sysgenid_data.read_waitq);
> > > +     init_waitqueue_head(&sysgenid_data.outdated_waitq);
> > > +     spin_lock_init(&sysgenid_data.lock);
> > > +
> > > +     ret = misc_register(&sysgenid_misc);
> > > +     if (ret < 0) {
> > > +             pr_err("misc_register() failed for sysgenid\n");
> > > +             goto err;
> > > +     }
> > > +
> > > +     return 0;
> > > +
> > > +err:
> > > +     free_pages(sysgenid_data.map_buf, 0);
> > > +     sysgenid_data.map_buf = 0;
> > > +
> > > +     return ret;
> > > +}
> > > +
> > > +static void __exit sysgenid_exit(void)
> > > +{
> > > +     misc_deregister(&sysgenid_misc);
> > > +     free_pages(sysgenid_data.map_buf, 0);
> > > +     sysgenid_data.map_buf = 0;
> > > +}
> > > +
> > > +module_init(sysgenid_init);
> > > +module_exit(sysgenid_exit);
> > 
> > So you do this for any bit of hardware that happens to be out there?
> > Will that really work?  You do not have any hwid to trigger off of to
> > know that this is a valid device you can handle?
> 
> The interface is already useful in a pure container context where the
> generation change request is triggered by software.
> 
> And yes, there are hardware triggers, but Michael was quite unhappy about
> potential races between VMGenID change and SysGenID change and thus wanted
> to ideally separate the interfaces. So we went ahead and isolated the
> SysGenID one, as it's already useful as is.
> 
> Hardware drivers to inject change events into SysGenID can then follow
> later, for all different hardware platforms. But SysGenID as in this patch
> is a completely hardware agnostic concept.

Ok, this is going to play havoc with fuzzers and other "automated
testers", should be fun to watch!  :)

Let's queue this up and see what happens...

thanks,

greg k-h
