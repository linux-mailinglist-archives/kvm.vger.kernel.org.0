Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94CD3310F8
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCHOhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCHOgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 09:36:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83AE9651DC;
        Mon,  8 Mar 2021 14:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615214194;
        bh=A0hmv3jMN4wqBTtB8OS7XxKHFgY14vTBrTGYAbFd1AE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QundLkZAHBw7vwUzNjhlWBqcEAAhBwetUmp/vZIOLhOg2eru9Qi/zNP+jbhPJSQw6
         RW7YG63jKYTkr56WUVYevwdCiCQbO3BwdlFapU0gyhbFFwSqX5oy+eJsIMN2SyaGNC
         5EZkNvPKmrKpKAUPsMJIc23ivHw5l9gNyLSslPwc=
Date:   Mon, 8 Mar 2021 15:36:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Catangiu <acatan@amazon.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, graf@amazon.com, rdunlap@infradead.org,
        arnd@arndb.de, ebiederm@xmission.com, rppt@kernel.org,
        0x7f454c46@gmail.com, borntraeger@de.ibm.com, Jason@zx2c4.com,
        jannh@google.com, w@1wt.eu, colmmacc@amazon.com, luto@kernel.org,
        tytso@mit.edu, ebiggers@kernel.org, dwmw@amazon.co.uk,
        bonzini@gnu.org, sblbir@amazon.com, raduweis@amazon.com,
        corbet@lwn.net, mst@redhat.com, mhocko@kernel.org,
        rafael@kernel.org, pavel@ucw.cz, mpe@ellerman.id.au,
        areber@redhat.com, ovzxemul@gmail.com, avagin@gmail.com,
        ptikhomirov@virtuozzo.com, gil@azul.com, asmehra@redhat.com,
        dgunigun@redhat.com, vijaysun@ca.ibm.com, oridgar@gmail.com,
        ghammer@redhat.com
Subject: Re: [PATCH v8] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <YEY2b1QU5RxozL0r@kroah.com>
References: <1615213083-29869-1-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615213083-29869-1-git-send-email-acatan@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 04:18:03PM +0200, Adrian Catangiu wrote:
> +static struct miscdevice sysgenid_misc = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "sysgenid",
> +	.fops = &fops,
> +};

Much cleaner, but:

> +static int __init sysgenid_init(void)
> +{
> +	int ret;
> +
> +	sysgenid_data.map_buf = get_zeroed_page(GFP_KERNEL);
> +	if (!sysgenid_data.map_buf)
> +		return -ENOMEM;
> +
> +	atomic_set(&sysgenid_data.generation_counter, 0);
> +	atomic_set(&sysgenid_data.outdated_watchers, 0);
> +	init_waitqueue_head(&sysgenid_data.read_waitq);
> +	init_waitqueue_head(&sysgenid_data.outdated_waitq);
> +	spin_lock_init(&sysgenid_data.lock);
> +
> +	ret = misc_register(&sysgenid_misc);
> +	if (ret < 0) {
> +		pr_err("misc_register() failed for sysgenid\n");
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	free_pages(sysgenid_data.map_buf, 0);
> +	sysgenid_data.map_buf = 0;
> +
> +	return ret;
> +}
> +
> +static void __exit sysgenid_exit(void)
> +{
> +	misc_deregister(&sysgenid_misc);
> +	free_pages(sysgenid_data.map_buf, 0);
> +	sysgenid_data.map_buf = 0;
> +}
> +
> +module_init(sysgenid_init);
> +module_exit(sysgenid_exit);

So you do this for any bit of hardware that happens to be out there?
Will that really work?  You do not have any hwid to trigger off of to
know that this is a valid device you can handle?

> +
> +MODULE_AUTHOR("Adrian Catangiu");
> +MODULE_DESCRIPTION("System Generation ID");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.1");

MODULE_VERSION() isn't a thing, just drop it please :)

thnaks,

greg k-h
