Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AC323F1BE
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgHGRKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGRKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 13:10:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4DBC061756;
        Fri,  7 Aug 2020 10:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=JN0F4lPHaasWPMVbc2J53m8iIz23bW2FmjeAH/lHUWo=; b=YXrb/4CimFeczmuOHH3wD2csoN
        9pwTh1fmpRlBlElDa93rX8FQlkrPChKXe8me9MuxIDYeulzLYGsMgD49giVgGEZ4yb9p8K5woJflb
        xuIaytqjvNQ1yrxsi4AZPfgT958us2iXwZvKTK5RCkLOhjZ1hFUK6SGtIuYFyb2bi9oPoKx2n3YUs
        2RUPFd6fP+Cv3qGKbZJDrwQ9DRrDawdFGyM9E3V7A+Svh7zrGnuAG0cYRQu+/BqajKc8BvqmGgjz8
        pavIu5h+XxIcWemozeJ64t+TNFgBhqhhvLgnmqql4pFYEnNhfYZV12qlggKCQDhf5JVIi6qt8dfFo
        DnmfaXkw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k45tG-00057J-Eh; Fri, 07 Aug 2020 17:10:46 +0000
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
To:     Jonathan Adams <jwadams@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
References: <20200806001431.2072150-1-jwadams@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5de55a11-c08b-0a55-a678-4bf0d2266a83@infradead.org>
Date:   Fri, 7 Aug 2020 10:10:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806001431.2072150-1-jwadams@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/20 5:14 PM, Jonathan Adams wrote:
> To try to restart the discussion of kernel statistics started by the
> statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
> to share the following set of patches which are Google's 'metricfs'
> implementation and some example uses.  Google has been using metricfs
> internally since 2012 as a way to export various statistics to our
> telemetry systems (similar to OpenTelemetry), and we have over 200
> statistics exported on a typical machine.
> 

Hi,

AFAIK all Linux filesystems (including pseudo/synthetic ones)
live under fs/, not in kernel/.

Therefore I think that this patch series needs more exposure,
i.e., Cc: it to linux-fsdevel@vger.kernel.org and netdev@vger.kernel.org.
oh, and to gregkh.


> Jonathan Adams (5):
>   core/metricfs: add support for percpu metricfs files
>   core/metricfs: metric for kernel warnings
>   core/metricfs: expose softirq information through metricfs
>   core/metricfs: expose scheduler stat information through metricfs
>   core/metricfs: expose x86-specific irq information through metricfs
> 
> Justin TerAvest (1):
>   core/metricfs: Create metricfs, standardized files under debugfs.
> 
> Laurent Chavey (1):
>   net-metricfs: Export /proc/net/dev via metricfs.
> 
>  arch/x86/kernel/irq.c      |  80 ++++
>  fs/proc/stat.c             |  57 +++
>  include/linux/metricfs.h   | 131 +++++++
>  kernel/Makefile            |   2 +
>  kernel/metricfs.c          | 775 +++++++++++++++++++++++++++++++++++++
>  kernel/metricfs_examples.c | 151 ++++++++
>  kernel/panic.c             | 131 +++++++
>  kernel/softirq.c           |  45 +++
>  lib/Kconfig.debug          |  18 +
>  net/core/Makefile          |   1 +
>  net/core/net_metricfs.c    | 194 ++++++++++
>  11 files changed, 1585 insertions(+)
>  create mode 100644 include/linux/metricfs.h
>  create mode 100644 kernel/metricfs.c
>  create mode 100644 kernel/metricfs_examples.c
>  create mode 100644 net/core/net_metricfs.c


thanks.
-- 
~Randy

