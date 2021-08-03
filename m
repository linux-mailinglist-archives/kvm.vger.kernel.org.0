Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85003DEB9A
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 13:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhHCLQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 07:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235329AbhHCLQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 07:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B14A61040;
        Tue,  3 Aug 2021 11:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627989383;
        bh=irsKls81jNM6jGZibRYCKH0dVnnI1L1OshG9DEuboV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PpUOvRNBM7tUwfU7zMqz8mkVQmcP5+8ie0RX2MW/3LqeWRaeSHmQli4vav9yCLrPV
         R2bHrVQXWLXmG8Bak60QArsN42gjH3mX2CzGj6wt8YScfe0baiM7UH75qbXpkbQYx/
         P/CxNxc4YxA1tU0BaDb68GGY0m6GwHjnLxmd4hEU=
Date:   Tue, 3 Aug 2021 13:16:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH kernel] KVM: Stop leaking memory in debugfs
Message-ID: <YQklgq4NkL4UToVY@kroah.com>
References: <20210730043217.953384-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730043217.953384-1-aik@ozlabs.ru>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 02:32:17PM +1000, Alexey Kardashevskiy wrote:
> The debugfs folder name is made of a supposedly unique pair of
> the process pid and a VM fd. However it is possible to get a race here
> which manifests in these messages:
> 
> [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' already present!
> 
> debugfs_create_dir() returns an error which is handled correctly
> everywhere except kvm_create_vm_debugfs() where the code allocates
> stat data structs and overwrites the older values regardless.
> 
> Spotted by syzkaller. This slow memory leak produces way too many
> OOM reports.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> I am pretty sure we better fix the race but I am not quite sure what
> lock is appropriate here, ideas?
> 
> ---
>  virt/kvm/kvm_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 986959833d70..89496fd8127a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -904,6 +904,10 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  
>  	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
>  	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> +	if (IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
> +		pr_err("Failed to create %s\n", dir_name);
> +		return 0;
> +	}

It should not matter if you fail a debugfs call at all.

If there is a larger race at work here, please fix that root cause, do
not paper over it by attempting to have debugfs catch the issue for you.

thanks,

greg k-h
