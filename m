Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24B61DE096
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEVHHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgEVHHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:07:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8999B2072C;
        Fri, 22 May 2020 07:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590131230;
        bh=O9DOOGqFE1YQFnwHy1+lkeoiAxM8nHIHQf7VGjF/aeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CuD8fEk1eMSpgE7BPDkS1LfhFXSTLnCj5KtDYlnFeBdwmnQEvAJLOlfm5gbavlGnH
         galIxzoZFsKbBW97AF9nwc6zQgwFD9l8wtV8RreR1DOB1zufPfZZ+koUff7pcltz8I
         /FEqR3E8sgrNngl3q20wD18vtZjUdo9n/E9ny0s0=
Date:   Fri, 22 May 2020 09:07:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v2 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
Message-ID: <20200522070708.GC771317@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-8-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522062946.28973-8-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 09:29:35AM +0300, Andra Paraschiv wrote:
> +static char *ne_cpus;
> +module_param(ne_cpus, charp, 0644);
> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");

This is not the 1990's, don't use module parameters if you can help it.
Why is this needed, and where is it documented?

> +/* CPU pool used for Nitro Enclaves. */
> +struct ne_cpu_pool {
> +	/* Available CPUs in the pool. */
> +	cpumask_var_t avail;
> +	struct mutex mutex;
> +};
> +
> +static struct ne_cpu_pool ne_cpu_pool;
> +
> +static int ne_open(struct inode *node, struct file *file)
> +{
> +	return 0;
> +}

If open does nothing, just don't even provide it.

> +
> +static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}

Same for ioctl.

> +
> +static int ne_release(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}

Same for release.

> +
> +static const struct file_operations ne_fops = {
> +	.owner		= THIS_MODULE,
> +	.llseek		= noop_llseek,
> +	.unlocked_ioctl	= ne_ioctl,
> +	.open		= ne_open,
> +	.release	= ne_release,
> +};
> +
> +struct miscdevice ne_miscdevice = {
> +	.minor	= MISC_DYNAMIC_MINOR,
> +	.name	= NE_DEV_NAME,
> +	.fops	= &ne_fops,
> +	.mode	= 0660,
> +};
> +
> +static int __init ne_init(void)
> +{
> +	unsigned int cpu = 0;
> +	unsigned int cpu_sibling = 0;
> +	int rc = -EINVAL;
> +
> +	memset(&ne_cpu_pool, 0, sizeof(ne_cpu_pool));

Why did you just set a structure to 0 that was already initialized by
the system to 0?  Are you sure about this?

> +
> +	if (!zalloc_cpumask_var(&ne_cpu_pool.avail, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	mutex_init(&ne_cpu_pool.mutex);
> +
> +	rc = cpulist_parse(ne_cpus, ne_cpu_pool.avail);
> +	if (rc < 0) {
> +		pr_err_ratelimited(NE "Error in cpulist parse [rc=%d]\n", rc);

Again, drop all ratelimited stuff please.

thanks,

greg k-h
