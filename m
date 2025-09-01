Return-Path: <kvm+bounces-56448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7D7B3E575
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3594918923B4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F1D3376A1;
	Mon,  1 Sep 2025 13:39:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B6F1DFDAB
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733950; cv=none; b=lxtcrNJDMhJdLqwr0ueIoLa590Q9YKwXf9o3KLiXfGtR0p6ZfMqxexkjhSuEjpeqHgV9ja11Y2zCaqBVq4xYjOEE/I237Tg4+DNB7lxbcW3tLPwBHzX8zK0tyfy8VnKoNzXOnuMCpddmEzY7wiT0yz89gF/bGPUC5XhFlRYhLK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733950; c=relaxed/simple;
	bh=g1HIdy4oNHsrrEikUrjR1i8Ev3H2co/eBXYJjS2odJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uu0A22ooN4Eqe6TL9EgZ28i5yo+Rbq6CEojk8i8IRtx/W6wam153sH/Dqny3Jwbdu3lc1IvodtkPmk7OzOVKg1/fjzTvWnG8DoxM7v39259l2HAJZNsZmYRNGdzYFT6SIT/i635s+B2C0DJ9SWOrc576viw+Z3wHIEp/T6IKAKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A62716A3;
	Mon,  1 Sep 2025 06:39:00 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1097F3F694;
	Mon,  1 Sep 2025 06:39:07 -0700 (PDT)
Message-ID: <b227a304-9b2f-4e89-9ca5-41d836ae4bae@arm.com>
Date: Mon, 1 Sep 2025 14:39:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Avoid debugfs warning caused by repeated vm fd
 number
To: Ted Chen <znscnchen@gmail.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>
References: <20250901130336.112842-1-znscnchen@gmail.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20250901130336.112842-1-znscnchen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ted,

On 9/1/25 14:03, Ted Chen wrote:
> Avoid debugfs warning like "KVM: debugfs: duplicate directory 59904-4"
> caused by creating VMs with the same vm fd number in a single process.
> 
> As shown in the below test case, two test() are executed sequentially in a
> single process, each creating a new VM.
> 
> Though the 2nd test() creates a new VM after the 1st test() closes the
> vm_fd, KVM prints warnings like "KVM: debugfs: duplicate directory 59904-4"
> on creating the 2nd VM.
> 
> This is due to the dup() of the vcpu_fd in test(). So, after closing the
> 1st vm_fd, kvm->users_count of the 1st VM is still > 0 when creating the
> 2nd VM. So, KVM has not yet invoked kvm_destroy_vm() and
> kvm_destroy_vm_debugfs() for the 1st VM after closing the 1st vm_fd. The
> 2nd test() thus will be able to create a different VM with the same vm fd
> number as the 1st VM.
> 
> Therefore, besides having "pid" and "fdname" in the dir_name of the
> debugfs, add a random number to differentiate different VMs to avoid
> printing warning, also allowing the 2nd VM to have a functional debugfs.
> 
> Use get_random_u32() to avoid dir_name() taking up too much memory while
> greatly reducing the chance of printing warning.
> 
> void test(void)
> {
>         int kvm_fd, vm_fd, vcpu_fd;
> 
>         kvm_fd = open("/dev/kvm", O_RDWR);
>         if (kvm_fd == -1)
>                 return;
> 
>         vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
>         if (vm_fd == -1)
>                 return;
>         vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
>         if (vcpu_fd == -1)
>                 return;
> 
>         dup(vcpu_fd);
>         close(vcpu_fd);
>         close(vm_fd);
>         close(kvm_fd);
> }
> 
> int main()
> {
>         test();
>         test();
> 
>         return 0;
> }
> 
> Signed-off-by: Ted Chen <znscnchen@gmail.com>
> ---
>  virt/kvm/kvm_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6c07dd423458..f92a60ed5de8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>  {
>  	static DEFINE_MUTEX(kvm_debugfs_lock);
>  	struct dentry *dent;
> -	char dir_name[ITOA_MAX_LEN * 2];
> +	char dir_name[ITOA_MAX_LEN * 3];
>  	struct kvm_stat_data *stat_data;
>  	const struct _kvm_stats_desc *pdesc;
>  	int i, ret = -ENOMEM;
> @@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>  	if (!debugfs_initialized())
>  		return 0;
>  
> -	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
> +	snprintf(dir_name, sizeof(dir_name), "%d-%s-%u", task_pid_nr(current),
> +		 fdname, get_random_u32());

This does make the directory names (very likely) to be unique but it's
not helpful in distinguishing which directory maps to which vm. I wonder
if there is some better id we could use here.

Should the vm stats_id also be updated to be unique and use the same scheme?

>  	mutex_lock(&kvm_debugfs_lock);
>  	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
>  	if (dent) {

Thanks,

Ben


