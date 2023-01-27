Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5D67E50A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjA0MXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjA0MWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:22:30 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FB8D7FA26;
        Fri, 27 Jan 2023 04:19:37 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E0ED2B;
        Fri, 27 Jan 2023 04:20:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D43A3F5A1;
        Fri, 27 Jan 2023 04:19:33 -0800 (PST)
Date:   Fri, 27 Jan 2023 12:19:22 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC kvmtool 04/31] Add --nocompat option to disable compat
 warnings
Message-ID: <Y9PBGK2JblgyNTlc@monolith.localdoman>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
 <20230127113932.166089-5-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127113932.166089-5-suzuki.poulose@arm.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 27, 2023 at 11:39:05AM +0000, Suzuki K Poulose wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Commit e66942073035 ("kvm tools: Guest kernel compatability") added the
> functionality that enables devices to print a warning message if the device
> hasn't been initialized by the time the VM is destroyed. The purpose of
> these messages is to let the user know if the kernel hasn't been built with
> the correct Kconfig options to take advantage of the said devices (all
> using virtio).
> 
> Since then, kvmtool has evolved and now supports loading different payloads
> (like firmware images), and having those warnings even when it is entirely
> intentional for the payload not to touch the devices can be confusing for
> the user and makes the output unnecessarily verbose in those cases.
> 
> Add the --nocompat option to disable the warnings; the warnings are still
> enabled by default.

I had a conversation with Will regarding this some time ago, we settled on
a different approach, by using --loglevel=<level>, similar to what Linux
does.  I'll put that on my TODO list and try to send patches soon-ish.

Thanks,
Alex

> 
> Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  builtin-run.c            | 5 ++++-
>  guest_compat.c           | 1 +
>  include/kvm/kvm-config.h | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index bb7e6e8d..f8edfb3f 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -183,6 +183,8 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  	OPT_BOOLEAN('\0', "nodefaults", &(cfg)->nodefaults, "Disable"   \
>  			" implicit configuration that cannot be"	\
>  			" disabled otherwise"),				\
> +	OPT_BOOLEAN('\0', "nocompat", &(cfg)->nocompat, "Disable"	\
> +			" compat warnings"),				\
>  	OPT_CALLBACK('\0', "9p", NULL, "dir_to_share,tag_name",		\
>  		     "Enable virtio 9p to share files between host and"	\
>  		     " guest", virtio_9p_rootdir_parser, kvm),		\
> @@ -797,7 +799,8 @@ static int kvm_cmd_run_work(struct kvm *kvm)
>  
>  static void kvm_cmd_run_exit(struct kvm *kvm, int guest_ret)
>  {
> -	compat__print_all_messages();
> +	if (!kvm->cfg.nocompat)
> +		compat__print_all_messages();
>  
>  	init_list__exit(kvm);
>  
> diff --git a/guest_compat.c b/guest_compat.c
> index fd4704b2..a413c12c 100644
> --- a/guest_compat.c
> +++ b/guest_compat.c
> @@ -88,6 +88,7 @@ int compat__print_all_messages(void)
>  
>  		printf("\n  # KVM compatibility warning.\n\t%s\n\t%s\n",
>  			msg->title, msg->desc);
> +		printf("\tTo stop seeing this warning, use the --nocompat option.\n");
>  
>  		list_del(&msg->list);
>  		compat__free(msg);
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 368e6c7d..88df7cc2 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -30,6 +30,7 @@ struct kvm_config {
>  	u64 vsock_cid;
>  	bool virtio_rng;
>  	bool nodefaults;
> +	bool nocompat;
>  	int active_console;
>  	int debug_iodelay;
>  	int nrcpus;
> -- 
> 2.34.1
> 
